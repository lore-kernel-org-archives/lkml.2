Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932189Ab2JRKx4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 06:53:56 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:57458 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932147Ab2JRKxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 06:53:53 -0400
X-Authenticated: #19202771
X-Provags-ID: V01U2FsdGVkX1+CjSx5NeGCudk+N1qfJ+J+rWFNsjNOhpHzQ7s8/0
	oq0K7RkL9u6VNH
From: Dennis Schridde <devurandom@gmx.net>
To: linux-kernel@vger.kernel.org
Subject: WARNING: at /usr/src/linux-3.6.2/kernel/irq/irqdomain.c:743
Date: Thu, 18 Oct 2012 12:53:44 +0200
Message-ID: <2504590.Z6KV040SDr@ernie>
User-Agent: KMail/4.9.2 (Linux/3.6.2-gentoo; KDE/4.9.2; x86_64; ; )
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1606955.5DYn9EG7bF"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7Bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart1606955.5DYn9EG7bF
Content-Type: multipart/mixed; boundary="nextPart2710719.TDxhTB7GYc"
Content-Transfer-Encoding: 7Bit

This is a multi-part message in MIME format.

--nextPart2710719.TDxhTB7GYc
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Hello!

The kernel for my IBM Cell Broadband Engine cluster (IBM QS22 blades) does not 
boot anymore after I updated from 3.5.3-gentoo to 3.6.2-gentoo.

It issues a ton of warnings instead, which were not present earlier:
WARNING: at /usr/src/linux-3.6.2/kernel/irq/irqdomain.c:743

I can confirm the problem with a vanilla 3.6.2 kernel.

I attached several logs and configs:
* blade02-3.5.3-gentoo.boot-20121019.log
  Successful boot with the old 3.5.3-gentoo kernel
* blade02-3.6.2-gentoo.boot-20121019.log
  Failing boot with the new 3.6.2-gentoo kernel
* blade02-3.6.2-gentoo.config.diff
  Diff between 3.5.3-gentoo and 3.6.2-gentoo configs
* blade03-3.6.2.boot-20121019.log
  Failing boot with a vanilla Linux 3.6.2 kernel
* blade03-3.6.2.config
  Config of the vanilla Linux 3.6.2 kernel
  Same as for 3.6.2-gentoo, except that gentoo also has CONFIG_KCOPY=m

It would be nice if someone could help me debug the issue. If you need any 
more information, please do not hesitate to ask me.

Please CC me, as I am not on the list.

Best regards,
Dennis Schridde
--nextPart2710719.TDxhTB7GYc
Content-Disposition: attachment; filename="blade02-3.5.3-gentoo.boot-20121019.log"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-log; charset="UTF-8"; name="blade02-3.5.3-gentoo.boot-20121019.log"

Please wait, loading kernel...

 Bootloader 2.0
  Reading MAC address from device: 00:1a:64:b8:06:f2
  Requesting IP address via DHCP: 192.168.100.52
  Requesting file "/images/gentoo-ppc64/vmlinux-3.5.3-gentoo" via TFTP from 192.168.100.1
  Receiving data:  8615 KBytes
  TFTP: Received /images/gentoo-ppc64/vmlinux-3.5.3-gentoo (8615 KBytes)
   Elf64 kernel loaded...
Loading ramdisk...

 Bootloader 2.0
  Reading MAC address from device: 00:1a:64:b8:06:f2
  Requesting IP address via DHCP: 192.168.100.52
  Requesting file "/images/gentoo-ppc64/initramfs-3.5.3-gentoo.img" via TFTP from 192.168.100.1
  Receiving data:  6911 KBytes
  TFTP: Received /images/gentoo-ppc64/initramfs-3.5.3-gentoo.img (6911 KBytes)
ramdisk loaded at 03000000, size: 6911 Kbytes
OF stdout device is: /axon@10000000000/plb5/plb4/opb/serial@40000200
Preparing to boot Linux version 3.5.3-gentoo (root@blade00) (gcc version 4.6.3 (Gentoo 4.6.3 p1.6, pie-0.5.2) ) #2 SMP Sat Sep 15 15:34:12 CEST 2012
Detected machine type: 0000000000000500
command line:  ksdevice=bootif lang=  text rd.debug ip=meth0:dhcp ifname=meth0:00:1a:64:b8:06:f2 root=aufs:/run/rw:/run/ro rd.mount.early=/run/rw:tmpfs:size=1g rd.mount.early=/run/ro:nfs:192.168.100.1:/export/gentoo/root-ppc64
memory layout at init:
  memory_limit : 0000000000000000 (16 MB aligned)
  alloc_bottom : 00000000036c0000
  alloc_top    : 0000000030000000
  alloc_top_hi : 0000000200000000
  rmo_top      : 0000000030000000
  ram_top      : 0000000200000000
instantiating rtas at 0x000000002fff3000... done
boot cpu hw idx 0
starting cpu hw idx 2... done
copying OF device tree...
Building dt strings...
Building dt structure...
Device tree strings 0x00000000037c1000 -> 0x00000000037c18e3
Device tree struct  0x00000000037c2000 -> 0x00000000037cb000
[    0.000000] Using Cell machine description
[    0.000000] Found initrd at 0xc000000003000000:0xc0000000036bff0c
[    0.000000] bootconsole [udbg0] enabled
[    0.000000] CPU maps initialized for 2 threads per core
[    0.000000] Starting Linux PPC64 #2 SMP Sat Sep 15 15:34:12 CEST 2012
[    0.000000] -----------------------------------------------------
[    0.000000] ppc64_pft_size                = 0x0
[    0.000000] physicalMemorySize            = 0x200000000
[    0.000000] htab_address                  = 0xc000000078000000
[    0.000000] htab_hash_mask                = 0xfffff
[    0.000000] -----------------------------------------------------
[    0.000000] Linux version 3.5.3-gentoo (root@blade00) (gcc version 4.6.3 (Gentoo 4.6.3 p1.6, pie-0.5.2) ) #2 SMP Sat Sep 15 15:34:12 CEST 2012
[    0.000000] *** 0000 : CF000012
[    0.000000]
[    0.000000] *** 0000 : Setup Arch
[    0.000000] [boot]0012 Setup Arch
[    0.000000] mmio NVRAM, 1020k at 0x14502000000 mapped to d000080080008000
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00000000-0x1ffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00000000-0xffffffff]
[    0.000000]   node   1: [mem 0x100000000-0x1ffffffff]
[    0.000000] *** 0000 : CF000015
[    0.000000]
[    0.000000] *** 0000 : Setup Done
[    0.000000] [boot]0015 Setup Done
[    0.000000] PERCPU: Embedded 11 pages/cpu @c000000000700000 s13568 r0 d31488 u262144
[    0.000000] Built 2 zonelists in Node order, mobility grouping on.  Total pages: 2068480
[    0.000000] Policy zone: DMA
[    0.000000] Kernel command line:  ksdevice=bootif lang=  text rd.debug ip=meth0:dhcp ifname=meth0:00:1a:64:b8:06:f2 root=aufs:/run/rw:/run/ro rd.mount.early=/run/rw:tmpfs:size=1g rd.mount.early=/run/ro:nfs:192.168.100.1:/export/gentoo/root-ppc64
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] freeing bootmem node 0
[    0.000000] freeing bootmem node 1
[    0.000000] Memory: 8128036k/8388608k available (5880k kernel code, 260572k reserved, 648k data, 422k bss, 1996k init)
[    0.000000] SLUB: Genslabs=15, HWalign=128, Order=0-3, MinObjects=0, CPUs=4, Nodes=256
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:512 nr_irqs:512 16
[    0.000000] IIC for CPU 0 target id 0xe : /be@20000000000/interrupt-controller@508400
[    0.000000] IIC for CPU 1 target id 0xf : /be@20000000000/interrupt-controller@508400
[    0.000000] IIC for CPU 2 target id 0x1e : /be@20100000000/interrupt-controller@508400
[    0.000000] IIC for CPU 3 target id 0x1f : /be@20100000000/interrupt-controller@508400
[    0.000000] mpic: Setting up MPIC " MPIC     " version 1.2 at 0, max 4 CPUs
[    0.000000] mpic: ISU size: 128, shift: 7, mask: 7f
[    0.000000] mpic: Initializing for 128 sources
[    0.000000] /axon@10000000000/interrupt-controller: hooking up to IRQ 43
[    0.000000] mpic: Setting up MPIC " MPIC     " version 1.2 at 0, max 4 CPUs
[    0.000000] mpic: ISU size: 128, shift: 7, mask: 7f
[    0.000000] mpic: Initializing for 128 sources
[    0.000000] /axon@30000000000/interrupt-controller: hooking up to IRQ 299
[    0.000000] clocksource: timebase mult[2580c51e] shift[24] registered
[    0.000000] Console: colour dummy device 80x25
[    0.065082] pid_max: default: 32768 minimum: 301
[    0.095097] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.150699] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.198529] Mount-cache hash table entries: 256
[    0.227209] Brought up 4 CPUs
[    0.245125] devtmpfs: initialized
[    0.292527] NET: Registered protocol family 16
[    0.320399] IOMMU: Using strong ordering for fixed mapping
[    0.354879] IOMMU table initialized, virtual merging enabled
[    0.390640] IOMMU: Using strong ordering for fixed mapping
[    0.448052] PCI: Probing PCI hardware
[    0.482562] iommu: missing iommu for ? (node -1)
[    0.509807] iommu: missing iommu for ? (node -1)
[    0.538877] bio: create slab <bio-0> at 0
[    0.562774] vgaarb: loaded
[    0.578932] Switching to clocksource timebase
[    0.611043] NET: Registered protocol family 2
[    0.637366] IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.685064] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    0.737032] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.778961] TCP: Hash tables configured (established 524288 bind 65536)
[    0.818128] TCP: reno registered
[    0.837436] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[    0.874017] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
[    0.913369] Unpacking initramfs...
[    3.630888] Freeing initrd memory: 6912k freed
[    3.658329] iommu: missing iommu for ? (node -1)
[    3.685732] Setting up PCI bus /axon@10000000000/plb5/plb4/pcix@4000004600000000
[    3.729802] PCI host bridge /axon@10000000000/plb5/plb4/pcix@4000004600000000  ranges:
[    3.777166]   IO 0x0000014608000000..0x000001460800ffff -> 0x0000000000000000
[    3.819874]  MEM 0x0000014780000000..0x00000147bfffffff -> 0x0000000080000000
[    3.863104]  MEM 0x00000147c0000000..0x00000147ffffffff -> 0x00000000c0000000 Prefetch
[    3.910598] of-pci 14600000000.pcix: PCI host bridge to bus 0000:00
[    3.948005] pci_bus 0000:00: root bus resource [io  0x10000-0x1ffff] (bus address [0x0000-0xffff])
[    4.001647] pci_bus 0000:00: root bus resource [mem 0x14780000000-0x147bfffffff] (bus address [0x80000000-0xbfffffff])
[    4.065711] pci_bus 0000:00: root bus resource [mem 0x147c0000000-0x147ffffffff pref] (bus address [0xc0000000-0xffffffff])
[    4.134163] Setting up PCI bus /axon@10000000000/plb5/pciex@a00000a000000000
[    4.175943] PCI host bridge /axon@10000000000/plb5/pciex@a00000a000000000  ranges:
[    4.221243]   IO 0x000001a100000000..0x000001a10000ffff -> 0x0000000000000000
[    4.263948]  MEM 0x000001c080000000..0x000001c0bfffffff -> 0x0000000080000000
[    4.307178]  MEM 0x000001c0c0000000..0x000001c0ffffffff -> 0x00000000c0000000 Prefetch
[    4.354670] of-pci D18000002400.pciex: PCI host bridge to bus 0001:00
[    4.393116] pci_bus 0001:00: root bus resource [io  0x21000-0x30fff] (bus address [0x0000-0xffff])
[    4.446764] pci_bus 0001:00: root bus resource [mem 0x1c080000000-0x1c0bfffffff] (bus address [0x80000000-0xbfffffff])
[    4.510831] pci_bus 0001:00: root bus resource [mem 0x1c0c0000000-0x1c0ffffffff pref] (bus address [0xc0000000-0xffffffff])
[    4.578177] irq: no irq domain found for /axon@10000000000/plb5/pciex-utl@a00000a000004000 !
[    4.628518] pci 0001:00:00.0: PCI bridge to [bus 01-01]
[    4.659763] Setting up PCI bus /axon@10000000000/plb5/pciex@a00000a200000000
[    4.701732] PCI host bridge /axon@10000000000/plb5/pciex@a00000a200000000  ranges:
[    4.747035]   IO 0x000001a300000000..0x000001a30000ffff -> 0x0000000000000000
[    4.789747]  MEM 0x000001d080000000..0x000001d0bfffffff -> 0x0000000080000000
[    4.832975]  MEM 0x000001d0c0000000..0x000001d0ffffffff -> 0x00000000c0000000 Prefetch
[    4.880450] of-pci D18000002800.pciex: PCI host bridge to bus 0002:00
[    4.918915] pci_bus 0002:00: root bus resource [io  0x32000-0x41fff] (bus address [0x0000-0xffff])
[    4.972561] pci_bus 0002:00: root bus resource [mem 0x1d080000000-0x1d0bfffffff] (bus address [0x80000000-0xbfffffff])
[    5.036626] pci_bus 0002:00: root bus resource [mem 0x1d0c0000000-0x1d0ffffffff pref] (bus address [0xc0000000-0xffffffff])
[    5.103964] irq: no irq domain found for /axon@10000000000/plb5/pciex-utl@a00000a200004000 !
[    5.154314] pci 0002:00:00.0: PCI bridge to [bus 01-01]
[    5.185565] Setting up PCI bus /axon@30000000000/plb5/plb4/pcix@4000004600000000
[    5.229618] PCI host bridge /axon@30000000000/plb5/plb4/pcix@4000004600000000  ranges:
[    5.277000]   IO 0x0000034608000000..0x000003460800ffff -> 0x0000000000000000
[    5.319709]  MEM 0x0000034780000000..0x00000347bfffffff -> 0x0000000080000000
[    5.362943]  MEM 0x00000347c0000000..0x00000347ffffffff -> 0x00000000c0000000 Prefetch
[    5.410443] of-pci 34600000000.pcix: PCI host bridge to bus 0003:00
[    5.447836] pci_bus 0003:00: root bus resource [io  0x43000-0x52fff] (bus address [0x0000-0xffff])
[    5.501484] pci_bus 0003:00: root bus resource [mem 0x34780000000-0x347bfffffff] (bus address [0x80000000-0xbfffffff])
[    5.565548] pci_bus 0003:00: root bus resource [mem 0x347c0000000-0x347ffffffff pref] (bus address [0xc0000000-0xffffffff])
[    5.634262] Setting up PCI bus /axon@30000000000/plb5/pciex@a00000a000000000
[    5.676040] PCI host bridge /axon@30000000000/plb5/pciex@a00000a000000000  ranges:
[    5.721335]   IO 0x000003a100000000..0x000003a10000ffff -> 0x0000000000000000
[    5.764044]  MEM 0x000003c080000000..0x000003c0bfffffff -> 0x0000000080000000
[    5.807274]  MEM 0x000003c0c0000000..0x000003c0ffffffff -> 0x00000000c0000000 Prefetch
[    5.854761] of-pci D38000002400.pciex: PCI host bridge to bus 0004:00
[    5.893221] pci_bus 0004:00: root bus resource [io  0x54000-0x63fff] (bus address [0x0000-0xffff])
[    5.946861] pci_bus 0004:00: root bus resource [mem 0x3c080000000-0x3c0bfffffff] (bus address [0x80000000-0xbfffffff])
[    6.010926] pci_bus 0004:00: root bus resource [mem 0x3c0c0000000-0x3c0ffffffff pref] (bus address [0xc0000000-0xffffffff])
[    6.078315] irq: no irq domain found for /axon@30000000000/plb5/pciex-utl@a00000a000004000 !
[    6.128694] pci 0004:00:00.0: PCI bridge to [bus 01-01]
[    6.159917] Setting up PCI bus /axon@30000000000/plb5/pciex@a00000a200000000
[    6.201881] PCI host bridge /axon@30000000000/plb5/pciex@a00000a200000000  ranges:
[    6.247202]   IO 0x000003a300000000..0x000003a30000ffff -> 0x0000000000000000
[    6.289895]  MEM 0x000003d080000000..0x000003d0bfffffff -> 0x0000000080000000
[    6.333124]  MEM 0x000003d0c0000000..0x000003d0ffffffff -> 0x00000000c0000000 Prefetch
[    6.380616] of-pci D38000002800.pciex: PCI host bridge to bus 0005:00
[    6.419068] pci_bus 0005:00: root bus resource [io  0x65000-0x74fff] (bus address [0x0000-0xffff])
[    6.472710] pci_bus 0005:00: root bus resource [mem 0x3d080000000-0x3d0bfffffff] (bus address [0x80000000-0xbfffffff])
[    6.536775] pci_bus 0005:00: root bus resource [mem 0x3d0c0000000-0x3d0ffffffff pref] (bus address [0xc0000000-0xffffffff])
[    6.604166] irq: no irq domain found for /axon@30000000000/plb5/pciex-utl@a00000a200004000 !
[    6.656037] pci 0005:00:00.0: PCI bridge to [bus 01-01]
[    6.687460] iommu: missing iommu for ? (node -1)
[    6.722729] iommu: missing iommu for ? (node -1)
[    6.756146] msgmni has been set to 15888
[    6.779350] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    6.823454] io scheduler noop registered
[    6.846888] io scheduler deadline registered
[    6.872584] io scheduler cfq registered (default)
[    6.989555] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    7.027359] iommu: missing iommu for ? (node -1)
[    7.077190] serial8250.0: ttyS0 at MMIO 0x14540000200 (irq = 16) is a U6_16550A
[    7.120638] console [ttyS0] enabled, bootconsole disabled
[    7.120638] console [ttyS0] enabled, bootconsole disabled
[    7.206834] serial8250.0: ttyS1 at MMIO 0x14540000300 (irq = 17) is a U6_16550A
[    7.272372] serial8250.0: ttyS2 at MMIO 0x34540000200 (irq = 18) is a U6_16550A
[    7.337972] serial8250.0: ttyS3 at MMIO 0x34540000300 (irq = 19) is a U6_16550A
[    7.382519] mousedev: PS/2 mouse device common for all mice
[    7.415984] cpuidle: using governor ladder
[    7.440545] cpuidle: using governor menu
[    7.464476] TCP: cubic registered
[    7.484410] Key type dns_resolver registered
[    7.512348] /usr/src/linux-3.5.3-gentoo/drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
[    7.569219] Freeing unused kernel memory: 1996k freed

