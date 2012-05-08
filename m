Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751479Ab2EHIZZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 04:25:25 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42387 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253Ab2EHIZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 04:25:21 -0400
Message-ID: <1336465510.11954.1.camel@phoenix>
Subject: [PATCH] ARM: mach-pxa: Use REGULATOR_SUPPLY macro
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Paul Parsons <lost.distance@yahoo.com>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Jonathan Cameron <jic23@cam.ac.uk>,
        Marek Vasut <marek.vasut@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Date: Tue, 08 May 2012 16:25:10 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Eric Miao <eric.y.miao@gmail.com>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Philipp Zabel <philipp.zabel@gmail.com>
Cc: Paul Parsons <lost.distance@yahoo.com>
Cc: Robert Jarzmik <robert.jarzmik@free.fr>
Cc: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Marek Vasut <marek.vasut@gmail.com>
---
 arch/arm/mach-pxa/balloon3.c  |    4 +---
 arch/arm/mach-pxa/cm-x300.c   |    4 +---
 arch/arm/mach-pxa/em-x270.c   |    5 +----
 arch/arm/mach-pxa/hx4700.c    |   13 ++++---------
 arch/arm/mach-pxa/magician.c  |    8 ++------
 arch/arm/mach-pxa/mioa701.c   |    4 +---
 arch/arm/mach-pxa/palm27x.c   |    4 +---
 arch/arm/mach-pxa/spitz.c     |    4 +---
 arch/arm/mach-pxa/stargate2.c |    5 +----
 arch/arm/mach-pxa/vpac270.c   |    4 +---
 arch/arm/mach-pxa/z2.c        |    4 +---
 11 files changed, 15 insertions(+), 44 deletions(-)

