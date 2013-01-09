Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933235Ab3AIVkY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 16:40:24 -0500
Received: from mail.kernel.org ([198.145.19.201]:41957 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932950Ab3AIUiK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:38:10 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Marcos Chaparro <marcos@mrkindustries.com.ar>,
        Gustavo Padovan <gustavo.padovan@collabora.co.uk>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [ 41/47] Bluetooth: ath3k: Add support for VAIO VPCEH [0489:e027]
Date: Wed,  9 Jan 2013 12:35:36 -0800
Message-Id: <20130109201734.206078328@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130109201729.435233560@linuxfoundation.org>
References: <20130109201729.435233560@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marcos Chaparro <marcos@mrkindustries.com.ar>

commit acd9454433e28c1a365d8b069813c35c1c3a8ac3 upstream.

Added Atheros AR3011 internal bluetooth device found in Sony VAIO VPCEH to the
devices list.
Before this, the bluetooth module was identified as an Foxconn / Hai bluetooth
device [0489:e027], now it claims to be an AtherosAR3011 Bluetooth
[0cf3:3005].

T:  Bus=01 Lev=02 Prnt=02 Port=04 Cnt=02 Dev#=  4 Spd=12   MxCh= 0
D:  Ver= 1.10 Cls=e0(wlcon) Sub=01 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=0489 ProdID=e027 Rev= 0.01
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

Signed-off-by: Marcos Chaparro <marcos@mrkindustries.com.ar>
Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/bluetooth/ath3k.c |    1 +
 drivers/bluetooth/btusb.c |    1 +
 2 files changed, 2 insertions(+)

--- a/drivers/bluetooth/ath3k.c
+++ b/drivers/bluetooth/ath3k.c
@@ -65,6 +65,7 @@ static struct usb_device_id ath3k_table[
 	{ USB_DEVICE(0x13d3, 0x3304) },
 	{ USB_DEVICE(0x0930, 0x0215) },
 	{ USB_DEVICE(0x0489, 0xE03D) },
+	{ USB_DEVICE(0x0489, 0xE027) },
 
 	/* Atheros AR9285 Malbec with sflash firmware */
 	{ USB_DEVICE(0x03F0, 0x311D) },
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -130,6 +130,7 @@ static struct usb_device_id blacklist_ta
 	{ USB_DEVICE(0x13d3, 0x3304), .driver_info = BTUSB_IGNORE },
 	{ USB_DEVICE(0x0930, 0x0215), .driver_info = BTUSB_IGNORE },
 	{ USB_DEVICE(0x0489, 0xe03d), .driver_info = BTUSB_IGNORE },
+	{ USB_DEVICE(0x0489, 0xe027), .driver_info = BTUSB_IGNORE },
 
 	/* Atheros AR9285 Malbec with sflash firmware */
 	{ USB_DEVICE(0x03f0, 0x311d), .driver_info = BTUSB_IGNORE },


