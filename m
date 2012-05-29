Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751528Ab2E2AAv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 20:00:51 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:36302 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077Ab2E2AAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 20:00:49 -0400
X-AuditID: cbfee61b-b7faf6d000001f49-aa-4fc411b03305
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Johan Hovold'" <jhovold@gmail.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH v2 3/3][RESEND] backlight: lm3533_bl: use devm_ functions
Date: Tue, 29 May 2012 09:00:48 +0900
Message-id: <001d01cd3d2e$1a70ea50$4f52bef0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac09LhpVM2JQpfYAROO0qYx9mu5fsA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCLMWRmVeSWpSXmKPExsVy+t9jQd0Ngkf8DabvULW4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZZ649ZSpo461YtJG7gfENVxcjJ4eEgInEgmN/2CBsMYkL99YD
	2VwcQgLTGSVenN4I5cxmkjj/8A87SBWbgJrEly+HwWwRgQiJ5hmzmEFsZoEiiXWProLZwgKe
	Eru+7GUEsVkEVCX2tJ5lAbF5BWwlPk7th7IFJX5MvscC0aslsX7ncSYIW15i85q3QHM4gC5S
	l3j0VxdilZ7EvafnWCFKRCT2vXjHOIFRYBaSSbOQTJqFZNIsJC0LGFlWMYqmFiQXFCel5xrp
	FSfmFpfmpesl5+duYgSH5TPpHYyrGiwOMQpwMCrx8HKsOOwvxJpYVlyZe4hRgoNZSYT3fT9Q
	iDclsbIqtSg/vqg0J7X4EKM0B4uSOO+TJTv8hQTSE0tSs1NTC1KLYLJMHJxSDYwrfLL39D2o
	mVx7nutSUs1cnpmKQgkOKg/OdIutrz+z5rb0Wsd6nwjbs0wHJ9RzlN5hZ16Uc0zg+U0no670
	l9+2qbn+i6/PzOyfUSI75ZrF9M3RMz9/eOHFY1UuKrN57olTLI37lJ6o5Eu0eGlWTTw/rZVx
	yrnou3XW+wuK/P9yS0tcjz9R06LEUpyRaKjFXFScCABC6GlURwIAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The devm_ functions allocate memory that is released when a driver
detaches. This patch uses devm_kzalloc of these functions.

Acked-by: Johan Hovold <jhovold@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/lm3533_bl.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/video/backlight/lm3533_bl.c b/drivers/video/backlight/lm3533_bl.c
index 0148227..d916ffe 100644
--- a/drivers/video/backlight/lm3533_bl.c
+++ b/drivers/video/backlight/lm3533_bl.c
@@ -295,7 +295,7 @@ static int __devinit lm3533_bl_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	bl = kzalloc(sizeof(*bl), GFP_KERNEL);
+	bl = devm_kzalloc(&pdev->dev, sizeof(*bl), GFP_KERNEL);
 	if (!bl) {
 		dev_err(&pdev->dev,
 				"failed to allocate memory for backlight\n");
@@ -317,8 +317,7 @@ static int __devinit lm3533_bl_probe(struct platform_device *pdev)
 						&lm3533_bl_ops, &props);
 	if (IS_ERR(bd)) {
 		dev_err(&pdev->dev, "failed to register backlight device\n");
-		ret = PTR_ERR(bd);
-		goto err_free;
+		return PTR_ERR(bd);
 	}
 
 	bl->bd = bd;
@@ -348,8 +347,6 @@ err_sysfs_remove:
 	sysfs_remove_group(&bd->dev.kobj, &lm3533_bl_attribute_group);
 err_unregister:
 	backlight_device_unregister(bd);
-err_free:
-	kfree(bl);
 
 	return ret;
 }
@@ -367,7 +364,6 @@ static int __devexit lm3533_bl_remove(struct platform_device *pdev)
 	lm3533_ctrlbank_disable(&bl->cb);
 	sysfs_remove_group(&bd->dev.kobj, &lm3533_bl_attribute_group);
 	backlight_device_unregister(bd);
-	kfree(bl);
 
 	return 0;
 }
-- 
1.7.1


