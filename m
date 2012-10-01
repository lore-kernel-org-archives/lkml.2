Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751375Ab2JANeJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 09:34:09 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:59402 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014Ab2JANeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 09:34:07 -0400
Date: Mon, 1 Oct 2012 15:34:01 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/build changes for v3.7
Message-ID: <20121001133401.GA23123@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-build-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-build-for-linus

   HEAD: 3120e25efdc0834c88e1c0f8394e2087444f8c19 x86/Kconfig: Clean up Kconfig defaults

defconfig and kconfig cleanups/fixes.

 Thanks,

	Ingo

------------------>
Jan Beulich (1):
      x86/Kconfig: Clean up Kconfig defaults

Josh Triplett (5):
      x86/Kconfig: Update defconfigs to current results of "make savedefconfig"
      x86/Kconfig: Switch to ext4 in defconfigs
      x86/Kconfig: Disable CONFIG_CRC_T10DIF in defconfigs
      x86/Kconfig: Turn off CONFIG_BLK_DEV_RAM
      x86/Kconfig: Turn off DEBUG_NX_TEST module in defconfigs


 arch/x86/Kconfig                  | 50 +++++++++++++++++++++++----------------
 arch/x86/Kconfig.cpu              |  5 ++--
 arch/x86/configs/i386_defconfig   | 23 ++++++------------
 arch/x86/configs/x86_64_defconfig | 23 ++++++------------
 4 files changed, 47 insertions(+), 54 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 8ec3a1a..3fb8719 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -7,11 +7,13 @@ config 64BIT
 	  Say no to build a 32-bit kernel - formerly known as i386
 
 config X86_32
-	def_bool !64BIT
+	def_bool y
+	depends on !64BIT
 	select CLKSRC_I8253
 
 config X86_64
-	def_bool 64BIT
+	def_bool y
+	depends on 64BIT
 	select X86_DEV_DMA_OPS
 
 ### Arch settings
@@ -99,7 +101,8 @@ config X86
 	select GENERIC_STRNLEN_USER
 
 config INSTRUCTION_DECODER
-	def_bool (KPROBES || PERF_EVENTS || UPROBES)
+	def_bool y
+	depends on KPROBES || PERF_EVENTS || UPROBES
 
 config OUTPUT_FORMAT
 	string
@@ -127,13 +130,15 @@ config SBUS
 	bool
 
 config NEED_DMA_MAP_STATE
-       def_bool (X86_64 || INTEL_IOMMU || DMA_API_DEBUG)
+	def_bool y
+	depends on X86_64 || INTEL_IOMMU || DMA_API_DEBUG
 
 config NEED_SG_DMA_LENGTH
 	def_bool y
 
 config GENERIC_ISA_DMA
-	def_bool ISA_DMA_API
+	def_bool y
+	depends on ISA_DMA_API
 
 config GENERIC_BUG
 	def_bool y
@@ -150,13 +155,16 @@ config GENERIC_GPIO
 	bool
 
 config ARCH_MAY_HAVE_PC_FDC
-	def_bool ISA_DMA_API
+	def_bool y
+	depends on ISA_DMA_API
 
 config RWSEM_GENERIC_SPINLOCK
-	def_bool !X86_XADD
+	def_bool y
+	depends on !X86_XADD
 
 config RWSEM_XCHGADD_ALGORITHM
-	def_bool X86_XADD
+	def_bool y
+	depends on X86_XADD
 
 config GENERIC_CALIBRATE_DELAY
 	def_bool y
@@ -752,7 +760,8 @@ config SWIOTLB
 	  3 GB of memory. If unsure, say Y.
 
 config IOMMU_HELPER
-	def_bool (CALGARY_IOMMU || GART_IOMMU || SWIOTLB || AMD_IOMMU)
+	def_bool y
+	depends on CALGARY_IOMMU || GART_IOMMU || SWIOTLB || AMD_IOMMU
 
 config MAXSMP
 	bool "Enable Maximum number of SMP Processors and NUMA Nodes"
@@ -1159,10 +1168,12 @@ config X86_PAE
 	  consumes more pagetable space per process.
 
 config ARCH_PHYS_ADDR_T_64BIT
-	def_bool X86_64 || X86_PAE
+	def_bool y
+	depends on X86_64 || X86_PAE
 
 config ARCH_DMA_ADDR_T_64BIT
