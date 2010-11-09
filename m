Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279Ab0KIOcd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 09:32:33 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:41343 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab0KIOc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 09:32:29 -0500
From: srinath@mistralsolutions.com
To: linux-omap@vger.kernel.org
Cc: jdk@ti.com, tony@atomide.com, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        khilman@deeprootsystems.com, nm@ti.com, nagendra@mistralsolutions.com,
        umeshk@mistralsolutions.com, Srinath <srinath@mistralsolutions.com>
Subject: [Patch v5] OMAP: AM3517/05: Add craneboard support
Date: Tue,  9 Nov 2010 19:43:52 +0530
Message-Id: <1289312032-16574-1-git-send-email-srinath@mistralsolutions.com>
X-Mailer: git-send-email 1.7.1.226.g770c5
In-Reply-To: <[PATCH] OMAP: AM3517/05: Add craneboard support>
References: <[PATCH] OMAP: AM3517/05: Add craneboard support>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srinath <srinath@mistralsolutions.com>

Craneboard is a hardware development platform based on the
Sitara AM3517 ARM Cortex - A8 microprocessor device. This is a
low cost reference design.

This patch adds basic board file. Detailed support will follow in
subsequent patches.

  [1] http://www.ti.com/arm
  [2] http://www.mistralsolutions.com/products/craneboard.php

Signed-off-by: Srinath <srinath@mistralsolutions.com>
---
 arch/arm/mach-omap2/Kconfig                  |    5 ++
 arch/arm/mach-omap2/Makefile                 |    2 +
 arch/arm/mach-omap2/board-am3517crane.c      |   69 ++++++++++++++++++++++++++
 arch/arm/plat-omap/include/plat/uncompress.h |    1 +
 4 files changed, 77 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-omap2/board-am3517crane.c

diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
index ab784bf..3688515 100644
--- a/arch/arm/mach-omap2/Kconfig
+++ b/arch/arm/mach-omap2/Kconfig
@@ -174,6 +174,11 @@ config MACH_OMAP3517EVM
 	default y
 	select OMAP_PACKAGE_CBB
 
+config MACH_CRANEBOARD
+	bool "AM3517/05 CRANE board"
+	depends on ARCH_OMAP3
+	select OMAP_PACKAGE_CBB
+
 config MACH_OMAP3_PANDORA
 	bool "OMAP3 Pandora"
 	depends on ARCH_OMAP3
diff --git a/arch/arm/mach-omap2/Makefile b/arch/arm/mach-omap2/Makefile
index b0810b9..d43bd33 100644
--- a/arch/arm/mach-omap2/Makefile
+++ b/arch/arm/mach-omap2/Makefile
@@ -174,6 +174,8 @@ obj-$(CONFIG_MACH_OMAP4_PANDA)		+= board-omap4panda.o \
 
 obj-$(CONFIG_MACH_OMAP3517EVM)		+= board-am3517evm.o
 
+obj-$(CONFIG_MACH_CRANEBOARD)		+= board-am3517crane.o
+
 obj-$(CONFIG_MACH_SBC3530)		+= board-omap3stalker.o \
 					   hsmmc.o
 # Platform specific device init code
diff --git a/arch/arm/mach-omap2/board-am3517crane.c b/arch/arm/mach-omap2/board-am3517crane.c
new file mode 100644
index 0000000..13ead33
--- /dev/null
+++ b/arch/arm/mach-omap2/board-am3517crane.c
@@ -0,0 +1,69 @@
+/*
+ * Support for AM3517/05 Craneboard
+ * http://www.mistralsolutions.com/products/craneboard.php
+ *
+ * Copyright (C) 2010 Mistral Solutions Pvt Ltd. <www.mistralsolutions.com>
+ * Author: R.Srinath <srinath@mistralsolutions.com>
+ *
+ * Based on mach-omap2/board-am3517evm.c
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as  published by the
+ * Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any kind,
+ * whether express or implied; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/gpio.h>
+
+#include <mach/hardware.h>
+#include <asm/mach-types.h>
+#include <asm/mach/arch.h>
+#include <asm/mach/map.h>
+
+#include <plat/board.h>
+#include <plat/common.h>
+
+#include "mux.h"
+
+/* Board initialization */
+static struct omap_board_config_kernel am3517_crane_config[] __initdata = {
+};
+
+#ifdef CONFIG_OMAP_MUX
+static struct omap_board_mux board_mux[] __initdata = {
+	{ .reg_offset = OMAP_MUX_TERMINATOR },
+};
+#else
+#define board_mux	NULL
+#endif
+
+static void __init am3517_crane_init_irq(void)
+{
+	omap_board_config = am3517_crane_config;
+	omap_board_config_size = ARRAY_SIZE(am3517_crane_config);
+
+	omap2_init_common_hw(NULL, NULL);
+	omap_init_irq();
+	omap_gpio_init();
+}
+
+static void __init am3517_crane_init(void)
+{
+	omap3_mux_init(board_mux, OMAP_PACKAGE_CBB);
+	omap_serial_init();
+}
+
+MACHINE_START(CRANEBOARD, "AM3517/05 CRANEBOARD")
+	.boot_params	= 0x80000100,
+	.map_io		= omap3_map_io,
+	.reserve	= omap_reserve,
+	.init_irq	= am3517_crane_init_irq,
+	.init_machine	= am3517_crane_init,
+	.timer		= &omap_timer,
+MACHINE_END
diff --git a/arch/arm/plat-omap/include/plat/uncompress.h b/arch/arm/plat-omap/include/plat/uncompress.h
index 9036e37..229fbf2 100644
--- a/arch/arm/plat-omap/include/plat/uncompress.h
+++ b/arch/arm/plat-omap/include/plat/uncompress.h
@@ -145,6 +145,7 @@ static inline void __arch_decomp_setup(unsigned long arch_id)
 		/* omap3 based boards using UART3 */
 		DEBUG_LL_OMAP3(3, cm_t35);
 		DEBUG_LL_OMAP3(3, cm_t3517);
+		DEBUG_LL_OMAP3(3, craneboard);
 		DEBUG_LL_OMAP3(3, igep0020);
 		DEBUG_LL_OMAP3(3, igep0030);
 		DEBUG_LL_OMAP3(3, nokia_rx51);
-- 
1.7.1.226.g770c5

