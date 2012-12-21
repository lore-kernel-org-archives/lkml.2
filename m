Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751161Ab2LUFXE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 00:23:04 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:40787 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710Ab2LUFWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 00:22:55 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-12-50d3f22ddc3c
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <000501cddf3a$9ba1ecb0$d2e5c610$%han@samsung.com>
In-reply-to: <000501cddf3a$9ba1ecb0$d2e5c610$%han@samsung.com>
Subject: [PATCH 09/11] backlight: tosa: use spi_get_drvdata and spi_set_drvdata
Date: Fri, 21 Dec 2012 14:22:53 +0900
Message-id: <000d01cddf3b$39f4a010$addde030$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3fOptdKnZ1gkj6SBm7JPAbRHnX+QAAIjBg
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKIsWRmVeSWpSXmKPExsVy+t8zA13dT5cDDL7uULK4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZ9y6sYC84I1Cx9vUk5gbGj7xdjBwcEgImErcWm3YxcgKZYhIX
	7q1n62Lk4hASWMYo8av1LSNEwkTiZO8+qMR0Ron+pv2MEM5sJol597YygVSxCahJfPlymB3E
	FhGIkGieMYsZZAOzgI/E5lmaIGEhAVuJ9q87wIZyCthJNM9tYgGxhQX8JU43toHFWQRUJfb9
	mQBm8wLVn+7YygJhC0r8mHwPzGYW0JJYv/M4E4QtL7F5zVtmiGfUJR791YW4wEjiwK/7UOUi
	EvtevIMaLyDxbfIhFohyWYlNB5hBPpEQmMcu8eR3DwvEv5ISB1fcYJnAKDELyeZZSDbPQrJ5
	FpIVCxhZVjGKphYkFxQnpeca6hUn5haX5qXrJefnbmKExJXUDsaVDRaHGAU4GJV4eBnNLgcI
	sSaWFVfmHmKU4GBWEuH1/wAU4k1JrKxKLcqPLyrNSS0+xOgDdPlEZinR5HxgzOeVxBsaG5uY
	mZiamFuampviEFYS5232SAkQEkhPLEnNTk0tSC2CGcfEwSnVwFghFerU0ith/OTE6+VtTP6H
	X/PvOBebN3OuTnD2efXOgDZu0QDBtn6PvMObLzEU/tuy++ILY9HtUicOr9Y7dCBafJLivX3P
	DXj1+h7dXcuRy3JqA3OWiknnPFevjVKVxl2nKz3+Xd7IWCUlYdXn8PNJY+XrJw5y/Tn7wsTv
	KhZWSMg4ce5drsRSnJFoqMVcVJwIAGJYLXXYAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKIsWRmVeSWpSXmKPExsVy+t9jQV3dT5cDDN4+k7O4vGsOmwOjx+dN
	cgGMUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlA
	U5UUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhHWMGfcurGAvOCNQsfb1JOYG
	xo+8XYycHBICJhIne/exQdhiEhfurQeyuTiEBKYzSvQ37WeEcGYzScy7t5UJpIpNQE3iy5fD
	7CC2iECERPOMWcxdjBwczAI+EptnaYKEhQRsJdq/7mAEsTkF7CSa5zaxgNjCAv4SpxvbwOIs
	AqoS+/5MALN5gepPd2xlgbAFJX5MvgdmMwtoSazfeZwJwpaX2LzmLdgqCQF1iUd/dSEuMJI4
	8Os+VLmIxL4X7xgnMArNQjJpFpJJs5BMmoWkZQEjyypG0dSC5ILipPRcQ73ixNzi0rx0veT8
	3E2M4Lh9JrWDcWWDxSFGAQ5GJR5eRrPLAUKsiWXFlbmHGCU4mJVEeP0/AIV4UxIrq1KL8uOL
	SnNSiw8x+gA9OpFZSjQ5H5hS8kriDY1NzIwsjcwsjEzMzXEIK4nzNnukBAgJpCeWpGanphak
	FsGMY+LglGpgZDJfOv/3fhHVzd2zTfOdn71p/OV/WbKqvDMwx13zcsw6yYTAt1rbznCcqGtT
	S57ByPJAoZXfX1Rf7Oi8/GIO9mk/1c8utDy1RlZccLGGUOT8Rav2nJWOYny2f9lUAbubd/lK
	w+dumf1IPlz3UWdrl3FZvwHv2wf+8emvDpgW/t3Ke3Xy/YUvlViKMxINtZiLihMB94GNOAgD	AAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the wrapper functions for getting and setting the driver data
using spi_device instead of using dev_{get|set}_drvdata with
&spi->dev, so we can directly pass a struct spi_device.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/tosa_lcd.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/video/backlight/tosa_lcd.c b/drivers/video/backlight/tosa_lcd.c
index 96bae94..666fe25 100644
--- a/drivers/video/backlight/tosa_lcd.c
+++ b/drivers/video/backlight/tosa_lcd.c
@@ -193,7 +193,7 @@ static int tosa_lcd_probe(struct spi_device *spi)
 		return ret;
 
 	data->spi = spi;
-	dev_set_drvdata(&spi->dev, data);
+	spi_set_drvdata(spi, data);
 
 	ret = devm_gpio_request_one(&spi->dev, TOSA_GPIO_TG_ON,
 				GPIOF_OUT_INIT_LOW, "tg #pwr");
@@ -220,13 +220,13 @@ static int tosa_lcd_probe(struct spi_device *spi)
 err_register:
 	tosa_lcd_tg_off(data);
 err_gpio_tg:
-	dev_set_drvdata(&spi->dev, NULL);
+	spi_set_drvdata(spi, NULL);
 	return ret;
 }
 
 static int tosa_lcd_remove(struct spi_device *spi)
 {
-	struct tosa_lcd_data *data = dev_get_drvdata(&spi->dev);
+	struct tosa_lcd_data *data = spi_get_drvdata(spi);
 
 	lcd_device_unregister(data->lcd);
 
@@ -235,7 +235,7 @@ static int tosa_lcd_remove(struct spi_device *spi)
 
 	tosa_lcd_tg_off(data);
 
-	dev_set_drvdata(&spi->dev, NULL);
+	spi_set_drvdata(spi, NULL);
 
 	return 0;
 }
@@ -243,7 +243,7 @@ static int tosa_lcd_remove(struct spi_device *spi)
 #ifdef CONFIG_PM
 static int tosa_lcd_suspend(struct spi_device *spi, pm_message_t state)
 {
-	struct tosa_lcd_data *data = dev_get_drvdata(&spi->dev);
+	struct tosa_lcd_data *data = spi_get_drvdata(spi);
 
 	tosa_lcd_tg_off(data);
 
@@ -252,7 +252,7 @@ static int tosa_lcd_suspend(struct spi_device *spi, pm_message_t state)
 
 static int tosa_lcd_resume(struct spi_device *spi)
 {
-	struct tosa_lcd_data *data = dev_get_drvdata(&spi->dev);
+	struct tosa_lcd_data *data = spi_get_drvdata(spi);
 
 	tosa_lcd_tg_init(data);
 	if (POWER_IS_ON(data->lcd_power))
-- 
1.7.2.5


