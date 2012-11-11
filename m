Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131Ab2KKFW3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 00:22:29 -0500
Received: from mout.web.de ([212.227.17.12]:55437 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752779Ab2KKFVN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 00:21:13 -0500
Subject: [PATCH 5/7] HID: roccat: Deprecated some Pyra sysfs attributes
From: Stefan Achatz <stefan_achatz@web.de>
To: Rob Landley <rob@landley.net>, Jiri Kosina <jkosina@suse.cz>,
        Stefan Achatz <erazor_de@users.sourceforge.net>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 11 Nov 2012 06:21:10 +0100
Message-ID: <1352611270.2463.225.camel@neuromancer.tessier-ashpool>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:7kN2W57DIm5HQwhhQWqMwm7eHDzBfI0AwJ7yxnM76MC
 dZlatlndsKnYCdHX+D9TfGxzYmaUbUT9SEyY6PRedmaZh2xStC
 BXoDlQY1ptTwRKC4uoE0BguEZJ9Qrxtw+ipZYBn0XPc/IikPF6
 jEoQNtztlbPi3tbls4nxLvEZ3mE+4aGPTfFyo23bZDb5XlYCG6
 CQju5jZmbxovVGUdOqX2w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduced attribute "control" and made profile_settings and profile_buttons
readable, which makes profile[1-5]_settings and profile[1-5]_buttons obsolete.

Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>
---
 .../ABI/obsolete/sysfs-driver-hid-roccat-pyra      |   27 ++++++++++++++-
 .../ABI/testing/sysfs-driver-hid-roccat-pyra       |   37 ++++++-------------
 drivers/hid/hid-roccat-pyra.c                      |   10 +++--
 drivers/hid/hid-roccat-pyra.h                      |    2 +
 4 files changed, 46 insertions(+), 30 deletions(-)

diff --git a/Documentation/ABI/obsolete/sysfs-driver-hid-roccat-pyra b/Documentation/ABI/obsolete/sysfs-driver-hid-roccat-pyra
index 0a661b3..87ac87e 100644
--- a/Documentation/ABI/obsolete/sysfs-driver-hid-roccat-pyra
+++ b/Documentation/ABI/obsolete/sysfs-driver-hid-roccat-pyra
@@ -37,6 +37,31 @@ Description:	When read, this file returns the raw integer version number of the
 		Please use binary attribute "info" which provides this information.
 Users:		http://roccat.sourceforge.net
 
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/pyra/roccatpyra<minor>/profile[1-5]_buttons
+Date:		August 2010
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	The mouse can store 5 profiles which can be switched by the
+		press of a button. A profile is split in settings and buttons.
+		profile_buttons holds information about button layout.
+		When read, these files return the respective profile buttons.
+		The returned data is 19 bytes in size.
+		This file is readonly.
+		Write control to select profile and read profile_buttons instead.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/pyra/roccatpyra<minor>/profile[1-5]_settings
+Date:		August 2010
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	The mouse can store 5 profiles which can be switched by the
+		press of a button. A profile is split in settings and buttons.
+		profile_settings holds information like resolution, sensitivity
+		and light effects.
+		When read, these files return the respective profile settings.
+		The returned data is 13 bytes in size.
+		This file is readonly.
+		Write control to select profile and read profile_settings instead.
+Users:		http://roccat.sourceforge.net
+
 What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/pyra/roccatpyra<minor>/startup_profile
 Date:		August 2010
 Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
@@ -45,4 +70,4 @@ Description:	The integer value of this attribute ranges from 0-4.
                 that's active when the mouse is powered on.
 		This file is readonly.
 		Please use binary attribute "settings" which provides this information.
-Users:		http://roccat.sourceforge.net
\ No newline at end of file
+Users:		http://roccat.sourceforge.net
diff --git a/Documentation/ABI/testing/sysfs-driver-hid-roccat-pyra b/Documentation/ABI/testing/sysfs-driver-hid-roccat-pyra
index b0fab8b..6571d8e 100644
--- a/Documentation/ABI/testing/sysfs-driver-hid-roccat-pyra
+++ b/Documentation/ABI/testing/sysfs-driver-hid-roccat-pyra
@@ -1,3 +1,11 @@
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/pyra/roccatpyra<minor>/info
+Date:		November 2012
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When read, this file returns general data like firmware version.
+		When written, the device can be reset.
+		The data is 6 bytes long.
+Users:		http://roccat.sourceforge.net
+
 What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/pyra/roccatpyra<minor>/profile_settings
 Date:		August 2010
 Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
@@ -10,19 +18,8 @@ Description:	The mouse can store 5 profiles which can be switched by the
 		The mouse will reject invalid data.
 		Which profile to write is determined by the profile number
 		contained in the data.
-		This file is writeonly.
-Users:		http://roccat.sourceforge.net
-
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/pyra/roccatpyra<minor>/profile[1-5]_settings
-Date:		August 2010
-Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
-Description:	The mouse can store 5 profiles which can be switched by the
-		press of a button. A profile is split in settings and buttons.
-		profile_settings holds information like resolution, sensitivity
-		and light effects.
-		When read, these files return the respective profile settings.
-		The returned data is 13 bytes in size.
-		This file is readonly.
+		Before reading this file, control has to be written to select
+		which profile to read.
 Users:		http://roccat.sourceforge.net
 
 What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/pyra/roccatpyra<minor>/profile_buttons
@@ -36,18 +33,8 @@ Description:	The mouse can store 5 profiles which can be switched by the
 		The mouse will reject invalid data.
 		Which profile to write is determined by the profile number
 		contained in the data.
-		This file is writeonly.
-Users:		http://roccat.sourceforge.net
-
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/pyra/roccatpyra<minor>/profile[1-5]_buttons
-Date:		August 2010
-Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
-Description:	The mouse can store 5 profiles which can be switched by the
-		press of a button. A profile is split in settings and buttons.
-		profile_buttons holds information about button layout.
-		When read, these files return the respective profile buttons.
-		The returned data is 19 bytes in size.
-		This file is readonly.
+		Before reading this file, control has to be written to select
+		which profile to read.
 Users:		http://roccat.sourceforge.net
 
 What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/pyra/roccatpyra<minor>/settings
diff --git a/drivers/hid/hid-roccat-pyra.c b/drivers/hid/hid-roccat-pyra.c
index 76199fa..d4f1e3b 100644
--- a/drivers/hid/hid-roccat-pyra.c
+++ b/drivers/hid/hid-roccat-pyra.c
@@ -177,9 +177,10 @@ PYRA_SYSFS_R(thingy, THINGY)
 	.write = pyra_sysfs_write_ ## thingy \
 }
 
