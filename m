Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964929Ab1FXAmb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 20:42:31 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:5766 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932752Ab1FXAm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 20:42:29 -0400
From: David Daney <david.daney@cavium.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org,
        devicetree-discuss@lists.ozlabs.org, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org
Cc: David Daney <ddaney@caviumnetworks.com>
Subject: [RFC PATCH] MIPS: Octeon: Add device tree source files.
Date: Thu, 23 Jun 2011 17:42:09 -0700
Message-Id: <1308876129-14145-1-git-send-email-david.daney@cavium.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1307387986-27069-4-git-send-email-ddaney@caviumnetworks.com>
References: <1307387986-27069-4-git-send-email-ddaney@caviumnetworks.com>
X-OriginalArrivalTime: 24 Jun 2011 00:42:28.0282 (UTC) FILETIME=[97FA39A0:01CC3207]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <ddaney@caviumnetworks.com>

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
---

This is a revision of my main device-tree definitions from my previous
RFC.  I wanted to get feedback on my changes to several bindings
before I set them in stone.

The changes are to bootbus.txt, compact-flash.txt and dma-engine.txt.

Basically there are a ton of parameters needed to initialize the boot
bus, and I just stuck them all in there.  Is this the best way to
handle something like this?

I look forward to hearing any feedback.

Thanks,
David Daney

 .../devicetree/bindings/mips/cavium/bootbus.txt    |  114 +++++
 .../devicetree/bindings/mips/cavium/ciu.txt        |   26 ++
 .../bindings/mips/cavium/compact-flash.txt         |   31 ++
 .../devicetree/bindings/mips/cavium/dma-engine.txt |   21 +
 .../devicetree/bindings/mips/cavium/gpio.txt       |   48 ++
 .../devicetree/bindings/mips/cavium/mdio.txt       |   27 ++
 .../devicetree/bindings/mips/cavium/mix.txt        |   40 ++
 .../devicetree/bindings/mips/cavium/pip.txt        |   98 +++++
 .../devicetree/bindings/mips/cavium/twsi.txt       |   34 ++
 .../devicetree/bindings/mips/cavium/uart.txt       |   19 +
 .../devicetree/bindings/mips/cavium/uctl.txt       |   47 ++
 arch/mips/cavium-octeon/.gitignore                 |    2 +
 arch/mips/cavium-octeon/Makefile                   |   13 +
 arch/mips/cavium-octeon/octeon_3xxx.dts            |  452 ++++++++++++++++++++
 14 files changed, 972 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mips/cavium/bootbus.txt
 create mode 100644 Documentation/devicetree/bindings/mips/cavium/ciu.txt
 create mode 100644 Documentation/devicetree/bindings/mips/cavium/compact-flash.txt
 create mode 100644 Documentation/devicetree/bindings/mips/cavium/dma-engine.txt
 create mode 100644 Documentation/devicetree/bindings/mips/cavium/gpio.txt
 create mode 100644 Documentation/devicetree/bindings/mips/cavium/mdio.txt
 create mode 100644 Documentation/devicetree/bindings/mips/cavium/mix.txt
 create mode 100644 Documentation/devicetree/bindings/mips/cavium/pip.txt
 create mode 100644 Documentation/devicetree/bindings/mips/cavium/twsi.txt
 create mode 100644 Documentation/devicetree/bindings/mips/cavium/uart.txt
 create mode 100644 Documentation/devicetree/bindings/mips/cavium/uctl.txt
 create mode 100644 arch/mips/cavium-octeon/.gitignore
 create mode 100644 arch/mips/cavium-octeon/octeon_3xxx.dts

