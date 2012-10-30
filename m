Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933918Ab2J3P7D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 11:59:03 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:49627 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932350Ab2J3P67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 11:58:59 -0400
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-kernel@vger.kernel.org
Cc: djbw@fb.com, vinod.koul@intel.com,
        Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH] dmaengine: imx-dma: Disable use of hw_chain to fix sg_dma transfers.
Date: Tue, 30 Oct 2012 16:58:50 +0100
Message-Id: <1351612730-19029-1-git-send-email-javier.martin@vista-silicon.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HW chaining is currently broken in imx-dma. It can be easily reproduced doing
intensive accesses to a external MMC card and checking how the file system
is corrupted.

Preventing the driver to use HW chaining solves these issues.


Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
---
 drivers/dma/imx-dma.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/imx-dma.c b/drivers/dma/imx-dma.c
index 5084975..03f3b64 100644
--- a/drivers/dma/imx-dma.c
+++ b/drivers/dma/imx-dma.c
@@ -643,9 +643,8 @@ static int imxdma_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 			break;
 		}
 
-		imxdmac->hw_chaining = 1;
-		if (!imxdma_hw_chain(imxdmac))
-			return -EINVAL;
+		imxdmac->hw_chaining = 0;
+
 		imxdmac->ccr_from_device = (mode | IMX_DMA_TYPE_FIFO) |
 			((IMX_DMA_MEMSIZE_32 | IMX_DMA_TYPE_LINEAR) << 2) |
 			CCR_REN;
-- 
1.7.9.5

