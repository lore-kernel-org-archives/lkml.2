Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437Ab1JKSZg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 14:25:36 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:65369 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755356Ab1JKSZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 14:25:33 -0400
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH 3/3] pata_cmd64x: remove dead CMD646 rev 1 code
Date: Tue, 11 Oct 2011 19:59:03 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.37.6-0.7-desktop-dirty; KDE/4.6.0; x86_64; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201110111959.04056.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_cmd64x: remove dead CMD646 rev 1 code

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_cmd64x.c |   33 ++-------------------------------
 1 file changed, 2 insertions(+), 31 deletions(-)

Index: b/drivers/ata/pata_cmd64x.c
===================================================================
--- a/drivers/ata/pata_cmd64x.c
+++ b/drivers/ata/pata_cmd64x.c
@@ -249,18 +249,6 @@ static void cmd648_bmdma_stop(struct ata
 	pci_write_config_byte(pdev, dma_reg, dma_intr | dma_mask);
 }
 
-/**
- *	cmd646r1_dma_stop	-	DMA stop callback
- *	@qc: Command in progress
- *
- *	Stub for now while investigating the r1 quirk in the old driver.
- */
-
-static void cmd646r1_bmdma_stop(struct ata_queued_cmd *qc)
-{
-	ata_bmdma_stop(qc);
-}
-
 static struct scsi_host_template cmd64x_sht = {
 	ATA_BMDMA_SHT(DRV_NAME),
 };
@@ -276,12 +264,6 @@ static struct ata_port_operations cmd64x
 	.cable_detect	= ata_cable_40wire,
 };
 
-static struct ata_port_operations cmd646r1_port_ops = {
-	.inherits	= &cmd64x_base_ops,
-	.bmdma_stop	= cmd646r1_bmdma_stop,
-	.cable_detect	= ata_cable_40wire,
-};
-
 static struct ata_port_operations cmd648_port_ops = {
 	.inherits	= &cmd64x_base_ops,
 	.bmdma_stop	= cmd648_bmdma_stop,
@@ -326,12 +308,6 @@ static int cmd64x_init_one(struct pci_de
 			.udma_mask = ATA_UDMA2,
 			.port_ops = &cmd64x_port_ops
 		},
-		{	/* CMD 646 rev 1  */
-			.flags = ATA_FLAG_SLAVE_POSS,
-			.pio_mask = ATA_PIO4,
-			.mwdma_mask = ATA_MWDMA2,
-			.port_ops = &cmd646r1_port_ops
-		},
 		{	/* CMD 648 */
 			.flags = ATA_FLAG_SLAVE_POSS,
 			.pio_mask = ATA_PIO4,
@@ -374,11 +350,6 @@ static int cmd64x_init_one(struct pci_de
 			ppi[0] = &cmd_info[2];
 			ppi[1] = &cmd_info[2];
 		}
-		/* Early rev with other problems ? */
-		else if (pdev->revision == 1) {
-			ppi[0] = &cmd_info[3];
-			ppi[1] = &cmd_info[3];
-		}
 		/* revs 1,2 have no CNTRL_CH0 */
 		if (pdev->revision < 3)
 			cntrl_ch0_ok = 0;
@@ -423,8 +394,8 @@ static int cmd64x_reinit_one(struct pci_
 static const struct pci_device_id cmd64x[] = {
 	{ PCI_VDEVICE(CMD, PCI_DEVICE_ID_CMD_643), 0 },
 	{ PCI_VDEVICE(CMD, PCI_DEVICE_ID_CMD_646), 1 },
-	{ PCI_VDEVICE(CMD, PCI_DEVICE_ID_CMD_648), 4 },
-	{ PCI_VDEVICE(CMD, PCI_DEVICE_ID_CMD_649), 5 },
+	{ PCI_VDEVICE(CMD, PCI_DEVICE_ID_CMD_648), 3 },
+	{ PCI_VDEVICE(CMD, PCI_DEVICE_ID_CMD_649), 4 },
 
 	{ },
 };
