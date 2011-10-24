Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932774Ab1JXOFW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 10:05:22 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:57371 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932761Ab1JXOFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 10:05:18 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: robherring2@gmail.com, grant.likely@secretlab.ca
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, plagnioj@jcrosoft.com,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH V3 2/2] ARM: at91: add at91sam9g20 and Calao USB A9G20 DT support
Date: Mon, 24 Oct 2011 16:05:01 +0200
Message-Id: <d139db89b4e9830e813abf1329ce1ac499653f2c.1319464310.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <15ab652499e7f6f8a26724bfd90643a8f3f96ad9.1319464310.git.nicolas.ferre@atmel.com>
References: <4E9F8226.4030503@gmail.com>
 <15ab652499e7f6f8a26724bfd90643a8f3f96ad9.1319464310.git.nicolas.ferre@atmel.com>
In-Reply-To: <15ab652499e7f6f8a26724bfd90643a8f3f96ad9.1319464310.git.nicolas.ferre@atmel.com>
References: <15ab652499e7f6f8a26724bfd90643a8f3f96ad9.1319464310.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>

Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/boot/dts/at91sam9g20.dtsi |  119 ++++++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/usb_a9g20.dts    |   30 +++++++++
 arch/arm/mach-at91/Makefile.boot   |    2 +-
 arch/arm/mach-at91/at91sam9260.c   |    8 +++
 arch/arm/mach-at91/board-dt.c      |    1 +
 5 files changed, 159 insertions(+), 1 deletions(-)
 create mode 100644 arch/arm/boot/dts/at91sam9g20.dtsi
 create mode 100644 arch/arm/boot/dts/usb_a9g20.dts

diff --git a/arch/arm/boot/dts/at91sam9g20.dtsi b/arch/arm/boot/dts/at91sam9g20.dtsi
new file mode 100644
index 0000000..aeef042
--- /dev/null
+++ b/arch/arm/boot/dts/at91sam9g20.dtsi
@@ -0,0 +1,119 @@
+/*
+ * at91sam9g20.dtsi - Device Tree Include file for AT91SAM9G20 family SoC
+ *
+ *  Copyright (C) 2011 Atmel,
+ *                2011 Nicolas Ferre <nicolas.ferre@atmel.com>,
+ *                2011 Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
+ *
+ * Licensed under GPLv2 or later.
+ */
+
+/include/ "skeleton.dtsi"
+
+/ {
+	model = "Atmel AT91SAM9G20 family SoC";
+	compatible = "atmel,at91sam9g20";
+	interrupt-parent = <&aic>;
+
+	aliases {
+		serial0 = &dbgu;
+		serial1 = &usart0;
+		serial2 = &usart1;
+		serial3 = &usart2;
+		serial4 = &usart3;
+		serial5 = &usart4;
+		serial6 = &usart5;
+	};
+	cpus {
+		cpu@0 {
+			compatible = "arm,arm926ejs";
+		};
+	};
+
+	memory@20000000 {
+		reg = <0x20000000 0x08000000>;
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
+			dbgu: serial@fffff200 {
+				compatible = "atmel,at91sam9260-usart";
+				reg = <0xfffff200 0x200>;
+				interrupts = <1>;
+				status = "disabled";
+			};
+
+			usart0: serial@fffb0000 {
+				compatible = "atmel,at91sam9260-usart";
+				reg = <0xfffb0000 0x200>;
+				interrupts = <6>;
+				atmel,use-dma-rx;
+				atmel,use-dma-tx;
+				status = "disabled";
+			};
+
+			usart1: serial@fffb4000 {
+				compatible = "atmel,at91sam9260-usart";
+				reg = <0xfffb4000 0x200>;
+				interrupts = <7>;
+				atmel,use-dma-rx;
+				atmel,use-dma-tx;
+				status = "disabled";
+			};
+
+			usart2: serial@fffb8000 {
+				compatible = "atmel,at91sam9260-usart";
+				reg = <0xfffb8000 0x200>;
+				interrupts = <8>;
+				atmel,use-dma-rx;
+				atmel,use-dma-tx;
+				status = "disabled";
+			};
+
+			usart3: serial@fffd0000 {
+				compatible = "atmel,at91sam9260-usart";
+				reg = <0xfffd0000 0x200>;
+				interrupts = <23>;
+				atmel,use-dma-rx;
+				atmel,use-dma-tx;
+				status = "disabled";
+			};
+
+			usart4: serial@fffd4000 {
+				compatible = "atmel,at91sam9260-usart";
+				reg = <0xfffd4000 0x200>;
+				interrupts = <24>;
+				atmel,use-dma-rx;
+				atmel,use-dma-tx;
+				status = "disabled";
+			};
+
+			usart5: serial@fffd8000 {
+				compatible = "atmel,at91sam9260-usart";
+				reg = <0xfffd8000 0x200>;
+				interrupts = <25>;
+				atmel,use-dma-rx;
+				atmel,use-dma-tx;
+				status = "disabled";
+			};
+		};
+	};
+};
diff --git a/arch/arm/boot/dts/usb_a9g20.dts b/arch/arm/boot/dts/usb_a9g20.dts
new file mode 100644
index 0000000..a060f6c
--- /dev/null
+++ b/arch/arm/boot/dts/usb_a9g20.dts
@@ -0,0 +1,30 @@
+/*
+ * usb_a9g20.dts - Device Tree file for Caloa USB A9G20 board
+ *
+ *  Copyright (C) 2011 Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
+ *
+ * Licensed under GPLv2 or later.
+ */
+/dts-v1/;
+/include/ "at91sam9g20.dtsi"
+
+/ {
+	model = "Calao USB A9G20";
+	compatible = "calao,usb-a9g20", "atmel,at91sam9g20", "atmel,at91sam9";
+
+	chosen {
+		bootargs = "mem=64M console=ttyS0,115200 mtdparts=atmel_nand:128k(at91bootstrap),256k(barebox)ro,128k(bareboxenv),128k(bareboxenv2),4M(kernel),120M(rootfs),-(data) root=/dev/mtdblock5 rw rootfstype=ubifs";
+	};
+
+	memory@70000000 {
+		reg = <0x20000000 0x4000000>;
+	};
+
+	ahb {
+		apb {
+			dbgu: serial@fffff200 {
+				status = "okay";
+			};
+		};
+	};
+};
diff --git a/arch/arm/mach-at91/Makefile.boot b/arch/arm/mach-at91/Makefile.boot
index d278863..08c665a 100644
--- a/arch/arm/mach-at91/Makefile.boot
+++ b/arch/arm/mach-at91/Makefile.boot
@@ -17,4 +17,4 @@ params_phys-y	:= 0x20000100
 initrd_phys-y	:= 0x20410000
 endif
 
