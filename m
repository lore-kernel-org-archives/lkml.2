Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591Ab0EIVzl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 17:55:41 -0400
Received: from b.painless.aaisp.net.uk ([81.187.30.52]:45700 "EHLO
	b.painless.aaisp.net.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460Ab0EIVzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 17:55:40 -0400
Subject: RE: option.ko: ZTE MF636 support
From: Peter Hicks <peter.hicks@poggs.co.uk>
To: Nils Radtke <lkml@Think-Future.de>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20100509142209.GA9319@localhost>
References: <20100509142209.GA9319@localhost>
Content-Type: multipart/mixed; boundary="=-qwK4Bvm+bTd1AxUaFM73"
Date: Sun, 09 May 2010 22:55:32 +0100
Message-ID: <1273442132.12665.28.camel@angel>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-qwK4Bvm+bTd1AxUaFM73
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Hi Nils

On Sun, 2010-05-09 at 16:22 +0200, Nils Radtke wrote:

> Similar symptoms are the long delay on opening of devices 0 and 2.
> /dev/ttyUSB0: status port
> /dev/ttyUSB2: modem port (not working)

Does "echo > /dev/ttyUSB0" return immediately, and "echo > /dev/ttyUSB2"
take around 15 seconds to return?

> What has been your solution to get the ZTE working?

I've blacklisted devices 0, 1 and 2 using the attached patch, taken
against 2.6.34-rc6.  It should be quite straightforward to modify this
for your device.

Without the patch, I'm able to use wvdial against ttyUSB3 to dial up,
but the device is unresponsive to anything apart from a PPP LCP
disconnect.

Regards,


Peter


--=-qwK4Bvm+bTd1AxUaFM73
Content-Disposition: attachment; filename="zte-mf636-blacklist.patch"
Content-Type: text/x-patch; name="zte-mf636-blacklist.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

--- drivers/usb/serial/option.orig.c	2010-05-09 22:46:41.761498988 +0100
+++ drivers/usb/serial/option.c	2010-05-09 22:44:49.911498986 +0100
@@ -393,6 +393,13 @@
 	.reason = OPTION_BLACKLIST_SENDSETUP
 };
 
+static const u8 zte_mf636_no_sendsetup[] = { 0, 1, 2 };
+static const struct option_blacklist_info zte_mf636_blacklist = {
+	.infolen = ARRAY_SIZE(zte_mf636_no_sendsetup),
+	.ifaceinfo = zte_mf636_no_sendsetup,
+	.reason = OPTION_BLACKLIST_SENDSETUP
+};
+
 static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_COLT) },
 	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_RICOLA) },
@@ -609,7 +616,9 @@
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0030, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, ZTE_PRODUCT_MF626, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0032, 0xff, 0xff, 0xff) },
-	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0033, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0033, 0xff, 0xff, 0xff),
+  	  .driver_info = (kernel_ulong_t)&zte_mf636_blacklist
+  	},
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0037, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0039, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0042, 0xff, 0xff, 0xff) },

--=-qwK4Bvm+bTd1AxUaFM73--

