Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933937Ab1DNShH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 14:37:07 -0400
Received: from mail.windriver.com ([147.11.1.11]:37257 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932438Ab1DNRpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:45:24 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Lytochkin Boris <lytboris@gmail.com>,
        Alexander Beregalov <a.beregalov@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 007/209] serial: add support for OX16PCI958 card
Date: Thu, 14 Apr 2011 13:40:37 -0400
Message-Id: <1302803039-9400-8-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lytochkin Boris <lytboris@gmail.com>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

commit e847003f00d5eca3e3b3a6a1199f82b51293faf6 upstream.

Signed-off-by: Lytochkin Boris <lytboris@gmail.com>
Tested-by: Lytochkin Boris <lytboris@gmail.com>
Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/serial/8250_pci.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/serial/8250_pci.c b/drivers/serial/8250_pci.c
index 01c012d..c0a4860 100644
--- a/drivers/serial/8250_pci.c
+++ b/drivers/serial/8250_pci.c
@@ -982,6 +982,7 @@ static int skip_tx_en_setup(struct serial_private *priv,
 #define PCI_SUBDEVICE_ID_POCTAL422	0x0408
 #define PCI_VENDOR_ID_ADVANTECH		0x13fe
 #define PCI_DEVICE_ID_ADVANTECH_PCI3620	0x3620
+#define PCI_DEVICE_ID_OXSEMI_16PCI958	0x9538
 
 /* Unknown vendors/cards - this should not be in linux/pci_ids.h */
 #define PCI_SUBDEVICE_ID_UNKNOWN_0x1584	0x1584
@@ -1530,6 +1531,8 @@ enum pci_board_num_t {
 	pbn_b2_4_921600,
 	pbn_b2_8_921600,
 
+	pbn_b2_8_1152000,
+
 	pbn_b2_bt_1_115200,
 	pbn_b2_bt_2_115200,
 	pbn_b2_bt_4_115200,
@@ -1944,6 +1947,13 @@ static struct pciserial_board pci_boards[] __devinitdata = {
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
@@ -2840,6 +2850,9 @@ static struct pci_device_id serial_pci_tbl[] = {
 	{	PCI_VENDOR_ID_OXSEMI, PCI_DEVICE_ID_OXSEMI_16PCI952,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 		pbn_b0_bt_2_921600 },
+	{	PCI_VENDOR_ID_OXSEMI, PCI_DEVICE_ID_OXSEMI_16PCI958,
+		PCI_ANY_ID , PCI_ANY_ID, 0, 0,
+		pbn_b2_8_1152000 },
 
 	/*
 	 * Oxford Semiconductor Inc. Tornado PCI express device range.
-- 
1.7.4.4