--nextPart2710719.TDxhTB7GYc
Content-Disposition: attachment; filename="blade03-3.6.2.config"
Content-Transfer-Encoding: 7Bit
Content-Type: application/x-config; name="blade03-3.6.2.config"

#
# Automatically generated file; DO NOT EDIT.
# Linux/powerpc 3.6.2 Kernel Configuration
#
CONFIG_PPC64=y

#
# Processor support
#
CONFIG_PPC_BOOK3S_64=y
# CONFIG_PPC_BOOK3E_64 is not set
# CONFIG_GENERIC_CPU is not set
CONFIG_CELL_CPU=y
# CONFIG_POWER4_CPU is not set
# CONFIG_POWER5_CPU is not set
# CONFIG_POWER6_CPU is not set
# CONFIG_POWER7_CPU is not set
CONFIG_PPC_BOOK3S=y
CONFIG_POWER3=y
CONFIG_POWER4=y
CONFIG_TUNE_CELL=y
CONFIG_PPC_FPU=y
CONFIG_ALTIVEC=y
CONFIG_VSX=y
# CONFIG_PPC_ICSWX is not set
CONFIG_PPC_STD_MMU=y
CONFIG_PPC_STD_MMU_64=y
# CONFIG_PPC_MM_SLICES is not set
CONFIG_VIRT_CPU_ACCOUNTING=y
CONFIG_PPC_HAVE_PMU_SUPPORT=y
CONFIG_SMP=y
CONFIG_NR_CPUS=32
CONFIG_64BIT=y
CONFIG_WORD_SIZE=64
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_MMU=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NR_IRQS=512
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_ARCH_HAS_ILOG2_U32=y
CONFIG_ARCH_HAS_ILOG2_U64=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_GENERIC_GPIO=y
CONFIG_ARCH_NO_VIRT_TO_BUS=y
CONFIG_PPC=y
CONFIG_EARLY_PRINTK=y
CONFIG_COMPAT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_SCHED_OMIT_FRAME_POINTER=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_PPC_OF=y
CONFIG_PPC_UDBG_16550=y
# CONFIG_GENERIC_TBSYNC is not set
CONFIG_AUDIT_ARCH=y
CONFIG_GENERIC_BUG=y
# CONFIG_EPAPR_BOOT is not set
# CONFIG_DEFAULT_UIMAGE is not set
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
# CONFIG_PPC_DCR_NATIVE is not set
CONFIG_PPC_DCR_MMIO=y
CONFIG_PPC_DCR=y
CONFIG_PPC_OF_PLATFORM_PCI=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_HAVE_IRQ_WORK=y

#
# General setup
#
# CONFIG_EXPERIMENTAL is not set
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
CONFIG_FHANDLE=y
# CONFIG_TASKSTATS is not set
# CONFIG_AUDIT is not set
CONFIG_HAVE_GENERIC_HARDIRQS=y

#
# IRQ subsystem
#
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_IRQ_SHOW_LEVEL=y
CONFIG_IRQ_EDGE_EOI_HANDLER=y
CONFIG_IRQ_DOMAIN=y
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_GENERIC_CMOS_UPDATE=y

#
# Timers subsystem
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_FANOUT=64
CONFIG_RCU_FANOUT_LEAF=16
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_RCU_FAST_NO_HZ is not set
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_IKCONFIG=m
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=17
# CONFIG_CGROUPS is not set
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_IPC_NS=y
CONFIG_PID_NS=y
CONFIG_NET_NS=y
# CONFIG_SCHED_AUTOGROUP is not set
# CONFIG_SYSFS_DEPRECATED is not set
# CONFIG_RELAY is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
# CONFIG_EXPERT is not set
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_KALLSYMS=y
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
# CONFIG_EMBEDDED is not set
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
# CONFIG_PERF_EVENTS is not set
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_PROFILING is not set
CONFIG_HAVE_OPROFILE=y
# CONFIG_KPROBES is not set
CONFIG_JUMP_LABEL=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_HAVE_SYSCALL_WRAPPERS=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
CONFIG_GENERIC_SMP_IDLE_THREAD=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y
CONFIG_HAVE_RCU_TABLE_FREE=y
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
CONFIG_ARCH_WANT_IPC_PARSE_VERSION=y
CONFIG_ARCH_WANT_COMPAT_IPC_PARSE_VERSION=y
CONFIG_ARCH_WANT_OLD_COMPAT_IPC=y

#
# GCOV-based kernel profiling
#
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
CONFIG_MODVERSIONS=y
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
# CONFIG_BLK_DEV_BSGLIB is not set
# CONFIG_BLK_DEV_INTEGRITY is not set

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_BLOCK_COMPAT=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
# CONFIG_INLINE_SPIN_TRYLOCK is not set
# CONFIG_INLINE_SPIN_TRYLOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK is not set
# CONFIG_INLINE_SPIN_LOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK_IRQ is not set
# CONFIG_INLINE_SPIN_LOCK_IRQSAVE is not set
# CONFIG_INLINE_SPIN_UNLOCK_BH is not set
CONFIG_INLINE_SPIN_UNLOCK_IRQ=y
# CONFIG_INLINE_SPIN_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_READ_TRYLOCK is not set
# CONFIG_INLINE_READ_LOCK is not set
# CONFIG_INLINE_READ_LOCK_BH is not set
# CONFIG_INLINE_READ_LOCK_IRQ is not set
# CONFIG_INLINE_READ_LOCK_IRQSAVE is not set
CONFIG_INLINE_READ_UNLOCK=y
# CONFIG_INLINE_READ_UNLOCK_BH is not set
CONFIG_INLINE_READ_UNLOCK_IRQ=y
# CONFIG_INLINE_READ_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_WRITE_TRYLOCK is not set
# CONFIG_INLINE_WRITE_LOCK is not set
# CONFIG_INLINE_WRITE_LOCK_BH is not set
# CONFIG_INLINE_WRITE_LOCK_IRQ is not set
# CONFIG_INLINE_WRITE_LOCK_IRQSAVE is not set
CONFIG_INLINE_WRITE_UNLOCK=y
# CONFIG_INLINE_WRITE_UNLOCK_BH is not set
CONFIG_INLINE_WRITE_UNLOCK_IRQ=y
# CONFIG_INLINE_WRITE_UNLOCK_IRQRESTORE is not set
CONFIG_MUTEX_SPIN_ON_OWNER=y
# CONFIG_FREEZER is not set
CONFIG_PPC_MSI_BITMAP=y
# CONFIG_PPC_XICS is not set
# CONFIG_PPC_ICP_NATIVE is not set
# CONFIG_PPC_ICP_HV is not set
# CONFIG_PPC_ICS_RTAS is not set
# CONFIG_GE_FPGA is not set

#
# Platform support
#
# CONFIG_PPC_POWERNV is not set
# CONFIG_PPC_PSERIES is not set
# CONFIG_PPC_PMAC is not set
# CONFIG_PPC_MAPLE is not set
# CONFIG_PPC_PASEMI is not set
# CONFIG_PPC_PS3 is not set
CONFIG_PPC_CELL=y
CONFIG_PPC_CELL_COMMON=y
CONFIG_PPC_CELL_NATIVE=y
CONFIG_PPC_IBM_CELL_BLADE=y
# CONFIG_PPC_CELLEB is not set
# CONFIG_PPC_CELL_QPACE is not set
CONFIG_AXON_MSI=y

#
# Cell Broadband Engine options
#
CONFIG_SPU_FS=y
CONFIG_SPU_BASE=y
CONFIG_CBE_RAS=y
CONFIG_PPC_IBM_CELL_RESETBUTTON=y
CONFIG_CBE_THERM=y
CONFIG_CBE_CPUFREQ=y
CONFIG_CBE_CPUFREQ_SPU_GOVERNOR=y
# CONFIG_PQ2ADS is not set
# CONFIG_PPC_WSP is not set
# CONFIG_KVM_GUEST is not set
# CONFIG_EPAPR_PARAVIRT is not set
CONFIG_PPC_NATIVE=y
CONFIG_PPC_OF_BOOT_TRAMPOLINE=y
CONFIG_UDBG_RTAS_CONSOLE=y
# CONFIG_IPIC is not set
CONFIG_MPIC=y
# CONFIG_PPC_EPAPR_HV_PIC is not set
# CONFIG_MPIC_WEIRD is not set
CONFIG_MPIC_MSGR=y
# CONFIG_PPC_I8259 is not set
# CONFIG_U3_DART is not set
CONFIG_PPC_RTAS=y
# CONFIG_RTAS_ERROR_LOGGING is not set
# CONFIG_PPC_RTAS_DAEMON is not set
CONFIG_RTAS_PROC=y
CONFIG_RTAS_FLASH=m
CONFIG_MMIO_NVRAM=y
# CONFIG_MPIC_U3_HT_IRQS is not set
# CONFIG_PPC_MPC106 is not set
# CONFIG_PPC_970_NAP is not set
# CONFIG_PPC_P7_NAP is not set
CONFIG_PPC_INDIRECT_IO=y
CONFIG_PPC_INDIRECT_PIO=y
CONFIG_PPC_INDIRECT_MMIO=y
CONFIG_PPC_IO_WORKAROUNDS=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_STAT=m
# CONFIG_CPU_FREQ_STAT_DETAILS is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_GOV_CONSERVATIVE is not set

