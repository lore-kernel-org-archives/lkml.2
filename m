Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751304Ab1J0Fa3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 01:30:29 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:27932 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421Ab1J0Fa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 01:30:26 -0400
Date: Thu, 27 Oct 2011 01:30:08 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: miche@google.com, gregkh@suse.de, linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com
Subject: Regression: patch " hvc_console: display printk messages on
 console." causing infinite loop with 3.2-rc0 + Xen.
Message-ID: <20111027053007.GA32765@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="C7zPtVaVf+AK4Oqc"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4EA8EC69.0189:SCFMA922111,ss=1,re=-19.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hey Miche.

The git commit 361162459f62dc0826b82c9690a741a940f457f0:

    hvc_console: display printk messages on console.

is causing an infinite loop when booting Linux under Xen, as so:

[    2.382984] console [hvc0] enabled
[    2.382984] console [hvc0] enabled
[    2.382984] console [hvc0] enabled
[    2.382984] console [hvc0] enabled
[    2.382984] console [hvc0] enabled
[    2.382984] console [hvc0] enabled
.. 

(see attached file titled bad.log)

If I use Linus's latest git tree and revert your patch I get the kernel
to bootup (see good.log file),

--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="bad.log"
Content-Transfer-Encoding: quoted-printable

PXELINUX 3.82 2009-06-09  Copyright (C) 1994-2009 H. Peter Anvin et al
Loading latest/xen.gz... ok
Loading latest/vmlinuz... ok
Loading latest/initramfs.cpio.gz... ok
 __  __            _  _    _    _ _ _  ___ ____   __  =20
 \ \/ /___ _ __   | || |  / |  / / / |/ _ \___ \ / /_ =20
  \  // _ \ '_ |__) | '_ \=20
  /  \  __/ | | | |__   _|| |__| | | | |_| / __/| (_) |
 /_/\_\___|_| |_|    |_|(_)_|  |_|_|_|\___/_____|\___/=20
                                                      =20
(XEN) Xen version 4.1-111027 (konrad@dumpdata.com) (gcc version 4.4.4 201=
00503 (Red Hat 4.4.4-2) (GCC) ) Thu Oct 27 00:58:50 EDT 2011
(XEN) Latest ChangeSet: Wed Oct 12 10:00:10 2011 -0400 23160:3660ad2b187f
(XEN) Console output is synchronous.
(XEN) Bootloader: unknown
(XEN) Command line: com1=3D115200,8n1 console=3Dcom1,vga guest_loglvl=3Da=
ll sync_console loglvl=3Dall apic=3Ddebug
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
(XEN) ACPI: XSDT CFEF0753, 009C (r1 DELL   PE_SC3    6040000 DELL        =
0)
(XEN) ACPI: FACP CFEF3C5F, 00F4 (r3 DELL   PE_SC3    6040000 DELL    F424=
0)
(XEN) ACPI: DSDT CFEF07EF, 33FC (r1 DELL   PE_SC3    6040000 MSFT  100000=
E)
(XEN) ACPI: FACS CFEF5FC0, 0040
(XEN) ACPI: TCPA CFEF3D53, 0032 (r1 Phoeni  x        6040000  TL         =
0)
(XEN) ACPI: SLIC CFEF3D85, 0024 (r1 DELL   PE_SC3    6040000 PTL         =
1)
(XEN) ACPI: SPCR CFEF3DA9, 0050 (r1 DELL   PE_SC3    6040000 PTL         =
1)
(XEN) ACPI: EINJ CFEF3DF9, 01B0 (r1 PTL    WHEAPTL   6040000 PTL         =
1)
(XEN) ACPI: HEST CFEF3FA9, 00A8 (r1 PTL    WHEAPTL   6040000 PTL         =
1)
(XEN) ACPI: BERT CFEF4051, 0030 (r1 PTL    WHEAPTL   6040000 PTL         =
1)
(XEN) ACPI: SSDT CFEF4081, 00E1 (r1 wheaos  wheaosc  6040000 INTL 2005062=
4)
(XEN) ACPI: ERST CFEF4162, 0270 (r1 PTL    WHEAPTL   6040000 PTL         =
1)
(XEN) ACPI: SRAT CFEF43D2, 00E8 (r1 AMD    HAMMER    6040000 AMD         =
1)
(XEN) ACPI: SSDT CFEF44BA, 0A30 (r1 AMD    POWERNOW  6040000 AMD         =
1)
(XEN) ACPI: MCFG CFEF4EEA, 003C (r1 PTLTD    MCFG    6040000  LTP        =
0)
(XEN) ACPI: HPET CFEF4F26, 0038 (r1 PTLTD  HPETTBL   6040000  LTP        =
1)
(XEN) ACPI: APIC CFEF4F5E, 007A (r1 PTLTD  	 APIC    6040000  LTP        =
0)
(XEN) ACPI: BOOT CFEF4FD8, 0028 (r1 PTLTD  $SBFTBL$  6040000  LTP        =
1)
(XEN) System RAM: 4094MB (4192756kB)
(XEN) SRAT: PXM 0 -> APIC 0 -> Node 0
(XEN) SRAT: PXM 0 -> APIC 1 -> Node 0
(XEN) SRAT: PXM 0 -> APIC 2 -> Node 0
(XEN) SRAT:rom 120167000 - 120169000
(XEN) NUMA: Using 8 for the hash shift.
(XEN) Domain heap initialised
(XEN) found SMP MP-table at 000f7a70
(XEN) DMI present.
(XEN) Using APIC driver default
(XEN) ACPI: PM-Timer IO Port: 0x8008
(XEN) ACPI: ACPI SLEEP INFO: pm1x_cnt[8004,0], pm1x_evt[8000,0]
(XEN) ACPI:                  wakeup_vec[cfef5fcc], vec_size[20]
(XEN) ACPI: Local APIC address 0xfee00000
(XEN) ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
(XEN) Processor #0 0:2 APIC version 16
(XEN) ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
(XEN) Processor #1 0:2 APIC version 16
(XEN) ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
(XEN) Processor #2 0:2 APIC version 16
(XEN) ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
(XEN) Processor #3 0:2 APIC version 16
(XEN) ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
(XEN) ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
(XEN) ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
(XEN) ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
(XEN) ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
(XEN) IOAPIC[0]: apic_id 4, version 17, address 0xfec00000, GSI 0-23
(XEN) ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
(XEN) ACPI: IRQ0 used by override.
(XEN) ACPI: IRQ2 used by override.
(XEN) Enabling APIC mode:  Flat.  Using 1 I/O APICs
(XEN) ACPI: HPET id: 0x10de8201 base: 0xfed00000
(XEN) PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 4
(XEN) PCI: MCFG area at e0000000 reserved in E820
(XEN) ERST table is invalid
(XEN) Using ACPI (MADT) for SMP configuration information
(XEN) IRQ limits: 24 GSI, 760 MSI/MSI-X
(XEN) Using scheduler: SMP Credit Scheduler (credit)
(XEN) Detected 2109.766 MHz processor.
(XEN) Initing memory sharing.
(XEN) AMD Fam10h machine check reporting enabled
(XEN) AO-APIC IRQs
(XEN)  -> Using new ACK method
(XEN) ..TIMER: vector=3D0xF0 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D-1
(XEN) Platform timer is 25.000MHz HPET
=FF(XEN) Allocated console ring of 32 KiB.
(XEN) HVM: ASIDs enabled.
(XEN) SVM: Support(XEN) Brought up 4 CPUs
(XEN) HPET: 3 timers in total, 0 timers will be used for broadcast
(XEN) ACPI sleep modes: S3
(XEN) MCA: Use hw thresholding t(XEN) mcheck_poll: Machine check polling =
timer started.
(XEN) *** LOADING DOMAIN 0 ***
(XEN)  Xen  kernel: 64-bit, lsb, compat32
(XEN)  Dom0 kernel: 64-bit, PAE, lsb, paddr 0x1000000 -> 0x202e000
(XEN) PHYSICAL MEMORY ARRANGEMENT:
(XEN)  Dom0 alloc.:   0000000118000000->000000011c000000 (926279 pages to=
 be allocated)
