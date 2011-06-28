Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757269Ab1F1LLQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 07:11:16 -0400
Received: from eu1sys200aog108.obsmtp.com ([207.126.144.125]:51638 "EHLO
	eu1sys200aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754670Ab1F1LJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 07:09:31 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] mfd: move TPS55910 Kconfig option
Date: Tue, 28 Jun 2011 13:09:14 +0200
Message-ID: <1309259354-32213-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Having another TPS chip at the end of the Kconfig when all it's
relatives are grouped together in their own section seems totally
counter-intuitive. Move it, also in the Makefile.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mfd/Kconfig  |   18 +++++++++---------
 drivers/mfd/Makefile |    3 ++-
 2 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 519ebab..f0d550b 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -171,6 +171,15 @@ config MFD_TPS6586X
 	  This driver can also be built as a module.  If so, the module
 	  will be called tps6586x.
 
+config MFD_TPS65910
+	bool "TPS65910 Power Management chip"
+	depends on I2C=y && GPIOLIB
+	select MFD_CORE
+	select GPIO_TPS65910
+	help
+	  if you say yes here you get support for the TPS65910 series of
+	  Power Management chips.
+
 config MFD_TPS65912
 	bool "TPS65912 PMIC"
 	depends on GPIOLIB
@@ -742,15 +751,6 @@ config MFD_PM8XXX_IRQ
 	  This is required to use certain other PM 8xxx features, such as GPIO
 	  and MPP.
 
-config MFD_TPS65910
-	bool "TPS65910 Power Management chip"
-	depends on I2C=y && GPIOLIB
-	select MFD_CORE
-	select GPIO_TPS65910
-	help
-	  if you say yes here you get support for the TPS65910 series of
-	  Power Management chips.
-
 endif # MFD_SUPPORT
 
 menu "Multimedia Capabilities Port drivers"
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 5309ec3..4747a4d 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -36,6 +36,7 @@ obj-$(CONFIG_MFD_WM8994)	+= wm8994-core.o wm8994-irq.o
 obj-$(CONFIG_TPS6105X)		+= tps6105x.o
 obj-$(CONFIG_TPS65010)		+= tps65010.o
 obj-$(CONFIG_TPS6507X)		+= tps6507x.o
+obj-$(CONFIG_MFD_TPS65910)	+= tps65910.o tps65910-irq.o
 tps65912-objs                   := tps65912-core.o tps65912-irq.o
 obj-$(CONFIG_MFD_TPS65912)	+= tps65912.o
 obj-$(CONFIG_MFD_TPS65912_I2C)	+= tps65912-i2c.o
@@ -98,4 +99,4 @@ obj-$(CONFIG_MFD_CS5535)	+= cs5535-mfd.o
 obj-$(CONFIG_MFD_OMAP_USB_HOST)	+= omap-usb-host.o
 obj-$(CONFIG_MFD_PM8921_CORE) 	+= pm8921-core.o
 obj-$(CONFIG_MFD_PM8XXX_IRQ) 	+= pm8xxx-irq.o
-obj-$(CONFIG_MFD_TPS65910)	+= tps65910.o tps65910-irq.o
+
-- 
1.7.3.2

