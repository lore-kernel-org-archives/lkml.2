Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755085Ab0EQMOR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 08:14:17 -0400
Received: from relay01.mx.bawue.net ([193.7.176.67]:39524 "EHLO
	relay01.mx.bawue.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755204Ab0EQMOO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 08:14:14 -0400
Date: Mon, 17 May 2010 14:14:11 +0200
From: Nils Radtke <lkml@Think-Future.de>
To: Matthias Urlichs <smurf@smurf.noris.de>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>, stable@kernel.org
Subject: [2.6.34 PATCH] USB: option.c: OLIVETTI OLICARD100 support
Message-ID: <20100517121411.GA21483@localhost>
Reply-To: Nils Radtke <lkml@Think-Future.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
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

I guess the previous patch for .33.4 came to late for inclusion. Am I missing
something else to get the IDs merged into .35 or maybe .34.1?

  Thank you,

                    Nils


drivers/usb/serial/option.c |    6 ++++++
1 file changed, 6 insertions(+)


Index: linux/drivers/usb/serial/option.c
===================================================================
--- linux.orig/drivers/usb/serial/option.c	2010-05-17 14:04:57.000000000 +0200
+++ linux/drivers/usb/serial/option.c	2010-05-17 14:05:00.000000000 +0200
@@ -380,6 +380,10 @@
 
 #define CINTERION_VENDOR_ID			0x0681
 
+/* Olivetti products */
+#define OLIVETTI_VENDOR_ID       0x0b3c
+#define OLIVETTI_PRODUCT_OLICARD100      0xc000
+
 /* some devices interfaces need special handling due to a number of reasons */
 enum option_blacklist_reason {
 		OPTION_BLACKLIST_NONE = 0,
@@ -726,6 +730,8 @@
 	{ USB_DEVICE(PIRELLI_VENDOR_ID, PIRELLI_PRODUCT_1012)},
 
 	{ USB_DEVICE(CINTERION_VENDOR_ID, 0x0047) },
+
+  { USB_DEVICE(OLIVETTI_VENDOR_ID, OLIVETTI_PRODUCT_OLICARD100) },
 	{ } /* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, option_ids);