(XE00->000000012ffff600
(XEN) VIRTUAL MEMORY ARRANGEMENT:
(XEN)  Loaded kernel: ffffffff81000000->ffffffff8202e000
(XEN)  Init. ramdisk: ffffffff8202e000->ffffffff9093a600
(XEN)  Phys-Mach map: ffffffff9093b000->ffffffff910e0aa0
(XEN)  Start info:    ffffffff910e1000->ffffffff910e14b4
(XEN)  Page tables:   ffffffff910e2000->ffffffff9116f000
(XEN)  Boot stack:    ffffffff9116f000->ffffffff91170000
(XEN)  TOTAL:         ffffffff80000000->ffffffff91400000
(XEN)  ENTRY ADDRESS: ffffffff81aeb200
(XEN) Dom0 has maximum 4 VCPUs
(XEN) Scrubbing Free RAM: .done.
(XEN) Xen trace buffers: disabled
(XEN) Std. Loglevel: All
(XEN) Guest Loglevel: All
(XEN) **********************************************
(XEN) ******* WARNING: CONSOLE OUTPUT IS SYNCHRONOUS
(XEN) ******* This option is intended to aid debugging of Xen by ensuring
(XEN) ******* that all output is synchronously delivered on the serial li=
ne.
(XEN) ******* However it can introduce SIGNIFICANT latencies and affect
(XEN) ******* timekeeping. It is NOT recommended for production use!
(XEN) **********************************************
(XEN) 3... 2... 1...=20
(XEN) Xen is relinquishing VGA console.
(XEN) *** Serial input -> DOM0 (type 'CTRL-a' three times to switch input=
 to Xen)
(XEN) Freed 224kB init memory.
mapping kernel into physical memory
Xen: setup ISA identity maps
about to get started...
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.ng  cff7f-cff80 pfn range: 1 pages freed
[    0.000000] Freeing  d0000-e0000 pfn range: 65536 pages freed
[    0.000000] Freeing  f0000-f4b54 pfn range: 19284 pages freed
[    0.000000] released 84821 pages of unused memory
[    0.000000] Set 196994 page(s) to 1-1 mapping.
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
[    0.000000]  Xen: 0000000100000000 - 0000000144b55000 (usable)
[    0.000000] bootconsole [xenboot0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI present.
[    0.000000] DMI: Dell Inc. PowerEdge T105 /0RR825, BIOS 1.3.2 08/20/20=
08
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (us=
able) =3D=3D> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (us=
able)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn =3D 0x144b55 max_arch_pfn =3D 0x400000000
[    0.000000] last_pfn =3D 0xc max_arch_pfn =3D 0x400000000
[    0.000000] found SMP MP-table at [ffff8800000f7a70] f7a70
[    0.000000] initial memory mapped : 0 - 1093b000
[    0.000000] Base memory trampoline at [ffff880000098000] 98000 size 20=
480
[    0.000000] init_memory_mapping: 0000000000000000-00000000cfef0000
[    0.000000]  0000000000 - 00cfef0000 page 4k
[    0.000000] kernel direct mapping tables up to cfef0000 @ cf86b000-cfe=
f0000
[    0.000000] xen: setting RW the range cfe60000 - cfef0000
[    0.000000] init_memory_mapping: 0000000100000000-0000000144b55 kernel=
 direct mapping tables up to 144b55000 @ cee3e000-cf86b000
[    0.000000] xen: setting RW the range cf066000 - cf86b000
[    0.000000] RAMDISK: 0202e000 - 1093b000
[    0.000000] ACPI: RSDP 00000000000f79b0 00024 (v02 PTLTD )
[    0.000000] ACPI: XSDT 00000000cfef0753 0009C (v01 DELL   PE_SC3   060=
40000 DELL 00000000)
[    0.000000] ACPI: FACP 00000000cfef3c5f 000F4 (v03 DELL   PE_SC3   060=
40000 DELL 000F4240)
[    0.000000] ACPI: DSDT 00000000cfef07ef 033FC (v01 DELL   PE_SC3   060=
40000 MSFT 0100000E)
[    0.000000] ACPI: FACS 00000000cfef5fc0 00040
[    0.000000] ACPI: TCPA 00000000cfef3d53 00032 (v01 Phoeni  x       060=
40000  TL  00000000)
[    0.000000] ACPI: SLIC 00000000cfef3d85 00024 (v01 DELL   PE_SC3   060=
40000 PTL  00000001)
[    0.000000] ACPI: SPCR 00000000cfef3da9 00050 (v01 DELL   PE_SC3   060=
40000 PTL  00000001)
[    0.000000] ACPI: EINJ 00000000cfef3df9 001B0 (v01 PTL    WHEAPTL  060=
40000 PTL  00000001)
[    0.000000] ACPI: HEST 00000000cfef3fa9 000A8 (v01 PTL    WHEAPTL  060=
40000 PTL  00000001)
[    0.000000] ACPI: BERT 00000000cfef4051 00030 (v01 PTL    WHEAPTL  060=
40000 PTL  00000001)
[    0.000000] ACPI: SSDT 00000000cfef4081 000E1 (v01 wheaos  wheaosc 060=
40000 INTL 20050624)
[    0.000000] ACPI: ERST 00000000cfef4162 00270 (v01 PTL    WHEAPTL  060=
40000 PTL  00000001)
[    0.000000] ACPI: SRAT 00000000cfef43d2 000E8 (v01 AMD    HAMMER   060=
40000 AMD  00000001)
[    0.000000] ACPI: SSDT 00000000cfef44ba 00A30 (v01 AMD    POWERNOW 060=
40000 AMD  00000001)
[    0.000000] ACPI: MCFG 00000000cfef4eea 0003C (v01 PTLTD    MCFG   060=
40000  LTP 00000000)
[    0.000000] ACPI: HPET 00000000cfef4f26 00038 (v01 PTLTD  HPETTBL  060=
40000  LTP 00000001)
[    0.000000] ACPI: APIC 00000000cfef4f5e 0007A (v01 PTLTD  ? APIC   060=
40000  LTP 00000000)
[    0.000000] ACPI: BOOT 00000000cfef4fd8 00028 (v01 PTLTD  $SBFTBL$ 060=
40000  LTP 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] Scanning NUMA topology in Northbridge 24
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-0000000144b55000
[    0.000000] Initmem setup node 0 0000000000000000-0000000144b55000
[    0.000000]   NODE_DATA [00000000cfec9000 - 00000000cfeeffff]
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x0rt PFN for each node
[    0.000000] early_node_map[4] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009d
[    0.000000]     0: 0x00000100 -> 0x0007fff0
[    0.000000]     0: 0x00080000 -> 0x000cfef0
[    0.000000]     0: 0x00100000 -> 0x00144b55
[    0.000000] On node 0 totalpages: 1132994
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 5 pages reserved
[    0.000000]   DMA zone: 3912 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 16320 pages used for memmap
[    0.000000]   DMA32 zone: 831264 pages, LIFO batch:31
[    0.000000]   Normal zone: 4398 pages used for memmap
[    0.000000]   Normal zone: 277031 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x8008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (a000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x0=
2] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, version 255, address 0xfec00000, GSI=
 0-255
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x10de8201 base: 0xfed00000
[    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 272
[    0.000000] PM: Registered nosave memory: 000000000009d000 - 000000000=
009e000
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 000000000=
0100000
[    0.000000] PM: Registered nosave memory: 000000007fff0000 - 000000008=
0000000
[    0.000000] PM: Registered nosave memory: 00000000cfef0000 - 00000000c=
fef5000
[    0.000000] PM: Registered nosave memory: 00000000cfef5000 - 00000000c=
ff7f000
[    0.000000] PM: Registered nosave memory: 00000000cff7f000 - 00000000c=
ff80000
[    0.000000] PM: Registered nosave memory: 00000000cff80000 - 00000000d=
0000000
[    0.000000] PM: Registered nosave memory: 00000000d0000000 - 00000000e=
0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f=
0000000
[    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000f=
ec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000f=
ec10000
[    0.000000] PM: Registered nosave memory: 00000000fec10000 - 00000000f=
ee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000f=
ee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000f=
ff80000
[    0.000000] PM: Registered nosave memory: 00000000fff80000 - 000000010=
0000000
[    0.000000] Allocating PCI resources starting at d0000000 (gap: d00000=
00:10000000)
[    0.000000] Booting paravirtualized kernel on Xen
[    0.000000] Xen version: 4.1-111027 (preserve-AD)
[    0.000000] setup_percpu: NR_CPUS:4096 nr_cpumask_bits:4 nr_cpu_ids:4 =
nr_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff8800cf7ff000 s81472 r81=
92 d20928 u110592
[    0.000000] pcpu-alloc: s81472 r8192 d20928 u110592 alloc=3D27*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3=20
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  To=
tal pages: 1112207
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: earlyprintk=3Dxenboot debug selinux=3D=
0 console=3Dtty console=3Dhvc0 xen-pciback.hide=3D(05:00.0)(05:00.1) logl=
evel=3D10
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Placing 64MB software IO TLB between ffff8800c6800000 - ff=
ff8800ca800000
[    0.000000] software IO TLB at phys 00 - 0xca800000
[    0.000000] Memory: 2996888k/5320020k available (6348k kernel code, 78=
8044k absent, 1535088k reserved, 4745k data, 2444k init6
[    0.000000] xen: sci override: global_irq=3D9 trigger=3D0 polarity=3D1
[    0.000000] xen: registering gsi 9 triggering 0 polarity 1
[    0.000000] xen: --> pirq=3D9 -> irq=3D9 (gsi=3D9)
[    0.000000] xen: acpi sci 9
[    0.000000] xen: --> pirq=3D1 -> irq=3D1 (gsi=3D1)
[    0.000000] xen: --> pirq=3D2 -> irq=3D2 (gsi=3D2)
[    0.000000] xen: --> pirq=3D3 -> irq=3D3 (gsi=3D3)
[    0.000000] xen: --> pirq=3D4 -> irq=3D4 (gsi=3D4)
[    0.000000] xen: --> pirq=3D5 -> irq=3D5 (gsi=3D5)
[    0.000000] xen: --> pirq=3D6 -> irq=3D6 (gsi=3D6)
[    0.000000] xen: --> pirq=3D7 -> irq=3D7 (gsi=3D7)
[    0.000000] xen: --> pirq=3D8 -> irq=3D8 (gsi=3D8)
[    0.000000] xen_map_pirq_gsi: returning irq 9 for gsi 9
[    0.000000] xen: --> pirq=3D9 -> irq=3D9 (gsi=3D9)
[    0.000000] xen: --> pirq=3D10 -> ffff]
[    0.169982] pci_root PNP0A03:00: host bridge window [mem 0xd0000000-0x=
febfffff]
[    0.169982] pci_root PNP0A03:00: host bridge window [mem 0xfed40000-0x=
fed8ffff]
[    0.169982] pci 0000:00:00.0: [10de:005e] type 0 class 0x000580
[    0.169982] pci 0000:00:01.0: [10de:0051] type 0 class 0x000601
[    0.169982] pci 0000:00:01.0: reg 10: [io  0x8c00-0x8fff]
[    0.170010] pci 0000:00:01.1: [10de:0052] type 0 class 0x000c05
[    0.170982] pci 0000:00:01.1: reg 10: [io  0x2080-0x209f]
[    0.170982] pci 0000:00:01.1: reg 20: [io  0x2040-0x207f]
[    0.170982] pci 0000:00:01.1: reg 24: [io  0x2000-0x203f]
[    0.170982] pci 0000:00:01.1: PME# supported from D3hot D3cold
[    0.170982] pci 0000:00:01.1: PME# disabled
[    0.170982] pci 0000:00:02.0: [10de:005a] type 0 class 0x000c03
[    0.170982] pci 0000:00:02.0: reg 10: [mem 0xd0000000-0xd0000fff]
[    0.170982] pci 0000:00:02.0: supports D1 D2
[    0.170982] pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3col=
d
[    0.170982] pci 0000:00:02.0: PME# disabled
[    0.170982] pci 0000:00:02.1: [10de:005b] type 0 class 0x000c03
[    0.170982] pci 0000:00:02.1: reg 10: [mem 0xd0001000-0xd00010ff]
[    0.170982] pci 0000:00:02.1: supports D1 D2
[    0.170982] pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot D3col=
d
[    0.170982] pci 0000:00:02.1: PME# disabled
[    0.170982] pci 0000:00:07.0: [10de:0054] type 0 class 0x000101
[    0.170982] pci 0000:00:07.0: reg 10: [io  0x20f0-0x20f7]
[    0.170982] pci 0000:00:07.0: reg 14: [io  0x20e0-0x20e3]
[    0.170982] pci 0000:00:07.0: reg 18: [io  0x20d0-0x20d7]
[    0.170982] pci 0000:00:07.0: reg 1c: [io  0x20c0-0x20c3]
[    0.170982] pci 0000:00:07.0: reg 20: [io  0x20b0-0x20bf]
[    0.170982] pci 0000:00:07.0: reg 24: [mem 0xd0002000-0xd0002fff]
[    0.170982] pci 0000:00:08.0: [10de:0055] type 0 class 0x000101
[    0.170982] pci 0000:00:08.0: reg 10: [io  0x2440-0x2447]
[    0.170982] pci 0000:00:08.0: reg 14: [io  0x2430-0x2433]
[    0.170982] pci 0000:00:08.0: reg 18: [io  0x2420-0x2427]
[    0.170982] pci 0000:00:08.0: reg 1c: [io  0x2410-0x2413]
[    0.170982] pci 0000:00:08.0: reg 20: [io  0x2400-0x240f]
[    0.170982] pci 0000:00:08.0: reg 24: [mem 0xd0003000-0xd0003fff]
[    0.170982] pci 0000:00:09.0: [10de:005c] type 1 class 0x000604
[    0.170982] pci 0000:00:0b.0: [10de:005d] type 1 class 0x000604
[    0.170982] pci 0000:00:0b.0: PME# supported from D0 D1 D2 D3hot D3col=
d
[    0.170982] pci 0000:00:0b.0: PME# disabled
[    0.170982] pci 0000:00:0c.0: [10de:005d] type 1 class 0x000604
[    0.170982] pci 0000:00:0c.0: PME# supported from D0 D1 D2 D3hot D3col=
d
[    0.170982] pci 0000:00:0c.0: PME# disabled
[    0.171164] pci 0000:00:0d.0: [10de:005d] type 1 class 0x000604
[    0.171982] pci 0000:00:0d.0: PME# supported from D0 D1 D2 D3hot D3col=
d
[    0.171982] pci 0000:00:0d.0: PME# disabled
[    0.171982] pci 0000:00:0e.0: [10de:005d] type 1 class 0x000604
[    0.171982] pci 0000:00:0e.0: PME# supported from D0 D1 D2 D3hot D3col=
d
[    0.171982] pci 0000:00:0e.0: PME# disabled
[    0.171982] pci 0000:00:18.0: [1022:1200] type 0 class 0x000600
[    0.171999] pci 0000:00:18.1: [1022:1201] type 0 class 0x000600
[    0.172982] pci 0000:00:18.2: [1022:1202] type 0 class 0x000600
[    0.172982] pci 0000:00:18.3: [1022:1203] type 0 class 0x000600
[    0.172982] pci 0000:00:18.4: [1022:1204] type 0 class 0x000600
[    0.172982] pci 0000:01:07.0: [1077:6312] type 0 class 0x000c04
[    0.172982] pci 0000:01:07.0: reg 10: [io  0x3000-0x30ff]
[    0.172982] pci 0000:01:07.0: reg 14: [mem 0xd0110000-0xd0110fff]
[    0.172982] pci 0000:01:07.0: reg 30: [mem 0x00000000-0x0001ffff pref]
[    0.173151] pci 0000:01:08.0: [1002:515e] type 0 class 0x000300
[    0.173982] pci 0000:01:08.0: reg 10: [mem 0xd8000000-0xdfffffff pref]
[    0.173982] pci 0000:01:08.0: reg 14: [io  0x3400-0x34ff]
[    0.173982] pci 0000:01:08.0: reg 18: [mem 0xd0100000-0xd010ffff]
[    0.173982] pci 0000:01:08.0: reg 30: [mem 0x00000000-0x0001ffff pref]
[    0.173982] pci 0000:01:08.0: supports D1 D2
[    0.173982] pci 0000:00:09.0: PCI bridge to [bus 01-01]
[    0.173982] pci 0000:00:09.0:   bridge window [io  0x3000-0x3fff]
[    0.173982] pci 0000:00:09.0:   bridge window [mem 0xd0100000-0xd01fff=
ff]
[    0.173982] pci 0000:00:09.0:   bridge window [mem 0xd8000000-0xdfffff=
ff pref]
[    0.173982] pci 0000:02:00.0: [14e4:165a] type 0 class 0x000200
[    0.173982] pci 0000:02:00.0: reg 10: [mem 0xd0200000-0xd020ffff 64bit=
]
[    0.173982] pci 0000:02:00.0: PME# supported from D3hot D3cold
[    0.173982] pci 0000:02:00.0: PME# disabled
[    0.175163] pci 0000:00:0b.0: PCI bridge to [bus 02-02]
[    0.175981] pci 0000:00:0b.0:   bridge window [mem 0xd0200000-0xd02fff=
ff]
[    0.175981] pci 0000:00:0c.0: PCI bridge to [bus 03-03]
[    0.175981] pci 0000:00:0d.0: PCI bridge to [bus 04-04]
[    0.175981] pci 0000:05:00.0: [8086:105e] type 0 class 0x000200
[    0.175981] pci 0000:05:00.0: reg 10: [mem 0xd0320000-0xd033ffff]
[    0.175981] pci 0000:05:00.0: reg 14: [mem 0xd0300000-0xd031ffff]
[    0.175981] pci 0000:05:00.0: reg 18: [io  0x4000-0x401f]
[    0.175981] pci 0000:05:00.0: reg 30: [mem 0x00000000-0x0001ffff pref]
[    0.175981] pci 0000:05:00.0: PME# supported from D0 D3hot D3cold
[    0.175981] pci 0000:05:00.0: PME# disabled
[    0.175981] pci 0000:05:00.1: [8086:105e] type 0 class 0x000200
[    0.175981] pci 0000:05:00.1: reg 10: [mem 0xd0360000-0xd037ffff]
[    0.175981] pci 0000:05:00.1: reg 14: [mem 0xd0340000-0xd035ffff]
[    0.175981] pci 0000:05:00.1: reg 18: [io  0x4020-0x403f]
[    0.175981] pci 0000:05:00.1: reg 30: [mem 0x00000000-0x0001ffff pref]
[    0.175981] pci 0000:05:00.1: PME# supported from D0 D3hot D3cold
[    0.175981] pci 0000:05:00.1: PME# disabled
[    0.175981] pci 0000:05:00.0: disabling ASPM on pre-1.1 PCIe device.  =
You can enable it with 'pcie_aspm=3Dforce'
[    0.175981] pci 0000:00:0e.0: PCI bridge to [bus 05-05]
[    0.175981] pci 0000:00:0e.0:   bridge window [io  0x4000-0x4fff]
[    0.175981] pci 0000:00:0e.0:   bridge window [mem 0xd0300000-0xd03fff=
ff]
[    0.175981] pci 0000:00:0b.0: Dev MPS 128 MPSS 128 MRRS 512
[    0.175981] pci 0000:00:0b.0: Dev MPS 128 MPSS 128 MRRS 128
[    0.175981] pci 0000:02:00.0: Dev MPS 128 MPSS 128 MRRS 512
[    0.175981] pci 0000:02:00.0: Dev MPS 128 MPSS 128 MRRS 128
[    0.175981] pci 0000:00:0c.0: Dev MPS 128 MPSS 128 MRRS 512
[    0.175981] pci 0000:00:0c.0: Dev MPS 128 MPSS 128 MRRS 128
[    0.175981] pci 0000:00:0d.0: Dev MPS 128 MPSS 128 MRRS 512
[    0.175981] pci 0000:00:0d.0: Dev MPS 128 MPSS 128 MRRS 128
[    0.175981] pci 0000:00:0e.0: Dev MPS 128 MPSS 128 MRRS 512
[    0.175981] pci 0000:00:0e.0: Dev MPS 128 MPSS 128 MRRS 128
[    0.175981] pci 0000:05:00.0: Dev MPS 128 MPSS 256 MRRS 512
[    0.175981] pci 0000:05:00.0: Dev MPS 128 MPSS 128 MRRS 128
[    0.175981] pci 0000:05:00.1: Dev MPS 128 MPSS 256 MRRS 512
[    0.175981] pci 0000:05:00.1: Dev MPS 128 MPSS 128 MRRS 128
[    0.175981] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.176092] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P0._PRT]
[    0.176981] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.XVR0._PRT]
[    0.176981] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.XVR1._PRT]
[    0.176981] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.XVR2._PRT]
[    0.176981] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.XVR3._PRT]
[    0.176981]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.176981]  pci0000:00: ACPI _OSC request failed (AE_NOT_FOUND), retu=
rned control mask: 0x1d
[    0.176981] ACPI _OSC control for PCIe not granted, disabling ASPM
(XEN) PCI add device 00:00.0
(XEN) PCI add device 00:01.0
(XEN) PCI add device 00:01.1
(XEN) PCI add device 00:02.0
(XEN) PCI add device 00:02.1
(XEN) PCI add device 00:07.0
(XEN) PCI add device 00:08.0
(XEN) PCI add device 00:09.0
(XEN) PCI add device 00:0b.0
(XEN) PCI add device 00:0c.0
(XEN) PCI add device 00:0d.0
(XEN) PCI add device 00:0e.0
(XEN) PCI add device 00:18.0
(XEN) PCI add device 00:18.1
(XEN) PCI add device 00:18.2
(XEN) PCI add device 00:18.3
(XEN) PCI add device 00:18.4
(XEN) PCI add device 01:07.0
(XEN) PCI add device 01:08.0
(XEN) PCI add device 02:00.0
(XEN) PCI add device 05:00.0
(XEN) PCI add device 05:00.1
[    0.219285] ACPI: PCI Interrupt Link [LNK1] (IRQs 16 17 18 19) *0
[    0.220275] ACPI: PCI Interrupt Link [LNK2] (IRQs 16 17 18 19) *0
[    0.221097] ACPI: PCI Interrupt Link [LNK3] (IRQs 16 17 18 19) *0
[    0.222276] ACPI: PCI Interrupt Link [LNK4] (IRQs 16 17 18 19) *0
[    0.223239] ACPI: PCI Interrupt Link [LNK5] (IRQs 16 17 18 19) *0, dis=
abled.
[    0.224266] ACPI: PCI Interrupt Link [LSMB] (IRQs 20 21 22 23) *0
[    0.225144] ACPI: PCI Interrupt Link [LUS0] (IRQs 20 21 22 23) *0
[    0.226134] ACPI: PCI Interrupt Link [LUS2] (IRQs 20 21 22 23) *0, dis=
abled.
[    0.227137] ACPI: PCI Interrupt Link [LMAC] (IRQs 20 21 22 23) *0, dis=
abled.
[    0.228229] ACPI: PCI Interrupt Link [LACI] (IRQs 20 21 22 23) *0, dis=
abled.
[    0.229145] ACPI: PCI Interrupt Link [LMCI] (IRQs 20 21 22 23) *0, dis=
abled.
[    0.230131] ACPI: PCI Interrupt Link [LPID] (IRQs 20 21 22 23) *0, dis=
abled.
[    0.231141] ACPI: PCI Interrupt Link [LTID] (IRQs 20 21 22 23) *0
[    0.232157] ACPI: PCI Interrupt Link [LSI1] (IRQs 20 21 22 23) *0
[    0.233150] ACPI: PCI Interrupt Link [APCP] (IRQs 20 21 22 23) *0, dis=
abled.
[    0.234041] xen/balloon: Initialising balloon driver.
[    0.234973] last_pfn =3D 0x144b55 max_arch_pfn =3D 0x400000000
[    0.240576] xen-balloon: Initialising balloon driver.
[    0.241044] xen/balloon: Xen selfballooning driver disabled for do
[    0.242152] vgaarb: device added: PCI:0000:01:08.0,decodes=3Dio+mem,ow=
ns=3Dio+mem,locks=3Dnone
[    0.242972] vgaarb: loaded
[    0.242972] vgaarb: bridge control possible 0000:01:08.0
[    0.243062] usbcore: registered new interface driver usbfs
[    0.244155] usbcore: registered new interface driver hub
[    0.245050] usbcore: registered new device driver usb
[    0.246057] PCI: Using ACPI for IRQ routing
[    0.246971] PCI: pci_cache_line_size set to 64 bytes
[    0.247121] reserve RAM buffer: 000000000009d000 - 000000000009ffff=20
[    0.247971] reserve RAM buffer: 000000007fff0000 - 000000007fffffff=20
[    0.247971] reserve RAM buffer: 00000000cfef0000 - 00000000cfffffff=20
[    0.247971] reserve RAM buffer: 0000000144b55000 - 0000000147ffffff=20
[    0.248151] NetLabel: Initializing
[    0.248971] NetLabel:  domain hash size =3D 128
[    0.248971] NetLabel:  protocols =3D UNLABELED CIPSOv4
[    0.248971] NetLabel:  unlabeled traffic allowed by default
[    0.249326] Switching to clocksource xen
[    0.250970] Switched to NOHz mode on CPU #0
[    0.259090] Switched to NOHz mode on CPU #3
[    0.259630] Switched to NOHz mode on CPU #2
[    0.259859] Switched to NOHtype pnp registered
[    0.267231] pnp 00:00: [mem 0xffc00000-0xffffffff]
[    0.267237] pnp 00:00: [mem 0xfec00000-0xfec00fff]
[    0.267243] pnp 00:00: [mem 0xfee00000-0xfeefffff]
[    0.267249] pnp 00:00: [mem 0xfed00000-0xfed00fff]
[    0.267517] system 00:00: [mem 0xffc00000-0xffffffff] could not be res=
erved
[    0.267521] system 00:00: [mem 0xfec00000-0xfec00fff] could not be res=
erved
[    0.267526] system 00:00: [mem 0xfee00000-0xfeefffff] could not be res=
erved
[    0.267530] system 00:00: [mem 0xfed00000-0xfed00fff] has been reserve=
d
[    0.267537] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (acti=
ve)
[    0.267721] pnp 00:01: [bus 00-ff]
[    0.267724] pnp 00:01: [io  0x0cf8-0x0cff]
[    0.267728] pnp 00:01: [io  0x0000-0x0cf7 window]
[    0.267731] pnp 00:01: [io  0x0d00-0xffff window]
[    0.267735] pnp 00:01: [mem 0x000a0000-0x000bffff window]
[    0.267739] pnp 00:01: [mem 0x000c0000-0x000dffff window]
[    0.267742] pnp 00:01: [mem 0xd0000000-0xfebfffff window]
[    0.267746] pnp 00:01: [mem 0xfed40000-0xfed8ffff]
[    0.268051] pnp 00:01: Plug and Play ACPI device, IDs PNP0a03 (active)
[    0.268130] pnp 00:02: [mem 0xe0000000-0xefffffff]
[    0.268381] system 00:02: [mem 0xe0000000-0xefffffff] has been reserve=
d
[    0.268388] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (acti=
ve)
[    0.269212] pnp 00:03: [io  0x8000-0x807f]
[    0.269216] pnp 00:03: [io  0x8080-0x80ff]
[    0.269219] pnp 00:03: [io  0x8400-0x847f]
[    0.269222] pnp 00:03: [io  0x8480-0x84ff]
[    0.269225] pnp 00:03: [io  0x8800-0x887f]
[    0.269229] pnp 00:03: [io  0x8880-0x88ff]
[    0.269236] pnp 00:03: [io  0x2040-0x207f]
[    0.269239] pnp 00:03: [io  0x2000-0x203f]
[    0.269242] pnp 00:03: [io  0x0060]
[    0.269245] pnp 00:03: [io  0x0064]
[    0.269496] system 00:03: [io  0x8000-0x807f] has been reserved
[    0.269500] system 00:03: [io  0x8080-0x80ff] has been reserved
[    0.269504] system 00:03: [io  0x8400-0x847f] has been reserved
[    0.269508] system 00:03: [io  0x8480-0x84ff] has been reserved
[    0.269512] system 00:03: [io  0x8800-0x887f] has been reserved
[    0.269516] system 00:03: [io  0x8880-0x88ff] has been reserved
[    0.269519] system 00:03: [io  0x2040-0x207f] has been reserved
[    0.269523] system 00:03: [io  0x2000-0x203f] has been reserved
[    0.269530] system 00:03: Plug and Play ACPI device, IDs PNP0c02 (acti=
ve)
[    0.269728] pnp 00:04: [irq 0 disabled]
[    0.269733] xen: registering gsi 8 triggering 1 polarity 0
[    0.269741] xen_map_pirq_gsi: returning irq 8 for gsi 8
[    0.269744] xen: --> pirq=3D8 -> irq=3D8 (gsi=3D8)
[    0.269752] pnp 00:04: [irq 8]
[    0.269755] pnp 00:04: [mem 0xfed00000-0xfed003ff]
[    0.269951] pnp 00:04: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.270004] pnp 00:05: [io  0x0010-0x001f]
[    0.270007] pnp 00:05: [io  0x0022-0x003f]
[    0.270010] pnp 00:05: [io  0x0044-0x005f]
[    0.270019] pnp 00:05: [io  0x0062-0x0063]
[    0.270022] pnp 00:05: [io  0x0065-0x006f]
[    0.270025] pnp 00:05: [io  0x0072-0x0073]
[    0.270031] pnp 00:05: [io  0x0074-0x007f]
[    0.270034] pnp 00:05: [io  0x0091-0x0093]
[    0.270037] pnp 00:05: [io  0x0097-0x009f]
[    0.270044] pnp 00:05: [io  0x00a2-0x00bf]
[    0.270048] pnp 00:05: [io  0x00e0-0x00ef]
[    0.270068] pnp 00:05: [io  0x04d0-0x04d1]
[    0.270321] system 00:05: [io  0x04d0-0x04d1] has been reserved
[    0.270328] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (acti=
ve)
[    0.270390] pnp 00:06: [io  0x0000-0x0008]
[    0.270394] pnp 00:06: [io  0x000a-0x000f]
[    0.270397] pnp 00:06: [io  0x0081-0x0083]
[    0.270400] pnp 00:06: [io  0x0087]
[    0.270406] pnp 00:06: [io  0x0089-0x008b]
[    0.270409] pnp 00:06: [io  0x008f]
[    0.270412] pnp 00:06: [io  0x00c0-0x00d1]
[    0.270419] pnp 00:06: [io  0x00d4-0x00df]
[    0.270423] pnp 00:06: [dma 4]
[    0.270613] pnp 00:06: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.270643] pnp 00:07: [io  0x0061]
[    0.270849] pnp 00:07: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.270946] pnp 00:08: [io  0x0070-0x0071]
[    0.271325] pnp 00:08: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.271361] pnp 00:09: [io  0x00f0-0x00f1]
[    0.271364] xen: registering gsi 13 triggering 1 polarity 0
[    0.271369] xen_map_pirq_gsi: returning irq 13 for gsi 13
[    0.271373] xen: --> pirq=3D13 -> irq=3D13 (gsi=3D13)
[    0.271378] pnp 00:09: [irq 13]
[    0.271581] pnp 00:09: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.271614] pnp 00:0a: [io  0x0c00-0x0c7f]
[    0.271887] system 00:0a: [io  0x0c00-0x0c7f] has been reserved
[    0.271894] system 00:0a: Plug and Play ACPI device, IDs PNP0c02 (acti=
ve)
[    0.272469] pnp 00:0b: [io  0x03f8-0x03ff]
[    0.272473] xen: registering gsi 4 triggering 1 polarity 0
[    0.272478] xen_map_pirq_gsi: returning irq 4 for gsi 4
[    0.272481] xen: --> pirq=3D4 -> irq=3D4 (gsi=3D4)
[    0.272488] Already setup the GSI :4
[    0.272491] pnp 00:0b: [irq 4]
[    0.272751] pnp 00:0b: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.274118] pnp: PnP ACPI: found 12 devices
[    0.274121] ACPI: ACPI bus type pnp unregistered
[    0.276262] pciback 0000:05:00.0: seizing device
[    0.276356] pciback 0000:05:00.1: seizing device
[    0.290015] PM-Timer failed consistency check  (0x0xffffff) - aborting=
.
[    0.290106] PCI: max bus depth: 1 pci_try_num: 2
[    0.290195] pci 0000:00:0e.0: BAR 15: assigned [mem 0xd0400000-0xd04ff=
fff pref]
[    0.290202] pci 0000:01:07.0: BAR 6: assigned [mem 0xd0120000-0xd013ff=
ff pref]
[    0.290207] pci 0000:01:08.0: BAR 6: assigned [mem 0xd0140000-0xd015ff=
ff pref]
[    0.290211] pci 0000:00:09.0: PCI bridge to [bus 01-01]
[    0.290218] pci 0000:00:09.0:   bridge window [io  0x3000-0x3fff]
[    0.290229] pci 0000:00:09.0:   bridge window [mem 0xd0100000-0xd01fff=
ff]
[    0.290237] pci 0000:00:09.0:   bridge window [mem 0xd8000000-0xdfffff=
ff pref]
[    0.290251] pci 0000:00:0b.0: PCI bridge to [bus 02-02]
[    0.290262] pci 0000:00:0b.0:   bridge window [mem 0xd0200000-0xd02fff=
ff]
[    0.290280] pci 0000:00:0c.0: PCI bridge to [bus 03-03]
[    0.290305] pci 0000:00:0d.0: PCI bridge to [bus 04-04]
[    0.290333] pciback 0000:05:00.0: BAR 6: assigned [mem 0xd0400000-0xd0=
41ffff pref]
[    0.290337] pciback 0000:05:00.1: BAR 6: assigned [mem 0xd0420000-0xd0=
43ffff pref]
[    0.290341] pci 0000:00:0e.0: PCI bridge to [bus 05-05]
[    0.290347] pci 0000:00:0e.0:   bridge window [io  0x4000-0x4fff]
[    0.290358] pci 0000:00:0e.0:   bridge window [mem 0xd0300000-0xd03fff=
ff]
[    0.290374] pci 0000:00:0e.0:   bridge window [mem 0xd0400000-0xd04fff=
ff pref]
[    0.290403] pci 0000:00:09.0: setting latency timer to 64
[    0.290423] pci 0000:00:0b.0: setting latency timer to 64
[    0.290443] pci 0000:00:0c.0: setting latency timer to 64
[    0.290462] pci 0000:00:0d.0: setting latency timer to 64
[    0.290482] pci 0000:00:0e.0: setting latency timer to 64
[    0.290489] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.290492] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.290496] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.290500] pci_bus 0000:00: resource 7 [mem 0x000c0000-0x000dffff]
[    0.290504] pci_bus 0000:00: resource 8 [mem 0xd0000000-0xfebfffff]
[    0.290507] pci_bus 0000:00: resource 9 [mem 0xfed40000-0xfed8ffff]
[    0.290511] pci_bus 0000:01: resource 0 [io  0x3000-0x3fff]
[    0.290515] pci_bus 0000:01: resource 1 [mem 0xd0100000-0xd01fffff]
[    0.290518] pci_bus 0000:01: resource 2 [mem 0xd8000000-0xdfffffff pre=
f]
[    0.290522] pci_bus 0000:02: resource 1 [mem 0xd0200000-0xd02fffff]
[    0.290526] pci_bus 0000:05: resource 0 [io  0x4000-0x4fff]
[    0.290530] pci_bus 0000:05: resource 1 [mem 0xd0300000-0xd03fffff]
[    0.290534] pci_bus 0000:05: resource 2 [mem 0xd0400000-0xd04fffff pre=
f]
[    0.290613] NET: Registered protocol family 2
[    0.293036] IP route cache hash table entries: 262144 (order: 9, 20971=
52 bytes)
[    0.302728] TCP established hash table entries: 524288 (order: 11, 838=
8608 bytes)
[    0.308160] TCP bind hash table entries: 65536 (order: 8, 1048576 byte=
s)
[    0.308588] TCP: Hash tables configured (established 524288 bind 65536=
)
[    0.308593] TCP reno registered
[    0.308683] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[    0.308831] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
[    0.309110] NET: Registered protocol family 1
[    0.309525] RPC: Registered named UNIX socket transport module.
[    0.309528] RPC: Registered udp transport module.
[    0.309532] RPC: Registered tcp transport module.
[    0.309535] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    1.053320] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    1.054059] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    1.054059] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    1.054059] pci 0000:00:0b.0: Found disabled HT MSI Mapping
[    1.054059] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    1.054059] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    1.054059] pci 0000:00:0c.0: Found disabled HT MSI Mapping
[    1.054059] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    1.054059] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    1.054059] pci 0000:00:0d.0: Found disabled HT MSI Mapping
[    1.054059] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    1.054059] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    1.054059] pci 0000:00:0e.0: Found disabled HT MSI Mapping
[    1.054059] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    1.054059] pci 0000:01:08.0: Boot video device
[    1.054059] PCI: CLS 64 bytes, default 64
[    1.140558] Trying to unpack rootfs image as initramfs...
[    1.886287] Freeing initrd memory: 238644k freed
[    2.007040] DMA-API: preallocated 32768 debug entries
[    2.007058] DMA-API: debugging enabled by kernel config
[    2.017868] Simple Boot Flag at 0x62 set to 0x1
[    2.025557] Machine check injector initialized
[    2.031995] microcode: CPU0: patch_level=3D0x01000065
[    2.036856] microcode: CPU1: patch_level=3D0x01000065
[    2.041793] microcode: CPU2: patch_level=3D0x01000065
[    2.046715] microcode: CPU3: patch_level=3D0x01000065
[    2.051782] microcode: Microcode Update Driver: v2.00 <tigran@aivazian=
.fsnet.co.uk>, Peter Oruba
[    2.061663] audit: initializing netlink socket (disabled)
[    2.067069] type=3D2000 audit(1319591165.549:1): initialized
[    2.099318] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    2.117959] VFS: Disk quotas dquot_6.5.2
[    2.122491] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    2.olarity 1
[    2.241744] xen: --> pirq=3D19 -> irq=3D19 (gsi=3D19)
[    2.246450] pciback 0000:05:00.1: PCI INT B -> Link[LNK4] -> GSI 19 (l=
evel, low) -> IRQ 19
[    2.247294] pciback 0000:05:00.1: PCI INT B disabled
[    2.260541] ACPI: PCI Interrupt Link [LNK3] enabled at IRQ 18
[    2.261056] xen: registering gsi 18 triggering 0 polarity 1
[    2.271896] xen: --> pirq=3D18 -> irq=3D18 (gsi=3D18)
[    2.276615] pciback 0000:05:00.0: PCI INT A -> Link[LNK3] -> GSI 18 (l=
evel, low) -> IRQ 18
[    2.277465] pciback 0000:05:00.0: PCI INT A disabled
[    2.289964] xen-pciback: backend is vpci
[    2.382984] console [hvc0] enabled
[    2.382984] console [hvc0] enabled
[    2.382984] console [hvc0] enabled
[    2.3 2.382984] console [hvc0] enabled
[    2.382984] console [hvc0] enabled
[    2.382984] console [hvc0] enabled
[    2.382984] console [hvc0] enabled
[    2.382984] console [hvc0] enabled
[    2.382984] console [hvc0] enabled
[    2.382984] console [hvc0] enabled
[    2.382984] console [hvc0] enabled
[    2.382984] console [hvc0] enabled
[    2.3] enabled
[    2.382984] console [hvc0] enabled
[    2.382984] console [hvc0] enabled
[    2.382984] console [hvc0] enabled
[    2.382984] console [hvc0] enabled
[    2.382984] console [hvc0] enabled
[    2.382984] console [hvc0] enabled
[    2.382984] console [hvc0] enabled
[    2.382984] console [hvc0] enabled
[    2.382984] console [hvc0] enabled
[    2.382984] console [hvc0] enabled
[    2.382984] console [hvc0] enabled
[    2.382984] console [hvc0] enabled
[    2.382984] console [hvc0] enabled
[    2.382984] console [hvc0] enabled
[    2.382984] console [hvc0] enabled
[    2.382984] console [hvc0] enabled
[    2.382984] console [hvc0] enabled
[    2.382984] console [hvc0] enabled
[    2.382984] console [hvc0] enabled
[    2.382984] console [hvc0] enabled
[    2.382984] console [hvc0] enabled
[    2.382984] console [hvc0] enabled
[    2.382984] console [hvc0] enabled
[    2.382984] console [hvc0] enabled
[    2.382984] console [hvc0] enabled
[    2.382984] console [hvc0] enabled
[    2.382984] console [hvc0] enabled
[    2.382984] console [hvc0] enabled
[    2.382984] console [hvc0] enabled
[    2.382984] console [hvc0] enabled
[    2.382984] console [hvc0] enabled
[    2.382984] console [hvc0] enabled
[    2.382984] console [hvc0] enabled
[    2.382984] console [hvc0] enabled
[    2.382984] console [hvc0] enabled
[    2.382984] console [hvc0] enabled
[    2.382984] console [hvc0] enabled
[    2.382984] console [hvc0] enabled
[    2.382984] console [hvc0] enabled
[    2.382984] console [hvc0] enabled
[    2.382984] console [hvc0] enabled
[    2.382984] console [hvc0] enabled
[    2.382984] console [hvc0] enabled
[    2.382984] console [hvc0] enabled
[    2.382984] console [hvc0] enabled
[    2.382984] console [hvc0] enabled
[    2.382984] console [hvc0] enabled
[    2.382984] console [hvc0] enabled
[    2.382984] console [hvc0] enabled

