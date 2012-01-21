Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751335Ab2AUSmt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 13:42:49 -0500
Received: from mail2.nsc.com ([12.238.8.132]:43967 "EHLO sc-mailgw05.nsc.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750980Ab2AUSms (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 13:42:48 -0500
X-WSS-ID: 0LY5VZA-0A-3UE-02
X-M-MSG: 
X-Server-Uuid: 75984BC7-5B1D-45FA-89A9-3E7188D47FBE
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "Axel Lin" <axel.lin@gmail.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Ryan Mallon" <rmallon@gmail.com>,
        "Jeong, Daniel" <Daniel.Jeong@nsc.com>,
        "Minkyu Kang" <mk7.kang@samsung.com>,
        "MyungJoo Ham" <myungjoo.ham@samsung.com>,
        "Rhyland Klein" <rklein@nvidia.com>,
        "Peter Edwards" <sweetlilmre@gmail.com>,
        "Anton Vorontsov" <cbouatmailru@gmail.com>
Date: Sat, 21 Jan 2012 10:42:34 -0800
Subject: RE: [PATCH] power_supply: Convert power_supply i2c drivers to
 module_i2c_driver
Thread-Topic: [PATCH] power_supply: Convert power_supply i2c drivers to
 module_i2c_driver
Thread-Index: AczYB/Agy0eKb0QySZCFN8k+/v9KFwAZBGIw
Message-ID: <B567DBAB974C0544994013492B949F8E3812CD380E@EXMAIL03.scwf.nsc.com>
References: <1327128174.24831.1.camel@phoenix>
In-Reply-To: <1327128174.24831.1.camel@phoenix>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ko-KR, en-US
MIME-Version: 1.0
X-WSS-ID: 6305D8971LS9843504-03-01
Content-Type: text/plain;
 charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q0LIgvgb011906

For lp8727_charger:
Acked-by: Milo(Woogyom) Kim <milo.kim@ti.com>

Thanks !

Best Regards,
Milo -

-----Original Message-----
From: Axel Lin [mailto:axel.lin@gmail.com] 
Sent: Saturday, January 21, 2012 3:43 PM
To: linux-kernel@vger.kernel.org
Cc: Ryan Mallon; Kim, Milo; Jeong, Daniel; Minkyu Kang; MyungJoo Ham; Rhyland Klein; Peter Edwards; Anton Vorontsov
Subject: [PATCH] power_supply: Convert power_supply i2c drivers to module_i2c_driver

Factor out some boilerplate code for i2c driver registration
into module_i2c_driver.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Ryan Mallon <rmallon@gmail.com>
Cc: Woogyom Kim <milo.kim@ti.com>
Cc: Daniel Jeong <daniel.jeong@ti.com>
Cc: Minkyu Kang <mk7.kang@samsung.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: Rhyland Klein <rklein@nvidia.com>
Cc: Peter Edwards <sweetlilmre@gmail.com>
---
 drivers/power/ds2782_battery.c   |   12 +-----------
 drivers/power/lp8727_charger.c   |   13 +------------
 drivers/power/max17040_battery.c |   12 +-----------
 drivers/power/max17042_battery.c |   12 +-----------
 drivers/power/sbs-battery.c      |   12 +-----------
 drivers/power/z2_battery.c       |   13 +------------
 6 files changed, 6 insertions(+), 68 deletions(-)

diff --git a/drivers/power/ds2782_battery.c b/drivers/power/ds2782_battery.c
index bfbce5d..6e3d76a 100644
--- a/drivers/power/ds2782_battery.c
+++ b/drivers/power/ds2782_battery.c
@@ -404,17 +404,7 @@ static struct i2c_driver ds278x_battery_driver = {
 	.id_table	= ds278x_id,
 };
 
-static int __init ds278x_init(void)
-{
-	return i2c_add_driver(&ds278x_battery_driver);
-}
-module_init(ds278x_init);
-
-static void __exit ds278x_exit(void)
-{
-	i2c_del_driver(&ds278x_battery_driver);
-}
-module_exit(ds278x_exit);
+module_i2c_driver(ds278x_battery_driver);
 
 MODULE_AUTHOR("Ryan Mallon");
 MODULE_DESCRIPTION("Maxim/Dallas DS2782 Stand-Alone Fuel Gauage IC driver");
diff --git a/drivers/power/lp8727_charger.c b/drivers/power/lp8727_charger.c
index b15b575..30de637 100644
--- a/drivers/power/lp8727_charger.c
+++ b/drivers/power/lp8727_charger.c
@@ -475,18 +475,7 @@ static struct i2c_driver lp8727_driver = {
 	.id_table = lp8727_ids,
 };
 
-static int __init lp8727_init(void)
-{
-	return i2c_add_driver(&lp8727_driver);
-}
-
-static void __exit lp8727_exit(void)
-{
-	i2c_del_driver(&lp8727_driver);
-}
-
-module_init(lp8727_init);
-module_exit(lp8727_exit);
+module_i2c_driver(lp8727_driver);
 
 MODULE_DESCRIPTION("National Semiconductor LP8727 charger driver");
 MODULE_AUTHOR
diff --git a/drivers/power/max17040_battery.c b/drivers/power/max17040_battery.c
index 2f2f9a6..1c8dd0e 100644
--- a/drivers/power/max17040_battery.c
+++ b/drivers/power/max17040_battery.c
@@ -291,17 +291,7 @@ static struct i2c_driver max17040_i2c_driver = {
 	.id_table	= max17040_id,
 };
 
-static int __init max17040_init(void)
-{
-	return i2c_add_driver(&max17040_i2c_driver);
-}
-module_init(max17040_init);
-
-static void __exit max17040_exit(void)
-{
-	i2c_del_driver(&max17040_i2c_driver);
-}
-module_exit(max17040_exit);
+module_i2c_driver(max17040_i2c_driver);
 
 MODULE_AUTHOR("Minkyu Kang <mk7.kang@samsung.com>");
 MODULE_DESCRIPTION("MAX17040 Fuel Gauge");
diff --git a/drivers/power/max17042_battery.c b/drivers/power/max17042_battery.c
index 86acee2..b2fd9e2 100644
--- a/drivers/power/max17042_battery.c
+++ b/drivers/power/max17042_battery.c
@@ -288,17 +288,7 @@ static struct i2c_driver max17042_i2c_driver = {
 	.id_table	= max17042_id,
 };
 
-static int __init max17042_init(void)
-{
-	return i2c_add_driver(&max17042_i2c_driver);
-}
-module_init(max17042_init);
-
-static void __exit max17042_exit(void)
-{
-	i2c_del_driver(&max17042_i2c_driver);
-}
-module_exit(max17042_exit);
+module_i2c_driver(max17042_i2c_driver);
 
 MODULE_AUTHOR("MyungJoo Ham <myungjoo.ham@samsung.com>");
 MODULE_DESCRIPTION("MAX17042 Fuel Gauge");
diff --git a/drivers/power/sbs-battery.c b/drivers/power/sbs-battery.c
index 9ff8af0..4f05498 100644
--- a/drivers/power/sbs-battery.c
+++ b/drivers/power/sbs-battery.c
@@ -853,17 +853,7 @@ static struct i2c_driver sbs_battery_driver = {
 	},
 };
 
