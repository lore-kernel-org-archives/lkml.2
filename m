Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757972Ab0KPUui (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 15:50:38 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:32809 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932438Ab0KPUud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 15:50:33 -0500
Subject: [PATCH 5/5] powerpc/5200: dts: refactor dts files
To: linux-kernel@vger.kernel.org
From: John Bonesio <bones@secretlab.ca>
Cc: linuxppc-dev@lists.ozlabs.org, jdl@jdl.com, glikely@secretlab.ca,
        devicetree-discuss@lists.ozlabs.org, david@gibson.dropbear.id.au
Date: Tue, 16 Nov 2010 12:50:28 -0800
Message-ID: <20101116205028.12146.48324.stgit@riker>
In-Reply-To: <20101116204917.12146.39851.stgit@riker>
References: <20101116204917.12146.39851.stgit@riker>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch creates mpc5200b.dtsi containing the information for the MPC5200b
SoC then modifies all of the dts files for MPC5200b based systems to use
mpc5200b.dtsi.

Signed-off-by: John Bonesio <bones@secretlab.ca>
---

 arch/powerpc/boot/dts/cm5200.dts    |  196 +++----------------------
 arch/powerpc/boot/dts/digsy_mtc.dts |  173 +++-------------------
 arch/powerpc/boot/dts/lite5200b.dts |  211 +++------------------------
 arch/powerpc/boot/dts/media5200.dts |  212 +++------------------------
 arch/powerpc/boot/dts/motionpro.dts |  190 +++---------------------
 arch/powerpc/boot/dts/mpc5200b.dtsi |  276 +++++++++++++++++++++++++++++++++++
 arch/powerpc/boot/dts/mucmc52.dts   |  176 ++++++----------------
 arch/powerpc/boot/dts/pcm030.dts    |  193 ++----------------------
 arch/powerpc/boot/dts/pcm032.dts    |  197 +------------------------
 arch/powerpc/boot/dts/uc101.dts     |  162 ++++-----------------
 10 files changed, 488 insertions(+), 1498 deletions(-)
 create mode 100644 arch/powerpc/boot/dts/mpc5200b.dtsi

diff --git a/arch/powerpc/boot/dts/cm5200.dts b/arch/powerpc/boot/dts/cm5200.dts
index d549897..c6d5d46 100644
--- a/arch/powerpc/boot/dts/cm5200.dts
+++ b/arch/powerpc/boot/dts/cm5200.dts
@@ -10,226 +10,78 @@
  * option) any later version.
  */
 