-	def_bool X86_64 || HIGHMEM64G
+	def_bool y
+	depends on X86_64 || HIGHMEM64G
 
 config DIRECT_GBPAGES
 	bool "Enable 1GB pages for kernel pagetables" if EXPERT
@@ -1285,8 +1296,8 @@ config ARCH_SELECT_MEMORY_MODEL
 	depends on ARCH_SPARSEMEM_ENABLE
 
 config ARCH_MEMORY_PROBE
-	def_bool X86_64
-	depends on MEMORY_HOTPLUG
+	def_bool y
+	depends on X86_64 && MEMORY_HOTPLUG
 
 config ARCH_PROC_KCORE_TEXT
 	def_bool y
@@ -1975,7 +1986,6 @@ config PCI_MMCONFIG
 
 config PCI_CNB20LE_QUIRK
 	bool "Read CNB20LE Host Bridge Windows" if EXPERT
-	default n
 	depends on PCI && EXPERIMENTAL
 	help
 	  Read the PCI windows out of the CNB20LE host bridge. This allows
@@ -2186,18 +2196,18 @@ config COMPAT
 	depends on IA32_EMULATION || X86_X32
 	select ARCH_WANT_OLD_COMPAT_IPC
 
+if COMPAT
 config COMPAT_FOR_U64_ALIGNMENT
-	def_bool COMPAT
-	depends on X86_64
+	def_bool y
 
 config SYSVIPC_COMPAT
 	def_bool y
-	depends on COMPAT && SYSVIPC
+	depends on SYSVIPC
 
 config KEYS_COMPAT
-	bool
-	depends on COMPAT && KEYS
-	default y
+	def_bool y
+	depends on KEYS
+endif
 
 endmenu
 
diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
index 706e12e..f3b86d0 100644
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -306,7 +306,8 @@ config X86_INTERNODE_CACHE_SHIFT
 	default X86_L1_CACHE_SHIFT
 
 config X86_CMPXCHG
-	def_bool X86_64 || (X86_32 && !M386)
+	def_bool y
+	depends on X86_64 || (X86_32 && !M386)
 
 config X86_L1_CACHE_SHIFT
 	int
@@ -317,7 +318,7 @@ config X86_L1_CACHE_SHIFT
 
 config X86_XADD
 	def_bool y
-	depends on X86_64 || !M386
+	depends on !M386
 
 config X86_PPRO_FENCE
 	bool "PentiumPro memory ordering errata workaround"
diff --git a/arch/x86/configs/i386_defconfig b/arch/x86/configs/i386_defconfig
index 119db67..5598547 100644
--- a/arch/x86/configs/i386_defconfig
+++ b/arch/x86/configs/i386_defconfig
@@ -8,6 +8,8 @@ CONFIG_TASK_DELAY_ACCT=y
 CONFIG_TASK_XACCT=y
 CONFIG_TASK_IO_ACCOUNTING=y
 CONFIG_AUDIT=y
+CONFIG_NO_HZ=y
+CONFIG_HIGH_RES_TIMERS=y
 CONFIG_LOG_BUF_SHIFT=18
 CONFIG_CGROUPS=y
 CONFIG_CGROUP_FREEZER=y
@@ -34,8 +36,6 @@ CONFIG_SGI_PARTITION=y
 CONFIG_SUN_PARTITION=y
 CONFIG_KARMA_PARTITION=y
 CONFIG_EFI_PARTITION=y
-CONFIG_NO_HZ=y
-CONFIG_HIGH_RES_TIMERS=y
 CONFIG_SMP=y
 CONFIG_X86_GENERIC=y
 CONFIG_HPET_TIMER=y
@@ -144,8 +144,6 @@ CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_DEBUG_DEVRES=y
 CONFIG_CONNECTOR=y
 CONFIG_BLK_DEV_LOOP=y
-CONFIG_BLK_DEV_RAM=y
-CONFIG_BLK_DEV_RAM_SIZE=16384
 CONFIG_BLK_DEV_SD=y
 CONFIG_BLK_DEV_SR=y
 CONFIG_BLK_DEV_SR_VENDOR=y
@@ -231,8 +229,6 @@ CONFIG_SND_HRTIMER=y
 CONFIG_SND_HDA_INTEL=y
 CONFIG_SND_HDA_HWDEP=y
 CONFIG_HIDRAW=y
