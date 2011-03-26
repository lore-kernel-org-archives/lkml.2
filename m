Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396Ab1CZRIr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 13:08:47 -0400
Received: from [123.120.158.88] ([123.120.158.88]:35156 "EHLO enigma.site"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752325Ab1CZRIp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 13:08:45 -0400
From: Coly Li <bosong.ly@taobao.com>
To: linux-kernel@vger.kernel.org
Cc: Coly Li <bosong.ly@taobao.com>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 2/4] dma: use BUG_ON correctly in mv_xor.c, v4
Date: Sun, 27 Mar 2011 01:26:53 +0800
Message-Id: <1301160415-24569-3-git-send-email-bosong.ly@taobao.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1301160415-24569-1-git-send-email-bosong.ly@taobao.com>
References: <1301160415-24569-1-git-send-email-bosong.ly@taobao.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes BUG_ON() usage correct in drivers/dma/mv_xor.c

Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Coly Li <bosong.ly@taobao.com>
---
 drivers/dma/mv_xor.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/mv_xor.c b/drivers/dma/mv_xor.c
index a25f5f6..954e334 100644
--- a/drivers/dma/mv_xor.c
+++ b/drivers/dma/mv_xor.c
@@ -671,7 +671,7 @@ mv_xor_prep_dma_memcpy(struct dma_chan *chan, dma_addr_t dest, dma_addr_t src,
 	if (unlikely(len < MV_XOR_MIN_BYTE_COUNT))
 		return NULL;
 
-	BUG_ON(unlikely(len > MV_XOR_MAX_BYTE_COUNT));
+	BUG_ON(len > MV_XOR_MAX_BYTE_COUNT);
 
 	spin_lock_bh(&mv_chan->lock);
 	slot_cnt = mv_chan_memcpy_slot_count(len);
@@ -710,7 +710,7 @@ mv_xor_prep_dma_memset(struct dma_chan *chan, dma_addr_t dest, int value,
 	if (unlikely(len < MV_XOR_MIN_BYTE_COUNT))
 		return NULL;
 
-	BUG_ON(unlikely(len > MV_XOR_MAX_BYTE_COUNT));
+	BUG_ON(len > MV_XOR_MAX_BYTE_COUNT);
 
 	spin_lock_bh(&mv_chan->lock);
 	slot_cnt = mv_chan_memset_slot_count(len);
@@ -744,7 +744,7 @@ mv_xor_prep_dma_xor(struct dma_chan *chan, dma_addr_t dest, dma_addr_t *src,
 	if (unlikely(len < MV_XOR_MIN_BYTE_COUNT))
 		return NULL;
 
-	BUG_ON(unlikely(len > MV_XOR_MAX_BYTE_COUNT));
+	BUG_ON(len > MV_XOR_MAX_BYTE_COUNT);
 
 	dev_dbg(mv_chan->device->common.dev,
 		"%s src_cnt: %d len: dest %x %u flags: %ld\n",
-- 
1.7.3.4

