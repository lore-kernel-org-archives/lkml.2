Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759215Ab2FAJOG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 05:14:06 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:15606 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757974Ab2FAJOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 05:14:00 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Fri, 01 Jun 2012 02:13:59 -0700
From: Prashant Gaikwad <pgaikwad@nvidia.com>
To: <swarren@nvidia.com>, <linux-tegra@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
CC: <linux-kernel@vger.kernel.org>, <olof@lixom.net>,
        Prashant Gaikwad <pgaikwad@nvidia.com>, <perex@perex.cz>,
        <tiwai@suse.de>, <alsa-devel@alsa-project.org>
Subject: [PATCH 8/9] ASoC: tegra: add clk_prepare/clk_unprepare
Date: Fri, 1 Jun 2012 14:42:47 +0530
Message-ID: <1338541968-7961-9-git-send-email-pgaikwad@nvidia.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1338541968-7961-1-git-send-email-pgaikwad@nvidia.com>
References: <1338541968-7961-1-git-send-email-pgaikwad@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use clk_prepare/clk_unprepare as required by the generic clk framework.

This patch should go through Tegra tree since other patches to port Tegra
to generic clock framework are dependent on it. Posting here to get ack from
the maintainers.

Signed-off-by: Prashant Gaikwad <pgaikwad@nvidia.com>
---
 sound/soc/tegra/tegra20_i2s.c      |    4 ++--
 sound/soc/tegra/tegra20_spdif.c    |    4 ++--
 sound/soc/tegra/tegra30_ahub.c     |    8 ++++----
 sound/soc/tegra/tegra30_i2s.c      |    4 ++--
 sound/soc/tegra/tegra_asoc_utils.c |   12 ++++++------
 5 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/sound/soc/tegra/tegra20_i2s.c b/sound/soc/tegra/tegra20_i2s.c
index 0c7af63..1647dbf 100644
--- a/sound/soc/tegra/tegra20_i2s.c
+++ b/sound/soc/tegra/tegra20_i2s.c
@@ -62,7 +62,7 @@ static int tegra20_i2s_runtime_suspend(struct device *dev)
 {
 	struct tegra20_i2s *i2s = dev_get_drvdata(dev);
 
-	clk_disable(i2s->clk_i2s);
+	clk_disable_unprepare(i2s->clk_i2s);
 
 	return 0;
 }
@@ -72,7 +72,7 @@ static int tegra20_i2s_runtime_resume(struct device *dev)
 	struct tegra20_i2s *i2s = dev_get_drvdata(dev);
 	int ret;
 
