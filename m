Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816Ab3AJIxw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 03:53:52 -0500
Received: from mga11.intel.com ([192.55.52.93]:31682 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753911Ab3AJIxu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 03:53:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,443,1355126400"; 
   d="scan'208";a="275270874"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        spear-devel <spear-devel@list.st.com>
Subject: [PATCHv2 11/11] dma: dw_dmac: clear suspend bit during termination
Date: Thu, 10 Jan 2013 10:53:06 +0200
Message-Id: <1357807986-4026-12-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1357807986-4026-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1357807986-4026-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heikki Krogerus <heikki.krogerus@linux.intel.com>

The DMA transfer could not be established if previously it was paused and
terminated. In that case the channel's suspend bit remains set that prevents to
transfer anything until channel is resumed.

The patch adds the dwc_chan_resume() call instead of a plain flag assignment.
That clears the DWC_CFGL_CH_SUSP bit as well during termination.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/dma/dw_dmac.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index f9d37ec..684a9e1e 100644
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

