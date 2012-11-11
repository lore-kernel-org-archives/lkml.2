Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024Ab2KKFVf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 00:21:35 -0500
Received: from mout.web.de ([212.227.15.3]:49898 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752945Ab2KKFVa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 00:21:30 -0500
Subject: [PATCH 7/7] HID: roccat: Deprecated some Kovaplus sysfs attributes
From: Stefan Achatz <stefan_achatz@web.de>
To: Rob Landley <rob@landley.net>, Jiri Kosina <jkosina@suse.cz>,
        Stefan Achatz <erazor_de@users.sourceforge.net>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 11 Nov 2012 06:21:19 +0100
Message-ID: <1352611279.2463.227.camel@neuromancer.tessier-ashpool>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:4EKCkMLlH5D5I0VFrmhy/uDuQOSM7rZclhaONBMb8it
 /rLwb6eQLkU8MuMWGZPvS23v36Vahpozhyrx2AFsLgo+w1xcEH
 SZBZAaKzwNsP0d/+Of72BqwYGFnNHuScdj3/MxYDRAJBtF2LD0
 ZPs9sfU4kmQJAWN+bC/Yy5X55gellE9ArHgQYFe7lod+9xwQtZ
 7+02KioeBdy6QWbZ1rOaw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduced attribute "control" and made profile_settings and profile_buttons
readable, which makes profile[1-5]_settings and profile[1-5]_buttons obsolete.

Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>
---
 .../ABI/obsolete/sysfs-driver-hid-roccat-kovaplus  |   25 +++++++++++++++++
 .../ABI/testing/sysfs-driver-hid-roccat-kovaplus   |   29 +++-----------------
 drivers/hid/hid-roccat-kovaplus.c                  |   10 ++++---
 drivers/hid/hid-roccat-kovaplus.h                  |    2 +
 4 files changed, 37 insertions(+), 29 deletions(-)

diff --git a/Documentation/ABI/obsolete/sysfs-driver-hid-roccat-kovaplus b/Documentation/ABI/obsolete/sysfs-driver-hid-roccat-kovaplus
index 4d9fb262..4a98e02 100644
--- a/Documentation/ABI/obsolete/sysfs-driver-hid-roccat-kovaplus
+++ b/Documentation/ABI/obsolete/sysfs-driver-hid-roccat-kovaplus
@@ -39,3 +39,28 @@ Description:	When read, this file returns the raw integer version number of the
 		This file is readonly.
 		Obsoleted by binary sysfs attribute "info".
 Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/kovaplus/roccatkovaplus<minor>/profile[1-5]_buttons
+Date:		January 2011
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	The mouse can store 5 profiles which can be switched by the
+		press of a button. A profile is split in settings and buttons.
+		profile_buttons holds information about button layout.
+		When read, these files return the respective profile buttons.
+		The returned data is 23 bytes in size.
+		This file is readonly.
+		Write control to select profile and read profile_buttons instead.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/kovaplus/roccatkovaplus<minor>/profile[1-5]_settings
+Date:		January 2011
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	The mouse can store 5 profiles which can be switched by the
+		press of a button. A profile is split in settings and buttons.
+		profile_settings holds information like resolution, sensitivity
+		and light effects.
+		When read, these files return the respective profile settings.
+		The returned data is 16 bytes in size.
+		This file is readonly.
+		Write control to select profile and read profile_settings instead.
+Users:		http://roccat.sourceforge.net
diff --git a/Documentation/ABI/testing/sysfs-driver-hid-roccat-kovaplus b/Documentation/ABI/testing/sysfs-driver-hid-roccat-kovaplus
index 507f2c7..e8a04f2 100644
--- a/Documentation/ABI/testing/sysfs-driver-hid-roccat-kovaplus
+++ b/Documentation/ABI/testing/sysfs-driver-hid-roccat-kovaplus
@@ -28,18 +28,8 @@ Description:	The mouse can store 5 profiles which can be switched by the
 		The mouse will reject invalid data.
 		Which profile to write is determined by the profile number
 		contained in the data.
-		This file is writeonly.
-Users:		http://roccat.sourceforge.net
-
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/kovaplus/roccatkovaplus<minor>/profile[1-5]_buttons
-Date:		January 2011
-Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
-Description:	The mouse can store 5 profiles which can be switched by the
-		press of a button. A profile is split in settings and buttons.
-		profile_buttons holds information about button layout.
-		When read, these files return the respective profile buttons.
-		The returned data is 23 bytes in size.
-		This file is readonly.
+		Before reading this file, control has to be written to select
+		which profile to read.
 Users:		http://roccat.sourceforge.net
 
 What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/kovaplus/roccatkovaplus<minor>/profile_settings
@@ -54,17 +44,6 @@ Description:	The mouse can store 5 profiles which can be switched by the
 		The mouse will reject invalid data.
 		Which profile to write is determined by the profile number
 		contained in the data.
-		This file is writeonly.
-Users:		http://roccat.sourceforge.net
-
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/kovaplus/roccatkovaplus<minor>/profile[1-5]_settings
-Date:		January 2011
-Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
-Description:	The mouse can store 5 profiles which can be switched by the
-		press of a button. A profile is split in settings and buttons.
-		profile_settings holds information like resolution, sensitivity
-		and light effects.
-		When read, these files return the respective profile settings.
-		The returned data is 16 bytes in size.
-		This file is readonly.
+		Before reading this file, control has to be written to select
+		which profile to read.
 Users:		http://roccat.sourceforge.net
diff --git a/drivers/hid/hid-roccat-kovaplus.c b/drivers/hid/hid-roccat-kovaplus.c
index 1589fd3..b8b3778 100644
--- a/drivers/hid/hid-roccat-kovaplus.c
+++ b/drivers/hid/hid-roccat-kovaplus.c
@@ -218,9 +218,10 @@ KOVAPLUS_SYSFS_R(thingy, THINGY)
 	.write = kovaplus_sysfs_write_ ## thingy \
 }
 
