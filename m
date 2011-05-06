Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754910Ab1EFARQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:17:16 -0400
Received: from kroah.org ([198.145.64.141]:32888 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754762Ab1EFAN3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:13:29 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:12:09 2011
Message-Id: <20110506001209.481953360@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:10:54 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dan Williams <dcbw@redhat.com>, Oliver Neukum <oneukum@suse.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: [patch 22/38] usbnet: add support for some Huawei modems with cdc-ether ports
In-Reply-To: <20110506001225.GA10547@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dan Williams <dcbw@redhat.com>

commit b3c914aa84f4e4bbb3efc8f41c359d96e5e932d2 upstream.

Some newer Huawei devices (T-Mobile Rocket, others) have cdc-ether
compatible ports, so recognize and expose them.

Signed-off-by: Dan Williams <dcbw@redhat.com>
Acked-by: Oliver Neukum <oneukum@suse.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/usb/cdc_ether.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/drivers/net/usb/cdc_ether.c
+++ b/drivers/net/usb/cdc_ether.c
@@ -458,7 +458,7 @@ static const struct driver_info	cdc_info
 	.manage_power =	cdc_manage_power,
 };
 
-static const struct driver_info mbm_info = {
+static const struct driver_info wwan_info = {
 	.description =	"Mobile Broadband Network Device",
 	.flags =	FLAG_WWAN,
 	.bind = 	cdc_bind,
@@ -469,6 +469,7 @@ static const struct driver_info mbm_info
 
 /*-------------------------------------------------------------------------*/
 
+#define HUAWEI_VENDOR_ID	0x12D1
 
 static const struct usb_device_id	products [] = {
 /*
@@ -578,8 +579,17 @@ static const struct usb_device_id	produc
 }, {
 	USB_INTERFACE_INFO(USB_CLASS_COMM, USB_CDC_SUBCLASS_MDLM,
 			USB_CDC_PROTO_NONE),
-	.driver_info = (unsigned long)&mbm_info,
+	.driver_info = (unsigned long)&wwan_info,
 
+}, {
+	/* Various Huawei modems with a network port like the UMG1831 */
+	.match_flags    =   USB_DEVICE_ID_MATCH_VENDOR
+		 | USB_DEVICE_ID_MATCH_INT_INFO,
+	.idVendor               = HUAWEI_VENDOR_ID,
+	.bInterfaceClass	= USB_CLASS_COMM,
+	.bInterfaceSubClass	= USB_CDC_SUBCLASS_ETHERNET,
+	.bInterfaceProtocol	= 255,
+	.driver_info = (unsigned long)&wwan_info,
 },
 	{ },		// END
 };


