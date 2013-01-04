Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159Ab3ADJrG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 04:47:06 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:3594 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752346Ab3ADJrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 04:47:01 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Fri, 04 Jan 2013 01:46:50 -0800
From: Prashant Gaikwad <pgaikwad@nvidia.com>
To: <swarren@nvidia.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, Prashant Gaikwad <pgaikwad@nvidia.com>
Subject: [PATCH 1/7] ARM: dt: tegra20: Add clock information
Date: Fri, 4 Jan 2013 15:16:37 +0530
Message-ID: <1357292803-28604-1-git-send-email-pgaikwad@nvidia.com>
X-Mailer: git-send-email 1.7.4.1
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add clock information to device nodes.

Signed-off-by: Prashant Gaikwad <pgaikwad@nvidia.com>
---
Tested on Ventana (Tegra20) and Cardhu (Tegra30).
This series depends on ccf-rework patch series.
---
 arch/arm/boot/dts/tegra20.dtsi |   41 ++++++++++++++++++++++++++++++++++++++++
 1 files changed, 41 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/tegra20.dtsi b/arch/arm/boot/dts/tegra20.dtsi
index be3421d..8cc5295 100644
--- a/arch/arm/boot/dts/tegra20.dtsi
+++ b/arch/arm/boot/dts/tegra20.dtsi
@@ -17,6 +17,7 @@
 		reg = <0x50000000 0x00024000>;
 		interrupts = <0 65 0x04   /* mpcore syncpt */
 			      0 67 0x04>; /* mpcore general */
+		clocks = <&tegra_car 28>;
 
 		#address-cells = <1>;
 		#size-cells = <1>;
@@ -27,41 +28,48 @@
 			compatible = "nvidia,tegra20-mpe";
 			reg = <0x54040000 0x00040000>;
 			interrupts = <0 68 0x04>;
