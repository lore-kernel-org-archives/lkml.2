Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752020Ab1BOCSb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 21:18:31 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:46370 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103Ab1BOCS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 21:18:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=d+CYdDrXcwHdJatkq8jbUOMd7AQ9uvUFQkrsf4E7zFKim6D1CkdA3iEh1MdKsBqjpm
         bcgJnXzyED8yqgxvPC4cws+TBww6YswKNrbUERc/sJuvOG1ItyO5guXABTf7F1LwJXfy
         3M9kVgN4o99Wkl0hjlhPTlLGvbEtcxZwr+XUU=
From: "Cho, Yu-Chen" <acho@novell.com>
To: marcel@holtmann.org, padovan@profusion.mobi,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: acho@novell.com, jlee@novell.com
Subject: [PATCH] Add Atheros BT AR5BBU12 fw supported
Date: Tue, 15 Feb 2011 10:20:07 +0800
Message-Id: <967f2d5b2d6382f4aa698a549d4bfa74f35c171f.1297736230.git.acho@novell.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the btusb.c blacklist [0489:e02c] for Atheros AR5BBU12 BT
and add to ath3k.c supported this device.

Signed-off-by: Cho, Yu-Chen <acho@novell.com>
---
 drivers/bluetooth/ath3k.c |    3 +++
 drivers/bluetooth/btusb.c |    3 +++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/bluetooth/ath3k.c b/drivers/bluetooth/ath3k.c
index 333c212..6dcd55a 100644
--- a/drivers/bluetooth/ath3k.c
+++ b/drivers/bluetooth/ath3k.c
@@ -41,6 +41,9 @@ static struct usb_device_id ath3k_table[] = {
 
 	/* Atheros AR9285 Malbec with sflash firmware */
 	{ USB_DEVICE(0x03F0, 0x311D) },
+
+	/* Atheros AR5BBU12 with sflash firmware */
+	{ USB_DEVICE(0x0489, 0xE02C) },
 	{ }	/* Terminating entry */
 };
 
diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 664f1cc..b7f2f37 100644
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

