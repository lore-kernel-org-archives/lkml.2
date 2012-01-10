Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933670Ab2AJX0p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 18:26:45 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52121 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933614Ab2AJW6W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 17:58:22 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan 10 13:46:21 2012
Message-Id: <20120110214620.922048451@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 10 Jan 2012 13:45:44 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Janne Snabb <snabb@epipe.com>
Subject: [31/40] usb: option: add ZD Incorporated HSPA modem
In-Reply-To: <20120110214630.GA14384@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Janne Snabb <snabb@epipe.com>

commit 3c8c9316710b83e906e425024153bf0929887b59 upstream.

Add support for Chinese Noname HSPA USB modem which is apparently
manufactured by a company called ZD Incorporated (based on texts in the
Windows drivers).

This product is available at least from Dealextreme (SKU 80032) and
possibly in India with name Olive V-MW250. It is based on Qualcomm
MSM6280 chip.

I needed to also add "options usb-storage quirks=0685:7000:i" in modprobe
configuration because udevd or the kernel keeps poking the embedded
fake-cd-rom which fails and causes the device to reset. There might be
a better way to accomplish the same. usb_modeswitch is not needed with
this device.

Signed-off-by: Janne Snabb <snabb@epipe.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/option.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -476,6 +476,10 @@ static void option_instat_callback(struc
 #define VIETTEL_VENDOR_ID			0x2262
 #define VIETTEL_PRODUCT_VT1000			0x0002
 
+/* ZD Incorporated */
+#define ZD_VENDOR_ID				0x0685
+#define ZD_PRODUCT_7000				0x7000
+
 /* some devices interfaces need special handling due to a number of reasons */
 enum option_blacklist_reason {
 		OPTION_BLACKLIST_NONE = 0,
@@ -1178,6 +1182,7 @@ static const struct usb_device_id option
 	{ USB_DEVICE(YUGA_VENDOR_ID, YUGA_PRODUCT_CLU528) },
 	{ USB_DEVICE(YUGA_VENDOR_ID, YUGA_PRODUCT_CLU526) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(VIETTEL_VENDOR_ID, VIETTEL_PRODUCT_VT1000, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZD_VENDOR_ID, ZD_PRODUCT_7000, 0xff, 0xff, 0xff) },
 	{ } /* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, option_ids);


