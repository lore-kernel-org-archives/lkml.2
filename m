Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756189Ab2HFMYP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 08:24:15 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:40028 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756055Ab2HFMYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 08:24:12 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Rabeeh Khoury <rabeeh@solid-run.com>,
        Ian Molton <ian.molton@codethink.co.uk>, Arnd Bergmann <arnd@arndb.de>,
        Maen Suleiman <maen@marvell.com>, Olof Johansson <olof@lixom.net>
Subject: [PATCH 5/6] ARM: dove: add device tree descriptors
Date: Mon,  6 Aug 2012 14:23:33 +0200
Message-Id: <1344255815-4457-6-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1344255815-4457-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1344255815-4457-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds device tree decriptors for dove SoC and currently
supported boards.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Cc: Rabeeh Khoury <rabeeh@solid-run.com>
Cc: Ian Molton <ian.molton@codethink.co.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Maen Suleiman <maen@marvell.com>
Cc: Olof Johansson <olof@lixom.net>
---
 arch/arm/boot/dts/dove-cm-a510.dts |   38 ++++++++++
 arch/arm/boot/dts/dove-dove-db.dts |   38 ++++++++++
 arch/arm/boot/dts/dove.dtsi        |  143 ++++++++++++++++++++++++++++++++++++
 arch/arm/mach-dove/Makefile.boot   |    3 +
 4 files changed, 222 insertions(+)
 create mode 100644 arch/arm/boot/dts/dove-cm-a510.dts
 create mode 100644 arch/arm/boot/dts/dove-dove-db.dts
 create mode 100644 arch/arm/boot/dts/dove.dtsi

