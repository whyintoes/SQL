use sakila;
show tables ;
select * from film ;
select * from category ;
select * from payment ;
SELECT * FROM rental ;
SELECT * FROM inventory ;

-- menghitung total revenue dari tiap film (multi table)
WITH film_revenue AS (
    SELECT
        c.name AS category,
        f.title AS film_title,
        SUM(p.amount) AS total_revenue
    FROM payment p
    JOIN rental r ON p.rental_id = r.rental_id
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN film f ON i.film_id = f.film_id
    JOIN film_category fc ON f.film_id = fc.film_id
    JOIN category c ON fc.category_id = c.category_id
    GROUP BY c.name, f.title
),
-- ranking film berdasarkan total revenue
film_ranked AS (
    SELECT
        *,
        RANK() OVER (PARTITION BY category ORDER BY total_revenue DESC) AS `rank`
    FROM film_revenue
)
-- mengambil 3 film teratas berdasarkan category
SELECT 
    category,
    film_title,
    total_revenue,
    `rank`
FROM film_ranked
WHERE `rank` <= 3
ORDER BY category, `rank`;
