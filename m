Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616Ab2DGXKM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2012 19:10:12 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64145 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500Ab2DGXKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2012 19:10:10 -0400
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH] gpio: Move DT support code into drivers/gpio
Date: Sat,  7 Apr 2012 14:37:25 -0600
Message-Id: <1333831045-2593-1-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code in drivers/of/gpio.c isn't shared by any other subsystem since it
is all gpiolib specific.  drivers/gpio is a better place to maintain these
functions.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/gpio/Kconfig                     |    4 ++++
 drivers/gpio/Makefile                    |    1 +
 drivers/{of/gpio.c => gpio/gpiolib-of.c} |    0
 drivers/of/Kconfig                       |    6 ------
 drivers/of/Makefile                      |    1 -
 5 files changed, 5 insertions(+), 7 deletions(-)
 rename drivers/{of/gpio.c => gpio/gpiolib-of.c} (100%)

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index e6862f1..1042c3f 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -37,6 +37,10 @@ menuconfig GPIOLIB
 
 if GPIOLIB
 
+config OF_GPIO
+	def_bool y
+	depends on OF && !SPARC
+
 config DEBUG_GPIO
 	bool "Debug GPIO calls"
 	depends on DEBUG_KERNEL
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index 007f54b..1c2f6c0 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -3,6 +3,7 @@
 ccflags-$(CONFIG_DEBUG_GPIO)	+= -DDEBUG
 
 obj-$(CONFIG_GPIOLIB)		+= gpiolib.o devres.o
+obj-$(CONFIG_OF_GPIO)		+= gpiolib-of.o
 
 # Device drivers. Generally keep list sorted alphabetically
 obj-$(CONFIG_GPIO_GENERIC)	+= gpio-generic.o
diff --git a/drivers/of/gpio.c b/drivers/gpio/gpiolib-of.c
similarity index 100%
rename from drivers/of/gpio.c
rename to drivers/gpio/gpiolib-of.c
diff --git a/drivers/of/Kconfig b/drivers/of/Kconfig
index 8e84ce9..ce00d11 100644
--- a/drivers/of/Kconfig
+++ b/drivers/of/Kconfig
@@ -51,12 +51,6 @@ config OF_IRQ
 config OF_DEVICE
 	def_bool y
 
-config OF_GPIO
-	def_bool y
-	depends on GPIOLIB && !SPARC
-	help
-	  OpenFirmware GPIO accessors
-
 config OF_I2C
 	def_tristate I2C
 	depends on I2C && !SPARC
diff --git a/drivers/of/Makefile b/drivers/of/Makefile
index aa90e60..aff2c62 100644
--- a/drivers/of/Makefile
+++ b/drivers/of/Makefile
@@ -4,7 +4,6 @@ obj-$(CONFIG_OF_PROMTREE) += pdt.o
 obj-$(CONFIG_OF_ADDRESS)  += address.o
 obj-$(CONFIG_OF_IRQ)    += irq.o
 obj-$(CONFIG_OF_DEVICE) += device.o platform.o
-obj-$(CONFIG_OF_GPIO)   += gpio.o
 obj-$(CONFIG_OF_I2C)	+= of_i2c.o
 obj-$(CONFIG_OF_NET)	+= of_net.o
 obj-$(CONFIG_OF_SPI)	+= of_spi.o
-- 
1.7.9.1

