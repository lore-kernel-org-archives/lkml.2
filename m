Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651Ab2BRVYi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Feb 2012 16:24:38 -0500
Received: from amber.ccs.neu.edu ([129.10.116.51]:56017 "EHLO
	amber.ccs.neu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753220Ab2BRVYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Feb 2012 16:24:35 -0500
Date: Sat, 18 Feb 2012 16:24:31 -0500
From: Jim Faulkner <jfaulkne@ccs.neu.edu>
To: linux-alpha@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        gregkh@linuxfoundation.org, rth@twiddle.net, ink@jurassic.park.msu.ru,
        mattst88@gmail.com, torvalds@linux-foundation.org,
        jay.estabrook@gmail.com
Subject: [PATCH] fix modpost when CONFIG_ALPHA_TSUNAMI=y
Message-ID: <20120218212431.GA25058@alumni-linux.ccs.neu.edu>
References: <20120109003504.GA19756@alumni-linux.ccs.neu.edu>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="Kj7319i9nmIyA2yE"
Content-Disposition: inline
In-Reply-To: <20120109003504.GA19756@alumni-linux.ccs.neu.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Kj7319i9nmIyA2yE
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Linux 3.2.6 fails to modpost on my alpha machine when
CONFIG_ALPHA_TSUNAMI=y.  Linux 3.3-rc3 does not appear to have a fix for
this bug, so is likely also affected.  I've attached a patch which fixes
this issue.  I have tested this patch on Linux 3.2.6 successfully, and
the patch also applies cleanly to Linux 3.3-rc3.

Linus, please consider adding this patch to the mainline.  Greg, please
consider adding this patch to the 3.2 stable tree.  Thanks to Jay
Estabrook for pointing out the fix for this issue.


On Sun, Jan 08, 2012 at 07:35:04PM -0500, Jim Faulkner wrote:
> Linux 3.2 fails to modpost on my alpha machine.  I'm using gcc 4.5.3 on
> Gentoo.  Linux 3.0.14 modposts fine with a similar configuration.  My
> .config is attached.  See below:
> 
>   SYSMAP  .tmp_System.map
>   STRIP  arch/alpha/boot/vmlinux
>   GZIP    arch/alpha/boot/vmlinux.gz
>   Kernel arch/alpha/boot/vmlinux.gz is ready
>   Building modules, stage 2.
>   MODPOST 491 modules
> ERROR: "tsunami_ioportmap" [drivers/tty/serial/8250_pci.ko] undefined!
> ERROR: "tsunami_ioremap" [drivers/tty/serial/8250_pci.ko] undefined!
> ERROR: "tsunami_ioportmap" [drivers/tty/serial/8250.ko] undefined!
> ERROR: "tsunami_ioremap" [drivers/tty/serial/8250.ko] undefined!
> ERROR: "tsunami_ioremap" [drivers/rtc/rtc-v3020.ko] undefined!
> ERROR: "tsunami_ioremap" [drivers/rtc/rtc-rp5c01.ko] undefined!
> ERROR: "tsunami_ioremap" [drivers/rtc/rtc-msm6242.ko] undefined!
> ERROR: "tsunami_ioremap" [drivers/rtc/rtc-m48t59.ko] undefined!
> ERROR: "tsunami_ioremap" [drivers/rtc/rtc-m48t35.ko] undefined!
> ERROR: "tsunami_ioremap" [drivers/rtc/rtc-ds1286.ko] undefined!
> ERROR: "tsunami_ioportmap" [drivers/rtc/rtc-cmos.ko] undefined!
> ERROR: "tsunami_ioportmap" [drivers/rtc/rtc-bq4802.ko] undefined!
> ERROR: "tsunami_ioremap" [drivers/rtc/rtc-bq4802.ko] undefined!
> ERROR: "tsunami_ioportmap" [drivers/i2c/busses/i2c-viapro.ko] undefined!
> ERROR: "tsunami_ioportmap" [drivers/i2c/busses/i2c-via.ko] undefined!
> ERROR: "tsunami_ioportmap" [drivers/i2c/busses/i2c-sis96x.ko] undefined!
> ERROR: "tsunami_ioportmap" [drivers/i2c/busses/i2c-sis630.ko] undefined!
> ERROR: "tsunami_ioportmap" [drivers/i2c/busses/i2c-sis5595.ko] undefined!
> ERROR: "tsunami_ioportmap" [drivers/i2c/busses/i2c-piix4.ko] undefined!
> ERROR: "tsunami_ioportmap" [drivers/i2c/busses/i2c-pca-isa.ko] undefined!
> ERROR: "tsunami_ioportmap" [drivers/i2c/busses/i2c-nforce2.ko] undefined!
> ERROR: "tsunami_ioportmap" [drivers/i2c/busses/i2c-isch.ko] undefined!
> ERROR: "tsunami_ioportmap" [drivers/i2c/busses/i2c-i801.ko] undefined!
> ERROR: "tsunami_ioportmap" [drivers/i2c/busses/i2c-amd8111.ko] undefined!
> ERROR: "tsunami_ioportmap" [drivers/i2c/busses/i2c-amd756.ko] undefined!
> ERROR: "tsunami_ioportmap" [drivers/i2c/busses/i2c-ali15x3.ko] undefined!
> ERROR: "tsunami_ioportmap" [drivers/i2c/busses/i2c-ali1563.ko] undefined!
> ERROR: "tsunami_ioportmap" [drivers/i2c/busses/i2c-ali1535.ko] undefined!
> ERROR: "tsunami_ioportmap" [drivers/hwmon/w83781d.ko] undefined!
> ERROR: "tsunami_ioportmap" [drivers/hwmon/w83627hf.ko] undefined!
> ERROR: "tsunami_ioportmap" [drivers/hwmon/w83627ehf.ko] undefined!
> ERROR: "tsunami_ioportmap" [drivers/hwmon/vt8231.ko] undefined!
> ERROR: "tsunami_ioportmap" [drivers/hwmon/vt1211.ko] undefined!
> ERROR: "tsunami_ioportmap" [drivers/hwmon/via686a.ko] undefined!
> ERROR: "tsunami_ioportmap" [drivers/hwmon/smsc47m1.ko] undefined!
> ERROR: "tsunami_ioportmap" [drivers/hwmon/smsc47b397.ko] undefined!
> ERROR: "tsunami_ioportmap" [drivers/hwmon/sis5595.ko] undefined!
> ERROR: "tsunami_ioportmap" [drivers/hwmon/sch56xx-common.ko] undefined!
> ERROR: "tsunami_ioportmap" [drivers/hwmon/pc87427.ko] undefined!
> ERROR: "tsunami_ioportmap" [drivers/hwmon/pc87360.ko] undefined!
> ERROR: "tsunami_ioportmap" [drivers/hwmon/lm78.ko] undefined!
> ERROR: "tsunami_ioportmap" [drivers/hwmon/it87.ko] undefined!
> ERROR: "tsunami_ioremap" [drivers/hwmon/i5k_amb.ko] undefined!
> ERROR: "tsunami_ioportmap" [drivers/hwmon/f71882fg.ko] undefined!
> ERROR: "tsunami_ioportmap" [drivers/hwmon/f71805f.ko] undefined!
> ERROR: "tsunami_ioportmap" [drivers/hwmon/dme1737.ko] undefined!
> ERROR: "tsunami_ioportmap" [drivers/gpio/gpio-vx855.ko] undefined!
> ERROR: "tsunami_ioportmap" [drivers/gpio/gpio-it8761e.ko] undefined!
> ERROR: "tsunami_ioremap" [drivers/gpio/gpio-bt8xx.ko] undefined!
> ERROR: "tsunami_ioremap" [drivers/dma/timb_dma.ko] undefined!
> ERROR: "tsunami_ioportmap" [drivers/block/floppy.ko] undefined!
> make[1]: *** [__modpost] Error 1
> make: *** [modules] Error 2
> 

> #
> # Automatically generated file; DO NOT EDIT.
> # Linux/alpha 3.2.0 Kernel Configuration
> #
> CONFIG_ALPHA=y
> CONFIG_64BIT=y
> CONFIG_MMU=y
> CONFIG_RWSEM_XCHGADD_ALGORITHM=y
> # CONFIG_ARCH_HAS_ILOG2_U32 is not set
> # CONFIG_ARCH_HAS_ILOG2_U64 is not set
> CONFIG_GENERIC_CALIBRATE_DELAY=y
> CONFIG_GENERIC_CMOS_UPDATE=y
> CONFIG_GENERIC_GPIO=y
> CONFIG_ZONE_DMA=y
> CONFIG_ARCH_DMA_ADDR_T_64BIT=y
> CONFIG_NEED_DMA_MAP_STATE=y
> CONFIG_NEED_SG_DMA_LENGTH=y
> CONFIG_GENERIC_ISA_DMA=y
> # CONFIG_GENERIC_IOMAP is not set
> CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
> CONFIG_HAVE_IRQ_WORK=y
> 
> #
> # General setup
> #
> CONFIG_EXPERIMENTAL=y
> CONFIG_BROKEN_ON_SMP=y
> CONFIG_INIT_ENV_ARG_LIMIT=32
> CONFIG_CROSS_COMPILE=""
> CONFIG_LOCALVERSION=""
> # CONFIG_LOCALVERSION_AUTO is not set
> CONFIG_DEFAULT_HOSTNAME="(none)"
> CONFIG_SWAP=y
> CONFIG_SYSVIPC=y
> CONFIG_SYSVIPC_SYSCTL=y
> CONFIG_POSIX_MQUEUE=y
> CONFIG_POSIX_MQUEUE_SYSCTL=y
> CONFIG_BSD_PROCESS_ACCT=y
> CONFIG_BSD_PROCESS_ACCT_V3=y
> # CONFIG_FHANDLE is not set
> # CONFIG_TASKSTATS is not set
> CONFIG_AUDIT=y
> CONFIG_HAVE_GENERIC_HARDIRQS=y
> 
> #
> # IRQ subsystem
> #
> CONFIG_GENERIC_HARDIRQS=y
> CONFIG_GENERIC_IRQ_PROBE=y
> CONFIG_GENERIC_IRQ_SHOW=y
> CONFIG_GENERIC_IRQ_CHIP=y
> 
> #
> # RCU Subsystem
> #
> CONFIG_TINY_RCU=y
> # CONFIG_PREEMPT_RCU is not set
> # CONFIG_RCU_TRACE is not set
> # CONFIG_TREE_RCU_TRACE is not set
> CONFIG_IKCONFIG=y
> CONFIG_IKCONFIG_PROC=y
> CONFIG_LOG_BUF_SHIFT=18
> CONFIG_CGROUPS=y
> # CONFIG_CGROUP_DEBUG is not set
> CONFIG_CGROUP_FREEZER=y
> # CONFIG_CGROUP_DEVICE is not set
> CONFIG_CPUSETS=y
> # CONFIG_PROC_PID_CPUSET is not set
> CONFIG_CGROUP_CPUACCT=y
> CONFIG_RESOURCE_COUNTERS=y
> CONFIG_CGROUP_MEM_RES_CTLR=y
> CONFIG_CGROUP_MEM_RES_CTLR_SWAP=y
> CONFIG_CGROUP_MEM_RES_CTLR_SWAP_ENABLED=y
> CONFIG_CGROUP_SCHED=y
> CONFIG_FAIR_GROUP_SCHED=y
> # CONFIG_CFS_BANDWIDTH is not set
> # CONFIG_RT_GROUP_SCHED is not set
> CONFIG_BLK_CGROUP=y
> # CONFIG_DEBUG_BLK_CGROUP is not set
> CONFIG_NAMESPACES=y
> CONFIG_UTS_NS=y
> CONFIG_IPC_NS=y
> CONFIG_USER_NS=y
> CONFIG_PID_NS=y
> CONFIG_NET_NS=y
> CONFIG_SCHED_AUTOGROUP=y
> CONFIG_MM_OWNER=y
> # CONFIG_SYSFS_DEPRECATED is not set
> CONFIG_RELAY=y
> CONFIG_BLK_DEV_INITRD=y
> CONFIG_INITRAMFS_SOURCE=""
> CONFIG_RD_GZIP=y
> CONFIG_RD_BZIP2=y
> CONFIG_RD_LZMA=y
> CONFIG_RD_XZ=y
> CONFIG_RD_LZO=y
> # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
> CONFIG_SYSCTL=y
> CONFIG_ANON_INODES=y
> # CONFIG_EXPERT is not set
> # CONFIG_SYSCTL_SYSCALL is not set
> CONFIG_KALLSYMS=y
> # CONFIG_KALLSYMS_ALL is not set
> CONFIG_HOTPLUG=y
> CONFIG_PRINTK=y
> CONFIG_BUG=y
> CONFIG_ELF_CORE=y
> CONFIG_PCSPKR_PLATFORM=y
> CONFIG_HAVE_PCSPKR_PLATFORM=y
> CONFIG_BASE_FULL=y
> CONFIG_FUTEX=y
> CONFIG_EPOLL=y
> CONFIG_SIGNALFD=y
> CONFIG_TIMERFD=y
> CONFIG_EVENTFD=y
> CONFIG_SHMEM=y
> CONFIG_AIO=y
> # CONFIG_EMBEDDED is not set
> CONFIG_HAVE_PERF_EVENTS=y
> 
> #
> # Kernel Performance Events And Counters
> #
> # CONFIG_PERF_EVENTS is not set
> # CONFIG_PERF_COUNTERS is not set
> CONFIG_VM_EVENT_COUNTERS=y
> CONFIG_PCI_QUIRKS=y
> CONFIG_SLUB_DEBUG=y
> # CONFIG_COMPAT_BRK is not set
> # CONFIG_SLAB is not set
> CONFIG_SLUB=y
> # CONFIG_PROFILING is not set
> CONFIG_HAVE_OPROFILE=y
> CONFIG_HAVE_SYSCALL_WRAPPERS=y
> CONFIG_HAVE_DMA_ATTRS=y
> CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
> 
> #
> # GCOV-based kernel profiling
> #
> # CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
> CONFIG_SLABINFO=y
> CONFIG_RT_MUTEXES=y
> CONFIG_BASE_SMALL=0
> CONFIG_MODULES=y
> # CONFIG_MODULE_FORCE_LOAD is not set
> CONFIG_MODULE_UNLOAD=y
> CONFIG_MODULE_FORCE_UNLOAD=y
> # CONFIG_MODVERSIONS is not set
> # CONFIG_MODULE_SRCVERSION_ALL is not set
> CONFIG_BLOCK=y
> CONFIG_BLK_DEV_BSG=y
> CONFIG_BLK_DEV_BSGLIB=y
> CONFIG_BLK_DEV_INTEGRITY=y
> CONFIG_BLK_DEV_THROTTLING=y
> 
> #
> # IO Schedulers
> #
> CONFIG_IOSCHED_NOOP=y
> CONFIG_IOSCHED_DEADLINE=m
> CONFIG_IOSCHED_CFQ=y
> CONFIG_CFQ_GROUP_IOSCHED=y
> # CONFIG_DEFAULT_DEADLINE is not set
> CONFIG_DEFAULT_CFQ=y
> # CONFIG_DEFAULT_NOOP is not set
> CONFIG_DEFAULT_IOSCHED="cfq"
> # CONFIG_INLINE_SPIN_TRYLOCK is not set
> # CONFIG_INLINE_SPIN_TRYLOCK_BH is not set
> # CONFIG_INLINE_SPIN_LOCK is not set
> # CONFIG_INLINE_SPIN_LOCK_BH is not set
> # CONFIG_INLINE_SPIN_LOCK_IRQ is not set
> # CONFIG_INLINE_SPIN_LOCK_IRQSAVE is not set
> CONFIG_INLINE_SPIN_UNLOCK=y
> # CONFIG_INLINE_SPIN_UNLOCK_BH is not set
> CONFIG_INLINE_SPIN_UNLOCK_IRQ=y
> # CONFIG_INLINE_SPIN_UNLOCK_IRQRESTORE is not set
> # CONFIG_INLINE_READ_TRYLOCK is not set
> # CONFIG_INLINE_READ_LOCK is not set
> # CONFIG_INLINE_READ_LOCK_BH is not set
> # CONFIG_INLINE_READ_LOCK_IRQ is not set
> # CONFIG_INLINE_READ_LOCK_IRQSAVE is not set
> CONFIG_INLINE_READ_UNLOCK=y
> # CONFIG_INLINE_READ_UNLOCK_BH is not set
> CONFIG_INLINE_READ_UNLOCK_IRQ=y
> # CONFIG_INLINE_READ_UNLOCK_IRQRESTORE is not set
> # CONFIG_INLINE_WRITE_TRYLOCK is not set
> # CONFIG_INLINE_WRITE_LOCK is not set
> # CONFIG_INLINE_WRITE_LOCK_BH is not set
> # CONFIG_INLINE_WRITE_LOCK_IRQ is not set
> # CONFIG_INLINE_WRITE_LOCK_IRQSAVE is not set
> CONFIG_INLINE_WRITE_UNLOCK=y
> # CONFIG_INLINE_WRITE_UNLOCK_BH is not set
> CONFIG_INLINE_WRITE_UNLOCK_IRQ=y
> # CONFIG_INLINE_WRITE_UNLOCK_IRQRESTORE is not set
> # CONFIG_MUTEX_SPIN_ON_OWNER is not set
> CONFIG_FREEZER=y
> 
> #
> # System setup
> #
> # CONFIG_ALPHA_GENERIC is not set
> # CONFIG_ALPHA_ALCOR is not set
> # CONFIG_ALPHA_XL is not set
> # CONFIG_ALPHA_BOOK1 is not set
> # CONFIG_ALPHA_AVANTI_CH is not set
> # CONFIG_ALPHA_CABRIOLET is not set
> CONFIG_ALPHA_DP264=y
> # CONFIG_ALPHA_EB164 is not set
> # CONFIG_ALPHA_EB64P_CH is not set
> # CONFIG_ALPHA_EB66 is not set
> # CONFIG_ALPHA_EB66P is not set
> # CONFIG_ALPHA_EIGER is not set
> # CONFIG_ALPHA_JENSEN is not set
> # CONFIG_ALPHA_LX164 is not set
> # CONFIG_ALPHA_LYNX is not set
> # CONFIG_ALPHA_MARVEL is not set
> # CONFIG_ALPHA_MIATA is not set
> # CONFIG_ALPHA_MIKASA is not set
> # CONFIG_ALPHA_NAUTILUS is not set
> # CONFIG_ALPHA_NONAME_CH is not set
> # CONFIG_ALPHA_NORITAKE is not set
> # CONFIG_ALPHA_PC164 is not set
> # CONFIG_ALPHA_P2K is not set
> # CONFIG_ALPHA_RAWHIDE is not set
> # CONFIG_ALPHA_RUFFIAN is not set
> # CONFIG_ALPHA_RX164 is not set
> # CONFIG_ALPHA_SX164 is not set
> # CONFIG_ALPHA_SABLE is not set
> # CONFIG_ALPHA_SHARK is not set
> # CONFIG_ALPHA_TAKARA is not set
> # CONFIG_ALPHA_TITAN is not set
> # CONFIG_ALPHA_WILDFIRE is not set
> CONFIG_ISA=y
> CONFIG_ISA_DMA_API=y
> CONFIG_PCI=y
> CONFIG_PCI_DOMAINS=y
> CONFIG_PCI_SYSCALL=y
> CONFIG_IOMMU_HELPER=y
> CONFIG_ALPHA_EV6=y
> CONFIG_ALPHA_TSUNAMI=y
> # CONFIG_ALPHA_EV67 is not set
> CONFIG_GENERIC_HWEIGHT=y
> CONFIG_VGA_HOSE=y
> CONFIG_ALPHA_SRM=y
> CONFIG_ARCH_MAY_HAVE_PC_FDC=y
> # CONFIG_SMP is not set
> # CONFIG_ARCH_DISCONTIGMEM_ENABLE is not set
> CONFIG_SELECT_MEMORY_MODEL=y
> CONFIG_FLATMEM_MANUAL=y
> CONFIG_FLATMEM=y
> CONFIG_FLAT_NODE_MEM_MAP=y
> CONFIG_PAGEFLAGS_EXTENDED=y
> CONFIG_SPLIT_PTLOCK_CPUS=4
> # CONFIG_COMPACTION is not set
> CONFIG_PHYS_ADDR_T_64BIT=y
> CONFIG_ZONE_DMA_FLAG=1
> CONFIG_BOUNCE=y
> CONFIG_VIRT_TO_BUS=y
> # CONFIG_KSM is not set
> CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
> CONFIG_NEED_PER_CPU_KM=y
> # CONFIG_CLEANCACHE is not set
> CONFIG_VERBOSE_MCHECK=y
> CONFIG_VERBOSE_MCHECK_ON=1
> CONFIG_HZ=1024
> # CONFIG_ARCH_SUPPORTS_MSI is not set
> # CONFIG_PCI_DEBUG is not set
> # CONFIG_PCI_STUB is not set
> # CONFIG_PCI_IOV is not set
> # CONFIG_PCI_PRI is not set
> # CONFIG_PCI_PASID is not set
> # CONFIG_PCCARD is not set
> CONFIG_SRM_ENV=y
> CONFIG_BINFMT_ELF=y
> # CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
> CONFIG_HAVE_AOUT=y
> # CONFIG_BINFMT_AOUT is not set
> # CONFIG_BINFMT_EM86 is not set
> CONFIG_BINFMT_MISC=m
> CONFIG_NET=y
> 
> #
> # Networking options
> #
> CONFIG_PACKET=m
> CONFIG_UNIX=m
> CONFIG_XFRM=y
> CONFIG_XFRM_USER=m
> # CONFIG_XFRM_SUB_POLICY is not set
> # CONFIG_XFRM_MIGRATE is not set
> # CONFIG_XFRM_STATISTICS is not set
> CONFIG_XFRM_IPCOMP=m
> CONFIG_NET_KEY=m
> # CONFIG_NET_KEY_MIGRATE is not set
> CONFIG_INET=y
> # CONFIG_IP_MULTICAST is not set
> CONFIG_IP_ADVANCED_ROUTER=y
> # CONFIG_IP_FIB_TRIE_STATS is not set
> # CONFIG_IP_MULTIPLE_TABLES is not set
> # CONFIG_IP_ROUTE_MULTIPATH is not set
> CONFIG_IP_ROUTE_VERBOSE=y
> # CONFIG_IP_PNP is not set
> CONFIG_NET_IPIP=m
> CONFIG_NET_IPGRE_DEMUX=m
> CONFIG_NET_IPGRE=m
> # CONFIG_ARPD is not set
> CONFIG_SYN_COOKIES=y
> CONFIG_INET_AH=m
> CONFIG_INET_ESP=m
> CONFIG_INET_IPCOMP=m
> CONFIG_INET_XFRM_TUNNEL=m
> CONFIG_INET_TUNNEL=m
> CONFIG_INET_XFRM_MODE_TRANSPORT=m
> CONFIG_INET_XFRM_MODE_TUNNEL=m
> CONFIG_INET_XFRM_MODE_BEET=m
> CONFIG_INET_LRO=m
> CONFIG_INET_DIAG=m
> CONFIG_INET_TCP_DIAG=m
> # CONFIG_TCP_CONG_ADVANCED is not set
> CONFIG_TCP_CONG_CUBIC=y
> CONFIG_DEFAULT_TCP_CONG="cubic"
> # CONFIG_TCP_MD5SIG is not set
> CONFIG_IPV6=m
> CONFIG_IPV6_PRIVACY=y
> CONFIG_IPV6_ROUTER_PREF=y
> CONFIG_IPV6_ROUTE_INFO=y
> CONFIG_IPV6_OPTIMISTIC_DAD=y
> CONFIG_INET6_AH=m
> CONFIG_INET6_ESP=m
> CONFIG_INET6_IPCOMP=m
> CONFIG_IPV6_MIP6=m
> CONFIG_INET6_XFRM_TUNNEL=m
> CONFIG_INET6_TUNNEL=m
> CONFIG_INET6_XFRM_MODE_TRANSPORT=m
> CONFIG_INET6_XFRM_MODE_TUNNEL=m
> CONFIG_INET6_XFRM_MODE_BEET=m
> CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION=m
> CONFIG_IPV6_SIT=m
> # CONFIG_IPV6_SIT_6RD is not set
> CONFIG_IPV6_NDISC_NODETYPE=y
> CONFIG_IPV6_TUNNEL=m
> # CONFIG_IPV6_MULTIPLE_TABLES is not set
> # CONFIG_IPV6_MROUTE is not set
> # CONFIG_NETLABEL is not set
> # CONFIG_NETWORK_SECMARK is not set
> # CONFIG_NETWORK_PHY_TIMESTAMPING is not set
> CONFIG_NETFILTER=y
> # CONFIG_NETFILTER_DEBUG is not set
> # CONFIG_NETFILTER_ADVANCED is not set
> 
> #
> # Core Netfilter Configuration
> #
> CONFIG_NETFILTER_NETLINK=m
> CONFIG_NETFILTER_NETLINK_LOG=m
> CONFIG_NF_CONNTRACK=m
> CONFIG_NF_CONNTRACK_FTP=m
> CONFIG_NF_CONNTRACK_IRC=m
> CONFIG_NF_CONNTRACK_BROADCAST=m
> CONFIG_NF_CONNTRACK_NETBIOS_NS=m
> CONFIG_NF_CONNTRACK_SIP=m
> CONFIG_NF_CT_NETLINK=m
> CONFIG_NETFILTER_XTABLES=m
> 
> #
> # Xtables combined modules
> #
> CONFIG_NETFILTER_XT_MARK=m
> 
> #
> # Xtables targets
> #
> CONFIG_NETFILTER_XT_TARGET_NFLOG=m
> CONFIG_NETFILTER_XT_TARGET_NOTRACK=m
> CONFIG_NETFILTER_XT_TARGET_TCPMSS=m
> 
> #
> # Xtables matches
> #
> CONFIG_NETFILTER_XT_MATCH_CONNTRACK=m
> CONFIG_NETFILTER_XT_MATCH_POLICY=m
> CONFIG_NETFILTER_XT_MATCH_STATE=m
> CONFIG_IP_SET=m
> CONFIG_IP_SET_MAX=256
> CONFIG_IP_SET_BITMAP_IP=m
> CONFIG_IP_SET_BITMAP_IPMAC=m
> CONFIG_IP_SET_BITMAP_PORT=m
> CONFIG_IP_SET_HASH_IP=m
> CONFIG_IP_SET_HASH_IPPORT=m
> CONFIG_IP_SET_HASH_IPPORTIP=m
> CONFIG_IP_SET_HASH_IPPORTNET=m
> CONFIG_IP_SET_HASH_NET=m
> CONFIG_IP_SET_HASH_NETPORT=m
> CONFIG_IP_SET_HASH_NETIFACE=m
> CONFIG_IP_SET_LIST_SET=m
> # CONFIG_IP_VS is not set
> 
> #
> # IP: Netfilter Configuration
> #
> CONFIG_NF_DEFRAG_IPV4=m
> CONFIG_NF_CONNTRACK_IPV4=m
> # CONFIG_NF_CONNTRACK_PROC_COMPAT is not set
> CONFIG_IP_NF_IPTABLES=m
> CONFIG_IP_NF_FILTER=m
> CONFIG_IP_NF_TARGET_REJECT=m
> CONFIG_IP_NF_TARGET_LOG=m
> CONFIG_IP_NF_TARGET_ULOG=m
> CONFIG_NF_NAT=m
> CONFIG_NF_NAT_NEEDED=y
> CONFIG_IP_NF_TARGET_MASQUERADE=m
> CONFIG_NF_NAT_FTP=m
> CONFIG_NF_NAT_IRC=m
> # CONFIG_NF_NAT_TFTP is not set
> # CONFIG_NF_NAT_AMANDA is not set
> # CONFIG_NF_NAT_PPTP is not set
> # CONFIG_NF_NAT_H323 is not set
> CONFIG_NF_NAT_SIP=m
> CONFIG_IP_NF_MANGLE=m
> CONFIG_IP_NF_RAW=m
> 
> #
> # IPv6: Netfilter Configuration
> #
> CONFIG_NF_DEFRAG_IPV6=m
> CONFIG_NF_CONNTRACK_IPV6=m
> CONFIG_IP6_NF_IPTABLES=m
> CONFIG_IP6_NF_MATCH_IPV6HEADER=m
> CONFIG_IP6_NF_TARGET_LOG=m
> CONFIG_IP6_NF_FILTER=m
> CONFIG_IP6_NF_TARGET_REJECT=m
> CONFIG_IP6_NF_MANGLE=m
> CONFIG_IP6_NF_RAW=m
> CONFIG_BRIDGE_NF_EBTABLES=m
> CONFIG_BRIDGE_EBT_BROUTE=m
> CONFIG_BRIDGE_EBT_T_FILTER=m
> CONFIG_BRIDGE_EBT_T_NAT=m
> CONFIG_BRIDGE_EBT_802_3=m
> CONFIG_BRIDGE_EBT_AMONG=m
> CONFIG_BRIDGE_EBT_ARP=m
> CONFIG_BRIDGE_EBT_IP=m
> CONFIG_BRIDGE_EBT_IP6=m
> CONFIG_BRIDGE_EBT_LIMIT=m
> CONFIG_BRIDGE_EBT_MARK=m
> CONFIG_BRIDGE_EBT_PKTTYPE=m
> CONFIG_BRIDGE_EBT_STP=m
> CONFIG_BRIDGE_EBT_VLAN=m
> CONFIG_BRIDGE_EBT_ARPREPLY=m
> CONFIG_BRIDGE_EBT_DNAT=m
> CONFIG_BRIDGE_EBT_MARK_T=m
> CONFIG_BRIDGE_EBT_REDIRECT=m
> CONFIG_BRIDGE_EBT_SNAT=m
> CONFIG_BRIDGE_EBT_LOG=m
> CONFIG_BRIDGE_EBT_ULOG=m
> CONFIG_BRIDGE_EBT_NFLOG=m
> # CONFIG_IP_DCCP is not set
> # CONFIG_IP_SCTP is not set
> # CONFIG_RDS is not set
> # CONFIG_TIPC is not set
> # CONFIG_ATM is not set
> # CONFIG_L2TP is not set
> CONFIG_STP=m
> CONFIG_BRIDGE=m
> CONFIG_BRIDGE_IGMP_SNOOPING=y
> # CONFIG_NET_DSA is not set
> CONFIG_VLAN_8021Q=m
> # CONFIG_VLAN_8021Q_GVRP is not set
> # CONFIG_DECNET is not set
> CONFIG_LLC=m
> # CONFIG_LLC2 is not set
> # CONFIG_IPX is not set
> # CONFIG_ATALK is not set
> # CONFIG_X25 is not set
> # CONFIG_LAPB is not set
> # CONFIG_ECONET is not set
> # CONFIG_WAN_ROUTER is not set
> # CONFIG_PHONET is not set
> # CONFIG_IEEE802154 is not set
> # CONFIG_NET_SCHED is not set
> # CONFIG_DCB is not set
> CONFIG_DNS_RESOLVER=y
> # CONFIG_BATMAN_ADV is not set
> 
> #
> # Network testing
> #
> # CONFIG_NET_PKTGEN is not set
> # CONFIG_HAMRADIO is not set
> # CONFIG_CAN is not set
> # CONFIG_IRDA is not set
> # CONFIG_BT is not set
> # CONFIG_AF_RXRPC is not set
> # CONFIG_WIRELESS is not set
> # CONFIG_WIMAX is not set
> # CONFIG_RFKILL is not set
> # CONFIG_NET_9P is not set
> # CONFIG_CAIF is not set
> # CONFIG_CEPH_LIB is not set
> # CONFIG_NFC is not set
> 
> #
> # Device Drivers
> #
> 
> #
> # Generic Driver Options
> #
> CONFIG_UEVENT_HELPER_PATH=""
> CONFIG_DEVTMPFS=y
> CONFIG_DEVTMPFS_MOUNT=y
> CONFIG_STANDALONE=y
> CONFIG_PREVENT_FIRMWARE_BUILD=y
> CONFIG_FW_LOADER=y
> CONFIG_FIRMWARE_IN_KERNEL=y
> CONFIG_EXTRA_FIRMWARE=""
> # CONFIG_DEBUG_DRIVER is not set
> # CONFIG_DEBUG_DEVRES is not set
> # CONFIG_SYS_HYPERVISOR is not set
> CONFIG_CONNECTOR=m
> # CONFIG_MTD is not set
> # CONFIG_PARPORT is not set
> CONFIG_PNP=y
> CONFIG_PNP_DEBUG_MESSAGES=y
> 
> #
> # Protocols
> #
> # CONFIG_ISAPNP is not set
> # CONFIG_PNPACPI is not set
> CONFIG_BLK_DEV=y
> CONFIG_BLK_DEV_FD=m
> # CONFIG_BLK_DEV_XD is not set
> # CONFIG_BLK_CPQ_DA is not set
> # CONFIG_BLK_CPQ_CISS_DA is not set
> # CONFIG_BLK_DEV_DAC960 is not set
> # CONFIG_BLK_DEV_UMEM is not set
> # CONFIG_BLK_DEV_COW_COMMON is not set
> CONFIG_BLK_DEV_LOOP=y
> CONFIG_BLK_DEV_LOOP_MIN_COUNT=8
> # CONFIG_BLK_DEV_CRYPTOLOOP is not set
> # CONFIG_BLK_DEV_DRBD is not set
> # CONFIG_BLK_DEV_NBD is not set
> # CONFIG_BLK_DEV_SX8 is not set
> CONFIG_BLK_DEV_RAM=y
> CONFIG_BLK_DEV_RAM_COUNT=16
> CONFIG_BLK_DEV_RAM_SIZE=16384
> # CONFIG_BLK_DEV_XIP is not set
> # CONFIG_CDROM_PKTCDVD is not set
> # CONFIG_ATA_OVER_ETH is not set
> # CONFIG_BLK_DEV_HD is not set
> # CONFIG_BLK_DEV_RBD is not set
> # CONFIG_SENSORS_LIS3LV02D is not set
> # CONFIG_MISC_DEVICES is not set
> CONFIG_HAVE_IDE=y
> # CONFIG_IDE is not set
> 
> #
> # SCSI device support
> #
> CONFIG_SCSI_MOD=y
> CONFIG_RAID_ATTRS=m
> CONFIG_SCSI=y
> CONFIG_SCSI_DMA=y
> CONFIG_SCSI_TGT=m
> # CONFIG_SCSI_NETLINK is not set
> # CONFIG_SCSI_PROC_FS is not set
> 
> #
> # SCSI support type (disk, tape, CD-ROM)
> #
> CONFIG_BLK_DEV_SD=y
> CONFIG_CHR_DEV_ST=m
> # CONFIG_CHR_DEV_OSST is not set
> CONFIG_BLK_DEV_SR=m
> # CONFIG_BLK_DEV_SR_VENDOR is not set
> CONFIG_CHR_DEV_SG=y
> # CONFIG_CHR_DEV_SCH is not set
> CONFIG_SCSI_MULTI_LUN=y
> CONFIG_SCSI_CONSTANTS=y
> # CONFIG_SCSI_LOGGING is not set
> # CONFIG_SCSI_SCAN_ASYNC is not set
> CONFIG_SCSI_WAIT_SCAN=m
> 
> #
> # SCSI Transports
> #
> CONFIG_SCSI_SPI_ATTRS=y
> # CONFIG_SCSI_FC_ATTRS is not set
> CONFIG_SCSI_ISCSI_ATTRS=m
> # CONFIG_SCSI_SAS_ATTRS is not set
> # CONFIG_SCSI_SAS_LIBSAS is not set
> # CONFIG_SCSI_SRP_ATTRS is not set
> CONFIG_SCSI_LOWLEVEL=y
> CONFIG_ISCSI_TCP=m
> # CONFIG_ISCSI_BOOT_SYSFS is not set
> # CONFIG_SCSI_CXGB3_ISCSI is not set
> # CONFIG_SCSI_CXGB4_ISCSI is not set
> # CONFIG_SCSI_BNX2_ISCSI is not set
> # CONFIG_SCSI_BNX2X_FCOE is not set
> # CONFIG_BE2ISCSI is not set
> # CONFIG_BLK_DEV_3W_XXXX_RAID is not set
> # CONFIG_SCSI_HPSA is not set
> # CONFIG_SCSI_3W_9XXX is not set
> # CONFIG_SCSI_3W_SAS is not set
> # CONFIG_SCSI_7000FASST is not set
> # CONFIG_SCSI_ACARD is not set
> # CONFIG_SCSI_AHA1542 is not set
> # CONFIG_SCSI_AACRAID is not set
> # CONFIG_SCSI_AIC7XXX is not set
> # CONFIG_SCSI_AIC7XXX_OLD is not set
> # CONFIG_SCSI_AIC79XX is not set
> # CONFIG_SCSI_AIC94XX is not set
> # CONFIG_SCSI_MVSAS is not set
> # CONFIG_SCSI_MVUMI is not set
> # CONFIG_SCSI_DPT_I2O is not set
> # CONFIG_SCSI_ADVANSYS is not set
> # CONFIG_SCSI_IN2000 is not set
> # CONFIG_SCSI_ARCMSR is not set
> # CONFIG_MEGARAID_NEWGEN is not set
> # CONFIG_MEGARAID_LEGACY is not set
> # CONFIG_MEGARAID_SAS is not set
> # CONFIG_SCSI_MPT2SAS is not set
> # CONFIG_SCSI_HPTIOP is not set
> # CONFIG_SCSI_BUSLOGIC is not set
> # CONFIG_LIBFC is not set
> # CONFIG_LIBFCOE is not set
> # CONFIG_FCOE is not set
> # CONFIG_SCSI_DMX3191D is not set
> # CONFIG_SCSI_DTC3280 is not set
> # CONFIG_SCSI_EATA is not set
> # CONFIG_SCSI_FUTURE_DOMAIN is not set
> # CONFIG_SCSI_GDTH is not set
> # CONFIG_SCSI_GENERIC_NCR5380 is not set
> # CONFIG_SCSI_GENERIC_NCR5380_MMIO is not set
> # CONFIG_SCSI_IPS is not set
> # CONFIG_SCSI_INITIO is not set
> # CONFIG_SCSI_INIA100 is not set
> # CONFIG_SCSI_NCR53C406A is not set
> # CONFIG_SCSI_STEX is not set
> CONFIG_SCSI_SYM53C8XX_2=y
> CONFIG_SCSI_SYM53C8XX_DMA_ADDRESSING_MODE=0
> CONFIG_SCSI_SYM53C8XX_DEFAULT_TAGS=16
> CONFIG_SCSI_SYM53C8XX_MAX_TAGS=64
> CONFIG_SCSI_SYM53C8XX_MMIO=y
> # CONFIG_SCSI_IPR is not set
> # CONFIG_SCSI_PAS16 is not set
> # CONFIG_SCSI_QLOGIC_FAS is not set
> # CONFIG_SCSI_QLOGIC_1280 is not set
> # CONFIG_SCSI_QLA_FC is not set
> # CONFIG_SCSI_QLA_ISCSI is not set
> # CONFIG_SCSI_LPFC is not set
> # CONFIG_SCSI_SYM53C416 is not set
> # CONFIG_SCSI_DC395x is not set
> # CONFIG_SCSI_DC390T is not set
> # CONFIG_SCSI_T128 is not set
> # CONFIG_SCSI_U14_34F is not set
> # CONFIG_SCSI_DEBUG is not set
> # CONFIG_SCSI_PMCRAID is not set
> # CONFIG_SCSI_PM8001 is not set
> # CONFIG_SCSI_SRP is not set
> # CONFIG_SCSI_BFA_FC is not set
> # CONFIG_SCSI_DH is not set
> # CONFIG_SCSI_OSD_INITIATOR is not set
> CONFIG_ATA=y
> # CONFIG_ATA_NONSTANDARD is not set
> CONFIG_ATA_VERBOSE_ERROR=y
> CONFIG_SATA_PMP=y
> 
> #
> # Controllers with non-SFF native interface
> #
> # CONFIG_SATA_AHCI is not set
> # CONFIG_SATA_AHCI_PLATFORM is not set
> # CONFIG_SATA_INIC162X is not set
> # CONFIG_SATA_ACARD_AHCI is not set
> # CONFIG_SATA_SIL24 is not set
> CONFIG_ATA_SFF=y
> 
> #
> # SFF controllers with custom DMA interface
> #
> # CONFIG_PDC_ADMA is not set
> # CONFIG_SATA_QSTOR is not set
> # CONFIG_SATA_SX4 is not set
> CONFIG_ATA_BMDMA=y
> 
> #
> # SATA SFF controllers with BMDMA
> #
> # CONFIG_ATA_PIIX is not set
> # CONFIG_SATA_MV is not set
> # CONFIG_SATA_NV is not set
> # CONFIG_SATA_PROMISE is not set
> # CONFIG_SATA_SIL is not set
> # CONFIG_SATA_SIS is not set
> # CONFIG_SATA_SVW is not set
> # CONFIG_SATA_ULI is not set
> # CONFIG_SATA_VIA is not set
> # CONFIG_SATA_VITESSE is not set
> 
> #
> # PATA SFF controllers with BMDMA
> #
> CONFIG_PATA_ALI=y
> # CONFIG_PATA_AMD is not set
> # CONFIG_PATA_ARASAN_CF is not set
> # CONFIG_PATA_ARTOP is not set
> # CONFIG_PATA_ATIIXP is not set
> # CONFIG_PATA_ATP867X is not set
> # CONFIG_PATA_CMD64X is not set
> # CONFIG_PATA_CS5520 is not set
> # CONFIG_PATA_CS5530 is not set
> # CONFIG_PATA_CS5536 is not set
> # CONFIG_PATA_CYPRESS is not set
> # CONFIG_PATA_EFAR is not set
> # CONFIG_PATA_HPT366 is not set
> # CONFIG_PATA_HPT37X is not set
> # CONFIG_PATA_HPT3X2N is not set
> # CONFIG_PATA_HPT3X3 is not set
> # CONFIG_PATA_IT8213 is not set
> # CONFIG_PATA_IT821X is not set
> # CONFIG_PATA_JMICRON is not set
> # CONFIG_PATA_MARVELL is not set
> # CONFIG_PATA_NETCELL is not set
> # CONFIG_PATA_NINJA32 is not set
> # CONFIG_PATA_NS87415 is not set
> # CONFIG_PATA_OLDPIIX is not set
> # CONFIG_PATA_OPTIDMA is not set
> # CONFIG_PATA_PDC2027X is not set
> # CONFIG_PATA_PDC_OLD is not set
> # CONFIG_PATA_RADISYS is not set
> # CONFIG_PATA_RDC is not set
> # CONFIG_PATA_SC1200 is not set
> # CONFIG_PATA_SCH is not set
> # CONFIG_PATA_SERVERWORKS is not set
> # CONFIG_PATA_SIL680 is not set
> # CONFIG_PATA_SIS is not set
> # CONFIG_PATA_TOSHIBA is not set
> # CONFIG_PATA_TRIFLEX is not set
> # CONFIG_PATA_VIA is not set
> # CONFIG_PATA_WINBOND is not set
> 
> #
> # PIO-only SFF controllers
> #
> # CONFIG_PATA_CMD640_PCI is not set
> # CONFIG_PATA_MPIIX is not set
> # CONFIG_PATA_NS87410 is not set
> # CONFIG_PATA_OPTI is not set
> # CONFIG_PATA_QDI is not set
> # CONFIG_PATA_RZ1000 is not set
> # CONFIG_PATA_WINBOND_VLB is not set
> 
> #
> # Generic fallback / legacy drivers
> #
> # CONFIG_ATA_GENERIC is not set
> # CONFIG_PATA_LEGACY is not set
> CONFIG_MD=y
> CONFIG_BLK_DEV_MD=m
> # CONFIG_MD_LINEAR is not set
> CONFIG_MD_RAID0=m
> CONFIG_MD_RAID1=m
> # CONFIG_MD_RAID10 is not set
> CONFIG_MD_RAID456=m
> # CONFIG_MD_MULTIPATH is not set
> # CONFIG_MD_FAULTY is not set
> CONFIG_BLK_DEV_DM=m
> # CONFIG_DM_DEBUG is not set
> CONFIG_DM_CRYPT=m
> CONFIG_DM_SNAPSHOT=m
> # CONFIG_DM_THIN_PROVISIONING is not set
> CONFIG_DM_MIRROR=m
> CONFIG_DM_RAID=m
> # CONFIG_DM_LOG_USERSPACE is not set
> CONFIG_DM_ZERO=m
> # CONFIG_DM_MULTIPATH is not set
> # CONFIG_DM_DELAY is not set
> CONFIG_DM_UEVENT=y
> # CONFIG_DM_FLAKEY is not set
> # CONFIG_TARGET_CORE is not set
> CONFIG_FUSION=y
> CONFIG_FUSION_SPI=y
> # CONFIG_FUSION_FC is not set
> # CONFIG_FUSION_SAS is not set
> CONFIG_FUSION_MAX_SGE=128
> CONFIG_FUSION_CTL=y
> CONFIG_FUSION_LOGGING=y
> 
> #
> # IEEE 1394 (FireWire) support
> #
> # CONFIG_FIREWIRE is not set
> # CONFIG_FIREWIRE_NOSY is not set
> # CONFIG_I2O is not set
> CONFIG_NETDEVICES=y
> CONFIG_NET_CORE=y
> CONFIG_BONDING=m
> # CONFIG_DUMMY is not set
> # CONFIG_EQUALIZER is not set
> # CONFIG_NET_FC is not set
> CONFIG_MII=m
> CONFIG_MACVLAN=m
> CONFIG_MACVTAP=m
> # CONFIG_NETCONSOLE is not set
> # CONFIG_NETPOLL is not set
> # CONFIG_NET_POLL_CONTROLLER is not set
> CONFIG_TUN=m
> CONFIG_VETH=m
> # CONFIG_ARCNET is not set
> 
> #
> # CAIF transport drivers
> #
> CONFIG_ETHERNET=y
> # CONFIG_NET_VENDOR_3COM is not set
> CONFIG_NET_VENDOR_ADAPTEC=y
> # CONFIG_ADAPTEC_STARFIRE is not set
> CONFIG_NET_VENDOR_ALTEON=y
> # CONFIG_ACENIC is not set
> CONFIG_NET_VENDOR_AMD=y
> # CONFIG_AMD8111_ETH is not set
> # CONFIG_LANCE is not set
> # CONFIG_PCNET32 is not set
> # CONFIG_DEPCA is not set
> # CONFIG_NI65 is not set
> CONFIG_NET_VENDOR_ATHEROS=y
> # CONFIG_ATL2 is not set
> # CONFIG_ATL1 is not set
> # CONFIG_ATL1E is not set
> # CONFIG_ATL1C is not set
> CONFIG_NET_VENDOR_BROADCOM=y
> # CONFIG_B44 is not set
> # CONFIG_BNX2 is not set
> # CONFIG_CNIC is not set
> # CONFIG_TIGON3 is not set
> # CONFIG_BNX2X is not set
> CONFIG_NET_VENDOR_BROCADE=y
> # CONFIG_BNA is not set
> CONFIG_NET_VENDOR_CHELSIO=y
> # CONFIG_CHELSIO_T1 is not set
> # CONFIG_CHELSIO_T3 is not set
> # CONFIG_CHELSIO_T4 is not set
> # CONFIG_CHELSIO_T4VF is not set
> CONFIG_NET_VENDOR_CIRRUS=y
> # CONFIG_CS89x0 is not set
> CONFIG_NET_VENDOR_CISCO=y
> # CONFIG_ENIC is not set
> # CONFIG_DNET is not set
> CONFIG_NET_VENDOR_DEC=y
> # CONFIG_EWRK3 is not set
> CONFIG_NET_TULIP=y
> # CONFIG_DE2104X is not set
> CONFIG_TULIP=y
> CONFIG_TULIP_MWI=y
> CONFIG_TULIP_MMIO=y
> CONFIG_TULIP_NAPI=y
> CONFIG_TULIP_NAPI_HW_MITIGATION=y
> # CONFIG_DE4X5 is not set
> # CONFIG_WINBOND_840 is not set
> # CONFIG_DM9102 is not set
> # CONFIG_ULI526X is not set
> CONFIG_NET_VENDOR_DLINK=y
> # CONFIG_DL2K is not set
> # CONFIG_SUNDANCE is not set
> CONFIG_NET_VENDOR_EMULEX=y
> # CONFIG_BE2NET is not set
> CONFIG_NET_VENDOR_EXAR=y
> # CONFIG_S2IO is not set
> # CONFIG_VXGE is not set
> CONFIG_NET_VENDOR_FUJITSU=y
> # CONFIG_AT1700 is not set
> # CONFIG_ETH16I is not set
> CONFIG_NET_VENDOR_HP=y
> # CONFIG_HP100 is not set
> CONFIG_NET_VENDOR_INTEL=y
> # CONFIG_E100 is not set
> # CONFIG_E1000 is not set
> # CONFIG_E1000E is not set
> # CONFIG_IGB is not set
> # CONFIG_IGBVF is not set
> # CONFIG_IXGB is not set
> # CONFIG_IXGBE is not set
> CONFIG_NET_VENDOR_I825XX=y
> # CONFIG_ELPLUS is not set
> # CONFIG_EL16 is not set
> # CONFIG_APRICOT is not set
> # CONFIG_EEXPRESS is not set
> # CONFIG_EEXPRESS_PRO is not set
> # CONFIG_LP486E is not set
> # CONFIG_NI52 is not set
> # CONFIG_ZNET is not set
> # CONFIG_IP1000 is not set
> # CONFIG_JME is not set
> CONFIG_NET_VENDOR_MARVELL=y
> # CONFIG_SKGE is not set
> # CONFIG_SKY2 is not set
> CONFIG_NET_VENDOR_MELLANOX=y
> # CONFIG_MLX4_EN is not set
> # CONFIG_MLX4_CORE is not set
> CONFIG_NET_VENDOR_MICREL=y
> # CONFIG_KS8842 is not set
> # CONFIG_KS8851_MLL is not set
> # CONFIG_KSZ884X_PCI is not set
> CONFIG_NET_VENDOR_MYRI=y
> # CONFIG_MYRI10GE is not set
> # CONFIG_FEALNX is not set
> CONFIG_NET_VENDOR_NATSEMI=y
> # CONFIG_NATSEMI is not set
> # CONFIG_NS83820 is not set
> CONFIG_NET_VENDOR_8390=y
> # CONFIG_EL2 is not set
> # CONFIG_AC3200 is not set
> # CONFIG_E2100 is not set
> # CONFIG_HPLAN_PLUS is not set
> # CONFIG_HPLAN is not set
> # CONFIG_NE2000 is not set
> # CONFIG_NE2K_PCI is not set
> # CONFIG_ULTRA is not set
> # CONFIG_WD80x3 is not set
> CONFIG_NET_VENDOR_NVIDIA=y
> # CONFIG_FORCEDETH is not set
> CONFIG_NET_VENDOR_OKI=y
> # CONFIG_PCH_GBE is not set
> # CONFIG_ETHOC is not set
> # CONFIG_NET_PACKET_ENGINE is not set
> CONFIG_NET_VENDOR_QLOGIC=y
> # CONFIG_QLA3XXX is not set
> # CONFIG_QLCNIC is not set
> # CONFIG_QLGE is not set
> # CONFIG_NETXEN_NIC is not set
> # CONFIG_NET_VENDOR_RACAL is not set
> CONFIG_NET_VENDOR_REALTEK=y
> # CONFIG_8139CP is not set
> # CONFIG_8139TOO is not set
> # CONFIG_R8169 is not set
> CONFIG_NET_VENDOR_RDC=y
> # CONFIG_R6040 is not set
> CONFIG_NET_VENDOR_SEEQ=y
> # CONFIG_SEEQ8005 is not set
> CONFIG_NET_VENDOR_SILAN=y
> # CONFIG_SC92031 is not set
> CONFIG_NET_VENDOR_SIS=y
> # CONFIG_SIS900 is not set
> # CONFIG_SIS190 is not set
> # CONFIG_SFC is not set
> CONFIG_NET_VENDOR_SMSC=y
> # CONFIG_SMC9194 is not set
> # CONFIG_EPIC100 is not set
> # CONFIG_SMSC9420 is not set
> CONFIG_NET_VENDOR_STMICRO=y
> # CONFIG_STMMAC_ETH is not set
> CONFIG_NET_VENDOR_SUN=y
> # CONFIG_HAPPYMEAL is not set
> # CONFIG_SUNGEM is not set
> # CONFIG_CASSINI is not set
> # CONFIG_NIU is not set
> CONFIG_NET_VENDOR_TEHUTI=y
> # CONFIG_TEHUTI is not set
> CONFIG_NET_VENDOR_TI=y
> # CONFIG_TLAN is not set
> CONFIG_NET_VENDOR_VIA=y
> # CONFIG_VIA_RHINE is not set
> # CONFIG_VIA_VELOCITY is not set
> # CONFIG_FDDI is not set
> # CONFIG_HIPPI is not set
> # CONFIG_NET_SB1000 is not set
> CONFIG_PHYLIB=m
> 
> #
> # MII PHY device drivers
> #
> CONFIG_MARVELL_PHY=m
> CONFIG_DAVICOM_PHY=m
> CONFIG_QSEMI_PHY=m
> CONFIG_LXT_PHY=m
> CONFIG_CICADA_PHY=m
> CONFIG_VITESSE_PHY=m
> CONFIG_SMSC_PHY=m
> CONFIG_BROADCOM_PHY=m
> CONFIG_ICPLUS_PHY=m
> CONFIG_REALTEK_PHY=m
> CONFIG_NATIONAL_PHY=m
> CONFIG_STE10XP=m
> CONFIG_LSI_ET1011C_PHY=m
> CONFIG_MICREL_PHY=m
> CONFIG_MDIO_BITBANG=m
> CONFIG_MDIO_GPIO=m
> CONFIG_PPP=m
> CONFIG_PPP_BSDCOMP=m
> CONFIG_PPP_DEFLATE=m
> CONFIG_PPP_FILTER=y
> CONFIG_PPP_MPPE=m
> # CONFIG_PPP_MULTILINK is not set
> CONFIG_PPPOE=m
> CONFIG_PPTP=m
> CONFIG_PPP_ASYNC=m
> CONFIG_PPP_SYNC_TTY=m
> # CONFIG_SLIP is not set
> CONFIG_SLHC=m
> # CONFIG_TR is not set
> # CONFIG_WLAN is not set
> 
> #
> # Enable WiMAX (Networking options) to see the WiMAX drivers
> #
> # CONFIG_WAN is not set
> # CONFIG_VMXNET3 is not set
> # CONFIG_ISDN is not set
> # CONFIG_PHONE is not set
> 
> #
> # Input device support
> #
> CONFIG_INPUT=y
> CONFIG_INPUT_FF_MEMLESS=m
> CONFIG_INPUT_POLLDEV=m
> CONFIG_INPUT_SPARSEKMAP=m
> 
> #
> # Userland interfaces
> #
> CONFIG_INPUT_MOUSEDEV=y
> # CONFIG_INPUT_MOUSEDEV_PSAUX is not set
> CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
> CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
> # CONFIG_INPUT_JOYDEV is not set
> CONFIG_INPUT_EVDEV=m
> # CONFIG_INPUT_EVBUG is not set
> 
> #
> # Input Device Drivers
> #
> CONFIG_INPUT_KEYBOARD=y
> # CONFIG_KEYBOARD_ADP5588 is not set
> # CONFIG_KEYBOARD_ADP5589 is not set
> CONFIG_KEYBOARD_ATKBD=y
> # CONFIG_KEYBOARD_QT1070 is not set
> # CONFIG_KEYBOARD_QT2160 is not set
> # CONFIG_KEYBOARD_LKKBD is not set
> # CONFIG_KEYBOARD_GPIO is not set
> # CONFIG_KEYBOARD_GPIO_POLLED is not set
> # CONFIG_KEYBOARD_TCA6416 is not set
> # CONFIG_KEYBOARD_MATRIX is not set
> # CONFIG_KEYBOARD_LM8323 is not set
> # CONFIG_KEYBOARD_MAX7359 is not set
> # CONFIG_KEYBOARD_MCS is not set
> # CONFIG_KEYBOARD_MPR121 is not set
> # CONFIG_KEYBOARD_NEWTON is not set
> # CONFIG_KEYBOARD_OPENCORES is not set
> # CONFIG_KEYBOARD_STOWAWAY is not set
> # CONFIG_KEYBOARD_SUNKBD is not set
> # CONFIG_KEYBOARD_XTKBD is not set
> CONFIG_INPUT_MOUSE=y
> CONFIG_MOUSE_PS2=m
> CONFIG_MOUSE_PS2_ALPS=y
> CONFIG_MOUSE_PS2_LOGIPS2PP=y
> CONFIG_MOUSE_PS2_SYNAPTICS=y
> CONFIG_MOUSE_PS2_TRACKPOINT=y
> # CONFIG_MOUSE_PS2_ELANTECH is not set
> # CONFIG_MOUSE_PS2_SENTELIC is not set
> # CONFIG_MOUSE_PS2_TOUCHKIT is not set
> # CONFIG_MOUSE_SERIAL is not set
> # CONFIG_MOUSE_INPORT is not set
> # CONFIG_MOUSE_LOGIBM is not set
> # CONFIG_MOUSE_PC110PAD is not set
> # CONFIG_MOUSE_VSXXXAA is not set
> # CONFIG_MOUSE_GPIO is not set
> # CONFIG_MOUSE_SYNAPTICS_I2C is not set
> # CONFIG_INPUT_JOYSTICK is not set
> # CONFIG_INPUT_TABLET is not set
> # CONFIG_INPUT_TOUCHSCREEN is not set
> CONFIG_INPUT_MISC=y
> # CONFIG_INPUT_AD714X is not set
> # CONFIG_INPUT_BMA150 is not set
> # CONFIG_INPUT_PCSPKR is not set
> # CONFIG_INPUT_MMA8450 is not set
> # CONFIG_INPUT_MPU3050 is not set
> # CONFIG_INPUT_KXTJ9 is not set
> CONFIG_INPUT_UINPUT=m
> # CONFIG_INPUT_PCF8574 is not set
> # CONFIG_INPUT_GPIO_ROTARY_ENCODER is not set
> # CONFIG_INPUT_ADXL34X is not set
> # CONFIG_INPUT_CMA3000 is not set
> 
> #
> # Hardware I/O ports
> #
> CONFIG_SERIO=y
> CONFIG_SERIO_I8042=y
> CONFIG_SERIO_SERPORT=m
> # CONFIG_SERIO_PCIPS2 is not set
> CONFIG_SERIO_LIBPS2=y
> # CONFIG_SERIO_RAW is not set
> # CONFIG_SERIO_ALTERA_PS2 is not set
> # CONFIG_SERIO_PS2MULT is not set
> # CONFIG_GAMEPORT is not set
> 
> #
> # Character devices
> #
> CONFIG_VT=y
> CONFIG_CONSOLE_TRANSLATIONS=y
> CONFIG_VT_CONSOLE=y
> CONFIG_HW_CONSOLE=y
> # CONFIG_VT_HW_CONSOLE_BINDING is not set
> CONFIG_UNIX98_PTYS=y
> CONFIG_DEVPTS_MULTIPLE_INSTANCES=y
> # CONFIG_LEGACY_PTYS is not set
> # CONFIG_SERIAL_NONSTANDARD is not set
> # CONFIG_NOZOMI is not set
> # CONFIG_N_GSM is not set
> # CONFIG_TRACE_SINK is not set
> # CONFIG_DEVKMEM is not set
> 
> #
> # Serial drivers
> #
> CONFIG_SERIAL_8250=m
> CONFIG_SERIAL_8250_PCI=m
> CONFIG_SERIAL_8250_PNP=m
> CONFIG_SERIAL_8250_NR_UARTS=4
> CONFIG_SERIAL_8250_RUNTIME_UARTS=4
> CONFIG_SERIAL_8250_EXTENDED=y
> # CONFIG_SERIAL_8250_MANY_PORTS is not set
> CONFIG_SERIAL_8250_SHARE_IRQ=y
> # CONFIG_SERIAL_8250_DETECT_IRQ is not set
> # CONFIG_SERIAL_8250_RSA is not set
> 
> #
> # Non-8250 serial port support
> #
> # CONFIG_SERIAL_MFD_HSU is not set
> CONFIG_SERIAL_CORE=m
> # CONFIG_SERIAL_JSM is not set
> # CONFIG_SERIAL_TIMBERDALE is not set
> # CONFIG_SERIAL_ALTERA_JTAGUART is not set
> # CONFIG_SERIAL_ALTERA_UART is not set
> # CONFIG_SERIAL_PCH_UART is not set
> # CONFIG_SERIAL_XILINX_PS_UART is not set
> # CONFIG_IPMI_HANDLER is not set
> CONFIG_HW_RANDOM=m
> # CONFIG_HW_RANDOM_TIMERIOMEM is not set
> # CONFIG_DTLK is not set
> # CONFIG_R3964 is not set
> # CONFIG_APPLICOM is not set
> # CONFIG_RAW_DRIVER is not set
> # CONFIG_TCG_TPM is not set
> CONFIG_DEVPORT=y
> # CONFIG_RAMOOPS is not set
> CONFIG_I2C=m
> CONFIG_I2C_BOARDINFO=y
> # CONFIG_I2C_COMPAT is not set
> CONFIG_I2C_CHARDEV=m
> CONFIG_I2C_MUX=m
> 
> #
> # Multiplexer I2C Chip support
> #
> CONFIG_I2C_MUX_GPIO=m
> CONFIG_I2C_MUX_PCA9541=m
> CONFIG_I2C_MUX_PCA954x=m
> CONFIG_I2C_HELPER_AUTO=y
> CONFIG_I2C_ALGOBIT=m
> CONFIG_I2C_ALGOPCA=m
> 
> #
> # I2C Hardware Bus support
> #
> 
> #
> # PC SMBus host controller drivers
> #
> CONFIG_I2C_ALI1535=m
> CONFIG_I2C_ALI1563=m
> CONFIG_I2C_ALI15X3=m
> CONFIG_I2C_AMD756=m
> CONFIG_I2C_AMD8111=m
> CONFIG_I2C_I801=m
> CONFIG_I2C_ISCH=m
> CONFIG_I2C_PIIX4=m
> CONFIG_I2C_NFORCE2=m
> CONFIG_I2C_SIS5595=m
> CONFIG_I2C_SIS630=m
> CONFIG_I2C_SIS96X=m
> CONFIG_I2C_VIA=m
> CONFIG_I2C_VIAPRO=m
> 
> #
> # I2C system bus drivers (mostly embedded / system-on-chip)
> #
> # CONFIG_I2C_DESIGNWARE_PCI is not set
> CONFIG_I2C_GPIO=m
> # CONFIG_I2C_INTEL_MID is not set
> # CONFIG_I2C_OCORES is not set
> # CONFIG_I2C_PCA_PLATFORM is not set
> # CONFIG_I2C_PXA_PCI is not set
> # CONFIG_I2C_SIMTEC is not set
> # CONFIG_I2C_XILINX is not set
> # CONFIG_I2C_EG20T is not set
> 
> #
> # External I2C/SMBus adapter drivers
> #
> # CONFIG_I2C_PARPORT_LIGHT is not set
> # CONFIG_I2C_TAOS_EVM is not set
> 
> #
> # Other I2C/SMBus bus drivers
> #
> # CONFIG_I2C_ELEKTOR is not set
> CONFIG_I2C_PCA_ISA=m
> # CONFIG_I2C_STUB is not set
> # CONFIG_I2C_DEBUG_CORE is not set
> # CONFIG_I2C_DEBUG_ALGO is not set
> # CONFIG_I2C_DEBUG_BUS is not set
> # CONFIG_SPI is not set
> 
> #
> # PPS support
> #
> # CONFIG_PPS is not set
> 
> #
> # PPS generators support
> #
> 
> #
> # PTP clock support
> #
> 
> #
> # Enable Device Drivers -> PPS to see the PTP clock options.
> #
> CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
> CONFIG_GPIOLIB=y
> # CONFIG_DEBUG_GPIO is not set
> # CONFIG_GPIO_SYSFS is not set
> CONFIG_GPIO_GENERIC=m
> CONFIG_GPIO_MAX730X=m
> 
> #
> # Memory mapped GPIO drivers:
> #
> CONFIG_GPIO_GENERIC_PLATFORM=m
> CONFIG_GPIO_IT8761E=m
> CONFIG_GPIO_VX855=m
> 
> #
> # I2C GPIO expanders:
> #
> CONFIG_GPIO_MAX7300=m
> CONFIG_GPIO_MAX732X=m
> CONFIG_GPIO_PCA953X=m
> CONFIG_GPIO_PCF857X=m
> CONFIG_GPIO_ADP5588=m
> 
> #
> # PCI GPIO expanders:
> #
> CONFIG_GPIO_BT8XX=m
> CONFIG_GPIO_ML_IOH=m
> CONFIG_GPIO_RDC321X=m
> 
> #
> # SPI GPIO expanders:
> #
> # CONFIG_GPIO_MCP23S08 is not set
> 
> #
> # AC97 GPIO expanders:
> #
> 
> #
> # MODULbus GPIO expanders:
> #
> # CONFIG_W1 is not set
> CONFIG_POWER_SUPPLY=m
> # CONFIG_POWER_SUPPLY_DEBUG is not set
> # CONFIG_PDA_POWER is not set
> # CONFIG_TEST_POWER is not set
> # CONFIG_BATTERY_DS2780 is not set
> # CONFIG_BATTERY_DS2782 is not set
> # CONFIG_BATTERY_BQ20Z75 is not set
> # CONFIG_BATTERY_BQ27x00 is not set
> # CONFIG_BATTERY_MAX17040 is not set
> # CONFIG_BATTERY_MAX17042 is not set
> # CONFIG_CHARGER_MAX8903 is not set
> CONFIG_CHARGER_GPIO=m
> CONFIG_HWMON=m
> CONFIG_HWMON_VID=m
> # CONFIG_HWMON_DEBUG_CHIP is not set
> 
> #
> # Native drivers
> #
> CONFIG_SENSORS_AD7414=m
> CONFIG_SENSORS_AD7418=m
> CONFIG_SENSORS_ADM1021=m
> CONFIG_SENSORS_ADM1025=m
> CONFIG_SENSORS_ADM1026=m
> CONFIG_SENSORS_ADM1029=m
> CONFIG_SENSORS_ADM1031=m
> CONFIG_SENSORS_ADM9240=m
> CONFIG_SENSORS_ADT7411=m
> CONFIG_SENSORS_ADT7462=m
> CONFIG_SENSORS_ADT7470=m
> CONFIG_SENSORS_ADT7475=m
> CONFIG_SENSORS_ASC7621=m
> CONFIG_SENSORS_ATXP1=m
> CONFIG_SENSORS_DS620=m
> CONFIG_SENSORS_DS1621=m
> CONFIG_SENSORS_I5K_AMB=m
> CONFIG_SENSORS_F71805F=m
> CONFIG_SENSORS_F71882FG=m
> CONFIG_SENSORS_F75375S=m
> CONFIG_SENSORS_G760A=m
> CONFIG_SENSORS_GL518SM=m
> CONFIG_SENSORS_GL520SM=m
> CONFIG_SENSORS_GPIO_FAN=m
> CONFIG_SENSORS_IT87=m
> CONFIG_SENSORS_JC42=m
> CONFIG_SENSORS_LINEAGE=m
> CONFIG_SENSORS_LM63=m
> CONFIG_SENSORS_LM73=m
> CONFIG_SENSORS_LM75=m
> CONFIG_SENSORS_LM77=m
> CONFIG_SENSORS_LM78=m
> CONFIG_SENSORS_LM80=m
> CONFIG_SENSORS_LM83=m
> CONFIG_SENSORS_LM85=m
> CONFIG_SENSORS_LM87=m
> CONFIG_SENSORS_LM90=m
> CONFIG_SENSORS_LM92=m
> CONFIG_SENSORS_LM93=m
> CONFIG_SENSORS_LTC4151=m
> CONFIG_SENSORS_LTC4215=m
> CONFIG_SENSORS_LTC4245=m
> CONFIG_SENSORS_LTC4261=m
> CONFIG_SENSORS_LM95241=m
> CONFIG_SENSORS_LM95245=m
> CONFIG_SENSORS_MAX16065=m
> CONFIG_SENSORS_MAX1619=m
> CONFIG_SENSORS_MAX1668=m
> CONFIG_SENSORS_MAX6639=m
> CONFIG_SENSORS_MAX6642=m
> CONFIG_SENSORS_MAX6650=m
> CONFIG_SENSORS_NTC_THERMISTOR=m
> CONFIG_SENSORS_PC87360=m
> CONFIG_SENSORS_PC87427=m
> CONFIG_SENSORS_PCF8591=m
> CONFIG_PMBUS=m
> CONFIG_SENSORS_PMBUS=m
> CONFIG_SENSORS_ADM1275=m
> CONFIG_SENSORS_LM25066=m
> CONFIG_SENSORS_LTC2978=m
> CONFIG_SENSORS_MAX16064=m
> CONFIG_SENSORS_MAX34440=m
> CONFIG_SENSORS_MAX8688=m
> CONFIG_SENSORS_UCD9000=m
> CONFIG_SENSORS_UCD9200=m
> CONFIG_SENSORS_ZL6100=m
> CONFIG_SENSORS_SHT15=m
> CONFIG_SENSORS_SHT21=m
> CONFIG_SENSORS_SIS5595=m
> CONFIG_SENSORS_SMM665=m
> CONFIG_SENSORS_DME1737=m
> CONFIG_SENSORS_EMC1403=m
> CONFIG_SENSORS_EMC2103=m
> CONFIG_SENSORS_EMC6W201=m
> CONFIG_SENSORS_SMSC47M1=m
> CONFIG_SENSORS_SMSC47M192=m
> CONFIG_SENSORS_SMSC47B397=m
> CONFIG_SENSORS_SCH56XX_COMMON=m
> CONFIG_SENSORS_SCH5627=m
> CONFIG_SENSORS_SCH5636=m
> CONFIG_SENSORS_ADS1015=m
> CONFIG_SENSORS_ADS7828=m
> CONFIG_SENSORS_AMC6821=m
> CONFIG_SENSORS_THMC50=m
> CONFIG_SENSORS_TMP102=m
> CONFIG_SENSORS_TMP401=m
> CONFIG_SENSORS_TMP421=m
> CONFIG_SENSORS_VIA686A=m
> CONFIG_SENSORS_VT1211=m
> CONFIG_SENSORS_VT8231=m
> CONFIG_SENSORS_W83781D=m
> CONFIG_SENSORS_W83791D=m
> CONFIG_SENSORS_W83792D=m
> CONFIG_SENSORS_W83793=m
> CONFIG_SENSORS_W83795=m
> # CONFIG_SENSORS_W83795_FANCTRL is not set
> CONFIG_SENSORS_W83L785TS=m
> CONFIG_SENSORS_W83L786NG=m
> CONFIG_SENSORS_W83627HF=m
> CONFIG_SENSORS_W83627EHF=m
> CONFIG_THERMAL=m
> CONFIG_THERMAL_HWMON=y
> # CONFIG_WATCHDOG is not set
> CONFIG_SSB_POSSIBLE=y
> 
> #
> # Sonics Silicon Backplane
> #
> # CONFIG_SSB is not set
> CONFIG_BCMA_POSSIBLE=y
> 
> #
> # Broadcom specific AMBA
> #
> # CONFIG_BCMA is not set
> 
> #
> # Multifunction device drivers
> #
> CONFIG_MFD_CORE=m
> # CONFIG_MFD_SM501 is not set
> # CONFIG_HTC_PASIC3 is not set
> # CONFIG_TPS6105X is not set
> # CONFIG_TPS65010 is not set
> # CONFIG_TPS6507X is not set
> # CONFIG_MFD_TMIO is not set
> # CONFIG_MFD_WM8400 is not set
> # CONFIG_MFD_PCF50633 is not set
> # CONFIG_ABX500_CORE is not set
> # CONFIG_MFD_TIMBERDALE is not set
> CONFIG_LPC_SCH=m
> CONFIG_MFD_RDC321X=m
> # CONFIG_MFD_JANZ_CMODIO is not set
> CONFIG_MFD_VX855=m
> # CONFIG_MFD_WL1273_CORE is not set
> # CONFIG_REGULATOR is not set
> # CONFIG_MEDIA_SUPPORT is not set
> 
> #
> # Graphics support
> #
> CONFIG_AGP=y
> CONFIG_VGA_ARB=y
> CONFIG_VGA_ARB_MAX_GPUS=1
> # CONFIG_DRM is not set
> # CONFIG_STUB_POULSBO is not set
> # CONFIG_VGASTATE is not set
> CONFIG_VIDEO_OUTPUT_CONTROL=m
> CONFIG_FB=y
> CONFIG_FIRMWARE_EDID=y
> CONFIG_FB_DDC=m
> # CONFIG_FB_BOOT_VESA_SUPPORT is not set
> CONFIG_FB_CFB_FILLRECT=y
> CONFIG_FB_CFB_COPYAREA=y
> CONFIG_FB_CFB_IMAGEBLIT=y
> # CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
> # CONFIG_FB_SYS_FILLRECT is not set
> # CONFIG_FB_SYS_COPYAREA is not set
> # CONFIG_FB_SYS_IMAGEBLIT is not set
> # CONFIG_FB_FOREIGN_ENDIAN is not set
> # CONFIG_FB_SYS_FOPS is not set
> # CONFIG_FB_WMT_GE_ROPS is not set
> # CONFIG_FB_SVGALIB is not set
> # CONFIG_FB_MACMODES is not set
> # CONFIG_FB_BACKLIGHT is not set
> # CONFIG_FB_MODE_HELPERS is not set
> CONFIG_FB_TILEBLITTING=y
> 
> #
> # Frame buffer hardware drivers
> #
> # CONFIG_FB_CIRRUS is not set
> # CONFIG_FB_PM2 is not set
> # CONFIG_FB_CYBER2000 is not set
> # CONFIG_FB_ASILIANT is not set
> # CONFIG_FB_IMSTT is not set
> # CONFIG_FB_TGA is not set
> # CONFIG_FB_UVESA is not set
> # CONFIG_FB_S1D13XXX is not set
> # CONFIG_FB_NVIDIA is not set
> # CONFIG_FB_RIVA is not set
> CONFIG_FB_MATROX=y
> CONFIG_FB_MATROX_MILLENIUM=y
> # CONFIG_FB_MATROX_MYSTIQUE is not set
> # CONFIG_FB_MATROX_G is not set
> CONFIG_FB_MATROX_I2C=m
> # CONFIG_FB_RADEON is not set
> # CONFIG_FB_ATY128 is not set
> # CONFIG_FB_ATY is not set
> # CONFIG_FB_S3 is not set
> # CONFIG_FB_SAVAGE is not set
> # CONFIG_FB_SIS is not set
> # CONFIG_FB_NEOMAGIC is not set
> # CONFIG_FB_KYRO is not set
> # CONFIG_FB_3DFX is not set
> # CONFIG_FB_VOODOO1 is not set
> # CONFIG_FB_VT8623 is not set
> # CONFIG_FB_TRIDENT is not set
> # CONFIG_FB_ARK is not set
> # CONFIG_FB_PM3 is not set
> # CONFIG_FB_CARMINE is not set
> # CONFIG_FB_TMIO is not set
> # CONFIG_FB_VIRTUAL is not set
> # CONFIG_FB_METRONOME is not set
> # CONFIG_FB_MB862XX is not set
> # CONFIG_FB_BROADSHEET is not set
> CONFIG_BACKLIGHT_LCD_SUPPORT=y
> CONFIG_LCD_CLASS_DEVICE=m
> CONFIG_LCD_PLATFORM=m
> CONFIG_BACKLIGHT_CLASS_DEVICE=m
> CONFIG_BACKLIGHT_GENERIC=m
> # CONFIG_BACKLIGHT_ADP8860 is not set
> # CONFIG_BACKLIGHT_ADP8870 is not set
> 
> #
> # Display device support
> #
> CONFIG_DISPLAY_SUPPORT=m
> 
> #
> # Display hardware drivers
> #
> 
> #
> # Console display driver support
> #
> CONFIG_VGA_CONSOLE=y
> CONFIG_VGACON_SOFT_SCROLLBACK=y
> CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
> # CONFIG_MDA_CONSOLE is not set
> CONFIG_DUMMY_CONSOLE=y
> CONFIG_FRAMEBUFFER_CONSOLE=y
> CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
> # CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
> CONFIG_FONTS=y
> # CONFIG_FONT_8x8 is not set
> CONFIG_FONT_8x16=y
> # CONFIG_FONT_6x11 is not set
> # CONFIG_FONT_7x14 is not set
> # CONFIG_FONT_PEARL_8x8 is not set
> # CONFIG_FONT_ACORN_8x8 is not set
> # CONFIG_FONT_MINI_4x6 is not set
> # CONFIG_FONT_SUN8x16 is not set
> # CONFIG_FONT_SUN12x22 is not set
> # CONFIG_FONT_10x18 is not set
> CONFIG_LOGO=y
> # CONFIG_LOGO_LINUX_MONO is not set
> # CONFIG_LOGO_LINUX_VGA16 is not set
> # CONFIG_LOGO_LINUX_CLUT224 is not set
> CONFIG_LOGO_DEC_CLUT224=y
> # CONFIG_SOUND is not set
> # CONFIG_HID_SUPPORT is not set
> # CONFIG_USB_SUPPORT is not set
> # CONFIG_UWB is not set
> # CONFIG_MMC is not set
> # CONFIG_MEMSTICK is not set
> CONFIG_NEW_LEDS=y
> CONFIG_LEDS_CLASS=y
> 
> #
> # LED drivers
> #
> # CONFIG_LEDS_LM3530 is not set
> # CONFIG_LEDS_PCA9532 is not set
> CONFIG_LEDS_GPIO=m
> # CONFIG_LEDS_LP3944 is not set
> # CONFIG_LEDS_LP5521 is not set
> # CONFIG_LEDS_LP5523 is not set
> # CONFIG_LEDS_PCA955X is not set
> # CONFIG_LEDS_BD2802 is not set
> # CONFIG_LEDS_LT3593 is not set
> CONFIG_LEDS_TRIGGERS=y
> 
> #
> # LED Triggers
> #
> CONFIG_LEDS_TRIGGER_TIMER=m
> CONFIG_LEDS_TRIGGER_HEARTBEAT=m
> CONFIG_LEDS_TRIGGER_BACKLIGHT=m
> CONFIG_LEDS_TRIGGER_GPIO=m
> CONFIG_LEDS_TRIGGER_DEFAULT_ON=m
> 
> #
> # iptables trigger is under Netfilter config (LED target)
> #
> # CONFIG_ACCESSIBILITY is not set
> # CONFIG_INFINIBAND is not set
> CONFIG_RTC_LIB=y
> CONFIG_RTC_CLASS=y
> # CONFIG_RTC_HCTOSYS is not set
> # CONFIG_RTC_DEBUG is not set
> 
> #
> # RTC interfaces
> #
> CONFIG_RTC_INTF_SYSFS=y
> CONFIG_RTC_INTF_PROC=y
> CONFIG_RTC_INTF_DEV=y
> # CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
> # CONFIG_RTC_DRV_TEST is not set
> 
> #
> # I2C RTC drivers
> #
> CONFIG_RTC_DRV_DS1307=m
> CONFIG_RTC_DRV_DS1374=m
> CONFIG_RTC_DRV_DS1672=m
> CONFIG_RTC_DRV_DS3232=m
> CONFIG_RTC_DRV_MAX6900=m
> CONFIG_RTC_DRV_RS5C372=m
> CONFIG_RTC_DRV_ISL1208=m
> CONFIG_RTC_DRV_ISL12022=m
> CONFIG_RTC_DRV_X1205=m
> CONFIG_RTC_DRV_PCF8563=m
> CONFIG_RTC_DRV_PCF8583=m
> CONFIG_RTC_DRV_M41T80=m
> # CONFIG_RTC_DRV_M41T80_WDT is not set
> CONFIG_RTC_DRV_BQ32K=m
> CONFIG_RTC_DRV_S35390A=m
> CONFIG_RTC_DRV_FM3130=m
> CONFIG_RTC_DRV_RX8581=m
> CONFIG_RTC_DRV_RX8025=m
> CONFIG_RTC_DRV_EM3027=m
> CONFIG_RTC_DRV_RV3029C2=m
> 
> #
> # SPI RTC drivers
> #
> 
> #
> # Platform RTC drivers
> #
> CONFIG_RTC_DRV_CMOS=m
> CONFIG_RTC_DRV_DS1286=m
> CONFIG_RTC_DRV_DS1511=m
> CONFIG_RTC_DRV_DS1553=m
> CONFIG_RTC_DRV_DS1742=m
> CONFIG_RTC_DRV_STK17TA8=m
> CONFIG_RTC_DRV_M48T86=m
> CONFIG_RTC_DRV_M48T35=m
> CONFIG_RTC_DRV_M48T59=m
> CONFIG_RTC_DRV_MSM6242=m
> CONFIG_RTC_DRV_BQ4802=m
> CONFIG_RTC_DRV_RP5C01=m
> CONFIG_RTC_DRV_V3020=m
> 
> #
> # on-CPU RTC drivers
> #
> CONFIG_DMADEVICES=y
> # CONFIG_DMADEVICES_DEBUG is not set
> 
> #
> # DMA Devices
> #
> CONFIG_TIMB_DMA=m
> CONFIG_DMA_ENGINE=y
> 
> #
> # DMA Clients
> #
> CONFIG_NET_DMA=y
> # CONFIG_ASYNC_TX_DMA is not set
> # CONFIG_DMATEST is not set
> # CONFIG_AUXDISPLAY is not set
> CONFIG_UIO=m
> # CONFIG_UIO_CIF is not set
> # CONFIG_UIO_PDRV is not set
> # CONFIG_UIO_PDRV_GENIRQ is not set
> # CONFIG_UIO_AEC is not set
> # CONFIG_UIO_SERCOS3 is not set
> # CONFIG_UIO_PCI_GENERIC is not set
> # CONFIG_UIO_NETX is not set
> 
> #
> # Virtio drivers
> #
> # CONFIG_VIRTIO_PCI is not set
> # CONFIG_VIRTIO_BALLOON is not set
> # CONFIG_VIRTIO_MMIO is not set
> # CONFIG_STAGING is not set
> 
> #
> # Hardware Spinlock drivers
> #
> CONFIG_I8253_LOCK=y
> CONFIG_CLKBLD_I8253=y
> CONFIG_IOMMU_SUPPORT=y
> # CONFIG_VIRT_DRIVERS is not set
> # CONFIG_PM_DEVFREQ is not set
> 
> #
> # File systems
> #
> CONFIG_EXT2_FS=m
> # CONFIG_EXT2_FS_XATTR is not set
> # CONFIG_EXT2_FS_XIP is not set
> CONFIG_EXT3_FS=m
> # CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
> # CONFIG_EXT3_FS_XATTR is not set
> CONFIG_EXT4_FS=y
> # CONFIG_EXT4_FS_XATTR is not set
> # CONFIG_EXT4_DEBUG is not set
> CONFIG_JBD=m
> CONFIG_JBD2=y
> CONFIG_REISERFS_FS=m
> # CONFIG_REISERFS_CHECK is not set
> # CONFIG_REISERFS_PROC_INFO is not set
> # CONFIG_REISERFS_FS_XATTR is not set
> CONFIG_JFS_FS=m
> # CONFIG_JFS_POSIX_ACL is not set
> # CONFIG_JFS_SECURITY is not set
> # CONFIG_JFS_DEBUG is not set
> # CONFIG_JFS_STATISTICS is not set
> CONFIG_XFS_FS=m
> # CONFIG_XFS_QUOTA is not set
> # CONFIG_XFS_POSIX_ACL is not set
> # CONFIG_XFS_RT is not set
> # CONFIG_XFS_DEBUG is not set
> # CONFIG_GFS2_FS is not set
> # CONFIG_OCFS2_FS is not set
> CONFIG_BTRFS_FS=m
> # CONFIG_BTRFS_FS_POSIX_ACL is not set
> # CONFIG_NILFS2_FS is not set
> CONFIG_FS_POSIX_ACL=y
> CONFIG_EXPORTFS=m
> CONFIG_FILE_LOCKING=y
> CONFIG_FSNOTIFY=y
> CONFIG_DNOTIFY=y
> CONFIG_INOTIFY_USER=y
> CONFIG_FANOTIFY=y
> # CONFIG_FANOTIFY_ACCESS_PERMISSIONS is not set
> # CONFIG_QUOTA is not set
> # CONFIG_QUOTACTL is not set
> CONFIG_AUTOFS4_FS=m
> CONFIG_FUSE_FS=m
> CONFIG_CUSE=m
> 
> #
> # Caches
> #
> CONFIG_FSCACHE=m
> # CONFIG_FSCACHE_STATS is not set
> # CONFIG_FSCACHE_HISTOGRAM is not set
> # CONFIG_FSCACHE_DEBUG is not set
> # CONFIG_FSCACHE_OBJECT_LIST is not set
> CONFIG_CACHEFILES=m
> # CONFIG_CACHEFILES_DEBUG is not set
> # CONFIG_CACHEFILES_HISTOGRAM is not set
> 
> #
> # CD-ROM/DVD Filesystems
> #
> CONFIG_ISO9660_FS=m
> CONFIG_JOLIET=y
> CONFIG_ZISOFS=y
> CONFIG_UDF_FS=m
> CONFIG_UDF_NLS=y
> 
> #
> # DOS/FAT/NT Filesystems
> #
> CONFIG_FAT_FS=m
> CONFIG_MSDOS_FS=m
> CONFIG_VFAT_FS=m
> CONFIG_FAT_DEFAULT_CODEPAGE=437
> CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
> # CONFIG_NTFS_FS is not set
> 
> #
> # Pseudo filesystems
> #
> CONFIG_PROC_FS=y
> # CONFIG_PROC_KCORE is not set
> CONFIG_PROC_SYSCTL=y
> CONFIG_PROC_PAGE_MONITOR=y
> CONFIG_SYSFS=y
> CONFIG_TMPFS=y
> # CONFIG_TMPFS_POSIX_ACL is not set
> # CONFIG_TMPFS_XATTR is not set
> # CONFIG_HUGETLB_PAGE is not set
> CONFIG_CONFIGFS_FS=m
> CONFIG_MISC_FILESYSTEMS=y
> # CONFIG_ADFS_FS is not set
> # CONFIG_AFFS_FS is not set
> # CONFIG_ECRYPT_FS is not set
> # CONFIG_HFS_FS is not set
> # CONFIG_HFSPLUS_FS is not set
> # CONFIG_BEFS_FS is not set
> # CONFIG_BFS_FS is not set
> # CONFIG_EFS_FS is not set
> # CONFIG_LOGFS is not set
> # CONFIG_CRAMFS is not set
> # CONFIG_SQUASHFS is not set
> # CONFIG_VXFS_FS is not set
> # CONFIG_MINIX_FS is not set
> # CONFIG_OMFS_FS is not set
> # CONFIG_HPFS_FS is not set
> # CONFIG_QNX4FS_FS is not set
> # CONFIG_ROMFS_FS is not set
> # CONFIG_PSTORE is not set
> # CONFIG_SYSV_FS is not set
> CONFIG_UFS_FS=m
> # CONFIG_UFS_FS_WRITE is not set
> # CONFIG_UFS_DEBUG is not set
> CONFIG_NETWORK_FILESYSTEMS=y
> CONFIG_NFS_FS=m
> CONFIG_NFS_V3=y
> # CONFIG_NFS_V3_ACL is not set
> CONFIG_NFS_V4=y
> # CONFIG_NFS_V4_1 is not set
> CONFIG_NFS_FSCACHE=y
> # CONFIG_NFS_USE_LEGACY_DNS is not set
> CONFIG_NFS_USE_KERNEL_DNS=y
> # CONFIG_NFS_USE_NEW_IDMAPPER is not set
> CONFIG_NFSD=m
> CONFIG_NFSD_V3=y
> # CONFIG_NFSD_V3_ACL is not set
> CONFIG_NFSD_V4=y
> CONFIG_LOCKD=m
> CONFIG_LOCKD_V4=y
> CONFIG_NFS_COMMON=y
> CONFIG_SUNRPC=m
> CONFIG_SUNRPC_GSS=m
> CONFIG_RPCSEC_GSS_KRB5=m
> # CONFIG_CEPH_FS is not set
> CONFIG_CIFS=m
> # CONFIG_CIFS_STATS is not set
> # CONFIG_CIFS_WEAK_PW_HASH is not set
> # CONFIG_CIFS_UPCALL is not set
> CONFIG_CIFS_XATTR=y
> CONFIG_CIFS_POSIX=y
> # CONFIG_CIFS_DEBUG2 is not set
> # CONFIG_CIFS_DFS_UPCALL is not set
> # CONFIG_CIFS_FSCACHE is not set
> # CONFIG_CIFS_ACL is not set
> # CONFIG_NCP_FS is not set
> # CONFIG_CODA_FS is not set
> # CONFIG_AFS_FS is not set
> 
> #
> # Partition Types
> #
> CONFIG_PARTITION_ADVANCED=y
> # CONFIG_ACORN_PARTITION is not set
> CONFIG_OSF_PARTITION=y
> # CONFIG_AMIGA_PARTITION is not set
> # CONFIG_ATARI_PARTITION is not set
> # CONFIG_MAC_PARTITION is not set
> CONFIG_MSDOS_PARTITION=y
> CONFIG_BSD_DISKLABEL=y
> # CONFIG_MINIX_SUBPARTITION is not set
> # CONFIG_SOLARIS_X86_PARTITION is not set
> # CONFIG_UNIXWARE_DISKLABEL is not set
> # CONFIG_LDM_PARTITION is not set
> # CONFIG_SGI_PARTITION is not set
> # CONFIG_ULTRIX_PARTITION is not set
> # CONFIG_SUN_PARTITION is not set
> # CONFIG_KARMA_PARTITION is not set
> CONFIG_EFI_PARTITION=y
> # CONFIG_SYSV68_PARTITION is not set
> CONFIG_NLS=m
> CONFIG_NLS_DEFAULT="utf8"
> CONFIG_NLS_CODEPAGE_437=m
> # CONFIG_NLS_CODEPAGE_737 is not set
> # CONFIG_NLS_CODEPAGE_775 is not set
> # CONFIG_NLS_CODEPAGE_850 is not set
> # CONFIG_NLS_CODEPAGE_852 is not set
> # CONFIG_NLS_CODEPAGE_855 is not set
> # CONFIG_NLS_CODEPAGE_857 is not set
> # CONFIG_NLS_CODEPAGE_860 is not set
> # CONFIG_NLS_CODEPAGE_861 is not set
> # CONFIG_NLS_CODEPAGE_862 is not set
> # CONFIG_NLS_CODEPAGE_863 is not set
> # CONFIG_NLS_CODEPAGE_864 is not set
> # CONFIG_NLS_CODEPAGE_865 is not set
> # CONFIG_NLS_CODEPAGE_866 is not set
> # CONFIG_NLS_CODEPAGE_869 is not set
> # CONFIG_NLS_CODEPAGE_936 is not set
> # CONFIG_NLS_CODEPAGE_950 is not set
> # CONFIG_NLS_CODEPAGE_932 is not set
> # CONFIG_NLS_CODEPAGE_949 is not set
> # CONFIG_NLS_CODEPAGE_874 is not set
> # CONFIG_NLS_ISO8859_8 is not set
> # CONFIG_NLS_CODEPAGE_1250 is not set
> # CONFIG_NLS_CODEPAGE_1251 is not set
> CONFIG_NLS_ASCII=m
> CONFIG_NLS_ISO8859_1=m
> # CONFIG_NLS_ISO8859_2 is not set
> # CONFIG_NLS_ISO8859_3 is not set
> # CONFIG_NLS_ISO8859_4 is not set
> # CONFIG_NLS_ISO8859_5 is not set
> # CONFIG_NLS_ISO8859_6 is not set
> # CONFIG_NLS_ISO8859_7 is not set
> # CONFIG_NLS_ISO8859_9 is not set
> # CONFIG_NLS_ISO8859_13 is not set
> # CONFIG_NLS_ISO8859_14 is not set
> CONFIG_NLS_ISO8859_15=m
> # CONFIG_NLS_KOI8_R is not set
> # CONFIG_NLS_KOI8_U is not set
> CONFIG_NLS_UTF8=m
> # CONFIG_DLM is not set
> 
> #
> # Kernel hacking
> #
> CONFIG_PRINTK_TIME=y
> CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
> # CONFIG_ENABLE_WARN_DEPRECATED is not set
> CONFIG_ENABLE_MUST_CHECK=y
> CONFIG_FRAME_WARN=2048
> # CONFIG_MAGIC_SYSRQ is not set
> CONFIG_STRIP_ASM_SYMS=y
> # CONFIG_UNUSED_SYMBOLS is not set
> # CONFIG_DEBUG_FS is not set
> # CONFIG_HEADERS_CHECK is not set
> # CONFIG_DEBUG_SECTION_MISMATCH is not set
> CONFIG_DEBUG_KERNEL=y
> # CONFIG_DEBUG_SHIRQ is not set
> # CONFIG_LOCKUP_DETECTOR is not set
> # CONFIG_HARDLOCKUP_DETECTOR is not set
> CONFIG_DETECT_HUNG_TASK=y
> CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
> # CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
> CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
> # CONFIG_SCHED_DEBUG is not set
> # CONFIG_SCHEDSTATS is not set
> CONFIG_TIMER_STATS=y
> # CONFIG_DEBUG_OBJECTS is not set
> # CONFIG_SLUB_DEBUG_ON is not set
> # CONFIG_SLUB_STATS is not set
> # CONFIG_DEBUG_RT_MUTEXES is not set
> # CONFIG_RT_MUTEX_TESTER is not set
> # CONFIG_DEBUG_SPINLOCK is not set
> # CONFIG_DEBUG_MUTEXES is not set
> # CONFIG_SPARSE_RCU_POINTER is not set
> # CONFIG_DEBUG_ATOMIC_SLEEP is not set
> # CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
> # CONFIG_DEBUG_STACK_USAGE is not set
> # CONFIG_DEBUG_KOBJECT is not set
> # CONFIG_DEBUG_INFO is not set
> # CONFIG_DEBUG_VM is not set
> # CONFIG_DEBUG_WRITECOUNT is not set
> CONFIG_DEBUG_MEMORY_INIT=y
> # CONFIG_DEBUG_LIST is not set
> # CONFIG_TEST_LIST_SORT is not set
> # CONFIG_DEBUG_SG is not set
> # CONFIG_DEBUG_NOTIFIERS is not set
> # CONFIG_DEBUG_CREDENTIALS is not set
> # CONFIG_BOOT_PRINTK_DELAY is not set
> # CONFIG_RCU_TORTURE_TEST is not set
> # CONFIG_BACKTRACE_SELF_TEST is not set
> # CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
> # CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
> # CONFIG_FAULT_INJECTION is not set
> CONFIG_SYSCTL_SYSCALL_CHECK=y
> # CONFIG_DEBUG_PAGEALLOC is not set
> # CONFIG_ATOMIC64_SELFTEST is not set
> # CONFIG_ASYNC_RAID6_TEST is not set
> # CONFIG_SAMPLES is not set
> # CONFIG_TEST_KSTRTOX is not set
> CONFIG_EARLY_PRINTK=y
> CONFIG_ALPHA_LEGACY_START_ADDRESS=y
> CONFIG_MATHEMU=y
> 
> #
> # Security options
> #
> CONFIG_KEYS=y
> # CONFIG_ENCRYPTED_KEYS is not set
> # CONFIG_KEYS_DEBUG_PROC_KEYS is not set
> # CONFIG_SECURITY_DMESG_RESTRICT is not set
> CONFIG_SECURITY=y
> # CONFIG_SECURITYFS is not set
> CONFIG_SECURITY_NETWORK=y
> # CONFIG_SECURITY_NETWORK_XFRM is not set
> # CONFIG_SECURITY_PATH is not set
> # CONFIG_SECURITY_SELINUX is not set
> # CONFIG_SECURITY_TOMOYO is not set
> # CONFIG_SECURITY_APPARMOR is not set
> # CONFIG_IMA is not set
> # CONFIG_EVM is not set
> CONFIG_DEFAULT_SECURITY_DAC=y
> CONFIG_DEFAULT_SECURITY=""
> CONFIG_XOR_BLOCKS=m
> CONFIG_ASYNC_CORE=m
> CONFIG_ASYNC_MEMCPY=m
> CONFIG_ASYNC_XOR=m
> CONFIG_ASYNC_PQ=m
> CONFIG_ASYNC_RAID6_RECOV=m
> CONFIG_CRYPTO=y
> 
> #
> # Crypto core or helper
> #
> # CONFIG_CRYPTO_FIPS is not set
> CONFIG_CRYPTO_ALGAPI=m
> CONFIG_CRYPTO_ALGAPI2=m
> CONFIG_CRYPTO_AEAD=m
> CONFIG_CRYPTO_AEAD2=m
> CONFIG_CRYPTO_BLKCIPHER=m
> CONFIG_CRYPTO_BLKCIPHER2=m
> CONFIG_CRYPTO_HASH=m
> CONFIG_CRYPTO_HASH2=m
> CONFIG_CRYPTO_RNG=m
> CONFIG_CRYPTO_RNG2=m
> CONFIG_CRYPTO_PCOMP=m
> CONFIG_CRYPTO_PCOMP2=m
> CONFIG_CRYPTO_MANAGER=m
> CONFIG_CRYPTO_MANAGER2=m
> # CONFIG_CRYPTO_USER is not set
> # CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
> CONFIG_CRYPTO_GF128MUL=m
> # CONFIG_CRYPTO_NULL is not set
> CONFIG_CRYPTO_WORKQUEUE=m
> CONFIG_CRYPTO_CRYPTD=m
> CONFIG_CRYPTO_AUTHENC=m
> # CONFIG_CRYPTO_TEST is not set
> 
> #
> # Authenticated Encryption with Associated Data
> #
> CONFIG_CRYPTO_CCM=m
> CONFIG_CRYPTO_GCM=m
> CONFIG_CRYPTO_SEQIV=m
> 
> #
> # Block modes
> #
> CONFIG_CRYPTO_CBC=m
> CONFIG_CRYPTO_CTR=m
> CONFIG_CRYPTO_CTS=m
> CONFIG_CRYPTO_ECB=m
> CONFIG_CRYPTO_LRW=m
> CONFIG_CRYPTO_PCBC=m
> CONFIG_CRYPTO_XTS=m
> 
> #
> # Hash modes
> #
> CONFIG_CRYPTO_HMAC=m
> CONFIG_CRYPTO_XCBC=m
> CONFIG_CRYPTO_VMAC=m
> 
> #
> # Digest
> #
> CONFIG_CRYPTO_CRC32C=m
> CONFIG_CRYPTO_GHASH=m
> CONFIG_CRYPTO_MD4=m
> CONFIG_CRYPTO_MD5=m
> CONFIG_CRYPTO_MICHAEL_MIC=m
> CONFIG_CRYPTO_RMD128=m
> CONFIG_CRYPTO_RMD160=m
> CONFIG_CRYPTO_RMD256=m
> CONFIG_CRYPTO_RMD320=m
> CONFIG_CRYPTO_SHA1=m
> CONFIG_CRYPTO_SHA256=m
> CONFIG_CRYPTO_SHA512=m
> CONFIG_CRYPTO_TGR192=m
> CONFIG_CRYPTO_WP512=m
> 
> #
> # Ciphers
> #
> CONFIG_CRYPTO_AES=m
> CONFIG_CRYPTO_ANUBIS=m
> CONFIG_CRYPTO_ARC4=m
> CONFIG_CRYPTO_BLOWFISH=m
> CONFIG_CRYPTO_BLOWFISH_COMMON=m
> CONFIG_CRYPTO_CAMELLIA=m
> CONFIG_CRYPTO_CAST5=m
> CONFIG_CRYPTO_CAST6=m
> CONFIG_CRYPTO_DES=m
> CONFIG_CRYPTO_FCRYPT=m
> CONFIG_CRYPTO_KHAZAD=m
> CONFIG_CRYPTO_SALSA20=m
> CONFIG_CRYPTO_SEED=m
> CONFIG_CRYPTO_SERPENT=m
> CONFIG_CRYPTO_TEA=m
> CONFIG_CRYPTO_TWOFISH=m
> CONFIG_CRYPTO_TWOFISH_COMMON=m
> 
> #
> # Compression
> #
> CONFIG_CRYPTO_DEFLATE=m
> CONFIG_CRYPTO_ZLIB=m
> CONFIG_CRYPTO_LZO=m
> 
> #
> # Random Number Generation
> #
> CONFIG_CRYPTO_ANSI_CPRNG=m
> CONFIG_CRYPTO_USER_API=m
> CONFIG_CRYPTO_USER_API_HASH=m
> CONFIG_CRYPTO_USER_API_SKCIPHER=m
> # CONFIG_CRYPTO_HW is not set
> # CONFIG_BINARY_PRINTF is not set
> 
> #
> # Library routines
> #
> CONFIG_RAID6_PQ=m
> CONFIG_BITREVERSE=y
> CONFIG_CRC_CCITT=m
> CONFIG_CRC16=y
> CONFIG_CRC_T10DIF=y
> CONFIG_CRC_ITU_T=m
> CONFIG_CRC32=y
> CONFIG_CRC7=m
> CONFIG_LIBCRC32C=m
> CONFIG_CRC8=m
> CONFIG_AUDIT_GENERIC=y
> CONFIG_ZLIB_INFLATE=y
> CONFIG_ZLIB_DEFLATE=m
> CONFIG_LZO_COMPRESS=m
> CONFIG_LZO_DECOMPRESS=y
> CONFIG_XZ_DEC=y
> CONFIG_XZ_DEC_X86=y
> CONFIG_XZ_DEC_POWERPC=y
> CONFIG_XZ_DEC_IA64=y
> CONFIG_XZ_DEC_ARM=y
> CONFIG_XZ_DEC_ARMTHUMB=y
> CONFIG_XZ_DEC_SPARC=y
> CONFIG_XZ_DEC_BCJ=y
> # CONFIG_XZ_DEC_TEST is not set
> CONFIG_DECOMPRESS_GZIP=y
> CONFIG_DECOMPRESS_BZIP2=y
> CONFIG_DECOMPRESS_LZMA=y
> CONFIG_DECOMPRESS_XZ=y
> CONFIG_DECOMPRESS_LZO=y
> CONFIG_HAS_IOMEM=y
> CONFIG_HAS_IOPORT=y
> CONFIG_HAS_DMA=y
> CONFIG_NLATTR=y
> CONFIG_AVERAGE=y
> CONFIG_CORDIC=m


--Kj7319i9nmIyA2yE
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="tsunami_modpost_fix.patch"

diff -uNr linux-3.3-rc3/arch/alpha/kernel/core_tsunami.c linux-3.3-rc3.patched/arch/alpha/kernel/core_tsunami.c
--- linux-3.3-rc3/arch/alpha/kernel/core_tsunami.c	2012-02-08 22:21:53.000000000 -0500
+++ linux-3.3-rc3.patched/arch/alpha/kernel/core_tsunami.c	2012-02-18 16:07:12.859977887 -0500
@@ -11,6 +11,7 @@
 #include <asm/core_tsunami.h>
 #undef __EXTERN_INLINE
 
+#include <linux/module.h>
 #include <linux/types.h>
 #include <linux/pci.h>
 #include <linux/sched.h>

--Kj7319i9nmIyA2yE--
