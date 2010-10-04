Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327Ab0JDKyK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 06:54:10 -0400
Received: from mga01.intel.com ([192.55.52.88]:34254 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754967Ab0JDKyI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 06:54:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,277,1283756400"; 
   d="scan'208";a="613062033"
From: Vinod Koul <vinod.koul@intel.com>
To: dan.j.williams@intel.com, linux-kernel@vger.kernel.org,
        alan@linux.intel.com, ramesh.b.k.v@intel.com,
        yong.y.wang@linux.intel.com
Cc: Vinod Koul <vinod.koul@intel.com>
Subject: [PATCH 5/6] intel_mid_dma: fix the WARN_ONs
Date: Mon,  4 Oct 2010 16:08:25 +0530
Message-Id: <1286188705-6305-1-git-send-email-vinod.koul@intel.com>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moved the WARN_ON to BUG_ON, as WARN_ON if hit,
can cause null pointer derefrences

Signed-off-by: Vinod Koul <vinod.koul@intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 drivers/dma/intel_mid_dma.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/intel_mid_dma.c b/drivers/dma/intel_mid_dma.c
index 2ae1086..ef7ffb8 100644
--- a/drivers/dma/intel_mid_dma.c
+++ b/drivers/dma/intel_mid_dma.c
@@ -581,15 +581,15 @@ static struct dma_async_tx_descriptor *intel_mid_dma_prep_memcpy(
 	enum intel_mid_dma_width width = 0;
 
 	pr_debug("MDMA: Prep for memcpy\n");
-	WARN_ON(!chan);
+	BUG_ON(!chan);
 	if (!len)
 		return NULL;
 
 	mids = chan->private;
-	WARN_ON(!mids);
+	BUG_ON(!mids);
 
 	midc = to_intel_mid_dma_chan(chan);
-	WARN_ON(!midc);
+	BUG_ON(!midc);
 
 	pr_debug("MDMA:called for DMA %x CH %d Length %zu\n",
 				midc->dma->pci_id, midc->ch_id, len);
-- 
1.6.6.1

