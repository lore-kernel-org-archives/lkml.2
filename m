Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757397Ab2ATATk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 19:19:40 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:40294 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756222Ab2ATATi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 19:19:38 -0500
Message-ID: <1327018768.7293.3.camel@phoenix>
Subject: [PATCH 2/2] rtc: Convert rtc i2c drivers to module_i2c_driver
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Piotr Ziecik <kosmo@semihalf.com>, Alessandro Zummo <a.zummo@towertech.it>,
        Scott Wood <scottwood@freescale.com>,
        Srikanth Srinivasan <srikanth.srinivasan@freescale.com>,
        Mike Rapoport <mike@compulab.co.il>, Sergey Lapin <slapin@ossfans.org>,
        Roman Fietze <roman.fietze@telemotive.de>,
        Herbert Valerio Riedel <hvr@gnu.org>, Alexander Bigga <ab@mycable.de>,
        Dale Farnsworth <dale@farnsworth.org>,
        Gregory Hermant <gregory.hermant@calao-systems.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Martyn Welch <martyn.welch@ge.com>,
        Byron Bradley <byron.bbradley@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, rtc-linux@googlegroups.com
Date: Fri, 20 Jan 2012 08:19:28 +0800
In-Reply-To: <1327018592.7293.1.camel@phoenix>
References: <1327018592.7293.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factor out some boilerplate code for i2c driver registration
into module_i2c_driver.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Piotr Ziecik <kosmo@semihalf.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Scott Wood <scottwood@freescale.com>
Cc: Srikanth Srinivasan <srikanth.srinivasan@freescale.com>
Cc: Mike Rapoport <mike@compulab.co.il>
Cc: Sergey Lapin <slapin@ossfans.org>
Cc: Roman Fietze <roman.fietze@telemotive.de>
Cc: Herbert Valerio Riedel <hvr@gnu.org>
Cc: Alexander Bigga <ab@mycable.de>
Cc: Dale Farnsworth <dale@farnsworth.org>
Cc: Gregory Hermant <gregory.hermant@calao-systems.com>
Cc: Wolfgang Grandegger <wg@grandegger.com>
Cc: Martyn Welch <martyn.welch@ge.com>
Cc: Byron Bradley <byron.bbradley@gmail.com>
---
 drivers/rtc/rtc-bq32k.c    |   12 +-----------
 drivers/rtc/rtc-ds1307.c   |   12 +-----------
 drivers/rtc/rtc-ds1374.c   |   13 +------------
 drivers/rtc/rtc-ds1672.c   |   13 +------------
 drivers/rtc/rtc-ds3232.c   |   13 +------------
 drivers/rtc/rtc-em3027.c   |   13 +------------
 drivers/rtc/rtc-fm3130.c   |   12 +-----------
 drivers/rtc/rtc-isl12022.c |   13 +------------
 drivers/rtc/rtc-isl1208.c  |   15 +--------------
 drivers/rtc/rtc-m41t80.c   |   13 +------------
 drivers/rtc/rtc-max6900.c  |   13 +------------
 drivers/rtc/rtc-pcf8563.c  |   13 +------------
 drivers/rtc/rtc-pcf8583.c  |   13 +------------
 drivers/rtc/rtc-rs5c372.c  |   13 +------------
 drivers/rtc/rtc-rv3029c2.c |   13 +------------
 drivers/rtc/rtc-rx8025.c   |   13 +------------
 drivers/rtc/rtc-rx8581.c   |   13 +------------
 drivers/rtc/rtc-s35390a.c  |   13 +------------
 drivers/rtc/rtc-x1205.c    |   13 +------------
 19 files changed, 19 insertions(+), 227 deletions(-)

diff --git a/drivers/rtc/rtc-bq32k.c b/drivers/rtc/rtc-bq32k.c
index 408cc8f..f090159 100644
--- a/drivers/rtc/rtc-bq32k.c
+++ b/drivers/rtc/rtc-bq32k.c
@@ -187,17 +187,7 @@ static struct i2c_driver bq32k_driver = {
 	.id_table	= bq32k_id,
 };
 
-static __init int bq32k_init(void)
-{
-	return i2c_add_driver(&bq32k_driver);
-}
-module_init(bq32k_init);
-
-static __exit void bq32k_exit(void)
-{
-	i2c_del_driver(&bq32k_driver);
-}
-module_exit(bq32k_exit);
+module_i2c_driver(bq32k_driver);
 
 MODULE_AUTHOR("Semihalf, Piotr Ziecik <kosmo@semihalf.com>");
 MODULE_DESCRIPTION("TI BQ32000 I2C RTC driver");
