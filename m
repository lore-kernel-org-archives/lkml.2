Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031583Ab2CITwI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 14:52:08 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64616 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031495Ab2CITwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 14:52:02 -0500
Message-Id: <20120309190216.667545323@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 09 Mar 2012 11:02:35 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Scott Talbert <talbert@techie.net>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 21/68] Move Logitech Harmony 900 from cdc_ether to zaurus
In-Reply-To: <20120309194409.GA2069@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Scott Talbert <talbert@techie.net>

commit ee932bf9acb2e2c6a309e808000f24856330e3f9 upstream.

In the current kernel implementation, the Logitech Harmony 900 remote
control is matched to the cdc_ether driver through the generic
USB_CDC_SUBCLASS_MDLM entry.  However, this device appears to be of the
pseudo-MDLM (Belcarra) type, rather than the standard one.  This patch
blacklists the Harmony 900 from the cdc_ether driver and whitelists it for
the pseudo-MDLM driver in zaurus.

Signed-off-by: Scott Talbert <talbert@techie.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/usb/cdc_ether.c |    7 +++++++
 drivers/net/usb/zaurus.c    |    7 +++++++
 2 files changed, 14 insertions(+)

--- a/drivers/net/usb/cdc_ether.c
+++ b/drivers/net/usb/cdc_ether.c
@@ -570,6 +570,13 @@ static const struct usb_device_id	produc
 	.driver_info = (unsigned long)&wwan_info,
 },
 
+/* Logitech Harmony 900 - uses the pseudo-MDLM (BLAN) driver */
+{
+	USB_DEVICE_AND_INTERFACE_INFO(0x046d, 0xc11f, USB_CLASS_COMM,
+			USB_CDC_SUBCLASS_MDLM, USB_CDC_PROTO_NONE),
+	.driver_info		= 0,
+},
+
 /*
  * WHITELIST!!!
  *
--- a/drivers/net/usb/zaurus.c
+++ b/drivers/net/usb/zaurus.c
@@ -349,6 +349,13 @@ static const struct usb_device_id	produc
 	ZAURUS_MASTER_INTERFACE,
 	.driver_info = OLYMPUS_MXL_INFO,
 },
+
+/* Logitech Harmony 900 - uses the pseudo-MDLM (BLAN) driver */
+{
+	USB_DEVICE_AND_INTERFACE_INFO(0x046d, 0xc11f, USB_CLASS_COMM,
+			USB_CDC_SUBCLASS_MDLM, USB_CDC_PROTO_NONE),
+	.driver_info = (unsigned long) &bogus_mdlm_info,
+},
 	{ },		// END
 };
 MODULE_DEVICE_TABLE(usb, products);


