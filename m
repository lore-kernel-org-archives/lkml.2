Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753926Ab3ADJrE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 04:47:04 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:3597 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091Ab3ADJrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 04:47:01 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Fri, 04 Jan 2013 01:47:00 -0800
From: Prashant Gaikwad <pgaikwad@nvidia.com>
To: <swarren@nvidia.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, Prashant Gaikwad <pgaikwad@nvidia.com>
Subject: [PATCH 3/7] ASoC: tegra: remove auxdata
Date: Fri, 4 Jan 2013 15:16:39 +0530
Message-ID: <1357292803-28604-3-git-send-email-pgaikwad@nvidia.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1357292803-28604-1-git-send-email-pgaikwad@nvidia.com>
References: <1357292803-28604-1-git-send-email-pgaikwad@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Configlink clock information is added to device tree. Get the clocks
using device node. Remove AUXDATA.

Signed-off-by: Prashant Gaikwad <pgaikwad@nvidia.com>
---
 sound/soc/tegra/tegra30_ahub.c |   14 ++------------
 1 files changed, 2 insertions(+), 12 deletions(-)

diff --git a/sound/soc/tegra/tegra30_ahub.c b/sound/soc/tegra/tegra30_ahub.c
index bb31c41..2355630 100644
--- a/sound/soc/tegra/tegra30_ahub.c
+++ b/sound/soc/tegra/tegra30_ahub.c
@@ -299,15 +299,6 @@ static const char * const configlink_clocks[] = {
 	"spdif_in",
 };
 
-struct of_dev_auxdata ahub_auxdata[] = {
-	OF_DEV_AUXDATA("nvidia,tegra30-i2s", 0x70080300, "tegra30-i2s.0", NULL),
-	OF_DEV_AUXDATA("nvidia,tegra30-i2s", 0x70080400, "tegra30-i2s.1", NULL),
-	OF_DEV_AUXDATA("nvidia,tegra30-i2s", 0x70080500, "tegra30-i2s.2", NULL),
-	OF_DEV_AUXDATA("nvidia,tegra30-i2s", 0x70080600, "tegra30-i2s.3", NULL),
-	OF_DEV_AUXDATA("nvidia,tegra30-i2s", 0x70080700, "tegra30-i2s.4", NULL),
-	{}
-};
-
 #define LAST_REG(name) \
 	(TEGRA30_AHUB_##name + \
 	 (TEGRA30_AHUB_##name##_STRIDE * TEGRA30_AHUB_##name##_COUNT) - 4)
@@ -451,7 +442,7 @@ static int tegra30_ahub_probe(struct platform_device *pdev)
 	 * Ensure that here.
 	 */
 	for (i = 0; i < ARRAY_SIZE(configlink_clocks); i++) {
-		clk = clk_get_sys(NULL, configlink_clocks[i]);
+		clk = clk_get(&pdev->dev, configlink_clocks[i]);
 		if (IS_ERR(clk)) {
 			dev_err(&pdev->dev, "Can't get clock %s\n",
 				configlink_clocks[i]);
@@ -569,8 +560,7 @@ static int tegra30_ahub_probe(struct platform_device *pdev)
 			goto err_pm_disable;
 	}
 
-	of_platform_populate(pdev->dev.of_node, NULL, ahub_auxdata,
-			     &pdev->dev);
+	of_platform_populate(pdev->dev.of_node, NULL, NULL, &pdev->dev);
 
 	return 0;
 
-- 
1.7.4.1

