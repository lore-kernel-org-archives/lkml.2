Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758514Ab0I0LWM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 07:22:12 -0400
Received: from mx4-phx2.redhat.com ([209.132.183.25]:36996 "EHLO
	mx02.colomx.prod.int.phx2.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755239Ab0I0LWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 07:22:10 -0400
Date: Mon, 27 Sep 2010 07:21:52 -0400 (EDT)
From: caiqian@redhat.com
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, kexec <kexec@lists.infradead.org>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Message-ID: <632974489.2046131285586512527.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
In-Reply-To: <1909915255.2046011285586388234.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
Subject: Re: kexec load failure introduced by "x86, memblock: Replace
 e820_/_early string with memblock_"
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.5.71]
X-Mailer: Zimbra 5.0.21_GA_3150.RHEL4_64 (ZimbraWebClient - FF3.0 (Linux)/5.0.21_GA_3150.RHEL4_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- "CAI Qian" <caiqian@redhat.com> wrote:

> ----- "Yinghai Lu" <yinghai@kernel.org> wrote:
> 
> > Please check this one on top of tip or next.
> This failed for both trees.
> [root@localhost linux-next]# patch -Np1 <memblock.patch
> patching file arch/x86/kernel/setup.c
> Hunk #1 FAILED at 516.
> 1 out of 1 hunk FAILED -- saving rejects to file
> arch/x86/kernel/setup.c.rej
After manually applied the patch on the top of the latest mmotm tree, now there was no /proc/vmcore exported to the second kernel anymore. It could be the results of other recent commits in mmotm though. It said,

Warning: Core image elf header is notsane
Kdump: vmcore not initialized

Here is the dmesg from the second kernel,

Initializing cgroup subsys cpuset
Linux version 2.6.36-rc5-mm1+ (root@localhost.localdomain) (gcc version 4.4.4 20100726 (Red Hat 4.4.4-13) (GCC) ) #6 SMP Mon Sep 27 07:00:15 EDT 2010
Command line: ro root=/dev/mapper/VolGroup-lv_root rd_LVM_LV=VolGroup/lv_root rd_LVM_LV=VolGroup/lv_swap rd_NO_LUKS rd_NO_MD rd_NO_DM LANG=en_US.UTF-8 SYSFONT=latarcyrheb-sun16 KEYBOARDTYPE=pc KEYTABLE=us rhgb quiet console=tty0 console=ttyS0,115200 crashkernel=128M irqpoll maxcpus=1 reset_devices cgroup_disable=memory  memmap=exactmap memmap=640K@0K memmap=130408K@32768K elfcorehdr=163176K kexec_jump_back_entry=0x000000000232f063
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000100 - 000000000009f400 (usable)
 BIOS-e820: 000000000009f400 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000dfffb000 (usable)
 BIOS-e820: 00000000dfffb000 - 00000000e0000000 (reserved)
 BIOS-e820: 00000000fffbc000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000ca0000000 (usable)
last_pfn = 0xca0000 max_arch_pfn = 0x400000000
NX (Execute Disable) protection: active
user-defined physical RAM map:
 user: 0000000000000000 - 00000000000a0000 (usable)
 user: 0000000002000000 - 0000000009f5a000 (usable)
DMI 2.4 present.
e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
No AGP bridge found
last_pfn = 0x9f5a max_arch_pfn = 0x400000000
MTRR default type: write-back
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-BFFFF uncachable
  C0000-FFFFF write-protect
MTRR variable ranges enabled:
  0 base 00E0000000 mask FFE0000000 uncachable
  1 disabled
  2 disabled
  3 disabled
  4 disabled
  5 disabled
  6 disabled
  7 disabled
PAT not supported by CPU.
found SMP MP-table at [ffff8800000f7fb0] f7fb0
initial memory mapped : 0 - 20000000
init_memory_mapping: 0000000000000000-0000000009f5a000
 0000000000 - 0009e00000 page 2M
 0009e00000 - 0009f5a000 page 4k
kernel direct mapping tables up to 9f5a000 @ 9f57000-9f5a000
RAMDISK: 09ae5000 - 09f49000
crashkernel reservation failed - No suitable area found.
ACPI: RSDP 00000000000f7f60 00014 (v00 BOCHS )
ACPI: RSDT 00000000dfffd890 00030 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
ACPI: FACP 00000000dffffa30 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
ACPI: DSDT 00000000dfffdb70 01E4B (v01   BXPC   BXDSDT 00000001 INTL 20090123)
ACPI: FACS 00000000dffff9c0 00040
ACPI: SSDT 00000000dfffda40 0012F (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
ACPI: APIC 00000000dfffd8c0 0010A (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
ACPI: Local APIC address 0xfee00000
No NUMA configuration found
Faking a node at 0000000000000000-0000000009f5a000
Initmem setup node 0 0000000000000000-0000000009f5a000
  NODE_DATA [0000000009abe000 - 0000000009ae4fff]
kvm-clock: Using msrs 12 and 11
kvm-clock: cpu 0, msr 0:28c3741, boot clock
 [ffffea0000000000-ffffea00003fffff] PMD -> [ffff880008e00000-ffff8800091fffff] on node 0
sizeof(struct page) = 56
Zone PFN ranges:
  DMA      0x00000010 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   empty
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000010 -> 0x000000a0
    0: 0x00002000 -> 0x00009f5a
On node 0 totalpages: 32746
  DMA zone: 56 pages used for memmap
  DMA zone: 7 pages reserved
  DMA zone: 81 pages, LIFO batch:0
  DMA32 zone: 502 pages used for memmap
  DMA32 zone: 32100 pages, LIFO batch:7
ACPI: PM-Timer IO Port: 0xb008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x04] enabled)
ACPI: LAPIC (acpi_id[0x05] lapic_id[0x05] enabled)
ACPI: LAPIC (acpi_id[0x06] lapic_id[0x06] enabled)
ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] enabled)
ACPI: LAPIC (acpi_id[0x08] lapic_id[0x08] enabled)
ACPI: LAPIC (acpi_id[0x09] lapic_id[0x09] enabled)
ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x0a] enabled)
ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x0b] enabled)
ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x0c] enabled)
ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x0d] enabled)
ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x0e] enabled)
ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x0f] enabled)
ACPI: LAPIC (acpi_id[0x10] lapic_id[0x10] enabled)
ACPI: LAPIC (acpi_id[0x11] lapic_id[0x11] enabled)
ACPI: LAPIC (acpi_id[0x12] lapic_id[0x12] enabled)
ACPI: LAPIC (acpi_id[0x13] lapic_id[0x13] enabled)
ACPI: IOAPIC (id[0x14] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 20, version 17, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ5 used by override.
ACPI: IRQ9 used by override.
ACPI: IRQ10 used by override.
ACPI: IRQ11 used by override.
Using ACPI (MADT) for SMP configuration information
SMP: Allowing 20 CPUs, 0 hotplug CPUs
nr_irqs_gsi: 40
PM: Registered nosave memory: 00000000000a0000 - 0000000002000000
Allocating PCI resources starting at 9f5a000 (gap: 9f5a000:f60a6000)
Booting paravirtualized kernel on KVM
setup_percpu: NR_CPUS:4096 nr_cpumask_bits:20 nr_cpu_ids:20 nr_node_ids:1
PERCPU: Embedded 29 pages/cpu @ffff880009400000 s86912 r8192 d23680 u262144
pcpu-alloc: s86912 r8192 d23680 u262144 alloc=1*2097152
pcpu-alloc: [0] 00 01 02 03 04 05 06 07 [0] 08 09 10 11 12 13 14 15 
pcpu-alloc: [0] 16 17 18 19 -- -- -- -- 
kvm-clock: cpu 0, msr 0:9414741, primary cpu clock
Built 1 zonelists in Node order, mobility grouping on.  Total pages: 32181
Policy zone: DMA32
Kernel command line: ro root=/dev/mapper/VolGroup-lv_root rd_LVM_LV=VolGroup/lv_root rd_LVM_LV=VolGroup/lv_swap rd_NO_LUKS rd_NO_MD rd_NO_DM LANG=en_US.UTF-8 SYSFONT=latarcyrheb-sun16 KEYBOARDTYPE=pc KEYTABLE=us rhgb quiet console=tty0 console=ttyS0,115200 crashkernel=128M irqpoll maxcpus=1 reset_devices cgroup_disable=memory  memmap=exactmap memmap=640K@0K memmap=130408K@32768K elfcorehdr=163176K kexec_jump_back_entry=0x000000000232f063
Misrouted IRQ fixup and polling support enabled
This may significantly impact system performance
Disabling memory control group subsystem
PID hash table entries: 512 (order: 0, 4096 bytes)
Checking aperture...
No AGP bridge found
Memory: 103484k/163176k available (4267k kernel code, 32192k absent, 27500k reserved, 4617k data, 2484k init)
Hierarchical RCU implementation.
	RCU-based detection of stalled CPUs is disabled.
	Verbose stalled-CPUs detection is disabled.
NR_IRQS:262400 nr_irqs:840
Spurious LAPIC timer interrupt on cpu 0
Console: colour VGA+ 80x25
console [tty0] enabled
console [ttyS0] enabled
Detected 1995.358 MHz processor.
Calibrating delay loop (skipped) preset value.. 3990.71 BogoMIPS (lpj=1995358)
pid_max: default: 32768 minimum: 301
Security Framework initialized
SELinux:  Initializing.
SELinux:  Starting in permissive mode
Dentry cache hash table entries: 16384 (order: 5, 131072 bytes)
Inode-cache hash table entries: 8192 (order: 4, 65536 bytes)
Mount-cache hash table entries: 256
Initializing cgroup subsys ns
Initializing cgroup subsys cpuacct
Initializing cgroup subsys memory
Initializing cgroup subsys devices
Initializing cgroup subsys freezer
Initializing cgroup subsys net_cls
mce: CPU supports 10 MCE banks
Performance Events: p6 PMU driver.
... version:                0
... bit width:              32
... generic registers:      2
... value mask:             00000000ffffffff
... max period:             000000007fffffff
... fixed-purpose events:   0
... event mask:             0000000000000003
SMP alternatives: switching to UP code
ACPI: Core revision 20100702
Setting APIC routing to physical flat
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel QEMU Virtual CPU version (cpu64-rhel6) stepping 03
Brought up 1 CPUs
Total of 1 processors activated (3990.71 BogoMIPS).
devtmpfs: initialized
regulator: core version 0.5
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
IRQ 9: starting IRQFIXUP_POLL
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: No dock devices found.
PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
pci_root PNP0A03:00: host bridge window [mem 0xe0000000-0xfebfffff] (ignored)
pci 0000:00:01.1: reg 20: [io  0xc000-0xc00f]
pci 0000:00:01.2: reg 20: [io  0xc020-0xc03f]
pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
pci 0000:00:02.0: reg 10: [mem 0xf0000000-0xf1ffffff pref]
pci 0000:00:02.0: reg 14: [mem 0xf2000000-0xf2000fff]
pci 0000:00:02.0: reg 30: [mem 0xf2010000-0xf201ffff pref]
pci 0000:00:03.0: reg 10: [io  0xc100-0xc1ff]
pci 0000:00:03.0: reg 14: [mem 0xf2020000-0xf20200ff]
pci 0000:00:03.0: reg 30: [mem 0xf2030000-0xf203ffff pref]
pci 0000:00:04.0: reg 10: [io  0xc400-0xc7ff]
pci 0000:00:04.0: reg 14: [io  0xc800-0xc8ff]
pci 0000:00:05.0: reg 10: [io  0xc900-0xc91f]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
ACPI: PCI Interrupt Link [LNKB] (IRQs 5 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
vgaarb: loaded
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: pci_cache_line_size set to 64 bytes
reserve RAM buffer: 0000000009f5a000 - 000000000bffffff 
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
Switching to clocksource kvm-clock
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 6 devices
ACPI: ACPI bus type pnp unregistered
pci_bus 0000:00: resource 0 [io  0x0000-0xffff]
pci_bus 0000:00: resource 1 [mem 0x00000000-0xffffffffffffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 1024 (order: 1, 8192 bytes)
TCP established hash table entries: 4096 (order: 4, 65536 bytes)
TCP bind hash table entries: 4096 (order: 4, 65536 bytes)
TCP: Hash tables configured (established 4096 bind 4096)
TCP reno registered
UDP hash table entries: 128 (order: 0, 4096 bytes)
UDP-Lite hash table entries: 128 (order: 0, 4096 bytes)
NET: Registered protocol family 1
pci 0000:00:00.0: Limiting direct PCI/PCI transfers
pci 0000:00:01.0: Activating ISA DMA hang workarounds
pci 0000:00:02.0: Boot video device
PCI: CLS 64 bytes, default 64
Trying to unpack rootfs image as initramfs...
Freeing initrd memory: 4496k freed
audit: initializing netlink socket (disabled)
type=2000 audit(1285586109.207:1): initialized
HugeTLB registered 2 MB page size, pre-allocated 0 pages
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
Warning: Core image elf header is notsane
Kdump: vmcore not initialized

> 
> >
> > Thanks
> >
> > Yinghai
> >
> > [PATCH] x86, memblock: Fix crashkernel allocation
> >
> > Cai Qian found that crashkernel is broken with x86 memblock changes
> > 1. crashkernel=128M@32M always reported that range is used, even
> first
> > kernel is small
> >    no one use that range
> > 2. always get following report when using "kexec -p"
> > 	Could not find a free area of memory of a000 bytes...
> > 	locate_hole failed
> >
> > The root cause is that generic memblock_find_in_range() will try to
> > get range from top_down.
> > But crashkernel do need from low and specified range.
> >
> > Let's limit the target range with rash_base + crash_size to make
> sure
> > that
> > We get range from bottom.
> >
> > Reported-and-Bisected-by: CAI Qian <caiqian@redhat.com>
> > Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> >
> > ---
> >  arch/x86/kernel/setup.c |   19 ++++++++++++++-----
> >  1 file changed, 14 insertions(+), 5 deletions(-)
> >
> > Index: linux-2.6/arch/x86/kernel/setup.c
> > ===================================================================
> > --- linux-2.6.orig/arch/x86/kernel/setup.c
> > +++ linux-2.6/arch/x86/kernel/setup.c
> > @@ -516,19 +516,28 @@ static void __init reserve_crashkernel(v
> >
> >  	/* 0 means: find the address automatically */
> >  	if (crash_base <= 0) {
> > +		unsigned long long start = 0;
> >  		const unsigned long long alignment = 16<<20;	/* 16M */
> >
> > -		crash_base = memblock_find_in_range(alignment, ULONG_MAX,
> > crash_size,
> > -				 alignment);
> > -		if (crash_base == MEMBLOCK_ERROR) {
> > +		crash_base = alignment;
> > +		while (crash_base < 0xffffffff) {
> > +			start = memblock_find_in_range(crash_base,
> > +				crash_base + crash_size, crash_size, alignment);
> > +
> > +			if (start == crash_base)
> > +				break;
> > +
> > +			crash_base += alignment;
> > +		}
> > +		if (start != crash_base) {
> >  			pr_info("crashkernel reservation failed - No suitable area
> > found.\n");
> >  			return;
> >  		}
> >  	} else {
> >  		unsigned long long start;
> >
> > -		start = memblock_find_in_range(crash_base, ULONG_MAX, crash_size,
> > -				 1<<20);
> > +		start = memblock_find_in_range(crash_base,
> > +				 crash_base + crash_size, crash_size, 1<<20);
> >  		if (start != crash_base) {
> >  			pr_info("crashkernel reservation failed - memory is in use.\n");
> >  			return;
> >
> > _______________________________________________
> > kexec mailing list
> > kexec@lists.infradead.org
> > http://lists.infradead.org/mailman/listinfo/kexec