diff --git a/drivers/rtc/rtc-ds1307.c b/drivers/rtc/rtc-ds1307.c
index 62b0763..58edcb0 100644
--- a/drivers/rtc/rtc-ds1307.c
+++ b/drivers/rtc/rtc-ds1307.c
@@ -938,17 +938,7 @@ static struct i2c_driver ds1307_driver = {
 	.id_table	= ds1307_id,
 };
 
-static int __init ds1307_init(void)
-{
-	return i2c_add_driver(&ds1307_driver);
-}
-module_init(ds1307_init);
-
-static void __exit ds1307_exit(void)
-{
-	i2c_del_driver(&ds1307_driver);
-}
-module_exit(ds1307_exit);
+module_i2c_driver(ds1307_driver);
 
 MODULE_DESCRIPTION("RTC driver for DS1307 and similar chips");
 MODULE_LICENSE("GPL");
diff --git a/drivers/rtc/rtc-ds1374.c b/drivers/rtc/rtc-ds1374.c
index e6e71de..9663160 100644
--- a/drivers/rtc/rtc-ds1374.c
+++ b/drivers/rtc/rtc-ds1374.c
@@ -446,18 +446,7 @@ static struct i2c_driver ds1374_driver = {
 	.id_table = ds1374_id,
 };
 
-static int __init ds1374_init(void)
-{
-	return i2c_add_driver(&ds1374_driver);
-}
-
-static void __exit ds1374_exit(void)
-{
-	i2c_del_driver(&ds1374_driver);
-}
-
-module_init(ds1374_init);
-module_exit(ds1374_exit);
+module_i2c_driver(ds1374_driver);
 
 MODULE_AUTHOR("Scott Wood <scottwood@freescale.com>");
 MODULE_DESCRIPTION("Maxim/Dallas DS1374 RTC Driver");
diff --git a/drivers/rtc/rtc-ds1672.c b/drivers/rtc/rtc-ds1672.c
index a319402..7fa67d0 100644
--- a/drivers/rtc/rtc-ds1672.c
+++ b/drivers/rtc/rtc-ds1672.c
@@ -202,20 +202,9 @@ static struct i2c_driver ds1672_driver = {
 	.id_table = ds1672_id,
 };
 
-static int __init ds1672_init(void)
-{
-	return i2c_add_driver(&ds1672_driver);
-}
-
-static void __exit ds1672_exit(void)
-{
-	i2c_del_driver(&ds1672_driver);
-}
+module_i2c_driver(ds1672_driver);
 
 MODULE_AUTHOR("Alessandro Zummo <a.zummo@towertech.it>");
 MODULE_DESCRIPTION("Dallas/Maxim DS1672 timekeeper driver");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_VERSION);
-
-module_init(ds1672_init);
-module_exit(ds1672_exit);
diff --git a/drivers/rtc/rtc-ds3232.c b/drivers/rtc/rtc-ds3232.c
index 27b7bf6..e194509 100644
--- a/drivers/rtc/rtc-ds3232.c
+++ b/drivers/rtc/rtc-ds3232.c
@@ -473,18 +473,7 @@ static struct i2c_driver ds3232_driver = {
 	.id_table = ds3232_id,
 };
 
-static int __init ds3232_init(void)
-{
-	return i2c_add_driver(&ds3232_driver);
-}
-
-static void __exit ds3232_exit(void)
-{
-	i2c_del_driver(&ds3232_driver);
-}
-
-module_init(ds3232_init);
-module_exit(ds3232_exit);
+module_i2c_driver(ds3232_driver);
 
 MODULE_AUTHOR("Srikanth Srinivasan <srikanth.srinivasan@freescale.com>");
 MODULE_DESCRIPTION("Maxim/Dallas DS3232 RTC Driver");
diff --git a/drivers/rtc/rtc-em3027.c b/drivers/rtc/rtc-em3027.c
index 8414dea..0104ea7 100644
--- a/drivers/rtc/rtc-em3027.c
+++ b/drivers/rtc/rtc-em3027.c
@@ -144,19 +144,8 @@ static struct i2c_driver em3027_driver = {
 	.id_table = em3027_id,
 };
 
