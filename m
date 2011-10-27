Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941Ab1J0Pbz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 11:31:55 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:26252 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752627Ab1J0Pbv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 11:31:51 -0400
Date: Thu, 27 Oct 2011 11:31:32 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Miche Baker-Harvey <miche@google.com>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com
Subject: Re: Regression: patch " hvc_console: display printk messages on
 console." causing infinite loop with 3.2-rc0 + Xen.
Message-ID: <20111027153132.GA2751@phenom.dumpdata.com>
References: <20111027053007.GA32765@phenom.dumpdata.com>
 <20111027054806.GA1377@suse.de>
 <CAB8Rdaq2r4Uc-WZK-k=wiEW8DKdixn+9dB7E4_XDL7k8jCMwSw@mail.gmail.com>
 <20111027150826.GC1157@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20111027150826.GC1157@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4EA9795E.0283:SCFMA922111,ss=1,re=-19.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > The "console [hvc0] enabled" message is coming from register_console() in
> > printk.c, and it doesn't have any loops.
> > It's called from hvc_console_init(), hvc_instantiate(), and hvc_alloc(),
> > none of which have loops.  The call in hvc_alloc() is the one I added, so
> > either I've inadvertently made one of the other two repeat (I'm guestting
> > hvc_instantiate() is the one you're using), or you're infinitely calling
> > hvc_alloc().  There's a calls to hvc_alloc() in hvc_xen.c::xen_hvc_init(),
> > and in init_port_console() in virtio_console.c, but again, no loops.
> >  Similarly for hvc_instantiate().
> > 
> > So, could I trouble you to put a breakpoint in register_console() and send
> > me the stack?
> 
> A dump_stack() should suffice I presume? Yeah let me do that.

Trying 192.168.101.14...
Connected to maxsrv1.
Escape character is '^]'.

PXELINUX 3.82 2009-06-09  Copyright (C) 1994-2009 H. Peter Anvin et al
Loading xen.gz... ok
Loading vmlinuz... ok
Loading initramfs.cpio.gz... ok
 __  __            _  _    _    _ _ _  ___ ____ _____ 
 \ \/ /___ _ __   | || |  / |  / / / |/ _ \___ \___  |
  \  // _ \ '_ \  
 /_/\_\___|_| |_|    |_|(_)_|  |_|_|_|\___/_____/_/   
                                                      
