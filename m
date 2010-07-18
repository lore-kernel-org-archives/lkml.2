Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756659Ab0GRQZb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jul 2010 12:25:31 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:64005 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756618Ab0GRQZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jul 2010 12:25:30 -0400
Date: Sun, 18 Jul 2010 18:24:49 +0200
From: Heinz Diehl <htd@fancy-poultry.org>
To: Michal Schmidt <mschmidt@redhat.com>
Cc: Borislav Petkov <borislav.petkov@amd.com>,
        Hans Rosenfeld <hans.rosenfeld@amd.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Shaohua Li <shaohua.li@intel.com>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/2] x86: fix keeping track of AMD C1E
Message-ID: <20100718162449.GB21151@fancy-poultry.org>
References: <909896077.345011279054483129.JavaMail.root@zmail02.collab.prod.int.phx2.redhat.com>
 <95386209.346271279054917131.JavaMail.root@zmail02.collab.prod.int.phx2.redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ReaqsoxgOBHFXBhH"
Content-Disposition: inline
In-Reply-To: <95386209.346271279054917131.JavaMail.root@zmail02.collab.prod.int.phx2.redhat.com>
X-Accept-Language: no,dk,se,en,de
Organization: private site
X-OpenPGP-KeyID: 0xA9353F12
X-OpenPGP-Fingerprint: C67E 9A93 1033 DF8A 9321  9F90 DC39 B8C3 A935 3F12
X-OpenPGP-URL: http://www.fritha.org/htd.asc
User-Agent: Mutt/1.5.20+20100619 (GNU/Linux)
X-Provags-ID: V02:K0:Rts9yYH94yULXhxnkpZdyrvzoznLgBAClWCGf8AkKx/
 kEcHKqf+lTPfDD/cN322SKHVkpceJY1yKNyh8fEDU6Dumu6d+3
 wg+KSl0u5CWMF08UcH4gXVhX11XkN/2xurm+3KjDBJSdLB85kk
 Vq6PLoFFYOiwoumz8jib14hy+AgIstc/GDGWB1cxBe1bfLZkae
 wkQu4w8iVVhsGza2i86og==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 14.07.2010, Michal Schmidt wrote: 

