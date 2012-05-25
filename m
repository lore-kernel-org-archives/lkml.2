Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758091Ab2EYCbg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 22:31:36 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:10094 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961Ab2EYCbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 22:31:34 -0400
X-AuditID: cbfee61a-b7fe76d0000023f5-bc-4fbeef05acc5
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Dmitry Baryshkov'" <dbaryshkov@gmail.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 13/13] backlight: tosa_lcd: use devm_ functions
Date: Fri, 25 May 2012 11:31:33 +0900
Message-id: <001801cd3a1e$7ff699f0$7fe3cdd0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac06Hn/iuD0EQ3uLSIyl156uSJib7g==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKLMWRmVeSWpSXmKPExsVy+t9jQV3W9/v8DWY8UrG4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZD59fZi04zF2xZ/4R1gbGXZxdjJwcEgImEjtmz2eBsMUkLtxb
	z9bFyMUhJDCdUeLPwllQzmwmiXtNB5lBqtgE1CS+fDnMDmKLCERINM+YBRZnFqiUWLSqGywu
	LGAv8erfErCpLAKqEu+7TrGB2LwCthJnT+9ggrAFJX5MvscC0aslsXlbEyuELS+xec1boJkc
	QBepSzz6qwuxSk/iUO9sqHIRiX0v3jFOYBSYhWTSLCSTZiGZNAtJywJGllWMoqkFyQXFSem5
	hnrFibnFpXnpesn5uZsYwYH5TGoH48oGi0OMAhyMSjy8gW/2+QuxJpYVV+YeYpTgYFYS4RWM
	BArxpiRWVqUW5ccXleakFh9ilOZgURLntVu8w19IID2xJDU7NbUgtQgmy8TBKdXAGLVeSSVK
	c3UiH9ezhUvWP3hcdPhnjJan+5Z7gbfvzY0qOuDuIJ12q2DZm21KWfNWOVtzdUvUdQmcSpdO
	ZDdK55vQwhuwQ+2F5ic++eC0nbtqXJOOZT8M8VFoCS2+881jXqH/rFmfdvR9U3y57M3GW1ty
	+l/VN10XKnrN1C8d5+HfnBDnMd9MiaU4I9FQi7moOBEAoAFLZEgCAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The devm_ functions allocate memory that is released when a driver
detaches. This patch uses devm_kzalloc of these functions.

Cc: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/tosa_lcd.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/video/backlight/tosa_lcd.c b/drivers/video/backlight/tosa_lcd.c
index 2231aec..47823b8 100644
--- a/drivers/video/backlight/tosa_lcd.c
+++ b/drivers/video/backlight/tosa_lcd.c
@@ -174,7 +174,8 @@ static int __devinit tosa_lcd_probe(struct spi_device *spi)
 	int ret;
 	struct tosa_lcd_data *data;
 
-	data = kzalloc(sizeof(struct tosa_lcd_data), GFP_KERNEL);
+	data = devm_kzalloc(&spi->dev, sizeof(struct tosa_lcd_data),
+				GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;
 
@@ -187,7 +188,7 @@ static int __devinit tosa_lcd_probe(struct spi_device *spi)
 
 	ret = spi_setup(spi);
 	if (ret < 0)
-		goto err_spi;
+		return ret;
 
 	data->spi = spi;
 	dev_set_drvdata(&spi->dev, data);
@@ -224,8 +225,6 @@ err_gpio_dir:
 	gpio_free(TOSA_GPIO_TG_ON);
 err_gpio_tg:
 	dev_set_drvdata(&spi->dev, NULL);
-err_spi:
-	kfree(data);
 	return ret;
 }
 
@@ -242,7 +241,6 @@ static int __devexit tosa_lcd_remove(struct spi_device *spi)
 
 	gpio_free(TOSA_GPIO_TG_ON);
 	dev_set_drvdata(&spi->dev, NULL);
-	kfree(data);
 
 	return 0;
 }
-- 
1.7.1


