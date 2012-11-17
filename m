Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043Ab2KQEAO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 23:00:14 -0500
Received: from [12.239.217.82] ([12.239.217.82]:64069 "EHLO
	brontomerus.synaptics.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753904Ab2KQEAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 23:00:10 -0500
From: Christopher Heiny <cheiny@synaptics.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jean Delvare <khali@linux-fr.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Christopher Heiny <cheiny@synaptics.com>,
        Allie Xiong <axiong@synaptics.com>, Vivian Ly <vly@synaptics.com>,
        Daniel Rosenberg <daniel.rosenberg@synaptics.com>,
        Alexandra Chin <alexandra.chin@tw.synaptics.com>,
        Joerie de Gram <j.de.gram@gmail.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
Subject: [RFC PATCH 04/06] input/rmi4: Config files and makefiles
Date: Fri, 16 Nov 2012 19:58:52 -0800
Message-Id: <1353124734-16803-5-git-send-email-cheiny@synaptics.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1353124734-16803-1-git-send-email-cheiny@synaptics.com>
References: <1353124734-16803-1-git-send-email-cheiny@synaptics.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Infrastructure files for configuration and building.


Signed-off-by: Christopher Heiny <cheiny@synaptics.com>

Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>
Cc: Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
Cc: Joeri de Gram <j.de.gram@gmail.com>


---

 drivers/input/Kconfig       |    2 +
 drivers/input/Makefile      |    3 ++
 drivers/input/rmi4/Kconfig  |   76 +++++++++++++++++++++++++++++++++++++++++++
 drivers/input/rmi4/Makefile |   22 ++++++++++++
 4 files changed, 103 insertions(+), 0 deletions(-)

diff --git a/drivers/input/Kconfig b/drivers/input/Kconfig
index 55f7e57..2c543c0 100644
--- a/drivers/input/Kconfig
+++ b/drivers/input/Kconfig
@@ -188,6 +188,8 @@ source "drivers/input/touchscreen/Kconfig"

 source "drivers/input/misc/Kconfig"

+source "drivers/input/rmi4/Kconfig"
+
 endif

 menu "Hardware I/O ports"
diff --git a/drivers/input/Makefile b/drivers/input/Makefile
index 5ca3f63..88354fc 100644
--- a/drivers/input/Makefile
+++ b/drivers/input/Makefile
@@ -24,4 +24,7 @@ obj-$(CONFIG_INPUT_TABLET)	+= tablet/
 obj-$(CONFIG_INPUT_TOUCHSCREEN)	+= touchscreen/
 obj-$(CONFIG_INPUT_MISC)	+= misc/

+obj-y += rmi4/
+
 obj-$(CONFIG_INPUT_APMPOWER)	+= apm-power.o
+
diff --git a/drivers/input/rmi4/Kconfig b/drivers/input/rmi4/Kconfig
new file mode 100644
index 0000000..41cbbee
--- /dev/null
+++ b/drivers/input/rmi4/Kconfig
@@ -0,0 +1,76 @@
+#
+# RMI4 configuration
+#
+config RMI4_BUS
+	bool "Synaptics RMI4 bus support"
+	help
+	  Say Y here if you want to support the Synaptics RMI4 bus.  This is
+	  required for all RMI4 device support.
+
+	  If unsure, say Y.
+
+	  This feature is not currently available as a loadable module.
+
+config RMI4_DEBUG
+	bool "RMI4 Debugging"
+	depends on RMI4_BUS
+	select DEBUG_FS
+	help
+	  Say Y here to enable debug feature in the RMI4 driver.
+
+	  Note that the RMI4 driver debug features can generate a lot of
+	  output (potentially clogging up your dmesg output) and generally
+	  slow down driver operation.  It's recommended to enable them only
+	  if you are actively developing/debugging RMI4 features.
+
+	  If unsure, say N.
+
+config RMI4_I2C
+	bool "RMI4 I2C Support"
+	depends on RMI4_BUS && I2C
+	help
+	  Say Y here if you want to support RMI4 devices connected to an I2C
+	  bus.
+
+	  If unsure, say Y.
+
+	  This feature is not currently available as a loadable module.
+
+config RMI4_GENERIC
+	bool "RMI4 Generic driver"
+	depends on RMI4_BUS
+	help
+	  Say Y here if you want to support generic RMI4 devices.
+
+	  This is pretty much required if you want to do anything useful with
+	  your RMI device.
+
+	  This feature is not currently available as a loadable module.
+
+config RMI4_F11
+	tristate "RMI4 Function 11 (2D pointing)"
+	depends on RMI4_BUS && RMI4_GENERIC
+	help
+	  Say Y here if you want to add support for RMI4 function 11.
+
+	  Function 11 provides 2D multifinger pointing for touchscreens and
+	  touchpads.  For sensors that support relative pointing, F11 also
+	  provides mouse input.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called rmi-f11.
+
+config RMI4_F11_PEN
+	bool "RMI4 F11 Pen Support"
+	depends on RMI4_F11
+	help
+	  Say Y here to add support for pen input to RMI4 function 11.
+
+	  If this feature is enabled, when pen inputs are detected they
+	  will be reported to the input stream as MT_TOOL_PEN.  Otherwise,
+	  pens will be treated the same as fingers.
+
+	  Not all UI implementations deal gracefully with pen discrimination.
+	  If your system is not recognizing pen touches and you know your
+	  sensor supports pen input, you probably want to turn this feature
+	  off.
diff --git a/drivers/input/rmi4/Makefile b/drivers/input/rmi4/Makefile
new file mode 100644
index 0000000..8882c3d
--- /dev/null
+++ b/drivers/input/rmi4/Makefile
@@ -0,0 +1,22 @@
+obj-$(CONFIG_RMI4_BUS) += rmi_bus.o
+obj-$(CONFIG_RMI4_I2C) += rmi_i2c.o
+obj-$(CONFIG_RMI4_GENERIC) += rmi_driver.o rmi_f01.o
+obj-$(CONFIG_RMI4_F11) += rmi_f11.o
+
+ccflags-$(CONFIG_RMI4_DEBUG) += -DDEBUG
+
+ifeq ($(KERNELRELEASE),)
+
+# KERNELDIR ?= /home/<AndroidKernelDirectory>
+PWD := $(shell pwd)
+
+.PHONY: build clean
+
+build:
+	$(MAKE) -C $(KERNELDIR) M=$(PWD) modules
+
+clean:
+	rm -rf *.o *~ core .depend .*.cmd *.ko *.mod.c
+
+endif
+
