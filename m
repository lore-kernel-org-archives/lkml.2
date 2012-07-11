Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757450Ab2GKMG6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 08:06:58 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:33856 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754192Ab2GKMG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 08:06:56 -0400
X-AuditID: cbfee61a-b7f616d000004b7e-80-4ffd6c5ed99a
From: Sangbeom Kim <sbkim73@samsung.com>
To: sameo@linux.intel.com,
        "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>
Cc: "'Liam Girdwood'" <lrg@ti.com>, linux-kernel@vger.kernel.org,
        sbkim01@gmail.com
Subject: [PATCH V3 2/7] mfd: samsung: Modify samsung mfd driver for common api
Date: Wed, 11 Jul 2012 21:06:55 +0900
Message-id: <012a01cd5f5d$a9f93050$fdeb90f0$@com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1fXanj9AwLg7DwSuG5abdehsBl/g==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKLMWRmVeSWpSXmKPExsVy+t9jAd24nL/+Btf6JC0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfG1A8iBTd6mSo2979ibGD8cJuxi5GTQ0LAROJk/3dmCFtM4sK9
	9WxdjFwcQgKLGCVmtP1ih3DmMkns2PIVrIpNQENi5e63bCC2iICvxO9pm5m6GDk4mAWCJbae
	1gMJCwv4Scz4ugdsAYuAqsTkLa/BWnkFDCX+dl1jhbAFJX5MvscCYjMLaEms33mcCcKWl9i8
	5i0zyEgJAXWJR391ITbpSXzaeIcdokREYt+Ld4wTGAVmIZk0C8mkWUgmzULSsoCRZRWjaGpB
	ckFxUnquoV5xYm5xaV66XnJ+7iZGcGA+k9rBuLLB4hCjAAejEg9vVfBffyHWxLLiytxDjBIc
	zEoivDU+QCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8xt5f/YUE0hNLUrNTUwtSi2CyTBycUg2M
	HaZTmu//YV63ojomLepujVbmF8etFaJ2ql9n3336NnflPzbv++8y1vy9q/4g4Kt44D/b788q
	boTVqJ47l24wT7Lp9B7+N3b5a5KvuR1ancB9+iJ7Bnf9qi2TnS+aNrr5Nzzezaaae57VnK9H
	77VEGSeXZFaG2gO3h6dManyrY7t3nLqyUf+iEktxRqKhFnNRcSIAOG4CCEgCAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previous naming rule of samsung pmic start with s5m prefix.
But It is changed by s2m.
To cover various samsung s2m and s5m series,
This patch modify function and variable name for common usage.

Signed-off-by: Sangbeom Kim <sbkim73@samsung.com>
---
 drivers/mfd/sec-core.c               |  130 +++++++++++-----------
 drivers/mfd/sec-irq.c                |  204 +++++++++++++++++-----------------
 drivers/regulator/s5m8767.c          |   78 +++++++-------
 include/linux/mfd/samsung/s5m-core.h |   30 +++---
 include/linux/mfd/samsung/s5m-pmic.h |   24 ++--
 5 files changed, 233 insertions(+), 233 deletions(-)

