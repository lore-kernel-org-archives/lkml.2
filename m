Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128Ab1GVMts (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 08:49:48 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55399 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753824Ab1GVMtp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 08:49:45 -0400
Date: Fri, 22 Jul 2011 14:48:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [GIT PULL] core/iommu changes for v3.1
Message-ID: <20110722124854.GA24600@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-iommu-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-iommu-for-linus

 Thanks,

	Ingo

------------------>
Joerg Roedel (13):
      x86/amd-iommu: Remove redundant device_flush_dte() calls
      x86/amd-iommu: Introduce global dev_data_list
      x86/amd-iommu: Store devid in dev_data
      x86/amd-iommu: Store ATS state in dev_data
      x86/amd-iommu: Use only dev_data for dte and iotlb flushing routines
      x86/amd-iommu: Use only dev_data in low-level domain attach/detach functions
      x86/amd-iommu: Allow dev_data->alias to be NULL
      x86/amd-iommu: Search for existind dev_data before allocting a new one
      x86/amd-iommu: Store device alias as dev_data pointer
      iommu: Move iommu Kconfig entries to submenu
      iommu/amd: Move missing parts to drivers/iommu
      iommu/amd: Don't use MSI address range for DMA addresses
      iommu/core: Fix build with INTR_REMAP=y && CONFIG_DMAR=n

Laura Abbott (1):
      iommu-api: Add missing header file

Ohad Ben-Cohen (4):
      drivers: iommu: move to a dedicated folder
      msm: iommu: move to drivers/iommu/
      x86: amd_iommu: move to drivers/iommu/
      x86/ia64: intel-iommu: move to drivers/iommu/


 arch/arm/mach-msm/Kconfig                          |   19 --
 arch/arm/mach-msm/Makefile                         |    2 +-
 arch/ia64/Kconfig                                  |   24 --
 arch/x86/Kconfig                                   |   79 -----
 arch/x86/kernel/Makefile                           |    1 -
 drivers/Kconfig                                    |    2 +
 drivers/Makefile                                   |    1 +
 drivers/base/Makefile                              |    1 -
 drivers/iommu/Kconfig                              |  110 +++++++
 drivers/iommu/Makefile                             |    5 +
 {arch/x86/kernel => drivers/iommu}/amd_iommu.c     |  314 ++++++++++++--------
 .../x86/kernel => drivers/iommu}/amd_iommu_init.c  |    8 +-
 .../asm => drivers/iommu}/amd_iommu_proto.h        |    2 +-
 .../asm => drivers/iommu}/amd_iommu_types.h        |    9 +-
 drivers/{pci => iommu}/dmar.c                      |    0
 drivers/{pci => iommu}/intel-iommu.c               |    1 -
 drivers/{pci => iommu}/intr_remapping.c            |    1 -
 drivers/{pci => iommu}/intr_remapping.h            |    0
 drivers/{base => iommu}/iommu.c                    |    0
 drivers/{pci => iommu}/iova.c                      |    0
 .../mach-msm/iommu.c => drivers/iommu/msm_iommu.c  |    0
 .../iommu_dev.c => drivers/iommu/msm_iommu_dev.c   |    0
 drivers/pci/Makefile                               |    5 -
 drivers/pci/pci.h                                  |    2 -
 .../asm/amd_iommu.h => include/linux/amd-iommu.h   |    0
 include/linux/iommu.h                              |    2 +
 include/linux/pci.h                                |   11 +
 27 files changed, 332 insertions(+), 267 deletions(-)
 create mode 100644 drivers/iommu/Kconfig
 create mode 100644 drivers/iommu/Makefile
 rename {arch/x86/kernel => drivers/iommu}/amd_iommu.c (91%)
 rename {arch/x86/kernel => drivers/iommu}/amd_iommu_init.c (99%)
 rename {arch/x86/include/asm => drivers/iommu}/amd_iommu_proto.h (98%)
 rename {arch/x86/include/asm => drivers/iommu}/amd_iommu_types.h (98%)
 rename drivers/{pci => iommu}/dmar.c (100%)
 rename drivers/{pci => iommu}/intel-iommu.c (99%)
 rename drivers/{pci => iommu}/intr_remapping.c (99%)
 rename drivers/{pci => iommu}/intr_remapping.h (100%)
 rename drivers/{base => iommu}/iommu.c (100%)
 rename drivers/{pci => iommu}/iova.c (100%)
 rename arch/arm/mach-msm/iommu.c => drivers/iommu/msm_iommu.c (100%)
 rename arch/arm/mach-msm/iommu_dev.c => drivers/iommu/msm_iommu_dev.c (100%)
 rename arch/x86/include/asm/amd_iommu.h => include/linux/amd-iommu.h (100%)

diff --git a/arch/arm/mach-msm/Kconfig b/arch/arm/mach-msm/Kconfig
index 1516896..888e925 100644
--- a/arch/arm/mach-msm/Kconfig
+++ b/arch/arm/mach-msm/Kconfig
@@ -148,22 +148,6 @@ config MACH_MSM8960_RUMI3
 
 endmenu
 
-config MSM_IOMMU
-	bool "MSM IOMMU Support"
-	depends on ARCH_MSM8X60 || ARCH_MSM8960
-	select IOMMU_API
-	default n
-	help
-	  Support for the IOMMUs found on certain Qualcomm SOCs.
-	  These IOMMUs allow virtualization of the address space used by most
-	  cores within the multimedia subsystem.
-
-	  If unsure, say N here.
-
-config IOMMU_PGTABLES_L2
-	def_bool y
-	depends on MSM_IOMMU && MMU && SMP && CPU_DCACHE_DISABLE=n
-
 config MSM_DEBUG_UART
 	int
 	default 1 if MSM_DEBUG_UART1
@@ -205,9 +189,6 @@ config MSM_GPIOMUX
 config MSM_V2_TLMM
 	bool
 
-config IOMMU_API
-	bool
-
 config MSM_SCM
 	bool
 endif
