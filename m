Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751970Ab1GYPhy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 11:37:54 -0400
Received: from casper.infradead.org ([85.118.1.10]:36519 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431Ab1GYPhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 11:37:52 -0400
Subject: [PATCH] dmaengine: add helper function for slave_single
From: Vinod Koul <vkoul@infradead.org>
To: Dan Williams <dan.j.williams@intel.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: vinod.koul@intel.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Organization: Intel Corp
Date: Mon, 25 Jul 2011 21:07:15 +0530
Message-ID: <1311608235.8206.24.camel@vkoul-mobl4>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From af9afd16e9954edb45f0cf71834653133d75e79c Mon Sep 17 00:00:00 2001
From: Vinod Koul <vinod.koul@intel.com>
Date: Mon, 25 Jul 2011 19:57:52 +0530
Subject: [PATCH] dmaengine: add helper function for slave_single

For clients which require a single slave transfer and dont want to be bothered
about the scatterlist api, this helper gives simple API for this transfer and
creates single scatterlist for DMA API

Idea from Russel King

Signed-off-by: Vinod Koul <vinod.koul@intel.com>
---
 include/linux/dmaengine.h |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index eee7add..97dafc6 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -517,6 +517,16 @@ static inline int dmaengine_slave_config(struct dma_chan *chan,
 			(unsigned long)config);
 }
 
+static inline struct dma_async_tx_descriptor *dmaengine_prep_slave_single(
+	struct dma_chan *chan, void *buf, size_t len,
+	enum dma_data_direction dir, unsigned long flags)
+{
+	struct scatterlist sg;
+	sg_init_one(&sg, buf, len);
+
+	return chan->device->device_prep_slave_sg(chan, &sg, 1, dir, flags);
+}
+
 static inline int dmaengine_terminate_all(struct dma_chan *chan)
 {
 	return dmaengine_device_control(chan, DMA_TERMINATE_ALL, 0);
-- 
1.7.0.4




-- 
~Vinod Koul
Intel Corp.

