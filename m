Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180Ab2HFJcZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 05:32:25 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:17915 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754104Ab2HFJcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 05:32:23 -0400
X-AuditID: cbfee61a-b7f616d000004b7e-ba-501f8f19b128
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Hans-Christian Egtvedt'" <egtvedt@samfundet.no>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 1/3] backlight: atmel-pwm-bl: remove goto err_free_mem
Date: Mon, 06 Aug 2012 18:32:09 +0900
Message-id: <003e01cd73b6$5a2ec8b0$0e8c5a10$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1ztloSCL4BlDh2Tuib+aj6z34mLQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKLMWRmVeSWpSXmKPExsVy+t9jQV2pfvkAg63rGC0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfG8VX/mAuec1dc+rSTuYHxJmcXIyeHhICJxK/3k9khbDGJC/fW
	s3UxcnEICUxnlLjd+RksISQwm0ni7g9XEJtNQE3iy5fDYHERgQiJ5hmzmEEamAUaGSX27lzA
	CpIQFnCTWP7zMDOIzSKgKnFswT2wOK+ArcScp2eYIWxBiR+T77GA2MwCWhKbtzWxQtjyEpvX
	vAWq4QC6SF3i0V9diF16ElcXdDNBlIhI7HvxjnECo8AsJJNmIZk0C8mkWUhaFjCyrGIUTS1I
	LihOSs811CtOzC0uzUvXS87P3cQIDsxnUjsYVzZYHGIU4GBU4uG9aSAfIMSaWFZcmXuIUYKD
	WUmEt7cZKMSbklhZlVqUH19UmpNafIhRmoNFSZzX2Purv5BAemJJanZqakFqEUyWiYNTqoFx
	w+LqFeL7Xs8JkeD27/LIDTD9+Vyq8hObj+iG2k8Jt77X1KrV/5M2e+0d39yt4HjykZRJ2gLD
	DSs+7X4Q/OaoS96N1h+JGf2Fb6YHx60vaXOaEHo8vEEjsyfn2s6rq1uNOryyIxrUWT1End5y
	Gyp4/O19sK34zbeHl3knH1hsfJdpI6/8XW8lluKMREMt5qLiRABSi2HSSAIAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes goto err_free_mem, which makes code a bit smaller.

Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: Richard Purdie <rpurdie@rpsys.net>
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


