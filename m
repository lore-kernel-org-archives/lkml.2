Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315Ab1IRNQw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Sep 2011 09:16:52 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42631 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138Ab1IRNQs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Sep 2011 09:16:48 -0400
MIME-Version: 1.0
In-Reply-To: <1316080416-26053-1-git-send-email-keguang.zhang@gmail.com>
References: <1316080416-26053-1-git-send-email-keguang.zhang@gmail.com>
Date: Sun, 18 Sep 2011 21:16:47 +0800
Message-ID: <CAD+V5Y+xR_QMOVfQKD7=e=NjEtLRXtV79MP0ffTOgjP=0_zXKg@mail.gmail.com>
Subject: Re: [PATCH] MIPS: Add basic support for Loongson1B (UPDATED)
From: wu zhangjin <wuzhangjin@gmail.com>
To: keguang.zhang@gmail.com
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        ralf@linux-mips.org, r0bertz@gentoo.org, chenj@lemote.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 15, 2011 at 5:53 PM,  <keguang.zhang@gmail.com> wrote:
> From: Zhang, Keguang <keguang.zhang@gmail.com>
>
> This patch adds basic support for Loongson1B
> including serial, timer and interrupt handler.
>
> Loongson 1B is a 32-bit SoC designed by Institute of
> Computing Technology (ICT), Chinese Academy of Sciences (CAS),
> which implements the MIPS32 release 2 instruction set.
>
> Signed-off-by: Zhang, Keguang <keguang.zhang@gmail.com>
> ---
>  arch/mips/Kbuild.platforms                       |    1 +
>  arch/mips/Kconfig                                |   31 +
>  arch/mips/configs/ls1b_defconfig                 |  830 ++++++++++++++++++++++
>  arch/mips/include/asm/cpu.h                      |    3 +-
>  arch/mips/include/asm/mach-loongson1/irq.h       |   70 ++
>  arch/mips/include/asm/mach-loongson1/loongson1.h |   48 ++
>  arch/mips/include/asm/mach-loongson1/platform.h  |   20 +
>  arch/mips/include/asm/mach-loongson1/prom.h      |   24 +
>  arch/mips/include/asm/mach-loongson1/regs-clk.h  |   32 +
>  arch/mips/include/asm/mach-loongson1/regs-intc.h |   24 +
>  arch/mips/include/asm/mach-loongson1/regs-wdt.h  |   21 +
>  arch/mips/include/asm/mach-loongson1/war.h       |   25 +
>  arch/mips/include/asm/module.h                   |    2 +
>  arch/mips/kernel/cpu-probe.c                     |   15 +
>  arch/mips/kernel/perf_event_mipsxx.c             |    6 +
>  arch/mips/kernel/traps.c                         |    1 +
>  arch/mips/loongson1/Kconfig                      |   29 +
>  arch/mips/loongson1/Makefile                     |   11 +
>  arch/mips/loongson1/Platform                     |    7 +
>  arch/mips/loongson1/common/Makefile              |    5 +
>  arch/mips/loongson1/common/clock.c               |  165 +++++
>  arch/mips/loongson1/common/irq.c                 |  135 ++++
>  arch/mips/loongson1/common/platform.c            |   50 ++
>  arch/mips/loongson1/common/prom.c                |   89 +++
>  arch/mips/loongson1/common/reset.c               |   46 ++
>  arch/mips/loongson1/common/setup.c               |   29 +
>  arch/mips/loongson1/ls1b/Makefile                |    5 +
>  arch/mips/loongson1/ls1b/board.c                 |   30 +
>  arch/mips/oprofile/common.c                      |    1 +
>  arch/mips/oprofile/op_model_mipsxx.c             |    4 +
>  30 files changed, 1758 insertions(+), 1 deletions(-)
>  create mode 100644 arch/mips/configs/ls1b_defconfig
>  create mode 100644 arch/mips/include/asm/mach-loongson1/irq.h
>  create mode 100644 arch/mips/include/asm/mach-loongson1/loongson1.h
>  create mode 100644 arch/mips/include/asm/mach-loongson1/platform.h
>  create mode 100644 arch/mips/include/asm/mach-loongson1/prom.h
>  create mode 100644 arch/mips/include/asm/mach-loongson1/regs-clk.h
>  create mode 100644 arch/mips/include/asm/mach-loongson1/regs-intc.h
>  create mode 100644 arch/mips/include/asm/mach-loongson1/regs-wdt.h
>  create mode 100644 arch/mips/include/asm/mach-loongson1/war.h
>  create mode 100644 arch/mips/loongson1/Kconfig
>  create mode 100644 arch/mips/loongson1/Makefile
>  create mode 100644 arch/mips/loongson1/Platform
>  create mode 100644 arch/mips/loongson1/common/Makefile
>  create mode 100644 arch/mips/loongson1/common/clock.c
>  create mode 100644 arch/mips/loongson1/common/irq.c
>  create mode 100644 arch/mips/loongson1/common/platform.c
>  create mode 100644 arch/mips/loongson1/common/prom.c
>  create mode 100644 arch/mips/loongson1/common/reset.c
>  create mode 100644 arch/mips/loongson1/common/setup.c
>  create mode 100644 arch/mips/loongson1/ls1b/Makefile
>  create mode 100644 arch/mips/loongson1/ls1b/board.c
>
> diff --git a/arch/mips/Kbuild.platforms b/arch/mips/Kbuild.platforms
> index 5ce8029..d64786d 100644
> --- a/arch/mips/Kbuild.platforms
> +++ b/arch/mips/Kbuild.platforms
> @@ -14,6 +14,7 @@ platforms += jz4740
>  platforms += lantiq
>  platforms += lasat
>  platforms += loongson
> +platforms += loongson1
>  platforms += mipssim
>  platforms += mti-malta
>  platforms += netlogic
> diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
> index b122adc..d693f48 100644
> --- a/arch/mips/Kconfig
> +++ b/arch/mips/Kconfig
> @@ -259,6 +259,17 @@ config MACH_LOONGSON
>          Chinese Academy of Sciences (CAS) in the People's Republic
>          of China. The chief architect is Professor Weiwu Hu.
>
> +config MACH_LOONGSON1
> +       bool "Loongson1 family of machines"
> +       select SYS_SUPPORTS_ZBOOT
> +       help
> +         This enables the support of Loongson1 family of machines.
> +
> +         Loongson1 is a family of 32-bit MIPS-compatible SoCs.
> +         developed at Institute of Computing Technology (ICT),
> +         Chinese Academy of Sciences (CAS) in the People's Republic
> +         of China.
> +
>  config MIPS_MALTA
>        bool "MIPS Malta board"
>        select ARCH_MAY_HAVE_PC_FDC
> @@ -804,6 +815,7 @@ source "arch/mips/txx9/Kconfig"
>  source "arch/mips/vr41xx/Kconfig"
>  source "arch/mips/cavium-octeon/Kconfig"
>  source "arch/mips/loongson/Kconfig"
> +source "arch/mips/loongson1/Kconfig"
>  source "arch/mips/netlogic/Kconfig"
>
>  endmenu
> @@ -1197,6 +1209,14 @@ config CPU_LOONGSON2F
>          have a similar programming interface with FPGA northbridge used in
>          Loongson2E.
>
> +config CPU_LOONGSON1B
> +       bool "Loongson 1B"
> +       depends on SYS_HAS_CPU_LOONGSON1B
> +       select CPU_LOONGSON1
> +       help
> +         The Loongson 1B is a 32-bit SoC, which implements the MIPS32 release 2
> +         instruction set.
> +
>  config CPU_MIPS32_R1
>        bool "MIPS32 Release 1"
>        depends on SYS_HAS_CPU_MIPS32_R1
> @@ -1525,6 +1545,14 @@ config CPU_LOONGSON2
>        select CPU_SUPPORTS_64BIT_KERNEL
>        select CPU_SUPPORTS_HIGHMEM
>
> +config CPU_LOONGSON1
> +       bool
> +       select CPU_MIPS32
> +       select CPU_MIPSR2
> +       select CPU_HAS_PREFETCH
> +       select CPU_SUPPORTS_32BIT_KERNEL
> +       select CPU_SUPPORTS_HIGHMEM
> +
>  config SYS_HAS_CPU_LOONGSON2E
>        bool
>
> @@ -1534,6 +1562,9 @@ config SYS_HAS_CPU_LOONGSON2F
>        select CPU_SUPPORTS_ADDRWINCFG if 64BIT
>        select CPU_SUPPORTS_UNCACHED_ACCELERATED
>
> +config SYS_HAS_CPU_LOONGSON1B
> +       bool
> +
>  config SYS_HAS_CPU_MIPS32_R1
>        bool
>
> diff --git a/arch/mips/configs/ls1b_defconfig b/arch/mips/configs/ls1b_defconfig
> new file mode 100644
> index 0000000..6463311
> --- /dev/null
> +++ b/arch/mips/configs/ls1b_defconfig
> @@ -0,0 +1,830 @@
> +#
> +# Automatically generated make config: don't edit
> +# Linux/mips 3.0.3 Kernel Configuration
> +#
> +CONFIG_MIPS=y
> +
> +#
> +# Machine selection
> +#
> +# CONFIG_MIPS_ALCHEMY is not set
> +# CONFIG_AR7 is not set
> +# CONFIG_ATH79 is not set
> +# CONFIG_BCM47XX is not set
> +# CONFIG_BCM63XX is not set
> +# CONFIG_MIPS_COBALT is not set
> +# CONFIG_MACH_DECSTATION is not set
> +# CONFIG_MACH_JAZZ is not set
> +# CONFIG_MACH_JZ4740 is not set
> +# CONFIG_LANTIQ is not set
> +# CONFIG_LASAT is not set
> +# CONFIG_MACH_LOONGSON is not set
> +CONFIG_MACH_LOONGSON1=y
> +# CONFIG_MIPS_MALTA is not set
> +# CONFIG_MIPS_SIM is not set
> +# CONFIG_NEC_MARKEINS is not set
> +# CONFIG_MACH_VR41XX is not set
> +# CONFIG_NXP_STB220 is not set
> +# CONFIG_NXP_STB225 is not set
> +# CONFIG_PNX8550_JBS is not set
> +# CONFIG_PNX8550_STB810 is not set
> +# CONFIG_PMC_MSP is not set
> +# CONFIG_PMC_YOSEMITE is not set
> +# CONFIG_POWERTV is not set
> +# CONFIG_SGI_IP22 is not set
> +# CONFIG_SGI_IP27 is not set
> +# CONFIG_SGI_IP28 is not set
> +# CONFIG_SGI_IP32 is not set
> +# CONFIG_SIBYTE_CRHINE is not set
> +# CONFIG_SIBYTE_CARMEL is not set
> +# CONFIG_SIBYTE_CRHONE is not set
> +# CONFIG_SIBYTE_RHONE is not set
> +# CONFIG_SIBYTE_SWARM is not set
> +# CONFIG_SIBYTE_LITTLESUR is not set
> +# CONFIG_SIBYTE_SENTOSA is not set
> +# CONFIG_SIBYTE_BIGSUR is not set
> +# CONFIG_SNI_RM is not set
> +# CONFIG_MACH_TX39XX is not set
> +# CONFIG_MACH_TX49XX is not set
> +# CONFIG_MIKROTIK_RB532 is not set
> +# CONFIG_WR_PPMC is not set
> +# CONFIG_CAVIUM_OCTEON_SIMULATOR is not set
> +# CONFIG_CAVIUM_OCTEON_REFERENCE_BOARD is not set
> +# CONFIG_NLM_XLR_BOARD is not set
> +# CONFIG_ALCHEMY_GPIO_INDIRECT is not set
> +CONFIG_ARCH_SPARSEMEM_ENABLE=y
> +CONFIG_LOONGSON1_LS1B=y
> +CONFIG_RWSEM_GENERIC_SPINLOCK=y
> +# CONFIG_ARCH_HAS_ILOG2_U32 is not set
> +# CONFIG_ARCH_HAS_ILOG2_U64 is not set
> +CONFIG_ARCH_SUPPORTS_OPROFILE=y
> +CONFIG_GENERIC_HWEIGHT=y
> +CONFIG_GENERIC_CALIBRATE_DELAY=y
> +CONFIG_GENERIC_CLOCKEVENTS=y
> +CONFIG_GENERIC_CMOS_UPDATE=y
> +CONFIG_SCHED_OMIT_FRAME_POINTER=y
> +CONFIG_CEVT_R4K_LIB=y
> +CONFIG_CEVT_R4K=y
> +CONFIG_CSRC_R4K_LIB=y
> +CONFIG_CSRC_R4K=y
> +# CONFIG_ARCH_DMA_ADDR_T_64BIT is not set
> +CONFIG_DMA_NONCOHERENT=y
> +CONFIG_NEED_DMA_MAP_STATE=y
> +CONFIG_SYS_HAS_EARLY_PRINTK=y
> +# CONFIG_MIPS_MACHINE is not set
> +# CONFIG_NO_IOPORT is not set
> +CONFIG_CPU_LITTLE_ENDIAN=y
> +CONFIG_SYS_SUPPORTS_LITTLE_ENDIAN=y
> +CONFIG_IRQ_CPU=y
> +CONFIG_BOOT_ELF32=y
> +CONFIG_MIPS_L1_CACHE_SHIFT=5
> +
> +#
> +# CPU selection
> +#
> +CONFIG_CPU_LOONGSON1B=y
> +CONFIG_SYS_SUPPORTS_ZBOOT=y
> +CONFIG_CPU_LOONGSON1=y
> +CONFIG_SYS_HAS_CPU_LOONGSON1B=y
> +CONFIG_CPU_MIPS32=y
> +CONFIG_CPU_MIPSR2=y
> +CONFIG_SYS_SUPPORTS_32BIT_KERNEL=y
> +CONFIG_CPU_SUPPORTS_32BIT_KERNEL=y
> +CONFIG_HARDWARE_WATCHPOINTS=y
> +
> +#
> +# Kernel type
> +#
> +CONFIG_32BIT=y
> +CONFIG_PAGE_SIZE_4KB=y
> +# CONFIG_PAGE_SIZE_16KB is not set
> +# CONFIG_PAGE_SIZE_64KB is not set
> +CONFIG_FORCE_MAX_ZONEORDER=11
> +CONFIG_CPU_HAS_PREFETCH=y
> +CONFIG_MIPS_MT_DISABLED=y
> +# CONFIG_ARCH_PHYS_ADDR_T_64BIT is not set
> +CONFIG_CPU_HAS_SYNC=y
> +# CONFIG_HIGHMEM is not set
> +CONFIG_CPU_SUPPORTS_HIGHMEM=y
> +CONFIG_SYS_SUPPORTS_HIGHMEM=y
> +CONFIG_ARCH_FLATMEM_ENABLE=y
> +CONFIG_ARCH_POPULATES_NODE_MAP=y
> +CONFIG_HW_PERF_EVENTS=y
> +CONFIG_SELECT_MEMORY_MODEL=y
> +CONFIG_FLATMEM_MANUAL=y
> +# CONFIG_SPARSEMEM_MANUAL is not set
> +CONFIG_FLATMEM=y
> +CONFIG_FLAT_NODE_MEM_MAP=y
> +CONFIG_SPARSEMEM_STATIC=y
> +CONFIG_PAGEFLAGS_EXTENDED=y
> +CONFIG_SPLIT_PTLOCK_CPUS=4
> +# CONFIG_COMPACTION is not set
> +# CONFIG_PHYS_ADDR_T_64BIT is not set
> +CONFIG_ZONE_DMA_FLAG=0
> +CONFIG_VIRT_TO_BUS=y
> +# CONFIG_KSM is not set
> +CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
> +CONFIG_NEED_PER_CPU_KM=y
> +# CONFIG_CLEANCACHE is not set
> +CONFIG_TICK_ONESHOT=y
> +# CONFIG_NO_HZ is not set
> +CONFIG_HIGH_RES_TIMERS=y
> +CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
> +# CONFIG_HZ_48 is not set
> +# CONFIG_HZ_100 is not set
> +# CONFIG_HZ_128 is not set
> +CONFIG_HZ_250=y
> +# CONFIG_HZ_256 is not set
> +# CONFIG_HZ_1000 is not set
> +# CONFIG_HZ_1024 is not set
> +CONFIG_SYS_SUPPORTS_ARBIT_HZ=y
> +CONFIG_HZ=250
> +# CONFIG_PREEMPT_NONE is not set
> +CONFIG_PREEMPT_VOLUNTARY=y
> +# CONFIG_PREEMPT is not set
> +CONFIG_KEXEC=y
> +# CONFIG_SECCOMP is not set
> +# CONFIG_USE_OF is not set
> +CONFIG_LOCKDEP_SUPPORT=y
> +CONFIG_STACKTRACE_SUPPORT=y
> +CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
> +CONFIG_HAVE_IRQ_WORK=y
> +CONFIG_IRQ_WORK=y
> +
> +#
> +# General setup
> +#
> +CONFIG_EXPERIMENTAL=y
> +CONFIG_BROKEN_ON_SMP=y
> +CONFIG_INIT_ENV_ARG_LIMIT=32
> +CONFIG_CROSS_COMPILE=""
> +CONFIG_LOCALVERSION=""
> +# CONFIG_LOCALVERSION_AUTO is not set
> +CONFIG_HAVE_KERNEL_GZIP=y
> +CONFIG_HAVE_KERNEL_BZIP2=y
> +CONFIG_HAVE_KERNEL_LZMA=y
> +CONFIG_HAVE_KERNEL_LZO=y
> +CONFIG_KERNEL_GZIP=y
> +# CONFIG_KERNEL_BZIP2 is not set
> +# CONFIG_KERNEL_LZMA is not set
> +# CONFIG_KERNEL_LZO is not set
> +CONFIG_DEFAULT_HOSTNAME="(none)"
> +CONFIG_SWAP=y
> +CONFIG_SYSVIPC=y
> +CONFIG_SYSVIPC_SYSCTL=y
> +# CONFIG_POSIX_MQUEUE is not set
> +CONFIG_BSD_PROCESS_ACCT=y
> +CONFIG_BSD_PROCESS_ACCT_V3=y
> +# CONFIG_FHANDLE is not set
> +# CONFIG_TASKSTATS is not set
> +# CONFIG_AUDIT is not set
> +CONFIG_HAVE_GENERIC_HARDIRQS=y
> +
> +#
> +# IRQ subsystem
> +#
> +CONFIG_GENERIC_HARDIRQS=y
> +CONFIG_GENERIC_IRQ_PROBE=y
> +CONFIG_GENERIC_IRQ_SHOW=y
> +
> +#
> +# RCU Subsystem
> +#
> +CONFIG_TINY_RCU=y
> +# CONFIG_PREEMPT_RCU is not set
> +# CONFIG_RCU_TRACE is not set
> +# CONFIG_TREE_RCU_TRACE is not set
> +CONFIG_IKCONFIG=y
> +CONFIG_IKCONFIG_PROC=y
> +CONFIG_LOG_BUF_SHIFT=16
> +# CONFIG_CGROUPS is not set
> +# CONFIG_NAMESPACES is not set
> +# CONFIG_SCHED_AUTOGROUP is not set
> +# CONFIG_SYSFS_DEPRECATED is not set
> +# CONFIG_RELAY is not set
> +CONFIG_BLK_DEV_INITRD=y
> +CONFIG_INITRAMFS_SOURCE=""
> +CONFIG_RD_GZIP=y
> +CONFIG_RD_BZIP2=y
> +CONFIG_RD_LZMA=y
> +CONFIG_RD_XZ=y
> +CONFIG_RD_LZO=y
> +# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
> +CONFIG_SYSCTL=y
> +CONFIG_ANON_INODES=y
> +CONFIG_EXPERT=y
> +CONFIG_SYSCTL_SYSCALL=y
> +CONFIG_KALLSYMS=y
> +CONFIG_KALLSYMS_ALL=y
> +CONFIG_HOTPLUG=y
> +CONFIG_PRINTK=y
> +CONFIG_BUG=y
> +CONFIG_ELF_CORE=y
> +CONFIG_PCSPKR_PLATFORM=y
> +CONFIG_BASE_FULL=y
> +CONFIG_FUTEX=y
> +CONFIG_EPOLL=y
> +CONFIG_SIGNALFD=y
> +CONFIG_TIMERFD=y
> +CONFIG_EVENTFD=y
> +CONFIG_SHMEM=y
> +CONFIG_AIO=y
> +# CONFIG_EMBEDDED is not set
> +CONFIG_HAVE_PERF_EVENTS=y
> +CONFIG_PERF_USE_VMALLOC=y
> +
> +#
> +# Kernel Performance Events And Counters
> +#
> +CONFIG_PERF_EVENTS=y
> +# CONFIG_PERF_COUNTERS is not set
> +# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
> +CONFIG_VM_EVENT_COUNTERS=y
> +CONFIG_SLUB_DEBUG=y
> +# CONFIG_COMPAT_BRK is not set
> +# CONFIG_SLAB is not set
> +CONFIG_SLUB=y
> +# CONFIG_SLOB is not set
> +# CONFIG_PROFILING is not set
> +CONFIG_HAVE_OPROFILE=y
> +# CONFIG_KPROBES is not set
> +# CONFIG_JUMP_LABEL is not set
> +CONFIG_HAVE_KPROBES=y
> +CONFIG_HAVE_KRETPROBES=y
> +CONFIG_HAVE_DMA_ATTRS=y
> +CONFIG_HAVE_DMA_API_DEBUG=y
> +CONFIG_HAVE_ARCH_JUMP_LABEL=y
> +
> +#
> +# GCOV-based kernel profiling
> +#
> +# CONFIG_GCOV_KERNEL is not set
> +CONFIG_HAVE_GENERIC_DMA_COHERENT=y
> +CONFIG_SLABINFO=y
> +CONFIG_RT_MUTEXES=y
> +CONFIG_BASE_SMALL=0
> +CONFIG_MODULES=y
> +# CONFIG_MODULE_FORCE_LOAD is not set
> +CONFIG_MODULE_UNLOAD=y
> +# CONFIG_MODULE_FORCE_UNLOAD is not set
> +CONFIG_MODVERSIONS=y
> +# CONFIG_MODULE_SRCVERSION_ALL is not set
> +CONFIG_BLOCK=y
> +# CONFIG_LBDAF is not set
> +# CONFIG_BLK_DEV_BSG is not set
> +# CONFIG_BLK_DEV_INTEGRITY is not set
> +
> +#
> +# IO Schedulers
> +#
> +CONFIG_IOSCHED_NOOP=y
> +CONFIG_IOSCHED_DEADLINE=y
> +CONFIG_IOSCHED_CFQ=y
> +# CONFIG_DEFAULT_DEADLINE is not set
> +CONFIG_DEFAULT_CFQ=y
> +# CONFIG_DEFAULT_NOOP is not set
> +CONFIG_DEFAULT_IOSCHED="cfq"
> +# CONFIG_INLINE_SPIN_TRYLOCK is not set
> +# CONFIG_INLINE_SPIN_TRYLOCK_BH is not set
> +# CONFIG_INLINE_SPIN_LOCK is not set
> +# CONFIG_INLINE_SPIN_LOCK_BH is not set
> +# CONFIG_INLINE_SPIN_LOCK_IRQ is not set
> +# CONFIG_INLINE_SPIN_LOCK_IRQSAVE is not set
> +CONFIG_INLINE_SPIN_UNLOCK=y
> +# CONFIG_INLINE_SPIN_UNLOCK_BH is not set
> +CONFIG_INLINE_SPIN_UNLOCK_IRQ=y
> +# CONFIG_INLINE_SPIN_UNLOCK_IRQRESTORE is not set
> +# CONFIG_INLINE_READ_TRYLOCK is not set
> +# CONFIG_INLINE_READ_LOCK is not set
> +# CONFIG_INLINE_READ_LOCK_BH is not set
> +# CONFIG_INLINE_READ_LOCK_IRQ is not set
> +# CONFIG_INLINE_READ_LOCK_IRQSAVE is not set
> +CONFIG_INLINE_READ_UNLOCK=y
> +# CONFIG_INLINE_READ_UNLOCK_BH is not set
> +CONFIG_INLINE_READ_UNLOCK_IRQ=y
> +# CONFIG_INLINE_READ_UNLOCK_IRQRESTORE is not set
> +# CONFIG_INLINE_WRITE_TRYLOCK is not set
> +# CONFIG_INLINE_WRITE_LOCK is not set
> +# CONFIG_INLINE_WRITE_LOCK_BH is not set
> +# CONFIG_INLINE_WRITE_LOCK_IRQ is not set
> +# CONFIG_INLINE_WRITE_LOCK_IRQSAVE is not set
> +CONFIG_INLINE_WRITE_UNLOCK=y
> +# CONFIG_INLINE_WRITE_UNLOCK_BH is not set
> +CONFIG_INLINE_WRITE_UNLOCK_IRQ=y
> +# CONFIG_INLINE_WRITE_UNLOCK_IRQRESTORE is not set
> +# CONFIG_MUTEX_SPIN_ON_OWNER is not set
> +# CONFIG_FREEZER is not set
> +
> +#
> +# Bus options (PCI, PCMCIA, EISA, ISA, TC)
> +#
> +# CONFIG_ARCH_SUPPORTS_MSI is not set
> +CONFIG_MMU=y
> +# CONFIG_PCCARD is not set
> +
> +#
> +# Executable file formats
> +#
> +CONFIG_BINFMT_ELF=y
> +# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
> +# CONFIG_HAVE_AOUT is not set
> +# CONFIG_BINFMT_MISC is not set
> +CONFIG_TRAD_SIGNALS=y
> +
> +#
> +# Power management options
> +#
> +CONFIG_ARCH_HIBERNATION_POSSIBLE=y
> +CONFIG_ARCH_SUSPEND_POSSIBLE=y
> +# CONFIG_SUSPEND is not set
> +# CONFIG_HIBERNATION is not set
> +# CONFIG_PM_RUNTIME is not set
> +CONFIG_NET=y
> +
> +#
> +# Networking options
> +#
> +CONFIG_PACKET=y
> +CONFIG_UNIX=y
> +# CONFIG_NET_KEY is not set
> +CONFIG_INET=y
> +# CONFIG_IP_MULTICAST is not set
> +# CONFIG_IP_ADVANCED_ROUTER is not set
> +CONFIG_IP_PNP=y
> +CONFIG_IP_PNP_DHCP=y
> +# CONFIG_IP_PNP_BOOTP is not set
> +# CONFIG_IP_PNP_RARP is not set
> +# CONFIG_NET_IPIP is not set
> +# CONFIG_NET_IPGRE_DEMUX is not set
> +# CONFIG_ARPD is not set
> +CONFIG_SYN_COOKIES=y
> +# CONFIG_INET_AH is not set
> +# CONFIG_INET_ESP is not set
> +# CONFIG_INET_IPCOMP is not set
> +# CONFIG_INET_XFRM_TUNNEL is not set
> +# CONFIG_INET_TUNNEL is not set
> +# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
> +# CONFIG_INET_XFRM_MODE_TUNNEL is not set
> +# CONFIG_INET_XFRM_MODE_BEET is not set
> +CONFIG_INET_LRO=y
> +# CONFIG_INET_DIAG is not set
> +# CONFIG_TCP_CONG_ADVANCED is not set
> +CONFIG_TCP_CONG_CUBIC=y
> +CONFIG_DEFAULT_TCP_CONG="cubic"
> +# CONFIG_TCP_MD5SIG is not set
> +# CONFIG_IPV6 is not set
> +# CONFIG_NETWORK_SECMARK is not set
> +# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
> +# CONFIG_NETFILTER is not set
> +# CONFIG_IP_DCCP is not set
> +# CONFIG_IP_SCTP is not set
> +# CONFIG_RDS is not set
> +# CONFIG_TIPC is not set
> +# CONFIG_ATM is not set
> +# CONFIG_L2TP is not set
> +# CONFIG_BRIDGE is not set
> +# CONFIG_VLAN_8021Q is not set
> +# CONFIG_DECNET is not set
> +# CONFIG_LLC2 is not set
> +# CONFIG_IPX is not set
> +# CONFIG_ATALK is not set
> +# CONFIG_X25 is not set
> +# CONFIG_LAPB is not set
> +# CONFIG_ECONET is not set
> +# CONFIG_WAN_ROUTER is not set
> +# CONFIG_PHONET is not set
> +# CONFIG_IEEE802154 is not set
> +# CONFIG_NET_SCHED is not set
> +# CONFIG_DCB is not set
> +# CONFIG_DNS_RESOLVER is not set
> +# CONFIG_BATMAN_ADV is not set
> +
> +#
> +# Network testing
> +#
> +# CONFIG_NET_PKTGEN is not set
> +# CONFIG_HAMRADIO is not set
> +# CONFIG_CAN is not set
> +# CONFIG_IRDA is not set
> +# CONFIG_BT is not set
> +# CONFIG_AF_RXRPC is not set
> +# CONFIG_WIRELESS is not set
> +# CONFIG_WIMAX is not set
> +# CONFIG_RFKILL is not set
> +# CONFIG_NET_9P is not set
> +# CONFIG_CAIF is not set
> +# CONFIG_CEPH_LIB is not set
> +
> +#
> +# Device Drivers
> +#
> +
> +#
> +# Generic Driver Options
> +#
> +CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
> +CONFIG_DEVTMPFS=y
> +CONFIG_DEVTMPFS_MOUNT=y
> +# CONFIG_STANDALONE is not set
> +CONFIG_PREVENT_FIRMWARE_BUILD=y
> +CONFIG_FW_LOADER=y
> +CONFIG_FIRMWARE_IN_KERNEL=y
> +CONFIG_EXTRA_FIRMWARE=""
> +# CONFIG_DEBUG_DRIVER is not set
> +# CONFIG_DEBUG_DEVRES is not set
> +# CONFIG_SYS_HYPERVISOR is not set
> +# CONFIG_CONNECTOR is not set
> +# CONFIG_MTD is not set
> +# CONFIG_PARPORT is not set
> +CONFIG_BLK_DEV=y
> +# CONFIG_BLK_DEV_COW_COMMON is not set
> +CONFIG_BLK_DEV_LOOP=y
> +# CONFIG_BLK_DEV_CRYPTOLOOP is not set
> +
> +#
> +# DRBD disabled because PROC_FS, INET or CONNECTOR not selected
> +#
> +# CONFIG_BLK_DEV_NBD is not set
> +# CONFIG_BLK_DEV_RAM is not set
> +# CONFIG_CDROM_PKTCDVD is not set
> +# CONFIG_ATA_OVER_ETH is not set
> +# CONFIG_BLK_DEV_HD is not set
> +# CONFIG_BLK_DEV_RBD is not set
> +# CONFIG_SENSORS_LIS3LV02D is not set
> +# CONFIG_MISC_DEVICES is not set
> +CONFIG_HAVE_IDE=y
> +# CONFIG_IDE is not set
> +
> +#
> +# SCSI device support
> +#
> +CONFIG_SCSI_MOD=y
> +# CONFIG_RAID_ATTRS is not set
> +# CONFIG_SCSI is not set
> +# CONFIG_SCSI_DMA is not set
> +# CONFIG_SCSI_NETLINK is not set
> +# CONFIG_ATA is not set
> +# CONFIG_MD is not set
> +# CONFIG_NETDEVICES is not set
> +# CONFIG_ISDN is not set
> +# CONFIG_PHONE is not set
> +
> +#
> +# Input device support
> +#
> +CONFIG_INPUT=y
> +# CONFIG_INPUT_FF_MEMLESS is not set
> +# CONFIG_INPUT_POLLDEV is not set
> +# CONFIG_INPUT_SPARSEKMAP is not set
> +
> +#
> +# Userland interfaces
> +#
> +# CONFIG_INPUT_MOUSEDEV is not set
> +# CONFIG_INPUT_JOYDEV is not set
> +# CONFIG_INPUT_EVDEV is not set
> +# CONFIG_INPUT_EVBUG is not set
> +
> +#
> +# Input Device Drivers
> +#
> +# CONFIG_INPUT_KEYBOARD is not set
> +# CONFIG_INPUT_MOUSE is not set
> +# CONFIG_INPUT_JOYSTICK is not set
> +# CONFIG_INPUT_TABLET is not set
> +# CONFIG_INPUT_TOUCHSCREEN is not set
> +# CONFIG_INPUT_MISC is not set
> +
> +#
> +# Hardware I/O ports
> +#
> +# CONFIG_SERIO is not set
> +# CONFIG_GAMEPORT is not set
> +
> +#
> +# Character devices
> +#
> +CONFIG_VT=y
> +CONFIG_CONSOLE_TRANSLATIONS=y
> +CONFIG_VT_CONSOLE=y
> +CONFIG_HW_CONSOLE=y
> +CONFIG_VT_HW_CONSOLE_BINDING=y
> +CONFIG_UNIX98_PTYS=y
> +# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
> +CONFIG_LEGACY_PTYS=y
> +CONFIG_LEGACY_PTY_COUNT=8
> +# CONFIG_SERIAL_NONSTANDARD is not set
> +# CONFIG_N_GSM is not set
> +# CONFIG_TRACE_SINK is not set
> +# CONFIG_DEVKMEM is not set
> +
> +#
> +# Serial drivers
> +#
> +CONFIG_SERIAL_8250=y
> +CONFIG_SERIAL_8250_CONSOLE=y
> +CONFIG_SERIAL_8250_NR_UARTS=4
> +CONFIG_SERIAL_8250_RUNTIME_UARTS=4
> +# CONFIG_SERIAL_8250_EXTENDED is not set
> +
> +#
> +# Non-8250 serial port support
> +#
> +CONFIG_SERIAL_CORE=y
> +CONFIG_SERIAL_CORE_CONSOLE=y
> +CONFIG_CONSOLE_POLL=y
> +# CONFIG_SERIAL_TIMBERDALE is not set
> +# CONFIG_SERIAL_ALTERA_JTAGUART is not set
> +# CONFIG_SERIAL_ALTERA_UART is not set
> +# CONFIG_SERIAL_XILINX_PS_UART is not set
> +# CONFIG_TTY_PRINTK is not set
> +# CONFIG_IPMI_HANDLER is not set
> +# CONFIG_HW_RANDOM is not set
> +# CONFIG_R3964 is not set
> +# CONFIG_RAW_DRIVER is not set
> +# CONFIG_TCG_TPM is not set
> +CONFIG_RAMOOPS=y
> +# CONFIG_I2C is not set
> +# CONFIG_SPI is not set
> +
> +#
> +# PPS support
> +#
> +# CONFIG_PPS is not set
> +
> +#
> +# PPS generators support
> +#
> +
> +#
> +# PTP clock support
> +#
> +
> +#
> +# Enable Device Drivers -> PPS to see the PTP clock options.
> +#
> +# CONFIG_W1 is not set
> +# CONFIG_POWER_SUPPLY is not set
> +# CONFIG_HWMON is not set
> +# CONFIG_THERMAL is not set
> +# CONFIG_WATCHDOG is not set
> +CONFIG_SSB_POSSIBLE=y
> +
> +#
> +# Sonics Silicon Backplane
> +#
> +# CONFIG_SSB is not set
> +CONFIG_BCMA_POSSIBLE=y
> +
> +#
> +# Broadcom specific AMBA
> +#
> +# CONFIG_BCMA is not set
> +# CONFIG_MFD_SUPPORT is not set
> +# CONFIG_REGULATOR is not set
> +# CONFIG_MEDIA_SUPPORT is not set
> +
> +#
> +# Graphics support
> +#
> +# CONFIG_DRM is not set
> +# CONFIG_VGASTATE is not set
> +# CONFIG_VIDEO_OUTPUT_CONTROL is not set
> +# CONFIG_FB is not set
> +# CONFIG_BACKLIGHT_LCD_SUPPORT is not set
> +
> +#
> +# Display device support
> +#
> +# CONFIG_DISPLAY_SUPPORT is not set
> +
> +#
> +# Console display driver support
> +#
> +# CONFIG_VGA_CONSOLE is not set
> +CONFIG_DUMMY_CONSOLE=y
> +# CONFIG_SOUND is not set
> +# CONFIG_HID_SUPPORT is not set
> +# CONFIG_USB_SUPPORT is not set
> +# CONFIG_MMC is not set
> +# CONFIG_MEMSTICK is not set
> +# CONFIG_NEW_LEDS is not set
> +# CONFIG_NFC_DEVICES is not set
> +# CONFIG_ACCESSIBILITY is not set
> +CONFIG_RTC_LIB=y
> +# CONFIG_RTC_CLASS is not set
> +# CONFIG_DMADEVICES is not set
> +# CONFIG_AUXDISPLAY is not set
> +# CONFIG_UIO is not set
> +# CONFIG_STAGING is not set
> +
> +#
> +# File systems
> +#
> +CONFIG_EXT2_FS=y
> +CONFIG_EXT2_FS_XATTR=y
> +CONFIG_EXT2_FS_POSIX_ACL=y
> +CONFIG_EXT2_FS_SECURITY=y
> +# CONFIG_EXT2_FS_XIP is not set
> +CONFIG_EXT3_FS=y
> +CONFIG_EXT3_DEFAULTS_TO_ORDERED=y
> +CONFIG_EXT3_FS_XATTR=y
> +CONFIG_EXT3_FS_POSIX_ACL=y
> +CONFIG_EXT3_FS_SECURITY=y
> +# CONFIG_EXT4_FS is not set
> +CONFIG_JBD=y
> +# CONFIG_JBD_DEBUG is not set
> +CONFIG_FS_MBCACHE=y
> +# CONFIG_REISERFS_FS is not set
> +# CONFIG_JFS_FS is not set
> +# CONFIG_XFS_FS is not set
> +# CONFIG_BTRFS_FS is not set
> +# CONFIG_NILFS2_FS is not set
> +CONFIG_FS_POSIX_ACL=y
> +CONFIG_FILE_LOCKING=y
> +CONFIG_FSNOTIFY=y
> +# CONFIG_DNOTIFY is not set
> +CONFIG_INOTIFY_USER=y
> +# CONFIG_FANOTIFY is not set
> +# CONFIG_QUOTA is not set
> +# CONFIG_QUOTACTL is not set
> +# CONFIG_AUTOFS4_FS is not set
> +# CONFIG_FUSE_FS is not set
> +CONFIG_GENERIC_ACL=y
> +
> +#
> +# Caches
> +#
> +# CONFIG_FSCACHE is not set
> +
> +#
> +# CD-ROM/DVD Filesystems
> +#
> +# CONFIG_ISO9660_FS is not set
> +# CONFIG_UDF_FS is not set
> +
> +#
> +# DOS/FAT/NT Filesystems
> +#
> +# CONFIG_MSDOS_FS is not set
> +# CONFIG_VFAT_FS is not set
> +# CONFIG_NTFS_FS is not set
> +
> +#
> +# Pseudo filesystems
> +#
> +CONFIG_PROC_FS=y
> +CONFIG_PROC_KCORE=y
> +CONFIG_PROC_SYSCTL=y
> +CONFIG_PROC_PAGE_MONITOR=y
> +CONFIG_SYSFS=y
> +CONFIG_TMPFS=y
> +CONFIG_TMPFS_POSIX_ACL=y
> +CONFIG_TMPFS_XATTR=y
> +# CONFIG_HUGETLB_PAGE is not set
> +# CONFIG_CONFIGFS_FS is not set
> +# CONFIG_MISC_FILESYSTEMS is not set
> +# CONFIG_NETWORK_FILESYSTEMS is not set
> +
> +#
> +# Partition Types
> +#
> +# CONFIG_PARTITION_ADVANCED is not set
> +CONFIG_MSDOS_PARTITION=y
> +# CONFIG_NLS is not set
> +
> +#
> +# Kernel hacking
> +#
> +CONFIG_TRACE_IRQFLAGS_SUPPORT=y
> +# CONFIG_PRINTK_TIME is not set
> +CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
> +# CONFIG_ENABLE_WARN_DEPRECATED is not set
> +# CONFIG_ENABLE_MUST_CHECK is not set
> +CONFIG_FRAME_WARN=1024
> +CONFIG_MAGIC_SYSRQ=y
> +# CONFIG_STRIP_ASM_SYMS is not set
> +CONFIG_UNUSED_SYMBOLS=y
> +CONFIG_DEBUG_FS=y
> +# CONFIG_HEADERS_CHECK is not set
> +# CONFIG_DEBUG_SECTION_MISMATCH is not set
> +CONFIG_DEBUG_KERNEL=y
> +# CONFIG_DEBUG_SHIRQ is not set
> +# CONFIG_LOCKUP_DETECTOR is not set
> +# CONFIG_HARDLOCKUP_DETECTOR is not set
> +CONFIG_DETECT_HUNG_TASK=y
> +CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
> +# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
> +CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
> +CONFIG_SCHED_DEBUG=y
> +CONFIG_SCHEDSTATS=y
> +CONFIG_TIMER_STATS=y
> +# CONFIG_DEBUG_OBJECTS is not set
> +# CONFIG_SLUB_DEBUG_ON is not set
> +# CONFIG_SLUB_STATS is not set
> +# CONFIG_DEBUG_KMEMLEAK is not set
> +# CONFIG_DEBUG_RT_MUTEXES is not set
> +# CONFIG_RT_MUTEX_TESTER is not set
> +# CONFIG_DEBUG_SPINLOCK is not set
> +# CONFIG_DEBUG_MUTEXES is not set
> +# CONFIG_DEBUG_LOCK_ALLOC is not set
> +# CONFIG_PROVE_LOCKING is not set
> +# CONFIG_SPARSE_RCU_POINTER is not set
> +# CONFIG_LOCK_STAT is not set
> +# CONFIG_DEBUG_SPINLOCK_SLEEP is not set
> +# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
> +# CONFIG_DEBUG_STACK_USAGE is not set
> +# CONFIG_DEBUG_KOBJECT is not set
> +CONFIG_DEBUG_INFO=y
> +# CONFIG_DEBUG_INFO_REDUCED is not set
> +# CONFIG_DEBUG_VM is not set
> +# CONFIG_DEBUG_WRITECOUNT is not set
> +CONFIG_DEBUG_MEMORY_INIT=y
> +# CONFIG_DEBUG_LIST is not set
> +# CONFIG_TEST_LIST_SORT is not set
> +# CONFIG_DEBUG_SG is not set
> +# CONFIG_DEBUG_NOTIFIERS is not set
> +# CONFIG_DEBUG_CREDENTIALS is not set
> +CONFIG_BOOT_PRINTK_DELAY=y
> +# CONFIG_RCU_TORTURE_TEST is not set
> +# CONFIG_BACKTRACE_SELF_TEST is not set
> +# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
> +# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
> +# CONFIG_LKDTM is not set
> +# CONFIG_FAULT_INJECTION is not set
> +CONFIG_SYSCTL_SYSCALL_CHECK=y
> +# CONFIG_DEBUG_PAGEALLOC is not set
> +CONFIG_HAVE_FUNCTION_TRACER=y
> +CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
> +CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
> +CONFIG_HAVE_DYNAMIC_FTRACE=y
> +CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
> +CONFIG_HAVE_C_RECORDMCOUNT=y
> +CONFIG_TRACING_SUPPORT=y
> +# CONFIG_FTRACE is not set
> +# CONFIG_DYNAMIC_DEBUG is not set
> +# CONFIG_DMA_API_DEBUG is not set
> +# CONFIG_ATOMIC64_SELFTEST is not set
> +# CONFIG_SAMPLES is not set
> +CONFIG_HAVE_ARCH_KGDB=y
> +CONFIG_KGDB=y
> +CONFIG_KGDB_SERIAL_CONSOLE=y
> +# CONFIG_KGDB_TESTS is not set
> +CONFIG_KGDB_LOW_LEVEL_TRAP=y
> +CONFIG_KGDB_KDB=y
> +CONFIG_KDB_KEYBOARD=y
> +# CONFIG_TEST_KSTRTOX is not set
> +# CONFIG_EARLY_PRINTK is not set
> +# CONFIG_CMDLINE_BOOL is not set
> +# CONFIG_DEBUG_STACKOVERFLOW is not set
> +# CONFIG_RUNTIME_DEBUG is not set
> +# CONFIG_DEBUG_ZBOOT is not set
> +# CONFIG_SPINLOCK_TEST is not set
> +
> +#
> +# Security options
> +#
> +CONFIG_KEYS=y
> +# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
> +# CONFIG_SECURITY_DMESG_RESTRICT is not set
> +# CONFIG_SECURITY is not set
> +# CONFIG_SECURITYFS is not set
> +CONFIG_DEFAULT_SECURITY_DAC=y
> +CONFIG_DEFAULT_SECURITY=""
> +# CONFIG_CRYPTO is not set
> +# CONFIG_VIRTUALIZATION is not set
> +# CONFIG_BINARY_PRINTF is not set
> +
> +#
> +# Library routines
> +#
> +CONFIG_BITREVERSE=y
> +# CONFIG_CRC_CCITT is not set
> +# CONFIG_CRC16 is not set
> +# CONFIG_CRC_T10DIF is not set
> +# CONFIG_CRC_ITU_T is not set
> +CONFIG_CRC32=y
> +# CONFIG_CRC7 is not set
> +# CONFIG_LIBCRC32C is not set
> +CONFIG_ZLIB_INFLATE=y
> +CONFIG_LZO_DECOMPRESS=y
> +CONFIG_XZ_DEC=y
> +CONFIG_XZ_DEC_X86=y
> +CONFIG_XZ_DEC_POWERPC=y
> +CONFIG_XZ_DEC_IA64=y
> +CONFIG_XZ_DEC_ARM=y
> +CONFIG_XZ_DEC_ARMTHUMB=y
> +CONFIG_XZ_DEC_SPARC=y
> +CONFIG_XZ_DEC_BCJ=y
> +# CONFIG_XZ_DEC_TEST is not set
> +CONFIG_DECOMPRESS_GZIP=y
> +CONFIG_DECOMPRESS_BZIP2=y
> +CONFIG_DECOMPRESS_LZMA=y
> +CONFIG_DECOMPRESS_XZ=y
> +CONFIG_DECOMPRESS_LZO=y
> +CONFIG_HAS_IOMEM=y
> +CONFIG_HAS_IOPORT=y
> +CONFIG_HAS_DMA=y
> +CONFIG_NLATTR=y
> +CONFIG_GENERIC_ATOMIC64=y
> +# CONFIG_AVERAGE is not set

