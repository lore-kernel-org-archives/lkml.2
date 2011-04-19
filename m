Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755014Ab1DSURl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 16:17:41 -0400
Received: from kroah.org ([198.145.64.141]:35686 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754947Ab1DSURg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 16:17:36 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 19 13:10:49 2011
Message-Id: <20110419201048.965980032@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 19 Apr 2011 13:09:03 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Marius B. Kotsbak" <marius@kotsbak.com>
Subject: [54/70] USB: option: Added support for Samsung GT-B3730/GT-B3710 LTE USB modem.
In-Reply-To: <20110419201501.GA8865@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Marius B. Kotsbak <marius@kotsbak.com>

commit 80f9df3e0093ad9f1eeefd2ff7fd27daaa518d25 upstream.

Bind only modem AT command endpoint to option.

Signed-off-by: Marius B. Kotsbak <marius@kotsbak.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/option.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -407,6 +407,10 @@ static void option_instat_callback(struc
 /* ONDA MT825UP HSDPA 14.2 modem */
 #define ONDA_MT825UP         0x000b
 
+/* Samsung products */
+#define SAMSUNG_VENDOR_ID                       0x04e8
+#define SAMSUNG_PRODUCT_GT_B3730                0x6889
+
 /* some devices interfaces need special handling due to a number of reasons */
 enum option_blacklist_reason {
 		OPTION_BLACKLIST_NONE = 0,
@@ -968,6 +972,7 @@ static const struct usb_device_id option
 	{ USB_DEVICE(OLIVETTI_VENDOR_ID, OLIVETTI_PRODUCT_OLICARD100) },
 	{ USB_DEVICE(CELOT_VENDOR_ID, CELOT_PRODUCT_CT680M) }, /* CT-650 CDMA 450 1xEVDO modem */
 	{ USB_DEVICE(ONDA_VENDOR_ID, ONDA_MT825UP) }, /* ONDA MT825UP modem */
+	{ USB_DEVICE_AND_INTERFACE_INFO(SAMSUNG_VENDOR_ID, SAMSUNG_PRODUCT_GT_B3730, USB_CLASS_CDC_DATA, 0x00, 0x00) }, /* Samsung GT-B3730/GT-B3710 LTE USB modem.*/
 	{ } /* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, option_ids);