diff --git a/arch/arm/mach-msm/Makefile b/arch/arm/mach-msm/Makefile
index 9519fd2..b70658c 100644
--- a/arch/arm/mach-msm/Makefile
+++ b/arch/arm/mach-msm/Makefile
@@ -3,7 +3,7 @@ obj-y += clock.o
 obj-$(CONFIG_DEBUG_FS) += clock-debug.o
 
 obj-$(CONFIG_MSM_VIC) += irq-vic.o
-obj-$(CONFIG_MSM_IOMMU) += iommu.o iommu_dev.o devices-iommu.o
+obj-$(CONFIG_MSM_IOMMU) += devices-iommu.o
 
 obj-$(CONFIG_ARCH_MSM7X00A) += dma.o irq.o acpuclock-arm11.o
 obj-$(CONFIG_ARCH_MSM7X30) += dma.o
diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
index 38280ef..7336ba6 100644
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -627,27 +627,6 @@ source "drivers/pci/hotplug/Kconfig"
 
 source "drivers/pcmcia/Kconfig"
 
-config DMAR
-        bool "Support for DMA Remapping Devices (EXPERIMENTAL)"
-        depends on IA64_GENERIC && ACPI && EXPERIMENTAL
-	help
-	  DMA remapping (DMAR) devices support enables independent address
-	  translations for Direct Memory Access (DMA) from devices.
-	  These DMA remapping devices are reported via ACPI tables
-	  and include PCI device scope covered by these DMA
-	  remapping devices.
-
-config DMAR_DEFAULT_ON
-	def_bool y
-	prompt "Enable DMA Remapping Devices by default"
-	depends on DMAR
-	help
-	  Selecting this option will enable a DMAR device at boot time if
-	  one is found. If this option is not selected, DMAR support can
-	  be enabled by passing intel_iommu=on to the kernel. It is
-	  recommended you say N here while the DMAR code remains
-	  experimental.
-
 endmenu
 
 endif
@@ -681,6 +660,3 @@ source "lib/Kconfig"
 
 config IOMMU_HELPER
 	def_bool (IA64_HP_ZX1 || IA64_HP_ZX1_SWIOTLB || IA64_GENERIC || SWIOTLB)
-
-config IOMMU_API
-	def_bool (DMAR)
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index da34972..a169573 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -680,33 +680,6 @@ config CALGARY_IOMMU_ENABLED_BY_DEFAULT
 	  Calgary anyway, pass 'iommu=calgary' on the kernel command line.
 	  If unsure, say Y.
 
-config AMD_IOMMU
-	bool "AMD IOMMU support"
-	select SWIOTLB
-	select PCI_MSI
-	select PCI_IOV
-	depends on X86_64 && PCI && ACPI
-	---help---
-	  With this option you can enable support for AMD IOMMU hardware in
-	  your system. An IOMMU is a hardware component which provides
-	  remapping of DMA memory accesses from devices. With an AMD IOMMU you
-	  can isolate the the DMA memory of different devices and protect the
-	  system from misbehaving device drivers or hardware.
-
-	  You can find out if your system has an AMD IOMMU if you look into
-	  your BIOS for an option to enable it or if you have an IVRS ACPI
-	  table.
-
-config AMD_IOMMU_STATS
-	bool "Export AMD IOMMU statistics to debugfs"
-	depends on AMD_IOMMU
-	select DEBUG_FS
-	---help---
-	  This option enables code in the AMD IOMMU driver to collect various
-	  statistics about whats happening in the driver and exports that
-	  information to userspace via debugfs.
-	  If unsure, say N.
-
 # need this always selected by IOMMU for the VIA workaround
 config SWIOTLB
 	def_bool y if X86_64
@@ -720,9 +693,6 @@ config SWIOTLB
 config IOMMU_HELPER
 	def_bool (CALGARY_IOMMU || GART_IOMMU || SWIOTLB || AMD_IOMMU)
 
-config IOMMU_API
-	def_bool (AMD_IOMMU || DMAR)
-
 config MAXSMP
 	bool "Enable Maximum number of SMP Processors and NUMA Nodes"
 	depends on X86_64 && SMP && DEBUG_KERNEL && EXPERIMENTAL
@@ -1942,55 +1912,6 @@ config PCI_CNB20LE_QUIRK
 
 	  You should say N unless you know you need this.
 
-config DMAR
-	bool "Support for DMA Remapping Devices (EXPERIMENTAL)"
-	depends on PCI_MSI && ACPI && EXPERIMENTAL
-	help
-	  DMA remapping (DMAR) devices support enables independent address
-	  translations for Direct Memory Access (DMA) from devices.
-	  These DMA remapping devices are reported via ACPI tables
-	  and include PCI device scope covered by these DMA
-	  remapping devices.
-
-config DMAR_DEFAULT_ON
-	def_bool y
-	prompt "Enable DMA Remapping Devices by default"
-	depends on DMAR
-	help
-	  Selecting this option will enable a DMAR device at boot time if
-	  one is found. If this option is not selected, DMAR support can
-	  be enabled by passing intel_iommu=on to the kernel. It is
-	  recommended you say N here while the DMAR code remains
-	  experimental.
-
-config DMAR_BROKEN_GFX_WA
-	bool "Workaround broken graphics drivers (going away soon)"
-	depends on DMAR && BROKEN
-	---help---
-	  Current Graphics drivers tend to use physical address
-	  for DMA and avoid using DMA APIs. Setting this config
-	  option permits the IOMMU driver to set a unity map for
-	  all the OS-visible memory. Hence the driver can continue
-	  to use physical addresses for DMA, at least until this
-	  option is removed in the 2.6.32 kernel.
-
-config DMAR_FLOPPY_WA
-	def_bool y
-	depends on DMAR
-	---help---
-	  Floppy disk drivers are known to bypass DMA API calls
-	  thereby failing to work when IOMMU is enabled. This
-	  workaround will setup a 1:1 mapping for the first
-	  16MiB to make floppy (an ISA device) work.
-
-config INTR_REMAP
-	bool "Support for Interrupt Remapping (EXPERIMENTAL)"
-	depends on X86_64 && X86_IO_APIC && PCI_MSI && ACPI && EXPERIMENTAL
-	---help---
-	  Supports Interrupt remapping for IO-APIC and MSI devices.
-	  To use x2apic mode in the CPU's which support x2APIC enhancements or
-	  to support platforms with CPU's having > 8 bit APIC ID, say Y.
-
 source "drivers/pci/pcie/Kconfig"
 
 source "drivers/pci/Kconfig"
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 90b06d4..11817ff 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -123,7 +123,6 @@ ifeq ($(CONFIG_X86_64),y)
 
 	obj-$(CONFIG_GART_IOMMU)	+= amd_gart_64.o aperture_64.o
 	obj-$(CONFIG_CALGARY_IOMMU)	+= pci-calgary_64.o tce_64.o
