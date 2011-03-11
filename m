Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755184Ab1CKMrD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 07:47:03 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46050 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675Ab1CKMrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 07:47:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=TV1g6Cy+GsgyrLXBfhnfI4EXia/soH3qNT1UxdkB28s85s8b3omJdlApiO1ysJ0/b2
         MfzK2epIqs2eF90oKyQU5VCVZ40pNC3PRNcUXPKrVAS0mW6Oiy/Xt92qot0dyEpuGThV
         E0lIKwX0SjiRK2jhavJB2yA3dzzGGxEefY5TI=
From: Wang Lei <f3d27b@gmail.com>
To: Andreas Herrmann <herrmann.der.user@googlemail.com>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>
Subject: Re: [BUG] Fans keep running, first found since v2.6.38-rc7
References: <4d774c85.20f98e0a.2695.73ed@mx.google.com>
	<201103092125.43950.rjw@sisk.pl>
	<4d780a2f.231a8f0a.3b01.ffffa228@mx.google.com>
	<201103100106.36678.rjw@sisk.pl>
	<4d796b47.20f98e0a.2695.fffff615@mx.google.com>
	<20110311074156.GD13156@alberich.amd.com>
	<4d79fdbd.43392b0a.0aae.0712@mx.google.com>
	<20110311113839.GA4717@alberich.amd.com>
Date: Fri, 11 Mar 2011 20:47:01 +0800
In-Reply-To: <20110311113839.GA4717@alberich.amd.com> (Andreas Herrmann's
	message of "Fri, 11 Mar 2011 12:38:39 +0100")
Message-ID: <4d7a19c2.29788e0a.231c.1837@mx.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain


On 2011-03-11 19:38:39 +0800, Andreas wrote:
>
> Can you please try to boot -rc7 with kernel parameter acpi_skip_timer_override
> and send the same output (dmesg again also with apic=debug and lspci -nnxxxx)
>
>
> Thanks,
>
> Andreas
>
> PS: My assumption is that the patch in -rc7 leads to usage of IO-APIC
>     pin2 for timer interrupt (potentially I have broken chipset
>     revision determination for some SB600.)

Hi Andreas,

I did what you said, appended acpi_skip_timer_override when boot -rc7.
Now the fans work OK. I don't know why and I don't think this is the
final solution. If not, I'll wait.

Anyway, Thank you very much!

Attach demsg and lspci output.


--=-=-=
Content-Type: text/plain
Content-Disposition: attachment; filename=dmesg2
Content-Description: dmesg

Initializing cgroup subsys cpuset
Initializing cgroup subsys cpu
Linux version 2.6.38-rc7-mute (lei@localhost) (gcc version 4.5.2 (Debian 4.5.2-5) ) #1 SMP Fri Mar 11 20:07:53 CST 2011
Command line: BOOT_IMAGE=/boot/vmlinuz-2.6.38-rc7-mute root=/dev/sda1 ro apic=debug acpi_skip_timer_override
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 0000000097fb0000 (usable)
 BIOS-e820: 0000000097fb0000 - 0000000097fc8000 (reserved)
 BIOS-e820: 0000000097fc8000 - 0000000097fe7fb8 (ACPI NVS)
 BIOS-e820: 0000000097fe7fb8 - 00000000a0000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec02000 (reserved)
 BIOS-e820: 00000000ffbc0000 - 00000000ffcc0000 (reserved)
 BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
