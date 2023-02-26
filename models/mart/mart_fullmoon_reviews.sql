{{ 
    config( 
        materialized = 'table',
        ) 
}}

--We are joining reviews to the full moon dates 
--Hypothesis - Does full moon have a bad effect on reviews? 
--We are looking to see if the previous day is a full moon. 

WITH fct_reviews AS (
 SELECT * FROM {{ ref('src_reviews') }} 
 where review_text is not null
),
full_moon_dates AS (
 SELECT * FROM {{ ref('seed_full_moon_dates') }}
)
SELECT
    r.*,
    CASE
        WHEN fm.full_moon_date IS NULL THEN 'not full moon'
        ELSE 'full moon'
        END AS is_full_moon
FROM fct_reviews r
    LEFT JOIN full_moon_dates fm
        ON (TO_DATE(r.review_date) = DATEADD(DAY, 1, fm.full_moon_date))