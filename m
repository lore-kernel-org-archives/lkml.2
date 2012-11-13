Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605Ab2KMI3Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 03:29:16 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:41574 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932129Ab2KMI3L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 03:29:11 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>
CC: Tero Kristo <t-kristo@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 11/13] mfd: twl4030-power: Change TWL4030_MODULE_* ids to TWL_MODULE_*
Date: Tue, 13 Nov 2012 09:28:52 +0100
Message-ID: <1352795334-7406-12-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1352795334-7406-1-git-send-email-peter.ujfalusi@ti.com>
References: <1352795334-7406-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To facilitate upcoming cleanup in twl stack.
No functional changes.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/mfd/twl4030-power.c | 124 ++++++++++++++++++--------------------------
 1 file changed, 51 insertions(+), 73 deletions(-)

diff --git a/drivers/mfd/twl4030-power.c b/drivers/mfd/twl4030-power.c
index 79ca33d..4fda77c 100644
--- a/drivers/mfd/twl4030-power.c
+++ b/drivers/mfd/twl4030-power.c
@@ -128,12 +128,10 @@ static int __devinit twl4030_write_script_byte(u8 address, u8 byte)
 {
 	int err;
 
-	err = twl_i2c_write_u8(TWL4030_MODULE_PM_MASTER, address,
-				R_MEMORY_ADDRESS);
+	err = twl_i2c_write_u8(TWL_MODULE_PM_MASTER, address, R_MEMORY_ADDRESS);
 	if (err)
 		goto out;
-	err = twl_i2c_write_u8(TWL4030_MODULE_PM_MASTER, byte,
-				R_MEMORY_DATA);
+	err = twl_i2c_write_u8(TWL_MODULE_PM_MASTER, byte, R_MEMORY_DATA);
 out:
 	return err;
 }
@@ -189,19 +187,16 @@ static int __devinit twl4030_config_wakeup3_sequence(u8 address)
 	u8 data;
 
 	/* Set SLEEP to ACTIVE SEQ address for P3 */
-	err = twl_i2c_write_u8(TWL4030_MODULE_PM_MASTER, address,
-				R_SEQ_ADD_S2A3);
+	err = twl_i2c_write_u8(TWL_MODULE_PM_MASTER, address, R_SEQ_ADD_S2A3);
 	if (err)
 		goto out;
 
 	/* P3 LVL_WAKEUP should be on LEVEL */
-	err = twl_i2c_read_u8(TWL4030_MODULE_PM_MASTER, &data,
-				R_P3_SW_EVENTS);
+	err = twl_i2c_read_u8(TWL_MODULE_PM_MASTER, &data, R_P3_SW_EVENTS);
 	if (err)
 		goto out;
 	data |= LVL_WAKEUP;
-	err = twl_i2c_write_u8(TWL4030_MODULE_PM_MASTER, data,
-				R_P3_SW_EVENTS);
+	err = twl_i2c_write_u8(TWL_MODULE_PM_MASTER, data, R_P3_SW_EVENTS);
 out:
 	if (err)
 		pr_err("TWL4030 wakeup sequence for P3 config error\n");
@@ -214,43 +209,38 @@ static int __devinit twl4030_config_wakeup12_sequence(u8 address)
 	u8 data;
 
 	/* Set SLEEP to ACTIVE SEQ address for P1 and P2 */
-	err = twl_i2c_write_u8(TWL4030_MODULE_PM_MASTER, address,
-				R_SEQ_ADD_S2A12);
+	err = twl_i2c_write_u8(TWL_MODULE_PM_MASTER, address, R_SEQ_ADD_S2A12);
 	if (err)
 		goto out;
 
 	/* P1/P2 LVL_WAKEUP should be on LEVEL */
-	err = twl_i2c_read_u8(TWL4030_MODULE_PM_MASTER, &data,
-				R_P1_SW_EVENTS);
+	err = twl_i2c_read_u8(TWL_MODULE_PM_MASTER, &data, R_P1_SW_EVENTS);
 	if (err)
 		goto out;
 
 	data |= LVL_WAKEUP;
-	err = twl_i2c_write_u8(TWL4030_MODULE_PM_MASTER, data,
-				R_P1_SW_EVENTS);
+	err = twl_i2c_write_u8(TWL_MODULE_PM_MASTER, data, R_P1_SW_EVENTS);
 	if (err)
 		goto out;
 
-	err = twl_i2c_read_u8(TWL4030_MODULE_PM_MASTER, &data,
-				R_P2_SW_EVENTS);
+	err = twl_i2c_read_u8(TWL_MODULE_PM_MASTER, &data, R_P2_SW_EVENTS);
 	if (err)
 		goto out;
 
 	data |= LVL_WAKEUP;
