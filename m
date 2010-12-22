Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721Ab0LVXkE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 18:40:04 -0500
Received: from virgo.iok.hu ([212.40.97.103]:51332 "EHLO virgo.iok.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752100Ab0LVXkB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 18:40:01 -0500
Date: Thu, 23 Dec 2010 00:39:56 +0100
From: Miklos Vajna <vmiklos@frugalware.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>, shenghui <crosslonelyover@gmail.com>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@elte.hu, Greg KH <greg@kroah.com>
Subject: Re: [PATCH] avoid race condition in pick_next_task_fair in
 kernel/sched_fair.c
Message-ID: <20101222233956.GE10557@genesis.frugalware.org>
References: <20101222002248.GP10557@genesis.frugalware.org>
 <1293006589.2170.41.camel@laptop>
 <1293007311.11370.172.camel@marge.simson.net>
 <1293008842.2170.70.camel@laptop>
 <20101222133154.GS10557@genesis.frugalware.org>
 <1293026422.2170.136.camel@laptop>
 <1293027112.2170.140.camel@laptop>
 <20101222151434.GW10557@genesis.frugalware.org>
 <1293037718.2170.155.camel@laptop>
 <20101222211151.GB10557@genesis.frugalware.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="diT81a9gloLbuVo+"
Content-Disposition: inline
In-Reply-To: <20101222211151.GB10557@genesis.frugalware.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--diT81a9gloLbuVo+
Content-Type: multipart/mixed; boundary="agGyne4gKHM29dDu"
Content-Disposition: inline


--agGyne4gKHM29dDu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 22, 2010 at 10:11:51PM +0100, Miklos Vajna <vmiklos@frugalware.=
org> wrote:
> I reported the issue as I tested 2.6.36 and 2.6.37-rc6 and both failed.
> Now I tried current -git and indeed I can't reproduce the issue there.
>=20
> I'm now bisecting between master and rc6 to see which commit fixes the
> problem - just to make sure it's not something irrelevant and the bug is
> still hidden somewhere.

I spoke too early. After some trying, it seems I can reproduce with
current -git as well. (But as Peter points out it's harder to
reproduce.)

Just in case it's interesting, I attached the -git dmesg. From a quick
look the trace is the same as with v2.6.36, which is easy to reproduce.

--agGyne4gKHM29dDu
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: attachment; filename="dmesg.txt"
Content-Transfer-Encoding: quoted-printable

Initializing cgroup subsys cpuset=0D
Initializing cgroup subsys cpu=0D
Linux version 2.6.37-rc6-00186-ge5fcdb7 (vmiklos@helicon) (gcc version 4.5.=
2 (Frugalware Linux) ) #2 SMP PREEMPT Wed Dec 22 21:22:52 CET 2010=0D
BIOS-provided physical RAM map:=0D
 BIOS-e820: 0000000000000000 - 000000000009f400 (usable)=0D
 BIOS-e820: 000000000009f400 - 00000000000a0000 (reserved)=0D
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)=0D
 BIOS-e820: 0000000000100000 - 000000003fffd000 (usable)=0D
 BIOS-e820: 000000003fffd000 - 0000000040000000 (reserved)=0D
 BIOS-e820: 00000000fffbc000 - 0000000100000000 (reserved)=0D
debug: ignoring loglevel setting.=0D
Notice: NX (Execute Disable) protection missing in CPU or disabled in BIOS!=
=0D
DMI 2.4 present.=0D
DMI: /Bochs, BIOS Bochs 01/01/2007=0D
e820 update range: 0000000000000000 - 0000000000010000 (usable) =3D=3D> (re=
served)=0D
e820 remove range: 00000000000a0000 - 0000000000100000 (usable)=0D
last_pfn =3D 0x3fffd max_arch_pfn =3D 0x100000=0D
found SMP MP-table at [c00fdc00] fdc00=0D
Scanning 0 areas for low memory corruption=0D
initial memory mapped : 0 - 01c00000=0D
init_memory_mapping: 0000000000000000-00000000377fe000=0D
 0000000000 - 0000400000 page 4k=0D
 0000400000 - 0037400000 page 2M=0D
 0037400000 - 00377fe000 page 4k=0D
