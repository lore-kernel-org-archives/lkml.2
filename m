Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751830Ab2FRL3K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 07:29:10 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:25115 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915Ab2FRL3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 07:29:08 -0400
X-AuditID: cbfee61b-b7fcc6d000003a7a-5f-4fdf1102109b
From: Sangbeom Kim <sbkim73@samsung.com>
To: "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>,
        sameo@linux.intel.com
Cc: "'Liam Girdwood'" <lrg@ti.com>, linux-kernel@vger.kernel.org,
        sbkim01@gmail.com
Subject: [PATCH 3/7] mfd: samsung: Modify samsung mfd driver for common api
Date: Mon, 18 Jun 2012 20:29:06 +0900
Message-id: <067501cd4d45$920c1540$b6243fc0$@com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1NRZHmqbh65ioFS0+AT0KS2So9/A==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGLMWRmVeSWpSXmKPExsVy+t9jAV0mwfv+Bmtnq1tc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6M93PusBf8PM1YcfbBRcYGxlPLGLsYOTkkBEwkrnRfZoewxSQu
	3FvP1sXIxSEksIhR4szmaywQzlwmibddq5lAqtgENCRW7n7LBmKLCPhKXHr5n7WLkYODWSBY
	YutpPZCwsIC3ROOvE6wgNouAqsTiS11g5bwChhJtp7+yQ9iCEj8m32MBsZkFtCTW7zzOBGHL
	S2xe85YZZKSEgLrEo7+6EJv0JH5d/gRVLiKx78U7xgmMArOQTJqFZNIsJJNmIWlZwMiyilE0
	tSC5oDgpPddIrzgxt7g0L10vOT93EyM4NJ9J72Bc1WBxiFGAg1GJh/cN+31/IdbEsuLK3EOM
	EhzMSiK8P7iAQrwpiZVVqUX58UWlOanFhxilOViUxHmbrC/4CwmkJ5akZqemFqQWwWSZODil
	Ghgnf2KZZ+DwZKJpzSSTXsXg0NwE2XKVK6p79Zn7DpbFfTg67zxLmW3Jyu1MrvpHui+lqoqE
	XYllaTT5cC0hs/m18UTBkzsOCu54u3fe+oznt70mOE047/1g10lBVVv1Ylv+B+paUYdNDvO+
	10pLKVx7I+WriPRK/XfP9i5QOySvf/5hg6LU7wlKLMUZiYZazEXFiQBR7nn1SQIAAA==
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
 drivers/mfd/sec-core.c               |  126 +++++++++++-----------
 drivers/mfd/sec-irq.c                |  203 +++++++++++++++++-----------------
 include/linux/mfd/samsung/s5m-core.h |   34 +++---
 include/linux/mfd/samsung/s5m-pmic.h |   34 +++---
 4 files changed, 198 insertions(+), 199 deletions(-)

diff --git a/drivers/mfd/sec-core.c b/drivers/mfd/sec-core.c
index b090360..6684e77 100644
--- a/drivers/mfd/sec-core.c
+++ b/drivers/mfd/sec-core.c
@@ -1,5 +1,5 @@
 /*
- * s5m87xx.c
+ * sec_pmic.c
  *
  * Copyright (c) 2011 Samsung Electronics Co., Ltd
  *              http://www.samsung.com
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
+int s5m_bulk_write(struct sec_pmic_dev *sec_pmic, u8 reg, int count, u8 *buf)
 {
-	return regmap_raw_write(s5m87xx->regmap, reg, buf, count);
+	return regmap_raw_write(sec_pmic->regmap, reg, buf, count);
 }
 EXPORT_SYMBOL_GPL(s5m_bulk_write);
 
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
+	struct sec_pmic_platform_data *pdata = i2c->dev.platform_data;
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
index f60364f..c1e2a59 100644
--- a/drivers/mfd/sec-irq.c
+++ b/drivers/mfd/sec-irq.c
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
@@ -280,26 +280,25 @@ static struct irq_chip s5m8763_irq_chip = {
 
 static irqreturn_t s5m8767_irq_thread(int irq, void *data)
 {
-	struct s5m87xx_dev *s5m87xx = data;
+	struct sec_pmic_dev *sec_pmic = data;
 	u8 irq_reg[NUM_IRQ_REGS-1];
 	int ret;
 	int i;
 
-
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
@@ -307,44 +306,44 @@ static irqreturn_t s5m8767_irq_thread(int irq, void *data)
 
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
-	if (s5m87xx->irq && s5m87xx->irq_base){
-		switch (s5m87xx->device_type) {
+	if (sec_pmic->irq && sec_pmic->irq_base){
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
@@ -352,43 +351,43 @@ int s5m_irq_resume(struct s5m87xx_dev *s5m87xx)
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
@@ -399,30 +398,30 @@ int s5m_irq_init(struct s5m87xx_dev *s5m87xx)
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
 
@@ -436,40 +435,40 @@ int s5m_irq_init(struct s5m87xx_dev *s5m87xx)
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
+						IRQF_ONESHOT, "sec-pmic-ono",
+						sec_pmic);
 		break;
 	case S5M8767X:
-		ret = request_threaded_irq(s5m87xx->ono, NULL,
+		ret = request_threaded_irq(sec_pmic->ono, NULL,
 					s5m8767_irq_thread,
 					IRQF_TRIGGER_FALLING |
 					IRQF_TRIGGER_RISING |
-					IRQF_ONESHOT, "s5m87xx-ono", s5m87xx);
+					IRQF_ONESHOT, "sec-pmic-ono", sec_pmic);
 		break;
 	default:
 		ret = -EINVAL;
@@ -477,19 +476,19 @@ int s5m_irq_init(struct s5m87xx_dev *s5m87xx)
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
diff --git a/include/linux/mfd/samsung/s5m-core.h b/include/linux/mfd/samsung/s5m-core.h
index 0b2e0ed..47ed571 100644
--- a/include/linux/mfd/samsung/s5m-core.h
+++ b/include/linux/mfd/samsung/s5m-core.h
@@ -11,12 +11,12 @@
  *
  */
 
