Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932117Ab2GJRdn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 13:33:43 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:38788 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677Ab2GJRdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 13:33:40 -0400
From: Yuri Khan <yurivkhan@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Yuri Khan <yurivkhan@gmail.com>
Subject: [PATCH v3 1/1] Input: xpad - Handle all variations of Mad Catz Beat Pad
Date: Wed, 11 Jul 2012 00:33:22 +0700
Message-Id: <1341941602-18418-1-git-send-email-yurivkhan@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1341592324-665-1-git-send-email-yurivkhan@gmail.com>
References: <1341592324-665-1-git-send-email-yurivkhan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Add this device to usbhid ignore list
---
 drivers/hid/hid-core.c        |    1 +
 drivers/hid/hid-ids.h         |    3 +++
 drivers/input/joystick/xpad.c |    1 +
 3 files changed, 5 insertions(+)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 6ac0286..1540934 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1995,6 +1995,7 @@ static const struct hid_device_id hid_ignore_list[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LD, USB_DEVICE_ID_LD_MCT) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LD, USB_DEVICE_ID_LD_HYBRID) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LD, USB_DEVICE_ID_LD_HEATCONTROL) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_MADCATZ, USB_DEVICE_ID_MADCATZ_BEATPAD) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MCC, USB_DEVICE_ID_MCC_PMD1024LS) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MCC, USB_DEVICE_ID_MCC_PMD1208LS) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROCHIP, USB_DEVICE_ID_PICKIT1) },
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index d1cdd2d..43c3d75 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -518,6 +518,9 @@
 #define USB_DEVICE_ID_CRYSTALTOUCH	0x0006
 #define USB_DEVICE_ID_CRYSTALTOUCH_DUAL	0x0007
 
+#define USB_VENDOR_ID_MADCATZ		0x0738
+#define USB_DEVICE_ID_MADCATZ_BEATPAD	0x4540
+
 #define USB_VENDOR_ID_MCC		0x09db
 #define USB_DEVICE_ID_MCC_PMD1024LS	0x0076
 #define USB_DEVICE_ID_MCC_PMD1208LS	0x007a
diff --git a/drivers/input/joystick/xpad.c b/drivers/input/joystick/xpad.c
index ee16fb6..16974ef 100644
--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -238,6 +238,7 @@ static struct usb_device_id xpad_table [] = {
 	XPAD_XBOX360_VENDOR(0x045e),		/* Microsoft X-Box 360 controllers */
 	XPAD_XBOX360_VENDOR(0x046d),		/* Logitech X-Box 360 style controllers */
 	XPAD_XBOX360_VENDOR(0x0738),		/* Mad Catz X-Box 360 controllers */
+	{ USB_DEVICE(0x0738, 0x4540) },		/* Mad Catz Beat Pad */
 	XPAD_XBOX360_VENDOR(0x0e6f),		/* 0x0e6f X-Box 360 controllers */
 	XPAD_XBOX360_VENDOR(0x12ab),		/* X-Box 360 dance pads */
 	XPAD_XBOX360_VENDOR(0x1430),		/* RedOctane X-Box 360 controllers */
-- 
1.7.9.5

