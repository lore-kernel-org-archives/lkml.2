Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580Ab1HQRGn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 13:06:43 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:18290 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645Ab1HQRGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 13:06:35 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6440"; a="111004316"
Message-Id: <20110817163522.852412019@codeaurora.org>
User-Agent: quilt/0.48-1
Date: Wed, 17 Aug 2011 11:35:29 -0500
From: Richard Kuo <rkuo@codeaurora.org>
To: linux-kernel@vger.kernel.org, linux-hexagon@vger.kernel.org
Subject: [patch 32/36] Hexagon: Comet platform support
References: <20110817163457.878854582@codeaurora.org>
Content-Disposition: inline; filename=platform-comet.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Kuo <rkuo@codeaurora.org>

---
 arch/hexagon/configs/comet_defconfig                  |  873 ++++++++++++++++++
 arch/hexagon/include/asm/platform/comet/comet_iomap.h |  237 ++++
 arch/hexagon/include/asm/platform/comet/irq.h         |   25 
 arch/hexagon/platform/comet/Kconfig                   |    1 
 arch/hexagon/platform/comet/Makefile                  |    1 
 arch/hexagon/platform/comet/board.c                   |  195 ++++
 arch/hexagon/platform/comet/board.h                   |   27 
 7 files changed, 1359 insertions(+)