#
# PowerPC CPU frequency scaling drivers
#

#
# CPU Frequency drivers
#

#
# CPUIdle driver
#
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
CONFIG_AXON_RAM=m
# CONFIG_FSL_ULI1575 is not set
CONFIG_SIMPLE_GPIO=y

#
# Kernel options
#
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
CONFIG_SCHED_HRTICK=y
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=m
CONFIG_IOMMU_HELPER=y
CONFIG_SWIOTLB=y
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_HAS_WALK_MEMORY=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y
# CONFIG_CRASH_DUMP is not set
CONFIG_IRQ_ALL_CPUS=y
CONFIG_NUMA=y
CONFIG_NODES_SHIFT=8
CONFIG_MAX_ACTIVE_REGIONS=256
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_SYS_SUPPORTS_HUGETLBFS=y
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_NEED_MULTIPLE_NODES=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_VMEMMAP=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_MEMORY_ISOLATION=y
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
# CONFIG_MEMORY_HOTREMOVE is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_CROSS_MEMORY_ATTACH=y
CONFIG_CLEANCACHE=y
CONFIG_FRONTSWAP=y
CONFIG_ARCH_MEMORY_PROBE=y
CONFIG_NODES_SPAN_OTHER_NODES=y
# CONFIG_PPC_HAS_HASH_64K is not set
CONFIG_PPC_4K_PAGES=y
# CONFIG_PPC_64K_PAGES is not set
CONFIG_FORCE_MAX_ZONEORDER=13
# CONFIG_SCHED_SMT is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_EXTRA_TARGETS=""
# CONFIG_HIBERNATION is not set
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
CONFIG_SECCOMP=y
CONFIG_ISA_DMA_API=y

#
# Bus options
#
CONFIG_ZONE_DMA=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_GENERIC_ISA_DMA=y
# CONFIG_PPC_INDIRECT_PCI is not set
CONFIG_PCI=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCI_SYSCALL=y
CONFIG_PCIEPORTBUS=y
CONFIG_PCIEAER=y
# CONFIG_PCIE_ECRC is not set
# CONFIG_PCIEAER_INJECT is not set
CONFIG_PCIEASPM=y
# CONFIG_PCIEASPM_DEBUG is not set
CONFIG_PCIEASPM_DEFAULT=y
# CONFIG_PCIEASPM_POWERSAVE is not set
# CONFIG_PCIEASPM_PERFORMANCE is not set
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
CONFIG_PCI_REALLOC_ENABLE_AUTO=y
# CONFIG_PCI_STUB is not set
# CONFIG_PCI_IOV is not set
# CONFIG_PCI_PRI is not set
# CONFIG_PCI_PASID is not set
# CONFIG_PCCARD is not set
# CONFIG_HOTPLUG_PCI is not set
# CONFIG_HAS_RAPIDIO is not set
# CONFIG_RAPIDIO is not set
CONFIG_NONSTATIC_KERNEL=y
CONFIG_RELOCATABLE=y
CONFIG_PAGE_OFFSET=0xc000000000000000
CONFIG_KERNEL_START=0xc000000000000000
CONFIG_PHYSICAL_START=0x00000000
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=m
CONFIG_UNIX=m
# CONFIG_UNIX_DIAG is not set
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=m
CONFIG_XFRM_USER=m
# CONFIG_NET_KEY is not set
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
# CONFIG_IP_ADVANCED_ROUTER is not set
# CONFIG_IP_PNP is not set
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE_DEMUX is not set
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
CONFIG_INET_LRO=m
# CONFIG_INET_DIAG is not set
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_IPV6=m
# CONFIG_IPV6_PRIVACY is not set
# CONFIG_IPV6_ROUTER_PREF is not set
# CONFIG_INET6_AH is not set
# CONFIG_INET6_ESP is not set
# CONFIG_INET6_IPCOMP is not set
# CONFIG_INET6_XFRM_TUNNEL is not set
# CONFIG_INET6_TUNNEL is not set
# CONFIG_INET6_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET6_XFRM_MODE_TUNNEL is not set
# CONFIG_INET6_XFRM_MODE_BEET is not set
# CONFIG_IPV6_SIT is not set
# CONFIG_IPV6_TUNNEL is not set
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
CONFIG_DNS_RESOLVER=y
# CONFIG_BATMAN_ADV is not set
# CONFIG_OPENVSWITCH is not set
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
CONFIG_BQL=y
# CONFIG_BPF_JIT is not set

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
CONFIG_NET_9P=m
CONFIG_NET_9P_DEBUG=y
# CONFIG_CAIF is not set
CONFIG_HAVE_BPF_JIT=y

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
# CONFIG_CONNECTOR is not set
# CONFIG_MTD is not set
CONFIG_DTC=y
CONFIG_OF=y

#
# Device Tree and Open Firmware support
#
# CONFIG_PROC_DEVICETREE is not set
# CONFIG_OF_SELFTEST is not set
CONFIG_OF_FLATTREE=y
CONFIG_OF_EARLY_FLATTREE=y
CONFIG_OF_ADDRESS=y
CONFIG_OF_IRQ=y
CONFIG_OF_DEVICE=y
CONFIG_OF_NET=y
CONFIG_OF_MDIO=y
CONFIG_OF_PCI=y
CONFIG_OF_PCI_IRQ=y
# CONFIG_PARPORT is not set
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=m
CONFIG_BLK_DEV_LOOP_MIN_COUNT=8
# CONFIG_BLK_DEV_CRYPTOLOOP is not set

#
# DRBD disabled because PROC_FS, INET or CONNECTOR not selected
#
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_NVME is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
# CONFIG_BLK_DEV_RAM is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_BLK_DEV_HD is not set

#
# Misc devices
#
# CONFIG_SENSORS_LIS3LV02D is not set
# CONFIG_PHANTOM is not set
# CONFIG_INTEL_MID_PTI is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_HP_ILO is not set
# CONFIG_PCH_PHUB is not set

#
# EEPROM support
#
# CONFIG_EEPROM_93CX6 is not set
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set

#
# Altera FPGA firmware download module
#
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=m
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=m
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_NETLINK is not set
# CONFIG_SCSI_PROC_FS is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=m
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=m
# CONFIG_BLK_DEV_SR_VENDOR is not set
CONFIG_CHR_DEV_SG=m
# CONFIG_CHR_DEV_SCH is not set
# CONFIG_SCSI_MULTI_LUN is not set
CONFIG_SCSI_CONSTANTS=y
# CONFIG_SCSI_LOGGING is not set
CONFIG_SCSI_SCAN_ASYNC=y

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
# CONFIG_ATA is not set
# CONFIG_MD is not set
# CONFIG_TARGET_CORE is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_NET_CORE=y
# CONFIG_BONDING is not set
# CONFIG_DUMMY is not set
# CONFIG_EQUALIZER is not set
# CONFIG_NET_FC is not set
# CONFIG_MII is not set
# CONFIG_NETCONSOLE is not set
# CONFIG_NETPOLL is not set
# CONFIG_NET_POLL_CONTROLLER is not set
# CONFIG_TUN is not set
# CONFIG_VETH is not set
# CONFIG_ARCNET is not set

#
# CAIF transport drivers
#
CONFIG_ETHERNET=y
# CONFIG_NET_VENDOR_3COM is not set
# CONFIG_NET_VENDOR_ADAPTEC is not set
# CONFIG_NET_VENDOR_ALTEON is not set
# CONFIG_NET_VENDOR_AMD is not set
# CONFIG_NET_VENDOR_ATHEROS is not set
CONFIG_NET_VENDOR_BROADCOM=y
# CONFIG_B44 is not set
# CONFIG_BNX2 is not set
# CONFIG_CNIC is not set
CONFIG_TIGON3=m
# CONFIG_BNX2X is not set
# CONFIG_NET_VENDOR_BROCADE is not set
# CONFIG_NET_CALXEDA_XGMAC is not set
# CONFIG_NET_VENDOR_CHELSIO is not set
# CONFIG_NET_VENDOR_CISCO is not set
# CONFIG_DNET is not set
# CONFIG_NET_VENDOR_DEC is not set
# CONFIG_NET_VENDOR_DLINK is not set
# CONFIG_NET_VENDOR_EMULEX is not set
# CONFIG_NET_VENDOR_EXAR is not set
# CONFIG_NET_VENDOR_HP is not set
CONFIG_NET_VENDOR_IBM=y
CONFIG_IBM_EMAC=m
CONFIG_IBM_EMAC_RXB=128
CONFIG_IBM_EMAC_TXB=64
CONFIG_IBM_EMAC_POLL_WEIGHT=32
CONFIG_IBM_EMAC_RX_COPY_THRESHOLD=256
CONFIG_IBM_EMAC_RX_SKB_HEADROOM=0
# CONFIG_IBM_EMAC_DEBUG is not set
CONFIG_IBM_EMAC_ZMII=y
CONFIG_IBM_EMAC_RGMII=y
CONFIG_IBM_EMAC_TAH=y
CONFIG_IBM_EMAC_EMAC4=y
# CONFIG_IBM_EMAC_NO_FLOW_CTRL is not set
# CONFIG_IBM_EMAC_MAL_CLR_ICINTSTAT is not set
# CONFIG_IBM_EMAC_MAL_COMMON_ERR is not set
# CONFIG_NET_VENDOR_INTEL is not set
# CONFIG_JME is not set
# CONFIG_NET_VENDOR_MARVELL is not set
# CONFIG_NET_VENDOR_MELLANOX is not set
# CONFIG_NET_VENDOR_MICREL is not set
# CONFIG_NET_VENDOR_MYRI is not set
# CONFIG_FEALNX is not set
# CONFIG_NET_VENDOR_NATSEMI is not set
# CONFIG_NET_VENDOR_NVIDIA is not set
# CONFIG_NET_VENDOR_OKI is not set
# CONFIG_ETHOC is not set
# CONFIG_NET_PACKET_ENGINE is not set
# CONFIG_NET_VENDOR_QLOGIC is not set
# CONFIG_NET_VENDOR_REALTEK is not set
# CONFIG_NET_VENDOR_RDC is not set
# CONFIG_NET_VENDOR_SIS is not set
# CONFIG_SFC is not set
# CONFIG_NET_VENDOR_SMSC is not set
# CONFIG_NET_VENDOR_STMICRO is not set
# CONFIG_NET_VENDOR_SUN is not set
# CONFIG_NET_VENDOR_TEHUTI is not set
# CONFIG_NET_VENDOR_TI is not set
# CONFIG_NET_VENDOR_TOSHIBA is not set
# CONFIG_NET_VENDOR_VIA is not set
# CONFIG_NET_VENDOR_WIZNET is not set
# CONFIG_NET_VENDOR_XILINX is not set
# CONFIG_FDDI is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
# CONFIG_AMD_PHY is not set
# CONFIG_MARVELL_PHY is not set
# CONFIG_DAVICOM_PHY is not set
# CONFIG_QSEMI_PHY is not set
# CONFIG_LXT_PHY is not set
# CONFIG_CICADA_PHY is not set
# CONFIG_VITESSE_PHY is not set
# CONFIG_SMSC_PHY is not set
# CONFIG_BROADCOM_PHY is not set
# CONFIG_BCM87XX_PHY is not set
# CONFIG_ICPLUS_PHY is not set
# CONFIG_REALTEK_PHY is not set
# CONFIG_NATIONAL_PHY is not set
# CONFIG_STE10XP is not set
# CONFIG_LSI_ET1011C_PHY is not set
# CONFIG_MICREL_PHY is not set
# CONFIG_FIXED_PHY is not set
# CONFIG_MDIO_BITBANG is not set
# CONFIG_MDIO_BUS_MUX_GPIO is not set
# CONFIG_PPP is not set
# CONFIG_SLIP is not set

#
# USB Network Adapters
#
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_USBNET is not set
# CONFIG_USB_IPHETH is not set
# CONFIG_WLAN is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#
# CONFIG_WAN is not set
# CONFIG_VMXNET3 is not set
# CONFIG_ISDN is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
# CONFIG_INPUT_POLLDEV is not set
# CONFIG_INPUT_SPARSEKMAP is not set
# CONFIG_INPUT_MATRIXKMAP is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
# CONFIG_INPUT_EVDEV is not set
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
# CONFIG_INPUT_KEYBOARD is not set
# CONFIG_INPUT_MOUSE is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
# CONFIG_SERIO is not set
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
# CONFIG_VT_HW_CONSOLE_BINDING is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_TRACE_SINK is not set
# CONFIG_PPC_EPAPR_HV_BYTECHAN is not set
CONFIG_DEVKMEM=y

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
CONFIG_SERIAL_8250_FSL=y
# CONFIG_SERIAL_8250_DW is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_OF_PLATFORM is not set
# CONFIG_SERIAL_OF_PLATFORM_NWPSERIAL is not set
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_PCH_UART is not set
# CONFIG_SERIAL_XILINX_PS_UART is not set
CONFIG_HVC_DRIVER=y
CONFIG_HVC_RTAS=y
CONFIG_IPMI_HANDLER=m
CONFIG_IPMI_PANIC_EVENT=y
CONFIG_IPMI_PANIC_STRING=y
CONFIG_IPMI_DEVICE_INTERFACE=m
CONFIG_IPMI_SI=m
CONFIG_IPMI_WATCHDOG=m
CONFIG_IPMI_POWEROFF=m
CONFIG_HW_RANDOM=m
CONFIG_HW_RANDOM_TIMERIOMEM=m
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_RAW_DRIVER is not set
# CONFIG_HANGCHECK_TIMER is not set
# CONFIG_TCG_TPM is not set
CONFIG_DEVPORT=y
# CONFIG_I2C is not set
# CONFIG_SPI is not set
# CONFIG_HSI is not set

