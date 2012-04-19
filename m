Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933590Ab2DSVgo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 17:36:44 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:61429 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964903Ab2DSVOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 17:14:23 -0400
Message-Id: <20120419210615.751722811@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 19 Apr 2012 14:07:05 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Eran <eran@over-here.org>,
        Michal Labedzki <michal.labedzki@tieto.com>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>,
        Jonathan Nieder <jrnieder@gmail.com>
Subject: [ 54/59] Bluetooth: Adding USB device 13d3:3375 as an Atheros AR3012.
In-Reply-To: <20120419210623.GA12156@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eran <eran@over-here.org>

commit 9498ba7a1d38d42eef4ef6d906ab1743c9f0fd6f upstream.

The bluetooth module in the Asus UX31/UX21 is based on Atheros AR3012
and requires a firmware to be uploaded before it's usable.

output of usb-devices for this module:
T:  Bus=01 Lev=02 Prnt=02 Port=07 Cnt=03 Dev#=  6 Spd=12  MxCh= 0
D:  Ver= 1.10 Cls=e0(wlcon) Sub=01 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=13d3 ProdID=3375 Rev=00.02
S:  Manufacturer=Atheros Communications
S:  Product=Bluetooth USB Host Controller
S:  SerialNumber=Alaska Day 2006
C:  #Ifs= 2 Cfg#= 1 Atr=e0 MxPwr=100mA
I:  If#= 0 Alt= 0 #EPs= 3 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
I:  If#= 1 Alt= 0 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb

Signed-off-by: Eran <eran@over-here.org>
Tested-by: Michal Labedzki <michal.labedzki@tieto.com>
Signed-off-by: Gustavo F. Padovan <padovan@profusion.mobi>
Cc: Jonathan Nieder <jrnieder@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/bluetooth/ath3k.c |    2 ++
 drivers/bluetooth/btusb.c |    1 +
 2 files changed, 3 insertions(+)

--- a/drivers/bluetooth/ath3k.c
+++ b/drivers/bluetooth/ath3k.c
@@ -71,6 +71,7 @@ static struct usb_device_id ath3k_table[
 
 	/* Atheros AR3012 with sflash firmware*/
 	{ USB_DEVICE(0x0CF3, 0x3004) },
+	{ USB_DEVICE(0x13d3, 0x3375) },
 
 	/* Atheros AR5BBU12 with sflash firmware */
 	{ USB_DEVICE(0x0489, 0xE02C) },
@@ -87,6 +88,7 @@ static struct usb_device_id ath3k_blist_
 
 	/* Atheros AR3012 with sflash firmware*/
 	{ USB_DEVICE(0x0cf3, 0x3004), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x13d3, 0x3375), .driver_info = BTUSB_ATH3012 },
 
 	{ }	/* Terminating entry */
 };
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -123,6 +123,7 @@ static struct usb_device_id blacklist_ta
 
 	/* Atheros 3012 with sflash firmware */
 	{ USB_DEVICE(0x0cf3, 0x3004), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x13d3, 0x3375), .driver_info = BTUSB_ATH3012 },
 
 	/* Atheros AR5BBU12 with sflash firmware */
 	{ USB_DEVICE(0x0489, 0xe02c), .driver_info = BTUSB_IGNORE },