diff --git a/arch/arm/mach-pxa/balloon3.c b/arch/arm/mach-pxa/balloon3.c
index 7ece2625..9244493 100644
--- a/arch/arm/mach-pxa/balloon3.c
+++ b/arch/arm/mach-pxa/balloon3.c
@@ -729,9 +729,7 @@ static inline void balloon3_nand_init(void) {}
 #if defined(CONFIG_REGULATOR_MAX1586) || \
     defined(CONFIG_REGULATOR_MAX1586_MODULE)
 static struct regulator_consumer_supply balloon3_max1587a_consumers[] = {
-	{
-		.supply	= "vcc_core",
-	}
+	REGULATOR_SUPPLY("vcc_core", NULL),
 };
 
 static struct regulator_init_data balloon3_max1587a_v3_info = {
diff --git a/arch/arm/mach-pxa/cm-x300.c b/arch/arm/mach-pxa/cm-x300.c
index 3132740..3e4e9fe 100644
--- a/arch/arm/mach-pxa/cm-x300.c
+++ b/arch/arm/mach-pxa/cm-x300.c
@@ -713,9 +713,7 @@ struct da9030_battery_info cm_x300_battery_info = {
 };
 
 static struct regulator_consumer_supply buck2_consumers[] = {
-	{
-		.supply = "vcc_core",
-	},
+	REGULATOR_SUPPLY("vcc_core", NULL),
 };
 
 static struct regulator_init_data buck2_data = {
diff --git a/arch/arm/mach-pxa/em-x270.c b/arch/arm/mach-pxa/em-x270.c
index 2771ad4..97f82ad 100644
--- a/arch/arm/mach-pxa/em-x270.c
+++ b/arch/arm/mach-pxa/em-x270.c
@@ -1082,10 +1082,7 @@ static void __init em_x270_userspace_consumers_init(void)
 /* DA9030 related initializations */
 #define REGULATOR_CONSUMER(_name, _dev_name, _supply)		        \
 	static struct regulator_consumer_supply _name##_consumers[] = {	\
-		{							\
-			.dev_name = _dev_name,				\
-			.supply = _supply,				\
-		},							\
+		REGULATOR_SUPPLY(_supply, _dev_name),			\
 	}
 
 REGULATOR_CONSUMER(ldo3, "reg-userspace-consumer.0", "vcc gps");
diff --git a/arch/arm/mach-pxa/hx4700.c b/arch/arm/mach-pxa/hx4700.c
index b83b95a..88f0f51 100644
--- a/arch/arm/mach-pxa/hx4700.c
+++ b/arch/arm/mach-pxa/hx4700.c
@@ -680,12 +680,8 @@ static struct platform_device power_supply = {
  */
 
 static struct regulator_consumer_supply bq24022_consumers[] = {
-	{
-		.supply = "vbus_draw",
-	},
-	{
-		.supply = "ac_draw",
-	},
+	REGULATOR_SUPPLY("vbus_draw", NULL),
+	REGULATOR_SUPPLY("ac_draw", NULL),
 };
 
 static struct regulator_init_data bq24022_init_data = {
@@ -764,9 +760,8 @@ static struct platform_device strataflash = {
  * Maxim MAX1587A on PI2C
  */
 
-static struct regulator_consumer_supply max1587a_consumer = {
-	.supply = "vcc_core",
-};
+static struct regulator_consumer_supply max1587a_consumer =
+	REGULATOR_SUPPLY("vcc_core", NULL);
 
 static struct regulator_init_data max1587a_v3_info = {
 	.constraints = {
diff --git a/arch/arm/mach-pxa/magician.c b/arch/arm/mach-pxa/magician.c
index 8de0651..2db697c 100644
--- a/arch/arm/mach-pxa/magician.c
+++ b/arch/arm/mach-pxa/magician.c
@@ -579,12 +579,8 @@ static struct platform_device power_supply = {
  */
 
 static struct regulator_consumer_supply bq24022_consumers[] = {
-	{
-		.supply = "vbus_draw",
-	},
-	{
-		.supply = "ac_draw",
-	},
+	REGULATOR_SUPPLY("vbus_draw", NULL),
+	REGULATOR_SUPPLY("ac_draw", NULL),
 };
 
 static struct regulator_init_data bq24022_init_data = {
diff --git a/arch/arm/mach-pxa/mioa701.c b/arch/arm/mach-pxa/mioa701.c
index 061d570..6745149 100644
--- a/arch/arm/mach-pxa/mioa701.c
+++ b/arch/arm/mach-pxa/mioa701.c
@@ -581,9 +581,7 @@ static struct wm97xx_pdata mioa701_wm97xx_pdata = {
  * Voltage regulation
  */
 static struct regulator_consumer_supply max1586_consumers[] = {
-	{
-		.supply = "vcc_core",
-	}
+	REGULATOR_SUPPLY("vcc_core", NULL),
 };
 
 static struct regulator_init_data max1586_v3_info = {
diff --git a/arch/arm/mach-pxa/palm27x.c b/arch/arm/mach-pxa/palm27x.c
index fbc10d7..dad71cf 100644
--- a/arch/arm/mach-pxa/palm27x.c
+++ b/arch/arm/mach-pxa/palm27x.c
@@ -429,9 +429,7 @@ void __init palm27x_power_init(int ac, int usb)
 #if defined(CONFIG_REGULATOR_MAX1586) || \
     defined(CONFIG_REGULATOR_MAX1586_MODULE)
 static struct regulator_consumer_supply palm27x_max1587a_consumers[] = {
-	{
-		.supply	= "vcc_core",
-	}
+	REGULATOR_SUPPLY("vcc_core", NULL),
 };
 
 static struct regulator_init_data palm27x_max1587a_v3_info = {
diff --git a/arch/arm/mach-pxa/spitz.c b/arch/arm/mach-pxa/spitz.c
index df2ab0f..363d91b 100644
--- a/arch/arm/mach-pxa/spitz.c
+++ b/arch/arm/mach-pxa/spitz.c
@@ -877,9 +877,7 @@ static struct i2c_board_info spitz_i2c_devs[] = {
 };
 
 static struct regulator_consumer_supply isl6271a_consumers[] = {
-	{
-		.supply	= "vcc_core",
-	}
+	REGULATOR_SUPPLY("vcc_core", NULL),
 };
 
 static struct regulator_init_data isl6271a_info[] = {
diff --git a/arch/arm/mach-pxa/stargate2.c b/arch/arm/mach-pxa/stargate2.c
index 4cd645e..30b1b0b 100644
--- a/arch/arm/mach-pxa/stargate2.c
+++ b/arch/arm/mach-pxa/stargate2.c
@@ -151,10 +151,7 @@ static struct platform_device sht15 = {
 };
 
 static struct regulator_consumer_supply stargate2_sensor_3_con[] = {
-	{
-		.dev_name = "sht15",
-		.supply = "vcc",
-	},
+	REGULATOR_SUPPLY("vcc", "sht15"),
 };
 
 enum stargate2_ldos{
diff --git a/arch/arm/mach-pxa/vpac270.c b/arch/arm/mach-pxa/vpac270.c
index c57ab63..e1740ac 100644
--- a/arch/arm/mach-pxa/vpac270.c
+++ b/arch/arm/mach-pxa/vpac270.c
@@ -640,9 +640,7 @@ static inline void vpac270_ide_init(void) {}
 #if defined(CONFIG_REGULATOR_MAX1586) || \
     defined(CONFIG_REGULATOR_MAX1586_MODULE)
 static struct regulator_consumer_supply vpac270_max1587a_consumers[] = {
-	{
-		.supply	= "vcc_core",
-	}
+	REGULATOR_SUPPLY("vcc_core", NULL),
 };
 
 static struct regulator_init_data vpac270_max1587a_v3_info = {
diff --git a/arch/arm/mach-pxa/z2.c b/arch/arm/mach-pxa/z2.c
index fa86199..b9320cb 100644
--- a/arch/arm/mach-pxa/z2.c
+++ b/arch/arm/mach-pxa/z2.c
@@ -615,9 +615,7 @@ static inline void z2_spi_init(void) {}
 #if defined(CONFIG_REGULATOR_TPS65023) || \
 	defined(CONFIG_REGULATOR_TPS65023_MODULE)
 static struct regulator_consumer_supply z2_tps65021_consumers[] = {
-	{
-		.supply	= "vcc_core",
-	}
+	REGULATOR_SUPPLY("vcc_core", NULL),
 };
 
 static struct regulator_init_data z2_tps65021_info[] = {
-- 
1.7.5.4



