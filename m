Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751314Ab1AEBqq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 20:46:46 -0500
Received: from nm4.bullet.mail.sp2.yahoo.com ([98.139.91.74]:25768 "HELO
	nm4.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750933Ab1AEBqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 20:46:44 -0500
X-Yahoo-Newman-Id: 316878.5366.bm@omp1026.mail.sp2.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.ca;
  h=DKIM-Signature:Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:Subject:From:To:Content-Type:Date:Message-ID:Mime-Version:X-Mailer:Content-Transfer-Encoding;
  b=R+d7C2F+t5Uruzq1Q2phM/B4vTXALCXTakT4scUMzVNmJngFp61xaKR8ZVPq9agX/U84IFjRs0EOPxBp5VCQdVixsQ9TuC7Y+QM4q9qN9zkGfCoCqdR+kMF/57WMkxRPbGH6eXAC5mXpsfsdqDoHjEtI4mBsm2dyBeXC8QP89VA=  ;
X-Yahoo-SMTP: izt95ZKswBDBT1bN16dPvD5jLHMKn5IFkJA-
X-YMail-OSG: 2AGE82wVM1ku9C4ODOGJACEe5__VLLSNX6N1vVVJkPA13DI
 nlu7q8gXoa1lFsN4U.w8nEyPzVBry7ZRKQ2KBA5HO2KpWBKs7bqH3mLs5ms1
 XCrF9014PNfuXdVep.ha8Jzarc1_nMtEpvmwgfY1IzQx5h8WpN1UwFfNvj5h
 XG6YL9jL3glHKVF7tlXEJz3jxGmxLXBku8T_n36JuCgrxf0QfSOTUjso_06A
 HuF9Zlv7.dZWfwlITT8YTLdJe1I4HQb35_ZcMCuaAHmp28BnETrvkKMwPqnl
 F9qVHw7Xi7bD.Gbi19F0Io2Vx1VPzUVvrIR7Od98VSuD_qf3Q
X-Yahoo-Newman-Property: ymail-3
Subject: can't resume from ACPI S3 with TICK_ONESHOT
From: "James C. Georgas" <james.georgas@yahoo.ca>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 04 Jan 2011 18:45:39 -0700
Message-ID: <1294191939.3889.49.camel@Tachyon>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If I enable CONFIG_NO_HZ or CONFIG_HIGH_RES_TIMERS, then I can't resume
from the ACPI S3 state (AKA suspend to RAM). The fan starts up, and the
power LED stops blinking and comes back on, but then the fan spins down
again, the screen stays off, and the system is unresponsive to input. I
have to power down by holding the power button for four seconds.

The only thing I can see that both options have in common is that they
both enable CONFIG_TICK_ONESHOT.

Here are my kernel config and dmesg. This config has CONFIG_NO_HZ set. I
get the same result with it unset, and CONFIG_HIGH_RES_TIMERS set
instead.

kernel config:

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.36.2
# Tue Jan  4 17:37:43 2011
#
CONFIG_64BIT=y
# CONFIG_X86_32 is not set
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf64-x86-64"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
# CONFIG_RWSEM_GENERIC_SPINLOCK is not set
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_DEFAULT_IDLE=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
# CONFIG_HAVE_CPUMASK_OF_CPU_MAP is not set
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ZONE_DMA32=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_HAVE_EARLY_RES=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_HARDIRQS_NO__DO_IRQ=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_X86_TRAMPOLINE=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11"
# CONFIG_KTIME_SCALAR is not set
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_CONSTRUCTORS=y

#
# General setup
#
# CONFIG_EXPERIMENTAL is not set
CONFIG_BROKEN_ON_SMP=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
CONFIG_LOCALVERSION="-s2ram"
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_LZO=y
# CONFIG_KERNEL_GZIP is not set
CONFIG_KERNEL_BZIP2=y
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_LZO is not set
# CONFIG_SWAP is not set
# CONFIG_SYSVIPC is not set
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_TASKSTATS is not set
# CONFIG_AUDIT is not set

#
# RCU Subsystem
#
# CONFIG_TREE_RCU is not set
# CONFIG_TREE_PREEMPT_RCU is not set
CONFIG_TINY_RCU=y
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_IKCONFIG is not set
CONFIG_LOG_BUF_SHIFT=15
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
# CONFIG_CGROUPS is not set
# CONFIG_SYSFS_DEPRECATED_V2 is not set
# CONFIG_RELAY is not set
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
# CONFIG_BLK_DEV_INITRD is not set
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
# CONFIG_EMBEDDED is not set
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
# CONFIG_KALLSYMS_EXTRA_PASS is not set
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_PERF_COUNTERS is not set
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_PROFILING is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y

#
# GCOV-based kernel profiling
#
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
# CONFIG_MODULES is not set
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
# CONFIG_BLK_DEV_INTEGRITY is not set

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
# CONFIG_IOSCHED_DEADLINE is not set
CONFIG_IOSCHED_CFQ=y
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
# CONFIG_INLINE_SPIN_TRYLOCK is not set
# CONFIG_INLINE_SPIN_TRYLOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK is not set
# CONFIG_INLINE_SPIN_LOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK_IRQ is not set
# CONFIG_INLINE_SPIN_LOCK_IRQSAVE is not set
# CONFIG_INLINE_SPIN_UNLOCK is not set
# CONFIG_INLINE_SPIN_UNLOCK_BH is not set
# CONFIG_INLINE_SPIN_UNLOCK_IRQ is not set
# CONFIG_INLINE_SPIN_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_READ_TRYLOCK is not set
# CONFIG_INLINE_READ_LOCK is not set
# CONFIG_INLINE_READ_LOCK_BH is not set
# CONFIG_INLINE_READ_LOCK_IRQ is not set
# CONFIG_INLINE_READ_LOCK_IRQSAVE is not set
# CONFIG_INLINE_READ_UNLOCK is not set
# CONFIG_INLINE_READ_UNLOCK_BH is not set
# CONFIG_INLINE_READ_UNLOCK_IRQ is not set
# CONFIG_INLINE_READ_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_WRITE_TRYLOCK is not set
# CONFIG_INLINE_WRITE_LOCK is not set
# CONFIG_INLINE_WRITE_LOCK_BH is not set
# CONFIG_INLINE_WRITE_LOCK_IRQ is not set
# CONFIG_INLINE_WRITE_LOCK_IRQSAVE is not set
# CONFIG_INLINE_WRITE_UNLOCK is not set
# CONFIG_INLINE_WRITE_UNLOCK_BH is not set
# CONFIG_INLINE_WRITE_UNLOCK_IRQ is not set
# CONFIG_INLINE_WRITE_UNLOCK_IRQRESTORE is not set
# CONFIG_MUTEX_SPIN_ON_OWNER is not set
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
# CONFIG_HIGH_RES_TIMERS is not set
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
# CONFIG_SMP is not set
# CONFIG_SPARSE_IRQ is not set
# CONFIG_X86_MPPARSE is not set
# CONFIG_X86_EXTENDED_PLATFORM is not set
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
# CONFIG_PARAVIRT_GUEST is not set
# CONFIG_NO_BOOTMEM is not set
# CONFIG_MEMTEST is not set
CONFIG_MK8=y
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
# CONFIG_GENERIC_CPU is not set
CONFIG_X86_CPU=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_XADD=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_HPET_TIMER=y
CONFIG_DMI=y
CONFIG_GART_IOMMU=y
# CONFIG_AMD_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
# CONFIG_IOMMU_API is not set
CONFIG_NR_CPUS=1
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
# CONFIG_X86_MCE is not set
# CONFIG_I8K is not set
# CONFIG_MICROCODE is not set
# CONFIG_X86_MSR is not set
# CONFIG_X86_CPUID is not set
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
CONFIG_ARCH_PROC_KCORE_TEXT=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER=y
# CONFIG_SPARSEMEM_VMEMMAP is not set
# CONFIG_MEMORY_HOTPLUG is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
# CONFIG_X86_RESERVE_LOW_64K is not set
CONFIG_MTRR=y
# CONFIG_MTRR_SANITIZER is not set
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
# CONFIG_CC_STACKPROTECTOR is not set
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
# CONFIG_SCHED_HRTICK is not set
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x1000000
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
CONFIG_PM_SLEEP=y
CONFIG_SUSPEND_NVS=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
# CONFIG_PM_RUNTIME is not set
CONFIG_PM_OPS=y
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_PROCFS is not set
# CONFIG_ACPI_PROCFS_POWER is not set
# CONFIG_ACPI_SYSFS_POWER is not set
# CONFIG_ACPI_EC_DEBUGFS is not set
# CONFIG_ACPI_PROC_EVENT is not set
# CONFIG_ACPI_AC is not set
# CONFIG_ACPI_BATTERY is not set
# CONFIG_ACPI_BUTTON is not set
# CONFIG_ACPI_FAN is not set
# CONFIG_ACPI_PROCESSOR is not set
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_APEI is not set
# CONFIG_SFI is not set

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_INTEL_IDLE is not set

#
# Memory power savings
#

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
# CONFIG_PCI_MMCONFIG is not set
CONFIG_PCI_DOMAINS=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
CONFIG_PCIEPORTBUS=y
# CONFIG_PCIEAER is not set
CONFIG_PCIEASPM=y
# CONFIG_PCIEASPM_DEBUG is not set
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
# CONFIG_PCI_STUB is not set
# CONFIG_HT_IRQ is not set
# CONFIG_PCI_IOV is not set
CONFIG_PCI_IOAPIC=y
CONFIG_ISA_DMA_API=y
CONFIG_K8_NB=y
# CONFIG_PCCARD is not set
# CONFIG_HOTPLUG_PCI is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
# CONFIG_HAVE_AOUT is not set
# CONFIG_BINFMT_MISC is not set
# CONFIG_IA32_EMULATION is not set
# CONFIG_COMPAT_FOR_U64_ALIGNMENT is not set
CONFIG_NET=y

#
# Networking options
#
# CONFIG_PACKET is not set
CONFIG_UNIX=y
# CONFIG_NET_KEY is not set
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_FIB_HASH=y
# CONFIG_IP_PNP is not set
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE is not set
# CONFIG_ARPD is not set
# CONFIG_SYN_COOKIES is not set
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
# CONFIG_INET_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_BEET is not set
# CONFIG_INET_LRO is not set
# CONFIG_INET_DIAG is not set
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_IPV6 is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETFILTER is not set
# CONFIG_ATM is not set
# CONFIG_L2TP is not set
# CONFIG_BRIDGE is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_PHONET is not set
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
# CONFIG_WIRELESS is not set
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
# CONFIG_CAIF is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH="/sbin/udevadm"
# CONFIG_DEVTMPFS is not set
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_CONNECTOR is not set
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
# CONFIG_BLK_DEV_LOOP is not set

#
# DRBD disabled because PROC_FS, INET or CONNECTOR not selected
#
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_RAM is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_BLK_DEV_HD is not set
# CONFIG_MISC_DEVICES is not set
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_NETLINK is not set
# CONFIG_SCSI_PROC_FS is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
# CONFIG_BLK_DEV_SR is not set
CONFIG_CHR_DEV_SG=y
# CONFIG_CHR_DEV_SCH is not set
# CONFIG_SCSI_MULTI_LUN is not set
# CONFIG_SCSI_CONSTANTS is not set
# CONFIG_SCSI_LOGGING is not set
# CONFIG_SCSI_SCAN_ASYNC is not set

#
# SCSI Transports
#
# CONFIG_SCSI_SPI_ATTRS is not set
# CONFIG_SCSI_FC_ATTRS is not set
# CONFIG_SCSI_ISCSI_ATTRS is not set
# CONFIG_SCSI_SAS_ATTRS is not set
# CONFIG_SCSI_SAS_LIBSAS is not set
# CONFIG_SCSI_SRP_ATTRS is not set
# CONFIG_SCSI_LOWLEVEL is not set
# CONFIG_SCSI_DH is not set
# CONFIG_SCSI_OSD_INITIATOR is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
# CONFIG_ATA_VERBOSE_ERROR is not set
CONFIG_ATA_ACPI=y
# CONFIG_SATA_PMP is not set
#
# Controllers with non-SFF native interface
#
CONFIG_SATA_AHCI=y
# CONFIG_SATA_AHCI_PLATFORM is not set
# CONFIG_SATA_INIC162X is not set
# CONFIG_SATA_SIL24 is not set
# CONFIG_ATA_SFF is not set
# CONFIG_MD is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#

#
# You can enable one or both FireWire driver stacks.
#

#
# The newer stack is recommended.
#
# CONFIG_FIREWIRE is not set
# CONFIG_IEEE1394 is not set
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
# CONFIG_NETDEVICES is not set
# CONFIG_ISDN is not set
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
# CONFIG_INPUT_POLLDEV is not set
# CONFIG_INPUT_SPARSEKMAP is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
# CONFIG_INPUT_EVDEV is not set
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_INPUT_MOUSE is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
# CONFIG_SERIO_SERPORT is not set
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_SERIO_ALTERA_PS2 is not set
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
# CONFIG_VT_HW_CONSOLE_BINDING is not set
# CONFIG_DEVKMEM is not set
# CONFIG_SERIAL_NONSTANDARD is not set

#
# Serial drivers
#
# CONFIG_SERIAL_8250 is not set
CONFIG_FIX_EARLYCON_MEM=y

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MFD_HSU is not set
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
# CONFIG_LEGACY_PTYS is not set
# CONFIG_IPMI_HANDLER is not set
# CONFIG_HW_RANDOM is not set
# CONFIG_NVRAM is not set
# CONFIG_RTC is not set
# CONFIG_GEN_RTC is not set
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_MWAVE is not set
# CONFIG_RAW_DRIVER is not set
# CONFIG_HPET is not set
# CONFIG_HANGCHECK_TIMER is not set
CONFIG_DEVPORT=y
# CONFIG_RAMOOPS is not set
# CONFIG_I2C is not set
# CONFIG_SPI is not set

#
# PPS support
#
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
# CONFIG_GPIOLIB is not set
CONFIG_W1=y

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set

#
# 1-wire Slaves
#
# CONFIG_W1_SLAVE_THERM is not set
# CONFIG_W1_SLAVE_SMEM is not set
# CONFIG_W1_SLAVE_DS2431 is not set
# CONFIG_W1_SLAVE_DS2433 is not set
CONFIG_W1_SLAVE_DS2760=y
# CONFIG_W1_SLAVE_BQ27000 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_TEST_POWER is not set
CONFIG_BATTERY_DS2760=y
# CONFIG_HWMON is not set
CONFIG_THERMAL=y
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
# CONFIG_SSB is not set
# CONFIG_MFD_SUPPORT is not set
# CONFIG_REGULATOR is not set
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set
# CONFIG_DRM is not set
# CONFIG_VGASTATE is not set
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
# CONFIG_FB is not set
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set

#
# Display device support
#
# CONFIG_DISPLAY_SUPPORT is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
# CONFIG_VGACON_SOFT_SCROLLBACK is not set
CONFIG_DUMMY_CONSOLE=y
# CONFIG_SOUND is not set
# CONFIG_HID_SUPPORT is not set
# CONFIG_USB_SUPPORT is not set
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
# CONFIG_NEW_LEDS is not set
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
# CONFIG_RTC_CLASS is not set
# CONFIG_DMADEVICES is not set
# CONFIG_AUXDISPLAY is not set
# CONFIG_UIO is not set
# CONFIG_STAGING is not set
# CONFIG_X86_PLATFORM_DEVICES is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
# CONFIG_DMIID is not set
# CONFIG_ISCSI_IBFT_FIND is not set

#
# File systems
#
# CONFIG_EXT2_FS is not set
# CONFIG_EXT3_FS is not set
CONFIG_EXT4_FS=y
CONFIG_EXT4_USE_FOR_EXT23=y
CONFIG_EXT4_FS_XATTR=y
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
# CONFIG_EXT4_DEBUG is not set
CONFIG_JBD2=y
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
CONFIG_FS_POSIX_ACL=y
# CONFIG_XFS_FS is not set
# CONFIG_OCFS2_FS is not set
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
# CONFIG_DNOTIFY is not set
CONFIG_INOTIFY_USER=y
# CONFIG_QUOTA is not set
# CONFIG_AUTOFS_FS is not set
# CONFIG_AUTOFS4_FS is not set
# CONFIG_FUSE_FS is not set
CONFIG_GENERIC_ACL=y

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# CD-ROM/DVD Filesystems
#
# CONFIG_ISO9660_FS is not set
# CONFIG_UDF_FS is not set

#
# DOS/FAT/NT Filesystems
#
# CONFIG_MSDOS_FS is not set
# CONFIG_VFAT_FS is not set
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=y
# CONFIG_MISC_FILESYSTEMS is not set
CONFIG_NETWORK_FILESYSTEMS=y
# CONFIG_NFS_FS is not set
# CONFIG_NFSD is not set
# CONFIG_SMB_FS is not set
# CONFIG_CIFS is not set
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=y
# CONFIG_NLS is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
# CONFIG_PRINTK_TIME is not set
# CONFIG_ENABLE_WARN_DEPRECATED is not set
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=2048
# CONFIG_MAGIC_SYSRQ is not set
# CONFIG_STRIP_ASM_SYMS is not set
# CONFIG_UNUSED_SYMBOLS is not set
# CONFIG_DEBUG_FS is not set
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_KERNEL is not set
# CONFIG_HARDLOCKUP_DETECTOR is not set
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_ARCH_WANT_FRAME_POINTERS=y
# CONFIG_FRAME_POINTER is not set
# CONFIG_SYSCTL_SYSCALL_CHECK is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_STRICT_DEVMEM is not set
# CONFIG_X86_VERBOSE_BOOTUP is not set
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=0
# CONFIG_OPTIMIZE_INLINING is not set

#
# Security options
#
# CONFIG_KEYS is not set
# CONFIG_SECURITY is not set
# CONFIG_SECURITYFS is not set
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
# CONFIG_CRYPTO is not set
CONFIG_HAVE_KVM=y
# CONFIG_VIRTUALIZATION is not set
# CONFIG_BINARY_PRINTF is not set

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
CONFIG_GENERIC_FIND_LAST_BIT=y
# CONFIG_CRC_CCITT is not set
CONFIG_CRC16=y
# CONFIG_CRC_T10DIF is not set
# CONFIG_CRC_ITU_T is not set
CONFIG_CRC32=y
# CONFIG_CRC7 is not set
# CONFIG_LIBCRC32C is not set
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_NLATTR=y


dmesg:

Linux version 2.6.36.2-s2ram (root@Tachyon) (gcc version 4.4.4 (Gentoo 4.4.4-r2 p1.2, pie-0.4.5) ) #7 PREEMPT Tue Jan 4 17:43:43 MST 2011
Command line: softlevel=s2ram
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009dc00 (usable)
 BIOS-e820: 000000000009dc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000d0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000afe90000 (usable)
 BIOS-e820: 00000000afe90000 - 00000000afead000 (ACPI data)
 BIOS-e820: 00000000afead000 - 00000000afeaf000 (ACPI NVS)
 BIOS-e820: 00000000afeaf000 - 00000000afeff000 (reserved)
 BIOS-e820: 00000000aff00000 - 00000000c0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
NX (Execute Disable) protection: active
DMI present.
e820 update range: 0000000000000000 - 0000000000001000 (usable) ==> (reserved)
e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
No AGP bridge found
last_pfn = 0xafe90 max_arch_pfn = 0x400000000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-BFFFF uncachable
  C0000-CEFFF write-protect
  CF000-DFFFF uncachable
  E0000-FFFFF write-protect
MTRR variable ranges enabled:
  0 base 000000000000 mask FFFF80000000 write-back
  1 base 000080000000 mask FFFFE0000000 write-back
  2 base 0000A0000000 mask FFFFF0000000 write-back
  3 disabled
  4 disabled
  5 disabled
  6 disabled
  7 disabled
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
initial memory mapped : 0 - 20000000
Using GB pages for direct mapping
init_memory_mapping: 0000000000000000-00000000afe90000
 0000000000 - 0080000000 page 1G
 0080000000 - 00afe00000 page 2M
 00afe00000 - 00afe90000 page 4k
kernel direct mapping tables up to afe90000 @ 8000-b000
ACPI: RSDP 00000000000f8000 00024 (v02 PTLTD )
ACPI: XSDT 00000000afe9c821 0007C (v01 ACRSYS ACRPRDCT 06040000 INNA 00000000)
ACPI: FACP 00000000afeac292 000F4 (v03 AMD    GUAM     06040000 AMD  000F4240)
ACPI: DSDT 00000000afe9c89d 0F9F5 (v01    ATI    SB800 06040000 MSFT 03000001)
ACPI: FACS 00000000afeaefc0 00040
ACPI: SLIC 00000000afeac3fa 00176 (v01 ACRSYS ACRPRDCT 06040000 ANNI 00000001)
ACPI: EINJ 00000000afeac570 001B0 (v01 PTL    WHEAPTL  06040000 PTL  00000001)
ACPI: HEST 00000000afeac720 002E4 (v01 PTL    WHEAPTL  06040000 PTL  00000001)
ACPI: BERT 00000000afeaca04 00030 (v01 PTL    WHEAPTL  06040000 PTL  00000001)
ACPI: SSDT 00000000afeaca34 000E1 (v01 wheaos  wheaosc 06040000 INTL 20050624)
ACPI: ERST 00000000afeacb15 00270 (v01 PTL    WHEAPTL  06040000 PTL  00000001)
ACPI: SSDT 00000000afeacd85 001B7 (v01 AMD    POWERNOW 06040000 AMD  00000001)
ACPI: APIC 00000000afeacf3c 00050 (v01 PTLTD  ? APIC   06040000  LTP 00000000)
ACPI: MCFG 00000000afeacf8c 0003C (v01 PTLTD    MCFG   06040000  LTP 00000000)
ACPI: HPET 00000000afeacfc8 00038 (v01 PTLTD  HPETTBL  06040000  LTP 00000001)
ACPI: Local APIC address 0xfee00000
(7/32 early reservations) ==> bootmem [0000000000 - 00afe90000]
  #0 [0001000000 - 00013ae8d0]    TEXT DATA BSS ==> [0001000000 - 00013ae8d0]
  #1 [000009dc00 - 0000100000]    BIOS reserved ==> [000009dc00 - 0000100000]
  #2 [00013af000 - 00013af230]              BRK ==> [00013af000 - 00013af230]
  #3 [0000001000 - 0000003000]       TRAMPOLINE ==> [0000001000 - 0000003000]
  #4 [0000003000 - 0000007000]      ACPI WAKEUP ==> [0000003000 - 0000007000]
  #5 [0000008000 - 000000a000]          PGTABLE ==> [0000008000 - 000000a000]
  #6 [000000a000 - 0000020000]          BOOTMAP ==> [000000a000 - 0000020000]
Zone PFN ranges:
  DMA      0x00000001 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   empty
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000001 -> 0x0000009d
    0: 0x00000100 -> 0x000afe90
On node 0 totalpages: 720428
  DMA zone: 56 pages used for memmap
  DMA zone: 128 pages reserved
  DMA zone: 3812 pages, LIFO batch:0
  DMA32 zone: 9795 pages used for memmap
  DMA32 zone: 706637 pages, LIFO batch:31
ACPI: PM-Timer IO Port: 0x8008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 1, version 33, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 low level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x43538210 base: 0xfed00000
nr_irqs_gsi: 40
Allocating PCI resources starting at c0000000 (gap: c0000000:3ec00000)
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 710449
Kernel command line: softlevel=s2ram
PID hash table entries: 4096 (order: 3, 32768 bytes)
Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
Checking aperture...
No AGP bridge found
Node 0: aperture @ d89c000000 size 32 MB
Aperture beyond 4GB. Ignoring.
Memory: 2832216k/2882112k available (2376k kernel code, 400k absent, 49496k reserved, 940k data, 268k init)
SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
NR_IRQS:288
Extended CMOS year: 2000
Console: colour VGA+ 80x25
console [tty0] enabled
hpet clockevent registered
Fast TSC calibration using PIT
Detected 1695.609 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequency.. 3391.21 BogoMIPS (lpj=1695607)
pid_max: default: 32768 minimum: 301
Mount-cache hash table entries: 256
tseg: 00aff00000
using C1E aware idle routine
Performance Events: AMD PMU driver.
... version:                0
... bit width:              48
... generic registers:      4
... value mask:             0000ffffffffffff
... max period:             00007fffffffffff
... fixed-purpose events:   0
... event mask:             000000000000000f
CPU: AMD Athlon(tm) II Neo K125 Processor stepping 03
ACPI: Core revision 20100702
Setting APIC routing to flat
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
NET: Registered protocol family 16
node 0 link 0: io port [1000, ffff]
TOM: 00000000c0000000 aka 3072M
Fam 10h mmconf [e0000000, efffffff]
node 0 link 0: mmio [a0000, bffff]
node 0 link 0: mmio [c0000000, d01fffff]
node 0 link 0: mmio [d0200000, dfffffff]
node 0 link 0: mmio [e0000000, efffffff] ==> none
node 0 link 0: mmio [f0000000, ff7fffff]
bus: [00, 1f] on node 0 link 0
bus: 00 index 0 [io  0x0000-0xffff]
bus: 00 index 1 [mem 0x000a0000-0x000bffff]
bus: 00 index 2 [mem 0xc0000000-0xdfffffff]
bus: 00 index 3 [mem 0xf0000000-0xfcffffffff]
ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
ACPI: bus type pci registered
PCI: Using configuration type 1 for base access
PCI: Using configuration type 1 for extended access
bio: create slab <bio-0> at 0
ACPI: EC: Look up EC in DSDT
\_SB_:_OSC evaluation returned wrong type
_OSC request data:1 4 
ACPI: BIOS _OSI(Linux) query ignored
ACPI: OEMN 00000000afeadd60 00024 (v01 AMD    NAHP     00000001 MSFT 03000001)
ACPI: Dynamic OEM Table Load:
ACPI: OEMN (null) 00024 (v01 AMD    NAHP     00000001 MSFT 03000001)
System has AMD C1E enabled
Switch to broadcast mode on CPU0
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: EC: GPE = 0x3, I/O: command/status = 0x66, data = 0x62
PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
pci_root PNP0A08:00: host bridge window [mem 0x000d0000-0x000d1fff]
pci_root PNP0A08:00: host bridge window [mem 0x000d2000-0x000d3fff]
pci_root PNP0A08:00: host bridge window [mem 0x000d4000-0x000d5fff]
pci_root PNP0A08:00: host bridge window [mem 0x000d6000-0x000d7fff]
pci_root PNP0A08:00: host bridge window [mem 0x000d8000-0x000d9fff]
pci_root PNP0A08:00: host bridge window [mem 0x000da000-0x000dbfff]
pci_root PNP0A08:00: host bridge window [mem 0x000dc000-0x000ddfff]
pci_root PNP0A08:00: host bridge window [mem 0x000de000-0x000dffff]
pci_root PNP0A08:00: host bridge window [mem 0xc0000000-0xdfffffff]
pci_root PNP0A08:00: host bridge window [mem 0xf0000000-0xffffffff]
pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
pci 0000:00:04.0: PME# supported from D0 D3hot D3cold
pci 0000:00:04.0: PME# disabled
pci 0000:00:05.0: PME# supported from D0 D3hot D3cold
pci 0000:00:05.0: PME# disabled
pci 0000:00:11.0: reg 10: [io  0x8440-0x8447]
pci 0000:00:11.0: reg 14: [io  0x8430-0x8433]
pci 0000:00:11.0: reg 18: [io  0x8420-0x8427]
pci 0000:00:11.0: reg 1c: [io  0x8410-0x8413]
pci 0000:00:11.0: reg 20: [io  0x8400-0x840f]
pci 0000:00:11.0: reg 24: [mem 0xd0607c00-0xd0607fff]
pci 0000:00:12.0: reg 10: [mem 0xd0404000-0xd0404fff]
pci 0000:00:12.2: reg 10: [mem 0xd0607000-0xd06070ff]
pci 0000:00:12.2: supports D1 D2
pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
pci 0000:00:12.2: PME# disabled
pci 0000:00:13.0: reg 10: [mem 0xd0405000-0xd0405fff]
pci 0000:00:13.2: reg 10: [mem 0xd0607400-0xd06074ff]
pci 0000:00:13.2: supports D1 D2
pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
pci 0000:00:13.2: PME# disabled
pci 0000:00:14.1: reg 10: [io  0x0000-0x0007]
pci 0000:00:14.1: reg 14: [io  0x0000-0x0003]
pci 0000:00:14.1: reg 18: [io  0x0000-0x0007]
pci 0000:00:14.1: reg 1c: [io  0x0000-0x0003]
pci 0000:00:14.1: reg 20: [io  0x8450-0x845f]
pci 0000:00:14.2: reg 10: [mem 0xd0400000-0xd0403fff 64bit]
pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
pci 0000:00:14.2: PME# disabled
pci 0000:00:16.0: reg 10: [mem 0xd0406000-0xd0406fff]
pci 0000:00:16.2: reg 10: [mem 0xd0607800-0xd06078ff]
pci 0000:00:16.2: supports D1 D2
pci 0000:00:16.2: PME# supported from D0 D1 D2 D3hot
pci 0000:00:16.2: PME# disabled
pci 0000:01:05.0: reg 10: [mem 0xc0000000-0xcfffffff pref]
pci 0000:01:05.0: reg 14: [io  0x9000-0x90ff]
pci 0000:01:05.0: reg 18: [mem 0xd0100000-0xd010ffff]
pci 0000:01:05.0: reg 24: [mem 0xd0000000-0xd00fffff]
pci 0000:01:05.0: supports D1 D2
pci 0000:01:05.1: reg 10: [mem 0xd0110000-0xd0113fff]
pci 0000:01:05.1: supports D1 D2
pci 0000:00:01.0: PCI bridge to [bus 01-01]
pci 0000:00:01.0:   bridge window [io  0x9000-0x9fff]
pci 0000:00:01.0:   bridge window [mem 0xd0000000-0xd01fffff]
pci 0000:00:01.0:   bridge window [mem 0xc0000000-0xcfffffff 64bit pref]
pci 0000:03:00.0: reg 10: [mem 0xd0200000-0xd023ffff 64bit]
pci 0000:03:00.0: reg 18: [io  0xa000-0xa07f]
pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:03:00.0: PME# disabled
pci 0000:00:04.0: PCI bridge to [bus 03-03]
pci 0000:00:04.0:   bridge window [io  0xa000-0xafff]
pci 0000:00:04.0:   bridge window [mem 0xd0200000-0xd02fffff]
pci 0000:00:04.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:06:00.0: reg 10: [mem 0xd0300000-0xd030ffff 64bit]
pci 0000:06:00.0: supports D1
pci 0000:06:00.0: PME# supported from D0 D1 D3hot
pci 0000:06:00.0: PME# disabled
pci 0000:06:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
pci 0000:00:05.0: PCI bridge to [bus 06-06]
pci 0000:00:05.0:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:00:05.0:   bridge window [mem 0xd0300000-0xd03fffff]
pci 0000:00:05.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:00:14.4: PCI bridge to [bus 07-07] (subtractive decode)
pci 0000:00:14.4:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:00:14.4:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
pci 0000:00:14.4:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:00:14.4:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
pci 0000:00:14.4:   bridge window [mem 0x000d0000-0x000d1fff] (subtractive decode)
pci 0000:00:14.4:   bridge window [mem 0x000d2000-0x000d3fff] (subtractive decode)
pci 0000:00:14.4:   bridge window [mem 0x000d4000-0x000d5fff] (subtractive decode)
pci 0000:00:14.4:   bridge window [mem 0x000d6000-0x000d7fff] (subtractive decode)
pci 0000:00:14.4:   bridge window [mem 0x000d8000-0x000d9fff] (subtractive decode)
pci 0000:00:14.4:   bridge window [mem 0x000da000-0x000dbfff] (subtractive decode)
pci 0000:00:14.4:   bridge window [mem 0x000dc000-0x000ddfff] (subtractive decode)
pci 0000:00:14.4:   bridge window [mem 0x000de000-0x000dffff] (subtractive decode)
pci 0000:00:14.4:   bridge window [mem 0xc0000000-0xdfffffff] (subtractive decode)
pci 0000:00:14.4:   bridge window [mem 0xf0000000-0xffffffff] (subtractive decode)
pci 0000:00:14.4:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
pci 0000:00:14.4:   bridge window [io  0x0d00-0xffff] (subtractive decode)
pci_bus 0000:00: on NUMA node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PB4_._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PB5_._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P_._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGP_._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 10 11) *0
ACPI: PCI Interrupt Link [LNKB] (IRQs 10 11) *0
ACPI: PCI Interrupt Link [LNKC] (IRQs 10 11) *0
ACPI: PCI Interrupt Link [LNKD] (IRQs 10 11) *0
ACPI: PCI Interrupt Link [LNKE] (IRQs 10 11) *0
ACPI: PCI Interrupt Link [LNKF] (IRQs 10 11) *0
ACPI: PCI Interrupt Link [LNKG] (IRQs 10 11) *0
ACPI: PCI Interrupt Link [LNKH] (IRQs 10 11) *0
vgaarb: device added: PCI:0000:01:05.0,decodes=io+mem,owns=io+mem,locks=none
vgaarb: loaded
SCSI subsystem initialized
libata version 3.00 loaded.
PCI: Using ACPI for IRQ routing
PCI: pci_cache_line_size set to 64 bytes
reserve RAM buffer: 000000000009dc00 - 000000000009ffff 
reserve RAM buffer: 00000000afe90000 - 00000000afffffff 
Switching to clocksource tsc
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 10 devices
ACPI: ACPI bus type pnp unregistered
system 00:01: [io  0x0f50-0x0f51] has been reserved
system 00:01: [mem 0xfec00000-0xfec00fff] could not be reserved
system 00:01: [mem 0xfee00000-0xfee00fff] has been reserved
system 00:06: [io  0x0220-0x022f] has been reserved
system 00:06: [io  0x040b] has been reserved
system 00:06: [io  0x04d0-0x04d1] has been reserved
system 00:06: [io  0x04d6] has been reserved
system 00:06: [io  0x0530-0x0537] has been reserved
system 00:06: [io  0x0c00-0x0c01] has been reserved
system 00:06: [io  0x0c14] has been reserved
system 00:06: [io  0x0c50-0x0c52] has been reserved
system 00:06: [io  0x0c6c] has been reserved
system 00:06: [io  0x0c6f] has been reserved
system 00:06: [io  0x0cd0-0x0cd1] has been reserved
system 00:06: [io  0x0cd2-0x0cd3] has been reserved
system 00:06: [io  0x0cd4-0x0cd5] has been reserved
system 00:06: [io  0x0cd6-0x0cd7] has been reserved
system 00:06: [io  0x0cd8-0x0cdf] has been reserved
system 00:06: [io  0x8000-0x805f] has been reserved
system 00:06: [io  0x8100-0x81ff window] has been reserved
system 00:06: [io  0x8200-0x82ff window] has been reserved
system 00:06: [io  0x0f40-0x0f47] has been reserved
system 00:06: [io  0x087f] has been reserved
system 00:06: [mem 0xff800000-0xff800fff] has been reserved
system 00:07: [mem 0x000e0000-0x000fffff] could not be reserved
system 00:07: [mem 0xffe00000-0xffffffff] could not be reserved
system 00:07: [mem 0xfec10000-0xfec1001f] has been reserved
system 00:07: [mem 0xfed00000-0xfed003ff] has been reserved
system 00:07: [mem 0xfed61000-0xfed613ff] has been reserved
system 00:07: [mem 0xfed80000-0xfed80fff] has been reserved
pci 0000:00:01.0: PCI bridge to [bus 01-01]
pci 0000:00:01.0:   bridge window [io  0x9000-0x9fff]
pci 0000:00:01.0:   bridge window [mem 0xd0000000-0xd01fffff]
pci 0000:00:01.0:   bridge window [mem 0xc0000000-0xcfffffff 64bit pref]
pci 0000:00:04.0: PCI bridge to [bus 03-03]
pci 0000:00:04.0:   bridge window [io  0xa000-0xafff]
pci 0000:00:04.0:   bridge window [mem 0xd0200000-0xd02fffff]
pci 0000:00:04.0:   bridge window [mem pref disabled]
pci 0000:00:05.0: PCI bridge to [bus 06-06]
pci 0000:00:05.0:   bridge window [io  disabled]
pci 0000:00:05.0:   bridge window [mem 0xd0300000-0xd03fffff]
pci 0000:00:05.0:   bridge window [mem pref disabled]
pci 0000:00:14.4: PCI bridge to [bus 07-07]
pci 0000:00:14.4:   bridge window [io  disabled]
pci 0000:00:14.4:   bridge window [mem disabled]
pci 0000:00:14.4:   bridge window [mem pref disabled]
pci 0000:00:04.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:04.0: setting latency timer to 64
pci 0000:00:05.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
pci 0000:00:05.0: setting latency timer to 64
pci_bus 0000:00: resource 4 [mem 0x000a0000-0x000bffff]
pci_bus 0000:00: resource 5 [mem 0x000d0000-0x000d1fff]
pci_bus 0000:00: resource 6 [mem 0x000d2000-0x000d3fff]
pci_bus 0000:00: resource 7 [mem 0x000d4000-0x000d5fff]
pci_bus 0000:00: resource 8 [mem 0x000d6000-0x000d7fff]
pci_bus 0000:00: resource 9 [mem 0x000d8000-0x000d9fff]
pci_bus 0000:00: resource 10 [mem 0x000da000-0x000dbfff]
pci_bus 0000:00: resource 11 [mem 0x000dc000-0x000ddfff]
pci_bus 0000:00: resource 12 [mem 0x000de000-0x000dffff]
pci_bus 0000:00: resource 13 [mem 0xc0000000-0xdfffffff]
pci_bus 0000:00: resource 14 [mem 0xf0000000-0xffffffff]
pci_bus 0000:00: resource 15 [io  0x0000-0x0cf7]
pci_bus 0000:00: resource 16 [io  0x0d00-0xffff]
pci_bus 0000:01: resource 0 [io  0x9000-0x9fff]
pci_bus 0000:01: resource 1 [mem 0xd0000000-0xd01fffff]
pci_bus 0000:01: resource 2 [mem 0xc0000000-0xcfffffff 64bit pref]
pci_bus 0000:03: resource 0 [io  0xa000-0xafff]
pci_bus 0000:03: resource 1 [mem 0xd0200000-0xd02fffff]
pci_bus 0000:06: resource 1 [mem 0xd0300000-0xd03fffff]
pci_bus 0000:07: resource 4 [mem 0x000a0000-0x000bffff]
pci_bus 0000:07: resource 5 [mem 0x000d0000-0x000d1fff]
pci_bus 0000:07: resource 6 [mem 0x000d2000-0x000d3fff]
pci_bus 0000:07: resource 7 [mem 0x000d4000-0x000d5fff]
pci_bus 0000:07: resource 8 [mem 0x000d6000-0x000d7fff]
pci_bus 0000:07: resource 9 [mem 0x000d8000-0x000d9fff]
pci_bus 0000:07: resource 10 [mem 0x000da000-0x000dbfff]
pci_bus 0000:07: resource 11 [mem 0x000dc000-0x000ddfff]
pci_bus 0000:07: resource 12 [mem 0x000de000-0x000dffff]
pci_bus 0000:07: resource 13 [mem 0xc0000000-0xdfffffff]
pci_bus 0000:07: resource 14 [mem 0xf0000000-0xffffffff]
pci_bus 0000:07: resource 15 [io  0x0000-0x0cf7]
pci_bus 0000:07: resource 16 [io  0x0d00-0xffff]
NET: Registered protocol family 2
IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
UDP hash table entries: 2048 (order: 4, 65536 bytes)
UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
NET: Registered protocol family 1
pci 0000:00:01.0: MSI quirk detected; subordinate MSI disabled
pci 0000:01:05.0: Boot video device
PCI: CLS 32 bytes, default 64
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
io scheduler noop registered
io scheduler cfq registered (default)
pcieport 0000:00:04.0: ACPI _OSC control granted for 0x14
pcieport 0000:00:04.0: setting latency timer to 64
pcieport 0000:00:04.0: irq 40 for MSI/MSI-X
pcieport 0000:00:05.0: ACPI _OSC control granted for 0x14
pcieport 0000:00:05.0: setting latency timer to 64
pcieport 0000:00:05.0: irq 41 for MSI/MSI-X
ahci 0000:00:11.0: version 3.0
ahci 0000:00:11.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
ahci 0000:00:11.0: irq 42 for MSI/MSI-X
ahci 0000:00:11.0: AHCI 0001.0200 32 slots 1 ports 6 Gbps 0x1 impl SATA mode
ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part 
scsi0 : ahci
ata1: SATA max UDMA/133 abar m1024@0xd0607c00 port 0xd0607d00 irq 42
PNP: PS/2 Controller [PNP0303:KBD0,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
Driver for 1-wire Dallas network protocol.
1-Wire driver for the DS2760 battery monitor  chip  - (c) 2004-2005, Szabolcs Gyurko
cpuidle: using governor ladder
cpuidle: using governor menu
TCP cubic registered
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1.00: ATA-8: WDC WD3200BEVT-22A23T0, 01.01A01, max UDMA/133
ata1.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
ata1.00: configured for UDMA/133
scsi 0:0:0:0: Direct-Access     ATA      WDC WD3200BEVT-2 01.0 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 625142448 512-byte logical blocks: (320 GB/298 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: Attached scsi generic sg0 type 0
 sda: sda1 sda2 < sda5 sda6 >
sd 0:0:0:0: [sda] Attached SCSI disk
EXT4-fs (sda5): mounted filesystem with ordered data mode. Opts: (null)
VFS: Mounted root (ext2 filesystem) readonly on device 8:5.
Freeing unused kernel memory: 268k freed
Switched to NOHz mode on CPU #0
udev: starting version 151
udevd (553): /proc/553/oom_adj is deprecated, please use /proc/553/oom_score_adj instead.
EXT4-fs (sda5): re-mounted. Opts: (null)


