Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933406Ab2EWL17 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 07:27:59 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36872 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932302Ab2EWL15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 07:27:57 -0400
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: vinod.koul@intel.com, dan.j.williams@intel.com, patches@linaro.org
Subject: [PATCH] dmaengine: pl330: dont complete descriptor for cyclic dma
Date: Wed, 23 May 2012 16:47:31 +0530
Message-Id: <1337771851-3431-1-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit eab215855803 ("dmaengine: pl330: dont complete descriptor for
cyclic dma") wrongly completes descriptor for cyclic dma, hence following
BUG_ON is still hit with cyclic DMA operations.

kernel BUG at drivers/dma/dmaengine.h:53!

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
---
 drivers/dma/pl330.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index fa3fb21..8c44f17 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -2322,7 +2322,7 @@ static void pl330_tasklet(unsigned long data)
 	/* Pick up ripe tomatoes */
 	list_for_each_entry_safe(desc, _dt, &pch->work_list, node)
 		if (desc->status == DONE) {
-			if (pch->cyclic)
+			if (!pch->cyclic)
 				dma_cookie_complete(&desc->txd);
 			list_move_tail(&desc->node, &list);
 		}
-- 
1.7.4.1

