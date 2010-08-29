Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167Ab0H2VH3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 17:07:29 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:52161 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754070Ab0H2VGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 17:06:48 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 3/5] tty/hvc: move files to drivers/tty/hvc
Date: Sun, 29 Aug 2010 23:06:33 +0200
Message-Id: <1283115995-4734-4-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1283115995-4734-1-git-send-email-arnd@arndb.de>
References: <1283115995-4734-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:pfXH5cGAhCfmR5WwsgklE8BOZ+8qVnsncB8QMvnrBno
 Vfh63VaFJPF+BuVT/ABsMw0N+vh5vGY1NvXyH8GCf3cgidndJ8
 QdMwEqA66JSM3lW7rs4xo/AJmrTsijbAvUoCHunm3cSqv/tamH
 ymzgkQjfScnTo8d1l5HW/YNljYsIHTLBSK4IA5oyus58s7w5zy
 dyc/itYMOtCKp0zUvQ8hQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All hvc device drivers fall into the same category
of tty drivers, so it makes sense to keep them
in a single directory.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 MAINTAINERS                                |    4 +-
 drivers/char/Kconfig                       |  103 +---------------------------
 drivers/char/Makefile                      |   12 ---
 drivers/tty/Makefile                       |    2 +
 drivers/tty/hvc/Kconfig                    |  104 ++++++++++++++++++++++++++++
 drivers/tty/hvc/Makefile                   |   12 +++
 drivers/{char => tty/hvc}/hvc_beat.c       |    0
 drivers/{char => tty/hvc}/hvc_console.c    |    0
 drivers/{char => tty/hvc}/hvc_console.h    |    0
 drivers/{char => tty/hvc}/hvc_irq.c        |    0
 drivers/{char => tty/hvc}/hvc_iseries.c    |    0
 drivers/{char => tty/hvc}/hvc_iucv.c       |    0
 drivers/{char => tty/hvc}/hvc_rtas.c       |    0
 drivers/{char => tty/hvc}/hvc_tile.c       |    0
 drivers/{char => tty/hvc}/hvc_udbg.c       |    0
 drivers/{char => tty/hvc}/hvc_vio.c        |    0
 drivers/{char => tty/hvc}/hvc_xen.c        |    0
 drivers/{char => tty/hvc}/hvcs.c           |    0
 drivers/{char => tty/hvc}/hvsi.c           |    0
 drivers/{char => tty/hvc}/virtio_console.c |    0
 20 files changed, 121 insertions(+), 116 deletions(-)
 create mode 100644 drivers/tty/hvc/Kconfig
 create mode 100644 drivers/tty/hvc/Makefile
 rename drivers/{char => tty/hvc}/hvc_beat.c (100%)
 rename drivers/{char => tty/hvc}/hvc_console.c (100%)
 rename drivers/{char => tty/hvc}/hvc_console.h (100%)
 rename drivers/{char => tty/hvc}/hvc_irq.c (100%)
 rename drivers/{char => tty/hvc}/hvc_iseries.c (100%)
 rename drivers/{char => tty/hvc}/hvc_iucv.c (100%)
 rename drivers/{char => tty/hvc}/hvc_rtas.c (100%)
 rename drivers/{char => tty/hvc}/hvc_tile.c (100%)
 rename drivers/{char => tty/hvc}/hvc_udbg.c (100%)
 rename drivers/{char => tty/hvc}/hvc_vio.c (100%)
 rename drivers/{char => tty/hvc}/hvc_xen.c (100%)
 rename drivers/{char => tty/hvc}/hvcs.c (100%)
 rename drivers/{char => tty/hvc}/hvsi.c (100%)
 rename drivers/{char => tty/hvc}/virtio_console.c (100%)

diff --git a/MAINTAINERS b/MAINTAINERS
index 794f630..637a866 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2566,7 +2566,7 @@ F:	mm/hwpoison-inject.c
 HYPERVISOR VIRTUAL CONSOLE DRIVER
 L:	linuxppc-dev@ozlabs.org
 S:	Odd Fixes
