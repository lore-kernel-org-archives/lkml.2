Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932574Ab1BRDIX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 22:08:23 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:51879 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932425Ab1BRDIK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 22:08:10 -0500
From: Andres Salomon <dilinger@queued.net>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@stericsson.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 18/29] mfd-core: rename platform_data field of mfd_cell to mfd_data
Date: Thu, 17 Feb 2011 19:07:25 -0800
Message-Id: <1297998456-7615-19-git-send-email-dilinger@queued.net>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1297998456-7615-1-git-send-email-dilinger@queued.net>
References: <1297998456-7615-1-git-send-email-dilinger@queued.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename the platform_data variable to imply a distinction between
common platform_data driver usage (typically accessed via
pdev->dev.platform_data) and the way MFD passes data down to
clients (using a wrapper named mfd_get_data).

All clients have already been changed to use the wrapper function,
so this can be a quick single-commit change that only touches things
in drivers/mfd.

Signed-off-by: Andres Salomon <dilinger@queued.net>
Acked-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/mfd/ab3100-core.c   |    2 +-
 drivers/mfd/ab3550-core.c   |    2 +-
 drivers/mfd/janz-cmodio.c   |    2 +-
 drivers/mfd/mc13xxx-core.c  |    2 +-
 drivers/mfd/timberdale.c    |   54 +++++++++++++++++++++---------------------
 drivers/mfd/twl4030-codec.c |    4 +-
 drivers/mfd/wl1273-core.c   |    4 +-
 include/linux/mfd/core.h    |    8 +++---
 8 files changed, 39 insertions(+), 39 deletions(-)

