Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382Ab1HOUas (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 16:30:48 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:50212 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231Ab1HOU3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 16:29:01 -0400
From: Stephen Warren <swarren@nvidia.com>
To: Grant Likely <grant.likely@secretlab.ca>, Colin Cross <ccross@android.com>,
        Erik Gilling <konkers@android.com>, Olof Johansson <olof@lixom.net>
Cc: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        devicetree-discuss@lists.ozlabs.org, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Belisko Marek <marek.belisko@gmail.com>,
        Jamie Iles <jamie@jamieiles.com>, Shawn Guo <shawn.guo@freescale.com>,
        Sergei Shtylyov <sshtylyov@mvista.com>,
        Stephen Warren <swarren@nvidia.com>
Subject: [RFC PATCH v2 07/13] arm/dt: Tegra: Add pinmux node
Date: Mon, 15 Aug 2011 14:28:14 -0600
Message-Id: <1313440100-17131-8-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1313440100-17131-1-git-send-email-swarren@nvidia.com>
References: <1313440100-17131-1-git-send-email-swarren@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a pinmux node to tegra20.dtsi in order to instantiate the future
pinmux device. Add pinmux nodes to Harmony and Seaboard, which detail
the entire initial pinmux configuration. This configuration is identical
to that in board-harmony/seaboard-pinmux.c.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 arch/arm/boot/dts/tegra-harmony.dts  |  468 ++++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/tegra-seaboard.dts |  413 ++++++++++++++++++++++++++++++
 arch/arm/boot/dts/tegra20.dtsi       |    5 +
 3 files changed, 886 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/tegra-harmony.dts b/arch/arm/boot/dts/tegra-harmony.dts
index d680707..e84a7fa 100644
--- a/arch/arm/boot/dts/tegra-harmony.dts
+++ b/arch/arm/boot/dts/tegra-harmony.dts
@@ -30,6 +30,474 @@
 		>;
 	};
 
