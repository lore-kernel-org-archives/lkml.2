Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763008Ab2DMAwM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 20:52:12 -0400
Received: from mail.savoirfairelinux.com ([209.172.62.77]:49383 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754709Ab2DMAwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 20:52:09 -0400
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: x86@kernel.org
Cc: Jerome Oufella <jerome.oufella@savoirfairelinux.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        lm-sensors@lm-sensors.org, Guenter Roeck <guenter.roeck@ericsson.com>,
        Jean Delvare <khali@linux-fr.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Vivien Didelot <vivien.didelot@savoirfairelinux.com>
Subject: [PATCH v6 3/3] gpio: TS-5500 GPIO support
Date: Thu, 12 Apr 2012 20:28:55 -0400
Message-Id: <1334276935-11258-4-git-send-email-vivien.didelot@savoirfairelinux.com>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1334276935-11258-1-git-send-email-vivien.didelot@savoirfairelinux.com>
References: <1334276935-11258-1-git-send-email-vivien.didelot@savoirfairelinux.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jerome Oufella <jerome.oufella@savoirfairelinux.com>

Signed-off-by: Jerome Oufella <jerome.oufella@savoirfairelinux.com>
Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
---
 MAINTAINERS                   |    2 +
 arch/x86/include/asm/ts5500.h |   62 ++++++++
 drivers/gpio/Kconfig          |    7 +
 drivers/gpio/Makefile         |    1 +
 drivers/gpio/gpio-ts5500.c    |  347 +++++++++++++++++++++++++++++++++++++++++
 5 files changed, 419 insertions(+)
 create mode 100644 arch/x86/include/asm/ts5500.h
 create mode 100644 drivers/gpio/gpio-ts5500.c

diff --git a/MAINTAINERS b/MAINTAINERS
index b126129..b7b5d95 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6624,6 +6624,8 @@ TECHNOLOGIC SYSTEMS TS-5500 MACHINE SUPPORT
 M:	Savoir-faire Linux Inc. <kernel@savoirfairelinux.com>
 S:	Maintained
 F:	arch/x86/platform/ts5500/
+F:	arch/x86/include/asm/ts5500.h
+F:	drivers/gpio/gpio-ts5500.c
 
 TEGRA SUPPORT
 M:	Colin Cross <ccross@android.com>
diff --git a/arch/x86/include/asm/ts5500.h b/arch/x86/include/asm/ts5500.h
new file mode 100644
index 0000000..baf136c
--- /dev/null
+++ b/arch/x86/include/asm/ts5500.h
@@ -0,0 +1,62 @@
+/*
+ * Technologic Systems TS-5500 GPIO (DIO) definitions
+ *
+ * Copyright (c) 2010-2012 Savoir-faire Linux Inc.
+ *	Jerome Oufella <jerome.oufella@savoirfairelinux.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _TS5500_H
+#define _TS5500_H
+
+#define TS5500_DIO1_0		0
+#define TS5500_DIO1_1		1
+#define TS5500_DIO1_2		2
+#define TS5500_DIO1_3		3
+#define TS5500_DIO1_4		4
+#define TS5500_DIO1_5		5
+#define TS5500_DIO1_6		6
+#define TS5500_DIO1_7		7
+#define TS5500_DIO1_8		8
+#define TS5500_DIO1_9		9
+#define TS5500_DIO1_10		10
+#define TS5500_DIO1_11		11
+#define TS5500_DIO1_12		12
+#define TS5500_DIO1_13		13
+
+#define TS5500_DIO2_0		14
+#define TS5500_DIO2_1		15
+#define TS5500_DIO2_2		16
+#define TS5500_DIO2_3		17
+#define TS5500_DIO2_4		18
+#define TS5500_DIO2_5		19
+#define TS5500_DIO2_6		20
+#define TS5500_DIO2_7		21
+#define TS5500_DIO2_8		22
+#define TS5500_DIO2_9		23
+#define TS5500_DIO2_10		24
+#define TS5500_DIO2_11		25
+/* #define TS5500_DIO2_12 - Keep commented out as it simply doesn't exist. */
+#define TS5500_DIO2_13		26
+
+#define TS5500_LCD_0		27
+#define TS5500_LCD_1		28
+#define TS5500_LCD_2		29
+#define TS5500_LCD_3		30
+#define TS5500_LCD_4		31
+#define TS5500_LCD_5		32
+#define TS5500_LCD_6		33
+#define TS5500_LCD_7		34
+#define TS5500_LCD_EN		35
+#define TS5500_LCD_RS		36
+#define TS5500_LCD_WR		37
+
+/* Lines that can trigger IRQs */
+#define TS5500_DIO1_13_IRQ	7
+#define TS5500_DIO2_13_IRQ	6
+#define TS5500_LCD_RS_IRQ	1
+
+#endif /* _TS5500_H */
diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index edadbda..a19b0f3 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -319,6 +319,13 @@ config GPIO_TPS65912
 	help
 	  This driver supports TPS65912 gpio chip
 
+config GPIO_TS5500
+	tristate "TS-5500 GPIOs"
+	depends on TS5500
+	help
+	  This driver supports the DIO headers for GPIO usage on the Technologic
+	  Systems TS-5500 platform.
+
 config GPIO_TWL4030
 	tristate "TWL4030, TWL5030, and TPS659x0 GPIOs"
 	depends on TWL4030_CORE
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index 007f54b..30cbd03 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -56,6 +56,7 @@ obj-$(CONFIG_GPIO_TIMBERDALE)	+= gpio-timberdale.o
 obj-$(CONFIG_ARCH_DAVINCI_TNETV107X) += gpio-tnetv107x.o
 obj-$(CONFIG_GPIO_TPS65910)	+= gpio-tps65910.o
 obj-$(CONFIG_GPIO_TPS65912)	+= gpio-tps65912.o
+obj-$(CONFIG_GPIO_TS5500)	+= gpio-ts5500.o
 obj-$(CONFIG_GPIO_TWL4030)	+= gpio-twl4030.o
 obj-$(CONFIG_GPIO_UCB1400)	+= gpio-ucb1400.o
 obj-$(CONFIG_GPIO_VR41XX)	+= gpio-vr41xx.o
diff --git a/drivers/gpio/gpio-ts5500.c b/drivers/gpio/gpio-ts5500.c
new file mode 100644
index 0000000..01f34d8
--- /dev/null
+++ b/drivers/gpio/gpio-ts5500.c
@@ -0,0 +1,347 @@
+/*
+ * GPIO (DIO) driver for Technologic Systems TS-5500
+ *
+ * TS-5500 board has 38 GPIOs referred to as DIOs in the product's literature.
+ *
+ * Copyright (c) 2010-2012 Savoir-faire Linux Inc.
+ *	Jerome Oufella <jerome.oufella@savoirfairelinux.com>
+ *	Vivien Didelot <vivien.didelot@savoirfairelinux.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/gpio.h>
+#include <linux/io.h>
+#include <linux/platform_device.h>
+#include <asm/ts5500.h>
+
+static int dio1_irq = 1;
+module_param(dio1_irq, int, 0644);
+MODULE_PARM_DESC(dio1_irq, "Enable usage of IRQ7 for any DIO1 line"
+		 " (default 1)");
+
+static int dio2_irq;
+module_param(dio2_irq, int, 0644);
+MODULE_PARM_DESC(dio2_irq, "Enable usage of IRQ6 for any DIO2 line"
+		 " (default 0)");
+
+static int lcd_irq;
+module_param(lcd_irq, int, 0644);
+MODULE_PARM_DESC(lcd_irq, "Enable usage of IRQ1 for any LCD line"
+		 " (default 0)");
+
+static int use_lcdio;
+module_param(use_lcdio, int, 0644);
+MODULE_PARM_DESC(use_lcdio, "Enable usage of the LCD header for DIO operation"
+		 " (default 0)");
+
+static DEFINE_SPINLOCK(gpio_lock);
+
+static inline void port_bit_set(u8 addr, int bit)
+{
+	u8 var;
+
+	var = inb(addr);
+	var |= (1 << bit);
+	outb(var, addr);
+}
+
+static inline void port_bit_clear(u8 addr, int bit)
+{
+	u8 var;
+
+	var = inb(addr);
+	var &= ~(1 << bit);
+	outb(var, addr);
+}
+
+/* "DIO" line to IO port mapping table for line's value */
+static const unsigned long line_to_port_map[] = {
+	0x7B, 0x7B, 0x7B, 0x7B, 0x7B, 0x7B, 0x7B, 0x7B,	/* DIO1_[0-7] */
+	0x7C, 0x7C, 0x7C, 0x7C, 0x7C, 0x7C,		/* DIO1_[8-13] */
+	0x7E, 0x7E, 0x7E, 0x7E, 0x7E, 0x7E, 0x7E, 0x7E,	/* DIO2_[0-7] */
+	0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F,		/* DIO2_[8-13] */
+	0x72, 0x72, 0x72, 0x72, 0x72, 0x72, 0x72, 0x72,	/* LCD_[0-7] */
+	0x73, 0x73, 0x73				/* LCD_{EN,RS,WR} */
+};
+
+/* "DIO" line to IO port's bit map for line's value */
+static const int line_to_bit_map[] = {
+	0, 1, 2, 3, 4, 5, 6, 7,	/* DIO1_[0-7] */
+	0, 1, 2, 3, 4, 5,	/* DIO1_[8-13] */
+	0, 1, 2, 3, 4, 5, 6, 7,	/* DIO2_[0-7] */
+	0, 1, 2, 3, 4, 5,	/* DIO2_[8-13] */
+	0, 1, 2, 3, 4, 5, 6, 7,	/* LCD_[0-7] */
+	0, 7, 6			/* LCD_{EN,RS,WR} */
+};
+
+/* "DIO" line's direction control mapping table */
+static const unsigned long line_to_dir_map[] = {
+	0x7A, 0x7A, 0x7A, 0x7A, 0x7A, 0x7A, 0x7A, 0x7A,	/* DIO1_[0-7] */
+	0x7A, 0x7A, 0x7A, 0x7A, 0, 0,			/* DIO1_[8-13] */
+	0x7D, 0x7D, 0x7D, 0x7D, 0x7D, 0x7D, 0x7D, 0x7D,	/* DIO2_[0-7] */
+	0x7D, 0x7D, 0x7D, 0x7D, 0, 0,			/* DIO2_[8-13] */
+	0x7D, 0x7D, 0x7D, 0x7D, 0x7D, 0x7D, 0x7D, 0x7D,	/* LCD_[0-7] */
+	0, 0, 0						/* LCD_{EN,RS,WR} */
+};
+
+/* "DIO" line's direction control bit-mapping table */
+static const int line_to_dir_bit_map[] = {
+	0, 0, 0, 0, 1, 1, 1, 1,	/* DIO1_[0-7] */
+	5, 5, 5, 5, -1, -1,	/* DIO1_[8-13] */
+	0, 0, 0, 0, 1, 1, 1, 1,	/* DIO2_[0-7] */
+	5, 5, 5, 5, -1, -1,	/* DIO2_[8-13] */
+	2, 2, 2, 2, 3, 3, 3, 3,	/* LCD_[0-7] */
+	-1, -1, -1		/* LCD_{EN,RS,WR} */
+};
+
+static int ts5500_gpio_direction_input(struct gpio_chip *chip, unsigned offset)
+{
+	unsigned long dir_reg, flags;
+	int dir_bit;
+
+	/* Some lines cannot be configured as input */
+	if (offset == TS5500_LCD_EN)
+		return -ENXIO;
+
+	dir_reg = line_to_dir_map[offset];
+	dir_bit = line_to_dir_bit_map[offset];
+
+	spin_lock_irqsave(&gpio_lock, flags);
+	port_bit_clear(dir_reg, dir_bit);
+	spin_unlock_irqrestore(&gpio_lock, flags);
+
+	return 0;
+}
+
+static int ts5500_gpio_get(struct gpio_chip *chip, unsigned offset)
+{
+	unsigned long ioaddr;
+	int bitno;
+
+	ioaddr = line_to_port_map[offset];
+	bitno = line_to_bit_map[offset];
+
+	return (inb(ioaddr) >> bitno) & 0x1;
+}
+
+static int ts5500_gpio_direction_output(struct gpio_chip *chip, unsigned offset,
+					int val)
+{
+	unsigned long dir_reg, ioaddr, flags;
+	int dir_bit, bitno;
+
+	/* Some lines cannot be configured as output */
+	switch (offset) {
+	case TS5500_DIO1_12:
+	case TS5500_DIO1_13:
+	case TS5500_DIO2_13:
+	case TS5500_LCD_RS:
+	case TS5500_LCD_WR:
+		return -ENXIO;
+	default:
+		break;
+	}
+
+	dir_reg = line_to_dir_map[offset];
+	dir_bit = line_to_dir_bit_map[offset];
+	ioaddr = line_to_port_map[offset];
+	bitno = line_to_bit_map[offset];
+
+	spin_lock_irqsave(&gpio_lock, flags);
+	port_bit_set(dir_reg, dir_bit);
+	if (val)
+		port_bit_set(ioaddr, bitno);
+	else
+		port_bit_clear(ioaddr, bitno);
+	spin_unlock_irqrestore(&gpio_lock, flags);
+
+	return 0;
+}
+
+static void ts5500_gpio_set(struct gpio_chip *chip, unsigned offset, int val)
+{
+	int bitno;
+	unsigned long ioaddr, flags;
+
+	ioaddr = line_to_port_map[offset];
+	bitno = line_to_bit_map[offset];
+
+	spin_lock_irqsave(&gpio_lock, flags);
+	if (val)
+		port_bit_set(ioaddr, bitno);
+	else
+		port_bit_clear(ioaddr, bitno);
+	spin_unlock_irqrestore(&gpio_lock, flags);
+}
+
+static int ts5500_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
+{
+	/* Only a few lines are IRQ-capable */
+	if (offset == TS5500_DIO1_13)
+		return TS5500_DIO1_13_IRQ;
+	if (offset == TS5500_DIO2_13)
+		return TS5500_DIO2_13_IRQ;
+	if (offset == TS5500_LCD_RS)
+		return TS5500_LCD_RS_IRQ;
+
+	/* IRQ line may be bridged with another DIO line from the same header */
+	if (dio1_irq && offset >= TS5500_DIO1_0 && offset < TS5500_DIO1_13)
+		return TS5500_DIO1_13_IRQ;
+	if (dio2_irq && offset >= TS5500_DIO2_0 && offset < TS5500_DIO2_13)
+		return TS5500_DIO2_13_IRQ;
+	if (lcd_irq && offset >= TS5500_LCD_0 && offset <= TS5500_LCD_WR)
+		return TS5500_LCD_RS_IRQ;
+
+	return -ENXIO;
+}
+
+static struct gpio_chip ts5500_gpio_chip = {
+	.label = "ts5500-gpio",
+	.owner = THIS_MODULE,
+	.direction_input = ts5500_gpio_direction_input,
+	.get = ts5500_gpio_get,
+	.direction_output = ts5500_gpio_direction_output,
+	.set = ts5500_gpio_set,
+	.to_irq = ts5500_gpio_to_irq,
+	.base = TS5500_DIO1_0,
+};
+
+static void ts5500_gpio_release(struct device *dev)
+{
+	/* noop */
+}
+
+static struct platform_device ts5500_gpio_pdev = {
+	.name = "ts5500-gpio",
+	.id = -1,
+	.dev = {
+		.release = ts5500_gpio_release,
+	},
+};
+
+static int __devinit ts5500_gpio_probe(struct platform_device *pdev)
+{
+	int ret;
+	unsigned long flags;
+
+	if (pdev == NULL)
+		return -ENODEV;
+
+	if (!request_region(0x7A, 3, "ts5500-gpio-DIO1")) {
+		dev_err(&pdev->dev, "failed to request I/O port 0x7A-7C\n");
+		return -EBUSY;
+	}
+
+	if (!request_region(0x7D, 3, "ts5500-gpio-DIO2")) {
+		dev_err(&pdev->dev, "failed to request I/O port 0x7D-7F\n");
+		ret = -EBUSY;
+		goto release_dio1;
+	}
+
+	if (use_lcdio && !request_region(0x72, 2, "ts5500-gpio-LCD")) {
+		dev_err(&pdev->dev, "failed to request I/O port 0x72-73\n");
+		ret = -EBUSY;
+		goto release_dio2;
+	}
+
+	if (use_lcdio)
+		ts5500_gpio_chip.ngpio = TS5500_LCD_WR + 1;
+	else
+		ts5500_gpio_chip.ngpio = TS5500_DIO2_13 + 1;
+
+	ret = gpiochip_add(&ts5500_gpio_chip);
+	if (ret) {
+		dev_err(&pdev->dev, "failed to register the gpio chip\n");
+		goto release_lcd;
+	}
+
+	/* Enable IRQ generation */
+	spin_lock_irqsave(&gpio_lock, flags);
+	port_bit_set(0x7A, 7); /* DIO1_13 on IRQ7 */
+	port_bit_set(0x7D, 7); /* DIO2_13 on IRQ6 */
+	if (use_lcdio) {
+		port_bit_clear(0x7D, 4); /* LCD header usage as DIO */
+		port_bit_set(0x7D, 6); /* LCD_RS on IRQ1 */
+	}
+	spin_unlock_irqrestore(&gpio_lock, flags);
+
+	return 0;
+
+release_lcd:
+	if (use_lcdio)
+		release_region(0x72, 2);
+release_dio2:
+	release_region(0x7D, 3);
+release_dio1:
+	release_region(0x7A, 3);
+
+	return ret;
+}
+
+static int __devexit ts5500_gpio_remove(struct platform_device *pdev)
+{
+	int ret;
+	unsigned long flags;
+
+	/* Disable IRQ generation */
+	spin_lock_irqsave(&gpio_lock, flags);
+	port_bit_clear(0x7A, 7);
+	port_bit_clear(0x7D, 7);
+	if (use_lcdio)
+		port_bit_clear(0x7D, 6);
+	spin_unlock_irqrestore(&gpio_lock, flags);
+
+	release_region(0x7A, 3);
+	release_region(0x7D, 3);
+	if (use_lcdio)
+		release_region(0x72, 2);
+
+	ret = gpiochip_remove(&ts5500_gpio_chip);
+	if (ret)
+		dev_err(&pdev->dev, "failed to remove the gpio chip\n");
+
+	return ret;
+}
+
+static struct platform_driver ts5500_gpio_driver = {
+	.driver = {
+		.name = "ts5500-gpio",
+		.owner = THIS_MODULE,
+	},
+	.probe = ts5500_gpio_probe,
+	.remove = __devexit_p(ts5500_gpio_remove),
+};
+
+static int __init ts5500_gpio_init(void)
+{
+	int ret;
+
+	ret = platform_driver_register(&ts5500_gpio_driver);
+	if (ret)
+		return ret;
+
+	ret = platform_device_register(&ts5500_gpio_pdev);
+	if (ret) {
+		platform_driver_unregister(&ts5500_gpio_driver);
+		return ret;
+	}
+
+	return 0;
+}
+module_init(ts5500_gpio_init);
+
+static void __exit ts5500_gpio_exit(void)
+{
+	platform_driver_unregister(&ts5500_gpio_driver);
+	platform_device_unregister(&ts5500_gpio_pdev);
+}
+module_exit(ts5500_gpio_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Savoir-faire Linux Inc. <kernel@savoirfairelinux.com>");
+MODULE_DESCRIPTION("Technologic Systems TS-5500, GPIO/DIO driver");
-- 
1.7.9.2

