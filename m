Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757718Ab0EZSwt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 14:52:49 -0400
Received: from mail-in-04.arcor-online.net ([151.189.21.44]:59837 "EHLO
	mail-in-04.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756742Ab0EZSwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 14:52:47 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-11.arcor-online.net 5150035A60E
Subject: [PATCH 3/3] HID: Changed kone_driver_version to kone_abi_version
From: Stefan Achatz <erazor_de@users.sourceforge.net>
Reply-To: erazor_de@users.sourceforge.net
To: Randy Dunlap <rdunlap@xenotime.net>,
       Stefan Achatz <erazor_de@users.sourceforge.net>,
       Jiri Kosina <jkosina@suse.cz>, Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-doc@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 26 May 2010 20:52:43 +0200
Message-ID: <1274899963.9492.4.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Renamed the sysfs attribute kone_driver_version to kone_abi_version and
simplified returned data to integer.

Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>
---
 .../ABI/testing/sysfs-driver-hid-roccat-kone       |    7 +++----
 drivers/hid/hid-roccat-kone.c                      |   12 ++++++------
 drivers/hid/hid-roccat-kone.h                      |    2 +-
 3 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-driver-hid-roccat-kone b/Documentation/ABI/testing/sysfs-driver-hid-roccat-kone
index 88340a2..36bfa23 100644
--- a/Documentation/ABI/testing/sysfs-driver-hid-roccat-kone
+++ b/Documentation/ABI/testing/sysfs-driver-hid-roccat-kone
@@ -33,11 +33,10 @@ Description:	When read, this file returns the raw integer version number of the
 		left. E.g. a returned value of 138 means 1.38
 		This file is readonly.
 
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/kone_driver_version
-Date:		March 2010
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/kone_abi_version
+Date:		May 2010
 Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
-Description:	When read, this file returns the driver version.
-		The format of the string is "v<major>.<minor>.<patchlevel>".
+Description:	When read, this file returns the abi version as an integer value.
 		This attribute is used by the userland tools to find the sysfs-
 		paths of installed kone-mice and determine the capabilites of
 		the driver. Versions of this driver for old kernels replace
diff --git a/drivers/hid/hid-roccat-kone.c b/drivers/hid/hid-roccat-kone.c
index 3e5b553..0ab1df9 100644
--- a/drivers/hid/hid-roccat-kone.c
+++ b/drivers/hid/hid-roccat-kone.c
@@ -621,12 +621,12 @@ static ssize_t kone_sysfs_set_startup_profile(struct device *dev,
  * This file is used by userland software to find devices that are handled by
  * this driver. This provides a consistent way for actual and older kernels
  * where this driver replaced usbhid instead of generic-usb.
- * Driver capabilities are determined by version number.
+ * Driver capabilities are determined by returned number.
  */
-static ssize_t kone_sysfs_show_driver_version(struct device *dev,
+static ssize_t kone_sysfs_show_abi_version(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
-	return snprintf(buf, PAGE_SIZE, ROCCAT_KONE_DRIVER_VERSION "\n");
+	return snprintf(buf, PAGE_SIZE, ROCCAT_KONE_ABI_VERSION "\n");
 }
 
 /*
@@ -666,8 +666,8 @@ static DEVICE_ATTR(startup_profile, 0660,
 		kone_sysfs_show_startup_profile,
 		kone_sysfs_set_startup_profile);
 
-static DEVICE_ATTR(kone_driver_version, 0440,
-		kone_sysfs_show_driver_version, NULL);
+static DEVICE_ATTR(kone_abi_version, 0440,
+		kone_sysfs_show_abi_version, NULL);
 
 static struct attribute *kone_attributes[] = {
 		&dev_attr_actual_dpi.attr,
@@ -676,7 +676,7 @@ static struct attribute *kone_attributes[] = {
 		&dev_attr_firmware_version.attr,
 		&dev_attr_tcu.attr,
 		&dev_attr_startup_profile.attr,
-		&dev_attr_kone_driver_version.attr,
+		&dev_attr_kone_abi_version.attr,
 		NULL
 };
 
diff --git a/drivers/hid/hid-roccat-kone.h b/drivers/hid/hid-roccat-kone.h
index 003e6f8..71b14fa 100644
--- a/drivers/hid/hid-roccat-kone.h
+++ b/drivers/hid/hid-roccat-kone.h
@@ -14,7 +14,7 @@
 
 #include <linux/types.h>
 
-#define ROCCAT_KONE_DRIVER_VERSION "v0.3.1"
+#define ROCCAT_KONE_ABI_VERSION "1"
 
 #pragma pack(push)
 #pragma pack(1)
-- 
1.6.6.1



