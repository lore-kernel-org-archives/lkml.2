Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362Ab1HNOmm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 10:42:42 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:39870 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168Ab1HNOmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 10:42:40 -0400
Date: Sun, 14 Aug 2011 15:43:11 +0100
From: Jeremiah Matthey <sprg86@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] usbhid: Add the malfunctioning SiGma Micro chip to the list
 of hid-quirks
Message-ID: <20110814144310.GA3303@netstar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch to add SiGma Micro-based keyboards (1c4f:0002) to hid-quirks.

These keyboards dont seem to allow the records to be initialized, and hence a
timeout occurs when the usbhid driver attempts to initialize them. The patch
just adds the signature for these keyboards to the hid-quirks list with the
setting HID_QUIRK_NO_INIT_REPORTS. This removes the 5-10 second wait for the
timeout to occur.

Patch was carried out against 3.0.1, although due to the simplicity, will
probably work with HEAD even if someone has changed those files.



diff -ru linux-3.0.1-clean/drivers/hid/hid-ids.h linux-3.0.1-patched/drivers/hid/hid-ids.h
--- linux-3.0.1-clean/drivers/hid/hid-ids.h	2011-08-05 05:59:21.000000000 +0100
+++ linux-3.0.1-patched/drivers/hid/hid-ids.h	2011-08-14 15:25:58.129865922 +0100
@@ -568,6 +568,9 @@
 #define USB_DEVICE_ID_SAMSUNG_IR_REMOTE	0x0001
 #define USB_DEVICE_ID_SAMSUNG_WIRELESS_KBD_MOUSE	0x0600
 
+#define USB_VENDOR_ID_SIGMA_MICRO	0x1c4f
+#define USB_DEVICE_ID_SIGMA_MICRO_KEYBOARD	0x0002
+
 #define USB_VENDOR_ID_SKYCABLE			0x1223
 #define	USB_DEVICE_ID_SKYCABLE_WIRELESS_PRESENTER	0x3F07
 
diff -ru linux-3.0.1-clean/drivers/hid/usbhid/hid-quirks.c linux-3.0.1-patched/drivers/hid/usbhid/hid-quirks.c
--- linux-3.0.1-clean/drivers/hid/usbhid/hid-quirks.c	2011-08-05 05:59:21.000000000 +0100
+++ linux-3.0.1-patched/drivers/hid/usbhid/hid-quirks.c	2011-08-14 15:26:06.289865845 +0100
@@ -89,6 +89,7 @@
 
 	{ USB_VENDOR_ID_CHICONY, USB_DEVICE_ID_CHICONY_MULTI_TOUCH, HID_QUIRK_MULTI_INPUT },
 	{ USB_VENDOR_ID_CHICONY, USB_DEVICE_ID_CHICONY_WIRELESS, HID_QUIRK_MULTI_INPUT },
+	{ USB_VENDOR_ID_SIGMA_MICRO, USB_DEVICE_ID_SIGMA_MICRO_KEYBOARD, HID_QUIRK_NO_INIT_REPORTS },
 	{ 0, 0 }
 };
 
