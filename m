Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757071Ab0LER41 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 12:56:27 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64682 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756845Ab0LERvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 12:51:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=GtH/1EoEktOTmnDvMiiauypbINg1lsNgO67/BCOJYma/hCTlCcDCErupjBGDj+FDJU
         4M/CQYkALDeFFLLEcVhVMndp+l7EfoRdCaGQ+rFpr4v9pR9GCcsrjrgLG6l715D2p00s
         fcCj11ZDP3sXoldgL3w3ZimAexCUoMqUzkb1c=
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 21/45] kstrtox: convert drivers/hid/
Date: Sun,  5 Dec 2010 19:49:18 +0200
Message-Id: <1291571382-2719-21-git-send-email-adobriyan@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1291571382-2719-1-git-send-email-adobriyan@gmail.com>
References: <1291571382-2719-1-git-send-email-adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 drivers/hid/hid-magicmouse.c  |   14 ++++++++--
 drivers/hid/hid-ntrig.c       |   54 ++++++++++++++++++++++------------------
 drivers/hid/hid-roccat-kone.c |    8 +++---
 3 files changed, 45 insertions(+), 31 deletions(-)

diff --git a/drivers/hid/hid-magicmouse.c b/drivers/hid/hid-magicmouse.c
index e6dc151..5107ee5 100644
--- a/drivers/hid/hid-magicmouse.c
+++ b/drivers/hid/hid-magicmouse.c
@@ -32,9 +32,17 @@ module_param(emulate_scroll_wheel, bool, 0644);
 MODULE_PARM_DESC(emulate_scroll_wheel, "Emulate a scroll wheel");
 
 static unsigned int scroll_speed = 32;
-static int param_set_scroll_speed(const char *val, struct kernel_param *kp) {
-	unsigned long speed;
-	if (!val || strict_strtoul(val, 0, &speed) || speed > 63)
+static int param_set_scroll_speed(const char *val, struct kernel_param *kp)
+{
+	unsigned int speed;
+	int rv;
+
+	if (!val)
+		return -EINVAL;
+	rv = kstrtouint(val, 0, &speed);
+	if (rv < 0)
+		return rv;
+	if (speed > 63)
 		return -EINVAL;
 	scroll_speed = speed;
 	return 0;
diff --git a/drivers/hid/hid-ntrig.c b/drivers/hid/hid-ntrig.c
index 69169ef..6128531 100644
--- a/drivers/hid/hid-ntrig.c
+++ b/drivers/hid/hid-ntrig.c
@@ -206,11 +206,12 @@ static ssize_t set_min_width(struct device *dev,
 	struct hid_device *hdev = container_of(dev, struct hid_device, dev);
 	struct ntrig_data *nd = hid_get_drvdata(hdev);
 
-	unsigned long val;
-
-	if (strict_strtoul(buf, 0, &val))
-		return -EINVAL;
+	u16 val;
+	int rv;
 
+	rv = kstrtou16(buf, 0, &val);
+	if (rv < 0)
+		return rv;
 	if (val > nd->sensor_physical_width)
 		return -EINVAL;
 
@@ -241,11 +242,12 @@ static ssize_t set_min_height(struct device *dev,
 	struct hid_device *hdev = container_of(dev, struct hid_device, dev);
 	struct ntrig_data *nd = hid_get_drvdata(hdev);
 
-	unsigned long val;
-
-	if (strict_strtoul(buf, 0, &val))
-		return -EINVAL;
+	u16 val;
+	int rv;
 
+	rv = kstrtou16(buf, 0, &val);
+	if (rv < 0)
+		return rv;
 	if (val > nd->sensor_physical_height)
 		return -EINVAL;
 
@@ -275,11 +277,12 @@ static ssize_t set_activate_slack(struct device *dev,
 	struct hid_device *hdev = container_of(dev, struct hid_device, dev);
 	struct ntrig_data *nd = hid_get_drvdata(hdev);
 
-	unsigned long val;
-
-	if (strict_strtoul(buf, 0, &val))
-		return -EINVAL;
+	u8 val;
+	int rv;
 
+	rv = kstrtou8(buf, 0, &val);
+	if (rv < 0)
+		return rv;
 	if (val > 0x7f)
 		return -EINVAL;
 
@@ -310,11 +313,12 @@ static ssize_t set_activation_width(struct device *dev,
 	struct hid_device *hdev = container_of(dev, struct hid_device, dev);
 	struct ntrig_data *nd = hid_get_drvdata(hdev);
 
-	unsigned long val;
-
-	if (strict_strtoul(buf, 0, &val))
-		return -EINVAL;
+	u16 val;
+	int rv;
 
+	rv = kstrtou16(buf, 0, &val);
+	if (rv < 0)
+		return rv;
 	if (val > nd->sensor_physical_width)
 		return -EINVAL;
 
@@ -346,11 +350,12 @@ static ssize_t set_activation_height(struct device *dev,
 	struct hid_device *hdev = container_of(dev, struct hid_device, dev);
 	struct ntrig_data *nd = hid_get_drvdata(hdev);
 
-	unsigned long val;
-
-	if (strict_strtoul(buf, 0, &val))
-		return -EINVAL;
+	u16 val;
+	int rv;
 
+	rv = kstrtou16(buf, 0, &val);
+	if (rv < 0)
+		return rv;
 	if (val > nd->sensor_physical_height)
 		return -EINVAL;
 
@@ -380,11 +385,12 @@ static ssize_t set_deactivate_slack(struct device *dev,
 	struct hid_device *hdev = container_of(dev, struct hid_device, dev);
 	struct ntrig_data *nd = hid_get_drvdata(hdev);
 
-	unsigned long val;
-
-	if (strict_strtoul(buf, 0, &val))
-		return -EINVAL;
+	u8 val;
+	int rv;
 
+	rv = kstrtou8(buf, 0, &val);
+	if (rv < 0)
+		return rv;
 	/*
 	 * No more than 8 terminal frames have been observed so far
 	 * and higher slack is highly likely to leave the single
diff --git a/drivers/hid/hid-roccat-kone.c b/drivers/hid/hid-roccat-kone.c
index f776957..e0dd8f9 100644
--- a/drivers/hid/hid-roccat-kone.c
+++ b/drivers/hid/hid-roccat-kone.c
@@ -507,9 +507,9 @@ static ssize_t kone_sysfs_set_tcu(struct device *dev,
 	struct kone_device *kone = hid_get_drvdata(dev_get_drvdata(dev));
 	struct usb_device *usb_dev = interface_to_usbdev(to_usb_interface(dev));
 	int retval;
-	unsigned long state;
+	int state;
 
-	retval = strict_strtoul(buf, 10, &state);
+	retval = kstrtoint(buf, 10, &state);
 	if (retval)
 		return retval;
 
@@ -589,9 +589,9 @@ static ssize_t kone_sysfs_set_startup_profile(struct device *dev,
 	struct kone_device *kone = hid_get_drvdata(dev_get_drvdata(dev));
 	struct usb_device *usb_dev = interface_to_usbdev(to_usb_interface(dev));
 	int retval;
-	unsigned long new_startup_profile;
+	int new_startup_profile;
 
-	retval = strict_strtoul(buf, 10, &new_startup_profile);
+	retval = kstrtoint(buf, 10, &new_startup_profile);
 	if (retval)
 		return retval;
 
-- 
1.7.2.2

