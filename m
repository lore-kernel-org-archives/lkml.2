Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932785Ab1JXOFX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 10:05:23 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:63764 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932641Ab1JXOFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 10:05:18 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: robherring2@gmail.com, grant.likely@secretlab.ca
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, plagnioj@jcrosoft.com,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH V3 1/2] ARM: at91: dt: at91sam9g45 family and board device tree files
Date: Mon, 24 Oct 2011 16:05:00 +0200
Message-Id: <15ab652499e7f6f8a26724bfd90643a8f3f96ad9.1319464310.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <4E9F8226.4030503@gmail.com>
References: <4E9F8226.4030503@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create a new device tree source file for Atmel at91sam9g45 SoC family.
The Evaluation Kit at91sam9m10g45ek includes it.
This first basic support will be populated as drivers and boards will be
converted to device tree.
Contains serial, dma and interrupt controllers.

The generic board file still takes advantage of platform data for early serial
init. As we need a storage media and the NAND flash driver is not converted to
DT yet, we keep old initialization for it.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
V3:
- additional clock lookup for device tree handling
- devices disabled in dtsi file so that only useful devices are
  enabled in dts files

V2: foundation for AT91SAM generic support
- device tree focused board file
- inclusion of USART DT support
- early USART and NAND still using platform data

 arch/arm/boot/dts/at91sam9g45.dtsi     |  106 +++++++++++++++++++++++++++
 arch/arm/boot/dts/at91sam9m10g45ek.dts |   35 +++++++++
 arch/arm/mach-at91/Kconfig             |   11 +++
 arch/arm/mach-at91/Makefile            |    3 +
 arch/arm/mach-at91/Makefile.boot       |    2 +
 arch/arm/mach-at91/at91sam9g45.c       |    6 ++
 arch/arm/mach-at91/board-dt.c          |  122 ++++++++++++++++++++++++++++++++
 7 files changed, 285 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/boot/dts/at91sam9g45.dtsi
 create mode 100644 arch/arm/boot/dts/at91sam9m10g45ek.dts
 create mode 100644 arch/arm/mach-at91/board-dt.c

diff --git a/arch/arm/boot/dts/at91sam9g45.dtsi b/arch/arm/boot/dts/at91sam9g45.dtsi
new file mode 100644
index 0000000..db6a452
--- /dev/null
+++ b/arch/arm/boot/dts/at91sam9g45.dtsi
@@ -0,0 +1,106 @@
+/*
+ * at91sam9g45.dtsi - Device Tree Include file for AT91SAM9G45 family SoC
+ *                    applies to AT91SAM9G45, AT91SAM9M10,
+ *                    AT91SAM9G46, AT91SAM9M11 SoC
+ *
+ *  Copyright (C) 2011 Atmel,
+ *                2011 Nicolas Ferre <nicolas.ferre@atmel.com>
+ *
+ * Licensed under GPLv2 or later.
+ */
+
+/include/ "skeleton.dtsi"
+
+/ {
+	model = "Atmel AT91SAM9G45 family SoC";
+	compatible = "atmel,at91sam9g45";
+	interrupt-parent = <&aic>;
+
+	aliases {
+		serial0 = &dbgu;
+		serial1 = &usart0;
+		serial2 = &usart1;
+		serial3 = &usart2;
+		serial4 = &usart3;
+	};
+	cpus {
+		cpu@0 {
+			compatible = "arm,arm926ejs";
+		};
+	};
+
+	memory@70000000 {
+		reg = <0x70000000 0x10000000>;
+	};
+
+	ahb {
+		compatible = "simple-bus";
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+
+		apb {
+			compatible = "simple-bus";
+			#address-cells = <1>;
+			#size-cells = <1>;
+			ranges;
+
+			aic: interrupt-controller@fffff000 {
+				#interrupt-cells = <1>;
+				compatible = "atmel,at91rm9200-aic";
+				interrupt-controller;
+				interrupt-parent;
+				reg = <0xfffff000 0x200>;
+			};
+
+			dma: dma-controller@ffffec00 {
+				compatible = "atmel,at91sam9g45-dma";
+				reg = <0xffffec00 0x200>;
+				interrupts = <21>;
+			};
+
+			dbgu: serial@ffffee00 {
+				compatible = "atmel,at91sam9260-usart";
+				reg = <0xffffee00 0x200>;
+				interrupts = <1>;
+				status = "disabled";
+			};
+
+			usart0: serial@fff8c000 {
+				compatible = "atmel,at91sam9260-usart";
+				reg = <0xfff8c000 0x200>;
+				interrupts = <7>;
+				atmel,use-dma-rx;
+				atmel,use-dma-tx;
+				status = "disabled";
+			};
+
+			usart1: serial@fff90000 {
+				compatible = "atmel,at91sam9260-usart";
+				reg = <0xfff90000 0x200>;
+				interrupts = <8>;
+				atmel,use-dma-rx;
+				atmel,use-dma-tx;
+				status = "disabled";
+			};
+
+			usart2: serial@fff94000 {
+				compatible = "atmel,at91sam9260-usart";
+				reg = <0xfff94000 0x200>;
+				interrupts = <9>;
+				atmel,use-dma-rx;
+				atmel,use-dma-tx;
+				status = "disabled";
+			};
+
+			usart3: serial@fff98000 {
+				compatible = "atmel,at91sam9260-usart";
+				reg = <0xfff98000 0x200>;
+				interrupts = <10>;
+				atmel,use-dma-rx;
+				atmel,use-dma-tx;
+				status = "disabled";
+			};
+		};
+	};
+};
diff --git a/arch/arm/boot/dts/at91sam9m10g45ek.dts b/arch/arm/boot/dts/at91sam9m10g45ek.dts
new file mode 100644
index 0000000..85b34f5
--- /dev/null
+++ b/arch/arm/boot/dts/at91sam9m10g45ek.dts
@@ -0,0 +1,35 @@
+/*
+ * at91sam9m10g45ek.dts - Device Tree file for AT91SAM9M10G45-EK board
+ *
+ *  Copyright (C) 2011 Atmel,
+ *                2011 Nicolas Ferre <nicolas.ferre@atmel.com>
+ *
+ * Licensed under GPLv2 or later.
+ */
+/dts-v1/;
+/include/ "at91sam9g45.dtsi"
+
+/ {
+	model = "Atmel AT91SAM9M10G45-EK";
+	compatible = "atmel,at91sam9m10g45ek", "atmel,at91sam9g45", "atmel,at91sam9";
+
+	chosen {
+		bootargs = "mem=64M console=ttyS0,115200 mtdparts=atmel_nand:4M(bootstrap/uboot/kernel)ro,60M(rootfs),-(data) root=/dev/mtdblock1 rw rootfstype=jffs2";
+	};
+
+	memory@70000000 {
+		reg = <0x70000000 0x4000000>;
+	};
+
+	ahb {
+		apb {
+			dbgu: serial@ffffee00 {
+				status = "okay";
+			};
+
+			usart1: serial@fff90000 {
+				status = "okay";
+			};
+		};
+	};
+};
diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
index 2248467..4b59d96 100644
--- a/arch/arm/mach-at91/Kconfig
+++ b/arch/arm/mach-at91/Kconfig
@@ -442,6 +442,17 @@ endif
 
 # ----------------------------------------------------------
 
