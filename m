Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976Ab2CLKcd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 06:32:33 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:59073 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752614Ab2CLKcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 06:32:31 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6646"; a="169288245"
From: Ravi Kumar V <kumarrav@codeaurora.org>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
        David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, Ravi Kumar V <kumarrav@codeaurora.org>
Subject: [PATCH v3 1/2] dmaengine: Add support for per xfer specific privatedata
Date: Mon, 12 Mar 2012 16:02:16 +0530
Message-Id: <1331548336-27802-1-git-send-email-kumarrav@codeaurora.org>
X-Mailer: git-send-email 1.7.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add new argument to DMA SG and Interleave mode for passing
per transfer specific private data, using this it enables the
dma devices which needs to pass the parameters which changes per
each transfer.

Signed-off-by: Ravi Kumar V <kumarrav@codeaurora.org>
---
 include/linux/dmaengine.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 679b349..b8f0495 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -570,7 +570,7 @@ struct dma_device {
 		struct dma_chan *chan,
 		struct scatterlist *dst_sg, unsigned int dst_nents,
 		struct scatterlist *src_sg, unsigned int src_nents,
-		unsigned long flags);
+		unsigned long flags, void *context);
 
 	struct dma_async_tx_descriptor *(*device_prep_slave_sg)(
 		struct dma_chan *chan, struct scatterlist *sgl,
@@ -581,7 +581,7 @@ struct dma_device {
 		size_t period_len, enum dma_transfer_direction direction);
 	struct dma_async_tx_descriptor *(*device_prep_interleaved_dma)(
 		struct dma_chan *chan, struct dma_interleaved_template *xt,
-		unsigned long flags);
+		unsigned long flags, void *context);
 	int (*device_control)(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 		unsigned long arg);
 
-- 
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

