Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935743Ab1KJEou (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 23:44:50 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43248 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935279Ab1KJDeN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:34:13 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:26 2011
Message-Id: <20111109212726.725551268@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:29:42 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Andreas Krist <andreas.krist@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [260/262] HID: hid-apple: add device ID of another wireless aluminium
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Krist <andreas.krist@gmail.com>

commit ad734bc1565364f9e4b70888d3ce5743b3c1030a upstream.

I've recently bought a Apple wireless aluminum keyboard (model 2011) which is
not yet supported by the kernel - it seems they just changed the device id.
After applying the attached patch, the device is fully functional.

Signed-off-by: Andreas Krist <andreas.krist@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hid/hid-apple.c |    3 +++
 drivers/hid/hid-core.c  |    1 +
 drivers/hid/hid-ids.h   |    1 +
 3 files changed, 5 insertions(+)

--- a/drivers/hid/hid-apple.c
+++ b/drivers/hid/hid-apple.c
@@ -483,6 +483,9 @@ static const struct hid_device_id apple_
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_ISO),
 		.driver_data = APPLE_NUMLOCK_EMULATION | APPLE_HAS_FN |
 			APPLE_ISO_KEYBOARD },
+	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_2011_ISO),
+		.driver_data = APPLE_NUMLOCK_EMULATION | APPLE_HAS_FN |
+			APPLE_ISO_KEYBOARD },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_JIS),
 		.driver_data = APPLE_NUMLOCK_EMULATION | APPLE_HAS_FN },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING_ANSI),
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1355,6 +1355,7 @@ static const struct hid_device_id hid_ha
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_ANSI) },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_ISO) },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_JIS) },
+	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_2011_ISO) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_FOUNTAIN_TP_ONLY) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER1_TP_ONLY) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ASUS, USB_DEVICE_ID_ASUS_T91MT) },
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -124,6 +124,7 @@
 #define USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_ANSI  0x0239
 #define USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_ISO   0x023a
 #define USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_JIS   0x023b
+#define USB_DEVICE_ID_APPLE_ALU_WIRELESS_2011_ISO   0x0256
 #define USB_DEVICE_ID_APPLE_FOUNTAIN_TP_ONLY	0x030a
 #define USB_DEVICE_ID_APPLE_GEYSER1_TP_ONLY	0x030b
 #define USB_DEVICE_ID_APPLE_ATV_IRCONTROL	0x8241


