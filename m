Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052Ab1AZSYm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 13:24:42 -0500
Received: from [123.122.106.155] ([123.122.106.155]:43808 "EHLO enigma.site"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752778Ab1AZSXn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 13:23:43 -0500
From: Coly Li <bosong.ly@taobao.com>
To: linux-kernel@vger.kernel.org
Cc: Coly Li <bosong.ly@taobao.com>, Greg KH <gregkh@suse.de>
Subject: [PATCH 2/6] dma: use BUG_ON correctly in iop-adma.c
Date: Thu, 27 Jan 2011 02:39:49 +0800
Message-Id: <1296067193-15879-3-git-send-email-bosong.ly@taobao.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1296067193-15879-1-git-send-email-bosong.ly@taobao.com>
References: <1296067193-15879-1-git-send-email-bosong.ly@taobao.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch mekes BUG_ON() usage correct in drivers/dma/iop-adma.c.

Signed-off-by: Coly Li <bosong.ly@taobao.com>
Cc: Greg KH <gregkh@suse.de>
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
1.7.3.2

