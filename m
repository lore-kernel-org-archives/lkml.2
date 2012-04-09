Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754290Ab2DIHVc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 03:21:32 -0400
Received: from denmail01-v4020.amcc.com ([192.195.68.30]:44014 "EHLO
	denmail01.apm.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753914Ab2DIHV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 03:21:29 -0400
From: Tanmay Inamdar <tinamdar@apm.com>
To: benh@kernel.crashing.org, jwboyer@gmail.com, grant.likely@secretlab.ca,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Cc: Tanmay Inamdar <tinamdar@apm.com>
Subject: [V2 1/5] powerpc: dts: klondike: Add AHB, APB  bus; remove OPB bus
Date: Mon,  9 Apr 2012 12:50:48 +0530
Message-Id: <1333956052-25319-1-git-send-email-tinamdar@apm.com>
X-Mailer: git-send-email 1.6.1.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add entries in klondike device tree for AHB and APB bus and remove entry for
non-existent OPB bus inherited from legacy code.

Signed-off-by: Tanmay Inamdar <tinamdar@apm.com>
---
:100644 100644 8c94290... 4ff2852... M	arch/powerpc/boot/dts/klondike.dts
 arch/powerpc/boot/dts/klondike.dts |  167 ++++++++++++++++++-----------------
 1 files changed, 86 insertions(+), 81 deletions(-)

diff --git a/arch/powerpc/boot/dts/klondike.dts b/arch/powerpc/boot/dts/klondike.dts
index 8c94290..4ff2852 100644
--- a/arch/powerpc/boot/dts/klondike.dts
+++ b/arch/powerpc/boot/dts/klondike.dts
@@ -132,96 +132,101 @@
 					/*RXDE*/  0x3 0x4>;
 		};
 
