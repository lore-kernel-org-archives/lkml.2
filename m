Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757877Ab2EYC2I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 22:28:08 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:26445 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255Ab2EYC2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 22:28:05 -0400
X-AuditID: cbfee61a-b7fe76d0000023f5-4a-4fbeee3474d8
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>, "'Marek Vasut'" <marex@denx.de>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 08/13] backlight: lms283gf05: use devm_ functions
Date: Fri, 25 May 2012 11:28:04 +0900
Message-id: <001301cd3a1e$03431410$09c93c30$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac06HgMhQsWoWkDhR3yoeymNLXqS8w==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKLMWRmVeSWpSXmKPExsVy+t9jAV2Td/v8DX71iFtc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6Mll+72Qum8FT8nH2auYHxHWcXIyeHhICJxOyF15khbDGJC/fW
	s3UxcnEICSxilOh4dZ4JwpnNJHF3wQwmkCo2ATWJL18Os4PYIgIREs0zZoF1MwvkSnQd/wtm
	Cws4Sszo28sGYrMIqEocuDaDBcTmFbCV+Pt+HiOELSjxY/I9FoheLYnN25pYIWx5ic1r3gLN
	4QC6SF3i0V9diFV6Eqe2n4cqEZHY9+Id4wRGgVlIJs1CMmkWkkmzkLQsYGRZxSiaWpBcUJyU
	nmuoV5yYW1yal66XnJ+7iREcmM+kdjCubLA4xCjAwajEwxv4Zp+/EGtiWXFl7iFGCQ5mJRFe
	wUigEG9KYmVValF+fFFpTmrxIUZpDhYlcV67xTv8hQTSE0tSs1NTC1KLYLJMHJxSDYwCGlWi
	CZ7CRz5Mai8R3z67s4Xx0tGjitZrbnBpM9y80X8kpIshrCH64X0thnDVeea8v2vk+LscvG8H
	uB9rvvTdK+BNaTNj5lrf2Ls7D7+b6KcwsUbqzYcHEx89uJw9++QMf4HVAVO+Oj7Ua1uyedbV
	invnNx5rZz6k/ZPzdk969ydNoaUX5acrsRRnJBpqMRcVJwIAmegtkEgCAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The devm_ functions allocate memory that is released when a driver
detaches. This patch uses devm_kzalloc of these functions.

Cc: Marek Vasut <marex@denx.de>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/lms283gf05.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/video/backlight/lms283gf05.c b/drivers/video/backlight/lms283gf05.c
index 4161f9e..a9f2c36 100644
--- a/drivers/video/backlight/lms283gf05.c
+++ b/drivers/video/backlight/lms283gf05.c
@@ -168,7 +168,8 @@ static int __devinit lms283gf05_probe(struct spi_device *spi)
 			goto err;
 	}
 
-	st = kzalloc(sizeof(struct lms283gf05_state), GFP_KERNEL);
+	st = devm_kzalloc(&spi->dev, sizeof(struct lms283gf05_state),
+				GFP_KERNEL);
 	if (st == NULL) {
 		dev_err(&spi->dev, "No memory for device state\n");
 		ret = -ENOMEM;
@@ -178,7 +179,7 @@ static int __devinit lms283gf05_probe(struct spi_device *spi)
 	ld = lcd_device_register("lms283gf05", &spi->dev, st, &lms_ops);
 	if (IS_ERR(ld)) {
 		ret = PTR_ERR(ld);
-		goto err2;
+		goto err;
 	}
 
 	st->spi = spi;
@@ -193,8 +194,6 @@ static int __devinit lms283gf05_probe(struct spi_device *spi)
 
 	return 0;
 
-err2:
-	kfree(st);
 err:
 	if (pdata != NULL)
 		gpio_free(pdata->reset_gpio);
@@ -212,8 +211,6 @@ static int __devexit lms283gf05_remove(struct spi_device *spi)
 	if (pdata != NULL)
 		gpio_free(pdata->reset_gpio);
 
-	kfree(st);
-
 	return 0;
 }
 
-- 
1.7.1


