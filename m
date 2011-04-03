Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004Ab1DCO7r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Apr 2011 10:59:47 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:40177 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363Ab1DCO7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Apr 2011 10:59:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:sender:from:cc:date:subject;
        b=fb42rbaJDX/qSJWjn/tG/E4mhI6C7Of2TMcy0JeJYTL/87Ryu6KGckgA/tCmgV28IF
         ZOMxEHbW1C6798TKOGFUGsyscVpbfA8KLxT+cz0CFU5qNEBI3NoutcFQvcZDhcfvfh3I
         o2ii3AB4cHeBYBBWlNiHFAEVBNMyLTX5ivOY8=
Message-ID: <4d988b60.29c6ec0a.0716.ffffa4bf@mx.google.com>
From: Unavowed <unavowed@vexillium.org>
Cc: linux-kernel@vger.kernel.org
Date: Sun, 3 Apr 2011 15:08:15 +0100
Subject: [PATCH] HID: Add NOGET quirk for the CH Pro Throttle
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CH Pro Throttle needs the NOGET quirk flag to work, just like other CH
Products devices which already have the flag set.

Signed-off-by: Unavowed <unavowed@vexillium.org>
---
 drivers/hid/hid-ids.h           |    1 +
 drivers/hid/usbhid/hid-quirks.c |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 65ac53d..1a9f996 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -150,6 +150,7 @@
 #define USB_DEVICE_ID_CANDO_MULTI_TOUCH_15_6 0x0f01
 
 #define USB_VENDOR_ID_CH		0x068e
+#define USB_DEVICE_ID_CH_PRO_THROTTLE	0x00f1
 #define USB_DEVICE_ID_CH_PRO_PEDALS	0x00f2
 #define USB_DEVICE_ID_CH_COMBATSTICK	0x00f4
 #define USB_DEVICE_ID_CH_FLIGHT_SIM_ECLIPSE_YOKE       0x0051
diff --git a/drivers/hid/usbhid/hid-quirks.c b/drivers/hid/usbhid/hid-quirks.c
index 9a94b64..a8426f1 100644
--- a/drivers/hid/usbhid/hid-quirks.c
+++ b/drivers/hid/usbhid/hid-quirks.c
@@ -59,6 +59,7 @@ static const struct hid_blacklist {
 	{ USB_VENDOR_ID_CH, USB_DEVICE_ID_CH_COMBATSTICK, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_CH, USB_DEVICE_ID_CH_FLIGHT_SIM_ECLIPSE_YOKE, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_CH, USB_DEVICE_ID_CH_FLIGHT_SIM_YOKE, HID_QUIRK_NOGET },
+	{ USB_VENDOR_ID_CH, USB_DEVICE_ID_CH_PRO_THROTTLE, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_CH, USB_DEVICE_ID_CH_PRO_PEDALS, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_CH, USB_DEVICE_ID_CH_3AXIS_5BUTTON_STICK, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_CH, USB_DEVICE_ID_CH_AXIS_295, HID_QUIRK_NOGET },
-- 
1.7.3.4

