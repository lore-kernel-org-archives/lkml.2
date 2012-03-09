Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030753Ab2CIUVh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 15:21:37 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:63959 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030692Ab2CITro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 14:47:44 -0500
Message-Id: <20120309190205.648252739@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 09 Mar 2012 11:02:43 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alan Stern <stern@rowland.harvard.edu>,
        okias <d.okias@gmail.com>, Jiri Kosina <jkosina@suse.cz>
Subject: [ 41/95] HID: usbhid: Add NOGET quirk for the AIREN Slim+ keyboard
In-Reply-To: <20120309194424.GA2134@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit 37891abc8464637964a26ae4b61d307fef831f80 upstream.

This patch (as1531) adds a NOGET quirk for the Slim+ keyboard marketed
by AIREN.  This keyboard seems to have a lot of bugs; NOGET works
around only one of them.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-by: okias <d.okias@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hid-ids.h           |    3 +++
 drivers/hid/usbhid/hid-quirks.c |    1 +
 2 files changed, 4 insertions(+)

--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -59,6 +59,9 @@
 #define USB_VENDOR_ID_AIRCABLE		0x16CA
 #define USB_DEVICE_ID_AIRCABLE1		0x1502
 
+#define USB_VENDOR_ID_AIREN		0x1a2c
+#define USB_DEVICE_ID_AIREN_SLIMPLUS	0x0002
+
 #define USB_VENDOR_ID_ALCOR		0x058f
 #define USB_DEVICE_ID_ALCOR_USBRS232	0x9720
 
--- a/drivers/hid/usbhid/hid-quirks.c
+++ b/drivers/hid/usbhid/hid-quirks.c
@@ -53,6 +53,7 @@ static const struct hid_blacklist {
 	{ USB_VENDOR_ID_PLAYDOTCOM, USB_DEVICE_ID_PLAYDOTCOM_EMS_USBII, HID_QUIRK_MULTI_INPUT },
 	{ USB_VENDOR_ID_TOUCHPACK, USB_DEVICE_ID_TOUCHPACK_RTS, HID_QUIRK_MULTI_INPUT },
 
+	{ USB_VENDOR_ID_AIREN, USB_DEVICE_ID_AIREN_SLIMPLUS, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_ATEN, USB_DEVICE_ID_ATEN_UC100KM, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_ATEN, USB_DEVICE_ID_ATEN_CS124U, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_ATEN, USB_DEVICE_ID_ATEN_2PORTKVM, HID_QUIRK_NOGET },


