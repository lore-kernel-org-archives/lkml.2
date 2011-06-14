Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508Ab1FNALB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 20:11:01 -0400
Received: from yumi.tdiedrich.de ([85.10.210.183]:54268 "EHLO mx.tdiedrich.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755122Ab1FNAK6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 20:10:58 -0400
Date: Tue, 14 Jun 2011 02:10:55 +0200
From: Tobias Diedrich <ranma+xen@tdiedrich.de>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: xen-users@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: Re: 3.0.0-rc2: Xen: High amount of kernel "reserved" memory, about
 33% in 256MB DOMU
Message-ID: <20110614001055.GB7417@yumi.tdiedrich.de>
Mail-Followup-To: Tobias Diedrich <ranma+xen@tdiedrich.de>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	xen-users@lists.xensource.com, linux-kernel@vger.kernel.org
References: <20110613205003.GD20616@yumi.tdiedrich.de>
 <20110613215900.GB19117@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110613215900.GB19117@dumpdata.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Konrad Rzeszutek Wilk wrote:
> On Mon, Jun 13, 2011 at 10:50:03PM +0200, Tobias Diedrich wrote:
> > Hi,
> > 
> > another issue I'm seeing with 3.0-rc2 and Xen is that there is an
> > unexpectedly high amount of kernel reserved memory.
> 
> > 
> > I suspect that Linux allocates page table entries and corresponding
> > data structures for the whole 6GB areas of the provided 'physical
> > RAM map' even though it has rather big unusable holes in it.
> 
> Can you run it with 'memblock=debug debug loglevel=8 initcall_debug'?
> It should tell you where it tries (and for much space) the pagetables.

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.0.0-rc2 (ranma@nukunuku) (gcc version 4.5.2 (Debian 4.5.2-11) ) #50 SMP Tue Jun 14 01:59:04 CEST 2011
[    0.000000] Command line: root=/dev/md2 vga=ext netconsole=25360@85.10.200.103/eth0,514@217.160.215.119/00:26:88:75:cf:27 memblock=debug debug loglevel=8 initcall_debug ro
[    0.000000] released 0 pages of unused memory
[    0.000000] 1-1 mapping on 9f->100
[    0.000000] 1-1 mapping on 7fef0->100000
[    0.000000] Set 524657 page(s) to 1-1 mapping.
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  Xen: 0000000000000000 - 000000000009f000 (usable)
[    0.000000]  Xen: 000000000009f000 - 0000000000100000 (reserved)
[    0.000000]  Xen: 0000000000100000 - 0000000010000000 (usable)
[    0.000000]  Xen: 0000000010000000 - 000000007fef0000 (unusable)
[    0.000000]  Xen: 000000007fef0000 - 000000007fef3000 (ACPI NVS)
[    0.000000]  Xen: 000000007fef3000 - 000000007ff00000 (ACPI data)
[    0.000000]  Xen: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000]  Xen: 0000000100000000 - 000000016fef0000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.3 present.
[    0.000000] DMI: MICRO-STAR INTERNATIONAL CO., LTD MS-7094/MS-7094, BIOS V3.6 10/12/2006
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] AGP bridge at 00:00:00
[    0.000000] Aperture from AGP @ f0000000 old size 32 MB
[    0.000000] Aperture from AGP @ f0000000 size 128 MB (APSIZE f20)
[    0.000000] last_pfn = 0x16fef0 max_arch_pfn = 0x400000000
[    0.000000] last_pfn = 0x10000 max_arch_pfn = 0x400000000
[    0.000000]     memblock_x86_reserve_range: [0x01ce8000-0x01d000b5]              BRK
[    0.000000] MEMBLOCK configuration:
[    0.000000]  memory size = 0x7fe7f000
[    0.000000]  memory.cnt  = 0x3
[    0.000000]  memory[0x0]	[0x00000000010000-0x0000000009efff], 0x8f000 bytes
[    0.000000]  memory[0x1]	[0x00000000100000-0x0000000fffffff], 0xff00000 bytes
[    0.000000]  memory[0x2]	[0x00000100000000-0x0000016feeffff], 0x6fef0000 bytes
[    0.000000]  reserved.cnt  = 0x3
[    0.000000]  reserved[0x0]	[0x00000001000000-0x00000001d000b5], 0xd000b6 bytes
[    0.000000]  reserved[0x1]	[0x00000001e1e000-0x00000001eb1fff], 0x94000 bytes
[    0.000000]  reserved[0x2]	[0x00000100000000-0x0000016feeffff], 0x6fef0000 bytes
[    0.000000] initial memory mapped : 0 - 01e1e000
[    0.000000]     memblock_x86_reserve_range: [0x0009d000-0x0009efff]       TRAMPOLINE
[    0.000000] Base memory trampoline at [ffff88000009d000] 9d000 size 8192
[    0.000000] init_memory_mapping: 0000000000000000-0000000010000000
[    0.000000]  0000000000 - 0010000000 page 4k
[    0.000000] kernel direct mapping tables up to 10000000 @ ff7e000-10000000
[    0.000000]     memblock_x86_reserve_range: [0x0ff7e000-0x0ffe9fff]          PGTABLE
[    0.000000] xen: setting RW the range ffea000 - 10000000
[    0.000000] init_memory_mapping: 0000000100000000-000000016fef0000
[    0.000000]  0100000000 - 016fef0000 page 4k
[    0.000000] kernel direct mapping tables up to 16fef0000 @ f3f7000-ff7e000
[    0.000000]     memblock_x86_reserve_range: [0x0f3f7000-0x0f778fff]          PGTABLE
[    0.000000] xen: setting RW the range f779000 - ff7e000
[    0.000000] ACPI: RSDP 00000000000f8dc0 00014 (v00 VIAK8T)
[    0.000000] ACPI: RSDT 000000007fef3040 00030 (v01 VIAK8T AWRDACPI 42302E31 AWRD 00000000)
[    0.000000] ACPI: FACP 000000007fef30c0 00074 (v01 VIAK8T AWRDACPI 42302E31 AWRD 00000000)
[    0.000000] ACPI: DSDT 000000007fef3180 04F07 (v01 VIAK8T AWRDACPI 00001000 MSFT 0100000E)
[    0.000000] ACPI: FACS 000000007fef0000 00040
[    0.000000] ACPI: SRAT 000000007fef8300 00090 (v01 AMD    HAMMER   00000001 AMD  00000001)
[    0.000000] ACPI: APIC 000000007fef8100 00068 (v01 VIAK8T AWRDACPI 42302E31 AWRD 00000000)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000]     memblock_x86_reserve_range: [0x0ffff000-0x0fffffff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x0fb7e000-0x0ff7dfff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x0fffee80-0x0fffefff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x0f77e000-0x0fb7dfff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x0d200000-0x0f1fffff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x0fffd000-0x0fffdfff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x0fffc000-0x0fffcfff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x0fffb000-0x0fffbfff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x0fffa000-0x0fffafff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x0fff9000-0x0fff9fff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x0fff8000-0x0fff8fff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x0fff7000-0x0fff7fff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x0fff6000-0x0fff6fff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x0fff5000-0x0fff5fff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x0fff4000-0x0fff4fff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x0fff3000-0x0fff3fff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x0fff2000-0x0fff2fff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x0fff1000-0x0fff1fff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x0fff0000-0x0fff0fff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x0ffef000-0x0ffeffff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x0ffee000-0x0ffeefff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x0ffed000-0x0ffedfff]          BOOTMEM
[    0.000000]        memblock_x86_free_range: [0x0ee00000-0x0f1fffff]
[    0.000000]        memblock_x86_free_range: [0x0f77e000-0x0fb7dfff]
[    0.000000]        memblock_x86_free_range: [0x0fb7e000-0x0ff7dfff]
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x0016fef0
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x00010000
[    0.000000]     0: 0x00100000 -> 0x0016fef0
[    0.000000] On node 0 totalpages: 523903
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 2 pages reserved
[    0.000000]   DMA zone: 3925 pages, LIFO batch:0
[    0.000000]     memblock_x86_reserve_range: [0x0fffed00-0x0fffee7f]          BOOTMEM
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 47160 pages, LIFO batch:15
[    0.000000]     memblock_x86_reserve_range: [0x0ff66000-0x0ff7dfff]          BOOTMEM
[    0.000000]   Normal zone: 6269 pages used for memmap
[    0.000000]   Normal zone: 452211 pages, LIFO batch:31
[    0.000000]     memblock_x86_reserve_range: [0x0ff5a000-0x0ff65fff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x0ffec000-0x0ffecfff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x0ffeb000-0x0ffebfff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x0ffea000-0x0ffeafff]          BOOTMEM
[    0.000000] Looks like a VIA chipset. Disabling IOMMU. Override with iommu=allowed
[    0.000000] ACPI: PM-Timer IO Port: 0x4008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] BIOS bug: APIC version is 0 for CPU 0/0x0, fixing up to 0x10
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 255, address 0xfec00000, GSI 0-255
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] SMP: Allowing 2 CPUs, 1 hotplug CPUs
[    0.000000]     memblock_x86_reserve_range: [0x0fffec80-0x0fffecc2]          BOOTMEM
[    0.000000] nr_irqs_gsi: 272
[    0.000000]     memblock_x86_reserve_range: [0x0fffea80-0x0fffec77]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x0fffea00-0x0fffea67]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x0fffe980-0x0fffe9e7]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x0fffe900-0x0fffe967]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x0fffe880-0x0fffe8e7]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x0fffe800-0x0fffe867]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x0fffe780-0x0fffe7e7]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x0fffe700-0x0fffe767]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x0fffe680-0x0fffe6e7]          BOOTMEM
[    0.000000] Allocating PCI resources starting at 7ff00000 (gap: 7ff00000:7ed00000)
[    0.000000] Booting paravirtualized kernel on Xen
[    0.000000] Xen version: 4.1.0 (preserve-AD)
[    0.000000]     memblock_x86_reserve_range: [0x0fffe5c0-0x0fffe651]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x0fffe500-0x0fffe591]          BOOTMEM
[    0.000000] setup_percpu: NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
[    0.000000]     memblock_x86_reserve_range: [0x0ff59000-0x0ff59fff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x0ff58000-0x0ff58fff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x0ff22000-0x0ff57fff]          BOOTMEM
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff88000ff22000 s79488 r8192 d22912 u110592
[    0.000000]     memblock_x86_reserve_range: [0x0fffe4c0-0x0fffe4c7]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x0fffe480-0x0fffe487]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x0fffe440-0x0fffe447]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x0fffe400-0x0fffe40f]          BOOTMEM
[    0.000000] pcpu-alloc: s79488 r8192 d22912 u110592 alloc=27*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1 
[    0.000000]     memblock_x86_reserve_range: [0x0fffe300-0x0fffe3ff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x0fffe280-0x0fffe2c7]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x0fffe200-0x0fffe247]          BOOTMEM
[    0.000000]        memblock_x86_free_range: [0x0ff59000-0x0ff59fff]
[    0.000000]        memblock_x86_free_range: [0x0ff58000-0x0ff58fff]
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 503296
[    0.000000] Kernel command line: root=/dev/md2 vga=ext netconsole=25360@85.10.200.103/eth0,514@217.160.215.119/00:26:88:75:cf:27 memblock=debug debug loglevel=8 initcall_debug ro
[    0.000000]     memblock_x86_reserve_range: [0x0ff1a000-0x0ff21fff]          BOOTMEM
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000]     memblock_x86_reserve_range: [0x0fd1a000-0x0ff19fff]          BOOTMEM
[    0.000000] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.000000]     memblock_x86_reserve_range: [0x0fc1a000-0x0fd19fff]          BOOTMEM
[    0.000000] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.000000]     memblock_x86_reserve_range: [0x09200000-0x0d1fffff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x0fbfa000-0x0fc19fff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x0fbba000-0x0fbf9fff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x0fbb2000-0x0fbb9fff]          BOOTMEM
[    0.000000] Placing 64MB software IO TLB between ffff880009200000 - ffff88000d200000
[    0.000000] software IO TLB at phys 0x9200000 - 0xd200000
[    0.000000] Subtract (27 early reservations)
[    0.000000]   [000009d000-000009efff]
[    0.000000]   [0001000000-0001d000b5]
[    0.000000]   [0001e1e000-0001eb1fff]
[    0.000000]   [0009200000-000edfffff]
[    0.000000]   [000f3f7000-000f778fff]
[    0.000000]   [000fbb2000-000ff57fff]
[    0.000000]   [000ff5a000-000fffdfff]
[    0.000000]   [000fffe200-000fffe247]
[    0.000000]   [000fffe280-000fffe2c7]
[    0.000000]   [000fffe300-000fffe40f]
[    0.000000]   [000fffe440-000fffe447]
[    0.000000]   [000fffe480-000fffe487]
[    0.000000]   [000fffe4c0-000fffe4c7]
[    0.000000]   [000fffe500-000fffe591]
[    0.000000]   [000fffe5c0-000fffe651]
[    0.000000]   [000fffe680-000fffe6e7]
[    0.000000]   [000fffe700-000fffe767]
[    0.000000]   [000fffe780-000fffe7e7]
[    0.000000]   [000fffe800-000fffe867]
[    0.000000]   [000fffe880-000fffe8e7]
[    0.000000]   [000fffe900-000fffe967]
[    0.000000]   [000fffe980-000fffe9e7]
[    0.000000]   [000fffea00-000fffea67]
[    0.000000]   [000fffea80-000fffec77]
[    0.000000]   [000fffec80-000fffecc2]
[    0.000000]   [000fffed00-000fffffff]
[    0.000000]   [0100000000-016feeffff]
[    0.000000] Memory: 145576k/6028224k available (6122k kernel code, 3932612k absent, 1950036k reserved, 4761k data, 576k init)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:320
[    0.000000] xen: sci override: global_irq=9 trigger=0 polarity=1
[    0.000000] xen: registering gsi 9 triggering 0 polarity 1
[    0.000000] xen: --> pirq=9 -> irq=9
[    0.000000] xen: acpi sci 9
[    0.000000] xen: --> pirq=1 -> irq=1
[    0.000000] xen: --> pirq=2 -> irq=2
[    0.000000] xen: --> pirq=3 -> irq=3
[    0.000000] xen: --> pirq=4 -> irq=4
[    0.000000] xen: --> pirq=5 -> irq=5
[    0.000000] xen: --> pirq=6 -> irq=6
[    0.000000] xen: --> pirq=7 -> irq=7
[    0.000000] xen: --> pirq=8 -> irq=8
[    0.000000] xen_map_pirq_gsi: returning irq 9 for gsi 9
[    0.000000] xen: --> pirq=9 -> irq=9
[    0.000000] xen: --> pirq=10 -> irq=10
[    0.000000] xen: --> pirq=11 -> irq=11
[    0.000000] xen: --> pirq=12 -> irq=12
[    0.000000] xen: --> pirq=13 -> irq=13
[    0.000000] xen: --> pirq=14 -> irq=14
[    0.000000] xen: --> pirq=15 -> irq=15
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 16777216 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] Xen: using vcpuop timer interface
[    0.000000] installing Xen timer for CPU 0
[    0.000000] Detected 2199.838 MHz processor.
[    0.010000] Calibrating delay loop (skipped), value calculated using timer frequency.. 4399.67 BogoMIPS (lpj=21998380)
[    0.010000] pid_max: default: 32768 minimum: 301
[    0.010000] Mount-cache hash table entries: 256
[    0.010000] Initializing cgroup subsys cpuacct
[    0.010000] Initializing cgroup subsys memory
[    0.010000] Initializing cgroup subsys net_cls
[    0.010000] Initializing cgroup subsys blkio
[    0.010000] tseg: 007ff00000
[    0.010000] SMP alternatives: switching to UP code
[    0.010508] Freeing SMP alternatives: 28k freed
[    0.010640] ACPI: Core revision 20110413
[    0.019291] calling  trace_init_flags_sys_exit+0x0/0x12 @ 1
[    0.019414] initcall trace_init_flags_sys_exit+0x0/0x12 returned 0 after 0 usecs
[    0.019611] calling  trace_init_flags_sys_enter+0x0/0x12 @ 1
[    0.019728] initcall trace_init_flags_sys_enter+0x0/0x12 returned 0 after 0 usecs
[    0.019923] calling  init_hw_perf_events+0x0/0xf1a @ 1
[    0.020000] Performance Events: Broken PMU hardware detected, using software events only.
[    0.020222] initcall init_hw_perf_events+0x0/0xf1a returned 0 after 9765 usecs
[    0.020420] calling  register_trigger_all_cpu_backtrace+0x0/0x14 @ 1
[    0.020538] initcall register_trigger_all_cpu_backtrace+0x0/0x14 returned 0 after 0 usecs
[    0.020737] calling  migration_init+0x0/0x70 @ 1
[    0.020854] initcall migration_init+0x0/0x70 returned 0 after 0 usecs
[    0.020973] calling  spawn_ksoftirqd+0x0/0x55 @ 1
[    0.021117] initcall spawn_ksoftirqd+0x0/0x55 returned 0 after 0 usecs
[    0.021235] calling  init_workqueues+0x0/0x2ff @ 1
[    0.021446] initcall init_workqueues+0x0/0x2ff returned 0 after 0 usecs
[    0.021567] calling  init_call_single_data+0x0/0x8c @ 1
[    0.021682] initcall init_call_single_data+0x0/0x8c returned 0 after 0 usecs
[    0.021800] calling  cpu_stop_init+0x0/0xaa @ 1
[    0.021939] initcall cpu_stop_init+0x0/0xaa returned 0 after 0 usecs
[    0.022055] calling  rcu_spawn_kthreads+0x0/0xc9 @ 1
[    0.022220] initcall rcu_spawn_kthreads+0x0/0xc9 returned 0 after 0 usecs
[    0.022337] calling  relay_init+0x0/0x14 @ 1
[    0.022450] initcall relay_init+0x0/0x14 returned 0 after 0 usecs
[    0.022566] calling  tracer_alloc_buffers+0x0/0x168 @ 1
[    0.022732] initcall tracer_alloc_buffers+0x0/0x168 returned 0 after 0 usecs
[    0.022850] calling  init_trace_printk+0x0/0x12 @ 1
[    0.022964] initcall init_trace_printk+0x0/0x12 returned 0 after 0 usecs
[    0.023084] NMI watchdog disabled (cpu0): hardware events not enabled
[    0.023225] Brought up 1 CPUs
[    0.023482] devtmpfs: initialized
[    0.023999] calling  init_mmap_min_addr+0x0/0x16 @ 1
[    0.024116] initcall init_mmap_min_addr+0x0/0x16 returned 0 after 0 usecs
[    0.024233] calling  init_cpufreq_transition_notifier_list+0x0/0x1b @ 1
[    0.024354] initcall init_cpufreq_transition_notifier_list+0x0/0x1b returned 0 after 0 usecs
[    0.024551] calling  net_ns_init+0x0/0x154 @ 1
[    0.024669] initcall net_ns_init+0x0/0x154 returned 0 after 0 usecs
[    0.024784] calling  cpufreq_tsc+0x0/0x30 @ 1
[    0.024898] initcall cpufreq_tsc+0x0/0x30 returned 0 after 0 usecs
[    0.025014] calling  pci_reboot_init+0x0/0x14 @ 1
[    0.025129] initcall pci_reboot_init+0x0/0x14 returned 0 after 0 usecs
[    0.025245] calling  init_lapic_sysfs+0x0/0x20 @ 1
[    0.025359] initcall init_lapic_sysfs+0x0/0x20 returned 0 after 0 usecs
[    0.025475] calling  init_smp_flush+0x0/0x2d @ 1
[    0.025589] initcall init_smp_flush+0x0/0x2d returned 0 after 0 usecs
[    0.025706] calling  alloc_frozen_cpus+0x0/0x8 @ 1
[    0.025819] initcall alloc_frozen_cpus+0x0/0x8 returned 0 after 0 usecs
[    0.025934] calling  sysctl_init+0x0/0x16 @ 1
[    0.026050] initcall sysctl_init+0x0/0x16 returned 0 after 0 usecs
[    0.026165] calling  ksysfs_init+0x0/0x94 @ 1
[    0.026283] initcall ksysfs_init+0x0/0x94 returned 0 after 0 usecs
[    0.026398] calling  init_jiffies_clocksource+0x0/0x12 @ 1
[    0.026514] initcall init_jiffies_clocksource+0x0/0x12 returned 0 after 0 usecs
[    0.026710] calling  pm_init+0x0/0x63 @ 1
[    0.029012] initcall pm_init+0x0/0x63 returned 0 after 0 usecs
[    0.029128] calling  init_zero_pfn+0x0/0x35 @ 1
[    0.029241] initcall init_zero_pfn+0x0/0x35 returned 0 after 0 usecs
[    0.029358] calling  fsnotify_init+0x0/0x26 @ 1
[    0.029474] initcall fsnotify_init+0x0/0x26 returned 0 after 0 usecs
[    0.029590] calling  filelock_init+0x0/0x2e @ 1
[    0.029708] initcall filelock_init+0x0/0x2e returned 0 after 0 usecs
[    0.029824] calling  init_misc_binfmt+0x0/0x44 @ 1
[    0.029939] initcall init_misc_binfmt+0x0/0x44 returned 0 after 0 usecs
[    0.030000] calling  init_script_binfmt+0x0/0x14 @ 1
[    0.030000] initcall init_script_binfmt+0x0/0x14 returned 0 after 0 usecs
[    0.030000] calling  init_elf_binfmt+0x0/0x14 @ 1
[    0.030000] initcall init_elf_binfmt+0x0/0x14 returned 0 after 0 usecs
[    0.030000] calling  init_compat_elf_binfmt+0x0/0x14 @ 1
[    0.030000] initcall init_compat_elf_binfmt+0x0/0x14 returned 0 after 0 usecs
[    0.030000] calling  debugfs_init+0x0/0x5c @ 1
[    0.030000] initcall debugfs_init+0x0/0x5c returned 0 after 0 usecs
[    0.030000] calling  calibrate_xor_blocks+0x0/0xa0 @ 1
[    0.030000] xor: automatically using best checksumming function: generic_sse
[    0.070002]    generic_sse:  2915.200 MB/sec
[    0.070116] xor: using function: generic_sse (2915.200 MB/sec)
[    0.070235] initcall calibrate_xor_blocks+0x0/0xa0 returned 0 after 48828 usecs
[    0.070431] calling  random32_init+0x0/0xd8 @ 1
[    0.070545] initcall random32_init+0x0/0xd8 returned 0 after 0 usecs
[    0.070663] calling  __gnttab_init+0x0/0x21 @ 1
[    0.070793] Grant table initialized
[    0.070905] initcall __gnttab_init+0x0/0x21 returned 0 after 0 usecs
[    0.071020] calling  cpufreq_core_init+0x0/0xad @ 1
[    0.071137] initcall cpufreq_core_init+0x0/0xad returned 0 after 0 usecs
[    0.071255] calling  cpuidle_init+0x0/0x40 @ 1
[    0.071371] initcall cpuidle_init+0x0/0x40 returned 0 after 0 usecs
[    0.071487] calling  sock_init+0x0/0x83 @ 1
[    0.071638] initcall sock_init+0x0/0x83 returned 0 after 0 usecs
[    0.071754] calling  netpoll_init+0x0/0x31 @ 1
[    0.071868] initcall netpoll_init+0x0/0x31 returned 0 after 0 usecs
[    0.071984] calling  netlink_proto_init+0x0/0x1ad @ 1
[    0.072111] NET: Registered protocol family 16
[    0.072236] initcall netlink_proto_init+0x0/0x1ad returned 0 after 0 usecs
[    0.072353] calling  bdi_class_init+0x0/0x49 @ 1
[    0.072537] initcall bdi_class_init+0x0/0x49 returned 0 after 0 usecs
[    0.072655] calling  kobject_uevent_init+0x0/0x21 @ 1
[    0.072773] initcall kobject_uevent_init+0x0/0x21 returned 0 after 0 usecs
[    0.072891] calling  pcibus_class_init+0x0/0x19 @ 1
[    0.073057] initcall pcibus_class_init+0x0/0x19 returned 0 after 0 usecs
[    0.073177] calling  pci_driver_init+0x0/0x12 @ 1
[    0.073345] initcall pci_driver_init+0x0/0x12 returned 0 after 0 usecs
[    0.073464] calling  xenbus_init+0x0/0x371 @ 1
[    0.073649] initcall xenbus_init+0x0/0x371 returned 0 after 0 usecs
[    0.073765] calling  tty_class_init+0x0/0x34 @ 1
[    0.073928] initcall tty_class_init+0x0/0x34 returned 0 after 0 usecs
[    0.074046] calling  vtconsole_class_init+0x0/0xeb @ 1
[    0.074271] initcall vtconsole_class_init+0x0/0xeb returned 0 after 0 usecs
[    0.074390] calling  wakeup_sources_debugfs_init+0x0/0x2b @ 1
[    0.074507] initcall wakeup_sources_debugfs_init+0x0/0x2b returned 0 after 0 usecs
[    0.074702] calling  i2c_init+0x0/0x6f @ 1
[    0.074918] initcall i2c_init+0x0/0x6f returned 0 after 0 usecs
[    0.075036] calling  amd_postcore_init+0x0/0x150 @ 1
[    0.075161] node 0 link 0: io port [1000, fffff]
[    0.075277] TOM: 0000000080000000 aka 2048M
[    0.075398] node 0 link 0: mmio [a0000, bffff]
[    0.075542] node 0 link 0: mmio [80000000, ff70ffff]
[    0.075687] bus: [00, ff] on node 0 link 0
[    0.075802] bus: 00 index 0 [io  0x0000-0xffff]
[    0.075917] bus: 00 index 1 [mem 0x000a0000-0x000bffff]
[    0.076032] bus: 00 index 2 [mem 0x80000000-0xfcffffffff]
[    0.076148] initcall amd_postcore_init+0x0/0x150 returned 0 after 0 usecs
[    0.076266] calling  arch_kdebugfs_init+0x0/0x24 @ 1
[    0.076384] initcall arch_kdebugfs_init+0x0/0x24 returned 0 after 0 usecs
[    0.076502] calling  configure_trampolines+0x0/0x29 @ 1
[    0.076621] initcall configure_trampolines+0x0/0x29 returned 0 after 0 usecs
[    0.076739] calling  mtrr_if_init+0x0/0x64 @ 1
[    0.076853] initcall mtrr_if_init+0x0/0x64 returned -19 after 0 usecs
[    0.076972] calling  ffh_cstate_init+0x0/0x2a @ 1
[    0.077087] initcall ffh_cstate_init+0x0/0x2a returned -1 after 0 usecs
[    0.077206] initcall ffh_cstate_init+0x0/0x2a returned with error code -1 
[    0.077323] calling  acpi_pci_init+0x0/0x61 @ 1
[    0.077436] ACPI: bus type pci registered
[    0.077551] initcall acpi_pci_init+0x0/0x61 returned 0 after 0 usecs
[    0.077667] calling  setup_vcpu_hotplug_event+0x0/0x22 @ 1
[    0.077783] initcall setup_vcpu_hotplug_event+0x0/0x22 returned 0 after 0 usecs
[    0.077979] calling  register_xen_pci_notifier+0x0/0x31 @ 1
[    0.078096] initcall register_xen_pci_notifier+0x0/0x31 returned 0 after 0 usecs
[    0.078291] calling  dmi_id_init+0x0/0x30e @ 1
[    0.078532] initcall dmi_id_init+0x0/0x30e returned 0 after 0 usecs
[    0.078650] calling  pci_arch_init+0x0/0x69 @ 1
[    0.078782] PCI: Using configuration type 1 for base access
[    0.078908] initcall pci_arch_init+0x0/0x69 returned 0 after 0 usecs
[    0.079025] calling  topology_init+0x0/0x40 @ 1
[    0.079188] initcall topology_init+0x0/0x40 returned 0 after 0 usecs
[    0.079305] calling  mtrr_init_finialize+0x0/0x36 @ 1
[    0.079422] initcall mtrr_init_finialize+0x0/0x36 returned 0 after 0 usecs
[    0.079540] calling  init_vdso_vars+0x0/0xf8 @ 1
[    0.079661] initcall init_vdso_vars+0x0/0xf8 returned 0 after 0 usecs
[    0.079778] calling  sysenter_setup+0x0/0x2c8 @ 1
[    0.079897] initcall sysenter_setup+0x0/0x2c8 returned 0 after 0 usecs
[    0.080000] calling  param_sysfs_init+0x0/0x1b4 @ 1
[    0.090988] initcall param_sysfs_init+0x0/0x1b4 returned 0 after 19531 usecs
[    0.091118] calling  pm_sysrq_init+0x0/0x19 @ 1
[    0.091234] initcall pm_sysrq_init+0x0/0x19 returned 0 after 0 usecs
[    0.091351] calling  default_bdi_init+0x0/0xa9 @ 1
[    0.091622] initcall default_bdi_init+0x0/0xa9 returned 0 after 0 usecs
[    0.091740] calling  init_bio+0x0/0xe5 @ 1
[    0.091879] bio: create slab <bio-0> at 0
[    0.092001] initcall init_bio+0x0/0xe5 returned 0 after 0 usecs
[    0.092116] calling  fsnotify_notification_init+0x0/0x8b @ 1
[    0.092242] initcall fsnotify_notification_init+0x0/0x8b returned 0 after 0 usecs
[    0.092438] calling  cryptomgr_init+0x0/0x12 @ 1
[    0.092552] initcall cryptomgr_init+0x0/0x12 returned 0 after 0 usecs
[    0.092668] calling  blk_settings_init+0x0/0x2a @ 1
[    0.092782] initcall blk_settings_init+0x0/0x2a returned 0 after 0 usecs
[    0.092900] calling  blk_ioc_init+0x0/0x2a @ 1
[    0.093017] initcall blk_ioc_init+0x0/0x2a returned 0 after 0 usecs
[    0.093133] calling  blk_softirq_init+0x0/0x6e @ 1
[    0.093249] initcall blk_softirq_init+0x0/0x6e returned 0 after 0 usecs
[    0.093366] calling  blk_iopoll_setup+0x0/0x6e @ 1
[    0.093481] initcall blk_iopoll_setup+0x0/0x6e returned 0 after 0 usecs
[    0.093599] calling  genhd_device_init+0x0/0x7c @ 1
[    0.093818] initcall genhd_device_init+0x0/0x7c returned 0 after 0 usecs
[    0.093938] calling  raid6_select_algo+0x0/0x1bd @ 1
[    0.260022] raid6: int64x1   2044 MB/s
[    0.430003] raid6: int64x2   2403 MB/s
[    0.600006] raid6: int64x4   1709 MB/s
[    0.770032] raid6: int64x8   1243 MB/s
[    0.940004] raid6: sse2x1    2440 MB/s
[    1.110013] raid6: sse2x2    3178 MB/s
[    1.280007] raid6: sse2x4    3705 MB/s
[    1.280120] raid6: using algorithm sse2x4 (3705 MB/s)
[    1.280237] initcall raid6_select_algo+0x0/0x1bd returned 0 after 1162109 usecs
[    1.280435] calling  pci_slot_init+0x0/0x46 @ 1
[    1.280551] initcall pci_slot_init+0x0/0x46 returned 0 after 0 usecs
[    1.280668] calling  acpi_init+0x0/0xb6 @ 1
[    1.283139] ACPI: EC: Look up EC in DSDT
[    1.295082] ACPI: Interpreter enabled
[    1.295202] ACPI: (supports S0 S5)
[    1.295388] ACPI: Using IOAPIC for interrupt routing
[    1.305848] initcall acpi_init+0x0/0xb6 returned 0 after 19531 usecs
[    1.305968] calling  dock_init+0x0/0xa5 @ 1
[    1.306336] ACPI: No dock devices found.
[    1.306451] initcall dock_init+0x0/0xa5 returned 0 after 0 usecs
[    1.306569] calling  acpi_pci_root_init+0x0/0x28 @ 1
[    1.306684] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
[    1.307001] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    1.307392] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[    1.307589] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
[    1.307784] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    1.307981] pci_root PNP0A03:00: host bridge window [mem 0x000c0000-0x000dffff] (ignored)
[    1.308178] pci_root PNP0A03:00: host bridge window [mem 0x80000000-0xfebfffff] (ignored)
[    1.308405] pci 0000:00:00.0: [1106:0282] type 0 class 0x000600
[    1.308532] pci 0000:00:00.0: reg 10: [mem 0xf0000000-0xf7ffffff pref]
[    1.308774] pci 0000:00:00.1: [1106:1282] type 0 class 0x000600
[    1.308964] pci 0000:00:00.2: [1106:2282] type 0 class 0x000600
[    1.309153] pci 0000:00:00.3: [1106:3282] type 0 class 0x000600
[    1.309343] pci 0000:00:00.4: [1106:4282] type 0 class 0x000600
[    1.309537] pci 0000:00:00.7: [1106:7282] type 0 class 0x000600
[    1.309732] pci 0000:00:01.0: [1106:b188] type 1 class 0x000604
[    1.309922] pci 0000:00:01.0: supports D1
[    1.310024] pci 0000:00:09.0: [10ec:8139] type 0 class 0x000200
[    1.310165] pci 0000:00:09.0: reg 10: [io  0xe000-0xe0ff]
[    1.310293] pci 0000:00:09.0: reg 14: [mem 0xfc122000-0xfc1220ff]
[    1.310472] pci 0000:00:09.0: reg 30: [mem 0x00000000-0x0000ffff pref]
[    1.310619] pci 0000:00:09.0: supports D1 D2
[    1.310731] pci 0000:00:09.0: PME# supported from D1 D2 D3hot D3cold
[    1.310851] pci 0000:00:09.0: PME# disabled
[    1.311003] pci 0000:00:0f.0: [1106:3149] type 0 class 0x000104
[    1.311145] pci 0000:00:0f.0: reg 10: [io  0xe200-0xe207]
[    1.311273] pci 0000:00:0f.0: reg 14: [io  0xe300-0xe303]
[    1.311401] pci 0000:00:0f.0: reg 18: [io  0xe400-0xe407]
[    1.311529] pci 0000:00:0f.0: reg 1c: [io  0xe500-0xe503]
[    1.313837] pci 0000:00:0f.0: reg 20: [io  0xe600-0xe60f]
[    1.313964] pci 0000:00:0f.0: reg 24: [io  0xe700-0xe7ff]
[    1.314153] pci 0000:00:0f.1: [1106:0571] type 0 class 0x000101
[    1.314348] pci 0000:00:0f.1: reg 20: [io  0xe800-0xe80f]
[    1.314563] pci 0000:00:10.0: [1106:3038] type 0 class 0x000c03
[    1.314754] pci 0000:00:10.0: reg 20: [io  0xe900-0xe91f]
[    1.314924] pci 0000:00:10.0: supports D1 D2
[    1.315037] pci 0000:00:10.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.315157] pci 0000:00:10.0: PME# disabled
[    1.315299] pci 0000:00:10.1: [1106:3038] type 0 class 0x000c03
[    1.315492] pci 0000:00:10.1: reg 20: [io  0xea00-0xea1f]
[    1.315663] pci 0000:00:10.1: supports D1 D2
[    1.315775] pci 0000:00:10.1: PME# supported from D0 D1 D2 D3hot D3cold
[    1.315895] pci 0000:00:10.1: PME# disabled
[    1.316036] pci 0000:00:10.2: [1106:3038] type 0 class 0x000c03
[    1.316229] pci 0000:00:10.2: reg 20: [io  0xeb00-0xeb1f]
[    1.316399] pci 0000:00:10.2: supports D1 D2
[    1.316512] pci 0000:00:10.2: PME# supported from D0 D1 D2 D3hot D3cold
[    1.316631] pci 0000:00:10.2: PME# disabled
[    1.316773] pci 0000:00:10.3: [1106:3038] type 0 class 0x000c03
[    1.316964] pci 0000:00:10.3: reg 20: [io  0xec00-0xec1f]
[    1.317133] pci 0000:00:10.3: supports D1 D2
[    1.317247] pci 0000:00:10.3: PME# supported from D0 D1 D2 D3hot D3cold
[    1.317366] pci 0000:00:10.3: PME# disabled
[    1.317508] pci 0000:00:10.4: [1106:3104] type 0 class 0x000c03
[    1.317649] pci 0000:00:10.4: reg 10: [mem 0xfc121000-0xfc1210ff]
[    1.317867] pci 0000:00:10.4: supports D1 D2
[    1.317981] pci 0000:00:10.4: PME# supported from D0 D1 D2 D3hot D3cold
[    1.318100] pci 0000:00:10.4: PME# disabled
[    1.318247] pci 0000:00:11.0: [1106:3227] type 0 class 0x000601
[    1.318466] HPET not enabled in BIOS. You might try hpet=force boot option
[    1.318659] pci 0000:00:18.0: [1022:1100] type 0 class 0x000600
[    1.318842] pci 0000:00:18.1: [1022:1101] type 0 class 0x000600
[    1.319010] pci 0000:00:18.2: [1022:1102] type 0 class 0x000600
[    1.319178] pci 0000:00:18.3: [1022:1103] type 0 class 0x000600
[    1.319355] PCI: peer root bus 00 res updated from pci conf
[    1.319532] pci 0000:01:00.0: [1002:5046] type 0 class 0x000300
[    1.319672] pci 0000:01:00.0: reg 10: [mem 0xf8000000-0xfbffffff pref]
[    1.319799] pci 0000:01:00.0: reg 14: [io  0xd000-0xd0ff]
[    1.319925] pci 0000:01:00.0: reg 18: [mem 0xfc020000-0xfc023fff]
[    1.320000] pci 0000:01:00.0: reg 30: [mem 0x00000000-0x0001ffff pref]
[    1.320014] pci 0000:01:00.0: supports D1
[    1.320192] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    1.320309] pci 0000:00:01.0:   bridge window [io  0xd000-0xdfff]
[    1.320429] pci 0000:00:01.0:   bridge window [mem 0xfc000000-0xfc0fffff]
[    1.320549] pci 0000:00:01.0:   bridge window [mem 0xf8000000-0xfbffffff pref]
[    1.320755] pci_bus 0000:00: on NUMA node 0
[    1.320869] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    1.321609]  pci0000:00: Unable to request _OSC control (_OSC support mask: 0x1e)
[    1.378242] initcall acpi_pci_root_init+0x0/0x28 returned 0 after 68359 usecs
[    1.378363] calling  acpi_pci_link_init+0x0/0x3e @ 1
[    1.378641] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 6 7 *10 11 12)
[    1.379178] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 6 7 10 *11 12)
[    1.379724] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 6 7 10 11 *12)
[    1.380118] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 6 7 10 11 12) *0, disabled.
[    1.380752] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 6 7 10 11 12) *0, disabled.
[    1.381379] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 6 7 10 11 12) *0, disabled.
[    1.382004] ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 6 7 10 11 12) *0, disabled.
[    1.382629] ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 6 7 10 11 12) *0, disabled.
[    1.383315] ACPI: PCI Interrupt Link [ALKA] (IRQs *20)
[    1.383684] ACPI: PCI Interrupt Link [ALKB] (IRQs *21)
[    1.384054] ACPI: PCI Interrupt Link [ALKC] (IRQs *22), disabled.
[    1.384502] ACPI: PCI Interrupt Link [ALKD] (IRQs *23), disabled.
[    1.384801] initcall acpi_pci_link_init+0x0/0x3e returned 0 after 9765 usecs
[    1.384919] calling  pnp_init+0x0/0x12 @ 1
[    1.385090] initcall pnp_init+0x0/0x12 returned 0 after 0 usecs
[    1.385209] calling  xen_setup_shutdown_event+0x0/0x22 @ 1
[    1.385327] initcall xen_setup_shutdown_event+0x0/0x22 returned 0 after 0 usecs
[    1.385523] calling  balloon_init+0x0/0x130 @ 1
[    1.385636] xen/balloon: Initialising balloon driver.
[    1.385751] last_pfn = 0x16fef0 max_arch_pfn = 0x400000000
[    1.399622] initcall balloon_init+0x0/0x130 returned 0 after 9765 usecs
[    1.399746] calling  xenbus_probe_backend_init+0x0/0x2d @ 1
[    1.400000] initcall xenbus_probe_backend_init+0x0/0x2d returned 0 after 0 usecs
[    1.400000] calling  xenbus_probe_frontend_init+0x0/0x2d @ 1
[    1.400056] initcall xenbus_probe_frontend_init+0x0/0x2d returned 0 after 9765 usecs
[    1.400253] calling  balloon_init+0x0/0x100 @ 1
[    1.400367] xen-balloon: Initialising balloon driver.
[    1.400584] initcall balloon_init+0x0/0x100 returned 0 after 0 usecs
[    1.400701] calling  misc_init+0x0/0xb7 @ 1
[    1.400876] initcall misc_init+0x0/0xb7 returned 0 after 0 usecs
[    1.400993] calling  vga_arb_device_init+0x0/0xe4 @ 1
[    1.401217] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
[    1.401413] vgaarb: loaded
[    1.401523] vgaarb: bridge control possible 0000:01:00.0
[    1.401639] initcall vga_arb_device_init+0x0/0xe4 returned 0 after 0 usecs
[    1.401756] calling  init_scsi+0x0/0x7c @ 1
[    1.402126] SCSI subsystem initialized
[    1.402241] initcall init_scsi+0x0/0x7c returned 0 after 0 usecs
[    1.402358] calling  ata_init+0x0/0x349 @ 1
[    1.402655] libata version 3.00 loaded.
[    1.402770] initcall ata_init+0x0/0x349 returned 0 after 0 usecs
[    1.402890] calling  usb_init+0x0/0x15f @ 1
[    1.403126] usbcore: registered new interface driver usbfs
[    1.403344] usbcore: registered new interface driver hub
[    1.403534] usbcore: registered new device driver usb
[    1.403651] initcall usb_init+0x0/0x15f returned 0 after 0 usecs
[    1.403767] calling  serio_init+0x0/0x31 @ 1
[    1.403933] initcall serio_init+0x0/0x31 returned 0 after 0 usecs
[    1.404050] calling  input_init+0x0/0x10c @ 1
[    1.404218] initcall input_init+0x0/0x10c returned 0 after 0 usecs
[    1.404336] calling  rtc_init+0x0/0x6a @ 1
[    1.404498] initcall rtc_init+0x0/0x6a returned 0 after 0 usecs
[    1.404615] calling  power_supply_class_init+0x0/0x40 @ 1
[    1.404778] initcall power_supply_class_init+0x0/0x40 returned 0 after 0 usecs
[    1.404974] calling  hwmon_init+0x0/0xee @ 1
[    1.405138] initcall hwmon_init+0x0/0xee returned 0 after 0 usecs
[    1.405257] calling  md_init+0x0/0x144 @ 1
[    1.405405] initcall md_init+0x0/0x144 returned 0 after 0 usecs
[    1.405521] calling  init_soundcore+0x0/0x34 @ 1
[    1.405690] initcall init_soundcore+0x0/0x34 returned 0 after 0 usecs
[    1.405807] calling  alsa_sound_init+0x0/0x90 @ 1
[    1.405935] Advanced Linux Sound Architecture Driver Version 1.0.24.
[    1.406053] initcall alsa_sound_init+0x0/0x90 returned 0 after 0 usecs
[    1.406169] calling  pci_subsys_init+0x0/0x4d @ 1
[    1.406282] PCI: Using ACPI for IRQ routing
[    1.406396] PCI: pci_cache_line_size set to 64 bytes
[    1.406628] reserve RAM buffer: 000000000009f000 - 000000000009ffff 
[    1.406667] reserve RAM buffer: 000000016fef0000 - 000000016fffffff 
[    1.406811] initcall pci_subsys_init+0x0/0x4d returned 0 after 0 usecs
[    1.407032] calling  proto_init+0x0/0x12 @ 1
[    1.407149] initcall proto_init+0x0/0x12 returned 0 after 0 usecs
[    1.407266] calling  net_dev_init+0x0/0x1d9 @ 1
[    1.407652] initcall net_dev_init+0x0/0x1d9 returned 0 after 0 usecs
[    1.407771] calling  neigh_init+0x0/0x71 @ 1
[    1.407886] initcall neigh_init+0x0/0x71 returned 0 after 0 usecs
[    1.408002] calling  fib_rules_init+0x0/0xa6 @ 1
[    1.408116] initcall fib_rules_init+0x0/0xa6 returned 0 after 0 usecs
[    1.408233] calling  pktsched_init+0x0/0xed @ 1
[    1.408351] initcall pktsched_init+0x0/0xed returned 0 after 0 usecs
[    1.408468] calling  tc_filter_init+0x0/0x4c @ 1
[    1.408583] initcall tc_filter_init+0x0/0x4c returned 0 after 0 usecs
[    1.408699] calling  tc_action_init+0x0/0x4c @ 1
[    1.408813] initcall tc_action_init+0x0/0x4c returned 0 after 0 usecs
[    1.408930] calling  genl_init+0x0/0x93 @ 1
[    1.409056] initcall genl_init+0x0/0x93 returned 0 after 0 usecs
[    1.409174] calling  sysctl_init+0x0/0x48 @ 1
[    1.409290] initcall sysctl_init+0x0/0x48 returned 0 after 0 usecs
[    1.409407] calling  print_ICs+0x0/0x510 @ 1
[    1.409520] initcall print_ICs+0x0/0x510 returned 0 after 0 usecs
[    1.409637] calling  hpet_late_init+0x0/0xf4 @ 1
[    1.409753] initcall hpet_late_init+0x0/0xf4 returned -19 after 0 usecs
[    1.409870] calling  init_amd_nbs+0x0/0xba @ 1
[    1.410000] initcall init_amd_nbs+0x0/0xba returned 0 after 0 usecs
[    1.410000] calling  clocksource_done_booting+0x0/0x5a @ 1
[    1.410000] Switching to clocksource xen
[    1.410015] initcall clocksource_done_booting+0x0/0x5a returned 0 after 9769 usecs
[    1.410213] calling  rb_init_debugfs+0x0/0x2f @ 1
[    1.410332] initcall rb_init_debugfs+0x0/0x2f returned 0 after 4 usecs
[    1.410448] calling  tracer_init_debugfs+0x0/0x36b @ 1
[    1.410632] initcall tracer_init_debugfs+0x0/0x36b returned 0 after 67 usecs
[    1.410749] calling  init_trace_printk_function_export+0x0/0x2f @ 1
[    1.410868] initcall init_trace_printk_function_export+0x0/0x2f returned 0 after 1 usecs
[    1.411063] calling  event_trace_init+0x0/0x2bd @ 1
[    1.416385] initcall event_trace_init+0x0/0x2bd returned 0 after 5078 usecs
[    1.416515] calling  init_pipe_fs+0x0/0x4c @ 1
[    1.416653] initcall init_pipe_fs+0x0/0x4c returned 0 after 23 usecs
[    1.416770] calling  eventpoll_init+0x0/0xda @ 1
[    1.416904] initcall eventpoll_init+0x0/0xda returned 0 after 20 usecs
[    1.417021] calling  anon_inode_init+0x0/0x12e @ 1
[    1.417146] initcall anon_inode_init+0x0/0x12e returned 0 after 10 usecs
[    1.417264] calling  blk_scsi_ioctl_init+0x0/0x289 @ 1
[    1.417380] initcall blk_scsi_ioctl_init+0x0/0x289 returned 0 after 0 usecs
[    1.417498] calling  acpi_event_init+0x0/0x52 @ 1
[    1.417624] initcall acpi_event_init+0x0/0x52 returned 0 after 11 usecs
[    1.417741] calling  pnp_system_init+0x0/0x12 @ 1
[    1.420073] Switched to NOHz mode on CPU #0
[    1.420317] initcall pnp_system_init+0x0/0x12 returned 0 after 272 usecs
[    1.420437] calling  pnpacpi_init+0x0/0x8c @ 1
[    1.420549] pnp: PnP ACPI init
[    1.420677] ACPI: bus type pnp registered
[    1.421171] pnp 00:00: [mem 0x000d1c00-0x000d3fff]
[    1.421287] pnp 00:00: [mem 0x000f0000-0x000f7fff]
[    1.421400] pnp 00:00: [mem 0x000f8000-0x000fbfff]
[    1.421515] pnp 00:00: [mem 0x000fc000-0x000fffff]
[    1.421629] pnp 00:00: [mem 0x7ff00000-0x7fffffff]
[    1.421742] pnp 00:00: [mem 0x7fef0000-0x7fefffff]
[    1.421858] pnp 00:00: [mem 0xffff0000-0xffffffff]
[    1.421972] pnp 00:00: [mem 0x00000000-0x0009ffff]
[    1.422085] pnp 00:00: [mem 0x00100000-0x7feeffff]
[    1.422200] pnp 00:00: [mem 0xfec00000-0xfec00fff]
[    1.422315] pnp 00:00: [mem 0xfee00000-0xfee00fff]
[    1.422430] pnp 00:00: [mem 0xfff80000-0xfffeffff]
[    1.422665] system 00:00: [mem 0x000d1c00-0x000d3fff] could not be reserved
[    1.422787] system 00:00: [mem 0x000f0000-0x000f7fff] could not be reserved
[    1.422905] system 00:00: [mem 0x000f8000-0x000fbfff] could not be reserved
[    1.423023] system 00:00: [mem 0x000fc000-0x000fffff] could not be reserved
[    1.423142] system 00:00: [mem 0x7ff00000-0x7fffffff] has been reserved
[    1.423261] system 00:00: [mem 0x7fef0000-0x7fefffff] could not be reserved
[    1.423379] system 00:00: [mem 0xffff0000-0xffffffff] has been reserved
[    1.423498] system 00:00: [mem 0x00000000-0x0009ffff] could not be reserved
[    1.423617] system 00:00: [mem 0x00100000-0x7feeffff] could not be reserved
[    1.423735] system 00:00: [mem 0xfec00000-0xfec00fff] could not be reserved
[    1.423853] system 00:00: [mem 0xfee00000-0xfee00fff] has been reserved
[    1.423970] system 00:00: [mem 0xfff80000-0xfffeffff] has been reserved
[    1.424090] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    1.424347] pnp 00:01: [bus 00-ff]
[    1.424460] pnp 00:01: [io  0x0cf8-0x0cff]
[    1.424574] pnp 00:01: [io  0x0000-0x0cf7 window]
[    1.424689] pnp 00:01: [io  0x0d00-0xffff window]
[    1.424804] pnp 00:01: [mem 0x000a0000-0x000bffff window]
[    1.424920] pnp 00:01: [mem 0x000c0000-0x000dffff window]
[    1.425036] pnp 00:01: [mem 0x80000000-0xfebfffff window]
[    1.425267] pnp 00:01: Plug and Play ACPI device, IDs PNP0a03 (active)
[    1.425421] pnp 00:02: [io  0x4000-0x407f]
[    1.425534] pnp 00:02: [io  0x5000-0x500f]
[    1.425739] system 00:02: [io  0x4000-0x407f] has been reserved
[    1.425857] system 00:02: [io  0x5000-0x500f] has been reserved
[    1.425974] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.427373] pnp 00:03: [io  0x0010-0x001f]
[    1.427488] pnp 00:03: [io  0x0022-0x003f]
[    1.427601] pnp 00:03: [io  0x0044-0x005f]
[    1.427712] pnp 00:03: [io  0x0062-0x0063]
[    1.427826] pnp 00:03: [io  0x0065-0x006f]
[    1.427939] pnp 00:03: [io  0x0074-0x007f]
[    1.428052] pnp 00:03: [io  0x0091-0x0093]
[    1.428164] pnp 00:03: [io  0x00a2-0x00bf]
[    1.428278] pnp 00:03: [io  0x00e0-0x00ef]
[    1.428392] pnp 00:03: [io  0x0b78-0x0b7b]
[    1.428505] pnp 00:03: [io  0x0f78-0x0f7b]
[    1.428617] pnp 00:03: [io  0x0a78-0x0a7b]
[    1.428730] pnp 00:03: [io  0x0e78-0x0e7b]
[    1.428843] pnp 00:03: [io  0x0bbc-0x0bbf]
[    1.428959] pnp 00:03: [io  0x0fbc-0x0fbf]
[    1.429073] pnp 00:03: [io  0x04d0-0x04d1]
[    1.429187] pnp 00:03: [io  0x0290-0x0297]
[    1.429425] system 00:03: [io  0x0b78-0x0b7b] has been reserved
[    1.429544] system 00:03: [io  0x0f78-0x0f7b] has been reserved
[    1.429661] system 00:03: [io  0x0a78-0x0a7b] has been reserved
[    1.429778] system 00:03: [io  0x0e78-0x0e7b] has been reserved
[    1.429895] system 00:03: [io  0x0bbc-0x0bbf] has been reserved
[    1.430012] system 00:03: [io  0x0fbc-0x0fbf] has been reserved
[    1.430058] system 00:03: [io  0x04d0-0x04d1] has been reserved
[    1.430058] system 00:03: [io  0x0290-0x0297] has been reserved
[    1.430058] system 00:03: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.430504] pnp 00:04: [dma 4]
[    1.430618] pnp 00:04: [io  0x0000-0x000f]
[    1.430733] pnp 00:04: [io  0x0080-0x0090]
[    1.430849] pnp 00:04: [io  0x0094-0x009f]
[    1.430963] pnp 00:04: [io  0x00c0-0x00df]
[    1.431164] pnp 00:04: Plug and Play ACPI device, IDs PNP0200 (active)
[    1.431300] pnp 00:05: [io  0x0070-0x0073]
[    1.431415] xen: registering gsi 8 triggering 1 polarity 0
[    1.431529] xen_map_pirq_gsi: returning irq 8 for gsi 8
[    1.431642] xen: --> pirq=8 -> irq=8
[    1.431764] pnp 00:05: [irq 8]
[    1.431961] pnp 00:05: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.432092] pnp 00:06: [io  0x0061]
[    1.432295] pnp 00:06: Plug and Play ACPI device, IDs PNP0800 (active)
[    1.432428] pnp 00:07: [io  0x00f0-0x00ff]
[    1.432543] xen: registering gsi 13 triggering 1 polarity 0
[    1.432659] xen_map_pirq_gsi: returning irq 13 for gsi 13
[    1.432774] xen: --> pirq=13 -> irq=13
[    1.432890] pnp 00:07: [irq 13]
[    1.433098] pnp 00:07: Plug and Play ACPI device, IDs PNP0c04 (active)
[    1.433428] pnp 00:08: [io  0x03f0-0x03f5]
[    1.433543] pnp 00:08: [io  0x03f7]
[    1.433655] xen: registering gsi 6 triggering 1 polarity 0
[    1.433771] xen_map_pirq_gsi: returning irq 6 for gsi 6
[    1.433886] xen: --> pirq=6 -> irq=6
[    1.434001] pnp 00:08: [irq 6]
[    1.434112] pnp 00:08: [dma 2]
[    1.434333] pnp 00:08: Plug and Play ACPI device, IDs PNP0700 (active)
[    1.434765] pnp 00:09: [io  0x03f8-0x03ff]
[    1.434880] xen: registering gsi 4 triggering 1 polarity 0
[    1.434993] xen_map_pirq_gsi: returning irq 4 for gsi 4
[    1.435108] xen: --> pirq=4 -> irq=4
[    1.435223] pnp 00:09: [irq 4]
[    1.435465] pnp 00:09: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.435928] pnp 00:0a: [io  0x02f8-0x02ff]
[    1.436042] xen: registering gsi 3 triggering 1 polarity 0
[    1.436157] xen_map_pirq_gsi: returning irq 3 for gsi 3
[    1.436270] xen: --> pirq=3 -> irq=3
[    1.436385] pnp 00:0a: [irq 3]
[    1.436628] pnp 00:0a: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.437323] pnp 00:0b: [io  0x0378-0x037f]
[    1.437436] pnp 00:0b: [io  0x0778-0x077b]
[    1.437550] xen: registering gsi 7 triggering 1 polarity 0
[    1.437664] xen_map_pirq_gsi: returning irq 7 for gsi 7
[    1.437778] xen: --> pirq=7 -> irq=7
[    1.437894] pnp 00:0b: [irq 7]
[    1.438130] pnp 00:0b: Plug and Play ACPI device, IDs PNP0400 (active)
[    1.438414] pnp 00:0c: [io  0x0060]
[    1.438526] pnp 00:0c: [io  0x0064]
[    1.438638] xen: registering gsi 1 triggering 1 polarity 0
[    1.438753] xen_map_pirq_gsi: returning irq 1 for gsi 1
[    1.438866] xen: --> pirq=1 -> irq=1
[    1.438983] pnp 00:0c: [irq 1]
[    1.439190] pnp 00:0c: Plug and Play ACPI device, IDs PNP0303 PNP030b (active)
[    1.439424] pnp: PnP ACPI: found 13 devices
[    1.439536] ACPI: ACPI bus type pnp unregistered
[    1.439651] initcall pnpacpi_init+0x0/0x8c returned 0 after 18651 usecs
[    1.439768] calling  chr_dev_init+0x0/0xc1 @ 1
[    1.445245] initcall chr_dev_init+0x0/0xc1 returned 0 after 5230 usecs
[    1.445371] calling  firmware_class_init+0x0/0x19 @ 1
[    1.445547] initcall firmware_class_init+0x0/0x19 returned 0 after 58 usecs
[    1.445666] calling  thermal_init+0x0/0x75 @ 1
[    1.445836] initcall thermal_init+0x0/0x75 returned 0 after 54 usecs
[    1.445955] calling  cpufreq_gov_performance_init+0x0/0x12 @ 1
[    1.446071] initcall cpufreq_gov_performance_init+0x0/0x12 returned 0 after 0 usecs
[    1.446268] calling  init_acpi_pm_clocksource+0x0/0xe0 @ 1
[    1.450316] PM-Timer failed consistency check  (0x0xffffff) - aborting.
[    1.450435] initcall init_acpi_pm_clocksource+0x0/0xe0 returned -19 after 3956 usecs
[    1.450634] calling  pcibios_assign_resources+0x0/0x74 @ 1
[    1.450773] PCI: max bus depth: 1 pci_try_num: 2
[    1.450909] pci 0000:00:09.0: BAR 6: assigned [mem 0x80000000-0x8000ffff pref]
[    1.451109] pci 0000:01:00.0: BAR 6: assigned [mem 0xfc000000-0xfc01ffff pref]
[    1.451305] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    1.451421] pci 0000:00:01.0:   bridge window [io  0xd000-0xdfff]
[    1.451543] pci 0000:00:01.0:   bridge window [mem 0xfc000000-0xfc0fffff]
[    1.451663] pci 0000:00:01.0:   bridge window [mem 0xf8000000-0xfbffffff pref]
[    1.451876] pci 0000:00:01.0: setting latency timer to 64
[    1.451993] pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
[    1.452110] pci_bus 0000:00: resource 5 [mem 0x000a0000-0x000bffff]
[    1.452225] pci_bus 0000:00: resource 6 [mem 0x80000000-0xfcffffffff]
[    1.452341] pci_bus 0000:01: resource 0 [io  0xd000-0xdfff]
[    1.452455] pci_bus 0000:01: resource 1 [mem 0xfc000000-0xfc0fffff]
[    1.452572] pci_bus 0000:01: resource 2 [mem 0xf8000000-0xfbffffff pref]
[    1.452689] initcall pcibios_assign_resources+0x0/0x74 returned 0 after 1893 usecs
[    1.452884] calling  sysctl_core_init+0x0/0x38 @ 1
[    1.453005] initcall sysctl_core_init+0x0/0x38 returned 0 after 7 usecs
[    1.453122] calling  inet_init+0x0/0x286 @ 1
[    1.453279] NET: Registered protocol family 2
[    1.453454] IP route cache hash table entries: 16384 (order: 5, 131072 bytes)
[    1.453779] TCP established hash table entries: 65536 (order: 8, 1048576 bytes)
[    1.454564] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    1.455322] TCP: Hash tables configured (established 65536 bind 65536)
[    1.455443] TCP reno registered
[    1.455557] UDP hash table entries: 1024 (order: 3, 32768 bytes)
[    1.455693] UDP-Lite hash table entries: 1024 (order: 3, 32768 bytes)
[    1.455972] initcall inet_init+0x0/0x286 returned 0 after 2668 usecs
[    1.456092] calling  af_unix_init+0x0/0x55 @ 1
[    1.456210] NET: Registered protocol family 1
[    1.456329] initcall af_unix_init+0x0/0x55 returned 0 after 120 usecs
[    1.456447] calling  init_sunrpc+0x0/0x73 @ 1
[    1.456716] RPC: Registered named UNIX socket transport module.
[    1.456834] RPC: Registered udp transport module.
[    1.456948] RPC: Registered tcp transport module.
[    1.459247] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    1.459366] initcall init_sunrpc+0x0/0x73 returned 0 after 2736 usecs
[    1.459483] calling  pci_apply_final_quirks+0x0/0x106 @ 1
[    1.459630] pci 0000:00:01.0: disabling DAC on VIA PCI bridge
[    1.459914] pci 0000:01:00.0: Boot video device
[    1.460031] PCI: CLS 32 bytes, default 64
[    1.460063] initcall pci_apply_final_quirks+0x0/0x106 returned 0 after 534 usecs
[    1.460063] calling  populate_rootfs+0x0/0x9e @ 1
[    1.460542] initcall populate_rootfs+0x0/0x9e returned 0 after 79 usecs
[    1.460661] calling  pci_iommu_init+0x0/0x41 @ 1
[    1.460776] initcall pci_iommu_init+0x0/0x41 returned 0 after 0 usecs
[    1.460893] calling  irqfd_module_init+0x0/0x31 @ 1
[    1.461079] initcall irqfd_module_init+0x0/0x31 returned 0 after 68 usecs
[    1.461197] calling  svm_init+0x0/0x1e @ 1
[    1.461313] has_svm: svm not available
[    1.461425] kvm: no hardware support
[    1.461538] initcall svm_init+0x0/0x1e returned -95 after 221 usecs
[    1.461656] initcall svm_init+0x0/0x1e returned with error code -95 
[    1.461772] calling  i8259A_init_ops+0x0/0x21 @ 1
[    1.461886] initcall i8259A_init_ops+0x0/0x21 returned 0 after 0 usecs
[    1.462003] calling  vsyscall_init+0x0/0x66 @ 1
[    1.462121] initcall vsyscall_init+0x0/0x66 returned 0 after 3 usecs
[    1.462237] calling  sbf_init+0x0/0xe9 @ 1
[    1.462349] initcall sbf_init+0x0/0xe9 returned 0 after 0 usecs
[    1.462465] calling  init_tsc_clocksource+0x0/0x5f @ 1
[    1.462585] initcall init_tsc_clocksource+0x0/0x5f returned 0 after 1 usecs
[    1.462703] calling  add_rtc_cmos+0x0/0x97 @ 1
[    1.462819] initcall add_rtc_cmos+0x0/0x97 returned 0 after 2 usecs
[    1.462935] calling  i8237A_init_ops+0x0/0x14 @ 1
[    1.463049] initcall i8237A_init_ops+0x0/0x14 returned 0 after 0 usecs
[    1.463168] calling  cache_sysfs_init+0x0/0x64 @ 1
[    1.463535] initcall cache_sysfs_init+0x0/0x64 returned 0 after 246 usecs
[    1.463654] calling  mcheck_init_device+0x0/0x100 @ 1
[    1.463771] initcall mcheck_init_device+0x0/0x100 returned -5 after 0 usecs
[    1.463889] initcall mcheck_init_device+0x0/0x100 returned with error code -5 
[    1.464086] calling  threshold_init_device+0x0/0x4f @ 1
[    1.464202] initcall threshold_init_device+0x0/0x4f returned 0 after 0 usecs
[    1.464320] calling  thermal_throttle_init_device+0x0/0x9b @ 1
[    1.464437] initcall thermal_throttle_init_device+0x0/0x9b returned 0 after 0 usecs
[    1.464635] calling  ioapic_init_ops+0x0/0x14 @ 1
[    1.464750] initcall ioapic_init_ops+0x0/0x14 returned 0 after 0 usecs
[    1.464868] calling  add_pcspkr+0x0/0x3a @ 1
[    1.465050] initcall add_pcspkr+0x0/0x3a returned 0 after 65 usecs
[    1.465167] calling  aes_init+0x0/0x12 @ 1
[    1.465321] initcall aes_init+0x0/0x12 returned 0 after 37 usecs
[    1.465437] calling  init+0x0/0x12 @ 1
[    1.465582] initcall init+0x0/0x12 returned 0 after 30 usecs
[    1.465698] calling  ia32_binfmt_init+0x0/0x14 @ 1
[    1.465814] initcall ia32_binfmt_init+0x0/0x14 returned 0 after 1 usecs
[    1.465930] calling  init_sched_debug_procfs+0x0/0x2c @ 1
[    1.466049] initcall init_sched_debug_procfs+0x0/0x2c returned 0 after 4 usecs
[    1.466243] calling  proc_schedstat_init+0x0/0x22 @ 1
[    1.466359] initcall proc_schedstat_init+0x0/0x22 returned 0 after 1 usecs
[    1.466475] calling  proc_execdomains_init+0x0/0x22 @ 1
[    1.466592] initcall proc_execdomains_init+0x0/0x22 returned 0 after 1 usecs
[    1.466709] calling  ioresources_init+0x0/0x3c @ 1
[    1.466826] initcall ioresources_init+0x0/0x3c returned 0 after 3 usecs
[    1.466942] calling  uid_cache_init+0x0/0x8d @ 1
[    1.467061] initcall uid_cache_init+0x0/0x8d returned 0 after 6 usecs
[    1.467180] calling  init_posix_timers+0x0/0x1cf @ 1
[    1.467300] initcall init_posix_timers+0x0/0x1cf returned 0 after 5 usecs
[    1.467416] calling  init_posix_cpu_timers+0x0/0xbf @ 1
[    1.467531] initcall init_posix_cpu_timers+0x0/0xbf returned 0 after 0 usecs
[    1.467648] calling  nsproxy_cache_init+0x0/0x2d @ 1
[    1.467768] initcall nsproxy_cache_init+0x0/0x2d returned 0 after 5 usecs
[    1.467885] calling  timekeeping_init_ops+0x0/0x14 @ 1
[    1.468001] initcall timekeeping_init_ops+0x0/0x14 returned 0 after 0 usecs
[    1.468117] calling  init_clocksource_sysfs+0x0/0x50 @ 1
[    1.468332] initcall init_clocksource_sysfs+0x0/0x50 returned 0 after 97 usecs
[    1.468529] calling  init_timer_list_procfs+0x0/0x2c @ 1
[    1.468647] initcall init_timer_list_procfs+0x0/0x2c returned 0 after 2 usecs
[    1.468764] calling  alarmtimer_init+0x0/0x147 @ 1
[    1.468991] initcall alarmtimer_init+0x0/0x147 returned 0 after 108 usecs
[    1.469111] calling  init_tstats_procfs+0x0/0x2c @ 1
[    1.469228] initcall init_tstats_procfs+0x0/0x2c returned 0 after 2 usecs
[    1.469346] calling  futex_init+0x0/0x5d @ 1
[    1.469467] initcall futex_init+0x0/0x5d returned 0 after 7 usecs
[    1.469583] calling  proc_dma_init+0x0/0x22 @ 1
[    1.469700] initcall proc_dma_init+0x0/0x22 returned 0 after 2 usecs
[    1.469819] calling  proc_modules_init+0x0/0x22 @ 1
[    1.469936] initcall proc_modules_init+0x0/0x22 returned 0 after 2 usecs
[    1.470055] calling  kallsyms_init+0x0/0x25 @ 1
[    1.470171] initcall kallsyms_init+0x0/0x25 returned 0 after 1 usecs
[    1.470288] calling  ikconfig_init+0x0/0x3a @ 1
[    1.470405] initcall ikconfig_init+0x0/0x3a returned 0 after 1 usecs
[    1.470472] calling  hung_task_init+0x0/0x56 @ 1
[    1.470672] initcall hung_task_init+0x0/0x56 returned 0 after 32 usecs
[    1.470790] calling  utsname_sysctl_init+0x0/0x14 @ 1
[    1.470907] initcall utsname_sysctl_init+0x0/0x14 returned 0 after 1 usecs
[    1.471024] calling  init_tracepoints+0x0/0x12 @ 1
[    1.471140] initcall init_tracepoints+0x0/0x12 returned 0 after 0 usecs
[    1.471257] calling  init_lstats_procfs+0x0/0x25 @ 1
[    1.471373] initcall init_lstats_procfs+0x0/0x25 returned 0 after 2 usecs
[    1.471491] calling  init_events+0x0/0x61 @ 1
[    1.471609] initcall init_events+0x0/0x61 returned 0 after 3 usecs
[    1.471726] calling  init_mmio_trace+0x0/0x12 @ 1
[    1.471842] initcall init_mmio_trace+0x0/0x12 returned 0 after 0 usecs
[    1.471958] calling  init_blk_tracer+0x0/0x55 @ 1
[    1.472073] initcall init_blk_tracer+0x0/0x55 returned 0 after 0 usecs
[    1.472190] calling  perf_event_sysfs_init+0x0/0x93 @ 1
[    1.472537] initcall perf_event_sysfs_init+0x0/0x93 returned 0 after 224 usecs
[    1.472734] calling  init_per_zone_wmark_min+0x0/0x88 @ 1
[    1.473665] initcall init_per_zone_wmark_min+0x0/0x88 returned 0 after 793 usecs
[    1.473866] calling  kswapd_init+0x0/0x20 @ 1
[    1.474038] initcall kswapd_init+0x0/0x20 returned 0 after 56 usecs
[    1.474157] calling  extfrag_debug_init+0x0/0x7b @ 1
[    1.474282] initcall extfrag_debug_init+0x0/0x7b returned 0 after 10 usecs
[    1.474399] calling  setup_vmstat+0x0/0xc0 @ 1
[    1.474531] initcall setup_vmstat+0x0/0xc0 returned 0 after 17 usecs
[    1.474647] calling  mm_sysfs_init+0x0/0x29 @ 1
[    1.474767] initcall mm_sysfs_init+0x0/0x29 returned 0 after 5 usecs
[    1.474884] calling  proc_vmalloc_init+0x0/0x25 @ 1
[    1.475000] initcall proc_vmalloc_init+0x0/0x25 returned 0 after 2 usecs
[    1.475116] calling  procswaps_init+0x0/0x22 @ 1
[    1.475233] initcall procswaps_init+0x0/0x22 returned 0 after 2 usecs
[    1.475350] calling  hugetlb_init+0x0/0x3db @ 1
[    1.475464] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.475590] initcall hugetlb_init+0x0/0x3db returned 0 after 123 usecs
[    1.475708] calling  slab_proc_init+0x0/0x25 @ 1
[    1.475824] initcall slab_proc_init+0x0/0x25 returned 0 after 2 usecs
[    1.475939] calling  cpucache_init+0x0/0x40 @ 1
[    1.476053] initcall cpucache_init+0x0/0x40 returned 0 after 0 usecs
[    1.476169] calling  hugepage_init+0x0/0x12a @ 1
[    1.476282] initcall hugepage_init+0x0/0x12a returned -22 after 0 usecs
[    1.476400] initcall hugepage_init+0x0/0x12a returned with error code -22 
[    1.476516] calling  init_cleancache+0x0/0x1b @ 1
[    1.476633] initcall init_cleancache+0x0/0x1b returned 0 after 3 usecs
[    1.476750] calling  fcntl_init+0x0/0x2a @ 1
[    1.476879] initcall fcntl_init+0x0/0x2a returned 0 after 15 usecs
[    1.476995] calling  proc_filesystems_init+0x0/0x22 @ 1
[    1.477112] initcall proc_filesystems_init+0x0/0x22 returned 0 after 2 usecs
[    1.477228] calling  fsnotify_mark_init+0x0/0x40 @ 1
[    1.477373] initcall fsnotify_mark_init+0x0/0x40 returned 0 after 28 usecs
[    1.477489] calling  dnotify_init+0x0/0x7b @ 1
[    1.477611] initcall dnotify_init+0x0/0x7b returned 0 after 9 usecs
[    1.477726] calling  inotify_user_setup+0x0/0x70 @ 1
[    1.477850] initcall inotify_user_setup+0x0/0x70 returned 0 after 10 usecs
[    1.477966] calling  aio_setup+0x0/0x78 @ 1
[    1.478092] initcall aio_setup+0x0/0x78 returned 0 after 13 usecs
[    1.478207] calling  proc_locks_init+0x0/0x22 @ 1
[    1.478325] initcall proc_locks_init+0x0/0x22 returned 0 after 2 usecs
[    1.478442] calling  init_sys32_ioctl+0x0/0x28 @ 1
[    1.478643] initcall init_sys32_ioctl+0x0/0x28 returned 0 after 85 usecs
[    1.478759] calling  init_mbcache+0x0/0x14 @ 1
[    1.478874] initcall init_mbcache+0x0/0x14 returned 0 after 0 usecs
[    1.478990] calling  proc_cmdline_init+0x0/0x22 @ 1
[    1.479106] initcall proc_cmdline_init+0x0/0x22 returned 0 after 2 usecs
[    1.479229] calling  proc_consoles_init+0x0/0x22 @ 1
[    1.479346] initcall proc_consoles_init+0x0/0x22 returned 0 after 2 usecs
[    1.479462] calling  proc_cpuinfo_init+0x0/0x22 @ 1
[    1.479581] initcall proc_cpuinfo_init+0x0/0x22 returned 0 after 2 usecs
[    1.479698] calling  proc_devices_init+0x0/0x22 @ 1
[    1.479814] initcall proc_devices_init+0x0/0x22 returned 0 after 2 usecs
[    1.479930] calling  proc_interrupts_init+0x0/0x22 @ 1
[    1.480046] initcall proc_interrupts_init+0x0/0x22 returned 0 after 2 usecs
[    1.480165] calling  proc_loadavg_init+0x0/0x22 @ 1
[    1.480281] initcall proc_loadavg_init+0x0/0x22 returned 0 after 1 usecs
[    1.480397] calling  proc_meminfo_init+0x0/0x22 @ 1
[    1.480512] initcall proc_meminfo_init+0x0/0x22 returned 0 after 1 usecs
[    1.480629] calling  proc_stat_init+0x0/0x22 @ 1
[    1.480641] initcall proc_stat_init+0x0/0x22 returned 0 after 1 usecs
[    1.480641] calling  proc_uptime_init+0x0/0x22 @ 1
[    1.480641] initcall proc_uptime_init+0x0/0x22 returned 0 after 1 usecs
[    1.480641] calling  proc_version_init+0x0/0x22 @ 1
[    1.480641] initcall proc_version_init+0x0/0x22 returned 0 after 1 usecs
[    1.480641] calling  proc_softirqs_init+0x0/0x22 @ 1
[    1.480641] initcall proc_softirqs_init+0x0/0x22 returned 0 after 1 usecs
[    1.480641] calling  proc_kcore_init+0x0/0xa9 @ 1
[    1.480641] initcall proc_kcore_init+0x0/0xa9 returned 0 after 4 usecs
[    1.480641] calling  proc_kmsg_init+0x0/0x25 @ 1
[    1.481926] initcall proc_kmsg_init+0x0/0x25 returned 0 after 22 usecs
[    1.482044] calling  proc_page_init+0x0/0x42 @ 1
[    1.482165] initcall proc_page_init+0x0/0x42 returned 0 after 4 usecs
[    1.484463] calling  configfs_init+0x0/0xb3 @ 1
[    1.484597] initcall configfs_init+0x0/0xb3 returned 0 after 17 usecs
[    1.484714] calling  init_devpts_fs+0x0/0x4c @ 1
[    1.484844] initcall init_devpts_fs+0x0/0x4c returned 0 after 15 usecs
[    1.484961] calling  init_ext3_fs+0x0/0x6f @ 1
[    1.485089] initcall init_ext3_fs+0x0/0x6f returned 0 after 12 usecs
[    1.485206] calling  init_ext2_fs+0x0/0x6f @ 1
[    1.485335] initcall init_ext2_fs+0x0/0x6f returned 0 after 13 usecs
[    1.485453] calling  ext4_init_fs+0x0/0x20c @ 1
[    1.485621] initcall ext4_init_fs+0x0/0x20c returned 0 after 49 usecs
[    1.485739] calling  journal_init+0x0/0x97 @ 1
[    1.485877] initcall journal_init+0x0/0x97 returned 0 after 20 usecs
[    1.485994] calling  journal_init+0x0/0x104 @ 1
[    1.486136] initcall journal_init+0x0/0x104 returned 0 after 25 usecs
[    1.486253] calling  init_squashfs_fs+0x0/0x66 @ 1
[    1.486373] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    1.486492] initcall init_squashfs_fs+0x0/0x66 returned 0 after 120 usecs
[    1.486609] calling  init_ramfs_fs+0x0/0x12 @ 1
[    1.486726] initcall init_ramfs_fs+0x0/0x12 returned 0 after 0 usecs
[    1.486843] calling  init_hugetlbfs_fs+0x0/0x98 @ 1
[    1.486987] initcall init_hugetlbfs_fs+0x0/0x98 returned 0 after 28 usecs
[    1.487106] calling  init_fat_fs+0x0/0x4f @ 1
[    1.487231] initcall init_fat_fs+0x0/0x4f returned 0 after 9 usecs
[    1.487347] calling  init_vfat_fs+0x0/0x12 @ 1
[    1.487462] initcall init_vfat_fs+0x0/0x12 returned 0 after 1 usecs
[    1.487579] calling  init_iso9660_fs+0x0/0x5c @ 1
[    1.487700] initcall init_iso9660_fs+0x0/0x5c returned 0 after 5 usecs
[    1.487818] calling  init_nfs_fs+0x0/0x10e @ 1
[    1.488048] initcall init_nfs_fs+0x0/0x10e returned 0 after 111 usecs
[    1.488165] calling  init_nfsd+0x0/0xbb @ 1
[    1.488278] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    1.488694] initcall init_nfsd+0x0/0xbb returned 0 after 404 usecs
[    1.488810] calling  init_nlm+0x0/0x22 @ 1
[    1.488925] initcall init_nlm+0x0/0x22 returned 0 after 1 usecs
[    1.489041] calling  init_nls_cp437+0x0/0x12 @ 1
[    1.489157] initcall init_nls_cp437+0x0/0x12 returned 0 after 0 usecs
[    1.489276] calling  init_nls_cp850+0x0/0x12 @ 1
[    1.489391] initcall init_nls_cp850+0x0/0x12 returned 0 after 0 usecs
[    1.489508] calling  init_nls_cp932+0x0/0x12 @ 1
[    1.489622] initcall init_nls_cp932+0x0/0x12 returned 0 after 0 usecs
[    1.489740] calling  init_nls_euc_jp+0x0/0x48 @ 1
[    1.489856] initcall init_nls_euc_jp+0x0/0x48 returned 0 after 0 usecs
[    1.489975] calling  init_nls_iso8859_1+0x0/0x12 @ 1
[    1.490091] initcall init_nls_iso8859_1+0x0/0x12 returned 0 after 0 usecs
[    1.490207] calling  init_nls_iso8859_15+0x0/0x12 @ 1
[    1.490322] initcall init_nls_iso8859_15+0x0/0x12 returned 0 after 0 usecs
[    1.490439] calling  init_nls_utf8+0x0/0x29 @ 1
[    1.490554] initcall init_nls_utf8+0x0/0x29 returned 0 after 0 usecs
[    1.490670] calling  init_ntfs_fs+0x0/0x1d1 @ 1
[    1.490783] NTFS driver 2.1.30 [Flags: R/W].
[    1.490931] initcall init_ntfs_fs+0x0/0x1d1 returned 0 after 143 usecs
[    1.491048] calling  init_autofs4_fs+0x0/0x26 @ 1
[    1.491274] initcall init_autofs4_fs+0x0/0x26 returned 0 after 108 usecs
[    1.491391] calling  fuse_init+0x0/0x141 @ 1
[    1.491503] fuse init (API version 7.16)
[    1.491702] initcall fuse_init+0x0/0x141 returned 0 after 193 usecs
[    1.491820] calling  init_udf_fs+0x0/0x5c @ 1
[    1.491942] initcall init_udf_fs+0x0/0x5c returned 0 after 6 usecs
[    1.492057] calling  init_xfs_fs+0x0/0xa9 @ 1
[    1.492170] SGI XFS with ACLs, security attributes, large block/inode numbers, no debug enabled
[    1.492597] initcall init_xfs_fs+0x0/0xa9 returned 0 after 414 usecs
[    1.492716] calling  ipc_init+0x0/0x23 @ 1
[    1.492831] msgmni has been set to 284
[    1.492950] initcall ipc_init+0x0/0x23 returned 0 after 117 usecs
[    1.493066] calling  ipc_sysctl_init+0x0/0x14 @ 1
[    1.493182] initcall ipc_sysctl_init+0x0/0x14 returned 0 after 1 usecs
[    1.493298] calling  key_proc_init+0x0/0x33 @ 1
[    1.493414] initcall key_proc_init+0x0/0x33 returned 0 after 2 usecs
[    1.493530] calling  crypto_wq_init+0x0/0x31 @ 1
[    1.493673] initcall crypto_wq_init+0x0/0x31 returned 0 after 27 usecs
[    1.493791] calling  crypto_algapi_init+0x0/0xd @ 1
[    1.493908] initcall crypto_algapi_init+0x0/0xd returned 0 after 3 usecs
[    1.494025] calling  skcipher_module_init+0x0/0x36 @ 1
[    1.494141] initcall skcipher_module_init+0x0/0x36 returned 0 after 0 usecs
[    1.494259] calling  chainiv_module_init+0x0/0x12 @ 1
[    1.494376] initcall chainiv_module_init+0x0/0x12 returned 0 after 0 usecs
[    1.494492] calling  eseqiv_module_init+0x0/0x12 @ 1
[    1.494607] initcall eseqiv_module_init+0x0/0x12 returned 0 after 0 usecs
[    1.494725] calling  seqiv_module_init+0x0/0x12 @ 1
[    1.494841] initcall seqiv_module_init+0x0/0x12 returned 0 after 0 usecs
[    1.494957] calling  hmac_module_init+0x0/0x12 @ 1
[    1.495070] initcall hmac_module_init+0x0/0x12 returned 0 after 0 usecs
[    1.495189] calling  md5_mod_init+0x0/0x12 @ 1
[    1.495343] initcall md5_mod_init+0x0/0x12 returned 0 after 37 usecs
[    1.495459] calling  sha1_generic_mod_init+0x0/0x12 @ 1
[    1.495608] initcall sha1_generic_mod_init+0x0/0x12 returned 0 after 33 usecs
[    1.495726] calling  sha256_generic_mod_init+0x0/0x3f @ 1
[    1.495905] initcall sha256_generic_mod_init+0x0/0x3f returned 0 after 62 usecs
[    1.496101] calling  crypto_cbc_module_init+0x0/0x12 @ 1
[    1.496216] initcall crypto_cbc_module_init+0x0/0x12 returned 0 after 0 usecs
[    1.496335] calling  crypto_ctr_module_init+0x0/0x3e @ 1
[    1.496450] initcall crypto_ctr_module_init+0x0/0x3e returned 0 after 0 usecs
[    1.496566] calling  cryptd_init+0x0/0xc5 @ 1
[    1.496683] initcall cryptd_init+0x0/0xc5 returned 0 after 3 usecs
[    1.496798] calling  des_generic_mod_init+0x0/0x3f @ 1
[    1.496977] initcall des_generic_mod_init+0x0/0x3f returned 0 after 62 usecs
[    1.497094] calling  blowfish_mod_init+0x0/0x12 @ 1
[    1.497240] initcall blowfish_mod_init+0x0/0x12 returned 0 after 31 usecs
[    1.497357] calling  aes_init+0x0/0x12 @ 1
[    1.497502] initcall aes_init+0x0/0x12 returned 0 after 30 usecs
[    1.497617] calling  krng_mod_init+0x0/0x12 @ 1
[    1.497763] initcall krng_mod_init+0x0/0x12 returned 0 after 31 usecs
[    1.497880] calling  async_pq_init+0x0/0x44 @ 1
[    1.497995] initcall async_pq_init+0x0/0x44 returned 0 after 1 usecs
[    1.498112] calling  proc_genhd_init+0x0/0x3c @ 1
[    1.498231] initcall proc_genhd_init+0x0/0x3c returned 0 after 5 usecs
[    1.498347] calling  init_cgroup_blkio+0x0/0x12 @ 1
[    1.498462] initcall init_cgroup_blkio+0x0/0x12 returned 0 after 0 usecs
[    1.498578] calling  throtl_init+0x0/0x44 @ 1
[    1.498719] initcall throtl_init+0x0/0x44 returned 0 after 25 usecs
[    1.498836] calling  noop_init+0x0/0x14 @ 1
[    1.498948] io scheduler noop registered
[    1.499062] initcall noop_init+0x0/0x14 returned 0 after 111 usecs
[    1.499179] calling  deadline_init+0x0/0x14 @ 1
[    1.499292] io scheduler deadline registered
[    1.499405] initcall deadline_init+0x0/0x14 returned 0 after 109 usecs
[    1.499521] calling  cfq_init+0x0/0xb3 @ 1
[    1.499646] io scheduler cfq registered (default)
[    1.499762] initcall cfq_init+0x0/0xb3 returned 0 after 124 usecs
[    1.499877] calling  init_kmp+0x0/0x12 @ 1
[    1.499992] initcall init_kmp+0x0/0x12 returned 0 after 0 usecs
[    1.500109] calling  init_bm+0x0/0x12 @ 1
[    1.500222] initcall init_bm+0x0/0x12 returned 0 after 0 usecs
[    1.500336] calling  init_fsm+0x0/0x12 @ 1
[    1.500450] initcall init_fsm+0x0/0x12 returned 0 after 0 usecs
[    1.500565] calling  percpu_counter_startup+0x0/0x19 @ 1
[    1.500680] initcall percpu_counter_startup+0x0/0x19 returned 0 after 0 usecs
[    1.500799] calling  pci_proc_init+0x0/0x6b @ 1
[    1.500993] initcall pci_proc_init+0x0/0x6b returned 0 after 78 usecs
[    1.501111] calling  pcie_portdrv_init+0x0/0x7a @ 1
[    1.501363] initcall pcie_portdrv_init+0x0/0x7a returned 0 after 132 usecs
[    1.501480] calling  aer_service_init+0x0/0x22 @ 1
[    1.501642] initcall aer_service_init+0x0/0x22 returned 0 after 46 usecs
[    1.501759] calling  pcie_pme_service_init+0x0/0x12 @ 1
[    1.501923] initcall pcie_pme_service_init+0x0/0x12 returned 0 after 47 usecs
[    1.502041] calling  ioapic_init+0x0/0x1b @ 1
[    1.502212] initcall ioapic_init+0x0/0x1b returned 0 after 55 usecs
[    1.502330] calling  pcifront_init+0x0/0x5c @ 1
[    1.502444] initcall pcifront_init+0x0/0x5c returned -19 after 0 usecs
[    1.502560] calling  acpi_reserve_resources+0x0/0xeb @ 1
[    1.502679] initcall acpi_reserve_resources+0x0/0xeb returned 0 after 4 usecs
[    1.502796] calling  irqrouter_init_ops+0x0/0x26 @ 1
[    1.502912] initcall irqrouter_init_ops+0x0/0x26 returned 0 after 0 usecs
[    1.503030] calling  acpi_button_init+0x0/0x12 @ 1
[    1.503263] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
[    1.503463] ACPI: Power Button [PWRB]
[    1.503701] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    1.503897] ACPI: Power Button [PWRF]
[    1.504069] initcall acpi_button_init+0x0/0x12 returned 0 after 901 usecs
[    1.504188] calling  acpi_fan_init+0x0/0x18 @ 1
[    1.504355] initcall acpi_fan_init+0x0/0x18 returned 0 after 51 usecs
[    1.504474] calling  acpi_pci_slot_init+0x0/0x20 @ 1
[    1.504931] initcall acpi_pci_slot_init+0x0/0x20 returned 0 after 335 usecs
[    1.505048] calling  acpi_processor_init+0x0/0xcd @ 1
[    1.505162] ACPI: acpi_idle registered with cpuidle
[    1.505471] initcall acpi_processor_init+0x0/0xcd returned 0 after 300 usecs
[    1.505589] calling  acpi_container_init+0x0/0x4a @ 1
[    1.509054] initcall acpi_container_init+0x0/0x4a returned 0 after 3269 usecs
[    1.509172] calling  acpi_thermal_init+0x0/0x42 @ 1
[    1.509350] initcall acpi_thermal_init+0x0/0x42 returned 0 after 60 usecs
[    1.509468] calling  xenbus_probe_initcall+0x0/0x3b @ 1
[    1.509584] initcall xenbus_probe_initcall+0x0/0x3b returned 0 after 0 usecs
[    1.509704] calling  xen_tmem_init+0x0/0x5c @ 1
[    1.509818] initcall xen_tmem_init+0x0/0x5c returned 0 after 0 usecs
[    1.509935] calling  evtchn_init+0x0/0x6e @ 1
[    1.510180] Event-channel device installed.
[    1.510294] initcall evtchn_init+0x0/0x6e returned 0 after 238 usecs
[    1.510412] calling  xenfs_init+0x0/0x2d @ 1
[    1.510529] initcall xenfs_init+0x0/0x2d returned 0 after 3 usecs
[    1.510646] calling  hypervisor_subsys_init+0x0/0x25 @ 1
[    1.510762] initcall hypervisor_subsys_init+0x0/0x25 returned 0 after 0 usecs
[    1.510879] calling  hyper_sysfs_init+0x0/0xbf @ 1
[    1.511006] initcall hyper_sysfs_init+0x0/0xbf returned 0 after 12 usecs
[    1.511122] calling  pty_init+0x0/0x26a @ 1
[    1.511331] initcall pty_init+0x0/0x26a returned 0 after 92 usecs
[    1.511446] calling  sysrq_init+0x0/0x68 @ 1
[    1.513746] initcall sysrq_init+0x0/0x68 returned 0 after 6 usecs
[    1.513864] calling  xen_hvc_init+0x0/0x144 @ 1
[    1.514566] initcall xen_hvc_init+0x0/0x144 returned 0 after 572 usecs
[    1.514684] calling  serial8250_init+0x0/0x18e @ 1
[    1.514799] Serial: 8250/16550 driver, 1 ports, IRQ sharing disabled
[    1.520093] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.535996] initcall serial8250_init+0x0/0x18e returned 0 after 20698 usecs
[    1.536114] calling  serial8250_pnp_init+0x0/0x12 @ 1
[    1.545863] 00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.557484] serial 00:0a: disabled
[    1.557664] initcall serial8250_pnp_init+0x0/0x12 returned 0 after 20931 usecs
[    1.557861] calling  serial8250_pci_init+0x0/0x1b @ 1
[    1.558065] initcall serial8250_pci_init+0x0/0x1b returned 0 after 85 usecs
[    1.558185] calling  rand_initialize+0x0/0x2c @ 1
[    1.558321] initcall rand_initialize+0x0/0x2c returned 0 after 21 usecs
[    1.558439] calling  hpet_init+0x0/0x6a @ 1
[    1.558683] initcall hpet_init+0x0/0x6a returned 0 after 126 usecs
[    1.558802] calling  topology_sysfs_init+0x0/0x50 @ 1
[    1.558924] initcall topology_sysfs_init+0x0/0x50 returned 0 after 6 usecs
[    1.559041] calling  loop_init+0x0/0x231 @ 1
[    1.560627] loop: module loaded
[    1.560741] initcall loop_init+0x0/0x231 returned 0 after 1547 usecs
[    1.560858] calling  init_cryptoloop+0x0/0x2f @ 1
[    1.560972] initcall init_cryptoloop+0x0/0x2f returned 0 after 0 usecs
[    1.561089] calling  xlblk_init+0x0/0x81 @ 1
[    1.561257] initcall xlblk_init+0x0/0x81 returned 0 after 51 usecs
[    1.561374] calling  xen_blkif_init+0x0/0x276 @ 1
[    1.562142] initcall xen_blkif_init+0x0/0x276 returned 0 after 638 usecs
[    1.562260] calling  init_sd+0x0/0x112 @ 1
[    1.562492] initcall init_sd+0x0/0x112 returned 0 after 113 usecs
[    1.562610] calling  init_sr+0x0/0x46 @ 1
[    1.562773] initcall init_sr+0x0/0x46 returned 0 after 48 usecs
[    1.562891] calling  init_sg+0x0/0xc7 @ 1
[    1.563055] initcall init_sg+0x0/0xc7 returned 0 after 48 usecs
[    1.563171] calling  ahci_init+0x0/0x1b @ 1
[    1.563363] initcall ahci_init+0x0/0x1b returned 0 after 74 usecs
[    1.563481] calling  piix_init+0x0/0x29 @ 1
[    1.563657] initcall piix_init+0x0/0x29 returned 0 after 60 usecs
[    1.563774] calling  mv_init+0x0/0x45 @ 1
[    1.563998] initcall mv_init+0x0/0x45 returned 0 after 106 usecs
[    1.564117] calling  nv_init+0x0/0x1b @ 1
[    1.564290] initcall nv_init+0x0/0x1b returned 0 after 57 usecs
[    1.564408] calling  svia_init+0x0/0x1b @ 1
[    1.564531] sata_via 0000:00:0f.0: version 2.6
[    1.564891] ACPI: PCI Interrupt Link [ALKA] enabled at IRQ 20
[    1.565008] xen: registering gsi 20 triggering 0 polarity 1
[    1.565129] xen: --> pirq=20 -> irq=20
[    1.565251] sata_via 0000:00:0f.0: PCI INT B -> Link[ALKA] -> GSI 20 (level, low) -> IRQ 20
[    1.565502] sata_via 0000:00:0f.0: routed to hard irq line 11
[    1.566207] scsi0 : sata_via
[    1.566498] scsi1 : sata_via
[    1.566744] ata1: SATA max UDMA/133 cmd 0xe200 ctl 0xe300 bmdma 0xe600 irq 20
[    1.566864] ata2: SATA max UDMA/133 cmd 0xe400 ctl 0xe500 bmdma 0xe608 irq 20
[    1.567009] calling  1_async_port_probe+0x0/0x4a @ 5
[    1.567172] calling  2_async_port_probe+0x0/0x4a @ 12
[    1.567288] async_waiting @ 12
[    1.567467] initcall svia_init+0x0/0x1b returned 0 after 2876 usecs
[    1.567585] calling  amd_init+0x0/0x1b @ 1
[    1.567759] initcall amd_init+0x0/0x1b returned 0 after 59 usecs
[    1.567877] calling  pdc2027x_init+0x0/0x1b @ 1
[    1.568049] initcall pdc2027x_init+0x0/0x1b returned 0 after 56 usecs
[    1.568166] calling  sil680_init+0x0/0x1b @ 1
[    1.568336] initcall sil680_init+0x0/0x1b returned 0 after 54 usecs
[    1.568453] calling  via_init+0x0/0x1b @ 1
[    1.568574] pata_via 0000:00:0f.1: version 0.3.4
[    1.568697] xen: registering gsi 20 triggering 0 polarity 1
[    1.568812] xen_map_pirq_gsi: returning irq 20 for gsi 20
[    1.568926] xen: --> pirq=20 -> irq=20
[    1.569038] Already setup the GSI :20
[    1.569151] pata_via 0000:00:0f.1: PCI INT A -> Link[ALKA] -> GSI 20 (level, low) -> IRQ 20
[    1.570175] scsi2 : pata_via
[    1.570443] scsi3 : pata_via
[    1.573335] ata3: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xe800 irq 14
[    1.573454] ata4: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xe808 irq 15
[    1.573602] calling  3_async_port_probe+0x0/0x4a @ 579
[    1.573886] calling  4_async_port_probe+0x0/0x4a @ 580
[    1.574001] async_waiting @ 580
[    1.574178] initcall via_init+0x0/0x1b returned 0 after 5479 usecs
[    1.574295] calling  e1000_init_module+0x0/0x87 @ 1
[    1.574410] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
[    1.574526] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    1.574707] initcall e1000_init_module+0x0/0x87 returned 0 after 288 usecs
[    1.574826] calling  e1000_init_module+0x0/0x3e @ 1
[    1.574939] e1000e: Intel(R) PRO/1000 Network Driver - 1.3.10-k2
[    1.575053] e1000e: Copyright(c) 1999 - 2011 Intel Corporation.
[    1.575232] initcall e1000_init_module+0x0/0x3e returned 0 after 284 usecs
[    1.575351] calling  e100_init_module+0x0/0x5d @ 1
[    1.575466] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[    1.575580] e100: Copyright(c) 1999-2006 Intel Corporation
[    1.575758] initcall e100_init_module+0x0/0x5d returned 0 after 283 usecs
[    1.575876] calling  net_olddevs_init+0x0/0x9e @ 1
[    1.575995] initcall net_olddevs_init+0x0/0x9e returned 0 after 4 usecs
[    1.576111] calling  ppp_init+0x0/0xe4 @ 1
[    1.576223] PPP generic driver version 2.4.2
[    1.576481] initcall ppp_init+0x0/0xe4 returned 0 after 250 usecs
[    1.576599] calling  ppp_async_init+0x0/0x36 @ 1
[    1.576714] initcall ppp_async_init+0x0/0x36 returned 0 after 0 usecs
[    1.576833] calling  ppp_sync_init+0x0/0x36 @ 1
[    1.576948] initcall ppp_sync_init+0x0/0x36 returned 0 after 0 usecs
[    1.577064] calling  deflate_init+0x0/0x3b @ 1
[    1.577176] PPP Deflate Compression module registered
[    1.577293] initcall deflate_init+0x0/0x3b returned 0 after 112 usecs
[    1.577409] calling  bsdcomp_init+0x0/0x2f @ 1
[    1.577521] PPP BSD Compression module registered
[    1.577635] initcall bsdcomp_init+0x0/0x2f returned 0 after 110 usecs
[    1.577751] calling  pppox_init+0x0/0x12 @ 1
[    1.577864] NET: Registered protocol family 24
[    1.577978] initcall pppox_init+0x0/0x12 returned 0 after 110 usecs
[    1.578095] calling  pppoe_init+0x0/0x87 @ 1
[    1.578220] initcall pppoe_init+0x0/0x87 returned 0 after 10 usecs
[    1.578336] calling  netif_init+0x0/0x66 @ 1
[    1.578450] initcall netif_init+0x0/0x66 returned 0 after 0 usecs
[    1.578567] calling  netback_init+0x0/0x219 @ 1
[    1.578831] initcall netback_init+0x0/0x219 returned 0 after 145 usecs
[    1.578951] calling  dummy_init_module+0x0/0xaa @ 1
[    1.579317] initcall dummy_init_module+0x0/0xaa returned 0 after 244 usecs
[    1.579436] calling  ifb_init_module+0x0/0xad @ 1
[    1.579990] initcall ifb_init_module+0x0/0xad returned 0 after 428 usecs
[    1.580062] calling  cp_init+0x0/0x1b @ 1
[    1.580246] 8139cp: 8139cp: 10/100 PCI Ethernet driver v1.3 (Mar 22, 2004)
[    1.580364] 8139cp 0000:00:09.0: This (id 10ec:8139 rev 10) is not an 8139C+ compatible chip, use 8139too
[    1.580631] initcall cp_init+0x0/0x1b returned 0 after 396 usecs
[    1.580747] calling  rtl8139_init_module+0x0/0x1b @ 1
[    1.580870] 8139too: 8139too Fast Ethernet driver 0.9.28
[    1.580998] xen: registering gsi 17 triggering 0 polarity 1
[    1.581118] xen: --> pirq=17 -> irq=17
[    1.581236] 8139too 0000:00:09.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    1.581839] 8139too 0000:00:09.0: eth0: RealTek RTL8139 at 0xffffc9000001a000, 00:e0:4c:4c:17:fb, IRQ 17
[    1.582105] initcall rtl8139_init_module+0x0/0x1b returned 0 after 1211 usecs
[    1.582223] calling  tun_init+0x0/0x93 @ 1
[    1.582334] tun: Universal TUN/TAP device driver, 1.6
[    1.582447] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    1.582642] initcall tun_init+0x0/0x93 returned 0 after 298 usecs
[    1.582760] calling  rtl8169_init_module+0x0/0x1b @ 1
[    1.582935] initcall rtl8169_init_module+0x0/0x1b returned 0 after 58 usecs
[    1.583054] calling  cdc_init+0x0/0x1b @ 1
[    1.583222] usbcore: registered new interface driver cdc_ether
[    1.583339] initcall cdc_init+0x0/0x1b returned 0 after 167 usecs
[    1.583454] calling  cdc_subset_init+0x0/0x1b @ 1
[    1.583619] usbcore: registered new interface driver cdc_subset
[    1.583736] initcall cdc_subset_init+0x0/0x1b returned 0 after 163 usecs
[    1.583853] calling  zaurus_init+0x0/0x1b @ 1
[    1.584016] usbcore: registered new interface driver zaurus
[    1.584134] initcall zaurus_init+0x0/0x1b returned 0 after 162 usecs
[    1.584250] calling  usbnet_init+0x0/0x2b @ 1
[    1.584368] initcall usbnet_init+0x0/0x2b returned 0 after 3 usecs
[    1.584484] calling  cdc_ncm_init+0x0/0x29 @ 1
[    1.584596] cdc_ncm: 01-June-2011
[    1.584761] usbcore: registered new interface driver cdc_ncm
[    1.584878] initcall cdc_ncm_init+0x0/0x29 returned 0 after 273 usecs
[    1.584995] calling  de_init+0x0/0x1b @ 1
[    1.585166] initcall de_init+0x0/0x1b returned 0 after 55 usecs
[    1.585284] calling  tulip_init+0x0/0x33 @ 1
[    1.585459] initcall tulip_init+0x0/0x33 returned 0 after 59 usecs
[    1.585577] calling  de4x5_module_init+0x0/0x1b @ 1
[    1.585748] initcall de4x5_module_init+0x0/0x1b returned 0 after 53 usecs
[    1.585865] calling  init_netconsole+0x0/0x23e @ 1
[    1.585981] netconsole: local port 25360
[    1.586093] netconsole: local IP 85.10.200.103
[    1.586205] netconsole: interface 'eth0'
[    1.586318] netconsole: remote port 514
[    1.586430] netconsole: remote IP 217.160.215.119
[    1.586543] netconsole: remote ethernet address 00:26:88:75:cf:27
[    1.586658] netconsole: device eth0 not up yet, forcing it
[    1.586942] 8139too 0000:00:09.0: eth0: link up, 100Mbps, full-duplex, lpa 0x45E1
[    1.587260] netconsole: carrier detect appears untrustworthy, waiting 4 seconds
[    1.742464] async_waiting @ 579
[    1.770068] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.970465] ata1.00: ATA-8: SAMSUNG HD321KJ, CP100-10, max UDMA7
[    1.970585] ata1.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    1.990444] ata1.00: configured for UDMA/133
[    1.990567] async_waiting @ 5
[    1.990678] async_continuing @ 5 after 0 usec
[    1.993138] scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG HD321KJ  CP10 PQ: 0 ANSI: 5
[    1.993608] calling  5_sd_probe_async+0x0/0x1b9 @ 599
[    1.993794] sd 0:0:0:0: [sda] 625142448 512-byte logical blocks: (320 GB/298 GiB)
[    1.994088] sd 0:0:0:0: [sda] Write Protect is off
[    1.994202] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.994356] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.995147] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.995271] initcall 1_async_port_probe+0x0/0x4a returned 0 after 418111 usecs
[    1.995482] async_continuing @ 12 after 418050 usec
[    2.011474]  sda: sda1 sda2 sda3 sda4 < sda5 >
[    2.013823] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.013946] initcall 5_sd_probe_async+0x0/0x1b9 returned 0 after 19744 usecs
[    2.200077] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.380461] ata2.00: ATA-8: SAMSUNG HD321KJ, CP100-10, max UDMA7
[    2.380577] ata2.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    2.400468] ata2.00: configured for UDMA/133
[    2.400596] async_waiting @ 12
[    2.400709] async_continuing @ 12 after 0 usec
[    2.400929] scsi 1:0:0:0: Direct-Access     ATA      SAMSUNG HD321KJ  CP10 PQ: 0 ANSI: 5
[    2.401365] calling  6_sd_probe_async+0x0/0x1b9 @ 599
[    2.401536] sd 1:0:0:0: [sdb] 625142448 512-byte logical blocks: (320 GB/298 GiB)
[    2.401825] sd 1:0:0:0: [sdb] Write Protect is off
[    2.401941] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    2.402095] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.402811] sd 1:0:0:0: Attached scsi generic sg1 type 0
[    2.402935] initcall 2_async_port_probe+0x0/0x4a returned 0 after 816059 usecs
[    2.403137] async_continuing @ 579 after 645080 usec
[    2.403253] initcall 3_async_port_probe+0x0/0x4a returned 0 after 810093 usecs
[    2.403453] async_continuing @ 580 after 809903 usec
[    2.411851]  sdb: sdb1 sdb2 sdb3 sdb4 < sdb5 >
[    2.412641] sd 1:0:0:0: [sdb] Attached SCSI disk
[    2.412759] initcall 6_sd_probe_async+0x0/0x1b9 returned 0 after 11011 usecs
[    2.572527] async_waiting @ 580
[    2.572641] async_continuing @ 580 after 0 usec
[    2.572757] initcall 4_async_port_probe+0x0/0x4a returned 0 after 975345 usecs
[    5.600087] console [netcon0] enabled
[    5.600087] netconsole: network logging started
[    5.600087] initcall init_netconsole+0x0/0x23e returned 0 after 3950957 usecs
[    5.600087] calling  cdrom_init+0x0/0xd @ 1
[    5.600087] initcall cdrom_init+0x0/0xd returned 0 after 5 usecs
[    5.600087] calling  mon_init+0x0/0xfc @ 1
[    5.632465] initcall mon_init+0x0/0xfc returned 0 after 159 usecs
[    5.632585] calling  ehci_hcd_init+0x0/0x78 @ 1
[    5.632704] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    5.633099] ACPI: PCI Interrupt Link [ALKB] enabled at IRQ 21
[    5.633220] xen: registering gsi 21 triggering 0 polarity 1
[    5.633350] xen: --> pirq=21 -> irq=21
[    5.633490] ehci_hcd 0000:00:10.4: PCI INT C -> Link[ALKB] -> GSI 21 (level, low) -> IRQ 21
[    5.633726] ehci_hcd 0000:00:10.4: EHCI Host Controller
[    5.633930] ehci_hcd 0000:00:10.4: new USB bus registered, assigned bus number 1
[    5.634263] ehci_hcd 0000:00:10.4: irq 21, io mem 0xfc121000
[    5.650086] ehci_hcd 0000:00:10.4: USB 2.0 started, EHCI 1.00
[    5.650427] hub 1-0:1.0: USB hub found
[    5.650548] hub 1-0:1.0: 8 ports detected
[    5.650883] initcall ehci_hcd_init+0x0/0x78 returned 0 after 17750 usecs
[    5.651005] calling  ohci_hcd_mod_init+0x0/0x54 @ 1
[    5.651122] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    5.651300] initcall ohci_hcd_mod_init+0x0/0x54 returned 0 after 171 usecs
[    5.651421] calling  uhci_hcd_init+0x0/0xc6 @ 1
[    5.651539] uhci_hcd: USB Universal Host Controller Interface driver
[    5.651695] xen: registering gsi 21 triggering 0 polarity 1
[    5.651813] xen_map_pirq_gsi: returning irq 21 for gsi 21
[    5.651930] xen: --> pirq=21 -> irq=21
[    5.652050] Already setup the GSI :21
[    5.652167] uhci_hcd 0000:00:10.0: PCI INT A -> Link[ALKB] -> GSI 21 (level, low) -> IRQ 21
[    5.652374] uhci_hcd 0000:00:10.0: UHCI Host Controller
[    5.652584] uhci_hcd 0000:00:10.0: new USB bus registered, assigned bus number 2
[    5.652822] uhci_hcd 0000:00:10.0: irq 21, io base 0x0000e900
[    5.653219] hub 2-0:1.0: USB hub found
[    5.653340] hub 2-0:1.0: 2 ports detected
[    5.653619] xen: registering gsi 21 triggering 0 polarity 1
[    5.653736] xen_map_pirq_gsi: returning irq 21 for gsi 21
[    5.653854] xen: --> pirq=21 -> irq=21
[    5.653975] Already setup the GSI :21
[    5.654092] uhci_hcd 0000:00:10.1: PCI INT A -> Link[ALKB] -> GSI 21 (level, low) -> IRQ 21
[    5.654298] uhci_hcd 0000:00:10.1: UHCI Host Controller
[    5.654496] uhci_hcd 0000:00:10.1: new USB bus registered, assigned bus number 3
[    5.654736] uhci_hcd 0000:00:10.1: irq 21, io base 0x0000ea00
[    5.655122] hub 3-0:1.0: USB hub found
[    5.655243] hub 3-0:1.0: 2 ports detected
[    5.655518] xen: registering gsi 21 triggering 0 polarity 1
[    5.655636] xen_map_pirq_gsi: returning irq 21 for gsi 21
[    5.655753] xen: --> pirq=21 -> irq=21
[    5.655872] Already setup the GSI :21
[    5.655991] uhci_hcd 0000:00:10.2: PCI INT B -> Link[ALKB] -> GSI 21 (level, low) -> IRQ 21
[    5.656199] uhci_hcd 0000:00:10.2: UHCI Host Controller
[    5.656402] uhci_hcd 0000:00:10.2: new USB bus registered, assigned bus number 4
[    5.656640] uhci_hcd 0000:00:10.2: irq 21, io base 0x0000eb00
[    5.657022] hub 4-0:1.0: USB hub found
[    5.657143] hub 4-0:1.0: 2 ports detected
[    5.657419] xen: registering gsi 21 triggering 0 polarity 1
[    5.657538] xen_map_pirq_gsi: returning irq 21 for gsi 21
[    5.657656] xen: --> pirq=21 -> irq=21
[    5.657778] Already setup the GSI :21
[    5.657894] uhci_hcd 0000:00:10.3: PCI INT B -> Link[ALKB] -> GSI 21 (level, low) -> IRQ 21
[    5.658100] uhci_hcd 0000:00:10.3: UHCI Host Controller
[    5.658309] uhci_hcd 0000:00:10.3: new USB bus registered, assigned bus number 5
[    5.658549] uhci_hcd 0000:00:10.3: irq 21, io base 0x0000ec00
[    5.658934] hub 5-0:1.0: USB hub found
[    5.659055] hub 5-0:1.0: 2 ports detected
[    5.659379] initcall uhci_hcd_init+0x0/0xc6 returned 0 after 7654 usecs
[    5.659501] calling  acm_init+0x0/0xfd @ 1
[    5.659692] usbcore: registered new interface driver cdc_acm
[    5.659813] cdc_acm: USB Abstract Control Model driver for USB modems and ISDN adapters
[    5.660016] initcall acm_init+0x0/0xfd returned 0 after 388 usecs
[    5.660057] calling  usblp_init+0x0/0x1b @ 1
[    5.660337] usbcore: registered new interface driver usblp
[    5.660460] initcall usblp_init+0x0/0x1b returned 0 after 199 usecs
[    5.660581] calling  usb_serial_init+0x0/0x1e5 @ 1
[    5.660822] usbcore: registered new interface driver usbserial
[    5.660997] USB Serial support registered for generic
[    5.661175] usbcore: registered new interface driver usbserial_generic
[    5.661296] usbserial: USB Serial Driver core
[    5.661416] initcall usb_serial_init+0x0/0x1e5 returned 0 after 699 usecs
[    5.661536] calling  pl2303_init+0x0/0x58 @ 1
[    5.661705] USB Serial support registered for pl2303
[    5.661888] usbcore: registered new interface driver pl2303
[    5.662007] pl2303: Prolific PL2303 USB to serial adaptor driver
[    5.662129] initcall pl2303_init+0x0/0x58 returned 0 after 464 usecs
[    5.662249] calling  i8042_init+0x0/0x3a2 @ 1
[    5.662498] i8042: PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[    5.662620] i8042: PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
[    5.663067] serio: i8042 KBD port at 0x60,0x64 irq 1
[    5.663286] initcall i8042_init+0x0/0x3a2 returned 0 after 897 usecs
[    5.663409] calling  serport_init+0x0/0x34 @ 1
[    5.663529] initcall serport_init+0x0/0x34 returned 0 after 0 usecs
[    5.663649] calling  mousedev_init+0x0/0x8e @ 1
[    5.663948] mousedev: PS/2 mouse device common for all mice
[    5.664070] initcall mousedev_init+0x0/0x8e returned 0 after 295 usecs
[    5.664189] calling  joydev_init+0x0/0x12 @ 1
[    5.664307] initcall joydev_init+0x0/0x12 returned 0 after 1 usecs
[    5.664426] calling  evdev_init+0x0/0x12 @ 1
[    5.664753] initcall evdev_init+0x0/0x12 returned 0 after 145 usecs
[    5.664873] calling  atkbd_init+0x0/0x27 @ 1
[    5.665054] initcall atkbd_init+0x0/0x27 returned 0 after 59 usecs
[    5.665173] calling  cmos_init+0x0/0x6a @ 1
[    5.665329] rtc_cmos 00:05: RTC can wake from S4
[    5.665729] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[    5.665917] rtc0: alarms up to one year, y3k, 242 bytes nvram
[    5.666092] initcall cmos_init+0x0/0x6a returned 0 after 782 usecs
[    5.666212] calling  i2c_dev_init+0x0/0xca @ 1
[    5.666329] i2c /dev entries driver
[    5.666502] initcall i2c_dev_init+0x0/0xca returned 0 after 166 usecs
[    5.666622] calling  i2c_piix4_init+0x0/0x1b @ 1
[    5.666805] initcall i2c_piix4_init+0x0/0x1b returned 0 after 62 usecs
[    5.666926] calling  sm_it87_init+0x0/0x3f5 @ 1
[    5.667077] initcall sm_it87_init+0x0/0x3f5 returned -19 after 32 usecs
[    5.667196] calling  k8temp_init+0x0/0x1b @ 1
[    5.667464] initcall k8temp_init+0x0/0x1b returned 0 after 146 usecs
[    5.667585] calling  sm_vt8231_init+0x0/0x1b @ 1
[    5.667759] initcall sm_vt8231_init+0x0/0x1b returned 0 after 54 usecs
[    5.667879] calling  raid_init+0x0/0x12 @ 1
[    5.667997] md: raid1 personality registered for level 1
[    5.668116] initcall raid_init+0x0/0x12 returned 0 after 115 usecs
[    5.668234] calling  raid5_init+0x0/0x2c @ 1
[    5.668406] md: raid6 personality registered for level 6
[    5.668526] md: raid5 personality registered for level 5
[    5.668645] md: raid4 personality registered for level 4
[    5.670279] initcall raid5_init+0x0/0x2c returned 0 after 2484 usecs
[    5.670279] calling  dm_init+0x0/0x46 @ 1
[    5.671724] device-mapper: ioctl: 4.20.0-ioctl (2011-02-02) initialised: dm-devel@redhat.com
[    5.671926] initcall dm_init+0x0/0x46 returned 0 after 665 usecs
[    5.672047] calling  dm_crypt_init+0x0/0x69 @ 1
[    5.672171] initcall dm_crypt_init+0x0/0x69 returned 0 after 6 usecs
[    5.672290] calling  dm_snapshot_init+0x0/0x205 @ 1
[    5.672505] initcall dm_snapshot_init+0x0/0x205 returned 0 after 39 usecs
[    5.672627] calling  dm_mirror_init+0x0/0x79 @ 1
[    5.672750] initcall dm_mirror_init+0x0/0x79 returned 0 after 5 usecs
[    5.672869] calling  dm_dirty_log_init+0x0/0x59 @ 1
[    5.672986] initcall dm_dirty_log_init+0x0/0x59 returned 0 after 0 usecs
[    5.673160] calling  cpufreq_stats_init+0x0/0x9d @ 1
[    5.673281] initcall cpufreq_stats_init+0x0/0x9d returned 0 after 2 usecs
[    5.673400] calling  cpufreq_gov_dbs_init+0x0/0x5e @ 1
[    5.673520] initcall cpufreq_gov_dbs_init+0x0/0x5e returned 0 after 1 usecs
[    5.673694] calling  init_ladder+0x0/0x12 @ 1
[    5.673811] cpuidle: using governor ladder
[    5.673927] initcall init_ladder+0x0/0x12 returned 0 after 112 usecs
[    5.674045] calling  init_menu+0x0/0x12 @ 1
[    5.674215] cpuidle: using governor menu
[    5.674332] initcall init_menu+0x0/0x12 returned 0 after 112 usecs
[    5.674449] calling  hid_init+0x0/0x4d @ 1
[    5.674637] initcall hid_init+0x0/0x4d returned 0 after 69 usecs
[    5.674759] calling  a4_init+0x0/0x1b @ 1
[    5.674930] initcall a4_init+0x0/0x1b returned 0 after 51 usecs
[    5.675050] calling  apple_init+0x0/0x38 @ 1
[    5.675223] initcall apple_init+0x0/0x38 returned 0 after 52 usecs
[    5.675343] calling  belkin_init+0x0/0x1b @ 1
[    5.675518] initcall belkin_init+0x0/0x1b returned 0 after 55 usecs
[    5.675638] calling  ch_init+0x0/0x1b @ 1
[    5.675806] initcall ch_init+0x0/0x1b returned 0 after 48 usecs
[    5.675927] calling  ch_init+0x0/0x1b @ 1
[    5.676095] initcall ch_init+0x0/0x1b returned 0 after 49 usecs
[    5.676215] calling  cp_init+0x0/0x1b @ 1
[    5.676386] initcall cp_init+0x0/0x1b returned 0 after 50 usecs
[    5.676508] calling  dr_init+0x0/0x1b @ 1
[    5.676678] initcall dr_init+0x0/0x1b returned 0 after 50 usecs
[    5.676799] calling  ez_init+0x0/0x1b @ 1
[    5.676967] initcall ez_init+0x0/0x1b returned 0 after 50 usecs
[    5.677087] calling  gyration_init+0x0/0x1b @ 1
[    5.677259] initcall gyration_init+0x0/0x1b returned 0 after 50 usecs
[    5.677380] calling  ks_init+0x0/0x1b @ 1
[    5.677563] initcall ks_init+0x0/0x1b returned 0 after 63 usecs
[    5.677684] calling  kye_init+0x0/0x1b @ 1
[    5.677863] initcall kye_init+0x0/0x1b returned 0 after 58 usecs
[    5.677983] calling  lg_init+0x0/0x1b @ 1
[    5.678153] initcall lg_init+0x0/0x1b returned 0 after 49 usecs
[    5.678273] calling  ms_init+0x0/0x1b @ 1
[    5.678450] initcall ms_init+0x0/0x1b returned 0 after 58 usecs
[    5.678570] calling  mr_init+0x0/0x1b @ 1
[    5.678740] initcall mr_init+0x0/0x1b returned 0 after 50 usecs
[    5.678860] calling  ntrig_init+0x0/0x1b @ 1
[    5.679033] initcall ntrig_init+0x0/0x1b returned 0 after 53 usecs
[    5.679153] calling  ortek_init+0x0/0x1b @ 1
[    5.679323] initcall ortek_init+0x0/0x1b returned 0 after 51 usecs
[    5.679443] calling  pl_init+0x0/0x1b @ 1
[    5.679613] initcall pl_init+0x0/0x1b returned 0 after 51 usecs
[    5.679732] calling  pl_init+0x0/0x1b @ 1
[    5.679901] initcall pl_init+0x0/0x1b returned 0 after 51 usecs
[    5.680021] calling  samsung_init+0x0/0x1b @ 1
[    5.680231] initcall samsung_init+0x0/0x1b returned 0 after 85 usecs
[    5.680352] calling  sjoy_init+0x0/0x1b @ 1
[    5.680522] initcall sjoy_init+0x0/0x1b returned 0 after 51 usecs
[    5.680643] calling  sony_init+0x0/0x1b @ 1
[    5.680815] initcall sony_init+0x0/0x1b returned 0 after 52 usecs
[    5.680935] calling  sp_init+0x0/0x1b @ 1
[    5.681115] initcall sp_init+0x0/0x1b returned 0 after 59 usecs
[    5.681237] calling  ga_init+0x0/0x1b @ 1
[    5.681408] initcall ga_init+0x0/0x1b returned 0 after 51 usecs
[    5.681527] calling  tm_init+0x0/0x1b @ 1
[    5.681699] initcall tm_init+0x0/0x1b returned 0 after 52 usecs
[    5.681818] calling  ts_init+0x0/0x1b @ 1
[    5.681990] initcall ts_init+0x0/0x1b returned 0 after 52 usecs
[    5.682110] calling  twinhan_init+0x0/0x1b @ 1
[    5.682283] initcall twinhan_init+0x0/0x1b returned 0 after 52 usecs
[    5.682404] calling  zp_init+0x0/0x1b @ 1
[    5.682594] initcall zp_init+0x0/0x1b returned 0 after 70 usecs
[    5.682713] calling  hid_init+0x0/0x79 @ 1
[    5.682947] usbcore: registered new interface driver usbhid
[    5.683066] usbhid: USB HID core driver
[    5.683185] initcall hid_init+0x0/0x79 returned 0 after 343 usecs
[    5.683304] calling  staging_init+0x0/0x8 @ 1
[    5.683420] initcall staging_init+0x0/0x8 returned 0 after 0 usecs
[    5.683597] calling  alsa_hwdep_init+0x0/0x64 @ 1
[    5.683734] initcall alsa_hwdep_init+0x0/0x64 returned 0 after 16 usecs
[    5.683855] calling  alsa_timer_init+0x0/0x146 @ 1
[    5.684076] initcall alsa_timer_init+0x0/0x146 returned 0 after 98 usecs
[    5.684196] calling  alsa_pcm_init+0x0/0x6c @ 1
[    5.684317] initcall alsa_pcm_init+0x0/0x6c returned 0 after 1 usecs
[    5.684436] calling  snd_mem_init+0x0/0x2c @ 1
[    5.684556] initcall snd_mem_init+0x0/0x2c returned 0 after 4 usecs
[    5.684731] calling  patch_realtek_init+0x0/0x12 @ 1
[    5.684852] initcall patch_realtek_init+0x0/0x12 returned 0 after 0 usecs
[    5.684973] calling  patch_cmedia_init+0x0/0x12 @ 1
[    5.685093] initcall patch_cmedia_init+0x0/0x12 returned 0 after 0 usecs
[    5.685268] calling  patch_analog_init+0x0/0x12 @ 1
[    5.685389] initcall patch_analog_init+0x0/0x12 returned 0 after 0 usecs
[    5.685510] calling  patch_sigmatel_init+0x0/0x12 @ 1
[    5.685629] initcall patch_sigmatel_init+0x0/0x12 returned 0 after 0 usecs
[    5.685807] calling  patch_si3054_init+0x0/0x12 @ 1
[    5.685927] initcall patch_si3054_init+0x0/0x12 returned 0 after 0 usecs
[    5.686047] calling  patch_cirrus_init+0x0/0x12 @ 1
[    5.686167] initcall patch_cirrus_init+0x0/0x12 returned 0 after 0 usecs
[    5.686342] calling  patch_ca0110_init+0x0/0x12 @ 1
[    5.686463] initcall patch_ca0110_init+0x0/0x12 returned 0 after 0 usecs
[    5.686585] calling  patch_conexant_init+0x0/0x12 @ 1
[    5.686703] initcall patch_conexant_init+0x0/0x12 returned 0 after 0 usecs
[    5.686882] calling  patch_via_init+0x0/0x12 @ 1
[    5.687000] initcall patch_via_init+0x0/0x12 returned 0 after 0 usecs
[    5.687120] calling  patch_hdmi_init+0x0/0x12 @ 1
[    5.687240] initcall patch_hdmi_init+0x0/0x12 returned 0 after 0 usecs
[    5.687417] calling  alsa_card_azx_init+0x0/0x1b @ 1
[    5.687611] initcall alsa_card_azx_init+0x0/0x1b returned 0 after 72 usecs
[    5.687732] calling  alsa_sound_last_init+0x0/0x6f @ 1
[    5.687850] ALSA device list:
[    5.687963]   No soundcards found.
[    5.688079] initcall alsa_sound_last_init+0x0/0x6f returned 0 after 222 usecs
[    5.688256] calling  llc_init+0x0/0x20 @ 1
[    5.688376] initcall llc_init+0x0/0x20 returned 0 after 0 usecs
[    5.688495] calling  snap_init+0x0/0x39 @ 1
[    5.688626] initcall snap_init+0x0/0x39 returned 0 after 10 usecs
[    5.688747] calling  blackhole_module_init+0x0/0x12 @ 1
[    5.688869] initcall blackhole_module_init+0x0/0x12 returned 0 after 1 usecs
[    5.688990] calling  police_init_module+0x0/0x12 @ 1
[    5.689166] initcall police_init_module+0x0/0x12 returned 0 after 0 usecs
[    5.689289] calling  cbq_module_init+0x0/0x12 @ 1
[    5.689409] initcall cbq_module_init+0x0/0x12 returned 0 after 0 usecs
[    5.689530] calling  htb_module_init+0x0/0x12 @ 1
[    5.689705] initcall htb_module_init+0x0/0x12 returned 0 after 0 usecs
[    5.689828] calling  red_module_init+0x0/0x12 @ 1
[    5.689946] initcall red_module_init+0x0/0x12 returned 0 after 0 usecs
[    5.690070] calling  gred_module_init+0x0/0x12 @ 1
[    5.690158] initcall gred_module_init+0x0/0x12 returned 0 after 0 usecs
[    5.690158] calling  ingress_module_init+0x0/0x12 @ 1
[    5.690158] initcall ingress_module_init+0x0/0x12 returned 0 after 0 usecs
[    5.690158] calling  dsmark_module_init+0x0/0x12 @ 1
[    5.690158] initcall dsmark_module_init+0x0/0x12 returned 0 after 0 usecs
[    5.690158] calling  sfb_module_init+0x0/0x12 @ 1
[    5.690158] initcall sfb_module_init+0x0/0x12 returned 0 after 0 usecs
[    5.690158] calling  sfq_module_init+0x0/0x12 @ 1
[    5.690158] initcall sfq_module_init+0x0/0x12 returned 0 after 0 usecs
[    5.690158] calling  tbf_module_init+0x0/0x12 @ 1
[    5.690158] initcall tbf_module_init+0x0/0x12 returned 0 after 0 usecs
[    5.690158] calling  teql_init+0x0/0xf1 @ 1
[    5.692330] initcall teql_init+0x0/0xf1 returned 0 after 462 usecs
[    5.692453] calling  prio_module_init+0x0/0x12 @ 1
[    5.692575] initcall prio_module_init+0x0/0x12 returned 0 after 0 usecs
[    5.692697] calling  mqprio_module_init+0x0/0x12 @ 1
[    5.692815] initcall mqprio_module_init+0x0/0x12 returned 0 after 0 usecs
[    5.692993] calling  choke_module_init+0x0/0x12 @ 1
[    5.693113] initcall choke_module_init+0x0/0x12 returned 0 after 0 usecs
[    5.693235] calling  init_u32+0x0/0x2e @ 1
[    5.693351] u32 classifier
[    5.693519]     Actions configured
[    5.693636] initcall init_u32+0x0/0x2e returned 0 after 276 usecs
[    5.693755] calling  init_route4+0x0/0x12 @ 1
[    5.693872] initcall init_route4+0x0/0x12 returned 0 after 0 usecs
[    5.694046] calling  init_fw+0x0/0x12 @ 1
[    5.694164] initcall init_fw+0x0/0x12 returned 0 after 0 usecs
[    5.694283] calling  init_rsvp+0x0/0x12 @ 1
[    5.694400] initcall init_rsvp+0x0/0x12 returned 0 after 0 usecs
[    5.694574] calling  init_tcindex+0x0/0x12 @ 1
[    5.694692] initcall init_tcindex+0x0/0x12 returned 0 after 0 usecs
[    5.694812] calling  init_rsvp+0x0/0x12 @ 1
[    5.694928] initcall init_rsvp+0x0/0x12 returned 0 after 0 usecs
[    5.695104] calling  init_basic+0x0/0x12 @ 1
[    5.695222] initcall init_basic+0x0/0x12 returned 0 after 0 usecs
[    5.695342] calling  init_cgroup_cls+0x0/0x3c @ 1
[    5.695461] initcall init_cgroup_cls+0x0/0x3c returned 0 after 0 usecs
[    5.695638] calling  nfnetlink_init+0x0/0x27 @ 1
[    5.695756] Netfilter messages via NETLINK v0.30.
[    5.695887] initcall nfnetlink_init+0x0/0x27 returned 0 after 125 usecs
[    5.696007] calling  nfnetlink_queue_init+0x0/0xa4 @ 1
[    5.696130] initcall nfnetlink_queue_init+0x0/0xa4 returned 0 after 4 usecs
[    5.696251] calling  nfnetlink_log_init+0x0/0xd7 @ 1
[    5.696432] initcall nfnetlink_log_init+0x0/0xd7 returned 0 after 6 usecs
[    5.696556] calling  nf_conntrack_standalone_init+0x0/0x12 @ 1
[    5.696675] nf_conntrack version 0.5.0 (1137 buckets, 4548 max)
[    5.699040] initcall nf_conntrack_standalone_init+0x0/0x12 returned 0 after 2309 usecs
[    5.699302] calling  ctnetlink_init+0x0/0x76 @ 1
[    5.699420] ctnetlink v0.93: registering with nfnetlink.
[    5.699540] initcall ctnetlink_init+0x0/0x76 returned 0 after 115 usecs
[    5.699662] calling  nf_conntrack_ftp_init+0x0/0x1a4 @ 1
[    5.699856] initcall nf_conntrack_ftp_init+0x0/0x1a4 returned 0 after 17 usecs
[    5.700056] calling  nf_conntrack_h323_init+0x0/0xd4 @ 1
[    5.700192] initcall nf_conntrack_h323_init+0x0/0xd4 returned 0 after 17 usecs
[    5.700392] calling  nf_conntrack_irc_init+0x0/0x181 @ 1
[    5.700517] initcall nf_conntrack_irc_init+0x0/0x181 returned 0 after 5 usecs
[    5.700640] calling  nf_conntrack_sip_init+0x0/0x1ca @ 1
[    5.700762] initcall nf_conntrack_sip_init+0x0/0x1ca returned 0 after 1 usecs
[    5.700881] calling  xt_init+0x0/0x117 @ 1
[    5.701054] initcall xt_init+0x0/0x117 returned 0 after 1 usecs
[    5.701173] calling  tcpudp_mt_init+0x0/0x17 @ 1
[    5.701291] initcall tcpudp_mt_init+0x0/0x17 returned 0 after 0 usecs
[    5.701410] calling  mark_mt_init+0x0/0x40 @ 1
[    5.701584] initcall mark_mt_init+0x0/0x40 returned 0 after 0 usecs
[    5.701703] calling  connmark_mt_init+0x0/0x40 @ 1
[    5.701821] initcall connmark_mt_init+0x0/0x40 returned 0 after 0 usecs
[    5.701941] calling  classify_tg_init+0x0/0x17 @ 1
[    5.702113] initcall classify_tg_init+0x0/0x17 returned 0 after 0 usecs
[    5.702234] calling  dscp_tg_init+0x0/0x17 @ 1
[    5.702351] initcall dscp_tg_init+0x0/0x17 returned 0 after 0 usecs
[    5.702470] calling  hl_tg_init+0x0/0x17 @ 1
[    5.702641] initcall hl_tg_init+0x0/0x17 returned 0 after 0 usecs
[    5.702761] calling  nflog_tg_init+0x0/0x12 @ 1
[    5.702878] initcall nflog_tg_init+0x0/0x12 returned 0 after 0 usecs
[    5.702997] calling  nfqueue_tg_init+0x0/0x17 @ 1
[    5.703169] initcall nfqueue_tg_init+0x0/0x17 returned 0 after 0 usecs
[    5.703290] calling  tcpmss_tg_init+0x0/0x17 @ 1
[    5.703407] initcall tcpmss_tg_init+0x0/0x17 returned 0 after 0 usecs
[    5.703526] calling  comment_mt_init+0x0/0x12 @ 1
[    5.703698] initcall comment_mt_init+0x0/0x12 returned 0 after 0 usecs
[    5.703819] calling  connbytes_mt_init+0x0/0x12 @ 1
[    5.703938] initcall connbytes_mt_init+0x0/0x12 returned 0 after 0 usecs
[    5.704059] calling  connlimit_mt_init+0x0/0x17 @ 1
[    5.704231] initcall connlimit_mt_init+0x0/0x17 returned 0 after 0 usecs
[    5.704353] calling  conntrack_mt_init+0x0/0x17 @ 1
[    5.704473] initcall conntrack_mt_init+0x0/0x17 returned 0 after 0 usecs
[    5.704593] calling  dscp_mt_init+0x0/0x17 @ 1
[    5.704765] initcall dscp_mt_init+0x0/0x17 returned 0 after 0 usecs
[    5.704886] calling  hashlimit_mt_init+0x0/0x8c @ 1
[    5.705016] initcall hashlimit_mt_init+0x0/0x8c returned 0 after 10 usecs
[    5.705136] calling  helper_mt_init+0x0/0x12 @ 1
[    5.705310] initcall helper_mt_init+0x0/0x12 returned 0 after 0 usecs
[    5.705430] calling  hl_mt_init+0x0/0x17 @ 1
[    5.705548] initcall hl_mt_init+0x0/0x17 returned 0 after 0 usecs
[    5.705668] calling  length_mt_init+0x0/0x17 @ 1
[    5.705839] initcall length_mt_init+0x0/0x17 returned 0 after 0 usecs
[    5.705960] calling  limit_mt_init+0x0/0x12 @ 1
[    5.706076] initcall limit_mt_init+0x0/0x12 returned 0 after 0 usecs
[    5.706196] calling  mac_mt_init+0x0/0x12 @ 1
[    5.706367] initcall mac_mt_init+0x0/0x12 returned 0 after 0 usecs
[    5.706487] calling  multiport_mt_init+0x0/0x17 @ 1
[    5.706604] initcall multiport_mt_init+0x0/0x17 returned 0 after 0 usecs
[    5.706723] calling  xt_osf_init+0x0/0x8d @ 1
[    5.706894] initcall xt_osf_init+0x0/0x8d returned 0 after 0 usecs
[    5.707015] calling  owner_mt_init+0x0/0x12 @ 1
[    5.707131] initcall owner_mt_init+0x0/0x12 returned 0 after 0 usecs
[    5.707250] calling  pkttype_mt_init+0x0/0x12 @ 1
[    5.707422] initcall pkttype_mt_init+0x0/0x12 returned 0 after 0 usecs
[    5.707543] calling  quota_mt_init+0x0/0x12 @ 1
[    5.707659] initcall quota_mt_init+0x0/0x12 returned 0 after 0 usecs
[    5.707777] calling  realm_mt_init+0x0/0x12 @ 1
[    5.707948] initcall realm_mt_init+0x0/0x12 returned 0 after 0 usecs
[    5.708067] calling  recent_mt_init+0x0/0x7a @ 1
[    5.708185] initcall recent_mt_init+0x0/0x7a returned 0 after 2 usecs
[    5.708304] calling  state_mt_init+0x0/0x12 @ 1
[    5.708475] initcall state_mt_init+0x0/0x12 returned 0 after 0 usecs
[    5.708594] calling  statistic_mt_init+0x0/0x12 @ 1
[    5.708711] initcall statistic_mt_init+0x0/0x12 returned 0 after 0 usecs
[    5.708829] calling  string_mt_init+0x0/0x12 @ 1
[    5.709000] initcall string_mt_init+0x0/0x12 returned 0 after 0 usecs
[    5.709119] calling  tcpmss_mt_init+0x0/0x17 @ 1
[    5.709235] initcall tcpmss_mt_init+0x0/0x17 returned 0 after 0 usecs
[    5.709355] calling  u32_mt_init+0x0/0x12 @ 1
[    5.709526] initcall u32_mt_init+0x0/0x12 returned 0 after 0 usecs
[    5.709646] calling  sysctl_ipv4_init+0x0/0x87 @ 1
[    5.709772] initcall sysctl_ipv4_init+0x0/0x87 returned 0 after 7 usecs
[    5.709893] calling  ipip_init+0x0/0x60 @ 1
[    5.710063] IPv4 over IPv4 tunneling driver
[    5.710440] initcall ipip_init+0x0/0x60 returned 0 after 366 usecs
[    5.710563] calling  init_syncookies+0x0/0x19 @ 1
[    5.710715] initcall init_syncookies+0x0/0x19 returned 0 after 33 usecs
[    5.710836] calling  tunnel4_init+0x0/0x66 @ 1
[    5.710955] initcall tunnel4_init+0x0/0x66 returned 0 after 0 usecs
[    5.711076] calling  ipv4_netfilter_init+0x0/0x12 @ 1
[    5.711195] initcall ipv4_netfilter_init+0x0/0x12 returned 0 after 0 usecs
[    5.711372] calling  nf_conntrack_l3proto_ipv4_init+0x0/0x14b @ 1
[    5.711527] initcall nf_conntrack_l3proto_ipv4_init+0x0/0x14b returned 0 after 33 usecs
[    5.711728] calling  nf_nat_init+0x0/0x111 @ 1
[    5.711857] initcall nf_nat_init+0x0/0x111 returned 0 after 8 usecs
[    5.711977] calling  nf_defrag_init+0x0/0x17 @ 1
[    5.712097] initcall nf_defrag_init+0x0/0x17 returned 0 after 0 usecs
[    5.712273] calling  nf_nat_ftp_init+0x0/0x1f @ 1
[    5.712393] initcall nf_nat_ftp_init+0x0/0x1f returned 0 after 0 usecs
[    5.712512] calling  init+0x0/0xd7 @ 1
[    5.712631] initcall init+0x0/0xd7 returned 0 after 0 usecs
[    5.712806] calling  nf_nat_irc_init+0x0/0x1f @ 1
[    5.712925] initcall nf_nat_irc_init+0x0/0x1f returned 0 after 0 usecs
[    5.713046] calling  nf_nat_sip_init+0x0/0xa9 @ 1
[    5.713165] initcall nf_nat_sip_init+0x0/0xa9 returned 0 after 0 usecs
[    5.713342] calling  ip_tables_init+0x0/0xaa @ 1
[    5.713464] ip_tables: (C) 2000-2006 Netfilter Core Team
[    5.713584] initcall ip_tables_init+0x0/0xaa returned 0 after 121 usecs
[    5.713705] calling  iptable_filter_init+0x0/0x6f @ 1
[    5.713901] initcall iptable_filter_init+0x0/0x6f returned 0 after 22 usecs
[    5.714025] calling  iptable_mangle_init+0x0/0x51 @ 1
[    5.714155] initcall iptable_mangle_init+0x0/0x51 returned 0 after 9 usecs
[    5.714278] calling  nf_nat_standalone_init+0x0/0x59 @ 1
[    5.714407] initcall nf_nat_standalone_init+0x0/0x59 returned 0 after 8 usecs
[    5.714584] calling  ecn_mt_init+0x0/0x12 @ 1
[    5.714704] initcall ecn_mt_init+0x0/0x12 returned 0 after 0 usecs
[    5.714824] calling  ecn_tg_init+0x0/0x12 @ 1
[    5.714942] initcall ecn_tg_init+0x0/0x12 returned 0 after 0 usecs
[    5.715117] calling  log_tg_init+0x0/0x29 @ 1
[    5.715236] initcall log_tg_init+0x0/0x29 returned 0 after 0 usecs
[    5.715356] calling  masquerade_tg_init+0x0/0x39 @ 1
[    5.715476] initcall masquerade_tg_init+0x0/0x39 returned 0 after 1 usecs
[    5.715652] calling  netmap_tg_init+0x0/0x12 @ 1
[    5.715772] initcall netmap_tg_init+0x0/0x12 returned 0 after 0 usecs
[    5.715894] calling  redirect_tg_init+0x0/0x12 @ 1
[    5.716013] initcall redirect_tg_init+0x0/0x12 returned 0 after 0 usecs
[    5.716190] calling  reject_tg_init+0x0/0x12 @ 1
[    5.716308] initcall reject_tg_init+0x0/0x12 returned 0 after 0 usecs
[    5.716428] calling  ip_queue_init+0x0/0x13a @ 1
[    5.716567] initcall ip_queue_init+0x0/0x13a returned 0 after 18 usecs
[    5.716689] calling  inet_diag_init+0x0/0x72 @ 1
[    5.716816] initcall inet_diag_init+0x0/0x72 returned 0 after 6 usecs
[    5.716937] calling  tcp_diag_init+0x0/0x12 @ 1
[    5.717057] initcall tcp_diag_init+0x0/0x12 returned 0 after 0 usecs
[    5.717177] calling  bictcp_register+0x0/0x12 @ 1
[    5.717351] TCP bic registered
[    5.717468] initcall bictcp_register+0x0/0x12 returned 0 after 113 usecs
[    5.717590] calling  cubictcp_register+0x0/0x6c @ 1
[    5.717707] TCP cubic registered
[    5.717881] initcall cubictcp_register+0x0/0x6c returned 0 after 168 usecs
[    5.718004] calling  tcp_westwood_register+0x0/0x12 @ 1
[    5.718123] TCP westwood registered
[    5.718240] initcall tcp_westwood_register+0x0/0x12 returned 0 after 113 usecs
[    5.718495] calling  hybla_register+0x0/0x12 @ 1
[    5.718613] TCP hybla registered
[    5.718730] initcall hybla_register+0x0/0x12 returned 0 after 112 usecs
[    5.718850] calling  tcp_vegas_register+0x0/0x14 @ 1
[    5.719023] TCP vegas registered
[    5.719142] initcall tcp_vegas_register+0x0/0x14 returned 0 after 114 usecs
[    5.719264] calling  inet6_init+0x0/0x2ba @ 1
[    5.719438] NET: Registered protocol family 10
[    5.719973] initcall inet6_init+0x0/0x2ba returned 0 after 575 usecs
[    5.720094] calling  tunnel6_init+0x0/0x66 @ 1
[    5.720203] initcall tunnel6_init+0x0/0x66 returned 0 after 0 usecs
[    5.720203] calling  ip6_tables_init+0x0/0xaa @ 1
[    5.720203] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    5.720203] initcall ip6_tables_init+0x0/0xaa returned 0 after 174 usecs
[    5.720203] calling  ip6table_filter_init+0x0/0x6f @ 1
[    5.720890] initcall ip6table_filter_init+0x0/0x6f returned 0 after 27 usecs
[    5.721012] calling  ip6table_mangle_init+0x0/0x51 @ 1
[    5.721154] initcall ip6table_mangle_init+0x0/0x51 returned 0 after 21 usecs
[    5.721273] calling  nf_conntrack_l3proto_ipv6_init+0x0/0xfc @ 1
[    5.721398] initcall nf_conntrack_l3proto_ipv6_init+0x0/0xfc returned 0 after 4 usecs
[    5.721596] calling  nf_defrag_init+0x0/0x54 @ 1
[    5.721715] initcall nf_defrag_init+0x0/0x54 returned 0 after 3 usecs
[    5.721888] calling  log_tg6_init+0x0/0x29 @ 1
[    5.722004] initcall log_tg6_init+0x0/0x29 returned 0 after 0 usecs
[    5.722121] calling  reject_tg6_init+0x0/0x12 @ 1
[    5.722237] initcall reject_tg6_init+0x0/0x12 returned 0 after 0 usecs
[    5.722410] calling  sit_init+0x0/0x60 @ 1
[    5.722524] IPv6 over IPv4 tunneling driver
[    5.722953] initcall sit_init+0x0/0x60 returned 0 after 416 usecs
[    5.723074] calling  ip6_tunnel_init+0x0/0x8e @ 1
[    5.723441] initcall ip6_tunnel_init+0x0/0x8e returned 0 after 240 usecs
[    5.723563] calling  packet_init+0x0/0x47 @ 1
[    5.723682] NET: Registered protocol family 17
[    5.725984] initcall packet_init+0x0/0x47 returned 0 after 2246 usecs
[    5.726103] calling  br_init+0x0/0xa2 @ 1
[    5.726302] initcall br_init+0x0/0xa2 returned 0 after 24 usecs
[    5.726422] calling  init_rpcsec_gss+0x0/0x4d @ 1
[    5.726549] initcall init_rpcsec_gss+0x0/0x4d returned 0 after 8 usecs
[    5.726669] calling  vlan_proto_init+0x0/0x82 @ 1
[    5.726785] 802.1Q VLAN Support v1.8
[    5.726970] initcall vlan_proto_init+0x0/0x82 returned 0 after 179 usecs
[    5.727091] calling  init_dns_resolver+0x0/0x108 @ 1
[    5.727208] Registering the dns_resolver key type
[    5.727346] initcall init_dns_resolver+0x0/0x108 returned 0 after 132 usecs
[    5.727467] calling  mcheck_debugfs_init+0x0/0x3b @ 1
[    5.727592] initcall mcheck_debugfs_init+0x0/0x3b returned 0 after 5 usecs
[    5.727713] calling  severities_debugfs_init+0x0/0x3b @ 1
[    5.727833] initcall severities_debugfs_init+0x0/0x3b returned 0 after 1 usecs
[    5.728087] calling  hpet_insert_resource+0x0/0x23 @ 1
[    5.728207] initcall hpet_insert_resource+0x0/0x23 returned 1 after 0 usecs
[    5.728327] initcall hpet_insert_resource+0x0/0x23 returned with error code 1 
[    5.728526] calling  lapic_insert_resource+0x0/0x3f @ 1
[    5.728701] initcall lapic_insert_resource+0x0/0x3f returned 0 after 2 usecs
[    5.728822] calling  io_apic_bug_finalize+0x0/0x1b @ 1
[    5.728940] initcall io_apic_bug_finalize+0x0/0x1b returned 0 after 0 usecs
[    5.729060] calling  check_early_ioremap_leak+0x0/0x50 @ 1
[    5.729232] initcall check_early_ioremap_leak+0x0/0x50 returned 0 after 0 usecs
[    5.729431] calling  pat_memtype_list_init+0x0/0x32 @ 1
[    5.729563] initcall pat_memtype_list_init+0x0/0x32 returned 0 after 14 usecs
[    5.729684] calling  sched_init_debug+0x0/0x24 @ 1
[    5.729806] initcall sched_init_debug+0x0/0x24 returned 0 after 1 usecs
[    5.729927] calling  init_oops_id+0x0/0x31 @ 1
[    5.730046] initcall init_oops_id+0x0/0x31 returned 0 after 3 usecs
[    5.730222] calling  printk_late_init+0x0/0x50 @ 1
[    5.730342] initcall printk_late_init+0x0/0x50 returned 0 after 1 usecs
[    5.730461] calling  pm_qos_power_init+0x0/0xca @ 1
[    5.730899] initcall pm_qos_power_init+0x0/0xca returned 0 after 310 usecs
[    5.731020] calling  alarmtimer_init_late+0x0/0x73 @ 1
[    5.731143] initcall alarmtimer_init_late+0x0/0x73 returned 0 after 2 usecs
[    5.731263] calling  clear_boot_tracer+0x0/0x2d @ 1
[    5.731379] initcall clear_boot_tracer+0x0/0x2d returned 0 after 0 usecs
[    5.731555] calling  max_swapfiles_check+0x0/0x8 @ 1
[    5.731675] initcall max_swapfiles_check+0x0/0x8 returned 0 after 0 usecs
[    5.731798] calling  set_recommended_min_free_kbytes+0x0/0x82 @ 1
[    5.731919] initcall set_recommended_min_free_kbytes+0x0/0x82 returned 0 after 0 usecs
[    5.732176] calling  random32_reseed+0x0/0xb3 @ 1
[    5.732303] initcall random32_reseed+0x0/0xb3 returned 0 after 5 usecs
[    5.732424] calling  pci_resource_alignment_sysfs_init+0x0/0x19 @ 1
[    5.732548] initcall pci_resource_alignment_sysfs_init+0x0/0x19 returned 0 after 2 usecs
[    5.732804] calling  pci_sysfs_init+0x0/0x51 @ 1
[    5.733237] initcall pci_sysfs_init+0x0/0x51 returned 0 after 305 usecs
[    5.733358] calling  boot_wait_for_devices+0x0/0x30 @ 1
[    5.733478] initcall boot_wait_for_devices+0x0/0x30 returned 0 after 1 usecs
[    5.733600] calling  seqgen_init+0x0/0xf @ 1
[    5.733729] initcall seqgen_init+0x0/0xf returned 0 after 11 usecs
[    5.733906] calling  scsi_complete_async_scans+0x0/0x11b @ 1
[    5.734025] initcall scsi_complete_async_scans+0x0/0x11b returned 0 after 0 usecs
[    5.734224] calling  rtc_hctosys+0x0/0x10d @ 1
[    5.734395] rtc_cmos 00:05: setting system clock to 2011-06-14 00:04:04 UTC (1308009844)
[    5.734652] initcall rtc_hctosys+0x0/0x10d returned 0 after 304 usecs
[    5.734774] calling  powernowk8_init+0x0/0x1bf @ 1
[    5.734895] powernow-k8: Found 1 AMD Athlon(tm) 64 Processor 3700+ (1 cpu cores) (version 2.20.00)
[    5.742439] powernow-k8: fid 0x2 (1000 MHz), vid 0x12
[    5.742559] powernow-k8: fid 0xa (1800 MHz), vid 0xa
[    5.742676] powernow-k8: fid 0xc (2000 MHz), vid 0x8
[    5.742793] powernow-k8: fid 0xe (2200 MHz), vid 0x8
[    5.742930] last_index set to -1 in cpufreq_stats_create_table!
[    5.743108] Marking TSC unstable due to cpufreq changes
[    5.743455] powernow-k8: fid trans failed, fid 0xa, curr 0x0
[    5.743573] cpufreq_stats_update: cpu=0 
[    5.743611]  max_state=4 last_index=0
[    5.743834] powernow-k8: transition frequency failed
[    5.744317] powernow-k8: fid trans failed, fid 0xa, curr 0x0
[    5.744435] cpufreq_stats_update: cpu=0 
[    5.744473]  max_state=4 last_index=0
[    5.744695] powernow-k8: transition frequency failed
[    5.745215] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input2
[    5.745503] initcall powernowk8_init+0x0/0x1bf returned 0 after 10361 usecs
[    5.745627] calling  acpi_cpufreq_init+0x0/0xc1 @ 1
[    5.745753] initcall acpi_cpufreq_init+0x0/0xc1 returned -16 after 6 usecs
[    5.745874] initcall acpi_cpufreq_init+0x0/0xc1 returned with error code -16 
[    5.745994] calling  memmap_init+0x0/0x34 @ 1
[    5.746291] initcall memmap_init+0x0/0x34 returned 0 after 35 usecs
[    5.746413] calling  pci_mmcfg_late_insert_resources+0x0/0x5e @ 1
[    5.746535] initcall pci_mmcfg_late_insert_resources+0x0/0x5e returned 1 after 0 usecs
[    5.746735] initcall pci_mmcfg_late_insert_resources+0x0/0x5e returned with error code 1 
[    5.746934] calling  tcp_congestion_default+0x0/0x12 @ 1
[    5.747195] initcall tcp_congestion_default+0x0/0x12 returned 0 after 0 usecs
[    5.747317] calling  ip_auto_config+0x0/0xd7b @ 1
[    5.747439] initcall ip_auto_config+0x0/0xd7b returned 0 after 5 usecs
[    5.747559] calling  initialize_hashrnd+0x0/0x19 @ 1
[    5.747824] initcall initialize_hashrnd+0x0/0x19 returned 0 after 2 usecs
[    5.748026] async_waiting @ 1
[    5.748142] async_continuing @ 1 after 0 usec
[    5.748266] md: Waiting for all devices to be available before autodetect
[    5.748384] md: If you don't use raid, use raid=noautodetect
[    5.748504] async_waiting @ 1
[    5.748763] async_continuing @ 1 after 0 usec
[    5.749117] md: Autodetecting RAID arrays.
[    5.889913] md: Scanned 8 and added 8 devices.
[    5.890030] md: autorun ...
[    5.890145] md: considering sdb5 ...
[    5.890280] md:  adding sdb5 ...
[    5.890398] md: sdb3 has different UUID to sdb5
[    5.890518] md: sdb2 has different UUID to sdb5
[    5.890635] md: sdb1 has different UUID to sdb5
[    5.890755] md:  adding sda5 ...
[    5.891018] md: sda3 has different UUID to sdb5
[    5.891135] md: sda2 has different UUID to sdb5
[    5.891251] md: sda1 has different UUID to sdb5
[    5.891576] md: created md3
[    5.891695] md: bind<sda5>
[    5.891817] md: bind<sdb5>
[    5.891936] md: running: <sdb5><sda5>
[    5.892386] bio: create slab <bio-1> at 1
[    5.892646] md/raid1:md3: active with 2 out of 2 mirrors
[    5.892794] md3: detected capacity change from 0 to 309644754944
[    5.892975] md: considering sdb3 ...
[    5.893097] md:  adding sdb3 ...
[    5.893215] md: sdb2 has different UUID to sdb3
[    5.893333] md: sdb1 has different UUID to sdb3
[    5.893453] md:  adding sda3 ...
[    5.893713] md: sda2 has different UUID to sdb3
[    5.893833] md: sda1 has different UUID to sdb3
[    5.894175] md: created md2
[    5.894290] md: bind<sda3>
[    5.894422] md: bind<sdb3>
[    5.894543] md: running: <sdb3><sda3>
[    5.895100] md/raid1:md2: active with 2 out of 2 mirrors
[    5.895242] md2: detected capacity change from 0 to 7999520768
[    5.895417] md: considering sdb2 ...
[    5.895538] md:  adding sdb2 ...
[    5.895657] md: sdb1 has different UUID to sdb2
[    5.895777] md:  adding sda2 ...
[    5.895893] md: sda1 has different UUID to sdb2
[    5.896350] md: created md1
[    5.896467] md: bind<sda2>
[    5.896588] md: bind<sdb2>
[    5.896707] md: running: <sdb2><sda2>
[    5.897266] md/raid1:md1: active with 2 out of 2 mirrors
[    5.897408] md1: detected capacity change from 0 to 271319040
[    5.897584] md: considering sdb1 ...
[    5.897706] md:  adding sdb1 ...
[    5.897825] md:  adding sda1 ...
[    5.897945] md: created md0
[    5.898060] md: bind<sda1>
[    5.898179] md: bind<sdb1>
[    5.898298] md: running: <sdb1><sda1>
[    5.898870] md/raid1:md0: active with 2 out of 2 mirrors
[    5.899009] md0: detected capacity change from 0 to 2152923136
[    5.899184] md: ... autorun DONE.
[    5.924550]  md2: unknown partition table
[    5.925419] EXT3-fs (md2): recovery required on readonly filesystem
[    5.925539] EXT3-fs (md2): write access will be enabled during recovery
[    5.932059] EXT3-fs: barriers not enabled
[    5.998525] kjournald starting.  Commit interval 5 seconds
[    5.998685] EXT3-fs (md2): recovery complete
[    5.999503] EXT3-fs (md2): mounted filesystem with writeback data mode
[    5.999640] VFS: Mounted root (ext3 filesystem) readonly on device 9:2.
[    6.023713] devtmpfs: mounted
[    6.023836] async_waiting @ 1
[    6.023951] async_continuing @ 1 after 0 usec
[    6.024384] Freeing unused kernel memory: 576k freed
[    6.024817] Write protecting the kernel read-only data: 10240k
[    6.031696] Freeing unused kernel memory: 4k freed
[    6.032397] Freeing unused kernel memory: 964k freed
[    6.389662] /etc/rcS.d/S01mountkernfs.sh start
[    6.569431] splash_progress 2
[    6.572049] /etc/rcS.d/S02udev start
[    6.721309] udev[825]: starting version 164
[    7.493847]  md1: unknown partition table
[    7.500638]  md0: unknown partition table
[    7.510452]  md3: unknown partition table
[    7.890275] splash_progress 4
[    7.890646] /etc/rcS.d/S03mdadm-raid start
[    7.921170] splash_progress 6
[    7.921357] /etc/rcS.d/S03mountdevsubfs.sh start
[    7.945936] splash_progress 8
[    7.946300] /etc/rcS.d/S04bootlogd start
[    7.975940] splash_progress 11
[    7.976289] /etc/rcS.d/S05keyboard-setup start
[    8.179187] splash_progress 13
[    8.179595] /etc/rcS.d/S06hostname.sh start
[    8.193791] splash_progress 15
[    8.193984] /etc/rcS.d/S06hwclockfirst.sh start
[    8.197644] splash_progress 17
[    8.197830] /etc/rcS.d/S06lvm2 start
[    8.630873] splash_progress 19
[    8.631231] /etc/rcS.d/S07checkroot.sh start
[    8.668326] Adding 2102460k swap on /dev/md0.  Priority:-1 extents:1 across:2102460k 
[    8.689279] EXT3-fs (md2): using internal journal
[    8.718190] splash_progress 22
[    8.718634] /etc/rcS.d/S08hwclock.sh start
[    8.722445] splash_progress 24
[    8.722636] /etc/rcS.d/S08ifupdown-clean start
[    8.751396] splash_progress 26
[    8.751588] /etc/rcS.d/S08module-init-tools start
[    8.772291] splash_progress 28
[    8.772481] /etc/rcS.d/S08mtab.sh start
[    8.903534] splash_progress 30
[    8.903914] /etc/rcS.d/S09checkfs.sh start
[    8.993725] splash_progress 33
[    8.994107] /etc/rcS.d/S10ifupdown start
[    9.012641] splash_progress 35
[    9.012832] /etc/rcS.d/S10mountall.sh start
[    9.142456] EXT3-fs: barriers not enabled
[    9.150441] kjournald starting.  Commit interval 5 seconds
[    9.150577] EXT3-fs (md1): warning: maximal mount count reached, running e2fsck is recommended
[    9.173004] EXT3-fs (md1): using internal journal
[    9.173124] EXT3-fs (md1): recovery complete
[    9.173245] EXT3-fs (md1): mounted filesystem with writeback data mode
[    9.273359] splash_progress 37
[    9.273709] /etc/rcS.d/S11mountall-bootclean.sh start
[    9.346975] splash_progress 39
[    9.347320] /etc/rcS.d/S12mountoverflowtmp start
[    9.366766] splash_progress 41
[    9.367202] /etc/rcS.d/S13networking start
[    9.375051] Configuring network interfaces
[   10.102338] netconsole: network logging stopped on interface eth0 as it is joining a master device
[   10.102579] device eth0 entered promiscuous mode
[   10.129521] br0: port 1(eth0) entering forwarding state
[   10.129648] br0: port 1(eth0) entering forwarding state
[   11.120061] br0: port 1(eth0) entering forwarding state
[   11.354514] network interfaces configured
[   11.355019] splash_progress 44
[   11.355182] /etc/rcS.d/S13procps start
[   11.394428] splash_progress 46
[   11.394593] /etc/rcS.d/S13udev-mtab start
[   11.407610] splash_progress 48
[   11.407782] /etc/rcS.d/S13urandom start
[   11.455954] splash_progress 50
[   11.456291] /etc/rcS.d/S14mountnfs.sh start
[   11.465652] splash_progress 52
[   11.465967] /etc/rcS.d/S15mountnfs-bootclean.sh start
[   11.507086] splash_progress 55
[   11.507397] /etc/rcS.d/S16kbd start
[   11.629998] splash_progress 57
[   11.630384] /etc/rcS.d/S17console-setup start
[   11.875413] splash_progress 59
[   11.929333] /etc/rcS.d/S18bootmisc.sh start
[   11.962891] splash_progress 61
[   11.963067] /etc/rcS.d/S18screen-cleanup start
[   12.002976] splash_progress 63
[   12.003310] /etc/rcS.d/S19stop-bootlogd-single start
[   12.008616] splash_progress 66
[   12.027549] /etc/rc2.d/S01rsyslog start
[   12.235453] splash_progress 67
[   12.235621] /etc/rc2.d/S01sudo start
[   12.276384] splash_progress 69
[   12.276554] /etc/rc2.d/S01xend start
[   12.418770] XENBUS: Unable to read cpu state
[   15.817960] splash_progress 71
[   15.818496] /etc/rc2.d/S02acpid start
[   15.860059] eth0: no IPv6 routers present
[   15.907526] splash_progress 73
[   15.907693] /etc/rc2.d/S02bind9 start
[   16.305255] splash_progress 75
[   16.305421] /etc/rc2.d/S02loadcpufreq start
[   16.393566] splash_progress 77
[   16.393731] /etc/rc2.d/S02mdadm start
[   16.428486] splash_progress 78
[   16.428653] /etc/rc2.d/S02ntp start
[   16.542324] splash_progress 80
[   16.542491] /etc/rc2.d/S02smartmontools start
[   16.561341] splash_progress 82
[   16.561507] /etc/rc2.d/S02ssh start
[   16.723889] sshd (1747): /proc/1747/oom_adj is deprecated, please use /proc/1747/oom_score_adj instead.
[   16.740918] splash_progress 84
[   16.741085] /etc/rc2.d/S02xendomains start
[   17.897128] splash_progress 86
[   17.897587] /etc/rc2.d/S03bootlogs start
[   18.090151] splash_progress 88
[   18.090327] /etc/rc2.d/S03cpufrequtils start
[   18.143342] powernow-k8: fid trans failed, fid 0x2, curr 0x0
[   18.143543] cpufreq_stats_update: cpu=0 
[   18.143578]  max_state=4 last_index=0
[   18.143796] powernow-k8: transition frequency failed
[   18.144973] splash_progress 89
[   18.145136] /etc/rc2.d/S03cron start
[   18.363744] splash_progress 91
[   18.363909] /etc/rc2.d/S03rsync start
[   18.371345] splash_progress 93
[   18.371722] /etc/rc2.d/S04rc.local start
[   18.389909] splash_progress 95
[   18.390299] /etc/rc2.d/S04rmnologin start
[   18.401564] splash_progress 97
[   18.401738] /etc/rc2.d/S04stop-bootlogd start
[   19.440417] powernow-k8: fid trans failed, fid 0x2, curr 0x0
[   19.442724] cpufreq_stats_update: cpu=0 
[   19.442759]  max_state=4 last_index=0
[   19.442978] powernow-k8: transition frequency failed
[   19.511011] splash_progress 99

-- 
Tobias						PGP: http://8ef7ddba.uguu.de
