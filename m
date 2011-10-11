Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478Ab1JKSZm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 14:25:42 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:65369 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755356Ab1JKSZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 14:25:40 -0400
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH] pata_scc: add proper cable detection method
Date: Tue, 11 Oct 2011 20:07:24 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.37.6-0.7-desktop-dirty; KDE/4.6.0; x86_64; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201110112007.24530.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_scc: add proper cable detection method

Use standard ata_cable_80wire() method for the cable detection,
as a bonus this allows us to use the default ->prereset method.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
earlier references:
https://lkml.org/lkml/2009/11/25/373

 drivers/ata/pata_scc.c |   14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

Index: b/drivers/ata/pata_scc.c
===================================================================
--- a/drivers/ata/pata_scc.c
+++ b/drivers/ata/pata_scc.c
@@ -827,18 +827,6 @@ static unsigned int scc_data_xfer (struc
 }
 
 /**
- *	scc_pata_prereset - prepare for reset
- *	@ap: ATA port to be reset
- *	@deadline: deadline jiffies for the operation
- */
-
-static int scc_pata_prereset(struct ata_link *link, unsigned long deadline)
-{
-	link->ap->cbl = ATA_CBL_PATA80;
-	return ata_sff_prereset(link, deadline);
-}
-
-/**
  *	scc_postreset - standard postreset callback
  *	@ap: the target ata_port
  *	@classes: classes of attached devices
@@ -947,7 +935,7 @@ static struct ata_port_operations scc_pa
 	.bmdma_status		= scc_bmdma_status,
 	.sff_data_xfer		= scc_data_xfer,
 
-	.prereset		= scc_pata_prereset,
+	.cable_detect		= ata_cable_80wire,
 	.softreset		= scc_softreset,
 	.postreset		= scc_postreset,
 
