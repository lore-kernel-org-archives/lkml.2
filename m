Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261Ab2GDPMc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 11:12:32 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:7606 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718Ab2GDPM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 11:12:29 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 04 Jul 2012 08:12:27 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <swarren@nvidia.com>, <olof@lixom.net>
CC: <linux-kernel@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH] ARM: tegra: cardhu: add dt entry for PMIC TPS65911.
Date: Wed, 4 Jul 2012 20:37:59 +0530
Message-ID: <1341414479-6446-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tegra30 based platform "cardhu" have the power management
IC TPS65911 for the regulator.
Adding DT entry for this device.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
Enabling the gpio/regulators of this device.

 arch/arm/boot/dts/tegra30-cardhu.dts |  121 ++++++++++++++++++++++++++++++++++
 1 files changed, 121 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/tegra30-cardhu.dts b/arch/arm/boot/dts/tegra30-cardhu.dts
index c169bce..e769434 100644
--- a/arch/arm/boot/dts/tegra30-cardhu.dts
+++ b/arch/arm/boot/dts/tegra30-cardhu.dts
@@ -126,6 +126,127 @@
 			ti,vsel0-state-high;
 			ti,vsel1-state-high;
 		};
+
+		tps65911: tps65911@2d {
+			compatible = "ti,tps65911";
+			reg = <0x2d>;
+
+			#gpio-cells = <2>;
+			gpio-controller;
+
+			regulators {
+				#address-cells = <1>;
+				#size-cells = <0>;
+
+				vdd1_reg: regulator@0 {
+					reg = <0>;
+					regulator-compatible = "vdd1";
+					regulator-name = "vdd_1v2_gen";
+					regulator-min-microvolt = < 600000>;
+					regulator-max-microvolt = <1500000>;
+					regulator-always-on;
+					regulator-boot-on;
+				};
+
+				vdd2_reg: regulator@1 {
+					reg = <1>;
+					regulator-compatible = "vdd2";
+					regulator-name = "vdd_1v5_gen";
+					regulator-min-microvolt = < 600000>;
+					regulator-max-microvolt = <1500000>;
+					regulator-boot-on;
+					regulator-always-on;
+				};
+
+				vddctrl_reg: regulator@2 {
+					reg = <2>;
+					regulator-compatible = "vddctrl";
+					regulator-name = "vdd_1v0_gen";
+					regulator-min-microvolt = < 600000>;
+					regulator-max-microvolt = <1400000>;
+					regulator-always-on;
+					regulator-boot-on;
+				};
+
+				vio_reg: regulator@3 {
+					reg = <3>;
+					regulator-compatible = "vio";
+					regulator-name = "vdd_1v8_gen";
+					regulator-min-microvolt = <1800000>;
+					regulator-max-microvolt = <1800000>;
+					regulator-always-on;
+					regulator-boot-on;
+				};
+
+				ldo1_reg: regulator@4 {
+					reg = <4>;
+					regulator-compatible = "ldo1";
+					regulator-name = "vdd_pmu_ldo1";
+					regulator-min-microvolt = <1000000>;
+					regulator-max-microvolt = <3300000>;
+				};
+
+				ldo2_reg: regulator@5 {
+					reg = <5>;
+					regulator-compatible = "ldo2";
+					regulator-name = "vdd_pmu_ldo2";
+					regulator-min-microvolt = <1050000>;
+					regulator-max-microvolt = <1050000>;
+				};
+
+				ldo3_reg: regulator@6 {
+					reg = <6>;
+					regulator-compatible = "ldo3";
+					regulator-name = "vdd_pmu_ldo3";
+					regulator-min-microvolt = <1000000>;
+					regulator-max-microvolt = <3300000>;
+				};
+
+				ldo4_reg: regulator@7 {
+					reg = <7>;
+					regulator-compatible = "ldo4";
+					regulator-name = "vdd_pmu_ldo4";
+					regulator-min-microvolt = <1000000>;
+					regulator-max-microvolt = <3300000>;
+					regulator-always-on;
+				};
+
+				ldo5_reg: regulator@8 {
+					reg = <8>;
+					regulator-compatible = "ldo5";
+					regulator-name = "vdd_pmu_ldo5";
+					regulator-min-microvolt = <1000000>;
+					regulator-max-microvolt = <3300000>;
+				};
+
+				ldo6_reg: regulator@9 {
+					reg = <9>;
+					regulator-compatible = "ldo6";
+					regulator-name = "vdd_pmu_ldo6";
+					regulator-min-microvolt = <1200000>;
+					regulator-max-microvolt = <1200000>;
+				};
+
+				ldo7_reg: regulator@10 {
+					reg = <10>;
+					regulator-compatible = "ldo7";
+					regulator-name = "vdd_pmu_ldo7";
+					regulator-min-microvolt = <1200000>;
+					regulator-max-microvolt = <1200000>;
+					regulator-always-on;
+					regulator-boot-on;
+				};
+
+				ldo8_reg: regulator@11 {
+					reg = <11>;
+					regulator-compatible = "ldo8";
+					regulator-name = "vdd_pmu_ldo8";
+					regulator-min-microvolt = <1000000>;
+					regulator-max-microvolt = <3300000>;
+					regulator-always-on;
+				};
+			};
+		};
 	};
 
 	ahub {
-- 
1.7.1.1

