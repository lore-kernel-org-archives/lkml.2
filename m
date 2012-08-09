Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031343Ab2HIPuT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 11:50:19 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:51769 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031311Ab2HIPsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 11:48:36 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, broonie@opensource.wolfsonmicro.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 17/22] ARM: ux500: Remove platform registration of MSP devices
Date: Thu,  9 Aug 2012 16:47:43 +0100
Message-Id: <1344527268-5964-18-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1344527268-5964-1-git-send-email-lee.jones@linaro.org>
References: <1344527268-5964-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes platform device registration of all 4 MSP
devices. It also takes care of all redundant infrastructure now
that each of the ux500 audio components have been Device Tree
enabled.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/board-mop500-msp.c |   14 --------------
 arch/arm/mach-ux500/board-mop500.c     |    2 --
 arch/arm/mach-ux500/board-mop500.h     |    2 --
 3 files changed, 18 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500-msp.c b/arch/arm/mach-ux500/board-mop500-msp.c
index 58768c2..326de5a 100644
--- a/arch/arm/mach-ux500/board-mop500-msp.c
+++ b/arch/arm/mach-ux500/board-mop500-msp.c
@@ -172,20 +172,6 @@ struct msp_i2s_platform_data msp3_platform_data = {
 	.msp_i2s_dma_tx	= NULL,
 };
 
-/* Due for removal once the MSP driver has been fully DT:ed. */
-void mop500_of_msp_init(struct device *parent)
-{
-	pr_info("Initialize MSP I2S-devices.\n");
-	db8500_add_msp_i2s(parent, 0, U8500_MSP0_BASE, IRQ_DB8500_MSP0,
-			   &msp0_platform_data);
-	db8500_add_msp_i2s(parent, 1, U8500_MSP1_BASE, IRQ_DB8500_MSP1,
-			   &msp1_platform_data);
-	db8500_add_msp_i2s(parent, 2, U8500_MSP2_BASE, IRQ_DB8500_MSP2,
-			   &msp2_platform_data);
-	db8500_add_msp_i2s(parent, 3, U8500_MSP3_BASE, IRQ_DB8500_MSP1,
-			   &msp3_platform_data);
-}
-
 void mop500_msp_init(struct device *parent)
 {
 	pr_info("%s: Register platform-device 'snd-soc-mop500'.\n", __func__);
diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index 0c141d5..f48d463 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -815,8 +815,6 @@ static void __init u8500_init_machine(void)
 
 		mop500_uib_init();
 
-	} else if (of_machine_is_compatible("calaosystems,snowball-a9500")) {
-		mop500_of_msp_init(parent);
 	} else if (of_machine_is_compatible("st-ericsson,hrefv60+")) {
 		/*
 		 * The HREFv60 board removed a GPIO expander and routed
diff --git a/arch/arm/mach-ux500/board-mop500.h b/arch/arm/mach-ux500/board-mop500.h
index 3fbf48f..e56c983 100644
--- a/arch/arm/mach-ux500/board-mop500.h
+++ b/arch/arm/mach-ux500/board-mop500.h
@@ -98,8 +98,6 @@ void __init mop500_pinmaps_init(void);
 void __init snowball_pinmaps_init(void);
 void __init hrefv60_pinmaps_init(void);
 void mop500_msp_init(struct device *parent);
-/* Due for removal once the MSP driver has been fully DT:ed. */
-void mop500_of_msp_init(struct device *parent);
 
 int __init mop500_uib_init(void);
 void mop500_uib_i2c_add(int busnum, struct i2c_board_info *info,
-- 
1.7.9.5

