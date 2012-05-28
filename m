Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751401Ab2E1X71 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 19:59:27 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:40934 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082Ab2E1X70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 19:59:26 -0400
X-AuditID: cbfee61a-b7fe76d0000023f5-33-4fc4115c97fa
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Hans-Christian Egtvedt'" <egtvedt@samfundet.no>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH v2 1/3][RESEND] backlight: atmel-pwm-bl: use devm_ functions
Date: Tue, 29 May 2012 08:59:24 +0900
Message-id: <001b01cd3d2d$e84aeee0$b8e0cca0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac09LefqJwF+o3IwSsCV8uzQz9GVRg==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKLMWRmVeSWpSXmKPExsVy+t9jQd0YwSP+BjffyFpc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6Mrbf/sxWs5qo4tGMWawPjTY4uRk4OCQETiZd/lzNB2GISF+6t
	Z+ti5OIQEpjOKDHp21UmCGc2k0T/rgXMIFVsAmoSX74cZgexRQQiJJpnzGIGKWIWaGSU2Ltz
	AWsXIweHsICPxNePESA1LAKqEnvvrQDbwCtgK7Fk7wsoW1Dix+R7LCA2s4CWxPqdx5kgbHmJ
	zWveMoOMkRBQl3j0VxdilZ7E8gOHWSFKRCT2vXjHOIFRYBaSSbOQTJqFZNIsJC0LGFlWMYqm
	FiQXFCel5xrqFSfmFpfmpesl5+duYgQH5jOpHYwrGywOMQpwMCrx8O5Yc9hfiDWxrLgy9xCj
	BAezkgjv+36gEG9KYmVValF+fFFpTmrxIUZpDhYlcV67xTv8hQTSE0tSs1NTC1KLYLJMHJxS
	DYzeS9WWtBSWHAvuv5TC2L4muLHIrT4hIYE7eqF8Rkbeh3vLH836Xj/rVE1O/pRN+ecNC3kz
	EsKT1a/dd8uJKDTzneS/4Mnsd3ZxjpY8Fxtk1vYVveZseqr8qaVh2vJunV9eTX4yW2PmhYvK
	b2Nl6L+oItnLL71y7pfluz8kHPyTXyd+rVg5V4mlOCPRUIu5qDgRAJoA5ABIAgAA
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


