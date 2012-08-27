Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751747Ab2H0Ekn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 00:40:43 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:62738 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771Ab2H0Ekm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 00:40:42 -0400
MIME-Version: 1.0
Date: Mon, 27 Aug 2012 12:40:42 +0800
Message-ID: <CAPgLHd-GhyvXvS0iKCwP_fcp8EsUeihjp6HSpLLbWtQiz06zuQ@mail.gmail.com>
Subject: [PATCH] dmaengine: use kmem_cache_zalloc instead of kmem_cache_alloc/memset
From: Wei Yongjun <weiyj.lk@gmail.com>
To: vinod.koul@intel.com, djbw@fb.com
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Using kmem_cache_zalloc() instead of kmem_cache_alloc() and memset().

spatch with a semantic match is used to found this problem.
(http://coccinelle.lip6.fr/)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/dma/ioat/dma_v2.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/dma/ioat/dma_v2.c b/drivers/dma/ioat/dma_v2.c
index 8689576..b9d6678 100644
--- a/drivers/dma/ioat/dma_v2.c
+++ b/drivers/dma/ioat/dma_v2.c
@@ -434,12 +434,11 @@ static struct ioat_ring_ent *ioat2_alloc_ring_ent(struct dma_chan *chan, gfp_t f
 		return NULL;
 	memset(hw, 0, sizeof(*hw));
 
-	desc = kmem_cache_alloc(ioat2_cache, flags);
+	desc = kmem_cache_zalloc(ioat2_cache, flags);
 	if (!desc) {
 		pci_pool_free(dma->dma_pool, hw, phys);
 		return NULL;
 	}
-	memset(desc, 0, sizeof(*desc));
 
 	dma_async_tx_descriptor_init(&desc->txd, chan);
 	desc->txd.tx_submit = ioat2_tx_submit_unlock;