#
# PPS support
#

#
# PPS generators support
#

#
# PTP clock support
#

#
# Enable Device Drivers -> PPS to see the PTP clock options.
#
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_ARCH_REQUIRE_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_OF_GPIO=y

#
# Memory mapped GPIO drivers:
#
# CONFIG_GPIO_GENERIC_PLATFORM is not set
# CONFIG_GPIO_XILINX is not set
# CONFIG_GPIO_VX855 is not set

#
# I2C GPIO expanders:
#

#
# PCI GPIO expanders:
#
# CONFIG_GPIO_BT8XX is not set
# CONFIG_GPIO_AMD8111 is not set
# CONFIG_GPIO_ML_IOH is not set
# CONFIG_GPIO_RDC321X is not set

#
# SPI GPIO expanders:
#

#
# AC97 GPIO expanders:
#

#
# MODULbus GPIO expanders:
#
# CONFIG_W1 is not set
# CONFIG_POWER_SUPPLY is not set
# CONFIG_POWER_AVS is not set
# CONFIG_HWMON is not set
# CONFIG_THERMAL is not set
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
# CONFIG_SSB is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
# CONFIG_BCMA is not set

#
# Multifunction device drivers
#
# CONFIG_MFD_CORE is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_ABX500_CORE is not set
# CONFIG_MFD_TIMBERDALE is not set
# CONFIG_LPC_SCH is not set
# CONFIG_LPC_ICH is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_VX855 is not set
# CONFIG_REGULATOR is not set
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_DRM is not set
# CONFIG_STUB_POULSBO is not set
# CONFIG_VGASTATE is not set
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
# CONFIG_FB is not set
# CONFIG_EXYNOS_VIDEO is not set
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set

#
# Console display driver support
#
# CONFIG_VGA_CONSOLE is not set
CONFIG_DUMMY_CONSOLE=y
# CONFIG_SOUND is not set

#
# HID support
#
CONFIG_HID=m
# CONFIG_HIDRAW is not set
# CONFIG_UHID is not set
CONFIG_HID_GENERIC=m

#
# Special HID drivers
#
CONFIG_HID_A4TECH=m
# CONFIG_HID_ACRUX is not set
CONFIG_HID_APPLE=m
# CONFIG_HID_AUREAL is not set
CONFIG_HID_BELKIN=m
CONFIG_HID_CHERRY=m
CONFIG_HID_CHICONY=m
CONFIG_HID_CYPRESS=m
# CONFIG_HID_DRAGONRISE is not set
# CONFIG_HID_EMS_FF is not set
CONFIG_HID_EZKEY=m
# CONFIG_HID_HOLTEK is not set
# CONFIG_HID_KEYTOUCH is not set
# CONFIG_HID_KYE is not set
# CONFIG_HID_UCLOGIC is not set
# CONFIG_HID_WALTOP is not set
# CONFIG_HID_GYRATION is not set
# CONFIG_HID_TWINHAN is not set
CONFIG_HID_KENSINGTON=m
# CONFIG_HID_LCPOWER is not set
# CONFIG_HID_LENOVO_TPKBD is not set
CONFIG_HID_LOGITECH=m
CONFIG_HID_LOGITECH_DJ=m
# CONFIG_LOGITECH_FF is not set
# CONFIG_LOGIRUMBLEPAD2_FF is not set
# CONFIG_LOGIG940_FF is not set
# CONFIG_LOGIWHEELS_FF is not set
CONFIG_HID_MICROSOFT=m
CONFIG_HID_MONTEREY=m
# CONFIG_HID_MULTITOUCH is not set
# CONFIG_HID_NTRIG is not set
# CONFIG_HID_ORTEK is not set
# CONFIG_HID_PANTHERLORD is not set
# CONFIG_HID_PETALYNX is not set
# CONFIG_HID_PICOLCD is not set
# CONFIG_HID_PRIMAX is not set
# CONFIG_HID_ROCCAT is not set
# CONFIG_HID_SAITEK is not set
# CONFIG_HID_SAMSUNG is not set
# CONFIG_HID_SONY is not set
# CONFIG_HID_SPEEDLINK is not set
# CONFIG_HID_SUNPLUS is not set
# CONFIG_HID_GREENASIA is not set
# CONFIG_HID_SMARTJOYPLUS is not set
# CONFIG_HID_TIVO is not set
# CONFIG_HID_TOPSEED is not set
# CONFIG_HID_THRUSTMASTER is not set
# CONFIG_HID_ZEROPLUS is not set
# CONFIG_HID_ZYDACRON is not set

#
# USB HID support
#
CONFIG_USB_HID=m
# CONFIG_HID_PID is not set
# CONFIG_USB_HIDDEV is not set
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB_ARCH_HAS_XHCI=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=m
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=m
# CONFIG_USB_DEBUG is not set
# CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set

#
# Miscellaneous USB options
#
CONFIG_USB_DYNAMIC_MINORS=y
CONFIG_USB_SUSPEND=y
# CONFIG_USB_MON is not set
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
CONFIG_USB_EHCI_HCD=m
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
CONFIG_USB_EHCI_HCD_PPC_OF=y
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1362_HCD is not set
CONFIG_USB_OHCI_HCD=m
CONFIG_USB_OHCI_HCD_PPC_OF_BE=y
CONFIG_USB_OHCI_HCD_PPC_OF_LE=y
CONFIG_USB_OHCI_HCD_PPC_OF=y
CONFIG_USB_OHCI_HCD_PCI=y
CONFIG_USB_OHCI_BIG_ENDIAN_DESC=y
CONFIG_USB_OHCI_BIG_ENDIAN_MMIO=y
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
# CONFIG_USB_UHCI_HCD is not set
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_CHIPIDEA is not set

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
# CONFIG_USB_PRINTER is not set
# CONFIG_USB_WDM is not set
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=m
# CONFIG_USB_STORAGE_DEBUG is not set
# CONFIG_USB_STORAGE_REALTEK is not set
# CONFIG_USB_STORAGE_DATAFAB is not set
# CONFIG_USB_STORAGE_FREECOM is not set
# CONFIG_USB_STORAGE_ISD200 is not set
# CONFIG_USB_STORAGE_USBAT is not set
# CONFIG_USB_STORAGE_SDDR09 is not set
# CONFIG_USB_STORAGE_SDDR55 is not set
# CONFIG_USB_STORAGE_JUMPSHOT is not set
# CONFIG_USB_STORAGE_ALAUDA is not set
# CONFIG_USB_STORAGE_ONETOUCH is not set
# CONFIG_USB_STORAGE_KARMA is not set
# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
# CONFIG_USB_STORAGE_ENE_UB6250 is not set
# CONFIG_USB_UAS is not set
# CONFIG_USB_LIBUSUAL is not set

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set

#
# USB port drivers
#
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_SEVSEG is not set
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
# CONFIG_USB_LED is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_YUREX is not set

#
# USB Physical Layer drivers
#
# CONFIG_USB_GADGET is not set

#
# OTG and related infrastructure
#
# CONFIG_USB_GPIO_VBUS is not set
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
# CONFIG_NEW_LEDS is not set
# CONFIG_ACCESSIBILITY is not set
CONFIG_INFINIBAND=m
CONFIG_INFINIBAND_USER_MAD=m
CONFIG_INFINIBAND_USER_ACCESS=m
CONFIG_INFINIBAND_USER_MEM=y
CONFIG_INFINIBAND_ADDR_TRANS=y
CONFIG_INFINIBAND_MTHCA=m
CONFIG_INFINIBAND_MTHCA_DEBUG=y
# CONFIG_INFINIBAND_QIB is not set
# CONFIG_INFINIBAND_AMSO1100 is not set
# CONFIG_MLX4_INFINIBAND is not set
# CONFIG_INFINIBAND_NES is not set
# CONFIG_INFINIBAND_OCRDMA is not set
# CONFIG_INFINIBAND_IPOIB is not set
# CONFIG_INFINIBAND_SRP is not set
# CONFIG_INFINIBAND_ISER is not set
CONFIG_EDAC=y

#
# Reporting subsystems
#
# CONFIG_EDAC_LEGACY_SYSFS is not set
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_MM_EDAC=m
CONFIG_EDAC_CELL=m
# CONFIG_EDAC_CPC925 is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
# CONFIG_RTC_DRV_TEST is not set

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
# CONFIG_RTC_DRV_CMOS is not set
# CONFIG_RTC_DRV_DS1286 is not set
# CONFIG_RTC_DRV_DS1511 is not set
# CONFIG_RTC_DRV_DS1553 is not set
# CONFIG_RTC_DRV_DS1742 is not set
# CONFIG_RTC_DRV_STK17TA8 is not set
# CONFIG_RTC_DRV_M48T86 is not set
# CONFIG_RTC_DRV_M48T35 is not set
# CONFIG_RTC_DRV_M48T59 is not set
# CONFIG_RTC_DRV_MSM6242 is not set
# CONFIG_RTC_DRV_BQ4802 is not set
# CONFIG_RTC_DRV_RP5C01 is not set
# CONFIG_RTC_DRV_V3020 is not set

#
# on-CPU RTC drivers
#
CONFIG_RTC_DRV_GENERIC=m
# CONFIG_DMADEVICES is not set
# CONFIG_AUXDISPLAY is not set
# CONFIG_UIO is not set

#
# Virtio drivers
#
# CONFIG_VIRTIO_BALLOON is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_STAGING is not set

#
# Hardware Spinlock drivers
#
CONFIG_IOMMU_SUPPORT=y
CONFIG_OF_IOMMU=y

#
# Remoteproc drivers (EXPERIMENTAL)
#

#
# Rpmsg drivers (EXPERIMENTAL)
#
# CONFIG_VIRT_DRIVERS is not set
# CONFIG_PM_DEVFREQ is not set
# CONFIG_EXTCON is not set
# CONFIG_MEMORY is not set
# CONFIG_IIO is not set
# CONFIG_VME_BUS is not set
# CONFIG_PWM is not set

#
# File systems
#
CONFIG_EXT2_FS=m
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
CONFIG_EXT2_FS_SECURITY=y
CONFIG_EXT2_FS_XIP=y
CONFIG_EXT3_FS=m
CONFIG_EXT3_DEFAULTS_TO_ORDERED=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
CONFIG_EXT4_FS=m
CONFIG_EXT4_FS_XATTR=y
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
# CONFIG_EXT4_DEBUG is not set
CONFIG_FS_XIP=y
CONFIG_JBD=m
CONFIG_JBD2=m
CONFIG_FS_MBCACHE=m
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
# CONFIG_QUOTA is not set
# CONFIG_QUOTACTL is not set
CONFIG_AUTOFS4_FS=m
CONFIG_FUSE_FS=m
# CONFIG_CUSE is not set