kernel direct mapping tables up to 377fe000 @ 1bfb000-1c00000=0D
ACPI: RSDP 000fdbb0 00014 (v00 BOCHS )=0D
ACPI: RSDT 3fffde30 00034 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)=0D
ACPI: FACP 3ffffe70 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)=0D
ACPI: DSDT 3fffdfd0 01E22 (v01   BXPC   BXDSDT 00000001 INTL 20090123)=0D
ACPI: FACS 3ffffe00 00040=0D
ACPI: SSDT 3fffdf90 00037 (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)=0D
ACPI: APIC 3fffdeb0 00072 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)=0D
ACPI: HPET 3fffde70 00038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)=0D
ACPI: Local APIC address 0xfee00000=0D
135MB HIGHMEM available.=0D
887MB LOWMEM available.=0D
  mapped low ram: 0 - 377fe000=0D
  low ram: 0 - 377fe000=0D
kvm-clock: Using msrs 12 and 11=0D
kvm-clock: cpu 0, msr 0:17be331, boot clock=0D
Zone PFN ranges:=0D
  DMA      0x00000010 -> 0x00001000=0D
  Normal   0x00001000 -> 0x000377fe=0D
  HighMem  0x000377fe -> 0x0003fffd=0D
Movable zone start PFN for each node=0D
early_node_map[2] active PFN ranges=0D
    0: 0x00000010 -> 0x0000009f=0D
    0: 0x00000100 -> 0x0003fffd=0D
On node 0 totalpages: 262028=0D
free_area_init_node: node 0, pgdat c172ee20, node_mem_map f6ffd200=0D
  DMA zone: 32 pages used for memmap=0D
  DMA zone: 0 pages reserved=0D
  DMA zone: 3951 pages, LIFO batch:0=0D
  Normal zone: 1744 pages used for memmap=0D
  Normal zone: 221486 pages, LIFO batch:31=0D
  HighMem zone: 272 pages used for memmap=0D
  HighMem zone: 34543 pages, LIFO batch:7=0D
Using APIC driver default=0D
ACPI: PM-Timer IO Port: 0xb008=0D
ACPI: Local APIC address 0xfee00000=0D
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)=0D
ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])=0D
IOAPIC[0]: apic_id 1, version 17, address 0xfec00000, GSI 0-23=0D
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)=0D
ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)=0D
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)=0D
ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)=0D
ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)=0D
ACPI: IRQ0 used by override.=0D
ACPI: IRQ2 used by override.=0D
ACPI: IRQ5 used by override.=0D
ACPI: IRQ9 used by override.=0D
ACPI: IRQ10 used by override.=0D
ACPI: IRQ11 used by override.=0D
Using ACPI (MADT) for SMP configuration information=0D
ACPI: HPET id: 0x8086a201 base: 0xfed00000=0D
SMP: Allowing 1 CPUs, 0 hotplug CPUs=0D
nr_irqs_gsi: 40=0D
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000=0D
PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000=0D
PM: Registered nosave memory: 00000000000f0000 - 0000000000100000=0D
Allocating PCI resources starting at 40000000 (gap: 40000000:bffbc000)=0D
Booting paravirtualized kernel on KVM=0D
setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:1 nr_node_ids:1=0D
PERCPU: Embedded 12 pages/cpu @f6800000 s27056 r0 d22096 u4194304=0D
pcpu-alloc: s27056 r0 d22096 u4194304 alloc=3D1*4194304=0D
pcpu-alloc: [0] 0 =0D
kvm-clock: cpu 0, msr 0:36806331, primary cpu clock=0D
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 259980=
=0D
Kernel command line: root=3D/dev/sda1 debug sched_debug ignore_loglevel sys=
rq_always_enabled console=3DttyS0 init=3D/bin/systemd=0D
PID hash table entries: 4096 (order: 2, 16384 bytes)=0D
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)=0D
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)=0D
Initializing CPU#0=0D
allocated 5242500 bytes of page_cgroup=0D
please try 'cgroup_disable=3Dmemory' option if you don't want memory cgroup=
s=0D
Initializing HighMem for node 0 (000377fe:0003fffd)=0D
Memory: 1025412k/1048564k available (5451k kernel code, 22700k reserved, 19=
72k data, 504k init, 139260k highmem)=0D
virtual kernel memory layout:=0D
    fixmap  : 0xfff17000 - 0xfffff000   ( 928 kB)=0D
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)=0D
    vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)=0D
    lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)=0D
      .init : 0xc1741000 - 0xc17bf000   ( 504 kB)=0D
      .data : 0xc1552f3d - 0xc174022c   (1972 kB)=0D
      .text : 0xc1000000 - 0xc1552f3d   (5451 kB)=0D
