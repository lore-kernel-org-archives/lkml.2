Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933200Ab2J2Vpo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 17:45:44 -0400
Received: from mail.kernel.org ([198.145.19.201]:48853 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933095Ab2J2Vlv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 17:41:51 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Barry Song <Baohua.Song@csr.com>,
        Vinod Koul <vinod.koul@linux.intel.com>
Subject: [ 43/54] dmaengine: sirf: fix a typo in moving running dma_desc to active queue
Date: Mon, 29 Oct 2012 14:40:44 -0700
Message-Id: <20121029213807.542822762@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121029213802.697479610@linuxfoundation.org>
References: <20121029213802.697479610@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/dma/sirf-dma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/dma/sirf-dma.c
+++ b/drivers/dma/sirf-dma.c
@@ -109,7 +109,7 @@ static void sirfsoc_dma_execute(struct s
 	sdesc = list_first_entry(&schan->queued, struct sirfsoc_dma_desc,
 		node);
 	/* Move the first queued descriptor to active list */
-	list_move_tail(&schan->queued, &schan->active);
+	list_move_tail(&sdesc->node, &schan->active);
 
 	/* Start the DMA transfer */
 	writel_relaxed(sdesc->width, sdma->base + SIRFSOC_DMA_WIDTH_0 +