diff --git a/drivers/mfd/ab3100-core.c b/drivers/mfd/ab3100-core.c
index b44c3d9..865251e 100644
--- a/drivers/mfd/ab3100-core.c
+++ b/drivers/mfd/ab3100-core.c
@@ -950,7 +950,7 @@ static int __devinit ab3100_probe(struct i2c_client *client,
 
 	/* Set up and register the platform devices. */
 	for (i = 0; i < ARRAY_SIZE(ab3100_devs); i++)
-		ab3100_devs[i].platform_data = ab3100_plf_data;
+		ab3100_devs[i].mfd_data = ab3100_plf_data;
 
 	err = mfd_add_devices(&client->dev, 0, ab3100_devs,
 		ARRAY_SIZE(ab3100_devs), NULL, 0);
diff --git a/drivers/mfd/ab3550-core.c b/drivers/mfd/ab3550-core.c
index d849087..f4c12a4 100644
--- a/drivers/mfd/ab3550-core.c
+++ b/drivers/mfd/ab3550-core.c
@@ -1321,7 +1321,7 @@ static int __init ab3550_probe(struct i2c_client *client,
 
 	/* Set up and register the platform devices. */
 	for (i = 0; i < AB3550_NUM_DEVICES; i++)
-		ab3550_devs[i].platform_data = ab3550_plf_data->dev_data[i];
+		ab3550_devs[i].mfd_data = ab3550_plf_data->dev_data[i];
 
 	err = mfd_add_devices(&client->dev, 0, ab3550_devs,
 		ARRAY_SIZE(ab3550_devs), NULL,
diff --git a/drivers/mfd/janz-cmodio.c b/drivers/mfd/janz-cmodio.c
index 58de1e2..fc41911 100644
--- a/drivers/mfd/janz-cmodio.c
+++ b/drivers/mfd/janz-cmodio.c
@@ -86,7 +86,7 @@ static int __devinit cmodio_setup_subdevice(struct cmodio_device *priv,
 
 	/* Add platform data */
 	pdata->modno = modno;
-	cell->platform_data = pdata;
+	cell->mfd_data = pdata;
 
 	/* MODULbus registers -- PCI BAR3 is big-endian MODULbus access */
 	res->flags = IORESOURCE_MEM;
diff --git a/drivers/mfd/mc13xxx-core.c b/drivers/mfd/mc13xxx-core.c
index 00c5490..b19b50a 100644
--- a/drivers/mfd/mc13xxx-core.c
+++ b/drivers/mfd/mc13xxx-core.c
@@ -689,7 +689,7 @@ static int mc13xxx_add_subdevice_pdata(struct mc13xxx *mc13xxx,
 	const char *name = mc13xxx_get_chipname(mc13xxx);
 
 	struct mfd_cell cell = {
-		.platform_data = pdata,
+		.mfd_data = pdata,
 	};
 
 	/* there is no asnprintf in the kernel :-( */
diff --git a/drivers/mfd/timberdale.c b/drivers/mfd/timberdale.c
index 6353921..94c6c8a 100644
--- a/drivers/mfd/timberdale.c
+++ b/drivers/mfd/timberdale.c
@@ -384,7 +384,7 @@ static __devinitdata struct mfd_cell timberdale_cells_bar0_cfg0[] = {
 		.name = "timb-dma",
 		.num_resources = ARRAY_SIZE(timberdale_dma_resources),
 		.resources = timberdale_dma_resources,
-		.platform_data = &timb_dma_platform_data,
+		.mfd_data = &timb_dma_platform_data,
 	},
 	{
 		.name = "timb-uart",
@@ -395,37 +395,37 @@ static __devinitdata struct mfd_cell timberdale_cells_bar0_cfg0[] = {
 		.name = "xiic-i2c",
 		.num_resources = ARRAY_SIZE(timberdale_xiic_resources),
 		.resources = timberdale_xiic_resources,
-		.platform_data = &timberdale_xiic_platform_data,
+		.mfd_data = &timberdale_xiic_platform_data,
 	},
 	{
 		.name = "timb-gpio",
 		.num_resources = ARRAY_SIZE(timberdale_gpio_resources),
 		.resources = timberdale_gpio_resources,
-		.platform_data = &timberdale_gpio_platform_data,
+		.mfd_data = &timberdale_gpio_platform_data,
 	},
 	{
 		.name = "timb-video",
 		.num_resources = ARRAY_SIZE(timberdale_video_resources),
 		.resources = timberdale_video_resources,
-		.platform_data = &timberdale_video_platform_data,
+		.mfd_data = &timberdale_video_platform_data,
 	},
 	{
 		.name = "timb-radio",
 		.num_resources = ARRAY_SIZE(timberdale_radio_resources),
 		.resources = timberdale_radio_resources,
-		.platform_data = &timberdale_radio_platform_data,
+		.mfd_data = &timberdale_radio_platform_data,
 	},
 	{
 		.name = "xilinx_spi",
 		.num_resources = ARRAY_SIZE(timberdale_spi_resources),
 		.resources = timberdale_spi_resources,
-		.platform_data = &timberdale_xspi_platform_data,
+		.mfd_data = &timberdale_xspi_platform_data,
 	},
 	{
 		.name = "ks8842",
 		.num_resources = ARRAY_SIZE(timberdale_eth_resources),
 		.resources = timberdale_eth_resources,
-		.platform_data = &timberdale_ks8842_platform_data,
+		.mfd_data = &timberdale_ks8842_platform_data,
 	},
 };
 
@@ -434,7 +434,7 @@ static __devinitdata struct mfd_cell timberdale_cells_bar0_cfg1[] = {
 		.name = "timb-dma",
 		.num_resources = ARRAY_SIZE(timberdale_dma_resources),
 		.resources = timberdale_dma_resources,
-		.platform_data = &timb_dma_platform_data,
+		.mfd_data = &timb_dma_platform_data,
 	},
 	{
 		.name = "timb-uart",
@@ -450,13 +450,13 @@ static __devinitdata struct mfd_cell timberdale_cells_bar0_cfg1[] = {
 		.name = "xiic-i2c",
 		.num_resources = ARRAY_SIZE(timberdale_xiic_resources),
 		.resources = timberdale_xiic_resources,
-		.platform_data = &timberdale_xiic_platform_data,
+		.mfd_data = &timberdale_xiic_platform_data,
 	},
 	{
 		.name = "timb-gpio",
 		.num_resources = ARRAY_SIZE(timberdale_gpio_resources),
 		.resources = timberdale_gpio_resources,
-		.platform_data = &timberdale_gpio_platform_data,
+		.mfd_data = &timberdale_gpio_platform_data,
 	},
 	{
 		.name = "timb-mlogicore",
@@ -467,25 +467,25 @@ static __devinitdata struct mfd_cell timberdale_cells_bar0_cfg1[] = {
 		.name = "timb-video",
 		.num_resources = ARRAY_SIZE(timberdale_video_resources),
 		.resources = timberdale_video_resources,
-		.platform_data = &timberdale_video_platform_data,
+		.mfd_data = &timberdale_video_platform_data,
 	},
 	{
 		.name = "timb-radio",
 		.num_resources = ARRAY_SIZE(timberdale_radio_resources),
 		.resources = timberdale_radio_resources,
-		.platform_data = &timberdale_radio_platform_data,
+		.mfd_data = &timberdale_radio_platform_data,
 	},
 	{
 		.name = "xilinx_spi",
 		.num_resources = ARRAY_SIZE(timberdale_spi_resources),
 		.resources = timberdale_spi_resources,
-		.platform_data = &timberdale_xspi_platform_data,
+		.mfd_data = &timberdale_xspi_platform_data,
 	},
 	{
 		.name = "ks8842",
 		.num_resources = ARRAY_SIZE(timberdale_eth_resources),
 		.resources = timberdale_eth_resources,
-		.platform_data = &timberdale_ks8842_platform_data,
+		.mfd_data = &timberdale_ks8842_platform_data,
 	},
 };
 
@@ -494,7 +494,7 @@ static __devinitdata struct mfd_cell timberdale_cells_bar0_cfg2[] = {
 		.name = "timb-dma",
 		.num_resources = ARRAY_SIZE(timberdale_dma_resources),
 		.resources = timberdale_dma_resources,
-		.platform_data = &timb_dma_platform_data,
+		.mfd_data = &timb_dma_platform_data,
 	},
 	{
 		.name = "timb-uart",
@@ -505,31 +505,31 @@ static __devinitdata struct mfd_cell timberdale_cells_bar0_cfg2[] = {
 		.name = "xiic-i2c",
 		.num_resources = ARRAY_SIZE(timberdale_xiic_resources),
 		.resources = timberdale_xiic_resources,
-		.platform_data = &timberdale_xiic_platform_data,
+		.mfd_data = &timberdale_xiic_platform_data,
 	},
 	{
 		.name = "timb-gpio",
 		.num_resources = ARRAY_SIZE(timberdale_gpio_resources),
 		.resources = timberdale_gpio_resources,
-		.platform_data = &timberdale_gpio_platform_data,
+		.mfd_data = &timberdale_gpio_platform_data,
 	},
 	{
 		.name = "timb-video",
 		.num_resources = ARRAY_SIZE(timberdale_video_resources),
 		.resources = timberdale_video_resources,
-		.platform_data = &timberdale_video_platform_data,
+		.mfd_data = &timberdale_video_platform_data,
 	},
 	{
 		.name = "timb-radio",
 		.num_resources = ARRAY_SIZE(timberdale_radio_resources),
 		.resources = timberdale_radio_resources,
-		.platform_data = &timberdale_radio_platform_data,
+		.mfd_data = &timberdale_radio_platform_data,
 	},
 	{
 		.name = "xilinx_spi",
 		.num_resources = ARRAY_SIZE(timberdale_spi_resources),
 		.resources = timberdale_spi_resources,
-		.platform_data = &timberdale_xspi_platform_data,
+		.mfd_data = &timberdale_xspi_platform_data,
 	},
 };
 
@@ -538,7 +538,7 @@ static __devinitdata struct mfd_cell timberdale_cells_bar0_cfg3[] = {
 		.name = "timb-dma",
 		.num_resources = ARRAY_SIZE(timberdale_dma_resources),
 		.resources = timberdale_dma_resources,
-		.platform_data = &timb_dma_platform_data,
+		.mfd_data = &timb_dma_platform_data,
 	},
 	{
 		.name = "timb-uart",
@@ -549,37 +549,37 @@ static __devinitdata struct mfd_cell timberdale_cells_bar0_cfg3[] = {
 		.name = "ocores-i2c",
 		.num_resources = ARRAY_SIZE(timberdale_ocores_resources),
 		.resources = timberdale_ocores_resources,
-		.platform_data = &timberdale_ocores_platform_data,
+		.mfd_data = &timberdale_ocores_platform_data,
 	},
 	{
 		.name = "timb-gpio",
 		.num_resources = ARRAY_SIZE(timberdale_gpio_resources),
 		.resources = timberdale_gpio_resources,
-		.platform_data = &timberdale_gpio_platform_data,
+		.mfd_data = &timberdale_gpio_platform_data,
 	},
 	{
 		.name = "timb-video",
 		.num_resources = ARRAY_SIZE(timberdale_video_resources),
 		.resources = timberdale_video_resources,
-		.platform_data = &timberdale_video_platform_data,
+		.mfd_data = &timberdale_video_platform_data,
 	},
 	{
 		.name = "timb-radio",
 		.num_resources = ARRAY_SIZE(timberdale_radio_resources),
 		.resources = timberdale_radio_resources,
-		.platform_data = &timberdale_radio_platform_data,
+		.mfd_data = &timberdale_radio_platform_data,
 	},
 	{
 		.name = "xilinx_spi",
 		.num_resources = ARRAY_SIZE(timberdale_spi_resources),
 		.resources = timberdale_spi_resources,
-		.platform_data = &timberdale_xspi_platform_data,
+		.mfd_data = &timberdale_xspi_platform_data,
 	},
 	{
 		.name = "ks8842",
 		.num_resources = ARRAY_SIZE(timberdale_eth_resources),
 		.resources = timberdale_eth_resources,
-		.platform_data = &timberdale_ks8842_platform_data,
+		.mfd_data = &timberdale_ks8842_platform_data,
 	},
 };
 
diff --git a/drivers/mfd/twl4030-codec.c b/drivers/mfd/twl4030-codec.c
index 0f57426..c02fded 100644
--- a/drivers/mfd/twl4030-codec.c
+++ b/drivers/mfd/twl4030-codec.c
@@ -208,13 +208,13 @@ static int __devinit twl4030_codec_probe(struct platform_device *pdev)
 	if (pdata->audio) {
 		cell = &codec->cells[childs];
 		cell->name = "twl4030-codec";
-		cell->platform_data = pdata->audio;
+		cell->mfd_data = pdata->audio;
 		childs++;
 	}
 	if (pdata->vibra) {
 		cell = &codec->cells[childs];
 		cell->name = "twl4030-vibra";
-		cell->platform_data = pdata->vibra;
+		cell->mfd_data = pdata->vibra;
 		childs++;
 	}
 
diff --git a/drivers/mfd/wl1273-core.c b/drivers/mfd/wl1273-core.c
index 703085e..f49e04e 100644
--- a/drivers/mfd/wl1273-core.c
+++ b/drivers/mfd/wl1273-core.c
@@ -79,7 +79,7 @@ static int __devinit wl1273_core_probe(struct i2c_client *client,
 
 	cell = &core->cells[children];
 	cell->name = "wl1273_fm_radio";
-	cell->platform_data = &core;
+	cell->mfd_data = &core;
 	children++;
 
 	if (pdata->children & WL1273_CODEC_CHILD) {
@@ -87,7 +87,7 @@ static int __devinit wl1273_core_probe(struct i2c_client *client,
 
 		dev_dbg(&client->dev, "%s: Have codec.\n", __func__);
 		cell->name = "wl1273-codec";
-		cell->platform_data = &core;
+		cell->mfd_data = &core;
 		children++;
 	}
 
diff --git a/include/linux/mfd/core.h b/include/linux/mfd/core.h
index 923ec25..f317fe4 100644
--- a/include/linux/mfd/core.h
+++ b/include/linux/mfd/core.h
@@ -33,8 +33,8 @@ struct mfd_cell {
 	/* driver-specific data for MFD-aware "cell" drivers */
 	void			*driver_data;
 
-	/* platform_data can be used to pass data to "generic" drivers */
-	void			*platform_data;
+	/* mfd_data can be used to pass data to client drivers */
+	void			*mfd_data;
 
 	/*
 	 * These resources can be specified relative to the parent device.
@@ -64,11 +64,11 @@ static inline const struct mfd_cell *mfd_get_cell(struct platform_device *pdev)
 
 /*
  * Given a platform device that's been created by mfd_add_devices(), fetch
- * the .platform_data entry from the mfd_cell that created it.
+ * the .mfd_data entry from the mfd_cell that created it.
  */
 static inline void *mfd_get_data(struct platform_device *pdev)
 {
-	return mfd_get_cell(pdev)->platform_data;
+	return mfd_get_cell(pdev)->mfd_data;
 }
 
 extern int mfd_add_devices(struct device *parent, int id,
-- 
1.7.2.3

