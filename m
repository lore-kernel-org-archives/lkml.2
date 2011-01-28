Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371Ab1A1RiI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 12:38:08 -0500
Received: from [123.122.102.109] ([123.122.102.109]:36391 "EHLO enigma.site"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754009Ab1A1Rhs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 12:37:48 -0500
From: Coly Li <bosong.ly@taobao.com>
To: linux-kernel@vger.kernel.org
Cc: Coly Li <bosong.ly@taobao.com>, Greg KH <gregkh@suse.de>
Subject: [PATCH 2/5] dma: use BUG_ON correctly in mv_xor.c, v3
Date: Sat, 29 Jan 2011 01:55:47 +0800
Message-Id: <1296237350-6624-3-git-send-email-bosong.ly@taobao.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1296237350-6624-1-git-send-email-bosong.ly@taobao.com>
References: <1296237350-6624-1-git-send-email-bosong.ly@taobao.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes BUG_ON() usage correct in drivers/dma/mv_xor.c

Signed-off-by: Coly Li <bosong.ly@taobao.com>
Cc: Greg KH <gregkh@suse.de>
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

