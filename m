Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754356Ab0LNVga (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 16:36:30 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:36595 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753289Ab0LNVgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 16:36:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=Lml/Q5pQD5S00pvhNy4PjrNGIbzSW/seriKNuGnz8BG7gFVLZEKoDwpo6VTnL810/H
         pi/bQez5X96+EDgpbCCknZAiDD8BApbOVDiMfp24fvQPpdTeDwvSl+y8WbuGxyn2DD3j
         WpPLJJ71wzYb1TSq2fLkjBfklVDF+AmasShKg=
Subject: [PATCH] hid: egalax: Extend support for touchscreen used in
 "Samsung NB30 touch" netbook.
From: Richard Nauber <richard.nauber@googlemail.com>
To: linux-kernel@vger.kernel.org
Cc: rydberg@euromail.se
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 14 Dec 2010 22:36:18 +0100
Message-ID: <1292362579.2232.84.camel@itzy>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there,
I got me a brand new "Samsung NB30 touch" and with this patch I have 
the full multitouch power at my fingertips. At least at two of them... 

The patch applies to the 
git://git.kernel.org/pub/scm/linux/kernel/git/rydberg/input-mt.git 
tree at a528f7.

Have Fun.

BTW: I have not found a suitable tuio bridge for linux mt devices, 
so I wrote a small mtdev2tuio tool. It uses libmtdev and liblo 
and allows to interact with lots of existing software (e.g. a 
compiz plugin, numtyphysics, ...). If someone is interested, I 
can upload it (might take a while).

-----snip-----

[hid] egalax: Extend hid-egalax support for touchscreen in the "Samsung NB30 touch" netbook.          

Signed-off-by: Richard Nauber <Richard.Nauber@gmail.com>

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 6fa4503..d8b10f6 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1301,6 +1301,7 @@ static const struct hid_device_id hid_blacklist[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_DWAV, USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_DWAV, USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH1) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_DWAV, USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH2) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_DWAV, USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH480e) },	
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_BM084) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_EZKEY, USB_DEVICE_ID_BTC_8193) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_GAMERON, USB_DEVICE_ID_GAMERON_DUAL_PSX_ADAPTOR) },
diff --git a/drivers/hid/hid-egalax.c b/drivers/hid/hid-egalax.c
index 5795969..0beada2 100644
--- a/drivers/hid/hid-egalax.c
+++ b/drivers/hid/hid-egalax.c
@@ -240,6 +240,8 @@ static const struct hid_device_id egalax_devices[] = {
 			USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH1) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_DWAV,
 			USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH2) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_DWAV,
+			USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH480e) },
 	{ }
 };
 MODULE_DEVICE_TABLE(hid, egalax_devices);
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index b76166a..16a6a02 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -197,6 +197,7 @@
 #define USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH	0x480d
 #define USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH1	0x720c
 #define USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH2	0x72a1
+#define USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH480e	0x480e
 
 #define USB_VENDOR_ID_ELECOM		0x056e
 #define USB_DEVICE_ID_ELECOM_BM084	0x0061

