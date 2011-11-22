Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753062Ab1KVS7e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 13:59:34 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43299 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750884Ab1KVS7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 13:59:33 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        devicetree-discuss@lists.ozlabs.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: Add basic device tree binding for wm8994
Date: Tue, 22 Nov 2011 18:59:28 +0000
Message-Id: <1321988368-16121-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a placeholder device tree binding for the wm8994 driver. At present
the binding is essentially null as none of the platform data is supported,
and at least some of that will depend on the pending regulator bindings.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 Documentation/devicetree/bindings/sound/wm8994.txt |   18 ++++++++++++++++++
 drivers/mfd/wm8994-core.c                          |    9 +++++++++
 2 files changed, 27 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/sound/wm8994.txt

diff --git a/Documentation/devicetree/bindings/sound/wm8994.txt b/Documentation/devicetree/bindings/sound/wm8994.txt
new file mode 100644
index 0000000..7a7eb1e
--- /dev/null
+++ b/Documentation/devicetree/bindings/sound/wm8994.txt
@@ -0,0 +1,18 @@
+WM1811/WM8994/WM8958 audio CODEC
+
+These devices support both I2C and SPI (configured with pin strapping
+on the board).
+
+Required properties:
+
+  - compatible : "wlf,wm1811", "wlf,wm8994", "wlf,wm8958"
+
+  - reg : the I2C address of the device for I2C, the chip select
+          number for SPI.
+
+Example:
+
+codec: wm8994@1a {
+	compatible = "wlf,wm8994";
+	reg = <0x1a>;
+};
diff --git a/drivers/mfd/wm8994-core.c b/drivers/mfd/wm8994-core.c
index fe7f071..5633fe4 100644
--- a/drivers/mfd/wm8994-core.c
+++ b/drivers/mfd/wm8994-core.c
@@ -545,6 +545,14 @@ static void wm8994_device_exit(struct wm8994 *wm8994)
 	regmap_exit(wm8994->regmap);
 }
 
+static const struct of_device_id wm8994_of_match[] = {
+	{ .compatible = "wlf,wm1811", },
+	{ .compatible = "wlf,wm8994", },
+	{ .compatible = "wlf,wm8958", },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, wm8994_of_match);
+
 static int wm8994_i2c_probe(struct i2c_client *i2c,
 			    const struct i2c_device_id *id)
 {
@@ -612,6 +620,7 @@ static struct i2c_driver wm8994_i2c_driver = {
 		.name = "wm8994",
 		.owner = THIS_MODULE,
 		.pm = &wm8994_pm_ops,
+		.of_match_table = wm8994_of_match,
 	},
 	.probe = wm8994_i2c_probe,
 	.remove = wm8994_i2c_remove,
-- 
1.7.7.3

