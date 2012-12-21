Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751251Ab2LUFXx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 00:23:53 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:57552 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033Ab2LUFXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 00:23:48 -0500
X-AuditID: cbfee61b-b7f616d00000319b-80-50d3f262c9c0
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <000501cddf3a$9ba1ecb0$d2e5c610$%han@samsung.com>
In-reply-to: <000501cddf3a$9ba1ecb0$d2e5c610$%han@samsung.com>
Subject: [PATCH 11/11] backlight: lms501kf03: use spi_get_drvdata and
 spi_set_drvdata
Date: Fri, 21 Dec 2012 14:23:45 +0900
Message-id: <000f01cddf3b$595946e0$0c0bd4a0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3fOptdKnZ1gkj6SBm7JPAbRHnX+QAAKxpw
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMIsWRmVeSWpSXmKPExsVy+t8zQ92kT5cDDCYukLC4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZS7ZdYi1YKFDxu728gfE6bxcjB4eEgInEuzk5XYycQKaYxIV7
	69m6GLk4hASWMUp0X2ljh0iYSHz/eAgqMZ1R4tbVm4wQzmwmiUUTPrKCVLEJqEl8+XIYrENE
	IEKiecYsZpANzAI+EptnaYKEhQRsJdq/7mAEsTkF7CSa5zaxgNjCAuES/57eArNZBFQl+r63
	gbXyAtUvmJAPEuYVEJT4MfkeWAmzgJbE+p3HmSBseYnNa94yQ/yiLvHory7EAUYSx2adYoYo
	EZHY9+IdI8R0AYlvkw+xQJTLSmw6wAzyiITAInaJ3l3b2SDelZQ4uOIGywRGiVlINs9CsnkW
	ks2zkKxYwMiyilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyMkpqR3MK5qsDjEKMDBqMTDG2lx
	OUCINbGsuDL3EKMEB7OSCK//B6AQb0piZVVqUX58UWlOavEhRh+gyycyS4km5wPjPa8k3tDY
	2MTMxNTE3NLU3BSHsJI4b7NHSoCQQHpiSWp2ampBahHMOCYOTqkGRt3GRjc97Zdx22ZfDD40
	dfZNu2f8CpYmEzby9kkr1+1eJbf02t+q23fc+987Ox44sla76lDdF5mHykLxBZ6l5evZow+l
	Ft9/PuuSy8OrR7vUvxyosfrwIS2+7uH7Bx84mVp+BN/OebVldYvbQRtup2lVurOvnP/7oDXL
	umNRabXM1KXmBR/0C5RYijMSDbWYi4oTAUm3RYXWAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMIsWRmVeSWpSXmKPExsVy+t9jQd2kT5cDDKYeErG4vGsOmwOjx+dN
	cgGMUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlA
	U5UUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhHWMGUu2XWItWChQ8bu9vIHx
	Om8XIyeHhICJxPePh9ggbDGJC/fWA9lcHEIC0xklbl29yQjhzGaSWDThIytIFZuAmsSXL4fZ
	QWwRgQiJ5hmzmLsYOTiYBXwkNs/SBAkLCdhKtH/dwQhicwrYSTTPbWIBsYUFwiX+Pb0FZrMI
	qEr0fW8Da+UFql8wIR8kzCsgKPFj8j2wEmYBLYn1O48zQdjyEpvXvAUrlxBQl3j0VxfiACOJ
	Y7NOMUOUiEjse/GOcQKj0Cwkk2YhmTQLyaRZSFoWMLKsYhRNLUguKE5KzzXSK07MLS7NS9dL
	zs/dxAiO2WfSOxhXNVgcYhTgYFTi4Y20uBwgxJpYVlyZe4hRgoNZSYTX/wNQiDclsbIqtSg/
	vqg0J7X4EKMP0J8TmaVEk/OB6SSvJN7Q2MTMyNLIzMLIxNwch7CSOG+zR0qAkEB6Yklqdmpq
	QWoRzDgmDk6pBkaHtsWKHs0Ldm16JTq33DTa8KAsS7BSplVb7wKBY+l+07ye8wQru7+UTixn
	KQmNEKq79ftCVt4Cb9kdn+qrbuQ9qZ/oELbJaPosq6+/b39yurY1663hPI97P/52Lfzetv9r
	d2Z6W5MqZ+D7xKNqXqcEA45/X37ni+nD3uj02j8tArM3m60wu6jEUpyRaKjFXFScCAAjXqxQ
	BgMAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the wrapper functions for getting and setting the driver data
using spi_device instead of using dev_{get|set}_drvdata with
&spi->dev, so we can directly pass a struct spi_device.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/lms501kf03.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/video/backlight/lms501kf03.c b/drivers/video/backlight/lms501kf03.c
index f904abc..d00b13b 100644
--- a/drivers/video/backlight/lms501kf03.c
+++ b/drivers/video/backlight/lms501kf03.c
@@ -370,7 +370,7 @@ static int lms501kf03_probe(struct spi_device *spi)
 		lcd->power = FB_BLANK_UNBLANK;
 	}
 
-	dev_set_drvdata(&spi->dev, lcd);
+	spi_set_drvdata(spi, lcd);
 
 	dev_info(&spi->dev, "lms501kf03 panel driver has been probed.\n");
 
@@ -379,7 +379,7 @@ static int lms501kf03_probe(struct spi_device *spi)
 
 static int lms501kf03_remove(struct spi_device *spi)
 {
-	struct lms501kf03 *lcd = dev_get_drvdata(&spi->dev);
+	struct lms501kf03 *lcd = spi_get_drvdata(spi);
 
 	lms501kf03_power(lcd, FB_BLANK_POWERDOWN);
 	lcd_device_unregister(lcd->ld);
@@ -391,7 +391,7 @@ static int lms501kf03_remove(struct spi_device *spi)
 
 static int lms501kf03_suspend(struct spi_device *spi, pm_message_t mesg)
 {
-	struct lms501kf03 *lcd = dev_get_drvdata(&spi->dev);
+	struct lms501kf03 *lcd = spi_get_drvdata(spi);
 
 	dev_dbg(&spi->dev, "lcd->power = %d\n", lcd->power);
 
@@ -404,7 +404,7 @@ static int lms501kf03_suspend(struct spi_device *spi, pm_message_t mesg)
 
 static int lms501kf03_resume(struct spi_device *spi)
 {
-	struct lms501kf03 *lcd = dev_get_drvdata(&spi->dev);
+	struct lms501kf03 *lcd = spi_get_drvdata(spi);
 
 	lcd->power = FB_BLANK_POWERDOWN;
 
@@ -417,7 +417,7 @@ static int lms501kf03_resume(struct spi_device *spi)
 
 void lms501kf03_shutdown(struct spi_device *spi)
 {
-	struct lms501kf03 *lcd = dev_get_drvdata(&spi->dev);
+	struct lms501kf03 *lcd = spi_get_drvdata(spi);
 
 	lms501kf03_power(lcd, FB_BLANK_POWERDOWN);
 }
-- 
1.7.2.5


