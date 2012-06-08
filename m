Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933298Ab2FHFPt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 01:15:49 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43225 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761171Ab2FHFH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 01:07:27 -0400
Message-Id: <20120608041848.596234292@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 08 Jun 2012 05:19:38 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, AceLan Kao <acelan.kao@canonical.com>,
        Johan Hedberg <johan.hedberg@intel.com>
Subject: [ 58/82] Bluetooth: Add support for Atheros [13d3:3362]
In-Reply-To: <20120608041840.861504477@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: AceLan Kao <acelan.kao@canonical.com>

commit 87522a433ba6886b5ccbb497e0a7cb8097def64e upstream.

Add another vendor specific ID for Atheros AR3012 device.
This chip is wrapped by IMC Networks.

output of usb-devices:
T:  Bus=01 Lev=02 Prnt=02 Port=00 Cnt=01 Dev#=  5 Spd=12  MxCh= 0
D:  Ver= 1.10 Cls=e0(wlcon) Sub=01 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=13d3 ProdID=3362 Rev=00.02
S:  Manufacturer=Atheros Communications
S:  Product=Bluetooth USB Host Controller
S:  SerialNumber=Alaska Day 2006
C:  #Ifs= 2 Cfg#= 1 Atr=e0 MxPwr=100mA
I:  If#= 0 Alt= 0 #EPs= 3 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
I:  If#= 1 Alt= 0 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb

Signed-off-by: AceLan Kao <acelan.kao@canonical.com>
Signed-off-by: Johan Hedberg <johan.hedberg@intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/bluetooth/ath3k.c |    2 ++
 drivers/bluetooth/btusb.c |    1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/bluetooth/ath3k.c b/drivers/bluetooth/ath3k.c
index ae9edca..639a161 100644
--- a/drivers/bluetooth/ath3k.c
+++ b/drivers/bluetooth/ath3k.c
@@ -75,6 +75,7 @@ static struct usb_device_id ath3k_table[] = {
 	{ USB_DEVICE(0x0CF3, 0x311D) },
 	{ USB_DEVICE(0x13d3, 0x3375) },
 	{ USB_DEVICE(0x04CA, 0x3005) },
+	{ USB_DEVICE(0x13d3, 0x3362) },
 
 	/* Atheros AR5BBU12 with sflash firmware */
 	{ USB_DEVICE(0x0489, 0xE02C) },
@@ -94,6 +95,7 @@ static struct usb_device_id ath3k_blist_tbl[] = {
 	{ USB_DEVICE(0x0cf3, 0x311D), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x13d3, 0x3375), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x04ca, 0x3005), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x13d3, 0x3362), .driver_info = BTUSB_ATH3012 },
 
 	{ }	/* Terminating entry */
 };
diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 9af450a..a497544 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -134,6 +134,7 @@ static struct usb_device_id blacklist_table[] = {
 	{ USB_DEVICE(0x0cf3, 0x311d), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x13d3, 0x3375), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x04ca, 0x3005), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x13d3, 0x3362), .driver_info = BTUSB_ATH3012 },
 
 	/* Atheros AR5BBU12 with sflash firmware */
 	{ USB_DEVICE(0x0489, 0xe02c), .driver_info = BTUSB_IGNORE },