(XEN) Xen version 4.1-111027 (konrad@dumpdata.com) (gcc version 4.4.4 20100503 (Red Hat 4.4.4-2) (GCC) ) Thu Oct 27 11:16:34 EDT 2011
(XEN) Latest ChangeSet: Tue Oct 04 14:11:56 2011 +0200 23182:98306e1f58ba
(XEN) Console output is synchronous.
(XEN) Bootloader: unknown
(XEN) Command line: com1=115200,8n1 console=com1,vga guest_loglvl=all sync_console apic=debug
(XEN) Video information:
(XEN)  VGA is text mode 80x25, font 8x16
(XEN)  VBE/DDC methods: none; EDID transfer time: 2 seconds
(XEN)  EDID info not retrieved because no DDC retrieval method detected
(XEN) Disc information:
(XEN)  Found 0 MBR signatures
(XEN)  Found 0 EDD information structures
(XEN) Xen-e820 RAM map:
(XEN)  0000000000000000 - 000000000009d800 (usable)
(XEN)  000000000009d800 - 00000000000a0000 (reserved)
(XEN)  00000000000cc000 - 0000000000100000 (reserved)
(XEN)  0000000000100000 - 000000007fff0000 (usable)
(XEN)  000000007fff0000 - 0000000080000000 (reserved)
(XEN)  0000000080000000 - 00000000cfef0000 (usable)
(XEN)  00000000cfef0000 - 00000000cfef5000 (ACPI data)
(XEN)  00000000cfef5000 - 00000000cff7f000 (ACPI NVS)
(XEN)  00000000cff80000 - 00000000d0000000 (reserved)
(XEN)  00000000e0000000 - 00000000f0000000 (reserved)
(XEN)  00000000fec00000 - 00000000fec10000 (reserved)
(XEN)  00000000fee00000 - 00000000fee01000 (reserved)
(XEN)  00000000fff80000 - 0000000100000000 (reserved)
(XEN)  0000000100000000 - 0000000130000000 (usable)
(XEN) ACPI: RSDP 000F79B0, 0024 (r2 PTLTD )
(XEN) ACPI: XSDT CFEF0753, 009C (r1 DELL   PE_SC3    6040000 DELL        0)
(XEN)  6040000 DELL    F4240)
(XEN) ACPI: DSDT CFEF07EF, 33FC (r1 DELL   PE_SC3    6040000 MSFT  100000E)
(XEN) ACPI: FACS CFEF5FC0, 0040
(XEN) ACPI: TCPA CFEF3D53, 0032 (r1 Phoeni  x        6040000  TL         0)
(XEN) ACPI: SLIC CFEF3D85, 0024 (r1 DELL   PE_SC3    6040000 PTL         1)
(XEN) ACPI: SPCR CFEF3DA9, 0050 (r1 DELL   PE_SC3    6040000 PTL         1)
(XEN) ACPI: EINJ CFEF3DF9, 01B0 (r1 PTL    WHEAPTL   6040000 PTL         1)
(XEN) ACPI: HEST CFEF3FA9, 00A8 (r1 PTL    WHEAPTL   6040000 PTL         1)
(XEN) ACPI: BERT CFEF4051, 0030 (r1 PTL    WHEAPTL   6040000 PTL         1)
(XEN) ACPI: SSDT CFEF4081, 00E1 (r1 wheaos  wheaosc  6040000 INTL 20050624)
(XEN) ACPI: ERST CFEF4162, 0270 (r1 PTL    WHEAPTL   6040000 PTL         1)
(XEN) ACPI: SRAT CFEF43D2, 00E8 (r1 AMD    HAMMER    6040000 AMD         1)
(XEN) ACPI: SSDT CFEF44BA, 0A30 (r1 AMD    POWERNOW  6040000 AMD         1)
(XEN) ACPI: MCFG CFEF4EEA, 003C (r1 PTLTD    MCFG    6040000  LTP        0)
(XEN) ACPI: HPET CFEF4F26, 0038 (r1 PTLTD  HPETTBL   6040000  LTP        1)
(XEN) ACPI: APIC CFEF4F5E, 007A (r1 PTLTD  	 APIC    6040000  LTP        0)
(XEN) ACPI: BOOT CFEF4FD8, 0028 (r1 PTLTD  $SBFTBL$  6040000  LTP        1)
(XEN) System RAM: 4094MB (4192756kB)
(XEN) Domain heap initialised
(XEN) Processor #0 0:2 APIC version 16
(XEN) Processor #1 0:2 APIC version 16
(XEN) Processor #2 0:2 APIC version 16
(XEN) Processor #3 0:2 APIC version 16
(XEN) IOAPIC[0]: apic_id 4, version 17, address 0xfec00000, GSI 0-23
(XEN) Enabling APIC mode:  Flat.  Using 1 I/O APICs
(XEN) ERST table is invalid
(XEN) Using scheduler: SMP Credit Scheduler (credit)
(XEN) Detected 2109.738 MHz processor.
(XEN) Initing memory sharing.
(XEN) AMD-Vi: IOMMU not found!
(XEN) I/O virtualisation disabled
(XEN) ENABLING IO-APIC IRQs
(XEN)  -> Using new ACK method
(XEN) Platform timer is 25.000MHz HPET
ÿ(XEN) Allocated console ring of 16 KiB.
(XEN) HVM: ASIDs enabled.
(XEN) SVM: Support(XEN) Brought up 4 CPUs
(XEN) *** LOADING DOMAIN 0 ***
(XEN)  Xen  kernel: 64-bit, lsb, compat32
(XEN)  Dom0 kernel: 64-bit, PAE, lsb, paddr 0x1000000 -> 0x202f000
(XEN) PHYSICAL MEMORY ARRANGEMENT:
(XEN)  Dom0 alloc.:   0000000118000000->000000011c000000 (926310 pages to be allocated)
(XEN)  Init. ramdisk: 000000012170e000->000000012ffff200
(XEN) VIRTUAL MEMORY ARRANGEMENT:
(XEN)  Loaded kernel: ffffffff81000000->ffffffff8202f000
(XEN)  Init. ramdisk: ffffffff8202f000->ffffffff90920200
(XEN)  Phys-Mach map: ffffffff90921000->ffffffff910c6ac0
(XEN)  Start info:    ffffffff910c7000->ffffffff910c74b4
(XEN)  Page tables:   ffffffff910c8000->ffffffff91155000
(XEN)  Boot stack:    ffffffff91155000->ffffffff91156000
(XEN)  TOTAL:         ffffffff80000000->ffffffff91400000
(XEN)  ENTRY ADDRESS: ffffffff81aec200
(XEN) Dom0 has maximum 4 VCPUs
(XEN) Scrubbing Free RAM: .done.
(XEN) Xen trace buffers: disabled
(XEN) Std. Loglevel: Errors and warnings
(XEN) Guest Loglevel: All
(XEN) ***********RNING: CONSOLE OUTPUT IS SYNCHRONOUS
(XEN) ******* This option is intended to aid debugging of Xen by ensuring
(XEN) ******* that all output is synchronously delivered on the serial line.
(XEN) ******* However it can introduce SIGNIFICANT latencies and affect
(XEN) ******* timekeeping. It is NOT recommended for production use!
(XEN) **********************************************
(XEN) 3... 2... 1... 
(XEN) Xen is relinquishing VGA console.
(XEN) *** Serial input -> DOM0 (type 'CTRL-a' three times to switch input to Xen)
(X[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.lways_enable earlyprintk=xen console=tty console=hvc0 loglevel=10 xen-pciback.hide=(01:00.0)(01:00.1)(05:02.0)(05:02.1) pciback.hide=(01:00.0)(01:00.1) initcall_debug ttm.no_dma=1
[    0.000000] Freeing  9d-100 pfn range: 99 pages freed
[    0.000000] 1-1 mapping on 9d->100
[    0.000000] Freeing  7fff0-80000 pfn range: 16 pages freed
[    0.000000] 1-1 mapping on 7fff0->80000
[    0.000000] Freeing  cfef0-f4b58 pfn range: 150632 pages freed
[    0.000000] 1-1 mapping on cfef0->100000
[    0.000000] Released 150747 pages of unused memory
[    0.000000] Set 196995 page(s) to 1-1 mapping
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  Xen: 0000000000000000 - 000000000009d000 (usable)
[    0.000000]  Xen: 000000000009d800 - 0000000000100000 (reserved)
[    0.000000]  Xen: 0000000000100000 - 000000007fff0000 (usable)
[    0.000000]  Xen: 000000007fff0000 - 0000000080000000 (reserved)
[    0.000000]  Xen: 0000000080000000 - 00000000cfef0000 (usable)
[    0.000000]  Xen: 00000000cfef0000 - 00000000cfef5000 (ACPI data)
[    0.000000]  Xen: 00000000cfef5000 - 00000000cff7f000 (ACPI NVS)
[    0.000000]  Xen: 00000000cff80000 - 00000000d0000000 (reserved)
[    0.000000]  Xen: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  Xen: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  Xen: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  Xen: 00000000fff80000 - 0000000100000000 (reserved)
[    0.000000]  Xen: 0000000100000000 - 0000000130000000 (usable)
[    0.000000] bootconsole [xenboot0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI present.
[    0.000000] DMI: Dell Inc. PowerEdge T105 /0RR825, BIOS 1.3.2 08/20/2008
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x130000 max_arch_pfn = 0x400000000
[    0.000000] last_pfn = 0xc[    0.000000] initial memory mapped : 0 - 10921000
[    0.000000] Base memory trampoline at [ffff880000098000] 98000 size 2048 - 00cfef0000 page 4k
[    0.000000] kernel direct mapping tables up to cfef0000 @ 97b000-1000000
[    0.000000] xen: setting RW the range f70000 - 1000000
[    0.000000] init_memory_mapping: 0000000100000000-00000001300000006a000-cfef0000
[    0.000000] xen: setting RW the range cf6eb000 - cfef0000
[    0.000000] RAMDISK: 0202f000 - 10921000
[    0.000000] ACPI:  00000000000f79b0 00024 (v02 PTLTD )
[    0.000000] ACPI: XSDT 00000000cfef0753 0009C (v01 DELL   PE_SC3   06040000 DELL 00000000)
[    0.000000] ACPI: FACP 00000000cfef3c5f 000F4 (v03 DELL   PE_SC3   06040000 DELL 000F4240)
[    0.000000] ACPI: DSDT 00000000cfef07ef 033FC (v01 DELL   PE_SC3   06040000 MSFT 0100000E)
[    0.000000] ACPI: FACS 00000000cfef5fc0 00040
[    0.000000] ACPI: TCPA 00000000cfef3d53 00032 (v01 Phoeni  x       06040000  TL  00000000)
[    0.000000] ACPI: SLIC 00000000cfef3d85 00024 (v01 DELL   PE_SC3   06040000 PTL  00000001)
[    0.000000] ACPI: SPCR 00000000cfef3da9 00050 (v01 DELL   PE_SC3   06040000 PTL  00000001)
[    0.000000] ACPI: EINJ 00000000cfef3df9 001B0 (v01 PTL    WHEAPTL  06040000 PTL  00000001)
[    0.000000] ACPI: HEST 00000000cfef3fa9 000A8 (v01 PTL    WHEAPTL  06040000 PTL  00000001)
[    0.000000] ACPI: BERT 00000000cfef4051 00030 (v01 PTL    WHEAPTL  06040000 PTL  00000001)
[    0.000000] ACPI: SSDT 00000000cfef4081 000E1 (v01 wheaos  wheaosc 06040000 INTL 20050624)
[    0.000000] ACPI: ERST 00000000cfef4162 00270 (v01 PTL    WHEAPTL  06040000 PTL  00000001)
[    0.000000] ACPI: SRAT 00000000cfef43d2 000E8 (v01 AMD    HAMMER   06040000 AMD  00000001)
[    0.000000] ACPI: SSDT 00000000cfef44ba 00A30 (v01 AMD    POWERNOW 06040000 AMD  00000001)
[    0.000000] ACPI: MCFG 00000000cfef4eea 0003C (v01 PTLTD    MCFG   06040000  LTP 00000000)
[    0.000000] ACPI: HPET 00000000cfef4f26 00038 (v01 PTLTD  HPETTBL  06040000  LTP 00000001)
[    0.000000] ACPI: APIC 00000000cfef4f5e 0007A (v01 PTLTD  ? APIC   06040000  LTP 00000000)
[    0.000000] ACPI: BOOT 00000000cfef4fd8 00028 (v01 PTLTD  $SBFTBL$ 06040000  LTP 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] Scanning NUMA topology in Northbridge 24
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-0000000130000000
[    0.000000] Initmem setup node 0 0000000000000000-0000000130000000
[    0.000000]   NODE_DATA [00000000cfec9000 - 00000000cfeeffff]
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00130000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[4] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009d
[    0.000000]     0: 0x00000100 -> 0x0007fff0
[    0.000000]     0: 0x00080000 -> 0x000cfef0
[    0.000000]     0: 0x00100000 -> 0x00130000
[    0.000000] On node 0 totalpages: 1048173
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 1530 pages reserved
[    0.000000]   DMA zone: 2387 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 16320 pages used for memmap
[    0.000000]   DMA32 zone: 831264 pages, LIFO batch:31
[    0.000000]   Normal zone: 3072 pages used for memmap
[    0.000000]   Normal zone: 193536 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x8008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (a 0/0x0, fixing up to 0x10
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, version 255, address 0xfec00000, GSI 0-255
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x10de8201 base: 0xfed00000
[    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 272
[    0.000000] PM: Registered nosave memory: 000000000009d000 - 000000000009e000
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 000000007fff0000 - 0000000080000000
[    0.000000] PM: Registered nosave memory: 00000000cfef0000 - 00000000cfef5000
[    0.000000] PM: Registered nosave memory: 00000000cfef5000 - 00000000cff7f000
[    0.000000] PM: Registered nosave memory: 00000000cff7f000 - 00000000cff80000
[    0.000000] PM: Registered nosave memory: 00000000cff80000 - 00000000d0000000
[    0.000000] PM: Registered nosave memory: 00000000d0000000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000
[    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec10000
[    0.000000] PM: Registered nosave memory: 00000000fec10000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000fff80000
[    0.000000] PM: Registered nosave memory: 00000000fff80000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at d0000000 (gap: d0000000:10000000)
[    0.000000] Booting paravirtualized kernel on Xen
[    0.000000] Xen version: 4.1-111027 (preserve-AD)
[    0.000000] setup_percpu: NR_CPUS:4096 nr_cpumask_bits:4 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 28 pages/cpu @ffff8800cfe33000 s82944 r8192 d23552 u114688
[    0.000000] pcpu-alloc: s82944 r8192 d23552 u114688 alloc=28*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1027187
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: debug selinux=0 initrd_ignore_loglevel sysrq_always_enable earlyprintk=xen console=tty console=hvc0 loglevel=10 xen-pciback.hide=(01:00.0)(01:00.1)(05:02.0)(05:02.1) pciback.hide=(01:00.0)(01:00.1) initcall_debug ttm.no_dma=1
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Placing 64MB software IO TLB between ffff8800c7000000 - ffff8800cb000000
[    0.000000] software IO TLB at phys [    0.000000] Memory: 3003820k/4980736k available (6391k kernel code, 788044k absent, 1188872k reserved, 4703k data, 2448k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] NR_IRQS:262400 nr_irqs:1024 16
[    0.000000] xen: sci override: global_irq=9 trigger=0 polarity=1
[    0.000000] xen: registering gsi 9 triggering 0 polarity 1
[    0.000000] xen: --> pirq=9 -> irq=9 (gsi=9)
[    0.000000] xen: acpi sci 9
[    0.000000] xen: --> pirq=1 -> irq=1 (gsi=1)
[    0.000000] xen: --> pirq=2 -> irq=2 (gsi=2)
[    0.000000] xen: --> pirq=3 -> irq=3 (gsi=3)
[    0.000000] xen: --> pirq=4 -> irq=4 (gsi=4)
[    0.000000] xen: --> pirq=5 -> irq=5 (gsi=5)
[    0.000000] xen: --> pirq=6 -> irq=6 (gsi=6)
[    0.000000] xen: --> pirq=7 -> irq=7 (gsi=7)
[    0.000000] xen: --> pirq=8 -> irq=8 (gsi=8)
[    0.000000] xen_map_pirq_gsi: returning irq 9 for gsi 9
[    0.000000] xen: --> pirq=9 -> irq=9 (gsi=9)
[    0.000000] xen: --> pirq=10 -> irq=10 (gsi=10)
[    0.000000] xen: --> pirq=11 -> irq=11 (gsi=11)
[    0.000000] xen: --> pirq=12 -> irq=12 (gsi=12)
[    0.000000] xen: --> pirq=13 -> irq=13 (gsi=13)
[    0.000000] xen: --> pirq=14 -> irq=14 (gsi=14)
[    0.000000] xen: --> pirq=15 -> irq=15 (gsi=15)
[    0.000000] kmemleak: Early log buffer exceeded, please increase DEBUG_KMEMLEAK_EARLY_LOG_SIZE
[    0.000000] kmemleak: Kernel memory leak detector disabled
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] Pid: 0, comm: swapper Not tainted 3.1.0-04893-g138c4ae-dirty #1
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff8109e15e>] ? register_console+0x1ae/0x390
[    0.000000]  [<ffffffff813ae83d>] hvc_instantiate+0x2d/0xd0
[    0.000000]  [<ffffffff813aea49>] xen_cons_init+0x49/0x50
[    0.000000]  [<ffffffff81b1f261>] console_init+0x19/0x2a
[    0.000000]  [<ffffffff81aecda6>] start_kernel+0x2d9/0x408
[    0.000000]  [<ffffffff81aec346>] x86_64_start_reservations+0x131/0x135
[    0.000000]  [<ffffffff81aefb49>] xen_start_kernel+0x612/0x619
[    0.000000] console [hvc0] enabled, bootconsole disabled
[    0.000000] console [hvc0] enabled, bootconsole disabled
[    0.000000] Xen: using vcpuop timer interface
[    0.000000] installing Xen timer for CPU 0
[    0.000000] Detected 2109.738 MHz processor.
[    0.000999] Calibrating delay loop (skipped), value calculated using timer frequency.. 4219.47 BogoMIPS (lpj=2109738)
[    0.000999] pid_max: default: 32768 minimum: 301
[    0.001051] Security Framework initialized
[    0.001999] SELinux:  Disabled at boot.
[    0.003840] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.006658] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.007725] Mount-cache hash table entries: 256
[    0.008323] Initializing cgroup subsys cpuacct
[    0.009009] Initializing cgroup subsys freezer
[    0.010080] tseg: 00cff80000
[    0.011006] CPU: Physical Processor ID: 0
[    0.011998] CPU: Processor Core ID: 0
[    0.011998] using AMD E400 aware idle routine
[    0.013338] ACPI: Core revision 20110623
[    0.025025] ftrace: allocating 23089 entries in 91 pages
[    0.027130] cpu 0 spinlock event irq 273
[    0.028099] calli0x0/0x12 @ 1
[    0.028998] initcall trace_init_flags_sys_enter+0x0/0x12 returned 0 after 0 usecs
[    0.028998] calling  init_hw_perf_events+0x0/0x44b @ 1
[    0.028998] Performance Events: (XEN) traps.c:2432:d0 Domain attempted WRMSR 00000000c0010004 from 0x00000812a205b8c2 to 0x000000000000abcd.
Broken PMU hardware detected, using software events only.
[    0.030997] initcall init_hw_perf_events+0x0/0x44b returned 0 after 1952 usecs
[    0.030997] calling  register_trigger_all_cpu_backtrace+0x0/0x1f @ 1
[    0.030997] initcall register_trigger_all_cpu_backtrace+0x0/0x1f returned 0 after 0 usecs
[    0.030997] calling  migration_init+0x0/0x6d @ 1
[    0.030997] initcall migration_init+0x0/0x6d returned 0 after 0 usecs
[    0.030997] calling  spawn_ksoftirqd+0x0/0x53 @ 1
[    0.033013] initcall spawn_ksoftirqd+0x0/0x53 returned 0 after 2929 usecs
[    0.033997] calling  init_workqueues+0x0/0x2ae @ 1
[    0.036091] initcall init_workqueues+0x0/0x2ae returned 0 after 2929 usecs
[    0.036997] calling  cpu_stop_init+0x0/0xab @ 1
[    0.039026] initcall cpu_stop_init+0x0/0xab returned 0 after 2929 usecs
[    0.039997] calling  rcu_scheduler_really_started+0x0/0x12 @ 1
[    0.039997] initcall rcu_scheduler_really_started+0x0/0x12 returned 0 after 0 usecs
[    0.039997] calling  relay_init+0x0/0x14 @ 1
[    0.039997] initcall relay_init+0x0/0x14 returned 0 after 0 usecs
[    0.039997] calling  tracer_alloc_buffers+0x0/0x1cf @ 1
[    0.039997] initcall tracer_alloc_buffers+0x0/0x1cf returned 0 after 0 usecs
[    0.039997] calling  init_trace_printk+0x0/0x12 @ 1
[    0.039997] initcall init_trace_printk+0x0/0x12 returned 0 after 0 usecs
[    0.039997] calling  mce_amd_init+0x0/0x17f @ 1
[    0.039997] MCE: In-kernel MCE decoding enabled.
[    0.039997] initcall mce_amd_init+0x0/0x17f returned 0 after 0 usecs
[    0.039997] NMI watchdog disabled (cpu0): hardware events not enabled
[    0.046023] installing Xen timer for CPU 1
[    0.047017] cpu 1 spinlock event irq 279
[    0.048183] NMI watchdog disabl[    0.055018] installing Xen timer for CPU 2
[    0.056013] cpu 2 spinlock event irq 285
[    0.057156] NMI watchdog disabl
[    0.069010] Brought up 4 CPUs
[    0.071204] calling  ipc_ns_init+0x0/0x14 @ 1
[    0.071993] initcall ipc_ns_init+0x0/0x14 returned 0 after 0 usecs
[    0.071993] calling  init_mmap_min_addr+0x0/0x26 @ 1
[    0.071993] initcall init_mmap_min_addr+0x0/0x26 returned 0 after 0 usecs
[    0.071993] calling  init_cpufreq_transition_notifier_list+0x0/0x1b @ 1
[    0.071993] initcall init_cpufreq_transition_notifier_list+0x0/0x1b returned 0 after 0 usecs
[    0.071993] calling  net_ns_init+0x0/0xf7 @ 1
[    0.072266] initcall net_ns_init+0x0/0xf7 returned 0 after 976 usecs
[    0.072993] calling  e820_mark_nvs_memory+0x0/0x41 @ 1
[    0.072993] PM: Registering ACPI NVS region at cfef5000 (565248 bytes)
[    0.073131] initcall e820_mark_nvs_memory+0x0/0x41 returned 0 after 976 usecs
[    0.073993] calling  cpufreq_tsc+0x0/0x37 @ 1
[    0.073993] initcall cpufreq_tsc+0x0/0x37 returned 0 after 0 usecs
[    0.073993] calling  pci_reboot_init+0x0/0x14 @ 1
[    0.073993] initcall pci_reboot_init+0x0/0x14 returned 0 after 0 usecs
[    0.073993] calling  init_lapic_sysfs+0x0/0x20 @ 1
[    0.073993] initcall init_lapic_sysfs+0x0/0x20 returned 0 after 0 usecs
[    0.073993] calling  init_smp_flush+0x0/0x3d @ 1
[    0.073993] initcall init_smp_flush+0x0/0x3d returned 0 after 0 usecs
[    0.073993] calling  alloc_frozen_cpus+0x0/0x30 @ 1
[    0.073993] initcall alloc_frozen_cpus+0x0/0x30 returned 0 after 0 usecs
[    0.073993] calling  sysctl_init+0x0/0x32 @ 1
[    0.074047] initcall sysctl_init+0x0/0x32 returned 0 after 976 usecs
[    0.074993] calling  ksysfs_init+0x0/0x94 @ 1
[    0.074993] initcall ksysfs_init+0x0/0x94 returned 0 after 0 usecs
[    0.074993] calling  init_jiffies_clocksource+0x0/0x12 @ 1
[    0.074993] initcall init_jiffies_clocksource+0x0/0x12 returned 0 after 0 usecs
[    0.074993] calling  pm_init+0x0/0x3e @ 1
[    0.074993] initcall pm_init+0x0/0x3e returned 0 after 0 usecs
[    0.074993] calling  pm_disk_init+0x0/0x19 @ 1
[    0.074993] initcall pm_disk_init+0x0/0x19 returned 0 after 0 usecs
[    0.074993] calling  swsusp_header_init+0x0/0x40 @ 1
[    0.074993] initcall swsusp_header_init+0x0/0x40 returned 0 after 0 usecs
[    0.074993] calling  init_zero_pfn+0x0/0x1f @ 1
[    0.074993] initcall init_zero_pfn+0x0/0x1f returned 0 after 0 usecs
[    0.074993] calling  fsnotify_init+0x0/0x26 @ 1
[    0.074993] initcall fsnotify_init+0x0/0x26 returned 0 after 0 usecs
[    0.074993] calling  filelock_init+0x0/0x2a @ 1
[    0.074993] initcall filelock_init+0x0/0x2a returned 0 after 0 usecs
[    0.074993] calling  init_misc_binfmt+0x0/0x44 @ 1
[    0.074993] initcall init_misc_binfmt+0x0/0x44 returned 0 after 0 usecs
[    0.074993] calling  init_script_binfmt+0x0/0x14 @ 1
[    0.074993] initcall init_script_binfmt+0x0/0x14 returned 0 after 0 usecs
[    0.074993] calling  init_elf_binfmt+0x0/0x14 @ 1
[    0.074993] initcall init_elf_binfmt+0x0/0x14 returned 0 after 0 usecs
[    0.074993] calling  init_compat_elf_binfmt+0x0/0x14 @ 1
[    0.074993] initcall init_compat_elf_binfmt+0x0/0x14 returned 0 after 0 usecs
[    0.074993] calling  debugfs_init+0x0/0x5c @ 1
[    0.074993] initcall debugfs_init+0x0/0x5c returned 0 after 0 usecs
[    0.074993] calling  random32_init+0x0/0xdb @ 1
[    0.074993] initcall random32_init+0x0/0xdb returned 0 after 0 usecs
[    0.074993] calling  virtio_init+0x0/0x30 @ 1
[    0.075081] kworker/u:0 used greatest stack depth: 5288 bytes left
[    0.075114] initcall virtio_init+0x0/0x30 returned 0 after 976 usecs
[    0.075114] calling  __gnttab_init+0x0/0x22 @ 1
[    0.075114] Grant table initialized
[    0.075114] initcall __gnttab_init+0x0/0x22 returned 0 after 0 usecs
[    0.075114] calling  early_resume_init+0x0/0x1d0 @ 1
[    0.075114] RTC time: 11:26:08, date: 10/26/11
[    0.075114] initcall early_resume_init+0x0/0x1d0 returned 0 after 0 usecs
[    0.075114] calling  cpufreq_core_init+0x0/0xb2 @ 1
[    0.075114] initcall cpufreq_core_init+0x0/0xb2 returned 0 after 0 usecs
[    0.075114] calling  cpuidle_init+0x0/0x40 @ 1
[    0.075114] initcall cpuidle_init+0x0/0x40 returned -19 after 0 usecs
[    0.075119] calling  sock_init+0x0/0x83 @ 1
[    0.075185] initcall sock_init+0x0/0x83 returned 0 after 0 usecs
[    0.075189] calling  net_inuse_init+0x0/0x26 @ 1
[    0.075197] initcall net_inuse_init+0x0/0x26 returned 0 after 0 usecs
[    0.075201] calling  netpoll_init+0x0/0x31 @ 1
[    0.075205] initcall netpoll_init+0x0/0x31 returned 0 after 0 usecs
[    0.075209] calling  netlink_proto_init+0x0/0x1c2 @ 1
[    0.075217] NET: Registered protocol family 16
[    0.075233] initcall netlink_proto_init+0x0/0x1c2 returned 0 after 0 usecs
[    0.075237] calling  bdi_class_init+0x0/0x4d @ 1
[    0.075366] initcall bdi_class_init+0x0/0x4d returned 0 after 0 usecs
[    0.075366] calling  kobject_uevent_init+0x0/0x21 @ 1
[    0.075366] initcall kobject_uevent_init+0x0/0x21 returned 0 after 0 usecs
[    0.075366] calling  pcibus_class_init+0x0/0x19 @ 1
[    0.075366] initcall pcibus_class_init+0x0/0x19 returned 0 after 0 usecs
[    0.075366] calling  pci_driver_init+0x0/0x12 @ 1
[    0.218045] initcall pci_driver_init+0x0/0x12 returned 0 after 139631 usecs
[    0.218975] calling  backlight_class_init+0x0/0x5d @ 1
[    0.219048] initcall backlight_class_init+0x0/0x5d returned 0 after 976 usecs
[    0.219975] calling  video_output_class_init+0x0/0x19 @ 1
[    0.220164] initcall video_output_class_init+0x0/0x19 returned 0 after 976 usecs
[    0.220975] calling  xenbus_init+0x0/0x2af @ 1
[    0.221059] initcall xenbus_init+0x0/0x2af returned 0 after 976 usecs
[    0.221975] calling  tty_class_init+0x0/0x38 @ 1
[    0.222162] initcall tty_class_init+0x0/0x38 returned 0 after 976 usecs
[    0.222975] calling  vtconsole_class_init+0x0/0xc2 @ 1
[    0.223077] initcall vtconsole_class_init+0x0/0xc2 returned 0 after 976 usecs
[    0.223974] calling  wakeup_sources_debugfs_init+0x0/0x2b @ 1
[    0.223974] initcall wakeup_sources_debugfs_init+0x0/0x2b returned 0 after 0 usecs
[    0.223974] calling  register_node_type+0x0/0x12 @ 1
[    0.224166] initcall register_node_type+0x0/0x12 returned 0 after 976 usecs
[    0.224974] calling  i2c_init+0x0/0x70 @ 1
[    0.225080] initcall i2c_init+0x0/0x70 returned 0 after 976 usecs
[    0.225974] calling  amd_postcore_init+0x0/0x157 @ 1
[    0.226119] node 0 link 0: io port [1000, 4fff]
[    0.226983] node 0 link 0: io port [5000, fffff]
[    0.227991] TOM: 00000000d0000000 aka 3328M
[    0.228981] node 0 link 0: mmio [d0000000, d05fffff]
[    0.230146] node 0 link 0: mmio [fed00000, fed0ffff]
[    0.230982] node 0 link 0: mmio [d8000000, dfffffff]
[    0.231983] node 0 link 0: mmio [fec00000, fec0ffff]
[    0.232980] node 0 link 0: mmio [e0000000, efffffff]
[    0.233981] node 0 link 0: mmio [a0000, bffff]
[    0.234981] node 0 link 0: mmio [f0000000, fe0bffff]
[    0.235978] TOM2: 0000000130000000 aka 4864M
[    0.236973] bus: [00, ff] on node 0 link 0
[    0.236973] bus: 00 index 0 [io  0x0000-0xffff]
[    0.236973] bus: 00 index 1 [mem 0xd0000000-0xd7ffffff]
[    0.236973] bus: 00 index 2 [mem 0xfec10000-0xffffffff]
[    0.236973] bus: 00 index 3 [mem 0xd8000000-0xfebfffff]
[    0.236973] bus: 00 index 4 [mem 0xfec00000-0xfec0ffff]
[    0.236973] bus: 00 index 5 [mem 0x000a0000-0x000bffff]
[    0.236973] bus: 00 index 6 [mem 0x130000000-0xfcffffffff]
[    0.236990] Extended Config Space enabled on 1 nodes
[    0.238119] initcall amd_postcore_init+0x0/0x157 returned 0 after 12693 usecs
[    0.238972] calling  arch_kdebugfs_init+0x0/0x258 @ 1
[    0.238972] initcall arch_kdebugfs_init+0x0/0x258 returned 0 after 0 usecs
[    0.238972] calling  configure_trampolines+0x0/0x26 @ 1
[    0.238972] initcall configure_trampolines+0x0/0x26 returned 0 after 0 usecs
[    0.238972] calling  mtrr_if_init+0x0/0x78 @ 1
[    0.238972] initcall mtrr_if_init+0x0/0x78 returned -19 after 0 usecs
[    0.238972] calling  ffh_cstate_init+0x0/0x2a @ 1
[    0.238972] initcall ffh_cstate_init+0x0/0x2a returned -1 after 0 usecs
[    0.238972] initcall ffh_cstate_init+0x0/0x2a returned with error code -1 
[    0.238972] calling  activate_jump_labels+0x0/0x28 @ 1
[    0.238972] initcall activate_jump_labels+0x0/0x28 returned 0 after 0 usecs
[    0.238972] calling  dynamic_debug_init+0x0/0x118 @ 1
[    0.239026] initcall dynamic_debug_init+0x0/0x118 returned 0 after 976 usecs
[    0.239972] calling  acpi_pci_init+0x0/0x61 @ 1
[    0.239972] ACPI: bus type pci registered
[    0.239972] initcall acpi_pci_init+0x0/0x61 returned 0 after 0 usecs
[    0.239972] calling  setup_vcpu_hotplug_event+0x0/0x22 @ 1
[    0.239972] initcall setup_vcpu_hotplug_event+0x0/0x22 returned 0 after 0 usecs
[    0.239972] calling  register_xen_pci_notifier+0x0/0x33 @ 1
[    0.239972] initcall register_xen_pci_notifier+0x0/0x33 returned 0 after 0 usecs
[    0.239972] calling  dmi_id_init+0x0/0x329 @ 1
[    0.240164] initcall dmi_id_init+0x0/0x329 returned 0 after 976 usecs
[    0.240972] calling  pci_arch_init+0x0/0x69 @ 1
[    0.240972] PCI: MMCONFIG for domain 0000 [bus 00-04] at [mem 0xe0000000-0xe04fffff] (base 0xe0000000)
[    0.240972] PCI: MMCONFIG at [mem 0xe0000000-0xe04fffff] reserved in E820
[    0.243098] PCI: Using configuration type 1 for base access
[    0.243972] initcall pci_arch_init+0x0/0x69 returned 0 after 2929 usecs
[    0.243972] calling  topology_init+0x0/0xa1 @ 1
[    0.244207] initcall topology_init+0x0/0xa1 returned 0 after 976 usecs
[    0.244971] calling  mtrr_init_finialize+0x0/0x36 @ 1
[    0.244971] initcall mtrr_init_finialize+0x0/0x36 returned 0 after 0 usecs
[    0.244971] calling  init_vdso+0x0/0x135 @ 1
[    0.244971] initcall init_vdso+0x0/0x135 returned 0 after 0 usecs
[    0.244971] calling  sysenter_setup+0x0/0x2dd @ 1
[    0.244971] initcall sysenter_setup+0x0/0x2dd returned 0 after 0 usecs
[    0.244971] calling  param_sysfs_init+0x0/0x1b5 @ 1
[    0.260062] initcall param_sysfs_init+0x0/0x1b5 returned 0 after 15622 usecs
[    0.260969] calling  pm_sysrq_init+0x0/0x20srq_init+0x0/0x20 returned 0 after 0 usecs
[    0.260969] calling  default_bdi_init+0x0/0xaa @ 1
[    0.261086] initcall default_bdi_init+0x0/0xaa returned 0 after 976 usecs
[    0.261969] calling  init_bio+0x0/0xf2 @ 1
[    0.261969] bio: create slab <bio-0> at 0
[    0.261969] initcall init_bio+0x0/0xf2 returned 0 after 0 usecs
[    0.261969] calling  fsnotify_notification_init+0x0/0x8b @ 1
[    0.261969] initcall fsnotify_notification_init+0x0/0x8b returned 0 after 0 usecs
[    0.261969] calling  cryptomgr_init+0x0/0x12 @ 1
[    0.261969] initcall cryptomgr_init+0x0/0x12 returned 0 after 0 usecs
[    0.261969] calling  blk_settings_init+0x0/0x2c @ 1
[    0.261969] initcall blk_settings_init+0x0/0x2c returned 0 after 0 usecs
[    0.261969] calling  blk_ioc_init+0x0/0x2a @ 1
[    0.261969] initcall blk_ioc_init+0x0/0x2a returned 0 after 0 usecs
[    0.261969] calling  blk_softirq_init+0x0/0x70 @ 1
[    0.261969] initcall blk_softirq_init+0x0/0x70 returned 0 after 0 usecs
[    0.261969] calling  blk_iopoll_setup+0x0/0x70 @ 1
[    0.261969] initcall blk_iopoll_setup+0x0/0x70 returned 0 after 0 usecs
[    0.261969] calling  genhd_device_init+0x0/0x85 @ 1
[    0.262166] initcall genhd_device_init+0x0/0x85 returned 0 after 976 usecs
[    0.262969] calling  pci_slot_init+0x0/0x50 @ 1
[    0.262969] initcall pci_slot_init+0x0/0x50 returned 0 after 0 usecs
[    0.262969] calling  fbmem_init+0x0/0x98 @ 1
[    0.263039] initcall fbmem_init+0x0/0x98 returned 0 after 976 usecs
[    0.263969] calling  acpi_init+0x0/0xbc @ 1
[    0.263969] ACPI: Added _OSI(Module Device)
[    0.263969] ACPI: Added _OSI(Processor Device)
[    0.263969] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.263969] ACPI: Added _OSI(Processor Aggregator Device)
[    0.265128] ACPI: EC: Look up EC in DSDT
[    0.265968] \_SB_:_OSC evaluation returned wrong type
[    0.265968] _OSC reqg
[    0.295088] initcall acpi_init+0x0/0xbc returned 0 after 31245 usecs
[    0.295964] calling  dock_init+0x0/0xa5 @ 1
[    296964] initcall dock_init+0x0/0xa5 returned 0 after 976 usecs
[    0.296964] calling  acpi_pci_root_init+0x0/0x2d @ 1
[    0.296964] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.297124] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.298252] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7]
[    0.298963] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff]
[    0.298963] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.298963] pci_root PNP0A03:00: host bridge window [mem 0x000c0000-0x000dffff]
[    0.298963] pci_root PNP0A03:00: host bridge window [mem 0xd0000000-0xfebfffff]
[    0.298963] pci_root PNP0A03:00: host bridge window [mem 0xfed40000-0xfed8ffff]
[    0.298963] pci 0000:00:00.0: [10de:005e] type 0 class 0x000580
[    0.298984] pci 0000:00:01.0: [10de:0051] type 0 class 0x000601
[    0.299963] pci 0000:00:01.0: reg 10: [io  0x8c00-0x8fff]
[    0.300105] pci 0000:00:01.1: [10de:0052] type 0 class 0x000c05
[    0.300963] pci 0000:00:01.1: reg 10: [io  0x2080-0x209f]
[    0.300963] pci 0000:00:01.1: reg 20: [io  0x2040-0x207f]
[    0.300963] pci 0000:00:01.1: reg 24: [io  0x2000-0x203f]
[    0.300963] pci 0000:00:01.1: PME# supported from D3hot D3cold
[    0.300963] pci 0000:00:01.1: PME# disabled
[    0.300963] pci 0000:00:02.0: [10de:005a] type 0 class 0x000c03
[    0.300963] pci 0000:00:02.0: reg 10: [mem 0xd0000000-0xd0000fff]
[    0.300963] pci 0000:00:02.0: supports D1 D2
[    0.300963] pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.300963] pci 0000:00:02.0: PME# disabled
[    0.300963] pci 0000:00:02.1: [10de:005b] type 0 class 0x000c03
[    0.300963] pci 0000:00:02.1: reg 10: [mem 0xd0001000-0xd00010ff]
[    0.300963] pci 0000:00:02.1: supports D1 D2
[    0.300963] pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.300963] pci 0000:00:02.1: PME# disabled
[    0.300963] pci 0000:00:07.0: [10de:0054] type 0 class 0x000101
[    0.300963] pci 0000:00:07.0: reg 10: [io  0x20f0-0x20f7]
[    0.300963] pci 0000:00:07.0: reg 14: [io  0x20e0-0x20e3]
[    0.300963] pci 0000:00:07.0: reg 18: [io  0x20d0-0x20d7]
[    0.300963] pci 0000:00:07.0: reg 1c: [io  0x20c0-0x20c3]
[    0.300963] pci 0000:00:07.0: reg 20: [io  0x20b0-0x20bf]
[    0.300963] pci 0000:00:07.0: reg 24: [mem 0xd0002000-0xd0002fff]
[    0.300963] pci 0000:00:08.0: [10de:0055] type 0 class 0x000101
[    0.300963] pci 0000:00:08.0: reg 10: [io  0x2440-0x2447]
[    0.300963] pci 0000:00:08.0: reg 14: [io  0x2430-0x2433]
[    0.300963] pci 0000:00:08.0: reg 18: [io  0x2420-0x2427]
[    0.300963] pci 0000:00:08.0: reg 1c: [io  0x2410-0x2413]
[    0.300963] pci 0000:00:08.0: reg 20: [io  0x2400-0x240f]
[    0.300963] pci 0000:00:08.0: reg 24: [mem 0xd0003000-0xd0003fff]
[    0.300963] pci 0000:00:09.0: [10de:005c] type 1 class 0x000604
[    0.300963] pci 0000:00:0b.0: [10de:005d] type 1 class 0x000604
[    0.300963] pci 0000:00:0b.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.300963] pci 0000:00:0b.0: PME# disabled
[    0.301003] pci 0000:00:0c.0: [10de:005d] type 1 class 0x000604
[    0.301963] pci 0000:00:0c.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.301963] pci 0000:00:0c.0: PME# disabled
[    0.301963] pci 0000:00:0d.0: [10de:005d] type 1 class 0x000604
[    0.301963] pci 0000:00:0d.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.301963] pci 0000:00:0d.0: PME# disabled
[    0.301963] pci 0000:00:0e.0: [10de:005d] type 1 class 0x000604
[    0.301963] pci 0000:00:0e.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.301963] pci 0000:00:0e.0: PME# disabled
[    0.301963] pci 0000:00:18.0: [1022:1200] type 0 class 0x000600
[    0.301963] pci 0000:00:18.1: [1022:1201] type 0 class 0x000600
[    0.301963] pci 0000:00:18.2: [1022:1202] type 0 class 0x000600
[    0.301963] pci 0000:00:18.3: [1022:1203] type 0 class 0x000600
[    0.301963] pci 0000:00:18.4: [1022:1204] type 0 class 0x000600
[    0.302123] pci 0000:01:07.0: [1077:6312] type 0 class 0x000c04
[    0.302963] pci 0000:01:07.0: reg 10: [io  0x3000-0x30ff]
[    0.302963] pci 0000:01:07.0: reg 14: [mem 0xd0110000-0xd0110fff]
[    0.302963] pci 0000:01:07.0: reg 30: [mem 0x00000000-0x0001ffff pref]
[    0.302963] pci 0000:01:08.0: [1002:515e] type 0 class 0x000300
[    0.302963] pci 0000:01:08.0: reg 10: [mem 0xd8000000-0xdfffffff pref]
[    0.302963] pci 0000:01:08.0: reg 14: [io  0x3400-0x34ff]
[    0.302963] pci 0000:01:08.0: reg 18: [mem 0xd0100000-0xd010ffff]
[    0.302963] pci 0000:01:08.0: reg 30: [mem 0x00000000-0x0001ffff pref]
[    0.302963] pci 0000:01:08.0: supports D1 D2
[    0.302963] pci 0000:00:09.0: PCI bridge to [bus 01-01]
[    0.302963] pci 0000:00:09.0:   bridge window [io  0x3000-0x3fff]
[    0.302963] pci 0000:00:09.0:   bridge window [mem 0xd0100000-0xd01fffff]
[    0.302963] pci 0000:00:09.0:   bridge window [mem 0xd8000000-0xdfffffff pref]
[    0.302963] pci 0000:02:00.0: [14e4:165a] type 0 class 0x000200
[    0.302963] pci 0000:02:00.0: reg 10: [mem 0xd0200000-0xd020ffff 64bit]
[    0.302963] pci 0000:02:00.0: PME# supported from D3hot D3cold
[    0.302963] pci 0000:02:00.0: PME# disabled
[    0.304126] pci 0000:00:0b.0: PCI bridge to [bus 02-02]
[    0.304962] pci 0000:00:0b.0:   bridge window [mem 0xd0200000-0xd02fffff]
[    0.304962] pci 0000:00:0c.0: PCI bridge to [bus 03-03]
[    0.304962] pci 0000:00:0d.0: PCI bridge to [bus 04-04]
[    0.304962] pci 0000:05:00.0: [8086:105e] type 0 class 0x000200
[    0.304962] pci 0000:05:00.0: reg 10: [mem 0xd0320000-0xd033ffff]
[    0.304962] pci 0000:05:00.0: reg 14: [mem 0xd0300000-0xd031ffff]
[    0.304962] pci 0000:05:00.0: reg 18: [io  0x4000-0x401f]
[    0.304962] pci 0000:05:00.0: reg 30: [mem 0x00000000-0x0001ffff pref]
[    0.304962] pci 0000:05:00.0: PME# supported from D0 D3hot D3cold
[    0.304962] pci 0000:05:00.0: PME# disabled
[    0.304962] pci 0000:05:00.1: [8086:105e] type 0 class 0x000200
[    0.304962] pci 0000:05:00.1: reg 10: [mem 0xd0360000-0xd037ffff]
[    0.304962] pci 0000:05:00.1: reg 14: [mem 0xd0340000-0xd035ffff]
[    0.304962] pci 0000:05:00.1: reg 18: [io  0x4020-0x403f]
[    0.304962] pci 0000:05:00.1: reg 30: [mem 0x00000000-0x0001ffff pref]
[    0.304962] pci 0000:05:00.1: PME# supported from D0 D3hot D3cold
[    0.304962] pci 0000:05:00.1: PME# disabled
[    0.304962] pci 0000:05:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.304962] pci 0000:00:0e.0: PCI bridge to [bus 05-05]
[    0.304962] pci 0000:00:0e.0:   bridge window [io  0x4000-0x4fff]
[    0.304962] pci 0000:00:0e.0:   bridge window [mem 0xd0300000-0xd03fffff]
[    0.304962] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.305050] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P0._PRT]
[    0.306101] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.XVR0._PRT]
[    0.306962] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.XVR1._PRT]
[    0.306962] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.XVR2._PRT]
[    0.306962] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.XVR3._PRT]
[    0.306962]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.306962]  pci0000:00: ACPI _OSC request failed (AE_NOT_FOUND), returned control mask: 0x1d
[    0.306962] ACPI _OSC control for PCIe not granted, disabling ASPM
[    0.338181] initcall acpi_pci_root_init+0x0/0x2d returned 0 after 41009 usecs
[    0.338957] calling  acpi_pci_link_init+0x70] ACPI: PCI Interrupt Link [LNK1] (IRQs 16 17 18 19) *0
[    0.340322] ACPI: PCI Interrupt Link [LNK2] (IRQs 16 17 18 19) *0
[    0.341113] ACPI: PCI Interrupt Link [LNK3] (IRQs 16 17 18 19) *0
[    0.342231] ACPI: PCI Interrupt Link [LNK4] (IRQs 16 17 18 19) *0
[    0.343198] ACPI: PCI Interrupt Link [LNK5] (IRQs 16 17 18 19) *0, disabled.
[    0.344228] ACPI: PCI Interrupt Link [LSMB] (IRQs 20 21 22 23) *0
[    0.345111] ACPI: PCI Interrupt Link [LUS0] (IRQs 20 21 22 23) *0
[    0.346105] ACPI: PCI Interrupt Link [LUS2] (IRQs 20 21 22 23) *0, disabled.
[    0.346956] ACPI: PCI Interrupt Link [LMAC] (IRQs 20 21 22 23) *0, disabled.
[    0.347112] ACPI: PCI Interrupt Link [LACI] (IRQs 20 21 22 23) *0, disabled.
[    0.348234] ACPI: PCI Interrupt Link [LMCI] (IRQs 20 21 22 23) *0, disabled.
[    0.349119] ACPI: PCI Interrupt Link [LPID] (IRQs 20 21 22 23) *0, disabled.
[    0.350123] ACPI: PCI Interrupt Link [LTID] (IRQs 20 21 22 23) *0
[    0.351123] ACPI: PCI Interrupt Link [LSI1] (IRQs 20 21 22 23) *0
[    0.352197] ACPI: PCI Interrupt Link [APCP] (IRQs 20 21 22 23) *0, disabled.
[    0.353037] initcall acpi_pci_link_init+0x0/0x43 returned 0 after 14646 usecs
[    0.353955] calling  pnp_init+0x0/0x12 @ 1
[    0.354019] initcall pnp_init+0x0/0x12 returned 0 after 976 usecs
[    0.354955] calling  xen_setup_shutdown_event+0x0/0x30 @ 1
[    0.354955] initcall xen_setup_shutdown_event+0x0/0x30 returned 0 after 0 usecs
[    0.354955] calling  balloon_init+0x0/0x13a @ 1
[    0.354955] xen/balloon: Initialising balloon driver.
[    0.358744] initcall balloon_init+0x0/0x13a returned 0 after 3905 usecs
[    0.358954] calling  xenbus_probe_backend_init+0nbus_probe_backend_init+0x0/0x57 returned 0 after 976 usecs
[    0.359954] calling  xenbus_probe_frontend_init+0x0/0x57 @ 1
[    0.360149] initcall xenbus_probe_frontend_init+0x0/0x57 returned 0 after 976 usecs
[    0.360954] calling  balloon_init+0x0/0x10e @ 1
[    0.360954] xen-balloon: Initialising balloon driver.
[    0.361049] initcall balloon_init+0x0/0x10e returned 0 after 976 usecs
[    0.361954] calling  xen_selfballoon_init+0x0/0x82 @ 1
[    0.361954] xen/balloon: Xen selfballooning driver disabled for domain0.
[    0.361954] initcall xen_selfballoon_init+0x0/0x82 returned -19 after 0 usecs
[    0.361954] calling  misc_init+0x0/0xba @ 1
[    0.362148] initcall misc_init+0x0/0xba returned 0 after 976 usecs
[    0.362954] calling  vga_arb_device_init+0x0/0xde @ 1
[    0.363027] vgaarb: device added: PCI:0000:01:08.0,decodes=io+mem,owns=io+mem,locks=none
[    0.363953] vgaarb: loaded
[    0.363953] vgaarb: bridge control possible 0000:01:08.0
[    0.363953] initcall vga_arb_device_init+0x0/0xde returned 0 after 976 usecs
[    0.363953] calling  cn_init+0x0/0x9e @ 1
[    0.364099] initcall cn_init+0x0/0x9e returned 0 after 976 usecs
[    0.364953] calling  phy_init+0x0/0x2e @ 1
[    0.365055] initcall phy_init+0x0/0x2e returned 0 after 976 usecs
[    0.365953] calling  init_pcmcia_cs+0x0/0x36 @ 1
[    0.366017] initcall init_pcmcia_cs+0x0/0x36 returned 0 after 976 usecs
[    0.366953] calling  usb_init+0x0/0x173 @ 1
[    0.367069] usbcore: registered new interface driver usbfs
[    0.368023] usbcore: registered new interface driver hub
[    0.369057] usbcore: registered new device driver usb
[    0.369953] initcall usb_init+0x0/0x173 returned 0 after 2929 usecs
[    0.369953] calling  serio_init+0x0/0x31 @ 1
[    0.370018] initcall serio_init+0x0/0x31 returned 0 after 976 usecs
[    0.370952] calling  input_init+0x0/0x10c @ 1
[    0.371147] initcall input_init+0x0/0x10c returned 0 after 976 usecs
[    0.371952] calling  rtc_init+0x0/0x71 @ 1
[    0.372020] initcall rtc_init+0x0/0x71 returned 0 after 976 usecs
[    0.372952] calling  power_supply_class_init+0x0/0x44 @ 1
[    0.373016] initcall power_supply_class_init+0x0/0x44 returned 0 after 976 usecs
[    0.373952] calling  hwmon_init+0x0/0xee @ 1
[    0.374016] initcall hwmon_init+0x0/0xee returned 0 after 976 usecs
[    0.374952] calling  leds_init+0x0/0x48 @ 1
[    0.375025] initcall leds_init+0x0/0x48 returned 0 after 976 usecs
[    0.375952] calling  pci_subsys_init+0x0/0x4f @ 1
[    0.375952] PCI: Using ACPI for IRQ routing
[    0.375952] PCI: pci_cache_line_size set to 64 bytes
[    0.376071] reserve RAM buffer: 000000000009d000 - 000000000009ffff 
[    0.376951] reserve RAM buffer: 000000007fff0000 - 000000007fffffff 
[    0.376951] reserve RAM buffer: 00000000cfef0000 - 00000000cfffffff 
[    0.376951] initcall pci_subsys_init+0x0/0x4f returned 0 after 976 usecs
[    0.376951] calling  proto_init+0x0/0x12 @ 1
[    0.376951] initcall proto_init+0x0/0x12 returned 0 after 0 usecs
[    0.376951] calling  net_dev_init+0x0/0x1b3 @ 1
[    0.377146] initcall net_dev_init+0x0/0x1b3 returned 0 after 976 usecs
[    0.377951] calling  neigh_init+0x0/0x80 @ 1
[    0.377951] initcall neigh_init+0x0/0x80 returned 0 after 0 usecs
[    0.377951] calling  fib_rules_init+0x0/0xaf @ 1
[    0.377951] initcall fib_rules_init+0x0/0xaf returned 0 after 0 usecs
[    0.377951] calling  pktsched_init+0x0/0xfe @ 1
[    0.377951] initcall pktsched_init+0x0/0xfe returned 0 after 0 usecs
[    0.377951] calling  tc_filter_init+0x0/0x55 @ 1
[    0.377951] initcall tc_filter_init+0x0/0x55 returned 0 after 0 usecs
[    0.377951] calling  tc_action_init+0x0/0x55 @ 1
[    0.377951] initcall tc_action_init+0x0/0x55 returned 0 after 0 usecs
[    0.377951] calling  genl_init+0x0/0x84 @ 1
[    0.377966] initcall genl_init+0x0/0x84 returned 0 after 976 usecs
[    0.378951] calling  cipso_v4_init+0x0/0x61 @ 1
[    0.378951] initcall cipso_v4_init+0x0/0x61 returned 0 after 0 usecs
[    0.378951] calling  netlbl_init+0x0/0x81 @ 1
[    0.378951] NetLabel: Initializing
[    0.378951] NetLabel:  domain hash size = 128
[    0.378951] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.378951] NetLabel:  unlabeled traffic allowed by default
[    0.378951] initcall netlbl_init+0x0/0x81 returned 0 after 0 usecs
[    0.378951] calling  rfkill_init+0x0/0x79 @ 1
[    0.379145] initcall rfkill_init+0x0/0x79 returned 0 after 976 usecs
[    0.379951] calling  sysctl_init+0x0/0x48 @ 1
[    0.379951] initcall sysctl_init+0x0/0x48 returned 0 after 0 usecs
[    0.379951] calling  xen_p2m_debugfs+0x0/0x4a @ 1
[    0.379969] initcall xen_p2m_debugfs+0x0/0x4a returned 0 after 976 usecs
[    0.380951] calling  xen_spinlock_debugfs+0x0/0x24e @ 1
[    0.381017] initcall xen_spinlock_debugfs+0x0/0x24e returned 0 after 976 usecs
[    0.381951] calling  hpet_late_init+0x0/0x103 @ 1
[    0.381951] initcall hpet_late_init+0x0/0x103 returned -19 after 0 usecs
[    0.381951] calling  init_amd_nbs+0x0/0xb8 @ 1
[    0.382006] initcall init_amd_nbs+0x0/0xb8 returned 0 after 976 usecs
[    0.382951] calling  clocksource_done_booting+0x0/0x5a @ 1
[    0.382951] Switching to clocksource xen
[    0.382974] initcall clocksource_done_booting+0x0/0x5a returned 0 after 987 usecs
[    0.383950] calling  ftrace_init_debugfs+0x0/0xcf @ 1
[    0.395940] initcall ftrace_init_debugfs+0x0/0xcf returned 0 after 377 usecs
[    0.396609] calling  rb_init_debugfs+0x0/0x2f @ 1
[    0.396609] initcall rb_init_debugfs+0x0/0x2f returned 0 after 5 usecs
[    0.396609] calling  tracer_init_debugfs+0x0/0x3c2 @ 1
[    0.420026] initcall tracer_init_debugfs+0x0/0x3c2 returned 0 after 535 usecs
[    0.420552] calling  init_trace_printk_function_export+0x0/0x2f @ 1
[    0.420552] initcall init_trace_printk_function_export+0x0/0x2f returned 0 after 5 usecs
[    0.420552] calling  event_trace_init+0x0/0x2bd @ 1
[    0.456145] initcall event_trace_init+0x0/0x2bd returned 0 after 9409 usecs
[    0.457058] calling  init_kprobe_trace+0x0/0 1
[    0.479551] initcall init_pipe_fs+0x0/0x4c returned 0 after 201 usecs
[    0.480367] calling  eventpoll_init+0x0/0xda @ 1
[    0.490781] initcall eventpoll_init+0x0/0xda returned 0 after 142 usecs
[    0.491644] calling  anon_inode_init+0x0/0x116 @ 1
[    0.491644] initcall anon_inode_init+0x0/0x116 returned 0 after 14 usecs
[    0.491644] calling  blk_scsi_ioctl_init+0x0/0x289 @ 1
[    0.491644] initcall blk_scsi_ioctl_init+0x0/0x289 returned 0 after 0 usecs
[    0.491644] calling  acpi_event_init+0x0/0x81 @ 1
[    0.525947] initcall acpi_event_init+0x0/0x81 returned 0 after 27 usecs
[    0.526927] calling  pnp_system_init+0x0/0x12 @ 1
[    0.537517] initcall pnp_system_init+0x0/0x12 returned 0 after 174 usecs
[    0.538491] calling  pnpacpi_init+0x0/0x8c @ 1
[    0.538491] pnp: PnP ACPI init
[    0.538491] ACPI: bus type pnp registered
[    0.557402] pnp 00:00: [mem 0xffc00000-0xffffffff]
[    0.558273] pnp 00:00: [mem 0xfec00000-0xfec00fff]
[    0.558273] pnp 00:00: [mem 0xfee00000-0xfeefffff]
[    0.558273] pnp 00:00: [mem 0xfed00000-0xfed00fff]
[    0.577096] system 00:00: [mem 0xffc00000-0xffffffff] could not be reserved
[    0.578047] system 00:00: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.578047] system 00:00: [mem 0xfee00000-0xfeefffff] could not be reserved
[    0.578047] system 00:00: [mem 0xfed00000-0xfed00fff] has been reserved
[    0.578047] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.611747] pnp 00:01: [bus 00-ff]
[    0.612649] pnp 00:01: [io  0x0cf8-0x0cff]
[    0.612649] pnp 00:01: [io  0x0000-0x0cf7 window]
[    0.612649] pnp 00:01: [io  0x0d00-0xffff window]
[    0.612649] pnp 00:01: [mem 0x000a0000-0x000bffff window]
[    0.612649] pnp 00:01: [mem 0x000c0000-0x000dffff window]
[    0.612649] pnp 00:01: [mem 0xd0000000-0xfebfffff window]
[    0.612649] pnp 00:01: [mem 0xfed40000-0xfed8ffff]
[    0.650423] pnp 00:01: Plug and Play ACPI device, IDs PNP0a03 (active)
[    0.651400] pnp 00:02: [mem 0xe0000000-0xefffffff]
[    0.662021] system 00:02: [mem 0xe0000000-0xefffffff] has been reserved
[    0.662994] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.676409] pnp 00:03: [io  0x8000-0x807f]
[    0.677057] pnp 00:03: [io  0x8080-0x80ff]
[    0.677057] pnp 00:03: [io  0x8400-0x847f]
[    0.677057] pnp 00:03: [io  0x8480-0x84ff]
[    0.677057] pnp 00:03: [io  0x8800-0x887f]
[    0.677057] pnp 00:03: [io  0x8880-0x88ff]
[    0.701260] pnp 00:03: [io  0x2040-0x207f]
[    0.702243] pnp 00:03: [io  0x2000-0x203f]
[    0.702243] pnp 00:03: [io  0x0060]
[    0.702243] pnp 00:03: [io  0x0064]
[    0.717025] system 00:03: [io  0x8000-0x807f] has been reserved
[    0.717998] system 00:03: [io  0x8080-0x80ff] has been reserved
[    0.717998] system 00:03: [io  0x8400-0x847f] has been reserved
[    0.717998] system 00:03: [io  0x8480-0x84ff] has been reserved
[    0.717998] system 00:03: [io  0x8800-0x887f] has been reserved
[    0.717998] system 00:03: [io  0x8880-0x88ff] has been reserved
[    0.717998] system 00:03: [io  0x2040-0x207f] has been reserved
[    0.717998] system 00:03: [io  0x2000-0x203f] has been reserved
[    0.717998] system 00:03: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.771758] pnp 00:04: [irq 0 disabled]
[    0.772631] xen: registering gsi 8 triggering 1 polarity 0
[    0.781377] xen_map_pirq_gsi: returning irq 8 for gsi 8
[    0.782114] xen: --> pirq=8 -> irq=8 (gsi=8)
[    0.790911] pnp 00:04: [irq 8]
[    0.791898] pnp 00:04: [mem 0xfed00000-0xfed003ff]
[    0.799174] pnp 00:04: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.800152] pnp 00:05: [io  0x0010-0x001f]
[    0.800152] pnp 00:05: [io  0x0022-0x003f]
[    0.800152] pnp 00:05: [io  0x0044-0x005f]
[    0.800152] pnp 00:05: [io  0x0062-0x0063]
[    0.800152] pnp 00:05: [io  0x0065-0x006f]
[    0.800152] pnp 00:05: [io  0x0072-0x0073]
[    0.800152] pnp 00:05: [io  0x0074-0x007f]
[    0.800152] pnp 00:05: [io  0x0091-0x0093]
[    0.800152] pnp 00:05: [io  0x0097-0x009f]
[    0.800152] pnp 00:05: [io  0x00a2-0x00bf]
[    0.800152] pnp 00:05: [io  0x00e0-0x00ef]
[    0.800152] pnp 00:05: [io  0x04d0-0x04d1]
[    0.855784] system 00:05: [io  0x04d0-0x04d1] has been reserved
[    0.856756] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.856756] pnp 00:06: [io  0x0000-0x0008]
[    0.856756] pnp 00:06: [io  0x000a-0x000f]
[    0.856756] pnp 00:06: [io  0x0081-0x0083]
[    0.856756] pnp 00:06: [io  0x0087]
[    0.856756] pnp 00:06: [io  0x0089-0x008b]
[    0.856756] pnp 00:06: [io  0x008f]
[    0.856756] pnp 00:06: [io  0x00c0-0x00d1]
[    0.856756] pnp 00:06: [io  0x00d4-0x00df]
[    0.856756] pnp 00:06: [dma 4]
[    0.903820] pnp 00:06: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.904798] pnp 00:07: [io  0x0061]
[    0.914054] pnp 00:07: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.915029] pnp 00:08: [io  0x0070-0x0071]
[    0.924901] pnp 00:08: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.925879] pnp 00:09: [io  0x00f0-0x00f1]
[    0.925879] xen: registering gsi 13 triggering 1 polarity 0
[    0.941182] xen_map_pirq_gsi: returning irq 13 for gsi 13
[    0.942170] xen: --> pirq=13 -> irq=13 (gsi=13)
[    0.951350] pnp 00:09: [irq 13]
[    0.954661] pnp 00:09: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.955638] pnp 00:0a: [io  0x0c00-0x0c7f]
[    0.965693] system 00:0a: [io  0x0c00-0x0c7f] has been reserved
[    0.966666] system 00:0a: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.978985] pnp 00:0b: [io  0x03f8-0x03ff]
[    0.979478] xen: registering gsi 4 triggering 1 polarity 0
[    0.988733] xen_map_pirq_gsi: returning irq 4 for gsi 4
[    0.989593] xen: --> pirq=4 -> irq=4 (gsi=4)
[    0.998261] Already setup the GSI :4
[    0.999250] pnp 00:0b: [irq 4]
[    1.005553] pnp 00:0b: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.013548] pnp: PnP ACPI: found 12 devices
[    1.014055] ACPI: ACPI bus type pnp unregistered
[    1.014055] initcall pnpacpi_init+0x0/0x8c returned 0 after 462591 usecs
[    1.014055] calling  pcistub_init+0x0/0x1d7 @ 1
[    1.035975] initcall pcistub_init+0x0/0x1d7 returned 0 after 2209 usecs
[    1.036941] calling  chr_dev_init+0x0/0xc6 @ 1
[    1.056849] initcall chr_dev_init+0x0/0xc6 returned 0 after 9552 usecs
[    1.057782] calling  firmware_class_init+0x0/0x19_bus+0x0/0x65 @ 1
[    1.080576] initcall init_pcmcia_bus+0x0/0x65 returned 0 after 230 usecs
[    1.081355] calling  thermal_init+0x0/0x75 @ 1
[    1.091977] initcall thermal_init+0x0/0x75 returned 0 after 221 usecs
[    1.092763] calling  cpufreq_gov_performance_init+0x0/0x12 @ 1
[    1.092763] initcall cpufreq_gov_performance_init+0x0/0x12 returned 0 after 0 usecs
[    1.092763] calling  cpufreq_gov_dbs_init+0x0/0x12 @ 1
[    1.092763] initcall cpufreq_gov_dbs_init+0x0/0x12 returned 0 after 0 usecs
[    1.092763] calling  init_acpi_pm_clocksource+0x0/0xec @ 1
[    1.133218] PM-Timer failed consistency check  (0x0xffffff) - aborting.
[    1.134062] initcall init_acpi_pm_clocksource+0x63] pci 0000:00:0e.0: BAR 15: assigned [mem 0xd0400000-0xd04fffff pref]
[    1.154163] pci 0000:01:07.0: BAR 6: assigned [mem 0xd0120000-0xd013ffff pref]
[    1.154163] pci 0000:01:08.0: BAR 6: assigned [mem 0xd0140000-0xd015ffff pref]
[    1.154163] pci 0000:00:09.0: PCI bridge to [bus 01-01]
[    1.154163] pci 0000:00:09.0:   bridge window [io  0x3000-0x3fff]
[    1.154163] pci 0000:00:09.0:   bridge window [mem 0xd0100000-0xd01fffff]
[    1.154163] pci 0000:00:09.0:   bridge window [mem 0xd8000000-0xdfffffff pref]
[    1.154163] pci 0000:00:0b.0: PCI bridge to [bus 02-02]
[    1.154163] pci 0000:00:0b.0:   bridge window [mem 0xd0200000-0xd02fffff]
[    1.154163] pci 0000:00:0c.0: PCI bridge to [bus 03-03]
[    1.154163] pci 0000:00:0d.0: PCI bridge to [bus 04-04]
[    1.154163] pci 0000:05:00.0: BAR 6: assigned [mem 0xd0400000-0xd041ffff pref]
[    1.154163] pci 0000:05:00.1: BAR 6: assigned [mem 0xd0420000-0xd043ffff pref]
[    1.154163] pci 0000:00:0e.0: PCI bridge to [bus 05-05]
[    1.154163] pci 0000:00:0e.0:   bridge window [io  0x4000-0x4fff]
[    1.154163] pci 0000:00:0e.0:   bridge window [mem 0xd0300000-0xd03fffff]
[    1.154163] pci 0000:00:0e.0:   bridge window [mem 0xd0400000-0xd04fffff pref]
[    1.154163] pci 0000:00:09.0: setting latency timer to 64
[    1.154163] pci 0000:00:0b.0: setting latency timer to 64
[    1.154163] pci 0000:00:0c.0: setting latency timer to 64
[    1.154163] pci 0000:00:0d.0: setting latency timer to 64
[    1.154163] pci 0000:00:0e.0: setting latency timer to 64
[    1.154163] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.154163] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    1.154163] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    1.154163] pci_bus 0000:00: resource 7 [mem 0x000c0000-0x000dffff]
[    1.154163] pci_bus 0000:00: resource 8 [mem 0xd0000000-0xfebfffff]
[    1.154163] pci_bus 0000:00: resource 9 [mem 0xfed40000-0xfed8ffff]
[    1.154163] pci_bus 0000:01: resource 0 [io  0x3000-0x3fff]
[    1.154163] pci_bus 0000:01: resource 1 [mem 0xd0100000-0xd01fffff]
[    1.154163] pci_bus 0000:01: resource 2 [mem 0xd8000000-0xdfffffff pref]
[    1.154163] pci_bus 0000:02: resource 1 [mem 0xd0200000-0xd02fffff]
[    1.154163] pci_bus 0000:05: resource 0 [io  0x4000-0x4fff]
[    1.154163] pci_bus 0000:05: resource 1 [mem 0xd0300000-0xd03fffff]
[    1.154163] pci_bus 0000:05: resource 2 [mem 0xd0400000-0xd04fffff pref]
[    1.154163] initcall pcibios_assign_resources+0x0/0x76 returned 0 after 217184 usecs
[    1.154163] calling  sysctl_core_init+0x0/0x38 @ 1
[    1.388361] initcall sysctl_core_init+0x0/0x38 returned 0 after 183 usecs
[    1.389212] calling  inet_init+0x0/0x27d @ 1
[    1.389212] NET: Registered protocol family 2
[    1.404778] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    1.418009] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    1.429619] TCP bind hash table entrie: Hash tables configured (established 524288 bind 65536)
[    1.437392] TCP reno registered
[    1.446719] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    1.452796] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    1.459438] initcall inet_init+0x0/0x27d returned 0 after 58592 usecs
[    1.460337] calling  af_unix_init+0x0/0x55 @ 1
[    1.460337] NET: Registered protocol family 1
[    1.460337] initcall af_unix_init+0x0/0x55 returned 0 after 4323 usecs
[    1.460337] calling  init_sunrpc+0x0/0x73 @ 1
[    1.486196] RPC: Registered named UNIX socket transport module.
[    1.487062] RPC: Registered udp transport module.
[    1.487062] RPC: Registered tcp transport module.
[    1.487062] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    1.487062] initcall init_sunrpc+0x0/0x73 returned 0 after 22944 usecs
[    1.487062] calling  pci_apply_final_quirks+0x0/0x10c @ 1
[    1.572298] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    1.573058] pci 0000:00:00.0: Found enabled HT MSI Mapping
HT MSI Mapping
[    1.584419] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    1.584419] pci 0000:00:0c.0: Found disabled HT MSI Mapping
[    1.584419] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    1.584419] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    1.584419] pci 0000:00:0d.0: Found disabled HT MSI Mapping
[    1.584419] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    1.584419] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    1.584419] pci 0000:00:0e.0: Found disabled HT MSI Mapping
[    1.584419] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    1.584419] pci 0000:01:08.0: Boot video device
[    1.584419] PCI: CLS 64 bytes, default 64
[    1.584419] initcall pci_apply_final_quirks+0x0/0x10c returned 0 after 134779 usecs
[    1.584419] calling  populate_rootfs+0x0/0xd3 @ 1
[    1.672231] Trying to unpack rootfs image as initramfs...
[    2.368114] Freeing initrd memory: 238536k freed
[    2.480588] initcall populate_rootfs+0x0/0xd3 returned 0 after 789869 usecs
[    2.481116] calling  pci_iommu_init+0x0/0x57[    2.498905] DMA-API: preallocated 32768 debug entries
[    2.499057] DMA-API: debugging enabled by kernel config
[    2.499057] initcall pci_iommu_init+0x0/0x57 returned 0 after 16624 usecs
[    2.499057] calling  calgary_fixup_tce_spaces+0x0/0x105 @ 1
[    2.499057] initcall calgary_fixup_tce_spaces+0x0/0x105 returned -19 after 0 usecs
[    2.499057] calling  irqfd_module_init+0x0/0x31 @ 1
[    2.534754] initcall irqfd_module_init+0x0/0x31 returned 0 after 524 usecs
[    2.535735] calling  i8259A_init_ops+0x0/0x21 @ 1
[    2.535735] initcall i8259A_init_ops+0x0/0x21 returned 0 after 1 usecs
[    2.535735] calling  vsyscall_init+0x0/0x27 @ 1
[    2.557547] initcall vsyscall_init+0x0/0x27 returned 0 after 32 usecs
[    2.558521] calling  sbf_init+0x0/0xf6 @ 1
[    2.558521] Simple Boot Flag at 0x62 set to 0x1
[    2.558521] initcall sbf_init+0x0/0xf6 returned 0 after 4483 usecs
[    2.558521] calling  init_tsc_clocksource+0x0/0x5f @ 1
[    2.558521] initcall init_tsc_clocksource+0x0/0x5f returned 0 after 5 usecs
[    2.558521] calling  add_rtc_cmos+0x0/0x96 @ 1
[    2.558521] initcall add_rtc_cmos+0x0/0x96 returned 0 after 3 usecs
[    2.558521] calling  i8237A_init_ops+0x0/0x14 @ 1
[    2.558521] initcall i8237A_init_ops+0x0/0x14 returned 0 after 0 usecs
[    2.558521] calling  cache_sysfs_init+0x0/0x6e @ 1
[    2.621792] initcall cache_sysfs_init+0x0/0x6e returned 0 after 3525 usecs
[    2.622779] calling  mcheck_init_device+0x0/0rned -5 after 0 usecs
[    2.634743] initcall mcheck_init_device+0x0/0x11f returned with error code -5 
[    2.634743] calling  threshold_init_device+0x0/0x91 @ 1
[    2.634743] initcall threshold_init_device+0x0/0x91 returned 0 after 0 usecs
[    2.634743] calling  inject_init+0x0/0x60 @ 1
[    2.634743] Machine check injector initialized
[    2.634743] initcall inject_init+0x0/0x60 returned 0 after 4395 usecs
[    2.634743] calling  thermal_throttle_init_device+0x0/0xa3 @ 1
[    2.634743] initcall thermal_throttle_init_device+0x0/0xa3 returned 0 after 0 usecs
[    2.634743] calling  amd_ibs_init+0x0/0x4bc @ 1
[    2.634743] initcall amd_ibs_init+0x0/0x4bc returned -19 after 0 usecs
[    2.634743] calling  msr_init+0x0/0x150 @ 1
[    2.705693] initcall msr_init+0x0/0x150 returned 0 after 886 usecs
[    2.706682] calling  cpuid_init+0x0/0x150 @ 1
[    2.716874] initcall cpuid_init+0x0/0x150 returned 0 after 609 usecs
[    2.717862] calling  ioapic_init_ops+0x0/0x14 @ 1
[    2.717862] initcall ioapic_init_ops+0x0/0x14 returned 0 after 0 usecs
[    2.717862] calling  add_pcspkr+0x0/0x60 @ 1
[    2.738993] initcall add_pcspkr+0x0/0x60 returned 0 after 136 usecs
[    2.739980] calling  microcode_init+0x0/0x16b @ 1
[    2.750141] microcode: CPU0: patch_level=0x01000065
[    2.755002] microcode: CPU1: patch_level=0x01000065
[    2.759938] microcode: CPU2: patch_level=0x01000065
[    2.764875] microcode: CPU3: patch_level=0x01000065
[    2.769926] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    2.770915] initcall microcode_init+0x0/0x16b returned 0 after 28032 usecs
[    2.770915] calling  start_periodic_check_for_corruption+0x0/0x50 @ 1
[    2.770915] initcall start_periodic_check_for_corruption+0x0/0x50 returned 0 after 0 usecs
[    2.770915] calling  audit_classes_init+0x0/0xaf @ 1
[    2.770915] initcall audit_classes_init+0x0/0xaf returned 0 after 3 usecs
[    2.770915] calling  pt_dump_init+0x0/0x30 @ 1
[    2.770915] initcall pt_dump_init+0x0/0x30 returned 0 after 12 usecs
[    2.770915] calling  ia32_binfmt_init+0x0/0x14 @ 1
[    2.770915] initcall ia32_binfmt_init+0x0/0x14 returned 0 after 17 usecs
[    2.770915] calling  proc_schedstat_init+0x0/0x22 @ 1
[    2.770915] initcall proc_schedstat_init+0x0/0x22 returned 0 after 6 usecs
[    2.770915] calling  proc_execdomains_init+0x0/0x22 @ 1
[    2.770915] initcall proc_execdomains_init+0x0/0x22 returned 0 after 6 usecs
[    2.770915] calling  ioresources_init+0x0/0x3c @ 1
[    2.864024] initcall ioresources_init+0x0/0x3c returned 0 after 25 usecs
[    2.865004] calling  uid_cache_init+0x0/0x8c @ 1
[    2.875574] initcall uid_cache_init+0x0/0x8c returned 0 after 148 usecs
[    2.876430] calling  init_posix_timers+0x0/0x1f4 @ 1
[    2.876430] initcall init_posix_timers+0x0/0x1f4 returned 0 after 1 usecs
[    2.876430] calling  init_posix_cpu_timers+0x0/0xbf @ 1
[    2.876430] initcall init_posix_cpu_timers+0x0/0xbf returned 0 after 0 usecs
[    2.876430] calling  create_proc_profile+0x0/0x290 @ 1
[    2.876430] initcall create_proc_profile+0x0/0x290 returned 0 after 0 usecs
[    2.876430] calling  timekeeping_init_ops+0x0/0x14 @ 1
[    2.876430] initcall timekeeping_init_ops+0x0/0x14 returned 0 after 0 usecs
[    2.876430] calling  init_clocksource_sysfs+0x0/0x50 @ 1
[    2.936487] initcall init_clocksource_sysfs+0x0/0x50 returned 0 after 321 usecs
[    2.937473] calling  init_timer_list_procfs+0x0/0x2c @ 1
[    2.937473] initcall init_timer_list_procfs+0x0/0x2c returned 0 after 3 usecs
[    2.937473] calling  alarmtimer_init+0x0/0x172 @ 1
[    2.961417] initcall alarmtimer_init+0x0/0x172 returned 0 after 255 usecs
[    2.962399] calling  init_tstats_procfs+0x0/0x2c @ 1
[    2.962399] initcall init_tstats_procfs+0x0/0x2c returned 0 after 3 usecs
[    2.962399] calling  futex_init+0x0/0x62 @ 1
[    2.984366] initcall futex_init+0x0/0x62 returned 0 after 17 usecs
[    2.985351] calling  proc_dma_init+0x0/0x22 @ 1
[    2.985351] initcall proc_dma_init+0x0/0x22 returned 0 after 3 usecs
[    2.985351] calling  proc_modules_init+0x0/0x22 @ 1
[    2.985351] initcall proc_modules_init+0x0/0x22 returned 0 after 3 usecs
[    2.985351] calling  kallsyms_init+0x0/0x25 @ 1
[    2.985351] initcall kallsyms_init+0x0/0x25 returned 0 after 2 usecs
[    2.985351] calling  snapshot_device_init+0x0/0x12 @ 1
[    3.029665] initcall snapshot_device_init+0x0/0x12 returned 0 after 220 usecs
[    3.030463] calling  crash_save_vmcoreinfo_init+0x0/0x46d @ 1
[    3.030463] initcall crash_save_vmcoreinfo_init+0x0/0x46d returned 0 after 20 usecs
[    3.030463] calling  crash_notes_memory_init+0x0/0x36 @ 1
[    3.030463] initcall crash_notes_memory_init+0x0/0x36 returned 0 after 5 usecs
[    3.030463] calling  user_namespaces_init+0x0/0x2d @ 1
[    3.030463] initcall user_namespaces_init+0x0/0x2d returned 0 after 7 usecs
[    3.030463] calling  pid_namespaces_init+0x0/0x2d @ 1
[    3.030463] initcall pid_namespaces_init+0x0/0x2d returned 0 after 4 usecs
[    3.030463] calling  audit_init+0x0/0x133 @ 1
[    3.030463] audit: initializing netlink socket (disabled)
[    3.097108] type=2000 audit(1319628370.680:1): initialized
[    3.098090] initcall audit_init+0x0/0x133 returned 0 after 10737 usecs
[    3.098090] calling  audit_watch_init+0x0/0x3a @ 1
[    3.098090] initcall audit_watch_init+0x0/0x3a returned 0 after 0 usecs
[    3.098090] calling  audit_tree_init+0x0/0x49 @ 1
[    3.098090] initcall audit_tree_init+0x0/0x49 returned 0 after 0 usecs
[    3.098090] calling  init_kprobes+0x0/0x17c @ 1
[    3.152006] initcall init_kprobes+0x0/0x17c returned 0 after 15015 usecs
[    3.152060] calling  irq_pm_init_ops+0x0/0x14 @ 1
[    3.152060] initcall irq_pm_init_ops+0x0/0x14 returned 0 after 0 usecs
[    3.152060] calling  utsname_sysctl_init+0x0/0x14 @ 1
[    3.152060] initcall utsname_sysctl_init+0x0/0x14 returned 0 after 61 usecs
[    3.152060] calling  init_tracepoints+0x0/0x20 @ 1
[    3.152060] initcall init_tracepoints+0x0/0x20 returned 0 after 0 usecs
[    3.152060] calling  ftrace_mod_cmd_init+0x0/0x12 @ 1
[    3.152060] initcall ftrace_mod_cmd_init+0x0/0x12 returned 0 after 0 usecs
[    3.152060] calling  init_events+0x0/0x61 @ 1
[    3.152060] initcall init_events+0x0/0x61 returned 0 after 3 usecs
[    3.152060] calling  init_function_trace+0x0/0x3e @ 1
[    3.152060] initcall init_function_trace+0x0/0x3e returned 0 after 1 usecs
[    3.152060] calling  init_graph_trace+0x0/0x66 @ 1
[    3.152060] initcall init_graph_trace+0x0/0x66 returned 0 after 1 usecs
[    3.152060] calling  init_blk_tracer+0x0/0x5a @ 1
[    3.152060] initcall init_blk_tracer+0x0/0x5a returned 0 after 0 usecs
[    3.152060] calling  perf_event_sysfs_init+0x0/0x93 @ 1
[    3.257059] initcall perf_event_sysfs_init+0x0/0x93 returned 0 after 579 usecs
[    3.258038] calling  init_per_zone_wmark_min+0x0/0x8b @ 1
[    3.258038] initcall init_per_zone_wmark_min+0x0/0x8b returned 0 after 10095 usecs
[    3.258038] calling  kswapd_init+0x0/
[    3.293133] calling  extfrag_debug_init+0x0/0x72 @ 1
[    3.293133] initcall extfrag_debug_init+0x0/0x72 returned 0 after 27 usecs
[    3.293133] calling  setup_vmstat+0x0/0xca @ 1
[    3.293133] initcall setup_vmstat+0x0/0xca returned 0 after 43 usecs
[    3.293133] calling  mm_sysfs_init+0x0/0x29 @ 1
[    3.293133] initcall mm_sysfs_init+0x0/0x29 returned 0 after 8 usecs
[    3.293133] calling  proc_vmalloc_init+0x0/0x25 @ 1
[    3.293133] initcall proc_vmalloc_init+0x0/0x25 returned 0 after 3 usecs
[    3.293133] calling  procswaps_init+0x0/0x22 @ 1
[    3.348690] initcall procswaps_init+0x0/0x22 returned 0 after 23 usecs
[    3.349671] calling  hugetlb_init+0x0/0x451 @ 1
[    3.349671] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    3.366397] initcall hugetlb_init+0x0/0x451 returned 0 after 6412 usecs
[    3.367255] calling  slab_proc_init+0x0/0x25 @ 1
[    3.367255] initcall slab_proc_init+0x0/0x25 returned 0 after 3 usecs
[    3.367255] calling  slab_sysfs_init+0x0/0x100 @ 1
[    3.401087] initcall slab_sysfs_init+0x0/0x100 returned 0 after 10697 usecs
[    3.402058] calling  init_cleancache+0x0/0x1nit+0x0/0x22 returned 0 after 8 usecs
[    3.402058] calling  fsnotify_mark_init+0x0/0x40 @ 1
[    3.447465] initcall fsnotify_mark_init+0x0/0x40 returned 0 after 234 usecs
[    3.448451] calling  dnotify_init+0x0/0x7b @ 1
[    3.459083] initcall dnotify_init+0x0/0x7b returned 0 after 190 usecs
[    3.460049] calling  inotify_user_setup+0x0/0x70 @ 1
[    3.460049] initcall inotify_user_setup+0x0/0x70 returned 0 after 6 usecs
[    3.460049] calling  aio_setup+0x0/0x9d @ 1
[    3.460049] initcall aio_setup+0x0/0x9d returned 0 after 9 usecs
[    3.460049] calling  proc_locks_init+0x0/0x22 @ 1
[    3.460049] initcall proc_locks_init+0x0/0x22 returned 0 after 3 usecs
[    3.460049] calling  init_sys32_ioctl+0x0/0x28 @ 1
[    3.503949] initcall init_sys32_ioctl+0x0/0x28 returned 0 after 121 usecs
[    3.504938] calling  dquot_init+0x0/0x121 @ 1
[    3.504938] VFS: Disk quotas dquot_6.5.2
[    3.519507] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    3.520473] initcall dquot_init+0x0/0x121 returned 0 after 10549 usecs
[    3.520473] calling  init_v2_quota_format+0x0/0x22 @ 1
[    3.520473] initcall init_v2_quota_format+0x0/0x22 returned 0 after 1 usecs
[    3.520473] calling  quota_init+0x0/0x26 @ 1
[    3.520473] initcall quota_init+0x0/0x26 returned 0 after 5 usecs
[    3.520473] calling  proc_cmdline_init+0x0/0x22 @ 1
[    3.520473] initcall proc_cmdline_init+0x0/0x22 returned 0 after 8 usecs
[    3.520473] calling  proc_consoles_init+0x0/0x22 @ 1
[    3.520473] initcall proc_consoles_init+0x0/0x22 returned 0 after 3 usecs
[    3.520473] calling  proc_cpuinfo_init+0x0/0x22 @ 1
[    3.520473] initcall proc_cpuinfo_init+0x0/0x22 returned 0 after 2 usecs
[    3.520473] calling  proc_devices_init+0x0/0x22 @ 1
[    3.520473] initcall proc_devices_init+0x0/0x22 returned 0 after 3 usecs
[    3.520473] calling  proc_interrupts_init+0x0/0x22 @ 1
[    3.520473] initcall proc_interrupts_init+0x0/0x22 returned 0 after 3 usecs
[    3.520473] calling  proc_loadavg_init+0x0/0x22 @ 1
[    3.520473] initcall proc_loadavg_init+0x0/0x22 returned 0 after 2 usecs
[    3.520473] calling  proc_meminfo_init+0x0/0x22 @ 1
[    3.520473] initcall proc_meminfo_init+0x0/0x22 returned 0 after 2 usecs
[    3.520473] calling  proc_stat_init+0x0/0x22 @ 1
[    3.520473] initcall proc_stat_init+0x0/0x22 returned 0 after 3 usecs
[    3.520473] calling  proc_uptime_init+0x0/0x22 @ 1
[    3.520473] initcall proc_uptime_init+0x0/0x22 returned 0 after 3 usecs
[    3.520473] calling  proc_version_init+0x0/0x22 @ 1
[    3.520473] initcall proc_version_init+0x0/0x22 returned 0 after 3 usecs
[    3.520473] calling  proc_softirqs_init+0x0/0x22 @ 1
[    3.520473] initcall proc_softirqs_init+0x0/0x22 returned 0 after 3 usecs
[    3.520473] calling  proc_kcore_init+0x0/0xa9 @ 1
[    3.520473] initcall proc_kcore_init+0x0/0xa9 returned 0 after 8 usecs
[    3.520473] calling  vmcore_init+0x0/0x39b @ 1
[    3.520473] initcall vmcore_init+0x0/0x39b returned 0 after 0 usecs
[    3.520473] calling  proc_kmsg_init+0x0/0x25 @ 1
[    3.520473] initcall proc_kmsg_init+0x0/0x25 returned 0 after 3 usecs
[    3.520473] calling  proc_page_init+0x0/0x42 @ 1
[    3.721888] initcall proc_page_init+0x0/0x42 returned 0 after 43 usecs
[    3.722849] calling  init_devpts_fs+0x0/0x4c @ 1
[    3.722849] initcall init_devpts_fs+0x0/0x4c returned 0 after 20 usecs
[    3.722849] calling  init_ramfs_fs+0x0/0x12 @ 1
[    3.722849] initcall init_ramfs_fs+0x0/0x12 returned 0 after 0 usecs
[    3.722849] calling  init_hugetlbfs_fs+0x0/0x98 @ 1
[    3.756080] initcall init_hugetlbfs_fs+0x0/0x98 returned 0 after 470 usecs
[    3.757019] calling  init_fat_fs+0x0/0x4f @ 1
[    3.767631] initcall init_fat_fs+0x0/0x4f returned 0 after 289 usecs
[    3.768620] calling  init_vfat_fs+0x0/0x12 @ 1
[    3.768620] initcall init_vfat_fs+0x0/0x12 returned 0 after 1 usecs
[    3.768620] calling  init_msdos_fs+0x0/0x12 @ 1
[    3.768620] initcall init_msdos_fs+0x0/0x12 returned 0 after 0 usecs
[    3.768620] calling  init_iso9660_fs+0x0/0x77 @ 1
[    3.800749] initcall init_iso9660_fs+0x0/0x77 returned 0 after 227 usecs
[    3.801688] calling  init_nfs_fs+0x0/0x150 @ 1
[    3.812546] initcall init_nfs_fs+0x0/0x150 returned 0 after 620 usecs
[    3.813472] calling  init_nlm+0x0/0x22 @ 1
[    3.813472] initcall init_nlm+0x0/0x22 returned 0 after 79 usecs
[    3.813472] calling  init_nls_cp437+0x0/0x12 @ 1
[    3.813472] initcall init_nls_cp437+0x0/0x12 returned 0 after 1 usecs
[    3.813472] calling  init_nls_ascii+0x0/0x12 @ 1
[    3.813472] initcall init_nls_ascii+0x0/0x12 returned 0 after 0 usecs
[    3.813472] calling  init_nls_iso8859_1+0x0/0x12 @ 1
[    3.813472] initcall init_nls_iso8859_1+0x0/0x12 returned 0 after 0 usecs
[    3.813472] calling  init_nls_utf8+0x0/0x2b @ 1
[    3.813472] initcall init_nls_utf8+0x0/0x2b returned 0 after 1 usecs
[    3.813472] calling  init_ntfs_fs+0x0/0x1d1 @ 1
[    3.813472] NTFS driver 2.1.30 [Flags: R/W].
[    3.883777] initcall init_ntfs_fs+0x0/0x1d1 returned 0 after 4739 usecs
[    3.884764] calling  init_autofs4_fs+0x0/0x26 @ 1
[    3.895263] initcall init_autofs4_fs+0x0/0x26 returned 0 after 145 usecs
[    3.896249] calling  ipc_init+0x0/0x23 @ 1
[    3.896249] msgmni has been set to 6332
[    3.896249] initcall ipc_init+0x0/0x23 returned 0 after 3808 usecs
[    3.896249] calling  ipc_sysctl_init+0x0/0x14 @ 1
[    3.921105] initcall ipc_sysctl_init+0x0/0x14 returned 0 after 130 usecs
[    3.922071] calling  init_mqueue_fs+0x0/0xb4 @ 1
[    3.932833] initcall init_mqueue_fs+0x0/0xb4 returned 0 after 383 usecs
[    3.933746] calling  key_proc_init+0x0/0x5e @ 1
[    3.933746] initcall key_proc_init+0x0/0x5e returned 0 after 6 usecs
[    3.933746] calling  selinux_nf_ip_init+0x0/0x69 @ 1
[    3.933746] initcall selinux_nf_ip_init+0x0/0x69 returned 0 after 0 usecs
[    3.933746] calling  init_sel_fs+0x0/0x9e @ 1
[    3.933746] initcall init_sel_fs+0x0/0x9e returned 0 after 0 usecs
[    3.933746] calling  selnl_init+0x0/0x4d @ 1
[    3.977248] initcall selnl_init+0x0/0x4d returned 0 after 19 usecs
[    3.978236] calling  sel_netif_init+0x0/0x66 @ 1
[    3.978236] initcall sel_netif_init+0x0/0x66 returned 0 after 0 usecs
[    3.978236] calling  sel_netnode_init+0x0/0x75 @ 1
[    3.978236] initcall sel_netnode_init+0x0/0x75 returned 0 after 0 usecs
[    3.978236] calling  sel_netport_init+0x0/0x75 @ 1
[    3.978236] initcall sel_netport_init+0x0/0x75 returned 0 after 0 usecs
[    3.978236] calling  aurule_init+0x0/0x37 @ 1
[    3.978236] initcall aurule_init+0x0/0x37 returned 0 after 0 usecs
[    3.978236] calling  crypto_wq_init+0x0/0x31 @ 1
[    4.033335] initcall crypto_wq_init+0x0/0x31 returned 0 after 361 usecs
[    4.034308] calling  crypto_algapi_init+0x0/0xd @ 1
[    4.034308] initcall crypto_algapi_init+0x0/0xd returned 0 after 3 usecs
[    4.034308] calling  skcipher_module_init+0x0/0x36 @ 1
[    4.034308] initcall skcipher_module_init+0x0/0x36 returned 0 after 0 usecs
[    4.034308] calling  chainiv_module_init+0x0/0x12 @ 1
[    4.034308] initcall chainiv_module_init+0x0/0x12 returned 0 after 1 usecs
[    4.034308] calling  eseqiv_module_init+0x0/0x12 @ 1
[    4.034308] initcall eseqiv_module_init+0x0/0x12 returned 0 after 0 usecs
[    4.034308] calling  hmac_module_init+0x0/0x12 @ 1
[    4.034308] initcall hmac_module_init+0x0/0x12 returned 0 after 0 usecs
[    4.034308] calling  md5_mod_init+0x0/0x12 @ 1
[    4.103980] initcall md5_mod_init+0x0/0x12 returned 0 after 277 usecs
[    4.104968] calling  sha1_generic_mod_init+0x0/0x12 @ 1
[    4.115769] initcall sha1_generic_mod_init+0x0/0x12 returned 0 after 104 usecs
[    4.116751] calling  crypto_cbc_module_init+0x0/0x12 @ 1
[    4.116751] initcall crypto_cbc_module_init+0x0/0x12 returned 0 after 0 usecs
[    4.116751] calling  des_generic_mod_init+0x0/0x3f @ 1
[    4.140886] initcall des_generic_mod_init+0x0/0x3f returned 0 after 189 usecs
[    4.141874] calling  zlib_mod_init+0x0/0x12 @ 1
[    4.152688] initcall zlib_mod_init+0x0/0x12 returned 0 after 103 usecs
[    4.153669] calling  crypto_authenc_module_init+0x0/0x12 @ 1
[    4.153669] initcall crypto_authenc_module_init+0x0/0x12 returned 0 after 0 usecs
[    4.153669] calling  crypto_authenc_esn_module_init+0x0/0x12 @ 1
[    4.153669] initcall crypto_authenc_esn_module_init+0x0/0x12 returned 0 after 0 usecs
[    4.153669] calling  krng_mod_init+0x0/0x12 @ 1
[    4.191133] initcall krng_mod_init+0x0/0x12 returned 0 after 188 usecs
[    4.192121] calling  proc_genhd_init+0x0/0x3c @ 1
[    4.202412] initcall proc_genhd_init+0x0/0x3c returned 0 after 27 usecs
[    4.203388] calling  bsg_init+0x0/0x12e @ 1
[    4.213764] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    4.214752] initcall bsg_init+0x0/0x12e returned 0 after 7668 usecs
[    4.214752] calling  noop_init+0x0/0x14 @ 1
[    4.214752] io scheduler noop registered
[    4.214752] initcall noop_init+0x0/0x14 returned 0 after 3886 usecs
[    4.214752] calling  deadline_init+0x0/0x14 @ 1
[    4.214752] io scheduler deadline registered
[    4.214752] initcall deadline_init+0x0/0x14 returned 0 after 4224 usecs
[    4.214752] calling  cfq_init+0x0/0x9e @ 1
[    4.261873] io scheduler cfq registered (default)
[    4.262857] initcall cfq_init+0x0/0x9e returned 0 after 4724 usecs
[    4.262857] calling  percpu_counter_startup+0x0/0x33 @ 1
[    4.262857] initcall percpu_counter_startup+0x0/0x33 returned 0 after 1 usecs
[    4.262857] calling  dynamic_debug_init_debugfs+0x0/0x6a @ 1
[    4.291081] initcall dynamic_debug_init_debugfs+0x0/0x6a returned 0 after 43 usecs
[    4.292043] calling  pci_proc_init+0x0/0x6a @ 1
[    4.303505] initcall pci_proc_init+0x0/0x6a returned 0 after 261 usecs
[    4.304337] calling  pcie_portdrv_init+0x0/0x7a @ 1
[    4.315345] pcieport 0000:00:0b.0: setting latency timer to 64
(XEN) physdev.c:155: dom0: wrong map_pirq type 3
[    4.325783] pcieport 0000:00:0c.0: setting latency timer to 64
[    4.332134] pcieport 0000:00:0d.0: setting latency timer to 64
[    4.338343] pcieport 0000:00:0e.0: setting latency timer to 64
[    4.344598] initcall pcie_portdrv_init+0x0/0x7a returned 0 after 28974 usecs
[    4.345583] calling  aer_service_init+0x0/0x22 @ 1
[    4.356587] initcall aer_service_init+0x0/0x22 returned 0 after 131 usecs
[    4.357574] calling  ioapic_init+0x0/0x1b @ 1
[    4.367906] initcall ioapic_init+0x0/0x1b returned 0 after 155 usecs
[    4.368892] calling  pci_hotplug_init+0x0/0x1d @ 1
[    4.368892] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    4.368892] initcall pci_hotplug_init+0x0/0x1d returned 0 after 5491 usecs
[    4.368892] calling  pcifront_init+0x0/0x5e @ 1
[    4.368892] initcall pcifront_init+0x0/0x5e returned -19 after 0 usecs
[    4.368892] calling  genericbl_init+0x0/0x12 @ 1
[    4.408737] initcall genericbl_init+0x0/0x12 returned 0 after 139 usecs
[    4.409724] calling  cirrusfb_init+0x0/0xcf @ 1
[    4.420073] initcall cirrusfb_init+0x0/0xcf returned 0 after 170 usecs
[    4.421050] calling  efifb_init+0x0/0x1fc @ 1
[    4.421050] initcall efifb_init+0x0/0x1fc returned -19 after 4 usecs
[    4.421050] calling  acpi_reserve_resources+0x0/0xeb @ 1
[    4.421050] initcall acpi_reserve_resources+0x0/0xeb returned 0 after 3 usecs
[    4.421050] calling  irqrouter_init_ops+0x0/0x26 @ 1
[    4.421050] initcall irqrouter_init_ops+0x0/0x26 returned 0 after 0 usecs
[    4.421050] calling  acpi_ac_init+0x0/0x28 @ 1
[    4.466486] initcall acpi_ac_init+0x0/0x28 returned 0 after 196 usecs
[    4.467474] calling  acpi_button_init+0x0/0x12 @ 1
[    4.477954] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
[    4.478939] ACPI: Power Button [PWRB]
[    4.490046] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    4.491034] ACPI: Power Button [PWRF]
[    4.501283] initcall acpi_button_init+0x0/0x12 returned 0 after 22996 usecs
[    4.502271] calling  acpi_fan_init+0x0/0x18 @ 1
[    4.512966] initcall acpi_fan_init+0x0/0x18 returned 0 after 168 usecs
[    4.513952] calling  acpi_processor_init+0x0/0xcd @ 1
[    4.513952] ACPI: acpi_idle yielding to (null)
[    4.530746] initcall acpi_processor_init+0x0/0xcd returned 0 after 6038 usecs
[    4.531593] calling  acpi_container_init+0x0/0x4a @ 1
[    4.547835] initcall acpi_container_init+0x0/0x4a returned 0 after 4763 usecs
[    4.548575] calling  acpi_thermal_init+0x0/0x42 @ 1
[    4.560053] initcall acpi_thermal_init+0x0/0x42 returned 0 after 184 usecs
[    4.561041] calling  acpi_battery_init+0x0/0x16 @ 1
[    4.561041] initcall acpi_battery_init+0x0/0x16 returned 0 after 5 usecs
[    4.571853] calling  1_acpi_battery_init_async+0x0/0x1b @ 5
[    4.572171] initcall 1_acpi_battery_init_async+0x0/0x1b returned 0 after 303 usecs
[    4.561041] calling  init+0x0/0x12 @ 1
[    4.595751] initcall init+0x0/0x12 returned 0 after 128 usecs
[    4.596739] calling  xenbus_probe_initcall+0x0/0x3b @ 1
[    4.596739] initcall xenbus_probe_initcall+0x0/0x3b returned 0 after 0 usecs
[    4.596739] calling  gntdev_init+0x0/0x4d @ 1
[    4.618410] initcall gntdev_init+0x0/0x4d returned 0 after 156 usecs
[    4.619396] calling  gntalloc_init+0x0/0x68 @ 1
[    4.629445] initcall gntalloc_init+0x0/0x68 returned 0 after 129 usecs
[    4.630431] calling  hypervisor_subsys_init+0x0/0x25 @ 1
[    4.630431] initcall hypervisor_subsys_init+0x0/0x25 returned 0 after 0 usecs
[    4.630431] calling  hyper_sysfs_init+0x0/0xfb @ 1
[    4.630431] initcall hyper_sysfs_init+0x0/0xfb returned 0 after 15 usecs
[    4.630431] calling  platform_pci_module_init+0x0/0x29 @ 1
[    4.630431] initcall platform_pci_module_init+0x0/0x29 returned -19 after 0 usecs
[    4.630431] calling  xen_tmem_init+0x0/0x5c @ 1
[    4.630431] initcall xen_tmem_init+0x0/0x5c returned 0 after 0 usecs
[    4.630431] calling  xen_pcibk_init+0x0/0x152 @ 1
[    4.688965] xen-pciback: backend is vpci
[    4.693053] initcall xen_pcibk_init+0x0/0x152 returned 0 after 4056 usecs
[    4.694036] calling  pty_init+0x0/0x524 @ 1
[    4.775581] initcall pty_init+0x0/0x524 returned 0 after 69853 usecs
[    4.776565] calling  sysrq_init+0x0/0x78 @ 1
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] console [hvc0] enabled
[    4.798374] coî
