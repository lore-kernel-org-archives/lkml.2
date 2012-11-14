Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161096Ab2KNPjx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 10:39:53 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:2422 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964793Ab2KNPju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 10:39:50 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 14 Nov 2012 07:39:43 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <sameo@linux.intel.com>, <broonie@opensource.wolfsonmicro.com>,
        <lrg@ti.com>
CC: <linux-kernel@vger.kernel.org>, <g.liakhovetski@gmx.de>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 2/2] regulator: tps80031: add prefix TPS80031 on common defines.
Date: Wed, 14 Nov 2012 21:09:29 +0530
Message-ID: <1352907569-12466-2-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1352907569-12466-1-git-send-email-ldewangan@nvidia.com>
References: <1352907569-12466-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pefix "TPS80031" is added on all defines of tps80031 header
to avoid conflict with other header definitions.
Update the regualtor driver of tps80031 to use the same name.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
Guennadi suggested to have the names of register and its field prefix
by TPS80031 to avoid the conflict with name on other driver's header.
By doing this, it also need to update the regulator driver to use new
names. Just updating the driver on top of applied patch.

 drivers/regulator/tps80031-regulator.c |   80 +++++++++++++++++---------------
 1 files changed, 42 insertions(+), 38 deletions(-)

diff --git a/drivers/regulator/tps80031-regulator.c b/drivers/regulator/tps80031-regulator.c
index 0484478..a37ede8 100644
--- a/drivers/regulator/tps80031-regulator.c
+++ b/drivers/regulator/tps80031-regulator.c
@@ -105,16 +105,17 @@ static int tps80031_reg_is_enabled(struct regulator_dev *rdev)
 	u8 reg_val;
 	int ret;
 
-	if (ri->ext_ctrl_flag & EXT_PWR_REQ)
+	if (ri->ext_ctrl_flag & TPS80031_EXT_PWR_REQ)
 		return true;
 
-	ret = tps80031_read(parent, SLAVE_ID1, ri->rinfo->state_reg, &reg_val);
+	ret = tps80031_read(parent, TPS80031_SLAVE_ID1, ri->rinfo->state_reg,
+				&reg_val);
 	if (ret < 0) {
 		dev_err(&rdev->dev, "Reg 0x%02x read failed, err = %d\n",
 			ri->rinfo->state_reg, ret);
 		return ret;
 	}
-	return ((reg_val & STATE_MASK) == STATE_ON);
+	return ((reg_val & TPS80031_STATE_MASK) == TPS80031_STATE_ON);
 }
 
 static int tps80031_reg_enable(struct regulator_dev *rdev)
@@ -123,11 +124,11 @@ static int tps80031_reg_enable(struct regulator_dev *rdev)
 	struct device *parent = to_tps80031_dev(rdev);
 	int ret;
 
-	if (ri->ext_ctrl_flag & EXT_PWR_REQ)
+	if (ri->ext_ctrl_flag & TPS80031_EXT_PWR_REQ)
 		return 0;
 
