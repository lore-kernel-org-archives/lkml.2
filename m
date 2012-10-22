Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755057Ab2JVPnF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 11:43:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46265 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750913Ab2JVPnC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 11:43:02 -0400
Date: Mon, 22 Oct 2012 17:42:58 +0200
From: Jan Kara <jack@suse.cz>
To: Fabio Coatti <fabio.coatti@gmail.com>
Cc: Jan Kara <jack@suse.cz>, NeilBrown <neilb@suse.de>,
        "Myklebust, Trond" <Trond.Myklebust@netapp.com>,
        Paul Bolle <pebolle@tiscali.nl>, linux-kernel@vger.kernel.org,
        Jeff Layton <jlayton@redhat.com>
Subject: Re: ext3 issue on 3.6.1
Message-ID: <20121022154258.GB9438@quack.suse.cz>
References: <CADpTngUPcX71qjE2QKhYqgDg7tZoz+pu8A6nE9DT-zbFKWGx1g@mail.gmail.com>
 <20121018212357.GA17646@quack.suse.cz>
 <1350596425.1366.15.camel@x61.thuisdomein>
 <20121018220809.GD17646@quack.suse.cz>
 <20121019124454.316ecfac@notabene.brown>
 <CADpTngX=6vWV1fv8x-g8ufKTb3gW2=phPZBHZJHATEcqqjwtYg@mail.gmail.com>
 <CADpTngVnJwmu-E3wJwUaK2CKGBsRoJphRNtDPAO9AHyOnnfeRQ@mail.gmail.com>
 <20121022134541.GA9438@quack.suse.cz>
 <CADpTngX9YNq6Own1gvrHnwizUfG0KfjRuXL2F38n2C+CnOTpDA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="k1lZvvs/B4yU6o8G"
Content-Disposition: inline
In-Reply-To: <CADpTngX9YNq6Own1gvrHnwizUfG0KfjRuXL2F38n2C+CnOTpDA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--k1lZvvs/B4yU6o8G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

> Uhu, my fault, I was sure to have answered to your request, sorry.
> So yes, we have an ext3 R/O partition mounted on that machine. The
> 3.6.3, with patch applied, dmesg is here:
  Interesting. You seem to be using data=journal on R/O partition, don't
you? Can you also attach /proc/mounts?

  Also please try running a kernel with the attached patch and report the
warning. Thanks!

									Honza
