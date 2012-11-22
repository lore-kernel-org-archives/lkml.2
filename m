Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756721Ab2KVWlA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 17:41:00 -0500
Received: from mail-ye0-f174.google.com ([209.85.213.174]:64605 "EHLO
	mail-ye0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753582Ab2KVWk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 17:40:57 -0500
Message-ID: <50AEA9F5.4010209@gmail.com>
Date: Thu, 22 Nov 2012 20:40:53 -0200
From: Marco Biscaro <marcobiscaro2112@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>, linux-usb@vger.kernel.org
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] USB: add support to novatec wireless mouse
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support to Novatec wireless mouse (device ID 0603:1602).
Fixes bug https://bugzilla.kernel.org/show_bug.cgi?id=47031

Signed-off-by: Marco Biscaro <marcobiscaro2112@gmail.com>
---
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 9d7a428..b40632e 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -603,6 +603,7 @@
 
 #define USB_VENDOR_ID_NOVATEK		0x0603
 #define USB_DEVICE_ID_NOVATEK_PCT	0x0600
+#define USB_DEVICE_ID_NOVATEK_MOUSE	0x1602
 
 #define USB_VENDOR_ID_NTRIG		0x1b96
 #define USB_DEVICE_ID_NTRIG_TOUCH_SCREEN   0x0001
diff --git a/drivers/hid/usbhid/hid-quirks.c b/drivers/hid/usbhid/hid-quirks.c
index 11c7932..ef49a19 100644
--- a/drivers/hid/usbhid/hid-quirks.c
+++ b/drivers/hid/usbhid/hid-quirks.c
@@ -72,6 +72,7 @@ static const struct hid_blacklist {
 	{ USB_VENDOR_ID_ELO, USB_DEVICE_ID_ELO_TS2700, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_FREESCALE, USB_DEVICE_ID_FREESCALE_MX28, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_MGE, USB_DEVICE_ID_MGE_UPS, HID_QUIRK_NOGET },
+	{ USB_VENDOR_ID_NOVATEK, USB_DEVICE_ID_NOVATEK_MOUSE, HID_QUIRK_NO_INIT_REPORTS },
 	{ USB_VENDOR_ID_PIXART, USB_DEVICE_ID_PIXART_OPTICAL_TOUCH_SCREEN, HID_QUIRK_NO_INIT_REPORTS },
 	{ USB_VENDOR_ID_PIXART, USB_DEVICE_ID_PIXART_OPTICAL_TOUCH_SCREEN1, HID_QUIRK_NO_INIT_REPORTS },
 	{ USB_VENDOR_ID_PIXART, USB_DEVICE_ID_PIXART_OPTICAL_TOUCH_SCREEN2, HID_QUIRK_NO_INIT_REPORTS },
