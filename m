Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213Ab2AZRNh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 12:13:37 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:42023 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404Ab2AZRNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 12:13:08 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: robherring2@gmail.com, devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, plagnioj@jcrosoft.com,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 6/6] ARM: at91/at91sam9x5: Device tree definition files
Date: Thu, 26 Jan 2012 18:12:37 +0100
Message-Id: <239740116657d3a3fdf89f857b1913708fc7d965.1327596859.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1327597957-32662-1-git-send-email-nicolas.ferre@atmel.com>
References: <1327597957-32662-1-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <15809998b6ca8f1bf69546bfcac18301a70625ef.1327596859.git.nicolas.ferre@atmel.com>
References: <15809998b6ca8f1bf69546bfcac18301a70625ef.1327596859.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Device tree include file for the AT91SAM9x5 SoC family.
An additional .dtsi file is created to describe the generic
SAM9x5 CPU Module (CM).
Device tree source files for each Evaluation Kit that are using
the generic CPU Module and the carrier board. The selection of
available peripherals is done in this .dts file.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/boot/dts/at91sam9g25ek.dts |   37 ++++++++
 arch/arm/boot/dts/at91sam9x5.dtsi   |  172 +++++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/at91sam9x5cm.dtsi |   14 +++
 3 files changed, 223 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/boot/dts/at91sam9g25ek.dts
 create mode 100644 arch/arm/boot/dts/at91sam9x5.dtsi
 create mode 100644 arch/arm/boot/dts/at91sam9x5cm.dtsi

