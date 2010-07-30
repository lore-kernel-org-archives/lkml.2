Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758441Ab0G3C5k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 22:57:40 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:62505 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755743Ab0G3C5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 22:57:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=vigLZTY5V4SulGg2ihRrQyATM9YmBR0ElAJ7jDitTZPBhXdfnSgQ9ZgjaQ08M/PLrC
         fk/hvzLfPiF4cgRoWEJl6m8AOIxx9ye18AVKmpruwqt3JLtlehY8YGFqJ8qQBeiKAJc0
         AUKbUkq5ICOt6juE5THWAhIbzCnfkCDklslF0=
Subject: [PATCH] backlight: use __devinit/__devexit for the
	platform_driver.probe/remove handler
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Richard Purdie <rpurdie@rpsys.net>,
        Kristoffer Ericson <kristoffer.ericson@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 30 Jul 2010 10:58:27 +0800
Message-Id: <1280458707.7632.0.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/video/backlight/88pm860x_bl.c    |    6 +++---
 drivers/video/backlight/atmel-pwm-bl.c   |    6 +++---
 drivers/video/backlight/cr_bllcd.c       |    6 +++---
 drivers/video/backlight/da903x_bl.c      |    6 +++---
 drivers/video/backlight/ep93xx_bl.c      |    4 ++--
 drivers/video/backlight/generic_bl.c     |    6 +++---
 drivers/video/backlight/hp680_bl.c       |    4 ++--
 drivers/video/backlight/jornada720_bl.c  |    6 +++---
 drivers/video/backlight/jornada720_lcd.c |    6 +++---
 drivers/video/backlight/kb3886_bl.c      |    6 +++---
 drivers/video/backlight/locomolcd.c      |    6 +++---
 drivers/video/backlight/omap1_bl.c       |    6 +++---
 drivers/video/backlight/progear_bl.c     |    6 +++---
 drivers/video/backlight/wm831x_bl.c      |    6 +++---
 14 files changed, 40 insertions(+), 40 deletions(-)

diff --git a/drivers/video/backlight/88pm860x_bl.c b/drivers/video/backlight/88pm860x_bl.c
index 38ffc3f..56e4f43 100644
--- a/drivers/video/backlight/88pm860x_bl.c
+++ b/drivers/video/backlight/88pm860x_bl.c
@@ -180,7 +180,7 @@ static int __check_device(struct pm860x_backlight_pdata *pdata, char *name)
 	return ret;
 }
 
-static int pm860x_backlight_probe(struct platform_device *pdev)
+static int __devinit pm860x_backlight_probe(struct platform_device *pdev)
 {
 	struct pm860x_chip *chip = dev_get_drvdata(pdev->dev.parent);
 	struct pm860x_platform_data *pm860x_pdata;
@@ -272,7 +272,7 @@ out:
 	return ret;
 }
 
-static int pm860x_backlight_remove(struct platform_device *pdev)
+static int __devexit pm860x_backlight_remove(struct platform_device *pdev)
 {
 	struct backlight_device *bl = platform_get_drvdata(pdev);
 	struct pm860x_backlight_data *data = bl_get_data(bl);
@@ -288,7 +288,7 @@ static struct platform_driver pm860x_backlight_driver = {
 		.owner	= THIS_MODULE,
 	},
 	.probe		= pm860x_backlight_probe,
-	.remove		= pm860x_backlight_remove,
+	.remove		= __devexit_p(pm860x_backlight_remove),
 };
 
 static int __init pm860x_backlight_init(void)
diff --git a/drivers/video/backlight/atmel-pwm-bl.c b/drivers/video/backlight/atmel-pwm-bl.c
index e6a66da..aee09f8 100644
--- a/drivers/video/backlight/atmel-pwm-bl.c
+++ b/drivers/video/backlight/atmel-pwm-bl.c
@@ -119,7 +119,7 @@ static const struct backlight_ops atmel_pwm_bl_ops = {
 	.update_status  = atmel_pwm_bl_set_intensity,
 };
 