diff --git a/Documentation/devicetree/bindings/mips/cavium/bootbus.txt b/Documentation/devicetree/bindings/mips/cavium/bootbus.txt
new file mode 100644
index 0000000..2960ba8
--- /dev/null
+++ b/Documentation/devicetree/bindings/mips/cavium/bootbus.txt
@@ -0,0 +1,114 @@
+* Boot Bus
+
+The Octeon Boot Bus is a configurable parallel bus with 8 chip
+selects.  Each chip select is independently configurable.
+
+Properties:
+- compatible: "cavium,octeon-3860-bootbus"
+
+  Compatibility with all cn3XXX, cn5XXX and cn6XXX SOCs.
+
+- reg: The base address of the Boot Bus' register bank.
+
+- #address-cells: Must be <2>.  The first cell is the chip select
+   within the bootbus.  The second cell is the offset from the chip select.
+
+- #size-cells: Must be <1>.
+
+- ranges: There must be one one triplet of (child-bus-address,
+  parent-bus-address, length) for each active chip select.  If the
+  length element for any triplet is zero, the chip select is disabled,
+  making it inactive.
+
+- t-adr: An array of 8 elements specifying the ADR timing parameter
+  (in nS) for the each of the 8 chip selects.
+
+- t-ce: An array of 8 elements specifying the CE timing parameter
+  (in nS) for the each of the 8 chip selects.
+
+- t-oe: An array of 8 elements specifying the OE timing parameter
+  (in nS) for the each of the 8 chip selects.
+
+- t-we: An array of 8 elements specifying the WE timing parameter
+  (in nS) for the each of the 8 chip selects.
+
+- t-rd-hld: An array of 8 elements specifying the RD_HLD timing parameter
+  (in nS) for the each of the 8 chip selects.
+
+- t-wr-hld: An array of 8 elements specifying the WR_HLD timing parameter
+  (in nS) for the each of the 8 chip selects.
+
+- t-pause: An array of 8 elements specifying the PAUSE timing parameter
+  (in nS) for the each of the 8 chip selects.
+
+- t-wait: An array of 8 elements specifying the WAIT timing parameter
+  (in nS) for the each of the 8 chip selects.
+
+- t-page: An array of 8 elements specifying the PAGE timing parameter
+  (in nS) for the each of the 8 chip selects.
+
+- t-rd-dly: An array of 8 elements specifying the RD_DLY timing parameter
+  (in nS) for the each of the 8 chip selects.
+
+- pages: An array of 8 elements specifying the PAGES parameter (0 = 8
+  bytes, 1 = 2 bytes, 2 = 4 bytes, 3 = 8 bytes) for the each of the 8
+  chip selects.
+
+- wait-mode: An array of 8 elements specifying the WAITM parameter
+  (0 or 1) for the each of the 8 chip selects.
+
+- page-mode: An array of 8 elements specifying the PAGEM parameter
+  (0 or 1) for the each of the 8 chip selects.
+
+- bus-width: An array of 8 elements specifying the WIDTH parameter
+  (in bits) for the each of the 8 chip selects.
+
+- ale-mode: An array of 8 elements specifying the ALE parameter
+  (0 or 1) for the each of the 8 chip selects.
+
+- sam-mode: An array of 8 elements specifying the SAM parameter
+  (0 or 1) for the each of the 8 chip selects.
+
+- or-mode: An array of 8 elements specifying the OR parameter
+  (0 or 1) for the each of the 8 chip selects.
+
+
+Example:
+	bootbus: bootbus@1180000000000 {
+		compatible = "cavium,octeon-3860-bootbus";
+		reg = <0x11800 0x00000000 0x0 0x200>;
+		/* The chip select number and offset */
+		#address-cells = <2>;
+		/* The size of the chip select region */
+		#size-cells = <1>;
+		ranges = <0 0  0x0 0x1f400000  0xc00000>,
+			 <1 0  0x10000 0x30000000  0>,
+			 <2 0  0x10000 0x40000000  0>,
+			 <3 0  0x10000 0x50000000  0>,
+			 <4 0  0x0 0x1d020000  0x10000>,
+			 <5 0  0x0 0x1d040000  0x10000>,
+			 <6 0  0x0 0x1d050000  0x10000>,
+			 <7 0  0x10000 0x90000000  0>;
+
+		t-adr    = <20 0 0 0 320   5   5 0>;
+		t-ce     = <60 0 0 0 320 300 300 0>;
+		t-oe     = <60 0 0 0 320 125 270 0>;
+		t-we     = <45 0 0 0 320 150 150 0>;
+		t-rd-hld = <35 0 0 0 320 100 100 0>;
+		t-wr-hld = <45 0 0 0 320  30  70 0>;
+		t-pause  = < 0 0 0 0 320   0   0 0>;
+		t-wait   = < 0 0 0 0 320  30   0 0>;
+		t-page   = <35 0 0 0 320 320 320 0>;
+		t-rd-dly = < 0 0 0 0   0   0   0 0>;
+
+		pages     = <0 0 0 0 0  0  0 0>;
+		wait-mode = <0 0 0 0 0  1  0 0>;
+		page-mode = <0 0 0 0 0  0  0 0>;
+		bus-width = <8 8 8 8 8 16 16 8>;
+		ale-mode  = <0 0 0 0 0  0  0 0>;
+		sam-mode  = <0 0 0 0 0  0  0 0>;
+		or-mode   = <0 0 0 0 0  0  0 0>;
+		.
+		.
+		.
+	};
diff --git a/Documentation/devicetree/bindings/mips/cavium/ciu.txt b/Documentation/devicetree/bindings/mips/cavium/ciu.txt
new file mode 100644
index 0000000..c8ff212
--- /dev/null
+++ b/Documentation/devicetree/bindings/mips/cavium/ciu.txt
@@ -0,0 +1,26 @@
+* Central Interrupt Unit
+
+Properties:
+- compatible: "cavium,octeon-3860-ciu"
+
+  Compatibility with all cn3XXX, cn5XXX and cn63XX SOCs.
+
+- interrupt-controller:  This is an interrupt controller. 
+
+- reg: The base address of the CIU's register bank.
+
+- #interrupt-cells: Must be <2>.  The first cell is the bank within
+   the CIU and may have a value of 0 or 1.  The second cell is the bit
+   within the bank and may have a value between 0 and 63.
+
+Example:
+	interrupt-controller@1070000000000 {
+		compatible = "cavium,octeon-3860-ciu";
+		interrupt-controller;
+		/* Interrupts are specified by two parts:
+		 * 1) Controller register (0 or 1)
+		 * 2) Bit within the register (0..63)
+		 */
+		#interrupt-cells = <2>;
+		reg = <0x10700 0x00000000 0x0 0x7000>;
+	};
diff --git a/Documentation/devicetree/bindings/mips/cavium/compact-flash.txt b/Documentation/devicetree/bindings/mips/cavium/compact-flash.txt
new file mode 100644
index 0000000..84972a3
--- /dev/null
+++ b/Documentation/devicetree/bindings/mips/cavium/compact-flash.txt
@@ -0,0 +1,31 @@
+* Compact Flash
+
+The Cavium Compact Flash device is connected to the Octeon Boot Bus,
+and is thus a child of the Boot Bus device.  It can read and write
+industry standard compact flash devices.
+
+Properties:
+- compatible: "cavium,ebt3000-compact-flash";
+
+  Compatibility with many Cavium evaluation boards.
+
+- reg: The base address of the the CF chip select banks.  Depending on
+  the device configuration, there may be one or two banks.
+
+- bus-width: The width of the connection to the CF devices.  Valid
+  values are 8 and 16.
+
+- true-ide: Mode of the CF connection.  Valid values are 1 - True IDE,
+  0 - not True IDE.
+
+- dma-engine-handle: Optional, a phandle for the DMA Engine connected
+  to this device.
+
+Example:
+	compact-flash@5,0 {
+		compatible = "cavium,ebt3000-compact-flash";
+		reg = <5 0 0x10000>, <6 0 0x10000>;
+		bus-width = <16>;
+		true-ide = <1>;
+		dma-engine-handle = <&dma0>; 
+	};
diff --git a/Documentation/devicetree/bindings/mips/cavium/dma-engine.txt b/Documentation/devicetree/bindings/mips/cavium/dma-engine.txt
new file mode 100644
index 0000000..cb4291e
--- /dev/null
+++ b/Documentation/devicetree/bindings/mips/cavium/dma-engine.txt
@@ -0,0 +1,21 @@
+* DMA Engine.
+
+The Octeon DMA Engine transfers between the Boot Bus and main memory.
+The DMA Engine will be refered to by phandle by any device that is
+connected to it.
+
+Properties:
+- compatible: "cavium,octeon-5750-bootbus-dma"
+
+  Compatibility with all cn52XX, cn56XX and cn6XXX SOCs.
+
+- reg: The base address of the DMA Engine's register bank.
+
+- interrupts: A single interrupt specifier.
+
+Example:
+	dma0: dma-engine@1180000000100 {
+		compatible = "cavium,octeon-5750-bootbus-dma";
+		reg = <0x11800 0x00000100 0x0 0x8>;
+		interrupts = <0 63>;
+	};
diff --git a/Documentation/devicetree/bindings/mips/cavium/gpio.txt b/Documentation/devicetree/bindings/mips/cavium/gpio.txt
new file mode 100644
index 0000000..21b989a
--- /dev/null
+++ b/Documentation/devicetree/bindings/mips/cavium/gpio.txt
@@ -0,0 +1,48 @@
+* General Purpose Input Output (GPIO) bus.
+
+Properties:
+- compatible: "cavium,octeon-3860-gpio"
+
+  Compatibility with all cn3XXX, cn5XXX and cn6XXX SOCs.
+
+- reg: The base address of the GPIO unit's register bank.
+
+- gpio-controller: This is a GPIO controller.
+
+- #gpio-cells: Must be <2>.  The first cell is the GPIO pin.
+
+- interrupt-controller: The GPIO controller is also an interrupt
+  controller, any of its pins may be configured as an interrupt
+  source.
+
+- #interrupt-cells: Must be <2>.  The first cell is the GPIO pin
+   connected to the interrupt source.  The second cell is the interrupt
+   triggering protocol and may have one of four values:
+   1 - edge triggered on the rising edge.
+   2 - edge triggered on the falling edge
+   4 - level triggered active high.
+   8 - level triggered active low.
+
+- interrupts: Interrupt routing for pin 0.  The remaining pins are
+  also routed, but in a manner that can be derived from the pin0
+  routing, so they are not specified.
+
+Example:
+
+	gpio-controller@1070000000800 {
+		#gpio-cells = <2>;
+		compatible = "cavium,octeon-3860-gpio";
+		reg = <0x10700 0x00000800 0x0 0x100>;
+		gpio-controller;
+		/* Interrupts are specified by two parts:
+		 * 1) GPIO pin number (0..15)
+		 * 2) Triggering (1 - edge rising
+		 *		  2 - edge falling
+		 *		  4 - level active high
+		 *		  8 - level active low)
+		 */
+		interrupt-controller;
+		#interrupt-cells = <2>;
+		/* The GPIO pin connect to 16 consecutive CUI bits */
+		interrupts = <0 16>;
+	};
diff --git a/Documentation/devicetree/bindings/mips/cavium/mdio.txt b/Documentation/devicetree/bindings/mips/cavium/mdio.txt
new file mode 100644
index 0000000..6253c3b
--- /dev/null
+++ b/Documentation/devicetree/bindings/mips/cavium/mdio.txt
@@ -0,0 +1,27 @@
+* System Management Interface (SMI) / MDIO
+
+Properties:
+- compatible: "cavium,octeon-3860-mdio"
+
+  Compatibility with all cn3XXX, cn5XXX and cn6XXX SOCs.
+
+- reg: The base address of the MDIO bus controller register bank.
+
+- #address-cells: Must be <1>.
+
+- #size-cells: Must be <0>.  MDIO addresses have no size component.
+
+Typically an MDIO bus might have several children. 
+
+Example:
+	mdio@1180000001800 {
+		compatible = "cavium,octeon-3860-mdio";
+		#address-cells = <1>;
+		#size-cells = <0>;
+		reg = <0x11800 0x00001800 0x0 0x40>;
+
+		ethernet-phy@0 {
+			...
+			reg = <0>;
+		};
+	};
diff --git a/Documentation/devicetree/bindings/mips/cavium/mix.txt b/Documentation/devicetree/bindings/mips/cavium/mix.txt
new file mode 100644
index 0000000..2a91a33
--- /dev/null
+++ b/Documentation/devicetree/bindings/mips/cavium/mix.txt
@@ -0,0 +1,40 @@
+* MIX Ethernet controller.
+
+Properties:
+- compatible: "cavium,octeon-5750-mix"
+
+  Compatibility with all cn5XXX and cn6XXX SOCs populated with MIX
+  devices.
+
+- reg: The base addresses of four seperate register banks.  The first
+  bank contains the MIX registers.  The second bank the corresponding
+  AGL registers.  The third bank are the AGL registers shared by all
+  MIX devices present.  The fourth bank is the AGL_PRT_CTL shared by
+  all MIX devices present.
+
+- cell-index: A single cell specifying which portion of the shared
+  register banks corresponds to this MIX device.
+
+- interrupts: Two interrupt specifiers.  The first is the MIX
+  interrupt routing and the second the routing for the AGL interrupts.
+
+- mac-address: Optional, the MAC address to assign to the device.
+
+- local-mac-address: Optional, the MAC address to assign to the device
+  if mac-address is not specified.
+
+- phy-handle: Optional, a phandle for the PHY device connected to this device.
+
+Example:
+	ethernet@1070000100800 {
+		compatible = "cavium,octeon-5750-mix";
+		reg = <0x10700 0x00100800 0x0 0x100>, /* MIX */
+		      <0x11800 0xE0000800 0x0 0x300>, /* AGL */
+		      <0x11800 0xE0000400 0x0 0x400>, /* AGL_SHARED  */
+		      <0x11800 0xE0002008 0x0 0x8>;   /* AGL_PRT_CTL */
+		cell-index = <1>;
+		interrupts = <1 18>, < 1 46>;
+		local-mac-address = [ 00 0f b7 10 63 54 ];
+		phy-handle = <&phy1>;
+	};
+
diff --git a/Documentation/devicetree/bindings/mips/cavium/pip.txt b/Documentation/devicetree/bindings/mips/cavium/pip.txt
new file mode 100644
index 0000000..d4c53ba
--- /dev/null
+++ b/Documentation/devicetree/bindings/mips/cavium/pip.txt
@@ -0,0 +1,98 @@
+* PIP Ethernet nexus.
+
+The PIP Ethernet nexus can control several data packet input/output
+devices.  The devices have a two level grouping scheme.  There may be
+several interfaces, and each interface may have several ports.  These
+ports might be an individual Ethernet PHY.
+
+
+Properties for the PIP nexus:
+- compatible: "cavium,octeon-3860-pip"
+
+  Compatibility with all cn3XXX, cn5XXX and cn6XXX SOCs.
+
+- reg: The base address of the PIP's register bank.
+
+- #address-cells: Must be <1>.
+
+- #size-cells: Must be <0>.
+
+Properties for PIP interfaces which is a child the PIP nexus:
+- compatible: "cavium,octeon-3860-pip-interface"
+
+  Compatibility with all cn3XXX, cn5XXX and cn6XXX SOCs.
+
+- reg: The interface number.
+
+- #address-cells: Must be <1>.
+
+- #size-cells: Must be <0>.
+
+Properties for PIP port which is a child the PIP interface:
+- compatible: "cavium,octeon-3860-pip-port"
+
+  Compatibility with all cn3XXX, cn5XXX and cn6XXX SOCs.
+
+- reg: The port number within the interface group.
+
+- mac-address: Optional, the MAC address to assign to the device.
+
+- local-mac-address: Optional, the MAC address to assign to the device
+  if mac-address is not specified.
+
+- phy-handle: Optional, a phandle for the PHY device connected to this device.
+
+Example:
+
+	pip@11800a0000000 {
+		compatible = "cavium,octeon-3860-pip";
+		#address-cells = <1>;
+		#size-cells = <0>;
+		reg = <0x11800 0xa0000000 0x0 0x2000>;
+
+		interface@0 {
+			compatible = "cavium,octeon-3860-pip-interface";
+			#address-cells = <1>;
+			#size-cells = <0>;
+			reg = <0>; /* interface */
+
+			ethernet@0 {
+				compatible = "cavium,octeon-3860-pip-port";
+				reg = <0x0>; /* Port */
+				local-mac-address = [ 00 0f b7 10 63 60 ];
+				phy-handle = <&phy2>;
+			};
+			ethernet@1 {
+				compatible = "cavium,octeon-3860-pip-port";
+				reg = <0x1>; /* Port */
+				local-mac-address = [ 00 0f b7 10 63 61 ];
+				phy-handle = <&phy3>;
+			};
+			ethernet@2 {
+				compatible = "cavium,octeon-3860-pip-port";
+				reg = <0x2>; /* Port */
+				local-mac-address = [ 00 0f b7 10 63 62 ];
+				phy-handle = <&phy4>;
+			};
+			ethernet@3 {
+				compatible = "cavium,octeon-3860-pip-port";
+				reg = <0x3>; /* Port */
+				local-mac-address = [ 00 0f b7 10 63 63 ];
+				phy-handle = <&phy5>;
+			};
+		};
+
+		interface@1 {
+			compatible = "cavium,octeon-3860-pip-interface";
+			#address-cells = <1>;
+			#size-cells = <0>;
+			reg = <1>; /* interface */
+
+			ethernet@0 {
+				compatible = "cavium,octeon-3860-pip-port";
+				reg = <0x0>; /* Port */
+				local-mac-address = [ 00 0f b7 10 63 64 ];
+				phy-handle = <&phy6>;
+			};
+		};
+	};
diff --git a/Documentation/devicetree/bindings/mips/cavium/twsi.txt b/Documentation/devicetree/bindings/mips/cavium/twsi.txt
new file mode 100644
index 0000000..6e57155
--- /dev/null
+++ b/Documentation/devicetree/bindings/mips/cavium/twsi.txt
@@ -0,0 +1,34 @@
+* Two Wire Serial Interface (TWSI) / I2C
+
+- compatible: "cavium,octeon-3860-twsi"
+
+  Compatibility with all cn3XXX, cn5XXX and cn6XXX SOCs.
+
+- reg: The base address of the TWSI/I2C bus controller register bank.
+
+- #address-cells: Must be <1>.
+
+- #size-cells: Must be <0>.  I2C addresses have no size component.
+
+- interrupts: A single interrupt specifier.
+
+- clock-rate: The I2C bus clock rate in Hz.
+
+Example:
+	twsi0: i2c@1180000001000 {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		compatible = "cavium,octeon-3860-twsi";
+		reg = <0x11800 0x00001000 0x0 0x200>;
+		interrupts = <0 45>;
+		clock-rate = <100000>;
+
+		rtc@68 {
+			compatible = "dallas,ds1337";
+			reg = <0x68>;
+		};
+		tmp@4c {
+			compatible = "ti,tmp421";
+			reg = <0x4c>;
+		};
+	};
diff --git a/Documentation/devicetree/bindings/mips/cavium/uart.txt b/Documentation/devicetree/bindings/mips/cavium/uart.txt
new file mode 100644
index 0000000..87a6c37
--- /dev/null
+++ b/Documentation/devicetree/bindings/mips/cavium/uart.txt
@@ -0,0 +1,19 @@
+* Universal Asynchronous Receiver/Transmitter (UART)
+
+- compatible: "cavium,octeon-3860-uart"
+
+  Compatibility with all cn3XXX, cn5XXX and cn6XXX SOCs.
+
+- reg: The base address of the UART register bank.
+
+- interrupts: A single interrupt specifier.
+
+- current-speed: Optional, the current bit rate in bits per second.
+
+Example:
+	uart1: serial@1180000000c00 {
+		compatible = "cavium,octeon-3860-uart","ns16550";
+		reg = <0x11800 0x00000c00 0x0 0x400>;
+		current-speed = <115200>;
+		interrupts = <0 35>;
+	};
diff --git a/Documentation/devicetree/bindings/mips/cavium/uctl.txt b/Documentation/devicetree/bindings/mips/cavium/uctl.txt
new file mode 100644
index 0000000..5dabe02
--- /dev/null
+++ b/Documentation/devicetree/bindings/mips/cavium/uctl.txt
@@ -0,0 +1,47 @@
+* UCTL USB controller glue
+
+Properties:
+- compatible: "cavium,octeon-6335-uctl"
+
+  Compatibility with all cn6XXX SOCs.
+
+- reg: The base address of the UCTL register bank.
+
+- #address-cells: Must be <2>.
+
+- #size-cells: Must be <2>.
+
+- ranges: Empty to signify direct mapping of the children.
+
+- refclk-frequency: A single cell containing the reference clock
+  frequency in Hz.
+
+- refclk-type: A string describing the reference clock connection
+  either "crystal" or "external".
+
+Example:
+	uctl@118006f000000 {
+		compatible = "cavium,octeon-6335-uctl";
+		reg = <0x11800 0x6f000000 0x0 0x100>;
+		ranges; /* Direct mapping */
+		#address-cells = <2>;
+		#size-cells = <2>;
+		/* 12MHz, 24MHz and 48MHz allowed */
+		refclk-frequency = <24000000>;
+		/* Either "crystal" or "external" */
+		refclk-type = "crystal";
+
+		ehci@16f0000000000 {
+			compatible = "cavium,octeon-6335-ehci","usb-ehci";
+			reg = <0x16f00 0x00000000 0x0 0x100>;
+			interrupts = <0 56>;
+			big-endian-regs;
+		};
+		ohci@16f0000000400 {
+			compatible = "cavium,octeon-6335-ohci","usb-ohci";
+			reg = <0x16f00 0x00000400 0x0 0x100>;
+			interrupts = <0 56>;
+			big-endian-regs;
+		};
+	};
+
diff --git a/arch/mips/cavium-octeon/.gitignore b/arch/mips/cavium-octeon/.gitignore
new file mode 100644
index 0000000..39c9686
--- /dev/null
+++ b/arch/mips/cavium-octeon/.gitignore
@@ -0,0 +1,2 @@
+*.dtb.S
+*.dtb
diff --git a/arch/mips/cavium-octeon/Makefile b/arch/mips/cavium-octeon/Makefile
index 19eb043..b8d4f63 100644
--- a/arch/mips/cavium-octeon/Makefile
+++ b/arch/mips/cavium-octeon/Makefile
@@ -15,3 +15,16 @@ obj-y += octeon-memcpy.o
 obj-y += executive/
 
 obj-$(CONFIG_SMP)                     += smp.o
