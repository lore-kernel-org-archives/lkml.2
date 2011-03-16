Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753040Ab1CPROG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 13:14:06 -0400
Received: from adelie.canonical.com ([91.189.90.139]:52975 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131Ab1CPRN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 13:13:57 -0400
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] HID: add support for Ortek PKB-1700
Date: Wed, 16 Mar 2011 14:13:53 -0300
Message-Id: <1300295633-8627-1-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As reported on http://ubuntuforums.org/showthread.php?t=1594007 the
PKB-1700 needs same special handling as WKB-2000. This change is
originally based on patch posted by user asmoore82 on the Ubuntu
forums.

BugLink: http://bugs.launchpad.net/bugs/735640
Cc: stable@kernel.org
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/hid/Kconfig     |    4 ++--
 drivers/hid/hid-core.c  |    1 +
 drivers/hid/hid-ids.h   |    1 +
 drivers/hid/hid-ortek.c |    3 ++-
 4 files changed, 6 insertions(+), 3 deletions(-)

v2: add PKB-1700 to Kconfig descriptions and hid-ortek.c comment 

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index 2560f01..3a07b4d 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -319,10 +319,10 @@ config HID_NTRIG
 	Support for N-Trig touch screen.
 
 config HID_ORTEK
-	tristate "Ortek WKB-2000 wireless keyboard and mouse trackpad"
+	tristate "Ortek PKB-1700/WKB-2000 wireless keyboard and mouse trackpad"
 	depends on USB_HID
 	---help---
-	Support for Ortek WKB-2000 wireless keyboard + mouse trackpad.
+	Support for Ortek PKB-1700/WKB-2000 wireless keyboard + mouse trackpad.
 
 config HID_PANTHERLORD
 	tristate "Pantherlord/GreenAsia game controller"
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index d678cf3..295e248 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1400,6 +1400,7 @@ static const struct hid_device_id hid_have_special_driver[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_NTRIG, USB_DEVICE_ID_NTRIG_TOUCH_SCREEN_16) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_NTRIG, USB_DEVICE_ID_NTRIG_TOUCH_SCREEN_17) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_NTRIG, USB_DEVICE_ID_NTRIG_TOUCH_SCREEN_18) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ORTEK, USB_DEVICE_ID_ORTEK_PKB1700) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ORTEK, USB_DEVICE_ID_ORTEK_WKB2000) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_PETALYNX, USB_DEVICE_ID_PETALYNX_MAXTER_REMOTE) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_QUANTA, USB_DEVICE_ID_QUANTA_OPTICAL_TOUCH) },
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 92a0d61..5f5cc91 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -466,6 +466,7 @@
 #define USB_DEVICE_ID_ONTRAK_ADU100	0x0064
 
 #define USB_VENDOR_ID_ORTEK		0x05a4
+#define USB_DEVICE_ID_ORTEK_PKB1700	0x1700
 #define USB_DEVICE_ID_ORTEK_WKB2000	0x2000
 
 #define USB_VENDOR_ID_PANJIT		0x134c
diff --git a/drivers/hid/hid-ortek.c b/drivers/hid/hid-ortek.c
index e90edfc..ad6faa6 100644
--- a/drivers/hid/hid-ortek.c
+++ b/drivers/hid/hid-ortek.c
@@ -1,5 +1,5 @@
 /*
- *  HID driver for Ortek WKB-2000 (wireless keyboard + mouse trackpad).
+ *  HID driver for Ortek PKB-1700/WKB-2000 (wireless keyboard + mouse trackpad).
  *  Fixes LogicalMaximum error in USB report description, see
  *  http://bugzilla.kernel.org/show_bug.cgi?id=14787
  *
@@ -30,6 +30,7 @@ static __u8 *ortek_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 }
 
 static const struct hid_device_id ortek_devices[] = {
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ORTEK, USB_DEVICE_ID_ORTEK_PKB1700) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ORTEK, USB_DEVICE_ID_ORTEK_WKB2000) },
 	{ }
 };
-- 
1.7.1

