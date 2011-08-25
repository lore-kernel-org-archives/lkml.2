Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181Ab1HYXq1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 19:46:27 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:46211 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753552Ab1HYXoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 19:44:06 -0400
From: Stephen Warren <swarren@nvidia.com>
To: Grant Likely <grant.likely@secretlab.ca>, Colin Cross <ccross@android.com>,
        Erik Gilling <konkers@android.com>, Olof Johansson <olof@lixom.net>
Cc: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        devicetree-discuss@lists.ozlabs.org, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Belisko Marek <marek.belisko@gmail.com>,
        Jamie Iles <jamie@jamieiles.com>, Shawn Guo <shawn.guo@freescale.com>,
        Sergei Shtylyov <sshtylyov@mvista.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH v3 05/13] arm/dt: Tegra: Add pinmux node
Date: Thu, 25 Aug 2011 17:43:36 -0600
Message-Id: <1314315824-9687-6-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1314315824-9687-1-git-send-email-swarren@nvidia.com>
References: <1314315824-9687-1-git-send-email-swarren@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a pinmux node to tegra20.dtsi in order to instantiate the future
pinmux device. Add pinmux nodes to Harmony and Seaboard, which detail
the entire initial pinmux configuration. This configuration is identical
to that in board-harmony/seaboard-pinmux.c.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 arch/arm/boot/dts/tegra-harmony.dts  |  243 ++++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/tegra-seaboard.dts |  239 +++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/tegra20.dtsi       |    5 +
 3 files changed, 487 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/tegra-harmony.dts b/arch/arm/boot/dts/tegra-harmony.dts
index 2bbe559..a2b8dec 100644
--- a/arch/arm/boot/dts/tegra-harmony.dts
+++ b/arch/arm/boot/dts/tegra-harmony.dts
@@ -30,6 +30,249 @@
 		>;
 	};
 
