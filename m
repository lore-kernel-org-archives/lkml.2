Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751548Ab2FRL2k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 07:28:40 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:43832 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415Ab2FRL2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 07:28:38 -0400
X-AuditID: cbfee61b-b7fcc6d000003a7a-0a-4fdf10e37829
From: Sangbeom Kim <sbkim73@samsung.com>
To: "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>,
        sameo@linux.intel.com
Cc: "'Liam Girdwood'" <lrg@ti.com>, linux-kernel@vger.kernel.org,
        sbkim01@gmail.com
Subject: [PATCH 1/7] mfd: samsung: Rename and Replace file and directory
Date: Mon, 18 Jun 2012 20:28:35 +0900
Message-id: <067301cd4d45$7fbe1be0$7f3a53a0$@com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1NRX9Uz5zXunHBR6WSD63YpyyRsw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCLMWRmVeSWpSXmKPExsVy+t9jQd0nAvf9Deb8YrW4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZm7qfshRsnsVScb79E1MD4+ytzF2MnBwSAiYSsydcZISwxSQu
	3FvPBmILCUxnlLh4tbCLkQvInsskcbt1EztIgk1AQ2Ll7rdgRSICvhKXXv5n7WLk4GAWCJbY
	eloPJCws4CFxfMcUJpAwi4CqxMpHCiBhXgFDiZ0XzjBC2IISPybfYwGxmQW0JNbvPM4EYctL
	bF7zlhmkVUJAXeLRX12IRXoSt5ZMZ4coEZHY9+Id4wRGgVlIJs1CMmkWkkmzkLQsYGRZxSia
	WpBcUJyUnmukV5yYW1yal66XnJ+7iREcls+kdzCuarA4xCjAwajEw/uG/b6/EGtiWXFl7iFG
	CQ5mJRHeH1xAId6UxMqq1KL8+KLSnNTiQ4zSHCxK4rxN1hf8hQTSE0tSs1NTC1KLYLJMHJxS
	DYxr5IX5xbWF701MXvHZ8fp8t20Ol8I9T0iE9XIL5a2IYMzxVnvbH6f/sGjqlyWbZ7iFBFy6
	1GW4Pat96ZrEsGqxfy9rHaLm+c9TLW3UXf1jybYsDuENO93T3/AKd8/bJrfz6KIS3uREn8uK
	aXGyPY+0dY9rFx+Zuene6kO7FvrM7Uw5uvHie0slluKMREMt5qLiRAB4+BrXRwIAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously, Samsung PMIC naming rule start with prefix of s5m.
But Naming rule is changed.
>From now on, Prefix will be changed to s2m.
So, To support pmic series of s5m and s2m, change mfd file and directory name.
Continuously, I will post modification patch for s5m8767 regulator driver

Signed-off-by: Sangbeom Kim <sbkim73@samsung.com>
---
 drivers/mfd/Kconfig                  |    6 +-
 drivers/mfd/Makefile                 |    2 +-
 drivers/mfd/s5m-core.c               |  206 --------------
 drivers/mfd/s5m-irq.c                |  495 ----------------------------------
 drivers/mfd/sec-core.c               |  206 ++++++++++++++
 drivers/mfd/sec-irq.c                |  495 ++++++++++++++++++++++++++++++++++
 include/linux/mfd/s5m87xx/s5m-core.h |  379 --------------------------
 include/linux/mfd/s5m87xx/s5m-pmic.h |  129 ---------
 include/linux/mfd/s5m87xx/s5m-rtc.h  |   84 ------
 include/linux/mfd/samsung/s5m-core.h |  379 ++++++++++++++++++++++++++
 include/linux/mfd/samsung/s5m-pmic.h |  129 +++++++++
 include/linux/mfd/samsung/s5m-rtc.h  |   84 ++++++
 12 files changed, 1297 insertions(+), 1297 deletions(-)
 delete mode 100644 drivers/mfd/s5m-core.c
 delete mode 100644 drivers/mfd/s5m-irq.c
 create mode 100644 drivers/mfd/sec-core.c
 create mode 100644 drivers/mfd/sec-irq.c
 delete mode 100644 include/linux/mfd/s5m87xx/s5m-core.h
 delete mode 100644 include/linux/mfd/s5m87xx/s5m-pmic.h
 delete mode 100644 include/linux/mfd/s5m87xx/s5m-rtc.h
 create mode 100644 include/linux/mfd/samsung/s5m-core.h
 create mode 100644 include/linux/mfd/samsung/s5m-pmic.h
 create mode 100644 include/linux/mfd/samsung/s5m-rtc.h

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index e129c82..28c134c 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -468,13 +468,13 @@ config MFD_MAX8998
 	  additional drivers must be enabled in order to use the functionality
 	  of the device.
 
-config MFD_S5M_CORE
-	bool "SAMSUNG S5M Series Support"
+config MFD_SEC_CORE
+	bool "SAMSUNG Electronics PMIC Series Support"
 	depends on I2C=y && GENERIC_HARDIRQS
 	select MFD_CORE
 	select REGMAP_I2C
 	help
-	 Support for the Samsung Electronics S5M MFD series.
+	 Support for the Samsung Electronics PMIC series.
 	 This driver provides common support for accessing the device,
 	 additional drivers must be enabled in order to use the functionality
 	 of the device
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 75f6ed6..46e414b 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -116,6 +116,6 @@ obj-$(CONFIG_MFD_AAT2870_CORE)	+= aat2870-core.o
 obj-$(CONFIG_MFD_INTEL_MSIC)	+= intel_msic.o
 obj-$(CONFIG_MFD_PALMAS)	+= palmas.o
 obj-$(CONFIG_MFD_RC5T583)	+= rc5t583.o rc5t583-irq.o
-obj-$(CONFIG_MFD_S5M_CORE)	+= s5m-core.o s5m-irq.o
+obj-$(CONFIG_MFD_SEC_CORE)	+= sec-core.o sec-irq.o
 obj-$(CONFIG_MFD_ANATOP)	+= anatop-mfd.o
 obj-$(CONFIG_MFD_LM3533)	+= lm3533-core.o lm3533-ctrlbank.o
