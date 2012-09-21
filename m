Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932340Ab2IUI50 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 04:57:26 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:16041 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932105Ab2IUI4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 04:56:08 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 21 Sep 2012 01:47:18 -0700
From: Wei Ni <wni@nvidia.com>
To: <swarren@wwwdotorg.org>
CC: <krakesh@nvidia.com>, <ldewangan@nvidia.com>,
        <linux-tegra@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Wei Ni <wni@nvidia.com>
Subject: [PATCH v2 4/5] ARM: dt: t30 cardhu: set pinmux and power for wlan
Date: Fri, 21 Sep 2012 16:54:59 +0800
Message-ID: <1348217700-12309-5-git-send-email-wni@nvidia.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1348217700-12309-1-git-send-email-wni@nvidia.com>
References: <1348217700-12309-1-git-send-email-wni@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Configure pinmux as required for WiFi.
Enable the SDHCI1 controller for a02 and a04 board, which is connected to the
WiFi module.
For now, always enable the regulator that provides power to the Wifi module.

Signed-off-by: Wei Ni <wni@nvidia.com>
---
 arch/arm/boot/dts/tegra30-cardhu-a02.dts |    6 ++++++
 arch/arm/boot/dts/tegra30-cardhu-a04.dts |    6 ++++++
 arch/arm/boot/dts/tegra30-cardhu.dtsi    |   27 +++++++++++++++++++++++++++
 3 files changed, 39 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/tegra30-cardhu-a02.dts b/arch/arm/boot/dts/tegra30-cardhu-a02.dts
index dd4222f..adc88aa 100644
--- a/arch/arm/boot/dts/tegra30-cardhu-a02.dts
+++ b/arch/arm/boot/dts/tegra30-cardhu-a02.dts
@@ -83,5 +83,11 @@
 			gpio = <&gpio 83 0>; /* GPIO PK3 */
 		};
 	};
+
+	sdhci@78000400 {
+		status = "okay";
+		power-gpios = <&gpio 28 0>; /* gpio PD4 */
+		bus-width = <4>;
+	};
 };
 
diff --git a/arch/arm/boot/dts/tegra30-cardhu-a04.dts b/arch/arm/boot/dts/tegra30-cardhu-a04.dts
index 0828f09..08163e1 100644
--- a/arch/arm/boot/dts/tegra30-cardhu-a04.dts
+++ b/arch/arm/boot/dts/tegra30-cardhu-a04.dts
@@ -95,4 +95,10 @@
 			gpio = <&gpio 232 0>; /* GPIO PDD0 */
 		};
 	};
+
+	sdhci@78000400 {
+		status = "okay";
+		power-gpios = <&gpio 27 0>; /* gpio PD3 */
+		bus-width = <4>;
+	};
 };
diff --git a/arch/arm/boot/dts/tegra30-cardhu.dtsi b/arch/arm/boot/dts/tegra30-cardhu.dtsi
index d10c9c5..4475750 100644
--- a/arch/arm/boot/dts/tegra30-cardhu.dtsi
+++ b/arch/arm/boot/dts/tegra30-cardhu.dtsi
@@ -52,6 +52,22 @@
 				nvidia,pull = <2>;
 				nvidia,tristate = <0>;
 			};
+			sdmmc3_clk_pa6 {
+				nvidia,pins = "sdmmc3_clk_pa6";
+				nvidia,function = "sdmmc3";
+				nvidia,pull = <0>;
+				nvidia,tristate = <0>;
+			};
+			sdmmc3_cmd_pa7 {
+				nvidia,pins =	"sdmmc3_cmd_pa7",
+						"sdmmc3_dat0_pb7",
+						"sdmmc3_dat1_pb6",
+						"sdmmc3_dat2_pb5",
+						"sdmmc3_dat3_pb4";
+				nvidia,function = "sdmmc3";
+				nvidia,pull = <2>;
+				nvidia,tristate = <0>;
+			};
 			sdmmc4_clk_pcc4 {
 				nvidia,pins =	"sdmmc4_clk_pcc4",
 						"sdmmc4_rst_n_pcc3";
@@ -81,6 +97,15 @@
 				nvidia,pull = <0>;
 				nvidia,tristate = <0>;
 			};
+			sdio3 {
+				nvidia,pins = "drive_sdio3";
+				nvidia,high-speed-mode = <0>;
+				nvidia,schmitt = <0>;
+				nvidia,pull-down-strength = <46>;
+				nvidia,pull-up-strength = <42>;
+				nvidia,slew-rate-rising = <1>;
+				nvidia,slew-rate-falling = <1>;
+			};
 		};
 	};
 
@@ -409,6 +434,8 @@
 			regulator-name = "vdd_com";
 			regulator-min-microvolt = <3300000>;
 			regulator-max-microvolt = <3300000>;
+			regulator-always-on;
+			regulator-boot-on;
 			enable-active-high;
 			gpio = <&gpio 24 0>; /* gpio PD0 */
 			vin-supply = <&sys_3v3_reg>;
-- 
1.7.1