-static int atmel_pwm_bl_probe(struct platform_device *pdev)
+static int __devinit atmel_pwm_bl_probe(struct platform_device *pdev)
 {
 	struct backlight_properties props;
 	const struct atmel_pwm_bl_platform_data *pdata;
@@ -205,7 +205,7 @@ err_free_mem:
 	return retval;
 }
 
-static int __exit atmel_pwm_bl_remove(struct platform_device *pdev)
+static int __devexit atmel_pwm_bl_remove(struct platform_device *pdev)
 {
 	struct atmel_pwm_bl *pwmbl = platform_get_drvdata(pdev);
 
@@ -227,7 +227,7 @@ static struct platform_driver atmel_pwm_bl_driver = {
 		.name = "atmel-pwm-bl",
 	},
 	/* REVISIT add suspend() and resume() */
-	.remove = __exit_p(atmel_pwm_bl_remove),
+	.remove = __devexit_p(atmel_pwm_bl_remove),
 };
 
 static int __init atmel_pwm_bl_init(void)
diff --git a/drivers/video/backlight/cr_bllcd.c b/drivers/video/backlight/cr_bllcd.c
index a4f4546..2b22f75 100644
--- a/drivers/video/backlight/cr_bllcd.c
+++ b/drivers/video/backlight/cr_bllcd.c
@@ -169,7 +169,7 @@ static struct lcd_ops cr_lcd_ops = {
 	.set_power = cr_lcd_set_power,
 };
 
