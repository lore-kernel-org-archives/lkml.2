Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758715Ab0HECzZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 22:55:25 -0400
Received: from mga01.intel.com ([192.55.52.88]:33096 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756958Ab0HECzW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 22:55:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,319,1278313200"; 
   d="scan'208";a="593084088"
Date: Thu, 5 Aug 2010 10:38:43 +0800
From: Yong Wang <yong.y.wang@linux.intel.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] DMAENGINE: pch_dma: kill another usage of
	__raw_{read|write}l
Message-ID: <20100805023843.GA30411@ywang-moblin2.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use {read|write}l instead of __raw_{read|write}l since PCH DMA
controller is PCI device.

Signed-off-by: Yong Wang <yong.y.wang@intel.com>
---
 drivers/dma/pch_dma.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/pch_dma.c b/drivers/dma/pch_dma.c
index 37139ca..3533948 100644
--- a/drivers/dma/pch_dma.c
+++ b/drivers/dma/pch_dma.c
@@ -133,9 +133,9 @@ struct pch_dma {
 #define PCH_DMA_STS1	0x14
 
 #define dma_readl(pd, name) \
-	__raw_readl((pd)->membase + PCH_DMA_##name)
+	readl((pd)->membase + PCH_DMA_##name)
 #define dma_writel(pd, name, val) \
-	__raw_writel((val), (pd)->membase + PCH_DMA_##name)
+	writel((val), (pd)->membase + PCH_DMA_##name)
 
 static inline struct pch_dma_desc *to_pd_desc(struct dma_async_tx_descriptor *txd)
 {
-- 
1.5.5.1

