Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751327Ab0FWJXY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 05:23:24 -0400
Received: from relay01.mx.bawue.net ([193.7.176.67]:42409 "EHLO
	relay01.mx.bawue.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059Ab0FWJXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 05:23:22 -0400
Date: Wed, 23 Jun 2010 11:23:16 +0200
From: Nils Radtke <lkml@Think-Future.de>
To: laurent.pinchart@skynet.be
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
       stable@kernel.org
Subject: [2.6.33.4 PATCH] V4L/uvcvideo: Add support for Suyin Corp. Lenovo
 Webcam
Message-ID: <20100623092316.GA13364@localhost>
Reply-To: Nils Radtke <lkml@Think-Future.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Url: http://www.Think-Future.de
X-Editor: Vi it! http://www.vim.org
X-Bkp: p2mi
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nils Radtke <lkml@Think-Future.de>

This patch adds support for the Suyin Corp. Lenovo Webcam.
lsusb: ID 064e:a102 Suyin Corp. Lenovo Webcam

It is available as built-in webcam i.e. in ACER timeline 1810t 
notebooks.

The note in uvc_driver.c about Logitech cameras applies the same 
to the Suyin web cam: it doesn't announce itself as UVC devices 
but is compliant.

Signed-off-by: Nils Radtke <lkml@Think-Future.de>

---

  Thank you,

                    Nils

 uvc_driver.c |    8 ++++++++
  1 file changed, 8 insertions(+)


Index: linux/drivers/media/video/uvc/uvc_driver.c
===================================================================
--- linux.orig/drivers/media/video/uvc/uvc_driver.c	2010-06-23 10:37:03.000000000 +0200
+++ linux/drivers/media/video/uvc/uvc_driver.c	2010-06-23 10:37:07.000000000 +0200
@@ -2153,6 +2153,14 @@
 	  .bInterfaceProtocol	= 0,
 	  .driver_info		= UVC_QUIRK_PROBE_MINMAX
 				| UVC_QUIRK_IGNORE_SELECTOR_UNIT },
+	/* Suyin Corp. Lenovo Webcam */
+	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
+				| USB_DEVICE_ID_MATCH_INT_INFO,
+	  .idVendor		= 0x064e,
+	  .idProduct		= 0xa102,
+	  .bInterfaceClass	= USB_CLASS_VENDOR_SPEC,
+	  .bInterfaceSubClass	= 1,
+	  .bInterfaceProtocol	= 0 },
 	/* Generic USB Video Class */
 	{ USB_INTERFACE_INFO(USB_CLASS_VIDEO, 1, 0) },
 	{}

