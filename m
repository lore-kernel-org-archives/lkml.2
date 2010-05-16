Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587Ab0EPVdq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 17:33:46 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:40557 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754441Ab0EPVdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 17:33:41 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+3aIibppu0283ogF9SEP3jB5hhK4SMg==
X-RZG-CLASS-ID: mo00
Date: Sun, 16 May 2010 23:33:33 +0200
From: Olaf Hering <olaf@aepfle.de>
To: linux-kernel@vger.kernel.org
Subject: qemu/nfsroot: BUG: sleeping function called from invalid context
 at 2.6.33.3-rt19-i686-pc/kernel/rtmutex.c:684
Message-ID: <20100516213333.GA27132@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Running 2.6.33.3-rt19 in qemu with nfsroot floods dmesg with lots of
warnings like

BUG: sleeping function called from invalid context at /opt/cross/sys-root/i686-linux/usr/src/linux-2.6.33-i686-kernel-source/kernel/rtmutex.c:684

This happens already when the kernel mounts the nfsroot filesystem,
if I interpret the dmesg output below correctly.

Any idea how to fix the reported BUG?

qemu is started like this:

qemu-system-i386 -no-reboot -M pc -m 64M \
-kernel /opt/cross/sys-root/i686-linux/boot/bzImage-i686-pc-2.6.33 \
-append 'console=ttyS0 quiet panic=1 nfsroot=1.1.1.1:/opt/cross/sys-root/i686-linux,tcp rw ip=dhcp' \
-serial stdio -vnc 127.0.0.1:1 -net nic -net tap,ifname=tap0 -nographic

I have these options enabled:

CONFIG_X86_32=y
CONFIG_X86=y
CONFIG_OUTPUT_FORMAT="elf32-i386"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/i386_defconfig"
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_RWSEM_GENERIC_SPINLOCK=y
CONFIG_ASM_SEMAPHORES=y
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_DEFAULT_IDLE=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_HARDIRQS_NO__DO_IRQ=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_X86_32_LAZY_GS=y
CONFIG_KTIME_SCALAR=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_CONSTRUCTORS=y
CONFIG_EXPERIMENTAL=y
CONFIG_BROKEN_ON_SMP=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION="-i686-pc"
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_KERNEL_GZIP=y
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
CONFIG_TREE_PREEMPT_RCU=y
CONFIG_RCU_FANOUT=32
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=21
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_NAMESPACES=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_LZO=y
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
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
CONFIG_PERF_EVENTS=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
CONFIG_SLAB=y
CONFIG_HAVE_OPROFILE=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
CONFIG_MODULE_UNLOAD=y
CONFIG_MODVERSIONS=y
CONFIG_BLOCK=y
CONFIG_LBDAF=y
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
CONFIG_DEFAULT_CFQ=y
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_FREEZER=y
CONFIG_TICK_ONESHOT=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_M686=y
CONFIG_X86_CPU=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=5
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=5
CONFIG_X86_XADD=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INVLPG=y
CONFIG_X86_BSWAP=y
CONFIG_X86_POPAD_OK=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=5
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_CYRIX_32=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_TRANSMETA_32=y
CONFIG_CPU_SUP_UMC_32=y
CONFIG_HPET_TIMER=y
CONFIG_DMI=y
CONFIG_NR_CPUS=1
CONFIG_PREEMPT_RT=y
CONFIG_PREEMPT=y
CONFIG_PREEMPT_SOFTIRQS=y
CONFIG_PREEMPT_HARDIRQS=y
CONFIG_VM86=y
CONFIG_HIGHMEM4G=y
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_HIGHMEM=y
CONFIG_NEED_NODE_MEMMAP_SIZE=y
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_SPLIT_PTLOCK_CPUS=999999
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_HZ_100=y
CONFIG_HZ=100
CONFIG_SCHED_HRTICK=y
CONFIG_PHYSICAL_START=0x1000000
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_PM=y
CONFIG_PM_SLEEP=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_PROCFS_POWER=y
CONFIG_ACPI_SYSFS_POWER=y
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_FAN=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_BLACKLIST_YEAR=0
CONFIG_X86_PM_TIMER=y
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_PCI=y
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCI_IOAPIC=y
CONFIG_ISA_DMA_API=y
CONFIG_BINFMT_ELF=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
CONFIG_HAVE_AOUT=y
CONFIG_BINFMT_MISC=y
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_NET=y
CONFIG_PACKET=y
CONFIG_PACKET_MMAP=y
CONFIG_UNIX=y
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_FIB_HASH=y
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
CONFIG_IP_PNP_BOOTP=y
CONFIG_INET_LRO=y
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
CONFIG_STANDALONE=y
CONFIG_FW_LOADER=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_LOOP=m
CONFIG_VIRTIO_BLK=y
CONFIG_HAVE_IDE=y
CONFIG_NETDEVICES=y
CONFIG_NET_ETHERNET=y
CONFIG_MII=y
CONFIG_NET_PCI=y
CONFIG_PCNET32=y
CONFIG_NE2K_PCI=y
CONFIG_NETDEV_1000=y
CONFIG_E1000=y
CONFIG_SKY2=y
CONFIG_VIRTIO_NET=y
CONFIG_INPUT=y
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_LIBPS2=y
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
CONFIG_DEVKMEM=y
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_UNIX98_PTYS=y
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=y
CONFIG_NVRAM=y
CONFIG_GEN_RTC=y
CONFIG_DEVPORT=y
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_POWER_SUPPLY=y
CONFIG_THERMAL=y
CONFIG_SSB_POSSIBLE=y
CONFIG_VGA_ARB=y
CONFIG_FB=y
CONFIG_FB_BOOT_VESA_SUPPORT=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
CONFIG_FB_VESA=y
CONFIG_VGA_CONSOLE=y
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
CONFIG_LOGO=y
CONFIG_LOGO_LINUX_CLUT224=y
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_FILE_LOCKING=y
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_MISC_FILESYSTEMS=y
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=y
CONFIG_NFS_V3=y
CONFIG_ROOT_NFS=y
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
CONFIG_MSDOS_PARTITION=y
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_FRAME_WARN=1024
CONFIG_MAGIC_SYSRQ=y
CONFIG_DEBUG_KERNEL=y
CONFIG_DETECT_SOFTLOCKUP=y
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
CONFIG_DETECT_HUNG_TASK=y
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_PI_LIST=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
CONFIG_TRACE_IRQFLAGS=y
CONFIG_DEBUG_SPINLOCK_SLEEP=y
CONFIG_STACKTRACE=y
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_TRACING_SUPPORT=y
CONFIG_HAVE_ARCH_KGDB=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
CONFIG_DEBUG_RODATA=y
CONFIG_DEBUG_RODATA_TEST=y
CONFIG_4KSTACKS=y
CONFIG_DOUBLEFAULT=y
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
CONFIG_DEFAULT_IO_DELAY_TYPE=0
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
CONFIG_VIRTIO=y
CONFIG_VIRTIO_RING=y
CONFIG_VIRTIO_BALLOON=y
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
CONFIG_GENERIC_FIND_LAST_BIT=y
CONFIG_CRC32=y
CONFIG_ZLIB_INFLATE=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_NLATTR=y

Linux version 2.6.33.3-rt19-i686-pc (abuild@build32) (gcc version 4.4.4 (GCC) ) #1 PREEMPT RT Sun May 16 17:04:43 UTC 2010
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
 BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e8000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 0000000003ff0000 (usable)
 BIOS-e820: 0000000003ff0000 - 0000000004000000 (ACPI data)
 BIOS-e820: 00000000fffc0000 - 0000000100000000 (reserved)
Notice: NX (Execute Disable) protection missing in CPU or disabled in BIOS!
DMI 2.4 present.
last_pfn = 0x3ff0 max_arch_pfn = 0x100000
initial memory mapped : 0 - 01c00000
init_memory_mapping: 0000000000000000-0000000003ff0000
 0000000000 - 0000400000 page 4k
 0000400000 - 0003c00000 page 2M
 0003c00000 - 0003ff0000 page 4k
kernel direct mapping tables up to 3ff0000 @ 7000-c000
ACPI: RSDP 000fbbf0 00014 (v00 QEMU  )
ACPI: RSDT 03ff0000 00034 (v01 QEMU   QEMURSDT 00000001 QEMU 00000001)
ACPI: FACP 03ff0038 00074 (v01 QEMU   QEMUFACP 00000001 QEMU 00000001)
ACPI: DSDT 03ff0100 0080D (v01   BXPC   BXDSDT 00000001 INTL 20061109)
ACPI: FACS 03ff00c0 00040
ACPI: APIC 03ff0948 0004A (v01 QEMU   QEMUAPIC 00000001 QEMU 00000001)
ACPI: SSDT 03ff090d 00037 (v01 QEMU   QEMUSSDT 00000001 QEMU 00000001)
ACPI: HPET 03ff0998 00038 (v01 QEMU   QEMUHPET 00000001 QEMU 00000001)
0MB HIGHMEM available.
63MB LOWMEM available.
  mapped low ram: 0 - 03ff0000
  low ram: 0 - 03ff0000
  node 0 low ram: 00000000 - 03ff0000
  node 0 bootmap 00005000 - 00005800
(7 early reservations) ==> bootmem [0000000000 - 0003ff0000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0001000000 - 0001a22f5c]    TEXT DATA BSS ==> [0001000000 - 0001a22f5c]
  #2 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
  #3 [0001a23000 - 0001a2a03d]              BRK ==> [0001a23000 - 0001a2a03d]
  #4 [0000001000 - 0000005000]      ACPI WAKEUP ==> [0000001000 - 0000005000]
  #5 [0000007000 - 0000008000]          PGTABLE ==> [0000007000 - 0000008000]
  #6 [0000005000 - 0000006000]          BOOTMAP ==> [0000005000 - 0000006000]
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  Normal   0x00001000 -> 0x00003ff0
  HighMem  0x00003ff0 -> 0x00003ff0
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000000 -> 0x0000009f
    0: 0x00000100 -> 0x00003ff0
On node 0 totalpages: 16271
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 3967 pages, LIFO batch:0
  Normal zone: 96 pages used for memmap
  Normal zone: 12176 pages, LIFO batch:1
