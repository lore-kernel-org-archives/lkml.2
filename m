Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383Ab2KKMwD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 07:52:03 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:56079 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288Ab2KKMux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 07:50:53 -0500
From: Jonas Gorski <jonas.gorski@gmail.com>
To: linux-mips@linux-mips.org
Cc: Ralf Baechle <ralf@linux-mips.org>, John Crispin <blogic@openwrt.org>,
        Maxime Bizon <mbizon@freebox.fr>,
        Florian Fainelli <florian@openwrt.org>,
        Kevin Cernekee <cernekee@gmail.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [RFC] MIPS: BCM63XX: register GPIO controller through Device Tree
Date: Sun, 11 Nov 2012 13:50:45 +0100
Message-Id: <1352638249-29298-12-git-send-email-jonas.gorski@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1352638249-29298-1-git-send-email-jonas.gorski@gmail.com>
References: <1352638249-29298-1-git-send-email-jonas.gorski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Register the GPIO controller through Device Tree and add the
appropriate values in the include files.

Since we can't register a platform driver at this early stage move the
direct call to bcm63xx_gpio_init from prom_init to an arch initcall.

Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
---
 .../devicetree/bindings/gpio/bcm63xx-gpio.txt      |   24 +++++++++++++
 arch/mips/bcm63xx/dts/bcm6328.dtsi                 |    8 ++++
 arch/mips/bcm63xx/dts/bcm6338.dtsi                 |    8 ++++
 arch/mips/bcm63xx/dts/bcm6345.dtsi                 |    7 ++++
 arch/mips/bcm63xx/dts/bcm6348.dtsi                 |    8 ++++
 arch/mips/bcm63xx/dts/bcm6358.dtsi                 |    8 ++++
 arch/mips/bcm63xx/dts/bcm6368.dtsi                 |    8 ++++
 arch/mips/bcm63xx/gpio.c                           |   35 +++++++++++++++++--
 arch/mips/bcm63xx/prom.c                           |    3 --
 9 files changed, 102 insertions(+), 7 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/gpio/bcm63xx-gpio.txt

diff --git a/Documentation/devicetree/bindings/gpio/bcm63xx-gpio.txt b/Documentation/devicetree/bindings/gpio/bcm63xx-gpio.txt
new file mode 100644
index 0000000..283765d
--- /dev/null
+++ b/Documentation/devicetree/bindings/gpio/bcm63xx-gpio.txt
@@ -0,0 +1,24 @@
+* Broadcom BCM63XX GPIO controller
+
+Required properties:
+- compatible: "brcm,bcm63xx-gpio"
+  Compatible with all BCM63XX SoCs.
+
+- reg: address and length of the register block.
+
+- gpio-controller: This is a GPIO controller.
+
+- #gpio-cells: Must be <2>. The first cell is the GPIO pin, and
+  the second one the standard linux flags.
+
+- ngpio: number of GPIOs present in this SoC.
+
+Example:
+
+	gpio: gpio@80 {
+		compatible = "brcm,bcm63xx-gpio";
+		reg = <0x80 0x80>;
+		gpio-controller;
+		#gpio-cells = <2>;
+		ngpio = <40>;
+	};
diff --git a/arch/mips/bcm63xx/dts/bcm6328.dtsi b/arch/mips/bcm63xx/dts/bcm6328.dtsi
index 9055187..e2e92c3 100644
--- a/arch/mips/bcm63xx/dts/bcm6328.dtsi
+++ b/arch/mips/bcm63xx/dts/bcm6328.dtsi
@@ -132,5 +132,13 @@
 				};
 			};
 		};
+
+		gpio0: gpio@80 {
+			compatible = "brcm,bcm63xx-gpio";
+			reg = <0x80 0x80>;
+			gpio-controller;
+			#gpio-cells = <2>;
+			ngpio = <32>;
+		};
 	};
 };
diff --git a/arch/mips/bcm63xx/dts/bcm6338.dtsi b/arch/mips/bcm63xx/dts/bcm6338.dtsi
index 6346a7e..28e7cb6 100644
--- a/arch/mips/bcm63xx/dts/bcm6338.dtsi
+++ b/arch/mips/bcm63xx/dts/bcm6338.dtsi
@@ -89,5 +89,13 @@
 				};
 			};
 		};
+
+		gpio0: gpio@400 {
+			compatible = "brcm,bcm63xx-gpio";
+			reg = <0x400 0x80>;
+			gpio-controller;
+			#gpio-cells = <2>;
+			ngpio = <8>;
+		};
 	};
 };
diff --git a/arch/mips/bcm63xx/dts/bcm6345.dtsi b/arch/mips/bcm63xx/dts/bcm6345.dtsi
index 1771775..1ebc024 100644
--- a/arch/mips/bcm63xx/dts/bcm6345.dtsi
+++ b/arch/mips/bcm63xx/dts/bcm6345.dtsi
@@ -75,5 +75,12 @@
 				};
 			};
 		};
+		gpio0: gpio@400 {
+			compatible = "brcm,bcm63xx-gpio";
+			reg = <0x400 0x80>;
+			gpio-controller;
+			#gpio-cells = <2>;
+			ngpio = <16>;
+		};
 	};
 };
