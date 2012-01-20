Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757281Ab2ATAQs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 19:16:48 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:34494 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507Ab2ATAQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 19:16:46 -0500
Message-ID: <1327018592.7293.1.camel@phoenix>
Subject: [PATCH 1/2] rtc: Convert rtc spi drivers to module_spi_driver
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Jackson <mpfj@mimc.co.uk>, Dennis Aberilla <denzzzhome@yahoo.com>,
        Nikolaus Voss <n.voss@weinmann.de>,
        "Kim B. Heino" <Kim.Heino@bluegiga.com>,
        Raphael Assenat <raph@raphnet.net>,
        Chris Verges <chrisv@cyberswitching.com>,
        Magnus Damm <damm@opensource.se>, Atsushi Nemoto <anemo@mba.ocn.ne.jp>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Andrew Morton <akpm@linux-foundation.org>, rtc-linux@googlegroups.com
Date: Fri, 20 Jan 2012 08:16:32 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factor out some boilerplate code for spi driver registration
into module_spi_driver.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Mark Jackson <mpfj@mimc.co.uk>
Cc: Dennis Aberilla <denzzzhome@yahoo.com>
Cc: Nikolaus Voss <n.voss@weinmann.de>
Cc: "Kim B. Heino" <Kim.Heino@bluegiga.com>
Cc: Raphael Assenat <raph@raphnet.net>
Cc: Chris Verges <chrisv@cyberswitching.com>
Cc: Magnus Damm <damm@opensource.se>
Cc: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
---
 drivers/rtc/rtc-ds1305.c  |   12 +-----------
 drivers/rtc/rtc-ds1390.c  |   12 +-----------
 drivers/rtc/rtc-ds3234.c  |   12 +-----------
 drivers/rtc/rtc-m41t93.c  |   12 +-----------
 drivers/rtc/rtc-m41t94.c  |   14 +-------------
 drivers/rtc/rtc-max6902.c |   12 +-----------
 drivers/rtc/rtc-pcf2123.c |   13 +------------
 drivers/rtc/rtc-r9701.c   |   12 +-----------
 drivers/rtc/rtc-rs5c348.c |   13 +------------
 9 files changed, 9 insertions(+), 103 deletions(-)

diff --git a/drivers/rtc/rtc-ds1305.c b/drivers/rtc/rtc-ds1305.c
index 3a33b1f..686a865 100644
--- a/drivers/rtc/rtc-ds1305.c
+++ b/drivers/rtc/rtc-ds1305.c
@@ -814,17 +814,7 @@ static struct spi_driver ds1305_driver = {
 	/* REVISIT add suspend/resume */
 };
 
-static int __init ds1305_init(void)
-{
-	return spi_register_driver(&ds1305_driver);
-}
-module_init(ds1305_init);
-
-static void __exit ds1305_exit(void)
-{
-	spi_unregister_driver(&ds1305_driver);
-}
-module_exit(ds1305_exit);
+module_spi_driver(ds1305_driver);
 
 MODULE_DESCRIPTION("RTC driver for DS1305 and DS1306 chips");
 MODULE_LICENSE("GPL");
diff --git a/drivers/rtc/rtc-ds1390.c b/drivers/rtc/rtc-ds1390.c
index b038d2c..b0a99e1 100644
--- a/drivers/rtc/rtc-ds1390.c
+++ b/drivers/rtc/rtc-ds1390.c
@@ -175,17 +175,7 @@ static struct spi_driver ds1390_driver = {
 	.remove = __devexit_p(ds1390_remove),
 };
 
-static __init int ds1390_init(void)
-{
-	return spi_register_driver(&ds1390_driver);
-}
-module_init(ds1390_init);
-
-static __exit void ds1390_exit(void)
-{
-	spi_unregister_driver(&ds1390_driver);
-}
-module_exit(ds1390_exit);
+module_spi_driver(ds1390_driver);
 
 MODULE_DESCRIPTION("Dallas/Maxim DS1390/93/94 SPI RTC driver");
 MODULE_AUTHOR("Mark Jackson <mpfj@mimc.co.uk>");
diff --git a/drivers/rtc/rtc-ds3234.c b/drivers/rtc/rtc-ds3234.c
index bbd2622..fda7079 100644
--- a/drivers/rtc/rtc-ds3234.c
+++ b/drivers/rtc/rtc-ds3234.c
@@ -173,17 +173,7 @@ static struct spi_driver ds3234_driver = {
 	.remove = __devexit_p(ds3234_remove),
 };
 
-static __init int ds3234_init(void)
-{
-	return spi_register_driver(&ds3234_driver);
-}
-module_init(ds3234_init);
-
-static __exit void ds3234_exit(void)
-{
-	spi_unregister_driver(&ds3234_driver);
-}
-module_exit(ds3234_exit);
+module_spi_driver(ds3234_driver);
 
 MODULE_DESCRIPTION("DS3234 SPI RTC driver");
 MODULE_AUTHOR("Dennis Aberilla <denzzzhome@yahoo.com>");
diff --git a/drivers/rtc/rtc-m41t93.c b/drivers/rtc/rtc-m41t93.c
index ef71132..10f1c29 100644
--- a/drivers/rtc/rtc-m41t93.c
+++ b/drivers/rtc/rtc-m41t93.c
@@ -206,17 +206,7 @@ static struct spi_driver m41t93_driver = {
 	.remove = __devexit_p(m41t93_remove),
 };
 