+comment "Generic Board Type"
+
+config MACH_AT91SAM_DT
+	bool "Atmel AT91SAM Evaluation Kits with device-tree support"
+	select USE_OF
+	help
+	  Select this if you want to experiment device-tree with
+	  an Atmel Evaluation Kit.
+
+# ----------------------------------------------------------
+
 comment "AT91 Board Options"
 
 config MTD_AT91_DATAFLASH_CARD
diff --git a/arch/arm/mach-at91/Makefile b/arch/arm/mach-at91/Makefile
index bf57e8b..3ff245e 100644
--- a/arch/arm/mach-at91/Makefile
+++ b/arch/arm/mach-at91/Makefile
@@ -74,6 +74,9 @@ obj-$(CONFIG_MACH_SNAPPER_9260)	+= board-snapper9260.o
 # AT91SAM9G45 board-specific support
 obj-$(CONFIG_MACH_AT91SAM9M10G45EK) += board-sam9m10g45ek.o
 
+# AT91SAM board with device-tree
+obj-$(CONFIG_MACH_AT91SAM_DT) += board-dt.o
+
 # AT91CAP9 board-specific support
 obj-$(CONFIG_MACH_AT91CAP9ADK)	+= board-cap9adk.o
 
diff --git a/arch/arm/mach-at91/Makefile.boot b/arch/arm/mach-at91/Makefile.boot
index 3462b81..d278863 100644
--- a/arch/arm/mach-at91/Makefile.boot
+++ b/arch/arm/mach-at91/Makefile.boot
@@ -16,3 +16,5 @@ else
 params_phys-y	:= 0x20000100
 initrd_phys-y	:= 0x20410000
 endif
