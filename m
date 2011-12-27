Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753058Ab1L0Tin (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 14:38:43 -0500
Received: from smtpq1.gn.mail.iss.as9143.net ([212.54.34.164]:52750 "EHLO
	smtpq1.gn.mail.iss.as9143.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752578Ab1L0Tij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 14:38:39 -0500
Message-ID: <4EFA1EB8.9090005@gmail.com>
Date: Tue, 27 Dec 2011 20:38:32 +0100
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:9.0) Gecko/20111224 Thunderbird/9.0.1
MIME-Version: 1.0
To: Andre Guedes <andre.guedes@openbossa.org>
CC: "Gustavo F. Padovan" <padovan@profusion.mobi>,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org
Subject: Re: [bluetooth] linux-3.x regression (bisected)
References: <4EF3BACA.1080405@gmail.com> <CACJA=fVezGGcgAtbzG=+ouWq0PiHbgXN1YPwL+VDUphWS7wnrw@mail.gmail.com>
In-Reply-To: <CACJA=fVezGGcgAtbzG=+ouWq0PiHbgXN1YPwL+VDUphWS7wnrw@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------070403030607090803010400"
X-Ziggo-spambar: +
X-Ziggo-spamscore: 1.0
X-Ziggo-spamreport: ALL_TRUSTED=-1,BAYES_00=-1.9,FB_WORD2_END_DOLLAR=1.294,FREEMAIL_EXTRA=2,FREEMAIL_FROM=0.5,HK_MUCHMONEY=0.3,LOTS_OF_MONEY=0.001,PROLO_TRUST_RDNS=-3,RDNS_DYNAMIC=0.982,SPF_NEUTRAL=0.779,TW_BF=0.077,TW_BM=0.077,TW_CF=0.077,TW_GF=0.077,TW_GM=0.077,TW_HM=0.077,TW_II=0.077,TW_KN=0.077,TW_PG=0.077,TW_SN=0.077,TW_UH=0.077,TW_VB=0.077,TW_XF=0.077
X-Ziggo-Spam-Status: No
X-Spam-Flag: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070403030607090803010400
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

On 27-12-11 18:22, Andre Guedes wrote:

> Could you please send us the kernel log messages with Bluetooth debug
> enabled? Here goes the instructions:
>
> 1. Compile kernel with CONFIG_DYNAMIC_DEBUG=y.
> 2. Load Bluetooth module.
> 3. Run the following commands to turn debug on (remember to mount debugfs
> first):
> --
> $ echo "file hci_core.c +pf">  /sys/kernel/debug/dynamic_debug/control
> $ echo "file hci_event.c +pf">  /sys/kernel/debug/dynamic_debug/control
> $ echo "file mgmt.c +pf">  /sys/kernel/debug/dynamic_debug/control
> $ echo "file btusb.c +pf">  /sys/kernel/debug/dynamic_debug/control
> --
> 4. Plug the Bluetooth adapter.

Thanks for the verbosity. Here's a -- full, just in case it's useful -- 
dmesg from vanilla 3.1.6 (i.e., when bluetooth does not work) generated 
per the above. The bluetooth bit is the last part.

Regards,
Rene

--------------070403030607090803010400
Content-Type: text/plain;
 name="bluetooth-3.1.6.dmesg"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="bluetooth-3.1.6.dmesg"

Linux version 3.1.6-e600 (rene@e600) (gcc version 4.6.2 20111125 (prerelease) (GCC) ) #8 SMP PREEMPT Tue Dec 27 20:18:09 CET 2011
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009b800 (usable)
 BIOS-e820: 000000000009b800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000ca000 - 00000000000cc000 (reserved)
 BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003f6f0000 (usable)
 BIOS-e820: 000000003f6f0000 - 000000003f6fb000 (ACPI data)
 BIOS-e820: 000000003f6fb000 - 000000003f700000 (ACPI NVS)
 BIOS-e820: 000000003f700000 - 000000003f780000 (usable)
 BIOS-e820: 000000003f780000 - 0000000040000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fed00400 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fef00000 (reserved)
 BIOS-e820: 00000000ffb80000 - 00000000ffc00000 (reserved)
 BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
Notice: NX (Execute Disable) protection missing in CPU!
DMI present.
DMI: FUJITSU SIEMENS SCENIC E/D1534, BIOS 5.00 R2.16.1534.01               04/01/2005
e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
last_pfn = 0x3f780 max_arch_pfn = 0x100000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-BFFFF uncachable
  C0000-C7FFF write-protect
  C8000-E3FFF uncachable
  E4000-FFFFF write-protect
MTRR variable ranges enabled:
  0 base 000000000 mask FC0000000 write-back
  1 base 03F780000 mask FFFF80000 uncachable
  2 base 03F800000 mask FFF800000 uncachable
  3 disabled
  4 disabled
  5 disabled
  6 disabled
  7 disabled
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
original variable MTRRs
reg 0, base: 0GB, range: 1GB, type WB
reg 1, base: 1039872KB, range: 512KB, type UC
reg 2, base: 1016MB, range: 8MB, type UC
total RAM covered: 1015M
Found optimal setting for mtrr clean up
 gran_size: 64K 	chunk_size: 16M 	num_reg: 3  	lose cover RAM: 0G
New variable MTRRs
reg 0, base: 0GB, range: 1GB, type WB
reg 1, base: 1039872KB, range: 512KB, type UC
reg 2, base: 1016MB, range: 8MB, type UC
initial memory mapped : 0 - 01c00000
Base memory trampoline at [b0097000] 97000 size 16384
init_memory_mapping: 0000000000000000-000000003f780000
 0000000000 - 0000400000 page 4k
 0000400000 - 003f400000 page 2M
 003f400000 - 003f780000 page 4k
kernel direct mapping tables up to 3f780000 @ 1bfb000-1c00000
ACPI: RSDP 000f7260 00014 (v00 PTLTD )
ACPI: RSDT 3f6f7634 00034 (v01 PTLTD    RSDT   00050000  LTP 00000000)
ACPI: FACP 3f6f7668 00074 (v01 FSC    D1534    00050000      000F4240)
ACPI: DSDT 3f6f76dc 03815 (v01 FSC    D1534    00050000 MSFT 02000002)
ACPI: FACS 3f6fbfc0 00040
ACPI: ASF! 3f6faef1 00085 (v16 OEMID  OEMTBL   00050000 PTL  00000001)
ACPI: APIC 3f6faf76 00062 (v01 FSC    ? APIC   00050000  CSF 00000000)
ACPI: BOOT 3f6fafd8 00028 (v01 PTLTD  $SBFTBL$ 00050000  LTP 00000001)
ACPI: Local APIC address 0xfee00000
1015MB LOWMEM available.
  mapped low ram: 0 - 3f780000
  low ram: 0 - 3f780000
Zone PFN ranges:
  DMA      0x00000010 -> 0x00001000
  Normal   0x00001000 -> 0x0003f780
Movable zone start PFN for each node
early_node_map[3] active PFN ranges
    0: 0x00000010 -> 0x0000009b
    0: 0x00000100 -> 0x0003f6f0
    0: 0x0003f700 -> 0x0003f780
On node 0 totalpages: 259835
free_area_init_node: node 0, pgdat b1548980, node_mem_map eef00200
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 3947 pages, LIFO batch:0
  Normal zone: 1999 pages used for memmap
  Normal zone: 253857 pages, LIFO batch:31
Using APIC driver default
ACPI: PM-Timer IO Port: 0xf008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Using ACPI (MADT) for SMP configuration information
SMP: Allowing 2 CPUs, 0 hotplug CPUs
nr_irqs_gsi: 40
PM: Registered nosave memory: 000000000009b000 - 000000000009c000
PM: Registered nosave memory: 000000000009c000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000ca000
PM: Registered nosave memory: 00000000000ca000 - 00000000000cc000
PM: Registered nosave memory: 00000000000cc000 - 00000000000e4000
PM: Registered nosave memory: 00000000000e4000 - 0000000000100000
PM: Registered nosave memory: 000000003f6f0000 - 000000003f6fb000
PM: Registered nosave memory: 000000003f6fb000 - 000000003f700000
Allocating PCI resources starting at 40000000 (gap: 40000000:bec00000)
setup_percpu: NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
PERCPU: Embedded 11 pages/cpu @ee800000 s24064 r0 d20992 u2097152
pcpu-alloc: s24064 r0 d20992 u2097152 alloc=1*4194304
pcpu-alloc: [0] 0 1 
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 257804
Kernel command line: root=/dev/sda7 ro video=1280x1024 BOOT_IMAGE=../vmlinuz 
PID hash table entries: 4096 (order: 2, 16384 bytes)
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Initializing CPU#0
Memory: 1024068k/1039872k available (3684k kernel code, 15272k reserved, 1761k data, 340k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xfff8f000 - 0xfffff000   ( 448 kB)
    vmalloc : 0xeff80000 - 0xfff8d000   ( 256 MB)
    lowmem  : 0xb0000000 - 0xef780000   (1015 MB)
      .init : 0xb1552000 - 0xb15a7000   ( 340 kB)
      .data : 0xb139902a - 0xb1551480   (1761 kB)
      .text : 0xb1000000 - 0xb139902a   (3684 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
SLUB: Genslabs=15, HWalign=128, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
Preemptible hierarchical RCU implementation.
NR_IRQS:320
CPU 0 irqstacks, hard=ee40c000 soft=ee40e000
Console: colour VGA+ 80x25
console [tty0] enabled
Fast TSC calibration using PIT
Detected 2992.512 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequency.. 5985.02 BogoMIPS (lpj=2992512)
pid_max: default: 32768 minimum: 301
Mount-cache hash table entries: 512
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
mce: CPU supports 4 MCE banks
CPU0: Thermal monitoring enabled (TM1)
ACPI: Core revision 20110623
Enabling APIC mode:  Flat.  Using 1 I/O APICs
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Pentium(R) 4 CPU 3.00GHz stepping 09
Performance Events: Netburst events, Netburst P4/Xeon PMU driver.
... version:                0
... bit width:              40
... generic registers:      18
... value mask:             000000ffffffffff
... max period:             0000007fffffffff
... fixed-purpose events:   0
... event mask:             000000000003ffff
CPU 1 irqstacks, hard=ee46c000 soft=ee46e000
Booting Node   0, Processors  #1 Ok.
smpboot cpu 1: start_ip = 97000
Initializing CPU#1
Brought up 2 CPUs
Total of 2 processors activated (11968.76 BogoMIPS).
devtmpfs: initialized
PM: Registering ACPI NVS region at 3f6fb000 (20480 bytes)
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xfd8db, last bus=3
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: Added _OSI(Module Device)
ACPI: Added _OSI(Processor Device)
ACPI: Added _OSI(3.0 _SCP Extensions)
ACPI: Added _OSI(Processor Aggregator Device)
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
pci_root PNP0A03:00: host bridge window [mem 0x000c8000-0x000dffff] (ignored)
pci_root PNP0A03:00: host bridge window [mem 0x40000000-0xfebfffff] (ignored)
pci_root PNP0A03:00: host bridge window [mem 0xfed00400-0xfed1ffff] (ignored)
pci_root PNP0A03:00: host bridge window [mem 0xfed90000-0xfedfffff] (ignored)
pci_root PNP0A03:00: host bridge window [mem 0xfef00000-0xffafffff] (ignored)
pci_root PNP0A03:00: host bridge window [mem 0xffc00000-0xffefffff] (ignored)
pci 0000:00:00.0: [8086:2570] type 0 class 0x000600
pci 0000:00:00.0: Enabling MCH 'Overflow' Device
pci 0000:00:00.0: reg 10: [mem 0xec000000-0xefffffff pref]
pci 0000:00:02.0: [8086:2572] type 0 class 0x000300
pci 0000:00:02.0: reg 10: [mem 0xf0000000-0xf7ffffff pref]
pci 0000:00:02.0: reg 14: [mem 0xe8000000-0xe807ffff]
pci 0000:00:02.0: reg 18: [io  0x1000-0x1007]
pci 0000:00:03.0: [8086:2573] type 1 class 0x000604
pci 0000:00:06.0: [8086:2576] type 0 class 0x000880
pci 0000:00:06.0: reg 10: [mem 0xfecf0000-0xfecf0fff]
pci 0000:00:1d.0: [8086:24d2] type 0 class 0x000c03
pci 0000:00:1d.0: reg 20: [io  0x1400-0x141f]
pci 0000:00:1d.1: [8086:24d4] type 0 class 0x000c03
pci 0000:00:1d.1: reg 20: [io  0x1800-0x181f]
pci 0000:00:1d.2: [8086:24d7] type 0 class 0x000c03
pci 0000:00:1d.2: reg 20: [io  0x1c00-0x1c1f]
pci 0000:00:1d.3: [8086:24de] type 0 class 0x000c03
pci 0000:00:1d.3: reg 20: [io  0x2000-0x201f]
pci 0000:00:1d.7: [8086:24dd] type 0 class 0x000c03
pci 0000:00:1d.7: reg 10: [mem 0xe8080000-0xe80803ff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
pci 0000:00:1e.0: [8086:244e] type 1 class 0x000604
pci 0000:00:1f.0: [8086:24d0] type 0 class 0x000601
pci 0000:00:1f.0: quirk: [io  0xf000-0xf07f] claimed by ICH4 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: [io  0xf180-0xf1bf] claimed by ICH4 GPIO
pci 0000:00:1f.1: [8086:24db] type 0 class 0x000101
pci 0000:00:1f.1: reg 10: [io  0x0000-0x0007]
pci 0000:00:1f.1: reg 14: [io  0x0000-0x0003]
pci 0000:00:1f.1: reg 18: [io  0x0000-0x0007]
pci 0000:00:1f.1: reg 1c: [io  0x0000-0x0003]
pci 0000:00:1f.1: reg 20: [io  0x3000-0x300f]
pci 0000:00:1f.1: reg 24: [mem 0x00000000-0x000003ff]
pci 0000:00:1f.2: [8086:24d1] type 0 class 0x000101
pci 0000:00:1f.2: reg 10: [io  0x3030-0x3037]
pci 0000:00:1f.2: reg 14: [io  0x3024-0x3027]
pci 0000:00:1f.2: reg 18: [io  0x3028-0x302f]
pci 0000:00:1f.2: reg 1c: [io  0x3020-0x3023]
pci 0000:00:1f.2: reg 20: [io  0x3010-0x301f]
pci 0000:00:1f.3: [8086:24d3] type 0 class 0x000c05
pci 0000:00:1f.3: reg 20: [io  0x2400-0x241f]
pci 0000:00:1f.5: [8086:24d5] type 0 class 0x000401
pci 0000:00:1f.5: reg 10: [io  0x2c00-0x2cff]
pci 0000:00:1f.5: reg 14: [io  0x2800-0x283f]
pci 0000:00:1f.5: reg 18: [mem 0xe8080c00-0xe8080dff]
pci 0000:00:1f.5: reg 1c: [mem 0xe8080800-0xe80808ff]
pci 0000:00:1f.5: PME# supported from D0 D3hot D3cold
pci 0000:00:1f.5: PME# disabled
pci 0000:02:01.0: [8086:1019] type 0 class 0x000200
pci 0000:02:01.0: reg 10: [mem 0xe8100000-0xe811ffff]
pci 0000:02:01.0: reg 18: [io  0x4000-0x401f]
pci 0000:02:01.0: PME# supported from D0 D3hot D3cold
pci 0000:02:01.0: PME# disabled
pci 0000:00:03.0: PCI bridge to [bus 02-02]
pci 0000:00:03.0:   bridge window [io  0x4000-0x4fff]
pci 0000:00:03.0:   bridge window [mem 0xe8100000-0xe81fffff]
pci 0000:00:1e.0: PCI bridge to [bus 03-03] (subtractive decode)
pci 0000:00:1e.0:   bridge window [io  0x0000-0xffff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x00000000-0xffffffff] (subtractive decode)
pci_bus 0000:00: on NUMA node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.CSAB._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIH._PRT]
 pci0000:00: Unable to request _OSC control (_OSC support mask: 0x08)
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
Advanced Linux Sound Architecture Driver Version 1.0.24.
PCI: Using ACPI for IRQ routing
PCI: pci_cache_line_size set to 64 bytes
reserve RAM buffer: 000000000009b800 - 000000000009ffff 
reserve RAM buffer: 000000003f6f0000 - 000000003fffffff 
reserve RAM buffer: 000000003f780000 - 000000003fffffff 
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp 00:00: [bus 00-ff]
pnp 00:00: [io  0x0000-0x0cf7 window]
pnp 00:00: [io  0x0d00-0xffff window]
pnp 00:00: [mem 0x000a0000-0x000bffff window]
pnp 00:00: [mem 0x000c8000-0x000dffff window]
pnp 00:00: [mem 0x40000000-0xfebfffff window]
pnp 00:00: [mem 0xfed00400-0xfed1ffff window]
pnp 00:00: [mem 0xfed90000-0xfedfffff window]
pnp 00:00: [mem 0xfef00000-0xffafffff window]
pnp 00:00: [mem 0xffc00000-0xffefffff window]
pnp 00:00: [io  0x0cf8-0x0cff]
pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
pnp 00:01: [io  0x004e-0x004f]
pnp 00:01: [io  0x00e0-0x00eb]
system 00:01: Plug and Play ACPI device, IDs PNP0c01 (active)
pnp 00:02: [mem 0xffb00000-0xffbfffff]
pnp 00:02: Plug and Play ACPI device, IDs INT0800 (active)
pnp 00:03: [io  0x0010-0x001f]
pnp 00:03: [io  0x0022-0x002d]
pnp 00:03: [io  0x0030-0x003f]
pnp 00:03: [io  0x0050-0x0053]
pnp 00:03: [io  0x0062-0x0063]
pnp 00:03: [io  0x0065-0x006f]
pnp 00:03: [io  0x0074-0x007f]
pnp 00:03: [io  0x0090-0x009f]
pnp 00:03: [io  0x00a2-0x00b1]
pnp 00:03: [io  0x00b2-0x00b3]
pnp 00:03: [io  0x00b4-0x00bf]
pnp 00:03: [io  0x00ec-0x00ef]
pnp 00:03: [io  0x0072-0x0073]
pnp 00:03: [io  0x002e-0x002f]
pnp 00:03: [io  0x04d0-0x04d1]
pnp 00:03: [io  0xf000-0xf07f]
pnp 00:03: [io  0xf100-0xf10f]
pnp 00:03: [io  0xf180-0xf1bf]
pnp 00:03: [io  0x0800-0x087f]
pnp 00:03: [io  0xf820-0xf82f]
pnp 00:03: [io  0xfe00]
pnp 00:03: [mem 0xfee00000-0xfeefffff]
pnp 00:03: [mem 0xfec00000-0xfecfffff]
system 00:03: [io  0x04d0-0x04d1] has been reserved
system 00:03: [io  0xf000-0xf07f] has been reserved
system 00:03: [io  0xf100-0xf10f] has been reserved
system 00:03: [io  0xf180-0xf1bf] has been reserved
system 00:03: [io  0x0800-0x087f] has been reserved
system 00:03: [io  0xf820-0xf82f] has been reserved
system 00:03: [io  0xfe00] has been reserved
system 00:03: [mem 0xfee00000-0xfeefffff] has been reserved
system 00:03: [mem 0xfec00000-0xfecfffff] could not be reserved
system 00:03: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:04: [io  0x0000-0x000f]
pnp 00:04: [io  0x0080-0x008f]
pnp 00:04: [io  0x00c0-0x00df]
pnp 00:04: [dma 4]
pnp 00:04: Plug and Play ACPI device, IDs PNP0200 (active)
pnp 00:05: [io  0x0070-0x0071]
pnp 00:05: [irq 8]
pnp 00:05: Plug and Play ACPI device, IDs PNP0b00 (active)
pnp 00:06: [io  0x00f0-0x00fe]
pnp 00:06: [irq 13]
pnp 00:06: Plug and Play ACPI device, IDs PNP0c04 (active)
pnp 00:07: [io  0x0061]
pnp 00:07: Plug and Play ACPI device, IDs PNP0800 (active)
pnp 00:08: [io  0x0060]
pnp 00:08: [io  0x0064]
pnp 00:08: [irq 1]
pnp 00:08: Plug and Play ACPI device, IDs PNP0303 (active)
pnp 00:09: [irq 12]
pnp 00:09: Plug and Play ACPI device, IDs PNP0f13 (active)
pnp 00:0a: [io  0x03f0-0x03f5]
pnp 00:0a: [io  0x03f7]
pnp 00:0a: [dma 2]
pnp 00:0a: [irq 6]
pnp 00:0a: Plug and Play ACPI device, IDs PNP0700 (active)
pnp 00:0b: [io  0x0378-0x037b]
pnp 00:0b: [irq 7]
pnp 00:0b: Plug and Play ACPI device, IDs PNP0400 (active)
pnp 00:0c: [io  0x03f8-0x03ff]
pnp 00:0c: [irq 4]
pnp 00:0c: Plug and Play ACPI device, IDs PNP0501 (active)
pnp 00:0d: [io  0x02f8-0x02ff]
pnp 00:0d: [irq 3]
pnp 00:0d: Plug and Play ACPI device, IDs PNP0501 (active)
pnp: PnP ACPI: found 14 devices
ACPI: ACPI bus type pnp unregistered
Switching to clocksource acpi_pm
PCI: max bus depth: 1 pci_try_num: 2
pci 0000:00:1f.1: BAR 5: assigned [mem 0x40000000-0x400003ff]
pci 0000:00:1f.1: BAR 5: set to [mem 0x40000000-0x400003ff] (PCI address [0x40000000-0x400003ff])
Switched to NOHz mode on CPU #0
Switched to NOHz mode on CPU #1
pci 0000:00:03.0: PCI bridge to [bus 02-02]
pci 0000:00:03.0:   bridge window [io  0x4000-0x4fff]
pci 0000:00:03.0:   bridge window [mem 0xe8100000-0xe81fffff]
pci 0000:00:1e.0: PCI bridge to [bus 03-03]
pci 0000:00:1e.0: setting latency timer to 64
pci_bus 0000:00: resource 0 [io  0x0000-0xffff]
pci_bus 0000:00: resource 1 [mem 0x00000000-0xffffffff]
pci_bus 0000:02: resource 0 [io  0x4000-0x4fff]
pci_bus 0000:02: resource 1 [mem 0xe8100000-0xe81fffff]
pci_bus 0000:03: resource 4 [io  0x0000-0xffff]
pci_bus 0000:03: resource 5 [mem 0x00000000-0xffffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
UDP hash table entries: 512 (order: 2, 16384 bytes)
UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
NET: Registered protocol family 1
pci 0000:00:02.0: Boot video device
PCI: CLS 32 bytes, default 64
Simple Boot Flag at 0x69 set to 0x1
audit: initializing netlink socket (disabled)
type=2000 audit(1325013649.187:1): initialized
fuse init (API version 7.17)
msgmni has been set to 2000
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
io scheduler noop registered
io scheduler cfq registered (default)
input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
ACPI: Power Button [PWRB]
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
ACPI: Power Button [PWRF]
Serial: 8250/16550 driver, 2 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
lp: driver loaded but no devices found
Real Time Clock Driver v1.12b
Non-volatile memory driver v1.3
Linux agpgart interface v0.103
agpgart-intel 0000:00:00.0: Intel 865 Chipset
agpgart-intel 0000:00:00.0: detected gtt size: 131072K total, 131072K mappable
agpgart-intel 0000:00:00.0: detected 8192K stolen memory
agpgart-intel 0000:00:00.0: AGP aperture is 128M @ 0xf0000000
[drm] Initialized drm 1.1.0 20060810
i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
i915 0000:00:02.0: setting latency timer to 64
[drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[drm] Driver supports precise vblank timestamp query.
[drm] initialized overlay support
fbcon: inteldrmfb (fb0) is primary device
Console: switching to colour frame buffer device 160x64
fb0: inteldrmfb frame buffer device
drm: registered panic notifier
[drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
parport_pc 00:0b: reported by Plug and Play ACPI
parport0: PC-style at 0x378, irq 7 [PCSPP,EPP]
lp0: using parport0 (interrupt-driven).
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
loop: module loaded
ata_piix 0000:00:1f.1: version 2.13
ata_piix 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
ata_piix 0000:00:1f.1: setting latency timer to 64
scsi0 : ata_piix
scsi1 : ata_piix
ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x3000 irq 14
ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x3008 irq 15
ata_piix 0000:00:1f.2: PCI INT A -> GSI 18 (level, low) -> IRQ 18
ata1: port disabled--ignoring
ata2: port disabled--ignoring
ata_piix 0000:00:1f.2: MAP [ P0 -- P1 -- ]
ata_piix 0000:00:1f.2: setting latency timer to 64
scsi2 : ata_piix
scsi3 : ata_piix
ata3: SATA max UDMA/133 cmd 0x3030 ctl 0x3024 bmdma 0x3010 irq 18
ata4: SATA max UDMA/133 cmd 0x3028 ctl 0x3020 bmdma 0x3018 irq 18
e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
e1000: Copyright (c) 1999-2006 Intel Corporation.
e1000 0000:02:01.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
e1000 0000:02:01.0: setting latency timer to 64
ata4.00: ATAPI: PLEXTOR DVDR   PX-820SA, 1.01, max UDMA/100
ata3.00: ATA-8: WDC WD5000AADS-00S9B0, 01.00A01, max UDMA/133
ata3.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata3.00: configured for UDMA/133
scsi 2:0:0:0: Direct-Access     ATA      WDC WD5000AADS-0 01.0 PQ: 0 ANSI: 5
sd 2:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB/465 GiB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 2:0:0:0: Attached scsi generic sg0 type 0
ata4.00: configured for UDMA/100
scsi 3:0:0:0: CD-ROM            PLEXTOR  DVDR   PX-820SA  1.01 PQ: 0 ANSI: 5
sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
cdrom: Uniform CD-ROM driver Revision: 3.20
sr 3:0:0:0: Attached scsi CD-ROM sr0
sr 3:0:0:0: Attached scsi generic sg1 type 5
 sda: sda1 < sda5 sda6 sda7 sda8 sda9 sda10 sda11 > sda2
sd 2:0:0:0: [sda] Attached SCSI disk
e1000 0000:02:01.0: eth0: (PCI:33MHz:32-bit) 00:30:05:70:a5:a1
e1000 0000:02:01.0: eth0: Intel(R) PRO/1000 Network Connection
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
ehci_hcd 0000:00:1d.7: irq 23, io mem 0xe8080000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
uhci_hcd: USB Universal Host Controller Interface driver
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.0: irq 16, io base 0x00001400
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.1: irq 19, io base 0x00001800
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001c00
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.3: PCI INT A -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1d.3: setting latency timer to 64
uhci_hcd 0000:00:1d.3: UHCI Host Controller
uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.3: irq 16, io base 0x00002000
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
i8042: PNP: PS/2 Controller [PNP0303:KEYB,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mousedev: PS/2 mouse device common for all mice
input: PC Speaker as /devices/platform/pcspkr/input/input2
i2c /dev entries driver
i801_smbus 0000:00:1f.3: PCI INT B -> GSI 17 (level, low) -> IRQ 17
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
fschmd 14-0073: Registered watchdog chardev major 10, minor: 130
fschmd 14-0073: Detected FSC Hermes chip, revision: 16
cpuidle: using governor ladder
cpuidle: using governor menu
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
ALSA device list:
  No soundcards found.
TCP cubic registered
NET: Registered protocol family 10
IPv6 over IPv4 tunneling driver
NET: Registered protocol family 17
Using IPI No-Shortcut mode
BIOS EDD facility v0.16 2004-Jun-25, 1 devices found
Refined TSC clocksource calibration: 2992.499 MHz.
Switching to clocksource tsc
input: ImPS/2 Generic Wheel Mouse as /devices/platform/i8042/serio1/input/input4
EXT4-fs (sda7): mounted filesystem with ordered data mode. Opts: (null)
VFS: Mounted root (ext4 filesystem) readonly on device 8:7.
Freeing unused kernel memory: 340k freed
udevd[1273]: starting version 175
snd_intel8x0 0000:00:1f.5: PCI INT B -> GSI 17 (level, low) -> IRQ 17
snd_intel8x0 0000:00:1f.5: setting latency timer to 64
intel8x0_measure_ac97_clock: measured 50564 usecs (2437 samples)
intel8x0: clocking to 48000
EXT4-fs (sda7): re-mounted. Opts: (null)
EXT4-fs (sda5): mounted filesystem with ordered data mode. Opts: (null)
EXT4-fs (sda8): mounted filesystem with ordered data mode. Opts: (null)
EXT4-fs (sda9): mounted filesystem with ordered data mode. Opts: (null)
EXT4-fs (sda10): mounted filesystem with ordered data mode. Opts: (null)
EXT4-fs (sda11): mounted filesystem with ordered data mode. Opts: (null)
Adding 2097148k swap on /dev/sda6.  Priority:-1 extents:1 across:2097148k 
ADDRCONF(NETDEV_UP): eth0: link is not ready
e1000: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Control: RX/TX
ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
RPC: Registered named UNIX socket transport module.
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
RPC: Registered tcp NFSv4.1 backchannel transport module.
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
Bluetooth: Core ver 2.16
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
Bluetooth: L2CAP socket layer initialized
Bluetooth: SCO socket layer initialized
Bluetooth: BNEP (Ethernet Emulation) ver 1.3
Bluetooth: BNEP filters: protocol multicast
[drm] capturing error event; look for more information in /debug/dri/0/i915_error_state
render error detected, EIR: 0x00000010
[drm:i915_report_and_clear_eir] *ERROR* EIR stuck: 0x00000010, masking
render error detected, EIR: 0x00000010
eth0: no IPv6 routers present
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM ver 1.11
Bluetooth: Generic Bluetooth USB driver ver 0.6
usbcore: registered new interface driver btusb
usb 2-1: new full speed USB device number 2 using uhci_hcd
btusb_probe:intf e69a1200 id f00ea0a0
hci_register_dev:eb609000 name  bus 1 owner f00ea6a0
hci_power_on:hci0
hci_dev_get:0
hci_dev_open:hci0 eb609000
btusb_open:hci0
btusb_submit_intr_urb:hci0
btusb_submit_bulk_urb:hci0
btusb_submit_bulk_urb:hci0
__hci_request:hci0 start
hci_init_req:hci0 0
hci_send_cmd:hci0 opcode 0xc03 plen 0
hci_send_cmd:skb len 3
hci_send_cmd:hci0 opcode 0x1003 plen 0
hci_send_cmd:skb len 3
hci_send_cmd:hci0 opcode 0x1001 plen 0
hci_send_cmd:skb len 3
hci_send_cmd:hci0 opcode 0x1005 plen 0
hci_send_cmd:skb len 3
hci_send_cmd:hci0 opcode 0x1009 plen 0
hci_send_cmd:skb len 3
hci_send_cmd:hci0 opcode 0xc23 plen 0
hci_send_cmd:skb len 3
hci_send_cmd:
hci_dev_get:0
hci0 opcode 0xc14 plen 0
hci_send_cmd:skb len 3
hci_send_cmd:hci0 opcode 0xc25 plen 0
hci_send_cmd:skb len 3
hci_send_cmd:hci0 opcode 0xc05 plen 1
hci_send_cmd:skb len 4
hci_send_cmd:hci0 opcode 0xc16 plen 2
hci_send_cmd:skb len 5
hci_send_cmd:hci0 opcode 0xc12 plen 7
hci_send_cmd:skb len 10
hci_cmd_task:hci0 cmd 1
hci_send_frame:hci0 type 1 len 3
btusb_send_frame:hci0
btusb_tx_complete:hci0 urb e6900100 status 0 count 3
btusb_probe:intf e69a0400 id f00ea0a0
hci_dev_get:0
hci_dev_get:0
hci_dev_open:hci0 eb609000
btusb_intr_complete:hci0 urb e6900680 status 0 count 6
hci_rx_task:hci0
hci_cc_reset:hci0 status 0x0
hci_req_complete:hci0 command 0x0c03 result 0x00
hci_cmd_task:hci0 cmd 1
hci_send_frame:hci0 type 1 len 3
btusb_send_frame:hci0
hci_dev_get:0
hci_del_off_timer:hci0
btusb_tx_complete:hci0 urb edce8600 status 0 count 3
btusb_intr_complete:hci0 urb e6900680 status 0 count 14
hci_rx_task:hci0
hci_cc_read_local_features:hci0 status 0x0
hci_cc_read_local_features:hci0 features 0xfffeff7e98190080
hci_cmd_task:hci0 cmd 1
hci_send_frame:hci0 type 1 len 3
btusb_send_frame:hci0
hci_dev_get:0
hci_del_off_timer:hci0
btusb_tx_complete:hci0 urb eb4fe480 status 0 count 3
btusb_intr_complete:hci0 urb e6900680 status 0 count 14
hci_rx_task:hci0
hci_cc_read_local_version:hci0 status 0x0
hci_cc_read_local_version:hci0 manufacturer 57 hci ver 3:730
hci_send_cmd:hci0 opcode 0xc01 plen 8
hci_send_cmd:skb len 11
hci_send_cmd:hci0 opcode 0x1002 plen 0
hci_send_cmd:skb len 3
hci_send_cmd:hci0 opcode 0xc45 plen 1
hci_send_cmd:skb len 4
hci_send_cmd:hci0 opcode 0x1004 plen 1
hci_send_cmd:skb len 4
hci_cmd_task:hci0 cmd 1
hci_send_frame:hci0 type 1 len 3
btusb_send_frame:hci0
hci_dev_get:0
hci_del_off_timer:hci0
btusb_tx_complete:hci0 urb e6900600 status 0 count 3
btusb_intr_complete:hci0 urb e6900680 status 0 count 13
hci_rx_task:hci0
hci_cc_read_buffer_size:hci0 status 0x0
hci_cc_read_buffer_size:hci0 acl mtu 1021:4 sco mtu 48:10
hci_cmd_task:hci0 cmd 1
hci_send_frame:hci0 type 1 len 3
btusb_send_frame:hci0
hci_dev_get:0
hci_del_off_timer:hci0
btusb_tx_complete:hci0 urb e6900600 status 0 count 3
btusb_intr_complete:hci0 urb e6900680 status 0 count 12
hci_rx_task:hci0
hci_cc_read_bd_addr:hci0 status 0x0
hci_req_complete:hci0 command 0x1009 result 0x00
hci_cmd_task:hci0 cmd 1
hci_send_frame:hci0 type 1 len 3
btusb_send_frame:hci0
hci_dev_get:0
hci_del_off_timer:hci0
btusb_tx_complete:hci0 urb e6900780 status 0 count 3
btusb_intr_complete:hci0 urb e6900680 status 0 count 9
hci_rx_task:hci0
hci_cc_read_class_of_dev:hci0 status 0x0
hci_cc_read_class_of_dev:hci0 class 0x000000
hci_cmd_task:hci0 cmd 1
hci_send_frame:hci0 type 1 len 3
btusb_send_frame:hci0
hci_dev_get:0
hci_del_off_timer:hci0
btusb_tx_complete:hci0 urb e6935380 status 0 count 3
btusb_intr_complete:hci0 urb e6900680 status 0 count 16
btusb_intr_complete:hci0 urb e6900680 status 0 count 16
btusb_intr_complete:hci0 urb e6900680 status 0 count 16
btusb_intr_complete:hci0 urb e6900680 status 0 count 16
btusb_intr_complete:hci0 urb e6900680 status 0 count 16
btusb_intr_complete:hci0 urb e6900680 status 0 count 16
btusb_intr_complete:hci0 urb e6900680 status 0 count 16
btusb_intr_complete:hci0 urb e6900680 status 0 count 16
btusb_intr_complete:hci0 urb e6900680 status 0 count 16
btusb_intr_complete:hci0 urb e6900680 status 0 count 16
btusb_intr_complete:hci0 urb e6900680 status 0 count 16
btusb_intr_complete:hci0 urb e6900680 status 0 count 16
btusb_intr_complete:hci0 urb e6900680 status 0 count 16
btusb_intr_complete:hci0 urb e6900680 status 0 count 16
btusb_intr_complete:hci0 urb e6900680 status 0 count 16
btusb_intr_complete:hci0 urb e6900680 status 0 count 14
hci_rx_task:hci0
hci_cc_read_local_name:hci0 status 0x0
hci_cmd_task:hci0 cmd 1
hci_send_frame:hci0 type 1 len 3
btusb_send_frame:hci0
hci_dev_get:0
hci_del_off_timer:hci0
btusb_tx_complete:hci0 urb e6a17c00 status 0 count 3
btusb_intr_complete:hci0 urb e6900680 status 0 count 8
hci_rx_task:hci0
hci_cc_read_voice_setting:hci0 status 0x0
hci_cc_read_voice_setting:hci0 voice setting 0x0060
btusb_notify:hci0 evt 3
hci_cmd_task:hci0 cmd 1
hci_send_frame:hci0 type 1 len 4
btusb_send_frame:hci0
hci_dev_get:0
hci_del_off_timer:hci0
btusb_tx_complete:hci0 urb e6a17a80 status 0 count 4
btusb_intr_complete:hci0 urb e6900680 status 0 count 6
hci_rx_task:hci0
hci_cc_set_event_flt:hci0 status 0x0
hci_req_complete:hci0 command 0x0c05 result 0x00
hci_cmd_task:hci0 cmd 1
hci_send_frame:hci0 type 1 len 5
btusb_send_frame:hci0
hci_dev_get:0
hci_del_off_timer:hci0
btusb_tx_complete:hci0 urb e688e200 status 0 count 5
btusb_intr_complete:hci0 urb e6900680 status 0 count 6
hci_rx_task:hci0
hci_cc_write_ca_timeout:hci0 status 0x0
hci_req_complete:hci0 command 0x0c16 result 0x00
hci_cmd_task:hci0 cmd 1
hci_send_frame:hci0 type 1 len 10
btusb_send_frame:hci0
hci_dev_get:0
hci_del_off_timer:hci0
btusb_tx_complete:hci0 urb e688e200 status 0 count 10
btusb_intr_complete:hci0 urb e6900680 status 0 count 8
hci_rx_task:hci0
hci_cc_delete_stored_link_key:hci0 status 0x0
hci_req_complete:hci0 command 0x0c12 result 0x00
hci_cmd_task:hci0 cmd 1
hci_send_frame:hci0 type 1 len 11
btusb_send_frame:hci0
hci_dev_get:0
hci_del_off_timer:hci0
btusb_tx_complete:hci0 urb e688e200 status 0 count 11
btusb_intr_complete:hci0 urb e6900680 status 0 count 6
hci_rx_task:hci0
hci_cc_set_event_mask:hci0 status 0x0
hci_req_complete:hci0 command 0x0c01 result 0x00
hci_cmd_task:hci0 cmd 1
hci_send_frame:hci0 type 1 len 3
btusb_send_frame:hci0
hci_dev_get:0
hci_del_off_timer:hci0
btusb_tx_complete:hci0 urb ec47bf00 status 0 count 3
btusb_intr_complete:hci0 urb e6900680 status 0 count 16
btusb_intr_complete:hci0 urb e6900680 status 0 count 16
btusb_intr_complete:hci0 urb e6900680 status 0 count 16
btusb_intr_complete:hci0 urb e6900680 status 0 count 16
btusb_intr_complete:hci0 urb e6900680 status 0 count 6
hci_rx_task:hci0
hci_cc_read_local_commands:hci0 status 0x0
hci_send_cmd:hci0 opcode 0x80f plen 2
hci_send_cmd:skb len 5
hci_req_complete:hci0 command 0x1002 result 0x00
hci_cmd_task:hci0 cmd 1
hci_send_frame:hci0 type 1 len 4
btusb_send_frame:hci0
hci_dev_get:0
hci_del_off_timer:hci0
btusb_tx_complete:hci0 urb e6890800 status 0 count 4
btusb_intr_complete:hci0 urb e6900680 status 0 count 6
hci_rx_task:hci0
hci_cc_write_inquiry_mode:hci0 status 0x0
hci_req_complete:hci0 command 0x0c45 result 0x00
hci_cmd_task:hci0 cmd 1
hci_send_frame:hci0 type 1 len 4
btusb_send_frame:hci0
hci_dev_get:0
hci_del_off_timer:hci0
btusb_tx_complete:hci0 urb e699a100 status 0 count 4
btusb_intr_complete:hci0 urb e6900680 status 0 count 16
hci_rx_task:hci0
hci_cc_read_local_ext_features:hci0 status 0x0
hci_req_complete:hci0 command 0x1004 result 0x00
hci_cmd_task:hci0 cmd 1
hci_send_frame:hci0 type 1 len 5
btusb_send_frame:hci0
hci_dev_get:0
hci_del_off_timer:hci0
btusb_tx_complete:hci0 urb e6953d00 status 0 count 5
btusb_intr_complete:hci0 urb e6900680 status 0 count 6
hci_rx_task:hci0
hci_cc_write_def_link_policy:hci0 status 0x0
hci_sent_cmd_data:hci0 opcode 0x80f
hci_req_complete:hci0 command 0x080f result 0x00
__hci_request:hci0 end: err 0
__hci_request:hci0 start
hci_le_init_req:hci0
hci_send_cmd:hci0 opcode 0x2002 plen 0
hci_send_cmd:skb len 3
hci_dev_get:
hci_cmd_task:hci0 cmd 1
0
hci_send_frame:
hci0 type 1 len 3
hci_del_off_timer:hci0
btusb_send_frame:hci0
btusb_tx_complete:hci0 urb e6930200 status 0 count 3
Bluetooth: hci0 command tx timeout
hci_cmd_task:hci0 cmd 1
__hci_request:hci0 end: err -110
btusb_flush:hci0
btusb_close:hci0
btusb_intr_complete:hci0 urb e6900680 status -2 count 0
btusb_bulk_complete:hci0 urb e6900800 status -2 count 0
btusb_bulk_complete:hci0 urb e6900500 status -2 count 0
btusb_open:hci0
btusb_submit_intr_urb:hci0
btusb_submit_bulk_urb:hci0
btusb_submit_bulk_urb:hci0
__hci_request:hci0 start
hci_init_req:hci0 0
hci_send_cmd:hci0 opcode 0xc03 plen 0
hci_send_cmd:skb len 3
hci_send_cmd:hci0 opcode 0x1003 plen 0
hci_send_cmd:skb len 3
hci_send_cmd:hci0 opcode 0x1001 plen 0
hci_send_cmd:skb len 3
hci_send_cmd:hci0 opcode 0x1005 plen 0
hci_send_cmd:skb len 3
hci_send_cmd:hci0 opcode 0x1009 plen 0
hci_send_cmd:skb len 3
hci_send_cmd:hci0 opcode 0xc23 plen 0
hci_send_cmd:skb len 3
hci_send_cmd:hci0 opcode 0xc14 plen 0
hci_send_cmd:skb len 3
hci_send_cmd:hci0 opcode 0xc25 plen 0
hci_send_cmd:skb len 3
hci_send_cmd:hci0 opcode 0xc05 plen 1
hci_send_cmd:skb len 4
hci_send_cmd:hci0 opcode 0xc16 plen 2
hci_send_cmd:skb len 5
hci_send_cmd:hci0 opcode 0xc12 plen 7
hci_send_cmd:skb len 10
hci_cmd_task:hci0 cmd 1
hci_send_frame:hci0 type 1 len 3
btusb_send_frame:hci0
btusb_tx_complete:hci0 urb e6931600 status 0 count 3
btusb_intr_complete:hci0 urb e6931f00 status 0 count 6
hci_rx_task:hci0
hci_cc_reset:hci0 status 0x0
hci_req_complete:hci0 command 0x0c03 result 0x00
hci_cmd_task:hci0 cmd 1
hci_send_frame:hci0 type 1 len 3
btusb_send_frame:hci0
hci_dev_get:0
hci_del_off_timer:hci0
btusb_tx_complete:hci0 urb e6a17680 status 0 count 3
btusb_intr_complete:hci0 urb e6931f00 status 0 count 14
hci_rx_task:hci0
hci_cc_read_local_features:hci0 status 0x0
hci_cc_read_local_features:hci0 features 0xfffeff7e98190080
hci_cmd_task:hci0 cmd 1
hci_send_frame:hci0 type 1 len 3
btusb_send_frame:hci0
hci_dev_get:0
hci_del_off_timer:hci0
btusb_tx_complete:hci0 urb e6a10f80 status 0 count 3
btusb_intr_complete:hci0 urb e6931f00 status 0 count 14
hci_rx_task:hci0
hci_cc_read_local_version:hci0 status 0x0
hci_cc_read_local_version:hci0 manufacturer 57 hci ver 3:730
hci_send_cmd:hci0 opcode 0xc01 plen 8
hci_send_cmd:skb len 11
hci_send_cmd:hci0 opcode 0x1002 plen 0
hci_send_cmd:skb len 3
hci_send_cmd:hci0 opcode 0xc45 plen 1
hci_send_cmd:skb len 4
hci_send_cmd:hci0 opcode 0x1004 plen 1
hci_send_cmd:skb len 4
hci_cmd_task:hci0 cmd 1
hci_send_frame:hci0 type 1 len 3
btusb_send_frame:hci0
hci_dev_get:0
hci_del_off_timer:hci0
btusb_tx_complete:hci0 urb e6a10f80 status 0 count 3
btusb_intr_complete:hci0 urb e6931f00 status 0 count 13
hci_rx_task:hci0
hci_cc_read_buffer_size:hci0 status 0x0
hci_cc_read_buffer_size:hci0 acl mtu 1021:4 sco mtu 48:10
hci_cmd_task:hci0 cmd 1
hci_send_frame:hci0 type 1 len 3
btusb_send_frame:hci0
hci_dev_get:0
hci_del_off_timer:hci0
btusb_tx_complete:hci0 urb e6a10600 status 0 count 3
btusb_intr_complete:hci0 urb e6931f00 status 0 count 12
hci_rx_task:hci0
hci_cc_read_bd_addr:hci0 status 0x0
hci_req_complete:hci0 command 0x1009 result 0x00
hci_cmd_task:hci0 cmd 1
hci_send_frame:hci0 type 1 len 3
btusb_send_frame:hci0
hci_dev_get:0
hci_del_off_timer:hci0
btusb_tx_complete:hci0 urb e6a10600 status 0 count 3
btusb_intr_complete:hci0 urb e6931f00 status 0 count 9
hci_rx_task:hci0
hci_cc_read_class_of_dev:hci0 status 0x0
hci_cc_read_class_of_dev:hci0 class 0x000000
hci_cmd_task:hci0 cmd 1
hci_send_frame:hci0 type 1 len 3
btusb_send_frame:hci0
hci_dev_get:0
hci_del_off_timer:hci0
btusb_tx_complete:hci0 urb e6953e80 status 0 count 3
btusb_intr_complete:hci0 urb e6931f00 status 0 count 16
btusb_intr_complete:hci0 urb e6931f00 status 0 count 16
btusb_intr_complete:hci0 urb e6931f00 status 0 count 16
btusb_intr_complete:hci0 urb e6931f00 status 0 count 16
btusb_intr_complete:hci0 urb e6931f00 status 0 count 16
btusb_intr_complete:hci0 urb e6931f00 status 0 count 16
btusb_intr_complete:hci0 urb e6931f00 status 0 count 16
btusb_intr_complete:hci0 urb e6931f00 status 0 count 16
btusb_intr_complete:hci0 urb e6931f00 status 0 count 16
btusb_intr_complete:hci0 urb e6931f00 status 0 count 16
btusb_intr_complete:hci0 urb e6931f00 status 0 count 16
btusb_intr_complete:hci0 urb e6931f00 status 0 count 16
btusb_intr_complete:hci0 urb e6931f00 status 0 count 16
btusb_intr_complete:hci0 urb e6931f00 status 0 count 16
btusb_intr_complete:hci0 urb e6931f00 status 0 count 16
btusb_intr_complete:hci0 urb e6931f00 status 0 count 14
hci_rx_task:hci0
hci_cc_read_local_name:hci0 status 0x0
hci_cmd_task:hci0 cmd 1
hci_send_frame:hci0 type 1 len 3
btusb_send_frame:hci0
hci_dev_get:0
hci_del_off_timer:hci0
btusb_tx_complete:hci0 urb e6953d00 status 0 count 3
btusb_intr_complete:hci0 urb e6931f00 status 0 count 8
hci_rx_task:hci0
hci_cc_read_voice_setting:hci0 status 0x0
hci_cmd_task:hci0 cmd 1
hci_send_frame:hci0 type 1 len 4
btusb_send_frame:hci0
hci_dev_get:0
hci_del_off_timer:hci0
btusb_tx_complete:hci0 urb e6893f80 status 0 count 4
btusb_intr_complete:hci0 urb e6931f00 status 0 count 6
hci_rx_task:hci0
hci_cc_set_event_flt:hci0 status 0x0
hci_req_complete:hci0 command 0x0c05 result 0x00
hci_cmd_task:hci0 cmd 1
hci_send_frame:hci0 type 1 len 5
btusb_send_frame:hci0
hci_dev_get:0
hci_del_off_timer:hci0
btusb_tx_complete:hci0 urb edce6b80 status 0 count 5
btusb_intr_complete:hci0 urb e6931f00 status 0 count 6
hci_rx_task:hci0
hci_cc_write_ca_timeout:hci0 status 0x0
hci_req_complete:hci0 command 0x0c16 result 0x00
hci_cmd_task:hci0 cmd 1
hci_send_frame:hci0 type 1 len 10
btusb_send_frame:hci0
hci_dev_get:0
hci_del_off_timer:hci0
btusb_tx_complete:hci0 urb e6935380 status 0 count 10
btusb_intr_complete:hci0 urb e6931f00 status 0 count 8
hci_rx_task:hci0
hci_cc_delete_stored_link_key:hci0 status 0x0
hci_req_complete:hci0 command 0x0c12 result 0x00
hci_cmd_task:hci0 cmd 1
hci_send_frame:hci0 type 1 len 11
btusb_send_frame:hci0
hci_dev_get:0
hci_del_off_timer:hci0
btusb_tx_complete:hci0 urb e685c500 status 0 count 11
btusb_intr_complete:hci0 urb e6931f00 status 0 count 6
hci_rx_task:hci0
hci_cc_set_event_mask:hci0 status 0x0
hci_req_complete:hci0 command 0x0c01 result 0x00
hci_cmd_task:hci0 cmd 1
hci_send_frame:hci0 type 1 len 3
btusb_send_frame:hci0
hci_dev_get:0
hci_del_off_timer:hci0
btusb_tx_complete:hci0 urb e6900700 status 0 count 3
btusb_intr_complete:hci0 urb e6931f00 status 0 count 16
btusb_intr_complete:hci0 urb e6931f00 status 0 count 16
btusb_intr_complete:hci0 urb e6931f00 status 0 count 16
btusb_intr_complete:hci0 urb e6931f00 status 0 count 16
btusb_intr_complete:hci0 urb e6931f00 status 0 count 6
hci_rx_task:hci0
hci_cc_read_local_commands:hci0 status 0x0
hci_send_cmd:hci0 opcode 0x80f plen 2
hci_send_cmd:skb len 5
hci_req_complete:hci0 command 0x1002 result 0x00
hci_cmd_task:hci0 cmd 1
hci_send_frame:hci0 type 1 len 4
btusb_send_frame:hci0
hci_dev_get:0
hci_del_off_timer:hci0
btusb_tx_complete:hci0 urb e6900600 status 0 count 4
btusb_intr_complete:hci0 urb e6931f00 status 0 count 6
hci_rx_task:hci0
hci_cc_write_inquiry_mode:hci0 status 0x0
hci_req_complete:hci0 command 0x0c45 result 0x00
hci_cmd_task:hci0 cmd 1
hci_send_frame:hci0 type 1 len 4
btusb_send_frame:hci0
hci_dev_get:0
hci_del_off_timer:hci0
btusb_tx_complete:hci0 urb e6900500 status 0 count 4
btusb_intr_complete:hci0 urb e6931f00 status 0 count 16
hci_rx_task:hci0
hci_cc_read_local_ext_features:hci0 status 0x0
hci_req_complete:hci0 command 0x1004 result 0x00
hci_cmd_task:hci0 cmd 1
hci_send_frame:hci0 type 1 len 5
btusb_send_frame:hci0
hci_dev_get:0
hci_del_off_timer:hci0
btusb_tx_complete:hci0 urb e6900800 status 0 count 5
btusb_intr_complete:hci0 urb e6931f00 status 0 count 6
hci_rx_task:hci0
hci_cc_write_def_link_policy:hci0 status 0x0
hci_sent_cmd_data:hci0 opcode 0x80f
hci_req_complete:hci0 command 0x080f result 0x00
__hci_request:hci0 end: err 0
hci_dev_get:0
__hci_request:hci_del_off_timer:hci0 start
hci0
hci_le_init_req:hci0
hci_send_cmd:hci0 opcode 0x2002 plen 0
hci_send_cmd:skb len 3
hci_cmd_task:hci0 cmd 1
hci_send_frame:hci0 type 1 len 3
btusb_send_frame:hci0
btusb_tx_complete:hci0 urb e6900700 status 0 count 3
Bluetooth: hci0 command tx timeout
hci_cmd_task:hci0 cmd 1
__hci_request:hci0 end: err -110
btusb_flush:hci0
btusb_close:hci0
btusb_intr_complete:hci0 urb e6931f00 status -2 count 0
btusb_bulk_complete:hci0 urb e6931200 status -2 count 0
btusb_bulk_complete:hci0 urb e6931380 status -2 count 0

--------------070403030607090803010400--
