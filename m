Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756204Ab1DKXTt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 19:19:49 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:63866 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753424Ab1DKXTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 19:19:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=XIoTVUlVO51CFwnH+VPgIKXVRIfus3P29tNJf8S/mCYQCN8H4buGpNZ1MOj858QZbr
         njpHUFK3iBofuxbc+ZONgI3eUOS7ecxuQve5GYC6fubKrEef/xqiL1OnNrTrG4ua8I4g
         0N6BVUTptgNApiCk6P620ZM+AOlILwUOHa/6Q=
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
        =?UTF-8?q?Michael=20B=C3=BCsch?= <mb@bu3sch.de>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        George Kashperko <george@znau.edu.ua>,
        Arend van Spriel <arend@broadcom.com>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <rmk@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Andy Botting <andy@andybotting.com>,
        linuxdriverproject <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH] axi: add AXI bus driver
Date: Tue, 12 Apr 2011 01:57:07 +0200
Message-Id: <1302566227-23788-1-git-send-email-zajec5@gmail.com>
X-Mailer: git-send-email 1.7.3.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 drivers/Kconfig                           |    2 +
 drivers/Makefile                          |    1 +
 drivers/axi/Kconfig                       |   33 +++
 drivers/axi/Makefile                      |    7 +
 drivers/axi/TODO                          |    3 +
 drivers/axi/axi_pci_bridge.c              |   33 +++
 drivers/axi/axi_private.h                 |   37 +++
 drivers/axi/core.c                        |   52 ++++
 drivers/axi/driver_chipcommon.c           |   87 +++++++
 drivers/axi/driver_chipcommon_pmu.c       |  134 ++++++++++
 drivers/axi/driver_pci.c                  |  163 ++++++++++++
 drivers/axi/host_pci.c                    |  175 +++++++++++++
 drivers/axi/main.c                        |  253 +++++++++++++++++++
 drivers/axi/scan.c                        |  391 +++++++++++++++++++++++++++++
 drivers/axi/scan.h                        |   56 ++++
 include/linux/axi/axi.h                   |  207 +++++++++++++++
 include/linux/axi/axi_driver_chipcommon.h |  308 +++++++++++++++++++++++
 include/linux/axi/axi_driver_pci.h        |   89 +++++++
 include/linux/axi/axi_regs.h              |   34 +++
 include/linux/mod_devicetable.h           |   17 ++
 scripts/mod/file2alias.c                  |   21 ++
 21 files changed, 2103 insertions(+), 0 deletions(-)
 create mode 100644 drivers/axi/Kconfig
 create mode 100644 drivers/axi/Makefile
 create mode 100644 drivers/axi/TODO
 create mode 100644 drivers/axi/axi_pci_bridge.c
 create mode 100644 drivers/axi/axi_private.h
 create mode 100644 drivers/axi/core.c
 create mode 100644 drivers/axi/driver_chipcommon.c
 create mode 100644 drivers/axi/driver_chipcommon_pmu.c
 create mode 100644 drivers/axi/driver_pci.c
 create mode 100644 drivers/axi/host_pci.c
 create mode 100644 drivers/axi/main.c
 create mode 100644 drivers/axi/scan.c
 create mode 100644 drivers/axi/scan.h
 create mode 100644 include/linux/axi/axi.h
 create mode 100644 include/linux/axi/axi_driver_chipcommon.h
 create mode 100644 include/linux/axi/axi_driver_pci.h
 create mode 100644 include/linux/axi/axi_regs.h

diff --git a/drivers/Kconfig b/drivers/Kconfig
index 177c7d1..1244e8c 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -68,6 +68,8 @@ source "drivers/watchdog/Kconfig"
 
 source "drivers/ssb/Kconfig"
 
+source "drivers/axi/Kconfig"
+
 source "drivers/mfd/Kconfig"
 
 source "drivers/regulator/Kconfig"
diff --git a/drivers/Makefile b/drivers/Makefile
index 3f135b6..6e1979b 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -110,6 +110,7 @@ obj-$(CONFIG_HID)		+= hid/
 obj-$(CONFIG_PPC_PS3)		+= ps3/
 obj-$(CONFIG_OF)		+= of/
 obj-$(CONFIG_SSB)		+= ssb/
+obj-$(CONFIG_AXI)		+= axi/
 obj-$(CONFIG_VHOST_NET)		+= vhost/
 obj-$(CONFIG_VLYNQ)		+= vlynq/
 obj-$(CONFIG_STAGING)		+= staging/