--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="good.log"
Content-Transfer-Encoding: quoted-printable

PXELINUX 3.82 2009-06-09  Copyright (C) 1994-2009 H. Peter Anvin et al
Loading latest/xen.gz... ok
Loading latest/vmlinuz... ok
Loading latest/initramfs.cpio.gz... ok
 __  __            _  _    _    _ _ _  ___ ____   __  =20
 \ \/ /___ _ __   | || |  / |  / / / |/ _ \___ \ / /_ =20
  \  // _ \ '_ \  | || |_ | |__| | | | | | |__) | '_ \=20
  /  \  __/ | | | |__   _|| |__| | | | |_| / __/| (_) |
 /_/\_\___|_| |_|    |_|(_)_|  |_|_|_|\___/_____|\___/=20
                                                      =20
(XEN) Xen version 4.1-111027 (konrad@dumpdata.com) (gcc version 4.4.4 20100=
503 (Red Hat 4.4.4-2) (GCC) ) Thu Oct 27 01:12:39 EDT 2011
(XEN) Latest ChangeSet: Wed Oct 12 10:00:10 2011 -0400 23160:3660ad2b187f
(XEN) Console output is synchronous.
(XEN) Bootloader: unknown
(XEN) Command line: com1=3D115200,8n1 console=3Dcom1,vga guest_loglvl=3Dall=
 sync_console loglvl=3Dall apic=3Ddebug
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
(XEN) ACPI: FACP CFEF3C5F, 00F4 (r3 DELL   PE_SC3    6040000 DELL    F4240)
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
(XEN) SRAT: PXM 0 -> APIC 0 -> Node 0
(XEN) SRAT: PXM 0 -> APIC 1 -> Node 0
(XEN) SRAT: PXM 0 -> APIC 2 -> Node 0
(XEN) SRAT: PXM 0 -> APIC 3 -> Node 0
(XEN) SRAT: Node 0 PXM 0 0-a0000
(XEN) SRAT: Node 0 PXM 0 100000-d0000000
(XEN) SRAT: Node 0 PXM 0 100000000-130000000
(XEN) NUMA: Allocated memnodemap from 120149000 - 12014b000
(XEN) NUMA: Using 8 for the hash shift.
(XEN) Domain heap initialised
(XEN) found SMP MP-table at 000f7a70
(XEN) DMI present.
(XEN) Using APIC driver default
(XEN) 0]
(XEN) ACPI:                  wakeup_vec[cfef5fcc], vec_size[20]
(XEN) ACPI: Local APIC address 0xfee00000
(XEN) ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
(XEN) Processor #0 0:2 APIC version 16
(XEN) ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
(XEN) Processor #1 0:2 APIC version 16
(XEN) ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
(XEN) Processor #2 0:2 APIC version 16
(XEN) ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
(XEN) Processor #3 0:2 APIC version 16
(XEN) ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
(XEN) ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
(XEN) ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
(XEN) ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
(XEN) ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
(XEN) IOAPIC[0]: apic_id 4, version 17, address 0xfec00000, GSI 0-23
(XEN) ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
(XEN) ACPI: IRQ0 used by override.
(XEN) ACPI: IRQ2 used by override.
(XEN) Enabling APIC mode:  Flat.  Using 1 I/O APICs
(XEN) ACPI: HPET id: 0x10de8201 base: 0xfed00000
(XEN) PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 4
(XEN) PCI: MCFG area at e0000000 reserved in E820
(XEN) ERST table is invalid
(XEN) Using ACPI (MADT) for SMP configuration information
(XEN) IRQ limits: 24 GSI, 760 MSI/MSI-X
(XEN) Using scheduler: SMP Credit Scheduler (credit)
(XEN) Detected 2109.726 MHz processor.
(XEN) Initing memory sharing.
(XEN) AMD Fam10h machine check reporting enabled
(XEN) Anot found!
(XEN) I/O virtualisation disabled
(XEN) ENABLING IO-APIC IRQs
(XEN)  -> Using new ACK method
(XEN) ..TIMER: vector=3D0xF0 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D-1
(XEN) Platform timer is 25.000MHz HPET
=FF(XEN) Allocated console ring of 32 KiB.
(XEN) HVM: ASIDs enabled.
(XEN) SVM: Support Tables (NPT)
(XEN)  - Last Branch Record (LBR) Virtualisation
(XEN) HVM: SVM enabled
(XEN) HVM: Hardware Assisted Paging detected.
(XEN) Brought up 4 CPUs
(XEN) HPET: 3 timers in total, 0 timers will be used for broadcast
(XEN) ACPI sleep modes: S3
(XEN) MCA: Use hw thresholding tachine check polling timer started.
(XEN) *** LOADING DOMAIN 0 ***
(XEN)  Xen  kernel: 64-bit, lsb, compat32
(XEN)  Dom0 kernel: 64-bit, PAE, lsb, paddr 0x1000000 -> 0x2030000
(XEN) PHYSICAL MEMORY ARRANGEMENT:
(XEN)  Dom0 alloc.:   0000000118000000->000000011c000000 (926259 pages to b=
e allocated)
(XEN)  Init. ramdisk: 00000001216df000->000000012ffffc00
(XEN) VIRTUAL MEMORY ARRANGEMENT:
(XEN)  Loaded kernel: ffffffff81000000->ffffffff82030000
(XEN)  Init. ramdisk: ffffffff82030000->ffffffff90950c00
(XEN)  Phys-Mach map: ftack:    ffffffff91185000->ffffffff91186000
(XEN)  TOTAL:         ffffffff80000000->ffffffff91400000
(XEN)  ENTRY ADDRESS: ffffffff81aec200
(XEN) Dom0 has maximum 4 VCPUs
(XEN) Scrubbing Free RAM: .done.
(XEN) Xen trace buffers: disabled
(XEN) Std. Loglevel: All
(XEN) Guest Loglevel: All
(XEN) **********************************************
(XEN) ******* WARNING: CONSOLE OUTPUT IS SYNCHRONOUS
(XEN) ******* This option is intended to aid debugging of Xen by ensuring
(XEN) ******* that all output is synchronously delivered on the serial line.
(XEN) ******* However it can introduce SIGNIFICANT latencies and affect
(XEN) ******* timekeeping. It is NOT recommended for production use!
(XEN) **********************************************
(XEN) 3... 2... 1...=20
(XEN) Xen is relinquishing VGA console.
(XEN) *** Serial input -> DOM0 (type 'CTRL-a' three times to switch input t=
o Xen)
(XEN) Freed 224kB init memory.
mapping kernel into physical memory
Xen: setup ISA identity maps
about to get started...
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.@phenom.dumpdata.com) (gcc version 4.4.4 201=
00503 (Red Hat 4.4.4-2) (GCC) ) #1 SMP PREEMPT Thu Oct 27 01:12:30 EDT 2011
[    0.000000] Command line: earlyprintk=3Dxenboot debug selinux=3D0 consol=
e=3Dtty console=3Dhvc0 xen-pciback.hide=3D(05:00.0)(05:00.1) loglevel=3D10
[    0.000000] Freeing  9d-100 pfn range: 99 pages freed
[    0.000000] Freeing  7fff0-80000 pfn range: 16 pages freed
[    0.000000] Freeing  cfef0-f4b54 pfn range: 150628 pages freed
[    0.000000] Released 150743 pages of unused memory
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
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usab=
le) =3D=3D> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usab=
le)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn =3D 0x130000 max_arch_pfn =3D 0x400000000
[    0.000000] last_pfn =3D 0xcfef0 max_arch_pfn =3D 0x400000000
[    0.000000] found SMP MP-table at [ffff8800000f7a70] f7a70
[    0.000000] initial memory mapped : 0 - 10951000
[    0.000000] Base memory trampoline at [ffff880000098000] 98000 size 20480
[    0.000000] init_memory_mapping: 0000000000000000-00000000cfef0000
[    0.000000]  0000000000 - 00cfef0000 page 4k
[    0.000000] kernel direct mapping tables up to cfef0000 @ 97b000-1000000
[    0.000000] xen: setting RW the range f70000 - 1000000
[    0.000000] init_memory_mapping: 0000000100000000-0000000130000000
[    0.000000]  0100000000 - 0130000000 page 4k
[    0.000000] kernel direct mapping tables up to 130000000 @ cf56a000-cfef=
0000
[    0.000000] xen: setting RW the range cf6eb000 - cfef0000
[    0.000000] RAMDISK: 02030000 - 10951000
[    0.000000] ACPI: 01 DELL   PE_SC3   06040000 MSFT 0100000E)
[    0.000000] ACPI: FACS 00000000cfef5fc0 00040
[    0.000000] ACPI: TCPA 00000000cfef3d53 00032 (v01 Phoeni  x       06040=
000  TL  00000000)
[    0.000000] ACPI: SLIC 00000000cfef3d85 00024 (v01 DELL   PE_SC3   06040=
000 PTL  00000001)
[    0.000000] ACPI: SPCR 00000000cfef3da9 00050 (v01 DELL   PE_SC3   06040=
000 PTL  00000001)
[    0.000000] ACPI: EINJ 00000000cfef3df9 001B0 (v01 PTL    WHEAPTL  06040=
000 PTL  00000001)
[    0.000000] ACPI: HEST 00000000cfef3fa9 000A8 (v01 PTL    WHEAPTL  06040=
000 PTL  00000001)
[    0.000000] ACPI: BERT 00000000cfef4051 00030 (v01 PTL    WHEAPTL  06040=
000 PTL  00000001)
[    0.000000] ACPI: SSDT 00000000cfef4081 000E1 (v01 wheaos  wheaosc 06040=
000 INTL 20050624)
[    0.000000] ACPI: ERST 00000000cfef4162 00270 (v01 PTL    WHEAPTL  06040=
000 PTL  00000001)
[    0.000000] ACPI: SRAT 00000000cfef43d2 000E8 (v01 AMD    HAMMER   06040=
000 AMD  00000001)
[    0.000000] ACPI: SSDT 00000000cfef44ba 00A30 (v01 AMD    POWERNOW 06040=
000 AMD  00000001)
[    0.000000] ACPI: MCFG 00000000cfef4eea 0003C (v01 PTLTD    MCFG   06040=
000  LTP 00000000)
[    0.000000] ACPI: HPET 00000000cfef4f26 00038 (v01 PTLTD  HPETTBL  06040=
000  LTP 00000001)
[    0.000000] ACPI: APIC 00000000cfef4f5e 0007A (v01 PTLTD  ? APIC   06040=
000  LTP 00000000)
[    0.000000] ACPI: BOOT 00000000cfef4fd8 00028 (v01 PTLTD  $SBFTBL$ 06040=
000  LTP 00000001)
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
[    0.000000] ACPI: LAPIC (a lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, version 255, address 0xfec00000, GSI 0=
-255
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x10de8201 base: 0xfed00000
[    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 272
[    0.000000] PM: Registered nosave memory: 000000000009d000 - 00000000000=
9e000
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 00000000001=
00000
[    0.000000] PM: Registered nosave memory: 000000007fff0000 - 00000000800=
00000
[    0.000000] PM: Registered nosave memory: 00000000cfef0000 - 00000000cfe=
f5000
[    0.000000] PM: Registered nosave memory: 00000000cfef5000 - 00000000cff=
7f000
[    0.000000] PM: Registered nosave memory: 00000000cff7f000 - 00000000cff=
80000
[    0.000000] PM: Registered nosave memory: 00000000cff80000 - 00000000d00=
00000
[    0.000000] PM: Registered nosave memory: 00000000d0000000 - 00000000e00=
00000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f00=
00000
[    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000fec=
00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec=
10000
[    0.000000] PM: Registered nosave memory: 00000000fec10000 - 00000000fee=
00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee=
01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000fff=
80000
[    0.000000] PM: Registered nosave memory: 00000000fff80000 - 00000001000=
00000
[    0.000000] Allocating PCI resources starting at d0000000 (gap: d0000000=
:10000000)
[    0.000000] Booting paravirtualized kernel on Xen
[    0.000000] Xen version: 4.1-111027 (preserve-AD)
[    0.000000] setup_percpu: NR_CPUS:4096 nr_cpumask_bits:4 nr_cpu_ids:4 nr=
_node_ids:1
[    0.000000] PERCPU: Embedded 28 pages/cpu @ffff8800cfe33000 s82944 r8192=
 d23552 u114688
[    0.000000] pcpu-alloc: s82944 r8192 d23552 u114688 alloc=3D28*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3=20
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 1027187
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: earlyprintk=3Dxenboot debug selinux=3D0=
 console=3Dtty console=3Dhvc0 xen-pciback.hide=3D(05:00.0)(05:00.1) logleve=
l=3D10
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Placing 64MB software IO TLB between ffff8800c7000000 - ffff=
8800cb000000
[    0.000000] software IO TLB at phys 0xc7000000 - 0xcb000000
[    0.000000] Memory: 3003628k/4980736k available (6394k kernel code, 7880=
44k absent, 1189064k reserved, 4700k data, 2452k init00000] NR_IRQS:262400 =
nr_irqs:1024 16
[    0.000000] xen: sci override: global_irq=3D9 trigger=3D0 polarity=3D1
[    0.000000] xen: registering gsi 9 triggering 0 polarity 1
[    0.000000] xen: --> pirq=3D9 -> irq=3D9 (gsi=3D9)
[    0.000000] xen: acpi sci 9
[    0.000000] xen: --> pirq=3D1 -> irq=3D1 (gsi=3D1)
[    0.000000] xen: --> pirq=3D2 -> irq=3D2 (gsi=3D2)
[    0.000000] xen: --> pirq=3D3 -> irq=3D3 (gsi=3D3)
[    0.000000] xen: --> pirq=3D4 -> irq=3D4 (gsi=3D4)
[    0.000000] xen: --> pirq=3D5 -> irq=3D5 (gsi=3D5)
[    0.000000] xen: --> pirq=3D6 -> irq=3D6 (gsi=3D6)
[    0.000000] xen: --> pirq=3D7 -> irq=3D7 (gsi=3D7)
[    0.000000] xen: --> pirq=3D8 -> irq=3D8 (gsi=3D8)
[    0.000000] xen_map_pirq_gsi: returning irq 9 for gsi 9
[    0.000000] xen: --> pirq=3D9 -> irq=3D9 (gsi=3D9)
[    0.000000] xen: --> pirq=3D10 -> irq=3D10 (gsi=3D10)
[    0.000000] xen: --> pirq=3D11 -> irq=3D11 (gsi=3D11)
[    0.000000] xen: --> pirq=3D12 -> irq=3D12 (gsi=3D12)
[    0.000000] xen: --> pirq=3D13 -> irq=3D13 (gsi=3D13)
[    0.000000] xen: --> pirq=3D14 -> irq=3D14 (gsi=3D14)
[    0.000000] xen: --> pirq=3D15 -> irq=3D15 (gsi=3D15)
[    0.000000] kmemleak: Early log buffer exceeded, please increase DEBUG_K=
MEMLEAK_EARLY_LOG_SIZE
[    0.000000] kmemleak: Kernel memory leak detector disabled
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] console [hvc0] enabled, bootconsole disabled
[    0.000000] console [hvc.000999] pid_max: default: 32768 minimum: 301
[    0.001050] Security Framework initialized
[    0.001999] SELinux:  Disabled at boot.
[    0.004283] Dentry cache hash table entries: 524288 (order: 10, 4194304 =
bytes)
[    0.007676] Inode-cache hash table entries: 262144 (order: 9, 2097152 by=
tes)
[    0.008723] Mount-cache hash table entries: 256
[    0.009321] Initializing cgroup subsys cpuacct
[    0.010009] Initializing cgroup subsys freezer
[    0.011080] tseg: 00cff80000
[    0.012007] CPU: Physical Processor ID: 0
[    0.012998] CPU: Processor Core ID: 0
[    0.012998] using AMD E400 aware idle routine
[    0.014387] ACPI: Core revision 20110623
[    0.024615] ftrace: allocating 23091 entries in 91 pages
[    0.026131] cpu 0 spinlock event irq 273
[    0.027086] Performance Events: (XEN) traps.c:2432:d0 Domain attempted W=
RMSR 00[    0.036078] MCE: In-kernel MCE decoding enabled.
[    0.036997] NMI watchdog disabled (cpu0): hardware events not enabled
[    0.043021] installing Xen timer for CPU 1
[    0.044018] cpu 1 spinlock event irq 279
[    0.045187] NMI watchdog disabled (cpu1): hardware events not enabled
[    0.052018] installing Xen timer for CPU 2
[    0.053014] cpu 2 spinlock event irq 285
[    0.054158] NMI watchdog disablht up 4 CPUs
[    0.068286] PM: Registering ACPI NVS region at cfef5000 (565248 bytes)
[    0.069515] kworker/u:0 used greatest stack depth: 5288 bytes left
[    0.069515] Grant table initialized
[    0.069515] RTC time:  1:23:28, date: 10/26/11
[    0.069515] NET: Registered protocol family 16
[    0.088006] node 0 link 0: io port [1000, 4fff]
[    0.089135] node 0 link 0: io port [5000, fffff]
[    0.090002] TOM: 00000000d0000000 aka 3328M
[    0.091010] node 0 link 0: mmio [d0000000, d05fffff]
[    0.092125] node 0 link 0: mmio [fed00000, fed0ffff]
[    0.093000] node 0 link 0: mmio [d8000000, dfffffff]
[    0.094003] node 0 link 0: mmio [fec00000, fec0ffff]
[    0.095135] node 0 link 0: mmio [e0000000, efffffff]
[    0.096000] node 0 link 0: mmio [a0000, bffff]
[    0.096998] node 0 link 0: mmio [f0000000, fe0bffff]
[    0.097999] TOM2: 0000000130000000 aka 4864M
[    0.098991] bus: [00, ff] on node 0 link 0
[    0.098991] bus: 00 index 0 [io  0x0000-0xffff]
[    0.098991] bus: 00 index 1 [mem 0xd0000000-0xd7ffffff]
[    0.098991] bus: 00 index 2 [mem 0xfec10000-0xffffffff]
[    0.098991] bus: 00 index 3 [mem 0xd8000000-0xfebfffff]
[    0.098991] bus: 00 index 4 [mem 0xfec00000-0xfec0ffff]
[    0.098991] bus: 00 index 5 [mem 0x000a0000-0x000bffff]
[    0.098991] bus: 00 index 6 [mem 0x130000000-0xfcffffffff]
[    0.099138] Extended Config Space enabled on 1 nodes
[    0.100147] ACPI: bus type pci registered
[    0.101123] PCI: MMCONFIG for domain 0000 [bus 00-04] at [mem 0xe0000000=
-0xe04fffff] (base 0xe0000000)
[    0.101990] PCI: MMCONFIG at [mem 0xe0000000-0xe04fffff] reserved in E820
[    0.104173] PCI: Using configuration type 1 for base access
[    0.123096] bio: create slab <bio-0> at 0
[    0.124175] ACPI: Added _OSI(Module Device)
[    0.124988] ACPI: Added _OSI(
[    0.127148] ACPI: EC: Look up EC in DSDT
[    0.128975] \_SB_:_OSC evaluation returned wrong type
[    0.128987] _OSC req IOAPIC for interrupt routing
[    0.156655] ACPI: No dock devices found.
[    0.156984] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnoa bug
[    0.157303] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.158278] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7]
[    0.158984] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff]
[    0.158984] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x00=
0bffff]
[    0.158984] pci_root PNP0A03:00: host bridge window [mem 0x000c0000-0x00=
0dffff]
[    0.158984] pci_root PNP0A03:00: host bridge window [mem 0xd0000000-0xfe=
bfffff]
[    0.158984] pci_root PNP0A03:00: host bridge window [mem 0xfed40000-0xfe=
d8ffff]
[    0.158984] pci 0000:00:00.0: [10de:005e] type 0 class 0x000580
[    0.159121] pci 0000:00:01.0: [10de:0051] type 0 class 0x000601
[    0.159983] pci 0000:00:01.0: reg 10: [io  0x8c00-0x8fff]
[    0.160009] pci 0000:00:01.1: [10de:0052] type 0 class 0x000c05
[    0.160983] pci 0000:00:01.1: reg 10: [io  0x2080-0x209f]
[    0.160983] pci 0000:00:01.1: reg 20: [io  0x2040-0x207f]
[    0.160983] pci 0000:00:01.1: reg 24: [io  0x2000-0x203f]
[    0.160983] pci 0000:00:01.1: PME# supported from D3hot D3cold
[    0.160983] pci 0000:00:01.1: PME# disabled
[    0.160983] pci 0000:00:02.0: [10de:005a] type 0 class 0x000c03
[    0.160983] pci 0000:00:02.0: reg 10: [mem 0xd0000000-0xd0000fff]
[    0.160983] pci 0000:00:02.0: supports D1 D2
[    0.160983] pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.160983] pci 0000:00:02.0: PME# disabled
[    0.160983] pci 0000:00:02.1: [10de:005b] type 0 class 0x000c03
[    0.160983] pci 0000:00:02.1: reg 10: [mem 0xd0001000-0xd00010ff]
[    0.160983] pci 0000:00:02.1: supports D1 D2
[    0.160983] pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.160983] pci 0000:00:02.1: PME# disabled
[    0.160983] pci 0000:00:07.0: [10de:0054] type 0 class 0x000101
[    0.160983] pci 0000:00:07.0: reg 10: [io  0x20f0-0x20f7]
[    0.160983] pci 0000:00:07.0: reg 14: [io  0x20e0-0x20e3]
[    0.160983] pci 0000:00:07.0: reg 18: [io  0x20d0-0x20d7]
[    0.160983] pci 0000:00:07.0: reg 1c: [io  0x20c0-0x20c3]
[    0.160983] pci 0000:00:07.0: reg 20: [io  0x20b0-0x20bf]
[    0.160983] pci 0000:00:07.0: reg 24: [mem 0xd0002000-0xd0002fff]
[    0.160983] pci 0000:00:08.0: [10de:0055] type 0 class 0x000101
[    0.160983] pci 0000:00:08.0: reg 10: [io  0x2440-0x2447]
[    0.160983] pci 0000:00:08.0: reg 14: [io  0x2430-0x2433]
[    0.160983] pci 0000:00:08.0: reg 18: [io  0x2420-0x2427]
[    0.160983] pci 0000:00:08.0: reg 1c: [io  0x2410-0x2413]
[    0.160983] pci 0000:00:08.0: reg 20: [io  0x2400-0x240f]
[    0.160983] pci 0000:00:08.0: reg 24: [mem 0xd0003000-0xd0003fff]
[    0.160983] pci 0000:00:09.0: [10de:005c] type 1 class 0x000604
[    0.160983] pci 0000:00:0b.0: [10de:005d] type 1 class 0x000604
[    0.160983] pci 0000:00:0b.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.160983] pci 0000:00:0b.0: PME# disabled
[    0.161149] pci 0000:00:0c.0: [10de:005d] type 1 class 0x000604
[    0.161983] pci 0000:00:0c.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.161983] pci 0000:00:0c.0: PME# disabled
[    0.161983] pci 0000:00:0d.0: [10de:005d1983] pci 0000:00:0d.0: PME# dis=
abled
[    0.161983] pci 0000:00:0e.0: [10de:005d] type 1 class 0x000604
[    0.161983] pci 0000:00:0e.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.161983] pci 0000:00:0e.0: PME# disabled
[    0.161983] pci 0000:00:18.0: [1022:1200] type 0 class 0x000600
[    0.161983] pci 0000:00:18.1: [1022:1201] type 0 class 0x000600
[    0.161983] pci 0000:00:18.2: [1022:1202] type 0 class 0x000600
[    0.161983] pci 0000:00:18.3: [1022:1203] type 0 class 0x000600
[    0.161983] pci 0000:00:18.4: [1022:1204] type 0 class 0x000600
[    0.162055] pci 0000:01:07.0: [1077:6312] type 0 class 0x000c04
[    0.162983] pci 0000:01:07.0: reg 10: [io  0x3000-0x30ff]
[    0.162983] pci 0000:01:07.0: reg 14: [mem 0xd0110000-0xd0110fff]
[    0.162983] pci 0000:01:07.0: reg 30: [mem 0x00000000-0x0001ffff pref]
[    0.162983] pci 0000:01:08.0: [1002:515e] type 0 class 0x000300
[    0.162983] pci 0000:01:08.0: reg 10: [mem 0xd8000000-0xdfffffff pref]
[    0.162983] pci 0000:01:08.0: reg 14: [io  0x3400-0x34ff]
[    0.162983] pci 0000:01:08.0: reg 18: [mem 0xd0100000-0xd010ffff]
[    0.162983] pci 0000:01:08.0: reg 30: [mem 0x00000000-0x0001ffff pref]
[    0.162983] pci 0000:01:08.0: supports D1 D2
[    0.162983] pci 0000:00:09.0: PCI bridge to [bus 01-01]
[    0.162983] pci 0000:00:09.0:   bridge window [io  0x3000-0x3fff]
[    0.162983] pci 0000:00:09.0:   bridge window [mem 0xd0100000-0xd01fffff]
[    0.162983] pci 0000:00:09.0:   bridge window [mem 0xd8000000-0xdfffffff=
 pref]
