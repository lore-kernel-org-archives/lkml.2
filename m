Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347Ab2IYLiI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 07:38:08 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:38546 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105Ab2IYLiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 07:38:06 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, broonie@opensource.wolfsonmicro.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH] ARM: ux500: Move regulator-name properties out to board DTS files
Date: Tue, 25 Sep 2012 12:37:54 +0100
Message-Id: <1348573074-11481-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Regulator supply names should be allocated by board rather than
per SoC, as the same SoC could be wired differently on varying
hardware. Here we push all regulator-name allocation out to the
dbx5x0 subordinate board files; HREF and Snowball.

Requested-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/dbx5x0.dtsi     |   31 ---------
 arch/arm/boot/dts/hrefv60plus.dts |  132 +++++++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/snowball.dts    |  132 +++++++++++++++++++++++++++++++++++++
 3 files changed, 264 insertions(+), 31 deletions(-)

diff --git a/arch/arm/boot/dts/dbx5x0.dtsi b/arch/arm/boot/dts/dbx5x0.dtsi
index 748ba7a..c8c39dd 100644
--- a/arch/arm/boot/dts/dbx5x0.dtsi
+++ b/arch/arm/boot/dts/dbx5x0.dtsi
@@ -209,123 +209,103 @@
 				// DB8500_REGULATOR_VAPE
 				db8500_vape_reg: db8500_vape {
 					regulator-compatible = "db8500_vape";
-					regulator-name = "db8500-vape";
 					regulator-always-on;
 				};
 
 				// DB8500_REGULATOR_VARM
 				db8500_varm_reg: db8500_varm {
 					regulator-compatible = "db8500_varm";
-					regulator-name = "db8500-varm";
 				};
 
 				// DB8500_REGULATOR_VMODEM
 				db8500_vmodem_reg: db8500_vmodem {
 					regulator-compatible = "db8500_vmodem";
-					regulator-name = "db8500-vmodem";
 				};
 
 				// DB8500_REGULATOR_VPLL
 				db8500_vpll_reg: db8500_vpll {
 					regulator-compatible = "db8500_vpll";
-					regulator-name = "db8500-vpll";
 				};
 
 				// DB8500_REGULATOR_VSMPS1
 				db8500_vsmps1_reg: db8500_vsmps1 {
 					regulator-compatible = "db8500_vsmps1";
-					regulator-name = "db8500-vsmps1";
 				};
 
 				// DB8500_REGULATOR_VSMPS2
 				db8500_vsmps2_reg: db8500_vsmps2 {
 					regulator-compatible = "db8500_vsmps2";
-					regulator-name = "db8500-vsmps2";
 				};
 
 				// DB8500_REGULATOR_VSMPS3
 				db8500_vsmps3_reg: db8500_vsmps3 {
 					regulator-compatible = "db8500_vsmps3";
-					regulator-name = "db8500-vsmps3";
 				};
 
 				// DB8500_REGULATOR_VRF1
 				db8500_vrf1_reg: db8500_vrf1 {
 					regulator-compatible = "db8500_vrf1";
-					regulator-name = "db8500-vrf1";
 				};
 
 				// DB8500_REGULATOR_SWITCH_SVAMMDSP
 				db8500_sva_mmdsp_reg: db8500_sva_mmdsp {
 					regulator-compatible = "db8500_sva_mmdsp";
-					regulator-name = "db8500-sva-mmdsp";
 				};
 
 				// DB8500_REGULATOR_SWITCH_SVAMMDSPRET
 				db8500_sva_mmdsp_ret_reg: db8500_sva_mmdsp_ret {
 					regulator-compatible = "db8500_sva_mmdsp_ret";
-					regulator-name = "db8500-sva-mmdsp-ret";
 				};
 
 				// DB8500_REGULATOR_SWITCH_SVAPIPE
 				db8500_sva_pipe_reg: db8500_sva_pipe {
 					regulator-compatible = "db8500_sva_pipe";
-					regulator-name = "db8500_sva_pipe";
 				};
 
 				// DB8500_REGULATOR_SWITCH_SIAMMDSP
 				db8500_sia_mmdsp_reg: db8500_sia_mmdsp {
 					regulator-compatible = "db8500_sia_mmdsp";
-					regulator-name = "db8500_sia_mmdsp";
 				};
 
 				// DB8500_REGULATOR_SWITCH_SIAMMDSPRET
 				db8500_sia_mmdsp_ret_reg: db8500_sia_mmdsp_ret {
-					regulator-name = "db8500-sia-mmdsp-ret";
 				};
 
 				// DB8500_REGULATOR_SWITCH_SIAPIPE
 				db8500_sia_pipe_reg: db8500_sia_pipe {
 					regulator-compatible = "db8500_sia_pipe";
-					regulator-name = "db8500-sia-pipe";
 				};
 
 				// DB8500_REGULATOR_SWITCH_SGA
 				db8500_sga_reg: db8500_sga {
 					regulator-compatible = "db8500_sga";
-					regulator-name = "db8500-sga";
 					vin-supply = <&db8500_vape_reg>;
 				};
 
 				// DB8500_REGULATOR_SWITCH_B2R2_MCDE
 				db8500_b2r2_mcde_reg: db8500_b2r2_mcde {
 					regulator-compatible = "db8500_b2r2_mcde";
-					regulator-name = "db8500-b2r2-mcde";
 					vin-supply = <&db8500_vape_reg>;
 				};
 
 				// DB8500_REGULATOR_SWITCH_ESRAM12
 				db8500_esram12_reg: db8500_esram12 {
 					regulator-compatible = "db8500_esram12";
-					regulator-name = "db8500-esram12";
 				};
 
 				// DB8500_REGULATOR_SWITCH_ESRAM12RET
 				db8500_esram12_ret_reg: db8500_esram12_ret {
 					regulator-compatible = "db8500_esram12_ret";
-					regulator-name = "db8500-esram12-ret";
 				};
 
 				// DB8500_REGULATOR_SWITCH_ESRAM34
 				db8500_esram34_reg: db8500_esram34 {
 					regulator-compatible = "db8500_esram34";
-					regulator-name = "db8500-esram34";
 				};
 
 				// DB8500_REGULATOR_SWITCH_ESRAM34RET
 				db8500_esram34_ret_reg: db8500_esram34_ret {
 					regulator-compatible = "db8500_esram34_ret";
-					regulator-name = "db8500-esram34-ret";
 				};
 			};
 
