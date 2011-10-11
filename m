Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598Ab1JKS0L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 14:26:11 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:65369 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755529Ab1JKSZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 14:25:50 -0400
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH 2/3] pata_sil680: constify tables
Date: Tue, 11 Oct 2011 20:20:28 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.37.6-0.7-desktop-dirty; KDE/4.6.0; x86_64; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201110112020.28868.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_sil680: constify tables

Constify tables in sil680_set_[pio,dma]mode().

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_sil680.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

Index: b/drivers/ata/pata_sil680.c
===================================================================
--- a/drivers/ata/pata_sil680.c
+++ b/drivers/ata/pata_sil680.c
@@ -105,8 +105,12 @@ static int sil680_cable_detect(struct at
 
 static void sil680_set_piomode(struct ata_port *ap, struct ata_device *adev)
 {
-	static u16 speed_p[5] = { 0x328A, 0x2283, 0x1104, 0x10C3, 0x10C1 };
-	static u16 speed_t[5] = { 0x328A, 0x2283, 0x1281, 0x10C3, 0x10C1 };
+	static const u16 speed_p[5] = {
+		0x328A, 0x2283, 0x1104, 0x10C3, 0x10C1
+	};
+	static const u16 speed_t[5] = {
+		0x328A, 0x2283, 0x1281, 0x10C3, 0x10C1
+	};
 
 	unsigned long tfaddr = sil680_selreg(ap, 0x02);
 	unsigned long addr = sil680_seldev(ap, adev, 0x04);
@@ -153,11 +157,11 @@ static void sil680_set_piomode(struct at
 
 static void sil680_set_dmamode(struct ata_port *ap, struct ata_device *adev)
 {
-	static u8 ultra_table[2][7] = {
+	static const u8 ultra_table[2][7] = {
 		{ 0x0C, 0x07, 0x05, 0x04, 0x02, 0x01, 0xFF },	/* 100MHz */
 		{ 0x0F, 0x0B, 0x07, 0x05, 0x03, 0x02, 0x01 },	/* 133Mhz */
 	};
-	static u16 dma_table[3] = { 0x2208, 0x10C2, 0x10C1 };
+	static const u16 dma_table[3] = { 0x2208, 0x10C2, 0x10C1 };
 
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	unsigned long ma = sil680_seldev(ap, adev, 0x08);