[    0.162983] pci 0000:02:00.0: [14e4:165a] type 0 class 0x000200
[    0.162983] pci 0000:02:00.0: reg 10: [mem 0xd0200000-0xd020ffff 64bit]
[    0.163180] pci 0000:02:00.0: PME# supported from D3hot D3cold
[    0.163983] pci 0000:02:00.0: PME# disabled
[    0.165017] pci 0000:00:0b.0: PCI bridge to [bus 02-02]
[    0.165983] pci 0000:00:0b.0:   bridge window [mem 0xd0200000-0xd02fffff]
[    0.165983] pci 0000:00:0c.0: PCI bridge to [bus 03-03]
[    0.165983] pci 0000:00:0d.0: PCI bridge to [bus 04-04]
[    0.165983] pci 0000:05:00.0: [8086:105e] type 0 class 0x000200
[    0.165983] pci 0000:05:00.0: reg 10: [mem 0xd0320000-0xd033ffff]
[    0.165983] pci 0000:05:00.0: reg 14: [mem 0xd0300000-0xd031ffff]
[    0.165983] pci 0000:05:00.0: reg 18: [io  0x4000-0x401f]
[    0.165983] pci 0000:05:00.0: reg 30: [mem 0x00000000-0x0001ffff pref]
[    0.165983] pci 0000:05:00.0: PME# supported from D0 D3hot D3cold
[    0.165983] pci 0000:05:00.0: PME# disabled
[    0.165983] pci 0000:05:00.1: [8086:105e] type 0 class 0x000200
[    0.165983] pci 0000:05:00.1: reg 10: [mem 0xd0360000-0xd037ffff]
[    0.165983] pci 0000:05:00.1: reg 14: [mem 0xd0340000-0xd035ffff]
[    0.165983] pci 0000:05:00.1: reg 18: [io  0x4020-0x403f]
[    0.165983] pci 0000:05:00.1: reg 30: [mem 0x00000000-0x0001ffff pref]
[    0.165983] pci 0000:05:00.1: PME# supported from D0 D3hot D3cold
[    0.165983] pci 0000:05:00.1: PME# disabled
[    0.165983] pci 0000:05:00.0: disabling ASPM on pre-1.1 PCIe device.  Yo=
u can enable it with 'pcie_aspm=3Dforce'
[    0.165983] pci 0000:00:0e.0: PCI bridge to [bus 05-05]
[    0.165983] pci 0000:00:0e.0:   bridge window [io  0x4000-0x4fff]
[    0.165983] pci 0000:00:0e.0:   bridge window [mem 0xd0300000-0xd03fffff]
[    0.165983] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.166183] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P0._PRT]
[    0.166999] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.XVR0._PRT]
[    0.167982] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.XVR1._PRT]
[    0.167982] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.XVR2._PRT]
[    0.167982] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.XVR3._PRT]
[    0.167982]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.167982]  pci0000:00: ACPI _OSC request failed (AE_NOT_FOUND), return=
ed control mask: 0x1d
[    0.167982] ACPI _OSC control for PCIe not granted, disabling ASPM
(XEN) PCI add device 00:00.0
(XEN) PCI add device 00:01.0
(XEN) PCI add device 00:01.1
(XEN) PCI add device 00:02.0
(XEN) PCI add device 00:02.1
(XEN) PCI add device 00:07.0
(XEN) PCI add device 00:08.0
(XEN) PCI add device 00:09.0
(XEN) PCI add device 00:0b.0
(XEN) PCI add device 00:0c.0
(XEN) PCI add device 00:0d.0
(XEN) PCI add device 00:0e.0
(XEN) PCI add device 00:18.0
(XEN) PCI add device 00:18.1
(XEN) PCI add device 00:18.2
(XEN) PCI add device 00:18.3
(XEN) PCI add device 00:18.4
(XEN) PCI add device 01:07.0
(XEN) PCI add device 01:08.0
(XEN) PCI add device 02:00.0
(XEN) PCI add device 05:00.0
(XEN) PCI add device 05:00.1
[    0.215296] ACPI: PCI Interrupt Link [LNK1] (IRQs 16 17 18 19) *0
[    0.216228] ACPI: PCI Interrupt Link [LNK2] (IRQs 16 17 18 19) *0
[    0.217260] ACPI: PCI Interrupt Link [LNK3] (IRQs 16 17 18 19) *0
[    0.218147] ACPI: PCI Interrupt Link [LNK4] (IRQs 16 17 18 19) *0
[    0.219347] ACPI: PCI Interrupt Link [LNK5] (IRQs 16 17 18 19) *0, disab=
led.
[    0.220148] ACPI: PCI Interrupt Link [LSMB] (IRQs 20 21 22 23) *0
[    0.221261] ACPI: PCI Interrupt Link [LUS0] (IRQs 20 21 22 23) *0
[    0.222141] ACPI: PCI Interrupt Link [LUS2] (IRQs 20 21 22 23) *0, disab=
led.
[    0.223146] ACPI: PCI Interrupt Link [LMAC] (IRQs 20 21 22 23) *0, disab=
led.
[    0.224152] ACPI: PCI Interrupt Link [LACI] (IRQs 20 21 22 23) *0, disab=
led.
[    0.225146] ACPI: PCI Interrupt Link [LMCI] (IRQs 20 21 22 23) *0, disab=
led.
[    0.226152] ACPI: PCI Interrupt Link [LPID] (IRQs 20 21 22 23) *0, disab=
led.
[    0.227154] ACPI: PCI Interrupt Link [LTID] (IRQs 20 21 22 23) *0
[    0.228159] ACPI: PCI Interrupt Link [LSI1] (IRQs 20 21 22 23) *0
[    0.229241] ACPI: PCI Interrupt Link [APCP] (IRQs 20 21 22 23) *0, disab=
led.
[    0.230061] xen/balloon: Initialising balloon driver.
[    0.234817] xen-balloon: Initialising balloon driver.
[    0.235065] xen/balloon: Xen selfballooning driver disabled for domain0.
[    0.236089] vgaarb: device added: PCI:0000:01:08.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.236973] vgaarb: loaded
[    0.236973] vgaarb: bridge control possible 0000:01:08.0
[    0.237186] usbcore: registered new interface driver usbfs
[    0.238042] usbcore: registered new interface driver hub
[    0.239073] usbcore: registered new device driver usb
[    0.240074] PCI: Using ACPI for IRQ routing
[    0.240972] PCI: pci_cache_line_size set to 64 bytes
[    0.241093] reserve RAM buffer: 000000000009d000 - 000000000009ffff=20
[    0.241972] reserve RAM buffer: 000000007fff0000 - 000000007fffffff=20
[    0.241972] reserve RAM buffer: 00000000cfef0000 - 00000000cfffffff=20
[    0.242165] NetLabel: Initializing
[    0.242972] NetLabel:  domain hash size =3D 128
[    0.242972] NetLabel:  protocols =3D UNLABELED CIPSOv4
[    0.242972] NetLabel:  unlabeled traffic allowed by default
[    0.243286] Switching to clocksource xen
[    0.253714] pnp: PnP ACPI init
[    0.254693] ACPI: bus type pnp registered
[    0.261128] pnp 00:00: [mem 0xffc00000-0xffff] could not be reserved
[    0.281677] system 00:00: [mem 0xfee00000-0xfeefffff] could not be reser=
ved
[    0.281677] system 00:00: [mem 0xfed00000-0xfed00fff] has been reserved
[    0.281677] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.315354] pnp 00:01: [bus 00-ff]
[    0.316256] pnp 00:01: [io  0x0cf8-0x0cff]
[    0.316256] pnp 00:01: [io  0x0000-0x0cf7 window]
[    0.316256] pnp 00:01: [io  0x0d00-0xffff window]
[    0.316256] pnp 00:01: [mem 0x000a0000-0x000bffff window]
[    0.316256] pnp 00:01: [mem 0x000c0000-0x000dffff window]
[    0.316256] pnp 00:01: [mem 0xd0000000-0xfebfffff window]
[    0.316256] pnp 00:01: [mem 0xfed40000-0xfed8ffff]
[    0.354051] pnp 00:01: Plug and Play ACPI device, IDs PNP0a03 (active)
[    0.360758] pnp 00:02: [mem 0xe0000000-0xefffffff]
[    0.365932] system 00:02: [mem 0xe0000000-0xefffffff] has been reserved
[    0.366913] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.366913] pnp 00:03: [io  0x8000-0x807f]
[    0.366913] pnp 00:03: [io  0x8080-0x80ff]
[    0.366913] pnp 00:03: [io  0x8400-0x847f]
[    0.366913] pnp 00:03: [io  0x8480-0x84ff]
[    0.366913] pnp 00:03: [io  0x8800-0x887f]
[    0.366913] pnp 00:03: [io  0x8880-0x88ff]
[    0.366913] pnp 00:03: [io  0x2040-0x207f]
[    0.366913] pnp 00:03: [io  0x2000-0x203f]
[    0.366913] pnp 00:03: [io  0x0060]
[    0.366913] pnp 00:03: [io  0x0064]
[    0.420623] system 00:03: [io  0x8000-0x807f] has been reserved
[    0.421606] system 00:03: [io  0x8080-0x80ff] has been reserved
[    0.421606] system 00:03: [io  0x8400-0x847f] has been reserved
[    0.421606] system 00:03: [io  0x8480-0x84ff] has been reserved
[    0.421606] system 00:03: [io  0x8800-0x887f] has been reserved
[    0.421606] system 00:03: [io  0x8880-0x88ff] has been reserved
[    0.421606] system 00:03: [io  0x2040-0x207f] has been reserved
[    0.421606] system 00:03: [io  0x2000-0x203f] has been reserved
[    0.421606] system 00:03: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.421606] pnp 00:04: [irq 0 disabled]
[    0.421606] xen: registering gsi 8 triggering 1 polarity 0
[    0.484683] xen_map_pirq_gsi: returning irq 8 for gsi 8
[    0.485672] xen: --> pirq=3D8 -> irq=3D8 (gsi=3D8)
[    0.494403] pnp 00:04: [irq 8]
[    0.495274] pnp 00:04: [mem 0xfed00000-0xfed003ff]
[    0.502513] pnp 00:04: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.503501] pnp 00:05: [io  0x0010-0x001f]
[    0.503501] pnp 00:05: [io  0x0022-0x003f]
[    0.503501] pnp 00:05: [io  0x0044-0x005f]
[    0.503501] pnp 00:05: [io  0x0062-0x0063]
[    0.503501] pnp 00:05: [io  0x0065-0x006f]
[    0.503501] pnp 00:05: [io  0x0072-0x0073]
[    0.503501] pnp 00:05: [io  0x0074-0x007f]
[    0.503501] pnp 00:05: [io  0x0091-0x0093]
[    0.503501] pnp 00:05: [io  0x0097-0x009f]
[    0.503501] pnp 00:05: [io  0x00a2-0x00bf]
[    0.503501] pnp 00:05: [io  0x00e0-0x00ef]
[    0.503501] pnp 00:05: [io  0x04d0-0x04d1]
[    0.559261] system 00:05: [io  0x04d0-0x04d1] has been reserved
[    0.560003] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.560003] pnp 00:06: [io  0x0000-0x0008]
[    0.560003] pnp 00:06: [io  0x000a-0x000f]
[    0.560003] pnp 00:06: [io  0x0081-0x0083]
[    0.560003] pnp 00:06: [io  0x0087]
[    0.560003] pnp 00:06: [io  0x0089-0x008b]
[    0.560003] pnp 00:06: [io  0x008f]
[    0.560003] pnp 00:06: [io  0x00c0-0x00d1]
[    0.560003] pnp 00:06: [io  0x00d4-0x00df]
[    0.560003] pnp 00:06: [dma 4]
[    0.607525] pnp 00:06: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.608286] pnp 00:07: [io  0x0061]
[    0.617776] pnp 00:07: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.618764] pnp 00:08: [io  0x0070-0x0071]
[    0.628615] pnp 00:08: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.629603] pnp 00:09: [io  0x00f0-0x00f1]
[    0.629603] xen: registering gsi 13 triggering 1 polarity 0
[    0.644895] xen_map_pirq_gsi: returning irq 13 for gsi 13
[    0.645886] xen: --> pirq=3D13 -> irq=3D13 (gsi=3D13)
[    0.655052] pnp 00:09: [irq 13]
[    0.658392] pnp 00:09: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.659378] pnp 00:0a: [io  0x0c00-0x0c7f]
[    0.669393] system 00:0a: [io  0x0c00-0x0c7f] has been reserved
[    0.670175] system 00:0a: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.682692] pnp 00:0b: [io  0x03f8-0x03ff]
[    0.683205] xen: registering gsi 4 triggering 1 polarity 0
[    0.692426] xen_map_pirq_gsi: returning irq 4 for gsi 4
[    0.693298] xen: --> pirq=3D4 -> irq=3D4 (gsi=3D4)
[    0.701951] Already setup the GSI :4
[    0.702943] pnp 00:0b: [irq 4]
[    0.709266] pnp 00:0b: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.717400] pnp: PnP ACPI: found 12 devices
[    0.718054] ACPI: ACPI bus type pnp unregistered
[    0.728468] pciback 0000:05:00.0: seizing device
[    0.733312] pciback 0000:05:00.1: seizing device
[    0.752158] PM-Timer failed consistency check  (0x0xffffff) - aborting.
[    0.753061] PCI: max bus depth: 1 pci_try_num: 2
[    0.753061] pci 0000:00:0e.0: BAR 15: assigned [mem 0xd0400000-0xd04ffff=
f pref]
[    0.753061] pci 0000:01:07.0: BAR 6: assigned [mem 0xd0120000-0xd013ffff=
 pref]
