Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753587Ab1EEVWN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 17:22:13 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:56268 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331Ab1EEVWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 17:22:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=YVOCGLHyYN8WukZSQOZOf6BX6x3GNwbk7XMEViPkWR19VvinbQ0VpNA9A7Uz/foF+D
         aiuPn3gZGIq0U9EkhSupoCdxog1/XlEbInIw21cbVsP5E3+XvGDeLVc0F+sT8Dt2jtAq
         MCkcsa0Z+Yv1xMaRZm4CN+nW5iBCwXaQwmBUw=
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
        Greg KH <greg@kroah.com>,
        =?UTF-8?q?Michael=20B=C3=BCsch?= <mb@bu3sch.de>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        George Kashperko <george@znau.edu.ua>,
        Arend van Spriel <arend@broadcom.com>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <rmk@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Andy Botting <andy@andybotting.com>,
        linuxdriverproject <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH][WAS:bcmai,axi] bcma: add Broadcom specific AMBA bus driver
Date: Thu,  5 May 2011 23:59:43 +0200
Message-Id: <1304632783-8781-1-git-send-email-zajec5@gmail.com>
X-Mailer: git-send-email 1.7.3.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Greg KH <greg@kroah.com>
Cc: Michael Büsch <mb@bu3sch.de>
Cc: Larry Finger <Larry.Finger@lwfinger.net>
Cc: George Kashperko <george@znau.edu.ua>
Cc: Arend van Spriel <arend@broadcom.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Andy Botting <andy@andybotting.com>
Cc: linuxdriverproject <devel@linuxdriverproject.org>
Cc: linux-kernel@vger.kernel.org <linux-kernel@vger.kernel.org>
Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
V2: Rename to axi
    Use DEFINE_PCI_DEVICE_TABLE in bridge
    Make use of pr_fmt and pr_*
    Store core class
    Rename bridge to not b43 specific
    Replace magic 0x1000 with BCMAI_CORE_SIZE
    Remove some old "ssb" names and defines
    Move BCMAI_ADDR_BASE def
    Add drvdata field
V3: Fix reloading (kfree issue)
    Add 14e4:0x4331
    Fix non-initialized struct issue
    Drop useless inline functions wrappers for pci core drv
    Proper pr_* usage
V3.1: Include forgotten changes (pr_* and include related)
    Explain why we dare to implement empty release function
V4: Add ABI documentation
    Move struct device to wrapper and alloc it dynamically
    checkpatch.pl pointed fixes
V5: Rename to bcma, AXI was really bad name
    Use EXPORT_SYMBOL_GPL
    Set pci driver fields in one place
    Drop unlikely
    Use BCMA_CORE_SIZE for calc in awrite32
    Add README
    Fix compilation (delay.h)
---
 Documentation/ABI/testing/sysfs-bus-bcma    |   31 ++
 drivers/Kconfig                             |    2 +
 drivers/Makefile                            |    1 +
 drivers/bcma/Kconfig                        |   33 +++
 drivers/bcma/Makefile                       |    7 +
 drivers/bcma/README                         |   18 ++
 drivers/bcma/TODO                           |    3 +
 drivers/bcma/bcma_private.h                 |   31 ++
 drivers/bcma/core.c                         |   51 ++++
 drivers/bcma/driver_chipcommon.c            |   87 ++++++
 drivers/bcma/driver_chipcommon_pmu.c        |  134 +++++++++
 drivers/bcma/driver_pci.c                   |  163 +++++++++++
 drivers/bcma/host_pci.c                     |  196 +++++++++++++
 drivers/bcma/main.c                         |  271 ++++++++++++++++++
 drivers/bcma/scan.c                         |  392 +++++++++++++++++++++++++++
 drivers/bcma/scan.h                         |   56 ++++
 include/linux/bcma/bcma.h                   |  232 ++++++++++++++++
 include/linux/bcma/bcma_driver_chipcommon.h |  297 ++++++++++++++++++++
 include/linux/bcma/bcma_driver_pci.h        |   89 ++++++
 include/linux/bcma/bcma_regs.h              |   34 +++
 include/linux/mod_devicetable.h             |   17 ++
 scripts/mod/file2alias.c                    |   22 ++
 22 files changed, 2167 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-bus-bcma
 create mode 100644 drivers/bcma/Kconfig
 create mode 100644 drivers/bcma/Makefile
 create mode 100644 drivers/bcma/README
 create mode 100644 drivers/bcma/TODO
 create mode 100644 drivers/bcma/bcma_private.h
 create mode 100644 drivers/bcma/core.c
 create mode 100644 drivers/bcma/driver_chipcommon.c
 create mode 100644 drivers/bcma/driver_chipcommon_pmu.c
 create mode 100644 drivers/bcma/driver_pci.c
 create mode 100644 drivers/bcma/host_pci.c
 create mode 100644 drivers/bcma/main.c
 create mode 100644 drivers/bcma/scan.c
 create mode 100644 drivers/bcma/scan.h
 create mode 100644 include/linux/bcma/bcma.h
 create mode 100644 include/linux/bcma/bcma_driver_chipcommon.h
 create mode 100644 include/linux/bcma/bcma_driver_pci.h
 create mode 100644 include/linux/bcma/bcma_regs.h

diff --git a/Documentation/ABI/testing/sysfs-bus-bcma b/Documentation/ABI/testing/sysfs-bus-bcma
new file mode 100644
index 0000000..ad3cd69
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-bus-bcma
@@ -0,0 +1,31 @@
+What:		/sys/bus/bcma/devices/.../class
+Date:		May 2011
+KernelVersion:	2.6.40
+Contact:	Rafał Miłecki <zajec5@gmail.com>
+Description:
+		Each AXI core is identified by few fields, including class it
+		belongs to. See include/linux/bcma/bcma.h for possible values.
+
+What:		/sys/bus/bcma/devices/.../manuf
+Date:		May 2011
+KernelVersion:	2.6.40
+Contact:	Rafał Miłecki <zajec5@gmail.com>
+Description:
+		Each AXI core has it's manufacturer id. See
+		include/linux/bcma/bcma.h for possible values.
+
+What:		/sys/bus/bcma/devices/.../rev
+Date:		May 2011
+KernelVersion:	2.6.40
+Contact:	Rafał Miłecki <zajec5@gmail.com>
+Description:
+		AXI cores of the same type can still slightly differ depending
+		on their revision. Use it for detailed programming.
+
+What:		/sys/bus/bcma/devices/.../id
+Date:		May 2011
+KernelVersion:	2.6.40
+Contact:	Rafał Miłecki <zajec5@gmail.com>
+Description:
+		There are a few types of AXI cores, they can be identified by
+		id field.
diff --git a/drivers/Kconfig b/drivers/Kconfig
index 177c7d1..aca7067 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -68,6 +68,8 @@ source "drivers/watchdog/Kconfig"
 
 source "drivers/ssb/Kconfig"
 
+source "drivers/bcma/Kconfig"
+
 source "drivers/mfd/Kconfig"
 
 source "drivers/regulator/Kconfig"
diff --git a/drivers/Makefile b/drivers/Makefile
index 3f135b6..a29527f 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -110,6 +110,7 @@ obj-$(CONFIG_HID)		+= hid/
 obj-$(CONFIG_PPC_PS3)		+= ps3/
 obj-$(CONFIG_OF)		+= of/
 obj-$(CONFIG_SSB)		+= ssb/
+obj-$(CONFIG_BCMA)		+= bcma/
 obj-$(CONFIG_VHOST_NET)		+= vhost/
 obj-$(CONFIG_VLYNQ)		+= vlynq/
 obj-$(CONFIG_STAGING)		+= staging/