-	obj-$(CONFIG_AMD_IOMMU)		+= amd_iommu_init.o amd_iommu.o
 
 	obj-$(CONFIG_PCI_MMCONFIG)	+= mmconf-fam10h_64.o
 	obj-y				+= vsmp_64.o
diff --git a/drivers/Kconfig b/drivers/Kconfig
index 3bb154d..9d51318 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -126,4 +126,6 @@ source "drivers/hwspinlock/Kconfig"
 
 source "drivers/clocksource/Kconfig"
 
+source "drivers/iommu/Kconfig"
+
 endmenu
diff --git a/drivers/Makefile b/drivers/Makefile
index 09f3232..2b551e9 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -122,3 +122,4 @@ obj-y				+= ieee802154/
 obj-y				+= clk/
 
 obj-$(CONFIG_HWSPINLOCK)	+= hwspinlock/
+obj-$(CONFIG_IOMMU_SUPPORT)	+= iommu/
diff --git a/drivers/base/Makefile b/drivers/base/Makefile
index 4c5701c..5ab0d07 100644
--- a/drivers/base/Makefile
+++ b/drivers/base/Makefile
@@ -13,7 +13,6 @@ obj-$(CONFIG_FW_LOADER)	+= firmware_class.o
 obj-$(CONFIG_NUMA)	+= node.o
 obj-$(CONFIG_MEMORY_HOTPLUG_SPARSE) += memory.o
 obj-$(CONFIG_SMP)	+= topology.o
-obj-$(CONFIG_IOMMU_API) += iommu.o
 ifeq ($(CONFIG_SYSFS),y)
 obj-$(CONFIG_MODULES)	+= module.o
 endif
diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
new file mode 100644
index 0000000..b57b3fa
--- /dev/null
+++ b/drivers/iommu/Kconfig
@@ -0,0 +1,110 @@
+# IOMMU_API always gets selected by whoever wants it.
+config IOMMU_API
+	bool
+
+menuconfig IOMMU_SUPPORT
+	bool "IOMMU Hardware Support"
+	default y
+	---help---
+	  Say Y here if you want to compile device drivers for IO Memory
+	  Management Units into the kernel. These devices usually allow to
+	  remap DMA requests and/or remap interrupts from other devices on the
+	  system.
+
+if IOMMU_SUPPORT
+
+# MSM IOMMU support
+config MSM_IOMMU
+	bool "MSM IOMMU Support"
+	depends on ARCH_MSM8X60 || ARCH_MSM8960
+	select IOMMU_API
+	help
+	  Support for the IOMMUs found on certain Qualcomm SOCs.
+	  These IOMMUs allow virtualization of the address space used by most
+	  cores within the multimedia subsystem.
+
+	  If unsure, say N here.
+
+config IOMMU_PGTABLES_L2
+	def_bool y
+	depends on MSM_IOMMU && MMU && SMP && CPU_DCACHE_DISABLE=n
+
+# AMD IOMMU support
+config AMD_IOMMU
+	bool "AMD IOMMU support"
+	select SWIOTLB
+	select PCI_MSI
+	select PCI_IOV
+	select IOMMU_API
+	depends on X86_64 && PCI && ACPI
+	---help---
+	  With this option you can enable support for AMD IOMMU hardware in
+	  your system. An IOMMU is a hardware component which provides
+	  remapping of DMA memory accesses from devices. With an AMD IOMMU you
+	  can isolate the the DMA memory of different devices and protect the
+	  system from misbehaving device drivers or hardware.
+
+	  You can find out if your system has an AMD IOMMU if you look into
+	  your BIOS for an option to enable it or if you have an IVRS ACPI
+	  table.
+
+config AMD_IOMMU_STATS
+	bool "Export AMD IOMMU statistics to debugfs"
+	depends on AMD_IOMMU
+	select DEBUG_FS
+	---help---
+	  This option enables code in the AMD IOMMU driver to collect various
+	  statistics about whats happening in the driver and exports that
+	  information to userspace via debugfs.
+	  If unsure, say N.
+
+# Intel IOMMU support
+config DMAR
+	bool "Support for DMA Remapping Devices"
+	depends on PCI_MSI && ACPI && (X86 || IA64_GENERIC)
+	select IOMMU_API
+	help
+	  DMA remapping (DMAR) devices support enables independent address
+	  translations for Direct Memory Access (DMA) from devices.
+	  These DMA remapping devices are reported via ACPI tables
+	  and include PCI device scope covered by these DMA
+	  remapping devices.
+
+config DMAR_DEFAULT_ON
+	def_bool y
+	prompt "Enable DMA Remapping Devices by default"
+	depends on DMAR
+	help
+	  Selecting this option will enable a DMAR device at boot time if
+	  one is found. If this option is not selected, DMAR support can
+	  be enabled by passing intel_iommu=on to the kernel.
+
+config DMAR_BROKEN_GFX_WA
+	bool "Workaround broken graphics drivers (going away soon)"
+	depends on DMAR && BROKEN && X86
+	---help---
+	  Current Graphics drivers tend to use physical address
+	  for DMA and avoid using DMA APIs. Setting this config
+	  option permits the IOMMU driver to set a unity map for
+	  all the OS-visible memory. Hence the driver can continue
+	  to use physical addresses for DMA, at least until this
+	  option is removed in the 2.6.32 kernel.
+
+config DMAR_FLOPPY_WA
+	def_bool y
+	depends on DMAR && X86
+	---help---
+	  Floppy disk drivers are known to bypass DMA API calls
+	  thereby failing to work when IOMMU is enabled. This
+	  workaround will setup a 1:1 mapping for the first
+	  16MiB to make floppy (an ISA device) work.
+
+config INTR_REMAP
+	bool "Support for Interrupt Remapping (EXPERIMENTAL)"
+	depends on X86_64 && X86_IO_APIC && PCI_MSI && ACPI && EXPERIMENTAL
+	---help---
+	  Supports Interrupt remapping for IO-APIC and MSI devices.
+	  To use x2apic mode in the CPU's which support x2APIC enhancements or
+	  to support platforms with CPU's having > 8 bit APIC ID, say Y.
+
+endif # IOMMU_SUPPORT
diff --git a/drivers/iommu/Makefile b/drivers/iommu/Makefile
new file mode 100644
index 0000000..4d4d77d
--- /dev/null
+++ b/drivers/iommu/Makefile
@@ -0,0 +1,5 @@
+obj-$(CONFIG_IOMMU_API) += iommu.o
+obj-$(CONFIG_MSM_IOMMU) += msm_iommu.o msm_iommu_dev.o
+obj-$(CONFIG_AMD_IOMMU) += amd_iommu.o amd_iommu_init.o
+obj-$(CONFIG_DMAR) += dmar.o iova.o intel-iommu.o
+obj-$(CONFIG_INTR_REMAP) += dmar.o intr_remapping.o
diff --git a/arch/x86/kernel/amd_iommu.c b/drivers/iommu/amd_iommu.c
similarity index 91%
rename from arch/x86/kernel/amd_iommu.c
rename to drivers/iommu/amd_iommu.c
index 7c3a95e..a14f8dc 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -27,13 +27,15 @@
 #include <linux/iommu-helper.h>
 #include <linux/iommu.h>
 #include <linux/delay.h>