diff --git a/drivers/axi/Kconfig b/drivers/axi/Kconfig
new file mode 100644
index 0000000..6221af0
--- /dev/null
+++ b/drivers/axi/Kconfig
@@ -0,0 +1,33 @@
+config AXI_POSSIBLE
+	bool
+	depends on HAS_IOMEM && HAS_DMA
+	default y
+
+menu "AMBA AXI"
+	depends on AXI_POSSIBLE
+
+config AXI
+	tristate "AXI support"
+	depends on AXI_POSSIBLE
+	help
+	  Bus driver for one of the Advanced Microcontroller Bus Architecture
+	  interfaces: Advanced eXtensible Interface.
+
+config AXI_HOST_PCI_POSSIBLE
+	bool
+	depends on AXI && PCI = y
+	default y
+
+config AXI_HOST_PCI
+	bool "Support for AXI on PCI-host bus"
+	depends on AXI_HOST_PCI_POSSIBLE
+
+config AXI_DEBUG
+	bool "AXI debugging"
+	depends on AXI
+	help
+	  This turns on additional debugging messages.
+
+	  If unsure, say N
+
+endmenu
diff --git a/drivers/axi/Makefile b/drivers/axi/Makefile
new file mode 100644
index 0000000..5e1628d
--- /dev/null
+++ b/drivers/axi/Makefile
@@ -0,0 +1,7 @@
+axi-y					+= main.o scan.o core.o
+axi-y					+= driver_chipcommon.o driver_chipcommon_pmu.o
+axi-y					+= driver_pci.o
+axi-$(CONFIG_AXI_HOST_PCI)		+= host_pci.o axi_pci_bridge.o
+obj-$(CONFIG_AXI)			+= axi.o
+
+ccflags-$(CONFIG_AXI_DEBUG)		:= -DDEBUG
\ No newline at end of file
diff --git a/drivers/axi/TODO b/drivers/axi/TODO
new file mode 100644
index 0000000..5190336
--- /dev/null
+++ b/drivers/axi/TODO
@@ -0,0 +1,3 @@
+- Interrupts
+- Defines for PCI core driver
+- Convert axi_bus->cores into linked list
diff --git a/drivers/axi/axi_pci_bridge.c b/drivers/axi/axi_pci_bridge.c
new file mode 100644
index 0000000..17e882c
--- /dev/null
+++ b/drivers/axi/axi_pci_bridge.c
@@ -0,0 +1,33 @@
+/*
+ * AXI PCI bridge module
+ *
+ * Licensed under the GNU/GPL. See COPYING for details.
+ */
+
+#include "axi_private.h"
+
+#include <linux/axi/axi.h>
+#include <linux/pci.h>
+
+static DEFINE_PCI_DEVICE_TABLE(axi_pci_bridge_tbl) = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4331) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4353) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4727) },
+	{ 0, },
+};
+MODULE_DEVICE_TABLE(pci, axi_pci_bridge_tbl);
+
+static struct pci_driver axi_pci_bridge_driver = {
+	.name = "axi-pci-bridge",
+	.id_table = axi_pci_bridge_tbl,
+};
+
+int __init axi_pci_bridge_init(void)
+{
+	return axi_host_pci_register(&axi_pci_bridge_driver);
+}
+
+void __exit axi_pci_bridge_exit(void)
+{
+	axi_host_pci_unregister(&axi_pci_bridge_driver);
+}
diff --git a/drivers/axi/axi_private.h b/drivers/axi/axi_private.h
new file mode 100644
index 0000000..756efb6
--- /dev/null
+++ b/drivers/axi/axi_private.h
@@ -0,0 +1,37 @@
+#ifndef LINUX_AXI_PRIVATE_H_
+#define LINUX_AXI_PRIVATE_H_
+
+#ifndef pr_fmt
+#define pr_fmt(fmt)		KBUILD_MODNAME ": " fmt
+#endif
+
+#include <linux/axi/axi.h>
+
+#define AXI_ADDR_BASE		0x18000000
+#define AXI_WRAP_BASE		0x18100000
+
+#define AXI_CORE_SIZE		0x1000
+
+struct axi_bus;
+
+/* main.c */
+extern int axi_bus_register(struct axi_bus *bus);
+extern void axi_bus_unregister(struct axi_bus *bus);
+
+/* scan.c */
+int axi_bus_scan(struct axi_bus *bus);
+
+#ifdef CONFIG_AXI_HOST_PCI
+/* b43_pci_ai_bridge.c */
+extern int __init axi_pci_bridge_init(void);
+extern void __exit axi_pci_bridge_exit(void);
+
+/* host_pci.c */
+extern int axi_host_pci_register(struct pci_driver *driver);
+static inline void axi_host_pci_unregister(struct pci_driver *driver)
+{
+	pci_unregister_driver(driver);
+}
+#endif /* CONFIG_AXI_HOST_PCI */
+
+#endif
diff --git a/drivers/axi/core.c b/drivers/axi/core.c
new file mode 100644
index 0000000..1d7f3a9
--- /dev/null
+++ b/drivers/axi/core.c
@@ -0,0 +1,52 @@
+/*
+ * AMBA AXI
+ * Core ops
+ *
+ * Licensed under the GNU/GPL. See COPYING for details.
+ */
+
+#include "axi_private.h"
+#include <linux/axi/axi.h>
+
+
+
+bool axi_core_is_enabled(struct axi_device *core)
+{
+	if ((axi_aread32(core, AXI_IOCTL) & (AXI_IOCTL_CLK | AXI_IOCTL_FGC)) != AXI_IOCTL_CLK)
+		return false;
+	if (axi_aread32(core, AXI_RESET_CTL) & AXI_RESET_CTL_RESET)
+		return false;
+	return true;
+}
+EXPORT_SYMBOL(axi_core_is_enabled);
+
+static void axi_core_disable(struct axi_device *core, u32 flags)
+{
+	if (axi_aread32(core, AXI_RESET_CTL) & AXI_RESET_CTL_RESET)
+		return;
+
+	axi_awrite32(core, AXI_IOCTL, flags);
+	axi_aread32(core, AXI_IOCTL);
+	udelay(10);
+
+	axi_awrite32(core, AXI_RESET_CTL, AXI_RESET_CTL_RESET);
+	udelay(1);
+}
+
+int axi_core_enable(struct axi_device *core, u32 flags)
+{
+	axi_core_disable(core, flags);
+
+	axi_awrite32(core, AXI_IOCTL, (AXI_IOCTL_CLK | AXI_IOCTL_FGC | flags));
+	axi_aread32(core, AXI_IOCTL);
+
+	axi_awrite32(core, AXI_RESET_CTL, 0);
+	udelay(1);
+
+	axi_awrite32(core, AXI_IOCTL, (AXI_IOCTL_CLK | flags));
+	axi_aread32(core, AXI_IOCTL);
+	udelay(1);
+
+	return 0;
+}
+EXPORT_SYMBOL(axi_core_enable);
diff --git a/drivers/axi/driver_chipcommon.c b/drivers/axi/driver_chipcommon.c
new file mode 100644
index 0000000..b3087df
--- /dev/null
+++ b/drivers/axi/driver_chipcommon.c
@@ -0,0 +1,87 @@
+/*
+ * AMBA AXI
+ * ChipCommon core driver
+ *
+ * Copyright 2005, Broadcom Corporation
+ * Copyright 2006, 2007, Michael Buesch <mb@bu3sch.de>
+ *
+ * Licensed under the GNU/GPL. See COPYING for details.
+ */
+
+#include "axi_private.h"
+#include <linux/axi/axi.h>
+
+static inline u32 axi_cc_write32_masked(struct axi_drv_cc *cc, u16 offset,
+					u32 mask, u32 value)
+{
+	value &= mask;
+	value |= axi_cc_read32(cc, offset) & ~mask;
+	axi_cc_write32(cc, offset, value);
+
+	return value;
+}
+
+void axi_core_chipcommon_init(struct axi_drv_cc *cc)
+{
+	if (cc->core->id.rev >= 11)
+		cc->status = axi_cc_read32(cc, AXI_CC_CHIPSTAT);
+	cc->capabilities = axi_cc_read32(cc, AXI_CC_CAP);
+	if (cc->core->id.rev >= 35)
+		cc->capabilities_ext = axi_cc_read32(cc, AXI_CC_CAP_EXT);
+
+	axi_cc_write32(cc, 0x58, 0);
+	axi_cc_write32(cc, 0x5C, 0);
+
+	if (cc->capabilities & AXI_CC_CAP_PMU)
+		axi_pmu_init(cc);
+	if (cc->capabilities & AXI_CC_CAP_PCTL)
+		pr_err("Power control not implemented!\n");
+}
+
+/* Set chip watchdog reset timer to fire in 'ticks' backplane cycles */
+void axi_chipco_watchdog_timer_set(struct axi_drv_cc *cc, u32 ticks)
+{
+	/* instant NMI */
+	axi_cc_write32(cc, AXI_CC_WATCHDOG, ticks);
+}
+
+void axi_chipco_irq_mask(struct axi_drv_cc *cc, u32 mask, u32 value)
+{
+	axi_cc_write32_masked(cc, AXI_CC_IRQMASK, mask, value);
+}
+
+u32 axi_chipco_irq_status(struct axi_drv_cc *cc, u32 mask)
+{
+	return axi_cc_read32(cc, AXI_CC_IRQSTAT) & mask;
+}
+
+u32 axi_chipco_gpio_in(struct axi_drv_cc *cc, u32 mask)
+{
+	return axi_cc_read32(cc, AXI_CC_GPIOIN) & mask;
+}
+
+u32 axi_chipco_gpio_out(struct axi_drv_cc *cc, u32 mask, u32 value)
+{
+	return axi_cc_write32_masked(cc, AXI_CC_GPIOOUT, mask, value);
+}
+
+u32 axi_chipco_gpio_outen(struct axi_drv_cc *cc, u32 mask, u32 value)
+{
+	return axi_cc_write32_masked(cc, AXI_CC_GPIOOUTEN, mask, value);
+}
+
+u32 xaxi_chipco_gpio_control(struct axi_drv_cc *cc, u32 mask, u32 value)
+{
+	return axi_cc_write32_masked(cc, AXI_CC_GPIOCTL, mask, value);
+}
+EXPORT_SYMBOL(xaxi_chipco_gpio_control);
+
+u32 axi_chipco_gpio_intmask(struct axi_drv_cc *cc, u32 mask, u32 value)
+{
+	return axi_cc_write32_masked(cc, AXI_CC_GPIOIRQ, mask, value);
+}
+
+u32 axi_chipco_gpio_polarity(struct axi_drv_cc *cc, u32 mask, u32 value)
+{
+	return axi_cc_write32_masked(cc, AXI_CC_GPIOPOL, mask, value);
+}
diff --git a/drivers/axi/driver_chipcommon_pmu.c b/drivers/axi/driver_chipcommon_pmu.c
new file mode 100644
index 0000000..b57a9d0
--- /dev/null
+++ b/drivers/axi/driver_chipcommon_pmu.c
@@ -0,0 +1,134 @@
+/*
+ * AMBA AXI
+ * ChipCommon Power Management Unit driver
+ *
+ * Copyright 2009, Michael Buesch <mb@bu3sch.de>
+ * Copyright 2007, Broadcom Corporation
+ *
+ * Licensed under the GNU/GPL. See COPYING for details.
+ */
+
+#include "axi_private.h"
+#include <linux/axi/axi.h>
+
+static void axi_chipco_chipctl_maskset(struct axi_drv_cc *cc,
+					 u32 offset, u32 mask, u32 set)
+{
+	u32 value;
+
+	axi_cc_read32(cc, AXI_CC_CHIPCTL_ADDR);
+	axi_cc_write32(cc, AXI_CC_CHIPCTL_ADDR, offset);
+	axi_cc_read32(cc, AXI_CC_CHIPCTL_ADDR);
+	value = axi_cc_read32(cc, AXI_CC_CHIPCTL_DATA);
+	value &= mask;
+	value |= set;
+	axi_cc_write32(cc, AXI_CC_CHIPCTL_DATA, value);
+	axi_cc_read32(cc, AXI_CC_CHIPCTL_DATA);
+}
+
+static void axi_pmu_pll_init(struct axi_drv_cc *cc)
+{
+	struct axi_bus *bus = cc->core->bus;
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
+static void axi_pmu_resources_init(struct axi_drv_cc *cc)
+{
+	struct axi_bus *bus = cc->core->bus;
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
+		axi_cc_write32(cc, AXI_CC_PMU_MINRES_MSK, min_msk);
+	if (max_msk)
+		axi_cc_write32(cc, AXI_CC_PMU_MAXRES_MSK, max_msk);
+}
+
+void axi_pmu_swreg_init(struct axi_drv_cc *cc)
+{
+	struct axi_bus *bus = cc->core->bus;
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
+void axi_pmu_workarounds(struct axi_drv_cc *cc)
+{
+	struct axi_bus *bus = cc->core->bus;
+
+	switch (bus->chipinfo.id) {
+	case 0x4313:
+		axi_chipco_chipctl_maskset(cc, 0, ~0, 0x7);
+		break;
+	case 0x4331:
+		pr_err("Enabling Ext PA lines not implemented\n");
+		break;
+	case 43224:
+		if (bus->chipinfo.rev == 0) {
+			pr_err("Workarounds for 43224 rev 0 not fully "
+				"implemented\n");
+			axi_chipco_chipctl_maskset(cc, 0, ~0, 0xF0);
+		} else {
+			axi_chipco_chipctl_maskset(cc, 0, ~0, 0xF0);
+		}
+		break;
+	default:
+		pr_err("Workarounds unknown for device 0x%04X\n",
+			bus->chipinfo.id);
+	}
+}
+
+void axi_pmu_init(struct axi_drv_cc *cc)
+{
+	u32 pmucap;
+
+	pmucap = axi_cc_read32(cc, AXI_CC_PMU_CAP);
+	cc->pmu.rev = (pmucap & AXI_CC_PMU_CAP_REVISION);
+
+	pr_debug("Found rev %u PMU (capabilities 0x%08X)\n", cc->pmu.rev,
+		 pmucap);
+
+	if (cc->pmu.rev == 1)
+		axi_cc_mask32(cc, AXI_CC_PMU_CTL,
+			      ~AXI_CC_PMU_CTL_NOILPONW);
+	else
+		axi_cc_set32(cc, AXI_CC_PMU_CTL,
+			     AXI_CC_PMU_CTL_NOILPONW);
+
+	if (cc->core->id.id == 0x4329 && cc->core->id.rev == 2)
+		pr_err("Fix for 4329b0 bad LPOM state not implemented!\n");
+
+	axi_pmu_pll_init(cc);
+	axi_pmu_resources_init(cc);
+	axi_pmu_swreg_init(cc);
+	axi_pmu_workarounds(cc);
+}
diff --git a/drivers/axi/driver_pci.c b/drivers/axi/driver_pci.c
new file mode 100644
index 0000000..fc4ab25
--- /dev/null
+++ b/drivers/axi/driver_pci.c
@@ -0,0 +1,163 @@
+/*
+ * AMBA AXI
+ * PCI Core
+ *
+ * Copyright 2005, Broadcom Corporation
+ * Copyright 2006, 2007, Michael Buesch <mb@bu3sch.de>
+ *
+ * Licensed under the GNU/GPL. See COPYING for details.
+ */
+
+#include "axi_private.h"
+#include <linux/axi/axi.h>
+
+/**************************************************
+ * R/W ops.
+ **************************************************/
+
+static u32 axi_pcie_read(struct axi_drv_pci *pc, u32 address)
+{
+	pcicore_write32(pc, 0x130, address);
+	pcicore_read32(pc, 0x130);
+	return pcicore_read32(pc, 0x134);
+}
+
+#if 0
+static void axi_pcie_write(struct axi_drv_pci *pc, u32 address, u32 data)
+{
+	pcicore_write32(pc, 0x130, address);
+	pcicore_read32(pc, 0x130);
+	pcicore_write32(pc, 0x134, data);
+}
+#endif
+
+static void axi_pcie_mdio_set_phy(struct axi_drv_pci *pc, u8 phy)
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
+static u16 axi_pcie_mdio_read(struct axi_drv_pci *pc, u8 device, u8 address)
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
+		axi_pcie_mdio_set_phy(pc, device);
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
+static void axi_pcie_mdio_write(struct axi_drv_pci *pc, u8 device,
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
+		axi_pcie_mdio_set_phy(pc, device);
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
+static u8 axi_pcicore_polarity_workaround(struct axi_drv_pci *pc)
+{
+	return (axi_pcie_read(pc, 0x204) & 0x10) ? 0xC0 : 0x80;
+}
+
+static void axi_pcicore_serdes_workaround(struct axi_drv_pci *pc)
+{
+	const u8 serdes_pll_device = 0x1D;
+	const u8 serdes_rx_device = 0x1F;
+	u16 tmp;
+
+	axi_pcie_mdio_write(pc, serdes_rx_device, 1 /* Control */,
+			      axi_pcicore_polarity_workaround(pc));
+	tmp = axi_pcie_mdio_read(pc, serdes_pll_device, 1 /* Control */);
+	if (tmp & 0x4000)
+		axi_pcie_mdio_write(pc, serdes_pll_device, 1, tmp & ~0x4000);
+}
+
+/**************************************************
+ * Init.
+ **************************************************/
+
+void axi_core_pci_init(struct axi_drv_pci *pc)
+{
+	axi_pcicore_serdes_workaround(pc);
+}
diff --git a/drivers/axi/host_pci.c b/drivers/axi/host_pci.c
new file mode 100644
index 0000000..904ac2c
--- /dev/null
+++ b/drivers/axi/host_pci.c
@@ -0,0 +1,175 @@
+/*
+ * AMBA AXI
+ * PCI Host
+ *
+ * Licensed under the GNU/GPL. See COPYING for details.
+ */
+
+#include "axi_private.h"
+#include <linux/axi/axi.h>
+
+static void axi_host_pci_switch_core(struct axi_device *core)
+{
+	pci_write_config_dword(core->bus->host_pci, AXI_PCI_BAR0_WIN,
+			       core->addr);
+	pci_write_config_dword(core->bus->host_pci, AXI_PCI_BAR0_WIN2,
+			       core->wrap);
+	core->bus->mapped_core = core;
+	pr_debug("Switched to core: 0x%X\n", core->id.id);
+}
+
+static u8 axi_host_pci_read8(struct axi_device *core, u16 offset)
+{
+	if (unlikely(core->bus->mapped_core != core))
+		axi_host_pci_switch_core(core);
+	return ioread8(core->bus->mmio + offset);
+}
+
+static u16 axi_host_pci_read16(struct axi_device *core, u16 offset)
+{
+	if (unlikely(core->bus->mapped_core != core))
+		axi_host_pci_switch_core(core);
+	return ioread16(core->bus->mmio + offset);
+}
+
+static u32 axi_host_pci_read32(struct axi_device *core, u16 offset)
+{
+	if (unlikely(core->bus->mapped_core != core))
+		axi_host_pci_switch_core(core);
+	return ioread32(core->bus->mmio + offset);
+}
+
+static void axi_host_pci_write8(struct axi_device *core, u16 offset, u8 value)
+{
+	if (unlikely(core->bus->mapped_core != core))
+		axi_host_pci_switch_core(core);
+	iowrite8(value, core->bus->mmio + offset);
+}
+
+static void axi_host_pci_write16(struct axi_device *core, u16 offset, u16 value)
+{
+	if (unlikely(core->bus->mapped_core != core))
+		axi_host_pci_switch_core(core);
+	iowrite16(value, core->bus->mmio + offset);
+}
+
+static void axi_host_pci_write32(struct axi_device *core, u16 offset, u32 value)
+{
+	if (unlikely(core->bus->mapped_core != core))
+		axi_host_pci_switch_core(core);
+	iowrite32(value, core->bus->mmio + offset);
+}
+
+static u32 axi_host_pci_aread32(struct axi_device *core, u16 offset)
+{
+	if (unlikely(core->bus->mapped_core != core))
+		axi_host_pci_switch_core(core);
+	return ioread32(core->bus->mmio + (1 * AXI_CORE_SIZE) + offset);
+}
+
+static void axi_host_pci_awrite32(struct axi_device *core, u16 offset, u32 value)
+{
+	if (unlikely(core->bus->mapped_core != core))
+		axi_host_pci_switch_core(core);
+	iowrite32(value, core->bus->mmio + 0x1000 + offset);
+}
+
+const struct axi_host_ops axi_host_pci_ops = {
+	.read8		= axi_host_pci_read8,
+	.read16		= axi_host_pci_read16,
+	.read32		= axi_host_pci_read32,
+	.write8		= axi_host_pci_write8,
+	.write16	= axi_host_pci_write16,
+	.write32	= axi_host_pci_write32,
+	.aread32	= axi_host_pci_aread32,
+	.awrite32	= axi_host_pci_awrite32,
+};
+
+static int axi_host_pci_probe(struct pci_dev *dev,
+			     const struct pci_device_id *id)
+{
+	struct axi_bus *bus;
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
+	/* SSB needed additional powering up, do we have any AI PCI cards? */
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
+	bus->hosttype = AXI_HOSTTYPE_PCI;
+	bus->ops = &axi_host_pci_ops;
+
+	/* Register */
+	err = axi_bus_register(bus);
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
+static void axi_host_pci_remove(struct pci_dev *dev)
+{
+	struct axi_bus *bus = pci_get_drvdata(dev);
+
+	axi_bus_unregister(bus);
+	pci_iounmap(dev, bus->mmio);
+	pci_release_regions(dev);
+	pci_disable_device(dev);
+	kfree(bus);
+	pci_set_drvdata(dev, NULL);
+}
+
+int axi_host_pci_register(struct pci_driver *driver)
+{
+	driver->probe = axi_host_pci_probe;
+	driver->remove = axi_host_pci_remove;
+
+	return pci_register_driver(driver);
+}
+EXPORT_SYMBOL(axi_host_pci_register);
diff --git a/drivers/axi/main.c b/drivers/axi/main.c
new file mode 100644
index 0000000..a9904ae
--- /dev/null
+++ b/drivers/axi/main.c
@@ -0,0 +1,253 @@
+/*
+ * AMBA AXI
+ * Bus subsystem
+ *
+ * Licensed under the GNU/GPL. See COPYING for details.
+ */
+
+#include "axi_private.h"
+#include <linux/axi/axi.h>
+
+MODULE_DESCRIPTION("AMBA AXI driver");
+MODULE_LICENSE("GPL");
+
+static int axi_bus_match(struct device *dev, struct device_driver *drv);
+static int axi_device_probe(struct device *dev);
+static int axi_device_remove(struct device *dev);
+
+static ssize_t manuf_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct axi_device *core = container_of(dev, struct axi_device, dev);
+	return sprintf(buf, "0x%03X", core->id.manuf);
+}
+static ssize_t id_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct axi_device *core = container_of(dev, struct axi_device, dev);
+	return sprintf(buf, "0x%03X", core->id.id);
+}
+static ssize_t rev_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct axi_device *core = container_of(dev, struct axi_device, dev);
+	return sprintf(buf, "0x%02X", core->id.rev);
+}
+static ssize_t class_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct axi_device *core = container_of(dev, struct axi_device, dev);
+	return sprintf(buf, "0x%X", core->id.class);
+}
+static struct device_attribute axi_device_attrs[] = {
+	__ATTR_RO(manuf),
+	__ATTR_RO(id),
+	__ATTR_RO(rev),
+	__ATTR_RO(class),
+	__ATTR_NULL,
+};
+
+static struct bus_type axi_bus_type = {
+	.name		= "axi",
+	.match		= axi_bus_match,
+	.probe		= axi_device_probe,
+	.remove		= axi_device_remove,
+	.dev_attrs	= axi_device_attrs,
+};
+
+static struct axi_device *axi_find_core(struct axi_bus *bus, u16 coreid)
+{
+	u8 i;
+	for (i = 0; i < bus->nr_cores; i++) {
+		if (bus->cores[i].id.id == coreid)
+			return &bus->cores[i];
+	}
+	return NULL;
+}
+
+static void axi_release_core_dev(struct device *dev)
+{
+	/* Just silent lack-of-release warning for now.
+	 * 
+	 * Put kfree of struct axi_device here, after converting bus->cores to
+	 * to linked list.
+	 */
+}
+
+static int axi_register_cores(struct axi_bus *bus)
+{
+	struct axi_device *core;
+	int i, err, dev_id = 0;
+
+	for (i = 0; i < bus->nr_cores; i++) {
+		core = &(bus->cores[i]);
+
+		/* We support that cores ourself */
+		switch (core->id.id) {
+		case AXI_CORE_CHIPCOMMON:
+		case AXI_CORE_PCI:
+		case AXI_CORE_PCIE:
+			continue;
+		}
+
+		core->dev.release = axi_release_core_dev;
+		core->dev.bus = &axi_bus_type;
+		dev_set_name(&core->dev, "axi%d:%d", 0/*bus->busnumber*/, dev_id);
+
+		switch (bus->hosttype) {
+		case AXI_HOSTTYPE_PCI:
+			core->dev.parent = &bus->host_pci->dev;
+			break;
+		case AXI_HOSTTYPE_NONE:
+		case AXI_HOSTTYPE_SDIO:
+			break;
+		}
+
+		err = device_register(&core->dev);
+		if (err) {
+			pr_err("Could not register dev for core 0x%03X\n",
+				  core->id.id);
+			core->dev.release = NULL;
+			core->dev.bus = NULL;
+			core->dev.parent = NULL;
+			continue;
+		}
+		dev_id++;
+	}
+
+	return 0;
+}
+
+static void axi_unregister_cores(struct axi_bus *bus)
+{
+	struct axi_device *core;
+	int i;
+
+	for (i = 0; i < bus->nr_cores; i++) {
+		core = &(bus->cores[i]);
+		if (core->dev.bus)
+			device_unregister(&core->dev);
+	}
+}
+
+int axi_bus_register(struct axi_bus *bus)
+{
+	int err;
+	struct axi_device *core;
+
+	/* Scan for devices (cores) */
+	err = axi_bus_scan(bus);
+	if (err) {
+		pr_err("Failed to scan: %d\n", err);
+		return -1;
+	}
+
+	/* Init CC core */
+	core = axi_find_core(bus, AXI_CORE_CHIPCOMMON);
+	if (core) {
+		bus->drv_cc.core = core;
+		axi_core_chipcommon_init(&bus->drv_cc);
+	}
+
+	/* Init PCIE core */
+	core = axi_find_core(bus, AXI_CORE_PCIE);
+	if (core) {
+		bus->drv_pci.core = core;
+		axi_core_pci_init(&bus->drv_pci);
+	}
+
+	/* Register found cores */
+	axi_register_cores(bus);
+
+	pr_info("AXI registered\n");
+
+	return 0;
+}
+EXPORT_SYMBOL(axi_bus_register);
+
+void axi_bus_unregister(struct axi_bus *bus)
+{
+	axi_unregister_cores(bus);
+}
+EXPORT_SYMBOL(axi_bus_unregister);
+
+int __axi_driver_register(struct axi_driver *drv, struct module *owner)
+{
+	drv->drv.name = drv->name;
+	drv->drv.bus = &axi_bus_type;
+	drv->drv.owner = owner;
+
+	return driver_register(&drv->drv);
+}
+EXPORT_SYMBOL(__axi_driver_register);
+
+void axi_driver_unregister(struct axi_driver *drv)
+{
+	driver_unregister(&drv->drv);
+}
+EXPORT_SYMBOL(axi_driver_unregister);
+
+static int axi_bus_match(struct device *dev, struct device_driver *drv)
+{
+	struct axi_device *core = container_of(dev, struct axi_device, dev);
+	struct axi_driver *adrv = container_of(drv, struct axi_driver, drv);
+	const struct axi_device_id *cid = &core->id;
+	const struct axi_device_id *did;
+
+	for (did = adrv->id_table; did->manuf || did->id || did->rev; did++) {
+	    if ((did->manuf == cid->manuf || did->manuf == AXI_ANY_MANUF) &&
+		(did->id == cid->id || did->id == AXI_ANY_ID) &&
+		(did->rev == cid->rev || did->rev == AXI_ANY_REV ) &&
+		(did->class == cid->class || did->class == AXI_ANY_CLASS ))
+			return 1;
+	}
+	return 0;
+}
+
+static int axi_device_probe(struct device *dev)
+{
+	struct axi_device *core = container_of(dev, struct axi_device, dev);
+	struct axi_driver *adrv = container_of(dev->driver, struct axi_driver, drv);
+	int err = 0;
+
+	if (adrv->probe)
+		err = adrv->probe(core);
+
+	return err;
+}
+
+static int axi_device_remove(struct device *dev)
+{
+	struct axi_device *core = container_of(dev, struct axi_device, dev);
+	struct axi_driver *adrv = container_of(dev->driver, struct axi_driver, drv);
+
+	if (adrv->remove)
+		adrv->remove(core);
+
+	return 0;
+}
+
+static int __init axi_modinit(void)
+{
+	int err;
+
+	err = bus_register(&axi_bus_type);
+	if (err)
+		return err;
+
+#ifdef CONFIG_AXI_HOST_PCI
+	err = axi_pci_bridge_init();
+	if (err) {
+		pr_err("AXI PCI bridge initialization failed\n");
+		err = 0;
+	}
+#endif
+
+	return err;
+}
+fs_initcall(axi_modinit);
+
+static void __exit axi_modexit(void)
+{
+#ifdef CONFIG_AXI_HOST_PCI
+	axi_pci_bridge_exit();
+#endif
+	bus_unregister(&axi_bus_type);
+}
+module_exit(axi_modexit)
diff --git a/drivers/axi/scan.c b/drivers/axi/scan.c
new file mode 100644
index 0000000..dfba88d
--- /dev/null
+++ b/drivers/axi/scan.c
@@ -0,0 +1,391 @@
+/*
+ * AMBA AXI
+ * Bus scanning
+ *
+ * Licensed under the GNU/GPL. See COPYING for details.
+ */
+
+#include "scan.h"
+#include "axi_private.h"
+
+#include <linux/axi/axi.h>
+#include <linux/axi/axi_regs.h>
+#include <linux/pci.h>
+#include <linux/io.h>
+#include <linux/dma-mapping.h>
+#include <linux/slab.h>
+
+const char *axi_device_name(u16 coreid)
+{
+	switch (coreid) {
+	case AXI_CORE_OOB_ROUTER:
+		return "OOB Router";
+	case AXI_CORE_INVALID:
+		return "Invalid";
+	case AXI_CORE_CHIPCOMMON:
+		return "ChipCommon";
+	case AXI_CORE_ILINE20:
+		return "ILine 20";
+	case AXI_CORE_SRAM:
+		return "SRAM";
+	case AXI_CORE_SDRAM:
+		return "SDRAM";
+	case AXI_CORE_PCI:
+		return "PCI";
+	case AXI_CORE_MIPS:
+		return "MIPS";
+	case AXI_CORE_ETHERNET:
+		return "Fast Ethernet";
+	case AXI_CORE_V90:
+		return "V90";
+	case AXI_CORE_USB11_HOSTDEV:
+		return "USB 1.1 Hostdev";
+	case AXI_CORE_ADSL:
+		return "ADSL";
+	case AXI_CORE_ILINE100:
+		return "ILine 100";
+	case AXI_CORE_IPSEC:
+		return "IPSEC";
+	case AXI_CORE_UTOPIA:
+		return "UTOPIA";
+	case AXI_CORE_PCMCIA:
+		return "PCMCIA";
+	case AXI_CORE_INTERNAL_MEM:
+		return "Internal Memory";
+	case AXI_CORE_MEMC_SDRAM:
+		return "MEMC SDRAM";
+	case AXI_CORE_OFDM:
+		return "OFDM";
+	case AXI_CORE_EXTIF:
+		return "EXTIF";
+	case AXI_CORE_80211:
+		return "IEEE 802.11";
+	case AXI_CORE_PHY_A:
+		return "PHY A";
+	case AXI_CORE_PHY_B:
+		return "PHY B";
+	case AXI_CORE_PHY_G:
+		return "PHY G";
+	case AXI_CORE_MIPS_3302:
+		return "MIPS 3302";
+	case AXI_CORE_USB11_HOST:
+		return "USB 1.1 Host";
+	case AXI_CORE_USB11_DEV:
+		return "USB 1.1 Device";
+	case AXI_CORE_USB20_HOST:
+		return "USB 2.0 Host";
+	case AXI_CORE_USB20_DEV:
+		return "USB 2.0 Device";
+	case AXI_CORE_SDIO_HOST:
+		return "SDIO Host";
+	case AXI_CORE_ROBOSWITCH:
+		return "Roboswitch";
+	case AXI_CORE_PARA_ATA:
+		return "PATA";
+	case AXI_CORE_SATA_XORDMA:
+		return "SATA XOR-DMA";
+	case AXI_CORE_ETHERNET_GBIT:
+		return "GBit Ethernet";
+	case AXI_CORE_PCIE:
+		return "PCIe";
+	case AXI_CORE_PHY_N:
+		return "PHY N";
+	case AXI_CORE_SRAM_CTL:
+		return "SRAM Controller";
+	case AXI_CORE_MINI_MACPHY:
+		return "Mini MACPHY";
+	case AXI_CORE_ARM_1176:
+		return "ARM 1176";
+	case AXI_CORE_ARM_7TDMI:
+		return "ARM 7TDMI";
+	case AXI_CORE_PHY_LP:
+		return "PHY LP";
+	case AXI_CORE_PMU:
+		return "PMU";
+	case AXI_CORE_PHY_SSN:
+		return "PHY SSN";
+	case AXI_CORE_SDIO_DEV:
+		return "SDIO Device";
+	case AXI_CORE_ARM_CM3:
+		return "ARM CM3";
+	case AXI_CORE_PHY_HT:
+		return "PHY HT";
+	case AXI_CORE_MIPS_74K:
+		return "MIPS 74K";
+	case AXI_CORE_MAC_GBIT:
+		return "GBit MAC";
+	case AXI_CORE_DDR12_MEM_CTL:
+		return "DDR1/DDR2 Memory Controller";
+	case AXI_CORE_PCIE_RC:
+		return "PCIe Root Complex";
+	case AXI_CORE_OCP_OCP_BRIDGE:
+		return "OCP to OCP Bridge";
+	case AXI_CORE_SHARED_COMMON:
+		return "Common Shared";
+	case AXI_CORE_OCP_AHB_BRIDGE:
+		return "OCP to AHB Bridge";
+	case AXI_CORE_SPI_HOST:
+		return "SPI Host";
+	case AXI_CORE_I2S:
+		return "I2S";
+	case AXI_CORE_SDR_DDR1_MEM_CTL:
+		return "SDR/DDR1 Memory Controller";
+	case AXI_CORE_SHIM:
+		return "SHIM";
+	case AXI_CORE_DEFAULT:
+		return "Default";
+	}
+	return "UNKNOWN";
+}
+
+static u32 axi_scan_read32(struct axi_bus *bus, u8 current_coreidx,
+		       u16 offset)
+{
+	return readl(bus->mmio + offset);
+}
+
+static void axi_scan_switch_core(struct axi_bus *bus, u32 addr)
+{
+	if (bus->hosttype == AXI_HOSTTYPE_PCI)
+		pci_write_config_dword(bus->host_pci, AXI_PCI_BAR0_WIN,
+				       addr);
+}
+
+static u32 axi_erom_get_ent(struct axi_bus *bus, u32 **eromptr)
+{
+	u32 ent = readl(*eromptr);
+	(*eromptr)++;
+	return ent;
+}
+
+static void axi_erom_push_ent(u32 **eromptr)
+{
+	(*eromptr)--;
+}
+
+static s32 axi_erom_get_ci(struct axi_bus *bus, u32 **eromptr)
+{
+	u32 ent = axi_erom_get_ent(bus, eromptr);
+	if (!(ent & SCAN_ER_VALID))
+		return -1;
+	if ((ent & SCAN_ER_TAG) != SCAN_ER_TAG_CI)
+		return -2;
+	return ent;
+}
+
+static bool axi_erom_is_end(struct axi_bus *bus, u32 **eromptr)
+{
+	u32 ent = axi_erom_get_ent(bus, eromptr);
+	axi_erom_push_ent(eromptr);
+	return (ent == (SCAN_ER_TAG_END | SCAN_ER_VALID));
+}
+
+static bool axi_erom_is_bridge(struct axi_bus *bus, u32 **eromptr)
+{
+	u32 ent = axi_erom_get_ent(bus, eromptr);
+	axi_erom_push_ent(eromptr);
+	return (((ent & SCAN_ER_VALID)) &&
+	        ((ent & SCAN_ER_TAGX) == SCAN_ER_TAG_ADDR) &&
+	        ((ent & SCAN_ADDR_TYPE) == SCAN_ADDR_TYPE_BRIDGE));
+}
+
+static void axi_erom_skip_component(struct axi_bus *bus, u32 **eromptr)
+{
+	u32 ent;
+	while (1) {
+		ent = axi_erom_get_ent(bus, eromptr);
+		if ((ent & SCAN_ER_VALID) && ((ent & SCAN_ER_TAG) == SCAN_ER_TAG_CI))
+			break;
+		if (ent == (SCAN_ER_TAG_END | SCAN_ER_VALID))
+			break;
+	}
+	axi_erom_push_ent(eromptr);
+}
+
+static s32 axi_erom_get_mst_port(struct axi_bus *bus, u32 **eromptr)
+{
+	u32 ent = axi_erom_get_ent(bus, eromptr);
+	if (!(ent & SCAN_ER_VALID))
+		return -1;
+	if ((ent & SCAN_ER_TAG) != SCAN_ER_TAG_MP)
+		return -2;
+	return ent;
+}
+
+static s32 axi_erom_get_addr_desc(struct axi_bus *bus, u32 **eromptr,
+				  u32 type, u8 port)
+{
+	u32 addrl, addrh, sizel, sizeh = 0;
+	u32 size;
+
+	u32 ent = axi_erom_get_ent(bus, eromptr);
+	if ((!(ent & SCAN_ER_VALID)) ||
+	    ((ent & SCAN_ER_TAGX) != SCAN_ER_TAG_ADDR) ||
+	    ((ent & SCAN_ADDR_TYPE) != type) ||
+	    (((ent & SCAN_ADDR_PORT) >> SCAN_ADDR_PORT_SHIFT) != port)) {
+		axi_erom_push_ent(eromptr);
+		return -1;
+	}
+
+	addrl = ent & SCAN_ADDR_ADDR;
+	if (ent & SCAN_ADDR_AG32)
+		addrh = axi_erom_get_ent(bus, eromptr);
+	else
+		addrh = 0;
+
+	if ((ent & SCAN_ADDR_SZ) == SCAN_ADDR_SZ_SZD) {
+		size = axi_erom_get_ent(bus, eromptr);
+		sizel = size & SCAN_SIZE_SZ;
+		if (size & SCAN_SIZE_SG32)
+			sizeh = axi_erom_get_ent(bus, eromptr);
+	} else
+		sizel = SCAN_ADDR_SZ_BASE <<
+				((ent & SCAN_ADDR_SZ) >> SCAN_ADDR_SZ_SHIFT);
+
+	return addrl;
+}
+
+int axi_bus_scan(struct axi_bus *bus)
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
+	axi_scan_switch_core(bus, AXI_ADDR_BASE);
+
+	tmp = axi_scan_read32(bus, 0, AXI_CC_ID);
+	bus->chipinfo.id = (tmp & AXI_CC_ID_ID) >> AXI_CC_ID_ID_SHIFT;
+	bus->chipinfo.rev = (tmp & AXI_CC_ID_REV) >> AXI_CC_ID_REV_SHIFT;
+	bus->chipinfo.pkg = (tmp & AXI_CC_ID_PKG) >> AXI_CC_ID_PKG_SHIFT;
+
+	erombase = axi_scan_read32(bus, 0, AXI_CC_EROM);
+	eromptr = bus->mmio;
+	eromend = eromptr + AXI_CORE_SIZE / sizeof(u32);
+
+	axi_scan_switch_core(bus, erombase);
+
+	while (eromptr < eromend) {
+		struct axi_device core = { };
+		core.bus = bus;
+
+		/* get CIs */
+		cia = axi_erom_get_ci(bus, &eromptr);
+		if (cia < 0) {
+			axi_erom_push_ent(&eromptr);
+			if (axi_erom_is_end(bus, &eromptr))
+				break;
+			return -1;
+		}
+		cib = axi_erom_get_ci(bus, &eromptr);
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
+		if (((core.id.manuf == AXI_MANUF_ARM) &&
+		     (core.id.id == 0xFFF)) ||
+		    (ports[1] == 0)) {
+			axi_erom_skip_component(bus, &eromptr);
+			continue;
+		}
+
+		/* check if component is a core at all */
+		if (wrappers[0] + wrappers[1] == 0) {
+			/* we could save addrl of the router
+			if (cid == AXI_CORE_OOB_ROUTER)
+			 */
+			axi_erom_skip_component(bus, &eromptr);
+			continue;
+		}
+
+		if (axi_erom_is_bridge(bus, &eromptr)) {
+			axi_erom_skip_component(bus, &eromptr);
+			continue;
+		}
+
+		/* get & parse master ports */
+		for (i = 0; i < ports[0]; i++) {
+			u32 mst_port_d = axi_erom_get_mst_port(bus, &eromptr);
+			if (mst_port_d < 0)
+				return -3;
+		}
+
+		/* get & parse slave ports */
+		for (i = 0; i < ports[1]; i++) {
+			for (j = 0; ; j++) {
+				tmp = axi_erom_get_addr_desc(bus, &eromptr,
+					SCAN_ADDR_TYPE_SLAVE, i);
+				if (tmp < 0) {
+					/* not more entries for port _i_ */
+					/* axi_debug("erom: slave port %d "
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
+				tmp = axi_erom_get_addr_desc(bus, &eromptr,
+					SCAN_ADDR_TYPE_MWRAP, i);
+				if (tmp < 0) {
+					/* there are not more entries for port _i_ */
+					/* axi_dbg("erom: master wrapper %d "
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
+				tmp = axi_erom_get_addr_desc(bus, &eromptr,
+					SCAN_ADDR_TYPE_SWRAP, i + hack);
+				if (tmp < 0) {
+					/* there are not more entries for port _i_ */
+					/* axi_dbg("erom: master wrapper %d "
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
+			bus->nr_cores, axi_device_name(core.id.id),
+			core.id.manuf, core.id.id, core.id.rev,
+			core.id.class);
+
+		core.core_index = bus->nr_cores;
+		bus->cores[bus->nr_cores++] = core;
+	}
+
+	return 0;
+}
diff --git a/drivers/axi/scan.h b/drivers/axi/scan.h
new file mode 100644
index 0000000..91056f6
--- /dev/null
+++ b/drivers/axi/scan.h
@@ -0,0 +1,56 @@
+#ifndef AXI_SCAN_H_
+#define AXI_SCAN_H_
+
+#define AXI_ADDR_BASE		0x18000000
+#define AXI_WRAP_BASE		0x18100000
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
+#endif /* AXI_SCAN_H_ */
diff --git a/include/linux/axi/axi.h b/include/linux/axi/axi.h
new file mode 100644
index 0000000..35f9e52
--- /dev/null
+++ b/include/linux/axi/axi.h
@@ -0,0 +1,207 @@
+#ifndef LINUX_AXI_H_
+#define LINUX_AXI_H_
+
+#include <linux/pci.h>
+#include <linux/mod_devicetable.h>
+
+#include <linux/axi/axi_driver_chipcommon.h>
+#include <linux/axi/axi_driver_pci.h>
+
+#include "axi_regs.h"
+
+struct axi_device;
+struct axi_bus;
+
+enum axi_hosttype {
+	AXI_HOSTTYPE_NONE,
+	AXI_HOSTTYPE_PCI,
+	AXI_HOSTTYPE_SDIO,
+};
+
+struct axi_chipinfo {
+	u16 id;
+	u8 rev;
+	u8 pkg;
+};
+
+struct axi_host_ops {
+	u8 (*read8)(struct axi_device *core, u16 offset);
+	u16 (*read16)(struct axi_device *core, u16 offset);
+	u32 (*read32)(struct axi_device *core, u16 offset);
+	void (*write8)(struct axi_device *core, u16 offset, u8 value);
+	void (*write16)(struct axi_device *core, u16 offset, u16 value);
+	void (*write32)(struct axi_device *core, u16 offset, u32 value);
+	/* Agent ops */
+	u32 (*aread32)(struct axi_device *core, u16 offset);
+	void (*awrite32)(struct axi_device *core, u16 offset, u32 value);
+};
+
+#define AXI_MANUF_ARM			0x43B
+#define AXI_MANUF_MIPS			0x4A7
+#define AXI_MANUF_BCM			0x4BF
+
+/* Core-ID values. */
+#define AXI_CORE_OOB_ROUTER		0x367	/* Out of band */
+#define AXI_CORE_INVALID		0x700
+#define AXI_CORE_CHIPCOMMON		0x800
+#define AXI_CORE_ILINE20		0x801
+#define AXI_CORE_SRAM			0x802
+#define AXI_CORE_SDRAM			0x803
+#define AXI_CORE_PCI			0x804
+#define AXI_CORE_MIPS			0x805
+#define AXI_CORE_ETHERNET		0x806
+#define AXI_CORE_V90			0x807
+#define AXI_CORE_USB11_HOSTDEV		0x808
+#define AXI_CORE_ADSL			0x809
+#define AXI_CORE_ILINE100		0x80A
+#define AXI_CORE_IPSEC			0x80B
+#define AXI_CORE_UTOPIA			0x80C
+#define AXI_CORE_PCMCIA			0x80D
+#define AXI_CORE_INTERNAL_MEM		0x80E
+#define AXI_CORE_MEMC_SDRAM		0x80F
+#define AXI_CORE_OFDM			0x810
+#define AXI_CORE_EXTIF			0x811
+#define AXI_CORE_80211			0x812
+#define AXI_CORE_PHY_A			0x813
+#define AXI_CORE_PHY_B			0x814
+#define AXI_CORE_PHY_G			0x815
+#define AXI_CORE_MIPS_3302		0x816
+#define AXI_CORE_USB11_HOST		0x817
+#define AXI_CORE_USB11_DEV		0x818
+#define AXI_CORE_USB20_HOST		0x819
+#define AXI_CORE_USB20_DEV		0x81A
+#define AXI_CORE_SDIO_HOST		0x81B
+#define AXI_CORE_ROBOSWITCH		0x81C
+#define AXI_CORE_PARA_ATA		0x81D
+#define AXI_CORE_SATA_XORDMA		0x81E
+#define AXI_CORE_ETHERNET_GBIT		0x81F
+#define AXI_CORE_PCIE			0x820
+#define AXI_CORE_PHY_N			0x821
+#define AXI_CORE_SRAM_CTL		0x822
+#define AXI_CORE_MINI_MACPHY		0x823
+#define AXI_CORE_ARM_1176		0x824
+#define AXI_CORE_ARM_7TDMI		0x825
+#define AXI_CORE_PHY_LP			0x826
+#define AXI_CORE_PMU			0x827
+#define AXI_CORE_PHY_SSN		0x828
+#define AXI_CORE_SDIO_DEV		0x829
+#define AXI_CORE_ARM_CM3		0x82A
+#define AXI_CORE_PHY_HT			0x82B
+#define AXI_CORE_MIPS_74K		0x82C
+#define AXI_CORE_MAC_GBIT		0x82D
+#define AXI_CORE_DDR12_MEM_CTL		0x82E
+#define AXI_CORE_PCIE_RC		0x82F	/* PCIe Root Complex */
+#define AXI_CORE_OCP_OCP_BRIDGE		0x830
+#define AXI_CORE_SHARED_COMMON		0x831
+#define AXI_CORE_OCP_AHB_BRIDGE		0x832
+#define AXI_CORE_SPI_HOST		0x833
+#define AXI_CORE_I2S			0x834
+#define AXI_CORE_SDR_DDR1_MEM_CTL	0x835	/* SDR/DDR1 memory controller core */
+#define AXI_CORE_SHIM			0x837	/* SHIM component in ubus/6362 */
+#define AXI_CORE_DEFAULT		0xFFF
+
+#define AXI_MAX_NR_CORES		16
+
+struct axi_device {
+	struct device dev;
+
+	struct axi_bus *bus;
+	struct axi_device_id id;
+
+	u8 core_index;
+
+	u32 addr;
+	u32 wrap;
+
+	void *drvdata;
+};
+
+static inline void *axi_get_drvdata(struct axi_device *core)
+{
+	return core->drvdata;
+}
+static inline void axi_set_drvdata(struct axi_device *core, void *drvdata)
+{
+	core->drvdata = drvdata;
+}
+
+struct axi_driver {
+	const char *name;
+	const struct axi_device_id *id_table;
+
+	int (*probe)(struct axi_device *dev);
+	void (*remove)(struct axi_device *dev);
+	int (*suspend)(struct axi_device *dev, pm_message_t state);
+	int (*resume)(struct axi_device *dev);
+	void (*shutdown)(struct axi_device *dev);
+
+	struct device_driver drv;
+};
+extern int __axi_driver_register(struct axi_driver *drv, struct module *owner);
+static inline int axi_driver_register(struct axi_driver *drv)
+{
+	return __axi_driver_register(drv, THIS_MODULE);
+}
+extern void axi_driver_unregister(struct axi_driver *drv);
+
+struct axi_bus {
+	/* The MMIO area. */
+	void __iomem *mmio;
+
+	const struct axi_host_ops *ops;
+
+	enum axi_hosttype hosttype;
+	union {
+		/* Pointer to the PCI bus (only for AXI_HOSTTYPE_PCI) */
+		struct pci_dev *host_pci;
+		/* Pointer to the SDIO device (only for AXI_HOSTTYPE_SDIO) */
+		struct sdio_func *host_sdio;
+	};
+
+	struct axi_chipinfo chipinfo;
+
+	struct axi_device *mapped_core;
+	struct axi_device cores[AXI_MAX_NR_CORES];
+	u8 nr_cores;
+
+	struct axi_drv_cc drv_cc;
+	struct axi_drv_pci drv_pci;
+};
+
+extern inline u32 axi_read8(struct axi_device *core, u16 offset)
+{
+	return core->bus->ops->read8(core, offset);
+}
+extern inline u32 axi_read16(struct axi_device *core, u16 offset)
+{
+	return core->bus->ops->read16(core, offset);
+}
+extern inline u32 axi_read32(struct axi_device *core, u16 offset)
+{
+	return core->bus->ops->read32(core, offset);
+}
+extern inline void axi_write8(struct axi_device *core, u16 offset, u32 value)
+{
+	core->bus->ops->write8(core, offset, value);
+}
+extern inline void axi_write16(struct axi_device *core, u16 offset, u32 value)
+{
+	core->bus->ops->write16(core, offset, value);
+}
+extern inline void axi_write32(struct axi_device *core, u16 offset, u32 value)
+{
+	core->bus->ops->write32(core, offset, value);
+}
+extern inline u32 axi_aread32(struct axi_device *core, u16 offset)
+{
+	return core->bus->ops->aread32(core, offset);
+}
+extern inline void axi_awrite32(struct axi_device *core, u16 offset, u32 value)
+{
+	core->bus->ops->awrite32(core, offset, value);
+}
+
+extern bool axi_core_is_enabled(struct axi_device *core);
+extern int axi_core_enable(struct axi_device *core, u32 flags);
+
+#endif /* LINUX_AXI_H_ */
diff --git a/include/linux/axi/axi_driver_chipcommon.h b/include/linux/axi/axi_driver_chipcommon.h
new file mode 100644
index 0000000..b5faa60
--- /dev/null
+++ b/include/linux/axi/axi_driver_chipcommon.h
@@ -0,0 +1,308 @@
+#ifndef LINUX_AXI_DRIVER_CC_H_
+#define LINUX_AXI_DRIVER_CC_H_
+
+/* SonicsSiliconBackplane CHIPCOMMON core hardware definitions
+ *
+ * The chipcommon core provides chip identification, SB control,
+ * jtag, 0/1/2 uarts, clock frequency control, a watchdog interrupt timer,
+ * gpio interface, extbus, and support for serial and parallel flashes.
+ *
+ * Copyright 2005, Broadcom Corporation
+ * Copyright 2006, Michael Buesch <mb@bu3sch.de>
+ *
+ * Licensed under the GPL version 2. See COPYING for details.
+ */
+
+/** ChipCommon core registers. **/
+
+#define AXI_CC_ID			0x0000
+#define  AXI_CC_ID_ID			0x0000FFFF
+#define  AXI_CC_ID_ID_SHIFT		0
+#define  AXI_CC_ID_REV			0x000F0000
+#define  AXI_CC_ID_REV_SHIFT		16
+#define  AXI_CC_ID_PKG			0x00F00000
+#define  AXI_CC_ID_PKG_SHIFT		20
+#define  AXI_CC_ID_NRCORES		0x0F000000
+#define  AXI_CC_ID_NRCORES_SHIFT	24
+#define  AXI_CC_ID_TYPE			0xF0000000
+#define  AXI_CC_ID_TYPE_SHIFT		28
+#define AXI_CC_CAP	 		0x0004		/* Capabilities */
+#define  AXI_CC_CAP_NRUART		0x00000003	/* # of UARTs */
+#define  AXI_CC_CAP_MIPSEB		0x00000004	/* MIPS in BigEndian Mode */
+#define  AXI_CC_CAP_UARTCLK		0x00000018	/* UART clock select */
+#define   AXI_CC_CAP_UARTCLK_INT	0x00000008	/* UARTs are driven by internal divided clock */
+#define  AXI_CC_CAP_UARTGPIO		0x00000020	/* UARTs on GPIO 15-12 */
+#define  AXI_CC_CAP_EXTBUS		0x000000C0	/* External buses present */
+#define  AXI_CC_CAP_FLASHT		0x00000700	/* Flash Type */
+#define   AXI_CC_FLASHT_NONE		0x00000000	/* No flash */
+#define   AXI_CC_FLASHT_STSER		0x00000100	/* ST serial flash */
+#define   AXI_CC_FLASHT_ATSER		0x00000200	/* Atmel serial flash */
+#define	  AXI_CC_FLASHT_PARA		0x00000700	/* Parallel flash */
+#define  AXI_CC_CAP_PLLT		0x00038000	/* PLL Type */
+#define   AXI_PLLTYPE_NONE		0x00000000
+#define   AXI_PLLTYPE_1			0x00010000	/* 48Mhz base, 3 dividers */
+#define   AXI_PLLTYPE_2			0x00020000	/* 48Mhz, 4 dividers */
+#define   AXI_PLLTYPE_3			0x00030000	/* 25Mhz, 2 dividers */
+#define   AXI_PLLTYPE_4			0x00008000	/* 48Mhz, 4 dividers */
+#define   AXI_PLLTYPE_5			0x00018000	/* 25Mhz, 4 dividers */
+#define   AXI_PLLTYPE_6			0x00028000	/* 100/200 or 120/240 only */
+#define   AXI_PLLTYPE_7			0x00038000	/* 25Mhz, 4 dividers */
+#define  AXI_CC_CAP_PCTL		0x00040000	/* Power Control */
+#define  AXI_CC_CAP_OTPS		0x00380000	/* OTP size */
+#define  AXI_CC_CAP_OTPS_SHIFT		19
+#define  AXI_CC_CAP_OTPS_BASE		5
+#define  AXI_CC_CAP_JTAGM		0x00400000	/* JTAG master present */
+#define  AXI_CC_CAP_BROM		0x00800000	/* Internal boot ROM active */
+#define  AXI_CC_CAP_64BIT		0x08000000	/* 64-bit Backplane */
+#define  AXI_CC_CAP_PMU			0x10000000	/* PMU available (rev >= 20) */
+#define  AXI_CC_CAP_ECI			0x20000000	/* ECI available (rev >= 20) */
+#define  AXI_CC_CAP_SPROM		0x40000000	/* SPROM present */
+#define AXI_CC_CORECTL			0x0008
+#define  AXI_CC_CORECTL_UARTCLK0	0x00000001	/* Drive UART with internal clock */
+#define	 AXI_CC_CORECTL_SE		0x00000002	/* sync clk out enable (corerev >= 3) */
+#define  AXI_CC_CORECTL_UARTCLKEN	0x00000008	/* UART clock enable (rev >= 21) */
+#define AXI_CC_BIST			0x000C
+#define AXI_CC_OTPS			0x0010		/* OTP status */
+#define	 AXI_CC_OTPS_PROGFAIL		0x80000000
+#define	 AXI_CC_OTPS_PROTECT		0x00000007
+#define	 AXI_CC_OTPS_HW_PROTECT		0x00000001
+#define	 AXI_CC_OTPS_SW_PROTECT		0x00000002
+#define	 AXI_CC_OTPS_CID_PROTECT	0x00000004
+#define AXI_CC_OTPC			0x0014		/* OTP control */
+#define	 AXI_CC_OTPC_RECWAIT		0xFF000000
+#define	 AXI_CC_OTPC_PROGWAIT		0x00FFFF00
+#define	 AXI_CC_OTPC_PRW_SHIFT		8
+#define	 AXI_CC_OTPC_MAXFAIL		0x00000038
+#define	 AXI_CC_OTPC_VSEL		0x00000006
+#define	 AXI_CC_OTPC_SELVL		0x00000001
+#define AXI_CC_OTPP			0x0018		/* OTP prog */
+#define	 AXI_CC_OTPP_COL		0x000000FF
+#define	 AXI_CC_OTPP_ROW		0x0000FF00
+#define	 AXI_CC_OTPP_ROW_SHIFT		8
+#define	 AXI_CC_OTPP_READERR		0x10000000
+#define	 AXI_CC_OTPP_VALUE		0x20000000
+#define	 AXI_CC_OTPP_READ		0x40000000
+#define	 AXI_CC_OTPP_START		0x80000000
+#define	 AXI_CC_OTPP_BUSY		0x80000000
+#define AXI_CC_IRQSTAT			0x0020
+#define AXI_CC_IRQMASK			0x0024
+#define	 AXI_CC_IRQ_GPIO		0x00000001	/* gpio intr */
+#define	 AXI_CC_IRQ_EXT			0x00000002	/* ro: ext intr pin (corerev >= 3) */
+#define	 AXI_CC_IRQ_WDRESET		0x80000000	/* watchdog reset occurred */
+#define AXI_CC_CHIPCTL			0x0028		/* Rev >= 11 only */
+#define AXI_CC_CHIPSTAT			0x002C		/* Rev >= 11 only */
+#define AXI_CC_JCMD			0x0030		/* Rev >= 10 only */
+#define  AXI_CC_JCMD_START		0x80000000
+#define  AXI_CC_JCMD_BUSY		0x80000000
+#define  AXI_CC_JCMD_PAUSE		0x40000000
+#define  AXI_CC_JCMD0_ACC_MASK		0x0000F000
+#define  AXI_CC_JCMD0_ACC_IRDR		0x00000000
+#define  AXI_CC_JCMD0_ACC_DR		0x00001000
+#define  AXI_CC_JCMD0_ACC_IR		0x00002000
+#define  AXI_CC_JCMD0_ACC_RESET		0x00003000
+#define  AXI_CC_JCMD0_ACC_IRPDR		0x00004000
+#define  AXI_CC_JCMD0_ACC_PDR		0x00005000
+#define  AXI_CC_JCMD0_IRW_MASK		0x00000F00
+#define  AXI_CC_JCMD_ACC_MASK		0x000F0000	/* Changes for corerev 11 */
+#define  AXI_CC_JCMD_ACC_IRDR		0x00000000
+#define  AXI_CC_JCMD_ACC_DR		0x00010000
+#define  AXI_CC_JCMD_ACC_IR		0x00020000
+#define  AXI_CC_JCMD_ACC_RESET		0x00030000
+#define  AXI_CC_JCMD_ACC_IRPDR		0x00040000
+#define  AXI_CC_JCMD_ACC_PDR		0x00050000
+#define  AXI_CC_JCMD_IRW_MASK		0x00001F00
+#define  AXI_CC_JCMD_IRW_SHIFT		8
+#define  AXI_CC_JCMD_DRW_MASK		0x0000003F
+#define AXI_CC_JIR			0x0034		/* Rev >= 10 only */
+#define AXI_CC_JDR			0x0038		/* Rev >= 10 only */
+#define AXI_CC_JCTL			0x003C		/* Rev >= 10 only */
+#define  AXI_CC_JCTL_FORCE_CLK		4		/* Force clock */
+#define  AXI_CC_JCTL_EXT_EN		2		/* Enable external targets */
+#define  AXI_CC_JCTL_EN			1		/* Enable Jtag master */
+#define AXI_CC_FLASHCTL			0x0040
+#define  AXI_CC_FLASHCTL_START		0x80000000
+#define  AXI_CC_FLASHCTL_BUSY		AXI_CC_FLASHCTL_START
+#define AXI_CC_FLASHADDR		0x0044
+#define AXI_CC_FLASHDATA		0x0048
+#define AXI_CC_BCAST_ADDR		0x0050
+#define AXI_CC_BCAST_DATA		0x0054
+#define AXI_CC_GPIOIN			0x0060
+#define AXI_CC_GPIOOUT			0x0064
+#define AXI_CC_GPIOOUTEN		0x0068
+#define AXI_CC_GPIOCTL			0x006C
+#define AXI_CC_GPIOPOL			0x0070
+#define AXI_CC_GPIOIRQ			0x0074
+#define AXI_CC_WATCHDOG			0x0080
+#define AXI_CC_GPIOTIMER		0x0088		/* LED powersave (corerev >= 16) */
+#define  AXI_CC_GPIOTIMER_ONTIME_SHIFT	16
+#define AXI_CC_GPIOTOUTM		0x008C		/* LED powersave (corerev >= 16) */
+#define AXI_CC_CLOCK_N			0x0090
+#define AXI_CC_CLOCK_SB			0x0094
+#define AXI_CC_CLOCK_PCI		0x0098
+#define AXI_CC_CLOCK_M2			0x009C
+#define AXI_CC_CLOCK_MIPS		0x00A0
+#define AXI_CC_CLKDIV			0x00A4		/* Rev >= 3 only */
+#define	 AXI_CC_CLKDIV_SFLASH		0x0F000000
+#define	 AXI_CC_CLKDIV_SFLASH_SHIFT	24
+#define	 AXI_CC_CLKDIV_OTP		0x000F0000
+#define	 AXI_CC_CLKDIV_OTP_SHIFT	16
+#define	 AXI_CC_CLKDIV_JTAG		0x00000F00
+#define	 AXI_CC_CLKDIV_JTAG_SHIFT	8
+#define	 AXI_CC_CLKDIV_UART		0x000000FF
+#define AXI_CC_CAP_EXT	 		0x00AC		/* Capabilities */
+#define AXI_CC_PLLONDELAY		0x00B0		/* Rev >= 4 only */
+#define AXI_CC_FREFSELDELAY		0x00B4		/* Rev >= 4 only */
+#define AXI_CC_SLOWCLKCTL		0x00B8		/* 6 <= Rev <= 9 only */
+#define  AXI_CC_SLOWCLKCTL_SRC		0x00000007	/* slow clock source mask */
+#define	  AXI_CC_SLOWCLKCTL_SRC_LPO	0x00000000	/* source of slow clock is LPO */
+#define   AXI_CC_SLOWCLKCTL_SRC_XTAL	0x00000001	/* source of slow clock is crystal */
+#define	  AXI_CC_SLOECLKCTL_SRC_PCI	0x00000002	/* source of slow clock is PCI */
+#define  AXI_CC_SLOWCLKCTL_LPOFREQ	0x00000200	/* LPOFreqSel, 1: 160Khz, 0: 32KHz */
+#define  AXI_CC_SLOWCLKCTL_LPOPD	0x00000400	/* LPOPowerDown, 1: LPO is disabled, 0: LPO is enabled */
+#define  AXI_CC_SLOWCLKCTL_FSLOW	0x00000800	/* ForceSlowClk, 1: sb/cores running on slow clock, 0: power logic control */
+#define  AXI_CC_SLOWCLKCTL_IPLL		0x00001000	/* IgnorePllOffReq, 1/0: power logic ignores/honors PLL clock disable requests from core */
+#define  AXI_CC_SLOWCLKCTL_ENXTAL	0x00002000	/* XtalControlEn, 1/0: power logic does/doesn't disable crystal when appropriate */
+#define  AXI_CC_SLOWCLKCTL_XTALPU	0x00004000	/* XtalPU (RO), 1/0: crystal running/disabled */
+#define  AXI_CC_SLOWCLKCTL_CLKDIV	0xFFFF0000	/* ClockDivider (SlowClk = 1/(4+divisor)) */
+#define  AXI_CC_SLOWCLKCTL_CLKDIV_SHIFT	16
+#define AXI_CC_SYSCLKCTL		0x00C0		/* Rev >= 3 only */
+#define	 AXI_CC_SYSCLKCTL_IDLPEN	0x00000001	/* ILPen: Enable Idle Low Power */
+#define	 AXI_CC_SYSCLKCTL_ALPEN		0x00000002	/* ALPen: Enable Active Low Power */
+#define	 AXI_CC_SYSCLKCTL_PLLEN		0x00000004	/* ForcePLLOn */
+#define	 AXI_CC_SYSCLKCTL_FORCEALP	0x00000008	/* Force ALP (or HT if ALPen is not set */
+#define	 AXI_CC_SYSCLKCTL_FORCEHT	0x00000010	/* Force HT */
+#define  AXI_CC_SYSCLKCTL_CLKDIV	0xFFFF0000	/* ClkDiv  (ILP = 1/(4+divisor)) */
+#define  AXI_CC_SYSCLKCTL_CLKDIV_SHIFT	16
+#define AXI_CC_CLKSTSTR			0x00C4		/* Rev >= 3 only */
+#define AXI_CC_EROM			0x00FC
+#define AXI_CC_PCMCIA_CFG		0x0100
+#define AXI_CC_PCMCIA_MEMWAIT		0x0104
+#define AXI_CC_PCMCIA_ATTRWAIT		0x0108
+#define AXI_CC_PCMCIA_IOWAIT		0x010C
+#define AXI_CC_IDE_CFG			0x0110
+#define AXI_CC_IDE_MEMWAIT		0x0114
+#define AXI_CC_IDE_ATTRWAIT		0x0118
+#define AXI_CC_IDE_IOWAIT		0x011C
+#define AXI_CC_PROG_CFG			0x0120
+#define AXI_CC_PROG_WAITCNT		0x0124
+#define AXI_CC_FLASH_CFG		0x0128
+#define AXI_CC_FLASH_WAITCNT		0x012C
+#define AXI_CC_CLKCTLST			0x01E0 /* Clock control and status (rev >= 20) */
+#define  AXI_CC_CLKCTLST_FORCEALP	0x00000001 /* Force ALP request */
+#define  AXI_CC_CLKCTLST_FORCEHT	0x00000002 /* Force HT request */
+#define  AXI_CC_CLKCTLST_FORCEILP	0x00000004 /* Force ILP request */
+#define  AXI_CC_CLKCTLST_HAVEALPREQ	0x00000008 /* ALP available request */
+#define  AXI_CC_CLKCTLST_HAVEHTREQ	0x00000010 /* HT available request */
+#define  AXI_CC_CLKCTLST_HWCROFF	0x00000020 /* Force HW clock request off */
+#define  AXI_CC_CLKCTLST_HAVEHT		0x00010000 /* HT available */
+#define  AXI_CC_CLKCTLST_HAVEALP	0x00020000 /* APL available */
+#define AXI_CC_HW_WORKAROUND		0x01E4 /* Hardware workaround (rev >= 20) */
+#define AXI_CC_UART0_DATA		0x0300
+#define AXI_CC_UART0_IMR		0x0304
+#define AXI_CC_UART0_FCR		0x0308
+#define AXI_CC_UART0_LCR		0x030C
+#define AXI_CC_UART0_MCR		0x0310
+#define AXI_CC_UART0_LSR		0x0314
+#define AXI_CC_UART0_MSR		0x0318
+#define AXI_CC_UART0_SCRATCH		0x031C
+#define AXI_CC_UART1_DATA		0x0400
+#define AXI_CC_UART1_IMR		0x0404
+#define AXI_CC_UART1_FCR		0x0408
+#define AXI_CC_UART1_LCR		0x040C
+#define AXI_CC_UART1_MCR		0x0410
+#define AXI_CC_UART1_LSR		0x0414
+#define AXI_CC_UART1_MSR		0x0418
+#define AXI_CC_UART1_SCRATCH		0x041C
+/* PMU registers (rev >= 20) */
+#define AXI_CC_PMU_CTL			0x0600 /* PMU control */
+#define  AXI_CC_PMU_CTL_ILP_DIV		0xFFFF0000 /* ILP div mask */
+#define  AXI_CC_PMU_CTL_ILP_DIV_SHIFT	16
+#define  AXI_CC_PMU_CTL_NOILPONW	0x00000200 /* No ILP on wait */
+#define  AXI_CC_PMU_CTL_HTREQEN		0x00000100 /* HT req enable */
+#define  AXI_CC_PMU_CTL_ALPREQEN	0x00000080 /* ALP req enable */
+#define  AXI_CC_PMU_CTL_XTALFREQ	0x0000007C /* Crystal freq */
+#define  AXI_CC_PMU_CTL_XTALFREQ_SHIFT	2
+#define  AXI_CC_PMU_CTL_ILPDIVEN	0x00000002 /* ILP div enable */
+#define  AXI_CC_PMU_CTL_LPOSEL		0x00000001 /* LPO sel */
+#define AXI_CC_PMU_CAP			0x0604 /* PMU capabilities */
+#define  AXI_CC_PMU_CAP_REVISION	0x000000FF /* Revision mask */
+#define AXI_CC_PMU_STAT			0x0608 /* PMU status */
+#define  AXI_CC_PMU_STAT_INTPEND	0x00000040 /* Interrupt pending */
+#define  AXI_CC_PMU_STAT_SBCLKST	0x00000030 /* Backplane clock status? */
+#define  AXI_CC_PMU_STAT_HAVEALP	0x00000008 /* ALP available */
+#define  AXI_CC_PMU_STAT_HAVEHT		0x00000004 /* HT available */
+#define  AXI_CC_PMU_STAT_RESINIT	0x00000003 /* Res init */
+#define AXI_CC_PMU_RES_STAT		0x060C /* PMU res status */
+#define AXI_CC_PMU_RES_PEND		0x0610 /* PMU res pending */
+#define AXI_CC_PMU_TIMER		0x0614 /* PMU timer */
+#define AXI_CC_PMU_MINRES_MSK		0x0618 /* PMU min res mask */
+#define AXI_CC_PMU_MAXRES_MSK		0x061C /* PMU max res mask */
+#define AXI_CC_PMU_RES_TABSEL		0x0620 /* PMU res table sel */
+#define AXI_CC_PMU_RES_DEPMSK		0x0624 /* PMU res dep mask */
+#define AXI_CC_PMU_RES_UPDNTM		0x0628 /* PMU res updown timer */
+#define AXI_CC_PMU_RES_TIMER		0x062C /* PMU res timer */
+#define AXI_CC_PMU_CLKSTRETCH		0x0630 /* PMU clockstretch */
+#define AXI_CC_PMU_WATCHDOG		0x0634 /* PMU watchdog */
+#define AXI_CC_PMU_RES_REQTS		0x0640 /* PMU res req timer sel */
+#define AXI_CC_PMU_RES_REQT		0x0644 /* PMU res req timer */
+#define AXI_CC_PMU_RES_REQM		0x0648 /* PMU res req mask */
+#define AXI_CC_CHIPCTL_ADDR		0x0650
+#define AXI_CC_CHIPCTL_DATA		0x0654
+#define AXI_CC_REGCTL_ADDR		0x0658
+#define AXI_CC_REGCTL_DATA		0x065C
+#define AXI_CC_PLLCTL_ADDR		0x0660
+#define AXI_CC_PLLCTL_DATA		0x0664
+
+/* Data for the PMU, if available.
+ * Check availability with ((struct axi_chipcommon)->capabilities & AXI_CC_CAP_PMU)
+ */
+struct axi_chipcommon_pmu {
+	u8 rev;			/* PMU revision */
+	u32 crystalfreq;	/* The active crystal frequency (in kHz) */
+};
+
+struct axi_drv_cc {
+	struct axi_device *core;
+	u32 status;
+	u32 capabilities;
+	u32 capabilities_ext;
+	/* Fast Powerup Delay constant */
+	u16 fast_pwrup_delay;
+	struct axi_chipcommon_pmu pmu;
+};
+
+/* Register access */
+#define axi_cc_read32(cc, offset)		axi_read32((cc)->core, offset)
+#define axi_cc_write32(cc, offset, val)		axi_write32((cc)->core, offset, val)
+
+#define axi_cc_mask32(cc, offset, mask) \
+		axi_cc_write32(cc, offset, axi_cc_read32(cc, offset) & (mask))
+#define axi_cc_set32(cc, offset, set) \
+		axi_cc_write32(cc, offset, axi_cc_read32(cc, offset) | (set))
+#define axi_cc_maskset32(cc, offset, mask, set) \
+		axi_cc_write32(cc, offset, (axi_cc_read32(cc, offset) & (mask)) | (set))
+
+extern void axi_core_chipcommon_init(struct axi_drv_cc *cc);
+
+extern void axi_chipco_suspend(struct axi_drv_cc *cc);
+extern void axi_chipco_resume(struct axi_drv_cc *cc);
+
+extern void axi_chipco_watchdog_timer_set(struct axi_drv_cc *cc,
+					  u32 ticks);
+
+void axi_chipco_irq_mask(struct axi_drv_cc *cc, u32 mask, u32 value);
+
+u32 axi_chipco_irq_status(struct axi_drv_cc *cc, u32 mask);
+
+/* Chipcommon GPIO pin access. */
+u32 axi_chipco_gpio_in(struct axi_drv_cc *cc, u32 mask);
+u32 axi_chipco_gpio_out(struct axi_drv_cc *cc, u32 mask, u32 value);
+u32 axi_chipco_gpio_outen(struct axi_drv_cc *cc, u32 mask, u32 value);
+u32 axi_chipco_gpio_control(struct axi_drv_cc *cc, u32 mask, u32 value);
+u32 axi_chipco_gpio_intmask(struct axi_drv_cc *cc, u32 mask, u32 value);
+u32 axi_chipco_gpio_polarity(struct axi_drv_cc *cc, u32 mask, u32 value);
+
+/* PMU support */
+extern void axi_pmu_init(struct axi_drv_cc *cc);
+
+#endif /* LINUX_AXI_DRIVER_CC_H_ */
diff --git a/include/linux/axi/axi_driver_pci.h b/include/linux/axi/axi_driver_pci.h
new file mode 100644
index 0000000..f2c637e
--- /dev/null
+++ b/include/linux/axi/axi_driver_pci.h
@@ -0,0 +1,89 @@
+#ifndef LINUX_AXI_DRIVER_PCI_H_
+#define LINUX_AXI_DRIVER_PCI_H_
+
+#include <linux/types.h>
+
+struct pci_dev;
+
+/* PCI core registers. */
+#define AXI_CORE_PCI_CTL			0x0000	/* PCI Control */
+#define  AXI_CORE_PCI_CTL_RST_OE		0x00000001 /* PCI_RESET Output Enable */
+#define  AXI_CORE_PCI_CTL_RST			0x00000002 /* PCI_RESET driven out to pin */
+#define  AXI_CORE_PCI_CTL_CLK_OE		0x00000004 /* Clock gate Output Enable */
+#define  AXI_CORE_PCI_CTL_CLK			0x00000008 /* Gate for clock driven out to pin */
+#define AXI_CORE_PCI_ARBCTL			0x0010	/* PCI Arbiter Control */
+#define  AXI_CORE_PCI_ARBCTL_INTERN		0x00000001 /* Use internal arbiter */
+#define  AXI_CORE_PCI_ARBCTL_EXTERN		0x00000002 /* Use external arbiter */
+#define  AXI_CORE_PCI_ARBCTL_PARKID		0x00000006 /* Mask, selects which agent is parked on an idle bus */
+#define   AXI_CORE_PCI_ARBCTL_PARKID_LAST	0x00000000 /* Last requestor */
+#define   AXI_CORE_PCI_ARBCTL_PARKID_4710	0x00000002 /* 4710 */
+#define   AXI_CORE_PCI_ARBCTL_PARKID_EXT0	0x00000004 /* External requestor 0 */
+#define   AXI_CORE_PCI_ARBCTL_PARKID_EXT1	0x00000006 /* External requestor 1 */
+#define AXI_CORE_PCI_ISTAT			0x0020	/* Interrupt status */
+#define  AXI_CORE_PCI_ISTAT_INTA		0x00000001 /* PCI INTA# */
+#define  AXI_CORE_PCI_ISTAT_INTB		0x00000002 /* PCI INTB# */
+#define  AXI_CORE_PCI_ISTAT_SERR		0x00000004 /* PCI SERR# (write to clear) */
+#define  AXI_CORE_PCI_ISTAT_PERR		0x00000008 /* PCI PERR# (write to clear) */
+#define  AXI_CORE_PCI_ISTAT_PME			0x00000010 /* PCI PME# */
+#define AXI_CORE_PCI_IMASK			0x0024	/* Interrupt mask */
+#define  AXI_CORE_PCI_IMASK_INTA		0x00000001 /* PCI INTA# */
+#define  AXI_CORE_PCI_IMASK_INTB		0x00000002 /* PCI INTB# */
+#define  AXI_CORE_PCI_IMASK_SERR		0x00000004 /* PCI SERR# */
+#define  AXI_CORE_PCI_IMASK_PERR		0x00000008 /* PCI PERR# */
+#define  AXI_CORE_PCI_IMASK_PME			0x00000010 /* PCI PME# */
+#define AXI_CORE_PCI_MBOX			0x0028	/* Backplane to PCI Mailbox */
+#define  AXI_CORE_PCI_MBOX_F0_0			0x00000100 /* PCI function 0, INT 0 */
+#define  AXI_CORE_PCI_MBOX_F0_1			0x00000200 /* PCI function 0, INT 1 */
+#define  AXI_CORE_PCI_MBOX_F1_0			0x00000400 /* PCI function 1, INT 0 */
+#define  AXI_CORE_PCI_MBOX_F1_1			0x00000800 /* PCI function 1, INT 1 */
+#define  AXI_CORE_PCI_MBOX_F2_0			0x00001000 /* PCI function 2, INT 0 */
+#define  AXI_CORE_PCI_MBOX_F2_1			0x00002000 /* PCI function 2, INT 1 */
+#define  AXI_CORE_PCI_MBOX_F3_0			0x00004000 /* PCI function 3, INT 0 */
+#define  AXI_CORE_PCI_MBOX_F3_1			0x00008000 /* PCI function 3, INT 1 */
+#define AXI_CORE_PCI_BCAST_ADDR			0x0050	/* Backplane Broadcast Address */
+#define  AXI_CORE_PCI_BCAST_ADDR_MASK		0x000000FF
+#define AXI_CORE_PCI_BCAST_DATA			0x0054	/* Backplane Broadcast Data */
+#define AXI_CORE_PCI_GPIO_IN			0x0060	/* rev >= 2 only */
+#define AXI_CORE_PCI_GPIO_OUT			0x0064	/* rev >= 2 only */
+#define AXI_CORE_PCI_GPIO_ENABLE		0x0068	/* rev >= 2 only */
+#define AXI_CORE_PCI_GPIO_CTL			0x006C	/* rev >= 2 only */
+#define AXI_CORE_PCI_SBTOPCI0			0x0100	/* Backplane to PCI translation 0 (sbtopci0) */
+#define  AXI_CORE_PCI_SBTOPCI0_MASK		0xFC000000
+#define AXI_CORE_PCI_SBTOPCI1			0x0104	/* Backplane to PCI translation 1 (sbtopci1) */
+#define  AXI_CORE_PCI_SBTOPCI1_MASK		0xFC000000
+#define AXI_CORE_PCI_SBTOPCI2			0x0108	/* Backplane to PCI translation 2 (sbtopci2) */
+#define  AXI_CORE_PCI_SBTOPCI2_MASK		0xC0000000
+#define AXI_CORE_PCI_PCICFG0			0x0400	/* PCI config space 0 (rev >= 8) */
+#define AXI_CORE_PCI_PCICFG1			0x0500	/* PCI config space 1 (rev >= 8) */
+#define AXI_CORE_PCI_PCICFG2			0x0600	/* PCI config space 2 (rev >= 8) */
+#define AXI_CORE_PCI_PCICFG3			0x0700	/* PCI config space 3 (rev >= 8) */
+#define AXI_CORE_PCI_SPROM(wordoffset)		(0x0800 + ((wordoffset) * 2)) /* SPROM shadow area (72 bytes) */
+
+/* SBtoPCIx */
+#define AXI_CORE_PCI_SBTOPCI_MEM		0x00000000
+#define AXI_CORE_PCI_SBTOPCI_IO			0x00000001
+#define AXI_CORE_PCI_SBTOPCI_CFG0		0x00000002
+#define AXI_CORE_PCI_SBTOPCI_CFG1		0x00000003
+#define AXI_CORE_PCI_SBTOPCI_PREF		0x00000004 /* Prefetch enable */
+#define AXI_CORE_PCI_SBTOPCI_BURST		0x00000008 /* Burst enable */
+#define AXI_CORE_PCI_SBTOPCI_MRM		0x00000020 /* Memory Read Multiple */
+#define AXI_CORE_PCI_SBTOPCI_RC			0x00000030 /* Read Command mask (rev >= 11) */
+#define  AXI_CORE_PCI_SBTOPCI_RC_READ		0x00000000 /* Memory read */
+#define  AXI_CORE_PCI_SBTOPCI_RC_READL		0x00000010 /* Memory read line */
+#define  AXI_CORE_PCI_SBTOPCI_RC_READM		0x00000020 /* Memory read multiple */
+
+/* PCIcore specific boardflags */
+#define AXI_CORE_PCI_BFL_NOPCI			0x00000400 /* Board leaves PCI floating */
+
+struct axi_drv_pci {
+	struct axi_device *core;
+	u8 setup_done:1;
+};
+
+/* Register access */
+#define pcicore_read32(pc, offset)		axi_read32((pc)->core, offset)
+#define pcicore_write32(pc, offset, val)	axi_write32((pc)->core, offset, val)
+
+extern void axi_core_pci_init(struct axi_drv_pci *pc);
+
+#endif /* LINUX_AXI_DRIVER_PCI_H_ */
diff --git a/include/linux/axi/axi_regs.h b/include/linux/axi/axi_regs.h
new file mode 100644
index 0000000..3bfb1d0
--- /dev/null
+++ b/include/linux/axi/axi_regs.h
@@ -0,0 +1,34 @@
+#ifndef LINUX_AXI_REGS_H_
+#define LINUX_AXI_REGS_H_
+
+/* Agent registers (common for every core) */
+#define AXI_IOCTL			0x0408
+#define  AXI_IOCTL_CORE_BITS		0x3FFC
+#define  AXI_IOCTL_CLK			0x0001
+#define  AXI_IOCTL_FGC			0x0002
+#define  AXI_IOCTL_PME_EN		0x4000
+#define  AXI_IOCTL_BIST_EN		0x8000
+#define AXI_RESET_CTL			0x0800
+#define  AXI_RESET_CTL_RESET		0x0001
+
+/* AXI PCI config space registers. */
+#define AXI_PCI_PMCSR			0x44
+#define  AXI_PCI_PE			0x100
+#define	AXI_PCI_BAR0_WIN		0x80	/* Backplane address space 0 */
+#define	AXI_PCI_BAR1_WIN		0x84	/* Backplane address space 1 */
+#define	AXI_PCI_SPROMCTL		0x88	/* SPROM control */
+#define  AXI_PCI_SPROMCTL_WE		0x10	/* SPROM write enable */
+#define	AXI_PCI_BAR1_CONTROL		0x8c	/* Address space 1 burst control */
+#define AXI_PCI_IRQS			0x90	/* PCI interrupts */
+#define AXI_PCI_IRQMASK			0x94	/* PCI IRQ control and mask (pcirev >= 6 only) */
+#define AXI_PCI_BACKPLANE_IRQS		0x98	/* Backplane Interrupts */
+#define AXI_PCI_BAR0_WIN2		0xAC
+#define AXI_PCI_GPIO_IN			0xB0	/* GPIO Input (pcirev >= 3 only) */
+#define AXI_PCI_GPIO_OUT		0xB4	/* GPIO Output (pcirev >= 3 only) */
+#define AXI_PCI_GPIO_OUT_ENABLE		0xB8	/* GPIO Output Enable/Disable (pcirev >= 3 only) */
+#define  AXI_PCI_GPIO_SCS		0x10	/* PCI config space bit 4 for 4306c0 slow clock source */
+#define  AXI_PCI_GPIO_HWRAD		0x20	/* PCI config space GPIO 13 for hw radio disable */
+#define  AXI_PCI_GPIO_XTAL		0x40	/* PCI config space GPIO 14 for Xtal powerup */
+#define  AXI_PCI_GPIO_PLL		0x80	/* PCI config space GPIO 15 for PLL powerdown */
+
+#endif /* LINUX_AXI_REGS_H_ */
diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
index 48c007d..b3b6424 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -382,6 +382,23 @@ struct ssb_device_id {
 #define SSB_ANY_ID		0xFFFF
 #define SSB_ANY_REV		0xFF
 
+/* AMBA AXI core, see drivers/axi/ */
+struct axi_device_id {
+	__u16	manuf;
+	__u16	id;
+	__u8	rev;
+	__u8	class;
+};
+#define AXI_CORE(_manuf, _id, _rev, _class)  \
+	{ .manuf = _manuf, .id = _id, .rev = _rev, .class = _class, }
+#define AXI_CORETABLE_END  \
+	{ 0, },
+
+#define AXI_ANY_MANUF		0xFFFF
+#define AXI_ANY_ID		0xFFFF
+#define AXI_ANY_REV		0xFF
+#define AXI_ANY_CLASS		0xFF
+
 struct virtio_device_id {
 	__u32 device;
 	__u32 vendor;
diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
index 88f3f07..d9eebd0 100644
--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -702,6 +702,23 @@ static int do_ssb_entry(const char *filename,
 	return 1;
 }
 
+/* Looks like: axi:mNidNrevNclN. */
+static int do_axi_entry(const char *filename,
+			struct axi_device_id *id, char *alias)
+{
+	id->manuf = TO_NATIVE(id->manuf);
+	id->id = TO_NATIVE(id->id);
+	id->rev = TO_NATIVE(id->rev);
+
+	strcpy(alias, "axi:");
+	ADD(alias, "m", id->manuf != AXI_ANY_MANUF, id->manuf);
+	ADD(alias, "id", id->id != AXI_ANY_ID, id->id);
+	ADD(alias, "rev", id->rev != AXI_ANY_REV, id->rev);
+	ADD(alias, "cl", id->class != AXI_ANY_CLASS, id->class);
+	add_wildcard(alias);
+	return 1;
+}
+
 /* Looks like: virtio:dNvN */
 static int do_virtio_entry(const char *filename, struct virtio_device_id *id,
 			   char *alias)
@@ -968,6 +985,10 @@ void handle_moddevtable(struct module *mod, struct elf_info *info,
 		do_table(symval, sym->st_size,
 			 sizeof(struct ssb_device_id), "ssb",
 			 do_ssb_entry, mod);
+	else if (sym_is(symname, "__mod_axi_device_table"))
+		do_table(symval, sym->st_size,
+			 sizeof(struct axi_device_id), "axi",
+			 do_axi_entry, mod);
 	else if (sym_is(symname, "__mod_virtio_device_table"))
 		do_table(symval, sym->st_size,
 			 sizeof(struct virtio_device_id), "virtio",
-- 
1.7.3.4