-	err = twl_i2c_write_u8(TWL4030_MODULE_PM_MASTER, data,
-				R_P2_SW_EVENTS);
+	err = twl_i2c_write_u8(TWL_MODULE_PM_MASTER, data, R_P2_SW_EVENTS);
 	if (err)
 		goto out;
 
 	if (machine_is_omap_3430sdp() || machine_is_omap_ldp()) {
 		/* Disabling AC charger effect on sleep-active transitions */
-		err = twl_i2c_read_u8(TWL4030_MODULE_PM_MASTER, &data,
-					R_CFG_P1_TRANSITION);
+		err = twl_i2c_read_u8(TWL_MODULE_PM_MASTER, &data,
+				      R_CFG_P1_TRANSITION);
 		if (err)
 			goto out;
 		data &= ~(1<<1);
-		err = twl_i2c_write_u8(TWL4030_MODULE_PM_MASTER, data ,
-					R_CFG_P1_TRANSITION);
+		err = twl_i2c_write_u8(TWL_MODULE_PM_MASTER, data,
+				       R_CFG_P1_TRANSITION);
 		if (err)
 			goto out;
 	}
@@ -267,8 +257,7 @@ static int __devinit twl4030_config_sleep_sequence(u8 address)
 	int err;
 
 	/* Set ACTIVE to SLEEP SEQ address in T2 memory*/
-	err = twl_i2c_write_u8(TWL4030_MODULE_PM_MASTER, address,
-				R_SEQ_ADD_A2S);
+	err = twl_i2c_write_u8(TWL_MODULE_PM_MASTER, address, R_SEQ_ADD_A2S);
 
 	if (err)
 		pr_err("TWL4030 sleep sequence config error\n");
@@ -282,42 +271,35 @@ static int __devinit twl4030_config_warmreset_sequence(u8 address)
 	u8 rd_data;
 
 	/* Set WARM RESET SEQ address for P1 */
-	err = twl_i2c_write_u8(TWL4030_MODULE_PM_MASTER, address,
-				R_SEQ_ADD_WARM);
+	err = twl_i2c_write_u8(TWL_MODULE_PM_MASTER, address, R_SEQ_ADD_WARM);
 	if (err)
 		goto out;
 
 	/* P1/P2/P3 enable WARMRESET */
-	err = twl_i2c_read_u8(TWL4030_MODULE_PM_MASTER, &rd_data,
-				R_P1_SW_EVENTS);
+	err = twl_i2c_read_u8(TWL_MODULE_PM_MASTER, &rd_data, R_P1_SW_EVENTS);
 	if (err)
 		goto out;
 
 	rd_data |= ENABLE_WARMRESET;
-	err = twl_i2c_write_u8(TWL4030_MODULE_PM_MASTER, rd_data,
-				R_P1_SW_EVENTS);
+	err = twl_i2c_write_u8(TWL_MODULE_PM_MASTER, rd_data, R_P1_SW_EVENTS);
 	if (err)
 		goto out;
 
-	err = twl_i2c_read_u8(TWL4030_MODULE_PM_MASTER, &rd_data,
-				R_P2_SW_EVENTS);
+	err = twl_i2c_read_u8(TWL_MODULE_PM_MASTER, &rd_data, R_P2_SW_EVENTS);
 	if (err)
 		goto out;
 
 	rd_data |= ENABLE_WARMRESET;
-	err = twl_i2c_write_u8(TWL4030_MODULE_PM_MASTER, rd_data,
-				R_P2_SW_EVENTS);
+	err = twl_i2c_write_u8(TWL_MODULE_PM_MASTER, rd_data, R_P2_SW_EVENTS);
 	if (err)
 		goto out;
 
-	err = twl_i2c_read_u8(TWL4030_MODULE_PM_MASTER, &rd_data,
-				R_P3_SW_EVENTS);
+	err = twl_i2c_read_u8(TWL_MODULE_PM_MASTER, &rd_data, R_P3_SW_EVENTS);
 	if (err)
 		goto out;
 
 	rd_data |= ENABLE_WARMRESET;
-	err = twl_i2c_write_u8(TWL4030_MODULE_PM_MASTER, rd_data,
-				R_P3_SW_EVENTS);
+	err = twl_i2c_write_u8(TWL_MODULE_PM_MASTER, rd_data, R_P3_SW_EVENTS);
 out:
 	if (err)
 		pr_err("TWL4030 warmreset seq config error\n");