-/dts-v1/;
+/include/ "mpc5200b.dtsi"
 
 / {
 	model = "schindler,cm5200";
 	compatible = "schindler,cm5200";
-	#address-cells = <1>;
-	#size-cells = <1>;
-	interrupt-parent = <&mpc5200_pic>;
-
-	cpus {
-		#address-cells = <1>;
-		#size-cells = <0>;
-
-		PowerPC,5200@0 {
-			device_type = "cpu";
-			reg = <0>;
-			d-cache-line-size = <32>;
-			i-cache-line-size = <32>;
-			d-cache-size = <0x4000>;		// L1, 16K
-			i-cache-size = <0x4000>;		// L1, 16K
-			timebase-frequency = <0>;	// from bootloader
-			bus-frequency = <0>;		// from bootloader
-			clock-frequency = <0>;		// from bootloader
-		};
-	};
-
-	memory {
-		device_type = "memory";
-		reg = <0x00000000 0x04000000>;	// 64MB
-	};
 
 	soc5200@f0000000 {
-		#address-cells = <1>;
-		#size-cells = <1>;
-		compatible = "fsl,mpc5200b-immr";
-		ranges = <0 0xf0000000 0x0000c000>;
-		reg = <0xf0000000 0x00000100>;
-		bus-frequency = <0>;		// from bootloader
-		system-frequency = <0>;		// from bootloader
-
-		cdm@200 {
-			compatible = "fsl,mpc5200b-cdm","fsl,mpc5200-cdm";
-			reg = <0x200 0x38>;
-		};
-
-		mpc5200_pic: interrupt-controller@500 {
-			// 5200 interrupts are encoded into two levels;
-			interrupt-controller;
-			#interrupt-cells = <3>;
-			compatible = "fsl,mpc5200b-pic","fsl,mpc5200-pic";
-			reg = <0x500 0x80>;
-		};
-
 		timer@600 {	// General Purpose Timer
-			compatible = "fsl,mpc5200b-gpt","fsl,mpc5200-gpt";
-			reg = <0x600 0x10>;
-			interrupts = <1 9 0>;
 			fsl,has-wdt;
 		};
 
-		timer@610 {	// General Purpose Timer
-			compatible = "fsl,mpc5200b-gpt","fsl,mpc5200-gpt";
-			reg = <0x610 0x10>;
-			interrupts = <1 10 0>;
-		};
-
-		timer@620 {	// General Purpose Timer
-			compatible = "fsl,mpc5200b-gpt","fsl,mpc5200-gpt";
-			reg = <0x620 0x10>;
-			interrupts = <1 11 0>;
-		};
-
-		timer@630 {	// General Purpose Timer
-			compatible = "fsl,mpc5200b-gpt","fsl,mpc5200-gpt";
-			reg = <0x630 0x10>;
-			interrupts = <1 12 0>;
-		};
-
-		timer@640 {	// General Purpose Timer
-			compatible = "fsl,mpc5200b-gpt","fsl,mpc5200-gpt";
-			reg = <0x640 0x10>;
-			interrupts = <1 13 0>;
-		};
-
-		timer@650 {	// General Purpose Timer
-			compatible = "fsl,mpc5200b-gpt","fsl,mpc5200-gpt";
-			reg = <0x650 0x10>;
-			interrupts = <1 14 0>;
-		};
-
-		timer@660 {	// General Purpose Timer
-			compatible = "fsl,mpc5200b-gpt","fsl,mpc5200-gpt";
-			reg = <0x660 0x10>;
-			interrupts = <1 15 0>;
-		};
-
-		timer@670 {	// General Purpose Timer
-			compatible = "fsl,mpc5200b-gpt","fsl,mpc5200-gpt";
-			reg = <0x670 0x10>;
-			interrupts = <1 16 0>;
-		};
-
-		rtc@800 {	// Real time clock
-			compatible = "fsl,mpc5200b-rtc","fsl,mpc5200-rtc";
-			reg = <0x800 0x100>;
-			interrupts = <1 5 0 1 6 0>;
-		};
-
-		gpio_simple: gpio@b00 {
-			compatible = "fsl,mpc5200b-gpio","fsl,mpc5200-gpio";
-			reg = <0xb00 0x40>;
-			interrupts = <1 7 0>;
-			gpio-controller;
-			#gpio-cells = <2>;
-		};
-
-		gpio_wkup: gpio@c00 {
-			compatible = "fsl,mpc5200b-gpio-wkup","fsl,mpc5200-gpio-wkup";
-			reg = <0xc00 0x40>;
-			interrupts = <1 8 0 0 3 0>;
-			gpio-controller;
-			#gpio-cells = <2>;
-		};
-
-		spi@f00 {
-			compatible = "fsl,mpc5200b-spi","fsl,mpc5200-spi";
-			reg = <0xf00 0x20>;
-			interrupts = <2 13 0 2 14 0>;
-		};
-
-		usb@1000 {
-			compatible = "fsl,mpc5200b-ohci","fsl,mpc5200-ohci","ohci-be";
-			reg = <0x1000 0xff>;
-			interrupts = <2 6 0>;
-		};
-
-		dma-controller@1200 {
-			compatible = "fsl,mpc5200b-bestcomm","fsl,mpc5200-bestcomm";
-			reg = <0x1200 0x80>;
-			interrupts = <3 0 0  3 1 0  3 2 0  3 3 0
-			              3 4 0  3 5 0  3 6 0  3 7 0
-			              3 8 0  3 9 0  3 10 0  3 11 0
-			              3 12 0  3 13 0  3 14 0  3 15 0>;
+		can@900 {
+			status = "disabled";
 		};
 
-		xlb@1f00 {
-			compatible = "fsl,mpc5200b-xlb","fsl,mpc5200-xlb";
-			reg = <0x1f00 0x100>;
+		can@980 {
+			status = "disabled";
 		};
 
 		psc@2000 {		// PSC1
 			compatible = "fsl,mpc5200b-psc-uart","fsl,mpc5200-psc-uart";
-			reg = <0x2000 0x100>;
-			interrupts = <2 1 0>;
 		};
 
 		psc@2200 {		// PSC2
 			compatible = "fsl,mpc5200b-psc-uart","fsl,mpc5200-psc-uart";
-			reg = <0x2200 0x100>;
-			interrupts = <2 2 0>;
 		};
 
 		psc@2400 {		// PSC3
 			compatible = "fsl,mpc5200b-psc-uart","fsl,mpc5200-psc-uart";
-			reg = <0x2400 0x100>;
-			interrupts = <2 3 0>;
 		};
 
-		psc@2c00 {		// PSC6
-			compatible = "fsl,mpc5200b-psc-uart","fsl,mpc5200-psc-uart";
-			reg = <0x2c00 0x100>;
-			interrupts = <2 4 0>;
+		psc@2600 {		// PSC4
+			status = "disabled";
 		};
 
-		ethernet@3000 {
-			compatible = "fsl,mpc5200b-fec","fsl,mpc5200-fec";
-			reg = <0x3000 0x400>;
-			local-mac-address = [ 00 00 00 00 00 00 ];
-			interrupts = <2 5 0>;
-			phy-handle = <&phy0>;
+		psc@2800 {		// PSC5
+			status = "disabled";
 		};
 
-		mdio@3000 {
-			#address-cells = <1>;
-			#size-cells = <0>;
-			compatible = "fsl,mpc5200b-mdio","fsl,mpc5200-mdio";
-			reg = <0x3000 0x400>;       // fec range, since we need to setup fec interrupts
-			interrupts = <2 5 0>;   // these are for "mii command finished", not link changes & co.
+		psc@2c00 {		// PSC6
+			compatible = "fsl,mpc5200b-psc-uart","fsl,mpc5200-psc-uart";
+		};
 
+		mdio@3000 {
 			phy0: ethernet-phy@0 {
 				reg = <0>;
 			};
 		};
 
-		i2c@3d40 {
-			#address-cells = <1>;
-			#size-cells = <0>;
-			compatible = "fsl,mpc5200b-i2c","fsl,mpc5200-i2c","fsl-i2c";
-			reg = <0x3d40 0x40>;
-			interrupts = <2 16 0>;
+		ata@3a00 {
+			status = "disabled";
 		};
 
-		sram@8000 {
-			compatible = "fsl,mpc5200b-sram","fsl,mpc5200-sram";
-			reg = <0x8000 0x4000>;
+		i2c@3d00 {
+			status = "disabled";
 		};
+
 	};
 
-	localbus {
-		compatible = "fsl,mpc5200b-lpb","simple-bus";
-		#address-cells = <2>;
-		#size-cells = <1>;
-		ranges = <0 0 0xfc000000 0x2000000>;
+	pci@f0000d00 {
+		status = "disabled";
+	};
 
+	localbus {
 		// 16-bit flash device at LocalPlus Bus CS0
 		flash@0,0 {
 			compatible = "cfi-flash";
 			reg = <0 0 0x2000000>;
 			bank-width = <2>;
 			device-width = <2>;
+			#size-cells = <1>;
+			#address-cells = <1>;
 		};
 	};
 };
diff --git a/arch/powerpc/boot/dts/digsy_mtc.dts b/arch/powerpc/boot/dts/digsy_mtc.dts
index f0592de..a12b587 100644
--- a/arch/powerpc/boot/dts/digsy_mtc.dts
+++ b/arch/powerpc/boot/dts/digsy_mtc.dts
@@ -11,195 +11,64 @@
  * option) any later version.
  */
 
-/dts-v1/;
+/include/ "mpc5200b.dtsi"
 
 / {
 	model = "intercontrol,digsy-mtc";
 	compatible = "intercontrol,digsy-mtc";
-	#address-cells = <1>;
-	#size-cells = <1>;
-	interrupt-parent = <&mpc5200_pic>;
-
-	cpus {
-		#address-cells = <1>;
-		#size-cells = <0>;
-
-		PowerPC,5200@0 {
-			device_type = "cpu";
-			reg = <0>;
-			d-cache-line-size = <32>;
-			i-cache-line-size = <32>;
-			d-cache-size = <0x4000>;		// L1, 16K
-			i-cache-size = <0x4000>;		// L1, 16K
-			timebase-frequency = <0>;	// from bootloader
-			bus-frequency = <0>;		// from bootloader
-			clock-frequency = <0>;		// from bootloader
-		};
-	};
 
 	memory {
-		device_type = "memory";
 		reg = <0x00000000 0x02000000>;	// 32MB
 	};
 
 	soc5200@f0000000 {
-		#address-cells = <1>;
-		#size-cells = <1>;
-		compatible = "fsl,mpc5200b-immr";
-		ranges = <0 0xf0000000 0x0000c000>;
-		reg = <0xf0000000 0x00000100>;
-		bus-frequency = <0>;		// from bootloader
-		system-frequency = <0>;		// from bootloader
-
-		cdm@200 {
-			compatible = "fsl,mpc5200b-cdm","fsl,mpc5200-cdm";
-			reg = <0x200 0x38>;
-		};
-
-		mpc5200_pic: interrupt-controller@500 {
-			// 5200 interrupts are encoded into two levels;
-			interrupt-controller;
-			#interrupt-cells = <3>;
-			compatible = "fsl,mpc5200b-pic","fsl,mpc5200-pic";
-			reg = <0x500 0x80>;
-		};
-
 		timer@600 {	// General Purpose Timer
-			compatible = "fsl,mpc5200b-gpt","fsl,mpc5200-gpt";
-			reg = <0x600 0x10>;
-			interrupts = <1 9 0>;
 			fsl,has-wdt;
 		};
 
-		timer@610 {	// General Purpose Timer
-			compatible = "fsl,mpc5200b-gpt","fsl,mpc5200-gpt";
-			reg = <0x610 0x10>;
-			interrupts = <1 10 0>;
-		};
-
-		timer@620 {	// General Purpose Timer
-			compatible = "fsl,mpc5200b-gpt","fsl,mpc5200-gpt";
-			reg = <0x620 0x10>;
-			interrupts = <1 11 0>;
-		};
-
-		timer@630 {	// General Purpose Timer
-			compatible = "fsl,mpc5200b-gpt","fsl,mpc5200-gpt";
-			reg = <0x630 0x10>;
-			interrupts = <1 12 0>;
-		};
-
-		timer@640 {	// General Purpose Timer
-			compatible = "fsl,mpc5200b-gpt","fsl,mpc5200-gpt";
-			reg = <0x640 0x10>;
-			interrupts = <1 13 0>;
-		};
-
-		timer@650 {	// General Purpose Timer
-			compatible = "fsl,mpc5200b-gpt","fsl,mpc5200-gpt";
-			reg = <0x650 0x10>;
-			interrupts = <1 14 0>;
+		rtc@800 {
+			status = "disabled";
 		};
 
-		timer@660 {	// General Purpose Timer
-			compatible = "fsl,mpc5200b-gpt","fsl,mpc5200-gpt";
-			reg = <0x660 0x10>;
-			interrupts = <1 15 0>;
+		can@900 {
+			status = "disabled";
 		};
 
-		timer@670 {	// General Purpose Timer
-			compatible = "fsl,mpc5200b-gpt","fsl,mpc5200-gpt";
-			reg = <0x670 0x10>;
-			interrupts = <1 16 0>;
+		can@980 {
+			status = "disabled";
 		};
 
-		gpio_simple: gpio@b00 {
-			compatible = "fsl,mpc5200b-gpio","fsl,mpc5200-gpio";
-			reg = <0xb00 0x40>;
-			interrupts = <1 7 0>;
-			gpio-controller;
-			#gpio-cells = <2>;
+		psc@2000 {		// PSC1
+			status = "disabled";
 		};
 
-		gpio_wkup: gpio@c00 {
-			compatible = "fsl,mpc5200b-gpio-wkup","fsl,mpc5200-gpio-wkup";
-			reg = <0xc00 0x40>;
-			interrupts = <1 8 0 0 3 0>;
-			gpio-controller;
-			#gpio-cells = <2>;
+		psc@2200 {		// PSC2
+			status = "disabled";
 		};
 
-		spi@f00 {
-			compatible = "fsl,mpc5200b-spi","fsl,mpc5200-spi";
-			reg = <0xf00 0x20>;
-			interrupts = <2 13 0 2 14 0>;
-		};
-
-		usb@1000 {
-			compatible = "fsl,mpc5200b-ohci","fsl,mpc5200-ohci","ohci-be";
-			reg = <0x1000 0xff>;
-			interrupts = <2 6 0>;
-		};
-
-		dma-controller@1200 {
-			compatible = "fsl,mpc5200b-bestcomm","fsl,mpc5200-bestcomm";
-			reg = <0x1200 0x80>;
-			interrupts = <3 0 0  3 1 0  3 2 0  3 3 0
-			              3 4 0  3 5 0  3 6 0  3 7 0
-			              3 8 0  3 9 0  3 10 0  3 11 0
-			              3 12 0  3 13 0  3 14 0  3 15 0>;
-		};
-
-		xlb@1f00 {
-			compatible = "fsl,mpc5200b-xlb","fsl,mpc5200-xlb";
-			reg = <0x1f00 0x100>;
+		psc@2400 {		// PSC3
+			status = "disabled";
 		};
 
 		psc@2600 {		// PSC4
 			compatible = "fsl,mpc5200b-psc-uart","fsl,mpc5200-psc-uart";
-			reg = <0x2600 0x100>;
-			interrupts = <2 11 0>;
 		};
 
 		psc@2800 {		// PSC5
 			compatible = "fsl,mpc5200b-psc-uart","fsl,mpc5200-psc-uart";
-			reg = <0x2800 0x100>;
-			interrupts = <2 12 0>;
 		};
 
-		ethernet@3000 {
-			compatible = "fsl,mpc5200b-fec","fsl,mpc5200-fec";
-			reg = <0x3000 0x400>;
-			local-mac-address = [ 00 00 00 00 00 00 ];
-			interrupts = <2 5 0>;
-			phy-handle = <&phy0>;
+		psc@2c00 {		// PSC6
+			status = "disabled";
 		};
 
 		mdio@3000 {
-			#address-cells = <1>;
-			#size-cells = <0>;
-			compatible = "fsl,mpc5200b-mdio","fsl,mpc5200-mdio";
-			reg = <0x3000 0x400>;       // fec range, since we need to setup fec interrupts
-			interrupts = <2 5 0>;   // these are for "mii command finished", not link changes & co.
-
 			phy0: ethernet-phy@0 {
 				reg = <0>;
 			};
 		};
 
-		ata@3a00 {
-			compatible = "fsl,mpc5200b-ata","fsl,mpc5200-ata";
-			reg = <0x3a00 0x100>;
-			interrupts = <2 7 0>;
-		};
-
 		i2c@3d00 {
-			#address-cells = <1>;
-			#size-cells = <0>;
-			compatible = "fsl,mpc5200b-i2c","fsl,mpc5200-i2c","fsl-i2c";
-			reg = <0x3d00 0x40>;
-			interrupts = <2 15 0>;
-
 			rtc@50 {
 				compatible = "at,24c08";
 				reg = <0x50>;
@@ -211,16 +80,16 @@
 			};
 		};
 
-		sram@8000 {
-			compatible = "fsl,mpc5200b-sram","fsl,mpc5200-sram";
-			reg = <0x8000 0x4000>;
+		i2c@3d40 {
+			status = "disabled";
 		};
 	};
 
+	pci@f0000d00 {
+		status = "disabled";
+	};
+
 	localbus {
-		compatible = "fsl,mpc5200b-lpb","simple-bus";
-		#address-cells = <2>;
-		#size-cells = <1>;
 		ranges = <0 0 0xff000000 0x1000000>;
 
 		// 16-bit flash device at LocalPlus Bus CS0
diff --git a/arch/powerpc/boot/dts/lite5200b.dts b/arch/powerpc/boot/dts/lite5200b.dts
index ed8d7ae..054e38a 100644
--- a/arch/powerpc/boot/dts/lite5200b.dts
+++ b/arch/powerpc/boot/dts/lite5200b.dts
@@ -10,172 +10,44 @@
  * option) any later version.
  */
 
-/dts-v1/;
+/include/ "mpc5200b.dtsi"
 
 / {
 	model = "fsl,lite5200b";
 	compatible = "fsl,lite5200b";
-	#address-cells = <1>;
-	#size-cells = <1>;
-	interrupt-parent = <&mpc5200_pic>;
-
-	cpus {
-		#address-cells = <1>;
-		#size-cells = <0>;
-
-		PowerPC,5200@0 {
-			device_type = "cpu";
-			reg = <0>;
-			d-cache-line-size = <32>;
-			i-cache-line-size = <32>;
-			d-cache-size = <0x4000>;	// L1, 16K
-			i-cache-size = <0x4000>;	// L1, 16K
-			timebase-frequency = <0>;	// from bootloader
-			bus-frequency = <0>;		// from bootloader
-			clock-frequency = <0>;		// from bootloader
-		};
-	};
 
 	memory {
-		device_type = "memory";
 		reg = <0x00000000 0x10000000>;	// 256MB
 	};
 
 	soc5200@f0000000 {
-		#address-cells = <1>;
-		#size-cells = <1>;
-		compatible = "fsl,mpc5200b-immr";
-		ranges = <0 0xf0000000 0x0000c000>;
-		reg = <0xf0000000 0x00000100>;
-		bus-frequency = <0>;		// from bootloader
-		system-frequency = <0>;		// from bootloader
-
-		cdm@200 {
-			compatible = "fsl,mpc5200b-cdm","fsl,mpc5200-cdm";
-			reg = <0x200 0x38>;
-		};
-
-		mpc5200_pic: interrupt-controller@500 {
-			// 5200 interrupts are encoded into two levels;
-			interrupt-controller;
-			#interrupt-cells = <3>;
-			compatible = "fsl,mpc5200b-pic","fsl,mpc5200-pic";
-			reg = <0x500 0x80>;
-		};
-
 		timer@600 {	// General Purpose Timer
-			compatible = "fsl,mpc5200b-gpt","fsl,mpc5200-gpt";
-			reg = <0x600 0x10>;
-			interrupts = <1 9 0>;
 			fsl,has-wdt;
 		};
 
-		timer@610 {	// General Purpose Timer
-			compatible = "fsl,mpc5200b-gpt","fsl,mpc5200-gpt";
-			reg = <0x610 0x10>;
-			interrupts = <1 10 0>;
-		};
-
-		timer@620 {	// General Purpose Timer
-			compatible = "fsl,mpc5200b-gpt","fsl,mpc5200-gpt";
-			reg = <0x620 0x10>;
-			interrupts = <1 11 0>;
-		};
-
-		timer@630 {	// General Purpose Timer
-			compatible = "fsl,mpc5200b-gpt","fsl,mpc5200-gpt";
-			reg = <0x630 0x10>;
-			interrupts = <1 12 0>;
-		};
-
-		timer@640 {	// General Purpose Timer
-			compatible = "fsl,mpc5200b-gpt","fsl,mpc5200-gpt";
-			reg = <0x640 0x10>;
-			interrupts = <1 13 0>;
-		};
-
-		timer@650 {	// General Purpose Timer
-			compatible = "fsl,mpc5200b-gpt","fsl,mpc5200-gpt";
-			reg = <0x650 0x10>;
-			interrupts = <1 14 0>;
-		};
-
-		timer@660 {	// General Purpose Timer
-			compatible = "fsl,mpc5200b-gpt","fsl,mpc5200-gpt";
-			reg = <0x660 0x10>;
-			interrupts = <1 15 0>;
-		};
-
-		timer@670 {	// General Purpose Timer
-			compatible = "fsl,mpc5200b-gpt","fsl,mpc5200-gpt";
-			reg = <0x670 0x10>;
-			interrupts = <1 16 0>;
-		};
-
-		rtc@800 {	// Real time clock
-			compatible = "fsl,mpc5200b-rtc","fsl,mpc5200-rtc";
-			reg = <0x800 0x100>;
-			interrupts = <1 5 0 1 6 0>;
-		};
-
-		can@900 {
-			compatible = "fsl,mpc5200b-mscan","fsl,mpc5200-mscan";
-			interrupts = <2 17 0>;
-			reg = <0x900 0x80>;
-		};
-
-		can@980 {
-			compatible = "fsl,mpc5200b-mscan","fsl,mpc5200-mscan";
-			interrupts = <2 18 0>;
-			reg = <0x980 0x80>;
-		};
-
-		gpio_simple: gpio@b00 {
-			compatible = "fsl,mpc5200b-gpio","fsl,mpc5200-gpio";
-			reg = <0xb00 0x40>;
-			interrupts = <1 7 0>;
-			gpio-controller;
-			#gpio-cells = <2>;
-		};
-
-		gpio_wkup: gpio@c00 {
-			compatible = "fsl,mpc5200b-gpio-wkup","fsl,mpc5200-gpio-wkup";
-			reg = <0xc00 0x40>;
-			interrupts = <1 8 0 0 3 0>;
-			gpio-controller;
-			#gpio-cells = <2>;
+		psc@2000 {		// PSC1
+			compatible = "fsl,mpc5200b-psc-uart","fsl,mpc5200-psc-uart";
+			cell-index = <0>;
 		};
 
-		spi@f00 {
-			compatible = "fsl,mpc5200b-spi","fsl,mpc5200-spi";
-			reg = <0xf00 0x20>;
-			interrupts = <2 13 0 2 14 0>;
+		psc@2200 {		// PSC2
+			status = "disabled";
 		};
 
-		usb@1000 {
-			compatible = "fsl,mpc5200b-ohci","fsl,mpc5200-ohci","ohci-be";
-			reg = <0x1000 0xff>;
-			interrupts = <2 6 0>;
+		psc@2400 {		// PSC3
+			status = "disabled";
 		};
 
-		dma-controller@1200 {
-			compatible = "fsl,mpc5200b-bestcomm","fsl,mpc5200-bestcomm";
-			reg = <0x1200 0x80>;
-			interrupts = <3 0 0  3 1 0  3 2 0  3 3 0
-			              3 4 0  3 5 0  3 6 0  3 7 0
-			              3 8 0  3 9 0  3 10 0  3 11 0
-			              3 12 0  3 13 0  3 14 0  3 15 0>;
+		psc@2600 {		// PSC4
+			status = "disabled";
 		};
 
-		xlb@1f00 {
-			compatible = "fsl,mpc5200b-xlb","fsl,mpc5200-xlb";
-			reg = <0x1f00 0x100>;
+		psc@2800 {		// PSC5
+			status = "disabled";
 		};
 
-		psc@2000 {		// PSC1
-			compatible = "fsl,mpc5200b-psc-uart","fsl,mpc5200-psc-uart";
-			reg = <0x2000 0x100>;
-			interrupts = <2 1 0>;
+		psc@2c00 {		// PSC6
+			status = "disabled";
 		};
 
 		// PSC2 in ac97 mode example
@@ -197,6 +69,7 @@
 		// PSC4 in uart mode example
 		//serial@2600 {		// PSC4
 		//	compatible = "fsl,mpc5200b-psc-uart","fsl,mpc5200-psc-uart";
+		//	cell-index = <3>;
 		//	reg = <0x2600 0x100>;
 		//	interrupts = <2 11 0>;
 		//};
@@ -204,6 +77,7 @@
 		// PSC5 in uart mode example
 		//serial@2800 {		// PSC5
 		//	compatible = "fsl,mpc5200b-psc-uart","fsl,mpc5200-psc-uart";
+		//	cell-index = <4>;
 		//	reg = <0x2800 0x100>;
 		//	interrupts = <2 12 0>;
 		//};
@@ -216,47 +90,13 @@
 		//	interrupts = <2 4 0>;
 		//};
 
-		ethernet@3000 {
-			compatible = "fsl,mpc5200b-fec","fsl,mpc5200-fec";
-			reg = <0x3000 0x400>;
-			local-mac-address = [ 00 00 00 00 00 00 ];
-			interrupts = <2 5 0>;
-			phy-handle = <&phy0>;
-		};
-
 		mdio@3000 {
-			#address-cells = <1>;
-			#size-cells = <0>;
-			compatible = "fsl,mpc5200b-mdio","fsl,mpc5200-mdio";
-			reg = <0x3000 0x400>;	// fec range, since we need to setup fec interrupts
-			interrupts = <2 5 0>;	// these are for "mii command finished", not link changes & co.
-
 			phy0: ethernet-phy@0 {
 				reg = <0>;
 			};
 		};
 
-		ata@3a00 {
-			compatible = "fsl,mpc5200b-ata","fsl,mpc5200-ata";
-			reg = <0x3a00 0x100>;
-			interrupts = <2 7 0>;
-		};
-
-		i2c@3d00 {
-			#address-cells = <1>;
-			#size-cells = <0>;
-			compatible = "fsl,mpc5200b-i2c","fsl,mpc5200-i2c","fsl-i2c";
-			reg = <0x3d00 0x40>;
-			interrupts = <2 15 0>;
-		};
-
 		i2c@3d40 {
-			#address-cells = <1>;
-			#size-cells = <0>;
-			compatible = "fsl,mpc5200b-i2c","fsl,mpc5200-i2c","fsl-i2c";
-			reg = <0x3d40 0x40>;
-			interrupts = <2 16 0>;
-
 			eeprom@50 {
 				compatible = "atmel,24c02";
 				reg = <0x50>;
@@ -270,12 +110,6 @@
 	};
 
 	pci@f0000d00 {
-		#interrupt-cells = <1>;
-		#size-cells = <2>;
-		#address-cells = <3>;
-		device_type = "pci";
-		compatible = "fsl,mpc5200b-pci","fsl,mpc5200-pci";
-		reg = <0xf0000d00 0x100>;
 		interrupt-map-mask = <0xf800 0 0 7>;
 		interrupt-map = <0xc000 0 0 1 &mpc5200_pic 0 0 3 // 1st slot
 				 0xc000 0 0 2 &mpc5200_pic 1 1 3
@@ -295,19 +129,14 @@
 	};
 
 	localbus {
-		compatible = "fsl,mpc5200b-lpb","simple-bus";
-
-		#address-cells = <2>;
-		#size-cells = <1>;
-
 		ranges = <0 0 0xfe000000 0x02000000>;
 
 		flash@0,0 {
 			compatible = "cfi-flash";
-			reg = <0 0 0x02000000>;
-			bank-width = <1>;
-			#size-cells = <1>;
-			#address-cells = <1>;
+                        reg = <0 0 0x02000000>;
+                        bank-width = <1>;
+                        #size-cells = <1>;
+                        #address-cells = <1>;
 
 			partition@0 {
 				label = "kernel";
diff --git a/arch/powerpc/boot/dts/media5200.dts b/arch/powerpc/boot/dts/media5200.dts
index e027f45..84558f8 100644
--- a/arch/powerpc/boot/dts/media5200.dts
+++ b/arch/powerpc/boot/dts/media5200.dts
@@ -11,14 +11,11 @@
  * option) any later version.
  */
 
-/dts-v1/;
+/include/ "mpc5200b.dtsi"
 
 / {
 	model = "fsl,media5200";
 	compatible = "fsl,media5200";
-	#address-cells = <1>;
-	#size-cells = <1>;
-	interrupt-parent = <&mpc5200_pic>;
 
 	aliases {
 		console = &console;
@@ -30,16 +27,7 @@
 	};
 
 	cpus {
-		#address-cells = <1>;
-		#size-cells = <0>;
-
 		PowerPC,5200@0 {
-			device_type = "cpu";
-			reg = <0>;
-			d-cache-line-size = <32>;
-			i-cache-line-size = <32>;
-			d-cache-size = <0x4000>;		// L1, 16K
-			i-cache-size = <0x4000>;		// L1, 16K
 			timebase-frequency = <33000000>;	// 33 MHz, these were configured by U-Boot
 			bus-frequency = <132000000>;		// 132 MHz
 			clock-frequency = <396000000>;		// 396 MHz
@@ -47,203 +35,53 @@
 	};
 
 	memory {
-		device_type = "memory";
 		reg = <0x00000000 0x08000000>;	// 128MB RAM
 	};
 
-	soc@f0000000 {
-		#address-cells = <1>;
-		#size-cells = <1>;
-		compatible = "fsl,mpc5200b-immr";
-		ranges = <0 0xf0000000 0x0000c000>;
-		reg = <0xf0000000 0x00000100>;
+	soc5200@f0000000 {
 		bus-frequency = <132000000>;// 132 MHz
-		system-frequency = <0>;		// from bootloader
-
-		cdm@200 {
-			compatible = "fsl,mpc5200b-cdm","fsl,mpc5200-cdm";
-			reg = <0x200 0x38>;
-		};
-
-		mpc5200_pic: interrupt-controller@500 {
-			// 5200 interrupts are encoded into two levels;
-			interrupt-controller;
-			#interrupt-cells = <3>;
-			compatible = "fsl,mpc5200b-pic","fsl,mpc5200-pic";
-			reg = <0x500 0x80>;
-		};
 
 		timer@600 {	// General Purpose Timer
-			compatible = "fsl,mpc5200b-gpt","fsl,mpc5200-gpt";
-			reg = <0x600 0x10>;
-			interrupts = <1 9 0>;
 			fsl,has-wdt;
 		};
 
-		timer@610 {	// General Purpose Timer
-			compatible = "fsl,mpc5200b-gpt","fsl,mpc5200-gpt";
-			reg = <0x610 0x10>;
-			interrupts = <1 10 0>;
-		};
-
-		timer@620 {	// General Purpose Timer
-			compatible = "fsl,mpc5200b-gpt","fsl,mpc5200-gpt";
-			reg = <0x620 0x10>;
-			interrupts = <1 11 0>;
-		};
-
-		timer@630 {	// General Purpose Timer
-			compatible = "fsl,mpc5200b-gpt","fsl,mpc5200-gpt";
-			reg = <0x630 0x10>;
-			interrupts = <1 12 0>;
-		};
-
-		timer@640 {	// General Purpose Timer
-			compatible = "fsl,mpc5200b-gpt","fsl,mpc5200-gpt";
-			reg = <0x640 0x10>;
-			interrupts = <1 13 0>;
+		psc@2000 {	// PSC1
+			status = "disabled";
 		};
 
-		timer@650 {	// General Purpose Timer
-			compatible = "fsl,mpc5200b-gpt","fsl,mpc5200-gpt";
-			reg = <0x650 0x10>;
-			interrupts = <1 14 0>;
+		psc@2200 {	// PSC2
+			status = "disabled";
 		};
 
-		timer@660 {	// General Purpose Timer
-			compatible = "fsl,mpc5200b-gpt","fsl,mpc5200-gpt";
-			reg = <0x660 0x10>;
-			interrupts = <1 15 0>;
+		psc@2400 {	// PSC3
+			status = "disabled";
 		};
 
-		timer@670 {	// General Purpose Timer
-			compatible = "fsl,mpc5200b-gpt","fsl,mpc5200-gpt";
-			reg = <0x670 0x10>;
-			interrupts = <1 16 0>;
+		psc@2600 {	// PSC4
+			status = "disabled";
 		};
 
-		rtc@800 {	// Real time clock
-			compatible = "fsl,mpc5200b-rtc","fsl,mpc5200-rtc";
-			reg = <0x800 0x100>;
-			interrupts = <1 5 0 1 6 0>;
-		};
-
-		can@900 {
-			compatible = "fsl,mpc5200b-mscan","fsl,mpc5200-mscan";
-			interrupts = <2 17 0>;
-			reg = <0x900 0x80>;
-		};
-
-		can@980 {
-			compatible = "fsl,mpc5200b-mscan","fsl,mpc5200-mscan";
-			interrupts = <2 18 0>;
-			reg = <0x980 0x80>;
-		};
-
-		gpio_simple: gpio@b00 {
-			compatible = "fsl,mpc5200b-gpio","fsl,mpc5200-gpio";
-			reg = <0xb00 0x40>;
-			interrupts = <1 7 0>;
-			gpio-controller;
-			#gpio-cells = <2>;
-		};
-
-		gpio_wkup: gpio@c00 {
-			compatible = "fsl,mpc5200b-gpio-wkup","fsl,mpc5200-gpio-wkup";
-			reg = <0xc00 0x40>;
-			interrupts = <1 8 0 0 3 0>;
-			gpio-controller;
-			#gpio-cells = <2>;
-		};
-
-		spi@f00 {
-			compatible = "fsl,mpc5200b-spi","fsl,mpc5200-spi";
-			reg = <0xf00 0x20>;
-			interrupts = <2 13 0 2 14 0>;
-		};
-
-		usb@1000 {
-			compatible = "fsl,mpc5200b-ohci","fsl,mpc5200-ohci","ohci-be";
-			reg = <0x1000 0x100>;
-			interrupts = <2 6 0>;
-		};
-
-		dma-controller@1200 {
-			compatible = "fsl,mpc5200b-bestcomm","fsl,mpc5200-bestcomm";
-			reg = <0x1200 0x80>;
-			interrupts = <3 0 0  3 1 0  3 2 0  3 3 0
-			              3 4 0  3 5 0  3 6 0  3 7 0
-			              3 8 0  3 9 0  3 10 0  3 11 0
-			              3 12 0  3 13 0  3 14 0  3 15 0>;
-		};
-
-		xlb@1f00 {
-			compatible = "fsl,mpc5200b-xlb","fsl,mpc5200-xlb";
-			reg = <0x1f00 0x100>;
+		psc@2800 {	// PSC5
+			status = "disabled";
 		};
 
 		// PSC6 in uart mode
 		console: psc@2c00 {		// PSC6
 			compatible = "fsl,mpc5200b-psc-uart","fsl,mpc5200-psc-uart";
-			reg = <0x2c00 0x100>;
-			interrupts = <2 4 0>;
-		};
-
-		eth0: ethernet@3000 {
-			compatible = "fsl,mpc5200b-fec","fsl,mpc5200-fec";
-			reg = <0x3000 0x400>;
-			local-mac-address = [ 00 00 00 00 00 00 ];
-			interrupts = <2 5 0>;
-			phy-handle = <&phy0>;
 		};
 
 		mdio@3000 {
-			#address-cells = <1>;
-			#size-cells = <0>;
-			compatible = "fsl,mpc5200b-mdio","fsl,mpc5200-mdio";
-			reg = <0x3000 0x400>;	// fec range, since we need to setup fec interrupts
-			interrupts = <2 5 0>;	// these are for "mii command finished", not link changes & co.
-
 			phy0: ethernet-phy@0 {
 				reg = <0>;
 			};
 		};
 
-		ata@3a00 {
-			compatible = "fsl,mpc5200b-ata","fsl,mpc5200-ata";
-			reg = <0x3a00 0x100>;
-			interrupts = <2 7 0>;
-		};
-
-		i2c@3d00 {
-			#address-cells = <1>;
-			#size-cells = <0>;
-			compatible = "fsl,mpc5200b-i2c","fsl,mpc5200-i2c","fsl-i2c";
-			reg = <0x3d00 0x40>;
-			interrupts = <2 15 0>;
-		};
-
-		i2c@3d40 {
-			#address-cells = <1>;
-			#size-cells = <0>;
-			compatible = "fsl,mpc5200b-i2c","fsl,mpc5200-i2c","fsl-i2c";
-			reg = <0x3d40 0x40>;
-			interrupts = <2 16 0>;
-		};
-
-		sram@8000 {
-			compatible = "fsl,mpc5200b-sram","fsl,mpc5200-sram";
-			reg = <0x8000 0x4000>;
+		usb@1000 {
+			reg = <0x1000 0x100>;
 		};
 	};
 
 	pci@f0000d00 {
-		#interrupt-cells = <1>;
-		#size-cells = <2>;
-		#address-cells = <3>;
-		device_type = "pci";
-		compatible = "fsl,mpc5200b-pci","fsl,mpc5200-pci";
-		reg = <0xf0000d00 0x100>;
 		interrupt-map-mask = <0xf800 0 0 7>;
 		interrupt-map = <0xc000 0 0 1 &media5200_fpga 0 2 // 1st slot
 				 0xc000 0 0 2 &media5200_fpga 0 3
@@ -260,37 +98,29 @@
 
 				 0xe000 0 0 1 &media5200_fpga 0 5 // CoralIP
 				>;
-		clock-frequency = <0>; // From boot loader
-		interrupts = <2 8 0 2 9 0 2 10 0>;
-		interrupt-parent = <&mpc5200_pic>;
-		bus-range = <0 0>;
 		ranges = <0x42000000 0 0x80000000 0x80000000 0 0x20000000
 			  0x02000000 0 0xa0000000 0xa0000000 0 0x10000000
 			  0x01000000 0 0x00000000 0xb0000000 0 0x01000000>;
+		interrupt-parent = <&mpc5200_pic>;
 	};
 
 	localbus {
-		compatible = "fsl,mpc5200b-lpb","simple-bus";
-		#address-cells = <2>;
-		#size-cells = <1>;
-
 		ranges = < 0 0 0xfc000000 0x02000000
 			   1 0 0xfe000000 0x02000000
 			   2 0 0xf0010000 0x00010000
 			   3 0 0xf0020000 0x00010000 >;
-
 		flash@0,0 {
 			compatible = "amd,am29lv28ml", "cfi-flash";
-			reg = <0 0x0 0x2000000>;		// 32 MB
-			bank-width = <4>;			// Width in bytes of the flash bank
-			device-width = <2>;			// Two devices on each bank
+			reg = <0 0x0 0x2000000>;                // 32 MB
+			bank-width = <4>;                       // Width in bytes of the flash bank
+			device-width = <2>;                     // Two devices on each bank
 		};
 
 		flash@1,0 {
 			compatible = "amd,am29lv28ml", "cfi-flash";
-			reg = <1 0 0x2000000>;			// 32 MB
-			bank-width = <4>;			// Width in bytes of the flash bank
-			device-width = <2>;			// Two devices on each bank
+			reg = <1 0 0x2000000>;                  // 32 MB
+			bank-width = <4>;                       // Width in bytes of the flash bank
+			device-width = <2>;                     // Two devices on each bank
 		};
 
 		media5200_fpga: fpga@2,0 {
diff --git a/arch/powerpc/boot/dts/motionpro.dts b/arch/powerpc/boot/dts/motionpro.dts
index 3ab4666..2276ccd 100644
--- a/arch/powerpc/boot/dts/motionpro.dts
+++ b/arch/powerpc/boot/dts/motionpro.dts
@@ -10,219 +10,69 @@
  * option) any later version.
  */
 
-/dts-v1/;
+/include/ "mpc5200b.dtsi"
 
 / {
 	model = "promess,motionpro";
 	compatible = "promess,motionpro";
-	#address-cells = <1>;
-	#size-cells = <1>;
-	interrupt-parent = <&mpc5200_pic>;
-
-	cpus {
-		#address-cells = <1>;
-		#size-cells = <0>;
-
-		PowerPC,5200@0 {
-			device_type = "cpu";
-			reg = <0>;
-			d-cache-line-size = <32>;
-			i-cache-line-size = <32>;
-			d-cache-size = <0x4000>;	// L1, 16K
-			i-cache-size = <0x4000>;	// L1, 16K
-			timebase-frequency = <0>;	// from bootloader
-			bus-frequency = <0>;		// from bootloader
-			clock-frequency = <0>;		// from bootloader
-		};
-	};
-
-	memory {
-		device_type = "memory";
-		reg = <0x00000000 0x04000000>;	// 64MB
-	};
 
 	soc5200@f0000000 {
-		#address-cells = <1>;
-		#size-cells = <1>;
-		compatible = "fsl,mpc5200b-immr";
-		ranges = <0 0xf0000000 0x0000c000>;
-		reg = <0xf0000000 0x00000100>;
-		bus-frequency = <0>;		// from bootloader
-		system-frequency = <0>;		// from bootloader
-
-		cdm@200 {
-			compatible = "fsl,mpc5200b-cdm","fsl,mpc5200-cdm";
-			reg = <0x200 0x38>;
-		};
-
-		mpc5200_pic: interrupt-controller@500 {
-			// 5200 interrupts are encoded into two levels;
-			interrupt-controller;
-			#interrupt-cells = <3>;
-			compatible = "fsl,mpc5200b-pic","fsl,mpc5200-pic";
-			reg = <0x500 0x80>;
-		};
-
 		timer@600 {	// General Purpose Timer
-			compatible = "fsl,mpc5200b-gpt","fsl,mpc5200-gpt";
-			reg = <0x600 0x10>;
-			interrupts = <1 9 0>;
 			fsl,has-wdt;
 		};
 
-		timer@610 {	// General Purpose Timer
-			compatible = "fsl,mpc5200b-gpt","fsl,mpc5200-gpt";
-			reg = <0x610 0x10>;
-			interrupts = <1 10 0>;
-		};
-
-		timer@620 {	// General Purpose Timer
-			compatible = "fsl,mpc5200b-gpt","fsl,mpc5200-gpt";
-			reg = <0x620 0x10>;
-			interrupts = <1 11 0>;
-		};
-
-		timer@630 {	// General Purpose Timer
-			compatible = "fsl,mpc5200b-gpt","fsl,mpc5200-gpt";
-			reg = <0x630 0x10>;
-			interrupts = <1 12 0>;
-		};
-
-		timer@640 {	// General Purpose Timer
-			compatible = "fsl,mpc5200b-gpt","fsl,mpc5200-gpt";
-			reg = <0x640 0x10>;
-			interrupts = <1 13 0>;
-		};
-
-		timer@650 {	// General Purpose Timer
-			compatible = "fsl,mpc5200b-gpt","fsl,mpc5200-gpt";
-			reg = <0x650 0x10>;
-			interrupts = <1 14 0>;
-		};
-
 		timer@660 {	// Motion-PRO status LED
 			compatible = "promess,motionpro-led";
 			label = "motionpro-statusled";
-			reg = <0x660 0x10>;
-			interrupts = <1 15 0>;
 			blink-delay = <100>; // 100 msec
 		};
 
 		timer@670 {	// Motion-PRO ready LED
 			compatible = "promess,motionpro-led";
 			label = "motionpro-readyled";
-			reg = <0x670 0x10>;
-			interrupts = <1 16 0>;
 		};
 
-		rtc@800 {	// Real time clock
-			compatible = "fsl,mpc5200b-rtc","fsl,mpc5200-rtc";
-			reg = <0x800 0x100>;
-			interrupts = <1 5 0 1 6 0>;
-		};
-
-		can@980 {
-			compatible = "fsl,mpc5200b-mscan","fsl,mpc5200-mscan";
-			interrupts = <2 18 0>;
-			reg = <0x980 0x80>;
-		};
-
-		gpio_simple: gpio@b00 {
-			compatible = "fsl,mpc5200b-gpio","fsl,mpc5200-gpio";
-			reg = <0xb00 0x40>;
-			interrupts = <1 7 0>;
-			gpio-controller;
-			#gpio-cells = <2>;
-		};
-
-		gpio_wkup: gpio@c00 {
-			compatible = "fsl,mpc5200b-gpio-wkup","fsl,mpc5200-gpio-wkup";
-			reg = <0xc00 0x40>;
-			interrupts = <1 8 0 0 3 0>;
-			gpio-controller;
-			#gpio-cells = <2>;
-		};
-
-		spi@f00 {
-			compatible = "fsl,mpc5200b-spi","fsl,mpc5200-spi";
-			reg = <0xf00 0x20>;
-			interrupts = <2 13 0 2 14 0>;
-		};
-
-		usb@1000 {
-			compatible = "fsl,mpc5200b-ohci","fsl,mpc5200-ohci","ohci-be";
-			reg = <0x1000 0xff>;
-			interrupts = <2 6 0>;
-		};
-
-		dma-controller@1200 {
-			compatible = "fsl,mpc5200b-bestcomm","fsl,mpc5200-bestcomm";
-			reg = <0x1200 0x80>;
-			interrupts = <3 0 0  3 1 0  3 2 0  3 3 0
-			              3 4 0  3 5 0  3 6 0  3 7 0
-			              3 8 0  3 9 0  3 10 0  3 11 0
-			              3 12 0  3 13 0  3 14 0  3 15 0>;
-		};
-
-		xlb@1f00 {
-			compatible = "fsl,mpc5200b-xlb","fsl,mpc5200-xlb";
-			reg = <0x1f00 0x100>;
+		can@900 {
+			status = "disabled";
 		};
 
 		psc@2000 {		// PSC1
 			compatible = "fsl,mpc5200b-psc-uart","fsl,mpc5200-psc-uart";
-			reg = <0x2000 0x100>;
-			interrupts = <2 1 0>;
 		};
 
 		// PSC2 in spi master mode 
 		psc@2200 {		// PSC2
 			compatible = "fsl,mpc5200b-psc-spi","fsl,mpc5200-psc-spi";
 			cell-index = <1>;
-			reg = <0x2200 0x100>;
-			interrupts = <2 2 0>;
 		};
 
-		// PSC5 in uart mode
+		psc@2400 {		// PSC3
+			status = "disabled";
+		};
+
+		psc@2600 {		// PSC4
+			status = "disabled";
+		};
+
 		psc@2800 {		// PSC5
 			compatible = "fsl,mpc5200b-psc-uart","fsl,mpc5200-psc-uart";
-			reg = <0x2800 0x100>;
-			interrupts = <2 12 0>;
 		};
 
-		ethernet@3000 {
-			compatible = "fsl,mpc5200b-fec","fsl,mpc5200-fec";
-			reg = <0x3000 0x400>;
-			local-mac-address = [ 00 00 00 00 00 00 ];
-			interrupts = <2 5 0>;
-			phy-handle = <&phy0>;
+		psc@2c00 {		// PSC6
+			status = "disabled";
 		};
 
 		mdio@3000 {
-			#address-cells = <1>;
-			#size-cells = <0>;
-			compatible = "fsl,mpc5200b-mdio","fsl,mpc5200-mdio";
-			reg = <0x3000 0x400>;       // fec range, since we need to setup fec interrupts
-			interrupts = <2 5 0>;   // these are for "mii command finished", not link changes & co.
-
 			phy0: ethernet-phy@2 {
 				reg = <2>;
 			};
 		};
 
-		ata@3a00 {
-			compatible = "fsl,mpc5200b-ata","fsl,mpc5200-ata";
-			reg = <0x3a00 0x100>;
-			interrupts = <2 7 0>;
+		i2c@3d00 {
+			status = "disabled";
 		};
 
 		i2c@3d40 {
-			#address-cells = <1>;
-			#size-cells = <0>;
-			compatible = "fsl,mpc5200b-i2c","fsl,mpc5200-i2c","fsl-i2c";
-			reg = <0x3d40 0x40>;
-			interrupts = <2 16 0>;
-
 			rtc@68 {
 				compatible = "dallas,ds1339";
 				reg = <0x68>;
@@ -235,10 +85,11 @@
 		};
 	};
 
+	pci@f0000d00 {
+		status = "disabled";
+	};
+
 	localbus {
-		compatible = "fsl,mpc5200b-lpb","simple-bus";
-		#address-cells = <2>;
-		#size-cells = <1>;
 		ranges = <0 0 0xff000000 0x01000000
 			  1 0 0x50000000 0x00010000
 			  2 0 0x50010000 0x00010000
@@ -277,6 +128,9 @@
 			reg = <0 0 0x01000000>;
 			bank-width = <2>;
 			device-width = <2>;
+			#size-cells = <1>;
+			#address-cells = <1>;
 		};
+
 	};
 };
diff --git a/arch/powerpc/boot/dts/mpc5200b.dtsi b/arch/powerpc/boot/dts/mpc5200b.dtsi
new file mode 100644
index 0000000..dff0621
--- /dev/null
+++ b/arch/powerpc/boot/dts/mpc5200b.dtsi
@@ -0,0 +1,276 @@
+/*
+ * base MPC5200b Device Tree Source
+ *
+ * Copyright (C) 2010 SecretLab
+ * Grant Likely <grant@secretlab.ca>
+ * John Bonesio <bones@secretlab.ca>
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
+	model = "fsl,mpc5200b";
+	compatible = "fsl,mpc5200b";
+	#address-cells = <1>;
+	#size-cells = <1>;
+	interrupt-parent = <&mpc5200_pic>;
+
+	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		powerpc: PowerPC,5200@0 {
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
+	memory: memory {
+		device_type = "memory";
+		reg = <0x00000000 0x04000000>;	// 64MB
+	};
+
+	soc: soc5200@f0000000 {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		compatible = "fsl,mpc5200b-immr";
+		ranges = <0 0xf0000000 0x0000c000>;
+		reg = <0xf0000000 0x00000100>;
+		bus-frequency = <0>;		// from bootloader
+		system-frequency = <0>;		// from bootloader
+
+		cdm@200 {
+			compatible = "fsl,mpc5200b-cdm","fsl,mpc5200-cdm";
+			reg = <0x200 0x38>;
+		};
+
+		mpc5200_pic: interrupt-controller@500 {
+			// 5200 interrupts are encoded into two levels;
+			interrupt-controller;
+			#interrupt-cells = <3>;
+			compatible = "fsl,mpc5200b-pic","fsl,mpc5200-pic";
+			reg = <0x500 0x80>;
+		};
+
+		timer@600 {	// General Purpose Timer
+			compatible = "fsl,mpc5200b-gpt","fsl,mpc5200-gpt";
+			reg = <0x600 0x10>;
+			interrupts = <1 9 0>;
+		};
+
+		timer@610 {	// General Purpose Timer
+			compatible = "fsl,mpc5200b-gpt","fsl,mpc5200-gpt";
+			reg = <0x610 0x10>;
+			interrupts = <1 10 0>;
+		};
+
+		timer@620 {	// General Purpose Timer
+			compatible = "fsl,mpc5200b-gpt","fsl,mpc5200-gpt";
+			reg = <0x620 0x10>;
+			interrupts = <1 11 0>;
+		};
+
+		timer@630 {	// General Purpose Timer
+			compatible = "fsl,mpc5200b-gpt","fsl,mpc5200-gpt";
+			reg = <0x630 0x10>;
+			interrupts = <1 12 0>;
+		};
+
+		timer@640 {	// General Purpose Timer
+			compatible = "fsl,mpc5200b-gpt","fsl,mpc5200-gpt";
+			reg = <0x640 0x10>;
+			interrupts = <1 13 0>;
+		};
+
+		timer@650 {	// General Purpose Timer
+			compatible = "fsl,mpc5200b-gpt","fsl,mpc5200-gpt";
+			reg = <0x650 0x10>;
+			interrupts = <1 14 0>;
+		};
+
+		timer@660 {	// General Purpose Timer
+			compatible = "fsl,mpc5200b-gpt","fsl,mpc5200-gpt";
+			reg = <0x660 0x10>;
+			interrupts = <1 15 0>;
+		};
+
+		timer@670 {	// General Purpose Timer
+			compatible = "fsl,mpc5200b-gpt","fsl,mpc5200-gpt";
+			reg = <0x670 0x10>;
+			interrupts = <1 16 0>;
+		};
+
+		rtc@800 {	// Real time clock
+			compatible = "fsl,mpc5200b-rtc","fsl,mpc5200-rtc";
+			reg = <0x800 0x100>;
+			interrupts = <1 5 0 1 6 0>;
+		};
+
+		can@900 {
+			compatible = "fsl,mpc5200b-mscan","fsl,mpc5200-mscan";
+			interrupts = <2 17 0>;
+			reg = <0x900 0x80>;
+		};
+
+		can@980 {
+			compatible = "fsl,mpc5200b-mscan","fsl,mpc5200-mscan";
+			interrupts = <2 18 0>;
+			reg = <0x980 0x80>;
+		};
+
+		gpio_simple: gpio@b00 {
+			compatible = "fsl,mpc5200b-gpio","fsl,mpc5200-gpio";
+			reg = <0xb00 0x40>;
+			interrupts = <1 7 0>;
+			gpio-controller;
+			#gpio-cells = <2>;
+		};
+
+		gpio_wkup: gpio@c00 {
+			compatible = "fsl,mpc5200b-gpio-wkup","fsl,mpc5200-gpio-wkup";
+			reg = <0xc00 0x40>;
+			interrupts = <1 8 0 0 3 0>;
+			gpio-controller;
+			#gpio-cells = <2>;
+		};
+
+		spi@f00 {
+			compatible = "fsl,mpc5200b-spi","fsl,mpc5200-spi";
+			reg = <0xf00 0x20>;
+			interrupts = <2 13 0 2 14 0>;
+		};
+
+		usb: usb@1000 {
+			compatible = "fsl,mpc5200b-ohci","fsl,mpc5200-ohci","ohci-be";
+			reg = <0x1000 0xff>;
+			interrupts = <2 6 0>;
+		};
+
+		dma-controller@1200 {
+			compatible = "fsl,mpc5200b-bestcomm","fsl,mpc5200-bestcomm";
+			reg = <0x1200 0x80>;
+			interrupts = <3 0 0  3 1 0  3 2 0  3 3 0
+			              3 4 0  3 5 0  3 6 0  3 7 0
+			              3 8 0  3 9 0  3 10 0  3 11 0
+			              3 12 0  3 13 0  3 14 0  3 15 0>;
+		};
+
+		xlb@1f00 {
+			compatible = "fsl,mpc5200b-xlb","fsl,mpc5200-xlb";
+			reg = <0x1f00 0x100>;
+		};
+
+		psc1: psc@2000 {		// PSC1
+			compatible = "fsl,mpc5200b-psc","fsl,mpc5200-psc";
+			reg = <0x2000 0x100>;
+			interrupts = <2 1 0>;
+		};
+
+		psc2: psc@2200 {		// PSC2
+			compatible = "fsl,mpc5200b-psc","fsl,mpc5200-psc";
+			reg = <0x2200 0x100>;
+			interrupts = <2 2 0>;
+		};
+
+		psc3: psc@2400 {		// PSC3
+			compatible = "fsl,mpc5200b-psc","fsl,mpc5200-psc";
+			reg = <0x2400 0x100>;
+			interrupts = <2 3 0>;
+		};
+
+		psc4: psc@2600 {		// PSC4
+			compatible = "fsl,mpc5200b-psc","fsl,mpc5200-psc";
+			reg = <0x2600 0x100>;
+			interrupts = <2 11 0>;
+		};
+
+		psc5: psc@2800 {		// PSC5
+			compatible = "fsl,mpc5200b-psc","fsl,mpc5200-psc";
+			reg = <0x2800 0x100>;
+			interrupts = <2 12 0>;
+		};
+
+		psc6: psc@2c00 {		// PSC6
+			compatible = "fsl,mpc5200b-psc","fsl,mpc5200-psc";
+			reg = <0x2c00 0x100>;
+			interrupts = <2 4 0>;
+		};
+
+		eth0: ethernet@3000 {
+			compatible = "fsl,mpc5200b-fec","fsl,mpc5200-fec";
+			reg = <0x3000 0x400>;
+			local-mac-address = [ 00 00 00 00 00 00 ];
+			interrupts = <2 5 0>;
+			phy-handle = <&phy0>;
+		};
+
+		mdio@3000 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			compatible = "fsl,mpc5200b-mdio","fsl,mpc5200-mdio";
+			reg = <0x3000 0x400>;	// fec range, since we need to setup fec interrupts
+			interrupts = <2 5 0>;	// these are for "mii command finished", not link changes & co.
+		};
+
+		ata@3a00 {
+			compatible = "fsl,mpc5200b-ata","fsl,mpc5200-ata";
+			reg = <0x3a00 0x100>;
+			interrupts = <2 7 0>;
+		};
+
+		i2c@3d00 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			compatible = "fsl,mpc5200b-i2c","fsl,mpc5200-i2c","fsl-i2c";
+			reg = <0x3d00 0x40>;
+			interrupts = <2 15 0>;
+		};
+
+		i2c@3d40 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			compatible = "fsl,mpc5200b-i2c","fsl,mpc5200-i2c","fsl-i2c";
+			reg = <0x3d40 0x40>;
+			interrupts = <2 16 0>;
+		};
+
+		sram@8000 {
+			compatible = "fsl,mpc5200b-sram","fsl,mpc5200-sram";
+			reg = <0x8000 0x4000>;
+		};
+	};
+
+	pci: pci@f0000d00 {
+		#interrupt-cells = <1>;
+		#size-cells = <2>;
+		#address-cells = <3>;
+		device_type = "pci";
+		compatible = "fsl,mpc5200b-pci","fsl,mpc5200-pci";
+		reg = <0xf0000d00 0x100>;
+		// interrupt-map-mask = need to add
+		// interrupt-map = need to add
+		clock-frequency = <0>; // From boot loader
+		interrupts = <2 8 0 2 9 0 2 10 0>;
+		bus-range = <0 0>;
+		// ranges = need to add
+	};
+
+	localbus: localbus {
+		compatible = "fsl,mpc5200b-lpb","simple-bus";
+		#address-cells = <2>;
+		#size-cells = <1>;
+		ranges = <0 0 0xfc000000 0x2000000>;
+	};
+};
diff --git a/arch/powerpc/boot/dts/mucmc52.dts b/arch/powerpc/boot/dts/mucmc52.dts
index b9d3559..b369db5 100644
--- a/arch/powerpc/boot/dts/mucmc52.dts
+++ b/arch/powerpc/boot/dts/mucmc52.dts
@@ -11,172 +11,105 @@
  * option) any later version.
  */
 
-/dts-v1/;
+/include/ "mpc5200b.dtsi"
 
 / {
 	model = "manroland,mucmc52";
 	compatible = "manroland,mucmc52";
-	#address-cells = <1>;
-	#size-cells = <1>;
-	interrupt-parent = <&mpc5200_pic>;
-
-	cpus {
-		#address-cells = <1>;
-		#size-cells = <0>;
-
-		PowerPC,5200@0 {
-			device_type = "cpu";
-			reg = <0>;
-			d-cache-line-size = <32>;
-			i-cache-line-size = <32>;
-			d-cache-size = <0x4000>;	// L1, 16K
-			i-cache-size = <0x4000>;	// L1, 16K
-			timebase-frequency = <0>;	// from bootloader
-			bus-frequency = <0>;		// from bootloader
-			clock-frequency = <0>;		// from bootloader
-		};
-	};
-
-	memory {
-		device_type = "memory";
-		reg = <0x00000000 0x04000000>;	// 64MB
-	};
 
 	soc5200@f0000000 {
-		#address-cells = <1>;
-		#size-cells = <1>;
-		compatible = "fsl,mpc5200b-immr";
-		ranges = <0 0xf0000000 0x0000c000>;
-		reg = <0xf0000000 0x00000100>;
-		bus-frequency = <0>;		// from bootloader
-		system-frequency = <0>;		// from bootloader
-
-		cdm@200 {
-			compatible = "fsl,mpc5200b-cdm","fsl,mpc5200-cdm";
-			reg = <0x200 0x38>;
-		};
-
-		mpc5200_pic: interrupt-controller@500 {
-			// 5200 interrupts are encoded into two levels;
-			interrupt-controller;
-			#interrupt-cells = <3>;
-			compatible = "fsl,mpc5200b-pic","fsl,mpc5200-pic";
-			reg = <0x500 0x80>;
-		};
-
 		gpt0: timer@600 {	// GPT 0 in GPIO mode
-			compatible = "fsl,mpc5200b-gpt","fsl,mpc5200-gpt";
-			reg = <0x600 0x10>;
-			interrupts = <1 9 0>;
 			gpio-controller;
 			#gpio-cells = <2>;
 		};
 
 		gpt1: timer@610 {	// General Purpose Timer in GPIO mode
-			compatible = "fsl,mpc5200b-gpt","fsl,mpc5200-gpt";
-			reg = <0x610 0x10>;
-			interrupts = <1 10 0>;
 			gpio-controller;
 			#gpio-cells = <2>;
 		};
 
 		gpt2: timer@620 {	// General Purpose Timer in GPIO mode
-			compatible = "fsl,mpc5200b-gpt","fsl,mpc5200-gpt";
-			reg = <0x620 0x10>;
-			interrupts = <1 11 0>;
 			gpio-controller;
 			#gpio-cells = <2>;
 		};
 
 		gpt3: timer@630 {	// General Purpose Timer in GPIO mode
-			compatible = "fsl,mpc5200b-gpt","fsl,mpc5200-gpt";
-			reg = <0x630 0x10>;
-			interrupts = <1 12 0>;
 			gpio-controller;
 			#gpio-cells = <2>;
 		};
 
-		gpio_simple: gpio@b00 {
-			compatible = "fsl,mpc5200b-gpio","fsl,mpc5200-gpio";
-			reg = <0xb00 0x40>;
-			interrupts = <1 7 0>;
-			gpio-controller;
-			#gpio-cells = <2>;
+		timer@640 {
+			status = "disabled";
 		};
 
-		gpio_wkup: gpio@c00 {
-			compatible = "fsl,mpc5200b-gpio-wkup","fsl,mpc5200-gpio-wkup";
-			reg = <0xc00 0x40>;
-			interrupts = <1 8 0 0 3 0>;
-			gpio-controller;
-			#gpio-cells = <2>;
+		timer@650 {
+			status = "disabled";
 		};
 
-		dma-controller@1200 {
-			compatible = "fsl,mpc5200b-bestcomm","fsl,mpc5200-bestcomm";
-			reg = <0x1200 0x80>;
-			interrupts = <3 0 0  3 1 0  3 2 0  3 3 0
-			              3 4 0  3 5 0  3 6 0  3 7 0
-			              3 8 0  3 9 0  3 10 0  3 11 0
-			              3 12 0  3 13 0  3 14 0  3 15 0>;
+		timer@660 {
+			status = "disabled";
 		};
 
-		xlb@1f00 {
-			compatible = "fsl,mpc5200b-xlb","fsl,mpc5200-xlb";
-			reg = <0x1f00 0x100>;
+		timer@670 {
+			status = "disabled";
 		};
 
-		psc@2000 { /* PSC1 in UART mode */
-			compatible = "fsl,mpc5200b-psc-uart","fsl,mpc5200-psc-uart";
-			reg = <0x2000 0x100>;
-			interrupts = <2 1 0>;
+		rtc@800 {
+			status = "disabled";
+		};
+
+		can@900 {
+			status = "disabled";
+		};
+
+		can@980 {
+			status = "disabled";
+		};
+
+		spi@f00 {
+			status = "disabled";
+		};
+
+		usb@1000 {
+			status = "disabled";
 		};
 
-		psc@2200 { /* PSC2 in UART mode */
+		psc@2000 {		// PSC1
 			compatible = "fsl,mpc5200b-psc-uart","fsl,mpc5200-psc-uart";
-			reg = <0x2200 0x100>;
-			interrupts = <2 2 0>;
 		};
 
-		psc@2c00 { /* PSC6 in UART mode */
+		psc@2200 {		// PSC2
 			compatible = "fsl,mpc5200b-psc-uart","fsl,mpc5200-psc-uart";
-			reg = <0x2c00 0x100>;
-			interrupts = <2 4 0>;
 		};
 
-		ethernet@3000 {
-			compatible = "fsl,mpc5200b-fec","fsl,mpc5200-fec";
-			reg = <0x3000 0x400>;
-			local-mac-address = [ 00 00 00 00 00 00 ];
-			interrupts = <2 5 0>;
-			phy-handle = <&phy0>;
+		psc@2400 {		// PSC3
+			status = "disabled";
 		};
 
-		mdio@3000 {
-			#address-cells = <1>;
-			#size-cells = <0>;
-			compatible = "fsl,mpc5200b-mdio","fsl,mpc5200-mdio";
-			reg = <0x3000 0x400>; 	// fec range, since we need to setup fec interrupts
-			interrupts = <2 5 0>; 	// these are for "mii command finished", not link changes & co.
+		psc@2600 {		// PSC4
+			status = "disabled";
+		};
+
+		psc@2800 {		// PSC5
+			status = "disabled";
+		};
 
+		psc@2c00 {		// PSC6
+			compatible = "fsl,mpc5200b-psc-uart","fsl,mpc5200-psc-uart";
+		};
+
+		mdio@3000 {
 			phy0: ethernet-phy@0 {
 				compatible = "intel,lxt971";
 				reg = <0>;
 			};
 		};
 
-		ata@3a00 {
-			compatible = "fsl,mpc5200b-ata","fsl,mpc5200-ata";
-			reg = <0x3a00 0x100>;
-			interrupts = <2 7 0>;
+		i2c@3d00 {
+			status = "disabled";
 		};
 
 		i2c@3d40 {
-			#address-cells = <1>;
-			#size-cells = <0>;
-			compatible = "fsl,mpc5200b-i2c","fsl,mpc5200-i2c","fsl-i2c";
-			reg = <0x3d40 0x40>;
-			interrupts = <2 16 0>;
 			hwmon@2c {
 				compatible = "ad,adm9240";
 				reg = <0x2c>;
@@ -186,20 +119,9 @@
 				reg = <0x51>;
 			};
 		};
-
-		sram@8000 {
-			compatible = "fsl,mpc5200b-sram","fsl,mpc5200-sram";
-			reg = <0x8000 0x4000>;
-		};
 	};
 
 	pci@f0000d00 {
-		#interrupt-cells = <1>;
-		#size-cells = <2>;
-		#address-cells = <3>;
-		device_type = "pci";
-		compatible = "fsl,mpc5200b-pci","fsl,mpc5200-pci";
-		reg = <0xf0000d00 0x100>;
 		interrupt-map-mask = <0xf800 0 0 7>;
 		interrupt-map = <
 				/* IDSEL 0x10 */
@@ -208,20 +130,12 @@
 				0x8000 0 0 3 &mpc5200_pic 0 2 3
 				0x8000 0 0 4 &mpc5200_pic 0 1 3
 				>;
-		clock-frequency = <0>; // From boot loader
-		interrupts = <2 8 0 2 9 0 2 10 0>;
-		bus-range = <0 0>;
 		ranges = <0x42000000 0 0x60000000 0x60000000 0 0x10000000
 			  0x02000000 0 0x90000000 0x90000000 0 0x10000000
 			  0x01000000 0 0x00000000 0xa0000000 0 0x01000000>;
 	};
 
 	localbus {
-		compatible = "fsl,mpc5200b-lpb","simple-bus";
-
-		#address-cells = <2>;
-		#size-cells = <1>;
-
 		ranges = <0 0 0xff800000 0x00800000
 			  1 0 0x80000000 0x00800000
 			  3 0 0x80000000 0x00800000>;
diff --git a/arch/powerpc/boot/dts/pcm030.dts b/arch/powerpc/boot/dts/pcm030.dts
index f3e30bb..b2ee689 100644
--- a/arch/powerpc/boot/dts/pcm030.dts
+++ b/arch/powerpc/boot/dts/pcm030.dts
@@ -12,244 +12,88 @@
  * option) any later version.
  */
 
-/dts-v1/;
+/include/ "mpc5200b.dtsi"
 
 / {
 	model = "phytec,pcm030";
 	compatible = "phytec,pcm030";
-	#address-cells = <1>;
-	#size-cells = <1>;
-	interrupt-parent = <&mpc5200_pic>;
-
-	cpus {
-		#address-cells = <1>;
-		#size-cells = <0>;
-
-		PowerPC,5200@0 {
-			device_type = "cpu";
-			reg = <0>;
-			d-cache-line-size = <32>;
-			i-cache-line-size = <32>;
-			d-cache-size = <0x4000>;	// L1, 16K
-			i-cache-size = <0x4000>;	// L1, 16K
-			timebase-frequency = <0>;	// from bootloader
-			bus-frequency = <0>;		// from bootloader
-			clock-frequency = <0>;		// from bootloader
-		};
-	};
-
-	memory {
-		device_type = "memory";
-		reg = <0x00000000 0x04000000>;	// 64MB
-	};
 
 	soc5200@f0000000 {
-		#address-cells = <1>;
-		#size-cells = <1>;
-		compatible = "fsl,mpc5200b-immr";
-		ranges = <0 0xf0000000 0x0000c000>;
-		bus-frequency = <0>;		// from bootloader
-		system-frequency = <0>;		// from bootloader
-
-		cdm@200 {
-			compatible = "fsl,mpc5200b-cdm","fsl,mpc5200-cdm";
-			reg = <0x200 0x38>;
-		};
-
-		mpc5200_pic: interrupt-controller@500 {
-			// 5200 interrupts are encoded into two levels;
-			interrupt-controller;
-			#interrupt-cells = <3>;
-			compatible = "fsl,mpc5200b-pic","fsl,mpc5200-pic";
-			reg = <0x500 0x80>;
-		};
-
-		timer@600 {	// General Purpose Timer
-			compatible = "fsl,mpc5200b-gpt","fsl,mpc5200-gpt";
-			reg = <0x600 0x10>;
-			interrupts = <1 9 0>;
+		timer@600 {		// General Purpose Timer
 			fsl,has-wdt;
 		};
 
-		timer@610 {	// General Purpose Timer
-			compatible = "fsl,mpc5200b-gpt","fsl,mpc5200-gpt";
-			reg = <0x610 0x10>;
-			interrupts = <1 10 0>;
-		};
-
 		gpt2: timer@620 {	// General Purpose Timer in GPIO mode
 			compatible = "fsl,mpc5200b-gpt-gpio","fsl,mpc5200-gpt-gpio";
-			reg = <0x620 0x10>;
-			interrupts = <1 11 0>;
 			gpio-controller;
 			#gpio-cells = <2>;
 		};
 
 		gpt3: timer@630 {	// General Purpose Timer in GPIO mode
 			compatible = "fsl,mpc5200b-gpt-gpio","fsl,mpc5200-gpt-gpio";
-			reg = <0x630 0x10>;
-			interrupts = <1 12 0>;
 			gpio-controller;
 			#gpio-cells = <2>;
 		};
 
 		gpt4: timer@640 {	// General Purpose Timer in GPIO mode
 			compatible = "fsl,mpc5200b-gpt-gpio","fsl,mpc5200-gpt-gpio";
-			reg = <0x640 0x10>;
-			interrupts = <1 13 0>;
 			gpio-controller;
 			#gpio-cells = <2>;
 		};
 
 		gpt5: timer@650 {	// General Purpose Timer in GPIO mode
 			compatible = "fsl,mpc5200b-gpt-gpio","fsl,mpc5200-gpt-gpio";
-			reg = <0x650 0x10>;
-			interrupts = <1 14 0>;
 			gpio-controller;
 			#gpio-cells = <2>;
 		};
 
 		gpt6: timer@660 {	// General Purpose Timer in GPIO mode
 			compatible = "fsl,mpc5200b-gpt-gpio","fsl,mpc5200-gpt-gpio";
-			reg = <0x660 0x10>;
-			interrupts = <1 15 0>;
 			gpio-controller;
 			#gpio-cells = <2>;
 		};
 
 		gpt7: timer@670 {	// General Purpose Timer in GPIO mode
 			compatible = "fsl,mpc5200b-gpt-gpio","fsl,mpc5200-gpt-gpio";
-			reg = <0x670 0x10>;
-			interrupts = <1 16 0>;
-			gpio-controller;
-			#gpio-cells = <2>;
-		};
-
-		rtc@800 {	// Real time clock
-			compatible = "fsl,mpc5200b-rtc","fsl,mpc5200-rtc";
-			reg = <0x800 0x100>;
-			interrupts = <1 5 0 1 6 0>;
-		};
-
-		can@900 {
-			compatible = "fsl,mpc5200b-mscan","fsl,mpc5200-mscan";
-			interrupts = <2 17 0>;
-			reg = <0x900 0x80>;
-		};
-
-		can@980 {
-			compatible = "fsl,mpc5200b-mscan","fsl,mpc5200-mscan";
-			interrupts = <2 18 0>;
-			reg = <0x980 0x80>;
-		};
-
-		gpio_simple: gpio@b00 {
-			compatible = "fsl,mpc5200b-gpio","fsl,mpc5200-gpio";
-			reg = <0xb00 0x40>;
-			interrupts = <1 7 0>;
-			gpio-controller;
-			#gpio-cells = <2>;
-		};
-
-		gpio_wkup: gpio@c00 {
-			compatible = "fsl,mpc5200b-gpio-wkup","fsl,mpc5200-gpio-wkup";
-			reg = <0xc00 0x40>;
-			interrupts = <1 8 0 0 3 0>;
 			gpio-controller;
 			#gpio-cells = <2>;
 		};
 
-		spi@f00 {
-			compatible = "fsl,mpc5200b-spi","fsl,mpc5200-spi";
-			reg = <0xf00 0x20>;
-			interrupts = <2 13 0 2 14 0>;
-		};
-
-		usb@1000 {
-			compatible = "fsl,mpc5200b-ohci","fsl,mpc5200-ohci","ohci-be";
-			reg = <0x1000 0xff>;
-			interrupts = <2 6 0>;
-		};
-
-		dma-controller@1200 {
-			compatible = "fsl,mpc5200b-bestcomm","fsl,mpc5200-bestcomm";
-			reg = <0x1200 0x80>;
-			interrupts = <3 0 0  3 1 0  3 2 0  3 3 0
-			              3 4 0  3 5 0  3 6 0  3 7 0
-			              3 8 0  3 9 0  3 10 0  3 11 0
-			              3 12 0  3 13 0  3 14 0  3 15 0>;
-		};
-
-		xlb@1f00 {
-			compatible = "fsl,mpc5200b-xlb","fsl,mpc5200-xlb";
-			reg = <0x1f00 0x100>;
-		};
-
 		psc@2000 { /* PSC1 in ac97 mode */
 			compatible = "mpc5200b-psc-ac97","fsl,mpc5200b-psc-ac97";
 			cell-index = <0>;
-			reg = <0x2000 0x100>;
-			interrupts = <2 1 0>;
 		};
 
 		/* PSC2 port is used by CAN1/2 */
+		psc@2200 {
+			status = "disabled";
+		};
 
 		psc@2400 { /* PSC3 in UART mode */
 			compatible = "fsl,mpc5200b-psc-uart","fsl,mpc5200-psc-uart";
-			reg = <0x2400 0x100>;
-			interrupts = <2 3 0>;
 		};
 
 		/* PSC4 is ??? */
-
+		psc@2600 {
+			status = "disabled";
+		};
+		
 		/* PSC5 is ??? */
+		psc@2800 {
+			status = "disabled";
+		};
 
 		psc@2c00 { /* PSC6 in UART mode */
 			compatible = "fsl,mpc5200b-psc-uart","fsl,mpc5200-psc-uart";
-			reg = <0x2c00 0x100>;
-			interrupts = <2 4 0>;
-		};
-
-		ethernet@3000 {
-			compatible = "fsl,mpc5200b-fec","fsl,mpc5200-fec";
-			reg = <0x3000 0x400>;
-			local-mac-address = [ 00 00 00 00 00 00 ];
-			interrupts = <2 5 0>;
-			phy-handle = <&phy0>;
 		};
 
 		mdio@3000 {
-			#address-cells = <1>;
-			#size-cells = <0>;
-			compatible = "fsl,mpc5200b-mdio","fsl,mpc5200-mdio";
-			reg = <0x3000 0x400>;	// fec range, since we need to setup fec interrupts
-			interrupts = <2 5 0>;	// these are for "mii command finished", not link changes & co.
-
 			phy0: ethernet-phy@0 {
 				reg = <0>;
 			};
 		};
 
-		ata@3a00 {
-			compatible = "fsl,mpc5200b-ata","fsl,mpc5200-ata";
-			reg = <0x3a00 0x100>;
-			interrupts = <2 7 0>;
-		};
-
-		i2c@3d00 {
-			#address-cells = <1>;
-			#size-cells = <0>;
-			compatible = "fsl,mpc5200b-i2c","fsl,mpc5200-i2c","fsl-i2c";
-			reg = <0x3d00 0x40>;
-			interrupts = <2 15 0>;
-		};
-
 		i2c@3d40 {
-			#address-cells = <1>;
-			#size-cells = <0>;
-			compatible = "fsl,mpc5200b-i2c","fsl,mpc5200-i2c","fsl-i2c";
-			reg = <0x3d40 0x40>;
-			interrupts = <2 16 0>;
 			rtc@51 {
 				compatible = "nxp,pcf8563";
 				reg = <0x51>;
@@ -267,12 +111,6 @@
 	};
 
 	pci@f0000d00 {
-		#interrupt-cells = <1>;
-		#size-cells = <2>;
-		#address-cells = <3>;
-		device_type = "pci";
-		compatible = "fsl,mpc5200b-pci","fsl,mpc5200-pci";
-		reg = <0xf0000d00 0x100>;
 		interrupt-map-mask = <0xf800 0 0 7>;
 		interrupt-map = <0xc000 0 0 1 &mpc5200_pic 0 0 3 // 1st slot
 				 0xc000 0 0 2 &mpc5200_pic 1 1 3
@@ -283,11 +121,12 @@
 				 0xc800 0 0 2 &mpc5200_pic 1 2 3
 				 0xc800 0 0 3 &mpc5200_pic 1 3 3
 				 0xc800 0 0 4 &mpc5200_pic 0 0 3>;
-		clock-frequency = <0>; // From boot loader
-		interrupts = <2 8 0 2 9 0 2 10 0>;
-		bus-range = <0 0>;
 		ranges = <0x42000000 0 0x80000000 0x80000000 0 0x20000000
 			  0x02000000 0 0xa0000000 0xa0000000 0 0x10000000
 			  0x01000000 0 0x00000000 0xb0000000 0 0x01000000>;
 	};
+
+	localbus {
+		status = "disabled";
+	};
 };
diff --git a/arch/powerpc/boot/dts/pcm032.dts b/arch/powerpc/boot/dts/pcm032.dts
index 085a646..184e194 100644
--- a/arch/powerpc/boot/dts/pcm032.dts
+++ b/arch/powerpc/boot/dts/pcm032.dts
@@ -12,99 +12,37 @@
  * option) any later version.
  */
 
-/dts-v1/;
+/include/ "mpc5200b.dtsi"
 
 / {
 	model = "phytec,pcm032";
 	compatible = "phytec,pcm032";
-	#address-cells = <1>;
-	#size-cells = <1>;
-	interrupt-parent = <&mpc5200_pic>;
-
-	cpus {
-		#address-cells = <1>;
-		#size-cells = <0>;
-
-		PowerPC,5200@0 {
-			device_type = "cpu";
-			reg = <0>;
-			d-cache-line-size = <32>;
-			i-cache-line-size = <32>;
-			d-cache-size = <0x4000>;	// L1, 16K
-			i-cache-size = <0x4000>;	// L1, 16K
-			timebase-frequency = <0>;	// from bootloader
-			bus-frequency = <0>;		// from bootloader
-			clock-frequency = <0>;		// from bootloader
-		};
-	};
 
 	memory {
-		device_type = "memory";
 		reg = <0x00000000 0x08000000>;	// 128MB
 	};
 
 	soc5200@f0000000 {
-		#address-cells = <1>;
-		#size-cells = <1>;
-		compatible = "fsl,mpc5200b-immr";
-		ranges = <0 0xf0000000 0x0000c000>;
-		bus-frequency = <0>;		// from bootloader
-		system-frequency = <0>;		// from bootloader
-
-		cdm@200 {
-			compatible = "fsl,mpc5200b-cdm","fsl,mpc5200-cdm";
-			reg = <0x200 0x38>;
-		};
-
-		mpc5200_pic: interrupt-controller@500 {
-			// 5200 interrupts are encoded into two levels;
-			interrupt-controller;
-			#interrupt-cells = <3>;
-			compatible = "fsl,mpc5200b-pic","fsl,mpc5200-pic";
-			reg = <0x500 0x80>;
-		};
-
-		timer@600 {	// General Purpose Timer
-			compatible = "fsl,mpc5200b-gpt","fsl,mpc5200-gpt";
-			reg = <0x600 0x10>;
-			interrupts = <1 9 0>;
+		timer@600 {		// General Purpose Timer
 			fsl,has-wdt;
 		};
 
-		timer@610 {	// General Purpose Timer
-			compatible = "fsl,mpc5200b-gpt","fsl,mpc5200-gpt";
-			reg = <0x610 0x10>;
-			interrupts = <1 10 0>;
-		};
-
 		gpt2: timer@620 {	// General Purpose Timer in GPIO mode
-			compatible = "fsl,mpc5200b-gpt","fsl,mpc5200-gpt";
-			reg = <0x620 0x10>;
-			interrupts = <1 11 0>;
 			gpio-controller;
 			#gpio-cells = <2>;
 		};
 
 		gpt3: timer@630 {	// General Purpose Timer in GPIO mode
-			compatible = "fsl,mpc5200b-gpt","fsl,mpc5200-gpt";
-			reg = <0x630 0x10>;
-			interrupts = <1 12 0>;
 			gpio-controller;
 			#gpio-cells = <2>;
 		};
 
 		gpt4: timer@640 {	// General Purpose Timer in GPIO mode
-			compatible = "fsl,mpc5200b-gpt","fsl,mpc5200-gpt";
-			reg = <0x640 0x10>;
-			interrupts = <1 13 0>;
 			gpio-controller;
 			#gpio-cells = <2>;
 		};
 
 		gpt5: timer@650 {	// General Purpose Timer in GPIO mode
-			compatible = "fsl,mpc5200b-gpt","fsl,mpc5200-gpt";
-			reg = <0x650 0x10>;
-			interrupts = <1 14 0>;
 			gpio-controller;
 			#gpio-cells = <2>;
 		};
@@ -118,138 +56,45 @@
 		};
 
 		gpt7: timer@670 {	// General Purpose Timer in GPIO mode
-			compatible = "fsl,mpc5200b-gpt","fsl,mpc5200-gpt";
-			reg = <0x670 0x10>;
-			interrupts = <1 16 0>;
-			gpio-controller;
-			#gpio-cells = <2>;
-		};
-
-		rtc@800 {	// Real time clock
-			compatible = "fsl,mpc5200b-rtc","fsl,mpc5200-rtc";
-			reg = <0x800 0x100>;
-			interrupts = <1 5 0 1 6 0>;
-		};
-
-		can@900 {
-			compatible = "fsl,mpc5200b-mscan","fsl,mpc5200-mscan";
-			interrupts = <2 17 0>;
-			reg = <0x900 0x80>;
-		};
-
-		can@980 {
-			compatible = "fsl,mpc5200b-mscan","fsl,mpc5200-mscan";
-			interrupts = <2 18 0>;
-			reg = <0x980 0x80>;
-		};
-
-		gpio_simple: gpio@b00 {
-			compatible = "fsl,mpc5200b-gpio","fsl,mpc5200-gpio";
-			reg = <0xb00 0x40>;
-			interrupts = <1 7 0>;
-			gpio-controller;
-			#gpio-cells = <2>;
-		};
-
-		gpio_wkup: gpio@c00 {
-			compatible = "fsl,mpc5200b-gpio-wkup","fsl,mpc5200-gpio-wkup";
-			reg = <0xc00 0x40>;
-			interrupts = <1 8 0 0 3 0>;
 			gpio-controller;
 			#gpio-cells = <2>;
 		};
 
-		spi@f00 {
-			compatible = "fsl,mpc5200b-spi","fsl,mpc5200-spi";
-			reg = <0xf00 0x20>;
-			interrupts = <2 13 0 2 14 0>;
-		};
-
-		usb@1000 {
-			compatible = "fsl,mpc5200b-ohci","fsl,mpc5200-ohci","ohci-be";
-			reg = <0x1000 0xff>;
-			interrupts = <2 6 0>;
-		};
-
-		dma-controller@1200 {
-			compatible = "fsl,mpc5200b-bestcomm","fsl,mpc5200-bestcomm";
-			reg = <0x1200 0x80>;
-			interrupts = <3 0 0  3 1 0  3 2 0  3 3 0
-			              3 4 0  3 5 0  3 6 0  3 7 0
-			              3 8 0  3 9 0  3 10 0  3 11 0
-			              3 12 0  3 13 0  3 14 0  3 15 0>;
-		};
-
-		xlb@1f00 {
-			compatible = "fsl,mpc5200b-xlb","fsl,mpc5200-xlb";
-			reg = <0x1f00 0x100>;
-		};
-
 		psc@2000 {	/* PSC1 is ac97 */
 			compatible = "fsl,mpc5200b-psc-ac97","fsl,mpc5200-psc-ac97";
 			cell-index = <0>;
-			reg = <0x2000 0x100>;
-			interrupts = <2 1 0>;
 		};
 
 		/* PSC2 port is used by CAN1/2 */
+		psc@2200 {
+			status = "disabled";
+		};
 
 		psc@2400 { /* PSC3 in UART mode */
 			compatible = "fsl,mpc5200b-psc-uart","fsl,mpc5200-psc-uart";
-			reg = <0x2400 0x100>;
-			interrupts = <2 3 0>;
 		};
 
 		/* PSC4 is ??? */
+		psc@2600 {
+			status = "disabled";
+		};
 
 		/* PSC5 is ??? */
+		psc@2800 {
+			status = "disabled";
+		};
 
 		psc@2c00 { /* PSC6 in UART mode */
 			compatible = "fsl,mpc5200b-psc-uart","fsl,mpc5200-psc-uart";
-			reg = <0x2c00 0x100>;
-			interrupts = <2 4 0>;
-		};
-
-		ethernet@3000 {
-			compatible = "fsl,mpc5200b-fec","fsl,mpc5200-fec";
-			reg = <0x3000 0x400>;
-			local-mac-address = [ 00 00 00 00 00 00 ];
-			interrupts = <2 5 0>;
-			phy-handle = <&phy0>;
 		};
 
 		mdio@3000 {
-			#address-cells = <1>;
-			#size-cells = <0>;
-			compatible = "fsl,mpc5200b-mdio","fsl,mpc5200-mdio";
-			reg = <0x3000 0x400>;	// fec range, since we need to setup fec interrupts
-			interrupts = <2 5 0>;	// these are for "mii command finished", not link changes & co.
-
 			phy0: ethernet-phy@0 {
 				reg = <0>;
 			};
 		};
 
-		ata@3a00 {
-			compatible = "fsl,mpc5200b-ata","fsl,mpc5200-ata";
-			reg = <0x3a00 0x100>;
-			interrupts = <2 7 0>;
-		};
-
-		i2c@3d00 {
-			#address-cells = <1>;
-			#size-cells = <0>;
-			compatible = "fsl,mpc5200b-i2c","fsl,mpc5200-i2c","fsl-i2c";
-			reg = <0x3d00 0x40>;
-			interrupts = <2 15 0>;
-		};
-
 		i2c@3d40 {
-			#address-cells = <1>;
-			#size-cells = <0>;
-			compatible = "fsl,mpc5200b-i2c","fsl,mpc5200-i2c","fsl-i2c";
-			reg = <0x3d40 0x40>;
-			interrupts = <2 16 0>;
 			rtc@51 {
 				compatible = "nxp,pcf8563";
 				reg = <0x51>;
@@ -259,20 +104,9 @@
 				reg = <0x52>;
 			};
 		};
-
-		sram@8000 {
-			compatible = "fsl,mpc5200b-sram","fsl,mpc5200-sram";
-			reg = <0x8000 0x4000>;
-		};
 	};
 
 	pci@f0000d00 {
-		#interrupt-cells = <1>;
-		#size-cells = <2>;
-		#address-cells = <3>;
-		device_type = "pci";
-		compatible = "fsl,mpc5200b-pci","fsl,mpc5200-pci";
-		reg = <0xf0000d00 0x100>;
 		interrupt-map-mask = <0xf800 0 0 7>;
 		interrupt-map = <0xc000 0 0 1 &mpc5200_pic 0 0 3 // 1st slot
 				 0xc000 0 0 2 &mpc5200_pic 1 1 3
@@ -283,20 +117,12 @@
 				 0xc800 0 0 2 &mpc5200_pic 1 2 3
 				 0xc800 0 0 3 &mpc5200_pic 1 3 3
 				 0xc800 0 0 4 &mpc5200_pic 0 0 3>;
-		clock-frequency = <0>; // From boot loader
-		interrupts = <2 8 0 2 9 0 2 10 0>;
-		bus-range = <0 0>;
 		ranges = <0x42000000 0 0x80000000 0x80000000 0 0x20000000
 			  0x02000000 0 0xa0000000 0xa0000000 0 0x10000000
 			  0x01000000 0 0x00000000 0xb0000000 0 0x01000000>;
 	};
 
 	localbus {
-		compatible = "fsl,mpc5200b-lpb","simple-bus";
-
-		#address-cells = <2>;
-		#size-cells = <1>;
-
 		ranges = <0 0 0xfe000000 0x02000000
 			  1 0 0xfc000000 0x02000000
 			  2 0 0xfbe00000 0x00200000
@@ -385,4 +211,3 @@
                  */
 	};
 };
-
diff --git a/arch/powerpc/boot/dts/uc101.dts b/arch/powerpc/boot/dts/uc101.dts
index 70299a4..49be562 100644
--- a/arch/powerpc/boot/dts/uc101.dts
+++ b/arch/powerpc/boot/dts/uc101.dts
@@ -11,79 +11,24 @@
  * option) any later version.
  */
 
-/dts-v1/;
+/include/ "mpc5200b.dtsi"
 
 / {
 	model = "manroland,uc101";
 	compatible = "manroland,uc101";
-	#address-cells = <1>;
-	#size-cells = <1>;
-	interrupt-parent = <&mpc5200_pic>;
-
-	cpus {
-		#address-cells = <1>;
-		#size-cells = <0>;
-
-		PowerPC,5200@0 {
-			device_type = "cpu";
-			reg = <0>;
-			d-cache-line-size = <32>;
-			i-cache-line-size = <32>;
-			d-cache-size = <0x4000>;	// L1, 16K
-			i-cache-size = <0x4000>;	// L1, 16K
-			timebase-frequency = <0>;	// from bootloader
-			bus-frequency = <0>;		// from bootloader
-			clock-frequency = <0>;		// from bootloader
-		};
-	};
-
-	memory {
-		device_type = "memory";
-		reg = <0x00000000 0x04000000>;	// 64MB
-	};
 
 	soc5200@f0000000 {
-		#address-cells = <1>;
-		#size-cells = <1>;
-		compatible = "fsl,mpc5200b-immr";
-		ranges = <0 0xf0000000 0x0000c000>;
-		reg = <0xf0000000 0x00000100>;
-		bus-frequency = <0>;		// from bootloader
-		system-frequency = <0>;		// from bootloader
-
-		cdm@200 {
-			compatible = "fsl,mpc5200b-cdm","fsl,mpc5200-cdm";
-			reg = <0x200 0x38>;
-		};
-
-		mpc5200_pic: interrupt-controller@500 {
-			// 5200 interrupts are encoded into two levels;
-			interrupt-controller;
-			#interrupt-cells = <3>;
-			compatible = "fsl,mpc5200b-pic","fsl,mpc5200-pic";
-			reg = <0x500 0x80>;
-		};
-
 		gpt0: timer@600 {	// General Purpose Timer in GPIO mode
-			compatible = "fsl,mpc5200b-gpt","fsl,mpc5200-gpt";
-			reg = <0x600 0x10>;
-			interrupts = <1 9 0>;
 			gpio-controller;
 			#gpio-cells = <2>;
 		};
 
 		gpt1: timer@610 {	// General Purpose Timer in GPIO mode
-			compatible = "fsl,mpc5200b-gpt","fsl,mpc5200-gpt";
-			reg = <0x610 0x10>;
-			interrupts = <1 10 0>;
 			gpio-controller;
 			#gpio-cells = <2>;
 		};
 
 		gpt2: timer@620 {	// General Purpose Timer in GPIO mode
-			compatible = "fsl,mpc5200b-gpt","fsl,mpc5200-gpt";
-			reg = <0x620 0x10>;
-			interrupts = <1 11 0>;
 			gpio-controller;
 			#gpio-cells = <2>;
 		};
@@ -97,118 +42,81 @@
 		};
 
 		gpt4: timer@640 {	// General Purpose Timer in GPIO mode
-			compatible = "fsl,mpc5200b-gpt","fsl,mpc5200-gpt";
-			reg = <0x640 0x10>;
-			interrupts = <1 13 0>;
 			gpio-controller;
 			#gpio-cells = <2>;
 		};
 
 		gpt5: timer@650 {	// General Purpose Timer in GPIO mode
-			compatible = "fsl,mpc5200b-gpt","fsl,mpc5200-gpt";
-			reg = <0x650 0x10>;
-			interrupts = <1 14 0>;
 			gpio-controller;
 			#gpio-cells = <2>;
 		};
 
 		gpt6: timer@660 {	// General Purpose Timer in GPIO mode
-			compatible = "fsl,mpc5200b-gpt","fsl,mpc5200-gpt";
-			reg = <0x660 0x10>;
-			interrupts = <1 15 0>;
 			gpio-controller;
 			#gpio-cells = <2>;
 		};
 
 		gpt7: timer@670 {	// General Purpose Timer in GPIO mode
-			compatible = "fsl,mpc5200b-gpt","fsl,mpc5200-gpt";
-			reg = <0x670 0x10>;
-			interrupts = <1 16 0>;
 			gpio-controller;
 			#gpio-cells = <2>;
 		};
 
-		gpio_simple: gpio@b00 {
-			compatible = "fsl,mpc5200b-gpio","fsl,mpc5200-gpio";
-			reg = <0xb00 0x40>;
-			interrupts = <1 7 0>;
-			gpio-controller;
-			#gpio-cells = <2>;
+		rtc@800 {
+			status = "disabled";
 		};
 
-		gpio_wkup: gpio@c00 {
-			compatible = "fsl,mpc5200b-gpio-wkup","fsl,mpc5200-gpio-wkup";
-			reg = <0xc00 0x40>;
-			interrupts = <1 8 0 0 3 0>;
-			gpio-controller;
-			#gpio-cells = <2>;
+		can@900 {
+			status = "disabled";
 		};
 
-		dma-controller@1200 {
-			compatible = "fsl,mpc5200b-bestcomm","fsl,mpc5200-bestcomm";
-			reg = <0x1200 0x80>;
-			interrupts = <3 0 0  3 1 0  3 2 0  3 3 0
-			              3 4 0  3 5 0  3 6 0  3 7 0
-			              3 8 0  3 9 0  3 10 0  3 11 0
-			              3 12 0  3 13 0  3 14 0  3 15 0>;
+		can@980 {
+			status = "disabled";
 		};
 
-		xlb@1f00 {
-			compatible = "fsl,mpc5200b-xlb","fsl,mpc5200-xlb";
-			reg = <0x1f00 0x100>;
+		spi@f00 {
+			status = "disabled";
 		};
 
-		psc@2000 { /* PSC1 in UART mode */
-			compatible = "fsl,mpc5200b-psc-uart","fsl,mpc5200-psc-uart";
-			reg = <0x2000 0x100>;
-			interrupts = <2 1 0>;
+		usb@1000 {
+			status = "disabled";
 		};
 
-		psc@2200 { /* PSC2 in UART mode */
+		psc@2000 {	// PSC1
 			compatible = "fsl,mpc5200b-psc-uart","fsl,mpc5200-psc-uart";
-			reg = <0x2200 0x100>;
-			interrupts = <2 2 0>;
 		};
 
-		psc@2c00 {		/* PSC6 in UART mode */
+		psc@2200 {	// PSC2
 			compatible = "fsl,mpc5200b-psc-uart","fsl,mpc5200-psc-uart";
-			reg = <0x2c00 0x100>;
-			interrupts = <2 4 0>;
 		};
 
-		ethernet@3000 {
-			compatible = "fsl,mpc5200b-fec","fsl,mpc5200-fec";
-			reg = <0x3000 0x400>;
-			local-mac-address = [ 00 00 00 00 00 00 ];
-			interrupts = <2 5 0>;
-			phy-handle = <&phy0>;
+		psc@2400 {	// PSC3
+			status = "disabled";
 		};
 
-		mdio@3000 {
-			#address-cells = <1>;
-			#size-cells = <0>;
-			compatible = "fsl,mpc5200b-mdio","fsl,mpc5200-mdio";
-			reg = <0x3000 0x400>;	// fec range, since we need to setup fec interrupts
-			interrupts = <2 5 0>;	// these are for "mii command finished", not link changes & co.
+		psc@2600 {	// PSC4
+			status = "disabled";
+		};
+
+		psc@2800 {	// PSC5
+			status = "disabled";
+		};
 
+		psc@2c00 {	// PSC6
+			compatible = "fsl,mpc5200b-psc-uart","fsl,mpc5200-psc-uart";
+		};
+
+		mdio@3000 {
 			phy0: ethernet-phy@0 {
 				compatible = "intel,lxt971";
 				reg = <0>;
 			};
 		};
 
-		ata@3a00 {
-			compatible = "fsl,mpc5200b-ata","fsl,mpc5200-ata";
-			reg = <0x3a00 0x100>;
-			interrupts = <2 7 0>;
+		i2c@3d00 {
+			status = "disabled";
 		};
 
 		i2c@3d40 {
-			#address-cells = <1>;
-			#size-cells = <0>;
-			compatible = "fsl,mpc5200b-i2c","fsl,mpc5200-i2c","fsl-i2c";
-			reg = <0x3d40 0x40>;
-			interrupts = <2 16 0>;
 			fsl,preserve-clocking;
 			clock-frequency = <400000>;
 
@@ -221,19 +129,13 @@
 				reg = <0x51>;
 			};
 		};
+	};
 
-		sram@8000 {
-			compatible = "fsl,mpc5200b-sram","fsl,mpc5200-sram";
-			reg = <0x8000 0x4000>;
-		};
+	pci@f0000d00 {
+		status = "disabled";
 	};
 
 	localbus {
-		compatible = "fsl,mpc5200b-lpb","simple-bus";
-
-		#address-cells = <2>;
-		#size-cells = <1>;
-
 		ranges = <0 0 0xff800000 0x00800000
 			  1 0 0x80000000 0x00800000
 			  3 0 0x80000000 0x00800000>;