> I found another person reporting the same symptoms on
> GIGABYTE GA-MA770T-UD3P AthlonXII 620 (4 cores) kernel 2.6.33.5 (Mandriva)
> (http://www.abclinuxu.cz/poradna/hardware/show/308799, in Czech)

Here's the relevant part of my dmesg, kernel 2.6.35-rc5 with your
debbuging patch applied (just the debbuging patch, no other fix/patch in
this thread). The full dmesg output is attached.

[....]
Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
Mount-cache hash table entries: 256
tseg: 00cfe00000
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
identify_cpu: before ANDing, c1e_detected: 0, boot_cpu_has(C1E): 0
identify_cpu:  after ANDing, c1e_detected: 0, boot_cpu_has(C1E): 0
mce: CPU supports 6 MCE banks
using C1E aware idle routine
Performance Events: AMD PMU driver.
... version:                0
... bit width:              48
... generic registers:      4
... value mask:             0000ffffffffffff
... max period:             00007fffffffffff
... fixed-purpose events:   0
... event mask:             000000000000000f
ACPI: Core revision 20100428
Setting APIC routing to flat
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: AMD Phenom(tm) II X4 905e Processor stepping 02
c1e_idle: cpu: 0, bits 0x08000000, c1e_detected: 0, boot_cpu_has(C1E): 0
System has AMD C1E enabled
Switch to broadcast mode on CPU0
Booting Node   0, Processors  #1
identify_cpu: before ANDing, c1e_detected: 1, boot_cpu_has(C1E): 1
identify_cpu:  after ANDing, c1e_detected: 1, boot_cpu_has(C1E): 0
Switch to broadcast mode on CPU1
 #2
 identify_cpu: before ANDing, c1e_detected: 1, boot_cpu_has(C1E): 0
 identify_cpu:  after ANDing, c1e_detected: 1, boot_cpu_has(C1E): 0
 Switch to broadcast mode on CPU2
  #3
 identify_cpu: before ANDing, c1e_detected: 1, boot_cpu_has(C1E): 0
 identify_cpu:  after ANDing, c1e_detected: 1, boot_cpu_has(C1E): 0
 Brought up 4 CPUs
 Total of 4 processors activated (20092.25 BogoMIPS).
 Switch to broadcast mode on CPU3
 NET: Registered protocol family 16
 node 0 link 0: io port [c000, ffff]
 TOM: 00000000d0000000 aka 3328M


--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg01.txt"

Linux version 2.6.35-rc5-c1e_debug (root@liesel) (gcc version 4.3.2 [gcc-4_3-branch revision 141291] (SUSE Linux) ) #1 SMP PREEMPT Sun Jul 18 17:50:33 CEST 2010
Command line: root=/dev/mapper/root luks_root=/dev/sda3 luks="root" resume=/dev/mapper/swap splash=silent vga=0x31a clocksource=hpet pci=use_crs
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 0000000000098400 (usable)
 BIOS-e820: 0000000000098400 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000cfd81000 (usable)
 BIOS-e820: 00000000cfde0000 - 00000000cfde3000 (ACPI NVS)
 BIOS-e820: 00000000cfde3000 - 00000000cfdf0000 (ACPI data)
 BIOS-e820: 00000000cfdf0000 - 00000000cfe00000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000230000000 (usable)
NX (Execute Disable) protection: active
DMI 2.4 present.
e820 update range: 0000000000000000 - 0000000000001000 (usable) ==> (reserved)
e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
No AGP bridge found
last_pfn = 0x230000 max_arch_pfn = 0x400000000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-BFFFF uncachable
  C0000-C7FFF write-protect
  C8000-FFFFF uncachable
MTRR variable ranges enabled:
  0 base 000000000000 mask FFFF80000000 write-back
  1 base 000080000000 mask FFFFC0000000 write-back
  2 base 0000C0000000 mask FFFFF0000000 write-back
  3 base 0000CFE00000 mask FFFFFFE00000 uncachable
  4 base 000100000000 mask FFFF00000000 write-back
  5 base 000200000000 mask FFFFE0000000 write-back
  6 base 000220000000 mask FFFFF0000000 write-back
  7 disabled
TOM2: 0000000230000000 aka 8960M
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
e820 update range: 00000000cfe00000 - 0000000100000000 (usable) ==> (reserved)
last_pfn = 0xcfd81 max_arch_pfn = 0x400000000
initial memory mapped : 0 - 20000000
Using GB pages for direct mapping
init_memory_mapping: 0000000000000000-00000000cfd81000
 0000000000 - 00c0000000 page 1G
 00c0000000 - 00cfc00000 page 2M
 00cfc00000 - 00cfd81000 page 4k
kernel direct mapping tables up to cfd81000 @ 8000-b000
init_memory_mapping: 0000000100000000-0000000230000000
 0100000000 - 0200000000 page 1G
 0200000000 - 0230000000 page 2M
kernel direct mapping tables up to 230000000 @ a000-c000
RAMDISK: 37a0c000 - 37ff0000
ACPI: RSDP 00000000000f6ed0 00014 (v00 GBT   )
ACPI: RSDT 00000000cfde3000 00038 (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
ACPI: FACP 00000000cfde3040 00074 (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
ACPI: DSDT 00000000cfde30c0 06D75 (v01 GBT    GBTUACPI 00001000 MSFT 03000000)
ACPI: FACS 00000000cfde0000 00040
ACPI: SSDT 00000000cfde9f00 0088C (v01 PTLTD  POWERNOW 00000001  LTP 00000001)
ACPI: HPET 00000000cfdea7c0 00038 (v01 GBT    GBTUACPI 42302E31 GBTU 00000098)
ACPI: MCFG 00000000cfdea800 0003C (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
ACPI: APIC 00000000cfde9e40 000BC (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
ACPI: Local APIC address 0xfee00000
No NUMA configuration found
Faking a node at 0000000000000000-0000000230000000
Initmem setup node 0 0000000000000000-0000000230000000
  NODE_DATA [0000000100000000 - 0000000100026fff]
 [ffffea0000000000-ffffea0007bfffff] PMD -> [ffff880100200000-ffff8801073fffff] on node 0
Zone PFN ranges:
  DMA      0x00000001 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x00230000
Movable zone start PFN for each node
early_node_map[3] active PFN ranges
    0: 0x00000001 -> 0x00000098
    0: 0x00000100 -> 0x000cfd81
    0: 0x00100000 -> 0x00230000
On node 0 totalpages: 2096408
  DMA zone: 56 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 3935 pages, LIFO batch:0
  DMA32 zone: 14280 pages used for memmap
  DMA32 zone: 832953 pages, LIFO batch:31
  Normal zone: 17024 pages used for memmap
  Normal zone: 1228160 pages, LIFO batch:31
ACPI: PM-Timer IO Port: 0x4008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x04] disabled)
ACPI: LAPIC (acpi_id[0x05] lapic_id[0x05] disabled)
ACPI: LAPIC (acpi_id[0x06] lapic_id[0x06] disabled)
ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] disabled)
ACPI: LAPIC_NMI (acpi_id[0x00] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x03] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x04] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x05] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x06] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x07] dfl dfl lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 33, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x10b9a201 base: 0xfed00000
SMP: Allowing 8 CPUs, 4 hotplug CPUs
nr_irqs_gsi: 40
early_res array is doubled to 64 at [7000 - 77ff]
PM: Registered nosave memory: 0000000000098000 - 0000000000099000
PM: Registered nosave memory: 0000000000099000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
PM: Registered nosave memory: 00000000cfd81000 - 00000000cfde0000
PM: Registered nosave memory: 00000000cfde0000 - 00000000cfde3000
PM: Registered nosave memory: 00000000cfde3000 - 00000000cfdf0000
PM: Registered nosave memory: 00000000cfdf0000 - 00000000cfe00000
PM: Registered nosave memory: 00000000cfe00000 - 00000000e0000000
PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000
PM: Registered nosave memory: 00000000f0000000 - 00000000fec00000
PM: Registered nosave memory: 00000000fec00000 - 0000000100000000
Allocating PCI resources starting at cfe00000 (gap: cfe00000:10200000)
setup_percpu: NR_CPUS:4096 nr_cpumask_bits:8 nr_cpu_ids:8 nr_node_ids:1
PERCPU: Embedded 27 pages/cpu @ffff880006000000 s81536 r8192 d20864 u262144
pcpu-alloc: s81536 r8192 d20864 u262144 alloc=1*2097152
pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2065048
Policy zone: Normal
Kernel command line: root=/dev/mapper/root luks_root=/dev/sda3 luks="root" resume=/dev/mapper/swap splash=silent vga=0x31a clocksource=hpet pci=use_crs
early_res array is doubled to 128 at [b000 - bfff]
PID hash table entries: 4096 (order: 3, 32768 bytes)
Checking aperture...
No AGP bridge found
Node 0: aperture @ 20000000 size 32 MB
Aperture pointing to e820 RAM. Ignoring.
Your BIOS doesn't leave a aperture memory hole
Please enable the IOMMU option in the BIOS setup
This costs you 64 MB of RAM
Mapping aperture over 65536 KB of RAM @ 20000000
PM: Registered nosave memory: 0000000020000000 - 0000000024000000
Subtract (63 early reservations)
  #1 [0001000000 - 0005e2db04]   TEXT DATA BSS
  #2 [0037a0c000 - 0037ff0000]         RAMDISK
  #3 [0000098400 - 0000100000]   BIOS reserved
  #4 [0005e2e000 - 0005e2e0fe]             BRK
  #5 [0000001000 - 0000003000]      TRAMPOLINE
  #6 [0000003000 - 0000007000]     ACPI WAKEUP
  #7 [0000008000 - 000000a000]         PGTABLE
  #8 [000000a000 - 000000b000]         PGTABLE
  #9 [0100000000 - 0100027000]       NODE_DATA
  #10 [0005e2e100 - 0005e2f100]         BOOTMEM
  #11 [000622f100 - 000622f700]         BOOTMEM
  #12 [0100027000 - 0100028000]         BOOTMEM
  #13 [0100028000 - 0100029000]         BOOTMEM
  #14 [0100200000 - 0107400000]        MEMMAP 0
  #15 [0005e2db40 - 0005e2dcc0]         BOOTMEM
  #16 [0005e2f100 - 0005e47100]         BOOTMEM
  #17 [0005e47100 - 0005e5f100]         BOOTMEM
  #18 [0005e60000 - 0005e61000]         BOOTMEM
  #19 [0005e2dcc0 - 0005e2dd01]         BOOTMEM
  #20 [0005e2dd40 - 0005e2dd83]         BOOTMEM
  #21 [0005e5f100 - 0005e5f368]         BOOTMEM
  #22 [0005e2ddc0 - 0005e2de28]         BOOTMEM
  #23 [0005e2de40 - 0005e2dea8]         BOOTMEM
  #24 [0005e2dec0 - 0005e2df28]         BOOTMEM
  #25 [0005e2df40 - 0005e2dfa8]         BOOTMEM
  #26 [0005e5f380 - 0005e5f3e8]         BOOTMEM
  #27 [0005e5f400 - 0005e5f468]         BOOTMEM
  #28 [0005e5f480 - 0005e5f4e8]         BOOTMEM
  #29 [0005e5f500 - 0005e5f568]         BOOTMEM
  #30 [0005e5f580 - 0005e5f5e8]         BOOTMEM
  #31 [0005e5f600 - 0005e5f668]         BOOTMEM
  #32 [0005e2dfc0 - 0005e2dfe0]         BOOTMEM
  #33 [0005e5f680 - 0005e5f6a0]         BOOTMEM
  #34 [0005e5f6c0 - 0005e5f743]         BOOTMEM
  #35 [0005e5f780 - 0005e5f803]         BOOTMEM
  #36 [0006000000 - 000601b000]         BOOTMEM
  #37 [0006040000 - 000605b000]         BOOTMEM
  #38 [0006080000 - 000609b000]         BOOTMEM
  #39 [00060c0000 - 00060db000]         BOOTMEM
  #40 [0006100000 - 000611b000]         BOOTMEM
  #41 [0006140000 - 000615b000]         BOOTMEM
  #42 [0006180000 - 000619b000]         BOOTMEM
  #43 [00061c0000 - 00061db000]         BOOTMEM
  #44 [0005e5f840 - 0005e5f848]         BOOTMEM
  #45 [0005e5f880 - 0005e5f888]         BOOTMEM
  #46 [0005e5f8c0 - 0005e5f8e0]         BOOTMEM
  #47 [0005e5f900 - 0005e5f940]         BOOTMEM
  #48 [0005e5f940 - 0005e5fa60]         BOOTMEM
  #49 [0005e5fa80 - 0005e5fac8]         BOOTMEM
  #50 [0005e5fb00 - 0005e5fb48]         BOOTMEM
  #51 [0005e5fb80 - 0005e5fd80]         BOOTMEM
  #52 [0005e5fd80 - 0005e5ff80]         BOOTMEM
  #53 [0005e61000 - 0005e61200]         BOOTMEM
  #54 [0005e61200 - 0005e61400]         BOOTMEM
  #55 [0005e61400 - 0005e61600]         BOOTMEM
  #56 [0005e61600 - 0005e69600]         BOOTMEM
  #57 [0020000000 - 0024000000]         BOOTMEM
  #58 [0005e5ff80 - 0005e5ffa0]         BOOTMEM
  #59 [0006230000 - 000a230000]         BOOTMEM
  #60 [0005e69600 - 0005e89600]         BOOTMEM
  #61 [0005e89600 - 0005ec9600]         BOOTMEM
  #62 [000000c000 - 0000014000]         BOOTMEM