[    0.753061] pci 0000:01:08.0: BAR 6: assigned [mem 0xd0140000-0xd015ffff=
 pref]
[    0.753061] pci 0000:00:09.0: PCI bridge to [bus 01-01]
[    0.753061] pci 0000:00:09.0:   bridge window [io  0x3000-0x3fff]
[    0.753061] pci 0000:00:09.0:   bridge window [mem 0xd0100000-0xd01fffff]
[    0.753061] pci 0000:00:09.0:   bridge window [mem 0xd8000000-0xdfffffff=
 pref]
[    0.753061] pci 0000:00:0b.0: PCI bridge to [bus 02-02]
[    0.753061] pci 0000:00:0b.0:   bridge window [mem 0xd0200000-0xd02fffff]
[    0.753061] pci 0000:00:0c.0: PCI bridge to [bus 03-03]
[    0.753061] pci 0000:00:0d.0: PCI bridge to [bus 04-04]
[    0.753061] pciback 0000:05:00.0: BAR 6: assigned [mem 0xd0400000-0xd041=
ffff pref]
[    0.753061] pciback 0000:05:00.1: BAR 6: assigned [mem 0xd0420000-0xd043=
ffff pref]
[    0.753061] pci 0000:00:0e.0: PCI bridge to [bus 05-05]
[    0.753061] pci 0000:00:0e.0:   bridge window [io  0x4000-0x4fff]
[    0.753061] pci 0000:00:0e.0:   bridge window [mem 0xd0300000-0xd03fffff]
[    0.753061] pci 0000:00:0e.0:   bridge window [mem 0xd0400000-0xd04fffff=
 pref]
[    0.753061] pci 0000:00:09.0: setting latency timer to 64
[    0.753061] pci 0000:00:0b.0: setting latency timer to 64
[    0.753061] pci 0000:00:0c.0: setting latency timer to 64
[    0.753061] pci 0000:00:0d.0: setting latency timer to 64
[    0.753061] pci 0000:00:0e.0: setting latency timer to 64
[    0.753061] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.753061] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.753061] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.753061] pci_bus 0000:00: resource 7 [mem 0x000c0000-0x000dffff]
[    0.753061] pci_bus 0000:00: resource 8 [mem 0xd0000000-0xfebfffff]
[    0.753061] pci_bus 0000:00: resource 9 [mem 0xfed40000-0xfed8ffff]
[    0.753061] pci_bus 0000:01: resource 0 [io  0x3000-0x3fff]
[    0.753061] pci_bus 0000:01: resource 1 [mem 0xd0100000-0xd01fffff]
[    0.753061] pci_bus 0000:01: resource 2 [mem 0xd8000000-0xdfffffff pref]
[    0.753061] pci_bus 0000:02: resource 1 [mem 0xd0200000-0xd02fffff]
[    0.753061] pci_bus 0000:05: resource 0 [io  0x4000-0x4fff]
[    0.753061] pci_bus 0000:05: resource 1 [mem 0xd0300000-0xd03fffff]
[    0.753061] pci_bus 0000:05: resource 2 [mem 0xd0400000-0xd04fffff pref]
[    0.983002] NET: Registered protocol family 2
[    0.988317] IP route cache hash table entries: 131072 (order: 8, 1048576=
 bytes)
