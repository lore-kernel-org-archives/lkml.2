Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516Ab0FXNkW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 09:40:22 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47938 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755329Ab0FXNkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 09:40:20 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: Greg KH <greg@kroah.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
       Hebbar Shivananda <x0hebbar@ti.com>,
       Ramos Falcon Ernesto <ernesto@ti.com>, Anna Suman <s-anna@ti.com>,
       Kanigeri Hari <h-kanigeri2@ti.com>,
       Felipe Contreras <felipe.contreras@gmail.com>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       Hiroshi DOYU <Hiroshi.DOYU@nokia.com>, Gupta Ramesh <grgupta@ti.com>,
       Guzman Lugo Fernando <fernando.lugo@ti.com>,
       Tony Lindgren <tony@atomide.com>,
       Ameya Palande <ameya.palande@nokia.com>,
       Gomez Castellanos Ivan <ivan.gomez@ti.com>,
       Andy Shevchenko <ext-andriy.shevchenko@nokia.com>,
       Armando Uribe De Leon <x0095078@ti.com>,
       Deepak Chitriki <deepak.chitriki@ti.com>, Menon Nishanth <nm@ti.com>,
       Phil Carmody <ext-phil.2.carmody@nokia.com>,
       Pitney Gilbert <gpitney@ti.com>, Bhavin Shah <bshah@ti.com>,
       Omar Ramirez Luna <omar.ramirez@ti.com>,
       Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH 11/11] staging: ti dspbridge: enable driver building
Date: Thu, 24 Jun 2010 16:40:07 +0300
Message-Id: <1277386807-19595-1-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <20100623224150.GA6680@kroah.com>
References: <20100623224150.GA6680@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Omar Ramirez Luna <omar.ramirez@ti.com>

Add Kconfig + Makefile for TI's DSP Bridge driver
and expose it to the staging menu.

For now, have tidspbridge depend on ARCH_OMAP3.
That dependency should be relaxed as soon as required cleanups are applied.

Signed-off-by: Omar Ramirez Luna <omar.ramirez@ti.com>
Signed-off-by: Kanigeri, Hari <h-kanigeri2@ti.com>
Signed-off-by: Ameya Palande <ameya.palande@nokia.com>
Signed-off-by: Guzman Lugo, Fernando <fernando.lugo@ti.com>
Signed-off-by: Hebbar, Shivananda <x0hebbar@ti.com>
Signed-off-by: Ramos Falcon, Ernesto <ernesto@ti.com>
Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
Signed-off-by: Anna, Suman <s-anna@ti.com>
Signed-off-by: Gupta, Ramesh <grgupta@ti.com>
Signed-off-by: Gomez Castellanos, Ivan <ivan.gomez@ti.com>
Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Signed-off-by: Armando Uribe De Leon <x0095078@ti.com>
Signed-off-by: Deepak Chitriki <deepak.chitriki@ti.com>
Signed-off-by: Menon, Nishanth <nm@ti.com>
Signed-off-by: Phil Carmody <ext-phil.2.carmody@nokia.com>
Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
 drivers/staging/Kconfig              |    2 +
 drivers/staging/Makefile             |    1 +
 drivers/staging/tidspbridge/Kconfig  |   88 ++++++++++++++++++++++++++++++++++
 drivers/staging/tidspbridge/Makefile |   34 +++++++++++++
 4 files changed, 125 insertions(+), 0 deletions(-)
 create mode 100644 drivers/staging/tidspbridge/Kconfig
 create mode 100644 drivers/staging/tidspbridge/Makefile

diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
index cdd3ea3..ce1dfa8 100644
--- a/drivers/staging/Kconfig
+++ b/drivers/staging/Kconfig
@@ -151,5 +151,7 @@ source "drivers/staging/msm/Kconfig"
 
 source "drivers/staging/easycap/Kconfig"
 
+source "drivers/staging/tidspbridge/Kconfig"
+
 endif # !STAGING_EXCLUDE_BUILD
 endif # STAGING
diff --git a/drivers/staging/Makefile b/drivers/staging/Makefile
index beceaff..7849818 100644
--- a/drivers/staging/Makefile
+++ b/drivers/staging/Makefile
@@ -56,3 +56,4 @@ obj-$(CONFIG_FB_XGI)		+= xgifb/
 obj-$(CONFIG_TOUCHSCREEN_MRSTOUCH)	+= mrst-touchscreen/
 obj-$(CONFIG_MSM_STAGING)	+= msm/
 obj-$(CONFIG_EASYCAP)		+= easycap/