Memory: 8050012k/9175040k available (4358k kernel code, 789408k absent, 335620k reserved, 3155k data, 1816k init)
SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
Preemptable hierarchical RCU implementation.
	RCU-based detection of stalled CPUs is disabled.
	Verbose stalled-CPUs detection is disabled.
NR_IRQS:4352
Console: colour dummy device 80x25
console [tty0] enabled
hpet clockevent registered
Fast TSC calibration using PIT
Detected 2511.864 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequency.. 5023.72 BogoMIPS (lpj=2511861)
pid_max: default: 32768 minimum: 301
Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
Mount-cache hash table entries: 256
tseg: 00cfe00000
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
identify_cpu: before ANDing, c1e_detected: 0, boot_cpu_has(C1E): 0
identify_cpu:  after ANDing, c1e_detected: 0, boot_cpu_has(C1E): 0
mce: CPU supports 6 MCE banks
using C1E aware idle routine
Performance Events: AMD PMU driver.
... version:                0
... bit width:              48
... generic registers:      4
... value mask:             0000ffffffffffff
... max period:             00007fffffffffff
... fixed-purpose events:   0
... event mask:             000000000000000f
ACPI: Core revision 20100428
Setting APIC routing to flat
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: AMD Phenom(tm) II X4 905e Processor stepping 02
c1e_idle: cpu: 0, bits 0x08000000, c1e_detected: 0, boot_cpu_has(C1E): 0
System has AMD C1E enabled
Switch to broadcast mode on CPU0
Booting Node   0, Processors  #1
identify_cpu: before ANDing, c1e_detected: 1, boot_cpu_has(C1E): 1
identify_cpu:  after ANDing, c1e_detected: 1, boot_cpu_has(C1E): 0
Switch to broadcast mode on CPU1
 #2
identify_cpu: before ANDing, c1e_detected: 1, boot_cpu_has(C1E): 0
identify_cpu:  after ANDing, c1e_detected: 1, boot_cpu_has(C1E): 0
Switch to broadcast mode on CPU2
 #3
