Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792Ab2DUJga (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 05:36:30 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:52107 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752077Ab2DUJfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 05:35:21 -0400
From: Roland Stigge <stigge@antcom.de>
To: arm@kernel.org, thierry.reding@avionic-design.de, arnd@arndb.de,
        linux-arm-kernel@lists.infradead.org, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, dmitry.torokhov@gmail.com,
        axel.lin@gmail.com, broonie@opensource.wolfsonmicro.com,
        marek.vasut@gmail.com, devel@driverdev.osuosl.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH v5 8/10] ARM: LPC32xx: DTS files for device tree conversion
Date: Sat, 21 Apr 2012 11:34:26 +0200
Message-Id: <1335000868-21974-9-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1335000868-21974-1-git-send-email-stigge@antcom.de>
References: <1335000868-21974-1-git-send-email-stigge@antcom.de>
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the dts files for the reference machine of LPC32xx:

* arch/arm/boot/dts/lpc32xx.dtsi: Include for devices based on LPC32xx
* arch/arm/boot/dts/phy3250.dts: Board support for PHYTEC phyCORE-LPC3250

Signed-off-by: Roland Stigge <stigge@antcom.de>

---
 arch/arm/boot/dts/lpc32xx.dtsi |  292 +++++++++++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/phy3250.dts  |  145 ++++++++++++++++++++
 2 files changed, 437 insertions(+)

