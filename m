Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024Ab2L1JaL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 04:30:11 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:2800 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096Ab2L1J35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 04:29:57 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 28 Dec 2012 01:29:50 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <broonie@opensource.wolfsonmicro.com>, <sameo@linux.intel.com>
CC: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <lrg@ti.com>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 1/4] mfd: tps65090: add DT support for tps65090
Date: Fri, 28 Dec 2012 14:59:38 +0530
Message-ID: <1356686981-4152-2-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1356686981-4152-1-git-send-email-ldewangan@nvidia.com>
References: <1356686981-4152-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device tree support for the TI PMIC TPS65090.
The device can be registered through platform or DT.

Add device tree binding document for this device.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 .../devicetree/bindings/regulator/tps65090.txt     |  121 ++++++++++++++++++++
 drivers/mfd/tps65090.c                             |   52 ++++++++-
 include/linux/mfd/tps65090.h                       |    1 +
 3 files changed, 172 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/regulator/tps65090.txt

diff --git a/Documentation/devicetree/bindings/regulator/tps65090.txt b/Documentation/devicetree/bindings/regulator/tps65090.txt
new file mode 100644
index 0000000..e81f47d
--- /dev/null
+++ b/Documentation/devicetree/bindings/regulator/tps65090.txt
@@ -0,0 +1,121 @@
+TPS65090 regulators
+
+Required properties:
+- compatible: "ti,tps65090"
+- reg: I2C slave address
+- interrupts: the interrupt outputs of the controller
+- regulators: A node that houses a sub-node for each regulator within the
+  device. Each sub-node is identified using the node's name (or the deprecated
+  regulator-compatible property if present), with valid values listed below.
+  The content of each sub-node is defined by the standard binding for
+  regulators; see regulator.txt.
+  dcdc[1-3], fet[1-7] and ldo[1-2] respectively.
+- vsys[1-3]-supply: The input supply for DCDC[1-3] respectively.
+- infet[1-7]-supply: The input supply for FET[1-7] respectively.
+- vsys_l[1-2]-supply: The input supply for LDO[1-2] respectively.
+
+Optional properties:
+- ti,enable-ext-control: This is applicable for DCDC1, DCDC2 and DCDC3.
+  If DCDCs are externally controlled then this property should be there.
+- gpio: This is applicable for DCDC1, DCDC2 and DCDC3. If DCDCs are
+  extrenally controlled and if it is from GPIO then gpio number should
+  be provided. If it is externally controlled and no gpio entry then
+  driver will just configure this rails as external control and will not
+  provide any enable/disable APIs.
+
+Each regulator is defined using the standard binding for regulators.
+
+Example:
+
+	tps65090@48 {
+		compatible = "ti,tps65090";
+		reg = <0x48>;
+		interrupts = <0 88 0x4>;
+
+		vsys1-supply = <&some_reg>;
+		vsys2-supply = <&some_reg>;
+		vsys3-supply = <&some_reg>;
+		infet1-supply = <&some_reg>;
+		infet2-supply = <&some_reg>;
+		infet3-supply = <&some_reg>;
+		infet4-supply = <&some_reg>;
+		infet5-supply = <&some_reg>;
+		infet6-supply = <&some_reg>;
+		infet7-supply = <&some_reg>;
+		vsys_l1-supply = <&some_reg>;
+		vsys_l2-supply = <&some_reg>;
+
+		regulators {
+			dcdc1 {
+				regulator-name = "dcdc1";
+				regulator-boot-on;
+				regulator-always-on;
+			};
+
+			dcdc2 {
+				regulator-name = "dcdc2";
+				regulator-boot-on;
+				regulator-always-on;
+			};
+
+			dcdc3 {
+				regulator-name = "dcdc3";
+				regulator-boot-on;
+				regulator-always-on;
+			};
+
+			fet1 {
+				regulator-name = "fet1";
+				regulator-boot-on;
+				regulator-always-on;
+			};
+
+			fet2 {
+				regulator-name = "fet2";
+				regulator-boot-on;
+				regulator-always-on;
+			};
+
+			fet3 {
+				regulator-name = "fet3";
+				regulator-boot-on;
+				regulator-always-on;
+			};
+
+			fet4 {
+				regulator-name = "fet4";
+				regulator-boot-on;
+				regulator-always-on;
+			};
+
+			fet5 {
+				regulator-name = "fet5";
+				regulator-boot-on;
+				regulator-always-on;
+			};
+
+			fet6 {
+				regulator-name = "fet6";
+				regulator-boot-on;
+				regulator-always-on;
+			};
+
+			fet7 {
+				regulator-name = "fet7";
+				regulator-boot-on;
+				regulator-always-on;
+			};
+
+			ldo1 {
+				regulator-name = "ldo1";
+				regulator-boot-on;
+				regulator-always-on;
+			};
+
+			ldo2 {
+				regulator-name = "ldo2";
+				regulator-boot-on;
+				regulator-always-on;
+			};
+		};
+	};
diff --git a/drivers/mfd/tps65090.c b/drivers/mfd/tps65090.c
index 8d12a8e..e4cf030 100644
--- a/drivers/mfd/tps65090.c
+++ b/drivers/mfd/tps65090.c
@@ -25,6 +25,8 @@
 #include <linux/i2c.h>
 #include <linux/mfd/core.h>
 #include <linux/mfd/tps65090.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
 #include <linux/err.h>
 
 #define NUM_INT_REG 2