-F:	drivers/char/hvc_*
+F:	drivers/tty/hvc/hvc_*
 
 iSCSI BOOT FIRMWARE TABLE (iBFT) DRIVER
 M:	Peter Jones <pjones@redhat.com>
@@ -6183,7 +6183,7 @@ VIRTIO CONSOLE DRIVER
 M:	Amit Shah <amit.shah@redhat.com>
 L:	virtualization@lists.linux-foundation.org
 S:	Maintained
-F:	drivers/char/virtio_console.c
+F:	drivers/tty/hvc/virtio_console.c
 F:	include/linux/virtio_console.h
 
 VIRTIO HOST (VHOST)
diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index 52fa94d..3ce0219 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -432,108 +432,7 @@ config PPDEV
 
 	  If unsure, say N.
 
-config HVC_DRIVER
-	bool
-	help
-	  Generic "hypervisor virtual console" infrastructure for various
-	  hypervisors (pSeries, iSeries, Xen, lguest).
-	  It will automatically be selected if one of the back-end console drivers
-	  is selected.
-
-config HVC_IRQ
-	bool
-
-config HVC_CONSOLE
-	bool "pSeries Hypervisor Virtual Console support"
-	depends on PPC_PSERIES
-	select HVC_DRIVER
-	select HVC_IRQ
-	help
-	  pSeries machines when partitioned support a hypervisor virtual
-	  console. This driver allows each pSeries partition to have a console
-	  which is accessed via the HMC.
-
-config HVC_ISERIES
-	bool "iSeries Hypervisor Virtual Console support"
-	depends on PPC_ISERIES
-	default y
-	select HVC_DRIVER
-	select HVC_IRQ
-	select VIOPATH
-	help
-	  iSeries machines support a hypervisor virtual console.
-
-config HVC_RTAS
-	bool "IBM RTAS Console support"
-	depends on PPC_RTAS
-	select HVC_DRIVER
-	help
-	  IBM Console device driver which makes use of RTAS
-
-config HVC_BEAT
-	bool "Toshiba's Beat Hypervisor Console support"
-	depends on PPC_CELLEB
-	select HVC_DRIVER
-	help
-	  Toshiba's Cell Reference Set Beat Console device driver
-
-config HVC_IUCV
-	bool "z/VM IUCV Hypervisor console support (VM only)"
-	depends on S390
-	select HVC_DRIVER
-	select IUCV
-	default y
-	help
-	  This driver provides a Hypervisor console (HVC) back-end to access
-	  a Linux (console) terminal via a z/VM IUCV communication path.
-
-config HVC_XEN
-	bool "Xen Hypervisor Console support"
-	depends on XEN
-	select HVC_DRIVER
-	select HVC_IRQ
-	default y
-	help
-	  Xen virtual console device driver
-
-config HVC_UDBG
-       bool "udbg based fake hypervisor console"
-       depends on PPC && EXPERIMENTAL
-       select HVC_DRIVER
-       default n
-
-config VIRTIO_CONSOLE
-	tristate "Virtio console"
-	depends on VIRTIO
-	select HVC_DRIVER
-	help
-	  Virtio console for use with lguest and other hypervisors.
-
-	  Also serves as a general-purpose serial device for data
-	  transfer between the guest and host.  Character devices at
-	  /dev/vportNpn will be created when corresponding ports are
-	  found, where N is the device number and n is the port number
-	  within that device.  If specified by the host, a sysfs
-	  attribute called 'name' will be populated with a name for
-	  the port which can be used by udev scripts to create a
-	  symlink to the device.
-
-config HVCS
-	tristate "IBM Hypervisor Virtual Console Server support"
-	depends on PPC_PSERIES && HVC_CONSOLE
-	help
-	  Partitionable IBM Power5 ppc64 machines allow hosting of
-	  firmware virtual consoles from one Linux partition by
-	  another Linux partition.  This driver allows console data
-	  from Linux partitions to be accessed through TTY device
-	  interfaces in the device tree of a Linux partition running
-	  this driver.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called hvcs.  Additionally, this module
-	  will depend on arch specific APIs exported from hvcserver.ko
-	  which will also be compiled when this driver is built as a
-	  module.
+source "drivers/tty/hvc/Kconfig"
 
 config IBM_BSR
 	tristate "IBM POWER Barrier Synchronization Register support"
