Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932737Ab2BBVdt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 16:33:49 -0500
Received: from mxout1.idt.com ([157.165.5.25]:57373 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757431Ab2BBVdq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 16:33:46 -0500
From: Alexandre Bounine <alexandre.bounine@idt.com>
To: vinod.koul@intel.com, dan.j.williams@intel.com,
        linux-kernel@vger.kernel.org
Cc: Alexandre Bounine <alexandre.bounine@idt.com>, akpm@linux-foundation.org,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Russell King <rmk@arm.linux.org.uk>,
        Kumar Gala <galak@kernel.crashing.org>,
        Matt Porter <mporter@kernel.crashing.org>,
        Li Yang <leoli@freescale.com>
Subject: [PATCH 01/11] dmaengine: add context parameter to prep_slave_sg and prep_dma_cyclic
Date: Thu,  2 Feb 2012 16:32:11 -0500
Message-Id: <1328218341-31436-2-git-send-email-alexandre.bounine@idt.com>
X-Mailer: git-send-email 1.7.8.4
In-Reply-To: <1328218341-31436-1-git-send-email-alexandre.bounine@idt.com>
References: <1328218341-31436-1-git-send-email-alexandre.bounine@idt.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add context parameter to device_prep_slave_sg() and device_prep_dma_cyclic()
interfaces to allow passing client/target specific information associated
with the data transfer.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Jassi Brar <jaswinder.singh@linaro.org>
Cc: Russell King <rmk@arm.linux.org.uk> 
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
---
 include/linux/dmaengine.h |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 679b349..2251bfa 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -575,10 +575,11 @@ struct dma_device {
 	struct dma_async_tx_descriptor *(*device_prep_slave_sg)(
 		struct dma_chan *chan, struct scatterlist *sgl,
 		unsigned int sg_len, enum dma_transfer_direction direction,
-		unsigned long flags);
+		unsigned long flags, void *context);
 	struct dma_async_tx_descriptor *(*device_prep_dma_cyclic)(
 		struct dma_chan *chan, dma_addr_t buf_addr, size_t buf_len,
-		size_t period_len, enum dma_transfer_direction direction);
+		size_t period_len, enum dma_transfer_direction direction,
+		void *context);
 	struct dma_async_tx_descriptor *(*device_prep_interleaved_dma)(
 		struct dma_chan *chan, struct dma_interleaved_template *xt,
 		unsigned long flags);
@@ -607,12 +608,13 @@ static inline int dmaengine_slave_config(struct dma_chan *chan,
 
 static inline struct dma_async_tx_descriptor *dmaengine_prep_slave_single(
 	struct dma_chan *chan, void *buf, size_t len,
-	enum dma_transfer_direction dir, unsigned long flags)
+	enum dma_transfer_direction dir, unsigned long flags, void *context)
 {
 	struct scatterlist sg;
 	sg_init_one(&sg, buf, len);
 
-	return chan->device->device_prep_slave_sg(chan, &sg, 1, dir, flags);
+	return chan->device->device_prep_slave_sg(chan, &sg, 1, dir, flags,
+						  context);
 }
 
 static inline int dmaengine_terminate_all(struct dma_chan *chan)
-- 
1.7.8.4

