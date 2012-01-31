Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075Ab2AaKta (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 05:49:30 -0500
Received: from mga01.intel.com ([192.55.52.88]:42805 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753895Ab2AaKtF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 05:49:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="118484396"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH 1/2] dmaengine: intel_mid_dma: fix error status mask
Date: Tue, 31 Jan 2012 12:48:59 +0200
Message-Id: <1328006940-9101-2-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1328006940-9101-1-git-send-email-adrian.hunter@intel.com>
References: <1328006940-9101-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The error status mask (MASK_ERR) has the same format as the other
masks (MASK_TFR, MASK_BLOCK etc) and must be cleared the same way.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 drivers/dma/intel_mid_dma.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/intel_mid_dma.c b/drivers/dma/intel_mid_dma.c
index 74f70aa..512e2ab 100644
--- a/drivers/dma/intel_mid_dma.c
+++ b/drivers/dma/intel_mid_dma.c
@@ -1056,7 +1056,8 @@ static irqreturn_t intel_mid_dma_interrupt(int irq, void *data)
 	}
 	err_status &= mid->intr_mask;
 	if (err_status) {
-		iowrite32(MASK_INTR_REG(err_status), mid->dma_base + MASK_ERR);
+		iowrite32((err_status << INT_MASK_WE),
+			  mid->dma_base + MASK_ERR);
 		call_tasklet = 1;
 	}
 	if (call_tasklet)
-- 
1.7.6.4