We should use the 'minimal' defconfig now, please get it with the
following command:

$ make savedefconfig

> diff --git a/arch/mips/include/asm/cpu.h b/arch/mips/include/asm/cpu.h
> index 5f95a4b..975f372 100644
> --- a/arch/mips/include/asm/cpu.h
> +++ b/arch/mips/include/asm/cpu.h
> @@ -191,6 +191,7 @@
>  #define PRID_REV_34K_V1_0_2    0x0022
>  #define PRID_REV_LOONGSON2E    0x0002
>  #define PRID_REV_LOONGSON2F    0x0003
> +#define PRID_REV_LOONGSON1B    0x0020
>
>  /*
>  * Older processors used to encode processor version and revision in two
> @@ -253,7 +254,7 @@ enum cpu_type_enum {
>         */
>        CPU_4KC, CPU_4KEC, CPU_4KSC, CPU_24K, CPU_34K, CPU_1004K, CPU_74K,
>        CPU_ALCHEMY, CPU_PR4450, CPU_BMIPS32, CPU_BMIPS3300, CPU_BMIPS4350,
> -       CPU_BMIPS4380, CPU_BMIPS5000, CPU_JZRISC,
> +       CPU_BMIPS4380, CPU_BMIPS5000, CPU_JZRISC, CPU_LOONGSON1,
>
>        /*
>         * MIPS64 class processors
> diff --git a/arch/mips/include/asm/mach-loongson1/irq.h b/arch/mips/include/asm/mach-loongson1/irq.h
> new file mode 100644
> index 0000000..3f1053e
> --- /dev/null
> +++ b/arch/mips/include/asm/mach-loongson1/irq.h
> @@ -0,0 +1,70 @@
> +/*
> + * Copyright (c) 2011 Zhang, Keguang <keguang.zhang@gmail.com>
> + *
> + * IRQ mappings for Loongson1.
> + *
> + * This program is free software; you can redistribute  it and/or modify it
> + * under  the terms of  the GNU General  Public License as published by the
> + * Free Software Foundation;  either version 2 of the  License, or (at your
> + * option) any later version.
> + */
> +
> +
> +#ifndef __ASM_MACH_LOONGSON1_IRQ_H
> +#define __ASM_MACH_LOONGSON1_IRQ_H
> +
> +/*
> + * CPU core Interrupt Numbers
> + */
> +#define MIPS_CPU_IRQ_BASE              0
> +#define MIPS_CPU_IRQ(x)                        (MIPS_CPU_IRQ_BASE + (x))
> +#define SOFTINT0_IRQ                   MIPS_CPU_IRQ(0)
> +#define SOFTINT1_IRQ                   MIPS_CPU_IRQ(1)
> +#define INT0_IRQ                       MIPS_CPU_IRQ(2)
> +#define INT1_IRQ                       MIPS_CPU_IRQ(3)
> +#define INT2_IRQ                       MIPS_CPU_IRQ(4)
> +#define INT3_IRQ                       MIPS_CPU_IRQ(5)
> +#define INT4_IRQ                       MIPS_CPU_IRQ(6)
> +#define TIMER_IRQ                      MIPS_CPU_IRQ(7)         /* cpu timer */
> +
> +/*
> + * INT0~3 Interrupt Numbers
> + */
> +#define LOONGSON1_IRQ_BASE             8
> +#define LOONGSON1_IRQ(n,x)             (LOONGSON1_IRQ_BASE + (n << 5) + (x))
> +
> +#define LOONGSON1_UART0_IRQ            LOONGSON1_IRQ(0,2)
> +#define LOONGSON1_UART1_IRQ            LOONGSON1_IRQ(0,3)
> +#define LOONGSON1_UART2_IRQ            LOONGSON1_IRQ(0,4)
> +#define LOONGSON1_UART3_IRQ            LOONGSON1_IRQ(0,5)
> +#define LOONGSON1_CAN0_IRQ             LOONGSON1_IRQ(0,6)
> +#define LOONGSON1_CAN1_IRQ             LOONGSON1_IRQ(0,7)
> +#define LOONGSON1_SPI0_IRQ             LOONGSON1_IRQ(0,8)
> +#define LOONGSON1_SPI1_IRQ             LOONGSON1_IRQ(0,9)
> +#define LOONGSON1_AC97_IRQ             LOONGSON1_IRQ(0,10)
> +#define LOONGSON1_DMA0_IRQ             LOONGSON1_IRQ(0,13)
> +#define LOONGSON1_DMA1_IRQ             LOONGSON1_IRQ(0,14)
> +#define LOONGSON1_DMA2_IRQ             LOONGSON1_IRQ(0,15)
> +#define LOONGSON1_PWM0_IRQ             LOONGSON1_IRQ(0,17)
> +#define LOONGSON1_PWM1_IRQ             LOONGSON1_IRQ(0,18)
> +#define LOONGSON1_PWM2_IRQ             LOONGSON1_IRQ(0,19)
> +#define LOONGSON1_PWM3_IRQ             LOONGSON1_IRQ(0,20)
> +#define LOONGSON1_RTC_INT0_IRQ         LOONGSON1_IRQ(0,21)
> +#define LOONGSON1_RTC_INT1_IRQ         LOONGSON1_IRQ(0,22)
> +#define LOONGSON1_RTC_INT2_IRQ         LOONGSON1_IRQ(0,23)
> +#define LOONGSON1_TOY_INT0_IRQ         LOONGSON1_IRQ(0,24)
> +#define LOONGSON1_TOY_INT1_IRQ         LOONGSON1_IRQ(0,25)
> +#define LOONGSON1_TOY_INT2_IRQ         LOONGSON1_IRQ(0,26)
> +#define LOONGSON1_RTC_TICK_IRQ         LOONGSON1_IRQ(0,27)
> +#define LOONGSON1_TOY_TICK_IRQ         LOONGSON1_IRQ(0,28)
> +#define LOONGSON1_UART4_IRQ            LOONGSON1_IRQ(0,29)
> +#define LOONGSON1_UART5_IRQ            LOONGSON1_IRQ(0,30)
> +
> +#define LOONGSON1_OHCI_IRQ             LOONGSON1_IRQ(1,0)
> +#define LOONGSON1_EHCI_IRQ             LOONGSON1_IRQ(1,1)
> +#define LOONGSON1_GMAC0_IRQ            LOONGSON1_IRQ(1,2)
> +#define LOONGSON1_GMAC1_IRQ            LOONGSON1_IRQ(1,3)
> +
> +#define NR_IRQS                                LOONGSON1_GMAC1_IRQ
> +
> +#endif /* __ASM_MACH_LOONGSON1_IRQ_H */
> diff --git a/arch/mips/include/asm/mach-loongson1/loongson1.h b/arch/mips/include/asm/mach-loongson1/loongson1.h
> new file mode 100644
> index 0000000..466136d
> --- /dev/null
> +++ b/arch/mips/include/asm/mach-loongson1/loongson1.h
> @@ -0,0 +1,48 @@
> +/*
> + * Copyright (c) 2011 Zhang, Keguang <keguang.zhang@gmail.com>
> + *
> + * Register mappings for Loongson1.
> + *
> + * This program is free software; you can redistribute  it and/or modify it
> + * under  the terms of  the GNU General  Public License as published by the
> + * Free Software Foundation;  either version 2 of the  License, or (at your
> + * option) any later version.
> + */
> +
> +
> +#ifndef __ASM_MACH_LOONGSON1_LOONGSON1_H
> +#define __ASM_MACH_LOONGSON1_LOONGSON1_H
> +
> +#define DEFAULT_MEMSIZE                        (256)   /* If no memsize provided */
> +
> +/* Loongson1 Register Bases */
> +/* All regs are accessed in KSEG1 */
> +#define LOONGSON1_REGBASE              (0xa0000000ul + 0x1fe00000ul)
> +
> +#define LOONGSON1_INTC_BASE            (0xbfd01040)
> +#define LOONGSON1_USB_BASE             (0xbfe00000)
> +#define LOONGSON1_GMAC0_BASE           (0xbfe10000)
> +#define LOONGSON1_GMAC1_BASE           (0xbfe20000)
> +#define LOONGSON1_UART0_BASE           (0xbfe40000)
> +#define LOONGSON1_UART1_BASE           (0xbfe44000)
> +#define LOONGSON1_UART2_BASE           (0xbfe48000)
> +#define LOONGSON1_UART3_BASE           (0xbfe4c000)
> +#define LOONGSON1_UART4_BASE           (0xbfe6c000)
> +#define LOONGSON1_UART5_BASE           (0xbfe7c000)
> +#define LOONGSON1_CAN0_BASE            (0xbfe50000)
> +#define LOONGSON1_CAN1_BASE            (0xbfe54000)
> +#define LOONGSON1_I2C0_BASE            (0xbfe58000)
> +#define LOONGSON1_I2C1_BASE            (0xbfe68000)
> +#define LOONGSON1_I2C2_BASE            (0xbfe70000)
> +#define LOONGSON1_PWM_BASE             (0xbfe5c000)
> +#define LOONGSON1_WDT_BASE             (0xbfe5c060)
> +#define LOONGSON1_RTC_BASE             (0xbfe64000)
> +#define LOONGSON1_AC97_BASE            (0xbfe74000)
> +#define LOONGSON1_NAND_BASE            (0xbfe78000)
> +#define LOONGSON1_CLK_BASE             (0xbfe78030)
> +
> +#include <regs-clk.h>
> +#include <regs-intc.h>
> +#include <regs-wdt.h>
> +
> +#endif /* __ASM_MACH_LOONGSON1_LOONGSON1_H */
> diff --git a/arch/mips/include/asm/mach-loongson1/platform.h b/arch/mips/include/asm/mach-loongson1/platform.h
> new file mode 100644
> index 0000000..db4f02e
> --- /dev/null
> +++ b/arch/mips/include/asm/mach-loongson1/platform.h
> @@ -0,0 +1,20 @@
> +/*
> + * Copyright (c) 2011 Zhang, Keguang <keguang.zhang@gmail.com>
> + *
> + * This program is free software; you can redistribute  it and/or modify it
> + * under  the terms of  the GNU General  Public License as published by the
> + * Free Software Foundation;  either version 2 of the  License, or (at your
> + * option) any later version.
> + */
> +
> +
> +#ifndef __ASM_MACH_LOONGSON1_PLATFORM_H
> +#define __ASM_MACH_LOONGSON1_PLATFORM_H
> +
> +#include <linux/platform_device.h>
> +
> +extern struct platform_device loongson1_uart_device;
> +
> +void loongson1_serial_setup(void);
> +
> +#endif /* __ASM_MACH_LOONGSON1_PLATFORM_H */
> diff --git a/arch/mips/include/asm/mach-loongson1/prom.h b/arch/mips/include/asm/mach-loongson1/prom.h
> new file mode 100644
> index 0000000..b871dc4
> --- /dev/null
> +++ b/arch/mips/include/asm/mach-loongson1/prom.h
> @@ -0,0 +1,24 @@
> +/*
> + * Copyright (c) 2011 Zhang, Keguang <keguang.zhang@gmail.com>
> + *
> + * This program is free software; you can redistribute  it and/or modify it
> + * under  the terms of  the GNU General  Public License as published by the
> + * Free Software Foundation;  either version 2 of the  License, or (at your
> + * option) any later version.
> + */
> +
> +#ifndef __ASM_MACH_LOONGSON1_PROM_H
> +#define __ASM_MACH_LOONGSON1_PROM_H
> +
> +#include <linux/io.h>
> +#include <linux/init.h>
> +#include <linux/irq.h>
> +
> +/* environment arguments from bootloader */
> +extern unsigned long memsize, highmemsize;
> +
> +/* loongson-specific command line, env and memory initialization */
> +extern char *prom_getenv(char *name);
> +extern void __init prom_init_cmdline(void);
> +
> +#endif /* __ASM_MACH_LOONGSON1_PROM_H */
> diff --git a/arch/mips/include/asm/mach-loongson1/regs-clk.h b/arch/mips/include/asm/mach-loongson1/regs-clk.h
> new file mode 100644
> index 0000000..8a14d97
> --- /dev/null
> +++ b/arch/mips/include/asm/mach-loongson1/regs-clk.h
> @@ -0,0 +1,32 @@
> +/*
> + * Copyright (c) 2011 Zhang, Keguang <keguang.zhang@gmail.com>
> + *
> + * Loongson1 Clock Register Definitions.
> + *
> + * This program is free software; you can redistribute  it and/or modify it
> + * under  the terms of  the GNU General  Public License as published by the
> + * Free Software Foundation;  either version 2 of the  License, or (at your
> + * option) any later version.
> + */
> +
> +#ifndef __ASM_MACH_LOONGSON1_REGS_CLK_H
> +#define __ASM_MACH_LOONGSON1_REGS_CLK_H
> +
> +#define LOONGSON1_CLK_REG(x)           ((void __iomem *)(LOONGSON1_CLK_BASE + (x)))
> +
> +#define        LS1_CLK_PLL_FREQ                LOONGSON1_CLK_REG(0x0)
> +#define        LS1_CLK_PLL_DIV                 LOONGSON1_CLK_REG(0x4)
> +
> +/* Clock PLL Divisor Register Bits */
> +#define        DIV_DC_EN                       (0x1 << 31)
> +#define DIV_DC                         (0x1f << 26)
> +#define        DIV_CPU_EN                      (0x1 << 25)
> +#define DIV_CPU                                (0x1f << 20)
> +#define        DIV_DDR_EN                      (0x1 << 19)
> +#define DIV_DDR                                (0x1f << 14)
> +
> +#define        DIV_DC_SHIFT                    (26)
> +#define        DIV_CPU_SHIFT                   (20)
> +#define        DIV_DDR_SHIFT                   (14)
> +
> +#endif /* __ASM_MACH_LOONGSON1_REGS_CLK_H */
> diff --git a/arch/mips/include/asm/mach-loongson1/regs-intc.h b/arch/mips/include/asm/mach-loongson1/regs-intc.h
> new file mode 100644
> index 0000000..69d1b4a
> --- /dev/null
> +++ b/arch/mips/include/asm/mach-loongson1/regs-intc.h
> @@ -0,0 +1,24 @@
> +/*
> + * Copyright (c) 2011 Zhang, Keguang <keguang.zhang@gmail.com>
> + *
> + * Loongson1 Interrupt register definitions.
> + *
> + * This program is free software; you can redistribute  it and/or modify it
> + * under  the terms of  the GNU General  Public License as published by the
> + * Free Software Foundation;  either version 2 of the  License, or (at your
> + * option) any later version.
> + */
> +
> +#ifndef __ASM_MACH_LOONGSON1_REGS_INTC_H
> +#define __ASM_MACH_LOONGSON1_REGS_INTC_H
> +
> +#define LOONGSON1_INTC_REG(x)          ((void __iomem *)(LOONGSON1_INTC_BASE + n * 0x18 + x))
> +
> +#define        LS1_INTC_INTISR(n)              LOONGSON1_INTC_REG(0x0)
> +#define        LS1_INTC_INTIEN(n)              LOONGSON1_INTC_REG(0x4)
> +#define        LS1_INTC_INTSET(n)              LOONGSON1_INTC_REG(0x8)
> +#define        LS1_INTC_INTCLR(n)              LOONGSON1_INTC_REG(0xc)
> +#define        LS1_INTC_INTPOL(n)              LOONGSON1_INTC_REG(0x10)
> +#define        LS1_INTC_INTEDGE(n)             LOONGSON1_INTC_REG(0x14)
> +
> +#endif /* __ASM_MACH_LOONGSON1_REGS_INTC_H */
> diff --git a/arch/mips/include/asm/mach-loongson1/regs-wdt.h b/arch/mips/include/asm/mach-loongson1/regs-wdt.h
> new file mode 100644
> index 0000000..3e5a51a
> --- /dev/null
> +++ b/arch/mips/include/asm/mach-loongson1/regs-wdt.h
> @@ -0,0 +1,21 @@
> +/*
> + * Copyright (c) 2011 Zhang, Keguang <keguang.zhang@gmail.com>
> + *
> + * Loongson1 Watchdog register definitions.
> + *
> + * This program is free software; you can redistribute  it and/or modify it
> + * under  the terms of  the GNU General  Public License as published by the
> + * Free Software Foundation;  either version 2 of the  License, or (at your
> + * option) any later version.
> + */
> +
> +#ifndef __ASM_MACH_LOONGSON1_REGS_WDT_H
> +#define __ASM_MACH_LOONGSON1_REGS_WDT_H
> +
> +#define LOONGSON1_WDT_REG(x)           ((void __iomem *)(LOONGSON1_WDT_BASE + (x)))
> +
> +#define        LS1_WDT_EN                      LOONGSON1_WDT_REG(0x0)
> +#define        LS1_WDT_SET                     LOONGSON1_WDT_REG(0x4)
> +#define        LS1_WDT_TIMER                   LOONGSON1_WDT_REG(0x8)
> +
> +#endif /* __ASM_MACH_LOONGSON1_REGS_WDT_H */
> diff --git a/arch/mips/include/asm/mach-loongson1/war.h b/arch/mips/include/asm/mach-loongson1/war.h
> new file mode 100644
> index 0000000..e3680a8
> --- /dev/null
> +++ b/arch/mips/include/asm/mach-loongson1/war.h
> @@ -0,0 +1,25 @@
> +/*
> + * This file is subject to the terms and conditions of the GNU General Public
> + * License.  See the file "COPYING" in the main directory of this archive
> + * for more details.
> + *
> + * Copyright (C) 2002, 2004, 2007 by Ralf Baechle <ralf@linux-mips.org>
> + */
> +#ifndef __ASM_MACH_LOONGSON1_WAR_H
> +#define __ASM_MACH_LOONGSON1_WAR_H
> +
> +#define R4600_V1_INDEX_ICACHEOP_WAR    0
> +#define R4600_V1_HIT_CACHEOP_WAR       0
> +#define R4600_V2_HIT_CACHEOP_WAR       0
> +#define R5432_CP0_INTERRUPT_WAR                0
> +#define BCM1250_M3_WAR                 0
> +#define SIBYTE_1956_WAR                        0
> +#define MIPS4K_ICACHE_REFILL_WAR       0
> +#define MIPS_CACHE_SYNC_WAR            0
> +#define TX49XX_ICACHE_INDEX_INV_WAR    0
> +#define RM9000_CDEX_SMP_WAR            0
> +#define ICACHE_REFILLS_WORKAROUND_WAR  0
> +#define R10000_LLSC_WAR                        0
> +#define MIPS34K_MISSED_ITLB_WAR                0
> +
> +#endif /* __ASM_MACH_LOONGSON1_WAR_H */

