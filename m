Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932537Ab1JNFrW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 01:47:22 -0400
Received: from mga14.intel.com ([143.182.124.37]:25401 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932429Ab1JNFrT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 01:47:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,344,1315206000"; 
   d="scan'208";a="62487021"
From: Vinod Koul <vinod.koul@intel.com>
To: dan.j.williams@intel.com
Cc: linux-kernel@vger.kernel.org, jaswinder.singh@linaro.org,
        21cnbao@gmail.com, rmk@arm.linux.org.uk,
        Vinod Koul <vinod.koul@linux.intel.com>
Subject: [PATCH 05/10] carma: move to dma_transfer_direction
Date: Fri, 14 Oct 2011 11:08:20 +0530
Message-Id: <1318570705-17595-6-git-send-email-vinod.koul@intel.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1318570705-17595-1-git-send-email-vinod.koul@intel.com>
References: <1318570705-17595-1-git-send-email-vinod.koul@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vinod Koul <vinod.koul@linux.intel.com>

Signed-off-by: Vinod Koul <vinod.koul@linux.intel.com>
CC Ira W. Snyder <iws@ovro.caltech.edu>
---
 drivers/misc/carma/carma-fpga-program.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/misc/carma/carma-fpga-program.c b/drivers/misc/carma/carma-fpga-program.c
index 7ce6065..c13e578 100644
--- a/drivers/misc/carma/carma-fpga-program.c
+++ b/drivers/misc/carma/carma-fpga-program.c
@@ -513,7 +513,7 @@ static noinline int fpga_program_dma(struct fpga_dev *priv)
 	 * transaction, and then put it under external control
 	 */
 	memset(&config, 0, sizeof(config));
-	config.direction = DMA_TO_DEVICE;
+	config.direction = MEM_TO_DEV;
 	config.dst_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
 	config.dst_maxburst = fpga_fifo_size(priv->regs) / 2 / 4;
 	ret = chan->device->device_control(chan, DMA_SLAVE_CONFIG,
-- 
1.7.0.4

