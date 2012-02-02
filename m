Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932922Ab2BBRbj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 12:31:39 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:50454 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756956Ab2BBRbd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 12:31:33 -0500
From: Tarun Kanti DebBarma <tarun.kanti@ti.com>
To: <linux-omap@vger.kernel.org>
CC: <grant.likely@secretlab.ca>, <khilman@ti.com>, <tony@atomide.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Charulatha V <charu@ti.com>, Tarun Kanti DebBarma <tarun.kanti@ti.com>
Subject: [PATCH v9 14/25] gpio/omap: remove bank->method & METHOD_* macros
Date: Thu, 2 Feb 2012 23:00:40 +0530
Message-ID: <1328203851-20435-15-git-send-email-tarun.kanti@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1328203851-20435-1-git-send-email-tarun.kanti@ti.com>
References: <1328203851-20435-1-git-send-email-tarun.kanti@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Charulatha V <charu@ti.com>

The only bank->type (method) used in the OMAP GPIO driver is MPUIO type as they
need to be handled separately. Identify the same using a flag and remove all
METHOD_* macros.

mpuio_init() function is defined under #ifdefs. It is required only in case
of MPUIO bank type and only when PM operations are supported by it.
This is applicable only in case of OMAP16xx SoC's MPUIO GPIO bank type.
For all the other cases it is a dummy function. Hence clean up the same
and remove all the OMAP SoC specific #ifdefs.

Signed-off-by: Charulatha V <charu@ti.com>
Signed-off-by: Tarun Kanti DebBarma <tarun.kanti@ti.com>
Reviewed-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Acked-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap1/gpio15xx.c         |    3 +-
 arch/arm/mach-omap1/gpio16xx.c         |    6 +----
 arch/arm/mach-omap1/gpio7xx.c          |    8 +------
 arch/arm/mach-omap2/gpio.c             |    2 -
 arch/arm/plat-omap/include/plat/gpio.h |    8 +------
 drivers/gpio/gpio-omap.c               |   38 +++++--------------------------
 6 files changed, 10 insertions(+), 55 deletions(-)