+#include <linux/amd-iommu.h>
+#include <asm/msidef.h>
 #include <asm/proto.h>
 #include <asm/iommu.h>
 #include <asm/gart.h>
 #include <asm/dma.h>
-#include <asm/amd_iommu_proto.h>
-#include <asm/amd_iommu_types.h>
-#include <asm/amd_iommu.h>
+
+#include "amd_iommu_proto.h"
+#include "amd_iommu_types.h"
 
 #define CMD_SET_TYPE(cmd, t) ((cmd)->data[1] |= ((t) << 28))
 
@@ -45,6 +47,10 @@ static DEFINE_RWLOCK(amd_iommu_devtable_lock);
 static LIST_HEAD(iommu_pd_list);
 static DEFINE_SPINLOCK(iommu_pd_list_lock);
 
+/* List of all available dev_data structures */
+static LIST_HEAD(dev_data_list);
+static DEFINE_SPINLOCK(dev_data_list_lock);
+
 /*
  * Domain for untranslated devices - only allocated
  * if iommu=pt passed on kernel cmd line.
@@ -68,6 +74,67 @@ static void update_domain(struct protection_domain *domain);
  *
  ****************************************************************************/
 
+static struct iommu_dev_data *alloc_dev_data(u16 devid)
+{
+	struct iommu_dev_data *dev_data;
+	unsigned long flags;
+
+	dev_data = kzalloc(sizeof(*dev_data), GFP_KERNEL);
+	if (!dev_data)
+		return NULL;
+
+	dev_data->devid = devid;
+	atomic_set(&dev_data->bind, 0);
+
+	spin_lock_irqsave(&dev_data_list_lock, flags);
+	list_add_tail(&dev_data->dev_data_list, &dev_data_list);
+	spin_unlock_irqrestore(&dev_data_list_lock, flags);
+
+	return dev_data;
+}
+
+static void free_dev_data(struct iommu_dev_data *dev_data)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&dev_data_list_lock, flags);
+	list_del(&dev_data->dev_data_list);
+	spin_unlock_irqrestore(&dev_data_list_lock, flags);
+
+	kfree(dev_data);
+}
+
+static struct iommu_dev_data *search_dev_data(u16 devid)
+{
+	struct iommu_dev_data *dev_data;
+	unsigned long flags;
+
+	spin_lock_irqsave(&dev_data_list_lock, flags);
+	list_for_each_entry(dev_data, &dev_data_list, dev_data_list) {
+		if (dev_data->devid == devid)
+			goto out_unlock;
+	}
+
+	dev_data = NULL;
+
+out_unlock:
+	spin_unlock_irqrestore(&dev_data_list_lock, flags);
+
+	return dev_data;
+}
+
+static struct iommu_dev_data *find_dev_data(u16 devid)
+{
+	struct iommu_dev_data *dev_data;
+
+	dev_data = search_dev_data(devid);
+
+	if (dev_data == NULL)
+		dev_data = alloc_dev_data(devid);
+
+	return dev_data;
+}
+
 static inline u16 get_device_id(struct device *dev)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