diff --git a/arch/arm/boot/dts/dove-cm-a510.dts b/arch/arm/boot/dts/dove-cm-a510.dts
new file mode 100644
index 0000000..61a8062
--- /dev/null
+++ b/arch/arm/boot/dts/dove-cm-a510.dts
@@ -0,0 +1,38 @@
+/dts-v1/;
+
+/include/ "dove.dtsi"
+
+/ {
+	model = "Compulab CM-A510";
+	compatible = "compulab,cm-a510", "marvell,dove";
+
+	memory {
+		device_type = "memory";
+		reg = <0x00000000 0x40000000>;
+	};
+
+	chosen {
+		bootargs = "console=ttyS0,115200n8 earlyprintk";
+	};
+};
+
+&uart0 { status = "okay"; };
+&uart1 { status = "okay"; };
+&sdio0 { status = "okay"; };
+&sdio1 { status = "okay"; };
+&sata0 { status = "okay"; };
+
+&spi0 {
+	status = "okay";
+
+	/* spi0.0: 4M Flash Winbond W25Q32BV */
+	spi-flash@0 {
+		compatible = "st,w25q32";
+		spi-max-frequency = <20000000>;
+		reg = <0>;
+	};
+};
+
+&i2c0 {
+	  status = "okay";
+};
diff --git a/arch/arm/boot/dts/dove-dove-db.dts b/arch/arm/boot/dts/dove-dove-db.dts
new file mode 100644
index 0000000..e5a920b
--- /dev/null
+++ b/arch/arm/boot/dts/dove-dove-db.dts
@@ -0,0 +1,38 @@
+/dts-v1/;
+
+/include/ "dove.dtsi"
+
+/ {
+	model = "Marvell DB-MV88AP510-BP Development Board";
+	compatible = "marvell,dove-db", "marvell,dove";
+
+	memory {
+		device_type = "memory";
+		reg = <0x00000000 0x40000000>;
+	};
+
+	chosen {
+		bootargs = "console=ttyS0,115200n8 earlyprintk";
+	};
+};
+
+&uart0 { status = "okay"; };
+&uart1 { status = "okay"; };
+&sdio0 { status = "okay"; };
+&sdio1 { status = "okay"; };
+&sata0 { status = "okay"; };
+
+&spi0 {
+	status = "okay";
+
+	/* spi0.0: 4M Flash ST-M25P32-VMF6P */
+	spi-flash@0 {
+		compatible = "st,m25p32";
+		spi-max-frequency = <20000000>;
+		reg = <0>;
+	};
+};
+
+&i2c0 {
+	  status = "okay";
+};
diff --git a/arch/arm/boot/dts/dove.dtsi b/arch/arm/boot/dts/dove.dtsi
new file mode 100644
index 0000000..96fb824
--- /dev/null
+++ b/arch/arm/boot/dts/dove.dtsi
@@ -0,0 +1,143 @@
+/include/ "skeleton.dtsi"
+
+/ {
+	compatible = "marvell,dove";
+	model = "Marvell Armada 88AP510 SoC";
+
+	interrupt-parent = <&intc>;
+
+	intc: interrupt-controller {
+		compatible = "marvell,orion-intc";
+		interrupt-controller;
+		#interrupt-cells = <1>;
+		reg = <0xf1020204 0x04>,
+		      <0xf1020214 0x04>;
+	};
+
+	mbus@f1000000 {
+		compatible = "simple-bus";
+		ranges = <0 0xf1000000 0x4000000>;
+		#address-cells = <1>;
+		#size-cells = <1>;
+
+		uart0: serial@12000 {
+			compatible = "ns16550a";
+			reg = <0x12000 0x100>;
+			reg-shift = <2>;
+			interrupts = <7>;
+			clock-frequency = <166666667>;
+			status = "disabled";
+		};
+
+		uart1: serial@12100 {
+			compatible = "ns16550a";
+			reg = <0x12100 0x100>;
+			reg-shift = <2>;
+			interrupts = <8>;
+			clock-frequency = <166666667>;
+			status = "disabled";
+		};
+
+		uart2: serial@12200 {
+			compatible = "ns16550a";
+			reg = <0x12000 0x100>;
+			reg-shift = <2>;
+			interrupts = <9>;
+			clock-frequency = <166666667>;
+			status = "disabled";
+		};
+
+		uart3: serial@12300 {
+			compatible = "ns16550a";
+			reg = <0x12100 0x100>;
+			reg-shift = <2>;
+			interrupts = <10>;
+			clock-frequency = <166666667>;
+			status = "disabled";
+		};
+
+		wdt: wdt@20300 {
+			compatible = "marvell,orion-wdt";
+			reg = <0x20300 0x28>;
+		};
+
+		gpio0: gpio@d0400 {
+			compatible = "marvell,orion-gpio";
+			#gpio-cells = <2>;
+			gpio-controller;
+			reg = <0xd0400 0x20>;
+			ngpio = <32>;
+			interrupts = <12>, <13>, <14>, <60>;
+		};
+
+		gpio1: gpio@d0420 {
+			compatible = "marvell,orion-gpio";
+			#gpio-cells = <2>;
+			gpio-controller;
+			reg = <0xd0420 0x20>;
+			ngpio = <32>;
+			interrupts = <61>;
+		};
+
+		gpio2: gpio@e8400 {
+			compatible = "marvell,orion-gpio";
+			#gpio-cells = <2>;
+			gpio-controller;
+			reg = <0xe8400 0x0c>;
+			ngpio = <8>;
+		};
+
+		spi0: spi@10600 {
+			compatible = "marvell,orion-spi";
+			#address-cells = <1>;
+			#size-cells = <0>;
+			cell-index = <0>;
+			interrupts = <6>;
+			reg = <0x10600 0x28>;
+			status = "disabled";
+		};
+
+		spi1: spi@14600 {
+			compatible = "marvell,orion-spi";
+			#address-cells = <1>;
+			#size-cells = <0>;
+			cell-index = <1>;
+			interrupts = <5>;
+			reg = <0x14600 0x28>;
+			status = "disabled";
+		};
+
+		i2c0: i2c@11000 {
+			compatible = "marvell,mv64xxx-i2c";
+			reg = <0x11000 0x20>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+			interrupts = <11>;
+			clock-frequency = <400000>;
+			timeout-ms = <1000>;
+			status = "disabled";
+		};
+
+		sdio0: sdio@92000 {
+			compatible = "marvell,dove-sdhci";
+			reg = <0x92000 0x100>;
+			interrupts = <35>, <37>;
+			status = "disabled";
+		};
+
+		sdio1: sdio@90000 {
+			compatible = "marvell,dove-sdhci";
+			reg = <0x90000 0x100>;
+			interrupts = <36>, <38>;
+			status = "disabled";
+		};
+
+		sata0: sata@a0000 {
+			compatible = "marvell,orion-sata";
+			reg = <0xa0000 0x2400>;
+			interrupts = <62>;
+			nr-ports = <1>;
+			status = "disabled";
+		};
+	};
+};
diff --git a/arch/arm/mach-dove/Makefile.boot b/arch/arm/mach-dove/Makefile.boot
index 760a0ef..94ab6b3 100644
--- a/arch/arm/mach-dove/Makefile.boot
+++ b/arch/arm/mach-dove/Makefile.boot
@@ -1,3 +1,6 @@
    zreladdr-y	+= 0x00008000
 params_phys-y	:= 0x00000100
 initrd_phys-y	:= 0x00800000
+
+dtb-$(CONFIG_MACH_DOVE_DT) += dove-dove-db.dtb
+dtb-$(CONFIG_MACH_DOVE_DT) += dove-cm-a510.dtb
-- 
1.7.10.4

