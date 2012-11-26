Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933931Ab2KZRNt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:13:49 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48076 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932850Ab2KZRNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:13:39 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Barry Song <Baohua.Song@csr.com>, Vinod Koul <vinod.koul@linux.intel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 220/270] dmaengine: sirf: fix a typo in moving running dma_desc to active queue
Date: Mon, 26 Nov 2012 14:58:30 -0200
Message-Id: <1353949160-26803-221-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Barry Song <Baohua.Song@csr.com>

commit 26fd12209c08fe947be1828896ef4ffc5bd0e6df upstream.

list_move_tail(&schan->queued, &schan->active) makes the list_empty(schan->queued)
undefined, we either should change it to:
list_move_tail(schan->queued.next, &schan->active)
or
list_move_tail(&sdesc->node, &schan->active)

Signed-off-by: Barry Song <Baohua.Song@csr.com>
Signed-off-by: Vinod Koul <vinod.koul@linux.intel.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/dma/sirf-dma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/sirf-dma.c b/drivers/dma/sirf-dma.c
index 35a329d..c439489 100644
--- a/drivers/dma/sirf-dma.c
+++ b/drivers/dma/sirf-dma.c
@@ -109,7 +109,7 @@ static void sirfsoc_dma_execute(struct sirfsoc_dma_chan *schan)
 	sdesc = list_first_entry(&schan->queued, struct sirfsoc_dma_desc,
 		node);
 	/* Move the first queued descriptor to active list */
-	list_move_tail(&schan->queued, &schan->active);
+	list_move_tail(&sdesc->node, &schan->active);
 
 	/* Start the DMA transfer */
 	writel_relaxed(sdesc->width, sdma->base + SIRFSOC_DMA_WIDTH_0 +
-- 
1.7.9.5