NX (Execute Disable) protection: active
DMI 2.4 present.
DMI: Hewlett-Packard HP Compaq 6515b (GL087PA#AB2)/30C2, BIOS 68YTT Ver. F.05 04/26/2007
e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
No AGP bridge found
last_pfn = 0x97fb0 max_arch_pfn = 0x400000000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-BFFFF uncachable
  C0000-C0FFF write-protect
  C1000-C3FFF write-back
  C4000-C4FFF write-protect
  C5000-C7FFF write-back
  C8000-C8FFF write-protect
  C9000-CBFFF write-back
  CC000-CCFFF write-protect
  CD000-CFFFF write-back
  D0000-EFFFF uncachable
  F0000-FFFFF write-protect
MTRR variable ranges enabled:
  0 base 0000000000 mask FF80000000 write-back
  1 base 0080000000 mask FFF0000000 write-back
  2 base 0090000000 mask FFF8000000 write-back
  3 disabled
  4 disabled
  5 disabled
  6 disabled
  7 disabled
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
initial memory mapped : 0 - 20000000
init_memory_mapping: 0000000000000000-0000000097fb0000
 0000000000 - 0097e00000 page 2M
 0097e00000 - 0097fb0000 page 4k
kernel direct mapping tables up to 97fb0000 @ 1fffb000-20000000
ACPI: RSDP 00000000000fe0b0 00024 (v02 HP    )
ACPI: XSDT 0000000097fc81bc 00064 (v01 HPQOEM SLIC-MPC 00000001 HP   00000001)
ACPI: FACP 0000000097fc8084 000F4 (v04 HP     0944     00000003 HP   00000001)
ACPI Error: 32/64X address mismatch in Pm2ControlBlock: 0x00008800/0x0000000000008100, using 32 (20110112/tbfadt-427)
ACPI: DSDT 0000000097fc84a4 11437 (v01 HP        SB400 00010000 MSFT 03000001)
ACPI: FACS 0000000097fe7d80 00040
ACPI: SLIC 0000000097fc8220 00176 (v01 HPQOEM SLIC-MPC 00000001 HP   00000001)
ACPI: EPTH 0000000097fc8398 00038 (v01 HP     0944     00000001 HP   00000001)
ACPI: APIC 0000000097fc83d0 00062 (v01 HP     0944     00000001 HP   00000001)
ACPI: MCFG 0000000097fc8434 0003C (v01 HP     0944     00000001 HP   00000001)
ACPI: TCPA 0000000097fc8470 00032 (v02 HP     0944     00000001 HP   00000001)
ACPI: SSDT 0000000097fd98db 00059 (v01 HP       HPQNLP 00000001 MSFT 03000001)
ACPI: SSDT 0000000097fd9934 00182 (v01 HP     PSSTBLID 00000001 HP   00000001)
ACPI: Local APIC address 0xfee00000
mapped APIC to ffffffffff5fc000 (        fee00000)
 [ffffea0000000000-ffffea00021fffff] PMD -> [ffff880095000000-ffff8800971fffff] on node 0
Zone PFN ranges:
  DMA      0x00000010 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   empty
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000010 -> 0x0000009f
    0: 0x00000100 -> 0x00097fb0
On node 0 totalpages: 622399
  DMA zone: 56 pages used for memmap
  DMA zone: 2 pages reserved
  DMA zone: 3925 pages, LIFO batch:0
  DMA32 zone: 8455 pages used for memmap
  DMA32 zone: 609961 pages, LIFO batch:31
Detected use of extended apic ids on hypertransport bus
ACPI: PM-Timer IO Port: 0x8008
ACPI: Local APIC address 0xfee00000
mapped APIC to ffffffffff5fc000 (        fee00000)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 33, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: BIOS IRQ0 pin2 override ignored.
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
Int: type 0, pol 3, trig 3, bus 00, IRQ 09, APIC ID 2, APIC INT 09
Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 2, APIC INT 00
Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 2, APIC INT 01
Int: type 0, pol 0, trig 0, bus 00, IRQ 02, APIC ID 2, APIC INT 02
Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 2, APIC INT 03
Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 2, APIC INT 04
Int: type 0, pol 0, trig 0, bus 00, IRQ 05, APIC ID 2, APIC INT 05
Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 2, APIC INT 06
Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 2, APIC INT 07
Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 2, APIC INT 08
ACPI: IRQ9 used by override.
Int: type 0, pol 0, trig 0, bus 00, IRQ 0a, APIC ID 2, APIC INT 0a
Int: type 0, pol 0, trig 0, bus 00, IRQ 0b, APIC ID 2, APIC INT 0b
Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 2, APIC INT 0c
Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 2, APIC INT 0d
Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 2, APIC INT 0e
Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 2, APIC INT 0f
Using ACPI (MADT) for SMP configuration information
SMP: Allowing 2 CPUs, 0 hotplug CPUs
mapped IOAPIC to ffffffffff5fb000 (fec00000)
nr_irqs_gsi: 40
Allocating PCI resources starting at a0000000 (gap: a0000000:40000000)
setup_percpu: NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
PERCPU: Embedded 25 pages/cpu @ffff880097c00000 s72640 r8192 d21568 u1048576
pcpu-alloc: s72640 r8192 d21568 u1048576 alloc=1*2097152
pcpu-alloc: [0] 0 1 
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 613886
Kernel command line: BOOT_IMAGE=/boot/vmlinuz-2.6.38-rc7-mute root=/dev/sda1 ro apic=debug acpi_skip_timer_override
PID hash table entries: 4096 (order: 3, 32768 bytes)
Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
Checking aperture...
No AGP bridge found
Node 0: aperture @ 412e000000 size 32 MB
Aperture beyond 4GB. Ignoring.
Memory: 2443420k/2490048k available (2775k kernel code, 452k absent, 46176k reserved, 1225k data, 368k init)
SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
Hierarchical RCU implementation.
	RCU-based detection of stalled CPUs is disabled.
NR_IRQS:4352 nr_irqs:512 16
Extended CMOS year: 2000
spurious 8259A interrupt: IRQ7.
Console: colour VGA+ 80x25
console [tty0] enabled
allocated 24903680 bytes of page_cgroup
please try 'cgroup_disable=memory' option if you don't want memory cgroups
Fast TSC calibration using PIT
Detected 1593.704 MHz processor.
Marking TSC unstable due to TSCs unsynchronized
Calibrating delay loop (skipped), value calculated using timer frequency.. 3187.40 BogoMIPS (lpj=1593704)
pid_max: default: 32768 minimum: 301
Mount-cache hash table entries: 256
Initializing cgroup subsys ns
ns_cgroup deprecated: consider using the 'clone_children' flag without the ns_cgroup.
Initializing cgroup subsys cpuacct
Initializing cgroup subsys memory
Initializing cgroup subsys devices
Initializing cgroup subsys freezer
Initializing cgroup subsys blkio
tseg: 0000000000
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
mce: CPU supports 5 MCE banks
using C1E aware idle routine
ACPI: Core revision 20110112
Getting VERSION: 80050010
Getting VERSION: 80050010
Getting ID: 0
Getting ID: ff000000
Getting LVT0: 700
Getting LVT1: 400
Setting APIC routing to flat
enabled ExtINT on CPU#0
ENABLING IO-APIC IRQs
init IO_APIC IRQs
IOAPIC[0]: Set routing entry (2-0 -> 0x30 -> IRQ 0 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-3 -> 0x33 -> IRQ 3 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-5 -> 0x35 -> IRQ 5 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:1 Active:1)
IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-14 -> 0x3e -> IRQ 14 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-15 -> 0x3f -> IRQ 15 Mode:0 Active:0)
 2-16 2-17 2-18 2-19 2-20 2-21 2-22 2-23 (apicid-pin) not connected