+	pinmux: pinmux@70000000 {
+		nvidia,mux-groups {
+			ata {
+				nvidia,function = "ide";
+			};
+			atb {
+				nvidia,function = "sdio4";
+			};
+			atc {
+				nvidia,function = "nand";
+			};
+			atd {
+				nvidia,function = "gmi";
+			};
+			ate {
+				nvidia,function = "gmi";
+			};
+			cdev1 {
+				nvidia,function = "plla_out";
+			};
+			cdev2 {
+				nvidia,function = "pllp_out4";
+				nvidia,pull-down;
+				nvidia,tristate;
+			};
+			crtp {
+				nvidia,function = "crt";
+				nvidia,tristate;
+			};
+			csus {
+				nvidia,function = "vi_sensor_clk";
+				nvidia,pull-down;
+				nvidia,tristate;
+			};
+			dap1 {
+				nvidia,function = "dap1";
+			};
+			dap2 {
+				nvidia,function = "dap2";
+				nvidia,tristate;
+			};
+			dap3 {
+				nvidia,function = "dap3";
+				nvidia,tristate;
+			};
+			dap4 {
+				nvidia,function = "dap4";
+				nvidia,tristate;
+			};
+			ddc {
+				nvidia,function = "i2c2";
+				nvidia,pull-up;
+			};
+			dta {
+				nvidia,function = "sdio2";
+				nvidia,pull-up;
+			};
+			dtb {
+				nvidia,function = "rsvd1";
+			};
+			dtc {
+				nvidia,function = "rsvd1";
+				nvidia,tristate;
+			};
+			dtd {
+				nvidia,function = "sdio2";
+				nvidia,pull-up;
+			};
+			dte {
+				nvidia,function = "rsvd1";
+				nvidia,tristate;
+			};
+			dtf {
+				nvidia,function = "i2c3";
+				nvidia,tristate;
+			};
+			gma {
+				nvidia,function = "sdio4";
+			};
+			gmb {
+				nvidia,function = "gmi";
+			};
+			gmc {
+				nvidia,function = "uartd";
+			};
+			gmd {
+				nvidia,function = "gmi";
+			};
+			gme {
+				nvidia,function = "sdio4";
+			};
+			gpu {
+				nvidia,function = "gmi";
+				nvidia,tristate;
+			};
+			gpu7 {
+				nvidia,function = "rtck";
+			};
+			gpv {
+				nvidia,function = "pcie";
+				nvidia,tristate;
+			};
+			hdint {
+				nvidia,function = "hdmi";
+				nvidia,pull-up;
+				nvidia,tristate;
+			};
+			i2cp {
+				nvidia,function = "i2c";
+			};
+			irrx {
+				nvidia,function = "uarta";
+				nvidia,pull-up;
+				nvidia,tristate;
+			};
+			irtx {
+				nvidia,function = "uarta";
+				nvidia,pull-up;
+				nvidia,tristate;
+			};
+			kbca {
+				nvidia,function = "kbc";
+				nvidia,pull-up;
+			};
+			kbcb {
+				nvidia,function = "kbc";
+				nvidia,pull-up;
+			};
+			kbcc {
+				nvidia,function = "kbc";
+				nvidia,pull-up;
+			};
+			kbcd {
+				nvidia,function = "kbc";
+				nvidia,pull-up;
+			};
+			kbce {
+				nvidia,function = "kbc";
+				nvidia,pull-up;
+			};
+			kbcf {
+				nvidia,function = "kbc";
+				nvidia,pull-up;
+			};
+			lcsn {
+				nvidia,function = "displaya";
+				nvidia,pull-up;
+				nvidia,tristate;
+			};
+			ld0 {
+				nvidia,function = "displaya";
+				nvidia,pull-down;
+			};
+			ld1 {
+				nvidia,function = "displaya";
+				nvidia,pull-down;
+			};
+			ld10 {
+				nvidia,function = "displaya";
+				nvidia,pull-down;
+			};
+			ld11 {
+				nvidia,function = "displaya";
+				nvidia,pull-down;
+			};
+			ld12 {
+				nvidia,function = "displaya";
+				nvidia,pull-down;
+			};
+			ld13 {
+				nvidia,function = "displaya";
+				nvidia,pull-down;
+			};
+			ld14 {
+				nvidia,function = "displaya";
+				nvidia,pull-down;
+			};
+			ld15 {
+				nvidia,function = "displaya";
+				nvidia,pull-down;
+			};
+			ld16 {
+				nvidia,function = "displaya";
+				nvidia,pull-down;
+			};
+			ld17 {
+				nvidia,function = "displaya";
+				nvidia,pull-down;
+			};
+			ld2 {
+				nvidia,function = "displaya";
+				nvidia,pull-down;
+			};
+			ld3 {
+				nvidia,function = "displaya";
+				nvidia,pull-down;
+			};
+			ld4 {
+				nvidia,function = "displaya";
+				nvidia,pull-down;
+			};
+			ld5 {
+				nvidia,function = "displaya";
+				nvidia,pull-down;
+			};
+			ld6 {
+				nvidia,function = "displaya";
+				nvidia,pull-down;
+			};
+			ld7 {
+				nvidia,function = "displaya";
+				nvidia,pull-down;
+			};
+			ld8 {
+				nvidia,function = "displaya";
+				nvidia,pull-down;
+			};
+			ld9 {
+				nvidia,function = "displaya";
+				nvidia,pull-down;
+			};
+			ldc {
+				nvidia,function = "displaya";
+				nvidia,pull-up;
+				nvidia,tristate;
+			};
+			ldi {
+				nvidia,function = "displaya";
+				nvidia,pull-down;
+			};
+			lhp0 {
+				nvidia,function = "displaya";
+				nvidia,pull-down;
+			};
+			lhp1 {
+				nvidia,function = "displaya";
+				nvidia,pull-down;
+			};
+			lhp2 {
+				nvidia,function = "displaya";
+				nvidia,pull-down;
+			};
+			lhs {
+				nvidia,function = "displaya";
+				nvidia,pull-up;
+			};
+			lm0 {
+				nvidia,function = "displaya";
+				nvidia,pull-up;
+			};
+			lm1 {
+				nvidia,function = "displaya";
+				nvidia,pull-up;
+				nvidia,tristate;
+			};
+			lpp {
+				nvidia,function = "displaya";
+				nvidia,pull-down;
+			};
+			lpw0 {
+				nvidia,function = "displaya";
+				nvidia,pull-up;
+			};
+			lpw1 {
+				nvidia,function = "displaya";
+				nvidia,pull-up;
+				nvidia,tristate;
+			};
+			lpw2 {
+				nvidia,function = "displaya";
+				nvidia,pull-up;
+			};
+			lsc0 {
+				nvidia,function = "displaya";
+				nvidia,pull-up;
+			};
+			lsc1 {
+				nvidia,function = "displaya";
+				nvidia,pull-up;
+				nvidia,tristate;
+			};
+			lsck {
+				nvidia,function = "displaya";
+				nvidia,pull-up;
+				nvidia,tristate;
+			};
+			lsda {
+				nvidia,function = "displaya";
+				nvidia,pull-up;
+				nvidia,tristate;
+			};
+			lsdi {
+				nvidia,function = "displaya";
+				nvidia,pull-up;
+				nvidia,tristate;
+			};
+			lspi {
+				nvidia,function = "displaya";
+				nvidia,pull-up;
+			};
+			lvp0 {
+				nvidia,function = "displaya";
+				nvidia,pull-up;
+				nvidia,tristate;
+			};
+			lvp1 {
+				nvidia,function = "displaya";
+				nvidia,pull-down;
+			};
+			lvs {
+				nvidia,function = "displaya";
+				nvidia,pull-up;
+			};
+			owc {
+				nvidia,function = "rsvd2";
+				nvidia,pull-up;
+				nvidia,tristate;
+			};
+			pmc {
+				nvidia,function = "pwr_on";
+			};
+			pta {
+				nvidia,function = "hdmi";
+			};
+			rm {
+				nvidia,function = "i2c";
+			};
+			sdb {
+				nvidia,function = "pwm";
+				nvidia,tristate;
+			};
+			sdc {
+				nvidia,function = "pwm";
+				nvidia,pull-up;
+			};
+			sdd {
+				nvidia,function = "pwm";
+				nvidia,pull-up;
+				nvidia,tristate;
+			};
+			sdio1 {
+				nvidia,function = "sdio1";
+				nvidia,tristate;
+			};
+			slxa {
+				nvidia,function = "pcie";
+				nvidia,tristate;
+			};
+			slxc {
+				nvidia,function = "spdif";
+				nvidia,tristate;
+			};
+			slxd {
+				nvidia,function = "spdif";
+				nvidia,tristate;
+			};
+			slxk {
+				nvidia,function = "pcie";
+				nvidia,tristate;
+			};
+			spdi {
+				nvidia,function = "rsvd2";
+				nvidia,tristate;
+			};
+			spdo {
+				nvidia,function = "rsvd2";
+				nvidia,tristate;
+			};
+			spia {
+				nvidia,function = "gmi";
+			};
+			spib {
+				nvidia,function = "gmi";
+			};
+			spic {
+				nvidia,function = "gmi";
+				nvidia,pull-up;
+				nvidia,tristate;
+			};
+			spid {
+				nvidia,function = "spi1";
+				nvidia,pull-down;
+				nvidia,tristate;
+			};
+			spie {
+				nvidia,function = "spi1";
+				nvidia,pull-up;
+				nvidia,tristate;
+			};
+			spif {
+				nvidia,function = "spi1";
+				nvidia,pull-down;
+				nvidia,tristate;
+			};
+			spig {
+				nvidia,function = "spi2_alt";
+				nvidia,tristate;
+			};
+			spih {
+				nvidia,function = "spi2_alt";
+				nvidia,pull-up;
+				nvidia,tristate;
+			};
+			uaa {
+				nvidia,function = "ulpi";
+				nvidia,pull-up;
+				nvidia,tristate;
+			};
+			uab {
+				nvidia,function = "ulpi";
+				nvidia,pull-up;
+				nvidia,tristate;
+			};
+			uac {
+				nvidia,function = "rsvd2";
+				nvidia,tristate;
+			};
+			uad {
+				nvidia,function = "irda";
+				nvidia,pull-up;
+				nvidia,tristate;
+			};
+			uca {
+				nvidia,function = "uartc";
+				nvidia,pull-up;
+				nvidia,tristate;
+			};
+			ucb {
+				nvidia,function = "uartc";
+				nvidia,pull-up;
+				nvidia,tristate;
+			};
+			uda {
+				nvidia,function = "ulpi";
+				nvidia,tristate;
+			};
+			ck32 {
+				nvidia,function = "none";
+			};
+			ddrc {
+				nvidia,function = "none";
+			};
+			pmca {
+				nvidia,function = "none";
+			};
+			pmcb {
+				nvidia,function = "none";
+			};
+			pmcc {
+				nvidia,function = "none";
+			};
+			pmcd {
+				nvidia,function = "none";
+			};
+			pmce {
+				nvidia,function = "none";
+			};
+			xm2c {
+				nvidia,function = "none";
+			};
+			xm2d {
+				nvidia,function = "none";
+			};
+		};
+		nvidia,drive-groups {
+		};
+	};
+
 	i2c@7000c000 {
 		clock-frequency = <400000>;
 
diff --git a/arch/arm/boot/dts/tegra-seaboard.dts b/arch/arm/boot/dts/tegra-seaboard.dts
index 43c8b2c..29114b7 100644
--- a/arch/arm/boot/dts/tegra-seaboard.dts
+++ b/arch/arm/boot/dts/tegra-seaboard.dts
@@ -24,6 +24,419 @@
 		>;
 	};
 