@@ -148,6 +150,37 @@ static const struct regmap_config tps65090_regmap_config = {
 	.volatile_reg = is_volatile_reg,
 };
 
+#ifdef CONFIG_OF
+static const struct of_device_id tps65090_of_match[] = {
+	{ .compatible = "ti,tps65090",},
+	{},
+};
+MODULE_DEVICE_TABLE(of, tps65090_of_match);
+
+static struct tps65090_platform_data *
+	of_get_tps65090_platform_data(struct device *dev)
+{
+	struct tps65090_platform_data *pdata;
+
+	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
+	if (!pdata) {
+		dev_err(dev, "Memory alloc failed for platform data\n");
+		return ERR_PTR(-ENOMEM);
+	}
+	/*
+	 * Nothing to set/parse here as DT parsing of regulators will be
+	 * done in regulator driver.
+	 */
+	return pdata;
+}
+#else
+static struct tps65090_platform_data *
+	of_get_tps65090_platform_data(struct device *dev)
+{
+	return NULL;
+}
+#endif
+
 static int tps65090_i2c_probe(struct i2c_client *client,
 					const struct i2c_device_id *id)
 {
@@ -155,9 +188,22 @@ static int tps65090_i2c_probe(struct i2c_client *client,
 	struct tps65090 *tps65090;
 	int ret;
 
-	if (!pdata) {
+	if (client->dev.of_node) {
+		const struct of_device_id *match;
+
+		match = of_match_device(of_match_ptr(tps65090_of_match),
+				&client->dev);
+		if (!match) {
+			dev_err(&client->dev, "No match device found\n");
+			return -ENODEV;
+		}
+	}
+
+	if (!pdata && client->dev.of_node)
+		pdata = of_get_tps65090_platform_data(&client->dev);
+	if (IS_ERR_OR_NULL(pdata)) {
 		dev_err(&client->dev, "tps65090 requires platform data\n");
-		return -EINVAL;
+		return (pdata) ? PTR_ERR(pdata) : -EINVAL;
 	}
 
 	tps65090 = devm_kzalloc(&client->dev, sizeof(*tps65090), GFP_KERNEL);
@@ -167,6 +213,7 @@ static int tps65090_i2c_probe(struct i2c_client *client,
 	}
 
 	tps65090->dev = &client->dev;
+	tps65090->pdata = pdata;
 	i2c_set_clientdata(client, tps65090);
 
 	tps65090->rmap = devm_regmap_init_i2c(client, &tps65090_regmap_config);
@@ -247,6 +294,7 @@ static struct i2c_driver tps65090_driver = {
 	.driver	= {
 		.name	= "tps65090",
 		.owner	= THIS_MODULE,
+		.of_match_table = of_match_ptr(tps65090_of_match),
 		.pm	= &tps65090_pm_ops,
 	},
 	.probe		= tps65090_i2c_probe,
diff --git a/include/linux/mfd/tps65090.h b/include/linux/mfd/tps65090.h
index 6694cf4..4403c54 100644
--- a/include/linux/mfd/tps65090.h
+++ b/include/linux/mfd/tps65090.h
@@ -67,6 +67,7 @@ struct tps65090 {
 	struct device		*dev;
 	struct regmap		*rmap;
 	struct regmap_irq_chip_data *irq_data;
+	struct tps65090_platform_data *pdata;
 };
 
 /*
-- 
1.7.1.1

