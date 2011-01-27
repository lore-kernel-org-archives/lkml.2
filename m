Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663Ab1A0Lyr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 06:54:47 -0500
Received: from [114.251.86.0] ([114.251.86.0]:25839 "EHLO enigma.site"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754556Ab1A0LyF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 06:54:05 -0500
From: Coly Li <bosong.ly@taobao.com>
To: linux-kernel@vger.kernel.org
Cc: Coly Li <bosong.ly@taobao.com>, Greg KH <gregkh@suse.de>
Subject: [PATCH 5/7] dma: use BUG_ON correctly in ppc4xx/adam.c
Date: Thu, 27 Jan 2011 20:12:34 +0800
Message-Id: <1296130356-29896-6-git-send-email-bosong.ly@taobao.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1296130356-29896-1-git-send-email-bosong.ly@taobao.com>
References: <1296130356-29896-1-git-send-email-bosong.ly@taobao.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes BUG_ON() usage correct in drivers/dma/ppc4xx/adam.c

Signed-off-by: Coly Li <bosong.ly@taobao.com>
Cc: Greg KH <gregkh@suse.de>
---
 drivers/dma/ppc4xx/adma.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/ppc4xx/adma.c b/drivers/dma/ppc4xx/adma.c
index cef5845..a2b62e9 100644
--- a/drivers/dma/ppc4xx/adma.c
+++ b/drivers/dma/ppc4xx/adma.c
@@ -2313,7 +2313,7 @@ static struct dma_async_tx_descriptor *ppc440spe_adma_prep_dma_memcpy(
 	if (unlikely(!len))
 		return NULL;
 
-	BUG_ON(unlikely(len > PPC440SPE_ADMA_DMA_MAX_BYTE_COUNT));
+	BUG_ON(len > PPC440SPE_ADMA_DMA_MAX_BYTE_COUNT);
 
 	spin_lock_bh(&ppc440spe_chan->lock);
 
@@ -2354,7 +2354,7 @@ static struct dma_async_tx_descriptor *ppc440spe_adma_prep_dma_memset(
 	if (unlikely(!len))
 		return NULL;
 
-	BUG_ON(unlikely(len > PPC440SPE_ADMA_DMA_MAX_BYTE_COUNT));
+	BUG_ON(len > PPC440SPE_ADMA_DMA_MAX_BYTE_COUNT);
 
 	spin_lock_bh(&ppc440spe_chan->lock);
 
@@ -2397,7 +2397,7 @@ static struct dma_async_tx_descriptor *ppc440spe_adma_prep_dma_xor(
 				     dma_dest, dma_src, src_cnt));
 	if (unlikely(!len))
 		return NULL;
-	BUG_ON(unlikely(len > PPC440SPE_ADMA_XOR_MAX_BYTE_COUNT));
+	BUG_ON(len > PPC440SPE_ADMA_XOR_MAX_BYTE_COUNT);
 
 	dev_dbg(ppc440spe_chan->device->common.dev,
 		"ppc440spe adma%d: %s src_cnt: %d len: %u int_en: %d\n",
@@ -2887,7 +2887,7 @@ static struct dma_async_tx_descriptor *ppc440spe_adma_prep_dma_pq(
 	ADMA_LL_DBG(prep_dma_pq_dbg(ppc440spe_chan->device->id,
 				    dst, src, src_cnt));
 	BUG_ON(!len);
-	BUG_ON(unlikely(len > PPC440SPE_ADMA_XOR_MAX_BYTE_COUNT));
+	BUG_ON(len > PPC440SPE_ADMA_XOR_MAX_BYTE_COUNT);
 	BUG_ON(!src_cnt);
 
 	if (src_cnt == 1 && dst[1] == src[0]) {
-- 
1.7.3.2