-		POB0: opb {
-			compatible = "ibm,opb";
-			#address-cells = <1>;
-			#size-cells = <1>;
-			ranges = <0x20000000 0x20000000 0x30000000
-				  0x50000000 0x50000000 0x10000000
-				  0x60000000 0x60000000 0x10000000
-				  0xFE000000 0xFE000000 0x00010000>;
-			dcr-reg = <0x100 0x020>;
-			clock-frequency = <300000000>; /* Filled in by U-Boot */
+		RGMII0: emac-rgmii@400a2000 {
+			compatible = "ibm,rgmii";
+			reg = <0x400a2000 0x00000010>;
+			has-mdio;
+		};
 
-			RGMII0: emac-rgmii@400a2000 {
-				compatible = "ibm,rgmii";
-				reg = <0x400a2000 0x00000010>;
-				has-mdio;
-			};
+		TAH0: emac-tah@400a3000 {
+			compatible = "ibm,tah";
+			reg = <0x400a3000 0x100>;
+		};
 
-			TAH0: emac-tah@400a3000 {
-				compatible = "ibm,tah";
-				reg = <0x400a3000 0x100>;
-			};
+		TAH1: emac-tah@400a4000 {
+			compatible = "ibm,tah";
+			reg = <0x400a4000 0x100>;
+		};
 
-			TAH1: emac-tah@400a4000 {
-				compatible = "ibm,tah";
-				reg = <0x400a4000 0x100>;
-			};
+		EMAC0: ethernet@400a0000 {
+			compatible = "ibm,emac4", "ibm-emac4sync";
+			interrupt-parent = <&EMAC0>;
+			interrupts = <0x0>;
+			#interrupt-cells = <1>;
+			#address-cells = <0>;
+			#size-cells = <0>;
+			interrupt-map = </*Status*/ 0x0 &UIC0 0x13 0x4>;
+			reg = <0x400a0000 0x00000100>;
+			local-mac-address = [000000000000]; /* Filled in by U-Boot */
+			mal-device = <&MAL0>;
+			mal-tx-channel = <0x0>;
+			mal-rx-channel = <0x0>;
+			cell-index = <0>;
+			max-frame-size = <9000>;
+			rx-fifo-size = <4096>;
+			tx-fifo-size = <2048>;
+			phy-mode = "rgmii";
+			phy-address = <0x2>;
+			turbo = "no";
+			phy-map = <0x00000000>;
+			rgmii-device = <&RGMII0>;
+			rgmii-channel = <0>;
+			tah-device = <&TAH0>;
+			tah-channel = <0>;
+			has-inverted-stacr-oc;
+			has-new-stacr-staopc;
+		};
 
-			EMAC0: ethernet@400a0000 {
-				compatible = "ibm,emac4", "ibm-emac4sync";
-				interrupt-parent = <&EMAC0>;
-				interrupts = <0x0>;
-				#interrupt-cells = <1>;
-				#address-cells = <0>;
-				#size-cells = <0>;
-				interrupt-map = </*Status*/ 0x0 &UIC0 0x13 0x4>;
-				reg = <0x400a0000 0x00000100>;
-				local-mac-address = [000000000000]; /* Filled in by U-Boot */
-				mal-device = <&MAL0>;
-				mal-tx-channel = <0x0>;
-				mal-rx-channel = <0x0>;
-				cell-index = <0>;
-				max-frame-size = <9000>;
-				rx-fifo-size = <4096>;
-				tx-fifo-size = <2048>;
-				phy-mode = "rgmii";
-				phy-address = <0x2>;
-				turbo = "no";
-				phy-map = <0x00000000>;
-				rgmii-device = <&RGMII0>;
-				rgmii-channel = <0>;
-				tah-device = <&TAH0>;
-				tah-channel = <0>;
-				has-inverted-stacr-oc;
-				has-new-stacr-staopc;
-			};
+		EMAC1: ethernet@400a1000 {
+			compatible = "ibm,emac4", "ibm-emac4sync";
+			status = "disabled";
+			interrupt-parent = <&EMAC1>;
+			interrupts = <0x0>;
+			#interrupt-cells = <1>;
+			#address-cells = <0>;
+			#size-cells = <0>;
+			interrupt-map = </*Status*/ 0x0 &UIC0 0x14 0x4>;
+			reg = <0x400a1000 0x00000100>;
+			local-mac-address = [000000000000]; /* Filled in by U-Boot */
+			mal-device = <&MAL0>;
+			mal-tx-channel = <1>;
+			mal-rx-channel = <8>;
+			cell-index = <1>;
+			max-frame-size = <9000>;
+			rx-fifo-size = <4096>;
+			tx-fifo-size = <2048>;
+			phy-mode = "rgmii";
+			phy-address = <0x3>;
+			turbo = "no";
+			phy-map = <0x00000000>;
+			rgmii-device = <&RGMII0>;
+			rgmii-channel = <1>;
+			tah-device = <&TAH1>;
+			tah-channel = <0>;
+			has-inverted-stacr-oc;
+			has-new-stacr-staopc;
+			mdio-device = <&EMAC0>;
+		};
 
-			EMAC1: ethernet@400a1000 {
-				compatible = "ibm,emac4", "ibm-emac4sync";
-				status = "disabled";
-				interrupt-parent = <&EMAC1>;
-				interrupts = <0x0>;
-				#interrupt-cells = <1>;
-				#address-cells = <0>;
-				#size-cells = <0>;
-				interrupt-map = </*Status*/ 0x0 &UIC0 0x14 0x4>;
-				reg = <0x400a1000 0x00000100>;
-				local-mac-address = [000000000000]; /* Filled in by U-Boot */
-				mal-device = <&MAL0>;
-				mal-tx-channel = <1>;
-				mal-rx-channel = <8>;
-				cell-index = <1>;
-				max-frame-size = <9000>;
-				rx-fifo-size = <4096>;
-				tx-fifo-size = <2048>;
-				phy-mode = "rgmii";
-				phy-address = <0x3>;
-				turbo = "no";
-				phy-map = <0x00000000>;
-				rgmii-device = <&RGMII0>;
-				rgmii-channel = <1>;
-				tah-device = <&TAH1>;
-				tah-channel = <0>;
-				has-inverted-stacr-oc;
-				has-new-stacr-staopc;
-				mdio-device = <&EMAC0>;
+		AHB: ahb {
+			compatible = "apm,ahb";
+			dcr-reg = <0xc 0x2>;
+			#address-cells = <1>;
+			#size-cells = <1>;
+			ranges;
+			clock-frequency = <0>; /* Filled in by U-Boot */
+
+			APB: apb {
+				compatible = "apm,apb";
+				#address-cells = <1>;
+				#size-cells = <1>;
+				ranges;
+				clock-frequency = <0>;
 			};
 		};
 	};
 
 	chosen {
-		linux,stdout-path = "/plb/opb/serial@50001000";
+		linux,stdout-path = "/plb/ahb/apb/serial@50001000";
 	};
 };
-- 
1.6.1.rc3

