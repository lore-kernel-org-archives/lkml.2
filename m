Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757324Ab1LNPHX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 10:07:23 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:4937 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757270Ab1LNPHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 10:07:19 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 14 Dec 2011 07:06:59 -0800
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Russell King <linux@arm.linux.org.uk>,
        Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@nvidia.com>, Gary King <gking@nvidia.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>
Subject: [PATCH v7 06/14] arm/tegra: rename board-dt.c to board-dt-tegra20.c
Date: Wed, 14 Dec 2011 17:03:18 +0200
Message-ID: <1323875032-18221-7-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1323875032-18221-1-git-send-email-pdeschrijver@nvidia.com>
References: <1323875032-18221-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tegra20 based boards will be handled by the current board-dt.c file. Tegra30
based boards will be handled by a new board-dt-tegra30.c file. Hence rename
the existing board-dt.c to board-dt-tegra20.c to reflect its use.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 arch/arm/mach-tegra/Kconfig            |    4 +-
 arch/arm/mach-tegra/Makefile           |    2 +-
 arch/arm/mach-tegra/board-dt-tegra20.c |  143 ++++++++++++++++++++++++++++++++
 arch/arm/mach-tegra/board-dt.c         |  143 --------------------------------
 4 files changed, 146 insertions(+), 146 deletions(-)
 create mode 100644 arch/arm/mach-tegra/board-dt-tegra20.c
 delete mode 100644 arch/arm/mach-tegra/board-dt.c

diff --git a/arch/arm/mach-tegra/Kconfig b/arch/arm/mach-tegra/Kconfig
index 2b1d49b..996828d 100644
--- a/arch/arm/mach-tegra/Kconfig
+++ b/arch/arm/mach-tegra/Kconfig
@@ -57,10 +57,10 @@ config MACH_SEABOARD
 	 have large similarities with the seaboard design.
 
 config MACH_TEGRA_DT
-	bool "Generic Tegra board (FDT support)"
+	bool "Generic Tegra20 board (FDT support)"
 	select USE_OF
 	help
-	  Support for generic nVidia Tegra boards using Flattened Device Tree
+	  Support for generic NVIDIA Tegra20 boards using Flattened Device Tree
 
 config MACH_TRIMSLICE
        bool "TrimSlice board"
diff --git a/arch/arm/mach-tegra/Makefile b/arch/arm/mach-tegra/Makefile
index 26ff456..813af0d 100644
--- a/arch/arm/mach-tegra/Makefile
+++ b/arch/arm/mach-tegra/Makefile
@@ -28,7 +28,7 @@ obj-$(CONFIG_MACH_PAZ00)		+= board-paz00-pinmux.o
 obj-$(CONFIG_MACH_SEABOARD)             += board-seaboard.o
 obj-$(CONFIG_MACH_SEABOARD)             += board-seaboard-pinmux.o
 
-obj-$(CONFIG_MACH_TEGRA_DT)             += board-dt.o
+obj-$(CONFIG_MACH_TEGRA_DT)             += board-dt-tegra20.o
 obj-$(CONFIG_MACH_TEGRA_DT)             += board-harmony-pinmux.o
 obj-$(CONFIG_MACH_TEGRA_DT)             += board-seaboard-pinmux.o
 obj-$(CONFIG_MACH_TEGRA_DT)             += board-paz00-pinmux.o