-static int cr_backlight_probe(struct platform_device *pdev)
+static int __devinit cr_backlight_probe(struct platform_device *pdev)
 {
 	struct backlight_properties props;
 	struct backlight_device *bdp;
@@ -231,7 +231,7 @@ static int cr_backlight_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int cr_backlight_remove(struct platform_device *pdev)
+static int __devexit cr_backlight_remove(struct platform_device *pdev)
 {
 	struct cr_panel *crp = platform_get_drvdata(pdev);
 	crp->cr_backlight_device->props.power = FB_BLANK_POWERDOWN;
@@ -248,7 +248,7 @@ static int cr_backlight_remove(struct platform_device *pdev)
 
 static struct platform_driver cr_backlight_driver = {
 	.probe = cr_backlight_probe,
-	.remove = cr_backlight_remove,
+	.remove = __devexit_p(cr_backlight_remove),
 	.driver = {
 		   .name = "cr_backlight",
 		   },
diff --git a/drivers/video/backlight/da903x_bl.c b/drivers/video/backlight/da903x_bl.c
index 87659ed..ba27b03 100644
--- a/drivers/video/backlight/da903x_bl.c
+++ b/drivers/video/backlight/da903x_bl.c
@@ -101,7 +101,7 @@ static const struct backlight_ops da903x_backlight_ops = {
 	.get_brightness	= da903x_backlight_get_brightness,
 };
 
-static int da903x_backlight_probe(struct platform_device *pdev)
+static int __devinit da903x_backlight_probe(struct platform_device *pdev)
 {
 	struct da9034_backlight_pdata *pdata = pdev->dev.platform_data;
 	struct da903x_backlight_data *data;
@@ -152,7 +152,7 @@ static int da903x_backlight_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int da903x_backlight_remove(struct platform_device *pdev)
+static int __devexit da903x_backlight_remove(struct platform_device *pdev)
 {
 	struct backlight_device *bl = platform_get_drvdata(pdev);
 	struct da903x_backlight_data *data = bl_get_data(bl);
@@ -194,7 +194,7 @@ static struct platform_driver da903x_backlight_driver = {
 #endif
 	},
 	.probe		= da903x_backlight_probe,
-	.remove		= da903x_backlight_remove,
+	.remove		= __devexit_p(da903x_backlight_remove),
 };
 
 static int __init da903x_backlight_init(void)
diff --git a/drivers/video/backlight/ep93xx_bl.c b/drivers/video/backlight/ep93xx_bl.c
index b0cc491..33004be 100644
--- a/drivers/video/backlight/ep93xx_bl.c
+++ b/drivers/video/backlight/ep93xx_bl.c
@@ -65,7 +65,7 @@ static const struct backlight_ops ep93xxbl_ops = {
 	.get_brightness	= ep93xxbl_get_brightness,
 };
 
-static int __init ep93xxbl_probe(struct platform_device *dev)
+static int __devinit ep93xxbl_probe(struct platform_device *dev)
 {
 	struct ep93xxbl *ep93xxbl;
 	struct backlight_device *bl;
@@ -102,7 +102,7 @@ static int __init ep93xxbl_probe(struct platform_device *dev)
 	return 0;
 }
 
-static int ep93xxbl_remove(struct platform_device *dev)
+static int __devexit ep93xxbl_remove(struct platform_device *dev)
 {
 	struct backlight_device *bl = platform_get_drvdata(dev);
 
diff --git a/drivers/video/backlight/generic_bl.c b/drivers/video/backlight/generic_bl.c
index 312ca61..b0b950f 100644
--- a/drivers/video/backlight/generic_bl.c
+++ b/drivers/video/backlight/generic_bl.c
@@ -76,7 +76,7 @@ static const struct backlight_ops genericbl_ops = {
 	.update_status  = genericbl_send_intensity,
 };
 
-static int genericbl_probe(struct platform_device *pdev)
+static int __devinit genericbl_probe(struct platform_device *pdev)
 {
 	struct backlight_properties props;
 	struct generic_bl_info *machinfo = pdev->dev.platform_data;
@@ -109,7 +109,7 @@ static int genericbl_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int genericbl_remove(struct platform_device *pdev)
+static int __devexit genericbl_remove(struct platform_device *pdev)
 {
 	struct backlight_device *bd = platform_get_drvdata(pdev);
 
@@ -125,7 +125,7 @@ static int genericbl_remove(struct platform_device *pdev)
 
 static struct platform_driver genericbl_driver = {
 	.probe		= genericbl_probe,
-	.remove		= genericbl_remove,
+	.remove		= __devexit_p(genericbl_remove),
 	.driver		= {
 		.name	= "generic-bl",
 	},
diff --git a/drivers/video/backlight/hp680_bl.c b/drivers/video/backlight/hp680_bl.c
index 267d23f..26bb75f 100644
--- a/drivers/video/backlight/hp680_bl.c
+++ b/drivers/video/backlight/hp680_bl.c
@@ -123,7 +123,7 @@ static int __devinit hp680bl_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int hp680bl_remove(struct platform_device *pdev)
+static int __devexit hp680bl_remove(struct platform_device *pdev)
 {
 	struct backlight_device *bd = platform_get_drvdata(pdev);
 
@@ -138,7 +138,7 @@ static int hp680bl_remove(struct platform_device *pdev)
 
 static struct platform_driver hp680bl_driver = {
 	.probe		= hp680bl_probe,
-	.remove		= hp680bl_remove,
+	.remove		= __devexit_p(hp680bl_remove),
 	.suspend	= hp680bl_suspend,
 	.resume		= hp680bl_resume,
 	.driver		= {
diff --git a/drivers/video/backlight/jornada720_bl.c b/drivers/video/backlight/jornada720_bl.c
index 2f177b3..60e1d28 100644
--- a/drivers/video/backlight/jornada720_bl.c
+++ b/drivers/video/backlight/jornada720_bl.c
@@ -99,7 +99,7 @@ static const struct backlight_ops jornada_bl_ops = {
 	.options = BL_CORE_SUSPENDRESUME,
 };
 
-static int jornada_bl_probe(struct platform_device *pdev)
+static int __devinit jornada_bl_probe(struct platform_device *pdev)
 {
 	struct backlight_properties props;
 	int ret;
@@ -129,7 +129,7 @@ static int jornada_bl_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int jornada_bl_remove(struct platform_device *pdev)
+static int __devexit jornada_bl_remove(struct platform_device *pdev)
 {
 	struct backlight_device *bd = platform_get_drvdata(pdev);
 
@@ -140,7 +140,7 @@ static int jornada_bl_remove(struct platform_device *pdev)
 
 static struct platform_driver jornada_bl_driver = {
 	.probe		= jornada_bl_probe,
-	.remove		= jornada_bl_remove,
+	.remove		= __devexit_p(jornada_bl_remove),
 	.driver	= {
 		.name	= "jornada_bl",
 	},
diff --git a/drivers/video/backlight/jornada720_lcd.c b/drivers/video/backlight/jornada720_lcd.c
index cbbb167..8fe0181 100644
--- a/drivers/video/backlight/jornada720_lcd.c
+++ b/drivers/video/backlight/jornada720_lcd.c
@@ -94,7 +94,7 @@ static struct lcd_ops jornada_lcd_props = {
 	.set_power = jornada_lcd_set_power,
 };
 
-static int jornada_lcd_probe(struct platform_device *pdev)
+static int __devinit jornada_lcd_probe(struct platform_device *pdev)
 {
 	struct lcd_device *lcd_device;
 	int ret;
@@ -118,7 +118,7 @@ static int jornada_lcd_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int jornada_lcd_remove(struct platform_device *pdev)
+static int __devexit jornada_lcd_remove(struct platform_device *pdev)
 {
 	struct lcd_device *lcd_device = platform_get_drvdata(pdev);
 
@@ -129,7 +129,7 @@ static int jornada_lcd_remove(struct platform_device *pdev)
 
 static struct platform_driver jornada_lcd_driver = {
 	.probe	= jornada_lcd_probe,
-	.remove	= jornada_lcd_remove,
+	.remove	= __devexit_p(jornada_lcd_remove),
 	.driver	= {
 		.name	= "jornada_lcd",
 	},
diff --git a/drivers/video/backlight/kb3886_bl.c b/drivers/video/backlight/kb3886_bl.c
index f439a86..5cf1023 100644
--- a/drivers/video/backlight/kb3886_bl.c
+++ b/drivers/video/backlight/kb3886_bl.c
@@ -139,7 +139,7 @@ static const struct backlight_ops kb3886bl_ops = {
 	.update_status  = kb3886bl_send_intensity,
 };
 
-static int kb3886bl_probe(struct platform_device *pdev)
+static int __devinit kb3886bl_probe(struct platform_device *pdev)
 {
 	struct backlight_properties props;
 	struct kb3886bl_machinfo *machinfo = pdev->dev.platform_data;
@@ -166,7 +166,7 @@ static int kb3886bl_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int kb3886bl_remove(struct platform_device *pdev)
+static int __devexit kb3886bl_remove(struct platform_device *pdev)
 {
 	struct backlight_device *bd = platform_get_drvdata(pdev);
 
@@ -177,7 +177,7 @@ static int kb3886bl_remove(struct platform_device *pdev)
 
 static struct platform_driver kb3886bl_driver = {
 	.probe		= kb3886bl_probe,
-	.remove		= kb3886bl_remove,
+	.remove		= __devexit_p(kb3886bl_remove),
 	.suspend	= kb3886bl_suspend,
 	.resume		= kb3886bl_resume,
 	.driver		= {
diff --git a/drivers/video/backlight/locomolcd.c b/drivers/video/backlight/locomolcd.c
index 7571bc2..987bb21 100644
--- a/drivers/video/backlight/locomolcd.c
+++ b/drivers/video/backlight/locomolcd.c
@@ -165,7 +165,7 @@ static int locomolcd_resume(struct locomo_dev *dev)
 #define locomolcd_resume	NULL
 #endif
 
-static int locomolcd_probe(struct locomo_dev *ldev)
+static int __devinit locomolcd_probe(struct locomo_dev *ldev)
 {
 	struct backlight_properties props;
 	unsigned long flags;
@@ -199,7 +199,7 @@ static int locomolcd_probe(struct locomo_dev *ldev)
 	return 0;
 }
 
-static int locomolcd_remove(struct locomo_dev *dev)
+static int __devexit locomolcd_remove(struct locomo_dev *dev)
 {
 	unsigned long flags;
 
@@ -220,7 +220,7 @@ static struct locomo_driver poodle_lcd_driver = {
 	},
 	.devid	= LOCOMO_DEVID_BACKLIGHT,
 	.probe	= locomolcd_probe,
-	.remove	= locomolcd_remove,
+	.remove	= __devexit_p(locomolcd_remove),
 	.suspend = locomolcd_suspend,
 	.resume = locomolcd_resume,
 };
diff --git a/drivers/video/backlight/omap1_bl.c b/drivers/video/backlight/omap1_bl.c
index d3bc562..5330f73 100644
--- a/drivers/video/backlight/omap1_bl.c
+++ b/drivers/video/backlight/omap1_bl.c
@@ -131,7 +131,7 @@ static const struct backlight_ops omapbl_ops = {
 	.update_status  = omapbl_update_status,
 };
 
-static int omapbl_probe(struct platform_device *pdev)
+static int __devinit omapbl_probe(struct platform_device *pdev)
 {
 	struct backlight_properties props;
 	struct backlight_device *dev;
@@ -173,7 +173,7 @@ static int omapbl_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int omapbl_remove(struct platform_device *pdev)
+static int __devexit omapbl_remove(struct platform_device *pdev)
 {
 	struct backlight_device *dev = platform_get_drvdata(pdev);
 	struct omap_backlight *bl = dev_get_drvdata(&dev->dev);
@@ -186,7 +186,7 @@ static int omapbl_remove(struct platform_device *pdev)
 
 static struct platform_driver omapbl_driver = {
 	.probe		= omapbl_probe,
-	.remove		= omapbl_remove,
+	.remove		= __devexit_p(omapbl_remove),
 	.suspend	= omapbl_suspend,
 	.resume		= omapbl_resume,
 	.driver		= {
diff --git a/drivers/video/backlight/progear_bl.c b/drivers/video/backlight/progear_bl.c
index 809278c..be3ee6b 100644
--- a/drivers/video/backlight/progear_bl.c
+++ b/drivers/video/backlight/progear_bl.c
@@ -59,7 +59,7 @@ static const struct backlight_ops progearbl_ops = {
 	.update_status = progearbl_set_intensity,
 };
 
-static int progearbl_probe(struct platform_device *pdev)
+static int __devinit progearbl_probe(struct platform_device *pdev)
 {
 	struct backlight_properties props;
 	u8 temp;
@@ -108,7 +108,7 @@ put_pmu:
 	return ret;
 }
 
-static int progearbl_remove(struct platform_device *pdev)
+static int __devexit progearbl_remove(struct platform_device *pdev)
 {
 	struct backlight_device *bd = platform_get_drvdata(pdev);
 	backlight_device_unregister(bd);
@@ -118,7 +118,7 @@ static int progearbl_remove(struct platform_device *pdev)
 
 static struct platform_driver progearbl_driver = {
 	.probe = progearbl_probe,
-	.remove = progearbl_remove,
+	.remove = __devexit_p(progearbl_remove),
 	.driver = {
 		   .name = "progear-bl",
 		   },
diff --git a/drivers/video/backlight/wm831x_bl.c b/drivers/video/backlight/wm831x_bl.c
index 08fd87f..e301569 100644
--- a/drivers/video/backlight/wm831x_bl.c
+++ b/drivers/video/backlight/wm831x_bl.c
@@ -119,7 +119,7 @@ static const struct backlight_ops wm831x_backlight_ops = {
 	.get_brightness	= wm831x_backlight_get_brightness,
 };
 
-static int wm831x_backlight_probe(struct platform_device *pdev)
+static int __devinit wm831x_backlight_probe(struct platform_device *pdev)
 {
 	struct wm831x *wm831x = dev_get_drvdata(pdev->dev.parent);
 	struct wm831x_pdata *wm831x_pdata;
@@ -215,7 +215,7 @@ static int wm831x_backlight_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int wm831x_backlight_remove(struct platform_device *pdev)
+static int __devexit wm831x_backlight_remove(struct platform_device *pdev)
 {
 	struct backlight_device *bl = platform_get_drvdata(pdev);
 	struct wm831x_backlight_data *data = bl_get_data(bl);
@@ -231,7 +231,7 @@ static struct platform_driver wm831x_backlight_driver = {
 		.owner	= THIS_MODULE,
 	},
 	.probe		= wm831x_backlight_probe,
-	.remove		= wm831x_backlight_remove,
+	.remove		= __devexit_p(wm831x_backlight_remove),
 };
 
 static int __init wm831x_backlight_init(void)
-- 
1.5.4.3