-static __init int m41t93_init(void)
-{
-	return spi_register_driver(&m41t93_driver);
-}
-module_init(m41t93_init);
-
-static __exit void m41t93_exit(void)
-{
-	spi_unregister_driver(&m41t93_driver);
-}
-module_exit(m41t93_exit);
+module_spi_driver(m41t93_driver);
 
 MODULE_AUTHOR("Nikolaus Voss <n.voss@weinmann.de>");
 MODULE_DESCRIPTION("Driver for ST M41T93 SPI RTC");
diff --git a/drivers/rtc/rtc-m41t94.c b/drivers/rtc/rtc-m41t94.c
index 2a4721f..6e78193 100644
--- a/drivers/rtc/rtc-m41t94.c
+++ b/drivers/rtc/rtc-m41t94.c
@@ -153,19 +153,7 @@ static struct spi_driver m41t94_driver = {
 	.remove = __devexit_p(m41t94_remove),
 };
 
-static __init int m41t94_init(void)
-{
-	return spi_register_driver(&m41t94_driver);
-}
-
-module_init(m41t94_init);
-
-static __exit void m41t94_exit(void)
-{
-	spi_unregister_driver(&m41t94_driver);
-}
-
-module_exit(m41t94_exit);
+module_spi_driver(m41t94_driver);
 
 MODULE_AUTHOR("Kim B. Heino <Kim.Heino@bluegiga.com>");
 MODULE_DESCRIPTION("Driver for ST M41T94 SPI RTC");
diff --git a/drivers/rtc/rtc-max6902.c b/drivers/rtc/rtc-max6902.c
index 1f6b3cc..36c74d2 100644
--- a/drivers/rtc/rtc-max6902.c
+++ b/drivers/rtc/rtc-max6902.c
@@ -160,17 +160,7 @@ static struct spi_driver max6902_driver = {
 	.remove = __devexit_p(max6902_remove),
 };
 
-static __init int max6902_init(void)
-{
-	return spi_register_driver(&max6902_driver);
-}
-module_init(max6902_init);
-
-static __exit void max6902_exit(void)
-{
-	spi_unregister_driver(&max6902_driver);
-}
-module_exit(max6902_exit);
+module_spi_driver(max6902_driver);
 
 MODULE_DESCRIPTION ("max6902 spi RTC driver");
 MODULE_AUTHOR ("Raphael Assenat");
diff --git a/drivers/rtc/rtc-pcf2123.c b/drivers/rtc/rtc-pcf2123.c
index b46c400..8361187 100644
--- a/drivers/rtc/rtc-pcf2123.c
+++ b/drivers/rtc/rtc-pcf2123.c
@@ -346,20 +346,9 @@ static struct spi_driver pcf2123_driver = {
 	.remove	= __devexit_p(pcf2123_remove),
 };
 
-static int __init pcf2123_init(void)
-{
-	return spi_register_driver(&pcf2123_driver);
-}
-
-static void __exit pcf2123_exit(void)
-{
-	spi_unregister_driver(&pcf2123_driver);
-}
+module_spi_driver(pcf2123_driver);
 
 MODULE_AUTHOR("Chris Verges <chrisv@cyberswitching.com>");
 MODULE_DESCRIPTION("NXP PCF2123 RTC driver");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_VERSION);
-
-module_init(pcf2123_init);
-module_exit(pcf2123_exit);
diff --git a/drivers/rtc/rtc-r9701.c b/drivers/rtc/rtc-r9701.c
index 9beba49c..931f95c 100644
--- a/drivers/rtc/rtc-r9701.c
+++ b/drivers/rtc/rtc-r9701.c
@@ -159,17 +159,7 @@ static struct spi_driver r9701_driver = {
 	.remove = __devexit_p(r9701_remove),
 };
 
-static __init int r9701_init(void)
-{
-	return spi_register_driver(&r9701_driver);
-}
-module_init(r9701_init);
-
-static __exit void r9701_exit(void)
-{
-	spi_unregister_driver(&r9701_driver);
-}
-module_exit(r9701_exit);
+module_spi_driver(r9701_driver);
 
 MODULE_DESCRIPTION("r9701 spi RTC driver");
 MODULE_AUTHOR("Magnus Damm <damm@opensource.se>");
diff --git a/drivers/rtc/rtc-rs5c348.c b/drivers/rtc/rtc-rs5c348.c
index ce2ca85..77074cc 100644
--- a/drivers/rtc/rtc-rs5c348.c
+++ b/drivers/rtc/rtc-rs5c348.c
@@ -235,18 +235,7 @@ static struct spi_driver rs5c348_driver = {
 	.remove	= __devexit_p(rs5c348_remove),
 };
 
-static __init int rs5c348_init(void)
-{
-	return spi_register_driver(&rs5c348_driver);
-}
-
-static __exit void rs5c348_exit(void)
-{
-	spi_unregister_driver(&rs5c348_driver);
-}
-
-module_init(rs5c348_init);
-module_exit(rs5c348_exit);
+module_spi_driver(rs5c348_driver);
 
 MODULE_AUTHOR("Atsushi Nemoto <anemo@mba.ocn.ne.jp>");
 MODULE_DESCRIPTION("Ricoh RS5C348 RTC driver");
-- 
1.7.5.4



