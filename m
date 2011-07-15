Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343Ab1GOI7D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 04:59:03 -0400
Received: from accupoint.com.tw ([220.128.111.38]:55449 "EHLO
	exsvr1.accupoint.com.tw" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752273Ab1GOI7C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 04:59:02 -0400
Subject: [Patch v2]hid-multitouch: add one new multitouch device's VID/PID
From: ice chien <ice.chien@accupoint.com.tw>
To: linux-kernel@vger.kernel.org, benjamin.tissoires@enac.fr
Cc: jonson.wu@accupoint.com.tw
Content-Type: text/plain; charset="UTF-8"
Organization: accupoint
Date: Fri, 15 Jul 2011 16:58:06 +0800
Message-ID: <1310720286.19815.25.camel@ice-Ubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Jul 2011 08:54:41.0085 (UTC) FILETIME=[D59316D0:01CC42CC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for the CSR panel built by XAT.

Signed-off-by: Ice Chien<ice.chien@accupoint.com.tw>
---
diff -u linux-3.0-rc7/drivers/hid/hid-core.c modified_linux-3.0-rc7/drivers/hid/hid-core.c
--- linux-3.0-rc7/drivers/hid/hid-core.c	2011-07-12 07:51:52.000000000 +0800
+++ modified_linux-3.0-rc7/drivers/hid/hid-core.c	2011-07-14 16:40:49.265137787 +0800
@@ -1499,6 +1499,7 @@
 	{ HID_USB_DEVICE(USB_VENDOR_ID_WALTOP, USB_DEVICE_ID_WALTOP_SLIM_TABLET_12_1_INCH) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_WALTOP, USB_DEVICE_ID_WALTOP_MEDIA_TABLET_10_6_INCH) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_WALTOP, USB_DEVICE_ID_WALTOP_MEDIA_TABLET_14_1_INCH) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_XAT, USB_DEVICE_ID_XAT_CSR) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ZEROPLUS, 0x0005) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ZEROPLUS, 0x0030) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ZYDACRON, USB_DEVICE_ID_ZYDACRON_REMOTE_CONTROL) },
diff -u linux-3.0-rc7/drivers/hid/hid-ids.h modified_linux-3.0-rc7/drivers/hid/hid-ids.h
--- linux-3.0-rc7/drivers/hid/hid-ids.h	2011-07-12 07:51:52.000000000 +0800
+++ modified_linux-3.0-rc7/drivers/hid/hid-ids.h	2011-07-14 16:38:00.565529748 +0800
@@ -663,6 +663,9 @@
 #define USB_VENDOR_ID_WISEGROUP_LTD2	0x6677
 #define USB_DEVICE_ID_SMARTJOY_DUAL_PLUS 0x8802
 
+#define USB_VENDOR_ID_XAT	0x2505
+#define USB_DEVICE_ID_XAT_CSR	0x0220
+
 #define USB_VENDOR_ID_YEALINK		0x6993
 #define USB_DEVICE_ID_YEALINK_P1K_P4K_B2K	0xb001
 
diff -u linux-3.0-rc7/drivers/hid/hid-multitouch.c modified_linux-3.0-rc7/drivers/hid/hid-multitouch.c
--- linux-3.0-rc7/drivers/hid/hid-multitouch.c	2011-07-12 07:51:52.000000000 +0800
+++ modified_linux-3.0-rc7/drivers/hid/hid-multitouch.c	2011-07-14 16:43:02.786343884 +0800
@@ -727,6 +727,10 @@
 	{ .driver_data = MT_CLS_DEFAULT,
 		HID_USB_DEVICE(USB_VENDOR_ID_UNITEC,
 			USB_DEVICE_ID_UNITEC_USB_TOUCH_0A19) },
+	/* XAT */
+	{ .driver_data = MT_CLS_DEFAULT,
+		HID_USB_DEVICE(USB_VENDOR_ID_XAT,
+			USB_DEVICE_ID_XAT_CSR) },
 
 	{ }
 };
diff -u linux-3.0-rc7/drivers/hid/Kconfig modified_linux-3.0-rc7/drivers/hid/Kconfig
--- linux-3.0-rc7/drivers/hid/Kconfig	2011-07-12 07:51:52.000000000 +0800
+++ modified_linux-3.0-rc7/drivers/hid/Kconfig	2011-07-14 16:44:05.610915920 +0800
@@ -322,6 +322,7 @@
 	  - Stantum multitouch panels
 	  - Touch International Panels
 	  - Unitec Panels
+	- XAT optical touch panels
 
 	  If unsure, say N.
 
Common subdirectories: linux-3.0-rc7/drivers/hid/usbhid and modified_linux-3.0-rc7/drivers/hid/usbhid