+	pinmux: pinmux@70000000 {
+		nvidia,mux-groups {
+			ata {
+				pins = "ata";
+				function = "ide";
+			};
+			atb {
+				pins = "atb", "gma", "gme";
+				function = "sdio4";
+			};
+			atc {
+				pins = "atc";
+				function = "nand";
+			};
+			atd {
+				pins = "atd", "ate", "gmb", "gmd", "spia", "spib";
+				function = "gmi";
+			};
+			cdev1 {
+				pins = "cdev1";
+				function = "plla_out";
+			};
+			cdev2 {
+				pins = "cdev2";
+				function = "pllp_out4";
+				pull-down;
+				tristate;
+			};
+			ck32 {
+				pins = "ck32", "ddrc", "pmca", "pmcb", "pmcc", "pmcd", "pmce", "xm2c", "xm2d";
+				function = "none";
+			};
+			crtp {
+				pins = "crtp";
+				function = "crt";
+				tristate;
+			};
+			csus {
+				pins = "csus";
+				function = "vi_sensor_clk";
+				pull-down;
+				tristate;
+			};
+			dap1 {
+				pins = "dap1";
+				function = "dap1";
+			};
+			dap2 {
+				pins = "dap2";
+				function = "dap2";
+				tristate;
+			};
+			dap3 {
+				pins = "dap3";
+				function = "dap3";
+				tristate;
+			};
+			dap4 {
+				pins = "dap4";
+				function = "dap4";
+				tristate;
+			};
+			ddc {
+				pins = "ddc";
+				function = "i2c2";
+				pull-up;
+			};
+			dta {
+				pins = "dta", "dtd";
+				function = "sdio2";
+				pull-up;
+			};
+			dtb {
+				pins = "dtb";
+				function = "rsvd1";
+			};
+			dtc {
+				pins = "dtc", "dte";
+				function = "rsvd1";
+				tristate;
+			};
+			dtf {
+				pins = "dtf";
+				function = "i2c3";
+				tristate;
+			};
+			gmc {
+				pins = "gmc";
+				function = "uartd";
+			};
+			gpu {
+				pins = "gpu";
+				function = "gmi";
+				tristate;
+			};
+			gpu7 {
+				pins = "gpu7";
+				function = "rtck";
+			};
+			gpv {
+				pins = "gpv", "slxa", "slxk";
+				function = "pcie";
+				tristate;
+			};
+			hdint {
+				pins = "hdint";
+				function = "hdmi";
+				pull-up;
+				tristate;
+			};
+			i2cp {
+				pins = "i2cp", "rm";
+				function = "i2c";
+			};
+			irrx {
+				pins = "irrx", "irtx";
+				function = "uarta";
+				pull-up;
+				tristate;
+			};
+			kbca {
+				pins = "kbca", "kbcb", "kbcc", "kbcd", "kbce", "kbcf";
+				function = "kbc";
+				pull-up;
+			};
+			lcsn {
+				pins = "lcsn", "ldc", "lm1", "lpw1", "lsc1", "lsck", "lsda", "lsdi", "lvp0";
+				function = "displaya";
+				pull-up;
+				tristate;
+			};
+			ld0 {
+				pins = "ld0", "ld1", "ld10", "ld11", "ld12", "ld13", "ld14", "ld15", "ld16", "ld17", "ld2", "ld3", "ld4", "ld5", "ld6", "ld7", "ld8", "ld9", "ldi", "lhp0", "lhp1", "lhp2", "lpp", "lvp1";
+				function = "displaya";
+				pull-down;
+			};
+			lhs {
+				pins = "lhs", "lm0", "lpw0", "lpw2", "lsc0", "lspi", "lvs";
+				function = "displaya";
+				pull-up;
+			};
+			owc {
+				pins = "owc";
+				function = "rsvd2";
+				pull-up;
+				tristate;
+			};
+			pmc {
+				pins = "pmc";
+				function = "pwr_on";
+			};
+			pta {
+				pins = "pta";
+				function = "hdmi";
+			};
+			sdb {
+				pins = "sdb";
+				function = "pwm";
+				tristate;
+			};
+			sdc {
+				pins = "sdc";
+				function = "pwm";
+				pull-up;
+			};
+			sdd {
+				pins = "sdd";
+				function = "pwm";
+				pull-up;
+				tristate;
+			};
+			sdio1 {
+				pins = "sdio1";
+				function = "sdio1";
+				tristate;
+			};
+			slxc {
+				pins = "slxc", "slxd";
+				function = "spdif";
+				tristate;
+			};
+			spdi {
+				pins = "spdi", "spdo", "uac";
+				function = "rsvd2";
+				tristate;
+			};
+			spic {
+				pins = "spic";
+				function = "gmi";
+				pull-up;
+				tristate;
+			};
+			spid {
+				pins = "spid", "spif";
+				function = "spi1";
+				pull-down;
+				tristate;
+			};
+			spie {
+				pins = "spie";
+				function = "spi1";
+				pull-up;
+				tristate;
+			};
+			spig {
+				pins = "spig";
+				function = "spi2_alt";
+				tristate;
+			};
+			spih {
+				pins = "spih";
+				function = "spi2_alt";
+				pull-up;
+				tristate;
+			};
+			uaa {
+				pins = "uaa", "uab";
+				function = "ulpi";
+				pull-up;
+				tristate;
+			};
+			uad {
+				pins = "uad";
+				function = "irda";
+				pull-up;
+				tristate;
+			};
+			uca {
+				pins = "uca", "ucb";
+				function = "uartc";
+				pull-up;
+				tristate;
+			};
+			uda {
+				pins = "uda";
+				function = "ulpi";
+				tristate;
+			};
+		};
+		nvidia,drive-groups {
+		};
+	};
+
 	i2c@7000c000 {
 		clock-frequency = <400000>;
 
diff --git a/arch/arm/boot/dts/tegra-seaboard.dts b/arch/arm/boot/dts/tegra-seaboard.dts
index ec8f8cf..b0677b2 100644
--- a/arch/arm/boot/dts/tegra-seaboard.dts
+++ b/arch/arm/boot/dts/tegra-seaboard.dts
@@ -24,6 +24,245 @@
 		>;
 	};
 
