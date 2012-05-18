Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030819Ab2ERCxo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 22:53:44 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:40583 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030736Ab2ERCwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 22:52:54 -0400
Message-Id: <20120518023300.468034885@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 18 May 2012 03:33:39 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Dan Williams <dcbw@redhat.com>,
        Oliver Neukum <oliver@neukum.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 45/53] cdc_ether: add Novatel USB551L device IDs for FLAG_WWAN
In-Reply-To: <20120518023254.339945758@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Williams <dcbw@redhat.com>

commit 4e6304b8420aba5311ba21fd68dab2924ae4d91a upstream.

Needs to be tagged with FLAG_WWAN, which since it has generic
descriptors, won't happen if we don't override the generic
driver info.

Cc: Oliver Neukum <oliver@neukum.org>
Signed-off-by: Dan Williams <dcbw@redhat.com>
Acked-by: Oliver Neukum <oliver@neukum.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/usb/cdc_ether.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/net/usb/cdc_ether.c b/drivers/net/usb/cdc_ether.c
index 00880ed..425e201 100644
--- a/drivers/net/usb/cdc_ether.c
+++ b/drivers/net/usb/cdc_ether.c
@@ -485,6 +485,7 @@ static const struct driver_info wwan_info = {
 /*-------------------------------------------------------------------------*/
 
 #define HUAWEI_VENDOR_ID	0x12D1
+#define NOVATEL_VENDOR_ID	0x1410
 
 static const struct usb_device_id	products [] = {
 /*
@@ -602,6 +603,21 @@ static const struct usb_device_id	products [] = {
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
-- 
1.7.10