Checking if this processor honours the WP bit even in supervisor mode...Ok.=
=0D
SLUB: Genslabs=3D15, HWalign=3D32, Order=3D0-3, MinObjects=3D0, CPUs=3D1, N=
odes=3D1=0D
Preemptable hierarchical RCU implementation.=0D
	RCU-based detection of stalled CPUs is disabled.=0D
	Verbose stalled-CPUs detection is disabled.=0D
NR_IRQS:2304 nr_irqs:256 16=0D
CPU 0 irqstacks, hard=3Df6408000 soft=3Df640a000=0D
Console: colour VGA+ 80x25=0D
console [ttyS0] enabled=0D
hpet clockevent registered=0D
Detected 2665.754 MHz processor.=0D
Calibrating delay loop (skipped) preset value.. 5331.50 BogoMIPS (lpj=3D266=
5754)=0D
pid_max: default: 32768 minimum: 301=0D
Security Framework initialized=0D
AppArmor: AppArmor disabled by boot time parameter=0D
Mount-cache hash table entries: 512=0D
Initializing cgroup subsys ns=0D
ns_cgroup deprecated: consider using the 'clone_children' flag without the =
ns_cgroup.=0D
Initializing cgroup subsys cpuacct=0D
Initializing cgroup subsys memory=0D
Initializing cgroup subsys devices=0D
Initializing cgroup subsys freezer=0D
Performance Events: Broken PMU hardware detected, software events only.=0D
SMP alternatives: switching to UP code=0D
Freeing SMP alternatives: 24k freed=0D
ACPI: Core revision 20101013=0D
Enabling APIC mode:  Flat.  Using 1 I/O APICs=0D
=2E.TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D-1=0D
CPU0: Intel QEMU Virtual CPU version 0.13.0 stepping 03=0D
Brought up 1 CPUs=0D
Total of 1 processors activated (5331.50 BogoMIPS).=0D
devtmpfs: initialized=0D
xor: automatically using best checksumming function: pIII_sse=0D
   pIII_sse  :  7960.000 MB/sec=0D
