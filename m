Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759936Ab2FGEbI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 00:31:08 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63306 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759892Ab2FGEYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 00:24:04 -0400
Message-Id: <20120607041401.484193075@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 07 Jun 2012 13:14:21 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Michael Gruetzner <mgruetzn@gmx.de>,
        Gustavo Padovan <gustavo@padovan.org>
Subject: [ 23/47] Bluetooth: Add support for Foxconn/Hon Hai AR5BBU22 0489:E03C
In-Reply-To: <20120607041504.GA13819@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Gruetzner <mgruetzn@gmx.de>

commit 85d59726c5c66016a507f1f4a60db8e374dd284d upstream.

Add Foxconn/Hon Hai AR5BBU22 Bluetooth Module( 0x489:0xE03C) to
the blacklist of btusb module and add it to the ath3k module to properly
load the firmware in Kernel 3.3.4
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
Signed-off-by: Gustavo Padovan <gustavo@padovan.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/bluetooth/ath3k.c |    6 ++++++
 drivers/bluetooth/btusb.c |    3 +++
 2 files changed, 9 insertions(+)

--- a/drivers/bluetooth/ath3k.c
+++ b/drivers/bluetooth/ath3k.c
@@ -78,6 +78,9 @@ static struct usb_device_id ath3k_table[
 	/* Atheros AR5BBU12 with sflash firmware */
 	{ USB_DEVICE(0x0489, 0xE02C) },
 
+	/* Atheros AR5BBU22 with sflash firmware */
+	{ USB_DEVICE(0x0489, 0xE03C) },
+
 	{ }	/* Terminating entry */
 };
 
@@ -94,6 +97,9 @@ static struct usb_device_id ath3k_blist_
 	{ USB_DEVICE(0x13d3, 0x3375), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x04ca, 0x3005), .driver_info = BTUSB_ATH3012 },
 
+	/* Atheros AR5BBU22 with sflash firmware */
+	{ USB_DEVICE(0x0489, 0xE03C), .driver_info = BTUSB_ATH3012 },
+
 	{ }	/* Terminating entry */
 };
 
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -141,6 +141,9 @@ static struct usb_device_id blacklist_ta
 	/* Atheros AR5BBU12 with sflash firmware */
 	{ USB_DEVICE(0x0489, 0xe02c), .driver_info = BTUSB_IGNORE },
 
+	/* Atheros AR5BBU12 with sflash firmware */
+	{ USB_DEVICE(0x0489, 0xe03c), .driver_info = BTUSB_ATH3012 },
+
 	/* Broadcom BCM2035 */
 	{ USB_DEVICE(0x0a5c, 0x2035), .driver_info = BTUSB_WRONG_SCO_MTU },
 	{ USB_DEVICE(0x0a5c, 0x200a), .driver_info = BTUSB_WRONG_SCO_MTU },


