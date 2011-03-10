Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653Ab1CJUxv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 15:53:51 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64662 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752228Ab1CJUxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 15:53:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :message-id;
        b=hO+DKNEeoWpj9qsJp4Qc8d/FuWdQlpHummeg5Z7s2JBLrIYhdIF8OG8UA1RgfYcBV0
         Do5UtdNiea+dKNScbOpvwyMAlHeV8Z8OnV9MY4SIJCl1HJ2aRngui9bB1GRagQsfLIGA
         AGr1c2oP7eLZ83rnmZO8eowXRSkjBBRm48JxQ=
From: Michal =?utf-8?q?Mal=C3=BD?= <madcatxster@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Product ID for Logitech Driving Force Pro wheel
Date: Thu, 10 Mar 2011 21:53:43 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.38-rc8-ARCHMOD; KDE/4.6.1; x86_64; ; )
Cc: jkosina@suse.cz
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_YpTeNlWA+vNxYn/"
Message-Id: <201103102153.44137.madcatxster@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_YpTeNlWA+vNxYn/
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit

This trivial fix adds correct product ID for Logitech Driving Force Pro wheel 
when it operates in native mode. This is needed to get force feedback working.

--Boundary-00=_YpTeNlWA+vNxYn/
Content-Type: text/x-patch;
  charset="UTF-8";
  name="dfp_id_0.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dfp_id_0.patch"

--- linux.orig/drivers/hid/hid-core.c	2011-03-08 06:09:37.000000000 +0100
+++ linux/drivers/hid/hid-core.c	2011-03-09 20:09:36.926973002 +0100
@@ -1368,6 +1368,7 @@
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_FLIGHT_SYSTEM_G940) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_MOMO_WHEEL) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_MOMO_WHEEL2) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_DFP_WHEEL) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_G25_WHEEL) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_WII_WHEEL) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_RUMBLEPAD2) },

--Boundary-00=_YpTeNlWA+vNxYn/
Content-Type: text/x-patch;
  charset="UTF-8";
  name="dfp_id_1.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dfp_id_1.patch"

--- linux.orig/drivers/hid/hid-lg.c	2011-03-08 06:09:37.000000000 +0100
+++ linux/drivers/hid/hid-lg.c	2011-03-09 20:09:36.927973002 +0100
@@ -375,6 +375,8 @@
 		.driver_data = LG_FF },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_MOMO_WHEEL2),
 		.driver_data = LG_FF },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_DFP_WHEEL),
+		.driver_data = LG_FF },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_G25_WHEEL),
 		.driver_data = LG_FF },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_WII_WHEEL),

--Boundary-00=_YpTeNlWA+vNxYn/
Content-Type: text/x-patch;
  charset="UTF-8";
  name="dfp_id_2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dfp_id_2.patch"

--- linux.orig/drivers/hid/hid-ids.h	2011-03-08 06:09:37.000000000 +0100
+++ linux/drivers/hid/hid-ids.h	2011-03-09 20:09:36.923973002 +0100
@@ -383,6 +383,7 @@
 #define USB_DEVICE_ID_LOGITECH_WHEEL	0xc294
 #define USB_DEVICE_ID_LOGITECH_WINGMAN_FFG	0xc293
 #define USB_DEVICE_ID_LOGITECH_MOMO_WHEEL	0xc295
+#define USB_DEVICE_ID_LOGITECH_DFP_WHEEL	0xc298
 #define USB_DEVICE_ID_LOGITECH_G25_WHEEL	0xc299
 #define USB_DEVICE_ID_LOGITECH_WII_WHEEL	0xc29c
 #define USB_DEVICE_ID_LOGITECH_ELITE_KBD	0xc30a

--Boundary-00=_YpTeNlWA+vNxYn/--