--- /dev/null
+++ linux-2.6/arch/arm/boot/dts/lpc32xx.dtsi
@@ -0,0 +1,292 @@
+/*
+ * NXP LPC32xx SoC
+ *
+ * Copyright 2012 Roland Stigge <stigge@antcom.de>
+ *
+ * The code contained herein is licensed under the GNU General Public
+ * License. You may obtain a copy of the GNU General Public License
+ * Version 2 or later at the following locations:
+ *
+ * http://www.opensource.org/licenses/gpl-license.html
+ * http://www.gnu.org/copyleft/gpl.html
+ */
+
+/include/ "skeleton.dtsi"
+
+/ {
+	compatible = "nxp,lpc3220";
+	interrupt-parent = <&mic>;
+
+	cpus {
+		cpu@0 {
+			compatible = "arm,arm926ejs";
+		};
+	};
+
+	ahb {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		compatible = "simple-bus";
+		ranges = <0x20000000 0x20000000 0x30000000>;
+
+		/*
+		 * Enable either SLC or MLC
+		 */
+		slc: flash@20020000 {
+			compatible = "nxp,nand-slc";
+			reg = <0x20020000 0x1000>;
+			status = "disable";
+		};
+
+		mlc: flash@200B0000 {
+			compatible = "nxp,nand-mlc";
+			reg = <0x200B0000 0x1000>;
+			status = "disable";
+		};
+
+		dma@31000000 {
+			compatible = "arm,pl080", "arm,primecell";
+			reg = <0x31000000 0x1000>;
+			interrupts = <0x1c 0>;
+		};
+
+		/*
+		 * Enable either ohci or usbd (gadget)!
+		 */
+		ohci@31020000 {
+			compatible = "nxp,ohci-nxp", "usb-ohci";
+			reg = <0x31020000 0x300>;
+			interrupts = <0x3b 0>;
+			status = "disable";
+		};
+
+		usbd@31020000 {
+			compatible = "nxp,lpc3220-udc";
+			reg = <0x31020000 0x300>;
+			interrupts = <0x3d 0>, <0x3e 0>, <0x3c 0>, <0x3a 0>;
+			status = "disable";
+		};
+
+		clcd@31040000 {
+			compatible = "arm,pl110", "arm,primecell";
+			reg = <0x31040000 0x1000>;
+			interrupts = <0x0e 0>;
+			status = "disable";
+		};
+
+		mac: ethernet@31060000 {
+			compatible = "nxp,lpc-eth";
+			reg = <0x31060000 0x1000>;
+			interrupts = <0x1d 0>;
+		};
+
+		apb {
+			#address-cells = <1>;
+			#size-cells = <1>;
+			compatible = "simple-bus";
+			ranges = <0x20000000 0x20000000 0x30000000>;
+
+			ssp0: ssp@20084000 {
+				compatible = "arm,pl022", "arm,primecell";
+				reg = <0x20084000 0x1000>;
+				interrupts = <0x14 0>;
+			};
+
+			spi1: spi@20088000 {
+				compatible = "nxp,spi";
+				reg = <0x20088000 0x1000>;
+			};
+
+			ssp1: ssp@2008c000 {
+				compatible = "arm,pl022", "arm,primecell";
+				reg = <0x2008c000 0x1000>;
+				interrupts = <0x15 0>;
+			};
+
+			spi2: spi@20090000 {
+				compatible = "nxp,spi";
+				reg = <0x20090000 0x1000>;
+			};
+
+			i2s0: i2s@20094000 {
+				compatible = "nxp,i2s";
+				reg = <0x20094000 0x1000>;
+			};
+
+			sd@20098000 {
+				compatible = "arm,pl180", "arm,primecell";
+				reg = <0x20098000 0x1000>;
+				interrupts = <0x0f 0>, <0x0d 0>;
+			};
+
+			i2s1: i2s@2009C000 {
+				compatible = "nxp,i2s";
+				reg = <0x2009C000 0x1000>;
+			};
+
+			uart3: serial@40080000 {
+				compatible = "nxp,serial";
+				reg = <0x40080000 0x1000>;
+			};
+
+			uart4: serial@40088000 {
+				compatible = "nxp,serial";
+				reg = <0x40088000 0x1000>;
+			};
+
+			uart5: serial@40090000 {
+				compatible = "nxp,serial";
+				reg = <0x40090000 0x1000>;
+			};
+
+			uart6: serial@40098000 {
+				compatible = "nxp,serial";
+				reg = <0x40098000 0x1000>;
+			};
+
+			i2c1: i2c@400A0000 {
+				compatible = "nxp,pnx-i2c";
+				reg = <0x400A0000 0x100>;
+				interrupts = <0x33 0>;
+				#address-cells = <1>;
+				#size-cells = <0>;
+				pnx,timeout = <0x64>;
+			};
+
+			i2c2: i2c@400A8000 {
+				compatible = "nxp,pnx-i2c";
+				reg = <0x400A8000 0x100>;
+				interrupts = <0x32 0>;
+				#address-cells = <1>;
+				#size-cells = <0>;
+				pnx,timeout = <0x64>;
+			};
+
+			i2cusb: i2c@31020300 {
+				compatible = "nxp,pnx-i2c";
+				reg = <0x31020300 0x100>;
+				interrupts = <0x3f 0>;
+				#address-cells = <1>;
+				#size-cells = <0>;
+				pnx,timeout = <0x64>;
+			};
+		};
+
+		fab {
+			#address-cells = <1>;
+			#size-cells = <1>;
+			compatible = "simple-bus";
+			ranges = <0x20000000 0x20000000 0x30000000>;
+
+			/*
+			 * MIC Interrupt controller includes:
+			 *   MIC @40008000
+			 *   SIC1 @4000C000
+			 *   SIC2 @40010000
+			 */
+			mic: interrupt-controller@40008000 {
+				compatible = "nxp,lpc3220-mic";
+				interrupt-controller;
+				reg = <0x40008000 0xC000>;
+				#interrupt-cells = <2>;
+			};
+
+			uart1: serial@40014000 {
+				compatible = "nxp,serial";
+				reg = <0x40014000 0x1000>;
+			};
+
+			uart2: serial@40018000 {
+				compatible = "nxp,serial";
+				reg = <0x40018000 0x1000>;
+			};
+
+			uart7: serial@4001C000 {
+				compatible = "nxp,serial";
+				reg = <0x4001C000 0x1000>;
+			};
+
+			rtc@40024000 {
+				compatible = "nxp,lpc3220-rtc";
+				reg = <0x40024000 0x1000>;
+				interrupts = <0x34 0>;
+			};
+
+			gpio: gpio@40028000 {
+				compatible = "nxp,lpc3220-gpio";
+				reg = <0x40028000 0x1000>;
+				/* create a private address space for enumeration */
+				#address-cells = <1>;
+				#size-cells = <0>;
+
+				gpio_p0: gpio-bank@0 {
+					gpio-controller;
+					#gpio-cells = <2>;
+					reg = <0>;
+				};
+
+				gpio_p1: gpio-bank@1 {
+					gpio-controller;
+					#gpio-cells = <2>;
+					reg = <1>;
+				};
+
+				gpio_p2: gpio-bank@2 {
+					gpio-controller;
+					#gpio-cells = <2>;
+					reg = <2>;
+				};
+
+				gpio_p3: gpio-bank@3 {
+					gpio-controller;
+					#gpio-cells = <2>;
+					reg = <3>;
+				};
+
+				gpi_p3: gpio-bank@4 {
+					gpio-controller;
+					#gpio-cells = <2>;
+					reg = <4>;
+				};
+
+				gpo_p3: gpio-bank@5 {
+					gpio-controller;
+					#gpio-cells = <2>;
+					reg = <5>;
+				};
+			};
+
+			watchdog@4003C000 {
+				compatible = "nxp,pnx4008-wdt";
+				reg = <0x4003C000 0x1000>;
+			};
+
+			/*
+			 * TSC vs. ADC: Since those two share the same
+			 * hardware, you need to choose from one of the
+			 * following two and do 'status = "okay";' for one of
+			 * them
+			 */
+
+			adc@40048000 {
+				compatible = "nxp,lpc3220-adc";
+				reg = <0x40048000 0x1000>;
+				interrupts = <0x27 0>;
+				status = "disable";
+			};
+
+			tsc@40048000 {
+				compatible = "nxp,lpc3220-tsc";
+				reg = <0x40048000 0x1000>;
+				interrupts = <0x27 0>;
+				status = "disable";
+			};
+
+			key@40050000 {
+				compatible = "nxp,lpc3220-key";
+				reg = <0x40050000 0x1000>;
+			};
+
+		};
+	};
+};
--- /dev/null
+++ linux-2.6/arch/arm/boot/dts/phy3250.dts
@@ -0,0 +1,145 @@
+/*
+ * PHYTEC phyCORE-LPC3250 board
+ *
+ * Copyright 2012 Roland Stigge <stigge@antcom.de>
+ *
+ * The code contained herein is licensed under the GNU General Public
+ * License. You may obtain a copy of the GNU General Public License
+ * Version 2 or later at the following locations:
+ *
+ * http://www.opensource.org/licenses/gpl-license.html
+ * http://www.gnu.org/copyleft/gpl.html
+ */
+
+/dts-v1/;
+/include/ "lpc32xx.dtsi"
+
+/ {
+	model = "PHYTEC phyCORE-LPC3250 board based on NXP LPC3250";
+	compatible = "phytec,phy3250", "nxp,lpc3250";
+	#address-cells = <1>;
+	#size-cells = <1>;
+
+	memory {
+		device_type = "memory";
+		reg = <0 0x4000000>;
+	};
+
+	ahb {
+		mac: ethernet@31060000 {
+			phy-mode = "rmii";
+			use-iram;
+		};
+
+		/* Here, choose exactly one from: ohci, usbd */
+		ohci@31020000 {
+			transceiver = <&isp1301>;
+			status = "okay";
+		};
+
+/*
+		usbd@31020000 {
+			transceiver = <&isp1301>;
+			status = "okay";
+		};
+*/
+
+		clcd@31040000 {
+			status = "okay";
+		};
+
+		/* 64MB Flash via SLC NAND controller */
+		slc: flash@20020000 {
+			status = "okay";
+			#address-cells = <1>;
+			#size-cells = <1>;
+
+			mtd0@00000000 {
+				label = "phy3250-boot";
+				reg = <0x00000000 0x00064000>;
+				read-only;
+			};
+
+			mtd1@00064000 {
+				label = "phy3250-uboot";
+				reg = <0x00064000 0x00190000>;
+				read-only;
+			};
+
+			mtd2@001f4000 {
+				label = "phy3250-ubt-prms";
+				reg = <0x001f4000 0x00010000>;
+			};
+
+			mtd3@00204000 {
+				label = "phy3250-kernel";
+				reg = <0x00204000 0x00400000>;
+			};
+
+			mtd4@00604000 {
+				label = "phy3250-rootfs";
+				reg = <0x00604000 0x039fc000>;
+			};
+		};
+
+		apb {
+			i2c1: i2c@400A0000 {
+				clock-frequency = <100000>;
+
+				pcf8563: rtc@51 {
+					compatible = "nxp,pcf8563";
+					reg = <0x51>;
+				};
+
+				uda1380: uda1380@18 {
+					compatible = "nxp,uda1380";
+					reg = <0x18>;
+					power-gpio = <&gpio 0x59 0>;
+					reset-gpio = <&gpio 0x51 0>;
+					dac-clk = "wspll";
+				};
+			};
+
+			i2c2: i2c@400A8000 {
+				clock-frequency = <100000>;
+			};
+
+			i2cusb: i2c@31020300 {
+				clock-frequency = <100000>;
+
+				isp1301: usb-transceiver@2c {
+					compatible = "nxp,isp1301";
+					reg = <0x2c>;
+				};
+			};
+
+			ssp0: ssp@20084000 {
+				eeprom: at25@0 {
+					compatible = "atmel,at25";
+				};
+			};
+		};
+
+		fab {
+			tsc@40048000 {
+				status = "okay";
+			};
+		};
+	};
+
+	leds {
+		compatible = "gpio-leds";
+
+		led0 {
+			gpios = <&gpo_p3 1 1>; /* GPO_P3 1, GPIO 80, active low */
+			linux,default-trigger = "heartbeat";
+			default-state = "off";
+		};
+
+		led1 {
+			gpios = <&gpo_p3 14 1>; /* GPO_P3 14, GPIO 93, active low */
+			linux,default-trigger = "timer";
+			default-state = "off";
+		};
+	};
+};