What about add a new cpu-feature-overrides.h for Loongson1, it may
help a little to the kernel image size and boot speed.

Please see arch/mips/include/asm/mach-loongson/cpu-feature-overrides.h
and show_cpuinfo() function defined in arch/mips/kernel/proc.c

> diff --git a/arch/mips/include/asm/module.h b/arch/mips/include/asm/module.h
> index bc01a02..b53d642 100644
> --- a/arch/mips/include/asm/module.h
> +++ b/arch/mips/include/asm/module.h
> @@ -116,6 +116,8 @@ search_module_dbetables(unsigned long addr)
>  #define MODULE_PROC_FAMILY "SB1 "
>  #elif defined CONFIG_CPU_LOONGSON2
>  #define MODULE_PROC_FAMILY "LOONGSON2 "
> +#elif defined CONFIG_CPU_LOONGSON1
> +#define MODULE_PROC_FAMILY "LOONGSON1 "
>  #elif defined CONFIG_CPU_CAVIUM_OCTEON
>  #define MODULE_PROC_FAMILY "OCTEON "
>  #elif defined CONFIG_CPU_XLR
> diff --git a/arch/mips/kernel/cpu-probe.c b/arch/mips/kernel/cpu-probe.c
> index ebc0cd2..c886e0d 100644
> --- a/arch/mips/kernel/cpu-probe.c
> +++ b/arch/mips/kernel/cpu-probe.c
> @@ -37,6 +37,8 @@
>  void (*cpu_wait)(void);
>  EXPORT_SYMBOL(cpu_wait);
>
> +static void __cpuinit decode_configs(struct cpuinfo_mips *c);
> +
>  static void r3081_wait(void)
>  {
>        unsigned long cfg = read_c0_conf();
> @@ -190,6 +192,7 @@ void __init check_wait(void)
>        case CPU_CAVIUM_OCTEON_PLUS:
>        case CPU_CAVIUM_OCTEON2:
>        case CPU_JZRISC:
> +       case CPU_LOONGSON1:
>                cpu_wait = r4k_wait;
>                break;
>
> @@ -635,6 +638,18 @@ static inline void cpu_probe_legacy(struct cpuinfo_mips *c, unsigned int cpu)
>                             MIPS_CPU_32FPR;
>                c->tlbsize = 64;
>                break;
> +       case PRID_IMP_LOONGSON1:
> +               decode_configs(c);
> +
> +               c->cputype = CPU_LOONGSON1;
> +
> +               switch (c->processor_id & PRID_REV_MASK) {
> +               case PRID_REV_LOONGSON1B:
> +                       __cpu_name[cpu] = "Loongson 1B";
> +                       break;
> +               }
> +
> +               break;
>        }
>  }
>
> diff --git a/arch/mips/kernel/perf_event_mipsxx.c b/arch/mips/kernel/perf_event_mipsxx.c
> index e5ad09a..e316b0e 100644
> --- a/arch/mips/kernel/perf_event_mipsxx.c
> +++ b/arch/mips/kernel/perf_event_mipsxx.c
> @@ -1062,6 +1062,12 @@ init_hw_perf_events(void)
>                mipsxxcore_pmu.irq = irq;
>                mipspmu = &mipsxxcore_pmu;
>                break;
> +       case CPU_LOONGSON1:
> +               mipsxxcore_pmu.name = "mips/loongson1";
> +               mipsxxcore_pmu.num_counters = counters;
> +               mipsxxcore_pmu.irq = irq;
> +               mipspmu = &mipsxxcore_pmu;
> +               break;
>        default:
>                pr_cont("Either hardware does not support performance "
>                        "counters, or not yet implemented.\n");
> diff --git a/arch/mips/kernel/traps.c b/arch/mips/kernel/traps.c
> index 01eff7e..cd55823 100644
> --- a/arch/mips/kernel/traps.c
> +++ b/arch/mips/kernel/traps.c
> @@ -1241,6 +1241,7 @@ static inline void parity_protection_init(void)
>                break;
>
>        case CPU_5KC:
> +       case CPU_LOONGSON1:
>                write_c0_ecc(0x80000000);
>                back_to_back_c0_hazard();
>                /* Set the PE bit (bit 31) in the c0_errctl register. */
> diff --git a/arch/mips/loongson1/Kconfig b/arch/mips/loongson1/Kconfig
> new file mode 100644
> index 0000000..c22ceac
> --- /dev/null
> +++ b/arch/mips/loongson1/Kconfig
> @@ -0,0 +1,29 @@
> +if MACH_LOONGSON1
> +
> +choice
> +       prompt "Machine Type"
> +
> +config LOONGSON1_LS1B
> +       bool "Loongson LS1B board"
> +       select ARCH_SPARSEMEM_ENABLE
> +       select CEVT_R4K
> +       select CSRC_R4K
> +       select SYS_HAS_CPU_LOONGSON1B
> +       select DMA_NONCOHERENT
> +       select BOOT_ELF32
> +       select IRQ_CPU
> +       select SYS_SUPPORTS_32BIT_KERNEL
> +       select SYS_SUPPORTS_LITTLE_ENDIAN
> +       select SYS_SUPPORTS_HIGHMEM
> +       select SYS_HAS_EARLY_PRINTK
> +#      select USB_ARCH_HAS_OHCI
> +#      select USB_ARCH_HAS_EHCI
> +
> +endchoice
> +
> +#config LOONGSON_SUSPEND
> +#      bool
> +#      default y
> +#      depends on CPU_SUPPORTS_CPUFREQ && SUSPEND
> +

