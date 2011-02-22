Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542Ab1BVWda (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 17:33:30 -0500
Received: from kroah.org ([198.145.64.141]:46675 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754325Ab1BVWVf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 17:21:35 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 22 14:18:39 2011
Message-Id: <20110222221839.379619514@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 22 Feb 2011 14:17:02 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Benjamin Tissoires <benjamin.tissoires@enac.fr>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [23/70] HID: Switch turbox/mosart touchscreen to hid-mosart
In-Reply-To: <20110222222003.GA15831@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Benjamin Tissoires <benjamin.tissoires@enac.fr>

commit c64f6f934c7490faff76faf96217066a1b3570a0 upstream.

This device used the MULTI_INPUT quirk whereas it could be used
with hid-mosart instead to support the multitouch part.

Reference: https://bugs.launchpad.net/ubuntu/+bug/620609/

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hid/hid-core.c          |    1 +
 drivers/hid/hid-mosart.c        |    1 +
 drivers/hid/usbhid/hid-quirks.c |    1 -
 3 files changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1391,6 +1391,7 @@ static const struct hid_device_id hid_bl
 	{ HID_USB_DEVICE(USB_VENDOR_ID_TOPSEED, USB_DEVICE_ID_TOPSEED_CYBERLINK) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_TOPSEED2, USB_DEVICE_ID_TOPSEED2_RF_COMBO) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_TWINHAN, USB_DEVICE_ID_TWINHAN_IR_REMOTE) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_TURBOX, USB_DEVICE_ID_TURBOX_TOUCHSCREEN_MOSART) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_UCLOGIC, USB_DEVICE_ID_UCLOGIC_TABLET_PF1209) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_UCLOGIC, USB_DEVICE_ID_UCLOGIC_TABLET_WP4030U) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_UCLOGIC, USB_DEVICE_ID_UCLOGIC_TABLET_WP5540U) },
--- a/drivers/hid/hid-mosart.c
+++ b/drivers/hid/hid-mosart.c
@@ -240,6 +240,7 @@ static void mosart_remove(struct hid_dev
 static const struct hid_device_id mosart_devices[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ASUS, USB_DEVICE_ID_ASUS_T91MT) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ASUS, USB_DEVICE_ID_ASUSTEK_MULTITOUCH_YFO) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_TURBOX, USB_DEVICE_ID_TURBOX_TOUCHSCREEN_MOSART) },
 	{ }
 };
 MODULE_DEVICE_TABLE(hid, mosart_devices);
--- a/drivers/hid/usbhid/hid-quirks.c
+++ b/drivers/hid/usbhid/hid-quirks.c
@@ -35,7 +35,6 @@ static const struct hid_blacklist {
 	{ USB_VENDOR_ID_CHIC, USB_DEVICE_ID_CHIC_GAMEPAD, HID_QUIRK_BADPAD },
 	{ USB_VENDOR_ID_DWAV, USB_DEVICE_ID_EGALAX_TOUCHCONTROLLER, HID_QUIRK_MULTI_INPUT | HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_MOJO, USB_DEVICE_ID_RETRO_ADAPTER, HID_QUIRK_MULTI_INPUT },
-	{ USB_VENDOR_ID_TURBOX, USB_DEVICE_ID_TURBOX_TOUCHSCREEN_MOSART, HID_QUIRK_MULTI_INPUT },
 	{ USB_VENDOR_ID_HAPP, USB_DEVICE_ID_UGCI_DRIVING, HID_QUIRK_BADPAD | HID_QUIRK_MULTI_INPUT },
 	{ USB_VENDOR_ID_HAPP, USB_DEVICE_ID_UGCI_FLYING, HID_QUIRK_BADPAD | HID_QUIRK_MULTI_INPUT },
 	{ USB_VENDOR_ID_HAPP, USB_DEVICE_ID_UGCI_FIGHTING, HID_QUIRK_BADPAD | HID_QUIRK_MULTI_INPUT },


