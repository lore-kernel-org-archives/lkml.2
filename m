Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755933Ab0GZXe1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 19:34:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25944 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755829Ab0GZXeY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 19:34:24 -0400
Date: Mon, 26 Jul 2010 19:34:23 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-media@vger.kernel.org, linux-input@vger.kernel.org
Subject: [PATCH 15/15] staging/lirc: wire up Kconfig and Makefile bits
Message-ID: <20100726233423.GP21225@redhat.com>
References: <20100726232546.GA21225@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100726232546.GA21225@redhat.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the bits under staging/lirc/ buildable, and add a TODO note.

Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/staging/Kconfig       |    2 +
 drivers/staging/Makefile      |    1 +
 drivers/staging/lirc/Kconfig  |  110 +++++++++++++++++++++++++++++++++++++++++
 drivers/staging/lirc/Makefile |   19 +++++++
 drivers/staging/lirc/TODO     |    8 +++
 5 files changed, 140 insertions(+), 0 deletions(-)
 create mode 100644 drivers/staging/lirc/Kconfig
 create mode 100644 drivers/staging/lirc/Makefile
 create mode 100644 drivers/staging/lirc/TODO

diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
index 9fc196d..fad88fb 100644
--- a/drivers/staging/Kconfig
+++ b/drivers/staging/Kconfig
@@ -155,5 +155,7 @@ source "drivers/staging/tidspbridge/Kconfig"
 
 source "drivers/staging/quickstart/Kconfig"
 
+source "drivers/staging/lirc/Kconfig"
+
 endif # !STAGING_EXCLUDE_BUILD
 endif # STAGING
diff --git a/drivers/staging/Makefile b/drivers/staging/Makefile
index 26942aa..27bb127 100644
--- a/drivers/staging/Makefile
+++ b/drivers/staging/Makefile
@@ -58,3 +58,4 @@ obj-$(CONFIG_EASYCAP)		+= easycap/
 obj-$(CONFIG_SOLO6X10)		+= solo6x10/
 obj-$(CONFIG_TIDSPBRIDGE)	+= tidspbridge/
 obj-$(CONFIG_ACPI_QUICKSTART)	+= quickstart/
