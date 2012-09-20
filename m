Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719Ab2ITMV1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 08:21:27 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:55161 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753801Ab2ITMNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 08:13:07 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, olof.johansson@gmail.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 03/32] ARM: ux500: Pass PMU platform data due for Perf though AUXDATA
Date: Thu, 20 Sep 2012 14:12:21 +0200
Message-Id: <1348143170-2130-4-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1348143170-2130-1-git-send-email-lee.jones@linaro.org>
References: <1348143170-2130-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When booting with Device Tree we need a way to call-back to the
DB8500 PMU IRQ handler. This is necessary because the two CPU
IRQ lines are muxed together on the DB8500 chip. The DB8500
PMU IRQ handler contains logic to pass over to the other core
in the case of IRQ_NONE. This patch allows the DB8500 PMU IRQ
handler to be passed to Perf through platform data.

Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/board-mop500.c |    2 ++
 arch/arm/mach-ux500/board-mop500.h |    1 +
 2 files changed, 3 insertions(+)

diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index a534d88..5d9600b 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -732,6 +732,8 @@ static struct platform_device *snowball_of_platform_devs[] __initdata = {
 };
 
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