Do we need the above lines commented with #?

> +endif # MACH_LOONGSON1
> diff --git a/arch/mips/loongson1/Makefile b/arch/mips/loongson1/Makefile
> new file mode 100644
> index 0000000..e9123c2
> --- /dev/null
> +++ b/arch/mips/loongson1/Makefile
> @@ -0,0 +1,11 @@
> +#
> +# Common code for all Loongson1 based systems
> +#
> +
> +obj-$(CONFIG_MACH_LOONGSON1) += common/
> +
> +#
> +# Loongson LS1B board
> +#
> +
> +obj-$(CONFIG_LOONGSON1_LS1B)  += ls1b/
> diff --git a/arch/mips/loongson1/Platform b/arch/mips/loongson1/Platform
> new file mode 100644
> index 0000000..92804c6
> --- /dev/null
> +++ b/arch/mips/loongson1/Platform
> @@ -0,0 +1,7 @@
> +cflags-$(CONFIG_CPU_LOONGSON1)  += \
> +       $(call cc-option,-march=mips32r2,-mips32r2 -U_MIPS_ISA -D_MIPS_ISA=_MIPS_ISA_MIPS32) \
> +       -Wa,-mips32r2 -Wa,--trap
> +
> +platform-$(CONFIG_MACH_LOONGSON1)      += loongson1/
> +cflags-$(CONFIG_MACH_LOONGSON1)                += -I$(srctree)/arch/mips/include/asm/mach-loongson1
> +load-$(CONFIG_LOONGSON1_LS1B)          += 0xffffffff80010000
> diff --git a/arch/mips/loongson1/common/Makefile b/arch/mips/loongson1/common/Makefile
> new file mode 100644
> index 0000000..b279770
> --- /dev/null
> +++ b/arch/mips/loongson1/common/Makefile
> @@ -0,0 +1,5 @@
> +#
> +# Makefile for common code of loongson1 based machines.
> +#
> +
> +obj-y  += clock.o irq.o platform.o prom.o reset.o setup.o
> diff --git a/arch/mips/loongson1/common/clock.c b/arch/mips/loongson1/common/clock.c
> new file mode 100644
> index 0000000..cd8d151
> --- /dev/null
> +++ b/arch/mips/loongson1/common/clock.c
> @@ -0,0 +1,165 @@
> +/*
> + * Copyright (c) 2011 Zhang, Keguang <keguang.zhang@gmail.com>
> + *
> + * This program is free software; you can redistribute  it and/or modify it
> + * under  the terms of  the GNU General  Public License as published by the
> + * Free Software Foundation;  either version 2 of the  License, or (at your
> + * option) any later version.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/list.h>
> +#include <linux/mutex.h>
> +#include <linux/clk.h>
> +#include <linux/err.h>
> +#include <asm/clock.h>
> +#include <asm/time.h>
> +
> +#include <loongson1.h>
> +
> +static LIST_HEAD(clocks);
> +static DEFINE_MUTEX(clocks_mutex);
> +
> +struct clk *clk_get(struct device *dev, const char *name)
> +{
> +       struct clk *c;
> +       struct clk *ret = NULL;
> +
> +       mutex_lock(&clocks_mutex);
> +       list_for_each_entry(c, &clocks, node) {
> +               if (!strcmp(c->name, name)) {
> +                       ret = c;
> +                       break;
> +               }
> +       }
> +       mutex_unlock(&clocks_mutex);
> +
> +       return ret;
> +}
> +EXPORT_SYMBOL(clk_get);
> +
> +unsigned long clk_get_rate(struct clk *clk)
> +{
> +       return clk->rate;
> +}
> +EXPORT_SYMBOL(clk_get_rate);
> +
> +static void pll_clk_init(struct clk *clk)
> +{
> +       u32 pll;
> +
> +       pll = __raw_readl(LS1_CLK_PLL_FREQ);
> +        clk->rate = (12 + (pll & 0x3f)) * 33 / 2
> +                       + ((pll >>8 ) & 0x3ff) * 33 / 1024 / 2;
> +        clk->rate *= 1000000;
> +}
> +
> +static void cpu_clk_init(struct clk *clk)
> +{
> +       u32 pll, ctrl;
> +
> +       pll = clk_get_rate(clk->parent);
> +       ctrl = __raw_readl(LS1_CLK_PLL_DIV) & DIV_CPU;
> +       clk->rate = pll / (ctrl >> DIV_CPU_SHIFT);
> +}
> +
> +static void ddr_clk_init(struct clk *clk)
> +{
> +       u32 pll, ctrl;
> +
> +       pll = clk_get_rate(clk->parent);
> +       ctrl = __raw_readl(LS1_CLK_PLL_DIV) & DIV_DDR;
> +       clk->rate = pll / (ctrl >> DIV_DDR_SHIFT);
> +}
> +
> +static void dc_clk_init(struct clk *clk)
> +{
> +       u32 pll, ctrl;
> +
> +       pll = clk_get_rate(clk->parent);
> +       ctrl = __raw_readl(LS1_CLK_PLL_DIV) & DIV_DC;
> +       clk->rate = pll / (ctrl >> DIV_DC_SHIFT);
> +}
> +
> +static struct clk_ops pll_clk_ops = {
> +       .init   = pll_clk_init,
> +};
> +
> +static struct clk_ops cpu_clk_ops = {
> +       .init   = cpu_clk_init,
> +};
> +
> +static struct clk_ops ddr_clk_ops = {
> +       .init   = ddr_clk_init,
> +};
> +
> +static struct clk_ops dc_clk_ops = {
> +       .init   = dc_clk_init,
> +};
> +
> +static struct clk pll_clk = {
> +       .name   = "pll",
> +       .ops    = &pll_clk_ops,
> +};
> +
> +static struct clk cpu_clk = {
> +       .name   = "cpu",
> +       .parent = &pll_clk,
> +       .ops    = &cpu_clk_ops,
> +};
> +
> +static struct clk ddr_clk = {
> +       .name   = "ddr",
> +       .parent = &pll_clk,
> +       .ops    = &ddr_clk_ops,
> +};
> +
> +static struct clk dc_clk = {
> +       .name   = "dc",
> +       .parent = &pll_clk,
> +       .ops    = &dc_clk_ops,
> +};
> +
> +int clk_register(struct clk *clk)
> +{
> +       mutex_lock(&clocks_mutex);
> +       list_add(&clk->node, &clocks);
> +       if (clk->ops->init)
> +               clk->ops->init(clk);
> +       mutex_unlock(&clocks_mutex);
> +
> +       return 0;
> +}
> +EXPORT_SYMBOL(clk_register);
> +
> +static struct clk *loongson1_clks[] = {
> +       &pll_clk,
> +       &cpu_clk,
> +       &ddr_clk,
> +       &dc_clk,
> +};
> +
> +int __init loongson1_clock_init(void)
> +{
> +       int i;
> +
> +       for (i = 0; i < ARRAY_SIZE(loongson1_clks); i++)
> +               clk_register(loongson1_clks[i]);
> +
> +       return 0;
> +}
> +
> +void __init plat_time_init(void)
> +{
> +       struct clk *clk;
> +
> +       /* Initialize loongson1 clocks */
> +       loongson1_clock_init();
> +
> +        /* setup mips r4k timer */
> +       clk = clk_get(NULL, "cpu");
> +       if (IS_ERR(clk))
> +               panic("unable to get dc clock, err=%ld", PTR_ERR(clk));
> +
> +       mips_hpt_frequency = clk_get_rate(clk) / 2;
> +}
> diff --git a/arch/mips/loongson1/common/irq.c b/arch/mips/loongson1/common/irq.c
> new file mode 100644
> index 0000000..688d7b9
> --- /dev/null
> +++ b/arch/mips/loongson1/common/irq.c
> @@ -0,0 +1,135 @@
> +/*
> + * Copyright (c) 2011 Zhang, Keguang <keguang.zhang@gmail.com>
> + *
> + * This program is free software; you can redistribute  it and/or modify it
> + * under  the terms of  the GNU General  Public License as published by the
> + * Free Software Foundation;  either version 2 of the  License, or (at your
> + * option) any later version.
> + */
> +
> +#include <linux/interrupt.h>
> +#include <linux/irq.h>
> +#include <asm/irq_cpu.h>
> +
> +#include <loongson1.h>
> +#include <irq.h>
> +
> +static void loongson1_irq_ack(struct irq_data *d)
> +{
> +       unsigned int bit = (d->irq - LOONGSON1_IRQ_BASE) & 0x1f;
> +       unsigned int n = (d->irq - LOONGSON1_IRQ_BASE) >> 5;
> +
> +       __raw_writel(__raw_readl(LS1_INTC_INTCLR(n))
> +                       | (1 << bit), LS1_INTC_INTCLR(n));
> +}
> +
> +static void loongson1_irq_mask(struct irq_data *d)
> +{
> +       unsigned int bit = (d->irq - LOONGSON1_IRQ_BASE) & 0x1f;
> +       unsigned int n = (d->irq - LOONGSON1_IRQ_BASE) >> 5;
> +
> +       __raw_writel(__raw_readl(LS1_INTC_INTIEN(n))
> +                       & ~(1 << bit), LS1_INTC_INTIEN(n));
> +}
> +
> +static void loongson1_irq_mask_ack(struct irq_data *d)
> +{
> +       unsigned int bit = (d->irq - LOONGSON1_IRQ_BASE) & 0x1f;
> +       unsigned int n = (d->irq - LOONGSON1_IRQ_BASE) >> 5;
> +
> +       __raw_writel(__raw_readl(LS1_INTC_INTIEN(n))
> +                       & ~(1 << bit), LS1_INTC_INTIEN(n));
> +       __raw_writel(__raw_readl(LS1_INTC_INTCLR(n))
> +                       | (1 << bit), LS1_INTC_INTCLR(n));
> +}
> +
> +static void loongson1_irq_unmask(struct irq_data *d)
> +{
> +       unsigned int bit = (d->irq - LOONGSON1_IRQ_BASE) & 0x1f;
> +       unsigned int n = (d->irq - LOONGSON1_IRQ_BASE) >> 5;
> +
> +       __raw_writel(__raw_readl(LS1_INTC_INTIEN(n))
> +                       | (1 << bit), LS1_INTC_INTIEN(n));
> +}
> +
> +static struct irq_chip loongson1_irq_chip = {
> +       .name           = "LOONGSON1-INTC",
> +       .irq_ack        = loongson1_irq_ack,
> +       .irq_mask       = loongson1_irq_mask,
> +       .irq_mask_ack   = loongson1_irq_mask_ack,
> +       .irq_unmask     = loongson1_irq_unmask,
> +};
> +
> +static void loongson1_irq_dispatch(int n)
> +{
> +       u32 int_status, irq;
> +
> +       /* Get pending sources, masked by current enables */
> +       int_status = __raw_readl(LS1_INTC_INTISR(n)) &
> +                       __raw_readl(LS1_INTC_INTIEN(n));
> +
> +       if (int_status) {
> +               irq = LOONGSON1_IRQ(n, __ffs(int_status));
> +               do_IRQ(irq);
> +       }
> +}
> +
> +asmlinkage void plat_irq_dispatch(void)
> +{
> +       unsigned int pending;
> +
> +       pending = read_c0_cause() & read_c0_status() & ST0_IM;
> +
> +       if (pending & CAUSEF_IP7)
> +               do_IRQ(TIMER_IRQ);
> +       else if (pending & CAUSEF_IP2)
> +               loongson1_irq_dispatch(0); /* INT0 */
> +       else if (pending & CAUSEF_IP3)
> +               loongson1_irq_dispatch(1); /* INT1 */
> +       else if (pending & CAUSEF_IP4)
> +               loongson1_irq_dispatch(2); /* INT2 */
> +       else if (pending & CAUSEF_IP5)
> +               loongson1_irq_dispatch(3); /* INT3 */
> +       else if (pending & CAUSEF_IP6)
> +               loongson1_irq_dispatch(4); /* INT4 */
> +       else
> +               spurious_interrupt();
> +
> +}
> +
> +struct irqaction cascade_irqaction = {
> +       .handler = no_action,
> +       .name = "cascade",
> +};