diff --git a/drivers/mfd/sec-core.c b/drivers/mfd/sec-core.c
index b090360..5dfe671 100644
--- a/drivers/mfd/sec-core.c
+++ b/drivers/mfd/sec-core.c
@@ -1,7 +1,7 @@
 /*
- * s5m87xx.c
+ * sec-core.c
  *
- * Copyright (c) 2011 Samsung Electronics Co., Ltd
+ * Copyright (c) 2012 Samsung Electronics Co., Ltd
  *              http://www.samsung.com
  *
  *  This program is free software; you can redistribute  it and/or modify it
@@ -54,95 +54,95 @@ static struct mfd_cell s5m8767_devs[] = {
 	},
 };
 
-int s5m_reg_read(struct s5m87xx_dev *s5m87xx, u8 reg, void *dest)
+int sec_reg_read(struct sec_pmic_dev *sec_pmic, u8 reg, void *dest)
 {
-	return regmap_read(s5m87xx->regmap, reg, dest);
+	return regmap_read(sec_pmic->regmap, reg, dest);
 }
-EXPORT_SYMBOL_GPL(s5m_reg_read);
+EXPORT_SYMBOL_GPL(sec_reg_read);
 
-int s5m_bulk_read(struct s5m87xx_dev *s5m87xx, u8 reg, int count, u8 *buf)
+int sec_bulk_read(struct sec_pmic_dev *sec_pmic, u8 reg, int count, u8 *buf)
 {
-	return regmap_bulk_read(s5m87xx->regmap, reg, buf, count);
+	return regmap_bulk_read(sec_pmic->regmap, reg, buf, count);
 }
-EXPORT_SYMBOL_GPL(s5m_bulk_read);
+EXPORT_SYMBOL_GPL(sec_bulk_read);
 
-int s5m_reg_write(struct s5m87xx_dev *s5m87xx, u8 reg, u8 value)
+int sec_reg_write(struct sec_pmic_dev *sec_pmic, u8 reg, u8 value)
 {
-	return regmap_write(s5m87xx->regmap, reg, value);
+	return regmap_write(sec_pmic->regmap, reg, value);
 }
-EXPORT_SYMBOL_GPL(s5m_reg_write);
+EXPORT_SYMBOL_GPL(sec_reg_write);
 
-int s5m_bulk_write(struct s5m87xx_dev *s5m87xx, u8 reg, int count, u8 *buf)
+int sec_bulk_write(struct sec_pmic_dev *sec_pmic, u8 reg, int count, u8 *buf)
 {
-	return regmap_raw_write(s5m87xx->regmap, reg, buf, count);
+	return regmap_raw_write(sec_pmic->regmap, reg, buf, count);
 }
-EXPORT_SYMBOL_GPL(s5m_bulk_write);
+EXPORT_SYMBOL_GPL(sec_bulk_write);
 
-int s5m_reg_update(struct s5m87xx_dev *s5m87xx, u8 reg, u8 val, u8 mask)
+int sec_reg_update(struct sec_pmic_dev *sec_pmic, u8 reg, u8 val, u8 mask)
 {
-	return regmap_update_bits(s5m87xx->regmap, reg, mask, val);
+	return regmap_update_bits(sec_pmic->regmap, reg, mask, val);
 }
-EXPORT_SYMBOL_GPL(s5m_reg_update);
+EXPORT_SYMBOL_GPL(sec_reg_update);
 
-static struct regmap_config s5m_regmap_config = {
+static struct regmap_config sec_regmap_config = {
 	.reg_bits = 8,
 	.val_bits = 8,
 };
 
-static int s5m87xx_i2c_probe(struct i2c_client *i2c,
+static int sec_pmic_probe(struct i2c_client *i2c,
 			    const struct i2c_device_id *id)
 {
-	struct s5m_platform_data *pdata = i2c->dev.platform_data;
-	struct s5m87xx_dev *s5m87xx;
+	struct sec_platform_data *pdata = i2c->dev.platform_data;
+	struct sec_pmic_dev *sec_pmic;
 	int ret;
 
-	s5m87xx = devm_kzalloc(&i2c->dev, sizeof(struct s5m87xx_dev),
+	sec_pmic = devm_kzalloc(&i2c->dev, sizeof(struct sec_pmic_dev),
 				GFP_KERNEL);
-	if (s5m87xx == NULL)
+	if (sec_pmic == NULL)
 		return -ENOMEM;
 
-	i2c_set_clientdata(i2c, s5m87xx);
-	s5m87xx->dev = &i2c->dev;
-	s5m87xx->i2c = i2c;
-	s5m87xx->irq = i2c->irq;
-	s5m87xx->type = id->driver_data;
+	i2c_set_clientdata(i2c, sec_pmic);
+	sec_pmic->dev = &i2c->dev;
+	sec_pmic->i2c = i2c;
+	sec_pmic->irq = i2c->irq;
+	sec_pmic->type = id->driver_data;
 
 	if (pdata) {
-		s5m87xx->device_type = pdata->device_type;
-		s5m87xx->ono = pdata->ono;
-		s5m87xx->irq_base = pdata->irq_base;
-		s5m87xx->wakeup = pdata->wakeup;
+		sec_pmic->device_type = pdata->device_type;
+		sec_pmic->ono = pdata->ono;
+		sec_pmic->irq_base = pdata->irq_base;
+		sec_pmic->wakeup = pdata->wakeup;
 	}
 
-	s5m87xx->regmap = devm_regmap_init_i2c(i2c, &s5m_regmap_config);
-	if (IS_ERR(s5m87xx->regmap)) {
-		ret = PTR_ERR(s5m87xx->regmap);
+	sec_pmic->regmap = devm_regmap_init_i2c(i2c, &sec_regmap_config);
+	if (IS_ERR(sec_pmic->regmap)) {
+		ret = PTR_ERR(sec_pmic->regmap);
 		dev_err(&i2c->dev, "Failed to allocate register map: %d\n",
 			ret);
 		return ret;
 	}
 
-	s5m87xx->rtc = i2c_new_dummy(i2c->adapter, RTC_I2C_ADDR);
-	i2c_set_clientdata(s5m87xx->rtc, s5m87xx);
+	sec_pmic->rtc = i2c_new_dummy(i2c->adapter, RTC_I2C_ADDR);
+	i2c_set_clientdata(sec_pmic->rtc, sec_pmic);
 
 	if (pdata && pdata->cfg_pmic_irq)
 		pdata->cfg_pmic_irq();
 
-	s5m_irq_init(s5m87xx);
+	sec_irq_init(sec_pmic);
 
-	pm_runtime_set_active(s5m87xx->dev);
+	pm_runtime_set_active(sec_pmic->dev);
 
-	switch (s5m87xx->device_type) {
+	switch (sec_pmic->device_type) {
 	case S5M8751X:
-		ret = mfd_add_devices(s5m87xx->dev, -1, s5m8751_devs,
+		ret = mfd_add_devices(sec_pmic->dev, -1, s5m8751_devs,
 					ARRAY_SIZE(s5m8751_devs), NULL, 0);
 		break;
 	case S5M8763X:
-		ret = mfd_add_devices(s5m87xx->dev, -1, s5m8763_devs,
+		ret = mfd_add_devices(sec_pmic->dev, -1, s5m8763_devs,
 					ARRAY_SIZE(s5m8763_devs), NULL, 0);
 		break;
 	case S5M8767X:
-		ret = mfd_add_devices(s5m87xx->dev, -1, s5m8767_devs,
+		ret = mfd_add_devices(sec_pmic->dev, -1, s5m8767_devs,
 					ARRAY_SIZE(s5m8767_devs), NULL, 0);
 		break;
 	default:
@@ -156,50 +156,50 @@ static int s5m87xx_i2c_probe(struct i2c_client *i2c,
 	return ret;
 
 err:
-	mfd_remove_devices(s5m87xx->dev);
-	s5m_irq_exit(s5m87xx);
-	i2c_unregister_device(s5m87xx->rtc);
+	mfd_remove_devices(sec_pmic->dev);
+	sec_irq_exit(sec_pmic);
+	i2c_unregister_device(sec_pmic->rtc);
 	return ret;
 }
 
-static int s5m87xx_i2c_remove(struct i2c_client *i2c)
+static int sec_pmic_remove(struct i2c_client *i2c)
 {
-	struct s5m87xx_dev *s5m87xx = i2c_get_clientdata(i2c);
+	struct sec_pmic_dev *sec_pmic = i2c_get_clientdata(i2c);
 
-	mfd_remove_devices(s5m87xx->dev);
-	s5m_irq_exit(s5m87xx);
-	i2c_unregister_device(s5m87xx->rtc);
+	mfd_remove_devices(sec_pmic->dev);
+	sec_irq_exit(sec_pmic);
+	i2c_unregister_device(sec_pmic->rtc);
 	return 0;
 }
 
-static const struct i2c_device_id s5m87xx_i2c_id[] = {
-	{ "s5m87xx", 0 },
+static const struct i2c_device_id sec_pmic_id[] = {
+	{ "sec_pmic", 0 },
 	{ }
 };
-MODULE_DEVICE_TABLE(i2c, s5m87xx_i2c_id);
+MODULE_DEVICE_TABLE(i2c, sec_pmic_id);
 
-static struct i2c_driver s5m87xx_i2c_driver = {
+static struct i2c_driver sec_pmic_driver = {
 	.driver = {
-		   .name = "s5m87xx",
+		   .name = "sec_pmic",
 		   .owner = THIS_MODULE,
 	},
-	.probe = s5m87xx_i2c_probe,
-	.remove = s5m87xx_i2c_remove,
-	.id_table = s5m87xx_i2c_id,
+	.probe = sec_pmic_probe,
+	.remove = sec_pmic_remove,
+	.id_table = sec_pmic_id,
 };
 
-static int __init s5m87xx_i2c_init(void)
+static int __init sec_pmic_init(void)
 {
-	return i2c_add_driver(&s5m87xx_i2c_driver);
+	return i2c_add_driver(&sec_pmic_driver);
 }
 
-subsys_initcall(s5m87xx_i2c_init);
+subsys_initcall(sec_pmic_init);
 
-static void __exit s5m87xx_i2c_exit(void)
+static void __exit sec_pmic_exit(void)
 {
-	i2c_del_driver(&s5m87xx_i2c_driver);
+	i2c_del_driver(&sec_pmic_driver);
 }
-module_exit(s5m87xx_i2c_exit);
+module_exit(sec_pmic_exit);
 
 MODULE_AUTHOR("Sangbeom Kim <sbkim73@samsung.com>");
 MODULE_DESCRIPTION("Core support for the S5M MFD");
diff --git a/drivers/mfd/sec-irq.c b/drivers/mfd/sec-irq.c
index f60364f..4f90ccc 100644
--- a/drivers/mfd/sec-irq.c
+++ b/drivers/mfd/sec-irq.c
@@ -1,5 +1,5 @@
 /*
- * s5m-irq.c
+ * sec-irq.c
  *
  * Copyright (c) 2011 Samsung Electronics Co., Ltd
  *              http://www.samsung.com
@@ -16,12 +16,12 @@
 #include <linux/irq.h>
 #include <linux/mfd/samsung/s5m-core.h>
 
-struct s5m_irq_data {
+struct sec_irq_data {
 	int reg;
 	int mask;
 };
 
-static struct s5m_irq_data s5m8767_irqs[] = {
+static struct sec_irq_data s5m8767_irqs[] = {
 	[S5M8767_IRQ_PWRR] = {
 		.reg = 1,
 		.mask = S5M8767_IRQ_PWRR_MASK,
@@ -92,7 +92,7 @@ static struct s5m_irq_data s5m8767_irqs[] = {
 	},
 };
 
-static struct s5m_irq_data s5m8763_irqs[] = {
+static struct sec_irq_data s5m8763_irqs[] = {
 	[S5M8763_IRQ_DCINF] = {
 		.reg = 1,
 		.mask = S5M8763_IRQ_DCINF_MASK,
@@ -167,51 +167,51 @@ static struct s5m_irq_data s5m8763_irqs[] = {
 	},
 };
 
-static inline struct s5m_irq_data *
-irq_to_s5m8767_irq(struct s5m87xx_dev *s5m87xx, int irq)
+static inline struct sec_irq_data *
+irq_to_s5m8767_irq(struct sec_pmic_dev *sec_pmic, int irq)
 {
-	return &s5m8767_irqs[irq - s5m87xx->irq_base];
+	return &s5m8767_irqs[irq - sec_pmic->irq_base];
 }
 
 static void s5m8767_irq_lock(struct irq_data *data)
 {
-	struct s5m87xx_dev *s5m87xx = irq_data_get_irq_chip_data(data);
+	struct sec_pmic_dev *sec_pmic = irq_data_get_irq_chip_data(data);
 
-	mutex_lock(&s5m87xx->irqlock);
+	mutex_lock(&sec_pmic->irqlock);
 }
 
 static void s5m8767_irq_sync_unlock(struct irq_data *data)
 {
-	struct s5m87xx_dev *s5m87xx = irq_data_get_irq_chip_data(data);
+	struct sec_pmic_dev *sec_pmic = irq_data_get_irq_chip_data(data);
 	int i;
 
-	for (i = 0; i < ARRAY_SIZE(s5m87xx->irq_masks_cur); i++) {
-		if (s5m87xx->irq_masks_cur[i] != s5m87xx->irq_masks_cache[i]) {
-			s5m87xx->irq_masks_cache[i] = s5m87xx->irq_masks_cur[i];
-			s5m_reg_write(s5m87xx, S5M8767_REG_INT1M + i,
-					s5m87xx->irq_masks_cur[i]);
+	for (i = 0; i < ARRAY_SIZE(sec_pmic->irq_masks_cur); i++) {
+		if (sec_pmic->irq_masks_cur[i] != sec_pmic->irq_masks_cache[i]) {
+			sec_pmic->irq_masks_cache[i] = sec_pmic->irq_masks_cur[i];
+			sec_reg_write(sec_pmic, S5M8767_REG_INT1M + i,
+					sec_pmic->irq_masks_cur[i]);
 		}
 	}
 
-	mutex_unlock(&s5m87xx->irqlock);
+	mutex_unlock(&sec_pmic->irqlock);
 }
 
 static void s5m8767_irq_unmask(struct irq_data *data)
 {
-	struct s5m87xx_dev *s5m87xx = irq_data_get_irq_chip_data(data);
-	struct s5m_irq_data *irq_data = irq_to_s5m8767_irq(s5m87xx,
+	struct sec_pmic_dev *sec_pmic = irq_data_get_irq_chip_data(data);
+	struct sec_irq_data *irq_data = irq_to_s5m8767_irq(sec_pmic,
 							       data->irq);
 
-	s5m87xx->irq_masks_cur[irq_data->reg - 1] &= ~irq_data->mask;
+	sec_pmic->irq_masks_cur[irq_data->reg - 1] &= ~irq_data->mask;
 }
 
 static void s5m8767_irq_mask(struct irq_data *data)
 {
-	struct s5m87xx_dev *s5m87xx = irq_data_get_irq_chip_data(data);
-	struct s5m_irq_data *irq_data = irq_to_s5m8767_irq(s5m87xx,
+	struct sec_pmic_dev *sec_pmic = irq_data_get_irq_chip_data(data);
+	struct sec_irq_data *irq_data = irq_to_s5m8767_irq(sec_pmic,
 							       data->irq);
 
-	s5m87xx->irq_masks_cur[irq_data->reg - 1] |= irq_data->mask;
+	sec_pmic->irq_masks_cur[irq_data->reg - 1] |= irq_data->mask;
 }
 
 static struct irq_chip s5m8767_irq_chip = {
@@ -222,51 +222,51 @@ static struct irq_chip s5m8767_irq_chip = {
 	.irq_unmask = s5m8767_irq_unmask,
 };
 
-static inline struct s5m_irq_data *
-irq_to_s5m8763_irq(struct s5m87xx_dev *s5m87xx, int irq)
+static inline struct sec_irq_data *
+irq_to_s5m8763_irq(struct sec_pmic_dev *sec_pmic, int irq)
 {
-	return &s5m8763_irqs[irq - s5m87xx->irq_base];
+	return &s5m8763_irqs[irq - sec_pmic->irq_base];
 }
 
 static void s5m8763_irq_lock(struct irq_data *data)
 {
-	struct s5m87xx_dev *s5m87xx = irq_data_get_irq_chip_data(data);
+	struct sec_pmic_dev *sec_pmic = irq_data_get_irq_chip_data(data);
 
-	mutex_lock(&s5m87xx->irqlock);
+	mutex_lock(&sec_pmic->irqlock);
 }
 
 static void s5m8763_irq_sync_unlock(struct irq_data *data)
 {
-	struct s5m87xx_dev *s5m87xx = irq_data_get_irq_chip_data(data);
+	struct sec_pmic_dev *sec_pmic = irq_data_get_irq_chip_data(data);
 	int i;
 
-	for (i = 0; i < ARRAY_SIZE(s5m87xx->irq_masks_cur); i++) {
-		if (s5m87xx->irq_masks_cur[i] != s5m87xx->irq_masks_cache[i]) {
-			s5m87xx->irq_masks_cache[i] = s5m87xx->irq_masks_cur[i];
-			s5m_reg_write(s5m87xx, S5M8763_REG_IRQM1 + i,
-					s5m87xx->irq_masks_cur[i]);
+	for (i = 0; i < ARRAY_SIZE(sec_pmic->irq_masks_cur); i++) {
+		if (sec_pmic->irq_masks_cur[i] != sec_pmic->irq_masks_cache[i]) {
+			sec_pmic->irq_masks_cache[i] = sec_pmic->irq_masks_cur[i];
+			sec_reg_write(sec_pmic, S5M8763_REG_IRQM1 + i,
+					sec_pmic->irq_masks_cur[i]);
 		}
 	}
 
-	mutex_unlock(&s5m87xx->irqlock);
+	mutex_unlock(&sec_pmic->irqlock);
 }
 
 static void s5m8763_irq_unmask(struct irq_data *data)
 {
-	struct s5m87xx_dev *s5m87xx = irq_data_get_irq_chip_data(data);
-	struct s5m_irq_data *irq_data = irq_to_s5m8763_irq(s5m87xx,
+	struct sec_pmic_dev *sec_pmic = irq_data_get_irq_chip_data(data);
+	struct sec_irq_data *irq_data = irq_to_s5m8763_irq(sec_pmic,
 							       data->irq);
 
-	s5m87xx->irq_masks_cur[irq_data->reg - 1] &= ~irq_data->mask;
+	sec_pmic->irq_masks_cur[irq_data->reg - 1] &= ~irq_data->mask;
 }
 
 static void s5m8763_irq_mask(struct irq_data *data)
 {
-	struct s5m87xx_dev *s5m87xx = irq_data_get_irq_chip_data(data);
-	struct s5m_irq_data *irq_data = irq_to_s5m8763_irq(s5m87xx,
+	struct sec_pmic_dev *sec_pmic = irq_data_get_irq_chip_data(data);
+	struct sec_irq_data *irq_data = irq_to_s5m8763_irq(sec_pmic,
 							       data->irq);
 
-	s5m87xx->irq_masks_cur[irq_data->reg - 1] |= irq_data->mask;
+	sec_pmic->irq_masks_cur[irq_data->reg - 1] |= irq_data->mask;
 }
 
 static struct irq_chip s5m8763_irq_chip = {
@@ -280,26 +280,26 @@ static struct irq_chip s5m8763_irq_chip = {
 
 static irqreturn_t s5m8767_irq_thread(int irq, void *data)
 {
-	struct s5m87xx_dev *s5m87xx = data;
+	struct sec_pmic_dev *sec_pmic = data;
 	u8 irq_reg[NUM_IRQ_REGS-1];
 	int ret;
 	int i;
 
 
-	ret = s5m_bulk_read(s5m87xx, S5M8767_REG_INT1,
+	ret = sec_bulk_read(sec_pmic, S5M8767_REG_INT1,
 				NUM_IRQ_REGS - 1, irq_reg);
 	if (ret < 0) {
-		dev_err(s5m87xx->dev, "Failed to read interrupt register: %d\n",
+		dev_err(sec_pmic->dev, "Failed to read interrupt register: %d\n",
 				ret);
 		return IRQ_NONE;
 	}
 
 	for (i = 0; i < NUM_IRQ_REGS - 1; i++)
-		irq_reg[i] &= ~s5m87xx->irq_masks_cur[i];
+		irq_reg[i] &= ~sec_pmic->irq_masks_cur[i];
 
 	for (i = 0; i < S5M8767_IRQ_NR; i++) {
 		if (irq_reg[s5m8767_irqs[i].reg - 1] & s5m8767_irqs[i].mask)
-			handle_nested_irq(s5m87xx->irq_base + i);
+			handle_nested_irq(sec_pmic->irq_base + i);
 	}
 
 	return IRQ_HANDLED;
@@ -307,44 +307,44 @@ static irqreturn_t s5m8767_irq_thread(int irq, void *data)
 
 static irqreturn_t s5m8763_irq_thread(int irq, void *data)
 {
-	struct s5m87xx_dev *s5m87xx = data;
+	struct sec_pmic_dev *sec_pmic = data;
 	u8 irq_reg[NUM_IRQ_REGS];
 	int ret;
 	int i;
 
-	ret = s5m_bulk_read(s5m87xx, S5M8763_REG_IRQ1,
+	ret = sec_bulk_read(sec_pmic, S5M8763_REG_IRQ1,
 				NUM_IRQ_REGS, irq_reg);
 	if (ret < 0) {
-		dev_err(s5m87xx->dev, "Failed to read interrupt register: %d\n",
+		dev_err(sec_pmic->dev, "Failed to read interrupt register: %d\n",
 				ret);
 		return IRQ_NONE;
 	}
 
 	for (i = 0; i < NUM_IRQ_REGS; i++)
-		irq_reg[i] &= ~s5m87xx->irq_masks_cur[i];
+		irq_reg[i] &= ~sec_pmic->irq_masks_cur[i];
 
 	for (i = 0; i < S5M8763_IRQ_NR; i++) {
 		if (irq_reg[s5m8763_irqs[i].reg - 1] & s5m8763_irqs[i].mask)
-			handle_nested_irq(s5m87xx->irq_base + i);
+			handle_nested_irq(sec_pmic->irq_base + i);
 	}
 
 	return IRQ_HANDLED;
 }
 
-int s5m_irq_resume(struct s5m87xx_dev *s5m87xx)
+int sec_irq_resume(struct sec_pmic_dev *sec_pmic)
 {
-	if (s5m87xx->irq && s5m87xx->irq_base) {
-		switch (s5m87xx->device_type) {
+	if (sec_pmic->irq && sec_pmic->irq_base) {
+		switch (sec_pmic->device_type) {
 		case S5M8763X:
-			s5m8763_irq_thread(s5m87xx->irq_base, s5m87xx);
+			s5m8763_irq_thread(sec_pmic->irq_base, sec_pmic);
 			break;
 		case S5M8767X:
-			s5m8767_irq_thread(s5m87xx->irq_base, s5m87xx);
+			s5m8767_irq_thread(sec_pmic->irq_base, sec_pmic);
 			break;
 		default:
-			dev_err(s5m87xx->dev,
+			dev_err(sec_pmic->dev,
 				"Unknown device type %d\n",
-				s5m87xx->device_type);
+				sec_pmic->device_type);
 			return -EINVAL;
 
 		}
@@ -352,43 +352,43 @@ int s5m_irq_resume(struct s5m87xx_dev *s5m87xx)
 	return 0;
 }
 
-int s5m_irq_init(struct s5m87xx_dev *s5m87xx)
+int sec_irq_init(struct sec_pmic_dev *sec_pmic)
 {
 	int i;
 	int cur_irq;
 	int ret = 0;
-	int type = s5m87xx->device_type;
+	int type = sec_pmic->device_type;
 
-	if (!s5m87xx->irq) {
-		dev_warn(s5m87xx->dev,
+	if (!sec_pmic->irq) {
+		dev_warn(sec_pmic->dev,
 			 "No interrupt specified, no interrupts\n");
-		s5m87xx->irq_base = 0;
+		sec_pmic->irq_base = 0;
 		return 0;
 	}
 
-	if (!s5m87xx->irq_base) {
-		dev_err(s5m87xx->dev,
+	if (!sec_pmic->irq_base) {
+		dev_err(sec_pmic->dev,
 			"No interrupt base specified, no interrupts\n");
 		return 0;
 	}
 
-	mutex_init(&s5m87xx->irqlock);
+	mutex_init(&sec_pmic->irqlock);
 
 	switch (type) {
 	case S5M8763X:
 		for (i = 0; i < NUM_IRQ_REGS; i++) {
-			s5m87xx->irq_masks_cur[i] = 0xff;
-			s5m87xx->irq_masks_cache[i] = 0xff;
-			s5m_reg_write(s5m87xx, S5M8763_REG_IRQM1 + i,
+			sec_pmic->irq_masks_cur[i] = 0xff;
+			sec_pmic->irq_masks_cache[i] = 0xff;
+			sec_reg_write(sec_pmic, S5M8763_REG_IRQM1 + i,
 						0xff);
 		}
 
-		s5m_reg_write(s5m87xx, S5M8763_REG_STATUSM1, 0xff);
-		s5m_reg_write(s5m87xx, S5M8763_REG_STATUSM2, 0xff);
+		sec_reg_write(sec_pmic, S5M8763_REG_STATUSM1, 0xff);
+		sec_reg_write(sec_pmic, S5M8763_REG_STATUSM2, 0xff);
 
 		for (i = 0; i < S5M8763_IRQ_NR; i++) {
-			cur_irq = i + s5m87xx->irq_base;
-			irq_set_chip_data(cur_irq, s5m87xx);
+			cur_irq = i + sec_pmic->irq_base;
+			irq_set_chip_data(cur_irq, sec_pmic);
 			irq_set_chip_and_handler(cur_irq, &s5m8763_irq_chip,
 						 handle_edge_irq);
 			irq_set_nested_thread(cur_irq, 1);
@@ -399,30 +399,30 @@ int s5m_irq_init(struct s5m87xx_dev *s5m87xx)
 #endif
 		}
 
-		ret = request_threaded_irq(s5m87xx->irq, NULL,
+		ret = request_threaded_irq(sec_pmic->irq, NULL,
 					s5m8763_irq_thread,
 					IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
-					"s5m87xx-irq", s5m87xx);
+					"sec-pmic-irq", sec_pmic);
 		if (ret) {
-			dev_err(s5m87xx->dev, "Failed to request IRQ %d: %d\n",
-				s5m87xx->irq, ret);
+			dev_err(sec_pmic->dev, "Failed to request IRQ %d: %d\n",
+				sec_pmic->irq, ret);
 			return ret;
 		}
 		break;
 	case S5M8767X:
 		for (i = 0; i < NUM_IRQ_REGS - 1; i++) {
-			s5m87xx->irq_masks_cur[i] = 0xff;
-			s5m87xx->irq_masks_cache[i] = 0xff;
-			s5m_reg_write(s5m87xx, S5M8767_REG_INT1M + i,
+			sec_pmic->irq_masks_cur[i] = 0xff;
+			sec_pmic->irq_masks_cache[i] = 0xff;
+			sec_reg_write(sec_pmic, S5M8767_REG_INT1M + i,
 						0xff);
 		}
 		for (i = 0; i < S5M8767_IRQ_NR; i++) {
-			cur_irq = i + s5m87xx->irq_base;
-			irq_set_chip_data(cur_irq, s5m87xx);
+			cur_irq = i + sec_pmic->irq_base;
+			irq_set_chip_data(cur_irq, sec_pmic);
 			if (ret) {
-				dev_err(s5m87xx->dev,
+				dev_err(sec_pmic->dev,
 					"Failed to irq_set_chip_data %d: %d\n",
-					s5m87xx->irq, ret);
+					sec_pmic->irq, ret);
 				return ret;
 			}
 
@@ -436,40 +436,40 @@ int s5m_irq_init(struct s5m87xx_dev *s5m87xx)
 #endif
 		}
 
-		ret = request_threaded_irq(s5m87xx->irq, NULL,
+		ret = request_threaded_irq(sec_pmic->irq, NULL,
 					   s5m8767_irq_thread,
 					   IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
-					   "s5m87xx-irq", s5m87xx);
+					   "sec-pmic-irq", sec_pmic);
 		if (ret) {
-			dev_err(s5m87xx->dev, "Failed to request IRQ %d: %d\n",
-				s5m87xx->irq, ret);
+			dev_err(sec_pmic->dev, "Failed to request IRQ %d: %d\n",
+				sec_pmic->irq, ret);
 			return ret;
 		}
 		break;
 	default:
-		dev_err(s5m87xx->dev,
-			"Unknown device type %d\n", s5m87xx->device_type);
+		dev_err(sec_pmic->dev,
+			"Unknown device type %d\n", sec_pmic->device_type);
 		return -EINVAL;
 	}
 
-	if (!s5m87xx->ono)
+	if (!sec_pmic->ono)
 		return 0;
 
 	switch (type) {
 	case S5M8763X:
-		ret = request_threaded_irq(s5m87xx->ono, NULL,
+		ret = request_threaded_irq(sec_pmic->ono, NULL,
 						s5m8763_irq_thread,
 						IRQF_TRIGGER_FALLING |
 						IRQF_TRIGGER_RISING |
-						IRQF_ONESHOT, "s5m87xx-ono",
-						s5m87xx);
+						IRQF_ONESHOT, "sec_pmic-ono",
+						sec_pmic);
 		break;
 	case S5M8767X:
-		ret = request_threaded_irq(s5m87xx->ono, NULL,
+		ret = request_threaded_irq(sec_pmic->ono, NULL,
 					s5m8767_irq_thread,
 					IRQF_TRIGGER_FALLING |
 					IRQF_TRIGGER_RISING |
-					IRQF_ONESHOT, "s5m87xx-ono", s5m87xx);
+					IRQF_ONESHOT, "sec_pmic-ono", sec_pmic);
 		break;
 	default:
 		ret = -EINVAL;
@@ -477,19 +477,19 @@ int s5m_irq_init(struct s5m87xx_dev *s5m87xx)
 	}
 
 	if (ret) {
-		dev_err(s5m87xx->dev, "Failed to request IRQ %d: %d\n",
-			s5m87xx->ono, ret);
+		dev_err(sec_pmic->dev, "Failed to request IRQ %d: %d\n",
+			sec_pmic->ono, ret);
 		return ret;
 	}
 
 	return 0;
 }
 
-void s5m_irq_exit(struct s5m87xx_dev *s5m87xx)
+void sec_irq_exit(struct sec_pmic_dev *sec_pmic)
 {
-	if (s5m87xx->ono)
-		free_irq(s5m87xx->ono, s5m87xx);
+	if (sec_pmic->ono)
+		free_irq(sec_pmic->ono, sec_pmic);
 
-	if (s5m87xx->irq)
-		free_irq(s5m87xx->irq, s5m87xx);
+	if (sec_pmic->irq)
+		free_irq(sec_pmic->irq, sec_pmic);
 }
diff --git a/drivers/regulator/s5m8767.c b/drivers/regulator/s5m8767.c
index a778958..0049e34 100644
--- a/drivers/regulator/s5m8767.c
+++ b/drivers/regulator/s5m8767.c
@@ -24,10 +24,10 @@
 
 struct s5m8767_info {
 	struct device *dev;
-	struct s5m87xx_dev *iodev;
+	struct sec_pmic_dev *iodev;
 	int num_regulators;
 	struct regulator_dev **rdev;
-	struct s5m_opmode_data *opmode;
+	struct sec_opmode_data *opmode;
 
 	int ramp_delay;
 	bool buck2_ramp;
@@ -44,43 +44,43 @@ struct s5m8767_info {
 	int buck_gpioindex;
 };
 
-struct s5m_voltage_desc {
+struct sec_voltage_desc {
 	int max;
 	int min;
 	int step;
 };
 
-static const struct s5m_voltage_desc buck_voltage_val1 = {
+static const struct sec_voltage_desc buck_voltage_val1 = {
 	.max = 2225000,
 	.min =  650000,
 	.step =   6250,
 };
 
-static const struct s5m_voltage_desc buck_voltage_val2 = {
+static const struct sec_voltage_desc buck_voltage_val2 = {
 	.max = 1600000,
 	.min =  600000,
 	.step =   6250,
 };
 
-static const struct s5m_voltage_desc buck_voltage_val3 = {
+static const struct sec_voltage_desc buck_voltage_val3 = {
 	.max = 3000000,
 	.min =  750000,
 	.step =  12500,
 };
 
-static const struct s5m_voltage_desc ldo_voltage_val1 = {
+static const struct sec_voltage_desc ldo_voltage_val1 = {
 	.max = 3950000,
 	.min =  800000,
 	.step =  50000,
 };
 
-static const struct s5m_voltage_desc ldo_voltage_val2 = {
+static const struct sec_voltage_desc ldo_voltage_val2 = {
 	.max = 2375000,
 	.min =  800000,
 	.step =  25000,
 };
 
-static const struct s5m_voltage_desc *reg_voltage_map[] = {
+static const struct sec_voltage_desc *reg_voltage_map[] = {
 	[S5M8767_LDO1] = &ldo_voltage_val2,
 	[S5M8767_LDO2] = &ldo_voltage_val2,
 	[S5M8767_LDO3] = &ldo_voltage_val1,
@@ -123,7 +123,7 @@ static const struct s5m_voltage_desc *reg_voltage_map[] = {
 static int s5m8767_list_voltage(struct regulator_dev *rdev,
 				unsigned int selector)
 {
-	const struct s5m_voltage_desc *desc;
+	const struct sec_voltage_desc *desc;
 	int reg_id = rdev_get_id(rdev);
 	int val;
 
@@ -233,7 +233,7 @@ static int s5m8767_reg_is_enabled(struct regulator_dev *rdev)
 	else if (ret)
 		return ret;
 
-	ret = s5m_reg_read(s5m8767->iodev, reg, &val);
+	ret = sec_reg_read(s5m8767->iodev, reg, &val);
 	if (ret)
 		return ret;
 
@@ -250,7 +250,7 @@ static int s5m8767_reg_enable(struct regulator_dev *rdev)
 	if (ret)
 		return ret;
 
-	return s5m_reg_update(s5m8767->iodev, reg, enable_ctrl, mask);
+	return sec_reg_update(s5m8767->iodev, reg, enable_ctrl, mask);
 }
 
 static int s5m8767_reg_disable(struct regulator_dev *rdev)
@@ -263,7 +263,7 @@ static int s5m8767_reg_disable(struct regulator_dev *rdev)
 	if (ret)
 		return ret;
 
-	return s5m_reg_update(s5m8767->iodev, reg, ~mask, mask);
+	return sec_reg_update(s5m8767->iodev, reg, ~mask, mask);
 }
 
 static int s5m8767_get_voltage_register(struct regulator_dev *rdev, int *_reg)
@@ -325,7 +325,7 @@ static int s5m8767_get_voltage_sel(struct regulator_dev *rdev)
 
 	mask = (reg_id < S5M8767_BUCK1) ? 0x3f : 0xff;
 
-	ret = s5m_reg_read(s5m8767->iodev, reg, &val);
+	ret = sec_reg_read(s5m8767->iodev, reg, &val);
 	if (ret)
 		return ret;
 
@@ -335,7 +335,7 @@ static int s5m8767_get_voltage_sel(struct regulator_dev *rdev)
 }
 
 static int s5m8767_convert_voltage_to_sel(
-		const struct s5m_voltage_desc *desc,
+		const struct sec_voltage_desc *desc,
 		int min_vol, int max_vol)
 {
 	int selector = 0;
@@ -379,7 +379,7 @@ static int s5m8767_set_voltage(struct regulator_dev *rdev,
 				int min_uV, int max_uV, unsigned *selector)
 {
 	struct s5m8767_info *s5m8767 = rdev_get_drvdata(rdev);
-	const struct s5m_voltage_desc *desc;
+	const struct sec_voltage_desc *desc;
 	int reg_id = rdev_get_id(rdev);
 	int sel, reg, mask, ret = 0, old_index, index = 0;
 	u8 val;
@@ -431,10 +431,10 @@ static int s5m8767_set_voltage(struct regulator_dev *rdev,
 		if (ret)
 			return ret;
 
-		s5m_reg_read(s5m8767->iodev, reg, &val);
+		sec_reg_read(s5m8767->iodev, reg, &val);
 		val = (val & ~mask) | sel;
 
-		ret = s5m_reg_write(s5m8767->iodev, reg, val);
+		ret = sec_reg_write(s5m8767->iodev, reg, val);
 	}
 
 	*selector = sel;
@@ -446,7 +446,7 @@ static int s5m8767_set_voltage_time_sel(struct regulator_dev *rdev,
 					     unsigned int new_sel)
 {
 	struct s5m8767_info *s5m8767 = rdev_get_drvdata(rdev);
-	const struct s5m_voltage_desc *desc;
+	const struct sec_voltage_desc *desc;
 	int reg_id = rdev_get_id(rdev);
 
 	desc = reg_voltage_map[reg_id];
@@ -517,8 +517,8 @@ static struct regulator_desc regulators[] = {
 
 static __devinit int s5m8767_pmic_probe(struct platform_device *pdev)
 {
-	struct s5m87xx_dev *iodev = dev_get_drvdata(pdev->dev.parent);
-	struct s5m_platform_data *pdata = dev_get_platdata(iodev->dev);
+	struct sec_pmic_dev *iodev = dev_get_drvdata(pdev->dev.parent);
+	struct sec_platform_data *pdata = dev_get_platdata(iodev->dev);
 	struct regulator_config config = { };
 	struct regulator_dev **rdev;
 	struct s5m8767_info *s5m8767;
@@ -644,70 +644,70 @@ static __devinit int s5m8767_pmic_probe(struct platform_device *pdev)
 		}
 	}
 
-	s5m_reg_update(s5m8767->iodev, S5M8767_REG_BUCK2CTRL,
+	sec_reg_update(s5m8767->iodev, S5M8767_REG_BUCK2CTRL,
 			(pdata->buck2_gpiodvs) ? (1 << 1) : (0 << 1), 1 << 1);
-	s5m_reg_update(s5m8767->iodev, S5M8767_REG_BUCK3CTRL,
+	sec_reg_update(s5m8767->iodev, S5M8767_REG_BUCK3CTRL,
 			(pdata->buck3_gpiodvs) ? (1 << 1) : (0 << 1), 1 << 1);
-	s5m_reg_update(s5m8767->iodev, S5M8767_REG_BUCK4CTRL,
+	sec_reg_update(s5m8767->iodev, S5M8767_REG_BUCK4CTRL,
 			(pdata->buck4_gpiodvs) ? (1 << 1) : (0 << 1), 1 << 1);
 
 	/* Initialize GPIO DVS registers */
 	for (i = 0; i < 8; i++) {
 		if (s5m8767->buck2_gpiodvs) {
-			s5m_reg_write(s5m8767->iodev, S5M8767_REG_BUCK2DVS1 + i,
+			sec_reg_write(s5m8767->iodev, S5M8767_REG_BUCK2DVS1 + i,
 					   s5m8767->buck2_vol[i]);
 		}
 
 		if (s5m8767->buck3_gpiodvs) {
-			s5m_reg_write(s5m8767->iodev, S5M8767_REG_BUCK3DVS1 + i,
+			sec_reg_write(s5m8767->iodev, S5M8767_REG_BUCK3DVS1 + i,
 					   s5m8767->buck3_vol[i]);
 		}
 
 		if (s5m8767->buck4_gpiodvs) {
-			s5m_reg_write(s5m8767->iodev, S5M8767_REG_BUCK4DVS1 + i,
+			sec_reg_write(s5m8767->iodev, S5M8767_REG_BUCK4DVS1 + i,
 					   s5m8767->buck4_vol[i]);
 		}
 	}
-	s5m_reg_update(s5m8767->iodev, S5M8767_REG_BUCK2CTRL, 0x78, 0xff);
-	s5m_reg_update(s5m8767->iodev, S5M8767_REG_BUCK3CTRL, 0x58, 0xff);
-	s5m_reg_update(s5m8767->iodev, S5M8767_REG_BUCK4CTRL, 0x78, 0xff);
+	sec_reg_update(s5m8767->iodev, S5M8767_REG_BUCK2CTRL, 0x78, 0xff);
+	sec_reg_update(s5m8767->iodev, S5M8767_REG_BUCK3CTRL, 0x58, 0xff);
+	sec_reg_update(s5m8767->iodev, S5M8767_REG_BUCK4CTRL, 0x78, 0xff);
 
 	if (s5m8767->buck2_ramp)
-		s5m_reg_update(s5m8767->iodev, S5M8767_REG_DVSRAMP, 0x08, 0x08);
+		sec_reg_update(s5m8767->iodev, S5M8767_REG_DVSRAMP, 0x08, 0x08);
 
 	if (s5m8767->buck3_ramp)
-		s5m_reg_update(s5m8767->iodev, S5M8767_REG_DVSRAMP, 0x04, 0x04);
+		sec_reg_update(s5m8767->iodev, S5M8767_REG_DVSRAMP, 0x04, 0x04);
 
 	if (s5m8767->buck4_ramp)
-		s5m_reg_update(s5m8767->iodev, S5M8767_REG_DVSRAMP, 0x02, 0x02);
+		sec_reg_update(s5m8767->iodev, S5M8767_REG_DVSRAMP, 0x02, 0x02);
 
 	if (s5m8767->buck2_ramp || s5m8767->buck3_ramp
 		|| s5m8767->buck4_ramp) {
 		switch (s5m8767->ramp_delay) {
 		case 15:
-			s5m_reg_update(s5m8767->iodev, S5M8767_REG_DVSRAMP,
+			sec_reg_update(s5m8767->iodev, S5M8767_REG_DVSRAMP,
 					0xc0, 0xf0);
 			break;
 		case 25:
-			s5m_reg_update(s5m8767->iodev, S5M8767_REG_DVSRAMP,
+			sec_reg_update(s5m8767->iodev, S5M8767_REG_DVSRAMP,
 					0xd0, 0xf0);
 			break;
 		case 50:
-			s5m_reg_update(s5m8767->iodev, S5M8767_REG_DVSRAMP,
+			sec_reg_update(s5m8767->iodev, S5M8767_REG_DVSRAMP,
 					0xe0, 0xf0);
 			break;
 		case 100:
-			s5m_reg_update(s5m8767->iodev, S5M8767_REG_DVSRAMP,
+			sec_reg_update(s5m8767->iodev, S5M8767_REG_DVSRAMP,
 					0xf0, 0xf0);
 			break;
 		default:
-			s5m_reg_update(s5m8767->iodev, S5M8767_REG_DVSRAMP,
+			sec_reg_update(s5m8767->iodev, S5M8767_REG_DVSRAMP,
 					0x90, 0xf0);
 		}
 	}
 
 	for (i = 0; i < pdata->num_regulators; i++) {
-		const struct s5m_voltage_desc *desc;
+		const struct sec_voltage_desc *desc;
 		int id = pdata->regulators[i].id;
 
 		desc = reg_voltage_map[id];
diff --git a/include/linux/mfd/samsung/s5m-core.h b/include/linux/mfd/samsung/s5m-core.h
index 21603b4..ca18120 100644
--- a/include/linux/mfd/samsung/s5m-core.h
+++ b/include/linux/mfd/samsung/s5m-core.h
@@ -16,7 +16,7 @@
 
 #define NUM_IRQ_REGS	4
 
-enum s5m_device_type {
+enum sec_device_type {
 	S5M8751X,
 	S5M8763X,
 	S5M8767X,
@@ -292,20 +292,20 @@ enum s5m8763_irq {
 #define S5M8763_ENRAMP                  (1 << 4)
 
 /**
- * struct s5m87xx_dev - s5m87xx master device for sub-drivers
+ * struct sec_pmic_dev - sec_pmic master device for sub-drivers
  * @dev: master device of the chip (can be used to access platform data)
  * @i2c: i2c client private data for regulator
  * @rtc: i2c client private data for rtc
  * @iolock: mutex for serializing io access
  * @irqlock: mutex for buslock
- * @irq_base: base IRQ number for s5m87xx, required for IRQs
+ * @irq_base: base IRQ number for sec_pmic, required for IRQs
  * @irq: generic IRQ number for s5m87xx
  * @ono: power onoff IRQ number for s5m87xx
  * @irq_masks_cur: currently active value
  * @irq_masks_cache: cached hardware value
  * @type: indicate which s5m87xx "variant" is used
  */
-struct s5m87xx_dev {
+struct sec_pmic_dev {
 	struct device *dev;
 	struct regmap *regmap;
 	struct i2c_client *i2c;
@@ -323,19 +323,19 @@ struct s5m87xx_dev {
 	bool wakeup;
 };
 
-int s5m_irq_init(struct s5m87xx_dev *s5m87xx);
-void s5m_irq_exit(struct s5m87xx_dev *s5m87xx);
-int s5m_irq_resume(struct s5m87xx_dev *s5m87xx);
+int sec_irq_init(struct sec_pmic_dev *sec_pmic);
+void sec_irq_exit(struct sec_pmic_dev *sec_pmic);
+int sec_irq_resume(struct sec_pmic_dev *sec_pmic);
 
-extern int s5m_reg_read(struct s5m87xx_dev *s5m87xx, u8 reg, void *dest);
-extern int s5m_bulk_read(struct s5m87xx_dev *s5m87xx, u8 reg, int count, u8 *buf);
-extern int s5m_reg_write(struct s5m87xx_dev *s5m87xx, u8 reg, u8 value);
-extern int s5m_bulk_write(struct s5m87xx_dev *s5m87xx, u8 reg, int count, u8 *buf);
-extern int s5m_reg_update(struct s5m87xx_dev *s5m87xx, u8 reg, u8 val, u8 mask);
+extern int sec_reg_read(struct sec_pmic_dev *sec_pmic, u8 reg, void *dest);
+extern int sec_bulk_read(struct sec_pmic_dev *sec_pmic, u8 reg, int count, u8 *buf);
+extern int sec_reg_write(struct sec_pmic_dev *sec_pmic, u8 reg, u8 value);
+extern int sec_bulk_write(struct sec_pmic_dev *sec_pmic, u8 reg, int count, u8 *buf);
+extern int sec_reg_update(struct sec_pmic_dev *sec_pmic, u8 reg, u8 val, u8 mask);
 
-struct s5m_platform_data {
-	struct s5m_regulator_data	*regulators;
-	struct s5m_opmode_data		*opmode;
+struct sec_platform_data {
+	struct sec_regulator_data	*regulators;
+	struct sec_opmode_data		*opmode;
 	int				device_type;
 	int				num_regulators;
 
diff --git a/include/linux/mfd/samsung/s5m-pmic.h b/include/linux/mfd/samsung/s5m-pmic.h
index 7c719f2..562febf 100644
--- a/include/linux/mfd/samsung/s5m-pmic.h
+++ b/include/linux/mfd/samsung/s5m-pmic.h
@@ -94,7 +94,7 @@ enum s5m8763_regulators {
  * @id: regulator id
  * @initdata: regulator init data (contraints, supplies, ...)
  */
-struct s5m_regulator_data {
+struct sec_regulator_data {
 	int				id;
 	struct regulator_init_data	*initdata;
 };
@@ -104,26 +104,26 @@ struct s5m_regulator_data {
  * @id: regulator id
  * @mode: regulator operation mode
  */
-struct s5m_opmode_data {
+struct sec_opmode_data {
 	int id;
 	int mode;
 };
 
 /*
- * s5m regulator operation mode
- * S5M_OPMODE_OFF	Regulator always OFF
- * S5M_OPMODE_ON	Regulator always ON
- * S5M_OPMODE_LOWPOWER  Regulator is on in low-power mode
- * S5M_OPMODE_SUSPEND   Regulator is changed by PWREN pin
+ * samsung regulator operation mode
+ * SEC_OPMODE_OFF	Regulator always OFF
+ * SEC_OPMODE_ON	Regulator always ON
+ * SEC_OPMODE_LOWPOWER  Regulator is on in low-power mode
+ * SEC_OPMODE_SUSPEND   Regulator is changed by PWREN pin
  *			If PWREN is high, regulator is on
  *			If PWREN is low, regulator is off
  */
 
-enum s5m_opmode {
-	S5M_OPMODE_OFF,
-	S5M_OPMODE_ON,
-	S5M_OPMODE_LOWPOWER,
-	S5M_OPMODE_SUSPEND,
+enum sec_opmode {
+	SEC_OPMODE_OFF,
+	SEC_OPMODE_ON,
+	SEC_OPMODE_LOWPOWER,
+	SEC_OPMODE_SUSPEND,
 };
 
 #endif /*  __LINUX_MFD_S5M_PMIC_H */
-- 
1.7.1

