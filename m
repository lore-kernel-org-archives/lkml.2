Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979Ab1BOB5W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 20:57:22 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:40951 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196Ab1BOB5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 20:57:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=WQDZoNuqN+Y86Zn5Xvtr319tSPh5mEhrcZjBcklCAckxPpOlZBv6pV8MFPBt0PVI3F
         vxCEPMWMJrRsjY8+6OdwuTltMtWxzGPPUFeUAvTaSKpZAN6MAPLfBr7JQrDrk8s4bDpo
         QJ27jdV1Ns/KunSaHqBjN10BlE+5QbdAbX0UQ=
From: "Cho, Yu-Chen" <acho@novell.com>
To: marcel@holtmann.org, padovan@profusion.mobi,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: acho@novell.com, jlee@novell.com
Subject: [PATCH] Add Atheros BT AR5BBU12 fw supported
Date: Tue, 15 Feb 2011 09:58:54 +0800
Message-Id: <ce34a9f1d05bc28c97d7de0c2a99225f56b11953.1297735066.git.acho@novell.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the btusb.c blacklist [0489:e02c] for Atheros AR5BBU12 BT
and add to ath3k.c supported this device.

Signed-off-by: Cho, Yu-Chen <acho@novell.com>
---
 drivers/bluetooth/ath3k.c |    4 ++++
 drivers/bluetooth/btusb.c |    3 +++
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/bluetooth/ath3k.c b/drivers/bluetooth/ath3k.c
index 333c212..d4065c0 100644
--- a/drivers/bluetooth/ath3k.c
+++ b/drivers/bluetooth/ath3k.c
@@ -41,6 +41,10 @@ static struct usb_device_id ath3k_table[] = {
 
 	/* Atheros AR9285 Malbec with sflash firmware */
 	{ USB_DEVICE(0x03F0, 0x311D) },
+
+	/* Atheros AR5BBU12 with sflash firmware */
+	{ USB_DEVICE(0x0489, 0xE02C) },
+
 	{ }	/* Terminating entry */
 };
 
diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 4cefa91..0ae22fd 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -105,6 +105,9 @@ static struct usb_device_id blacklist_table[] = {
 	/* Atheros AR9285 Malbec with sflash firmware */
 	{ USB_DEVICE(0x03f0, 0x311d), .driver_info = BTUSB_IGNORE },
 
+	/* Atheros AR5BBU12 with sflash firmware */
+	{ USB_DEVICE(0x0489, 0xe02c), .driver_info = BTUSB_IGNORE },
+
 	/* Broadcom BCM2035 */
 	{ USB_DEVICE(0x0a5c, 0x2035), .driver_info = BTUSB_WRONG_SCO_MTU },
 	{ USB_DEVICE(0x0a5c, 0x200a), .driver_info = BTUSB_WRONG_SCO_MTU },
-- 
1.7.1