The short no_action handler should be unthreaded, please mark it with
the following line.

+       .flags = IRQF_NO_THREAD,

Please see the kernel patch "mips: i8259: Mark cascade interrupt
non-threaded" as a reference in MIPS mailing list or patchwork sent by
Thomas.

> +
> +static void __init loongson1_irq_init(int base)
> +{
> +       int n;
> +
> +       /* Disable interrupts and clear pending,
> +        * setup all IRQs as high level triggered
> +        */
> +       for (n = 0; n < 4; n++) {
> +               __raw_writel(0x0, LS1_INTC_INTIEN(n));
> +               __raw_writel(0xffffffff, LS1_INTC_INTCLR(n));
> +               __raw_writel(0xffffffff, LS1_INTC_INTPOL(n));
> +               __raw_writel(0x0, LS1_INTC_INTEDGE(n));
> +       }
> +
> +
> +       for (n = base; n < NR_IRQS; n++) {
> +               irq_set_chip_and_handler(n, &loongson1_irq_chip,
> +                                        handle_level_irq);
> +       }
> +
> +       setup_irq(INT0_IRQ, &cascade_irqaction);
> +       setup_irq(INT1_IRQ, &cascade_irqaction);
> +       setup_irq(INT2_IRQ, &cascade_irqaction);
> +       setup_irq(INT3_IRQ, &cascade_irqaction);
> +}
> +
> +void __init arch_init_irq(void)
> +{
> +       mips_cpu_irq_init();
> +       loongson1_irq_init(LOONGSON1_IRQ_BASE);
> +}
> diff --git a/arch/mips/loongson1/common/platform.c b/arch/mips/loongson1/common/platform.c
> new file mode 100644
> index 0000000..4ea477d
> --- /dev/null
> +++ b/arch/mips/loongson1/common/platform.c
> @@ -0,0 +1,50 @@
> +/*
> + * Copyright (c) 2011 Zhang, Keguang <keguang.zhang@gmail.com>
> + *
> + * This program is free software; you can redistribute  it and/or modify it
> + * under  the terms of  the GNU General  Public License as published by the
> + * Free Software Foundation;  either version 2 of the  License, or (at your
> + * option) any later version.
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/err.h>
> +#include <linux/serial_8250.h>
> +
> +#include <loongson1.h>
> +
> +#define LOONGSON1_UART_PORT(_id)                                       \
> +       {                                                               \
> +               .mapbase        = LOONGSON1_UART ## _id ## _BASE,       \
> +               .membase        = (void *)(LOONGSON1_UART ## _id ## _BASE), \
> +               .irq            = LOONGSON1_UART ## _id ## _IRQ,        \
> +               .iotype         = UPIO_MEM,                             \
> +               .flags          = UPF_BOOT_AUTOCONF | UPF_FIXED_TYPE,   \
> +               .type           = PORT_16550A,                          \
> +       }
> +
> +static struct plat_serial8250_port loongson1_serial8250_port[] = {
> +       LOONGSON1_UART_PORT(0),
> +       {},
> +};
> +
> +struct platform_device loongson1_uart_device = {
> +       .name                   = "serial8250",
> +       .id                     = PLAT8250_DEV_PLATFORM,
> +       .dev                    = {
> +               .platform_data  = loongson1_serial8250_port,
> +       },
> +};
> +
> +void __init loongson1_serial_setup(void)
> +{
> +       struct clk *clk;
> +       struct plat_serial8250_port *p;
> +
> +        clk = clk_get(NULL, "dc");
> +        if (IS_ERR(clk))
> +               panic("unable to get dc clock, err=%ld", PTR_ERR(clk));
> +
> +       for (p = loongson1_serial8250_port; p->flags != 0; ++p)
> +               p->uartclk = clk_get_rate(clk);
> +}
> diff --git a/arch/mips/loongson1/common/prom.c b/arch/mips/loongson1/common/prom.c
> new file mode 100644
> index 0000000..a7422f4
> --- /dev/null
> +++ b/arch/mips/loongson1/common/prom.c
> @@ -0,0 +1,89 @@
> +/*
> + * Copyright (c) 2011 Zhang, Keguang <keguang.zhang@gmail.com>
> + *
> + * Modified from arch/mips/pnx833x/common/prom.c.
> + *
> + * This program is free software; you can redistribute  it and/or modify it
> + * under  the terms of  the GNU General  Public License as published by the
> + * Free Software Foundation;  either version 2 of the  License, or (at your
> + * option) any later version.
> + */
> +
> +#include <linux/serial_reg.h>
> +#include <asm/bootinfo.h>
> +
> +#include <loongson1.h>
> +#include <prom.h>
> +
> +int prom_argc;
> +char **prom_argv, **prom_envp;
> +unsigned long memsize, highmemsize;
> +
> +char *prom_getenv(char *envname)
> +{
> +       extern char **prom_envp;
> +       char **env = prom_envp;
> +       int i;
> +
> +       i = strlen(envname);
> +
> +       while (*env) {
> +               if (strncmp(envname, *env, i) == 0 && *(*env+i) == '=')
> +                       return *env + i + 1;
> +               env++;
> +       }
> +
> +       return 0;
> +}
> +
> +static inline unsigned long env_or_default(char *env, unsigned long dfl)
> +{
> +       char *str = prom_getenv(env);
> +       return str ? simple_strtol(str, 0, 0) : dfl;
> +}
> +
> +void __init prom_init_cmdline(void)
> +{
> +       char *c = &(arcs_cmdline[0]);
> +       int i;
> +
> +       for (i = 1; i < prom_argc; i++) {
> +               strcpy(c, prom_argv[i]);
> +               c += strlen(prom_argv[i]);
> +               if (i < prom_argc-1)
> +                       *c++ = ' ';
> +       }
> +       *c = 0;
> +}
> +
> +void __init prom_init(void)
> +{
> +       prom_argc = fw_arg0;
> +       prom_argv = (char **)fw_arg1;
> +       prom_envp = (char **)fw_arg2;
> +
> +       prom_init_cmdline();
> +
> +       memsize = env_or_default("memsize", DEFAULT_MEMSIZE);
> +       highmemsize = env_or_default("highmemsize", 0x0);
> +}
> +
> +void __init prom_free_prom_memory(void)
> +{
> +}
> +
> +#define UART_BASE      LOONGSON1_UART0_BASE
> +#define PORT(base, offset) (u8 *)(base + offset)
> +
> +void __init prom_putchar(char c)
> +{
> +       int timeout;
> +
> +       timeout = 1024;
> +
> +       while (((readb(PORT(UART_BASE, UART_LSR)) & UART_LSR_THRE) == 0)
> +                       && (timeout-- > 0))
> +               ;
> +
> +       writeb(c, PORT(UART_BASE, UART_TX));
> +}
> diff --git a/arch/mips/loongson1/common/reset.c b/arch/mips/loongson1/common/reset.c
> new file mode 100644
> index 0000000..75f550f
> --- /dev/null
> +++ b/arch/mips/loongson1/common/reset.c
> @@ -0,0 +1,46 @@
> +/*
> + * Copyright (c) 2011 Zhang, Keguang <keguang.zhang@gmail.com>
> + *
> + * This program is free software; you can redistribute  it and/or modify it
> + * under  the terms of  the GNU General  Public License as published by the
> + * Free Software Foundation;  either version 2 of the  License, or (at your
> + * option) any later version.
> + */
> +
> +#include <linux/io.h>
> +#include <linux/pm.h>
> +#include <asm/reboot.h>
> +
> +#include <loongson1.h>
> +
> +static void loongson1_restart(char *command)
> +{
> +       __raw_writel(0x1, LS1_WDT_EN);
> +       __raw_writel(0x5000000, LS1_WDT_TIMER);
> +       __raw_writel(0x1, LS1_WDT_SET);
> +}
> +
> +static void loongson1_halt(void)
> +{
> +       pr_notice("\n\n** You can safely turn off the power now **\n\n");
> +       while (1) {
> +               if (cpu_wait)
> +                       cpu_wait();
> +       }
> +}
> +
> +static void loongson1_power_off(void)
> +{
> +       loongson1_halt();
> +}
> +
> +static int __init loongson1_reboot_setup(void)
> +{
> +       _machine_restart = loongson1_restart;
> +       _machine_halt = loongson1_halt;
> +       pm_power_off = loongson1_power_off;
> +
> +       return 0;
> +}
> +
> +arch_initcall(loongson1_reboot_setup);
> diff --git a/arch/mips/loongson1/common/setup.c b/arch/mips/loongson1/common/setup.c
> new file mode 100644
> index 0000000..62128cc
> --- /dev/null
> +++ b/arch/mips/loongson1/common/setup.c
> @@ -0,0 +1,29 @@
> +/*
> + * Copyright (c) 2011 Zhang, Keguang <keguang.zhang@gmail.com>
> + *
> + * This program is free software; you can redistribute  it and/or modify it
> + * under  the terms of  the GNU General  Public License as published by the
> + * Free Software Foundation;  either version 2 of the  License, or (at your
> + * option) any later version.
> + */
> +
> +#include <asm/bootinfo.h>
> +
> +#include <prom.h>
> +
> +void __init plat_mem_setup(void)
> +{
> +       add_memory_region(0x0, (memsize << 20), BOOT_MEM_RAM);
> +}
> +
> +const char *get_system_type(void)
> +{
> +       unsigned int processor_id = (&current_cpu_data)->processor_id;
> +
> +       switch (processor_id & PRID_REV_MASK) {
> +       case PRID_REV_LOONGSON1B:
> +               return "LOONGSON LS1B";
> +       default:
> +               return "LOONGSON (unknown)";
> +       }
> +}
> diff --git a/arch/mips/loongson1/ls1b/Makefile b/arch/mips/loongson1/ls1b/Makefile
> new file mode 100644
> index 0000000..891eac4
> --- /dev/null
> +++ b/arch/mips/loongson1/ls1b/Makefile
> @@ -0,0 +1,5 @@
> +#
> +# Makefile for loongson1B based machines.
> +#
> +
> +obj-y += board.o
> diff --git a/arch/mips/loongson1/ls1b/board.c b/arch/mips/loongson1/ls1b/board.c
> new file mode 100644
> index 0000000..b1a602f
> --- /dev/null
> +++ b/arch/mips/loongson1/ls1b/board.c
> @@ -0,0 +1,30 @@
> +/*
> + * Copyright (c) 2011 Zhang, Keguang <keguang.zhang@gmail.com>
> + *
> + * This program is free software; you can redistribute  it and/or modify it
> + * under  the terms of  the GNU General  Public License as published by the
> + * Free Software Foundation;  either version 2 of the  License, or (at your
> + * option) any later version.
> + */
> +
> +#include <platform.h>
> +
> +#include <linux/serial_8250.h>
> +#include <loongson1.h>
> +
> +static struct platform_device *loongson1_platform_devices[] __initdata = {
> +       &loongson1_uart_device,
> +};
> +
> +static int __init loongson1_platform_init(void)
> +{
> +       int err;
> +
> +       loongson1_serial_setup();
> +
> +       err = platform_add_devices(loongson1_platform_devices,
> +                                  ARRAY_SIZE(loongson1_platform_devices));
> +       return err;
> +}
> +
> +arch_initcall(loongson1_platform_init);
> diff --git a/arch/mips/oprofile/common.c b/arch/mips/oprofile/common.c
> index d1f2d4c..99216f0 100644
> --- a/arch/mips/oprofile/common.c
> +++ b/arch/mips/oprofile/common.c
> @@ -89,6 +89,7 @@ int __init oprofile_arch_init(struct oprofile_operations *ops)
>        case CPU_R10000:
>        case CPU_R12000:
>        case CPU_R14000:
> +       case CPU_LOONGSON1:
>                lmodel = &op_model_mipsxx_ops;
>                break;
>
> diff --git a/arch/mips/oprofile/op_model_mipsxx.c b/arch/mips/oprofile/op_model_mipsxx.c
> index 54759f1..03be670 100644
> --- a/arch/mips/oprofile/op_model_mipsxx.c
> +++ b/arch/mips/oprofile/op_model_mipsxx.c
> @@ -365,6 +365,10 @@ static int __init mipsxx_init(void)
>                op_model_mipsxx_ops.cpu_type = "mips/sb1";
>                break;
>
> +       case CPU_LOONGSON1:
> +               op_model_mipsxx_ops.cpu_type = "mips/loongson1";
> +               break;
> +
>        default:
>                printk(KERN_ERR "Profiling unsupported for this CPU\n");
>
> --
> 1.7.1
>
>

It may still be possible to reduce duplications if we consider
applying dtb for Loongson ;)

Best Regards,
Wu Zhangjin
