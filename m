Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728Ab2L2KPW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2012 05:15:22 -0500
Received: from mout.web.de ([212.227.17.11]:55679 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751321Ab2L2KPE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2012 05:15:04 -0500
From: Daniel Schaal <farbing@web.de>
To: Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Daniel Schaal <farbing@web.de>
Subject: [PATCH] Bluetooth: Add support for GC-WB300D PCIe [04ca:3006] to ath3k.
Date: Sat, 29 Dec 2012 11:14:34 +0100
Message-Id: <1356776074-1703-2-git-send-email-farbing@web.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1356776074-1703-1-git-send-email-farbing@web.de>
References: <1356776074-1703-1-git-send-email-farbing@web.de>
X-Provags-ID: V02:K0:D+B4rmE9oFqyS9k5fWVODlErOR5BUqW2b3qmtQoZlob
 F/POW2cgbfD8vchk+f0GWMHlu1Qg3YYeJbc1F2pZ3PxHM/08e9
 htzyO4XAuJLneJe34YMBpxUXFpsGRztyNt8y/FOL95Y+gi6/a4
 2s3Xm+sJ0ykFMFjcbQd/jB99tEfUEOHCYseUkz5ORpcm7lXeio
 MUG5Vk0YNAPVLhWNQ7kbw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

T:  Bus=02 Lev=02 Prnt=02 Port=06 Cnt=01 Dev#=  4 Spd=12   MxCh= 0
D:  Ver= 1.10 Cls=e0(wlcon) Sub=01 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=04ca ProdID=3006 Rev= 0.02
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

Signed-off-by: Daniel Schaal <farbing@web.de>
---
 drivers/bluetooth/ath3k.c |    2 ++
 drivers/bluetooth/btusb.c |    1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/bluetooth/ath3k.c b/drivers/bluetooth/ath3k.c
index b00000e..d936c5d 100644
--- a/drivers/bluetooth/ath3k.c
+++ b/drivers/bluetooth/ath3k.c
@@ -77,6 +77,7 @@ static struct usb_device_id ath3k_table[] = {
 	{ USB_DEVICE(0x0CF3, 0x311D) },
 	{ USB_DEVICE(0x13d3, 0x3375) },
 	{ USB_DEVICE(0x04CA, 0x3005) },
+	{ USB_DEVICE(0x04CA, 0x3006) },
 	{ USB_DEVICE(0x13d3, 0x3362) },
 	{ USB_DEVICE(0x0CF3, 0xE004) },
 	{ USB_DEVICE(0x0930, 0x0219) },
@@ -104,6 +105,7 @@ static struct usb_device_id ath3k_blist_tbl[] = {
 	{ USB_DEVICE(0x0cf3, 0x311D), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x13d3, 0x3375), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x04ca, 0x3005), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x04ca, 0x3006), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x13d3, 0x3362), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0cf3, 0xe004), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0930, 0x0219), .driver_info = BTUSB_ATH3012 },
diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index a1d4ede..3252792 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -135,6 +135,7 @@ static struct usb_device_id blacklist_table[] = {
 	{ USB_DEVICE(0x0cf3, 0x311d), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x13d3, 0x3375), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x04ca, 0x3005), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x04ca, 0x3006), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x13d3, 0x3362), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0cf3, 0xe004), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0930, 0x0219), .driver_info = BTUSB_ATH3012 },
-- 
1.7.10.4