+
+dtb-$(CONFIG_MACH_AT91SAM_DT) += at91sam9m10g45ek.dtb
diff --git a/arch/arm/mach-at91/at91sam9g45.c b/arch/arm/mach-at91/at91sam9g45.c
index e04c5fb..8baf5a1 100644
--- a/arch/arm/mach-at91/at91sam9g45.c
+++ b/arch/arm/mach-at91/at91sam9g45.c
@@ -215,6 +215,12 @@ static struct clk_lookup periph_clocks_lookups[] = {
 	CLKDEV_CON_DEV_ID("t0_clk", "atmel_tcb.1", &tcb0_clk),
 	CLKDEV_CON_DEV_ID("pclk", "ssc.0", &ssc0_clk),
 	CLKDEV_CON_DEV_ID("pclk", "ssc.1", &ssc1_clk),
+	/* more usart lookup table for DT entries */
+	CLKDEV_CON_DEV_ID("usart", "ffffee00.serial", &mck),
+	CLKDEV_CON_DEV_ID("usart", "fff8c000.serial", &usart0_clk),
+	CLKDEV_CON_DEV_ID("usart", "fff90000.serial", &usart1_clk),
+	CLKDEV_CON_DEV_ID("usart", "fff94000.serial", &usart2_clk),
+	CLKDEV_CON_DEV_ID("usart", "fff98000.serial", &usart3_clk),
 };
 
 static struct clk_lookup usart_clocks_lookups[] = {
diff --git a/arch/arm/mach-at91/board-dt.c b/arch/arm/mach-at91/board-dt.c
new file mode 100644
index 0000000..77fe466
--- /dev/null
+++ b/arch/arm/mach-at91/board-dt.c
@@ -0,0 +1,122 @@
+/*
+ *  Setup code for AT91SAM Evaluation Kits with Device Tree support
+ *
+ *  Covers: * AT91SAM9G45-EKES  board
+ *          * AT91SAM9M10-EKES  board
+ *          * AT91SAM9M10G45-EK board
+ *
+ *  Copyright (C) 2011 Atmel,
+ *                2011 Nicolas Ferre <nicolas.ferre@atmel.com>
+ *
+ * Licensed under GPLv2 or later.
+ */
+
+#include <linux/types.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/gpio.h>
+#include <linux/irqdomain.h>
+#include <linux/of_irq.h>
+#include <linux/of_platform.h>
+
+#include <mach/hardware.h>
+#include <mach/board.h>
+#include <mach/system_rev.h>
+#include <mach/at91sam9_smc.h>
+
+#include <asm/setup.h>
+#include <asm/irq.h>
+#include <asm/mach/arch.h>
+#include <asm/mach/map.h>
+#include <asm/mach/irq.h>
+
+#include "sam9_smc.h"
+#include "generic.h"
+
+
+static void __init ek_init_early(void)
+{
+	/* Initialize processor: 12.000 MHz crystal */
+	at91_initialize(12000000);
+
+	/* DGBU on ttyS0. (Rx & Tx only) */
+	at91_register_uart(0, 0, 0);
+
+	/* set serial console to ttyS0 (ie, DBGU) */
+	at91_set_serial_console(0);
+}
+
+/* det_pin is not connected */
+static struct atmel_nand_data __initdata ek_nand_data = {
+	.ale		= 21,
+	.cle		= 22,
+	.rdy_pin	= AT91_PIN_PC8,
+	.enable_pin	= AT91_PIN_PC14,
+};
+
+static struct sam9_smc_config __initdata ek_nand_smc_config = {
+	.ncs_read_setup		= 0,
+	.nrd_setup		= 2,
+	.ncs_write_setup	= 0,
+	.nwe_setup		= 2,
+
+	.ncs_read_pulse		= 4,
+	.nrd_pulse		= 4,
+	.ncs_write_pulse	= 4,
+	.nwe_pulse		= 4,
+
+	.read_cycle		= 7,
+	.write_cycle		= 7,
+
+	.mode			= AT91_SMC_READMODE | AT91_SMC_WRITEMODE | AT91_SMC_EXNWMODE_DISABLE,
+	.tdf_cycles		= 3,
+};
+
+static void __init ek_add_device_nand(void)
+{
+	ek_nand_data.bus_width_16 = board_have_nand_16bit();
+	/* setup bus-width (8 or 16) */
+	if (ek_nand_data.bus_width_16)
+		ek_nand_smc_config.mode |= AT91_SMC_DBW_16;
+	else
+		ek_nand_smc_config.mode |= AT91_SMC_DBW_8;
+
+	/* configure chip-select 3 (NAND) */
+	sam9_smc_configure(3, &ek_nand_smc_config);
+
+	at91_add_device_nand(&ek_nand_data);
+}
+
+static const struct of_device_id aic_of_match[] __initconst = {
+	{ .compatible = "atmel,at91rm9200-aic", },
+	{},
+};
+
+static void __init at91_dt_init_irq(void)
+{
+	irq_domain_generate_simple(aic_of_match, 0xfffff000, 0);
+	at91_init_irq_default();
+}
+
+static void __init at91_dt_device_init(void)
+{
+	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
+
+	/* NAND */
+	ek_add_device_nand();
+}
+
+static const char *at91_dt_board_compat[] __initdata = {
+	"atmel,at91sam9m10g45ek",
+	NULL
+};
+
+DT_MACHINE_START(at91sam9m10g45ek_dt, "Atmel AT91SAM (Device Tree)")
+	/* Maintainer: Atmel */
+	.timer		= &at91sam926x_timer,
+	.map_io		= at91_map_io,
+	.init_early	= ek_init_early,
+	.init_irq	= at91_dt_init_irq,
+	.init_machine	= at91_dt_device_init,
+	.dt_compat	= at91_dt_board_compat,
+MACHINE_END
-- 
1.7.5.4