@@ -341,7 +323,7 @@ static int __devinit twl4030_configure_resource(struct twl4030_resconfig *rconfi
 	rconfig_addr = res_config_addrs[rconfig->resource];
 
 	/* Set resource group */
-	err = twl_i2c_read_u8(TWL4030_MODULE_PM_RECEIVER, &grp,
+	err = twl_i2c_read_u8(TWL_MODULE_PM_RECEIVER, &grp,
 			      rconfig_addr + DEV_GRP_OFFSET);
 	if (err) {
 		pr_err("TWL4030 Resource %d group could not be read\n",
@@ -352,7 +334,7 @@ static int __devinit twl4030_configure_resource(struct twl4030_resconfig *rconfi
 	if (rconfig->devgroup != TWL4030_RESCONFIG_UNDEF) {
 		grp &= ~DEV_GRP_MASK;
 		grp |= rconfig->devgroup << DEV_GRP_SHIFT;
-		err = twl_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER,
+		err = twl_i2c_write_u8(TWL_MODULE_PM_RECEIVER,
 				       grp, rconfig_addr + DEV_GRP_OFFSET);
 		if (err < 0) {
 			pr_err("TWL4030 failed to program devgroup\n");
@@ -361,7 +343,7 @@ static int __devinit twl4030_configure_resource(struct twl4030_resconfig *rconfi
 	}
 
 	/* Set resource types */
-	err = twl_i2c_read_u8(TWL4030_MODULE_PM_RECEIVER, &type,
+	err = twl_i2c_read_u8(TWL_MODULE_PM_RECEIVER, &type,
 				rconfig_addr + TYPE_OFFSET);
 	if (err < 0) {
 		pr_err("TWL4030 Resource %d type could not be read\n",
@@ -379,7 +361,7 @@ static int __devinit twl4030_configure_resource(struct twl4030_resconfig *rconfi
 		type |= rconfig->type2 << TYPE2_SHIFT;
 	}
 
-	err = twl_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER,
+	err = twl_i2c_write_u8(TWL_MODULE_PM_RECEIVER,
 				type, rconfig_addr + TYPE_OFFSET);
 	if (err < 0) {
 		pr_err("TWL4030 failed to program resource type\n");
@@ -387,7 +369,7 @@ static int __devinit twl4030_configure_resource(struct twl4030_resconfig *rconfi
 	}
 
 	/* Set remap states */
-	err = twl_i2c_read_u8(TWL4030_MODULE_PM_RECEIVER, &remap,
+	err = twl_i2c_read_u8(TWL_MODULE_PM_RECEIVER, &remap,
 			      rconfig_addr + REMAP_OFFSET);
 	if (err < 0) {
 		pr_err("TWL4030 Resource %d remap could not be read\n",
@@ -405,7 +387,7 @@ static int __devinit twl4030_configure_resource(struct twl4030_resconfig *rconfi
 		remap |= rconfig->remap_sleep << SLEEP_STATE_SHIFT;
 	}
 
-	err = twl_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER,
+	err = twl_i2c_write_u8(TWL_MODULE_PM_RECEIVER,
 			       remap,
 			       rconfig_addr + REMAP_OFFSET);
 	if (err < 0) {
@@ -463,49 +445,47 @@ int twl4030_remove_script(u8 flags)
 {
 	int err = 0;
 
-	err = twl_i2c_write_u8(TWL4030_MODULE_PM_MASTER,
-			TWL4030_PM_MASTER_KEY_CFG1,
-			TWL4030_PM_MASTER_PROTECT_KEY);
+	err = twl_i2c_write_u8(TWL_MODULE_PM_MASTER, TWL4030_PM_MASTER_KEY_CFG1,
+			       TWL4030_PM_MASTER_PROTECT_KEY);
 	if (err) {
 		pr_err("twl4030: unable to unlock PROTECT_KEY\n");
 		return err;
 	}
 
-	err = twl_i2c_write_u8(TWL4030_MODULE_PM_MASTER,
-			TWL4030_PM_MASTER_KEY_CFG2,
-			TWL4030_PM_MASTER_PROTECT_KEY);
+	err = twl_i2c_write_u8(TWL_MODULE_PM_MASTER, TWL4030_PM_MASTER_KEY_CFG2,
+			       TWL4030_PM_MASTER_PROTECT_KEY);
 	if (err) {
 		pr_err("twl4030: unable to unlock PROTECT_KEY\n");
 		return err;
 	}
 
 	if (flags & TWL4030_WRST_SCRIPT) {
-		err = twl_i2c_write_u8(TWL4030_MODULE_PM_MASTER, END_OF_SCRIPT,
-				R_SEQ_ADD_WARM);
+		err = twl_i2c_write_u8(TWL_MODULE_PM_MASTER, END_OF_SCRIPT,
+				       R_SEQ_ADD_WARM);
 		if (err)
 			return err;
 	}
 	if (flags & TWL4030_WAKEUP12_SCRIPT) {
-		err = twl_i2c_write_u8(TWL4030_MODULE_PM_MASTER, END_OF_SCRIPT,
-				R_SEQ_ADD_S2A12);
+		err = twl_i2c_write_u8(TWL_MODULE_PM_MASTER, END_OF_SCRIPT,
+				       R_SEQ_ADD_S2A12);
 		if (err)
 			return err;
 	}
 	if (flags & TWL4030_WAKEUP3_SCRIPT) {
-		err = twl_i2c_write_u8(TWL4030_MODULE_PM_MASTER, END_OF_SCRIPT,
-				R_SEQ_ADD_S2A3);
+		err = twl_i2c_write_u8(TWL_MODULE_PM_MASTER, END_OF_SCRIPT,
+				       R_SEQ_ADD_S2A3);
 		if (err)
 			return err;
 	}
 	if (flags & TWL4030_SLEEP_SCRIPT) {
-		err = twl_i2c_write_u8(TWL4030_MODULE_PM_MASTER, END_OF_SCRIPT,
-				R_SEQ_ADD_A2S);
+		err = twl_i2c_write_u8(TWL_MODULE_PM_MASTER, END_OF_SCRIPT,
+				       R_SEQ_ADD_A2S);
 		if (err)
 			return err;
 	}
 
-	err = twl_i2c_write_u8(TWL4030_MODULE_PM_MASTER, 0,
-			TWL4030_PM_MASTER_PROTECT_KEY);
+	err = twl_i2c_write_u8(TWL_MODULE_PM_MASTER, 0,
+			       TWL4030_PM_MASTER_PROTECT_KEY);
 	if (err)
 		pr_err("TWL4030 Unable to relock registers\n");
 
@@ -521,7 +501,7 @@ void twl4030_power_off(void)
 {
 	int err;
 
-	err = twl_i2c_write_u8(TWL4030_MODULE_PM_MASTER, PWR_DEVOFF,
+	err = twl_i2c_write_u8(TWL_MODULE_PM_MASTER, PWR_DEVOFF,
 			       TWL4030_PM_MASTER_P1_SW_EVENTS);
 	if (err)
 		pr_err("TWL4030 Unable to power off\n");
@@ -534,15 +514,13 @@ void __devinit twl4030_power_init(struct twl4030_power_data *twl4030_scripts)
 	struct twl4030_resconfig *resconfig;
 	u8 val, address = twl4030_start_script_address;
 
-	err = twl_i2c_write_u8(TWL4030_MODULE_PM_MASTER,
-			TWL4030_PM_MASTER_KEY_CFG1,
-			TWL4030_PM_MASTER_PROTECT_KEY);
+	err = twl_i2c_write_u8(TWL_MODULE_PM_MASTER, TWL4030_PM_MASTER_KEY_CFG1,
+			       TWL4030_PM_MASTER_PROTECT_KEY);
 	if (err)
 		goto unlock;
 
-	err = twl_i2c_write_u8(TWL4030_MODULE_PM_MASTER,
-			TWL4030_PM_MASTER_KEY_CFG2,
-			TWL4030_PM_MASTER_PROTECT_KEY);
+	err = twl_i2c_write_u8(TWL_MODULE_PM_MASTER, TWL4030_PM_MASTER_KEY_CFG2,
+			       TWL4030_PM_MASTER_PROTECT_KEY);
 	if (err)
 		goto unlock;
 
@@ -567,14 +545,14 @@ void __devinit twl4030_power_init(struct twl4030_power_data *twl4030_scripts)
 	/* Board has to be wired properly to use this feature */
 	if (twl4030_scripts->use_poweroff && !pm_power_off) {
 		/* Default for SEQ_OFFSYNC is set, lets ensure this */
-		err = twl_i2c_read_u8(TWL4030_MODULE_PM_MASTER, &val,
+		err = twl_i2c_read_u8(TWL_MODULE_PM_MASTER, &val,
 				      TWL4030_PM_MASTER_CFG_P123_TRANSITION);
 		if (err) {
 			pr_warning("TWL4030 Unable to read registers\n");
 
 		} else if (!(val & SEQ_OFFSYNC)) {
 			val |= SEQ_OFFSYNC;
-			err = twl_i2c_write_u8(TWL4030_MODULE_PM_MASTER, val,
+			err = twl_i2c_write_u8(TWL_MODULE_PM_MASTER, val,
 					TWL4030_PM_MASTER_CFG_P123_TRANSITION);
 			if (err) {
 				pr_err("TWL4030 Unable to setup SEQ_OFFSYNC\n");
@@ -586,8 +564,8 @@ void __devinit twl4030_power_init(struct twl4030_power_data *twl4030_scripts)
 	}
 
 relock:
-	err = twl_i2c_write_u8(TWL4030_MODULE_PM_MASTER, 0,
-			TWL4030_PM_MASTER_PROTECT_KEY);
+	err = twl_i2c_write_u8(TWL_MODULE_PM_MASTER, 0,
+			       TWL4030_PM_MASTER_PROTECT_KEY);
 	if (err)
 		pr_err("TWL4030 Unable to relock registers\n");
 	return;
-- 
1.8.0