-	ret = clk_enable(i2s->clk_i2s);
+	ret = clk_prepare_enable(i2s->clk_i2s);
 	if (ret) {
 		dev_err(dev, "clk_enable failed: %d\n", ret);
 		return ret;
diff --git a/sound/soc/tegra/tegra20_spdif.c b/sound/soc/tegra/tegra20_spdif.c
index f9b5741..2262e4f 100644
--- a/sound/soc/tegra/tegra20_spdif.c
+++ b/sound/soc/tegra/tegra20_spdif.c
@@ -54,7 +54,7 @@ static int tegra20_spdif_runtime_suspend(struct device *dev)
 {
 	struct tegra20_spdif *spdif = dev_get_drvdata(dev);
 
-	clk_disable(spdif->clk_spdif_out);
+	clk_disable_unprepare(spdif->clk_spdif_out);
 
 	return 0;
 }
@@ -64,7 +64,7 @@ static int tegra20_spdif_runtime_resume(struct device *dev)
 	struct tegra20_spdif *spdif = dev_get_drvdata(dev);
 	int ret;
 
-	ret = clk_enable(spdif->clk_spdif_out);
+	ret = clk_prepare_enable(spdif->clk_spdif_out);
 	if (ret) {
 		dev_err(dev, "clk_enable failed: %d\n", ret);
 		return ret;
diff --git a/sound/soc/tegra/tegra30_ahub.c b/sound/soc/tegra/tegra30_ahub.c
index 57cd419..1efb822 100644
--- a/sound/soc/tegra/tegra30_ahub.c
+++ b/sound/soc/tegra/tegra30_ahub.c
@@ -56,8 +56,8 @@ static int tegra30_ahub_runtime_suspend(struct device *dev)
 	regcache_cache_only(ahub->regmap_apbif, true);
 	regcache_cache_only(ahub->regmap_ahub, true);
 
-	clk_disable(ahub->clk_apbif);
-	clk_disable(ahub->clk_d_audio);
+	clk_disable_unprepare(ahub->clk_apbif);
+	clk_disable_unprepare(ahub->clk_d_audio);
 
 	return 0;
 }
@@ -77,12 +77,12 @@ static int tegra30_ahub_runtime_resume(struct device *dev)
 {
 	int ret;
 
-	ret = clk_enable(ahub->clk_d_audio);
+	ret = clk_prepare_enable(ahub->clk_d_audio);
 	if (ret) {
 		dev_err(dev, "clk_enable d_audio failed: %d\n", ret);
 		return ret;
 	}
-	ret = clk_enable(ahub->clk_apbif);
+	ret = clk_prepare_enable(ahub->clk_apbif);
 	if (ret) {
 		dev_err(dev, "clk_enable apbif failed: %d\n", ret);
 		clk_disable(ahub->clk_d_audio);
diff --git a/sound/soc/tegra/tegra30_i2s.c b/sound/soc/tegra/tegra30_i2s.c
index 8596032..d308faa 100644
--- a/sound/soc/tegra/tegra30_i2s.c
+++ b/sound/soc/tegra/tegra30_i2s.c
@@ -62,7 +62,7 @@ static int tegra30_i2s_runtime_suspend(struct device *dev)
 
 	regcache_cache_only(i2s->regmap, true);
 
-	clk_disable(i2s->clk_i2s);
+	clk_disable_unprepare(i2s->clk_i2s);
 
 	return 0;
 }
@@ -72,7 +72,7 @@ static int tegra30_i2s_runtime_resume(struct device *dev)
 	struct tegra30_i2s *i2s = dev_get_drvdata(dev);
 	int ret;
 
-	ret = clk_enable(i2s->clk_i2s);
+	ret = clk_prepare_enable(i2s->clk_i2s);
 	if (ret) {
 		dev_err(dev, "clk_enable failed: %d\n", ret);
 		return ret;
diff --git a/sound/soc/tegra/tegra_asoc_utils.c b/sound/soc/tegra/tegra_asoc_utils.c
index 9515ce5..6872c77 100644
--- a/sound/soc/tegra/tegra_asoc_utils.c
+++ b/sound/soc/tegra/tegra_asoc_utils.c
@@ -69,9 +69,9 @@ int tegra_asoc_utils_set_rate(struct tegra_asoc_utils_data *data, int srate,
 	data->set_baseclock = 0;
 	data->set_mclk = 0;
 
-	clk_disable(data->clk_cdev1);
-	clk_disable(data->clk_pll_a_out0);
-	clk_disable(data->clk_pll_a);
+	clk_disable_unprepare(data->clk_cdev1);
+	clk_disable_unprepare(data->clk_pll_a_out0);
+	clk_disable_unprepare(data->clk_pll_a);
 
 	err = clk_set_rate(data->clk_pll_a, new_baseclock);
 	if (err) {
@@ -87,19 +87,19 @@ int tegra_asoc_utils_set_rate(struct tegra_asoc_utils_data *data, int srate,
 
 	/* Don't set cdev1/extern1 rate; it's locked to pll_a_out0 */
 
-	err = clk_enable(data->clk_pll_a);
+	err = clk_prepare_enable(data->clk_pll_a);
 	if (err) {
 		dev_err(data->dev, "Can't enable pll_a: %d\n", err);
 		return err;
 	}
 
-	err = clk_enable(data->clk_pll_a_out0);
+	err = clk_prepare_enable(data->clk_pll_a_out0);
 	if (err) {
 		dev_err(data->dev, "Can't enable pll_a_out0: %d\n", err);
 		return err;
 	}
 
-	err = clk_enable(data->clk_cdev1);
+	err = clk_prepare_enable(data->clk_cdev1);
 	if (err) {
 		dev_err(data->dev, "Can't enable cdev1: %d\n", err);
 		return err;
-- 
1.7.4.1

