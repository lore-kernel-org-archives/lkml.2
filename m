Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819Ab2D3BmE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 21:42:04 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:53612 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754369Ab2D3BmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 21:42:00 -0400
X-Authenticated: #4445348
X-Provags-ID: V01U2FsdGVkX1+wLeEpfUOwFShnWMJmW42OBN9krTzB0VrRksV+lu
	Z+WKIeSaXUM6hH
From: Michael =?ISO-8859-1?Q?Gr=FCtzner?= <mgruetzn@gmx.de>
To: marcel@holtmann.org
Cc: gustavo@padovan.org, johan.hedberg@gmail.com,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] bluetooth: Add support for Foxconn/Hon Hai AR5BBU22 0489:E03C
Date: Mon, 30 Apr 2012 03:41:45 +0200
Message-ID: <1844233.LmPXZadnGE@dagobah>
User-Agent: KMail/4.8.2 (Linux/3.3.1-18.1-MG; KDE/4.8.2; i686; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Gruetzner <mgruetzn@gmx.de>

Add Foxconn/Hon Hai AR5BBU22 Bluetooth Module( 0x489:0xE03C) to 
the blacklist of btusb module and add it to the ath3k module to properly load 
the firmware in Kernel 3.3.4
The device is integrated in  e.g. some  Acer Aspire 7750G.
 
Signed-off-by: Michael Gruetzner <mgruetzn@gmx.de>
---
diff -uprN -X linux-3.3.4-vanilla/Documentation/dontdiff linux-3.3.4-vanilla/drivers/bluetooth/ath3k.c linux-3.3.4/drivers/bluetooth/ath3k.c
--- linux-3.3.4-vanilla/drivers/bluetooth/ath3k.c	2012-04-27 19:17:35.000000000 +0200
+++ linux-3.3.4/drivers/bluetooth/ath3k.c	2012-04-30 01:29:47.081838667 +0200
@@ -79,6 +79,9 @@ static struct usb_device_id ath3k_table[
 	/* Atheros AR5BBU12 with sflash firmware */
 	{ USB_DEVICE(0x0489, 0xE02C) },
 
+	/* Atheros AR5BBU22 with sflash firmware */
+	{ USB_DEVICE(0x0489, 0xE03C) },
+
 	{ }	/* Terminating entry */
 };
 
@@ -95,6 +98,9 @@ static struct usb_device_id ath3k_blist_
 	{ USB_DEVICE(0x13d3, 0x3375), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x04ca, 0x3005), .driver_info = BTUSB_ATH3012 },
 
+	/* Atheros AR5BBU22 with sflash firmware */
+	{ USB_DEVICE(0x0489, 0xE03C), .driver_info = BTUSB_ATH3012 },
+
 	{ }	/* Terminating entry */
 };
 
diff -uprN -X linux-3.3.4-vanilla/Documentation/dontdiff linux-3.3.4-vanilla/drivers/bluetooth/btusb.c linux-3.3.4/drivers/bluetooth/btusb.c
--- linux-3.3.4-vanilla/drivers/bluetooth/btusb.c	2012-04-27 19:17:35.000000000 +0200
+++ linux-3.3.4/drivers/bluetooth/btusb.c	2012-04-30 01:31:49.302182281 +0200
@@ -135,6 +135,9 @@ static struct usb_device_id blacklist_ta
 	/* Atheros AR5BBU12 with sflash firmware */
 	{ USB_DEVICE(0x0489, 0xe02c), .driver_info = BTUSB_IGNORE },
 
+	/* Atheros AR5BBU22 with sflash firmware */
+	{ USB_DEVICE(0x0489, 0xe03c), .driver_info = BTUSB_ATH3012 },
+
 	/* Broadcom BCM2035 */
 	{ USB_DEVICE(0x0a5c, 0x2035), .driver_info = BTUSB_WRONG_SCO_MTU },
 	{ USB_DEVICE(0x0a5c, 0x200a), .driver_info = BTUSB_WRONG_SCO_MTU },

