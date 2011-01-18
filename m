Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339Ab1ARTX3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 14:23:29 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:53072 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753102Ab1ARTW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 14:22:26 -0500
From: Cyril Chemparathy <cyril@ti.com>
To: davinci-linux-open-source@linux.davincidsp.com,
        spi-devel-general@lists.sourceforge.net, sameo@linux.intel.com,
        rpurdie@rpsys.net, dbrownell@users.sourceforge.net
Cc: c-park@ti.com, linux-arm-kernel@lists.arm.linux.org.uk,
        linux-kernel@vger.kernel.org, Cyril Chemparathy <cyril@ti.com>
Subject: [PATCH v8 06/11] davinci: add ssp config for tnetv107x evm board
Date: Tue, 18 Jan 2011 14:21:40 -0500
Message-Id: <1295378505-15221-7-git-send-email-cyril@ti.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1295378505-15221-1-git-send-email-cyril@ti.com>
References: <1295378505-15221-1-git-send-email-cyril@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds SSP configuration and pin muxing info for tnetv107x
evm boards.

Signed-off-by: Cyril Chemparathy <cyril@ti.com>
---
 arch/arm/mach-davinci/board-tnetv107x-evm.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-davinci/board-tnetv107x-evm.c b/arch/arm/mach-davinci/board-tnetv107x-evm.c
index a6db854..ef526b1 100644
--- a/arch/arm/mach-davinci/board-tnetv107x-evm.c
+++ b/arch/arm/mach-davinci/board-tnetv107x-evm.c
@@ -99,6 +99,12 @@ static const short uart1_pins[] __initdata = {
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
@@ -196,17 +202,25 @@ static struct matrix_keypad_platform_data keypad_config = {
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
1.7.1

