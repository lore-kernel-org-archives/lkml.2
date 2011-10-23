Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861Ab1JWGeQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 02:34:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40071 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754690Ab1JWGeK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 02:34:10 -0400
X-Mailbox-Line: From gregkh@pistachio.kroah.org Sun Oct 23 08:25:37 2011
Message-Id: <20111023062537.802723325@pistachio.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Sun, 23 Oct 2011 08:24:31 +0200
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: stable-review@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jeremiah Matthey <sprg86@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Jonathan Nieder <jrnieder@gmail.com>
Subject: [03/27] HID: usbhid: Add support for SiGma Micro chip
In-Reply-To: <20111023062833.GA8126@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jeremiah Matthey <sprg86@gmail.com>

commit f5e4282586dc0c9dab8c7d32e6c43aa07f68586b upstream.

Patch to add SiGma Micro-based keyboards (1c4f:0002) to hid-quirks.

These keyboards dont seem to allow the records to be initialized, and hence a
timeout occurs when the usbhid driver attempts to initialize them. The patch
just adds the signature for these keyboards to the hid-quirks list with the
setting HID_QUIRK_NO_INIT_REPORTS. This removes the 5-10 second wait for the
timeout to occur.

Signed-off-by: Jeremiah Matthey <sprg86@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hid/hid-ids.h           |    3 +++
 drivers/hid/usbhid/hid-quirks.c |    1 +
 2 files changed, 4 insertions(+)

--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -568,6 +568,9 @@
 #define USB_DEVICE_ID_SAMSUNG_IR_REMOTE	0x0001
 #define USB_DEVICE_ID_SAMSUNG_WIRELESS_KBD_MOUSE	0x0600
 
+#define USB_VENDOR_ID_SIGMA_MICRO	0x1c4f
+#define USB_DEVICE_ID_SIGMA_MICRO_KEYBOARD	0x0002
+
 #define USB_VENDOR_ID_SKYCABLE			0x1223
 #define	USB_DEVICE_ID_SKYCABLE_WIRELESS_PRESENTER	0x3F07
 
--- a/drivers/hid/usbhid/hid-quirks.c
+++ b/drivers/hid/usbhid/hid-quirks.c
@@ -89,6 +89,7 @@ static const struct hid_blacklist {
 
 	{ USB_VENDOR_ID_CHICONY, USB_DEVICE_ID_CHICONY_MULTI_TOUCH, HID_QUIRK_MULTI_INPUT },
 	{ USB_VENDOR_ID_CHICONY, USB_DEVICE_ID_CHICONY_WIRELESS, HID_QUIRK_MULTI_INPUT },
+	{ USB_VENDOR_ID_SIGMA_MICRO, USB_DEVICE_ID_SIGMA_MICRO_KEYBOARD, HID_QUIRK_NO_INIT_REPORTS },
 	{ 0, 0 }
 };
 