xor: using function: pIII_sse (7960.000 MB/sec)=0D
regulator: core version 0.5=0D
regulator: dummy: =0D
NET: Registered protocol family 16=0D
EISA bus registered=0D
ACPI: bus type pci registered=0D
PCI: Using configuration type 1 for base access=0D
bio: create slab <bio-0> at 0=0D
raid6: int32x1    968 MB/s=0D
raid6: int32x2    929 MB/s=0D
raid6: int32x4    785 MB/s=0D
raid6: int32x8    664 MB/s=0D
raid6: mmxx1     3222 MB/s=0D
raid6: mmxx2     3613 MB/s=0D
raid6: sse1x1    2218 MB/s=0D
raid6: sse1x2    2804 MB/s=0D
raid6: sse2x1    4093 MB/s=0D
raid6: sse2x2    4855 MB/s=0D
raid6: using algorithm sse2x2 (4855 MB/s)=0D
ACPI: EC: Look up EC in DSDT=0D
ACPI: Interpreter enabled=0D
ACPI: (supports S0 S3 S4 S5)=0D
ACPI: Using IOAPIC for interrupt routing=0D
ACPI: No dock devices found.=0D
PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=3Duse_c=
rs" and report a bug=0D
ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])=0D
pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)=0D
pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)=0D
pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignore=
d)=0D
pci_root PNP0A03:00: host bridge window [mem 0xe0000000-0xfebfffff] (ignore=
d)=0D
pci 0000:00:00.0: [8086:1237] type 0 class 0x000600=0D
pci 0000:00:01.0: [8086:7000] type 0 class 0x000601=0D
pci 0000:00:01.1: [8086:7010] type 0 class 0x000101=0D
pci 0000:00:01.1: reg 20: [io  0xc000-0xc00f]=0D
pci 0000:00:01.3: [8086:7113] type 0 class 0x000680=0D
pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI=0D
pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB=0D
pci 0000:00:02.0: [1013:00b8] type 0 class 0x000300=0D
pci 0000:00:02.0: reg 10: [mem 0xf0000000-0xf1ffffff pref]=0D
pci 0000:00:02.0: reg 14: [mem 0xf2000000-0xf2000fff]=0D
pci 0000:00:02.0: reg 30: [mem 0xf2010000-0xf201ffff pref]=0D
pci 0000:00:03.0: [8086:100e] type 0 class 0x000200=0D
pci 0000:00:03.0: reg 10: [mem 0xf2020000-0xf203ffff]=0D
pci 0000:00:03.0: reg 14: [io  0xc040-0xc07f]=0D
pci 0000:00:03.0: reg 30: [mem 0xf2040000-0xf205ffff pref]=0D
pci_bus 0000:00: on NUMA node 0=0D
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]=0D
ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)=0D
ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)=0D
ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)=0D
ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)=0D
vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=3Dio+mem,locks=
=3Dnone=0D
vgaarb: loaded=0D
SCSI subsystem initialized=0D
libata version 3.00 loaded.=0D
usbcore: registered new interface driver usbfs=0D
usbcore: registered new interface driver hub=0D
usbcore: registered new device driver usb=0D
PCI: Using ACPI for IRQ routing=0D
PCI: pci_cache_line_size set to 32 bytes=0D
reserve RAM buffer: 000000000009f400 - 000000000009ffff =0D
reserve RAM buffer: 000000003fffd000 - 000000003fffffff =0D
NetLabel: Initializing=0D
NetLabel:  domain hash size =3D 128=0D
NetLabel:  protocols =3D UNLABELED CIPSOv4=0D
NetLabel:  unlabeled traffic allowed by default=0D
HPET: 3 timers in total, 0 timers will be used for per-cpu timer=0D
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0=0D
hpet0: 3 comparators, 64-bit 100.000000 MHz counter=0D
Switching to clocksource kvm-clock=0D
pnp: PnP ACPI init=0D
ACPI: bus type pnp registered=0D
pnp 00:00: [bus 00-ff]=0D
pnp 00:00: [io  0x0cf8-0x0cff]=0D
pnp 00:00: [io  0x0000-0x0cf7 window]=0D
pnp 00:00: [io  0x0d00-0xffff window]=0D
pnp 00:00: [mem 0x000a0000-0x000bffff window]=0D
pnp 00:00: [mem 0xe0000000-0xfebfffff window]=0D
pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)=0D
pnp 00:01: [io  0x0070-0x0071]=0D
pnp 00:01: [irq 8]=0D
pnp 00:01: [io  0x0072-0x0077]=0D
pnp 00:01: Plug and Play ACPI device, IDs PNP0b00 (active)=0D
pnp 00:02: [io  0x0060]=0D
pnp 00:02: [io  0x0064]=0D
pnp 00:02: [irq 1]=0D
pnp 00:02: Plug and Play ACPI device, IDs PNP0303 (active)=0D
pnp 00:03: [irq 12]=0D
pnp 00:03: Plug and Play ACPI device, IDs PNP0f13 (active)=0D
pnp 00:04: [io  0x03f2-0x03f5]=0D
pnp 00:04: [io  0x03f7]=0D
pnp 00:04: [irq 6]=0D
pnp 00:04: [dma 2]=0D
pnp 00:04: Plug and Play ACPI device, IDs PNP0700 (active)=0D
pnp 00:05: [io  0x0378-0x037f]=0D
pnp 00:05: [irq 7]=0D
pnp 00:05: Plug and Play ACPI device, IDs PNP0400 (active)=0D
pnp 00:06: [io  0x03f8-0x03ff]=0D
pnp 00:06: [irq 4]=0D
pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)=0D
pnp 00:07: [mem 0xfed00000-0xfed003ff]=0D
pnp 00:07: Plug and Play ACPI device, IDs PNP0103 (active)=0D
pnp: PnP ACPI: found 8 devices=0D
ACPI: ACPI bus type pnp unregistered=0D
PnPBIOS: Disabled=0D
pci_bus 0000:00: resource 0 [io  0x0000-0xffff]=0D
pci_bus 0000:00: resource 1 [mem 0x00000000-0xffffffff]=0D
NET: Registered protocol family 2=0D
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)=0D
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)=0D
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)=0D
TCP: Hash tables configured (established 131072 bind 65536)=0D
TCP reno registered=0D
UDP hash table entries: 512 (order: 2, 16384 bytes)=0D
UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)=0D
NET: Registered protocol family 1=0D
pci 0000:00:00.0: Limiting direct PCI/PCI transfers=0D
pci 0000:00:01.0: PIIX3: Enabling Passive Release=0D
pci 0000:00:01.0: Activating ISA DMA hang workarounds=0D
pci 0000:00:02.0: Boot video device=0D
PCI: CLS 0 bytes, default 32=0D
Scanning for low memory corruption every 60 seconds=0D
audit: initializing netlink socket (disabled)=0D
type=3D2000 audit(1293058318.479:1): initialized=0D
highmem bounce pool size: 64 pages=0D
VFS: Disk quotas dquot_6.5.2=0D
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)=0D
SGI XFS with ACLs, security attributes, realtime, large block/inode numbers=
, no debug enabled=0D
SGI XFS Quota Management subsystem=0D
msgmni has been set to 1730=0D
async_tx: api initialized (async)=0D
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)=0D
io scheduler noop registered=0D
io scheduler deadline registered=0D
io scheduler cfq registered (default)=0D
pci_hotplug: PCI Hot Plug PCI Core version: 0.5=0D
isapnp: Scanning for PnP cards...=0D
isapnp: No Plug & Play device found=0D
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled=0D
Clocksource tsc unstable (delta =3D -74324425 ns)=0D
=FFserial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A=0D
00:06: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A=0D
FDC 0 is a S82078B=0D
brd: module loaded=0D
Compaq SMART2 Driver (v 2.6.0)=0D
HP CISS Driver (v 3.6.26)=0D
Uniform Multi-Platform E-IDE driver=0D
ide-gd driver 1.18=0D
ide-cd driver 5.00=0D
stex: Promise SuperTrak EX Driver version: 4.6.0000.4=0D
ata_piix 0000:00:01.1: version 2.13=0D
ata_piix 0000:00:01.1: setting latency timer to 64=0D
scsi0 : ata_piix=0D
scsi1 : ata_piix=0D
ata1: PATA max MWDMA2 cmd 0x1f0 ctl 0x3f6 bmdma 0xc000 irq 14=0D
ata2: PATA max MWDMA2 cmd 0x170 ctl 0x376 bmdma 0xc008 irq 15=0D
Fusion MPT base driver 3.04.17=0D
Copyright (c) 1999-2008 LSI Corporation=0D
Fusion MPT SPI Host driver 3.04.17=0D
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver=0D
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver=0D
uhci_hcd: USB Universal Host Controller Interface driver=0D
Initializing USB Mass Storage driver...=0D
usbcore: registered new interface driver usb-storage=0D
USB Mass Storage support registered.=0D
usbcore: registered new interface driver ums-alauda=0D
usbcore: registered new interface driver ums-cypress=0D
usbcore: registered new interface driver ums-datafab=0D
usbcore: registered new interface driver ums-freecom=0D
usbcore: registered new interface driver ums-isd200=0D
usbcore: registered new interface driver ums-jumpshot=0D
usbcore: registered new interface driver ums-karma=0D
usbcore: registered new interface driver ums-onetouch=0D
usbcore: registered new interface driver ums-sddr09=0D
usbcore: registered new interface driver ums-sddr55=0D
usbcore: registered new interface driver ums-usbat=0D
PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12=0D
serio: i8042 KBD port at 0x60,0x64 irq 1=0D
serio: i8042 AUX port at 0x60,0x64 irq 12=0D
mice: PS/2 mouse device common for all mice=0D
md: linear personality registered for level -1=0D
md: raid0 personality registered for level 0=0D
md: raid1 personality registered for level 1=0D
md: raid10 personality registered for level 10=0D
md: raid6 personality registered for level 6=0D
md: raid5 personality registered for level 5=0D
md: raid4 personality registered for level 4=0D
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input=
/input0=0D
EISA: Probing bus 0 at eisa.0=0D
EISA: Detected 0 cards.=0D
cpuidle: using governor ladder=0D
cpuidle: using governor menu=0D
usbcore: registered new interface driver usbhid=0D
usbhid: USB HID core driver=0D
TCP bic registered=0D
Initializing XFRM netlink socket=0D
NET: Registered protocol family 17=0D
Registering the dns_resolver key type=0D
Using IPI No-Shortcut mode=0D
registered taskstats version 1=0D
drivers/rtc/hctosys.c: unable to open rtc device (rtc0)=0D
ata2.01: NODEV after polling detection=0D
ata1.01: NODEV after polling detection=0D
ata1.00: ATA-7: QEMU HARDDISK, 0.13.0, max UDMA/100=0D
ata1.00: 16777216 sectors, multi 16: LBA48 =0D
ata2.00: ATAPI: QEMU DVD-ROM, 0.13.0, max UDMA/100=0D
ata2.00: configured for MWDMA2=0D
ata1.00: configured for MWDMA2=0D
scsi 0:0:0:0: Direct-Access     ATA      QEMU HARDDISK    0.13 PQ: 0 ANSI: =
5=0D
sd 0:0:0:0: [sda] 16777216 512-byte logical blocks: (8.58 GB/8.00 GiB)=0D
sd 0:0:0:0: [sda] Write Protect is off=0D
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00=0D
sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't suppo=
rt DPO or FUA=0D
 sda: sda1=0D