@@ -138,33 +205,31 @@ static bool check_device(struct device *dev)
 static int iommu_init_device(struct device *dev)
 {
 	struct iommu_dev_data *dev_data;
-	struct pci_dev *pdev;
-	u16 devid, alias;
+	u16 alias;
 
 	if (dev->archdata.iommu)
 		return 0;
 
-	dev_data = kzalloc(sizeof(*dev_data), GFP_KERNEL);
+	dev_data = find_dev_data(get_device_id(dev));
 	if (!dev_data)
 		return -ENOMEM;
 
-	dev_data->dev = dev;
+	alias = amd_iommu_alias_table[dev_data->devid];
+	if (alias != dev_data->devid) {
+		struct iommu_dev_data *alias_data;
 
-	devid = get_device_id(dev);
-	alias = amd_iommu_alias_table[devid];
-	pdev = pci_get_bus_and_slot(PCI_BUS(alias), alias & 0xff);
-	if (pdev)
-		dev_data->alias = &pdev->dev;
-	else {
-		kfree(dev_data);
-		return -ENOTSUPP;
+		alias_data = find_dev_data(alias);
+		if (alias_data == NULL) {
+			pr_err("AMD-Vi: Warning: Unhandled device %s\n",
+					dev_name(dev));
+			free_dev_data(dev_data);
+			return -ENOTSUPP;
+		}
+		dev_data->alias_data = alias_data;
 	}
 
-	atomic_set(&dev_data->bind, 0);
-
 	dev->archdata.iommu = dev_data;
 
-
 	return 0;
 }
 
@@ -184,11 +249,16 @@ static void iommu_ignore_device(struct device *dev)
 
 static void iommu_uninit_device(struct device *dev)
 {
-	kfree(dev->archdata.iommu);
+	/*
+	 * Nothing to do here - we keep dev_data around for unplugged devices
+	 * and reuse it when the device is re-plugged - not doing so would
+	 * introduce a ton of races.
+	 */
 }
 
 void __init amd_iommu_uninit_devices(void)
 {
+	struct iommu_dev_data *dev_data, *n;
 	struct pci_dev *pdev = NULL;
 
 	for_each_pci_dev(pdev) {
@@ -198,6 +268,10 @@ void __init amd_iommu_uninit_devices(void)
 
 		iommu_uninit_device(&pdev->dev);
 	}
+
+	/* Free all of our dev_data structures */
+	list_for_each_entry_safe(dev_data, n, &dev_data_list, dev_data_list)
+		free_dev_data(dev_data);
 }
 
 int __init amd_iommu_init_devices(void)
@@ -654,19 +728,17 @@ void iommu_flush_all_caches(struct amd_iommu *iommu)
 /*
  * Command send function for flushing on-device TLB
  */
-static int device_flush_iotlb(struct device *dev, u64 address, size_t size)
+static int device_flush_iotlb(struct iommu_dev_data *dev_data,
+			      u64 address, size_t size)
 {
-	struct pci_dev *pdev = to_pci_dev(dev);
 	struct amd_iommu *iommu;
 	struct iommu_cmd cmd;
-	u16 devid;
 	int qdep;
 
-	qdep  = pci_ats_queue_depth(pdev);
-	devid = get_device_id(dev);
-	iommu = amd_iommu_rlookup_table[devid];
+	qdep     = dev_data->ats.qdep;
+	iommu    = amd_iommu_rlookup_table[dev_data->devid];
 
-	build_inv_iotlb_pages(&cmd, devid, qdep, address, size);
+	build_inv_iotlb_pages(&cmd, dev_data->devid, qdep, address, size);
 
 	return iommu_queue_command(iommu, &cmd);
 }
@@ -674,23 +746,19 @@ static int device_flush_iotlb(struct device *dev, u64 address, size_t size)
 /*
  * Command send function for invalidating a device table entry
  */
-static int device_flush_dte(struct device *dev)
+static int device_flush_dte(struct iommu_dev_data *dev_data)
 {
 	struct amd_iommu *iommu;
-	struct pci_dev *pdev;
-	u16 devid;
 	int ret;
 
-	pdev  = to_pci_dev(dev);
-	devid = get_device_id(dev);
-	iommu = amd_iommu_rlookup_table[devid];
+	iommu = amd_iommu_rlookup_table[dev_data->devid];
 
-	ret = iommu_flush_dte(iommu, devid);
+	ret = iommu_flush_dte(iommu, dev_data->devid);
 	if (ret)
 		return ret;
 
-	if (pci_ats_enabled(pdev))
-		ret = device_flush_iotlb(dev, 0, ~0UL);
+	if (dev_data->ats.enabled)
+		ret = device_flush_iotlb(dev_data, 0, ~0UL);
 
 	return ret;
 }
@@ -721,12 +789,11 @@ static void __domain_flush_pages(struct protection_domain *domain,
 	}
 
 	list_for_each_entry(dev_data, &domain->dev_list, list) {
-		struct pci_dev *pdev = to_pci_dev(dev_data->dev);
 
-		if (!pci_ats_enabled(pdev))
+		if (!dev_data->ats.enabled)
 			continue;
 
-		ret |= device_flush_iotlb(dev_data->dev, address, size);
+		ret |= device_flush_iotlb(dev_data, address, size);
 	}
 
 	WARN_ON(ret);
@@ -778,7 +845,7 @@ static void domain_flush_devices(struct protection_domain *domain)
 	spin_lock_irqsave(&domain->lock, flags);
 
 	list_for_each_entry(dev_data, &domain->dev_list, list)
-		device_flush_dte(dev_data->dev);
+		device_flush_dte(dev_data);
 
 	spin_unlock_irqrestore(&domain->lock, flags);
 }
