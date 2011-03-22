Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505Ab1CVI2S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 04:28:18 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:35700 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755332Ab1CVI1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 04:27:41 -0400
X-Auth-Info: tYa63Ui8hUkKhj3DzebrSF+WdrmqYeRkAwwB06olvbA=
From: Heiko Schocher <hs@denx.de>
To: linuxppc-dev@lists.ozlabs.org
Cc: Heiko Schocher <hs@denx.de>, Wolfram Sang <w.sang@pengutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-fbdev@vger.kernel.org, devicetree-discuss@ozlabs.org,
        Ben Dooks <ben@simtec.co.uk>, Vincent Sanders <vince@simtec.co.uk>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>, Wolfgang Denk <wd@denx.de>,
        Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH v1 1/6] powerpc, 5200: add support for charon board
Date: Tue, 22 Mar 2011 09:27:27 +0100
Message-Id: <1300782452-528-2-git-send-email-hs@denx.de>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1300782452-528-1-git-send-email-hs@denx.de>
References: <1291451028-22532-1-git-send-email-hs@denx.de>
 <1300782452-528-1-git-send-email-hs@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Heiko Schocher <hs@denx.de>
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Wolfram Sang <w.sang@pengutronix.de>
cc: Grant Likely <grant.likely@secretlab.ca>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: linux-fbdev@vger.kernel.org
cc: devicetree-discuss@ozlabs.org
cc: Ben Dooks <ben@simtec.co.uk>
cc: Vincent Sanders <vince@simtec.co.uk>
cc: Samuel Ortiz <sameo@linux.intel.com>
cc: linux-kernel@vger.kernel.org
cc: Randy Dunlap <rdunlap@xenotime.net>
cc: Wolfgang Denk <wd@denx.de>
cc: Paul Mundt <lethal@linux-sh.org>
---
- changes since v1:
  add comments from Wolfram Sang
  - no defconfig file
  - comment corrected in DTS
  - boardlist sorted alphabetically
  - commit log without boardinfo
- changes for v6:
  - rebased against current head
  - repost complete patchserie
  - added Acked-by from Benjamin Herrenschmidt

 arch/powerpc/boot/dts/charon.dts             |  226 ++++++++++++++++++++++++++
 arch/powerpc/platforms/52xx/mpc5200_simple.c |    1 +
 2 files changed, 227 insertions(+), 0 deletions(-)
 create mode 100644 arch/powerpc/boot/dts/charon.dts

