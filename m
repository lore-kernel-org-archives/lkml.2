Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756623Ab1BRDKy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 22:10:54 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:51899 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932505Ab1BRDIO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 22:08:14 -0500
From: Andres Salomon <dilinger@queued.net>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, Ian Molton <ian@mnementh.co.uk>,
        Chris Ball <cjb@laptop.org>, linux-mmc@vger.kernel.org
Subject: [PATCH 22/29] tmio-mmc: use mfd_data instead of driver_data
Date: Thu, 17 Feb 2011 19:07:29 -0800
Message-Id: <1297998456-7615-23-git-send-email-dilinger@queued.net>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1297998456-7615-1-git-send-email-dilinger@queued.net>
References: <1297998456-7615-1-git-send-email-dilinger@queued.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use mfd_data for passing information from mfd drivers to mfd
clients.  The mfd_cell's driver_data field is being phased out.

Clients that were using driver_data now access .mfd_data
via mfd_get_data().  This changes tmio-mmc only; mfd drivers with
other cells are not modified.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 drivers/mfd/asic3.c          |    2 +-
 drivers/mfd/sh_mobile_sdhi.c |    2 +-
 drivers/mfd/t7l66xb.c        |    2 +-
 drivers/mfd/tc6387xb.c       |    2 +-
 drivers/mfd/tc6393xb.c       |    2 +-
 drivers/mmc/host/tmio_mmc.c  |   26 +++++++++-----------------
 6 files changed, 14 insertions(+), 22 deletions(-)

diff --git a/drivers/mfd/asic3.c b/drivers/mfd/asic3.c
index 549d14d..d0d247d 100644
--- a/drivers/mfd/asic3.c
+++ b/drivers/mfd/asic3.c
@@ -783,7 +783,7 @@ static struct mfd_cell asic3_cell_mmc = {
 	.name          = "tmio-mmc",
 	.enable        = asic3_mmc_enable,
 	.disable       = asic3_mmc_disable,
-	.driver_data   = &asic3_mmc_data,
+	.mfd_data      = &asic3_mmc_data,
 	.num_resources = ARRAY_SIZE(asic3_mmc_resources),
 	.resources     = asic3_mmc_resources,
 };
diff --git a/drivers/mfd/sh_mobile_sdhi.c b/drivers/mfd/sh_mobile_sdhi.c
index b511e74..53a6302 100644
--- a/drivers/mfd/sh_mobile_sdhi.c
+++ b/drivers/mfd/sh_mobile_sdhi.c
@@ -146,7 +146,7 @@ static int __devinit sh_mobile_sdhi_probe(struct platform_device *pdev)
 	}
 
 	memcpy(&priv->cell_mmc, &sh_mobile_sdhi_cell, sizeof(priv->cell_mmc));
-	priv->cell_mmc.driver_data = mmc_data;
+	priv->cell_mmc.mfd_data = mmc_data;
 
 	platform_set_drvdata(pdev, priv);
 
diff --git a/drivers/mfd/t7l66xb.c b/drivers/mfd/t7l66xb.c
index b9c1e4c..3c9e389 100644
--- a/drivers/mfd/t7l66xb.c
+++ b/drivers/mfd/t7l66xb.c
@@ -170,7 +170,7 @@ static struct mfd_cell t7l66xb_cells[] = {
 		.name = "tmio-mmc",
 		.enable = t7l66xb_mmc_enable,
 		.disable = t7l66xb_mmc_disable,
-		.driver_data = &t7166xb_mmc_data,
+		.mfd_data = &t7166xb_mmc_data,
 		.num_resources = ARRAY_SIZE(t7l66xb_mmc_resources),
 		.resources = t7l66xb_mmc_resources,
 	},
diff --git a/drivers/mfd/tc6387xb.c b/drivers/mfd/tc6387xb.c
index 6bf1775..b006f7c 100644
--- a/drivers/mfd/tc6387xb.c
+++ b/drivers/mfd/tc6387xb.c
@@ -131,7 +131,7 @@ static struct mfd_cell tc6387xb_cells[] = {
 		.name = "tmio-mmc",
 		.enable = tc6387xb_mmc_enable,
 		.disable = tc6387xb_mmc_disable,
-		.driver_data = &tc6387xb_mmc_data,
+		.mfd_data = &tc6387xb_mmc_data,
 		.num_resources = ARRAY_SIZE(tc6387xb_mmc_resources),
 		.resources = tc6387xb_mmc_resources,
 	},
diff --git a/drivers/mfd/tc6393xb.c b/drivers/mfd/tc6393xb.c
index a71ff5c..7f7b9fa 100644
--- a/drivers/mfd/tc6393xb.c
+++ b/drivers/mfd/tc6393xb.c
@@ -393,7 +393,7 @@ static struct mfd_cell __devinitdata tc6393xb_cells[] = {
 		.name = "tmio-mmc",
 		.enable = tc6393xb_mmc_enable,
 		.resume = tc6393xb_mmc_resume,
-		.driver_data = &tc6393xb_mmc_data,
+		.mfd_data = &tc6393xb_mmc_data,
 		.num_resources = ARRAY_SIZE(tc6393xb_mmc_resources),
 		.resources = tc6393xb_mmc_resources,
 	},
