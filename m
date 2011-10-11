Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534Ab1JKS2F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 14:28:05 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46351 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755421Ab1JKSZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 14:25:35 -0400
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH] pata_cs5520: remove incorrect warning message
Date: Tue, 11 Oct 2011 20:00:44 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.37.6-0.7-desktop-dirty; KDE/4.6.0; x86_64; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201110112000.44960.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_cs5520: remove incorrect warning message

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_cs5520.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

Index: b/drivers/ata/pata_cs5520.c
===================================================================
--- a/drivers/ata/pata_cs5520.c
+++ b/drivers/ata/pata_cs5520.c
@@ -148,10 +148,8 @@ static int __devinit cs5520_init_one(str
 	if (pcicfg & 2)
 		ppi[1] = &pi;
 
-	if ((pcicfg & 0x40) == 0) {
-		dev_warn(&pdev->dev, "DMA mode disabled. Enabling.\n");
+	if ((pcicfg & 0x40) == 0)
 		pci_write_config_byte(pdev, 0x60, pcicfg | 0x40);
-	}
 
 	pi.mwdma_mask = id->driver_data;
 