+obj-$(CONFIG_LIRC_STAGING)	+= lirc/
diff --git a/drivers/staging/lirc/Kconfig b/drivers/staging/lirc/Kconfig
new file mode 100644
index 0000000..968c2ad
--- /dev/null
+++ b/drivers/staging/lirc/Kconfig
@@ -0,0 +1,110 @@
+#
+# LIRC driver(s) configuration
+#
+menuconfig LIRC_STAGING
+	bool "Linux Infrared Remote Control IR receiver/transmitter drivers"
+	help
+	  Say Y here, and all supported Linux Infrared Remote Control IR and
+	  RF receiver and transmitter drivers will be displayed. When paired
+	  with a remote control and the lirc daemon, the receiver drivers
+	  allow control of your Linux system via remote control.
+
+if LIRC_STAGING
+
+config LIRC_BT829
+        tristate "BT829 based hardware"
+	depends on LIRC_STAGING
+	help
+	  Driver for the IR interface on BT829-based hardware
+
+config LIRC_ENE0100
+	tristate "ENE KB3924/ENE0100 CIR Port Reciever"
+	depends on LIRC_STAGING
+	help
+	  This is a driver for CIR port handled by ENE KB3924 embedded
+	  controller found on some notebooks.
+	  It appears on PNP list as ENE0100.
+
+config LIRC_I2C
+	tristate "I2C Based IR Receivers"
+	depends on LIRC_STAGING
+	help
+	  Driver for I2C-based IR receivers, such as those commonly
+	  found onboard Hauppauge PVR-150/250/350 video capture cards
+
+config LIRC_IGORPLUGUSB
+	tristate "Igor Cesko's USB IR Receiver"
+	depends on LIRC_STAGING && USB
+	help
+	  Driver for Igor Cesko's USB IR Receiver
+
+config LIRC_IMON
+	tristate "Legacy SoundGraph iMON Receiver and Display"
+	depends on LIRC_STAGING
+	help
+	  Driver for the original SoundGraph iMON IR Receiver and Display
+
+	  Current generation iMON devices use the input layer imon driver.
+
+config LIRC_IT87
+	tristate "ITE IT87XX CIR Port Receiver"
+	depends on LIRC_STAGING
+	help
+	  Driver for the ITE IT87xx IR Receiver
+
+config LIRC_ITE8709
+	tristate "ITE8709 CIR Port Receiver"
+	depends on LIRC_STAGING && PNP
+	help
+	  Driver for the ITE8709 IR Receiver
+
+config LIRC_PARALLEL
+	tristate "Homebrew Parallel Port Receiver"
+	depends on LIRC_STAGING && !SMP
+	help
+	  Driver for Homebrew Parallel Port Receivers
+
+config LIRC_SASEM
+	tristate "Sasem USB IR Remote"
+	depends on LIRC_STAGING
+	help
+	  Driver for the Sasem OnAir Remocon-V or Dign HV5 HTPC IR/VFD Module
+
+config LIRC_SERIAL
+	tristate "Homebrew Serial Port Receiver"
+	depends on LIRC_STAGING
+	help
+	  Driver for Homebrew Serial Port Receivers
+
+config LIRC_SERIAL_TRANSMITTER
+	bool "Serial Port Transmitter"
+	default y
+	depends on LIRC_SERIAL
+	help
+	  Serial Port Transmitter support
+
+config LIRC_SIR
+	tristate "Built-in SIR IrDA port"
+	depends on LIRC_STAGING
+	help
+	  Driver for the SIR IrDA port
+
+config LIRC_STREAMZAP
+	tristate "Streamzap PC Receiver"
+	depends on LIRC_STAGING
+	help
+	  Driver for the Streamzap PC Receiver
+
+config LIRC_TTUSBIR
+	tristate "Technotrend USB IR Receiver"
+	depends on LIRC_STAGING && USB
+	help
+	  Driver for the Technotrend USB IR Receiver
+
+config LIRC_ZILOG
+	tristate "Zilog/Hauppauge IR Transmitter"
+	depends on LIRC_STAGING
+	help
+	  Driver for the Zilog/Hauppauge IR Transmitter, found on
+	  PVR-150/500, HVR-1200/1250/1700/1800, HD-PVR and other cards
+endif
diff --git a/drivers/staging/lirc/Makefile b/drivers/staging/lirc/Makefile
new file mode 100644
index 0000000..a019182
--- /dev/null
+++ b/drivers/staging/lirc/Makefile
@@ -0,0 +1,19 @@
+# Makefile for the lirc drivers.
+#
+
+# Each configuration option enables a list of files.
+
+obj-$(CONFIG_LIRC_BT829)	+= lirc_bt829.o
+obj-$(CONFIG_LIRC_ENE0100)	+= lirc_ene0100.o
+obj-$(CONFIG_LIRC_I2C)		+= lirc_i2c.o
+obj-$(CONFIG_LIRC_IGORPLUGUSB)	+= lirc_igorplugusb.o
+obj-$(CONFIG_LIRC_IMON)		+= lirc_imon.o
+obj-$(CONFIG_LIRC_IT87)		+= lirc_it87.o
+obj-$(CONFIG_LIRC_ITE8709)	+= lirc_ite8709.o
+obj-$(CONFIG_LIRC_PARALLEL)	+= lirc_parallel.o
+obj-$(CONFIG_LIRC_SASEM)	+= lirc_sasem.o
+obj-$(CONFIG_LIRC_SERIAL)	+= lirc_serial.o
+obj-$(CONFIG_LIRC_SIR)		+= lirc_sir.o
+obj-$(CONFIG_LIRC_STREAMZAP)	+= lirc_streamzap.o
+obj-$(CONFIG_LIRC_TTUSBIR)	+= lirc_ttusbir.o
+obj-$(CONFIG_LIRC_ZILOG)	+= lirc_zilog.o
diff --git a/drivers/staging/lirc/TODO b/drivers/staging/lirc/TODO
new file mode 100644
index 0000000..b6cb593
--- /dev/null
+++ b/drivers/staging/lirc/TODO
@@ -0,0 +1,8 @@
+- All drivers should either be ported to ir-core, or dropped entirely
+  (see drivers/media/IR/mceusb.c vs. lirc_mceusb.c in lirc cvs for an
+  example of a previously completed port).
+
+Please send patches to:
+Jarod Wilson <jarod@wilsonet.com>
+Greg Kroah-Hartman <greg@kroah.com>
+
-- 
1.7.1.1

-- 
Jarod Wilson
jarod@redhat.com