+KOVAPLUS_SYSFS_W(control, CONTROL)
 KOVAPLUS_SYSFS_RW(info, INFO)
-KOVAPLUS_SYSFS_W(profile_settings, PROFILE_SETTINGS)
-KOVAPLUS_SYSFS_W(profile_buttons, PROFILE_BUTTONS)
+KOVAPLUS_SYSFS_RW(profile_settings, PROFILE_SETTINGS)
+KOVAPLUS_SYSFS_RW(profile_buttons, PROFILE_BUTTONS)
 
 static ssize_t kovaplus_sysfs_read_profilex_settings(struct file *fp,
 		struct kobject *kobj, struct bin_attribute *attr, char *buf,
@@ -369,9 +370,10 @@ static struct device_attribute kovaplus_attributes[] = {
 };
 
 static struct bin_attribute kovaplus_bin_attributes[] = {
+	KOVAPLUS_BIN_ATTRIBUTE_W(control, CONTROL),
 	KOVAPLUS_BIN_ATTRIBUTE_RW(info, INFO),
-	KOVAPLUS_BIN_ATTRIBUTE_W(profile_settings, PROFILE_SETTINGS),
-	KOVAPLUS_BIN_ATTRIBUTE_W(profile_buttons, PROFILE_BUTTONS),
+	KOVAPLUS_BIN_ATTRIBUTE_RW(profile_settings, PROFILE_SETTINGS),
+	KOVAPLUS_BIN_ATTRIBUTE_RW(profile_buttons, PROFILE_BUTTONS),
 	{
 		.attr = { .name = "profile1_settings", .mode = 0440 },
 		.size = KOVAPLUS_SIZE_PROFILE_SETTINGS,
diff --git a/drivers/hid/hid-roccat-kovaplus.h b/drivers/hid/hid-roccat-kovaplus.h
index 1189573..fbb7a16 100644
--- a/drivers/hid/hid-roccat-kovaplus.h
+++ b/drivers/hid/hid-roccat-kovaplus.h
@@ -15,6 +15,7 @@
 #include <linux/types.h>
 
 enum {
+	KOVAPLUS_SIZE_CONTROL = 0x03,
 	KOVAPLUS_SIZE_INFO = 0x06,
 	KOVAPLUS_SIZE_PROFILE_SETTINGS = 0x10,
 	KOVAPLUS_SIZE_PROFILE_BUTTONS = 0x17,
@@ -61,6 +62,7 @@ struct kovaplus_info {
 
 enum kovaplus_commands {
 	KOVAPLUS_COMMAND_ACTUAL_PROFILE = 0x5,
+	KOVAPLUS_COMMAND_CONTROL = 0x4,
 	KOVAPLUS_COMMAND_PROFILE_SETTINGS = 0x6,
 	KOVAPLUS_COMMAND_PROFILE_BUTTONS = 0x7,
 	KOVAPLUS_COMMAND_INFO = 0x9,
-- 
1.7.3.4



