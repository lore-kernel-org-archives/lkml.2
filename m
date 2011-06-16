Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904Ab1FPHBS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:01:18 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:57679 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755825Ab1FPHBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:01:07 -0400
X-Sasl-enc: E77eggOYo41lLbYSTkvqODDKzR90aD90LmZxkVQ06IYv 1308207666
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:02:34 2011
Message-Id: <20110616000234.300133550@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 17:00:17 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Torsten Hilbrich <torsten.hilbrich@secunet.com>
Subject: [54/89] USB: option Add blacklist for ZTE K3765-Z (19d2:2002)
In-Reply-To: <20110616000258.GA14529@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Torsten Hilbrich <torsten.hilbrich@secunet.com>

commit 7e8e62e4a5d26e4cb45f25dddd093837d75616c2 upstream.

The funtion option_send_status times out when sending USB messages
to the interfaces 0, 1, and 2 of this UMTS stick. This results in a
5s timeout in the function causing other tty operations to feel very
sluggish.

This patch adds a blacklist entry for these 3 interfaces on the ZTE
K3765-Z device.

I was also able to reproduce the problem with v2.6.38 and v2.6.39.

This is very similar to a problem fixed in

commit 7a89e4cb9cdaba92f5fbc509945cf4e3c48db4e2
Author: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Date:   Wed Mar 9 09:19:48 2011 +0000

    USB: serial: option: Apply OPTION_BLACKLIST_SENDSETUP also for ZTE MF626

Signed-off-by: Torsten Hilbrich <torsten.hilbrich@secunet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/option.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -443,6 +443,13 @@ static const struct option_blacklist_inf
 	.reason = OPTION_BLACKLIST_SENDSETUP
 };
 
+static const u8 zte_k3765_z_no_sendsetup[] = { 0, 1, 2 };
+static const struct option_blacklist_info zte_k3765_z_blacklist = {
+	.infolen = ARRAY_SIZE(zte_k3765_z_no_sendsetup),
+	.ifaceinfo = zte_k3765_z_no_sendsetup,
+	.reason = OPTION_BLACKLIST_SENDSETUP
+};
+
 static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_COLT) },
 	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_RICOLA) },
@@ -927,7 +934,8 @@ static const struct usb_device_id option
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0073, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0130, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0141, 0xff, 0xff, 0xff) },
-	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x2002, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x2002, 0xff,
+	  0xff, 0xff), .driver_info = (kernel_ulong_t)&zte_k3765_z_blacklist },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x2003, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, ZTE_PRODUCT_CDMA_TECH, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, ZTE_PRODUCT_AC8710, 0xff, 0xff, 0xff) },