diff --git a/drivers/mmc/host/tmio_mmc.c b/drivers/mmc/host/tmio_mmc.c
index 816fb74..f7d3fa9 100644
--- a/drivers/mmc/host/tmio_mmc.c
+++ b/drivers/mmc/host/tmio_mmc.c
@@ -300,8 +300,7 @@ static void tmio_mmc_set_clock(struct tmio_mmc_host *host, int new_clock)
 
 static void tmio_mmc_clk_stop(struct tmio_mmc_host *host)
 {
-	struct mfd_cell *cell = mfd_get_cell(host->pdev);
-	struct tmio_mmc_data *pdata = cell->driver_data;
+	struct tmio_mmc_data *pdata = mfd_get_data(host->pdev);
 
 	/*
 	 * Testing on sh-mobile showed that SDIO IRQs are unmasked when
@@ -324,8 +323,7 @@ static void tmio_mmc_clk_stop(struct tmio_mmc_host *host)
 
 static void tmio_mmc_clk_start(struct tmio_mmc_host *host)
 {
-	struct mfd_cell *cell = mfd_get_cell(host->pdev);
-	struct tmio_mmc_data *pdata = cell->driver_data;
+	struct tmio_mmc_data *pdata = mfd_get_data(host->pdev);
 
 	sd_ctrl_write16(host, CTL_SD_CARD_CLK_CTL, 0x0100 |
 		sd_ctrl_read16(host, CTL_SD_CARD_CLK_CTL));
@@ -666,8 +664,7 @@ out:
 static irqreturn_t tmio_mmc_irq(int irq, void *devid)
 {
 	struct tmio_mmc_host *host = devid;
-	struct mfd_cell	*cell = mfd_get_cell(host->pdev);
-	struct tmio_mmc_data *pdata = cell->driver_data;
+	struct tmio_mmc_data *pdata = mfd_get_data(host->pdev);
 	unsigned int ireg, irq_mask, status;
 	unsigned int sdio_ireg, sdio_irq_mask, sdio_status;
 
@@ -796,8 +793,7 @@ static void tmio_mmc_start_dma_rx(struct tmio_mmc_host *host)
 	struct scatterlist *sg = host->sg_ptr, *sg_tmp;
 	struct dma_async_tx_descriptor *desc = NULL;
 	struct dma_chan *chan = host->chan_rx;
-	struct mfd_cell	*cell = mfd_get_cell(host->pdev);
-	struct tmio_mmc_data *pdata = cell->driver_data;
+	struct tmio_mmc_data *pdata = mfd_get_data(host->pdev);
 	dma_cookie_t cookie;
 	int ret, i;
 	bool aligned = true, multiple = true;
@@ -873,8 +869,7 @@ static void tmio_mmc_start_dma_tx(struct tmio_mmc_host *host)
 	struct scatterlist *sg = host->sg_ptr, *sg_tmp;
 	struct dma_async_tx_descriptor *desc = NULL;
 	struct dma_chan *chan = host->chan_tx;
-	struct mfd_cell	*cell = mfd_get_cell(host->pdev);
-	struct tmio_mmc_data *pdata = cell->driver_data;
+	struct tmio_mmc_data *pdata = mfd_get_data(host->pdev);
 	dma_cookie_t cookie;
 	int ret, i;
 	bool aligned = true, multiple = true;
@@ -1071,8 +1066,7 @@ static void tmio_mmc_release_dma(struct tmio_mmc_host *host)
 static int tmio_mmc_start_data(struct tmio_mmc_host *host,
 	struct mmc_data *data)
 {
-	struct mfd_cell *cell = mfd_get_cell(host->pdev);
-	struct tmio_mmc_data *pdata = cell->driver_data;
+	struct tmio_mmc_data *pdata = mfd_get_data(host->pdev);
 
 	pr_debug("setup data transfer: blocksize %08x  nr_blocks %d\n",
 		 data->blksz, data->blocks);
@@ -1177,8 +1171,7 @@ static void tmio_mmc_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 static int tmio_mmc_get_ro(struct mmc_host *mmc)
 {
 	struct tmio_mmc_host *host = mmc_priv(mmc);
-	struct mfd_cell	*cell = mfd_get_cell(host->pdev);
-	struct tmio_mmc_data *pdata = cell->driver_data;
+	struct tmio_mmc_data *pdata = mfd_get_data(host->pdev);
 
 	return ((pdata->flags & TMIO_MMC_WRPROTECT_DISABLE) ||
 		(sd_ctrl_read32(host, CTL_STATUS) & TMIO_STAT_WRPROTECT)) ? 0 : 1;
@@ -1187,8 +1180,7 @@ static int tmio_mmc_get_ro(struct mmc_host *mmc)
 static int tmio_mmc_get_cd(struct mmc_host *mmc)
 {
 	struct tmio_mmc_host *host = mmc_priv(mmc);
-	struct mfd_cell	*cell = mfd_get_cell(host->pdev);
-	struct tmio_mmc_data *pdata = cell->driver_data;
+	struct tmio_mmc_data *pdata = mfd_get_data(host->pdev);
 
 	if (!pdata->get_cd)
 		return -ENOSYS;
@@ -1260,7 +1252,7 @@ static int __devinit tmio_mmc_probe(struct platform_device *dev)
 	if (!res_ctl)
 		goto out;
 
-	pdata = cell->driver_data;
+	pdata = mfd_get_data(dev);
 	if (!pdata || !pdata->hclk)
 		goto out;
 
-- 
1.7.2.3