> 
> [    0.000000] Linux version 3.6.3-p (root@opus47) (gcc version 4.4.5
> (Debian 4.4.5-8) ) #1 SMP Mon Oct 22 11:32:45 CEST 2012
> [    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-3.6.3 root=/dev/sda2 ro
> [    0.000000] KERNEL supported cpus:
> [    0.000000]   AMD AuthenticAMD
> [    0.000000] e820: BIOS-provided physical RAM map:
> [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009efff] usable
> [    0.000000] BIOS-e820: [mem 0x000000000009f000-0x000000000009ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000bde1bfff] usable
> [    0.000000] BIOS-e820: [mem 0x00000000bde1c000-0x00000000bde4bfff] ACPI data
> [    0.000000] BIOS-e820: [mem 0x00000000bde4c000-0x00000000bde4cfff] usable
> [    0.000000] BIOS-e820: [mem 0x00000000bde4d000-0x00000000cfffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fee0ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000ff800000-0x00000000ffffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000043fffefff] usable
> [    0.000000] NX (Execute Disable) protection: active
> [    0.000000] DMI 2.7 present.
> [    0.000000] DMI: HP ProLiant BL465c G7, BIOS A19 05/08/2012
> [    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
> [    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
> [    0.000000] No AGP bridge found
> [    0.000000] e820: last_pfn = 0x43ffff max_arch_pfn = 0x400000000
> [    0.000000] MTRR default type: uncachable
> [    0.000000] MTRR fixed ranges enabled:
> [    0.000000]   00000-9FFFF write-back
> [    0.000000]   A0000-BFFFF uncachable
> [    0.000000]   C0000-FFFFF write-back
> [    0.000000] MTRR variable ranges enabled:
> [    0.000000]   0 base 000000000000 mask FFFF80000000 write-back
> [    0.000000]   1 base 000080000000 mask FFFFC0000000 write-back
> [    0.000000]   2 disabled
> [    0.000000]   3 disabled
> [    0.000000]   4 disabled
> [    0.000000]   5 disabled
> [    0.000000]   6 base 0000FFF80000 mask FFFFFFFC0000 write-protect
> [    0.000000]   7 base 0000FFFC0000 mask FFFFFFFF0000 write-protect
> [    0.000000] TOM2: 0000000440000000 aka 17408M
> [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
> [    0.000000] e820: last_pfn = 0xbde4d max_arch_pfn = 0x400000000
> [    0.000000] found SMP MP-table at [mem 0x000f4f60-0x000f4f6f]
> mapped at [ffff8800000f4f60]
> [    0.000000] initial memory mapped: [mem 0x00000000-0x1fffffff]
> [    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
> [    0.000000] Using GB pages for direct mapping
> [    0.000000] init_memory_mapping: [mem 0x00000000-0xbde4cfff]
> [    0.000000]  [mem 0x00000000-0x7fffffff] page 1G
> [    0.000000]  [mem 0x80000000-0xbddfffff] page 2M
> [    0.000000]  [mem 0xbde00000-0xbde4cfff] page 4k
> [    0.000000] kernel direct mapping tables up to 0xbde4cfff @ [mem
> 0x1fbfd000-0x1fffffff]
> [    0.000000] init_memory_mapping: [mem 0x100000000-0x43fffefff]
> [    0.000000]  [mem 0x100000000-0x3ffffffff] page 1G
> [    0.000000]  [mem 0x400000000-0x43fdfffff] page 2M
> [    0.000000]  [mem 0x43fe00000-0x43fffefff] page 4k
> [    0.000000] kernel direct mapping tables up to 0x43fffefff @ [mem
> 0xbde19000-0xbde1bfff]
> [    0.000000] ACPI: RSDP 00000000000f4ee0 00024 (v02 HP    )
> [    0.000000] ACPI: XSDT 00000000bde1d3c0 0009C (v01 HP     ProLiant
> 00000002   <D2>? 0000162E)
> [    0.000000] ACPI: FACP 00000000bde1d4c0 000F4 (v03 HP     ProLiant
> 00000002   <D2>? 0000162E)
> [    0.000000] ACPI: DSDT 00000000bde1d5c0 0CEFD (v01 HP         DSDT
> 00000001 INTL 20061109)
> [    0.000000] ACPI: FACS 00000000bde1c140 00040
> [    0.000000] ACPI: SPCR 00000000bde1c180 00050 (v01 HP     SPCRRBSU
> 00000001   <D2>? 0000162E)
> [    0.000000] ACPI: MCFG 00000000bde1c200 0003C (v01 HP     ProLiant
> 00000001      00000000)
> [    0.000000] ACPI: HPET 00000000bde1c240 00038 (v01 HP     ProLiant
> 00000002   <D2>? 0000162E)
> [    0.000000] ACPI: SPMI 00000000bde1c280 00040 (v05 HP     ProLiant
> 00000001   <D2>? 0000162E)
> [    0.000000] ACPI: ERST 00000000bde1c2c0 001D0 (v01 HP     ProLiant
> 00000001   <D2>? 0000162E)
> [    0.000000] ACPI: APIC 00000000bde1c4c0 000DE (v01 HP     ProLiant
> 00000002      00000000)
> [    0.000000] ACPI: SRAT 00000000bde1c7c0 001D0 (v02 AMD    AGESA
> 00000001 AMD  00000001)
> [    0.000000] ACPI: FFFF 00000000bde1cfc0 00176 (v01 HP     ProLiant
> 00000001   <D2>? 0000162E)
> [    0.000000] ACPI: BERT 00000000bde1d140 00030 (v01 HP     ProLiant
> 00000001   <D2>? 0000162E)
> [    0.000000] ACPI: HEST 00000000bde1d180 0018C (v01 HP     ProLiant
> 00000001   <D2>? 0000162E)
> [    0.000000] ACPI: FFFF 00000000bde1d340 00064 (v02 HP     ProLiant
> 00000002   <D2>? 0000162E)
> [    0.000000] ACPI: SSDT 00000000bde2a4c0 00125 (v03     HP  CRSPCI0
> 00000002   HP 00000001)
> [    0.000000] ACPI: SSDT 00000000bde2a600 00377 (v01     HP     pmab
> 00000001 INTL 20090625)
> [    0.000000] ACPI: SSDT 00000000bde2a980 02914 (v02 AMD    POWERNOW
> 00000001 AMD  00000001)
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] SRAT: PXM 0 -> APIC 0x10 -> Node 0
> [    0.000000] SRAT: PXM 0 -> APIC 0x11 -> Node 0
> [    0.000000] SRAT: PXM 0 -> APIC 0x12 -> Node 0
> [    0.000000] SRAT: PXM 0 -> APIC 0x13 -> Node 0
> [    0.000000] SRAT: PXM 1 -> APIC 0x14 -> Node 1
> [    0.000000] SRAT: PXM 1 -> APIC 0x15 -> Node 1
> [    0.000000] SRAT: PXM 1 -> APIC 0x16 -> Node 1
> [    0.000000] SRAT: PXM 1 -> APIC 0x17 -> Node 1
> [    0.000000] SRAT: PXM 2 -> APIC 0x24 -> Node 2
> [    0.000000] SRAT: PXM 2 -> APIC 0x25 -> Node 2
> [    0.000000] SRAT: PXM 2 -> APIC 0x26 -> Node 2
> [    0.000000] SRAT: PXM 2 -> APIC 0x27 -> Node 2
> [    0.000000] SRAT: PXM 3 -> APIC 0x20 -> Node 3
> [    0.000000] SRAT: PXM 3 -> APIC 0x21 -> Node 3
> [    0.000000] SRAT: PXM 3 -> APIC 0x22 -> Node 3
> [    0.000000] SRAT: PXM 3 -> APIC 0x23 -> Node 3
> [    0.000000] SRAT: Node 0 PXM 0 [mem 0x00000000-0x0009ffff]
> [    0.000000] SRAT: Node 0 PXM 0 [mem 0x00100000-0xbfffffff]
> [    0.000000] SRAT: Node 0 PXM 0 [mem 0x100000000-0x23fffffff]
> [    0.000000] SRAT: Node 1 PXM 1 [mem 0x240000000-0x43fffffff]
> [    0.000000] NUMA: Node 0 [mem 0x00000000-0x0009ffff] + [mem
> 0x00100000-0xbfffffff] -> [mem 0x00000000-0xbfffffff]
> [    0.000000] NUMA: Node 0 [mem 0x00000000-0xbfffffff] + [mem
> 0x100000000-0x23fffffff] -> [mem 0x00000000-0x23fffffff]
> [    0.000000] Initmem setup node 0 [mem 0x00000000-0x23fffffff]
> [    0.000000]   NODE_DATA [mem 0x23fffc000-0x23fffffff]
> [    0.000000] Initmem setup node 1 [mem 0x240000000-0x43fffefff]
> [    0.000000]   NODE_DATA [mem 0x43fffb000-0x43fffefff]
> [    0.000000]  [ffffea0000000000-ffffea0008ffffff] PMD ->
> [ffff880237e00000-ffff88023fdfffff] on node 0
> [    0.000000]  [ffffea0009000000-ffffea0010ffffff] PMD ->
> [ffff880437600000-ffff88043f5fffff] on node 1
> [    0.000000] Zone ranges:
> [    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
> [    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
> [    0.000000]   Normal   [mem 0x100000000-0x43fffefff]
> [    0.000000] Movable zone start for each node
> [    0.000000] Early memory node ranges
> [    0.000000]   node   0: [mem 0x00010000-0x0009efff]
> [    0.000000]   node   0: [mem 0x00100000-0xbde1bfff]
> [    0.000000]   node   0: [mem 0xbde4c000-0xbde4cfff]
> [    0.000000]   node   0: [mem 0x100000000-0x23fffffff]
> [    0.000000]   node   1: [mem 0x240000000-0x43fffefff]
> [    0.000000] On node 0 totalpages: 2088364
> [    0.000000]   DMA zone: 64 pages used for memmap
> [    0.000000]   DMA zone: 6 pages reserved
> [    0.000000]   DMA zone: 3913 pages, LIFO batch:0
> [    0.000000]   DMA32 zone: 16320 pages used for memmap
> [    0.000000]   DMA32 zone: 757341 pages, LIFO batch:31
> [    0.000000]   Normal zone: 20480 pages used for memmap
> [    0.000000]   Normal zone: 1290240 pages, LIFO batch:31
> [    0.000000] On node 1 totalpages: 2097151
> [    0.000000]   Normal zone: 32768 pages used for memmap
> [    0.000000]   Normal zone: 2064383 pages, LIFO batch:31
> [    0.000000] ACPI: PM-Timer IO Port: 0x920
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x10] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x20] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x11] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x21] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x12] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x22] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x13] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x23] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x14] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x24] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x15] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x25] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x16] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x26] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x17] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x27] enabled)
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
> [    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
> [    0.000000] IOAPIC[0]: apic_id 8, version 33, address 0xfec00000, GSI 0-23
> [    0.000000] ACPI: IOAPIC (id[0x09] address[0xefffc000] gsi_base[24])
> [    0.000000] IOAPIC[1]: apic_id 9, version 33, address 0xefffc000, GSI 24-55
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
> [    0.000000] ACPI: IRQ0 used by override.
> [    0.000000] ACPI: IRQ2 used by override.
> [    0.000000] ACPI: IRQ9 used by override.
> [    0.000000] Using ACPI (MADT) for SMP configuration information
> [    0.000000] ACPI: HPET id: 0x1166a201 base: 0xfed00000
> [    0.000000] smpboot: Allowing 16 CPUs, 0 hotplug CPUs
> [    0.000000] nr_irqs_gsi: 72
> [    0.000000] e820: [mem 0xd0000000-0xfebfffff] available for PCI devices
> [    0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:32
> nr_cpu_ids:16 nr_node_ids:4
> [    0.000000] PERCPU: Embedded 23 pages/cpu @ffff880237800000 s72768
> r0 d21440 u524288
> [    0.000000] pcpu-alloc: s72768 r0 d21440 u524288 alloc=1*2097152
> [    0.000000] pcpu-alloc: [0] 00 01 02 03 [0] 04 05 06 07
> [    0.000000] pcpu-alloc: [0] 09 11 13 15 [1] 08 10 12 14
> [    0.000000] Built 2 zonelists in Zone order, mobility grouping on.
> Total pages: 4115877
> [    0.000000] Policy zone: Normal
> [    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.6.3
> root=/dev/sda2 ro
> [    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
> [    0.000000] __ex_table already sorted, skipping sort
> [    0.000000] Checking aperture...
> [    0.000000] No AGP bridge found
> [    0.000000] Node 0: aperture @ b4000000 size 32 MB
> [    0.000000] Aperture pointing to e820 RAM. Ignoring.
> [    0.000000] Your BIOS doesn't leave a aperture memory hole
> [    0.000000] Please enable the IOMMU option in the BIOS setup
> [    0.000000] This costs you 64 MB of RAM
> [    0.000000] Mapping aperture over 65536 KB of RAM @ b4000000
> [    0.000000] Memory: 16332512k/17825788k available (6185k kernel
> code, 1083728k absent, 409548k reserved, 6662k data, 628k init)
> [    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0,
> CPUs=16, Nodes=4
> [    0.000000] Hierarchical RCU implementation.
> [    0.000000]  RCU restricting CPUs from NR_CPUS=32 to nr_cpu_ids=16.
> [    0.000000] NR_IRQS:4352 nr_irqs:1352 16
> [    0.000000] Extended CMOS year: 2000
> [    0.000000] spurious 8259A interrupt: IRQ7.
> [    0.000000] Console: colour VGA+ 80x25
> [    0.000000] console [tty0] enabled
> [    0.000000] hpet clockevent registered
> [    0.003333] tsc: Fast TSC calibration using PIT
> [    0.006666] tsc: Detected 2300.095 MHz processor
> [    0.000004] Calibrating delay loop (skipped), value calculated
> using timer frequency.. 4602.86 BogoMIPS (lpj=7666983)
> [    0.000183] pid_max: default: 32768 minimum: 301
> [    0.001307] Dentry cache hash table entries: 2097152 (order: 12,
> 16777216 bytes)
> [    0.006873] Inode-cache hash table entries: 1048576 (order: 11,
> 8388608 bytes)
> [    0.009449] Mount-cache hash table entries: 256
> [    0.009770] tseg: 00be000000
> [    0.009772] CPU: Physical Processor ID: 0
> [    0.009867] CPU: Processor Core ID: 0
> [    0.009951] mce: CPU supports 6 MCE banks
> [    0.010039] LVT offset 0 assigned for vector 0xf9
> [    0.010129] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
> [    0.010129] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
> [    0.010129] tlb_flushall_shift is 0xffffffff
> [    0.010399] Freeing SMP alternatives: 28k freed
> [    0.010495] ACPI: Core revision 20120711
> [    0.016352] Switched APIC routing to physical flat.
> [    0.017026] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> [    0.050106] smpboot: CPU0: AMD Opteron(tm) Processor 6134 stepping 01
> [    0.156442] Performance Events: Broken BIOS detected, complain to
> your hardware vendor.
> [    0.156612] [Firmware Bug]: the BIOS has corrupted hw-PMU resources
> (MSR c0010000 is 430076)
> [    0.156735] AMD PMU driver.
> [    0.156816] ... version:                0
> [    0.156900] ... bit width:              48
> [    0.156985] ... generic registers:      4
> [    0.157069] ... value mask:             0000ffffffffffff
> [    0.157158] ... max period:             00007fffffffffff
> [    0.157246] ... fixed-purpose events:   0
> [    0.157330] ... event mask:             000000000000000f
> [    0.157531] MCE: In-kernel MCE decoding enabled.
> [    0.157730] smpboot: Booting Node   0, Processors  #1 #2 #3 #4 #5 #6 #7 OK
> [    0.349427] smpboot: Booting Node   1, Processors  #8 OK
> [    0.362818] smpboot: Booting Node   0, Processors  #9 OK
> [    0.376211] smpboot: Booting Node   1, Processors  #10 OK
> [    0.389594] smpboot: Booting Node   0, Processors  #11 OK
> [    0.402990] smpboot: Booting Node   1, Processors  #12 OK
> [    0.424676] smpboot: Booting Node   0, Processors  #13 OK
> [    0.438062] smpboot: Booting Node   1, Processors  #14 OK
> [    0.451440] smpboot: Booting Node   0, Processors  #15 OK
> [    0.464734] Brought up 16 CPUs
> [    0.464818] smpboot: Total of 16 processors activated (73631.86 BogoMIPS)
> [    0.485579] devtmpfs: initialized
> [    0.485892] NET: Registered protocol family 16
> [    0.486479] node 0 link 3: io port [1000, ffff]
> [    0.486482] TOM: 00000000c0000000 aka 3072M
> [    0.486567] Fam 10h mmconf [mem 0xc0000000-0xcfffffff]
> [    0.486570] node 0 link 3: mmio [eff00000, fdffffff]
> [    0.486573] node 0 link 3: mmio [c0000000, cff0ffff] ==> none
> [    0.486575] TOM2: 0000000440000000 aka 17408M
> [    0.486662] bus: [bus 00-3f] on node 0 link 3
> [    0.486664] bus: 00 [io  0x0000-0xffff]
> [    0.486665] bus: 00 [mem 0xd0000000-0xffffffff]
> [    0.486666] bus: 00 [mem 0x440000000-0xfcffffffff]
> [    0.486858] ACPI FADT declares the system doesn't support PCIe
> ASPM, so disable it
> [    0.486980] ACPI: bus type pci registered
> [    0.487187] dca service started, version 1.12.1
> [    0.487321] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem
> 0xc0000000-0xcfffffff] (base 0xc0000000)
> [    0.487449] PCI: MMCONFIG at [mem 0xc0000000-0xcfffffff] reserved in E820
> [    0.504518] PCI: Using configuration type 1 for base access
> [    0.514881] bio: create slab <bio-0> at 0
> [    0.515043] ACPI: Added _OSI(Module Device)
> [    0.515128] ACPI: Added _OSI(Processor Device)
> [    0.515214] ACPI: Added _OSI(3.0 _SCP Extensions)
> [    0.515301] ACPI: Added _OSI(Processor Aggregator Device)
> [    0.516789] ACPI: EC: Look up EC in DSDT
> [    0.531866] \_SB_:_OSC evaluation returned wrong type
> [    0.531868] _OSC request data:1 4
> [    0.532291] ACPI: Interpreter enabled
> [    0.532375] ACPI: (supports S0 S5)
> [    0.532553] ACPI: Using IOAPIC for interrupt routing
> [    0.547943] PCI: Using host bridge windows from ACPI; if necessary,
> use "pci=nocrs" and report a bug
> [    0.548141] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3f])
> [    0.548298] PCI host bridge to bus 0000:00
> [    0.548385] pci_bus 0000:00: busn_res: [bus 00-3f] is inserted
> under domain [bus 00-ff]
> [    0.548387] pci_bus 0000:00: root bus resource [bus 00-3f]
> [    0.548478] pci_bus 0000:00: root bus resource [mem 0xeff00000-0xfdffffff]
> [    0.548573] pci_bus 0000:00: root bus resource [io  0x1000-0xffff]
> [    0.548665] pci_bus 0000:00: root bus resource [io  0x0000-0x03af]
> [    0.548758] pci_bus 0000:00: root bus resource [io  0x03e0-0x0cf7]
> [    0.548850] pci_bus 0000:00: root bus resource [io  0x0d00-0x0fff]
> [    0.548942] pci_bus 0000:00: root bus resource [mem 0xfed00000-0xfed03fff]
> [    0.549037] pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfed44fff]
> [    0.549131] pci_bus 0000:00: root bus resource [io  0x03b0-0x03bb]
> [    0.549224] pci_bus 0000:00: root bus resource [io  0x03c0-0x03df]
> [    0.549316] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
> [    0.549420] pci 0000:00:00.0: [1002:5a10] type 00 class 0x060000
> [    0.549478] pci 0000:00:03.0: [1002:5a17] type 01 class 0x060400
> [    0.549507] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
> [    0.549519] pci 0000:00:04.0: [1002:5a18] type 01 class 0x060400
> [    0.549547] pci 0000:00:04.0: PME# supported from D0 D3hot D3cold
> [    0.549565] pci 0000:00:0a.0: [1002:5a1d] type 01 class 0x060400
> [    0.549596] pci 0000:00:0a.0: PME# supported from D0 D3hot D3cold
> [    0.549621] pci 0000:00:11.0: [1002:4390] type 00 class 0x01018f
> [    0.549639] pci 0000:00:11.0: reg 10: [io  0x1000-0x1007]
> [    0.549648] pci 0000:00:11.0: reg 14: [io  0x1008-0x100b]
> [    0.549657] pci 0000:00:11.0: reg 18: [io  0x1010-0x1017]
> [    0.549667] pci 0000:00:11.0: reg 1c: [io  0x1018-0x101b]
> [    0.549676] pci 0000:00:11.0: reg 20: [io  0x1020-0x102f]
> [    0.549685] pci 0000:00:11.0: reg 24: [mem 0xfd4f0000-0xfd4f03ff]
> [    0.549704] pci 0000:00:11.0: set SATA to AHCI mode
> [    0.549833] pci 0000:00:12.0: [1002:4397] type 00 class 0x0c0310
> [    0.549846] pci 0000:00:12.0: reg 10: [mem 0xfd4e0000-0xfd4e0fff]
> [    0.549907] pci 0000:00:12.1: [1002:4398] type 00 class 0x0c0310
> [    0.549919] pci 0000:00:12.1: reg 10: [mem 0xfd4d0000-0xfd4d0fff]
> [    0.549985] pci 0000:00:12.2: [1002:4396] type 00 class 0x0c0320
> [    0.550002] pci 0000:00:12.2: reg 10: [mem 0xfd4c0000-0xfd4c00ff]
> [    0.550079] pci 0000:00:12.2: supports D1 D2
> [    0.550081] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
> [    0.550105] pci 0000:00:13.0: [1002:4397] type 00 class 0x0c0310
> [    0.550118] pci 0000:00:13.0: reg 10: [mem 0xfd4b0000-0xfd4b0fff]
> [    0.550178] pci 0000:00:13.1: [1002:4398] type 00 class 0x0c0310
> [    0.550190] pci 0000:00:13.1: reg 10: [mem 0xfd4a0000-0xfd4a0fff]
> [    0.550256] pci 0000:00:13.2: [1002:4396] type 00 class 0x0c0320
> [    0.550274] pci 0000:00:13.2: reg 10: [mem 0xfd490000-0xfd4900ff]
> [    0.550350] pci 0000:00:13.2: supports D1 D2
> [    0.550352] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
> [    0.550376] pci 0000:00:14.0: [1002:4385] type 00 class 0x0c0500
> [    0.550468] pci 0000:00:14.1: [1002:439c] type 00 class 0x01018a
> [    0.550484] pci 0000:00:14.1: reg 10: [io  0x01f0-0x01f7]
> [    0.550493] pci 0000:00:14.1: reg 14: [io  0x03f4-0x03f7]
> [    0.550502] pci 0000:00:14.1: reg 18: [io  0x0170-0x0177]
> [    0.550511] pci 0000:00:14.1: reg 1c: [io  0x0374-0x0377]
> [    0.550520] pci 0000:00:14.1: reg 20: [io  0x0500-0x050f]
> [    0.550573] pci 0000:00:14.3: [1002:439d] type 00 class 0x060100
> [    0.550644] pci 0000:00:14.4: [1002:4384] type 01 class 0x060401
> [    0.550688] pci 0000:00:18.0: [1022:1200] type 00 class 0x060000
> [    0.550711] pci 0000:00:18.1: [1022:1201] type 00 class 0x060000
> [    0.550723] pci 0000:00:18.2: [1022:1202] type 00 class 0x060000
> [    0.550737] pci 0000:00:18.3: [1022:1203] type 00 class 0x060000
> [    0.550753] pci 0000:00:18.4: [1022:1204] type 00 class 0x060000
> [    0.550768] pci 0000:00:19.0: [1022:1200] type 00 class 0x060000
> [    0.550792] pci 0000:00:19.1: [1022:1201] type 00 class 0x060000
> [    0.550806] pci 0000:00:19.2: [1022:1202] type 00 class 0x060000
> [    0.550821] pci 0000:00:19.3: [1022:1203] type 00 class 0x060000
> [    0.550840] pci 0000:00:19.4: [1022:1204] type 00 class 0x060000
> [    0.550857] pci 0000:00:1a.0: [1022:1200] type 00 class 0x060000
> [    0.550881] pci 0000:00:1a.1: [1022:1201] type 00 class 0x060000
> [    0.550895] pci 0000:00:1a.2: [1022:1202] type 00 class 0x060000
> [    0.550910] pci 0000:00:1a.3: [1022:1203] type 00 class 0x060000
> [    0.550929] pci 0000:00:1a.4: [1022:1204] type 00 class 0x060000
> [    0.550946] pci 0000:00:1b.0: [1022:1200] type 00 class 0x060000
> [    0.550973] pci 0000:00:1b.1: [1022:1201] type 00 class 0x060000
> [    0.550987] pci 0000:00:1b.2: [1022:1202] type 00 class 0x060000
> [    0.551002] pci 0000:00:1b.3: [1022:1203] type 00 class 0x060000
> [    0.551021] pci 0000:00:1b.4: [1022:1204] type 00 class 0x060000
> [    0.551061] pci_bus 0000:04: busn_res: [bus 04] is inserted under [bus 00-3f]
> [    0.551076] pci 0000:04:00.0: [19a2:0700] type 00 class 0x020000
> [    0.551095] pci 0000:04:00.0: reg 14: [mem 0xfdff0000-0xfdff3fff]
> [    0.551109] pci 0000:04:00.0: reg 18: [mem 0xfdfc0000-0xfdfdffff 64bit]
> [    0.551122] pci 0000:04:00.0: reg 20: [mem 0xfdfa0000-0xfdfbffff 64bit]
> [    0.551131] pci 0000:04:00.0: reg 30: [mem 0x00000000-0x0007ffff pref]
> [    0.551169] pci 0000:04:00.0: PME# supported from D3hot D3cold
> [    0.551199] pci 0000:04:00.1: [19a2:0700] type 00 class 0x020000
> [    0.551218] pci 0000:04:00.1: reg 14: [mem 0xfdf90000-0xfdf93fff]
> [    0.551231] pci 0000:04:00.1: reg 18: [mem 0xfdf60000-0xfdf7ffff 64bit]
> [    0.551244] pci 0000:04:00.1: reg 20: [mem 0xfdf40000-0xfdf5ffff 64bit]
> [    0.551253] pci 0000:04:00.1: reg 30: [mem 0x00000000-0x0007ffff pref]
> [    0.551291] pci 0000:04:00.1: PME# supported from D3hot D3cold
> [    0.551319] pci 0000:04:00.2: [19a2:0702] type 00 class 0x018000
> [    0.551338] pci 0000:04:00.2: reg 14: [mem 0xfdf30000-0xfdf33fff]
> [    0.551351] pci 0000:04:00.2: reg 18: [mem 0xfdf00000-0xfdf1ffff 64bit]
> [    0.551363] pci 0000:04:00.2: reg 20: [mem 0xfdee0000-0xfdefffff 64bit]
> [    0.551372] pci 0000:04:00.2: reg 30: [mem 0x00000000-0x0007ffff pref]
> [    0.551411] pci 0000:04:00.2: PME# supported from D3hot D3cold
> [    0.551438] pci 0000:04:00.3: [19a2:0702] type 00 class 0x018000
> [    0.551457] pci 0000:04:00.3: reg 14: [mem 0xfded0000-0xfded3fff]
> [    0.551470] pci 0000:04:00.3: reg 18: [mem 0xfdea0000-0xfdebffff 64bit]
> [    0.551483] pci 0000:04:00.3: reg 20: [mem 0xfde80000-0xfde9ffff 64bit]
> [    0.551492] pci 0000:04:00.3: reg 30: [mem 0x00000000-0x0007ffff pref]
> [    0.551530] pci 0000:04:00.3: PME# supported from D3hot D3cold
> [    0.556274] pci 0000:00:03.0: PCI bridge to [bus 04]
> [    0.556368] pci 0000:00:03.0:   bridge window [mem 0xfdd00000-0xfdffffff]
> [    0.556392] pci_bus 0000:03: busn_res: [bus 03] is inserted under [bus 00-3f]
> [    0.556405] pci 0000:03:00.0: [103c:323a] type 00 class 0x010400
> [    0.556417] pci 0000:03:00.0: reg 10: [mem 0xfda00000-0xfdbfffff 64bit]
> [    0.556427] pci 0000:03:00.0: reg 18: [mem 0xfd9f0000-0xfd9f0fff 64bit]
> [    0.556433] pci 0000:03:00.0: reg 20: [io  0x4000-0x40ff]
> [    0.556445] pci 0000:03:00.0: reg 30: [mem 0x00000000-0x0007ffff pref]
> [    0.556475] pci 0000:03:00.0: PME# supported from D0
> [    0.562932] pci 0000:00:04.0: PCI bridge to [bus 03]
> [    0.563025] pci 0000:00:04.0:   bridge window [io  0x4000-0x4fff]
> [    0.563028] pci 0000:00:04.0:   bridge window [mem 0xfd900000-0xfdbfffff]
> [    0.563052] pci_bus 0000:02: busn_res: [bus 02] is inserted under [bus 00-3f]
> [    0.563073] pci 0000:02:00.0: [103c:3306] type 00 class 0x088000
> [    0.563087] pci 0000:02:00.0: reg 10: [io  0x3000-0x30ff]
> [    0.563096] pci 0000:02:00.0: reg 14: [mem 0xfd8f0000-0xfd8f01ff]
> [    0.563106] pci 0000:02:00.0: reg 18: [io  0x3400-0x34ff]
> [    0.563203] pci 0000:02:00.2: [103c:3307] type 00 class 0x088000
> [    0.563216] pci 0000:02:00.2: reg 10: [io  0x3800-0x38ff]
> [    0.563225] pci 0000:02:00.2: reg 14: [mem 0xfd8e0000-0xfd8e00ff]
> [    0.563235] pci 0000:02:00.2: reg 18: [mem 0xfd700000-0xfd7fffff]
> [    0.563244] pci 0000:02:00.2: reg 1c: [mem 0xfd680000-0xfd6fffff]
> [    0.563253] pci 0000:02:00.2: reg 20: [mem 0xfd670000-0xfd677fff]
> [    0.563262] pci 0000:02:00.2: reg 24: [mem 0xfd660000-0xfd667fff]
> [    0.563272] pci 0000:02:00.2: reg 30: [mem 0x00000000-0x0000ffff pref]
> [    0.563312] pci 0000:02:00.2: PME# supported from D0 D3hot D3cold
> [    0.563339] pci 0000:02:00.4: [103c:3300] type 00 class 0x0c0300
> [    0.563381] pci 0000:02:00.4: reg 20: [io  0x3c00-0x3c1f]
> [    0.569600] pci 0000:00:0a.0: PCI bridge to [bus 02]
> [    0.569692] pci 0000:00:0a.0:   bridge window [io  0x3000-0x3fff]
> [    0.569695] pci 0000:00:0a.0:   bridge window [mem 0xfd600000-0xfd8fffff]
> [    0.569711] pci_bus 0000:01: busn_res: [bus 01] is inserted under [bus 00-3f]
> [    0.569730] pci 0000:01:03.0: [1002:515e] type 00 class 0x030000
> [    0.569752] pci 0000:01:03.0: reg 10: [mem 0xf0000000-0xf7ffffff pref]
> [    0.569764] pci 0000:01:03.0: reg 14: [io  0x2000-0x20ff]
> [    0.569776] pci 0000:01:03.0: reg 18: [mem 0xfd5f0000-0xfd5fffff]
> [    0.569818] pci 0000:01:03.0: reg 30: [mem 0x00000000-0x0001ffff pref]
> [    0.569855] pci 0000:01:03.0: supports D1 D2
> [    0.569903] pci 0000:00:14.4: PCI bridge to [bus 01] (subtractive decode)
> [    0.570000] pci 0000:00:14.4:   bridge window [io  0x2000-0x2fff]
> [    0.570004] pci 0000:00:14.4:   bridge window [mem 0xfd500000-0xfd5fffff]
> [    0.570008] pci 0000:00:14.4:   bridge window [mem
> 0xf0000000-0xf7ffffff pref]
> [    0.570010] pci 0000:00:14.4:   bridge window [mem
> 0xeff00000-0xfdffffff] (subtractive decode)
> [    0.570012] pci 0000:00:14.4:   bridge window [io  0x1000-0xffff]
> (subtractive decode)
> [    0.570015] pci 0000:00:14.4:   bridge window [io  0x0000-0x03af]
> (subtractive decode)
> [    0.570017] pci 0000:00:14.4:   bridge window [io  0x03e0-0x0cf7]
> (subtractive decode)
> [    0.570019] pci 0000:00:14.4:   bridge window [io  0x0d00-0x0fff]
> (subtractive decode)
> [    0.570021] pci 0000:00:14.4:   bridge window [mem
> 0xfed00000-0xfed03fff] (subtractive decode)
> [    0.570023] pci 0000:00:14.4:   bridge window [mem
> 0xfed40000-0xfed44fff] (subtractive decode)
> [    0.570025] pci 0000:00:14.4:   bridge window [io  0x03b0-0x03bb]
> (subtractive decode)
> [    0.570027] pci 0000:00:14.4:   bridge window [io  0x03c0-0x03df]
> (subtractive decode)
> [    0.570029] pci 0000:00:14.4:   bridge window [mem
> 0x000a0000-0x000bffff] (subtractive decode)
> [    0.570046] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
> [    0.570162] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
> [    0.570185] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.G134._PRT]
> [    0.570205] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.G113._PRT]
> [    0.570242] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.G13A._PRT]
> [    0.570325]  pci0000:00: Requesting ACPI _OSC control (0x1d)
> [    0.570459]  pci0000:00: ACPI _OSC request failed (AE_SUPPORT),
> returned control mask: 0x00
> [    0.570583] ACPI _OSC control for PCIe not granted, disabling ASPM
> [    0.660477] ACPI: PCI Interrupt Link [I020] (IRQs *24)
> [    0.661040] ACPI: PCI Interrupt Link [I021] (IRQs *25)
> [    0.661608] ACPI: PCI Interrupt Link [I022] (IRQs *26)
> [    0.662180] ACPI: PCI Interrupt Link [I023] (IRQs *27)
> [    0.662740] ACPI: PCI Interrupt Link [I030] (IRQs *28)
> [    0.663309] ACPI: PCI Interrupt Link [I031] (IRQs *29)
> [    0.663881] ACPI: PCI Interrupt Link [I032] (IRQs *30)
> [    0.664457] ACPI: PCI Interrupt Link [I033] (IRQs *31)
> [    0.665026] ACPI: PCI Interrupt Link [I040] (IRQs *44)
> [    0.665598] ACPI: PCI Interrupt Link [I041] (IRQs *45)
> [    0.666175] ACPI: PCI Interrupt Link [I042] (IRQs *46)
> [    0.666759] ACPI: PCI Interrupt Link [I043] (IRQs *47)
> [    0.667330] ACPI: PCI Interrupt Link [I050] (IRQs *48)
> [    0.667907] ACPI: PCI Interrupt Link [I051] (IRQs *49)
> [    0.668492] ACPI: PCI Interrupt Link [I052] (IRQs *50)
> [    0.669079] ACPI: PCI Interrupt Link [I053] (IRQs *51)
> [    0.669675] ACPI: PCI Interrupt Link [I060] (IRQs *47)
> [    0.670252] ACPI: PCI Interrupt Link [I061] (IRQs *44)
> [    0.670834] ACPI: PCI Interrupt Link [I062] (IRQs *45)
> [    0.671421] ACPI: PCI Interrupt Link [I063] (IRQs *46)
> [    0.672003] ACPI: PCI Interrupt Link [I070] (IRQs *24)
> [    0.672590] ACPI: PCI Interrupt Link [I071] (IRQs *25)
> [    0.673187] ACPI: PCI Interrupt Link [I072] (IRQs *26)
> [    0.673786] ACPI: PCI Interrupt Link [I073] (IRQs *27)
> [    0.674088] ACPI: PCI Interrupt Link [I090] (IRQs *24)
> [    0.674388] ACPI: PCI Interrupt Link [I091] (IRQs *24)
> [    0.674689] ACPI: PCI Interrupt Link [I092] (IRQs *24)
> [    0.674989] ACPI: PCI Interrupt Link [I093] (IRQs *24)
> [    0.675580] ACPI: PCI Interrupt Link [I0A0] (IRQs *24)
> [    0.676177] ACPI: PCI Interrupt Link [I0A1] (IRQs *25)
> [    0.676782] ACPI: PCI Interrupt Link [I0A2] (IRQs *26)
> [    0.677387] ACPI: PCI Interrupt Link [I0A3] (IRQs *27)
> [    0.677983] ACPI: PCI Interrupt Link [I0B0] (IRQs *32)
> [    0.678584] ACPI: PCI Interrupt Link [I0B1] (IRQs *33)
> [    0.679191] ACPI: PCI Interrupt Link [I0B2] (IRQs *34)
> [    0.679805] ACPI: PCI Interrupt Link [I0B3] (IRQs *35)
> [    0.680407] ACPI: PCI Interrupt Link [I0C0] (IRQs *36)
> [    0.681013] ACPI: PCI Interrupt Link [I0C1] (IRQs *37)
> [    0.681626] ACPI: PCI Interrupt Link [I0C2] (IRQs *38)
> [    0.682244] ACPI: PCI Interrupt Link [I0C3] (IRQs *39)
> [    0.682853] ACPI: PCI Interrupt Link [I0D0] (IRQs *40)
> [    0.683466] ACPI: PCI Interrupt Link [I0D1] (IRQs *41)
> [    0.684084] ACPI: PCI Interrupt Link [I0D2] (IRQs *42)
> [    0.684705] ACPI: PCI Interrupt Link [I0D3] (IRQs *43)
> [    0.684966] ACPI: PCI Interrupt Link [BI02] (IRQs *52)
> [    0.685227] ACPI: PCI Interrupt Link [BI03] (IRQs *52)
> [    0.685494] ACPI: PCI Interrupt Link [BI04] (IRQs *52)
> [    0.685766] ACPI: PCI Interrupt Link [BI05] (IRQs *52)
> [    0.686043] ACPI: PCI Interrupt Link [BI06] (IRQs *54)
> [    0.686329] ACPI: PCI Interrupt Link [BI07] (IRQs *24)
> [    0.686616] ACPI: PCI Interrupt Link [BI08] (IRQs *24)
> [    0.686910] ACPI: PCI Interrupt Link [BI09] (IRQs *24)
> [    0.687207] ACPI: PCI Interrupt Link [BI0A] (IRQs *24)
> [    0.687510] ACPI: PCI Interrupt Link [BI0B] (IRQs *54)
> [    0.687818] ACPI: PCI Interrupt Link [BI0C] (IRQs *54)
> [    0.688130] ACPI: PCI Interrupt Link [BI0D] (IRQs *54)
> [    0.688388] ACPI: PCI Interrupt Link [PI20] (IRQs 10 11) *0, disabled.
> [    0.688797] ACPI: PCI Interrupt Link [PI21] (IRQs 10 11) *0, disabled.
> [    0.689206] ACPI: PCI Interrupt Link [PI22] (IRQs 10 11) *0, disabled.
> [    0.689617] ACPI: PCI Interrupt Link [PI23] (IRQs 10 11) *0, disabled.
> [    0.690025] ACPI: PCI Interrupt Link [PI30] (IRQs 10 11) *0, disabled.
> [    0.690433] ACPI: PCI Interrupt Link [PI31] (IRQs 10 11) *0, disabled.
> [    0.690842] ACPI: PCI Interrupt Link [PI32] (IRQs 10 11) *0, disabled.
> [    0.691250] ACPI: PCI Interrupt Link [PI33] (IRQs 10 11) *0, disabled.
> [    0.691659] ACPI: PCI Interrupt Link [PI40] (IRQs 10 11) *0, disabled.
> [    0.692067] ACPI: PCI Interrupt Link [PI41] (IRQs 10 11) *0, disabled.
> [    0.692474] ACPI: PCI Interrupt Link [PI42] (IRQs 10 11) *0, disabled.
> [    0.692884] ACPI: PCI Interrupt Link [PI43] (IRQs 10 11) *0, disabled.
> [    0.693293] ACPI: PCI Interrupt Link [PI50] (IRQs 10 11) *0, disabled.
> [    0.693701] ACPI: PCI Interrupt Link [PI51] (IRQs 10 11) *0, disabled.
> [    0.694108] ACPI: PCI Interrupt Link [PI52] (IRQs 10 11) *0, disabled.
> [    0.694516] ACPI: PCI Interrupt Link [PI53] (IRQs 10 11) *0, disabled.
> [    0.694924] ACPI: PCI Interrupt Link [PI60] (IRQs 10 11) *0, disabled.
> [    0.695332] ACPI: PCI Interrupt Link [PI61] (IRQs 10 11) *0, disabled.
> [    0.695740] ACPI: PCI Interrupt Link [PI62] (IRQs 10 11) *0, disabled.
> [    0.696148] ACPI: PCI Interrupt Link [PI63] (IRQs 10 11) *0, disabled.
> [    0.696559] ACPI: PCI Interrupt Link [PI70] (IRQs 10 11) *0, disabled.
> [    0.696968] ACPI: PCI Interrupt Link [PI71] (IRQs 10 11) *0, disabled.
> [    0.697379] ACPI: PCI Interrupt Link [PI72] (IRQs 10 11) *0, disabled.
> [    0.697787] ACPI: PCI Interrupt Link [PI73] (IRQs 10 11) *0, disabled.
> [    0.698196] ACPI: PCI Interrupt Link [PI90] (IRQs 10 11) *0, disabled.
> [    0.698604] ACPI: PCI Interrupt Link [PI91] (IRQs 10 11) *0, disabled.
> [    0.699013] ACPI: PCI Interrupt Link [PI92] (IRQs 10 11) *0, disabled.
> [    0.699421] ACPI: PCI Interrupt Link [PI93] (IRQs 10 11) *0, disabled.
> [    0.699833] ACPI: PCI Interrupt Link [PIA0] (IRQs 10 11) *0, disabled.
> [    0.700241] ACPI: PCI Interrupt Link [PIA1] (IRQs 10 11) *0, disabled.
> [    0.700648] ACPI: PCI Interrupt Link [PIA2] (IRQs 10 11) *0, disabled.
> [    0.701057] ACPI: PCI Interrupt Link [PIA3] (IRQs 10 11) *0, disabled.
> [    0.701466] ACPI: PCI Interrupt Link [PIB0] (IRQs 10 11) *0, disabled.
> [    0.701873] ACPI: PCI Interrupt Link [PIB1] (IRQs 10 11) *0, disabled.
> [    0.702282] ACPI: PCI Interrupt Link [PIB2] (IRQs 10 11) *0, disabled.
> [    0.702690] ACPI: PCI Interrupt Link [PIB3] (IRQs 10 11) *0, disabled.
> [    0.703102] ACPI: PCI Interrupt Link [PIC0] (IRQs 10 11) *0, disabled.
> [    0.703510] ACPI: PCI Interrupt Link [PIC1] (IRQs 10 11) *0, disabled.
> [    0.703917] ACPI: PCI Interrupt Link [PIC2] (IRQs 10 11) *0, disabled.
> [    0.704325] ACPI: PCI Interrupt Link [PIC3] (IRQs 10 11) *0, disabled.
> [    0.704734] ACPI: PCI Interrupt Link [PID0] (IRQs 10 11) *0, disabled.
> [    0.705141] ACPI: PCI Interrupt Link [PID1] (IRQs 10 11) *0, disabled.
> [    0.705552] ACPI: PCI Interrupt Link [PID2] (IRQs 10 11) *0, disabled.
> [    0.705960] ACPI: PCI Interrupt Link [PID3] (IRQs 10 11) *0, disabled.
> [    0.706370] ACPI: PCI Interrupt Link [PIR2] (IRQs 10 11) *0, disabled.
> [    0.706778] ACPI: PCI Interrupt Link [PIR3] (IRQs 10 11) *0, disabled.
> [    0.707187] ACPI: PCI Interrupt Link [PIR4] (IRQs 10 11) *0, disabled.
> [    0.707593] ACPI: PCI Interrupt Link [PIR5] (IRQs 10 11) *0, disabled.
> [    0.708002] ACPI: PCI Interrupt Link [PIR6] (IRQs 10 11) *0, disabled.
> [    0.708411] ACPI: PCI Interrupt Link [PIR7] (IRQs 10 11) *0, disabled.
> [    0.708819] ACPI: PCI Interrupt Link [PIR8] (IRQs 10 11) *0, disabled.
> [    0.709227] ACPI: PCI Interrupt Link [PIR9] (IRQs 10 11) *0, disabled.
> [    0.709638] ACPI: PCI Interrupt Link [PIRA] (IRQs 10 11) *0, disabled.
> [    0.710046] ACPI: PCI Interrupt Link [PIRB] (IRQs 10 11) *0, disabled.
> [    0.710454] ACPI: PCI Interrupt Link [PIRC] (IRQs 10 11) *0, disabled.
> [    0.710862] ACPI: PCI Interrupt Link [PIRD] (IRQs 10 11) *0, disabled.
> [    0.711279] ACPI: PCI Interrupt Link [USB1] (IRQs *22)
> [    0.711546] ACPI: PCI Interrupt Link [USB2] (IRQs *23)
> [    0.711817] ACPI: PCI Interrupt Link [USB3] (IRQs *23)
> [    0.712093] ACPI: PCI Interrupt Link [USB4] (IRQs *22)
> [    0.712392] ACPI: Invalid _PRS IRQ 0
> [    0.712542] ACPI: PCI Interrupt Link [U1PI] (IRQs) *0
> [    0.712845] ACPI: Invalid _PRS IRQ 0
> [    0.712998] ACPI: PCI Interrupt Link [U2PI] (IRQs) *0
> [    0.713299] ACPI: Invalid _PRS IRQ 0
> [    0.713454] ACPI: PCI Interrupt Link [U3PI] (IRQs) *0
> [    0.713758] ACPI: Invalid _PRS IRQ 0
> [    0.713915] ACPI: PCI Interrupt Link [U4PI] (IRQs) *0
> [    0.714167] ACPI: PCI Interrupt Link [SATA] (IRQs *16)
> [    0.714426] ACPI: Invalid _PRS IRQ 0
> [    0.714538] ACPI: PCI Interrupt Link [SATP] (IRQs) *0
> [    0.714790] ACPI: PCI Interrupt Link [VIDA] (IRQs *16)
> [    0.715049] ACPI: Invalid _PRS IRQ 0
> [    0.715161] ACPI: PCI Interrupt Link [VIDP] (IRQs) *0
> [    0.715624] vgaarb: device added:
> PCI:0000:01:03.0,decodes=io+mem,owns=io+mem,locks=none
> [    0.724046] vgaarb: loaded
> [    0.724126] vgaarb: bridge control possible 0000:01:03.0
> [    0.724521] SCSI subsystem initialized
> [    0.724703] ACPI: bus type usb registered
> [    0.724855] usbcore: registered new interface driver usbfs
> [    0.724981] usbcore: registered new interface driver hub
> [    0.725137] usbcore: registered new device driver usb
> [    0.725359] PCI: Using ACPI for IRQ routing
> [    0.733368] PCI: pci_cache_line_size set to 64 bytes
> [    0.733470] e820: reserve RAM buffer [mem 0x0009f000-0x0009ffff]
> [    0.733472] e820: reserve RAM buffer [mem 0xbde1c000-0xbfffffff]
> [    0.733473] e820: reserve RAM buffer [mem 0xbde4d000-0xbfffffff]
> [    0.733475] e820: reserve RAM buffer [mem 0x43ffff000-0x43fffffff]
> [    0.733745] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
> [    0.734063] hpet0: 4 comparators, 32-bit 14.318180 MHz counter
> [    0.736259] Switching to clocksource hpet
> [    0.736562] FS-Cache: Loaded
> [    0.736769] CacheFiles: Loaded
> [    0.736916] pnp: PnP ACPI init
> [    0.737003] ACPI: bus type pnp registered
> [    0.737149] pnp 00:00: [bus 00-3f]
> [    0.737152] pnp 00:00: [mem 0xeff00000-0xfdffffff window]
> [    0.737155] pnp 00:00: [io  0x1000-0xffff window]
> [    0.737157] pnp 00:00: [io  0x0000-0x03af window]
> [    0.737159] pnp 00:00: [io  0x03e0-0x0cf7 window]
> [    0.737160] pnp 00:00: [io  0x0d00-0x0fff window]
> [    0.737162] pnp 00:00: [mem 0xfed00000-0xfed03fff window]
> [    0.737164] pnp 00:00: [mem 0xfed40000-0xfed44fff window]
> [    0.737166] pnp 00:00: [io  0x03b0-0x03bb window]
> [    0.737168] pnp 00:00: [io  0x03c0-0x03df window]
> [    0.737170] pnp 00:00: [mem 0x000a0000-0x000bffff window]
> [    0.737425] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08
> PNP0a03 (active)
> [    0.739283] pnp 00:01: [io  0x0010-0x001f]
> [    0.739285] pnp 00:01: [io  0x0020-0x003f]
> [    0.739287] pnp 00:01: [io  0x00a0-0x00bf]
> [    0.739289] pnp 00:01: [io  0x0050-0x0053]
> [    0.739290] pnp 00:01: [io  0x0070-0x0079]
> [    0.739292] pnp 00:01: [io  0x0090-0x009f]
> [    0.739294] pnp 00:01: [io  0x00f0]
> [    0.739296] pnp 00:01: [io  0x0379-0x037a]
> [    0.739297] pnp 00:01: [io  0x0400-0x043f]
> [    0.739299] pnp 00:01: [io  0x04d0-0x04d1]
> [    0.739301] pnp 00:01: [io  0x04d6]
> [    0.739302] pnp 00:01: [io  0x0520]
> [    0.739304] pnp 00:01: [io  0x0580-0x059f]
> [    0.739306] pnp 00:01: [io  0x0600-0x067f]
> [    0.739308] pnp 00:01: [io  0x0700-0x0703]
> [    0.739309] pnp 00:01: [io  0x0820-0x082f]
> [    0.739311] pnp 00:01: [io  0x0900-0x09fe]
> [    0.739313] pnp 00:01: [io  0x0c06-0x0c07]
> [    0.739315] pnp 00:01: [io  0x0c14]
> [    0.739316] pnp 00:01: [io  0x0c4a]
> [    0.739318] pnp 00:01: [io  0x0c50-0x0c52]
> [    0.739320] pnp 00:01: [io  0x0c6c]
> [    0.739321] pnp 00:01: [io  0x0c6f]
> [    0.739323] pnp 00:01: [io  0x0c80-0x0c83]
> [    0.739325] pnp 00:01: [io  0x0c90-0x0c9f]
> [    0.739326] pnp 00:01: [io  0x0ca0-0x0ca5]
> [    0.739328] pnp 00:01: [io  0x0cd0-0x0cdf]
> [    0.739330] pnp 00:01: [io  0x0f50-0x0f58]
> [    0.739332] pnp 00:01: [io  0x0b00-0x0b3f]
> [    0.739334] pnp 00:01: [io  0x03f8-0x03ff]
> [    0.739336] pnp 00:01: [mem 0xc0000000-0xcfffffff]
> [    0.739604] system 00:01: [io  0x0379-0x037a] has been reserved
> [    0.739702] system 00:01: [io  0x0400-0x043f] has been reserved
> [    0.739847] system 00:01: [io  0x04d0-0x04d1] has been reserved
> [    0.739940] system 00:01: [io  0x04d6] has been reserved
> [    0.740032] system 00:01: [io  0x0520] has been reserved
> [    0.740124] system 00:01: [io  0x0580-0x059f] has been reserved
> [    0.740217] system 00:01: [io  0x0600-0x067f] has been reserved
> [    0.740312] system 00:01: [io  0x0700-0x0703] has been reserved
> [    0.740405] system 00:01: [io  0x0820-0x082f] has been reserved
> [    0.740499] system 00:01: [io  0x0900-0x09fe] has been reserved
> [    0.740592] system 00:01: [io  0x0c06-0x0c07] has been reserved
> [    0.740686] system 00:01: [io  0x0c14] has been reserved
> [    0.740777] system 00:01: [io  0x0c4a] has been reserved
> [    0.740869] system 00:01: [io  0x0c50-0x0c52] has been reserved
> [    0.740962] system 00:01: [io  0x0c6c] has been reserved
> [    0.741054] system 00:01: [io  0x0c6f] has been reserved
> [    0.741146] system 00:01: [io  0x0c80-0x0c83] has been reserved
> [    0.741239] system 00:01: [io  0x0c90-0x0c9f] has been reserved
> [    0.741333] system 00:01: [io  0x0ca0-0x0ca5] has been reserved
> [    0.741427] system 00:01: [io  0x0cd0-0x0cdf] has been reserved
> [    0.741520] system 00:01: [io  0x0f50-0x0f58] has been reserved
> [    0.741614] system 00:01: [io  0x0b00-0x0b3f] has been reserved
> [    0.741708] system 00:01: [io  0x03f8-0x03ff] has been reserved
> [    0.741803] system 00:01: [mem 0xc0000000-0xcfffffff] has been reserved
> [    0.741899] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
> [    0.741907] pnp 00:02: [io  0x0ca2-0x0ca3]
> [    0.742036] pnp 00:02: Plug and Play ACPI device, IDs IPI0001 (active)
> [    0.742054] pnp 00:03: [mem 0xfed00000-0xfed003ff]
> [    0.742137] pnp 00:03: Plug and Play ACPI device, IDs PNP0103 (active)
> [    0.742145] pnp 00:04: [dma 7]
> [    0.742147] pnp 00:04: [io  0x0000-0x000f]
> [    0.742149] pnp 00:04: [io  0x0080-0x008f]
> [    0.742151] pnp 00:04: [io  0x00c0-0x00df]
> [    0.742237] pnp 00:04: Plug and Play ACPI device, IDs PNP0200 (active)
> [    0.742244] pnp 00:05: [io  0x0061]
> [    0.742325] pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
> [    0.742334] pnp 00:06: [io  0x0060]
> [    0.742336] pnp 00:06: [io  0x0064]
> [    0.742352] pnp 00:06: [irq 1]
> [    0.742436] pnp 00:06: Plug and Play ACPI device, IDs PNP0303 (active)
> [    0.742450] pnp 00:07: [irq 12]
> [    0.742535] pnp 00:07: Plug and Play ACPI device, IDs PNP0f13
> PNP0f0e (active)
> [    0.742544] pnp 00:08: [io  0x002e-0x002f]
> [    0.742546] pnp 00:08: [io  0x0620-0x065f]
> [    0.742548] pnp 00:08: [io  0x0680-0x069f]
> [    0.742550] pnp 00:08: [io  0x0600-0x061f]
> [    0.742552] pnp 00:08: [io  0x0660-0x067f]
> [    0.742553] pnp 00:08: [io  0x0300-0x031f]
> [    0.742635] pnp 00:08: Plug and Play ACPI device, IDs PNP0a06 (active)
> [    0.742743] pnp 00:09: [irq 3]
> [    0.742745] pnp 00:09: [io  0x02f8-0x02ff]
> [    0.742901] pnp 00:09: Plug and Play ACPI device, IDs PNP0501
> PNP0500 (active)
> [    0.742908] pnp 00:0a: [io  0x0070-0x0071]
> [    0.742993] pnp 00:0a: Plug and Play ACPI device, IDs PNP0b00 (active)
> [    0.743060] pnp: PnP ACPI: found 11 devices
> [    0.743202] ACPI: ACPI bus type pnp unregistered
> [    0.752067] pci 0000:00:03.0: BAR 15: assigned [mem
> 0xf8000000-0xf81fffff pref]
> [    0.752192] pci 0000:00:04.0: BAR 15: assigned [mem
> 0xf8200000-0xf82fffff pref]
> [    0.752317] pci 0000:00:0a.0: BAR 15: assigned [mem
> 0xf8300000-0xf83fffff pref]
> [    0.752443] pci 0000:04:00.0: BAR 6: assigned [mem
> 0xf8000000-0xf807ffff pref]
> [    0.752568] pci 0000:04:00.1: BAR 6: assigned [mem
> 0xf8080000-0xf80fffff pref]
> [    0.752692] pci 0000:04:00.2: BAR 6: assigned [mem
> 0xf8100000-0xf817ffff pref]
> [    0.752816] pci 0000:04:00.3: BAR 6: assigned [mem
> 0xf8180000-0xf81fffff pref]
> [    0.752940] pci 0000:00:03.0: PCI bridge to [bus 04]
> [    0.753031] pci 0000:00:03.0:   bridge window [mem 0xfdd00000-0xfdffffff]
> [    0.753180] pci 0000:00:03.0:   bridge window [mem
> 0xf8000000-0xf81fffff pref]
> [    0.753306] pci 0000:03:00.0: BAR 6: assigned [mem
> 0xf8200000-0xf827ffff pref]
> [    0.753429] pci 0000:00:04.0: PCI bridge to [bus 03]
> [    0.753520] pci 0000:00:04.0:   bridge window [io  0x4000-0x4fff]
> [    0.753614] pci 0000:00:04.0:   bridge window [mem 0xfd900000-0xfdbfffff]
> [    0.753711] pci 0000:00:04.0:   bridge window [mem
> 0xf8200000-0xf82fffff pref]
> [    0.753837] pci 0000:02:00.2: BAR 6: assigned [mem
> 0xf8300000-0xf830ffff pref]
> [    0.753960] pci 0000:00:0a.0: PCI bridge to [bus 02]
> [    0.754051] pci 0000:00:0a.0:   bridge window [io  0x3000-0x3fff]
> [    0.754146] pci 0000:00:0a.0:   bridge window [mem 0xfd600000-0xfd8fffff]
> [    0.754243] pci 0000:00:0a.0:   bridge window [mem
> 0xf8300000-0xf83fffff pref]
> [    0.754369] pci 0000:01:03.0: BAR 6: assigned [mem
> 0xfd500000-0xfd51ffff pref]
> [    0.754492] pci 0000:00:14.4: PCI bridge to [bus 01]
> [    0.754583] pci 0000:00:14.4:   bridge window [io  0x2000-0x2fff]
> [    0.754681] pci 0000:00:14.4:   bridge window [mem 0xfd500000-0xfd5fffff]
> [    0.754779] pci 0000:00:14.4:   bridge window [mem
> 0xf0000000-0xf7ffffff pref]
> [    0.754951] ACPI: PCI Interrupt Link [BI03] enabled at IRQ 52
> [    0.755091] ACPI: PCI Interrupt Link [BI04] enabled at IRQ 52
> [    0.755232] ACPI: PCI Interrupt Link [BI0A] enabled at IRQ 24
> [    0.755336] pci_bus 0000:00: resource 4 [mem 0xeff00000-0xfdffffff]
> [    0.755338] pci_bus 0000:00: resource 5 [io  0x1000-0xffff]
> [    0.755340] pci_bus 0000:00: resource 6 [io  0x0000-0x03af]
> [    0.755342] pci_bus 0000:00: resource 7 [io  0x03e0-0x0cf7]
> [    0.755344] pci_bus 0000:00: resource 8 [io  0x0d00-0x0fff]
> [    0.755346] pci_bus 0000:00: resource 9 [mem 0xfed00000-0xfed03fff]
> [    0.755348] pci_bus 0000:00: resource 10 [mem 0xfed40000-0xfed44fff]
> [    0.755350] pci_bus 0000:00: resource 11 [io  0x03b0-0x03bb]
> [    0.755352] pci_bus 0000:00: resource 12 [io  0x03c0-0x03df]
> [    0.755355] pci_bus 0000:00: resource 13 [mem 0x000a0000-0x000bffff]
> [    0.755357] pci_bus 0000:04: resource 1 [mem 0xfdd00000-0xfdffffff]
> [    0.755359] pci_bus 0000:04: resource 2 [mem 0xf8000000-0xf81fffff pref]
> [    0.755362] pci_bus 0000:03: resource 0 [io  0x4000-0x4fff]
> [    0.755364] pci_bus 0000:03: resource 1 [mem 0xfd900000-0xfdbfffff]
> [    0.755366] pci_bus 0000:03: resource 2 [mem 0xf8200000-0xf82fffff pref]
> [    0.755369] pci_bus 0000:02: resource 0 [io  0x3000-0x3fff]
> [    0.755371] pci_bus 0000:02: resource 1 [mem 0xfd600000-0xfd8fffff]
> [    0.755373] pci_bus 0000:02: resource 2 [mem 0xf8300000-0xf83fffff pref]
> [    0.755375] pci_bus 0000:01: resource 0 [io  0x2000-0x2fff]
> [    0.755378] pci_bus 0000:01: resource 1 [mem 0xfd500000-0xfd5fffff]
> [    0.755380] pci_bus 0000:01: resource 2 [mem 0xf0000000-0xf7ffffff pref]
> [    0.755382] pci_bus 0000:01: resource 4 [mem 0xeff00000-0xfdffffff]
> [    0.755384] pci_bus 0000:01: resource 5 [io  0x1000-0xffff]
> [    0.755386] pci_bus 0000:01: resource 6 [io  0x0000-0x03af]
> [    0.755388] pci_bus 0000:01: resource 7 [io  0x03e0-0x0cf7]
> [    0.755390] pci_bus 0000:01: resource 8 [io  0x0d00-0x0fff]
> [    0.755392] pci_bus 0000:01: resource 9 [mem 0xfed00000-0xfed03fff]
> [    0.755395] pci_bus 0000:01: resource 10 [mem 0xfed40000-0xfed44fff]
> [    0.755397] pci_bus 0000:01: resource 11 [io  0x03b0-0x03bb]
> [    0.755399] pci_bus 0000:01: resource 12 [io  0x03c0-0x03df]
> [    0.755401] pci_bus 0000:01: resource 13 [mem 0x000a0000-0x000bffff]
> [    0.755451] NET: Registered protocol family 2
> [    0.756299] TCP established hash table entries: 524288 (order: 11,
> 8388608 bytes)
> [    0.759436] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
> [    0.759938] TCP: Hash tables configured (established 524288 bind 65536)
> [    0.760080] TCP: reno registered
> [    0.760191] UDP hash table entries: 8192 (order: 6, 262144 bytes)
> [    0.760413] UDP-Lite hash table entries: 8192 (order: 6, 262144 bytes)
> [    0.760715] NET: Registered protocol family 1
> [    0.760942] RPC: Registered named UNIX socket transport module.
> [    0.761035] RPC: Registered udp transport module.
> [    0.761124] RPC: Registered tcp transport module.
> [    0.761212] RPC: Registered tcp NFSv4.1 backchannel transport module.
> [    0.761423] ACPI: PCI Interrupt Link [USB1] enabled at IRQ 22
> [    0.896521] ACPI: PCI Interrupt Link [USB2] enabled at IRQ 23
> [    0.913178] ACPI: PCI Interrupt Link [USB3] enabled at IRQ 23
> [    1.053113] ACPI: PCI Interrupt Link [USB4] enabled at IRQ 22
> [    1.069984] ACPI: PCI Interrupt Link [I061] enabled at IRQ 44
> [    1.070117] pci 0000:01:03.0: Boot video device
> [    1.070121] PCI: CLS 64 bytes, default 64
> [    1.071082] PCI-DMA: Disabling AGP.
> [    1.071302] PCI-DMA: aperture base @ b4000000 size 65536 KB
> [    1.071393] PCI-DMA: using GART IOMMU.
> [    1.071480] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
> [    1.076187] LVT offset 1 assigned for vector 0x400
> [    1.076354] IBS: LVT offset 1 assigned
> [    1.076480] perf: AMD IBS detected (0x0000001f)
> [    1.078377] microcode: CPU0: patch_level=0x010000d9
> [    1.078485] microcode: CPU1: patch_level=0x010000d9
> [    1.078587] microcode: CPU2: patch_level=0x010000d9
> [    1.078683] microcode: CPU3: patch_level=0x010000d9
> [    1.078786] microcode: CPU4: patch_level=0x010000d9
> [    1.078894] microcode: CPU5: patch_level=0x010000d9
> [    1.079003] microcode: CPU6: patch_level=0x010000d9
> [    1.079109] microcode: CPU7: patch_level=0x010000d9
> [    1.079221] microcode: CPU8: patch_level=0x010000d9
> [    1.079333] microcode: CPU9: patch_level=0x010000d9
> [    1.079446] microcode: CPU10: patch_level=0x010000d9
> [    1.079557] microcode: CPU11: patch_level=0x010000d9
> [    1.079710] microcode: CPU12: patch_level=0x010000d9
> [    1.079814] microcode: CPU13: patch_level=0x010000d9
> [    1.079919] microcode: CPU14: patch_level=0x010000d9
> [    1.080025] microcode: CPU15: patch_level=0x010000d9
> [    1.080230] microcode: Microcode Update Driver: v2.00
> <tigran@aivazian.fsnet.co.uk>, Peter Oruba
> [    1.080879] AVX instructions are not detected.
> [    1.081285] AVX instructions are not detected.
> [    1.081373] sha1_ssse3: Neither AVX nor SSSE3 is available/usable.
> [    1.083188] HugeTLB registered 2 MB page size, pre-allocated 0 pages
> [    1.088793] VFS: Disk quotas dquot_6.5.2
> [    1.088953] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
> [    1.089914] FS-Cache: Netfs 'nfs' registered for caching
> [    1.090231] NFS: Registering the id_resolver key type
> [    1.090334] Key type id_resolver registered
> [    1.090421] Key type id_legacy registered
> [    1.090510] nfs4filelayout_init: NFSv4 File Layout Driver Registering...
> [    1.090616] NTFS driver 2.1.30 [Flags: R/O].
> [    1.090858] fuse init (API version 7.20)
> [    1.091277] JFS: nTxBlock = 8192, nTxLock = 65536
> [    1.093937] SGI XFS with ACLs, security attributes, realtime, large
> block/inode numbers, no debug enabled
> [    1.094810] msgmni has been set to 32028
> [    1.096589] NET: Registered protocol family 38
> [    1.096881] Block layer SCSI generic (bsg) driver version 0.4
> loaded (major 253)
> [    1.097006] io scheduler noop registered
> [    1.097092] io scheduler deadline registered
> [    1.097185] io scheduler cfq registered (default)
> [    1.097841] input: Power Button as
> /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
> [    1.097968] ACPI: Power Button [PWRF]
> [    1.098312] ioatdma: Intel(R) QuickData Technology Driver 4.00
> [    1.098863] Non-volatile memory driver v1.3
> [    1.099083] Linux agpgart interface v0.103
> [    1.099305] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180
> seconds, margin is 60 seconds).
> [    1.099433] Hangcheck: Using getrawmonotonic().
> [    1.101560] brd: module loaded
> [    1.102655] loop: module loaded
> [    1.102739] HP CISS Driver (v 3.6.26)
> [    1.103313] nbd: registered device at major 43
> [    1.106213] Loading iSCSI transport class v2.0-870.
> [    1.107044] bnx2fc: Broadcom NetXtreme II FCoE Driver bnx2fc
> v1.0.12 (Jun 04, 2012)
> [    1.107661] iscsi: registered transport (tcp)
> [    1.107775] HP HPSA Driver (v 2.0.2-1)
> [    1.108083] ACPI: PCI Interrupt Link [I040] enabled at IRQ 44
> [    1.108186] hpsa 0000:03:00.0: MSIX
> [    1.108316] hpsa 0000:03:00.0: irq 72 for MSI/MSI-X
> [    1.108324] hpsa 0000:03:00.0: irq 73 for MSI/MSI-X
> [    1.108330] hpsa 0000:03:00.0: irq 74 for MSI/MSI-X
> [    1.108335] hpsa 0000:03:00.0: irq 75 for MSI/MSI-X
> [    1.108341] hpsa 0000:03:00.0: irq 76 for MSI/MSI-X
> [    1.108348] hpsa 0000:03:00.0: irq 77 for MSI/MSI-X
> [    1.108354] hpsa 0000:03:00.0: irq 78 for MSI/MSI-X
> [    1.108359] hpsa 0000:03:00.0: irq 79 for MSI/MSI-X
> [    1.126362] hpsa 0000:03:00.0: hpsa0: <0x323a> at IRQ 72 using DAC
> [    1.146555] scsi0 : hpsa
> [    1.149032] hpsa 0000:03:00.0: RAID              device c0b3t0l0 added.
> [    1.149128] hpsa 0000:03:00.0: Direct-Access     device c0b0t0l0 added.
> [    1.149452] scsi 0:3:0:0: RAID              HP       P410i
>   5.70 PQ: 0 ANSI: 5
> [    1.150022] scsi 0:0:0:0: Direct-Access     HP       LOGICAL VOLUME
>   5.70 PQ: 0 ANSI: 5
> [    1.150425] Broadcom NetXtreme II iSCSI Driver bnx2i v2.7.2.2 (Apr 25, 2012)
> [    1.150572] iscsi: registered transport (bnx2i)
> [    1.160024] sd 0:0:0:0: [sda] 143305920 512-byte logical blocks:
> (73.3 GB/68.3 GiB)
> [    1.160205] scsi 0:3:0:0: Attached scsi generic sg0 type 12
> [    1.160371] sd 0:0:0:0: Attached scsi generic sg1 type 0
> [    1.160380] sd 0:0:0:0: [sda] Write Protect is off
> [    1.160382] sd 0:0:0:0: [sda] Mode Sense: 6b 00 00 08
> [    1.160521] sd 0:0:0:0: [sda] Write cache: disabled, read cache:
> enabled, doesn't support DPO or FUA
> [    1.160741] bonding: Ethernet Channel Bonding Driver: v3.7.1 (April 27, 2011)
> [    1.161336]  sda: sda1 sda2 sda3
> [    1.162296] sd 0:0:0:0: [sda] Attached SCSI disk
> [    1.163200] tun: Universal TUN/TAP device driver, 1.6
> [    1.163291] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
> [    1.163523] cnic: Broadcom NetXtreme II CNIC Driver cnic v2.5.12
> (June 29, 2012)
> [    1.163690] bnx2x: Broadcom NetXtreme II 5771x/578xx 10/20-Gigabit
> Ethernet Driver bnx2x 1.72.51-0 (2012/06/18)
> [    1.164174] ACPI: PCI Interrupt Link [I030] enabled at IRQ 28
> [    1.346248] be2net 0000:04:00.0: irq 80 for MSI/MSI-X
> [    1.346255] be2net 0000:04:00.0: irq 81 for MSI/MSI-X
> [    1.346261] be2net 0000:04:00.0: irq 82 for MSI/MSI-X
> [    1.346267] be2net 0000:04:00.0: irq 83 for MSI/MSI-X
> [    1.529447] be2net 0000:04:00.0: Created only 5 receive queues
> [    1.660812] be2net 0000:04:00.0: eth0: Emulex OneConnect 10Gbps NIC port 0
> [    1.661145] ACPI: PCI Interrupt Link [I031] enabled at IRQ 29
> [    1.779381] be2net 0000:04:00.1: irq 84 for MSI/MSI-X
> [    1.779388] be2net 0000:04:00.1: irq 85 for MSI/MSI-X
> [    1.779394] be2net 0000:04:00.1: irq 86 for MSI/MSI-X
> [    1.779400] be2net 0000:04:00.1: irq 87 for MSI/MSI-X
> [    1.952591] be2net 0000:04:00.1: Created only 5 receive queues
> [    2.050038] be2net 0000:04:00.1: eth1: Emulex OneConnect 10Gbps NIC port 1
> [    2.050306] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> [    2.050438] ehci_hcd 0000:00:12.2: EHCI Host Controller
> [    2.050533] ehci_hcd 0000:00:12.2: new USB bus registered, assigned
> bus number 1
> [    2.050663] ehci_hcd 0000:00:12.2: applying AMD
> SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
> [    2.050812] ehci_hcd 0000:00:12.2: debug port 1
> [    2.050923] ehci_hcd 0000:00:12.2: irq 23, io mem 0xfd4c0000
> [    2.062539] ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00
> [    2.062649] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
> [    2.062744] usb usb1: New USB device strings: Mfr=3, Product=2,
> SerialNumber=1
> [    2.062865] usb usb1: Product: EHCI Host Controller
> [    2.062953] usb usb1: Manufacturer: Linux 3.6.3-p ehci_hcd
> [    2.063043] usb usb1: SerialNumber: 0000:00:12.2
> [    2.063351] hub 1-0:1.0: USB hub found
> [    2.063438] hub 1-0:1.0: 6 ports detected
> [    2.063609] ehci_hcd 0000:00:13.2: EHCI Host Controller
> [    2.063703] ehci_hcd 0000:00:13.2: new USB bus registered, assigned
> bus number 2
> [    2.063825] ehci_hcd 0000:00:13.2: applying AMD
> SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
> [    2.063978] ehci_hcd 0000:00:13.2: debug port 1
> [    2.064088] ehci_hcd 0000:00:13.2: irq 22, io mem 0xfd490000
> [    2.075861] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00
> [    2.075967] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
> [    2.076062] usb usb2: New USB device strings: Mfr=3, Product=2,
> SerialNumber=1
> [    2.076182] usb usb2: Product: EHCI Host Controller
> [    2.076270] usb usb2: Manufacturer: Linux 3.6.3-p ehci_hcd
> [    2.076360] usb usb2: SerialNumber: 0000:00:13.2
> [    2.076655] hub 2-0:1.0: USB hub found
> [    2.076741] hub 2-0:1.0: 6 ports detected
> [    2.076933] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
> [    2.077063] ohci_hcd 0000:00:12.0: OHCI Host Controller
> [    2.077158] ohci_hcd 0000:00:12.0: new USB bus registered, assigned
> bus number 3
> [    2.077297] ohci_hcd 0000:00:12.0: irq 22, io mem 0xfd4e0000
> [    2.079183] tsc: Refined TSC clocksource calibration: 2299.999 MHz
> [    2.079287] Switching to clocksource tsc
> [    2.136494] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
> [    2.136590] usb usb3: New USB device strings: Mfr=3, Product=2,
> SerialNumber=1
> [    2.136712] usb usb3: Product: OHCI Host Controller
> [    2.136799] usb usb3: Manufacturer: Linux 3.6.3-p ohci_hcd
> [    2.136889] usb usb3: SerialNumber: 0000:00:12.0
> [    2.137185] hub 3-0:1.0: USB hub found
> [    2.137274] hub 3-0:1.0: 3 ports detected
> [    2.137440] ohci_hcd 0000:00:12.1: OHCI Host Controller
> [    2.137534] ohci_hcd 0000:00:12.1: new USB bus registered, assigned
> bus number 4
> [    2.137669] ohci_hcd 0000:00:12.1: irq 22, io mem 0xfd4d0000
> [    2.193132] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
> [    2.193228] usb usb4: New USB device strings: Mfr=3, Product=2,
> SerialNumber=1
> [    2.193349] usb usb4: Product: OHCI Host Controller
> [    2.193437] usb usb4: Manufacturer: Linux 3.6.3-p ohci_hcd
> [    2.193526] usb usb4: SerialNumber: 0000:00:12.1
> [    2.193824] hub 4-0:1.0: USB hub found
> [    2.193912] hub 4-0:1.0: 3 ports detected
> [    2.194078] ohci_hcd 0000:00:13.0: OHCI Host Controller
> [    2.194175] ohci_hcd 0000:00:13.0: new USB bus registered, assigned
> bus number 5
> [    2.194311] ohci_hcd 0000:00:13.0: irq 23, io mem 0xfd4b0000
> [    2.253101] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
> [    2.253197] usb usb5: New USB device strings: Mfr=3, Product=2,
> SerialNumber=1
> [    2.253318] usb usb5: Product: OHCI Host Controller
> [    2.253406] usb usb5: Manufacturer: Linux 3.6.3-p ohci_hcd
> [    2.253495] usb usb5: SerialNumber: 0000:00:13.0
> [    2.253792] hub 5-0:1.0: USB hub found
> [    2.253880] hub 5-0:1.0: 3 ports detected
> [    2.254041] ohci_hcd 0000:00:13.1: OHCI Host Controller
> [    2.254134] ohci_hcd 0000:00:13.1: new USB bus registered, assigned
> bus number 6
> [    2.254270] ohci_hcd 0000:00:13.1: irq 23, io mem 0xfd4a0000
> [    2.313071] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
> [    2.313167] usb usb6: New USB device strings: Mfr=3, Product=2,
> SerialNumber=1
> [    2.313288] usb usb6: Product: OHCI Host Controller
> [    2.313375] usb usb6: Manufacturer: Linux 3.6.3-p ohci_hcd
> [    2.313465] usb usb6: SerialNumber: 0000:00:13.1
> [    2.313759] hub 6-0:1.0: USB hub found
> [    2.313847] hub 6-0:1.0: 3 ports detected
> [    2.314034] uhci_hcd: USB Universal Host Controller Interface driver
> [    2.314165] uhci_hcd 0000:02:00.4: UHCI Host Controller
> [    2.314260] uhci_hcd 0000:02:00.4: new USB bus registered, assigned
> bus number 7
> [    2.314390] uhci_hcd 0000:02:00.4: port count misdetected? forcing to 2 ports
> [    2.314503] uhci_hcd 0000:02:00.4: irq 44, io base 0x00003c00
> [    2.314617] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
> [    2.314711] usb usb7: New USB device strings: Mfr=3, Product=2,
> SerialNumber=1
> [    2.314832] usb usb7: Product: UHCI Host Controller
> [    2.314919] usb usb7: Manufacturer: Linux 3.6.3-p uhci_hcd
> [    2.315009] usb usb7: SerialNumber: 0000:02:00.4
> [    2.315292] hub 7-0:1.0: USB hub found
> [    2.315377] hub 7-0:1.0: 2 ports detected
> [    2.315654] usbcore: registered new interface driver uas
> [    2.315760] Initializing USB Mass Storage driver...
> [    2.315912] usbcore: registered new interface driver usb-storage
> [    2.316005] USB Mass Storage support registered.
> [    2.316133] usbcore: registered new interface driver ums-cypress
> [    2.316265] usbcore: registered new interface driver ums-datafab
> [    2.316397] usbcore: registered new interface driver ums-freecom
> [    2.316529] usbcore: registered new interface driver ums-isd200
> [    2.316662] usbcore: registered new interface driver ums-sddr09
> [    2.316796] usbcore: registered new interface driver ums-sddr55
> [    2.316927] usbcore: registered new interface driver ums-usbat
> [    2.317061] usbcore: registered new interface driver ldusb
> [    2.317261] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f0e:PS2M]
> at 0x60,0x64 irq 1,12
> [    2.318894] serio: i8042 KBD port at 0x60,0x64 irq 1
> [    2.318988] serio: i8042 AUX port at 0x60,0x64 irq 12
> [    2.319435] mousedev: PS/2 mouse device common for all mice
> [    2.319738] rtc_cmos 00:0a: RTC can wake from S4
> [    2.319966] rtc_cmos 00:0a: rtc core: registered rtc_cmos as rtc0
> [    2.320093] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
> [    2.320997] i2c /dev entries driver
> [    2.321454] piix4_smbus 0000:00:14.0: SMBus Host Controller at
> 0xb00, revision 0
> [    2.322104] i2c-parport-light: adapter type unspecified
> [    2.322275] usbcore: registered new interface driver i2c-tiny-usb
> [    2.628916] usb 7-1: new full-speed USB device number 2 using uhci_hcd
> [    2.772654] usb 7-1: New USB device found, idVendor=03f0, idProduct=7029
> [    2.772750] usb 7-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> [    2.772846] usb 7-1: Product: Virtual Keyboard
> [    2.772932] usb 7-1: Manufacturer: HP
> [    2.858804] EDAC MC: Ver: 3.0.0
> [    2.859136] AMD64 EDAC driver v3.4.0
> [    2.859258] EDAC amd64: DRAM ECC enabled.
> [    2.859364] EDAC amd64: F10h detected (node 0).
> [    2.859470] EDAC MC: DCT0 chip selects:
> [    2.859472] EDAC amd64: MC: 0:     0MB 1:     0MB
> [    2.859559] EDAC amd64: MC: 2:  4096MB 3:  4096MB
> [    2.859646] EDAC amd64: MC: 4:     0MB 5:     0MB
> [    2.859732] EDAC amd64: MC: 6:     0MB 7:     0MB
> [    2.859819] EDAC MC: DCT1 chip selects:
> [    2.859820] EDAC amd64: MC: 0:     0MB 1:     0MB
> [    2.859907] EDAC amd64: MC: 2:     0MB 3:     0MB
> [    2.859994] EDAC amd64: MC: 4:     0MB 5:     0MB
> [    2.860080] EDAC amd64: MC: 6:     0MB 7:     0MB
> [    2.860167] EDAC amd64: using x8 syndromes.
> [    2.860252] EDAC amd64: MCT channel count: 1
> [    2.860349] EDAC amd64: CS2: Registered DDR3 RAM
> [    2.860435] EDAC amd64: CS3: Registered DDR3 RAM
> [    2.860741] EDAC MC0: Giving out device to 'amd64_edac' 'F10h': DEV
> 0000:00:18.2
> [    2.860916] EDAC amd64: DRAM ECC enabled.
> [    2.861036] EDAC amd64: F10h detected (node 1).
> [    2.861153] EDAC MC: DCT0 chip selects:
> [    2.861155] EDAC amd64: MC: 0:     0MB 1:     0MB
> [    2.861244] EDAC amd64: MC: 2:  4096MB 3:  4096MB
> [    2.861333] EDAC amd64: MC: 4:     0MB 5:     0MB
> [    2.861421] EDAC amd64: MC: 6:     0MB 7:     0MB
> [    2.861509] EDAC MC: DCT1 chip selects:
> [    2.861510] EDAC amd64: MC: 0:     0MB 1:     0MB
> [    2.861598] EDAC amd64: MC: 2:     0MB 3:     0MB
> [    2.861687] EDAC amd64: MC: 4:     0MB 5:     0MB
> [    2.861775] EDAC amd64: MC: 6:     0MB 7:     0MB
> [    2.861863] EDAC amd64: using x8 syndromes.
> [    2.861950] EDAC amd64: MCT channel count: 1
> [    2.870633] EDAC amd64: CS2: Registered DDR3 RAM
> [    2.870721] EDAC amd64: CS3: Registered DDR3 RAM
> [    2.871048] EDAC MC1: Giving out device to 'amd64_edac' 'F10h': DEV
> 0000:00:19.2
> [    2.871215] EDAC amd64: DRAM ECC enabled.
> [    2.871326] EDAC amd64: F10h detected (node 2).
> [    2.871439] EDAC MC: DCT0 chip selects:
> [    2.871440] EDAC amd64: MC: 0:     0MB 1:     0MB
> [    2.871527] EDAC amd64: MC: 2:     0MB 3:     0MB
> [    2.871613] EDAC amd64: MC: 4:     0MB 5:     0MB
> [    2.871700] EDAC amd64: MC: 6:     0MB 7:     0MB
> [    2.871787] EDAC MC: DCT1 chip selects:
> [    2.871788] EDAC amd64: MC: 0:     0MB 1:     0MB
> [    2.871875] EDAC amd64: MC: 2:     0MB 3:     0MB
> [    2.871961] EDAC amd64: MC: 4:     0MB 5:     0MB
> [    2.872048] EDAC amd64: MC: 6:     0MB 7:     0MB
> [    2.872140] EDAC amd64: using x4 syndromes.
> [    2.872225] EDAC amd64: MCT channel count: 0
> [    2.872442] EDAC MC2: Giving out device to 'amd64_edac' 'F10h': DEV
> 0000:00:1a.2
> [    2.872595] EDAC amd64: DRAM ECC enabled.
> [    2.872697] EDAC amd64: F10h detected (node 3).
> [    2.872804] EDAC MC: DCT0 chip selects:
> [    2.872806] EDAC amd64: MC: 0:     0MB 1:     0MB
> [    2.872892] EDAC amd64: MC: 2:     0MB 3:     0MB
> [    2.872979] EDAC amd64: MC: 4:     0MB 5:     0MB
> [    2.873065] EDAC amd64: MC: 6:     0MB 7:     0MB
> [    2.873152] EDAC MC: DCT1 chip selects:
> [    2.873153] EDAC amd64: MC: 0:     0MB 1:     0MB
> [    2.873239] EDAC amd64: MC: 2:     0MB 3:     0MB
> [    2.873326] EDAC amd64: MC: 4:     0MB 5:     0MB
> [    2.873412] EDAC amd64: MC: 6:     0MB 7:     0MB
> [    2.873499] EDAC amd64: using x4 syndromes.
> [    2.873583] EDAC amd64: MCT channel count: 0
> [    2.873807] EDAC MC3: Giving out device to 'amd64_edac' 'F10h': DEV
> 0000:00:1b.2
> [    2.874016] EDAC PCI0: Giving out device to module 'amd64_edac'
> controller 'EDAC PCI controller': DEV '0000:00:18.2' (POLLED)
> [    2.874155] EFI Variables Facility v0.08 2004-May-17
> [    2.874246] No iBFT detected.
> [    2.876168] input: HP  Virtual Keyboard  as
> /devices/pci0000:00/0000:00:0a.0/0000:02:00.4/usb7/7-1/7-1:1.0/input/input1
> [    2.876445] hid-generic 0003:03F0:7029.0001: input,hidraw0: USB HID
> v1.01 Keyboard [HP  Virtual Keyboard ] on usb-0000:02:00.4-1/input0
> [    2.878078] input: HP  Virtual Keyboard  as
> /devices/pci0000:00/0000:00:0a.0/0000:02:00.4/usb7/7-1/7-1:1.1/input/input2
> [    2.878391] hid-generic 0003:03F0:7029.0002: input,hidraw1: USB HID
> v1.01 Mouse [HP  Virtual Keyboard ] on usb-0000:02:00.4-1/input1
> [    2.878567] usbcore: registered new interface driver usbhid
> [    2.878657] usbhid: USB HID core driver
> [    2.878888] Netfilter messages via NETLINK v0.30.
> [    2.878977] nfnl_acct: registering with nfnetlink.
> [    2.879076] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
> [    2.879409] ctnetlink v0.93: registering with nfnetlink.
> [    2.879509] NF_TPROXY: Transparent proxy support initialized, version 4.1.0
> [    2.879603] NF_TPROXY: Copyright (c) 2006-2007 BalaBit IT Ltd.
> [    2.879796] xt_time: kernel timezone is -0000
> [    2.880024] ip_tables: (C) 2000-2006 Netfilter Core Team
> [    2.880211] ipt_CLUSTERIP: ClusterIP Version 0.8 loaded successfully
> [    2.880311] arp_tables: (C) 2002 David S. Miller
> [    2.880423] TCP: bic registered
> [    2.880504] TCP: cubic registered
> [    2.880586] TCP: westwood registered
> [    2.880669] TCP: highspeed registered
> [    2.880752] TCP: hybla registered
> [    2.880834] TCP: htcp registered
> [    2.880915] TCP: vegas registered
> [    2.880997] TCP: veno registered
> [    2.881078] TCP: scalable registered
> [    2.881162] TCP: lp registered
> [    2.881243] TCP: yeah registered
> [    2.881324] TCP: illinois registered
> [    2.881407] Initializing XFRM netlink socket
> [    2.881825] NET: Registered protocol family 10
> [    2.882238] mip6: Mobile IPv6
> [    2.882324] ip6_tables: (C) 2000-2006 Netfilter Core Team
> [    2.882496] sit: IPv6 over IPv4 tunneling driver
> [    2.883034] NET: Registered protocol family 17
> [    2.883124] NET: Registered protocol family 15
> [    2.883225] Bridge firewalling registered
> [    2.883311] Ebtables v2.0 registered
> [    2.883440] NET: Registered protocol family 33
> [    2.883528] Key type rxrpc registered
> [    2.883611] Key type rxrpc_s registered
> [    2.883840] RxRPC: Registered security type 2 'rxkad'
> [    2.883928] 8021q: 802.1Q VLAN Support v1.8
> [    2.884023] Key type dns_resolver registered
> [    2.886498] console [netcon0] enabled
> [    2.886583] netconsole: network logging started
> [    2.886724] rtc_cmos 00:0a: setting system clock to 2012-10-22
> 12:08:10 UTC (1350907690)
> [    2.886848] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
> [    2.886939] EDD information not available.
> [    2.924187] kjournald starting.  Commit interval 5 seconds
> [    2.924219] EXT3-fs (sda2): mounted filesystem with ordered data mode
> [    2.924233] VFS: Mounted root (ext3 filesystem) readonly on device 8:2.
> [    2.926639] devtmpfs: mounted
> [    2.927655] Freeing unused kernel memory: 628k freed
> [    2.927991] Write protecting the kernel read-only data: 12288k
> [    2.935849] Freeing unused kernel memory: 1996k freed
> [    2.940643] Freeing unused kernel memory: 996k freed
> [    3.502580] udev[1565]: starting version 164
> [    4.178596] Adding 2088956k swap on /dev/sda1.  Priority:-1
> extents:1 across:2088956k
> [    4.254836] EXT3-fs (sda2): using internal journal
> [    4.523678] kjournald starting.  Commit interval 5 seconds
> [    4.523699] EXT3-fs (sda3): warning: maximal mount count reached,
> running e2fsck is recommended
> [    4.523788] EXT3-fs (sda3): using internal journal
> [    4.523790] EXT3-fs (sda3): mounted filesystem with ordered data mode
> [    4.901752] bonding: bond0: setting mode to active-backup (1).
> [    4.901931] bonding: bond0: Setting MII monitoring interval to 100.
> [    4.902095] bonding: bond0: Setting up delay to 200.
> [    4.902232] bonding: bond0: Setting down delay to 200.
> [    4.915244] bonding: bond0: Adding slave eth0.
> [    4.958268] 8021q: adding VLAN 0 to HW filter on device eth0
> [    4.964119] bonding: bond0: enslaving eth0 as a backup interface
> with an up link.
> [    4.973116] bonding: bond0: Adding slave eth1.
> [    5.031560] 8021q: adding VLAN 0 to HW filter on device eth1
> [    5.037410] bonding: bond0: enslaving eth1 as a backup interface
> with an up link.
> [    5.039401] bonding: bond0: Setting eth0 as primary slave.
> [    5.109624] IPv6: ADDRCONF(NETDEV_UP): bond0: link is not ready
> [    5.109720] 8021q: adding VLAN 0 to HW filter on device bond0
> [    5.121018] bonding: bond0: link status definitely up for interface
> eth0, 1000 Mbps full duplex.
> [    5.121151] bonding: bond0: making interface eth0 the new active one.
> [    5.122652] bonding: bond0: first active interface up!
> [    5.122744] bonding: bond0: link status definitely up for interface
> eth1, 1000 Mbps full duplex.
> [    5.122882] IPv6: ADDRCONF(NETDEV_CHANGE): bond0: link becomes ready
> [    8.784445] sshd (2696): /proc/2696/oom_adj is deprecated, please
> use /proc/2696/oom_score_adj instead.
> [   27.038835] nf_conntrack: automatic helper assignment is deprecated
> and it will be removed soon. Use the iptables CT target to attach
> helpers instead.
> [  228.849355] ------------[ cut here ]------------
> [  228.849529] WARNING: at fs/ext3/inode.c:1754
> ext3_journalled_writepage+0x55/0x1a7()
> [  228.849706] Hardware name: ProLiant BL465c G7
> [  228.849833] Pid: 2749, comm: flush-8:0 Not tainted 3.6.3-p #1
> [  228.849953] Call Trace:
> [  228.850070]  [<ffffffff81057884>] ? warn_slowpath_common+0x73/0x87
> [  228.850192]  [<ffffffff8115ccd6>] ? ext3_journalled_writepage+0x55/0x1a7
> [  228.850343]  [<ffffffff810a2833>] ? __writepage+0xa/0x21
> [  228.850474]  [<ffffffff810a31db>] ? write_cache_pages+0x206/0x2f8
> [  228.850598]  [<ffffffff810a2829>] ? set_page_dirty+0x5e/0x5e
> [  228.850721]  [<ffffffff81297ccb>] ? queue_unplugged+0x28/0x34
> [  228.850823]  [<ffffffff810a330b>] ? generic_writepages+0x3e/0x55
> [  228.850919]  [<ffffffff810f4eb0>] ? __writeback_single_inode+0x39/0xd1
> [  228.851016]  [<ffffffff810f5c69>] ? writeback_sb_inodes+0x206/0x392
> [  228.851112]  [<ffffffff810f5e5c>] ? __writeback_inodes_wb+0x67/0xa2
> [  228.851208]  [<ffffffff810f5ffa>] ? wb_writeback+0xfd/0x18b
> [  228.851315]  [<ffffffff810f61c5>] ? wb_do_writeback+0x13d/0x1a2
> [  228.851436]  [<ffffffff81061e9b>] ? add_timer_on+0x61/0x61
> [  228.851529]  [<ffffffff810f62a9>] ? bdi_writeback_thread+0x7f/0x13e
> [  228.851624]  [<ffffffff810f622a>] ? wb_do_writeback+0x1a2/0x1a2
> [  228.851719]  [<ffffffff810f622a>] ? wb_do_writeback+0x1a2/0x1a2
> [  228.851815]  [<ffffffff8106e134>] ? kthread+0x81/0x89
> [  228.851909]  [<ffffffff81607e74>] ? kernel_thread_helper+0x4/0x10
> [  228.852004]  [<ffffffff8106e0b3>] ? kthread_worker_fn+0xe0/0xe0
> [  228.852098]  [<ffffffff81607e70>] ? gs_change+0xb/0xb
> [  228.852189] ---[ end trace 67e723d93533674a ]---
> 
> 
> 
> -- 
> Fabio
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--k1lZvvs/B4yU6o8G
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-Debug-setting-page-dirty-on-RO-filesystem.patch"

>From 31fc1ccab9f3f136af32d8319eac0ecfbf034a3b Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Mon, 22 Oct 2012 17:41:20 +0200
Subject: [PATCH] Debug setting page dirty on RO filesystem

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext3/inode.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 7e87e37..a0ca1f5 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -1963,6 +1963,7 @@ out:
  */
 static int ext3_journalled_set_page_dirty(struct page *page)
 {
+	WARN_ON(page->mapping && page->mapping->host && IS_RDONLY(page->mapping->host));
 	SetPageChecked(page);
 	return __set_page_dirty_nobuffers(page);
 }
-- 
1.7.1


--k1lZvvs/B4yU6o8G--
