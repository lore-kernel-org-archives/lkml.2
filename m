Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750963Ab2AVHia (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jan 2012 02:38:30 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37233 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741Ab2AVHi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jan 2012 02:38:29 -0500
Message-ID: <1327217902.6497.4.camel@phoenix>
Subject: [PATCH 3/3] MISC: convert drivers/misc/* to use module_spi_driver()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Michael Hennerich <hennerich@blackfin.uclinux.org>,
        Anatolij Gustschin <agust@denx.de>, Daniel Mack <zonque@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <greg@kroah.com>
Date: Sun, 22 Jan 2012 15:38:22 +0800
In-Reply-To: <1327217629.6497.0.camel@phoenix>
References: <1327217629.6497.0.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the drivers in drivers/misc/* to use the
module_spi_driver() macro which makes the code smaller and a bit
simpler.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Michael Hennerich <hennerich@blackfin.uclinux.org>
Cc: Anatolij Gustschin <agust@denx.de>
Cc: Daniel Mack <zonque@gmail.com>
Acked-by: Michael Hennerich <michael.hennerich@analog.com>
---
 drivers/misc/ad525x_dpot-spi.c         |   12 +-----------
 drivers/misc/eeprom/at25.c             |   12 +-----------
 drivers/misc/eeprom/eeprom_93xx46.c    |   12 +-----------
 drivers/misc/lis3lv02d/lis3lv02d_spi.c |   13 +------------
 drivers/misc/ti_dac7512.c              |   13 +------------
 5 files changed, 5 insertions(+), 57 deletions(-)

diff --git a/drivers/misc/ad525x_dpot-spi.c b/drivers/misc/ad525x_dpot-spi.c
index 822749e..f623175 100644
--- a/drivers/misc/ad525x_dpot-spi.c
+++ b/drivers/misc/ad525x_dpot-spi.c
@@ -135,17 +135,7 @@ static struct spi_driver ad_dpot_spi_driver = {
 	.id_table	= ad_dpot_spi_id,
 };
 
-static int __init ad_dpot_spi_init(void)
-{
-	return spi_register_driver(&ad_dpot_spi_driver);
-}
-module_init(ad_dpot_spi_init);
-
-static void __exit ad_dpot_spi_exit(void)
-{
-	spi_unregister_driver(&ad_dpot_spi_driver);
-}
-module_exit(ad_dpot_spi_exit);
+module_spi_driver(ad_dpot_spi_driver);
 
 MODULE_AUTHOR("Michael Hennerich <hennerich@blackfin.uclinux.org>");
 MODULE_DESCRIPTION("digital potentiometer SPI bus driver");
diff --git a/drivers/misc/eeprom/at25.c b/drivers/misc/eeprom/at25.c
index c627e41..01ab3c9 100644
--- a/drivers/misc/eeprom/at25.c
+++ b/drivers/misc/eeprom/at25.c
@@ -405,17 +405,7 @@ static struct spi_driver at25_driver = {
 	.remove		= __devexit_p(at25_remove),
 };
 
-static int __init at25_init(void)
-{
-	return spi_register_driver(&at25_driver);
-}
-module_init(at25_init);
-
-static void __exit at25_exit(void)
-{
-	spi_unregister_driver(&at25_driver);
-}
-module_exit(at25_exit);
+module_spi_driver(at25_driver);
 
 MODULE_DESCRIPTION("Driver for most SPI EEPROMs");
 MODULE_AUTHOR("David Brownell");
diff --git a/drivers/misc/eeprom/eeprom_93xx46.c b/drivers/misc/eeprom/eeprom_93xx46.c
index 0c7ebb1..ce3fe36 100644
--- a/drivers/misc/eeprom/eeprom_93xx46.c
+++ b/drivers/misc/eeprom/eeprom_93xx46.c
@@ -392,17 +392,7 @@ static struct spi_driver eeprom_93xx46_driver = {
 	.remove		= __devexit_p(eeprom_93xx46_remove),
 };
 
-static int __init eeprom_93xx46_init(void)
-{
-	return spi_register_driver(&eeprom_93xx46_driver);
-}
-module_init(eeprom_93xx46_init);
-
-static void __exit eeprom_93xx46_exit(void)
-{
-	spi_unregister_driver(&eeprom_93xx46_driver);
-}
-module_exit(eeprom_93xx46_exit);
+module_spi_driver(eeprom_93xx46_driver);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Driver for 93xx46 EEPROMs");
diff --git a/drivers/misc/lis3lv02d/lis3lv02d_spi.c b/drivers/misc/lis3lv02d/lis3lv02d_spi.c
index b2c1be1..80880e9 100644
--- a/drivers/misc/lis3lv02d/lis3lv02d_spi.c
+++ b/drivers/misc/lis3lv02d/lis3lv02d_spi.c
@@ -126,18 +126,7 @@ static struct spi_driver lis302dl_spi_driver = {
 	.remove	= __devexit_p(lis302dl_spi_remove),
 };
 
-static int __init lis302dl_init(void)
-{
-	return spi_register_driver(&lis302dl_spi_driver);
-}
-
-static void __exit lis302dl_exit(void)
-{
-	spi_unregister_driver(&lis302dl_spi_driver);
-}
-
-module_init(lis302dl_init);
-module_exit(lis302dl_exit);
+module_spi_driver(lis302dl_spi_driver);
 
 MODULE_AUTHOR("Daniel Mack <daniel@caiaq.de>");
 MODULE_DESCRIPTION("lis3lv02d SPI glue layer");
diff --git a/drivers/misc/ti_dac7512.c b/drivers/misc/ti_dac7512.c
index d3f229a..5acbba1 100644
--- a/drivers/misc/ti_dac7512.c
+++ b/drivers/misc/ti_dac7512.c
@@ -82,20 +82,9 @@ static struct spi_driver dac7512_driver = {
 	.remove	= __devexit_p(dac7512_remove),
 };
 
-static int __init dac7512_init(void)
-{
-	return spi_register_driver(&dac7512_driver);
-}
-
-static void __exit dac7512_exit(void)
-{
-	spi_unregister_driver(&dac7512_driver);
-}
+module_spi_driver(dac7512_driver);
 
 MODULE_AUTHOR("Daniel Mack <daniel@caiaq.de>");
 MODULE_DESCRIPTION("DAC7512 16-bit DAC");
 MODULE_LICENSE("GPL v2");
 MODULE_VERSION(DRIVER_VERSION);
-
-module_init(dac7512_init);
-module_exit(dac7512_exit);
-- 
1.7.5.4



