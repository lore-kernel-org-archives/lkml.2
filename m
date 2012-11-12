Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356Ab2KLLwv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 06:52:51 -0500
Received: from us02smtp2.synopsys.com ([198.182.60.77]:51577 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104Ab2KLLws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 06:52:48 -0500
From: <Vineet.Gupta1@synopsys.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <tglx@linutronix.de>, <arnd@arndb.de>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [RFC Patch v1 54/55] ARC: [plat-arcfpga] defconfig
Date: Mon, 12 Nov 2012 17:19:12 +0530
Message-ID: <1352720953-24321-24-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1352720953-24321-1-git-send-email-vgupta@synopsys.com>
References: <1352720953-24321-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vineet Gupta <vgupta@synopsys.com>

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 arch/arc/configs/fpga_defconfig |  137 +++++++++++++++++++++++++++++++++++++--
 1 files changed, 130 insertions(+), 7 deletions(-)

diff --git a/arch/arc/configs/fpga_defconfig b/arch/arc/configs/fpga_defconfig
index cfdca3c..d43e738 100644
--- a/arch/arc/configs/fpga_defconfig
+++ b/arch/arc/configs/fpga_defconfig
@@ -17,6 +17,7 @@ CONFIG_STACKTRACE_SUPPORT=y
 CONFIG_HAVE_LATENCYTOP_SUPPORT=y
 # CONFIG_NO_DMA is not set
 CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
+CONFIG_HAVE_IRQ_WORK=y
 
 #
 # General setup
@@ -31,6 +32,7 @@ CONFIG_DEFAULT_HOSTNAME="(none)"
 # CONFIG_SWAP is not set
 # CONFIG_SYSVIPC is not set
 # CONFIG_FHANDLE is not set
+# CONFIG_AUDIT is not set
 CONFIG_HAVE_GENERIC_HARDIRQS=y
 
 #
@@ -53,6 +55,7 @@ CONFIG_HIGH_RES_TIMERS=y
 #
 CONFIG_TICK_CPU_ACCOUNTING=y
 # CONFIG_BSD_PROCESS_ACCT is not set
+# CONFIG_TASKSTATS is not set
 
 #
 # RCU Subsystem
@@ -66,8 +69,7 @@ CONFIG_LOG_BUF_SHIFT=17
 CONFIG_NAMESPACES=y
 # CONFIG_UTS_NS is not set
 # CONFIG_PID_NS is not set
-CONFIG_UIDGID_CONVERTED=y
-# CONFIG_UIDGID_STRICT_TYPE_CHECKS is not set
+CONFIG_NET_NS=y
 # CONFIG_SCHED_AUTOGROUP is not set
 # CONFIG_SYSFS_DEPRECATED is not set
 # CONFIG_RELAY is not set
@@ -97,13 +99,16 @@ CONFIG_BUG=y
 # CONFIG_SIGNALFD is not set
 # CONFIG_TIMERFD is not set
 # CONFIG_EVENTFD is not set
-# CONFIG_SHMEM is not set
+CONFIG_SHMEM=y
 # CONFIG_AIO is not set
 CONFIG_EMBEDDED=y
+CONFIG_HAVE_PERF_EVENTS=y
+CONFIG_PERF_USE_VMALLOC=y
 
 #
 # Kernel Performance Events And Counters
 #
+# CONFIG_PERF_EVENTS is not set
 # CONFIG_VM_EVENT_COUNTERS is not set
 # CONFIG_SLUB_DEBUG is not set
 # CONFIG_COMPAT_BRK is not set
@@ -111,6 +116,11 @@ CONFIG_EMBEDDED=y
 CONFIG_SLUB=y
 # CONFIG_SLOB is not set
 # CONFIG_PROFILING is not set
+CONFIG_HAVE_OPROFILE=y
+# CONFIG_KPROBES is not set
+CONFIG_HAVE_KPROBES=y
+CONFIG_HAVE_KRETPROBES=y
+CONFIG_HAVE_ARCH_TRACEHOOK=y
 CONFIG_GENERIC_SMP_IDLE_THREAD=y
 CONFIG_ARCH_WANT_IPC_PARSE_VERSION=y
 CONFIG_GENERIC_KERNEL_THREAD=y
@@ -121,7 +131,12 @@ CONFIG_MODULES_USE_ELF_RELA=y
 #
 # CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
 CONFIG_BASE_SMALL=1
-# CONFIG_MODULES is not set
+CONFIG_MODULES=y
+# CONFIG_MODULE_FORCE_LOAD is not set
+# CONFIG_MODULE_UNLOAD is not set
+# CONFIG_MODVERSIONS is not set
+# CONFIG_MODULE_SRCVERSION_ALL is not set
+# CONFIG_MODULE_SIG is not set
 CONFIG_BLOCK=y
 # CONFIG_LBDAF is not set
 # CONFIG_BLK_DEV_BSG is not set
@@ -165,6 +180,8 @@ CONFIG_ARC_CACHE_LINE_SHIFT=6
 CONFIG_ARC_HAS_ICACHE=y
 CONFIG_ARC_HAS_DCACHE=y
 CONFIG_ARC_CACHE_PAGES=y
+# CONFIG_ARC_HAS_ICCM is not set
+# CONFIG_ARC_HAS_DCCM is not set
 CONFIG_ARC_HAS_HW_MPY=y
 # CONFIG_ARC_MMU_V1 is not set
 # CONFIG_ARC_MMU_V2 is not set
@@ -172,6 +189,7 @@ CONFIG_ARC_MMU_V3=y
 CONFIG_ARC_PAGE_SIZE_8K=y
 # CONFIG_ARC_PAGE_SIZE_16K is not set
 # CONFIG_ARC_PAGE_SIZE_4K is not set
+# CONFIG_ARC_COMPACT_IRQ_LEVELS is not set
 # CONFIG_ARC_FPU_SAVE_RESTORE is not set
 CONFIG_ARC_CPU_REL_4_10=y
 CONFIG_ARC_HAS_LLSC=y
@@ -183,12 +201,17 @@ CONFIG_ARC_HAS_RTSC=y
 #
 CONFIG_ARC_BOARD_ANGEL4=y
 # CONFIG_ARC_BOARD_ML509 is not set
+# CONFIG_ISS_SMP_EXTN is not set
 CONFIG_ARC_SERIAL_BAUD=115200
+# CONFIG_ARC_HAS_BVCI_LAT_UNIT is not set
 CONFIG_ARC_PLAT_CLK=80000000
 CONFIG_LINUX_LINK_BASE=0x80000000
 CONFIG_ARC_PLAT_SDRAM_SIZE=0x10000000
+CONFIG_ARC_CURR_IN_REG=y
+# CONFIG_ARC_MISALIGN_ACCESS is not set
 # CONFIG_ARC_STACK_NONEXEC is not set
 CONFIG_HZ=100
+# CONFIG_ARC_METAWARE_HLINK is not set
 # CONFIG_ARC_DBG is not set
 CONFIG_CMDLINE="print-fatal-signals=1"
 # CONFIG_CMDLINE_UBOOT is not set
@@ -208,7 +231,71 @@ CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
 # CONFIG_CROSS_MEMORY_ATTACH is not set
 CONFIG_NEED_PER_CPU_KM=y
 # CONFIG_CLEANCACHE is not set
-# CONFIG_NET is not set
+CONFIG_NET=y
+
+#
+# Networking options
+#
+CONFIG_PACKET=y
+# CONFIG_PACKET_DIAG is not set
+CONFIG_UNIX=y
+# CONFIG_UNIX_DIAG is not set
+# CONFIG_XFRM_USER is not set
+# CONFIG_NET_KEY is not set
+CONFIG_INET=y
+# CONFIG_IP_MULTICAST is not set
+# CONFIG_IP_ADVANCED_ROUTER is not set
+# CONFIG_IP_PNP is not set
+# CONFIG_NET_IPIP is not set
+# CONFIG_NET_IPGRE_DEMUX is not set
+# CONFIG_ARPD is not set
+# CONFIG_SYN_COOKIES is not set
+# CONFIG_INET_AH is not set
+# CONFIG_INET_ESP is not set
+# CONFIG_INET_IPCOMP is not set
+# CONFIG_INET_XFRM_TUNNEL is not set
+# CONFIG_INET_TUNNEL is not set
+# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
+# CONFIG_INET_XFRM_MODE_TUNNEL is not set
+# CONFIG_INET_XFRM_MODE_BEET is not set
+# CONFIG_INET_LRO is not set
+CONFIG_INET_DIAG=y
+CONFIG_INET_TCP_DIAG=y
+# CONFIG_INET_UDP_DIAG is not set
+# CONFIG_TCP_CONG_ADVANCED is not set
+CONFIG_TCP_CONG_CUBIC=y
+CONFIG_DEFAULT_TCP_CONG="cubic"
+# CONFIG_IPV6 is not set
+# CONFIG_NETWORK_SECMARK is not set
+# CONFIG_NETFILTER is not set
+# CONFIG_ATM is not set
+# CONFIG_L2TP is not set
+# CONFIG_BRIDGE is not set
+# CONFIG_VLAN_8021Q is not set
+# CONFIG_DECNET is not set
+# CONFIG_LLC2 is not set
+# CONFIG_IPX is not set
+# CONFIG_ATALK is not set
+# CONFIG_PHONET is not set
+# CONFIG_NET_SCHED is not set
+# CONFIG_DCB is not set
+# CONFIG_BATMAN_ADV is not set
+# CONFIG_OPENVSWITCH is not set
+CONFIG_BQL=y
+
+#
+# Network testing
+#
+# CONFIG_NET_PKTGEN is not set
+# CONFIG_HAMRADIO is not set
+# CONFIG_CAN is not set
+# CONFIG_IRDA is not set
+# CONFIG_BT is not set
+# CONFIG_WIRELESS is not set
+# CONFIG_WIMAX is not set
+# CONFIG_RFKILL is not set
+# CONFIG_NET_9P is not set
+# CONFIG_CAIF is not set
 
 #
 # Device Drivers
@@ -234,6 +321,7 @@ CONFIG_EXTRA_FIRMWARE=""
 # Bus devices
 #
 # CONFIG_OMAP_OCP2SCP is not set
+# CONFIG_CONNECTOR is not set
 # CONFIG_MTD is not set
 # CONFIG_PARPORT is not set
 # CONFIG_BLK_DEV is not set
@@ -268,6 +356,8 @@ CONFIG_SCSI_MOD=y
 # CONFIG_SCSI_NETLINK is not set
 # CONFIG_ATA is not set
 # CONFIG_MD is not set
+# CONFIG_NETDEVICES is not set
+# CONFIG_ISDN is not set
 
 #
 # Input device support
@@ -314,6 +404,7 @@ CONFIG_UNIX98_PTYS=y
 # CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
 # CONFIG_LEGACY_PTYS is not set
 # CONFIG_SERIAL_NONSTANDARD is not set
+# CONFIG_N_GSM is not set
 # CONFIG_TRACE_SINK is not set
 # CONFIG_DEVKMEM is not set
 
@@ -461,8 +552,16 @@ CONFIG_DUMMY_CONSOLE=y
 #
 # File systems
 #
-# CONFIG_EXT2_FS is not set
-# CONFIG_EXT3_FS is not set
+CONFIG_EXT2_FS=y
+CONFIG_EXT2_FS_XATTR=y
+# CONFIG_EXT2_FS_POSIX_ACL is not set
+# CONFIG_EXT2_FS_SECURITY is not set
+# CONFIG_EXT2_FS_XIP is not set
+CONFIG_EXT3_FS=y
+CONFIG_EXT3_DEFAULTS_TO_ORDERED=y
+CONFIG_EXT3_FS_XATTR=y
+# CONFIG_EXT3_FS_POSIX_ACL is not set
+# CONFIG_EXT3_FS_SECURITY is not set
 # CONFIG_EXT4_FS is not set
 # CONFIG_REISERFS_FS is not set
 # CONFIG_JFS_FS is not set
@@ -504,9 +603,28 @@ CONFIG_PROC_FS=y
 CONFIG_PROC_SYSCTL=y
 CONFIG_PROC_PAGE_MONITOR=y
 CONFIG_SYSFS=y
+CONFIG_TMPFS=y
+# CONFIG_TMPFS_POSIX_ACL is not set
+# CONFIG_TMPFS_XATTR is not set
 # CONFIG_HUGETLB_PAGE is not set
 # CONFIG_CONFIGFS_FS is not set
 # CONFIG_MISC_FILESYSTEMS is not set
+CONFIG_NETWORK_FILESYSTEMS=y
+CONFIG_NFS_FS=y
+# CONFIG_NFS_V2 is not set
+CONFIG_NFS_V3=y
+# CONFIG_NFS_V3_ACL is not set
+# CONFIG_NFS_V4 is not set
+# CONFIG_NFS_SWAP is not set
+# CONFIG_NFSD is not set
+CONFIG_LOCKD=y
+CONFIG_LOCKD_V4=y
+CONFIG_NFS_COMMON=y
+CONFIG_SUNRPC=y
+# CONFIG_SUNRPC_DEBUG is not set
+# CONFIG_CIFS is not set
+# CONFIG_NCP_FS is not set
+# CONFIG_CODA_FS is not set
 # CONFIG_NLS is not set
 
 #
@@ -562,8 +680,11 @@ CONFIG_STACKTRACE=y
 # CONFIG_FAULT_INJECTION is not set
 # CONFIG_LATENCYTOP is not set
 # CONFIG_DEBUG_PAGEALLOC is not set
+# CONFIG_RBTREE_TEST is not set
+# CONFIG_INTERVAL_TREE_TEST is not set
 # CONFIG_ATOMIC64_SELFTEST is not set
 # CONFIG_SAMPLES is not set
+CONFIG_HAVE_ARCH_KGDB=y
 # CONFIG_TEST_KSTRTOX is not set
 CONFIG_EARLY_PRINTK=y
 # CONFIG_DEBUG_STACKOVERFLOW is not set
@@ -600,6 +721,8 @@ CONFIG_ZLIB_INFLATE=y
 CONFIG_DECOMPRESS_GZIP=y
 CONFIG_HAS_IOMEM=y
 CONFIG_HAS_DMA=y
+CONFIG_DQL=y
+CONFIG_NLATTR=y
 CONFIG_GENERIC_ATOMIC64=y
 CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
 # CONFIG_AVERAGE is not set
-- 
1.7.4.1

