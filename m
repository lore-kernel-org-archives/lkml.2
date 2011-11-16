Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204Ab1KPDVk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 22:21:40 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:52451 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417Ab1KPDVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 22:21:39 -0500
From: Keng-Yu Lin <kengyu@canonical.com>
To: Marcel Holtmann <marcel@holtmann.org>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Keng-Yu Lin <kengyu@canonical.com>
Subject: [PATCH] Bluetooth: Add AR30XX device ID on Asus laptops
Date: Wed, 16 Nov 2011 11:21:23 +0800
Message-Id: <1321413683-4502-1-git-send-email-kengyu@canonical.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ID is found on Asus K54HR and K53U.
Blacklist the AR3011-based device ID [0489:e03d]
and add to ath3k.c for firmware loading.

Signed-off-by: Keng-Yu Lin <kengyu@canonical.com>
---
 drivers/bluetooth/ath3k.c |    1 +
 drivers/bluetooth/btusb.c |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/bluetooth/ath3k.c b/drivers/bluetooth/ath3k.c
index 106beb1..db811d2 100644
--- a/drivers/bluetooth/ath3k.c
+++ b/drivers/bluetooth/ath3k.c
@@ -64,6 +64,7 @@ static struct usb_device_id ath3k_table[] = {
 	{ USB_DEVICE(0x0CF3, 0x3002) },
 	{ USB_DEVICE(0x13d3, 0x3304) },
 	{ USB_DEVICE(0x0930, 0x0215) },
+	{ USB_DEVICE(0x0489, 0xE03D) },
 
 	/* Atheros AR9285 Malbec with sflash firmware */
 	{ USB_DEVICE(0x03F0, 0x311D) },
diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index f9b7260..bf1eb35 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -116,6 +116,7 @@ static struct usb_device_id blacklist_table[] = {
 	{ USB_DEVICE(0x0cf3, 0x3002), .driver_info = BTUSB_IGNORE },
 	{ USB_DEVICE(0x13d3, 0x3304), .driver_info = BTUSB_IGNORE },
 	{ USB_DEVICE(0x0930, 0x0215), .driver_info = BTUSB_IGNORE },
+	{ USB_DEVICE(0x0489, 0xe03d), .driver_info = BTUSB_IGNORE },
 
 	/* Atheros AR9285 Malbec with sflash firmware */
 	{ USB_DEVICE(0x03f0, 0x311d), .driver_info = BTUSB_IGNORE },
-- 
1.7.5.4

