Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157Ab2GFMcs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 08:32:48 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:62991 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883Ab2GFMcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 08:32:47 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH] ARM: ux500: Pass PMU platform data due for Perf though AUXDATA
Date: Fri,  6 Jul 2012 13:32:38 +0100
Message-Id: <1341577958-8521-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When booting with Device Tree we need a way to call-back to the
DB8500 PMU IRQ handler. This is necessary because the two CPU
IRQ lines are muxed together on the DB8500 chip. The DB8500
PMU IRQ handler contains logic to pass over to the other core
in the case of IRQ_NONE. This patch allows the DB8500 PMU IRQ
handler to be passed to Perf through platform data.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/board-mop500.c |    2 ++
 arch/arm/mach-ux500/board-mop500.h |    1 +
 2 files changed, 3 insertions(+)

diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index 9c78e40..aa1bdcf 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -727,6 +727,8 @@ MACHINE_END
 #ifdef CONFIG_MACH_UX500_DT
 
 struct of_dev_auxdata u8500_auxdata_lookup[] __initdata = {
+	/* Requires call-back bindings. */
+	OF_DEV_AUXDATA("arm,cortex-a9-pmu", 0, "arm-pmu", &db8500_pmu_platdata),
 	/* Requires DMA and call-back bindings. */
 	OF_DEV_AUXDATA("arm,pl011", 0x80120000, "uart0", &uart0_plat),
 	OF_DEV_AUXDATA("arm,pl011", 0x80121000, "uart1", &uart1_plat),
diff --git a/arch/arm/mach-ux500/board-mop500.h b/arch/arm/mach-ux500/board-mop500.h
index b5bfc1a..d04a8e6 100644
--- a/arch/arm/mach-ux500/board-mop500.h
+++ b/arch/arm/mach-ux500/board-mop500.h
@@ -81,6 +81,7 @@ struct device;
 struct i2c_board_info;
 extern struct mmci_platform_data mop500_sdi0_data;
 extern struct mmci_platform_data mop500_sdi4_data;
+extern struct arm_pmu_platdata db8500_pmu_platdata;
 
 extern void mop500_sdi_init(struct device *parent);
 extern void snowball_sdi_init(struct device *parent);
-- 
1.7.9.5

