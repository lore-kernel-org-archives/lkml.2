Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757656Ab1F0Jft (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 05:35:49 -0400
Received: from eu1sys200aog118.obsmtp.com ([207.126.144.145]:46825 "EHLO
	eu1sys200aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757480Ab1F0Jdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 05:33:40 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: <linux-kernel@vger.kernel.org>, Dan Williams <dan.j.williams@intel.com>,
        Lee Jones <lee.jones@linaro.org>,
        Robert Marklund <robert.marklund@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 1/4] dmaengine/ste_dma40: make the cyclic alloc NOWAIT
Date: Mon, 27 Jun 2011 11:33:24 +0200
Message-ID: <1309167204-23338-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Marklund <robert.marklund@stericsson.com>

This function may be initiated from IRQ context, so the allocation
must allocate NOWAIT memory.

Signed-off-by: Robert Marklund <robert.marklund@stericsson.com>
Reviewed-by: Rabin Vincent <rabin.vincent@stericsson.com>
Reviewed-by: Philippe Langlais <philippe.langlais@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/dma/ste_dma40.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 91d5ed7..58de946 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -2110,7 +2110,7 @@ dma40_prep_dma_cyclic(struct dma_chan *chan, dma_addr_t dma_addr,
 	struct scatterlist *sg;
 	int i;
 
-	sg = kcalloc(periods + 1, sizeof(struct scatterlist), GFP_KERNEL);
+	sg = kcalloc(periods + 1, sizeof(struct scatterlist), GFP_NOWAIT);
 	for (i = 0; i < periods; i++) {
 		sg_dma_address(&sg[i]) = dma_addr;
 		sg_dma_len(&sg[i]) = period_len;
-- 
1.7.3.2

