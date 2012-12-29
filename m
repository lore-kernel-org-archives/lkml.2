Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276Ab2L2UwH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2012 15:52:07 -0500
Received: from mail-ee0-f54.google.com ([74.125.83.54]:48135 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753077Ab2L2UwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2012 15:52:05 -0500
From: ahemaily@gmail.com
To: tony@atomide.com
Cc: linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        ahemaily <ahemaily@gmail.com>
Subject: [PATCH 1/1] arm :omap :DMA:  fix a bug on reserving the omap SDMA channels 
Date: Sat, 29 Dec 2012 22:43:20 +0200
Message-Id: <1356813800-4705-1-git-send-email-ahemaily@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: ahemaily <ahemaily@gmail.com>

The variable  dma_lch_count  used for comparison  (omap_dma_reserve_channels <= dma_lch_count)
before it initialized to the value from omap_dma_dev_attr : d->lch_count.

I change the place of dma_lch_count initialization to be before the comparison.

Signed-off-by: Abdelrahman Hemaily <ahemaily@gmail.com>
---
 arch/arm/plat-omap/dma.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/plat-omap/dma.c b/arch/arm/plat-omap/dma.c
index c76ed8b..cb3e321 100644
--- a/arch/arm/plat-omap/dma.c
+++ b/arch/arm/plat-omap/dma.c
@@ -2014,12 +2014,12 @@ static int __devinit omap_system_dma_probe(struct platform_device *pdev)
 
 	d			= p->dma_attr;
 	errata			= p->errata;
-
+	dma_lch_count           = d->lch_count;
+
 	if ((d->dev_caps & RESERVE_CHANNEL) && omap_dma_reserve_channels
 			&& (omap_dma_reserve_channels <= dma_lch_count))
 		d->lch_count	= omap_dma_reserve_channels;
 
-	dma_lch_count		= d->lch_count;
 	dma_chan_count		= dma_lch_count;
 	dma_chan		= d->chan;
 	enable_1510_mode	= d->dev_caps & ENABLE_1510_MODE;
-- 
1.7.9.5

