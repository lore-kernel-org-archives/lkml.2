Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317Ab3ADVSl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 16:18:41 -0500
Received: from mail.savoirfairelinux.com ([209.172.62.77]:48266 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755023Ab3ADVSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 16:18:37 -0500
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Vivien Didelot <vivien.didelot@savoirfairelinux.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        "Savoir-faire Linux Inc." <kernel@savoirfairelinux.com>
Subject: [PATCH] x86: add TS-5500 platform support
Date: Fri,  4 Jan 2013 16:18:14 -0500
Message-Id: <1357334294-12760-1-git-send-email-vivien.didelot@savoirfairelinux.com>
X-Mailer: git-send-email 1.8.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Technologic Systems TS-5500 is an x86-based (AMD Elan SC520) single
board computer. This driver registers most of its devices and exposes
sysfs attributes for information such as jumpers' state or presence of
some of its options.

This driver currently registers the TS-5500 platform, its on-board LED,
2 pin blocks (GPIO) and its analog/digital converter. It can be extended
to support other Technologic Systems products, such as the TS-5600.

Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
---
 Documentation/ABI/testing/sysfs-platform-ts5500 |  47 ++++
 MAINTAINERS                                     |   5 +
 arch/x86/Kconfig                                |   7 +
 arch/x86/platform/Makefile                      |   1 +
 arch/x86/platform/ts5500/Makefile               |   1 +
 arch/x86/platform/ts5500/ts5500.c               | 339 ++++++++++++++++++++++++
 6 files changed, 400 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-platform-ts5500
 create mode 100644 arch/x86/platform/ts5500/Makefile
 create mode 100644 arch/x86/platform/ts5500/ts5500.c

diff --git a/Documentation/ABI/testing/sysfs-platform-ts5500 b/Documentation/ABI/testing/sysfs-platform-ts5500
new file mode 100644
index 0000000..c88375a
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-platform-ts5500
@@ -0,0 +1,47 @@
+What:		/sys/devices/platform/ts5500/adc
+Date:		January 2013
+KernelVersion:	3.7
+Contact:	"Savoir-faire Linux Inc." <kernel@savoirfairelinux.com>
+Description:
+		Indicates the presence of an A/D Converter. If it is present,
+		it will display "1", otherwise "0".
+
+What:		/sys/devices/platform/ts5500/ereset
+Date:		January 2013
+KernelVersion:	3.7
+Contact:	"Savoir-faire Linux Inc." <kernel@savoirfairelinux.com>
+Description:
+		Indicates the presence of an external reset. If it is present,
+		it will display "1", otherwise "0".
+
+What:		/sys/devices/platform/ts5500/id
+Date:		January 2013
+KernelVersion:	3.7
+Contact:	"Savoir-faire Linux Inc." <kernel@savoirfairelinux.com>
+Description:
+		Product ID of the TS board. TS-5500 ID is 0x60.
+
+What:		/sys/devices/platform/ts5500/jumpers
+Date:		January 2013
+KernelVersion:	3.7
+Contact:	"Savoir-faire Linux Inc." <kernel@savoirfairelinux.com>
+Description:
+		Bitfield showing the jumpers' state. If a jumper is present,
+		the corresponding bit is set. For instance, 0x0e means jumpers
+		2, 3 and 4 are set.
+
+What:		/sys/devices/platform/ts5500/rs485
+Date:		January 2013
+KernelVersion:	3.7
+Contact:	"Savoir-faire Linux Inc." <kernel@savoirfairelinux.com>
+Description:
+		Indicates the presence of the RS485 option. If it is present,
+		it will display "1", otherwise "0".
+
+What:		/sys/devices/platform/ts5500/sram
+Date:		January 2013
+KernelVersion:	3.7
+Contact:	"Savoir-faire Linux Inc." <kernel@savoirfairelinux.com>
+Description:
+		Indicates the presence of the SRAM option. If it is present,
+		it will display "1", otherwise "0".
diff --git a/MAINTAINERS b/MAINTAINERS
index fa309ab..e453939 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7487,6 +7487,11 @@ S:	Supported
 F:	drivers/net/team/
 F:	include/linux/if_team.h
 
+TECHNOLOGIC SYSTEMS TS-5500 PLATFORM SUPPORT
+M:	Savoir-faire Linux Inc. <kernel@savoirfairelinux.com>
+S:	Maintained
+F:	arch/x86/platform/ts5500/
+
 TECHNOTREND USB IR RECEIVER
 M:	Sean Young <sean@mess.org>
 L:	linux-media@vger.kernel.org
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 79795af..df5815e 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2187,6 +2187,13 @@ config GEOS
 	---help---
 	  This option enables system support for the Traverse Technologies GEOS.
 
+config TS5500
+	bool "Technologic Systems TS-5500 platform support"
+	depends on MELAN
+	select CHECK_SIGNATURE
+	---help---
+	  This option enables system support for the Technologic Systems TS-5500.
+
 endif # X86_32
 
 config AMD_NB
diff --git a/arch/x86/platform/Makefile b/arch/x86/platform/Makefile
index 8d87439..f50911b 100644
--- a/arch/x86/platform/Makefile
+++ b/arch/x86/platform/Makefile
@@ -7,5 +7,6 @@ obj-y	+= mrst/
 obj-y	+= olpc/
 obj-y	+= scx200/
 obj-y	+= sfi/
+obj-y	+= ts5500/
 obj-y	+= visws/
 obj-y	+= uv/
diff --git a/arch/x86/platform/ts5500/Makefile b/arch/x86/platform/ts5500/Makefile
new file mode 100644
index 0000000..c54e348
--- /dev/null
+++ b/arch/x86/platform/ts5500/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_TS5500)	+= ts5500.o
diff --git a/arch/x86/platform/ts5500/ts5500.c b/arch/x86/platform/ts5500/ts5500.c
new file mode 100644
index 0000000..39febb2
--- /dev/null
+++ b/arch/x86/platform/ts5500/ts5500.c
@@ -0,0 +1,339 @@
+/*
+ * Technologic Systems TS-5500 Single Board Computer support
+ *
+ * Copyright (C) 2013 Savoir-faire Linux Inc.
+ *	Vivien Didelot <vivien.didelot@savoirfairelinux.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it under
+ * the terms of the GNU General Public License as published by the Free Software
+ * Foundation; either version 2 of the License, or (at your option) any later
+ * version.
+ *
+ *
+ * This driver registers the Technologic Systems TS-5500 Single Board Computer
+ * (SBC) and its devices, and exposes information to userspace such as jumpers'
+ * state or available options. For further information about sysfs entries, see
+ * Documentation/ABI/testing/sysfs-platform-ts5500.
+ *
+ * This code actually supports the TS-5500 platform, but it may be extended to
+ * support similar Technologic Systems x86-based platforms, such as the TS-5600.
+ */
+
+#include <linux/delay.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/leds.h>
+#include <linux/module.h>
+#include <linux/platform_data/gpio-ts5500.h>
+#include <linux/platform_data/max197.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+
+/* Product code register */
+#define TS5500_PRODUCT_CODE_ADDR	0x74
+#define TS5500_PRODUCT_CODE		0x60	/* TS-5500 product code */
+
+/* SRAM/RS-485/ADC options, and RS-485 RTS/Automatic RS-485 flags register */
+#define TS5500_SRAM_RS485_ADC_ADDR	0x75
+#define TS5500_SRAM			BIT(0)	/* SRAM option */
+#define TS5500_RS485			BIT(1)	/* RS-485 option */
+#define TS5500_ADC			BIT(2)	/* A/D converter option */
+#define TS5500_RS485_RTS		BIT(6)	/* RTS for RS-485 */
+#define TS5500_RS485_AUTO		BIT(7)	/* Automatic RS-485 */
+
+/* External Reset/Industrial Temperature Range options register */
+#define TS5500_ERESET_ITR_ADDR		0x76
+#define TS5500_ERESET			BIT(0)	/* External Reset option */
+#define TS5500_ITR			BIT(1)	/* Indust. Temp. Range option */
+
+/* LED/Jumpers register */
+#define TS5500_LED_JP_ADDR		0x77
+#define TS5500_LED			BIT(0)	/* LED flag */
+#define TS5500_JP1			BIT(1)	/* Automatic CMOS */
+#define TS5500_JP2			BIT(2)	/* Enable Serial Console */
+#define TS5500_JP3			BIT(3)	/* Write Enable Drive A */
+#define TS5500_JP4			BIT(4)	/* Fast Console (115K baud) */
+#define TS5500_JP5			BIT(5)	/* User Jumper */
+#define TS5500_JP6			BIT(6)	/* Console on COM1 (req. JP2) */
+#define TS5500_JP7			BIT(7)	/* Undocumented (Unused) */
+
+/* A/D Converter registers */
+#define TS5500_ADC_CONV_BUSY_ADDR	0x195	/* Conversion state register */
+#define TS5500_ADC_CONV_BUSY		BIT(0)
+#define TS5500_ADC_CONV_INIT_LSB_ADDR	0x196	/* Start conv. / LSB register */
+#define TS5500_ADC_CONV_MSB_ADDR	0x197	/* MSB register */
+#define TS5500_ADC_CONV_DELAY		12	/* usec */
+
+/**
+ * struct ts5500_sbc - TS-5500 board description
+ * @id:		Board product ID.
+ * @sram:	Flag for SRAM option.
+ * @rs485:	Flag for RS-485 option.
+ * @adc:	Flag for Analog/Digital converter option.
+ * @ereset:	Flag for External Reset option.
+ * @itr:	Flag for Industrial Temperature Range option.
+ * @jumpers:	Bitfield for jumpers' state.
+ */
+struct ts5500_sbc {
+	int	id;
+	bool	sram;
+	bool	rs485;
+	bool	adc;
+	bool	ereset;
+	bool	itr;
+	u8	jumpers;
+};
+
+/* Board signatures in BIOS shadow RAM */
+static const struct {
+	const char * const string;
+	const ssize_t offset;
+} ts5500_signatures[] __initdata = {
+	{ "TS-5x00 AMD Elan", 0xb14 },
+};
+
+static int __init ts5500_check_signature(void)
+{
+	void __iomem *bios;
+	int i, ret = -ENODEV;
+
+	bios = ioremap(0xf0000, 0x10000);
+	if (!bios)
+		return -ENOMEM;
+
+	for (i = 0; i < ARRAY_SIZE(ts5500_signatures); i++) {
+		if (check_signature(bios + ts5500_signatures[i].offset,
+				    ts5500_signatures[i].string,
+				    strlen(ts5500_signatures[i].string))) {
+			ret = 0;
+			break;
+		}
+	}
+
+	iounmap(bios);
+	return ret;
+}
+
+static int __init ts5500_detect_config(struct ts5500_sbc *sbc)
+{
+	u8 tmp;
+	int ret = 0;
+
+	if (!request_region(TS5500_PRODUCT_CODE_ADDR, 4, "ts5500"))
+		return -EBUSY;
+
+	tmp = inb(TS5500_PRODUCT_CODE_ADDR);
+	if (tmp != TS5500_PRODUCT_CODE) {
+		pr_err("This platform is not a TS-5500 (found ID 0x%x)\n", tmp);
+		ret = -ENODEV;
+		goto cleanup;
+	}
+	sbc->id = tmp;
+
+	tmp = inb(TS5500_SRAM_RS485_ADC_ADDR);
+	sbc->sram = tmp & TS5500_SRAM;
+	sbc->rs485 = tmp & TS5500_RS485;
+	sbc->adc = tmp & TS5500_ADC;
+
+	tmp = inb(TS5500_ERESET_ITR_ADDR);
+	sbc->ereset = tmp & TS5500_ERESET;
+	sbc->itr = tmp & TS5500_ITR;
+
+	tmp = inb(TS5500_LED_JP_ADDR);
+	sbc->jumpers = tmp & ~TS5500_LED;
+
+cleanup:
+	release_region(TS5500_PRODUCT_CODE_ADDR, 4);
+	return ret;
+}
+
+static ssize_t ts5500_show_id(struct device *dev,
+			      struct device_attribute *attr, char *buf)
+{
+	struct ts5500_sbc *sbc = dev_get_drvdata(dev);
+
+	return sprintf(buf, "0x%.2x\n", sbc->id);
+}
+
+static ssize_t ts5500_show_jumpers(struct device *dev,
+				   struct device_attribute *attr,
+				   char *buf)
+{
+	struct ts5500_sbc *sbc = dev_get_drvdata(dev);
+
+	return sprintf(buf, "0x%.2x\n", sbc->jumpers >> 1);
+}
+
+#define TS5500_SHOW(field)					\
+	static ssize_t ts5500_show_##field(struct device *dev,	\
+			struct device_attribute *attr,		\
+			char *buf)				\
+	{							\
+		struct ts5500_sbc *sbc = dev_get_drvdata(dev);	\
+		return sprintf(buf, "%d\n", sbc->field);	\
+	}
+
+TS5500_SHOW(sram)
+TS5500_SHOW(rs485)
+TS5500_SHOW(adc)
+TS5500_SHOW(ereset)
+TS5500_SHOW(itr)
+
+static DEVICE_ATTR(id, S_IRUGO, ts5500_show_id, NULL);
+static DEVICE_ATTR(jumpers, S_IRUGO, ts5500_show_jumpers, NULL);
+static DEVICE_ATTR(sram, S_IRUGO, ts5500_show_sram, NULL);
+static DEVICE_ATTR(rs485, S_IRUGO, ts5500_show_rs485, NULL);
+static DEVICE_ATTR(adc, S_IRUGO, ts5500_show_adc, NULL);
+static DEVICE_ATTR(ereset, S_IRUGO, ts5500_show_ereset, NULL);
+static DEVICE_ATTR(itr, S_IRUGO, ts5500_show_itr, NULL);
+
+static struct attribute *ts5500_attributes[] = {
+	&dev_attr_id.attr,
+	&dev_attr_jumpers.attr,
+	&dev_attr_sram.attr,
+	&dev_attr_rs485.attr,
+	&dev_attr_adc.attr,
+	&dev_attr_ereset.attr,
+	&dev_attr_itr.attr,
+	NULL
+};
+
+static const struct attribute_group ts5500_attr_group = {
+	.attrs = ts5500_attributes,
+};
+
+static struct resource ts5500_dio1_resource[] = {
+	DEFINE_RES_IRQ_NAMED(7, "DIO1 interrupt"),
+};
+
+static struct platform_device ts5500_dio1_pdev = {
+	.name = "ts5500-dio1",
+	.id = -1,
+	.resource = ts5500_dio1_resource,
+	.num_resources = 1,
+};
+
+static struct resource ts5500_dio2_resource[] = {
+	DEFINE_RES_IRQ_NAMED(6, "DIO2 interrupt"),
+};
+
+static struct platform_device ts5500_dio2_pdev = {
+	.name = "ts5500-dio2",
+	.id = -1,
+	.resource = ts5500_dio2_resource,
+	.num_resources = 1,
+};
+
+static void ts5500_led_set(struct led_classdev *led_cdev,
+			   enum led_brightness brightness)
+{
+	outb(!!brightness, TS5500_LED_JP_ADDR);
+}
+
+static enum led_brightness ts5500_led_get(struct led_classdev *led_cdev)
+{
+	return (inb(TS5500_LED_JP_ADDR) & TS5500_LED) ? LED_FULL : LED_OFF;
+}
+
+static struct led_classdev ts5500_led_cdev = {
+	.name = "ts5500:green:",
+	.brightness_set = ts5500_led_set,
+	.brightness_get = ts5500_led_get,
+};
+
+static int ts5500_adc_convert(u8 ctrl)
+{
+	u8 lsb, msb;
+
+	/* Start conversion (ensure the 3 MSB are set to 0) */
+	outb(ctrl & 0x1f, TS5500_ADC_CONV_INIT_LSB_ADDR);
+
+	/*
+	 * The platform has CPLD logic driving the A/D converter.
+	 * The conversion must complete within 11 microseconds,
+	 * otherwise we have to re-initiate a conversion.
+	 */
+	udelay(TS5500_ADC_CONV_DELAY);
+	if (inb(TS5500_ADC_CONV_BUSY_ADDR) & TS5500_ADC_CONV_BUSY)
+		return -EBUSY;
+
+	/* Read the raw data */
+	lsb = inb(TS5500_ADC_CONV_INIT_LSB_ADDR);
+	msb = inb(TS5500_ADC_CONV_MSB_ADDR);
+
+	return (msb << 8) | lsb;
+}
+
+static struct max197_platform_data ts5500_adc_pdata = {
+	.convert = ts5500_adc_convert,
+};
+
+static struct platform_device ts5500_adc_pdev = {
+	.name = "max197",
+	.id = -1,
+	.dev = {
+		.platform_data = &ts5500_adc_pdata,
+	},
+};
+
+static int __init ts5500_init(void)
+{
+	struct platform_device *pdev;
+	struct ts5500_sbc *sbc;
+	int err;
+
+	/*
+	 * There is no DMI available or PCI bridge subvendor info,
+	 * only the BIOS provides a 16-bit identification call.
+	 * It is safer to find a signature in the BIOS shadow RAM.
+	 */
+	err = ts5500_check_signature();
+	if (err)
+		return err;
+
+	pdev = platform_device_register_simple("ts5500", -1, NULL, 0);
+	if (IS_ERR(pdev))
+		return PTR_ERR(pdev);
+
+	sbc = devm_kzalloc(&pdev->dev, sizeof(struct ts5500_sbc), GFP_KERNEL);
+	if (!sbc) {
+		err = -ENOMEM;
+		goto error;
+	}
+
+	err = ts5500_detect_config(sbc);
+	if (err)
+		goto error;
+
+	platform_set_drvdata(pdev, sbc);
+
+	err = sysfs_create_group(&pdev->dev.kobj, &ts5500_attr_group);
+	if (err)
+		goto error;
+
+	ts5500_dio1_pdev.dev.parent = &pdev->dev;
+	if (platform_device_register(&ts5500_dio1_pdev))
+		dev_warn(&pdev->dev, "DIO1 block registration failed\n");
+	ts5500_dio2_pdev.dev.parent = &pdev->dev;
+	if (platform_device_register(&ts5500_dio2_pdev))
+		dev_warn(&pdev->dev, "DIO2 block registration failed\n");
+
+	if (led_classdev_register(&pdev->dev, &ts5500_led_cdev))
+		dev_warn(&pdev->dev, "LED registration failed\n");
+
+	if (sbc->adc) {
+		ts5500_adc_pdev.dev.parent = &pdev->dev;
+		if (platform_device_register(&ts5500_adc_pdev))
+			dev_warn(&pdev->dev, "ADC registration failed\n");
+	}
+
+	return 0;
+error:
+	platform_device_unregister(pdev);
+	return err;
+}
+device_initcall(ts5500_init);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Savoir-faire Linux Inc. <kernel@savoirfairelinux.com>");
+MODULE_DESCRIPTION("Technologic Systems TS-5500 platform driver");
-- 
1.8.1

