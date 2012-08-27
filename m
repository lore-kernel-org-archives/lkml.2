Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753683Ab2H0K1L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 06:27:11 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:5906 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753116Ab2H0K0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 06:26:31 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 27 Aug 2012 03:20:20 -0700
From: Wei Ni <wni@nvidia.com>
To: <swarren@wwwdotorg.org>, <brudley@broadcom.com>, <rvossen@broadcom.com>
CC: <krakesh@nvidia.com>, <ldewangan@nvidia.com>,
        <linux-tegra@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
        <brcm80211-dev-list@broadcom.com>, Wei Ni <wni@nvidia.com>
Subject: [PATCH 5/6] ARM: dt: t30 cardhu: set pinmux and power for wlan
Date: Mon, 27 Aug 2012 18:25:13 +0800
Message-ID: <1346063114-30361-6-git-send-email-wni@nvidia.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1346063114-30361-1-git-send-email-wni@nvidia.com>
References: <1346063114-30361-1-git-send-email-wni@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Configure pinmux as required for WiFi.
Enable the SDHCI1 controller. This is connectted to the WiFi module.
For now, always enable the regulator that provides power to the Wifi module.

Signed-off-by: Wei Ni <wni@nvidia.com>
---
 arch/arm/boot/dts/tegra30-cardhu.dtsi |   32 ++++++++++++++++++++++++++++++++
 1 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/tegra30-cardhu.dtsi b/arch/arm/boot/dts/tegra30-cardhu.dtsi
index 4794693..ed9b530 100644
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
 
@@ -292,6 +317,11 @@
 		bus-width = <4>;
 	};
 
+	sdhci@78000400 {
+		status = "okay";
+		power-gpios = <&gpio 28 0>; /* gpio PD4 */
+	};
+
 	sdhci@78000600 {
 		status = "okay";
 		bus-width = <8>;
@@ -407,6 +437,8 @@
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