-CONFIG_HID_PID=y
-CONFIG_USB_HIDDEV=y
 CONFIG_HID_GYRATION=y
 CONFIG_LOGITECH_FF=y
 CONFIG_HID_NTRIG=y
@@ -243,11 +239,11 @@ CONFIG_HID_SAMSUNG=y
 CONFIG_HID_SONY=y
 CONFIG_HID_SUNPLUS=y
 CONFIG_HID_TOPSEED=y
+CONFIG_HID_PID=y
+CONFIG_USB_HIDDEV=y
 CONFIG_USB=y
 CONFIG_USB_DEBUG=y
 CONFIG_USB_ANNOUNCE_NEW_DEVICES=y
-CONFIG_USB_DEVICEFS=y
-# CONFIG_USB_DEVICE_CLASS is not set
 CONFIG_USB_MON=y
 CONFIG_USB_EHCI_HCD=y
 # CONFIG_USB_EHCI_TT_NEWSCHED is not set
@@ -262,10 +258,9 @@ CONFIG_RTC_CLASS=y
 CONFIG_DMADEVICES=y
 CONFIG_EEEPC_LAPTOP=y
 CONFIG_EFI_VARS=y
-CONFIG_EXT3_FS=y
-# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
-CONFIG_EXT3_FS_POSIX_ACL=y
-CONFIG_EXT3_FS_SECURITY=y
+CONFIG_EXT4_FS=y
+CONFIG_EXT4_FS_POSIX_ACL=y
+CONFIG_EXT4_FS_SECURITY=y
 CONFIG_QUOTA=y
 CONFIG_QUOTA_NETLINK_INTERFACE=y
 # CONFIG_PRINT_QUOTA_WARNING is not set
@@ -280,7 +275,6 @@ CONFIG_PROC_KCORE=y
 CONFIG_TMPFS_POSIX_ACL=y
 CONFIG_HUGETLBFS=y
 CONFIG_NFS_FS=y
-CONFIG_NFS_V3=y
 CONFIG_NFS_V3_ACL=y
 CONFIG_NFS_V4=y
 CONFIG_ROOT_NFS=y
@@ -299,13 +293,11 @@ CONFIG_DEBUG_KERNEL=y
 CONFIG_SCHEDSTATS=y
 CONFIG_TIMER_STATS=y
 CONFIG_DEBUG_STACK_USAGE=y
-CONFIG_SYSCTL_SYSCALL_CHECK=y
 CONFIG_BLK_DEV_IO_TRACE=y
 CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
 CONFIG_EARLY_PRINTK_DBGP=y
 CONFIG_DEBUG_STACKOVERFLOW=y
 # CONFIG_DEBUG_RODATA_TEST is not set
-CONFIG_DEBUG_NX_TEST=m
 CONFIG_DEBUG_BOOT_PARAMS=y
 CONFIG_OPTIMIZE_INLINING=y
 CONFIG_KEYS_DEBUG_PROC_KEYS=y
@@ -316,4 +308,3 @@ CONFIG_SECURITY_SELINUX_BOOTPARAM=y
 CONFIG_SECURITY_SELINUX_DISABLE=y
 CONFIG_CRYPTO_AES_586=y
 # CONFIG_CRYPTO_ANSI_CPRNG is not set
-CONFIG_CRC_T10DIF=y
diff --git a/arch/x86/configs/x86_64_defconfig b/arch/x86/configs/x86_64_defconfig
index 76eb290..671524d 100644
--- a/arch/x86/configs/x86_64_defconfig
+++ b/arch/x86/configs/x86_64_defconfig
@@ -8,6 +8,8 @@ CONFIG_TASK_DELAY_ACCT=y
 CONFIG_TASK_XACCT=y
 CONFIG_TASK_IO_ACCOUNTING=y
 CONFIG_AUDIT=y
+CONFIG_NO_HZ=y
+CONFIG_HIGH_RES_TIMERS=y
 CONFIG_LOG_BUF_SHIFT=18
 CONFIG_CGROUPS=y
 CONFIG_CGROUP_FREEZER=y
@@ -34,8 +36,6 @@ CONFIG_SGI_PARTITION=y
 CONFIG_SUN_PARTITION=y
 CONFIG_KARMA_PARTITION=y
 CONFIG_EFI_PARTITION=y
