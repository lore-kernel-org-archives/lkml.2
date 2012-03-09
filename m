Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076Ab2CIIxy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 03:53:54 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:37959 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753702Ab2CIIxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 03:53:53 -0500
X-AuditID: cbfee61a-b7b78ae000001ceb-0f-4f59c51fc7a0
From: Sangbeom Kim <sbkim73@samsung.com>
To: sameo@linux.intel.com, linux-kernel@vger.kernel.org
Cc: "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>, sbkim01@gmail.com
Subject: [PATCH 1/2] mfd: Add s5m regulator operation mode
Date: Fri, 09 Mar 2012 17:53:53 +0900
Message-id: <06ac01ccfdd2$27701c80$76505580$@com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Acz90iczTjIJluDLSlajekwZeLCLmw==
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add variables for opmode of s5m series.
S5M series have 4 operation modes.
Off mode is always regulator off mode.
On mode is always regulator on mode.
Lowpower mode is that regualtor operate in low-power.
Suspend mode is that regulator operation depends on AP suspend mode.

Signed-off-by: Sangbeom Kim <sbkim73@samsung.com>
---
 include/linux/mfd/s5m87xx/s5m-core.h |    1 +
 include/linux/mfd/s5m87xx/s5m-pmic.h |   29 +++++++++++++++++++++++++++++
 2 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/include/linux/mfd/s5m87xx/s5m-core.h b/include/linux/mfd/s5m87xx/s5m-core.h
index a7480b5..21603b4 100644
--- a/include/linux/mfd/s5m87xx/s5m-core.h
+++ b/include/linux/mfd/s5m87xx/s5m-core.h
@@ -335,6 +335,7 @@ extern int s5m_reg_update(struct s5m87xx_dev *s5m87xx, u8 reg, u8 val, u8 mask);
 
 struct s5m_platform_data {
 	struct s5m_regulator_data	*regulators;
+	struct s5m_opmode_data		*opmode;
 	int				device_type;
 	int				num_regulators;
 
diff --git a/include/linux/mfd/s5m87xx/s5m-pmic.h b/include/linux/mfd/s5m87xx/s5m-pmic.h
index a72a5d2..a199589 100644
--- a/include/linux/mfd/s5m87xx/s5m-pmic.h
+++ b/include/linux/mfd/s5m87xx/s5m-pmic.h
@@ -58,6 +58,8 @@ enum s5m8767_regulators {
 	S5M8767_REG_MAX,
 };
 
+#define S5M8767_ENCTRL_SHIFT  6
+
 /* S5M8763 regulator ids */
 enum s5m8763_regulators {
 	S5M8763_LDO1,
@@ -97,4 +99,31 @@ struct s5m_regulator_data {
 	struct regulator_init_data	*initdata;
 };
 
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
 #endif /*  __LINUX_MFD_S5M_PMIC_H */
-- 
1.7.1