diff --git a/arch/arm/mach-omap1/gpio15xx.c b/arch/arm/mach-omap1/gpio15xx.c
index 950e467..634903e 100644
--- a/arch/arm/mach-omap1/gpio15xx.c
+++ b/arch/arm/mach-omap1/gpio15xx.c
@@ -47,7 +47,7 @@ static struct omap_gpio_reg_offs omap15xx_mpuio_regs = {
 
 static struct __initdata omap_gpio_platform_data omap15xx_mpu_gpio_config = {
 	.virtual_irq_start	= IH_MPUIO_BASE,
-	.bank_type		= METHOD_MPUIO,
+	.is_mpuio		= true,
 	.bank_width		= 16,
 	.bank_stride		= 1,
 	.regs			= &omap15xx_mpuio_regs,
@@ -90,7 +90,6 @@ static struct omap_gpio_reg_offs omap15xx_gpio_regs = {
 
 static struct __initdata omap_gpio_platform_data omap15xx_gpio_config = {
 	.virtual_irq_start	= IH_GPIO_BASE,
-	.bank_type		= METHOD_GPIO_1510,
 	.bank_width		= 16,
 	.regs                   = &omap15xx_gpio_regs,
 };
diff --git a/arch/arm/mach-omap1/gpio16xx.c b/arch/arm/mach-omap1/gpio16xx.c
index 86ac415..1c5f90e 100644
--- a/arch/arm/mach-omap1/gpio16xx.c
+++ b/arch/arm/mach-omap1/gpio16xx.c
@@ -53,7 +53,7 @@ static struct omap_gpio_reg_offs omap16xx_mpuio_regs = {
 
 static struct __initdata omap_gpio_platform_data omap16xx_mpu_gpio_config = {
 	.virtual_irq_start	= IH_MPUIO_BASE,
-	.bank_type		= METHOD_MPUIO,
+	.is_mpuio		= true,
 	.bank_width		= 16,
 	.bank_stride		= 1,
 	.regs                   = &omap16xx_mpuio_regs,
@@ -100,7 +100,6 @@ static struct omap_gpio_reg_offs omap16xx_gpio_regs = {
 
 static struct __initdata omap_gpio_platform_data omap16xx_gpio1_config = {
 	.virtual_irq_start	= IH_GPIO_BASE,
-	.bank_type		= METHOD_GPIO_1610,
 	.bank_width		= 16,
 	.regs                   = &omap16xx_gpio_regs,
 };
@@ -130,7 +129,6 @@ static struct __initdata resource omap16xx_gpio2_resources[] = {
 
 static struct __initdata omap_gpio_platform_data omap16xx_gpio2_config = {
 	.virtual_irq_start	= IH_GPIO_BASE + 16,
-	.bank_type		= METHOD_GPIO_1610,
 	.bank_width		= 16,
 	.regs                   = &omap16xx_gpio_regs,
 };
@@ -160,7 +158,6 @@ static struct __initdata resource omap16xx_gpio3_resources[] = {
 
 static struct __initdata omap_gpio_platform_data omap16xx_gpio3_config = {
 	.virtual_irq_start	= IH_GPIO_BASE + 32,
-	.bank_type		= METHOD_GPIO_1610,
 	.bank_width		= 16,
 	.regs                   = &omap16xx_gpio_regs,
 };
@@ -190,7 +187,6 @@ static struct __initdata resource omap16xx_gpio4_resources[] = {
 
 static struct __initdata omap_gpio_platform_data omap16xx_gpio4_config = {
 	.virtual_irq_start	= IH_GPIO_BASE + 48,
-	.bank_type		= METHOD_GPIO_1610,
 	.bank_width		= 16,
 	.regs                   = &omap16xx_gpio_regs,
 };
diff --git a/arch/arm/mach-omap1/gpio7xx.c b/arch/arm/mach-omap1/gpio7xx.c
index 207a23c..433491c 100644
--- a/arch/arm/mach-omap1/gpio7xx.c
+++ b/arch/arm/mach-omap1/gpio7xx.c
@@ -52,8 +52,8 @@ static struct omap_gpio_reg_offs omap7xx_mpuio_regs = {
 
 static struct __initdata omap_gpio_platform_data omap7xx_mpu_gpio_config = {
 	.virtual_irq_start	= IH_MPUIO_BASE,
-	.bank_type		= METHOD_MPUIO,
 	.bank_width		= 32,
+	.is_mpuio		= true,
 	.bank_stride		= 2,
 	.regs                   = &omap7xx_mpuio_regs,
 };
@@ -94,7 +94,6 @@ static struct omap_gpio_reg_offs omap7xx_gpio_regs = {
 
 static struct __initdata omap_gpio_platform_data omap7xx_gpio1_config = {
 	.virtual_irq_start	= IH_GPIO_BASE,
-	.bank_type		= METHOD_GPIO_7XX,
 	.bank_width		= 32,
 	.regs			= &omap7xx_gpio_regs,
 };
@@ -124,7 +123,6 @@ static struct __initdata resource omap7xx_gpio2_resources[] = {
 
 static struct __initdata omap_gpio_platform_data omap7xx_gpio2_config = {
 	.virtual_irq_start	= IH_GPIO_BASE + 32,
-	.bank_type		= METHOD_GPIO_7XX,
 	.bank_width		= 32,
 	.regs			= &omap7xx_gpio_regs,
 };
@@ -154,7 +152,6 @@ static struct __initdata resource omap7xx_gpio3_resources[] = {
 
 static struct __initdata omap_gpio_platform_data omap7xx_gpio3_config = {
 	.virtual_irq_start	= IH_GPIO_BASE + 64,
-	.bank_type		= METHOD_GPIO_7XX,
 	.bank_width		= 32,
 	.regs			= &omap7xx_gpio_regs,
 };
@@ -184,7 +181,6 @@ static struct __initdata resource omap7xx_gpio4_resources[] = {
 
 static struct __initdata omap_gpio_platform_data omap7xx_gpio4_config = {
 	.virtual_irq_start	= IH_GPIO_BASE + 96,
-	.bank_type		= METHOD_GPIO_7XX,
 	.bank_width		= 32,
 	.regs			= &omap7xx_gpio_regs,
 };
@@ -214,7 +210,6 @@ static struct __initdata resource omap7xx_gpio5_resources[] = {
 
 static struct __initdata omap_gpio_platform_data omap7xx_gpio5_config = {
 	.virtual_irq_start	= IH_GPIO_BASE + 128,
-	.bank_type		= METHOD_GPIO_7XX,
 	.bank_width		= 32,
 	.regs			= &omap7xx_gpio_regs,
 };
@@ -244,7 +239,6 @@ static struct __initdata resource omap7xx_gpio6_resources[] = {
 
 static struct __initdata omap_gpio_platform_data omap7xx_gpio6_config = {
 	.virtual_irq_start	= IH_GPIO_BASE + 160,
-	.bank_type		= METHOD_GPIO_7XX,
 	.bank_width		= 32,
 	.regs			= &omap7xx_gpio_regs,
 };
diff --git a/arch/arm/mach-omap2/gpio.c b/arch/arm/mach-omap2/gpio.c
index f4c45ca..dfda6b3 100644
--- a/arch/arm/mach-omap2/gpio.c
+++ b/arch/arm/mach-omap2/gpio.c
@@ -74,7 +74,6 @@ static int omap2_gpio_dev_init(struct omap_hwmod *oh, void *unused)
 		/* fall through */
 
 	case 1:
-		pdata->bank_type = METHOD_GPIO_24XX;
 		pdata->regs->revision = OMAP24XX_GPIO_REVISION;
 		pdata->regs->direction = OMAP24XX_GPIO_OE;
 		pdata->regs->datain = OMAP24XX_GPIO_DATAIN;
@@ -97,7 +96,6 @@ static int omap2_gpio_dev_init(struct omap_hwmod *oh, void *unused)
 		pdata->regs->fallingdetect = OMAP24XX_GPIO_FALLINGDETECT;
 		break;
 	case 2:
-		pdata->bank_type = METHOD_GPIO_44XX;
 		pdata->regs->revision = OMAP4_GPIO_REVISION;
 		pdata->regs->direction = OMAP4_GPIO_OE;
 		pdata->regs->datain = OMAP4_GPIO_DATAIN;
diff --git a/arch/arm/plat-omap/include/plat/gpio.h b/arch/arm/plat-omap/include/plat/gpio.h
index 8be1651..cb75b65 100644
--- a/arch/arm/plat-omap/include/plat/gpio.h
+++ b/arch/arm/plat-omap/include/plat/gpio.h
@@ -162,13 +162,6 @@
 				 IH_MPUIO_BASE + ((nr) & 0x0f) : \
 				 IH_GPIO_BASE + (nr))
 
-#define METHOD_MPUIO		0
-#define METHOD_GPIO_1510	1
-#define METHOD_GPIO_1610	2
-#define METHOD_GPIO_7XX		3
-#define METHOD_GPIO_24XX	5
-#define METHOD_GPIO_44XX	6
-
 struct omap_gpio_dev_attr {
 	int bank_width;		/* GPIO bank width */
 	bool dbck_flag;		/* dbck required or not - True for OMAP3&4 */
@@ -210,6 +203,7 @@ struct omap_gpio_platform_data {
 	int bank_stride;	/* Only needed for omap1 MPUIO */
 	bool dbck_flag;		/* dbck required or not - True for OMAP3&4 */
 	bool loses_context;	/* whether the bank would ever lose context */
+	bool is_mpuio;		/* whether the bank is of type MPUIO */
 	u32 non_wakeup_gpios;
 
 	struct omap_gpio_reg_offs *regs;
diff --git a/drivers/gpio/gpio-omap.c b/drivers/gpio/gpio-omap.c
index 38beccc..951d784 100644
--- a/drivers/gpio/gpio-omap.c
+++ b/drivers/gpio/gpio-omap.c
@@ -49,7 +49,6 @@ struct gpio_bank {
 	void __iomem *base;
 	u16 irq;
 	u16 virtual_irq_start;
-	int method;
 	u32 suspend_wakeup;
 	u32 saved_wakeup;
 	u32 non_wakeup_gpios;
@@ -66,6 +65,7 @@ struct gpio_bank {
 	u32 mod_usage;
 	u32 dbck_enable_mask;
 	struct device *dev;
+	bool is_mpuio;
 	bool dbck_flag;
 	bool loses_context;
 	int stride;
@@ -693,14 +693,6 @@ static struct irq_chip gpio_irq_chip = {
 
 /*---------------------------------------------------------------------*/
 
-#ifdef CONFIG_ARCH_OMAP1
-
-#define bank_is_mpuio(bank)	((bank)->method == METHOD_MPUIO)
-
-#ifdef CONFIG_ARCH_OMAP16XX
-
-#include <linux/platform_device.h>
-
 static int omap_mpuio_suspend_noirq(struct device *dev)
 {
 	struct platform_device *pdev = to_platform_device(dev);
@@ -762,23 +754,8 @@ static inline void mpuio_init(struct gpio_bank *bank)
 		(void) platform_device_register(&omap_mpuio_device);
 }
 
-#else
-static inline void mpuio_init(struct gpio_bank *bank) {}
-#endif	/* 16xx */
-
-#else
-
-#define bank_is_mpuio(bank)	0
-static inline void mpuio_init(struct gpio_bank *bank) {}
-
-#endif
-
 /*---------------------------------------------------------------------*/
 
-/* REVISIT these are stupid implementations!  replace by ones that
- * don't switch on METHOD_* and which mostly avoid spinlocks
- */
-
 static int gpio_input(struct gpio_chip *chip, unsigned offset)
 {
 	struct gpio_bank *bank;
@@ -899,7 +876,7 @@ static void omap_gpio_mod_init(struct gpio_bank *bank)
 	if (bank->width == 16)
 		l = 0xffff;
 
-	if (bank_is_mpuio(bank)) {
+	if (bank->is_mpuio) {
 		__raw_writel(l, bank->base + bank->regs->irqenable);
 		return;
 	}
@@ -951,7 +928,6 @@ static void __devinit omap_gpio_chip_init(struct gpio_bank *bank)
 	int j;
 	static int gpio;
 
-	bank->mod_usage = 0;
 	/*
 	 * REVISIT eventually switch from OMAP-specific gpio structs
 	 * over to the generic ones
@@ -964,12 +940,10 @@ static void __devinit omap_gpio_chip_init(struct gpio_bank *bank)
 	bank->chip.set_debounce = gpio_debounce;
 	bank->chip.set = gpio_set;
 	bank->chip.to_irq = gpio_2irq;
-	if (bank_is_mpuio(bank)) {
+	if (bank->is_mpuio) {
 		bank->chip.label = "mpuio";
-#ifdef CONFIG_ARCH_OMAP16XX
 		if (bank->regs->wkup_en)
 			bank->chip.dev = &omap_mpuio_device.dev;
-#endif
 		bank->chip.base = OMAP_MPUIO(0);
 	} else {
 		bank->chip.label = "gpio";
@@ -984,7 +958,7 @@ static void __devinit omap_gpio_chip_init(struct gpio_bank *bank)
 		     j < bank->virtual_irq_start + bank->width; j++) {
 		irq_set_lockdep_class(j, &gpio_lock_class);
 		irq_set_chip_data(j, bank);
-		if (bank_is_mpuio(bank)) {
+		if (bank->is_mpuio) {
 			omap_mpuio_alloc_gc(bank, j, bank->width);
 		} else {
 			irq_set_chip(j, &gpio_irq_chip);
@@ -1028,11 +1002,11 @@ static int __devinit omap_gpio_probe(struct platform_device *pdev)
 
 	pdata = pdev->dev.platform_data;
 	bank->virtual_irq_start = pdata->virtual_irq_start;
-	bank->method = pdata->bank_type;
 	bank->dev = &pdev->dev;
 	bank->dbck_flag = pdata->dbck_flag;
 	bank->stride = pdata->bank_stride;
 	bank->width = pdata->bank_width;
+	bank->is_mpuio = pdata->is_mpuio;
 	bank->non_wakeup_gpios = pdata->non_wakeup_gpios;
 	bank->loses_context = pdata->loses_context;
 	bank->get_context_loss_count = pdata->get_context_loss_count;
@@ -1065,7 +1039,7 @@ static int __devinit omap_gpio_probe(struct platform_device *pdev)
 	pm_runtime_enable(bank->dev);
 	pm_runtime_get_sync(bank->dev);
 
-	if (bank_is_mpuio(bank))
+	if (bank->is_mpuio)
 		mpuio_init(bank);
 
 	omap_gpio_mod_init(bank);
-- 
1.7.0.4

