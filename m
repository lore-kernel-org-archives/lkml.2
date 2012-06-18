Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751904Ab2FRL3f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 07:29:35 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:38098 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294Ab2FRL3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 07:29:33 -0400
X-AuditID: cbfee61b-b7fcc6d000003a7a-8b-4fdf111b2636
From: Sangbeom Kim <sbkim73@samsung.com>
To: "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>,
        sameo@linux.intel.com
Cc: "'Liam Girdwood'" <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 5/7] mfd: samsung: Modify samsung mfd header
Date: Mon, 18 Jun 2012 20:29:31 +0900
Message-id: <067701cd4d45$a1159200$e340b600$@com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1NRaD0yYNlV/6VSTyJHwIJBF9MsA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGLMWRmVeSWpSXmKPExsVy+t9jAV1pwfv+Bs/X61pc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6M9s6HjAUXJzFVtO2cwt7AuPsRYxcjJ4eEgInE+ld3WSFsMYkL
	99azdTFycQgJLGKUmLD1CjuEM5dJ4umjHUwgVWwCGhIrd79lA7FFBHwlLr38D9bNLGAnMfdA
	C1iNsICNRHvnHLA4i4CqxNpNf4C2cXDwChhKfH1XARLmFRCU+DH5HgtEq5bE+p3HmSBseYnN
	a94yg5RLCKhLPPqrC7FJT2L+ghNQm0Qk9r14xziBUWAWkkmzkEyahWTSLCQtCxhZVjGKphYk
	FxQnpeca6RUn5haX5qXrJefnbmIEh+Yz6R2MqxosDjEKcDAq8fC+Yb/vL8SaWFZcmXuIUYKD
	WUmE9wcXUIg3JbGyKrUoP76oNCe1+BCjNAeLkjhvk/UFfyGB9MSS1OzU1ILUIpgsEwenVAMj
	j4O1Ucc/1VkPDZ1vvvAqkqn32/pfLKphL7dklJtb29FvlZOTN3FJGWffv1TTsVSas/Ndutqk
	utNpgTtvs0+IiQiI0pWdGLz7QkznceG9Sm7Lua4u+sfFPu3f6exej7tPp36XmPBIqUDs04qd
	EaaVN/kvNXvmv7IIOl7dKXBnrm/Vnc/n2AuVWIozEg21mIuKEwEX4D80SQIAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As Prefix of Samsung pmic changed from s5m to s2m,
To make common mfd driver for s2m and s5m series,
This patch rename header of Samsung mfd and modify mfd driver.

Signed-off-by: Sangbeom Kim <sbkim73@samsung.com>
---
 drivers/mfd/sec-core.c               |    6 +-
 drivers/mfd/sec-irq.c                |    5 +-
 drivers/regulator/s5m8767.c          |    4 +-
 include/linux/mfd/samsung/core.h     |  147 +++++++++++++
 include/linux/mfd/samsung/irq.h      |  113 ++++++++++
 include/linux/mfd/samsung/rtc.h      |   84 ++++++++
 include/linux/mfd/samsung/s5m-core.h |  379 ----------------------------------
 include/linux/mfd/samsung/s5m-pmic.h |  129 ------------
 include/linux/mfd/samsung/s5m-rtc.h  |   84 --------
 include/linux/mfd/samsung/s5m8763.h  |   97 +++++++++
 include/linux/mfd/samsung/s5m8767.h  |  189 +++++++++++++++++
 11 files changed, 639 insertions(+), 598 deletions(-)
 create mode 100644 include/linux/mfd/samsung/core.h
 create mode 100644 include/linux/mfd/samsung/irq.h
 create mode 100644 include/linux/mfd/samsung/rtc.h
 delete mode 100644 include/linux/mfd/samsung/s5m-core.h
 delete mode 100644 include/linux/mfd/samsung/s5m-pmic.h
 delete mode 100644 include/linux/mfd/samsung/s5m-rtc.h
 create mode 100644 include/linux/mfd/samsung/s5m8763.h
 create mode 100644 include/linux/mfd/samsung/s5m8767.h

diff --git a/drivers/mfd/sec-core.c b/drivers/mfd/sec-core.c
index 6684e77..5bf33cd 100644
--- a/drivers/mfd/sec-core.c
+++ b/drivers/mfd/sec-core.c
@@ -21,9 +21,9 @@
 #include <linux/pm_runtime.h>
 #include <linux/mutex.h>
 #include <linux/mfd/core.h>
