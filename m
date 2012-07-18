Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757651Ab2GRAG3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 20:06:29 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48276 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757497Ab2GRAEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 20:04:36 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Yuri Khan <yurivkhan@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [ 24/37] Input: xpad - handle all variations of Mad Catz Beat Pad
Date: Tue, 17 Jul 2012 17:03:01 -0700
Message-Id: <20120717232433.360625635@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120717232431.399005532@linuxfoundation.org>
References: <20120717232455.GA5994@kroah.com>
 <20120717232431.399005532@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuri Khan <yurivkhan@gmail.com>

commit 3ffb62cb9ac2430c2504c6ff9727d0f2476ef0bd upstream.

The device should be handled by xpad driver instead of generic HID driver.

Signed-off-by: Yuri Khan <yurivkhan@gmail.com>
Acked-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hid-core.c        |    1 +
 drivers/hid/hid-ids.h         |    3 +++
 drivers/input/joystick/xpad.c |    1 +
 3 files changed, 5 insertions(+)

--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1914,6 +1914,7 @@ static const struct hid_device_id hid_ig
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LD, USB_DEVICE_ID_LD_MCT) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LD, USB_DEVICE_ID_LD_HYBRID) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LD, USB_DEVICE_ID_LD_HEATCONTROL) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_MADCATZ, USB_DEVICE_ID_MADCATZ_BEATPAD) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MCC, USB_DEVICE_ID_MCC_PMD1024LS) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MCC, USB_DEVICE_ID_MCC_PMD1208LS) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROCHIP, USB_DEVICE_ID_PICKIT1) },
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -509,6 +509,9 @@
 #define USB_DEVICE_ID_CRYSTALTOUCH	0x0006
 #define USB_DEVICE_ID_CRYSTALTOUCH_DUAL	0x0007
 
+#define USB_VENDOR_ID_MADCATZ		0x0738
+#define USB_DEVICE_ID_MADCATZ_BEATPAD	0x4540
+
 #define USB_VENDOR_ID_MCC		0x09db
 #define USB_DEVICE_ID_MCC_PMD1024LS	0x0076
 #define USB_DEVICE_ID_MCC_PMD1208LS	0x007a
--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -238,6 +238,7 @@ static struct usb_device_id xpad_table [
 	XPAD_XBOX360_VENDOR(0x045e),		/* Microsoft X-Box 360 controllers */
 	XPAD_XBOX360_VENDOR(0x046d),		/* Logitech X-Box 360 style controllers */
 	XPAD_XBOX360_VENDOR(0x0738),		/* Mad Catz X-Box 360 controllers */
+	{ USB_DEVICE(0x0738, 0x4540) },		/* Mad Catz Beat Pad */
 	XPAD_XBOX360_VENDOR(0x0e6f),		/* 0x0e6f X-Box 360 controllers */
 	XPAD_XBOX360_VENDOR(0x12ab),		/* X-Box 360 dance pads */
 	XPAD_XBOX360_VENDOR(0x1430),		/* RedOctane X-Box 360 controllers */


