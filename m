Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759570Ab0JZKSi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 06:18:38 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:60804 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759305Ab0JZKS2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 06:18:28 -0400
From: Julia Lawall <julia@diku.dk>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: kernel-janitors@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 14/14] drivers/ata/pata_octeon_cf.c: delete double assignment
Date: Tue, 26 Oct 2010 12:25:43 +0200
Message-Id: <1288088743-3725-15-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1288088743-3725-1-git-send-email-julia@diku.dk>
References: <1288088743-3725-1-git-send-email-julia@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Delete successive assignments to the same location.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression i;
@@

*i = ...;
 i = ...;
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/ata/pata_octeon_cf.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/ata/pata_octeon_cf.c b/drivers/ata/pata_octeon_cf.c
index 74b8298..fa1b95a 100644
--- a/drivers/ata/pata_octeon_cf.c
+++ b/drivers/ata/pata_octeon_cf.c
@@ -653,8 +653,6 @@ static irqreturn_t octeon_cf_interrupt(int irq, void *dev_instance)
 
 		ap = host->ports[i];
 		ocd = ap->dev->platform_data;
-
-		ocd = ap->dev->platform_data;
 		cf_port = ap->private_data;
 		dma_int.u64 =
 			cvmx_read_csr(CVMX_MIO_BOOT_DMA_INTX(ocd->dma_engine));