+	pinmux: pinmux@70000000 {
+		nvidia,mux-groups {
+			ata {
+				nvidia,function = "ide";
+			};
+			atb {
+				nvidia,function = "sdio4";
+			};
+			atc {
+				nvidia,function = "nand";
+			};
+			atd {
+				nvidia,function = "gmi";
+			};
+			ate {
+				nvidia,function = "gmi";
+				nvidia,tristate;
+			};
+			cdev1 {
+				nvidia,function = "plla_out";
+			};
+			cdev2 {
+				nvidia,function = "pllp_out4";
+			};
+			crtp {
+				nvidia,function = "crt";
+				nvidia,pull-up;
+				nvidia,tristate;
+			};
+			csus {
+				nvidia,function = "vi_sensor_clk";
+				nvidia,tristate;
+			};
+			dap1 {
+				nvidia,function = "dap1";
+			};
+			dap2 {
+				nvidia,function = "dap2";
+			};
+			dap3 {
+				nvidia,function = "dap3";
+				nvidia,tristate;
+			};
+			dap4 {
+				nvidia,function = "dap4";
+			};
+			ddc {
+				nvidia,function = "rsvd2";
+				nvidia,tristate;
+			};
+			dta {
+				nvidia,function = "vi";
+				nvidia,pull-down;
+			};
+			dtb {
+				nvidia,function = "vi";
+				nvidia,pull-down;
+			};
+			dtc {
+				nvidia,function = "vi";
+				nvidia,pull-down;
+			};
+			dtd {
+				nvidia,function = "vi";
+				nvidia,pull-down;
+			};
+			dte {
+				nvidia,function = "vi";
+				nvidia,pull-down;
+				nvidia,tristate;
+			};
+			dtf {
+				nvidia,function = "i2c3";
+			};
+			gma {
+				nvidia,function = "sdio4";
+			};
+			gmb {
+				nvidia,function = "gmi";
+				nvidia,pull-up;
+				nvidia,tristate;
+			};
+			gmc {
+				nvidia,function = "uartd";
+			};
+			gmd {
+				nvidia,function = "sflash";
+			};
+			gme {
+				nvidia,function = "sdio4";
+			};
+			gpu {
+				nvidia,function = "pwm";
+			};
+			gpu7 {
+				nvidia,function = "rtck";
+			};
+			gpv {
+				nvidia,function = "pcie";
+				nvidia,tristate;
+			};
+			hdint {
+				nvidia,function = "hdmi";
+				nvidia,tristate;
+			};
+			i2cp {
+				nvidia,function = "i2c";
+			};
+			irrx {
+				nvidia,function = "uartb";
+			};
+			irtx {
+				nvidia,function = "uartb";
+			};
+			kbca {
+				nvidia,function = "kbc";
+				nvidia,pull-up;
+			};
+			kbcb {
+				nvidia,function = "kbc";
+				nvidia,pull-up;
+			};
+			kbcc {
+				nvidia,function = "kbc";
+				nvidia,pull-up;
+			};
+			kbcd {
+				nvidia,function = "kbc";
+				nvidia,pull-up;
+			};
+			kbce {
+				nvidia,function = "kbc";
+				nvidia,pull-up;
+			};
+			kbcf {
+				nvidia,function = "kbc";
+				nvidia,pull-up;
+			};
+			lcsn {
+				nvidia,function = "rsvd4";
+				nvidia,tristate;
+			};
+			ld0 {
+				nvidia,function = "displaya";
+			};
+			ld1 {
+				nvidia,function = "displaya";
+			};
+			ld10 {
+				nvidia,function = "displaya";
+			};
+			ld11 {
+				nvidia,function = "displaya";
+			};
+			ld12 {
+				nvidia,function = "displaya";
+			};
+			ld13 {
+				nvidia,function = "displaya";
+			};
+			ld14 {
+				nvidia,function = "displaya";
+			};
+			ld15 {
+				nvidia,function = "displaya";
+			};
+			ld16 {
+				nvidia,function = "displaya";
+			};
+			ld17 {
+				nvidia,function = "displaya";
+			};
+			ld2 {
+				nvidia,function = "displaya";
+			};
+			ld3 {
+				nvidia,function = "displaya";
+			};
+			ld4 {
+				nvidia,function = "displaya";
+			};
+			ld5 {
+				nvidia,function = "displaya";
+			};
+			ld6 {
+				nvidia,function = "displaya";
+			};
+			ld7 {
+				nvidia,function = "displaya";
+			};
+			ld8 {
+				nvidia,function = "displaya";
+			};
+			ld9 {
+				nvidia,function = "displaya";
+			};
+			ldc {
+				nvidia,function = "rsvd4";
+				nvidia,tristate;
+			};
+			ldi {
+				nvidia,function = "displaya";
+			};
+			lhp0 {
+				nvidia,function = "displaya";
+			};
+			lhp1 {
+				nvidia,function = "displaya";
+			};
+			lhp2 {
+				nvidia,function = "displaya";
+			};
+			lhs {
+				nvidia,function = "displaya";
+			};
+			lm0 {
+				nvidia,function = "rsvd4";
+			};
+			lm1 {
+				nvidia,function = "crt";
+				nvidia,tristate;
+			};
+			lpp {
+				nvidia,function = "displaya";
+			};
+			lpw0 {
+				nvidia,function = "hdmi";
+			};
+			lpw1 {
+				nvidia,function = "rsvd4";
+				nvidia,tristate;
+			};
+			lpw2 {
+				nvidia,function = "hdmi";
+			};
+			lsc0 {
+				nvidia,function = "displaya";
+			};
+			lsc1 {
+				nvidia,function = "hdmi";
+				nvidia,tristate;
+			};
+			lsck {
+				nvidia,function = "hdmi";
+				nvidia,tristate;
+			};
+			lsda {
+				nvidia,function = "hdmi";
+				nvidia,tristate;
+			};
+			lsdi {
+				nvidia,function = "rsvd4";
+				nvidia,tristate;
+			};
+			lspi {
+				nvidia,function = "displaya";
+			};
+			lvp0 {
+				nvidia,function = "rsvd4";
+				nvidia,tristate;
+			};
+			lvp1 {
+				nvidia,function = "displaya";
+			};
+			lvs {
+				nvidia,function = "displaya";
+			};
+			owc {
+				nvidia,function = "rsvd2";
+				nvidia,tristate;
+			};
+			pmc {
+				nvidia,function = "pwr_on";
+			};
+			pta {
+				nvidia,function = "hdmi";
+			};
+			rm {
+				nvidia,function = "i2c";
+			};
+			sdb {
+				nvidia,function = "sdio3";
+			};
+			sdc {
+				nvidia,function = "sdio3";
+			};
+			sdd {
+				nvidia,function = "sdio3";
+			};
+			sdio1 {
+				nvidia,function = "sdio1";
+				nvidia,pull-up;
+			};
+			slxa {
+				nvidia,function = "pcie";
+				nvidia,pull-up;
+				nvidia,tristate;
+			};
+			slxc {
+				nvidia,function = "spdif";
+				nvidia,tristate;
+			};
+			slxd {
+				nvidia,function = "spdif";
+			};
+			slxk {
+				nvidia,function = "pcie";
+			};
+			spdi {
+				nvidia,function = "rsvd2";
+			};
+			spdo {
+				nvidia,function = "rsvd2";
+			};
+			spia {
+				nvidia,function = "gmi";
+				nvidia,pull-up;
+				nvidia,tristate;
+			};
+			spib {
+				nvidia,function = "gmi";
+				nvidia,tristate;
+			};
+			spic {
+				nvidia,function = "gmi";
+				nvidia,pull-up;
+			};
+			spid {
+				nvidia,function = "spi1";
+				nvidia,tristate;
+			};
+			spie {
+				nvidia,function = "spi1";
+				nvidia,tristate;
+			};
+			spif {
+				nvidia,function = "spi1";
+				nvidia,pull-down;
+				nvidia,tristate;
+			};
+			spig {
+				nvidia,function = "spi2_alt";
+				nvidia,pull-up;
+				nvidia,tristate;
+			};
+			spih {
+				nvidia,function = "spi2_alt";
+				nvidia,pull-up;
+				nvidia,tristate;
+			};
+			uaa {
+				nvidia,function = "ulpi";
+				nvidia,pull-up;
+			};
+			uab {
+				nvidia,function = "ulpi";
+				nvidia,pull-up;
+			};
+			uac {
+				nvidia,function = "rsvd2";
+			};
+			uad {
+				nvidia,function = "irda";
+			};
+			uca {
+				nvidia,function = "uartc";
+			};
+			ucb {
+				nvidia,function = "uartc";
+			};
+			uda {
+				nvidia,function = "ulpi";
+			};
+			ck32 {
+				nvidia,function = "none";
+			};
+			ddrc {
+				nvidia,function = "none";
+			};
+			pmca {
+				nvidia,function = "none";
+			};
+			pmcb {
+				nvidia,function = "none";
+			};
+			pmcc {
+				nvidia,function = "none";
+			};
+			pmcd {
+				nvidia,function = "none";
+			};
+			pmce {
+				nvidia,function = "none";
+			};
+			xm2c {
+				nvidia,function = "none";
+			};
+			xm2d {
+				nvidia,function = "none";
+			};
+		};
+		nvidia,drive-groups {
+			sdio1 {
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

