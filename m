Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758648Ab2C1SN0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 14:13:26 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:34257 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758634Ab2C1SNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 14:13:24 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-12.tower-209.messagelabs.com!1332958350!1834142!54
X-Originating-IP: [216.166.12.178]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/5] arm: Use the plat_nand default partition parser
Date: Wed, 28 Mar 2012 11:13:09 -0700
User-Agent: KMail/1.9.9
CC: <linux-mtd@lists.infradead.org>, <rmallon@gmail.com>, <kaloz@openwrt.org>,
        <khc@pm.waw.pl>, <tony@atomide.com>, <alex@digriz.org.uk>,
        <nico@fluxnic.net>, <eric.y.miao@gmail.com>,
        <haojian.zhuang@gmail.com>, <marek.vasut@gmail.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201203281113.10684.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the default partition parser, cmdlinepart, provided by the plat_nand driver.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ryan Mallon <rmallon@gmail.com>
Cc: Imre Kaloz <kaloz@openwrt.org>
Cc: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Alexander Clouter <alex@digriz.org.uk>
Cc: Nicolas Pitre <nico@fluxnic.net>
Cc: Eric Miao <eric.y.miao@gmail.com>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Marek Vasut <marek.vasut@gmail.com>

---

diff --git a/arch/arm/mach-ep93xx/snappercl15.c b/arch/arm/mach-ep93xx/snappercl15.c
index 0c00852..5df9092 100644
--- a/arch/arm/mach-ep93xx/snappercl15.c
+++ b/arch/arm/mach-ep93xx/snappercl15.c
@@ -82,8 +82,6 @@ static int snappercl15_nand_dev_ready(struct mtd_info *mtd)
 	return !!(__raw_readw(NAND_CTRL_ADDR(chip)) & SNAPPERCL15_NAND_RDY);
 }
 