#
# Caches
#
CONFIG_FSCACHE=m
# CONFIG_FSCACHE_STATS is not set
# CONFIG_FSCACHE_HISTOGRAM is not set
# CONFIG_FSCACHE_DEBUG is not set
# CONFIG_FSCACHE_OBJECT_LIST is not set
# CONFIG_CACHEFILES is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=m
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=m
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=m
CONFIG_MSDOS_FS=m
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
# CONFIG_TMPFS_POSIX_ACL is not set
# CONFIG_TMPFS_XATTR is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
# CONFIG_CONFIGFS_FS is not set
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_HFSPLUS_FS is not set
# CONFIG_CRAMFS is not set
CONFIG_SQUASHFS=m
CONFIG_SQUASHFS_XATTR=y
CONFIG_SQUASHFS_ZLIB=y
CONFIG_SQUASHFS_LZO=y
CONFIG_SQUASHFS_XZ=y
# CONFIG_SQUASHFS_4K_DEVBLK_SIZE is not set
# CONFIG_SQUASHFS_EMBEDDED is not set
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_QNX6FS_FS is not set
# CONFIG_ROMFS_FS is not set
# CONFIG_PSTORE is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=m
CONFIG_NFS_V2=m
CONFIG_NFS_V3=m
CONFIG_NFS_V3_ACL=y
CONFIG_NFS_V4=m
# CONFIG_NFS_SWAP is not set
CONFIG_NFS_FSCACHE=y
# CONFIG_NFS_USE_LEGACY_DNS is not set
CONFIG_NFS_USE_KERNEL_DNS=y
# CONFIG_NFSD is not set
CONFIG_LOCKD=m
CONFIG_LOCKD_V4=y
CONFIG_NFS_ACL_SUPPORT=m
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=m
CONFIG_SUNRPC_GSS=m
# CONFIG_SUNRPC_DEBUG is not set
# CONFIG_CIFS is not set
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
CONFIG_9P_FS=m
CONFIG_9P_FS_POSIX_ACL=y
CONFIG_NLS=m
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=m
CONFIG_NLS_CODEPAGE_737=m
CONFIG_NLS_CODEPAGE_775=m
CONFIG_NLS_CODEPAGE_850=m
CONFIG_NLS_CODEPAGE_852=m
CONFIG_NLS_CODEPAGE_855=m
CONFIG_NLS_CODEPAGE_857=m
CONFIG_NLS_CODEPAGE_860=m
CONFIG_NLS_CODEPAGE_861=m
CONFIG_NLS_CODEPAGE_862=m
CONFIG_NLS_CODEPAGE_863=m
CONFIG_NLS_CODEPAGE_864=m
CONFIG_NLS_CODEPAGE_865=m
CONFIG_NLS_CODEPAGE_866=m
CONFIG_NLS_CODEPAGE_869=m
CONFIG_NLS_CODEPAGE_936=m
CONFIG_NLS_CODEPAGE_950=m
CONFIG_NLS_CODEPAGE_932=m
CONFIG_NLS_CODEPAGE_949=m
CONFIG_NLS_CODEPAGE_874=m
CONFIG_NLS_ISO8859_8=m
CONFIG_NLS_CODEPAGE_1250=m
CONFIG_NLS_CODEPAGE_1251=m
CONFIG_NLS_ASCII=m
CONFIG_NLS_ISO8859_1=m
CONFIG_NLS_ISO8859_2=m
CONFIG_NLS_ISO8859_3=m
CONFIG_NLS_ISO8859_4=m
CONFIG_NLS_ISO8859_5=m
CONFIG_NLS_ISO8859_6=m
CONFIG_NLS_ISO8859_7=m
CONFIG_NLS_ISO8859_9=m
CONFIG_NLS_ISO8859_13=m
CONFIG_NLS_ISO8859_14=m
CONFIG_NLS_ISO8859_15=m
CONFIG_NLS_KOI8_R=m
CONFIG_NLS_KOI8_U=m
CONFIG_NLS_MAC_ROMAN=m
CONFIG_NLS_MAC_CELTIC=m
CONFIG_NLS_MAC_CENTEURO=m
CONFIG_NLS_MAC_CROATIAN=m
CONFIG_NLS_MAC_CYRILLIC=m
CONFIG_NLS_MAC_GAELIC=m
CONFIG_NLS_MAC_GREEK=m
CONFIG_NLS_MAC_ICELAND=m
CONFIG_NLS_MAC_INUIT=m
CONFIG_NLS_MAC_ROMANIAN=m
CONFIG_NLS_MAC_TURKISH=m
CONFIG_NLS_UTF8=m
# CONFIG_BINARY_PRINTF is not set

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_IO=y
# CONFIG_CRC_CCITT is not set
CONFIG_CRC16=m
# CONFIG_CRC_T10DIF is not set
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
# CONFIG_CRC7 is not set
# CONFIG_LIBCRC32C is not set
# CONFIG_CRC8 is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
CONFIG_XZ_DEC_IA64=y
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
# CONFIG_AVERAGE is not set
# CONFIG_CORDIC is not set
# CONFIG_DDR is not set

#
# Kernel hacking
#
CONFIG_PRINTK_TIME=y
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
# CONFIG_MAGIC_SYSRQ is not set
# CONFIG_STRIP_ASM_SYMS is not set
# CONFIG_UNUSED_SYMBOLS is not set
# CONFIG_DEBUG_FS is not set
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_SECTION_MISMATCH is not set
# CONFIG_DEBUG_KERNEL is not set
# CONFIG_HARDLOCKUP_DETECTOR is not set
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
# CONFIG_SPARSE_RCU_POINTER is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_RCU_CPU_STALL_TIMEOUT=60
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_TEST_KSTRTOX is not set
# CONFIG_PPC_DISABLE_WERROR is not set
CONFIG_PPC_WERROR=y
CONFIG_PRINT_STACK_DEPTH=64
# CONFIG_BOOTX_TEXT is not set
# CONFIG_PPC_EARLY_DEBUG is not set
CONFIG_STRICT_DEVMEM=y

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_ENCRYPTED_KEYS is not set
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
# CONFIG_SECURITY is not set
# CONFIG_SECURITYFS is not set
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_KEYS_COMPAT=y
CONFIG_CRYPTO=m

#
# Crypto core or helper
#
# CONFIG_CRYPTO_FIPS is not set
CONFIG_CRYPTO_ALGAPI=m
CONFIG_CRYPTO_ALGAPI2=m
CONFIG_CRYPTO_HASH=m
CONFIG_CRYPTO_HASH2=m
CONFIG_CRYPTO_RNG=m
CONFIG_CRYPTO_RNG2=m
# CONFIG_CRYPTO_MANAGER is not set
# CONFIG_CRYPTO_MANAGER2 is not set
# CONFIG_CRYPTO_USER is not set
# CONFIG_CRYPTO_GF128MUL is not set
# CONFIG_CRYPTO_NULL is not set
# CONFIG_CRYPTO_CRYPTD is not set
# CONFIG_CRYPTO_AUTHENC is not set
# CONFIG_CRYPTO_TEST is not set

#
# Authenticated Encryption with Associated Data
#
# CONFIG_CRYPTO_CCM is not set
# CONFIG_CRYPTO_GCM is not set
# CONFIG_CRYPTO_SEQIV is not set

#
# Block modes
#
# CONFIG_CRYPTO_CBC is not set
# CONFIG_CRYPTO_CTR is not set
# CONFIG_CRYPTO_CTS is not set
# CONFIG_CRYPTO_ECB is not set
# CONFIG_CRYPTO_LRW is not set
# CONFIG_CRYPTO_PCBC is not set
# CONFIG_CRYPTO_XTS is not set

#
# Hash modes
#
# CONFIG_CRYPTO_HMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=m
# CONFIG_CRYPTO_GHASH is not set
# CONFIG_CRYPTO_MD4 is not set
# CONFIG_CRYPTO_MD5 is not set
# CONFIG_CRYPTO_MICHAEL_MIC is not set
# CONFIG_CRYPTO_RMD128 is not set
# CONFIG_CRYPTO_RMD160 is not set
# CONFIG_CRYPTO_RMD256 is not set
# CONFIG_CRYPTO_RMD320 is not set
# CONFIG_CRYPTO_SHA1 is not set
# CONFIG_CRYPTO_SHA256 is not set
# CONFIG_CRYPTO_SHA512 is not set
# CONFIG_CRYPTO_TGR192 is not set
# CONFIG_CRYPTO_WP512 is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=m
# CONFIG_CRYPTO_ANUBIS is not set
# CONFIG_CRYPTO_ARC4 is not set
# CONFIG_CRYPTO_BLOWFISH is not set
# CONFIG_CRYPTO_CAMELLIA is not set
# CONFIG_CRYPTO_CAST5 is not set
# CONFIG_CRYPTO_CAST6 is not set
# CONFIG_CRYPTO_DES is not set
# CONFIG_CRYPTO_FCRYPT is not set
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_SEED is not set
# CONFIG_CRYPTO_SERPENT is not set
# CONFIG_CRYPTO_TEA is not set
# CONFIG_CRYPTO_TWOFISH is not set

#
# Compression
#
# CONFIG_CRYPTO_DEFLATE is not set
# CONFIG_CRYPTO_ZLIB is not set
# CONFIG_CRYPTO_LZO is not set

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=m
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
CONFIG_CRYPTO_HW=y
# CONFIG_PPC_CLOCK is not set
# CONFIG_VIRTUALIZATION is not set

--nextPart2710719.TDxhTB7GYc
Content-Disposition: attachment; filename="blade02-3.6.2-gentoo.boot-20121019.log"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-log; charset="UTF-8"; name="blade02-3.6.2-gentoo.boot-20121019.log"

Please wait, loading kernel...

 Bootloader 2.0
  Reading MAC address from device: 00:1a:64:b8:06:f2
  Requesting IP address via DHCP: 192.168.100.52
  Requesting file "/images/gentoo-ppc64/vmlinux-3.6.2-gentoo" via TFTP from 192.168.100.1
  Receiving data:  8738 KBytes
  TFTP: Received /images/gentoo-ppc64/vmlinux-3.6.2-gentoo (8738 KBytes)
   Elf64 kernel loaded...
Loading ramdisk...

 Bootloader 2.0
  Reading MAC address from device: 00:1a:64:b8:06:f2
  Requesting IP address via DHCP: 192.168.100.52
  Requesting file "/images/gentoo-ppc64/initramfs-3.6.2-gentoo.img" via TFTP from 192.168.100.1
  Receiving data:  6948 KBytes
  TFTP: Received /images/gentoo-ppc64/initramfs-3.6.2-gentoo.img (6948 KBytes)
ramdisk loaded at 03000000, size: 6948 Kbytes
OF stdout device is: /axon@10000000000/plb5/plb4/opb/serial@40000200
Preparing to boot Linux version 3.6.2-gentoo (root@blade00) (gcc version 4.7.2 (Gentoo 4.7.2 p1.1, pie-0.5.5) ) #4 SMP Thu Oct 18 02:49:29 CEST 2012
Detected machine type: 0000000000000500
command line:  ksdevice=bootif lang=  text rd.debug ip=meth0:dhcp ifname=meth0:00:1a:64:b8:06:f2 root=aufs:/run/rw:/run/ro rd.mount.early=/run/rw:tmpfs:size=1g rd.mount.early=/run/ro:nfs:192.168.100.1:/export/gentoo/root-ppc64
memory layout at init:
  memory_limit : 0000000000000000 (16 MB aligned)
  alloc_bottom : 00000000036ca000
  alloc_top    : 0000000030000000
  alloc_top_hi : 0000000200000000
  rmo_top      : 0000000030000000
  ram_top      : 0000000200000000