-#ifndef __LINUX_MFD_S5M_CORE_H
-#define __LINUX_MFD_S5M_CORE_H
+#ifndef __LINUX_MFD_SEC_CORE_H
+#define __LINUX_MFD_SEC_CORE_H
 
 #define NUM_IRQ_REGS	4
 
-enum s5m_device_type {
+enum sec_device_type {
 	S5M8751X,
 	S5M8763X,
 	S5M8767X,
@@ -292,7 +292,7 @@ enum s5m8763_irq {
 #define S5M8763_ENRAMP                  (1 << 4)
 
 /**
- * struct s5m87xx_dev - s5m87xx master device for sub-drivers
+ * struct sec_pmic_dev - s5m87xx master device for sub-drivers
  * @dev: master device of the chip (can be used to access platform data)
  * @i2c: i2c client private data for regulator
  * @rtc: i2c client private data for rtc
@@ -305,7 +305,7 @@ enum s5m8763_irq {
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
+struct sec_pmic_platform_data {
+	struct sec_regulator_data	*regulators;
+	struct sec_opmode_data		*opmode;
 	int				device_type;
 	int				num_regulators;
 
@@ -376,4 +376,4 @@ struct s5m_platform_data {
 	int				buck4_init;
 };
 
-#endif /*  __LINUX_MFD_S5M_CORE_H */
+#endif /*  __LINUX_MFD_SEC_CORE_H */
diff --git a/include/linux/mfd/samsung/s5m-pmic.h b/include/linux/mfd/samsung/s5m-pmic.h
index 7c719f2..2c03d7d 100644
--- a/include/linux/mfd/samsung/s5m-pmic.h
+++ b/include/linux/mfd/samsung/s5m-pmic.h
@@ -8,8 +8,8 @@
  * published by the Free Software Foundation.
 */
 
-#ifndef __LINUX_MFD_S5M_PMIC_H
-#define __LINUX_MFD_S5M_PMIC_H
+#ifndef __LINUX_MFD_SEC_PMIC_H
+#define __LINUX_MFD_SEC_PMIC_H
 
 #include <linux/regulator/machine.h>
 
@@ -90,40 +90,40 @@ enum s5m8763_regulators {
 };
 
 /**
- * s5m87xx_regulator_data - regulator data
+ * sec_regulator_data - regulator data
  * @id: regulator id
  * @initdata: regulator init data (contraints, supplies, ...)
  */
-struct s5m_regulator_data {
+struct sec_regulator_data {
 	int				id;
 	struct regulator_init_data	*initdata;
 };
 
 /*
- * s5m_opmode_data - regulator operation mode data
+ * sec_opmode_data - regulator operation mode data
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
 
-#endif /*  __LINUX_MFD_S5M_PMIC_H */
+#endif /*  __LINUX_MFD_SEC_PMIC_H */
-- 
1.7.1