[    1.001361] TCP established hash table entries: 524288 (order: 11, 83886=
08 bytes)
[    1.012831] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    1.013482] TCP: Hash tables configured (established 524288 bind 65536)
[    1.013482] TCP reno registered
[    1.029753] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    1.035960] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    1.036817] NET: Registered protocol family 1
[    1.047421] RPC: Registered named UNIX socket transport module.
[    1.048178] RPC: Registered udp transport module.
[    1.048178] RPC: Registered tcp transport module.
[    1.048178] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    1.120311] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    1.121070] pci 0000:00:00.0: Found enabled HT MSI Mapping
21070] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    1.121070] pci 0000:00:0b.0: Found disabled HT MSI Mapping
[    1.121070] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    1.121070] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    1.121070] pci 0000:00:0c.0: Found disabled HT MSI Mapping
[    1.121070] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    1.121070] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    1.121070] pci 0000:00:0d.0: Found disabled HT MSI Mapping
[    1.121070] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    1.121070] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    1.121070] pci 0000:00:0e.0: Found disabled HT MSI Mapping
[    1.121070] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    1.121070] pci 0000:01:08.0: Boot video device
[    1.121070] PCI: CLS 64 bytes, default 64
[    1.207522] Trying to unpack rootfs image as initramfs...
[    1.913680] Freeing initrd memory: 238724k freed
[    2.033419] DMA-API: preallocated 32768 debug entries
[    2.034057] DMA-API: debugging enabled by kernel config
[    2.0 2.051893] Machine check injector initialized
[    2.057897] microcode: CPU0: patch_level=3D0x01000065
[    2.062763] microcode: CPU1: patch_level=3D0x01000065
[    2.067690] microcode: CPU2: patch_level=3D0x01000065
[    2.072643] microcode: CPU3: patch_level=3D0x01000065
[    2.077687] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.f=
snet.co.uk>, Peter Oruba
[    2.087324] audit: initializing netlink socket (disabled)
[    2.092718] type=3D2000 audit(1319592210.509:1): initialized
[    2.124567] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    2.142241] VFS: Disk quotas dquot_6.5.2
[    2.146672] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    2.154747] NTFS driver 2.1.30 [Flags: R/W].
[    2.159500] msgmni has been set to 6332
[    2.164656] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 253)
[    2.165645] io scheduler noop registered
[    2.165645] io scheduler deadline registered
[    2.180505] io scheduler cfq registered (default)
[    2.185722] pcieport 0000:00:0b.0: setting latency timer to 64
(XEN) physdev.c:155: dom0: wrong map_pirq type 3
[    2.196427] pcieport 0000:00:0c.0: setting latency timer to 64
[    2.202620] pcieport 0000:00:0d.0: setting latency timer to 64
[    2.208805] pcieport 0000:00:0e.0: setting latency timer to 64
[    2.215429] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    2.221634] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0=
C:00/input/input0
[    2.222623] ACPI: Power Button [PWRB]
[    2.233722] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input1
[    2.234710] ACPI: Power Button [PWRF]
[    2.245126] ACPI: acpi_idle yielding to (null)
[    2.257152] ACPI: PCI Interrupt Link [LNK4] enabled at IRQ 19
[    2.258060] xen: registering gsi 19 triggering 0 polarity  18
[    2.288063] xen: registering gsi 18 triggering 0 polarity 1
[    2.298596] xen: --> pirq=3D18 -> irq=3D18 (gsi=3D18)
[    2.303389] pciback 0000:05:00.0: PCI INT A -> Link[LNK3] -> GSI 18 (lev=
el, low) -> IRQ 18
[    2.304166] pciback 0000:05:00.0: PCI INT A disabled
[    2.316758] xen-pciback: backend is vpci
[    2.337367] kworker/u:1 used greatest stack depth: 4936 bytes left
[    2.393104] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    2.481801] hpet_acpi_add: no address or irqs in _CRS
[    2.487146] Non-volatile memory driver v1.3
[    2.488127] Linux agpgart interface v0.103
[    2.498575] [drm] Initialized drm 1.1.0 20060810
[    2.509005] brd: module loaded
[    2.515135] loop: module loaded
[snynsky <maxk@qualcomm.com>
[    2.534988] tg3.c:v3.120 (August 18, 2011)
[    2.539552] ACPI: PCI Interrupt Link [LNK2] enabled at IRQ 17
[    2.540165] xen: registering gsi 17 triggering 0 polarity 1
[    2.551195] xen: --> pirq=3D17 -> irq=3D17 (gsi=3D17)
[    2.555707] tg3 0000:02:00.0: PCI INT A -> Link[LNK2] -> GSI 17 (level, =
low) -> IRQ 17
[    2.556695] tg3 0000:02:00.0: setting latency timer to 64
[    2.577882] tg3 0000:02:00.0: eth0: Tigon3 [partno(BCM95722) rev a200] (=
PCI Express) MAC address 00:1d:09:17:b5:46
[    2.564-bit]
[    2.613432] work_for_cpu used greatest stack depth: 4744 bytes left
[    2.620853] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    2.621841] ehci_hcd: block sizes: qh 112 qtd 96 itd 192 sitd 96
[    2.633937] ACPI: PCI Interrupt Link [LUS2] enabled at IRQ 23
[    2.634506] xen: registering gsi 23 triggering 0 polarity 1
[    2.645299] xen: --> pirq=3D23 -> irq=3D23 (gsi=3D23)
[    2.650153] ehci_hcd 0000:00:02.1: PCI INT B -> Link[LUS2] -> GSI 23 (le=
vel, low) -> IRQ 23
[    2.658516] ehci_hcd 0000:00:02.1: setting latency timer to 64
[    2.659495] ehci_hcd 0000:00:02.1: EHCI Host Controller
[    2.659495] /home/konrad/ssd/linux/drivers/usb/core/inode.c: creating fi=
le 'devices'
[    2.659495] /home/konrad/ssd/linux/drivers/usb/core/inode.c: creating fi=
le '001'
[    2.685447] ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus =
number 1
[    2.686437] ehci_hcd 0000:00:02.1: reset hcs_params 0x10148a dbg=3D1 cc=
=3D1 pcc=3D4 !ppc ports=3D10
[    2.686437] ehci_hcd 0000:00:02.1: reset portroute 0 0 0 0 0 0 0 0 0 0=
=20
[    2.686437] ehci_hcd 0000:00:02.1: reset hcc_params a086 caching frame 2=
56/512/1024 park
[    2.686437] ehci_hcd 0000:00:02.1: park 0
[    2.686437] ehci_hcd 0000:00:02.1: debug port 1
[    2.686437] ehci_hcd 0000:00:02.1: reset command 0080b32  park=3D3 ithre=
sh=3D8 Async Periodic period=3D1024 Reset HALT
[    2.686437] ehci_hcd 0000:00:02.1: bogus port configuration: cc=3D1 x pc=
c=3D4 < ports=3D10
[    2.686437] ehci_hcd 0000:00:02.1: cache line size of 64 is not supported
[    2.686437] ehci_hcd 0000:00:02.1: supports USB remote wakeup
[    2.686437] ehci_hcd 0000:00:02.1: irq 23, io mem 0xd0001000
[    2.686437] ehci_hcd 0000:00:02.1: reset command 0080b02  park=3D3 ithre=
sh=3D8 period=3D1024 Reset HALT
[    2.686437] ehci_hcd 0000:00:02.1: init command 0010005 (park)=3D0 ithre=
sh=3D1 period=3D512 RUN
[    2.784089] ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00
[    2.789882] usb usb1: default language 0x0409
[    2.794lber=3D1
[    2.795216] usb usb1: Product: EHCI Host Controller
[    2.795216] usb usb1: Manufacturer: Linux 3.1.0-04894-g4dbe431-dirty ehc=
i_hcd
[    2.795216] usb usb1: SerialNumber: 0000:00:02.1
[    2.830230] usb usb1: usb_probe_device
[    2.831210] usb usb1: configuration #1 chosen from 1 choice
[    2.839602] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[    2.845677] hub 1-0:1.0: usb_probe_interface
[    2.846658] hub 1-0:1.0: usb_probe_interface - got id
[    2.846658] hub 1-0:1.0: USB hub found
[    2.858849] hub 1-0:1.0: 10 ports detected
[    2.859830] hub 1-0:1.0: standalone hub
[    2.859830] hub 1-0:1.0: no power switching (usb 1.0)
[    2.859830] hub 1-0:1.0: individual port over-current protection
[    2.859830] hub 1-0:1.0: power on to power good time: 20ms
[    2.883734] hub 1-0:1.0: local power source is good
[    2.884583] hub 1-0:1.0: trying to enable port power on non-switchable h=
ub
[    2.895608] /home/konrad/ssd/linux/drivers/usb/core/inode.c: creating fi=
le '001'
[    2.903515] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    2.904500] ohci_hcd: block sizes: ed 80 td 96
[    2.914830] ACPI: PCI Interrupt Link [LUS0] enabled at IRQ 22
[    2.915402] xen: registering gsi 22 triggering 0 polarity 1
[    2.926191] xen: --> pirq=3D22 -> irq=3D22 (gsi=3D22)
[    2.931013] ohci_hcd 0000:00:02.0: PCI INT A -> Link[LUS0] -> GSI 22 (le=
vel, low) -> IRQ 22
[    2.939510] ohci_hcd 0000:00:02.0: setting latency timer to 64
[    2.940356] ohci_hcd 0000:00:02.0: OHCI Host Controller
[    2.950856] /home/konrad/ssd/linux/drivers/usb/core/inode.c: creating fi=
le '002'
[    2.958519] ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus =
number 2
[    2.959290] ohci_hcd 0000:00:02.0: enabled nVidia shutdown quirk
[    2.973464] ohci_hcd 0000:00:02.0: created debug files
[    2.974214] ohci_hcd 0000:00:02.0: supports USB remote wakeup
[    2.974214] ohci_hcd 0000:00:02.0: irq 22, io mem 0xd0000000
[    2.995285] hub 1-0:1.0: state 7 ports 10 chg 0000 evt 0000
[    3.043297] ohci_hcd 0000:00:02.0: OHCI controller state
[    3.044053] ohci_hcd 0000:00:02.0: OHCI 1.0, NO legacy support registers
[    3.044053] ohci_hcd 0000:00:02.0: control 0x683 RWE RWC HCFS=3Doperatio=
nal CBSR=3D3
[    3.044053] ohci_hcd 0000:00:02.0: cmdstatus 0x00000 SOC=3D0
[    3.044053] ohci_hcd 0000:00:02.0: intrstatus 0x00000004 SF
[    3.044053] ohci_hcd 0000:00:02.0: intrenable 0x8000004a MIE RHSC RD WDH
[    3.044053] ohci_hcd 0000:00:02.0: hcca frame #0028
[    3.044053] ohci_hcd 0000:00:02.0: roothub.a 0100020a POTPGT=3D1 NPS NDP=
=3D10(10)
[    3.044053] ohci_hcd 0000:00:02.0: roothub.b 00000000 PPCM=3D0000 DR=3D0=
000
[    3.044053] ohci_hcd 0000:00:02.0: roothub.status 00008000 DRWE
[    3.044053] ohci_hcd 0000:00:02.0: roothub.portstatus [0] 0x00000100 PPS
[    3.044053] ohci_hcd 0000:00:02.0: roothub.portstatus [1] 0x00000100 PPS
[    3.044053] ohci_hcd 0000:00:02.0: roothub.portstatus [2] 0x00000100 PPS
[    3.044053] ohci_hcd 0000:00:02.0: roothub.portstatus [3] 0x00000100 PPS
[    3.044053] ohci_hcd 0000:00:02.0: roothub.portstatus [4] 0x00000100 PPS
[    3.044053] ohci_hcd 0000:00:02.0: roothub.portstatus [5] 0x00000100 PPS
[    3.044053] ohci_hcd 0000:00:02.0: roothub.portstatus [6] 0x00000100 PPS
[    3.044053] ohci_hcd 0000:00:02.0: roothub.portstatus [7] 0x00000100 PPS
[    3.044053] ohci_hcd 0000:00:02.0: roothub.portstatus [8] 0x00000100 PPS
[    3.044053] ohci_hcd 0000:00:02.0: roothub.portstatus [9] 0x00000100 PPS
[    3.172976] usb usb2: default language 0x0409
[    3.177382] usb usb2: udev 1, busnum 2, minor =3D 128
[    3.178356] usb usb2: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[    3.178356] usb usb2: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    3.178356] usb usb2: Product: OHCI Host Controller
[    3.178356] usb usb2: Manufacturer: Linux 3.1.0-04894-g4dbe431-dirty ohc=
i_hcd
[    3.178356] usb usb2: SerialNumber: 0000:00:02.0
[    3.213533] usb usb2: usb_probe_device
[    3.214517] usb usb2: configuration #1 chosen from 1 choice
[    3.222900] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[    3.228971] hub 2-0:1.0: usb_probe_interface
[    3.229953] hub 2-0:1.0: usb_probe_interface - got id
[    3.229953] hub 2-0:1.0: USB hub found
[    3.242140] hub 2-0:1.0: 10 ports detected
[    3.243127] hub 2-0:1.0: standalone hub
[    3.243127] hub 2-0:1.0: no power switching (usb 1.0)
[    3.243127] hub 2-0:1.0: global over-current protection
[    3.243127] hub 2-0:1.0: power on to power good time: 2ms
[    3.266163] hub 2-0:1.0: local power source is good
[    3.267011] hub 2-0:1.0: no over-current condition exists
[    3.267011] hub 2-0:1.0: trying to enable port power on non-switchable h=
ub
[    3.283448] /home/konrad/ssd/linux/drivers/usb/core/inode.c: creating fi=
le '001'
[    3.291028] ehci_hcd 0000:00:02.1: HS companion for 0000:00:02.0
[    3.297387] uhci_hcd: USB Universal Host Controller Interface driver
[    3.304385] usbcore: registered new interface driver usblp
[    3.309987] usbcore: registered new interface driver libusual
[    3.316377] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    3.383386] hub 2-0:1.0: state 7 ports 10 chg 0000 evt 0000
[    3.574575] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.579972] mousedev: PS/2 mouse device common for all mice
[    rtc_cmos 00:08: rtc core: registered rtc_cmos as rtc0
[    3.597232] rtc0: alarms up to one year, y3k, 114 bytes nvram
[    3.603276] EFI Variables Facility v0.08 2004-May-17
[    3.608539] zram: num_devices not specified. Using default: 1
[    3.609244] zram: Creating 1 devices ...
[    3.619789] Netfilter messages via NETLINK v0.30.
[    3.624501] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    3.631312] ctnetlink v0.93: registering with nfnetlink.
[    3.639311] ip_tables: (C) 2000-2006 Netfilter Core Team
[    3.644641] TCP cubic registered
[    3.645629] Initializing XFRM netlink socket
[    3.652969] NET: Registered protocol family 10
[    3.661511] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    3.667079] IPv6 over IPv4 tunneling driver
[    3.673987] NET: Registered protocol family 17
[    3.674060] Registering the dns_resolver key type
[    3.683648] PM: Hitaskstats version 1
[    3.695173]   Magic number: 15:902:357
[    3.699244] powernow-k8: Found 1 Quad-Core AMD Opteron(tm) Processor 135=
2 (4 cpu cores) (version 2.20.00)
[    3.708998] powernow-k8: invalid pstate 1 - bad value 1.
[    3.709792] powernow-k8: Please report to BIOS manufacturer
[    3.709792] powernow-k8: invalid pstate 2 - bad value 2.
[    3.709792] powernow-k8: Please report to BIOS manufacturer
[    3.709792] powernow-k8: invalid pstate 3 - bad value 3.
[    3.709792] powernow-k8: Please report to BIOS manufacturer
[    3.709792] powernow-k8: invalid pstate 4 - bad value 4.
[    3.709792] powernow-k8: Please report to BIOS manufacturer
[    3.752891] [Firmware Bug]: powernow-k8: invalid powernow_table
^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^=
G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G=
^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^=
G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G[    3.782787] Freeing unused kernel memory:=
 2452k freed