instantiating rtas at 0x000000002fff3000... done
boot cpu hw idx 0
starting cpu hw idx 2... done
copying OF device tree...
Building dt strings...
Building dt structure...
Device tree strings 0x00000000037cb000 -> 0x00000000037cb8e3
Device tree struct  0x00000000037cc000 -> 0x00000000037d5000
[    0.000000] Using Cell machine description
[    0.000000] Found initrd at 0xc000000003000000:0xc0000000036c92c8
[    0.000000] bootconsole [udbg0] enabled
[    0.000000] CPU maps initialized for 2 threads per core
[    0.000000] Starting Linux PPC64 #4 SMP Thu Oct 18 02:49:29 CEST 2012
[    0.000000] -----------------------------------------------------
[    0.000000] ppc64_pft_size                = 0x0
[    0.000000] physicalMemorySize            = 0x200000000
[    0.000000] htab_address                  = 0xc000000078000000
[    0.000000] htab_hash_mask                = 0xfffff
[    0.000000] -----------------------------------------------------
[    0.000000] Linux version 3.6.2-gentoo (root@blade00) (gcc version 4.7.2 (Gentoo 4.7.2 p1.1, pie-0.5.5) ) #4 SMP Thu Oct 18 02:49:29 CEST 2012
[    0.000000] *** 0000 : CF000012
[    0.000000]
[    0.000000] *** 0000 : Setup Arch
[    0.000000] [boot]0012 Setup Arch
[    0.000000] mmio NVRAM, 1020k at 0x14502000000 mapped to d000080080008000
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00000000-0x1ffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00000000-0xffffffff]
[    0.000000]   node   1: [mem 0x100000000-0x1ffffffff]
[    0.000000] *** 0000 : CF000015
[    0.000000]
[    0.000000] *** 0000 : Setup Done
[    0.000000] [boot]0015 Setup Done
[    0.000000] PERCPU: Embedded 11 pages/cpu @c000000000700000 s14720 r0 d30336 u262144
[    0.000000] Built 2 zonelists in Node order, mobility grouping on.  Total pages: 2068480
[    0.000000] Policy zone: DMA
[    0.000000] Kernel command line:  ksdevice=bootif lang=  text rd.debug ip=meth0:dhcp ifname=meth0:00:1a:64:b8:06:f2 root=aufs:/run/rw:/run/ro rd.mount.early=/run/rw:tmpfs:size=1g rd.mount.early=/run/ro:nfs:192.168.100.1:/export/gentoo/root-ppc64
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] freeing bootmem node 0
[    0.000000] freeing bootmem node 1
[    0.000000] Memory: 8127896k/8388608k available (5980k kernel code, 260712k reserved, 644k data, 424k bss, 2016k init)
[    0.000000] SLUB: Genslabs=15, HWalign=128, Order=0-3, MinObjects=0, CPUs=4, Nodes=256
[    0.000000] Hierarchical RCU implementation.
[    0.000000]  RCU restricting CPUs from NR_CPUS=32 to nr_cpu_ids=4.
[    0.000000] NR_IRQS:512 nr_irqs:512 16
[    0.000000] IIC for CPU 0 target id 0xe : /be@20000000000/interrupt-controller@508400
[    0.000000] IIC for CPU 1 target id 0xf : /be@20000000000/interrupt-controller@508400
[    0.000000] IIC for CPU 2 target id 0x1e : /be@20100000000/interrupt-controller@508400
[    0.000000] IIC for CPU 3 target id 0x1f : /be@20100000000/interrupt-controller@508400
[    0.000000] mpic: Setting up MPIC " MPIC     " version 1.2 at 0, max 4 CPUs
[    0.000000] mpic: ISU size: 128, shift: 7, mask: 7f
[    0.000000] mpic: Initializing for 128 sources
[    0.000000] /axon@10000000000/interrupt-controller: hooking up to IRQ 43
[    0.000000] mpic: Setting up MPIC " MPIC     " version 1.2 at 0, max 4 CPUs
[    0.000000] mpic: ISU size: 128, shift: 7, mask: 7f
[    0.000000] mpic: Initializing for 128 sources
[    0.000000] /axon@30000000000/interrupt-controller: hooking up to IRQ 299
[    0.000000] clocksource: timebase mult[2580c67f] shift[24] registered
[    0.000000] Console: colour dummy device 80x25
[    0.065076] pid_max: default: 32768 minimum: 301
[    0.095238] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.150642] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.198503] Mount-cache hash table entries: 256
[    0.227933] Brought up 4 CPUs
[    0.245823] devtmpfs: initialized
[    0.292275] NET: Registered protocol family 16
[    0.320134] IOMMU: Using strong ordering for fixed mapping
[    0.354491] IOMMU table initialized, virtual merging enabled
[    0.390314] IOMMU: Using strong ordering for fixed mapping
[    0.425764] ------------[ cut here ]------------
[    0.452929] WARNING: at /usr/src/linux-3.6.2-gentoo/kernel/irq/irqdomain.c:743
[    0.496158] Modules linked in:
[    0.514389] NIP: c0000000000ba1e4 LR: c0000000000bb228 CTR: 0000000000000000
[    0.556579] REGS: c0000000fe65ba70 TRAP: 0700   Not tainted  (3.6.2-gentoo)
[    0.598244] MSR: 9000000000029032 <SF,HV,EE,ME,IR,DR,RI>  CR: 84000082  XER: 00000000
[    0.645121] SOFTE: 1
[    0.658144] TASK = c0000000fe650000[1] 'swapper/0' THREAD: c0000000fe658000 CPU: 0
GPR00: c0000000000bb228 c0000000fe65bcf0 c0000000006687c0 c0000000fe006000
GPR04: 000000000000027e 0000000000000000 ffffffffffffffff fffffffffffffffc
GPR08: fffffffffffffffc 0000000000000001 c000000000675c10 c0000001fe64ccc0
GPR12: 0000000084000084 c00000000fffb000 ffffffffffffffff 0000000002c0f498
GPR16: 0000000000000060 000000000ead9738 0000000002c0f498 00000000037ca028
GPR20: 00000000037cb012 0000000002c0f488 0000000002c109a0 0000000002c109a8
GPR24: 0000000002c10998 0000000000000031 0000000000000000 c0000000fe658000
GPR28: c00000000040e0f0 000000000000027e c000000000614b10 c0000000fe006000
[    1.024311] NIP [c0000000000ba1e4] .irq_linear_revmap+0x2c/0x50
[    1.059720] LR [c0000000000bb228] .irq_create_mapping+0x40/0x1d0
[    1.095655] Call Trace:
[    1.110243] [c0000000fe65bcf0] [c0000000000bb228] .irq_create_mapping+0x40/0x1d0 (unreliable)
[    1.161289] [c0000000fe65bd90] [c0000000003f09d8] .__machine_initcall_cell_cbe_init_pm_irq+0x58/0x11c
[    1.216499] [c0000000fe65be20] [c000000000009a70] .do_one_initcall+0x168/0x1d0
[    1.259730] [c0000000fe65bee0] [c0000000003dfb74] .kernel_init+0x14c/0x1f4
[    1.300877] [c0000000fe65bf90] [c00000000001b478] .kernel_thread+0x54/0x70
[    1.342016] Instruction dump:
[    1.359726] 60000000 81230010 69290002 7d290034 5529d97e 79290020 69290001 0b090000
[    1.406081] 81230018 7d292010 39200000 7d294914 <0b090000> 2fa90000 40de0014 e9230020
[    1.453491] ---[ end trace 1c41163440405734 ]---
[    1.481143] ------------[ cut here ]------------
[    1.508689] WARNING: at /usr/src/linux-3.6.2-gentoo/kernel/irq/irqdomain.c:743
[    1.551918] Modules linked in:
[    1.570150] NIP: c0000000000ba1e4 LR: c0000000000bb228 CTR: 0000000000000000
[    1.612340] REGS: c0000000fe65ba70 TRAP: 0700   Tainted: G        W     (3.6.2-gentoo)
[    1.659736] MSR: 9000000000029032 <SF,HV,EE,ME,IR,DR,RI>  CR: 84000082  XER: 00000000
[    1.706611] SOFTE: 1
[    1.719634] TASK = c0000000fe650000[1] 'swapper/0' THREAD: c0000000fe658000 CPU: 0
GPR00: c0000000000bb228 c0000000fe65bcf0 c0000000006687c0 c0000000fe006000
GPR04: 000000000000037e 0000000000000000 ffffffffffffffff fffffffffffffff8
GPR08: fffffffffffffff8 0000000000000001 c000000000675c10 c0000001fe64ccc0
GPR12: 0000000084000084 c00000000fffb000 ffffffffffffffff 0000000002c0f498
GPR16: 0000000000000060 000000000ead9738 0000000002c0f498 00000000037ca028
GPR20: 00000000037cb012 0000000002c0f488 0000000002c109a0 0000000002c109a8
GPR24: 0000000002c10998 0000000000000031 0000000000000000 c0000000fe658000
GPR28: c00000000040e0f0 000000000000037e c000000000614b10 c0000000fe006000
[    2.085794] NIP [c0000000000ba1e4] .irq_linear_revmap+0x2c/0x50
[    2.121211] LR [c0000000000bb228] .irq_create_mapping+0x40/0x1d0
[    2.157146] Call Trace:
[    2.171733] [c0000000fe65bcf0] [c0000000000bb228] .irq_create_mapping+0x40/0x1d0 (unreliable)
[    2.222777] [c0000000fe65bd90] [c0000000003f09d8] .__machine_initcall_cell_cbe_init_pm_irq+0x58/0x11c
[    2.277986] [c0000000fe65be20] [c000000000009a70] .do_one_initcall+0x168/0x1d0
[    2.321216] [c0000000fe65bee0] [c0000000003dfb74] .kernel_init+0x14c/0x1f4
[    2.362365] [c0000000fe65bf90] [c00000000001b478] .kernel_thread+0x54/0x70
[    2.403508] Instruction dump:
[    2.421216] 60000000 81230010 69290002 7d290034 5529d97e 79290020 69290001 0b090000
[    2.467572] 81230018 7d292010 39200000 7d294914 <0b090000> 2fa90000 40de0014 e9230020
[    2.514970] ---[ end trace 1c41163440405735 ]---

--nextPart2710719.TDxhTB7GYc
Content-Disposition: attachment; filename="blade03-3.6.2.boot-20121019.log"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-log; charset="UTF-8"; name="blade03-3.6.2.boot-20121019.log"

Please wait, loading kernel...


 Bootloader 2.0 

  Reading MAC address from device: 00:1a:64:b8:07:fa

  Requesting IP address via DHCP:     600192.168.100.53

  Requesting file "/images/gentoo-ppc64-3.6/vmlinux-3.6.2" via TFTP from 192.168.100.1

  Receiving data:  0 KBytes512 KBytes1023 KBytes1535 KBytes2046 KBytes2558 KBytes3069 KBytes3581 KBytes4092 KBytes4604 KBytes5115 KBytes5627 KBytes6138 KBytes6650 KBytes7161 KBytes7673 KBytes8184 KBytes8696 KBytes8735 KBytes

  TFTP: Received /images/gentoo-ppc64-3.6/vmlinux-3.6.2 (8735 KBytes)

   Elf64 kernel loaded...
Loading ramdisk...


 Bootloader 2.0 

  Reading MAC address from device: 00:1a:64:b8:07:fa

  Requesting IP address via DHCP:     600192.168.100.53

  Requesting file "/images/gentoo-ppc64-3.6/initramfs-3.6.2.img" via TFTP from 192.168.100.1

  Receiving data:  0 KBytes512 KBytes1023 KBytes1535 KBytes2046 KBytes2558 KBytes3069 KBytes3581 KBytes4092 KBytes4604 KBytes5115 KBytes5627 KBytes6138 KBytes6650 KBytes6872 KBytes

  TFTP: Received /images/gentoo-ppc64-3.6/initramfs-3.6.2.img (6872 KBytes)

ramdisk loaded at 03000000, size: 6872 Kbytes
OF stdout device is: /axon@10000000000/plb5/plb4/opb/serial@40000200
Preparing to boot Linux version 3.6.2 (root@blade00) (gcc version 4.7.2 (Gentoo 4.7.2 p1.1, pie-0.5.5) ) #1 SMP Thu Oct 18 11:52:57 CEST 2012
Detected machine type: 0000000000000500
command line:  ksdevice=bootif lang=  text  
memory layout at init:
  memory_limit : 0000000000000000 (16 MB aligned)
  alloc_bottom : 00000000036b7000
  alloc_top    : 0000000030000000
  alloc_top_hi : 0000000200000000
  rmo_top      : 0000000030000000
  ram_top      : 0000000200000000