-CONFIG_NO_HZ=y
-CONFIG_HIGH_RES_TIMERS=y
 CONFIG_SMP=y
 CONFIG_CALGARY_IOMMU=y
 CONFIG_NR_CPUS=64
@@ -144,8 +144,6 @@ CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_DEBUG_DEVRES=y
 CONFIG_CONNECTOR=y
 CONFIG_BLK_DEV_LOOP=y
-CONFIG_BLK_DEV_RAM=y
-CONFIG_BLK_DEV_RAM_SIZE=16384
 CONFIG_BLK_DEV_SD=y
 CONFIG_BLK_DEV_SR=y
 CONFIG_BLK_DEV_SR_VENDOR=y
@@ -227,8 +225,6 @@ CONFIG_SND_HRTIMER=y
 CONFIG_SND_HDA_INTEL=y
 CONFIG_SND_HDA_HWDEP=y
 CONFIG_HIDRAW=y
-CONFIG_HID_PID=y
-CONFIG_USB_HIDDEV=y
 CONFIG_HID_GYRATION=y
 CONFIG_LOGITECH_FF=y
 CONFIG_HID_NTRIG=y
@@ -239,11 +235,11 @@ CONFIG_HID_SAMSUNG=y
 CONFIG_HID_SONY=y
 CONFIG_HID_SUNPLUS=y
 CONFIG_HID_TOPSEED=y
+CONFIG_HID_PID=y
+CONFIG_USB_HIDDEV=y
 CONFIG_USB=y
 CONFIG_USB_DEBUG=y
 CONFIG_USB_ANNOUNCE_NEW_DEVICES=y
-CONFIG_USB_DEVICEFS=y
-# CONFIG_USB_DEVICE_CLASS is not set
 CONFIG_USB_MON=y
 CONFIG_USB_EHCI_HCD=y
 # CONFIG_USB_EHCI_TT_NEWSCHED is not set
@@ -262,10 +258,9 @@ CONFIG_AMD_IOMMU_STATS=y
 CONFIG_INTEL_IOMMU=y
 # CONFIG_INTEL_IOMMU_DEFAULT_ON is not set
 CONFIG_EFI_VARS=y
-CONFIG_EXT3_FS=y
-# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
-CONFIG_EXT3_FS_POSIX_ACL=y
-CONFIG_EXT3_FS_SECURITY=y
+CONFIG_EXT4_FS=y
+CONFIG_EXT4_FS_POSIX_ACL=y
+CONFIG_EXT4_FS_SECURITY=y
 CONFIG_QUOTA=y
 CONFIG_QUOTA_NETLINK_INTERFACE=y
 # CONFIG_PRINT_QUOTA_WARNING is not set
@@ -280,7 +275,6 @@ CONFIG_PROC_KCORE=y
 CONFIG_TMPFS_POSIX_ACL=y
 CONFIG_HUGETLBFS=y
 CONFIG_NFS_FS=y
-CONFIG_NFS_V3=y
 CONFIG_NFS_V3_ACL=y
 CONFIG_NFS_V4=y
 CONFIG_ROOT_NFS=y
@@ -298,13 +292,11 @@ CONFIG_DEBUG_KERNEL=y
 CONFIG_SCHEDSTATS=y
 CONFIG_TIMER_STATS=y
 CONFIG_DEBUG_STACK_USAGE=y
-CONFIG_SYSCTL_SYSCALL_CHECK=y
 CONFIG_BLK_DEV_IO_TRACE=y
 CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
 CONFIG_EARLY_PRINTK_DBGP=y
 CONFIG_DEBUG_STACKOVERFLOW=y
 # CONFIG_DEBUG_RODATA_TEST is not set
-CONFIG_DEBUG_NX_TEST=m
 CONFIG_DEBUG_BOOT_PARAMS=y
 CONFIG_OPTIMIZE_INLINING=y
 CONFIG_KEYS_DEBUG_PROC_KEYS=y
@@ -314,4 +306,3 @@ CONFIG_SECURITY_SELINUX=y
 CONFIG_SECURITY_SELINUX_BOOTPARAM=y
 CONFIG_SECURITY_SELINUX_DISABLE=y
 # CONFIG_CRYPTO_ANSI_CPRNG is not set
-CONFIG_CRC_T10DIF=y
