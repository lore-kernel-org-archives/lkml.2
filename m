Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091Ab1BJIiU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 03:38:20 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46017 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752341Ab1BJIiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 03:38:19 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: linux-kernel@vger.kernel.org, David Jander <david@protonic.nl>
Subject: [PATCH] led/mc13783: convert to mc13xxx MFD
Date: Thu, 10 Feb 2011 09:38:14 +0100
Message-Id: <1297327094-15212-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.2.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Jander <david@protonic.nl>

mc13xxx is the more general API and most of the mc13783_... functions
are going to die.

Signed-off-by: David Jander <david@protonic.nl>
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/leds/leds-mc13783.c |   52 +++++++++++++++++++++---------------------
 1 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/drivers/leds/leds-mc13783.c b/drivers/leds/leds-mc13783.c
index f05bb08..3ab3247 100644
--- a/drivers/leds/leds-mc13783.c
+++ b/drivers/leds/leds-mc13783.c
@@ -21,13 +21,13 @@
 #include <linux/platform_device.h>
 #include <linux/leds.h>
 #include <linux/workqueue.h>
-#include <linux/mfd/mc13783.h>
+#include <linux/mfd/mc13xxx.h>
 #include <linux/slab.h>
 
 struct mc13783_led {
 	struct led_classdev	cdev;
 	struct work_struct	work;
-	struct mc13783		*master;
+	struct mc13xxx		*master;
 	enum led_brightness	new_brightness;
 	int			id;
 };
@@ -111,11 +111,11 @@ static void mc13783_led_work(struct work_struct *work)
 		break;
 	}
 
-	mc13783_lock(led->master);
+	mc13xxx_lock(led->master);
 
-	mc13783_reg_rmw(led->master, reg, mask, value);
+	mc13xxx_reg_rmw(led->master, reg, mask, value);
 
-	mc13783_unlock(led->master);
+	mc13xxx_unlock(led->master);
 }
 
 static void mc13783_led_set(struct led_classdev *led_cdev,
@@ -172,23 +172,23 @@ static int __devinit mc13783_led_setup(struct mc13783_led *led, int max_current)
 		break;
 	}
 
-	mc13783_lock(led->master);
+	mc13xxx_lock(led->master);
 
