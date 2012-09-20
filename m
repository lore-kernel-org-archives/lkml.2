Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932256Ab2ITOnI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 10:43:08 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:52363 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932195Ab2ITOml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 10:42:41 -0400
From: Matt Porter <mporter@ti.com>
To: Tony Lindgren <tony@atomide.com>, Sekhar Nori <nsekhar@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Vinod Koul <vinod.koul@intel.com>, Rob Landley <rob@landley.net>,
        Chris Ball <cjb@laptop.org>
Cc: Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Arnd Bergmann <arnd@arndb.de>, Dan Williams <djbw@fb.com>,
        Rob Herring <rob.herring@calxeda.com>
Subject: [RFC PATCH 12/13] ARM: dts: add am33xx EDMA support
Date: Thu, 20 Sep 2012 10:43:45 -0400
Message-Id: <1348152226-13588-13-git-send-email-mporter@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1348152226-13588-1-git-send-email-mporter@ti.com>
References: <1348152226-13588-1-git-send-email-mporter@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds support for the defined EDMA, generic DMA controller, and
DMA request bindings for mmc and spi.

Signed-off-by: Matt Porter <mporter@ti.com>
---
 arch/arm/boot/dts/am33xx.dtsi |   46 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
index e8033eb..c14a61d 100644
--- a/arch/arm/boot/dts/am33xx.dtsi
+++ b/arch/arm/boot/dts/am33xx.dtsi
@@ -86,6 +86,36 @@
 			reg = <0x48200000 0x1000>;
 		};
 
+		edma: edma@49000000 {
+			compatible = "ti,edma3";
+			ti,hwmods = "tpcc", "tptc0", "tptc1", "tptc2";
+			reg = <0x49000000 0x10000>;
+			interrupt-parent = <&intc>;
+			interrupts = <12 13 14>;
+			#dma-cells = <1>;
+			dma-channels = <64>;
+			ti,edma-regions = <4>;
+			ti,edma-slots = <256>;
+			ti,edma-reserved-channels = <0  2
+					     14 2
+					     26 6
+					     48 4
+					     56 8>;
+			ti,edma-reserved-slots = <0  2
+					  14 2
+					  26 6
+					  48 4
+					  56 8
+					  64 127>;
+			ti,edma-queue-tc-map = <0 0
+					1 1
+					2 2>;
+			ti,edma-queue-priority-map = <0 0
+					      1 1
+					      2 2>;
+			ti,edma-default-queue = <0>;
+		};
+
 		gpio0: gpio@44e07000 {
 			compatible = "ti,omap4-gpio";
 			ti,hwmods = "gpio1";
@@ -290,6 +320,9 @@
 			ti,hwmods = "mmc1";
 			ti,dual-volt;
 			ti,needs-special-reset;
+			dmas = <&edma 24
+				&edma 25>;
+			dma-names = "tx", "rx";
 		};
 
 		mmc2: mmc@481D8000 {
@@ -297,6 +330,9 @@
 			ti,hwmods = "mmc2";
 			ti,needs-special-reset;
 			status = "disabled";
+			dmas = <&edma 2
+				&edma 3>;
+			dma-names = "tx", "rx";
 		};
 
 		mmc3: mmc@47810000 {
@@ -339,6 +375,11 @@
 			reg = <0x48030000 0x400>;
 			interrupt-parent = <&intc>;
 			interrupt = <65>;
+			dmas = <&edma 16
+				&edma 17
+				&edma 18
+				&edma 19>;
+			dma-names = "tx0", "rx0", "tx1", "rx1";
 			ti,spi-num-cs = <2>;
 			ti,hwmods = "spi0";
 			status = "disabled";
@@ -351,6 +392,11 @@
 			reg = <0x481a0000 0x400>;
 			interrupt-parent = <&intc>;
 			interrupt = <125>;
+			dmas = <&edma 42
+				&edma 43
+				&edma 44
+				&edma 45>;
+			dma-names = "tx0", "rx0", "tx1", "rx1";
 			ti,spi-num-cs = <2>;
 			ti,hwmods = "spi1";
 			status = "disabled";
-- 
1.7.9.5

