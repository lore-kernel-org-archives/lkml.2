Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933906Ab2KZRNm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:13:42 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48070 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933898Ab2KZRNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:13:36 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Barry Song <Baohua.Song@csr.com>, Vinod Koul <vinod.koul@linux.intel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 219/270] dmaengine: sirf: fix a typo in dma_prep_interleaved
Date: Mon, 26 Nov 2012 14:58:29 -0200
Message-Id: <1353949160-26803-220-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Barry Song <Baohua.Song@csr.com>

commit 5997e089e4c3a7f0958a8fb0a54ec2b5a6f06168 upstream.

either DEV_TO_MEM or MEM_TO_DEV is supported, so change
OR to AND.

Signed-off-by: Barry Song <Baohua.Song@csr.com>
Signed-off-by: Vinod Koul <vinod.koul@linux.intel.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/dma/sirf-dma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/sirf-dma.c b/drivers/dma/sirf-dma.c
index 434ad31..35a329d 100644
--- a/drivers/dma/sirf-dma.c
+++ b/drivers/dma/sirf-dma.c
@@ -428,7 +428,7 @@ static struct dma_async_tx_descriptor *sirfsoc_dma_prep_interleaved(
 	unsigned long iflags;
 	int ret;
 
-	if ((xt->dir != DMA_MEM_TO_DEV) || (xt->dir != DMA_DEV_TO_MEM)) {
+	if ((xt->dir != DMA_MEM_TO_DEV) && (xt->dir != DMA_DEV_TO_MEM)) {
 		ret = -EINVAL;
 		goto err_dir;
 	}
-- 
1.7.9.5

