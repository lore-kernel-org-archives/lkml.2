Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932162Ab2JGXla (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 19:41:30 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38317 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753058Ab2JGXWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 19:22:23 -0400
Message-Id: <20121007225849.236079825@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 08 Oct 2012 00:00:19 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Marek Vasut <marex@denx.de>, Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Subject: [ 105/108] Bluetooth: Support AR3011 in Acer Iconia Tab W500
In-Reply-To: <20121007225834.673681075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marex@denx.de>

commit 6eda541d12116b4772baa09d3e8d7b0389df4289 upstream.

Acer used this chip connected via USB:

Bus 005 Device 005: ID 0cf3:3005 Atheros Communications, Inc. AR3011 Bluetooth
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass          224 Wireless
  bDeviceSubClass         1 Radio Frequency
  bDeviceProtocol         1 Bluetooth
  bMaxPacketSize0        64
  idVendor           0x0cf3 Atheros Communications, Inc.
  idProduct          0x3005 AR3011 Bluetooth
  bcdDevice            0.01
  iManufacturer           0
  iProduct                0
  iSerial                 0
  bNumConfigurations      1

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Gustavo Padovan <gustavo@padovan.org>
Cc: Johan Hedberg <johan.hedberg@gmail.com>
Cc: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/bluetooth/ath3k.c |    1 +
 drivers/bluetooth/btusb.c |    1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/bluetooth/ath3k.c b/drivers/bluetooth/ath3k.c
index ad591bd..f0f6202 100644
--- a/drivers/bluetooth/ath3k.c
+++ b/drivers/bluetooth/ath3k.c
@@ -63,6 +63,7 @@ static struct usb_device_id ath3k_table[] = {
 
 	/* Atheros AR3011 with sflash firmware*/
 	{ USB_DEVICE(0x0CF3, 0x3002) },
+	{ USB_DEVICE(0x0CF3, 0xE019) },
 	{ USB_DEVICE(0x13d3, 0x3304) },
 	{ USB_DEVICE(0x0930, 0x0215) },
 	{ USB_DEVICE(0x0489, 0xE03D) },
diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index c9463af8..ff3eabc 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -125,6 +125,7 @@ static struct usb_device_id blacklist_table[] = {
 
 	/* Atheros 3011 with sflash firmware */
 	{ USB_DEVICE(0x0cf3, 0x3002), .driver_info = BTUSB_IGNORE },
+	{ USB_DEVICE(0x0cf3, 0xe019), .driver_info = BTUSB_IGNORE },
 	{ USB_DEVICE(0x13d3, 0x3304), .driver_info = BTUSB_IGNORE },
 	{ USB_DEVICE(0x0930, 0x0215), .driver_info = BTUSB_IGNORE },
 	{ USB_DEVICE(0x0489, 0xe03d), .driver_info = BTUSB_IGNORE },


