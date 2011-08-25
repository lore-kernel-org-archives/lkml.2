Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581Ab1HYXoH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 19:44:07 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:52207 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753542Ab1HYXoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 19:44:04 -0400
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
Subject: [PATCH v3 04/13] docs/dt: Document nvidia,tegra20-pinmux binding
Date: Thu, 25 Aug 2011 17:43:35 -0600
Message-Id: <1314315824-9687-5-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1314315824-9687-1-git-send-email-swarren@nvidia.com>
References: <1314315824-9687-1-git-send-email-swarren@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 .../devicetree/bindings/pinmux/pinmux_nvidia.txt   |  302 ++++++++++++++++++++
 1 files changed, 302 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/pinmux/pinmux_nvidia.txt

diff --git a/Documentation/devicetree/bindings/pinmux/pinmux_nvidia.txt b/Documentation/devicetree/bindings/pinmux/pinmux_nvidia.txt
new file mode 100644
index 0000000..4a7e082
--- /dev/null
+++ b/Documentation/devicetree/bindings/pinmux/pinmux_nvidia.txt
@@ -0,0 +1,302 @@
+NVIDIA Tegra 2 pinmux controller
+
+Required properties:
+- compatible : "nvidia,tegra20-pinmux"
+
+Optional sub-nodes:
+- nvidia,mux-groups : Mux group settings; see below.
+- nvidia,drive-groups : Drive group settings; see below.
+
+nvidia,mux-groups sub-node:
+
+Each desired configuration of a pin group, or a set of pin groups, should be
+represented as a sub-node of the nvidia,mux-groups node. The name of the
+sub-node has no meaning.
+
+Required subnode-properties:
+- pins : An array of strings. Each string contains the name of a mux pingroup.
+    Valid values for pingroup names are listed below.
+- function : A string containing the name of the pinmux function to mux to the
+  pingroup. Valid values for function names are listed below. See the Tegra
+  TRM to determine which are valid for each pingroup:
+
+Valid pin group names for muxing are:
+
+	ata
+	atb
+	atc
+	atd
+	ate
+	cdev1
+	cdev2
+	crtp
+	csus
+	dap1
+	dap2
+	dap3
+	dap4
+	ddc
+	dta
+	dtb
+	dtc
+	dtd
+	dte
+	dtf
+	gma
+	gmb
+	gmc
+	gmd
+	gme
+	gpu
+	gpu7
+	gpv
+	hdint
+	i2cp
+	irrx
+	irtx
+	kbca
+	kbcb
+	kbcc
+	kbcd
+	kbce
+	kbcf
+	lcsn
+	ld0
+	ld1
+	ld10
+	ld11
+	ld12
+	ld13
+	ld14
+	ld15
+	ld16
+	ld17
+	ld2
+	ld3
+	ld4
+	ld5
+	ld6
+	ld7
+	ld8
+	ld9
+	ldc
+	ldi
+	lhp0
+	lhp1
+	lhp2
+	lhs
+	lm0
+	lm1
+	lpp
+	lpw0
+	lpw1
+	lpw2
+	lsc0
+	lsc1
+	lsck
+	lsda
+	lsdi
+	lspi
+	lvp0
+	lvp1
+	lvs
+	owc
+	pmc
+	pta
+	rm
+	sdb
+	sdc
+	sdd
+	sdio1
+	slxa
+	slxc
+	slxd
+	slxk
+	spdi
+	spdo
+	spia
+	spib
+	spic
+	spid
+	spie
+	spif
+	spig
+	spih
+	uaa
+	uab
+	uac
+	uad
+	uca
+	ucb
+	uda
+	ck32
+	ddrc
+	pmca
+	pmcb
+	pmcc
+	pmcd
+	pmce
+	xm2c
+	xm2d
+
+Valid function names are:
+
+	none (used for pingroups without muxing functionality)
+	ahb_clk
+	apb_clk
+	audio_sync
+	crt
+	dap1
+	dap2
+	dap3
+	dap4
+	dap5
+	displaya
+	displayb
+	emc_test0_dll
+	emc_test1_dll
+	gmi
+	gmi_int
+	hdmi
+	i2c
+	i2c2
+	i2c3
+	ide
+	irda
+	kbc
+	mio
+	mipi_hs
+	nand
+	osc
+	owr
+	pcie
+	plla_out
+	pllc_out1
+	pllm_out1
+	pllp_out2
+	pllp_out3
+	pllp_out4
+	pwm
+	pwr_intr
+	pwr_on
+	rtck
+	sdio1
+	sdio2
+	sdio3
+	sdio4
+	sflash
+	spdif
+	spi1
+	spi2
+	spi2_alt
+	spi3
+	spi4
+	trace
+	twc
+	uarta
+	uartb
+	uartc
+	uartd
+	uarte
+	ulpi
+	vi
+	vi_sensor_clk
+	xio
+
+Optional subnode-properties:
+- pull-up : Boolean, apply Tegra's internal pull-up to the pin.
+- pull-down : Boolean, apply Tegra's internal pull-down to the pin.
+- tristate : Boolean, tristate the pin. Otherwise, drive it.
+
+If both pull-up and pull-down are specified, pull-up takes precedence.
+
+nvidia,drive-groups sub-node:
+
+Each desired configuration of a pin group, or a set of pin groups, should be
+represented as a sub-node of the nvidia,drive-groups node. The name of the
+sub-node has no meaning.
+
+Required subnode-properties:
+- pins : An array of strings. Each string contains the name of a mux pingroup.
+    Valid values for pingroup names are listed below.
+- nvidia,high-speed-mode : Boolean, enable high speed mode the pins.
+- nvidia,schmitt : Boolean, enables Schmitt Trigger on the input.
+- nvidia,drive-power : Integer, valid values 0-3. 0 is least power, 3 is
+    most power. Controls the drive power or current. See "Low Power Mode"
+    or "LPMD1" and "LPMD0" in the Tegra TRM.
+- nvidia,pull-down-strength : Integer, valid values 0-31. Controls drive
+    strength. See "CAL_DRVDN" in the Tegra TRM.
+- nvidia,pull-up-strength : Integer, valid values 0-31. Controls drive
+    strength. See "CAL_DRVUP" in the Tegra TRM.
+- nvidia,slew_rate-rising : Integer, valid values 0-3. 0 is fastest, 3 is
+    slowest. See "DRVUP_SLWR" in the Tegra TRM.
+- nvidia,slew_rate-falling : Integer, valid values 0-3. 0 is fastest, 3 is
+    slowest. See "DRVDN_SLWR" in the Tegra TRM.
+
+Valid pin group names for drive configuration are:
+
+	ao1
+	ao2
+	at1
+	at2
+	cdev1
+	cdev2
+	csus
+	dap1
+	dap2
+	dap3
+	dap4
+	dbg
+	lcd1
+	lcd2
+	sdmmc2
+	sdmmc3
+	spi
+	uaa
+	uab
+	uart2
+	uart3
+	vi1
+	vi2
+	xm2a
+	xm2c
+	xm2d
+	xm2clk
+	memcomp
+	sdio1
+	crt
+	ddc
+	gma
+	gmb
+	gmc
+	gmd
+	gme
+	owr
+	uad
+
+Example of a pinmux-controller node:
+
+	pinmux: pinmux@70000000 {
+		compatible = "nvidia,tegra20-pinmux";
+		reg = < 0x70000000 0xc00 >;
+		nvidia,mux-groups {
+			lcsn {
+				pins = "lcsn", "ldc", "lm1", "lpw1", "lsc1";
+				function = "displaya";
+				pull-up;
+				tristate;
+			};
+		};
+		nvidia,drive-groups {
+			sdio1 {
+				pins = "sdio1";
+				nvidia,schmitt;
+				nvidia,drive-power = <1>;
+				nvidia,pull-down-strength = <31>;
+				nvidia,pull-up-strength = <31>;
+				nvidia,slew-rate-rising = <3>;
+				nvidia,slew-rate-falling = <3>;
+			};
+		};
+	};
+
-- 
1.7.0.4

