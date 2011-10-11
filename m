Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423Ab1JKS3S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 14:29:18 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:65369 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755335Ab1JKSZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 14:25:17 -0400
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH] pata_amd: DMA modes do not have 8-bit timings
Date: Tue, 11 Oct 2011 19:45:45 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.37.6-0.7-desktop-dirty; KDE/4.6.0; x86_64; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Message-Id: <201110111945.46105.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_amd: DMA modes do not have 8-bit timings

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_amd.c |    5 -----
 1 file changed, 5 deletions(-)

Index: b/drivers/ata/pata_amd.c
===================================================================
--- a/drivers/ata/pata_amd.c
+++ b/drivers/ata/pata_amd.c
@@ -65,11 +65,6 @@ static void timing_setup(struct ata_port
 	}
 
 	if (peer) {
-		/* This may be over conservative */
-		if (peer->dma_mode) {
-			ata_timing_compute(peer, peer->dma_mode, &apeer, T, UT);
-			ata_timing_merge(&apeer, &at, &at, ATA_TIMING_8BIT);
-		}
 		ata_timing_compute(peer, peer->pio_mode, &apeer, T, UT);
 		ata_timing_merge(&apeer, &at, &at, ATA_TIMING_8BIT);
 	}