+			clocks = <&tegra_car 60>;
 		};
 
 		vi {
 			compatible = "nvidia,tegra20-vi";
 			reg = <0x54080000 0x00040000>;
 			interrupts = <0 69 0x04>;
+			clocks = <&tegra_car 100>;
 		};
 
 		epp {
 			compatible = "nvidia,tegra20-epp";
 			reg = <0x540c0000 0x00040000>;
 			interrupts = <0 70 0x04>;
+			clocks = <&tegra_car 19>;
 		};
 
 		isp {
 			compatible = "nvidia,tegra20-isp";
 			reg = <0x54100000 0x00040000>;
 			interrupts = <0 71 0x04>;
+			clocks = <&tegra_car 23>;
 		};
 
 		gr2d {
 			compatible = "nvidia,tegra20-gr2d";
 			reg = <0x54140000 0x00040000>;
 			interrupts = <0 72 0x04>;
+			clocks = <&tegra_car 21>;
 		};
 
 		gr3d {
 			compatible = "nvidia,tegra20-gr3d";
 			reg = <0x54180000 0x00040000>;
+			clocks = <&tegra_car 24>;
 		};
 
 		dc@54200000 {
 			compatible = "nvidia,tegra20-dc";
 			reg = <0x54200000 0x00040000>;
 			interrupts = <0 73 0x04>;
+			clocks = <&tegra_car 27>;
 
 			rgb {
 				status = "disabled";
@@ -72,6 +80,7 @@
 			compatible = "nvidia,tegra20-dc";
 			reg = <0x54240000 0x00040000>;
 			interrupts = <0 74 0x04>;
+			clocks = <&tegra_car 26>;
 
 			rgb {
 				status = "disabled";
@@ -83,6 +92,7 @@
 			reg = <0x54280000 0x00040000>;
 			interrupts = <0 75 0x04>;
 			status = "disabled";
+			clocks = <&tegra_car 51>;
 		};
 
 		tvo {
@@ -90,12 +100,14 @@
 			reg = <0x542c0000 0x00040000>;
 			interrupts = <0 76 0x04>;
 			status = "disabled";
+			clocks = <&tegra_car 102>;
 		};
 
 		dsi {
 			compatible = "nvidia,tegra20-dsi";
 			reg = <0x54300000 0x00040000>;
 			status = "disabled";
+			clocks = <&tegra_car 48>;
 		};
 	};
 
@@ -156,6 +168,7 @@
 			      0 117 0x04
 			      0 118 0x04
 			      0 119 0x04>;
+		clocks = <&tegra_car 34>;
 	};
 
 	ahb {
@@ -198,6 +211,7 @@
 		interrupts = <0 13 0x04>;
 		nvidia,dma-request-selector = <&apbdma 2>;
 		status = "disabled";
+		clocks = <&tegra_car 11>;
 	};
 
 	tegra_i2s2: i2s@70002a00 {
@@ -206,6 +220,7 @@
 		interrupts = <0 3 0x04>;
 		nvidia,dma-request-selector = <&apbdma 1>;
 		status = "disabled";
+		clocks = <&tegra_car 18>;
 	};
 
 	/*
@@ -222,6 +237,7 @@
 		interrupts = <0 36 0x04>;
 		nvidia,dma-request-selector = <&apbdma 8>;
 		status = "disabled";
+		clocks = <&tegra_car 6>;
 	};
 
 	uartb: serial@70006040 {
@@ -231,6 +247,7 @@
 		interrupts = <0 37 0x04>;
 		nvidia,dma-request-selector = <&apbdma 9>;
 		status = "disabled";
+		clocks = <&tegra_car 96>;
 	};
 
 	uartc: serial@70006200 {
@@ -240,6 +257,7 @@
 		interrupts = <0 46 0x04>;
 		nvidia,dma-request-selector = <&apbdma 10>;
 		status = "disabled";
+		clocks = <&tegra_car 55>;
 	};
 
 	uartd: serial@70006300 {
@@ -249,6 +267,7 @@
 		interrupts = <0 90 0x04>;
 		nvidia,dma-request-selector = <&apbdma 19>;
 		status = "disabled";
+		clocks = <&tegra_car 65>;
 	};
 
 	uarte: serial@70006400 {
@@ -258,12 +277,14 @@
 		interrupts = <0 91 0x04>;
 		nvidia,dma-request-selector = <&apbdma 20>;
 		status = "disabled";
+		clocks = <&tegra_car 66>;
 	};
 
 	pwm: pwm {
 		compatible = "nvidia,tegra20-pwm";
 		reg = <0x7000a000 0x100>;
 		#pwm-cells = <2>;
+		clocks = <&tegra_car 17>;
 	};
 
 	rtc {
@@ -279,6 +300,8 @@
 		#address-cells = <1>;
 		#size-cells = <0>;
 		status = "disabled";
+		clocks = <&tegra_car 12>, <&tegra_car 124>;
+		clock-names = "div-clk", "fast-clk";
 	};
 
 	spi@7000c380 {
@@ -289,6 +312,7 @@
 		#address-cells = <1>;
 		#size-cells = <0>;
 		status = "disabled";
+		clocks = <&tegra_car 43>;
 	};
 
 	i2c@7000c400 {
@@ -298,6 +322,8 @@
 		#address-cells = <1>;
 		#size-cells = <0>;
 		status = "disabled";
+		clocks = <&tegra_car 54>, <&tegra_car 124>;
+		clock-names = "div-clk", "fast-clk";
 	};
 
 	i2c@7000c500 {
@@ -307,6 +333,8 @@
 		#address-cells = <1>;
 		#size-cells = <0>;
 		status = "disabled";
+		clocks = <&tegra_car 67>, <&tegra_car 124>;
+		clock-names = "div-clk", "fast-clk";
 	};
 
 	i2c@7000d000 {
@@ -316,6 +344,8 @@
 		#address-cells = <1>;
 		#size-cells = <0>;
 		status = "disabled";
+		clocks = <&tegra_car 47>, <&tegra_car 124>;
+		clock-names = "div-clk", "fast-clk";
 	};
 
 	spi@7000d400 {
@@ -326,6 +356,7 @@
 		#address-cells = <1>;
 		#size-cells = <0>;
 		status = "disabled";
+		clocks = <&tegra_car 41>;
 	};
 
 	spi@7000d600 {
@@ -336,6 +367,7 @@
 		#address-cells = <1>;
 		#size-cells = <0>;
 		status = "disabled";
+		clocks = <&tegra_car 44>;
 	};
 
 	spi@7000d800 {
@@ -346,6 +378,7 @@
 		#address-cells = <1>;
 		#size-cells = <0>;
 		status = "disabled";
+		clocks = <&tegra_car 46>;
 	};
 
 	spi@7000da00 {
@@ -356,6 +389,7 @@
 		#address-cells = <1>;
 		#size-cells = <0>;
 		status = "disabled";
+		clocks = <&tegra_car 68>;
 	};
 
 	pmc {
@@ -390,6 +424,7 @@
 		phy_type = "utmi";
 		nvidia,has-legacy-mode;
 		status = "disabled";
+		clocks = <&tegra_car 22>;
 	};
 
 	usb@c5004000 {
@@ -398,6 +433,7 @@
 		interrupts = <0 21 0x04>;
 		phy_type = "ulpi";
 		status = "disabled";
+		clocks = <&tegra_car 58>;
 	};
 
 	usb@c5008000 {
@@ -406,6 +442,7 @@
 		interrupts = <0 97 0x04>;
 		phy_type = "utmi";
 		status = "disabled";
+		clocks = <&tegra_car 59>;
 	};
 
 	sdhci@c8000000 {
@@ -413,6 +450,7 @@
 		reg = <0xc8000000 0x200>;
 		interrupts = <0 14 0x04>;
 		status = "disabled";
+		clocks = <&tegra_car 14>;
 	};
 
 	sdhci@c8000200 {
@@ -420,6 +458,7 @@
 		reg = <0xc8000200 0x200>;
 		interrupts = <0 15 0x04>;
 		status = "disabled";
+		clocks = <&tegra_car 9>;
 	};
 
 	sdhci@c8000400 {
@@ -427,6 +466,7 @@
 		reg = <0xc8000400 0x200>;
 		interrupts = <0 19 0x04>;
 		status = "disabled";
+		clocks = <&tegra_car 69>;
 	};
 
 	sdhci@c8000600 {
@@ -434,6 +474,7 @@
 		reg = <0xc8000600 0x200>;
 		interrupts = <0 31 0x04>;
 		status = "disabled";
+		clocks = <&tegra_car 15>;
 	};
 
 	pmu {
-- 
1.7.4.1

