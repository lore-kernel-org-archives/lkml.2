Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683Ab2KPPwv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 10:52:51 -0500
Received: from mga01.intel.com ([192.55.52.88]:59998 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752598Ab2KPPwW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 10:52:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,265,1352102400"; 
   d="scan'208";a="250305898"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Vinod Koul <vinod.koul@intel.com>, spear-devel <spear-devel@list.st.com>,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCHv2 5/6] dma: ipu_idmac: reuse is_slave_xfer helper
Date: Fri, 16 Nov 2012 17:52:04 +0200
Message-Id: <1353081126-17995-6-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353081126-17995-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1353081126-17995-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The is_slave_xfer helps to check if the transfer type is slave.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/dma/ipu/ipu_idmac.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/ipu/ipu_idmac.c b/drivers/dma/ipu/ipu_idmac.c
index 6585537..c8d0254 100644
--- a/drivers/dma/ipu/ipu_idmac.c
+++ b/drivers/dma/ipu/ipu_idmac.c
@@ -1347,7 +1347,7 @@ static struct dma_async_tx_descriptor *idmac_prep_slave_sg(struct dma_chan *chan
 	    chan->chan_id != IDMAC_IC_7)
 		return NULL;
 
-	if (direction != DMA_DEV_TO_MEM && direction != DMA_MEM_TO_DEV) {
+	if (!is_slave_xfer(direction)) {
 		dev_err(chan->device->dev, "Invalid DMA direction %d!\n", direction);
 		return NULL;
 	}
-- 
1.7.10.4