+obj-$(CONFIG_TIDSPBRIDGE)	+= tidspbridge/
diff --git a/drivers/staging/tidspbridge/Kconfig b/drivers/staging/tidspbridge/Kconfig
new file mode 100644
index 0000000..45372cd
--- /dev/null
+++ b/drivers/staging/tidspbridge/Kconfig
@@ -0,0 +1,88 @@
+#
+# DSP Bridge Driver Support
+#
+
+menuconfig TIDSPBRIDGE
+	tristate "DSP Bridge driver"
+	depends on ARCH_OMAP3
+	select OMAP_MBOX_FWK
+	help
+	  DSP/BIOS Bridge is designed for platforms that contain a GPP and
+	  one or more attached DSPs.  The GPP is considered the master or
+	  "host" processor, and the attached DSPs are processing resources
+	  that can be utilized by applications and drivers running on the GPP.
+
+	  This driver depends on OMAP Mailbox (OMAP_MBOX_FWK).
+
+config BRIDGE_DVFS
+	bool "Enable Bridge Dynamic Voltage and Frequency Scaling (DVFS)"
+	depends on TIDSPBRIDGE && OMAP_PM_SRF && CPU_FREQ
+	default n
+	help
+	  DVFS allows DSP Bridge to initiate the operating point change to
+	  scale the chip voltage and frequency in order to match the
+	  performance and power consumption to the current processing
+	  requirements.
+
+config BRIDGE_MEMPOOL_SIZE
+	hex "Physical memory pool size (Byte)"
+	depends on TIDSPBRIDGE
+	default 0x600000
+	help
+	  Allocate specified size of memory at booting time to avoid allocation
+	  failure under heavy memory fragmentation after some use time.
+
+config BRIDGE_DEBUG
+	bool "DSP Bridge Debug Support"
+	depends on TIDSPBRIDGE
+	help
+	  Say Y to enable Bridge debugging capabilities
+
+config BRIDGE_RECOVERY
+	bool "DSP Recovery Support"
+	depends on TIDSPBRIDGE
+	help
+	  In case of DSP fatal error, BRIDGE driver will try to
+	  recover itself.
+
+config BRIDGE_CACHE_LINE_CHECK
+	bool "Check buffers to be 128 byte aligned"
+	depends on TIDSPBRIDGE
+	default n
+	help
+	  When the DSP processes data, the DSP cache controller loads 128-Byte
+	  chunks (lines) from SDRAM and writes the data back in 128-Byte chunks.
+	  If a DMM buffer does not start and end on a 128-Byte boundary, the data
+	  preceding the start address (SA) from the 128-Byte boundary to the SA
+	  and the data at addresses trailing the end address (EA) from the EA to
+	  the next 128-Byte boundary will be loaded and written back as well.
+	  This can lead to heap corruption. Say Y, to enforce the check for 128
+	  byte alignment, buffers failing this check will be rejected.
+
+config BRIDGE_WDT3
+	bool "Enable WDT3 interruptions"
+	depends on TIDSPBRIDGE
+	default n
+	help
+	  WTD3 is managed by DSP and once it is enabled, DSP side bridge is in
+	  charge of refreshing the timer before overflow, if the DSP hangs MPU
+	  will caught the interrupt and try to recover DSP.
+
+config WDT_TIMEOUT
+	int "DSP watchdog timer timeout (in secs)"
+	depends on BRIDGE_WDT3
+	default 5
+	help
+	   Watchdog timer timeout value, after that time if the watchdog timer
+	   counter is not reset the wdt overflow interrupt will be triggered
+
+comment "Bridge Notifications"
+	depends on TIDSPBRIDGE
+
+config BRIDGE_NTFY_PWRERR
+	bool "Notify DSP Power Error"
+	depends on TIDSPBRIDGE
+	help
+	  Enable notifications to registered clients on the event of power errror
+	  trying to suspend bridge driver. Say Y, to signal this event as a fatal
+	  error, this will require a bridge restart to recover.
diff --git a/drivers/staging/tidspbridge/Makefile b/drivers/staging/tidspbridge/Makefile
new file mode 100644
index 0000000..6082ef0
--- /dev/null
+++ b/drivers/staging/tidspbridge/Makefile
@@ -0,0 +1,34 @@
+obj-$(CONFIG_TIDSPBRIDGE)	+= bridgedriver.o
+
+libgen = gen/gb.o gen/gs.o gen/gh.o gen/uuidutil.o
+libservices = services/sync.o services/cfg.o \
+		services/ntfy.o services/services.o
+libcore = core/chnl_sm.o core/msg_sm.o core/io_sm.o core/tiomap3430.o \
+		core/tiomap3430_pwr.o core/tiomap_io.o \
+		core/mmu_fault.o core/ue_deh.o core/wdt.o core/dsp-clock.o
+libpmgr = pmgr/chnl.o pmgr/io.o pmgr/msg.o pmgr/cod.o pmgr/dev.o pmgr/dspapi.o \
+		pmgr/dmm.o pmgr/cmm.o pmgr/dbll.o
+librmgr = rmgr/dbdcd.o rmgr/disp.o rmgr/drv.o rmgr/mgr.o rmgr/node.o \
+		rmgr/proc.o rmgr/pwr.o rmgr/rmm.o rmgr/strm.o rmgr/dspdrv.o \
+		rmgr/nldr.o rmgr/drv_interface.o
+libdload = dynload/cload.o dynload/getsection.o dynload/reloc.o \
+		 dynload/tramp.o
+libhw = hw/hw_mmu.o
+
+bridgedriver-objs = $(libgen) $(libservices) $(libcore) $(libpmgr) $(librmgr) \
+			$(libdload) $(libhw)
+
+#Machine dependent
+ccflags-y += -D_TI_ -D_DB_TIOMAP -DTMS32060 \
+		-DTICFG_PROC_VER -DTICFG_EVM_TYPE -DCHNL_SMCLASS \
+		-DCHNL_MESSAGES -DUSE_LEVEL_1_MACROS
+
+ccflags-y += -Idrivers/staging/tidspbridge/include
+ccflags-y += -Idrivers/staging/tidspbridge/services
+ccflags-y += -Idrivers/staging/tidspbridge/core
+ccflags-y += -Idrivers/staging/tidspbridge/pmgr
+ccflags-y += -Idrivers/staging/tidspbridge/rmgr
+ccflags-y += -Idrivers/staging/tidspbridge/dynload
+ccflags-y += -Idrivers/staging/tidspbridge/hw
+ccflags-y += -Iarch/arm
+
-- 
1.7.0.4

