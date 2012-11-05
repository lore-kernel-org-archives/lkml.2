Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810Ab2KEUFi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 15:05:38 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44396 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164Ab2KEUFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 15:05:36 -0500
From: Chris J Arges <chris.j.arges@canonical.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, Chris J Arges <chris.j.arges@canonical.com>
Subject: [PATCH] hid: usbhid: add quirk for SB arena headset v2
Date: Mon,  5 Nov 2012 14:05:45 -0600
Message-Id: <1352145945-8035-1-git-send-email-chris.j.arges@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When an SB Arena USB headset is plugged in, it registers the volume
keys on the headset as a keyboard and continually sends events causing
issues with normal keyboard input. This quirk disables the volume keys.

BugLink: http://bugs.launchpad.net/bugs/1007575
Signed-off-by: Chris J Arges <chris.j.arges@canonical.com>
---
 drivers/hid/hid-ids.h           |    1 +
 drivers/hid/usbhid/hid-quirks.c |    1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 269b509..1936414 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -223,6 +223,7 @@
 
 #define USB_VENDOR_ID_CREATIVELABS	0x041e
 #define USB_DEVICE_ID_PRODIKEYS_PCMIDI	0x2801
+#define USB_DEVICE_ID_SB_ARENA_HEADSET	0x0403
 
 #define USB_VENDOR_ID_CVTOUCH		0x1ff7
 #define USB_DEVICE_ID_CVTOUCH_SCREEN	0x0013
diff --git a/drivers/hid/usbhid/hid-quirks.c b/drivers/hid/usbhid/hid-quirks.c
index 11c7932..4bee3b7 100644
--- a/drivers/hid/usbhid/hid-quirks.c
+++ b/drivers/hid/usbhid/hid-quirks.c
@@ -68,6 +68,7 @@ static const struct hid_blacklist {
 	{ USB_VENDOR_ID_CH, USB_DEVICE_ID_CH_PRO_PEDALS, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_CH, USB_DEVICE_ID_CH_3AXIS_5BUTTON_STICK, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_CH, USB_DEVICE_ID_CH_AXIS_295, HID_QUIRK_NOGET },
+	{ USB_VENDOR_ID_CREATIVELABS, USB_DEVICE_ID_SB_ARENA_HEADSET, HID_QUIRK_IGNORE },
 	{ USB_VENDOR_ID_DMI, USB_DEVICE_ID_DMI_ENC, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_ELO, USB_DEVICE_ID_ELO_TS2700, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_FREESCALE, USB_DEVICE_ID_FREESCALE_MX28, HID_QUIRK_NOGET },
-- 
1.7.9.5