-	ret = mc13783_reg_rmw(led->master, reg, mask << shift,
+	ret = mc13xxx_reg_rmw(led->master, reg, mask << shift,
 						value << shift);
 
-	mc13783_unlock(led->master);
+	mc13xxx_unlock(led->master);
 	return ret;
 }
 
 static int __devinit mc13783_leds_prepare(struct platform_device *pdev)
 {
 	struct mc13783_leds_platform_data *pdata = dev_get_platdata(&pdev->dev);
-	struct mc13783 *dev = dev_get_drvdata(pdev->dev.parent);
+	struct mc13xxx *dev = dev_get_drvdata(pdev->dev.parent);
 	int ret = 0;
 	int reg = 0;
 
-	mc13783_lock(dev);
+	mc13xxx_lock(dev);
 
 	if (pdata->flags & MC13783_LED_TC1HALF)
 		reg |= MC13783_LED_C1_TC1HALF_BIT;
@@ -196,7 +196,7 @@ static int __devinit mc13783_leds_prepare(struct platform_device *pdev)
 	if (pdata->flags & MC13783_LED_SLEWLIMTC)
 		reg |= MC13783_LED_Cx_SLEWLIM_BIT;
 
-	ret = mc13783_reg_write(dev, MC13783_REG_LED_CONTROL_1, reg);
+	ret = mc13xxx_reg_write(dev, MC13783_REG_LED_CONTROL_1, reg);
 	if (ret)
 		goto out;
 
@@ -206,7 +206,7 @@ static int __devinit mc13783_leds_prepare(struct platform_device *pdev)
 	if (pdata->flags & MC13783_LED_SLEWLIMBL)
 		reg |= MC13783_LED_Cx_SLEWLIM_BIT;
 
-	ret = mc13783_reg_write(dev, MC13783_REG_LED_CONTROL_2, reg);
+	ret = mc13xxx_reg_write(dev, MC13783_REG_LED_CONTROL_2, reg);
 	if (ret)
 		goto out;
 
@@ -216,7 +216,7 @@ static int __devinit mc13783_leds_prepare(struct platform_device *pdev)
 	if (pdata->flags & MC13783_LED_TRIODE_TC1)
 		reg |= MC13783_LED_Cx_TRIODE_TC_BIT;
 
-	ret = mc13783_reg_write(dev, MC13783_REG_LED_CONTROL_3, reg);
+	ret = mc13xxx_reg_write(dev, MC13783_REG_LED_CONTROL_3, reg);
 	if (ret)
 		goto out;
 
@@ -226,7 +226,7 @@ static int __devinit mc13783_leds_prepare(struct platform_device *pdev)
 	if (pdata->flags & MC13783_LED_TRIODE_TC2)
 		reg |= MC13783_LED_Cx_TRIODE_TC_BIT;
 
-	ret = mc13783_reg_write(dev, MC13783_REG_LED_CONTROL_4, reg);
+	ret = mc13xxx_reg_write(dev, MC13783_REG_LED_CONTROL_4, reg);
 	if (ret)
 		goto out;
 
@@ -236,7 +236,7 @@ static int __devinit mc13783_leds_prepare(struct platform_device *pdev)
 	if (pdata->flags & MC13783_LED_TRIODE_TC3)
 		reg |= MC13783_LED_Cx_TRIODE_TC_BIT;;
 
-	ret = mc13783_reg_write(dev, MC13783_REG_LED_CONTROL_5, reg);
+	ret = mc13xxx_reg_write(dev, MC13783_REG_LED_CONTROL_5, reg);
 	if (ret)
 		goto out;
 
@@ -255,10 +255,10 @@ static int __devinit mc13783_leds_prepare(struct platform_device *pdev)
 	reg |= (pdata->abref & MC13783_LED_C0_ABREF_MASK) <<
 							MC13783_LED_C0_ABREF;
 
-	ret = mc13783_reg_write(dev, MC13783_REG_LED_CONTROL_0, reg);
+	ret = mc13xxx_reg_write(dev, MC13783_REG_LED_CONTROL_0, reg);
 
 out:
-	mc13783_unlock(dev);
+	mc13xxx_unlock(dev);
 	return ret;
 }
 
@@ -353,7 +353,7 @@ static int __devexit mc13783_led_remove(struct platform_device *pdev)
 {
 	struct mc13783_leds_platform_data *pdata = dev_get_platdata(&pdev->dev);
 	struct mc13783_led *led = platform_get_drvdata(pdev);
-	struct mc13783 *dev = dev_get_drvdata(pdev->dev.parent);
+	struct mc13xxx *dev = dev_get_drvdata(pdev->dev.parent);
 	int i;
 
 	for (i = 0; i < pdata->num_leds; i++) {
@@ -361,16 +361,16 @@ static int __devexit mc13783_led_remove(struct platform_device *pdev)
 		cancel_work_sync(&led[i].work);
 	}
 
-	mc13783_lock(dev);
+	mc13xxx_lock(dev);
 
-	mc13783_reg_write(dev, MC13783_REG_LED_CONTROL_0, 0);
-	mc13783_reg_write(dev, MC13783_REG_LED_CONTROL_1, 0);
-	mc13783_reg_write(dev, MC13783_REG_LED_CONTROL_2, 0);
-	mc13783_reg_write(dev, MC13783_REG_LED_CONTROL_3, 0);
-	mc13783_reg_write(dev, MC13783_REG_LED_CONTROL_4, 0);
-	mc13783_reg_write(dev, MC13783_REG_LED_CONTROL_5, 0);
+	mc13xxx_reg_write(dev, MC13783_REG_LED_CONTROL_0, 0);
+	mc13xxx_reg_write(dev, MC13783_REG_LED_CONTROL_1, 0);
+	mc13xxx_reg_write(dev, MC13783_REG_LED_CONTROL_2, 0);
+	mc13xxx_reg_write(dev, MC13783_REG_LED_CONTROL_3, 0);
+	mc13xxx_reg_write(dev, MC13783_REG_LED_CONTROL_4, 0);
+	mc13xxx_reg_write(dev, MC13783_REG_LED_CONTROL_5, 0);
 
-	mc13783_unlock(dev);
+	mc13xxx_unlock(dev);
 
 	kfree(led);
 	return 0;
-- 
1.7.2.3

