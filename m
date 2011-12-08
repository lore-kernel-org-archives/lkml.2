Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318Ab1LHIQR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 03:16:17 -0500
Received: from mail.karo-electronics.de ([81.173.242.67]:65486 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105Ab1LHIQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 03:16:02 -0500
From: =?utf-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Huang Shijie <b32955@freescale.com>, Wolfram Sang <w.sang@pengutronix.de>,
        linux-kernel@vger.kernel.org,
        =?utf-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
Subject: [PATCH 2/4] dma: mxs-dma: Always leave mxs_dma_init() with the clock disabled.
Date: Thu,  8 Dec 2011 09:15:42 +0100
Message-Id: <a1132406901d44f33dcbd3553af8ea32d5a9044e.1323176362.git.LW@KARO-electronics.de>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <95cce41674a2ad03ecd55190ec184eab0069fe3a.1323176362.git.LW@KARO-electronics.de>
References: <cover.1323176362.git.LW@KARO-electronics.de>
 <95cce41674a2ad03ecd55190ec184eab0069fe3a.1323176362.git.LW@KARO-electronics.de>
In-Reply-To: <cover.1323176362.git.LW@KARO-electronics.de>
References: <cover.1323176362.git.LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to have the clock enabled all the time the driver is
loaded.
It will be enabled anyway in mxs_dma_alloc_chan_resources() when a
channel is actually going to be used.

Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
---
 drivers/dma/mxs-dma.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/dma/mxs-dma.c b/drivers/dma/mxs-dma.c
index f228f55..c7574e8 100644
--- a/drivers/dma/mxs-dma.c
+++ b/drivers/dma/mxs-dma.c
@@ -580,7 +580,7 @@ static int __init mxs_dma_init(struct mxs_dma_engine *mxs_dma)
 
 	ret = clk_enable(mxs_dma->clk);
 	if (ret)
-		goto err_out;
+		return ret;
 
 	ret = mxs_reset_block(mxs_dma->base);
 	if (ret)
@@ -604,11 +604,8 @@ static int __init mxs_dma_init(struct mxs_dma_engine *mxs_dma)
 	writel(MXS_DMA_CHANNELS_MASK << MXS_DMA_CHANNELS,
 		mxs_dma->base + HW_APBHX_CTRL1 + MXS_SET_ADDR);
 
-	clk_disable(mxs_dma->clk);
-
-	return 0;
-
 err_out:
+	clk_disable(mxs_dma->clk);
 	return ret;
 }
 
-- 
1.5.6.5

