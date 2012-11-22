Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757407Ab2KVUFM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 15:05:12 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:11049 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753260Ab2KVUFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 15:05:08 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-46-50adda423566
From: Chanwoo Choi <cw00.choi@samsung.com>
To: anton.vorontsov@linaro.org
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH v2 3/3] charger-manager: Split _probe funtion for code clean
Date: Thu, 22 Nov 2012 16:54:26 +0900
Message-id: <1353570866-19523-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.7.0.4
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMLMWRmVeSWpSXmKPExsVy+t8zLV2nW2sDDKZ/VrG4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZq37dZi64G1XRte4JawPjfc8uRk4OCQETib7Ld5ggbDGJC/fW
	s3UxcnEICSxjlPj76DYjTNGzvysYIRLTGSU6r79jgXCWMklcmLicBaSKTUBLYv+LG2wgtoiA
	nMTrtX/BxjIL1Ersu9bECmILC/hI7Gm9BFbDIqAq0baoGyzOK+AqceXHUjaIbQoSrcsOsUPU
	CEh8m3wIaD4HUFxWYtMBZoiSHWwS11/HQ9iSEgdX3GCZwCi4gJFhFaNoakFyQXFSeq6hXnFi
	bnFpXrpecn7uJkZISEntYFzZYHGIUYCDUYmHV9N5bYAQa2JZcWXuIUYJDmYlEd5FBUAh3pTE
	yqrUovz4otKc1OJDjD5Ah0xklhJNzgeGe15JvKGxgbGhoaWhmamlqQEOYSVx3maPlAAhgfTE
	ktTs1NSC1CKYcUwcnFINjBNXaV6tPNDvaZMUXPHc6LNM/4Zz7zium5w1e77ptsaFSYadV1Pe
	9bPXvtSwLmM683dZ+6/NKot+vpP1CyozLjr17c593uYsv6cnFpxufc92/n3lj2/Subo9VXJL
	bb7kGdr/9W0Q3W06e38lr8b1sxoFuWfZqsudfeWE7ulPd12w4NOz1XNzk5VYijMSDbWYi4oT
	Af7yNy1WAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMLMWRmVeSWpSXmKPExsVy+t9jQV2nW2sDDBZfkba4vGsOmwOjx+dN
	cgGMUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlA
	U5UUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhHWMGat+3WYuuBtV0bXuCWsD
	433PLkZODgkBE4lnf1cwQthiEhfurWfrYuTiEBKYzijRef0dC4SzlEniwsTlLCBVbAJaEvtf
	3GADsUUE5CRer/3LBGIzC9RK7LvWxApiCwv4SOxpvQRWwyKgKtG2qBsszivgKnHlx1I2iG0K
	Eq3LDrFPYORewMiwilE0tSC5oDgpPddQrzgxt7g0L10vOT93EyM4ZJ9J7WBc2WBxiFGAg1GJ
	h1fTeW2AEGtiWXFl7iFGCQ5mJRHeRQVAId6UxMqq1KL8+KLSnNTiQ4w+QNsnMkuJJucD4ymv
	JN7Q2MTMyNLIzNjE3NgYh7CSOG+zR0qAkEB6YklqdmpqQWoRzDgmDk6pBsaOjLw1Ey8aODde
	mNSyy+OWqGlyR8TMnDa7fsmLPxtVOr1aDqzqfrOojUP3rrT4tjC+J1L5zzv3TbxWu+v6xM7l
	Rc5fj2bN1ln859VSySijg6b2k14oivLnvzzNYaG/+9jJJce392v4yTxytJ83X/z0Lj0HTs7v
	vP3+8V3d4k/u3X0yp2gGwyslluKMREMt5qLiRABv4w4RhgIAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch split _probe function for readability because
_probe function is longer than 400 line.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/power/charger-manager.c |  279 +++++++++++++++++++++++----------------
 1 files changed, 168 insertions(+), 111 deletions(-)

diff --git a/drivers/power/charger-manager.c b/drivers/power/charger-manager.c
index 17130c7..cc000c4 100644
--- a/drivers/power/charger-manager.c
+++ b/drivers/power/charger-manager.c
@@ -1217,6 +1217,55 @@ static int charger_extcon_init(struct charger_manager *cm,
 	return ret;
 }
 