+PYRA_SYSFS_W(control, CONTROL)
 PYRA_SYSFS_RW(info, INFO)
-PYRA_SYSFS_W(profile_settings, PROFILE_SETTINGS)
-PYRA_SYSFS_W(profile_buttons, PROFILE_BUTTONS)
+PYRA_SYSFS_RW(profile_settings, PROFILE_SETTINGS)
+PYRA_SYSFS_RW(profile_buttons, PROFILE_BUTTONS)
 PYRA_SYSFS_R(settings, SETTINGS)
 
 static ssize_t pyra_sysfs_read_profilex_settings(struct file *fp,
@@ -312,9 +313,10 @@ static struct device_attribute pyra_attributes[] = {
 };
 
 static struct bin_attribute pyra_bin_attributes[] = {
+	PYRA_BIN_ATTRIBUTE_W(control, CONTROL),
 	PYRA_BIN_ATTRIBUTE_RW(info, INFO),
-	PYRA_BIN_ATTRIBUTE_W(profile_settings, PROFILE_SETTINGS),
-	PYRA_BIN_ATTRIBUTE_W(profile_buttons, PROFILE_BUTTONS),
+	PYRA_BIN_ATTRIBUTE_RW(profile_settings, PROFILE_SETTINGS),
+	PYRA_BIN_ATTRIBUTE_RW(profile_buttons, PROFILE_BUTTONS),
 	PYRA_BIN_ATTRIBUTE_RW(settings, SETTINGS),
 	{
 		.attr = { .name = "profile1_settings", .mode = 0440 },
diff --git a/drivers/hid/hid-roccat-pyra.h b/drivers/hid/hid-roccat-pyra.h
index 93e4949..beedcf0 100644
--- a/drivers/hid/hid-roccat-pyra.h
+++ b/drivers/hid/hid-roccat-pyra.h
@@ -15,6 +15,7 @@
 #include <linux/types.h>
 
 enum {
+	PYRA_SIZE_CONTROL = 0x03,
 	PYRA_SIZE_INFO = 0x06,
 	PYRA_SIZE_PROFILE_SETTINGS = 0x0d,
 	PYRA_SIZE_PROFILE_BUTTONS = 0x13,
@@ -57,6 +58,7 @@ struct pyra_info {
 } __attribute__ ((__packed__));
 
 enum pyra_commands {
+	PYRA_COMMAND_CONTROL = 0x4,
 	PYRA_COMMAND_SETTINGS = 0x5,
 	PYRA_COMMAND_PROFILE_SETTINGS = 0x6,
 	PYRA_COMMAND_PROFILE_BUTTONS = 0x7,
-- 
1.7.3.4



