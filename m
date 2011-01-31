Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756165Ab1AaUUK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 15:20:10 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:48533 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754248Ab1AaUT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 15:19:58 -0500
Subject: [PATCH v3 1/3] dt: Move device tree documentation out of powerpc
	directory
To: devicetree-discuss@lists.ozlabs.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
From: Grant Likely <grant.likely@secretlab.ca>
Cc: benh@kernel.crashing.org, jwboyer@linux.vnet.ibm.com, sam@ravnborg.org
Date: Mon, 31 Jan 2011 13:19:43 -0700
Message-ID: <20110131201941.12434.11171.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The device tree is used by more than just PowerPC.  Make the documentation
directory available to all.

v2: reorganized files while moving to create arch and driver specific
    directories.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Acked-by: Josh Boyer <jwboyer@linux.vnet.ibm.com>
---
 Documentation/devicetree/bindings/ata/fsl-sata.txt |   29 
 Documentation/devicetree/bindings/eeprom.txt       |   28 
 .../devicetree/bindings/gpio/8xxx_gpio.txt         |   60 +
 Documentation/devicetree/bindings/gpio/gpio.txt    |   50 +
 Documentation/devicetree/bindings/gpio/led.txt     |   58 +
 Documentation/devicetree/bindings/i2c/fsl-i2c.txt  |   64 +
 Documentation/devicetree/bindings/marvell.txt      |  521 +++++++
 .../devicetree/bindings/mmc/fsl-esdhc.txt          |   29 
 .../devicetree/bindings/mmc/mmc-spi-slot.txt       |   23 
 .../devicetree/bindings/mtd/fsl-upm-nand.txt       |   63 +
 .../devicetree/bindings/mtd/mtd-physmap.txt        |   90 +
 .../devicetree/bindings/net/can/mpc5xxx-mscan.txt  |   53 +
 .../devicetree/bindings/net/can/sja1000.txt        |   53 +
 .../devicetree/bindings/net/fsl-tsec-phy.txt       |   76 +
 .../devicetree/bindings/net/mdio-gpio.txt          |   19 
 Documentation/devicetree/bindings/net/phy.txt      |   25 
 .../devicetree/bindings/pci/83xx-512x-pci.txt      |   40 +
 .../devicetree/bindings/powerpc/4xx/cpm.txt        |   52 +
 .../devicetree/bindings/powerpc/4xx/emac.txt       |  148 ++
 .../devicetree/bindings/powerpc/4xx/ndfc.txt       |   39 +
 .../bindings/powerpc/4xx/ppc440spe-adma.txt        |   93 +
 .../devicetree/bindings/powerpc/4xx/reboot.txt     |   18 
 .../devicetree/bindings/powerpc/fsl/board.txt      |   63 +
 .../devicetree/bindings/powerpc/fsl/cpm_qe/cpm.txt |   67 +
 .../bindings/powerpc/fsl/cpm_qe/cpm/brg.txt        |   21 
 .../bindings/powerpc/fsl/cpm_qe/cpm/i2c.txt        |   41 +
 .../bindings/powerpc/fsl/cpm_qe/cpm/pic.txt        |   18 
 .../bindings/powerpc/fsl/cpm_qe/cpm/usb.txt        |   15 
 .../bindings/powerpc/fsl/cpm_qe/gpio.txt           |   38 +
 .../bindings/powerpc/fsl/cpm_qe/network.txt        |   45 +
 .../devicetree/bindings/powerpc/fsl/cpm_qe/qe.txt  |  115 ++
 .../bindings/powerpc/fsl/cpm_qe/qe/firmware.txt    |   24 
 .../bindings/powerpc/fsl/cpm_qe/qe/par_io.txt      |   51 +
 .../bindings/powerpc/fsl/cpm_qe/qe/pincfg.txt      |   60 +
 .../bindings/powerpc/fsl/cpm_qe/qe/ucc.txt         |   70 +
 .../bindings/powerpc/fsl/cpm_qe/qe/usb.txt         |   37 +
 .../bindings/powerpc/fsl/cpm_qe/serial.txt         |   32 
 .../devicetree/bindings/powerpc/fsl/diu.txt        |   34 
 .../devicetree/bindings/powerpc/fsl/dma.txt        |  144 ++
 .../devicetree/bindings/powerpc/fsl/ecm.txt        |   64 +
 .../devicetree/bindings/powerpc/fsl/gtm.txt        |   31 
 .../devicetree/bindings/powerpc/fsl/guts.txt       |   25 
 .../devicetree/bindings/powerpc/fsl/lbc.txt        |   35 
 .../devicetree/bindings/powerpc/fsl/mcm.txt        |   64 +
 .../bindings/powerpc/fsl/mcu-mpc8349emitx.txt      |   17 
 .../bindings/powerpc/fsl/mpc5121-psc.txt           |   70 +
 .../devicetree/bindings/powerpc/fsl/mpc5200.txt    |  198 +++
 .../devicetree/bindings/powerpc/fsl/mpic.txt       |   42 +
 .../devicetree/bindings/powerpc/fsl/msi-pic.txt    |   36 
 .../devicetree/bindings/powerpc/fsl/pmc.txt        |   63 +
 .../devicetree/bindings/powerpc/fsl/sec.txt        |   68 +
 .../devicetree/bindings/powerpc/fsl/ssi.txt        |   73 +
 .../bindings/powerpc/nintendo/gamecube.txt         |  109 ++
 .../devicetree/bindings/powerpc/nintendo/wii.txt   |  184 +++
 Documentation/devicetree/bindings/spi/fsl-spi.txt  |   53 +
 Documentation/devicetree/bindings/spi/spi-bus.txt  |   57 +
 Documentation/devicetree/bindings/usb/fsl-usb.txt  |   81 +
 Documentation/devicetree/bindings/usb/usb-ehci.txt |   25 
 Documentation/devicetree/bindings/xilinx.txt       |  306 ++++
 Documentation/devicetree/booting-without-of.txt    | 1447 ++++++++++++++++++++
 Documentation/powerpc/booting-without-of.txt       | 1447 --------------------
 Documentation/powerpc/dts-bindings/4xx/cpm.txt     |   52 -
 Documentation/powerpc/dts-bindings/4xx/emac.txt    |  148 --
 Documentation/powerpc/dts-bindings/4xx/ndfc.txt    |   39 -
 .../powerpc/dts-bindings/4xx/ppc440spe-adma.txt    |   93 -
 Documentation/powerpc/dts-bindings/4xx/reboot.txt  |   18 
 Documentation/powerpc/dts-bindings/can/sja1000.txt |   53 -
 Documentation/powerpc/dts-bindings/ecm.txt         |   64 -
 Documentation/powerpc/dts-bindings/eeprom.txt      |   28 
 .../powerpc/dts-bindings/fsl/83xx-512x-pci.txt     |   40 -
 .../powerpc/dts-bindings/fsl/8xxx_gpio.txt         |   60 -
 Documentation/powerpc/dts-bindings/fsl/board.txt   |   63 -
 Documentation/powerpc/dts-bindings/fsl/can.txt     |   53 -
 .../powerpc/dts-bindings/fsl/cpm_qe/cpm.txt        |   67 -
 .../powerpc/dts-bindings/fsl/cpm_qe/cpm/brg.txt    |   21 
 .../powerpc/dts-bindings/fsl/cpm_qe/cpm/i2c.txt    |   41 -
 .../powerpc/dts-bindings/fsl/cpm_qe/cpm/pic.txt    |   18 
 .../powerpc/dts-bindings/fsl/cpm_qe/cpm/usb.txt    |   15 
 .../powerpc/dts-bindings/fsl/cpm_qe/gpio.txt       |   38 -
 .../powerpc/dts-bindings/fsl/cpm_qe/network.txt    |   45 -
 .../powerpc/dts-bindings/fsl/cpm_qe/qe.txt         |  115 --
 .../dts-bindings/fsl/cpm_qe/qe/firmware.txt        |   24 
 .../powerpc/dts-bindings/fsl/cpm_qe/qe/par_io.txt  |   51 -
 .../powerpc/dts-bindings/fsl/cpm_qe/qe/pincfg.txt  |   60 -
 .../powerpc/dts-bindings/fsl/cpm_qe/qe/ucc.txt     |   70 -
 .../powerpc/dts-bindings/fsl/cpm_qe/qe/usb.txt     |   37 -
 .../powerpc/dts-bindings/fsl/cpm_qe/serial.txt     |   32 
 Documentation/powerpc/dts-bindings/fsl/diu.txt     |   34 
 Documentation/powerpc/dts-bindings/fsl/dma.txt     |  144 --
 Documentation/powerpc/dts-bindings/fsl/esdhc.txt   |   29 
 Documentation/powerpc/dts-bindings/fsl/gtm.txt     |   31 
 Documentation/powerpc/dts-bindings/fsl/guts.txt    |   25 
 Documentation/powerpc/dts-bindings/fsl/i2c.txt     |   64 -
 Documentation/powerpc/dts-bindings/fsl/lbc.txt     |   35 
 Documentation/powerpc/dts-bindings/fsl/mcm.txt     |   64 -
 .../powerpc/dts-bindings/fsl/mcu-mpc8349emitx.txt  |   17 
 .../powerpc/dts-bindings/fsl/mpc5121-psc.txt       |   70 -
 Documentation/powerpc/dts-bindings/fsl/mpc5200.txt |  198 ---
 Documentation/powerpc/dts-bindings/fsl/mpic.txt    |   42 -
 Documentation/powerpc/dts-bindings/fsl/msi-pic.txt |   36 
 Documentation/powerpc/dts-bindings/fsl/pmc.txt     |   63 -
 Documentation/powerpc/dts-bindings/fsl/sata.txt    |   29 
 Documentation/powerpc/dts-bindings/fsl/sec.txt     |   68 -
 Documentation/powerpc/dts-bindings/fsl/spi.txt     |   53 -
 Documentation/powerpc/dts-bindings/fsl/ssi.txt     |   73 -
 Documentation/powerpc/dts-bindings/fsl/tsec.txt    |   76 -
 .../powerpc/dts-bindings/fsl/upm-nand.txt          |   63 -
 Documentation/powerpc/dts-bindings/fsl/usb.txt     |   81 -
 Documentation/powerpc/dts-bindings/gpio/gpio.txt   |   50 -
 Documentation/powerpc/dts-bindings/gpio/led.txt    |   58 -
 Documentation/powerpc/dts-bindings/gpio/mdio.txt   |   19 
 Documentation/powerpc/dts-bindings/marvell.txt     |  521 -------
 .../powerpc/dts-bindings/mmc-spi-slot.txt          |   23 
 Documentation/powerpc/dts-bindings/mtd-physmap.txt |   90 -
 .../powerpc/dts-bindings/nintendo/gamecube.txt     |  109 --
 .../powerpc/dts-bindings/nintendo/wii.txt          |  184 ---
 Documentation/powerpc/dts-bindings/phy.txt         |   25 
 Documentation/powerpc/dts-bindings/spi-bus.txt     |   57 -
 Documentation/powerpc/dts-bindings/usb-ehci.txt    |   25 
 Documentation/powerpc/dts-bindings/xilinx.txt      |  306 ----
 120 files changed, 5554 insertions(+), 5554 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/ata/fsl-sata.txt
 create mode 100644 Documentation/devicetree/bindings/eeprom.txt
 create mode 100644 Documentation/devicetree/bindings/gpio/8xxx_gpio.txt
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio.txt
 create mode 100644 Documentation/devicetree/bindings/gpio/led.txt
 create mode 100644 Documentation/devicetree/bindings/i2c/fsl-i2c.txt
 create mode 100644 Documentation/devicetree/bindings/marvell.txt
 create mode 100644 Documentation/devicetree/bindings/mmc/fsl-esdhc.txt
 create mode 100644 Documentation/devicetree/bindings/mmc/mmc-spi-slot.txt
 create mode 100644 Documentation/devicetree/bindings/mtd/fsl-upm-nand.txt
 create mode 100644 Documentation/devicetree/bindings/mtd/mtd-physmap.txt
 create mode 100644 Documentation/devicetree/bindings/net/can/mpc5xxx-mscan.txt
 create mode 100644 Documentation/devicetree/bindings/net/can/sja1000.txt
 create mode 100644 Documentation/devicetree/bindings/net/fsl-tsec-phy.txt
 create mode 100644 Documentation/devicetree/bindings/net/mdio-gpio.txt
 create mode 100644 Documentation/devicetree/bindings/net/phy.txt
 create mode 100644 Documentation/devicetree/bindings/pci/83xx-512x-pci.txt
 create mode 100644 Documentation/devicetree/bindings/powerpc/4xx/cpm.txt
 create mode 100644 Documentation/devicetree/bindings/powerpc/4xx/emac.txt
 create mode 100644 Documentation/devicetree/bindings/powerpc/4xx/ndfc.txt
 create mode 100644 Documentation/devicetree/bindings/powerpc/4xx/ppc440spe-adma.txt
 create mode 100644 Documentation/devicetree/bindings/powerpc/4xx/reboot.txt
 create mode 100644 Documentation/devicetree/bindings/powerpc/fsl/board.txt
 create mode 100644 Documentation/devicetree/bindings/powerpc/fsl/cpm_qe/cpm.txt
 create mode 100644 Documentation/devicetree/bindings/powerpc/fsl/cpm_qe/cpm/brg.txt
 create mode 100644 Documentation/devicetree/bindings/powerpc/fsl/cpm_qe/cpm/i2c.txt
 create mode 100644 Documentation/devicetree/bindings/powerpc/fsl/cpm_qe/cpm/pic.txt
 create mode 100644 Documentation/devicetree/bindings/powerpc/fsl/cpm_qe/cpm/usb.txt
 create mode 100644 Documentation/devicetree/bindings/powerpc/fsl/cpm_qe/gpio.txt
 create mode 100644 Documentation/devicetree/bindings/powerpc/fsl/cpm_qe/network.txt
 create mode 100644 Documentation/devicetree/bindings/powerpc/fsl/cpm_qe/qe.txt
 create mode 100644 Documentation/devicetree/bindings/powerpc/fsl/cpm_qe/qe/firmware.txt
 create mode 100644 Documentation/devicetree/bindings/powerpc/fsl/cpm_qe/qe/par_io.txt
 create mode 100644 Documentation/devicetree/bindings/powerpc/fsl/cpm_qe/qe/pincfg.txt
 create mode 100644 Documentation/devicetree/bindings/powerpc/fsl/cpm_qe/qe/ucc.txt
 create mode 100644 Documentation/devicetree/bindings/powerpc/fsl/cpm_qe/qe/usb.txt
 create mode 100644 Documentation/devicetree/bindings/powerpc/fsl/cpm_qe/serial.txt
 create mode 100644 Documentation/devicetree/bindings/powerpc/fsl/diu.txt
 create mode 100644 Documentation/devicetree/bindings/powerpc/fsl/dma.txt
 create mode 100644 Documentation/devicetree/bindings/powerpc/fsl/ecm.txt
 create mode 100644 Documentation/devicetree/bindings/powerpc/fsl/gtm.txt
 create mode 100644 Documentation/devicetree/bindings/powerpc/fsl/guts.txt
 create mode 100644 Documentation/devicetree/bindings/powerpc/fsl/lbc.txt
 create mode 100644 Documentation/devicetree/bindings/powerpc/fsl/mcm.txt
 create mode 100644 Documentation/devicetree/bindings/powerpc/fsl/mcu-mpc8349emitx.txt
 create mode 100644 Documentation/devicetree/bindings/powerpc/fsl/mpc5121-psc.txt
 create mode 100644 Documentation/devicetree/bindings/powerpc/fsl/mpc5200.txt
 create mode 100644 Documentation/devicetree/bindings/powerpc/fsl/mpic.txt
 create mode 100644 Documentation/devicetree/bindings/powerpc/fsl/msi-pic.txt
 create mode 100644 Documentation/devicetree/bindings/powerpc/fsl/pmc.txt
 create mode 100644 Documentation/devicetree/bindings/powerpc/fsl/sec.txt
 create mode 100644 Documentation/devicetree/bindings/powerpc/fsl/ssi.txt
 create mode 100644 Documentation/devicetree/bindings/powerpc/nintendo/gamecube.txt
 create mode 100644 Documentation/devicetree/bindings/powerpc/nintendo/wii.txt
 create mode 100644 Documentation/devicetree/bindings/spi/fsl-spi.txt
 create mode 100644 Documentation/devicetree/bindings/spi/spi-bus.txt
 create mode 100644 Documentation/devicetree/bindings/usb/fsl-usb.txt
 create mode 100644 Documentation/devicetree/bindings/usb/usb-ehci.txt
 create mode 100644 Documentation/devicetree/bindings/xilinx.txt
 create mode 100644 Documentation/devicetree/booting-without-of.txt
 delete mode 100644 Documentation/powerpc/booting-without-of.txt
 delete mode 100644 Documentation/powerpc/dts-bindings/4xx/cpm.txt
 delete mode 100644 Documentation/powerpc/dts-bindings/4xx/emac.txt
 delete mode 100644 Documentation/powerpc/dts-bindings/4xx/ndfc.txt
 delete mode 100644 Documentation/powerpc/dts-bindings/4xx/ppc440spe-adma.txt
 delete mode 100644 Documentation/powerpc/dts-bindings/4xx/reboot.txt
 delete mode 100644 Documentation/powerpc/dts-bindings/can/sja1000.txt
 delete mode 100644 Documentation/powerpc/dts-bindings/ecm.txt
 delete mode 100644 Documentation/powerpc/dts-bindings/eeprom.txt
 delete mode 100644 Documentation/powerpc/dts-bindings/fsl/83xx-512x-pci.txt
 delete mode 100644 Documentation/powerpc/dts-bindings/fsl/8xxx_gpio.txt
 delete mode 100644 Documentation/powerpc/dts-bindings/fsl/board.txt
 delete mode 100644 Documentation/powerpc/dts-bindings/fsl/can.txt
 delete mode 100644 Documentation/powerpc/dts-bindings/fsl/cpm_qe/cpm.txt
 delete mode 100644 Documentation/powerpc/dts-bindings/fsl/cpm_qe/cpm/brg.txt
 delete mode 100644 Documentation/powerpc/dts-bindings/fsl/cpm_qe/cpm/i2c.txt
 delete mode 100644 Documentation/powerpc/dts-bindings/fsl/cpm_qe/cpm/pic.txt
 delete mode 100644 Documentation/powerpc/dts-bindings/fsl/cpm_qe/cpm/usb.txt
 delete mode 100644 Documentation/powerpc/dts-bindings/fsl/cpm_qe/gpio.txt
 delete mode 100644 Documentation/powerpc/dts-bindings/fsl/cpm_qe/network.txt
 delete mode 100644 Documentation/powerpc/dts-bindings/fsl/cpm_qe/qe.txt
 delete mode 100644 Documentation/powerpc/dts-bindings/fsl/cpm_qe/qe/firmware.txt
 delete mode 100644 Documentation/powerpc/dts-bindings/fsl/cpm_qe/qe/par_io.txt
 delete mode 100644 Documentation/powerpc/dts-bindings/fsl/cpm_qe/qe/pincfg.txt
 delete mode 100644 Documentation/powerpc/dts-bindings/fsl/cpm_qe/qe/ucc.txt
 delete mode 100644 Documentation/powerpc/dts-bindings/fsl/cpm_qe/qe/usb.txt
 delete mode 100644 Documentation/powerpc/dts-bindings/fsl/cpm_qe/serial.txt
 delete mode 100644 Documentation/powerpc/dts-bindings/fsl/diu.txt
 delete mode 100644 Documentation/powerpc/dts-bindings/fsl/dma.txt
 delete mode 100644 Documentation/powerpc/dts-bindings/fsl/esdhc.txt
 delete mode 100644 Documentation/powerpc/dts-bindings/fsl/gtm.txt
 delete mode 100644 Documentation/powerpc/dts-bindings/fsl/guts.txt
 delete mode 100644 Documentation/powerpc/dts-bindings/fsl/i2c.txt
 delete mode 100644 Documentation/powerpc/dts-bindings/fsl/lbc.txt
 delete mode 100644 Documentation/powerpc/dts-bindings/fsl/mcm.txt
 delete mode 100644 Documentation/powerpc/dts-bindings/fsl/mcu-mpc8349emitx.txt
 delete mode 100644 Documentation/powerpc/dts-bindings/fsl/mpc5121-psc.txt
 delete mode 100644 Documentation/powerpc/dts-bindings/fsl/mpc5200.txt
 delete mode 100644 Documentation/powerpc/dts-bindings/fsl/mpic.txt
 delete mode 100644 Documentation/powerpc/dts-bindings/fsl/msi-pic.txt
 delete mode 100644 Documentation/powerpc/dts-bindings/fsl/pmc.txt
 delete mode 100644 Documentation/powerpc/dts-bindings/fsl/sata.txt
 delete mode 100644 Documentation/powerpc/dts-bindings/fsl/sec.txt
 delete mode 100644 Documentation/powerpc/dts-bindings/fsl/spi.txt
 delete mode 100644 Documentation/powerpc/dts-bindings/fsl/ssi.txt
 delete mode 100644 Documentation/powerpc/dts-bindings/fsl/tsec.txt
 delete mode 100644 Documentation/powerpc/dts-bindings/fsl/upm-nand.txt
 delete mode 100644 Documentation/powerpc/dts-bindings/fsl/usb.txt
 delete mode 100644 Documentation/powerpc/dts-bindings/gpio/gpio.txt
 delete mode 100644 Documentation/powerpc/dts-bindings/gpio/led.txt
 delete mode 100644 Documentation/powerpc/dts-bindings/gpio/mdio.txt
 delete mode 100644 Documentation/powerpc/dts-bindings/marvell.txt
 delete mode 100644 Documentation/powerpc/dts-bindings/mmc-spi-slot.txt
 delete mode 100644 Documentation/powerpc/dts-bindings/mtd-physmap.txt
 delete mode 100644 Documentation/powerpc/dts-bindings/nintendo/gamecube.txt
 delete mode 100644 Documentation/powerpc/dts-bindings/nintendo/wii.txt
 delete mode 100644 Documentation/powerpc/dts-bindings/phy.txt
 delete mode 100644 Documentation/powerpc/dts-bindings/spi-bus.txt
 delete mode 100644 Documentation/powerpc/dts-bindings/usb-ehci.txt
 delete mode 100644 Documentation/powerpc/dts-bindings/xilinx.txt

diff --git a/Documentation/devicetree/bindings/ata/fsl-sata.txt b/Documentation/devicetree/bindings/ata/fsl-sata.txt
new file mode 100644
index 0000000..b46bcf4
--- /dev/null
+++ b/Documentation/devicetree/bindings/ata/fsl-sata.txt
@@ -0,0 +1,29 @@
+* Freescale 8xxx/3.0 Gb/s SATA nodes
+
+SATA nodes are defined to describe on-chip Serial ATA controllers.
+Each SATA port should have its own node.
+
+Required properties:
+- compatible        : compatible list, contains 2 entries, first is
+		 "fsl,CHIP-sata", where CHIP is the processor
+		 (mpc8315, mpc8379, etc.) and the second is
+		 "fsl,pq-sata"
+- interrupts        : <interrupt mapping for SATA IRQ>
+- cell-index        : controller index.
+                          1 for controller @ 0x18000
+                          2 for controller @ 0x19000
+                          3 for controller @ 0x1a000
+                          4 for controller @ 0x1b000
+
+Optional properties:
+- interrupt-parent  : optional, if needed for interrupt mapping
+- reg               : <registers mapping>
+
+Example:
+	sata@18000 {
+		compatible = "fsl,mpc8379-sata", "fsl,pq-sata";
+		reg = <0x18000 0x1000>;
+		cell-index = <1>;
+		interrupts = <2c 8>;
+		interrupt-parent = < &ipic >;
+	};
diff --git a/Documentation/devicetree/bindings/eeprom.txt b/Documentation/devicetree/bindings/eeprom.txt
new file mode 100644
index 0000000..4342c10
--- /dev/null
+++ b/Documentation/devicetree/bindings/eeprom.txt
@@ -0,0 +1,28 @@
+EEPROMs (I2C)
+
+Required properties:
+
+  - compatible : should be "<manufacturer>,<type>"
+		 If there is no specific driver for <manufacturer>, a generic
+		 driver based on <type> is selected. Possible types are:
+		 24c00, 24c01, 24c02, 24c04, 24c08, 24c16, 24c32, 24c64,
+		 24c128, 24c256, 24c512, 24c1024, spd
+
+  - reg : the I2C address of the EEPROM
+
+Optional properties:
+
+  - pagesize : the length of the pagesize for writing. Please consult the
+               manual of your device, that value varies a lot. A wrong value
+	       may result in data loss! If not specified, a safety value of
+	       '1' is used which will be very slow.
+
+  - read-only: this parameterless property disables writes to the eeprom
+
+Example:
+
+eeprom@52 {
+	compatible = "atmel,24c32";
+	reg = <0x52>;
+	pagesize = <32>;
+};
diff --git a/Documentation/devicetree/bindings/gpio/8xxx_gpio.txt b/Documentation/devicetree/bindings/gpio/8xxx_gpio.txt
new file mode 100644
index 0000000..b0019eb
--- /dev/null
+++ b/Documentation/devicetree/bindings/gpio/8xxx_gpio.txt
@@ -0,0 +1,60 @@
+GPIO controllers on MPC8xxx SoCs
+
+This is for the non-QE/CPM/GUTs GPIO controllers as found on
+8349, 8572, 8610 and compatible.
+
+Every GPIO controller node must have #gpio-cells property defined,
+this information will be used to translate gpio-specifiers.
+
+Required properties:
+- compatible : "fsl,<CHIP>-gpio" followed by "fsl,mpc8349-gpio" for
+  83xx, "fsl,mpc8572-gpio" for 85xx and "fsl,mpc8610-gpio" for 86xx.
+- #gpio-cells : Should be two. The first cell is the pin number and the
+  second cell is used to specify optional parameters (currently unused).
+ - interrupts : Interrupt mapping for GPIO IRQ.
+ - interrupt-parent : Phandle for the interrupt controller that
+   services interrupts for this device.
+- gpio-controller : Marks the port as GPIO controller.
+
+Example of gpio-controller nodes for a MPC8347 SoC:
+
+	gpio1: gpio-controller@c00 {
+		#gpio-cells = <2>;
+		compatible = "fsl,mpc8347-gpio", "fsl,mpc8349-gpio";
+		reg = <0xc00 0x100>;
+		interrupts = <74 0x8>;
+		interrupt-parent = <&ipic>;
+		gpio-controller;
+	};
+
+	gpio2: gpio-controller@d00 {
+		#gpio-cells = <2>;
+		compatible = "fsl,mpc8347-gpio", "fsl,mpc8349-gpio";
+		reg = <0xd00 0x100>;
+		interrupts = <75 0x8>;
+		interrupt-parent = <&ipic>;
+		gpio-controller;
+	};
+
+See booting-without-of.txt for details of how to specify GPIO
+information for devices.
+
+To use GPIO pins as interrupt sources for peripherals, specify the
+GPIO controller as the interrupt parent and define GPIO number +
+trigger mode using the interrupts property, which is defined like
+this:
+
+interrupts = <number trigger>, where:
+ - number: GPIO pin (0..31)
+ - trigger: trigger mode:
+	2 = trigger on falling edge
+	3 = trigger on both edges
+
+Example of device using this is:
+
+	funkyfpga@0 {
+		compatible = "funky-fpga";
+		...
+		interrupts = <4 3>;
+		interrupt-parent = <&gpio1>;
+	};
diff --git a/Documentation/devicetree/bindings/gpio/gpio.txt b/Documentation/devicetree/bindings/gpio/gpio.txt
new file mode 100644
index 0000000..edaa84d
--- /dev/null
+++ b/Documentation/devicetree/bindings/gpio/gpio.txt
@@ -0,0 +1,50 @@
+Specifying GPIO information for devices
+============================================
+
+1) gpios property
+-----------------
+
+Nodes that makes use of GPIOs should define them using `gpios' property,
+format of which is: <&gpio-controller1-phandle gpio1-specifier
+		     &gpio-controller2-phandle gpio2-specifier
+		     0 /* holes are permitted, means no GPIO 3 */
+		     &gpio-controller4-phandle gpio4-specifier
+		     ...>;
+
+Note that gpio-specifier length is controller dependent.
+
+gpio-specifier may encode: bank, pin position inside the bank,
+whether pin is open-drain and whether pin is logically inverted.
+
+Example of the node using GPIOs:
+
+	node {
+		gpios = <&qe_pio_e 18 0>;
+	};
+
+In this example gpio-specifier is "18 0" and encodes GPIO pin number,
+and empty GPIO flags as accepted by the "qe_pio_e" gpio-controller.
+
+2) gpio-controller nodes
+------------------------
+
+Every GPIO controller node must have #gpio-cells property defined,
+this information will be used to translate gpio-specifiers.
+
+Example of two SOC GPIO banks defined as gpio-controller nodes:
+
+	qe_pio_a: gpio-controller@1400 {
+		#gpio-cells = <2>;
+		compatible = "fsl,qe-pario-bank-a", "fsl,qe-pario-bank";
+		reg = <0x1400 0x18>;
+		gpio-controller;
+	};
+
+	qe_pio_e: gpio-controller@1460 {
+		#gpio-cells = <2>;
+		compatible = "fsl,qe-pario-bank-e", "fsl,qe-pario-bank";
+		reg = <0x1460 0x18>;
+		gpio-controller;
+	};
+
+
diff --git a/Documentation/devicetree/bindings/gpio/led.txt b/Documentation/devicetree/bindings/gpio/led.txt
new file mode 100644
index 0000000..064db92
--- /dev/null
+++ b/Documentation/devicetree/bindings/gpio/led.txt
@@ -0,0 +1,58 @@
+LEDs connected to GPIO lines
+
+Required properties:
+- compatible : should be "gpio-leds".
+
+Each LED is represented as a sub-node of the gpio-leds device.  Each
+node's name represents the name of the corresponding LED.
+
+LED sub-node properties:
+- gpios :  Should specify the LED's GPIO, see "Specifying GPIO information
+  for devices" in Documentation/powerpc/booting-without-of.txt.  Active
+  low LEDs should be indicated using flags in the GPIO specifier.
+- label :  (optional) The label for this LED.  If omitted, the label is
+  taken from the node name (excluding the unit address).
+- linux,default-trigger :  (optional) This parameter, if present, is a
+  string defining the trigger assigned to the LED.  Current triggers are:
+    "backlight" - LED will act as a back-light, controlled by the framebuffer
+		  system
+    "default-on" - LED will turn on, but see "default-state" below
+    "heartbeat" - LED "double" flashes at a load average based rate
+    "ide-disk" - LED indicates disk activity
+    "timer" - LED flashes at a fixed, configurable rate
+- default-state:  (optional) The initial state of the LED.  Valid
+  values are "on", "off", and "keep".  If the LED is already on or off
+  and the default-state property is set the to same value, then no
+  glitch should be produced where the LED momentarily turns off (or
+  on).  The "keep" setting will keep the LED at whatever its current
+  state is, without producing a glitch.  The default is off if this
+  property is not present.
+
+Examples:
+
+leds {
+	compatible = "gpio-leds";
+	hdd {
+		label = "IDE Activity";
+		gpios = <&mcu_pio 0 1>; /* Active low */
+		linux,default-trigger = "ide-disk";
+	};
+
+	fault {
+		gpios = <&mcu_pio 1 0>;
+		/* Keep LED on if BIOS detected hardware fault */
+		default-state = "keep";
+	};
+};
+
+run-control {
+	compatible = "gpio-leds";
+	red {
+		gpios = <&mpc8572 6 0>;
+		default-state = "off";
+	};
+	green {
+		gpios = <&mpc8572 7 0>;
+		default-state = "on";
+	};
+}
diff --git a/Documentation/devicetree/bindings/i2c/fsl-i2c.txt b/Documentation/devicetree/bindings/i2c/fsl-i2c.txt
new file mode 100644
index 0000000..1eacd6b
--- /dev/null
+++ b/Documentation/devicetree/bindings/i2c/fsl-i2c.txt
@@ -0,0 +1,64 @@
+* I2C
+
+Required properties :
+
+ - reg : Offset and length of the register set for the device
+ - compatible : should be "fsl,CHIP-i2c" where CHIP is the name of a
+   compatible processor, e.g. mpc8313, mpc8543, mpc8544, mpc5121,
+   mpc5200 or mpc5200b. For the mpc5121, an additional node
+   "fsl,mpc5121-i2c-ctrl" is required as shown in the example below.
+
+Recommended properties :
+
+ - interrupts : <a b> where a is the interrupt number and b is a
+   field that represents an encoding of the sense and level
+   information for the interrupt.  This should be encoded based on
+   the information in section 2) depending on the type of interrupt
+   controller you have.
+ - interrupt-parent : the phandle for the interrupt controller that
+   services interrupts for this device.
+ - fsl,preserve-clocking : boolean; if defined, the clock settings
+   from the bootloader are preserved (not touched).
+ - clock-frequency : desired I2C bus clock frequency in Hz.
+ - fsl,timeout : I2C bus timeout in microseconds.
+
+Examples :
+
+	/* MPC5121 based board */
+	i2c@1740 {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		compatible = "fsl,mpc5121-i2c", "fsl-i2c";
+		reg = <0x1740 0x20>;
+		interrupts = <11 0x8>;
+		interrupt-parent = <&ipic>;
+		clock-frequency = <100000>;
+	};
+
+	i2ccontrol@1760 {
+		compatible = "fsl,mpc5121-i2c-ctrl";
+		reg = <0x1760 0x8>;
+	};
+
+	/* MPC5200B based board */
+	i2c@3d00 {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		compatible = "fsl,mpc5200b-i2c","fsl,mpc5200-i2c","fsl-i2c";
+		reg = <0x3d00 0x40>;
+		interrupts = <2 15 0>;
+		interrupt-parent = <&mpc5200_pic>;
+		fsl,preserve-clocking;
+	};
+
+	/* MPC8544 base board */
+	i2c@3100 {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		compatible = "fsl,mpc8544-i2c", "fsl-i2c";
+		reg = <0x3100 0x100>;
+		interrupts = <43 2>;
+		interrupt-parent = <&mpic>;
+		clock-frequency = <400000>;
+		fsl,timeout = <10000>;
+	};
diff --git a/Documentation/devicetree/bindings/marvell.txt b/Documentation/devicetree/bindings/marvell.txt
new file mode 100644
index 0000000..f1533d9
--- /dev/null
+++ b/Documentation/devicetree/bindings/marvell.txt
@@ -0,0 +1,521 @@
+Marvell Discovery mv64[345]6x System Controller chips
+===========================================================
+
+The Marvell mv64[345]60 series of system controller chips contain
+many of the peripherals needed to implement a complete computer
+system.  In this section, we define device tree nodes to describe
+the system controller chip itself and each of the peripherals
+which it contains.  Compatible string values for each node are
+prefixed with the string "marvell,", for Marvell Technology Group Ltd.
+
+1) The /system-controller node
+
+  This node is used to represent the system-controller and must be
+  present when the system uses a system controller chip. The top-level
+  system-controller node contains information that is global to all
+  devices within the system controller chip. The node name begins
+  with "system-controller" followed by the unit address, which is
+  the base address of the memory-mapped register set for the system
+  controller chip.
+
+  Required properties:
+
+    - ranges : Describes the translation of system controller addresses
+      for memory mapped registers.
+    - clock-frequency: Contains the main clock frequency for the system
+      controller chip.
+    - reg : This property defines the address and size of the
+      memory-mapped registers contained within the system controller
+      chip.  The address specified in the "reg" property should match
+      the unit address of the system-controller node.
+    - #address-cells : Address representation for system controller
+      devices.  This field represents the number of cells needed to
+      represent the address of the memory-mapped registers of devices
+      within the system controller chip.
+    - #size-cells : Size representation for the memory-mapped
+      registers within the system controller chip.
+    - #interrupt-cells : Defines the width of cells used to represent
+      interrupts.
+
+  Optional properties:
+
+    - model : The specific model of the system controller chip.  Such
+      as, "mv64360", "mv64460", or "mv64560".
+    - compatible : A string identifying the compatibility identifiers
+      of the system controller chip.
+
+  The system-controller node contains child nodes for each system
+  controller device that the platform uses.  Nodes should not be created
+  for devices which exist on the system controller chip but are not used
+
+  Example Marvell Discovery mv64360 system-controller node:
+
+    system-controller@f1000000 { /* Marvell Discovery mv64360 */
+	    #address-cells = <1>;
+	    #size-cells = <1>;
+	    model = "mv64360";                      /* Default */
+	    compatible = "marvell,mv64360";
+	    clock-frequency = <133333333>;
+	    reg = <0xf1000000 0x10000>;
+	    virtual-reg = <0xf1000000>;
+	    ranges = <0x88000000 0x88000000 0x1000000 /* PCI 0 I/O Space */
+		    0x80000000 0x80000000 0x8000000 /* PCI 0 MEM Space */
+		    0xa0000000 0xa0000000 0x4000000 /* User FLASH */
+		    0x00000000 0xf1000000 0x0010000 /* Bridge's regs */
+		    0xf2000000 0xf2000000 0x0040000>;/* Integrated SRAM */
+
+	    [ child node definitions... ]
+    }
+
+2) Child nodes of /system-controller
+
+   a) Marvell Discovery MDIO bus
+
+   The MDIO is a bus to which the PHY devices are connected.  For each
+   device that exists on this bus, a child node should be created.  See
+   the definition of the PHY node below for an example of how to define
+   a PHY.
+
+   Required properties:
+     - #address-cells : Should be <1>
+     - #size-cells : Should be <0>
+     - device_type : Should be "mdio"
+     - compatible : Should be "marvell,mv64360-mdio"
+
+   Example:
+
+     mdio {
+	     #address-cells = <1>;
+	     #size-cells = <0>;
+	     device_type = "mdio";
+	     compatible = "marvell,mv64360-mdio";
+
+	     ethernet-phy@0 {
+		     ......
+	     };
+     };
+
+
+   b) Marvell Discovery ethernet controller
+
+   The Discover ethernet controller is described with two levels
+   of nodes.  The first level describes an ethernet silicon block
+   and the second level describes up to 3 ethernet nodes within
+   that block.  The reason for the multiple levels is that the
+   registers for the node are interleaved within a single set
+   of registers.  The "ethernet-block" level describes the
+   shared register set, and the "ethernet" nodes describe ethernet
+   port-specific properties.
+
+   Ethernet block node
+
+   Required properties:
+     - #address-cells : <1>
+     - #size-cells : <0>
+     - compatible : "marvell,mv64360-eth-block"
+     - reg : Offset and length of the register set for this block
+
+   Example Discovery Ethernet block node:
+     ethernet-block@2000 {
+	     #address-cells = <1>;
+	     #size-cells = <0>;
+	     compatible = "marvell,mv64360-eth-block";
+	     reg = <0x2000 0x2000>;
+	     ethernet@0 {
+		     .......
+	     };
+     };
+
+   Ethernet port node
+
+   Required properties:
+     - device_type : Should be "network".
+     - compatible : Should be "marvell,mv64360-eth".
+     - reg : Should be <0>, <1>, or <2>, according to which registers
+       within the silicon block the device uses.
+     - interrupts : <a> where a is the interrupt number for the port.
+     - interrupt-parent : the phandle for the interrupt controller
+       that services interrupts for this device.
+     - phy : the phandle for the PHY connected to this ethernet
+       controller.
+     - local-mac-address : 6 bytes, MAC address
+
+   Example Discovery Ethernet port node:
+     ethernet@0 {
+	     device_type = "network";
+	     compatible = "marvell,mv64360-eth";
+	     reg = <0>;
+	     interrupts = <32>;
+	     interrupt-parent = <&PIC>;
+	     phy = <&PHY0>;
+	     local-mac-address = [ 00 00 00 00 00 00 ];
+     };
+
+
+
+   c) Marvell Discovery PHY nodes
+
+   Required properties:
+     - device_type : Should be "ethernet-phy"
+     - interrupts : <a> where a is the interrupt number for this phy.
+     - interrupt-parent : the phandle for the interrupt controller that
+       services interrupts for this device.
+     - reg : The ID number for the phy, usually a small integer
+
+   Example Discovery PHY node:
+     ethernet-phy@1 {
+	     device_type = "ethernet-phy";
+	     compatible = "broadcom,bcm5421";
+	     interrupts = <76>;      /* GPP 12 */
+	     interrupt-parent = <&PIC>;
+	     reg = <1>;
+     };
+
+
+   d) Marvell Discovery SDMA nodes
+
+   Represent DMA hardware associated with the MPSC (multiprotocol
+   serial controllers).
+
+   Required properties:
+     - compatible : "marvell,mv64360-sdma"
+     - reg : Offset and length of the register set for this device
+     - interrupts : <a> where a is the interrupt number for the DMA
+       device.
+     - interrupt-parent : the phandle for the interrupt controller
+       that services interrupts for this device.
+
+   Example Discovery SDMA node:
+     sdma@4000 {
+	     compatible = "marvell,mv64360-sdma";
+	     reg = <0x4000 0xc18>;
+	     virtual-reg = <0xf1004000>;
+	     interrupts = <36>;
+	     interrupt-parent = <&PIC>;
+     };
+
+
+   e) Marvell Discovery BRG nodes
+
+   Represent baud rate generator hardware associated with the MPSC
+   (multiprotocol serial controllers).
+
+   Required properties:
+     - compatible : "marvell,mv64360-brg"
+     - reg : Offset and length of the register set for this device
+     - clock-src : A value from 0 to 15 which selects the clock
+       source for the baud rate generator.  This value corresponds
+       to the CLKS value in the BRGx configuration register.  See
+       the mv64x60 User's Manual.
+     - clock-frequence : The frequency (in Hz) of the baud rate
+       generator's input clock.
+     - current-speed : The current speed setting (presumably by
+       firmware) of the baud rate generator.
+
+   Example Discovery BRG node:
+     brg@b200 {
+	     compatible = "marvell,mv64360-brg";
+	     reg = <0xb200 0x8>;
+	     clock-src = <8>;
+	     clock-frequency = <133333333>;
+	     current-speed = <9600>;
+     };
+
+
+   f) Marvell Discovery CUNIT nodes
+
+   Represent the Serial Communications Unit device hardware.
+
+   Required properties:
+     - reg : Offset and length of the register set for this device
+
+   Example Discovery CUNIT node:
+     cunit@f200 {
+	     reg = <0xf200 0x200>;
+     };
+
+
+   g) Marvell Discovery MPSCROUTING nodes
+
+   Represent the Discovery's MPSC routing hardware
+
+   Required properties:
+     - reg : Offset and length of the register set for this device
+
+   Example Discovery CUNIT node:
+     mpscrouting@b500 {
+	     reg = <0xb400 0xc>;
+     };
+
+
+   h) Marvell Discovery MPSCINTR nodes
+
+   Represent the Discovery's MPSC DMA interrupt hardware registers
+   (SDMA cause and mask registers).
+
+   Required properties:
+     - reg : Offset and length of the register set for this device
+
+   Example Discovery MPSCINTR node:
+     mpsintr@b800 {
+	     reg = <0xb800 0x100>;
+     };
+
+
+   i) Marvell Discovery MPSC nodes
+
+   Represent the Discovery's MPSC (Multiprotocol Serial Controller)
+   serial port.
+
+   Required properties:
+     - device_type : "serial"
+     - compatible : "marvell,mv64360-mpsc"
+     - reg : Offset and length of the register set for this device
+     - sdma : the phandle for the SDMA node used by this port
+     - brg : the phandle for the BRG node used by this port
+     - cunit : the phandle for the CUNIT node used by this port
+     - mpscrouting : the phandle for the MPSCROUTING node used by this port
+     - mpscintr : the phandle for the MPSCINTR node used by this port
+     - cell-index : the hardware index of this cell in the MPSC core
+     - max_idle : value needed for MPSC CHR3 (Maximum Frame Length)
+       register
+     - interrupts : <a> where a is the interrupt number for the MPSC.
+     - interrupt-parent : the phandle for the interrupt controller
+       that services interrupts for this device.
+
+   Example Discovery MPSCINTR node:
+     mpsc@8000 {
+	     device_type = "serial";
+	     compatible = "marvell,mv64360-mpsc";
+	     reg = <0x8000 0x38>;
+	     virtual-reg = <0xf1008000>;
+	     sdma = <&SDMA0>;
+	     brg = <&BRG0>;
+	     cunit = <&CUNIT>;
+	     mpscrouting = <&MPSCROUTING>;
+	     mpscintr = <&MPSCINTR>;
+	     cell-index = <0>;
+	     max_idle = <40>;
+	     interrupts = <40>;
+	     interrupt-parent = <&PIC>;
+     };
+
+
+   j) Marvell Discovery Watch Dog Timer nodes
+
+   Represent the Discovery's watchdog timer hardware
+
+   Required properties:
+     - compatible : "marvell,mv64360-wdt"
+     - reg : Offset and length of the register set for this device
+
+   Example Discovery Watch Dog Timer node:
+     wdt@b410 {
+	     compatible = "marvell,mv64360-wdt";
+	     reg = <0xb410 0x8>;
+     };
+
+
+   k) Marvell Discovery I2C nodes
+
+   Represent the Discovery's I2C hardware
+
+   Required properties:
+     - device_type : "i2c"
+     - compatible : "marvell,mv64360-i2c"
+     - reg : Offset and length of the register set for this device
+     - interrupts : <a> where a is the interrupt number for the I2C.
+     - interrupt-parent : the phandle for the interrupt controller
+       that services interrupts for this device.
+
+   Example Discovery I2C node:
+	     compatible = "marvell,mv64360-i2c";
+	     reg = <0xc000 0x20>;
+	     virtual-reg = <0xf100c000>;
+	     interrupts = <37>;
+	     interrupt-parent = <&PIC>;
+     };
+
+
+   l) Marvell Discovery PIC (Programmable Interrupt Controller) nodes
+
+   Represent the Discovery's PIC hardware
+
+   Required properties:
+     - #interrupt-cells : <1>
+     - #address-cells : <0>
+     - compatible : "marvell,mv64360-pic"
+     - reg : Offset and length of the register set for this device
+     - interrupt-controller
+
+   Example Discovery PIC node:
+     pic {
+	     #interrupt-cells = <1>;
+	     #address-cells = <0>;
+	     compatible = "marvell,mv64360-pic";
+	     reg = <0x0 0x88>;
+	     interrupt-controller;
+     };
+
+
+   m) Marvell Discovery MPP (Multipurpose Pins) multiplexing nodes
+
+   Represent the Discovery's MPP hardware
+
+   Required properties:
+     - compatible : "marvell,mv64360-mpp"
+     - reg : Offset and length of the register set for this device
+
+   Example Discovery MPP node:
+     mpp@f000 {
+	     compatible = "marvell,mv64360-mpp";
+	     reg = <0xf000 0x10>;
+     };
+
+
+   n) Marvell Discovery GPP (General Purpose Pins) nodes
+
+   Represent the Discovery's GPP hardware
+
+   Required properties:
+     - compatible : "marvell,mv64360-gpp"
+     - reg : Offset and length of the register set for this device
+
+   Example Discovery GPP node:
+     gpp@f000 {
+	     compatible = "marvell,mv64360-gpp";
+	     reg = <0xf100 0x20>;
+     };
+
+
+   o) Marvell Discovery PCI host bridge node
+
+   Represents the Discovery's PCI host bridge device.  The properties
+   for this node conform to Rev 2.1 of the PCI Bus Binding to IEEE
+   1275-1994.  A typical value for the compatible property is
+   "marvell,mv64360-pci".
+
+   Example Discovery PCI host bridge node
+     pci@80000000 {
+	     #address-cells = <3>;
+	     #size-cells = <2>;
+	     #interrupt-cells = <1>;
+	     device_type = "pci";
+	     compatible = "marvell,mv64360-pci";
+	     reg = <0xcf8 0x8>;
+	     ranges = <0x01000000 0x0        0x0
+			     0x88000000 0x0 0x01000000
+		       0x02000000 0x0 0x80000000
+			     0x80000000 0x0 0x08000000>;
+	     bus-range = <0 255>;
+	     clock-frequency = <66000000>;
+	     interrupt-parent = <&PIC>;
+	     interrupt-map-mask = <0xf800 0x0 0x0 0x7>;
+	     interrupt-map = <
+		     /* IDSEL 0x0a */
+		     0x5000 0 0 1 &PIC 80
+		     0x5000 0 0 2 &PIC 81
+		     0x5000 0 0 3 &PIC 91
+		     0x5000 0 0 4 &PIC 93
+
+		     /* IDSEL 0x0b */
+		     0x5800 0 0 1 &PIC 91
+		     0x5800 0 0 2 &PIC 93
+		     0x5800 0 0 3 &PIC 80
+		     0x5800 0 0 4 &PIC 81
+
+		     /* IDSEL 0x0c */
+		     0x6000 0 0 1 &PIC 91
+		     0x6000 0 0 2 &PIC 93
+		     0x6000 0 0 3 &PIC 80
+		     0x6000 0 0 4 &PIC 81
+
+		     /* IDSEL 0x0d */
+		     0x6800 0 0 1 &PIC 93
+		     0x6800 0 0 2 &PIC 80
+		     0x6800 0 0 3 &PIC 81
+		     0x6800 0 0 4 &PIC 91
+	     >;
+     };
+
+
+   p) Marvell Discovery CPU Error nodes
+
+   Represent the Discovery's CPU error handler device.
+
+   Required properties:
+     - compatible : "marvell,mv64360-cpu-error"
+     - reg : Offset and length of the register set for this device
+     - interrupts : the interrupt number for this device
+     - interrupt-parent : the phandle for the interrupt controller
+       that services interrupts for this device.
+
+   Example Discovery CPU Error node:
+     cpu-error@0070 {
+	     compatible = "marvell,mv64360-cpu-error";
+	     reg = <0x70 0x10 0x128 0x28>;
+	     interrupts = <3>;
+	     interrupt-parent = <&PIC>;
+     };
+
+
+   q) Marvell Discovery SRAM Controller nodes
+
+   Represent the Discovery's SRAM controller device.
+
+   Required properties:
+     - compatible : "marvell,mv64360-sram-ctrl"
+     - reg : Offset and length of the register set for this device
+     - interrupts : the interrupt number for this device
+     - interrupt-parent : the phandle for the interrupt controller
+       that services interrupts for this device.
+
+   Example Discovery SRAM Controller node:
+     sram-ctrl@0380 {
+	     compatible = "marvell,mv64360-sram-ctrl";
+	     reg = <0x380 0x80>;
+	     interrupts = <13>;
+	     interrupt-parent = <&PIC>;
+     };
+
+
+   r) Marvell Discovery PCI Error Handler nodes
+
+   Represent the Discovery's PCI error handler device.
+
+   Required properties:
+     - compatible : "marvell,mv64360-pci-error"
+     - reg : Offset and length of the register set for this device
+     - interrupts : the interrupt number for this device
+     - interrupt-parent : the phandle for the interrupt controller
+       that services interrupts for this device.
+
+   Example Discovery PCI Error Handler node:
+     pci-error@1d40 {
+	     compatible = "marvell,mv64360-pci-error";
+	     reg = <0x1d40 0x40 0xc28 0x4>;
+	     interrupts = <12>;
+	     interrupt-parent = <&PIC>;
+     };
+
+
+   s) Marvell Discovery Memory Controller nodes
+
+   Represent the Discovery's memory controller device.
+
+   Required properties:
+     - compatible : "marvell,mv64360-mem-ctrl"
+     - reg : Offset and length of the register set for this device
+     - interrupts : the interrupt number for this device
+     - interrupt-parent : the phandle for the interrupt controller
+       that services interrupts for this device.
+
+   Example Discovery Memory Controller node:
+     mem-ctrl@1400 {
+	     compatible = "marvell,mv64360-mem-ctrl";
+	     reg = <0x1400 0x60>;
+	     interrupts = <17>;
+	     interrupt-parent = <&PIC>;
+     };
+
+
diff --git a/Documentation/devicetree/bindings/mmc/fsl-esdhc.txt b/Documentation/devicetree/bindings/mmc/fsl-esdhc.txt
new file mode 100644
index 0000000..64bcb8b
--- /dev/null
+++ b/Documentation/devicetree/bindings/mmc/fsl-esdhc.txt
@@ -0,0 +1,29 @@
+* Freescale Enhanced Secure Digital Host Controller (eSDHC)
+
+The Enhanced Secure Digital Host Controller provides an interface
+for MMC, SD, and SDIO types of memory cards.
+
+Required properties:
+  - compatible : should be
+    "fsl,<chip>-esdhc", "fsl,esdhc"
+  - reg : should contain eSDHC registers location and length.
+  - interrupts : should contain eSDHC interrupt.
+  - interrupt-parent : interrupt source phandle.
+  - clock-frequency : specifies eSDHC base clock frequency.
+  - sdhci,wp-inverted : (optional) specifies that eSDHC controller
+    reports inverted write-protect state;
+  - sdhci,1-bit-only : (optional) specifies that a controller can
+    only handle 1-bit data transfers.
+  - sdhci,auto-cmd12: (optional) specifies that a controller can
+    only handle auto CMD12.
+
+Example:
+
+sdhci@2e000 {
+	compatible = "fsl,mpc8378-esdhc", "fsl,esdhc";
+	reg = <0x2e000 0x1000>;
+	interrupts = <42 0x8>;
+	interrupt-parent = <&ipic>;
+	/* Filled in by U-Boot */
+	clock-frequency = <0>;
+};
diff --git a/Documentation/devicetree/bindings/mmc/mmc-spi-slot.txt b/Documentation/devicetree/bindings/mmc/mmc-spi-slot.txt
new file mode 100644
index 0000000..c39ac28
--- /dev/null
+++ b/Documentation/devicetree/bindings/mmc/mmc-spi-slot.txt
@@ -0,0 +1,23 @@
+MMC/SD/SDIO slot directly connected to a SPI bus
+
+Required properties:
+- compatible : should be "mmc-spi-slot".
+- reg : should specify SPI address (chip-select number).
+- spi-max-frequency : maximum frequency for this device (Hz).
+- voltage-ranges : two cells are required, first cell specifies minimum
+  slot voltage (mV), second cell specifies maximum slot voltage (mV).
+  Several ranges could be specified.
+- gpios : (optional) may specify GPIOs in this order: Card-Detect GPIO,
+  Write-Protect GPIO.
+
+Example:
+
+	mmc-slot@0 {
+		compatible = "fsl,mpc8323rdb-mmc-slot",
+			     "mmc-spi-slot";
+		reg = <0>;
+		gpios = <&qe_pio_d 14 1
+			 &qe_pio_d 15 0>;
+		voltage-ranges = <3300 3300>;
+		spi-max-frequency = <50000000>;
+	};
diff --git a/Documentation/devicetree/bindings/mtd/fsl-upm-nand.txt b/Documentation/devicetree/bindings/mtd/fsl-upm-nand.txt
new file mode 100644
index 0000000..a48b2ca
--- /dev/null
+++ b/Documentation/devicetree/bindings/mtd/fsl-upm-nand.txt
@@ -0,0 +1,63 @@
+Freescale Localbus UPM programmed to work with NAND flash
+
+Required properties:
+- compatible : "fsl,upm-nand".
+- reg : should specify localbus chip select and size used for the chip.
+- fsl,upm-addr-offset : UPM pattern offset for the address latch.
+- fsl,upm-cmd-offset : UPM pattern offset for the command latch.
+
+Optional properties:
+- fsl,upm-wait-flags : add chip-dependent short delays after running the
+	UPM pattern (0x1), after writing a data byte (0x2) or after
+	writing out a buffer (0x4).
+- fsl,upm-addr-line-cs-offsets : address offsets for multi-chip support.
+	The corresponding address lines are used to select the chip.
+- gpios : may specify optional GPIOs connected to the Ready-Not-Busy pins
+	(R/B#). For multi-chip devices, "n" GPIO definitions are required
+	according to the number of chips.
+- chip-delay : chip dependent delay for transfering data from array to
+	read registers (tR). Required if property "gpios" is not used
+	(R/B# pins not connected).
+
+Examples:
+
+upm@1,0 {
+	compatible = "fsl,upm-nand";
+	reg = <1 0 1>;
+	fsl,upm-addr-offset = <16>;
+	fsl,upm-cmd-offset = <8>;
+	gpios = <&qe_pio_e 18 0>;
+
+	flash {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		compatible = "...";
+
+		partition@0 {
+			...
+		};
+	};
+};
+
+upm@3,0 {
+	#address-cells = <0>;
+	#size-cells = <0>;
+	compatible = "tqc,tqm8548-upm-nand", "fsl,upm-nand";
+	reg = <3 0x0 0x800>;
+	fsl,upm-addr-offset = <0x10>;
+	fsl,upm-cmd-offset = <0x08>;
+	/* Multi-chip NAND device */
+	fsl,upm-addr-line-cs-offsets = <0x0 0x200>;
+	fsl,upm-wait-flags = <0x5>;
+	chip-delay = <25>; // in micro-seconds
+
+	nand@0 {
+		#address-cells = <1>;
+		#size-cells = <1>;
+
+		partition@0 {
+			    label = "fs";
+			    reg = <0x00000000 0x10000000>;
+		};
+	};
+};
diff --git a/Documentation/devicetree/bindings/mtd/mtd-physmap.txt b/Documentation/devicetree/bindings/mtd/mtd-physmap.txt
new file mode 100644
index 0000000..80152cb
--- /dev/null
+++ b/Documentation/devicetree/bindings/mtd/mtd-physmap.txt
@@ -0,0 +1,90 @@
+CFI or JEDEC memory-mapped NOR flash, MTD-RAM (NVRAM...)
+
+Flash chips (Memory Technology Devices) are often used for solid state
+file systems on embedded devices.
+
+ - compatible : should contain the specific model of mtd chip(s)
+   used, if known, followed by either "cfi-flash", "jedec-flash"
+   or "mtd-ram".
+ - reg : Address range(s) of the mtd chip(s)
+   It's possible to (optionally) define multiple "reg" tuples so that
+   non-identical chips can be described in one node.
+ - bank-width : Width (in bytes) of the bank.  Equal to the
+   device width times the number of interleaved chips.
+ - device-width : (optional) Width of a single mtd chip.  If
+   omitted, assumed to be equal to 'bank-width'.
+ - #address-cells, #size-cells : Must be present if the device has
+   sub-nodes representing partitions (see below).  In this case
+   both #address-cells and #size-cells must be equal to 1.
+
+For JEDEC compatible devices, the following additional properties
+are defined:
+
+ - vendor-id : Contains the flash chip's vendor id (1 byte).
+ - device-id : Contains the flash chip's device id (1 byte).
+
+In addition to the information on the mtd bank itself, the
+device tree may optionally contain additional information
+describing partitions of the address space.  This can be
+used on platforms which have strong conventions about which
+portions of a flash are used for what purposes, but which don't
+use an on-flash partition table such as RedBoot.
+
+Each partition is represented as a sub-node of the mtd device.
+Each node's name represents the name of the corresponding
+partition of the mtd device.
+
+Flash partitions
+ - reg : The partition's offset and size within the mtd bank.
+ - label : (optional) The label / name for this partition.
+   If omitted, the label is taken from the node name (excluding
+   the unit address).
+ - read-only : (optional) This parameter, if present, is a hint to
+   Linux that this partition should only be mounted
+   read-only.  This is usually used for flash partitions
+   containing early-boot firmware images or data which should not
+   be clobbered.
+
+Example:
+
+	flash@ff000000 {
+		compatible = "amd,am29lv128ml", "cfi-flash";
+		reg = <ff000000 01000000>;
+		bank-width = <4>;
+		device-width = <1>;
+		#address-cells = <1>;
+		#size-cells = <1>;
+		fs@0 {
+			label = "fs";
+			reg = <0 f80000>;
+		};
+		firmware@f80000 {
+			label ="firmware";
+			reg = <f80000 80000>;
+			read-only;
+		};
+	};
+
+Here an example with multiple "reg" tuples:
+
+	flash@f0000000,0 {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		compatible = "intel,PC48F4400P0VB", "cfi-flash";
+		reg = <0 0x00000000 0x02000000
+		       0 0x02000000 0x02000000>;
+		bank-width = <2>;
+		partition@0 {
+			label = "test-part1";
+			reg = <0 0x04000000>;
+		};
+	};
+
+An example using SRAM:
+
+	sram@2,0 {
+		compatible = "samsung,k6f1616u6a", "mtd-ram";
+		reg = <2 0 0x00200000>;
+		bank-width = <2>;
+	};
+
diff --git a/Documentation/devicetree/bindings/net/can/mpc5xxx-mscan.txt b/Documentation/devicetree/bindings/net/can/mpc5xxx-mscan.txt
new file mode 100644
index 0000000..2fa4fcd
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/can/mpc5xxx-mscan.txt
@@ -0,0 +1,53 @@
+CAN Device Tree Bindings
+------------------------
+
+(c) 2006-2009 Secret Lab Technologies Ltd
+Grant Likely <grant.likely@secretlab.ca>
+
+fsl,mpc5200-mscan nodes
+-----------------------
+In addition to the required compatible-, reg- and interrupt-properties, you can
+also specify which clock source shall be used for the controller:
+
+- fsl,mscan-clock-source : a string describing the clock source. Valid values
+			   are:	"ip" for ip bus clock
+				 "ref" for reference clock (XTAL)
+			   "ref" is default in case this property is not
+			   present.
+
+fsl,mpc5121-mscan nodes
+-----------------------
+In addition to the required compatible-, reg- and interrupt-properties, you can
+also specify which clock source and divider shall be used for the controller:
+
+- fsl,mscan-clock-source : a string describing the clock source. Valid values
+			   are:	"ip" for ip bus clock
+				"ref" for reference clock
+				"sys" for system clock
+			   If this property is not present, an optimal CAN
+			   clock source and frequency based on the system
+			   clock will be selected. If this is not possible,
+			   the reference clock will be used.
+
+- fsl,mscan-clock-divider: for the reference and system clock, an additional
+			   clock divider can be specified. By default, a
+			   value of 1 is used.
+
+Note that the MPC5121 Rev. 1 processor is not supported.
+
+Examples:
+	can@1300 {
+		compatible = "fsl,mpc5121-mscan";
+		interrupts = <12 0x8>;
+		interrupt-parent = <&ipic>;
+		reg = <0x1300 0x80>;
+	};
+
+	can@1380 {
+		compatible = "fsl,mpc5121-mscan";
+		interrupts = <13 0x8>;
+		interrupt-parent = <&ipic>;
+		reg = <0x1380 0x80>;
+		fsl,mscan-clock-source = "ref";
+		fsl,mscan-clock-divider = <3>;
+	};
diff --git a/Documentation/devicetree/bindings/net/can/sja1000.txt b/Documentation/devicetree/bindings/net/can/sja1000.txt
new file mode 100644
index 0000000..d6d209d
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/can/sja1000.txt
@@ -0,0 +1,53 @@
+Memory mapped SJA1000 CAN controller from NXP (formerly Philips)
+
+Required properties:
+
+- compatible : should be "nxp,sja1000".
+
+- reg : should specify the chip select, address offset and size required
+	to map the registers of the SJA1000. The size is usually 0x80.
+
+- interrupts: property with a value describing the interrupt source
+	(number and sensitivity) required for the SJA1000.
+
+Optional properties:
+
+- nxp,external-clock-frequency : Frequency of the external oscillator
+	clock in Hz. Note that the internal clock frequency used by the
+	SJA1000 is half of that value. If not specified, a default value
+	of 16000000 (16 MHz) is used.
+
+- nxp,tx-output-mode : operation mode of the TX output control logic:
+	<0x0> : bi-phase output mode
+	<0x1> : normal output mode (default)
+	<0x2> : test output mode
+	<0x3> : clock output mode
+
+- nxp,tx-output-config : TX output pin configuration:
+	<0x01> : TX0 invert
+	<0x02> : TX0 pull-down (default)
+	<0x04> : TX0 pull-up
+	<0x06> : TX0 push-pull
+	<0x08> : TX1 invert
+	<0x10> : TX1 pull-down
+	<0x20> : TX1 pull-up
+	<0x30> : TX1 push-pull
+
+- nxp,clock-out-frequency : clock frequency in Hz on the CLKOUT pin.
+	If not specified or if the specified value is 0, the CLKOUT pin
+	will be disabled.
+
+- nxp,no-comparator-bypass : Allows to disable the CAN input comperator.
+
+For futher information, please have a look to the SJA1000 data sheet.
+
+Examples:
+
+can@3,100 {
+	compatible = "nxp,sja1000";
+	reg = <3 0x100 0x80>;
+	interrupts = <2 0>;
+	interrupt-parent = <&mpic>;
+	nxp,external-clock-frequency = <16000000>;
+};
+
diff --git a/Documentation/devicetree/bindings/net/fsl-tsec-phy.txt b/Documentation/devicetree/bindings/net/fsl-tsec-phy.txt
new file mode 100644
index 0000000..edb7ae1
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/fsl-tsec-phy.txt
@@ -0,0 +1,76 @@
+* MDIO IO device
+
+The MDIO is a bus to which the PHY devices are connected.  For each
+device that exists on this bus, a child node should be created.  See
+the definition of the PHY node in booting-without-of.txt for an example
+of how to define a PHY.
+
+Required properties:
+  - reg : Offset and length of the register set for the device
+  - compatible : Should define the compatible device type for the
+    mdio.  Currently, this is most likely to be "fsl,gianfar-mdio"
+
+Example:
+
+	mdio@24520 {
+		reg = <24520 20>;
+		compatible = "fsl,gianfar-mdio";
+
+		ethernet-phy@0 {
+			......
+		};
+	};
+
+* TBI Internal MDIO bus
+
+As of this writing, every tsec is associated with an internal TBI PHY.
+This PHY is accessed through the local MDIO bus.  These buses are defined
+similarly to the mdio buses, except they are compatible with "fsl,gianfar-tbi".
+The TBI PHYs underneath them are similar to normal PHYs, but the reg property
+is considered instructive, rather than descriptive.  The reg property should
+be chosen so it doesn't interfere with other PHYs on the bus.
+
+* Gianfar-compatible ethernet nodes
+
+Properties:
+
+  - device_type : Should be "network"
+  - model : Model of the device.  Can be "TSEC", "eTSEC", or "FEC"
+  - compatible : Should be "gianfar"
+  - reg : Offset and length of the register set for the device
+  - local-mac-address : List of bytes representing the ethernet address of
+    this controller
+  - interrupts : For FEC devices, the first interrupt is the device's
+    interrupt.  For TSEC and eTSEC devices, the first interrupt is
+    transmit, the second is receive, and the third is error.
+  - phy-handle : The phandle for the PHY connected to this ethernet
+    controller.
+  - fixed-link : <a b c d e> where a is emulated phy id - choose any,
+    but unique to the all specified fixed-links, b is duplex - 0 half,
+    1 full, c is link speed - d#10/d#100/d#1000, d is pause - 0 no
+    pause, 1 pause, e is asym_pause - 0 no asym_pause, 1 asym_pause.
+  - phy-connection-type : a string naming the controller/PHY interface type,
+    i.e., "mii" (default), "rmii", "gmii", "rgmii", "rgmii-id", "sgmii",
+    "tbi", or "rtbi".  This property is only really needed if the connection
+    is of type "rgmii-id", as all other connection types are detected by
+    hardware.
+  - fsl,magic-packet : If present, indicates that the hardware supports
+    waking up via magic packet.
+  - bd-stash : If present, indicates that the hardware supports stashing
+    buffer descriptors in the L2.
+  - rx-stash-len : Denotes the number of bytes of a received buffer to stash
+    in the L2.
+  - rx-stash-idx : Denotes the index of the first byte from the received
+    buffer to stash in the L2.
+
+Example:
+	ethernet@24000 {
+		device_type = "network";
+		model = "TSEC";
+		compatible = "gianfar";
+		reg = <0x24000 0x1000>;
+		local-mac-address = [ 00 E0 0C 00 73 00 ];
+		interrupts = <29 2 30 2 34 2>;
+		interrupt-parent = <&mpic>;
+		phy-handle = <&phy0>
+	};
diff --git a/Documentation/devicetree/bindings/net/mdio-gpio.txt b/Documentation/devicetree/bindings/net/mdio-gpio.txt
new file mode 100644
index 0000000..bc95495
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/mdio-gpio.txt
@@ -0,0 +1,19 @@
+MDIO on GPIOs
+
+Currently defined compatibles:
+- virtual,gpio-mdio
+
+MDC and MDIO lines connected to GPIO controllers are listed in the
+gpios property as described in section VIII.1 in the following order:
+
+MDC, MDIO.
+
+Example:
+
+mdio {
+	compatible = "virtual,mdio-gpio";
+	#address-cells = <1>;
+	#size-cells = <0>;
+	gpios = <&qe_pio_a 11
+		 &qe_pio_c 6>;
+};
diff --git a/Documentation/devicetree/bindings/net/phy.txt b/Documentation/devicetree/bindings/net/phy.txt
new file mode 100644
index 0000000..bb8c742
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/phy.txt
@@ -0,0 +1,25 @@
+PHY nodes
+
+Required properties:
+
+ - device_type : Should be "ethernet-phy"
+ - interrupts : <a b> where a is the interrupt number and b is a
+   field that represents an encoding of the sense and level
+   information for the interrupt.  This should be encoded based on
+   the information in section 2) depending on the type of interrupt
+   controller you have.
+ - interrupt-parent : the phandle for the interrupt controller that
+   services interrupts for this device.
+ - reg : The ID number for the phy, usually a small integer
+ - linux,phandle :  phandle for this node; likely referenced by an
+   ethernet controller node.
+
+Example:
+
+ethernet-phy@0 {
+	linux,phandle = <2452000>
+	interrupt-parent = <40000>;
+	interrupts = <35 1>;
+	reg = <0>;
+	device_type = "ethernet-phy";
+};
diff --git a/Documentation/devicetree/bindings/pci/83xx-512x-pci.txt b/Documentation/devicetree/bindings/pci/83xx-512x-pci.txt
new file mode 100644
index 0000000..35a4653
--- /dev/null
+++ b/Documentation/devicetree/bindings/pci/83xx-512x-pci.txt
@@ -0,0 +1,40 @@
+* Freescale 83xx and 512x PCI bridges
+
+Freescale 83xx and 512x SOCs include the same pci bridge core.
+
+83xx/512x specific notes:
+- reg: should contain two address length tuples
+    The first is for the internal pci bridge registers
+    The second is for the pci config space access registers
+
+Example (MPC8313ERDB)
+	pci0: pci@e0008500 {
+		cell-index = <1>;
+		interrupt-map-mask = <0xf800 0x0 0x0 0x7>;
+		interrupt-map = <
+				/* IDSEL 0x0E -mini PCI */
+				 0x7000 0x0 0x0 0x1 &ipic 18 0x8
+				 0x7000 0x0 0x0 0x2 &ipic 18 0x8
+				 0x7000 0x0 0x0 0x3 &ipic 18 0x8
+				 0x7000 0x0 0x0 0x4 &ipic 18 0x8
+
+				/* IDSEL 0x0F - PCI slot */
+				 0x7800 0x0 0x0 0x1 &ipic 17 0x8
+				 0x7800 0x0 0x0 0x2 &ipic 18 0x8
+				 0x7800 0x0 0x0 0x3 &ipic 17 0x8
+				 0x7800 0x0 0x0 0x4 &ipic 18 0x8>;
+		interrupt-parent = <&ipic>;
+		interrupts = <66 0x8>;
+		bus-range = <0x0 0x0>;
+		ranges = <0x02000000 0x0 0x90000000 0x90000000 0x0 0x10000000
+			  0x42000000 0x0 0x80000000 0x80000000 0x0 0x10000000
+			  0x01000000 0x0 0x00000000 0xe2000000 0x0 0x00100000>;
+		clock-frequency = <66666666>;
+		#interrupt-cells = <1>;
+		#size-cells = <2>;
+		#address-cells = <3>;
+		reg = <0xe0008500 0x100		/* internal registers */
+		       0xe0008300 0x8>;		/* config space access registers */
+		compatible = "fsl,mpc8349-pci";
+		device_type = "pci";
+	};
diff --git a/Documentation/devicetree/bindings/powerpc/4xx/cpm.txt b/Documentation/devicetree/bindings/powerpc/4xx/cpm.txt
new file mode 100644
index 0000000..ee45980
--- /dev/null
+++ b/Documentation/devicetree/bindings/powerpc/4xx/cpm.txt
@@ -0,0 +1,52 @@
+PPC4xx Clock Power Management (CPM) node
+
+Required properties:
+	- compatible		: compatible list, currently only "ibm,cpm"
+	- dcr-access-method	: "native"
+	- dcr-reg		: < DCR register range >
+
+Optional properties:
+	- er-offset		: All 4xx SoCs with a CPM controller have
+				  one of two different order for the CPM
+				  registers. Some have the CPM registers
+				  in the following order (ER,FR,SR). The
+				  others have them in the following order
+				  (SR,ER,FR). For the second case set
+				  er-offset = <1>.
+	- unused-units		: specifier consist of one cell. For each
+				  bit in the cell, the corresponding bit
+				  in CPM will be set to turn off unused
+				  devices.
+	- idle-doze		: specifier consist of one cell. For each
+				  bit in the cell, the corresponding bit
+				  in CPM will be set to turn off unused
+				  devices. This is usually just CPM[CPU].
+	- standby		: specifier consist of one cell. For each
+				  bit in the cell, the corresponding bit
+				  in CPM will be set on standby and
+				  restored on resume.
+	- suspend		: specifier consist of one cell. For each
+				  bit in the cell, the corresponding bit
+				  in CPM will be set on suspend (mem) and
+				  restored on resume. Note, for standby
+				  and suspend the corresponding bits can
+				  be different or the same. Usually for
+				  standby only class 2 and 3 units are set.
+				  However, the interface does not care.
+				  If they are the same, the additional
+				  power saving will be seeing if support
+				  is available to put the DDR in self
+				  refresh mode and any additional power
+				  saving techniques for the specific SoC.
+
+Example:
+	CPM0: cpm {
+		compatible = "ibm,cpm";
+		dcr-access-method = "native";
+		dcr-reg = <0x160 0x003>;
+		er-offset = <0>;
+		unused-units = <0x00000100>;
+		idle-doze = <0x02000000>;
+		standby = <0xfeff0000>;
+		suspend = <0xfeff791d>;
+};
diff --git a/Documentation/devicetree/bindings/powerpc/4xx/emac.txt b/Documentation/devicetree/bindings/powerpc/4xx/emac.txt
new file mode 100644
index 0000000..2161334
--- /dev/null
+++ b/Documentation/devicetree/bindings/powerpc/4xx/emac.txt
@@ -0,0 +1,148 @@
+    4xx/Axon EMAC ethernet nodes
+
+    The EMAC ethernet controller in IBM and AMCC 4xx chips, and also
+    the Axon bridge.  To operate this needs to interact with a ths
+    special McMAL DMA controller, and sometimes an RGMII or ZMII
+    interface.  In addition to the nodes and properties described
+    below, the node for the OPB bus on which the EMAC sits must have a
+    correct clock-frequency property.
+
+      i) The EMAC node itself
+
+    Required properties:
+    - device_type       : "network"
+
+    - compatible        : compatible list, contains 2 entries, first is
+			  "ibm,emac-CHIP" where CHIP is the host ASIC (440gx,
+			  405gp, Axon) and second is either "ibm,emac" or
+			  "ibm,emac4".  For Axon, thus, we have: "ibm,emac-axon",
+			  "ibm,emac4"
+    - interrupts        : <interrupt mapping for EMAC IRQ and WOL IRQ>
+    - interrupt-parent  : optional, if needed for interrupt mapping
+    - reg               : <registers mapping>
+    - local-mac-address : 6 bytes, MAC address
+    - mal-device        : phandle of the associated McMAL node
+    - mal-tx-channel    : 1 cell, index of the tx channel on McMAL associated
+			  with this EMAC
+    - mal-rx-channel    : 1 cell, index of the rx channel on McMAL associated
+			  with this EMAC
+    - cell-index        : 1 cell, hardware index of the EMAC cell on a given
+			  ASIC (typically 0x0 and 0x1 for EMAC0 and EMAC1 on
+			  each Axon chip)
+    - max-frame-size    : 1 cell, maximum frame size supported in bytes
+    - rx-fifo-size      : 1 cell, Rx fifo size in bytes for 10 and 100 Mb/sec
+			  operations.
+			  For Axon, 2048
+    - tx-fifo-size      : 1 cell, Tx fifo size in bytes for 10 and 100 Mb/sec
+			  operations.
+			  For Axon, 2048.
+    - fifo-entry-size   : 1 cell, size of a fifo entry (used to calculate
+			  thresholds).
+			  For Axon, 0x00000010
+    - mal-burst-size    : 1 cell, MAL burst size (used to calculate thresholds)
+			  in bytes.
+			  For Axon, 0x00000100 (I think ...)
+    - phy-mode          : string, mode of operations of the PHY interface.
+			  Supported values are: "mii", "rmii", "smii", "rgmii",
+			  "tbi", "gmii", rtbi", "sgmii".
+			  For Axon on CAB, it is "rgmii"
+    - mdio-device       : 1 cell, required iff using shared MDIO registers
+			  (440EP).  phandle of the EMAC to use to drive the
+			  MDIO lines for the PHY used by this EMAC.
+    - zmii-device       : 1 cell, required iff connected to a ZMII.  phandle of
+			  the ZMII device node
+    - zmii-channel      : 1 cell, required iff connected to a ZMII.  Which ZMII
+			  channel or 0xffffffff if ZMII is only used for MDIO.
+    - rgmii-device      : 1 cell, required iff connected to an RGMII. phandle
+			  of the RGMII device node.
+			  For Axon: phandle of plb5/plb4/opb/rgmii
+    - rgmii-channel     : 1 cell, required iff connected to an RGMII.  Which
+			  RGMII channel is used by this EMAC.
+			  Fox Axon: present, whatever value is appropriate for each
+			  EMAC, that is the content of the current (bogus) "phy-port"
+			  property.
+
+    Optional properties:
+    - phy-address       : 1 cell, optional, MDIO address of the PHY. If absent,
+			  a search is performed.
+    - phy-map           : 1 cell, optional, bitmap of addresses to probe the PHY
+			  for, used if phy-address is absent. bit 0x00000001 is
+			  MDIO address 0.
+			  For Axon it can be absent, though my current driver
+			  doesn't handle phy-address yet so for now, keep
+			  0x00ffffff in it.
+    - rx-fifo-size-gige : 1 cell, Rx fifo size in bytes for 1000 Mb/sec
+			  operations (if absent the value is the same as
+			  rx-fifo-size).  For Axon, either absent or 2048.
+    - tx-fifo-size-gige : 1 cell, Tx fifo size in bytes for 1000 Mb/sec
+			  operations (if absent the value is the same as
+			  tx-fifo-size). For Axon, either absent or 2048.
+    - tah-device        : 1 cell, optional. If connected to a TAH engine for
+			  offload, phandle of the TAH device node.
+    - tah-channel       : 1 cell, optional. If appropriate, channel used on the
+			  TAH engine.
+
+    Example:
+
+	EMAC0: ethernet@40000800 {
+		device_type = "network";
+		compatible = "ibm,emac-440gp", "ibm,emac";
+		interrupt-parent = <&UIC1>;
+		interrupts = <1c 4 1d 4>;
+		reg = <40000800 70>;
+		local-mac-address = [00 04 AC E3 1B 1E];
+		mal-device = <&MAL0>;
+		mal-tx-channel = <0 1>;
+		mal-rx-channel = <0>;
+		cell-index = <0>;
+		max-frame-size = <5dc>;
+		rx-fifo-size = <1000>;
+		tx-fifo-size = <800>;
+		phy-mode = "rmii";
+		phy-map = <00000001>;
+		zmii-device = <&ZMII0>;
+		zmii-channel = <0>;
+	};
+
+      ii) McMAL node
+
+    Required properties:
+    - device_type        : "dma-controller"
+    - compatible         : compatible list, containing 2 entries, first is
+			   "ibm,mcmal-CHIP" where CHIP is the host ASIC (like
+			   emac) and the second is either "ibm,mcmal" or
+			   "ibm,mcmal2".
+			   For Axon, "ibm,mcmal-axon","ibm,mcmal2"
+    - interrupts         : <interrupt mapping for the MAL interrupts sources:
+                           5 sources: tx_eob, rx_eob, serr, txde, rxde>.
+                           For Axon: This is _different_ from the current
+			   firmware.  We use the "delayed" interrupts for txeob
+			   and rxeob. Thus we end up with mapping those 5 MPIC
+			   interrupts, all level positive sensitive: 10, 11, 32,
+			   33, 34 (in decimal)
+    - dcr-reg            : < DCR registers range >
+    - dcr-parent         : if needed for dcr-reg
+    - num-tx-chans       : 1 cell, number of Tx channels
+    - num-rx-chans       : 1 cell, number of Rx channels
+
+      iii) ZMII node
+
+    Required properties:
+    - compatible         : compatible list, containing 2 entries, first is
+			   "ibm,zmii-CHIP" where CHIP is the host ASIC (like
+			   EMAC) and the second is "ibm,zmii".
+			   For Axon, there is no ZMII node.
+    - reg                : <registers mapping>
+
+      iv) RGMII node
+
+    Required properties:
+    - compatible         : compatible list, containing 2 entries, first is
+			   "ibm,rgmii-CHIP" where CHIP is the host ASIC (like
+			   EMAC) and the second is "ibm,rgmii".
+                           For Axon, "ibm,rgmii-axon","ibm,rgmii"
+    - reg                : <registers mapping>
+    - revision           : as provided by the RGMII new version register if
+			   available.
+			   For Axon: 0x0000012a
+
diff --git a/Documentation/devicetree/bindings/powerpc/4xx/ndfc.txt b/Documentation/devicetree/bindings/powerpc/4xx/ndfc.txt
new file mode 100644
index 0000000..869f0b5
--- /dev/null
+++ b/Documentation/devicetree/bindings/powerpc/4xx/ndfc.txt
@@ -0,0 +1,39 @@
+AMCC NDFC (NanD Flash Controller)
+
+Required properties:
+- compatible : "ibm,ndfc".
+- reg : should specify chip select and size used for the chip (0x2000).
+
+Optional properties:
+- ccr : NDFC config and control register value (default 0).
+- bank-settings : NDFC bank configuration register value (default 0).
+
+Notes:
+- partition(s) - follows the OF MTD standard for partitions
+
+Example:
+
+ndfc@1,0 {
+	compatible = "ibm,ndfc";
+	reg = <0x00000001 0x00000000 0x00002000>;
+	ccr = <0x00001000>;
+	bank-settings = <0x80002222>;
+	#address-cells = <1>;
+	#size-cells = <1>;
+
+	nand {
+		#address-cells = <1>;
+		#size-cells = <1>;
+
+		partition@0 {
+			label = "kernel";
+			reg = <0x00000000 0x00200000>;
+		};
+		partition@200000 {
+			label = "root";
+			reg = <0x00200000 0x03E00000>;
+		};
+	};
+};
+
+
diff --git a/Documentation/devicetree/bindings/powerpc/4xx/ppc440spe-adma.txt b/Documentation/devicetree/bindings/powerpc/4xx/ppc440spe-adma.txt
new file mode 100644
index 0000000..515ebcf
--- /dev/null
+++ b/Documentation/devicetree/bindings/powerpc/4xx/ppc440spe-adma.txt
@@ -0,0 +1,93 @@
+PPC440SPe DMA/XOR (DMA Controller and XOR Accelerator)
+
+Device nodes needed for operation of the ppc440spe-adma driver
+are specified hereby. These are I2O/DMA, DMA and XOR nodes
+for DMA engines and Memory Queue Module node. The latter is used
+by ADMA driver for configuration of RAID-6 H/W capabilities of
+the PPC440SPe. In addition to the nodes and properties described
+below, the ranges property of PLB node must specify ranges for
+DMA devices.
+
+ i) The I2O node
+
+ Required properties:
+
+ - compatible		: "ibm,i2o-440spe";
+ - reg			: <registers mapping>
+ - dcr-reg		: <DCR registers range>
+
+ Example:
+
+	I2O: i2o@400100000 {
+		compatible = "ibm,i2o-440spe";
+		reg = <0x00000004 0x00100000 0x100>;
+		dcr-reg = <0x060 0x020>;
+	};
+
+
+ ii) The DMA node
+
+ Required properties:
+
+ - compatible		: "ibm,dma-440spe";
+ - cell-index		: 1 cell, hardware index of the DMA engine
+			  (typically 0x0 and 0x1 for DMA0 and DMA1)
+ - reg			: <registers mapping>
+ - dcr-reg		: <DCR registers range>
+ - interrupts		: <interrupt mapping for DMA0/1 interrupts sources:
+			   2 sources: DMAx CS FIFO Needs Service IRQ (on UIC0)
+			   and DMA Error IRQ (on UIC1). The latter is common
+			   for both DMA engines>.
+ - interrupt-parent	: needed for interrupt mapping
+
+ Example:
+
+	DMA0: dma0@400100100 {
+		compatible = "ibm,dma-440spe";
+		cell-index = <0>;
+		reg = <0x00000004 0x00100100 0x100>;
+		dcr-reg = <0x060 0x020>;
+		interrupt-parent = <&DMA0>;
+		interrupts = <0 1>;
+		#interrupt-cells = <1>;
+		#address-cells = <0>;
+		#size-cells = <0>;
+		interrupt-map = <
+			0 &UIC0 0x14 4
+			1 &UIC1 0x16 4>;
+	};
+
+
+ iii) XOR Accelerator node
+
+ Required properties:
+
+ - compatible		: "amcc,xor-accelerator";
+ - reg			: <registers mapping>
+ - interrupts		: <interrupt mapping for XOR interrupt source>
+ - interrupt-parent	: for interrupt mapping
+
+ Example:
+
+	xor-accel@400200000 {
+		compatible = "amcc,xor-accelerator";
+		reg = <0x00000004 0x00200000 0x400>;
+		interrupt-parent = <&UIC1>;
+		interrupts = <0x1f 4>;
+	};
+
+
+ iv) Memory Queue Module node
+
+ Required properties:
+
+ - compatible		: "ibm,mq-440spe";
+ - dcr-reg		: <DCR registers range>
+
+ Example:
+
+	MQ0: mq {
+		compatible = "ibm,mq-440spe";
+		dcr-reg = <0x040 0x020>;
+	};
+
diff --git a/Documentation/devicetree/bindings/powerpc/4xx/reboot.txt b/Documentation/devicetree/bindings/powerpc/4xx/reboot.txt
new file mode 100644
index 0000000..d721726
--- /dev/null
+++ b/Documentation/devicetree/bindings/powerpc/4xx/reboot.txt
@@ -0,0 +1,18 @@
+Reboot property to control system reboot on PPC4xx systems:
+
+By setting "reset_type" to one of the following values, the default
+software reset mechanism may be overidden. Here the possible values of
+"reset_type":
+
+      1 - PPC4xx core reset
+      2 - PPC4xx chip reset
+      3 - PPC4xx system reset (default)
+
+Example:
+
+		cpu@0 {
+			device_type = "cpu";
+			model = "PowerPC,440SPe";
+			...
+			reset-type = <2>;	/* Use chip-reset */
+		};
diff --git a/Documentation/devicetree/bindings/powerpc/fsl/board.txt b/Documentation/devicetree/bindings/powerpc/fsl/board.txt
new file mode 100644
index 0000000..39e9415
--- /dev/null
+++ b/Documentation/devicetree/bindings/powerpc/fsl/board.txt
@@ -0,0 +1,63 @@
+* Board Control and Status (BCSR)
+
+Required properties:
+
+ - compatible : Should be "fsl,<board>-bcsr"
+ - reg : Offset and length of the register set for the device
+
+Example:
+
+	bcsr@f8000000 {
+		compatible = "fsl,mpc8360mds-bcsr";
+		reg = <f8000000 8000>;
+	};
+
+* Freescale on board FPGA
+
+This is the memory-mapped registers for on board FPGA.
+
+Required properities:
+- compatible : should be "fsl,fpga-pixis".
+- reg : should contain the address and the length of the FPPGA register
+  set.
+- interrupt-parent: should specify phandle for the interrupt controller.
+- interrupts : should specify event (wakeup) IRQ.
+
+Example (MPC8610HPCD):
+
+	board-control@e8000000 {
+		compatible = "fsl,fpga-pixis";
+		reg = <0xe8000000 32>;
+		interrupt-parent = <&mpic>;
+		interrupts = <8 8>;
+	};
+
+* Freescale BCSR GPIO banks
+
+Some BCSR registers act as simple GPIO controllers, each such
+register can be represented by the gpio-controller node.
+
+Required properities:
+- compatible : Should be "fsl,<board>-bcsr-gpio".
+- reg : Should contain the address and the length of the GPIO bank
+  register.
+- #gpio-cells : Should be two. The first cell is the pin number and the
+  second cell is used to specify optional parameters (currently unused).
+- gpio-controller : Marks the port as GPIO controller.
+
+Example:
+
+	bcsr@1,0 {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		compatible = "fsl,mpc8360mds-bcsr";
+		reg = <1 0 0x8000>;
+		ranges = <0 1 0 0x8000>;
+
+		bcsr13: gpio-controller@d {
+			#gpio-cells = <2>;
+			compatible = "fsl,mpc8360mds-bcsr-gpio";
+			reg = <0xd 1>;
+			gpio-controller;
+		};
+	};
diff --git a/Documentation/devicetree/bindings/powerpc/fsl/cpm_qe/cpm.txt b/Documentation/devicetree/bindings/powerpc/fsl/cpm_qe/cpm.txt
new file mode 100644
index 0000000..160c752
--- /dev/null
+++ b/Documentation/devicetree/bindings/powerpc/fsl/cpm_qe/cpm.txt
@@ -0,0 +1,67 @@
+* Freescale Communications Processor Module
+
+NOTE: This is an interim binding, and will likely change slightly,
+as more devices are supported.  The QE bindings especially are
+incomplete.
+
+* Root CPM node
+
+Properties:
+- compatible : "fsl,cpm1", "fsl,cpm2", or "fsl,qe".
+- reg : A 48-byte region beginning with CPCR.
+
+Example:
+     cpm@119c0 {
+	#address-cells = <1>;
+	#size-cells = <1>;
+	#interrupt-cells = <2>;
+	compatible = "fsl,mpc8272-cpm", "fsl,cpm2";
+	reg = <119c0 30>;
+     }
+
+* Properties common to multiple CPM/QE devices
+
+- fsl,cpm-command : This value is ORed with the opcode and command flag
+                    to specify the device on which a CPM command operates.
+
+- fsl,cpm-brg : Indicates which baud rate generator the device
+                is associated with.  If absent, an unused BRG
+                should be dynamically allocated.  If zero, the
+                device uses an external clock rather than a BRG.
+
+- reg : Unless otherwise specified, the first resource represents the
+        scc/fcc/ucc registers, and the second represents the device's
+        parameter RAM region (if it has one).
+
+* Multi-User RAM (MURAM)
+
+The multi-user/dual-ported RAM is expressed as a bus under the CPM node.
+
+Ranges must be set up subject to the following restrictions:
+
+- Children's reg nodes must be offsets from the start of all muram, even
+  if the user-data area does not begin at zero.
+- If multiple range entries are used, the difference between the parent
+  address and the child address must be the same in all, so that a single
+  mapping can cover them all while maintaining the ability to determine
+  CPM-side offsets with pointer subtraction.  It is recommended that
+  multiple range entries not be used.
+- A child address of zero must be translatable, even if no reg resources
+  contain it.
+
+A child "data" node must exist, compatible with "fsl,cpm-muram-data", to
+indicate the portion of muram that is usable by the OS for arbitrary
+purposes.  The data node may have an arbitrary number of reg resources,
+all of which contribute to the allocatable muram pool.
+
+Example, based on mpc8272:
+	muram@0 {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges = <0 0 10000>;
+
+		data@0 {
+			compatible = "fsl,cpm-muram-data";
+			reg = <0 2000 9800 800>;
+		};
+	};
diff --git a/Documentation/devicetree/bindings/powerpc/fsl/cpm_qe/cpm/brg.txt b/Documentation/devicetree/bindings/powerpc/fsl/cpm_qe/cpm/brg.txt
new file mode 100644
index 0000000..4c7d45e
--- /dev/null
+++ b/Documentation/devicetree/bindings/powerpc/fsl/cpm_qe/cpm/brg.txt
@@ -0,0 +1,21 @@
+* Baud Rate Generators
+
+Currently defined compatibles:
+fsl,cpm-brg
+fsl,cpm1-brg
+fsl,cpm2-brg
+
+Properties:
+- reg : There may be an arbitrary number of reg resources; BRG
+  numbers are assigned to these in order.
+- clock-frequency : Specifies the base frequency driving
+  the BRG.
+
+Example:
+	brg@119f0 {
+		compatible = "fsl,mpc8272-brg",
+			     "fsl,cpm2-brg",
+			     "fsl,cpm-brg";
+		reg = <119f0 10 115f0 10>;
+		clock-frequency = <d#25000000>;
+	};
diff --git a/Documentation/devicetree/bindings/powerpc/fsl/cpm_qe/cpm/i2c.txt b/Documentation/devicetree/bindings/powerpc/fsl/cpm_qe/cpm/i2c.txt
new file mode 100644
index 0000000..87bc604
--- /dev/null
+++ b/Documentation/devicetree/bindings/powerpc/fsl/cpm_qe/cpm/i2c.txt
@@ -0,0 +1,41 @@
+* I2C
+
+The I2C controller is expressed as a bus under the CPM node.
+
+Properties:
+- compatible : "fsl,cpm1-i2c", "fsl,cpm2-i2c"
+- reg : On CPM2 devices, the second resource doesn't specify the I2C
+  Parameter RAM itself, but the I2C_BASE field of the CPM2 Parameter RAM
+  (typically 0x8afc 0x2).
+- #address-cells : Should be one. The cell is the i2c device address with
+  the r/w bit set to zero.
+- #size-cells : Should be zero.
+- clock-frequency : Can be used to set the i2c clock frequency. If
+  unspecified, a default frequency of 60kHz is being used.
+The following two properties are deprecated. They are only used by legacy
+i2c drivers to find the bus to probe:
+- linux,i2c-index : Can be used to hard code an i2c bus number. By default,
+  the bus number is dynamically assigned by the i2c core.
+- linux,i2c-class : Can be used to override the i2c class. The class is used
+  by legacy i2c device drivers to find a bus in a specific context like
+  system management, video or sound. By default, I2C_CLASS_HWMON (1) is
+  being used. The definition of the classes can be found in
+  include/i2c/i2c.h
+
+Example, based on mpc823:
+
+	i2c@860 {
+		compatible = "fsl,mpc823-i2c",
+			     "fsl,cpm1-i2c";
+		reg = <0x860 0x20 0x3c80 0x30>;
+		interrupts = <16>;
+		interrupt-parent = <&CPM_PIC>;
+		fsl,cpm-command = <0x10>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		rtc@68 {
+			compatible = "dallas,ds1307";
+			reg = <0x68>;
+		};
+	};
diff --git a/Documentation/devicetree/bindings/powerpc/fsl/cpm_qe/cpm/pic.txt b/Documentation/devicetree/bindings/powerpc/fsl/cpm_qe/cpm/pic.txt
new file mode 100644
index 0000000..8e3ee16
--- /dev/null
+++ b/Documentation/devicetree/bindings/powerpc/fsl/cpm_qe/cpm/pic.txt
@@ -0,0 +1,18 @@
+* Interrupt Controllers
+
+Currently defined compatibles:
+- fsl,cpm1-pic
+  - only one interrupt cell
+- fsl,pq1-pic
+- fsl,cpm2-pic
+  - second interrupt cell is level/sense:
+    - 2 is falling edge
+    - 8 is active low
+
+Example:
+	interrupt-controller@10c00 {
+		#interrupt-cells = <2>;
+		interrupt-controller;
+		reg = <10c00 80>;
+		compatible = "mpc8272-pic", "fsl,cpm2-pic";
+	};
diff --git a/Documentation/devicetree/bindings/powerpc/fsl/cpm_qe/cpm/usb.txt b/Documentation/devicetree/bindings/powerpc/fsl/cpm_qe/cpm/usb.txt
new file mode 100644
index 0000000..74bfda4
--- /dev/null
+++ b/Documentation/devicetree/bindings/powerpc/fsl/cpm_qe/cpm/usb.txt
@@ -0,0 +1,15 @@
+* USB (Universal Serial Bus Controller)
+
+Properties:
+- compatible : "fsl,cpm1-usb", "fsl,cpm2-usb", "fsl,qe-usb"
+
+Example:
+	usb@11bc0 {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		compatible = "fsl,cpm2-usb";
+		reg = <11b60 18 8b00 100>;
+		interrupts = <b 8>;
+		interrupt-parent = <&PIC>;
+		fsl,cpm-command = <2e600000>;
+	};
diff --git a/Documentation/devicetree/bindings/powerpc/fsl/cpm_qe/gpio.txt b/Documentation/devicetree/bindings/powerpc/fsl/cpm_qe/gpio.txt
new file mode 100644
index 0000000..349f79f
--- /dev/null
+++ b/Documentation/devicetree/bindings/powerpc/fsl/cpm_qe/gpio.txt
@@ -0,0 +1,38 @@
+Every GPIO controller node must have #gpio-cells property defined,
+this information will be used to translate gpio-specifiers.
+
+On CPM1 devices, all ports are using slightly different register layouts.
+Ports A, C and D are 16bit ports and Ports B and E are 32bit ports.
+
+On CPM2 devices, all ports are 32bit ports and use a common register layout.
+
+Required properties:
+- compatible : "fsl,cpm1-pario-bank-a", "fsl,cpm1-pario-bank-b",
+  "fsl,cpm1-pario-bank-c", "fsl,cpm1-pario-bank-d",
+  "fsl,cpm1-pario-bank-e", "fsl,cpm2-pario-bank"
+- #gpio-cells : Should be two. The first cell is the pin number and the
+  second cell is used to specify optional parameters (currently unused).
+- gpio-controller : Marks the port as GPIO controller.
+
+Example of three SOC GPIO banks defined as gpio-controller nodes:
+
+	CPM1_PIO_A: gpio-controller@950 {
+		#gpio-cells = <2>;
+		compatible = "fsl,cpm1-pario-bank-a";
+		reg = <0x950 0x10>;
+		gpio-controller;
+	};
+
+	CPM1_PIO_B: gpio-controller@ab8 {
+		#gpio-cells = <2>;
+		compatible = "fsl,cpm1-pario-bank-b";
+		reg = <0xab8 0x10>;
+		gpio-controller;
+	};
+
+	CPM1_PIO_E: gpio-controller@ac8 {
+		#gpio-cells = <2>;
+		compatible = "fsl,cpm1-pario-bank-e";
+		reg = <0xac8 0x18>;
+		gpio-controller;
+	};
diff --git a/Documentation/devicetree/bindings/powerpc/fsl/cpm_qe/network.txt b/Documentation/devicetree/bindings/powerpc/fsl/cpm_qe/network.txt
new file mode 100644
index 0000000..0e42694
--- /dev/null
+++ b/Documentation/devicetree/bindings/powerpc/fsl/cpm_qe/network.txt
@@ -0,0 +1,45 @@
+* Network
+
+Currently defined compatibles:
+- fsl,cpm1-scc-enet
+- fsl,cpm2-scc-enet
+- fsl,cpm1-fec-enet
+- fsl,cpm2-fcc-enet (third resource is GFEMR)
+- fsl,qe-enet
+
+Example:
+
+	ethernet@11300 {
+		device_type = "network";
+		compatible = "fsl,mpc8272-fcc-enet",
+			     "fsl,cpm2-fcc-enet";
+		reg = <11300 20 8400 100 11390 1>;
+		local-mac-address = [ 00 00 00 00 00 00 ];
+		interrupts = <20 8>;
+		interrupt-parent = <&PIC>;
+		phy-handle = <&PHY0>;
+		fsl,cpm-command = <12000300>;
+	};
+
+* MDIO
+
+Currently defined compatibles:
+fsl,pq1-fec-mdio (reg is same as first resource of FEC device)
+fsl,cpm2-mdio-bitbang (reg is port C registers)
+
+Properties for fsl,cpm2-mdio-bitbang:
+fsl,mdio-pin : pin of port C controlling mdio data
+fsl,mdc-pin : pin of port C controlling mdio clock
+
+Example:
+	mdio@10d40 {
+		device_type = "mdio";
+		compatible = "fsl,mpc8272ads-mdio-bitbang",
+			     "fsl,mpc8272-mdio-bitbang",
+			     "fsl,cpm2-mdio-bitbang";
+		reg = <10d40 14>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		fsl,mdio-pin = <12>;
+		fsl,mdc-pin = <13>;
+	};
diff --git a/Documentation/devicetree/bindings/powerpc/fsl/cpm_qe/qe.txt b/Documentation/devicetree/bindings/powerpc/fsl/cpm_qe/qe.txt
new file mode 100644
index 0000000..4f89302
--- /dev/null
+++ b/Documentation/devicetree/bindings/powerpc/fsl/cpm_qe/qe.txt
@@ -0,0 +1,115 @@
+* Freescale QUICC Engine module (QE)
+This represents qe module that is installed on PowerQUICC II Pro.
+
+NOTE:  This is an interim binding; it should be updated to fit
+in with the CPM binding later in this document.
+
+Basically, it is a bus of devices, that could act more or less
+as a complete entity (UCC, USB etc ). All of them should be siblings on
+the "root" qe node, using the common properties from there.
+The description below applies to the qe of MPC8360 and
+more nodes and properties would be extended in the future.
+
+i) Root QE device
+
+Required properties:
+- compatible : should be "fsl,qe";
+- model : precise model of the QE, Can be "QE", "CPM", or "CPM2"
+- reg : offset and length of the device registers.
+- bus-frequency : the clock frequency for QUICC Engine.
+- fsl,qe-num-riscs: define how many RISC engines the QE has.
+- fsl,qe-num-snums: define how many serial number(SNUM) the QE can use for the
+  threads.
+
+Optional properties:
+- fsl,firmware-phandle:
+    Usage: required only if there is no fsl,qe-firmware child node
+    Value type: <phandle>
+    Definition: Points to a firmware node (see "QE Firmware Node" below)
+        that contains the firmware that should be uploaded for this QE.
+        The compatible property for the firmware node should say,
+        "fsl,qe-firmware".
+
+Recommended properties
+- brg-frequency : the internal clock source frequency for baud-rate
+  generators in Hz.
+
+Example:
+     qe@e0100000 {
+	#address-cells = <1>;
+	#size-cells = <1>;
+	#interrupt-cells = <2>;
+	compatible = "fsl,qe";
+	ranges = <0 e0100000 00100000>;
+	reg = <e0100000 480>;
+	brg-frequency = <0>;
+	bus-frequency = <179A7B00>;
+     }
+
+* Multi-User RAM (MURAM)
+
+Required properties:
+- compatible : should be "fsl,qe-muram", "fsl,cpm-muram".
+- mode : the could be "host" or "slave".
+- ranges : Should be defined as specified in 1) to describe the
+   translation of MURAM addresses.
+- data-only : sub-node which defines the address area under MURAM
+   bus that can be allocated as data/parameter
+
+Example:
+
+     muram@10000 {
+	compatible = "fsl,qe-muram", "fsl,cpm-muram";
+	ranges = <0 00010000 0000c000>;
+
+	data-only@0{
+		compatible = "fsl,qe-muram-data",
+			     "fsl,cpm-muram-data";
+		reg = <0 c000>;
+	};
+     };
+
+* QE Firmware Node
+
+This node defines a firmware binary that is embedded in the device tree, for
+the purpose of passing the firmware from bootloader to the kernel, or from
+the hypervisor to the guest.
+
+The firmware node itself contains the firmware binary contents, a compatible
+property, and any firmware-specific properties.  The node should be placed
+inside a QE node that needs it.  Doing so eliminates the need for a
+fsl,firmware-phandle property.  Other QE nodes that need the same firmware
+should define an fsl,firmware-phandle property that points to the firmware node
+in the first QE node.
+
+The fsl,firmware property can be specified in the DTS (possibly using incbin)
+or can be inserted by the boot loader at boot time.
+
+Required properties:
+  - compatible
+      Usage: required
+      Value type: <string>
+      Definition: A standard property.  Specify a string that indicates what
+          kind of firmware it is.  For QE, this should be "fsl,qe-firmware".
+
+   - fsl,firmware
+      Usage: required
+      Value type: <prop-encoded-array>, encoded as an array of bytes
+      Definition: A standard property.  This property contains the firmware
+          binary "blob".
+
+Example:
+	qe1@e0080000 {
+		compatible = "fsl,qe";
+		qe_firmware:qe-firmware {
+			compatible = "fsl,qe-firmware";
+			fsl,firmware = [0x70 0xcd 0x00 0x00 0x01 0x46 0x45 ...];
+		};
+		...
+	};
+
+	qe2@e0090000 {
+		compatible = "fsl,qe";
+		fsl,firmware-phandle = <&qe_firmware>;
+		...
+	};
diff --git a/Documentation/devicetree/bindings/powerpc/fsl/cpm_qe/qe/firmware.txt b/Documentation/devicetree/bindings/powerpc/fsl/cpm_qe/qe/firmware.txt
new file mode 100644
index 0000000..249db3a
--- /dev/null
+++ b/Documentation/devicetree/bindings/powerpc/fsl/cpm_qe/qe/firmware.txt
@@ -0,0 +1,24 @@
+* Uploaded QE firmware
+
+      If a new firmware has been uploaded to the QE (usually by the
+      boot loader), then a 'firmware' child node should be added to the QE
+      node.  This node provides information on the uploaded firmware that
+      device drivers may need.
+
+      Required properties:
+      - id: The string name of the firmware.  This is taken from the 'id'
+            member of the qe_firmware structure of the uploaded firmware.
+            Device drivers can search this string to determine if the
+            firmware they want is already present.
+      - extended-modes: The Extended Modes bitfield, taken from the
+		   firmware binary.  It is a 64-bit number represented
+		   as an array of two 32-bit numbers.
+      - virtual-traps: The virtual traps, taken from the firmware binary.
+		  It is an array of 8 32-bit numbers.
+
+Example:
+	firmware {
+		id = "Soft-UART";
+		extended-modes = <0 0>;
+		virtual-traps = <0 0 0 0 0 0 0 0>;
+	};
diff --git a/Documentation/devicetree/bindings/powerpc/fsl/cpm_qe/qe/par_io.txt b/Documentation/devicetree/bindings/powerpc/fsl/cpm_qe/qe/par_io.txt
new file mode 100644
index 0000000..6098426
--- /dev/null
+++ b/Documentation/devicetree/bindings/powerpc/fsl/cpm_qe/qe/par_io.txt
@@ -0,0 +1,51 @@
+* Parallel I/O Ports
+
+This node configures Parallel I/O ports for CPUs with QE support.
+The node should reside in the "soc" node of the tree.  For each
+device that using parallel I/O ports, a child node should be created.
+See the definition of the Pin configuration nodes below for more
+information.
+
+Required properties:
+- device_type : should be "par_io".
+- reg : offset to the register set and its length.
+- num-ports : number of Parallel I/O ports
+
+Example:
+par_io@1400 {
+	reg = <1400 100>;
+	#address-cells = <1>;
+	#size-cells = <0>;
+	device_type = "par_io";
+	num-ports = <7>;
+	ucc_pin@01 {
+		......
+	};
+
+Note that "par_io" nodes are obsolete, and should not be used for
+the new device trees. Instead, each Par I/O bank should be represented
+via its own gpio-controller node:
+
+Required properties:
+- #gpio-cells : should be "2".
+- compatible : should be "fsl,<chip>-qe-pario-bank",
+  "fsl,mpc8323-qe-pario-bank".
+- reg : offset to the register set and its length.
+- gpio-controller : node to identify gpio controllers.
+
+Example:
+	qe_pio_a: gpio-controller@1400 {
+		#gpio-cells = <2>;
+		compatible = "fsl,mpc8360-qe-pario-bank",
+		"fsl,mpc8323-qe-pario-bank";
+		reg = <0x1400 0x18>;
+		gpio-controller;
+	  };
+
+	qe_pio_e: gpio-controller@1460 {
+		#gpio-cells = <2>;
+		compatible = "fsl,mpc8360-qe-pario-bank",
+			     "fsl,mpc8323-qe-pario-bank";
+		reg = <0x1460 0x18>;
+		gpio-controller;
+	  };
diff --git a/Documentation/devicetree/bindings/powerpc/fsl/cpm_qe/qe/pincfg.txt b/Documentation/devicetree/bindings/powerpc/fsl/cpm_qe/qe/pincfg.txt
new file mode 100644
index 0000000..c5b4306
--- /dev/null
+++ b/Documentation/devicetree/bindings/powerpc/fsl/cpm_qe/qe/pincfg.txt
@@ -0,0 +1,60 @@
+* Pin configuration nodes
+
+Required properties:
+- linux,phandle : phandle of this node; likely referenced by a QE
+  device.
+- pio-map : array of pin configurations.  Each pin is defined by 6
+  integers.  The six numbers are respectively: port, pin, dir,
+  open_drain, assignment, has_irq.
+  - port : port number of the pin; 0-6 represent port A-G in UM.
+  - pin : pin number in the port.
+  - dir : direction of the pin, should encode as follows:
+
+     0 = The pin is disabled
+     1 = The pin is an output
+     2 = The pin is an input
+     3 = The pin is I/O
+
+  - open_drain : indicates the pin is normal or wired-OR:
+
+     0 = The pin is actively driven as an output
+     1 = The pin is an open-drain driver. As an output, the pin is
+         driven active-low, otherwise it is three-stated.
+
+  - assignment : function number of the pin according to the Pin Assignment
+    tables in User Manual.  Each pin can have up to 4 possible functions in
+    QE and two options for CPM.
+  - has_irq : indicates if the pin is used as source of external
+    interrupts.
+
+Example:
+     ucc_pin@01 {
+	linux,phandle = <140001>;
+	pio-map = <
+	/* port  pin  dir  open_drain  assignment  has_irq */
+		0  3  1  0  1  0 	/* TxD0 */
+		0  4  1  0  1  0 	/* TxD1 */
+		0  5  1  0  1  0 	/* TxD2 */
+		0  6  1  0  1  0 	/* TxD3 */
+		1  6  1  0  3  0 	/* TxD4 */
+		1  7  1  0  1  0 	/* TxD5 */
+		1  9  1  0  2  0 	/* TxD6 */
+		1  a  1  0  2  0 	/* TxD7 */
+		0  9  2  0  1  0 	/* RxD0 */
+		0  a  2  0  1  0 	/* RxD1 */
+		0  b  2  0  1  0 	/* RxD2 */
+		0  c  2  0  1  0 	/* RxD3 */
+		0  d  2  0  1  0 	/* RxD4 */
+		1  1  2  0  2  0 	/* RxD5 */
+		1  0  2  0  2  0 	/* RxD6 */
+		1  4  2  0  2  0 	/* RxD7 */
+		0  7  1  0  1  0 	/* TX_EN */
+		0  8  1  0  1  0 	/* TX_ER */
+		0  f  2  0  1  0 	/* RX_DV */
+		0  10 2  0  1  0 	/* RX_ER */
+		0  0  2  0  1  0 	/* RX_CLK */
+		2  9  1  0  3  0 	/* GTX_CLK - CLK10 */
+		2  8  2  0  1  0>;	/* GTX125 - CLK9 */
+     };
+
+
diff --git a/Documentation/devicetree/bindings/powerpc/fsl/cpm_qe/qe/ucc.txt b/Documentation/devicetree/bindings/powerpc/fsl/cpm_qe/qe/ucc.txt
new file mode 100644
index 0000000..e47734b
--- /dev/null
+++ b/Documentation/devicetree/bindings/powerpc/fsl/cpm_qe/qe/ucc.txt
@@ -0,0 +1,70 @@
+* UCC (Unified Communications Controllers)
+
+Required properties:
+- device_type : should be "network", "hldc", "uart", "transparent"
+  "bisync", "atm", or "serial".
+- compatible : could be "ucc_geth" or "fsl_atm" and so on.
+- cell-index : the ucc number(1-8), corresponding to UCCx in UM.
+- reg : Offset and length of the register set for the device
+- interrupts : <a b> where a is the interrupt number and b is a
+  field that represents an encoding of the sense and level
+  information for the interrupt.  This should be encoded based on
+  the information in section 2) depending on the type of interrupt
+  controller you have.
+- interrupt-parent : the phandle for the interrupt controller that
+  services interrupts for this device.
+- pio-handle : The phandle for the Parallel I/O port configuration.
+- port-number : for UART drivers, the port number to use, between 0 and 3.
+  This usually corresponds to the /dev/ttyQE device, e.g. <0> = /dev/ttyQE0.
+  The port number is added to the minor number of the device.  Unlike the
+  CPM UART driver, the port-number is required for the QE UART driver.
+- soft-uart : for UART drivers, if specified this means the QE UART device
+  driver should use "Soft-UART" mode, which is needed on some SOCs that have
+  broken UART hardware.  Soft-UART is provided via a microcode upload.
+- rx-clock-name: the UCC receive clock source
+  "none": clock source is disabled
+  "brg1" through "brg16": clock source is BRG1-BRG16, respectively
+  "clk1" through "clk24": clock source is CLK1-CLK24, respectively
+- tx-clock-name: the UCC transmit clock source
+  "none": clock source is disabled
+  "brg1" through "brg16": clock source is BRG1-BRG16, respectively
+  "clk1" through "clk24": clock source is CLK1-CLK24, respectively
+The following two properties are deprecated.  rx-clock has been replaced
+with rx-clock-name, and tx-clock has been replaced with tx-clock-name.
+Drivers that currently use the deprecated properties should continue to
+do so, in order to support older device trees, but they should be updated
+to check for the new properties first.
+- rx-clock : represents the UCC receive clock source.
+  0x00 : clock source is disabled;
+  0x1~0x10 : clock source is BRG1~BRG16 respectively;
+  0x11~0x28: clock source is QE_CLK1~QE_CLK24 respectively.
+- tx-clock: represents the UCC transmit clock source;
+  0x00 : clock source is disabled;
+  0x1~0x10 : clock source is BRG1~BRG16 respectively;
+  0x11~0x28: clock source is QE_CLK1~QE_CLK24 respectively.
+
+Required properties for network device_type:
+- mac-address : list of bytes representing the ethernet address.
+- phy-handle : The phandle for the PHY connected to this controller.
+
+Recommended properties:
+- phy-connection-type : a string naming the controller/PHY interface type,
+  i.e., "mii" (default), "rmii", "gmii", "rgmii", "rgmii-id" (Internal
+  Delay), "rgmii-txid" (delay on TX only), "rgmii-rxid" (delay on RX only),
+  "tbi", or "rtbi".
+
+Example:
+	ucc@2000 {
+		device_type = "network";
+		compatible = "ucc_geth";
+		cell-index = <1>;
+		reg = <2000 200>;
+		interrupts = <a0 0>;
+		interrupt-parent = <700>;
+		mac-address = [ 00 04 9f 00 23 23 ];
+		rx-clock = "none";
+		tx-clock = "clk9";
+		phy-handle = <212000>;
+		phy-connection-type = "gmii";
+		pio-handle = <140001>;
+	};
diff --git a/Documentation/devicetree/bindings/powerpc/fsl/cpm_qe/qe/usb.txt b/Documentation/devicetree/bindings/powerpc/fsl/cpm_qe/qe/usb.txt
new file mode 100644
index 0000000..9ccd5f3
--- /dev/null
+++ b/Documentation/devicetree/bindings/powerpc/fsl/cpm_qe/qe/usb.txt
@@ -0,0 +1,37 @@
+Freescale QUICC Engine USB Controller
+
+Required properties:
+- compatible : should be "fsl,<chip>-qe-usb", "fsl,mpc8323-qe-usb".
+- reg : the first two cells should contain usb registers location and
+  length, the next two two cells should contain PRAM location and
+  length.
+- interrupts : should contain USB interrupt.
+- interrupt-parent : interrupt source phandle.
+- fsl,fullspeed-clock : specifies the full speed USB clock source:
+  "none": clock source is disabled
+  "brg1" through "brg16": clock source is BRG1-BRG16, respectively
+  "clk1" through "clk24": clock source is CLK1-CLK24, respectively
+- fsl,lowspeed-clock : specifies the low speed USB clock source:
+  "none": clock source is disabled
+  "brg1" through "brg16": clock source is BRG1-BRG16, respectively
+  "clk1" through "clk24": clock source is CLK1-CLK24, respectively
+- hub-power-budget : USB power budget for the root hub, in mA.
+- gpios : should specify GPIOs in this order: USBOE, USBTP, USBTN, USBRP,
+  USBRN, SPEED (optional), and POWER (optional).
+
+Example:
+
+usb@6c0 {
+	compatible = "fsl,mpc8360-qe-usb", "fsl,mpc8323-qe-usb";
+	reg = <0x6c0 0x40 0x8b00 0x100>;
+	interrupts = <11>;
+	interrupt-parent = <&qeic>;
+	fsl,fullspeed-clock = "clk21";
+	gpios = <&qe_pio_b  2 0 /* USBOE */
+		 &qe_pio_b  3 0 /* USBTP */
+		 &qe_pio_b  8 0 /* USBTN */
+		 &qe_pio_b  9 0 /* USBRP */
+		 &qe_pio_b 11 0 /* USBRN */
+		 &qe_pio_e 20 0 /* SPEED */
+		 &qe_pio_e 21 0 /* POWER */>;
+};
diff --git a/Documentation/devicetree/bindings/powerpc/fsl/cpm_qe/serial.txt b/Documentation/devicetree/bindings/powerpc/fsl/cpm_qe/serial.txt
new file mode 100644
index 0000000..2ea76d9
--- /dev/null
+++ b/Documentation/devicetree/bindings/powerpc/fsl/cpm_qe/serial.txt
@@ -0,0 +1,32 @@
+* Serial
+
+Currently defined compatibles:
+- fsl,cpm1-smc-uart
+- fsl,cpm2-smc-uart
+- fsl,cpm1-scc-uart
+- fsl,cpm2-scc-uart
+- fsl,qe-uart
+
+Modem control lines connected to GPIO controllers are listed in the gpios
+property as described in booting-without-of.txt, section IX.1 in the following
+order:
+
+CTS, RTS, DCD, DSR, DTR, and RI.
+
+The gpios property is optional and can be left out when control lines are
+not used.
+
+Example:
+
+	serial@11a00 {
+		device_type = "serial";
+		compatible = "fsl,mpc8272-scc-uart",
+			     "fsl,cpm2-scc-uart";
+		reg = <11a00 20 8000 100>;
+		interrupts = <28 8>;
+		interrupt-parent = <&PIC>;
+		fsl,cpm-brg = <1>;
+		fsl,cpm-command = <00800000>;
+		gpios = <&gpio_c 15 0
+			 &gpio_d 29 0>;
+	};
diff --git a/Documentation/devicetree/bindings/powerpc/fsl/diu.txt b/Documentation/devicetree/bindings/powerpc/fsl/diu.txt
new file mode 100644
index 0000000..b66cb6d
--- /dev/null
+++ b/Documentation/devicetree/bindings/powerpc/fsl/diu.txt
@@ -0,0 +1,34 @@
+* Freescale Display Interface Unit
+
+The Freescale DIU is a LCD controller, with proper hardware, it can also
+drive DVI monitors.
+
+Required properties:
+- compatible : should be "fsl,diu" or "fsl,mpc5121-diu".
+- reg : should contain at least address and length of the DIU register
+  set.
+- interrupts : one DIU interrupt should be described here.
+- interrupt-parent : the phandle for the interrupt controller that
+  services interrupts for this device.
+
+Optional properties:
+- edid : verbatim EDID data block describing attached display.
+  Data from the detailed timing descriptor will be used to
+  program the display controller.
+
+Example (MPC8610HPCD):
+	display@2c000 {
+		compatible = "fsl,diu";
+		reg = <0x2c000 100>;
+		interrupts = <72 2>;
+		interrupt-parent = <&mpic>;
+	};
+
+Example for MPC5121:
+	display@2100 {
+		compatible = "fsl,mpc5121-diu";
+		reg = <0x2100 0x100>;
+		interrupts = <64 0x8>;
+		interrupt-parent = <&ipic>;
+		edid = [edid-data];
+	};
diff --git a/Documentation/devicetree/bindings/powerpc/fsl/dma.txt b/Documentation/devicetree/bindings/powerpc/fsl/dma.txt
new file mode 100644
index 0000000..2a4b4bc
--- /dev/null
+++ b/Documentation/devicetree/bindings/powerpc/fsl/dma.txt
@@ -0,0 +1,144 @@
+* Freescale 83xx DMA Controller
+
+Freescale PowerPC 83xx have on chip general purpose DMA controllers.
+
+Required properties:
+
+- compatible        : compatible list, contains 2 entries, first is
+		 "fsl,CHIP-dma", where CHIP is the processor
+		 (mpc8349, mpc8360, etc.) and the second is
+		 "fsl,elo-dma"
+- reg               : <registers mapping for DMA general status reg>
+- ranges		: Should be defined as specified in 1) to describe the
+		  DMA controller channels.
+- cell-index        : controller index.  0 for controller @ 0x8100
+- interrupts        : <interrupt mapping for DMA IRQ>
+- interrupt-parent  : optional, if needed for interrupt mapping
+
+
+- DMA channel nodes:
+        - compatible        : compatible list, contains 2 entries, first is
+			 "fsl,CHIP-dma-channel", where CHIP is the processor
+			 (mpc8349, mpc8350, etc.) and the second is
+			 "fsl,elo-dma-channel". However, see note below.
+        - reg               : <registers mapping for channel>
+        - cell-index        : dma channel index starts at 0.
+
+Optional properties:
+        - interrupts        : <interrupt mapping for DMA channel IRQ>
+			  (on 83xx this is expected to be identical to
+			   the interrupts property of the parent node)
+        - interrupt-parent  : optional, if needed for interrupt mapping
+
+Example:
+	dma@82a8 {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		compatible = "fsl,mpc8349-dma", "fsl,elo-dma";
+		reg = <0x82a8 4>;
+		ranges = <0 0x8100 0x1a4>;
+		interrupt-parent = <&ipic>;
+		interrupts = <71 8>;
+		cell-index = <0>;
+		dma-channel@0 {
+			compatible = "fsl,mpc8349-dma-channel", "fsl,elo-dma-channel";
+			cell-index = <0>;
+			reg = <0 0x80>;
+			interrupt-parent = <&ipic>;
+			interrupts = <71 8>;
+		};
+		dma-channel@80 {
+			compatible = "fsl,mpc8349-dma-channel", "fsl,elo-dma-channel";
+			cell-index = <1>;
+			reg = <0x80 0x80>;
+			interrupt-parent = <&ipic>;
+			interrupts = <71 8>;
+		};
+		dma-channel@100 {
+			compatible = "fsl,mpc8349-dma-channel", "fsl,elo-dma-channel";
+			cell-index = <2>;
+			reg = <0x100 0x80>;
+			interrupt-parent = <&ipic>;
+			interrupts = <71 8>;
+		};
+		dma-channel@180 {
+			compatible = "fsl,mpc8349-dma-channel", "fsl,elo-dma-channel";
+			cell-index = <3>;
+			reg = <0x180 0x80>;
+			interrupt-parent = <&ipic>;
+			interrupts = <71 8>;
+		};
+	};
+
+* Freescale 85xx/86xx DMA Controller
+
+Freescale PowerPC 85xx/86xx have on chip general purpose DMA controllers.
+
+Required properties:
+
+- compatible        : compatible list, contains 2 entries, first is
+		 "fsl,CHIP-dma", where CHIP is the processor
+		 (mpc8540, mpc8540, etc.) and the second is
+		 "fsl,eloplus-dma"
+- reg               : <registers mapping for DMA general status reg>
+- cell-index        : controller index.  0 for controller @ 0x21000,
+                                         1 for controller @ 0xc000
+- ranges		: Should be defined as specified in 1) to describe the
+		  DMA controller channels.
+
+- DMA channel nodes:
+        - compatible        : compatible list, contains 2 entries, first is
+			 "fsl,CHIP-dma-channel", where CHIP is the processor
+			 (mpc8540, mpc8560, etc.) and the second is
+			 "fsl,eloplus-dma-channel". However, see note below.
+        - cell-index        : dma channel index starts at 0.
+        - reg               : <registers mapping for channel>
+        - interrupts        : <interrupt mapping for DMA channel IRQ>
+        - interrupt-parent  : optional, if needed for interrupt mapping
+
+Example:
+	dma@21300 {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		compatible = "fsl,mpc8540-dma", "fsl,eloplus-dma";
+		reg = <0x21300 4>;
+		ranges = <0 0x21100 0x200>;
+		cell-index = <0>;
+		dma-channel@0 {
+			compatible = "fsl,mpc8540-dma-channel", "fsl,eloplus-dma-channel";
+			reg = <0 0x80>;
+			cell-index = <0>;
+			interrupt-parent = <&mpic>;
+			interrupts = <20 2>;
+		};
+		dma-channel@80 {
+			compatible = "fsl,mpc8540-dma-channel", "fsl,eloplus-dma-channel";
+			reg = <0x80 0x80>;
+			cell-index = <1>;
+			interrupt-parent = <&mpic>;
+			interrupts = <21 2>;
+		};
+		dma-channel@100 {
+			compatible = "fsl,mpc8540-dma-channel", "fsl,eloplus-dma-channel";
+			reg = <0x100 0x80>;
+			cell-index = <2>;
+			interrupt-parent = <&mpic>;
+			interrupts = <22 2>;
+		};
+		dma-channel@180 {
+			compatible = "fsl,mpc8540-dma-channel", "fsl,eloplus-dma-channel";
+			reg = <0x180 0x80>;
+			cell-index = <3>;
+			interrupt-parent = <&mpic>;
+			interrupts = <23 2>;
+		};
+	};
+
+Note on DMA channel compatible properties: The compatible property must say
+"fsl,elo-dma-channel" or "fsl,eloplus-dma-channel" to be used by the Elo DMA
+driver (fsldma).  Any DMA channel used by fsldma cannot be used by another
+DMA driver, such as the SSI sound drivers for the MPC8610.  Therefore, any DMA
+channel that should be used for another driver should not use
+"fsl,elo-dma-channel" or "fsl,eloplus-dma-channel".  For the SSI drivers, for
+example, the compatible property should be "fsl,ssi-dma-channel".  See ssi.txt
+for more information.
diff --git a/Documentation/devicetree/bindings/powerpc/fsl/ecm.txt b/Documentation/devicetree/bindings/powerpc/fsl/ecm.txt
new file mode 100644
index 0000000..f514f29
--- /dev/null
+++ b/Documentation/devicetree/bindings/powerpc/fsl/ecm.txt
@@ -0,0 +1,64 @@
+=====================================================================
+E500 LAW & Coherency Module Device Tree Binding
+Copyright (C) 2009 Freescale Semiconductor Inc.
+=====================================================================
+
+Local Access Window (LAW) Node
+
+The LAW node represents the region of CCSR space where local access
+windows are configured.  For ECM based devices this is the first 4k
+of CCSR space that includes CCSRBAR, ALTCBAR, ALTCAR, BPTR, and some
+number of local access windows as specified by fsl,num-laws.
+
+PROPERTIES
+
+  - compatible
+      Usage: required
+      Value type: <string>
+      Definition: Must include "fsl,ecm-law"
+
+  - reg
+      Usage: required
+      Value type: <prop-encoded-array>
+      Definition: A standard property.  The value specifies the
+          physical address offset and length of the CCSR space
+          registers.
+
+  - fsl,num-laws
+      Usage: required
+      Value type: <u32>
+      Definition: The value specifies the number of local access
+          windows for this device.
+
+=====================================================================
+
+E500 Coherency Module Node
+
+The E500 LAW node represents the region of CCSR space where ECM config
+and error reporting registers exist, this is the second 4k (0x1000)
+of CCSR space.
+
+PROPERTIES
+
+  - compatible
+      Usage: required
+      Value type: <string>
+      Definition: Must include "fsl,CHIP-ecm", "fsl,ecm" where
+      CHIP is the processor (mpc8572, mpc8544, etc.)
+
+  - reg
+      Usage: required
+      Value type: <prop-encoded-array>
+      Definition: A standard property.  The value specifies the
+          physical address offset and length of the CCSR space
+          registers.
+
+   - interrupts
+      Usage: required
+      Value type: <prop-encoded-array>
+
+   - interrupt-parent
+      Usage: required
+      Value type: <phandle>
+
+=====================================================================
diff --git a/Documentation/devicetree/bindings/powerpc/fsl/gtm.txt b/Documentation/devicetree/bindings/powerpc/fsl/gtm.txt
new file mode 100644
index 0000000..9a33efd
--- /dev/null
+++ b/Documentation/devicetree/bindings/powerpc/fsl/gtm.txt
@@ -0,0 +1,31 @@
+* Freescale General-purpose Timers Module
+
+Required properties:
+  - compatible : should be
+    "fsl,<chip>-gtm", "fsl,gtm" for SOC GTMs
+    "fsl,<chip>-qe-gtm", "fsl,qe-gtm", "fsl,gtm" for QE GTMs
+    "fsl,<chip>-cpm2-gtm", "fsl,cpm2-gtm", "fsl,gtm" for CPM2 GTMs
+  - reg : should contain gtm registers location and length (0x40).
+  - interrupts : should contain four interrupts.
+  - interrupt-parent : interrupt source phandle.
+  - clock-frequency : specifies the frequency driving the timer.
+
+Example:
+
+timer@500 {
+	compatible = "fsl,mpc8360-gtm", "fsl,gtm";
+	reg = <0x500 0x40>;
+	interrupts = <90 8 78 8 84 8 72 8>;
+	interrupt-parent = <&ipic>;
+	/* filled by u-boot */
+	clock-frequency = <0>;
+};
+
+timer@440 {
+	compatible = "fsl,mpc8360-qe-gtm", "fsl,qe-gtm", "fsl,gtm";
+	reg = <0x440 0x40>;
+	interrupts = <12 13 14 15>;
+	interrupt-parent = <&qeic>;
+	/* filled by u-boot */
+	clock-frequency = <0>;
+};
diff --git a/Documentation/devicetree/bindings/powerpc/fsl/guts.txt b/Documentation/devicetree/bindings/powerpc/fsl/guts.txt
new file mode 100644
index 0000000..9e7a241
--- /dev/null
+++ b/Documentation/devicetree/bindings/powerpc/fsl/guts.txt
@@ -0,0 +1,25 @@
+* Global Utilities Block
+
+The global utilities block controls power management, I/O device
+enabling, power-on-reset configuration monitoring, general-purpose
+I/O signal configuration, alternate function selection for multiplexed
+signals, and clock control.
+
+Required properties:
+
+ - compatible : Should define the compatible device type for
+   global-utilities.
+ - reg : Offset and length of the register set for the device.
+
+Recommended properties:
+
+ - fsl,has-rstcr : Indicates that the global utilities register set
+   contains a functioning "reset control register" (i.e. the board
+   is wired to reset upon setting the HRESET_REQ bit in this register).
+
+Example:
+	global-utilities@e0000 {	/* global utilities block */
+		compatible = "fsl,mpc8548-guts";
+		reg = <e0000 1000>;
+		fsl,has-rstcr;
+	};
diff --git a/Documentation/devicetree/bindings/powerpc/fsl/lbc.txt b/Documentation/devicetree/bindings/powerpc/fsl/lbc.txt
new file mode 100644
index 0000000..3300fec
--- /dev/null
+++ b/Documentation/devicetree/bindings/powerpc/fsl/lbc.txt
@@ -0,0 +1,35 @@
+* Chipselect/Local Bus
+
+Properties:
+- name : Should be localbus
+- #address-cells : Should be either two or three.  The first cell is the
+                   chipselect number, and the remaining cells are the
+                   offset into the chipselect.
+- #size-cells : Either one or two, depending on how large each chipselect
+                can be.
+- ranges : Each range corresponds to a single chipselect, and cover
+           the entire access window as configured.
+
+Example:
+	localbus@f0010100 {
+		compatible = "fsl,mpc8272-localbus",
+			   "fsl,pq2-localbus";
+		#address-cells = <2>;
+		#size-cells = <1>;
+		reg = <f0010100 40>;
+
+		ranges = <0 0 fe000000 02000000
+			  1 0 f4500000 00008000>;
+
+		flash@0,0 {
+			compatible = "jedec-flash";
+			reg = <0 0 2000000>;
+			bank-width = <4>;
+			device-width = <1>;
+		};
+
+		board-control@1,0 {
+			reg = <1 0 20>;
+			compatible = "fsl,mpc8272ads-bcsr";
+		};
+	};
diff --git a/Documentation/devicetree/bindings/powerpc/fsl/mcm.txt b/Documentation/devicetree/bindings/powerpc/fsl/mcm.txt
new file mode 100644
index 0000000..4ceda9b
--- /dev/null
+++ b/Documentation/devicetree/bindings/powerpc/fsl/mcm.txt
@@ -0,0 +1,64 @@
+=====================================================================
+MPX LAW & Coherency Module Device Tree Binding
+Copyright (C) 2009 Freescale Semiconductor Inc.
+=====================================================================
+
+Local Access Window (LAW) Node
+
+The LAW node represents the region of CCSR space where local access
+windows are configured.  For MCM based devices this is the first 4k
+of CCSR space that includes CCSRBAR, ALTCBAR, ALTCAR, BPTR, and some
+number of local access windows as specified by fsl,num-laws.
+
+PROPERTIES
+
+  - compatible
+      Usage: required
+      Value type: <string>
+      Definition: Must include "fsl,mcm-law"
+
+  - reg
+      Usage: required
+      Value type: <prop-encoded-array>
+      Definition: A standard property.  The value specifies the
+          physical address offset and length of the CCSR space
+          registers.
+
+  - fsl,num-laws
+      Usage: required
+      Value type: <u32>
+      Definition: The value specifies the number of local access
+          windows for this device.
+
+=====================================================================
+
+MPX Coherency Module Node
+
+The MPX LAW node represents the region of CCSR space where MCM config
+and error reporting registers exist, this is the second 4k (0x1000)
+of CCSR space.
+
+PROPERTIES
+
+  - compatible
+      Usage: required
+      Value type: <string>
+      Definition: Must include "fsl,CHIP-mcm", "fsl,mcm" where
+      CHIP is the processor (mpc8641, mpc8610, etc.)
+
+  - reg
+      Usage: required
+      Value type: <prop-encoded-array>
+      Definition: A standard property.  The value specifies the
+          physical address offset and length of the CCSR space
+          registers.
+
+   - interrupts
+      Usage: required
+      Value type: <prop-encoded-array>
+
+   - interrupt-parent
+      Usage: required
+      Value type: <phandle>
+
+=====================================================================
diff --git a/Documentation/devicetree/bindings/powerpc/fsl/mcu-mpc8349emitx.txt b/Documentation/devicetree/bindings/powerpc/fsl/mcu-mpc8349emitx.txt
new file mode 100644
index 0000000..0f76633
--- /dev/null
+++ b/Documentation/devicetree/bindings/powerpc/fsl/mcu-mpc8349emitx.txt
@@ -0,0 +1,17 @@
+Freescale MPC8349E-mITX-compatible Power Management Micro Controller Unit (MCU)
+
+Required properties:
+- compatible : "fsl,<mcu-chip>-<board>", "fsl,mcu-mpc8349emitx".
+- reg : should specify I2C address (0x0a).
+- #gpio-cells : should be 2.
+- gpio-controller : should be present.
+
+Example:
+
+mcu@0a {
+	#gpio-cells = <2>;
+	compatible = "fsl,mc9s08qg8-mpc8349emitx",
+		     "fsl,mcu-mpc8349emitx";
+	reg = <0x0a>;
+	gpio-controller;
+};
diff --git a/Documentation/devicetree/bindings/powerpc/fsl/mpc5121-psc.txt b/Documentation/devicetree/bindings/powerpc/fsl/mpc5121-psc.txt
new file mode 100644
index 0000000..8832e87
--- /dev/null
+++ b/Documentation/devicetree/bindings/powerpc/fsl/mpc5121-psc.txt
@@ -0,0 +1,70 @@
+MPC5121 PSC Device Tree Bindings
+
+PSC in UART mode
+----------------
+
+For PSC in UART mode the needed PSC serial devices
+are specified by fsl,mpc5121-psc-uart nodes in the
+fsl,mpc5121-immr SoC node. Additionally the PSC FIFO
+Controller node fsl,mpc5121-psc-fifo is requered there:
+
+fsl,mpc5121-psc-uart nodes
+--------------------------
+
+Required properties :
+ - compatible : Should contain "fsl,mpc5121-psc-uart" and "fsl,mpc5121-psc"
+ - cell-index : Index of the PSC in hardware
+ - reg : Offset and length of the register set for the PSC device
+ - interrupts : <a b> where a is the interrupt number of the
+   PSC FIFO Controller and b is a field that represents an
+   encoding of the sense and level information for the interrupt.
+ - interrupt-parent : the phandle for the interrupt controller that
+   services interrupts for this device.
+
+Recommended properties :
+ - fsl,rx-fifo-size : the size of the RX fifo slice (a multiple of 4)
+ - fsl,tx-fifo-size : the size of the TX fifo slice (a multiple of 4)
+
+
+fsl,mpc5121-psc-fifo node
+-------------------------
+
+Required properties :
+ - compatible : Should be "fsl,mpc5121-psc-fifo"
+ - reg : Offset and length of the register set for the PSC
+         FIFO Controller
+ - interrupts : <a b> where a is the interrupt number of the
+   PSC FIFO Controller and b is a field that represents an
+   encoding of the sense and level information for the interrupt.
+ - interrupt-parent : the phandle for the interrupt controller that
+   services interrupts for this device.
+
+
+Example for a board using PSC0 and PSC1 devices in serial mode:
+
+serial@11000 {
+	compatible = "fsl,mpc5121-psc-uart", "fsl,mpc5121-psc";
+	cell-index = <0>;
+	reg = <0x11000 0x100>;
+	interrupts = <40 0x8>;
+	interrupt-parent = < &ipic >;
+	fsl,rx-fifo-size = <16>;
+	fsl,tx-fifo-size = <16>;
+};
+
+serial@11100 {
+	compatible = "fsl,mpc5121-psc-uart", "fsl,mpc5121-psc";
+	cell-index = <1>;
+	reg = <0x11100 0x100>;
+	interrupts = <40 0x8>;
+	interrupt-parent = < &ipic >;
+	fsl,rx-fifo-size = <16>;
+	fsl,tx-fifo-size = <16>;
+};
+
+pscfifo@11f00 {
+	compatible = "fsl,mpc5121-psc-fifo";
+	reg = <0x11f00 0x100>;
+	interrupts = <40 0x8>;
+	interrupt-parent = < &ipic >;
+};
diff --git a/Documentation/devicetree/bindings/powerpc/fsl/mpc5200.txt b/Documentation/devicetree/bindings/powerpc/fsl/mpc5200.txt
new file mode 100644
index 0000000..4ccb2cd
--- /dev/null
+++ b/Documentation/devicetree/bindings/powerpc/fsl/mpc5200.txt
@@ -0,0 +1,198 @@
+MPC5200 Device Tree Bindings
+----------------------------
+
+(c) 2006-2009 Secret Lab Technologies Ltd
+Grant Likely <grant.likely@secretlab.ca>
+
+Naming conventions
+------------------
+For mpc5200 on-chip devices, the format for each compatible value is
+<chip>-<device>[-<mode>].  The OS should be able to match a device driver
+to the device based solely on the compatible value.  If two drivers
+match on the compatible list; the 'most compatible' driver should be
+selected.
+
+The split between the MPC5200 and the MPC5200B leaves a bit of a
+conundrum.  How should the compatible property be set up to provide
+maximum compatibility information; but still accurately describe the
+chip?  For the MPC5200; the answer is easy.  Most of the SoC devices
+originally appeared on the MPC5200.  Since they didn't exist anywhere
+else; the 5200 compatible properties will contain only one item;
+"fsl,mpc5200-<device>".
+
+The 5200B is almost the same as the 5200, but not quite.  It fixes
+silicon bugs and it adds a small number of enhancements.  Most of the
+devices either provide exactly the same interface as on the 5200.  A few
+devices have extra functions but still have a backwards compatible mode.
+To express this information as completely as possible, 5200B device trees
+should have two items in the compatible list:
+	compatible = "fsl,mpc5200b-<device>","fsl,mpc5200-<device>";
+
+It is *strongly* recommended that 5200B device trees follow this convention
+(instead of only listing the base mpc5200 item).
+
+ie. ethernet on mpc5200: compatible = "fsl,mpc5200-fec";
+    ethernet on mpc5200b: compatible = "fsl,mpc5200b-fec", "fsl,mpc5200-fec";
+
+Modal devices, like PSCs, also append the configured function to the
+end of the compatible field.  ie. A PSC in i2s mode would specify
+"fsl,mpc5200-psc-i2s", not "fsl,mpc5200-i2s".  This convention is chosen to
+avoid naming conflicts with non-psc devices providing the same
+function.  For example, "fsl,mpc5200-spi" and "fsl,mpc5200-psc-spi" describe
+the mpc5200 simple spi device and a PSC spi mode respectively.
+
+At the time of writing, exact chip may be either 'fsl,mpc5200' or
+'fsl,mpc5200b'.
+
+The soc node
+------------
+This node describes the on chip SOC peripherals.  Every mpc5200 based
+board will have this node, and as such there is a common naming
+convention for SOC devices.
+
+Required properties:
+name			description
+----			-----------
+ranges			Memory range of the internal memory mapped registers.
+			Should be <0 [baseaddr] 0xc000>
+reg			Should be <[baseaddr] 0x100>
+compatible		mpc5200: "fsl,mpc5200-immr"
+			mpc5200b: "fsl,mpc5200b-immr"
+system-frequency	'fsystem' frequency in Hz; XLB, IPB, USB and PCI
+			clocks are derived from the fsystem clock.
+bus-frequency		IPB bus frequency in Hz.  Clock rate
+			used by most of the soc devices.
+
+soc child nodes
+---------------
+Any on chip SOC devices available to Linux must appear as soc5200 child nodes.
+
+Note: The tables below show the value for the mpc5200.  A mpc5200b device
+tree should use the "fsl,mpc5200b-<device>","fsl,mpc5200-<device>" form.
+
+Required soc5200 child nodes:
+name				compatible		Description
+----				----------		-----------
+cdm@<addr>			fsl,mpc5200-cdm		Clock Distribution
+interrupt-controller@<addr>	fsl,mpc5200-pic		need an interrupt
+							controller to boot
+bestcomm@<addr>			fsl,mpc5200-bestcomm	Bestcomm DMA controller
+
+Recommended soc5200 child nodes; populate as needed for your board
+name		compatible		Description
+----		----------		-----------
+timer@<addr>	fsl,mpc5200-gpt		 General purpose timers
+gpio@<addr>	fsl,mpc5200-gpio	 MPC5200 simple gpio controller
+gpio@<addr>	fsl,mpc5200-gpio-wkup	 MPC5200 wakeup gpio controller
+rtc@<addr>	fsl,mpc5200-rtc		 Real time clock
+mscan@<addr>	fsl,mpc5200-mscan	 CAN bus controller
+pci@<addr>	fsl,mpc5200-pci		 PCI bridge
+serial@<addr>	fsl,mpc5200-psc-uart	 PSC in serial mode
+i2s@<addr>	fsl,mpc5200-psc-i2s	 PSC in i2s mode
+ac97@<addr>	fsl,mpc5200-psc-ac97	 PSC in ac97 mode
+spi@<addr>	fsl,mpc5200-psc-spi	 PSC in spi mode
+irda@<addr>	fsl,mpc5200-psc-irda	 PSC in IrDA mode
+spi@<addr>	fsl,mpc5200-spi		 MPC5200 spi device
+ethernet@<addr>	fsl,mpc5200-fec		 MPC5200 ethernet device
+ata@<addr>	fsl,mpc5200-ata		 IDE ATA interface
+i2c@<addr>	fsl,mpc5200-i2c		 I2C controller
+usb@<addr>	fsl,mpc5200-ohci,ohci-be USB controller
+xlb@<addr>	fsl,mpc5200-xlb		 XLB arbitrator
+
+fsl,mpc5200-gpt nodes
+---------------------
+On the mpc5200 and 5200b, GPT0 has a watchdog timer function.  If the board
+design supports the internal wdt, then the device node for GPT0 should
+include the empty property 'fsl,has-wdt'.  Note that this does not activate
+the watchdog.  The timer will function as a GPT if the timer api is used, and
+it will function as watchdog if the watchdog device is used.  The watchdog
+mode has priority over the gpt mode, i.e. if the watchdog is activated, any
+gpt api call to this timer will fail with -EBUSY.
+
+If you add the property
+	fsl,wdt-on-boot = <n>;
+GPT0 will be marked as in-use watchdog, i.e. blocking every gpt access to it.
+If n>0, the watchdog is started with a timeout of n seconds.  If n=0, the
+configuration of the watchdog is not touched.  This is useful in two cases:
+- just mark GPT0 as watchdog, blocking gpt accesses, and configure it later;
+- do not touch a configuration assigned by the boot loader which supervises
+  the boot process itself.
+
+The watchdog will respect the CONFIG_WATCHDOG_NOWAYOUT option.
+
+An mpc5200-gpt can be used as a single line GPIO controller.  To do so,
+add the following properties to the gpt node:
+	gpio-controller;
+	#gpio-cells = <2>;
+When referencing the GPIO line from another node, the first cell must always
+be zero and the second cell represents the gpio flags and described in the
+gpio device tree binding.
+
+An mpc5200-gpt can be used as a single line edge sensitive interrupt
+controller.  To do so, add the following properties to the gpt node:
+	interrupt-controller;
+	#interrupt-cells = <1>;
+When referencing the IRQ line from another node, the cell represents the
+sense mode; 1 for edge rising, 2 for edge falling.
+
+fsl,mpc5200-psc nodes
+---------------------
+The PSCs should include a cell-index which is the index of the PSC in
+hardware.  cell-index is used to determine which shared SoC registers to
+use when setting up PSC clocking.  cell-index number starts at '0'.  ie:
+	PSC1 has 'cell-index = <0>'
+	PSC4 has 'cell-index = <3>'
+
+PSC in i2s mode:  The mpc5200 and mpc5200b PSCs are not compatible when in
+i2s mode.  An 'mpc5200b-psc-i2s' node cannot include 'mpc5200-psc-i2s' in the
+compatible field.
+
+
+fsl,mpc5200-gpio and fsl,mpc5200-gpio-wkup nodes
+------------------------------------------------
+Each GPIO controller node should have the empty property gpio-controller and
+#gpio-cells set to 2. First cell is the GPIO number which is interpreted
+according to the bit numbers in the GPIO control registers. The second cell
+is for flags which is currently unused.
+
+fsl,mpc5200-fec nodes
+---------------------
+The FEC node can specify one of the following properties to configure
+the MII link:
+- fsl,7-wire-mode - An empty property that specifies the link uses 7-wire
+                    mode instead of MII
+- current-speed   - Specifies that the MII should be configured for a fixed
+                    speed.  This property should contain two cells.  The
+                    first cell specifies the speed in Mbps and the second
+                    should be '0' for half duplex and '1' for full duplex
+- phy-handle      - Contains a phandle to an Ethernet PHY.
+
+Interrupt controller (fsl,mpc5200-pic) node
+-------------------------------------------
+The mpc5200 pic binding splits hardware IRQ numbers into two levels.  The
+split reflects the layout of the PIC hardware itself, which groups
+interrupts into one of three groups; CRIT, MAIN or PERP.  Also, the
+Bestcomm dma engine has it's own set of interrupt sources which are
+cascaded off of peripheral interrupt 0, which the driver interprets as a
+fourth group, SDMA.
+
+The interrupts property for device nodes using the mpc5200 pic consists
+of three cells; <L1 L2 level>
+
+    L1 := [CRIT=0, MAIN=1, PERP=2, SDMA=3]
+    L2 := interrupt number; directly mapped from the value in the
+          "ICTL PerStat, MainStat, CritStat Encoded Register"
+    level := [LEVEL_HIGH=0, EDGE_RISING=1, EDGE_FALLING=2, LEVEL_LOW=3]
+
+For external IRQs, use the following interrupt property values (how to
+specify external interrupts is a frequently asked question):
+External interrupts:
+	external irq0:	interrupts = <0 0 n>;
+	external irq1:	interrupts = <1 1 n>;
+	external irq2:	interrupts = <1 2 n>;
+	external irq3:	interrupts = <1 3 n>;
+'n' is sense (0: level high, 1: edge rising, 2: edge falling 3: level low)
+
+fsl,mpc5200-mscan nodes
+-----------------------
+See file can.txt in this directory.
diff --git a/Documentation/devicetree/bindings/powerpc/fsl/mpic.txt b/Documentation/devicetree/bindings/powerpc/fsl/mpic.txt
new file mode 100644
index 0000000..71e39cf
--- /dev/null
+++ b/Documentation/devicetree/bindings/powerpc/fsl/mpic.txt
@@ -0,0 +1,42 @@
+* OpenPIC and its interrupt numbers on Freescale's e500/e600 cores
+
+The OpenPIC specification does not specify which interrupt source has to
+become which interrupt number. This is up to the software implementation
+of the interrupt controller. The only requirement is that every
+interrupt source has to have an unique interrupt number / vector number.
+To accomplish this the current implementation assigns the number zero to
+the first source, the number one to the second source and so on until
+all interrupt sources have their unique number.
+Usually the assigned vector number equals the interrupt number mentioned
+in the documentation for a given core / CPU. This is however not true
+for the e500 cores (MPC85XX CPUs) where the documentation distinguishes
+between internal and external interrupt sources and starts counting at
+zero for both of them.
+
+So what to write for external interrupt source X or internal interrupt
+source Y into the device tree? Here is an example:
+
+The memory map for the interrupt controller in the MPC8544[0] shows,
+that the first interrupt source starts at 0x5_0000 (PIC Register Address
+Map-Interrupt Source Configuration Registers). This source becomes the
+number zero therefore:
+ External interrupt 0 = interrupt number 0
+ External interrupt 1 = interrupt number 1
+ External interrupt 2 = interrupt number 2
+ ...
+Every interrupt number allocates 0x20 bytes register space. So to get
+its number it is sufficient to shift the lower 16bits to right by five.
+So for the external interrupt 10 we have:
+  0x0140 >> 5 = 10
+
+After the external sources, the internal sources follow. The in core I2C
+controller on the MPC8544 for instance has the internal source number
+27. Oo obtain its interrupt number we take the lower 16bits of its memory
+address (0x5_0560) and shift it right:
+ 0x0560 >> 5 = 43
+
+Therefore the I2C device node for the MPC8544 CPU has to have the
+interrupt number 43 specified in the device tree.
+
+[0] MPC8544E PowerQUICCTM III, Integrated Host Processor Family Reference Manual
+    MPC8544ERM Rev. 1 10/2007
diff --git a/Documentation/devicetree/bindings/powerpc/fsl/msi-pic.txt b/Documentation/devicetree/bindings/powerpc/fsl/msi-pic.txt
new file mode 100644
index 0000000..bcc30ba
--- /dev/null
+++ b/Documentation/devicetree/bindings/powerpc/fsl/msi-pic.txt
@@ -0,0 +1,36 @@
+* Freescale MSI interrupt controller
+
+Required properties:
+- compatible : compatible list, contains 2 entries,
+  first is "fsl,CHIP-msi", where CHIP is the processor(mpc8610, mpc8572,
+  etc.) and the second is "fsl,mpic-msi" or "fsl,ipic-msi" depending on
+  the parent type.
+- reg : should contain the address and the length of the shared message
+  interrupt register set.
+- msi-available-ranges: use <start count> style section to define which
+  msi interrupt can be used in the 256 msi interrupts. This property is
+  optional, without this, all the 256 MSI interrupts can be used.
+- interrupts : each one of the interrupts here is one entry per 32 MSIs,
+  and routed to the host interrupt controller. the interrupts should
+  be set as edge sensitive.
+- interrupt-parent: the phandle for the interrupt controller
+  that services interrupts for this device. for 83xx cpu, the interrupts
+  are routed to IPIC, and for 85xx/86xx cpu the interrupts are routed
+  to MPIC.
+
+Example:
+	msi@41600 {
+		compatible = "fsl,mpc8610-msi", "fsl,mpic-msi";
+		reg = <0x41600 0x80>;
+		msi-available-ranges = <0 0x100>;
+		interrupts = <
+			0xe0 0
+			0xe1 0
+			0xe2 0
+			0xe3 0
+			0xe4 0
+			0xe5 0
+			0xe6 0
+			0xe7 0>;
+		interrupt-parent = <&mpic>;
+	};
diff --git a/Documentation/devicetree/bindings/powerpc/fsl/pmc.txt b/Documentation/devicetree/bindings/powerpc/fsl/pmc.txt
new file mode 100644
index 0000000..07256b7
--- /dev/null
+++ b/Documentation/devicetree/bindings/powerpc/fsl/pmc.txt
@@ -0,0 +1,63 @@
+* Power Management Controller
+
+Properties:
+- compatible: "fsl,<chip>-pmc".
+
+  "fsl,mpc8349-pmc" should be listed for any chip whose PMC is
+  compatible.  "fsl,mpc8313-pmc" should also be listed for any chip
+  whose PMC is compatible, and implies deep-sleep capability.
+
+  "fsl,mpc8548-pmc" should be listed for any chip whose PMC is
+  compatible.  "fsl,mpc8536-pmc" should also be listed for any chip
+  whose PMC is compatible, and implies deep-sleep capability.
+
+  "fsl,mpc8641d-pmc" should be listed for any chip whose PMC is
+  compatible; all statements below that apply to "fsl,mpc8548-pmc" also
+  apply to "fsl,mpc8641d-pmc".
+
+  Compatibility does not include bit assignments in SCCR/PMCDR/DEVDISR; these
+  bit assignments are indicated via the sleep specifier in each device's
+  sleep property.
+
+- reg: For devices compatible with "fsl,mpc8349-pmc", the first resource
+  is the PMC block, and the second resource is the Clock Configuration
+  block.
+
+  For devices compatible with "fsl,mpc8548-pmc", the first resource
+  is a 32-byte block beginning with DEVDISR.
+
+- interrupts: For "fsl,mpc8349-pmc"-compatible devices, the first
+  resource is the PMC block interrupt.
+
+- fsl,mpc8313-wakeup-timer: For "fsl,mpc8313-pmc"-compatible devices,
+  this is a phandle to an "fsl,gtm" node on which timer 4 can be used as
+  a wakeup source from deep sleep.
+
+Sleep specifiers:
+
+  fsl,mpc8349-pmc: Sleep specifiers consist of one cell.  For each bit
+  that is set in the cell, the corresponding bit in SCCR will be saved
+  and cleared on suspend, and restored on resume.  This sleep controller
+  supports disabling and resuming devices at any time.
+
+  fsl,mpc8536-pmc: Sleep specifiers consist of three cells, the third of
+  which will be ORed into PMCDR upon suspend, and cleared from PMCDR
+  upon resume.  The first two cells are as described for fsl,mpc8578-pmc.
+  This sleep controller only supports disabling devices during system
+  sleep, or permanently.
+
+  fsl,mpc8548-pmc: Sleep specifiers consist of one or two cells, the
+  first of which will be ORed into DEVDISR (and the second into
+  DEVDISR2, if present -- this cell should be zero or absent if the
+  hardware does not have DEVDISR2) upon a request for permanent device
+  disabling.  This sleep controller does not support configuring devices
+  to disable during system sleep (unless supported by another compatible
+  match), or dynamically.
+
+Example:
+
+	power@b00 {
+		compatible = "fsl,mpc8313-pmc", "fsl,mpc8349-pmc";
+		reg = <0xb00 0x100 0xa00 0x100>;
+		interrupts = <80 8>;
+	};
diff --git a/Documentation/devicetree/bindings/powerpc/fsl/sec.txt b/Documentation/devicetree/bindings/powerpc/fsl/sec.txt
new file mode 100644
index 0000000..2b6f2d4
--- /dev/null
+++ b/Documentation/devicetree/bindings/powerpc/fsl/sec.txt
@@ -0,0 +1,68 @@
+Freescale SoC SEC Security Engines
+
+Required properties:
+
+- compatible : Should contain entries for this and backward compatible
+  SEC versions, high to low, e.g., "fsl,sec2.1", "fsl,sec2.0"
+- reg : Offset and length of the register set for the device
+- interrupts : the SEC's interrupt number
+- fsl,num-channels : An integer representing the number of channels
+  available.
+- fsl,channel-fifo-len : An integer representing the number of
+  descriptor pointers each channel fetch fifo can hold.
+- fsl,exec-units-mask : The bitmask representing what execution units
+  (EUs) are available. It's a single 32-bit cell. EU information
+  should be encoded following the SEC's Descriptor Header Dword
+  EU_SEL0 field documentation, i.e. as follows:
+
+	bit 0  = reserved - should be 0
+	bit 1  = set if SEC has the ARC4 EU (AFEU)
+	bit 2  = set if SEC has the DES/3DES EU (DEU)
+	bit 3  = set if SEC has the message digest EU (MDEU/MDEU-A)
+	bit 4  = set if SEC has the random number generator EU (RNG)
+	bit 5  = set if SEC has the public key EU (PKEU)
+	bit 6  = set if SEC has the AES EU (AESU)
+	bit 7  = set if SEC has the Kasumi EU (KEU)
+	bit 8  = set if SEC has the CRC EU (CRCU)
+	bit 11 = set if SEC has the message digest EU extended alg set (MDEU-B)
+
+remaining bits are reserved for future SEC EUs.
+
+- fsl,descriptor-types-mask : The bitmask representing what descriptors
+  are available. It's a single 32-bit cell. Descriptor type information
+  should be encoded following the SEC's Descriptor Header Dword DESC_TYPE
+  field documentation, i.e. as follows:
+
+	bit 0  = set if SEC supports the aesu_ctr_nonsnoop desc. type
+	bit 1  = set if SEC supports the ipsec_esp descriptor type
+	bit 2  = set if SEC supports the common_nonsnoop desc. type
+	bit 3  = set if SEC supports the 802.11i AES ccmp desc. type
+	bit 4  = set if SEC supports the hmac_snoop_no_afeu desc. type
+	bit 5  = set if SEC supports the srtp descriptor type
+	bit 6  = set if SEC supports the non_hmac_snoop_no_afeu desc.type
+	bit 7  = set if SEC supports the pkeu_assemble descriptor type
+	bit 8  = set if SEC supports the aesu_key_expand_output desc.type
+	bit 9  = set if SEC supports the pkeu_ptmul descriptor type
+	bit 10 = set if SEC supports the common_nonsnoop_afeu desc. type
+	bit 11 = set if SEC supports the pkeu_ptadd_dbl descriptor type
+
+  ..and so on and so forth.
+
+Optional properties:
+
+- interrupt-parent : the phandle for the interrupt controller that
+  services interrupts for this device.
+
+Example:
+
+	/* MPC8548E */
+	crypto@30000 {
+		compatible = "fsl,sec2.1", "fsl,sec2.0";
+		reg = <0x30000 0x10000>;
+		interrupts = <29 2>;
+		interrupt-parent = <&mpic>;
+		fsl,num-channels = <4>;
+		fsl,channel-fifo-len = <24>;
+		fsl,exec-units-mask = <0xfe>;
+		fsl,descriptor-types-mask = <0x12b0ebf>;
+	};
diff --git a/Documentation/devicetree/bindings/powerpc/fsl/ssi.txt b/Documentation/devicetree/bindings/powerpc/fsl/ssi.txt
new file mode 100644
index 0000000..5ff76c9
--- /dev/null
+++ b/Documentation/devicetree/bindings/powerpc/fsl/ssi.txt
@@ -0,0 +1,73 @@
+Freescale Synchronous Serial Interface
+
+The SSI is a serial device that communicates with audio codecs.  It can
+be programmed in AC97, I2S, left-justified, or right-justified modes.
+
+Required properties:
+- compatible:       Compatible list, contains "fsl,ssi".
+- cell-index:       The SSI, <0> = SSI1, <1> = SSI2, and so on.
+- reg:              Offset and length of the register set for the device.
+- interrupts:       <a b> where a is the interrupt number and b is a
+                    field that represents an encoding of the sense and
+                    level information for the interrupt.  This should be
+                    encoded based on the information in section 2)
+                    depending on the type of interrupt controller you
+                    have.
+- interrupt-parent: The phandle for the interrupt controller that
+                    services interrupts for this device.
+- fsl,mode:         The operating mode for the SSI interface.
+                    "i2s-slave" - I2S mode, SSI is clock slave
+                    "i2s-master" - I2S mode, SSI is clock master
+                    "lj-slave" - left-justified mode, SSI is clock slave
+                    "lj-master" - l.j. mode, SSI is clock master
+                    "rj-slave" - right-justified mode, SSI is clock slave
+                    "rj-master" - r.j., SSI is clock master
+                    "ac97-slave" - AC97 mode, SSI is clock slave
+                    "ac97-master" - AC97 mode, SSI is clock master
+- fsl,playback-dma: Phandle to a node for the DMA channel to use for
+                    playback of audio.  This is typically dictated by SOC
+                    design.  See the notes below.
+- fsl,capture-dma:  Phandle to a node for the DMA channel to use for
+                    capture (recording) of audio.  This is typically dictated
+                    by SOC design.  See the notes below.
+- fsl,fifo-depth:   The number of elements in the transmit and receive FIFOs.
+                    This number is the maximum allowed value for SFCSR[TFWM0].
+- fsl,ssi-asynchronous:
+                    If specified, the SSI is to be programmed in asynchronous
+                    mode.  In this mode, pins SRCK, STCK, SRFS, and STFS must
+                    all be connected to valid signals.  In synchronous mode,
+                    SRCK and SRFS are ignored.  Asynchronous mode allows
+                    playback and capture to use different sample sizes and
+                    sample rates.  Some drivers may require that SRCK and STCK
+                    be connected together, and SRFS and STFS be connected
+                    together.  This would still allow different sample sizes,
+                    but not different sample rates.
+
+Optional properties:
+- codec-handle:     Phandle to a 'codec' node that defines an audio
+                    codec connected to this SSI.  This node is typically
+                    a child of an I2C or other control node.
+
+Child 'codec' node required properties:
+- compatible:       Compatible list, contains the name of the codec
+
+Child 'codec' node optional properties:
+- clock-frequency:  The frequency of the input clock, which typically comes
+                    from an on-board dedicated oscillator.
+
+Notes on fsl,playback-dma and fsl,capture-dma:
+
+On SOCs that have an SSI, specific DMA channels are hard-wired for playback
+and capture.  On the MPC8610, for example, SSI1 must use DMA channel 0 for
+playback and DMA channel 1 for capture.  SSI2 must use DMA channel 2 for
+playback and DMA channel 3 for capture.  The developer can choose which
+DMA controller to use, but the channels themselves are hard-wired.  The
+purpose of these two properties is to represent this hardware design.
+
+The device tree nodes for the DMA channels that are referenced by
+"fsl,playback-dma" and "fsl,capture-dma" must be marked as compatible with
+"fsl,ssi-dma-channel".  The SOC-specific compatible string (e.g.
+"fsl,mpc8610-dma-channel") can remain.  If these nodes are left as
+"fsl,elo-dma-channel" or "fsl,eloplus-dma-channel", then the generic Elo DMA
+drivers (fsldma) will attempt to use them, and it will conflict with the
+sound drivers.
diff --git a/Documentation/devicetree/bindings/powerpc/nintendo/gamecube.txt b/Documentation/devicetree/bindings/powerpc/nintendo/gamecube.txt
new file mode 100644
index 0000000..b558585
--- /dev/null
+++ b/Documentation/devicetree/bindings/powerpc/nintendo/gamecube.txt
@@ -0,0 +1,109 @@
+
+Nintendo GameCube device tree
+=============================
+
+1) The "flipper" node
+
+  This node represents the multi-function "Flipper" chip, which packages
+  many of the devices found in the Nintendo GameCube.
+
+  Required properties:
+
+   - compatible : Should be "nintendo,flipper"
+
+1.a) The Video Interface (VI) node
+
+  Represents the interface between the graphics processor and a external
+  video encoder.
+
+  Required properties:
+
+   - compatible : should be "nintendo,flipper-vi"
+   - reg : should contain the VI registers location and length
+   - interrupts : should contain the VI interrupt
+
+1.b) The Processor Interface (PI) node
+
+  Represents the data and control interface between the main processor
+  and graphics and audio processor.
+
+  Required properties:
+
+  - compatible : should be "nintendo,flipper-pi"
+  - reg : should contain the PI registers location and length
+
+1.b.i) The "Flipper" interrupt controller node
+
+  Represents the interrupt controller within the "Flipper" chip.
+  The node for the "Flipper" interrupt controller must be placed under
+  the PI node.
+
+  Required properties:
+
+  - compatible : should be "nintendo,flipper-pic"
+
+1.c) The Digital Signal Procesor (DSP) node
+
+  Represents the digital signal processor interface, designed to offload
+  audio related tasks.
+
+  Required properties:
+
+   - compatible : should be "nintendo,flipper-dsp"
+   - reg : should contain the DSP registers location and length
+   - interrupts : should contain the DSP interrupt
+
+1.c.i) The Auxiliary RAM (ARAM) node
+
+  Represents the non cpu-addressable ram designed mainly to store audio
+  related information.
+  The ARAM node must be placed under the DSP node.
+
+  Required properties:
+
+   - compatible : should be "nintendo,flipper-aram"
+   - reg : should contain the ARAM start (zero-based) and length
+
+1.d) The Disk Interface (DI) node
+
+  Represents the interface used to communicate with mass storage devices.
+
+  Required properties:
+
+   - compatible : should be "nintendo,flipper-di"
+   - reg : should contain the DI registers location and length
+   - interrupts : should contain the DI interrupt
+
+1.e) The Audio Interface (AI) node
+
+  Represents the interface to the external 16-bit stereo digital-to-analog
+  converter.
+
+  Required properties:
+
+   - compatible : should be "nintendo,flipper-ai"
+   - reg : should contain the AI registers location and length
+   - interrupts : should contain the AI interrupt
+
+1.f) The Serial Interface (SI) node
+
+  Represents the interface to the four single bit serial interfaces.
+  The SI is a proprietary serial interface used normally to control gamepads.
+  It's NOT a RS232-type interface.
+
+  Required properties:
+
+   - compatible : should be "nintendo,flipper-si"
+   - reg : should contain the SI registers location and length
+   - interrupts : should contain the SI interrupt
+
+1.g) The External Interface (EXI) node
+
+  Represents the multi-channel SPI-like interface.
+
+  Required properties:
+
+   - compatible : should be "nintendo,flipper-exi"
+   - reg : should contain the EXI registers location and length
+   - interrupts : should contain the EXI interrupt
+
diff --git a/Documentation/devicetree/bindings/powerpc/nintendo/wii.txt b/Documentation/devicetree/bindings/powerpc/nintendo/wii.txt
new file mode 100644
index 0000000..a7e155a
--- /dev/null
+++ b/Documentation/devicetree/bindings/powerpc/nintendo/wii.txt
@@ -0,0 +1,184 @@
+
+Nintendo Wii device tree
+========================
+
+0) The root node
+
+  This node represents the Nintendo Wii video game console.
+
+  Required properties:
+
+   - model : Should be "nintendo,wii"
+   - compatible : Should be "nintendo,wii"
+
+1) The "hollywood" node
+
+  This node represents the multi-function "Hollywood" chip, which packages
+  many of the devices found in the Nintendo Wii.
+
+  Required properties:
+
+   - compatible : Should be "nintendo,hollywood"
+
+1.a) The Video Interface (VI) node
+
+  Represents the interface between the graphics processor and a external
+  video encoder.
+
+  Required properties:
+
+   - compatible : should be "nintendo,hollywood-vi","nintendo,flipper-vi"
+   - reg : should contain the VI registers location and length
+   - interrupts : should contain the VI interrupt
+
+1.b) The Processor Interface (PI) node
+
+  Represents the data and control interface between the main processor
+  and graphics and audio processor.
+
+  Required properties:
+
+  - compatible : should be "nintendo,hollywood-pi","nintendo,flipper-pi"
+  - reg : should contain the PI registers location and length
+
+1.b.i) The "Flipper" interrupt controller node
+
+  Represents the "Flipper" interrupt controller within the "Hollywood" chip.
+  The node for the "Flipper" interrupt controller must be placed under
+  the PI node.
+
+  Required properties:
+
+  - #interrupt-cells : <1>
+  - compatible : should be "nintendo,flipper-pic"
+  - interrupt-controller
+
+1.c) The Digital Signal Procesor (DSP) node
+
+  Represents the digital signal processor interface, designed to offload
+  audio related tasks.
+
+  Required properties:
+
+   - compatible : should be "nintendo,hollywood-dsp","nintendo,flipper-dsp"
+   - reg : should contain the DSP registers location and length
+   - interrupts : should contain the DSP interrupt
+
+1.d) The Serial Interface (SI) node
+
+  Represents the interface to the four single bit serial interfaces.
+  The SI is a proprietary serial interface used normally to control gamepads.
+  It's NOT a RS232-type interface.
+
+  Required properties:
+
+   - compatible : should be "nintendo,hollywood-si","nintendo,flipper-si"
+   - reg : should contain the SI registers location and length
+   - interrupts : should contain the SI interrupt
+
+1.e) The Audio Interface (AI) node
+
+  Represents the interface to the external 16-bit stereo digital-to-analog
+  converter.
+
+  Required properties:
+
+   - compatible : should be "nintendo,hollywood-ai","nintendo,flipper-ai"
+   - reg : should contain the AI registers location and length
+   - interrupts : should contain the AI interrupt
+
+1.f) The External Interface (EXI) node
+
+  Represents the multi-channel SPI-like interface.
+
+  Required properties:
+
+   - compatible : should be "nintendo,hollywood-exi","nintendo,flipper-exi"
+   - reg : should contain the EXI registers location and length
+   - interrupts : should contain the EXI interrupt
+
+1.g) The Open Host Controller Interface (OHCI) nodes
+
+  Represent the USB 1.x Open Host Controller Interfaces.
+
+  Required properties:
+
+   - compatible : should be "nintendo,hollywood-usb-ohci","usb-ohci"
+   - reg : should contain the OHCI registers location and length
+   - interrupts : should contain the OHCI interrupt
+
+1.h) The Enhanced Host Controller Interface (EHCI) node
+
+  Represents the USB 2.0 Enhanced Host Controller Interface.
+
+  Required properties:
+
+   - compatible : should be "nintendo,hollywood-usb-ehci","usb-ehci"
+   - reg : should contain the EHCI registers location and length
+   - interrupts : should contain the EHCI interrupt
+
+1.i) The Secure Digital Host Controller Interface (SDHCI) nodes
+
+  Represent the Secure Digital Host Controller Interfaces.
+
+  Required properties:
+
+   - compatible : should be "nintendo,hollywood-sdhci","sdhci"
+   - reg : should contain the SDHCI registers location and length
+   - interrupts : should contain the SDHCI interrupt
+
+1.j) The Inter-Processsor Communication (IPC) node
+
+  Represent the Inter-Processor Communication interface. This interface
+  enables communications between the Broadway and the Starlet processors.
+
+   - compatible : should be "nintendo,hollywood-ipc"
+   - reg : should contain the IPC registers location and length
+   - interrupts : should contain the IPC interrupt
+
+1.k) The "Hollywood" interrupt controller node
+
+  Represents the "Hollywood" interrupt controller within the
+  "Hollywood" chip.
+
+  Required properties:
+
+  - #interrupt-cells : <1>
+  - compatible : should be "nintendo,hollywood-pic"
+  - reg : should contain the controller registers location and length
+  - interrupt-controller
+  - interrupts : should contain the cascade interrupt of the "flipper" pic
+  - interrupt-parent: should contain the phandle of the "flipper" pic
+
+1.l) The General Purpose I/O (GPIO) controller node
+
+  Represents the dual access 32 GPIO controller interface.
+
+  Required properties:
+
+  - #gpio-cells : <2>
+  - compatible : should be "nintendo,hollywood-gpio"
+  - reg : should contain the IPC registers location and length
+  - gpio-controller
+
+1.m) The control node
+
+  Represents the control interface used to setup several miscellaneous
+  settings of the "Hollywood" chip like boot memory mappings, resets,
+  disk interface mode, etc.
+
+  Required properties:
+
+   - compatible : should be "nintendo,hollywood-control"
+   - reg : should contain the control registers location and length
+
+1.n) The Disk Interface (DI) node
+
+  Represents the interface used to communicate with mass storage devices.
+
+  Required properties:
+
+   - compatible : should be "nintendo,hollywood-di"
+   - reg : should contain the DI registers location and length
+   - interrupts : should contain the DI interrupt
+
diff --git a/Documentation/devicetree/bindings/spi/fsl-spi.txt b/Documentation/devicetree/bindings/spi/fsl-spi.txt
new file mode 100644
index 0000000..777abd7
--- /dev/null
+++ b/Documentation/devicetree/bindings/spi/fsl-spi.txt
@@ -0,0 +1,53 @@
+* SPI (Serial Peripheral Interface)
+
+Required properties:
+- cell-index : QE SPI subblock index.
+		0: QE subblock SPI1
+		1: QE subblock SPI2
+- compatible : should be "fsl,spi".
+- mode : the SPI operation mode, it can be "cpu" or "cpu-qe".
+- reg : Offset and length of the register set for the device
+- interrupts : <a b> where a is the interrupt number and b is a
+  field that represents an encoding of the sense and level
+  information for the interrupt.  This should be encoded based on
+  the information in section 2) depending on the type of interrupt
+  controller you have.
+- interrupt-parent : the phandle for the interrupt controller that
+  services interrupts for this device.
+
+Optional properties:
+- gpios : specifies the gpio pins to be used for chipselects.
+  The gpios will be referred to as reg = <index> in the SPI child nodes.
+  If unspecified, a single SPI device without a chip select can be used.
+
+Example:
+	spi@4c0 {
+		cell-index = <0>;
+		compatible = "fsl,spi";
+		reg = <4c0 40>;
+		interrupts = <82 0>;
+		interrupt-parent = <700>;
+		mode = "cpu";
+		gpios = <&gpio 18 1	// device reg=<0>
+			 &gpio 19 1>;	// device reg=<1>
+	};
+
+
+* eSPI (Enhanced Serial Peripheral Interface)
+
+Required properties:
+- compatible : should be "fsl,mpc8536-espi".
+- reg : Offset and length of the register set for the device.
+- interrupts : should contain eSPI interrupt, the device has one interrupt.
+- fsl,espi-num-chipselects : the number of the chipselect signals.
+
+Example:
+	spi@110000 {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		compatible = "fsl,mpc8536-espi";
+		reg = <0x110000 0x1000>;
+		interrupts = <53 0x2>;
+		interrupt-parent = <&mpic>;
+		fsl,espi-num-chipselects = <4>;
+	};
diff --git a/Documentation/devicetree/bindings/spi/spi-bus.txt b/Documentation/devicetree/bindings/spi/spi-bus.txt
new file mode 100644
index 0000000..e782add
--- /dev/null
+++ b/Documentation/devicetree/bindings/spi/spi-bus.txt
@@ -0,0 +1,57 @@
+SPI (Serial Peripheral Interface) busses
+
+SPI busses can be described with a node for the SPI master device
+and a set of child nodes for each SPI slave on the bus.  For this
+discussion, it is assumed that the system's SPI controller is in
+SPI master mode.  This binding does not describe SPI controllers
+in slave mode.
+
+The SPI master node requires the following properties:
+- #address-cells  - number of cells required to define a chip select
+    		address on the SPI bus.
+- #size-cells     - should be zero.
+- compatible      - name of SPI bus controller following generic names
+    		recommended practice.
+No other properties are required in the SPI bus node.  It is assumed
+that a driver for an SPI bus device will understand that it is an SPI bus.
+However, the binding does not attempt to define the specific method for
+assigning chip select numbers.  Since SPI chip select configuration is
+flexible and non-standardized, it is left out of this binding with the
+assumption that board specific platform code will be used to manage
+chip selects.  Individual drivers can define additional properties to
+support describing the chip select layout.
+
+SPI slave nodes must be children of the SPI master node and can
+contain the following properties.
+- reg             - (required) chip select address of device.
+- compatible      - (required) name of SPI device following generic names
+    		recommended practice
+- spi-max-frequency - (required) Maximum SPI clocking speed of device in Hz
+- spi-cpol        - (optional) Empty property indicating device requires
+    		inverse clock polarity (CPOL) mode
+- spi-cpha        - (optional) Empty property indicating device requires
+    		shifted clock phase (CPHA) mode
+- spi-cs-high     - (optional) Empty property indicating device requires
+    		chip select active high
+
+SPI example for an MPC5200 SPI bus:
+	spi@f00 {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		compatible = "fsl,mpc5200b-spi","fsl,mpc5200-spi";
+		reg = <0xf00 0x20>;
+		interrupts = <2 13 0 2 14 0>;
+		interrupt-parent = <&mpc5200_pic>;
+
+		ethernet-switch@0 {
+			compatible = "micrel,ks8995m";
+			spi-max-frequency = <1000000>;
+			reg = <0>;
+		};
+
+		codec@1 {
+			compatible = "ti,tlv320aic26";
+			spi-max-frequency = <100000>;
+			reg = <1>;
+		};
+	};
diff --git a/Documentation/devicetree/bindings/usb/fsl-usb.txt b/Documentation/devicetree/bindings/usb/fsl-usb.txt
new file mode 100644
index 0000000..bd5723f
--- /dev/null
+++ b/Documentation/devicetree/bindings/usb/fsl-usb.txt
@@ -0,0 +1,81 @@
+Freescale SOC USB controllers
+
+The device node for a USB controller that is part of a Freescale
+SOC is as described in the document "Open Firmware Recommended
+Practice : Universal Serial Bus" with the following modifications
+and additions :
+
+Required properties :
+ - compatible : Should be "fsl-usb2-mph" for multi port host USB
+   controllers, or "fsl-usb2-dr" for dual role USB controllers
+   or "fsl,mpc5121-usb2-dr" for dual role USB controllers of MPC5121
+ - phy_type : For multi port host USB controllers, should be one of
+   "ulpi", or "serial". For dual role USB controllers, should be
+   one of "ulpi", "utmi", "utmi_wide", or "serial".
+ - reg : Offset and length of the register set for the device
+ - port0 : boolean; if defined, indicates port0 is connected for
+   fsl-usb2-mph compatible controllers.  Either this property or
+   "port1" (or both) must be defined for "fsl-usb2-mph" compatible
+   controllers.
+ - port1 : boolean; if defined, indicates port1 is connected for
+   fsl-usb2-mph compatible controllers.  Either this property or
+   "port0" (or both) must be defined for "fsl-usb2-mph" compatible
+   controllers.
+ - dr_mode : indicates the working mode for "fsl-usb2-dr" compatible
+   controllers.  Can be "host", "peripheral", or "otg".  Default to
+   "host" if not defined for backward compatibility.
+
+Recommended properties :
+ - interrupts : <a b> where a is the interrupt number and b is a
+   field that represents an encoding of the sense and level
+   information for the interrupt.  This should be encoded based on
+   the information in section 2) depending on the type of interrupt
+   controller you have.
+ - interrupt-parent : the phandle for the interrupt controller that
+   services interrupts for this device.
+
+Optional properties :
+ - fsl,invert-drvvbus : boolean; for MPC5121 USB0 only. Indicates the
+   port power polarity of internal PHY signal DRVVBUS is inverted.
+ - fsl,invert-pwr-fault : boolean; for MPC5121 USB0 only. Indicates
+   the PWR_FAULT signal polarity is inverted.
+
+Example multi port host USB controller device node :
+	usb@22000 {
+		compatible = "fsl-usb2-mph";
+		reg = <22000 1000>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		interrupt-parent = <700>;
+		interrupts = <27 1>;
+		phy_type = "ulpi";
+		port0;
+		port1;
+	};
+
+Example dual role USB controller device node :
+	usb@23000 {
+		compatible = "fsl-usb2-dr";
+		reg = <23000 1000>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		interrupt-parent = <700>;
+		interrupts = <26 1>;
+		dr_mode = "otg";
+		phy = "ulpi";
+	};
+
+Example dual role USB controller device node for MPC5121ADS:
+
+	usb@4000 {
+		compatible = "fsl,mpc5121-usb2-dr";
+		reg = <0x4000 0x1000>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		interrupt-parent = < &ipic >;
+		interrupts = <44 0x8>;
+		dr_mode = "otg";
+		phy_type = "utmi_wide";
+		fsl,invert-drvvbus;
+		fsl,invert-pwr-fault;
+	};
diff --git a/Documentation/devicetree/bindings/usb/usb-ehci.txt b/Documentation/devicetree/bindings/usb/usb-ehci.txt
new file mode 100644
index 0000000..fa18612
--- /dev/null
+++ b/Documentation/devicetree/bindings/usb/usb-ehci.txt
@@ -0,0 +1,25 @@
+USB EHCI controllers
+
+Required properties:
+  - compatible : should be "usb-ehci".
+  - reg : should contain at least address and length of the standard EHCI
+    register set for the device. Optional platform-dependent registers
+    (debug-port or other) can be also specified here, but only after
+    definition of standard EHCI registers.
+  - interrupts : one EHCI interrupt should be described here.
+If device registers are implemented in big endian mode, the device
+node should have "big-endian-regs" property.
+If controller implementation operates with big endian descriptors,
+"big-endian-desc" property should be specified.
+If both big endian registers and descriptors are used by the controller
+implementation, "big-endian" property can be specified instead of having
+both "big-endian-regs" and "big-endian-desc".
+
+Example (Sequoia 440EPx):
+    ehci@e0000300 {
+	   compatible = "ibm,usb-ehci-440epx", "usb-ehci";
+	   interrupt-parent = <&UIC0>;
+	   interrupts = <1a 4>;
+	   reg = <0 e0000300 90 0 e0000390 70>;
+	   big-endian;
+   };
diff --git a/Documentation/devicetree/bindings/xilinx.txt b/Documentation/devicetree/bindings/xilinx.txt
new file mode 100644
index 0000000..299d092
--- /dev/null
+++ b/Documentation/devicetree/bindings/xilinx.txt
@@ -0,0 +1,306 @@
+   d) Xilinx IP cores
+
+   The Xilinx EDK toolchain ships with a set of IP cores (devices) for use
+   in Xilinx Spartan and Virtex FPGAs.  The devices cover the whole range
+   of standard device types (network, serial, etc.) and miscellaneous
+   devices (gpio, LCD, spi, etc).  Also, since these devices are
+   implemented within the fpga fabric every instance of the device can be
+   synthesised with different options that change the behaviour.
+
+   Each IP-core has a set of parameters which the FPGA designer can use to
+   control how the core is synthesized.  Historically, the EDK tool would
+   extract the device parameters relevant to device drivers and copy them
+   into an 'xparameters.h' in the form of #define symbols.  This tells the
+   device drivers how the IP cores are configured, but it requires the kernel
+   to be recompiled every time the FPGA bitstream is resynthesized.
+
+   The new approach is to export the parameters into the device tree and
+   generate a new device tree each time the FPGA bitstream changes.  The
+   parameters which used to be exported as #defines will now become
+   properties of the device node.  In general, device nodes for IP-cores
+   will take the following form:
+
+	(name): (generic-name)@(base-address) {
+		compatible = "xlnx,(ip-core-name)-(HW_VER)"
+			     [, (list of compatible devices), ...];
+		reg = <(baseaddr) (size)>;
+		interrupt-parent = <&interrupt-controller-phandle>;
+		interrupts = < ... >;
+		xlnx,(parameter1) = "(string-value)";
+		xlnx,(parameter2) = <(int-value)>;
+	};
+
+	(generic-name):   an open firmware-style name that describes the
+			generic class of device.  Preferably, this is one word, such
+			as 'serial' or 'ethernet'.
+	(ip-core-name):	the name of the ip block (given after the BEGIN
+			directive in system.mhs).  Should be in lowercase
+			and all underscores '_' converted to dashes '-'.
+	(name):		is derived from the "PARAMETER INSTANCE" value.
+	(parameter#):	C_* parameters from system.mhs.  The C_ prefix is
+			dropped from the parameter name, the name is converted
+			to lowercase and all underscore '_' characters are
+			converted to dashes '-'.
+	(baseaddr):	the baseaddr parameter value (often named C_BASEADDR).
+	(HW_VER):	from the HW_VER parameter.
+	(size):		the address range size (often C_HIGHADDR - C_BASEADDR + 1).
+
+   Typically, the compatible list will include the exact IP core version
+   followed by an older IP core version which implements the same
+   interface or any other device with the same interface.
+
+   'reg', 'interrupt-parent' and 'interrupts' are all optional properties.
+
+   For example, the following block from system.mhs:
+
+	BEGIN opb_uartlite
+		PARAMETER INSTANCE = opb_uartlite_0
+		PARAMETER HW_VER = 1.00.b
+		PARAMETER C_BAUDRATE = 115200
+		PARAMETER C_DATA_BITS = 8
+		PARAMETER C_ODD_PARITY = 0
+		PARAMETER C_USE_PARITY = 0
+		PARAMETER C_CLK_FREQ = 50000000
+		PARAMETER C_BASEADDR = 0xEC100000
+		PARAMETER C_HIGHADDR = 0xEC10FFFF
+		BUS_INTERFACE SOPB = opb_7
+		PORT OPB_Clk = CLK_50MHz
+		PORT Interrupt = opb_uartlite_0_Interrupt
+		PORT RX = opb_uartlite_0_RX
+		PORT TX = opb_uartlite_0_TX
+		PORT OPB_Rst = sys_bus_reset_0
+	END
+
+   becomes the following device tree node:
+
+	opb_uartlite_0: serial@ec100000 {
+		device_type = "serial";
+		compatible = "xlnx,opb-uartlite-1.00.b";
+		reg = <ec100000 10000>;
+		interrupt-parent = <&opb_intc_0>;
+		interrupts = <1 0>; // got this from the opb_intc parameters
+		current-speed = <d#115200>;	// standard serial device prop
+		clock-frequency = <d#50000000>;	// standard serial device prop
+		xlnx,data-bits = <8>;
+		xlnx,odd-parity = <0>;
+		xlnx,use-parity = <0>;
+	};
+
+   Some IP cores actually implement 2 or more logical devices.  In
+   this case, the device should still describe the whole IP core with
+   a single node and add a child node for each logical device.  The
+   ranges property can be used to translate from parent IP-core to the
+   registers of each device.  In addition, the parent node should be
+   compatible with the bus type 'xlnx,compound', and should contain
+   #address-cells and #size-cells, as with any other bus.  (Note: this
+   makes the assumption that both logical devices have the same bus
+   binding.  If this is not true, then separate nodes should be used
+   for each logical device).  The 'cell-index' property can be used to
+   enumerate logical devices within an IP core.  For example, the
+   following is the system.mhs entry for the dual ps2 controller found
+   on the ml403 reference design.
+
+	BEGIN opb_ps2_dual_ref
+		PARAMETER INSTANCE = opb_ps2_dual_ref_0
+		PARAMETER HW_VER = 1.00.a
+		PARAMETER C_BASEADDR = 0xA9000000
+		PARAMETER C_HIGHADDR = 0xA9001FFF
+		BUS_INTERFACE SOPB = opb_v20_0
+		PORT Sys_Intr1 = ps2_1_intr
+		PORT Sys_Intr2 = ps2_2_intr
+		PORT Clkin1 = ps2_clk_rx_1
+		PORT Clkin2 = ps2_clk_rx_2
+		PORT Clkpd1 = ps2_clk_tx_1
+		PORT Clkpd2 = ps2_clk_tx_2
+		PORT Rx1 = ps2_d_rx_1
+		PORT Rx2 = ps2_d_rx_2
+		PORT Txpd1 = ps2_d_tx_1
+		PORT Txpd2 = ps2_d_tx_2
+	END
+
+   It would result in the following device tree nodes:
+
+	opb_ps2_dual_ref_0: opb-ps2-dual-ref@a9000000 {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		compatible = "xlnx,compound";
+		ranges = <0 a9000000 2000>;
+		// If this device had extra parameters, then they would
+		// go here.
+		ps2@0 {
+			compatible = "xlnx,opb-ps2-dual-ref-1.00.a";
+			reg = <0 40>;
+			interrupt-parent = <&opb_intc_0>;
+			interrupts = <3 0>;
+			cell-index = <0>;
+		};
+		ps2@1000 {
+			compatible = "xlnx,opb-ps2-dual-ref-1.00.a";
+			reg = <1000 40>;
+			interrupt-parent = <&opb_intc_0>;
+			interrupts = <3 0>;
+			cell-index = <0>;
+		};
+	};
+
+   Also, the system.mhs file defines bus attachments from the processor
+   to the devices.  The device tree structure should reflect the bus
+   attachments.  Again an example; this system.mhs fragment:
+
+	BEGIN ppc405_virtex4
+		PARAMETER INSTANCE = ppc405_0
+		PARAMETER HW_VER = 1.01.a
+		BUS_INTERFACE DPLB = plb_v34_0
+		BUS_INTERFACE IPLB = plb_v34_0
+	END
+
+	BEGIN opb_intc
+		PARAMETER INSTANCE = opb_intc_0
+		PARAMETER HW_VER = 1.00.c
+		PARAMETER C_BASEADDR = 0xD1000FC0
+		PARAMETER C_HIGHADDR = 0xD1000FDF
+		BUS_INTERFACE SOPB = opb_v20_0
+	END
+
+	BEGIN opb_uart16550
+		PARAMETER INSTANCE = opb_uart16550_0
+		PARAMETER HW_VER = 1.00.d
+		PARAMETER C_BASEADDR = 0xa0000000
+		PARAMETER C_HIGHADDR = 0xa0001FFF
+		BUS_INTERFACE SOPB = opb_v20_0
+	END
+
+	BEGIN plb_v34
+		PARAMETER INSTANCE = plb_v34_0
+		PARAMETER HW_VER = 1.02.a
+	END
+
+	BEGIN plb_bram_if_cntlr
+		PARAMETER INSTANCE = plb_bram_if_cntlr_0
+		PARAMETER HW_VER = 1.00.b
+		PARAMETER C_BASEADDR = 0xFFFF0000
+		PARAMETER C_HIGHADDR = 0xFFFFFFFF
+		BUS_INTERFACE SPLB = plb_v34_0
+	END
+
+	BEGIN plb2opb_bridge
+		PARAMETER INSTANCE = plb2opb_bridge_0
+		PARAMETER HW_VER = 1.01.a
+		PARAMETER C_RNG0_BASEADDR = 0x20000000
+		PARAMETER C_RNG0_HIGHADDR = 0x3FFFFFFF
+		PARAMETER C_RNG1_BASEADDR = 0x60000000
+		PARAMETER C_RNG1_HIGHADDR = 0x7FFFFFFF
+		PARAMETER C_RNG2_BASEADDR = 0x80000000
+		PARAMETER C_RNG2_HIGHADDR = 0xBFFFFFFF
+		PARAMETER C_RNG3_BASEADDR = 0xC0000000
+		PARAMETER C_RNG3_HIGHADDR = 0xDFFFFFFF
+		BUS_INTERFACE SPLB = plb_v34_0
+		BUS_INTERFACE MOPB = opb_v20_0
+	END
+
+   Gives this device tree (some properties removed for clarity):
+
+	plb@0 {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		compatible = "xlnx,plb-v34-1.02.a";
+		device_type = "ibm,plb";
+		ranges; // 1:1 translation
+
+		plb_bram_if_cntrl_0: bram@ffff0000 {
+			reg = <ffff0000 10000>;
+		}
+
+		opb@20000000 {
+			#address-cells = <1>;
+			#size-cells = <1>;
+			ranges = <20000000 20000000 20000000
+				  60000000 60000000 20000000
+				  80000000 80000000 40000000
+				  c0000000 c0000000 20000000>;
+
+			opb_uart16550_0: serial@a0000000 {
+				reg = <a00000000 2000>;
+			};
+
+			opb_intc_0: interrupt-controller@d1000fc0 {
+				reg = <d1000fc0 20>;
+			};
+		};
+	};
+
+   That covers the general approach to binding xilinx IP cores into the
+   device tree.  The following are bindings for specific devices:
+
+      i) Xilinx ML300 Framebuffer
+
+      Simple framebuffer device from the ML300 reference design (also on the
+      ML403 reference design as well as others).
+
+      Optional properties:
+       - resolution = <xres yres> : pixel resolution of framebuffer.  Some
+                                    implementations use a different resolution.
+                                    Default is <d#640 d#480>
+       - virt-resolution = <xvirt yvirt> : Size of framebuffer in memory.
+                                           Default is <d#1024 d#480>.
+       - rotate-display (empty) : rotate display 180 degrees.
+
+      ii) Xilinx SystemACE
+
+      The Xilinx SystemACE device is used to program FPGAs from an FPGA
+      bitstream stored on a CF card.  It can also be used as a generic CF
+      interface device.
+
+      Optional properties:
+       - 8-bit (empty) : Set this property for SystemACE in 8 bit mode
+
+      iii) Xilinx EMAC and Xilinx TEMAC
+
+      Xilinx Ethernet devices.  In addition to general xilinx properties
+      listed above, nodes for these devices should include a phy-handle
+      property, and may include other common network device properties
+      like local-mac-address.
+
+      iv) Xilinx Uartlite
+
+      Xilinx uartlite devices are simple fixed speed serial ports.
+
+      Required properties:
+       - current-speed : Baud rate of uartlite
+
+      v) Xilinx hwicap
+
+		Xilinx hwicap devices provide access to the configuration logic
+		of the FPGA through the Internal Configuration Access Port
+		(ICAP).  The ICAP enables partial reconfiguration of the FPGA,
+		readback of the configuration information, and some control over
+		'warm boots' of the FPGA fabric.
+
+		Required properties:
+		- xlnx,family : The family of the FPGA, necessary since the
+                      capabilities of the underlying ICAP hardware
+                      differ between different families.  May be
+                      'virtex2p', 'virtex4', or 'virtex5'.
+
+      vi) Xilinx Uart 16550
+
+      Xilinx UART 16550 devices are very similar to the NS16550 but with
+      different register spacing and an offset from the base address.
+
+      Required properties:
+       - clock-frequency : Frequency of the clock input
+       - reg-offset : A value of 3 is required
+       - reg-shift : A value of 2 is required
+
+      vii) Xilinx USB Host controller
+
+      The Xilinx USB host controller is EHCI compatible but with a different
+      base address for the EHCI registers, and it is always a big-endian
+      USB Host controller. The hardware can be configured as high speed only,
+      or high speed/full speed hybrid.
+
+      Required properties:
+      - xlnx,support-usb-fs: A value 0 means the core is built as high speed
+                             only. A value 1 means the core also supports
+                             full speed devices.
+
diff --git a/Documentation/devicetree/booting-without-of.txt b/Documentation/devicetree/booting-without-of.txt
new file mode 100644
index 0000000..7400d75
--- /dev/null
+++ b/Documentation/devicetree/booting-without-of.txt
@@ -0,0 +1,1447 @@
+           Booting the Linux/ppc kernel without Open Firmware
+           --------------------------------------------------
+
+(c) 2005 Benjamin Herrenschmidt <benh at kernel.crashing.org>,
+    IBM Corp.
+(c) 2005 Becky Bruce <becky.bruce at freescale.com>,
+    Freescale Semiconductor, FSL SOC and 32-bit additions
+(c) 2006 MontaVista Software, Inc.
+    Flash chip node definition
+
+Table of Contents
+=================
+
+  I - Introduction
+    1) Entry point for arch/powerpc
+    2) Board support
+
+  II - The DT block format
+    1) Header
+    2) Device tree generalities
+    3) Device tree "structure" block
+    4) Device tree "strings" block
+
+  III - Required content of the device tree
+    1) Note about cells and address representation
+    2) Note about "compatible" properties
+    3) Note about "name" properties
+    4) Note about node and property names and character set
+    5) Required nodes and properties
+      a) The root node
+      b) The /cpus node
+      c) The /cpus/* nodes
+      d) the /memory node(s)
+      e) The /chosen node
+      f) the /soc<SOCname> node
+
+  IV - "dtc", the device tree compiler
+
+  V - Recommendations for a bootloader
+
+  VI - System-on-a-chip devices and nodes
+    1) Defining child nodes of an SOC
+    2) Representing devices without a current OF specification
+      a) PHY nodes
+      b) Interrupt controllers
+      c) 4xx/Axon EMAC ethernet nodes
+      d) Xilinx IP cores
+      e) USB EHCI controllers
+      f) MDIO on GPIOs
+      g) SPI busses
+
+  VII - Specifying interrupt information for devices
+    1) interrupts property
+    2) interrupt-parent property
+    3) OpenPIC Interrupt Controllers
+    4) ISA Interrupt Controllers
+
+  VIII - Specifying device power management information (sleep property)
+
+  Appendix A - Sample SOC node for MPC8540
+
+
+Revision Information
+====================
+
+   May 18, 2005: Rev 0.1 - Initial draft, no chapter III yet.
+
+   May 19, 2005: Rev 0.2 - Add chapter III and bits & pieces here or
+                           clarifies the fact that a lot of things are
+                           optional, the kernel only requires a very
+                           small device tree, though it is encouraged
+                           to provide an as complete one as possible.
+
+   May 24, 2005: Rev 0.3 - Precise that DT block has to be in RAM
+			 - Misc fixes
+			 - Define version 3 and new format version 16
+			   for the DT block (version 16 needs kernel
+			   patches, will be fwd separately).
+			   String block now has a size, and full path
+			   is replaced by unit name for more
+			   compactness.
+			   linux,phandle is made optional, only nodes
+			   that are referenced by other nodes need it.
+			   "name" property is now automatically
+			   deduced from the unit name
+
+   June 1, 2005: Rev 0.4 - Correct confusion between OF_DT_END and
+                           OF_DT_END_NODE in structure definition.
+                         - Change version 16 format to always align
+                           property data to 4 bytes. Since tokens are
+                           already aligned, that means no specific
+                           required alignment between property size
+                           and property data. The old style variable
+                           alignment would make it impossible to do
+                           "simple" insertion of properties using
+                           memmove (thanks Milton for
+                           noticing). Updated kernel patch as well
+			 - Correct a few more alignment constraints
+			 - Add a chapter about the device-tree
+                           compiler and the textural representation of
+                           the tree that can be "compiled" by dtc.
+
+   November 21, 2005: Rev 0.5
+			 - Additions/generalizations for 32-bit
+			 - Changed to reflect the new arch/powerpc
+			   structure
+			 - Added chapter VI
+
+
+ ToDo:
+	- Add some definitions of interrupt tree (simple/complex)
+	- Add some definitions for PCI host bridges
+	- Add some common address format examples
+	- Add definitions for standard properties and "compatible"
+	  names for cells that are not already defined by the existing
+	  OF spec.
+	- Compare FSL SOC use of PCI to standard and make sure no new
+	  node definition required.
+	- Add more information about node definitions for SOC devices
+  	  that currently have no standard, like the FSL CPM.
+
+
+I - Introduction
+================
+
+During the recent development of the Linux/ppc64 kernel, and more
+specifically, the addition of new platform types outside of the old
+IBM pSeries/iSeries pair, it was decided to enforce some strict rules
+regarding the kernel entry and bootloader <-> kernel interfaces, in
+order to avoid the degeneration that had become the ppc32 kernel entry
+point and the way a new platform should be added to the kernel. The
+legacy iSeries platform breaks those rules as it predates this scheme,
+but no new board support will be accepted in the main tree that
+doesn't follow them properly.  In addition, since the advent of the
+arch/powerpc merged architecture for ppc32 and ppc64, new 32-bit
+platforms and 32-bit platforms which move into arch/powerpc will be
+required to use these rules as well.
+
+The main requirement that will be defined in more detail below is
+the presence of a device-tree whose format is defined after Open
+Firmware specification. However, in order to make life easier
+to embedded board vendors, the kernel doesn't require the device-tree
+to represent every device in the system and only requires some nodes
+and properties to be present. This will be described in detail in
+section III, but, for example, the kernel does not require you to
+create a node for every PCI device in the system. It is a requirement
+to have a node for PCI host bridges in order to provide interrupt
+routing informations and memory/IO ranges, among others. It is also
+recommended to define nodes for on chip devices and other busses that
+don't specifically fit in an existing OF specification. This creates a
+great flexibility in the way the kernel can then probe those and match
+drivers to device, without having to hard code all sorts of tables. It
+also makes it more flexible for board vendors to do minor hardware
+upgrades without significantly impacting the kernel code or cluttering
+it with special cases.
+
+
+1) Entry point for arch/powerpc
+-------------------------------
+
+   There is one and one single entry point to the kernel, at the start
+   of the kernel image. That entry point supports two calling
+   conventions:
+
+        a) Boot from Open Firmware. If your firmware is compatible
+        with Open Firmware (IEEE 1275) or provides an OF compatible
+        client interface API (support for "interpret" callback of
+        forth words isn't required), you can enter the kernel with:
+
+              r5 : OF callback pointer as defined by IEEE 1275
+              bindings to powerpc. Only the 32-bit client interface
+              is currently supported
+
+              r3, r4 : address & length of an initrd if any or 0
+
+              The MMU is either on or off; the kernel will run the
+              trampoline located in arch/powerpc/kernel/prom_init.c to
+              extract the device-tree and other information from open
+              firmware and build a flattened device-tree as described
+              in b). prom_init() will then re-enter the kernel using
+              the second method. This trampoline code runs in the
+              context of the firmware, which is supposed to handle all
+              exceptions during that time.
+
+        b) Direct entry with a flattened device-tree block. This entry
+        point is called by a) after the OF trampoline and can also be
+        called directly by a bootloader that does not support the Open
+        Firmware client interface. It is also used by "kexec" to
+        implement "hot" booting of a new kernel from a previous
+        running one. This method is what I will describe in more
+        details in this document, as method a) is simply standard Open
+        Firmware, and thus should be implemented according to the
+        various standard documents defining it and its binding to the
+        PowerPC platform. The entry point definition then becomes:
+
+                r3 : physical pointer to the device-tree block
+                (defined in chapter II) in RAM
+
+                r4 : physical pointer to the kernel itself. This is
+                used by the assembly code to properly disable the MMU
+                in case you are entering the kernel with MMU enabled
+                and a non-1:1 mapping.
+
+                r5 : NULL (as to differentiate with method a)
+
+        Note about SMP entry: Either your firmware puts your other
+        CPUs in some sleep loop or spin loop in ROM where you can get
+        them out via a soft reset or some other means, in which case
+        you don't need to care, or you'll have to enter the kernel
+        with all CPUs. The way to do that with method b) will be
+        described in a later revision of this document.
+
+
+2) Board support
+----------------
+
+64-bit kernels:
+
+   Board supports (platforms) are not exclusive config options. An
+   arbitrary set of board supports can be built in a single kernel
+   image. The kernel will "know" what set of functions to use for a
+   given platform based on the content of the device-tree. Thus, you
+   should:
+
+        a) add your platform support as a _boolean_ option in
+        arch/powerpc/Kconfig, following the example of PPC_PSERIES,
+        PPC_PMAC and PPC_MAPLE. The later is probably a good
+        example of a board support to start from.
+
+        b) create your main platform file as
+        "arch/powerpc/platforms/myplatform/myboard_setup.c" and add it
+        to the Makefile under the condition of your CONFIG_
+        option. This file will define a structure of type "ppc_md"
+        containing the various callbacks that the generic code will
+        use to get to your platform specific code
+
+        c) Add a reference to your "ppc_md" structure in the
+        "machines" table in arch/powerpc/kernel/setup_64.c if you are
+        a 64-bit platform.
+
+        d) request and get assigned a platform number (see PLATFORM_*
+        constants in arch/powerpc/include/asm/processor.h
+
+32-bit embedded kernels:
+
+  Currently, board support is essentially an exclusive config option.
+  The kernel is configured for a single platform.  Part of the reason
+  for this is to keep kernels on embedded systems small and efficient;
+  part of this is due to the fact the code is already that way. In the
+  future, a kernel may support multiple platforms, but only if the
+  platforms feature the same core architecture.  A single kernel build
+  cannot support both configurations with Book E and configurations
+  with classic Powerpc architectures.
+
+  32-bit embedded platforms that are moved into arch/powerpc using a
+  flattened device tree should adopt the merged tree practice of
+  setting ppc_md up dynamically, even though the kernel is currently
+  built with support for only a single platform at a time.  This allows
+  unification of the setup code, and will make it easier to go to a
+  multiple-platform-support model in the future.
+
+NOTE: I believe the above will be true once Ben's done with the merge
+of the boot sequences.... someone speak up if this is wrong!
+
+  To add a 32-bit embedded platform support, follow the instructions
+  for 64-bit platforms above, with the exception that the Kconfig
+  option should be set up such that the kernel builds exclusively for
+  the platform selected.  The processor type for the platform should
+  enable another config option to select the specific board
+  supported.
+
+NOTE: If Ben doesn't merge the setup files, may need to change this to
+point to setup_32.c
+
+
+   I will describe later the boot process and various callbacks that
+   your platform should implement.
+
+
+II - The DT block format
+========================
+
+
+This chapter defines the actual format of the flattened device-tree
+passed to the kernel. The actual content of it and kernel requirements
+are described later. You can find example of code manipulating that
+format in various places, including arch/powerpc/kernel/prom_init.c
+which will generate a flattened device-tree from the Open Firmware
+representation, or the fs2dt utility which is part of the kexec tools
+which will generate one from a filesystem representation. It is
+expected that a bootloader like uboot provides a bit more support,
+that will be discussed later as well.
+
+Note: The block has to be in main memory. It has to be accessible in
+both real mode and virtual mode with no mapping other than main
+memory. If you are writing a simple flash bootloader, it should copy
+the block to RAM before passing it to the kernel.
+
+
+1) Header
+---------
+
+   The kernel is entered with r3 pointing to an area of memory that is
+   roughly described in arch/powerpc/include/asm/prom.h by the structure
+   boot_param_header:
+
+struct boot_param_header {
+        u32     magic;                  /* magic word OF_DT_HEADER */
+        u32     totalsize;              /* total size of DT block */
+        u32     off_dt_struct;          /* offset to structure */
+        u32     off_dt_strings;         /* offset to strings */
+        u32     off_mem_rsvmap;         /* offset to memory reserve map
+                                           */
+        u32     version;                /* format version */
+        u32     last_comp_version;      /* last compatible version */
+
+        /* version 2 fields below */
+        u32     boot_cpuid_phys;        /* Which physical CPU id we're
+                                           booting on */
+        /* version 3 fields below */
+        u32     size_dt_strings;        /* size of the strings block */
+
+        /* version 17 fields below */
+        u32	size_dt_struct;		/* size of the DT structure block */
+};
+
+   Along with the constants:
+
+/* Definitions used by the flattened device tree */
+#define OF_DT_HEADER            0xd00dfeed      /* 4: version,
+						   4: total size */
+#define OF_DT_BEGIN_NODE        0x1             /* Start node: full name
+						   */
+#define OF_DT_END_NODE          0x2             /* End node */
+#define OF_DT_PROP              0x3             /* Property: name off,
+                                                   size, content */
+#define OF_DT_END               0x9
+
+   All values in this header are in big endian format, the various
+   fields in this header are defined more precisely below. All
+   "offset" values are in bytes from the start of the header; that is
+   from the value of r3.
+
+   - magic
+
+     This is a magic value that "marks" the beginning of the
+     device-tree block header. It contains the value 0xd00dfeed and is
+     defined by the constant OF_DT_HEADER
+
+   - totalsize
+
+     This is the total size of the DT block including the header. The
+     "DT" block should enclose all data structures defined in this
+     chapter (who are pointed to by offsets in this header). That is,
+     the device-tree structure, strings, and the memory reserve map.
+
+   - off_dt_struct
+
+     This is an offset from the beginning of the header to the start
+     of the "structure" part the device tree. (see 2) device tree)
+
+   - off_dt_strings
+
+     This is an offset from the beginning of the header to the start
+     of the "strings" part of the device-tree
+
+   - off_mem_rsvmap
+
+     This is an offset from the beginning of the header to the start
+     of the reserved memory map. This map is a list of pairs of 64-
+     bit integers. Each pair is a physical address and a size. The
+     list is terminated by an entry of size 0. This map provides the
+     kernel with a list of physical memory areas that are "reserved"
+     and thus not to be used for memory allocations, especially during
+     early initialization. The kernel needs to allocate memory during
+     boot for things like un-flattening the device-tree, allocating an
+     MMU hash table, etc... Those allocations must be done in such a
+     way to avoid overriding critical things like, on Open Firmware
+     capable machines, the RTAS instance, or on some pSeries, the TCE
+     tables used for the iommu. Typically, the reserve map should
+     contain _at least_ this DT block itself (header,total_size). If
+     you are passing an initrd to the kernel, you should reserve it as
+     well. You do not need to reserve the kernel image itself. The map
+     should be 64-bit aligned.
+
+   - version
+
+     This is the version of this structure. Version 1 stops
+     here. Version 2 adds an additional field boot_cpuid_phys.
+     Version 3 adds the size of the strings block, allowing the kernel
+     to reallocate it easily at boot and free up the unused flattened
+     structure after expansion. Version 16 introduces a new more
+     "compact" format for the tree itself that is however not backward
+     compatible. Version 17 adds an additional field, size_dt_struct,
+     allowing it to be reallocated or moved more easily (this is
+     particularly useful for bootloaders which need to make
+     adjustments to a device tree based on probed information). You
+     should always generate a structure of the highest version defined
+     at the time of your implementation. Currently that is version 17,
+     unless you explicitly aim at being backward compatible.
+
+   - last_comp_version
+
+     Last compatible version. This indicates down to what version of
+     the DT block you are backward compatible. For example, version 2
+     is backward compatible with version 1 (that is, a kernel build
+     for version 1 will be able to boot with a version 2 format). You
+     should put a 1 in this field if you generate a device tree of
+     version 1 to 3, or 16 if you generate a tree of version 16 or 17
+     using the new unit name format.
+
+   - boot_cpuid_phys
+
+     This field only exist on version 2 headers. It indicate which
+     physical CPU ID is calling the kernel entry point. This is used,
+     among others, by kexec. If you are on an SMP system, this value
+     should match the content of the "reg" property of the CPU node in
+     the device-tree corresponding to the CPU calling the kernel entry
+     point (see further chapters for more informations on the required
+     device-tree contents)
+
+   - size_dt_strings
+
+     This field only exists on version 3 and later headers.  It
+     gives the size of the "strings" section of the device tree (which
+     starts at the offset given by off_dt_strings).
+
+   - size_dt_struct
+
+     This field only exists on version 17 and later headers.  It gives
+     the size of the "structure" section of the device tree (which
+     starts at the offset given by off_dt_struct).
+
+   So the typical layout of a DT block (though the various parts don't
+   need to be in that order) looks like this (addresses go from top to
+   bottom):
+
+
+             ------------------------------
+       r3 -> |  struct boot_param_header  |
+             ------------------------------
+             |      (alignment gap) (*)   |
+             ------------------------------
+             |      memory reserve map    |
+             ------------------------------
+             |      (alignment gap)       |
+             ------------------------------
+             |                            |
+             |    device-tree structure   |
+             |                            |
+             ------------------------------
+             |      (alignment gap)       |
+             ------------------------------
+             |                            |
+             |     device-tree strings    |
+             |                            |
+      -----> ------------------------------
+      |
+      |
+      --- (r3 + totalsize)
+
+  (*) The alignment gaps are not necessarily present; their presence
+      and size are dependent on the various alignment requirements of
+      the individual data blocks.
+
+
+2) Device tree generalities
+---------------------------
+
+This device-tree itself is separated in two different blocks, a
+structure block and a strings block. Both need to be aligned to a 4
+byte boundary.
+
+First, let's quickly describe the device-tree concept before detailing
+the storage format. This chapter does _not_ describe the detail of the
+required types of nodes & properties for the kernel, this is done
+later in chapter III.
+
+The device-tree layout is strongly inherited from the definition of
+the Open Firmware IEEE 1275 device-tree. It's basically a tree of
+nodes, each node having two or more named properties. A property can
+have a value or not.
+
+It is a tree, so each node has one and only one parent except for the
+root node who has no parent.
+
+A node has 2 names. The actual node name is generally contained in a
+property of type "name" in the node property list whose value is a
+zero terminated string and is mandatory for version 1 to 3 of the
+format definition (as it is in Open Firmware). Version 16 makes it
+optional as it can generate it from the unit name defined below.
+
+There is also a "unit name" that is used to differentiate nodes with
+the same name at the same level, it is usually made of the node
+names, the "@" sign, and a "unit address", which definition is
+specific to the bus type the node sits on.
+
+The unit name doesn't exist as a property per-se but is included in
+the device-tree structure. It is typically used to represent "path" in
+the device-tree. More details about the actual format of these will be
+below.
+
+The kernel powerpc generic code does not make any formal use of the
+unit address (though some board support code may do) so the only real
+requirement here for the unit address is to ensure uniqueness of
+the node unit name at a given level of the tree. Nodes with no notion
+of address and no possible sibling of the same name (like /memory or
+/cpus) may omit the unit address in the context of this specification,
+or use the "@0" default unit address. The unit name is used to define
+a node "full path", which is the concatenation of all parent node
+unit names separated with "/".
+
+The root node doesn't have a defined name, and isn't required to have
+a name property either if you are using version 3 or earlier of the
+format. It also has no unit address (no @ symbol followed by a unit
+address). The root node unit name is thus an empty string. The full
+path to the root node is "/".
+
+Every node which actually represents an actual device (that is, a node
+which isn't only a virtual "container" for more nodes, like "/cpus"
+is) is also required to have a "device_type" property indicating the
+type of node .
+
+Finally, every node that can be referenced from a property in another
+node is required to have a "linux,phandle" property. Real open
+firmware implementations provide a unique "phandle" value for every
+node that the "prom_init()" trampoline code turns into
+"linux,phandle" properties. However, this is made optional if the
+flattened device tree is used directly. An example of a node
+referencing another node via "phandle" is when laying out the
+interrupt tree which will be described in a further version of this
+document.
+
+This "linux, phandle" property is a 32-bit value that uniquely
+identifies a node. You are free to use whatever values or system of
+values, internal pointers, or whatever to generate these, the only
+requirement is that every node for which you provide that property has
+a unique value for it.
+
+Here is an example of a simple device-tree. In this example, an "o"
+designates a node followed by the node unit name. Properties are
+presented with their name followed by their content. "content"
+represents an ASCII string (zero terminated) value, while <content>
+represents a 32-bit hexadecimal value. The various nodes in this
+example will be discussed in a later chapter. At this point, it is
+only meant to give you a idea of what a device-tree looks like. I have
+purposefully kept the "name" and "linux,phandle" properties which
+aren't necessary in order to give you a better idea of what the tree
+looks like in practice.
+
+  / o device-tree
+      |- name = "device-tree"
+      |- model = "MyBoardName"
+      |- compatible = "MyBoardFamilyName"
+      |- #address-cells = <2>
+      |- #size-cells = <2>
+      |- linux,phandle = <0>
+      |
+      o cpus
+      | | - name = "cpus"
+      | | - linux,phandle = <1>
+      | | - #address-cells = <1>
+      | | - #size-cells = <0>
+      | |
+      | o PowerPC,970@0
+      |   |- name = "PowerPC,970"
+      |   |- device_type = "cpu"
+      |   |- reg = <0>
+      |   |- clock-frequency = <5f5e1000>
+      |   |- 64-bit
+      |   |- linux,phandle = <2>
+      |
+      o memory@0
+      | |- name = "memory"
+      | |- device_type = "memory"
+      | |- reg = <00000000 00000000 00000000 20000000>
+      | |- linux,phandle = <3>
+      |
+      o chosen
+        |- name = "chosen"
+        |- bootargs = "root=/dev/sda2"
+        |- linux,phandle = <4>
+
+This tree is almost a minimal tree. It pretty much contains the
+minimal set of required nodes and properties to boot a linux kernel;
+that is, some basic model informations at the root, the CPUs, and the
+physical memory layout.  It also includes misc information passed
+through /chosen, like in this example, the platform type (mandatory)
+and the kernel command line arguments (optional).
+
+The /cpus/PowerPC,970@0/64-bit property is an example of a
+property without a value. All other properties have a value. The
+significance of the #address-cells and #size-cells properties will be
+explained in chapter IV which defines precisely the required nodes and
+properties and their content.
+
+
+3) Device tree "structure" block
+
+The structure of the device tree is a linearized tree structure. The
+"OF_DT_BEGIN_NODE" token starts a new node, and the "OF_DT_END_NODE"
+ends that node definition. Child nodes are simply defined before
+"OF_DT_END_NODE" (that is nodes within the node). A 'token' is a 32
+bit value. The tree has to be "finished" with a OF_DT_END token
+
+Here's the basic structure of a single node:
+
+     * token OF_DT_BEGIN_NODE (that is 0x00000001)
+     * for version 1 to 3, this is the node full path as a zero
+       terminated string, starting with "/". For version 16 and later,
+       this is the node unit name only (or an empty string for the
+       root node)
+     * [align gap to next 4 bytes boundary]
+     * for each property:
+        * token OF_DT_PROP (that is 0x00000003)
+        * 32-bit value of property value size in bytes (or 0 if no
+          value)
+        * 32-bit value of offset in string block of property name
+        * property value data if any
+        * [align gap to next 4 bytes boundary]
+     * [child nodes if any]
+     * token OF_DT_END_NODE (that is 0x00000002)
+
+So the node content can be summarized as a start token, a full path,
+a list of properties, a list of child nodes, and an end token. Every
+child node is a full node structure itself as defined above.
+
+NOTE: The above definition requires that all property definitions for
+a particular node MUST precede any subnode definitions for that node.
+Although the structure would not be ambiguous if properties and
+subnodes were intermingled, the kernel parser requires that the
+properties come first (up until at least 2.6.22).  Any tools
+manipulating a flattened tree must take care to preserve this
+constraint.
+
+4) Device tree "strings" block
+
+In order to save space, property names, which are generally redundant,
+are stored separately in the "strings" block. This block is simply the
+whole bunch of zero terminated strings for all property names
+concatenated together. The device-tree property definitions in the
+structure block will contain offset values from the beginning of the
+strings block.
+
+
+III - Required content of the device tree
+=========================================
+
+WARNING: All "linux,*" properties defined in this document apply only
+to a flattened device-tree. If your platform uses a real
+implementation of Open Firmware or an implementation compatible with
+the Open Firmware client interface, those properties will be created
+by the trampoline code in the kernel's prom_init() file. For example,
+that's where you'll have to add code to detect your board model and
+set the platform number. However, when using the flattened device-tree
+entry point, there is no prom_init() pass, and thus you have to
+provide those properties yourself.
+
+
+1) Note about cells and address representation
+----------------------------------------------
+
+The general rule is documented in the various Open Firmware
+documentations. If you choose to describe a bus with the device-tree
+and there exist an OF bus binding, then you should follow the
+specification. However, the kernel does not require every single
+device or bus to be described by the device tree.
+
+In general, the format of an address for a device is defined by the
+parent bus type, based on the #address-cells and #size-cells
+properties.  Note that the parent's parent definitions of #address-cells
+and #size-cells are not inherited so every node with children must specify
+them.  The kernel requires the root node to have those properties defining
+addresses format for devices directly mapped on the processor bus.
+
+Those 2 properties define 'cells' for representing an address and a
+size. A "cell" is a 32-bit number. For example, if both contain 2
+like the example tree given above, then an address and a size are both
+composed of 2 cells, and each is a 64-bit number (cells are
+concatenated and expected to be in big endian format). Another example
+is the way Apple firmware defines them, with 2 cells for an address
+and one cell for a size.  Most 32-bit implementations should define
+#address-cells and #size-cells to 1, which represents a 32-bit value.
+Some 32-bit processors allow for physical addresses greater than 32
+bits; these processors should define #address-cells as 2.
+
+"reg" properties are always a tuple of the type "address size" where
+the number of cells of address and size is specified by the bus
+#address-cells and #size-cells. When a bus supports various address
+spaces and other flags relative to a given address allocation (like
+prefetchable, etc...) those flags are usually added to the top level
+bits of the physical address. For example, a PCI physical address is
+made of 3 cells, the bottom two containing the actual address itself
+while the top cell contains address space indication, flags, and pci
+bus & device numbers.
+
+For busses that support dynamic allocation, it's the accepted practice
+to then not provide the address in "reg" (keep it 0) though while
+providing a flag indicating the address is dynamically allocated, and
+then, to provide a separate "assigned-addresses" property that
+contains the fully allocated addresses. See the PCI OF bindings for
+details.
+
+In general, a simple bus with no address space bits and no dynamic
+allocation is preferred if it reflects your hardware, as the existing
+kernel address parsing functions will work out of the box. If you
+define a bus type with a more complex address format, including things
+like address space bits, you'll have to add a bus translator to the
+prom_parse.c file of the recent kernels for your bus type.
+
+The "reg" property only defines addresses and sizes (if #size-cells is
+non-0) within a given bus. In order to translate addresses upward
+(that is into parent bus addresses, and possibly into CPU physical
+addresses), all busses must contain a "ranges" property. If the
+"ranges" property is missing at a given level, it's assumed that
+translation isn't possible, i.e., the registers are not visible on the
+parent bus.  The format of the "ranges" property for a bus is a list
+of:
+
+	bus address, parent bus address, size
+
+"bus address" is in the format of the bus this bus node is defining,
+that is, for a PCI bridge, it would be a PCI address. Thus, (bus
+address, size) defines a range of addresses for child devices. "parent
+bus address" is in the format of the parent bus of this bus. For
+example, for a PCI host controller, that would be a CPU address. For a
+PCI<->ISA bridge, that would be a PCI address. It defines the base
+address in the parent bus where the beginning of that range is mapped.
+
+For a new 64-bit powerpc board, I recommend either the 2/2 format or
+Apple's 2/1 format which is slightly more compact since sizes usually
+fit in a single 32-bit word.   New 32-bit powerpc boards should use a
+1/1 format, unless the processor supports physical addresses greater
+than 32-bits, in which case a 2/1 format is recommended.
+
+Alternatively, the "ranges" property may be empty, indicating that the
+registers are visible on the parent bus using an identity mapping
+translation.  In other words, the parent bus address space is the same
+as the child bus address space.
+
+2) Note about "compatible" properties
+-------------------------------------
+
+These properties are optional, but recommended in devices and the root
+node. The format of a "compatible" property is a list of concatenated
+zero terminated strings. They allow a device to express its
+compatibility with a family of similar devices, in some cases,
+allowing a single driver to match against several devices regardless
+of their actual names.
+
+3) Note about "name" properties
+-------------------------------
+
+While earlier users of Open Firmware like OldWorld macintoshes tended
+to use the actual device name for the "name" property, it's nowadays
+considered a good practice to use a name that is closer to the device
+class (often equal to device_type). For example, nowadays, ethernet
+controllers are named "ethernet", an additional "model" property
+defining precisely the chip type/model, and "compatible" property
+defining the family in case a single driver can driver more than one
+of these chips. However, the kernel doesn't generally put any
+restriction on the "name" property; it is simply considered good
+practice to follow the standard and its evolutions as closely as
+possible.
+
+Note also that the new format version 16 makes the "name" property
+optional. If it's absent for a node, then the node's unit name is then
+used to reconstruct the name. That is, the part of the unit name
+before the "@" sign is used (or the entire unit name if no "@" sign
+is present).
+
+4) Note about node and property names and character set
+-------------------------------------------------------
+
+While open firmware provides more flexible usage of 8859-1, this
+specification enforces more strict rules. Nodes and properties should
+be comprised only of ASCII characters 'a' to 'z', '0' to
+'9', ',', '.', '_', '+', '#', '?', and '-'. Node names additionally
+allow uppercase characters 'A' to 'Z' (property names should be
+lowercase. The fact that vendors like Apple don't respect this rule is
+irrelevant here). Additionally, node and property names should always
+begin with a character in the range 'a' to 'z' (or 'A' to 'Z' for node
+names).
+
+The maximum number of characters for both nodes and property names
+is 31. In the case of node names, this is only the leftmost part of
+a unit name (the pure "name" property), it doesn't include the unit
+address which can extend beyond that limit.
+
+
+5) Required nodes and properties
+--------------------------------
+  These are all that are currently required. However, it is strongly
+  recommended that you expose PCI host bridges as documented in the
+  PCI binding to open firmware, and your interrupt tree as documented
+  in OF interrupt tree specification.
+
+  a) The root node
+
+  The root node requires some properties to be present:
+
+    - model : this is your board name/model
+    - #address-cells : address representation for "root" devices
+    - #size-cells: the size representation for "root" devices
+    - device_type : This property shouldn't be necessary. However, if
+      you decide to create a device_type for your root node, make sure it
+      is _not_ "chrp" unless your platform is a pSeries or PAPR compliant
+      one for 64-bit, or a CHRP-type machine for 32-bit as this will
+      matched by the kernel this way.
+
+  Additionally, some recommended properties are:
+
+    - compatible : the board "family" generally finds its way here,
+      for example, if you have 2 board models with a similar layout,
+      that typically get driven by the same platform code in the
+      kernel, you would use a different "model" property but put a
+      value in "compatible". The kernel doesn't directly use that
+      value but it is generally useful.
+
+  The root node is also generally where you add additional properties
+  specific to your board like the serial number if any, that sort of
+  thing. It is recommended that if you add any "custom" property whose
+  name may clash with standard defined ones, you prefix them with your
+  vendor name and a comma.
+
+  b) The /cpus node
+
+  This node is the parent of all individual CPU nodes. It doesn't
+  have any specific requirements, though it's generally good practice
+  to have at least:
+
+               #address-cells = <00000001>
+               #size-cells    = <00000000>
+
+  This defines that the "address" for a CPU is a single cell, and has
+  no meaningful size. This is not necessary but the kernel will assume
+  that format when reading the "reg" properties of a CPU node, see
+  below
+
+  c) The /cpus/* nodes
+
+  So under /cpus, you are supposed to create a node for every CPU on
+  the machine. There is no specific restriction on the name of the
+  CPU, though It's common practice to call it PowerPC,<name>. For
+  example, Apple uses PowerPC,G5 while IBM uses PowerPC,970FX.
+
+  Required properties:
+
+    - device_type : has to be "cpu"
+    - reg : This is the physical CPU number, it's a single 32-bit cell
+      and is also used as-is as the unit number for constructing the
+      unit name in the full path. For example, with 2 CPUs, you would
+      have the full path:
+        /cpus/PowerPC,970FX@0
+        /cpus/PowerPC,970FX@1
+      (unit addresses do not require leading zeroes)
+    - d-cache-block-size : one cell, L1 data cache block size in bytes (*)
+    - i-cache-block-size : one cell, L1 instruction cache block size in
+      bytes
+    - d-cache-size : one cell, size of L1 data cache in bytes
+    - i-cache-size : one cell, size of L1 instruction cache in bytes
+
+(*) The cache "block" size is the size on which the cache management
+instructions operate. Historically, this document used the cache
+"line" size here which is incorrect. The kernel will prefer the cache
+block size and will fallback to cache line size for backward
+compatibility.
+
+  Recommended properties:
+
+    - timebase-frequency : a cell indicating the frequency of the
+      timebase in Hz. This is not directly used by the generic code,
+      but you are welcome to copy/paste the pSeries code for setting
+      the kernel timebase/decrementer calibration based on this
+      value.
+    - clock-frequency : a cell indicating the CPU core clock frequency
+      in Hz. A new property will be defined for 64-bit values, but if
+      your frequency is < 4Ghz, one cell is enough. Here as well as
+      for the above, the common code doesn't use that property, but
+      you are welcome to re-use the pSeries or Maple one. A future
+      kernel version might provide a common function for this.
+    - d-cache-line-size : one cell, L1 data cache line size in bytes
+      if different from the block size
+    - i-cache-line-size : one cell, L1 instruction cache line size in
+      bytes if different from the block size
+
+  You are welcome to add any property you find relevant to your board,
+  like some information about the mechanism used to soft-reset the
+  CPUs. For example, Apple puts the GPIO number for CPU soft reset
+  lines in there as a "soft-reset" property since they start secondary
+  CPUs by soft-resetting them.
+
+
+  d) the /memory node(s)
+
+  To define the physical memory layout of your board, you should
+  create one or more memory node(s). You can either create a single
+  node with all memory ranges in its reg property, or you can create
+  several nodes, as you wish. The unit address (@ part) used for the
+  full path is the address of the first range of memory defined by a
+  given node. If you use a single memory node, this will typically be
+  @0.
+
+  Required properties:
+
+    - device_type : has to be "memory"
+    - reg : This property contains all the physical memory ranges of
+      your board. It's a list of addresses/sizes concatenated
+      together, with the number of cells of each defined by the
+      #address-cells and #size-cells of the root node. For example,
+      with both of these properties being 2 like in the example given
+      earlier, a 970 based machine with 6Gb of RAM could typically
+      have a "reg" property here that looks like:
+
+      00000000 00000000 00000000 80000000
+      00000001 00000000 00000001 00000000
+
+      That is a range starting at 0 of 0x80000000 bytes and a range
+      starting at 0x100000000 and of 0x100000000 bytes. You can see
+      that there is no memory covering the IO hole between 2Gb and
+      4Gb. Some vendors prefer splitting those ranges into smaller
+      segments, but the kernel doesn't care.
+
+  e) The /chosen node
+
+  This node is a bit "special". Normally, that's where open firmware
+  puts some variable environment information, like the arguments, or
+  the default input/output devices.
+
+  This specification makes a few of these mandatory, but also defines
+  some linux-specific properties that would be normally constructed by
+  the prom_init() trampoline when booting with an OF client interface,
+  but that you have to provide yourself when using the flattened format.
+
+  Recommended properties:
+
+    - bootargs : This zero-terminated string is passed as the kernel
+      command line
+    - linux,stdout-path : This is the full path to your standard
+      console device if any. Typically, if you have serial devices on
+      your board, you may want to put the full path to the one set as
+      the default console in the firmware here, for the kernel to pick
+      it up as its own default console. If you look at the function
+      set_preferred_console() in arch/ppc64/kernel/setup.c, you'll see
+      that the kernel tries to find out the default console and has
+      knowledge of various types like 8250 serial ports. You may want
+      to extend this function to add your own.
+
+  Note that u-boot creates and fills in the chosen node for platforms
+  that use it.
+
+  (Note: a practice that is now obsolete was to include a property
+  under /chosen called interrupt-controller which had a phandle value
+  that pointed to the main interrupt controller)
+
+  f) the /soc<SOCname> node
+
+  This node is used to represent a system-on-a-chip (SOC) and must be
+  present if the processor is a SOC. The top-level soc node contains
+  information that is global to all devices on the SOC. The node name
+  should contain a unit address for the SOC, which is the base address
+  of the memory-mapped register set for the SOC. The name of an soc
+  node should start with "soc", and the remainder of the name should
+  represent the part number for the soc.  For example, the MPC8540's
+  soc node would be called "soc8540".
+
+  Required properties:
+
+    - device_type : Should be "soc"
+    - ranges : Should be defined as specified in 1) to describe the
+      translation of SOC addresses for memory mapped SOC registers.
+    - bus-frequency: Contains the bus frequency for the SOC node.
+      Typically, the value of this field is filled in by the boot
+      loader.
+
+
+  Recommended properties:
+
+    - reg : This property defines the address and size of the
+      memory-mapped registers that are used for the SOC node itself.
+      It does not include the child device registers - these will be
+      defined inside each child node.  The address specified in the
+      "reg" property should match the unit address of the SOC node.
+    - #address-cells : Address representation for "soc" devices.  The
+      format of this field may vary depending on whether or not the
+      device registers are memory mapped.  For memory mapped
+      registers, this field represents the number of cells needed to
+      represent the address of the registers.  For SOCs that do not
+      use MMIO, a special address format should be defined that
+      contains enough cells to represent the required information.
+      See 1) above for more details on defining #address-cells.
+    - #size-cells : Size representation for "soc" devices
+    - #interrupt-cells : Defines the width of cells used to represent
+       interrupts.  Typically this value is <2>, which includes a
+       32-bit number that represents the interrupt number, and a
+       32-bit number that represents the interrupt sense and level.
+       This field is only needed if the SOC contains an interrupt
+       controller.
+
+  The SOC node may contain child nodes for each SOC device that the
+  platform uses.  Nodes should not be created for devices which exist
+  on the SOC but are not used by a particular platform. See chapter VI
+  for more information on how to specify devices that are part of a SOC.
+
+  Example SOC node for the MPC8540:
+
+	soc8540@e0000000 {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		#interrupt-cells = <2>;
+		device_type = "soc";
+		ranges = <00000000 e0000000 00100000>
+		reg = <e0000000 00003000>;
+		bus-frequency = <0>;
+	}
+
+
+
+IV - "dtc", the device tree compiler
+====================================
+
+
+dtc source code can be found at
+<http://git.jdl.com/gitweb/?p=dtc.git>
+
+WARNING: This version is still in early development stage; the
+resulting device-tree "blobs" have not yet been validated with the
+kernel. The current generated block lacks a useful reserve map (it will
+be fixed to generate an empty one, it's up to the bootloader to fill
+it up) among others. The error handling needs work, bugs are lurking,
+etc...
+
+dtc basically takes a device-tree in a given format and outputs a
+device-tree in another format. The currently supported formats are:
+
+  Input formats:
+  -------------
+
+     - "dtb": "blob" format, that is a flattened device-tree block
+       with
+        header all in a binary blob.
+     - "dts": "source" format. This is a text file containing a
+       "source" for a device-tree. The format is defined later in this
+        chapter.
+     - "fs" format. This is a representation equivalent to the
+        output of /proc/device-tree, that is nodes are directories and
+	properties are files
+
+ Output formats:
+ ---------------
+
+     - "dtb": "blob" format
+     - "dts": "source" format
+     - "asm": assembly language file. This is a file that can be
+       sourced by gas to generate a device-tree "blob". That file can
+       then simply be added to your Makefile. Additionally, the
+       assembly file exports some symbols that can be used.
+
+
+The syntax of the dtc tool is
+
+    dtc [-I <input-format>] [-O <output-format>]
+        [-o output-filename] [-V output_version] input_filename
+
+
+The "output_version" defines what version of the "blob" format will be
+generated. Supported versions are 1,2,3 and 16. The default is
+currently version 3 but that may change in the future to version 16.
+
+Additionally, dtc performs various sanity checks on the tree, like the
+uniqueness of linux, phandle properties, validity of strings, etc...
+
+The format of the .dts "source" file is "C" like, supports C and C++
+style comments.
+
+/ {
+}
+
+The above is the "device-tree" definition. It's the only statement
+supported currently at the toplevel.
+
+/ {
+  property1 = "string_value";	/* define a property containing a 0
+                                 * terminated string
+				 */
+
+  property2 = <1234abcd>;	/* define a property containing a
+                                 * numerical 32-bit value (hexadecimal)
+				 */
+
+  property3 = <12345678 12345678 deadbeef>;
+                                /* define a property containing 3
+                                 * numerical 32-bit values (cells) in
+                                 * hexadecimal
+				 */
+  property4 = [0a 0b 0c 0d de ea ad be ef];
+                                /* define a property whose content is
+                                 * an arbitrary array of bytes
+                                 */
+
+  childnode@address {	/* define a child node named "childnode"
+                                 * whose unit name is "childnode at
+				 * address"
+                                 */
+
+    childprop = "hello\n";      /* define a property "childprop" of
+                                 * childnode (in this case, a string)
+                                 */
+  };
+};
+
+Nodes can contain other nodes etc... thus defining the hierarchical
+structure of the tree.
+
+Strings support common escape sequences from C: "\n", "\t", "\r",
+"\(octal value)", "\x(hex value)".
+
+It is also suggested that you pipe your source file through cpp (gcc
+preprocessor) so you can use #include's, #define for constants, etc...
+
+Finally, various options are planned but not yet implemented, like
+automatic generation of phandles, labels (exported to the asm file so
+you can point to a property content and change it easily from whatever
+you link the device-tree with), label or path instead of numeric value
+in some cells to "point" to a node (replaced by a phandle at compile
+time), export of reserve map address to the asm file, ability to
+specify reserve map content at compile time, etc...
+
+We may provide a .h include file with common definitions of that
+proves useful for some properties (like building PCI properties or
+interrupt maps) though it may be better to add a notion of struct
+definitions to the compiler...
+
+
+V - Recommendations for a bootloader
+====================================
+
+
+Here are some various ideas/recommendations that have been proposed
+while all this has been defined and implemented.
+
+  - The bootloader may want to be able to use the device-tree itself
+    and may want to manipulate it (to add/edit some properties,
+    like physical memory size or kernel arguments). At this point, 2
+    choices can be made. Either the bootloader works directly on the
+    flattened format, or the bootloader has its own internal tree
+    representation with pointers (similar to the kernel one) and
+    re-flattens the tree when booting the kernel. The former is a bit
+    more difficult to edit/modify, the later requires probably a bit
+    more code to handle the tree structure. Note that the structure
+    format has been designed so it's relatively easy to "insert"
+    properties or nodes or delete them by just memmoving things
+    around. It contains no internal offsets or pointers for this
+    purpose.
+
+  - An example of code for iterating nodes & retrieving properties
+    directly from the flattened tree format can be found in the kernel
+    file arch/ppc64/kernel/prom.c, look at scan_flat_dt() function,
+    its usage in early_init_devtree(), and the corresponding various
+    early_init_dt_scan_*() callbacks. That code can be re-used in a
+    GPL bootloader, and as the author of that code, I would be happy
+    to discuss possible free licensing to any vendor who wishes to
+    integrate all or part of this code into a non-GPL bootloader.
+
+
+
+VI - System-on-a-chip devices and nodes
+=======================================
+
+Many companies are now starting to develop system-on-a-chip
+processors, where the processor core (CPU) and many peripheral devices
+exist on a single piece of silicon.  For these SOCs, an SOC node
+should be used that defines child nodes for the devices that make
+up the SOC. While platforms are not required to use this model in
+order to boot the kernel, it is highly encouraged that all SOC
+implementations define as complete a flat-device-tree as possible to
+describe the devices on the SOC.  This will allow for the
+genericization of much of the kernel code.
+
+
+1) Defining child nodes of an SOC
+---------------------------------
+
+Each device that is part of an SOC may have its own node entry inside
+the SOC node.  For each device that is included in the SOC, the unit
+address property represents the address offset for this device's
+memory-mapped registers in the parent's address space.  The parent's
+address space is defined by the "ranges" property in the top-level soc
+node. The "reg" property for each node that exists directly under the
+SOC node should contain the address mapping from the child address space
+to the parent SOC address space and the size of the device's
+memory-mapped register file.
+
+For many devices that may exist inside an SOC, there are predefined
+specifications for the format of the device tree node.  All SOC child
+nodes should follow these specifications, except where noted in this
+document.
+
+See appendix A for an example partial SOC node definition for the
+MPC8540.
+
+
+2) Representing devices without a current OF specification
+----------------------------------------------------------
+
+Currently, there are many devices on SOCs that do not have a standard
+representation pre-defined as part of the open firmware
+specifications, mainly because the boards that contain these SOCs are
+not currently booted using open firmware.   This section contains
+descriptions for the SOC devices for which new nodes have been
+defined; this list will expand as more and more SOC-containing
+platforms are moved over to use the flattened-device-tree model.
+
+VII - Specifying interrupt information for devices
+===================================================
+
+The device tree represents the busses and devices of a hardware
+system in a form similar to the physical bus topology of the
+hardware.
+
+In addition, a logical 'interrupt tree' exists which represents the
+hierarchy and routing of interrupts in the hardware.
+
+The interrupt tree model is fully described in the
+document "Open Firmware Recommended Practice: Interrupt
+Mapping Version 0.9".  The document is available at:
+<http://playground.sun.com/1275/practice>.
+
+1) interrupts property
+----------------------
+
+Devices that generate interrupts to a single interrupt controller
+should use the conventional OF representation described in the
+OF interrupt mapping documentation.
+
+Each device which generates interrupts must have an 'interrupt'
+property.  The interrupt property value is an arbitrary number of
+of 'interrupt specifier' values which describe the interrupt or
+interrupts for the device.
+
+The encoding of an interrupt specifier is determined by the
+interrupt domain in which the device is located in the
+interrupt tree.  The root of an interrupt domain specifies in
+its #interrupt-cells property the number of 32-bit cells
+required to encode an interrupt specifier.  See the OF interrupt
+mapping documentation for a detailed description of domains.
+
+For example, the binding for the OpenPIC interrupt controller
+specifies  an #interrupt-cells value of 2 to encode the interrupt
+number and level/sense information. All interrupt children in an
+OpenPIC interrupt domain use 2 cells per interrupt in their interrupts
+property.
+
+The PCI bus binding specifies a #interrupt-cell value of 1 to encode
+which interrupt pin (INTA,INTB,INTC,INTD) is used.
+
+2) interrupt-parent property
+----------------------------
+
+The interrupt-parent property is specified to define an explicit
+link between a device node and its interrupt parent in
+the interrupt tree.  The value of interrupt-parent is the
+phandle of the parent node.
+
+If the interrupt-parent property is not defined for a node, its
+interrupt parent is assumed to be an ancestor in the node's
+_device tree_ hierarchy.
+
+3) OpenPIC Interrupt Controllers
+--------------------------------
+
+OpenPIC interrupt controllers require 2 cells to encode
+interrupt information.  The first cell defines the interrupt
+number.  The second cell defines the sense and level
+information.
+
+Sense and level information should be encoded as follows:
+
+	0 = low to high edge sensitive type enabled
+	1 = active low level sensitive type enabled
+	2 = active high level sensitive type enabled
+	3 = high to low edge sensitive type enabled
+
+4) ISA Interrupt Controllers
+----------------------------
+
+ISA PIC interrupt controllers require 2 cells to encode
+interrupt information.  The first cell defines the interrupt
+number.  The second cell defines the sense and level
+information.
+
+ISA PIC interrupt controllers should adhere to the ISA PIC
+encodings listed below:
+
+	0 =  active low level sensitive type enabled
+	1 =  active high level sensitive type enabled
+	2 =  high to low edge sensitive type enabled
+	3 =  low to high edge sensitive type enabled
+
+VIII - Specifying Device Power Management Information (sleep property)
+===================================================================
+
+Devices on SOCs often have mechanisms for placing devices into low-power
+states that are decoupled from the devices' own register blocks.  Sometimes,
+this information is more complicated than a cell-index property can
+reasonably describe.  Thus, each device controlled in such a manner
+may contain a "sleep" property which describes these connections.
+
+The sleep property consists of one or more sleep resources, each of
+which consists of a phandle to a sleep controller, followed by a
+controller-specific sleep specifier of zero or more cells.
+
+The semantics of what type of low power modes are possible are defined
+by the sleep controller.  Some examples of the types of low power modes
+that may be supported are:
+
+ - Dynamic: The device may be disabled or enabled at any time.
+ - System Suspend: The device may request to be disabled or remain
+   awake during system suspend, but will not be disabled until then.
+ - Permanent: The device is disabled permanently (until the next hard
+   reset).
+
+Some devices may share a clock domain with each other, such that they should
+only be suspended when none of the devices are in use.  Where reasonable,
+such nodes should be placed on a virtual bus, where the bus has the sleep
+property.  If the clock domain is shared among devices that cannot be
+reasonably grouped in this manner, then create a virtual sleep controller
+(similar to an interrupt nexus, except that defining a standardized
+sleep-map should wait until its necessity is demonstrated).
+
+Appendix A - Sample SOC node for MPC8540
+========================================
+
+	soc@e0000000 {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		compatible = "fsl,mpc8540-ccsr", "simple-bus";
+		device_type = "soc";
+		ranges = <0x00000000 0xe0000000 0x00100000>
+		bus-frequency = <0>;
+		interrupt-parent = <&pic>;
+
+		ethernet@24000 {
+			#address-cells = <1>;
+			#size-cells = <1>;
+			device_type = "network";
+			model = "TSEC";
+			compatible = "gianfar", "simple-bus";
+			reg = <0x24000 0x1000>;
+			local-mac-address = [ 00 E0 0C 00 73 00 ];
+			interrupts = <29 2 30 2 34 2>;
+			phy-handle = <&phy0>;
+			sleep = <&pmc 00000080>;
+			ranges;
+
+			mdio@24520 {
+				reg = <0x24520 0x20>;
+				compatible = "fsl,gianfar-mdio";
+
+				phy0: ethernet-phy@0 {
+					interrupts = <5 1>;
+					reg = <0>;
+					device_type = "ethernet-phy";
+				};
+
+				phy1: ethernet-phy@1 {
+					interrupts = <5 1>;
+					reg = <1>;
+					device_type = "ethernet-phy";
+				};
+
+				phy3: ethernet-phy@3 {
+					interrupts = <7 1>;
+					reg = <3>;
+					device_type = "ethernet-phy";
+				};
+			};
+		};
+
+		ethernet@25000 {
+			device_type = "network";
+			model = "TSEC";
+			compatible = "gianfar";
+			reg = <0x25000 0x1000>;
+			local-mac-address = [ 00 E0 0C 00 73 01 ];
+			interrupts = <13 2 14 2 18 2>;
+			phy-handle = <&phy1>;
+			sleep = <&pmc 00000040>;
+		};
+
+		ethernet@26000 {
+			device_type = "network";
+			model = "FEC";
+			compatible = "gianfar";
+			reg = <0x26000 0x1000>;
+			local-mac-address = [ 00 E0 0C 00 73 02 ];
+			interrupts = <41 2>;
+			phy-handle = <&phy3>;
+			sleep = <&pmc 00000020>;
+		};
+
+		serial@4500 {
+			#address-cells = <1>;
+			#size-cells = <1>;
+			compatible = "fsl,mpc8540-duart", "simple-bus";
+			sleep = <&pmc 00000002>;
+			ranges;
+
+			serial@4500 {
+				device_type = "serial";
+				compatible = "ns16550";
+				reg = <0x4500 0x100>;
+				clock-frequency = <0>;
+				interrupts = <42 2>;
+			};
+
+			serial@4600 {
+				device_type = "serial";
+				compatible = "ns16550";
+				reg = <0x4600 0x100>;
+				clock-frequency = <0>;
+				interrupts = <42 2>;
+			};
+		};
+
+		pic: pic@40000 {
+			interrupt-controller;
+			#address-cells = <0>;
+			#interrupt-cells = <2>;
+			reg = <0x40000 0x40000>;
+			compatible = "chrp,open-pic";
+			device_type = "open-pic";
+		};
+
+		i2c@3000 {
+			interrupts = <43 2>;
+			reg = <0x3000 0x100>;
+			compatible  = "fsl-i2c";
+			dfsrr;
+			sleep = <&pmc 00000004>;
+		};
+
+		pmc: power@e0070 {
+			compatible = "fsl,mpc8540-pmc", "fsl,mpc8548-pmc";
+			reg = <0xe0070 0x20>;
+		};
+	};
diff --git a/Documentation/powerpc/booting-without-of.txt b/Documentation/powerpc/booting-without-of.txt
deleted file mode 100644
index 7400d75..0000000
--- a/Documentation/powerpc/booting-without-of.txt
+++ /dev/null
@@ -1,1447 +0,0 @@
-           Booting the Linux/ppc kernel without Open Firmware
-           --------------------------------------------------
-
-(c) 2005 Benjamin Herrenschmidt <benh at kernel.crashing.org>,
-    IBM Corp.
-(c) 2005 Becky Bruce <becky.bruce at freescale.com>,
-    Freescale Semiconductor, FSL SOC and 32-bit additions
-(c) 2006 MontaVista Software, Inc.
-    Flash chip node definition
-
-Table of Contents
-=================
-
-  I - Introduction
-    1) Entry point for arch/powerpc
-    2) Board support
-
-  II - The DT block format
-    1) Header
-    2) Device tree generalities
-    3) Device tree "structure" block
-    4) Device tree "strings" block
-
-  III - Required content of the device tree
-    1) Note about cells and address representation
-    2) Note about "compatible" properties
-    3) Note about "name" properties
-    4) Note about node and property names and character set
-    5) Required nodes and properties
-      a) The root node
-      b) The /cpus node
-      c) The /cpus/* nodes
-      d) the /memory node(s)
-      e) The /chosen node
-      f) the /soc<SOCname> node
-
-  IV - "dtc", the device tree compiler
-
-  V - Recommendations for a bootloader
-
-  VI - System-on-a-chip devices and nodes
-    1) Defining child nodes of an SOC
-    2) Representing devices without a current OF specification
-      a) PHY nodes
-      b) Interrupt controllers
-      c) 4xx/Axon EMAC ethernet nodes
-      d) Xilinx IP cores
-      e) USB EHCI controllers
-      f) MDIO on GPIOs
-      g) SPI busses
-
-  VII - Specifying interrupt information for devices
-    1) interrupts property
-    2) interrupt-parent property
-    3) OpenPIC Interrupt Controllers
-    4) ISA Interrupt Controllers
-
-  VIII - Specifying device power management information (sleep property)
-
-  Appendix A - Sample SOC node for MPC8540
-
-
-Revision Information
-====================
-
-   May 18, 2005: Rev 0.1 - Initial draft, no chapter III yet.
-
-   May 19, 2005: Rev 0.2 - Add chapter III and bits & pieces here or
-                           clarifies the fact that a lot of things are
-                           optional, the kernel only requires a very
-                           small device tree, though it is encouraged
-                           to provide an as complete one as possible.
-
-   May 24, 2005: Rev 0.3 - Precise that DT block has to be in RAM
-			 - Misc fixes
-			 - Define version 3 and new format version 16
-			   for the DT block (version 16 needs kernel
-			   patches, will be fwd separately).
-			   String block now has a size, and full path
-			   is replaced by unit name for more
-			   compactness.
-			   linux,phandle is made optional, only nodes
-			   that are referenced by other nodes need it.
-			   "name" property is now automatically
-			   deduced from the unit name
-
-   June 1, 2005: Rev 0.4 - Correct confusion between OF_DT_END and
-                           OF_DT_END_NODE in structure definition.
-                         - Change version 16 format to always align
-                           property data to 4 bytes. Since tokens are
-                           already aligned, that means no specific
-                           required alignment between property size
-                           and property data. The old style variable
-                           alignment would make it impossible to do
-                           "simple" insertion of properties using
-                           memmove (thanks Milton for
-                           noticing). Updated kernel patch as well
-			 - Correct a few more alignment constraints
-			 - Add a chapter about the device-tree
-                           compiler and the textural representation of
-                           the tree that can be "compiled" by dtc.
-
-   November 21, 2005: Rev 0.5
-			 - Additions/generalizations for 32-bit
-			 - Changed to reflect the new arch/powerpc
-			   structure
-			 - Added chapter VI
-
-
- ToDo:
-	- Add some definitions of interrupt tree (simple/complex)
-	- Add some definitions for PCI host bridges
-	- Add some common address format examples
-	- Add definitions for standard properties and "compatible"
-	  names for cells that are not already defined by the existing
-	  OF spec.
-	- Compare FSL SOC use of PCI to standard and make sure no new
-	  node definition required.
-	- Add more information about node definitions for SOC devices
-  	  that currently have no standard, like the FSL CPM.
-
-
-I - Introduction
-================
-
-During the recent development of the Linux/ppc64 kernel, and more
-specifically, the addition of new platform types outside of the old
-IBM pSeries/iSeries pair, it was decided to enforce some strict rules
-regarding the kernel entry and bootloader <-> kernel interfaces, in
-order to avoid the degeneration that had become the ppc32 kernel entry
-point and the way a new platform should be added to the kernel. The
-legacy iSeries platform breaks those rules as it predates this scheme,
-but no new board support will be accepted in the main tree that
-doesn't follow them properly.  In addition, since the advent of the
-arch/powerpc merged architecture for ppc32 and ppc64, new 32-bit
-platforms and 32-bit platforms which move into arch/powerpc will be
-required to use these rules as well.
-
-The main requirement that will be defined in more detail below is
-the presence of a device-tree whose format is defined after Open
-Firmware specification. However, in order to make life easier
-to embedded board vendors, the kernel doesn't require the device-tree
-to represent every device in the system and only requires some nodes
-and properties to be present. This will be described in detail in
-section III, but, for example, the kernel does not require you to
-create a node for every PCI device in the system. It is a requirement
-to have a node for PCI host bridges in order to provide interrupt
-routing informations and memory/IO ranges, among others. It is also
-recommended to define nodes for on chip devices and other busses that
-don't specifically fit in an existing OF specification. This creates a
-great flexibility in the way the kernel can then probe those and match
-drivers to device, without having to hard code all sorts of tables. It
-also makes it more flexible for board vendors to do minor hardware
-upgrades without significantly impacting the kernel code or cluttering
-it with special cases.
-
-
-1) Entry point for arch/powerpc
--------------------------------
-
-   There is one and one single entry point to the kernel, at the start
-   of the kernel image. That entry point supports two calling
-   conventions:
-
-        a) Boot from Open Firmware. If your firmware is compatible
-        with Open Firmware (IEEE 1275) or provides an OF compatible
-        client interface API (support for "interpret" callback of
-        forth words isn't required), you can enter the kernel with:
-
-              r5 : OF callback pointer as defined by IEEE 1275
-              bindings to powerpc. Only the 32-bit client interface
-              is currently supported
-
-              r3, r4 : address & length of an initrd if any or 0
-
-              The MMU is either on or off; the kernel will run the
-              trampoline located in arch/powerpc/kernel/prom_init.c to
-              extract the device-tree and other information from open
-              firmware and build a flattened device-tree as described
-              in b). prom_init() will then re-enter the kernel using
-              the second method. This trampoline code runs in the
-              context of the firmware, which is supposed to handle all
-              exceptions during that time.
-
-        b) Direct entry with a flattened device-tree block. This entry
-        point is called by a) after the OF trampoline and can also be
-        called directly by a bootloader that does not support the Open
-        Firmware client interface. It is also used by "kexec" to
-        implement "hot" booting of a new kernel from a previous
-        running one. This method is what I will describe in more
-        details in this document, as method a) is simply standard Open
-        Firmware, and thus should be implemented according to the
-        various standard documents defining it and its binding to the
-        PowerPC platform. The entry point definition then becomes:
-
-                r3 : physical pointer to the device-tree block
-                (defined in chapter II) in RAM
-
-                r4 : physical pointer to the kernel itself. This is
-                used by the assembly code to properly disable the MMU
-                in case you are entering the kernel with MMU enabled
-                and a non-1:1 mapping.
-
-                r5 : NULL (as to differentiate with method a)
-
-        Note about SMP entry: Either your firmware puts your other
-        CPUs in some sleep loop or spin loop in ROM where you can get
-        them out via a soft reset or some other means, in which case
-        you don't need to care, or you'll have to enter the kernel
-        with all CPUs. The way to do that with method b) will be
-        described in a later revision of this document.
-
-
-2) Board support
-----------------
-
-64-bit kernels:
-
-   Board supports (platforms) are not exclusive config options. An
-   arbitrary set of board supports can be built in a single kernel
-   image. The kernel will "know" what set of functions to use for a
-   given platform based on the content of the device-tree. Thus, you
-   should:
-
-        a) add your platform support as a _boolean_ option in
-        arch/powerpc/Kconfig, following the example of PPC_PSERIES,
-        PPC_PMAC and PPC_MAPLE. The later is probably a good
-        example of a board support to start from.
-
-        b) create your main platform file as
-        "arch/powerpc/platforms/myplatform/myboard_setup.c" and add it
-        to the Makefile under the condition of your CONFIG_
-        option. This file will define a structure of type "ppc_md"
-        containing the various callbacks that the generic code will
-        use to get to your platform specific code
-
-        c) Add a reference to your "ppc_md" structure in the
-        "machines" table in arch/powerpc/kernel/setup_64.c if you are
-        a 64-bit platform.
-
-        d) request and get assigned a platform number (see PLATFORM_*
-        constants in arch/powerpc/include/asm/processor.h
-
-32-bit embedded kernels:
-
-  Currently, board support is essentially an exclusive config option.
-  The kernel is configured for a single platform.  Part of the reason
-  for this is to keep kernels on embedded systems small and efficient;
-  part of this is due to the fact the code is already that way. In the
-  future, a kernel may support multiple platforms, but only if the
-  platforms feature the same core architecture.  A single kernel build
-  cannot support both configurations with Book E and configurations
-  with classic Powerpc architectures.
-
-  32-bit embedded platforms that are moved into arch/powerpc using a
-  flattened device tree should adopt the merged tree practice of
-  setting ppc_md up dynamically, even though the kernel is currently
-  built with support for only a single platform at a time.  This allows
-  unification of the setup code, and will make it easier to go to a
-  multiple-platform-support model in the future.
-
-NOTE: I believe the above will be true once Ben's done with the merge
-of the boot sequences.... someone speak up if this is wrong!
-
-  To add a 32-bit embedded platform support, follow the instructions
-  for 64-bit platforms above, with the exception that the Kconfig
-  option should be set up such that the kernel builds exclusively for
-  the platform selected.  The processor type for the platform should
-  enable another config option to select the specific board
-  supported.
-
-NOTE: If Ben doesn't merge the setup files, may need to change this to
-point to setup_32.c
-
-
-   I will describe later the boot process and various callbacks that
-   your platform should implement.
-
-
-II - The DT block format
-========================
-
-
-This chapter defines the actual format of the flattened device-tree
-passed to the kernel. The actual content of it and kernel requirements
-are described later. You can find example of code manipulating that
-format in various places, including arch/powerpc/kernel/prom_init.c
-which will generate a flattened device-tree from the Open Firmware
-representation, or the fs2dt utility which is part of the kexec tools
-which will generate one from a filesystem representation. It is
-expected that a bootloader like uboot provides a bit more support,
-that will be discussed later as well.
-
-Note: The block has to be in main memory. It has to be accessible in
-both real mode and virtual mode with no mapping other than main
-memory. If you are writing a simple flash bootloader, it should copy
-the block to RAM before passing it to the kernel.
-
-
-1) Header
----------
-
-   The kernel is entered with r3 pointing to an area of memory that is
-   roughly described in arch/powerpc/include/asm/prom.h by the structure
-   boot_param_header:
-
-struct boot_param_header {
-        u32     magic;                  /* magic word OF_DT_HEADER */
-        u32     totalsize;              /* total size of DT block */
-        u32     off_dt_struct;          /* offset to structure */
-        u32     off_dt_strings;         /* offset to strings */
-        u32     off_mem_rsvmap;         /* offset to memory reserve map
-                                           */
-        u32     version;                /* format version */
-        u32     last_comp_version;      /* last compatible version */
-
-        /* version 2 fields below */
-        u32     boot_cpuid_phys;        /* Which physical CPU id we're
-                                           booting on */
-        /* version 3 fields below */
-        u32     size_dt_strings;        /* size of the strings block */
-
-        /* version 17 fields below */
-        u32	size_dt_struct;		/* size of the DT structure block */
-};
-
-   Along with the constants:
-
-/* Definitions used by the flattened device tree */
-#define OF_DT_HEADER            0xd00dfeed      /* 4: version,
-						   4: total size */
-#define OF_DT_BEGIN_NODE        0x1             /* Start node: full name
-						   */
-#define OF_DT_END_NODE          0x2             /* End node */
-#define OF_DT_PROP              0x3             /* Property: name off,
-                                                   size, content */
-#define OF_DT_END               0x9
-
-   All values in this header are in big endian format, the various
-   fields in this header are defined more precisely below. All
-   "offset" values are in bytes from the start of the header; that is
-   from the value of r3.
-
-   - magic
-
-     This is a magic value that "marks" the beginning of the
-     device-tree block header. It contains the value 0xd00dfeed and is
-     defined by the constant OF_DT_HEADER
-
-   - totalsize
-
-     This is the total size of the DT block including the header. The
-     "DT" block should enclose all data structures defined in this
-     chapter (who are pointed to by offsets in this header). That is,
-     the device-tree structure, strings, and the memory reserve map.
-
-   - off_dt_struct
-
-     This is an offset from the beginning of the header to the start
-     of the "structure" part the device tree. (see 2) device tree)
-
-   - off_dt_strings
-
-     This is an offset from the beginning of the header to the start
-     of the "strings" part of the device-tree
-
-   - off_mem_rsvmap
-
-     This is an offset from the beginning of the header to the start
-     of the reserved memory map. This map is a list of pairs of 64-
-     bit integers. Each pair is a physical address and a size. The
-     list is terminated by an entry of size 0. This map provides the
-     kernel with a list of physical memory areas that are "reserved"
-     and thus not to be used for memory allocations, especially during
-     early initialization. The kernel needs to allocate memory during
-     boot for things like un-flattening the device-tree, allocating an
-     MMU hash table, etc... Those allocations must be done in such a
-     way to avoid overriding critical things like, on Open Firmware
-     capable machines, the RTAS instance, or on some pSeries, the TCE
-     tables used for the iommu. Typically, the reserve map should
-     contain _at least_ this DT block itself (header,total_size). If
-     you are passing an initrd to the kernel, you should reserve it as
-     well. You do not need to reserve the kernel image itself. The map
-     should be 64-bit aligned.
-
-   - version
-
-     This is the version of this structure. Version 1 stops
-     here. Version 2 adds an additional field boot_cpuid_phys.
-     Version 3 adds the size of the strings block, allowing the kernel
-     to reallocate it easily at boot and free up the unused flattened
-     structure after expansion. Version 16 introduces a new more
-     "compact" format for the tree itself that is however not backward
-     compatible. Version 17 adds an additional field, size_dt_struct,
-     allowing it to be reallocated or moved more easily (this is
-     particularly useful for bootloaders which need to make
-     adjustments to a device tree based on probed information). You
-     should always generate a structure of the highest version defined
-     at the time of your implementation. Currently that is version 17,
-     unless you explicitly aim at being backward compatible.
-
-   - last_comp_version
-
-     Last compatible version. This indicates down to what version of
-     the DT block you are backward compatible. For example, version 2
-     is backward compatible with version 1 (that is, a kernel build
-     for version 1 will be able to boot with a version 2 format). You
-     should put a 1 in this field if you generate a device tree of
-     version 1 to 3, or 16 if you generate a tree of version 16 or 17
-     using the new unit name format.
-
-   - boot_cpuid_phys
-
-     This field only exist on version 2 headers. It indicate which
-     physical CPU ID is calling the kernel entry point. This is used,
-     among others, by kexec. If you are on an SMP system, this value
-     should match the content of the "reg" property of the CPU node in
-     the device-tree corresponding to the CPU calling the kernel entry
-     point (see further chapters for more informations on the required
-     device-tree contents)
-
-   - size_dt_strings
-
-     This field only exists on version 3 and later headers.  It
-     gives the size of the "strings" section of the device tree (which
-     starts at the offset given by off_dt_strings).
-
-   - size_dt_struct
-
-     This field only exists on version 17 and later headers.  It gives
-     the size of the "structure" section of the device tree (which
-     starts at the offset given by off_dt_struct).
-
-   So the typical layout of a DT block (though the various parts don't
-   need to be in that order) looks like this (addresses go from top to
-   bottom):
-
-
-             ------------------------------
-       r3 -> |  struct boot_param_header  |
-             ------------------------------
-             |      (alignment gap) (*)   |
-             ------------------------------
-             |      memory reserve map    |
-             ------------------------------
-             |      (alignment gap)       |
-             ------------------------------
-             |                            |
-             |    device-tree structure   |
-             |                            |
-             ------------------------------
-             |      (alignment gap)       |
-             ------------------------------
-             |                            |
-             |     device-tree strings    |
-             |                            |
-      -----> ------------------------------
-      |
-      |
-      --- (r3 + totalsize)
-
-  (*) The alignment gaps are not necessarily present; their presence
-      and size are dependent on the various alignment requirements of
-      the individual data blocks.
-
-
-2) Device tree generalities
----------------------------
-
-This device-tree itself is separated in two different blocks, a
-structure block and a strings block. Both need to be aligned to a 4
-byte boundary.
-
-First, let's quickly describe the device-tree concept before detailing
-the storage format. This chapter does _not_ describe the detail of the
-required types of nodes & properties for the kernel, this is done
-later in chapter III.
-
-The device-tree layout is strongly inherited from the definition of
-the Open Firmware IEEE 1275 device-tree. It's basically a tree of
-nodes, each node having two or more named properties. A property can
-have a value or not.
-
-It is a tree, so each node has one and only one parent except for the
-root node who has no parent.
-
-A node has 2 names. The actual node name is generally contained in a
-property of type "name" in the node property list whose value is a
-zero terminated string and is mandatory for version 1 to 3 of the
-format definition (as it is in Open Firmware). Version 16 makes it
-optional as it can generate it from the unit name defined below.
-
-There is also a "unit name" that is used to differentiate nodes with
-the same name at the same level, it is usually made of the node
-names, the "@" sign, and a "unit address", which definition is
-specific to the bus type the node sits on.
-
-The unit name doesn't exist as a property per-se but is included in
-the device-tree structure. It is typically used to represent "path" in
-the device-tree. More details about the actual format of these will be
-below.
-
-The kernel powerpc generic code does not make any formal use of the
-unit address (though some board support code may do) so the only real
-requirement here for the unit address is to ensure uniqueness of
-the node unit name at a given level of the tree. Nodes with no notion
-of address and no possible sibling of the same name (like /memory or
-/cpus) may omit the unit address in the context of this specification,
-or use the "@0" default unit address. The unit name is used to define
-a node "full path", which is the concatenation of all parent node
-unit names separated with "/".
-
-The root node doesn't have a defined name, and isn't required to have
-a name property either if you are using version 3 or earlier of the
-format. It also has no unit address (no @ symbol followed by a unit
-address). The root node unit name is thus an empty string. The full
-path to the root node is "/".
-
-Every node which actually represents an actual device (that is, a node
-which isn't only a virtual "container" for more nodes, like "/cpus"
-is) is also required to have a "device_type" property indicating the
-type of node .
-
-Finally, every node that can be referenced from a property in another
-node is required to have a "linux,phandle" property. Real open
-firmware implementations provide a unique "phandle" value for every
-node that the "prom_init()" trampoline code turns into
-"linux,phandle" properties. However, this is made optional if the
-flattened device tree is used directly. An example of a node
-referencing another node via "phandle" is when laying out the
-interrupt tree which will be described in a further version of this
-document.
-
-This "linux, phandle" property is a 32-bit value that uniquely
-identifies a node. You are free to use whatever values or system of
-values, internal pointers, or whatever to generate these, the only
-requirement is that every node for which you provide that property has
-a unique value for it.
-
-Here is an example of a simple device-tree. In this example, an "o"
-designates a node followed by the node unit name. Properties are
-presented with their name followed by their content. "content"
-represents an ASCII string (zero terminated) value, while <content>
-represents a 32-bit hexadecimal value. The various nodes in this
-example will be discussed in a later chapter. At this point, it is
-only meant to give you a idea of what a device-tree looks like. I have
-purposefully kept the "name" and "linux,phandle" properties which
-aren't necessary in order to give you a better idea of what the tree
-looks like in practice.
-
-  / o device-tree
-      |- name = "device-tree"
-      |- model = "MyBoardName"
-      |- compatible = "MyBoardFamilyName"
-      |- #address-cells = <2>
-      |- #size-cells = <2>
-      |- linux,phandle = <0>
-      |
-      o cpus
-      | | - name = "cpus"
-      | | - linux,phandle = <1>
-      | | - #address-cells = <1>
-      | | - #size-cells = <0>
-      | |
-      | o PowerPC,970@0
-      |   |- name = "PowerPC,970"
-      |   |- device_type = "cpu"
-      |   |- reg = <0>
-      |   |- clock-frequency = <5f5e1000>
-      |   |- 64-bit
-      |   |- linux,phandle = <2>
-      |
-      o memory@0
-      | |- name = "memory"
-      | |- device_type = "memory"
-      | |- reg = <00000000 00000000 00000000 20000000>
-      | |- linux,phandle = <3>
-      |
-      o chosen
-        |- name = "chosen"
-        |- bootargs = "root=/dev/sda2"
-        |- linux,phandle = <4>
-
-This tree is almost a minimal tree. It pretty much contains the
-minimal set of required nodes and properties to boot a linux kernel;
-that is, some basic model informations at the root, the CPUs, and the
-physical memory layout.  It also includes misc information passed
-through /chosen, like in this example, the platform type (mandatory)
-and the kernel command line arguments (optional).
-
-The /cpus/PowerPC,970@0/64-bit property is an example of a
-property without a value. All other properties have a value. The
-significance of the #address-cells and #size-cells properties will be
-explained in chapter IV which defines precisely the required nodes and
-properties and their content.
-
-
-3) Device tree "structure" block
-
-The structure of the device tree is a linearized tree structure. The
-"OF_DT_BEGIN_NODE" token starts a new node, and the "OF_DT_END_NODE"
-ends that node definition. Child nodes are simply defined before
-"OF_DT_END_NODE" (that is nodes within the node). A 'token' is a 32
-bit value. The tree has to be "finished" with a OF_DT_END token
-
-Here's the basic structure of a single node:
-
-     * token OF_DT_BEGIN_NODE (that is 0x00000001)
-     * for version 1 to 3, this is the node full path as a zero
-       terminated string, starting with "/". For version 16 and later,
-       this is the node unit name only (or an empty string for the
-       root node)
-     * [align gap to next 4 bytes boundary]
-     * for each property:
-        * token OF_DT_PROP (that is 0x00000003)
-        * 32-bit value of property value size in bytes (or 0 if no
-          value)
-        * 32-bit value of offset in string block of property name
-        * property value data if any
-        * [align gap to next 4 bytes boundary]
-     * [child nodes if any]
-     * token OF_DT_END_NODE (that is 0x00000002)
-
-So the node content can be summarized as a start token, a full path,
-a list of properties, a list of child nodes, and an end token. Every
-child node is a full node structure itself as defined above.
-
-NOTE: The above definition requires that all property definitions for
-a particular node MUST precede any subnode definitions for that node.
-Although the structure would not be ambiguous if properties and
-subnodes were intermingled, the kernel parser requires that the
-properties come first (up until at least 2.6.22).  Any tools
-manipulating a flattened tree must take care to preserve this
-constraint.
-
-4) Device tree "strings" block
-
-In order to save space, property names, which are generally redundant,
-are stored separately in the "strings" block. This block is simply the
-whole bunch of zero terminated strings for all property names
-concatenated together. The device-tree property definitions in the
-structure block will contain offset values from the beginning of the
-strings block.
-
-
-III - Required content of the device tree
-=========================================
-
-WARNING: All "linux,*" properties defined in this document apply only
-to a flattened device-tree. If your platform uses a real
-implementation of Open Firmware or an implementation compatible with
-the Open Firmware client interface, those properties will be created
-by the trampoline code in the kernel's prom_init() file. For example,
-that's where you'll have to add code to detect your board model and
-set the platform number. However, when using the flattened device-tree
-entry point, there is no prom_init() pass, and thus you have to
-provide those properties yourself.
-
-
-1) Note about cells and address representation
-----------------------------------------------
-
-The general rule is documented in the various Open Firmware
-documentations. If you choose to describe a bus with the device-tree
-and there exist an OF bus binding, then you should follow the
-specification. However, the kernel does not require every single
-device or bus to be described by the device tree.
-
-In general, the format of an address for a device is defined by the
-parent bus type, based on the #address-cells and #size-cells
-properties.  Note that the parent's parent definitions of #address-cells
-and #size-cells are not inherited so every node with children must specify
-them.  The kernel requires the root node to have those properties defining
-addresses format for devices directly mapped on the processor bus.
-
-Those 2 properties define 'cells' for representing an address and a
-size. A "cell" is a 32-bit number. For example, if both contain 2
-like the example tree given above, then an address and a size are both
-composed of 2 cells, and each is a 64-bit number (cells are
-concatenated and expected to be in big endian format). Another example
-is the way Apple firmware defines them, with 2 cells for an address
-and one cell for a size.  Most 32-bit implementations should define
-#address-cells and #size-cells to 1, which represents a 32-bit value.
-Some 32-bit processors allow for physical addresses greater than 32
-bits; these processors should define #address-cells as 2.
-
-"reg" properties are always a tuple of the type "address size" where
-the number of cells of address and size is specified by the bus
-#address-cells and #size-cells. When a bus supports various address
-spaces and other flags relative to a given address allocation (like
-prefetchable, etc...) those flags are usually added to the top level
-bits of the physical address. For example, a PCI physical address is
-made of 3 cells, the bottom two containing the actual address itself
-while the top cell contains address space indication, flags, and pci
-bus & device numbers.
-
-For busses that support dynamic allocation, it's the accepted practice
-to then not provide the address in "reg" (keep it 0) though while
-providing a flag indicating the address is dynamically allocated, and
-then, to provide a separate "assigned-addresses" property that
-contains the fully allocated addresses. See the PCI OF bindings for
-details.
-
-In general, a simple bus with no address space bits and no dynamic
-allocation is preferred if it reflects your hardware, as the existing
-kernel address parsing functions will work out of the box. If you
-define a bus type with a more complex address format, including things
-like address space bits, you'll have to add a bus translator to the
-prom_parse.c file of the recent kernels for your bus type.
-
-The "reg" property only defines addresses and sizes (if #size-cells is
-non-0) within a given bus. In order to translate addresses upward
-(that is into parent bus addresses, and possibly into CPU physical
-addresses), all busses must contain a "ranges" property. If the
-"ranges" property is missing at a given level, it's assumed that
-translation isn't possible, i.e., the registers are not visible on the
-parent bus.  The format of the "ranges" property for a bus is a list
-of:
-
-	bus address, parent bus address, size
-
-"bus address" is in the format of the bus this bus node is defining,
-that is, for a PCI bridge, it would be a PCI address. Thus, (bus
-address, size) defines a range of addresses for child devices. "parent
-bus address" is in the format of the parent bus of this bus. For
-example, for a PCI host controller, that would be a CPU address. For a
-PCI<->ISA bridge, that would be a PCI address. It defines the base
-address in the parent bus where the beginning of that range is mapped.
-
-For a new 64-bit powerpc board, I recommend either the 2/2 format or
-Apple's 2/1 format which is slightly more compact since sizes usually
-fit in a single 32-bit word.   New 32-bit powerpc boards should use a
-1/1 format, unless the processor supports physical addresses greater
-than 32-bits, in which case a 2/1 format is recommended.
-
-Alternatively, the "ranges" property may be empty, indicating that the
-registers are visible on the parent bus using an identity mapping
-translation.  In other words, the parent bus address space is the same
-as the child bus address space.
-
-2) Note about "compatible" properties
--------------------------------------
-
-These properties are optional, but recommended in devices and the root
-node. The format of a "compatible" property is a list of concatenated
-zero terminated strings. They allow a device to express its
-compatibility with a family of similar devices, in some cases,
-allowing a single driver to match against several devices regardless
-of their actual names.
-
-3) Note about "name" properties
--------------------------------
-
-While earlier users of Open Firmware like OldWorld macintoshes tended
-to use the actual device name for the "name" property, it's nowadays
-considered a good practice to use a name that is closer to the device
-class (often equal to device_type). For example, nowadays, ethernet
-controllers are named "ethernet", an additional "model" property
-defining precisely the chip type/model, and "compatible" property
-defining the family in case a single driver can driver more than one
-of these chips. However, the kernel doesn't generally put any
-restriction on the "name" property; it is simply considered good
-practice to follow the standard and its evolutions as closely as
-possible.
-
-Note also that the new format version 16 makes the "name" property
-optional. If it's absent for a node, then the node's unit name is then
-used to reconstruct the name. That is, the part of the unit name
-before the "@" sign is used (or the entire unit name if no "@" sign
-is present).
-
-4) Note about node and property names and character set
--------------------------------------------------------
-
-While open firmware provides more flexible usage of 8859-1, this
-specification enforces more strict rules. Nodes and properties should
-be comprised only of ASCII characters 'a' to 'z', '0' to
-'9', ',', '.', '_', '+', '#', '?', and '-'. Node names additionally
-allow uppercase characters 'A' to 'Z' (property names should be
-lowercase. The fact that vendors like Apple don't respect this rule is
-irrelevant here). Additionally, node and property names should always
-begin with a character in the range 'a' to 'z' (or 'A' to 'Z' for node
-names).
-
-The maximum number of characters for both nodes and property names
-is 31. In the case of node names, this is only the leftmost part of
-a unit name (the pure "name" property), it doesn't include the unit
-address which can extend beyond that limit.
-
-
-5) Required nodes and properties
---------------------------------
-  These are all that are currently required. However, it is strongly
-  recommended that you expose PCI host bridges as documented in the
-  PCI binding to open firmware, and your interrupt tree as documented
-  in OF interrupt tree specification.
-
-  a) The root node
-
-  The root node requires some properties to be present:
-
-    - model : this is your board name/model
-    - #address-cells : address representation for "root" devices
-    - #size-cells: the size representation for "root" devices
-    - device_type : This property shouldn't be necessary. However, if
-      you decide to create a device_type for your root node, make sure it
-      is _not_ "chrp" unless your platform is a pSeries or PAPR compliant
-      one for 64-bit, or a CHRP-type machine for 32-bit as this will
-      matched by the kernel this way.
-
-  Additionally, some recommended properties are:
-
-    - compatible : the board "family" generally finds its way here,
-      for example, if you have 2 board models with a similar layout,
-      that typically get driven by the same platform code in the
-      kernel, you would use a different "model" property but put a
-      value in "compatible". The kernel doesn't directly use that
-      value but it is generally useful.
-
-  The root node is also generally where you add additional properties
-  specific to your board like the serial number if any, that sort of
-  thing. It is recommended that if you add any "custom" property whose
-  name may clash with standard defined ones, you prefix them with your
-  vendor name and a comma.
-
-  b) The /cpus node
-
-  This node is the parent of all individual CPU nodes. It doesn't
-  have any specific requirements, though it's generally good practice
-  to have at least:
-
-               #address-cells = <00000001>
-               #size-cells    = <00000000>
-
-  This defines that the "address" for a CPU is a single cell, and has
-  no meaningful size. This is not necessary but the kernel will assume
-  that format when reading the "reg" properties of a CPU node, see
-  below
-
-  c) The /cpus/* nodes
-
-  So under /cpus, you are supposed to create a node for every CPU on
-  the machine. There is no specific restriction on the name of the
-  CPU, though It's common practice to call it PowerPC,<name>. For
-  example, Apple uses PowerPC,G5 while IBM uses PowerPC,970FX.
-
-  Required properties:
-
-    - device_type : has to be "cpu"
-    - reg : This is the physical CPU number, it's a single 32-bit cell
-      and is also used as-is as the unit number for constructing the
-      unit name in the full path. For example, with 2 CPUs, you would
-      have the full path:
-        /cpus/PowerPC,970FX@0
-        /cpus/PowerPC,970FX@1
-      (unit addresses do not require leading zeroes)
-    - d-cache-block-size : one cell, L1 data cache block size in bytes (*)
-    - i-cache-block-size : one cell, L1 instruction cache block size in
-      bytes
-    - d-cache-size : one cell, size of L1 data cache in bytes
-    - i-cache-size : one cell, size of L1 instruction cache in bytes
-
-(*) The cache "block" size is the size on which the cache management
-instructions operate. Historically, this document used the cache
-"line" size here which is incorrect. The kernel will prefer the cache
-block size and will fallback to cache line size for backward
-compatibility.
-
-  Recommended properties:
-
-    - timebase-frequency : a cell indicating the frequency of the
-      timebase in Hz. This is not directly used by the generic code,
-      but you are welcome to copy/paste the pSeries code for setting
-      the kernel timebase/decrementer calibration based on this
-      value.
-    - clock-frequency : a cell indicating the CPU core clock frequency
-      in Hz. A new property will be defined for 64-bit values, but if
-      your frequency is < 4Ghz, one cell is enough. Here as well as
-      for the above, the common code doesn't use that property, but
-      you are welcome to re-use the pSeries or Maple one. A future
-      kernel version might provide a common function for this.
-    - d-cache-line-size : one cell, L1 data cache line size in bytes
-      if different from the block size
-    - i-cache-line-size : one cell, L1 instruction cache line size in
-      bytes if different from the block size
-
-  You are welcome to add any property you find relevant to your board,
-  like some information about the mechanism used to soft-reset the
-  CPUs. For example, Apple puts the GPIO number for CPU soft reset
-  lines in there as a "soft-reset" property since they start secondary
-  CPUs by soft-resetting them.
-
-
-  d) the /memory node(s)
-
-  To define the physical memory layout of your board, you should
-  create one or more memory node(s). You can either create a single
-  node with all memory ranges in its reg property, or you can create
-  several nodes, as you wish. The unit address (@ part) used for the
-  full path is the address of the first range of memory defined by a
-  given node. If you use a single memory node, this will typically be
-  @0.
-
-  Required properties:
-
-    - device_type : has to be "memory"
-    - reg : This property contains all the physical memory ranges of
-      your board. It's a list of addresses/sizes concatenated
-      together, with the number of cells of each defined by the
-      #address-cells and #size-cells of the root node. For example,
-      with both of these properties being 2 like in the example given
-      earlier, a 970 based machine with 6Gb of RAM could typically
-      have a "reg" property here that looks like:
-
-      00000000 00000000 00000000 80000000
-      00000001 00000000 00000001 00000000
-
-      That is a range starting at 0 of 0x80000000 bytes and a range
-      starting at 0x100000000 and of 0x100000000 bytes. You can see
-      that there is no memory covering the IO hole between 2Gb and
-      4Gb. Some vendors prefer splitting those ranges into smaller
-      segments, but the kernel doesn't care.
-
-  e) The /chosen node
-
-  This node is a bit "special". Normally, that's where open firmware
-  puts some variable environment information, like the arguments, or
-  the default input/output devices.
-
-  This specification makes a few of these mandatory, but also defines
-  some linux-specific properties that would be normally constructed by
-  the prom_init() trampoline when booting with an OF client interface,
-  but that you have to provide yourself when using the flattened format.
-
-  Recommended properties:
-
-    - bootargs : This zero-terminated string is passed as the kernel
-      command line
-    - linux,stdout-path : This is the full path to your standard
-      console device if any. Typically, if you have serial devices on
-      your board, you may want to put the full path to the one set as
-      the default console in the firmware here, for the kernel to pick
-      it up as its own default console. If you look at the function
-      set_preferred_console() in arch/ppc64/kernel/setup.c, you'll see
-      that the kernel tries to find out the default console and has
-      knowledge of various types like 8250 serial ports. You may want
-      to extend this function to add your own.
-
-  Note that u-boot creates and fills in the chosen node for platforms
-  that use it.
-
-  (Note: a practice that is now obsolete was to include a property
-  under /chosen called interrupt-controller which had a phandle value
-  that pointed to the main interrupt controller)
-
-  f) the /soc<SOCname> node
-
-  This node is used to represent a system-on-a-chip (SOC) and must be
-  present if the processor is a SOC. The top-level soc node contains
-  information that is global to all devices on the SOC. The node name
-  should contain a unit address for the SOC, which is the base address
-  of the memory-mapped register set for the SOC. The name of an soc
-  node should start with "soc", and the remainder of the name should
-  represent the part number for the soc.  For example, the MPC8540's
-  soc node would be called "soc8540".
-
-  Required properties:
-
-    - device_type : Should be "soc"
-    - ranges : Should be defined as specified in 1) to describe the
-      translation of SOC addresses for memory mapped SOC registers.
-    - bus-frequency: Contains the bus frequency for the SOC node.
-      Typically, the value of this field is filled in by the boot
-      loader.
-
-
-  Recommended properties:
-
-    - reg : This property defines the address and size of the
-      memory-mapped registers that are used for the SOC node itself.
-      It does not include the child device registers - these will be
-      defined inside each child node.  The address specified in the
-      "reg" property should match the unit address of the SOC node.
-    - #address-cells : Address representation for "soc" devices.  The
-      format of this field may vary depending on whether or not the
-      device registers are memory mapped.  For memory mapped
-      registers, this field represents the number of cells needed to
-      represent the address of the registers.  For SOCs that do not
-      use MMIO, a special address format should be defined that
-      contains enough cells to represent the required information.
-      See 1) above for more details on defining #address-cells.
-    - #size-cells : Size representation for "soc" devices
-    - #interrupt-cells : Defines the width of cells used to represent
-       interrupts.  Typically this value is <2>, which includes a
-       32-bit number that represents the interrupt number, and a
-       32-bit number that represents the interrupt sense and level.
-       This field is only needed if the SOC contains an interrupt
-       controller.
-
-  The SOC node may contain child nodes for each SOC device that the
-  platform uses.  Nodes should not be created for devices which exist
-  on the SOC but are not used by a particular platform. See chapter VI
-  for more information on how to specify devices that are part of a SOC.
-
-  Example SOC node for the MPC8540:
-
-	soc8540@e0000000 {
-		#address-cells = <1>;
-		#size-cells = <1>;
-		#interrupt-cells = <2>;
-		device_type = "soc";
-		ranges = <00000000 e0000000 00100000>
-		reg = <e0000000 00003000>;
-		bus-frequency = <0>;
-	}
-
-
-
-IV - "dtc", the device tree compiler
-====================================
-
-
-dtc source code can be found at
-<http://git.jdl.com/gitweb/?p=dtc.git>
-
-WARNING: This version is still in early development stage; the
-resulting device-tree "blobs" have not yet been validated with the
-kernel. The current generated block lacks a useful reserve map (it will
-be fixed to generate an empty one, it's up to the bootloader to fill
-it up) among others. The error handling needs work, bugs are lurking,
-etc...
-
-dtc basically takes a device-tree in a given format and outputs a
-device-tree in another format. The currently supported formats are:
-
-  Input formats:
-  -------------
-
-     - "dtb": "blob" format, that is a flattened device-tree block
-       with
-        header all in a binary blob.
-     - "dts": "source" format. This is a text file containing a
-       "source" for a device-tree. The format is defined later in this
-        chapter.
-     - "fs" format. This is a representation equivalent to the
-        output of /proc/device-tree, that is nodes are directories and
-	properties are files
-
- Output formats:
- ---------------
-
-     - "dtb": "blob" format
-     - "dts": "source" format
-     - "asm": assembly language file. This is a file that can be
-       sourced by gas to generate a device-tree "blob". That file can
-       then simply be added to your Makefile. Additionally, the
-       assembly file exports some symbols that can be used.
-
-
-The syntax of the dtc tool is
-
-    dtc [-I <input-format>] [-O <output-format>]
-        [-o output-filename] [-V output_version] input_filename
-
-
-The "output_version" defines what version of the "blob" format will be
-generated. Supported versions are 1,2,3 and 16. The default is
-currently version 3 but that may change in the future to version 16.
-
-Additionally, dtc performs various sanity checks on the tree, like the
-uniqueness of linux, phandle properties, validity of strings, etc...
-
-The format of the .dts "source" file is "C" like, supports C and C++
-style comments.
-
-/ {
-}
-
-The above is the "device-tree" definition. It's the only statement
-supported currently at the toplevel.
-
-/ {
-  property1 = "string_value";	/* define a property containing a 0
-                                 * terminated string
-				 */
-
-  property2 = <1234abcd>;	/* define a property containing a
-                                 * numerical 32-bit value (hexadecimal)
-				 */
-
-  property3 = <12345678 12345678 deadbeef>;
-                                /* define a property containing 3
-                                 * numerical 32-bit values (cells) in
-                                 * hexadecimal
-				 */
-  property4 = [0a 0b 0c 0d de ea ad be ef];
-                                /* define a property whose content is
-                                 * an arbitrary array of bytes
-                                 */
-
-  childnode@address {	/* define a child node named "childnode"
-                                 * whose unit name is "childnode at
-				 * address"
-                                 */
-
-    childprop = "hello\n";      /* define a property "childprop" of
-                                 * childnode (in this case, a string)
-                                 */
-  };
-};
-
-Nodes can contain other nodes etc... thus defining the hierarchical
-structure of the tree.
-
-Strings support common escape sequences from C: "\n", "\t", "\r",
-"\(octal value)", "\x(hex value)".
-
-It is also suggested that you pipe your source file through cpp (gcc
-preprocessor) so you can use #include's, #define for constants, etc...
-
-Finally, various options are planned but not yet implemented, like
-automatic generation of phandles, labels (exported to the asm file so
-you can point to a property content and change it easily from whatever
-you link the device-tree with), label or path instead of numeric value
-in some cells to "point" to a node (replaced by a phandle at compile
-time), export of reserve map address to the asm file, ability to
-specify reserve map content at compile time, etc...
-
-We may provide a .h include file with common definitions of that
-proves useful for some properties (like building PCI properties or
-interrupt maps) though it may be better to add a notion of struct
-definitions to the compiler...
-
-
-V - Recommendations for a bootloader
-====================================
-
-
-Here are some various ideas/recommendations that have been proposed
-while all this has been defined and implemented.
-
-  - The bootloader may want to be able to use the device-tree itself
-    and may want to manipulate it (to add/edit some properties,
-    like physical memory size or kernel arguments). At this point, 2
-    choices can be made. Either the bootloader works directly on the
-    flattened format, or the bootloader has its own internal tree
-    representation with pointers (similar to the kernel one) and
-    re-flattens the tree when booting the kernel. The former is a bit
-    more difficult to edit/modify, the later requires probably a bit
-    more code to handle the tree structure. Note that the structure
-    format has been designed so it's relatively easy to "insert"
-    properties or nodes or delete them by just memmoving things
-    around. It contains no internal offsets or pointers for this
-    purpose.
-
-  - An example of code for iterating nodes & retrieving properties
-    directly from the flattened tree format can be found in the kernel
-    file arch/ppc64/kernel/prom.c, look at scan_flat_dt() function,
-    its usage in early_init_devtree(), and the corresponding various
-    early_init_dt_scan_*() callbacks. That code can be re-used in a
-    GPL bootloader, and as the author of that code, I would be happy
-    to discuss possible free licensing to any vendor who wishes to
-    integrate all or part of this code into a non-GPL bootloader.
-
-
-
-VI - System-on-a-chip devices and nodes
-=======================================
-
-Many companies are now starting to develop system-on-a-chip
-processors, where the processor core (CPU) and many peripheral devices
-exist on a single piece of silicon.  For these SOCs, an SOC node
-should be used that defines child nodes for the devices that make
-up the SOC. While platforms are not required to use this model in
-order to boot the kernel, it is highly encouraged that all SOC
-implementations define as complete a flat-device-tree as possible to
-describe the devices on the SOC.  This will allow for the
-genericization of much of the kernel code.
-
-
-1) Defining child nodes of an SOC
----------------------------------
-
-Each device that is part of an SOC may have its own node entry inside
-the SOC node.  For each device that is included in the SOC, the unit
-address property represents the address offset for this device's
-memory-mapped registers in the parent's address space.  The parent's
-address space is defined by the "ranges" property in the top-level soc
-node. The "reg" property for each node that exists directly under the
-SOC node should contain the address mapping from the child address space
-to the parent SOC address space and the size of the device's
-memory-mapped register file.
-
-For many devices that may exist inside an SOC, there are predefined
-specifications for the format of the device tree node.  All SOC child
-nodes should follow these specifications, except where noted in this
-document.
-
-See appendix A for an example partial SOC node definition for the
-MPC8540.
-
-
-2) Representing devices without a current OF specification
-----------------------------------------------------------
-
-Currently, there are many devices on SOCs that do not have a standard
-representation pre-defined as part of the open firmware
-specifications, mainly because the boards that contain these SOCs are
-not currently booted using open firmware.   This section contains
-descriptions for the SOC devices for which new nodes have been
-defined; this list will expand as more and more SOC-containing
-platforms are moved over to use the flattened-device-tree model.
-
-VII - Specifying interrupt information for devices
-===================================================
-
-The device tree represents the busses and devices of a hardware
-system in a form similar to the physical bus topology of the
-hardware.
-
-In addition, a logical 'interrupt tree' exists which represents the
-hierarchy and routing of interrupts in the hardware.
-
-The interrupt tree model is fully described in the
-document "Open Firmware Recommended Practice: Interrupt
-Mapping Version 0.9".  The document is available at:
-<http://playground.sun.com/1275/practice>.
-
-1) interrupts property
-----------------------
-
-Devices that generate interrupts to a single interrupt controller
-should use the conventional OF representation described in the
-OF interrupt mapping documentation.
-
-Each device which generates interrupts must have an 'interrupt'
-property.  The interrupt property value is an arbitrary number of
-of 'interrupt specifier' values which describe the interrupt or
-interrupts for the device.
-
-The encoding of an interrupt specifier is determined by the
-interrupt domain in which the device is located in the
-interrupt tree.  The root of an interrupt domain specifies in
-its #interrupt-cells property the number of 32-bit cells
-required to encode an interrupt specifier.  See the OF interrupt
-mapping documentation for a detailed description of domains.
-
-For example, the binding for the OpenPIC interrupt controller
-specifies  an #interrupt-cells value of 2 to encode the interrupt
-number and level/sense information. All interrupt children in an
-OpenPIC interrupt domain use 2 cells per interrupt in their interrupts
-property.
-
-The PCI bus binding specifies a #interrupt-cell value of 1 to encode
-which interrupt pin (INTA,INTB,INTC,INTD) is used.
-
-2) interrupt-parent property
-----------------------------
-
-The interrupt-parent property is specified to define an explicit
-link between a device node and its interrupt parent in
-the interrupt tree.  The value of interrupt-parent is the
-phandle of the parent node.
-
-If the interrupt-parent property is not defined for a node, its
-interrupt parent is assumed to be an ancestor in the node's
-_device tree_ hierarchy.
-
-3) OpenPIC Interrupt Controllers
---------------------------------
-
-OpenPIC interrupt controllers require 2 cells to encode
-interrupt information.  The first cell defines the interrupt
-number.  The second cell defines the sense and level
-information.
-
-Sense and level information should be encoded as follows:
-
-	0 = low to high edge sensitive type enabled
-	1 = active low level sensitive type enabled
-	2 = active high level sensitive type enabled
-	3 = high to low edge sensitive type enabled
-
-4) ISA Interrupt Controllers
-----------------------------
-
-ISA PIC interrupt controllers require 2 cells to encode
-interrupt information.  The first cell defines the interrupt
-number.  The second cell defines the sense and level
-information.
-
-ISA PIC interrupt controllers should adhere to the ISA PIC
-encodings listed below:
-
-	0 =  active low level sensitive type enabled
-	1 =  active high level sensitive type enabled
-	2 =  high to low edge sensitive type enabled
-	3 =  low to high edge sensitive type enabled
-
-VIII - Specifying Device Power Management Information (sleep property)
-===================================================================
-
-Devices on SOCs often have mechanisms for placing devices into low-power
-states that are decoupled from the devices' own register blocks.  Sometimes,
-this information is more complicated than a cell-index property can
-reasonably describe.  Thus, each device controlled in such a manner
-may contain a "sleep" property which describes these connections.
-
-The sleep property consists of one or more sleep resources, each of
-which consists of a phandle to a sleep controller, followed by a
-controller-specific sleep specifier of zero or more cells.
-
-The semantics of what type of low power modes are possible are defined
-by the sleep controller.  Some examples of the types of low power modes
-that may be supported are:
-
- - Dynamic: The device may be disabled or enabled at any time.
- - System Suspend: The device may request to be disabled or remain
-   awake during system suspend, but will not be disabled until then.
- - Permanent: The device is disabled permanently (until the next hard
-   reset).
-
-Some devices may share a clock domain with each other, such that they should
-only be suspended when none of the devices are in use.  Where reasonable,
-such nodes should be placed on a virtual bus, where the bus has the sleep
-property.  If the clock domain is shared among devices that cannot be
-reasonably grouped in this manner, then create a virtual sleep controller
-(similar to an interrupt nexus, except that defining a standardized
-sleep-map should wait until its necessity is demonstrated).
-
-Appendix A - Sample SOC node for MPC8540
-========================================
-
-	soc@e0000000 {
-		#address-cells = <1>;
-		#size-cells = <1>;
-		compatible = "fsl,mpc8540-ccsr", "simple-bus";
-		device_type = "soc";
-		ranges = <0x00000000 0xe0000000 0x00100000>
-		bus-frequency = <0>;
-		interrupt-parent = <&pic>;
-
-		ethernet@24000 {
-			#address-cells = <1>;
-			#size-cells = <1>;
-			device_type = "network";
-			model = "TSEC";
-			compatible = "gianfar", "simple-bus";
-			reg = <0x24000 0x1000>;
-			local-mac-address = [ 00 E0 0C 00 73 00 ];
-			interrupts = <29 2 30 2 34 2>;
-			phy-handle = <&phy0>;
-			sleep = <&pmc 00000080>;
-			ranges;
-
-			mdio@24520 {
-				reg = <0x24520 0x20>;
-				compatible = "fsl,gianfar-mdio";
-
-				phy0: ethernet-phy@0 {
-					interrupts = <5 1>;
-					reg = <0>;
-					device_type = "ethernet-phy";
-				};
-
-				phy1: ethernet-phy@1 {
-					interrupts = <5 1>;
-					reg = <1>;
-					device_type = "ethernet-phy";
-				};
-
-				phy3: ethernet-phy@3 {
-					interrupts = <7 1>;
-					reg = <3>;
-					device_type = "ethernet-phy";
-				};
-			};
-		};
-
-		ethernet@25000 {
-			device_type = "network";
-			model = "TSEC";
-			compatible = "gianfar";
-			reg = <0x25000 0x1000>;
-			local-mac-address = [ 00 E0 0C 00 73 01 ];
-			interrupts = <13 2 14 2 18 2>;
-			phy-handle = <&phy1>;
-			sleep = <&pmc 00000040>;
-		};
-
-		ethernet@26000 {
-			device_type = "network";
-			model = "FEC";
-			compatible = "gianfar";
-			reg = <0x26000 0x1000>;
-			local-mac-address = [ 00 E0 0C 00 73 02 ];
-			interrupts = <41 2>;
-			phy-handle = <&phy3>;
-			sleep = <&pmc 00000020>;
-		};
-
-		serial@4500 {
-			#address-cells = <1>;
-			#size-cells = <1>;
-			compatible = "fsl,mpc8540-duart", "simple-bus";
-			sleep = <&pmc 00000002>;
-			ranges;
-
-			serial@4500 {
-				device_type = "serial";
-				compatible = "ns16550";
-				reg = <0x4500 0x100>;
-				clock-frequency = <0>;
-				interrupts = <42 2>;
-			};
-
-			serial@4600 {
-				device_type = "serial";
-				compatible = "ns16550";
-				reg = <0x4600 0x100>;
-				clock-frequency = <0>;
-				interrupts = <42 2>;
-			};
-		};
-
-		pic: pic@40000 {
-			interrupt-controller;
-			#address-cells = <0>;
-			#interrupt-cells = <2>;
-			reg = <0x40000 0x40000>;
-			compatible = "chrp,open-pic";
-			device_type = "open-pic";
-		};
-
-		i2c@3000 {
-			interrupts = <43 2>;
-			reg = <0x3000 0x100>;
-			compatible  = "fsl-i2c";
-			dfsrr;
-			sleep = <&pmc 00000004>;
-		};
-
-		pmc: power@e0070 {
-			compatible = "fsl,mpc8540-pmc", "fsl,mpc8548-pmc";
-			reg = <0xe0070 0x20>;
-		};
-	};
diff --git a/Documentation/powerpc/dts-bindings/4xx/cpm.txt b/Documentation/powerpc/dts-bindings/4xx/cpm.txt
deleted file mode 100644
index ee45980..0000000
--- a/Documentation/powerpc/dts-bindings/4xx/cpm.txt
+++ /dev/null
@@ -1,52 +0,0 @@
-PPC4xx Clock Power Management (CPM) node
-
-Required properties:
-	- compatible		: compatible list, currently only "ibm,cpm"
-	- dcr-access-method	: "native"
-	- dcr-reg		: < DCR register range >
-
-Optional properties:
-	- er-offset		: All 4xx SoCs with a CPM controller have
-				  one of two different order for the CPM
-				  registers. Some have the CPM registers
-				  in the following order (ER,FR,SR). The
-				  others have them in the following order
-				  (SR,ER,FR). For the second case set
-				  er-offset = <1>.
-	- unused-units		: specifier consist of one cell. For each
-				  bit in the cell, the corresponding bit
-				  in CPM will be set to turn off unused
-				  devices.
-	- idle-doze		: specifier consist of one cell. For each
-				  bit in the cell, the corresponding bit
-				  in CPM will be set to turn off unused
-				  devices. This is usually just CPM[CPU].
-	- standby		: specifier consist of one cell. For each
-				  bit in the cell, the corresponding bit
-				  in CPM will be set on standby and
-				  restored on resume.
-	- suspend		: specifier consist of one cell. For each
-				  bit in the cell, the corresponding bit
-				  in CPM will be set on suspend (mem) and
-				  restored on resume. Note, for standby
-				  and suspend the corresponding bits can
-				  be different or the same. Usually for
-				  standby only class 2 and 3 units are set.
-				  However, the interface does not care.
-				  If they are the same, the additional
-				  power saving will be seeing if support
-				  is available to put the DDR in self
-				  refresh mode and any additional power
-				  saving techniques for the specific SoC.
-
-Example:
-	CPM0: cpm {
-		compatible = "ibm,cpm";
-		dcr-access-method = "native";
-		dcr-reg = <0x160 0x003>;
-		er-offset = <0>;
-		unused-units = <0x00000100>;
-		idle-doze = <0x02000000>;
-		standby = <0xfeff0000>;
-		suspend = <0xfeff791d>;
-};
diff --git a/Documentation/powerpc/dts-bindings/4xx/emac.txt b/Documentation/powerpc/dts-bindings/4xx/emac.txt
deleted file mode 100644
index 2161334..0000000
--- a/Documentation/powerpc/dts-bindings/4xx/emac.txt
+++ /dev/null
@@ -1,148 +0,0 @@
-    4xx/Axon EMAC ethernet nodes
-
-    The EMAC ethernet controller in IBM and AMCC 4xx chips, and also
-    the Axon bridge.  To operate this needs to interact with a ths
-    special McMAL DMA controller, and sometimes an RGMII or ZMII
-    interface.  In addition to the nodes and properties described
-    below, the node for the OPB bus on which the EMAC sits must have a
-    correct clock-frequency property.
-
-      i) The EMAC node itself
-
-    Required properties:
-    - device_type       : "network"
-
-    - compatible        : compatible list, contains 2 entries, first is
-			  "ibm,emac-CHIP" where CHIP is the host ASIC (440gx,
-			  405gp, Axon) and second is either "ibm,emac" or
-			  "ibm,emac4".  For Axon, thus, we have: "ibm,emac-axon",
-			  "ibm,emac4"
-    - interrupts        : <interrupt mapping for EMAC IRQ and WOL IRQ>
-    - interrupt-parent  : optional, if needed for interrupt mapping
-    - reg               : <registers mapping>
-    - local-mac-address : 6 bytes, MAC address
-    - mal-device        : phandle of the associated McMAL node
-    - mal-tx-channel    : 1 cell, index of the tx channel on McMAL associated
-			  with this EMAC
-    - mal-rx-channel    : 1 cell, index of the rx channel on McMAL associated
-			  with this EMAC
-    - cell-index        : 1 cell, hardware index of the EMAC cell on a given
-			  ASIC (typically 0x0 and 0x1 for EMAC0 and EMAC1 on
-			  each Axon chip)
-    - max-frame-size    : 1 cell, maximum frame size supported in bytes
-    - rx-fifo-size      : 1 cell, Rx fifo size in bytes for 10 and 100 Mb/sec
-			  operations.
-			  For Axon, 2048
-    - tx-fifo-size      : 1 cell, Tx fifo size in bytes for 10 and 100 Mb/sec
-			  operations.
-			  For Axon, 2048.
-    - fifo-entry-size   : 1 cell, size of a fifo entry (used to calculate
-			  thresholds).
-			  For Axon, 0x00000010
-    - mal-burst-size    : 1 cell, MAL burst size (used to calculate thresholds)
-			  in bytes.
-			  For Axon, 0x00000100 (I think ...)
-    - phy-mode          : string, mode of operations of the PHY interface.
-			  Supported values are: "mii", "rmii", "smii", "rgmii",
-			  "tbi", "gmii", rtbi", "sgmii".
-			  For Axon on CAB, it is "rgmii"
-    - mdio-device       : 1 cell, required iff using shared MDIO registers
-			  (440EP).  phandle of the EMAC to use to drive the
-			  MDIO lines for the PHY used by this EMAC.
-    - zmii-device       : 1 cell, required iff connected to a ZMII.  phandle of
-			  the ZMII device node
-    - zmii-channel      : 1 cell, required iff connected to a ZMII.  Which ZMII
-			  channel or 0xffffffff if ZMII is only used for MDIO.
-    - rgmii-device      : 1 cell, required iff connected to an RGMII. phandle
-			  of the RGMII device node.
-			  For Axon: phandle of plb5/plb4/opb/rgmii
-    - rgmii-channel     : 1 cell, required iff connected to an RGMII.  Which
-			  RGMII channel is used by this EMAC.
-			  Fox Axon: present, whatever value is appropriate for each
-			  EMAC, that is the content of the current (bogus) "phy-port"
-			  property.
-
-    Optional properties:
-    - phy-address       : 1 cell, optional, MDIO address of the PHY. If absent,
-			  a search is performed.
-    - phy-map           : 1 cell, optional, bitmap of addresses to probe the PHY
-			  for, used if phy-address is absent. bit 0x00000001 is
-			  MDIO address 0.
-			  For Axon it can be absent, though my current driver
-			  doesn't handle phy-address yet so for now, keep
-			  0x00ffffff in it.
-    - rx-fifo-size-gige : 1 cell, Rx fifo size in bytes for 1000 Mb/sec
-			  operations (if absent the value is the same as
-			  rx-fifo-size).  For Axon, either absent or 2048.
-    - tx-fifo-size-gige : 1 cell, Tx fifo size in bytes for 1000 Mb/sec
-			  operations (if absent the value is the same as
-			  tx-fifo-size). For Axon, either absent or 2048.
-    - tah-device        : 1 cell, optional. If connected to a TAH engine for
-			  offload, phandle of the TAH device node.
-    - tah-channel       : 1 cell, optional. If appropriate, channel used on the
-			  TAH engine.
-
-    Example:
-
-	EMAC0: ethernet@40000800 {
-		device_type = "network";
-		compatible = "ibm,emac-440gp", "ibm,emac";
-		interrupt-parent = <&UIC1>;
-		interrupts = <1c 4 1d 4>;
-		reg = <40000800 70>;
-		local-mac-address = [00 04 AC E3 1B 1E];
-		mal-device = <&MAL0>;
-		mal-tx-channel = <0 1>;
-		mal-rx-channel = <0>;
-		cell-index = <0>;
-		max-frame-size = <5dc>;
-		rx-fifo-size = <1000>;
-		tx-fifo-size = <800>;
-		phy-mode = "rmii";
-		phy-map = <00000001>;
-		zmii-device = <&ZMII0>;
-		zmii-channel = <0>;
-	};
-
-      ii) McMAL node
-
-    Required properties:
-    - device_type        : "dma-controller"
-    - compatible         : compatible list, containing 2 entries, first is
-			   "ibm,mcmal-CHIP" where CHIP is the host ASIC (like
-			   emac) and the second is either "ibm,mcmal" or
-			   "ibm,mcmal2".
-			   For Axon, "ibm,mcmal-axon","ibm,mcmal2"
-    - interrupts         : <interrupt mapping for the MAL interrupts sources:
-                           5 sources: tx_eob, rx_eob, serr, txde, rxde>.
-                           For Axon: This is _different_ from the current
-			   firmware.  We use the "delayed" interrupts for txeob
-			   and rxeob. Thus we end up with mapping those 5 MPIC
-			   interrupts, all level positive sensitive: 10, 11, 32,
-			   33, 34 (in decimal)
-    - dcr-reg            : < DCR registers range >
-    - dcr-parent         : if needed for dcr-reg
-    - num-tx-chans       : 1 cell, number of Tx channels
-    - num-rx-chans       : 1 cell, number of Rx channels
-
-      iii) ZMII node
-
-    Required properties:
-    - compatible         : compatible list, containing 2 entries, first is
-			   "ibm,zmii-CHIP" where CHIP is the host ASIC (like
-			   EMAC) and the second is "ibm,zmii".
-			   For Axon, there is no ZMII node.
-    - reg                : <registers mapping>
-
-      iv) RGMII node
-
-    Required properties:
-    - compatible         : compatible list, containing 2 entries, first is
-			   "ibm,rgmii-CHIP" where CHIP is the host ASIC (like
-			   EMAC) and the second is "ibm,rgmii".
-                           For Axon, "ibm,rgmii-axon","ibm,rgmii"
-    - reg                : <registers mapping>
-    - revision           : as provided by the RGMII new version register if
-			   available.
-			   For Axon: 0x0000012a
-
diff --git a/Documentation/powerpc/dts-bindings/4xx/ndfc.txt b/Documentation/powerpc/dts-bindings/4xx/ndfc.txt
deleted file mode 100644
index 869f0b5..0000000
--- a/Documentation/powerpc/dts-bindings/4xx/ndfc.txt
+++ /dev/null
@@ -1,39 +0,0 @@
-AMCC NDFC (NanD Flash Controller)
-
-Required properties:
-- compatible : "ibm,ndfc".
-- reg : should specify chip select and size used for the chip (0x2000).
-
-Optional properties:
-- ccr : NDFC config and control register value (default 0).
-- bank-settings : NDFC bank configuration register value (default 0).
-
-Notes:
-- partition(s) - follows the OF MTD standard for partitions
-
-Example:
-
-ndfc@1,0 {
-	compatible = "ibm,ndfc";
-	reg = <0x00000001 0x00000000 0x00002000>;
-	ccr = <0x00001000>;
-	bank-settings = <0x80002222>;
-	#address-cells = <1>;
-	#size-cells = <1>;
-
-	nand {
-		#address-cells = <1>;
-		#size-cells = <1>;
-
-		partition@0 {
-			label = "kernel";
-			reg = <0x00000000 0x00200000>;
-		};
-		partition@200000 {
-			label = "root";
-			reg = <0x00200000 0x03E00000>;
-		};
-	};
-};
-
-
diff --git a/Documentation/powerpc/dts-bindings/4xx/ppc440spe-adma.txt b/Documentation/powerpc/dts-bindings/4xx/ppc440spe-adma.txt
deleted file mode 100644
index 515ebcf..0000000
--- a/Documentation/powerpc/dts-bindings/4xx/ppc440spe-adma.txt
+++ /dev/null
@@ -1,93 +0,0 @@
-PPC440SPe DMA/XOR (DMA Controller and XOR Accelerator)
-
-Device nodes needed for operation of the ppc440spe-adma driver
-are specified hereby. These are I2O/DMA, DMA and XOR nodes
-for DMA engines and Memory Queue Module node. The latter is used
-by ADMA driver for configuration of RAID-6 H/W capabilities of
-the PPC440SPe. In addition to the nodes and properties described
-below, the ranges property of PLB node must specify ranges for
-DMA devices.
-
- i) The I2O node
-
- Required properties:
-
- - compatible		: "ibm,i2o-440spe";
- - reg			: <registers mapping>
- - dcr-reg		: <DCR registers range>
-
- Example:
-
-	I2O: i2o@400100000 {
-		compatible = "ibm,i2o-440spe";
-		reg = <0x00000004 0x00100000 0x100>;
-		dcr-reg = <0x060 0x020>;
-	};
-
-
- ii) The DMA node
-
- Required properties:
-
- - compatible		: "ibm,dma-440spe";
- - cell-index		: 1 cell, hardware index of the DMA engine
-			  (typically 0x0 and 0x1 for DMA0 and DMA1)
- - reg			: <registers mapping>
- - dcr-reg		: <DCR registers range>
- - interrupts		: <interrupt mapping for DMA0/1 interrupts sources:
-			   2 sources: DMAx CS FIFO Needs Service IRQ (on UIC0)
-			   and DMA Error IRQ (on UIC1). The latter is common
-			   for both DMA engines>.
- - interrupt-parent	: needed for interrupt mapping
-
- Example:
-
-	DMA0: dma0@400100100 {
-		compatible = "ibm,dma-440spe";
-		cell-index = <0>;
-		reg = <0x00000004 0x00100100 0x100>;
-		dcr-reg = <0x060 0x020>;
-		interrupt-parent = <&DMA0>;
-		interrupts = <0 1>;
-		#interrupt-cells = <1>;
-		#address-cells = <0>;
-		#size-cells = <0>;
-		interrupt-map = <
-			0 &UIC0 0x14 4
-			1 &UIC1 0x16 4>;
-	};
-
-
- iii) XOR Accelerator node
-
- Required properties:
-
- - compatible		: "amcc,xor-accelerator";
- - reg			: <registers mapping>
- - interrupts		: <interrupt mapping for XOR interrupt source>
- - interrupt-parent	: for interrupt mapping
-
- Example:
-
-	xor-accel@400200000 {
-		compatible = "amcc,xor-accelerator";
-		reg = <0x00000004 0x00200000 0x400>;
-		interrupt-parent = <&UIC1>;
-		interrupts = <0x1f 4>;
-	};
-
-
- iv) Memory Queue Module node
-
- Required properties:
-
- - compatible		: "ibm,mq-440spe";
- - dcr-reg		: <DCR registers range>
-
- Example:
-
-	MQ0: mq {
-		compatible = "ibm,mq-440spe";
-		dcr-reg = <0x040 0x020>;
-	};
-
diff --git a/Documentation/powerpc/dts-bindings/4xx/reboot.txt b/Documentation/powerpc/dts-bindings/4xx/reboot.txt
deleted file mode 100644
index d721726..0000000
--- a/Documentation/powerpc/dts-bindings/4xx/reboot.txt
+++ /dev/null
@@ -1,18 +0,0 @@
-Reboot property to control system reboot on PPC4xx systems:
-
-By setting "reset_type" to one of the following values, the default
-software reset mechanism may be overidden. Here the possible values of
-"reset_type":
-
-      1 - PPC4xx core reset
-      2 - PPC4xx chip reset
-      3 - PPC4xx system reset (default)
-
-Example:
-
-		cpu@0 {
-			device_type = "cpu";
-			model = "PowerPC,440SPe";
-			...
-			reset-type = <2>;	/* Use chip-reset */
-		};
diff --git a/Documentation/powerpc/dts-bindings/can/sja1000.txt b/Documentation/powerpc/dts-bindings/can/sja1000.txt
deleted file mode 100644
index d6d209d..0000000
--- a/Documentation/powerpc/dts-bindings/can/sja1000.txt
+++ /dev/null
@@ -1,53 +0,0 @@
-Memory mapped SJA1000 CAN controller from NXP (formerly Philips)
-
-Required properties:
-
-- compatible : should be "nxp,sja1000".
-
-- reg : should specify the chip select, address offset and size required
-	to map the registers of the SJA1000. The size is usually 0x80.
-
-- interrupts: property with a value describing the interrupt source
-	(number and sensitivity) required for the SJA1000.
-
-Optional properties:
-
-- nxp,external-clock-frequency : Frequency of the external oscillator
-	clock in Hz. Note that the internal clock frequency used by the
-	SJA1000 is half of that value. If not specified, a default value
-	of 16000000 (16 MHz) is used.
-
-- nxp,tx-output-mode : operation mode of the TX output control logic:
-	<0x0> : bi-phase output mode
-	<0x1> : normal output mode (default)
-	<0x2> : test output mode
-	<0x3> : clock output mode
-
-- nxp,tx-output-config : TX output pin configuration:
-	<0x01> : TX0 invert
-	<0x02> : TX0 pull-down (default)
-	<0x04> : TX0 pull-up
-	<0x06> : TX0 push-pull
-	<0x08> : TX1 invert
-	<0x10> : TX1 pull-down
-	<0x20> : TX1 pull-up
-	<0x30> : TX1 push-pull
-
-- nxp,clock-out-frequency : clock frequency in Hz on the CLKOUT pin.
-	If not specified or if the specified value is 0, the CLKOUT pin
-	will be disabled.
-
-- nxp,no-comparator-bypass : Allows to disable the CAN input comperator.
-
-For futher information, please have a look to the SJA1000 data sheet.
-
-Examples:
-
-can@3,100 {
-	compatible = "nxp,sja1000";
-	reg = <3 0x100 0x80>;
-	interrupts = <2 0>;
-	interrupt-parent = <&mpic>;
-	nxp,external-clock-frequency = <16000000>;
-};
-
diff --git a/Documentation/powerpc/dts-bindings/ecm.txt b/Documentation/powerpc/dts-bindings/ecm.txt
deleted file mode 100644
index f514f29..0000000
--- a/Documentation/powerpc/dts-bindings/ecm.txt
+++ /dev/null
@@ -1,64 +0,0 @@
-=====================================================================
-E500 LAW & Coherency Module Device Tree Binding
-Copyright (C) 2009 Freescale Semiconductor Inc.
-=====================================================================
-
-Local Access Window (LAW) Node
-
-The LAW node represents the region of CCSR space where local access
-windows are configured.  For ECM based devices this is the first 4k
-of CCSR space that includes CCSRBAR, ALTCBAR, ALTCAR, BPTR, and some
-number of local access windows as specified by fsl,num-laws.
-
-PROPERTIES
-
-  - compatible
-      Usage: required
-      Value type: <string>
-      Definition: Must include "fsl,ecm-law"
-
-  - reg
-      Usage: required
-      Value type: <prop-encoded-array>
-      Definition: A standard property.  The value specifies the
-          physical address offset and length of the CCSR space
-          registers.
-
-  - fsl,num-laws
-      Usage: required
-      Value type: <u32>
-      Definition: The value specifies the number of local access
-          windows for this device.
-
-=====================================================================
-
-E500 Coherency Module Node
-
-The E500 LAW node represents the region of CCSR space where ECM config
-and error reporting registers exist, this is the second 4k (0x1000)
-of CCSR space.
-
-PROPERTIES
-
-  - compatible
-      Usage: required
-      Value type: <string>
-      Definition: Must include "fsl,CHIP-ecm", "fsl,ecm" where
-      CHIP is the processor (mpc8572, mpc8544, etc.)
-
-  - reg
-      Usage: required
-      Value type: <prop-encoded-array>
-      Definition: A standard property.  The value specifies the
-          physical address offset and length of the CCSR space
-          registers.
-
-   - interrupts
-      Usage: required
-      Value type: <prop-encoded-array>
-
-   - interrupt-parent
-      Usage: required
-      Value type: <phandle>
-
-=====================================================================
diff --git a/Documentation/powerpc/dts-bindings/eeprom.txt b/Documentation/powerpc/dts-bindings/eeprom.txt
deleted file mode 100644
index 4342c10..0000000
--- a/Documentation/powerpc/dts-bindings/eeprom.txt
+++ /dev/null
@@ -1,28 +0,0 @@
-EEPROMs (I2C)
-
-Required properties:
-
-  - compatible : should be "<manufacturer>,<type>"
-		 If there is no specific driver for <manufacturer>, a generic
-		 driver based on <type> is selected. Possible types are:
-		 24c00, 24c01, 24c02, 24c04, 24c08, 24c16, 24c32, 24c64,
-		 24c128, 24c256, 24c512, 24c1024, spd
-
-  - reg : the I2C address of the EEPROM
-
-Optional properties:
-
-  - pagesize : the length of the pagesize for writing. Please consult the
-               manual of your device, that value varies a lot. A wrong value
-	       may result in data loss! If not specified, a safety value of
-	       '1' is used which will be very slow.
-
-  - read-only: this parameterless property disables writes to the eeprom
-
-Example:
-
-eeprom@52 {
-	compatible = "atmel,24c32";
-	reg = <0x52>;
-	pagesize = <32>;
-};
diff --git a/Documentation/powerpc/dts-bindings/fsl/83xx-512x-pci.txt b/Documentation/powerpc/dts-bindings/fsl/83xx-512x-pci.txt
deleted file mode 100644
index 35a4653..0000000
--- a/Documentation/powerpc/dts-bindings/fsl/83xx-512x-pci.txt
+++ /dev/null
@@ -1,40 +0,0 @@
-* Freescale 83xx and 512x PCI bridges
-
-Freescale 83xx and 512x SOCs include the same pci bridge core.
-
-83xx/512x specific notes:
-- reg: should contain two address length tuples
-    The first is for the internal pci bridge registers
-    The second is for the pci config space access registers
-
-Example (MPC8313ERDB)
-	pci0: pci@e0008500 {
-		cell-index = <1>;
-		interrupt-map-mask = <0xf800 0x0 0x0 0x7>;
-		interrupt-map = <
-				/* IDSEL 0x0E -mini PCI */
-				 0x7000 0x0 0x0 0x1 &ipic 18 0x8
-				 0x7000 0x0 0x0 0x2 &ipic 18 0x8
-				 0x7000 0x0 0x0 0x3 &ipic 18 0x8
-				 0x7000 0x0 0x0 0x4 &ipic 18 0x8
-
-				/* IDSEL 0x0F - PCI slot */
-				 0x7800 0x0 0x0 0x1 &ipic 17 0x8
-				 0x7800 0x0 0x0 0x2 &ipic 18 0x8
-				 0x7800 0x0 0x0 0x3 &ipic 17 0x8
-				 0x7800 0x0 0x0 0x4 &ipic 18 0x8>;
-		interrupt-parent = <&ipic>;
-		interrupts = <66 0x8>;
-		bus-range = <0x0 0x0>;
-		ranges = <0x02000000 0x0 0x90000000 0x90000000 0x0 0x10000000
-			  0x42000000 0x0 0x80000000 0x80000000 0x0 0x10000000
-			  0x01000000 0x0 0x00000000 0xe2000000 0x0 0x00100000>;
-		clock-frequency = <66666666>;
-		#interrupt-cells = <1>;
-		#size-cells = <2>;
-		#address-cells = <3>;
-		reg = <0xe0008500 0x100		/* internal registers */
-		       0xe0008300 0x8>;		/* config space access registers */
-		compatible = "fsl,mpc8349-pci";
-		device_type = "pci";
-	};
diff --git a/Documentation/powerpc/dts-bindings/fsl/8xxx_gpio.txt b/Documentation/powerpc/dts-bindings/fsl/8xxx_gpio.txt
deleted file mode 100644
index b0019eb..0000000
--- a/Documentation/powerpc/dts-bindings/fsl/8xxx_gpio.txt
+++ /dev/null
@@ -1,60 +0,0 @@
-GPIO controllers on MPC8xxx SoCs
-
-This is for the non-QE/CPM/GUTs GPIO controllers as found on
-8349, 8572, 8610 and compatible.
-
-Every GPIO controller node must have #gpio-cells property defined,
-this information will be used to translate gpio-specifiers.
-
-Required properties:
-- compatible : "fsl,<CHIP>-gpio" followed by "fsl,mpc8349-gpio" for
-  83xx, "fsl,mpc8572-gpio" for 85xx and "fsl,mpc8610-gpio" for 86xx.
-- #gpio-cells : Should be two. The first cell is the pin number and the
-  second cell is used to specify optional parameters (currently unused).
- - interrupts : Interrupt mapping for GPIO IRQ.
- - interrupt-parent : Phandle for the interrupt controller that
-   services interrupts for this device.
-- gpio-controller : Marks the port as GPIO controller.
-
-Example of gpio-controller nodes for a MPC8347 SoC:
-
-	gpio1: gpio-controller@c00 {
-		#gpio-cells = <2>;
-		compatible = "fsl,mpc8347-gpio", "fsl,mpc8349-gpio";
-		reg = <0xc00 0x100>;
-		interrupts = <74 0x8>;
-		interrupt-parent = <&ipic>;
-		gpio-controller;
-	};
-
-	gpio2: gpio-controller@d00 {
-		#gpio-cells = <2>;
-		compatible = "fsl,mpc8347-gpio", "fsl,mpc8349-gpio";
-		reg = <0xd00 0x100>;
-		interrupts = <75 0x8>;
-		interrupt-parent = <&ipic>;
-		gpio-controller;
-	};
-
-See booting-without-of.txt for details of how to specify GPIO
-information for devices.
-
-To use GPIO pins as interrupt sources for peripherals, specify the
-GPIO controller as the interrupt parent and define GPIO number +
-trigger mode using the interrupts property, which is defined like
-this:
-
-interrupts = <number trigger>, where:
- - number: GPIO pin (0..31)
- - trigger: trigger mode:
-	2 = trigger on falling edge
-	3 = trigger on both edges
-
-Example of device using this is:
-
-	funkyfpga@0 {
-		compatible = "funky-fpga";
-		...
-		interrupts = <4 3>;
-		interrupt-parent = <&gpio1>;
-	};
diff --git a/Documentation/powerpc/dts-bindings/fsl/board.txt b/Documentation/powerpc/dts-bindings/fsl/board.txt
deleted file mode 100644
index 39e9415..0000000
--- a/Documentation/powerpc/dts-bindings/fsl/board.txt
+++ /dev/null
@@ -1,63 +0,0 @@
-* Board Control and Status (BCSR)
-
-Required properties:
-
- - compatible : Should be "fsl,<board>-bcsr"
- - reg : Offset and length of the register set for the device
-
-Example:
-
-	bcsr@f8000000 {
-		compatible = "fsl,mpc8360mds-bcsr";
-		reg = <f8000000 8000>;
-	};
-
-* Freescale on board FPGA
-
-This is the memory-mapped registers for on board FPGA.
-
-Required properities:
-- compatible : should be "fsl,fpga-pixis".
-- reg : should contain the address and the length of the FPPGA register
-  set.
-- interrupt-parent: should specify phandle for the interrupt controller.
-- interrupts : should specify event (wakeup) IRQ.
-
-Example (MPC8610HPCD):
-
-	board-control@e8000000 {
-		compatible = "fsl,fpga-pixis";
-		reg = <0xe8000000 32>;
-		interrupt-parent = <&mpic>;
-		interrupts = <8 8>;
-	};
-
-* Freescale BCSR GPIO banks
-
-Some BCSR registers act as simple GPIO controllers, each such
-register can be represented by the gpio-controller node.
-
-Required properities:
-- compatible : Should be "fsl,<board>-bcsr-gpio".
-- reg : Should contain the address and the length of the GPIO bank
-  register.
-- #gpio-cells : Should be two. The first cell is the pin number and the
-  second cell is used to specify optional parameters (currently unused).
-- gpio-controller : Marks the port as GPIO controller.
-
-Example:
-
-	bcsr@1,0 {
-		#address-cells = <1>;
-		#size-cells = <1>;
-		compatible = "fsl,mpc8360mds-bcsr";
-		reg = <1 0 0x8000>;
-		ranges = <0 1 0 0x8000>;
-
-		bcsr13: gpio-controller@d {
-			#gpio-cells = <2>;
-			compatible = "fsl,mpc8360mds-bcsr-gpio";
-			reg = <0xd 1>;
-			gpio-controller;
-		};
-	};
diff --git a/Documentation/powerpc/dts-bindings/fsl/can.txt b/Documentation/powerpc/dts-bindings/fsl/can.txt
deleted file mode 100644
index 2fa4fcd..0000000
--- a/Documentation/powerpc/dts-bindings/fsl/can.txt
+++ /dev/null
@@ -1,53 +0,0 @@
-CAN Device Tree Bindings
-------------------------
-
-(c) 2006-2009 Secret Lab Technologies Ltd
-Grant Likely <grant.likely@secretlab.ca>
-
-fsl,mpc5200-mscan nodes
------------------------
-In addition to the required compatible-, reg- and interrupt-properties, you can
-also specify which clock source shall be used for the controller:
-
-- fsl,mscan-clock-source : a string describing the clock source. Valid values
-			   are:	"ip" for ip bus clock
-				 "ref" for reference clock (XTAL)
-			   "ref" is default in case this property is not
-			   present.
-
-fsl,mpc5121-mscan nodes
------------------------
-In addition to the required compatible-, reg- and interrupt-properties, you can
-also specify which clock source and divider shall be used for the controller:
-
-- fsl,mscan-clock-source : a string describing the clock source. Valid values
-			   are:	"ip" for ip bus clock
-				"ref" for reference clock
-				"sys" for system clock
-			   If this property is not present, an optimal CAN
-			   clock source and frequency based on the system
-			   clock will be selected. If this is not possible,
-			   the reference clock will be used.
-
-- fsl,mscan-clock-divider: for the reference and system clock, an additional
-			   clock divider can be specified. By default, a
-			   value of 1 is used.
-
-Note that the MPC5121 Rev. 1 processor is not supported.
-
-Examples:
-	can@1300 {
-		compatible = "fsl,mpc5121-mscan";
-		interrupts = <12 0x8>;
-		interrupt-parent = <&ipic>;
-		reg = <0x1300 0x80>;
-	};
-
-	can@1380 {
-		compatible = "fsl,mpc5121-mscan";
-		interrupts = <13 0x8>;
-		interrupt-parent = <&ipic>;
-		reg = <0x1380 0x80>;
-		fsl,mscan-clock-source = "ref";
-		fsl,mscan-clock-divider = <3>;
-	};
diff --git a/Documentation/powerpc/dts-bindings/fsl/cpm_qe/cpm.txt b/Documentation/powerpc/dts-bindings/fsl/cpm_qe/cpm.txt
deleted file mode 100644
index 160c752..0000000
--- a/Documentation/powerpc/dts-bindings/fsl/cpm_qe/cpm.txt
+++ /dev/null
@@ -1,67 +0,0 @@
-* Freescale Communications Processor Module
-
-NOTE: This is an interim binding, and will likely change slightly,
-as more devices are supported.  The QE bindings especially are
-incomplete.
-
-* Root CPM node
-
-Properties:
-- compatible : "fsl,cpm1", "fsl,cpm2", or "fsl,qe".
-- reg : A 48-byte region beginning with CPCR.
-
-Example:
-     cpm@119c0 {
-	#address-cells = <1>;
-	#size-cells = <1>;
-	#interrupt-cells = <2>;
-	compatible = "fsl,mpc8272-cpm", "fsl,cpm2";
-	reg = <119c0 30>;
-     }
-
-* Properties common to multiple CPM/QE devices
-
-- fsl,cpm-command : This value is ORed with the opcode and command flag
-                    to specify the device on which a CPM command operates.
-
-- fsl,cpm-brg : Indicates which baud rate generator the device
-                is associated with.  If absent, an unused BRG
-                should be dynamically allocated.  If zero, the
-                device uses an external clock rather than a BRG.
-
-- reg : Unless otherwise specified, the first resource represents the
-        scc/fcc/ucc registers, and the second represents the device's
-        parameter RAM region (if it has one).
-
-* Multi-User RAM (MURAM)
-
-The multi-user/dual-ported RAM is expressed as a bus under the CPM node.
-
-Ranges must be set up subject to the following restrictions:
-
-- Children's reg nodes must be offsets from the start of all muram, even
-  if the user-data area does not begin at zero.
-- If multiple range entries are used, the difference between the parent
-  address and the child address must be the same in all, so that a single
-  mapping can cover them all while maintaining the ability to determine
-  CPM-side offsets with pointer subtraction.  It is recommended that
-  multiple range entries not be used.
-- A child address of zero must be translatable, even if no reg resources
-  contain it.
-
-A child "data" node must exist, compatible with "fsl,cpm-muram-data", to
-indicate the portion of muram that is usable by the OS for arbitrary
-purposes.  The data node may have an arbitrary number of reg resources,
-all of which contribute to the allocatable muram pool.
-
-Example, based on mpc8272:
-	muram@0 {
-		#address-cells = <1>;
-		#size-cells = <1>;
-		ranges = <0 0 10000>;
-
-		data@0 {
-			compatible = "fsl,cpm-muram-data";
-			reg = <0 2000 9800 800>;
-		};
-	};
diff --git a/Documentation/powerpc/dts-bindings/fsl/cpm_qe/cpm/brg.txt b/Documentation/powerpc/dts-bindings/fsl/cpm_qe/cpm/brg.txt
deleted file mode 100644
index 4c7d45e..0000000
--- a/Documentation/powerpc/dts-bindings/fsl/cpm_qe/cpm/brg.txt
+++ /dev/null
@@ -1,21 +0,0 @@
-* Baud Rate Generators
-
-Currently defined compatibles:
-fsl,cpm-brg
-fsl,cpm1-brg
-fsl,cpm2-brg
-
-Properties:
-- reg : There may be an arbitrary number of reg resources; BRG
-  numbers are assigned to these in order.
-- clock-frequency : Specifies the base frequency driving
-  the BRG.
-
-Example:
-	brg@119f0 {
-		compatible = "fsl,mpc8272-brg",
-			     "fsl,cpm2-brg",
-			     "fsl,cpm-brg";
-		reg = <119f0 10 115f0 10>;
-		clock-frequency = <d#25000000>;
-	};
diff --git a/Documentation/powerpc/dts-bindings/fsl/cpm_qe/cpm/i2c.txt b/Documentation/powerpc/dts-bindings/fsl/cpm_qe/cpm/i2c.txt
deleted file mode 100644
index 87bc604..0000000
--- a/Documentation/powerpc/dts-bindings/fsl/cpm_qe/cpm/i2c.txt
+++ /dev/null
@@ -1,41 +0,0 @@
-* I2C
-
-The I2C controller is expressed as a bus under the CPM node.
-
-Properties:
-- compatible : "fsl,cpm1-i2c", "fsl,cpm2-i2c"
-- reg : On CPM2 devices, the second resource doesn't specify the I2C
-  Parameter RAM itself, but the I2C_BASE field of the CPM2 Parameter RAM
-  (typically 0x8afc 0x2).
-- #address-cells : Should be one. The cell is the i2c device address with
-  the r/w bit set to zero.
-- #size-cells : Should be zero.
-- clock-frequency : Can be used to set the i2c clock frequency. If
-  unspecified, a default frequency of 60kHz is being used.
-The following two properties are deprecated. They are only used by legacy
-i2c drivers to find the bus to probe:
-- linux,i2c-index : Can be used to hard code an i2c bus number. By default,
-  the bus number is dynamically assigned by the i2c core.
-- linux,i2c-class : Can be used to override the i2c class. The class is used
-  by legacy i2c device drivers to find a bus in a specific context like
-  system management, video or sound. By default, I2C_CLASS_HWMON (1) is
-  being used. The definition of the classes can be found in
-  include/i2c/i2c.h
-
-Example, based on mpc823:
-
-	i2c@860 {
-		compatible = "fsl,mpc823-i2c",
-			     "fsl,cpm1-i2c";
-		reg = <0x860 0x20 0x3c80 0x30>;
-		interrupts = <16>;
-		interrupt-parent = <&CPM_PIC>;
-		fsl,cpm-command = <0x10>;
-		#address-cells = <1>;
-		#size-cells = <0>;
-
-		rtc@68 {
-			compatible = "dallas,ds1307";
-			reg = <0x68>;
-		};
-	};
diff --git a/Documentation/powerpc/dts-bindings/fsl/cpm_qe/cpm/pic.txt b/Documentation/powerpc/dts-bindings/fsl/cpm_qe/cpm/pic.txt
deleted file mode 100644
index 8e3ee16..0000000
--- a/Documentation/powerpc/dts-bindings/fsl/cpm_qe/cpm/pic.txt
+++ /dev/null
@@ -1,18 +0,0 @@
-* Interrupt Controllers
-
-Currently defined compatibles:
-- fsl,cpm1-pic
-  - only one interrupt cell
-- fsl,pq1-pic
-- fsl,cpm2-pic
-  - second interrupt cell is level/sense:
-    - 2 is falling edge
-    - 8 is active low
-
-Example:
-	interrupt-controller@10c00 {
-		#interrupt-cells = <2>;
-		interrupt-controller;
-		reg = <10c00 80>;
-		compatible = "mpc8272-pic", "fsl,cpm2-pic";
-	};
diff --git a/Documentation/powerpc/dts-bindings/fsl/cpm_qe/cpm/usb.txt b/Documentation/powerpc/dts-bindings/fsl/cpm_qe/cpm/usb.txt
deleted file mode 100644
index 74bfda4..0000000
--- a/Documentation/powerpc/dts-bindings/fsl/cpm_qe/cpm/usb.txt
+++ /dev/null
@@ -1,15 +0,0 @@
-* USB (Universal Serial Bus Controller)
-
-Properties:
-- compatible : "fsl,cpm1-usb", "fsl,cpm2-usb", "fsl,qe-usb"
-
-Example:
-	usb@11bc0 {
-		#address-cells = <1>;
-		#size-cells = <0>;
-		compatible = "fsl,cpm2-usb";
-		reg = <11b60 18 8b00 100>;
-		interrupts = <b 8>;
-		interrupt-parent = <&PIC>;
-		fsl,cpm-command = <2e600000>;
-	};
diff --git a/Documentation/powerpc/dts-bindings/fsl/cpm_qe/gpio.txt b/Documentation/powerpc/dts-bindings/fsl/cpm_qe/gpio.txt
deleted file mode 100644
index 349f79f..0000000
--- a/Documentation/powerpc/dts-bindings/fsl/cpm_qe/gpio.txt
+++ /dev/null
@@ -1,38 +0,0 @@
-Every GPIO controller node must have #gpio-cells property defined,
-this information will be used to translate gpio-specifiers.
-
-On CPM1 devices, all ports are using slightly different register layouts.
-Ports A, C and D are 16bit ports and Ports B and E are 32bit ports.
-
-On CPM2 devices, all ports are 32bit ports and use a common register layout.
-
-Required properties:
-- compatible : "fsl,cpm1-pario-bank-a", "fsl,cpm1-pario-bank-b",
-  "fsl,cpm1-pario-bank-c", "fsl,cpm1-pario-bank-d",
-  "fsl,cpm1-pario-bank-e", "fsl,cpm2-pario-bank"
-- #gpio-cells : Should be two. The first cell is the pin number and the
-  second cell is used to specify optional parameters (currently unused).
-- gpio-controller : Marks the port as GPIO controller.
-
-Example of three SOC GPIO banks defined as gpio-controller nodes:
-
-	CPM1_PIO_A: gpio-controller@950 {
-		#gpio-cells = <2>;
-		compatible = "fsl,cpm1-pario-bank-a";
-		reg = <0x950 0x10>;
-		gpio-controller;
-	};
-
-	CPM1_PIO_B: gpio-controller@ab8 {
-		#gpio-cells = <2>;
-		compatible = "fsl,cpm1-pario-bank-b";
-		reg = <0xab8 0x10>;
-		gpio-controller;
-	};
-
-	CPM1_PIO_E: gpio-controller@ac8 {
-		#gpio-cells = <2>;
-		compatible = "fsl,cpm1-pario-bank-e";
-		reg = <0xac8 0x18>;
-		gpio-controller;
-	};
diff --git a/Documentation/powerpc/dts-bindings/fsl/cpm_qe/network.txt b/Documentation/powerpc/dts-bindings/fsl/cpm_qe/network.txt
deleted file mode 100644
index 0e42694..0000000
--- a/Documentation/powerpc/dts-bindings/fsl/cpm_qe/network.txt
+++ /dev/null
@@ -1,45 +0,0 @@
-* Network
-
-Currently defined compatibles:
-- fsl,cpm1-scc-enet
-- fsl,cpm2-scc-enet
-- fsl,cpm1-fec-enet
-- fsl,cpm2-fcc-enet (third resource is GFEMR)
-- fsl,qe-enet
-
-Example:
-
-	ethernet@11300 {
-		device_type = "network";
-		compatible = "fsl,mpc8272-fcc-enet",
-			     "fsl,cpm2-fcc-enet";
-		reg = <11300 20 8400 100 11390 1>;
-		local-mac-address = [ 00 00 00 00 00 00 ];
-		interrupts = <20 8>;
-		interrupt-parent = <&PIC>;
-		phy-handle = <&PHY0>;
-		fsl,cpm-command = <12000300>;
-	};
-
-* MDIO
-
-Currently defined compatibles:
-fsl,pq1-fec-mdio (reg is same as first resource of FEC device)
-fsl,cpm2-mdio-bitbang (reg is port C registers)
-
-Properties for fsl,cpm2-mdio-bitbang:
-fsl,mdio-pin : pin of port C controlling mdio data
-fsl,mdc-pin : pin of port C controlling mdio clock
-
-Example:
-	mdio@10d40 {
-		device_type = "mdio";
-		compatible = "fsl,mpc8272ads-mdio-bitbang",
-			     "fsl,mpc8272-mdio-bitbang",
-			     "fsl,cpm2-mdio-bitbang";
-		reg = <10d40 14>;
-		#address-cells = <1>;
-		#size-cells = <0>;
-		fsl,mdio-pin = <12>;
-		fsl,mdc-pin = <13>;
-	};
diff --git a/Documentation/powerpc/dts-bindings/fsl/cpm_qe/qe.txt b/Documentation/powerpc/dts-bindings/fsl/cpm_qe/qe.txt
deleted file mode 100644
index 4f89302..0000000
--- a/Documentation/powerpc/dts-bindings/fsl/cpm_qe/qe.txt
+++ /dev/null
@@ -1,115 +0,0 @@
-* Freescale QUICC Engine module (QE)
-This represents qe module that is installed on PowerQUICC II Pro.
-
-NOTE:  This is an interim binding; it should be updated to fit
-in with the CPM binding later in this document.
-
-Basically, it is a bus of devices, that could act more or less
-as a complete entity (UCC, USB etc ). All of them should be siblings on
-the "root" qe node, using the common properties from there.
-The description below applies to the qe of MPC8360 and
-more nodes and properties would be extended in the future.
-
-i) Root QE device
-
-Required properties:
-- compatible : should be "fsl,qe";
-- model : precise model of the QE, Can be "QE", "CPM", or "CPM2"
-- reg : offset and length of the device registers.
-- bus-frequency : the clock frequency for QUICC Engine.
-- fsl,qe-num-riscs: define how many RISC engines the QE has.
-- fsl,qe-num-snums: define how many serial number(SNUM) the QE can use for the
-  threads.
-
-Optional properties:
-- fsl,firmware-phandle:
-    Usage: required only if there is no fsl,qe-firmware child node
-    Value type: <phandle>
-    Definition: Points to a firmware node (see "QE Firmware Node" below)
-        that contains the firmware that should be uploaded for this QE.
-        The compatible property for the firmware node should say,
-        "fsl,qe-firmware".
-
-Recommended properties
-- brg-frequency : the internal clock source frequency for baud-rate
-  generators in Hz.
-
-Example:
-     qe@e0100000 {
-	#address-cells = <1>;
-	#size-cells = <1>;
-	#interrupt-cells = <2>;
-	compatible = "fsl,qe";
-	ranges = <0 e0100000 00100000>;
-	reg = <e0100000 480>;
-	brg-frequency = <0>;
-	bus-frequency = <179A7B00>;
-     }
-
-* Multi-User RAM (MURAM)
-
-Required properties:
-- compatible : should be "fsl,qe-muram", "fsl,cpm-muram".
-- mode : the could be "host" or "slave".
-- ranges : Should be defined as specified in 1) to describe the
-   translation of MURAM addresses.
-- data-only : sub-node which defines the address area under MURAM
-   bus that can be allocated as data/parameter
-
-Example:
-
-     muram@10000 {
-	compatible = "fsl,qe-muram", "fsl,cpm-muram";
-	ranges = <0 00010000 0000c000>;
-
-	data-only@0{
-		compatible = "fsl,qe-muram-data",
-			     "fsl,cpm-muram-data";
-		reg = <0 c000>;
-	};
-     };
-
-* QE Firmware Node
-
-This node defines a firmware binary that is embedded in the device tree, for
-the purpose of passing the firmware from bootloader to the kernel, or from
-the hypervisor to the guest.
-
-The firmware node itself contains the firmware binary contents, a compatible
-property, and any firmware-specific properties.  The node should be placed
-inside a QE node that needs it.  Doing so eliminates the need for a
-fsl,firmware-phandle property.  Other QE nodes that need the same firmware
-should define an fsl,firmware-phandle property that points to the firmware node
-in the first QE node.
-
-The fsl,firmware property can be specified in the DTS (possibly using incbin)
-or can be inserted by the boot loader at boot time.
-
-Required properties:
-  - compatible
-      Usage: required
-      Value type: <string>
-      Definition: A standard property.  Specify a string that indicates what
-          kind of firmware it is.  For QE, this should be "fsl,qe-firmware".
-
-   - fsl,firmware
-      Usage: required
-      Value type: <prop-encoded-array>, encoded as an array of bytes
-      Definition: A standard property.  This property contains the firmware
-          binary "blob".
-
-Example:
-	qe1@e0080000 {
-		compatible = "fsl,qe";
-		qe_firmware:qe-firmware {
-			compatible = "fsl,qe-firmware";
-			fsl,firmware = [0x70 0xcd 0x00 0x00 0x01 0x46 0x45 ...];
-		};
-		...
-	};
-
-	qe2@e0090000 {
-		compatible = "fsl,qe";
-		fsl,firmware-phandle = <&qe_firmware>;
-		...
-	};
diff --git a/Documentation/powerpc/dts-bindings/fsl/cpm_qe/qe/firmware.txt b/Documentation/powerpc/dts-bindings/fsl/cpm_qe/qe/firmware.txt
deleted file mode 100644
index 249db3a..0000000
--- a/Documentation/powerpc/dts-bindings/fsl/cpm_qe/qe/firmware.txt
+++ /dev/null
@@ -1,24 +0,0 @@
-* Uploaded QE firmware
-
-      If a new firmware has been uploaded to the QE (usually by the
-      boot loader), then a 'firmware' child node should be added to the QE
-      node.  This node provides information on the uploaded firmware that
-      device drivers may need.
-
-      Required properties:
-      - id: The string name of the firmware.  This is taken from the 'id'
-            member of the qe_firmware structure of the uploaded firmware.
-            Device drivers can search this string to determine if the
-            firmware they want is already present.
-      - extended-modes: The Extended Modes bitfield, taken from the
-		   firmware binary.  It is a 64-bit number represented
-		   as an array of two 32-bit numbers.
-      - virtual-traps: The virtual traps, taken from the firmware binary.
-		  It is an array of 8 32-bit numbers.
-
-Example:
-	firmware {
-		id = "Soft-UART";
-		extended-modes = <0 0>;
-		virtual-traps = <0 0 0 0 0 0 0 0>;
-	};
diff --git a/Documentation/powerpc/dts-bindings/fsl/cpm_qe/qe/par_io.txt b/Documentation/powerpc/dts-bindings/fsl/cpm_qe/qe/par_io.txt
deleted file mode 100644
index 6098426..0000000
--- a/Documentation/powerpc/dts-bindings/fsl/cpm_qe/qe/par_io.txt
+++ /dev/null
@@ -1,51 +0,0 @@
-* Parallel I/O Ports
-
-This node configures Parallel I/O ports for CPUs with QE support.
-The node should reside in the "soc" node of the tree.  For each
-device that using parallel I/O ports, a child node should be created.
-See the definition of the Pin configuration nodes below for more
-information.
-
-Required properties:
-- device_type : should be "par_io".
-- reg : offset to the register set and its length.
-- num-ports : number of Parallel I/O ports
-
-Example:
-par_io@1400 {
-	reg = <1400 100>;
-	#address-cells = <1>;
-	#size-cells = <0>;
-	device_type = "par_io";
-	num-ports = <7>;
-	ucc_pin@01 {
-		......
-	};
-
-Note that "par_io" nodes are obsolete, and should not be used for
-the new device trees. Instead, each Par I/O bank should be represented
-via its own gpio-controller node:
-
-Required properties:
-- #gpio-cells : should be "2".
-- compatible : should be "fsl,<chip>-qe-pario-bank",
-  "fsl,mpc8323-qe-pario-bank".
-- reg : offset to the register set and its length.
-- gpio-controller : node to identify gpio controllers.
-
-Example:
-	qe_pio_a: gpio-controller@1400 {
-		#gpio-cells = <2>;
-		compatible = "fsl,mpc8360-qe-pario-bank",
-		"fsl,mpc8323-qe-pario-bank";
-		reg = <0x1400 0x18>;
-		gpio-controller;
-	  };
-
-	qe_pio_e: gpio-controller@1460 {
-		#gpio-cells = <2>;
-		compatible = "fsl,mpc8360-qe-pario-bank",
-			     "fsl,mpc8323-qe-pario-bank";
-		reg = <0x1460 0x18>;
-		gpio-controller;
-	  };
diff --git a/Documentation/powerpc/dts-bindings/fsl/cpm_qe/qe/pincfg.txt b/Documentation/powerpc/dts-bindings/fsl/cpm_qe/qe/pincfg.txt
deleted file mode 100644
index c5b4306..0000000
--- a/Documentation/powerpc/dts-bindings/fsl/cpm_qe/qe/pincfg.txt
+++ /dev/null
@@ -1,60 +0,0 @@
-* Pin configuration nodes
-
-Required properties:
-- linux,phandle : phandle of this node; likely referenced by a QE
-  device.
-- pio-map : array of pin configurations.  Each pin is defined by 6
-  integers.  The six numbers are respectively: port, pin, dir,
-  open_drain, assignment, has_irq.
-  - port : port number of the pin; 0-6 represent port A-G in UM.
-  - pin : pin number in the port.
-  - dir : direction of the pin, should encode as follows:
-
-     0 = The pin is disabled
-     1 = The pin is an output
-     2 = The pin is an input
-     3 = The pin is I/O
-
-  - open_drain : indicates the pin is normal or wired-OR:
-
-     0 = The pin is actively driven as an output
-     1 = The pin is an open-drain driver. As an output, the pin is
-         driven active-low, otherwise it is three-stated.
-
-  - assignment : function number of the pin according to the Pin Assignment
-    tables in User Manual.  Each pin can have up to 4 possible functions in
-    QE and two options for CPM.
-  - has_irq : indicates if the pin is used as source of external
-    interrupts.
-
-Example:
-     ucc_pin@01 {
-	linux,phandle = <140001>;
-	pio-map = <
-	/* port  pin  dir  open_drain  assignment  has_irq */
-		0  3  1  0  1  0 	/* TxD0 */
-		0  4  1  0  1  0 	/* TxD1 */
-		0  5  1  0  1  0 	/* TxD2 */
-		0  6  1  0  1  0 	/* TxD3 */
-		1  6  1  0  3  0 	/* TxD4 */
-		1  7  1  0  1  0 	/* TxD5 */
-		1  9  1  0  2  0 	/* TxD6 */
-		1  a  1  0  2  0 	/* TxD7 */
-		0  9  2  0  1  0 	/* RxD0 */
-		0  a  2  0  1  0 	/* RxD1 */
-		0  b  2  0  1  0 	/* RxD2 */
-		0  c  2  0  1  0 	/* RxD3 */
-		0  d  2  0  1  0 	/* RxD4 */
-		1  1  2  0  2  0 	/* RxD5 */
-		1  0  2  0  2  0 	/* RxD6 */
-		1  4  2  0  2  0 	/* RxD7 */
-		0  7  1  0  1  0 	/* TX_EN */
-		0  8  1  0  1  0 	/* TX_ER */
-		0  f  2  0  1  0 	/* RX_DV */
-		0  10 2  0  1  0 	/* RX_ER */
-		0  0  2  0  1  0 	/* RX_CLK */
-		2  9  1  0  3  0 	/* GTX_CLK - CLK10 */
-		2  8  2  0  1  0>;	/* GTX125 - CLK9 */
-     };
-
-
diff --git a/Documentation/powerpc/dts-bindings/fsl/cpm_qe/qe/ucc.txt b/Documentation/powerpc/dts-bindings/fsl/cpm_qe/qe/ucc.txt
deleted file mode 100644
index e47734b..0000000
--- a/Documentation/powerpc/dts-bindings/fsl/cpm_qe/qe/ucc.txt
+++ /dev/null
@@ -1,70 +0,0 @@
-* UCC (Unified Communications Controllers)
-
-Required properties:
-- device_type : should be "network", "hldc", "uart", "transparent"
-  "bisync", "atm", or "serial".
-- compatible : could be "ucc_geth" or "fsl_atm" and so on.
-- cell-index : the ucc number(1-8), corresponding to UCCx in UM.
-- reg : Offset and length of the register set for the device
-- interrupts : <a b> where a is the interrupt number and b is a
-  field that represents an encoding of the sense and level
-  information for the interrupt.  This should be encoded based on
-  the information in section 2) depending on the type of interrupt
-  controller you have.
-- interrupt-parent : the phandle for the interrupt controller that
-  services interrupts for this device.
-- pio-handle : The phandle for the Parallel I/O port configuration.
-- port-number : for UART drivers, the port number to use, between 0 and 3.
-  This usually corresponds to the /dev/ttyQE device, e.g. <0> = /dev/ttyQE0.
-  The port number is added to the minor number of the device.  Unlike the
-  CPM UART driver, the port-number is required for the QE UART driver.
-- soft-uart : for UART drivers, if specified this means the QE UART device
-  driver should use "Soft-UART" mode, which is needed on some SOCs that have
-  broken UART hardware.  Soft-UART is provided via a microcode upload.
-- rx-clock-name: the UCC receive clock source
-  "none": clock source is disabled
-  "brg1" through "brg16": clock source is BRG1-BRG16, respectively
-  "clk1" through "clk24": clock source is CLK1-CLK24, respectively
-- tx-clock-name: the UCC transmit clock source
-  "none": clock source is disabled
-  "brg1" through "brg16": clock source is BRG1-BRG16, respectively
-  "clk1" through "clk24": clock source is CLK1-CLK24, respectively
-The following two properties are deprecated.  rx-clock has been replaced
-with rx-clock-name, and tx-clock has been replaced with tx-clock-name.
-Drivers that currently use the deprecated properties should continue to
-do so, in order to support older device trees, but they should be updated
-to check for the new properties first.
-- rx-clock : represents the UCC receive clock source.
-  0x00 : clock source is disabled;
-  0x1~0x10 : clock source is BRG1~BRG16 respectively;
-  0x11~0x28: clock source is QE_CLK1~QE_CLK24 respectively.
-- tx-clock: represents the UCC transmit clock source;
-  0x00 : clock source is disabled;
-  0x1~0x10 : clock source is BRG1~BRG16 respectively;
-  0x11~0x28: clock source is QE_CLK1~QE_CLK24 respectively.
-
-Required properties for network device_type:
-- mac-address : list of bytes representing the ethernet address.
-- phy-handle : The phandle for the PHY connected to this controller.
-
-Recommended properties:
-- phy-connection-type : a string naming the controller/PHY interface type,
-  i.e., "mii" (default), "rmii", "gmii", "rgmii", "rgmii-id" (Internal
-  Delay), "rgmii-txid" (delay on TX only), "rgmii-rxid" (delay on RX only),
-  "tbi", or "rtbi".
-
-Example:
-	ucc@2000 {
-		device_type = "network";
-		compatible = "ucc_geth";
-		cell-index = <1>;
-		reg = <2000 200>;
-		interrupts = <a0 0>;
-		interrupt-parent = <700>;
-		mac-address = [ 00 04 9f 00 23 23 ];
-		rx-clock = "none";
-		tx-clock = "clk9";
-		phy-handle = <212000>;
-		phy-connection-type = "gmii";
-		pio-handle = <140001>;
-	};
diff --git a/Documentation/powerpc/dts-bindings/fsl/cpm_qe/qe/usb.txt b/Documentation/powerpc/dts-bindings/fsl/cpm_qe/qe/usb.txt
deleted file mode 100644
index 9ccd5f3..0000000
--- a/Documentation/powerpc/dts-bindings/fsl/cpm_qe/qe/usb.txt
+++ /dev/null
@@ -1,37 +0,0 @@
-Freescale QUICC Engine USB Controller
-
-Required properties:
-- compatible : should be "fsl,<chip>-qe-usb", "fsl,mpc8323-qe-usb".
-- reg : the first two cells should contain usb registers location and
-  length, the next two two cells should contain PRAM location and
-  length.
-- interrupts : should contain USB interrupt.
-- interrupt-parent : interrupt source phandle.
-- fsl,fullspeed-clock : specifies the full speed USB clock source:
-  "none": clock source is disabled
-  "brg1" through "brg16": clock source is BRG1-BRG16, respectively
-  "clk1" through "clk24": clock source is CLK1-CLK24, respectively
-- fsl,lowspeed-clock : specifies the low speed USB clock source:
-  "none": clock source is disabled
-  "brg1" through "brg16": clock source is BRG1-BRG16, respectively
-  "clk1" through "clk24": clock source is CLK1-CLK24, respectively
-- hub-power-budget : USB power budget for the root hub, in mA.
-- gpios : should specify GPIOs in this order: USBOE, USBTP, USBTN, USBRP,
-  USBRN, SPEED (optional), and POWER (optional).
-
-Example:
-
-usb@6c0 {
-	compatible = "fsl,mpc8360-qe-usb", "fsl,mpc8323-qe-usb";
-	reg = <0x6c0 0x40 0x8b00 0x100>;
-	interrupts = <11>;
-	interrupt-parent = <&qeic>;
-	fsl,fullspeed-clock = "clk21";
-	gpios = <&qe_pio_b  2 0 /* USBOE */
-		 &qe_pio_b  3 0 /* USBTP */
-		 &qe_pio_b  8 0 /* USBTN */
-		 &qe_pio_b  9 0 /* USBRP */
-		 &qe_pio_b 11 0 /* USBRN */
-		 &qe_pio_e 20 0 /* SPEED */
-		 &qe_pio_e 21 0 /* POWER */>;
-};
diff --git a/Documentation/powerpc/dts-bindings/fsl/cpm_qe/serial.txt b/Documentation/powerpc/dts-bindings/fsl/cpm_qe/serial.txt
deleted file mode 100644
index 2ea76d9..0000000
--- a/Documentation/powerpc/dts-bindings/fsl/cpm_qe/serial.txt
+++ /dev/null
@@ -1,32 +0,0 @@
-* Serial
-
-Currently defined compatibles:
-- fsl,cpm1-smc-uart
-- fsl,cpm2-smc-uart
-- fsl,cpm1-scc-uart
-- fsl,cpm2-scc-uart
-- fsl,qe-uart
-
-Modem control lines connected to GPIO controllers are listed in the gpios
-property as described in booting-without-of.txt, section IX.1 in the following
-order:
-
-CTS, RTS, DCD, DSR, DTR, and RI.
-
-The gpios property is optional and can be left out when control lines are
-not used.
-
-Example:
-
-	serial@11a00 {
-		device_type = "serial";
-		compatible = "fsl,mpc8272-scc-uart",
-			     "fsl,cpm2-scc-uart";
-		reg = <11a00 20 8000 100>;
-		interrupts = <28 8>;
-		interrupt-parent = <&PIC>;
-		fsl,cpm-brg = <1>;
-		fsl,cpm-command = <00800000>;
-		gpios = <&gpio_c 15 0
-			 &gpio_d 29 0>;
-	};
diff --git a/Documentation/powerpc/dts-bindings/fsl/diu.txt b/Documentation/powerpc/dts-bindings/fsl/diu.txt
deleted file mode 100644
index b66cb6d..0000000
--- a/Documentation/powerpc/dts-bindings/fsl/diu.txt
+++ /dev/null
@@ -1,34 +0,0 @@
-* Freescale Display Interface Unit
-
-The Freescale DIU is a LCD controller, with proper hardware, it can also
-drive DVI monitors.
-
-Required properties:
-- compatible : should be "fsl,diu" or "fsl,mpc5121-diu".
-- reg : should contain at least address and length of the DIU register
-  set.
-- interrupts : one DIU interrupt should be described here.
-- interrupt-parent : the phandle for the interrupt controller that
-  services interrupts for this device.
-
-Optional properties:
-- edid : verbatim EDID data block describing attached display.
-  Data from the detailed timing descriptor will be used to
-  program the display controller.
-
-Example (MPC8610HPCD):
-	display@2c000 {
-		compatible = "fsl,diu";
-		reg = <0x2c000 100>;
-		interrupts = <72 2>;
-		interrupt-parent = <&mpic>;
-	};
-
-Example for MPC5121:
-	display@2100 {
-		compatible = "fsl,mpc5121-diu";
-		reg = <0x2100 0x100>;
-		interrupts = <64 0x8>;
-		interrupt-parent = <&ipic>;
-		edid = [edid-data];
-	};
diff --git a/Documentation/powerpc/dts-bindings/fsl/dma.txt b/Documentation/powerpc/dts-bindings/fsl/dma.txt
deleted file mode 100644
index 2a4b4bc..0000000
--- a/Documentation/powerpc/dts-bindings/fsl/dma.txt
+++ /dev/null
@@ -1,144 +0,0 @@
-* Freescale 83xx DMA Controller
-
-Freescale PowerPC 83xx have on chip general purpose DMA controllers.
-
-Required properties:
-
-- compatible        : compatible list, contains 2 entries, first is
-		 "fsl,CHIP-dma", where CHIP is the processor
-		 (mpc8349, mpc8360, etc.) and the second is
-		 "fsl,elo-dma"
-- reg               : <registers mapping for DMA general status reg>
-- ranges		: Should be defined as specified in 1) to describe the
-		  DMA controller channels.
-- cell-index        : controller index.  0 for controller @ 0x8100
-- interrupts        : <interrupt mapping for DMA IRQ>
-- interrupt-parent  : optional, if needed for interrupt mapping
-
-
-- DMA channel nodes:
-        - compatible        : compatible list, contains 2 entries, first is
-			 "fsl,CHIP-dma-channel", where CHIP is the processor
-			 (mpc8349, mpc8350, etc.) and the second is
-			 "fsl,elo-dma-channel". However, see note below.
-        - reg               : <registers mapping for channel>
-        - cell-index        : dma channel index starts at 0.
-
-Optional properties:
-        - interrupts        : <interrupt mapping for DMA channel IRQ>
-			  (on 83xx this is expected to be identical to
-			   the interrupts property of the parent node)
-        - interrupt-parent  : optional, if needed for interrupt mapping
-
-Example:
-	dma@82a8 {
-		#address-cells = <1>;
-		#size-cells = <1>;
-		compatible = "fsl,mpc8349-dma", "fsl,elo-dma";
-		reg = <0x82a8 4>;
-		ranges = <0 0x8100 0x1a4>;
-		interrupt-parent = <&ipic>;
-		interrupts = <71 8>;
-		cell-index = <0>;
-		dma-channel@0 {
-			compatible = "fsl,mpc8349-dma-channel", "fsl,elo-dma-channel";
-			cell-index = <0>;
-			reg = <0 0x80>;
-			interrupt-parent = <&ipic>;
-			interrupts = <71 8>;
-		};
-		dma-channel@80 {
-			compatible = "fsl,mpc8349-dma-channel", "fsl,elo-dma-channel";
-			cell-index = <1>;
-			reg = <0x80 0x80>;
-			interrupt-parent = <&ipic>;
-			interrupts = <71 8>;
-		};
-		dma-channel@100 {
-			compatible = "fsl,mpc8349-dma-channel", "fsl,elo-dma-channel";
-			cell-index = <2>;
-			reg = <0x100 0x80>;
-			interrupt-parent = <&ipic>;
-			interrupts = <71 8>;
-		};
-		dma-channel@180 {
-			compatible = "fsl,mpc8349-dma-channel", "fsl,elo-dma-channel";
-			cell-index = <3>;
-			reg = <0x180 0x80>;
-			interrupt-parent = <&ipic>;
-			interrupts = <71 8>;
-		};
-	};
-
-* Freescale 85xx/86xx DMA Controller
-
-Freescale PowerPC 85xx/86xx have on chip general purpose DMA controllers.
-
-Required properties:
-
-- compatible        : compatible list, contains 2 entries, first is
-		 "fsl,CHIP-dma", where CHIP is the processor
-		 (mpc8540, mpc8540, etc.) and the second is
-		 "fsl,eloplus-dma"
-- reg               : <registers mapping for DMA general status reg>
-- cell-index        : controller index.  0 for controller @ 0x21000,
-                                         1 for controller @ 0xc000
-- ranges		: Should be defined as specified in 1) to describe the
-		  DMA controller channels.
-
-- DMA channel nodes:
-        - compatible        : compatible list, contains 2 entries, first is
-			 "fsl,CHIP-dma-channel", where CHIP is the processor
-			 (mpc8540, mpc8560, etc.) and the second is
-			 "fsl,eloplus-dma-channel". However, see note below.
-        - cell-index        : dma channel index starts at 0.
-        - reg               : <registers mapping for channel>
-        - interrupts        : <interrupt mapping for DMA channel IRQ>
-        - interrupt-parent  : optional, if needed for interrupt mapping
-
-Example:
-	dma@21300 {
-		#address-cells = <1>;
-		#size-cells = <1>;
-		compatible = "fsl,mpc8540-dma", "fsl,eloplus-dma";
-		reg = <0x21300 4>;
-		ranges = <0 0x21100 0x200>;
-		cell-index = <0>;
-		dma-channel@0 {
-			compatible = "fsl,mpc8540-dma-channel", "fsl,eloplus-dma-channel";
-			reg = <0 0x80>;
-			cell-index = <0>;
-			interrupt-parent = <&mpic>;
-			interrupts = <20 2>;
-		};
-		dma-channel@80 {
-			compatible = "fsl,mpc8540-dma-channel", "fsl,eloplus-dma-channel";
-			reg = <0x80 0x80>;
-			cell-index = <1>;
-			interrupt-parent = <&mpic>;
-			interrupts = <21 2>;
-		};
-		dma-channel@100 {
-			compatible = "fsl,mpc8540-dma-channel", "fsl,eloplus-dma-channel";
-			reg = <0x100 0x80>;
-			cell-index = <2>;
-			interrupt-parent = <&mpic>;
-			interrupts = <22 2>;
-		};
-		dma-channel@180 {
-			compatible = "fsl,mpc8540-dma-channel", "fsl,eloplus-dma-channel";
-			reg = <0x180 0x80>;
-			cell-index = <3>;
-			interrupt-parent = <&mpic>;
-			interrupts = <23 2>;
-		};
-	};
-
-Note on DMA channel compatible properties: The compatible property must say
-"fsl,elo-dma-channel" or "fsl,eloplus-dma-channel" to be used by the Elo DMA
-driver (fsldma).  Any DMA channel used by fsldma cannot be used by another
-DMA driver, such as the SSI sound drivers for the MPC8610.  Therefore, any DMA
-channel that should be used for another driver should not use
-"fsl,elo-dma-channel" or "fsl,eloplus-dma-channel".  For the SSI drivers, for
-example, the compatible property should be "fsl,ssi-dma-channel".  See ssi.txt
-for more information.
diff --git a/Documentation/powerpc/dts-bindings/fsl/esdhc.txt b/Documentation/powerpc/dts-bindings/fsl/esdhc.txt
deleted file mode 100644
index 64bcb8b..0000000
--- a/Documentation/powerpc/dts-bindings/fsl/esdhc.txt
+++ /dev/null
@@ -1,29 +0,0 @@
-* Freescale Enhanced Secure Digital Host Controller (eSDHC)
-
-The Enhanced Secure Digital Host Controller provides an interface
-for MMC, SD, and SDIO types of memory cards.
-
-Required properties:
-  - compatible : should be
-    "fsl,<chip>-esdhc", "fsl,esdhc"
-  - reg : should contain eSDHC registers location and length.
-  - interrupts : should contain eSDHC interrupt.
-  - interrupt-parent : interrupt source phandle.
-  - clock-frequency : specifies eSDHC base clock frequency.
-  - sdhci,wp-inverted : (optional) specifies that eSDHC controller
-    reports inverted write-protect state;
-  - sdhci,1-bit-only : (optional) specifies that a controller can
-    only handle 1-bit data transfers.
-  - sdhci,auto-cmd12: (optional) specifies that a controller can
-    only handle auto CMD12.
-
-Example:
-
-sdhci@2e000 {
-	compatible = "fsl,mpc8378-esdhc", "fsl,esdhc";
-	reg = <0x2e000 0x1000>;
-	interrupts = <42 0x8>;
-	interrupt-parent = <&ipic>;
-	/* Filled in by U-Boot */
-	clock-frequency = <0>;
-};
diff --git a/Documentation/powerpc/dts-bindings/fsl/gtm.txt b/Documentation/powerpc/dts-bindings/fsl/gtm.txt
deleted file mode 100644
index 9a33efd..0000000
--- a/Documentation/powerpc/dts-bindings/fsl/gtm.txt
+++ /dev/null
@@ -1,31 +0,0 @@
-* Freescale General-purpose Timers Module
-
-Required properties:
-  - compatible : should be
-    "fsl,<chip>-gtm", "fsl,gtm" for SOC GTMs
-    "fsl,<chip>-qe-gtm", "fsl,qe-gtm", "fsl,gtm" for QE GTMs
-    "fsl,<chip>-cpm2-gtm", "fsl,cpm2-gtm", "fsl,gtm" for CPM2 GTMs
-  - reg : should contain gtm registers location and length (0x40).
-  - interrupts : should contain four interrupts.
-  - interrupt-parent : interrupt source phandle.
-  - clock-frequency : specifies the frequency driving the timer.
-
-Example:
-
-timer@500 {
-	compatible = "fsl,mpc8360-gtm", "fsl,gtm";
-	reg = <0x500 0x40>;
-	interrupts = <90 8 78 8 84 8 72 8>;
-	interrupt-parent = <&ipic>;
-	/* filled by u-boot */
-	clock-frequency = <0>;
-};
-
-timer@440 {
-	compatible = "fsl,mpc8360-qe-gtm", "fsl,qe-gtm", "fsl,gtm";
-	reg = <0x440 0x40>;
-	interrupts = <12 13 14 15>;
-	interrupt-parent = <&qeic>;
-	/* filled by u-boot */
-	clock-frequency = <0>;
-};
diff --git a/Documentation/powerpc/dts-bindings/fsl/guts.txt b/Documentation/powerpc/dts-bindings/fsl/guts.txt
deleted file mode 100644
index 9e7a241..0000000
--- a/Documentation/powerpc/dts-bindings/fsl/guts.txt
+++ /dev/null
@@ -1,25 +0,0 @@
-* Global Utilities Block
-
-The global utilities block controls power management, I/O device
-enabling, power-on-reset configuration monitoring, general-purpose
-I/O signal configuration, alternate function selection for multiplexed
-signals, and clock control.
-
-Required properties:
-
- - compatible : Should define the compatible device type for
-   global-utilities.
- - reg : Offset and length of the register set for the device.
-
-Recommended properties:
-
- - fsl,has-rstcr : Indicates that the global utilities register set
-   contains a functioning "reset control register" (i.e. the board
-   is wired to reset upon setting the HRESET_REQ bit in this register).
-
-Example:
-	global-utilities@e0000 {	/* global utilities block */
-		compatible = "fsl,mpc8548-guts";
-		reg = <e0000 1000>;
-		fsl,has-rstcr;
-	};
diff --git a/Documentation/powerpc/dts-bindings/fsl/i2c.txt b/Documentation/powerpc/dts-bindings/fsl/i2c.txt
deleted file mode 100644
index 1eacd6b..0000000
--- a/Documentation/powerpc/dts-bindings/fsl/i2c.txt
+++ /dev/null
@@ -1,64 +0,0 @@
-* I2C
-
-Required properties :
-
- - reg : Offset and length of the register set for the device
- - compatible : should be "fsl,CHIP-i2c" where CHIP is the name of a
-   compatible processor, e.g. mpc8313, mpc8543, mpc8544, mpc5121,
-   mpc5200 or mpc5200b. For the mpc5121, an additional node
-   "fsl,mpc5121-i2c-ctrl" is required as shown in the example below.
-
-Recommended properties :
-
- - interrupts : <a b> where a is the interrupt number and b is a
-   field that represents an encoding of the sense and level
-   information for the interrupt.  This should be encoded based on
-   the information in section 2) depending on the type of interrupt
-   controller you have.
- - interrupt-parent : the phandle for the interrupt controller that
-   services interrupts for this device.
- - fsl,preserve-clocking : boolean; if defined, the clock settings
-   from the bootloader are preserved (not touched).
- - clock-frequency : desired I2C bus clock frequency in Hz.
- - fsl,timeout : I2C bus timeout in microseconds.
-
-Examples :
-
-	/* MPC5121 based board */
-	i2c@1740 {
-		#address-cells = <1>;
-		#size-cells = <0>;
-		compatible = "fsl,mpc5121-i2c", "fsl-i2c";
-		reg = <0x1740 0x20>;
-		interrupts = <11 0x8>;
-		interrupt-parent = <&ipic>;
-		clock-frequency = <100000>;
-	};
-
-	i2ccontrol@1760 {
-		compatible = "fsl,mpc5121-i2c-ctrl";
-		reg = <0x1760 0x8>;
-	};
-
-	/* MPC5200B based board */
-	i2c@3d00 {
-		#address-cells = <1>;
-		#size-cells = <0>;
-		compatible = "fsl,mpc5200b-i2c","fsl,mpc5200-i2c","fsl-i2c";
-		reg = <0x3d00 0x40>;
-		interrupts = <2 15 0>;
-		interrupt-parent = <&mpc5200_pic>;
-		fsl,preserve-clocking;
-	};
-
-	/* MPC8544 base board */
-	i2c@3100 {
-		#address-cells = <1>;
-		#size-cells = <0>;
-		compatible = "fsl,mpc8544-i2c", "fsl-i2c";
-		reg = <0x3100 0x100>;
-		interrupts = <43 2>;
-		interrupt-parent = <&mpic>;
-		clock-frequency = <400000>;
-		fsl,timeout = <10000>;
-	};
diff --git a/Documentation/powerpc/dts-bindings/fsl/lbc.txt b/Documentation/powerpc/dts-bindings/fsl/lbc.txt
deleted file mode 100644
index 3300fec..0000000
--- a/Documentation/powerpc/dts-bindings/fsl/lbc.txt
+++ /dev/null
@@ -1,35 +0,0 @@
-* Chipselect/Local Bus
-
-Properties:
-- name : Should be localbus
-- #address-cells : Should be either two or three.  The first cell is the
-                   chipselect number, and the remaining cells are the
-                   offset into the chipselect.
-- #size-cells : Either one or two, depending on how large each chipselect
-                can be.
-- ranges : Each range corresponds to a single chipselect, and cover
-           the entire access window as configured.
-
-Example:
-	localbus@f0010100 {
-		compatible = "fsl,mpc8272-localbus",
-			   "fsl,pq2-localbus";
-		#address-cells = <2>;
-		#size-cells = <1>;
-		reg = <f0010100 40>;
-
-		ranges = <0 0 fe000000 02000000
-			  1 0 f4500000 00008000>;
-
-		flash@0,0 {
-			compatible = "jedec-flash";
-			reg = <0 0 2000000>;
-			bank-width = <4>;
-			device-width = <1>;
-		};
-
-		board-control@1,0 {
-			reg = <1 0 20>;
-			compatible = "fsl,mpc8272ads-bcsr";
-		};
-	};
diff --git a/Documentation/powerpc/dts-bindings/fsl/mcm.txt b/Documentation/powerpc/dts-bindings/fsl/mcm.txt
deleted file mode 100644
index 4ceda9b..0000000
--- a/Documentation/powerpc/dts-bindings/fsl/mcm.txt
+++ /dev/null
@@ -1,64 +0,0 @@
-=====================================================================
-MPX LAW & Coherency Module Device Tree Binding
-Copyright (C) 2009 Freescale Semiconductor Inc.
-=====================================================================
-
-Local Access Window (LAW) Node
-
-The LAW node represents the region of CCSR space where local access
-windows are configured.  For MCM based devices this is the first 4k
-of CCSR space that includes CCSRBAR, ALTCBAR, ALTCAR, BPTR, and some
-number of local access windows as specified by fsl,num-laws.
-
-PROPERTIES
-
-  - compatible
-      Usage: required
-      Value type: <string>
-      Definition: Must include "fsl,mcm-law"
-
-  - reg
-      Usage: required
-      Value type: <prop-encoded-array>
-      Definition: A standard property.  The value specifies the
-          physical address offset and length of the CCSR space
-          registers.
-
-  - fsl,num-laws
-      Usage: required
-      Value type: <u32>
-      Definition: The value specifies the number of local access
-          windows for this device.
-
-=====================================================================
-
-MPX Coherency Module Node
-
-The MPX LAW node represents the region of CCSR space where MCM config
-and error reporting registers exist, this is the second 4k (0x1000)
-of CCSR space.
-
-PROPERTIES
-
-  - compatible
-      Usage: required
-      Value type: <string>
-      Definition: Must include "fsl,CHIP-mcm", "fsl,mcm" where
-      CHIP is the processor (mpc8641, mpc8610, etc.)
-
-  - reg
-      Usage: required
-      Value type: <prop-encoded-array>
-      Definition: A standard property.  The value specifies the
-          physical address offset and length of the CCSR space
-          registers.
-
-   - interrupts
-      Usage: required
-      Value type: <prop-encoded-array>
-
-   - interrupt-parent
-      Usage: required
-      Value type: <phandle>
-
-=====================================================================
diff --git a/Documentation/powerpc/dts-bindings/fsl/mcu-mpc8349emitx.txt b/Documentation/powerpc/dts-bindings/fsl/mcu-mpc8349emitx.txt
deleted file mode 100644
index 0f76633..0000000
--- a/Documentation/powerpc/dts-bindings/fsl/mcu-mpc8349emitx.txt
+++ /dev/null
@@ -1,17 +0,0 @@
-Freescale MPC8349E-mITX-compatible Power Management Micro Controller Unit (MCU)
-
-Required properties:
-- compatible : "fsl,<mcu-chip>-<board>", "fsl,mcu-mpc8349emitx".
-- reg : should specify I2C address (0x0a).
-- #gpio-cells : should be 2.
-- gpio-controller : should be present.
-
-Example:
-
-mcu@0a {
-	#gpio-cells = <2>;
-	compatible = "fsl,mc9s08qg8-mpc8349emitx",
-		     "fsl,mcu-mpc8349emitx";
-	reg = <0x0a>;
-	gpio-controller;
-};
diff --git a/Documentation/powerpc/dts-bindings/fsl/mpc5121-psc.txt b/Documentation/powerpc/dts-bindings/fsl/mpc5121-psc.txt
deleted file mode 100644
index 8832e87..0000000
--- a/Documentation/powerpc/dts-bindings/fsl/mpc5121-psc.txt
+++ /dev/null
@@ -1,70 +0,0 @@
-MPC5121 PSC Device Tree Bindings
-
-PSC in UART mode
-----------------
-
-For PSC in UART mode the needed PSC serial devices
-are specified by fsl,mpc5121-psc-uart nodes in the
-fsl,mpc5121-immr SoC node. Additionally the PSC FIFO
-Controller node fsl,mpc5121-psc-fifo is requered there:
-
-fsl,mpc5121-psc-uart nodes
---------------------------
-
-Required properties :
- - compatible : Should contain "fsl,mpc5121-psc-uart" and "fsl,mpc5121-psc"
- - cell-index : Index of the PSC in hardware
- - reg : Offset and length of the register set for the PSC device
- - interrupts : <a b> where a is the interrupt number of the
-   PSC FIFO Controller and b is a field that represents an
-   encoding of the sense and level information for the interrupt.
- - interrupt-parent : the phandle for the interrupt controller that
-   services interrupts for this device.
-
-Recommended properties :
- - fsl,rx-fifo-size : the size of the RX fifo slice (a multiple of 4)
- - fsl,tx-fifo-size : the size of the TX fifo slice (a multiple of 4)
-
-
-fsl,mpc5121-psc-fifo node
--------------------------
-
-Required properties :
- - compatible : Should be "fsl,mpc5121-psc-fifo"
- - reg : Offset and length of the register set for the PSC
-         FIFO Controller
- - interrupts : <a b> where a is the interrupt number of the
-   PSC FIFO Controller and b is a field that represents an
-   encoding of the sense and level information for the interrupt.
- - interrupt-parent : the phandle for the interrupt controller that
-   services interrupts for this device.
-
-
-Example for a board using PSC0 and PSC1 devices in serial mode:
-
-serial@11000 {
-	compatible = "fsl,mpc5121-psc-uart", "fsl,mpc5121-psc";
-	cell-index = <0>;
-	reg = <0x11000 0x100>;
-	interrupts = <40 0x8>;
-	interrupt-parent = < &ipic >;
-	fsl,rx-fifo-size = <16>;
-	fsl,tx-fifo-size = <16>;
-};
-
-serial@11100 {
-	compatible = "fsl,mpc5121-psc-uart", "fsl,mpc5121-psc";
-	cell-index = <1>;
-	reg = <0x11100 0x100>;
-	interrupts = <40 0x8>;
-	interrupt-parent = < &ipic >;
-	fsl,rx-fifo-size = <16>;
-	fsl,tx-fifo-size = <16>;
-};
-
-pscfifo@11f00 {
-	compatible = "fsl,mpc5121-psc-fifo";
-	reg = <0x11f00 0x100>;
-	interrupts = <40 0x8>;
-	interrupt-parent = < &ipic >;
-};
diff --git a/Documentation/powerpc/dts-bindings/fsl/mpc5200.txt b/Documentation/powerpc/dts-bindings/fsl/mpc5200.txt
deleted file mode 100644
index 4ccb2cd..0000000
--- a/Documentation/powerpc/dts-bindings/fsl/mpc5200.txt
+++ /dev/null
@@ -1,198 +0,0 @@
-MPC5200 Device Tree Bindings
-----------------------------
-
-(c) 2006-2009 Secret Lab Technologies Ltd
-Grant Likely <grant.likely@secretlab.ca>
-
-Naming conventions
-------------------
-For mpc5200 on-chip devices, the format for each compatible value is
-<chip>-<device>[-<mode>].  The OS should be able to match a device driver
-to the device based solely on the compatible value.  If two drivers
-match on the compatible list; the 'most compatible' driver should be
-selected.
-
-The split between the MPC5200 and the MPC5200B leaves a bit of a
-conundrum.  How should the compatible property be set up to provide
-maximum compatibility information; but still accurately describe the
-chip?  For the MPC5200; the answer is easy.  Most of the SoC devices
-originally appeared on the MPC5200.  Since they didn't exist anywhere
-else; the 5200 compatible properties will contain only one item;
-"fsl,mpc5200-<device>".
-
-The 5200B is almost the same as the 5200, but not quite.  It fixes
-silicon bugs and it adds a small number of enhancements.  Most of the
-devices either provide exactly the same interface as on the 5200.  A few
-devices have extra functions but still have a backwards compatible mode.
-To express this information as completely as possible, 5200B device trees
-should have two items in the compatible list:
-	compatible = "fsl,mpc5200b-<device>","fsl,mpc5200-<device>";
-
-It is *strongly* recommended that 5200B device trees follow this convention
-(instead of only listing the base mpc5200 item).
-
-ie. ethernet on mpc5200: compatible = "fsl,mpc5200-fec";
-    ethernet on mpc5200b: compatible = "fsl,mpc5200b-fec", "fsl,mpc5200-fec";
-
-Modal devices, like PSCs, also append the configured function to the
-end of the compatible field.  ie. A PSC in i2s mode would specify
-"fsl,mpc5200-psc-i2s", not "fsl,mpc5200-i2s".  This convention is chosen to
-avoid naming conflicts with non-psc devices providing the same
-function.  For example, "fsl,mpc5200-spi" and "fsl,mpc5200-psc-spi" describe
-the mpc5200 simple spi device and a PSC spi mode respectively.
-
-At the time of writing, exact chip may be either 'fsl,mpc5200' or
-'fsl,mpc5200b'.
-
-The soc node
-------------
-This node describes the on chip SOC peripherals.  Every mpc5200 based
-board will have this node, and as such there is a common naming
-convention for SOC devices.
-
-Required properties:
-name			description
-----			-----------
-ranges			Memory range of the internal memory mapped registers.
-			Should be <0 [baseaddr] 0xc000>
-reg			Should be <[baseaddr] 0x100>
-compatible		mpc5200: "fsl,mpc5200-immr"
-			mpc5200b: "fsl,mpc5200b-immr"
-system-frequency	'fsystem' frequency in Hz; XLB, IPB, USB and PCI
-			clocks are derived from the fsystem clock.
-bus-frequency		IPB bus frequency in Hz.  Clock rate
-			used by most of the soc devices.
-
-soc child nodes
----------------
-Any on chip SOC devices available to Linux must appear as soc5200 child nodes.
-
-Note: The tables below show the value for the mpc5200.  A mpc5200b device
-tree should use the "fsl,mpc5200b-<device>","fsl,mpc5200-<device>" form.
-
-Required soc5200 child nodes:
-name				compatible		Description
-----				----------		-----------
-cdm@<addr>			fsl,mpc5200-cdm		Clock Distribution
-interrupt-controller@<addr>	fsl,mpc5200-pic		need an interrupt
-							controller to boot
-bestcomm@<addr>			fsl,mpc5200-bestcomm	Bestcomm DMA controller
-
-Recommended soc5200 child nodes; populate as needed for your board
-name		compatible		Description
-----		----------		-----------
-timer@<addr>	fsl,mpc5200-gpt		 General purpose timers
-gpio@<addr>	fsl,mpc5200-gpio	 MPC5200 simple gpio controller
-gpio@<addr>	fsl,mpc5200-gpio-wkup	 MPC5200 wakeup gpio controller
-rtc@<addr>	fsl,mpc5200-rtc		 Real time clock
-mscan@<addr>	fsl,mpc5200-mscan	 CAN bus controller
-pci@<addr>	fsl,mpc5200-pci		 PCI bridge
-serial@<addr>	fsl,mpc5200-psc-uart	 PSC in serial mode
-i2s@<addr>	fsl,mpc5200-psc-i2s	 PSC in i2s mode
-ac97@<addr>	fsl,mpc5200-psc-ac97	 PSC in ac97 mode
-spi@<addr>	fsl,mpc5200-psc-spi	 PSC in spi mode
-irda@<addr>	fsl,mpc5200-psc-irda	 PSC in IrDA mode
-spi@<addr>	fsl,mpc5200-spi		 MPC5200 spi device
-ethernet@<addr>	fsl,mpc5200-fec		 MPC5200 ethernet device
-ata@<addr>	fsl,mpc5200-ata		 IDE ATA interface
-i2c@<addr>	fsl,mpc5200-i2c		 I2C controller
-usb@<addr>	fsl,mpc5200-ohci,ohci-be USB controller
-xlb@<addr>	fsl,mpc5200-xlb		 XLB arbitrator
-
-fsl,mpc5200-gpt nodes
----------------------
-On the mpc5200 and 5200b, GPT0 has a watchdog timer function.  If the board
-design supports the internal wdt, then the device node for GPT0 should
-include the empty property 'fsl,has-wdt'.  Note that this does not activate
-the watchdog.  The timer will function as a GPT if the timer api is used, and
-it will function as watchdog if the watchdog device is used.  The watchdog
-mode has priority over the gpt mode, i.e. if the watchdog is activated, any
-gpt api call to this timer will fail with -EBUSY.
-
-If you add the property
-	fsl,wdt-on-boot = <n>;
-GPT0 will be marked as in-use watchdog, i.e. blocking every gpt access to it.
-If n>0, the watchdog is started with a timeout of n seconds.  If n=0, the
-configuration of the watchdog is not touched.  This is useful in two cases:
-- just mark GPT0 as watchdog, blocking gpt accesses, and configure it later;
-- do not touch a configuration assigned by the boot loader which supervises
-  the boot process itself.
-
-The watchdog will respect the CONFIG_WATCHDOG_NOWAYOUT option.
-
-An mpc5200-gpt can be used as a single line GPIO controller.  To do so,
-add the following properties to the gpt node:
-	gpio-controller;
-	#gpio-cells = <2>;
-When referencing the GPIO line from another node, the first cell must always
-be zero and the second cell represents the gpio flags and described in the
-gpio device tree binding.
-
-An mpc5200-gpt can be used as a single line edge sensitive interrupt
-controller.  To do so, add the following properties to the gpt node:
-	interrupt-controller;
-	#interrupt-cells = <1>;
-When referencing the IRQ line from another node, the cell represents the
-sense mode; 1 for edge rising, 2 for edge falling.
-
-fsl,mpc5200-psc nodes
----------------------
-The PSCs should include a cell-index which is the index of the PSC in
-hardware.  cell-index is used to determine which shared SoC registers to
-use when setting up PSC clocking.  cell-index number starts at '0'.  ie:
-	PSC1 has 'cell-index = <0>'
-	PSC4 has 'cell-index = <3>'
-
-PSC in i2s mode:  The mpc5200 and mpc5200b PSCs are not compatible when in
-i2s mode.  An 'mpc5200b-psc-i2s' node cannot include 'mpc5200-psc-i2s' in the
-compatible field.
-
-
-fsl,mpc5200-gpio and fsl,mpc5200-gpio-wkup nodes
-------------------------------------------------
-Each GPIO controller node should have the empty property gpio-controller and
-#gpio-cells set to 2. First cell is the GPIO number which is interpreted
-according to the bit numbers in the GPIO control registers. The second cell
-is for flags which is currently unused.
-
-fsl,mpc5200-fec nodes
----------------------
-The FEC node can specify one of the following properties to configure
-the MII link:
-- fsl,7-wire-mode - An empty property that specifies the link uses 7-wire
-                    mode instead of MII
-- current-speed   - Specifies that the MII should be configured for a fixed
-                    speed.  This property should contain two cells.  The
-                    first cell specifies the speed in Mbps and the second
-                    should be '0' for half duplex and '1' for full duplex
-- phy-handle      - Contains a phandle to an Ethernet PHY.
-
-Interrupt controller (fsl,mpc5200-pic) node
--------------------------------------------
-The mpc5200 pic binding splits hardware IRQ numbers into two levels.  The
-split reflects the layout of the PIC hardware itself, which groups
-interrupts into one of three groups; CRIT, MAIN or PERP.  Also, the
-Bestcomm dma engine has it's own set of interrupt sources which are
-cascaded off of peripheral interrupt 0, which the driver interprets as a
-fourth group, SDMA.
-
-The interrupts property for device nodes using the mpc5200 pic consists
-of three cells; <L1 L2 level>
-
-    L1 := [CRIT=0, MAIN=1, PERP=2, SDMA=3]
-    L2 := interrupt number; directly mapped from the value in the
-          "ICTL PerStat, MainStat, CritStat Encoded Register"
-    level := [LEVEL_HIGH=0, EDGE_RISING=1, EDGE_FALLING=2, LEVEL_LOW=3]
-
-For external IRQs, use the following interrupt property values (how to
-specify external interrupts is a frequently asked question):
-External interrupts:
-	external irq0:	interrupts = <0 0 n>;
-	external irq1:	interrupts = <1 1 n>;
-	external irq2:	interrupts = <1 2 n>;
-	external irq3:	interrupts = <1 3 n>;
-'n' is sense (0: level high, 1: edge rising, 2: edge falling 3: level low)
-
-fsl,mpc5200-mscan nodes
------------------------
-See file can.txt in this directory.
diff --git a/Documentation/powerpc/dts-bindings/fsl/mpic.txt b/Documentation/powerpc/dts-bindings/fsl/mpic.txt
deleted file mode 100644
index 71e39cf..0000000
--- a/Documentation/powerpc/dts-bindings/fsl/mpic.txt
+++ /dev/null
@@ -1,42 +0,0 @@
-* OpenPIC and its interrupt numbers on Freescale's e500/e600 cores
-
-The OpenPIC specification does not specify which interrupt source has to
-become which interrupt number. This is up to the software implementation
-of the interrupt controller. The only requirement is that every
-interrupt source has to have an unique interrupt number / vector number.
-To accomplish this the current implementation assigns the number zero to
-the first source, the number one to the second source and so on until
-all interrupt sources have their unique number.
-Usually the assigned vector number equals the interrupt number mentioned
-in the documentation for a given core / CPU. This is however not true
-for the e500 cores (MPC85XX CPUs) where the documentation distinguishes
-between internal and external interrupt sources and starts counting at
-zero for both of them.
-
-So what to write for external interrupt source X or internal interrupt
-source Y into the device tree? Here is an example:
-
-The memory map for the interrupt controller in the MPC8544[0] shows,
-that the first interrupt source starts at 0x5_0000 (PIC Register Address
-Map-Interrupt Source Configuration Registers). This source becomes the
-number zero therefore:
- External interrupt 0 = interrupt number 0
- External interrupt 1 = interrupt number 1
- External interrupt 2 = interrupt number 2
- ...
-Every interrupt number allocates 0x20 bytes register space. So to get
-its number it is sufficient to shift the lower 16bits to right by five.
-So for the external interrupt 10 we have:
-  0x0140 >> 5 = 10
-
-After the external sources, the internal sources follow. The in core I2C
-controller on the MPC8544 for instance has the internal source number
-27. Oo obtain its interrupt number we take the lower 16bits of its memory
-address (0x5_0560) and shift it right:
- 0x0560 >> 5 = 43
-
-Therefore the I2C device node for the MPC8544 CPU has to have the
-interrupt number 43 specified in the device tree.
-
-[0] MPC8544E PowerQUICCTM III, Integrated Host Processor Family Reference Manual
-    MPC8544ERM Rev. 1 10/2007
diff --git a/Documentation/powerpc/dts-bindings/fsl/msi-pic.txt b/Documentation/powerpc/dts-bindings/fsl/msi-pic.txt
deleted file mode 100644
index bcc30ba..0000000
--- a/Documentation/powerpc/dts-bindings/fsl/msi-pic.txt
+++ /dev/null
@@ -1,36 +0,0 @@
-* Freescale MSI interrupt controller
-
-Required properties:
-- compatible : compatible list, contains 2 entries,
-  first is "fsl,CHIP-msi", where CHIP is the processor(mpc8610, mpc8572,
-  etc.) and the second is "fsl,mpic-msi" or "fsl,ipic-msi" depending on
-  the parent type.
-- reg : should contain the address and the length of the shared message
-  interrupt register set.
-- msi-available-ranges: use <start count> style section to define which
-  msi interrupt can be used in the 256 msi interrupts. This property is
-  optional, without this, all the 256 MSI interrupts can be used.
-- interrupts : each one of the interrupts here is one entry per 32 MSIs,
-  and routed to the host interrupt controller. the interrupts should
-  be set as edge sensitive.
-- interrupt-parent: the phandle for the interrupt controller
-  that services interrupts for this device. for 83xx cpu, the interrupts
-  are routed to IPIC, and for 85xx/86xx cpu the interrupts are routed
-  to MPIC.
-
-Example:
-	msi@41600 {
-		compatible = "fsl,mpc8610-msi", "fsl,mpic-msi";
-		reg = <0x41600 0x80>;
-		msi-available-ranges = <0 0x100>;
-		interrupts = <
-			0xe0 0
-			0xe1 0
-			0xe2 0
-			0xe3 0
-			0xe4 0
-			0xe5 0
-			0xe6 0
-			0xe7 0>;
-		interrupt-parent = <&mpic>;
-	};
diff --git a/Documentation/powerpc/dts-bindings/fsl/pmc.txt b/Documentation/powerpc/dts-bindings/fsl/pmc.txt
deleted file mode 100644
index 07256b7..0000000
--- a/Documentation/powerpc/dts-bindings/fsl/pmc.txt
+++ /dev/null
@@ -1,63 +0,0 @@
-* Power Management Controller
-
-Properties:
-- compatible: "fsl,<chip>-pmc".
-
-  "fsl,mpc8349-pmc" should be listed for any chip whose PMC is
-  compatible.  "fsl,mpc8313-pmc" should also be listed for any chip
-  whose PMC is compatible, and implies deep-sleep capability.
-
-  "fsl,mpc8548-pmc" should be listed for any chip whose PMC is
-  compatible.  "fsl,mpc8536-pmc" should also be listed for any chip
-  whose PMC is compatible, and implies deep-sleep capability.
-
-  "fsl,mpc8641d-pmc" should be listed for any chip whose PMC is
-  compatible; all statements below that apply to "fsl,mpc8548-pmc" also
-  apply to "fsl,mpc8641d-pmc".
-
-  Compatibility does not include bit assignments in SCCR/PMCDR/DEVDISR; these
-  bit assignments are indicated via the sleep specifier in each device's
-  sleep property.
-
-- reg: For devices compatible with "fsl,mpc8349-pmc", the first resource
-  is the PMC block, and the second resource is the Clock Configuration
-  block.
-
-  For devices compatible with "fsl,mpc8548-pmc", the first resource
-  is a 32-byte block beginning with DEVDISR.
-
-- interrupts: For "fsl,mpc8349-pmc"-compatible devices, the first
-  resource is the PMC block interrupt.
-
-- fsl,mpc8313-wakeup-timer: For "fsl,mpc8313-pmc"-compatible devices,
-  this is a phandle to an "fsl,gtm" node on which timer 4 can be used as
-  a wakeup source from deep sleep.
-
-Sleep specifiers:
-
-  fsl,mpc8349-pmc: Sleep specifiers consist of one cell.  For each bit
-  that is set in the cell, the corresponding bit in SCCR will be saved
-  and cleared on suspend, and restored on resume.  This sleep controller
-  supports disabling and resuming devices at any time.
-
-  fsl,mpc8536-pmc: Sleep specifiers consist of three cells, the third of
-  which will be ORed into PMCDR upon suspend, and cleared from PMCDR
-  upon resume.  The first two cells are as described for fsl,mpc8578-pmc.
-  This sleep controller only supports disabling devices during system
-  sleep, or permanently.
-
-  fsl,mpc8548-pmc: Sleep specifiers consist of one or two cells, the
-  first of which will be ORed into DEVDISR (and the second into
-  DEVDISR2, if present -- this cell should be zero or absent if the
-  hardware does not have DEVDISR2) upon a request for permanent device
-  disabling.  This sleep controller does not support configuring devices
-  to disable during system sleep (unless supported by another compatible
-  match), or dynamically.
-
-Example:
-
-	power@b00 {
-		compatible = "fsl,mpc8313-pmc", "fsl,mpc8349-pmc";
-		reg = <0xb00 0x100 0xa00 0x100>;
-		interrupts = <80 8>;
-	};
diff --git a/Documentation/powerpc/dts-bindings/fsl/sata.txt b/Documentation/powerpc/dts-bindings/fsl/sata.txt
deleted file mode 100644
index b46bcf4..0000000
--- a/Documentation/powerpc/dts-bindings/fsl/sata.txt
+++ /dev/null
@@ -1,29 +0,0 @@
-* Freescale 8xxx/3.0 Gb/s SATA nodes
-
-SATA nodes are defined to describe on-chip Serial ATA controllers.
-Each SATA port should have its own node.
-
-Required properties:
-- compatible        : compatible list, contains 2 entries, first is
-		 "fsl,CHIP-sata", where CHIP is the processor
-		 (mpc8315, mpc8379, etc.) and the second is
-		 "fsl,pq-sata"
-- interrupts        : <interrupt mapping for SATA IRQ>
-- cell-index        : controller index.
-                          1 for controller @ 0x18000
-                          2 for controller @ 0x19000
-                          3 for controller @ 0x1a000
-                          4 for controller @ 0x1b000
-
-Optional properties:
-- interrupt-parent  : optional, if needed for interrupt mapping
-- reg               : <registers mapping>
-
-Example:
-	sata@18000 {
-		compatible = "fsl,mpc8379-sata", "fsl,pq-sata";
-		reg = <0x18000 0x1000>;
-		cell-index = <1>;
-		interrupts = <2c 8>;
-		interrupt-parent = < &ipic >;
-	};
diff --git a/Documentation/powerpc/dts-bindings/fsl/sec.txt b/Documentation/powerpc/dts-bindings/fsl/sec.txt
deleted file mode 100644
index 2b6f2d4..0000000
--- a/Documentation/powerpc/dts-bindings/fsl/sec.txt
+++ /dev/null
@@ -1,68 +0,0 @@
-Freescale SoC SEC Security Engines
-
-Required properties:
-
-- compatible : Should contain entries for this and backward compatible
-  SEC versions, high to low, e.g., "fsl,sec2.1", "fsl,sec2.0"
-- reg : Offset and length of the register set for the device
-- interrupts : the SEC's interrupt number
-- fsl,num-channels : An integer representing the number of channels
-  available.
-- fsl,channel-fifo-len : An integer representing the number of
-  descriptor pointers each channel fetch fifo can hold.
-- fsl,exec-units-mask : The bitmask representing what execution units
-  (EUs) are available. It's a single 32-bit cell. EU information
-  should be encoded following the SEC's Descriptor Header Dword
-  EU_SEL0 field documentation, i.e. as follows:
-
-	bit 0  = reserved - should be 0
-	bit 1  = set if SEC has the ARC4 EU (AFEU)
-	bit 2  = set if SEC has the DES/3DES EU (DEU)
-	bit 3  = set if SEC has the message digest EU (MDEU/MDEU-A)
-	bit 4  = set if SEC has the random number generator EU (RNG)
-	bit 5  = set if SEC has the public key EU (PKEU)
-	bit 6  = set if SEC has the AES EU (AESU)
-	bit 7  = set if SEC has the Kasumi EU (KEU)
-	bit 8  = set if SEC has the CRC EU (CRCU)
-	bit 11 = set if SEC has the message digest EU extended alg set (MDEU-B)
-
-remaining bits are reserved for future SEC EUs.
-
-- fsl,descriptor-types-mask : The bitmask representing what descriptors
-  are available. It's a single 32-bit cell. Descriptor type information
-  should be encoded following the SEC's Descriptor Header Dword DESC_TYPE
-  field documentation, i.e. as follows:
-
-	bit 0  = set if SEC supports the aesu_ctr_nonsnoop desc. type
-	bit 1  = set if SEC supports the ipsec_esp descriptor type
-	bit 2  = set if SEC supports the common_nonsnoop desc. type
-	bit 3  = set if SEC supports the 802.11i AES ccmp desc. type
-	bit 4  = set if SEC supports the hmac_snoop_no_afeu desc. type
-	bit 5  = set if SEC supports the srtp descriptor type
-	bit 6  = set if SEC supports the non_hmac_snoop_no_afeu desc.type
-	bit 7  = set if SEC supports the pkeu_assemble descriptor type
-	bit 8  = set if SEC supports the aesu_key_expand_output desc.type
-	bit 9  = set if SEC supports the pkeu_ptmul descriptor type
-	bit 10 = set if SEC supports the common_nonsnoop_afeu desc. type
-	bit 11 = set if SEC supports the pkeu_ptadd_dbl descriptor type
-
-  ..and so on and so forth.
-
-Optional properties:
-
-- interrupt-parent : the phandle for the interrupt controller that
-  services interrupts for this device.
-
-Example:
-
-	/* MPC8548E */
-	crypto@30000 {
-		compatible = "fsl,sec2.1", "fsl,sec2.0";
-		reg = <0x30000 0x10000>;
-		interrupts = <29 2>;
-		interrupt-parent = <&mpic>;
-		fsl,num-channels = <4>;
-		fsl,channel-fifo-len = <24>;
-		fsl,exec-units-mask = <0xfe>;
-		fsl,descriptor-types-mask = <0x12b0ebf>;
-	};
diff --git a/Documentation/powerpc/dts-bindings/fsl/spi.txt b/Documentation/powerpc/dts-bindings/fsl/spi.txt
deleted file mode 100644
index 777abd7..0000000
--- a/Documentation/powerpc/dts-bindings/fsl/spi.txt
+++ /dev/null
@@ -1,53 +0,0 @@
-* SPI (Serial Peripheral Interface)
-
-Required properties:
-- cell-index : QE SPI subblock index.
-		0: QE subblock SPI1
-		1: QE subblock SPI2
-- compatible : should be "fsl,spi".
-- mode : the SPI operation mode, it can be "cpu" or "cpu-qe".
-- reg : Offset and length of the register set for the device
-- interrupts : <a b> where a is the interrupt number and b is a
-  field that represents an encoding of the sense and level
-  information for the interrupt.  This should be encoded based on
-  the information in section 2) depending on the type of interrupt
-  controller you have.
-- interrupt-parent : the phandle for the interrupt controller that
-  services interrupts for this device.
-
-Optional properties:
-- gpios : specifies the gpio pins to be used for chipselects.
-  The gpios will be referred to as reg = <index> in the SPI child nodes.
-  If unspecified, a single SPI device without a chip select can be used.
-
-Example:
-	spi@4c0 {
-		cell-index = <0>;
-		compatible = "fsl,spi";
-		reg = <4c0 40>;
-		interrupts = <82 0>;
-		interrupt-parent = <700>;
-		mode = "cpu";
-		gpios = <&gpio 18 1	// device reg=<0>
-			 &gpio 19 1>;	// device reg=<1>
-	};
-
-
-* eSPI (Enhanced Serial Peripheral Interface)
-
-Required properties:
-- compatible : should be "fsl,mpc8536-espi".
-- reg : Offset and length of the register set for the device.
-- interrupts : should contain eSPI interrupt, the device has one interrupt.
-- fsl,espi-num-chipselects : the number of the chipselect signals.
-
-Example:
-	spi@110000 {
-		#address-cells = <1>;
-		#size-cells = <0>;
-		compatible = "fsl,mpc8536-espi";
-		reg = <0x110000 0x1000>;
-		interrupts = <53 0x2>;
-		interrupt-parent = <&mpic>;
-		fsl,espi-num-chipselects = <4>;
-	};
diff --git a/Documentation/powerpc/dts-bindings/fsl/ssi.txt b/Documentation/powerpc/dts-bindings/fsl/ssi.txt
deleted file mode 100644
index 5ff76c9..0000000
--- a/Documentation/powerpc/dts-bindings/fsl/ssi.txt
+++ /dev/null
@@ -1,73 +0,0 @@
-Freescale Synchronous Serial Interface
-
-The SSI is a serial device that communicates with audio codecs.  It can
-be programmed in AC97, I2S, left-justified, or right-justified modes.
-
-Required properties:
-- compatible:       Compatible list, contains "fsl,ssi".
-- cell-index:       The SSI, <0> = SSI1, <1> = SSI2, and so on.
-- reg:              Offset and length of the register set for the device.
-- interrupts:       <a b> where a is the interrupt number and b is a
-                    field that represents an encoding of the sense and
-                    level information for the interrupt.  This should be
-                    encoded based on the information in section 2)
-                    depending on the type of interrupt controller you
-                    have.
-- interrupt-parent: The phandle for the interrupt controller that
-                    services interrupts for this device.
-- fsl,mode:         The operating mode for the SSI interface.
-                    "i2s-slave" - I2S mode, SSI is clock slave
-                    "i2s-master" - I2S mode, SSI is clock master
-                    "lj-slave" - left-justified mode, SSI is clock slave
-                    "lj-master" - l.j. mode, SSI is clock master
-                    "rj-slave" - right-justified mode, SSI is clock slave
-                    "rj-master" - r.j., SSI is clock master
-                    "ac97-slave" - AC97 mode, SSI is clock slave
-                    "ac97-master" - AC97 mode, SSI is clock master
-- fsl,playback-dma: Phandle to a node for the DMA channel to use for
-                    playback of audio.  This is typically dictated by SOC
-                    design.  See the notes below.
-- fsl,capture-dma:  Phandle to a node for the DMA channel to use for
-                    capture (recording) of audio.  This is typically dictated
-                    by SOC design.  See the notes below.
-- fsl,fifo-depth:   The number of elements in the transmit and receive FIFOs.
-                    This number is the maximum allowed value for SFCSR[TFWM0].
-- fsl,ssi-asynchronous:
-                    If specified, the SSI is to be programmed in asynchronous
-                    mode.  In this mode, pins SRCK, STCK, SRFS, and STFS must
-                    all be connected to valid signals.  In synchronous mode,
-                    SRCK and SRFS are ignored.  Asynchronous mode allows
-                    playback and capture to use different sample sizes and
-                    sample rates.  Some drivers may require that SRCK and STCK
-                    be connected together, and SRFS and STFS be connected
-                    together.  This would still allow different sample sizes,
-                    but not different sample rates.
-
-Optional properties:
-- codec-handle:     Phandle to a 'codec' node that defines an audio
-                    codec connected to this SSI.  This node is typically
-                    a child of an I2C or other control node.
-
-Child 'codec' node required properties:
-- compatible:       Compatible list, contains the name of the codec
-
-Child 'codec' node optional properties:
-- clock-frequency:  The frequency of the input clock, which typically comes
-                    from an on-board dedicated oscillator.
-
-Notes on fsl,playback-dma and fsl,capture-dma:
-
-On SOCs that have an SSI, specific DMA channels are hard-wired for playback
-and capture.  On the MPC8610, for example, SSI1 must use DMA channel 0 for
-playback and DMA channel 1 for capture.  SSI2 must use DMA channel 2 for
-playback and DMA channel 3 for capture.  The developer can choose which
-DMA controller to use, but the channels themselves are hard-wired.  The
-purpose of these two properties is to represent this hardware design.
-
-The device tree nodes for the DMA channels that are referenced by
-"fsl,playback-dma" and "fsl,capture-dma" must be marked as compatible with
-"fsl,ssi-dma-channel".  The SOC-specific compatible string (e.g.
-"fsl,mpc8610-dma-channel") can remain.  If these nodes are left as
-"fsl,elo-dma-channel" or "fsl,eloplus-dma-channel", then the generic Elo DMA
-drivers (fsldma) will attempt to use them, and it will conflict with the
-sound drivers.
diff --git a/Documentation/powerpc/dts-bindings/fsl/tsec.txt b/Documentation/powerpc/dts-bindings/fsl/tsec.txt
deleted file mode 100644
index edb7ae1..0000000
--- a/Documentation/powerpc/dts-bindings/fsl/tsec.txt
+++ /dev/null
@@ -1,76 +0,0 @@
-* MDIO IO device
-
-The MDIO is a bus to which the PHY devices are connected.  For each
-device that exists on this bus, a child node should be created.  See
-the definition of the PHY node in booting-without-of.txt for an example
-of how to define a PHY.
-
-Required properties:
-  - reg : Offset and length of the register set for the device
-  - compatible : Should define the compatible device type for the
-    mdio.  Currently, this is most likely to be "fsl,gianfar-mdio"
-
-Example:
-
-	mdio@24520 {
-		reg = <24520 20>;
-		compatible = "fsl,gianfar-mdio";
-
-		ethernet-phy@0 {
-			......
-		};
-	};
-
-* TBI Internal MDIO bus
-
-As of this writing, every tsec is associated with an internal TBI PHY.
-This PHY is accessed through the local MDIO bus.  These buses are defined
-similarly to the mdio buses, except they are compatible with "fsl,gianfar-tbi".
-The TBI PHYs underneath them are similar to normal PHYs, but the reg property
-is considered instructive, rather than descriptive.  The reg property should
-be chosen so it doesn't interfere with other PHYs on the bus.
-
-* Gianfar-compatible ethernet nodes
-
-Properties:
-
-  - device_type : Should be "network"
-  - model : Model of the device.  Can be "TSEC", "eTSEC", or "FEC"
-  - compatible : Should be "gianfar"
-  - reg : Offset and length of the register set for the device
-  - local-mac-address : List of bytes representing the ethernet address of
-    this controller
-  - interrupts : For FEC devices, the first interrupt is the device's
-    interrupt.  For TSEC and eTSEC devices, the first interrupt is
-    transmit, the second is receive, and the third is error.
-  - phy-handle : The phandle for the PHY connected to this ethernet
-    controller.
-  - fixed-link : <a b c d e> where a is emulated phy id - choose any,
-    but unique to the all specified fixed-links, b is duplex - 0 half,
-    1 full, c is link speed - d#10/d#100/d#1000, d is pause - 0 no
-    pause, 1 pause, e is asym_pause - 0 no asym_pause, 1 asym_pause.
-  - phy-connection-type : a string naming the controller/PHY interface type,
-    i.e., "mii" (default), "rmii", "gmii", "rgmii", "rgmii-id", "sgmii",
-    "tbi", or "rtbi".  This property is only really needed if the connection
-    is of type "rgmii-id", as all other connection types are detected by
-    hardware.
-  - fsl,magic-packet : If present, indicates that the hardware supports
-    waking up via magic packet.
-  - bd-stash : If present, indicates that the hardware supports stashing
-    buffer descriptors in the L2.
-  - rx-stash-len : Denotes the number of bytes of a received buffer to stash
-    in the L2.
-  - rx-stash-idx : Denotes the index of the first byte from the received
-    buffer to stash in the L2.
-
-Example:
-	ethernet@24000 {
-		device_type = "network";
-		model = "TSEC";
-		compatible = "gianfar";
-		reg = <0x24000 0x1000>;
-		local-mac-address = [ 00 E0 0C 00 73 00 ];
-		interrupts = <29 2 30 2 34 2>;
-		interrupt-parent = <&mpic>;
-		phy-handle = <&phy0>
-	};
diff --git a/Documentation/powerpc/dts-bindings/fsl/upm-nand.txt b/Documentation/powerpc/dts-bindings/fsl/upm-nand.txt
deleted file mode 100644
index a48b2ca..0000000
--- a/Documentation/powerpc/dts-bindings/fsl/upm-nand.txt
+++ /dev/null
@@ -1,63 +0,0 @@
-Freescale Localbus UPM programmed to work with NAND flash
-
-Required properties:
-- compatible : "fsl,upm-nand".
-- reg : should specify localbus chip select and size used for the chip.
-- fsl,upm-addr-offset : UPM pattern offset for the address latch.
-- fsl,upm-cmd-offset : UPM pattern offset for the command latch.
-
-Optional properties:
-- fsl,upm-wait-flags : add chip-dependent short delays after running the
-	UPM pattern (0x1), after writing a data byte (0x2) or after
-	writing out a buffer (0x4).
-- fsl,upm-addr-line-cs-offsets : address offsets for multi-chip support.
-	The corresponding address lines are used to select the chip.
-- gpios : may specify optional GPIOs connected to the Ready-Not-Busy pins
-	(R/B#). For multi-chip devices, "n" GPIO definitions are required
-	according to the number of chips.
-- chip-delay : chip dependent delay for transfering data from array to
-	read registers (tR). Required if property "gpios" is not used
-	(R/B# pins not connected).
-
-Examples:
-
-upm@1,0 {
-	compatible = "fsl,upm-nand";
-	reg = <1 0 1>;
-	fsl,upm-addr-offset = <16>;
-	fsl,upm-cmd-offset = <8>;
-	gpios = <&qe_pio_e 18 0>;
-
-	flash {
-		#address-cells = <1>;
-		#size-cells = <1>;
-		compatible = "...";
-
-		partition@0 {
-			...
-		};
-	};
-};
-
-upm@3,0 {
-	#address-cells = <0>;
-	#size-cells = <0>;
-	compatible = "tqc,tqm8548-upm-nand", "fsl,upm-nand";
-	reg = <3 0x0 0x800>;
-	fsl,upm-addr-offset = <0x10>;
-	fsl,upm-cmd-offset = <0x08>;
-	/* Multi-chip NAND device */
-	fsl,upm-addr-line-cs-offsets = <0x0 0x200>;
-	fsl,upm-wait-flags = <0x5>;
-	chip-delay = <25>; // in micro-seconds
-
-	nand@0 {
-		#address-cells = <1>;
-		#size-cells = <1>;
-
-		partition@0 {
-			    label = "fs";
-			    reg = <0x00000000 0x10000000>;
-		};
-	};
-};
diff --git a/Documentation/powerpc/dts-bindings/fsl/usb.txt b/Documentation/powerpc/dts-bindings/fsl/usb.txt
deleted file mode 100644
index bd5723f..0000000
--- a/Documentation/powerpc/dts-bindings/fsl/usb.txt
+++ /dev/null
@@ -1,81 +0,0 @@
-Freescale SOC USB controllers
-
-The device node for a USB controller that is part of a Freescale
-SOC is as described in the document "Open Firmware Recommended
-Practice : Universal Serial Bus" with the following modifications
-and additions :
-
-Required properties :
- - compatible : Should be "fsl-usb2-mph" for multi port host USB
-   controllers, or "fsl-usb2-dr" for dual role USB controllers
-   or "fsl,mpc5121-usb2-dr" for dual role USB controllers of MPC5121
- - phy_type : For multi port host USB controllers, should be one of
-   "ulpi", or "serial". For dual role USB controllers, should be
-   one of "ulpi", "utmi", "utmi_wide", or "serial".
- - reg : Offset and length of the register set for the device
- - port0 : boolean; if defined, indicates port0 is connected for
-   fsl-usb2-mph compatible controllers.  Either this property or
-   "port1" (or both) must be defined for "fsl-usb2-mph" compatible
-   controllers.
- - port1 : boolean; if defined, indicates port1 is connected for
-   fsl-usb2-mph compatible controllers.  Either this property or
-   "port0" (or both) must be defined for "fsl-usb2-mph" compatible
-   controllers.
- - dr_mode : indicates the working mode for "fsl-usb2-dr" compatible
-   controllers.  Can be "host", "peripheral", or "otg".  Default to
-   "host" if not defined for backward compatibility.
-
-Recommended properties :
- - interrupts : <a b> where a is the interrupt number and b is a
-   field that represents an encoding of the sense and level
-   information for the interrupt.  This should be encoded based on
-   the information in section 2) depending on the type of interrupt
-   controller you have.
- - interrupt-parent : the phandle for the interrupt controller that
-   services interrupts for this device.
-
-Optional properties :
- - fsl,invert-drvvbus : boolean; for MPC5121 USB0 only. Indicates the
-   port power polarity of internal PHY signal DRVVBUS is inverted.
- - fsl,invert-pwr-fault : boolean; for MPC5121 USB0 only. Indicates
-   the PWR_FAULT signal polarity is inverted.
-
-Example multi port host USB controller device node :
-	usb@22000 {
-		compatible = "fsl-usb2-mph";
-		reg = <22000 1000>;
-		#address-cells = <1>;
-		#size-cells = <0>;
-		interrupt-parent = <700>;
-		interrupts = <27 1>;
-		phy_type = "ulpi";
-		port0;
-		port1;
-	};
-
-Example dual role USB controller device node :
-	usb@23000 {
-		compatible = "fsl-usb2-dr";
-		reg = <23000 1000>;
-		#address-cells = <1>;
-		#size-cells = <0>;
-		interrupt-parent = <700>;
-		interrupts = <26 1>;
-		dr_mode = "otg";
-		phy = "ulpi";
-	};
-
-Example dual role USB controller device node for MPC5121ADS:
-
-	usb@4000 {
-		compatible = "fsl,mpc5121-usb2-dr";
-		reg = <0x4000 0x1000>;
-		#address-cells = <1>;
-		#size-cells = <0>;
-		interrupt-parent = < &ipic >;
-		interrupts = <44 0x8>;
-		dr_mode = "otg";
-		phy_type = "utmi_wide";
-		fsl,invert-drvvbus;
-		fsl,invert-pwr-fault;
-	};
diff --git a/Documentation/powerpc/dts-bindings/gpio/gpio.txt b/Documentation/powerpc/dts-bindings/gpio/gpio.txt
deleted file mode 100644
index edaa84d..0000000
--- a/Documentation/powerpc/dts-bindings/gpio/gpio.txt
+++ /dev/null
@@ -1,50 +0,0 @@
-Specifying GPIO information for devices
-============================================
-
-1) gpios property
------------------
-
-Nodes that makes use of GPIOs should define them using `gpios' property,
-format of which is: <&gpio-controller1-phandle gpio1-specifier
-		     &gpio-controller2-phandle gpio2-specifier
-		     0 /* holes are permitted, means no GPIO 3 */
-		     &gpio-controller4-phandle gpio4-specifier
-		     ...>;
-
-Note that gpio-specifier length is controller dependent.
-
-gpio-specifier may encode: bank, pin position inside the bank,
-whether pin is open-drain and whether pin is logically inverted.
-
-Example of the node using GPIOs:
-
-	node {
-		gpios = <&qe_pio_e 18 0>;
-	};
-
-In this example gpio-specifier is "18 0" and encodes GPIO pin number,
-and empty GPIO flags as accepted by the "qe_pio_e" gpio-controller.
-
-2) gpio-controller nodes
-------------------------
-
-Every GPIO controller node must have #gpio-cells property defined,
-this information will be used to translate gpio-specifiers.
-
-Example of two SOC GPIO banks defined as gpio-controller nodes:
-
-	qe_pio_a: gpio-controller@1400 {
-		#gpio-cells = <2>;
-		compatible = "fsl,qe-pario-bank-a", "fsl,qe-pario-bank";
-		reg = <0x1400 0x18>;
-		gpio-controller;
-	};
-
-	qe_pio_e: gpio-controller@1460 {
-		#gpio-cells = <2>;
-		compatible = "fsl,qe-pario-bank-e", "fsl,qe-pario-bank";
-		reg = <0x1460 0x18>;
-		gpio-controller;
-	};
-
-
diff --git a/Documentation/powerpc/dts-bindings/gpio/led.txt b/Documentation/powerpc/dts-bindings/gpio/led.txt
deleted file mode 100644
index 064db92..0000000
--- a/Documentation/powerpc/dts-bindings/gpio/led.txt
+++ /dev/null
@@ -1,58 +0,0 @@
-LEDs connected to GPIO lines
-
-Required properties:
-- compatible : should be "gpio-leds".
-
-Each LED is represented as a sub-node of the gpio-leds device.  Each
-node's name represents the name of the corresponding LED.
-
-LED sub-node properties:
-- gpios :  Should specify the LED's GPIO, see "Specifying GPIO information
-  for devices" in Documentation/powerpc/booting-without-of.txt.  Active
-  low LEDs should be indicated using flags in the GPIO specifier.
-- label :  (optional) The label for this LED.  If omitted, the label is
-  taken from the node name (excluding the unit address).
-- linux,default-trigger :  (optional) This parameter, if present, is a
-  string defining the trigger assigned to the LED.  Current triggers are:
-    "backlight" - LED will act as a back-light, controlled by the framebuffer
-		  system
-    "default-on" - LED will turn on, but see "default-state" below
-    "heartbeat" - LED "double" flashes at a load average based rate
-    "ide-disk" - LED indicates disk activity
-    "timer" - LED flashes at a fixed, configurable rate
-- default-state:  (optional) The initial state of the LED.  Valid
-  values are "on", "off", and "keep".  If the LED is already on or off
-  and the default-state property is set the to same value, then no
-  glitch should be produced where the LED momentarily turns off (or
-  on).  The "keep" setting will keep the LED at whatever its current
-  state is, without producing a glitch.  The default is off if this
-  property is not present.
-
-Examples:
-
-leds {
-	compatible = "gpio-leds";
-	hdd {
-		label = "IDE Activity";
-		gpios = <&mcu_pio 0 1>; /* Active low */
-		linux,default-trigger = "ide-disk";
-	};
-
-	fault {
-		gpios = <&mcu_pio 1 0>;
-		/* Keep LED on if BIOS detected hardware fault */
-		default-state = "keep";
-	};
-};
-
-run-control {
-	compatible = "gpio-leds";
-	red {
-		gpios = <&mpc8572 6 0>;
-		default-state = "off";
-	};
-	green {
-		gpios = <&mpc8572 7 0>;
-		default-state = "on";
-	};
-}
diff --git a/Documentation/powerpc/dts-bindings/gpio/mdio.txt b/Documentation/powerpc/dts-bindings/gpio/mdio.txt
deleted file mode 100644
index bc95495..0000000
--- a/Documentation/powerpc/dts-bindings/gpio/mdio.txt
+++ /dev/null
@@ -1,19 +0,0 @@
-MDIO on GPIOs
-
-Currently defined compatibles:
-- virtual,gpio-mdio
-
-MDC and MDIO lines connected to GPIO controllers are listed in the
-gpios property as described in section VIII.1 in the following order:
-
-MDC, MDIO.
-
-Example:
-
-mdio {
-	compatible = "virtual,mdio-gpio";
-	#address-cells = <1>;
-	#size-cells = <0>;
-	gpios = <&qe_pio_a 11
-		 &qe_pio_c 6>;
-};
diff --git a/Documentation/powerpc/dts-bindings/marvell.txt b/Documentation/powerpc/dts-bindings/marvell.txt
deleted file mode 100644
index f1533d9..0000000
--- a/Documentation/powerpc/dts-bindings/marvell.txt
+++ /dev/null
@@ -1,521 +0,0 @@
-Marvell Discovery mv64[345]6x System Controller chips
-===========================================================
-
-The Marvell mv64[345]60 series of system controller chips contain
-many of the peripherals needed to implement a complete computer
-system.  In this section, we define device tree nodes to describe
-the system controller chip itself and each of the peripherals
-which it contains.  Compatible string values for each node are
-prefixed with the string "marvell,", for Marvell Technology Group Ltd.
-
-1) The /system-controller node
-
-  This node is used to represent the system-controller and must be
-  present when the system uses a system controller chip. The top-level
-  system-controller node contains information that is global to all
-  devices within the system controller chip. The node name begins
-  with "system-controller" followed by the unit address, which is
-  the base address of the memory-mapped register set for the system
-  controller chip.
-
-  Required properties:
-
-    - ranges : Describes the translation of system controller addresses
-      for memory mapped registers.
-    - clock-frequency: Contains the main clock frequency for the system
-      controller chip.
-    - reg : This property defines the address and size of the
-      memory-mapped registers contained within the system controller
-      chip.  The address specified in the "reg" property should match
-      the unit address of the system-controller node.
-    - #address-cells : Address representation for system controller
-      devices.  This field represents the number of cells needed to
-      represent the address of the memory-mapped registers of devices
-      within the system controller chip.
-    - #size-cells : Size representation for the memory-mapped
-      registers within the system controller chip.
-    - #interrupt-cells : Defines the width of cells used to represent
-      interrupts.
-
-  Optional properties:
-
-    - model : The specific model of the system controller chip.  Such
-      as, "mv64360", "mv64460", or "mv64560".
-    - compatible : A string identifying the compatibility identifiers
-      of the system controller chip.
-
-  The system-controller node contains child nodes for each system
-  controller device that the platform uses.  Nodes should not be created
-  for devices which exist on the system controller chip but are not used
-
-  Example Marvell Discovery mv64360 system-controller node:
-
-    system-controller@f1000000 { /* Marvell Discovery mv64360 */
-	    #address-cells = <1>;
-	    #size-cells = <1>;
-	    model = "mv64360";                      /* Default */
-	    compatible = "marvell,mv64360";
-	    clock-frequency = <133333333>;
-	    reg = <0xf1000000 0x10000>;
-	    virtual-reg = <0xf1000000>;
-	    ranges = <0x88000000 0x88000000 0x1000000 /* PCI 0 I/O Space */
-		    0x80000000 0x80000000 0x8000000 /* PCI 0 MEM Space */
-		    0xa0000000 0xa0000000 0x4000000 /* User FLASH */
-		    0x00000000 0xf1000000 0x0010000 /* Bridge's regs */
-		    0xf2000000 0xf2000000 0x0040000>;/* Integrated SRAM */
-
-	    [ child node definitions... ]
-    }
-
-2) Child nodes of /system-controller
-
-   a) Marvell Discovery MDIO bus
-
-   The MDIO is a bus to which the PHY devices are connected.  For each
-   device that exists on this bus, a child node should be created.  See
-   the definition of the PHY node below for an example of how to define
-   a PHY.
-
-   Required properties:
-     - #address-cells : Should be <1>
-     - #size-cells : Should be <0>
-     - device_type : Should be "mdio"
-     - compatible : Should be "marvell,mv64360-mdio"
-
-   Example:
-
-     mdio {
-	     #address-cells = <1>;
-	     #size-cells = <0>;
-	     device_type = "mdio";
-	     compatible = "marvell,mv64360-mdio";
-
-	     ethernet-phy@0 {
-		     ......
-	     };
-     };
-
-
-   b) Marvell Discovery ethernet controller
-
-   The Discover ethernet controller is described with two levels
-   of nodes.  The first level describes an ethernet silicon block
-   and the second level describes up to 3 ethernet nodes within
-   that block.  The reason for the multiple levels is that the
-   registers for the node are interleaved within a single set
-   of registers.  The "ethernet-block" level describes the
-   shared register set, and the "ethernet" nodes describe ethernet
-   port-specific properties.
-
-   Ethernet block node
-
-   Required properties:
-     - #address-cells : <1>
-     - #size-cells : <0>
-     - compatible : "marvell,mv64360-eth-block"
-     - reg : Offset and length of the register set for this block
-
-   Example Discovery Ethernet block node:
-     ethernet-block@2000 {
-	     #address-cells = <1>;
-	     #size-cells = <0>;
-	     compatible = "marvell,mv64360-eth-block";
-	     reg = <0x2000 0x2000>;
-	     ethernet@0 {
-		     .......
-	     };
-     };
-
-   Ethernet port node
-
-   Required properties:
-     - device_type : Should be "network".
-     - compatible : Should be "marvell,mv64360-eth".
-     - reg : Should be <0>, <1>, or <2>, according to which registers
-       within the silicon block the device uses.
-     - interrupts : <a> where a is the interrupt number for the port.
-     - interrupt-parent : the phandle for the interrupt controller
-       that services interrupts for this device.
-     - phy : the phandle for the PHY connected to this ethernet
-       controller.
-     - local-mac-address : 6 bytes, MAC address
-
-   Example Discovery Ethernet port node:
-     ethernet@0 {
-	     device_type = "network";
-	     compatible = "marvell,mv64360-eth";
-	     reg = <0>;
-	     interrupts = <32>;
-	     interrupt-parent = <&PIC>;
-	     phy = <&PHY0>;
-	     local-mac-address = [ 00 00 00 00 00 00 ];
-     };
-
-
-
-   c) Marvell Discovery PHY nodes
-
-   Required properties:
-     - device_type : Should be "ethernet-phy"
-     - interrupts : <a> where a is the interrupt number for this phy.
-     - interrupt-parent : the phandle for the interrupt controller that
-       services interrupts for this device.
-     - reg : The ID number for the phy, usually a small integer
-
-   Example Discovery PHY node:
-     ethernet-phy@1 {
-	     device_type = "ethernet-phy";
-	     compatible = "broadcom,bcm5421";
-	     interrupts = <76>;      /* GPP 12 */
-	     interrupt-parent = <&PIC>;
-	     reg = <1>;
-     };
-
-
-   d) Marvell Discovery SDMA nodes
-
-   Represent DMA hardware associated with the MPSC (multiprotocol
-   serial controllers).
-
-   Required properties:
-     - compatible : "marvell,mv64360-sdma"
-     - reg : Offset and length of the register set for this device
-     - interrupts : <a> where a is the interrupt number for the DMA
-       device.
-     - interrupt-parent : the phandle for the interrupt controller
-       that services interrupts for this device.
-
-   Example Discovery SDMA node:
-     sdma@4000 {
-	     compatible = "marvell,mv64360-sdma";
-	     reg = <0x4000 0xc18>;
-	     virtual-reg = <0xf1004000>;
-	     interrupts = <36>;
-	     interrupt-parent = <&PIC>;
-     };
-
-
-   e) Marvell Discovery BRG nodes
-
-   Represent baud rate generator hardware associated with the MPSC
-   (multiprotocol serial controllers).
-
-   Required properties:
-     - compatible : "marvell,mv64360-brg"
-     - reg : Offset and length of the register set for this device
-     - clock-src : A value from 0 to 15 which selects the clock
-       source for the baud rate generator.  This value corresponds
-       to the CLKS value in the BRGx configuration register.  See
-       the mv64x60 User's Manual.
-     - clock-frequence : The frequency (in Hz) of the baud rate
-       generator's input clock.
-     - current-speed : The current speed setting (presumably by
-       firmware) of the baud rate generator.
-
-   Example Discovery BRG node:
-     brg@b200 {
-	     compatible = "marvell,mv64360-brg";
-	     reg = <0xb200 0x8>;
-	     clock-src = <8>;
-	     clock-frequency = <133333333>;
-	     current-speed = <9600>;
-     };
-
-
-   f) Marvell Discovery CUNIT nodes
-
-   Represent the Serial Communications Unit device hardware.
-
-   Required properties:
-     - reg : Offset and length of the register set for this device
-
-   Example Discovery CUNIT node:
-     cunit@f200 {
-	     reg = <0xf200 0x200>;
-     };
-
-
-   g) Marvell Discovery MPSCROUTING nodes
-
-   Represent the Discovery's MPSC routing hardware
-
-   Required properties:
-     - reg : Offset and length of the register set for this device
-
-   Example Discovery CUNIT node:
-     mpscrouting@b500 {
-	     reg = <0xb400 0xc>;
-     };
-
-
-   h) Marvell Discovery MPSCINTR nodes
-
-   Represent the Discovery's MPSC DMA interrupt hardware registers
-   (SDMA cause and mask registers).
-
-   Required properties:
-     - reg : Offset and length of the register set for this device
-
-   Example Discovery MPSCINTR node:
-     mpsintr@b800 {
-	     reg = <0xb800 0x100>;
-     };
-
-
-   i) Marvell Discovery MPSC nodes
-
-   Represent the Discovery's MPSC (Multiprotocol Serial Controller)
-   serial port.
-
-   Required properties:
-     - device_type : "serial"
-     - compatible : "marvell,mv64360-mpsc"
-     - reg : Offset and length of the register set for this device
-     - sdma : the phandle for the SDMA node used by this port
-     - brg : the phandle for the BRG node used by this port
-     - cunit : the phandle for the CUNIT node used by this port
-     - mpscrouting : the phandle for the MPSCROUTING node used by this port
-     - mpscintr : the phandle for the MPSCINTR node used by this port
-     - cell-index : the hardware index of this cell in the MPSC core
-     - max_idle : value needed for MPSC CHR3 (Maximum Frame Length)
-       register
-     - interrupts : <a> where a is the interrupt number for the MPSC.
-     - interrupt-parent : the phandle for the interrupt controller
-       that services interrupts for this device.
-
-   Example Discovery MPSCINTR node:
-     mpsc@8000 {
-	     device_type = "serial";
-	     compatible = "marvell,mv64360-mpsc";
-	     reg = <0x8000 0x38>;
-	     virtual-reg = <0xf1008000>;
-	     sdma = <&SDMA0>;
-	     brg = <&BRG0>;
-	     cunit = <&CUNIT>;
-	     mpscrouting = <&MPSCROUTING>;
-	     mpscintr = <&MPSCINTR>;
-	     cell-index = <0>;
-	     max_idle = <40>;
-	     interrupts = <40>;
-	     interrupt-parent = <&PIC>;
-     };
-
-
-   j) Marvell Discovery Watch Dog Timer nodes
-
-   Represent the Discovery's watchdog timer hardware
-
-   Required properties:
-     - compatible : "marvell,mv64360-wdt"
-     - reg : Offset and length of the register set for this device
-
-   Example Discovery Watch Dog Timer node:
-     wdt@b410 {
-	     compatible = "marvell,mv64360-wdt";
-	     reg = <0xb410 0x8>;
-     };
-
-
-   k) Marvell Discovery I2C nodes
-
-   Represent the Discovery's I2C hardware
-
-   Required properties:
-     - device_type : "i2c"
-     - compatible : "marvell,mv64360-i2c"
-     - reg : Offset and length of the register set for this device
-     - interrupts : <a> where a is the interrupt number for the I2C.
-     - interrupt-parent : the phandle for the interrupt controller
-       that services interrupts for this device.
-
-   Example Discovery I2C node:
-	     compatible = "marvell,mv64360-i2c";
-	     reg = <0xc000 0x20>;
-	     virtual-reg = <0xf100c000>;
-	     interrupts = <37>;
-	     interrupt-parent = <&PIC>;
-     };
-
-
-   l) Marvell Discovery PIC (Programmable Interrupt Controller) nodes
-
-   Represent the Discovery's PIC hardware
-
-   Required properties:
-     - #interrupt-cells : <1>
-     - #address-cells : <0>
-     - compatible : "marvell,mv64360-pic"
-     - reg : Offset and length of the register set for this device
-     - interrupt-controller
-
-   Example Discovery PIC node:
-     pic {
-	     #interrupt-cells = <1>;
-	     #address-cells = <0>;
-	     compatible = "marvell,mv64360-pic";
-	     reg = <0x0 0x88>;
-	     interrupt-controller;
-     };
-
-
-   m) Marvell Discovery MPP (Multipurpose Pins) multiplexing nodes
-
-   Represent the Discovery's MPP hardware
-
-   Required properties:
-     - compatible : "marvell,mv64360-mpp"
-     - reg : Offset and length of the register set for this device
-
-   Example Discovery MPP node:
-     mpp@f000 {
-	     compatible = "marvell,mv64360-mpp";
-	     reg = <0xf000 0x10>;
-     };
-
-
-   n) Marvell Discovery GPP (General Purpose Pins) nodes
-
-   Represent the Discovery's GPP hardware
-
-   Required properties:
-     - compatible : "marvell,mv64360-gpp"
-     - reg : Offset and length of the register set for this device
-
-   Example Discovery GPP node:
-     gpp@f000 {
-	     compatible = "marvell,mv64360-gpp";
-	     reg = <0xf100 0x20>;
-     };
-
-
-   o) Marvell Discovery PCI host bridge node
-
-   Represents the Discovery's PCI host bridge device.  The properties
-   for this node conform to Rev 2.1 of the PCI Bus Binding to IEEE
-   1275-1994.  A typical value for the compatible property is
-   "marvell,mv64360-pci".
-
-   Example Discovery PCI host bridge node
-     pci@80000000 {
-	     #address-cells = <3>;
-	     #size-cells = <2>;
-	     #interrupt-cells = <1>;
-	     device_type = "pci";
-	     compatible = "marvell,mv64360-pci";
-	     reg = <0xcf8 0x8>;
-	     ranges = <0x01000000 0x0        0x0
-			     0x88000000 0x0 0x01000000
-		       0x02000000 0x0 0x80000000
-			     0x80000000 0x0 0x08000000>;
-	     bus-range = <0 255>;
-	     clock-frequency = <66000000>;
-	     interrupt-parent = <&PIC>;
-	     interrupt-map-mask = <0xf800 0x0 0x0 0x7>;
-	     interrupt-map = <
-		     /* IDSEL 0x0a */
-		     0x5000 0 0 1 &PIC 80
-		     0x5000 0 0 2 &PIC 81
-		     0x5000 0 0 3 &PIC 91
-		     0x5000 0 0 4 &PIC 93
-
-		     /* IDSEL 0x0b */
-		     0x5800 0 0 1 &PIC 91
-		     0x5800 0 0 2 &PIC 93
-		     0x5800 0 0 3 &PIC 80
-		     0x5800 0 0 4 &PIC 81
-
-		     /* IDSEL 0x0c */
-		     0x6000 0 0 1 &PIC 91
-		     0x6000 0 0 2 &PIC 93
-		     0x6000 0 0 3 &PIC 80
-		     0x6000 0 0 4 &PIC 81
-
-		     /* IDSEL 0x0d */
-		     0x6800 0 0 1 &PIC 93
-		     0x6800 0 0 2 &PIC 80
-		     0x6800 0 0 3 &PIC 81
-		     0x6800 0 0 4 &PIC 91
-	     >;
-     };
-
-
-   p) Marvell Discovery CPU Error nodes
-
-   Represent the Discovery's CPU error handler device.
-
-   Required properties:
-     - compatible : "marvell,mv64360-cpu-error"
-     - reg : Offset and length of the register set for this device
-     - interrupts : the interrupt number for this device
-     - interrupt-parent : the phandle for the interrupt controller
-       that services interrupts for this device.
-
-   Example Discovery CPU Error node:
-     cpu-error@0070 {
-	     compatible = "marvell,mv64360-cpu-error";
-	     reg = <0x70 0x10 0x128 0x28>;
-	     interrupts = <3>;
-	     interrupt-parent = <&PIC>;
-     };
-
-
-   q) Marvell Discovery SRAM Controller nodes
-
-   Represent the Discovery's SRAM controller device.
-
-   Required properties:
-     - compatible : "marvell,mv64360-sram-ctrl"
-     - reg : Offset and length of the register set for this device
-     - interrupts : the interrupt number for this device
-     - interrupt-parent : the phandle for the interrupt controller
-       that services interrupts for this device.
-
-   Example Discovery SRAM Controller node:
-     sram-ctrl@0380 {
-	     compatible = "marvell,mv64360-sram-ctrl";
-	     reg = <0x380 0x80>;
-	     interrupts = <13>;
-	     interrupt-parent = <&PIC>;
-     };
-
-
-   r) Marvell Discovery PCI Error Handler nodes
-
-   Represent the Discovery's PCI error handler device.
-
-   Required properties:
-     - compatible : "marvell,mv64360-pci-error"
-     - reg : Offset and length of the register set for this device
-     - interrupts : the interrupt number for this device
-     - interrupt-parent : the phandle for the interrupt controller
-       that services interrupts for this device.
-
-   Example Discovery PCI Error Handler node:
-     pci-error@1d40 {
-	     compatible = "marvell,mv64360-pci-error";
-	     reg = <0x1d40 0x40 0xc28 0x4>;
-	     interrupts = <12>;
-	     interrupt-parent = <&PIC>;
-     };
-
-
-   s) Marvell Discovery Memory Controller nodes
-
-   Represent the Discovery's memory controller device.
-
-   Required properties:
-     - compatible : "marvell,mv64360-mem-ctrl"
-     - reg : Offset and length of the register set for this device
-     - interrupts : the interrupt number for this device
-     - interrupt-parent : the phandle for the interrupt controller
-       that services interrupts for this device.
-
-   Example Discovery Memory Controller node:
-     mem-ctrl@1400 {
-	     compatible = "marvell,mv64360-mem-ctrl";
-	     reg = <0x1400 0x60>;
-	     interrupts = <17>;
-	     interrupt-parent = <&PIC>;
-     };
-
-
diff --git a/Documentation/powerpc/dts-bindings/mmc-spi-slot.txt b/Documentation/powerpc/dts-bindings/mmc-spi-slot.txt
deleted file mode 100644
index c39ac28..0000000
--- a/Documentation/powerpc/dts-bindings/mmc-spi-slot.txt
+++ /dev/null
@@ -1,23 +0,0 @@
-MMC/SD/SDIO slot directly connected to a SPI bus
-
-Required properties:
-- compatible : should be "mmc-spi-slot".
-- reg : should specify SPI address (chip-select number).
-- spi-max-frequency : maximum frequency for this device (Hz).
-- voltage-ranges : two cells are required, first cell specifies minimum
-  slot voltage (mV), second cell specifies maximum slot voltage (mV).
-  Several ranges could be specified.
-- gpios : (optional) may specify GPIOs in this order: Card-Detect GPIO,
-  Write-Protect GPIO.
-
-Example:
-
-	mmc-slot@0 {
-		compatible = "fsl,mpc8323rdb-mmc-slot",
-			     "mmc-spi-slot";
-		reg = <0>;
-		gpios = <&qe_pio_d 14 1
-			 &qe_pio_d 15 0>;
-		voltage-ranges = <3300 3300>;
-		spi-max-frequency = <50000000>;
-	};
diff --git a/Documentation/powerpc/dts-bindings/mtd-physmap.txt b/Documentation/powerpc/dts-bindings/mtd-physmap.txt
deleted file mode 100644
index 80152cb..0000000
--- a/Documentation/powerpc/dts-bindings/mtd-physmap.txt
+++ /dev/null
@@ -1,90 +0,0 @@
-CFI or JEDEC memory-mapped NOR flash, MTD-RAM (NVRAM...)
-
-Flash chips (Memory Technology Devices) are often used for solid state
-file systems on embedded devices.
-
- - compatible : should contain the specific model of mtd chip(s)
-   used, if known, followed by either "cfi-flash", "jedec-flash"
-   or "mtd-ram".
- - reg : Address range(s) of the mtd chip(s)
-   It's possible to (optionally) define multiple "reg" tuples so that
-   non-identical chips can be described in one node.
- - bank-width : Width (in bytes) of the bank.  Equal to the
-   device width times the number of interleaved chips.
- - device-width : (optional) Width of a single mtd chip.  If
-   omitted, assumed to be equal to 'bank-width'.
- - #address-cells, #size-cells : Must be present if the device has
-   sub-nodes representing partitions (see below).  In this case
-   both #address-cells and #size-cells must be equal to 1.
-
-For JEDEC compatible devices, the following additional properties
-are defined:
-
- - vendor-id : Contains the flash chip's vendor id (1 byte).
- - device-id : Contains the flash chip's device id (1 byte).
-
-In addition to the information on the mtd bank itself, the
-device tree may optionally contain additional information
-describing partitions of the address space.  This can be
-used on platforms which have strong conventions about which
-portions of a flash are used for what purposes, but which don't
-use an on-flash partition table such as RedBoot.
-
-Each partition is represented as a sub-node of the mtd device.
-Each node's name represents the name of the corresponding
-partition of the mtd device.
-
-Flash partitions
- - reg : The partition's offset and size within the mtd bank.
- - label : (optional) The label / name for this partition.
-   If omitted, the label is taken from the node name (excluding
-   the unit address).
- - read-only : (optional) This parameter, if present, is a hint to
-   Linux that this partition should only be mounted
-   read-only.  This is usually used for flash partitions
-   containing early-boot firmware images or data which should not
-   be clobbered.
-
-Example:
-
-	flash@ff000000 {
-		compatible = "amd,am29lv128ml", "cfi-flash";
-		reg = <ff000000 01000000>;
-		bank-width = <4>;
-		device-width = <1>;
-		#address-cells = <1>;
-		#size-cells = <1>;
-		fs@0 {
-			label = "fs";
-			reg = <0 f80000>;
-		};
-		firmware@f80000 {
-			label ="firmware";
-			reg = <f80000 80000>;
-			read-only;
-		};
-	};
-
-Here an example with multiple "reg" tuples:
-
-	flash@f0000000,0 {
-		#address-cells = <1>;
-		#size-cells = <1>;
-		compatible = "intel,PC48F4400P0VB", "cfi-flash";
-		reg = <0 0x00000000 0x02000000
-		       0 0x02000000 0x02000000>;
-		bank-width = <2>;
-		partition@0 {
-			label = "test-part1";
-			reg = <0 0x04000000>;
-		};
-	};
-
-An example using SRAM:
-
-	sram@2,0 {
-		compatible = "samsung,k6f1616u6a", "mtd-ram";
-		reg = <2 0 0x00200000>;
-		bank-width = <2>;
-	};
-
diff --git a/Documentation/powerpc/dts-bindings/nintendo/gamecube.txt b/Documentation/powerpc/dts-bindings/nintendo/gamecube.txt
deleted file mode 100644
index b558585..0000000
--- a/Documentation/powerpc/dts-bindings/nintendo/gamecube.txt
+++ /dev/null
@@ -1,109 +0,0 @@
-
-Nintendo GameCube device tree
-=============================
-
-1) The "flipper" node
-
-  This node represents the multi-function "Flipper" chip, which packages
-  many of the devices found in the Nintendo GameCube.
-
-  Required properties:
-
-   - compatible : Should be "nintendo,flipper"
-
-1.a) The Video Interface (VI) node
-
-  Represents the interface between the graphics processor and a external
-  video encoder.
-
-  Required properties:
-
-   - compatible : should be "nintendo,flipper-vi"
-   - reg : should contain the VI registers location and length
-   - interrupts : should contain the VI interrupt
-
-1.b) The Processor Interface (PI) node
-
-  Represents the data and control interface between the main processor
-  and graphics and audio processor.
-
-  Required properties:
-
-  - compatible : should be "nintendo,flipper-pi"
-  - reg : should contain the PI registers location and length
-
-1.b.i) The "Flipper" interrupt controller node
-
-  Represents the interrupt controller within the "Flipper" chip.
-  The node for the "Flipper" interrupt controller must be placed under
-  the PI node.
-
-  Required properties:
-
-  - compatible : should be "nintendo,flipper-pic"
-
-1.c) The Digital Signal Procesor (DSP) node
-
-  Represents the digital signal processor interface, designed to offload
-  audio related tasks.
-
-  Required properties:
-
-   - compatible : should be "nintendo,flipper-dsp"
-   - reg : should contain the DSP registers location and length
-   - interrupts : should contain the DSP interrupt
-
-1.c.i) The Auxiliary RAM (ARAM) node
-
-  Represents the non cpu-addressable ram designed mainly to store audio
-  related information.
-  The ARAM node must be placed under the DSP node.
-
-  Required properties:
-
-   - compatible : should be "nintendo,flipper-aram"
-   - reg : should contain the ARAM start (zero-based) and length
-
-1.d) The Disk Interface (DI) node
-
-  Represents the interface used to communicate with mass storage devices.
-
-  Required properties:
-
-   - compatible : should be "nintendo,flipper-di"
-   - reg : should contain the DI registers location and length
-   - interrupts : should contain the DI interrupt
-
-1.e) The Audio Interface (AI) node
-
-  Represents the interface to the external 16-bit stereo digital-to-analog
-  converter.
-
-  Required properties:
-
-   - compatible : should be "nintendo,flipper-ai"
-   - reg : should contain the AI registers location and length
-   - interrupts : should contain the AI interrupt
-
-1.f) The Serial Interface (SI) node
-
-  Represents the interface to the four single bit serial interfaces.
-  The SI is a proprietary serial interface used normally to control gamepads.
-  It's NOT a RS232-type interface.
-
-  Required properties:
-
-   - compatible : should be "nintendo,flipper-si"
-   - reg : should contain the SI registers location and length
-   - interrupts : should contain the SI interrupt
-
-1.g) The External Interface (EXI) node
-
-  Represents the multi-channel SPI-like interface.
-
-  Required properties:
-
-   - compatible : should be "nintendo,flipper-exi"
-   - reg : should contain the EXI registers location and length
-   - interrupts : should contain the EXI interrupt
-
diff --git a/Documentation/powerpc/dts-bindings/nintendo/wii.txt b/Documentation/powerpc/dts-bindings/nintendo/wii.txt
deleted file mode 100644
index a7e155a..0000000
--- a/Documentation/powerpc/dts-bindings/nintendo/wii.txt
+++ /dev/null
@@ -1,184 +0,0 @@
-
-Nintendo Wii device tree
-========================
-
-0) The root node
-
-  This node represents the Nintendo Wii video game console.
-
-  Required properties:
-
-   - model : Should be "nintendo,wii"
-   - compatible : Should be "nintendo,wii"
-
-1) The "hollywood" node
-
-  This node represents the multi-function "Hollywood" chip, which packages
-  many of the devices found in the Nintendo Wii.
-
-  Required properties:
-
-   - compatible : Should be "nintendo,hollywood"
-
-1.a) The Video Interface (VI) node
-
-  Represents the interface between the graphics processor and a external
-  video encoder.
-
-  Required properties:
-
-   - compatible : should be "nintendo,hollywood-vi","nintendo,flipper-vi"
-   - reg : should contain the VI registers location and length
-   - interrupts : should contain the VI interrupt
-
-1.b) The Processor Interface (PI) node
-
-  Represents the data and control interface between the main processor
-  and graphics and audio processor.
-
-  Required properties:
-
-  - compatible : should be "nintendo,hollywood-pi","nintendo,flipper-pi"
-  - reg : should contain the PI registers location and length
-
-1.b.i) The "Flipper" interrupt controller node
-
-  Represents the "Flipper" interrupt controller within the "Hollywood" chip.
-  The node for the "Flipper" interrupt controller must be placed under
-  the PI node.
-
-  Required properties:
-
-  - #interrupt-cells : <1>
-  - compatible : should be "nintendo,flipper-pic"
-  - interrupt-controller
-
-1.c) The Digital Signal Procesor (DSP) node
-
-  Represents the digital signal processor interface, designed to offload
-  audio related tasks.
-
-  Required properties:
-
-   - compatible : should be "nintendo,hollywood-dsp","nintendo,flipper-dsp"
-   - reg : should contain the DSP registers location and length
-   - interrupts : should contain the DSP interrupt
-
-1.d) The Serial Interface (SI) node
-
-  Represents the interface to the four single bit serial interfaces.
-  The SI is a proprietary serial interface used normally to control gamepads.
-  It's NOT a RS232-type interface.
-
-  Required properties:
-
-   - compatible : should be "nintendo,hollywood-si","nintendo,flipper-si"
-   - reg : should contain the SI registers location and length
-   - interrupts : should contain the SI interrupt
-
-1.e) The Audio Interface (AI) node
-
-  Represents the interface to the external 16-bit stereo digital-to-analog
-  converter.
-
-  Required properties:
-
-   - compatible : should be "nintendo,hollywood-ai","nintendo,flipper-ai"
-   - reg : should contain the AI registers location and length
-   - interrupts : should contain the AI interrupt
-
-1.f) The External Interface (EXI) node
-
-  Represents the multi-channel SPI-like interface.
-
-  Required properties:
-
-   - compatible : should be "nintendo,hollywood-exi","nintendo,flipper-exi"
-   - reg : should contain the EXI registers location and length
-   - interrupts : should contain the EXI interrupt
-
-1.g) The Open Host Controller Interface (OHCI) nodes
-
-  Represent the USB 1.x Open Host Controller Interfaces.
-
-  Required properties:
-
-   - compatible : should be "nintendo,hollywood-usb-ohci","usb-ohci"
-   - reg : should contain the OHCI registers location and length
-   - interrupts : should contain the OHCI interrupt
-
-1.h) The Enhanced Host Controller Interface (EHCI) node
-
-  Represents the USB 2.0 Enhanced Host Controller Interface.
-
-  Required properties:
-
-   - compatible : should be "nintendo,hollywood-usb-ehci","usb-ehci"
-   - reg : should contain the EHCI registers location and length
-   - interrupts : should contain the EHCI interrupt
-
-1.i) The Secure Digital Host Controller Interface (SDHCI) nodes
-
-  Represent the Secure Digital Host Controller Interfaces.
-
-  Required properties:
-
-   - compatible : should be "nintendo,hollywood-sdhci","sdhci"
-   - reg : should contain the SDHCI registers location and length
-   - interrupts : should contain the SDHCI interrupt
-
-1.j) The Inter-Processsor Communication (IPC) node
-
-  Represent the Inter-Processor Communication interface. This interface
-  enables communications between the Broadway and the Starlet processors.
-
-   - compatible : should be "nintendo,hollywood-ipc"
-   - reg : should contain the IPC registers location and length
-   - interrupts : should contain the IPC interrupt
-
-1.k) The "Hollywood" interrupt controller node
-
-  Represents the "Hollywood" interrupt controller within the
-  "Hollywood" chip.
-
-  Required properties:
-
-  - #interrupt-cells : <1>
-  - compatible : should be "nintendo,hollywood-pic"
-  - reg : should contain the controller registers location and length
-  - interrupt-controller
-  - interrupts : should contain the cascade interrupt of the "flipper" pic
-  - interrupt-parent: should contain the phandle of the "flipper" pic
-
-1.l) The General Purpose I/O (GPIO) controller node
-
-  Represents the dual access 32 GPIO controller interface.
-
-  Required properties:
-
-  - #gpio-cells : <2>
-  - compatible : should be "nintendo,hollywood-gpio"
-  - reg : should contain the IPC registers location and length
-  - gpio-controller
-
-1.m) The control node
-
-  Represents the control interface used to setup several miscellaneous
-  settings of the "Hollywood" chip like boot memory mappings, resets,
-  disk interface mode, etc.
-
-  Required properties:
-
-   - compatible : should be "nintendo,hollywood-control"
-   - reg : should contain the control registers location and length
-
-1.n) The Disk Interface (DI) node
-
-  Represents the interface used to communicate with mass storage devices.
-
-  Required properties:
-
-   - compatible : should be "nintendo,hollywood-di"
-   - reg : should contain the DI registers location and length
-   - interrupts : should contain the DI interrupt
-
diff --git a/Documentation/powerpc/dts-bindings/phy.txt b/Documentation/powerpc/dts-bindings/phy.txt
deleted file mode 100644
index bb8c742..0000000
--- a/Documentation/powerpc/dts-bindings/phy.txt
+++ /dev/null
@@ -1,25 +0,0 @@
-PHY nodes
-
-Required properties:
-
- - device_type : Should be "ethernet-phy"
- - interrupts : <a b> where a is the interrupt number and b is a
-   field that represents an encoding of the sense and level
-   information for the interrupt.  This should be encoded based on
-   the information in section 2) depending on the type of interrupt
-   controller you have.
- - interrupt-parent : the phandle for the interrupt controller that
-   services interrupts for this device.
- - reg : The ID number for the phy, usually a small integer
- - linux,phandle :  phandle for this node; likely referenced by an
-   ethernet controller node.
-
-Example:
-
-ethernet-phy@0 {
-	linux,phandle = <2452000>
-	interrupt-parent = <40000>;
-	interrupts = <35 1>;
-	reg = <0>;
-	device_type = "ethernet-phy";
-};
diff --git a/Documentation/powerpc/dts-bindings/spi-bus.txt b/Documentation/powerpc/dts-bindings/spi-bus.txt
deleted file mode 100644
index e782add..0000000
--- a/Documentation/powerpc/dts-bindings/spi-bus.txt
+++ /dev/null
@@ -1,57 +0,0 @@
-SPI (Serial Peripheral Interface) busses
-
-SPI busses can be described with a node for the SPI master device
-and a set of child nodes for each SPI slave on the bus.  For this
-discussion, it is assumed that the system's SPI controller is in
-SPI master mode.  This binding does not describe SPI controllers
-in slave mode.
-
-The SPI master node requires the following properties:
-- #address-cells  - number of cells required to define a chip select
-    		address on the SPI bus.
-- #size-cells     - should be zero.
-- compatible      - name of SPI bus controller following generic names
-    		recommended practice.
-No other properties are required in the SPI bus node.  It is assumed
-that a driver for an SPI bus device will understand that it is an SPI bus.
-However, the binding does not attempt to define the specific method for
-assigning chip select numbers.  Since SPI chip select configuration is
-flexible and non-standardized, it is left out of this binding with the
-assumption that board specific platform code will be used to manage
-chip selects.  Individual drivers can define additional properties to
-support describing the chip select layout.
-
-SPI slave nodes must be children of the SPI master node and can
-contain the following properties.
-- reg             - (required) chip select address of device.
-- compatible      - (required) name of SPI device following generic names
-    		recommended practice
-- spi-max-frequency - (required) Maximum SPI clocking speed of device in Hz
-- spi-cpol        - (optional) Empty property indicating device requires
-    		inverse clock polarity (CPOL) mode
-- spi-cpha        - (optional) Empty property indicating device requires
-    		shifted clock phase (CPHA) mode
-- spi-cs-high     - (optional) Empty property indicating device requires
-    		chip select active high
-
-SPI example for an MPC5200 SPI bus:
-	spi@f00 {
-		#address-cells = <1>;
-		#size-cells = <0>;
-		compatible = "fsl,mpc5200b-spi","fsl,mpc5200-spi";
-		reg = <0xf00 0x20>;
-		interrupts = <2 13 0 2 14 0>;
-		interrupt-parent = <&mpc5200_pic>;
-
-		ethernet-switch@0 {
-			compatible = "micrel,ks8995m";
-			spi-max-frequency = <1000000>;
-			reg = <0>;
-		};
-
-		codec@1 {
-			compatible = "ti,tlv320aic26";
-			spi-max-frequency = <100000>;
-			reg = <1>;
-		};
-	};
diff --git a/Documentation/powerpc/dts-bindings/usb-ehci.txt b/Documentation/powerpc/dts-bindings/usb-ehci.txt
deleted file mode 100644
index fa18612..0000000
--- a/Documentation/powerpc/dts-bindings/usb-ehci.txt
+++ /dev/null
@@ -1,25 +0,0 @@
-USB EHCI controllers
-
-Required properties:
-  - compatible : should be "usb-ehci".
-  - reg : should contain at least address and length of the standard EHCI
-    register set for the device. Optional platform-dependent registers
-    (debug-port or other) can be also specified here, but only after
-    definition of standard EHCI registers.
-  - interrupts : one EHCI interrupt should be described here.
-If device registers are implemented in big endian mode, the device
-node should have "big-endian-regs" property.
-If controller implementation operates with big endian descriptors,
-"big-endian-desc" property should be specified.
-If both big endian registers and descriptors are used by the controller
-implementation, "big-endian" property can be specified instead of having
-both "big-endian-regs" and "big-endian-desc".
-
-Example (Sequoia 440EPx):
-    ehci@e0000300 {
-	   compatible = "ibm,usb-ehci-440epx", "usb-ehci";
-	   interrupt-parent = <&UIC0>;
-	   interrupts = <1a 4>;
-	   reg = <0 e0000300 90 0 e0000390 70>;
-	   big-endian;
-   };
diff --git a/Documentation/powerpc/dts-bindings/xilinx.txt b/Documentation/powerpc/dts-bindings/xilinx.txt
deleted file mode 100644
index 299d092..0000000
--- a/Documentation/powerpc/dts-bindings/xilinx.txt
+++ /dev/null
@@ -1,306 +0,0 @@
-   d) Xilinx IP cores
-
-   The Xilinx EDK toolchain ships with a set of IP cores (devices) for use
-   in Xilinx Spartan and Virtex FPGAs.  The devices cover the whole range
-   of standard device types (network, serial, etc.) and miscellaneous
-   devices (gpio, LCD, spi, etc).  Also, since these devices are
-   implemented within the fpga fabric every instance of the device can be
-   synthesised with different options that change the behaviour.
-
-   Each IP-core has a set of parameters which the FPGA designer can use to
-   control how the core is synthesized.  Historically, the EDK tool would
-   extract the device parameters relevant to device drivers and copy them
-   into an 'xparameters.h' in the form of #define symbols.  This tells the
-   device drivers how the IP cores are configured, but it requires the kernel
-   to be recompiled every time the FPGA bitstream is resynthesized.
-
-   The new approach is to export the parameters into the device tree and
-   generate a new device tree each time the FPGA bitstream changes.  The
-   parameters which used to be exported as #defines will now become
-   properties of the device node.  In general, device nodes for IP-cores
-   will take the following form:
-
-	(name): (generic-name)@(base-address) {
-		compatible = "xlnx,(ip-core-name)-(HW_VER)"
-			     [, (list of compatible devices), ...];
-		reg = <(baseaddr) (size)>;
-		interrupt-parent = <&interrupt-controller-phandle>;
-		interrupts = < ... >;
-		xlnx,(parameter1) = "(string-value)";
-		xlnx,(parameter2) = <(int-value)>;
-	};
-
-	(generic-name):   an open firmware-style name that describes the
-			generic class of device.  Preferably, this is one word, such
-			as 'serial' or 'ethernet'.
-	(ip-core-name):	the name of the ip block (given after the BEGIN
-			directive in system.mhs).  Should be in lowercase
-			and all underscores '_' converted to dashes '-'.
-	(name):		is derived from the "PARAMETER INSTANCE" value.
-	(parameter#):	C_* parameters from system.mhs.  The C_ prefix is
-			dropped from the parameter name, the name is converted
-			to lowercase and all underscore '_' characters are
-			converted to dashes '-'.
-	(baseaddr):	the baseaddr parameter value (often named C_BASEADDR).
-	(HW_VER):	from the HW_VER parameter.
-	(size):		the address range size (often C_HIGHADDR - C_BASEADDR + 1).
-
-   Typically, the compatible list will include the exact IP core version
-   followed by an older IP core version which implements the same
-   interface or any other device with the same interface.
-
-   'reg', 'interrupt-parent' and 'interrupts' are all optional properties.
-
-   For example, the following block from system.mhs:
-
-	BEGIN opb_uartlite
-		PARAMETER INSTANCE = opb_uartlite_0
-		PARAMETER HW_VER = 1.00.b
-		PARAMETER C_BAUDRATE = 115200
-		PARAMETER C_DATA_BITS = 8
-		PARAMETER C_ODD_PARITY = 0
-		PARAMETER C_USE_PARITY = 0
-		PARAMETER C_CLK_FREQ = 50000000
-		PARAMETER C_BASEADDR = 0xEC100000
-		PARAMETER C_HIGHADDR = 0xEC10FFFF
-		BUS_INTERFACE SOPB = opb_7
-		PORT OPB_Clk = CLK_50MHz
-		PORT Interrupt = opb_uartlite_0_Interrupt
-		PORT RX = opb_uartlite_0_RX
-		PORT TX = opb_uartlite_0_TX
-		PORT OPB_Rst = sys_bus_reset_0
-	END
-
-   becomes the following device tree node:
-
-	opb_uartlite_0: serial@ec100000 {
-		device_type = "serial";
-		compatible = "xlnx,opb-uartlite-1.00.b";
-		reg = <ec100000 10000>;
-		interrupt-parent = <&opb_intc_0>;
-		interrupts = <1 0>; // got this from the opb_intc parameters
-		current-speed = <d#115200>;	// standard serial device prop
-		clock-frequency = <d#50000000>;	// standard serial device prop
-		xlnx,data-bits = <8>;
-		xlnx,odd-parity = <0>;
-		xlnx,use-parity = <0>;
-	};
-
-   Some IP cores actually implement 2 or more logical devices.  In
-   this case, the device should still describe the whole IP core with
-   a single node and add a child node for each logical device.  The
-   ranges property can be used to translate from parent IP-core to the
-   registers of each device.  In addition, the parent node should be
-   compatible with the bus type 'xlnx,compound', and should contain
-   #address-cells and #size-cells, as with any other bus.  (Note: this
-   makes the assumption that both logical devices have the same bus
-   binding.  If this is not true, then separate nodes should be used
-   for each logical device).  The 'cell-index' property can be used to
-   enumerate logical devices within an IP core.  For example, the
-   following is the system.mhs entry for the dual ps2 controller found
-   on the ml403 reference design.
-
-	BEGIN opb_ps2_dual_ref
-		PARAMETER INSTANCE = opb_ps2_dual_ref_0
-		PARAMETER HW_VER = 1.00.a
-		PARAMETER C_BASEADDR = 0xA9000000
-		PARAMETER C_HIGHADDR = 0xA9001FFF
-		BUS_INTERFACE SOPB = opb_v20_0
-		PORT Sys_Intr1 = ps2_1_intr
-		PORT Sys_Intr2 = ps2_2_intr
-		PORT Clkin1 = ps2_clk_rx_1
-		PORT Clkin2 = ps2_clk_rx_2
-		PORT Clkpd1 = ps2_clk_tx_1
-		PORT Clkpd2 = ps2_clk_tx_2
-		PORT Rx1 = ps2_d_rx_1
-		PORT Rx2 = ps2_d_rx_2
-		PORT Txpd1 = ps2_d_tx_1
-		PORT Txpd2 = ps2_d_tx_2
-	END
-
-   It would result in the following device tree nodes:
-
-	opb_ps2_dual_ref_0: opb-ps2-dual-ref@a9000000 {
-		#address-cells = <1>;
-		#size-cells = <1>;
-		compatible = "xlnx,compound";
-		ranges = <0 a9000000 2000>;
-		// If this device had extra parameters, then they would
-		// go here.
-		ps2@0 {
-			compatible = "xlnx,opb-ps2-dual-ref-1.00.a";
-			reg = <0 40>;
-			interrupt-parent = <&opb_intc_0>;
-			interrupts = <3 0>;
-			cell-index = <0>;
-		};
-		ps2@1000 {
-			compatible = "xlnx,opb-ps2-dual-ref-1.00.a";
-			reg = <1000 40>;
-			interrupt-parent = <&opb_intc_0>;
-			interrupts = <3 0>;
-			cell-index = <0>;
-		};
-	};
-
-   Also, the system.mhs file defines bus attachments from the processor
-   to the devices.  The device tree structure should reflect the bus
-   attachments.  Again an example; this system.mhs fragment:
-
-	BEGIN ppc405_virtex4
-		PARAMETER INSTANCE = ppc405_0
-		PARAMETER HW_VER = 1.01.a
-		BUS_INTERFACE DPLB = plb_v34_0
-		BUS_INTERFACE IPLB = plb_v34_0
-	END
-
-	BEGIN opb_intc
-		PARAMETER INSTANCE = opb_intc_0
-		PARAMETER HW_VER = 1.00.c
-		PARAMETER C_BASEADDR = 0xD1000FC0
-		PARAMETER C_HIGHADDR = 0xD1000FDF
-		BUS_INTERFACE SOPB = opb_v20_0
-	END
-
-	BEGIN opb_uart16550
-		PARAMETER INSTANCE = opb_uart16550_0
-		PARAMETER HW_VER = 1.00.d
-		PARAMETER C_BASEADDR = 0xa0000000
-		PARAMETER C_HIGHADDR = 0xa0001FFF
-		BUS_INTERFACE SOPB = opb_v20_0
-	END
-
-	BEGIN plb_v34
-		PARAMETER INSTANCE = plb_v34_0
-		PARAMETER HW_VER = 1.02.a
-	END
-
-	BEGIN plb_bram_if_cntlr
-		PARAMETER INSTANCE = plb_bram_if_cntlr_0
-		PARAMETER HW_VER = 1.00.b
-		PARAMETER C_BASEADDR = 0xFFFF0000
-		PARAMETER C_HIGHADDR = 0xFFFFFFFF
-		BUS_INTERFACE SPLB = plb_v34_0
-	END
-
-	BEGIN plb2opb_bridge
-		PARAMETER INSTANCE = plb2opb_bridge_0
-		PARAMETER HW_VER = 1.01.a
-		PARAMETER C_RNG0_BASEADDR = 0x20000000
-		PARAMETER C_RNG0_HIGHADDR = 0x3FFFFFFF
-		PARAMETER C_RNG1_BASEADDR = 0x60000000
-		PARAMETER C_RNG1_HIGHADDR = 0x7FFFFFFF
-		PARAMETER C_RNG2_BASEADDR = 0x80000000
-		PARAMETER C_RNG2_HIGHADDR = 0xBFFFFFFF
-		PARAMETER C_RNG3_BASEADDR = 0xC0000000
-		PARAMETER C_RNG3_HIGHADDR = 0xDFFFFFFF
-		BUS_INTERFACE SPLB = plb_v34_0
-		BUS_INTERFACE MOPB = opb_v20_0
-	END
-
-   Gives this device tree (some properties removed for clarity):
-
-	plb@0 {
-		#address-cells = <1>;
-		#size-cells = <1>;
-		compatible = "xlnx,plb-v34-1.02.a";
-		device_type = "ibm,plb";
-		ranges; // 1:1 translation
-
-		plb_bram_if_cntrl_0: bram@ffff0000 {
-			reg = <ffff0000 10000>;
-		}
-
-		opb@20000000 {
-			#address-cells = <1>;
-			#size-cells = <1>;
-			ranges = <20000000 20000000 20000000
-				  60000000 60000000 20000000
-				  80000000 80000000 40000000
-				  c0000000 c0000000 20000000>;
-
-			opb_uart16550_0: serial@a0000000 {
-				reg = <a00000000 2000>;
-			};
-
-			opb_intc_0: interrupt-controller@d1000fc0 {
-				reg = <d1000fc0 20>;
-			};
-		};
-	};
-
-   That covers the general approach to binding xilinx IP cores into the
-   device tree.  The following are bindings for specific devices:
-
-      i) Xilinx ML300 Framebuffer
-
-      Simple framebuffer device from the ML300 reference design (also on the
-      ML403 reference design as well as others).
-
-      Optional properties:
-       - resolution = <xres yres> : pixel resolution of framebuffer.  Some
-                                    implementations use a different resolution.
-                                    Default is <d#640 d#480>
-       - virt-resolution = <xvirt yvirt> : Size of framebuffer in memory.
-                                           Default is <d#1024 d#480>.
-       - rotate-display (empty) : rotate display 180 degrees.
-
-      ii) Xilinx SystemACE
-
-      The Xilinx SystemACE device is used to program FPGAs from an FPGA
-      bitstream stored on a CF card.  It can also be used as a generic CF
-      interface device.
-
-      Optional properties:
-       - 8-bit (empty) : Set this property for SystemACE in 8 bit mode
-
-      iii) Xilinx EMAC and Xilinx TEMAC
-
-      Xilinx Ethernet devices.  In addition to general xilinx properties
-      listed above, nodes for these devices should include a phy-handle
-      property, and may include other common network device properties
-      like local-mac-address.
-
-      iv) Xilinx Uartlite
-
-      Xilinx uartlite devices are simple fixed speed serial ports.
-
-      Required properties:
-       - current-speed : Baud rate of uartlite
-
-      v) Xilinx hwicap
-
-		Xilinx hwicap devices provide access to the configuration logic
-		of the FPGA through the Internal Configuration Access Port
-		(ICAP).  The ICAP enables partial reconfiguration of the FPGA,
-		readback of the configuration information, and some control over
-		'warm boots' of the FPGA fabric.
-
-		Required properties:
-		- xlnx,family : The family of the FPGA, necessary since the
-                      capabilities of the underlying ICAP hardware
-                      differ between different families.  May be
-                      'virtex2p', 'virtex4', or 'virtex5'.
-
-      vi) Xilinx Uart 16550
-
-      Xilinx UART 16550 devices are very similar to the NS16550 but with
-      different register spacing and an offset from the base address.
-
-      Required properties:
-       - clock-frequency : Frequency of the clock input
-       - reg-offset : A value of 3 is required
-       - reg-shift : A value of 2 is required
-
-      vii) Xilinx USB Host controller
-
-      The Xilinx USB host controller is EHCI compatible but with a different
-      base address for the EHCI registers, and it is always a big-endian
-      USB Host controller. The hardware can be configured as high speed only,
-      or high speed/full speed hybrid.
-
-      Required properties:
-      - xlnx,support-usb-fs: A value 0 means the core is built as high speed
-                             only. A value 1 means the core also supports
-                             full speed devices.
-

