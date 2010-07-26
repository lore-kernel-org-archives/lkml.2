Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753099Ab0GZGDT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 02:03:19 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:64306 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121Ab0GZGDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 02:03:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=nuswtSM0//4qacjXovT2Zjir8zqLP718wa1toPik0Cga4US4xraVi0hcdejRJdNYPJ
         U1VO60aQ0r3/P2BE6PWlUKGK378pOJuVKG9Bf5LQ9/YlYcyFtPJQd8JB5ZAJ85VgkxBF
         xNEwOu7jr4BJ0jGBZizj9oFRrhi1Y0PLy2NKA=
From: Alexander Beregalov <a.beregalov@gmail.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, Lytochkin Boris <lytboris@gmail.com>,
        Alexander Beregalov <a.beregalov@gmail.com>
Subject: [PATCH] serial: add support for OX16PCI958 card
Date: Mon, 26 Jul 2010 10:02:26 +0400
Message-Id: <1280124146-24735-1-git-send-email-a.beregalov@gmail.com>
X-Mailer: git-send-email 1.7.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lytochkin Boris <lytboris@gmail.com>

Signed-off-by: Lytochkin Boris <lytboris@gmail.com>
Tested-by: Lytochkin Boris <lytboris@gmail.com>
Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---
 drivers/serial/8250_pci.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/serial/8250_pci.c b/drivers/serial/8250_pci.c
index 746a446..53be4d3 100644
--- a/drivers/serial/8250_pci.c
+++ b/drivers/serial/8250_pci.c
@@ -994,6 +994,7 @@ static int skip_tx_en_setup(struct serial_private *priv,
 #define PCI_DEVICE_ID_TITAN_800E	0xA014
 #define PCI_DEVICE_ID_TITAN_200EI	0xA016
 #define PCI_DEVICE_ID_TITAN_200EISI	0xA017
+#define PCI_DEVICE_ID_OXSEMI_16PCI958	0x9538
 
 /* Unknown vendors/cards - this should not be in linux/pci_ids.h */
 #define PCI_SUBDEVICE_ID_UNKNOWN_0x1584	0x1584
@@ -1542,6 +1543,8 @@ enum pci_board_num_t {
 	pbn_b2_4_921600,
 	pbn_b2_8_921600,
 
+	pbn_b2_8_1152000,
+
 	pbn_b2_bt_1_115200,
 	pbn_b2_bt_2_115200,
 	pbn_b2_bt_4_115200,
@@ -1960,6 +1963,13 @@ static struct pciserial_board pci_boards[] __devinitdata = {
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
@@ -2875,6 +2885,9 @@ static struct pci_device_id serial_pci_tbl[] = {
 	{	PCI_VENDOR_ID_OXSEMI, PCI_DEVICE_ID_OXSEMI_16PCI952,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 		pbn_b0_bt_2_921600 },
+	{	PCI_VENDOR_ID_OXSEMI, PCI_DEVICE_ID_OXSEMI_16PCI958,
+		PCI_ANY_ID , PCI_ANY_ID, 0, 0,
+		pbn_b2_8_1152000 },
 
 	/*
 	 * Oxford Semiconductor Inc. Tornado PCI express device range.
-- 
1.7.1.1

