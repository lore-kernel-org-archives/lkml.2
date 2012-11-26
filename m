Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933884Ab2KZRNc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:13:32 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48051 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933866Ab2KZRNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:13:24 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Vinod Koul <vinod.koul@linux.intel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 216/270] dmaengine: imx-dma: fix missing unlock on error in imxdma_xfer_desc()
Date: Mon, 26 Nov 2012 14:58:26 -0200
Message-Id: <1353949160-26803-217-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

commit 720dfd250e48a8c7fd1b2b8645955413989c4ee0 upstream.

Add the missing unlock on the error handling path in function
imxdma_xfer_desc().

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Signed-off-by: Vinod Koul <vinod.koul@linux.intel.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/dma/imx-dma.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/imx-dma.c b/drivers/dma/imx-dma.c
index 5084975..8aa9113 100644
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
-- 
1.7.9.5