+
+DTS_FILES = octeon_3xxx.dts
+DTB_FILES = $(patsubst %.dts, %.dtb, $(DTS_FILES))
+
+obj-y += $(patsubst %.dts, %.dtb.o, $(DTS_FILES))
+
+$(obj)/%.dtb: $(src)/%.dts
+	$(call cmd,dtc)
+
+# Let's keep the .dtb files around in case we want to look at them.
+.SECONDARY:  $(addprefix $(obj)/, $(DTB_FILES))
+
+clean-files += $(DTB_FILES) $(patsubst %.dtb, %.dtb.S, $(DTB_FILES))
diff --git a/arch/mips/cavium-octeon/octeon_3xxx.dts b/arch/mips/cavium-octeon/octeon_3xxx.dts
new file mode 100644
index 0000000..a6afd21
--- /dev/null
+++ b/arch/mips/cavium-octeon/octeon_3xxx.dts
@@ -0,0 +1,452 @@
+/dts-v1/;
+/*
+ * OCTEON 3XXX, 5XXX, 63XX device tree skeleton.
+ *
+ * This device tree is pruned and patched by early boot code before
+ * use.  Because of this, it contains a super-set of the available
+ * devices and properties.
+ */
+/ {
+	compatible = "cavium,octeon-3860";
+	#address-cells = <2>;
+	#size-cells = <2>;
+	interrupt-parent = <&ciu>;
+
+	soc@0 {
+		compatible = "simple-bus";
+		#address-cells = <2>;
+		#size-cells = <2>;
+		ranges; /* Direct mapping */
+
+		ciu: interrupt-controller@1070000000000 {
+			compatible = "cavium,octeon-3860-ciu";
+			interrupt-controller;
+			/* Interrupts are specified by two parts:
+			 * 1) Controller register (0 or 1)
+			 * 2) Bit within the register (0..63)
+			 */
+			#interrupt-cells = <2>;
+			reg = <0x10700 0x00000000 0x0 0x7000>;
+		};
+
+		gpio: gpio-controller@1070000000800 {
+			#gpio-cells = <2>;
+			compatible = "cavium,octeon-3860-gpio";
+			reg = <0x10700 0x00000800 0x0 0x100>;
+			gpio-controller;
+			/* Interrupts are specified by two parts:
+			 * 1) GPIO pin number (0..15)
+			 * 2) Triggering (1 - edge rising
+			 *		  2 - edge falling
+			 *		  4 - level active high
+			 *		  8 - level active low)
+			 */
+			interrupt-controller;
+			#interrupt-cells = <2>;
+			/* The GPIO pin connect to 16 consecutive CUI bits */
+			interrupts = <0 16>; /* <0 17> <0 18> <0 19>
+				     <0 20> <0 21> <0 22> <0 23>
+				     <0 24> <0 25> <0 26> <0 27>
+				     <0 28> <0 29> <0 30> <0 31>; */
+		};
+
+		smi0: mdio@1180000001800 {
+			compatible = "cavium,octeon-3860-mdio";
+			#address-cells = <1>;
+			#size-cells = <0>;
+			reg = <0x11800 0x00001800 0x0 0x40>;
+
+			phy0: ethernet-phy@0 {
+				compatible = "broadcom,bcm5241";
+				reg = <0>;
+			};
+
+			phy1: ethernet-phy@1 {
+				compatible = "broadcom,bcm5241";
+				reg = <1>;
+			};
+
+			phy2: ethernet-phy@2 {
+				reg = <2>;
+				compatible = "marvell,88e1149r";
+				marvell,reg-init = <3 0x10 0 0x5777>,
+					<3 0x11 0 0x00aa>,
+					<3 0x12 0 0x4105>,
+					<3 0x13 0 0x0a60>;
+			};
+			phy3: ethernet-phy@3 {
+				reg = <3>;
+				compatible = "marvell,88e1149r";
+				marvell,reg-init = <3 0x10 0 0x5777>,
+					<3 0x11 0 0x00aa>,
+					<3 0x12 0 0x4105>,
+					<3 0x13 0 0x0a60>;
+			};
+			phy4: ethernet-phy@4 {
+				reg = <4>;
+				compatible = "marvell,88e1149r";
+				marvell,reg-init = <3 0x10 0 0x5777>,
+					<3 0x11 0 0x00aa>,
+					<3 0x12 0 0x4105>,
+					<3 0x13 0 0x0a60>;
+			};
+			phy5: ethernet-phy@5 {
+				reg = <5>;
+				compatible = "marvell,88e1149r";
+				marvell,reg-init = <3 0x10 0 0x5777>,
+					<3 0x11 0 0x00aa>,
+					<3 0x12 0 0x4105>,
+					<3 0x13 0 0x0a60>;
+			};
+
+			phy6: ethernet-phy@6 {
+				reg = <6>;
+				compatible = "marvell,88e1149r";
+				marvell,reg-init = <3 0x10 0 0x5777>,
+					<3 0x11 0 0x00aa>,
+					<3 0x12 0 0x4105>,
+					<3 0x13 0 0x0a60>;
+			};
+			phy7: ethernet-phy@7 {
+				reg = <7>;
+				compatible = "marvell,88e1149r";
+				marvell,reg-init = <3 0x10 0 0x5777>,
+					<3 0x11 0 0x00aa>,
+					<3 0x12 0 0x4105>,
+					<3 0x13 0 0x0a60>;
+			};
+			phy8: ethernet-phy@8 {
+				reg = <8>;
+				compatible = "marvell,88e1149r";
+				marvell,reg-init = <3 0x10 0 0x5777>,
+					<3 0x11 0 0x00aa>,
+					<3 0x12 0 0x4105>,
+					<3 0x13 0 0x0a60>;
+			};
+			phy9: ethernet-phy@9 {
+				reg = <9>;
+				compatible = "marvell,88e1149r";
+				marvell,reg-init = <3 0x10 0 0x5777>,
+					<3 0x11 0 0x00aa>,
+					<3 0x12 0 0x4105>,
+					<3 0x13 0 0x0a60>;
+			};
+		};
+
+		smi1: mdio@1180000001900 {
+			compatible = "cavium,octeon-3860-mdio";
+			#address-cells = <1>;
+			#size-cells = <0>;
+			reg = <0x11800 0x00001900 0x0 0x40>;
+		};
+
+		mix0: ethernet@1070000100000 {
+			compatible = "cavium,octeon-5750-mix";
+			reg = <0x10700 0x00100000 0x0 0x100>, /* MIX */
+			      <0x11800 0xE0000000 0x0 0x300>, /* AGL */
+			      <0x11800 0xE0000400 0x0 0x400>, /* AGL_SHARED  */
+			      <0x11800 0xE0002000 0x0 0x8>;   /* AGL_PRT_CTL */
+			cell-index = <0>;
+			interrupts = <0 62>, <1 46>;
+			local-mac-address = [ 00 00 00 00 00 00 ];
+			phy-handle = <&phy0>;
+		};
+
+		mix1: ethernet@1070000100800 {
+			compatible = "cavium,octeon-5750-mix";
+			reg = <0x10700 0x00100800 0x0 0x100>, /* MIX */
+			      <0x11800 0xE0000800 0x0 0x300>, /* AGL */
+			      <0x11800 0xE0000400 0x0 0x400>, /* AGL_SHARED  */
+			      <0x11800 0xE0002008 0x0 0x8>;   /* AGL_PRT_CTL */
+			cell-index = <1>;
+			interrupts = <1 18>, < 1 46>;
+			local-mac-address = [ 00 00 00 00 00 00 ];
+			phy-handle = <&phy1>;
+		};
+
+		pip: pip@11800a0000000 {
+			compatible = "cavium,octeon-3860-pip";
+			#address-cells = <1>;
+			#size-cells = <0>;
+			reg = <0x11800 0xa0000000 0x0 0x2000>;
+
+			interface@0 {
+				compatible = "cavium,octeon-3860-pip-interface";
+				#address-cells = <1>;
+				#size-cells = <0>;
+				reg = <0>; /* interface */
+
+				ethernet@0 {
+					compatible = "cavium,octeon-3860-pip-port";
+					reg = <0x0>; /* Port */
+					local-mac-address = [ 00 00 00 00 00 00 ];
+					phy-handle = <&phy2>;
+				};
+				ethernet@1 {
+					compatible = "cavium,octeon-3860-pip-port";
+					reg = <0x1>; /* Port */
+					local-mac-address = [ 00 00 00 00 00 00 ];
+					phy-handle = <&phy3>;
+				};
+				ethernet@2 {
+					compatible = "cavium,octeon-3860-pip-port";
+					reg = <0x2>; /* Port */
+					local-mac-address = [ 00 00 00 00 00 00 ];
+					phy-handle = <&phy4>;
+				};
+				ethernet@3 {
+					compatible = "cavium,octeon-3860-pip-port";
+					reg = <0x3>; /* Port */
+					local-mac-address = [ 00 00 00 00 00 00 ];
+					phy-handle = <&phy5>;
+				};
+				ethernet@4 {
+					compatible = "cavium,octeon-3860-pip-port";
+					reg = <0x4>; /* Port */
+					local-mac-address = [ 00 00 00 00 00 00 ];
+				};
+				ethernet@5 {
+					compatible = "cavium,octeon-3860-pip-port";
+					reg = <0x5>; /* Port */
+					local-mac-address = [ 00 00 00 00 00 00 ];
+				};
+				ethernet@6 {
+					compatible = "cavium,octeon-3860-pip-port";
+					reg = <0x6>; /* Port */
+					local-mac-address = [ 00 00 00 00 00 00 ];
+				};
+				ethernet@7 {
+					compatible = "cavium,octeon-3860-pip-port";
+					reg = <0x7>; /* Port */
+					local-mac-address = [ 00 00 00 00 00 00 ];
+				};
+				ethernet@8 {
+					compatible = "cavium,octeon-3860-pip-port";
+					reg = <0x8>; /* Port */
+					local-mac-address = [ 00 00 00 00 00 00 ];
+				};
+				ethernet@9 {
+					compatible = "cavium,octeon-3860-pip-port";
+					reg = <0x9>; /* Port */
+					local-mac-address = [ 00 00 00 00 00 00 ];
+				};
+				ethernet@a {
+					compatible = "cavium,octeon-3860-pip-port";
+					reg = <0xa>; /* Port */
+					local-mac-address = [ 00 00 00 00 00 00 ];
+				};
+				ethernet@b {
+					compatible = "cavium,octeon-3860-pip-port";
+					reg = <0xb>; /* Port */
+					local-mac-address = [ 00 00 00 00 00 00 ];
+				};
+				ethernet@c {
+					compatible = "cavium,octeon-3860-pip-port";
+					reg = <0xc>; /* Port */
+					local-mac-address = [ 00 00 00 00 00 00 ];
+				};
+				ethernet@d {
+					compatible = "cavium,octeon-3860-pip-port";
+					reg = <0xd>; /* Port */
+					local-mac-address = [ 00 00 00 00 00 00 ];
+				};
+				ethernet@e {
+					compatible = "cavium,octeon-3860-pip-port";
+					reg = <0xe>; /* Port */
+					local-mac-address = [ 00 00 00 00 00 00 ];
+				};
+				ethernet@f {
+					compatible = "cavium,octeon-3860-pip-port";
+					reg = <0xf>; /* Port */
+					local-mac-address = [ 00 00 00 00 00 00 ];
+				};
+			};
+
+			interface@1 {
+				compatible = "cavium,octeon-3860-pip-interface";
+				#address-cells = <1>;
+				#size-cells = <0>;
+				reg = <1>; /* interface */
+
+				ethernet@0 {
+					compatible = "cavium,octeon-3860-pip-port";
+					reg = <0x0>; /* Port */
+					local-mac-address = [ 00 00 00 00 00 00 ];
+					phy-handle = <&phy6>;
+				};
+				ethernet@1 {
+					compatible = "cavium,octeon-3860-pip-port";
+					reg = <0x1>; /* Port */
+					local-mac-address = [ 00 00 00 00 00 00 ];
+					phy-handle = <&phy7>;
+				};
+				ethernet@2 {
+					compatible = "cavium,octeon-3860-pip-port";
+					reg = <0x2>; /* Port */
+					local-mac-address = [ 00 00 00 00 00 00 ];
+					phy-handle = <&phy8>;
+				};
+				ethernet@3 {
+					compatible = "cavium,octeon-3860-pip-port";
+					reg = <0x3>; /* Port */
+					local-mac-address = [ 00 00 00 00 00 00 ];
+					phy-handle = <&phy9>;
+				};
+			};
+		};
+
+		twsi0: i2c@1180000001000 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			compatible = "cavium,octeon-3860-twsi";
+			reg = <0x11800 0x00001000 0x0 0x200>;
+			interrupts = <0 45>;
+			clock-rate = <100000>;
+
+			rtc@68 {
+				compatible = "dallas,ds1337";
+				reg = <0x68>;
+			};
+			tmp@4c {
+				compatible = "ti,tmp421";
+				reg = <0x4c>;
+			};
+		};
+
+		twsi1: i2c@1180000001200 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			compatible = "cavium,octeon-3860-twsi";
+			reg = <0x11800 0x00001200 0x0 0x200>;
+			interrupts = <0 59>;
+			clock-rate = <100000>;
+		};
+
+		uart0: serial@1180000000800 {
+			compatible = "cavium,octeon-3860-uart","ns16550";
+			reg = <0x11800 0x00000800 0x0 0x400>;
+			clock-frequency = <0>;
+			current-speed = <115200>;
+			reg-shift = <3>;
+			interrupts = <0 34>;
+		};
+
+		uart1: serial@1180000000c00 {
+			compatible = "cavium,octeon-3860-uart","ns16550";
+			reg = <0x11800 0x00000c00 0x0 0x400>;
+			clock-frequency = <0>;
+			current-speed = <115200>;
+			reg-shift = <3>;
+			interrupts = <0 35>;
+		};
+
+		uart2: serial@1180000000400 {
+			compatible = "cavium,octeon-3860-uart","ns16550";
+			reg = <0x11800 0x00000400 0x0 0x400>;
+			clock-frequency = <0>;
+			current-speed = <115200>;
+			reg-shift = <3>;
+			interrupts = <1 16>;
+		};
+
+		bootbus: bootbus@1180000000000 {
+			compatible = "cavium,octeon-3860-bootbus";
+			reg = <0x11800 0x00000000 0x0 0x200>;
+			/* The chip select number and offset */
+			#address-cells = <2>;
+			/* The size of the chip select region */
+			#size-cells = <1>;
+			ranges = <0 0  0x0 0x1f400000  0xc00000>,
+				 <1 0  0x10000 0x30000000  0>,
+				 <2 0  0x10000 0x40000000  0>,
+				 <3 0  0x10000 0x50000000  0>,
+				 <4 0  0x0 0x1d020000  0x10000>,
+				 <5 0  0x0 0x1d040000  0x10000>,
+				 <6 0  0x0 0x1d050000  0x10000>,
+				 <7 0  0x10000 0x90000000  0>;
+
+			t-adr    = <20 0 0 0 320   5   5 0>;
+			t-ce     = <60 0 0 0 320 300 300 0>;
+			t-oe     = <60 0 0 0 320 125 270 0>;
+			t-we     = <45 0 0 0 320 150 150 0>;
+			t-rd-hld = <35 0 0 0 320 100 100 0>;
+			t-wr-hld = <45 0 0 0 320  30  70 0>;
+			t-pause  = < 0 0 0 0 320   0   0 0>;
+			t-wait   = < 0 0 0 0 320  30   0 0>;
+			t-page   = <35 0 0 0 320 320 320 0>;
+			t-rd-dly = < 0 0 0 0   0   0   0 0>;
+
+			pages     = <0 0 0 0 0  0  0 0>;
+			wait-mode = <0 0 0 0 0  1  0 0>;
+			page-mode = <0 0 0 0 0  0  0 0>;
+			bus-width = <8 8 8 8 8 16 16 8>;
+			ale-mode  = <0 0 0 0 0  0  0 0>;
+			sam-mode  = <0 0 0 0 0  0  0 0>;
+
+			flash0: nor@0,0 {
+				compatible = "cfi-flash";
+				reg = <0 0 0x800000>;
+				#address-cells = <1>;
+				#size-cells = <1>;
+			};
+
+			compact-flash@5,0 {
+				compatible = "cavium,ebt3000-compact-flash";
+				reg = <5 0 0x10000>, <6 0 0x10000>;
+				bus-width = <16>;
+				true-ide = <1>;
+				dma-engine-handle = <&dma0>; 
+			};
+		};
+
+		dma0: dma-engine@1180000000100 {
+			compatible = "cavium,octeon-5750-bootbus-dma";
+			reg = <0x11800 0x00000100 0x0 0x8>;
+			interrupts = <0 63>;
+		};
+		dma1: dma-engine@1180000000108 {
+			compatible = "cavium,octeon-5750-bootbus-dma";
+			reg = <0x11800 0x00000108 0x0 0x8>;
+			interrupts = <0 63>;
+		};
+
+		uctl: uctl@118006f000000 {
+			compatible = "cavium,octeon-6335-uctl";
+			reg = <0x11800 0x6f000000 0x0 0x100>;
+			ranges; /* Direct mapping */
+			#address-cells = <2>;
+			#size-cells = <2>;
+			/* 12MHz, 24MHz and 48MHz allowed */
+			refclk-frequency = <24000000>;
+			/* Either "crystal" or "external" */
+			refclk-type = "crystal";
+
+			ehci@16f0000000000 {
+				compatible = "cavium,octeon-6335-ehci","usb-ehci";
+				reg = <0x16f00 0x00000000 0x0 0x100>;
+				interrupts = <0 56>;
+				big-endian-regs;
+			};
+			ohci@16f0000000400 {
+				compatible = "cavium,octeon-6335-ohci","usb-ohci";
+				reg = <0x16f00 0x00000400 0x0 0x100>;
+				interrupts = <0 56>;
+				big-endian-regs;
+			};
+		};
+	};
+
+	aliases {
+		mix0 = &mix0;
+		mix1 = &mix1;
+		pip = &pip;
+		smi0 = &smi0;
+		smi1 = &smi1;
+		twsi0 = &twsi0;
+		twsi1 = &twsi1;
+		uart0 = &uart0;
+		uart1 = &uart1;
+		uart2 = &uart2;
+		flash0 = &flash0;
+	};
+ };
-- 
1.7.2.3

