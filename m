Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497Ab2GMILG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 04:11:06 -0400
Received: from mga14.intel.com ([143.182.124.37]:13242 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754940Ab2GMIJ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 04:09:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="167610904"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Viresh Kumar <viresh.linux@gmail.com>, linux-kernel@vger.kernel.org,
        Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 3/3] dw_dmac: set default alignment
Date: Fri, 13 Jul 2012 11:09:34 +0300
Message-Id: <1342166974-4490-3-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1342166974-4490-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1342166974-4490-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The default values are filled to support at least mem-to-mem tests provided by
dmatest module. It makes sense to choose the 4 bytes (2 least significant bits)
alignment by the default.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/dma/dw_dmac.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 3d061c6..2a19ab6 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -1485,6 +1485,12 @@ static int __devinit dw_probe(struct platform_device *pdev)
 	dw->dma.device_tx_status = dwc_tx_status;
 	dw->dma.device_issue_pending = dwc_issue_pending;
 
+	/* Set default alignment */
+	dw->dma.copy_align = 2;
+	dw->dma.xor_align = 2;
+	dw->dma.pq_align = 2;
+	dw->dma.fill_align = 2;
+
 	dma_writel(dw, CFG, DW_CFG_DMA_EN);
 
 	printk(KERN_INFO "%s: DesignWare DMA Controller, %d channels\n",
-- 
1.7.10.4

