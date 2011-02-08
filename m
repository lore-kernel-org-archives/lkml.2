Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056Ab1BHMYn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 07:24:43 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:61026 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753898Ab1BHMYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 07:24:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=JOC4RQhWDxpE9XK5WxLmo1mYVtqKBMFOfI8BLQbHeL86CFYpmtGDwu78MfcKno4vUV
         8DLO3922yJL8iBKr5yzyCyi/xT7sdOqCnOAIobUGjaWpbLuKuN0ajoE0PR1jr07jhJkI
         FFAV8gB3Tbg1UxxaGZw48GzMVh1w37dWohmrA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Tue, 08 Feb 2011 13:24:31 +0100
Message-Id: <20110208122431.19110.30142.sendpatchset@linux-mhg7.site>
In-Reply-To: <20110208122314.19110.4092.sendpatchset@linux-mhg7.site>
References: <20110208122314.19110.4092.sendpatchset@linux-mhg7.site>
Subject: [PATCH 08/20] pata_it8213: add UDMA100 and UDMA133 support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From d7d8c9c8372230ec596814ca3281564156f94926 Mon Sep 17 00:00:00 2001
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date: Tue, 8 Feb 2011 12:39:26 +0100
Subject: [PATCH 08/20] pata_it8213: add UDMA100 and UDMA133 support

Fixes IDE -> libata regression.

IDE's it8213 host driver has been supporting those modes
(per official documentation) since the initial driver's merge
on Feb 7 2007 (commit 9c6712c0 "ide: add it8213 IDE driver").

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_it8213.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/pata_it8213.c b/drivers/ata/pata_it8213.c
index ccfd1ae..e045eab 100644
--- a/drivers/ata/pata_it8213.c
+++ b/drivers/ata/pata_it8213.c
@@ -164,7 +164,7 @@ static void it8213_set_dmamode (struct ata_port *ap, struct ata_device *adev)
 
 		/* Clocks follow the PIIX style */
 		u_speed = min(2 - (udma & 1), udma);
-		if (udma == 5)
+		if (udma > 4)
 			u_clock = 0x1000;	/* 100Mhz */
 		else if (udma > 2)
 			u_clock = 1;		/* 66Mhz */
@@ -234,7 +234,7 @@ static int it8213_init_one (struct pci_dev *pdev, const struct pci_device_id *en
 		.flags		= ATA_FLAG_SLAVE_POSS,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA12_ONLY,
-		.udma_mask 	= ATA_UDMA4, /* FIXME: want UDMA 100? */
+		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &it8213_ops,
 	};
 	/* Current IT8213 stuff is single port */
-- 
1.7.1

