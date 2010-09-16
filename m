Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751797Ab0IPVTk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 17:19:40 -0400
Received: from mail.cybernet.com.pl ([195.117.60.252]:50441 "EHLO
	mail.cybernet.com.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807Ab0IPVTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 17:19:38 -0400
Message-ID: <4C9289E5.3020400@multivision.pl>
Date: Thu, 16 Sep 2010 23:19:33 +0200
From: Lech Perczak <lech.perczak@multivision.pl>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100825 Thunderbird/3.1.3
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [Patch 1/1] hid: Fix for A4Tech RP-649 horizontal scrollwheel (updated)
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



From: Lech Perczak<lech.perczak@multivision.pl>

- Add USB device ID of A4Tech RF mouse receiver (09da:001a) used with RP-649(Z) mice
- Enable fix for their horizontal scroll wheel behaviour, associate it with B8 hack.
- Blacklist the new device ID in hid-core.c

Signed-off-by: Lech Perczak<lech.perczak@multivision.pl>
---
diff -up hid/hid-a4tech.c.orig hid/hid-a4tech.c
--- hid/hid-a4tech.c.orig	2010-08-02 00:11:14.000000000 +0200
+++ hid/hid-a4tech.c	2010-09-09 17:51:23.000000000 +0200
@@ -133,6 +133,8 @@
  		.driver_data = A4_2WHEEL_MOUSE_HACK_7 },
  	{ HID_USB_DEVICE(USB_VENDOR_ID_A4TECH, USB_DEVICE_ID_A4TECH_X5_005D),
  		.driver_data = A4_2WHEEL_MOUSE_HACK_B8 },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_A4TECH, USB_DEVICE_ID_A4TECH_RP_649),
+		.driver_data = A4_2WHEEL_MOUSE_HACK_B8 },
  	{ }
  };
  MODULE_DEVICE_TABLE(hid, a4_devices);
diff -up hid/hid-ids.h.orig hid/hid-ids.h
--- hid/hid-ids.h.orig	2010-09-09 17:48:28.000000000 +0200
+++ hid/hid-ids.h	2010-09-09 17:41:09.000000000 +0200
@@ -25,6 +25,7 @@
  #define USB_VENDOR_ID_A4TECH		0x09da
  #define USB_DEVICE_ID_A4TECH_WCP32PU	0x0006
  #define USB_DEVICE_ID_A4TECH_X5_005D	0x000a
+#define USB_DEVICE_ID_A4TECH_RP_649	0x001a

  #define USB_VENDOR_ID_AASHIMA		0x06d6
  #define USB_DEVICE_ID_AASHIMA_GAMEPAD	0x0025
diff -up hid/hid-core.c.orig hid/hid-core.c
--- hid/hid-core.c.orig	2010-08-02 00:11:14.000000000 +0200
+++ hid/hid-core.c	2010-09-16 23:03:24.000000000 +0200
@@ -1239,6 +1239,7 @@ static const struct hid_device_id hid_bl
  	{ HID_USB_DEVICE(USB_VENDOR_ID_3M, USB_DEVICE_ID_3M2256) },
  	{ HID_USB_DEVICE(USB_VENDOR_ID_A4TECH, USB_DEVICE_ID_A4TECH_WCP32PU) },
  	{ HID_USB_DEVICE(USB_VENDOR_ID_A4TECH, USB_DEVICE_ID_A4TECH_X5_005D) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_A4TECH, USB_DEVICE_ID_A4TECH_RP_649) },
  	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ATV_IRCONTROL) },
  	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_IRCONTROL4) },
  	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_MIGHTYMOUSE) },


