Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757480Ab3AIISA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 03:18:00 -0500
Received: from mga11.intel.com ([192.55.52.93]:43190 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757412Ab3AIIR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 03:17:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,436,1355126400"; 
   d="scan'208";a="271648619"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        spear-devel <spear-devel@list.st.com>
Subject: [resend][PATCH 06/16] dma: ep93xx_dma: reuse is_slave_xfer helper
Date: Wed,  9 Jan 2013 10:17:05 +0200
Message-Id: <1357719435-29955-7-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1357719435-29955-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <20130108155423.GJ19691@intel.com>
 <1357719435-29955-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The is_slave_xfer helps to check if the transfer type is slave.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Viresh Kumar <viresh.kumar@linaro.org>
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/dma/ep93xx_dma.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/dma/ep93xx_dma.c b/drivers/dma/ep93xx_dma.c
index bcfde40..a2f1d9f 100644
--- a/drivers/dma/ep93xx_dma.c
+++ b/drivers/dma/ep93xx_dma.c
@@ -903,8 +903,7 @@ static int ep93xx_dma_alloc_chan_resources(struct dma_chan *chan)
 			switch (data->port) {
 			case EP93XX_DMA_SSP:
 			case EP93XX_DMA_IDE:
-				if (data->direction != DMA_MEM_TO_DEV &&
-				    data->direction != DMA_DEV_TO_MEM)
+				if (!is_slave_xfer(data->direction))
 					return -EINVAL;
 				break;
 			default:
-- 
1.7.10.4

