Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932852Ab1KCBe2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 21:34:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50479 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932789Ab1KCBeZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:34:25 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  2 15:14:54 2011
Message-Id: <20111102221454.415089074@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 02 Nov 2011 15:14:13 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jeremiah Matthey <sprg86@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Jonathan Nieder <jrnieder@gmail.com>
Subject: [047/107] HID: usbhid: Add support for SiGma Micro chip
In-Reply-To: <20111102221600.GA26650@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

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
@@ -389,6 +389,9 @@
 #define USB_VENDOR_ID_SAMSUNG		0x0419
 #define USB_DEVICE_ID_SAMSUNG_IR_REMOTE	0x0001
 
+#define USB_VENDOR_ID_SIGMA_MICRO	0x1c4f
+#define USB_DEVICE_ID_SIGMA_MICRO_KEYBOARD	0x0002
+
 #define USB_VENDOR_ID_SONY			0x054c
 #define USB_DEVICE_ID_SONY_VAIO_VGX_MOUSE	0x024b
 #define USB_DEVICE_ID_SONY_PS3_CONTROLLER	0x0268
--- a/drivers/hid/usbhid/hid-quirks.c
+++ b/drivers/hid/usbhid/hid-quirks.c
@@ -65,6 +65,7 @@ static const struct hid_blacklist {
 	{ USB_VENDOR_ID_WISEGROUP_LTD, USB_DEVICE_ID_SMARTJOY_DUAL_PLUS, HID_QUIRK_NOGET | HID_QUIRK_MULTI_INPUT },
 	{ USB_VENDOR_ID_WISEGROUP_LTD2, USB_DEVICE_ID_SMARTJOY_DUAL_PLUS, HID_QUIRK_NOGET | HID_QUIRK_MULTI_INPUT },
 
+	{ USB_VENDOR_ID_SIGMA_MICRO, USB_DEVICE_ID_SIGMA_MICRO_KEYBOARD, HID_QUIRK_NO_INIT_REPORTS },
 	{ 0, 0 }
 };
 


