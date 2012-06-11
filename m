Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016Ab2FKAKl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 20:10:41 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:47735 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559Ab2FKAKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 20:10:40 -0400
X-AuditID: cbfee61a-b7f9f6d0000016a8-00-4fd5377eba6c
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Hans-Christian Egtvedt'" <egtvedt@samfundet.no>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH v2 1/3][RESEND] backlight: atmel-pwm-bl: use devm_ functions
Date: Mon, 11 Jun 2012 09:10:38 +0900
Message-id: <000b01cd4766$a16d8d00$e448a700$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1HZqEmxJIk5xKVRf2t0nAL86CJig==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCLMWRmVeSWpSXmKPExsVy+t9jAd0686v+Br9Wqlpc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6Mrbf/sxWs5qo4tGMWawPjTY4uRk4OCQETib9L7zBC2GISF+6t
	Z+ti5OIQEljEKHGg8xgThDObSeLlmuNgVWwCahJfvhxmB7FFBCIkmmfMYgYpYhZoZJTYu3MB
	axcjB4ewgI/E148RIDUsAqoS5191M4GEeQVsJT5tSAAJ8woISvyYfI8FxGYW0JJYv/M4E4Qt
	L7F5zVtmkHIJAXWJR391ITbpSWy/+geqRERi34t3jBMYBWYhmTQLyaRZSCbNQtKygJFlFaNo
	akFyQXFSeq6hXnFibnFpXrpecn7uJkZwWD6T2sG4ssHiEKMAB6MSD6/BySv+QqyJZcWVuYcY
	JTiYlUR4tzJd8hfiTUmsrEotyo8vKs1JLT7EKM3BoiTO22R9wV9IID2xJDU7NbUgtQgmy8TB
	KdXAOPvlm6m3c6bvTU5ZeMb+k4bw6RU62xqaHWR+mE35a7e8mE9qzseVe5YbpXB9WNxuxndJ
	eOVTS9ef1SHPRO5Pa+4qWPpXn+/b+0653XzpLl/31iRf7F2l96HUZsoS60193VGShur1thfk
	D3MkmOWuWLwuXn3WBV1OVp6OO/XB047ekgpI+6cdosRSnJFoqMVcVJwIAK7VSlFHAgAA
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The devm_ functions allocate memory that is released when a driver
detaches. This patch uses devm_kzalloc of these functions.

Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/atmel-pwm-bl.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/video/backlight/atmel-pwm-bl.c b/drivers/video/backlight/atmel-pwm-bl.c
index 0443a4f..cd64073 100644
--- a/drivers/video/backlight/atmel-pwm-bl.c
+++ b/drivers/video/backlight/atmel-pwm-bl.c
@@ -127,7 +127,8 @@ static int atmel_pwm_bl_probe(struct platform_device *pdev)
 	struct atmel_pwm_bl *pwmbl;
 	int retval;
 
-	pwmbl = kzalloc(sizeof(struct atmel_pwm_bl), GFP_KERNEL);
+	pwmbl = devm_kzalloc(&pdev->dev, sizeof(struct atmel_pwm_bl),
+				GFP_KERNEL);
 	if (!pwmbl)
 		return -ENOMEM;
 
@@ -202,7 +203,6 @@ err_free_gpio:
 err_free_pwm:
 	pwm_channel_free(&pwmbl->pwmc);
 err_free_mem:
-	kfree(pwmbl);
 	return retval;
 }
 
@@ -218,7 +218,6 @@ static int __exit atmel_pwm_bl_remove(struct platform_device *pdev)
 	pwm_channel_free(&pwmbl->pwmc);
 	backlight_device_unregister(pwmbl->bldev);
 	platform_set_drvdata(pdev, NULL);
-	kfree(pwmbl);
 
 	return 0;
 }
-- 
1.7.1


