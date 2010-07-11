Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043Ab0GKQqQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 12:46:16 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37662 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683Ab0GKQqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 12:46:14 -0400
MIME-Version: 1.0
From: samwise <samwise@bagshot-row.org>
Date: Sun, 11 Jul 2010 17:45:50 +0100
Message-ID: <AANLkTilCk7q_GsrBtxsuNGTwsQMZmUJN7O8e1G0q3fqA@mail.gmail.com>
Subject: [PATCHv1] USB HID DRIVERS: Enable HID_QUIRK_MULTI_INPUT for Retro 
	Adaptor
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, Stephane Chatty <chatty@enac.fr>,
        Don Prince <dhprince-devel@yahoo.co.uk>,
        Peter Hutterer <peter.hutterer@who-t.net>,
        Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
        Daniel Oliveira Nascimento <don@syst.com.br>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Qureshi <retro@world3.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Edwards <samwise@bagshot-row.org>

Patch for linux-2.6.35-rc4 mainline kernel to enable Paul Qureshi's
Retro Adapter [http://keio.dk/retroadapter.html], an open source USB
device which allows controllers and joysticks from classic computers
and consoles to work on modern PCs, to appear as two separate devices
under Linux.
Signed-off-by: Peter Edwards <samwise@bagshot-row.org>
Acked-by: Paul Qureshi <retro@world3.net>
---

This is a first patch submission following the
Documentation/SubmittingPatches guidelines. Hope this is in the
correct format for inclusion and is directed at the correct
maintainer. Please reply if any modifications or further info is
required.

diff -uprN -X linux-2.6.35-rc4-vanilla/Documentation/dontdiff
linux-2.6.35-rc4-vanilla/drivers/hid/hid-ids.h
linux-2.6.35-rc4/drivers/hid/hid-ids.h
--- linux-2.6.35-rc4-vanilla/drivers/hid/hid-ids.h	2010-07-05
04:22:50.000000000 +0100
+++ linux-2.6.35-rc4/drivers/hid/hid-ids.h	2010-07-11 16:54:07.948153000 +0100
@@ -369,6 +369,8 @@
 #define USB_DEVICE_ID_MS_PRESENTER_8K_BT	0x0701
 #define USB_DEVICE_ID_MS_PRESENTER_8K_USB	0x0713

+#define USB_VENDOR_ID_MOJO              0x8282
+#define USB_DEVICE_ID_RETRO_ADAPTER     0x3201

 #define USB_VENDOR_ID_MONTEREY		0x0566
 #define USB_DEVICE_ID_GENIUS_KB29E	0x3004
diff -uprN -X linux-2.6.35-rc4-vanilla/Documentation/dontdiff
linux-2.6.35-rc4-vanilla/drivers/hid/usbhid/hid-quirks.c
linux-2.6.35-rc4/drivers/hid/usbhid/hid-quirks.c
--- linux-2.6.35-rc4-vanilla/drivers/hid/usbhid/hid-quirks.c	2010-07-05
04:22:50.000000000 +0100
+++ linux-2.6.35-rc4/drivers/hid/usbhid/hid-quirks.c	2010-07-11
16:55:22.028152999 +0100
@@ -37,6 +37,7 @@ static const struct hid_blacklist {
 	{ USB_VENDOR_ID_HAPP, USB_DEVICE_ID_UGCI_DRIVING, HID_QUIRK_BADPAD |
HID_QUIRK_MULTI_INPUT },
 	{ USB_VENDOR_ID_HAPP, USB_DEVICE_ID_UGCI_FLYING, HID_QUIRK_BADPAD |
HID_QUIRK_MULTI_INPUT },
 	{ USB_VENDOR_ID_HAPP, USB_DEVICE_ID_UGCI_FIGHTING, HID_QUIRK_BADPAD
| HID_QUIRK_MULTI_INPUT },
+{ USB_VENDOR_ID_MOJO, USB_DEVICE_ID_RETRO_ADAPTER, HID_QUIRK_MULTI_INPUT },
 	{ USB_VENDOR_ID_NATSU, USB_DEVICE_ID_NATSU_GAMEPAD, HID_QUIRK_BADPAD },
 	{ USB_VENDOR_ID_NEC, USB_DEVICE_ID_NEC_USB_GAME_PAD, HID_QUIRK_BADPAD },
 	{ USB_VENDOR_ID_NEXTWINDOW, USB_DEVICE_ID_NEXTWINDOW_TOUCHSCREEN,
HID_QUIRK_MULTI_INPUT},
