Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162000Ab1FAJJk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 05:09:40 -0400
Received: from cantor.suse.de ([195.135.220.2]:43877 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161922Ab1FAIP7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:15:59 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:04:17 2011
Message-Id: <20110601080416.868773645@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:00:44 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Marius B. Kotsbak" <marius@kotsbak.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [108/146] Bind only modem AT command endpoint to option module.
In-Reply-To: <20110601080606.GA522@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: "Marius B. Kotsbak" <marius@kotsbak.com>

commit 15b2f3204a5c878c32939094775fb7349f707263 upstream.

Network interface is handled by upcoming gt_b3730 module.

Removed "GT-B3710" from comment, it is another modem with another USB ID.

Signed-off-by: Marius B. Kotsbak <marius@kotsbak.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/option.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -972,7 +972,7 @@ static const struct usb_device_id option
 	{ USB_DEVICE(OLIVETTI_VENDOR_ID, OLIVETTI_PRODUCT_OLICARD100) },
 	{ USB_DEVICE(CELOT_VENDOR_ID, CELOT_PRODUCT_CT680M) }, /* CT-650 CDMA 450 1xEVDO modem */
 	{ USB_DEVICE(ONDA_VENDOR_ID, ONDA_MT825UP) }, /* ONDA MT825UP modem */
-	{ USB_DEVICE_AND_INTERFACE_INFO(SAMSUNG_VENDOR_ID, SAMSUNG_PRODUCT_GT_B3730, USB_CLASS_CDC_DATA, 0x00, 0x00) }, /* Samsung GT-B3730/GT-B3710 LTE USB modem.*/
+	{ USB_DEVICE_AND_INTERFACE_INFO(SAMSUNG_VENDOR_ID, SAMSUNG_PRODUCT_GT_B3730, USB_CLASS_CDC_DATA, 0x00, 0x00) }, /* Samsung GT-B3730 LTE USB modem.*/
 	{ } /* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, option_ids);
@@ -1109,6 +1109,12 @@ static int option_probe(struct usb_seria
 		serial->interface->cur_altsetting->desc.bInterfaceNumber == 1)
 		return -ENODEV;
 
+	/* Don't bind network interface on Samsung GT-B3730, it is handled by a separate module */
+	if (serial->dev->descriptor.idVendor == SAMSUNG_VENDOR_ID &&
+		serial->dev->descriptor.idProduct == SAMSUNG_PRODUCT_GT_B3730 &&
+		serial->interface->cur_altsetting->desc.bInterfaceClass != USB_CLASS_CDC_DATA)
+		return -ENODEV;
+
 	data = serial->private = kzalloc(sizeof(struct usb_wwan_intf_private), GFP_KERNEL);
 
 	if (!data)


