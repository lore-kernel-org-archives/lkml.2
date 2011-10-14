Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932459Ab1JNFrR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 01:47:17 -0400
Received: from mga14.intel.com ([143.182.124.37]:19902 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932431Ab1JNFrO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 01:47:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,344,1315206000"; 
   d="scan'208";a="62486999"
From: Vinod Koul <vinod.koul@intel.com>
To: dan.j.williams@intel.com
Cc: linux-kernel@vger.kernel.org, jaswinder.singh@linaro.org,
        21cnbao@gmail.com, rmk@arm.linux.org.uk,
        Vinod Koul <vinod.koul@linux.intel.com>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Boojin Kim <boojin.kim@samsung.com>
Subject: [PATCH 03/10] plat-samsung: move to dma_transfer_direction
Date: Fri, 14 Oct 2011 11:08:18 +0530
Message-Id: <1318570705-17595-4-git-send-email-vinod.koul@intel.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1318570705-17595-1-git-send-email-vinod.koul@intel.com>
References: <1318570705-17595-1-git-send-email-vinod.koul@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vinod Koul <vinod.koul@linux.intel.com>

Signed-off-by: Vinod Koul <vinod.koul@linux.intel.com>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: Boojin Kim <boojin.kim@samsung.com>
---
 arch/arm/plat-samsung/dma-ops.c              |    4 ++--
 arch/arm/plat-samsung/include/plat/dma-ops.h |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/plat-samsung/dma-ops.c b/arch/arm/plat-samsung/dma-ops.c
index 6e3d9ab..a044171 100644
--- a/arch/arm/plat-samsung/dma-ops.c
+++ b/arch/arm/plat-samsung/dma-ops.c
@@ -35,14 +35,14 @@ static unsigned samsung_dmadev_request(enum dma_ch dma_ch,
 
 	chan = dma_request_channel(mask, pl330_filter, (void *)dma_ch);
 
-	if (info->direction == DMA_FROM_DEVICE) {
+	if (info->direction == DEV_TO_MEM) {
 		memset(&slave_config, 0, sizeof(struct dma_slave_config));
 		slave_config.direction = info->direction;
 		slave_config.src_addr = info->fifo;
 		slave_config.src_addr_width = info->width;
 		slave_config.src_maxburst = 1;
 		dmaengine_slave_config(chan, &slave_config);
-	} else if (info->direction == DMA_TO_DEVICE) {
+	} else if (info->direction == MEM_TO_DEV) {
 		memset(&slave_config, 0, sizeof(struct dma_slave_config));
 		slave_config.direction = info->direction;
 		slave_config.dst_addr = info->fifo;
diff --git a/arch/arm/plat-samsung/include/plat/dma-ops.h b/arch/arm/plat-samsung/include/plat/dma-ops.h
index 4c1a363..1256115 100644
--- a/arch/arm/plat-samsung/include/plat/dma-ops.h
+++ b/arch/arm/plat-samsung/include/plat/dma-ops.h
@@ -17,7 +17,7 @@
 
 struct samsung_dma_prep_info {
 	enum dma_transaction_type cap;
-	enum dma_data_direction direction;
+	enum dma_transfer_direction direction;
 	dma_addr_t buf;
 	unsigned long period;
 	unsigned long len;
@@ -27,7 +27,7 @@ struct samsung_dma_prep_info {
 
 struct samsung_dma_info {
 	enum dma_transaction_type cap;
-	enum dma_data_direction direction;
+	enum dma_transfer_direction direction;
 	enum dma_slave_buswidth width;
 	dma_addr_t fifo;
 	struct s3c2410_dma_client *client;
-- 
1.7.0.4

