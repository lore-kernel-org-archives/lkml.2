Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460Ab0LVNqt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 08:46:49 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:64453 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752901Ab0LVNqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 08:46:48 -0500
Date: Wed, 22 Dec 2010 14:46:46 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: linux-kernel@vger.kernel.org
cc: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH] dmaengine: provide dummy functions for DMA_ENGINE=n
Message-ID: <Pine.LNX.4.64.1012221444300.14483@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:F8p02zNWucKkP9ZQlqYHzHBLmi+PCCXAQk1DpBZ9rNW
 C2yXHOOUlAwUk/F3mz+jEDv6pF7ME7NboaVJxsNUroPQIBAwb2
 SnaFUxB+Xi64iCAREAHtRfHZCPG7klKGSCFdoddrHs4ZyJ+ASb
 /KVL1KJsdI79zVB/OUwuHY/F5vo6fiux73LHlISkjxJfSqI2IC
 MbWmVWtU2uYdjHp1BJdGIP1QZGo+9nyjHLrLBSjigE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This lets drivers, optionally using the dmaengine, build with DMA_ENGINE
unselected.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 include/linux/dmaengine.h |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 9d8688b..8cd00ad 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -824,6 +824,8 @@ enum dma_status dma_sync_wait(struct dma_chan *chan, dma_cookie_t cookie);
 #ifdef CONFIG_DMA_ENGINE
 enum dma_status dma_wait_for_async_tx(struct dma_async_tx_descriptor *tx);
 void dma_issue_pending_all(void);
+struct dma_chan *__dma_request_channel(dma_cap_mask_t *mask, dma_filter_fn fn, void *fn_param);
+void dma_release_channel(struct dma_chan *chan);
 #else
 static inline enum dma_status dma_wait_for_async_tx(struct dma_async_tx_descriptor *tx)
 {
@@ -831,7 +833,14 @@ static inline enum dma_status dma_wait_for_async_tx(struct dma_async_tx_descript
 }
 static inline void dma_issue_pending_all(void)
 {
-	do { } while (0);
+}
+static inline struct dma_chan *__dma_request_channel(dma_cap_mask_t *mask,
+					      dma_filter_fn fn, void *fn_param)
+{
+	return NULL;
+}
+static inline void dma_release_channel(struct dma_chan *chan)
+{
 }
 #endif
 
@@ -842,8 +851,6 @@ void dma_async_device_unregister(struct dma_device *device);
 void dma_run_dependencies(struct dma_async_tx_descriptor *tx);
 struct dma_chan *dma_find_channel(enum dma_transaction_type tx_type);
 #define dma_request_channel(mask, x, y) __dma_request_channel(&(mask), x, y)
-struct dma_chan *__dma_request_channel(dma_cap_mask_t *mask, dma_filter_fn fn, void *fn_param);
-void dma_release_channel(struct dma_chan *chan);
 
 /* --- Helper iov-locking functions --- */
 
-- 
1.7.2.3

