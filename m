Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338Ab1A1Rhs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 12:37:48 -0500
Received: from [123.122.102.109] ([123.122.102.109]:36387 "EHLO enigma.site"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754532Ab1A1Rhq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 12:37:46 -0500
From: Coly Li <bosong.ly@taobao.com>
To: linux-kernel@vger.kernel.org
Cc: Coly Li <bosong.ly@taobao.com>, Greg KH <gregkh@suse.de>,
        Yong Zhang <yong.zhang0@gmail.com>,
        Wang Cong <xiyou.wangcong@gmail.com>
Subject: [PATCH 0/5] use BUG_ON correctly, v3
Date: Sat, 29 Jan 2011 01:55:45 +0800
Message-Id: <1296237350-6624-1-git-send-email-bosong.ly@taobao.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most of BUG_ON() implementations use unlikely() internally for better
branch prediction results. The following method to use BUG_ON() with
an explicit unlikely() doesn't make things better and is unwelcome:
	BUG_ON(unlikely(condition));
Source code should use BUG_ON() just with condition code.

For arch implementation of BUG_ON(), there are feed backs for v2 patch
set from MIPS and PowerPC developers than neither explicit no implicit
unlikely() does help anything.

Therefore using unlikely() explicit with BUG_ON() is always a bug. This
patch set removes all incorrect BUG_ON() usage.

The difference between v3 and v2 patch set is 2 patches are removed from
the patch set (since the modification is gratuitous):
(1) [PATCH 1/7] MIPS: add unlikely() to BUG_ON()
(2) [PATCH 2/7] PowerPC: add unlikely() to BUG_ON()

Signed-off-by: Coly Li <bosong.ly@taobao.com>
Cc: Greg KH <gregkh@suse.de>
Cc: Yong Zhang <yong.zhang0@gmail.com>
Cc: Wang Cong <xiyou.wangcong@gmail.com>
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

