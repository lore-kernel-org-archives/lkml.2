Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936Ab1AXE3j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 23:29:39 -0500
Received: from www.tglx.de ([62.245.132.106]:55551 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752497Ab1AXE3a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 23:29:30 -0500
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-kernel@vger.kernel.org
Cc: sodaville@linutronix.de, x86@kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Dirk Brandewie <dirk.brandewie@gmail.com>
Subject: [PATCH TIP 03/14] x86/dtb: Add a device tree for CE4100
Date: Mon, 24 Jan 2011 09:58:51 +0530
Message-Id: <1295843342-1122-4-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1295843342-1122-1-git-send-email-bigeasy@linutronix.de>
References: <1295843342-1122-1-git-send-email-bigeasy@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: devicetree-discuss@lists.ozlabs.org
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
---
 arch/x86/platform/ce4100/falconfalls.dts |  228 ++++++++++++++++++++++++++++++
 1 files changed, 228 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/platform/ce4100/falconfalls.dts

diff --git a/arch/x86/platform/ce4100/falconfalls.dts b/arch/x86/platform/ce4100/falconfalls.dts
new file mode 100644
index 0000000..c2df5c8
--- /dev/null
+++ b/arch/x86/platform/ce4100/falconfalls.dts
@@ -0,0 +1,228 @@
+/*
+ * CE4100 on Falcon Falls
+ *
+ * (c) Copyright 2010 Intel Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; version 2 of the License.
+ */
+/dts-v1/;
+/ {
+	model = "intel,falconfalls";
+	compatible = "intel,falconfalls";
+	#address-cells = <1>;
+	#size-cells = <1>;
+
+	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		cpu@0 {
+			device_type = "cpu";
+			compatible = "intel,ce4100";
+			reg = <0>;
+			lapic = <&lapic0>;
+		};
+	};
+
+	soc@0 {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		compatible = "intel,ce4100-immr";
+		ranges;
+
+		ioapic1: pic@fec00000 {
+			#interrupt-cells = <2>;
+			compatible = "intel,ioapic-ce4100", "intel,ioapic";
+			interrupt-controller;
+			reg = <0xfec00000 0x1000>;
+		};
+
+		timer@fed00000 {
+			compatible = "intel,hpet-ce4100", "intel,hpet";
+			reg = <0xfed00000 0x200>;
+		};
+
+		lapic0: interrupt-controller@fee00000 {
+			compatible = "intel,lapic-ce4100", "intel,lapic";
+			reg = <0xfee00000 0x1000>;
+		};
+
+		pci@3fc {
+			#address-cells = <3>;
+			#interrupt-cells = <1>;
+			#size-cells = <2>;
+			compatible = "intel,ce4100-pci", "pci";
+			device_type = "pci";
+			bus-range = <0 0>;
+			ranges = <0x2000000 0 0xbffff000 0xbffff000 0 0x1000
+				  0x2000000 0 0xdffe0000 0xdffe0000 0 0x1000
+				  0x0000000 0 0x0	 0x0	    0 0x100>;
+
+			isa@0 {
+				#address-cells = <2>;
+				#size-cells = <1>;
+				compatible = "isa";
+				ranges = <1 0 0 0 0 0x100>;
+
+				rtc@70 {
+					compatible = "intel,ce4100-rtc", "motorola,mc146818";
+					interrupts = <8 3>;
+					interrupt-parent = <&ioapic1>;
+					ctrl-reg = <2>;
+					freq-reg = <0x26>;
+					reg = <1 0x70 2>;
+				};
+			};
+
+			/* Secondary IO-APIC */
+			ioapic2: pic@bffff000 {
+				#interrupt-cells = <2>;
+				compatible = "intel,ioapic-ce4100", "intel,ioapic";
+				interrupt-controller;
+				reg = <0x100 0x0 0x0 0x0 0x0>;
+				assigned-addresses = <0x02000000 0x0 0xbffff000 0x0 0x1000>;
+			};
+
+			pci@av {
+				#address-cells = <3>;
+				#interrupt-cells = <1>;
+				#size-cells = <2>;
+				compatible = "intel,ce4100-pci";
+				device_type = "pci";
+				bus-range = <1 1>;
+				ranges = <0x2000000 0 0xdffe0000 0x2000000 0 0xdffe0000 0 0x1000>;
+
+				interrupt-map-mask = <0xffffff 0x0 0x0 0x0>;
+				interrupt-map = <
+					/* GFX: 0x2E5B */
+					0x11000 0x0 0x0 0x0 &ioapic2 0 0x1
+					/* ***** FIXME ****** Compositing Engine: 0x2E72 */
+					/* 0x11100 0x0 0x0 0x1 &ioapic2 0 0x1 */
+					/* MFD: 0x2E5C */
+					0x11800 0x0 0x0 0x0 &ioapic2 2 0x1
+					/* TS Prefilter: 0x2E5D */
+					0x12000 0x0 0x0 0x0 &ioapic2 4 0x1
+					/* TS Demux: 0x2E5E */
+					0x12100 0x0 0x0 0x0 &ioapic2 5 0x1
+					/* ***** FIXME ***** Audio DSP: 0x2E5F */
+					/* 0x13000 0x0 0x0 0x1 &ioapic2 0 0x1 */
+					/* Audio Interfaces: 0x2E60 */
+					0x13200 0x0 0x0 0x0 &ioapic2 8 0x1
+					/* VDC: 0x2E61 */
+					0x14000 0x0 0x0 0x0 &ioapic2 9 0x1
+					/* DPE: 0x2E62 */
+					0x14100 0x0 0x0 0x0 &ioapic2 10 0x1
+					/* HDMI Tx: 0x2E63 */
+					0x14200 0x0 0x0 0x0 &ioapic2 11 0x1
+					/* SEC: 0x2E64 */
+					0x14800 0x0 0x0 0x0 &ioapic2 12 0x1
+					/* EXP: 0x2E65 */
+					0x15000 0x0 0x0 0x0 &ioapic2 13 0x1
+					/* UART0/1: 0x2E66 */
+					0x15800 0x0 0x0 0x0 &ioapic2 14 0x1
+					/* GPIO: 0x2E67 */
+					0x15900 0x0 0x0 0x0 &ioapic2 15 0x1
+					/* I2C0/1/2: 0x2E68 */
+					0x15a00 0x0 0x0 0x0 &ioapic2 16 0x1
+					/* Smart Card 0/1: 0x2E69 */
+					0x15b00 0x0 0x0 0x0 &ioapic2 15 0x1
+					/* SPI: 0x2E6A */
+					0x15c00 0x0 0x0 0x0 &ioapic2 15 0x1
+					/* MSPOD: 0x2E6B */
+					0x15d00 0x0 0x0 0x0 &ioapic2 19 0x1
+					/* IR: 0x2E6C */
+					0x15e00 0x0 0x0 0x0 &ioapic2 16 0x1
+					/* **** FIXME ***** DFX: 0x2E6D */
+					/* 0x15f00 0x0 0x0 0x1 &ioapic2 0x0 0x1 */
+					/* Gig Ethernet: 0x2E6E */
+					0x16000 0x0 0x0 0x0 &ioapic2 21 0x1
+					/* IEEE1588 and Clock Recovery Unit: 0x2E6F */
+					0x16100 0x0 0x0 0x0 &ioapic2 3 0x1
+					/* USB0: 0x2E70 */
+					0x16800 0x0 0x0 0x0 &ioapic2 22 0x3
+					/* USB1: 0x2E70 */
+					0x16900 0x0 0x0 0x0 &ioapic2 22 0x3
+					/* SATA: 0x2E71 */
+					0x17000 0x0 0x0 0x0 &ioapic2 23 0x3
+					>;
+
+				i2c-controller@15a00,0,0 {
+					#address-cells = <2>;
+					#size-cells = <1>;
+					compatible = "pci8086,2e68.2",
+						   "pci8086,2e68",
+						   "pciclass,ff0000",
+						   "pciclass,ff00";
+
+					reg = <0x15a00 0x0 0x0 0x0 0x0>;
+					ranges = <0 0	0x02000000 0 0xdffe0500	0x100
+						  1 0	0x02000000 0 0xdffe0600	0x100
+						  2 0	0x02000000 0 0xdffe0700	0x100>;
+
+					i2c@0 {
+						#address-cells = <1>;
+						#size-cells = <0>;
+						compatible = "intel,ce4100-i2c-controller";
+						reg = <0 0 0x100>;
+					};
+
+					i2c@1 {
+						#address-cells = <1>;
+						#size-cells = <0>;
+						compatible = "intel,ce4100-i2c-controller";
+						reg = <1 0 0x100>;
+
+						gpio@26 {
+							compatible = "ti,pcf8575";
+							reg = <0x26>;
+						};
+					};
+
+					i2c@2 {
+						#address-cells = <1>;
+						#size-cells = <0>;
+						compatible = "intel,ce4100-i2c-controller";
+						reg = <2 0 0x100>;
+
+						gpio@26 {
+							compatible = "ti,pcf8575";
+							reg = <0x26>;
+						};
+					};
+				};
+
+				spi-controller@15c00,0,0 {
+					#address-cells = <1>;
+					#size-cells = <0>;
+					compatible =
+						"pci8086,2e6a.2",
+						"pci8086,2e6a",
+						"pciclass,ff0000",
+						"pciclass,ff00";
+
+					reg = <0x15c00 0x0 0x0 0x0 0x0>;
+
+					dac@0 {
+						compatible = "ti,pcm1755";
+						reg = <0>;
+						spi-max-frequency = <115200>;
+					};
+
+					dac@1 {
+						compatible = "ti,pcm1609a";
+						reg = <1>;
+						spi-max-frequency = <115200>;
+					};
+
+					eeprom@2 {
+						compatible = "atmel,at93c46";
+						reg = <2>;
+						spi-max-frequency = <115200>;
+					};
+				};
+			};
+		};
+	};
+};
-- 
1.7.3.2

