Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756310Ab2JROe2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 10:34:28 -0400
Received: from mga02.intel.com ([134.134.136.20]:11550 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752411Ab2JROeY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 10:34:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,608,1344236400"; 
   d="scan'208";a="229254050"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Viresh Kumar <viresh.linux@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org, spear-devel <spear-devel@list.st.com>,
        balbi@ti.com
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCHv3 5/6] dw_dmac: change dev_crit to dev_WARN in dwc_handle_error
Date: Thu, 18 Oct 2012 17:34:11 +0300
Message-Id: <1350570852-10398-6-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1350570852-10398-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1350570852-10398-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case of handling a bad descriptor the dwc_handle_error() will dump a stack
as well. It's a lot more verbose and more likely to get user's attention.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/dma/dw_dmac.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 180ffd5..826ff8d 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -485,14 +485,14 @@ static void dwc_handle_error(struct dw_dma *dw, struct dw_dma_chan *dwc)
 		dwc_dostart(dwc, dwc_first_active(dwc));
 
 	/*
-	 * KERN_CRITICAL may seem harsh, but since this only happens
+	 * WARN may seem harsh, but since this only happens
 	 * when someone submits a bad physical address in a
 	 * descriptor, we should consider ourselves lucky that the
 	 * controller flagged an error instead of scribbling over
 	 * random memory locations.
 	 */
-	dev_crit(chan2dev(&dwc->chan), "Bad descriptor submitted for DMA!\n");
-	dev_crit(chan2dev(&dwc->chan), "  cookie: %d\n", bad_desc->txd.cookie);
+	dev_WARN(chan2dev(&dwc->chan), "Bad descriptor submitted for DMA!\n"
+				       "  cookie: %d\n", bad_desc->txd.cookie);
 	dwc_dump_lli(dwc, &bad_desc->lli);
 	list_for_each_entry(child, &bad_desc->tx_list, desc_node)
 		dwc_dump_lli(dwc, &child->lli);
-- 
1.7.10.4

