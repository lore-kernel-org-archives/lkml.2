Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383Ab2JROe0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 10:34:26 -0400
Received: from mga03.intel.com ([143.182.124.21]:5217 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753081Ab2JROeY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 10:34:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,607,1344236400"; 
   d="scan'208";a="206091412"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Viresh Kumar <viresh.linux@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org, spear-devel <spear-devel@list.st.com>,
        balbi@ti.com
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCHv3 4/6] dw_dmac: don't call platform_get_drvdata twice
Date: Thu, 18 Oct 2012 17:34:10 +0300
Message-Id: <1350570852-10398-5-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1350570852-10398-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1350570852-10398-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to call platform_get_drvdata twice as we have it already in dw
variable.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Reviewed-by: Felipe Balbi <balbi@ti.com>
---
 drivers/dma/dw_dmac.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index d4ddf48..180ffd5 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -1653,7 +1653,7 @@ static void dw_shutdown(struct platform_device *pdev)
 {
 	struct dw_dma	*dw = platform_get_drvdata(pdev);
 
-	dw_dma_off(platform_get_drvdata(pdev));
+	dw_dma_off(dw);
 	clk_disable_unprepare(dw->clk);
 }
 
@@ -1662,7 +1662,7 @@ static int dw_suspend_noirq(struct device *dev)
 	struct platform_device *pdev = to_platform_device(dev);
 	struct dw_dma	*dw = platform_get_drvdata(pdev);
 
-	dw_dma_off(platform_get_drvdata(pdev));
+	dw_dma_off(dw);
 	clk_disable_unprepare(dw->clk);
 
 	return 0;
-- 
1.7.10.4

