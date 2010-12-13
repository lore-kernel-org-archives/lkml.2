Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755181Ab0LMEFH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 23:05:07 -0500
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:52099 "EHLO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754137Ab0LMEEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 23:04:02 -0500
From: Sundar Iyer <sundar.iyer@stericsson.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: <linux-kernel@vger.kernel.org>, Sundar Iyer <sundar.iyer@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH v2 3/8] mfd/tc35892: rename tc35892 core driver to tc3589x
Date: Mon, 13 Dec 2010 09:33:13 +0530
Message-ID: <1292212998-13066-4-git-send-email-sundar.iyer@stericsson.com>
X-Mailer: git-send-email 1.7.2.dirty
In-Reply-To: <1292212998-13066-1-git-send-email-sundar.iyer@stericsson.com>
References: <1292212998-13066-1-git-send-email-sundar.iyer@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename the tc35892 core/gpio drivers to tc3589x to include
new variants in the same mfd core

Acked-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Sundar Iyer <sundar.iyer@stericsson.com>
---
 drivers/gpio/Kconfig                            |    8 ++++----
 drivers/gpio/Makefile                           |    2 +-
 drivers/gpio/{tc35892-gpio.c => tc3589x-gpio.c} |    0
 drivers/mfd/Kconfig                             |    6 +++---
 drivers/mfd/Makefile                            |    2 +-
 drivers/mfd/{tc35892.c => tc3589x.c}            |    0
 6 files changed, 9 insertions(+), 9 deletions(-)
 rename drivers/gpio/{tc35892-gpio.c => tc3589x-gpio.c} (100%)
 rename drivers/mfd/{tc35892.c => tc3589x.c} (100%)

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 3143ac7..082495b 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -230,11 +230,11 @@ config GPIO_STMPE
 	  This enables support for the GPIOs found on the STMPE I/O
 	  Expanders.
 
-config GPIO_TC35892
-	bool "TC35892 GPIOs"
-	depends on MFD_TC35892
+config GPIO_TC3589X
+	bool "TC3589X GPIOs"
+	depends on MFD_TC3589X
 	help
-	  This enables support for the GPIOs found on the TC35892
+	  This enables support for the GPIOs found on the TC3589X
 	  I/O Expander.
 
 config GPIO_TWL4030
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index bdf3dde..39bfd7a 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -24,7 +24,7 @@ obj-$(CONFIG_GPIO_PCF857X)	+= pcf857x.o
 obj-$(CONFIG_GPIO_PCH)		+= pch_gpio.o
 obj-$(CONFIG_GPIO_PL061)	+= pl061.o
 obj-$(CONFIG_GPIO_STMPE)	+= stmpe-gpio.o
-obj-$(CONFIG_GPIO_TC35892)	+= tc35892-gpio.o
+obj-$(CONFIG_GPIO_TC3589X)	+= tc3589x-gpio.o
 obj-$(CONFIG_GPIO_TIMBERDALE)	+= timbgpio.o
 obj-$(CONFIG_GPIO_TWL4030)	+= twl4030-gpio.o
 obj-$(CONFIG_GPIO_UCB1400)	+= ucb1400_gpio.o
diff --git a/drivers/gpio/tc35892-gpio.c b/drivers/gpio/tc3589x-gpio.c
similarity index 100%
rename from drivers/gpio/tc35892-gpio.c
rename to drivers/gpio/tc3589x-gpio.c
diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index c856aa7..a4c2e3e 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -218,12 +218,12 @@ config MFD_STMPE
 		Keypad: stmpe-keypad
 		Touchscreen: stmpe-ts
 
-config MFD_TC35892
-	bool "Support Toshiba TC35892"
+config MFD_TC3589X
+	bool "Support Toshiba TC35892 and variants"
 	depends on I2C=y && GENERIC_HARDIRQS
 	select MFD_CORE
 	help
-	  Support for the Toshiba TC35892 I/O Expander.
+	  Support for the Toshiba TC35892 and variants I/O Expander.
 
 	  This driver provides common support for accessing the device,
 	  additional drivers must be enabled in order to use the
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 67c8bcb..e42e0889 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -16,7 +16,7 @@ obj-$(CONFIG_MFD_DAVINCI_VOICECODEC)	+= davinci_voicecodec.o
 obj-$(CONFIG_MFD_DM355EVM_MSP)	+= dm355evm_msp.o
 
 obj-$(CONFIG_MFD_STMPE)		+= stmpe.o
-obj-$(CONFIG_MFD_TC35892)	+= tc35892.o
+obj-$(CONFIG_MFD_TC3589X)	+= tc3589x.o
 obj-$(CONFIG_MFD_T7L66XB)	+= t7l66xb.o tmio_core.o
 obj-$(CONFIG_MFD_TC6387XB)	+= tc6387xb.o tmio_core.o
 obj-$(CONFIG_MFD_TC6393XB)	+= tc6393xb.o tmio_core.o
diff --git a/drivers/mfd/tc35892.c b/drivers/mfd/tc3589x.c
similarity index 100%
rename from drivers/mfd/tc35892.c
rename to drivers/mfd/tc3589x.c
-- 
1.7.2.dirty