instantiating rtas at 0x000000002fff3000... done
boot cpu hw idx 0
starting cpu hw idx 2... done
copying OF device tree...
Building dt strings...
Building dt structure...
Device tree strings 0x00000000037b8000 -> 0x00000000037b88e3
Device tree struct  0x00000000037b9000 -> 0x00000000037c2000
[    0.000000] Using Cell machine description
[    0.000000] Found initrd at 0xc000000003000000:0xc0000000036b6290
[    0.000000] bootconsole [udbg0] enabled
[    0.000000] CPU maps initialized for 2 threads per core
[    0.000000] Starting Linux PPC64 #1 SMP Thu Oct 18 11:52:57 CEST 2012
[    0.000000] -----------------------------------------------------
[    0.000000] ppc64_pft_size                = 0x0
[    0.000000] physicalMemorySize            = 0x200000000
[    0.000000] htab_address                  = 0xc000000078000000
[    0.000000] htab_hash_mask                = 0xfffff
[    0.000000] -----------------------------------------------------
[    0.000000] Linux version 3.6.2 (root@blade00) (gcc version 4.7.2 (Gentoo 4.7.2 p1.1, pie-0.5.5) ) #1 SMP Thu Oct 18 11:52:57 CEST 2012
[    0.000000] *** 0000 : CF000012
[    0.000000] 
[    0.000000] *** 0000 : Setup Arch
[    0.000000] [boot]0012 Setup Arch
[    0.000000] mmio NVRAM, 1020k at 0x14502000000 mapped to d000080080008000
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00000000-0x1ffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00000000-0xffffffff]
[    0.000000]   node   1: [mem 0x100000000-0x1ffffffff]
[    0.000000] *** 0000 : CF000015
[    0.000000] 
[    0.000000] *** 0000 : Setup Done
[    0.000000] [boot]0015 Setup Done
[    0.000000] PERCPU: Embedded 11 pages/cpu @c000000000700000 s14720 r0 d30336 u262144
[    0.000000] Built 2 zonelists in Node order, mobility grouping on.  Total pages: 2068480
[    0.000000] Policy zone: DMA
[    0.000000] Kernel command line:  ksdevice=bootif lang=  text  
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] freeing bootmem node 0
[    0.000000] freeing bootmem node 1
[    0.000000] Memory: 8127972k/8388608k available (5976k kernel code, 260636k reserved, 648k data, 424k bss, 2016k init)
[    0.000000] SLUB: Genslabs=15, HWalign=128, Order=0-3, MinObjects=0, CPUs=4, Nodes=256
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=32 to nr_cpu_ids=4.
[    0.000000] NR_IRQS:512 nr_irqs:512 16
[    0.000000] IIC for CPU 0 target id 0xe : /be@20000000000/interrupt-controller@508400
[    0.000000] IIC for CPU 1 target id 0xf : /be@20000000000/interrupt-controller@508400
[    0.000000] IIC for CPU 2 target id 0x1e : /be@20100000000/interrupt-controller@508400
[    0.000000] IIC for CPU 3 target id 0x1f : /be@20100000000/interrupt-controller@508400
[    0.000000] mpic: Setting up MPIC " MPIC     " version 1.2 at 0, max 4 CPUs
[    0.000000] mpic: ISU size: 128, shift: 7, mask: 7f
[    0.000000] mpic: Initializing for 128 sources
[    0.000000] /axon@10000000000/interrupt-controller: hooking up to IRQ 43
[    0.000000] mpic: Setting up MPIC " MPIC     " version 1.2 at 0, max 4 CPUs
[    0.000000] mpic: ISU size: 128, shift: 7, mask: 7f
[    0.000000] mpic: Initializing for 128 sources
[    0.000000] /axon@30000000000/interrupt-controller: hooking up to IRQ 299
[    0.000000] clocksource: timebase mult[2580c0f8] shift[24] registered
[    0.000000] Console: colour dummy device 80x25
[    0.065080] pid_max: default: 32768 minimum: 301
[    0.095241] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.150665] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.198507] Mount-cache hash table entries: 256
[    0.227929] Brought up 4 CPUs
[    0.245823] devtmpfs: initialized
[    0.292353] NET: Registered protocol family 16
[    0.320203] IOMMU: Using strong ordering for fixed mapping
[    0.354609] IOMMU table initialized, virtual merging enabled
[    0.390317] IOMMU: Using strong ordering for fixed mapping
[    0.425782] ------------[ cut here ]------------
[    0.452982] WARNING: at /usr/src/linux-3.6.2/kernel/irq/irqdomain.c:743
[    0.492565] Modules linked in:
[    0.510796] NIP: c0000000000ba1e4 LR: c0000000000bb228 CTR: 0000000000000000
[    0.552986] REGS: c0000000fe65ba70 TRAP: 0700   Not tainted  (3.6.2)
[    0.591005] MSR: 9000000000029032 <SF,HV,EE,ME,IR,DR,RI>  CR: 84000082  XER: 00000000
[    0.637881] SOFTE: 1
[    0.650905] TASK = c0000000fe650000[1] 'swapper/0' THREAD: c0000000fe658000 CPU: 0
GPR00: c0000000000bb228 c0000000fe65bcf0 c0000000006677c0 c0000000fe006000 
GPR04: 000000000000027e 0000000000000000 ffffffffffffffff fffffffffffffffc 
GPR08: fffffffffffffffc 0000000000000001 c000000000675c10 c0000001fe64ccc0 
GPR12: 0000000084000084 c00000000fffb000 ffffffffffffffff 0000000002c0e498 
GPR16: 0000000000000060 000000000ead9738 0000000002c0e498 00000000037b7028 
GPR20: 00000000037b8012 0000000002c0e488 0000000002c0f9a0 0000000002c0f9a8 
GPR24: 0000000002c0f998 0000000000000031 0000000000000000 c0000000fe658000 
GPR28: c00000000040d0f0 000000000000027e c000000000613b10 c0000000fe006000 
[    1.017071] NIP [c0000000000ba1e4] .irq_linear_revmap+0x2c/0x50
[    1.052481] LR [c0000000000bb228] .irq_create_mapping+0x40/0x1d0
[    1.088415] Call Trace:
[    1.103003] [c0000000fe65bcf0] [c0000000000bb228] .irq_create_mapping+0x40/0x1d0 (unreliable)
[    1.154049] [c0000000fe65bd90] [c0000000003ef9d8] .__machine_initcall_cell_cbe_init_pm_irq+0x58/0x11c
[    1.209260] [c0000000fe65be20] [c000000000009a70] .do_one_initcall+0x168/0x1d0
[    1.252490] [c0000000fe65bee0] [c0000000003deb74] .kernel_init+0x14c/0x1f4
[    1.293638] [c0000000fe65bf90] [c00000000001b478] .kernel_thread+0x54/0x70
[    1.334776] Instruction dump:
[    1.352486] 60000000 81230010 69290002 7d290034 5529d97e 79290020 69290001 0b090000 
[    1.398841] 81230018 7d292010 39200000 7d294914 <0b090000> 2fa90000 40de0014 e9230020 
[    1.446250] ---[ end trace 1c1fafb330910489 ]---
[    1.473902] ------------[ cut here ]------------
[    1.501449] WARNING: at /usr/src/linux-3.6.2/kernel/irq/irqdomain.c:743
[    1.541032] Modules linked in:
[    1.559263] NIP: c0000000000ba1e4 LR: c0000000000bb228 CTR: 0000000000000000
[    1.601454] REGS: c0000000fe65ba70 TRAP: 0700   Tainted: G        W     (3.6.2)
[    1.645203] MSR: 9000000000029032 <SF,HV,EE,ME,IR,DR,RI>  CR: 84000082  XER: 00000000
[    1.692079] SOFTE: 1
[    1.705101] TASK = c0000000fe650000[1] 'swapper/0' THREAD: c0000000fe658000 CPU: 0
GPR00: c0000000000bb228 c0000000fe65bcf0 c0000000006677c0 c0000000fe006000 
GPR04: 000000000000037e 0000000000000000 ffffffffffffffff fffffffffffffff8 
GPR08: fffffffffffffff8 0000000000000001 c000000000675c10 c0000001fe64ccc0 
GPR12: 0000000084000084 c00000000fffb000 ffffffffffffffff 0000000002c0e498 
GPR16: 0000000000000060 000000000ead9738 0000000002c0e498 00000000037b7028 
GPR20: 00000000037b8012 0000000002c0e488 0000000002c0f9a0 0000000002c0f9a8 
GPR24: 0000000002c0f998 0000000000000031 0000000000000000 c0000000fe658000 
GPR28: c00000000040d0f0 000000000000037e c000000000613b10 c0000000fe006000 
[    2.071260] NIP [c0000000000ba1e4] .irq_linear_revmap+0x2c/0x50
[    2.106678] LR [c0000000000bb228] .irq_create_mapping+0x40/0x1d0
[    2.142612] Call Trace:
[    2.157200] [c0000000fe65bcf0] [c0000000000bb228] .irq_create_mapping+0x40/0x1d0 (unreliable)
[    2.208244] [c0000000fe65bd90] [c0000000003ef9d8] .__machine_initcall_cell_cbe_init_pm_irq+0x58/0x11c
[    2.263453] [c0000000fe65be20] [c000000000009a70] .do_one_initcall+0x168/0x1d0
[    2.306684] [c0000000fe65bee0] [c0000000003deb74] .kernel_init+0x14c/0x1f4
[    2.347832] [c0000000fe65bf90] [c00000000001b478] .kernel_thread+0x54/0x70
[    2.388974] Instruction dump:
[    2.406683] 60000000 81230010 69290002 7d290034 5529d97e 79290020 69290001 0b090000 
[    2.453038] 81230018 7d292010 39200000 7d294914 <0b090000> 2fa90000 40de0014 e9230020 
[    2.500436] ---[ end trace 1c1fafb33091048a ]---
[    2.528074] ------------[ cut here ]------------
[    2.555646] WARNING: at /usr/src/linux-3.6.2/kernel/irq/irqdomain.c:743
[    2.595230] Modules linked in:
[    2.613461] NIP: c0000000000ba1e4 LR: c0000000000bb228 CTR: 0000000000000000
[    2.655651] REGS: c0000000fe65ba70 TRAP: 0700   Tainted: G        W     (3.6.2)
[    2.699400] MSR: 9000000000029032 <SF,HV,EE,ME,IR,DR,RI>  CR: 84000082  XER: 00000000
[    2.746276] SOFTE: 1
[    2.759298] TASK = c0000000fe650000[1] 'swapper/0' THREAD: c0000000fe658000 CPU: 0
GPR00: c0000000000bb228 c0000000fe65bcf0 c0000000006677c0 c0000000fe006000 
GPR04: 000000000000047e 0000000000000000 ffffffffffffffff fffffffffffffff0 
GPR08: fffffffffffffff0 0000000000000001 c000000000675c10 c0000001fe64ccc0 
GPR12: 0000000084000084 c00000000fffb000 ffffffffffffffff 0000000002c0e498 
GPR16: 0000000000000060 000000000ead9738 0000000002c0e498 00000000037b7028 
GPR20: 00000000037b8012 0000000002c0e488 0000000002c0f9a0 0000000002c0f9a8 
GPR24: 0000000002c0f998 0000000000000031 0000000000000000 c0000000fe658000 
GPR28: c00000000040d0f0 000000000000047e c000000000613b10 c0000000fe006000 
[    3.125458] NIP [c0000000000ba1e4] .irq_linear_revmap+0x2c/0x50
[    3.160875] LR [c0000000000bb228] .irq_create_mapping+0x40/0x1d0
[    3.196810] Call Trace:
[    3.211398] [c0000000fe65bcf0] [c0000000000bb228] .irq_create_mapping+0x40/0x1d0 (unreliable)
[    3.262441] [c0000000fe65bd90] [c0000000003ef9d8] .__machine_initcall_cell_cbe_init_pm_irq+0x58/0x11c
[    3.317651] [c0000000fe65be20] [c000000000009a70] .do_one_initcall+0x168/0x1d0
[    3.360881] [c0000000fe65bee0] [c0000000003deb74] .kernel_init+0x14c/0x1f4
[    3.402028] [c0000000fe65bf90] [c00000000001b478] .kernel_thread+0x54/0x70
[    3.443171] Instruction dump:
[    3.460880] 60000000 81230010 69290002 7d290034 5529d97e 79290020 69290001 0b090000 
[    3.507236] 81230018 7d292010 39200000 7d294914 <0b090000> 2fa90000 40de0014 e9230020 
[    3.554634] ---[ end trace 1c1fafb33091048b ]---
[    3.582273] ------------[ cut here ]------------
[    3.609844] WARNING: at /usr/src/linux-3.6.2/kernel/irq/irqdomain.c:743
[    3.649427] Modules linked in:
[    3.667659] NIP: c0000000000ba1e4 LR: c0000000000bb228 CTR: 0000000000000000
[    3.709848] REGS: c0000000fe65ba70 TRAP: 0700   Tainted: G        W     (3.6.2)
[    3.753598] MSR: 9000000000029032 <SF,HV,EE,ME,IR,DR,RI>  CR: 84000082  XER: 00000000
[    3.800474] SOFTE: 1
[    3.813496] TASK = c0000000fe650000[1] 'swapper/0' THREAD: c0000000fe658000 CPU: 0
GPR00: c0000000000bb228 c0000000fe65bcf0 c0000000006677c0 c0000000fe006000 
GPR04: 000000000000057e 0000000000000000 ffffffffffffffff ffffffffffffffe0 
GPR08: ffffffffffffffe0 0000000000000001 c000000000675c10 c0000001fe64ccc0 
GPR12: 0000000084000084 c00000000fffb000 ffffffffffffffff 0000000002c0e498 
GPR16: 0000000000000060 000000000ead9738 0000000002c0e498 00000000037b7028 
GPR20: 00000000037b8012 0000000002c0e488 0000000002c0f9a0 0000000002c0f9a8 
GPR24: 0000000002c0f998 0000000000000031 0000000000000000 c0000000fe658000 
GPR28: c00000000040d0f0 000000000000057e c000000000613b10 c0000000fe006000 
[    4.179655] NIP [c0000000000ba1e4] .irq_linear_revmap+0x2c/0x50
[    4.215072] LR [c0000000000bb228] .irq_create_mapping+0x40/0x1d0
[    4.251008] Call Trace:
[    4.265595] [c0000000fe65bcf0] [c0000000000bb228] .irq_create_mapping+0x40/0x1d0 (unreliable)
[    4.316638] [c0000000fe65bd90] [c0000000003ef9d8] .__machine_initcall_cell_cbe_init_pm_irq+0x58/0x11c
[    4.371848] [c0000000fe65be20] [c000000000009a70] .do_one_initcall+0x168/0x1d0
[    4.415078] [c0000000fe65bee0] [c0000000003deb74] .kernel_init+0x14c/0x1f4
[    4.456225] [c0000000fe65bf90] [c00000000001b478] .kernel_thread+0x54/0x70
[    4.497369] Instruction dump:
[    4.515077] 60000000 81230010 69290002 7d290034 5529d97e 79290020 69290001 0b090000 
[    4.561433] 81230018 7d292010 39200000 7d294914 <0b090000> 2fa90000 40de0014 e9230020 
[    4.608831] ---[ end trace 1c1fafb33091048c ]---
[    4.636475] ------------[ cut here ]------------
[    4.664041] WARNING: at /usr/src/linux-3.6.2/kernel/irq/irqdomain.c:743
[    4.703625] Modules linked in:
[    4.721856] NIP: c0000000000ba1e4 LR: c0000000000bb228 CTR: 0000000000000000
[    4.764045] REGS: c0000000fe65ba70 TRAP: 0700   Tainted: G        W     (3.6.2)
[    4.807795] MSR: 9000000000029032 <SF,HV,EE,ME,IR,DR,RI>  CR: 84000082  XER: 00000000
[    4.854671] SOFTE: 1
[    4.867694] TASK = c0000000fe650000[1] 'swapper/0' THREAD: c0000000fe658000 CPU: 0
GPR00: c0000000000bb228 c0000000fe65bcf0 c0000000006677c0 c0000000fe006000 
GPR04: 000000000000067e 0000000000000000 ffffffffffffffff ffffffffffffffc0 
GPR08: ffffffffffffffc0 0000000000000001 c000000000675c10 c0000001fe64ccc0 
GPR12: 0000000084000084 c00000000fffb000 ffffffffffffffff 0000000002c0e498 
GPR16: 0000000000000060 000000000ead9738 0000000002c0e498 00000000037b7028 
GPR20: 00000000037b8012 0000000002c0e488 0000000002c0f9a0 0000000002c0f9a8 
GPR24: 0000000002c0f998 0000000000000031 0000000000000000 c0000000fe658000 
GPR28: c00000000040d0f0 000000000000067e c000000000613b10 c0000000fe006000 
[    5.233853] NIP [c0000000000ba1e4] .irq_linear_revmap+0x2c/0x50
[    5.269270] LR [c0000000000bb228] .irq_create_mapping+0x40/0x1d0
[    5.305205] Call Trace:
[    5.319792] [c0000000fe65bcf0] [c0000000000bb228] .irq_create_mapping+0x40/0x1d0 (unreliable)
[    5.370836] [c0000000fe65bd90] [c0000000003ef9d8] .__machine_initcall_cell_cbe_init_pm_irq+0x58/0x11c
[    5.426046] [c0000000fe65be20] [c000000000009a70] .do_one_initcall+0x168/0x1d0
[    5.469275] [c0000000fe65bee0] [c0000000003deb74] .kernel_init+0x14c/0x1f4
[    5.510423] [c0000000fe65bf90] [c00000000001b478] .kernel_thread+0x54/0x70
[    5.551567] Instruction dump:
[    5.569275] 60000000 81230010 69290002 7d290034 5529d97e 79290020 69290001 0b090000 
[    5.615630] 81230018 7d292010 39200000 7d294914 <0b090000> 2fa90000 40de0014 e9230020 
[    5.663028] ---[ end trace 1c1fafb33091048d ]---
[    5.690667] ------------[ cut here ]------------
[    5.718239] WARNING: at /usr/src/linux-3.6.2/kernel/irq/irqdomain.c:743
[    5.757823] Modules linked in:
[    5.776054] NIP: c0000000000ba1e4 LR: c0000000000bb228 CTR: 0000000000000000
[    5.818243] REGS: c0000000fe65ba70 TRAP: 0700   Tainted: G        W     (3.6.2)
[    5.861993] MSR: 9000000000029032 <SF,HV,EE,ME,IR,DR,RI>  CR: 84000082  XER: 00000000
[    5.908868] SOFTE: 1
[    5.921891] TASK = c0000000fe650000[1] 'swapper/0' THREAD: c0000000fe658000 CPU: 0
GPR00: c0000000000bb228 c0000000fe65bcf0 c0000000006677c0 c0000000fe006000 
GPR04: 000000000000077e 0000000000000000 ffffffffffffffff ffffffffffffff80 
GPR08: ffffffffffffff80 0000000000000001 c000000000675c10 c0000001fe64ccc0 
GPR12: 0000000084000084 c00000000fffb000 ffffffffffffffff 0000000002c0e498 
GPR16: 0000000000000060 000000000ead9738 0000000002c0e498 00000000037b7028 
GPR20: 00000000037b8012 0000000002c0e488 0000000002c0f9a0 0000000002c0f9a8 
GPR24: 0000000002c0f998 0000000000000031 0000000000000000 c0000000fe658000 
GPR28: c00000000040d0f0 000000000000077e c000000000613b10 c0000000fe006000 
[    6.288050] NIP [c0000000000ba1e4] .irq_linear_revmap+0x2c/0x50
[    6.323467] LR [c0000000000bb228] .irq_create_mapping+0x40/0x1d0
[    6.359403] Call Trace:
[    6.373990] [c0000000fe65bcf0] [c0000000000bb228] .irq_create_mapping+0x40/0x1d0 (unreliable)
[    6.425033] [c0000000fe65bd90] [c0000000003ef9d8] .__machine_initcall_cell_cbe_init_pm_irq+0x58/0x11c
[    6.480243] [c0000000fe65be20] [c000000000009a70] .do_one_initcall+0x168/0x1d0
[    6.523473] [c0000000fe65bee0] [c0000000003deb74] .kernel_init+0x14c/0x1f4
[    6.564621] [c0000000fe65bf90] [c00000000001b478] .kernel_thread+0x54/0x70
[    6.605763] Instruction dump:
[    6.623472] 60000000 81230010 69290002 7d290034 5529d97e 79290020 69290001 0b090000 
[    6.669828] 81230018 7d292010 39200000 7d294914 <0b090000> 2fa90000 40de0014 e9230020 
[    6.717227] ---[ end trace 1c1fafb33091048e ]---
[    6.744864] ------------[ cut here ]------------
[    6.7724OFTE: 1
[    6.976088] TASK = c0000000fe650000[1] 'swapper/0' THREAD: c0000000fe658000 CPU: 0
GPR00: c0000000000bb228 c0000000fe65bcf0 c0000000006677c0 c0000000fe006000 
GPR04: 000000000000087e 0000000000000000 ffffffffffffffff ffffffffffffff00 
GPR08: ffffffffffffff00 0000000000000001 c000000000675c10 c0000001fe64ccc0 
GPR12: 0000000084000084 c00000000fffb000 ffffffffffffffff 0000000002c0e498 
GPR16: 0000000000000060 000000000ead9738 0000000002c0e498 00000000037b7028 
GPR20: 00000000037b8012 0000000002c0e488 0000000002c0f9a0 0000000002c0f9a8 
GPR24: 0000000002c0f998 0000000000000031 0000000000000000 c0000000fe658000 
GPR28: c00000000040d0f0 000000000000087e c000000000613b10 c0000000fe006000 
[    7.342248] NIP [c0000000000ba1e4] .irq_linear_revmap+0x2c/0x50
[    7.377664] LR [c0000000000bb228] .irq_create_mapping+0x40/0x1d0
[    7.413600] Call Trace:
[    7.428187] [c0000000fe65bcf0] [c0000000000bb228] .irq_create_mapping+0x40/0x1d0 (unreliable)
[    7.479231] [c0000000fe65bd90] [c0000000003ef9d8] .__machine_initcall_cell_cbe_init_pm_irq+0x58/0x11c
[    7.534441] [c0000000fe65be20] [c000000000009a70] .do_one_initcall+0x168/0x1d0
[    7.577671] [c0000000fe65bee0] [c0000000003deb74] .kernel_init+0x14c/0x1f4
[    7.618818] [c0000000fe65bf90] [c00000000001b478] .kernel_thread+0x54/0x70
[    7.659961] Instruction dump:
[    7.677670] 60000000 81230010 69290002 7d290034 5529d97e 79290020 69290001 0b090000 
[    7.724026] 81230018 7d292010 39200000 7d294914 <0b090000> 2fa90000 40de0014 e9230020 
[    7.771423] ---[ end trace 1c1fafb33091048f ]---
[    7.799075] ------------[ cut here ]------------
[    7.826634] WARNING: at /usr/src/linux-3.6.2/kernel/irq/irqdomain.c:743
[    7.866217] Modules linked in:
[    7.884449] NIP: c0000000000ba1e4 LR: c0000000000bb228 CTR: 0000000000000000
[    7.926638] REGS: c0000000fe65ba70 TRAP: 0700   Tainted: G        W     (3.6.2)
[    7.970387] MSR: 9000000000029032 <SF,HV,EE,ME,IR,DR,RI>  CR: 84000082  XER: 00000000
[    8.017264] SOFTE: 1
[    8.030287] TASK = c0000000fe650000[1] 'swapper/0' THREAD: c0000000fe658000 CPU: 0
GPR00: c0000000000bb228 c0000000fe65bcf0 c0000000006677c0 c0000000fe006000 
GPR04: 000000000000097e 0000000000000000 ffffffffffffffff fffffffffffffe00 
GPR08: fffffffffffffe00 0000000000000001 c000000000675c10 c0000001fe64ccc0 
GPR12: 0000000084000084 c00000000fffb000 ffffffffffffffff 0000000002c0e498 
GPR16: 0000000000000060 000000000ead9738 0000000002c0e498 00000000037b7028 
GPR20: 00000000037b8012 0000000002c0e488 0000000002c0f9a0 0000000002c0f9a8 
GPR24: 0000000002c0f998 0000000000000031 0000000000000000 c0000000fe658000 
GPR28: c00000000040d0f0 000000000000097e c000000000613b10 c0000000fe006000 
[    8.396446] NIP [c0000000000ba1e4] .irq_linear_revmap+0x2c/0x50
[    8.431862] LR [c0000000000bb228] .irq_create_mapping+0x40/0x1d0
[    8.467797] Call Trace:
[    8.482385] [c0000000fe65bcf0] [c0000000000bb228] .irq_create_mapping+0x40/0x1d0 (unreliable)
[    8.533429] [c0000000fe65bd90] [c0000000003ef9d8] .__machine_initcall_000002c0f9a8 
GPR24: 0000000002c0f998 0000000000000031 0000000000000000 c0000000fe658000 
GPR28: c00000000040d0f0 0000000000000a7e c000000000613b10 c0000000fe006000 
[    9.450643] NIP [c0000000000ba1e4] .irq_linear_revmap+0x2c/0x50
[    9.486060] LR [c0000000000bb228] .irq_create_mapping+0x40/0x1d0
[    9.521995] Call Trace:
[    9.536583] [c0000000fe65bcf0] [c0000000000bb228] .irq_create_mapping+0x40/0x1d0 (unreliable)
[    9.587626] [c0000000fe65bd90] [c0000000003ef9d8] .__machine_initcall_cell_cbe_init_pm_irq+0x58/0x11c
[    9.642836] [c0000000fe65be20] [c000000000009a70] .do_one_initcall+0x168/0x1d0
[    9.686066] [c0000000fe65bee0] [c0000000003deb74] .kernel_init+0x14c/0x1f4
[    9.727213] [c0000000fe65bf90] [c00000000001b478] .kernel_thread+0x54/0x70
[    9.768357] Instruction dump:
[    9.786066] 60000000 81230010 69290002 7d290034 5529d97e 79290020 69290001 0b090000 
[    9.832420] 81230018 7d292010 39200000 7d294914 <0b090000> 2fa90000 40de0014 e9230020 
[   
system:blade[3]> 

--nextPart2710719.TDxhTB7GYc
Content-Disposition: attachment; filename="blade02-3.6.2-gentoo.config.diff"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-patch; charset="UTF-8"; name="blade02-3.6.2-gentoo.config.diff"

--- build-3.5.3-gentoo/.config	2012-09-15 18:45:36.496634068 +0200
+++ build-3.6.2-gentoo/.config	2012-10-17 15:26:52.285239283 +0200
@@ -1,6 +1,6 @@
 #
 # Automatically generated file; DO NOT EDIT.
-# Linux/powerpc 3.5.3-gentoo Kernel Configuration
+# Linux/powerpc 3.6.2-gentoo Kernel Configuration
 #
 CONFIG_PPC64=y
 
@@ -190,6 +190,8 @@
 CONFIG_HAVE_ARCH_JUMP_LABEL=y
 CONFIG_HAVE_RCU_TABLE_FREE=y
 CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
+CONFIG_ARCH_WANT_IPC_PARSE_VERSION=y
+CONFIG_ARCH_WANT_COMPAT_IPC_PARSE_VERSION=y
 CONFIG_ARCH_WANT_OLD_COMPAT_IPC=y
 
 #
@@ -293,6 +295,7 @@
 # CONFIG_PQ2ADS is not set
 # CONFIG_PPC_WSP is not set
 # CONFIG_KVM_GUEST is not set
+# CONFIG_EPAPR_PARAVIRT is not set
 CONFIG_PPC_NATIVE=y
 CONFIG_PPC_OF_BOOT_TRAMPOLINE=y
 CONFIG_UDBG_RTAS_CONSOLE=y
@@ -349,6 +352,7 @@
 CONFIG_CPU_IDLE=y
 CONFIG_CPU_IDLE_GOV_LADDER=y
 CONFIG_CPU_IDLE_GOV_MENU=y
+# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
 CONFIG_AXON_RAM=m
 # CONFIG_FSL_ULI1575 is not set
 CONFIG_SIMPLE_GPIO=y
@@ -393,6 +397,7 @@
 CONFIG_SPARSEMEM_VMEMMAP=y
 CONFIG_HAVE_MEMBLOCK=y
 CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
+CONFIG_MEMORY_ISOLATION=y
 CONFIG_MEMORY_HOTPLUG=y
 CONFIG_MEMORY_HOTPLUG_SPARSE=y
 # CONFIG_MEMORY_HOTREMOVE is not set
@@ -655,7 +660,6 @@
 CONFIG_SCSI_CONSTANTS=y
 # CONFIG_SCSI_LOGGING is not set
 CONFIG_SCSI_SCAN_ASYNC=y
-CONFIG_SCSI_WAIT_SCAN=m
 
 #
 # SCSI Transports
@@ -776,6 +780,7 @@
 # CONFIG_VITESSE_PHY is not set
 # CONFIG_SMSC_PHY is not set
 # CONFIG_BROADCOM_PHY is not set
+# CONFIG_BCM87XX_PHY is not set
 # CONFIG_ICPLUS_PHY is not set
 # CONFIG_REALTEK_PHY is not set
 # CONFIG_NATIONAL_PHY is not set
@@ -944,6 +949,7 @@
 # PCI GPIO expanders:
 #
 # CONFIG_GPIO_BT8XX is not set
+# CONFIG_GPIO_AMD8111 is not set
 # CONFIG_GPIO_ML_IOH is not set
 # CONFIG_GPIO_RDC321X is not set
 
@@ -960,6 +966,7 @@
 #
 # CONFIG_W1 is not set
 # CONFIG_POWER_SUPPLY is not set
+# CONFIG_POWER_AVS is not set
 # CONFIG_HWMON is not set
 # CONFIG_THERMAL is not set
 # CONFIG_WATCHDOG is not set
@@ -1019,6 +1026,7 @@
 #
 CONFIG_HID=m
 # CONFIG_HIDRAW is not set
+# CONFIG_UHID is not set
 CONFIG_HID_GENERIC=m
 
 #
@@ -1044,6 +1052,7 @@
 # CONFIG_HID_TWINHAN is not set
 CONFIG_HID_KENSINGTON=m
 # CONFIG_HID_LCPOWER is not set
+# CONFIG_HID_LENOVO_TPKBD is not set
 CONFIG_HID_LOGITECH=m
 CONFIG_HID_LOGITECH_DJ=m
 # CONFIG_LOGITECH_FF is not set
@@ -1223,6 +1232,7 @@
 #
 # Reporting subsystems
 #
+# CONFIG_EDAC_LEGACY_SYSFS is not set
 # CONFIG_EDAC_DEBUG is not set
 CONFIG_EDAC_MM_EDAC=m
 CONFIG_EDAC_CELL=m
@@ -1285,6 +1295,7 @@
 # Hardware Spinlock drivers
 #
 CONFIG_IOMMU_SUPPORT=y
+CONFIG_OF_IOMMU=y
 
 #
 # Remoteproc drivers (EXPERIMENTAL)
@@ -1299,6 +1310,7 @@
 # CONFIG_MEMORY is not set
 # CONFIG_IIO is not set
 # CONFIG_VME_BUS is not set
+# CONFIG_PWM is not set
 
 #
 # File systems
@@ -1405,10 +1417,11 @@
 # CONFIG_UFS_FS is not set
 CONFIG_NETWORK_FILESYSTEMS=y
 CONFIG_NFS_FS=m
-CONFIG_NFS_V2=y
-CONFIG_NFS_V3=y
+CONFIG_NFS_V2=m
+CONFIG_NFS_V3=m
 CONFIG_NFS_V3_ACL=y
-CONFIG_NFS_V4=y
+CONFIG_NFS_V4=m
+# CONFIG_NFS_SWAP is not set
 CONFIG_NFS_FSCACHE=y
 # CONFIG_NFS_USE_LEGACY_DNS is not set
 CONFIG_NFS_USE_KERNEL_DNS=y
@@ -1522,6 +1535,7 @@
 CONFIG_CPU_RMAP=y
 CONFIG_DQL=y
 CONFIG_NLATTR=y
+CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
 # CONFIG_AVERAGE is not set
 # CONFIG_CORDIC is not set
 # CONFIG_DDR is not set

--nextPart2710719.TDxhTB7GYc--

--nextPart1606955.5DYn9EG7bF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEABECAAYFAlB/370ACgkQjqfyF1DtJW5UEwCaA3olWxeC7+FOtR7Zt3+dE9rC
mG4AoJTejsnCEilb0NWZh3lmqIONSUm2
=4Z5F
-----END PGP SIGNATURE-----

--nextPart1606955.5DYn9EG7bF--

