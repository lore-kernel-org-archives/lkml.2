Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341Ab2DRAwi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 20:52:38 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45064 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751903Ab2DRAwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 20:52:37 -0400
Message-ID: <1334710348.3020.3.camel@phoenix>
Subject: [PATCH] regulator: Remove unneeded include of linux/delay.h from
 regulator drivers
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Wed, 18 Apr 2012 08:52:28 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All the drivers that need delay for the regulator voltage output voltage to
stabilize after being enabled or after being set to a new value has been
converted to implement enable_time and set_voltage_time_sel callbacks.
Then regulator core will take care of the necessary delay.

For the drivers that don't need the delay, don't need to include linux/delay.h.
This patch removes the unneeded include of linux/delay.h in regulator drivers.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/aat2870-regulator.c  |    1 -
 drivers/regulator/ab3100.c             |    1 -
 drivers/regulator/fixed.c              |    1 -
 drivers/regulator/gpio-regulator.c     |    1 -
 drivers/regulator/isl6271a-regulator.c |    1 -
 drivers/regulator/max8997.c            |    1 -
 drivers/regulator/max8998.c            |    1 -
 drivers/regulator/rc5t583-regulator.c  |    1 -
 drivers/regulator/s5m8767.c            |    1 -
 drivers/regulator/tps62360-regulator.c |    1 -
 drivers/regulator/tps65023-regulator.c |    1 -
 drivers/regulator/tps6507x-regulator.c |    1 -
 drivers/regulator/tps65090-regulator.c |    1 -
 drivers/regulator/tps65910-regulator.c |    1 -
 drivers/regulator/tps65912-regulator.c |    1 -
 drivers/regulator/twl-regulator.c      |    1 -
 16 files changed, 0 insertions(+), 16 deletions(-)

diff --git a/drivers/regulator/aat2870-regulator.c b/drivers/regulator/aat2870-regulator.c
index 7f000d6..06776ca 100644
--- a/drivers/regulator/aat2870-regulator.c
+++ b/drivers/regulator/aat2870-regulator.c
@@ -24,7 +24,6 @@
 #include <linux/err.h>
 #include <linux/module.h>
 #include <linux/slab.h>
-#include <linux/delay.h>
 #include <linux/platform_device.h>
 #include <linux/regulator/driver.h>
 #include <linux/regulator/machine.h>
diff --git a/drivers/regulator/ab3100.c b/drivers/regulator/ab3100.c
index ce61925..e2062ad 100644
--- a/drivers/regulator/ab3100.c
+++ b/drivers/regulator/ab3100.c
@@ -13,7 +13,6 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/err.h>
-#include <linux/delay.h>
 #include <linux/platform_device.h>
 #include <linux/regulator/driver.h>
 #include <linux/mfd/abx500.h>
diff --git a/drivers/regulator/fixed.c b/drivers/regulator/fixed.c
index b47b005..bd437c1 100644
--- a/drivers/regulator/fixed.c
+++ b/drivers/regulator/fixed.c
@@ -25,7 +25,6 @@
 #include <linux/regulator/driver.h>
 #include <linux/regulator/fixed.h>
 #include <linux/gpio.h>
-#include <linux/delay.h>
 #include <linux/slab.h>
 #include <linux/of.h>
 #include <linux/of_gpio.h>
diff --git a/drivers/regulator/gpio-regulator.c b/drivers/regulator/gpio-regulator.c
index f93b06b..9997d7a 100644
--- a/drivers/regulator/gpio-regulator.c
+++ b/drivers/regulator/gpio-regulator.c
@@ -30,7 +30,6 @@
 #include <linux/regulator/machine.h>
 #include <linux/regulator/gpio-regulator.h>
 #include <linux/gpio.h>