[    3.783065] Write protecting the kernel read-only data: 10240k
[    3.804032] Freeing unused kernel memory: 1776k freed
[    3.810130] Freeing unused kernel memory: 148k freed
init started: BusyBox v1.14.3 (2011-10-26 23:42:14 EDT)
Mounting directories  [  OK  ]
mount: mount point /sys/kernel/config does not exist
FATAL: Error inserting xen_kbdfront (/lib/modules/3.1.0-04894-g4dbe431-dirt=
y/kernel/drivers/input/misc/xen-kbdfront.ko): No suchideo/xen-fbfront.ko): =
No such device
^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G[    4.491350] udevd (1403)=
: /proc/1403/oom_adj is deprecated, please use /proc/1403/oom_score_adj ins=
tead.
[    4.664588] SCSI subsystem initialized
[    4.688858] libata version 3.00 loaded.
[    4.697827] sata_nv 0000:00:07.0: version 3.5
[    4.703771] ACPI: PCI Interrupt Link [LTID] enabled at IRQ 21
[    4.703tering gsi 21 triggering 0 polarity 1
[    4.703806] xen: --> pirq=3D21 -> irq=3D21 (gsi=3D21)
[    4.703820] sata_nv 0000:00:07.0: PCI INT A -> Link[LTID] -> GSI 21 (lev=
el, low) -> IRQ 21
[    4.703950] sata_nv 0000:00:07.0: setting latency timer to 64
^G^G^G^G[    4.746625] scsi0 : sata_nv
[    4.775952] scsi1 : sata_nv
[    4.800793] ata1: SATA max UDMA/133 cmd 0x20f0 ctl 0x20e0 bmdma 0x20b0 i=
rq 21
[    4.80230 ctl 0x20c0 bmdma 0x20b8 irq 21
^G^G^G^G^G^G^G^G^G^G[    4.817379] [drm] radeon defaulting to kernel modese=
tting.
[    4.818057] [drm] radeon kernel modesetting enabled.
[    4.826234] ACPI: PCI Interrupt Link [LSI1] enabled at IRQ 20
[    4.826239] xen: registering gsi 20 triggering 0 polarity 1
[    4.826263] xen: --> pirq=3D20 -> irq=3D20 (gsi=3D20)
[    4.826272] sata_nv 0000:00:08.0: PCI INT A -> Link[LSI1] -> GSI 20 (lev=
el, low) -> IRQ 20
[    4.826366] sata_nv 0000:00:08.0: setting latency timer to 64
[    4.830581] scsi2 : sata_nv
[    4.830933] scsi3 : sata_nv
[    4.831524] ata3: SATA max UDMA/133 cmd 0x2440 ctl 0x2430 bmdma 0x2400 i=
rq 20
[    4.831529] ata4: SATA max UDMA/133 cmd 0x2420 ctl 0x2410 bmdma 0x2408 i=
rq 20
[    4.880694] ACPI: PCI Interrupt Link [LNK1] enabled at IRQ 16
[    4.881062] xen: registering gsi 16 triggering 0 polarity 1
[    4.892444] xen: --> pirq=3D16 -> irq=3D16 (gsi=3D16)
[    4.897448] radeon 0000:01:08.0: PCI INT A -> Link[LNK1] -> GSI 16 (leve=
l, low) -> IRQ 16
[    4.911270] [drm] initializing kernel modesetting (RV100 0x1002:0x515E 0=
x1028:0x0225).
[    4.919306] [drm] register mmio b01:08.0: VRAM: 128M 0x00000000D8000000 =
- 0x00000000DFFFFFFF (32M used)
[    4.931080] radeon 0000:01:08.0: GTT: 512M 0x00000000B8000000 - 0x000000=
00D7FFFFFF
^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G[    4.956861] [drm] Supports vblank ti=
mestamp caching Rev 1 (10.10.2010).
[    4.957086] ^G^G^G^G^G^G^G^G^G[    4.978385] [drm] radeon: irq initializ=
ed.
[    4.979064] [drm] Detected VRAM RAM=3D128M, BAR=3D128M
[    4.988352] [drm] RAMool allocator.
[    5.003062] [drm] radeon: 32M of VRAM memory ready
^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G[    5.024650] [drm] =
radeon: 512M of GTT memory ready.
[    5.029699] [drm] GART: num cpu pages 131072, num gpu pages 131072
[    5.058527] radeon 0000:01:08.0: WB enabled
[    5.063515] [drm] Loading R100 Microcode
[    5.081524] [drm] radeon: ring^G[    5.110509] ip used greatest stack de=
pth: 3712 bytes left
[    5.272129] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    5.276132] [drm:r100_ring_test] *ERROR* radeon: ring't worki^ng (-22).
G[    5.276146] r^adeon 0000:01:08G.0: failed initializing CP (-22).
[    5.276152] radeon 0000:01:08.0: Disabling GPU acceleration
[    5.277094] [drm] radeon: cp finalized
[    5.282536] [drm] Radeon Display Connectors
[    5.282542] [drm] Connector 0:
^[    5.282545] [Gdrm]   VGA
^[    5.282552] [Gdrm]   DDC: 0x60^ 0x60 0x60 0x60 G0x60 0x60 0x60 0x60
^[    5.282556] [Gdrm]   Encoders:
^[    5.282561] [Gdrm]     CRT1: I^NTERNAL_DAC1
G[    5.304862] [^drm] Radeon dispGlay connector VG^A-1: No monitor Gconnec=
ted or inv^alid EDIDG^G^G^G^G
^[    5.342355] aGta3: SATA link u^p 1.5 Gbps (SStaGtus 113 SControl^ 300)
G^G^G^G^G^G^G[    5.352253] ata3.00: ATAPI: HL-DT-STDVD-ROM GDRH20N, 0D04, =
max UDMA/100
[    5.358381] ata1.00: ATA-7: WDC WD800AAJS-18TDA1, 01.00A04, max UDMA/133
[    5.358387] ata1.00: 156250000 sectors, multi 0: LBA48 NCQ (depth 0/32)
[    5.361714] ata1.00: configured for UDMA/133
[    5.361909] scsi 0:0:0:0: Direct-Access     ATA      WDC WD800AAJS-18 01=
=2E0 PQ: 0 ANSI: 5
[    5.391292] ata3.00: configured for UDMA/100
[    5.393676] [drm] fb mappable at 0xD8040000
[    5.393679] [drm] vram appm]    pitch is 1024
G[    5.393868] f^bcon: radeondrmfGb (fb0) is prima^ry device
G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^GWaiting for devices [  OK  ]
[    5.583222] Console: switching to colour frame buffer device 128x48
[    5.591060] fb0: radeondrmfb frame buffer device
[ 0
^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G[    5.689104] at=
a2: SATA link down (SStatus 0 SControl 300)
[    5.707168] scsi 2:0:0:0: CD-ROM            HL-DT-ST DVD-ROM GDRH20N  0D=
04 PQ: 0 ANSI: 5
[    6.019102] ata4: SATA link down (SStatus 0 SControl 300)
[    6.042254] sd 0:0:0:0: [sda] 156250000 512-byte logical blockmc drive: =
48x/48x cd/rw xa/form2 cdda tray
[    6.043824] cdrom: Uniform CD-ROM driver Revision: 3.20
[    6.044331] sr 2:0:0:0: Attached scsi CD-ROM sr0
^G^G[    6.066514] s^d 0:0:0:0: [sda]G Write Protect i^s off
G[    6.067090] s^d 0:0:0:0: [sda]G Mode Sense: 00 3a 00 00
^G^G^G[    6.077470] s^d 0:0:0:0: [sda]G Write cache: en^abled, read cachGe=
: enabled, does^n't support DPO Gor FUA
^G^G[    6.087677] qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA =
Driver: 8.03.07.07-k.
[    6.096388]  sda: sda1 sda2
[    6.096736] xen: registering gsi 19 triggering 0 polarity 1
[    6.096745] xen_map_pirq_gsi: returning irq 19 for gsi 19
[    6.096748] xen: --> pirq=3D19 -> irq=3D19 (gsi=3D19)
[    6.096752] Already setup the GSI :19
[    6.096758] qla2xxx 0000:01:07.0: PCI INT A -> Link[LNK4] -> GSI 19 (lev=
el, low) -> IRQ 19
[    6.096806] qla2xxx [0000:01:07.0]-001d: : Found an ISP6312 irq 19 iobas=
e 0xffffc9000067c000.
[    6.097160] qla2xxx [0000:01:07.0]-0040:4: Configuring PCI space...
[    6.097453] qla2xxx [0000:01:07.0]-0061:4: Configure NVRAM parameters...
[    6.153^G^G^G^G^G^G^G^G^G[    6.169942] sd 0:0:0:0: Attached scsi generi=
c sg0 type 0
[    6.178857] sr 2:0:0:0: Attached scsi generic sg1 type 5
[    6.226909] qla2xxx [0000:01:07.0]-0078:4: Verifying loaded RISC code...
[    6.326395] qla2xxx [0000:01:07.0]-00c5:4: Allocated (412 KB) for firmwa=
re dump.
[    6.491258] scsi4 : qla2xxx
[    6.498666] qla2xxx [0000:01:07.0]-00fa:4: QLogic Fibre Channed HBA Driv=
er: 8.03.07.07-k.
[    6.499643] qla2xxx [0000:01:0
^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^=
G^G^GWaiting for fb [  OK  ]
Starting..[/dev/fb0]
/dev/fb0: len:0
/dev/fb0: bits/pixel8
(7fcf928ad000): Writting .. [1024:768]
Done!
FATAL: Module agpgart_intel not found.
[    6.642887] wmi: Mapper loaded
[    6.732573] [drm:i915_init] *ERROR* drm/i915 can't work without intel_ag=
p module!
FATAL: Error inserting i915 (/lib/modules/3.1.0-04894-g4dbe431-dirty/kernel=
/drivers/gpu/drm/i915/i915.ko): No such device
Starting..[/dev/fb0]
/dev/fb0: len:0
/dev/fb0: bits/pixel8
(7f41d847e000): Writting .. [1024:768]
Done!
VGA: 0000:01:08.0
Waiting for network [  OK  ]
Bringing up loopback interface:  [  OK  ]
Bringing up interface eth0:  [    7.447693] ADDRCONF(NETDEV_UP): eth0: link=
 is not ready
[    7.461660] device eth0 entered promiscuous mode
[  OK  ]
Bringing up interface switch: =20
Determining IP information for switch...[    7.578671] ADDRCONF(NETDEV_UP):=
 switch: link is not ready
[   10.170794] tg3 0000:02:00.0: eth0: Link is up at 1000 Mbps, full duplex
[   10.171059] tg3 0000:02:00.0: eth0: Flow control is on for TX and on for=
 RX
[   10.192313] ADDRCONF(NETDEV_CHANGE): eth0: lwitch: port 1(eth0) entering=
 forwarding state
[   10.221090] ADDRCONF(NETDEV_CHANGE): switch: link becomes ready
 done.
[  OK  ]
Waiting for init.custom [  OK  ]
Start sshd
PING master.dumpdata.com (192.168.101.1) 56(84) bytes of data.

--- master.dumpdata.com ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 1ms
rtt min/avg/max/mdev =3D 0.312/0.312/0.312/0.000 ms
[   12.185065] mount.nfs used greatest stack depth: 3264 bytes left

Starting SSHd ...
ERROR: Module radeon is in use
[   12.234915] [drm] Module unloaded
 [0x0->0x9d] pfn
 [0x9d->0x100] identity
 [0x100->0x7fff0] pfn
 [0x7fff0->0x80000] identity
 [0x80000->0xcfef0] pfn
 [0x0->0xf4c00] level entry
 [0xcfef0->0x100000] identity
 [0xf4c00->0x100000] level middle
 [0x100000->0x1ffffff] missing
 [0x100000->0x1ffffff] level top
libxl: error: libxl.c:56:libxl_ctx_init Is xenstore daemon running?
failed to stat /var/run/xenstored.pid: No such file or directory
cannot init xl context
Waiting for SSHd [  OK  ]
WARNING: ssh currently running [2920] ignoring start request
[   13.042309] tg3 0000:02:00.0: single idx 3 P=3Dbe258040 D=3D3e806040 L=
=3D640 DMA_FROM_DEVICE
[   13.043122] tg3 0000:02:00.0: single idx 3 P=3Dbe258840 D=3D3e806840 L=
=3D640 DMA_FROM_DEVICE
[   13.043122] tg3 0000:02:00.0: single idx 3 P=3Dbe259040 D=3D3e807040 L=
=3D640 DMA_FROM_DEVICE
[   13.043122] tg3 0000:02:00.0: sinidx 4 P=3Dbe25a040 D=3D3e808040 L=3D640=
 DMA_FROM_DEVICE
[   13.043122] tg3 0000:02:00.0: single idx 4 P=3Dbe25a840 D=3D3e808840 L=
=3D640 DMA_FROM_DEVICE
[   13.043122] tg3 0000:02:00.0: sin[   13.043122] tg3 0000:02:00.0: single=
 idx 5 P=3Dbe25c040 D=3D3e80a040 L=3D640 DMA_FROM_DEVICE
[   13.043122] tg3 0000:02:00.0: single idx 5 P=3Dbe25c840 D=3D3e80a840 L=
=3D640 DMA_FROM_DEVICE
[   13.043122] tg3 0000:02:00.0: single idx 5 P=3Dbe25d040 D=3D3e80b040 L=
=3D640 DMA_FROM_DEVICE
[   13.043122] tg3 0000:02:00.0: sin D=3D3e80b840 L=3D640 DMA_FROM_DEVICE
[   13.043122] tg3 0000:02:00.0: single idx 6 P=3Dbe25e040 D=3D3e80c040 L=
=3D640 DMA_FROM_DEVICE
[   13.043122] tg3 0000:02:00.0: sin000:02:00.0: single idx 6 P=3Dbe25f840 =
D=3D3e80d840 L=3D640 DMA_FROM_DEVICE
[   13.043122] tg3 0000:02:00.0: single idx 71 P=3Dbe2e0040 D=3D3e88e040 L=
=3D640 DMA_FROM_DEVICE
[   13.043122] tg3 0000:02:00.0: single idx 71 P=3Dbe2e0840 D=3D3e88e840 L=
=3D640 DMA_FROM_DEVICE
[   13.043122] tg3 0000:02:00.0: single idx 71 P=3Dbe2e1040 D=3D3e88f040 L=
=3D640 DMA_FROM_DEVICE
[   13.043122] tg3 0000:02:00.0: single idx 71 P=3Dbe2e1840 D=3D3e88f840 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 72 P=3Dbe2e2040 D=3D3e890040 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0:
 single idx 72 P    SSH started [2920]
=3Dbe2e2840 D=3D3e89
0840 L=3D640 DMA_FROM_DEVICE

[   13.255338] tg3 0000:02:00.0: single idx 72 P=3Dbe2e3040 D=3D3e891040 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 72 P=3Dbe2e3840 D=3D3e891840 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 73 P=3Dbe2e4040 D=3D3e892040 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 73 P=3Dbe2e4840 D=3D3e892840 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 73 P=3Dbe2e5040 D=3D3e893040 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 73 P=3Dbe2e5840 D=3D3e893840 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 74 P=3Dbe2e6040 D=3D3e894040 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 74 P=3Dbe2e6840 D=3D3e894840 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: si0 D=3D3e895040 L=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 74 P=3Dbe2e7840 D=3D3e895840 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] sata_nv 0000:00:08.0: coherent idx 102 P=3Dbe31f000 D=3D3e8c=
d000 L=3D800 DMA_BIDIRECTIONAL
[   13.255338] sata_nv 0000:00:08.0: coherent idx 108 P=3Dbe32b000 D=3D3e8d=
9000 L=3D800 DMA_BIDIRECTIONAL
[   13.255338] tg3 0000:02:00.0: single idx 231 P=3Dbe420040 D=3D3e9ce040 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 231 P=3Dbe420840 D=3D3e9ce840 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 231 P=3Dbe421040 D=3D3e9cf040 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 231 P=3Dbe421840 D=3D3e9cf840 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 232 P=3Dbe422040 D=3D3e9d0040 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 232 P=3Dbe422840 D=3D3e9d0840 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 232 P=3Dbe423040 D=3D3e9d1040 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 232 P=3Dbe423840 D=3D3e9d1840 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 233 P=3Dbe424040 D=3D3e9d2040 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 233 P=3Dbe424840 D=3D3e9d2840 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 233 P=3Dbe425040 D=3D3e9d3040 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 233 P=3Dbe425840 D=3D3e9d3840 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 234 P=3Dbe426040 D=3D3e9d4040 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 234 P=3Dbe426840 D=3D3e9d4840 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 234 P=3Dbe427040 D=3D3e9d5040 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 234 P=3Dbe427840 D=3D3e9d5840 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 235 P=3Dbe428040 D=3D3e9d6040 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 235 P=3Dbe428840 D=3D3e9d6840 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 235 P=3Dbe429040 D=3D3e9d7040 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 235 P=3Dbe429840 D=3D3e9d7840 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 236 P=3Dbe42a040 D=3D3e9d8040 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 236 P=3Dbe42a840 D=3D3e9d8840 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 243 P=3Dbe438040 D=3D3e9e6040 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 243 P=3Dbe438840 D=3D3e9e6840 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 243 P=3Dbe439040 D=3D3e9e7040 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 243 P=3Dbe439840 D=3D3e9e7840 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 244 P=3Dbe43a040 D=3D3e9e8040 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 244 P=3Dbe43a840 D=3D3e9e8840 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 244 P=3Dbe43b040 D=3D3e9e9040 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 244 P=3Dbe43b840 D=3D3e9e9840 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 245 P=3Dbe43c040 D=3D3e9ea040 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 245 P=3Dbe43c840 D=3D3e9ea840 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 245 P=3Dbe43d040 D=3D3e9eb040 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 245 P=3Dbe43d840 D=3D3e9eb840 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 246 P=3Dbe43e040 D=3D3e9ec040 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 246 P=3Dbe43e840 D=3D3e9ec840 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 246 P=3Dbe43f040 D=3D3e9ed040 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 246 P=3Dbe43f840 D=3D3e9ed840 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: coherent idx 264 P=3Dbe062000 D=3D3ea10000=
 L=3D2000 DMA_BIDIRECTIONAL
[   13.255338] tg3 0000:02:00.0: single idx 299 P=3Dbe0a8040 D=3D3ea56040 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 299 P=3Dbe0a8840 D=3D3ea56840 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 299 P=3Dbe0a9040 D=3D3ea57040 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 299 P=3Dbe0a9840 D=3D3ea57840 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 300 P=3Dbe0aa040 D=3D3ea58040 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 300 P=3Dbe0aa840 D=3D3ea58840 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 300 P=3Dbe0ab040 D=3D3ea59040 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 300 P=3Dbe0ab840 D=3D3ea59840 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 301 P=3Dbe0ac040 D=3D3ea5a040 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 301 P=3Dbe0ac840 D=3D3ea5a840 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 301 P=3Dbe0ad040 D=3D3ea5b040 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 301 P=3Dbe0ad840 D=3D3ea5b840 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 302 P=3Dbe0ae040 D=3D3ea5c040 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 302 P=3Dbe0ae840 D=3D3ea5c840 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 302 P=3Dbe0af040 D=3D3ea5d040 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 302 P=3Dbe0af840 D=3D3ea5d840 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 315 P=3Dbe8c8040 D=3D3e276040 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 317 P=3Dbe8cd040 D=3D3e27b040 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 317 P=3Dbe8cc840 D=3D3e27a840 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 323 P=3Dbe8d8040 D=3D3e286040 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 323 P=3Dbe8d8840 D=3D3e286840 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 323 P=3Dbe8d9040 D=3D3e287040 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 323 P=3Dbe8d9840 D=3D3e287840 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 324 P=3Dbe8da040 D=3D3e288040 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 324 P=3Dbe8da840 D=3D3e288840 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 324 P=3Dbe8db040 D=3D3e289040 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 324 P=3Dbe8db840 D=3D3e289840 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 325 P=3Dbe8dc040 D=3D3e28a040 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 325 P=3Dbe8dc840 D=3D3e28a840 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 325 P=3Dbe8dd040 D=3D3e28b040 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 325 P=3Dbe8dd840 D=3D3e28b840 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 326 P=3Dbe8de040 D=3D3e28c040 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 326 P=3Dbe8de840 D=3D3e28c840 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 326 P=3Dbe8df040 D=3D3e28d040 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 326 P=3Dbe8df840 D=3D3e28d840 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] qla2xxx 0000:01:07.0: coherent idx 327 P=3Dbe8e0000 D=3D3e28=
e000 L=3D8040 DMA_BIDIRECTIONAL
[   13.255338] tg3 0000:02:00.0: single idx 347 P=3Dbe109840 D=3D3eab7840 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 347 P=3Dbe109040 D=3D3eab7040 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 347 P=3Dbe108840 D=3D3eab6840 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 347 P=3Dbe108040 D=3D3eab6040 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 348 P=3Dbe10b840 D=3D3eab9840 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 348 P=3Dbe10b040 D=3D3eab9040 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 348 P=3Dbe10a840 D=3D3eab8840 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 348 P=3Dbe10a040 D=3D3eab8040 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 349 P=3Dbe10d840 D=3D3eabb840 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 349 P=3Dbe10c040 D=3D3eaba040 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 349 P=3Dbe10c840 D=3D3eaba840 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 350 P=3Dbe10f040 D=3D3eabd040 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 350 P=3Dbe10f840 D=3D3eabd840 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] qla2xxx 0000:01:07.0: coherent idx 389 P=3Dbe15d000 D=3D3eb0=
b000 L=3D60 DMA_BIDIRECTIONAL
[   13.255338] qla2xxx 0000:01:07.0: coherent idx 389 P=3Dbe15c000 D=3D3eb0=
a000 L=3D1000 DMA_BIDIRECTIONAL
[   13.255338] tg3 0000:02:00.0: coherent idx 389 P=3Dbe95c000 D=3D3e30a000=
 L=3D4000 DMA_BIDIRECTIONAL