Index: linux-hexagon-kernel/arch/hexagon/configs/comet_defconfig
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/configs/comet_defconfig	2011-07-20 15:19:44.785151291 -0500
@@ -0,0 +1,873 @@
+#
+# Automatically generated make config: don't edit
+# Linux/hexagon 2.6.39-rc5 Kernel Configuration
+# Wed May  4 16:08:56 2011
+#
+
+#
+# Linux Kernel Configuration for Hexagon
+#
+CONFIG_HEXAGON=y
+CONFIG_HEXAGON_ARCH_V2=y
+CONFIG_FRAME_POINTER=y
+CONFIG_LOCKDEP_SUPPORT=y
+# CONFIG_PCI is not set
+CONFIG_EARLY_PRINTK=y
+CONFIG_KTIME_SCALAR=y
+CONFIG_MMU=y
+CONFIG_TRACE_IRQFLAGS_SUPPORT=y
+CONFIG_GENERIC_IRQ_PROBE=y
+CONFIG_GENERIC_IOMAP=y
+CONFIG_HAS_DMA=y
+CONFIG_NEED_SG_DMA_LENGTH=y
+# CONFIG_RWSEM_GENERIC_SPINLOCK is not set
+CONFIG_RWSEM_XCHGADD_ALGORITHM=y
+CONFIG_GENERIC_CALIBRATE_DELAY=y
+CONFIG_GENERIC_FIND_NEXT_BIT=y
+CONFIG_GENERIC_HWEIGHT=y
+CONFIG_GENERIC_TIME=y
+CONFIG_GENERIC_CLOCKEVENTS=y
+CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
+CONFIG_STACKTRACE_SUPPORT=y
+CONFIG_GENERIC_BUG=y
+CONFIG_BUG=y
+
+#
+# Machine selection
+#
+CONFIG_HEXAGON_COMET=y
+# CONFIG_HEXAGON_AMAZON is not set
+CONFIG_HEXAGON_VM=y
+CONFIG_CMDLINE=""
+# CONFIG_HEXAGON_ANGEL_TRAPS is not set
+CONFIG_SMP=y
+CONFIG_NR_CPUS=6
+CONFIG_PAGE_SIZE_4KB=y
+# CONFIG_PAGE_SIZE_16KB is not set
+# CONFIG_PAGE_SIZE_64KB is not set
+# CONFIG_PAGE_SIZE_256KB is not set
+# CONFIG_HIGHMEM is not set
+CONFIG_SELECT_MEMORY_MODEL=y
+CONFIG_FLATMEM_MANUAL=y
+CONFIG_FLATMEM=y
+CONFIG_FLAT_NODE_MEM_MAP=y
+CONFIG_PAGEFLAGS_EXTENDED=y
+CONFIG_SPLIT_PTLOCK_CPUS=4
+# CONFIG_COMPACTION is not set
+# CONFIG_PHYS_ADDR_T_64BIT is not set
+CONFIG_ZONE_DMA_FLAG=0
+CONFIG_VIRT_TO_BUS=y
+# CONFIG_KSM is not set
+CONFIG_DEFAULT_MMAP_MIN_ADDR=0
+CONFIG_HZ_100=y
+# CONFIG_HZ_250 is not set
+# CONFIG_HZ_300 is not set
+# CONFIG_HZ_1000 is not set
+CONFIG_HZ=100
+# CONFIG_SCHED_HRTICK is not set
+# CONFIG_NO_HZ is not set
+# CONFIG_HIGH_RES_TIMERS is not set
+CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
+# CONFIG_GENERIC_GPIO is not set
+CONFIG_HEXAGON_BITOPS=y
+CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
+CONFIG_CONSTRUCTORS=y
+
+#
+# General setup
+#
+CONFIG_EXPERIMENTAL=y
+CONFIG_INIT_ENV_ARG_LIMIT=32
+CONFIG_CROSS_COMPILE="hexagon-"
+CONFIG_LOCALVERSION="-smp"
+# CONFIG_LOCALVERSION_AUTO is not set
+CONFIG_SWAP=y
+CONFIG_SYSVIPC=y
+CONFIG_SYSVIPC_SYSCTL=y
+CONFIG_POSIX_MQUEUE=y
+CONFIG_POSIX_MQUEUE_SYSCTL=y
+CONFIG_BSD_PROCESS_ACCT=y
+CONFIG_BSD_PROCESS_ACCT_V3=y
+# CONFIG_FHANDLE is not set
+CONFIG_TASKSTATS=y
+CONFIG_TASK_DELAY_ACCT=y
+# CONFIG_TASK_XACCT is not set
+# CONFIG_AUDIT is not set
+CONFIG_HAVE_GENERIC_HARDIRQS=y
+
+#
+# IRQ subsystem
+#
+CONFIG_GENERIC_HARDIRQS=y
+
+#
+# RCU Subsystem
+#
+CONFIG_TREE_RCU=y
+# CONFIG_PREEMPT_RCU is not set
+# CONFIG_RCU_TRACE is not set
+CONFIG_RCU_FANOUT=32
+# CONFIG_RCU_FANOUT_EXACT is not set
+# CONFIG_TREE_RCU_TRACE is not set
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_LOG_BUF_SHIFT=18
+# CONFIG_CGROUPS is not set
+# CONFIG_NAMESPACES is not set
+# CONFIG_SCHED_AUTOGROUP is not set
+# CONFIG_SYSFS_DEPRECATED is not set
+# CONFIG_RELAY is not set
+CONFIG_BLK_DEV_INITRD=y
+CONFIG_INITRAMFS_SOURCE=""
+CONFIG_RD_GZIP=y
+# CONFIG_RD_BZIP2 is not set
+# CONFIG_RD_LZMA is not set
+# CONFIG_RD_XZ is not set
+# CONFIG_RD_LZO is not set
+# CONFIG_INITRAMFS_COMPRESSION_NONE is not set
+# CONFIG_INITRAMFS_COMPRESSION_GZIP is not set
+# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
+CONFIG_SYSCTL=y
+CONFIG_ANON_INODES=y
+CONFIG_EXPERT=y
+CONFIG_SYSCTL_SYSCALL=y
+CONFIG_KALLSYMS=y
+# CONFIG_KALLSYMS_ALL is not set
+# CONFIG_KALLSYMS_EXTRA_PASS is not set
+CONFIG_HOTPLUG=y
+CONFIG_PRINTK=y
+CONFIG_ELF_CORE=y
+CONFIG_BASE_FULL=y
+CONFIG_FUTEX=y
+CONFIG_EPOLL=y
+CONFIG_SIGNALFD=y
+CONFIG_TIMERFD=y
+CONFIG_EVENTFD=y
+CONFIG_SHMEM=y
+CONFIG_AIO=y
+CONFIG_EMBEDDED=y
+
+#
+# Kernel Performance Events And Counters
+#
+# CONFIG_VM_EVENT_COUNTERS is not set
+CONFIG_SLUB_DEBUG=y
+CONFIG_COMPAT_BRK=y
+# CONFIG_SLAB is not set
+CONFIG_SLUB=y
+# CONFIG_SLOB is not set
+# CONFIG_PROFILING is not set
+CONFIG_HAVE_OPROFILE=y
+CONFIG_HAVE_DMA_ATTRS=y
+
+#
+# GCOV-based kernel profiling
+#
+# CONFIG_GCOV_KERNEL is not set
+# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
+CONFIG_SLABINFO=y
+CONFIG_RT_MUTEXES=y
+CONFIG_BASE_SMALL=0
+# CONFIG_MODULES is not set
+CONFIG_BLOCK=y
+CONFIG_LBDAF=y
+# CONFIG_BLK_DEV_BSG is not set
+# CONFIG_BLK_DEV_INTEGRITY is not set
+
+#
+# IO Schedulers
+#
+CONFIG_IOSCHED_NOOP=y
+CONFIG_IOSCHED_DEADLINE=y
+CONFIG_IOSCHED_CFQ=y
+# CONFIG_DEFAULT_DEADLINE is not set
+CONFIG_DEFAULT_CFQ=y
+# CONFIG_DEFAULT_NOOP is not set
+CONFIG_DEFAULT_IOSCHED="cfq"
+# CONFIG_INLINE_SPIN_TRYLOCK is not set
+# CONFIG_INLINE_SPIN_TRYLOCK_BH is not set
+# CONFIG_INLINE_SPIN_LOCK is not set
+# CONFIG_INLINE_SPIN_LOCK_BH is not set
+# CONFIG_INLINE_SPIN_LOCK_IRQ is not set
+# CONFIG_INLINE_SPIN_LOCK_IRQSAVE is not set
+CONFIG_INLINE_SPIN_UNLOCK=y
+# CONFIG_INLINE_SPIN_UNLOCK_BH is not set
+CONFIG_INLINE_SPIN_UNLOCK_IRQ=y
+# CONFIG_INLINE_SPIN_UNLOCK_IRQRESTORE is not set
+# CONFIG_INLINE_READ_TRYLOCK is not set
+# CONFIG_INLINE_READ_LOCK is not set
+# CONFIG_INLINE_READ_LOCK_BH is not set
+# CONFIG_INLINE_READ_LOCK_IRQ is not set
+# CONFIG_INLINE_READ_LOCK_IRQSAVE is not set
+CONFIG_INLINE_READ_UNLOCK=y
+# CONFIG_INLINE_READ_UNLOCK_BH is not set
+CONFIG_INLINE_READ_UNLOCK_IRQ=y
+# CONFIG_INLINE_READ_UNLOCK_IRQRESTORE is not set
+# CONFIG_INLINE_WRITE_TRYLOCK is not set
+# CONFIG_INLINE_WRITE_LOCK is not set
+# CONFIG_INLINE_WRITE_LOCK_BH is not set
+# CONFIG_INLINE_WRITE_LOCK_IRQ is not set
+# CONFIG_INLINE_WRITE_LOCK_IRQSAVE is not set
+CONFIG_INLINE_WRITE_UNLOCK=y
+# CONFIG_INLINE_WRITE_UNLOCK_BH is not set
+CONFIG_INLINE_WRITE_UNLOCK_IRQ=y
+# CONFIG_INLINE_WRITE_UNLOCK_IRQRESTORE is not set
+CONFIG_MUTEX_SPIN_ON_OWNER=y
+
+#
+# Device Drivers
+#
+
+#
+# Generic Driver Options
+#
+CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
+# CONFIG_DEVTMPFS is not set
+# CONFIG_STANDALONE is not set
+CONFIG_PREVENT_FIRMWARE_BUILD=y
+CONFIG_FW_LOADER=y
+CONFIG_FIRMWARE_IN_KERNEL=y
+CONFIG_EXTRA_FIRMWARE=""
+# CONFIG_DEBUG_DRIVER is not set
+# CONFIG_DEBUG_DEVRES is not set
+# CONFIG_SYS_HYPERVISOR is not set
+CONFIG_CONNECTOR=y
+CONFIG_PROC_EVENTS=y
+# CONFIG_MTD is not set
+# CONFIG_PARPORT is not set
+CONFIG_BLK_DEV=y
+# CONFIG_BLK_DEV_COW_COMMON is not set
+CONFIG_BLK_DEV_LOOP=y
+# CONFIG_BLK_DEV_CRYPTOLOOP is not set
+# CONFIG_BLK_DEV_DRBD is not set
+CONFIG_BLK_DEV_NBD=y
+# CONFIG_BLK_DEV_RAM is not set
+# CONFIG_CDROM_PKTCDVD is not set
+# CONFIG_ATA_OVER_ETH is not set
+# CONFIG_BLK_DEV_RBD is not set
+# CONFIG_SENSORS_LIS3LV02D is not set
+# CONFIG_MISC_DEVICES is not set
+
+#
+# SCSI device support
+#
+CONFIG_SCSI_MOD=y
+# CONFIG_RAID_ATTRS is not set
+# CONFIG_SCSI is not set
+# CONFIG_SCSI_DMA is not set
+# CONFIG_SCSI_NETLINK is not set
+# CONFIG_ATA is not set
+# CONFIG_MD is not set
+CONFIG_NETDEVICES=y
+# CONFIG_DUMMY is not set
+# CONFIG_BONDING is not set
+# CONFIG_MACVLAN is not set
+# CONFIG_EQUALIZER is not set
+# CONFIG_TUN is not set
+# CONFIG_VETH is not set
+CONFIG_MII=y
+CONFIG_PHYLIB=y
+
+#
+# MII PHY device drivers
+#
+# CONFIG_MARVELL_PHY is not set
+# CONFIG_DAVICOM_PHY is not set
+# CONFIG_QSEMI_PHY is not set
+# CONFIG_LXT_PHY is not set
+# CONFIG_CICADA_PHY is not set
+# CONFIG_VITESSE_PHY is not set
+# CONFIG_SMSC_PHY is not set
+# CONFIG_BROADCOM_PHY is not set
+# CONFIG_BCM63XX_PHY is not set
+# CONFIG_ICPLUS_PHY is not set
+# CONFIG_REALTEK_PHY is not set
+# CONFIG_NATIONAL_PHY is not set
+# CONFIG_STE10XP is not set
+# CONFIG_LSI_ET1011C_PHY is not set
+# CONFIG_MICREL_PHY is not set
+# CONFIG_FIXED_PHY is not set
+# CONFIG_MDIO_BITBANG is not set
+CONFIG_NET_ETHERNET=y
+# CONFIG_ENC28J60 is not set
+# CONFIG_ETHOC is not set
+CONFIG_SMSC911X=y
+# CONFIG_SMSC911X_ARCH_HOOKS is not set
+# CONFIG_DNET is not set
+# CONFIG_IBM_NEW_EMAC_ZMII is not set
+# CONFIG_IBM_NEW_EMAC_RGMII is not set
+# CONFIG_IBM_NEW_EMAC_TAH is not set
+# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
+# CONFIG_IBM_NEW_EMAC_NO_FLOW_CTRL is not set
+# CONFIG_IBM_NEW_EMAC_MAL_CLR_ICINTSTAT is not set
+# CONFIG_IBM_NEW_EMAC_MAL_COMMON_ERR is not set
+# CONFIG_B44 is not set
+# CONFIG_KS8851 is not set
+# CONFIG_KS8851_MLL is not set
+# CONFIG_NETDEV_1000 is not set
+# CONFIG_NETDEV_10000 is not set
+CONFIG_WLAN=y
+# CONFIG_HOSTAP is not set
+
+#
+# Enable WiMAX (Networking options) to see the WiMAX drivers
+#
+# CONFIG_WAN is not set
+
+#
+# CAIF transport drivers
+#
+# CONFIG_PPP is not set
+# CONFIG_SLIP is not set
+# CONFIG_NETCONSOLE is not set
+# CONFIG_NETPOLL is not set
+# CONFIG_NET_POLL_CONTROLLER is not set
+# CONFIG_ISDN is not set
+# CONFIG_PHONE is not set
+
+#
+# Input device support
+#
+CONFIG_INPUT=y
+# CONFIG_INPUT_FF_MEMLESS is not set
+# CONFIG_INPUT_POLLDEV is not set
+# CONFIG_INPUT_SPARSEKMAP is not set
+
+#
+# Userland interfaces
+#
+# CONFIG_INPUT_MOUSEDEV is not set
+# CONFIG_INPUT_JOYDEV is not set
+# CONFIG_INPUT_EVDEV is not set
+# CONFIG_INPUT_EVBUG is not set
+
+#
+# Input Device Drivers
+#
+# CONFIG_INPUT_KEYBOARD is not set
+# CONFIG_INPUT_MOUSE is not set
+# CONFIG_INPUT_JOYSTICK is not set
+# CONFIG_INPUT_TABLET is not set
+# CONFIG_INPUT_TOUCHSCREEN is not set
+# CONFIG_INPUT_MISC is not set
+
+#
+# Hardware I/O ports
+#
+# CONFIG_SERIO is not set
+# CONFIG_GAMEPORT is not set
+
+#
+# Character devices
+#
+CONFIG_VT=y
+# CONFIG_CONSOLE_TRANSLATIONS is not set
+CONFIG_VT_CONSOLE=y
+CONFIG_HW_CONSOLE=y
+# CONFIG_VT_HW_CONSOLE_BINDING is not set
+CONFIG_UNIX98_PTYS=y
+# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
+CONFIG_LEGACY_PTYS=y
+CONFIG_LEGACY_PTY_COUNT=64
+# CONFIG_SERIAL_NONSTANDARD is not set
+# CONFIG_N_GSM is not set
+# CONFIG_DEVKMEM is not set
+
+#
+# Serial drivers
+#
+# CONFIG_SERIAL_8250 is not set
+
+#
+# Non-8250 serial port support
+#
+# CONFIG_SERIAL_MAX3100 is not set
+# CONFIG_SERIAL_MAX3107 is not set
+CONFIG_SERIAL_CORE=y
+CONFIG_SERIAL_CORE_CONSOLE=y
+CONFIG_SERIAL_MSM=y
+CONFIG_SERIAL_MSM_CONSOLE=y
+CONFIG_SERIAL_MSM_CONSOLE_PORT=2
+# CONFIG_SERIAL_TIMBERDALE is not set
+# CONFIG_SERIAL_ALTERA_JTAGUART is not set
+# CONFIG_SERIAL_ALTERA_UART is not set
+# CONFIG_TTY_PRINTK is not set
+# CONFIG_IPMI_HANDLER is not set
+# CONFIG_HW_RANDOM is not set
+# CONFIG_RTC is not set
+# CONFIG_GEN_RTC is not set
+# CONFIG_R3964 is not set
+
+#
+# PCMCIA character devices
+#
+# CONFIG_RAW_DRIVER is not set
+# CONFIG_TCG_TPM is not set
+# CONFIG_RAMOOPS is not set
+# CONFIG_I2C is not set
+CONFIG_SPI=y
+CONFIG_SPI_DEBUG=y
+CONFIG_SPI_MASTER=y
+
+#
+# SPI Master Controller Drivers
+#
+# CONFIG_SPI_ALTERA is not set
+CONFIG_SPI_BITBANG=y
+# CONFIG_SPI_PXA2XX_PCI is not set
+# CONFIG_SPI_XILINX is not set
+# CONFIG_SPI_DESIGNWARE is not set
+
+#
+# SPI Protocol Masters
+#
+# CONFIG_SPI_SPIDEV is not set
+# CONFIG_SPI_TLE62X0 is not set
+
+#
+# PPS support
+#
+# CONFIG_PPS is not set
+
+#
+# PPS generators support
+#
+# CONFIG_W1 is not set
+# CONFIG_POWER_SUPPLY is not set
+# CONFIG_HWMON is not set
+# CONFIG_THERMAL is not set
+# CONFIG_WATCHDOG is not set
+CONFIG_SSB_POSSIBLE=y
+
+#
+# Sonics Silicon Backplane
+#
+# CONFIG_SSB is not set
+CONFIG_MFD_SUPPORT=y
+# CONFIG_MFD_CORE is not set
+# CONFIG_MFD_SM501 is not set
+# CONFIG_HTC_PASIC3 is not set
+# CONFIG_MFD_TMIO is not set
+# CONFIG_MFD_WM831X_SPI is not set
+# CONFIG_MFD_MC13XXX is not set
+# CONFIG_ABX500_CORE is not set
+# CONFIG_EZX_PCAP is not set
+# CONFIG_REGULATOR is not set
+# CONFIG_MEDIA_SUPPORT is not set
+
+#
+# Graphics support
+#
+# CONFIG_DRM is not set
+# CONFIG_VGASTATE is not set
+# CONFIG_VIDEO_OUTPUT_CONTROL is not set
+# CONFIG_FB is not set
+# CONFIG_BACKLIGHT_LCD_SUPPORT is not set
+
+#
+# Display device support
+#
+# CONFIG_DISPLAY_SUPPORT is not set
+
+#
+# Console display driver support
+#
+# CONFIG_VGA_CONSOLE is not set
+CONFIG_DUMMY_CONSOLE=y
+# CONFIG_SOUND is not set
+# CONFIG_HID_SUPPORT is not set
+# CONFIG_USB_SUPPORT is not set
+# CONFIG_MMC is not set
+# CONFIG_MEMSTICK is not set
+# CONFIG_NEW_LEDS is not set
+# CONFIG_NFC_DEVICES is not set
+# CONFIG_ACCESSIBILITY is not set
+# CONFIG_RTC_CLASS is not set
+# CONFIG_DMADEVICES is not set
+# CONFIG_AUXDISPLAY is not set
+# CONFIG_UIO is not set
+# CONFIG_STAGING is not set
+
+#
+# File systems
+#
+CONFIG_EXT2_FS=y
+CONFIG_EXT2_FS_XATTR=y
+CONFIG_EXT2_FS_POSIX_ACL=y
+CONFIG_EXT2_FS_SECURITY=y
+# CONFIG_EXT2_FS_XIP is not set
+CONFIG_EXT3_FS=y
+# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
+CONFIG_EXT3_FS_XATTR=y
+CONFIG_EXT3_FS_POSIX_ACL=y
+CONFIG_EXT3_FS_SECURITY=y
+# CONFIG_EXT4_FS is not set
+CONFIG_JBD=y
+# CONFIG_JBD_DEBUG is not set
+CONFIG_FS_MBCACHE=y
+# CONFIG_REISERFS_FS is not set
+# CONFIG_JFS_FS is not set
+# CONFIG_XFS_FS is not set
+# CONFIG_GFS2_FS is not set
+# CONFIG_BTRFS_FS is not set
+# CONFIG_NILFS2_FS is not set
+CONFIG_FS_POSIX_ACL=y
+CONFIG_FILE_LOCKING=y
+CONFIG_FSNOTIFY=y
+CONFIG_DNOTIFY=y
+CONFIG_INOTIFY_USER=y
+# CONFIG_FANOTIFY is not set
+CONFIG_QUOTA=y
+# CONFIG_QUOTA_NETLINK_INTERFACE is not set
+CONFIG_PRINT_QUOTA_WARNING=y
+# CONFIG_QUOTA_DEBUG is not set
+# CONFIG_QFMT_V1 is not set
+# CONFIG_QFMT_V2 is not set
+CONFIG_QUOTACTL=y
+# CONFIG_AUTOFS4_FS is not set
+# CONFIG_FUSE_FS is not set
+CONFIG_GENERIC_ACL=y
+
+#
+# Caches
+#
+# CONFIG_FSCACHE is not set
+
+#
+# CD-ROM/DVD Filesystems
+#
+# CONFIG_ISO9660_FS is not set
+# CONFIG_UDF_FS is not set
+
+#
+# DOS/FAT/NT Filesystems
+#
+# CONFIG_MSDOS_FS is not set
+# CONFIG_VFAT_FS is not set
+# CONFIG_NTFS_FS is not set
+
+#
+# Pseudo filesystems
+#
+CONFIG_PROC_FS=y
+CONFIG_PROC_KCORE=y
+CONFIG_PROC_SYSCTL=y
+CONFIG_PROC_PAGE_MONITOR=y
+CONFIG_SYSFS=y
+CONFIG_TMPFS=y
+CONFIG_TMPFS_POSIX_ACL=y
+# CONFIG_HUGETLB_PAGE is not set
+# CONFIG_CONFIGFS_FS is not set
+# CONFIG_MISC_FILESYSTEMS is not set
+CONFIG_NETWORK_FILESYSTEMS=y
+CONFIG_NFS_FS=y
+CONFIG_NFS_V3=y
+CONFIG_NFS_V3_ACL=y
+# CONFIG_NFS_V4 is not set
+# CONFIG_NFSD is not set
+CONFIG_LOCKD=y
+CONFIG_LOCKD_V4=y
+CONFIG_NFS_ACL_SUPPORT=y
+CONFIG_NFS_COMMON=y
+CONFIG_SUNRPC=y
+# CONFIG_RPCSEC_GSS_KRB5 is not set
+# CONFIG_CEPH_FS is not set
+# CONFIG_CIFS is not set
+# CONFIG_NCP_FS is not set
+# CONFIG_CODA_FS is not set
+# CONFIG_AFS_FS is not set
+
+#
+# Partition Types
+#
+# CONFIG_PARTITION_ADVANCED is not set
+CONFIG_MSDOS_PARTITION=y
+# CONFIG_NLS is not set
+
+#
+# Executable File Formats
+#
+CONFIG_BINFMT_ELF=y
+# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
+# CONFIG_HAVE_AOUT is not set
+# CONFIG_BINFMT_MISC is not set
+CONFIG_NET=y
+
+#
+# Networking options
+#
+CONFIG_PACKET=y
+CONFIG_UNIX=y
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
+# CONFIG_INET_DIAG is not set
+# CONFIG_TCP_CONG_ADVANCED is not set
+CONFIG_TCP_CONG_CUBIC=y
+CONFIG_DEFAULT_TCP_CONG="cubic"
+# CONFIG_TCP_MD5SIG is not set
+# CONFIG_IPV6 is not set
+# CONFIG_NETWORK_SECMARK is not set
+# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
+# CONFIG_NETFILTER is not set
+# CONFIG_IP_DCCP is not set
+# CONFIG_IP_SCTP is not set
+# CONFIG_RDS is not set
+# CONFIG_TIPC is not set
+# CONFIG_ATM is not set
+# CONFIG_L2TP is not set
+# CONFIG_BRIDGE is not set
+# CONFIG_NET_DSA is not set
+# CONFIG_VLAN_8021Q is not set
+# CONFIG_DECNET is not set
+# CONFIG_LLC2 is not set
+# CONFIG_IPX is not set
+# CONFIG_ATALK is not set
+# CONFIG_X25 is not set
+# CONFIG_LAPB is not set
+# CONFIG_ECONET is not set
+# CONFIG_WAN_ROUTER is not set
+# CONFIG_PHONET is not set
+# CONFIG_IEEE802154 is not set
+# CONFIG_NET_SCHED is not set
+# CONFIG_DCB is not set
+# CONFIG_BATMAN_ADV is not set
+
+#
+# Network testing
+#
+# CONFIG_NET_PKTGEN is not set
+# CONFIG_HAMRADIO is not set
+# CONFIG_CAN is not set
+# CONFIG_IRDA is not set
+# CONFIG_BT is not set
+# CONFIG_AF_RXRPC is not set
+CONFIG_WIRELESS=y
+# CONFIG_CFG80211 is not set
+# CONFIG_LIB80211 is not set
+
+#
+# CFG80211 needs to be enabled for MAC80211
+#
+# CONFIG_WIMAX is not set
+# CONFIG_RFKILL is not set
+# CONFIG_NET_9P is not set
+# CONFIG_CAIF is not set
+# CONFIG_CEPH_LIB is not set
+
+#
+# Security options
+#
+# CONFIG_KEYS is not set
+# CONFIG_SECURITY_DMESG_RESTRICT is not set
+# CONFIG_SECURITY is not set
+# CONFIG_SECURITYFS is not set
+CONFIG_DEFAULT_SECURITY_DAC=y
+CONFIG_DEFAULT_SECURITY=""
+CONFIG_CRYPTO=y
+
+#
+# Crypto core or helper
+#
+CONFIG_CRYPTO_ALGAPI=y
+CONFIG_CRYPTO_ALGAPI2=y
+CONFIG_CRYPTO_HASH=y
+CONFIG_CRYPTO_HASH2=y
+# CONFIG_CRYPTO_MANAGER is not set
+# CONFIG_CRYPTO_MANAGER2 is not set
+# CONFIG_CRYPTO_GF128MUL is not set
+# CONFIG_CRYPTO_NULL is not set
+# CONFIG_CRYPTO_PCRYPT is not set
+# CONFIG_CRYPTO_CRYPTD is not set
+# CONFIG_CRYPTO_AUTHENC is not set
+
+#
+# Authenticated Encryption with Associated Data
+#
+# CONFIG_CRYPTO_CCM is not set
+# CONFIG_CRYPTO_GCM is not set
+# CONFIG_CRYPTO_SEQIV is not set
+
+#
+# Block modes
+#
+# CONFIG_CRYPTO_CBC is not set
+# CONFIG_CRYPTO_CTR is not set
+# CONFIG_CRYPTO_CTS is not set
+# CONFIG_CRYPTO_ECB is not set
+# CONFIG_CRYPTO_LRW is not set
+# CONFIG_CRYPTO_PCBC is not set
+# CONFIG_CRYPTO_XTS is not set
+
+#
+# Hash modes
+#
+# CONFIG_CRYPTO_HMAC is not set
+# CONFIG_CRYPTO_XCBC is not set
+# CONFIG_CRYPTO_VMAC is not set
+
+#
+# Digest
+#
+CONFIG_CRYPTO_CRC32C=y
+# CONFIG_CRYPTO_GHASH is not set
+# CONFIG_CRYPTO_MD4 is not set
+CONFIG_CRYPTO_MD5=y
+# CONFIG_CRYPTO_MICHAEL_MIC is not set
+# CONFIG_CRYPTO_RMD128 is not set
+# CONFIG_CRYPTO_RMD160 is not set
+# CONFIG_CRYPTO_RMD256 is not set
+# CONFIG_CRYPTO_RMD320 is not set
+# CONFIG_CRYPTO_SHA1 is not set
+# CONFIG_CRYPTO_SHA256 is not set
+# CONFIG_CRYPTO_SHA512 is not set
+# CONFIG_CRYPTO_TGR192 is not set
+# CONFIG_CRYPTO_WP512 is not set
+
+#
+# Ciphers
+#
+# CONFIG_CRYPTO_AES is not set
+# CONFIG_CRYPTO_ANUBIS is not set
+# CONFIG_CRYPTO_ARC4 is not set
+# CONFIG_CRYPTO_BLOWFISH is not set
+# CONFIG_CRYPTO_CAMELLIA is not set
+# CONFIG_CRYPTO_CAST5 is not set
+# CONFIG_CRYPTO_CAST6 is not set
+# CONFIG_CRYPTO_DES is not set
+# CONFIG_CRYPTO_FCRYPT is not set
+# CONFIG_CRYPTO_KHAZAD is not set
+# CONFIG_CRYPTO_SALSA20 is not set
+# CONFIG_CRYPTO_SEED is not set
+# CONFIG_CRYPTO_SERPENT is not set
+# CONFIG_CRYPTO_TEA is not set
+# CONFIG_CRYPTO_TWOFISH is not set
+
+#
+# Compression
+#
+# CONFIG_CRYPTO_DEFLATE is not set
+# CONFIG_CRYPTO_ZLIB is not set
+# CONFIG_CRYPTO_LZO is not set
+
+#
+# Random Number Generation
+#
+# CONFIG_CRYPTO_ANSI_CPRNG is not set
+# CONFIG_CRYPTO_USER_API_HASH is not set
+# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
+# CONFIG_CRYPTO_HW is not set
+# CONFIG_BINARY_PRINTF is not set
+
+#
+# Library routines
+#
+CONFIG_BITREVERSE=y
+CONFIG_GENERIC_FIND_LAST_BIT=y
+CONFIG_CRC_CCITT=y
+CONFIG_CRC16=y
+CONFIG_CRC_T10DIF=y
+# CONFIG_CRC_ITU_T is not set
+CONFIG_CRC32=y
+# CONFIG_CRC7 is not set
+CONFIG_LIBCRC32C=y
+CONFIG_ZLIB_INFLATE=y
+# CONFIG_XZ_DEC is not set
+# CONFIG_XZ_DEC_BCJ is not set
+CONFIG_DECOMPRESS_GZIP=y
+CONFIG_GENERIC_ALLOCATOR=y
+CONFIG_HAS_IOMEM=y
+CONFIG_HAS_IOPORT=y
+CONFIG_NLATTR=y
+# CONFIG_AVERAGE is not set
+
+#
+# Kernel hacking
+#
+# CONFIG_PRINTK_TIME is not set
+CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
+CONFIG_ENABLE_WARN_DEPRECATED=y
+CONFIG_ENABLE_MUST_CHECK=y
+CONFIG_FRAME_WARN=0
+CONFIG_MAGIC_SYSRQ=y
+# CONFIG_STRIP_ASM_SYMS is not set
+# CONFIG_UNUSED_SYMBOLS is not set
+CONFIG_DEBUG_FS=y
+# CONFIG_HEADERS_CHECK is not set
+# CONFIG_DEBUG_SECTION_MISMATCH is not set
+CONFIG_DEBUG_KERNEL=y
+# CONFIG_DEBUG_SHIRQ is not set
+# CONFIG_LOCKUP_DETECTOR is not set
+# CONFIG_HARDLOCKUP_DETECTOR is not set
+# CONFIG_DETECT_HUNG_TASK is not set
+# CONFIG_SCHED_DEBUG is not set
+# CONFIG_SCHEDSTATS is not set
+# CONFIG_TIMER_STATS is not set
+# CONFIG_DEBUG_OBJECTS is not set
+# CONFIG_SLUB_DEBUG_ON is not set
+# CONFIG_SLUB_STATS is not set
+# CONFIG_DEBUG_RT_MUTEXES is not set
+# CONFIG_RT_MUTEX_TESTER is not set
+# CONFIG_DEBUG_SPINLOCK is not set
+# CONFIG_DEBUG_MUTEXES is not set
+# CONFIG_DEBUG_LOCK_ALLOC is not set
+# CONFIG_PROVE_LOCKING is not set
+# CONFIG_SPARSE_RCU_POINTER is not set
+# CONFIG_LOCK_STAT is not set
+# CONFIG_DEBUG_SPINLOCK_SLEEP is not set
+# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
+CONFIG_STACKTRACE=y
+# CONFIG_DEBUG_KOBJECT is not set
+CONFIG_DEBUG_BUGVERBOSE=y
+CONFIG_DEBUG_INFO=y
+# CONFIG_DEBUG_INFO_REDUCED is not set
+# CONFIG_DEBUG_VM is not set
+# CONFIG_DEBUG_WRITECOUNT is not set
+# CONFIG_DEBUG_MEMORY_INIT is not set
+# CONFIG_DEBUG_LIST is not set
+# CONFIG_TEST_LIST_SORT is not set
+# CONFIG_DEBUG_SG is not set
+# CONFIG_DEBUG_NOTIFIERS is not set
+# CONFIG_DEBUG_CREDENTIALS is not set
+# CONFIG_BOOT_PRINTK_DELAY is not set
+# CONFIG_RCU_TORTURE_TEST is not set
+CONFIG_RCU_CPU_STALL_DETECTOR=y
+CONFIG_RCU_CPU_STALL_TIMEOUT=60
+CONFIG_RCU_CPU_STALL_DETECTOR_RUNNABLE=y
+# CONFIG_BACKTRACE_SELF_TEST is not set
+# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
+# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
+# CONFIG_LKDTM is not set
+# CONFIG_FAULT_INJECTION is not set
+# CONFIG_SYSCTL_SYSCALL_CHECK is not set
+# CONFIG_DEBUG_PAGEALLOC is not set
+CONFIG_TRACING_SUPPORT=y
+CONFIG_FTRACE=y
+# CONFIG_IRQSOFF_TRACER is not set
+# CONFIG_SCHED_TRACER is not set
+# CONFIG_ENABLE_DEFAULT_TRACERS is not set
+CONFIG_BRANCH_PROFILE_NONE=y
+# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
+# CONFIG_PROFILE_ALL_BRANCHES is not set
+# CONFIG_BLK_DEV_IO_TRACE is not set
+# CONFIG_DYNAMIC_DEBUG is not set
+# CONFIG_ATOMIC64_SELFTEST is not set
+# CONFIG_SAMPLES is not set
+CONFIG_HAVE_ARCH_KGDB=y
+# CONFIG_KGDB is not set
+# CONFIG_TEST_KSTRTOX is not set
Index: linux-hexagon-kernel/arch/hexagon/platform/comet/board.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/platform/comet/board.c	2011-07-20 15:19:44.785151291 -0500
@@ -0,0 +1,195 @@
+/*
+ * linux/arch/hexagon/platform/comet/board.c
+ *
+ * Copyright (C) 2007 Google, Inc.
+ * Copyright (c) 2008-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/smsc911x.h>
+#include <linux/io.h>
+#include <asm/irq.h>
+#include <asm/clock.h>
+#include <asm/platform.h>
+#include <asm/platform/sirc.h>
+#include <asm/platform/comet/irq.h>
+#include <asm/platform/comet/comet_iomap.h>
+#include "board.h"
+
+/*  Clock Control */
+static struct resource clkctl_resources[] = {
+	{
+		.name  = "clk_ctl_phys",
+		.start = CLK_CTL_PHYS,
+		.end   = CLK_CTL_PHYS+PAGE_SIZE-1,
+		.flags = IORESOURCE_MEM
+	}
+};
+
+static struct platform_device clk_ctl_device = {
+	.name = "clk_ctl",
+	.id = 0,
+	.num_resources = ARRAY_SIZE(clkctl_resources),
+	.resource = clkctl_resources
+};
+
+/*  MSM Serial */
+static struct resource msm_serial0_resources[] = {
+	{
+		/* The irq is on the second controller */
+		.start = HEXAGON_CPUINTS + L2_GROUP_SIZE + L2_SIRC1_UART3,
+		.end   = HEXAGON_CPUINTS + L2_GROUP_SIZE + L2_SIRC1_UART3,
+		.flags	= IORESOURCE_IRQ,
+	},
+	{
+		.start	= MSM_UART3_PHYS,
+		.end	= MSM_UART3_PHYS + MSM_UART3_SIZE - 1,
+		.flags	= IORESOURCE_MEM,
+	},
+};
+
+static struct platform_device msm_serial0_device = {
+	.name	= "msm_serial",
+	.id	= 2,
+	.num_resources	= ARRAY_SIZE(msm_serial0_resources),
+	.resource	= msm_serial0_resources,
+};
+
+/*  SMSC911X (Ethernet) */
+/*  Driver set the chip for push/pull, active low by default.  */
+static struct smsc911x_platform_config comet_smsc911x_config = {
+	.flags		= SMSC911X_USE_32BIT,
+	.irq_polarity	= SMSC911X_IRQ_POLARITY_ACTIVE_LOW,
+	.irq_type	= SMSC911X_IRQ_TYPE_PUSH_PULL,
+/*	.phy_interface	= PHY_INTERFACE_MODE_MII  */
+};
+
+static struct resource smsc911x_resources[] = {
+	[0] = {
+		.start	= SMC911X_PHYS,
+		.end	= SMC911X_PHYS+PAGE_SIZE-1,
+		.flags	= IORESOURCE_MEM,
+	},
+	[1] = {
+/*
+ * XXX ethernet is actually on gpio 156 which is routed
+ * the GPIO group one, which is on SIRC group zero.
+ * So, for now, just route it to gpio_group_1; fix later!
+ */
+		.start   = HEXAGON_CPUINTS + L2_SIRC0_GPIO_GROUP1,
+		.end     = HEXAGON_CPUINTS + L2_SIRC0_GPIO_GROUP1,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+/* Devices */
+static struct platform_device smc911x_device = {
+	.name		= "smsc911x",
+	.id		= 0,
+	.num_resources	= ARRAY_SIZE(smsc911x_resources),
+	.resource	= smsc911x_resources,
+	.dev		= {
+		.platform_data = &comet_smsc911x_config,
+	},
+};
+
+static struct platform_device *devices[] __initdata = {
+	&msm_serial0_device,
+	&smc911x_device,
+	&clk_ctl_device
+};
+
+static struct clk comet_clocks[] = {
+	CLOCK("uart1_clk",	UART1_CLK,	OFF),
+	CLOCK("uart2_clk",	UART2_CLK,	0),
+	CLOCK("uart3_clk",	UART3_CLK,	OFF),
+};
+
+static struct msm_clock_platform_data comet_clock_data = {
+	.active_clocks = comet_clocks,
+	.active_clock_count = ARRAY_SIZE(comet_clocks),
+};
+
+/*
+ * Eventually, we should pull this info from the platform device tree.
+ */
+static struct sirc_cascade_regs regs_table[] = {
+	{
+		.cascade_irq      = L1_ADSP6_SIRC0,
+		.sirq_base        = HEXAGON_CPUINTS,
+		.group_size       = L2_GROUP_SIZE,
+		.base_addr        = ADSP6_SIRC,
+		.regs.int_status       = (void *) HEXSS_SIRC0_IRQ_STATUS,
+		.regs.int_polarity     = (void *) HEXSS_SIRC0_INT_POLARITY,
+		.regs.int_type         = (void *) HEXSS_SIRC0_INT_TYPE,
+		.regs.int_enable       = (void *) HEXSS_SIRC0_INT_ENABLE,
+		.regs.int_enable_set   = (void *) HEXSS_SIRC0_INT_ENABLE_SET,
+		.regs.int_enable_clear = (void *) HEXSS_SIRC0_INT_ENABLE_CLEAR,
+		.regs.int_clear        = (void *) HEXSS_SIRC0_INT_CLEAR,
+	},
+	{
+		.cascade_irq      = L1_ADSP6_SIRC1,
+		.sirq_base        = HEXAGON_CPUINTS + L2_GROUP_SIZE,
+		.group_size       = L2_GROUP_SIZE,
+		.base_addr        = ADSP6_SIRC,
+		.regs.int_status       = (void *) HEXSS_SIRC1_IRQ_STATUS,
+		.regs.int_polarity     = (void *) HEXSS_SIRC1_INT_POLARITY,
+		.regs.int_type         = (void *) HEXSS_SIRC1_INT_TYPE,
+		.regs.int_enable       = (void *) HEXSS_SIRC1_INT_ENABLE,
+		.regs.int_enable_set   = (void *) HEXSS_SIRC1_INT_ENABLE_SET,
+		.regs.int_enable_clear = (void *) HEXSS_SIRC1_INT_ENABLE_CLEAR,
+		.regs.int_clear        = (void *) HEXSS_SIRC1_INT_CLEAR,
+	},
+};
+
+static int __init comet_init(void)
+{
+	void __iomem *tmp_clk;
+
+	hexss_init_sirc(regs_table, ARRAY_SIZE(regs_table));
+
+	printk(KERN_INFO "%s: Setting UART3 to TCX0\n", __func__);
+	tmp_clk = ioremap(CLK_CTL_PHYS, PAGE_SIZE);
+
+	if (!tmp_clk)
+		panic("ERROR:  problem mapping clock control\n");
+
+	writel(UART_NS_REG__UART3_CLK_BRANCH_ENA___M,
+		tmp_clk + 0xc0);
+
+	iounmap(tmp_clk);
+
+	platform_add_devices(devices, ARRAY_SIZE(devices));
+
+	return 0;
+}
+
+/*
+ * Bypass all the machine garbage and stuff this right into initcalls.
+ * map_io is called during paging_init.
+ */
+arch_initcall(comet_init);
+
+static void __init comet_clock_init(void)
+{
+	msm_clock_init(&comet_clock_data);
+}
+
+void __init comet_setup_ops(struct platform_ops_t * ops)
+{
+	ops->clock_init = comet_clock_init;
+	bootmem_lastpg = PFN_DOWN(EBI1_CS_N1_TOP);
+}
+
Index: linux-hexagon-kernel/arch/hexagon/platform/comet/board.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/platform/comet/board.h	2011-07-20 15:19:44.785151291 -0500
@@ -0,0 +1,27 @@
+/*
+ * Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+#ifndef _COMET_BOARD_H
+#define _COMET_BOARD_H
+
+#define UART_NS_REG__UART3_SRC_SEL__TCX04       0x1
+#define UART_NS_REG__UART3_SRC_SEL___S          12
+#define UART_NS_REG__UART3_ROOT_ENA___M         0x00010000
+#define UART_NS_REG__UART3_CLK_BRANCH_ENA___M   0x00020000
+
+#endif
Index: linux-hexagon-kernel/arch/hexagon/platform/comet/Kconfig
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/platform/comet/Kconfig	2011-07-20 15:19:44.785151291 -0500
@@ -0,0 +1 @@
+# this space intentionally left blank
Index: linux-hexagon-kernel/arch/hexagon/platform/comet/Makefile
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/platform/comet/Makefile	2011-07-20 15:19:44.785151291 -0500
@@ -0,0 +1 @@
+obj-y += board.o
Index: linux-hexagon-kernel/arch/hexagon/include/asm/platform/comet/comet_iomap.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/platform/comet/comet_iomap.h	2011-07-20 15:19:44.785151291 -0500
@@ -0,0 +1,237 @@
+/*
+ * Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+#ifndef COMET_IOMAP_H
+#define COMET_IOMAP_H
+
+/*
+ * The "machine" io starts at UART1, but UART3 is the one that's signed up
+ * for console.
+ *
+ * If you change UART3, you need to change hexagon_cosimcfg for
+ * software simulation.
+ */
+
+#define EBI1_CS_N1_TOP		0x30000000
+
+#define SMC911X_PHYS		0x84000000
+#define AUDIO_PHYS		0xa0700000
+#define SSBI_PHYS		0xa8100000
+#define CLK_CTL_PHYS		0xa8600000
+
+#define TLMMADDR_GPIO1_BASE		0xa8e00000
+#define TLMMADDR_GPIO2_BASE		0xa8f00000
+#define TLMMADDR_GPIO1SHDW1_BASE	0xa9000000
+#define TLMMADDR_GPIO2SHDW1_BASE	0xa9100000
+
+#define MSM_UART1_PHYS		0xA9A00000
+#define MSM_UART1_SIZE		(1<<12)
+
+#define MSM_UART2_PHYS		0xA9B00000
+#define MSM_UART2_SIZE		(1<<12)
+
+#define MSM_UART3_PHYS		0xA9C00000
+#define MSM_UART3_SIZE		(1<<12)
+
+#define ADSP6_SIRC		0xab010000
+
+#define MSS_PERIPH_PHYS		0xb8000000
+
+/* Second-level interrupt registers */
+/* These all sit on thier own 4K page */
+/* These are relative to ADSP6_SIRC */
+#define HEXSS_SIRC0_INT_ENABLE		0x0000
+#define HEXSS_SIRC0_INT_ENABLE_CLEAR	0x0004
+#define HEXSS_SIRC0_INT_ENABLE_SET	0x0008
+#define HEXSS_SIRC0_INT_TYPE		0x000C
+#define HEXSS_SIRC0_INT_POLARITY	0x0010
+#define HEXSS_SIRC0_IRQ_STATUS		0x0014
+#define HEXSS_SIRC0_INT_CLEAR		0x0018
+#define HEXSS_SIRC0_SOFT_INT		0x001C
+#define HEXSS_SIRC0_IRQ_PENDING		0x0020
+#define HEXSS_SIRC1_INT_ENABLE		0x0400
+#define HEXSS_SIRC1_INT_ENABLE_CLEAR	0x0404
+#define HEXSS_SIRC1_INT_ENABLE_SET	0x0408
+#define HEXSS_SIRC1_INT_TYPE		0x040C
+#define HEXSS_SIRC1_INT_POLARITY	0x0410
+#define HEXSS_SIRC1_IRQ_STATUS		0x0414
+#define HEXSS_SIRC1_INT_CLEAR		0x0418
+#define HEXSS_SIRC1_SOFT_INT		0x041C
+#define HEXSS_SIRC1_IRQ_PENDING		0x0420
+
+/* QSD8x50 ADSP6 Level One Interrupt Mapping */
+#define L1_ADSP6_ETM		0
+#define L1_ADSP6_ISDB		1
+#define L1_ADSP6_MPRPH		2
+#define L1_ADSP6_RGPTIMER	3
+#define L1_ADSP6_UGPTIMER	4
+#define L1_ADSP6_IPC0		5
+#define L1_ADSP6_IPC1		6
+#define L1_ADSP6_IPC2		7
+#define L1_ADSP6_IPC3		8
+#define L1_ADSP6_IPC4		9
+#define L1_ADSP6_IPC5		10
+#define L1_ADSP6_SPSS		11
+#define L1_ADSP6_AUDIO		12
+#define L1_ADSP6_VIDEO_FE	13
+#define L1_ADSP6_ADM		14
+#define L1_ADSP6_VIDEO_ENC	15
+#define L1_ADSP6_VIDEO_DEC	16
+#define L1_ADSP6_GRAPHICS	17
+#define L1_ADSP6_MDP		18
+#define L1_ADSP6_MDSP4		19
+#define L1_ADSP6_MARM_FIQ	20
+#define L1_ADSP6_MARM_IRQ	21
+#define L1_ADSP6_MARM_RESET	22
+#define L1_ADSP6_SIRC0		23
+#define L1_ADSP6_SIRC1		24
+#define L1_ADSP6_AVS_DONE	25
+
+/* Max number of interrupts per secondary controller */
+#define L2_GROUP_SIZE		32
+
+/* QSD8x50 ADSP6 Level Two Group Zero Interrupt Mapping */
+#define L2_SIRC0_EBI1			0
+#define L2_SIRC0_IMEM			1
+#define L2_SIRC0_SMI			2
+#define L2_SIRC0_AXI			3
+#define L2_SIRC0_PBUS_ERROR		4
+#define L2_SIRC0_TV_ENC			5
+#define L2_SIRC0_EBI2_OP_DONE		6
+#define L2_SIRC0_EBI2_WR_ER_DONE	7
+#define L2_SIRC0_A0_PEN			15
+#define L2_SIRC0_CRYPTO			16
+#define L2_SIRC0_GPIO_GROUP2		18
+#define L2_SIRC0_GPIO_GROUP1		19
+#define L2_SIRC0_MDDI_EXTERN		20
+#define L2_SIRC0_MDDI_PRIMARY		21
+#define L2_SIRC0_MDDI_CLIENT		22
+#define L2_SIRC0_TCHSCRN_I2C		23
+#define L2_SIRC0_TCHSCRN_SRC1		24
+#define L2_SIRC0_TCHSCRN_SRC2		25
+#define L2_SIRC0_TCHSCRN_SSBI		26
+
+/* QSD8x50 ADSP6 Level Two Group One Interrupt Mapping */
+#define L2_SIRC1_USB_FS1	0
+#define L2_SIRC1_USB_HS		1
+#define L2_SIRC1_USB_FS2	2
+#define L2_SIRC1_SDC1_0		3
+#define L2_SIRC1_SDC1_1		4
+#define L2_SIRC1_SDC2_0		5
+#define L2_SIRC1_SDC2_1		6
+#define L2_SIRC1_SDC3_0		7
+#define L2_SIRC1_SDC3_1		8
+#define L2_SIRC1_SDC4_0		9
+#define L2_SIRC1_SDC4_1		10
+#define L2_SIRC1_SPI_OUT	11
+#define L2_SIRC1_SPI_IN		12
+#define L2_SIRC1_SPI_ERR	13
+#define L2_SIRC1_UART1		14
+#define L2_SIRC1_UART1_RX	15
+#define L2_SIRC1_UART2		16
+#define L2_SIRC1_UART2_RX	17
+#define L2_SIRC1_UART3		18
+#define L2_SIRC1_UART3_RX	19
+#define L2_SIRC1_UARTDM1	20
+#define L2_SIRC1_UARTDM1_RX	21
+#define L2_SIRC1_UARTDM2	22
+#define L2_SIRC1_UARTDM2_RX	23
+#define L2_SIRC1_TSIF		24
+
+/* GPIO register offsets. These are relative to TLMMADDR_GPIO1_BASE */
+#define GPIO_OUT_0		0x0000
+#define GPIO_OUT_2		0x0004
+#define GPIO_OUT_3		0x0008
+#define GPIO_OUT_4		0x000C
+#define GPIO_OUT_5		0x0010
+#define GPIO_OUT_6		0x0014
+#define GPIO_OUT_7		0x0018
+#define GPIO_OE_0		0x0020
+#define GPIO_OE_2		0x0024
+#define GPIO_OE_3		0x0028
+#define GPIO_OE_4		0x002C
+#define GPIO_OE_5		0x0030
+#define GPIO_OE_6		0x0034
+#define GPIO_OE_7		0x0038
+#define GPIO1_PAGE		0x0040
+#define GPIO1_CFG		0x0044
+#define GPIO_IN_0		0x0050
+#define GPIO_IN_2		0x0054
+#define GPIO_IN_3		0x0058
+#define GPIO_IN_4		0x005C
+#define GPIO_IN_5		0x0060
+#define GPIO_IN_6		0x0064
+#define GPIO_IN_7		0x0068
+#define GPIO_INT_DETECT_CTL_0	0x0070
+#define GPIO_INT_DETECT_CTL_2	0x0074
+#define GPIO_INT_DETECT_CTL_3	0x0078
+#define GPIO_INT_DETECT_CTL_4	0x007C
+#define GPIO_INT_DETECT_CTL_5	0x0080
+#define GPIO_INT_DETECT_CTL_6	0x0084
+#define GPIO_INT_DETECT_CTL_7	0x0088
+#define GPIO_INT_POLARITY_0	0x0090
+#define GPIO_INT_POLARITY_2	0x0094
+#define GPIO_INT_POLARITY_3	0x0098
+#define GPIO_INT_POLARITY_4	0x009C
+#define GPIO_INT_POLARITY_5	0x00A0
+#define GPIO_INT_POLARITY_6	0x00A4
+#define GPIO_INT_POLARITY_7	0x00A8
+#define GPIO_INT_EN_0		0x00B0
+#define GPIO_INT_EN_2		0x00B4
+#define GPIO_INT_EN_3		0x00B8
+#define GPIO_INT_EN_4		0x00BC
+#define GPIO_INT_EN_5		0x00C0
+#define GPIO_INT_EN_6		0x00C4
+#define GPIO_INT_EN_7		0x00C8
+#define GPIO_INT_CLEAR_0	0x00D0
+#define GPIO_INT_CLEAR_2	0x00D4
+#define GPIO_INT_CLEAR_3	0x00D8
+#define GPIO_INT_CLEAR_4	0x00DC
+#define GPIO_INT_CLEAR_5	0x00E0
+#define GPIO_INT_CLEAR_6	0x00E4
+#define GPIO_INT_CLEAR_7	0x00E8
+#define GPIO_INT_STATUS_0	0x00F0
+#define GPIO_INT_STATUS_2	0x00F4
+#define GPIO_INT_STATUS_3	0x00F8
+#define GPIO_INT_STATUS_4	0x00FC
+#define GPIO_INT_STATUS_5	0x0100
+#define GPIO_INT_STATUS_6	0x0104
+#define GPIO_INT_STATUS_7	0x0108
+
+
+/* Things that are wired up to the GPIO pins */
+#define SPI_CLK_GPIO		17
+#define SPI_DATA_MO_SI		18
+#define SPI_DATA_MI_SO		19
+#define SPI_CS0_N		20
+#define IDE_INT_N		99
+#define EBI2_CS4_N		102
+#define LINE_OUT_HP_DET_N	104
+#define ACCEL_INT		106
+#define USB_DAT			139
+#define USB_SE0			140
+#define USB_OE			141
+#define AUDIO_SDAC_WSOUT	143
+#define AUDIO_SDAC_DOUT		145
+#define AUDIO_MASTER_CLKOUT	146
+#define SPI_CS2_N		147
+#define ENET_MSM_INT		156
+#define SD_CARD_DET_N		157
+
+#endif
+
Index: linux-hexagon-kernel/arch/hexagon/include/asm/platform/comet/irq.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/platform/comet/irq.h	2011-07-20 15:19:44.785151291 -0500
@@ -0,0 +1,25 @@
+/*
+ * Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+#ifndef PLAT_IRQ_H
+#define PLAT_IRQ_H
+
+/* XXX TODO probably should move stuff from comet_iomap.h to here ?? */
+
+#endif
+

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

