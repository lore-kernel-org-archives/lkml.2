Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268Ab2ATNDR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 08:03:17 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:53260 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608Ab2ATNDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 08:03:15 -0500
Message-ID: <1327064588.15205.2.camel@phoenix>
Subject: [PATCH 2/2] Input: convert drivers/input/* to use
 module_spi_driver()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Barry Song <21cnbao@gmail.com>,
        Michael Hennerich <hennerich@blackfin.uclinux.org>,
        Anatolij Gustschin <agust@denx.de>,
        Lauri Leukkunen <lauri.leukkunen@nokia.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org
Date: Fri, 20 Jan 2012 21:03:08 +0800
In-Reply-To: <1327064484.15205.1.camel@phoenix>
References: <1327064484.15205.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This converts the drivers in drivers/input/* to use the
module_spi_driver() macro which makes the code smaller and a bit simpler.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Barry Song <21cnbao@gmail.com>
Cc: Michael Hennerich <hennerich@blackfin.uclinux.org>
Cc: Anatolij Gustschin <agust@denx.de>
Cc: Lauri Leukkunen <lauri.leukkunen@nokia.com>
---
 drivers/input/misc/ad714x-spi.c        |   12 +-----------
 drivers/input/misc/adxl34x-spi.c       |   12 +-----------
 drivers/input/touchscreen/ad7877.c     |   12 +-----------
 drivers/input/touchscreen/ad7879-spi.c |   12 +-----------
 drivers/input/touchscreen/ads7846.c    |   12 +-----------
 drivers/input/touchscreen/tsc2005.c    |   12 +-----------
 6 files changed, 6 insertions(+), 66 deletions(-)

diff --git a/drivers/input/misc/ad714x-spi.c b/drivers/input/misc/ad714x-spi.c
index 875b508..75f6136d 100644
--- a/drivers/input/misc/ad714x-spi.c
+++ b/drivers/input/misc/ad714x-spi.c
@@ -123,17 +123,7 @@ static struct spi_driver ad714x_spi_driver = {
 	.remove		= __devexit_p(ad714x_spi_remove),
 };
 
-static __init int ad714x_spi_init(void)
-{
-	return spi_register_driver(&ad714x_spi_driver);
-}
-module_init(ad714x_spi_init);
-
-static __exit void ad714x_spi_exit(void)
-{
-	spi_unregister_driver(&ad714x_spi_driver);
-}
-module_exit(ad714x_spi_exit);
+module_spi_driver(ad714x_spi_driver);
 
 MODULE_DESCRIPTION("Analog Devices AD714X Capacitance Touch Sensor SPI Bus Driver");
 MODULE_AUTHOR("Barry Song <21cnbao@gmail.com>");
diff --git a/drivers/input/misc/adxl34x-spi.c b/drivers/input/misc/adxl34x-spi.c
index 34d401e..820a802 100644
--- a/drivers/input/misc/adxl34x-spi.c
+++ b/drivers/input/misc/adxl34x-spi.c
@@ -129,17 +129,7 @@ static struct spi_driver adxl34x_driver = {
 	.remove  = __devexit_p(adxl34x_spi_remove),
 };
 
-static int __init adxl34x_spi_init(void)
-{
-	return spi_register_driver(&adxl34x_driver);
-}
-module_init(adxl34x_spi_init);
-
-static void __exit adxl34x_spi_exit(void)
-{
-	spi_unregister_driver(&adxl34x_driver);
-}
-module_exit(adxl34x_spi_exit);
+module_spi_driver(adxl34x_driver);
 
 MODULE_AUTHOR("Michael Hennerich <hennerich@blackfin.uclinux.org>");
 MODULE_DESCRIPTION("ADXL345/346 Three-Axis Digital Accelerometer SPI Bus Driver");
diff --git a/drivers/input/touchscreen/ad7877.c b/drivers/input/touchscreen/ad7877.c
index 49a36df..2c76921 100644
--- a/drivers/input/touchscreen/ad7877.c
+++ b/drivers/input/touchscreen/ad7877.c
@@ -860,17 +860,7 @@ static struct spi_driver ad7877_driver = {
 	.remove		= __devexit_p(ad7877_remove),
 };
 
-static int __init ad7877_init(void)
-{
-	return spi_register_driver(&ad7877_driver);
-}
-module_init(ad7877_init);
-
-static void __exit ad7877_exit(void)
-{
-	spi_unregister_driver(&ad7877_driver);
-}
-module_exit(ad7877_exit);
+module_spi_driver(ad7877_driver);
 
 MODULE_AUTHOR("Michael Hennerich <hennerich@blackfin.uclinux.org>");
 MODULE_DESCRIPTION("AD7877 touchscreen Driver");
diff --git a/drivers/input/touchscreen/ad7879-spi.c b/drivers/input/touchscreen/ad7879-spi.c
index 9b2e1c2..db49abf 100644
--- a/drivers/input/touchscreen/ad7879-spi.c
+++ b/drivers/input/touchscreen/ad7879-spi.c
@@ -157,17 +157,7 @@ static struct spi_driver ad7879_spi_driver = {
 	.remove		= __devexit_p(ad7879_spi_remove),
 };
 
-static int __init ad7879_spi_init(void)
-{
-	return spi_register_driver(&ad7879_spi_driver);
-}
-module_init(ad7879_spi_init);
-
-static void __exit ad7879_spi_exit(void)
-{
-	spi_unregister_driver(&ad7879_spi_driver);
-}
-module_exit(ad7879_spi_exit);
+module_spi_driver(ad7879_spi_driver);
 
 MODULE_AUTHOR("Michael Hennerich <hennerich@blackfin.uclinux.org>");
 MODULE_DESCRIPTION("AD7879(-1) touchscreen SPI bus driver");
diff --git a/drivers/input/touchscreen/ads7846.c b/drivers/input/touchscreen/ads7846.c
index 23fd901..f02028e 100644
--- a/drivers/input/touchscreen/ads7846.c
+++ b/drivers/input/touchscreen/ads7846.c
@@ -1433,17 +1433,7 @@ static struct spi_driver ads7846_driver = {
 	.remove		= __devexit_p(ads7846_remove),
 };
 
-static int __init ads7846_init(void)
-{
-	return spi_register_driver(&ads7846_driver);
-}
-module_init(ads7846_init);
-
-static void __exit ads7846_exit(void)
-{
-	spi_unregister_driver(&ads7846_driver);
-}
-module_exit(ads7846_exit);
+module_spi_driver(ads7846_driver);
 
 MODULE_DESCRIPTION("ADS7846 TouchScreen Driver");
 MODULE_LICENSE("GPL");
diff --git a/drivers/input/touchscreen/tsc2005.c b/drivers/input/touchscreen/tsc2005.c
index 067d956..b6adeae 100644
--- a/drivers/input/touchscreen/tsc2005.c
+++ b/drivers/input/touchscreen/tsc2005.c
@@ -747,17 +747,7 @@ static struct spi_driver tsc2005_driver = {
 	.remove	= __devexit_p(tsc2005_remove),
 };
 
-static int __init tsc2005_init(void)
-{
-	return spi_register_driver(&tsc2005_driver);
-}
-module_init(tsc2005_init);
-
-static void __exit tsc2005_exit(void)
-{
-	spi_unregister_driver(&tsc2005_driver);
-}
-module_exit(tsc2005_exit);
+module_spi_driver(tsc2005_driver);
 
 MODULE_AUTHOR("Lauri Leukkunen <lauri.leukkunen@nokia.com>");
 MODULE_DESCRIPTION("TSC2005 Touchscreen Driver");
-- 
1.7.5.4



