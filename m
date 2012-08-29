Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752372Ab2H2FjH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 01:39:07 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:6986 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914Ab2H2FjE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 01:39:04 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 28 Aug 2012 22:32:35 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <u.kleine-koenig@pengutronix.de>, <vinod.koul@intel.com>, <djbw@fb.com>
CC: <swarren@wwwdotorg.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH RESEND] dma: tegra: add const to of_device_id.data's structure
Date: Wed, 29 Aug 2012 10:47:27 +0530
Message-ID: <1346217447-19730-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The member "data" of structure of_device_id is changed to const
pointer. Hence initializing this with const type data.
This will fix the compilation warning like
drivers/dma/tegra20-apb-dma.c:1217:9: warning: assignment discards 'const' qualifier from
pointer target type [enabled by default]

This warning came after the change
---------
commit 98d7bbb9929bcc14e11ac8a55245a4f2dc174e17
Author: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    of: add const to struct *of_device_id.data
---------

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
Acked-by: Stephen Warren <swarren@wwwdotorg.org>
Acked-by: Vinod Koul <vinod.koul@linux.intel.com>

---
Resending patch to Uwe and adding ack from Stephen and Vinod.
Fix typo in description.

 drivers/dma/tegra20-apb-dma.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/tegra20-apb-dma.c b/drivers/dma/tegra20-apb-dma.c
index 24acd71..09a15ff 100644
--- a/drivers/dma/tegra20-apb-dma.c
+++ b/drivers/dma/tegra20-apb-dma.c
@@ -201,7 +201,7 @@ struct tegra_dma {
 	struct clk			*dma_clk;
 	spinlock_t			global_lock;
 	void __iomem			*base_addr;
-	struct tegra_dma_chip_data	*chip_data;
+	const struct tegra_dma_chip_data	*chip_data;
 
 	/* Some register need to be cache before suspend */
 	u32				reg_gen;
@@ -1173,14 +1173,14 @@ static void tegra_dma_free_chan_resources(struct dma_chan *dc)
 }
 
 /* Tegra20 specific DMA controller information */
-static struct tegra_dma_chip_data tegra20_dma_chip_data = {
+static const struct tegra_dma_chip_data tegra20_dma_chip_data = {
 	.nr_channels		= 16,
 	.max_dma_count		= 1024UL * 64,
 };
 
 #if defined(CONFIG_OF)
 /* Tegra30 specific DMA controller information */
-static struct tegra_dma_chip_data tegra30_dma_chip_data = {
+static const struct tegra_dma_chip_data tegra30_dma_chip_data = {
 	.nr_channels		= 32,
 	.max_dma_count		= 1024UL * 64,
 };
@@ -1204,7 +1204,7 @@ static int __devinit tegra_dma_probe(struct platform_device *pdev)
 	struct tegra_dma *tdma;
 	int ret;
 	int i;
-	struct tegra_dma_chip_data *cdata = NULL;
+	const struct tegra_dma_chip_data *cdata = NULL;
 
 	if (pdev->dev.of_node) {
 		const struct of_device_id *match;
-- 
1.7.1.1

