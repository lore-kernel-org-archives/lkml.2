Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836Ab0EOSmw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 14:42:52 -0400
Received: from relay01.mx.bawue.net ([193.7.176.67]:60931 "EHLO
	relay01.mx.bawue.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792Ab0EOSmu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 14:42:50 -0400
Date: Sat, 15 May 2010 20:42:40 +0200
From: Nils Radtke <lkml@Think-Future.de>
To: Matthias Urlichs <smurf@smurf.noris.de>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>, stable@kernel.org
Subject: [stable-2.6.33.4 PATCH] USB: option.c: OLIVETTI OLICARD100 support
Message-ID: <20100515184240.GF18740@localhost>
Reply-To: Nils Radtke <lkml@Think-Future.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-Url: http://www.Think-Future.de
X-Editor: Vi it! http://www.vim.org
X-Bkp: p2mi
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nils Radtke <lkml@Think-Future.de>

This patch adds support for an olivetti olicard100 HЅDPA usb-stick.

This device is a zeroCD one with ID 0b3c:c700 that needs switching via 
eject or usb-modeswitch with 
MessageContent="5553424312345678000000000000061b000000030000000000000000000000".
After switching it has ID 0b3c:c000 and provides 5 serial ports ttyUSB[0-4].
Port 0 (modem) and 4 are interrupt ports.

Signed-off-by: Nils Radtke <lkml@Think-Future.de>

---

 drivers/usb/serial/option.c |    5 +++++
 1 file changed, 5 insertions(+)


Index: linux/drivers/usb/serial/option.c
===================================================================
--- linux.orig/drivers/usb/serial/option.c	2010-05-14 13:01:08.000000000 +0200
+++ linux/drivers/usb/serial/option.c	2010-05-14 13:03:51.000000000 +0200
@@ -346,6 +346,10 @@
 #define HAIER_VENDOR_ID				0x201e
 #define HAIER_PRODUCT_CE100			0x2009
 
+/* Olivetti products */
+#define OLIVETTI_VENDOR_ID				0x0b3c
+#define OLIVETTI_PRODUCT_OLICARD100			0xc000
+
 static struct usb_device_id option_ids[] = {
 	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_COLT) },
 	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_RICOLA) },
@@ -649,6 +653,7 @@
 	{ USB_DEVICE(TLAYTECH_VENDOR_ID, TLAYTECH_PRODUCT_TEU800) },
 	{ USB_DEVICE(FOUR_G_SYSTEMS_VENDOR_ID, FOUR_G_SYSTEMS_PRODUCT_W14) },
 	{ USB_DEVICE(HAIER_VENDOR_ID, HAIER_PRODUCT_CE100) },
+	{ USB_DEVICE(OLIVETTI_VENDOR_ID, OLIVETTI_PRODUCT_OLICARD100) },
 	{ } /* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, option_ids);