-static int __init em3027_init(void)
-{
-	return i2c_add_driver(&em3027_driver);
-}
-
-static void __exit em3027_exit(void)
-{
-	i2c_del_driver(&em3027_driver);
-}
+module_i2c_driver(em3027_driver);
 
 MODULE_AUTHOR("Mike Rapoport <mike@compulab.co.il>");
 MODULE_DESCRIPTION("EM Microelectronic EM3027 RTC driver");
 MODULE_LICENSE("GPL");
-
-module_init(em3027_init);
-module_exit(em3027_exit);
diff --git a/drivers/rtc/rtc-fm3130.c b/drivers/rtc/rtc-fm3130.c
index 4cf2e70..86b6ecc 100644
--- a/drivers/rtc/rtc-fm3130.c
+++ b/drivers/rtc/rtc-fm3130.c
@@ -565,17 +565,7 @@ static struct i2c_driver fm3130_driver = {
 	.id_table	= fm3130_id,
 };
 
-static int __init fm3130_init(void)
-{
-	return i2c_add_driver(&fm3130_driver);
-}
-module_init(fm3130_init);
-
-static void __exit fm3130_exit(void)
-{
-	i2c_del_driver(&fm3130_driver);
-}
-module_exit(fm3130_exit);
+module_i2c_driver(fm3130_driver);
 
 MODULE_DESCRIPTION("RTC driver for FM3130");
 MODULE_AUTHOR("Sergey Lapin <slapin@ossfans.org>");
diff --git a/drivers/rtc/rtc-isl12022.c b/drivers/rtc/rtc-isl12022.c
index 6186833..1850104 100644
--- a/drivers/rtc/rtc-isl12022.c
+++ b/drivers/rtc/rtc-isl12022.c
@@ -309,18 +309,7 @@ static struct i2c_driver isl12022_driver = {
 	.id_table	= isl12022_id,
 };
 
-static int __init isl12022_init(void)
-{
-	return i2c_add_driver(&isl12022_driver);
-}
-
-static void __exit isl12022_exit(void)
-{
-	i2c_del_driver(&isl12022_driver);
-}
-
-module_init(isl12022_init);
-module_exit(isl12022_exit);
+module_i2c_driver(isl12022_driver);
 
 MODULE_AUTHOR("roman.fietze@telemotive.de");
 MODULE_DESCRIPTION("ISL 12022 RTC driver");
diff --git a/drivers/rtc/rtc-isl1208.c b/drivers/rtc/rtc-isl1208.c
index da8beb8..dd2aeee 100644
--- a/drivers/rtc/rtc-isl1208.c
+++ b/drivers/rtc/rtc-isl1208.c
@@ -710,22 +710,9 @@ static struct i2c_driver isl1208_driver = {
 	.id_table = isl1208_id,
 };
 
-static int __init
-isl1208_init(void)
-{
-	return i2c_add_driver(&isl1208_driver);
-}
-
-static void __exit
-isl1208_exit(void)
-{
-	i2c_del_driver(&isl1208_driver);
-}
+module_i2c_driver(isl1208_driver);
 
 MODULE_AUTHOR("Herbert Valerio Riedel <hvr@gnu.org>");
 MODULE_DESCRIPTION("Intersil ISL1208 RTC driver");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_VERSION);
-
-module_init(isl1208_init);
-module_exit(isl1208_exit);
diff --git a/drivers/rtc/rtc-m41t80.c b/drivers/rtc/rtc-m41t80.c
index 64aedd8..4e0f84a 100644
--- a/drivers/rtc/rtc-m41t80.c
+++ b/drivers/rtc/rtc-m41t80.c
@@ -900,20 +900,9 @@ static struct i2c_driver m41t80_driver = {
 	.id_table = m41t80_id,
 };
 
-static int __init m41t80_rtc_init(void)
-{
-	return i2c_add_driver(&m41t80_driver);
-}
-
-static void __exit m41t80_rtc_exit(void)
-{
-	i2c_del_driver(&m41t80_driver);
-}
+module_i2c_driver(m41t80_driver);
 
 MODULE_AUTHOR("Alexander Bigga <ab@mycable.de>");
 MODULE_DESCRIPTION("ST Microelectronics M41T80 series RTC I2C Client Driver");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_VERSION);
