Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226Ab1AHLPQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jan 2011 06:15:16 -0500
Received: from smtp1-g21.free.fr ([212.27.42.1]:53982 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751548Ab1AHLPM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jan 2011 06:15:12 -0500
From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
To: Stephane Chatty <chatty@enac.fr>, Henrik Rydberg <rydberg@euromail.se>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Subject: [PATCH] HID: Switch turbox/mosart touchscreen to hid-mosart
Date: Sat,  8 Jan 2011 12:15:42 +0100
Message-Id: <1294485342-2492-2-git-send-email-benjamin.tissoires@enac.fr>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1294485342-2492-1-git-send-email-benjamin.tissoires@enac.fr>
References: <1294485342-2492-1-git-send-email-benjamin.tissoires@enac.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This device used the MULTI_INPUT quirk whereas it could be used
with hid-mosart instead to support the multitouch part.

Reference: https://bugs.launchpad.net/ubuntu/+bug/620609/

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
---
Hi Jiri,

This one is in the utouch ppa since Novembre.
The guy that sent the multi_input quirk was not able to
test it, but others reported it is ok.

I think it also can go to stable.

Cheers,
Benjamin

 drivers/hid/hid-core.c          |    1 +
 drivers/hid/hid-mosart.c        |    1 +
 drivers/hid/usbhid/hid-quirks.c |    1 -
 3 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index a397010..9303632 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1420,6 +1420,7 @@ static const struct hid_device_id hid_have_special_driver[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_TOPSEED, USB_DEVICE_ID_TOPSEED_CYBERLINK) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_TOPSEED2, USB_DEVICE_ID_TOPSEED2_RF_COMBO) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_TWINHAN, USB_DEVICE_ID_TWINHAN_IR_REMOTE) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_TURBOX, USB_DEVICE_ID_TURBOX_TOUCHSCREEN_MOSART) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_UCLOGIC, USB_DEVICE_ID_UCLOGIC_TABLET_PF1209) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_UCLOGIC, USB_DEVICE_ID_UCLOGIC_TABLET_WP4030U) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_UCLOGIC, USB_DEVICE_ID_UCLOGIC_TABLET_WP5540U) },
diff --git a/drivers/hid/hid-mosart.c b/drivers/hid/hid-mosart.c
index 9fb050c..aed7ffe 100644
--- a/drivers/hid/hid-mosart.c
+++ b/drivers/hid/hid-mosart.c
@@ -257,6 +257,7 @@ static void mosart_remove(struct hid_device *hdev)
 static const struct hid_device_id mosart_devices[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ASUS, USB_DEVICE_ID_ASUS_T91MT) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ASUS, USB_DEVICE_ID_ASUSTEK_MULTITOUCH_YFO) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_TURBOX, USB_DEVICE_ID_TURBOX_TOUCHSCREEN_MOSART) },
 	{ }
 };
 MODULE_DEVICE_TABLE(hid, mosart_devices);
diff --git a/drivers/hid/usbhid/hid-quirks.c b/drivers/hid/usbhid/hid-quirks.c
index 76b9a14..9a94b64 100644
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
-- 
1.7.3.4

