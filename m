Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757494Ab2EUJSk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 05:18:40 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:56473 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757169Ab2EUJSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 05:18:38 -0400
X-AuditID: cbfee61a-b7fe76d0000023f5-54-4fba086cf537
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Hans-Christian Egtvedt'" <egtvedt@samfundet.no>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 1/3] backlight: atmel-pwm-bl: use devm_ functions
Date: Mon, 21 May 2012 18:18:36 +0900
Message-id: <002b01cd3732$b3d4c290$1b7e47b0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac03MrM/LZOGZISnRF+oIdaEbEeIsg==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKLMWRmVeSWpSXmKPExsVy+t9jAd1cjl3+BvePslhc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6Mf6e+shUs5apobJ3G2sB4maOLkZNDQsBE4tqRE4wQtpjEhXvr
	2boYuTiEBBYxSnz6vp4VwpnNJHFo2xFWkCo2ATWJL18Os4PYIgIREs0zZjGDFDELNDJK7N25
	AKxIWMBRouVmPxOIzSKgKtG+cSVYA6+ArcTXDVcYIWxBiR+T77GA2MwCWhLrdx5ngrDlJTav
	eQs0lAPoJHWJR391QUwRAT2JNzscISpEJPa9eMc4gVFgFpJBs5AMmoVk0CwkLQsYWVYxiqYW
	JBcUJ6XnGuoVJ+YWl+al6yXn525iBAfmM6kdjCsbLA4xCnAwKvHwzny601+INbGsuDL3EKME
	B7OSCO/dh0Ah3pTEyqrUovz4otKc1OJDjNIcLErivHaLd/gLCaQnlqRmp6YWpBbBZJk4OKUa
	GH0+8+xyEzq27m6Pb7l56Zz7r4q+ONqm9f+M5d73SfHX8WILyWdf/66bW/bJ1vKohsNhPdG/
	7PlmuzwOPet/tNQk7lNl3Im0hUr5B895nnx94tmWkx+Xd74xeb9sVfPPnXeiuVZtqL8s9vXy
	HanG/RXb54nyCXwun/r8hmb51MY9l4ukX2tu2nVDiaU4I9FQi7moOBEAlI+lrkgCAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The devm_ functions allocate memory that is released when a driver
detaches. This patch uses devm_kzalloc of these functions.

Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
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


