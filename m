Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756805Ab1CaCkL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 22:40:11 -0400
Received: from [12.234.97.163] ([12.234.97.163]:6176 "EHLO
	brontomerus.synaptics.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755418Ab1CaCkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 22:40:09 -0400
From: Christopher Heiny <cheiny@synaptics.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jean Delvare <khali@linux-fr.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Christopher Heiny <cheiny@synaptics.com>,
        Allie Xiong <axiong@synaptics.com>,
        William Manson <wmanson@synaptics.com>,
        Joerie de Gram <j.de.gram@gmail.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
Subject: [PATCH 3/3] (corrected) input/touchscreen: Synaptics RMI4 Touchscreen Driver
Date: Wed, 30 Mar 2011 19:39:29 -0700
Message-Id: <1301539169-9105-4-git-send-email-cheiny@synaptics.com>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1301539169-9105-1-git-send-email-cheiny@synaptics.com>
References: <1301539169-9105-1-git-send-email-cheiny@synaptics.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Driver for Synaptics touchscreens using RMI4 protocol.

Signed-off-by: William Manson <wmanson@synaptics.com>
Signed-off-by: Allie Xiong <axiong@synaptics.com>
Signed-off-by: Christopher Heiny <cheiny@synaptics.com>

Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>
Cc: Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
Cc: Joeri de Gram <j.de.gram@gmail.com>

Acked-by: Jean Delvare <khali@linux-fr.org>

---

diff --git a/drivers/input/touchscreen/Makefile b/drivers/input/touchscreen/Makefile
index 718bcc8..99dfa52 100644
--- a/drivers/input/touchscreen/Makefile
+++ b/drivers/input/touchscreen/Makefile
@@ -12,6 +12,7 @@ obj-$(CONFIG_TOUCHSCREEN_AD7879)	+= ad7879.o
 obj-$(CONFIG_TOUCHSCREEN_AD7879_I2C)	+= ad7879-i2c.o
 obj-$(CONFIG_TOUCHSCREEN_AD7879_SPI)	+= ad7879-spi.o
 obj-$(CONFIG_TOUCHSCREEN_ADS7846)	+= ads7846.o
+obj-$(CONFIG_TOUCHSCREEN_ATMEL_MXT)	+= atmel_mxt_ts.o
 obj-$(CONFIG_TOUCHSCREEN_ATMEL_TSADCC)	+= atmel_tsadcc.o
 obj-$(CONFIG_TOUCHSCREEN_BITSY)		+= h3600_ts_input.o
 obj-$(CONFIG_TOUCHSCREEN_BU21013)       += bu21013_ts.o
@@ -37,17 +38,28 @@ obj-$(CONFIG_TOUCHSCREEN_HTCPEN)	+= htcpen.o
 obj-$(CONFIG_TOUCHSCREEN_USB_COMPOSITE)	+= usbtouchscreen.o
 obj-$(CONFIG_TOUCHSCREEN_PCAP)		+= pcap_ts.o
 obj-$(CONFIG_TOUCHSCREEN_PENMOUNT)	+= penmount.o
-obj-$(CONFIG_TOUCHSCREEN_QT602240)	+= qt602240_ts.o
 obj-$(CONFIG_TOUCHSCREEN_S3C2410)	+= s3c2410_ts.o
 obj-$(CONFIG_TOUCHSCREEN_ST1232)	+= st1232.o
 obj-$(CONFIG_TOUCHSCREEN_STMPE)		+= stmpe-ts.o
+CFLAGS_rmi_bus.o := -DDEBUG
+CFLAGS_rmi_sensor.o := -DDEBUG
+CFLAGS_rmi_function.o := -DDEBUG
+CFLAGS_rmi_f01.o := -DDEBUG
+CFLAGS_rmi_f11.o := -DDEBUG
+CFLAGS_rmi_f19.o := -DDEBUG
+CFLAGS_rmi_f34.o := -DDEBUG
+CFLAGS_rmi_i2c.o := -DDEBUG
+obj-$(CONFIG_TOUCHSCREEN_SYNAPTICS_RMI4_I2C)	+=  rmi_bus.o rmi_sensor.o rmi_function.o rmi_f01.o rmi_f11.o rmi_f19.o rmi_f34.o rmi_i2c.o
+obj-$(CONFIG_TOUCHSCREEN_SYNAPTICS_RMI4_SPI)	+=  rmi_bus.o rmi_sensor.o rmi_function.o rmi_f01.o rmi_f11.o rmi_f19.o rmi_f34.o rmi_spi.o
 obj-$(CONFIG_TOUCHSCREEN_TNETV107X)	+= tnetv107x-ts.o
 obj-$(CONFIG_TOUCHSCREEN_TOUCHIT213)	+= touchit213.o
 obj-$(CONFIG_TOUCHSCREEN_TOUCHRIGHT)	+= touchright.o
 obj-$(CONFIG_TOUCHSCREEN_TOUCHWIN)	+= touchwin.o
+obj-$(CONFIG_TOUCHSCREEN_TSC2005)	+= tsc2005.o
 obj-$(CONFIG_TOUCHSCREEN_TSC2007)	+= tsc2007.o
 obj-$(CONFIG_TOUCHSCREEN_UCB1400)	+= ucb1400_ts.o
 obj-$(CONFIG_TOUCHSCREEN_WACOM_W8001)	+= wacom_w8001.o
+obj-$(CONFIG_TOUCHSCREEN_WM831X)	+= wm831x-ts.o
 obj-$(CONFIG_TOUCHSCREEN_WM97XX)	+= wm97xx-ts.o
 wm97xx-ts-$(CONFIG_TOUCHSCREEN_WM9705)	+= wm9705.o
 wm97xx-ts-$(CONFIG_TOUCHSCREEN_WM9712)	+= wm9712.o
diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
index 61834ae..62cfc70 100644
--- a/drivers/input/touchscreen/Kconfig
+++ b/drivers/input/touchscreen/Kconfig
@@ -86,6 +86,18 @@ config TOUCHSCREEN_AD7879_SPI
 	  To compile this driver as a module, choose M here: the
 	  module will be called ad7879-spi.
 
+config TOUCHSCREEN_ATMEL_MXT
+	tristate "Atmel mXT I2C Touchscreen"
+	depends on I2C
+	help
+	  Say Y here if you have Atmel mXT series I2C touchscreen,
+	  such as AT42QT602240/ATMXT224, connected to your system.
+
+	  If unsure, say N.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called atmel_mxt_ts.
+
 config TOUCHSCREEN_BITSY
 	tristate "Compaq iPAQ H3600 (Bitsy) touchscreen"
 	depends on SA1100_BITSY
@@ -339,18 +351,6 @@ config TOUCHSCREEN_PENMOUNT
 	  To compile this driver as a module, choose M here: the
 	  module will be called penmount.
 
-config TOUCHSCREEN_QT602240
-	tristate "QT602240 I2C Touchscreen"
-	depends on I2C
-	help
-	  Say Y here if you have the AT42QT602240/ATMXT224 I2C touchscreen
-	  connected to your system.
-
-	  If unsure, say N.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called qt602240_ts.
-
 config TOUCHSCREEN_MIGOR
 	tristate "Renesas MIGO-R touchscreen"
 	depends on SH_MIGOR && I2C
@@ -362,6 +362,36 @@ config TOUCHSCREEN_MIGOR
 	  To compile this driver as a module, choose M here: the
 	  module will be called migor_ts.
 
+config TOUCHSCREEN_SYNAPTICS_RMI4_I2C
+	tristate "Synaptics RMI4 I2C touchscreens"
+	depends on I2C
+	help
+	  Say Y here if you have a Synaptics RMI4 I2C touchscreen connected to
+	  your system. This enables support for Synaptics RMI4 over I2C based
+	  touchscreens.
+
+	  If unsure, say N.
+
+	  To compile this driver as a set of modules, choose M here: the
+	  modules will be called rmi_core, rmi_app_touchpad, rmi_phys_i2c.
+
+config TOUCHSCREEN_SYNAPTICS_RMI4_SPI
+	tristate "Synaptics RMI4 SPI touchscreens"
+	depends on SPI
+	help
+	  Say Y here if you have a Synaptics RMI4 SPI touchscreen connected to
+	  your system. This enables support for Synaptics RMI4 over SPI based
+	  touchscreens.
+
+	  If unsure, say N.
+
+	  To compile this driver as a set of modules, choose M here: the
+	  modules will be called rmi_core, rmi_app_touchpad, rmi_phys_spi.
+
+config SYNA_MULTI_TOUCH
+	bool "Synaptics pointing using multi-touch events"
+	depends on TOUCHSCREEN_SYNAPTICS_RMI4_I2C || TOUCHSCREEN_SYNAPTICS_RMI4_SPI
+
 config TOUCHSCREEN_TNETV107X
 	tristate "TI TNETV107X touchscreen support"
 	depends on ARCH_DAVINCI_TNETV107X
@@ -423,6 +453,16 @@ config TOUCHSCREEN_UCB1400
 	  To compile this driver as a module, choose M here: the
 	  module will be called ucb1400_ts.
 
+config TOUCHSCREEN_WM831X
+	tristate "Support for WM831x touchscreen controllers"
+	depends on MFD_WM831X
+	help
+	  This enables support for the touchscreen controller on the WM831x
+	  series of PMICs.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called wm831x-ts.
+
 config TOUCHSCREEN_WM97XX
 	tristate "Support for WM97xx AC97 touchscreen controllers"
 	depends on AC97_BUS
@@ -629,6 +669,17 @@ config TOUCHSCREEN_TOUCHIT213
 	  To compile this driver as a module, choose M here: the
 	  module will be called touchit213.
 
+config TOUCHSCREEN_TSC2005
+        tristate "TSC2005 based touchscreens"
+        depends on SPI_MASTER && GENERIC_HARDIRQS
+        help
+          Say Y here if you have a TSC2005 based touchscreen.
+
+	  If unsure, say N.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called tsc2005.
+
 config TOUCHSCREEN_TSC2007
 	tristate "TSC2007 based touchscreens"
 	depends on I2C
