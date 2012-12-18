Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562Ab2LRIeN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 03:34:13 -0500
Received: from mga02.intel.com ([134.134.136.20]:15759 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754146Ab2LRIeM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 03:34:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,308,1355126400"; 
   d="scan'208";a="258777659"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Vinod Koul <vinod.koul@intel.com>, spear-devel <spear-devel@list.st.com>,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCHv2 2/2] dma: dw_dmac: clear suspend bit during termination
Date: Tue, 18 Dec 2012 10:33:55 +0200
Message-Id: <1355819635-18693-2-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1355819635-18693-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1355819635-18693-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heikki Krogerus <heikki.krogerus@linux.intel.com>

The DMA transfer could not be established if previously it was paused and
terminated. In that case the channel's suspend bit remains set that prevents to
transfer anything until channel is resumed.

The patch adds a code that clears the DWC_CFGL_CH_SUSP bit during termination.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/dma/dw_dmac.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 687af2a..8d77643 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -1059,7 +1059,7 @@ static int dwc_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 
 		dwc_chan_disable(dw, dwc);
 
-		dwc->paused = false;
+		dwc_chan_resume(dwc);
 
 		/* active_list entries will end up before queued entries */
 		list_splice_init(&dwc->queue, &list);
-- 
1.7.10.4

