Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757422Ab0EKIkt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 04:40:49 -0400
Received: from relay01.mx.bawue.net ([193.7.176.67]:57219 "EHLO
	relay01.mx.bawue.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752373Ab0EKIkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 04:40:45 -0400
Date: Tue, 11 May 2010 10:40:38 +0200
From: Nils Radtke <lkml@Think-Future.de>
To: linux-kernel@vger.kernel.org
Cc: peter.hicks@poggs.co.uk
Subject: 2.6.34-rc7 option.c: support for olicard100 + zte636-0x0037
Message-ID: <20100511084038.GB9838@localhost>
Reply-To: Nils Radtke <lkml@Think-Future.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273442132.12665.28.camel@angel>
X-Url: http://www.Think-Future.de
X-Editor: Vi it! http://www.vim.org
X-Bkp: p2mi
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  Hi,

  using the attached patch to get the olicard100 umts-stick working. W/o success.
  No change in behaviour when trying to dial up.

  I noticed that I missed a device, no 4, in the blacklist. Re-testing soon.

  Cheers,

  Nils


Index: linux-2.6.34-rc7/drivers/usb/serial/option.c
===================================================================
--- linux-2.6.34-rc7.orig/drivers/usb/serial/option.c	2010-05-10 20:56:37.000000000 +0200
+++ linux-2.6.34-rc7/drivers/usb/serial/option.c	2010-05-10 21:00:59.000000000 +0200
@@ -302,6 +302,7 @@
 #define ZTE_PRODUCT_MF622			0x0001
 #define ZTE_PRODUCT_MF628			0x0015
 #define ZTE_PRODUCT_MF626			0x0031
+#define ZTE_PRODUCT_MF636			0x0037
 #define ZTE_PRODUCT_CDMA_TECH			0xfffe
 #define ZTE_PRODUCT_AC8710			0xfff1
 #define ZTE_PRODUCT_AC2726			0xfff5
@@ -378,6 +379,10 @@
 #define HAIER_VENDOR_ID				0x201e
 #define HAIER_PRODUCT_CE100			0x2009
 
+/* Olivetti products */
+#define OLIVETTI_VENDOR_ID				0x0b3c
+#define OLIVETTI_PRODUCT_OLICARD100			0xc000
+
 #define CINTERION_VENDOR_ID			0x0681
 
 /* some devices interfaces need special handling due to a number of reasons */
@@ -400,6 +405,13 @@
 	.reason = OPTION_BLACKLIST_SENDSETUP
 };
 
+static const u8 olivetti_olicard100_no_sendsetup[] = { 1, 3 };
+static const struct option_blacklist_info olivetti_olicard100_blacklist = {
+	.infolen = ARRAY_SIZE(olivetti_olicard100_no_sendsetup),
+	.ifaceinfo = olivetti_olicard100_no_sendsetup,
+	.reason = OPTION_BLACKLIST_SENDSETUP
+};
+
 static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_COLT) },
 	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_RICOLA) },
@@ -617,7 +629,7 @@
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, ZTE_PRODUCT_MF626, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0032, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0033, 0xff, 0xff, 0xff) },
-	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0037, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, ZTE_PRODUCT_MF636, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0039, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0042, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0043, 0xff, 0xff, 0xff) },
@@ -707,6 +719,9 @@
   	  .driver_info = (kernel_ulong_t)&four_g_w14_blacklist
   	},
 	{ USB_DEVICE(HAIER_VENDOR_ID, HAIER_PRODUCT_CE100) },
+	{ USB_DEVICE(OLIVETTI_VENDOR_ID, OLIVETTI_PRODUCT_OLICARD100),
+  	  .driver_info = (kernel_ulong_t)&olivetti_olicard100_blacklist
+    },
 	/* Pirelli  */
 	{ USB_DEVICE(PIRELLI_VENDOR_ID, PIRELLI_PRODUCT_C100_1)},
 	{ USB_DEVICE(PIRELLI_VENDOR_ID, PIRELLI_PRODUCT_C100_2)},

