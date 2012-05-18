Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946365Ab2ERXEP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 19:04:15 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:53122 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946376Ab2ERXEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 19:04:07 -0400
Message-Id: <20120518211602.113717596@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 18 May 2012 14:16:28 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Oliver Neukum <oliver@neukum.org>,
        Dan Williams <dcbw@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 29/54] cdc_ether: add Novatel USB551L device IDs for FLAG_WWAN
In-Reply-To: <20120518212656.GA4992@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Williams <dcbw@redhat.com>

commit 4e6304b8420aba5311ba21fd68dab2924ae4d91a upstream.

Needs to be tagged with FLAG_WWAN, which since it has generic
descriptors, won't happen if we don't override the generic
driver info.

Cc: Oliver Neukum <oliver@neukum.org>
Cc: stable@vger.kernel.org
Signed-off-by: Dan Williams <dcbw@redhat.com>
Acked-by: Oliver Neukum <oliver@neukum.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/usb/cdc_ether.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/drivers/net/usb/cdc_ether.c
+++ b/drivers/net/usb/cdc_ether.c
@@ -482,6 +482,7 @@ static const struct driver_info wwan_inf
 /*-------------------------------------------------------------------------*/
 
 #define HUAWEI_VENDOR_ID	0x12D1
+#define NOVATEL_VENDOR_ID	0x1410
 
 static const struct usb_device_id	products [] = {
 /*
@@ -599,6 +600,21 @@ static const struct usb_device_id	produc
  * because of bugs/quirks in a given product (like Zaurus, above).
  */
 {
+	/* Novatel USB551L */
+	/* This match must come *before* the generic CDC-ETHER match so that
+	 * we get FLAG_WWAN set on the device, since it's descriptors are
+	 * generic CDC-ETHER.
+	 */
+	.match_flags    =   USB_DEVICE_ID_MATCH_VENDOR
+		 | USB_DEVICE_ID_MATCH_PRODUCT
+		 | USB_DEVICE_ID_MATCH_INT_INFO,
+	.idVendor               = NOVATEL_VENDOR_ID,
+	.idProduct		= 0xB001,
+	.bInterfaceClass	= USB_CLASS_COMM,
+	.bInterfaceSubClass	= USB_CDC_SUBCLASS_ETHERNET,
+	.bInterfaceProtocol	= USB_CDC_PROTO_NONE,
+	.driver_info = (unsigned long)&wwan_info,
+}, {
 	USB_INTERFACE_INFO(USB_CLASS_COMM, USB_CDC_SUBCLASS_ETHERNET,
 			USB_CDC_PROTO_NONE),
 	.driver_info = (unsigned long) &cdc_info,