diff --git a/drivers/mfd/s5m-core.c b/drivers/mfd/s5m-core.c
deleted file mode 100644
index dd17030..0000000
--- a/drivers/mfd/s5m-core.c
+++ /dev/null
@@ -1,206 +0,0 @@
-/*
- * s5m87xx.c
- *
- * Copyright (c) 2011 Samsung Electronics Co., Ltd
- *              http://www.samsung.com
- *
- *  This program is free software; you can redistribute  it and/or modify it
- *  under  the terms of  the GNU General  Public License as published by the
- *  Free Software Foundation;  either version 2 of the  License, or (at your
- *  option) any later version.
- *
- */
-
-#include <linux/module.h>
-#include <linux/moduleparam.h>
-#include <linux/init.h>
-#include <linux/err.h>
-#include <linux/slab.h>
-#include <linux/i2c.h>
-#include <linux/interrupt.h>
-#include <linux/pm_runtime.h>
-#include <linux/mutex.h>
-#include <linux/mfd/core.h>
-#include <linux/mfd/s5m87xx/s5m-core.h>
-#include <linux/mfd/s5m87xx/s5m-pmic.h>
-#include <linux/mfd/s5m87xx/s5m-rtc.h>
-#include <linux/regmap.h>
-
-static struct mfd_cell s5m8751_devs[] = {
-	{
-		.name = "s5m8751-pmic",
-	}, {
-		.name = "s5m-charger",
-	}, {
-		.name = "s5m8751-codec",
-	},
-};
-
-static struct mfd_cell s5m8763_devs[] = {
-	{
-		.name = "s5m8763-pmic",
-	}, {
-		.name = "s5m-rtc",
-	}, {
-		.name = "s5m-charger",
-	},
-};
-
-static struct mfd_cell s5m8767_devs[] = {
-	{
-		.name = "s5m8767-pmic",
-	}, {
-		.name = "s5m-rtc",
-	},
-};
-
-int s5m_reg_read(struct s5m87xx_dev *s5m87xx, u8 reg, void *dest)
-{
-	return regmap_read(s5m87xx->regmap, reg, dest);
-}
-EXPORT_SYMBOL_GPL(s5m_reg_read);
-
-int s5m_bulk_read(struct s5m87xx_dev *s5m87xx, u8 reg, int count, u8 *buf)
-{
-	return regmap_bulk_read(s5m87xx->regmap, reg, buf, count);
-}
-EXPORT_SYMBOL_GPL(s5m_bulk_read);
-
-int s5m_reg_write(struct s5m87xx_dev *s5m87xx, u8 reg, u8 value)
-{
-	return regmap_write(s5m87xx->regmap, reg, value);
-}
-EXPORT_SYMBOL_GPL(s5m_reg_write);
-
-int s5m_bulk_write(struct s5m87xx_dev *s5m87xx, u8 reg, int count, u8 *buf)
-{
-	return regmap_raw_write(s5m87xx->regmap, reg, buf, count);
-}
-EXPORT_SYMBOL_GPL(s5m_bulk_write);
-
-int s5m_reg_update(struct s5m87xx_dev *s5m87xx, u8 reg, u8 val, u8 mask)
-{
-	return regmap_update_bits(s5m87xx->regmap, reg, mask, val);
-}
-EXPORT_SYMBOL_GPL(s5m_reg_update);
-
-static struct regmap_config s5m_regmap_config = {
-	.reg_bits = 8,
-	.val_bits = 8,
-};
-
-static int s5m87xx_i2c_probe(struct i2c_client *i2c,
-			    const struct i2c_device_id *id)
-{
-	struct s5m_platform_data *pdata = i2c->dev.platform_data;
-	struct s5m87xx_dev *s5m87xx;
-	int ret;
-
-	s5m87xx = devm_kzalloc(&i2c->dev, sizeof(struct s5m87xx_dev),
-				GFP_KERNEL);
-	if (s5m87xx == NULL)
-		return -ENOMEM;
-
-	i2c_set_clientdata(i2c, s5m87xx);
-	s5m87xx->dev = &i2c->dev;
-	s5m87xx->i2c = i2c;
-	s5m87xx->irq = i2c->irq;
-	s5m87xx->type = id->driver_data;
-
-	if (pdata) {
-		s5m87xx->device_type = pdata->device_type;
-		s5m87xx->ono = pdata->ono;
-		s5m87xx->irq_base = pdata->irq_base;
-		s5m87xx->wakeup = pdata->wakeup;
-	}
-
-	s5m87xx->regmap = devm_regmap_init_i2c(i2c, &s5m_regmap_config);
-	if (IS_ERR(s5m87xx->regmap)) {
-		ret = PTR_ERR(s5m87xx->regmap);
-		dev_err(&i2c->dev, "Failed to allocate register map: %d\n",
-			ret);
-		return ret;
-	}
-
-	s5m87xx->rtc = i2c_new_dummy(i2c->adapter, RTC_I2C_ADDR);
-	i2c_set_clientdata(s5m87xx->rtc, s5m87xx);
-
-	if (pdata && pdata->cfg_pmic_irq)
-		pdata->cfg_pmic_irq();
-
-	s5m_irq_init(s5m87xx);
-
-	pm_runtime_set_active(s5m87xx->dev);
-
-	switch (s5m87xx->device_type) {
-	case S5M8751X:
-		ret = mfd_add_devices(s5m87xx->dev, -1, s5m8751_devs,
-					ARRAY_SIZE(s5m8751_devs), NULL, 0);
-		break;
-	case S5M8763X:
-		ret = mfd_add_devices(s5m87xx->dev, -1, s5m8763_devs,
-					ARRAY_SIZE(s5m8763_devs), NULL, 0);
-		break;
-	case S5M8767X:
-		ret = mfd_add_devices(s5m87xx->dev, -1, s5m8767_devs,
-					ARRAY_SIZE(s5m8767_devs), NULL, 0);
-		break;
-	default:
-		/* If this happens the probe function is problem */
-		BUG();
-	}
-
-	if (ret < 0)
-		goto err;
-
-	return ret;
-
-err:
-	mfd_remove_devices(s5m87xx->dev);
-	s5m_irq_exit(s5m87xx);
-	i2c_unregister_device(s5m87xx->rtc);
-	return ret;
-}
-
-static int s5m87xx_i2c_remove(struct i2c_client *i2c)
-{
-	struct s5m87xx_dev *s5m87xx = i2c_get_clientdata(i2c);
-
-	mfd_remove_devices(s5m87xx->dev);
-	s5m_irq_exit(s5m87xx);
-	i2c_unregister_device(s5m87xx->rtc);
-	return 0;
-}
-
-static const struct i2c_device_id s5m87xx_i2c_id[] = {
-	{ "s5m87xx", 0 },
-	{ }
-};
-MODULE_DEVICE_TABLE(i2c, s5m87xx_i2c_id);
-
-static struct i2c_driver s5m87xx_i2c_driver = {
-	.driver = {
-		   .name = "s5m87xx",
-		   .owner = THIS_MODULE,
-	},
-	.probe = s5m87xx_i2c_probe,
-	.remove = s5m87xx_i2c_remove,
-	.id_table = s5m87xx_i2c_id,
-};
-
-static int __init s5m87xx_i2c_init(void)
-{
-	return i2c_add_driver(&s5m87xx_i2c_driver);
-}
-
-subsys_initcall(s5m87xx_i2c_init);
-
-static void __exit s5m87xx_i2c_exit(void)
-{
-	i2c_del_driver(&s5m87xx_i2c_driver);
-}
-module_exit(s5m87xx_i2c_exit);
-
-MODULE_AUTHOR("Sangbeom Kim <sbkim73@samsung.com>");
-MODULE_DESCRIPTION("Core support for the S5M MFD");
-MODULE_LICENSE("GPL");
diff --git a/drivers/mfd/s5m-irq.c b/drivers/mfd/s5m-irq.c
deleted file mode 100644
index 0236676..0000000
--- a/drivers/mfd/s5m-irq.c
+++ /dev/null
@@ -1,495 +0,0 @@
-/*
- * s5m-irq.c
- *
- * Copyright (c) 2011 Samsung Electronics Co., Ltd
- *              http://www.samsung.com
- *
- *  This program is free software; you can redistribute  it and/or modify it
- *  under  the terms of  the GNU General  Public License as published by the
- *  Free Software Foundation;  either version 2 of the  License, or (at your
- *  option) any later version.
- *
- */
-
-#include <linux/device.h>
-#include <linux/interrupt.h>
-#include <linux/irq.h>
-#include <linux/mfd/s5m87xx/s5m-core.h>
-
-struct s5m_irq_data {
-	int reg;
-	int mask;
-};
-
-static struct s5m_irq_data s5m8767_irqs[] = {
-	[S5M8767_IRQ_PWRR] = {
-		.reg = 1,
-		.mask = S5M8767_IRQ_PWRR_MASK,
-	},
-	[S5M8767_IRQ_PWRF] = {
-		.reg = 1,
-		.mask = S5M8767_IRQ_PWRF_MASK,
-	},
-	[S5M8767_IRQ_PWR1S] = {
-		.reg = 1,
-		.mask = S5M8767_IRQ_PWR1S_MASK,
-	},
-	[S5M8767_IRQ_JIGR] = {
-		.reg = 1,
-		.mask = S5M8767_IRQ_JIGR_MASK,
-	},
-	[S5M8767_IRQ_JIGF] = {
-		.reg = 1,
-		.mask = S5M8767_IRQ_JIGF_MASK,
-	},
-	[S5M8767_IRQ_LOWBAT2] = {
-		.reg = 1,
-		.mask = S5M8767_IRQ_LOWBAT2_MASK,
-	},
-	[S5M8767_IRQ_LOWBAT1] = {
-		.reg = 1,
-		.mask = S5M8767_IRQ_LOWBAT1_MASK,
-	},
-	[S5M8767_IRQ_MRB] = {
-		.reg = 2,
-		.mask = S5M8767_IRQ_MRB_MASK,
-	},
-	[S5M8767_IRQ_DVSOK2] = {
-		.reg = 2,
-		.mask = S5M8767_IRQ_DVSOK2_MASK,
-	},
-	[S5M8767_IRQ_DVSOK3] = {
-		.reg = 2,
-		.mask = S5M8767_IRQ_DVSOK3_MASK,
-	},
-	[S5M8767_IRQ_DVSOK4] = {
-		.reg = 2,
-		.mask = S5M8767_IRQ_DVSOK4_MASK,
-	},
-	[S5M8767_IRQ_RTC60S] = {
-		.reg = 3,
-		.mask = S5M8767_IRQ_RTC60S_MASK,
-	},
-	[S5M8767_IRQ_RTCA1] = {
-		.reg = 3,
-		.mask = S5M8767_IRQ_RTCA1_MASK,
-	},
-	[S5M8767_IRQ_RTCA2] = {
-		.reg = 3,
-		.mask = S5M8767_IRQ_RTCA2_MASK,
-	},
-	[S5M8767_IRQ_SMPL] = {
-		.reg = 3,
-		.mask = S5M8767_IRQ_SMPL_MASK,
-	},
-	[S5M8767_IRQ_RTC1S] = {
-		.reg = 3,
-		.mask = S5M8767_IRQ_RTC1S_MASK,
-	},
-	[S5M8767_IRQ_WTSR] = {
-		.reg = 3,
-		.mask = S5M8767_IRQ_WTSR_MASK,
-	},
-};
-
-static struct s5m_irq_data s5m8763_irqs[] = {
-	[S5M8763_IRQ_DCINF] = {
-		.reg = 1,
-		.mask = S5M8763_IRQ_DCINF_MASK,
-	},
-	[S5M8763_IRQ_DCINR] = {
-		.reg = 1,
-		.mask = S5M8763_IRQ_DCINR_MASK,
-	},
-	[S5M8763_IRQ_JIGF] = {
-		.reg = 1,
-		.mask = S5M8763_IRQ_JIGF_MASK,
-	},
-	[S5M8763_IRQ_JIGR] = {
-		.reg = 1,
-		.mask = S5M8763_IRQ_JIGR_MASK,
-	},
-	[S5M8763_IRQ_PWRONF] = {
-		.reg = 1,
-		.mask = S5M8763_IRQ_PWRONF_MASK,
-	},
-	[S5M8763_IRQ_PWRONR] = {
-		.reg = 1,
-		.mask = S5M8763_IRQ_PWRONR_MASK,
-	},
-	[S5M8763_IRQ_WTSREVNT] = {
-		.reg = 2,
-		.mask = S5M8763_IRQ_WTSREVNT_MASK,
-	},
-	[S5M8763_IRQ_SMPLEVNT] = {
-		.reg = 2,
-		.mask = S5M8763_IRQ_SMPLEVNT_MASK,
-	},
-	[S5M8763_IRQ_ALARM1] = {
-		.reg = 2,
-		.mask = S5M8763_IRQ_ALARM1_MASK,
-	},
-	[S5M8763_IRQ_ALARM0] = {
-		.reg = 2,
-		.mask = S5M8763_IRQ_ALARM0_MASK,
-	},
-	[S5M8763_IRQ_ONKEY1S] = {
-		.reg = 3,
-		.mask = S5M8763_IRQ_ONKEY1S_MASK,
-	},
-	[S5M8763_IRQ_TOPOFFR] = {
-		.reg = 3,
-		.mask = S5M8763_IRQ_TOPOFFR_MASK,
-	},
-	[S5M8763_IRQ_DCINOVPR] = {
-		.reg = 3,
-		.mask = S5M8763_IRQ_DCINOVPR_MASK,
-	},
-	[S5M8763_IRQ_CHGRSTF] = {
-		.reg = 3,
-		.mask = S5M8763_IRQ_CHGRSTF_MASK,
-	},
-	[S5M8763_IRQ_DONER] = {
-		.reg = 3,
-		.mask = S5M8763_IRQ_DONER_MASK,
-	},
-	[S5M8763_IRQ_CHGFAULT] = {
-		.reg = 3,
-		.mask = S5M8763_IRQ_CHGFAULT_MASK,
-	},
-	[S5M8763_IRQ_LOBAT1] = {
-		.reg = 4,
-		.mask = S5M8763_IRQ_LOBAT1_MASK,
-	},
-	[S5M8763_IRQ_LOBAT2] = {
-		.reg = 4,
-		.mask = S5M8763_IRQ_LOBAT2_MASK,
-	},
-};
-
-static inline struct s5m_irq_data *
-irq_to_s5m8767_irq(struct s5m87xx_dev *s5m87xx, int irq)
-{
-	return &s5m8767_irqs[irq - s5m87xx->irq_base];
-}
-
-static void s5m8767_irq_lock(struct irq_data *data)
-{
-	struct s5m87xx_dev *s5m87xx = irq_data_get_irq_chip_data(data);
-
-	mutex_lock(&s5m87xx->irqlock);
-}
-
-static void s5m8767_irq_sync_unlock(struct irq_data *data)
-{
-	struct s5m87xx_dev *s5m87xx = irq_data_get_irq_chip_data(data);
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(s5m87xx->irq_masks_cur); i++) {
-		if (s5m87xx->irq_masks_cur[i] != s5m87xx->irq_masks_cache[i]) {
-			s5m87xx->irq_masks_cache[i] = s5m87xx->irq_masks_cur[i];
-			s5m_reg_write(s5m87xx, S5M8767_REG_INT1M + i,
-					s5m87xx->irq_masks_cur[i]);
-		}
-	}
-
-	mutex_unlock(&s5m87xx->irqlock);
-}
-
-static void s5m8767_irq_unmask(struct irq_data *data)
-{
-	struct s5m87xx_dev *s5m87xx = irq_data_get_irq_chip_data(data);
-	struct s5m_irq_data *irq_data = irq_to_s5m8767_irq(s5m87xx,
-							       data->irq);
-
-	s5m87xx->irq_masks_cur[irq_data->reg - 1] &= ~irq_data->mask;
-}
-
-static void s5m8767_irq_mask(struct irq_data *data)
-{
-	struct s5m87xx_dev *s5m87xx = irq_data_get_irq_chip_data(data);
-	struct s5m_irq_data *irq_data = irq_to_s5m8767_irq(s5m87xx,
-							       data->irq);
-
-	s5m87xx->irq_masks_cur[irq_data->reg - 1] |= irq_data->mask;
-}
-
-static struct irq_chip s5m8767_irq_chip = {
-	.name = "s5m8767",
-	.irq_bus_lock = s5m8767_irq_lock,
-	.irq_bus_sync_unlock = s5m8767_irq_sync_unlock,
-	.irq_mask = s5m8767_irq_mask,
-	.irq_unmask = s5m8767_irq_unmask,
-};
-
-static inline struct s5m_irq_data *
-irq_to_s5m8763_irq(struct s5m87xx_dev *s5m87xx, int irq)
-{
-	return &s5m8763_irqs[irq - s5m87xx->irq_base];
-}
-
-static void s5m8763_irq_lock(struct irq_data *data)
-{
-	struct s5m87xx_dev *s5m87xx = irq_data_get_irq_chip_data(data);
-
-	mutex_lock(&s5m87xx->irqlock);
-}
-
-static void s5m8763_irq_sync_unlock(struct irq_data *data)
-{
-	struct s5m87xx_dev *s5m87xx = irq_data_get_irq_chip_data(data);
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(s5m87xx->irq_masks_cur); i++) {
-		if (s5m87xx->irq_masks_cur[i] != s5m87xx->irq_masks_cache[i]) {
-			s5m87xx->irq_masks_cache[i] = s5m87xx->irq_masks_cur[i];
-			s5m_reg_write(s5m87xx, S5M8763_REG_IRQM1 + i,
-					s5m87xx->irq_masks_cur[i]);
-		}
-	}
-
-	mutex_unlock(&s5m87xx->irqlock);
-}
-
-static void s5m8763_irq_unmask(struct irq_data *data)
-{
-	struct s5m87xx_dev *s5m87xx = irq_data_get_irq_chip_data(data);
-	struct s5m_irq_data *irq_data = irq_to_s5m8763_irq(s5m87xx,
-							       data->irq);
-
-	s5m87xx->irq_masks_cur[irq_data->reg - 1] &= ~irq_data->mask;
-}
-
-static void s5m8763_irq_mask(struct irq_data *data)
-{
-	struct s5m87xx_dev *s5m87xx = irq_data_get_irq_chip_data(data);
-	struct s5m_irq_data *irq_data = irq_to_s5m8763_irq(s5m87xx,
-							       data->irq);
-
-	s5m87xx->irq_masks_cur[irq_data->reg - 1] |= irq_data->mask;
-}
-
-static struct irq_chip s5m8763_irq_chip = {
-	.name = "s5m8763",
-	.irq_bus_lock = s5m8763_irq_lock,
-	.irq_bus_sync_unlock = s5m8763_irq_sync_unlock,
-	.irq_mask = s5m8763_irq_mask,
-	.irq_unmask = s5m8763_irq_unmask,
-};
-
-
-static irqreturn_t s5m8767_irq_thread(int irq, void *data)
-{
-	struct s5m87xx_dev *s5m87xx = data;
-	u8 irq_reg[NUM_IRQ_REGS-1];
-	int ret;
-	int i;
-
-
-	ret = s5m_bulk_read(s5m87xx, S5M8767_REG_INT1,
-				NUM_IRQ_REGS - 1, irq_reg);
-	if (ret < 0) {
-		dev_err(s5m87xx->dev, "Failed to read interrupt register: %d\n",
-				ret);
-		return IRQ_NONE;
-	}
-
-	for (i = 0; i < NUM_IRQ_REGS - 1; i++)
-		irq_reg[i] &= ~s5m87xx->irq_masks_cur[i];
-
-	for (i = 0; i < S5M8767_IRQ_NR; i++) {
-		if (irq_reg[s5m8767_irqs[i].reg - 1] & s5m8767_irqs[i].mask)
-			handle_nested_irq(s5m87xx->irq_base + i);
-	}
-
-	return IRQ_HANDLED;
-}
-
-static irqreturn_t s5m8763_irq_thread(int irq, void *data)
-{
-	struct s5m87xx_dev *s5m87xx = data;
-	u8 irq_reg[NUM_IRQ_REGS];
-	int ret;
-	int i;
-
-	ret = s5m_bulk_read(s5m87xx, S5M8763_REG_IRQ1,
-				NUM_IRQ_REGS, irq_reg);
-	if (ret < 0) {
-		dev_err(s5m87xx->dev, "Failed to read interrupt register: %d\n",
-				ret);
-		return IRQ_NONE;
-	}
-
-	for (i = 0; i < NUM_IRQ_REGS; i++)
-		irq_reg[i] &= ~s5m87xx->irq_masks_cur[i];
-
-	for (i = 0; i < S5M8763_IRQ_NR; i++) {
-		if (irq_reg[s5m8763_irqs[i].reg - 1] & s5m8763_irqs[i].mask)
-			handle_nested_irq(s5m87xx->irq_base + i);
-	}
-
-	return IRQ_HANDLED;
-}
-
-int s5m_irq_resume(struct s5m87xx_dev *s5m87xx)
-{
-	if (s5m87xx->irq && s5m87xx->irq_base){
-		switch (s5m87xx->device_type) {
-		case S5M8763X:
-			s5m8763_irq_thread(s5m87xx->irq_base, s5m87xx);
-			break;
-		case S5M8767X:
-			s5m8767_irq_thread(s5m87xx->irq_base, s5m87xx);
-			break;
-		default:
-			dev_err(s5m87xx->dev,
-				"Unknown device type %d\n",
-				s5m87xx->device_type);
-			return -EINVAL;
-
-		}
-	}
-	return 0;
-}
-
-int s5m_irq_init(struct s5m87xx_dev *s5m87xx)
-{
-	int i;
-	int cur_irq;
-	int ret = 0;
-	int type = s5m87xx->device_type;
-
-	if (!s5m87xx->irq) {
-		dev_warn(s5m87xx->dev,
-			 "No interrupt specified, no interrupts\n");
-		s5m87xx->irq_base = 0;
-		return 0;
-	}
-
-	if (!s5m87xx->irq_base) {
-		dev_err(s5m87xx->dev,
-			"No interrupt base specified, no interrupts\n");
-		return 0;
-	}
-
-	mutex_init(&s5m87xx->irqlock);
-
-	switch (type) {
-	case S5M8763X:
-		for (i = 0; i < NUM_IRQ_REGS; i++) {
-			s5m87xx->irq_masks_cur[i] = 0xff;
-			s5m87xx->irq_masks_cache[i] = 0xff;
-			s5m_reg_write(s5m87xx, S5M8763_REG_IRQM1 + i,
-						0xff);
-		}
-
-		s5m_reg_write(s5m87xx, S5M8763_REG_STATUSM1, 0xff);
-		s5m_reg_write(s5m87xx, S5M8763_REG_STATUSM2, 0xff);
-
-		for (i = 0; i < S5M8763_IRQ_NR; i++) {
-			cur_irq = i + s5m87xx->irq_base;
-			irq_set_chip_data(cur_irq, s5m87xx);
-			irq_set_chip_and_handler(cur_irq, &s5m8763_irq_chip,
-						 handle_edge_irq);
-			irq_set_nested_thread(cur_irq, 1);
-#ifdef CONFIG_ARM
-			set_irq_flags(cur_irq, IRQF_VALID);
-#else
-			irq_set_noprobe(cur_irq);
-#endif
-		}
-
-		ret = request_threaded_irq(s5m87xx->irq, NULL,
-					s5m8763_irq_thread,
-					IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
-					"s5m87xx-irq", s5m87xx);
-		if (ret) {
-			dev_err(s5m87xx->dev, "Failed to request IRQ %d: %d\n",
-				s5m87xx->irq, ret);
-			return ret;
-		}
-		break;
-	case S5M8767X:
-		for (i = 0; i < NUM_IRQ_REGS - 1; i++) {
-			s5m87xx->irq_masks_cur[i] = 0xff;
-			s5m87xx->irq_masks_cache[i] = 0xff;
-			s5m_reg_write(s5m87xx, S5M8767_REG_INT1M + i,
-						0xff);
-		}
-		for (i = 0; i < S5M8767_IRQ_NR; i++) {
-			cur_irq = i + s5m87xx->irq_base;
-			irq_set_chip_data(cur_irq, s5m87xx);
-			if (ret) {
-				dev_err(s5m87xx->dev,
-					"Failed to irq_set_chip_data %d: %d\n",
-					s5m87xx->irq, ret);
-				return ret;
-			}
-
-			irq_set_chip_and_handler(cur_irq, &s5m8767_irq_chip,
-						 handle_edge_irq);
-			irq_set_nested_thread(cur_irq, 1);
-#ifdef CONFIG_ARM
-			set_irq_flags(cur_irq, IRQF_VALID);
-#else
-			irq_set_noprobe(cur_irq);
-#endif
-		}
-
-		ret = request_threaded_irq(s5m87xx->irq, NULL,
-					   s5m8767_irq_thread,
-					   IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
-					   "s5m87xx-irq", s5m87xx);
-		if (ret) {
-			dev_err(s5m87xx->dev, "Failed to request IRQ %d: %d\n",
-				s5m87xx->irq, ret);
-			return ret;
-		}
-		break;
-	default:
-		dev_err(s5m87xx->dev,
-			"Unknown device type %d\n", s5m87xx->device_type);
-		return -EINVAL;
-	}
-
-	if (!s5m87xx->ono)
-		return 0;
-
-	switch (type) {
-	case S5M8763X:
-		ret = request_threaded_irq(s5m87xx->ono, NULL,
-						s5m8763_irq_thread,
-						IRQF_TRIGGER_FALLING |
-						IRQF_TRIGGER_RISING |
-						IRQF_ONESHOT, "s5m87xx-ono",
-						s5m87xx);
-		break;
-	case S5M8767X:
-		ret = request_threaded_irq(s5m87xx->ono, NULL,
-					s5m8767_irq_thread,
-					IRQF_TRIGGER_FALLING |
-					IRQF_TRIGGER_RISING |
-					IRQF_ONESHOT, "s5m87xx-ono", s5m87xx);
-		break;
-	default:
-		ret = -EINVAL;
-		break;
-	}
-
-	if (ret) {
-		dev_err(s5m87xx->dev, "Failed to request IRQ %d: %d\n",
-			s5m87xx->ono, ret);
-		return ret;
-	}
-
-	return 0;
-}
-
-void s5m_irq_exit(struct s5m87xx_dev *s5m87xx)
-{
-	if (s5m87xx->ono)
-		free_irq(s5m87xx->ono, s5m87xx);
-
-	if (s5m87xx->irq)
-		free_irq(s5m87xx->irq, s5m87xx);
-}
diff --git a/drivers/mfd/sec-core.c b/drivers/mfd/sec-core.c
new file mode 100644
index 0000000..b090360
--- /dev/null
+++ b/drivers/mfd/sec-core.c
@@ -0,0 +1,206 @@
+/*
+ * s5m87xx.c
+ *
+ * Copyright (c) 2011 Samsung Electronics Co., Ltd
+ *              http://www.samsung.com
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/init.h>
+#include <linux/err.h>
+#include <linux/slab.h>
+#include <linux/i2c.h>
+#include <linux/interrupt.h>
+#include <linux/pm_runtime.h>
+#include <linux/mutex.h>
+#include <linux/mfd/core.h>
+#include <linux/mfd/samsung/s5m-core.h>
+#include <linux/mfd/samsung/s5m-pmic.h>
+#include <linux/mfd/samsung/s5m-rtc.h>
+#include <linux/regmap.h>
+
+static struct mfd_cell s5m8751_devs[] = {
+	{
+		.name = "s5m8751-pmic",
+	}, {
+		.name = "s5m-charger",
+	}, {
+		.name = "s5m8751-codec",
+	},
+};
+
+static struct mfd_cell s5m8763_devs[] = {
+	{
+		.name = "s5m8763-pmic",
+	}, {
+		.name = "s5m-rtc",
+	}, {
+		.name = "s5m-charger",
+	},
+};
+
+static struct mfd_cell s5m8767_devs[] = {
+	{
+		.name = "s5m8767-pmic",
+	}, {
+		.name = "s5m-rtc",
+	},
+};
+
+int s5m_reg_read(struct s5m87xx_dev *s5m87xx, u8 reg, void *dest)
+{
+	return regmap_read(s5m87xx->regmap, reg, dest);
+}
+EXPORT_SYMBOL_GPL(s5m_reg_read);
+
+int s5m_bulk_read(struct s5m87xx_dev *s5m87xx, u8 reg, int count, u8 *buf)
+{
+	return regmap_bulk_read(s5m87xx->regmap, reg, buf, count);
+}
+EXPORT_SYMBOL_GPL(s5m_bulk_read);
+
+int s5m_reg_write(struct s5m87xx_dev *s5m87xx, u8 reg, u8 value)
+{
+	return regmap_write(s5m87xx->regmap, reg, value);
+}
+EXPORT_SYMBOL_GPL(s5m_reg_write);
+
+int s5m_bulk_write(struct s5m87xx_dev *s5m87xx, u8 reg, int count, u8 *buf)
+{
+	return regmap_raw_write(s5m87xx->regmap, reg, buf, count);
+}
+EXPORT_SYMBOL_GPL(s5m_bulk_write);
+
+int s5m_reg_update(struct s5m87xx_dev *s5m87xx, u8 reg, u8 val, u8 mask)
+{
+	return regmap_update_bits(s5m87xx->regmap, reg, mask, val);
+}
+EXPORT_SYMBOL_GPL(s5m_reg_update);
+
+static struct regmap_config s5m_regmap_config = {
+	.reg_bits = 8,
+	.val_bits = 8,
+};
+
+static int s5m87xx_i2c_probe(struct i2c_client *i2c,
+			    const struct i2c_device_id *id)
+{
+	struct s5m_platform_data *pdata = i2c->dev.platform_data;
+	struct s5m87xx_dev *s5m87xx;
+	int ret;
+
+	s5m87xx = devm_kzalloc(&i2c->dev, sizeof(struct s5m87xx_dev),
+				GFP_KERNEL);
+	if (s5m87xx == NULL)
+		return -ENOMEM;
+
+	i2c_set_clientdata(i2c, s5m87xx);
+	s5m87xx->dev = &i2c->dev;
+	s5m87xx->i2c = i2c;
+	s5m87xx->irq = i2c->irq;
+	s5m87xx->type = id->driver_data;
+
+	if (pdata) {
+		s5m87xx->device_type = pdata->device_type;
+		s5m87xx->ono = pdata->ono;
+		s5m87xx->irq_base = pdata->irq_base;
+		s5m87xx->wakeup = pdata->wakeup;
+	}
+
+	s5m87xx->regmap = devm_regmap_init_i2c(i2c, &s5m_regmap_config);
+	if (IS_ERR(s5m87xx->regmap)) {
+		ret = PTR_ERR(s5m87xx->regmap);
+		dev_err(&i2c->dev, "Failed to allocate register map: %d\n",
+			ret);
+		return ret;
+	}
+
+	s5m87xx->rtc = i2c_new_dummy(i2c->adapter, RTC_I2C_ADDR);
+	i2c_set_clientdata(s5m87xx->rtc, s5m87xx);
+
+	if (pdata && pdata->cfg_pmic_irq)
+		pdata->cfg_pmic_irq();
+
+	s5m_irq_init(s5m87xx);
+
+	pm_runtime_set_active(s5m87xx->dev);
+
+	switch (s5m87xx->device_type) {
+	case S5M8751X:
+		ret = mfd_add_devices(s5m87xx->dev, -1, s5m8751_devs,
+					ARRAY_SIZE(s5m8751_devs), NULL, 0);
+		break;
+	case S5M8763X:
+		ret = mfd_add_devices(s5m87xx->dev, -1, s5m8763_devs,
+					ARRAY_SIZE(s5m8763_devs), NULL, 0);
+		break;
+	case S5M8767X:
+		ret = mfd_add_devices(s5m87xx->dev, -1, s5m8767_devs,
+					ARRAY_SIZE(s5m8767_devs), NULL, 0);
+		break;
+	default:
+		/* If this happens the probe function is problem */
+		BUG();
+	}
+
+	if (ret < 0)
+		goto err;
+
+	return ret;
+
+err:
+	mfd_remove_devices(s5m87xx->dev);
+	s5m_irq_exit(s5m87xx);
+	i2c_unregister_device(s5m87xx->rtc);
+	return ret;
+}
+
+static int s5m87xx_i2c_remove(struct i2c_client *i2c)
+{
+	struct s5m87xx_dev *s5m87xx = i2c_get_clientdata(i2c);
+
+	mfd_remove_devices(s5m87xx->dev);
+	s5m_irq_exit(s5m87xx);
+	i2c_unregister_device(s5m87xx->rtc);
+	return 0;
+}
+
+static const struct i2c_device_id s5m87xx_i2c_id[] = {
+	{ "s5m87xx", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, s5m87xx_i2c_id);
+
+static struct i2c_driver s5m87xx_i2c_driver = {
+	.driver = {
+		   .name = "s5m87xx",
+		   .owner = THIS_MODULE,
+	},
+	.probe = s5m87xx_i2c_probe,
+	.remove = s5m87xx_i2c_remove,
+	.id_table = s5m87xx_i2c_id,
+};
+
+static int __init s5m87xx_i2c_init(void)
+{
+	return i2c_add_driver(&s5m87xx_i2c_driver);
+}
+
+subsys_initcall(s5m87xx_i2c_init);
+
+static void __exit s5m87xx_i2c_exit(void)
+{
+	i2c_del_driver(&s5m87xx_i2c_driver);
+}
+module_exit(s5m87xx_i2c_exit);
+
+MODULE_AUTHOR("Sangbeom Kim <sbkim73@samsung.com>");
+MODULE_DESCRIPTION("Core support for the S5M MFD");
+MODULE_LICENSE("GPL");
diff --git a/drivers/mfd/sec-irq.c b/drivers/mfd/sec-irq.c
new file mode 100644
index 0000000..f60364f
--- /dev/null
+++ b/drivers/mfd/sec-irq.c
@@ -0,0 +1,495 @@
+/*
+ * s5m-irq.c
+ *
+ * Copyright (c) 2011 Samsung Electronics Co., Ltd
+ *              http://www.samsung.com
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ *
+ */
+
+#include <linux/device.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/mfd/samsung/s5m-core.h>
+
+struct s5m_irq_data {
+	int reg;
+	int mask;
+};
+
+static struct s5m_irq_data s5m8767_irqs[] = {
+	[S5M8767_IRQ_PWRR] = {
+		.reg = 1,
+		.mask = S5M8767_IRQ_PWRR_MASK,
+	},
+	[S5M8767_IRQ_PWRF] = {
+		.reg = 1,
+		.mask = S5M8767_IRQ_PWRF_MASK,
+	},
+	[S5M8767_IRQ_PWR1S] = {
+		.reg = 1,
+		.mask = S5M8767_IRQ_PWR1S_MASK,
+	},
+	[S5M8767_IRQ_JIGR] = {
+		.reg = 1,
+		.mask = S5M8767_IRQ_JIGR_MASK,
+	},
+	[S5M8767_IRQ_JIGF] = {
+		.reg = 1,
+		.mask = S5M8767_IRQ_JIGF_MASK,
+	},
+	[S5M8767_IRQ_LOWBAT2] = {
+		.reg = 1,
+		.mask = S5M8767_IRQ_LOWBAT2_MASK,
+	},
+	[S5M8767_IRQ_LOWBAT1] = {
+		.reg = 1,
+		.mask = S5M8767_IRQ_LOWBAT1_MASK,
+	},
+	[S5M8767_IRQ_MRB] = {
+		.reg = 2,
+		.mask = S5M8767_IRQ_MRB_MASK,
+	},
+	[S5M8767_IRQ_DVSOK2] = {
+		.reg = 2,
+		.mask = S5M8767_IRQ_DVSOK2_MASK,
+	},
+	[S5M8767_IRQ_DVSOK3] = {
+		.reg = 2,
+		.mask = S5M8767_IRQ_DVSOK3_MASK,
+	},
+	[S5M8767_IRQ_DVSOK4] = {
+		.reg = 2,
+		.mask = S5M8767_IRQ_DVSOK4_MASK,
+	},
+	[S5M8767_IRQ_RTC60S] = {
+		.reg = 3,
+		.mask = S5M8767_IRQ_RTC60S_MASK,
+	},
+	[S5M8767_IRQ_RTCA1] = {
+		.reg = 3,
+		.mask = S5M8767_IRQ_RTCA1_MASK,
+	},
+	[S5M8767_IRQ_RTCA2] = {
+		.reg = 3,
+		.mask = S5M8767_IRQ_RTCA2_MASK,
+	},
+	[S5M8767_IRQ_SMPL] = {
+		.reg = 3,
+		.mask = S5M8767_IRQ_SMPL_MASK,
+	},
+	[S5M8767_IRQ_RTC1S] = {
+		.reg = 3,
+		.mask = S5M8767_IRQ_RTC1S_MASK,
+	},
+	[S5M8767_IRQ_WTSR] = {
+		.reg = 3,
+		.mask = S5M8767_IRQ_WTSR_MASK,
+	},
+};
+
+static struct s5m_irq_data s5m8763_irqs[] = {
+	[S5M8763_IRQ_DCINF] = {
+		.reg = 1,
+		.mask = S5M8763_IRQ_DCINF_MASK,
+	},
+	[S5M8763_IRQ_DCINR] = {
+		.reg = 1,
+		.mask = S5M8763_IRQ_DCINR_MASK,
+	},
+	[S5M8763_IRQ_JIGF] = {
+		.reg = 1,
+		.mask = S5M8763_IRQ_JIGF_MASK,
+	},
+	[S5M8763_IRQ_JIGR] = {
+		.reg = 1,
+		.mask = S5M8763_IRQ_JIGR_MASK,
+	},
+	[S5M8763_IRQ_PWRONF] = {
+		.reg = 1,
+		.mask = S5M8763_IRQ_PWRONF_MASK,
+	},
+	[S5M8763_IRQ_PWRONR] = {
+		.reg = 1,
+		.mask = S5M8763_IRQ_PWRONR_MASK,
+	},
+	[S5M8763_IRQ_WTSREVNT] = {
+		.reg = 2,
+		.mask = S5M8763_IRQ_WTSREVNT_MASK,
+	},
+	[S5M8763_IRQ_SMPLEVNT] = {
+		.reg = 2,
+		.mask = S5M8763_IRQ_SMPLEVNT_MASK,
+	},
+	[S5M8763_IRQ_ALARM1] = {
+		.reg = 2,
+		.mask = S5M8763_IRQ_ALARM1_MASK,
+	},
+	[S5M8763_IRQ_ALARM0] = {
+		.reg = 2,
+		.mask = S5M8763_IRQ_ALARM0_MASK,
+	},
+	[S5M8763_IRQ_ONKEY1S] = {
+		.reg = 3,
+		.mask = S5M8763_IRQ_ONKEY1S_MASK,
+	},
+	[S5M8763_IRQ_TOPOFFR] = {
+		.reg = 3,
+		.mask = S5M8763_IRQ_TOPOFFR_MASK,
+	},
+	[S5M8763_IRQ_DCINOVPR] = {
+		.reg = 3,
+		.mask = S5M8763_IRQ_DCINOVPR_MASK,
+	},
+	[S5M8763_IRQ_CHGRSTF] = {
+		.reg = 3,
+		.mask = S5M8763_IRQ_CHGRSTF_MASK,
+	},
+	[S5M8763_IRQ_DONER] = {
+		.reg = 3,
+		.mask = S5M8763_IRQ_DONER_MASK,
+	},
+	[S5M8763_IRQ_CHGFAULT] = {
+		.reg = 3,
+		.mask = S5M8763_IRQ_CHGFAULT_MASK,
+	},
+	[S5M8763_IRQ_LOBAT1] = {
+		.reg = 4,
+		.mask = S5M8763_IRQ_LOBAT1_MASK,
+	},
+	[S5M8763_IRQ_LOBAT2] = {
+		.reg = 4,
+		.mask = S5M8763_IRQ_LOBAT2_MASK,
+	},
+};
+
+static inline struct s5m_irq_data *
+irq_to_s5m8767_irq(struct s5m87xx_dev *s5m87xx, int irq)
+{
+	return &s5m8767_irqs[irq - s5m87xx->irq_base];
+}
+
+static void s5m8767_irq_lock(struct irq_data *data)
+{
+	struct s5m87xx_dev *s5m87xx = irq_data_get_irq_chip_data(data);
+
+	mutex_lock(&s5m87xx->irqlock);
+}
+
+static void s5m8767_irq_sync_unlock(struct irq_data *data)
+{
+	struct s5m87xx_dev *s5m87xx = irq_data_get_irq_chip_data(data);
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(s5m87xx->irq_masks_cur); i++) {
+		if (s5m87xx->irq_masks_cur[i] != s5m87xx->irq_masks_cache[i]) {
+			s5m87xx->irq_masks_cache[i] = s5m87xx->irq_masks_cur[i];
+			s5m_reg_write(s5m87xx, S5M8767_REG_INT1M + i,
+					s5m87xx->irq_masks_cur[i]);
+		}
+	}
+
+	mutex_unlock(&s5m87xx->irqlock);
+}
+
+static void s5m8767_irq_unmask(struct irq_data *data)
+{
+	struct s5m87xx_dev *s5m87xx = irq_data_get_irq_chip_data(data);
+	struct s5m_irq_data *irq_data = irq_to_s5m8767_irq(s5m87xx,
+							       data->irq);
+
+	s5m87xx->irq_masks_cur[irq_data->reg - 1] &= ~irq_data->mask;
+}
+
+static void s5m8767_irq_mask(struct irq_data *data)
+{
+	struct s5m87xx_dev *s5m87xx = irq_data_get_irq_chip_data(data);
+	struct s5m_irq_data *irq_data = irq_to_s5m8767_irq(s5m87xx,
+							       data->irq);
+
+	s5m87xx->irq_masks_cur[irq_data->reg - 1] |= irq_data->mask;
+}
+
+static struct irq_chip s5m8767_irq_chip = {
+	.name = "s5m8767",
+	.irq_bus_lock = s5m8767_irq_lock,
+	.irq_bus_sync_unlock = s5m8767_irq_sync_unlock,
+	.irq_mask = s5m8767_irq_mask,
+	.irq_unmask = s5m8767_irq_unmask,
+};
+
+static inline struct s5m_irq_data *
+irq_to_s5m8763_irq(struct s5m87xx_dev *s5m87xx, int irq)
+{
+	return &s5m8763_irqs[irq - s5m87xx->irq_base];
+}
+
+static void s5m8763_irq_lock(struct irq_data *data)
+{
+	struct s5m87xx_dev *s5m87xx = irq_data_get_irq_chip_data(data);
+
+	mutex_lock(&s5m87xx->irqlock);
+}
+
+static void s5m8763_irq_sync_unlock(struct irq_data *data)
+{
+	struct s5m87xx_dev *s5m87xx = irq_data_get_irq_chip_data(data);
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(s5m87xx->irq_masks_cur); i++) {
+		if (s5m87xx->irq_masks_cur[i] != s5m87xx->irq_masks_cache[i]) {
+			s5m87xx->irq_masks_cache[i] = s5m87xx->irq_masks_cur[i];
+			s5m_reg_write(s5m87xx, S5M8763_REG_IRQM1 + i,
+					s5m87xx->irq_masks_cur[i]);
+		}
+	}
+
+	mutex_unlock(&s5m87xx->irqlock);
+}
+
+static void s5m8763_irq_unmask(struct irq_data *data)
+{
+	struct s5m87xx_dev *s5m87xx = irq_data_get_irq_chip_data(data);
+	struct s5m_irq_data *irq_data = irq_to_s5m8763_irq(s5m87xx,
+							       data->irq);
+
+	s5m87xx->irq_masks_cur[irq_data->reg - 1] &= ~irq_data->mask;
+}
+
+static void s5m8763_irq_mask(struct irq_data *data)
+{
+	struct s5m87xx_dev *s5m87xx = irq_data_get_irq_chip_data(data);
+	struct s5m_irq_data *irq_data = irq_to_s5m8763_irq(s5m87xx,
+							       data->irq);
+
+	s5m87xx->irq_masks_cur[irq_data->reg - 1] |= irq_data->mask;
+}
+
+static struct irq_chip s5m8763_irq_chip = {
+	.name = "s5m8763",
+	.irq_bus_lock = s5m8763_irq_lock,
+	.irq_bus_sync_unlock = s5m8763_irq_sync_unlock,
+	.irq_mask = s5m8763_irq_mask,
+	.irq_unmask = s5m8763_irq_unmask,
+};
+
+
+static irqreturn_t s5m8767_irq_thread(int irq, void *data)
+{
+	struct s5m87xx_dev *s5m87xx = data;
+	u8 irq_reg[NUM_IRQ_REGS-1];
+	int ret;
+	int i;
+
+
+	ret = s5m_bulk_read(s5m87xx, S5M8767_REG_INT1,
+				NUM_IRQ_REGS - 1, irq_reg);
+	if (ret < 0) {
+		dev_err(s5m87xx->dev, "Failed to read interrupt register: %d\n",
+				ret);
+		return IRQ_NONE;
+	}
+
+	for (i = 0; i < NUM_IRQ_REGS - 1; i++)
+		irq_reg[i] &= ~s5m87xx->irq_masks_cur[i];
+
+	for (i = 0; i < S5M8767_IRQ_NR; i++) {
+		if (irq_reg[s5m8767_irqs[i].reg - 1] & s5m8767_irqs[i].mask)
+			handle_nested_irq(s5m87xx->irq_base + i);
+	}
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t s5m8763_irq_thread(int irq, void *data)
+{
+	struct s5m87xx_dev *s5m87xx = data;
+	u8 irq_reg[NUM_IRQ_REGS];
+	int ret;
+	int i;
+
+	ret = s5m_bulk_read(s5m87xx, S5M8763_REG_IRQ1,
+				NUM_IRQ_REGS, irq_reg);
+	if (ret < 0) {
+		dev_err(s5m87xx->dev, "Failed to read interrupt register: %d\n",
+				ret);
+		return IRQ_NONE;
+	}
+
+	for (i = 0; i < NUM_IRQ_REGS; i++)
+		irq_reg[i] &= ~s5m87xx->irq_masks_cur[i];
+
+	for (i = 0; i < S5M8763_IRQ_NR; i++) {
+		if (irq_reg[s5m8763_irqs[i].reg - 1] & s5m8763_irqs[i].mask)
+			handle_nested_irq(s5m87xx->irq_base + i);
+	}
+
+	return IRQ_HANDLED;
+}
+
+int s5m_irq_resume(struct s5m87xx_dev *s5m87xx)
+{
+	if (s5m87xx->irq && s5m87xx->irq_base){
+		switch (s5m87xx->device_type) {
+		case S5M8763X:
+			s5m8763_irq_thread(s5m87xx->irq_base, s5m87xx);
+			break;
+		case S5M8767X:
+			s5m8767_irq_thread(s5m87xx->irq_base, s5m87xx);
+			break;
+		default:
+			dev_err(s5m87xx->dev,
+				"Unknown device type %d\n",
+				s5m87xx->device_type);
+			return -EINVAL;
+
+		}
+	}
+	return 0;
+}
+
+int s5m_irq_init(struct s5m87xx_dev *s5m87xx)
+{
+	int i;
+	int cur_irq;
+	int ret = 0;
+	int type = s5m87xx->device_type;
+
+	if (!s5m87xx->irq) {
+		dev_warn(s5m87xx->dev,
+			 "No interrupt specified, no interrupts\n");
+		s5m87xx->irq_base = 0;
+		return 0;
+	}
+
+	if (!s5m87xx->irq_base) {
+		dev_err(s5m87xx->dev,
+			"No interrupt base specified, no interrupts\n");
+		return 0;
+	}
+
+	mutex_init(&s5m87xx->irqlock);
+
+	switch (type) {
+	case S5M8763X:
+		for (i = 0; i < NUM_IRQ_REGS; i++) {
+			s5m87xx->irq_masks_cur[i] = 0xff;
+			s5m87xx->irq_masks_cache[i] = 0xff;
+			s5m_reg_write(s5m87xx, S5M8763_REG_IRQM1 + i,
+						0xff);
+		}
+
+		s5m_reg_write(s5m87xx, S5M8763_REG_STATUSM1, 0xff);
+		s5m_reg_write(s5m87xx, S5M8763_REG_STATUSM2, 0xff);
+
+		for (i = 0; i < S5M8763_IRQ_NR; i++) {
+			cur_irq = i + s5m87xx->irq_base;
+			irq_set_chip_data(cur_irq, s5m87xx);
+			irq_set_chip_and_handler(cur_irq, &s5m8763_irq_chip,
+						 handle_edge_irq);
+			irq_set_nested_thread(cur_irq, 1);
+#ifdef CONFIG_ARM
+			set_irq_flags(cur_irq, IRQF_VALID);
+#else
+			irq_set_noprobe(cur_irq);
+#endif
+		}
+
+		ret = request_threaded_irq(s5m87xx->irq, NULL,
+					s5m8763_irq_thread,
+					IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
+					"s5m87xx-irq", s5m87xx);
+		if (ret) {
+			dev_err(s5m87xx->dev, "Failed to request IRQ %d: %d\n",
+				s5m87xx->irq, ret);
+			return ret;
+		}
+		break;
+	case S5M8767X:
+		for (i = 0; i < NUM_IRQ_REGS - 1; i++) {
+			s5m87xx->irq_masks_cur[i] = 0xff;
+			s5m87xx->irq_masks_cache[i] = 0xff;
+			s5m_reg_write(s5m87xx, S5M8767_REG_INT1M + i,
+						0xff);
+		}
+		for (i = 0; i < S5M8767_IRQ_NR; i++) {
+			cur_irq = i + s5m87xx->irq_base;
+			irq_set_chip_data(cur_irq, s5m87xx);
+			if (ret) {
+				dev_err(s5m87xx->dev,
+					"Failed to irq_set_chip_data %d: %d\n",
+					s5m87xx->irq, ret);
+				return ret;
+			}
+
+			irq_set_chip_and_handler(cur_irq, &s5m8767_irq_chip,
+						 handle_edge_irq);
+			irq_set_nested_thread(cur_irq, 1);
+#ifdef CONFIG_ARM
+			set_irq_flags(cur_irq, IRQF_VALID);
+#else
+			irq_set_noprobe(cur_irq);
+#endif
+		}
+
+		ret = request_threaded_irq(s5m87xx->irq, NULL,
+					   s5m8767_irq_thread,
+					   IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
+					   "s5m87xx-irq", s5m87xx);
+		if (ret) {
+			dev_err(s5m87xx->dev, "Failed to request IRQ %d: %d\n",
+				s5m87xx->irq, ret);
+			return ret;
+		}
+		break;
+	default:
+		dev_err(s5m87xx->dev,
+			"Unknown device type %d\n", s5m87xx->device_type);
+		return -EINVAL;
+	}
+
+	if (!s5m87xx->ono)
+		return 0;
+
+	switch (type) {
+	case S5M8763X:
+		ret = request_threaded_irq(s5m87xx->ono, NULL,
+						s5m8763_irq_thread,
+						IRQF_TRIGGER_FALLING |
+						IRQF_TRIGGER_RISING |
+						IRQF_ONESHOT, "s5m87xx-ono",
+						s5m87xx);
+		break;
+	case S5M8767X:
+		ret = request_threaded_irq(s5m87xx->ono, NULL,
+					s5m8767_irq_thread,
+					IRQF_TRIGGER_FALLING |
+					IRQF_TRIGGER_RISING |
+					IRQF_ONESHOT, "s5m87xx-ono", s5m87xx);
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+	if (ret) {
+		dev_err(s5m87xx->dev, "Failed to request IRQ %d: %d\n",
+			s5m87xx->ono, ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+void s5m_irq_exit(struct s5m87xx_dev *s5m87xx)
+{
+	if (s5m87xx->ono)
+		free_irq(s5m87xx->ono, s5m87xx);
+
+	if (s5m87xx->irq)
+		free_irq(s5m87xx->irq, s5m87xx);
+}
diff --git a/include/linux/mfd/s5m87xx/s5m-core.h b/include/linux/mfd/s5m87xx/s5m-core.h
deleted file mode 100644
index 0b2e0ed..0000000
--- a/include/linux/mfd/s5m87xx/s5m-core.h
+++ /dev/null
@@ -1,379 +0,0 @@
-/*
- * s5m-core.h
- *
- * Copyright (c) 2011 Samsung Electronics Co., Ltd
- *              http://www.samsung.com
- *
- *  This program is free software; you can redistribute  it and/or modify it
- *  under  the terms of  the GNU General  Public License as published by the
- *  Free Software Foundation;  either version 2 of the  License, or (at your
- *  option) any later version.
- *
- */
-
-#ifndef __LINUX_MFD_S5M_CORE_H
-#define __LINUX_MFD_S5M_CORE_H
-
-#define NUM_IRQ_REGS	4
-
-enum s5m_device_type {
-	S5M8751X,
-	S5M8763X,
-	S5M8767X,
-};
-
-/* S5M8767 registers */
-enum s5m8767_reg {
-	S5M8767_REG_ID,
-	S5M8767_REG_INT1,
-	S5M8767_REG_INT2,
-	S5M8767_REG_INT3,
-	S5M8767_REG_INT1M,
-	S5M8767_REG_INT2M,
-	S5M8767_REG_INT3M,
-	S5M8767_REG_STATUS1,
-	S5M8767_REG_STATUS2,
-	S5M8767_REG_STATUS3,
-	S5M8767_REG_CTRL1,
-	S5M8767_REG_CTRL2,
-	S5M8767_REG_LOWBAT1,
-	S5M8767_REG_LOWBAT2,
-	S5M8767_REG_BUCHG,
-	S5M8767_REG_DVSRAMP,
-	S5M8767_REG_DVSTIMER2 = 0x10,
-	S5M8767_REG_DVSTIMER3,
-	S5M8767_REG_DVSTIMER4,
-	S5M8767_REG_LDO1,
-	S5M8767_REG_LDO2,
-	S5M8767_REG_LDO3,
-	S5M8767_REG_LDO4,
-	S5M8767_REG_LDO5,
-	S5M8767_REG_LDO6,
-	S5M8767_REG_LDO7,
-	S5M8767_REG_LDO8,
-	S5M8767_REG_LDO9,
-	S5M8767_REG_LDO10,
-	S5M8767_REG_LDO11,
-	S5M8767_REG_LDO12,
-	S5M8767_REG_LDO13,
-	S5M8767_REG_LDO14 = 0x20,
-	S5M8767_REG_LDO15,
-	S5M8767_REG_LDO16,
-	S5M8767_REG_LDO17,
-	S5M8767_REG_LDO18,
-	S5M8767_REG_LDO19,
-	S5M8767_REG_LDO20,
-	S5M8767_REG_LDO21,
-	S5M8767_REG_LDO22,
-	S5M8767_REG_LDO23,
-	S5M8767_REG_LDO24,
-	S5M8767_REG_LDO25,
-	S5M8767_REG_LDO26,
-	S5M8767_REG_LDO27,
-	S5M8767_REG_LDO28,
-	S5M8767_REG_UVLO = 0x31,
-	S5M8767_REG_BUCK1CTRL1,
-	S5M8767_REG_BUCK1CTRL2,
-	S5M8767_REG_BUCK2CTRL,
-	S5M8767_REG_BUCK2DVS1,
-	S5M8767_REG_BUCK2DVS2,
-	S5M8767_REG_BUCK2DVS3,
-	S5M8767_REG_BUCK2DVS4,
-	S5M8767_REG_BUCK2DVS5,
-	S5M8767_REG_BUCK2DVS6,
-	S5M8767_REG_BUCK2DVS7,
-	S5M8767_REG_BUCK2DVS8,
-	S5M8767_REG_BUCK3CTRL,
-	S5M8767_REG_BUCK3DVS1,
-	S5M8767_REG_BUCK3DVS2,
-	S5M8767_REG_BUCK3DVS3,
-	S5M8767_REG_BUCK3DVS4,
-	S5M8767_REG_BUCK3DVS5,
-	S5M8767_REG_BUCK3DVS6,
-	S5M8767_REG_BUCK3DVS7,
-	S5M8767_REG_BUCK3DVS8,
-	S5M8767_REG_BUCK4CTRL,
-	S5M8767_REG_BUCK4DVS1,
-	S5M8767_REG_BUCK4DVS2,
-	S5M8767_REG_BUCK4DVS3,
-	S5M8767_REG_BUCK4DVS4,
-	S5M8767_REG_BUCK4DVS5,
-	S5M8767_REG_BUCK4DVS6,
-	S5M8767_REG_BUCK4DVS7,
-	S5M8767_REG_BUCK4DVS8,
-	S5M8767_REG_BUCK5CTRL1,
-	S5M8767_REG_BUCK5CTRL2,
-	S5M8767_REG_BUCK5CTRL3,
-	S5M8767_REG_BUCK5CTRL4,
-	S5M8767_REG_BUCK5CTRL5,
-	S5M8767_REG_BUCK6CTRL1,
-	S5M8767_REG_BUCK6CTRL2,
-	S5M8767_REG_BUCK7CTRL1,
-	S5M8767_REG_BUCK7CTRL2,
-	S5M8767_REG_BUCK8CTRL1,
-	S5M8767_REG_BUCK8CTRL2,
-	S5M8767_REG_BUCK9CTRL1,
-	S5M8767_REG_BUCK9CTRL2,
-	S5M8767_REG_LDO1CTRL,
-	S5M8767_REG_LDO2_1CTRL,
-	S5M8767_REG_LDO2_2CTRL,
-	S5M8767_REG_LDO2_3CTRL,
-	S5M8767_REG_LDO2_4CTRL,
-	S5M8767_REG_LDO3CTRL,
-	S5M8767_REG_LDO4CTRL,
-	S5M8767_REG_LDO5CTRL,
-	S5M8767_REG_LDO6CTRL,
-	S5M8767_REG_LDO7CTRL,
-	S5M8767_REG_LDO8CTRL,
-	S5M8767_REG_LDO9CTRL,
-	S5M8767_REG_LDO10CTRL,
-	S5M8767_REG_LDO11CTRL,
-	S5M8767_REG_LDO12CTRL,
-	S5M8767_REG_LDO13CTRL,
-	S5M8767_REG_LDO14CTRL,
-	S5M8767_REG_LDO15CTRL,
-	S5M8767_REG_LDO16CTRL,
-	S5M8767_REG_LDO17CTRL,
-	S5M8767_REG_LDO18CTRL,
-	S5M8767_REG_LDO19CTRL,
-	S5M8767_REG_LDO20CTRL,
-	S5M8767_REG_LDO21CTRL,
-	S5M8767_REG_LDO22CTRL,
-	S5M8767_REG_LDO23CTRL,
-	S5M8767_REG_LDO24CTRL,
-	S5M8767_REG_LDO25CTRL,
-	S5M8767_REG_LDO26CTRL,
-	S5M8767_REG_LDO27CTRL,
-	S5M8767_REG_LDO28CTRL,
-};
-
-/* S5M8763 registers */
-enum s5m8763_reg {
-	S5M8763_REG_IRQ1,
-	S5M8763_REG_IRQ2,
-	S5M8763_REG_IRQ3,
-	S5M8763_REG_IRQ4,
-	S5M8763_REG_IRQM1,
-	S5M8763_REG_IRQM2,
-	S5M8763_REG_IRQM3,
-	S5M8763_REG_IRQM4,
-	S5M8763_REG_STATUS1,
-	S5M8763_REG_STATUS2,
-	S5M8763_REG_STATUSM1,
-	S5M8763_REG_STATUSM2,
-	S5M8763_REG_CHGR1,
-	S5M8763_REG_CHGR2,
-	S5M8763_REG_LDO_ACTIVE_DISCHARGE1,
-	S5M8763_REG_LDO_ACTIVE_DISCHARGE2,
-	S5M8763_REG_BUCK_ACTIVE_DISCHARGE3,
-	S5M8763_REG_ONOFF1,
-	S5M8763_REG_ONOFF2,
-	S5M8763_REG_ONOFF3,
-	S5M8763_REG_ONOFF4,
-	S5M8763_REG_BUCK1_VOLTAGE1,
-	S5M8763_REG_BUCK1_VOLTAGE2,
-	S5M8763_REG_BUCK1_VOLTAGE3,
-	S5M8763_REG_BUCK1_VOLTAGE4,
-	S5M8763_REG_BUCK2_VOLTAGE1,
-	S5M8763_REG_BUCK2_VOLTAGE2,
-	S5M8763_REG_BUCK3,
-	S5M8763_REG_BUCK4,
-	S5M8763_REG_LDO1_LDO2,
-	S5M8763_REG_LDO3,
-	S5M8763_REG_LDO4,
-	S5M8763_REG_LDO5,
-	S5M8763_REG_LDO6,
-	S5M8763_REG_LDO7,
-	S5M8763_REG_LDO7_LDO8,
-	S5M8763_REG_LDO9_LDO10,
-	S5M8763_REG_LDO11,
-	S5M8763_REG_LDO12,
-	S5M8763_REG_LDO13,
-	S5M8763_REG_LDO14,
-	S5M8763_REG_LDO15,
-	S5M8763_REG_LDO16,
-	S5M8763_REG_BKCHR,
-	S5M8763_REG_LBCNFG1,
-	S5M8763_REG_LBCNFG2,
-};
-
-enum s5m8767_irq {
-	S5M8767_IRQ_PWRR,
-	S5M8767_IRQ_PWRF,
-	S5M8767_IRQ_PWR1S,
-	S5M8767_IRQ_JIGR,
-	S5M8767_IRQ_JIGF,
-	S5M8767_IRQ_LOWBAT2,
-	S5M8767_IRQ_LOWBAT1,
-
-	S5M8767_IRQ_MRB,
-	S5M8767_IRQ_DVSOK2,
-	S5M8767_IRQ_DVSOK3,
-	S5M8767_IRQ_DVSOK4,
-
-	S5M8767_IRQ_RTC60S,
-	S5M8767_IRQ_RTCA1,
-	S5M8767_IRQ_RTCA2,
-	S5M8767_IRQ_SMPL,
-	S5M8767_IRQ_RTC1S,
-	S5M8767_IRQ_WTSR,
-
-	S5M8767_IRQ_NR,
-};
-
-#define S5M8767_IRQ_PWRR_MASK		(1 << 0)
-#define S5M8767_IRQ_PWRF_MASK		(1 << 1)
-#define S5M8767_IRQ_PWR1S_MASK		(1 << 3)
-#define S5M8767_IRQ_JIGR_MASK		(1 << 4)
-#define S5M8767_IRQ_JIGF_MASK		(1 << 5)
-#define S5M8767_IRQ_LOWBAT2_MASK	(1 << 6)
-#define S5M8767_IRQ_LOWBAT1_MASK	(1 << 7)
-
-#define S5M8767_IRQ_MRB_MASK		(1 << 2)
-#define S5M8767_IRQ_DVSOK2_MASK		(1 << 3)
-#define S5M8767_IRQ_DVSOK3_MASK		(1 << 4)
-#define S5M8767_IRQ_DVSOK4_MASK		(1 << 5)
-
-#define S5M8767_IRQ_RTC60S_MASK		(1 << 0)
-#define S5M8767_IRQ_RTCA1_MASK		(1 << 1)
-#define S5M8767_IRQ_RTCA2_MASK		(1 << 2)
-#define S5M8767_IRQ_SMPL_MASK		(1 << 3)
-#define S5M8767_IRQ_RTC1S_MASK		(1 << 4)
-#define S5M8767_IRQ_WTSR_MASK		(1 << 5)
-
-enum s5m8763_irq {
-	S5M8763_IRQ_DCINF,
-	S5M8763_IRQ_DCINR,
-	S5M8763_IRQ_JIGF,
-	S5M8763_IRQ_JIGR,
-	S5M8763_IRQ_PWRONF,
-	S5M8763_IRQ_PWRONR,
-
-	S5M8763_IRQ_WTSREVNT,
-	S5M8763_IRQ_SMPLEVNT,
-	S5M8763_IRQ_ALARM1,
-	S5M8763_IRQ_ALARM0,
-
-	S5M8763_IRQ_ONKEY1S,
-	S5M8763_IRQ_TOPOFFR,
-	S5M8763_IRQ_DCINOVPR,
-	S5M8763_IRQ_CHGRSTF,
-	S5M8763_IRQ_DONER,
-	S5M8763_IRQ_CHGFAULT,
-
-	S5M8763_IRQ_LOBAT1,
-	S5M8763_IRQ_LOBAT2,
-
-	S5M8763_IRQ_NR,
-};
-
-#define S5M8763_IRQ_DCINF_MASK		(1 << 2)
-#define S5M8763_IRQ_DCINR_MASK		(1 << 3)
-#define S5M8763_IRQ_JIGF_MASK		(1 << 4)
-#define S5M8763_IRQ_JIGR_MASK		(1 << 5)
-#define S5M8763_IRQ_PWRONF_MASK		(1 << 6)
-#define S5M8763_IRQ_PWRONR_MASK		(1 << 7)
-
-#define S5M8763_IRQ_WTSREVNT_MASK	(1 << 0)
-#define S5M8763_IRQ_SMPLEVNT_MASK	(1 << 1)
-#define S5M8763_IRQ_ALARM1_MASK		(1 << 2)
-#define S5M8763_IRQ_ALARM0_MASK		(1 << 3)
-
-#define S5M8763_IRQ_ONKEY1S_MASK	(1 << 0)
-#define S5M8763_IRQ_TOPOFFR_MASK	(1 << 2)
-#define S5M8763_IRQ_DCINOVPR_MASK	(1 << 3)
-#define S5M8763_IRQ_CHGRSTF_MASK	(1 << 4)
-#define S5M8763_IRQ_DONER_MASK		(1 << 5)
-#define S5M8763_IRQ_CHGFAULT_MASK	(1 << 7)
-
-#define S5M8763_IRQ_LOBAT1_MASK		(1 << 0)
-#define S5M8763_IRQ_LOBAT2_MASK		(1 << 1)
-
-#define S5M8763_ENRAMP                  (1 << 4)
-
-/**
- * struct s5m87xx_dev - s5m87xx master device for sub-drivers
- * @dev: master device of the chip (can be used to access platform data)
- * @i2c: i2c client private data for regulator
- * @rtc: i2c client private data for rtc
- * @iolock: mutex for serializing io access
- * @irqlock: mutex for buslock
- * @irq_base: base IRQ number for s5m87xx, required for IRQs
- * @irq: generic IRQ number for s5m87xx
- * @ono: power onoff IRQ number for s5m87xx
- * @irq_masks_cur: currently active value
- * @irq_masks_cache: cached hardware value
- * @type: indicate which s5m87xx "variant" is used
- */
-struct s5m87xx_dev {
-	struct device *dev;
-	struct regmap *regmap;
-	struct i2c_client *i2c;
-	struct i2c_client *rtc;
-	struct mutex iolock;
-	struct mutex irqlock;
-
-	int device_type;
-	int irq_base;
-	int irq;
-	int ono;
-	u8 irq_masks_cur[NUM_IRQ_REGS];
-	u8 irq_masks_cache[NUM_IRQ_REGS];
-	int type;
-	bool wakeup;
-};
-
-int s5m_irq_init(struct s5m87xx_dev *s5m87xx);
-void s5m_irq_exit(struct s5m87xx_dev *s5m87xx);
-int s5m_irq_resume(struct s5m87xx_dev *s5m87xx);
-
-extern int s5m_reg_read(struct s5m87xx_dev *s5m87xx, u8 reg, void *dest);
-extern int s5m_bulk_read(struct s5m87xx_dev *s5m87xx, u8 reg, int count, u8 *buf);
-extern int s5m_reg_write(struct s5m87xx_dev *s5m87xx, u8 reg, u8 value);
-extern int s5m_bulk_write(struct s5m87xx_dev *s5m87xx, u8 reg, int count, u8 *buf);
-extern int s5m_reg_update(struct s5m87xx_dev *s5m87xx, u8 reg, u8 val, u8 mask);
-
-struct s5m_platform_data {
-	struct s5m_regulator_data	*regulators;
-	struct s5m_opmode_data		*opmode;
-	int				device_type;
-	int				num_regulators;
-
-	int				irq_base;
-	int 				(*cfg_pmic_irq)(void);
-
-	int				ono;
-	bool				wakeup;
-	bool				buck_voltage_lock;
-
-	int				buck_gpios[3];
-	int				buck_ds[3];
-	int				buck2_voltage[8];
-	bool				buck2_gpiodvs;
-	int				buck3_voltage[8];
-	bool				buck3_gpiodvs;
-	int				buck4_voltage[8];
-	bool				buck4_gpiodvs;
-
-	int				buck_set1;
-	int				buck_set2;
-	int				buck_set3;
-	int				buck2_enable;
-	int				buck3_enable;
-	int				buck4_enable;
-	int				buck_default_idx;
-	int				buck2_default_idx;
-	int				buck3_default_idx;
-	int				buck4_default_idx;
-
-	int                             buck_ramp_delay;
-	bool                            buck2_ramp_enable;
-	bool                            buck3_ramp_enable;
-	bool                            buck4_ramp_enable;
-
-	int				buck2_init;
-	int				buck3_init;
-	int				buck4_init;
-};
-
-#endif /*  __LINUX_MFD_S5M_CORE_H */
diff --git a/include/linux/mfd/s5m87xx/s5m-pmic.h b/include/linux/mfd/s5m87xx/s5m-pmic.h
deleted file mode 100644
index 7c719f2..0000000
--- a/include/linux/mfd/s5m87xx/s5m-pmic.h
+++ /dev/null
@@ -1,129 +0,0 @@
-/* s5m87xx.h
- *
- * Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
- *		http://www.samsung.com
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
-*/
-
-#ifndef __LINUX_MFD_S5M_PMIC_H
-#define __LINUX_MFD_S5M_PMIC_H
-
-#include <linux/regulator/machine.h>
-
-/* S5M8767 regulator ids */
-enum s5m8767_regulators {
-	S5M8767_LDO1,
-	S5M8767_LDO2,
-	S5M8767_LDO3,
-	S5M8767_LDO4,
-	S5M8767_LDO5,
-	S5M8767_LDO6,
-	S5M8767_LDO7,
-	S5M8767_LDO8,
-	S5M8767_LDO9,
-	S5M8767_LDO10,
-	S5M8767_LDO11,
-	S5M8767_LDO12,
-	S5M8767_LDO13,
-	S5M8767_LDO14,
-	S5M8767_LDO15,
-	S5M8767_LDO16,
-	S5M8767_LDO17,
-	S5M8767_LDO18,
-	S5M8767_LDO19,
-	S5M8767_LDO20,
-	S5M8767_LDO21,
-	S5M8767_LDO22,
-	S5M8767_LDO23,
-	S5M8767_LDO24,
-	S5M8767_LDO25,
-	S5M8767_LDO26,
-	S5M8767_LDO27,
-	S5M8767_LDO28,
-	S5M8767_BUCK1,
-	S5M8767_BUCK2,
-	S5M8767_BUCK3,
-	S5M8767_BUCK4,
-	S5M8767_BUCK5,
-	S5M8767_BUCK6,
-	S5M8767_BUCK7,
-	S5M8767_BUCK8,
-	S5M8767_BUCK9,
-	S5M8767_AP_EN32KHZ,
-	S5M8767_CP_EN32KHZ,
-
-	S5M8767_REG_MAX,
-};
-
-#define S5M8767_ENCTRL_SHIFT  6
-
-/* S5M8763 regulator ids */
-enum s5m8763_regulators {
-	S5M8763_LDO1,
-	S5M8763_LDO2,
-	S5M8763_LDO3,
-	S5M8763_LDO4,
-	S5M8763_LDO5,
-	S5M8763_LDO6,
-	S5M8763_LDO7,
-	S5M8763_LDO8,
-	S5M8763_LDO9,
-	S5M8763_LDO10,
-	S5M8763_LDO11,
-	S5M8763_LDO12,
-	S5M8763_LDO13,
-	S5M8763_LDO14,
-	S5M8763_LDO15,
-	S5M8763_LDO16,
-	S5M8763_BUCK1,
-	S5M8763_BUCK2,
-	S5M8763_BUCK3,
-	S5M8763_BUCK4,
-	S5M8763_AP_EN32KHZ,
-	S5M8763_CP_EN32KHZ,
-	S5M8763_ENCHGVI,
-	S5M8763_ESAFEUSB1,
-	S5M8763_ESAFEUSB2,
-};
-
-/**
- * s5m87xx_regulator_data - regulator data
- * @id: regulator id
- * @initdata: regulator init data (contraints, supplies, ...)
- */
-struct s5m_regulator_data {
-	int				id;
-	struct regulator_init_data	*initdata;
-};
-
-/*
- * s5m_opmode_data - regulator operation mode data
- * @id: regulator id
- * @mode: regulator operation mode
- */
-struct s5m_opmode_data {
-	int id;
-	int mode;
-};
-
-/*
- * s5m regulator operation mode
- * S5M_OPMODE_OFF	Regulator always OFF
- * S5M_OPMODE_ON	Regulator always ON
- * S5M_OPMODE_LOWPOWER  Regulator is on in low-power mode
- * S5M_OPMODE_SUSPEND   Regulator is changed by PWREN pin
- *			If PWREN is high, regulator is on
- *			If PWREN is low, regulator is off
- */
-
-enum s5m_opmode {
-	S5M_OPMODE_OFF,
-	S5M_OPMODE_ON,
-	S5M_OPMODE_LOWPOWER,
-	S5M_OPMODE_SUSPEND,
-};
-
-#endif /*  __LINUX_MFD_S5M_PMIC_H */
diff --git a/include/linux/mfd/s5m87xx/s5m-rtc.h b/include/linux/mfd/s5m87xx/s5m-rtc.h
deleted file mode 100644
index 6ce8da2..0000000
--- a/include/linux/mfd/s5m87xx/s5m-rtc.h
+++ /dev/null
@@ -1,84 +0,0 @@
-/*
- * s5m-rtc.h
- *
- * Copyright (c) 2011 Samsung Electronics Co., Ltd
- *              http://www.samsung.com
- *
- *  This program is free software; you can redistribute  it and/or modify it
- *  under  the terms of  the GNU General  Public License as published by the
- *  Free Software Foundation;  either version 2 of the  License, or (at your
- *  option) any later version.
- *
- */
-
-#ifndef __LINUX_MFD_S5M_RTC_H
-#define __LINUX_MFD_S5M_RTC_H
-
-enum s5m87xx_rtc_reg {
-	S5M87XX_RTC_SEC,
-	S5M87XX_RTC_MIN,
-	S5M87XX_RTC_HOUR,
-	S5M87XX_RTC_WEEKDAY,
-	S5M87XX_RTC_DATE,
-	S5M87XX_RTC_MONTH,
-	S5M87XX_RTC_YEAR1,
-	S5M87XX_RTC_YEAR2,
-	S5M87XX_ALARM0_SEC,
-	S5M87XX_ALARM0_MIN,
-	S5M87XX_ALARM0_HOUR,
-	S5M87XX_ALARM0_WEEKDAY,
-	S5M87XX_ALARM0_DATE,
-	S5M87XX_ALARM0_MONTH,
-	S5M87XX_ALARM0_YEAR1,
-	S5M87XX_ALARM0_YEAR2,
-	S5M87XX_ALARM1_SEC,
-	S5M87XX_ALARM1_MIN,
-	S5M87XX_ALARM1_HOUR,
-	S5M87XX_ALARM1_WEEKDAY,
-	S5M87XX_ALARM1_DATE,
-	S5M87XX_ALARM1_MONTH,
-	S5M87XX_ALARM1_YEAR1,
-	S5M87XX_ALARM1_YEAR2,
-	S5M87XX_ALARM0_CONF,
-	S5M87XX_ALARM1_CONF,
-	S5M87XX_RTC_STATUS,
-	S5M87XX_WTSR_SMPL_CNTL,
-	S5M87XX_RTC_UDR_CON,
-};
-
-#define RTC_I2C_ADDR		(0x0C >> 1)
-
-#define HOUR_12			(1 << 7)
-#define HOUR_AMPM		(1 << 6)
-#define HOUR_PM			(1 << 5)
-#define ALARM0_STATUS		(1 << 1)
-#define ALARM1_STATUS		(1 << 2)
-#define UPDATE_AD		(1 << 0)
-
-/* RTC Control Register */
-#define BCD_EN_SHIFT		0
-#define BCD_EN_MASK		(1 << BCD_EN_SHIFT)
-#define MODEL24_SHIFT		1
-#define MODEL24_MASK		(1 << MODEL24_SHIFT)
-/* RTC Update Register1 */
-#define RTC_UDR_SHIFT		0
-#define RTC_UDR_MASK		(1 << RTC_UDR_SHIFT)
-/* RTC Hour register */
-#define HOUR_PM_SHIFT		6
-#define HOUR_PM_MASK		(1 << HOUR_PM_SHIFT)
-/* RTC Alarm Enable */
-#define ALARM_ENABLE_SHIFT	7
-#define ALARM_ENABLE_MASK	(1 << ALARM_ENABLE_SHIFT)
-
-enum {
-	RTC_SEC = 0,
-	RTC_MIN,
-	RTC_HOUR,
-	RTC_WEEKDAY,
-	RTC_DATE,
-	RTC_MONTH,
-	RTC_YEAR1,
-	RTC_YEAR2,
-};
-
-#endif /*  __LINUX_MFD_S5M_RTC_H */
diff --git a/include/linux/mfd/samsung/s5m-core.h b/include/linux/mfd/samsung/s5m-core.h
new file mode 100644
index 0000000..0b2e0ed
--- /dev/null
+++ b/include/linux/mfd/samsung/s5m-core.h
@@ -0,0 +1,379 @@
+/*
+ * s5m-core.h
+ *
+ * Copyright (c) 2011 Samsung Electronics Co., Ltd
+ *              http://www.samsung.com
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ *
+ */
+
+#ifndef __LINUX_MFD_S5M_CORE_H
+#define __LINUX_MFD_S5M_CORE_H
+
+#define NUM_IRQ_REGS	4
+
+enum s5m_device_type {
+	S5M8751X,
+	S5M8763X,
+	S5M8767X,
+};
+
+/* S5M8767 registers */
+enum s5m8767_reg {
+	S5M8767_REG_ID,
+	S5M8767_REG_INT1,
+	S5M8767_REG_INT2,
+	S5M8767_REG_INT3,
+	S5M8767_REG_INT1M,
+	S5M8767_REG_INT2M,
+	S5M8767_REG_INT3M,
+	S5M8767_REG_STATUS1,
+	S5M8767_REG_STATUS2,
+	S5M8767_REG_STATUS3,
+	S5M8767_REG_CTRL1,
+	S5M8767_REG_CTRL2,
+	S5M8767_REG_LOWBAT1,
+	S5M8767_REG_LOWBAT2,
+	S5M8767_REG_BUCHG,
+	S5M8767_REG_DVSRAMP,
+	S5M8767_REG_DVSTIMER2 = 0x10,
+	S5M8767_REG_DVSTIMER3,
+	S5M8767_REG_DVSTIMER4,
+	S5M8767_REG_LDO1,
+	S5M8767_REG_LDO2,
+	S5M8767_REG_LDO3,
+	S5M8767_REG_LDO4,
+	S5M8767_REG_LDO5,
+	S5M8767_REG_LDO6,
+	S5M8767_REG_LDO7,
+	S5M8767_REG_LDO8,
+	S5M8767_REG_LDO9,
+	S5M8767_REG_LDO10,
+	S5M8767_REG_LDO11,
+	S5M8767_REG_LDO12,
+	S5M8767_REG_LDO13,
+	S5M8767_REG_LDO14 = 0x20,
+	S5M8767_REG_LDO15,
+	S5M8767_REG_LDO16,
+	S5M8767_REG_LDO17,
+	S5M8767_REG_LDO18,
+	S5M8767_REG_LDO19,
+	S5M8767_REG_LDO20,
+	S5M8767_REG_LDO21,
+	S5M8767_REG_LDO22,
+	S5M8767_REG_LDO23,
+	S5M8767_REG_LDO24,
+	S5M8767_REG_LDO25,
+	S5M8767_REG_LDO26,
+	S5M8767_REG_LDO27,
+	S5M8767_REG_LDO28,
+	S5M8767_REG_UVLO = 0x31,
+	S5M8767_REG_BUCK1CTRL1,
+	S5M8767_REG_BUCK1CTRL2,
+	S5M8767_REG_BUCK2CTRL,
+	S5M8767_REG_BUCK2DVS1,
+	S5M8767_REG_BUCK2DVS2,
+	S5M8767_REG_BUCK2DVS3,
+	S5M8767_REG_BUCK2DVS4,
+	S5M8767_REG_BUCK2DVS5,
+	S5M8767_REG_BUCK2DVS6,
+	S5M8767_REG_BUCK2DVS7,
+	S5M8767_REG_BUCK2DVS8,
+	S5M8767_REG_BUCK3CTRL,
+	S5M8767_REG_BUCK3DVS1,
+	S5M8767_REG_BUCK3DVS2,
+	S5M8767_REG_BUCK3DVS3,
+	S5M8767_REG_BUCK3DVS4,
+	S5M8767_REG_BUCK3DVS5,
+	S5M8767_REG_BUCK3DVS6,
+	S5M8767_REG_BUCK3DVS7,
+	S5M8767_REG_BUCK3DVS8,
+	S5M8767_REG_BUCK4CTRL,
+	S5M8767_REG_BUCK4DVS1,
+	S5M8767_REG_BUCK4DVS2,
+	S5M8767_REG_BUCK4DVS3,
+	S5M8767_REG_BUCK4DVS4,
+	S5M8767_REG_BUCK4DVS5,
+	S5M8767_REG_BUCK4DVS6,
+	S5M8767_REG_BUCK4DVS7,
+	S5M8767_REG_BUCK4DVS8,
+	S5M8767_REG_BUCK5CTRL1,
+	S5M8767_REG_BUCK5CTRL2,
+	S5M8767_REG_BUCK5CTRL3,
+	S5M8767_REG_BUCK5CTRL4,
+	S5M8767_REG_BUCK5CTRL5,
+	S5M8767_REG_BUCK6CTRL1,
+	S5M8767_REG_BUCK6CTRL2,
+	S5M8767_REG_BUCK7CTRL1,
+	S5M8767_REG_BUCK7CTRL2,
+	S5M8767_REG_BUCK8CTRL1,
+	S5M8767_REG_BUCK8CTRL2,
+	S5M8767_REG_BUCK9CTRL1,
+	S5M8767_REG_BUCK9CTRL2,
+	S5M8767_REG_LDO1CTRL,
+	S5M8767_REG_LDO2_1CTRL,
+	S5M8767_REG_LDO2_2CTRL,
+	S5M8767_REG_LDO2_3CTRL,
+	S5M8767_REG_LDO2_4CTRL,
+	S5M8767_REG_LDO3CTRL,
+	S5M8767_REG_LDO4CTRL,
+	S5M8767_REG_LDO5CTRL,
+	S5M8767_REG_LDO6CTRL,
+	S5M8767_REG_LDO7CTRL,
+	S5M8767_REG_LDO8CTRL,
+	S5M8767_REG_LDO9CTRL,
+	S5M8767_REG_LDO10CTRL,
+	S5M8767_REG_LDO11CTRL,
+	S5M8767_REG_LDO12CTRL,
+	S5M8767_REG_LDO13CTRL,
+	S5M8767_REG_LDO14CTRL,
+	S5M8767_REG_LDO15CTRL,
+	S5M8767_REG_LDO16CTRL,
+	S5M8767_REG_LDO17CTRL,
+	S5M8767_REG_LDO18CTRL,
+	S5M8767_REG_LDO19CTRL,
+	S5M8767_REG_LDO20CTRL,
+	S5M8767_REG_LDO21CTRL,
+	S5M8767_REG_LDO22CTRL,
+	S5M8767_REG_LDO23CTRL,
+	S5M8767_REG_LDO24CTRL,
+	S5M8767_REG_LDO25CTRL,
+	S5M8767_REG_LDO26CTRL,
+	S5M8767_REG_LDO27CTRL,
+	S5M8767_REG_LDO28CTRL,
+};
+
+/* S5M8763 registers */
+enum s5m8763_reg {
+	S5M8763_REG_IRQ1,
+	S5M8763_REG_IRQ2,
+	S5M8763_REG_IRQ3,
+	S5M8763_REG_IRQ4,
+	S5M8763_REG_IRQM1,
+	S5M8763_REG_IRQM2,
+	S5M8763_REG_IRQM3,
+	S5M8763_REG_IRQM4,
+	S5M8763_REG_STATUS1,
+	S5M8763_REG_STATUS2,
+	S5M8763_REG_STATUSM1,
+	S5M8763_REG_STATUSM2,
+	S5M8763_REG_CHGR1,
+	S5M8763_REG_CHGR2,
+	S5M8763_REG_LDO_ACTIVE_DISCHARGE1,
+	S5M8763_REG_LDO_ACTIVE_DISCHARGE2,
+	S5M8763_REG_BUCK_ACTIVE_DISCHARGE3,
+	S5M8763_REG_ONOFF1,
+	S5M8763_REG_ONOFF2,
+	S5M8763_REG_ONOFF3,
+	S5M8763_REG_ONOFF4,
+	S5M8763_REG_BUCK1_VOLTAGE1,
+	S5M8763_REG_BUCK1_VOLTAGE2,
+	S5M8763_REG_BUCK1_VOLTAGE3,
+	S5M8763_REG_BUCK1_VOLTAGE4,
+	S5M8763_REG_BUCK2_VOLTAGE1,
+	S5M8763_REG_BUCK2_VOLTAGE2,
+	S5M8763_REG_BUCK3,
+	S5M8763_REG_BUCK4,
+	S5M8763_REG_LDO1_LDO2,
+	S5M8763_REG_LDO3,
+	S5M8763_REG_LDO4,
+	S5M8763_REG_LDO5,
+	S5M8763_REG_LDO6,
+	S5M8763_REG_LDO7,
+	S5M8763_REG_LDO7_LDO8,
+	S5M8763_REG_LDO9_LDO10,
+	S5M8763_REG_LDO11,
+	S5M8763_REG_LDO12,
+	S5M8763_REG_LDO13,
+	S5M8763_REG_LDO14,
+	S5M8763_REG_LDO15,
+	S5M8763_REG_LDO16,
+	S5M8763_REG_BKCHR,
+	S5M8763_REG_LBCNFG1,
+	S5M8763_REG_LBCNFG2,
+};
+
+enum s5m8767_irq {
+	S5M8767_IRQ_PWRR,
+	S5M8767_IRQ_PWRF,
+	S5M8767_IRQ_PWR1S,
+	S5M8767_IRQ_JIGR,
+	S5M8767_IRQ_JIGF,
+	S5M8767_IRQ_LOWBAT2,
+	S5M8767_IRQ_LOWBAT1,
+
+	S5M8767_IRQ_MRB,
+	S5M8767_IRQ_DVSOK2,
+	S5M8767_IRQ_DVSOK3,
+	S5M8767_IRQ_DVSOK4,
+
+	S5M8767_IRQ_RTC60S,
+	S5M8767_IRQ_RTCA1,
+	S5M8767_IRQ_RTCA2,
+	S5M8767_IRQ_SMPL,
+	S5M8767_IRQ_RTC1S,
+	S5M8767_IRQ_WTSR,
+
+	S5M8767_IRQ_NR,
+};
+
+#define S5M8767_IRQ_PWRR_MASK		(1 << 0)
+#define S5M8767_IRQ_PWRF_MASK		(1 << 1)
+#define S5M8767_IRQ_PWR1S_MASK		(1 << 3)
+#define S5M8767_IRQ_JIGR_MASK		(1 << 4)
+#define S5M8767_IRQ_JIGF_MASK		(1 << 5)
+#define S5M8767_IRQ_LOWBAT2_MASK	(1 << 6)
+#define S5M8767_IRQ_LOWBAT1_MASK	(1 << 7)
+
+#define S5M8767_IRQ_MRB_MASK		(1 << 2)
+#define S5M8767_IRQ_DVSOK2_MASK		(1 << 3)
+#define S5M8767_IRQ_DVSOK3_MASK		(1 << 4)
+#define S5M8767_IRQ_DVSOK4_MASK		(1 << 5)
+
+#define S5M8767_IRQ_RTC60S_MASK		(1 << 0)
+#define S5M8767_IRQ_RTCA1_MASK		(1 << 1)
+#define S5M8767_IRQ_RTCA2_MASK		(1 << 2)
+#define S5M8767_IRQ_SMPL_MASK		(1 << 3)
+#define S5M8767_IRQ_RTC1S_MASK		(1 << 4)
+#define S5M8767_IRQ_WTSR_MASK		(1 << 5)
+
+enum s5m8763_irq {
+	S5M8763_IRQ_DCINF,
+	S5M8763_IRQ_DCINR,
+	S5M8763_IRQ_JIGF,
+	S5M8763_IRQ_JIGR,
+	S5M8763_IRQ_PWRONF,
+	S5M8763_IRQ_PWRONR,
+
+	S5M8763_IRQ_WTSREVNT,
+	S5M8763_IRQ_SMPLEVNT,
+	S5M8763_IRQ_ALARM1,
+	S5M8763_IRQ_ALARM0,
+
+	S5M8763_IRQ_ONKEY1S,
+	S5M8763_IRQ_TOPOFFR,
+	S5M8763_IRQ_DCINOVPR,
+	S5M8763_IRQ_CHGRSTF,
+	S5M8763_IRQ_DONER,
+	S5M8763_IRQ_CHGFAULT,
+
+	S5M8763_IRQ_LOBAT1,
+	S5M8763_IRQ_LOBAT2,
+
+	S5M8763_IRQ_NR,
+};
+
+#define S5M8763_IRQ_DCINF_MASK		(1 << 2)
+#define S5M8763_IRQ_DCINR_MASK		(1 << 3)
+#define S5M8763_IRQ_JIGF_MASK		(1 << 4)
+#define S5M8763_IRQ_JIGR_MASK		(1 << 5)
+#define S5M8763_IRQ_PWRONF_MASK		(1 << 6)
+#define S5M8763_IRQ_PWRONR_MASK		(1 << 7)
+
+#define S5M8763_IRQ_WTSREVNT_MASK	(1 << 0)
+#define S5M8763_IRQ_SMPLEVNT_MASK	(1 << 1)
+#define S5M8763_IRQ_ALARM1_MASK		(1 << 2)
+#define S5M8763_IRQ_ALARM0_MASK		(1 << 3)
+
+#define S5M8763_IRQ_ONKEY1S_MASK	(1 << 0)
+#define S5M8763_IRQ_TOPOFFR_MASK	(1 << 2)
+#define S5M8763_IRQ_DCINOVPR_MASK	(1 << 3)
+#define S5M8763_IRQ_CHGRSTF_MASK	(1 << 4)
+#define S5M8763_IRQ_DONER_MASK		(1 << 5)
+#define S5M8763_IRQ_CHGFAULT_MASK	(1 << 7)
+
+#define S5M8763_IRQ_LOBAT1_MASK		(1 << 0)
+#define S5M8763_IRQ_LOBAT2_MASK		(1 << 1)
+
+#define S5M8763_ENRAMP                  (1 << 4)
+
+/**
+ * struct s5m87xx_dev - s5m87xx master device for sub-drivers
+ * @dev: master device of the chip (can be used to access platform data)
+ * @i2c: i2c client private data for regulator
+ * @rtc: i2c client private data for rtc
+ * @iolock: mutex for serializing io access
+ * @irqlock: mutex for buslock
+ * @irq_base: base IRQ number for s5m87xx, required for IRQs
+ * @irq: generic IRQ number for s5m87xx
+ * @ono: power onoff IRQ number for s5m87xx
+ * @irq_masks_cur: currently active value
+ * @irq_masks_cache: cached hardware value
+ * @type: indicate which s5m87xx "variant" is used
+ */
+struct s5m87xx_dev {
+	struct device *dev;
+	struct regmap *regmap;
+	struct i2c_client *i2c;
+	struct i2c_client *rtc;
+	struct mutex iolock;
+	struct mutex irqlock;
+
+	int device_type;
+	int irq_base;
+	int irq;
+	int ono;
+	u8 irq_masks_cur[NUM_IRQ_REGS];
+	u8 irq_masks_cache[NUM_IRQ_REGS];
+	int type;
+	bool wakeup;
+};
+
+int s5m_irq_init(struct s5m87xx_dev *s5m87xx);
+void s5m_irq_exit(struct s5m87xx_dev *s5m87xx);
+int s5m_irq_resume(struct s5m87xx_dev *s5m87xx);
+
+extern int s5m_reg_read(struct s5m87xx_dev *s5m87xx, u8 reg, void *dest);
+extern int s5m_bulk_read(struct s5m87xx_dev *s5m87xx, u8 reg, int count, u8 *buf);
+extern int s5m_reg_write(struct s5m87xx_dev *s5m87xx, u8 reg, u8 value);
+extern int s5m_bulk_write(struct s5m87xx_dev *s5m87xx, u8 reg, int count, u8 *buf);
+extern int s5m_reg_update(struct s5m87xx_dev *s5m87xx, u8 reg, u8 val, u8 mask);
+
+struct s5m_platform_data {
+	struct s5m_regulator_data	*regulators;
+	struct s5m_opmode_data		*opmode;
+	int				device_type;
+	int				num_regulators;
+
+	int				irq_base;
+	int 				(*cfg_pmic_irq)(void);
+
+	int				ono;
+	bool				wakeup;
+	bool				buck_voltage_lock;
+
+	int				buck_gpios[3];
+	int				buck_ds[3];
+	int				buck2_voltage[8];
+	bool				buck2_gpiodvs;
+	int				buck3_voltage[8];
+	bool				buck3_gpiodvs;
+	int				buck4_voltage[8];
+	bool				buck4_gpiodvs;
+
+	int				buck_set1;
+	int				buck_set2;
+	int				buck_set3;
+	int				buck2_enable;
+	int				buck3_enable;
+	int				buck4_enable;
+	int				buck_default_idx;
+	int				buck2_default_idx;
+	int				buck3_default_idx;
+	int				buck4_default_idx;
+
+	int                             buck_ramp_delay;
+	bool                            buck2_ramp_enable;
+	bool                            buck3_ramp_enable;
+	bool                            buck4_ramp_enable;
+
+	int				buck2_init;
+	int				buck3_init;
+	int				buck4_init;
+};
+
+#endif /*  __LINUX_MFD_S5M_CORE_H */
diff --git a/include/linux/mfd/samsung/s5m-pmic.h b/include/linux/mfd/samsung/s5m-pmic.h
new file mode 100644
index 0000000..7c719f2
--- /dev/null
+++ b/include/linux/mfd/samsung/s5m-pmic.h
@@ -0,0 +1,129 @@
+/* s5m87xx.h
+ *
+ * Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+#ifndef __LINUX_MFD_S5M_PMIC_H
+#define __LINUX_MFD_S5M_PMIC_H
+
+#include <linux/regulator/machine.h>
+
+/* S5M8767 regulator ids */
+enum s5m8767_regulators {
+	S5M8767_LDO1,
+	S5M8767_LDO2,
+	S5M8767_LDO3,
+	S5M8767_LDO4,
+	S5M8767_LDO5,
+	S5M8767_LDO6,
+	S5M8767_LDO7,
+	S5M8767_LDO8,
+	S5M8767_LDO9,
+	S5M8767_LDO10,
+	S5M8767_LDO11,
+	S5M8767_LDO12,
+	S5M8767_LDO13,
+	S5M8767_LDO14,
+	S5M8767_LDO15,
+	S5M8767_LDO16,
+	S5M8767_LDO17,
+	S5M8767_LDO18,
+	S5M8767_LDO19,
+	S5M8767_LDO20,
+	S5M8767_LDO21,
+	S5M8767_LDO22,
+	S5M8767_LDO23,
+	S5M8767_LDO24,
+	S5M8767_LDO25,
+	S5M8767_LDO26,
+	S5M8767_LDO27,
+	S5M8767_LDO28,
+	S5M8767_BUCK1,
+	S5M8767_BUCK2,
+	S5M8767_BUCK3,
+	S5M8767_BUCK4,
+	S5M8767_BUCK5,
+	S5M8767_BUCK6,
+	S5M8767_BUCK7,
+	S5M8767_BUCK8,
+	S5M8767_BUCK9,
+	S5M8767_AP_EN32KHZ,
+	S5M8767_CP_EN32KHZ,
+
+	S5M8767_REG_MAX,
+};
+
+#define S5M8767_ENCTRL_SHIFT  6
+
+/* S5M8763 regulator ids */
+enum s5m8763_regulators {
+	S5M8763_LDO1,
+	S5M8763_LDO2,
+	S5M8763_LDO3,
+	S5M8763_LDO4,
+	S5M8763_LDO5,
+	S5M8763_LDO6,
+	S5M8763_LDO7,
+	S5M8763_LDO8,
+	S5M8763_LDO9,
+	S5M8763_LDO10,
+	S5M8763_LDO11,
+	S5M8763_LDO12,
+	S5M8763_LDO13,
+	S5M8763_LDO14,
+	S5M8763_LDO15,
+	S5M8763_LDO16,
+	S5M8763_BUCK1,
+	S5M8763_BUCK2,
+	S5M8763_BUCK3,
+	S5M8763_BUCK4,
+	S5M8763_AP_EN32KHZ,
+	S5M8763_CP_EN32KHZ,
+	S5M8763_ENCHGVI,
+	S5M8763_ESAFEUSB1,
+	S5M8763_ESAFEUSB2,
+};
+
+/**
+ * s5m87xx_regulator_data - regulator data
+ * @id: regulator id
+ * @initdata: regulator init data (contraints, supplies, ...)
+ */
+struct s5m_regulator_data {
+	int				id;
+	struct regulator_init_data	*initdata;
+};
+
+/*
+ * s5m_opmode_data - regulator operation mode data
+ * @id: regulator id
+ * @mode: regulator operation mode
+ */
+struct s5m_opmode_data {
+	int id;
+	int mode;
+};
+
+/*
+ * s5m regulator operation mode
+ * S5M_OPMODE_OFF	Regulator always OFF
+ * S5M_OPMODE_ON	Regulator always ON
+ * S5M_OPMODE_LOWPOWER  Regulator is on in low-power mode
+ * S5M_OPMODE_SUSPEND   Regulator is changed by PWREN pin
+ *			If PWREN is high, regulator is on
+ *			If PWREN is low, regulator is off
+ */
+
+enum s5m_opmode {
+	S5M_OPMODE_OFF,
+	S5M_OPMODE_ON,
+	S5M_OPMODE_LOWPOWER,
+	S5M_OPMODE_SUSPEND,
+};
+
+#endif /*  __LINUX_MFD_S5M_PMIC_H */
diff --git a/include/linux/mfd/samsung/s5m-rtc.h b/include/linux/mfd/samsung/s5m-rtc.h
new file mode 100644
index 0000000..6ce8da2
--- /dev/null
+++ b/include/linux/mfd/samsung/s5m-rtc.h
@@ -0,0 +1,84 @@
+/*
+ * s5m-rtc.h
+ *
+ * Copyright (c) 2011 Samsung Electronics Co., Ltd
+ *              http://www.samsung.com
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ *
+ */
+
+#ifndef __LINUX_MFD_S5M_RTC_H
+#define __LINUX_MFD_S5M_RTC_H
+
+enum s5m87xx_rtc_reg {
+	S5M87XX_RTC_SEC,
+	S5M87XX_RTC_MIN,
+	S5M87XX_RTC_HOUR,
+	S5M87XX_RTC_WEEKDAY,
+	S5M87XX_RTC_DATE,
+	S5M87XX_RTC_MONTH,
+	S5M87XX_RTC_YEAR1,
+	S5M87XX_RTC_YEAR2,
+	S5M87XX_ALARM0_SEC,
+	S5M87XX_ALARM0_MIN,
+	S5M87XX_ALARM0_HOUR,
+	S5M87XX_ALARM0_WEEKDAY,
+	S5M87XX_ALARM0_DATE,
+	S5M87XX_ALARM0_MONTH,
+	S5M87XX_ALARM0_YEAR1,
+	S5M87XX_ALARM0_YEAR2,
+	S5M87XX_ALARM1_SEC,
+	S5M87XX_ALARM1_MIN,
+	S5M87XX_ALARM1_HOUR,
+	S5M87XX_ALARM1_WEEKDAY,
+	S5M87XX_ALARM1_DATE,
+	S5M87XX_ALARM1_MONTH,
+	S5M87XX_ALARM1_YEAR1,
+	S5M87XX_ALARM1_YEAR2,
+	S5M87XX_ALARM0_CONF,
+	S5M87XX_ALARM1_CONF,
+	S5M87XX_RTC_STATUS,
+	S5M87XX_WTSR_SMPL_CNTL,
+	S5M87XX_RTC_UDR_CON,
+};
+
+#define RTC_I2C_ADDR		(0x0C >> 1)
+
+#define HOUR_12			(1 << 7)
+#define HOUR_AMPM		(1 << 6)
+#define HOUR_PM			(1 << 5)
+#define ALARM0_STATUS		(1 << 1)
+#define ALARM1_STATUS		(1 << 2)
+#define UPDATE_AD		(1 << 0)
+
+/* RTC Control Register */
+#define BCD_EN_SHIFT		0
+#define BCD_EN_MASK		(1 << BCD_EN_SHIFT)
+#define MODEL24_SHIFT		1
+#define MODEL24_MASK		(1 << MODEL24_SHIFT)
+/* RTC Update Register1 */
+#define RTC_UDR_SHIFT		0
+#define RTC_UDR_MASK		(1 << RTC_UDR_SHIFT)
+/* RTC Hour register */
+#define HOUR_PM_SHIFT		6
+#define HOUR_PM_MASK		(1 << HOUR_PM_SHIFT)
+/* RTC Alarm Enable */
+#define ALARM_ENABLE_SHIFT	7
+#define ALARM_ENABLE_MASK	(1 << ALARM_ENABLE_SHIFT)
+
+enum {
+	RTC_SEC = 0,
+	RTC_MIN,
+	RTC_HOUR,
+	RTC_WEEKDAY,
+	RTC_DATE,
+	RTC_MONTH,
+	RTC_YEAR1,
+	RTC_YEAR2,
+};
+
+#endif /*  __LINUX_MFD_S5M_RTC_H */
-- 
1.7.1


