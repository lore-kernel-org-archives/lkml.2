Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755348Ab1JKSZj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 14:25:39 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:65369 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755356Ab1JKSZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 14:25:37 -0400
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH] pata_cs5535: no need to program PIO0 timings during device init
Date: Tue, 11 Oct 2011 20:04:05 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.37.6-0.7-desktop-dirty; KDE/4.6.0; x86_64; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201110112004.05251.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_cs5535: no need to program PIO0 timings during device init

Core libata code takes care of it nowadays.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
earlier references:
https://lkml.org/lkml/2009/11/25/345

 drivers/ata/pata_cs5535.c |   12 ------------
 1 file changed, 12 deletions(-)

Index: b/drivers/ata/pata_cs5535.c
===================================================================
--- a/drivers/ata/pata_cs5535.c
+++ b/drivers/ata/pata_cs5535.c
@@ -67,8 +67,6 @@
 
 #define CS5535_CABLE_DETECT    0x48
 
-#define CS5535_BAD_PIO(timings) ( (timings&~0x80000000UL)==0x00009172 )
-
 /**
  *	cs5535_cable_detect	-	detect cable type
  *	@ap: Port to detect on
@@ -188,16 +186,6 @@ static int cs5535_init_one(struct pci_de
 	};
 	const struct ata_port_info *ppi[] = { &info, &ata_dummy_port_info };
 
-	u32 timings, dummy;
-
-	/* Check the BIOS set the initial timing clock. If not set the
-	   timings for PIO0 */
-	rdmsr(ATAC_CH0D0_PIO, timings, dummy);
-	if (CS5535_BAD_PIO(timings))
-		wrmsr(ATAC_CH0D0_PIO, 0xF7F4F7F4UL, 0);
-	rdmsr(ATAC_CH0D1_PIO, timings, dummy);
-	if (CS5535_BAD_PIO(timings))
-		wrmsr(ATAC_CH0D1_PIO, 0xF7F4F7F4UL, 0);
 	return ata_pci_bmdma_init_one(dev, ppi, &cs5535_sht, NULL, 0);
 }
 