scsi 1:0:0:0: CD-ROM            QEMU     QEMU DVD-ROM     0.13 PQ: 0 ANSI: =
5=0D
sd 0:0:0:0: [sda] Attached SCSI disk=0D
sr0: scsi3-mmc drive: 4x/4x xa/form2 tray=0D
cdrom: Uniform CD-ROM driver Revision: 3.20=0D
sr 1:0:0:0: Attached scsi CD-ROM sr0=0D
md: Waiting for all devices to be available before autodetect=0D
md: If you don't use raid, use raid=3Dnoautodetect=0D
md: Autodetecting RAID arrays.=0D
md: Scanned 0 and added 0 devices.=0D
md: autorun ...=0D
md: ... autorun DONE.=0D
EXT3-fs (sda1): error: couldn't mount because of unsupported optional featu=
res (240)=0D
EXT2-fs (sda1): error: couldn't mount because of unsupported optional featu=
res (244)=0D
EXT4-fs (sda1): INFO: recovery required on readonly filesystem=0D
EXT4-fs (sda1): write access will be enabled during recovery=0D
EXT4-fs (sda1): recovery complete=0D
EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)=0D
VFS: Mounted root (ext4 filesystem) readonly on device 8:1.=0D
devtmpfs: mounted=0D
Freeing unused kernel memory: 504k freed=0D
systemd[1]: systemd 15 running in system mode. (+PAM -LIBWRAP -AUDIT -SELIN=
UX +SYSVINIT -LIBCRYPTSETUP; frugalware)=0D
Welcome to =1B[1;36mFrugalware 1.4pre2 (Nexon)=1B[0m!=0D
systemd[1]: /sbin/modprobe failed with error code 1.=0D
systemd[1]: Set hostname to <frugalware>.=0D
systemd[1]: /etc/mtab is not a symlink or not pointing to /proc/self/mounts=
=2E This is not supported anymore. Please make sure to replace this file by=
 a symlink to avoid incorrect or misleading mount(8) output.=0D
Starting LSB: Clean /tmp, /var/run and /var/lock....=0D
Starting Apply Kernel Variables...=0D
Starting Load Kernel Modules...=0D
systemd[1]: Failed to open /dev/autofs: No such file or directory=0D
systemd[1]: Failed to initialize automounter: No such file or directory=0D
systemd[1]: Unit sys-kernel-debug.automount entered failed state.=0D
systemd[1]: Failed to open /dev/autofs: No such file or directory=0D
systemd[1]: Failed to initialize automounter: No such file or directory=0D
systemd[1]: Unit proc-sys-fs-binfmt_misc.automount entered failed state.=0D
systemd[1]: Failed to open /dev/autofs: No such file or directory=0D
systemd[1]: Failed to initialize automounter: No such file or directory=0D
systemd[1]: Unit sys-kernel-security.automount entered failed state.=0D
systemd[1]: Failed to open /dev/autofs: No such file or directory=0D
systemd[1]: Failed to initialize automounter: No such file or directory=0D
systemd[1]: Unit dev-mqueue.automount entered failed state.=0D
Starting Setup Virtual Console...=0D
Starting Apply System Clock UTC Offset...=0D
Starting Remount API VFS...=0D
Starting File System Check on Root Device...=0D
Starting Logging Daemon...=0D
Starting systemd Syslog Kernel Log Buffer Bridge...=0D
systemd[1]: systemd-modules-load.service: main process exited, code=3Dexite=
d, status=3D1=0D
Starting Load Kernel Modules =1B[1;31mfailed=1B[0m.=0D
systemd[1]: Unit systemd-modules-load.service entered failed state.=0D
modprobe[1229]: FATAL: Could not load /lib/modules/2.6.37-rc6-00186-ge5fcdb=
7/modules.dep: No such file or directoryStarting udev Kernel Device Manager=
=2E..=0D
=0D
systemd-fsck[1235]: /dev/sda1: Superblock last mount time is in the future.=
=0D
systemd-fsck[1235]: (by less than a day, probably due to the hardware clock=
 being incorrectly set)  FIXED.=0D
systemd-fsck[1235]: /dev/sda1: clean, 45976/524288 files, 265431/2096474 bl=
ocks (check in 3 mounts)=0D
udev[1244]: starting version 165=0D
Starting Remount Root FS...=0D
EXT4-fs (sda1): re-mounted. Opts: (null)=0D
Starting Load Random Seed...=0D
Starting Recreate Volatile Files and Directories...=0D
BUG: unable to handle kernel NULL pointer dereference at 00000001=0D
IP: [<c129e938>] __rb_rotate_right+0x18/0x70=0D
*pde =3D 00000000 =0D
Oops: 0000 [#1] PREEMPT SMP =0D
last sysfs file: /sys/bus/pnp/drivers/i8042 kbd/uevent=0D
Modules linked in:=0D
=0D
Pid: 1380, comm: systemd-cgroups Not tainted 2.6.37-rc6-00186-ge5fcdb7 #2 /=
Bochs=0D
EIP: 0060:[<c129e938>] EFLAGS: 00010002 CPU: 0=0D
EIP is at __rb_rotate_right+0x18/0x70=0D
EAX: f5ca2e48 EBX: f5ca2e4c ECX: f5ca2e48 EDX: f5ca27fc=0D
ESI: 00000001 EDI: 00000001 EBP: f6806360 ESP: f5d6fe88=0D
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068=0D
Process systemd-cgroups (pid: 1380, ti=3Df5d6e000 task=3Df67c4000 task.ti=
=3Df5d6e000)=0D
Stack:=0D
 f5ca27fc 00000001 f5ca2e48 c129ed02 00000001 f5ca27e0 f5ca2a20 f5ca2a28=0D
 f6806360 c1032438 f67c41bc f6806360 00000000 f67c4000 c154f5ff f5d6ff24=0D
 c155a7e0 00000564 c110480a f5d6ff17 c17be360 c17be360 f67c41c0 c17be360=0D
Call Trace:=0D
 [<c129ed02>] ? rb_erase+0x262/0x2b0=0D
 [<c1032438>] ? pick_next_task_fair+0x88/0x120=0D
 [<c154f5ff>] ? schedule+0x49f/0x960=0D
 [<c110480a>] ? d_lookup+0x2a/0x40=0D
 [<c10e6e96>] ? __slab_free+0xd6/0x180=0D
 [<c103ea89>] ? release_task+0x2b9/0x420=0D
 [<c1040410>] ? do_exit+0x520/0x790=0D
 [<c104088e>] ? do_group_exit+0x2e/0x90=0D
 [<c1040901>] ? sys_exit_group+0x11/0x20=0D
 [<c100361c>] ? sysenter_do_call+0x12/0x28=0D
Code: 5f c3 90 89 4b 08 8b 10 83 e2 03 09 ca 89 10 5b 5e 5f c3 57 56 53 8b =
48 08 8b 18 83 e3 fc 8b 71 04 89 70 08 85 f6 74 0c 8b 79 04 <8b> 37 83 e6 0=
3 09 c6 89 37 89 41 04 8b 31 83 e6 03 09 de 89 31 =0D
EIP: [<c129e938>] __rb_rotate_right+0x18/0x70 SS:ESP 0068:f5d6fe88=0D
CR2: 0000000000000001=0D
---[ end trace 0f6a879251f67ee0 ]---=0D
Fixing recursive fault but reboot is needed!=0D

--agGyne4gKHM29dDu--

--diT81a9gloLbuVo+
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk0SjEwACgkQe81tAgORUJYI6ACfQDiF4h/ArXmDHRmCoeAwsdPQ
ZasAn0miYPQdbYPxJ5U0LP/N7DOicmxu
=wROT
-----END PGP SIGNATURE-----

--diT81a9gloLbuVo+--