-static const char *snappercl15_nand_part_probes[] = {"cmdlinepart", NULL};
-
 static struct mtd_partition snappercl15_nand_parts[] = {
 	{
 		.name		= "Kernel",
@@ -100,7 +98,6 @@ static struct mtd_partition snappercl15_nand_parts[] = {
 static struct platform_nand_data snappercl15_nand_data = {
 	.chip = {
 		.nr_chips		= 1,
-		.part_probe_types	= snappercl15_nand_part_probes,
 		.partitions		= snappercl15_nand_parts,
 		.nr_partitions		= ARRAY_SIZE(snappercl15_nand_parts),
 		.options		= NAND_NO_AUTOINCR,
diff --git a/arch/arm/mach-ep93xx/ts72xx.c b/arch/arm/mach-ep93xx/ts72xx.c
index 5ea7909..14d7121 100644
--- a/arch/arm/mach-ep93xx/ts72xx.c
+++ b/arch/arm/mach-ep93xx/ts72xx.c
@@ -105,8 +105,6 @@ static int ts72xx_nand_device_ready(struct mtd_info *mtd)
 	return !!(__raw_readb(addr) & 0x20);
 }
 
-static const char *ts72xx_nand_part_probes[] = { "cmdlinepart", NULL };
-
 #define TS72XX_BOOTROM_PART_SIZE	(SZ_16K)
 #define TS72XX_REDBOOT_PART_SIZE	(SZ_2M + SZ_1M)
 
@@ -134,7 +132,6 @@ static struct platform_nand_data ts72xx_nand_data = {
 		.nr_chips	= 1,
 		.chip_offset	= 0,
 		.chip_delay	= 15,
-		.part_probe_types = ts72xx_nand_part_probes,
 		.partitions	= ts72xx_nand_parts,
 		.nr_partitions	= ARRAY_SIZE(ts72xx_nand_parts),
 	},
diff --git a/arch/arm/mach-ixp4xx/ixdp425-setup.c b/arch/arm/mach-ixp4xx/ixdp425-setup.c
index 3d742ae..fccfc73 100644
--- a/arch/arm/mach-ixp4xx/ixdp425-setup.c
+++ b/arch/arm/mach-ixp4xx/ixdp425-setup.c
@@ -60,8 +60,6 @@ static struct platform_device ixdp425_flash = {
 #if defined(CONFIG_MTD_NAND_PLATFORM) || \
     defined(CONFIG_MTD_NAND_PLATFORM_MODULE)
 
-const char *part_probes[] = { "cmdlinepart", NULL };
-
 static struct mtd_partition ixdp425_partitions[] = {
 	{
 		.name	= "ixp400 NAND FS 0",
@@ -101,7 +99,6 @@ static struct platform_nand_data ixdp425_flash_nand_data = {
 		.nr_chips		= 1,
 		.chip_delay		= 30,
 		.options		= NAND_NO_AUTOINCR,
-		.part_probe_types 	= part_probes,
 		.partitions	 	= ixdp425_partitions,
 		.nr_partitions	 	= ARRAY_SIZE(ixdp425_partitions),
 	},
diff --git a/arch/arm/mach-omap1/board-fsample.c b/arch/arm/mach-omap1/board-fsample.c
index 80bd43c..62a1e11 100644
--- a/arch/arm/mach-omap1/board-fsample.c
+++ b/arch/arm/mach-omap1/board-fsample.c
@@ -206,14 +206,11 @@ static int nand_dev_ready(struct mtd_info *mtd)
 	return gpio_get_value(FSAMPLE_NAND_RB_GPIO_PIN);
 }
 
-static const char *part_probes[] = { "cmdlinepart", NULL };
-
 static struct platform_nand_data nand_data = {
 	.chip	= {
 		.nr_chips		= 1,
 		.chip_offset		= 0,
 		.options		= NAND_SAMSUNG_LP_OPTIONS,
-		.part_probe_types	= part_probes,
 	},
 	.ctrl	= {
 		.cmd_ctrl	= nand_cmd_ctl,
diff --git a/arch/arm/mach-omap1/board-h2.c b/arch/arm/mach-omap1/board-h2.c
index c306862..a914a7d 100644
--- a/arch/arm/mach-omap1/board-h2.c
+++ b/arch/arm/mach-omap1/board-h2.c
@@ -200,8 +200,6 @@ static int h2_nand_dev_ready(struct mtd_info *mtd)
 	return gpio_get_value(H2_NAND_RB_GPIO_PIN);
 }
 
-static const char *h2_part_probes[] = { "cmdlinepart", NULL };
-
 static struct platform_nand_data h2_nand_platdata = {
 	.chip	= {
 		.nr_chips		= 1,
@@ -209,7 +207,6 @@ static struct platform_nand_data h2_nand_platdata = {
 		.nr_partitions		= ARRAY_SIZE(h2_nand_partitions),
 		.partitions		= h2_nand_partitions,
 		.options		= NAND_SAMSUNG_LP_OPTIONS,
-		.part_probe_types	= h2_part_probes,
 	},
 	.ctrl	= {
 		.cmd_ctrl	= h2_nand_cmd_ctl,
diff --git a/arch/arm/mach-omap1/board-h3.c b/arch/arm/mach-omap1/board-h3.c
index 64b8584..49952b9 100644
--- a/arch/arm/mach-omap1/board-h3.c
+++ b/arch/arm/mach-omap1/board-h3.c
@@ -202,8 +202,6 @@ static int nand_dev_ready(struct mtd_info *mtd)
 	return gpio_get_value(H3_NAND_RB_GPIO_PIN);
 }
 
-static const char *part_probes[] = { "cmdlinepart", NULL };
-
 static struct platform_nand_data nand_platdata = {
 	.chip	= {
 		.nr_chips		= 1,
@@ -211,7 +209,6 @@ static struct platform_nand_data nand_platdata = {
 		.nr_partitions		= ARRAY_SIZE(nand_partitions),
 		.partitions		= nand_partitions,
 		.options		= NAND_SAMSUNG_LP_OPTIONS,
-		.part_probe_types	= part_probes,
 	},
 	.ctrl	= {
 		.cmd_ctrl	= nand_cmd_ctl,
diff --git a/arch/arm/mach-omap1/board-perseus2.c b/arch/arm/mach-omap1/board-perseus2.c
index 76d4ee0..eb8b2c7 100644
--- a/arch/arm/mach-omap1/board-perseus2.c
+++ b/arch/arm/mach-omap1/board-perseus2.c
@@ -164,14 +164,11 @@ static int nand_dev_ready(struct mtd_info *mtd)
 	return gpio_get_value(P2_NAND_RB_GPIO_PIN);
 }
 
-static const char *part_probes[] = { "cmdlinepart", NULL };
-
 static struct platform_nand_data nand_data = {
 	.chip	= {
 		.nr_chips		= 1,
 		.chip_offset		= 0,
 		.options		= NAND_SAMSUNG_LP_OPTIONS,
-		.part_probe_types	= part_probes,
 	},
 	.ctrl	= {
 		.cmd_ctrl	= nand_cmd_ctl,
diff --git a/arch/arm/mach-orion5x/ts78xx-setup.c b/arch/arm/mach-orion5x/ts78xx-setup.c
index c96f374..53e595e 100644
--- a/arch/arm/mach-orion5x/ts78xx-setup.c
+++ b/arch/arm/mach-orion5x/ts78xx-setup.c
@@ -245,8 +245,6 @@ static void ts78xx_ts_nand_read_buf(struct mtd_info *mtd,
 		readsb(io_base, buf, len);
 }
 
-const char *ts_nand_part_probes[] = { "cmdlinepart", NULL };
-
 static struct mtd_partition ts78xx_ts_nand_parts[] = {
 	{
 		.name		= "mbr",
@@ -271,7 +269,6 @@ static struct mtd_partition ts78xx_ts_nand_parts[] = {
 static struct platform_nand_data ts78xx_ts_nand_data = {
 	.chip	= {
 		.nr_chips		= 1,
-		.part_probe_types	= ts_nand_part_probes,
 		.partitions		= ts78xx_ts_nand_parts,
 		.nr_partitions		= ARRAY_SIZE(ts78xx_ts_nand_parts),
 		.chip_delay		= 15,
diff --git a/arch/arm/mach-pxa/balloon3.c b/arch/arm/mach-pxa/balloon3.c
index c35456f..7ece2625 100644
--- a/arch/arm/mach-pxa/balloon3.c
+++ b/arch/arm/mach-pxa/balloon3.c
@@ -679,8 +679,6 @@ static struct mtd_partition balloon3_partition_info[] = {
 	},
 };
 
-static const char *balloon3_part_probes[] = { "cmdlinepart", NULL };
-
 struct platform_nand_data balloon3_nand_pdata = {
 	.chip = {
 		.nr_chips	= 4,
@@ -688,7 +686,6 @@ struct platform_nand_data balloon3_nand_pdata = {
 		.nr_partitions	= ARRAY_SIZE(balloon3_partition_info),
 		.partitions	= balloon3_partition_info,
 		.chip_delay	= 50,
-		.part_probe_types = balloon3_part_probes,
 	},
 	.ctrl = {
 		.hwcontrol	= 0,
diff --git a/arch/arm/mach-pxa/em-x270.c b/arch/arm/mach-pxa/em-x270.c
index c1b65da..34b1cd8 100644
--- a/arch/arm/mach-pxa/em-x270.c
+++ b/arch/arm/mach-pxa/em-x270.c
@@ -338,8 +338,6 @@ static struct mtd_partition em_x270_partition_info[] = {
 	},
 };
 
-static const char *em_x270_part_probes[] = { "cmdlinepart", NULL };
-
 struct platform_nand_data em_x270_nand_platdata = {
 	.chip = {
 		.nr_chips = 1,
@@ -347,7 +345,6 @@ struct platform_nand_data em_x270_nand_platdata = {
 		.nr_partitions = ARRAY_SIZE(em_x270_partition_info),
 		.partitions = em_x270_partition_info,
 		.chip_delay = 20,
-		.part_probe_types = em_x270_part_probes,
 	},
 	.ctrl = {
 		.hwcontrol = 0,
diff --git a/arch/arm/mach-pxa/palmtx.c b/arch/arm/mach-pxa/palmtx.c
index 9507605..0da35dc 100644
--- a/arch/arm/mach-pxa/palmtx.c
+++ b/arch/arm/mach-pxa/palmtx.c
@@ -268,8 +268,6 @@ static struct mtd_partition palmtx_partition_info[] = {
 	},
 };
 
-static const char *palmtx_part_probes[] = { "cmdlinepart", NULL };
-
 struct platform_nand_data palmtx_nand_platdata = {
 	.chip	= {
 		.nr_chips		= 1,
@@ -277,7 +275,6 @@ struct platform_nand_data palmtx_nand_platdata = {
 		.nr_partitions		= ARRAY_SIZE(palmtx_partition_info),
 		.partitions		= palmtx_partition_info,
 		.chip_delay		= 20,
-		.part_probe_types 	= palmtx_part_probes,
 	},
 	.ctrl	= {
 		.cmd_ctrl	= palmtx_nand_cmd_ctl,
