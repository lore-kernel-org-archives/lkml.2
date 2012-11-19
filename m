Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751600Ab2KSGmt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 01:42:49 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:44281 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365Ab2KSGms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 01:42:48 -0500
From: Shubhrajyoti D <shubhrajyoti@ti.com>
To: <spi-devel-general@lists.sourceforge.net>
CC: <broonie@opensource.wolfsonmicro.com>, <grant.likely@secretlab.ca>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Shubhrajyoti D <shubhrajyoti@ti.com>
Subject: [PATCH] spi: omap2-mcspi: Fix the redifine warning
Date: Mon, 19 Nov 2012 12:12:29 +0530
Message-ID: <1353307349-4611-1-git-send-email-shubhrajyoti@ti.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the below warning
drivers/spi/spi-omap2-mcspi.c:336:34: warning: symbol 'tx' shadows an earlier one
drivers/spi/spi-omap2-mcspi.c:327:12: originally declared here

So delete the u8 tx as it is assigned and not used(resigned afterwards).

Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
---
 drivers/spi/spi-omap2-mcspi.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/spi-omap2-mcspi.c b/drivers/spi/spi-omap2-mcspi.c
index 251f6d0..c3dcfb3 100644
--- a/drivers/spi/spi-omap2-mcspi.c
+++ b/drivers/spi/spi-omap2-mcspi.c
@@ -323,14 +323,11 @@ static void omap2_mcspi_tx_dma(struct spi_device *spi,
 	struct omap2_mcspi	*mcspi;
 	struct omap2_mcspi_dma  *mcspi_dma;
 	unsigned int		count;
-	const u8		* tx;
 
 	mcspi = spi_master_get_devdata(spi->master);
 	mcspi_dma = &mcspi->dma_channels[spi->chip_select];
 	count = xfer->len;
 
-	tx = xfer->tx_buf;
-
 	if (mcspi_dma->dma_tx) {
 		struct dma_async_tx_descriptor *tx;
 		struct scatterlist sg;
-- 
1.7.5.4

