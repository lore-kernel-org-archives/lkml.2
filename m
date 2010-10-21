Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758119Ab0JUVCF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 17:02:05 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:35297 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750942Ab0JUVB5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 17:01:57 -0400
From: Cyril Chemparathy <cyril@ti.com>
To: davinci-linux-open-source@linux.davincidsp.com,
        spi-devel-general@lists.sourceforge.net,
        broonie@opensource.wolfsonmicro.com, lrg@slimlogic.co.uk,
        dbrownell@users.sourceforge.net, grant.likely@secretlab.ca,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        rpurdie@rpsys.net
Cc: Cyril Chemparathy <cyril@ti.com>
Subject: [PATCH v3 03/12] davinci: add ssp config for tnetv107x evm board
Date: Thu, 21 Oct 2010 17:01:04 -0400
Message-Id: <1287694873-12904-4-git-send-email-cyril@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1287694873-12904-1-git-send-email-cyril@ti.com>
References: <1287694873-12904-1-git-send-email-cyril@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds SSP configuration and pin muxing info for tnetv107x
evm boards.

Signed-off-by: Cyril Chemparathy <cyril@ti.com>
---
 arch/arm/mach-davinci/board-tnetv107x-evm.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-davinci/board-tnetv107x-evm.c b/arch/arm/mach-davinci/board-tnetv107x-evm.c
index 5afa8fc..401ad26 100644
--- a/arch/arm/mach-davinci/board-tnetv107x-evm.c
+++ b/arch/arm/mach-davinci/board-tnetv107x-evm.c
@@ -33,6 +33,7 @@
 #include <mach/edma.h>
 #include <mach/mux.h>
 #include <mach/cp_intc.h>
+#include <mach/ti_ssp.h>
 #include <mach/tnetv107x.h>
 
 #define EVM_MMC_WP_GPIO		21
@@ -99,6 +100,12 @@ static const short uart1_pins[] __initdata = {
 	-1
 };
 
+static const short ssp_pins[] __initdata = {
+	TNETV107X_SSP0_0, TNETV107X_SSP0_1, TNETV107X_SSP0_2,
+	TNETV107X_SSP1_0, TNETV107X_SSP1_1, TNETV107X_SSP1_2,
+	TNETV107X_SSP1_3, -1
+};
+
 static struct mtd_partition nand_partitions[] = {
 	/* bootloader (U-Boot, etc) in first 12 sectors */
 	{
@@ -196,17 +203,25 @@ static struct matrix_keypad_platform_data keypad_config = {
 	.no_autorepeat	= 0,
 };
 
+static struct ti_ssp_data ssp_config = {
+	.out_clock	= 250 * 1000,
+	.dev_data	= {
+	},
+};
+
 static struct tnetv107x_device_info evm_device_info __initconst = {
 	.serial_config		= &serial_config,
 	.mmc_config[1]		= &mmc_config,	/* controller 1 */
 	.nand_config[0]		= &nand_config,	/* chip select 0 */
 	.keypad_config		= &keypad_config,
+	.ssp_config		= &ssp_config,
 };
 
 static __init void tnetv107x_evm_board_init(void)
 {
 	davinci_cfg_reg_list(sdio1_pins);
 	davinci_cfg_reg_list(uart1_pins);
+	davinci_cfg_reg_list(ssp_pins);
 
 	tnetv107x_devices_init(&evm_device_info);
 }
-- 
1.7.0.4

