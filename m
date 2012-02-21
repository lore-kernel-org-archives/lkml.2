Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479Ab2BUOwP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 09:52:15 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:62801 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755426Ab2BUOwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 09:52:10 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of festevam@gmail.com designates 10.236.145.2 as permitted sender) smtp.mail=festevam@gmail.com; dkim=pass header.i=festevam@gmail.com
From: Fabio Estevam <festevam@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: vinod.koul@intel.com, dan.j.williams@intel.com,
        Fabio Estevam <festevam@gmail.com>,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] dma: dmaengine: Distinguish between 'dmaengine: failed to get' messages
Date: Tue, 21 Feb 2012 12:51:59 -0200
Message-Id: <1329835919-18425-1-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The message "dmaengine: failed to get" can come from two possible locations within dmaengine.c.

In order to distinguish between them, replace "dmaengine" with __func__ string so that the
source function of the error message can be easily identified.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/dma/dmaengine.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index a6c6051..ac10325 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -510,8 +510,8 @@ struct dma_chan *__dma_request_channel(dma_cap_mask_t *mask, dma_filter_fn fn, v
 					 dma_chan_name(chan));
 				list_del_rcu(&device->global_node);
 			} else if (err)
-				pr_debug("dmaengine: failed to get %s: (%d)\n",
-					 dma_chan_name(chan), err);
+				pr_debug("%s: failed to get %s: (%d)\n",
+					__func__, dma_chan_name(chan), err);
 			else
 				break;
 			if (--device->privatecnt == 0)
@@ -564,8 +564,8 @@ void dmaengine_get(void)
 				list_del_rcu(&device->global_node);
 				break;
 			} else if (err)
-				pr_err("dmaengine: failed to get %s: (%d)\n",
-				       dma_chan_name(chan), err);
+				pr_err("%s: failed to get %s: (%d)\n",
+					__func__, dma_chan_name(chan), err);
 		}
 	}
 
-- 
1.7.1

