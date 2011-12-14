Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757908Ab1LNSYO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 13:24:14 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54290 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756962Ab1LNSYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 13:24:13 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/2] leds: Convert wm831x status driver to devm_kzalloc()
Date: Thu, 15 Dec 2011 02:24:07 +0800
Message-Id: <1323887048-9437-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Saves a small amount of code and systematically eliminates leaks.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/leds/leds-wm831x-status.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/leds/leds-wm831x-status.c b/drivers/leds/leds-wm831x-status.c
index 444a68d..74a24cf 100644
--- a/drivers/leds/leds-wm831x-status.c
+++ b/drivers/leds/leds-wm831x-status.c
@@ -237,7 +237,8 @@ static int wm831x_status_probe(struct platform_device *pdev)
 		goto err;
 	}
 
-	drvdata = kzalloc(sizeof(struct wm831x_status), GFP_KERNEL);
+	drvdata = devm_kzalloc(&pdev->dev, sizeof(struct wm831x_status),
+			       GFP_KERNEL);
 	if (!drvdata)
 		return -ENOMEM;
 	dev_set_drvdata(&pdev->dev, drvdata);
@@ -300,7 +301,6 @@ static int wm831x_status_probe(struct platform_device *pdev)
 
 err_led:
 	led_classdev_unregister(&drvdata->cdev);
-	kfree(drvdata);
 err:
 	return ret;
 }
@@ -311,7 +311,6 @@ static int wm831x_status_remove(struct platform_device *pdev)
 
 	device_remove_file(drvdata->cdev.dev, &dev_attr_src);
 	led_classdev_unregister(&drvdata->cdev);
-	kfree(drvdata);
 
 	return 0;
 }
-- 
1.7.7.3

