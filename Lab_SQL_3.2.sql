-- LAB 3.2
use sakila;

-- 1. How many copies of the film Hunchback Impossible exist in the inventory system?

SELECT f.title as 'Film', COUNT(f.film_id) as 'Inventory Count' 
FROM film f
JOIN inventory USING (film_id)
WHERE title = 'Hunchback Impossible';

-- 2. List all films whose length is longer than the average of all the films.

SELECT title
FROM film
WHERE length > (
  SELECT AVG(length)
  FROM film
);

-- 3. Use subqueries to display all actors who appear in the film Alone Trip.

SELECT CONCAT(first_name,' ',last_name) as 'Alone Trip Cast' 
FROM actor
WHERE actor_id in 
	(SELECT actor_id FROM film_actor 
    WHERE film_id = 
	(SELECT film_id FROM film 
    WHERE title = 'Alone Trip'));

-- 4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.

SELECT f.title as 'Family Films' 
FROM film f
JOIN film_category fc USING(film_id)
JOIN category c USING(category_id)
WHERE c.name = 'Family'; 

-- 5. Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.

SELECT CONCAT(cu.first_name, ' ', cu.last_name) as 'Customer Name', cu.email
FROM customer cu
JOIN address a USING(address_id)
JOIN city ci USING(city_id)
JOIN country co USING(country_id)
WHERE co.country = 'Canada';

-- 6 Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.

-- Step 1:
	SELECT actor_id, COUNT(actor_id) as 'no of films'
	FROM film_actor fa
	GROUP BY actor_id
	ORDER BY count(actor_id) DESC; -- Could not figure out how to join this query with one that would allow us to see the films they have starred in.


-- 7. Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments

-- Step 1: Most profitable customer
SELECT c.customer_id, CONCAT(c.first_name, ' ', c.last_name) as 'customer name', total
FROM customer c
JOIN
    (SELECT customer_id, SUM(amount) AS 'total'
    FROM payment
    GROUP BY customer_id
    ORDER BY total DESC
    LIMIT 5) p USING(customer_id) -- Could not figure out how to subquery here to get the film's rented. 

-- 8. Customers who spent more than the average payments.

SELECT customer_id, sum(amount)/count(customer_id) AS Avg_payment FROM sakila.payment
WHERE customer_id IN (
SELECT customer_id, AVG(amount) as Average
GROUP BY customer_id
HAVING Average > Avg_payment); -- Could not figure this one out.