diff --git a/drivers/bcma/Kconfig b/drivers/bcma/Kconfig
new file mode 100644
index 0000000..353781b
--- /dev/null
+++ b/drivers/bcma/Kconfig
@@ -0,0 +1,33 @@
+config BCMA_POSSIBLE
+	bool
+	depends on HAS_IOMEM && HAS_DMA
+	default y
+
+menu "Broadcom specific AMBA"
+	depends on BCMA_POSSIBLE
+
+config BCMA
+	tristate "BCMA support"
+	depends on BCMA_POSSIBLE
+	help
+	  Bus driver for Broadcom specific Advanced Microcontroller Bus
+	  Architecture.
+
+config BCMA_HOST_PCI_POSSIBLE
+	bool
+	depends on BCMA && PCI = y
+	default y
+
+config BCMA_HOST_PCI
+	bool "Support for BCMA on PCI-host bus"
+	depends on BCMA_HOST_PCI_POSSIBLE
+
+config BCMA_DEBUG
+	bool "BCMA debugging"
+	depends on BCMA
+	help
+	  This turns on additional debugging messages.
+
+	  If unsure, say N
+
+endmenu
diff --git a/drivers/bcma/Makefile b/drivers/bcma/Makefile
new file mode 100644
index 0000000..0d56245
--- /dev/null
+++ b/drivers/bcma/Makefile
@@ -0,0 +1,7 @@
+bcma-y					+= main.o scan.o core.o
+bcma-y					+= driver_chipcommon.o driver_chipcommon_pmu.o
+bcma-y					+= driver_pci.o
+bcma-$(CONFIG_BCMA_HOST_PCI)		+= host_pci.o
+obj-$(CONFIG_BCMA)			+= bcma.o
+
+ccflags-$(CONFIG_BCMA_DEBUG)		:= -DDEBUG
diff --git a/drivers/bcma/README b/drivers/bcma/README
new file mode 100644
index 0000000..b52cd2b
--- /dev/null
+++ b/drivers/bcma/README
@@ -0,0 +1,18 @@
+Broadcom introduced new bus as replacement for older SSB. It is based on AMBA,
+however from programming point of view there is nothing AMBA specific we use.
+
+Standard AMBA drivers are platform specific, have hardcoded addresses and use
+AMBA standard fields like CID and PID.
+
+In case of Broadcom's cards every device consists of:
+1) Broadcom specific AMBA device. It is put on AMBA bus, but can not be treated
+   as standard AMBA device. Reading it's CID or PID can cause machine lockup.
+2) AMBA standard devices called ports or wrappers. They have CIDs (AMBA_CID)
+   and PIDs (0x103BB369), but we do not use that info for anything. One of that
+   devices is used for managing Broadcom specific core.
+
+Addresses of AMBA devices are not hardcoded in driver and have to be read from
+EPROM.
+
+In this situation we decided to introduce separated bus with devices identified
+by Broadcom specific fields, read from EPROM.
diff --git a/drivers/bcma/TODO b/drivers/bcma/TODO
new file mode 100644
index 0000000..45eadc9
--- /dev/null
+++ b/drivers/bcma/TODO
@@ -0,0 +1,3 @@
+- Interrupts
+- Defines for PCI core driver
+- Convert bcma_bus->cores into linked list
diff --git a/drivers/bcma/bcma_private.h b/drivers/bcma/bcma_private.h
new file mode 100644
index 0000000..2a55f3e
--- /dev/null
+++ b/drivers/bcma/bcma_private.h
@@ -0,0 +1,31 @@
+#ifndef LINUX_BCMA_PRIVATE_H_
+#define LINUX_BCMA_PRIVATE_H_
+
+#ifndef pr_fmt
+#define pr_fmt(fmt)		KBUILD_MODNAME ": " fmt
+#endif
+
+#include <linux/bcma/bcma.h>
+#include <linux/delay.h>
+
+#define BCMA_ADDR_BASE		0x18000000
+#define BCMA_WRAP_BASE		0x18100000
+
+#define BCMA_CORE_SIZE		0x1000
+
+struct bcma_bus;
+
+/* main.c */
+extern int bcma_bus_register(struct bcma_bus *bus);
+extern void bcma_bus_unregister(struct bcma_bus *bus);
+
+/* scan.c */
+int bcma_bus_scan(struct bcma_bus *bus);
+
+#ifdef CONFIG_BCMA_HOST_PCI
+/* host_pci.c */
+extern int __init bcma_host_pci_init(void);
+extern void __exit bcma_host_pci_exit(void);
+#endif /* CONFIG_BCMA_HOST_PCI */
+
+#endif
diff --git a/drivers/bcma/core.c b/drivers/bcma/core.c
new file mode 100644
index 0000000..ced379f
--- /dev/null
+++ b/drivers/bcma/core.c
@@ -0,0 +1,51 @@
+/*
+ * Broadcom specific AMBA
+ * Core ops
+ *
+ * Licensed under the GNU/GPL. See COPYING for details.
+ */
+
+#include "bcma_private.h"
+#include <linux/bcma/bcma.h>
+
+bool bcma_core_is_enabled(struct bcma_device *core)
+{
+	if ((bcma_aread32(core, BCMA_IOCTL) & (BCMA_IOCTL_CLK | BCMA_IOCTL_FGC))
+	    != BCMA_IOCTL_CLK)
+		return false;
+	if (bcma_aread32(core, BCMA_RESET_CTL) & BCMA_RESET_CTL_RESET)
+		return false;
+	return true;
+}
+EXPORT_SYMBOL_GPL(bcma_core_is_enabled);
+
+static void bcma_core_disable(struct bcma_device *core, u32 flags)
+{
+	if (bcma_aread32(core, BCMA_RESET_CTL) & BCMA_RESET_CTL_RESET)
+		return;
+
+	bcma_awrite32(core, BCMA_IOCTL, flags);
+	bcma_aread32(core, BCMA_IOCTL);
+	udelay(10);
+
+	bcma_awrite32(core, BCMA_RESET_CTL, BCMA_RESET_CTL_RESET);
+	udelay(1);
+}
+
+int bcma_core_enable(struct bcma_device *core, u32 flags)
+{
+	bcma_core_disable(core, flags);
+
+	bcma_awrite32(core, BCMA_IOCTL, (BCMA_IOCTL_CLK | BCMA_IOCTL_FGC | flags));
+	bcma_aread32(core, BCMA_IOCTL);
+
+	bcma_awrite32(core, BCMA_RESET_CTL, 0);
+	udelay(1);
+
+	bcma_awrite32(core, BCMA_IOCTL, (BCMA_IOCTL_CLK | flags));
+	bcma_aread32(core, BCMA_IOCTL);
+	udelay(1);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(bcma_core_enable);
diff --git a/drivers/bcma/driver_chipcommon.c b/drivers/bcma/driver_chipcommon.c
new file mode 100644
index 0000000..caf5960
--- /dev/null
+++ b/drivers/bcma/driver_chipcommon.c
@@ -0,0 +1,87 @@
+/*
+ * Broadcom specific AMBA
+ * ChipCommon core driver
+ *
+ * Copyright 2005, Broadcom Corporation
+ * Copyright 2006, 2007, Michael Buesch <mb@bu3sch.de>
+ *
+ * Licensed under the GNU/GPL. See COPYING for details.
+ */
+
+#include "bcma_private.h"
+#include <linux/bcma/bcma.h>
+
+static inline u32 bcma_cc_write32_masked(struct bcma_drv_cc *cc, u16 offset,
+					 u32 mask, u32 value)
+{
+	value &= mask;
+	value |= bcma_cc_read32(cc, offset) & ~mask;
+	bcma_cc_write32(cc, offset, value);
+
+	return value;
+}
+
+void bcma_core_chipcommon_init(struct bcma_drv_cc *cc)
+{
+	if (cc->core->id.rev >= 11)
+		cc->status = bcma_cc_read32(cc, BCMA_CC_CHIPSTAT);
+	cc->capabilities = bcma_cc_read32(cc, BCMA_CC_CAP);
+	if (cc->core->id.rev >= 35)
+		cc->capabilities_ext = bcma_cc_read32(cc, BCMA_CC_CAP_EXT);
+
+	bcma_cc_write32(cc, 0x58, 0);
+	bcma_cc_write32(cc, 0x5C, 0);
+
+	if (cc->capabilities & BCMA_CC_CAP_PMU)
+		bcma_pmu_init(cc);
+	if (cc->capabilities & BCMA_CC_CAP_PCTL)
+		pr_err("Power control not implemented!\n");
+}
+
+/* Set chip watchdog reset timer to fire in 'ticks' backplane cycles */
+void bcma_chipco_watchdog_timer_set(struct bcma_drv_cc *cc, u32 ticks)
+{
+	/* instant NMI */
+	bcma_cc_write32(cc, BCMA_CC_WATCHDOG, ticks);
+}
+
+void bcma_chipco_irq_mask(struct bcma_drv_cc *cc, u32 mask, u32 value)
+{
+	bcma_cc_write32_masked(cc, BCMA_CC_IRQMASK, mask, value);
+}
+
+u32 bcma_chipco_irq_status(struct bcma_drv_cc *cc, u32 mask)
+{
+	return bcma_cc_read32(cc, BCMA_CC_IRQSTAT) & mask;
+}
+
+u32 bcma_chipco_gpio_in(struct bcma_drv_cc *cc, u32 mask)
+{
+	return bcma_cc_read32(cc, BCMA_CC_GPIOIN) & mask;
+}
+
+u32 bcma_chipco_gpio_out(struct bcma_drv_cc *cc, u32 mask, u32 value)
+{
+	return bcma_cc_write32_masked(cc, BCMA_CC_GPIOOUT, mask, value);
+}
+
+u32 bcma_chipco_gpio_outen(struct bcma_drv_cc *cc, u32 mask, u32 value)
+{
+	return bcma_cc_write32_masked(cc, BCMA_CC_GPIOOUTEN, mask, value);
+}
+
+u32 bcma_chipco_gpio_control(struct bcma_drv_cc *cc, u32 mask, u32 value)
+{
+	return bcma_cc_write32_masked(cc, BCMA_CC_GPIOCTL, mask, value);
+}
+EXPORT_SYMBOL_GPL(bcma_chipco_gpio_control);
+
+u32 bcma_chipco_gpio_intmask(struct bcma_drv_cc *cc, u32 mask, u32 value)
+{
+	return bcma_cc_write32_masked(cc, BCMA_CC_GPIOIRQ, mask, value);
+}
+
+u32 bcma_chipco_gpio_polarity(struct bcma_drv_cc *cc, u32 mask, u32 value)
+{
+	return bcma_cc_write32_masked(cc, BCMA_CC_GPIOPOL, mask, value);
+}
diff --git a/drivers/bcma/driver_chipcommon_pmu.c b/drivers/bcma/driver_chipcommon_pmu.c
new file mode 100644
index 0000000..f44177a
--- /dev/null
+++ b/drivers/bcma/driver_chipcommon_pmu.c
@@ -0,0 +1,134 @@
+/*
+ * Broadcom specific AMBA
+ * ChipCommon Power Management Unit driver
+ *
+ * Copyright 2009, Michael Buesch <mb@bu3sch.de>
+ * Copyright 2007, Broadcom Corporation
+ *
+ * Licensed under the GNU/GPL. See COPYING for details.
+ */
+
+#include "bcma_private.h"
+#include <linux/bcma/bcma.h>
+
+static void bcma_chipco_chipctl_maskset(struct bcma_drv_cc *cc,
+					u32 offset, u32 mask, u32 set)
+{
+	u32 value;
+
+	bcma_cc_read32(cc, BCMA_CC_CHIPCTL_ADDR);
+	bcma_cc_write32(cc, BCMA_CC_CHIPCTL_ADDR, offset);
+	bcma_cc_read32(cc, BCMA_CC_CHIPCTL_ADDR);
+	value = bcma_cc_read32(cc, BCMA_CC_CHIPCTL_DATA);
+	value &= mask;
+	value |= set;
+	bcma_cc_write32(cc, BCMA_CC_CHIPCTL_DATA, value);
+	bcma_cc_read32(cc, BCMA_CC_CHIPCTL_DATA);
+}
+
+static void bcma_pmu_pll_init(struct bcma_drv_cc *cc)
+{
+	struct bcma_bus *bus = cc->core->bus;
+
+	switch (bus->chipinfo.id) {
+	case 0x4313:
+	case 0x4331:
+	case 43224:
+	case 43225:
+		break;
+	default:
+		pr_err("PLL init unknown for device 0x%04X\n",
+			bus->chipinfo.id);
+	}
+}
+
+static void bcma_pmu_resources_init(struct bcma_drv_cc *cc)
+{
+	struct bcma_bus *bus = cc->core->bus;
+	u32 min_msk = 0, max_msk = 0;
+
+	switch (bus->chipinfo.id) {
+	case 0x4313:
+		min_msk = 0x200D;
+		max_msk = 0xFFFF;
+		break;
+	case 43224:
+		break;
+	default:
+		pr_err("PMU resource config unknown for device 0x%04X\n",
+			bus->chipinfo.id);
+	}
+
+	/* Set the resource masks. */
+	if (min_msk)
+		bcma_cc_write32(cc, BCMA_CC_PMU_MINRES_MSK, min_msk);
+	if (max_msk)
+		bcma_cc_write32(cc, BCMA_CC_PMU_MAXRES_MSK, max_msk);
+}
+
+void bcma_pmu_swreg_init(struct bcma_drv_cc *cc)
+{
+	struct bcma_bus *bus = cc->core->bus;
+
+	switch (bus->chipinfo.id) {
+	case 0x4313:
+	case 0x4331:
+	case 43224:
+		break;
+	default:
+		pr_err("PMU switch/regulators init unknown for device "
+			"0x%04X\n", bus->chipinfo.id);
+	}
+}
+
+void bcma_pmu_workarounds(struct bcma_drv_cc *cc)
+{
+	struct bcma_bus *bus = cc->core->bus;
+
+	switch (bus->chipinfo.id) {
+	case 0x4313:
+		bcma_chipco_chipctl_maskset(cc, 0, ~0, 0x7);
+		break;
+	case 0x4331:
+		pr_err("Enabling Ext PA lines not implemented\n");
+		break;
+	case 43224:
+		if (bus->chipinfo.rev == 0) {
+			pr_err("Workarounds for 43224 rev 0 not fully "
+				"implemented\n");
+			bcma_chipco_chipctl_maskset(cc, 0, ~0, 0xF0);
+		} else {
+			bcma_chipco_chipctl_maskset(cc, 0, ~0, 0xF0);
+		}
+		break;
+	default:
+		pr_err("Workarounds unknown for device 0x%04X\n",
+			bus->chipinfo.id);
+	}
+}
+
+void bcma_pmu_init(struct bcma_drv_cc *cc)
+{
+	u32 pmucap;
+
+	pmucap = bcma_cc_read32(cc, BCMA_CC_PMU_CAP);
+	cc->pmu.rev = (pmucap & BCMA_CC_PMU_CAP_REVISION);
+
+	pr_debug("Found rev %u PMU (capabilities 0x%08X)\n", cc->pmu.rev,
+		 pmucap);
+
+	if (cc->pmu.rev == 1)
+		bcma_cc_mask32(cc, BCMA_CC_PMU_CTL,
+			      ~BCMA_CC_PMU_CTL_NOILPONW);
+	else
+		bcma_cc_set32(cc, BCMA_CC_PMU_CTL,
+			     BCMA_CC_PMU_CTL_NOILPONW);
+
+	if (cc->core->id.id == 0x4329 && cc->core->id.rev == 2)
+		pr_err("Fix for 4329b0 bad LPOM state not implemented!\n");
+
+	bcma_pmu_pll_init(cc);
+	bcma_pmu_resources_init(cc);
+	bcma_pmu_swreg_init(cc);
+	bcma_pmu_workarounds(cc);
+}
diff --git a/drivers/bcma/driver_pci.c b/drivers/bcma/driver_pci.c
new file mode 100644
index 0000000..b98b835
--- /dev/null
+++ b/drivers/bcma/driver_pci.c
@@ -0,0 +1,163 @@
+/*
+ * Broadcom specific AMBA
+ * PCI Core
+ *
+ * Copyright 2005, Broadcom Corporation
+ * Copyright 2006, 2007, Michael Buesch <mb@bu3sch.de>
+ *
+ * Licensed under the GNU/GPL. See COPYING for details.
+ */
+
+#include "bcma_private.h"
+#include <linux/bcma/bcma.h>
+
+/**************************************************
+ * R/W ops.
+ **************************************************/
+
+static u32 bcma_pcie_read(struct bcma_drv_pci *pc, u32 address)
+{
+	pcicore_write32(pc, 0x130, address);
+	pcicore_read32(pc, 0x130);
+	return pcicore_read32(pc, 0x134);
+}
+
+#if 0
+static void bcma_pcie_write(struct bcma_drv_pci *pc, u32 address, u32 data)
+{
+	pcicore_write32(pc, 0x130, address);
+	pcicore_read32(pc, 0x130);
+	pcicore_write32(pc, 0x134, data);
+}
+#endif
+
+static void bcma_pcie_mdio_set_phy(struct bcma_drv_pci *pc, u8 phy)
+{
+	const u16 mdio_control = 0x128;
+	const u16 mdio_data = 0x12C;
+	u32 v;
+	int i;
+
+	v = (1 << 30); /* Start of Transaction */
+	v |= (1 << 28); /* Write Transaction */
+	v |= (1 << 17); /* Turnaround */
+	v |= (0x1F << 18);
+	v |= (phy << 4);
+	pcicore_write32(pc, mdio_data, v);
+
+	udelay(10);
+	for (i = 0; i < 200; i++) {
+		v = pcicore_read32(pc, mdio_control);
+		if (v & 0x100 /* Trans complete */)
+			break;
+		msleep(1);
+	}
+}
+
+static u16 bcma_pcie_mdio_read(struct bcma_drv_pci *pc, u8 device, u8 address)
+{
+	const u16 mdio_control = 0x128;
+	const u16 mdio_data = 0x12C;
+	int max_retries = 10;
+	u16 ret = 0;
+	u32 v;
+	int i;
+
+	v = 0x80; /* Enable Preamble Sequence */
+	v |= 0x2; /* MDIO Clock Divisor */
+	pcicore_write32(pc, mdio_control, v);
+
+	if (pc->core->id.rev >= 10) {
+		max_retries = 200;
+		bcma_pcie_mdio_set_phy(pc, device);
+	}
+
+	v = (1 << 30); /* Start of Transaction */
+	v |= (1 << 29); /* Read Transaction */
+	v |= (1 << 17); /* Turnaround */
+	if (pc->core->id.rev < 10)
+		v |= (u32)device << 22;
+	v |= (u32)address << 18;
+	pcicore_write32(pc, mdio_data, v);
+	/* Wait for the device to complete the transaction */
+	udelay(10);
+	for (i = 0; i < 200; i++) {
+		v = pcicore_read32(pc, mdio_control);
+		if (v & 0x100 /* Trans complete */) {
+			udelay(10);
+			ret = pcicore_read32(pc, mdio_data);
+			break;
+		}
+		msleep(1);
+	}
+	pcicore_write32(pc, mdio_control, 0);
+	return ret;
+}
+
+static void bcma_pcie_mdio_write(struct bcma_drv_pci *pc, u8 device,
+				u8 address, u16 data)
+{
+	const u16 mdio_control = 0x128;
+	const u16 mdio_data = 0x12C;
+	int max_retries = 10;
+	u32 v;
+	int i;
+
+	v = 0x80; /* Enable Preamble Sequence */
+	v |= 0x2; /* MDIO Clock Divisor */
+	pcicore_write32(pc, mdio_control, v);
+
+	if (pc->core->id.rev >= 10) {
+		max_retries = 200;
+		bcma_pcie_mdio_set_phy(pc, device);
+	}
+
+	v = (1 << 30); /* Start of Transaction */
+	v |= (1 << 28); /* Write Transaction */
+	v |= (1 << 17); /* Turnaround */
+	if (pc->core->id.rev < 10)
+		v |= (u32)device << 22;
+	v |= (u32)address << 18;
+	v |= data;
+	pcicore_write32(pc, mdio_data, v);
+	/* Wait for the device to complete the transaction */
+	udelay(10);
+	for (i = 0; i < max_retries; i++) {
+		v = pcicore_read32(pc, mdio_control);
+		if (v & 0x100 /* Trans complete */)
+			break;
+		msleep(1);
+	}
+	pcicore_write32(pc, mdio_control, 0);
+}
+
+/**************************************************
+ * Workarounds.
+ **************************************************/
+
+static u8 bcma_pcicore_polarity_workaround(struct bcma_drv_pci *pc)
+{
+	return (bcma_pcie_read(pc, 0x204) & 0x10) ? 0xC0 : 0x80;
+}
+
+static void bcma_pcicore_serdes_workaround(struct bcma_drv_pci *pc)
+{
+	const u8 serdes_pll_device = 0x1D;
+	const u8 serdes_rx_device = 0x1F;
+	u16 tmp;
+
+	bcma_pcie_mdio_write(pc, serdes_rx_device, 1 /* Control */,
+			      bcma_pcicore_polarity_workaround(pc));
+	tmp = bcma_pcie_mdio_read(pc, serdes_pll_device, 1 /* Control */);
+	if (tmp & 0x4000)
+		bcma_pcie_mdio_write(pc, serdes_pll_device, 1, tmp & ~0x4000);
+}
+
+/**************************************************
+ * Init.
+ **************************************************/
+
+void bcma_core_pci_init(struct bcma_drv_pci *pc)
+{
+	bcma_pcicore_serdes_workaround(pc);
+}
diff --git a/drivers/bcma/host_pci.c b/drivers/bcma/host_pci.c
new file mode 100644
index 0000000..99dd36e
--- /dev/null
+++ b/drivers/bcma/host_pci.c
@@ -0,0 +1,196 @@
+/*
+ * Broadcom specific AMBA
+ * PCI Host
+ *
+ * Licensed under the GNU/GPL. See COPYING for details.
+ */
+
+#include "bcma_private.h"
+#include <linux/bcma/bcma.h>
+#include <linux/pci.h>
+
+static void bcma_host_pci_switch_core(struct bcma_device *core)
+{
+	pci_write_config_dword(core->bus->host_pci, BCMA_PCI_BAR0_WIN,
+			       core->addr);
+	pci_write_config_dword(core->bus->host_pci, BCMA_PCI_BAR0_WIN2,
+			       core->wrap);
+	core->bus->mapped_core = core;
+	pr_debug("Switched to core: 0x%X\n", core->id.id);
+}
+
+static u8 bcma_host_pci_read8(struct bcma_device *core, u16 offset)
+{
+	if (core->bus->mapped_core != core)
+		bcma_host_pci_switch_core(core);
+	return ioread8(core->bus->mmio + offset);
+}
+
+static u16 bcma_host_pci_read16(struct bcma_device *core, u16 offset)
+{
+	if (core->bus->mapped_core != core)
+		bcma_host_pci_switch_core(core);
+	return ioread16(core->bus->mmio + offset);
+}
+
+static u32 bcma_host_pci_read32(struct bcma_device *core, u16 offset)
+{
+	if (core->bus->mapped_core != core)
+		bcma_host_pci_switch_core(core);
+	return ioread32(core->bus->mmio + offset);
+}
+
+static void bcma_host_pci_write8(struct bcma_device *core, u16 offset,
+				 u8 value)
+{
+	if (core->bus->mapped_core != core)
+		bcma_host_pci_switch_core(core);
+	iowrite8(value, core->bus->mmio + offset);
+}
+
+static void bcma_host_pci_write16(struct bcma_device *core, u16 offset,
+				 u16 value)
+{
+	if (core->bus->mapped_core != core)
+		bcma_host_pci_switch_core(core);
+	iowrite16(value, core->bus->mmio + offset);
+}
+
+static void bcma_host_pci_write32(struct bcma_device *core, u16 offset,
+				 u32 value)
+{
+	if (core->bus->mapped_core != core)
+		bcma_host_pci_switch_core(core);
+	iowrite32(value, core->bus->mmio + offset);
+}
+
+static u32 bcma_host_pci_aread32(struct bcma_device *core, u16 offset)
+{
+	if (core->bus->mapped_core != core)
+		bcma_host_pci_switch_core(core);
+	return ioread32(core->bus->mmio + (1 * BCMA_CORE_SIZE) + offset);
+}
+
+static void bcma_host_pci_awrite32(struct bcma_device *core, u16 offset,
+				  u32 value)
+{
+	if (core->bus->mapped_core != core)
+		bcma_host_pci_switch_core(core);
+	iowrite32(value, core->bus->mmio + (1 * BCMA_CORE_SIZE) + offset);
+}
+
+const struct bcma_host_ops bcma_host_pci_ops = {
+	.read8		= bcma_host_pci_read8,
+	.read16		= bcma_host_pci_read16,
+	.read32		= bcma_host_pci_read32,
+	.write8		= bcma_host_pci_write8,
+	.write16	= bcma_host_pci_write16,
+	.write32	= bcma_host_pci_write32,
+	.aread32	= bcma_host_pci_aread32,
+	.awrite32	= bcma_host_pci_awrite32,
+};
+
+static int bcma_host_pci_probe(struct pci_dev *dev,
+			     const struct pci_device_id *id)
+{
+	struct bcma_bus *bus;
+	int err = -ENOMEM;
+	const char *name;
+	u32 val;
+
+	/* Alloc */
+	bus = kzalloc(sizeof(*bus), GFP_KERNEL);
+	if (!bus)
+		goto out;
+
+	/* Basic PCI configuration */
+	err = pci_enable_device(dev);
+	if (err)
+		goto err_kfree_bus;
+
+	name = dev_name(&dev->dev);
+	if (dev->driver && dev->driver->name)
+		name = dev->driver->name;
+	err = pci_request_regions(dev, name);
+	if (err)
+		goto err_pci_disable;
+	pci_set_master(dev);
+
+	/* Disable the RETRY_TIMEOUT register (0x41) to keep
+	 * PCI Tx retries from interfering with C3 CPU state */
+	pci_read_config_dword(dev, 0x40, &val);
+	if ((val & 0x0000ff00) != 0)
+		pci_write_config_dword(dev, 0x40, val & 0xffff00ff);
+
+	/* SSB needed additional powering up, do we have any AMBA PCI cards? */
+	if (!pci_is_pcie(dev))
+		pr_err("PCI card detected, report problems.\n");
+
+	/* Map MMIO */
+	err = -ENOMEM;
+	bus->mmio = pci_iomap(dev, 0, ~0UL);
+	if (!bus->mmio)
+		goto err_pci_release_regions;
+
+	/* Host specific */
+	bus->host_pci = dev;
+	bus->hosttype = BCMA_HOSTTYPE_PCI;
+	bus->ops = &bcma_host_pci_ops;
+
+	/* Register */
+	err = bcma_bus_register(bus);
+	if (err)
+		goto err_pci_unmap_mmio;
+
+	pci_set_drvdata(dev, bus);
+
+out:
+	return err;
+
+err_pci_unmap_mmio:
+	pci_iounmap(dev, bus->mmio);
+err_pci_release_regions:
+	pci_release_regions(dev);
+err_pci_disable:
+	pci_disable_device(dev);
+err_kfree_bus:
+	kfree(bus);
+	return err;
+}
+
+static void bcma_host_pci_remove(struct pci_dev *dev)
+{
+	struct bcma_bus *bus = pci_get_drvdata(dev);
+
+	bcma_bus_unregister(bus);
+	pci_iounmap(dev, bus->mmio);
+	pci_release_regions(dev);
+	pci_disable_device(dev);
+	kfree(bus);
+	pci_set_drvdata(dev, NULL);
+}
+
+static DEFINE_PCI_DEVICE_TABLE(bcma_pci_bridge_tbl) = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4331) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4353) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4727) },
+	{ 0, },
+};
+MODULE_DEVICE_TABLE(pci, bcma_pci_bridge_tbl);
+
+static struct pci_driver bcma_pci_bridge_driver = {
+	.name = "bcma-pci-bridge",
+	.id_table = bcma_pci_bridge_tbl,
+	.probe = bcma_host_pci_probe,
+	.remove = bcma_host_pci_remove,
+};
+
+int __init bcma_host_pci_init(void)
+{
+	return pci_register_driver(&bcma_pci_bridge_driver);
+}
+
+void __exit bcma_host_pci_exit(void)
+{
+	pci_unregister_driver(&bcma_pci_bridge_driver);
+}
diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
new file mode 100644
index 0000000..a46c0fd
--- /dev/null
+++ b/drivers/bcma/main.c
@@ -0,0 +1,271 @@
+/*
+ * Broadcom specific AMBA
+ * Bus subsystem
+ *
+ * Licensed under the GNU/GPL. See COPYING for details.
+ */
+
+#include "bcma_private.h"
+#include <linux/bcma/bcma.h>
+
+MODULE_DESCRIPTION("Broadcom's specific AMBA driver");
+MODULE_LICENSE("GPL");
+
+static int bcma_bus_match(struct device *dev, struct device_driver *drv);
+static int bcma_device_probe(struct device *dev);
+static int bcma_device_remove(struct device *dev);
+
+static ssize_t manuf_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct __bcma_dev_wrapper *wrapper = container_of(dev,
+						struct __bcma_dev_wrapper, dev);
+	return sprintf(buf, "0x%03X\n", wrapper->core->id.manuf);
+}
+static ssize_t id_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct __bcma_dev_wrapper *wrapper = container_of(dev,
+						struct __bcma_dev_wrapper, dev);
+	return sprintf(buf, "0x%03X\n", wrapper->core->id.id);
+}
+static ssize_t rev_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct __bcma_dev_wrapper *wrapper = container_of(dev,
+						struct __bcma_dev_wrapper, dev);
+	return sprintf(buf, "0x%02X\n", wrapper->core->id.rev);
+}
+static ssize_t class_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct __bcma_dev_wrapper *wrapper = container_of(dev,
+						struct __bcma_dev_wrapper, dev);
+	return sprintf(buf, "0x%X\n", wrapper->core->id.class);
+}
+static struct device_attribute bcma_device_attrs[] = {
+	__ATTR_RO(manuf),
+	__ATTR_RO(id),
+	__ATTR_RO(rev),
+	__ATTR_RO(class),
+	__ATTR_NULL,
+};
+
+static struct bus_type bcma_bus_type = {
+	.name		= "bcma",
+	.match		= bcma_bus_match,
+	.probe		= bcma_device_probe,
+	.remove		= bcma_device_remove,
+	.dev_attrs	= bcma_device_attrs,
+};
+
+static struct bcma_device *bcma_find_core(struct bcma_bus *bus, u16 coreid)
+{
+	u8 i;
+	for (i = 0; i < bus->nr_cores; i++) {
+		if (bus->cores[i].id.id == coreid)
+			return &bus->cores[i];
+	}
+	return NULL;
+}
+
+static void bcma_release_core_dev(struct device *dev)
+{
+	struct __bcma_dev_wrapper *wrapper = container_of(dev,
+						struct __bcma_dev_wrapper, dev);
+	kfree(wrapper);
+}
+
+static int bcma_register_cores(struct bcma_bus *bus)
+{
+	struct bcma_device *core;
+	struct __bcma_dev_wrapper *wrapper;
+	int i, err, dev_id = 0;
+
+	for (i = 0; i < bus->nr_cores; i++) {
+		core = &(bus->cores[i]);
+
+		/* We support that cores ourself */
+		switch (core->id.id) {
+		case BCMA_CORE_CHIPCOMMON:
+		case BCMA_CORE_PCI:
+		case BCMA_CORE_PCIE:
+			continue;
+		}
+
+		wrapper = kzalloc(sizeof(*wrapper), GFP_KERNEL);
+		if (!wrapper) {
+			pr_err("Could not allocate wrapper for core 0x%03X\n",
+			       core->id.id);
+			continue;
+		}
+
+		wrapper->core = core;
+		wrapper->dev.release = bcma_release_core_dev;
+		wrapper->dev.bus = &bcma_bus_type;
+		dev_set_name(&wrapper->dev, "bcma%d:%d", 0/*bus->num*/, dev_id);
+
+		switch (bus->hosttype) {
+		case BCMA_HOSTTYPE_PCI:
+			wrapper->dev.parent = &bus->host_pci->dev;
+			break;
+		case BCMA_HOSTTYPE_NONE:
+		case BCMA_HOSTTYPE_SDIO:
+			break;
+		}
+
+		err = device_register(&wrapper->dev);
+		if (err) {
+			pr_err("Could not register dev for core 0x%03X\n",
+			       core->id.id);
+			kfree(wrapper);
+			continue;
+		}
+		core->dev = &wrapper->dev;
+		dev_id++;
+	}
+
+	return 0;
+}
+
+static void bcma_unregister_cores(struct bcma_bus *bus)
+{
+	struct bcma_device *core;
+	int i;
+
+	for (i = 0; i < bus->nr_cores; i++) {
+		core = &(bus->cores[i]);
+		if (core->dev)
+			device_unregister(core->dev);
+	}
+}
+
+int bcma_bus_register(struct bcma_bus *bus)
+{
+	int err;
+	struct bcma_device *core;
+
+	/* Scan for devices (cores) */
+	err = bcma_bus_scan(bus);
+	if (err) {
+		pr_err("Failed to scan: %d\n", err);
+		return -1;
+	}
+
+	/* Init CC core */
+	core = bcma_find_core(bus, BCMA_CORE_CHIPCOMMON);
+	if (core) {
+		bus->drv_cc.core = core;
+		bcma_core_chipcommon_init(&bus->drv_cc);
+	}
+
+	/* Init PCIE core */
+	core = bcma_find_core(bus, BCMA_CORE_PCIE);
+	if (core) {
+		bus->drv_pci.core = core;
+		bcma_core_pci_init(&bus->drv_pci);
+	}
+
+	/* Register found cores */
+	bcma_register_cores(bus);
+
+	pr_info("Bus registered\n");
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(bcma_bus_register);
+
+void bcma_bus_unregister(struct bcma_bus *bus)
+{
+	bcma_unregister_cores(bus);
+}
+EXPORT_SYMBOL_GPL(bcma_bus_unregister);
+
+int __bcma_driver_register(struct bcma_driver *drv, struct module *owner)
+{
+	drv->drv.name = drv->name;
+	drv->drv.bus = &bcma_bus_type;
+	drv->drv.owner = owner;
+
+	return driver_register(&drv->drv);
+}
+EXPORT_SYMBOL_GPL(__bcma_driver_register);
+
+void bcma_driver_unregister(struct bcma_driver *drv)
+{
+	driver_unregister(&drv->drv);
+}
+EXPORT_SYMBOL_GPL(bcma_driver_unregister);
+
+static int bcma_bus_match(struct device *dev, struct device_driver *drv)
+{
+	struct __bcma_dev_wrapper *wrapper = container_of(dev,
+						struct __bcma_dev_wrapper, dev);
+	struct bcma_device *core = wrapper->core;
+	struct bcma_driver *adrv = container_of(drv, struct bcma_driver, drv);
+	const struct bcma_device_id *cid = &core->id;
+	const struct bcma_device_id *did;
+
+	for (did = adrv->id_table; did->manuf || did->id || did->rev; did++) {
+	    if ((did->manuf == cid->manuf || did->manuf == BCMA_ANY_MANUF) &&
+		(did->id == cid->id || did->id == BCMA_ANY_ID) &&
+		(did->rev == cid->rev || did->rev == BCMA_ANY_REV) &&
+		(did->class == cid->class || did->class == BCMA_ANY_CLASS))
+			return 1;
+	}
+	return 0;
+}
+
+static int bcma_device_probe(struct device *dev)
+{
+	struct __bcma_dev_wrapper *wrapper = container_of(dev,
+						struct __bcma_dev_wrapper, dev);
+	struct bcma_device *core = wrapper->core;
+	struct bcma_driver *adrv = container_of(dev->driver, struct bcma_driver,
+					       drv);
+	int err = 0;
+
+	if (adrv->probe)
+		err = adrv->probe(core);
+
+	return err;
+}
+
+static int bcma_device_remove(struct device *dev)
+{
+	struct __bcma_dev_wrapper *wrapper = container_of(dev,
+						struct __bcma_dev_wrapper, dev);
+	struct bcma_device *core = wrapper->core;
+	struct bcma_driver *adrv = container_of(dev->driver, struct bcma_driver,
+					       drv);
+
+	if (adrv->remove)
+		adrv->remove(core);
+
+	return 0;
+}
+
+static int __init bcma_modinit(void)
+{
+	int err;
+
+	err = bus_register(&bcma_bus_type);
+	if (err)
+		return err;
+
+#ifdef CONFIG_BCMA_HOST_PCI
+	err = bcma_host_pci_init();
+	if (err) {
+		pr_err("PCI host initialization failed\n");
+		err = 0;
+	}
+#endif
+
+	return err;
+}
+fs_initcall(bcma_modinit);
+
+static void __exit bcma_modexit(void)
+{
+#ifdef CONFIG_BCMA_HOST_PCI
+	bcma_host_pci_exit();
+#endif
+	bus_unregister(&bcma_bus_type);
+}
+module_exit(bcma_modexit)
diff --git a/drivers/bcma/scan.c b/drivers/bcma/scan.c
new file mode 100644
index 0000000..ddf3d26
--- /dev/null
+++ b/drivers/bcma/scan.c
@@ -0,0 +1,392 @@
+/*
+ * Broadcom specific AMBA
+ * Bus scanning
+ *
+ * Licensed under the GNU/GPL. See COPYING for details.
+ */
+
+#include "scan.h"
+#include "bcma_private.h"
+
+#include <linux/bcma/bcma.h>
+#include <linux/bcma/bcma_regs.h>
+#include <linux/pci.h>
+#include <linux/io.h>
+#include <linux/dma-mapping.h>
+#include <linux/slab.h>
+
+const char *bcma_device_name(u16 coreid)
+{
+	switch (coreid) {
+	case BCMA_CORE_OOB_ROUTER:
+		return "OOB Router";
+	case BCMA_CORE_INVALID:
+		return "Invalid";
+	case BCMA_CORE_CHIPCOMMON:
+		return "ChipCommon";
+	case BCMA_CORE_ILINE20:
+		return "ILine 20";
+	case BCMA_CORE_SRAM:
+		return "SRAM";
+	case BCMA_CORE_SDRAM:
+		return "SDRAM";
+	case BCMA_CORE_PCI:
+		return "PCI";
+	case BCMA_CORE_MIPS:
+		return "MIPS";
+	case BCMA_CORE_ETHERNET:
+		return "Fast Ethernet";
+	case BCMA_CORE_V90:
+		return "V90";
+	case BCMA_CORE_USB11_HOSTDEV:
+		return "USB 1.1 Hostdev";
+	case BCMA_CORE_ADSL:
+		return "ADSL";
+	case BCMA_CORE_ILINE100:
+		return "ILine 100";
+	case BCMA_CORE_IPSEC:
+		return "IPSEC";
+	case BCMA_CORE_UTOPIA:
+		return "UTOPIA";
+	case BCMA_CORE_PCMCIA:
+		return "PCMCIA";
+	case BCMA_CORE_INTERNAL_MEM:
+		return "Internal Memory";
+	case BCMA_CORE_MEMC_SDRAM:
+		return "MEMC SDRAM";
+	case BCMA_CORE_OFDM:
+		return "OFDM";
+	case BCMA_CORE_EXTIF:
+		return "EXTIF";
+	case BCMA_CORE_80211:
+		return "IEEE 802.11";
+	case BCMA_CORE_PHY_A:
+		return "PHY A";
+	case BCMA_CORE_PHY_B:
+		return "PHY B";
+	case BCMA_CORE_PHY_G:
+		return "PHY G";
+	case BCMA_CORE_MIPS_3302:
+		return "MIPS 3302";
+	case BCMA_CORE_USB11_HOST:
+		return "USB 1.1 Host";
+	case BCMA_CORE_USB11_DEV:
+		return "USB 1.1 Device";
+	case BCMA_CORE_USB20_HOST:
+		return "USB 2.0 Host";
+	case BCMA_CORE_USB20_DEV:
+		return "USB 2.0 Device";
+	case BCMA_CORE_SDIO_HOST:
+		return "SDIO Host";
+	case BCMA_CORE_ROBOSWITCH:
+		return "Roboswitch";
+	case BCMA_CORE_PARA_ATA:
+		return "PATA";
+	case BCMA_CORE_SATA_XORDMA:
+		return "SATA XOR-DMA";
+	case BCMA_CORE_ETHERNET_GBIT:
+		return "GBit Ethernet";
+	case BCMA_CORE_PCIE:
+		return "PCIe";
+	case BCMA_CORE_PHY_N:
+		return "PHY N";
+	case BCMA_CORE_SRAM_CTL:
+		return "SRAM Controller";
+	case BCMA_CORE_MINI_MACPHY:
+		return "Mini MACPHY";
+	case BCMA_CORE_ARM_1176:
+		return "ARM 1176";
+	case BCMA_CORE_ARM_7TDMI:
+		return "ARM 7TDMI";
+	case BCMA_CORE_PHY_LP:
+		return "PHY LP";
+	case BCMA_CORE_PMU:
+		return "PMU";
+	case BCMA_CORE_PHY_SSN:
+		return "PHY SSN";
+	case BCMA_CORE_SDIO_DEV:
+		return "SDIO Device";
+	case BCMA_CORE_ARM_CM3:
+		return "ARM CM3";
+	case BCMA_CORE_PHY_HT:
+		return "PHY HT";
+	case BCMA_CORE_MIPS_74K:
+		return "MIPS 74K";
+	case BCMA_CORE_MAC_GBIT:
+		return "GBit MAC";
+	case BCMA_CORE_DDR12_MEM_CTL:
+		return "DDR1/DDR2 Memory Controller";
+	case BCMA_CORE_PCIE_RC:
+		return "PCIe Root Complex";
+	case BCMA_CORE_OCP_OCP_BRIDGE:
+		return "OCP to OCP Bridge";
+	case BCMA_CORE_SHARED_COMMON:
+		return "Common Shared";
+	case BCMA_CORE_OCP_AHB_BRIDGE:
+		return "OCP to AHB Bridge";
+	case BCMA_CORE_SPI_HOST:
+		return "SPI Host";
+	case BCMA_CORE_I2S:
+		return "I2S";
+	case BCMA_CORE_SDR_DDR1_MEM_CTL:
+		return "SDR/DDR1 Memory Controller";
+	case BCMA_CORE_SHIM:
+		return "SHIM";
+	case BCMA_CORE_DEFAULT:
+		return "Default";
+	}
+	return "UNKNOWN";
+}
+
+static u32 bcma_scan_read32(struct bcma_bus *bus, u8 current_coreidx,
+		       u16 offset)
+{
+	return readl(bus->mmio + offset);
+}
+
+static void bcma_scan_switch_core(struct bcma_bus *bus, u32 addr)
+{
+	if (bus->hosttype == BCMA_HOSTTYPE_PCI)
+		pci_write_config_dword(bus->host_pci, BCMA_PCI_BAR0_WIN,
+				       addr);
+}
+
+static u32 bcma_erom_get_ent(struct bcma_bus *bus, u32 **eromptr)
+{
+	u32 ent = readl(*eromptr);
+	(*eromptr)++;
+	return ent;
+}
+
+static void bcma_erom_push_ent(u32 **eromptr)
+{
+	(*eromptr)--;
+}
+
+static s32 bcma_erom_get_ci(struct bcma_bus *bus, u32 **eromptr)
+{
+	u32 ent = bcma_erom_get_ent(bus, eromptr);
+	if (!(ent & SCAN_ER_VALID))
+		return -1;
+	if ((ent & SCAN_ER_TAG) != SCAN_ER_TAG_CI)
+		return -2;
+	return ent;
+}
+
+static bool bcma_erom_is_end(struct bcma_bus *bus, u32 **eromptr)
+{
+	u32 ent = bcma_erom_get_ent(bus, eromptr);
+	bcma_erom_push_ent(eromptr);
+	return (ent == (SCAN_ER_TAG_END | SCAN_ER_VALID));
+}
+
+static bool bcma_erom_is_bridge(struct bcma_bus *bus, u32 **eromptr)
+{
+	u32 ent = bcma_erom_get_ent(bus, eromptr);
+	bcma_erom_push_ent(eromptr);
+	return (((ent & SCAN_ER_VALID)) &&
+		((ent & SCAN_ER_TAGX) == SCAN_ER_TAG_ADDR) &&
+		((ent & SCAN_ADDR_TYPE) == SCAN_ADDR_TYPE_BRIDGE));
+}
+
+static void bcma_erom_skip_component(struct bcma_bus *bus, u32 **eromptr)
+{
+	u32 ent;
+	while (1) {
+		ent = bcma_erom_get_ent(bus, eromptr);
+		if ((ent & SCAN_ER_VALID) &&
+		    ((ent & SCAN_ER_TAG) == SCAN_ER_TAG_CI))
+			break;
+		if (ent == (SCAN_ER_TAG_END | SCAN_ER_VALID))
+			break;
+	}
+	bcma_erom_push_ent(eromptr);
+}
+
+static s32 bcma_erom_get_mst_port(struct bcma_bus *bus, u32 **eromptr)
+{
+	u32 ent = bcma_erom_get_ent(bus, eromptr);
+	if (!(ent & SCAN_ER_VALID))
+		return -1;
+	if ((ent & SCAN_ER_TAG) != SCAN_ER_TAG_MP)
+		return -2;
+	return ent;
+}
+
+static s32 bcma_erom_get_addr_desc(struct bcma_bus *bus, u32 **eromptr,
+				  u32 type, u8 port)
+{
+	u32 addrl, addrh, sizel, sizeh = 0;
+	u32 size;
+
+	u32 ent = bcma_erom_get_ent(bus, eromptr);
+	if ((!(ent & SCAN_ER_VALID)) ||
+	    ((ent & SCAN_ER_TAGX) != SCAN_ER_TAG_ADDR) ||
+	    ((ent & SCAN_ADDR_TYPE) != type) ||
+	    (((ent & SCAN_ADDR_PORT) >> SCAN_ADDR_PORT_SHIFT) != port)) {
+		bcma_erom_push_ent(eromptr);
+		return -1;
+	}
+
+	addrl = ent & SCAN_ADDR_ADDR;
+	if (ent & SCAN_ADDR_AG32)
+		addrh = bcma_erom_get_ent(bus, eromptr);
+	else
+		addrh = 0;
+
+	if ((ent & SCAN_ADDR_SZ) == SCAN_ADDR_SZ_SZD) {
+		size = bcma_erom_get_ent(bus, eromptr);
+		sizel = size & SCAN_SIZE_SZ;
+		if (size & SCAN_SIZE_SG32)
+			sizeh = bcma_erom_get_ent(bus, eromptr);
+	} else
+		sizel = SCAN_ADDR_SZ_BASE <<
+				((ent & SCAN_ADDR_SZ) >> SCAN_ADDR_SZ_SHIFT);
+
+	return addrl;
+}
+
+int bcma_bus_scan(struct bcma_bus *bus)
+{
+	u32 erombase;
+	u32 __iomem *eromptr, *eromend;
+
+	s32 cia, cib;
+	u8 ports[2], wrappers[2];
+
+	s32 tmp;
+	u8 i, j;
+
+	bus->nr_cores = 0;
+
+	bcma_scan_switch_core(bus, BCMA_ADDR_BASE);
+
+	tmp = bcma_scan_read32(bus, 0, BCMA_CC_ID);
+	bus->chipinfo.id = (tmp & BCMA_CC_ID_ID) >> BCMA_CC_ID_ID_SHIFT;
+	bus->chipinfo.rev = (tmp & BCMA_CC_ID_REV) >> BCMA_CC_ID_REV_SHIFT;
+	bus->chipinfo.pkg = (tmp & BCMA_CC_ID_PKG) >> BCMA_CC_ID_PKG_SHIFT;
+
+	erombase = bcma_scan_read32(bus, 0, BCMA_CC_EROM);
+	eromptr = bus->mmio;
+	eromend = eromptr + BCMA_CORE_SIZE / sizeof(u32);
+
+	bcma_scan_switch_core(bus, erombase);
+
+	while (eromptr < eromend) {
+		struct bcma_device core = { };
+		core.bus = bus;
+
+		/* get CIs */
+		cia = bcma_erom_get_ci(bus, &eromptr);
+		if (cia < 0) {
+			bcma_erom_push_ent(&eromptr);
+			if (bcma_erom_is_end(bus, &eromptr))
+				break;
+			return -1;
+		}
+		cib = bcma_erom_get_ci(bus, &eromptr);
+		if (cib < 0)
+			return -2;
+
+		/* parse CIs */
+		core.id.class = (cia & SCAN_CIA_CLASS) >> SCAN_CIA_CLASS_SHIFT;
+		core.id.id = (cia & SCAN_CIA_ID) >> SCAN_CIA_ID_SHIFT;
+		core.id.manuf = (cia & SCAN_CIA_MANUF) >> SCAN_CIA_MANUF_SHIFT;
+		ports[0] = (cib & SCAN_CIB_NMP) >> SCAN_CIB_NMP_SHIFT;
+		ports[1] = (cib & SCAN_CIB_NSP) >> SCAN_CIB_NSP_SHIFT;
+		wrappers[0] = (cib & SCAN_CIB_NMW) >> SCAN_CIB_NMW_SHIFT;
+		wrappers[1] = (cib & SCAN_CIB_NSW) >> SCAN_CIB_NSW_SHIFT;
+		core.id.rev = (cib & SCAN_CIB_REV) >> SCAN_CIB_REV_SHIFT;
+
+		if (((core.id.manuf == BCMA_MANUF_ARM) &&
+		     (core.id.id == 0xFFF)) ||
+		    (ports[1] == 0)) {
+			bcma_erom_skip_component(bus, &eromptr);
+			continue;
+		}
+
+		/* check if component is a core at all */
+		if (wrappers[0] + wrappers[1] == 0) {
+			/* we could save addrl of the router
+			if (cid == BCMA_CORE_OOB_ROUTER)
+			 */
+			bcma_erom_skip_component(bus, &eromptr);
+			continue;
+		}
+
+		if (bcma_erom_is_bridge(bus, &eromptr)) {
+			bcma_erom_skip_component(bus, &eromptr);
+			continue;
+		}
+
+		/* get & parse master ports */
+		for (i = 0; i < ports[0]; i++) {
+			u32 mst_port_d = bcma_erom_get_mst_port(bus, &eromptr);
+			if (mst_port_d < 0)
+				return -3;
+		}
+
+		/* get & parse slave ports */
+		for (i = 0; i < ports[1]; i++) {
+			for (j = 0; ; j++) {
+				tmp = bcma_erom_get_addr_desc(bus, &eromptr,
+					SCAN_ADDR_TYPE_SLAVE, i);
+				if (tmp < 0) {
+					/* no more entries for port _i_ */
+					/* pr_debug("erom: slave port %d "
+					 * "has %d descriptors\n", i, j); */
+					break;
+				} else {
+					if (i == 0 && j == 0)
+						core.addr = tmp;
+				}
+			}
+		}
+
+		/* get & parse master wrappers */
+		for (i = 0; i < wrappers[0]; i++) {
+			for (j = 0; ; j++) {
+				tmp = bcma_erom_get_addr_desc(bus, &eromptr,
+					SCAN_ADDR_TYPE_MWRAP, i);
+				if (tmp < 0) {
+					/* no more entries for port _i_ */
+					/* pr_debug("erom: master wrapper %d "
+					 * "has %d descriptors\n", i, j); */
+					break;
+				} else {
+					if (i == 0 && j == 0)
+						core.wrap = tmp;
+				}
+			}
+		}
+
+		/* get & parse slave wrappers */
+		for (i = 0; i < wrappers[1]; i++) {
+			u8 hack = (ports[1] == 1) ? 0 : 1;
+			for (j = 0; ; j++) {
+				tmp = bcma_erom_get_addr_desc(bus, &eromptr,
+					SCAN_ADDR_TYPE_SWRAP, i + hack);
+				if (tmp < 0) {
+					/* no more entries for port _i_ */
+					/* pr_debug("erom: master wrapper %d "
+					 * has %d descriptors\n", i, j); */
+					break;
+				} else {
+					if (wrappers[0] == 0 && !i && !j)
+						core.wrap = tmp;
+				}
+			}
+		}
+
+		pr_info("Core %d found: %s "
+			"(manuf 0x%03X, id 0x%03X, rev 0x%02X, class 0x%X)\n",
+			bus->nr_cores, bcma_device_name(core.id.id),
+			core.id.manuf, core.id.id, core.id.rev,
+			core.id.class);
+
+		core.core_index = bus->nr_cores;
+		bus->cores[bus->nr_cores++] = core;
+	}
+
+	return 0;
+}
diff --git a/drivers/bcma/scan.h b/drivers/bcma/scan.h
new file mode 100644
index 0000000..113e6a6
--- /dev/null
+++ b/drivers/bcma/scan.h
@@ -0,0 +1,56 @@
+#ifndef BCMA_SCAN_H_
+#define BCMA_SCAN_H_
+
+#define BCMA_ADDR_BASE		0x18000000
+#define BCMA_WRAP_BASE		0x18100000
+
+#define SCAN_ER_VALID		0x00000001
+#define SCAN_ER_TAGX		0x00000006 /* we have to ignore 0x8 bit when checking tag for SCAN_ER_TAG_ADDR */
+#define SCAN_ER_TAG		0x0000000E
+#define  SCAN_ER_TAG_CI		0x00000000
+#define  SCAN_ER_TAG_MP		0x00000002
+#define  SCAN_ER_TAG_ADDR	0x00000004
+#define  SCAN_ER_TAG_END	0x0000000E
+#define SCAN_ER_BAD		0xFFFFFFFF
+
+#define SCAN_CIA_CLASS		0x000000F0
+#define SCAN_CIA_CLASS_SHIFT	4
+#define SCAN_CIA_ID		0x000FFF00
+#define SCAN_CIA_ID_SHIFT	8
+#define SCAN_CIA_MANUF		0xFFF00000
+#define SCAN_CIA_MANUF_SHIFT	20
+
+#define SCAN_CIB_NMP		0x000001F0
+#define SCAN_CIB_NMP_SHIFT	4
+#define SCAN_CIB_NSP		0x00003E00
+#define SCAN_CIB_NSP_SHIFT	9
+#define SCAN_CIB_NMW		0x0007C000
+#define SCAN_CIB_NMW_SHIFT	14
+#define SCAN_CIB_NSW		0x00F80000
+#define SCAN_CIB_NSW_SHIFT	17
+#define SCAN_CIB_REV		0xFF000000
+#define SCAN_CIB_REV_SHIFT	24
+
+#define SCAN_ADDR_AG32		0x00000008
+#define SCAN_ADDR_SZ		0x00000030
+#define SCAN_ADDR_SZ_SHIFT	4
+#define  SCAN_ADDR_SZ_4K	0x00000000
+#define  SCAN_ADDR_SZ_8K	0x00000010
+#define  SCAN_ADDR_SZ_16K	0x00000020
+#define  SCAN_ADDR_SZ_SZD	0x00000030
+#define SCAN_ADDR_TYPE		0x000000C0
+#define  SCAN_ADDR_TYPE_SLAVE	0x00000000
+#define  SCAN_ADDR_TYPE_BRIDGE	0x00000040
+#define  SCAN_ADDR_TYPE_SWRAP	0x00000080
+#define  SCAN_ADDR_TYPE_MWRAP	0x000000C0
+#define SCAN_ADDR_PORT		0x00000F00
+#define SCAN_ADDR_PORT_SHIFT	8
+#define SCAN_ADDR_ADDR		0xFFFFF000
+
+#define SCAN_ADDR_SZ_BASE	0x00001000	/* 4KB */
+
+#define SCAN_SIZE_SZ_ALIGN	0x00000FFF
+#define SCAN_SIZE_SZ		0xFFFFF000
+#define SCAN_SIZE_SG32		0x00000008
+
+#endif /* BCMA_SCAN_H_ */
diff --git a/include/linux/bcma/bcma.h b/include/linux/bcma/bcma.h
new file mode 100644
index 0000000..0df6633
--- /dev/null
+++ b/include/linux/bcma/bcma.h
@@ -0,0 +1,232 @@
+#ifndef LINUX_BCMA_H_
+#define LINUX_BCMA_H_
+
+#include <linux/pci.h>
+#include <linux/mod_devicetable.h>
+
+#include <linux/bcma/bcma_driver_chipcommon.h>
+#include <linux/bcma/bcma_driver_pci.h>
+
+#include "bcma_regs.h"
+
+struct bcma_device;
+struct bcma_bus;
+
+enum bcma_hosttype {
+	BCMA_HOSTTYPE_NONE,
+	BCMA_HOSTTYPE_PCI,
+	BCMA_HOSTTYPE_SDIO,
+};
+
+struct bcma_chipinfo {
+	u16 id;
+	u8 rev;
+	u8 pkg;
+};
+
+struct bcma_host_ops {
+	u8 (*read8)(struct bcma_device *core, u16 offset);
+	u16 (*read16)(struct bcma_device *core, u16 offset);
+	u32 (*read32)(struct bcma_device *core, u16 offset);
+	void (*write8)(struct bcma_device *core, u16 offset, u8 value);
+	void (*write16)(struct bcma_device *core, u16 offset, u16 value);
+	void (*write32)(struct bcma_device *core, u16 offset, u32 value);
+	/* Agent ops */
+	u32 (*aread32)(struct bcma_device *core, u16 offset);
+	void (*awrite32)(struct bcma_device *core, u16 offset, u32 value);
+};
+
+/* Core manufacturers */
+#define BCMA_MANUF_ARM			0x43B
+#define BCMA_MANUF_MIPS			0x4A7
+#define BCMA_MANUF_BCM			0x4BF
+
+/* Core class values. */
+#define BCMA_CL_SIM			0x0
+#define BCMA_CL_EROM			0x1
+#define BCMA_CL_CORESIGHT		0x9
+#define BCMA_CL_VERIF			0xB
+#define BCMA_CL_OPTIMO			0xD
+#define BCMA_CL_GEN			0xE
+#define BCMA_CL_PRIMECELL		0xF
+
+/* Core-ID values. */
+#define BCMA_CORE_OOB_ROUTER		0x367	/* Out of band */
+#define BCMA_CORE_INVALID		0x700
+#define BCMA_CORE_CHIPCOMMON		0x800
+#define BCMA_CORE_ILINE20		0x801
+#define BCMA_CORE_SRAM			0x802
+#define BCMA_CORE_SDRAM			0x803
+#define BCMA_CORE_PCI			0x804
+#define BCMA_CORE_MIPS			0x805
+#define BCMA_CORE_ETHERNET		0x806
+#define BCMA_CORE_V90			0x807
+#define BCMA_CORE_USB11_HOSTDEV		0x808
+#define BCMA_CORE_ADSL			0x809
+#define BCMA_CORE_ILINE100		0x80A
+#define BCMA_CORE_IPSEC			0x80B
+#define BCMA_CORE_UTOPIA		0x80C
+#define BCMA_CORE_PCMCIA		0x80D
+#define BCMA_CORE_INTERNAL_MEM		0x80E
+#define BCMA_CORE_MEMC_SDRAM		0x80F
+#define BCMA_CORE_OFDM			0x810
+#define BCMA_CORE_EXTIF			0x811
+#define BCMA_CORE_80211			0x812
+#define BCMA_CORE_PHY_A			0x813
+#define BCMA_CORE_PHY_B			0x814
+#define BCMA_CORE_PHY_G			0x815
+#define BCMA_CORE_MIPS_3302		0x816
+#define BCMA_CORE_USB11_HOST		0x817
+#define BCMA_CORE_USB11_DEV		0x818
+#define BCMA_CORE_USB20_HOST		0x819
+#define BCMA_CORE_USB20_DEV		0x81A
+#define BCMA_CORE_SDIO_HOST		0x81B
+#define BCMA_CORE_ROBOSWITCH		0x81C
+#define BCMA_CORE_PARA_ATA		0x81D
+#define BCMA_CORE_SATA_XORDMA		0x81E
+#define BCMA_CORE_ETHERNET_GBIT		0x81F
+#define BCMA_CORE_PCIE			0x820
+#define BCMA_CORE_PHY_N			0x821
+#define BCMA_CORE_SRAM_CTL		0x822
+#define BCMA_CORE_MINI_MACPHY		0x823
+#define BCMA_CORE_ARM_1176		0x824
+#define BCMA_CORE_ARM_7TDMI		0x825
+#define BCMA_CORE_PHY_LP		0x826
+#define BCMA_CORE_PMU			0x827
+#define BCMA_CORE_PHY_SSN		0x828
+#define BCMA_CORE_SDIO_DEV		0x829
+#define BCMA_CORE_ARM_CM3		0x82A
+#define BCMA_CORE_PHY_HT		0x82B
+#define BCMA_CORE_MIPS_74K		0x82C
+#define BCMA_CORE_MAC_GBIT		0x82D
+#define BCMA_CORE_DDR12_MEM_CTL		0x82E
+#define BCMA_CORE_PCIE_RC		0x82F	/* PCIe Root Complex */
+#define BCMA_CORE_OCP_OCP_BRIDGE	0x830
+#define BCMA_CORE_SHARED_COMMON		0x831
+#define BCMA_CORE_OCP_AHB_BRIDGE	0x832
+#define BCMA_CORE_SPI_HOST		0x833
+#define BCMA_CORE_I2S			0x834
+#define BCMA_CORE_SDR_DDR1_MEM_CTL	0x835	/* SDR/DDR1 memory controller core */
+#define BCMA_CORE_SHIM			0x837	/* SHIM component in ubus/6362 */
+#define BCMA_CORE_DEFAULT		0xFFF
+
+#define BCMA_MAX_NR_CORES		16
+
+/* 1) It is not allowed to put struct device statically in bcma_device
+ * 2) We can not just use pointer to struct device because we use container_of
+ * 3) We do not have pointer to struct bcma_device in struct device
+ * Solution: use such a dummy wrapper
+ */
+struct __bcma_dev_wrapper {
+	struct device dev;
+	struct bcma_device *core;
+};
+
+struct bcma_device {
+	struct bcma_bus *bus;
+	struct bcma_device_id id;
+
+	struct device *dev;
+
+	u8 core_index;
+
+	u32 addr;
+	u32 wrap;
+
+	void *drvdata;
+};
+
+static inline void *bcma_get_drvdata(struct bcma_device *core)
+{
+	return core->drvdata;
+}
+static inline void bcma_set_drvdata(struct bcma_device *core, void *drvdata)
+{
+	core->drvdata = drvdata;
+}
+
+struct bcma_driver {
+	const char *name;
+	const struct bcma_device_id *id_table;
+
+	int (*probe)(struct bcma_device *dev);
+	void (*remove)(struct bcma_device *dev);
+	int (*suspend)(struct bcma_device *dev, pm_message_t state);
+	int (*resume)(struct bcma_device *dev);
+	void (*shutdown)(struct bcma_device *dev);
+
+	struct device_driver drv;
+};
+extern
+int __bcma_driver_register(struct bcma_driver *drv, struct module *owner);
+static inline int bcma_driver_register(struct bcma_driver *drv)
+{
+	return __bcma_driver_register(drv, THIS_MODULE);
+}
+extern void bcma_driver_unregister(struct bcma_driver *drv);
+
+struct bcma_bus {
+	/* The MMIO area. */
+	void __iomem *mmio;
+
+	const struct bcma_host_ops *ops;
+
+	enum bcma_hosttype hosttype;
+	union {
+		/* Pointer to the PCI bus (only for BCMA_HOSTTYPE_PCI) */
+		struct pci_dev *host_pci;
+		/* Pointer to the SDIO device (only for BCMA_HOSTTYPE_SDIO) */
+		struct sdio_func *host_sdio;
+	};
+
+	struct bcma_chipinfo chipinfo;
+
+	struct bcma_device *mapped_core;
+	struct bcma_device cores[BCMA_MAX_NR_CORES];
+	u8 nr_cores;
+
+	struct bcma_drv_cc drv_cc;
+	struct bcma_drv_pci drv_pci;
+};
+
+extern inline u32 bcma_read8(struct bcma_device *core, u16 offset)
+{
+	return core->bus->ops->read8(core, offset);
+}
+extern inline u32 bcma_read16(struct bcma_device *core, u16 offset)
+{
+	return core->bus->ops->read16(core, offset);
+}
+extern inline u32 bcma_read32(struct bcma_device *core, u16 offset)
+{
+	return core->bus->ops->read32(core, offset);
+}
+extern inline
+void bcma_write8(struct bcma_device *core, u16 offset, u32 value)
+{
+	core->bus->ops->write8(core, offset, value);
+}
+extern inline
+void bcma_write16(struct bcma_device *core, u16 offset, u32 value)
+{
+	core->bus->ops->write16(core, offset, value);
+}
+extern inline
+void bcma_write32(struct bcma_device *core, u16 offset, u32 value)
+{
+	core->bus->ops->write32(core, offset, value);
+}
+extern inline u32 bcma_aread32(struct bcma_device *core, u16 offset)
+{
+	return core->bus->ops->aread32(core, offset);
+}
+extern inline
+void bcma_awrite32(struct bcma_device *core, u16 offset, u32 value)
+{
+	core->bus->ops->awrite32(core, offset, value);
+}
+
+extern bool bcma_core_is_enabled(struct bcma_device *core);
+extern int bcma_core_enable(struct bcma_device *core, u32 flags);
+
+#endif /* LINUX_BCMA_H_ */
diff --git a/include/linux/bcma/bcma_driver_chipcommon.h b/include/linux/bcma/bcma_driver_chipcommon.h
new file mode 100644
index 0000000..4f8fd6a
--- /dev/null
+++ b/include/linux/bcma/bcma_driver_chipcommon.h
@@ -0,0 +1,297 @@
+#ifndef LINUX_BCMA_DRIVER_CC_H_
+#define LINUX_BCMA_DRIVER_CC_H_
+
+/** ChipCommon core registers. **/
+#define BCMA_CC_ID			0x0000
+#define  BCMA_CC_ID_ID			0x0000FFFF
+#define  BCMA_CC_ID_ID_SHIFT		0
+#define  BCMA_CC_ID_REV			0x000F0000
+#define  BCMA_CC_ID_REV_SHIFT		16
+#define  BCMA_CC_ID_PKG			0x00F00000
+#define  BCMA_CC_ID_PKG_SHIFT		20
+#define  BCMA_CC_ID_NRCORES		0x0F000000
+#define  BCMA_CC_ID_NRCORES_SHIFT	24
+#define  BCMA_CC_ID_TYPE		0xF0000000
+#define  BCMA_CC_ID_TYPE_SHIFT		28
+#define BCMA_CC_CAP			0x0004		/* Capabilities */
+#define  BCMA_CC_CAP_NRUART		0x00000003	/* # of UARTs */
+#define  BCMA_CC_CAP_MIPSEB		0x00000004	/* MIPS in BigEndian Mode */
+#define  BCMA_CC_CAP_UARTCLK		0x00000018	/* UART clock select */
+#define   BCMA_CC_CAP_UARTCLK_INT	0x00000008	/* UARTs are driven by internal divided clock */
+#define  BCMA_CC_CAP_UARTGPIO		0x00000020	/* UARTs on GPIO 15-12 */
+#define  BCMA_CC_CAP_EXTBUS		0x000000C0	/* External buses present */
+#define  BCMA_CC_CAP_FLASHT		0x00000700	/* Flash Type */
+#define   BCMA_CC_FLASHT_NONE		0x00000000	/* No flash */
+#define   BCMA_CC_FLASHT_STSER		0x00000100	/* ST serial flash */
+#define   BCMA_CC_FLASHT_ATSER		0x00000200	/* Atmel serial flash */
+#define	  BCMA_CC_FLASHT_PARA		0x00000700	/* Parallel flash */
+#define  BCMA_CC_CAP_PLLT		0x00038000	/* PLL Type */
+#define   BCMA_PLLTYPE_NONE		0x00000000
+#define   BCMA_PLLTYPE_1		0x00010000	/* 48Mhz base, 3 dividers */
+#define   BCMA_PLLTYPE_2		0x00020000	/* 48Mhz, 4 dividers */
+#define   BCMA_PLLTYPE_3		0x00030000	/* 25Mhz, 2 dividers */
+#define   BCMA_PLLTYPE_4		0x00008000	/* 48Mhz, 4 dividers */
+#define   BCMA_PLLTYPE_5		0x00018000	/* 25Mhz, 4 dividers */
+#define   BCMA_PLLTYPE_6		0x00028000	/* 100/200 or 120/240 only */
+#define   BCMA_PLLTYPE_7		0x00038000	/* 25Mhz, 4 dividers */
+#define  BCMA_CC_CAP_PCTL		0x00040000	/* Power Control */
+#define  BCMA_CC_CAP_OTPS		0x00380000	/* OTP size */
+#define  BCMA_CC_CAP_OTPS_SHIFT		19
+#define  BCMA_CC_CAP_OTPS_BASE		5
+#define  BCMA_CC_CAP_JTAGM		0x00400000	/* JTAG master present */
+#define  BCMA_CC_CAP_BROM		0x00800000	/* Internal boot ROM active */
+#define  BCMA_CC_CAP_64BIT		0x08000000	/* 64-bit Backplane */
+#define  BCMA_CC_CAP_PMU		0x10000000	/* PMU available (rev >= 20) */
+#define  BCMA_CC_CAP_ECI		0x20000000	/* ECI available (rev >= 20) */
+#define  BCMA_CC_CAP_SPROM		0x40000000	/* SPROM present */
+#define BCMA_CC_CORECTL			0x0008
+#define  BCMA_CC_CORECTL_UARTCLK0	0x00000001	/* Drive UART with internal clock */
+#define	 BCMA_CC_CORECTL_SE		0x00000002	/* sync clk out enable (corerev >= 3) */
+#define  BCMA_CC_CORECTL_UARTCLKEN	0x00000008	/* UART clock enable (rev >= 21) */
+#define BCMA_CC_BIST			0x000C
+#define BCMA_CC_OTPS			0x0010		/* OTP status */
+#define	 BCMA_CC_OTPS_PROGFAIL		0x80000000
+#define	 BCMA_CC_OTPS_PROTECT		0x00000007
+#define	 BCMA_CC_OTPS_HW_PROTECT	0x00000001
+#define	 BCMA_CC_OTPS_SW_PROTECT	0x00000002
+#define	 BCMA_CC_OTPS_CID_PROTECT	0x00000004
+#define BCMA_CC_OTPC			0x0014		/* OTP control */
+#define	 BCMA_CC_OTPC_RECWAIT		0xFF000000
+#define	 BCMA_CC_OTPC_PROGWAIT		0x00FFFF00
+#define	 BCMA_CC_OTPC_PRW_SHIFT		8
+#define	 BCMA_CC_OTPC_MAXFAIL		0x00000038
+#define	 BCMA_CC_OTPC_VSEL		0x00000006
+#define	 BCMA_CC_OTPC_SELVL		0x00000001
+#define BCMA_CC_OTPP			0x0018		/* OTP prog */
+#define	 BCMA_CC_OTPP_COL		0x000000FF
+#define	 BCMA_CC_OTPP_ROW		0x0000FF00
+#define	 BCMA_CC_OTPP_ROW_SHIFT		8
+#define	 BCMA_CC_OTPP_READERR		0x10000000
+#define	 BCMA_CC_OTPP_VALUE		0x20000000
+#define	 BCMA_CC_OTPP_READ		0x40000000
+#define	 BCMA_CC_OTPP_START		0x80000000
+#define	 BCMA_CC_OTPP_BUSY		0x80000000
+#define BCMA_CC_IRQSTAT			0x0020
+#define BCMA_CC_IRQMASK			0x0024
+#define	 BCMA_CC_IRQ_GPIO		0x00000001	/* gpio intr */
+#define	 BCMA_CC_IRQ_EXT		0x00000002	/* ro: ext intr pin (corerev >= 3) */
+#define	 BCMA_CC_IRQ_WDRESET		0x80000000	/* watchdog reset occurred */
+#define BCMA_CC_CHIPCTL			0x0028		/* Rev >= 11 only */
+#define BCMA_CC_CHIPSTAT		0x002C		/* Rev >= 11 only */
+#define BCMA_CC_JCMD			0x0030		/* Rev >= 10 only */
+#define  BCMA_CC_JCMD_START		0x80000000
+#define  BCMA_CC_JCMD_BUSY		0x80000000
+#define  BCMA_CC_JCMD_PAUSE		0x40000000
+#define  BCMA_CC_JCMD0_ACC_MASK		0x0000F000
+#define  BCMA_CC_JCMD0_ACC_IRDR		0x00000000
+#define  BCMA_CC_JCMD0_ACC_DR		0x00001000
+#define  BCMA_CC_JCMD0_ACC_IR		0x00002000
+#define  BCMA_CC_JCMD0_ACC_RESET	0x00003000
+#define  BCMA_CC_JCMD0_ACC_IRPDR	0x00004000
+#define  BCMA_CC_JCMD0_ACC_PDR		0x00005000
+#define  BCMA_CC_JCMD0_IRW_MASK		0x00000F00
+#define  BCMA_CC_JCMD_ACC_MASK		0x000F0000	/* Changes for corerev 11 */
+#define  BCMA_CC_JCMD_ACC_IRDR		0x00000000
+#define  BCMA_CC_JCMD_ACC_DR		0x00010000
+#define  BCMA_CC_JCMD_ACC_IR		0x00020000
+#define  BCMA_CC_JCMD_ACC_RESET		0x00030000
+#define  BCMA_CC_JCMD_ACC_IRPDR		0x00040000
+#define  BCMA_CC_JCMD_ACC_PDR		0x00050000
+#define  BCMA_CC_JCMD_IRW_MASK		0x00001F00
+#define  BCMA_CC_JCMD_IRW_SHIFT		8
+#define  BCMA_CC_JCMD_DRW_MASK		0x0000003F
+#define BCMA_CC_JIR			0x0034		/* Rev >= 10 only */
+#define BCMA_CC_JDR			0x0038		/* Rev >= 10 only */
+#define BCMA_CC_JCTL			0x003C		/* Rev >= 10 only */
+#define  BCMA_CC_JCTL_FORCE_CLK		4		/* Force clock */
+#define  BCMA_CC_JCTL_EXT_EN		2		/* Enable external targets */
+#define  BCMA_CC_JCTL_EN		1		/* Enable Jtag master */
+#define BCMA_CC_FLASHCTL		0x0040
+#define  BCMA_CC_FLASHCTL_START		0x80000000
+#define  BCMA_CC_FLASHCTL_BUSY		BCMA_CC_FLASHCTL_START
+#define BCMA_CC_FLASHADDR		0x0044
+#define BCMA_CC_FLASHDATA		0x0048
+#define BCMA_CC_BCAST_ADDR		0x0050
+#define BCMA_CC_BCAST_DATA		0x0054
+#define BCMA_CC_GPIOIN			0x0060
+#define BCMA_CC_GPIOOUT			0x0064
+#define BCMA_CC_GPIOOUTEN		0x0068
+#define BCMA_CC_GPIOCTL			0x006C
+#define BCMA_CC_GPIOPOL			0x0070
+#define BCMA_CC_GPIOIRQ			0x0074
+#define BCMA_CC_WATCHDOG		0x0080
+#define BCMA_CC_GPIOTIMER		0x0088		/* LED powersave (corerev >= 16) */
+#define  BCMA_CC_GPIOTIMER_ONTIME_SHIFT	16
+#define BCMA_CC_GPIOTOUTM		0x008C		/* LED powersave (corerev >= 16) */
+#define BCMA_CC_CLOCK_N			0x0090
+#define BCMA_CC_CLOCK_SB		0x0094
+#define BCMA_CC_CLOCK_PCI		0x0098
+#define BCMA_CC_CLOCK_M2		0x009C
+#define BCMA_CC_CLOCK_MIPS		0x00A0
+#define BCMA_CC_CLKDIV			0x00A4		/* Rev >= 3 only */
+#define	 BCMA_CC_CLKDIV_SFLASH		0x0F000000
+#define	 BCMA_CC_CLKDIV_SFLASH_SHIFT	24
+#define	 BCMA_CC_CLKDIV_OTP		0x000F0000
+#define	 BCMA_CC_CLKDIV_OTP_SHIFT	16
+#define	 BCMA_CC_CLKDIV_JTAG		0x00000F00
+#define	 BCMA_CC_CLKDIV_JTAG_SHIFT	8
+#define	 BCMA_CC_CLKDIV_UART		0x000000FF
+#define BCMA_CC_CAP_EXT			0x00AC		/* Capabilities */
+#define BCMA_CC_PLLONDELAY		0x00B0		/* Rev >= 4 only */
+#define BCMA_CC_FREFSELDELAY		0x00B4		/* Rev >= 4 only */
+#define BCMA_CC_SLOWCLKCTL		0x00B8		/* 6 <= Rev <= 9 only */
+#define  BCMA_CC_SLOWCLKCTL_SRC		0x00000007	/* slow clock source mask */
+#define	  BCMA_CC_SLOWCLKCTL_SRC_LPO	0x00000000	/* source of slow clock is LPO */
+#define   BCMA_CC_SLOWCLKCTL_SRC_XTAL	0x00000001	/* source of slow clock is crystal */
+#define	  BCMA_CC_SLOECLKCTL_SRC_PCI	0x00000002	/* source of slow clock is PCI */
+#define  BCMA_CC_SLOWCLKCTL_LPOFREQ	0x00000200	/* LPOFreqSel, 1: 160Khz, 0: 32KHz */
+#define  BCMA_CC_SLOWCLKCTL_LPOPD	0x00000400	/* LPOPowerDown, 1: LPO is disabled, 0: LPO is enabled */
+#define  BCMA_CC_SLOWCLKCTL_FSLOW	0x00000800	/* ForceSlowClk, 1: sb/cores running on slow clock, 0: power logic control */
+#define  BCMA_CC_SLOWCLKCTL_IPLL	0x00001000	/* IgnorePllOffReq, 1/0: power logic ignores/honors PLL clock disable requests from core */
+#define  BCMA_CC_SLOWCLKCTL_ENXTAL	0x00002000	/* XtalControlEn, 1/0: power logic does/doesn't disable crystal when appropriate */
+#define  BCMA_CC_SLOWCLKCTL_XTALPU	0x00004000	/* XtalPU (RO), 1/0: crystal running/disabled */
+#define  BCMA_CC_SLOWCLKCTL_CLKDIV	0xFFFF0000	/* ClockDivider (SlowClk = 1/(4+divisor)) */
+#define  BCMA_CC_SLOWCLKCTL_CLKDIV_SHIFT	16
+#define BCMA_CC_SYSCLKCTL		0x00C0		/* Rev >= 3 only */
+#define	 BCMA_CC_SYSCLKCTL_IDLPEN	0x00000001	/* ILPen: Enable Idle Low Power */
+#define	 BCMA_CC_SYSCLKCTL_ALPEN	0x00000002	/* ALPen: Enable Active Low Power */
+#define	 BCMA_CC_SYSCLKCTL_PLLEN	0x00000004	/* ForcePLLOn */
+#define	 BCMA_CC_SYSCLKCTL_FORCEALP	0x00000008	/* Force ALP (or HT if ALPen is not set */
+#define	 BCMA_CC_SYSCLKCTL_FORCEHT	0x00000010	/* Force HT */
+#define  BCMA_CC_SYSCLKCTL_CLKDIV	0xFFFF0000	/* ClkDiv  (ILP = 1/(4+divisor)) */
+#define  BCMA_CC_SYSCLKCTL_CLKDIV_SHIFT	16
+#define BCMA_CC_CLKSTSTR		0x00C4		/* Rev >= 3 only */
+#define BCMA_CC_EROM			0x00FC
+#define BCMA_CC_PCMCIA_CFG		0x0100
+#define BCMA_CC_PCMCIA_MEMWAIT		0x0104
+#define BCMA_CC_PCMCIA_ATTRWAIT		0x0108
+#define BCMA_CC_PCMCIA_IOWAIT		0x010C
+#define BCMA_CC_IDE_CFG			0x0110
+#define BCMA_CC_IDE_MEMWAIT		0x0114
+#define BCMA_CC_IDE_ATTRWAIT		0x0118
+#define BCMA_CC_IDE_IOWAIT		0x011C
+#define BCMA_CC_PROG_CFG		0x0120
+#define BCMA_CC_PROG_WAITCNT		0x0124
+#define BCMA_CC_FLASH_CFG		0x0128
+#define BCMA_CC_FLASH_WAITCNT		0x012C
+#define BCMA_CC_CLKCTLST		0x01E0 /* Clock control and status (rev >= 20) */
+#define  BCMA_CC_CLKCTLST_FORCEALP	0x00000001 /* Force ALP request */
+#define  BCMA_CC_CLKCTLST_FORCEHT	0x00000002 /* Force HT request */
+#define  BCMA_CC_CLKCTLST_FORCEILP	0x00000004 /* Force ILP request */
+#define  BCMA_CC_CLKCTLST_HAVEALPREQ	0x00000008 /* ALP available request */
+#define  BCMA_CC_CLKCTLST_HAVEHTREQ	0x00000010 /* HT available request */
+#define  BCMA_CC_CLKCTLST_HWCROFF	0x00000020 /* Force HW clock request off */
+#define  BCMA_CC_CLKCTLST_HAVEHT	0x00010000 /* HT available */
+#define  BCMA_CC_CLKCTLST_HAVEALP	0x00020000 /* APL available */
+#define BCMA_CC_HW_WORKAROUND		0x01E4 /* Hardware workaround (rev >= 20) */
+#define BCMA_CC_UART0_DATA		0x0300
+#define BCMA_CC_UART0_IMR		0x0304
+#define BCMA_CC_UART0_FCR		0x0308
+#define BCMA_CC_UART0_LCR		0x030C
+#define BCMA_CC_UART0_MCR		0x0310
+#define BCMA_CC_UART0_LSR		0x0314
+#define BCMA_CC_UART0_MSR		0x0318
+#define BCMA_CC_UART0_SCRATCH		0x031C
+#define BCMA_CC_UART1_DATA		0x0400
+#define BCMA_CC_UART1_IMR		0x0404
+#define BCMA_CC_UART1_FCR		0x0408
+#define BCMA_CC_UART1_LCR		0x040C
+#define BCMA_CC_UART1_MCR		0x0410
+#define BCMA_CC_UART1_LSR		0x0414
+#define BCMA_CC_UART1_MSR		0x0418
+#define BCMA_CC_UART1_SCRATCH		0x041C
+/* PMU registers (rev >= 20) */
+#define BCMA_CC_PMU_CTL			0x0600 /* PMU control */
+#define  BCMA_CC_PMU_CTL_ILP_DIV	0xFFFF0000 /* ILP div mask */
+#define  BCMA_CC_PMU_CTL_ILP_DIV_SHIFT	16
+#define  BCMA_CC_PMU_CTL_NOILPONW	0x00000200 /* No ILP on wait */
+#define  BCMA_CC_PMU_CTL_HTREQEN	0x00000100 /* HT req enable */
+#define  BCMA_CC_PMU_CTL_ALPREQEN	0x00000080 /* ALP req enable */
+#define  BCMA_CC_PMU_CTL_XTALFREQ	0x0000007C /* Crystal freq */
+#define  BCMA_CC_PMU_CTL_XTALFREQ_SHIFT	2
+#define  BCMA_CC_PMU_CTL_ILPDIVEN	0x00000002 /* ILP div enable */
+#define  BCMA_CC_PMU_CTL_LPOSEL		0x00000001 /* LPO sel */
+#define BCMA_CC_PMU_CAP			0x0604 /* PMU capabilities */
+#define  BCMA_CC_PMU_CAP_REVISION	0x000000FF /* Revision mask */
+#define BCMA_CC_PMU_STAT		0x0608 /* PMU status */
+#define  BCMA_CC_PMU_STAT_INTPEND	0x00000040 /* Interrupt pending */
+#define  BCMA_CC_PMU_STAT_SBCLKST	0x00000030 /* Backplane clock status? */
+#define  BCMA_CC_PMU_STAT_HAVEALP	0x00000008 /* ALP available */
+#define  BCMA_CC_PMU_STAT_HAVEHT	0x00000004 /* HT available */
+#define  BCMA_CC_PMU_STAT_RESINIT	0x00000003 /* Res init */
+#define BCMA_CC_PMU_RES_STAT		0x060C /* PMU res status */
+#define BCMA_CC_PMU_RES_PEND		0x0610 /* PMU res pending */
+#define BCMA_CC_PMU_TIMER		0x0614 /* PMU timer */
+#define BCMA_CC_PMU_MINRES_MSK		0x0618 /* PMU min res mask */
+#define BCMA_CC_PMU_MAXRES_MSK		0x061C /* PMU max res mask */
+#define BCMA_CC_PMU_RES_TABSEL		0x0620 /* PMU res table sel */
+#define BCMA_CC_PMU_RES_DEPMSK		0x0624 /* PMU res dep mask */
+#define BCMA_CC_PMU_RES_UPDNTM		0x0628 /* PMU res updown timer */
+#define BCMA_CC_PMU_RES_TIMER		0x062C /* PMU res timer */
+#define BCMA_CC_PMU_CLKSTRETCH		0x0630 /* PMU clockstretch */
+#define BCMA_CC_PMU_WATCHDOG		0x0634 /* PMU watchdog */
+#define BCMA_CC_PMU_RES_REQTS		0x0640 /* PMU res req timer sel */
+#define BCMA_CC_PMU_RES_REQT		0x0644 /* PMU res req timer */
+#define BCMA_CC_PMU_RES_REQM		0x0648 /* PMU res req mask */
+#define BCMA_CC_CHIPCTL_ADDR		0x0650
+#define BCMA_CC_CHIPCTL_DATA		0x0654
+#define BCMA_CC_REGCTL_ADDR		0x0658
+#define BCMA_CC_REGCTL_DATA		0x065C
+#define BCMA_CC_PLLCTL_ADDR		0x0660
+#define BCMA_CC_PLLCTL_DATA		0x0664
+
+/* Data for the PMU, if available.
+ * Check availability with ((struct bcma_chipcommon)->capabilities & BCMA_CC_CAP_PMU)
+ */
+struct bcma_chipcommon_pmu {
+	u8 rev;			/* PMU revision */
+	u32 crystalfreq;	/* The active crystal frequency (in kHz) */
+};
+
+struct bcma_drv_cc {
+	struct bcma_device *core;
+	u32 status;
+	u32 capabilities;
+	u32 capabilities_ext;
+	/* Fast Powerup Delay constant */
+	u16 fast_pwrup_delay;
+	struct bcma_chipcommon_pmu pmu;
+};
+
+/* Register access */
+#define bcma_cc_read32(cc, offset) \
+	bcma_read32((cc)->core, offset)
+#define bcma_cc_write32(cc, offset, val) \
+	bcma_write32((cc)->core, offset, val)
+
+#define bcma_cc_mask32(cc, offset, mask) \
+	bcma_cc_write32(cc, offset, bcma_cc_read32(cc, offset) & (mask))
+#define bcma_cc_set32(cc, offset, set) \
+	bcma_cc_write32(cc, offset, bcma_cc_read32(cc, offset) | (set))
+#define bcma_cc_maskset32(cc, offset, mask, set) \
+	bcma_cc_write32(cc, offset, (bcma_cc_read32(cc, offset) & (mask)) | (set))
+
+extern void bcma_core_chipcommon_init(struct bcma_drv_cc *cc);
+
+extern void bcma_chipco_suspend(struct bcma_drv_cc *cc);
+extern void bcma_chipco_resume(struct bcma_drv_cc *cc);
+
+extern void bcma_chipco_watchdog_timer_set(struct bcma_drv_cc *cc,
+					  u32 ticks);
+
+void bcma_chipco_irq_mask(struct bcma_drv_cc *cc, u32 mask, u32 value);
+
+u32 bcma_chipco_irq_status(struct bcma_drv_cc *cc, u32 mask);
+
+/* Chipcommon GPIO pin access. */
+u32 bcma_chipco_gpio_in(struct bcma_drv_cc *cc, u32 mask);
+u32 bcma_chipco_gpio_out(struct bcma_drv_cc *cc, u32 mask, u32 value);
+u32 bcma_chipco_gpio_outen(struct bcma_drv_cc *cc, u32 mask, u32 value);
+u32 bcma_chipco_gpio_control(struct bcma_drv_cc *cc, u32 mask, u32 value);
+u32 bcma_chipco_gpio_intmask(struct bcma_drv_cc *cc, u32 mask, u32 value);
+u32 bcma_chipco_gpio_polarity(struct bcma_drv_cc *cc, u32 mask, u32 value);
+
+/* PMU support */
+extern void bcma_pmu_init(struct bcma_drv_cc *cc);
+
+#endif /* LINUX_BCMA_DRIVER_CC_H_ */
diff --git a/include/linux/bcma/bcma_driver_pci.h b/include/linux/bcma/bcma_driver_pci.h
new file mode 100644
index 0000000..b7e191c
--- /dev/null
+++ b/include/linux/bcma/bcma_driver_pci.h
@@ -0,0 +1,89 @@
+#ifndef LINUX_BCMA_DRIVER_PCI_H_
+#define LINUX_BCMA_DRIVER_PCI_H_
+
+#include <linux/types.h>
+
+struct pci_dev;
+
+/** PCI core registers. **/
+#define BCMA_CORE_PCI_CTL			0x0000	/* PCI Control */
+#define  BCMA_CORE_PCI_CTL_RST_OE		0x00000001 /* PCI_RESET Output Enable */
+#define  BCMA_CORE_PCI_CTL_RST			0x00000002 /* PCI_RESET driven out to pin */
+#define  BCMA_CORE_PCI_CTL_CLK_OE		0x00000004 /* Clock gate Output Enable */
+#define  BCMA_CORE_PCI_CTL_CLK			0x00000008 /* Gate for clock driven out to pin */
+#define BCMA_CORE_PCI_ARBCTL			0x0010	/* PCI Arbiter Control */
+#define  BCMA_CORE_PCI_ARBCTL_INTERN		0x00000001 /* Use internal arbiter */
+#define  BCMA_CORE_PCI_ARBCTL_EXTERN		0x00000002 /* Use external arbiter */
+#define  BCMA_CORE_PCI_ARBCTL_PARKID		0x00000006 /* Mask, selects which agent is parked on an idle bus */
+#define   BCMA_CORE_PCI_ARBCTL_PARKID_LAST	0x00000000 /* Last requestor */
+#define   BCMA_CORE_PCI_ARBCTL_PARKID_4710	0x00000002 /* 4710 */
+#define   BCMA_CORE_PCI_ARBCTL_PARKID_EXT0	0x00000004 /* External requestor 0 */
+#define   BCMA_CORE_PCI_ARBCTL_PARKID_EXT1	0x00000006 /* External requestor 1 */
+#define BCMA_CORE_PCI_ISTAT			0x0020	/* Interrupt status */
+#define  BCMA_CORE_PCI_ISTAT_INTA		0x00000001 /* PCI INTA# */
+#define  BCMA_CORE_PCI_ISTAT_INTB		0x00000002 /* PCI INTB# */
+#define  BCMA_CORE_PCI_ISTAT_SERR		0x00000004 /* PCI SERR# (write to clear) */
+#define  BCMA_CORE_PCI_ISTAT_PERR		0x00000008 /* PCI PERR# (write to clear) */
+#define  BCMA_CORE_PCI_ISTAT_PME		0x00000010 /* PCI PME# */
+#define BCMA_CORE_PCI_IMASK			0x0024	/* Interrupt mask */
+#define  BCMA_CORE_PCI_IMASK_INTA		0x00000001 /* PCI INTA# */
+#define  BCMA_CORE_PCI_IMASK_INTB		0x00000002 /* PCI INTB# */
+#define  BCMA_CORE_PCI_IMASK_SERR		0x00000004 /* PCI SERR# */
+#define  BCMA_CORE_PCI_IMASK_PERR		0x00000008 /* PCI PERR# */
+#define  BCMA_CORE_PCI_IMASK_PME		0x00000010 /* PCI PME# */
+#define BCMA_CORE_PCI_MBOX			0x0028	/* Backplane to PCI Mailbox */
+#define  BCMA_CORE_PCI_MBOX_F0_0		0x00000100 /* PCI function 0, INT 0 */
+#define  BCMA_CORE_PCI_MBOX_F0_1		0x00000200 /* PCI function 0, INT 1 */
+#define  BCMA_CORE_PCI_MBOX_F1_0		0x00000400 /* PCI function 1, INT 0 */
+#define  BCMA_CORE_PCI_MBOX_F1_1		0x00000800 /* PCI function 1, INT 1 */
+#define  BCMA_CORE_PCI_MBOX_F2_0		0x00001000 /* PCI function 2, INT 0 */
+#define  BCMA_CORE_PCI_MBOX_F2_1		0x00002000 /* PCI function 2, INT 1 */
+#define  BCMA_CORE_PCI_MBOX_F3_0		0x00004000 /* PCI function 3, INT 0 */
+#define  BCMA_CORE_PCI_MBOX_F3_1		0x00008000 /* PCI function 3, INT 1 */
+#define BCMA_CORE_PCI_BCAST_ADDR		0x0050	/* Backplane Broadcast Address */
+#define  BCMA_CORE_PCI_BCAST_ADDR_MASK		0x000000FF
+#define BCMA_CORE_PCI_BCAST_DATA		0x0054	/* Backplane Broadcast Data */
+#define BCMA_CORE_PCI_GPIO_IN			0x0060	/* rev >= 2 only */
+#define BCMA_CORE_PCI_GPIO_OUT			0x0064	/* rev >= 2 only */
+#define BCMA_CORE_PCI_GPIO_ENABLE		0x0068	/* rev >= 2 only */
+#define BCMA_CORE_PCI_GPIO_CTL			0x006C	/* rev >= 2 only */
+#define BCMA_CORE_PCI_SBTOPCI0			0x0100	/* Backplane to PCI translation 0 (sbtopci0) */
+#define  BCMA_CORE_PCI_SBTOPCI0_MASK		0xFC000000
+#define BCMA_CORE_PCI_SBTOPCI1			0x0104	/* Backplane to PCI translation 1 (sbtopci1) */
+#define  BCMA_CORE_PCI_SBTOPCI1_MASK		0xFC000000
+#define BCMA_CORE_PCI_SBTOPCI2			0x0108	/* Backplane to PCI translation 2 (sbtopci2) */
+#define  BCMA_CORE_PCI_SBTOPCI2_MASK		0xC0000000
+#define BCMA_CORE_PCI_PCICFG0			0x0400	/* PCI config space 0 (rev >= 8) */
+#define BCMA_CORE_PCI_PCICFG1			0x0500	/* PCI config space 1 (rev >= 8) */
+#define BCMA_CORE_PCI_PCICFG2			0x0600	/* PCI config space 2 (rev >= 8) */
+#define BCMA_CORE_PCI_PCICFG3			0x0700	/* PCI config space 3 (rev >= 8) */
+#define BCMA_CORE_PCI_SPROM(wordoffset)		(0x0800 + ((wordoffset) * 2)) /* SPROM shadow area (72 bytes) */
+
+/* SBtoPCIx */
+#define BCMA_CORE_PCI_SBTOPCI_MEM		0x00000000
+#define BCMA_CORE_PCI_SBTOPCI_IO		0x00000001
+#define BCMA_CORE_PCI_SBTOPCI_CFG0		0x00000002
+#define BCMA_CORE_PCI_SBTOPCI_CFG1		0x00000003
+#define BCMA_CORE_PCI_SBTOPCI_PREF		0x00000004 /* Prefetch enable */
+#define BCMA_CORE_PCI_SBTOPCI_BURST		0x00000008 /* Burst enable */
+#define BCMA_CORE_PCI_SBTOPCI_MRM		0x00000020 /* Memory Read Multiple */
+#define BCMA_CORE_PCI_SBTOPCI_RC		0x00000030 /* Read Command mask (rev >= 11) */
+#define  BCMA_CORE_PCI_SBTOPCI_RC_READ		0x00000000 /* Memory read */
+#define  BCMA_CORE_PCI_SBTOPCI_RC_READL		0x00000010 /* Memory read line */
+#define  BCMA_CORE_PCI_SBTOPCI_RC_READM		0x00000020 /* Memory read multiple */
+
+/* PCIcore specific boardflags */
+#define BCMA_CORE_PCI_BFL_NOPCI			0x00000400 /* Board leaves PCI floating */
+
+struct bcma_drv_pci {
+	struct bcma_device *core;
+	u8 setup_done:1;
+};
+
+/* Register access */
+#define pcicore_read32(pc, offset)		bcma_read32((pc)->core, offset)
+#define pcicore_write32(pc, offset, val)	bcma_write32((pc)->core, offset, val)
+
+extern void bcma_core_pci_init(struct bcma_drv_pci *pc);
+
+#endif /* LINUX_BCMA_DRIVER_PCI_H_ */
diff --git a/include/linux/bcma/bcma_regs.h b/include/linux/bcma/bcma_regs.h
new file mode 100644
index 0000000..f82d88a
--- /dev/null
+++ b/include/linux/bcma/bcma_regs.h
@@ -0,0 +1,34 @@
+#ifndef LINUX_BCMA_REGS_H_
+#define LINUX_BCMA_REGS_H_
+
+/* Agent registers (common for every core) */
+#define BCMA_IOCTL			0x0408
+#define  BCMA_IOCTL_CLK			0x0001
+#define  BCMA_IOCTL_FGC			0x0002
+#define  BCMA_IOCTL_CORE_BITS		0x3FFC
+#define  BCMA_IOCTL_PME_EN		0x4000
+#define  BCMA_IOCTL_BIST_EN		0x8000
+#define BCMA_RESET_CTL			0x0800
+#define  BCMA_RESET_CTL_RESET		0x0001
+
+/* BCMA PCI config space registers. */
+#define BCMA_PCI_PMCSR			0x44
+#define  BCMA_PCI_PE			0x100
+#define BCMA_PCI_BAR0_WIN		0x80	/* Backplane address space 0 */
+#define BCMA_PCI_BAR1_WIN		0x84	/* Backplane address space 1 */
+#define BCMA_PCI_SPROMCTL		0x88	/* SPROM control */
+#define  BCMA_PCI_SPROMCTL_WE		0x10	/* SPROM write enable */
+#define BCMA_PCI_BAR1_CONTROL		0x8c	/* Address space 1 burst control */
+#define BCMA_PCI_IRQS			0x90	/* PCI interrupts */
+#define BCMA_PCI_IRQMASK		0x94	/* PCI IRQ control and mask (pcirev >= 6 only) */
+#define BCMA_PCI_BACKPLANE_IRQS		0x98	/* Backplane Interrupts */
+#define BCMA_PCI_BAR0_WIN2		0xAC
+#define BCMA_PCI_GPIO_IN		0xB0	/* GPIO Input (pcirev >= 3 only) */
+#define BCMA_PCI_GPIO_OUT		0xB4	/* GPIO Output (pcirev >= 3 only) */
+#define BCMA_PCI_GPIO_OUT_ENABLE	0xB8	/* GPIO Output Enable/Disable (pcirev >= 3 only) */
+#define  BCMA_PCI_GPIO_SCS		0x10	/* PCI config space bit 4 for 4306c0 slow clock source */
+#define  BCMA_PCI_GPIO_HWRAD		0x20	/* PCI config space GPIO 13 for hw radio disable */
+#define  BCMA_PCI_GPIO_XTAL		0x40	/* PCI config space GPIO 14 for Xtal powerup */
+#define  BCMA_PCI_GPIO_PLL		0x80	/* PCI config space GPIO 15 for PLL powerdown */
+
+#endif /* LINUX_BCMA_REGS_H_ */
diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
index 48c007d..ae28e93 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -382,6 +382,23 @@ struct ssb_device_id {
 #define SSB_ANY_ID		0xFFFF
 #define SSB_ANY_REV		0xFF
 
+/* Broadcom's specific AMBA core, see drivers/bcma/ */
+struct bcma_device_id {
+	__u16	manuf;
+	__u16	id;
+	__u8	rev;
+	__u8	class;
+};
+#define BCMA_CORE(_manuf, _id, _rev, _class)  \
+	{ .manuf = _manuf, .id = _id, .rev = _rev, .class = _class, }
+#define BCMA_CORETABLE_END  \
+	{ 0, },
+
+#define BCMA_ANY_MANUF		0xFFFF
+#define BCMA_ANY_ID		0xFFFF
+#define BCMA_ANY_REV		0xFF
+#define BCMA_ANY_CLASS		0xFF
+
 struct virtio_device_id {
 	__u32 device;
 	__u32 vendor;
diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
index 88f3f07..e26e2fb 100644
--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -702,6 +702,24 @@ static int do_ssb_entry(const char *filename,
 	return 1;
 }
 
+/* Looks like: bcma:mNidNrevNclN. */
+static int do_bcma_entry(const char *filename,
+			 struct bcma_device_id *id, char *alias)
+{
+	id->manuf = TO_NATIVE(id->manuf);
+	id->id = TO_NATIVE(id->id);
+	id->rev = TO_NATIVE(id->rev);
+	id->class = TO_NATIVE(id->class);
+
+	strcpy(alias, "bcma:");
+	ADD(alias, "m", id->manuf != BCMA_ANY_MANUF, id->manuf);
+	ADD(alias, "id", id->id != BCMA_ANY_ID, id->id);
+	ADD(alias, "rev", id->rev != BCMA_ANY_REV, id->rev);
+	ADD(alias, "cl", id->class != BCMA_ANY_CLASS, id->class);
+	add_wildcard(alias);
+	return 1;
+}
+
 /* Looks like: virtio:dNvN */
 static int do_virtio_entry(const char *filename, struct virtio_device_id *id,
 			   char *alias)
@@ -968,6 +986,10 @@ void handle_moddevtable(struct module *mod, struct elf_info *info,
 		do_table(symval, sym->st_size,
 			 sizeof(struct ssb_device_id), "ssb",
 			 do_ssb_entry, mod);
+	else if (sym_is(symname, "__mod_bcma_device_table"))
+		do_table(symval, sym->st_size,
+			 sizeof(struct bcma_device_id), "bcma",
+			 do_bcma_entry, mod);
 	else if (sym_is(symname, "__mod_virtio_device_table"))
 		do_table(symval, sym->st_size,
 			 sizeof(struct virtio_device_id), "virtio",
-- 
1.7.3.4