-dtb-$(CONFIG_MACH_AT91SAM_DT) += at91sam9m10g45ek.dtb
+dtb-$(CONFIG_MACH_AT91SAM_DT) += at91sam9m10g45ek.dtb usb_a9g20.dtb
diff --git a/arch/arm/mach-at91/at91sam9260.c b/arch/arm/mach-at91/at91sam9260.c
index cb397be..f4518b4 100644
--- a/arch/arm/mach-at91/at91sam9260.c
+++ b/arch/arm/mach-at91/at91sam9260.c
@@ -199,6 +199,14 @@ static struct clk_lookup periph_clocks_lookups[] = {
 	CLKDEV_CON_DEV_ID("t4_clk", "atmel_tcb.1", &tc4_clk),
 	CLKDEV_CON_DEV_ID("t5_clk", "atmel_tcb.1", &tc5_clk),
 	CLKDEV_CON_DEV_ID("pclk", "ssc.0", &ssc_clk),
+	/* more usart lookup table for DT entries */
+	CLKDEV_CON_DEV_ID("usart", "fffff200.serial", &mck),
+	CLKDEV_CON_DEV_ID("usart", "fffb0000.serial", &usart0_clk),
+	CLKDEV_CON_DEV_ID("usart", "fffb4000.serial", &usart1_clk),
+	CLKDEV_CON_DEV_ID("usart", "fffb8000.serial", &usart2_clk),
+	CLKDEV_CON_DEV_ID("usart", "fffd0000.serial", &usart3_clk),
+	CLKDEV_CON_DEV_ID("usart", "fffd4000.serial", &usart4_clk),
+	CLKDEV_CON_DEV_ID("usart", "fffd8000.serial", &usart5_clk),
 };
 
 static struct clk_lookup usart_clocks_lookups[] = {
diff --git a/arch/arm/mach-at91/board-dt.c b/arch/arm/mach-at91/board-dt.c
index 77fe466..a3d22f8 100644
--- a/arch/arm/mach-at91/board-dt.c
+++ b/arch/arm/mach-at91/board-dt.c
@@ -108,6 +108,7 @@ static void __init at91_dt_device_init(void)
 
 static const char *at91_dt_board_compat[] __initdata = {
 	"atmel,at91sam9m10g45ek",
+	"calao,usb-a9g20",
 	NULL
 };
 
-- 
1.7.5.4

