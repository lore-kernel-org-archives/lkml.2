Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753096Ab2JUL6c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 07:58:32 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:63128 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752728Ab2JUL6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 07:58:31 -0400
MIME-Version: 1.0
Date: Sun, 21 Oct 2012 19:58:30 +0800
Message-ID: <CAPgLHd-RVCk=cqiOuTYdFzgTkEp25PrjqZ+Og4PdHG+1a8ayWA@mail.gmail.com>
Subject: [PATCH] dmaengine: imx-dma: fix missing unlock on error in imxdma_xfer_desc()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: djbw@fb.com, vinod.koul@intel.com
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Add the missing unlock on the error handling path in function
imxdma_xfer_desc().

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/dma/imx-dma.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/imx-dma.c b/drivers/dma/imx-dma.c
index f11b5b2..7d9554c 100644
--- a/drivers/dma/imx-dma.c
+++ b/drivers/dma/imx-dma.c
@@ -474,8 +474,10 @@ static int imxdma_xfer_desc(struct imxdma_desc *d)
 			slot = i;
 			break;
 		}
-		if (slot < 0)
+		if (slot < 0) {
+			spin_unlock_irqrestore(&imxdma->lock, flags);
 			return -EBUSY;
+		}
 
 		imxdma->slots_2d[slot].xsr = d->x;
 		imxdma->slots_2d[slot].ysr = d->y;


