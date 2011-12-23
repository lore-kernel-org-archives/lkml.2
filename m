Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895Ab1LWHxT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 02:53:19 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:37274 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913Ab1LWHxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 02:53:17 -0500
X-AuditID: cbfee61a-b7b89ae000001a15-49-4ef43366b2f2
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH] backlight: use kstrtoul
Date: Fri, 23 Dec 2011 16:53:10 +0900
Message-id: <000201ccc147$ea6750e0$bf35f2a0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Content-language: ko
Thread-index: AczBR+oXPwnGCLhoS6iseIPO38PalQ==
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The usage of simple_strtoul or strict_strtoul is not preferred. Thus,
kstrtoul should be used.

This patch also fixes checkpatch error as follows:
ERROR: space required after that ',' (ctx:VxV)

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/backlight.c |    6 +++---
 drivers/video/backlight/lcd.c       |   26 ++++++++++----------------
 2 files changed, 13 insertions(+), 19 deletions(-)

diff --git a/drivers/video/backlight/backlight.c b/drivers/video/backlight/backlight.c
index 7363c1b..bf5b1ec 100644
--- a/drivers/video/backlight/backlight.c
+++ b/drivers/video/backlight/backlight.c
@@ -102,7 +102,7 @@ static void backlight_generate_event(struct backlight_device *bd,
 }
 
 static ssize_t backlight_show_power(struct device *dev,
-		struct device_attribute *attr,char *buf)
+		struct device_attribute *attr, char *buf)
 {
 	struct backlight_device *bd = to_backlight_device(dev);
 
@@ -116,7 +116,7 @@ static ssize_t backlight_store_power(struct device *dev,
 	struct backlight_device *bd = to_backlight_device(dev);
 	unsigned long power;
 
-	rc = strict_strtoul(buf, 0, &power);
+	rc = kstrtoul(buf, 0, &power);
 	if (rc)
 		return rc;
 
@@ -150,7 +150,7 @@ static ssize_t backlight_store_brightness(struct device *dev,
 	struct backlight_device *bd = to_backlight_device(dev);
 	unsigned long brightness;
 
-	rc = strict_strtoul(buf, 0, &brightness);
+	rc = kstrtoul(buf, 0, &brightness);
 	if (rc)
 		return rc;
 
diff --git a/drivers/video/backlight/lcd.c b/drivers/video/backlight/lcd.c
index 71a11ca..79c1b0d 100644
--- a/drivers/video/backlight/lcd.c
+++ b/drivers/video/backlight/lcd.c
@@ -97,19 +97,16 @@ static ssize_t lcd_store_power(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t count)
 {
 	int rc = -ENXIO;
-	char *endp;
 	struct lcd_device *ld = to_lcd_device(dev);
-	int power = simple_strtoul(buf, &endp, 0);
-	size_t size = endp - buf;
+	unsigned long power;
 
-	if (isspace(*endp))
-		size++;
-	if (size != count)
-		return -EINVAL;
+	rc = kstrtoul(buf, 0, &power);
+	if (rc)
+		return rc;
 
 	mutex_lock(&ld->ops_lock);
 	if (ld->ops && ld->ops->set_power) {
-		pr_debug("lcd: set power to %d\n", power);
+		pr_debug("lcd: set power to %lu\n", power);
 		ld->ops->set_power(ld, power);
 		rc = count;
 	}
@@ -136,19 +133,16 @@ static ssize_t lcd_store_contrast(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t count)
 {
 	int rc = -ENXIO;
-	char *endp;
 	struct lcd_device *ld = to_lcd_device(dev);
-	int contrast = simple_strtoul(buf, &endp, 0);
-	size_t size = endp - buf;
+	unsigned long contrast;
 
-	if (isspace(*endp))
-		size++;
-	if (size != count)
-		return -EINVAL;
+	rc = kstrtoul(buf, 0, &contrast);
+	if (rc)
+		return rc;
 
 	mutex_lock(&ld->ops_lock);
 	if (ld->ops && ld->ops->set_contrast) {
-		pr_debug("lcd: set contrast to %d\n", contrast);
+		pr_debug("lcd: set contrast to %lu\n", contrast);
 		ld->ops->set_contrast(ld, contrast);
 		rc = count;
 	}
-- 
1.7.1


