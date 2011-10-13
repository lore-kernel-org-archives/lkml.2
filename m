Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756536Ab1JMQL5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 12:11:57 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:37716 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753383Ab1JMQLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 12:11:55 -0400
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH] pata_it8213: add UDMA100 and UDMA133 support
Date: Thu, 13 Oct 2011 18:11:29 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.37.6-0.7-desktop-dirty; KDE/4.6.0; x86_64; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201110131811.30054.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_it8213: add UDMA100 and UDMA133 support

Fixes IDE -> libata regression.

IDE's it8213 host driver has been supporting those modes
(per official documentation) since the initial driver's merge
on Feb 7 2007 (commit 9c6712c0 "ide: add it8213 IDE driver").

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
earlier references:
https://lkml.org/lkml/2011/2/8/105
https://lkml.org/lkml/2009/11/25/324

 drivers/ata/pata_it8213.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: b/drivers/ata/pata_it8213.c
===================================================================
--- a/drivers/ata/pata_it8213.c
+++ b/drivers/ata/pata_it8213.c
@@ -164,7 +164,7 @@ static void it8213_set_dmamode (struct a
 
 		/* Clocks follow the PIIX style */
 		u_speed = min(2 - (udma & 1), udma);
-		if (udma == 5)
+		if (udma > 4)
 			u_clock = 0x1000;	/* 100Mhz */
 		else if (udma > 2)
 			u_clock = 1;		/* 66Mhz */
@@ -234,7 +234,7 @@ static int it8213_init_one (struct pci_d
 		.flags		= ATA_FLAG_SLAVE_POSS,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA12_ONLY,
-		.udma_mask 	= ATA_UDMA4, /* FIXME: want UDMA 100? */
+		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &it8213_ops,
 	};
 	/* Current IT8213 stuff is single port */