identify_cpu: before ANDing, c1e_detected: 1, boot_cpu_has(C1E): 0
identify_cpu:  after ANDing, c1e_detected: 1, boot_cpu_has(C1E): 0
Brought up 4 CPUs
Total of 4 processors activated (20092.25 BogoMIPS).
Switch to broadcast mode on CPU3
NET: Registered protocol family 16
node 0 link 0: io port [c000, ffff]
TOM: 00000000d0000000 aka 3328M
Fam 10h mmconf [e0000000, e00fffff]
node 0 link 0: mmio [a0000, bffff]
node 0 link 0: mmio [d0000000, dfffffff]
node 0 link 0: mmio [f0000000, fe02ffff]
node 0 link 0: mmio [e0000000, e03fffff] ==> [e0100000, e03fffff]
TOM2: 0000000230000000 aka 8960M
bus: [00, 03] on node 0 link 0
bus: 00 index 0 [io  0x0000-0xffff]
bus: 00 index 1 [mem 0x000a0000-0x000bffff]
bus: 00 index 2 [mem 0xd0000000-0xdfffffff]
bus: 00 index 3 [mem 0xe0400000-0xffffffff]
bus: 00 index 4 [mem 0xe0100000-0xe03fffff]
bus: 00 index 5 [mem 0x230000000-0xfcffffffff]
ACPI: bus type pci registered
PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: No dock devices found.
PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7]
pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff]
pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
pci_root PNP0A03:00: host bridge window [mem 0x000c0000-0x000dffff]
pci_root PNP0A03:00: host bridge window [mem 0xcff00000-0xfebfffff]
pci 0000:00:00.0: reg 1c: [mem 0xe0000000-0xffffffff 64bit]
pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
pci 0000:00:02.0: PME# disabled
pci 0000:00:0a.0: PME# supported from D0 D3hot D3cold
pci 0000:00:0a.0: PME# disabled
pci 0000:00:11.0: reg 10: [io  0xff00-0xff07]
pci 0000:00:11.0: reg 14: [io  0xfe00-0xfe03]
pci 0000:00:11.0: reg 18: [io  0xfd00-0xfd07]
pci 0000:00:11.0: reg 1c: [io  0xfc00-0xfc03]
pci 0000:00:11.0: reg 20: [io  0xfb00-0xfb0f]
pci 0000:00:11.0: reg 24: [mem 0xfe02f000-0xfe02f3ff]
pci 0000:00:12.0: reg 10: [mem 0xfe02e000-0xfe02efff]
pci 0000:00:12.1: reg 10: [mem 0xfe02d000-0xfe02dfff]
pci 0000:00:12.2: reg 10: [mem 0xfe02c000-0xfe02c0ff]
pci 0000:00:12.2: supports D1 D2
pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
pci 0000:00:12.2: PME# disabled
pci 0000:00:13.0: reg 10: [mem 0xfe02b000-0xfe02bfff]
pci 0000:00:13.1: reg 10: [mem 0xfe02a000-0xfe02afff]
pci 0000:00:13.2: reg 10: [mem 0xfe029000-0xfe0290ff]
pci 0000:00:13.2: supports D1 D2
pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
pci 0000:00:13.2: PME# disabled
pci 0000:00:14.1: reg 10: [io  0x0000-0x0007]
pci 0000:00:14.1: reg 14: [io  0x0000-0x0003]
pci 0000:00:14.1: reg 18: [io  0x0000-0x0007]
pci 0000:00:14.1: reg 1c: [io  0x0000-0x0003]
pci 0000:00:14.1: reg 20: [io  0xfa00-0xfa0f]
pci 0000:00:14.2: reg 10: [mem 0xfe024000-0xfe027fff 64bit]
pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
pci 0000:00:14.2: PME# disabled
pci 0000:00:14.5: reg 10: [mem 0xfe028000-0xfe028fff]
pci 0000:01:00.0: reg 10: [mem 0xfa000000-0xfaffffff]
pci 0000:01:00.0: reg 14: [mem 0xd0000000-0xdfffffff 64bit pref]
pci 0000:01:00.0: reg 1c: [mem 0xfb000000-0xfbffffff 64bit]
pci 0000:01:00.0: reg 24: [io  0xef00-0xef7f]
pci 0000:01:00.0: reg 30: [mem 0x00000000-0x0001ffff pref]
pci 0000:00:02.0: PCI bridge to [bus 01-01]
pci 0000:00:02.0:   bridge window [io  0xe000-0xefff]
pci 0000:00:02.0:   bridge window [mem 0xfa000000-0xfcffffff]
pci 0000:00:02.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
pci 0000:02:00.0: reg 10: [io  0xde00-0xdeff]
pci 0000:02:00.0: reg 18: [mem 0xfdfff000-0xfdffffff 64bit pref]
pci 0000:02:00.0: reg 20: [mem 0xfdfe0000-0xfdfeffff 64bit pref]
pci 0000:02:00.0: reg 30: [mem 0x00000000-0x0000ffff pref]
pci 0000:02:00.0: supports D1 D2
pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:02:00.0: PME# disabled
pci 0000:00:0a.0: PCI bridge to [bus 02-02]
pci 0000:00:0a.0:   bridge window [io  0xd000-0xdfff]
pci 0000:00:0a.0:   bridge window [mem 0xfdc00000-0xfdcfffff]
pci 0000:00:0a.0:   bridge window [mem 0xfdf00000-0xfdffffff 64bit pref]
pci 0000:00:14.4: PCI bridge to [bus 03-03] (subtractive decode)
pci 0000:00:14.4:   bridge window [io  0xc000-0xcfff]
pci 0000:00:14.4:   bridge window [mem 0xfde00000-0xfdefffff]
pci 0000:00:14.4:   bridge window [mem 0xfdd00000-0xfddfffff pref]
pci 0000:00:14.4:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
pci 0000:00:14.4:   bridge window [io  0x0d00-0xffff] (subtractive decode)
pci 0000:00:14.4:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
pci 0000:00:14.4:   bridge window [mem 0x000c0000-0x000dffff] (subtractive decode)
pci 0000:00:14.4:   bridge window [mem 0xcff00000-0xfebfffff] (subtractive decode)
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P_._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCEA._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 6 7 10 11) *0, disabled.
vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
vgaarb: loaded
PCI: Using ACPI for IRQ routing
PCI: pci_cache_line_size set to 64 bytes
pci 0000:00:00.0: no compatible bridge window for [mem 0xe0000000-0xffffffff 64bit]
reserve RAM buffer: 0000000000098400 - 000000000009ffff 
reserve RAM buffer: 00000000cfd81000 - 00000000cfffffff 
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
hpet0: 4 comparators, 32-bit 14.318180 MHz counter
Switching to clocksource hpet
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp 00:02: disabling [mem 0x00000000-0x00000fff window] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
pnp 00:02: disabling [mem 0x00000000-0x00000fff window disabled] because it overlaps 0000:01:00.0 BAR 6 [mem 0x00000000-0x0001ffff pref]
pnp 00:02: disabling [mem 0x00000000-0x00000fff window disabled] because it overlaps 0000:02:00.0 BAR 6 [mem 0x00000000-0x0000ffff pref]
pnp 00:0c: disabling [mem 0x000d4400-0x000d7fff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
pnp 00:0c: disabling [mem 0x000f0000-0x000f7fff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
pnp 00:0c: disabling [mem 0x000f8000-0x000fbfff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
pnp 00:0c: disabling [mem 0x000fc000-0x000fffff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
pnp 00:0c: disabling [mem 0x00000000-0x0009ffff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
pnp 00:0c: disabling [mem 0x00100000-0xcfddffff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
pnp: PnP ACPI: found 13 devices
ACPI: ACPI bus type pnp unregistered
system 00:01: [io  0x04d0-0x04d1] has been reserved
system 00:01: [io  0x0220-0x0225] has been reserved
system 00:01: [io  0x0290-0x0294] has been reserved
system 00:02: [io  0x4100-0x411f] has been reserved
system 00:02: [io  0x0228-0x022f] has been reserved
system 00:02: [io  0x0238-0x023f] has been reserved
system 00:02: [io  0x040b] has been reserved
system 00:02: [io  0x04d6] has been reserved
system 00:02: [io  0x0c00-0x0c01] has been reserved
system 00:02: [io  0x0c14] has been reserved
system 00:02: [io  0x0c50-0x0c52] has been reserved
system 00:02: [io  0x0c6c-0x0c6d] has been reserved
system 00:02: [io  0x0c6f] has been reserved
system 00:02: [io  0x0cd0-0x0cd1] has been reserved
system 00:02: [io  0x0cd2-0x0cd3] has been reserved
system 00:02: [io  0x0cd4-0x0cdf] has been reserved
system 00:02: [io  0x4000-0x40fe] has been reserved
system 00:02: [io  0x4210-0x4217] has been reserved
system 00:02: [io  0x0b00-0x0b0f] has been reserved
system 00:02: [io  0x0b10-0x0b1f] has been reserved
system 00:02: [io  0x0b20-0x0b3f] has been reserved
system 00:02: [mem 0xfee00400-0xfee00fff window] has been reserved
system 00:0b: [mem 0xe0000000-0xefffffff] has been reserved
system 00:0c: [mem 0xcfde0000-0xcfdeffff] could not be reserved
system 00:0c: [mem 0xffff0000-0xffffffff] has been reserved
system 00:0c: [mem 0xcfdf0000-0xcfdfffff] has been reserved
system 00:0c: [mem 0xcfe00000-0xcfefffff] could not be reserved
system 00:0c: [mem 0xfec00000-0xfec00fff] could not be reserved
system 00:0c: [mem 0xfee00000-0xfee00fff] could not be reserved
system 00:0c: [mem 0xfff80000-0xfffeffff] has been reserved
pci 0000:01:00.0: BAR 6: assigned [mem 0xfc000000-0xfc01ffff pref]
pci 0000:00:02.0: PCI bridge to [bus 01-01]
pci 0000:00:02.0:   bridge window [io  0xe000-0xefff]
pci 0000:00:02.0:   bridge window [mem 0xfa000000-0xfcffffff]
pci 0000:00:02.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
pci 0000:02:00.0: BAR 6: assigned [mem 0xfdf00000-0xfdf0ffff pref]
pci 0000:00:0a.0: PCI bridge to [bus 02-02]
pci 0000:00:0a.0:   bridge window [io  0xd000-0xdfff]
pci 0000:00:0a.0:   bridge window [mem 0xfdc00000-0xfdcfffff]
pci 0000:00:0a.0:   bridge window [mem 0xfdf00000-0xfdffffff 64bit pref]
pci 0000:00:14.4: PCI bridge to [bus 03-03]
pci 0000:00:14.4:   bridge window [io  0xc000-0xcfff]
pci 0000:00:14.4:   bridge window [mem 0xfde00000-0xfdefffff]
pci 0000:00:14.4:   bridge window [mem 0xfdd00000-0xfddfffff pref]
pci 0000:00:02.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
pci 0000:00:02.0: setting latency timer to 64
pci 0000:00:0a.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
pci 0000:00:0a.0: setting latency timer to 64
pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
pci_bus 0000:00: resource 7 [mem 0x000c0000-0x000dffff]
pci_bus 0000:00: resource 8 [mem 0xcff00000-0xfebfffff]
pci_bus 0000:01: resource 0 [io  0xe000-0xefff]
pci_bus 0000:01: resource 1 [mem 0xfa000000-0xfcffffff]
pci_bus 0000:01: resource 2 [mem 0xd0000000-0xdfffffff 64bit pref]
pci_bus 0000:02: resource 0 [io  0xd000-0xdfff]
pci_bus 0000:02: resource 1 [mem 0xfdc00000-0xfdcfffff]
pci_bus 0000:02: resource 2 [mem 0xfdf00000-0xfdffffff 64bit pref]
pci_bus 0000:03: resource 0 [io  0xc000-0xcfff]
pci_bus 0000:03: resource 1 [mem 0xfde00000-0xfdefffff]
pci_bus 0000:03: resource 2 [mem 0xfdd00000-0xfddfffff pref]
pci_bus 0000:03: resource 4 [io  0x0000-0x0cf7]
pci_bus 0000:03: resource 5 [io  0x0d00-0xffff]
pci_bus 0000:03: resource 6 [mem 0x000a0000-0x000bffff]
pci_bus 0000:03: resource 7 [mem 0x000c0000-0x000dffff]
pci_bus 0000:03: resource 8 [mem 0xcff00000-0xfebfffff]
NET: Registered protocol family 2
IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 524288 bind 65536)
TCP reno registered
UDP hash table entries: 4096 (order: 5, 131072 bytes)
UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
NET: Registered protocol family 1
pci 0000:01:00.0: Boot video device
PCI: CLS 64 bytes, default 64
Trying to unpack rootfs image as initramfs...
Freeing initrd memory: 6032k freed
PCI-DMA: Disabling AGP.
PCI-DMA: aperture base @ 20000000 size 65536 KB
PCI-DMA: using GART IOMMU.
PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
audit: initializing netlink socket (disabled)
type=2000 audit(1279476208.487:1): initialized
HugeTLB registered 2 MB page size, pre-allocated 0 pages
SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, no debug enabled
Btrfs loaded
msgmni has been set to 15863
alg: No test for stdrng (krng)
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
pcieport 0000:00:02.0: setting latency timer to 64
pcieport 0000:00:02.0: irq 40 for MSI/MSI-X
pcieport 0000:00:0a.0: setting latency timer to 64
pcieport 0000:00:0a.0: irq 41 for MSI/MSI-X
vesafb: framebuffer at 0xd0000000, mapped to 0xffffc90011800000, using 5120k, total 262144k
vesafb: mode is 1280x1024x16, linelength=2560, pages=1
vesafb: scrolling: redraw
vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
Console: switching to colour frame buffer device 160x64
fb0: VESA VGA frame buffer device
Non-volatile memory driver v1.3
Linux agpgart interface v0.103
Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
brd: module loaded
Compaq SMART2 Driver (v 2.6.0)
HP CISS Driver (v 3.6.20)
MM: desc_per_page = 128
PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
serio: i8042 KBD port at 0x60,0x64 irq 1
mice: PS/2 mouse device common for all mice
cpuidle: using governor ladder
cpuidle: using governor menu
Netfilter messages via NETLINK v0.30.
CCID: Activated CCID 2 (TCP-like)
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
registered taskstats version 1
Freeing unused kernel memory: 1816k freed
ACPI: acpi_idle registered with cpuidle
acpi_processor_cstate_check: enter
acpi_processor_cstate_check: max_cstate: 8
SCSI subsystem initialized
libata version 3.00 loaded.
Uniform Multi-Platform E-IDE driver
BIOS EDD facility v0.16 2004-Jun-25, 3 devices found
fuse init (API version 7.14)
loop: module loaded
device-mapper: ioctl: 4.17.0-ioctl (2010-03-05) initialised: dm-devel@redhat.com
udevd version 128 started
pata_atiixp 0000:00:14.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
scsi0 : pata_atiixp
scsi1 : pata_atiixp
ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xfa00 irq 14
ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xfa08 irq 15
rtc_cmos 00:05: RTC can wake from S4
rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month, 242 bytes nvram, hpet irqs
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ahci 0000:00:11.0: version 3.0
ahci 0000:00:11.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
ahci 0000:00:11.0: AHCI 0001.0100 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part ccc 
scsi2 : ahci
scsi3 : ahci
scsi4 : ahci
scsi5 : ahci
CE: hpet increased min_delta_ns to 7500 nsec
scsi6 : ahci
scsi7 : ahci
ata3: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f100 irq 22
ata4: SATA max UDMA/133 irq_stat 0x00400040, connection status changed irq 22
ata5: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f200 irq 22
ata6: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f280 irq 22
ata7: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f300 irq 22
ata8: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f380 irq 22
ehci_hcd 0000:00:12.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
ehci_hcd 0000:00:12.2: EHCI Host Controller
ehci_hcd 0000:00:12.2: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:12.2: applying AMD SB600/SB700 USB freeze workaround
ehci_hcd 0000:00:12.2: debug port 1
ehci_hcd 0000:00:12.2: irq 17, io mem 0xfe02c000
ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.35-rc5-c1e_debug ehci_hcd
usb usb1: SerialNumber: 0000:00:12.2
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 6 ports detected
ehci_hcd 0000:00:13.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
ehci_hcd 0000:00:13.2: EHCI Host Controller
ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:13.2: applying AMD SB600/SB700 USB freeze workaround
ehci_hcd 0000:00:13.2: debug port 1
ehci_hcd 0000:00:13.2: irq 19, io mem 0xfe029000
ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00
usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: EHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.35-rc5-c1e_debug ehci_hcd
usb usb2: SerialNumber: 0000:00:13.2
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 6 ports detected
ata6: SATA link down (SStatus 0 SControl 300)
ata7: SATA link down (SStatus 0 SControl 300)
usb 1-1: new high speed USB device using ehci_hcd and address 2
ata5: softreset failed (device not ready)
ata3: softreset failed (device not ready)
ata8: softreset failed (device not ready)
ata3: applying SB600 PMP SRST workaround and retrying
ata8: applying SB600 PMP SRST workaround and retrying
ata5: applying SB600 PMP SRST workaround and retrying
ata8: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata8.00: HPA detected: current 976771055, native 976773168
usb 1-1: New USB device found, idVendor=07d1, idProduct=3c03
usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 1-1: Product: 802.11 bg WLAN
usb 1-1: Manufacturer: Ralink
ata3.00: HPA detected: current 976771055, native 976773168
ata3.00: ATA-8: WDC WD5000AAKS-00YGA0, 12.01C02, max UDMA/133
ata3.00: 976771055 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
ata3.00: configured for UDMA/133
scsi 2:0:0:0: Direct-Access     ATA      WDC WD5000AAKS-0 12.0 PQ: 0 ANSI: 5
ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata8.00: ATA-8: WDC WD5000AAKS-00YGA0, 12.01C02, max UDMA/133
ata8.00: 976771055 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
ata8.00: configured for UDMA/133
ata5.00: ATA-8: OCZ SOLID_SSD, 02.10104, max UDMA/100
ata5.00: 62586880 sectors, multi 0: LBA 
ata5.00: configured for UDMA/100
ata4: softreset failed (device not ready)
ata4: applying SB600 PMP SRST workaround and retrying
ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata4.00: ATAPI: TSSTcorp CDDVDW SH-S223F, SB00, max UDMA/100
ata4.00: configured for UDMA/100
scsi 3:0:0:0: CD-ROM            TSSTcorp CDDVDW SH-S223F  SB00 PQ: 0 ANSI: 5
scsi 4:0:0:0: Direct-Access     ATA      OCZ SOLID_SSD    02.1 PQ: 0 ANSI: 5
scsi 7:0:0:0: Direct-Access     ATA      WDC WD5000AAKS-0 12.0 PQ: 0 ANSI: 5
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
ohci_hcd 0000:00:12.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
sd 2:0:0:0: [sda] 976771055 512-byte logical blocks: (500 GB/465 GiB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 4:0:0:0: [sdb] 62586880 512-byte logical blocks: (32.0 GB/29.8 GiB)
sd 4:0:0:0: [sdb] Write Protect is off
sd 4:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 4:0:0:0: [sdb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 7:0:0:0: [sdc] 976771055 512-byte logical blocks: (500 GB/465 GiB)
sd 7:0:0:0: [sdc] Write Protect is off
sd 7:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 7:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdb:
 sdc:
 sda: sdb1
 sda1 sda2 sda3 sda4
ohci_hcd 0000:00:12.0: OHCI Host Controller
 sdc1
sd 4:0:0:0: [sdb] Attached SCSI disk
ohci_hcd 0000:00:12.0: new USB bus registered, assigned bus number 3
ohci_hcd 0000:00:12.0: irq 16, io mem 0xfe02e000
sd 7:0:0:0: [sdc] Attached SCSI disk
sd 2:0:0:0: [sda] Attached SCSI disk
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: OHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.35-rc5-c1e_debug ohci_hcd
usb usb3: SerialNumber: 0000:00:12.0
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 3 ports detected
ohci_hcd 0000:00:12.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
ohci_hcd 0000:00:12.1: OHCI Host Controller
ohci_hcd 0000:00:12.1: new USB bus registered, assigned bus number 4
ohci_hcd 0000:00:12.1: irq 16, io mem 0xfe02d000
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: OHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.35-rc5-c1e_debug ohci_hcd
usb usb4: SerialNumber: 0000:00:12.1
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 3 ports detected
ohci_hcd 0000:00:13.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
ohci_hcd 0000:00:13.0: OHCI Host Controller
ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 5
ohci_hcd 0000:00:13.0: irq 18, io mem 0xfe02b000
usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb5: Product: OHCI Host Controller
usb usb5: Manufacturer: Linux 2.6.35-rc5-c1e_debug ohci_hcd
usb usb5: SerialNumber: 0000:00:13.0
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 3 ports detected
ohci_hcd 0000:00:13.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
ohci_hcd 0000:00:13.1: OHCI Host Controller
ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 6
ohci_hcd 0000:00:13.1: irq 18, io mem 0xfe02a000
usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb6: Product: OHCI Host Controller
usb usb6: Manufacturer: Linux 2.6.35-rc5-c1e_debug ohci_hcd
usb usb6: SerialNumber: 0000:00:13.1
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 3 ports detected
ohci_hcd 0000:00:14.5: PCI INT C -> GSI 18 (level, low) -> IRQ 18
ohci_hcd 0000:00:14.5: OHCI Host Controller
ohci_hcd 0000:00:14.5: new USB bus registered, assigned bus number 7
ohci_hcd 0000:00:14.5: irq 18, io mem 0xfe028000
usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb7: Product: OHCI Host Controller
usb usb7: Manufacturer: Linux 2.6.35-rc5-c1e_debug ohci_hcd
usb usb7: SerialNumber: 0000:00:14.5
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 2 ports detected
usb 3-2: new full speed USB device using ohci_hcd and address 2
usb 3-2: New USB device found, idVendor=04a9, idProduct=220d
usb 3-2: New USB device strings: Mfr=64, Product=77, SerialNumber=0
usb 3-2: Product: CanoScan
usb 3-2: Manufacturer: Canon
usb 4-2: new low speed USB device using ohci_hcd and address 2
usb 4-2: New USB device found, idVendor=051d, idProduct=0002
usb 4-2: New USB device strings: Mfr=3, Product=1, SerialNumber=2
usb 4-2: Product: Back-UPS ES 700 FW:829.D2 .I USB FW:D2 
usb 4-2: Manufacturer: APC
usb 4-2: SerialNumber: 5B0825T20337  
usbcore: registered new interface driver hiddev
usb 4-3: new full speed USB device using ohci_hcd and address 3
generic-usb 0003:051D:0002.0001: hiddev96,hidraw0: USB HID v1.10 Device [APC Back-UPS ES 700 FW:829.D2 .I USB FW:D2 ] on usb-0000:00:12.1-2/input0
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
usb 4-3: New USB device found, idVendor=046d, idProduct=c52b
usb 4-3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 4-3: Product: USB Receiver
usb 4-3: Manufacturer: Logitech
input: Logitech USB Receiver as /devices/pci0000:00/0000:00:12.1/usb4/4-3/4-3:1.0/input/input1
generic-usb 0003:046D:C52B.0002: input,hidraw1: USB HID v1.11 Keyboard [Logitech USB Receiver] on usb-0000:00:12.1-3/input0
input: Logitech USB Receiver as /devices/pci0000:00/0000:00:12.1/usb4/4-3/4-3:1.1/input/input2
generic-usb 0003:046D:C52B.0003: input,hiddev97,hidraw2: USB HID v1.11 Mouse [Logitech USB Receiver] on usb-0000:00:12.1-3/input1
generic-usb 0003:046D:C52B.0004: hiddev98,hidraw3: USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:12.1-3/input2
alg: No test for xts(twofish) (xts(twofish-asm))
XFS mounting filesystem dm-0
Ending clean XFS mount for filesystem: dm-0
udevd version 128 started
k10temp 0000:00:18.3: unreliable CPU thermal sensor; monitoring disabled
sd 2:0:0:0: Attached scsi generic sg0 type 0
scsi 3:0:0:0: Attached scsi generic sg1 type 5
sd 4:0:0:0: Attached scsi generic sg2 type 0
sd 7:0:0:0: Attached scsi generic sg3 type 0
input: PC Speaker as /devices/platform/pcspkr/input/input3
input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input4
ACPI: Power Button [PWRB]
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input5
ACPI: Power Button [PWRF]
ACPI: resource piix4_smbus [io  0x0b00-0x0b07] conflicts with ACPI region SOR1 [mem 0x00000b00-0x00000b0f 64bit pref window]
parport_pc 00:09: reported by Plug and Play ACPI
parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
cfg80211: Calling CRDA to update world regulatory domain
cfg80211: Calling CRDA for country: EU
ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
ppdev: user-space parallel port driver
r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
r8169 0000:02:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
r8169 0000:02:00.0: setting latency timer to 64
r8169 0000:02:00.0: irq 42 for MSI/MSI-X
r8169 0000:02:00.0: eth0: RTL8168c/8111c at 0xffffc90011ede000, 00:1f:d0:be:4c:a5, XID 1c4000c0 IRQ 42
Error: Driver 'pcspkr' is already registered, aborting...
udev: renamed network interface eth0 to eth1
sr0: scsi3-mmc drive: 16x/16x writer dvd-ram cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 3:0:0:0: Attached scsi CD-ROM sr0
HDA Intel 0000:00:14.2: PCI INT A -> GSI 16 (level, low) -> IRQ 16
phy0 -> rt73usb_validate_eeprom: EEPROM recovery - NIC: 0xffef
phy0 -> rt73usb_validate_eeprom: EEPROM recovery - Led: 0xe000
phy0 -> rt73usb_validate_eeprom: EEPROM recovery - RSSI OFFSET A: 0x0000
phy0 -> rt2x00_set_chip: Info - Chipset detected - rt: 2573, rf: 0002, rev: 000a.
phy0: Selected rate control algorithm 'minstrel'
Registered led device: rt73usb-phy0::radio
Registered led device: rt73usb-phy0::assoc
Registered led device: rt73usb-phy0::quality
usbcore: registered new interface driver rt73usb
ALSA sound/pci/hda/patch_realtek.c:1308: SKU: Nid=0x0 sku_cfg=0x0000e601
ALSA sound/pci/hda/patch_realtek.c:1310: SKU: port_connectivity=0x0
ALSA sound/pci/hda/patch_realtek.c:1311: SKU: enable_pcbeep=0x1
ALSA sound/pci/hda/patch_realtek.c:1312: SKU: check_sum=0x00000000
ALSA sound/pci/hda/patch_realtek.c:1313: SKU: customization=0x00000000
ALSA sound/pci/hda/patch_realtek.c:1314: SKU: external_amp=0x0
ALSA sound/pci/hda/patch_realtek.c:1315: SKU: platform_type=0x0
ALSA sound/pci/hda/patch_realtek.c:1316: SKU: swap=0x0
ALSA sound/pci/hda/patch_realtek.c:1317: SKU: override=0x1
hda_codec: ALC888: BIOS auto-probing.
ALSA sound/pci/hda/hda_codec.c:4435: autoconfig: line_outs=4 (0x14/0x15/0x16/0x17/0x0)
ALSA sound/pci/hda/hda_codec.c:4439:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
ALSA sound/pci/hda/hda_codec.c:4443:    hp_outs=1 (0x1b/0x0/0x0/0x0/0x0)
ALSA sound/pci/hda/hda_codec.c:4444:    mono: mono_out=0x0
ALSA sound/pci/hda/hda_codec.c:4447:    dig-out=0x1e/0x0
ALSA sound/pci/hda/hda_codec.c:4455:    inputs: mic=0x18, fmic=0x19, line=0x1a, fline=0x0, cd=0x1c, aux=0x0
ALSA sound/pci/hda/hda_codec.c:4457:    dig-in=0x1f
ALSA sound/pci/hda/patch_realtek.c:1374: realtek: Enabling init ASM_ID=0xe601 CODEC_ID=10ec0888
uhci_hcd: USB Universal Host Controller Interface driver
device-mapper: ioctl: unable to remove open device temporary-cryptsetup-3233
XFS mounting filesystem dm-2
Ending clean XFS mount for filesystem: dm-2
XFS mounting filesystem dm-3
Ending clean XFS mount for filesystem: dm-3
XFS mounting filesystem dm-4
Ending clean XFS mount for filesystem: dm-4
Adding 8383904k swap on /dev/mapper/swap.  Priority:-1 extents:1 across:8383904k 
TCP vegas registered
ip_tables: (C) 2000-2006 Netfilter Core Team
ata5.00: configured for UDMA/100
ata5: EH complete
sd 4:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
ip6_tables: (C) 2000-2006 Netfilter Core Team
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
nf_conntrack.acct=1 kernel parameter, acct=1 nf_conntrack module option or
sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
powernow-k8: Found 1 AMD Phenom(tm) II X4 905e Processor (4 cpu cores) (version 2.20.00)
powernow-k8:    0 : pstate 0 (2500 MHz)
powernow-k8:    1 : pstate 1 (1900 MHz)
powernow-k8:    2 : pstate 2 (1400 MHz)
powernow-k8:    3 : pstate 3 (800 MHz)
it87: Found IT8720F chip at 0x228, revision 5
it87: Routing internal VCCH to in7
it87: in3 is VCC (+5V)
it87: in7 is VCCH (+5V Stand-By)
it87: Beeping is supported
phy0 -> rt2x00lib_request_firmware: Info - Loading firmware file 'rt73.bin'.
phy0 -> rt2x00lib_request_firmware: Info - Firmware detected - version: 1.7.
phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 0 - CWmin: 3, CWmax: 4, Aifs: 2, TXop: 102.
phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 1 - CWmin: 4, CWmax: 5, Aifs: 2, TXop: 188.
phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 2 - CWmin: 5, CWmax: 10, Aifs: 3, TXop: 0.
phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 3 - CWmin: 5, CWmax: 10, Aifs: 7, TXop: 0.
NET: Registered protocol family 17
wlan0: deauthenticating from 00:1d:7e:c6:f3:21 by local choice (reason=3)
wlan0: authenticate with 00:1d:7e:c6:f3:21 (try 1)
wlan0: authenticated
wlan0: associate with 00:1d:7e:c6:f3:21 (try 1)
wlan0: RX AssocResp from 00:1d:7e:c6:f3:21 (capab=0x411 status=0 aid=1)
wlan0: associated
phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 0 - CWmin: 2, CWmax: 3, Aifs: 2, TXop: 47.
phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 1 - CWmin: 3, CWmax: 4, Aifs: 2, TXop: 94.
phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 2 - CWmin: 4, CWmax: 10, Aifs: 3, TXop: 0.
phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 3 - CWmin: 4, CWmax: 10, Aifs: 7, TXop: 0.
CPUFREQ: Per core ondemand sysfs interface is deprecated - up_threshold

--ReaqsoxgOBHFXBhH--