+	pinmux: pinmux@70000000 {
+		nvidia,mux-groups {
+			ata {
+				pins = "ata";
+				function = "ide";
+			};
+			atb {
+				pins = "atb", "gma", "gme";
+				function = "sdio4";
+			};
+			atc {
+				pins = "atc";
+				function = "nand";
+			};
+			atd {
+				pins = "atd";
+				function = "gmi";
+			};
+			ate {
+				pins = "ate", "spib";
+				function = "gmi";
+				tristate;
+			};
+			cdev1 {
+				pins = "cdev1";
+				function = "plla_out";
+			};
+			cdev2 {
+				pins = "cdev2";
+				function = "pllp_out4";
+			};
+			ck32 {
+				pins = "ck32", "ddrc", "pmca", "pmcb", "pmcc", "pmcd", "pmce", "xm2c", "xm2d";
+				function = "none";
+			};
+			crtp {
+				pins = "crtp";
+				function = "crt";
+				pull-up;
+				tristate;
+			};
+			csus {
+				pins = "csus";
+				function = "vi_sensor_clk";
+				tristate;
+			};
+			dap1 {
+				pins = "dap1";
+				function = "dap1";
+			};
+			dap2 {
+				pins = "dap2";
+				function = "dap2";
+			};
+			dap3 {
+				pins = "dap3";
+				function = "dap3";
+				tristate;
+			};
+			dap4 {
+				pins = "dap4";
+				function = "dap4";
+			};
+			ddc {
+				pins = "ddc", "owc";
+				function = "rsvd2";
+				tristate;
+			};
+			dta {
+				pins = "dta", "dtb", "dtc", "dtd";
+				function = "vi";
+				pull-down;
+			};
+			dte {
+				pins = "dte";
+				function = "vi";
+				pull-down;
+				tristate;
+			};
+			dtf {
+				pins = "dtf";
+				function = "i2c3";
+			};
+			gmb {
+				pins = "gmb", "spia";
+				function = "gmi";
+				pull-up;
+				tristate;
+			};
+			gmc {
+				pins = "gmc";
+				function = "uartd";
+			};
+			gmd {
+				pins = "gmd";
+				function = "sflash";
+			};
+			gpu {
+				pins = "gpu";
+				function = "pwm";
+			};
+			gpu7 {
+				pins = "gpu7";
+				function = "rtck";
+			};
+			gpv {
+				pins = "gpv";
+				function = "pcie";
+				tristate;
+			};
+			hdint {
+				pins = "hdint", "lsc1", "lsck", "lsda";
+				function = "hdmi";
+				tristate;
+			};
+			i2cp {
+				pins = "i2cp", "rm";
+				function = "i2c";
+			};
+			irrx {
+				pins = "irrx", "irtx";
+				function = "uartb";
+			};
+			kbca {
+				pins = "kbca", "kbcb", "kbcc", "kbcd", "kbce", "kbcf";
+				function = "kbc";
+				pull-up;
+			};
+			lcsn {
+				pins = "lcsn", "ldc", "lpw1", "lsdi", "lvp0";
+				function = "rsvd4";
+				tristate;
+			};
+			ld0 {
+				pins = "ld0", "ld1", "ld10", "ld11", "ld12", "ld13", "ld14", "ld15", "ld16", "ld17", "ld2", "ld3", "ld4", "ld5", "ld6", "ld7", "ld8", "ld9", "ldi", "lhp0", "lhp1", "lhp2", "lhs", "lpp", "lsc0", "lspi", "lvp1", "lvs";
+				function = "displaya";
+			};
+			lm0 {
+				pins = "lm0";
+				function = "rsvd4";
+			};
+			lm1 {
+				pins = "lm1";
+				function = "crt";
+				tristate;
+			};
+			lpw0 {
+				pins = "lpw0", "lpw2", "pta";
+				function = "hdmi";
+			};
+			pmc {
+				pins = "pmc";
+				function = "pwr_on";
+			};
+			sdb {
+				pins = "sdb", "sdc", "sdd";
+				function = "sdio3";
+			};
+			sdio1 {
+				pins = "sdio1";
+				function = "sdio1";
+				pull-up;
+			};
+			slxa {
+				pins = "slxa";
+				function = "pcie";
+				pull-up;
+				tristate;
+			};
+			slxc {
+				pins = "slxc";
+				function = "spdif";
+				tristate;
+			};
+			slxd {
+				pins = "slxd";
+				function = "spdif";
+			};
+			slxk {
+				pins = "slxk";
+				function = "pcie";
+			};
+			spdi {
+				pins = "spdi", "spdo", "uac";
+				function = "rsvd2";
+			};
+			spic {
+				pins = "spic";
+				function = "gmi";
+				pull-up;
+			};
+			spid {
+				pins = "spid", "spie";
+				function = "spi1";
+				tristate;
+			};
+			spif {
+				pins = "spif";
+				function = "spi1";
+				pull-down;
+				tristate;
+			};
+			spig {
+				pins = "spig", "spih";
+				function = "spi2_alt";
+				pull-up;
+				tristate;
+			};
+			uaa {
+				pins = "uaa", "uab";
+				function = "ulpi";
+				pull-up;
+			};
+			uad {
+				pins = "uad";
+				function = "irda";
+			};
+			uca {
+				pins = "uca", "ucb";
+				function = "uartc";
+			};
+			uda {
+				pins = "uda";
+				function = "ulpi";
+			};
+		};
+		nvidia,drive-groups {
+			sdio1 {
+				pins = "sdio1";
+				nvidia,schmitt;
+				nvidia,drive-power = <3>;
+				nvidia,pull-down-strength = <31>;
+				nvidia,pull-up-strength = <31>;
+				nvidia,slew-rate-rising = <3>;
+				nvidia,slew-rate-falling = <3>;
+			};
+		};
+	};
+
 	serial@70006300 {
 		clock-frequency = < 216000000 >;
 	};
diff --git a/arch/arm/boot/dts/tegra20.dtsi b/arch/arm/boot/dts/tegra20.dtsi
index 5727595..5921c1d 100644
--- a/arch/arm/boot/dts/tegra20.dtsi
+++ b/arch/arm/boot/dts/tegra20.dtsi
@@ -77,6 +77,11 @@
 		gpio-controller;
 	};
 
+	pinmux: pinmux@70000000 {
+		compatible = "nvidia,tegra20-pinmux";
+		reg = < 0x70000000 0xc00 >;
+	};
+
 	serial@70006000 {
 		compatible = "nvidia,tegra20-uart";
 		reg = <0x70006000 0x40>;
-- 
1.7.0.4

