Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055Ab2KPN7g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 08:59:36 -0500
Received: from mga02.intel.com ([134.134.136.20]:36657 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752010Ab2KPN7d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 08:59:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,264,1352102400"; 
   d="scan'208";a="243282684"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Vinod Koul <vinod.koul@intel.com>, spear-devel <spear-devel@list.st.com>,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 4/6] dma: ep93xx_dma: reuse is_slave_xfer helper
Date: Fri, 16 Nov 2012 15:59:17 +0200
Message-Id: <1353074360-1903-5-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353074360-1903-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1353074360-1903-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/dma/ep93xx_dma.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/dma/ep93xx_dma.c b/drivers/dma/ep93xx_dma.c
index bcfde40..7c26354 100644
--- a/drivers/dma/ep93xx_dma.c
+++ b/drivers/dma/ep93xx_dma.c
@@ -903,8 +903,7 @@ static int ep93xx_dma_alloc_chan_resources(struct dma_chan *chan)
 			switch (data->port) {
 			case EP93XX_DMA_SSP:
 			case EP93XX_DMA_IDE:
-				if (data->direction != DMA_MEM_TO_DEV &&
-				    data->direction != DMA_DEV_TO_MEM)
+				if (!is_slave_xfter(data->direction))
 					return -EINVAL;
 				break;
 			default:
-- 
1.7.10.4