diff --git a/drivers/char/Makefile b/drivers/char/Makefile
index f507df7..d2fd481 100644
--- a/drivers/char/Makefile
+++ b/drivers/char/Makefile
@@ -30,24 +30,12 @@ obj-$(CONFIG_SYNCLINK_GT)	+= synclink_gt.o
 obj-$(CONFIG_AMIGA_BUILTIN_SERIAL) += amiserial.o
 obj-$(CONFIG_SX)		+= sx.o generic_serial.o
 obj-$(CONFIG_RIO)		+= rio/ generic_serial.o
-obj-$(CONFIG_HVC_CONSOLE)	+= hvc_vio.o hvsi.o
-obj-$(CONFIG_HVC_ISERIES)	+= hvc_iseries.o
-obj-$(CONFIG_HVC_RTAS)		+= hvc_rtas.o
-obj-$(CONFIG_HVC_TILE)		+= hvc_tile.o
-obj-$(CONFIG_HVC_BEAT)		+= hvc_beat.o
-obj-$(CONFIG_HVC_DRIVER)	+= hvc_console.o
-obj-$(CONFIG_HVC_IRQ)		+= hvc_irq.o
-obj-$(CONFIG_HVC_XEN)		+= hvc_xen.o
-obj-$(CONFIG_HVC_IUCV)		+= hvc_iucv.o
-obj-$(CONFIG_HVC_UDBG)		+= hvc_udbg.o
-obj-$(CONFIG_VIRTIO_CONSOLE)	+= virtio_console.o
 obj-$(CONFIG_RAW_DRIVER)	+= raw.o
 obj-$(CONFIG_SGI_SNSC)		+= snsc.o snsc_event.o
 obj-$(CONFIG_MSPEC)		+= mspec.o
 obj-$(CONFIG_MMTIMER)		+= mmtimer.o
 obj-$(CONFIG_UV_MMTIMER)	+= uv_mmtimer.o
 obj-$(CONFIG_VIOTAPE)		+= viotape.o
-obj-$(CONFIG_HVCS)		+= hvcs.o
 obj-$(CONFIG_IBM_BSR)		+= bsr.o
 obj-$(CONFIG_SGI_MBCS)		+= mbcs.o
 obj-$(CONFIG_BRIQ_PANEL)	+= briq_panel.o
diff --git a/drivers/tty/Makefile b/drivers/tty/Makefile
index 5845211..938cb73 100644
--- a/drivers/tty/Makefile
+++ b/drivers/tty/Makefile
@@ -17,6 +17,8 @@ obj-$(CONFIG_AUDIT)		+= tty_audit.o
 
 obj-$(CONFIG_MAGIC_SYSRQ)	+= sysrq.o
 
+obj-$(CONFIG_HVC_DRIVER)	+= hvc/
+
 obj-y				+= n_tty.o
 obj-$(CONFIG_N_HDLC)		+= n_hdlc.o
 obj-$(CONFIG_N_GSM)		+= n_gsm.o
