Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197Ab0GVIN1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 04:13:27 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:47071 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752230Ab0GVINW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 04:13:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=wBLPaigrO+g5SQAi1zHXaJZ85Aov0EBn3Cmz7Twsv9/Wb4GJIWm0QU3AuLsiVPEcrs
         TKfiTfmJ680cBeztWCxYyaBEZjb0uWqy/15qYwiquUydWWiwz0shEOav6FuYui8pPlOi
         75R22fteqcS7DSypEBXEiOvkhz9Gji6csiyA4=
From: Alexander Beregalov <a.beregalov@gmail.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, Lytochkin Boris <lytboris@gmail.com>,
        Alexander Beregalov <a.beregalov@gmail.com>
Subject: [PATCH] serial: add support for OX16PCI958 card
Date: Thu, 22 Jul 2010 12:12:43 +0400
Message-Id: <1279786363-16813-1-git-send-email-a.beregalov@gmail.com>
X-Mailer: git-send-email 1.7.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lytochkin Boris <lytboris@gmail.com>

Signed-off-by: Lytochkin Boris <lytboris@gmail.com>
Tested-by: Lytochkin Boris <lytboris@gmail.com>
Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---
 drivers/serial/8250_pci.c |   12 ++++++++++++
 include/linux/pci_ids.h   |    1 +
 2 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/serial/8250_pci.c b/drivers/serial/8250_pci.c
index 746a446..0d7a13e 100644
--- a/drivers/serial/8250_pci.c
+++ b/drivers/serial/8250_pci.c
@@ -1542,6 +1542,8 @@ enum pci_board_num_t {
 	pbn_b2_4_921600,
 	pbn_b2_8_921600,
 
+	pbn_b2_8_1152000,
+
 	pbn_b2_bt_1_115200,
 	pbn_b2_bt_2_115200,
 	pbn_b2_bt_4_115200,
@@ -1960,6 +1962,13 @@ static struct pciserial_board pci_boards[] __devinitdata = {
 		.uart_offset	= 8,
 	},
 
+	[pbn_b2_8_1152000] = {
+		.flags		= FL_BASE2,
+		.num_ports	= 8,
+		.base_baud	= 1152000,
+		.uart_offset	= 8,
+	},
+
 	[pbn_b2_bt_1_115200] = {
 		.flags		= FL_BASE2|FL_BASE_BARS,
 		.num_ports	= 1,
@@ -2875,6 +2884,9 @@ static struct pci_device_id serial_pci_tbl[] = {
 	{	PCI_VENDOR_ID_OXSEMI, PCI_DEVICE_ID_OXSEMI_16PCI952,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 		pbn_b0_bt_2_921600 },
+	{	PCI_VENDOR_ID_OXSEMI, PCI_DEVICE_ID_OXSEMI_16PCI958,
+		PCI_ANY_ID , PCI_ANY_ID, 0, 0,
+		pbn_b2_8_1152000 },
 
 	/*
 	 * Oxford Semiconductor Inc. Tornado PCI express device range.
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 3bedcc1..5bc2a63 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -1998,6 +1998,7 @@
 #define PCI_DEVICE_ID_OXSEMI_16PCI954PP	0x9513
 #define PCI_DEVICE_ID_OXSEMI_16PCI952	0x9521
 #define PCI_DEVICE_ID_OXSEMI_16PCI952PP	0x9523
+#define PCI_DEVICE_ID_OXSEMI_16PCI958	0x9538
 #define PCI_SUBDEVICE_ID_OXSEMI_C950	0x0001
 
 #define PCI_VENDOR_ID_CHELSIO		0x1425
-- 
1.7.1.1

