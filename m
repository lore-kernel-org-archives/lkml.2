Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977Ab1C3OY1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 10:24:27 -0400
Received: from misc-148-66-126-238.pool.starband.net ([148.66.126.238]:48832
	"EHLO brontomerus.synaptics.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754812Ab1C3OYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 10:24:25 -0400
X-Greylist: delayed 983 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 Mar 2011 10:24:12 EDT
From: Christopher Heiny <cheiny@synaptics.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jean Delvare <khali@linux-fr.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Christopher Heiny <cheiny@synaptics.com>,
        Allie Xiong <axiong@synaptics.com>,
        William Manson <wmanson@synaptics.com>,
        Joerie de Gram <j.de.gram@gmail.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
Subject: [PATCH 3/3] (corrected) input/touchscreen: Synaptics RMI4 Touchscreen Driver
Date: Wed, 30 Mar 2011 07:05:27 -0700
Message-Id: <1301493927-30237-4-git-send-email-cheiny@synaptics.com>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1301493927-30237-1-git-send-email-cheiny@synaptics.com>
References: <1301493927-30237-1-git-send-email-cheiny@synaptics.com>
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
index 718bcc8..3181008 100644
--- a/drivers/input/touchscreen/Makefile
+++ b/drivers/input/touchscreen/Makefile
@@ -41,6 +41,16 @@ obj-$(CONFIG_TOUCHSCREEN_QT602240)	+= qt602240_ts.o
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
diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
index 61834ae..2b2f6dc 100644
--- a/drivers/input/touchscreen/Kconfig
+++ b/drivers/input/touchscreen/Kconfig
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