diff --git a/drivers/tty/hvc/Kconfig b/drivers/tty/hvc/Kconfig
new file mode 100644
index 0000000..5341b5d
--- /dev/null
+++ b/drivers/tty/hvc/Kconfig
@@ -0,0 +1,104 @@
+config HVC_DRIVER
+	bool
+	help
+	  Generic "hypervisor virtual console" infrastructure for various
+	  hypervisors (pSeries, iSeries, Xen, lguest).
+	  It will automatically be selected if one of the back-end console drivers
+	  is selected.
+
+config HVC_IRQ
+	bool
+
+config HVC_CONSOLE
+	bool "pSeries Hypervisor Virtual Console support"
+	depends on PPC_PSERIES
+	select HVC_DRIVER
+	select HVC_IRQ
+	help
+	  pSeries machines when partitioned support a hypervisor virtual
+	  console. This driver allows each pSeries partition to have a console
+	  which is accessed via the HMC.
+
+config HVC_ISERIES
+	bool "iSeries Hypervisor Virtual Console support"
+	depends on PPC_ISERIES
+	default y
+	select HVC_DRIVER
+	select HVC_IRQ
+	select VIOPATH
+	help
+	  iSeries machines support a hypervisor virtual console.
+
+config HVC_RTAS
+	bool "IBM RTAS Console support"
+	depends on PPC_RTAS
+	select HVC_DRIVER
+	help
+	  IBM Console device driver which makes use of RTAS
+
+config HVC_BEAT
+	bool "Toshiba's Beat Hypervisor Console support"
+	depends on PPC_CELLEB
+	select HVC_DRIVER
+	help
+	  Toshiba's Cell Reference Set Beat Console device driver
+
+config HVC_IUCV
+	bool "z/VM IUCV Hypervisor console support (VM only)"
+	depends on S390
+	select HVC_DRIVER
+	select IUCV
+	default y
+	help
+	  This driver provides a Hypervisor console (HVC) back-end to access
+	  a Linux (console) terminal via a z/VM IUCV communication path.
+
+config HVC_XEN
+	bool "Xen Hypervisor Console support"
+	depends on XEN
+	select HVC_DRIVER
+	select HVC_IRQ
+	default y
+	help
+	  Xen virtual console device driver
+
+config HVC_UDBG
+       bool "udbg based fake hypervisor console"
+       depends on PPC && EXPERIMENTAL
+       select HVC_DRIVER
+       default n
+
+config VIRTIO_CONSOLE
+	tristate "Virtio console"
+	depends on VIRTIO
+	select HVC_DRIVER
+	help
+	  Virtio console for use with lguest and other hypervisors.
+
+	  Also serves as a general-purpose serial device for data
+	  transfer between the guest and host.  Character devices at
+	  /dev/vportNpn will be created when corresponding ports are
+	  found, where N is the device number and n is the port number
+	  within that device.  If specified by the host, a sysfs
+	  attribute called 'name' will be populated with a name for
+	  the port which can be used by udev scripts to create a
+	  symlink to the device.
+
+config HVCS
+	tristate "IBM Hypervisor Virtual Console Server support"
+	depends on PPC_PSERIES && HVC_CONSOLE
+	help
+	  Partitionable IBM Power5 ppc64 machines allow hosting of
+	  firmware virtual consoles from one Linux partition by
+	  another Linux partition.  This driver allows console data
+	  from Linux partitions to be accessed through TTY device
+	  interfaces in the device tree of a Linux partition running
+	  this driver.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called hvcs.  Additionally, this module
+	  will depend on arch specific APIs exported from hvcserver.ko
+	  which will also be compiled when this driver is built as a
+	  module.
+
+
diff --git a/drivers/tty/hvc/Makefile b/drivers/tty/hvc/Makefile
new file mode 100644
index 0000000..1e7b978
--- /dev/null
+++ b/drivers/tty/hvc/Makefile
@@ -0,0 +1,12 @@
+obj-$(CONFIG_HVC_CONSOLE)	+= hvc_vio.o hvsi.o
+obj-$(CONFIG_HVC_ISERIES)	+= hvc_iseries.o
+obj-$(CONFIG_HVC_RTAS)		+= hvc_rtas.o
+obj-$(CONFIG_HVC_TILE)		+= hvc_tile.o
+obj-$(CONFIG_HVC_BEAT)		+= hvc_beat.o
+obj-$(CONFIG_HVC_DRIVER)	+= hvc_console.o
+obj-$(CONFIG_HVC_IRQ)		+= hvc_irq.o
+obj-$(CONFIG_HVC_XEN)		+= hvc_xen.o
+obj-$(CONFIG_HVC_IUCV)		+= hvc_iucv.o
+obj-$(CONFIG_HVC_UDBG)		+= hvc_udbg.o
+obj-$(CONFIG_HVCS)		+= hvcs.o
+obj-$(CONFIG_VIRTIO_CONSOLE)	+= virtio_console.o
diff --git a/drivers/char/hvc_beat.c b/drivers/tty/hvc/hvc_beat.c
similarity index 100%
rename from drivers/char/hvc_beat.c
rename to drivers/tty/hvc/hvc_beat.c
diff --git a/drivers/char/hvc_console.c b/drivers/tty/hvc/hvc_console.c
similarity index 100%
rename from drivers/char/hvc_console.c
rename to drivers/tty/hvc/hvc_console.c
diff --git a/drivers/char/hvc_console.h b/drivers/tty/hvc/hvc_console.h
similarity index 100%
rename from drivers/char/hvc_console.h
rename to drivers/tty/hvc/hvc_console.h
diff --git a/drivers/char/hvc_irq.c b/drivers/tty/hvc/hvc_irq.c
similarity index 100%
rename from drivers/char/hvc_irq.c
rename to drivers/tty/hvc/hvc_irq.c
diff --git a/drivers/char/hvc_iseries.c b/drivers/tty/hvc/hvc_iseries.c
similarity index 100%
rename from drivers/char/hvc_iseries.c
rename to drivers/tty/hvc/hvc_iseries.c
diff --git a/drivers/char/hvc_iucv.c b/drivers/tty/hvc/hvc_iucv.c
similarity index 100%
rename from drivers/char/hvc_iucv.c
rename to drivers/tty/hvc/hvc_iucv.c
diff --git a/drivers/char/hvc_rtas.c b/drivers/tty/hvc/hvc_rtas.c
similarity index 100%
rename from drivers/char/hvc_rtas.c
rename to drivers/tty/hvc/hvc_rtas.c
diff --git a/drivers/char/hvc_tile.c b/drivers/tty/hvc/hvc_tile.c
similarity index 100%
rename from drivers/char/hvc_tile.c
rename to drivers/tty/hvc/hvc_tile.c
diff --git a/drivers/char/hvc_udbg.c b/drivers/tty/hvc/hvc_udbg.c
similarity index 100%
rename from drivers/char/hvc_udbg.c
rename to drivers/tty/hvc/hvc_udbg.c
diff --git a/drivers/char/hvc_vio.c b/drivers/tty/hvc/hvc_vio.c
similarity index 100%
rename from drivers/char/hvc_vio.c
rename to drivers/tty/hvc/hvc_vio.c
diff --git a/drivers/char/hvc_xen.c b/drivers/tty/hvc/hvc_xen.c
similarity index 100%
rename from drivers/char/hvc_xen.c
rename to drivers/tty/hvc/hvc_xen.c
diff --git a/drivers/char/hvcs.c b/drivers/tty/hvc/hvcs.c
similarity index 100%
rename from drivers/char/hvcs.c
rename to drivers/tty/hvc/hvcs.c
diff --git a/drivers/char/hvsi.c b/drivers/tty/hvc/hvsi.c
similarity index 100%
rename from drivers/char/hvsi.c
rename to drivers/tty/hvc/hvsi.c
diff --git a/drivers/char/virtio_console.c b/drivers/tty/hvc/virtio_console.c
similarity index 100%
rename from drivers/char/virtio_console.c
rename to drivers/tty/hvc/virtio_console.c
-- 
1.7.1