-#include <linux/mfd/samsung/s5m-core.h>
-#include <linux/mfd/samsung/s5m-pmic.h>
-#include <linux/mfd/samsung/s5m-rtc.h>
+#include <linux/mfd/samsung/core.h>
+#include <linux/mfd/samsung/irq.h>
+#include <linux/mfd/samsung/rtc.h>
 #include <linux/regmap.h>
 
 static struct mfd_cell s5m8751_devs[] = {
diff --git a/drivers/mfd/sec-irq.c b/drivers/mfd/sec-irq.c
index c1e2a59..370cc4f 100644
--- a/drivers/mfd/sec-irq.c
+++ b/drivers/mfd/sec-irq.c
@@ -14,7 +14,10 @@
 #include <linux/device.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
-#include <linux/mfd/samsung/s5m-core.h>
+#include <linux/mfd/samsung/core.h>
+#include <linux/mfd/samsung/irq.h>
+#include <linux/mfd/samsung/s5m8763.h>
+#include <linux/mfd/samsung/s5m8767.h>
 
 struct sec_irq_data {
 	int reg;
diff --git a/drivers/regulator/s5m8767.c b/drivers/regulator/s5m8767.c
index 8ac984c..b98cad1 100644
--- a/drivers/regulator/s5m8767.c
+++ b/drivers/regulator/s5m8767.c
@@ -19,8 +19,8 @@
 #include <linux/platform_device.h>
 #include <linux/regulator/driver.h>
 #include <linux/regulator/machine.h>
-#include <linux/mfd/samsung/s5m-core.h>
-#include <linux/mfd/samsung/s5m-pmic.h>
+#include <linux/mfd/samsung/core.h>
+#include <linux/mfd/samsung/s5m8767.h>
 
 struct s5m8767_info {
 	struct device *dev;
diff --git a/include/linux/mfd/samsung/core.h b/include/linux/mfd/samsung/core.h
new file mode 100644
index 0000000..be6277a
--- /dev/null
+++ b/include/linux/mfd/samsung/core.h
@@ -0,0 +1,147 @@
+/*
+ * core.h
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
+#ifndef __LINUX_MFD_SEC_CORE_H
+#define __LINUX_MFD_SEC_CORE_H
+
+#define NUM_IRQ_REGS	4
+
+enum sec_device_type {
+	S5M8751X,
+	S5M8763X,
+	S5M8767X,
+};
+
+/**
+ * struct sec_pmic_dev - s5m87xx master device for sub-drivers
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
+struct sec_pmic_dev {
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
+int sec_irq_init(struct sec_pmic_dev *sec_pmic);
+void sec_irq_exit(struct sec_pmic_dev *sec_pmic);
+int sec_irq_resume(struct sec_pmic_dev *sec_pmic);
+
+extern int sec_reg_read(struct sec_pmic_dev *sec_pmic, u8 reg, void *dest);
+extern int sec_bulk_read(struct sec_pmic_dev *sec_pmic, u8 reg, int count, u8 *buf);
+extern int sec_reg_write(struct sec_pmic_dev *sec_pmic, u8 reg, u8 value);
+extern int sec_bulk_write(struct sec_pmic_dev *sec_pmic, u8 reg, int count, u8 *buf);
+extern int sec_reg_update(struct sec_pmic_dev *sec_pmic, u8 reg, u8 val, u8 mask);
+
+struct sec_pmic_platform_data {
+	struct sec_regulator_data	*regulators;
+	struct sec_opmode_data		*opmode;
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
+/**
+ * sec_regulator_data - regulator data
+ * @id: regulator id
+ * @initdata: regulator init data (contraints, supplies, ...)
+ */
+struct sec_regulator_data {
+	int				id;
+	struct regulator_init_data	*initdata;
+};
+
+/*
+ * sec_opmode_data - regulator operation mode data
+ * @id: regulator id
+ * @mode: regulator operation mode
+ */
+struct sec_opmode_data {
+	int id;
+	int mode;
+};
+
+/*
+ * samsung regulator operation mode
+ * SEC_OPMODE_OFF	Regulator always OFF
+ * SEC_OPMODE_ON	Regulator always ON
+ * SEC_OPMODE_LOWPOWER  Regulator is on in low-power mode
+ * SEC_OPMODE_SUSPEND   Regulator is changed by PWREN pin
+ *			If PWREN is high, regulator is on
+ *			If PWREN is low, regulator is off
+ */
+
+enum sec_opmode {
+	SEC_OPMODE_OFF,
+	SEC_OPMODE_ON,
+	SEC_OPMODE_LOWPOWER,
+	SEC_OPMODE_SUSPEND,
+};
+
+#endif /*  __LINUX_MFD_SEC_CORE_H */
diff --git a/include/linux/mfd/samsung/irq.h b/include/linux/mfd/samsung/irq.h
new file mode 100644
index 0000000..010f444
--- /dev/null
+++ b/include/linux/mfd/samsung/irq.h
@@ -0,0 +1,113 @@
+/*
+ * irq.h
+ *
+ * Copyright (c) 2012 Samsung Electronics Co., Ltd
+ *              http://www.samsung.com
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ *
+ */
+
+#ifndef __LINUX_MFD_SEC_IRQ_H
+#define __LINUX_MFD_SEC_IRQ_H
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
+
+
+#endif /*  __LINUX_MFD_SEC_IRQ_H */
diff --git a/include/linux/mfd/samsung/rtc.h b/include/linux/mfd/samsung/rtc.h
new file mode 100644
index 0000000..a0a86c3
--- /dev/null
+++ b/include/linux/mfd/samsung/rtc.h
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
+#ifndef __LINUX_MFD_SEC_RTC_H
+#define __LINUX_MFD_SEC_RTC_H
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
+#endif /*  __LINUX_MFD_SEC_RTC_H */
diff --git a/include/linux/mfd/samsung/s5m-core.h b/include/linux/mfd/samsung/s5m-core.h
deleted file mode 100644
index 47ed571..0000000
--- a/include/linux/mfd/samsung/s5m-core.h
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
-#ifndef __LINUX_MFD_SEC_CORE_H
-#define __LINUX_MFD_SEC_CORE_H
-
-#define NUM_IRQ_REGS	4
-
-enum sec_device_type {
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
- * struct sec_pmic_dev - s5m87xx master device for sub-drivers
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
-struct sec_pmic_dev {
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
-int sec_irq_init(struct sec_pmic_dev *sec_pmic);
-void sec_irq_exit(struct sec_pmic_dev *sec_pmic);
-int sec_irq_resume(struct sec_pmic_dev *sec_pmic);
-
-extern int sec_reg_read(struct sec_pmic_dev *sec_pmic, u8 reg, void *dest);
-extern int sec_bulk_read(struct sec_pmic_dev *sec_pmic, u8 reg, int count, u8 *buf);
-extern int sec_reg_write(struct sec_pmic_dev *sec_pmic, u8 reg, u8 value);
-extern int sec_bulk_write(struct sec_pmic_dev *sec_pmic, u8 reg, int count, u8 *buf);
-extern int sec_reg_update(struct sec_pmic_dev *sec_pmic, u8 reg, u8 val, u8 mask);
-
-struct sec_pmic_platform_data {
-	struct sec_regulator_data	*regulators;
-	struct sec_opmode_data		*opmode;
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
-#endif /*  __LINUX_MFD_SEC_CORE_H */
diff --git a/include/linux/mfd/samsung/s5m-pmic.h b/include/linux/mfd/samsung/s5m-pmic.h
deleted file mode 100644
index 2c03d7d..0000000
--- a/include/linux/mfd/samsung/s5m-pmic.h
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
-#ifndef __LINUX_MFD_SEC_PMIC_H
-#define __LINUX_MFD_SEC_PMIC_H
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
- * sec_regulator_data - regulator data
- * @id: regulator id
- * @initdata: regulator init data (contraints, supplies, ...)
- */
-struct sec_regulator_data {
-	int				id;
-	struct regulator_init_data	*initdata;
-};
-
-/*
- * sec_opmode_data - regulator operation mode data
- * @id: regulator id
- * @mode: regulator operation mode
- */
-struct sec_opmode_data {
-	int id;
-	int mode;
-};
-
-/*
- * samsung regulator operation mode
- * SEC_OPMODE_OFF	Regulator always OFF
- * SEC_OPMODE_ON	Regulator always ON
- * SEC_OPMODE_LOWPOWER  Regulator is on in low-power mode
- * SEC_OPMODE_SUSPEND   Regulator is changed by PWREN pin
- *			If PWREN is high, regulator is on
- *			If PWREN is low, regulator is off
- */
-
-enum sec_opmode {
-	SEC_OPMODE_OFF,
-	SEC_OPMODE_ON,
-	SEC_OPMODE_LOWPOWER,
-	SEC_OPMODE_SUSPEND,
-};
-
-#endif /*  __LINUX_MFD_SEC_PMIC_H */
diff --git a/include/linux/mfd/samsung/s5m-rtc.h b/include/linux/mfd/samsung/s5m-rtc.h
deleted file mode 100644
index 6ce8da2..0000000
--- a/include/linux/mfd/samsung/s5m-rtc.h
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
diff --git a/include/linux/mfd/samsung/s5m8763.h b/include/linux/mfd/samsung/s5m8763.h
new file mode 100644
index 0000000..2be7af3
--- /dev/null
+++ b/include/linux/mfd/samsung/s5m8763.h
@@ -0,0 +1,97 @@
+/*
+ * s5m8763.h
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
+#ifndef __LINUX_MFD_S5M8763_H
+#define __LINUX_MFD_S5M8763_H
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
+#define S5M8763_ENRAMP                  (1 << 4)
+#endif /* __LINUX_MFD_S5M8763_H */
diff --git a/include/linux/mfd/samsung/s5m8767.h b/include/linux/mfd/samsung/s5m8767.h
new file mode 100644
index 0000000..3bf920a
--- /dev/null
+++ b/include/linux/mfd/samsung/s5m8767.h
@@ -0,0 +1,189 @@
+/*
+ * s5m8767.h
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
+#ifndef __LINUX_MFD_S5M8767_H
+#define __LINUX_MFD_S5M8767_H
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
+#endif /* __LINUX_MFD_S5M8767_H */
-- 
1.7.1