..TIMER: vector=0x30 apic1=0 pin1=0 apic2=-1 pin2=-1
CPU0: AMD Turion(tm) 64 X2 Mobile Technology TL-52 stepping 02
Using local APIC timer interrupts.
calibrating APIC timer ...
... lapic delta = 1246683
... PM-Timer delta = 357899
... PM-Timer result ok
..... delta 1246683
..... mult: 53552767
..... calibration result: 199469
..... CPU clock speed is 1595.0753 MHz.
..... host bus clock speed is 199.0469 MHz.
Performance Events: AMD PMU driver.
... version:                0
... bit width:              48
... generic registers:      4
... value mask:             0000ffffffffffff
... max period:             00007fffffffffff
... fixed-purpose events:   0
... event mask:             000000000000000f
MCE: In-kernel MCE decoding enabled.
Booting Node   0, Processors  #1 Ok.
masked ExtINT on CPU#1
System has AMD C1E enabled
Brought up 2 CPUs
Total of 2 processors activated (6378.76 BogoMIPS).
Switch to broadcast mode on CPU1
Switch to broadcast mode on CPU0
devtmpfs: initialized
NET: Registered protocol family 16
node 0 link 0: io port [1000, fffff]
TOM: 00000000a0000000 aka 2560M
node 0 link 0: mmio [e0000000, efffffff]
node 0 link 0: mmio [f0000000, ffffffff]
node 0 link 0: mmio [c8000000, dfffffff]
node 0 link 0: mmio [c0000000, c7ffffff]
node 0 link 0: mmio [a0000, bffff]
node 0 link 0: mmio [a0000000, bfffffff]
bus: [00, ff] on node 0 link 0
bus: 00 index 0 [io  0x0000-0xffff]
bus: 00 index 1 [mem 0xa0000000-0xfcffffffff]
bus: 00 index 2 [mem 0x000a0000-0x000bffff]
ACPI: bus type pci registered
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: Power Resource [C171] (off)
ACPI: Power Resource [C24C] (on)
ACPI: Power Resource [C395] (off)
ACPI: Power Resource [C396] (off)
ACPI: Power Resource [C397] (off)
ACPI: Power Resource [C398] (off)
ACPI: EC: GPE = 0x11, I/O: command/status = 0x66, data = 0x62
PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
ACPI: PCI Root Bridge [C08B] (domain 0000 [bus 00-ff])
pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
pci_root PNP0A03:00: host bridge window [mem 0xa0000000-0xfedfffff] (ignored)
pci_root PNP0A03:00: host bridge window [mem 0xfee01000-0xffffffff] (ignored)
pci_root PNP0A03:00: host bridge window [mem 0x000d0000-0x000dffff] (ignored)
pci 0000:00:00.0: [1002:7910] type 0 class 0x000600
pci 0000:00:01.0: [1002:7912] type 1 class 0x000604
pci 0000:00:05.0: [1002:7915] type 1 class 0x000604
pci 0000:00:05.0: PME# supported from D0 D3hot D3cold
pci 0000:00:05.0: PME# disabled
pci 0000:00:12.0: [1002:4380] type 0 class 0x000101
pci 0000:00:12.0: reg 10: [io  0x9000-0x9007]
pci 0000:00:12.0: reg 14: [io  0x9008-0x900b]
pci 0000:00:12.0: reg 18: [io  0x9010-0x9017]
pci 0000:00:12.0: reg 1c: [io  0x5018-0x501b]
pci 0000:00:12.0: reg 20: [io  0x5020-0x502f]
pci 0000:00:12.0: reg 24: [mem 0xcc309000-0xcc3093ff]
pci 0000:00:12.0: set SATA to AHCI mode
pci 0000:00:13.0: [1002:4387] type 0 class 0x000c03
pci 0000:00:13.0: reg 10: [mem 0xcc301000-0xcc301fff]
pci 0000:00:13.1: [1002:4388] type 0 class 0x000c03
pci 0000:00:13.1: reg 10: [mem 0xcc302000-0xcc302fff]
pci 0000:00:13.2: [1002:4389] type 0 class 0x000c03
pci 0000:00:13.2: reg 10: [mem 0xcc303000-0xcc303fff]
pci 0000:00:13.3: [1002:438a] type 0 class 0x000c03
pci 0000:00:13.3: reg 10: [mem 0xcc304000-0xcc304fff]
pci 0000:00:13.4: [1002:438b] type 0 class 0x000c03
pci 0000:00:13.4: reg 10: [mem 0xcc305000-0xcc305fff]
pci 0000:00:13.5: [1002:4386] type 0 class 0x000c03
pci 0000:00:13.5: reg 10: [mem 0xcc306000-0xcc3060ff]
pci 0000:00:13.5: supports D1 D2
pci 0000:00:13.5: PME# supported from D0 D1 D2 D3hot
pci 0000:00:13.5: PME# disabled
pci 0000:00:14.0: [1002:4385] type 0 class 0x000c05
pci 0000:00:14.0: reg 10: [io  0x8200-0x820f]
pci 0000:00:14.1: [1002:438c] type 0 class 0x000101
pci 0000:00:14.1: reg 10: [io  0x0000-0x0007]
pci 0000:00:14.1: reg 14: [io  0x0000-0x0003]
pci 0000:00:14.1: reg 18: [io  0x0000-0x0007]
pci 0000:00:14.1: reg 1c: [io  0x0000-0x0003]
pci 0000:00:14.1: reg 20: [io  0x5040-0x504f]
pci 0000:00:14.2: [1002:4383] type 0 class 0x000403
pci 0000:00:14.2: reg 10: [mem 0xcc308000-0xcc30bfff 64bit]
pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
pci 0000:00:14.2: PME# disabled
pci 0000:00:14.3: [1002:438d] type 0 class 0x000601
pci 0000:00:14.4: [1002:4384] type 1 class 0x000604
pci 0000:00:18.0: [1022:1100] type 0 class 0x000600
pci 0000:00:18.1: [1022:1101] type 0 class 0x000600
pci 0000:00:18.2: [1022:1102] type 0 class 0x000600
pci 0000:00:18.3: [1022:1103] type 0 class 0x000600
PCI: peer root bus 00 res updated from pci conf
pci 0000:01:05.0: [1002:791f] type 0 class 0x000300
pci 0000:01:05.0: reg 10: [mem 0xc0000000-0xc7ffffff 64bit pref]
pci 0000:01:05.0: reg 18: [mem 0xcc100000-0xcc10ffff 64bit]
pci 0000:01:05.0: reg 20: [io  0x4000-0x40ff]
pci 0000:01:05.0: reg 24: [mem 0xcc200000-0xcc2fffff]
pci 0000:01:05.0: supports D1 D2
pci 0000:00:01.0: PCI bridge to [bus 01-01]
pci 0000:00:01.0:   bridge window [io  0x4000-0x4fff]
pci 0000:00:01.0:   bridge window [mem 0xcc100000-0xcc2fffff]
pci 0000:00:01.0:   bridge window [mem 0xc0000000-0xc7ffffff 64bit pref]
pci 0000:00:05.0: PCI bridge to [bus 20-20]
pci 0000:00:05.0:   bridge window [io  0x2000-0x3fff]
pci 0000:00:05.0:   bridge window [mem 0xc8000000-0xcbffffff]
pci 0000:00:05.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:02:04.0: [1180:0476] type 2 class 0x000607
pci 0000:02:04.0: reg 10: [mem 0xcc000000-0xcc000fff]
pci 0000:02:04.0: supports D1 D2
pci 0000:02:04.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:02:04.0: PME# disabled
pci 0000:00:14.4: PCI bridge to [bus 02-03] (subtractive decode)
pci 0000:00:14.4:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:00:14.4:   bridge window [mem 0xcc000000-0xcc0fffff]
pci 0000:00:14.4:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:00:14.4:   bridge window [io  0x0000-0xffff] (subtractive decode)
pci 0000:00:14.4:   bridge window [mem 0xa0000000-0xfcffffffff] (subtractive decode)
pci 0000:00:14.4:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
pci_bus 0000:03: [bus 03-06] partially hidden behind transparent bridge 0000:02 [bus 02-03]
pci_bus 0000:00: on NUMA node 0
ACPI: PCI Interrupt Routing Table [\_SB_.C08B._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.C08B.C08C._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.C08B.C0FC._PRT]
ACPI: PCI Interrupt Link [C145] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [C146] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [C147] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [C148] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [C149] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [C14A] (IRQs 9) *0, disabled.
ACPI: PCI Interrupt Link [C14B] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [C14C] (IRQs 10 11) *0, disabled.
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: pci_cache_line_size set to 64 bytes
pci 0000:00:14.2: address space collision: [mem 0xcc308000-0xcc30bfff 64bit] conflicts with 0000:00:12.0 [mem 0xcc309000-0xcc3093ff]
reserve RAM buffer: 000000000009fc00 - 000000000009ffff 
reserve RAM buffer: 0000000097fb0000 - 0000000097ffffff 

