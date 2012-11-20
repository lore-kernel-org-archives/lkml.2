Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751919Ab2KTGfV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 01:35:21 -0500
Received: from mga11.intel.com ([192.55.52.93]:59124 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751041Ab2KTGfU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 01:35:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,282,1352102400"; 
   d="scan'208";a="251708144"
Subject: [PATCH] DMA interrupt mask value should not be hard coded
From: chao bi <chao.bi@intel.com>
To: djbw@fb.com, vinod.koul@intel.com
Cc: linux-kernel@vger.kernel.org, jun.d.chen@intel.com
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 20 Nov 2012 14:45:59 +0800
Message-ID: <1353393959.4445.82.camel@bichao>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In intel_mid_dma.c, when setup DMA controller, its interrupt
mask value is hard coded, it's not needed because this value
has already been initiated and set value according to DMA
channels which are used.

cc: Chen Jun <jun.d.chen@intel.com>
Signed-off-by: channing <chao.bi@intel.com>
---
 drivers/dma/intel_mid_dma.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/intel_mid_dma.c b/drivers/dma/intel_mid_dma.c
index 02b21d7..11a1a48 100644
--- a/drivers/dma/intel_mid_dma.c
+++ b/drivers/dma/intel_mid_dma.c
@@ -1161,7 +1161,6 @@ static int mid_setup_dma(struct pci_dev *pdev)
 		if (0 != err)
 			goto err_irq;
 	} else {
-		dma->intr_mask = 0x03;
 		pr_debug("MDMA:Requesting irq for DMAC2\n");
 		err = request_irq(pdev->irq, intel_mid_dma_interrupt2,
 			IRQF_SHARED, "INTEL_MID_DMAC2", dma);
-- 
1.7.1



