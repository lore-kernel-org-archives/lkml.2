Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753643Ab2HGJ13 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 05:27:29 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:60174 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753372Ab2HGJ12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 05:27:28 -0400
X-AuditID: cbfee61a-b7f616d000004b7e-6b-5020dedbf0db
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Hans-Christian Egtvedt'" <egtvedt@samfundet.no>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH v2 1/3] backlight: atmel-pwm-bl: remove goto err_free_mem
Date: Tue, 07 Aug 2012 18:24:43 +0900
Message-id: <000501cd747e$7a8e4d60$6faae820$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac10fnp9kD1OJHUpTbSf4ZuzgsZmhQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGLMWRmVeSWpSXmKPExsVy+t9jAd3b9xQCDNbfUbW4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZ8zb9YCx4y13RvfsQSwPjfc4uRk4OCQETiUULnjBC2GISF+6t
	Z+ti5OIQEljEKLGzcQc7hDObSWLFpodgVWwCahJfvhxmB7FFBCIkmmfMYgYpYhZoZJTYu3MB
	K0hCWMBTYt3p/2BFLAKqEo8mnmQCsXkFbCVOtD5kg7AFJX5MvscCYjMLaEms33mcCcKWl9i8
	5i3QUA6gk9QlHv3VhdilJzGr7QIbRImIxL4X7xgnMArMQjJpFpJJs5BMmoWkZQEjyypG0dSC
	5ILipPRcQ73ixNzi0rx0veT83E2M4NB8JrWDcWWDxSFGAQ5GJR7eCbIKAUKsiWXFlbmHGCU4
	mJVEeA/vBArxpiRWVqUW5ccXleakFh9ilOZgURLnNfb+6i8kkJ5YkpqdmlqQWgSTZeLglGpg
	7Hf6pTvz4MtXhmExn13YK26mfC/ksNJhWHmt2/pQ+bw7H2ZMFj44KW9RlCbnZf3VCv+tTt57
	8/5EQ1J+baDOvLzvdn+E/lRn1rD2Os5+eM9SUIrPonh7zONMzZIbL2Yf2yeSatq67swkL1P/
	S6/myxwtcDMTsVn/OK9nQ8/T8qhDvpJPGJbuVWIpzkg01GIuKk4EANV85yFJAgAA
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes goto err_free_mem, which makes code a bit smaller.

Cc: Richard Purdie <rpurdie@rpsys.net>
Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/atmel-pwm-bl.c |   15 +++++----------
 1 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/video/backlight/atmel-pwm-bl.c b/drivers/video/backlight/atmel-pwm-bl.c
index df1cbb7..832d07d 100644
--- a/drivers/video/backlight/atmel-pwm-bl.c
+++ b/drivers/video/backlight/atmel-pwm-bl.c
@@ -135,24 +135,20 @@ static int atmel_pwm_bl_probe(struct platform_device *pdev)
 	pwmbl->pdev = pdev;
 
 	pdata = pdev->dev.platform_data;
-	if (!pdata) {
-		retval = -ENODEV;
-		goto err_free_mem;
-	}
+	if (!pdata)
+		return -ENODEV;
 
 	if (pdata->pwm_compare_max < pdata->pwm_duty_max ||
 			pdata->pwm_duty_min > pdata->pwm_duty_max ||
-			pdata->pwm_frequency == 0) {
-		retval = -EINVAL;
-		goto err_free_mem;
-	}
+			pdata->pwm_frequency == 0)
+		return -EINVAL;
 
 	pwmbl->pdata = pdata;
 	pwmbl->gpio_on = pdata->gpio_on;
 
 	retval = pwm_channel_alloc(pdata->pwm_channel, &pwmbl->pwmc);
 	if (retval)
-		goto err_free_mem;
+		return retval;
 
 	if (pwmbl->gpio_on != -1) {
 		retval = devm_gpio_request(&pdev->dev, pwmbl->gpio_on,
@@ -200,7 +196,6 @@ err_free_bl_dev:
 	backlight_device_unregister(bldev);
 err_free_pwm:
 	pwm_channel_free(&pwmbl->pwmc);
-err_free_mem:
 	return retval;
 }
 
-- 
1.7.1