printing PIC contents
... PIC  IMR: ffff
... PIC  IRR: 0003
... PIC  ISR: 0000
... PIC ELCR: 0e20
printing local APIC contents on CPU#0/0:
... APIC ID:      00000000 (0)
... APIC VERSION: 80050010
... APIC TASKPRI: 00000000 (00)
... APIC ARBPRI: 00000000 (00)
... APIC PROCPRI: 00000000
... APIC LDR: 01000000
... APIC DFR: ffffffff
... APIC SPIV: 000001ff
... APIC ISR field:
0000000000000000000000000000000000000000000000000000000000000000
... APIC TMR field:
0000000000000000000000000000000000000000000000000000000000000000
... APIC IRR field:
0000000000000000000000000000000000000000000000000000000000008000
... APIC ESR: 00000000
... APIC ICR: 000008fd
... APIC ICR2: 02000000
... APIC LVTT: 000300ef
... APIC LVTPC: 00000400
... APIC LVT0: 00010700
... APIC LVT1: 00000400
... APIC LVTERR: 000000fe
... APIC TMICT: 00000000
... APIC TMCCT: 00000000
... APIC TDCR: 00000003
... APIC EFEAT: 00010003
... APIC ECTRL: 00000000
... APIC EILVT0: 000000f9

number of MP IRQ sources: 16.
number of IO-APIC #2 registers: 24.
testing the IO APIC.......................

IO APIC #2......
.... register #00: 00000000
.......    : physical APIC id: 00
.......    : Delivery Type: 0
.......    : LTS          : 0
.... register #01: 00178021
.......     : max redirection entries: 0017
.......     : PRQ implemented: 1
.......     : IO APIC version: 0021
.... register #02: 00000000
.......     : arbitration: 00
.... IRQ redirection table:
 NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:
 00 003 0    0    0   0   0    1    1    30
 01 003 1    0    0   0   0    1    1    31
 02 003 1    0    0   0   0    0    0    32
 03 003 0    0    0   0   0    1    1    33
 04 003 0    0    0   0   0    1    1    34
 05 003 0    0    0   0   0    1    1    35
 06 003 0    0    0   0   0    1    1    36
 07 003 0    0    0   0   0    1    1    37
 08 003 0    0    0   0   0    1    1    38
 09 003 0    1    0   1   0    1    1    39
 0a 003 0    0    0   0   0    1    1    3A
 0b 003 0    0    0   0   0    1    1    3B
 0c 003 0    0    0   0   0    1    1    3C
 0d 003 0    0    0   0   0    1    1    3D
 0e 003 0    0    0   0   0    1    1    3E
 0f 003 0    0    0   0   0    1    1    3F
 10 000 1    0    0   0   0    0    0    00
 11 000 1    0    0   0   0    0    0    00
 12 000 1    0    0   0   0    0    0    00
 13 000 1    0    0   0   0    0    0    00
 14 000 1    0    0   0   0    0    0    00
 15 000 1    0    0   0   0    0    0    00
 16 000 1    0    0   0   0    0    0    00
 17 000 1    0    0   0   0    0    0    00