ACPI: PM-Timer IO Port: 0xb008
ACPI: HPET id: 0x8086a201 base: 0xfed00000
Allocating PCI resources starting at 4000000 (gap: 4000000:fbfc0000)
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 16143
Kernel command line: console=ttyS0 quiet panic=1 nfsroot=1.1.1.1:/opt/cross/sys-root/i686-linux,tcp rw ip=dhcp
PID hash table entries: 256 (order: -2, 1024 bytes)
Dentry cache hash table entries: 8192 (order: 7, 786432 bytes)
Inode-cache hash table entries: 4096 (order: 6, 393216 bytes)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
Initializing HighMem for node 0 (00000000:00000000)
Memory: 52944k/65472k available (1851k kernel code, 12116k reserved, 1102k data, 272k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xfffe5000 - 0xfffff000   ( 104 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xc47f0000 - 0xff7fe000   ( 944 MB)
    lowmem  : 0xc0000000 - 0xc3ff0000   (  63 MB)
      .init : 0xc12e3000 - 0xc1327000   ( 272 kB)
      .data : 0xc11cedd7 - 0xc12e28bc   (1102 kB)
      .text : 0xc1000000 - 0xc11cedd7   (1851 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
Real-Time Preemption Support (C) 2004-2007 Ingo Molnar
Experimental preemptable hierarchical RCU implementation.
NR_IRQS:16
CPU 0 irqstacks, hard=c12b9000 soft=c12ba000
Console: colour VGA+ 80x25
console [ttyS0] enabled
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
... MAX_LOCKDEP_SUBCLASSES:  8
... MAX_LOCK_DEPTH:          48
... MAX_LOCKDEP_KEYS:        8191
... CLASSHASH_SIZE:          4096
... MAX_LOCKDEP_ENTRIES:     16384
... MAX_LOCKDEP_CHAINS:      32768
... CHAINHASH_SIZE:          16384
 memory used by lock dependency info: 3567 kB
 per task-struct memory footprint: 1152 bytes
hpet clockevent registered
Fast TSC calibration failed
TSC: Unable to calibrate against PIT
TSC: using HPET reference calibration
Detected 1861.938 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequency.. 3723.87 BogoMIPS (lpj=18619380)
Mount-cache hash table entries: 512
Performance Events: p6 PMU driver.
... version:                0
... bit width:              32
... generic registers:      2
... value mask:             00000000ffffffff
... max period:             000000007fffffff
... fixed-purpose events:   0
... event mask:             0000000000000003
CPU: Intel Pentium II (Klamath) stepping 03
Checking 'hlt' instruction... OK.
ACPI: Core revision 20091214
ACPI: setting ELCR to 0200 (from 0a00)
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xfb430, last bus=0
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S5)
ACPI: Using PIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci_root PNP0A03:00: ignoring host bridge windows from ACPI; boot with "pci=use_crs" to use them
pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
pci_root PNP0A03:00: host bridge window [mem 0xe0000000-0xfebfffff] (ignored)
pci 0000:00:01.1: reg 20: [io  0xc000-0xc00f]
pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
pci 0000:00:02.0: reg 10: [mem 0xf0000000-0xf1ffffff pref]
pci 0000:00:02.0: reg 14: [mem 0xf2000000-0xf2000fff]
pci 0000:00:03.0: reg 10: [io  0xc100-0xc1ff]
pci 0000:00:04.0: reg 10: [io  0xc200-0xc21f]
pci_bus 0000:00: on NUMA node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *9 10 11 12)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11 12)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 *9 10 11 12)
vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
vgaarb: loaded
PCI: Using ACPI for IRQ routing
PCI: pci_cache_line_size set to 32 bytes
Switching to clocksource tsc
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 7 devices
ACPI: ACPI bus type pnp unregistered
pci_bus 0000:00: resource 0 [io  0x0000-0xffff]
pci_bus 0000:00: resource 1 [mem 0x00000000-0xffffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 1024 (order: 0, 4096 bytes)
TCP established hash table entries: 2048 (order: 2, 16384 bytes)
TCP bind hash table entries: 2048 (order: 5, 196608 bytes)
TCP: Hash tables configured (established 2048 bind 2048)
TCP reno registered
UDP hash table entries: 32 (order: 0, 6656 bytes)
UDP-Lite hash table entries: 32 (order: 0, 6656 bytes)
NET: Registered protocol family 1
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
RPC: Registered tcp NFSv4.1 backchannel transport module.
pci 0000:00:00.0: Limiting direct PCI/PCI transfers
pci 0000:00:01.0: PIIX3: Enabling Passive Release
pci 0000:00:01.0: Activating ISA DMA hang workarounds
pci 0000:00:02.0: Boot video device
PCI: CLS 0 bytes, default 32
msgmni has been set to 103
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
ACPI: Power Button [PWRF]
Generic RTC Driver v1.07
Non-volatile memory driver v1.3
Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Intel(R) PRO/1000 Network Driver - version 7.3.21-k5-NAPI
Copyright (c) 1999-2006 Intel Corporation.
ne2k-pci.c:v1.03 9/22/2003 D. Becker/P. Gortmaker
ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
PCI: setting IRQ 11 as level-triggered
ne2k-pci 0000:00:03.0: PCI INT A -> Link[LNKC] -> GSI 11 (level, low) -> IRQ 11
eth0: RealTek RTL-8029 found at 0xc100, IRQ 11, 52:54:00:12:34:56.
pcnet32.c:v1.35 21.Apr.2008 tsbogend@alpha.franken.de
sky2 driver version 1.26
PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
cpuidle: using governor ladder
TCP cubic registered
NET: Registered protocol family 17
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
Sending DHCP requests .
spurious 8259A interrupt: IRQ15.
, OK
IP-Config: Got DHCP answer from 1.1.1.1, my address is 1.1.1.11
IP-Config: Complete:
     device=eth0, addr=1.1.1.11, mask=255.255.255.0, gw=1.1.1.1,
     host=qemuclient, domain=easybox, nis-domain=(none),
     bootserver=1.1.1.1, rootserver=1.1.1.1, rootpath=
Looking up port of RPC 100003/2 on 1.1.1.1
Looking up port of RPC 100005/1 on 1.1.1.1
VFS: Mounted root (nfs filesystem) on device 0:11.
*****************************************************************************
*                                                                           *
*  REMINDER, the following debugging options are turned on in your .config: *
*                                                                           *
*        CONFIG_DEBUG_RT_MUTEXES                                            *
*        CONFIG_LOCKDEP                                                     *
*                                                                           *
*  they may increase runtime overhead and latencies.                        *
*                                                                           *
*****************************************************************************
Freeing unused kernel memory: 272k freed
Write protecting the kernel text: 1852k
Write protecting the kernel read-only data: 928k
BUG: sleeping function called from invalid context at /opt/cross/sys-root/i686-linux/usr/src/linux-2.6.33-i686-kernel-source/kernel/rtmutex.c:684
pcnt: 0 0 in_atomic(): 0, irqs_disabled(): 1, pid: 1, name: swapper
4 locks held by swapper/1:
 #0:  (&sb->s_type->i_mutex_key#3){+.+.+.}, at: [<c10708c7>] do_lookup+0x8c/0x17b
 #1:  (sk_lock-AF_INET-RPC){+.+...}, at: [<c118a284>] tcp_sendmsg+0x17/0x8b1
 #2:  (rcu_read_lock){.+.+..}, at: [<c116d1ad>] dev_queue_xmit+0x19c/0x431
 #3:  (_xmit_ETHER#2){+.+...}, at: [<c11783f7>] sch_direct_xmit+0x29/0x132
irq event stamp: 206392
hardirqs last  enabled at (206391): [<c11cdda1>] _raw_spin_unlock_irqrestore+0x36/0x51
hardirqs last disabled at (206392): [<c11492e0>] ei_start_xmit+0x92/0x266
softirqs last  enabled at (0): [<c1017f09>] copy_process+0x2f9/0xff2
softirqs last disabled at (0): [<(null)>] (null)
Pid: 1, comm: swapper Not tainted 2.6.33.3-rt19-i686-pc #1
Call Trace:
 [<c1014af5>] __might_sleep+0xd1/0xd9
 [<c11cd697>] rt_spin_lock+0x25/0x62
 [<c11492e8>] ei_start_xmit+0x9a/0x266
 [<c116ce8b>] dev_hard_start_xmit+0x24d/0x2ec
 [<c1178416>] sch_direct_xmit+0x48/0x132
 [<c11cd6cc>] ? rt_spin_lock+0x5a/0x62
 [<c116d2d9>] dev_queue_xmit+0x2c8/0x431
 [<c103c330>] ? is_module_text_address+0x14/0x34
 [<c118416d>] ip_finish_output+0x1fa/0x235
 [<c1184200>] ip_output+0x58/0x5d
 [<c118266c>] ip_local_out+0x51/0x55
 [<c1183c23>] ip_queue_xmit+0x298/0x2ce
 [<c1195c44>] ? tcp_v4_send_check+0x7d/0xb1
 [<c119298a>] tcp_transmit_skb+0x605/0x63b
 [<c11cdda1>] ? _raw_spin_unlock_irqrestore+0x36/0x51
 [<c1034f02>] ? trace_hardirqs_on_caller+0xfe/0x11f
 [<c1194acb>] tcp_write_xmit+0x756/0x834
 [<c1067c35>] ? __kmalloc+0xe1/0x135
 [<c1194bf6>] __tcp_push_pending_frames+0x21/0x75
 [<c118aa47>] tcp_sendmsg+0x7da/0x8b1
 [<c103c1ef>] ? __module_text_address+0xb/0x44
 [<c1160afe>] sock_sendmsg+0xa4/0xba
 [<c1004124>] ? dump_trace+0x73/0xa3
 [<c1009c4a>] ? save_stack_trace+0x1c/0x38
 [<c1034027>] ? save_trace+0x37/0xa0
 [<c1036ed0>] ? __lock_acquire+0x112d/0x130c
 [<c1020d92>] ? lock_timer_base+0x28/0x40
 [<c1160b3c>] kernel_sendmsg+0x28/0x37
 [<c11b49af>] xs_send_kvec+0x6d/0x77
 [<c11b4a1b>] xs_sendpages+0x62/0x172
 [<c11cd027>] ? rt_spin_lock_slowunlock+0x3b/0x5e
 [<c11b4c0c>] xs_tcp_send_request+0x41/0x117
 [<c11b336d>] xprt_transmit+0x156/0x250
 [<c11b1168>] call_transmit+0x1b2/0x1ed
 [<c11b6cc6>] __rpc_execute+0x6e/0x1f6
 [<c11b6e64>] rpc_execute+0x16/0x19
 [<c11b1972>] rpc_run_task+0x3a/0x42
 [<c11b1a59>] rpc_call_sync+0x3d/0x58
 [<c10ae9dd>] nfs_proc_lookup+0x7f/0xa1
 [<c10a5870>] nfs_lookup+0xee/0x16e
 [<c1009c4a>] ? save_stack_trace+0x1c/0x38
 [<c1034cd5>] ? mark_held_locks+0x43/0x5b
 [<c11cdda1>] ? _raw_spin_unlock_irqrestore+0x36/0x51
 [<c1034f02>] ? trace_hardirqs_on_caller+0xfe/0x11f
 [<c1034f2e>] ? trace_hardirqs_on+0xb/0xd
 [<c11cd027>] ? rt_spin_lock_slowunlock+0x3b/0x5e
 [<c11cd70a>] ? rt_spin_unlock+0x36/0x39
 [<c10789f7>] ? d_alloc+0x1a0/0x1a9
 [<c1070909>] do_lookup+0xce/0x17b
 [<c1071a0f>] link_path_walk+0x1e5/0x906
 [<c1072235>] path_walk+0x39/0x83
 [<c1070d5e>] ? path_init+0x6d/0x10d
 [<c107240d>] do_path_lookup+0x12e/0x14f
 [<c1072e44>] do_filp_open+0xd7/0x753
 [<c1034f02>] ? trace_hardirqs_on_caller+0xfe/0x11f
 [<c11cd027>] ? rt_spin_lock_slowunlock+0x3b/0x5e
 [<c11cd70a>] ? rt_spin_unlock+0x36/0x39
 [<c10687bb>] do_sys_open+0x40/0x76
 [<c1068833>] sys_open+0x1e/0x26
 [<c12e31b1>] ? kernel_init+0x0/0x163
 [<c1001274>] init_post+0x3e/0xfa
 [<c12e330d>] kernel_init+0x15c/0x163
 [<c1002c5a>] kernel_thread_helper+0x6/0x10
BUG: sleeping function called from invalid context at /opt/cross/sys-root/i686-linux/usr/src/linux-2.6.33-i686-kernel-source/kernel/rtmutex.c:684
pcnt: 0 0 in_atomic(): 0, irqs_disabled(): 1, pid: 1, name: init
3 locks held by init/1:
 #0:  (&mm->mmap_sem){+++++.}, at: [<c10102aa>] do_page_fault+0xf4/0x29b
 #1:  (rcu_read_lock){.+.+..}, at: [<c116d1ad>] dev_queue_xmit+0x19c/0x431
 #2:  (_xmit_ETHER#2){+.+...}, at: [<c11783f7>] sch_direct_xmit+0x29/0x132
irq event stamp: 245364
hardirqs last  enabled at (245363): [<c11cdda1>] _raw_spin_unlock_irqrestore+0x36/0x51
hardirqs last disabled at (245364): [<c11492e0>] ei_start_xmit+0x92/0x266
softirqs last  enabled at (0): [<c1017f09>] copy_process+0x2f9/0xff2
softirqs last disabled at (0): [<(null)>] (null)
Pid: 1, comm: init Not tainted 2.6.33.3-rt19-i686-pc #1
Call Trace:
 [<c1014af5>] __might_sleep+0xd1/0xd9
 [<c11cd697>] rt_spin_lock+0x25/0x62
 [<c11492e8>] ei_start_xmit+0x9a/0x266
 [<c116ce8b>] dev_hard_start_xmit+0x24d/0x2ec
 [<c1178416>] sch_direct_xmit+0x48/0x132
 [<c11cd6cc>] ? rt_spin_lock+0x5a/0x62
 [<c116d2d9>] dev_queue_xmit+0x2c8/0x431
 [<c118416d>] ip_finish_output+0x1fa/0x235
 [<c1184200>] ip_output+0x58/0x5d
 [<c118266c>] ip_local_out+0x51/0x55
 [<c1183c23>] ip_queue_xmit+0x298/0x2ce
 [<c11cdda1>] ? _raw_spin_unlock_irqrestore+0x36/0x51
 [<c1034f02>] ? trace_hardirqs_on_caller+0xfe/0x11f
 [<c1034f2e>] ? trace_hardirqs_on+0xb/0xd
 [<c1195c44>] ? tcp_v4_send_check+0x7d/0xb1
 [<c119298a>] tcp_transmit_skb+0x605/0x63b
 [<c1067c35>] ? __kmalloc+0xe1/0x135
 [<c1192b3e>] tcp_send_ack+0xdd/0xe5
 [<c118e00a>] __tcp_ack_snd_check+0x5e/0x73
 [<c1191a11>] tcp_rcv_established+0x3ca/0x525
 [<c1196a31>] tcp_v4_do_rcv+0x21/0x148
 [<c1162c0b>] release_sock+0x68/0xde
 [<c118aa4e>] tcp_sendmsg+0x7e1/0x8b1
 [<c11cd027>] ? rt_spin_lock_slowunlock+0x3b/0x5e
 [<c1160afe>] sock_sendmsg+0xa4/0xba
 [<c1160b3c>] kernel_sendmsg+0x28/0x37
 [<c11b49af>] xs_send_kvec+0x6d/0x77
 [<c11b4a1b>] xs_sendpages+0x62/0x172
 [<c11cd027>] ? rt_spin_lock_slowunlock+0x3b/0x5e
 [<c11b4c0c>] xs_tcp_send_request+0x41/0x117
 [<c11b336d>] xprt_transmit+0x156/0x250
 [<c11b1168>] call_transmit+0x1b2/0x1ed
 [<c11b6cc6>] __rpc_execute+0x6e/0x1f6
 [<c11b6e64>] rpc_execute+0x16/0x19
 [<c11b1972>] rpc_run_task+0x3a/0x42
 [<c10afcd9>] nfs_read_rpcsetup+0x1b5/0x1cf
 [<c104b6c7>] ? mempool_alloc_slab+0xe/0x10
 [<c104b7d7>] ? mempool_alloc+0x4e/0xdc
 [<c10b016e>] nfs_pagein_one+0x7f/0xb4
 [<c10ae161>] nfs_pageio_doio+0x27/0x4f
 [<c10ae23b>] nfs_pageio_add_request+0xb2/0xc5
 [<c10afa5b>] readpage_async_filler+0xc3/0x10d
 [<c105019f>] read_cache_pages+0x64/0xad
 [<c10af998>] ? readpage_async_filler+0x0/0x10d
 [<c10af807>] nfs_readpages+0xee/0x148
 [<c10b00ef>] ? nfs_pagein_one+0x0/0xb4
 [<c10af719>] ? nfs_readpages+0x0/0x148
 [<c104fceb>] __do_page_cache_readahead+0x14c/0x1c5
 [<c104fd7b>] ra_submit+0x17/0x1c
 [<c104af87>] filemap_fault+0x1c5/0x373
 [<c105a6b9>] __do_fault+0x3b/0x373
 [<c105b210>] handle_mm_fault+0x256/0x509
 [<c10102aa>] ? do_page_fault+0xf4/0x29b
 [<c101043b>] do_page_fault+0x285/0x29b
 [<c10101b6>] ? do_page_fault+0x0/0x29b
 [<c11ce2a3>] error_code+0x63/0x68
 [<c10101b6>] ? do_page_fault+0x0/0x29b
BUG: sleeping function called from invalid context at /opt/cross/sys-root/i686-linux/usr/src/linux-2.6.33-i686-kernel-source/kernel/rtmutex.c:684
pcnt: 0 0 in_atomic(): 0, irqs_disabled(): 1, pid: 6, name: sirq-net-rx/0
5 locks held by sirq-net-rx/0/6:
 #0:  (rcu_read_lock){.+.+..}, at: [<c116c046>] netif_receive_skb+0xf0/0x276
 #1:  (rcu_read_lock){.+.+..}, at: [<c11805b3>] ip_local_deliver+0x3f/0xfb
 #2:  (slock-AF_INET-RPC/1){+.+...}, at: [<c1196d76>] tcp_v4_rcv+0x21e/0x543
 #3:  (rcu_read_lock){.+.+..}, at: [<c116d1ad>] dev_queue_xmit+0x19c/0x431
 #4:  (_xmit_ETHER#2){+.+...}, at: [<c11783f7>] sch_direct_xmit+0x29/0x132
irq event stamp: 38668
hardirqs last  enabled at (38667): [<c11cdda1>] _raw_spin_unlock_irqrestore+0x36/0x51
hardirqs last disabled at (38668): [<c11492e0>] ei_start_xmit+0x92/0x266
softirqs last  enabled at (0): [<c1017f09>] copy_process+0x2f9/0xff2
softirqs last disabled at (0): [<(null)>] (null)
Pid: 6, comm: sirq-net-rx/0 Not tainted 2.6.33.3-rt19-i686-pc #1
Call Trace:
 [<c1014af5>] __might_sleep+0xd1/0xd9
 [<c11cd697>] rt_spin_lock+0x25/0x62
 [<c11492e8>] ei_start_xmit+0x9a/0x266
 [<c116ce8b>] dev_hard_start_xmit+0x24d/0x2ec
 [<c1178416>] sch_direct_xmit+0x48/0x132
 [<c11cd6cc>] ? rt_spin_lock+0x5a/0x62
 [<c116d2d9>] dev_queue_xmit+0x2c8/0x431
 [<c118416d>] ip_finish_output+0x1fa/0x235
 [<c1184200>] ip_output+0x58/0x5d
 [<c118266c>] ip_local_out+0x51/0x55
 [<c1183c23>] ip_queue_xmit+0x298/0x2ce
 [<c11cdda1>] ? _raw_spin_unlock_irqrestore+0x36/0x51
 [<c1034f02>] ? trace_hardirqs_on_caller+0xfe/0x11f
 [<c1034f2e>] ? trace_hardirqs_on+0xb/0xd
 [<c1195c44>] ? tcp_v4_send_check+0x7d/0xb1
 [<c119298a>] tcp_transmit_skb+0x605/0x63b
 [<c1067c35>] ? __kmalloc+0xe1/0x135
 [<c1192b3e>] tcp_send_ack+0xdd/0xe5
 [<c118e00a>] __tcp_ack_snd_check+0x5e/0x73
 [<c1191a11>] tcp_rcv_established+0x3ca/0x525
 [<c1196a31>] tcp_v4_do_rcv+0x21/0x148
 [<c1196ebb>] tcp_v4_rcv+0x363/0x543
 [<c11805b3>] ? ip_local_deliver+0x3f/0xfb
 [<c118060a>] ip_local_deliver+0x96/0xfb
 [<c1180543>] ip_rcv+0x3e7/0x418
 [<c116c194>] netif_receive_skb+0x23e/0x276
 [<c116c230>] process_backlog+0x64/0x8c
 [<c116c782>] net_rx_action+0x48/0x108
 [<c101d33a>] run_ksoftirqd+0x102/0x1cc
 [<c101d238>] ? run_ksoftirqd+0x0/0x1cc
 [<c102958a>] kthread+0x5e/0x63
 [<c102952c>] ? kthread+0x0/0x63
 [<c102952c>] ? kthread+0x0/0x63
 [<c1002c5a>] kernel_thread_helper+0x6/0x10
BUG: sleeping function called from invalid context at /opt/cross/sys-root/i686-linux/usr/src/linux-2.6.33-i686-kernel-source/kernel/rtmutex.c:684
pcnt: 0 0 in_atomic(): 0, irqs_disabled(): 1, pid: 6, name: sirq-net-rx/0
5 locks held by sirq-net-rx/0/6:
 #0:  (rcu_read_lock){.+.+..}, at: [<c116c046>] netif_receive_skb+0xf0/0x276
 #1:  (rcu_read_lock){.+.+..}, at: [<c11805b3>] ip_local_deliver+0x3f/0xfb
 #2:  (slock-AF_INET-RPC/1){+.+...}, at: [<c1196d76>] tcp_v4_rcv+0x21e/0x543
 #3:  (rcu_read_lock){.+.+..}, at: [<c116d1ad>] dev_queue_xmit+0x19c/0x431
 #4:  (_xmit_ETHER#2){+.+...}, at: [<c11783f7>] sch_direct_xmit+0x29/0x132
irq event stamp: 60116
hardirqs last  enabled at (60115): [<c11cdda1>] _raw_spin_unlock_irqrestore+0x36/0x51
hardirqs last disabled at (60116): [<c11492e0>] ei_start_xmit+0x92/0x266
softirqs last  enabled at (0): [<c1017f09>] copy_process+0x2f9/0xff2
softirqs last disabled at (0): [<(null)>] (null)
Pid: 6, comm: sirq-net-rx/0 Not tainted 2.6.33.3-rt19-i686-pc #1
Call Trace:
 [<c1014af5>] __might_sleep+0xd1/0xd9
 [<c11cd697>] rt_spin_lock+0x25/0x62
 [<c11492e8>] ei_start_xmit+0x9a/0x266
 [<c116ce8b>] dev_hard_start_xmit+0x24d/0x2ec
 [<c1178416>] sch_direct_xmit+0x48/0x132
 [<c11cd6cc>] ? rt_spin_lock+0x5a/0x62
 [<c116d2d9>] dev_queue_xmit+0x2c8/0x431
 [<c118416d>] ip_finish_output+0x1fa/0x235
 [<c1184200>] ip_output+0x58/0x5d
 [<c118266c>] ip_local_out+0x51/0x55
 [<c1183c23>] ip_queue_xmit+0x298/0x2ce
 [<c11cdda1>] ? _raw_spin_unlock_irqrestore+0x36/0x51
 [<c1034f02>] ? trace_hardirqs_on_caller+0xfe/0x11f
 [<c1034f2e>] ? trace_hardirqs_on+0xb/0xd
 [<c1195c44>] ? tcp_v4_send_check+0x7d/0xb1
 [<c119298a>] tcp_transmit_skb+0x605/0x63b
 [<c1067c35>] ? __kmalloc+0xe1/0x135
 [<c1192b3e>] tcp_send_ack+0xdd/0xe5
 [<c118e00a>] __tcp_ack_snd_check+0x5e/0x73
 [<c1191a11>] tcp_rcv_established+0x3ca/0x525
 [<c1196a31>] tcp_v4_do_rcv+0x21/0x148
 [<c1196ebb>] tcp_v4_rcv+0x363/0x543
 [<c11805b3>] ? ip_local_deliver+0x3f/0xfb
 [<c118060a>] ip_local_deliver+0x96/0xfb
 [<c1180543>] ip_rcv+0x3e7/0x418
 [<c116c194>] netif_receive_skb+0x23e/0x276
 [<c116c230>] process_backlog+0x64/0x8c
 [<c116c782>] net_rx_action+0x48/0x108
 [<c101d33a>] run_ksoftirqd+0x102/0x1cc
 [<c101d238>] ? run_ksoftirqd+0x0/0x1cc
 [<c102958a>] kthread+0x5e/0x63
 [<c102952c>] ? kthread+0x0/0x63
 [<c102952c>] ? kthread+0x0/0x63
 [<c1002c5a>] kernel_thread_helper+0x6/0x10
BUG: sleeping function called from invalid context at /opt/cross/sys-root/i686-linux/usr/src/linux-2.6.33-i686-kernel-source/kernel/rtmutex.c:684
pcnt: 0 0 in_atomic(): 0, irqs_disabled(): 1, pid: 303, name: ldconfig
3 locks held by ldconfig/303:
 #0:  (sk_lock-AF_INET-RPC){+.+...}, at: [<c118a284>] tcp_sendmsg+0x17/0x8b1
 #1:  (rcu_read_lock){.+.+..}, at: [<c116d1ad>] dev_queue_xmit+0x19c/0x431
 #2:  (_xmit_ETHER#2){+.+...}, at: [<c11783f7>] sch_direct_xmit+0x29/0x132
irq event stamp: 100038
hardirqs last  enabled at (100037): [<c11cdda1>] _raw_spin_unlock_irqrestore+0x36/0x51
hardirqs last disabled at (100038): [<c11492e0>] ei_start_xmit+0x92/0x266
softirqs last  enabled at (0): [<c1017f09>] copy_process+0x2f9/0xff2
softirqs last disabled at (0): [<(null)>] (null)
Pid: 303, comm: ldconfig Not tainted 2.6.33.3-rt19-i686-pc #1
Call Trace:
 [<c1014af5>] __might_sleep+0xd1/0xd9
 [<c11cd697>] rt_spin_lock+0x25/0x62
 [<c11492e8>] ei_start_xmit+0x9a/0x266
 [<c116ce8b>] dev_hard_start_xmit+0x24d/0x2ec
 [<c1178416>] sch_direct_xmit+0x48/0x132
 [<c11cd6cc>] ? rt_spin_lock+0x5a/0x62
 [<c116d2d9>] dev_queue_xmit+0x2c8/0x431
 [<c118416d>] ip_finish_output+0x1fa/0x235
 [<c1184200>] ip_output+0x58/0x5d
 [<c118266c>] ip_local_out+0x51/0x55
 [<c1183c23>] ip_queue_xmit+0x298/0x2ce
 [<c1195c44>] ? tcp_v4_send_check+0x7d/0xb1
 [<c119298a>] tcp_transmit_skb+0x605/0x63b
 [<c11cdda1>] ? _raw_spin_unlock_irqrestore+0x36/0x51
 [<c1034f02>] ? trace_hardirqs_on_caller+0xfe/0x11f
 [<c1194acb>] tcp_write_xmit+0x756/0x834
 [<c1067c35>] ? __kmalloc+0xe1/0x135
 [<c1194bf6>] __tcp_push_pending_frames+0x21/0x75
 [<c118aa47>] tcp_sendmsg+0x7da/0x8b1
 [<c1160afe>] sock_sendmsg+0xa4/0xba
 [<c1160b3c>] kernel_sendmsg+0x28/0x37
 [<c11b49af>] xs_send_kvec+0x6d/0x77
 [<c11b4a1b>] xs_sendpages+0x62/0x172
 [<c11cd027>] ? rt_spin_lock_slowunlock+0x3b/0x5e
 [<c11b4c0c>] xs_tcp_send_request+0x41/0x117
 [<c11b336d>] xprt_transmit+0x156/0x250
 [<c11b1168>] call_transmit+0x1b2/0x1ed
 [<c11b6cc6>] __rpc_execute+0x6e/0x1f6
 [<c11b6e64>] rpc_execute+0x16/0x19
 [<c11b1972>] rpc_run_task+0x3a/0x42
 [<c11b1a59>] rpc_call_sync+0x3d/0x58
 [<c10ae93d>] nfs_proc_readlink+0x6b/0x8c
 [<c10b05c8>] nfs_symlink_filler+0x27/0x53
 [<c104acda>] do_read_cache_page+0x7d/0x114
 [<c10b05a1>] ? nfs_symlink_filler+0x0/0x53
 [<c104adab>] read_cache_page_async+0x19/0x1e
 [<c104adbb>] read_cache_page+0xb/0x12
 [<c10b0572>] nfs_follow_link+0x2e/0x5d
 [<c1071ebe>] link_path_walk+0x694/0x906
 [<c1072235>] path_walk+0x39/0x83
 [<c1070d5e>] ? path_init+0x6d/0x10d
 [<c107240d>] do_path_lookup+0x12e/0x14f
 [<c1072c4f>] user_path_at+0x39/0x64
 [<c106cbcd>] vfs_fstatat+0x2d/0x54
 [<c106ccc5>] vfs_stat+0x13/0x15
 [<c106ccdb>] sys_stat64+0x14/0x28
 [<c1002763>] ? sysenter_exit+0xf/0x18
 [<c1034f02>] ? trace_hardirqs_on_caller+0xfe/0x11f
 [<c10d59d0>] ? trace_hardirqs_on_thunk+0xc/0x10
 [<c1002730>] sysenter_do_call+0x12/0x36
BUG: sleeping function called from invalid context at /opt/cross/sys-root/i686-linux/usr/src/linux-2.6.33-i686-kernel-source/kernel/rtmutex.c:684
pcnt: 0 0 in_atomic(): 0, irqs_disabled(): 1, pid: 303, name: ldconfig
3 locks held by ldconfig/303:
 #0:  (sk_lock-AF_INET-RPC){+.+...}, at: [<c118a284>] tcp_sendmsg+0x17/0x8b1
 #1:  (rcu_read_lock){.+.+..}, at: [<c116d1ad>] dev_queue_xmit+0x19c/0x431
 #2:  (_xmit_ETHER#2){+.+...}, at: [<c11783f7>] sch_direct_xmit+0x29/0x132
irq event stamp: 150418
hardirqs last  enabled at (150417): [<c11cdda1>] _raw_spin_unlock_irqrestore+0x36/0x51
hardirqs last disabled at (150418): [<c11492e0>] ei_start_xmit+0x92/0x266
softirqs last  enabled at (0): [<c1017f09>] copy_process+0x2f9/0xff2
softirqs last disabled at (0): [<(null)>] (null)
Pid: 303, comm: ldconfig Not tainted 2.6.33.3-rt19-i686-pc #1
Call Trace:
 [<c1014af5>] __might_sleep+0xd1/0xd9
 [<c11cd697>] rt_spin_lock+0x25/0x62
 [<c11492e8>] ei_start_xmit+0x9a/0x266
 [<c116ce8b>] dev_hard_start_xmit+0x24d/0x2ec
 [<c1178416>] sch_direct_xmit+0x48/0x132
 [<c11cd6cc>] ? rt_spin_lock+0x5a/0x62
 [<c116d2d9>] dev_queue_xmit+0x2c8/0x431
 [<c118416d>] ip_finish_output+0x1fa/0x235
 [<c1184200>] ip_output+0x58/0x5d
 [<c118266c>] ip_local_out+0x51/0x55
 [<c1183c23>] ip_queue_xmit+0x298/0x2ce
 [<c1195c44>] ? tcp_v4_send_check+0x7d/0xb1
 [<c119298a>] tcp_transmit_skb+0x605/0x63b
 [<c11cdda1>] ? _raw_spin_unlock_irqrestore+0x36/0x51
 [<c1034f02>] ? trace_hardirqs_on_caller+0xfe/0x11f
 [<c1194acb>] tcp_write_xmit+0x756/0x834
 [<c1067c35>] ? __kmalloc+0xe1/0x135
 [<c1194bf6>] __tcp_push_pending_frames+0x21/0x75
 [<c118aa47>] tcp_sendmsg+0x7da/0x8b1
 [<c1160afe>] sock_sendmsg+0xa4/0xba
 [<c1160b3c>] kernel_sendmsg+0x28/0x37
 [<c11b49af>] xs_send_kvec+0x6d/0x77
 [<c11b4a1b>] xs_sendpages+0x62/0x172
 [<c11cd027>] ? rt_spin_lock_slowunlock+0x3b/0x5e
 [<c11b4c0c>] xs_tcp_send_request+0x41/0x117
 [<c11b336d>] xprt_transmit+0x156/0x250
 [<c11b1168>] call_transmit+0x1b2/0x1ed
 [<c11b6cc6>] __rpc_execute+0x6e/0x1f6
 [<c11b6e64>] rpc_execute+0x16/0x19
 [<c11b1972>] rpc_run_task+0x3a/0x42
 [<c11b1a59>] rpc_call_sync+0x3d/0x58
 [<c10ae93d>] nfs_proc_readlink+0x6b/0x8c
 [<c10b05c8>] nfs_symlink_filler+0x27/0x53
 [<c104acda>] do_read_cache_page+0x7d/0x114
 [<c10b05a1>] ? nfs_symlink_filler+0x0/0x53
 [<c104adab>] read_cache_page_async+0x19/0x1e
 [<c104adbb>] read_cache_page+0xb/0x12
 [<c10b0572>] nfs_follow_link+0x2e/0x5d
 [<c1071ebe>] link_path_walk+0x694/0x906
 [<c1072235>] path_walk+0x39/0x83
 [<c1070d5e>] ? path_init+0x6d/0x10d
 [<c107240d>] do_path_lookup+0x12e/0x14f
 [<c1072c4f>] user_path_at+0x39/0x64
 [<c106cbcd>] vfs_fstatat+0x2d/0x54
 [<c106ccc5>] vfs_stat+0x13/0x15
 [<c106ccdb>] sys_stat64+0x14/0x28
 [<c1002763>] ? sysenter_exit+0xf/0x18
 [<c1034f02>] ? trace_hardirqs_on_caller+0xfe/0x11f
 [<c10d59d0>] ? trace_hardirqs_on_thunk+0xc/0x10
 [<c1002730>] sysenter_do_call+0x12/0x36
BUG: sleeping function called from invalid context at /opt/cross/sys-root/i686-linux/usr/src/linux-2.6.33-i686-kernel-source/kernel/rtmutex.c:684
pcnt: 0 0 in_atomic(): 0, irqs_disabled(): 1, pid: 302, name: rcS
3 locks held by rcS/302:
 #0:  (sk_lock-AF_INET-RPC){+.+...}, at: [<c118a284>] tcp_sendmsg+0x17/0x8b1
 #1:  (rcu_read_lock){.+.+..}, at: [<c116d1ad>] dev_queue_xmit+0x19c/0x431
 #2:  (_xmit_ETHER#2){+.+...}, at: [<c11783f7>] sch_direct_xmit+0x29/0x132
irq event stamp: 19840
hardirqs last  enabled at (19839): [<c11cdda1>] _raw_spin_unlock_irqrestore+0x36/0x51
hardirqs last disabled at (19840): [<c11492e0>] ei_start_xmit+0x92/0x266
softirqs last  enabled at (0): [<c1017f09>] copy_process+0x2f9/0xff2
softirqs last disabled at (0): [<(null)>] (null)
Pid: 302, comm: rcS Not tainted 2.6.33.3-rt19-i686-pc #1
Call Trace:
 [<c1014af5>] __might_sleep+0xd1/0xd9
 [<c11cd697>] rt_spin_lock+0x25/0x62
 [<c11492e8>] ei_start_xmit+0x9a/0x266
 [<c116ce8b>] dev_hard_start_xmit+0x24d/0x2ec
 [<c1178416>] sch_direct_xmit+0x48/0x132
 [<c11cd6cc>] ? rt_spin_lock+0x5a/0x62
 [<c116d2d9>] dev_queue_xmit+0x2c8/0x431
 [<c118416d>] ip_finish_output+0x1fa/0x235
 [<c1184200>] ip_output+0x58/0x5d
 [<c118266c>] ip_local_out+0x51/0x55
 [<c1183c23>] ip_queue_xmit+0x298/0x2ce
 [<c1195c44>] ? tcp_v4_send_check+0x7d/0xb1
 [<c119298a>] tcp_transmit_skb+0x605/0x63b
 [<c11cdda1>] ? _raw_spin_unlock_irqrestore+0x36/0x51
 [<c1034f02>] ? trace_hardirqs_on_caller+0xfe/0x11f
 [<c1194acb>] tcp_write_xmit+0x756/0x834
 [<c1067c35>] ? __kmalloc+0xe1/0x135
 [<c1194bf6>] __tcp_push_pending_frames+0x21/0x75
 [<c118aa47>] tcp_sendmsg+0x7da/0x8b1
 [<c1160afe>] sock_sendmsg+0xa4/0xba
 [<c1160b3c>] kernel_sendmsg+0x28/0x37
 [<c11b49af>] xs_send_kvec+0x6d/0x77
 [<c11b4a1b>] xs_sendpages+0x62/0x172
 [<c11cd027>] ? rt_spin_lock_slowunlock+0x3b/0x5e
 [<c11b4c0c>] xs_tcp_send_request+0x41/0x117
 [<c11b336d>] xprt_transmit+0x156/0x250
 [<c11b1168>] call_transmit+0x1b2/0x1ed
 [<c11b6cc6>] __rpc_execute+0x6e/0x1f6
 [<c11b6e64>] rpc_execute+0x16/0x19
 [<c11b1972>] rpc_run_task+0x3a/0x42
 [<c11b1a59>] rpc_call_sync+0x3d/0x58
 [<c10aea4d>] nfs_proc_getattr+0x4e/0x70
 [<c10a9013>] __nfs_revalidate_inode+0x9d/0x195
 [<c103637a>] ? __lock_acquire+0x5d7/0x130c
 [<c11cd027>] ? rt_spin_lock_slowunlock+0x3b/0x5e
 [<c10a91b8>] nfs_revalidate_inode+0x39/0x52
 [<c10a94ab>] nfs_getattr+0x93/0xcc
 [<c10a9418>] ? nfs_getattr+0x0/0xcc
 [<c106cb8f>] vfs_getattr+0x17/0x28
 [<c106cd64>] vfs_fstat+0x25/0x35
 [<c106cd88>] sys_fstat64+0x14/0x28
 [<c11ccfc2>] ? rt_mutex_slowunlock+0x3b/0x5b
 [<c11ccfea>] ? rt_mutex_unlock+0x8/0xa
 [<c103b997>] ? rt_up_read+0x28/0x2b
 [<c11ce058>] ? restore_all_notrace+0x0/0x18
 [<c10101b6>] ? do_page_fault+0x0/0x29b
 [<c1034f02>] ? trace_hardirqs_on_caller+0xfe/0x11f
 [<c10d59d0>] ? trace_hardirqs_on_thunk+0xc/0x10
 [<c1002730>] sysenter_do_call+0x12/0x36
BUG: sleeping function called from invalid context at /opt/cross/sys-root/i686-linux/usr/src/linux-2.6.33-i686-kernel-source/kernel/rtmutex.c:684
pcnt: 0 0 in_atomic(): 0, irqs_disabled(): 1, pid: 6, name: sirq-net-rx/0
6 locks held by sirq-net-rx/0/6:
 #0:  (rcu_read_lock){.+.+..}, at: [<c116c046>] netif_receive_skb+0xf0/0x276
 #1:  (rcu_read_lock){.+.+..}, at: [<c11805b3>] ip_local_deliver+0x3f/0xfb
 #2:  (slock-AF_INET-RPC/1){+.+...}, at: [<c1196d76>] tcp_v4_rcv+0x21e/0x543
 #3:  (clock-AF_INET){++++..}, at: [<c11b54af>] xs_tcp_data_ready+0x2c/0x80
 #4:  (rcu_read_lock){.+.+..}, at: [<c116d1ad>] dev_queue_xmit+0x19c/0x431
 #5:  (_xmit_ETHER#2){+.+...}, at: [<c11783f7>] sch_direct_xmit+0x29/0x132
irq event stamp: 124222
hardirqs last  enabled at (124221): [<c11cdda1>] _raw_spin_unlock_irqrestore+0x36/0x51
hardirqs last disabled at (124222): [<c11492e0>] ei_start_xmit+0x92/0x266
softirqs last  enabled at (0): [<c1017f09>] copy_process+0x2f9/0xff2
softirqs last disabled at (0): [<(null)>] (null)
Pid: 6, comm: sirq-net-rx/0 Not tainted 2.6.33.3-rt19-i686-pc #1
Call Trace:
 [<c1014af5>] __might_sleep+0xd1/0xd9
 [<c11cd697>] rt_spin_lock+0x25/0x62
 [<c11492e8>] ei_start_xmit+0x9a/0x266
 [<c116ce8b>] dev_hard_start_xmit+0x24d/0x2ec
 [<c1178416>] sch_direct_xmit+0x48/0x132
 [<c11cd6cc>] ? rt_spin_lock+0x5a/0x62
 [<c116d2d9>] dev_queue_xmit+0x2c8/0x431
 [<c118416d>] ip_finish_output+0x1fa/0x235
 [<c1184200>] ip_output+0x58/0x5d
 [<c118266c>] ip_local_out+0x51/0x55
 [<c1183c23>] ip_queue_xmit+0x298/0x2ce
 [<c11cdda1>] ? _raw_spin_unlock_irqrestore+0x36/0x51
 [<c1034f02>] ? trace_hardirqs_on_caller+0xfe/0x11f
 [<c1034f2e>] ? trace_hardirqs_on+0xb/0xd
 [<c1195c44>] ? tcp_v4_send_check+0x7d/0xb1
 [<c119298a>] tcp_transmit_skb+0x605/0x63b
 [<c1067c35>] ? __kmalloc+0xe1/0x135
 [<c1192b3e>] tcp_send_ack+0xdd/0xe5
 [<c11892cf>] tcp_cleanup_rbuf+0xdf/0xe7
 [<c118a01f>] tcp_read_sock+0x19f/0x1a9
 [<c11b5ddb>] ? xs_tcp_data_recv+0x0/0x52d
 [<c11b54f0>] xs_tcp_data_ready+0x6d/0x80
 [<c118ee4d>] tcp_data_queue+0x4cf/0xb66
 [<c1191aeb>] tcp_rcv_established+0x4a4/0x525
 [<c1196a31>] tcp_v4_do_rcv+0x21/0x148
 [<c1196ebb>] tcp_v4_rcv+0x363/0x543
 [<c11805b3>] ? ip_local_deliver+0x3f/0xfb
 [<c118060a>] ip_local_deliver+0x96/0xfb
 [<c1180543>] ip_rcv+0x3e7/0x418
 [<c116c194>] netif_receive_skb+0x23e/0x276
 [<c116c230>] process_backlog+0x64/0x8c
 [<c116c782>] net_rx_action+0x48/0x108
 [<c101d33a>] run_ksoftirqd+0x102/0x1cc
 [<c101d238>] ? run_ksoftirqd+0x0/0x1cc
 [<c102958a>] kthread+0x5e/0x63
 [<c102952c>] ? kthread+0x0/0x63
 [<c102952c>] ? kthread+0x0/0x63
 [<c1002c5a>] kernel_thread_helper+0x6/0x10
BUG: sleeping function called from invalid context at /opt/cross/sys-root/i686-linux/usr/src/linux-2.6.33-i686-kernel-source/kernel/rtmutex.c:684
pcnt: 0 0 in_atomic(): 0, irqs_disabled(): 1, pid: 302, name: rcS
4 locks held by rcS/302:
 #0:  (&sb->s_type->i_mutex_key#3){+.+.+.}, at: [<c10708c7>] do_lookup+0x8c/0x17b
 #1:  (sk_lock-AF_INET-RPC){+.+...}, at: [<c118a284>] tcp_sendmsg+0x17/0x8b1
 #2:  (rcu_read_lock){.+.+..}, at: [<c116d1ad>] dev_queue_xmit+0x19c/0x431
 #3:  (_xmit_ETHER#2){+.+...}, at: [<c11783f7>] sch_direct_xmit+0x29/0x132
irq event stamp: 46536
hardirqs last  enabled at (46535): [<c11cdda1>] _raw_spin_unlock_irqrestore+0x36/0x51
hardirqs last disabled at (46536): [<c11492e0>] ei_start_xmit+0x92/0x266
softirqs last  enabled at (0): [<c1017f09>] copy_process+0x2f9/0xff2
softirqs last disabled at (0): [<(null)>] (null)
Pid: 302, comm: rcS Not tainted 2.6.33.3-rt19-i686-pc #1
Call Trace:
 [<c1014af5>] __might_sleep+0xd1/0xd9
 [<c11cd697>] rt_spin_lock+0x25/0x62
 [<c11492e8>] ei_start_xmit+0x9a/0x266
 [<c116ce8b>] dev_hard_start_xmit+0x24d/0x2ec
 [<c1178416>] sch_direct_xmit+0x48/0x132
 [<c11cd6cc>] ? rt_spin_lock+0x5a/0x62
 [<c116d2d9>] dev_queue_xmit+0x2c8/0x431
 [<c118416d>] ip_finish_output+0x1fa/0x235
 [<c1184200>] ip_output+0x58/0x5d
 [<c118266c>] ip_local_out+0x51/0x55
 [<c1183c23>] ip_queue_xmit+0x298/0x2ce
 [<c1195c44>] ? tcp_v4_send_check+0x7d/0xb1
 [<c119298a>] tcp_transmit_skb+0x605/0x63b
 [<c1194acb>] tcp_write_xmit+0x756/0x834
 [<c1067c35>] ? __kmalloc+0xe1/0x135
 [<c1194bf6>] __tcp_push_pending_frames+0x21/0x75
 [<c118aa47>] tcp_sendmsg+0x7da/0x8b1
 [<c1160afe>] sock_sendmsg+0xa4/0xba
 [<c1160b3c>] kernel_sendmsg+0x28/0x37
 [<c11b49af>] xs_send_kvec+0x6d/0x77
 [<c11b4a1b>] xs_sendpages+0x62/0x172
 [<c11cd027>] ? rt_spin_lock_slowunlock+0x3b/0x5e
 [<c11b4c0c>] xs_tcp_send_request+0x41/0x117
 [<c11b336d>] xprt_transmit+0x156/0x250
 [<c11b1168>] call_transmit+0x1b2/0x1ed
 [<c11b6cc6>] __rpc_execute+0x6e/0x1f6
 [<c11b6e64>] rpc_execute+0x16/0x19
 [<c11b1972>] rpc_run_task+0x3a/0x42
 [<c11b1a59>] rpc_call_sync+0x3d/0x58
 [<c10ae9dd>] nfs_proc_lookup+0x7f/0xa1
 [<c10a5870>] nfs_lookup+0xee/0x16e
 [<c1034cd5>] ? mark_held_locks+0x43/0x5b
 [<c11cdda1>] ? _raw_spin_unlock_irqrestore+0x36/0x51
 [<c1034f02>] ? trace_hardirqs_on_caller+0xfe/0x11f
 [<c1034f2e>] ? trace_hardirqs_on+0xb/0xd
 [<c11cd027>] ? rt_spin_lock_slowunlock+0x3b/0x5e
 [<c11cd70a>] ? rt_spin_unlock+0x36/0x39
 [<c10789f7>] ? d_alloc+0x1a0/0x1a9
 [<c1070909>] do_lookup+0xce/0x17b
 [<c1071db7>] link_path_walk+0x58d/0x906
 [<c1072235>] path_walk+0x39/0x83
 [<c1070d5e>] ? path_init+0x6d/0x10d
 [<c107240d>] do_path_lookup+0x12e/0x14f
 [<c1072c4f>] user_path_at+0x39/0x64
 [<c11cd70a>] ? rt_spin_unlock+0x36/0x39
 [<c105af39>] ? do_wp_page+0x548/0x5c9
 [<c106cbcd>] vfs_fstatat+0x2d/0x54
 [<c1034f02>] ? trace_hardirqs_on_caller+0xfe/0x11f
 [<c106ccc5>] vfs_stat+0x13/0x15
 [<c106ccdb>] sys_stat64+0x14/0x28
 [<c11ccfc2>] ? rt_mutex_slowunlock+0x3b/0x5b
 [<c11ccfea>] ? rt_mutex_unlock+0x8/0xa
 [<c103b997>] ? rt_up_read+0x28/0x2b
 [<c11ce058>] ? restore_all_notrace+0x0/0x18
 [<c10101b6>] ? do_page_fault+0x0/0x29b
 [<c1034f02>] ? trace_hardirqs_on_caller+0xfe/0x11f
 [<c10d59d0>] ? trace_hardirqs_on_thunk+0xc/0x10
 [<c1002730>] sysenter_do_call+0x12/0x36
BUG: sleeping function called from invalid context at /opt/cross/sys-root/i686-linux/usr/src/linux-2.6.33-i686-kernel-source/kernel/rtmutex.c:684
pcnt: 0 0 in_atomic(): 0, irqs_disabled(): 1, pid: 322, name: syslogd
3 locks held by syslogd/322:
 #0:  (sk_lock-AF_INET-RPC){+.+...}, at: [<c118a284>] tcp_sendmsg+0x17/0x8b1
 #1:  (rcu_read_lock){.+.+..}, at: [<c116d1ad>] dev_queue_xmit+0x19c/0x431
 #2:  (_xmit_ETHER#2){+.+...}, at: [<c11783f7>] sch_direct_xmit+0x29/0x132
irq event stamp: 19728
hardirqs last  enabled at (19727): [<c11cdda1>] _raw_spin_unlock_irqrestore+0x36/0x51
hardirqs last disabled at (19728): [<c11492e0>] ei_start_xmit+0x92/0x266
softirqs last  enabled at (0): [<c1017f09>] copy_process+0x2f9/0xff2
softirqs last disabled at (0): [<(null)>] (null)
Pid: 322, comm: syslogd Not tainted 2.6.33.3-rt19-i686-pc #1
Call Trace:
 [<c1014af5>] __might_sleep+0xd1/0xd9
 [<c11cd697>] rt_spin_lock+0x25/0x62
 [<c11492e8>] ei_start_xmit+0x9a/0x266
 [<c116ce8b>] dev_hard_start_xmit+0x24d/0x2ec
 [<c1178416>] sch_direct_xmit+0x48/0x132
 [<c11cd6cc>] ? rt_spin_lock+0x5a/0x62
 [<c116d2d9>] dev_queue_xmit+0x2c8/0x431
 [<c118416d>] ip_finish_output+0x1fa/0x235
 [<c1184200>] ip_output+0x58/0x5d
 [<c118266c>] ip_local_out+0x51/0x55
 [<c1183c23>] ip_queue_xmit+0x298/0x2ce
 [<c1195c44>] ? tcp_v4_send_check+0x7d/0xb1
 [<c119298a>] tcp_transmit_skb+0x605/0x63b
 [<c1194acb>] tcp_write_xmit+0x756/0x834
 [<c118a284>] ? tcp_sendmsg+0x17/0x8b1
 [<c1194bd1>] tcp_push_one+0x28/0x2c
 [<c118a937>] tcp_sendmsg+0x6ca/0x8b1
 [<c1160afe>] sock_sendmsg+0xa4/0xba
 [<c1160afe>] ? sock_sendmsg+0xa4/0xba
 [<c1160b3c>] kernel_sendmsg+0x28/0x37
 [<c116317d>] sock_no_sendpage+0x45/0x58
 [<c118ab51>] tcp_sendpage+0x33/0x4c6
 [<c11b4ab4>] xs_sendpages+0xfb/0x172
 [<c11b4c0c>] xs_tcp_send_request+0x41/0x117
 [<c11b336d>] xprt_transmit+0x156/0x250
 [<c11b1168>] call_transmit+0x1b2/0x1ed
 [<c11b6cc6>] __rpc_execute+0x6e/0x1f6
 [<c11b6e64>] rpc_execute+0x16/0x19
 [<c11b1972>] rpc_run_task+0x3a/0x42
 [<c10b0fd5>] nfs_write_rpcsetup+0x1f4/0x20e
 [<c10b271f>] nfs_flush_one+0x82/0xb2
 [<c10ae161>] nfs_pageio_doio+0x27/0x4f
 [<c10ae23b>] nfs_pageio_add_request+0xb2/0xc5
 [<c10b1170>] nfs_do_writepage+0x124/0x146
 [<c1034f02>] ? trace_hardirqs_on_caller+0xfe/0x11f
 [<c10b156f>] nfs_writepages_callback+0xc/0x1b
 [<c104f18b>] write_cache_pages+0x177/0x24e
 [<c10b1563>] ? nfs_writepages_callback+0x0/0x1b
 [<c10b1531>] nfs_writepages+0x8e/0xc0
 [<c10b269d>] ? nfs_flush_one+0x0/0xb2
 [<c10b2554>] nfs_write_mapping+0x4b/0x7d
 [<c10b25ab>] nfs_wb_all+0x10/0x12
 [<c10a726d>] nfs_do_fsync+0x15/0x30
 [<c10a7424>] nfs_file_flush+0x5d/0x65
 [<c10686b6>] filp_close+0x32/0x52
 [<c1068747>] sys_close+0x71/0xa5
 [<c1002730>] sysenter_do_call+0x12/0x36
BUG: sleeping function called from invalid context at /opt/cross/sys-root/i686-linux/usr/src/linux-2.6.33-i686-kernel-source/kernel/rtmutex.c:684
pcnt: 0 0 in_atomic(): 0, irqs_disabled(): 1, pid: 322, name: syslogd
4 locks held by syslogd/322:
 #0:  (&sb->s_type->i_mutex_key#3/1){+.+.+.}, at: [<c1071679>] lock_rename+0x20/0x90
 #1:  (sk_lock-AF_INET-RPC){+.+...}, at: [<c118a284>] tcp_sendmsg+0x17/0x8b1
 #2:  (rcu_read_lock){.+.+..}, at: [<c116d1ad>] dev_queue_xmit+0x19c/0x431
 #3:  (_xmit_ETHER#2){+.+...}, at: [<c11783f7>] sch_direct_xmit+0x29/0x132
irq event stamp: 45634
hardirqs last  enabled at (45633): [<c11cdda1>] _raw_spin_unlock_irqrestore+0x36/0x51
hardirqs last disabled at (45634): [<c11492e0>] ei_start_xmit+0x92/0x266
softirqs last  enabled at (0): [<c1017f09>] copy_process+0x2f9/0xff2
softirqs last disabled at (0): [<(null)>] (null)
Pid: 322, comm: syslogd Not tainted 2.6.33.3-rt19-i686-pc #1
Call Trace:
 [<c1014af5>] __might_sleep+0xd1/0xd9
 [<c11cd697>] rt_spin_lock+0x25/0x62
 [<c11492e8>] ei_start_xmit+0x9a/0x266
 [<c116ce8b>] dev_hard_start_xmit+0x24d/0x2ec
 [<c1178416>] sch_direct_xmit+0x48/0x132
 [<c11cd6cc>] ? rt_spin_lock+0x5a/0x62
 [<c116d2d9>] dev_queue_xmit+0x2c8/0x431
 [<c118416d>] ip_finish_output+0x1fa/0x235
 [<c1184200>] ip_output+0x58/0x5d
 [<c118266c>] ip_local_out+0x51/0x55
 [<c1183c23>] ip_queue_xmit+0x298/0x2ce
 [<c1195c44>] ? tcp_v4_send_check+0x7d/0xb1
 [<c119298a>] tcp_transmit_skb+0x605/0x63b
 [<c11cdda1>] ? _raw_spin_unlock_irqrestore+0x36/0x51
 [<c1034f02>] ? trace_hardirqs_on_caller+0xfe/0x11f
 [<c1194acb>] tcp_write_xmit+0x756/0x834
 [<c1067c35>] ? __kmalloc+0xe1/0x135
 [<c1194bf6>] __tcp_push_pending_frames+0x21/0x75
 [<c118aa47>] tcp_sendmsg+0x7da/0x8b1
 [<c1160afe>] sock_sendmsg+0xa4/0xba
 [<c1160b3c>] kernel_sendmsg+0x28/0x37
 [<c11b49af>] xs_send_kvec+0x6d/0x77
 [<c11b4a1b>] xs_sendpages+0x62/0x172
 [<c11cd027>] ? rt_spin_lock_slowunlock+0x3b/0x5e
 [<c11b4c0c>] xs_tcp_send_request+0x41/0x117
 [<c11b336d>] xprt_transmit+0x156/0x250
 [<c11b1168>] call_transmit+0x1b2/0x1ed
 [<c11b6cc6>] __rpc_execute+0x6e/0x1f6
 [<c11b6e64>] rpc_execute+0x16/0x19
 [<c11b1972>] rpc_run_task+0x3a/0x42
 [<c11b1a59>] rpc_call_sync+0x3d/0x58
 [<c10ae9dd>] nfs_proc_lookup+0x7f/0xa1
 [<c10a5870>] nfs_lookup+0xee/0x16e
 [<c1034cd5>] ? mark_held_locks+0x43/0x5b
 [<c11cdda1>] ? _raw_spin_unlock_irqrestore+0x36/0x51
 [<c1034f02>] ? trace_hardirqs_on_caller+0xfe/0x11f
 [<c1034f2e>] ? trace_hardirqs_on+0xb/0xd
 [<c11cd027>] ? rt_spin_lock_slowunlock+0x3b/0x5e
 [<c11cd70a>] ? rt_spin_unlock+0x36/0x39
 [<c10789f7>] ? d_alloc+0x1a0/0x1a9
 [<c1070a89>] __lookup_hash+0xd3/0xee
 [<c1070ac6>] lookup_hash+0x22/0x25
 [<c1072587>] sys_renameat+0xbf/0x1d3
 [<c11cddd9>] ? _raw_spin_unlock+0x1d/0x35
 [<c106a4c7>] ? vfs_read+0x7c/0x8c
 [<c10726ad>] sys_rename+0x12/0x14
 [<c1002730>] sysenter_do_call+0x12/0x36
BUG: sleeping function called from invalid context at /opt/cross/sys-root/i686-linux/usr/src/linux-2.6.33-i686-kernel-source/kernel/rtmutex.c:684
pcnt: 0 0 in_atomic(): 0, irqs_disabled(): 1, pid: 162, name: rpciod/0
4 locks held by rpciod/0/162:
 #0:  (rpciod){+.+.+.}, at: [<c1026be0>] worker_thread+0x122/0x236
 #1:  ((&task->u.tk_work)){+.+...}, at: [<c1026be0>] worker_thread+0x122/0x236
 #2:  (rcu_read_lock){.+.+..}, at: [<c116d1ad>] dev_queue_xmit+0x19c/0x431
 #3:  (_xmit_ETHER#2){+.+...}, at: [<c11783f7>] sch_direct_xmit+0x29/0x132
irq event stamp: 62352
hardirqs last  enabled at (62351): [<c11cdda1>] _raw_spin_unlock_irqrestore+0x36/0x51
hardirqs last disabled at (62352): [<c11492e0>] ei_start_xmit+0x92/0x266
softirqs last  enabled at (0): [<c1017f09>] copy_process+0x2f9/0xff2
softirqs last disabled at (0): [<(null)>] (null)
Pid: 162, comm: rpciod/0 Not tainted 2.6.33.3-rt19-i686-pc #1
Call Trace:
 [<c1014af5>] __might_sleep+0xd1/0xd9
 [<c11cd697>] rt_spin_lock+0x25/0x62
 [<c11492e8>] ei_start_xmit+0x9a/0x266
 [<c116ce8b>] dev_hard_start_xmit+0x24d/0x2ec
 [<c1178416>] sch_direct_xmit+0x48/0x132
 [<c11cd6cc>] ? rt_spin_lock+0x5a/0x62
 [<c116d2d9>] dev_queue_xmit+0x2c8/0x431
 [<c118416d>] ip_finish_output+0x1fa/0x235
 [<c1184200>] ip_output+0x58/0x5d
 [<c118266c>] ip_local_out+0x51/0x55
 [<c1183c23>] ip_queue_xmit+0x298/0x2ce
 [<c11cdda1>] ? _raw_spin_unlock_irqrestore+0x36/0x51
 [<c1034f02>] ? trace_hardirqs_on_caller+0xfe/0x11f
 [<c1034f2e>] ? trace_hardirqs_on+0xb/0xd
 [<c1195c44>] ? tcp_v4_send_check+0x7d/0xb1
 [<c119298a>] tcp_transmit_skb+0x605/0x63b
 [<c1067c35>] ? __kmalloc+0xe1/0x135
 [<c1192b3e>] tcp_send_ack+0xdd/0xe5
 [<c118e00a>] __tcp_ack_snd_check+0x5e/0x73
 [<c1191a11>] tcp_rcv_established+0x3ca/0x525
 [<c1196a31>] tcp_v4_do_rcv+0x21/0x148
 [<c1162c0b>] release_sock+0x68/0xde
 [<c118aa4e>] tcp_sendmsg+0x7e1/0x8b1
 [<c1160afe>] sock_sendmsg+0xa4/0xba
 [<c1160b3c>] kernel_sendmsg+0x28/0x37
 [<c11b49af>] xs_send_kvec+0x6d/0x77
 [<c11b4a1b>] xs_sendpages+0x62/0x172
 [<c11cd027>] ? rt_spin_lock_slowunlock+0x3b/0x5e
 [<c11b4c0c>] xs_tcp_send_request+0x41/0x117
 [<c11b336d>] xprt_transmit+0x156/0x250
 [<c11b1168>] call_transmit+0x1b2/0x1ed
 [<c11b6cc6>] __rpc_execute+0x6e/0x1f6
 [<c11b6e72>] rpc_async_schedule+0xb/0xd
 [<c1026c24>] worker_thread+0x166/0x236
 [<c1026be0>] ? worker_thread+0x122/0x236
 [<c11b6e67>] ? rpc_async_schedule+0x0/0xd
 [<c102972d>] ? autoremove_wake_function+0x0/0x2f
 [<c1026abe>] ? worker_thread+0x0/0x236
 [<c102958a>] kthread+0x5e/0x63
 [<c102952c>] ? kthread+0x0/0x63
 [<c102952c>] ? kthread+0x0/0x63
 [<c1002c5a>] kernel_thread_helper+0x6/0x10
BUG: sleeping function called from invalid context at /opt/cross/sys-root/i686-linux/usr/src/linux-2.6.33-i686-kernel-source/kernel/rtmutex.c:684
pcnt: 0 0 in_atomic(): 0, irqs_disabled(): 1, pid: 162, name: rpciod/0
4 locks held by rpciod/0/162:
 #0:  (rpciod){+.+.+.}, at: [<c1026be0>] worker_thread+0x122/0x236
 #1:  ((&task->u.tk_work)){+.+...}, at: [<c1026be0>] worker_thread+0x122/0x236
 #2:  (rcu_read_lock){.+.+..}, at: [<c116d1ad>] dev_queue_xmit+0x19c/0x431
 #3:  (_xmit_ETHER#2){+.+...}, at: [<c11783f7>] sch_direct_xmit+0x29/0x132
irq event stamp: 91558
hardirqs last  enabled at (91557): [<c11cdda1>] _raw_spin_unlock_irqrestore+0x36/0x51
hardirqs last disabled at (91558): [<c11492e0>] ei_start_xmit+0x92/0x266
softirqs last  enabled at (0): [<c1017f09>] copy_process+0x2f9/0xff2
softirqs last disabled at (0): [<(null)>] (null)
Pid: 162, comm: rpciod/0 Not tainted 2.6.33.3-rt19-i686-pc #1
Call Trace:
 [<c1014af5>] __might_sleep+0xd1/0xd9
 [<c11cd697>] rt_spin_lock+0x25/0x62
 [<c11492e8>] ei_start_xmit+0x9a/0x266
 [<c116ce8b>] dev_hard_start_xmit+0x24d/0x2ec
 [<c1178416>] sch_direct_xmit+0x48/0x132
 [<c11cd6cc>] ? rt_spin_lock+0x5a/0x62
 [<c116d2d9>] dev_queue_xmit+0x2c8/0x431
 [<c118416d>] ip_finish_output+0x1fa/0x235
 [<c1184200>] ip_output+0x58/0x5d
 [<c118266c>] ip_local_out+0x51/0x55
 [<c1183c23>] ip_queue_xmit+0x298/0x2ce
 [<c11cdda1>] ? _raw_spin_unlock_irqrestore+0x36/0x51
 [<c1034f02>] ? trace_hardirqs_on_caller+0xfe/0x11f
 [<c1034f2e>] ? trace_hardirqs_on+0xb/0xd
 [<c1195c44>] ? tcp_v4_send_check+0x7d/0xb1
 [<c119298a>] tcp_transmit_skb+0x605/0x63b
 [<c1067c35>] ? __kmalloc+0xe1/0x135
 [<c1192b3e>] tcp_send_ack+0xdd/0xe5
 [<c118e00a>] __tcp_ack_snd_check+0x5e/0x73
 [<c1191a11>] tcp_rcv_established+0x3ca/0x525
 [<c1196a31>] tcp_v4_do_rcv+0x21/0x148
 [<c1162c0b>] release_sock+0x68/0xde
 [<c118aa4e>] tcp_sendmsg+0x7e1/0x8b1
 [<c1160afe>] sock_sendmsg+0xa4/0xba
 [<c1160b3c>] kernel_sendmsg+0x28/0x37
 [<c11b49af>] xs_send_kvec+0x6d/0x77
 [<c11b4a1b>] xs_sendpages+0x62/0x172
 [<c11cd027>] ? rt_spin_lock_slowunlock+0x3b/0x5e
 [<c11b4c0c>] xs_tcp_send_request+0x41/0x117
 [<c11b336d>] xprt_transmit+0x156/0x250
 [<c11b1168>] call_transmit+0x1b2/0x1ed
 [<c11b6cc6>] __rpc_execute+0x6e/0x1f6
 [<c11b6e72>] rpc_async_schedule+0xb/0xd
 [<c1026c24>] worker_thread+0x166/0x236
 [<c1026be0>] ? worker_thread+0x122/0x236
 [<c11b6e67>] ? rpc_async_schedule+0x0/0xd
 [<c102972d>] ? autoremove_wake_function+0x0/0x2f
 [<c1026abe>] ? worker_thread+0x0/0x236
 [<c102958a>] kthread+0x5e/0x63
 [<c102952c>] ? kthread+0x0/0x63
 [<c102952c>] ? kthread+0x0/0x63
 [<c1002c5a>] kernel_thread_helper+0x6/0x10
BUG: sleeping function called from invalid context at /opt/cross/sys-root/i686-linux/usr/src/linux-2.6.33-i686-kernel-source/kernel/rtmutex.c:684
pcnt: 0 0 in_atomic(): 0, irqs_disabled(): 1, pid: 162, name: rpciod/0
5 locks held by rpciod/0/162:
 #0:  (rpciod){+.+.+.}, at: [<c1026be0>] worker_thread+0x122/0x236
 #1:  ((&task->u.tk_work)){+.+...}, at: [<c1026be0>] worker_thread+0x122/0x236
 #2:  (sk_lock-AF_INET-RPC){+.+...}, at: [<c118a284>] tcp_sendmsg+0x17/0x8b1
 #3:  (rcu_read_lock){.+.+..}, at: [<c116d1ad>] dev_queue_xmit+0x19c/0x431
 #4:  (_xmit_ETHER#2){+.+...}, at: [<c11783f7>] sch_direct_xmit+0x29/0x132
irq event stamp: 119196
hardirqs last  enabled at (119195): [<c11cdda1>] _raw_spin_unlock_irqrestore+0x36/0x51
hardirqs last disabled at (119196): [<c11492e0>] ei_start_xmit+0x92/0x266
softirqs last  enabled at (0): [<c1017f09>] copy_process+0x2f9/0xff2
softirqs last disabled at (0): [<(null)>] (null)
Pid: 162, comm: rpciod/0 Not tainted 2.6.33.3-rt19-i686-pc #1
Call Trace:
 [<c1014af5>] __might_sleep+0xd1/0xd9
 [<c11cd697>] rt_spin_lock+0x25/0x62
 [<c11492e8>] ei_start_xmit+0x9a/0x266
 [<c116ce8b>] dev_hard_start_xmit+0x24d/0x2ec
 [<c1178416>] sch_direct_xmit+0x48/0x132
 [<c11cd6cc>] ? rt_spin_lock+0x5a/0x62
 [<c116d2d9>] dev_queue_xmit+0x2c8/0x431
 [<c118416d>] ip_finish_output+0x1fa/0x235
 [<c1184200>] ip_output+0x58/0x5d
 [<c118266c>] ip_local_out+0x51/0x55
 [<c1183c23>] ip_queue_xmit+0x298/0x2ce
 [<c1195c44>] ? tcp_v4_send_check+0x7d/0xb1
 [<c119298a>] tcp_transmit_skb+0x605/0x63b
 [<c1194acb>] tcp_write_xmit+0x756/0x834
 [<c118a284>] ? tcp_sendmsg+0x17/0x8b1
 [<c1194bd1>] tcp_push_one+0x28/0x2c
 [<c118a937>] tcp_sendmsg+0x6ca/0x8b1
 [<c1160afe>] sock_sendmsg+0xa4/0xba
 [<c1160afe>] ? sock_sendmsg+0xa4/0xba
 [<c1160b3c>] kernel_sendmsg+0x28/0x37
 [<c116317d>] sock_no_sendpage+0x45/0x58
 [<c118ab51>] tcp_sendpage+0x33/0x4c6
 [<c11b4ab4>] xs_sendpages+0xfb/0x172
 [<c11b4c0c>] xs_tcp_send_request+0x41/0x117
 [<c11b336d>] xprt_transmit+0x156/0x250
 [<c11b1168>] call_transmit+0x1b2/0x1ed
 [<c11b6cc6>] __rpc_execute+0x6e/0x1f6
 [<c11b6e72>] rpc_async_schedule+0xb/0xd
 [<c1026c24>] worker_thread+0x166/0x236
 [<c1026be0>] ? worker_thread+0x122/0x236
 [<c11b6e67>] ? rpc_async_schedule+0x0/0xd
 [<c102972d>] ? autoremove_wake_function+0x0/0x2f
 [<c1026abe>] ? worker_thread+0x0/0x236
 [<c102958a>] kthread+0x5e/0x63
 [<c102952c>] ? kthread+0x0/0x63
 [<c102952c>] ? kthread+0x0/0x63
 [<c1002c5a>] kernel_thread_helper+0x6/0x10
BUG: sleeping function called from invalid context at /opt/cross/sys-root/i686-linux/usr/src/linux-2.6.33-i686-kernel-source/kernel/rtmutex.c:684
pcnt: 0 0 in_atomic(): 0, irqs_disabled(): 1, pid: 322, name: syslogd
3 locks held by syslogd/322:
 #0:  (sk_lock-AF_INET-RPC){+.+...}, at: [<c118a284>] tcp_sendmsg+0x17/0x8b1
 #1:  (rcu_read_lock){.+.+..}, at: [<c116d1ad>] dev_queue_xmit+0x19c/0x431
 #2:  (_xmit_ETHER#2){+.+...}, at: [<c11783f7>] sch_direct_xmit+0x29/0x132
irq event stamp: 105230
hardirqs last  enabled at (105229): [<c11cdda1>] _raw_spin_unlock_irqrestore+0x36/0x51
hardirqs last disabled at (105230): [<c11492e0>] ei_start_xmit+0x92/0x266
softirqs last  enabled at (0): [<c1017f09>] copy_process+0x2f9/0xff2
softirqs last disabled at (0): [<(null)>] (null)
Pid: 322, comm: syslogd Not tainted 2.6.33.3-rt19-i686-pc #1
Call Trace:
 [<c1014af5>] __might_sleep+0xd1/0xd9
 [<c11cd697>] rt_spin_lock+0x25/0x62
 [<c11492e8>] ei_start_xmit+0x9a/0x266
 [<c116ce8b>] dev_hard_start_xmit+0x24d/0x2ec
 [<c1178416>] sch_direct_xmit+0x48/0x132
 [<c11cd6cc>] ? rt_spin_lock+0x5a/0x62
 [<c116d2d9>] dev_queue_xmit+0x2c8/0x431
 [<c118416d>] ip_finish_output+0x1fa/0x235
 [<c1184200>] ip_output+0x58/0x5d
 [<c118266c>] ip_local_out+0x51/0x55
 [<c1183c23>] ip_queue_xmit+0x298/0x2ce
 [<c1195c44>] ? tcp_v4_send_check+0x7d/0xb1
 [<c119298a>] tcp_transmit_skb+0x605/0x63b
 [<c1194acb>] tcp_write_xmit+0x756/0x834
 [<c118a284>] ? tcp_sendmsg+0x17/0x8b1
 [<c1194bd1>] tcp_push_one+0x28/0x2c
 [<c118a937>] tcp_sendmsg+0x6ca/0x8b1
 [<c1160afe>] sock_sendmsg+0xa4/0xba
 [<c1160afe>] ? sock_sendmsg+0xa4/0xba
 [<c1160b3c>] kernel_sendmsg+0x28/0x37
 [<c116317d>] sock_no_sendpage+0x45/0x58
 [<c118ab51>] tcp_sendpage+0x33/0x4c6
 [<c11b4ab4>] xs_sendpages+0xfb/0x172
 [<c11b4c0c>] xs_tcp_send_request+0x41/0x117
 [<c11b336d>] xprt_transmit+0x156/0x250
 [<c11b1168>] call_transmit+0x1b2/0x1ed
 [<c11b6cc6>] __rpc_execute+0x6e/0x1f6
 [<c11b6e64>] rpc_execute+0x16/0x19
 [<c11b1972>] rpc_run_task+0x3a/0x42
 [<c10b0fd5>] nfs_write_rpcsetup+0x1f4/0x20e
 [<c10b271f>] nfs_flush_one+0x82/0xb2
 [<c10ae161>] nfs_pageio_doio+0x27/0x4f
 [<c10ae23b>] nfs_pageio_add_request+0xb2/0xc5
 [<c10b1170>] nfs_do_writepage+0x124/0x146
 [<c1034f02>] ? trace_hardirqs_on_caller+0xfe/0x11f
 [<c10b156f>] nfs_writepages_callback+0xc/0x1b
 [<c104f18b>] write_cache_pages+0x177/0x24e
 [<c10b1563>] ? nfs_writepages_callback+0x0/0x1b
 [<c10b1531>] nfs_writepages+0x8e/0xc0
 [<c10b269d>] ? nfs_flush_one+0x0/0xb2
 [<c10b2554>] nfs_write_mapping+0x4b/0x7d
 [<c10b25ab>] nfs_wb_all+0x10/0x12
 [<c10a726d>] nfs_do_fsync+0x15/0x30
 [<c10a7424>] nfs_file_flush+0x5d/0x65
 [<c10686b6>] filp_close+0x32/0x52
 [<c1068747>] sys_close+0x71/0xa5
 [<c1002730>] sysenter_do_call+0x12/0x36
BUG: sleeping function called from invalid context at /opt/cross/sys-root/i686-linux/usr/src/linux-2.6.33-i686-kernel-source/kernel/rtmutex.c:684
pcnt: 0 0 in_atomic(): 0, irqs_disabled(): 1, pid: 350, name: login
3 locks held by login/350:
 #0:  (sk_lock-AF_INET-RPC){+.+...}, at: [<c118a284>] tcp_sendmsg+0x17/0x8b1
 #1:  (rcu_read_lock){.+.+..}, at: [<c116d1ad>] dev_queue_xmit+0x19c/0x431
 #2:  (_xmit_ETHER#2){+.+...}, at: [<c11783f7>] sch_direct_xmit+0x29/0x132
irq event stamp: 13344
hardirqs last  enabled at (13343): [<c11cdda1>] _raw_spin_unlock_irqrestore+0x36/0x51
hardirqs last disabled at (13344): [<c11492e0>] ei_start_xmit+0x92/0x266
softirqs last  enabled at (0): [<c1017f09>] copy_process+0x2f9/0xff2
softirqs last disabled at (0): [<(null)>] (null)
Pid: 350, comm: login Not tainted 2.6.33.3-rt19-i686-pc #1
Call Trace:
 [<c1014af5>] __might_sleep+0xd1/0xd9
 [<c11cd697>] rt_spin_lock+0x25/0x62
 [<c11492e8>] ei_start_xmit+0x9a/0x266
 [<c116ce8b>] dev_hard_start_xmit+0x24d/0x2ec
 [<c1178416>] sch_direct_xmit+0x48/0x132
 [<c11cd6cc>] ? rt_spin_lock+0x5a/0x62
 [<c116d2d9>] dev_queue_xmit+0x2c8/0x431
 [<c118416d>] ip_finish_output+0x1fa/0x235
 [<c1184200>] ip_output+0x58/0x5d
 [<c118266c>] ip_local_out+0x51/0x55
 [<c1183c23>] ip_queue_xmit+0x298/0x2ce
 [<c1195c44>] ? tcp_v4_send_check+0x7d/0xb1
 [<c119298a>] tcp_transmit_skb+0x605/0x63b
 [<c11cdda1>] ? _raw_spin_unlock_irqrestore+0x36/0x51
 [<c1034f02>] ? trace_hardirqs_on_caller+0xfe/0x11f
 [<c1194acb>] tcp_write_xmit+0x756/0x834
 [<c1067c35>] ? __kmalloc+0xe1/0x135
 [<c1194bf6>] __tcp_push_pending_frames+0x21/0x75
 [<c118aa47>] tcp_sendmsg+0x7da/0x8b1
 [<c10a9085>] ? __nfs_revalidate_inode+0x10f/0x195
 [<c1160afe>] sock_sendmsg+0xa4/0xba
 [<c1160b3c>] kernel_sendmsg+0x28/0x37
 [<c11b49af>] xs_send_kvec+0x6d/0x77
 [<c11b4a1b>] xs_sendpages+0x62/0x172
 [<c11cd027>] ? rt_spin_lock_slowunlock+0x3b/0x5e
 [<c11b4c0c>] xs_tcp_send_request+0x41/0x117
 [<c11b336d>] xprt_transmit+0x156/0x250
 [<c11b1168>] call_transmit+0x1b2/0x1ed
 [<c11b6cc6>] __rpc_execute+0x6e/0x1f6
 [<c11b6e64>] rpc_execute+0x16/0x19
 [<c11b1972>] rpc_run_task+0x3a/0x42
 [<c11b1a59>] rpc_call_sync+0x3d/0x58
 [<c10aea4d>] nfs_proc_getattr+0x4e/0x70
 [<c10a9013>] __nfs_revalidate_inode+0x9d/0x195
 [<c11cdda1>] ? _raw_spin_unlock_irqrestore+0x36/0x51
 [<c1034f02>] ? trace_hardirqs_on_caller+0xfe/0x11f
 [<c1034f2e>] ? trace_hardirqs_on+0xb/0xd
 [<c11cd027>] ? rt_spin_lock_slowunlock+0x3b/0x5e
 [<c11cd70a>] ? rt_spin_unlock+0x36/0x39
 [<c1066be9>] ? kmem_cache_free+0x79/0xb0
 [<c1091e8c>] ? locks_free_lock+0x43/0x46
 [<c10a79c3>] nfs_revalidate_file_size+0x4e/0x56
 [<c10a7c68>] nfs_file_llseek+0x64/0xbc
 [<c10a7c04>] ? nfs_file_llseek+0x0/0xbc
 [<c10698d3>] vfs_llseek+0x40/0x47
 [<c106a5d0>] sys_llseek+0x37/0x75
 [<c1002730>] sysenter_do_call+0x12/0x36
BUG: sleeping function called from invalid context at /opt/cross/sys-root/i686-linux/usr/src/linux-2.6.33-i686-kernel-source/kernel/rtmutex.c:684
pcnt: 0 0 in_atomic(): 0, irqs_disabled(): 1, pid: 357, name: ntpd
3 locks held by ntpd/357:
 #0:  (sk_lock-AF_INET){+.+.+.}, at: [<c119be3c>] udp_sendmsg+0x378/0x514
 #1:  (rcu_read_lock){.+.+..}, at: [<c116d1ad>] dev_queue_xmit+0x19c/0x431
 #2:  (_xmit_ETHER#2){+.+...}, at: [<c11783f7>] sch_direct_xmit+0x29/0x132
irq event stamp: 6266
hardirqs last  enabled at (6265): [<c11cdda1>] _raw_spin_unlock_irqrestore+0x36/0x51
hardirqs last disabled at (6266): [<c11492e0>] ei_start_xmit+0x92/0x266
softirqs last  enabled at (0): [<c1017f09>] copy_process+0x2f9/0xff2
softirqs last disabled at (0): [<(null)>] (null)
Pid: 357, comm: ntpd Not tainted 2.6.33.3-rt19-i686-pc #1
Call Trace:
 [<c1014af5>] __might_sleep+0xd1/0xd9
 [<c11cd697>] rt_spin_lock+0x25/0x62
 [<c11492e8>] ei_start_xmit+0x9a/0x266
 [<c116ce8b>] dev_hard_start_xmit+0x24d/0x2ec
 [<c1178416>] sch_direct_xmit+0x48/0x132
 [<c11cd6cc>] ? rt_spin_lock+0x5a/0x62
 [<c116d2d9>] dev_queue_xmit+0x2c8/0x431
 [<c118416d>] ip_finish_output+0x1fa/0x235
 [<c1184200>] ip_output+0x58/0x5d
 [<c118266c>] ip_local_out+0x51/0x55
 [<c11828ca>] ip_push_pending_frames+0x25a/0x2a1
 [<c119b095>] udp_push_pending_frames+0x26e/0x2cf
 [<c119bef8>] ? udp_sendmsg+0x434/0x514
 [<c119bf17>] udp_sendmsg+0x453/0x514
 [<c11a1050>] inet_sendmsg+0x3d/0x46
 [<c1160afe>] sock_sendmsg+0xa4/0xba
 [<c103718d>] ? lock_release_non_nested+0x86/0x221
 [<c1058c05>] ? might_fault+0x41/0x7f
 [<c1058c05>] ? might_fault+0x41/0x7f
 [<c10d5c4c>] ? _copy_from_user+0x2d/0x68
 [<c11611da>] sys_sendto+0xa4/0xc3
 [<c1034f02>] ? trace_hardirqs_on_caller+0xfe/0x11f
 [<c103718d>] ? lock_release_non_nested+0x86/0x221
 [<c1058c05>] ? might_fault+0x41/0x7f
 [<c1161f05>] sys_socketcall+0xe1/0x18b
 [<c1002730>] sysenter_do_call+0x12/0x36
BUG: sleeping function called from invalid context at /opt/cross/sys-root/i686-linux/usr/src/linux-2.6.33-i686-kernel-source/kernel/rtmutex.c:684
pcnt: 0 0 in_atomic(): 0, irqs_disabled(): 1, pid: 357, name: ntpd
3 locks held by ntpd/357:
 #0:  (sk_lock-AF_INET){+.+.+.}, at: [<c119be3c>] udp_sendmsg+0x378/0x514
 #1:  (rcu_read_lock){.+.+..}, at: [<c116d1ad>] dev_queue_xmit+0x19c/0x431
 #2:  (_xmit_ETHER#2){+.+...}, at: [<c11783f7>] sch_direct_xmit+0x29/0x132
irq event stamp: 7712
hardirqs last  enabled at (7711): [<c11cdda1>] _raw_spin_unlock_irqrestore+0x36/0x51
hardirqs last disabled at (7712): [<c11492e0>] ei_start_xmit+0x92/0x266
softirqs last  enabled at (0): [<c1017f09>] copy_process+0x2f9/0xff2
softirqs last disabled at (0): [<(null)>] (null)
Pid: 357, comm: ntpd Not tainted 2.6.33.3-rt19-i686-pc #1
Call Trace:
 [<c1014af5>] __might_sleep+0xd1/0xd9
 [<c11cd697>] rt_spin_lock+0x25/0x62
 [<c11492e8>] ei_start_xmit+0x9a/0x266
 [<c116ce8b>] dev_hard_start_xmit+0x24d/0x2ec
 [<c1178416>] sch_direct_xmit+0x48/0x132
 [<c11cd6cc>] ? rt_spin_lock+0x5a/0x62
 [<c116d2d9>] dev_queue_xmit+0x2c8/0x431
 [<c118416d>] ip_finish_output+0x1fa/0x235
 [<c1184200>] ip_output+0x58/0x5d
 [<c118266c>] ip_local_out+0x51/0x55
 [<c11828ca>] ip_push_pending_frames+0x25a/0x2a1
 [<c119b095>] udp_push_pending_frames+0x26e/0x2cf
 [<c119bef8>] ? udp_sendmsg+0x434/0x514
 [<c119bf17>] udp_sendmsg+0x453/0x514
 [<c11a1050>] inet_sendmsg+0x3d/0x46
 [<c1160afe>] sock_sendmsg+0xa4/0xba
 [<c103718d>] ? lock_release_non_nested+0x86/0x221
 [<c1058c05>] ? might_fault+0x41/0x7f
 [<c1058c05>] ? might_fault+0x41/0x7f
 [<c10d5c4c>] ? _copy_from_user+0x2d/0x68
 [<c11611da>] sys_sendto+0xa4/0xc3
 [<c1034f02>] ? trace_hardirqs_on_caller+0xfe/0x11f
 [<c103718d>] ? lock_release_non_nested+0x86/0x221
 [<c1058c05>] ? might_fault+0x41/0x7f
 [<c1161f05>] sys_socketcall+0xe1/0x18b
 [<c1002730>] sysenter_do_call+0x12/0x36
BUG: sleeping function called from invalid context at /opt/cross/sys-root/i686-linux/usr/src/linux-2.6.33-i686-kernel-source/kernel/rtmutex.c:684
pcnt: 0 0 in_atomic(): 0, irqs_disabled(): 1, pid: 357, name: ntpd
3 locks held by ntpd/357:
 #0:  (sk_lock-AF_INET){+.+.+.}, at: [<c119be3c>] udp_sendmsg+0x378/0x514
 #1:  (rcu_read_lock){.+.+..}, at: [<c116d1ad>] dev_queue_xmit+0x19c/0x431
 #2:  (_xmit_ETHER#2){+.+...}, at: [<c11783f7>] sch_direct_xmit+0x29/0x132
irq event stamp: 8068
hardirqs last  enabled at (8067): [<c11cdda1>] _raw_spin_unlock_irqrestore+0x36/0x51
hardirqs last disabled at (8068): [<c11492e0>] ei_start_xmit+0x92/0x266
softirqs last  enabled at (0): [<c1017f09>] copy_process+0x2f9/0xff2
softirqs last disabled at (0): [<(null)>] (null)
Pid: 357, comm: ntpd Not tainted 2.6.33.3-rt19-i686-pc #1
Call Trace:
 [<c1014af5>] __might_sleep+0xd1/0xd9
 [<c11cd697>] rt_spin_lock+0x25/0x62
 [<c11492e8>] ei_start_xmit+0x9a/0x266
 [<c116ce8b>] dev_hard_start_xmit+0x24d/0x2ec
 [<c1178416>] sch_direct_xmit+0x48/0x132
 [<c11cd6cc>] ? rt_spin_lock+0x5a/0x62
 [<c116d2d9>] dev_queue_xmit+0x2c8/0x431
 [<c118416d>] ip_finish_output+0x1fa/0x235
 [<c1184200>] ip_output+0x58/0x5d
 [<c118266c>] ip_local_out+0x51/0x55
 [<c11828ca>] ip_push_pending_frames+0x25a/0x2a1
 [<c119b095>] udp_push_pending_frames+0x26e/0x2cf
 [<c119bef8>] ? udp_sendmsg+0x434/0x514
 [<c119bf17>] udp_sendmsg+0x453/0x514
 [<c11a1050>] inet_sendmsg+0x3d/0x46
 [<c1160afe>] sock_sendmsg+0xa4/0xba
 [<c103718d>] ? lock_release_non_nested+0x86/0x221
 [<c1058c05>] ? might_fault+0x41/0x7f
 [<c1058c05>] ? might_fault+0x41/0x7f
 [<c10d5c4c>] ? _copy_from_user+0x2d/0x68
 [<c11611da>] sys_sendto+0xa4/0xc3
 [<c1034f02>] ? trace_hardirqs_on_caller+0xfe/0x11f
 [<c103718d>] ? lock_release_non_nested+0x86/0x221
 [<c1058c05>] ? might_fault+0x41/0x7f
 [<c1161f05>] sys_socketcall+0xe1/0x18b
 [<c1002730>] sysenter_do_call+0x12/0x36
BUG: sleeping function called from invalid context at /opt/cross/sys-root/i686-linux/usr/src/linux-2.6.33-i686-kernel-source/kernel/rtmutex.c:684
pcnt: 0 0 in_atomic(): 0, irqs_disabled(): 1, pid: 350, name: sh
4 locks held by sh/350:
 #0:  (&sb->s_type->i_mutex_key#3){+.+.+.}, at: [<c1072f5a>] do_filp_open+0x1ed/0x753
 #1:  (sk_lock-AF_INET-RPC){+.+...}, at: [<c118a284>] tcp_sendmsg+0x17/0x8b1
 #2:  (rcu_read_lock){.+.+..}, at: [<c116d1ad>] dev_queue_xmit+0x19c/0x431
 #3:  (_xmit_ETHER#2){+.+...}, at: [<c11783f7>] sch_direct_xmit+0x29/0x132
irq event stamp: 32344
hardirqs last  enabled at (32343): [<c11cdda1>] _raw_spin_unlock_irqrestore+0x36/0x51
hardirqs last disabled at (32344): [<c11492e0>] ei_start_xmit+0x92/0x266
softirqs last  enabled at (0): [<c1017f09>] copy_process+0x2f9/0xff2
softirqs last disabled at (0): [<(null)>] (null)
Pid: 350, comm: sh Not tainted 2.6.33.3-rt19-i686-pc #1
Call Trace:
 [<c1014af5>] __might_sleep+0xd1/0xd9
 [<c11cd697>] rt_spin_lock+0x25/0x62
 [<c11492e8>] ei_start_xmit+0x9a/0x266
 [<c116ce8b>] dev_hard_start_xmit+0x24d/0x2ec
 [<c1178416>] sch_direct_xmit+0x48/0x132
 [<c11cd6cc>] ? rt_spin_lock+0x5a/0x62
 [<c116d2d9>] dev_queue_xmit+0x2c8/0x431
 [<c118416d>] ip_finish_output+0x1fa/0x235
 [<c1184200>] ip_output+0x58/0x5d
 [<c118266c>] ip_local_out+0x51/0x55
 [<c1183c23>] ip_queue_xmit+0x298/0x2ce
 [<c1195c44>] ? tcp_v4_send_check+0x7d/0xb1
 [<c119298a>] tcp_transmit_skb+0x605/0x63b
 [<c1194acb>] tcp_write_xmit+0x756/0x834
 [<c1067c35>] ? __kmalloc+0xe1/0x135
 [<c1194bf6>] __tcp_push_pending_frames+0x21/0x75
 [<c118aa47>] tcp_sendmsg+0x7da/0x8b1
 [<c1160afe>] sock_sendmsg+0xa4/0xba
 [<c1160b3c>] kernel_sendmsg+0x28/0x37
 [<c11b49af>] xs_send_kvec+0x6d/0x77
 [<c11b4a1b>] xs_sendpages+0x62/0x172
 [<c11cd027>] ? rt_spin_lock_slowunlock+0x3b/0x5e
 [<c11b4c0c>] xs_tcp_send_request+0x41/0x117
 [<c11b336d>] xprt_transmit+0x156/0x250
 [<c11b1168>] call_transmit+0x1b2/0x1ed
 [<c11b6cc6>] __rpc_execute+0x6e/0x1f6
 [<c11b6e64>] rpc_execute+0x16/0x19
 [<c11b1972>] rpc_run_task+0x3a/0x42
 [<c11b1a59>] rpc_call_sync+0x3d/0x58
 [<c10aea4d>] nfs_proc_getattr+0x4e/0x70
 [<c10a9013>] __nfs_revalidate_inode+0x9d/0x195
 [<c1034cd5>] ? mark_held_locks+0x43/0x5b
 [<c11cdda1>] ? _raw_spin_unlock_irqrestore+0x36/0x51
 [<c1034f02>] ? trace_hardirqs_on_caller+0xfe/0x11f
 [<c1034f2e>] ? trace_hardirqs_on+0xb/0xd
 [<c11cd027>] ? rt_spin_lock_slowunlock+0x3b/0x5e
 [<c11cd70a>] ? rt_spin_unlock+0x36/0x39
 [<c10a4be5>] nfs_lookup_revalidate+0x243/0x436
 [<c1034cd5>] ? mark_held_locks+0x43/0x5b
 [<c11cdda1>] ? _raw_spin_unlock_irqrestore+0x36/0x51
 [<c1034f02>] ? trace_hardirqs_on_caller+0xfe/0x11f
 [<c1034f2e>] ? trace_hardirqs_on+0xb/0xd
 [<c11cd027>] ? rt_spin_lock_slowunlock+0x3b/0x5e
 [<c10786e8>] ? __d_lookup+0x124/0x12e
 [<c1070a26>] __lookup_hash+0x70/0xee
 [<c1070ac6>] lookup_hash+0x22/0x25
 [<c1072f62>] do_filp_open+0x1f5/0x753
 [<c11cd027>] ? rt_spin_lock_slowunlock+0x3b/0x5e
 [<c11cd70a>] ? rt_spin_unlock+0x36/0x39
 [<c10687bb>] do_sys_open+0x40/0x76
 [<c1068833>] sys_open+0x1e/0x26
 [<c1002730>] sysenter_do_call+0x12/0x36
