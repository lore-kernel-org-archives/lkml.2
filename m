Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751857Ab2LSGbd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 01:31:33 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:6366 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922Ab2LSGb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 01:31:28 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Tue, 18 Dec 2012 22:29:45 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <swarren@wwwdotorg.org>
CC: <linux@arm.linux.org.uk>, <linux-tegra@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH] ARM: tegra: dts: add aliases and DMA requestor for serial controller
Date: Wed, 19 Dec 2012 12:01:11 +0530
Message-ID: <1355898671-3960-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add APB DMA requestor and serial aliases for serial controller.
There will be two serial driver i.e. 8250 based simple serial driver
and APB DMA based serial driver for higher baudrate and performace.

The simple serial driver get enabled with compatible nvidia,tegra20-uart
and APB DMA based driver will get enabled with compatible
nvidia,tegra20-hsuart.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 arch/arm/boot/dts/tegra20.dtsi |   30 +++++++++++++++++++++++++-----
 arch/arm/boot/dts/tegra30.dtsi |   31 ++++++++++++++++++++++++++-----
 2 files changed, 51 insertions(+), 10 deletions(-)

diff --git a/arch/arm/boot/dts/tegra20.dtsi b/arch/arm/boot/dts/tegra20.dtsi
index b8effa1..fe35c72 100644
--- a/arch/arm/boot/dts/tegra20.dtsi
+++ b/arch/arm/boot/dts/tegra20.dtsi
@@ -4,6 +4,14 @@
 	compatible = "nvidia,tegra20";
 	interrupt-parent = <&intc>;
 
+	aliases {
+		serial0 = &uarta;
+		serial1 = &uartb;
+		serial2 = &uartc;
+		serial3 = &uartd;
+		serial4 = &uarte;
+	};
+
 	host1x {
 		compatible = "nvidia,tegra20-host1x", "simple-bus";
 		reg = <0x50000000 0x00024000>;
@@ -194,43 +202,55 @@
 		status = "disabled";
 	};
 
-	serial@70006000 {
+	/*
+	 * There are two serial driver i.e. 8250 based simple serial
+	 * driver and APB DMA based serial driver for higher baudrate
+	 * and performace. To enable the 8250 based driver, the compatible
+	 * is "nvidia,tegra20-uart" and to enable the APB DMA based serial
+	 * driver, the comptible is "nvidia,tegra20-hsuart".
+	 */
+	uarta: serial@70006000 {
 		compatible = "nvidia,tegra20-uart";
 		reg = <0x70006000 0x40>;
 		reg-shift = <2>;
 		interrupts = <0 36 0x04>;
+		nvidia,dma-request-selector = <&apbdma 8>;
 		status = "disabled";
 	};
 
-	serial@70006040 {
+	uartb: serial@70006040 {
 		compatible = "nvidia,tegra20-uart";
 		reg = <0x70006040 0x40>;
 		reg-shift = <2>;
 		interrupts = <0 37 0x04>;
+		nvidia,dma-request-selector = <&apbdma 9>;
 		status = "disabled";
 	};
 
-	serial@70006200 {
+	uartc: serial@70006200 {
 		compatible = "nvidia,tegra20-uart";
 		reg = <0x70006200 0x100>;
 		reg-shift = <2>;
 		interrupts = <0 46 0x04>;
+		nvidia,dma-request-selector = <&apbdma 10>;
 		status = "disabled";
 	};
 
-	serial@70006300 {
+	uartd: serial@70006300 {
 		compatible = "nvidia,tegra20-uart";
 		reg = <0x70006300 0x100>;
 		reg-shift = <2>;
 		interrupts = <0 90 0x04>;
+		nvidia,dma-request-selector = <&apbdma 19>;
 		status = "disabled";
 	};
 
-	serial@70006400 {
+	uarte: serial@70006400 {
 		compatible = "nvidia,tegra20-uart";
 		reg = <0x70006400 0x100>;
 		reg-shift = <2>;
 		interrupts = <0 91 0x04>;
+		nvidia,dma-request-selector = <&apbdma 20>;
 		status = "disabled";
 	};
 
diff --git a/arch/arm/boot/dts/tegra30.dtsi b/arch/arm/boot/dts/tegra30.dtsi
index 529fdb8..80a0edf 100644
--- a/arch/arm/boot/dts/tegra30.dtsi
+++ b/arch/arm/boot/dts/tegra30.dtsi
@@ -4,6 +4,14 @@
 	compatible = "nvidia,tegra30";
 	interrupt-parent = <&intc>;
 
+	aliases {
+		serial0 = &uarta;
+		serial1 = &uartb;
+		serial2 = &uartc;
+		serial3 = &uartd;
+		serial4 = &uarte;
+	};
+
 	host1x {
 		compatible = "nvidia,tegra30-host1x", "simple-bus";
 		reg = <0x50000000 0x00024000>;
@@ -190,43 +198,56 @@
 		       0x70003000 0x3e4>; /* Mux registers */
 	};
 
-	serial@70006000 {
+	/*
+	 * There are two serial driver i.e. 8250 based simple serial
+	 * driver and APB DMA based serial driver for higher baudrate
+	 * and performace. To enable the 8250 based driver, the compatible
+	 * is "nvidia,tegra30-uart", "nvidia,tegra20-uart" and to enable
+	 * the APB DMA based serial driver, the comptible is
+	 * "nvidia,tegra30-hsuart", "nvidia,tegra20-hsuart".
+	 */
+	uarta: serial@70006000 {
 		compatible = "nvidia,tegra30-uart", "nvidia,tegra20-uart";
 		reg = <0x70006000 0x40>;
 		reg-shift = <2>;
 		interrupts = <0 36 0x04>;
+		nvidia,dma-request-selector = <&apbdma 8>;
 		status = "disabled";
 	};
 
-	serial@70006040 {
+	uartb: serial@70006040 {
 		compatible = "nvidia,tegra30-uart", "nvidia,tegra20-uart";
 		reg = <0x70006040 0x40>;
 		reg-shift = <2>;
 		interrupts = <0 37 0x04>;
+		nvidia,dma-request-selector = <&apbdma 9>;
 		status = "disabled";
 	};
 
-	serial@70006200 {
+	uartc: serial@70006200 {
 		compatible = "nvidia,tegra30-uart", "nvidia,tegra20-uart";
 		reg = <0x70006200 0x100>;
 		reg-shift = <2>;
 		interrupts = <0 46 0x04>;
+		nvidia,dma-request-selector = <&apbdma 10>;
 		status = "disabled";
 	};
 
-	serial@70006300 {
+	uartd: serial@70006300 {
 		compatible = "nvidia,tegra30-uart", "nvidia,tegra20-uart";
 		reg = <0x70006300 0x100>;
 		reg-shift = <2>;
 		interrupts = <0 90 0x04>;
+		nvidia,dma-request-selector = <&apbdma 19>;
 		status = "disabled";
 	};
 
-	serial@70006400 {
+	uarte: serial@70006400 {
 		compatible = "nvidia,tegra30-uart", "nvidia,tegra20-uart";
 		reg = <0x70006400 0x100>;
 		reg-shift = <2>;
 		interrupts = <0 91 0x04>;
+		nvidia,dma-request-selector = <&apbdma 20>;
 		status = "disabled";
 	};
 
-- 
1.7.1.1

