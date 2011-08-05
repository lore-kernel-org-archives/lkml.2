Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756543Ab1HEVYq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 17:24:46 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:55591 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756164Ab1HEVYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 17:24:39 -0400
From: Rob Herring <robherring2@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@lists.ozlabs.org, Ben Dooks <ben-linux@fluff.org>
Subject: [PATCH 3/3] i2c-designware: add OF binding support
Date: Fri,  5 Aug 2011 16:24:28 -0500
Message-Id: <1312579468-19365-4-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1312579468-19365-1-git-send-email-robherring2@gmail.com>
References: <1312579468-19365-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

Add of_match_table and DT style i2c registration to designware i2c
driver.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Acked-by: Grant Likely <grant.likely@secretlab.ca>
Cc: devicetree-discuss@lists.ozlabs.org
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: linux-i2c@vger.kernel.org
---
 Documentation/devicetree/bindings/i2c/dw-i2c.txt |   23 ++++++++++++++++++++++
 drivers/i2c/busses/i2c-designware.c              |    8 +++++++
 2 files changed, 31 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/i2c/dw-i2c.txt

diff --git a/Documentation/devicetree/bindings/i2c/dw-i2c.txt b/Documentation/devicetree/bindings/i2c/dw-i2c.txt
new file mode 100644
index 0000000..cbcb404
--- /dev/null
+++ b/Documentation/devicetree/bindings/i2c/dw-i2c.txt
@@ -0,0 +1,23 @@
+* Synopsys DesignWare I2C
+
+Required properties :
+
+ - compatible : should be "snps,designware-i2c"
+ - reg : Offset and length of the register set for the device
+ - interrupts : <IRQ> where IRQ is the interrupt number.
+
+Recommended properties :
+
+ - clock-frequency : desired I2C bus clock frequency in Hz.
+
+Example :
+
+	i2c@f0000 {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		compatible = "snps,designware-i2c";
+		reg = <0xf0000 0x1000>;
+		interrupts = <11>;
+		clock-frequency = <400000>;
+	};
+
diff --git a/drivers/i2c/busses/i2c-designware.c b/drivers/i2c/busses/i2c-designware.c
index b7a51c4..0223b98 100644
--- a/drivers/i2c/busses/i2c-designware.c
+++ b/drivers/i2c/busses/i2c-designware.c
@@ -769,6 +769,7 @@ static int __devinit dw_i2c_probe(struct platform_device *pdev)
 			sizeof(adap->name));
 	adap->algo = &i2c_dw_algo;
 	adap->dev.parent = &pdev->dev;
+	adap->dev.of_node = pdev->dev.of_node;
 
 	adap->nr = pdev->id;
 	r = i2c_add_numbered_adapter(adap);
@@ -819,6 +820,12 @@ static int __devexit dw_i2c_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static const struct of_device_id dw_i2c_of_match[] = {
+	{ .compatible = "snps,designware-i2c", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, dw_i2c_of_match);
+
 /* work with hotplug and coldplug */
 MODULE_ALIAS("platform:i2c_designware");
 
@@ -827,6 +834,7 @@ static struct platform_driver dw_i2c_driver = {
 	.driver		= {
 		.name	= "i2c_designware",
 		.owner	= THIS_MODULE,
+		.of_match_table = dw_i2c_of_match,
 	},
 };
 
-- 
1.7.4.1

