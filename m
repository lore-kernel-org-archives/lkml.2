Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484Ab0HXPpI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 11:45:08 -0400
Received: from iku-turso.techk.org ([201.17.8.2]:47018 "EHLO
	Iku-turso.techk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313Ab0HXPpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 11:45:05 -0400
X-Greylist: delayed 306 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Aug 2010 11:45:05 EDT
Date: Tue, 24 Aug 2010 12:39:50 -0300 (BRT)
From: Decio Fonini <fonini@techk.org>
To: Jiri Kosina <jkosina@suse.cz>
cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: [PATCH 2.6.35.3] usbhid: USB 5543:6001 needs HID_QUIRK_MULTI_INPUT
Message-ID: <alpine.LFD.2.00.1008241235200.29566@Tk.techk.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Decio Fonini <fonini@techk.org>

The Kanvus Note A5 tablet (with USB ID 5543:6001, USB vendor UC_Logic) needs 
the HID_QUIRK_MULTI_INPUT in order to work out of the box; otherwise, we get 
the usual "cursor stuck at the upper left corner of the screen".

Signed-off-by: Decio Fonini <fonini@techk.org>

---

diff -uprN -X a/Documentation/dontdiff a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
--- a/drivers/hid/hid-ids.h	2010-08-20 15:55:55.000000000 -0300
+++ b/drivers/hid/hid-ids.h	2010-08-24 10:17:12.244384470 -0300
@@ -490,6 +490,7 @@
  #define USB_VENDOR_ID_UCLOGIC		0x5543
  #define USB_DEVICE_ID_UCLOGIC_TABLET_PF1209	0x0042
  #define USB_DEVICE_ID_UCLOGIC_TABLET_WP4030U	0x0003
+#define USB_DEVICE_ID_UCLOGIC_TABLET_KNA5	0x6001

  #define USB_VENDOR_ID_VERNIER		0x08f7
  #define USB_DEVICE_ID_VERNIER_LABPRO	0x0001
diff -uprN -X a/Documentation/dontdiff a/drivers/hid/usbhid/hid-quirks.c b/drivers/hid/usbhid/hid-quirks.c
--- a/drivers/hid/usbhid/hid-quirks.c	2010-08-20 15:55:55.000000000 -0300
+++ b/drivers/hid/usbhid/hid-quirks.c	2010-08-24 11:07:51.388410656 -0300
@@ -69,6 +69,7 @@ static const struct hid_blacklist {
  	{ USB_VENDOR_ID_TURBOX, USB_DEVICE_ID_TURBOX_KEYBOARD, HID_QUIRK_NOGET },
  	{ USB_VENDOR_ID_UCLOGIC, USB_DEVICE_ID_UCLOGIC_TABLET_PF1209, HID_QUIRK_MULTI_INPUT },
  	{ USB_VENDOR_ID_UCLOGIC, USB_DEVICE_ID_UCLOGIC_TABLET_WP4030U, HID_QUIRK_MULTI_INPUT },
+	{ USB_VENDOR_ID_UCLOGIC, USB_DEVICE_ID_UCLOGIC_TABLET_KNA5, HID_QUIRK_MULTI_INPUT },
  	{ USB_VENDOR_ID_WISEGROUP, USB_DEVICE_ID_DUAL_USB_JOYPAD, HID_QUIRK_NOGET | HID_QUIRK_MULTI_INPUT | HID_QUIRK_SKIP_OUTPUT_REPORTS },
  	{ USB_VENDOR_ID_WISEGROUP, USB_DEVICE_ID_QUAD_USB_JOYPAD, HID_QUIRK_NOGET | HID_QUIRK_MULTI_INPUT },