diff --git a/arch/powerpc/boot/dts/charon.dts b/arch/powerpc/boot/dts/charon.dts
new file mode 100644
index 0000000..9776889
--- /dev/null
+++ b/arch/powerpc/boot/dts/charon.dts
@@ -0,0 +1,226 @@
+/*
+ * charon board Device Tree Source
+ *
+ * Copyright (C) 2007 Semihalf
+ * Marian Balakowicz <m8@semihalf.com>
+ *
+ * Copyright (C) 2010 DENX Software Engineering GmbH
+ * Heiko Schocher <hs@denx.de>
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+/dts-v1/;
+
+/ {
+	model = "anon,charon";
+	compatible = "anon,charon";
+	#address-cells = <1>;
+	#size-cells = <1>;
+	interrupt-parent = <&mpc5200_pic>;
+
+	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		PowerPC,5200@0 {
+			device_type = "cpu";
+			reg = <0>;
+			d-cache-line-size = <32>;
+			i-cache-line-size = <32>;
+			d-cache-size = <0x4000>;	// L1, 16K
+			i-cache-size = <0x4000>;	// L1, 16K
+			timebase-frequency = <0>;	// from bootloader
+			bus-frequency = <0>;		// from bootloader
+			clock-frequency = <0>;		// from bootloader
+		};
+	};
+
+	memory {
+		device_type = "memory";
+		reg = <0x00000000 0x08000000>;	// 128MB
+	};
+
+	soc5200@f0000000 {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		compatible = "fsl,mpc5200-immr";
+		ranges = <0 0xf0000000 0x0000c000>;
+		reg = <0xf0000000 0x00000100>;
+		bus-frequency = <0>;		// from bootloader
+		system-frequency = <0>;		// from bootloader
+
+		cdm@200 {
+			compatible = "fsl,mpc5200-cdm";
+			reg = <0x200 0x38>;
+		};
+
+		mpc5200_pic: interrupt-controller@500 {
+			// 5200 interrupts are encoded into two levels;
+			interrupt-controller;
+			#interrupt-cells = <3>;
+			compatible = "fsl,mpc5200-pic";
+			reg = <0x500 0x80>;
+		};
+
+		timer@600 {	// General Purpose Timer
+			compatible = "fsl,mpc5200-gpt";
+			reg = <0x600 0x10>;
+			interrupts = <1 9 0>;
+			fsl,has-wdt;
+		};
+
+		can@900 {
+			compatible = "fsl,mpc5200-mscan";
+			interrupts = <2 17 0>;
+			reg = <0x900 0x80>;
+		};
+
+		can@980 {
+			compatible = "fsl,mpc5200-mscan";
+			interrupts = <2 18 0>;
+			reg = <0x980 0x80>;
+		};
+
+		gpio_simple: gpio@b00 {
+			compatible = "fsl,mpc5200-gpio";
+			reg = <0xb00 0x40>;
+			interrupts = <1 7 0>;
+			gpio-controller;
+			#gpio-cells = <2>;
+		};
+
+		usb@1000 {
+			compatible = "fsl,mpc5200-ohci","ohci-be";
+			reg = <0x1000 0xff>;
+			interrupts = <2 6 0>;
+		};
+
+		dma-controller@1200 {
+			device_type = "dma-controller";
+			compatible = "fsl,mpc5200-bestcomm";
+			reg = <0x1200 0x80>;
+			interrupts = <3 0 0  3 1 0  3 2 0  3 3 0
+			              3 4 0  3 5 0  3 6 0  3 7 0
+			              3 8 0  3 9 0  3 10 0  3 11 0
+			              3 12 0  3 13 0  3 14 0  3 15 0>;
+		};
+
+		xlb@1f00 {
+			compatible = "fsl,mpc5200-xlb";
+			reg = <0x1f00 0x100>;
+		};
+
+		serial@2000 {		// PSC1
+			compatible = "fsl,mpc5200-psc-uart";
+			reg = <0x2000 0x100>;
+			interrupts = <2 1 0>;
+		};
+
+		serial@2400 {		// PSC3
+			compatible = "fsl,mpc5200-psc-uart";
+			reg = <0x2400 0x100>;
+			interrupts = <2 3 0>;
+		};
+
+		ethernet@3000 {
+			compatible = "fsl,mpc5200-fec";
+			reg = <0x3000 0x400>;
+			local-mac-address = [ 00 00 00 00 00 00 ];
+			interrupts = <2 5 0>;
+			fixed-link = <1 1 100 0 0>;
+		};
+
+		mdio@3000 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			compatible = "fsl,mpc5200-mdio";
+			reg = <0x3000 0x400>;       // fec range, since we need to setup fec interrupts
+			interrupts = <2 5 0>;   // these are for "mii command finished", not link changes & co.
+		};
+
+		ata@3a00 {
+			compatible = "fsl,mpc5200-ata";
+			reg = <0x3a00 0x100>;
+			interrupts = <2 7 0>;
+		};
+
+		i2c@3d00 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			compatible = "fsl,mpc5200-i2c","fsl-i2c";
+			reg = <0x3d00 0x40>;
+			interrupts = <2 15 0>;
+		};
+
+
+		i2c@3d40 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			compatible = "fsl,mpc5200-i2c","fsl-i2c";
+			reg = <0x3d40 0x40>;
+			interrupts = <2 16 0>;
+
+			dtt@28 {
+				compatible = "national,lm80";
+				reg = <0x28>;
+			};
+
+			rtc@68 {
+				compatible = "dallas,ds1374";
+				reg = <0x68>;
+			};
+		};
+
+		sram@8000 {
+			compatible = "fsl,mpc5200-sram";
+			reg = <0x8000 0x4000>;
+		};
+	};
+
+	localbus {
+		compatible = "fsl,mpc5200-lpb","simple-bus";
+		#address-cells = <2>;
+		#size-cells = <1>;
+		ranges = <	0 0 0xfc000000 0x02000000
+				3 0 0xe8000000 0x00080000>;
+
+		flash@0,0 {
+			compatible = "cfi-flash";
+			reg = <0 0 0x02000000>;
+			bank-width = <4>;
+			device-width = <2>;
+			#size-cells = <1>;
+			#address-cells = <1>;
+		};
+
+		mram0@3,0 {
+			compatible = "mtd-ram";
+			reg = <3 0x00000 0x80000>;
+			bank-width = <1>;
+		};
+	};
+
+	pci@f0000d00 {
+		#interrupt-cells = <1>;
+		#size-cells = <2>;
+		#address-cells = <3>;
+		device_type = "pci";
+		compatible = "fsl,mpc5200-pci";
+		reg = <0xf0000d00 0x100>;
+		interrupt-map-mask = <0xf800 0 0 7>;
+		interrupt-map = <0xc000 0 0 1 &mpc5200_pic 0 0 3
+				 0xc000 0 0 2 &mpc5200_pic 0 0 3
+				 0xc000 0 0 3 &mpc5200_pic 0 0 3
+				 0xc000 0 0 4 &mpc5200_pic 0 0 3>;
+		clock-frequency = <0>; // From boot loader
+		interrupts = <2 8 0 2 9 0 2 10 0>;
+		bus-range = <0 0>;
+		ranges = <0x42000000 0 0x80000000 0x80000000 0 0x10000000
+			  0x02000000 0 0x90000000 0x90000000 0 0x10000000
+			  0x01000000 0 0x00000000 0xa0000000 0 0x01000000>;
+	};
+};
diff --git a/arch/powerpc/platforms/52xx/mpc5200_simple.c b/arch/powerpc/platforms/52xx/mpc5200_simple.c
index e36d6e2..846b789 100644
--- a/arch/powerpc/platforms/52xx/mpc5200_simple.c
+++ b/arch/powerpc/platforms/52xx/mpc5200_simple.c
@@ -50,6 +50,7 @@ static void __init mpc5200_simple_setup_arch(void)
 
 /* list of the supported boards */
 static const char *board[] __initdata = {
+	"anon,charon",
 	"intercontrol,digsy-mtc",
 	"manroland,mucmc52",
 	"manroland,uc101",
-- 
1.7.4