-static int __init sbs_battery_init(void)
-{
-	return i2c_add_driver(&sbs_battery_driver);
-}
-module_init(sbs_battery_init);
-
-static void __exit sbs_battery_exit(void)
-{
-	i2c_del_driver(&sbs_battery_driver);
-}
-module_exit(sbs_battery_exit);
+module_i2c_driver(sbs_battery_driver);
 
 MODULE_DESCRIPTION("SBS battery monitor driver");
 MODULE_LICENSE("GPL");
diff --git a/drivers/power/z2_battery.c b/drivers/power/z2_battery.c
index 636ebb2..15c3fba 100644
--- a/drivers/power/z2_battery.c
+++ b/drivers/power/z2_battery.c
@@ -317,18 +317,7 @@ static struct i2c_driver z2_batt_driver = {
 	.id_table	= z2_batt_id,
 };
 
-static int __init z2_batt_init(void)
-{
-	return i2c_add_driver(&z2_batt_driver);
-}
-
-static void __exit z2_batt_exit(void)
-{
-	i2c_del_driver(&z2_batt_driver);
-}
-
-module_init(z2_batt_init);
-module_exit(z2_batt_exit);
+module_i2c_driver(z2_batt_driver);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Peter Edwards <sweetlilmre@gmail.com>");
-- 
1.7.5.4



ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
