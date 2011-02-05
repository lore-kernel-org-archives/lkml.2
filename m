Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753062Ab1BEOVz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 09:21:55 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57576 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752825Ab1BEOVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 09:21:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=gGUuBJ5Qu6nu7WlUrVCBbL2LuLecHKBvVzYunbhjgPSTB+yAz+EPBtwjii3B+SDqIJ
         HntbQ+cBYT+1mTKsa8yk5lni5tiLPO4hmm5AKOVfH5hvFW0w5dG8WrbLu+EPo3ZlaJ/H
         RHUzlt9BLWjyGUlo1IvMDbfFpnN1yq5Egdwtg=
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, adobriyan@gmail.com
Subject: [PATCH 19/52] kstrtox: convert drivers/hid/
Date: Sat,  5 Feb 2011 16:20:22 +0200
Message-Id: <1296915654-7458-19-git-send-email-adobriyan@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1296915654-7458-1-git-send-email-adobriyan@gmail.com>
References: <1296915654-7458-1-git-send-email-adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 drivers/hid/hid-magicmouse.c      |   14 +++++++--
 drivers/hid/hid-ntrig.c           |   54 ++++++++++++++++++++----------------
 drivers/hid/hid-roccat-kone.c     |    8 +++---
 drivers/hid/hid-roccat-koneplus.c |    4 +-
 4 files changed, 47 insertions(+), 33 deletions(-)

diff --git a/drivers/hid/hid-magicmouse.c b/drivers/hid/hid-magicmouse.c
index 698e645..f3ce099 100644
--- a/drivers/hid/hid-magicmouse.c
+++ b/drivers/hid/hid-magicmouse.c
@@ -34,9 +34,17 @@ module_param(emulate_scroll_wheel, bool, 0644);
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
index beb4034..4bbab1a 100644
--- a/drivers/hid/hid-ntrig.c
+++ b/drivers/hid/hid-ntrig.c
@@ -205,11 +205,12 @@ static ssize_t set_min_width(struct device *dev,
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
 
@@ -240,11 +241,12 @@ static ssize_t set_min_height(struct device *dev,
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
 
@@ -274,11 +276,12 @@ static ssize_t set_activate_slack(struct device *dev,
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
 
@@ -309,11 +312,12 @@ static ssize_t set_activation_width(struct device *dev,
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
 
@@ -345,11 +349,12 @@ static ssize_t set_activation_height(struct device *dev,
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
 
@@ -379,11 +384,12 @@ static ssize_t set_deactivate_slack(struct device *dev,
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
index cbd8cc4..f803932 100644
--- a/drivers/hid/hid-roccat-kone.c
+++ b/drivers/hid/hid-roccat-kone.c
@@ -464,13 +464,13 @@ static ssize_t kone_sysfs_set_tcu(struct device *dev,
 	struct kone_device *kone;
 	struct usb_device *usb_dev;
 	int retval;
-	unsigned long state;
+	int state;
 
 	dev = dev->parent->parent;
 	kone = hid_get_drvdata(dev_get_drvdata(dev));
 	usb_dev = interface_to_usbdev(to_usb_interface(dev));
 
-	retval = strict_strtoul(buf, 10, &state);
+	retval = kstrtoint(buf, 10, &state);
 	if (retval)
 		return retval;
 
@@ -551,13 +551,13 @@ static ssize_t kone_sysfs_set_startup_profile(struct device *dev,
 	struct kone_device *kone;
 	struct usb_device *usb_dev;
 	int retval;
-	unsigned long new_startup_profile;
+	int new_startup_profile;
 
 	dev = dev->parent->parent;
 	kone = hid_get_drvdata(dev_get_drvdata(dev));
 	usb_dev = interface_to_usbdev(to_usb_interface(dev));
 
-	retval = strict_strtoul(buf, 10, &new_startup_profile);
+	retval = kstrtoint(buf, 10, &new_startup_profile);
 	if (retval)
 		return retval;
 
diff --git a/drivers/hid/hid-roccat-koneplus.c b/drivers/hid/hid-roccat-koneplus.c
index 1608c8d..6e13756 100644
--- a/drivers/hid/hid-roccat-koneplus.c
+++ b/drivers/hid/hid-roccat-koneplus.c
@@ -463,14 +463,14 @@ static ssize_t koneplus_sysfs_set_startup_profile(struct device *dev,
 {
 	struct koneplus_device *koneplus;
 	struct usb_device *usb_dev;
-	unsigned long profile;
+	u8 profile;
 	int retval;
 
 	dev = dev->parent->parent;
 	koneplus = hid_get_drvdata(dev_get_drvdata(dev));
 	usb_dev = interface_to_usbdev(to_usb_interface(dev));
 
-	retval = strict_strtoul(buf, 10, &profile);
+	retval = kstrtou8(buf, 10, &profile);
 	if (retval)
 		return retval;
 
-- 
1.7.3.4