@@ -404,7 +384,6 @@
 					// supplies to the display/camera
 					ab8500_ldo_aux1_reg: ab8500_ldo_aux1 {
 						regulator-compatible = "ab8500_ldo_aux1";
-						regulator-name = "V-DISPLAY";
 						regulator-min-microvolt = <2500000>;
 						regulator-max-microvolt = <2900000>;
 						regulator-boot-on;
@@ -415,7 +394,6 @@
 					// supplies to the on-board eMMC
 					ab8500_ldo_aux2_reg: ab8500_ldo_aux2 {
 						regulator-compatible = "ab8500_ldo_aux2";
-						regulator-name = "V-eMMC1";
 						regulator-min-microvolt = <1100000>;
 						regulator-max-microvolt = <3300000>;
 					};
@@ -423,7 +401,6 @@
 					// supply for VAUX3; SDcard slots
 					ab8500_ldo_aux3_reg: ab8500_ldo_aux3 {
 						regulator-compatible = "ab8500_ldo_aux3";
-						regulator-name = "V-MMC-SD";
 						regulator-min-microvolt = <1100000>;
 						regulator-max-microvolt = <3300000>;
 					};
@@ -431,49 +408,41 @@
 					// supply for v-intcore12; VINTCORE12 LDO
 					ab8500_ldo_initcore_reg: ab8500_ldo_initcore {
 						regulator-compatible = "ab8500_ldo_initcore";
-						regulator-name = "V-INTCORE";
 					};
 
 					// supply for tvout; gpadc; TVOUT LDO
 					ab8500_ldo_tvout_reg: ab8500_ldo_tvout {
 						regulator-compatible = "ab8500_ldo_tvout";
-						regulator-name = "V-TVOUT";
 					};
 
 					// supply for ab8500-usb; USB LDO
 					ab8500_ldo_usb_reg: ab8500_ldo_usb {
 						regulator-compatible = "ab8500_ldo_usb";
-						regulator-name = "dummy";
 					};
 
 					// supply for ab8500-vaudio; VAUDIO LDO
 					ab8500_ldo_audio_reg: ab8500_ldo_audio {
 						regulator-compatible = "ab8500_ldo_audio";
-						regulator-name = "V-AUD";
 					};
 
 					// supply for v-anamic1 VAMic1-LDO
 					ab8500_ldo_anamic1_reg: ab8500_ldo_anamic1 {
 						regulator-compatible = "ab8500_ldo_anamic1";
-						regulator-name = "V-AMIC1";
 					};
 
 					// supply for v-amic2; VAMIC2 LDO; reuse constants for AMIC1
 					ab8500_ldo_amamic2_reg: ab8500_ldo_amamic2 {
 						regulator-compatible = "ab8500_ldo_amamic2";
-						regulator-name = "V-AMIC2";
 					};
 
 					// supply for v-dmic; VDMIC LDO
 					ab8500_ldo_dmic_reg: ab8500_ldo_dmic {
 						regulator-compatible = "ab8500_ldo_dmic";
-						regulator-name = "V-DMIC";
 					};
 
 					// supply for U8500 CSI/DSI; VANA LDO
 					ab8500_ldo_ana_reg: ab8500_ldo_ana {
 						regulator-compatible = "ab8500_ldo_ana";
-						regulator-name = "V-CSI/DSI";
 					};
 				};
 			};
