Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753764Ab2LMKQi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 05:16:38 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:21898 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235Ab2LMKQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 05:16:35 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-13-50c9aafb6b9b
From: Joonyoung Shim <jy0922.shim@samsung.com>
To: thierry.reding@avionic-design.de
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        kgene.kim@samsung.com, kyungmin.park@samsung.com
Subject: [PATCH] pwm: add Exynos PWM driver
Date: Thu, 13 Dec 2012 19:16:36 +0900
Message-id: <1355393796-15436-1-git-send-email-jy0922.shim@samsung.com>
X-Mailer: git-send-email 1.7.9.5
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBLMWRmVeSWpSXmKPExsVy+t8zTd3fq04GGDR91rG4vGsOm8WM8/uY
	HJg8Pm+SC2CM4rJJSc3JLEst0rdL4MpY9XonW8Ek54q1XW3sDYzbzbsYOTkkBEwk5i17wARh
	i0lcuLeerYuRi0NIYBmjxKKtj1lhipb//88MkVjEKDG9/SMjhNPCJDH70F0WkCo2AT2JO9uO
	g40SEVCRmLYGYiyzQLlE++/dzCC2sIC2RP+vbkYQm0VAVaL50kl2EJtXwF3i6M4+oHoOoG0K
	EnMm2UCUCEh8m3yIBSIsK7HpANgNEgIH2CRen/vNBnGcpMTBFTdYJjAKLmBkWMUomlqQXFCc
	lJ5rqFecmFtcmpeul5yfu4kRElxSOxhXNlgcYhTgYFTi4S0IPxkgxJpYVlyZe4hRgoNZSYTX
	fzlQiDclsbIqtSg/vqg0J7X4EKMP0CUTmaVEk/OBgZ9XEm9obGBsaGhpaGZqaWqAQ1hJnLfZ
	IyVASCA9sSQ1OzW1ILUIZhwTB6dUA6Pvwjs+XiUpFaIvzriFdt8442PTND/cfvuvx9Muqv5Z
	qPT94ayDn9331Kur+D1ZH6KaUpoSot9m5eR6UYd1daPdlQ8tK1P2z5iiHDvt2bQjz+2Vfeff
	r9F/ki29+p7KivcpJ6Zz+Dss09UtburJSXGXXLQytF5+vYlzx4bg4IAnRvOOrrl6Z6sSS3FG
	oqEWc1FxIgBGAD4kWwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOLMWRmVeSWpSXmKPExsVy+t9jAd3fq04GGOyYq2JxedccNosZ5/cx
	OTB5fN4kF8AY1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIT
	oOuWmQM0WkmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeYser1TraCSc4V
	a7va2BsYt5t3MXJySAiYSCz//58ZwhaTuHBvPVsXIxeHkMAiRonp7R8ZIZwWJonZh+6ygFSx
	CehJ3Nl2nAnEFhFQkZi25gGYzSxQLtH+ezfYJGEBbYn+X92MIDaLgKpE86WT7CA2r4C7xNGd
	fUD1HEDbFCTmTLKZwMi9gJFhFaNoakFyQXFSeq6hXnFibnFpXrpecn7uJkZw6D6T2sG4ssHi
	EKMAB6MSD29B+MkAIdbEsuLK3EOMEhzMSiK8/suBQrwpiZVVqUX58UWlOanFhxh9gJZPZJYS
	Tc4HxlVeSbyhsYmZkaWRmbGJubExDmElcd5mj5QAIYH0xJLU7NTUgtQimHFMHJxSDYyMHO76
	eXUPZsyd0/FwEVfME9/lC8/vP8jJOUfkuojmDNX+z3d/60XPPTR3ujnDIfv/E138Kz6/mXTZ
	tPC43OnoBWVOdWs6L8j6TQ12Ujn2gUMp/0xfn9cpO7d/H1WdeMQTgvi3tc4zCDM+XFG+SC4r
	ap9QL/fyW533nk+8MP+Zr89thl8hwg+VWIozEg21mIuKEwGXbV5nigIAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is PWM driver to support 4 pwm for Exynos SoCs. Also this supports
device tree node.

The existing s3c24xx-pwm driver has many dependence with arch specific
codes and it is difficult to support device tree by static mapping of
PMW memory area. Also it can't support multi pwm to one device and can't
make to module.

Signed-off-by: Joonyoung Shim <jy0922.shim@samsung.com>
---
This is based on for-next branch of git://gitorious.org/linux-pwm/linux-pwm.git

 drivers/pwm/Kconfig      |    9 ++
 drivers/pwm/Makefile     |    1 +
 drivers/pwm/pwm-exynos.c |  234 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 244 insertions(+)
 create mode 100644 drivers/pwm/pwm-exynos.c

diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
index ed81720..1632ace 100644
--- a/drivers/pwm/Kconfig
+++ b/drivers/pwm/Kconfig
@@ -46,6 +46,15 @@ config PWM_BFIN
 	  To compile this driver as a module, choose M here: the module
 	  will be called pwm-bfin.
 
