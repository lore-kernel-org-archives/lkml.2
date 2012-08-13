Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720Ab2HMUbd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 16:31:33 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:51310 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754725Ab2HMUYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 16:24:25 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Austin Hendrix <ahendrix@willowgarage.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [ 61/82] HID: multitouch: add support for Novatek touchscreen
Date: Mon, 13 Aug 2012 13:19:37 -0700
Message-Id: <20120813201751.808648844@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120813201746.448504360@linuxfoundation.org>
References: <20120813201746.448504360@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Austin Hendrix <ahendrix@willowgarage.com>

commit 4db703ead4535792ea54dba7275fdd1527848e74 upstream.

Add support for a Novatek touchscreen panel as a generic HID multitouch
panel.

Signed-off-by: Austin Hendrix <ahendrix@willowgarage.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hid-ids.h        |    3 +++
 drivers/hid/hid-multitouch.c |    5 +++++
 2 files changed, 8 insertions(+)

--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -573,6 +573,9 @@
 #define USB_VENDOR_ID_NINTENDO		0x057e
 #define USB_DEVICE_ID_NINTENDO_WIIMOTE	0x0306
 
+#define USB_VENDOR_ID_NOVATEK		0x0603
+#define USB_DEVICE_ID_NOVATEK_PCT	0x0600
+
 #define USB_VENDOR_ID_NTRIG		0x1b96
 #define USB_DEVICE_ID_NTRIG_TOUCH_SCREEN   0x0001
 #define USB_DEVICE_ID_NTRIG_TOUCH_SCREEN_1   0x0003
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -962,6 +962,11 @@ static const struct hid_device_id mt_dev
 		MT_USB_DEVICE(USB_VENDOR_ID_PANASONIC,
 			USB_DEVICE_ID_PANABOARD_UBT880) },
 
+	/* Novatek Panel */
+	{ .driver_data = MT_CLS_DEFAULT,
+		HID_USB_DEVICE(USB_VENDOR_ID_NOVATEK,
+			USB_DEVICE_ID_NOVATEK_PCT) },
+
 	/* PenMount panels */
 	{ .driver_data = MT_CLS_CONFIDENCE,
 		MT_USB_DEVICE(USB_VENDOR_ID_PENMOUNT,