@@ -1136,7 +1203,7 @@ static int alloc_new_range(struct dma_ops_domain *dma_dom,
 {
 	int index = dma_dom->aperture_size >> APERTURE_RANGE_SHIFT;
 	struct amd_iommu *iommu;
-	unsigned long i;
+	unsigned long i, old_size;
 
 #ifdef CONFIG_IOMMU_STRESS
 	populate = false;
@@ -1172,8 +1239,21 @@ static int alloc_new_range(struct dma_ops_domain *dma_dom,
 		}
 	}
 
+	old_size                = dma_dom->aperture_size;
 	dma_dom->aperture_size += APERTURE_RANGE_SIZE;
 
+	/* Reserve address range used for MSI messages */
+	if (old_size < MSI_ADDR_BASE_LO &&
+	    dma_dom->aperture_size > MSI_ADDR_BASE_LO) {
+		unsigned long spage;
+		int pages;
+
+		pages = iommu_num_pages(MSI_ADDR_BASE_LO, 0x10000, PAGE_SIZE);
+		spage = MSI_ADDR_BASE_LO >> PAGE_SHIFT;
+
+		dma_ops_reserve_addresses(dma_dom, spage, pages);
+	}
+
 	/* Initialize the exclusion range if necessary */
 	for_each_iommu(iommu) {
 		if (iommu->exclusion_start &&
@@ -1526,44 +1606,33 @@ static void clear_dte_entry(u16 devid)
 	amd_iommu_apply_erratum_63(devid);
 }
 
-static void do_attach(struct device *dev, struct protection_domain *domain)
+static void do_attach(struct iommu_dev_data *dev_data,
+		      struct protection_domain *domain)
 {
-	struct iommu_dev_data *dev_data;
 	struct amd_iommu *iommu;
-	struct pci_dev *pdev;
-	bool ats = false;
-	u16 devid;
+	bool ats;
 
-	devid    = get_device_id(dev);
-	iommu    = amd_iommu_rlookup_table[devid];
-	dev_data = get_dev_data(dev);
-	pdev     = to_pci_dev(dev);
-
-	if (amd_iommu_iotlb_sup)
-		ats = pci_ats_enabled(pdev);
+	iommu = amd_iommu_rlookup_table[dev_data->devid];
+	ats   = dev_data->ats.enabled;
 
 	/* Update data structures */
 	dev_data->domain = domain;
 	list_add(&dev_data->list, &domain->dev_list);
-	set_dte_entry(devid, domain, ats);
+	set_dte_entry(dev_data->devid, domain, ats);
 
 	/* Do reference counting */
 	domain->dev_iommu[iommu->index] += 1;
 	domain->dev_cnt                 += 1;
 
 	/* Flush the DTE entry */
-	device_flush_dte(dev);
+	device_flush_dte(dev_data);
 }
 
-static void do_detach(struct device *dev)
+static void do_detach(struct iommu_dev_data *dev_data)
 {
-	struct iommu_dev_data *dev_data;
 	struct amd_iommu *iommu;
-	u16 devid;
 
-	devid    = get_device_id(dev);
-	iommu    = amd_iommu_rlookup_table[devid];
-	dev_data = get_dev_data(dev);
+	iommu = amd_iommu_rlookup_table[dev_data->devid];
 
 	/* decrease reference counters */
 	dev_data->domain->dev_iommu[iommu->index] -= 1;
@@ -1572,52 +1641,46 @@ static void do_detach(struct device *dev)
 	/* Update data structures */
 	dev_data->domain = NULL;
 	list_del(&dev_data->list);
-	clear_dte_entry(devid);
+	clear_dte_entry(dev_data->devid);
 
 	/* Flush the DTE entry */
-	device_flush_dte(dev);
+	device_flush_dte(dev_data);
 }
 
 /*
  * If a device is not yet associated with a domain, this function does
  * assigns it visible for the hardware
  */
-static int __attach_device(struct device *dev,
+static int __attach_device(struct iommu_dev_data *dev_data,
 			   struct protection_domain *domain)
 {
-	struct iommu_dev_data *dev_data, *alias_data;
 	int ret;
 
-	dev_data   = get_dev_data(dev);
-	alias_data = get_dev_data(dev_data->alias);
-
-	if (!alias_data)
-		return -EINVAL;
-
 	/* lock domain */
 	spin_lock(&domain->lock);
 
-	/* Some sanity checks */
-	ret = -EBUSY;
-	if (alias_data->domain != NULL &&
-	    alias_data->domain != domain)
-		goto out_unlock;
+	if (dev_data->alias_data != NULL) {
+		struct iommu_dev_data *alias_data = dev_data->alias_data;
 
-	if (dev_data->domain != NULL &&
-	    dev_data->domain != domain)
-		goto out_unlock;
+		/* Some sanity checks */
+		ret = -EBUSY;
+		if (alias_data->domain != NULL &&
+				alias_data->domain != domain)
+			goto out_unlock;
 
-	/* Do real assignment */
-	if (dev_data->alias != dev) {
-		alias_data = get_dev_data(dev_data->alias);
+		if (dev_data->domain != NULL &&
+				dev_data->domain != domain)
+			goto out_unlock;
+
+		/* Do real assignment */
 		if (alias_data->domain == NULL)
-			do_attach(dev_data->alias, domain);
+			do_attach(alias_data, domain);
 
 		atomic_inc(&alias_data->bind);
 	}
 
 	if (dev_data->domain == NULL)
-		do_attach(dev, domain);
+		do_attach(dev_data, domain);
 
 	atomic_inc(&dev_data->bind);
 
@@ -1639,14 +1702,19 @@ static int attach_device(struct device *dev,
 			 struct protection_domain *domain)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
+	struct iommu_dev_data *dev_data;
 	unsigned long flags;
 	int ret;
 
-	if (amd_iommu_iotlb_sup)
-		pci_enable_ats(pdev, PAGE_SHIFT);
+	dev_data = get_dev_data(dev);
+
+	if (amd_iommu_iotlb_sup && pci_enable_ats(pdev, PAGE_SHIFT) == 0) {
+		dev_data->ats.enabled = true;
+		dev_data->ats.qdep    = pci_ats_queue_depth(pdev);
+	}
 
 	write_lock_irqsave(&amd_iommu_devtable_lock, flags);
-	ret = __attach_device(dev, domain);
+	ret = __attach_device(dev_data, domain);
 	write_unlock_irqrestore(&amd_iommu_devtable_lock, flags);
 
 	/*
@@ -1662,10 +1730,8 @@ static int attach_device(struct device *dev,
 /*
  * Removes a device from a protection domain (unlocked)
  */
-static void __detach_device(struct device *dev)
+static void __detach_device(struct iommu_dev_data *dev_data)
 {
-	struct iommu_dev_data *dev_data = get_dev_data(dev);
-	struct iommu_dev_data *alias_data;
 	struct protection_domain *domain;
 	unsigned long flags;
 
@@ -1675,14 +1741,15 @@ static void __detach_device(struct device *dev)
 
 	spin_lock_irqsave(&domain->lock, flags);
 
-	if (dev_data->alias != dev) {
-		alias_data = get_dev_data(dev_data->alias);
+	if (dev_data->alias_data != NULL) {
+		struct iommu_dev_data *alias_data = dev_data->alias_data;
+
 		if (atomic_dec_and_test(&alias_data->bind))
-			do_detach(dev_data->alias);
+			do_detach(alias_data);
 	}
 
 	if (atomic_dec_and_test(&dev_data->bind))
-		do_detach(dev);
+		do_detach(dev_data);
 
 	spin_unlock_irqrestore(&domain->lock, flags);
 
@@ -1693,7 +1760,7 @@ static void __detach_device(struct device *dev)
 	 */
 	if (iommu_pass_through &&
 	    (dev_data->domain == NULL && domain != pt_domain))
-		__attach_device(dev, pt_domain);
+		__attach_device(dev_data, pt_domain);
 }
 
 /*
@@ -1701,16 +1768,20 @@ static void __detach_device(struct device *dev)
  */
 static void detach_device(struct device *dev)
 {
-	struct pci_dev *pdev = to_pci_dev(dev);
+	struct iommu_dev_data *dev_data;
 	unsigned long flags;
 
+	dev_data = get_dev_data(dev);
+
 	/* lock device table */
 	write_lock_irqsave(&amd_iommu_devtable_lock, flags);
-	__detach_device(dev);
+	__detach_device(dev_data);
 	write_unlock_irqrestore(&amd_iommu_devtable_lock, flags);
 
-	if (amd_iommu_iotlb_sup && pci_ats_enabled(pdev))
-		pci_disable_ats(pdev);
+	if (dev_data->ats.enabled) {
+		pci_disable_ats(to_pci_dev(dev));
+		dev_data->ats.enabled = false;
+	}
 }
 
 /*
@@ -1719,26 +1790,25 @@ static void detach_device(struct device *dev)
  */
 static struct protection_domain *domain_for_device(struct device *dev)
 {
-	struct protection_domain *dom;
-	struct iommu_dev_data *dev_data, *alias_data;
+	struct iommu_dev_data *dev_data;
+	struct protection_domain *dom = NULL;
 	unsigned long flags;
-	u16 devid;
 
-	devid      = get_device_id(dev);
 	dev_data   = get_dev_data(dev);
-	alias_data = get_dev_data(dev_data->alias);
-	if (!alias_data)
-		return NULL;
 
-	read_lock_irqsave(&amd_iommu_devtable_lock, flags);
-	dom = dev_data->domain;
-	if (dom == NULL &&
-	    alias_data->domain != NULL) {
-		__attach_device(dev, alias_data->domain);
-		dom = alias_data->domain;
-	}
+	if (dev_data->domain)
+		return dev_data->domain;
+
+	if (dev_data->alias_data != NULL) {
+		struct iommu_dev_data *alias_data = dev_data->alias_data;
 
-	read_unlock_irqrestore(&amd_iommu_devtable_lock, flags);
+		read_lock_irqsave(&amd_iommu_devtable_lock, flags);
+		if (alias_data->domain != NULL) {
+			__attach_device(dev_data, alias_data->domain);
+			dom = alias_data->domain;
+		}
+		read_unlock_irqrestore(&amd_iommu_devtable_lock, flags);
+	}
 
 	return dom;
 }
@@ -1798,7 +1868,6 @@ static int device_change_notifier(struct notifier_block *nb,
 		goto out;
 	}
 
-	device_flush_dte(dev);
 	iommu_completion_wait(iommu);
 
 out:
@@ -1858,11 +1927,8 @@ static void update_device_table(struct protection_domain *domain)
 {
 	struct iommu_dev_data *dev_data;
 
-	list_for_each_entry(dev_data, &domain->dev_list, list) {
-		struct pci_dev *pdev = to_pci_dev(dev_data->dev);
-		u16 devid = get_device_id(dev_data->dev);
-		set_dte_entry(devid, domain, pci_ats_enabled(pdev));
-	}
+	list_for_each_entry(dev_data, &domain->dev_list, list)
+		set_dte_entry(dev_data->devid, domain, dev_data->ats.enabled);
 }
 
 static void update_domain(struct protection_domain *domain)
@@ -2497,9 +2563,7 @@ static void cleanup_domain(struct protection_domain *domain)
 	write_lock_irqsave(&amd_iommu_devtable_lock, flags);
 
 	list_for_each_entry_safe(dev_data, next, &domain->dev_list, list) {
-		struct device *dev = dev_data->dev;
-
-		__detach_device(dev);
+		__detach_device(dev_data);
 		atomic_set(&dev_data->bind, 0);
 	}
 
@@ -2605,7 +2669,6 @@ static void amd_iommu_detach_device(struct iommu_domain *dom,
 	if (!iommu)
 		return;
 
-	device_flush_dte(dev);
 	iommu_completion_wait(iommu);
 }
 
@@ -2616,16 +2679,13 @@ static int amd_iommu_attach_device(struct iommu_domain *dom,
 	struct iommu_dev_data *dev_data;
 	struct amd_iommu *iommu;
 	int ret;
-	u16 devid;
 
 	if (!check_device(dev))
 		return -EINVAL;
 
 	dev_data = dev->archdata.iommu;
 
-	devid = get_device_id(dev);
-
-	iommu = amd_iommu_rlookup_table[devid];
+	iommu = amd_iommu_rlookup_table[dev_data->devid];
 	if (!iommu)
 		return -EINVAL;
 
diff --git a/arch/x86/kernel/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
similarity index 99%
rename from arch/x86/kernel/amd_iommu_init.c
rename to drivers/iommu/amd_iommu_init.c
index bfc8453..82d2410 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -24,14 +24,16 @@
 #include <linux/syscore_ops.h>
 #include <linux/interrupt.h>
 #include <linux/msi.h>
+#include <linux/amd-iommu.h>
 #include <asm/pci-direct.h>
-#include <asm/amd_iommu_proto.h>
-#include <asm/amd_iommu_types.h>
-#include <asm/amd_iommu.h>
 #include <asm/iommu.h>
 #include <asm/gart.h>
 #include <asm/x86_init.h>
 #include <asm/iommu_table.h>
+
+#include "amd_iommu_proto.h"
+#include "amd_iommu_types.h"
+
 /*
  * definitions for the ACPI scanning code
  */
diff --git a/arch/x86/include/asm/amd_iommu_proto.h b/drivers/iommu/amd_iommu_proto.h
similarity index 98%
rename from arch/x86/include/asm/amd_iommu_proto.h
rename to drivers/iommu/amd_iommu_proto.h
index 55d95eb..7ffaa64 100644
--- a/arch/x86/include/asm/amd_iommu_proto.h
+++ b/drivers/iommu/amd_iommu_proto.h
@@ -19,7 +19,7 @@
 #ifndef _ASM_X86_AMD_IOMMU_PROTO_H
 #define _ASM_X86_AMD_IOMMU_PROTO_H
 
-#include <asm/amd_iommu_types.h>
+#include "amd_iommu_types.h"
 
 extern int amd_iommu_init_dma_ops(void);
 extern int amd_iommu_init_passthrough(void);
diff --git a/arch/x86/include/asm/amd_iommu_types.h b/drivers/iommu/amd_iommu_types.h
similarity index 98%
rename from arch/x86/include/asm/amd_iommu_types.h
rename to drivers/iommu/amd_iommu_types.h
index 4c99829..5b9c507 100644
--- a/arch/x86/include/asm/amd_iommu_types.h
+++ b/drivers/iommu/amd_iommu_types.h
@@ -310,10 +310,15 @@ struct protection_domain {
  */
 struct iommu_dev_data {
 	struct list_head list;		  /* For domain->dev_list */
-	struct device *dev;		  /* Device this data belong to */
-	struct device *alias;		  /* The Alias Device */
+	struct list_head dev_data_list;	  /* For global dev_data_list */
+	struct iommu_dev_data *alias_data;/* The alias dev_data */
 	struct protection_domain *domain; /* Domain the device is bound to */
 	atomic_t bind;			  /* Domain attach reverent count */
+	u16 devid;			  /* PCI Device ID */
+	struct {
+		bool enabled;
+		int qdep;
+	} ats;				  /* ATS state */
 };
 
 /*
diff --git a/drivers/pci/dmar.c b/drivers/iommu/dmar.c
similarity index 100%
rename from drivers/pci/dmar.c
rename to drivers/iommu/dmar.c
diff --git a/drivers/pci/intel-iommu.c b/drivers/iommu/intel-iommu.c
similarity index 99%
rename from drivers/pci/intel-iommu.c
rename to drivers/iommu/intel-iommu.c
index f02c34d..c621c98 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -42,7 +42,6 @@
 #include <linux/pci-ats.h>
 #include <asm/cacheflush.h>
 #include <asm/iommu.h>
-#include "pci.h"
 
 #define ROOT_SIZE		VTD_PAGE_SIZE
 #define CONTEXT_SIZE		VTD_PAGE_SIZE
diff --git a/drivers/pci/intr_remapping.c b/drivers/iommu/intr_remapping.c
similarity index 99%
rename from drivers/pci/intr_remapping.c
rename to drivers/iommu/intr_remapping.c
index 3607faf..1a89d4a 100644
--- a/drivers/pci/intr_remapping.c
+++ b/drivers/iommu/intr_remapping.c
@@ -13,7 +13,6 @@
 #include "intr_remapping.h"
 #include <acpi/acpi.h>
 #include <asm/pci-direct.h>
-#include "pci.h"
 
 static struct ioapic_scope ir_ioapic[MAX_IO_APICS];
 static struct hpet_scope ir_hpet[MAX_HPET_TBS];
diff --git a/drivers/pci/intr_remapping.h b/drivers/iommu/intr_remapping.h
similarity index 100%
rename from drivers/pci/intr_remapping.h
rename to drivers/iommu/intr_remapping.h
diff --git a/drivers/base/iommu.c b/drivers/iommu/iommu.c
similarity index 100%
rename from drivers/base/iommu.c
rename to drivers/iommu/iommu.c
diff --git a/drivers/pci/iova.c b/drivers/iommu/iova.c
similarity index 100%
rename from drivers/pci/iova.c
rename to drivers/iommu/iova.c
diff --git a/arch/arm/mach-msm/iommu.c b/drivers/iommu/msm_iommu.c
similarity index 100%
rename from arch/arm/mach-msm/iommu.c
rename to drivers/iommu/msm_iommu.c
diff --git a/arch/arm/mach-msm/iommu_dev.c b/drivers/iommu/msm_iommu_dev.c
similarity index 100%
rename from arch/arm/mach-msm/iommu_dev.c
rename to drivers/iommu/msm_iommu_dev.c
diff --git a/drivers/pci/Makefile b/drivers/pci/Makefile
index 094308e..825c02b 100644
--- a/drivers/pci/Makefile
+++ b/drivers/pci/Makefile
@@ -29,11 +29,6 @@ obj-$(CONFIG_PCI_MSI) += msi.o
 # Build the Hypertransport interrupt support
 obj-$(CONFIG_HT_IRQ) += htirq.o
 
-# Build Intel IOMMU support
-obj-$(CONFIG_DMAR) += dmar.o iova.o intel-iommu.o
-
-obj-$(CONFIG_INTR_REMAP) += dmar.o intr_remapping.o
-
 obj-$(CONFIG_PCI_IOV) += iov.o
 
 #
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 731e202..b7bf11d 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -184,8 +184,6 @@ pci_match_one_device(const struct pci_device_id *id, const struct pci_dev *dev)
 	return NULL;
 }
 
-struct pci_dev *pci_find_upstream_pcie_bridge(struct pci_dev *pdev);
-
 /* PCI slot sysfs helper code */
 #define to_pci_slot(s) container_of(s, struct pci_slot, kobj)
 
diff --git a/arch/x86/include/asm/amd_iommu.h b/include/linux/amd-iommu.h
similarity index 100%
rename from arch/x86/include/asm/amd_iommu.h
rename to include/linux/amd-iommu.h
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 0a2ba40..9940319 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -19,6 +19,8 @@
 #ifndef __LINUX_IOMMU_H
 #define __LINUX_IOMMU_H
 
+#include <linux/errno.h>
+
 #define IOMMU_READ	(1)
 #define IOMMU_WRITE	(2)
 #define IOMMU_CACHE	(4) /* DMA cache coherency */
diff --git a/include/linux/pci.h b/include/linux/pci.h
index c446b5c..970bfe0 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1589,5 +1589,16 @@ int pci_vpd_find_tag(const u8 *buf, unsigned int off, unsigned int len, u8 rdt);
 int pci_vpd_find_info_keyword(const u8 *buf, unsigned int off,
 			      unsigned int len, const char *kw);
 
+/**
+ * pci_find_upstream_pcie_bridge - find upstream PCIe-to-PCI bridge of a device
+ * @pdev: the PCI device
+ *
+ * if the device is PCIE, return NULL
+ * if the device isn't connected to a PCIe bridge (that is its parent is a
+ * legacy PCI bridge and the bridge is directly connected to bus 0), return its
+ * parent
+ */
+struct pci_dev *pci_find_upstream_pcie_bridge(struct pci_dev *pdev);
+
 #endif /* __KERNEL__ */
 #endif /* LINUX_PCI_H */