diff --git a/arch/mips/bcm63xx/dts/bcm6348.dtsi b/arch/mips/bcm63xx/dts/bcm6348.dtsi
index 14f1996..89acec7 100644
--- a/arch/mips/bcm63xx/dts/bcm6348.dtsi
+++ b/arch/mips/bcm63xx/dts/bcm6348.dtsi
@@ -96,5 +96,13 @@
 				};
 			};
 		};
+
+		gpio0: gpio@400 {
+			compatible = "brcm,bcm63xx-gpio";
+			regs = <0x400 0x80>;
+			gpio-controller;
+			#gpio-cells = <2>;
+			ngpio = <37>;
+		};
 	};
 };
diff --git a/arch/mips/bcm63xx/dts/bcm6358.dtsi b/arch/mips/bcm63xx/dts/bcm6358.dtsi
index 943b480..52170d6 100644
--- a/arch/mips/bcm63xx/dts/bcm6358.dtsi
+++ b/arch/mips/bcm63xx/dts/bcm6358.dtsi
@@ -130,5 +130,13 @@
 				};
 			};
 		};
+
+		gpio0: gpio@80 {
+			compatible = "brcm,bcm63xx-gpio";
+			reg = <0x80 0x80>;
+			gpio-controller;
+			#gpio-cells = <2>;
+			ngpio = <40>;
+		};
 	};
 };
diff --git a/arch/mips/bcm63xx/dts/bcm6368.dtsi b/arch/mips/bcm63xx/dts/bcm6368.dtsi
index 2156be0..068231b 100644
--- a/arch/mips/bcm63xx/dts/bcm6368.dtsi
+++ b/arch/mips/bcm63xx/dts/bcm6368.dtsi
@@ -170,5 +170,13 @@
 				};
 			};
 		};
+
+		gpio0: gpio@80 {
+			compatible = "brcm,bcm63xx-gpio";
+			regs = <0x80 0x80>;
+			gpio-controller;
+			#gpio-cells = <2>;
+			ngpio = <38>;
+		};
 	};
 };
diff --git a/arch/mips/bcm63xx/gpio.c b/arch/mips/bcm63xx/gpio.c
index a6c2135..774fd08 100644
--- a/arch/mips/bcm63xx/gpio.c
+++ b/arch/mips/bcm63xx/gpio.c
@@ -141,7 +141,6 @@ static int bcm63xx_gpio_direction_output(struct gpio_chip *chip,
 	return bcm63xx_gpio_set_direction(chip, gpio, BCM63XX_GPIO_DIR_OUT);
 }
 
-
 static struct gpio_chip bcm63xx_gpio_chip = {
 	.label			= "bcm63xx-gpio",
 	.direction_input	= bcm63xx_gpio_direction_input,
@@ -151,6 +150,34 @@ static struct gpio_chip bcm63xx_gpio_chip = {
 	.base			= 0,
 };
 
+int __init bcm63xx_gpio_probe(struct platform_device *pdev)
+{
+	u32 val;
+
+	if (of_property_read_u32(pdev->dev.of_node, "ngpio", &val))
+		return -EINVAL;
+
+	bcm63xx_gpio_chip.ngpio = val;
+	bcm63xx_gpio_chip.dev = &pdev->dev;
+	pr_info("registering %d GPIOs\n", bcm63xx_gpio_chip.ngpio);
+
+	return gpiochip_add(&bcm63xx_gpio_chip);
+}
+
+static struct of_device_id of_bcm63xx_gpio_match[] = {
+	{ .compatible = "brcm,bcm63xx-gpio" },
+	{ },
+};
+
+static struct platform_driver bcm63xx_gpio_driver = {
+	.driver = {
+		.name = "bcm63xx-gpio",
+		.owner = THIS_MODULE,
+		.of_match_table = of_bcm63xx_gpio_match,
+	},
+	.probe = bcm63xx_gpio_probe,
+};
+
 int __init bcm63xx_gpio_init(void)
 {
 	bcm63xx_gpio_out_low_reg_init();
@@ -158,8 +185,8 @@ int __init bcm63xx_gpio_init(void)
 	gpio_out_low = bcm_gpio_readl(gpio_out_low_reg);
 	if (!BCMCPU_IS_6345())
 		gpio_out_high = bcm_gpio_readl(GPIO_DATA_HI_REG);
-	bcm63xx_gpio_chip.ngpio = bcm63xx_gpio_count();
-	pr_info("registering %d GPIOs\n", bcm63xx_gpio_chip.ngpio);
 
-	return gpiochip_add(&bcm63xx_gpio_chip);
+	return platform_driver_register(&bcm63xx_gpio_driver);
 }
+
+arch_initcall(bcm63xx_gpio_init);
diff --git a/arch/mips/bcm63xx/prom.c b/arch/mips/bcm63xx/prom.c
index 10eaff4..0b636d6 100644
--- a/arch/mips/bcm63xx/prom.c
+++ b/arch/mips/bcm63xx/prom.c
@@ -45,9 +45,6 @@ void __init prom_init(void)
 	reg &= ~mask;
 	bcm_perf_writel(reg, PERF_CKCTL_REG);
 
-	/* register gpiochip */
-	bcm63xx_gpio_init();
-
 	/* do low level board init */
 	board_prom_init();
 }
-- 
1.7.2.5

