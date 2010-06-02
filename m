Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932495Ab0FBLjs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 07:39:48 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:63631 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932448Ab0FBLix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 07:38:53 -0400
From: Thomas Weber <weber@corscience.de>
To: linux-omap@vger.kernel.org
Cc: Thomas Weber <weber@corscience.de>, Tony Lindgren <tony@atomide.com>,
       Russell King <linux@arm.linux.org.uk>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCHv2 06/11] OMAP2: Devkit8000: Remove non existing vsim supply
Date: Wed,  2 Jun 2010 13:37:46 +0200
Message-Id: <1275478671-24563-7-git-send-email-weber@corscience.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1275478671-24563-1-git-send-email-weber@corscience.de>
References: <1275478671-24563-1-git-send-email-weber@corscience.de>
X-Provags-ID: V01U2FsdGVkX1/bu+5X2gi4tzJprZ4mByjOuU3Y3ET24pVbxiB
 N8+lAuDq2bXIxKnYlx7N3J6UmkX7dvnz467kaKPPgHMRds7uAm
 VdjoR9vKKaqfrNbBhAlcg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Devkit8000 uses the cost reduced variant tps65930 of the twl4030.
The TPS65930 only has vdd1, vdd2, vpll1, vio, vmmc1, vdac and vaux2.

vaux2 is not used on Devkit8000.

Signed-off-by: Thomas Weber <weber@corscience.de>
---
 arch/arm/mach-omap2/board-devkit8000.c |   22 ----------------------
 1 files changed, 0 insertions(+), 22 deletions(-)

diff --git a/arch/arm/mach-omap2/board-devkit8000.c b/arch/arm/mach-omap2/board-devkit8000.c
index 8cc8c3b..59877b1 100644
--- a/arch/arm/mach-omap2/board-devkit8000.c
+++ b/arch/arm/mach-omap2/board-devkit8000.c
@@ -168,15 +168,10 @@ static void devkit8000_panel_disable_tv(struct omap_dss_device *dssdev)
 {
 }
 
-
 static struct regulator_consumer_supply devkit8000_vmmc1_supply = {
 	.supply			= "vmmc",
 };
 
-static struct regulator_consumer_supply devkit8000_vsim_supply = {
-	.supply			= "vmmc_aux",
-};
-
 /* ads7846 on SPI */
 static struct regulator_consumer_supply devkit8000_vio_supplies[] = {
 	REGULATOR_SUPPLY("vcc", "spi2.0")
@@ -281,7 +276,6 @@ static int devkit8000_twl_gpio_setup(struct device *dev,
 
 	/* link regulators to MMC adapters */
 	devkit8000_vmmc1_supply.dev = mmc[0].dev;
-	devkit8000_vsim_supply.dev = mmc[0].dev;
 
 	/* TWL4030_GPIO_MAX + 1 == ledB, PMU_STAT (out, active low LED) */
 	gpio_leds[2].gpio = gpio + TWL4030_GPIO_MAX + 1;
@@ -334,21 +328,6 @@ static struct regulator_init_data devkit8000_vmmc1 = {
 	.consumer_supplies	= &devkit8000_vmmc1_supply,
 };
 
-/* VSIM for MMC1 pins DAT4..DAT7 (2 mA, plus card == max 50 mA) */
-static struct regulator_init_data devkit8000_vsim = {
-	.constraints = {
-		.min_uV			= 1800000,
-		.max_uV			= 3000000,
-		.valid_modes_mask	= REGULATOR_MODE_NORMAL
-					| REGULATOR_MODE_STANDBY,
-		.valid_ops_mask		= REGULATOR_CHANGE_VOLTAGE
-					| REGULATOR_CHANGE_MODE
-					| REGULATOR_CHANGE_STATUS,
-	},
-	.num_consumer_supplies	= 1,
-	.consumer_supplies	= &devkit8000_vsim_supply,
-};
-
 /* VDAC for DSS driving S-Video (8 mA unloaded, max 65 mA) */
 static struct regulator_init_data devkit8000_vdac = {
 	.constraints = {
@@ -414,7 +393,6 @@ static struct twl4030_platform_data devkit8000_twldata = {
 	.gpio		= &devkit8000_gpio_data,
 	.codec		= &devkit8000_codec_data,
 	.vmmc1		= &devkit8000_vmmc1,
-	.vsim		= &devkit8000_vsim,
 	.vdac		= &devkit8000_vdac,
 	.vpll1		= &devkit8000_vpll1,
 	.vio		= &devkit8000_vio,
-- 
1.7.1