diff --git a/arch/arm/boot/dts/hrefv60plus.dts b/arch/arm/boot/dts/hrefv60plus.dts
index 32aba7e..b26d6ea 100644
--- a/arch/arm/boot/dts/hrefv60plus.dts
+++ b/arch/arm/boot/dts/hrefv60plus.dts
@@ -147,5 +147,137 @@
 		msp3: msp@80125000 {
 			status = "okay";
 		};
+
+		prcmu@80157000 {
+			db8500-prcmu-regulators {
+				db8500_vape_reg: db8500_vape {
+					regulator-name = "db8500-vape";
+				};
+
+				db8500_varm_reg: db8500_varm {
+					regulator-name = "db8500-varm";
+				};
+
+				db8500_vmodem_reg: db8500_vmodem {
+					regulator-name = "db8500-vmodem";
+				};
+
+				db8500_vpll_reg: db8500_vpll {
+					regulator-name = "db8500-vpll";
+				};
+
+				db8500_vsmps1_reg: db8500_vsmps1 {
+					regulator-name = "db8500-vsmps1";
+				};
+
+				db8500_vsmps2_reg: db8500_vsmps2 {
+					regulator-name = "db8500-vsmps2";
+				};
+
+				db8500_vsmps3_reg: db8500_vsmps3 {
+					regulator-name = "db8500-vsmps3";
+				};
+
+				db8500_vrf1_reg: db8500_vrf1 {
+					regulator-name = "db8500-vrf1";
+				};
+
+				db8500_sva_mmdsp_reg: db8500_sva_mmdsp {
+					regulator-name = "db8500-sva-mmdsp";
+				};
+
+				db8500_sva_mmdsp_ret_reg: db8500_sva_mmdsp_ret {
+					regulator-name = "db8500-sva-mmdsp-ret";
+				};
+
+				db8500_sva_pipe_reg: db8500_sva_pipe {
+					regulator-name = "db8500_sva_pipe";
+				};
+
+				db8500_sia_mmdsp_reg: db8500_sia_mmdsp {
+					regulator-name = "db8500_sia_mmdsp";
+				};
+
+				db8500_sia_mmdsp_ret_reg: db8500_sia_mmdsp_ret {
+					regulator-name = "db8500-sia-mmdsp-ret";
+				};
+
+				db8500_sia_pipe_reg: db8500_sia_pipe {
+					regulator-name = "db8500-sia-pipe";
+				};
+
+				db8500_sga_reg: db8500_sga {
+					regulator-name = "db8500-sga";
+				};
+
+				db8500_b2r2_mcde_reg: db8500_b2r2_mcde {
+					regulator-name = "db8500-b2r2-mcde";
+				};
+
+				db8500_esram12_reg: db8500_esram12 {
+					regulator-name = "db8500-esram12";
+				};
+
+				db8500_esram12_ret_reg: db8500_esram12_ret {
+					regulator-name = "db8500-esram12-ret";
+				};
+
+				db8500_esram34_reg: db8500_esram34 {
+					regulator-name = "db8500-esram34";
+				};
+
+				db8500_esram34_ret_reg: db8500_esram34_ret {
+					regulator-name = "db8500-esram34-ret";
+				};
+			};
+
+			ab8500@5 {
+				ab8500-regulators {
+					ab8500_ldo_aux1_reg: ab8500_ldo_aux1 {
+						regulator-name = "V-DISPLAY";
+					};
+
+					ab8500_ldo_aux2_reg: ab8500_ldo_aux2 {
+						regulator-name = "V-eMMC1";
+					};
+
+					ab8500_ldo_aux3_reg: ab8500_ldo_aux3 {
+						regulator-name = "V-MMC-SD";
+					};
+
+					ab8500_ldo_initcore_reg: ab8500_ldo_initcore {
+						regulator-name = "V-INTCORE";
+					};
+
+					ab8500_ldo_tvout_reg: ab8500_ldo_tvout {
+						regulator-name = "V-TVOUT";
+					};
+
+					ab8500_ldo_usb_reg: ab8500_ldo_usb {
+						regulator-name = "dummy";
+					};
+
+					ab8500_ldo_audio_reg: ab8500_ldo_audio {
+						regulator-name = "V-AUD";
+					};
+
+					ab8500_ldo_anamic1_reg: ab8500_ldo_anamic1 {
+						regulator-name = "V-AMIC1";
+					};
+
+					ab8500_ldo_amamic2_reg: ab8500_ldo_amamic2 {
+						regulator-name = "V-AMIC2";
+					};
+
+					ab8500_ldo_dmic_reg: ab8500_ldo_dmic {
+						regulator-name = "V-DMIC";
+					};
+
+					ab8500_ldo_ana_reg: ab8500_ldo_ana {
+						regulator-name = "V-CSI/DSI";
+					};
+				};
+			};
+		};
 	};
 };