-
-module_init(m41t80_rtc_init);
-module_exit(m41t80_rtc_exit);
diff --git a/drivers/rtc/rtc-max6900.c b/drivers/rtc/rtc-max6900.c
index 486142c..a00e332 100644
--- a/drivers/rtc/rtc-max6900.c
+++ b/drivers/rtc/rtc-max6900.c
@@ -261,20 +261,9 @@ static struct i2c_driver max6900_driver = {
 	.id_table = max6900_id,
 };
 
-static int __init max6900_init(void)
-{
-	return i2c_add_driver(&max6900_driver);
-}
-
-static void __exit max6900_exit(void)
-{
-	i2c_del_driver(&max6900_driver);
-}
+module_i2c_driver(max6900_driver);
 
 MODULE_DESCRIPTION("Maxim MAX6900 RTC driver");
 MODULE_AUTHOR("Dale Farnsworth <dale@farnsworth.org>");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_VERSION);
-
-module_init(max6900_init);
-module_exit(max6900_exit);
diff --git a/drivers/rtc/rtc-pcf8563.c b/drivers/rtc/rtc-pcf8563.c
index 606fdfa..bc0677d 100644
--- a/drivers/rtc/rtc-pcf8563.c
+++ b/drivers/rtc/rtc-pcf8563.c
@@ -252,20 +252,9 @@ static struct i2c_driver pcf8563_driver = {
 	.id_table	= pcf8563_id,
 };
 
-static int __init pcf8563_init(void)
-{
-	return i2c_add_driver(&pcf8563_driver);
-}
-
-static void __exit pcf8563_exit(void)
-{
-	i2c_del_driver(&pcf8563_driver);
-}
+module_i2c_driver(pcf8563_driver);
 
 MODULE_AUTHOR("Alessandro Zummo <a.zummo@towertech.it>");
 MODULE_DESCRIPTION("Philips PCF8563/Epson RTC8564 RTC driver");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_VERSION);
-
-module_init(pcf8563_init);
-module_exit(pcf8563_exit);
diff --git a/drivers/rtc/rtc-pcf8583.c b/drivers/rtc/rtc-pcf8583.c
index 2d201af..019ff35 100644
--- a/drivers/rtc/rtc-pcf8583.c
+++ b/drivers/rtc/rtc-pcf8583.c
@@ -320,18 +320,7 @@ static struct i2c_driver pcf8583_driver = {
 	.id_table	= pcf8583_id,
 };
 
-static __init int pcf8583_init(void)
-{
-	return i2c_add_driver(&pcf8583_driver);
-}
-
-static __exit void pcf8583_exit(void)
-{
-	i2c_del_driver(&pcf8583_driver);
-}
-
-module_init(pcf8583_init);
-module_exit(pcf8583_exit);
+module_i2c_driver(pcf8583_driver);
 
 MODULE_AUTHOR("Russell King");
 MODULE_DESCRIPTION("PCF8583 I2C RTC driver");
diff --git a/drivers/rtc/rtc-rs5c372.c b/drivers/rtc/rtc-rs5c372.c
index d29f543..fb4842c 100644
--- a/drivers/rtc/rtc-rs5c372.c
+++ b/drivers/rtc/rtc-rs5c372.c
@@ -689,18 +689,7 @@ static struct i2c_driver rs5c372_driver = {
 	.id_table	= rs5c372_id,
 };
 
