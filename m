Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751828Ab1HXN2k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 09:28:40 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41295 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076Ab1HXN2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 09:28:39 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Samuel Ortiz <sameo@linux.intel.com>, Richard Purdie <rpurdie@rpsys.net>
Cc: David Jander <david@protonic.nl>, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de
Date: Wed, 24 Aug 2011 15:28:20 +0200
Message-Id: <1314192505-23499-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <20110824132740.GA28197@pengutronix.de>
References: <20110824132740.GA28197@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ukl@pengutronix.de
Subject: [PATCH 1/6] led/mc13783: convert to mc13xxx MFD
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on metis.ext.pengutronix.de)
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
index f369e56..cf71764 100644
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
 		reg |= MC13783_LED_Cx_TRIODE_TC_BIT;
 
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
1.7.5.4

