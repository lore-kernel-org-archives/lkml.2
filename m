Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760363Ab2FVLne (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 07:43:34 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:6266 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760137Ab2FVLnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 07:43:33 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Fri, 22 Jun 2012 04:43:32 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <vinod.koul@intel.com>, <dan.j.williams@intel.com>
CC: <linux-kernel@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 2/2] dma: tegra: do not set transfer desc flag to DMA_CTRL_ACK in cyclic mode
Date: Fri, 22 Jun 2012 17:12:44 +0530
Message-ID: <1340365364-16276-2-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1340365364-16276-1-git-send-email-ldewangan@nvidia.com>
References: <1340365364-16276-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sound dmaengine pcm driver uses the dma in cyclic mode and
it does not ack the transfer descriptor  after transfer stops.
This may lead to hold that desc in chip's dma driver and does
not allow to reuse/free that descriptors. Hence not enabling
flag DMA_CTRL_ACK when dma runs in cyclic mode.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/dma/tegra20-apb-dma.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/tegra20-apb-dma.c b/drivers/dma/tegra20-apb-dma.c
index b4bd50c..2e4c187 100644
--- a/drivers/dma/tegra20-apb-dma.c
+++ b/drivers/dma/tegra20-apb-dma.c
@@ -1093,7 +1093,7 @@ struct dma_async_tx_descriptor *tegra_dma_prep_dma_cyclic(
 		mem += len;
 	}
 	sg_req->last_sg = true;
-	dma_desc->txd.flags = DMA_CTRL_ACK;
+	dma_desc->txd.flags = 0;
 
 	/*
 	 * Make sure that mode should not be conflicting with currently
-- 
1.7.1.1