diff --git a/arch/arm/boot/dts/snowball.dts b/arch/arm/boot/dts/snowball.dts
index 702c0ba..639b8e9 100644
--- a/arch/arm/boot/dts/snowball.dts
+++ b/arch/arm/boot/dts/snowball.dts
@@ -183,5 +183,137 @@
 				reg = <0x33>;
 			};
 		};
+
+		prcmu@80157000 {
+			db8500-prcmu-regulators {
+				db8500_vape_reg: db8500_vape {
+					regulator-name = "db8500-vape";
+				};
+
+				db8500_varm_reg: db8500_varm {
+					regulator-name = "db8500-varm";
+				};
+
+				db8500_vmodem_reg: db8500_vmodem {
+					regulator-name = "db8500-vmodem";
+				};
+
+				db8500_vpll_reg: db8500_vpll {
+					regulator-name = "db8500-vpll";
+				};
+
+				db8500_vsmps1_reg: db8500_vsmps1 {
+					regulator-name = "db8500-vsmps1";
+				};
+
+				db8500_vsmps2_reg: db8500_vsmps2 {
+					regulator-name = "db8500-vsmps2";
+				};
+
+				db8500_vsmps3_reg: db8500_vsmps3 {
+					regulator-name = "db8500-vsmps3";
+				};
+
+				db8500_vrf1_reg: db8500_vrf1 {
+					regulator-name = "db8500-vrf1";
+				};
+
+				db8500_sva_mmdsp_reg: db8500_sva_mmdsp {
+					regulator-name = "db8500-sva-mmdsp";
+				};
+
+				db8500_sva_mmdsp_ret_reg: db8500_sva_mmdsp_ret {
+					regulator-name = "db8500-sva-mmdsp-ret";
+				};
+
+				db8500_sva_pipe_reg: db8500_sva_pipe {
+					regulator-name = "db8500_sva_pipe";
+				};
+
+				db8500_sia_mmdsp_reg: db8500_sia_mmdsp {
+					regulator-name = "db8500_sia_mmdsp";
+				};
+
+				db8500_sia_mmdsp_ret_reg: db8500_sia_mmdsp_ret {
+					regulator-name = "db8500-sia-mmdsp-ret";
+				};
+
+				db8500_sia_pipe_reg: db8500_sia_pipe {
+					regulator-name = "db8500-sia-pipe";
+				};
+
+				db8500_sga_reg: db8500_sga {
+					regulator-name = "db8500-sga";
+				};
+
+				db8500_b2r2_mcde_reg: db8500_b2r2_mcde {
+					regulator-name = "db8500-b2r2-mcde";
+				};
+
+				db8500_esram12_reg: db8500_esram12 {
+					regulator-name = "db8500-esram12";
+				};
+
+				db8500_esram12_ret_reg: db8500_esram12_ret {
+					regulator-name = "db8500-esram12-ret";
+				};
+
+				db8500_esram34_reg: db8500_esram34 {
+					regulator-name = "db8500-esram34";
+				};
+
+				db8500_esram34_ret_reg: db8500_esram34_ret {
+					regulator-name = "db8500-esram34-ret";
+				};
+			};
+
+			ab8500@5 {
+				ab8500-regulators {
+					ab8500_ldo_aux1_reg: ab8500_ldo_aux1 {
+						regulator-name = "V-DISPLAY";
+					};
+
+					ab8500_ldo_aux2_reg: ab8500_ldo_aux2 {
+						regulator-name = "V-eMMC1";
+					};
+
+					ab8500_ldo_aux3_reg: ab8500_ldo_aux3 {
+						regulator-name = "V-MMC-SD";
+					};
+
+					ab8500_ldo_initcore_reg: ab8500_ldo_initcore {
+						regulator-name = "V-INTCORE";
+					};
+
+					ab8500_ldo_tvout_reg: ab8500_ldo_tvout {
+						regulator-name = "V-TVOUT";
+					};
+
+					ab8500_ldo_usb_reg: ab8500_ldo_usb {
+						regulator-name = "dummy";
+					};
+
+					ab8500_ldo_audio_reg: ab8500_ldo_audio {
+						regulator-name = "V-AUD";
+					};
+
+					ab8500_ldo_anamic1_reg: ab8500_ldo_anamic1 {
+						regulator-name = "V-AMIC1";
+					};
+
+					ab8500_ldo_amamic2_reg: ab8500_ldo_amamic2 {
+						regulator-name = "V-AMIC2";
+					};
+
+					ab8500_ldo_dmic_reg: ab8500_ldo_dmic {
+						regulator-name = "V-DMIC";
+					};
+
+					ab8500_ldo_ana_reg: ab8500_ldo_ana {
+						regulator-name = "V-CSI/DSI";
+					};
+				};
+			};
+		};
 	};
 };
-- 
1.7.9.5

