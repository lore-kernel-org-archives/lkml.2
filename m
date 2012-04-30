Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757489Ab2D3Xn1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 19:43:27 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:57549 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756603Ab2D3Xn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 19:43:26 -0400
X-Authenticated: #4445348
X-Provags-ID: V01U2FsdGVkX1/aFzEkK+XaM1eZ7Lp0VbcPk/jA05os33q/8y5Idx
	yoFriKHdrPmJej
From: Michael =?ISO-8859-1?Q?Gr=FCtzner?= <mgruetzn@gmx.de>
To: marcel@holtmann.org
Cc: gustavo@padovan.org, johan.hedberg@gmail.com,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] bluetooth: Add support for Foxconn/Hon Hai AR5BBU22 0489:E03C
Date: Tue, 01 May 2012 01:43:17 +0200
Message-ID: <1769868.QZY8sEHkp9@dagobah>
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
 
Output from /sys/kernel/debug/usb/devices:

T:  Bus=01 Lev=02 Prnt=02 Port=05 Cnt=02 Dev#=  6 Spd=12   MxCh= 0
D:  Ver= 2.00 Cls=e0(wlcon) Sub=01 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=0489 ProdID=e03c Rev= 0.02
S:  Manufacturer=Atheros Communications
S:  Product=Bluetooth USB Host Controller
S:  SerialNumber=Alaska Day 2006
C:* #Ifs= 2 Cfg#= 1 Atr=e0 MxPwr=100mA
I:* If#= 0 Alt= 0 #EPs= 3 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=81(I) Atr=03(Int.) MxPS=  16 Ivl=1ms
E:  Ad=82(I) Atr=02(Bulk) MxPS=  64 Ivl=0ms
E:  Ad=02(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms
I:* If#= 1 Alt= 0 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=83(I) Atr=01(Isoc) MxPS=   0 Ivl=1ms
E:  Ad=03(O) Atr=01(Isoc) MxPS=   0 Ivl=1ms
I:  If#= 1 Alt= 1 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=83(I) Atr=01(Isoc) MxPS=   9 Ivl=1ms
E:  Ad=03(O) Atr=01(Isoc) MxPS=   9 Ivl=1ms
I:  If#= 1 Alt= 2 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=83(I) Atr=01(Isoc) MxPS=  17 Ivl=1ms
E:  Ad=03(O) Atr=01(Isoc) MxPS=  17 Ivl=1ms
I:  If#= 1 Alt= 3 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=83(I) Atr=01(Isoc) MxPS=  25 Ivl=1ms
E:  Ad=03(O) Atr=01(Isoc) MxPS=  25 Ivl=1ms
I:  If#= 1 Alt= 4 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=83(I) Atr=01(Isoc) MxPS=  33 Ivl=1ms
E:  Ad=03(O) Atr=01(Isoc) MxPS=  33 Ivl=1ms
I:  If#= 1 Alt= 5 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=83(I) Atr=01(Isoc) MxPS=  49 Ivl=1ms
E:  Ad=03(O) Atr=01(Isoc) MxPS=  49 Ivl=1ms

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