diff --git a/arch/arm/mach-tegra/board-dt-tegra20.c b/arch/arm/mach-tegra/board-dt-tegra20.c
new file mode 100644
index 0000000..2bfefac
--- /dev/null
+++ b/arch/arm/mach-tegra/board-dt-tegra20.c
@@ -0,0 +1,143 @@
+/*
+ * nVidia Tegra device tree board support
+ *
+ * Copyright (C) 2010 Secret Lab Technologies, Ltd.
+ * Copyright (C) 2010 Google, Inc.
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/serial_8250.h>
+#include <linux/clk.h>
+#include <linux/dma-mapping.h>
+#include <linux/irqdomain.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_fdt.h>
+#include <linux/of_irq.h>
+#include <linux/of_platform.h>
+#include <linux/pda_power.h>
+#include <linux/io.h>
+#include <linux/i2c.h>
+#include <linux/i2c-tegra.h>
+
+#include <asm/hardware/gic.h>
+#include <asm/mach-types.h>
+#include <asm/mach/arch.h>
+#include <asm/mach/time.h>
+#include <asm/setup.h>
+
+#include <mach/iomap.h>
+#include <mach/irqs.h>
+
+#include "board.h"
+#include "board-harmony.h"
+#include "clock.h"
+#include "devices.h"
+
+void harmony_pinmux_init(void);
+void paz00_pinmux_init(void);
+void seaboard_pinmux_init(void);
+void trimslice_pinmux_init(void);
+void ventana_pinmux_init(void);
+
+struct of_dev_auxdata tegra20_auxdata_lookup[] __initdata = {
+	OF_DEV_AUXDATA("nvidia,tegra20-sdhci", TEGRA_SDMMC1_BASE, "sdhci-tegra.0", NULL),
+	OF_DEV_AUXDATA("nvidia,tegra20-sdhci", TEGRA_SDMMC2_BASE, "sdhci-tegra.1", NULL),
+	OF_DEV_AUXDATA("nvidia,tegra20-sdhci", TEGRA_SDMMC3_BASE, "sdhci-tegra.2", NULL),
+	OF_DEV_AUXDATA("nvidia,tegra20-sdhci", TEGRA_SDMMC4_BASE, "sdhci-tegra.3", NULL),
+	OF_DEV_AUXDATA("nvidia,tegra20-i2c", TEGRA_I2C_BASE, "tegra-i2c.0", NULL),
+	OF_DEV_AUXDATA("nvidia,tegra20-i2c", TEGRA_I2C2_BASE, "tegra-i2c.1", NULL),
+	OF_DEV_AUXDATA("nvidia,tegra20-i2c", TEGRA_I2C3_BASE, "tegra-i2c.2", NULL),
+	OF_DEV_AUXDATA("nvidia,tegra20-i2c", TEGRA_DVC_BASE, "tegra-i2c.3", NULL),
+	OF_DEV_AUXDATA("nvidia,tegra20-i2s", TEGRA_I2S1_BASE, "tegra-i2s.0", NULL),
+	OF_DEV_AUXDATA("nvidia,tegra20-i2s", TEGRA_I2S1_BASE, "tegra-i2s.1", NULL),
+	OF_DEV_AUXDATA("nvidia,tegra20-das", TEGRA_APB_MISC_DAS_BASE, "tegra-das", NULL),
+	OF_DEV_AUXDATA("nvidia,tegra20-ehci", TEGRA_USB_BASE, "tegra-ehci.0",
+		       &tegra_ehci1_device.dev.platform_data),
+	OF_DEV_AUXDATA("nvidia,tegra20-ehci", TEGRA_USB2_BASE, "tegra-ehci.1",
+		       &tegra_ehci2_device.dev.platform_data),
+	OF_DEV_AUXDATA("nvidia,tegra20-ehci", TEGRA_USB3_BASE, "tegra-ehci.2",
+		       &tegra_ehci3_device.dev.platform_data),
+	{}
+};
+
+static __initdata struct tegra_clk_init_table tegra_dt_clk_init_table[] = {
+	/* name		parent		rate		enabled */
+	{ "uartd",	"pll_p",	216000000,	true },
+	{ "usbd",	"clk_m",	12000000,	false },
+	{ "usb2",	"clk_m",	12000000,	false },
+	{ "usb3",	"clk_m",	12000000,	false },
+	{ NULL,		NULL,		0,		0},
+};
+
+static struct of_device_id tegra_dt_match_table[] __initdata = {
+	{ .compatible = "simple-bus", },
+	{}
+};
+
+static struct {
+	char *machine;
+	void (*init)(void);
+} pinmux_configs[] = {
+	{ "compulab,trimslice", trimslice_pinmux_init },
+	{ "nvidia,harmony", harmony_pinmux_init },
+	{ "compal,paz00", paz00_pinmux_init },
+	{ "nvidia,seaboard", seaboard_pinmux_init },
+	{ "nvidia,ventana", ventana_pinmux_init },
+};
+
+static void __init tegra_dt_init(void)
+{
+	int i;
+
+	tegra_clk_init_from_table(tegra_dt_clk_init_table);
+
+	/*
+	 * Finished with the static registrations now; fill in the missing
+	 * devices
+	 */
+	of_platform_populate(NULL, tegra_dt_match_table,
+				tegra20_auxdata_lookup, NULL);
+
+	for (i = 0; i < ARRAY_SIZE(pinmux_configs); i++) {
+		if (of_machine_is_compatible(pinmux_configs[i].machine)) {
+			pinmux_configs[i].init();
+			break;
+		}
+	}
+
+	WARN(i == ARRAY_SIZE(pinmux_configs),
+		"Unknown platform! Pinmuxing not initialized\n");
+}
+
+static const char *tegra20_dt_board_compat[] = {
+	"compulab,trimslice",
+	"nvidia,harmony",
+	"compal,paz00",
+	"nvidia,seaboard",
+	"nvidia,ventana",
+	NULL
+};
+
+DT_MACHINE_START(TEGRA_DT, "nVidia Tegra20 (Flattened Device Tree)")
+	.map_io		= tegra_map_common_io,
+	.init_early	= tegra20_init_early,
+	.init_irq	= tegra_dt_init_irq,
+	.handle_irq	= gic_handle_irq,
+	.timer		= &tegra_timer,
+	.init_machine	= tegra_dt_init,
+	.restart	= tegra_assert_system_reset,
+	.dt_compat	= tegra20_dt_board_compat,
+MACHINE_END
diff --git a/arch/arm/mach-tegra/board-dt.c b/arch/arm/mach-tegra/board-dt.c
deleted file mode 100644
index 2bfefac..0000000
--- a/arch/arm/mach-tegra/board-dt.c
+++ /dev/null
@@ -1,143 +0,0 @@
-/*
- * nVidia Tegra device tree board support
- *
- * Copyright (C) 2010 Secret Lab Technologies, Ltd.
- * Copyright (C) 2010 Google, Inc.
- *
- * This software is licensed under the terms of the GNU General Public
- * License version 2, as published by the Free Software Foundation, and
- * may be copied, distributed, and modified under those terms.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- */
-
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/platform_device.h>
-#include <linux/serial_8250.h>
-#include <linux/clk.h>
-#include <linux/dma-mapping.h>
-#include <linux/irqdomain.h>
-#include <linux/of.h>
-#include <linux/of_address.h>
-#include <linux/of_fdt.h>
-#include <linux/of_irq.h>
-#include <linux/of_platform.h>
-#include <linux/pda_power.h>
-#include <linux/io.h>
-#include <linux/i2c.h>
-#include <linux/i2c-tegra.h>
-
-#include <asm/hardware/gic.h>
-#include <asm/mach-types.h>
-#include <asm/mach/arch.h>
-#include <asm/mach/time.h>
-#include <asm/setup.h>
-
-#include <mach/iomap.h>
-#include <mach/irqs.h>
-
-#include "board.h"
-#include "board-harmony.h"
-#include "clock.h"
-#include "devices.h"
-
-void harmony_pinmux_init(void);
-void paz00_pinmux_init(void);
-void seaboard_pinmux_init(void);
-void trimslice_pinmux_init(void);
-void ventana_pinmux_init(void);
-
-struct of_dev_auxdata tegra20_auxdata_lookup[] __initdata = {
-	OF_DEV_AUXDATA("nvidia,tegra20-sdhci", TEGRA_SDMMC1_BASE, "sdhci-tegra.0", NULL),
-	OF_DEV_AUXDATA("nvidia,tegra20-sdhci", TEGRA_SDMMC2_BASE, "sdhci-tegra.1", NULL),
-	OF_DEV_AUXDATA("nvidia,tegra20-sdhci", TEGRA_SDMMC3_BASE, "sdhci-tegra.2", NULL),
-	OF_DEV_AUXDATA("nvidia,tegra20-sdhci", TEGRA_SDMMC4_BASE, "sdhci-tegra.3", NULL),
-	OF_DEV_AUXDATA("nvidia,tegra20-i2c", TEGRA_I2C_BASE, "tegra-i2c.0", NULL),
-	OF_DEV_AUXDATA("nvidia,tegra20-i2c", TEGRA_I2C2_BASE, "tegra-i2c.1", NULL),
-	OF_DEV_AUXDATA("nvidia,tegra20-i2c", TEGRA_I2C3_BASE, "tegra-i2c.2", NULL),
-	OF_DEV_AUXDATA("nvidia,tegra20-i2c", TEGRA_DVC_BASE, "tegra-i2c.3", NULL),
-	OF_DEV_AUXDATA("nvidia,tegra20-i2s", TEGRA_I2S1_BASE, "tegra-i2s.0", NULL),
-	OF_DEV_AUXDATA("nvidia,tegra20-i2s", TEGRA_I2S1_BASE, "tegra-i2s.1", NULL),
-	OF_DEV_AUXDATA("nvidia,tegra20-das", TEGRA_APB_MISC_DAS_BASE, "tegra-das", NULL),
-	OF_DEV_AUXDATA("nvidia,tegra20-ehci", TEGRA_USB_BASE, "tegra-ehci.0",
-		       &tegra_ehci1_device.dev.platform_data),
-	OF_DEV_AUXDATA("nvidia,tegra20-ehci", TEGRA_USB2_BASE, "tegra-ehci.1",
-		       &tegra_ehci2_device.dev.platform_data),
-	OF_DEV_AUXDATA("nvidia,tegra20-ehci", TEGRA_USB3_BASE, "tegra-ehci.2",
-		       &tegra_ehci3_device.dev.platform_data),
-	{}
-};
-
-static __initdata struct tegra_clk_init_table tegra_dt_clk_init_table[] = {
-	/* name		parent		rate		enabled */
-	{ "uartd",	"pll_p",	216000000,	true },
-	{ "usbd",	"clk_m",	12000000,	false },
-	{ "usb2",	"clk_m",	12000000,	false },
-	{ "usb3",	"clk_m",	12000000,	false },
-	{ NULL,		NULL,		0,		0},
-};
-
-static struct of_device_id tegra_dt_match_table[] __initdata = {
-	{ .compatible = "simple-bus", },
-	{}
-};
-
-static struct {
-	char *machine;
-	void (*init)(void);
-} pinmux_configs[] = {
-	{ "compulab,trimslice", trimslice_pinmux_init },
-	{ "nvidia,harmony", harmony_pinmux_init },
-	{ "compal,paz00", paz00_pinmux_init },
-	{ "nvidia,seaboard", seaboard_pinmux_init },
-	{ "nvidia,ventana", ventana_pinmux_init },
-};
-
-static void __init tegra_dt_init(void)
-{
-	int i;
-
-	tegra_clk_init_from_table(tegra_dt_clk_init_table);
-
-	/*
-	 * Finished with the static registrations now; fill in the missing
-	 * devices
-	 */
-	of_platform_populate(NULL, tegra_dt_match_table,
-				tegra20_auxdata_lookup, NULL);
-
-	for (i = 0; i < ARRAY_SIZE(pinmux_configs); i++) {
-		if (of_machine_is_compatible(pinmux_configs[i].machine)) {
-			pinmux_configs[i].init();
-			break;
-		}
-	}
-
-	WARN(i == ARRAY_SIZE(pinmux_configs),
-		"Unknown platform! Pinmuxing not initialized\n");
-}
-
-static const char *tegra20_dt_board_compat[] = {
-	"compulab,trimslice",
-	"nvidia,harmony",
-	"compal,paz00",
-	"nvidia,seaboard",
-	"nvidia,ventana",
-	NULL
-};
-
-DT_MACHINE_START(TEGRA_DT, "nVidia Tegra20 (Flattened Device Tree)")
-	.map_io		= tegra_map_common_io,
-	.init_early	= tegra20_init_early,
-	.init_irq	= tegra_dt_init_irq,
-	.handle_irq	= gic_handle_irq,
-	.timer		= &tegra_timer,
-	.init_machine	= tegra_dt_init,
-	.restart	= tegra_assert_system_reset,
-	.dt_compat	= tegra20_dt_board_compat,
-MACHINE_END
-- 
1.7.7.rc0.72.g4b5ea.dirty

