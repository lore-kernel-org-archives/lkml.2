Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757454Ab3AIIRu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 03:17:50 -0500
Received: from mga02.intel.com ([134.134.136.20]:18877 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757406Ab3AIIRe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 03:17:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,436,1355126400"; 
   d="scan'208";a="269725945"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        spear-devel <spear-devel@list.st.com>
Subject: [resend][PATCH 13/16] dw_dmac: remove redundant check
Date: Wed,  9 Jan 2013 10:17:12 +0200
Message-Id: <1357719435-29955-14-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1357719435-29955-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <20130108155423.GJ19691@intel.com>
 <1357719435-29955-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to check the callback_required parameter, due to we check the
callback pointer to be a non-NULL.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/dma/dw_dmac.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 83e0f9e..05a8265 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -364,7 +364,7 @@ dwc_descriptor_complete(struct dw_dma_chan *dwc, struct dw_desc *desc,
 
 	spin_unlock_irqrestore(&dwc->lock, flags);
 
-	if (callback_required && callback)
+	if (callback)
 		callback(param);
 }
 
-- 
1.7.10.4