+config PWM_EXYNOS
+	tristate "Exynos pwm support"
+	depends on ARCH_EXYNOS
+	help
+	  Generic PWM framework driver for Exynos.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called pwm-exynos.
+
 config PWM_IMX
 	tristate "i.MX pwm support"
 	depends on ARCH_MXC
diff --git a/drivers/pwm/Makefile b/drivers/pwm/Makefile
index acfe482..423a251 100644
--- a/drivers/pwm/Makefile
+++ b/drivers/pwm/Makefile
@@ -1,6 +1,7 @@
 obj-$(CONFIG_PWM)		+= core.o
 obj-$(CONFIG_PWM_AB8500)	+= pwm-ab8500.o
 obj-$(CONFIG_PWM_BFIN)		+= pwm-bfin.o
+obj-$(CONFIG_PWM_EXYNOS)	+= pwm-exynos.o
 obj-$(CONFIG_PWM_IMX)		+= pwm-imx.o
 obj-$(CONFIG_PWM_JZ4740)	+= pwm-jz4740.o
 obj-$(CONFIG_PWM_LPC32XX)	+= pwm-lpc32xx.o
diff --git a/drivers/pwm/pwm-exynos.c b/drivers/pwm/pwm-exynos.c
new file mode 100644
index 0000000..5a411b6
--- /dev/null
+++ b/drivers/pwm/pwm-exynos.c
@@ -0,0 +1,234 @@
+/*
+ * Copyright (C) 2012 Samsung Electronics Co.Ltd
+ * Author: Joonyoung Shim <jy0922.shim@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/clk.h>
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <linux/pwm.h>
+
+#define PWM_NUM			4
+
+#define PWM_TCFG0		0x00
+#define PWM_TCFG1		0x04
+#define PWM_TCON		0x08
+#define PWM_TCNTB(hw)		(0x0c + (hw) * 0x0c)
+#define PWM_TCMPB(hw)		(0x10 + (hw) * 0x0c)
+#define PWM_TCNTO(hw)		(0x14 + (hw) * 0x0c)
+
+#define PWM_TCFG0_RST_VAL	0x101
+#define PWM_TCFG1_RST_VAL	0x0
+#define PWM_TCON_RST_VAL	0x44404		/* inverter on */
+
+#define PWM_TCFG0_PRESCALER0_MASK	0xff
+#define PWM_TCFG0_PRESCALER1_MASK	0xff00
+#define PWM_TCFG0_PRESCALER1_SHIFT	8
+
+#define PWM_TCFG1_MUX_MASK		0xf
+#define PWM_TCFG1_MUX_SHIFT		4
+
+#define PWM_TCON_BASE(hw)		((hw) ? ((hw) + 1) * 4 : 0)
+#define PWM_TCON_START(hw)		(1 << (PWM_TCON_BASE(hw) + 0))
+#define PWM_TCON_MANUALUPDATE(hw)	(1 << (PWM_TCON_BASE(hw) + 1))
+#define PWM_TCON_INVERTER(hw)		(1 << (PWM_TCON_BASE(hw) + 2))
+#define PWM_TCON_AUTORELOAD(hw)		(1 << (PWM_TCON_BASE(hw) + 3))
+
+struct exynos_pwm {
+	struct pwm_chip		chip;
+	struct device		*dev;
+	struct clk		*clk;
+	struct mutex		mutex;
+	void __iomem		*base;
+};
+
+static int exynos_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
+			     int duty_ns, int period_ns)
+{
+	struct exynos_pwm *exynos = container_of(chip, struct exynos_pwm, chip);
+	unsigned long long c;
+	unsigned long period_cycles, duty_cycles;
+	unsigned long clk_rate;
+	unsigned int prescaler;
+	unsigned int divider;
+	unsigned int hw = pwm->hwpwm;
+	u32 val;
+
+	if (period_ns > NSEC_PER_SEC)
+		return -ERANGE;
+
+	val = readl(exynos->base + PWM_TCFG0);
+	if (hw == 0 || hw == 1)
+		prescaler = val & PWM_TCFG0_PRESCALER0_MASK;
+	else
+		prescaler = (val & PWM_TCFG0_PRESCALER1_MASK) >>
+						PWM_TCFG0_PRESCALER1_SHIFT;
+
+	val = readl(exynos->base + PWM_TCFG1);
+	divider = val & (PWM_TCFG1_MUX_MASK << (hw * PWM_TCFG1_MUX_SHIFT));
+	divider = 1 << divider;
+
+	/* Clock Frequency = PCLK / (prescaler + 1) / divider */
+	clk_rate = clk_get_rate(exynos->clk);
+	clk_rate = clk_rate / (prescaler + 1) / divider;
+
+	c = (unsigned long long)clk_rate * period_ns;
+	do_div(c, NSEC_PER_SEC);
+	period_cycles = (unsigned long)c;
+
+	c = (unsigned long long)period_cycles * duty_ns;
+	do_div(c, period_ns);
+	duty_cycles = (unsigned long)c;
+
+	/* because inverter is on and count down */
+	duty_cycles = period_cycles - duty_cycles;
+
+	writel(period_cycles, exynos->base + PWM_TCNTB(hw));
+	writel(duty_cycles, exynos->base + PWM_TCMPB(hw));
+
+	mutex_lock(&exynos->mutex);
+	val = readl(exynos->base + PWM_TCON);
+	val |= PWM_TCON_MANUALUPDATE(hw);
+	val |= PWM_TCON_AUTORELOAD(hw);
+	writel(val, exynos->base + PWM_TCON);
+
+	val &= ~PWM_TCON_MANUALUPDATE(hw);
+	writel(val, exynos->base + PWM_TCON);
+	mutex_unlock(&exynos->mutex);
+
+	return 0;
+}
+
+static int exynos_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
+{
+	struct exynos_pwm *exynos = container_of(chip, struct exynos_pwm, chip);
+	unsigned int hw = pwm->hwpwm;
+	u32 val;
+
+	mutex_lock(&exynos->mutex);
+	val = readl(exynos->base + PWM_TCON);
+	val |= PWM_TCON_START(hw);
+	writel(val, exynos->base + PWM_TCON);
+	mutex_unlock(&exynos->mutex);
+
+	return 0;
+}
+
+static void exynos_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
+{
+	struct exynos_pwm *exynos = container_of(chip, struct exynos_pwm, chip);
+	unsigned int hw = pwm->hwpwm;
+	u32 val;
+
+	mutex_lock(&exynos->mutex);
+	val = readl(exynos->base + PWM_TCON);
+	val |= PWM_TCON_START(hw);
+	writel(val, exynos->base + PWM_TCON);
+	mutex_unlock(&exynos->mutex);
+}
+
+static const struct pwm_ops exynos_pwm_ops = {
+	.config = exynos_pwm_config,
+	.enable = exynos_pwm_enable,
+	.disable = exynos_pwm_disable,
+	.owner = THIS_MODULE,
+};
+
+static int exynos_pwm_probe(struct platform_device *pdev)
+{
+	struct exynos_pwm *exynos;
+	struct resource *res;
+	int ret;
+
+	exynos = devm_kzalloc(&pdev->dev, sizeof(*exynos), GFP_KERNEL);
+	if (!exynos) {
+		dev_err(&pdev->dev, "failed to allocate memory\n");
+		return -ENOMEM;
+	}
+
+	exynos->dev = &pdev->dev;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		dev_err(&pdev->dev, "no memory resources defined\n");
+		return -ENODEV;
+	}
+
+	exynos->base = devm_request_and_ioremap(&pdev->dev, res);
+	if (!exynos->base)
+		return -EADDRNOTAVAIL;
+
+	exynos->clk = devm_clk_get(&pdev->dev, "timers");
+	if (IS_ERR(exynos->clk)) {
+		dev_err(&pdev->dev, "failed to get timer clock with %ld\n",
+				PTR_ERR(exynos->clk));
+		return PTR_ERR(exynos->clk);
+	}
+
+	mutex_init(&exynos->mutex);
+
+	exynos->chip.dev = &pdev->dev;
+	exynos->chip.ops = &exynos_pwm_ops;
+	exynos->chip.base = -1;
+	exynos->chip.npwm = PWM_NUM;
+
+	ret = clk_prepare_enable(exynos->clk);
+	if (ret)
+		return ret;
+
+	/* Reset registers related with PWM clock and control */
+	writel(PWM_TCFG0_RST_VAL, exynos->base + PWM_TCFG0);
+	writel(PWM_TCFG1_RST_VAL, exynos->base + PWM_TCFG1);
+	writel(PWM_TCON_RST_VAL, exynos->base + PWM_TCON);
+
+	ret = pwmchip_add(&exynos->chip);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "pwmchip_add() failed: %d\n", ret);
+		clk_disable_unprepare(exynos->clk);
+		return ret;
+	}
+
+	platform_set_drvdata(pdev, exynos);
+
+	return 0;
+}
+
+static int __devexit exynos_pwm_remove(struct platform_device *pdev)
+{
+	struct exynos_pwm *exynos = platform_get_drvdata(pdev);
+	if (!exynos)
+		return -ENODEV;
+
+	clk_disable_unprepare(exynos->clk);
+
+	return pwmchip_remove(&exynos->chip);
+}
+
+#ifdef CONFIG_OF
+static const struct of_device_id exynos_pwm_dt_match[] = {
+	{ .compatible = "samsung,exynos-pwm" },
+	{},
+};
+MODULE_DEVICE_TABLE(of, exynos_pwm_dt_match);
+#endif
+
+static struct platform_driver exynos_pwm_driver = {
+	.probe		= exynos_pwm_probe,
+	.remove		= __devexit_p(exynos_pwm_remove),
+	.driver		= {
+		.name	= "exynos-pwm",
+		.owner	= THIS_MODULE,
+		.of_match_table	= of_match_ptr(exynos_pwm_dt_match),
+	},
+};
+module_platform_driver(exynos_pwm_driver);
+
+MODULE_DESCRIPTION("Exynos PWM driver");
+MODULE_AUTHOR("Joonyoung Shim <jy0922.shim@samsung.com>");
+MODULE_LICENSE("GPL");
-- 
1.7.9.5

