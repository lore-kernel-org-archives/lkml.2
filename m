Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863Ab1LVCXJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 21:23:09 -0500
Received: from [12.239.217.82] ([12.239.217.82]:9459 "EHLO venom.synaptics.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754668Ab1LVCUa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 21:20:30 -0500
X-Greylist: delayed 592 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Dec 2011 21:20:28 EST
From: Christopher Heiny <cheiny@synaptics.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jean Delvare <khali@linux-fr.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Christopher Heiny <cheiny@synaptics.com>,
        Joerie de Gram <j.de.gram@gmail.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
Subject: [RFC PATCH 4/11] input: RMI4 KConfigs and Makefiles.
Date: Wed, 21 Dec 2011 18:09:55 -0800
Message-Id: <1324519802-23894-5-git-send-email-cheiny@synaptics.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1324519802-23894-1-git-send-email-cheiny@synaptics.com>
References: <1324519802-23894-1-git-send-email-cheiny@synaptics.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christopher Heiny <cheiny@synaptics.com>

Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>
Cc: Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
Cc: Joeri de Gram <j.de.gram@gmail.com>


---

 drivers/input/Kconfig       |    2 +
 drivers/input/Makefile      |    2 +
 drivers/input/rmi4/Kconfig  |  116 +++++++++++++++++++++++++++++++++++++++++++
 drivers/input/rmi4/Makefile |   30 +++++++++++
 4 files changed, 150 insertions(+), 0 deletions(-)

diff --git a/drivers/input/Kconfig b/drivers/input/Kconfig
index 1903c0f..0cdd8a5 100644
--- a/drivers/input/Kconfig
+++ b/drivers/input/Kconfig
@@ -185,6 +185,8 @@ source "drivers/input/touchscreen/Kconfig"
 
 source "drivers/input/misc/Kconfig"
 
+source "drivers/input/rmi4/Kconfig"
+
 endif
 
 menu "Hardware I/O ports"
diff --git a/drivers/input/Makefile b/drivers/input/Makefile
index 09614ce..18383b9 100644
--- a/drivers/input/Makefile
+++ b/drivers/input/Makefile
@@ -23,6 +23,8 @@ obj-$(CONFIG_INPUT_TABLET)	+= tablet/
 obj-$(CONFIG_INPUT_TOUCHSCREEN)	+= touchscreen/
 obj-$(CONFIG_INPUT_MISC)	+= misc/
 
+obj-y += rmi4/
+
 obj-$(CONFIG_INPUT_APMPOWER)	+= apm-power.o
 
 obj-$(CONFIG_XEN_KBDDEV_FRONTEND)	+= xen-kbdfront.o
diff --git a/drivers/input/rmi4/Kconfig b/drivers/input/rmi4/Kconfig
new file mode 100644
index 0000000..06a6a07
--- /dev/null
+++ b/drivers/input/rmi4/Kconfig
@@ -0,0 +1,116 @@
+#
+# RMI4 configuration
+#
+config RMI4_BUS
+	bool "Synaptics RMI4 bus support"
+	help
+	  Say Y here if you want to support the Synaptics RMI4 bus.
+
+	  If unsure, say Y.
+
+	  This feature is not currently available as
+	  a loadable module.
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
+config RMI4_SPI
+	bool "RMI4 SPI Support"
+	depends on RMI4_BUS && SPI
+	help
+	  Say Y here if you want to support RMI4 devices connected to an SPI
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
+config RMI4_F09
+	tristate "RMI4 Function 09 (self testing)"
+	depends on RMI4_BUS && RMI4_GENERIC
+	help
+	  Say Y here if you want to add support for RMI4 function 09.
+
+	  Function 09 provides self testing for touchscreens and touchpads.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called rmi-f09.
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
+config RMI4_F19
+	tristate "RMI4 Function 19 (0D pointing)"
+	depends on RMI4_BUS && RMI4_GENERIC
+	help
+	  Say Y here if you want to add support for RMI4 function 19.
+
+	  Function 19 provides support for capacitive buttons for sensors
+	  that implement capacitive buttons.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called rmi-f19.
+
+config RMI4_F34
+	tristate "RMI4 Function 34 (device reflash)"
+	depends on RMI4_BUS && RMI4_GENERIC
+	help
+	  Say Y here if you want to add support for RMI4 function 34.
+
+	  Function 34 provides firmware upgrade capability for your sensor.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called rmi-f34.
+
+config RMI4_F54
+	tristate "RMI4 Function 54 (analog diagnostics)"
+	depends on RMI4_BUS && RMI4_GENERIC
+	help
+	  Say Y here if you want to add support for RMI4 function 54.
+
+	  Function 54 provides access to various diagnostic features in
+	  certain RMI4 touch sensors.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called rmi-f54.
+
+config RMI4_DEV
+	tristate "Synaptics direct RMI device support (rmidev)"
+	depends on GPIO_SYSFS && (RMI4_I2C || RMI4_SPI)
+	help
+	  Say Y here to add support for rmidev.
+
+	  The rmidev feature implements a character device providing access
+	  to RMI4 sensor register maps.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called rmi-dev.
diff --git a/drivers/input/rmi4/Makefile b/drivers/input/rmi4/Makefile
new file mode 100644
index 0000000..be0c54b
--- /dev/null
+++ b/drivers/input/rmi4/Makefile
@@ -0,0 +1,30 @@
+obj-$(CONFIG_RMI4_BUS) += rmi_bus.o
+obj-$(CONFIG_RMI4_I2C) += rmi_i2c.o
+obj-$(CONFIG_RMI4_SPI) += rmi_spi.o
+obj-$(CONFIG_RMI4_GENERIC) += rmi_driver.o rmi_f01.o
+obj-$(CONFIG_RMI4_F09) += rmi_f09.o
+obj-$(CONFIG_RMI4_F11) += rmi_f11.o
+obj-$(CONFIG_RMI4_F19) += rmi_f19.o
+obj-$(CONFIG_RMI4_F34) += rmi_f34.o
+obj-$(CONFIG_RMI4_F54) += rmi_f54.o
+obj-$(CONFIG_RMI4_DEV) += rmi_dev.o
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
+else
+
+$(info Building with KERNELRELEASE = ${KERNELRELEASE})
+obj-m :=    rmi_dev.o
+
+endif
+
