Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754965Ab1LMPkS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 10:40:18 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44326 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753810Ab1LMPkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 10:40:15 -0500
From: Shawn Guo <shawn.guo@linaro.org>
To: Vinod Koul <vinod.koul@intel.com>, Chris Ball <cjb@laptop.org>,
        Artem Bityutskiy <artem.bityutskiy@intel.com>
Cc: Huang Shijie <b32955@freescale.com>, linux-mmc@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH 1/4] dmaengine: add DMA_TRANS_NONE to dma_transfer_direction
Date: Tue, 13 Dec 2011 23:48:03 +0800
Message-Id: <1323791286-29574-2-git-send-email-shawn.guo@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1323791286-29574-1-git-send-email-shawn.guo@linaro.org>
References: <1323791286-29574-1-git-send-email-shawn.guo@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before dma_transfer_direction was introduced to replace
dma_data_direction, some dmaengine device uses DMA_NONE of
dma_data_direction for some talk with its client drivers.
The mxs-dma and its clients mxs-mmc and gpmi-nand are such case.

This patch adds DMA_TRANS_NONE to dma_transfer_direction and
migrate the DMA_NONE use in mxs-dma to it.

It also fixes the compile warning below.

CC      drivers/dma/mxs-dma.o
drivers/dma/mxs-dma.c: In function ‘mxs_dma_prep_slave_sg’:
drivers/dma/mxs-dma.c:420:16: warning: comparison between ‘enum dma_transfer_direction’ and ‘enum dma_data_direction’

Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
---
 drivers/dma/mxs-dma.c     |    2 +-
 include/linux/dmaengine.h |    1 +
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/mxs-dma.c b/drivers/dma/mxs-dma.c
index bdf4672..ff89211 100644
--- a/drivers/dma/mxs-dma.c
+++ b/drivers/dma/mxs-dma.c
@@ -417,7 +417,7 @@ static struct dma_async_tx_descriptor *mxs_dma_prep_slave_sg(
 		idx = 0;
 	}
 
-	if (direction == DMA_NONE) {
+	if (direction == DMA_TRANS_NONE) {
 		ccw = &mxs_chan->ccw[idx++];
 		pio = (u32 *) sgl;
 
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 5532bb8..679b349 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -88,6 +88,7 @@ enum dma_transfer_direction {
 	DMA_MEM_TO_DEV,
 	DMA_DEV_TO_MEM,
 	DMA_DEV_TO_DEV,
+	DMA_TRANS_NONE,
 };
 
 /**
-- 
1.7.4.1

