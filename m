Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758717Ab0HEC6v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 22:58:51 -0400
Received: from mga09.intel.com ([134.134.136.24]:43200 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756958Ab0HEC6t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 22:58:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,319,1278313200"; 
   d="scan'208";a="644803679"
Date: Thu, 5 Aug 2010 10:40:08 +0800
From: Yong Wang <yong.y.wang@linux.intel.com>
To: Dan Williams <dan.j.williams@intel.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] DMAENGINE: at_hdmac: locking fixlet
Message-ID: <20100805024008.GB30411@ywang-moblin2.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

atc_chain_complete shall be called with atchan->lock held
and bh disabled.

Signed-off-by: Yong Wang <yong.y.wang@intel.com>
---
 drivers/dma/at_hdmac.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index bd5250e..646f6d6 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -790,12 +790,12 @@ static int atc_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 	list_splice_init(&atchan->queue, &list);
 	list_splice_init(&atchan->active_list, &list);
 
-	spin_unlock_bh(&atchan->lock);
-
 	/* Flush all pending and queued descriptors */
 	list_for_each_entry_safe(desc, _desc, &list, desc_node)
 		atc_chain_complete(atchan, desc);
 
+	spin_unlock_bh(&atchan->lock);
+
 	return 0;
 }
 
-- 
1.5.5.1