IRQ to pin mappings:
IRQ0 -> 0:0
IRQ1 -> 0:1
IRQ2 -> 0:2
IRQ3 -> 0:3
IRQ4 -> 0:4
IRQ5 -> 0:5
IRQ6 -> 0:6
IRQ7 -> 0:7
IRQ8 -> 0:8
IRQ9 -> 0:9
IRQ10 -> 0:10
IRQ11 -> 0:11
IRQ12 -> 0:12
IRQ13 -> 0:13
IRQ14 -> 0:14
IRQ15 -> 0:15
.................................... done.
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp 00:00: [mem 0x00000000-0x0009ffff]
pnp 00:00: [mem 0x000e0000-0x000fffff]
pnp 00:00: [mem 0x00100000-0xffffffff]
system 00:00: [mem 0x00000000-0x0009ffff] could not be reserved
system 00:00: [mem 0x000e0000-0x000fffff] could not be reserved
system 00:00: [mem 0x00100000-0xffffffff] could not be reserved
system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
pnp 00:01: [bus 00-ff]
pnp 00:01: [io  0x0cf8-0x0cff]
pnp 00:01: [io  0x0000-0x0cf7 window]
pnp 00:01: [io  0x0d00-0xffff window]
pnp 00:01: [mem 0x000a0000-0x000bffff window]
pnp 00:01: [mem 0xa0000000-0xfedfffff window]
pnp 00:01: [mem 0xfee01000-0xffffffff window]
pnp 00:01: [mem 0x000d0000-0x000dffff window]
pnp 00:01: Plug and Play ACPI device, IDs PNP0a03 (active)
pnp 00:02: [io  0x00f0-0x00ff]
IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0)
pnp 00:02: [irq 13]
pnp 00:02: Plug and Play ACPI device, IDs PNP0c04 (active)
pnp 00:03: [io  0x0000-0x000f]
pnp 00:03: [io  0x0080-0x008f]
pnp 00:03: [io  0x00c0-0x00df]
pnp 00:03: [dma 4]
pnp 00:03: Plug and Play ACPI device, IDs PNP0200 (active)
pnp 00:04: [io  0x0061]
pnp 00:04: Plug and Play ACPI device, IDs PNP0800 (active)
pnp 00:05: [io  0x0070-0x0071]
pnp 00:05: [io  0x0072-0x0073]
IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0)
pnp 00:05: [irq 8]
pnp 00:05: Plug and Play ACPI device, IDs PNP0b00 (active)
pnp 00:06: [io  0x0060]
pnp 00:06: [io  0x0064]
IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0)
pnp 00:06: [irq 1]
pnp 00:06: Plug and Play ACPI device, IDs PNP0303 (active)
IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0)
pnp 00:07: [irq 12]
pnp 00:07: Plug and Play ACPI device, IDs SYN0131 SYN0100 SYN0002 PNP0f13 (active)
pnp 00:08: [io  0x0010-0x001f]
pnp 00:08: [io  0x0022-0x0023]
pnp 00:08: [io  0x002e-0x002f]
pnp 00:08: [io  0x004e-0x004f]
pnp 00:08: [io  0x0092]
pnp 00:08: [io  0x00b0-0x00b1]
pnp 00:08: [io  0x040b]
pnp 00:08: [io  0x04d0-0x04d1]
pnp 00:08: [io  0x04d6]
pnp 00:08: [io  0x0500-0x053f]
pnp 00:08: [io  0x0c00-0x0c01]
pnp 00:08: [io  0x0c14]
pnp 00:08: [io  0x0c50-0x0c51]
pnp 00:08: [io  0x0c52]
pnp 00:08: [io  0x0c6c]
pnp 00:08: [io  0x0c6f]
pnp 00:08: [io  0x0cd0-0x0cdf]
pnp 00:08: [mem 0xffb00000-0xffbfffff]
pnp 00:08: [mem 0xfff00000-0xffffffff]
system 00:08: [io  0x040b] has been reserved
system 00:08: [io  0x04d0-0x04d1] has been reserved
system 00:08: [io  0x04d6] has been reserved
system 00:08: [io  0x0500-0x053f] has been reserved
system 00:08: [io  0x0c00-0x0c01] has been reserved
system 00:08: [io  0x0c14] has been reserved
system 00:08: [io  0x0c50-0x0c51] has been reserved
system 00:08: [io  0x0c52] has been reserved
system 00:08: [io  0x0c6c] has been reserved
system 00:08: [io  0x0c6f] has been reserved
system 00:08: [io  0x0cd0-0x0cdf] has been reserved
system 00:08: [mem 0xffb00000-0xffbfffff] could not be reserved
system 00:08: [mem 0xfff00000-0xffffffff] has been reserved
system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
IOAPIC[0]: Set routing entry (2-22 -> 0x29 -> IRQ 22 Mode:0 Active:0)
pnp 00:09: [irq 22]
pnp 00:09: Plug and Play ACPI device, IDs HPQ0004 (active)
pnp 00:0a: [io  0x8000-0x802f]
pnp 00:0a: [io  0x8100-0x811f]
pnp 00:0a: [mem 0xe0000000-0xefffffff]
pnp 00:0a: [mem 0xfec00000-0xfec000ff]
pnp 00:0a: [mem 0xfed45000-0xfed8ffff]
system 00:0a: [io  0x8000-0x802f] has been reserved
system 00:0a: [io  0x8100-0x811f] has been reserved
system 00:0a: [mem 0xe0000000-0xefffffff] has been reserved
system 00:0a: [mem 0xfec00000-0xfec000ff] could not be reserved
system 00:0a: [mem 0xfed45000-0xfed8ffff] has been reserved
system 00:0a: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:0b: [mem 0x000cd400-0x000cffff]
pnp 00:0b: [mem 0x00000000-0x07ffffff]
pnp 00:0b: [mem 0xfee00000-0xfee00fff]
system 00:0b: [mem 0x000cd400-0x000cffff] has been reserved
system 00:0b: [mem 0x00000000-0x07ffffff] could not be reserved
system 00:0b: [mem 0xfee00000-0xfee00fff] has been reserved
system 00:0b: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp: PnP ACPI: found 12 devices
ACPI: ACPI bus type pnp unregistered
Switching to clocksource acpi_pm
pci 0000:00:14.4: BAR 9: assigned [mem 0xa0000000-0xa3ffffff pref]
pci 0000:00:14.2: BAR 0: assigned [mem 0xa4000000-0xa4003fff 64bit]
pci 0000:00:14.2: BAR 0: set to [mem 0xa4000000-0xa4003fff 64bit] (PCI address [0xa4000000-0xa4003fff])
pci 0000:00:14.4: BAR 7: assigned [io  0x1000-0x1fff]
pci 0000:00:01.0: PCI bridge to [bus 01-01]
pci 0000:00:01.0:   bridge window [io  0x4000-0x4fff]
pci 0000:00:01.0:   bridge window [mem 0xcc100000-0xcc2fffff]
pci 0000:00:01.0:   bridge window [mem 0xc0000000-0xc7ffffff 64bit pref]
pci 0000:00:05.0: PCI bridge to [bus 20-20]
pci 0000:00:05.0:   bridge window [io  0x2000-0x3fff]
pci 0000:00:05.0:   bridge window [mem 0xc8000000-0xcbffffff]
pci 0000:00:05.0:   bridge window [mem pref disabled]
pci 0000:02:04.0: BAR 9: assigned [mem 0xa0000000-0xa3ffffff pref]
pci 0000:02:04.0: BAR 10: assigned [mem 0xa8000000-0xabffffff]
pci 0000:02:04.0: BAR 7: assigned [io  0x1000-0x10ff]
pci 0000:02:04.0: BAR 8: assigned [io  0x1400-0x14ff]
pci 0000:02:04.0: CardBus bridge to [bus 03-06]
pci 0000:02:04.0:   bridge window [io  0x1000-0x10ff]
pci 0000:02:04.0:   bridge window [io  0x1400-0x14ff]
pci 0000:02:04.0:   bridge window [mem 0xa0000000-0xa3ffffff pref]
pci 0000:02:04.0:   bridge window [mem 0xa8000000-0xabffffff]
pci 0000:00:14.4: PCI bridge to [bus 02-03]
pci 0000:00:14.4:   bridge window [io  0x1000-0x1fff]
pci 0000:00:14.4:   bridge window [mem 0xcc000000-0xcc0fffff]
pci 0000:00:14.4:   bridge window [mem 0xa0000000-0xa3ffffff pref]
pci 0000:00:05.0: setting latency timer to 64
IOAPIC[0]: Set routing entry (2-20 -> 0x41 -> IRQ 20 Mode:1 Active:1)
pci 0000:02:04.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
pci_bus 0000:00: resource 5 [mem 0xa0000000-0xfcffffffff]
pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
pci_bus 0000:01: resource 0 [io  0x4000-0x4fff]
pci_bus 0000:01: resource 1 [mem 0xcc100000-0xcc2fffff]
pci_bus 0000:01: resource 2 [mem 0xc0000000-0xc7ffffff 64bit pref]
pci_bus 0000:20: resource 0 [io  0x2000-0x3fff]
pci_bus 0000:20: resource 1 [mem 0xc8000000-0xcbffffff]
pci_bus 0000:02: resource 0 [io  0x1000-0x1fff]
pci_bus 0000:02: resource 1 [mem 0xcc000000-0xcc0fffff]
pci_bus 0000:02: resource 2 [mem 0xa0000000-0xa3ffffff pref]
pci_bus 0000:02: resource 4 [io  0x0000-0xffff]
pci_bus 0000:02: resource 5 [mem 0xa0000000-0xfcffffffff]
pci_bus 0000:02: resource 6 [mem 0x000a0000-0x000bffff]
pci_bus 0000:03: resource 0 [io  0x1000-0x10ff]
pci_bus 0000:03: resource 1 [io  0x1400-0x14ff]
pci_bus 0000:03: resource 2 [mem 0xa0000000-0xa3ffffff pref]
pci_bus 0000:03: resource 3 [mem 0xa8000000-0xabffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
UDP hash table entries: 2048 (order: 4, 65536 bytes)
UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
NET: Registered protocol family 1
pci 0000:01:05.0: Boot video device
PCI: CLS 64 bytes, default 64
msgmni has been set to 4772
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
ACPI: AC Adapter [C1EB] (on-line)
input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input0
ACPI: Sleep Button [C28D]
input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input1
ACPI: Lid Switch [C265]
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
ACPI: Power Button [PWRF]
ACPI: Fan [C399] (off)
ACPI: Fan [C39A] (off)
ACPI: Fan [C39B] (off)
ACPI: Fan [C39C] (off)
ACPI: acpi_idle registered with cpuidle
ACPI: processor limited to max C-state 1
thermal LNXTHERM:00: registered as thermal_zone0
ACPI: Thermal Zone [TZ1] (44 C)
ACPI: Battery Slot [C1ED] (battery absent)
ACPI: Battery Slot [C1EC] (battery absent)
ahci 0000:00:12.0: version 3.0
IOAPIC[0]: Set routing entry (2-16 -> 0x49 -> IRQ 16 Mode:1 Active:1)
ahci 0000:00:12.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
ahci 0000:00:12.0: controller can't do 64bit DMA, forcing 32bit
ahci 0000:00:12.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0x1 impl SATA mode
ahci 0000:00:12.0: flags: ncq sntf ilck pm led clo pio slum part ccc 
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
ata1: SATA max UDMA/133 abar m1024@0xcc309000 port 0xcc309100 irq 16
ata2: DUMMY
ata3: DUMMY
ata4: DUMMY
pata_atiixp 0000:00:14.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
scsi4 : pata_atiixp
scsi5 : pata_atiixp
ata5: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x5040 irq 14
ata6: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x5048 irq 15
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
IOAPIC[0]: Set routing entry (2-23 -> 0x51 -> IRQ 23 Mode:1 Active:1)
ehci_hcd 0000:00:13.5: PCI INT D -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:13.5: EHCI Host Controller
ehci_hcd 0000:00:13.5: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:13.5: applying AMD SB600/SB700 USB freeze workaround
ehci_hcd 0000:00:13.5: debug port 1
ehci_hcd 0000:00:13.5: irq 23, io mem 0xcc306000
ehci_hcd 0000:00:13.5: USB 2.0 started, EHCI 1.00
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 10 ports detected
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
ohci_hcd 0000:00:13.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
ohci_hcd 0000:00:13.0: OHCI Host Controller
ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:13.0: irq 23, io mem 0xcc301000
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
IOAPIC[0]: Set routing entry (2-17 -> 0x59 -> IRQ 17 Mode:1 Active:1)
ohci_hcd 0000:00:13.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
ohci_hcd 0000:00:13.1: OHCI Host Controller
ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 3
ohci_hcd 0000:00:13.1: irq 17, io mem 0xcc302000
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
ohci_hcd 0000:00:13.2: PCI INT C -> GSI 17 (level, low) -> IRQ 17
ohci_hcd 0000:00:13.2: OHCI Host Controller
ohci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 4
ohci_hcd 0000:00:13.2: irq 17, io mem 0xcc303000
ata5.00: ATAPI: TSSTcorpCDW/DVD TS-L462D, HH08, max MWDMA2
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
ohci_hcd 0000:00:13.3: PCI INT B -> GSI 17 (level, low) -> IRQ 17
ohci_hcd 0000:00:13.3: OHCI Host Controller
ohci_hcd 0000:00:13.3: new USB bus registered, assigned bus number 5
ohci_hcd 0000:00:13.3: irq 17, io mem 0xcc304000
ata5.00: configured for MWDMA2
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
ohci_hcd 0000:00:13.4: PCI INT C -> GSI 17 (level, low) -> IRQ 17
ohci_hcd 0000:00:13.4: OHCI Host Controller
ohci_hcd 0000:00:13.4: new USB bus registered, assigned bus number 6
ohci_hcd 0000:00:13.4: irq 17, io mem 0xcc305000
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 2 ports detected
i8042: PNP: PS/2 Controller [PNP0303:C249,PNP0f13:C24A] at 0x60,0x64 irq 1,12
i8042: Detected active multiplexing controller, rev 1.1
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX0 port at 0x60,0x64 irq 12
serio: i8042 AUX1 port at 0x60,0x64 irq 12
serio: i8042 AUX2 port at 0x60,0x64 irq 12
serio: i8042 AUX3 port at 0x60,0x64 irq 12
rtc_cmos 00:05: RTC can wake from S4
rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month, y3k, 114 bytes nvram
EDAC MC: Ver: 2.1.0 Mar 11 2011
EDAC amd64_edac: v3.3.0
EDAC amd64: DRAM ECC disabled.
EDAC amd64: ECC disabled in the BIOS or no ECC capability, module will not load.
 Either enable ECC checking or force module loading by setting 'ecc_enable_override'.
 (Note that use of the override may cause unknown side effects.)
cpuidle: using governor ladder
Netfilter messages via NETLINK v0.30.
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 10
IPv6 over IPv4 tunneling driver
NET: Registered protocol family 17
NET: Registered protocol family 15
rtc_cmos 00:05: setting system clock to 2011-03-11 12:32:12 UTC (1299846732)
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ATA-7: FUJITSU MHW2120BH, 8918, max UDMA/100
ata1.00: 234441648 sectors, multi 16: LBA48 
ata1.00: SB600 AHCI: limiting to 255 sectors per cmd
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
ata1.00: SB600 AHCI: limiting to 255 sectors per cmd
ata1.00: configured for UDMA/100
scsi 0:0:0:0: Direct-Access     ATA      FUJITSU MHW2120B 8918 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 234441648 512-byte logical blocks: (120 GB/111 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: Attached scsi generic sg0 type 0
scsi 4:0:0:0: CD-ROM            TSSTcorp CDW/DVD TS-L462D HH08 PQ: 0 ANSI: 5
 sda: sda1 sda2 < sda5 sda6 >
sd 0:0:0:0: [sda] Attached SCSI disk
sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda tray
cdrom: Uniform CD-ROM driver Revision: 3.20
sr 4:0:0:0: Attached scsi CD-ROM sr0
sr 4:0:0:0: Attached scsi generic sg1 type 5
EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
VFS: Mounted root (ext2 filesystem) readonly on device 8:1.
devtmpfs: mounted
Freeing unused kernel memory: 368k freed
udev[709]: starting version 166
Synaptics Touchpad, model: 1, fw: 6.2, id: 0x2580b1, caps: 0xa04793/0x300000/0x0
serio: Synaptics pass-through port at isa0060/serio4/input0
input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio4/input/input4
EXT4-fs (sda1): re-mounted. Opts: (null)
EXT4-fs (sda1): re-mounted. Opts: errors=remount-ro
EXT4-fs (sda5): warning: maximal mount count reached, running e2fsck is recommended
EXT4-fs (sda5): mounted filesystem with ordered data mode. Opts: (null)

--=-=-=
Content-Type: text/plain
Content-Disposition: attachment; filename=lspci2
Content-Description: lspci

00:00.0 Host bridge [0600]: ATI Technologies Inc RS690 Host Bridge [1002:7910]
00: 02 10 10 79 06 00 20 22 00 00 00 06 00 40 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 3c 10 c2 30
30: 00 00 00 00 c4 00 00 00 00 00 00 00 00 00 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 42 20 05 00
50: 3c 10 c2 30 00 00 00 00 00 00 00 00 00 00 00 00
60: 88 00 00 00 30 00 c0 07 00 02 20 00 d8 f8 01 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 40 42 00 00 95 00 00 03 20 11 10 00 03 26 00 10
90: 00 00 00 98 40 c3 40 e3 00 c0 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 07 01 00 00 49 01 10 07
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 08 00 94 01 60 20 11 11 d0 00 00 00
d0: 25 05 65 00 02 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 e0 e0 00 00 04 01 00 00 00 01 00 0f
f0: 00 00 00 00 00 80 80 00 00 00 00 00 00 00 00 00

00:01.0 PCI bridge [0604]: ATI Technologies Inc RS690 PCI to PCI Bridge (Internal gfx) [1002:7912]
00: 02 10 12 79 07 00 30 02 00 00 04 06 00 40 01 00
10: 00 00 00 00 00 00 00 00 00 01 01 00 41 41 20 02
20: 10 cc 20 cc 01 c0 f1 c7 00 00 00 00 00 00 00 00
30: 00 00 00 00 44 00 00 00 00 00 00 00 00 00 0c 00
40: 00 00 00 00 08 b0 03 a8 00 00 00 00 3c 10 c2 30
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 0d 00 00 00 3c 10 c2 30 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:05.0 PCI bridge [0604]: ATI Technologies Inc RS690 PCI to PCI Bridge (PCI Express Port 1) [1002:7915]
00: 02 10 15 79 07 00 10 00 00 00 04 06 10 00 01 00
10: 00 00 00 00 00 00 00 00 00 20 20 00 21 31 00 00
20: 00 c8 f0 cb f1 ff 01 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 50 00 00 00 00 00 00 00 00 00 04 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 01 58 03 c8 00 00 00 00 10 80 41 01 20 80 00 00
60: 10 08 00 00 11 0c 10 f7 00 00 01 11 00 00 00 00
70: c0 03 00 00 00 00 01 00 00 00 00 00 00 00 00 00
80: 05 b0 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 0d b8 00 00 3c 10 c2 30 08 00 03 a8 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: a5 00 00 00 02 01 00 04 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:12.0 SATA controller [0106]: ATI Technologies Inc SB600 Non-Raid-5 SATA [1002:4380]
00: 02 10 80 43 07 00 30 02 00 01 06 01 10 40 00 00
10: 01 90 00 00 09 90 00 00 11 90 00 00 19 50 00 00
20: 21 50 00 00 00 90 30 cc 00 00 00 00 02 10 80 43
30: 00 00 00 00 60 00 00 00 00 00 00 00 0a 01 00 00
40: 10 00 8e 02 01 00 10 00 01 00 00 00 00 00 00 00
50: 05 00 84 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 01 00 22 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 12 00 10 00 0f 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 06 00 00 2c d6 01 b4 00 d6 01 b4 00
90: d6 01 b4 00 d6 01 b4 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 78 00 00 00 00 00 00 00 78 00 00
b0: 00 00 00 00 00 78 00 00 00 00 00 00 00 78 00 00
c0: 00 20 00 00 80 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:13.0 USB Controller [0c03]: ATI Technologies Inc SB600 USB (OHCI0) [1002:4387]
00: 02 10 87 43 07 00 a0 02 00 10 03 0c 10 40 80 00
10: 00 10 30 cc 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 3c 10 c2 30
30: 00 00 00 00 00 00 00 00 00 00 00 00 0b 01 00 00
40: 80 1f 1a 01 0a 84 b7 18 07 35 00 00 00 00 00 00
50: 00 9d 00 00 00 00 00 00 ff ff ff ff ff 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 ff 00 00 80 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:13.1 USB Controller [0c03]: ATI Technologies Inc SB600 USB (OHCI1) [1002:4388]
00: 02 10 88 43 07 00 a0 02 00 10 03 0c 10 40 00 00
10: 00 20 30 cc 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 3c 10 c2 30
30: 00 00 00 00 00 00 00 00 00 00 00 00 05 02 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:13.2 USB Controller [0c03]: ATI Technologies Inc SB600 USB (OHCI2) [1002:4389]
00: 02 10 89 43 07 00 a0 02 00 10 03 0c 10 40 00 00
10: 00 30 30 cc 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 3c 10 c2 30
30: 00 00 00 00 00 00 00 00 00 00 00 00 05 03 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:13.3 USB Controller [0c03]: ATI Technologies Inc SB600 USB (OHCI3) [1002:438a]
00: 02 10 8a 43 07 00 a0 02 00 10 03 0c 10 40 00 00
10: 00 40 30 cc 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 3c 10 c2 30
30: 00 00 00 00 00 00 00 00 00 00 00 00 05 02 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:13.4 USB Controller [0c03]: ATI Technologies Inc SB600 USB (OHCI4) [1002:438b]
00: 02 10 8b 43 07 00 a0 02 00 10 03 0c 10 40 00 00
10: 00 50 30 cc 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 3c 10 c2 30
30: 00 00 00 00 00 00 00 00 00 00 00 00 05 03 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:13.5 USB Controller [0c03]: ATI Technologies Inc SB600 USB Controller (EHCI) [1002:4386]
00: 02 10 86 43 17 00 b0 02 00 20 03 0c 10 40 00 00
10: 00 60 30 cc 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 3c 10 c2 30
30: 00 00 00 00 c0 00 00 00 00 00 00 00 0b 04 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 40 00 0e 08 00 00 00 00 00 00 00 00 00 00 00 00
60: 20 20 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 01 00 00 00 00 00 08 c0 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 01 e4 02 7e 00 00 40 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 0a 00 e0 20 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:14.0 SMBus [0c05]: ATI Technologies Inc SBx00 SMBus Controller [1002:4385] (rev 14)
00: 02 10 85 43 03 00 30 02 14 00 05 0c 00 00 80 00
10: 01 82 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 3c 10 c2 30
30: 00 00 00 00 b0 00 00 00 00 00 00 00 00 00 00 00
40: d4 33 00 04 00 00 00 00 0f ff 00 00 00 00 00 00
50: f0 0f 00 00 00 00 00 00 11 82 f0 0f 00 00 00 00
60: 01 00 25 00 bf 39 de 03 3f d3 00 00 20 00 00 00
70: 00 01 00 00 08 00 c0 fe ff 4b 00 00 00 00 f0 0f
80: 50 01 c2 3e 00 00 00 00 00 00 00 00 8c 00 00 80
90: 01 82 00 00 f9 ce bf 00 00 00 00 00 00 00 00 00
a0: 00 00 ff ff ff ff 78 09 13 cc 13 02 16 7b 20 00
b0: 08 00 02 a8 00 00 00 00 00 00 00 00 f0 0b 0f 39
c0: ff ff ff ff 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 20 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: d8 0c 00 00 00 00 44 00 00 00 00 00 fa 00 30 01

00:14.1 IDE interface [0101]: ATI Technologies Inc SB600 IDE [1002:438c]
00: 02 10 8c 43 05 00 20 02 00 82 01 01 10 40 00 00
10: 01 00 00 00 01 00 00 00 01 00 00 00 01 00 00 00
20: 41 50 00 00 00 00 00 00 00 00 00 00 3c 10 c2 30
30: 00 00 00 00 00 00 00 00 00 00 00 00 0a 01 00 00
40: 5d 20 00 00 ff 20 00 00 00 01 04 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 40 00 10 2c 01 07 01 00 00 00 ff ff 0f 00
70: 05 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:14.2 Audio device [0403]: ATI Technologies Inc SBx00 Azalia (Intel HDA) [1002:4383]
00: 02 10 83 43 06 00 10 04 00 00 03 04 10 40 00 00
10: 04 00 00 a4 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 3c 10 c2 30
30: 00 00 00 00 50 00 00 00 00 00 00 00 0a 01 00 00
40: 00 00 00 00 01 00 00 00 00 00 00 00 01 00 00 00
50: 01 00 42 c8 00 00 00 00 00 00 00 00 00 00 00 00
60: 05 00 80 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:14.3 ISA bridge [0601]: ATI Technologies Inc SB600 PCI to LPC Bridge [1002:438d]
00: 02 10 8d 43 0f 00 20 02 00 00 01 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 3c 10 c2 30
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
40: 04 00 00 00 bc 0d c3 ff 1b ff 4e 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 0a 00 00 0f 00 00 00 f0 ff ff ff
70: 67 45 23 01 00 00 00 00 01 00 00 00 05 00 00 00
80: 08 00 03 a8 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 20 30 b8 ff 00 00 00 00 00 00 00 00 00 00 00 00
b0: 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:14.4 PCI bridge [0604]: ATI Technologies Inc SBx00 PCI to PCI Bridge [1002:4384]
00: 02 10 84 43 27 00 a0 02 00 01 04 06 00 40 81 00
10: 00 00 00 00 00 00 00 00 00 02 03 40 10 10 80 22
20: 00 cc 00 cc 00 a0 f0 a3 00 00 00 00 00 00 00 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 04 00
40: 26 00 3c ff 00 00 00 00 0c 01 3c d1 03 02 00 00
50: 01 08 00 00 08 00 03 a8 00 00 00 00 85 00 ff ff
60: ca 0e 17 00 ba 98 10 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 01 00 02 06
e0: 00 00 80 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:18.0 Host bridge [0600]: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration [1022:1100]
00: 22 10 00 11 00 00 10 00 00 00 00 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 80 00 00 00 00 00 00 00 00 00 00 00
40: 01 01 01 00 01 01 01 00 01 01 01 00 01 01 01 00
50: 01 01 01 00 01 01 01 00 01 01 01 00 01 01 01 00
60: 00 00 01 00 e4 00 00 00 20 c8 2f 0f 0c 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 08 00 01 21 20 a8 11 11 22 05 35 80 02 00 00 00
90: 78 01 70 01 00 00 ff 00 07 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:18.1 Host bridge [0600]: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Address Map [1022:1101]
00: 22 10 01 11 00 00 00 00 00 00 00 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
40: 03 00 00 00 00 00 9f 00 00 00 00 00 01 00 00 00
50: 00 00 00 00 02 00 00 00 00 00 00 00 03 00 00 00
60: 00 00 00 00 04 00 00 00 00 00 00 00 05 00 00 00
70: 00 00 00 00 06 00 00 00 00 00 00 00 07 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 03 00 e0 00 80 ff ef 00 03 00 f0 00 00 ff ff 00
a0: 03 00 c8 00 00 ff df 00 03 00 c0 00 80 ff c7 00
b0: 03 0a 00 00 00 0b 00 00 03 00 a0 00 00 ff bf 00
c0: 00 00 00 00 00 00 00 00 13 10 00 00 00 f0 0f 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 03 00 00 ff 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:18.2 Host bridge [0600]: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM Controller [1022:1102]
00: 22 10 02 11 00 00 00 00 00 00 00 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
40: 01 00 80 00 01 00 90 00 00 00 00 00 00 00 00 00
50: 01 00 00 00 01 00 40 00 00 00 00 00 00 00 00 00
60: e0 3f 08 00 00 00 00 00 e0 3f 38 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 46 00 00 00 00 00 00 00
80: 01 05 00 00 00 00 00 00 24 c2 aa 5d 20 13 12 08
90: 20 04 01 00 6a 80 11 a7 38 00 00 80 00 00 00 00
a0: ff 06 00 5d 00 00 00 00 00 00 00 00 00 00 00 00
b0: d0 3a 9d b6 69 00 00 00 48 40 10 52 b5 60 be a1
c0: 00 00 03 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 3f 80 0c 0c 23 13 a3 3c 21 88 0a 02 96 03 10 80
e0: 63 02 08 ec 03 1a 99 2c 19 c0 00 83 b8 01 0c 88
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:18.3 Host bridge [0600]: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Miscellaneous Control [1022:1103]
00: 22 10 03 11 00 00 10 00 00 00 00 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 f0 00 00 00 00 00 00 00 00 00 00 00
40: ff 3b 04 00 40 00 10 0a 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 80 20 51 ec
60: 35 00 00 00 01 77 1f 00 00 00 00 00 00 00 00 00
70: 11 01 32 51 21 40 30 50 00 2a 00 08 1b 21 00 00
80: 31 37 07 33 13 31 13 31 00 00 00 00 00 00 00 00
90: 00 00 00 00 97 20 00 00 60 01 02 44 00 00 00 00
a0: 9a 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 01 a7 0d 00 00 00 00 09 25 26 26 00
e0: 00 00 00 00 20 0e 5e 00 01 17 00 00 00 00 00 00
f0: 0f 00 10 00 00 00 00 00 00 00 00 00 82 0f 04 00

01:05.0 VGA compatible controller [0300]: ATI Technologies Inc RS690M [Radeon X1200 Series] [1002:791f]
00: 02 10 1f 79 07 00 10 00 00 00 00 03 10 40 00 00
10: 0c 00 00 c0 00 00 00 00 04 00 10 cc 00 00 00 00
20: 01 40 00 00 00 00 20 cc 00 00 00 00 3c 10 c2 30
30: 00 00 00 00 50 00 00 00 00 00 00 00 0b 02 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 3c 10 c2 30
50: 01 80 02 06 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 05 00 80 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

02:04.0 CardBus bridge [0607]: Ricoh Co Ltd RL5c476 II [1180:0476] (rev b6)
00: 80 11 76 04 07 00 10 02 b6 00 07 06 00 40 82 00
10: 00 00 00 cc dc 00 00 02 02 03 06 b0 00 00 00 a0
20: 00 f0 ff a3 00 00 00 a8 00 f0 ff ab 00 10 00 00
30: fc 10 00 00 00 14 00 00 fc 14 00 00 0a 01 80 07
40: 3c 10 c2 30 01 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 01 00 a0 30 00 00 00 00 63 04 63 04 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 08 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 bf 00 30 00 00 00 00 00 00
c0: 3c 10 c2 30 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 01 00 0a fe
e0: 00 40 c0 24 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00


--=-=-=
Content-Type: text/plain


-- 
Regards,
Lei

--=-=-=--
