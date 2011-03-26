Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357Ab1CZRJY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 13:09:24 -0400
Received: from [123.120.158.88] ([123.120.158.88]:35155 "EHLO enigma.site"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752343Ab1CZRIm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 13:08:42 -0400
From: Coly Li <bosong.ly@taobao.com>
To: linux-kernel@vger.kernel.org
Cc: Coly Li <bosong.ly@taobao.com>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Anatolij Gustschin <agust@denx.de>,
        Sean MacLennan <smaclennan@pikatech.com>,
        Joe Perches <joe@perches.com>
Subject: [PATCH 3/4] dma: use BUG_ON correctly in ppc4xx/adam.c, v4
Date: Sun, 27 Mar 2011 01:26:54 +0800
Message-Id: <1301160415-24569-4-git-send-email-bosong.ly@taobao.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1301160415-24569-1-git-send-email-bosong.ly@taobao.com>
References: <1301160415-24569-1-git-send-email-bosong.ly@taobao.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes BUG_ON() usage correct in drivers/dma/ppc4xx/adam.c

Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Anatolij Gustschin <agust@denx.de>
Cc: Sean MacLennan <smaclennan@pikatech.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Coly Li <bosong.ly@taobao.com>
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
1.7.3.4