diff --git a/arch/arm/boot/dts/at91sam9g25ek.dts b/arch/arm/boot/dts/at91sam9g25ek.dts
new file mode 100644
index 0000000..e64eb93
--- /dev/null
+++ b/arch/arm/boot/dts/at91sam9g25ek.dts
@@ -0,0 +1,37 @@
+/*
+ * at91sam9g25ek.dts - Device Tree file for AT91SAM9G25-EK board
+ *
+ *  Copyright (C) 2012 Atmel,
+ *                2012 Nicolas Ferre <nicolas.ferre@atmel.com>
+ *
+ * Licensed under GPLv2 or later.
+ */
+/dts-v1/;
+/include/ "at91sam9x5.dtsi"
+/include/ "at91sam9x5cm.dtsi"
+
+/ {
+	model = "Atmel AT91SAM9G25-EK";
+	compatible = "atmel,at91sam9g25ek", "atmel,at91sam9x5ek", "atmel,at91sam9x5", "atmel,at91sam9";
+
+	chosen {
+		bootargs = "128M console=ttyS0,115200 mtdparts=atmel_nand:8M(bootstrap/uboot/kernel)ro,-(rootfs) root=/dev/mtdblock1 rw rootfstype=ubifs ubi.mtd=1 root=ubi0:rootfs";
+	};
+
+	ahb {
+		apb {
+			dbgu: serial@fffff200 {
+				status = "okay";
+			};
+
+			usart0: serial@f801c000 {
+				status = "okay";
+			};
+
+			macb0: ethernet@f802c000 {
+				phy-mode = "rmii";
+				status = "okay";
+			};
+		};
+	};
+};
diff --git a/arch/arm/boot/dts/at91sam9x5.dtsi b/arch/arm/boot/dts/at91sam9x5.dtsi
new file mode 100644
index 0000000..e91391f
--- /dev/null
+++ b/arch/arm/boot/dts/at91sam9x5.dtsi
@@ -0,0 +1,172 @@
+/*
+ * at91sam9x5.dtsi - Device Tree Include file for AT91SAM9x5 family SoC
+ *                   applies to AT91SAM9G15, AT91SAM9G25, AT91SAM9G35,
+ *                   AT91SAM9X25, AT91SAM9X35 SoC
+ *
+ *  Copyright (C) 2012 Atmel,
+ *                2012 Nicolas Ferre <nicolas.ferre@atmel.com>
+ *
+ * Licensed under GPLv2 or later.
+ */
+
+/include/ "skeleton.dtsi"
+
+/ {
+	model = "Atmel AT91SAM9x5 family SoC";
+	compatible = "atmel,at91sam9x5";
+	interrupt-parent = <&aic>;
+
+	aliases {
+		serial0 = &dbgu;
+		serial1 = &usart0;
+		serial2 = &usart1;
+		serial3 = &usart2;
+		gpio0 = &pioA;
+		gpio1 = &pioB;
+		gpio2 = &pioC;
+		gpio3 = &pioD;
+		tcb0 = &tcb0;
+		tcb1 = &tcb1;
+	};
+	cpus {
+		cpu@0 {
+			compatible = "arm,arm926ejs";
+		};
+	};
+
+	memory@20000000 {
+		reg = <0x20000000 0x10000000>;
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
+				#interrupt-cells = <2>;
+				compatible = "atmel,at91rm9200-aic";
+				interrupt-controller;
+				interrupt-parent;
+				reg = <0xfffff000 0x200>;
+			};
+
+			pit: timer@fffffe30 {
+				compatible = "atmel,at91sam9260-pit";
+				reg = <0xfffffe30 0xf>;
+				interrupts = <1 4>;
+			};
+
+			tcb0: timer@f8008000 {
+				compatible = "atmel,at91sam9x5-tcb";
+				reg = <0xf8008000 0x100>;
+				interrupts = <17 4>;
+			};
+
+			tcb1: timer@f800c000 {
+				compatible = "atmel,at91sam9x5-tcb";
+				reg = <0xf800c000 0x100>;
+				interrupts = <17 4>;
+			};
+
+			dma0: dma-controller@ffffec00 {
+				compatible = "atmel,at91sam9g45-dma";
+				reg = <0xffffec00 0x200>;
+				interrupts = <20 4>;
+			};
+
+			dma1: dma-controller@ffffee00 {
+				compatible = "atmel,at91sam9g45-dma";
+				reg = <0xffffee00 0x200>;
+				interrupts = <21 4>;
+			};
+
+			pioA: gpio@fffff400 {
+				compatible = "atmel,at91rm9200-gpio";
+				reg = <0xfffff400 0x100>;
+				interrupts = <2 4>;
+				#gpio-cells = <2>;
+				gpio-controller;
+			};
+
+			pioB: gpio@fffff600 {
+				compatible = "atmel,at91rm9200-gpio";
+				reg = <0xfffff600 0x100>;
+				interrupts = <2 4>;
+				#gpio-cells = <2>;
+				gpio-controller;
+			};
+
+			pioC: gpio@fffff800 {
+				compatible = "atmel,at91rm9200-gpio";
+				reg = <0xfffff800 0x100>;
+				interrupts = <3 4>;
+				#gpio-cells = <2>;
+				gpio-controller;
+			};
+
+			pioD: gpio@fffffa00 {
+				compatible = "atmel,at91rm9200-gpio";
+				reg = <0xfffffa00 0x100>;
+				interrupts = <3 4>;
+				#gpio-cells = <2>;
+				gpio-controller;
+			};
+
+			dbgu: serial@fffff200 {
+				compatible = "atmel,at91sam9260-usart";
+				reg = <0xfffff200 0x200>;
+				interrupts = <1 4>;
+				status = "disabled";
+			};
+
+			usart0: serial@f801c000 {
+				compatible = "atmel,at91sam9260-usart";
+				reg = <0xf801c000 0x200>;
+				interrupts = <5 4>;
+				atmel,use-dma-rx;
+				atmel,use-dma-tx;
+				status = "disabled";
+			};
+
+			usart1: serial@f8020000 {
+				compatible = "atmel,at91sam9260-usart";
+				reg = <0xf8020000 0x200>;
+				interrupts = <6 4>;
+				atmel,use-dma-rx;
+				atmel,use-dma-tx;
+				status = "disabled";
+			};
+
+			usart2: serial@f8024000 {
+				compatible = "atmel,at91sam9260-usart";
+				reg = <0xf8024000 0x200>;
+				interrupts = <7 4>;
+				atmel,use-dma-rx;
+				atmel,use-dma-tx;
+				status = "disabled";
+			};
+
+			macb0: ethernet@f802c000 {
+				compatible = "cdns,at32ap7000-macb", "cdns,macb";
+				reg = <0xf802c000 0x100>;
+				interrupts = <24 4>;
+				status = "disabled";
+			};
+
+			macb1: ethernet@f8030000 {
+				compatible = "cdns,at32ap7000-macb", "cdns,macb";
+				reg = <0xf8030000 0x100>;
+				interrupts = <27 4>;
+				status = "disabled";
+			};
+		};
+	};
+};
diff --git a/arch/arm/boot/dts/at91sam9x5cm.dtsi b/arch/arm/boot/dts/at91sam9x5cm.dtsi
new file mode 100644
index 0000000..4ab5a77
--- /dev/null
+++ b/arch/arm/boot/dts/at91sam9x5cm.dtsi
@@ -0,0 +1,14 @@
+/*
+ * at91sam9x5cm.dtsi - Device Tree Include file for AT91SAM9x5 CPU Module
+ *
+ *  Copyright (C) 2012 Atmel,
+ *                2012 Nicolas Ferre <nicolas.ferre@atmel.com>
+ *
+ * Licensed under GPLv2 or later.
+ */
+
+/ {
+	memory@20000000 {
+		reg = <0x20000000 0x8000000>;
+	};
+};
-- 
1.7.5.4

