Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282Ab1CZRIn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 13:08:43 -0400
Received: from [123.120.158.88] ([123.120.158.88]:35153 "EHLO enigma.site"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752212Ab1CZRIk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 13:08:40 -0400
From: Coly Li <bosong.ly@taobao.com>
To: linux-kernel@vger.kernel.org
Cc: Coly Li <bosong.ly@taobao.com>, Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>
Subject: [PATCH 1/4] dma: use BUG_ON correctly in iop-adma.c, v4
Date: Sun, 27 Mar 2011 01:26:52 +0800
Message-Id: <1301160415-24569-2-git-send-email-bosong.ly@taobao.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1301160415-24569-1-git-send-email-bosong.ly@taobao.com>
References: <1301160415-24569-1-git-send-email-bosong.ly@taobao.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes BUG_ON() usage correct in drivers/dma/iop-adma.c.

Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>
Signed-off-by: Coly Li <bosong.ly@taobao.com>
---
 drivers/dma/iop-adma.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/iop-adma.c b/drivers/dma/iop-adma.c
index c6b01f5..e03f811 100644
--- a/drivers/dma/iop-adma.c
+++ b/drivers/dma/iop-adma.c
@@ -619,7 +619,7 @@ iop_adma_prep_dma_memcpy(struct dma_chan *chan, dma_addr_t dma_dest,
 
 	if (unlikely(!len))
 		return NULL;
-	BUG_ON(unlikely(len > IOP_ADMA_MAX_BYTE_COUNT));
+	BUG_ON(len > IOP_ADMA_MAX_BYTE_COUNT);
 
 	dev_dbg(iop_chan->device->common.dev, "%s len: %u\n",
 		__func__, len);
@@ -652,7 +652,7 @@ iop_adma_prep_dma_memset(struct dma_chan *chan, dma_addr_t dma_dest,
 
 	if (unlikely(!len))
 		return NULL;
-	BUG_ON(unlikely(len > IOP_ADMA_MAX_BYTE_COUNT));
+	BUG_ON(len > IOP_ADMA_MAX_BYTE_COUNT);
 
 	dev_dbg(iop_chan->device->common.dev, "%s len: %u\n",
 		__func__, len);
@@ -686,7 +686,7 @@ iop_adma_prep_dma_xor(struct dma_chan *chan, dma_addr_t dma_dest,
 
 	if (unlikely(!len))
 		return NULL;
-	BUG_ON(unlikely(len > IOP_ADMA_XOR_MAX_BYTE_COUNT));
+	BUG_ON(len > IOP_ADMA_XOR_MAX_BYTE_COUNT);
 
 	dev_dbg(iop_chan->device->common.dev,
 		"%s src_cnt: %d len: %u flags: %lx\n",
-- 
1.7.3.4