[   13.255338] tg3 0000:02:00.0: single idx 391 P=3Dbe160040 D=3D3eb0e040 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 391 P=3Dbe160840 D=3D3eb0e840 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 391 P=3Dbe161040 D=3D3eb0f040 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 391 P=3Dbe161840 D=3D3eb0f840 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 392 P=3Dbe162040 D=3D3eb10040 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 392 P=3Dbe162840 D=3D3eb10840 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 392 P=3Dbe163040 D=3D3eb11040 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 392 P=3Dbe55338] tg3 0000:02:00=
=2E0: single idx 393 P=3Dbe164840 D=3D3eb12840 L=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 393 P=3Dbe165040 D=3D3eb13040 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 393 P=3Dbe165840 D=3D3eb13840 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 394 P=3Dbe166040 D=3D3eb14040 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 394 P=3Dbe166840 D=3D3eb14840 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 394 P=3Dbe167040 D=3D3eb15040 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 394 P=3Dbe167840 D=3D3eb15840 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 487 P=3Dbe220040 D=3D3ebce040 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 487 P=3Dbe220840 D=3D3ebce840 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 487 P=3Dbe221840 D=3D3ebcf840 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 488 P=3Dbe222040 D=3D3ebd0040 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 488 P=3Dbe222840 D=3D3ebd0840 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 488 P=3Dbe223040 D=3D3ebd1040 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 488 P=3Dbe223840 D=3D3ebd1840 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 489 P=3Dbe224040 D=3D3ebd2040 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 489 P=3Dbe224840 D=3D3ebd2840 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 489 P=3Dbe225040 D=3D3ebd3040 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 489 P=3Dbe225840 D=3D3ebd3840 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 490 P=3Dbe226040 D=3D3ebd4040 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 490 P=3Dbe226840 D=3D3ebd4840 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 490 P=3Dbe227040 D=3D3ebd5040 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 490 P=3Dbe227840 D=3D3ebd5840 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] ohci_hcd 0000:00:02.0: coherent idx 571 P=3D1011c000 D=3Dcfc=
77000 L=3D100 DMA_BIDIRECTIONAL
[   13.255338] sata_nv 0000:00:07.0: coherent idx 571 P=3Dffb9000 D=3Dcfc76=
000 L=3D800 DMA_BIDIRECTIONAL
[   13.255338] tg3 0000:02:00.0: single idx 595 P=3Dbdef8040 D=3D3eca6040 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 595 P=3Dbdef8840 D=3D3eca6840 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 595 P=3Dbdef9040 D=3D3eca7040 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 595 P=3Dbdef9840 D=3D3eca7840 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 596 P=3Dbdefa040 D=3D3eca8040 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 596 P=3Dbdefa840 D=3D3eca8840 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 596 P=3Dbdefb040 D=3D3eca9040 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 596 P=3Dbdefb840 D=3D3eca9840 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 597 P=3Dbdefc040 D=3D3ecaa040 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 597 P=3Dbdefc840 D=3D3ecaa840 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 597 P=3Dbdefd040 D=3D3ecab040 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 597 P=3Dbdefd840 D=3D3ecab840 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 598 P=3Dbdefe040 D=3D3ecac040 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 598 P=3Dbdefe840 D=3D3ecac840 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 598 P=3Dbdeff040 D=3D3ecad040 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 598 P=3Dbdeff840 D=3D3ecad840 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 625 P=3Dfe34840 D=3D12f4e3840 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] sata_nv 0000:00:07.0: coherent idx 640 P=3Db6753000 D=3D4650=
1000 L=3D800 DMA_BIDIRECTIONAL
[   13.255338] tg3 0000:02:00.0: single idx 703 P=3Dbdfd0040 D=3D3ed7e040 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 703 P=3Dbdfd0840 D=3D3ed7e840 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 703 P=3Dbdfd1040 D=3D3ed7f040 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 703 P=3Dbdfd1840 D=3D3ed7f840 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 704 P=3Db67d3040 D=3D46581040 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 704 P=3Dbdfd2040 D=3D3ed80040 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 704 P=3Dbdfd2840 D=3D3ed80840 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 704 P=3Dbdfd3040 D=3D3ed81040 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 704 P=3Dbdfd3840 D=3D3ed81840 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 705 P=3Dbdfd4040 D=3D3ed82040 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 705 P=3Dbdfd4840 D=3D3ed82840 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 705 P=3Dbdfd5040 D=3D3ed83040 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 705 P=3Dbdfd5840 D=3D3ed83840 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 706 P=3Dbdfd6040 D=3D3ed84040 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 706 P=3Dbdfd6840 D=3D3ed84840 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 706 P=3Dbdfd7040 D=3D3ed85040 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 706 P=3Dbdfd7840 D=3D3ed85840 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] ehci_hcd 0000:00:02.1: coherent idx 719 P=3D10115000 D=3D7cd=
9f000 L=3D1000 DMA_BIDIRECTIONAL
[   13.255338] ehci_hcd 0000:00:02.1: coherent idx 719 P=3D10116000 D=3D7cd=
9e000 L=3D1000 DMA_BIDIRECTIONAL
[   13.255338] ehci_hcd 0000:00:02.1: coherent idx 726 P=3D10117000 D=3D7cd=
ad000 L=3D800 DMA_BIDIRECTIONAL
[   13.255338] tg3 0000:02:00.0: coherent idx 731 P=3Dbe008000 D=3D3edb6000=
 L=3D4000 DMA_BIDIRECTIONAL
[   13.255338] tg3 0000:02:00.0: coherent idx 742 P=3Dbe01f000 D=3D3edcd000=
 L=3D800 DMA_BIDIRECTIONAL
[   13.255338] qla2xxx 0000:01:07.0: coherent idx 823 P=3Dbdcc0000 D=3D3ee6=
e000 L=3D20040 DMA_BIDIRECTIONAL
[   13.255338] qla2xxx 0000:01:07.0: coherent idx 853 P=3Dfffc000 D=3D12f6a=
b000 L=3D810 DMA_BIDIRECTIONAL
[   13.255338] qla2xxx 0000:01:07.0: coherent idx 854 P=3Dfffd000 D=3D12f6a=
c000 L=3D1000 DMA_BIDIRECTIONAL
[   13.255338] tg3 0000:02:00.0: single idx 983 P=3Dbe600040 D=3D3e7ae040 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 983 P=3Dbe600840 D=3D3e7ae840 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 983 P=3Dbe601040 D=3D3e7af040 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 983 P=3Dbe601840 D=3D3e7af840 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 984 P=3Dbe602040 D=3D3e7b0040 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 984 P=3Dbe602840 D=3D3e7b0840 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 984 P=3Dbe603040 D=3D3e7b1040 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 984 P=3Dbe603840 D=3D3e7b1840 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 985 P=3Dbe604040 D=3D3e7b2040 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 985 P=3Dbe604840 D=3D3e7b2840 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 985 P=3Dbe605040 D=3D3e7b3040 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 985 P=3Dbe605840 D=3D3e7b3840 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 986 P=3Dbe606040 D=3D3e7b4040 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 986 P=3Dbe606840 D=3D3e7b4840 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 986 P=3Dbe607040 D=3D3e7b5040 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 986 P=3Dbe607840 D=3D3e7b5840 L=
=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: single idx 1007 P=3D1012f040 D=3D12f7de040=
 L=3D640 DMA_FROM_DEVICE
[   13.255338] tg3 0000:02:00.0: coherent idx 1018 P=3Db6646000 D=3D467f400=
0 L=3D50 DMA_BIDIRECTIONAL
[   15.161628] Loading iSCSI transport class v2.0-870.
[   15.174052] iscsi: registered transport (tcp)
iscsistart: transport class version 2.0-870. iscsid version 2.0-872
Could not get list of targets from firmware.
Oct 26 01:2^G^G^G^G^G^G^G^G[   15.258546] Event-channel device installed.
Starting xenstored...Oct 26 01:23:44 tst001 xenstored: Checking store ...
Oct 26 01:23:44 tst001 xenstored: Checking store complete.
[   15.334317] XENBUS: Unable to read cpu state
[   15.340456] XENBUS: Unable to read cpu state
[   15.346475] XENBUS: Unable to read cpu state
[   15.352530] XENBUS: Unable to read cpu state

Setting domain 0 name...
Starting xenconsoled...
Oct 26 01:23:44 tst001 xenconsoled: Failed to open log /var/log/xen/console=
/hypervisor.log: 2 (No such file or directory)
xencommons should be started first.
[0:0:0:0]    disk    ATA      WDC WD800AAJS-18 01.0  /dev/sda=20
[2:0:0:0]    cd/dvd  HL-DT-ST DVD-ROM GDRH20N  0D04  /dev/sr0=20
00:00.0 Memory controller: nVidia Corporation CK804 Memory Controller (rev =
a4)
00:01.0 ISA bridge: nVidia Corporation CK804 ISA Bridge (rev f1)
00:01.1 SMBus: nVidia Corporation CK804 SMBus (rev a2)
00:02.0 USB Controller: nVidia Corporation CK804 USB Controller (rev a2)
00:02.1 USB Controller: nVidia Corporation CK804 USB Controller (rev a4)
00:07.0 IDE interface: nVidia Corporation CK804 Serial ATA Controller (rev =
f3)
00:08.0 IDE interface: nVidia Corporation CK804 Serial ATA Controller (rev =
f3)
00:09.0 PCI bridge: nVidia Corporation CK804 PCI Bridge (rev f2)
00:0b.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev f3)
00:0c.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev f3)
00:0d.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev f3)
00:0e.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev a3)
00:18.0 Host bridge: Advanced Micro Devices [AMD] K10 [Opteron, Athlon64, S=
empron] HyperTransport Configuration
00:18.1 Host bridge: Advanced Micro Devices [AMD] K10 [Opteron, Athlon64, S=
empron] Address Map
00:18.2 Host bridge: Advanced Micro Devices [AMD] K10 [Opteron, Athlon64, S=
empron] DRAM Controller
00:18.3 Host bridge: Advanced Micro Devices [AMD] K10 [Opteron, Athlon64, S=
empron] Miscellaneous Control
00:18.4 Host bridge: Advanced Micro Devices [AMD] K10 [Opteron, Athlon64, S=
empron] Link Control
01:07.0 Fibre Channel: QLogic Corp. SP202-based 2Gb Fibre Channel to PCI-X =
HBA (rev 03)
01:08.0 VGA compatible controller: ATI Technologies Inc ES1000 (rev 02)
02:00.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5722 Gigabit=
 Ethernet PCI Express
05:00.0 Ethernet controller: Intel Corporation 82571EB Gigabit Ethernet Con=
troller (rev 06)
05:00.1 Ethernet controller: Intel Corporation 82571EB Gigabit Ethernet Con=
troller (rev 06)
            CPU0       CPU1       CPU2       CPU3      =20
   1:          2          0          0          0  xen-pirq-ioapic-eden-pir=
q-ioapic-edge  rtc0
   9:          0          0          0          0  xen-pirq-ioapic-level  a=
cpi
  19:         11          0          0          0  xen-pirq-ioapic-level  q=
la2xxx
  20:        105          0          0          0  xen-pirq-ioapic-level  s=
ata_nv
  21:          4          0          0          0  xen-pirq-ioapic-level  s=
ata_nv
  22:          0          0          0          0  xen-pirq-ioapic-level  o=
hci_hcd:usb2
  23:          0          0          0          0  xen-pirq-ioapic-level  e=
hci_hcd:usb1
 272:       4815          0          0          0  xen-percpu-virq      tim=
er0
 273:         19          0          0          0  xen-percpu-ipi       spi=
nlock0
 274:       1625          0          0          0  xen-percpu-ipi       res=
ched0
 275:        225          0          0          0  xen-percpu-ipi       cal=
lfunc0
 276:          0          0          0          0  xen-percpu-virq      deb=
ug0
 277:         97          0          0          0  xen-percpu-ipi       cal=
lfuncsingle0
 278:          0       7500          0          0  xen-percpu-virq      tim=
er1
 279:          0         23          0          0  xen-percpu-ipi       spi=
nlock1
 280:          0       3140          0          0  xen-percpu-ipi       res=
ched1
 281:          0        222          0          0  xen-percpu-ipi       cal=
lfunc1
 282:          0          0          0          0  xen-percpu-virq      deb=
ug1
 283:          0        106          0          0  xen-percpu-ipi       cal=
lfuncsingle1
 284:          0          0       8315          0  xen-percpu-virq      tim=
er2
 285:          0          0         19          0  xen-percpu-ipi       spi=
nlock2
 286:          0          0       1950          0  xen-percpu-ipi       res=
ched2
 287:          0          0        259          0  xen-percpu-ipi       cal=
lfunc2
 288:          0          0          0          0  xen-percpu-virq      deb=
ug2
 289:          0          0        101          0  xen-percpu-ipi       cal=
lfuncsingle2
 290:          0          0          0       6209  xen-percpu-virq      tim=
er3
 291:          0          0          0         18  xen-percpu-ipi       spi=
nlock3
 292:          0          0          0       1783  xen-percpu-ipi       res=
ched3
 293:          0          0          0        248  xen-percpu-ipi       cal=
lfunc3
 294:          0          0          0          0  xen-percpu-virq      deb=
ug3
 295:          0          0          0         88  xen-percpu-ipi       cal=
lfuncsingle3
 296:         63          0          0          0   xen-dyn-event     xenbus
 301:        141          0          0          0  xen-percpu-virq      hvc=
_console
 302:        148          0          0          0  xen-pirq-msi       eth0
 303:         50          0          0          0   xen-dyn-event     evtch=
n:xenstored
 304:          0          0          0          0   xen-dyn-event     evtch=
n:xenstored
 NMI:          0          0          0          0   Non-maskable interrupts
 LOC:          0          0          0          0   Local timer interrupts
 SPU:          0          0          0          0   Spurious interrupts
 PMI:          0          0          0          0   Performance monitoring =
interrupts
 IWI:          0          0          0          0   IRQ work interrupts
 RES:       1625       3140       1950       1783   Rescheduling interrupts
 CAL:        322        328        360        336   Function call interrupts
 TLB:          0          0          0          0   TLB shootdowns
 TRM:          0          0          0          0   Thermal event interrupts
 THR:          0          0          0          0   Threshold APIC interrup=
ts
 MCE:          0          0          0          0   Machine check exceptions
 MCP:          0          0          0          0   Machine check polls
 ERR:          0
 MIS:          0
^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G00000000-0000ffff : reserved
00010000-0009cfff : System RAM
0009d000-0009d7ff : RAM buffer
0009d800-000fffff : reserved
  000a0000-000bffff : PCI Bus 0000:00
  000c0000-000dffff : PCI Bus 0000:00
    000c0000-000c8fff : Video ROM
    000c9000-000cadff : Adapter ROM
  000f0000-000fffff : System ROM
00100000-7ffeffff : System RAM
  01000000-0163e92d : Kernel code
  0163e92e-01ad5cff : Kernel data
  01d42000-01ef9fff : Kernel bss
7fff0000-7fffffff : reserved
80000000-cfeeffff : System RAM
cfef0000-cfef4fff : ACPI Tables
cfef5000-cff7efff : ACPI Non-volatile Storage
cff7f000-cff7ffff : RAM buffer
cff80000-cfffffff : reserved
d0000000-febfffff : PCI Bus 0000:00
  d0000000-d0000fff : 0000:00:02.0
    d0000000-d0000fff : ohci_hcd
  d0001000-d00010ff : 0000:00:02.1
    d0001000-d00010ff : ehci_hcd
  d0002000-d0002fff : 0000:00:07.0
    d0002000-d0002fff : sata_nv
  d0003000-d0003fff : 0000:00:08.0
    d0003000-d0003fff : sata_nv
  d0100000-d01fffff : PCI Bus 0000:01
    d0100000-d010ffff : 0000:01:08.0
    d0110000-d0110fff : 0000:01:07.0
      d0110000-d0110fff : qla2xxx
    d0120000-d013ffff : 0000:01:07.0
    d0140000-d015ffff : 0000:01:08.0
  d0200000-d02fffff : PCI Bus 0000:02
    d0200000-d020ffff : 0000:02:00.0
      d0200000-d020ffff : tg3
  d0300000-d03fffff : PCI Bus 0000:05
    d0300000-d031ffff : 0000:05:00.0
    d0320000-d033ffff : 0000:05:00.0
    d0340000-d035ffff : 0000:05:00.1
    d0360000-d037ffff : 0000:05:00.1
  d0400000-d04fffff : PCI Bus 0000:05
    d0400000-d041ffff : 0000:05:00.0
    d0420000-d043ffff : 0000:05:00.1
  d8000000-dfffffff : PCI Bus 0000:01
    d8000000-dfffffff : 0000:01:08.0
  e0000000-efffffff : reserved
    e0000000-efffffff : pnp 00:02
      e0000000-e04fffff : PCI MMCONFIG 0000 [bus 00-04]
fec00000-fec0ffff : reserved
  fec00000-fec003ff : IOAPIC 0
fed00000-fed00fff : pnp 00:00
  fed00000-fed003ff : HPET 0
fed40000-fed8ffff : PCI Bus 0000:00
fee00000-fee00fff : Local APIC
  fee00000-fee00fff : reserved
fff80000-ffffffff : reserved
100000000-12fffffff : System RAM

   ~~~~~~~~~~~~~~~~~~~~~~~~~~| DirectFB 1.4.9 |~~~~~~~~~~~~~~~~~~~~~~~~~~
        (c) 2001-2010  The world wide DirectFB Op004  Convergence (integrat=
ed media) GmbH
      ----------------------------------------------------------------

^G^G^G^G^G^G^G(*) DirectFB/Core: Single Application Core. (2011-10-27 03:49=
)=20
^G^G^Gsh-4.1# =07=07=07(*) Direct/Memcpy: Using libc memcpy()
=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=
=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=
=07=07=07=07=07(*) Direct/Thread: Started 'VT Switcher' (-1) [CRITICAL OTHE=
R/OTHER 0/0] <8388608>...
(*) Direct/Thread: Started 'VT Flusher' (-1) [DEFAULT OTHER/OTHER 0/0] <838=
8608>...
(*) DirectFB/FBDev: Found 'radeondrmfb' (ID 0) with frame buffer at 0xd8040=
000, 768k (MMIO 0x00000000, 0k)
(*) Direct/Thread: Started 'Keyboard Input' (-1) [INPUT OTHER/OTHER 0/0] <8=
388608>...
(*) DirectFB/Input: Keyboard 0.9 (directfb.org)
(*) Direct/Thread: Started 'PS/2 Input' (-1) [INPUT OTHER/OTHER 0/0] <83886=
08>...
(*) DirectFB/Input: IMPS/2 Mouse 1.0 (direct=07(*) Direct/Thread: Started '=
Linux Input' (-1) [INPUT OTHER/OTHER 0/0] <8388608>...
(*) DirectFB/Input: Power Button (1) 0.1 (dd: Started 'Hotplug with Linux I=
nput' (-1) [INPUT OTHER/OTHER 0/0] <8388608>...
=07=07=07(*) DirectFB/Input: Hot-plug detection enabled with Linux Input Dr=
iver=20
=07=07(*) DirectFB/Genefx: MMX detected and enabled
=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07(*) DirectFB/Graphics: MMX =
Software Rasterizer 0.6 (directfb.org)
(*) DirectFB/Core/WM: Default 0.3 (directfb.org)
(*) FBDev/Mode: Setting 1024x768 LUT8
(*) FBDev/Mode: Switched to 1024x768 (virtual 1024x768) at 8 bit (LUT8), pi=
tch 1024
[   20.642188] switch: no IPv6 routers present
[   21.202103] eth0: no IPv6 routers present
[   25.248086] switch: port 1(eth0) entering forwarding state
[   28.969466] qla2xxx [0000:01:07.0]-8038:4: Cable is unplugged...
[   28.970406] qla2xxx [0000:01:07.0]-803b:4: Firmware ready **** FAILED **=
**.

telnet> Connection closed.
[Connecting to system 1 ]

--C7zPtVaVf+AK4Oqc--
