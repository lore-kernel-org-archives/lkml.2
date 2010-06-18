Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933520Ab0FROmd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 10:42:33 -0400
Received: from mail-in-17.arcor-online.net ([151.189.21.57]:60463 "EHLO
	mail-in-17.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932449Ab0FROmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 10:42:31 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-08.arcor-online.net 2B0A8205553
Subject: [PATCH] HID: removing obsolete kone_abi_version sysfs attr for
 roccat kone
From: Stefan Achatz <erazor_de@users.sourceforge.net>
Reply-To: erazor_de@users.sourceforge.net
To: Randy Dunlap <rdunlap@xenotime.net>,
       Stefan Achatz <erazor_de@users.sourceforge.net>,
       Jiri Kosina <jkosina@suse.cz>, Stephen Rothwell <sfr@canb.auug.org.au>,
       Tejun Heo <tj@kernel.org>, linux-doc@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Jun 2010 16:42:25 +0200
Message-ID: <1276872145.2358.1.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The newest version of the accompanying userland tools cuts backward
compatibility and uses libudev to find its devices superseding the
quirky kone_abi_version sysfs attribute. Therefore it should be removed.

Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>
---
 .../ABI/testing/sysfs-driver-hid-roccat-kone       |   12 ------------
 drivers/hid/hid-roccat-kone.c                      |   16 ----------------
 drivers/hid/hid-roccat-kone.h                      |    2 --
 3 files changed, 0 insertions(+), 30 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-driver-hid-roccat-kone b/Documentation/ABI/testing/sysfs-driver-hid-roccat-kone
index 36bfa23..063bda7 100644
--- a/Documentation/ABI/testing/sysfs-driver-hid-roccat-kone
+++ b/Documentation/ABI/testing/sysfs-driver-hid-roccat-kone
@@ -33,18 +33,6 @@ Description:	When read, this file returns the raw integer version number of the
 		left. E.g. a returned value of 138 means 1.38
 		This file is readonly.
 
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/kone_abi_version
-Date:		May 2010
-Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
-Description:	When read, this file returns the abi version as an integer value.
-		This attribute is used by the userland tools to find the sysfs-
-		paths of installed kone-mice and determine the capabilites of
-		the driver. Versions of this driver for old kernels replace
-		usbhid instead of generic-usb. The way to scan for this file
-		has been chosen to provide a consistent way for all supported
-		kernel versions.
-		This file is readonly.
-
 What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/profile[1-5]
 Date:		March 2010
 Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
diff --git a/drivers/hid/hid-roccat-kone.c b/drivers/hid/hid-roccat-kone.c
index 0ab1df9..fcc2ccc 100644
--- a/drivers/hid/hid-roccat-kone.c
+++ b/drivers/hid/hid-roccat-kone.c
@@ -618,18 +618,6 @@ static ssize_t kone_sysfs_set_startup_profile(struct device *dev,
 }
 
 /*
- * This file is used by userland software to find devices that are handled by
- * this driver. This provides a consistent way for actual and older kernels
- * where this driver replaced usbhid instead of generic-usb.
- * Driver capabilities are determined by returned number.
- */
-static ssize_t kone_sysfs_show_abi_version(struct device *dev,
-		struct device_attribute *attr, char *buf)
-{
-	return snprintf(buf, PAGE_SIZE, ROCCAT_KONE_ABI_VERSION "\n");
-}
-
-/*
  * Read actual dpi settings.
  * Returns raw value for further processing. Refer to enum kone_polling_rates to
  * get real value.
@@ -666,9 +654,6 @@ static DEVICE_ATTR(startup_profile, 0660,
 		kone_sysfs_show_startup_profile,
 		kone_sysfs_set_startup_profile);
 
-static DEVICE_ATTR(kone_abi_version, 0440,
-		kone_sysfs_show_abi_version, NULL);
-
 static struct attribute *kone_attributes[] = {
 		&dev_attr_actual_dpi.attr,
 		&dev_attr_actual_profile.attr,
@@ -676,7 +661,6 @@ static struct attribute *kone_attributes[] = {
 		&dev_attr_firmware_version.attr,
 		&dev_attr_tcu.attr,
 		&dev_attr_startup_profile.attr,
-		&dev_attr_kone_abi_version.attr,
 		NULL
 };
 
diff --git a/drivers/hid/hid-roccat-kone.h b/drivers/hid/hid-roccat-kone.h
index 71b14fa..130d656 100644
--- a/drivers/hid/hid-roccat-kone.h
+++ b/drivers/hid/hid-roccat-kone.h
@@ -14,8 +14,6 @@
 
 #include <linux/types.h>
 
-#define ROCCAT_KONE_ABI_VERSION "1"
-
 #pragma pack(push)
 #pragma pack(1)
 
-- 
1.6.6.1



