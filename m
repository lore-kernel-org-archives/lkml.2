Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758884Ab2CFJyD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 04:54:03 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63418 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758480Ab2CFJx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 04:53:56 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of benjamin.tissoires@gmail.com designates 10.180.93.4 as permitted sender) smtp.mail=benjamin.tissoires@gmail.com; dkim=pass header.i=benjamin.tissoires@gmail.com
From: "benjamin.tissoires" <benjamin.tissoires@gmail.com>
To: "benjamin.tissoires" <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] HID: multitouch: add more eGalax devices
Date: Tue,  6 Mar 2012 10:53:47 +0100
Message-Id: <1331027628-7946-3-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1331027628-7946-1-git-send-email-benjamin.tissoires@gmail.com>
References: <1331027628-7946-1-git-send-email-benjamin.tissoires@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Tissoires <benjamin.tissoires@enac.fr>

This is a list of devices that should be handled by hid-multitouch.
They all present the HID usage "Contact ID" and won't be handled by
hid-input.
Some of them have _not_ been tested (though I have their report
descriptors), but I've been guaranted by eeti that they follow the same
protocol.
The tested ones are also blacklisted in hid-core.c.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
---
 drivers/hid/hid-core.c       |    2 ++
 drivers/hid/hid-ids.h        |    6 ++++++
 drivers/hid/hid-multitouch.c |   18 ++++++++++++++++++
 3 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index c4d049a..eeaa7c5 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1407,6 +1407,8 @@ static const struct hid_device_id hid_have_special_driver[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_DWAV, USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_480D) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_DWAV, USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_480E) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_DWAV, USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_720C) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_DWAV, USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_7224) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_DWAV, USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_725E) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_DWAV, USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_726B) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_DWAV, USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_72A1) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_DWAV, USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_7302) },
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index e2fb977..963207b 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -237,11 +237,17 @@
 #define USB_DEVICE_ID_EGALAX_TOUCHCONTROLLER	0x0001
 #define USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_480D	0x480d
 #define USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_480E	0x480e
+#define USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_7207	0x7207
 #define USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_720C	0x720c
+#define USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_7224	0x7224
+#define USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_725E	0x725e
+#define USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_7262	0x7262
 #define USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_726B	0x726b
+#define USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_72AA	0x72aa
 #define USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_72A1	0x72a1
 #define USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_72FA	0x72fa
 #define USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_7302	0x7302
+#define USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_7349	0x7349
 #define USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_A001	0xa001
 
 #define USB_VENDOR_ID_ELECOM		0x056e
diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 1e6de67..a98102d 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -785,12 +785,27 @@ static const struct hid_device_id mt_devices[] = {
 	{ .driver_data = MT_CLS_EGALAX,
 		HID_USB_DEVICE(USB_VENDOR_ID_DWAV,
 			USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_720C) },
+	{ .driver_data = MT_CLS_EGALAX_SERIAL,
+		HID_USB_DEVICE(USB_VENDOR_ID_DWAV,
+			USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_7207) },
+	{ .driver_data = MT_CLS_EGALAX_SERIAL,
+		HID_USB_DEVICE(USB_VENDOR_ID_DWAV,
+			USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_725E) },
+	{ .driver_data = MT_CLS_EGALAX_SERIAL,
+		HID_USB_DEVICE(USB_VENDOR_ID_DWAV,
+			USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_7224) },
 	{ .driver_data = MT_CLS_EGALAX,
 		HID_USB_DEVICE(USB_VENDOR_ID_DWAV,
 			USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_726B) },
+	{ .driver_data = MT_CLS_EGALAX_SERIAL,
+		HID_USB_DEVICE(USB_VENDOR_ID_DWAV,
+			USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_7262) },
 	{ .driver_data = MT_CLS_EGALAX,
 		HID_USB_DEVICE(USB_VENDOR_ID_DWAV,
 			USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_72A1) },
+	{ .driver_data = MT_CLS_EGALAX_SERIAL,
+		HID_USB_DEVICE(USB_VENDOR_ID_DWAV,
+			USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_72AA) },
 	{ .driver_data = MT_CLS_EGALAX,
 		HID_USB_DEVICE(USB_VENDOR_ID_DWAV,
 			USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_72FA) },
@@ -799,6 +814,9 @@ static const struct hid_device_id mt_devices[] = {
 			USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_7302) },
 	{ .driver_data = MT_CLS_EGALAX_SERIAL,
 		HID_USB_DEVICE(USB_VENDOR_ID_DWAV,
+			USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_7349) },
+	{ .driver_data = MT_CLS_EGALAX_SERIAL,
+		HID_USB_DEVICE(USB_VENDOR_ID_DWAV,
 			USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_A001) },
 
 	/* Elo TouchSystems IntelliTouch Plus panel */
-- 
1.7.7.6

