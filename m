Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069Ab2ASFsS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 00:48:18 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53564 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991Ab2ASFsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 00:48:05 -0500
From: Keng-Yu Lin <kengyu@canonical.com>
To: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: sylee@canonical.com, Keng-Yu Lin <kengyu@canonical.com>
Subject: [PATCH] HID: add extra hotkeys in Asus AIO keyboards
Date: Thu, 19 Jan 2012 13:47:50 +0800
Message-Id: <1326952070-5680-1-git-send-email-kengyu@canonical.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Asus All-In-One PC has a wireless keyboard with wifi toggle,
brightness up, brightness down and display off hotkeys.

This patch adds suppoort for these hotkeys.

Signed-off-by: Keng-Yu Lin <kengyu@canonical.com>
---
 drivers/hid/hid-chicony.c |    5 +++++
 drivers/hid/hid-core.c    |    1 +
 drivers/hid/hid-ids.h     |    1 +
 3 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/hid/hid-chicony.c b/drivers/hid/hid-chicony.c
index 8965ad9..4162505 100644
--- a/drivers/hid/hid-chicony.c
+++ b/drivers/hid/hid-chicony.c
@@ -45,6 +45,10 @@ static int ch_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 	case 0xff09: ch_map_key_clear(BTN_9);	break;
 	case 0xff0a: ch_map_key_clear(BTN_A);	break;
 	case 0xff0b: ch_map_key_clear(BTN_B);	break;
+	case 0x00f1: ch_map_key_clear(KEY_WLAN);	break;
+	case 0x00f2: ch_map_key_clear(KEY_BRIGHTNESSDOWN);	break;
+	case 0x00f3: ch_map_key_clear(KEY_BRIGHTNESSUP);	break;
+	case 0x00f4: ch_map_key_clear(KEY_DISPLAY_OFF);	break;
 	default:
 		return 0;
 	}
@@ -53,6 +57,7 @@ static int ch_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 
 static const struct hid_device_id ch_devices[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CHICONY, USB_DEVICE_ID_CHICONY_TACTICAL_PAD) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_CHICONY, USB_DEVICE_ID_CHICONY_WIRELESS2) },
 	{ }
 };
 MODULE_DEVICE_TABLE(hid, ch_devices);
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index af08ce7..75dbe34 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1396,6 +1396,7 @@ static const struct hid_device_id hid_have_special_driver[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CHERRY, USB_DEVICE_ID_CHERRY_CYMOTION_SOLAR) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CHICONY, USB_DEVICE_ID_CHICONY_TACTICAL_PAD) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CHICONY, USB_DEVICE_ID_CHICONY_WIRELESS) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_CHICONY, USB_DEVICE_ID_CHICONY_WIRELESS2) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CHUNGHWAT, USB_DEVICE_ID_CHUNGHWAT_MULTITOUCH) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CREATIVELABS, USB_DEVICE_ID_PRODIKEYS_PCMIDI) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CVTOUCH, USB_DEVICE_ID_CVTOUCH_SCREEN) },
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index b8574cd..fb9e61f 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -190,6 +190,7 @@
 #define USB_DEVICE_ID_CHICONY_TACTICAL_PAD	0x0418
 #define USB_DEVICE_ID_CHICONY_MULTI_TOUCH	0xb19d
 #define USB_DEVICE_ID_CHICONY_WIRELESS	0x0618
+#define USB_DEVICE_ID_CHICONY_WIRELESS2	0x1123
 
 #define USB_VENDOR_ID_CHUNGHWAT		0x2247
 #define USB_DEVICE_ID_CHUNGHWAT_MULTITOUCH	0x0001
-- 
1.7.5.4