-static __init int rs5c372_init(void)
-{
-	return i2c_add_driver(&rs5c372_driver);
-}
-
-static __exit void rs5c372_exit(void)
-{
-	i2c_del_driver(&rs5c372_driver);
-}
-
-module_init(rs5c372_init);
-module_exit(rs5c372_exit);
+module_i2c_driver(rs5c372_driver);
 
 MODULE_AUTHOR(
 		"Pavel Mironchik <pmironchik@optifacio.net>, "
diff --git a/drivers/rtc/rtc-rv3029c2.c b/drivers/rtc/rtc-rv3029c2.c
index ea09ff2..0fbe57b 100644
--- a/drivers/rtc/rtc-rv3029c2.c
+++ b/drivers/rtc/rtc-rv3029c2.c
@@ -436,18 +436,7 @@ static struct i2c_driver rv3029c2_driver = {
 	.id_table = rv3029c2_id,
 };
 
-static int __init rv3029c2_init(void)
-{
-	return i2c_add_driver(&rv3029c2_driver);
-}
-
-static void __exit rv3029c2_exit(void)
-{
-	i2c_del_driver(&rv3029c2_driver);
-}
-
-module_init(rv3029c2_init);
-module_exit(rv3029c2_exit);
+module_i2c_driver(rv3029c2_driver);
 
 MODULE_AUTHOR("Gregory Hermant <gregory.hermant@calao-systems.com>");
 MODULE_DESCRIPTION("Micro Crystal RV3029C2 RTC driver");
diff --git a/drivers/rtc/rtc-rx8025.c b/drivers/rtc/rtc-rx8025.c
index fde172f..0de902dc 100644
--- a/drivers/rtc/rtc-rx8025.c
+++ b/drivers/rtc/rtc-rx8025.c
@@ -644,19 +644,8 @@ static struct i2c_driver rx8025_driver = {
 	.id_table	= rx8025_id,
 };
 
-static int __init rx8025_init(void)
-{
-	return i2c_add_driver(&rx8025_driver);
-}
-
-static void __exit rx8025_exit(void)
-{
-	i2c_del_driver(&rx8025_driver);
-}
+module_i2c_driver(rx8025_driver);
 
 MODULE_AUTHOR("Wolfgang Grandegger <wg@grandegger.com>");
 MODULE_DESCRIPTION("RX-8025 SA/NB RTC driver");
 MODULE_LICENSE("GPL");
-
-module_init(rx8025_init);
-module_exit(rx8025_exit);
diff --git a/drivers/rtc/rtc-rx8581.c b/drivers/rtc/rtc-rx8581.c
index 600b890..d848251 100644
--- a/drivers/rtc/rtc-rx8581.c
+++ b/drivers/rtc/rtc-rx8581.c
@@ -276,20 +276,9 @@ static struct i2c_driver rx8581_driver = {
 	.id_table	= rx8581_id,
 };
 
-static int __init rx8581_init(void)
-{
-	return i2c_add_driver(&rx8581_driver);
-}
-
-static void __exit rx8581_exit(void)
-{
-	i2c_del_driver(&rx8581_driver);
-}
+module_i2c_driver(rx8581_driver);
 
 MODULE_AUTHOR("Martyn Welch <martyn.welch@ge.com>");
 MODULE_DESCRIPTION("Epson RX-8581 RTC driver");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_VERSION);
-
-module_init(rx8581_init);
-module_exit(rx8581_exit);
diff --git a/drivers/rtc/rtc-s35390a.c b/drivers/rtc/rtc-s35390a.c
index f789e00..c9562ce 100644
--- a/drivers/rtc/rtc-s35390a.c
+++ b/drivers/rtc/rtc-s35390a.c
@@ -304,19 +304,8 @@ static struct i2c_driver s35390a_driver = {
 	.id_table	= s35390a_id,
 };
 
-static int __init s35390a_rtc_init(void)
-{
-	return i2c_add_driver(&s35390a_driver);
-}
-
-static void __exit s35390a_rtc_exit(void)
-{
-	i2c_del_driver(&s35390a_driver);
-}
+module_i2c_driver(s35390a_driver);
 
 MODULE_AUTHOR("Byron Bradley <byron.bbradley@gmail.com>");
 MODULE_DESCRIPTION("S35390A RTC driver");
 MODULE_LICENSE("GPL");
-
-module_init(s35390a_rtc_init);
-module_exit(s35390a_rtc_exit);
diff --git a/drivers/rtc/rtc-x1205.c b/drivers/rtc/rtc-x1205.c
index 8c051d3..403b3d4 100644
--- a/drivers/rtc/rtc-x1205.c
+++ b/drivers/rtc/rtc-x1205.c
@@ -623,15 +623,7 @@ static struct i2c_driver x1205_driver = {
 	.id_table	= x1205_id,
 };
 
-static int __init x1205_init(void)
-{
-	return i2c_add_driver(&x1205_driver);
-}
-
-static void __exit x1205_exit(void)
-{
-	i2c_del_driver(&x1205_driver);
-}
+module_i2c_driver(x1205_driver);
 
 MODULE_AUTHOR(
 	"Karen Spearel <kas111 at gmail dot com>, "
@@ -639,6 +631,3 @@ MODULE_AUTHOR(
 MODULE_DESCRIPTION("Xicor/Intersil X1205 RTC driver");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_VERSION);
-
-module_init(x1205_init);
-module_exit(x1205_exit);
-- 
1.7.5.4