+/**
+ * charger_manager_register_extcon - Register extcon device to recevie state
+ *				     of charger cable.
+ * @cm: the Charger Manager representing the battery.
+ *
+ * This function support EXTCON(External Connector) subsystem to detect the
+ * state of charger cables for enabling or disabling charger(regulator) and
+ * select the charger cable for charging among a number of external cable
+ * according to policy of H/W board.
+ */
+static int charger_manager_register_extcon(struct charger_manager *cm)
+{
+	struct charger_desc *desc = cm->desc;
+	struct charger_regulator *charger;
+	int ret = 0;
+	int i;
+	int j;
+
+	for (i = 0; i < desc->num_charger_regulators; i++) {
+		charger = &desc->charger_regulators[i];
+
+		charger->consumer = regulator_get(cm->dev,
+					charger->regulator_name);
+		if (charger->consumer == NULL) {
+			dev_err(cm->dev, "Cannot find charger(%s)n",
+					charger->regulator_name);
+			ret = -EINVAL;
+			goto err;
+		}
+		charger->cm = cm;
+
+		for (j = 0; j < charger->num_cables; j++) {
+			struct charger_cable *cable = &charger->cables[j];
+
+			ret = charger_extcon_init(cm, cable);
+			if (ret < 0) {
+				dev_err(cm->dev, "Cannot initialize charger(%s)n",
+						charger->regulator_name);
+				goto err;
+			}
+			cable->charger = charger;
+			cable->cm = cm;
+		}
+	}
+
+err:
+	return ret;
+}
+
 /* help function of sysfs node to control charger(regulator) */
 static ssize_t charger_name_show(struct device *dev,
 				struct device_attribute *attr, char *buf)