-#include <linux/delay.h>
 #include <linux/slab.h>
 
 struct gpio_regulator_data {
diff --git a/drivers/regulator/isl6271a-regulator.c b/drivers/regulator/isl6271a-regulator.c
index 60044c3..5caaf1f 100644
--- a/drivers/regulator/isl6271a-regulator.c
+++ b/drivers/regulator/isl6271a-regulator.c
@@ -22,7 +22,6 @@
 #include <linux/platform_device.h>
 #include <linux/regulator/driver.h>
 #include <linux/i2c.h>
-#include <linux/delay.h>
 #include <linux/slab.h>
 
 #define	ISL6271A_VOLTAGE_MIN	850000
diff --git a/drivers/regulator/max8997.c b/drivers/regulator/max8997.c
index f4ab2e3..01172c2 100644
--- a/drivers/regulator/max8997.c
+++ b/drivers/regulator/max8997.c
@@ -22,7 +22,6 @@
  */
 
 #include <linux/bug.h>
-#include <linux/delay.h>
 #include <linux/err.h>
 #include <linux/gpio.h>
 #include <linux/slab.h>
diff --git a/drivers/regulator/max8998.c b/drivers/regulator/max8998.c
index 4ca22f9..052ee35 100644
--- a/drivers/regulator/max8998.c
+++ b/drivers/regulator/max8998.c
@@ -28,7 +28,6 @@
 #include <linux/slab.h>
 #include <linux/interrupt.h>
 #include <linux/mutex.h>
-#include <linux/delay.h>
 #include <linux/platform_device.h>
 #include <linux/regulator/driver.h>
 #include <linux/mfd/max8998.h>
diff --git a/drivers/regulator/rc5t583-regulator.c b/drivers/regulator/rc5t583-regulator.c
index 81a74d1..f35dc527 100644
--- a/drivers/regulator/rc5t583-regulator.c
+++ b/drivers/regulator/rc5t583-regulator.c
@@ -23,7 +23,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/delay.h>
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/err.h>
diff --git a/drivers/regulator/s5m8767.c b/drivers/regulator/s5m8767.c
index cb53187..a31d358 100644
--- a/drivers/regulator/s5m8767.c
+++ b/drivers/regulator/s5m8767.c
@@ -12,7 +12,6 @@
  */
 
 #include <linux/bug.h>
-#include <linux/delay.h>
 #include <linux/err.h>
 #include <linux/gpio.h>
 #include <linux/slab.h>
diff --git a/drivers/regulator/tps62360-regulator.c b/drivers/regulator/tps62360-regulator.c
index 0657c98..20fef1d 100644
--- a/drivers/regulator/tps62360-regulator.c
+++ b/drivers/regulator/tps62360-regulator.c
@@ -32,7 +32,6 @@
 #include <linux/regulator/tps62360.h>
 #include <linux/gpio.h>
 #include <linux/i2c.h>
-#include <linux/delay.h>
 #include <linux/slab.h>
 #include <linux/regmap.h>
 
diff --git a/drivers/regulator/tps65023-regulator.c b/drivers/regulator/tps65023-regulator.c
index a1fd656..f841bd0 100644
--- a/drivers/regulator/tps65023-regulator.c
+++ b/drivers/regulator/tps65023-regulator.c
@@ -23,7 +23,6 @@
 #include <linux/regulator/driver.h>
 #include <linux/regulator/machine.h>
 #include <linux/i2c.h>
-#include <linux/delay.h>
 #include <linux/slab.h>
 #include <linux/regmap.h>
 
diff --git a/drivers/regulator/tps6507x-regulator.c b/drivers/regulator/tps6507x-regulator.c
index 8e432004b..9dfc98b 100644
--- a/drivers/regulator/tps6507x-regulator.c
+++ b/drivers/regulator/tps6507x-regulator.c
@@ -23,7 +23,6 @@
 #include <linux/regulator/driver.h>
 #include <linux/regulator/machine.h>
 #include <linux/regulator/tps6507x.h>
-#include <linux/delay.h>
 #include <linux/slab.h>
 #include <linux/mfd/tps6507x.h>
 
diff --git a/drivers/regulator/tps65090-regulator.c b/drivers/regulator/tps65090-regulator.c
index 299237d..c44b448 100644
--- a/drivers/regulator/tps65090-regulator.c
+++ b/drivers/regulator/tps65090-regulator.c
@@ -17,7 +17,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/delay.h>
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/err.h>
diff --git a/drivers/regulator/tps65910-regulator.c b/drivers/regulator/tps65910-regulator.c
index fe66a2c..3d9c54f 100644
--- a/drivers/regulator/tps65910-regulator.c
+++ b/drivers/regulator/tps65910-regulator.c
@@ -20,7 +20,6 @@
 #include <linux/platform_device.h>
 #include <linux/regulator/driver.h>
 #include <linux/regulator/machine.h>
-#include <linux/delay.h>
 #include <linux/slab.h>
 #include <linux/gpio.h>
 #include <linux/mfd/tps65910.h>
diff --git a/drivers/regulator/tps65912-regulator.c b/drivers/regulator/tps65912-regulator.c
index af335dd..7312e36 100644
--- a/drivers/regulator/tps65912-regulator.c
+++ b/drivers/regulator/tps65912-regulator.c
@@ -20,7 +20,6 @@
 #include <linux/platform_device.h>
 #include <linux/regulator/driver.h>
 #include <linux/regulator/machine.h>
-#include <linux/delay.h>
 #include <linux/slab.h>
 #include <linux/gpio.h>
 #include <linux/mfd/tps65912.h>
diff --git a/drivers/regulator/twl-regulator.c b/drivers/regulator/twl-regulator.c
index 7385b27..fffacb4 100644
--- a/drivers/regulator/twl-regulator.c
+++ b/drivers/regulator/twl-regulator.c
@@ -12,7 +12,6 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/err.h>
-#include <linux/delay.h>
 #include <linux/platform_device.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
-- 
1.7.5.4