-	ret = tps80031_update(parent, SLAVE_ID1, ri->rinfo->state_reg,
-			STATE_ON, STATE_MASK);
+	ret = tps80031_update(parent, TPS80031_SLAVE_ID1, ri->rinfo->state_reg,
+			TPS80031_STATE_ON, TPS80031_STATE_MASK);
 	if (ret < 0) {
 		dev_err(&rdev->dev, "Reg 0x%02x update failed, err = %d\n",
 			ri->rinfo->state_reg, ret);
@@ -142,11 +143,11 @@ static int tps80031_reg_disable(struct regulator_dev *rdev)
 	struct device *parent = to_tps80031_dev(rdev);
 	int ret;
 
-	if (ri->ext_ctrl_flag & EXT_PWR_REQ)
+	if (ri->ext_ctrl_flag & TPS80031_EXT_PWR_REQ)
 		return 0;
 
-	ret = tps80031_update(parent, SLAVE_ID1, ri->rinfo->state_reg,
-			STATE_OFF, STATE_MASK);
+	ret = tps80031_update(parent, TPS80031_SLAVE_ID1, ri->rinfo->state_reg,
+			TPS80031_STATE_OFF, TPS80031_STATE_MASK);
 	if (ret < 0)
 		dev_err(&rdev->dev, "Reg 0x%02x update failed, err = %d\n",
 			ri->rinfo->state_reg, ret);
@@ -299,14 +300,14 @@ static int tps80031_vbus_is_enabled(struct regulator_dev *rdev)
 	uint8_t ctrl1 = 0;
 	uint8_t ctrl3 = 0;
 
-	ret = tps80031_read(parent, SLAVE_ID2,
+	ret = tps80031_read(parent, TPS80031_SLAVE_ID2,
 			TPS80031_CHARGERUSB_CTRL1, &ctrl1);
 	if (ret < 0) {
 		dev_err(ri->dev, "reg 0x%02x read failed, e = %d\n",
 			TPS80031_CHARGERUSB_CTRL1, ret);
 		return ret;
 	}
-	ret = tps80031_read(parent, SLAVE_ID2,
+	ret = tps80031_read(parent, TPS80031_SLAVE_ID2,
 				TPS80031_CHARGERUSB_CTRL3, &ctrl3);
 	if (ret < 0) {
 		dev_err(ri->dev, "reg 0x%02x read failed, e = %d\n",
@@ -324,7 +325,7 @@ static int tps80031_vbus_enable(struct regulator_dev *rdev)
 	struct device *parent = to_tps80031_dev(rdev);
 	int ret;
 
-	ret = tps80031_set_bits(parent, SLAVE_ID2,
+	ret = tps80031_set_bits(parent, TPS80031_SLAVE_ID2,
 				TPS80031_CHARGERUSB_CTRL1, OPA_MODE_EN);
 	if (ret < 0) {
 		dev_err(ri->dev, "reg 0x%02x read failed, e = %d\n",
@@ -332,7 +333,7 @@ static int tps80031_vbus_enable(struct regulator_dev *rdev)
 		return ret;
 	}
 
-	ret = tps80031_set_bits(parent, SLAVE_ID2,
+	ret = tps80031_set_bits(parent, TPS80031_SLAVE_ID2,
 				TPS80031_CHARGERUSB_CTRL3, BOOST_HW_PWR_EN);
 	if (ret < 0) {
 		dev_err(ri->dev, "reg 0x%02x read failed, e = %d\n",
@@ -348,8 +349,8 @@ static int tps80031_vbus_disable(struct regulator_dev *rdev)
 	struct device *parent = to_tps80031_dev(rdev);
 	int ret = 0;
 
-	if (ri->config_flags & VBUS_DISCHRG_EN_PDN) {
-		ret = tps80031_write(parent, SLAVE_ID2,
+	if (ri->config_flags & TPS80031_VBUS_DISCHRG_EN_PDN) {
+		ret = tps80031_write(parent, TPS80031_SLAVE_ID2,
 			USB_VBUS_CTRL_SET, VBUS_DISCHRG);
 		if (ret < 0) {
 			dev_err(ri->dev, "reg 0x%02x write failed, e = %d\n",
@@ -358,7 +359,7 @@ static int tps80031_vbus_disable(struct regulator_dev *rdev)
 		}
 	}
 
-	ret = tps80031_clr_bits(parent, SLAVE_ID2,
+	ret = tps80031_clr_bits(parent, TPS80031_SLAVE_ID2,
 			TPS80031_CHARGERUSB_CTRL1,  OPA_MODE_EN);
 	if (ret < 0) {
 		dev_err(ri->dev, "reg 0x%02x clearbit failed, e = %d\n",
@@ -366,7 +367,7 @@ static int tps80031_vbus_disable(struct regulator_dev *rdev)
 		return ret;
 	}
 
-	ret = tps80031_clr_bits(parent, SLAVE_ID2,
+	ret = tps80031_clr_bits(parent, TPS80031_SLAVE_ID2,
 				TPS80031_CHARGERUSB_CTRL3, BOOST_HW_PWR_EN);
 	if (ret < 0) {
 		dev_err(ri->dev, "reg 0x%02x clearbit failed, e = %d\n",
@@ -375,8 +376,8 @@ static int tps80031_vbus_disable(struct regulator_dev *rdev)
 	}
 
 	mdelay(DIV_ROUND_UP(ri->rinfo->desc.enable_time, 1000));
-	if (ri->config_flags & VBUS_DISCHRG_EN_PDN) {
-		ret = tps80031_write(parent, SLAVE_ID2,
+	if (ri->config_flags & TPS80031_VBUS_DISCHRG_EN_PDN) {
+		ret = tps80031_write(parent, TPS80031_SLAVE_ID2,
 			USB_VBUS_CTRL_CLR, VBUS_DISCHRG);
 		if (ret < 0) {
 			dev_err(ri->dev, "reg 0x%02x write failed, e = %d\n",
@@ -433,7 +434,7 @@ static struct regulator_ops tps80031_ext_reg_ops = {
 	.state_reg = TPS80031_##_id##_CFG_STATE,		\
 	.force_reg = TPS80031_##_id##_CFG_FORCE,		\
 	.volt_reg = TPS80031_##_id##_CFG_VOLTAGE,		\
-	.volt_id = SLAVE_##_volt_id,				\
+	.volt_id = TPS80031_SLAVE_##_volt_id,			\
 	.preq_bit = _pbit,					\
 	.desc = {						\
 		.name = "tps80031_"#_id,			\
@@ -451,7 +452,7 @@ static struct regulator_ops tps80031_ext_reg_ops = {
 	.trans_reg = TPS80031_##_id##_CFG_TRANS,		\
 	.state_reg = TPS80031_##_id##_CFG_STATE,		\
 	.volt_reg = TPS80031_##_id##_CFG_VOLTAGE,		\
-	.volt_id = SLAVE_ID1,					\
+	.volt_id = TPS80031_SLAVE_ID1,				\
 	.preq_bit = _preq_bit,					\
 	.desc = {						\
 		.owner = THIS_MODULE,				\
@@ -471,7 +472,7 @@ static struct regulator_ops tps80031_ext_reg_ops = {
 {								\
 	.trans_reg = TPS80031_##_id##_CFG_TRANS,		\
 	.state_reg = TPS80031_##_id##_CFG_STATE,		\
-	.volt_id = SLAVE_ID1,					\
+	.volt_id = TPS80031_SLAVE_ID1,				\
 	.preq_bit = _pbit,					\
 	.desc = {						\
 		.name = "tps80031_"#_id,			\
@@ -524,9 +525,10 @@ static int tps80031_power_req_config(struct device *parent,
 	}
 
 skip_pwr_req_config:
-	if (tps80031_pdata->ext_ctrl_flag & PWR_ON_ON_SLEEP) {
-		ret = tps80031_update(parent, SLAVE_ID1, ri->rinfo->trans_reg,
-				TRANS_SLEEP_ON, TRANS_SLEEP_MASK);
+	if (tps80031_pdata->ext_ctrl_flag & TPS80031_PWR_ON_ON_SLEEP) {
+		ret = tps80031_update(parent, TPS80031_SLAVE_ID1,
+				ri->rinfo->trans_reg, TPS80031_TRANS_SLEEP_ON,
+				TPS80031_TRANS_SLEEP_MASK);
 		if (ret < 0) {
 			dev_err(ri->dev, "Reg 0x%02x update failed, e %d\n",
 					ri->rinfo->trans_reg, ret);
@@ -544,16 +546,17 @@ static int tps80031_regulator_config(struct device *parent,
 
 	switch (ri->rinfo->desc.id) {
 	case TPS80031_REGULATOR_LDOUSB:
-		if (ri->config_flags &
-			(USBLDO_INPUT_VSYS | USBLDO_INPUT_PMID)) {
+		if (ri->config_flags & (TPS80031_USBLDO_INPUT_VSYS |
+			TPS80031_USBLDO_INPUT_PMID)) {
 			unsigned val = 0;
-			if (ri->config_flags & USBLDO_INPUT_VSYS)
+			if (ri->config_flags & TPS80031_USBLDO_INPUT_VSYS)
 				val = MISC2_LDOUSB_IN_VSYS;
 			else
 				val = MISC2_LDOUSB_IN_PMID;
 
-			ret = tps80031_update(parent, SLAVE_ID1,
-				TPS80031_MISC2, val, MISC2_LDOUSB_IN_MASK);
+			ret = tps80031_update(parent, TPS80031_SLAVE_ID1,
+				TPS80031_MISC2, val,
+				MISC2_LDOUSB_IN_MASK);
 			if (ret < 0) {
 				dev_err(ri->dev,
 					"LDOUSB config failed, e= %d\n", ret);
@@ -563,8 +566,8 @@ static int tps80031_regulator_config(struct device *parent,
 		break;
 
 	case TPS80031_REGULATOR_LDO3:
-		if (ri->config_flags & LDO3_OUTPUT_VIB) {
-			ret = tps80031_update(parent, SLAVE_ID1,
+		if (ri->config_flags & TPS80031_LDO3_OUTPUT_VIB) {
+			ret = tps80031_update(parent, TPS80031_SLAVE_ID1,
 				TPS80031_MISC2, MISC2_LDO3_SEL_VIB_VAL,
 				MISC2_LDO3_SEL_VIB_MASK);
 			if (ret < 0) {
@@ -577,7 +580,7 @@ static int tps80031_regulator_config(struct device *parent,
 
 	case TPS80031_REGULATOR_VBUS:
 		/* Provide SW control Ops if VBUS is SW control */
-		if (!(ri->config_flags & VBUS_SW_ONLY))
+		if (!(ri->config_flags & TPS80031_VBUS_SW_ONLY))
 			ri->rinfo->desc.ops = &tps80031_vbus_sw_ops;
 		break;
 	default:
@@ -585,9 +588,10 @@ static int tps80031_regulator_config(struct device *parent,
 	}
 
 	/* Configure Active state to ON, SLEEP to OFF and OFF_state to OFF */
-	ret = tps80031_update(parent, SLAVE_ID1, ri->rinfo->trans_reg,
-		TRANS_ACTIVE_ON | TRANS_SLEEP_OFF | TRANS_OFF_OFF,
-		TRANS_ACTIVE_MASK | TRANS_SLEEP_MASK | TRANS_OFF_MASK);
+	ret = tps80031_update(parent, TPS80031_SLAVE_ID1, ri->rinfo->trans_reg,
+		TPS80031_TRANS_ACTIVE_ON | TPS80031_TRANS_SLEEP_OFF |
+		TPS80031_TRANS_OFF_OFF, TPS80031_TRANS_ACTIVE_MASK |
+		TPS80031_TRANS_SLEEP_MASK | TPS80031_TRANS_OFF_MASK);
 	if (ret < 0) {
 		dev_err(ri->dev, "trans reg update failed, e %d\n", ret);
 		return ret;
@@ -604,14 +608,14 @@ static int check_smps_mode_mult(struct device *parent,
 	u8 smps_offset;
 	u8 smps_mult;
 
-	ret = tps80031_read(parent, SLAVE_ID1,
+	ret = tps80031_read(parent, TPS80031_SLAVE_ID1,
 			TPS80031_SMPS_OFFSET, &smps_offset);
 	if (ret < 0) {
 		dev_err(parent, "Error in reading smps offset register\n");
 		return ret;
 	}
 
-	ret = tps80031_read(parent, SLAVE_ID1,
+	ret = tps80031_read(parent, TPS80031_SLAVE_ID1,
 			TPS80031_SMPS_MULT, &smps_mult);
 	if (ret < 0) {
 		dev_err(parent, "Error in reading smps mult register\n");
-- 
1.7.1.1

