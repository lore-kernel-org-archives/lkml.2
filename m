Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743Ab2AZPdz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 10:33:55 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:46003 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752126Ab2AZPdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 10:33:54 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: linux-kernel@vger.kernel.org
Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH] dmaengine: dmatest: fix thread_count
Date: Thu, 26 Jan 2012 16:33:45 +0100
Message-Id: <1327592025-2461-1-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.7.3
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1327592034;2ec62492;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems with commit f1aef8b6e6abf32a3a269542f95a19e2cb319f6c
another case where thread_count wasn't calculated correctly
has been overlooked.

This fix also a -Wparentheses compiler warning.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 drivers/dma/dmatest.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
index 2b8661b..24225f0 100644
--- a/drivers/dma/dmatest.c
+++ b/drivers/dma/dmatest.c
@@ -599,7 +599,7 @@ static int dmatest_add_channel(struct dma_chan *chan)
 	}
 	if (dma_has_cap(DMA_PQ, dma_dev->cap_mask)) {
 		cnt = dmatest_add_threads(dtc, DMA_PQ);
-		thread_count += cnt > 0 ?: 0;
+		thread_count += cnt > 0 ? cnt : 0;
 	}
 
 	pr_info("dmatest: Started %u threads using %s\n",
-- 
1.7.7.3

