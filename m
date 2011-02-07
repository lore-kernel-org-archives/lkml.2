Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754295Ab1BGBo4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 20:44:56 -0500
Received: from home.keithp.com ([63.227.221.253]:58773 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754178Ab1BGBoz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 20:44:55 -0500
From: Keith Packard <keithp@keithp.com>
To: Jiri Kosina <jkosnia@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@kernel.org, Keith Packard <keithp@keithp.com>
Subject: [PATCH] hid: Ortek W/L rdesc has incorrect Logical Maximum for keyboard
Date: Sun,  6 Feb 2011 17:44:23 -0800
Message-Id: <1297043063-22539-1-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Ortek WKB-2000 had the same rdesc bug -- the Logical Maximum value
was reported as '1' instead of the correct value (146), preventing
most of the keyboard keys from working. This patch simply shares
precisely the same quirk code for this other device.

Signed-off-by: Keith Packard <keithp@keithp.com>
---
 drivers/hid/hid-core.c  |    1 +
 drivers/hid/hid-ids.h   |    1 +
 drivers/hid/hid-ortek.c |    3 ++-
 3 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index d678cf3..233bbf2 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1401,6 +1401,7 @@ static const struct hid_device_id hid_have_special_driver[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_NTRIG, USB_DEVICE_ID_NTRIG_TOUCH_SCREEN_17) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_NTRIG, USB_DEVICE_ID_NTRIG_TOUCH_SCREEN_18) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ORTEK, USB_DEVICE_ID_ORTEK_WKB2000) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ORTEK, USB_DEVICE_ID_ORTEK_WL) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_PETALYNX, USB_DEVICE_ID_PETALYNX_MAXTER_REMOTE) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_QUANTA, USB_DEVICE_ID_QUANTA_OPTICAL_TOUCH) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_QUANTA, USB_DEVICE_ID_PIXART_IMAGING_INC_OPTICAL_TOUCH_SCREEN) },
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 92a0d61..b478b25 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -467,6 +467,7 @@
 
 #define USB_VENDOR_ID_ORTEK		0x05a4
 #define USB_DEVICE_ID_ORTEK_WKB2000	0x2000
+#define USB_DEVICE_ID_ORTEK_WL		0x1700
 
 #define USB_VENDOR_ID_PANJIT		0x134c
 
diff --git a/drivers/hid/hid-ortek.c b/drivers/hid/hid-ortek.c
index e90edfc..74011af 100644
--- a/drivers/hid/hid-ortek.c
+++ b/drivers/hid/hid-ortek.c
@@ -23,7 +23,7 @@ static __u8 *ortek_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 		unsigned int *rsize)
 {
 	if (*rsize >= 56 && rdesc[54] == 0x25 && rdesc[55] == 0x01) {
-		hid_info(hdev, "Fixing up Ortek WKB-2000 report descriptor\n");
+		hid_info(hdev, "Fixing up Ortek WKB-2000 or W/L report descriptor\n");
 		rdesc[55] = 0x92;
 	}
 	return rdesc;
@@ -31,6 +31,7 @@ static __u8 *ortek_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 
 static const struct hid_device_id ortek_devices[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ORTEK, USB_DEVICE_ID_ORTEK_WKB2000) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ORTEK, USB_DEVICE_ID_ORTEK_WL) },
 	{ }
 };
 MODULE_DEVICE_TABLE(hid, ortek_devices);
-- 
1.7.2.3

