Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762282Ab2FVPMF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 11:12:05 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:11763 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756319Ab2FVPME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 11:12:04 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Fri, 22 Jun 2012 08:11:59 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <vinod.koul@intel.com>, <dan.j.williams@intel.com>
CC: <linux-kernel@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH] dma: tegra: use sg_dma_address() for getting dma buffer address
Date: Fri, 22 Jun 2012 20:41:10 +0530
Message-ID: <1340377870-10035-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the sg_dma_address() to get the segment buffer address for
DMA transfer in place of sg_phys() which returns the physical
address of an sg entry.
The sg_dma_address() returns the correct buffer memory address
for DMA transfer.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/dma/tegra20-apb-dma.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/tegra20-apb-dma.c b/drivers/dma/tegra20-apb-dma.c
index 2e4c187..a46a21c 100644
--- a/drivers/dma/tegra20-apb-dma.c
+++ b/drivers/dma/tegra20-apb-dma.c
@@ -929,7 +929,7 @@ static struct dma_async_tx_descriptor *tegra_dma_prep_slave_sg(
 	for_each_sg(sgl, sg, sg_len, i) {
 		u32 len, mem;
 
-		mem = sg_phys(sg);
+		mem = sg_dma_address(sg);
 		len = sg_dma_len(sg);
 
 		if ((len & 3) || (mem & 3) ||
-- 
1.7.1.1

