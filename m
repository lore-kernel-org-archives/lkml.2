Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702Ab2FYGb6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 02:31:58 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:2140 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754145Ab2FYGb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 02:31:57 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Sun, 24 Jun 2012 23:31:54 -0700
From: Prashant Gaikwad <pgaikwad@nvidia.com>
To: <vinod.koul@intel.com>, <dan.j.williams@intel.com>,
        <swarren@wwwdotorg.org>
CC: <linux-kernel@vger.kernel.org>, <ldewangan@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>
Subject: [PATCH] dma: tegra: add clk_prepare/clk_unprepare
Date: Mon, 25 Jun 2012 12:01:31 +0530
Message-ID: <1340605891-19076-1-git-send-email-pgaikwad@nvidia.com>
X-Mailer: git-send-email 1.7.4.1
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use clk_prepare/clk_unprepare as required by the generic clk framework.

Signed-off-by: Prashant Gaikwad <pgaikwad@nvidia.com>
---
 drivers/dma/tegra20-apb-dma.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/tegra20-apb-dma.c b/drivers/dma/tegra20-apb-dma.c
index 134ea7c..30fa67a 100644
--- a/drivers/dma/tegra20-apb-dma.c
+++ b/drivers/dma/tegra20-apb-dma.c
@@ -1366,7 +1366,7 @@ static int tegra_dma_runtime_suspend(struct device *dev)
 	struct platform_device *pdev = to_platform_device(dev);
 	struct tegra_dma *tdma = platform_get_drvdata(pdev);
 
-	clk_disable(tdma->dma_clk);
+	clk_disable_unprepare(tdma->dma_clk);
 	return 0;
 }
 
@@ -1376,7 +1376,7 @@ static int tegra_dma_runtime_resume(struct device *dev)
 	struct tegra_dma *tdma = platform_get_drvdata(pdev);
 	int ret;
 
-	ret = clk_enable(tdma->dma_clk);
+	ret = clk_prepare_enable(tdma->dma_clk);
 	if (ret < 0) {
 		dev_err(dev, "clk_enable failed: %d\n", ret);
 		return ret;
-- 
1.7.4.1

