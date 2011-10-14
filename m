Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932426Ab1JNFrD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 01:47:03 -0400
Received: from mga03.intel.com ([143.182.124.21]:40732 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755422Ab1JNFrA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 01:47:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,344,1315206000"; 
   d="scan'208";a="62486948"
From: Vinod Koul <vinod.koul@intel.com>
To: dan.j.williams@intel.com
Cc: linux-kernel@vger.kernel.org, jaswinder.singh@linaro.org,
        21cnbao@gmail.com, rmk@arm.linux.org.uk,
        Vinod Koul <vinod.koul@linux.intel.com>
Subject: [PATCH 01/10] dmaengine: add new enum dma_transfer_direction
Date: Fri, 14 Oct 2011 11:08:16 +0530
Message-Id: <1318570705-17595-2-git-send-email-vinod.koul@intel.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1318570705-17595-1-git-send-email-vinod.koul@intel.com>
References: <1318570705-17595-1-git-send-email-vinod.koul@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vinod Koul <vinod.koul@linux.intel.com>

This new enum removes usage of dma_data_direction for dma direction. The new
enum cleans tells the DMA direction and mode
This further paves way for merging the dmaengine _prep operations and also for
interleaved dma

Suggested-by: Jassi Brar <jaswinder.singh@linaro.org>
Signed-off-by: Vinod Koul <vinod.koul@linux.intel.com>
---
 include/linux/dmaengine.h |   22 +++++++++++++++++-----
 1 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index ace51af..24942ad 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -23,7 +23,6 @@
 
 #include <linux/device.h>
 #include <linux/uio.h>
-#include <linux/dma-direction.h>
 #include <linux/scatterlist.h>
 
 /**
@@ -75,6 +74,19 @@ enum dma_transaction_type {
 /* last transaction type for creation of the capabilities mask */
 #define DMA_TX_TYPE_END (DMA_CYCLIC + 1)
 
+/**
+ * enum dma_transfer_direction - dma transfer mode and direction indicator
+ * @MEM_TO_MEM: Async/Memcpy mode
+ * @MEM_TO_DEV: Slave mode & From Memory to Device
+ * @DEV_TO_MEM: Slave mode & From Device to Memory
+ * @DEV_TO_DEV: Slave mode & From Device to Device
+ */
+enum dma_transfer_direction {
+	MEM_TO_MEM,
+	MEM_TO_DEV,
+	DEV_TO_MEM,
+	DEV_TO_DEV,
+};
 
 /**
  * enum dma_ctrl_flags - DMA flags to augment operation preparation,
@@ -267,7 +279,7 @@ enum dma_slave_buswidth {
  * struct, if applicable.
  */
 struct dma_slave_config {
-	enum dma_data_direction direction;
+	enum dma_transfer_direction direction;
 	dma_addr_t src_addr;
 	dma_addr_t dst_addr;
 	enum dma_slave_buswidth src_addr_width;
@@ -490,11 +502,11 @@ struct dma_device {
 
 	struct dma_async_tx_descriptor *(*device_prep_slave_sg)(
 		struct dma_chan *chan, struct scatterlist *sgl,
-		unsigned int sg_len, enum dma_data_direction direction,
+		unsigned int sg_len, enum dma_transfer_direction direction,
 		unsigned long flags);
 	struct dma_async_tx_descriptor *(*device_prep_dma_cyclic)(
 		struct dma_chan *chan, dma_addr_t buf_addr, size_t buf_len,
-		size_t period_len, enum dma_data_direction direction);
+		size_t period_len, enum dma_transfer_direction direction);
 	int (*device_control)(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 		unsigned long arg);
 
@@ -520,7 +532,7 @@ static inline int dmaengine_slave_config(struct dma_chan *chan,
 
 static inline struct dma_async_tx_descriptor *dmaengine_prep_slave_single(
 	struct dma_chan *chan, void *buf, size_t len,
-	enum dma_data_direction dir, unsigned long flags)
+	enum dma_transfer_direction dir, unsigned long flags)
 {
 	struct scatterlist sg;
 	sg_init_one(&sg, buf, len);
-- 
1.7.0.4

