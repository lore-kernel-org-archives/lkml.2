Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760450Ab2FVLni (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 07:43:38 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:6277 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760137Ab2FVLng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 07:43:36 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 22 Jun 2012 04:40:38 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <vinod.koul@intel.com>, <dan.j.williams@intel.com>
CC: <linux-kernel@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 1/2] dma: tegra: set DMA_CYCLIC capability
Date: Fri, 22 Jun 2012 17:12:43 +0530
Message-ID: <1340365364-16276-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tegra's APB DMA driver support the cyclic mode of data
transfer and hence setting the DMA_CYCLIC caps for dma
channels.

This is require when generic sound dmaengine pcm driver
request for dma channel with CYCLIC capability.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/dma/tegra20-apb-dma.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/tegra20-apb-dma.c b/drivers/dma/tegra20-apb-dma.c
index 134ea7c..b4bd50c 100644
--- a/drivers/dma/tegra20-apb-dma.c
+++ b/drivers/dma/tegra20-apb-dma.c
@@ -1306,6 +1306,8 @@ static int __devinit tegra_dma_probe(struct platform_device *pdev)
 
 	dma_cap_set(DMA_SLAVE, tdma->dma_dev.cap_mask);
 	dma_cap_set(DMA_PRIVATE, tdma->dma_dev.cap_mask);
+	dma_cap_set(DMA_CYCLIC, tdma->dma_dev.cap_mask);
+
 	tdma->dma_dev.dev = &pdev->dev;
 	tdma->dma_dev.device_alloc_chan_resources =
 					tegra_dma_alloc_chan_resources;
-- 
1.7.1.1

