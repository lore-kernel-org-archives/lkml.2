Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932143Ab2EPFJB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 01:09:01 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:21311 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932766Ab2EPFI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 01:08:59 -0400
X-AuditID: cbfee61b-b7b94ae000002e44-9c-4fb33669a78e
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH v2 1/7] backlight: use pr_warn instead of printk
Date: Wed, 16 May 2012 14:08:57 +0900
Message-id: <001f01cd3321$ff4260d0$fdc72270$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac0zIf8jRLPl4+0oTiG5qdrIQ/4kpQ==
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch uses pr_warn instead of printk to allow dynamic debugging.
The pr_fmt prefix for pr_ macros is used. It also fixes checkpatch
warnings as below:

WARNING: Prefer pr_warn(... to printk(KERN_WARNING, ...

Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/backlight.c |   11 ++++++-----
 drivers/video/backlight/lcd.c       |   10 ++++++----
 2 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/video/backlight/backlight.c b/drivers/video/backlight/backlight.c
index bf5b1ec..f7ce212 100644
--- a/drivers/video/backlight/backlight.c
+++ b/drivers/video/backlight/backlight.c
@@ -5,6 +5,8 @@
  *
  */
 
+#define pr_fmt(fmt) "backlight: " fmt
+
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/device.h>
@@ -123,7 +125,7 @@ static ssize_t backlight_store_power(struct device *dev,
 	rc = -ENXIO;
 	mutex_lock(&bd->ops_lock);
 	if (bd->ops) {
-		pr_debug("backlight: set power to %lu\n", power);
+		pr_debug("set power to %lu\n", power);
 		if (bd->props.power != power) {
 			bd->props.power = power;
 			backlight_update_status(bd);
@@ -161,8 +163,7 @@ static ssize_t backlight_store_brightness(struct device *dev,
 		if (brightness > bd->props.max_brightness)
 			rc = -EINVAL;
 		else {
-			pr_debug("backlight: set brightness to %lu\n",
-				 brightness);
+			pr_debug("set brightness to %lu\n", brightness);
 			bd->props.brightness = brightness;
 			backlight_update_status(bd);
 			rc = count;
@@ -378,8 +379,8 @@ static int __init backlight_class_init(void)
 {
 	backlight_class = class_create(THIS_MODULE, "backlight");
 	if (IS_ERR(backlight_class)) {
-		printk(KERN_WARNING "Unable to create backlight class; errno = %ld\n",
-				PTR_ERR(backlight_class));
+		pr_warn("Unable to create backlight class; errno = %ld\n",
+			PTR_ERR(backlight_class));
 		return PTR_ERR(backlight_class);
 	}
 
diff --git a/drivers/video/backlight/lcd.c b/drivers/video/backlight/lcd.c
index 1c298d5..e61db49 100644
--- a/drivers/video/backlight/lcd.c
+++ b/drivers/video/backlight/lcd.c
@@ -5,6 +5,8 @@
  *
  */
 
+#define pr_fmt(fmt) "lcd: " fmt
+
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/device.h>
@@ -116,7 +118,7 @@ static ssize_t lcd_store_power(struct device *dev,
 
 	mutex_lock(&ld->ops_lock);
 	if (ld->ops && ld->ops->set_power) {
-		pr_debug("lcd: set power to %lu\n", power);
+		pr_debug("set power to %lu\n", power);
 		ld->ops->set_power(ld, power);
 		rc = count;
 	}
@@ -152,7 +154,7 @@ static ssize_t lcd_store_contrast(struct device *dev,
 
 	mutex_lock(&ld->ops_lock);
 	if (ld->ops && ld->ops->set_contrast) {
-		pr_debug("lcd: set contrast to %lu\n", contrast);
+		pr_debug("set contrast to %lu\n", contrast);
 		ld->ops->set_contrast(ld, contrast);
 		rc = count;
 	}
@@ -263,8 +265,8 @@ static int __init lcd_class_init(void)
 {
 	lcd_class = class_create(THIS_MODULE, "lcd");
 	if (IS_ERR(lcd_class)) {
-		printk(KERN_WARNING "Unable to create backlight class; errno = %ld\n",
-				PTR_ERR(lcd_class));
+		pr_warn("Unable to create backlight class; errno = %ld\n",
+			PTR_ERR(lcd_class));
 		return PTR_ERR(lcd_class);
 	}
 
-- 
1.7.1


