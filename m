Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755648Ab2FOHFn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 03:05:43 -0400
Received: from mga11.intel.com ([192.55.52.93]:38473 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751429Ab2FOHFl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 03:05:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="180369886"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Viresh Kumar <viresh.kumar@st.com>, Vinod Koul <vinod.koul@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 4/9] dw_dmac: print correct number of scanned descriptors
Date: Fri, 15 Jun 2012 10:05:08 +0300
Message-Id: <1339743913-6236-5-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1339743913-6236-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1339743913-6236-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case the first descriptor we found is available, the counter still remains 0
value which is wrong. This patch fixes the counter behaviour.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/dma/dw_dmac.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index b6251dc..763730a 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -107,13 +107,13 @@ static struct dw_desc *dwc_desc_get(struct dw_dma_chan *dwc)
 
 	spin_lock_irqsave(&dwc->lock, flags);
 	list_for_each_entry_safe(desc, _desc, &dwc->free_list, desc_node) {
+		i++;
 		if (async_tx_test_ack(&desc->txd)) {
 			list_del(&desc->desc_node);
 			ret = desc;
 			break;
 		}
 		dev_dbg(chan2dev(&dwc->chan), "desc %p not ACKed\n", desc);
-		i++;
 	}
 	spin_unlock_irqrestore(&dwc->lock, flags);
 
-- 
1.7.10

