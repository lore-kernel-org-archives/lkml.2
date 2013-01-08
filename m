Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845Ab3AHIT4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 03:19:56 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:49104 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754564Ab3AHITy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 03:19:54 -0500
From: "Kumar, Anil" <anilkumar.v@ti.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>
CC: <linux@arm.linux.org.uk>, <nsekhar@ti.com>, <khilman@ti.com>, <hs@denx.de>
Subject: [PATCH V2 1/3] ARM: davinci: da850: add pinctrl driver entries
Date: Tue, 8 Jan 2013 13:50:18 +0530
Message-ID: <1357633220-29827-2-git-send-email-anilkumar.v@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1357633220-29827-1-git-send-email-anilkumar.v@ti.com>
References: <1357633220-29827-1-git-send-email-anilkumar.v@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For DT, DaVinci platform can use pinctrl-single driver for handling
padconf registers.

Enable PINCTRL Kconfig for MACH_DA8XX_DT platform. Add required
pinctrl DT entries in da850 dts file.

 Test procedure
  1)Populate DT file with NAND node information.
  2)Populate board DT file with pinmux information for NAND.
  3)Boot and confirm NAND is detected by the kernel.
  4)cat /proc/mtd to show partitions.

Signed-off-by: Kumar, Anil <anilkumar.v@ti.com>
---
:100644 100644 37dc5a3... c7609d0... M	arch/arm/boot/dts/da850-evm.dts
:100644 100644 fbada87... e9c6e82... M	arch/arm/boot/dts/da850.dtsi
:100644 100644 0153950... a075b3e... M	arch/arm/mach-davinci/Kconfig
 arch/arm/boot/dts/da850-evm.dts |    3 +++
 arch/arm/boot/dts/da850.dtsi    |   10 ++++++++++
 arch/arm/mach-davinci/Kconfig   |    1 +
 3 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/da850-evm.dts b/arch/arm/boot/dts/da850-evm.dts
index 37dc5a3..c7609d0 100644
--- a/arch/arm/boot/dts/da850-evm.dts
+++ b/arch/arm/boot/dts/da850-evm.dts
@@ -15,6 +15,9 @@
 	model = "DA850/AM1808/OMAP-L138 EVM";
 
 	soc {
+		pmx_core:pinmux@1c14120 {
+			status = "okay";
+		};
 		serial0: serial@1c42000 {
 			status = "okay";
 		};
diff --git a/arch/arm/boot/dts/da850.dtsi b/arch/arm/boot/dts/da850.dtsi
index fbada87..e9c6e82 100644
--- a/arch/arm/boot/dts/da850.dtsi
+++ b/arch/arm/boot/dts/da850.dtsi
@@ -29,6 +29,16 @@
 		#size-cells = <1>;
 		ranges = <0x0 0x01c00000 0x400000>;
 
+		pmx_core:pinmux@1c14120 {
+			compatible = "pinctrl-single";
+			reg = <0x14120 0x50>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+			pinctrl-single,bit-per-mux;
+			pinctrl-single,register-width = <32>;
+			pinctrl-single,function-mask = <0xffffffff>;
+			status = "disabled";
+		};
 		serial0: serial@1c42000 {
 			compatible = "ns16550a";
 			reg = <0x42000 0x100>;
diff --git a/arch/arm/mach-davinci/Kconfig b/arch/arm/mach-davinci/Kconfig
index 0153950..a075b3e 100644
--- a/arch/arm/mach-davinci/Kconfig
+++ b/arch/arm/mach-davinci/Kconfig
@@ -62,6 +62,7 @@ config MACH_DA8XX_DT
 	bool "Support DA8XX platforms using device tree"
 	default y
 	depends on ARCH_DAVINCI_DA8XX
+	select PINCTRL
 	help
 	  Say y here to include support for TI DaVinci DA850 based using
 	  Flattened Device Tree. More information at Documentation/devicetree
-- 
1.7.4.1