@@ -1276,7 +1325,7 @@ static ssize_t charger_externally_control_store(struct device *dev,
 
 	for (i = 0; i < desc->num_charger_regulators; i++) {
 		if (&desc->charger_regulators[i] != charger &&
-			      !desc->charger_regulators[i].externally_control) {
+			!desc->charger_regulators[i].externally_control) {
 			/*
 			 * At least, one charger is controlled by
 			 * charger-manager
@@ -1305,13 +1354,107 @@ static ssize_t charger_externally_control_store(struct device *dev,
 	return count;
 }
 
+/**
+ * charger_manager_register_sysfs - Register sysfs entry for each charger
+ * @cm: the Charger Manager representing the battery.
+ *
+ * This function add sysfs entry for charger(regulator) to control charger from
+ * user-space. If some development board use one more chargers for charging
+ * but only need one charger on specific case which is dependent on user
+ * scenario or hardware restrictions, the user enter 1 or 0(zero) to '/sys/
+ * class/power_supply/battery/charger.[index]/externally_control'. For example,
+ * if user enter 1 to 'sys/class/power_supply/battery/charger.[index]/
+ * externally_control, this charger isn't controlled from charger-manager and
+ * always stay off state of regulator.
+ */
+static int charger_manager_register_sysfs(struct charger_manager *cm)
+{
+	struct charger_desc *desc = cm->desc;
+	struct charger_regulator *charger;
+	int chargers_externally_control = 1;
+	char buf[11];
+	char *str;
+	int ret = 0;
+	int i;
+
+	/* Create sysfs entry to control charger(regulator) */
+	for (i = 0; i < desc->num_charger_regulators; i++) {
+		charger = &desc->charger_regulators[i];
+
+		snprintf(buf, 10, "charger.%d", i);
+		str = kzalloc(sizeof(char) * (strlen(buf) + 1), GFP_KERNEL);
+		if (!str) {
+			dev_err(cm->dev, "Cannot allocate memory: %s\n",
+					charger->regulator_name);
+			ret = -ENOMEM;
+			goto err;
+		}
+		strcpy(str, buf);
+
+		charger->attrs[0] = &charger->attr_name.attr;
+		charger->attrs[1] = &charger->attr_state.attr;
+		charger->attrs[2] = &charger->attr_externally_control.attr;
+		charger->attrs[3] = NULL;
+		charger->attr_g.name = str;
+		charger->attr_g.attrs = charger->attrs;
+
+		sysfs_attr_init(&charger->attr_name.attr);
+		charger->attr_name.attr.name = "name";
+		charger->attr_name.attr.mode = 0444;
+		charger->attr_name.show = charger_name_show;
+
+		sysfs_attr_init(&charger->attr_state.attr);
+		charger->attr_state.attr.name = "state";
+		charger->attr_state.attr.mode = 0444;
+		charger->attr_state.show = charger_state_show;
+
+		sysfs_attr_init(&charger->attr_externally_control.attr);
+		charger->attr_externally_control.attr.name
+				= "externally_control";
+		charger->attr_externally_control.attr.mode = 0644;
+		charger->attr_externally_control.show
+				= charger_externally_control_show;
+		charger->attr_externally_control.store
+				= charger_externally_control_store;
+
+		if (!desc->charger_regulators[i].externally_control ||
+				!chargers_externally_control)
+			chargers_externally_control = 0;
+
+		dev_info(cm->dev, "'%s' regulator's externally_control"
+				"is %d\n", charger->regulator_name,
+				charger->externally_control);
+
+		ret = sysfs_create_group(&cm->charger_psy.dev->kobj,
+					&charger->attr_g);
+		if (ret < 0) {
+			dev_err(cm->dev, "Cannot create sysfs entry"
+					"of %s regulator\n",
+					charger->regulator_name);
+			ret = -EINVAL;
+			goto err;
+		}
+	}
+
+	if (chargers_externally_control) {
+		dev_err(cm->dev, "Cannot register regulator because "
+				"charger-manager must need at least "
+				"one charger for charging battery\n");
+
+		ret = -EINVAL;
+		goto err;
+	}
+
+err:
+	return ret;
+}
+
 static int charger_manager_probe(struct platform_device *pdev)
 {
 	struct charger_desc *desc = dev_get_platdata(&pdev->dev);
 	struct charger_manager *cm;
 	int ret = 0, i = 0;
 	int j = 0;
-	int chargers_externally_control = 1;
 	union power_supply_propval val;
 
 	if (g_desc && !rtc_dev && g_desc->rtc_name) {
@@ -1442,11 +1585,10 @@ static int charger_manager_probe(struct platform_device *pdev)
 
 	memcpy(&cm->charger_psy, &psy_default, sizeof(psy_default));
 
-	if (!desc->psy_name) {
+	if (!desc->psy_name)
 		strncpy(cm->psy_name_buf, psy_default.name, PSY_NAME_MAX);
-	} else {
+	else
 		strncpy(cm->psy_name_buf, desc->psy_name, PSY_NAME_MAX);
-	}
 	cm->charger_psy.name = cm->psy_name_buf;
 
 	/* Allocate for psy properties because they may vary */
@@ -1498,105 +1640,19 @@ static int charger_manager_probe(struct platform_device *pdev)
 		goto err_register;
 	}
 
-	for (i = 0 ; i < desc->num_charger_regulators ; i++) {
-		struct charger_regulator *charger
-					= &desc->charger_regulators[i];
-		char buf[11];
-		char *str;
-
-		charger->consumer = regulator_get(&pdev->dev,
-					charger->regulator_name);
-		if (charger->consumer == NULL) {
-			dev_err(&pdev->dev, "Cannot find charger(%s)n",
-						charger->regulator_name);
-			ret = -EINVAL;
-			goto err_chg_get;
-		}
-		charger->cm = cm;
-
-		for (j = 0 ; j < charger->num_cables ; j++) {
-			struct charger_cable *cable = &charger->cables[j];
-
-			ret = charger_extcon_init(cm, cable);
-			if (ret < 0) {
-				dev_err(&pdev->dev, "Cannot find charger(%s)n",
-						charger->regulator_name);
-				goto err_extcon;
-			}
-			cable->charger = charger;
-			cable->cm = cm;
-		}
-
-		/* Create sysfs entry to control charger(regulator) */
-		snprintf(buf, 10, "charger.%d", i);
-		str = kzalloc(sizeof(char) * (strlen(buf) + 1), GFP_KERNEL);
-		if (!str) {
-			for (i--; i >= 0; i--) {
-				charger = &desc->charger_regulators[i];
-				kfree(charger->attr_g.name);
-			}
-			ret = -ENOMEM;
-
-			goto err_extcon;
-		}
-		strcpy(str, buf);
-
-		charger->attrs[0] = &charger->attr_name.attr;
-		charger->attrs[1] = &charger->attr_state.attr;
-		charger->attrs[2] = &charger->attr_externally_control.attr;
-		charger->attrs[3] = NULL;
-		charger->attr_g.name = str;
-		charger->attr_g.attrs = charger->attrs;
-
-		sysfs_attr_init(&charger->attr_name.attr);
-		charger->attr_name.attr.name = "name";
-		charger->attr_name.attr.mode = 0444;
-		charger->attr_name.show = charger_name_show;
-
-		sysfs_attr_init(&charger->attr_state.attr);
-		charger->attr_state.attr.name = "state";
-		charger->attr_state.attr.mode = 0444;
-		charger->attr_state.show = charger_state_show;
-
-		sysfs_attr_init(&charger->attr_externally_control.attr);
-		charger->attr_externally_control.attr.name
-				= "externally_control";
-		charger->attr_externally_control.attr.mode = 0644;
-		charger->attr_externally_control.show
-				= charger_externally_control_show;
-		charger->attr_externally_control.store
-				= charger_externally_control_store;
-
-		if (!desc->charger_regulators[i].externally_control ||
-				!chargers_externally_control) {
-			chargers_externally_control = 0;
-		}
-		dev_info(&pdev->dev, "'%s' regulator's externally_control"
-				"is %d\n", charger->regulator_name,
-				charger->externally_control);
-
-		ret = sysfs_create_group(&cm->charger_psy.dev->kobj,
-				&charger->attr_g);
-		if (ret < 0) {
-			dev_info(&pdev->dev, "Cannot create sysfs entry"
-					"of %s regulator\n",
-					charger->regulator_name);
-		}
-	}
-
-	if (chargers_externally_control) {
-		dev_err(&pdev->dev, "Cannot register regulator because "
-				"charger-manager must need at least "
-				"one charger for charging battery\n");
-
-		ret = -EINVAL;
-		goto err_chg_enable;
+	/* Register extcon device for charger cable */
+	ret = charger_manager_register_extcon(cm);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "Cannot initialize extcon device\n");
+		goto err_reg_extcon;
 	}
 
-	ret = try_charger_enable(cm, true);
-	if (ret) {
-		dev_err(&pdev->dev, "Cannot enable charger regulators\n");
-		goto err_chg_enable;
+	/* Register sysfs entry for charger(regulator) */
+	ret = charger_manager_register_sysfs(cm);
+	if (ret < 0) {
+		dev_err(&pdev->dev,
+			"Cannot initialize sysfs entry of regulator\n");
+		goto err_reg_sysfs;
 	}
 
 	/* Add to the list */
@@ -1615,27 +1671,28 @@ static int charger_manager_probe(struct platform_device *pdev)
 
 	return 0;
 
-err_chg_enable:
+err_reg_sysfs:
 	for (i = 0; i < desc->num_charger_regulators; i++) {
 		struct charger_regulator *charger;
 
 		charger = &desc->charger_regulators[i];
 		sysfs_remove_group(&cm->charger_psy.dev->kobj,
 				&charger->attr_g);
+
 		kfree(charger->attr_g.name);
 	}
-err_extcon:
-	for (i = 0 ; i < desc->num_charger_regulators ; i++) {
-		struct charger_regulator *charger
-				= &desc->charger_regulators[i];
-		for (j = 0 ; j < charger->num_cables ; j++) {
+err_reg_extcon:
+	for (i = 0; i < desc->num_charger_regulators; i++) {
+		struct charger_regulator *charger;
+
+		charger = &desc->charger_regulators[i];
+		for (j = 0; j < charger->num_cables; j++) {
 			struct charger_cable *cable = &charger->cables[j];
 			extcon_unregister_interest(&cable->extcon_dev);
 		}
-	}
-err_chg_get:
-	for (i = 0 ; i < desc->num_charger_regulators ; i++)
+
 		regulator_put(desc->charger_regulators[i].consumer);
+	}
 
 	power_supply_unregister(&cm->charger_psy);
 err_register:
-- 
1.7.0.4

