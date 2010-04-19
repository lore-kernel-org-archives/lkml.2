Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993Ab0DSMDQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 08:03:16 -0400
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:3513 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753866Ab0DSMDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 08:03:14 -0400
From: Frans Pop <elendil@planet.nl>
To: Dave Airlie <airlied@redhat.com>
Subject: Re: [regression,bisected] Missing boot messages with VESAFB after VT initialization
Date: Mon, 19 Apr 2010 14:03:08 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       x86@kernel.org
References: <201004171718.55867.elendil@planet.nl> <1271625028.19111.0.camel@t60prh>
In-Reply-To: <1271625028.19111.0.camel@t60prh>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_9ZEzLEmRLWYbOlg"
Message-Id: <201004191403.09593.elendil@planet.nl>
X-OriginalArrivalTime: 19 Apr 2010 12:03:09.0763 (UTC) FILETIME=[475B6930:01CADFB8]
X-RecipientDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_9ZEzLEmRLWYbOlg
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Sunday 18 April 2010, you wrote:
> On Sat, 2010-04-17 at 17:18 +0200, Frans Pop wrote:
> > Initially all messages from init scripts are displayed correctly, but
> > after the init script to set up the VT1-VT6 is run, messages from init
> > scripts are no longer displayed. Instead the display is blank with
> > only a cursor.
> >
> > However, if I switch back to VT1 from X.Org after the boot has
> > completed, the missing messages are visible.
> >
> > System is x86_64 running Debian stable ("Lenny"). I'm using VESAFB
> > (vga=791) and no KMS.
> >
> > I've bisected this to the following commit:
> >    commit 477346ff74f4c2aed50e8a0db96a61069f3e5b80
> >    Author: Dave Airlie <airlied@redhat.com>
> >    Date:   Thu Jan 7 17:04:54 2010 +1000
> >        x86-64: Allow fbdev primary video code
>
> Can you diff dmesg with/without this?

There is no relevant difference between the dmesg for 477346ff ("bisect-5": 
bad) and its predecessor b0483e78 ("bisect-6": good). See attachment.

> It shouldn't do anything unless you have multiple framebuffer drivers.

Unfortunately "shouldn't" isn't always the same as "doesn't" :-)

$ cat /proc/fb
0 VESA VGA

00:02.0 VGA compatible controller [0300]: Intel Corporation Mobile
    GM965/GL960 Integrated Graphics Controller [8086:2a02] (rev 0c)
00:02.1 Display controller [0380]: Intel Corporation Mobile
    GM965/GL960 Integrated Graphics Controller [8086:2a03] (rev 0c)

Cheers,
FJP


--Boundary-00=_9ZEzLEmRLWYbOlg
Content-Type: text/x-diff;
  charset="utf-8";
  name="dmesg_2.6.34-bisect.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="dmesg_2.6.34-bisect.diff"

--- ../aragorn/2.6.34-bisect-5	2010-04-19 13:53:01.000000000 +0200
+++ ../aragorn/2.6.34-bisect-6	2010-04-19 13:45:17.000000000 +0200
@@ -1,674 +1,674 @@
-Linux version 2.6.34-bisect (fjp@aragorn) (gcc version 4.3.2 (Debian 4.3.2-1.1) ) #10 SMP Sat Apr 17 16:35:15 CEST 2010
+Linux version 2.6.34-bisect (fjp@aragorn) (gcc version 4.3.2 (Debian 4.3.2-1.1) ) #11 SMP Sat Apr 17 16:46:53 CEST 2010
 Command line: root=/dev/mapper/main-root ro vga=791 quiet
 BIOS-provided physical RAM map:
  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
  BIOS-e820: 0000000000100000 - 000000007e7b0000 (usable)
  BIOS-e820: 000000007e7b0000 - 000000007e7c5400 (reserved)
  BIOS-e820: 000000007e7c5400 - 000000007e7e7fb8 (ACPI NVS)
  BIOS-e820: 000000007e7e7fb8 - 000000007f000000 (reserved)
  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
  BIOS-e820: 00000000fed20000 - 00000000fed9a000 (reserved)
  BIOS-e820: 00000000feda0000 - 00000000fedc0000 (reserved)
  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
  BIOS-e820: 00000000ffb00000 - 00000000ffc00000 (reserved)
  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
 NX (Execute Disable) protection: active
 DMI 2.4 present.
 No AGP bridge found
 last_pfn = 0x7e7b0 max_arch_pfn = 0x400000000
 MTRR default type: uncachable
 MTRR fixed ranges enabled:
   00000-9FFFF write-back
   A0000-BFFFF uncachable
   C0000-D3FFF write-protect
   D4000-EFFFF uncachable
   F0000-FFFFF write-protect
 MTRR variable ranges enabled:
   0 base 000000000 mask F80000000 write-back
   1 base 07F000000 mask FFF000000 uncachable
   2 base 07E800000 mask FFF800000 uncachable
   3 base 0FEDA0000 mask FFFFE0000 uncachable
   4 disabled
   5 disabled
   6 disabled
   7 disabled
 x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
 initial memory mapped : 0 - 20000000
 init_memory_mapping: 0000000000000000-000000007e7b0000
  0000000000 - 007e600000 page 2M
  007e600000 - 007e7b0000 page 4k
 kernel direct mapping tables up to 7e7b0000 @ 8000-c000
-RAMDISK: 37a74000 - 37feffa4
+RAMDISK: 37a74000 - 37fefdac
 ACPI: RSDP 00000000000f7980 00024 (v02 HP    )
 ACPI: XSDT 000000007e7c81c8 0007C (v01 HPQOEM SLIC-MPC 00000001 HP   00000001)
 ACPI: FACP 000000007e7c8084 000F4 (v04 HP     30C9     00000003 HP   00000001)
 ACPI: DSDT 000000007e7c8538 13484 (v01 HP       nc2500 00010000 MSFT 03000001)
 ACPI: FACS 000000007e7e7d80 00040
 ACPI: SLIC 000000007e7c8244 00176 (v01 HPQOEM SLIC-MPC 00000001 HP   00000001)
 ACPI: HPET 000000007e7c83bc 00038 (v01 HP     30C9     00000001 HP   00000001)
 ACPI: APIC 000000007e7c83f4 00068 (v01 HP     30C9     00000001 HP   00000001)
 ACPI: MCFG 000000007e7c845c 0003C (v01 HP     30C9     00000001 HP   00000001)
 ACPI: TCPA 000000007e7c8498 00032 (v02 HP     30C9     00000001 HP   00000001)
 ACPI: ASF! 000000007e7c84cc 00069 (v16 HP     CHIMAYU  00000001 HP   00000000)
 ACPI: SSDT 000000007e7db9bc 002BE (v01 HP       HPQPAT 00000001 MSFT 03000001)
 ACPI: SSDT 000000007e7dc640 0025F (v01 HP      Cpu0Tst 00003000 INTL 20060317)
 ACPI: SSDT 000000007e7dc89f 000A6 (v01 HP      Cpu1Tst 00003000 INTL 20060317)
 ACPI: SSDT 000000007e7dc945 004D7 (v01 HP        CpuPm 00003000 INTL 20060317)
 ACPI: Local APIC address 0xfee00000
 (8 early reservations) ==> bootmem [0000000000 - 007e7b0000]
   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
   #1 [0001000000 - 00015bee70]    TEXT DATA BSS ==> [0001000000 - 00015bee70]
-  #2 [0037a74000 - 0037feffa4]          RAMDISK ==> [0037a74000 - 0037feffa4]
+  #2 [0037a74000 - 0037fefdac]          RAMDISK ==> [0037a74000 - 0037fefdac]
   #3 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
   #4 [00015bf000 - 00015bf18c]              BRK ==> [00015bf000 - 00015bf18c]
   #5 [0000001000 - 0000003000]       TRAMPOLINE ==> [0000001000 - 0000003000]
   #6 [0000003000 - 0000007000]      ACPI WAKEUP ==> [0000003000 - 0000007000]
   #7 [0000008000 - 000000a000]          PGTABLE ==> [0000008000 - 000000a000]
  [ffffea0000000000-ffffea0001bfffff] PMD -> [ffff880001a00000-ffff8800035fffff] on node 0
 Zone PFN ranges:
   DMA      0x00000000 -> 0x00001000
   DMA32    0x00001000 -> 0x00100000
   Normal   0x00100000 -> 0x00100000
 Movable zone start PFN for each node
 early_node_map[2] active PFN ranges
     0: 0x00000000 -> 0x0000009f
     0: 0x00000100 -> 0x0007e7b0
 On node 0 totalpages: 517967
   DMA zone: 56 pages used for memmap
   DMA zone: 105 pages reserved
   DMA zone: 3838 pages, LIFO batch:0
   DMA32 zone: 7027 pages used for memmap
   DMA32 zone: 506941 pages, LIFO batch:31
 ACPI: PM-Timer IO Port: 0x1008
 ACPI: Local APIC address 0xfee00000
 ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
 ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
 ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
 ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
 ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
 IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
 ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
 ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
 ACPI: IRQ0 used by override.
 ACPI: IRQ2 used by override.
 ACPI: IRQ9 used by override.
 Using ACPI (MADT) for SMP configuration information
 ACPI: HPET id: 0x8086a201 base: 0xfed00000
 SMP: Allowing 2 CPUs, 0 hotplug CPUs
 nr_irqs_gsi: 24
 PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
 PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
 PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
 Allocating PCI resources starting at 7f000000 (gap: 7f000000:7fc00000)
 setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_node_ids:1
 PERCPU: Embedded 28 pages/cpu @ffff880001600000 s82008 r8192 d24488 u1048576
 pcpu-alloc: s82008 r8192 d24488 u1048576 alloc=1*2097152
 pcpu-alloc: [0] 0 1 
 Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 510779
 Kernel command line: root=/dev/mapper/main-root ro vga=791 quiet
 PID hash table entries: 4096 (order: 3, 32768 bytes)
 Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
 Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
 Checking aperture...
 No AGP bridge found
-Memory: 2027468k/2072256k available (2732k kernel code, 388k absent, 43660k reserved, 1952k data, 524k init)
+Memory: 2027468k/2072256k available (2732k kernel code, 388k absent, 43660k reserved, 1953k data, 524k init)
 SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
 Hierarchical RCU implementation.
 NR_IRQS:512
 Extended CMOS year: 2000
 Console: colour dummy device 80x25
 console [tty0] enabled
 hpet clockevent registered
 Fast TSC calibration using PIT
-Detected 1330.008 MHz processor.
-Calibrating delay loop (skipped), value calculated using timer frequency.. 2660.01 BogoMIPS (lpj=5320032)
+Detected 1329.929 MHz processor.
+Calibrating delay loop (skipped), value calculated using timer frequency.. 2659.85 BogoMIPS (lpj=5319716)
 Security Framework initialized
 SELinux:  Disabled at boot.
 Mount-cache hash table entries: 256
 CPU: Physical Processor ID: 0
 CPU: Processor Core ID: 0
 mce: CPU supports 6 MCE banks
 CPU0: Thermal monitoring handled by SMI
 using mwait in idle threads.
 Performance Events: Core2 events, Intel PMU driver.
 ... version:                2
 ... bit width:              40
 ... generic registers:      2
 ... value mask:             000000ffffffffff
 ... max period:             000000007fffffff
 ... fixed-purpose events:   3
 ... event mask:             0000000700000003
 ACPI: Core revision 20091214
 ftrace: converting mcount calls to 0f 1f 44 00 00
-ftrace: allocating 13895 entries in 55 pages
+ftrace: allocating 13894 entries in 55 pages
 Setting APIC routing to flat
 ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
 CPU0: Intel(R) Core(TM)2 Duo CPU     U7700  @ 1.33GHz stepping 0d
 Booting Node   0, Processors  #1 Ok.
 CPU1: Thermal monitoring handled by SMI
 Brought up 2 CPUs
-Total of 2 processors activated (5319.99 BogoMIPS).
+Total of 2 processors activated (5319.82 BogoMIPS).
 NET: Registered protocol family 16
 ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
 ACPI: bus type pci registered
 PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
 PCI: not using MMCONFIG
 PCI: Using configuration type 1 for base access
 bio: create slab <bio-0> at 0
 ACPI: EC: Look up EC in DSDT
 ACPI: Interpreter enabled
 ACPI: (supports S0 S3 S4 S5)
 ACPI: Using IOAPIC for interrupt routing
 PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
 PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in ACPI motherboard resources
 ACPI: EC: GPE = 0x16, I/O: command/status = 0x66, data = 0x62
 ACPI: Power Resource [C29F] (on)
 ACPI: Power Resource [C1C7] (off)
 ACPI: Power Resource [C3AD] (off)
 ACPI: Power Resource [C3B0] (off)
 ACPI: Power Resource [C3C3] (off)
 ACPI: Power Resource [C3C4] (off)
 ACPI: Power Resource [C3C5] (off)
 ACPI: Power Resource [C3C6] (off)
 ACPI: Power Resource [C3C7] (off)
 ACPI: No dock devices found.
 ACPI: PCI Root Bridge [C003] (0000:00)
 pci_root PNP0A08:00: ignoring host bridge windows from ACPI; boot with "pci=use_crs" to use them
 pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7] (ignored)
 pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff] (ignored)
 pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
 pci_root PNP0A08:00: host bridge window [mem 0x7e800000-0xfedfffff] (ignored)
 pci_root PNP0A08:00: host bridge window [mem 0xfee01000-0xfffffffe] invalid; aligning end to 16-byte boundary
 pci_root PNP0A08:00: host bridge window [mem 0xfee01000-0xffffffff] (ignored)
 pci_root PNP0A08:00: host bridge window [mem 0x000d4000-0x000dffff] (ignored)
 pci 0000:00:02.0: reg 10: [mem 0xe0400000-0xe04fffff 64bit]
 pci 0000:00:02.0: reg 18: [mem 0xd0000000-0xdfffffff 64bit pref]
 pci 0000:00:02.0: reg 20: [io  0x2000-0x2007]
 pci 0000:00:02.1: reg 10: [mem 0xe0500000-0xe05fffff 64bit]
 pci 0000:00:03.0: reg 10: [mem 0xe0600000-0xe060000f 64bit]
 pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
 pci 0000:00:03.0: PME# disabled
 pci 0000:00:03.2: reg 10: [io  0x2008-0x200f]
 pci 0000:00:03.2: reg 14: [io  0x2010-0x2013]
 pci 0000:00:03.2: reg 18: [io  0x2018-0x201f]
 pci 0000:00:03.2: reg 1c: [io  0x2020-0x2023]
 pci 0000:00:03.2: reg 20: [io  0x2030-0x203f]
 pci 0000:00:03.3: reg 10: [io  0x2040-0x2047]
 pci 0000:00:03.3: reg 14: [mem 0xe0601000-0xe0601fff]
 pci 0000:00:19.0: reg 10: [mem 0xe0620000-0xe063ffff]
 pci 0000:00:19.0: reg 14: [mem 0xe0640000-0xe0640fff]
 pci 0000:00:19.0: reg 18: [io  0x2060-0x207f]
 pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
 pci 0000:00:19.0: PME# disabled
 pci 0000:00:1a.0: reg 20: [io  0x2080-0x209f]
 pci 0000:00:1a.1: reg 20: [io  0x20a0-0x20bf]
 pci 0000:00:1a.7: reg 10: [mem 0xe0641000-0xe06413ff]
 pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
 pci 0000:00:1a.7: PME# disabled
 pci 0000:00:1b.0: reg 10: [mem 0xe0644000-0xe0647fff 64bit]
 pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
 pci 0000:00:1b.0: PME# disabled
 pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
 pci 0000:00:1c.0: PME# disabled
 pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
 pci 0000:00:1c.1: PME# disabled
 pci 0000:00:1d.0: reg 20: [io  0x20c0-0x20df]
 pci 0000:00:1d.1: reg 20: [io  0x20e0-0x20ff]
 pci 0000:00:1d.2: reg 20: [io  0x2100-0x211f]
 pci 0000:00:1d.7: reg 10: [mem 0xe0648000-0xe06483ff]
 pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
 pci 0000:00:1d.7: PME# disabled
 pci 0000:00:1f.0: quirk: [io  0x1000-0x107f] claimed by ICH6 ACPI/GPIO/TCO
 pci 0000:00:1f.0: quirk: [io  0x1100-0x113f] claimed by ICH6 GPIO
 pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0500 (mask 007f)
 pci 0000:00:1f.0: ICH7 LPC Generic IO decode 4 PIO at 02e8 (mask 0007)
 pci 0000:00:1f.1: reg 10: [io  0x0000-0x0007]
 pci 0000:00:1f.1: reg 14: [io  0x0000-0x0003]
 pci 0000:00:1f.1: reg 18: [io  0x0000-0x0007]
 pci 0000:00:1f.1: reg 1c: [io  0x0000-0x0003]
 pci 0000:00:1f.1: reg 20: [io  0x2120-0x212f]
 pci 0000:00:1c.0: PCI bridge to [bus 08-08]
 pci 0000:10:00.0: reg 10: [mem 0xe0000000-0xe0001fff 64bit]
 pci 0000:10:00.0: PME# supported from D0 D3hot D3cold
 pci 0000:10:00.0: PME# disabled
 pci 0000:00:1c.1: PCI bridge to [bus 10-10]
 pci 0000:00:1c.1:   bridge window [mem 0xe0000000-0xe00fffff]
 pci 0000:02:06.0: reg 10: [mem 0xe0100000-0xe0100fff]
 pci 0000:02:06.0: supports D1 D2
 pci 0000:02:06.0: PME# supported from D0 D1 D2 D3hot D3cold
 pci 0000:02:06.0: PME# disabled
 pci 0000:02:06.1: reg 10: [mem 0xe0101000-0xe01017ff]
 pci 0000:02:06.1: supports D1 D2
 pci 0000:02:06.1: PME# supported from D0 D1 D2 D3hot D3cold
 pci 0000:02:06.1: PME# disabled
 pci 0000:02:06.2: reg 10: [mem 0xe0102000-0xe01020ff]
 pci 0000:02:06.2: supports D1 D2
 pci 0000:02:06.2: PME# supported from D0 D1 D2 D3hot D3cold
 pci 0000:02:06.2: PME# disabled
 pci 0000:02:06.3: reg 10: [mem 0xe0103000-0xe01030ff]
 pci 0000:02:06.3: supports D1 D2
 pci 0000:02:06.3: PME# supported from D0 D1 D2 D3hot D3cold
 pci 0000:02:06.3: PME# disabled
 pci 0000:00:1e.0: PCI bridge to [bus 02-03] (subtractive decode)
 pci 0000:00:1e.0:   bridge window [mem 0xe0100000-0xe03fffff]
 pci_bus 0000:03: [bus 03-06] partially hidden behind transparent bridge 0000:02 [bus 02-03]
 pci_bus 0000:00: on NUMA node 0
 ACPI: PCI Interrupt Routing Table [\_SB_.C003._PRT]
 ACPI: PCI Interrupt Routing Table [\_SB_.C003.C0B2._PRT]
 ACPI: PCI Interrupt Routing Table [\_SB_.C003.C11F._PRT]
 ACPI: PCI Interrupt Routing Table [\_SB_.C003.C133._PRT]
 ACPI: PCI Interrupt Link [C12F] (IRQs *10 11)
 ACPI: PCI Interrupt Link [C130] (IRQs *10 11)
 ACPI: PCI Interrupt Link [C131] (IRQs 10 *11)
 ACPI: PCI Interrupt Link [C132] (IRQs 10 11) *5
 ACPI: PCI Interrupt Link [C142] (IRQs *10 11)
 ACPI: PCI Interrupt Link [C143] (IRQs 10 11) *0, disabled.
 ACPI: PCI Interrupt Link [C144] (IRQs 10 *11)
 ACPI Exception: AE_NOT_FOUND, Evaluating _PRS (20091214/pci_link-184)
 vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
 vgaarb: loaded
 usbcore: registered new interface driver usbfs
 usbcore: registered new interface driver hub
 usbcore: registered new device driver usb
 PCI: Using ACPI for IRQ routing
 PCI: pci_cache_line_size set to 64 bytes
 HPET: 3 timers in total, 0 timers will be used for per-cpu timer
 hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
 hpet0: 3 comparators, 64-bit 14.318180 MHz counter
 Switching to clocksource tsc
 pnp: PnP ACPI init
 ACPI: bus type pnp registered
 pnp: PnP ACPI: found 14 devices
 ACPI: ACPI bus type pnp unregistered
 system 00:00: [mem 0x00000000-0x0009ffff] could not be reserved
 system 00:00: [mem 0x000e0000-0x000fffff] could not be reserved
 system 00:00: [mem 0x00100000-0x7e7fffff] could not be reserved
 system 00:0a: [io  0x0500-0x055f] has been reserved
 system 00:0a: [io  0x0800-0x080f] has been reserved
 system 00:0a: [mem 0xffb00000-0xffbfffff] has been reserved
 system 00:0a: [mem 0xfff00000-0xffffffff] has been reserved
 system 00:0c: [io  0x04d0-0x04d1] has been reserved
 system 00:0c: [io  0x02f8-0x02ff] has been reserved
 system 00:0c: [io  0x03f8-0x03ff] has been reserved
 system 00:0c: [io  0x1000-0x107f] has been reserved
 system 00:0c: [io  0x1100-0x113f] has been reserved
 system 00:0c: [io  0x1200-0x121f] has been reserved
 system 00:0c: [mem 0xf8000000-0xfbffffff] has been reserved
 system 00:0c: [mem 0xfec00000-0xfec000ff] could not be reserved
 system 00:0c: [mem 0xfed20000-0xfed3ffff] has been reserved
 system 00:0c: [mem 0xfed45000-0xfed8ffff] has been reserved
 system 00:0c: [mem 0xfed90000-0xfed99fff] has been reserved
 system 00:0d: [mem 0x000cee00-0x000cffff] has been reserved
 system 00:0d: [mem 0x000d2000-0x000d3fff] has been reserved
 system 00:0d: [mem 0xfeda0000-0xfedbffff] has been reserved
 system 00:0d: [mem 0xfee00000-0xfee00fff] has been reserved
 pci 0000:00:1e.0: BAR 9: assigned [mem 0x80000000-0x83ffffff pref]
 pci 0000:00:1e.0: BAR 7: assigned [io  0x3000-0x3fff]
 pci 0000:00:1c.0: PCI bridge to [bus 08-08]
 pci 0000:00:1c.0:   bridge window [io  disabled]
 pci 0000:00:1c.0:   bridge window [mem disabled]
 pci 0000:00:1c.0:   bridge window [mem pref disabled]
 pci 0000:00:1c.1: PCI bridge to [bus 10-10]
 pci 0000:00:1c.1:   bridge window [io  disabled]
 pci 0000:00:1c.1:   bridge window [mem 0xe0000000-0xe00fffff]
 pci 0000:00:1c.1:   bridge window [mem pref disabled]
 pci 0000:02:06.0: BAR 9: assigned [mem 0x80000000-0x83ffffff pref]
 pci 0000:02:06.0: BAR 10: assigned [mem 0x84000000-0x87ffffff]
 pci 0000:02:06.0: BAR 7: assigned [io  0x3000-0x30ff]
 pci 0000:02:06.0: BAR 8: assigned [io  0x3400-0x34ff]
 pci 0000:02:06.0: CardBus bridge to [bus 03-06]
 pci 0000:02:06.0:   bridge window [io  0x3000-0x30ff]
 pci 0000:02:06.0:   bridge window [io  0x3400-0x34ff]
 pci 0000:02:06.0:   bridge window [mem 0x80000000-0x83ffffff pref]
 pci 0000:02:06.0:   bridge window [mem 0x84000000-0x87ffffff]
 pci 0000:00:1e.0: PCI bridge to [bus 02-03]
 pci 0000:00:1e.0:   bridge window [io  0x3000-0x3fff]
 pci 0000:00:1e.0:   bridge window [mem 0xe0100000-0xe03fffff]
 pci 0000:00:1e.0:   bridge window [mem 0x80000000-0x83ffffff pref]
 pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
 pci 0000:00:1c.0: setting latency timer to 64
 pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
 pci 0000:00:1c.1: setting latency timer to 64
 pci 0000:00:1e.0: setting latency timer to 64
 pci 0000:02:06.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
 pci_bus 0000:00: resource 0 [io  0x0000-0xffff]
 pci_bus 0000:00: resource 1 [mem 0x00000000-0xffffffffffffffff]
 pci_bus 0000:10: resource 1 [mem 0xe0000000-0xe00fffff]
 pci_bus 0000:02: resource 0 [io  0x3000-0x3fff]
 pci_bus 0000:02: resource 1 [mem 0xe0100000-0xe03fffff]
 pci_bus 0000:02: resource 2 [mem 0x80000000-0x83ffffff pref]
 pci_bus 0000:02: resource 3 [io  0x0000-0xffff]
 pci_bus 0000:02: resource 4 [mem 0x00000000-0xffffffffffffffff]
 pci_bus 0000:03: resource 0 [io  0x3000-0x30ff]
 pci_bus 0000:03: resource 1 [io  0x3400-0x34ff]
 pci_bus 0000:03: resource 2 [mem 0x80000000-0x83ffffff pref]
 pci_bus 0000:03: resource 3 [mem 0x84000000-0x87ffffff]
 NET: Registered protocol family 2
 IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
 TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
 TCP bind hash table entries: 65536 (order: 9, 2097152 bytes)
 TCP: Hash tables configured (established 262144 bind 65536)
 TCP reno registered
 UDP hash table entries: 1024 (order: 4, 98304 bytes)
 UDP-Lite hash table entries: 1024 (order: 4, 98304 bytes)
 NET: Registered protocol family 1
 pci 0000:00:02.0: Boot video device
 PCI: CLS 64 bytes, default 64
 Trying to unpack rootfs image as initramfs...
 Freeing initrd memory: 5615k freed
 audit: initializing netlink socket (disabled)
-type=2000 audit(1271677647.651:1): initialized
+type=2000 audit(1271677401.651:1): initialized
 VFS: Disk quotas dquot_6.5.2
 Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
 msgmni has been set to 3972
 alg: No test for stdrng (krng)
 io scheduler noop registered
 io scheduler deadline registered
 io scheduler cfq registered (default)
 pcieport 0000:00:1c.0: setting latency timer to 64
 pcieport 0000:00:1c.0: irq 24 for MSI/MSI-X
 pcieport 0000:00:1c.1: setting latency timer to 64
 pcieport 0000:00:1c.1: irq 25 for MSI/MSI-X
 vesafb: framebuffer at 0xd0000000, mapped to 0xffffc90004100000, using 3072k, total 7616k
 vesafb: mode is 1024x768x16, linelength=2048, pages=3
 vesafb: scrolling: redraw
 vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
 Console: switching to colour frame buffer device 128x48
 fb0: VESA VGA frame buffer device
 Linux agpgart interface v0.103
 Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
 serial 0000:00:03.3: PCI INT B -> GSI 17 (level, low) -> IRQ 17
 0000:00:03.3: ttyS0 at I/O 0x2040 (irq = 17) is a 16550A
 brd: module loaded
 PNP: PS/2 Controller [PNP0303:C29C,PNP0f13:C29D] at 0x60,0x64 irq 1,12
 i8042.c: Detected active multiplexing controller, rev 1.1.
 serio: i8042 KBD port at 0x60,0x64 irq 1
 serio: i8042 AUX0 port at 0x60,0x64 irq 12
 serio: i8042 AUX1 port at 0x60,0x64 irq 12
 serio: i8042 AUX2 port at 0x60,0x64 irq 12
 serio: i8042 AUX3 port at 0x60,0x64 irq 12
 mice: PS/2 mouse device common for all mice
 rtc_cmos 00:06: RTC can wake from S4
 rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
 rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
 cpuidle: using governor ladder
 cpuidle: using governor menu
 TCP cubic registered
 NET: Registered protocol family 17
 registered taskstats version 1
-rtc_cmos 00:06: setting system clock to 2010-04-19 11:47:28 UTC (1271677648)
+rtc_cmos 00:06: setting system clock to 2010-04-19 11:43:22 UTC (1271677402)
 Freeing unused kernel memory: 524k freed
 input: AT Translated Set 2 keyboard as /class/input/input0
 ACPI: Fan [C3B1] (off)
 ACPI: Fan [C3B2] (off)
 ACPI: Fan [C3C8] (off)
 ACPI: Fan [C3C9] (off)
 ACPI: Fan [C3CA] (off)
 ACPI: Fan [C3CB] (off)
 ACPI: Fan [C3CC] (off)
 thermal LNXTHERM:01: registered as thermal_zone0
 ACPI: Thermal Zone [TZ6] (25 C)
 thermal LNXTHERM:02: registered as thermal_zone1
-ACPI: Thermal Zone [TZ0] (54 C)
+ACPI: Thermal Zone [TZ0] (53 C)
 thermal LNXTHERM:03: registered as thermal_zone2
 ACPI: Thermal Zone [TZ1] (55 C)
 thermal LNXTHERM:04: registered as thermal_zone3
 ACPI: Thermal Zone [TZ3] (43 C)
 thermal LNXTHERM:05: registered as thermal_zone4
 ACPI: Thermal Zone [TZ4] (30 C)
 thermal LNXTHERM:06: registered as thermal_zone5
-ACPI: Thermal Zone [TZ5] (49 C)
-ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
-ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
-ehci_hcd 0000:00:1a.7: setting latency timer to 64
-ehci_hcd 0000:00:1a.7: EHCI Host Controller
-ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
-ehci_hcd 0000:00:1a.7: debug port 1
-ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
+ACPI: Thermal Zone [TZ5] (50 C)
 e1000e: Intel(R) PRO/1000 Network Driver - 1.0.2-k2
 e1000e: Copyright (c) 1999 - 2009 Intel Corporation.
-SCSI subsystem initialized
-ehci_hcd 0000:00:1a.7: irq 18, io mem 0xe0641000
-ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
-hub 1-0:1.0: USB hub found
-hub 1-0:1.0: 4 ports detected
 e1000e 0000:00:19.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
 e1000e 0000:00:19.0: setting latency timer to 64
 e1000e 0000:00:19.0: irq 26 for MSI/MSI-X
+ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
 ricoh-mmc: Ricoh MMC Controller disabling driver
 ricoh-mmc: Copyright(c) Philip Langdale
 ricoh-mmc: Ricoh MMC controller found at 0000:02:06.3 [1180:0843] (rev 11)
 ricoh-mmc: Controller is now disabled.
+SCSI subsystem initialized
 libata version 3.00 loaded.
-ohci1394 0000:02:06.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
 sdhci: Secure Digital Host Controller Interface driver
 sdhci: Copyright(c) Pierre Ossman
-ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[19]  MMIO=[e0101000-e01017ff]  Max Packet=[2048]  IR/IT contexts=[4/4]
 sdhci-pci 0000:02:06.2: SDHCI controller found [1180:0822] (rev 21)
 sdhci-pci 0000:02:06.2: PCI INT C -> GSI 20 (level, low) -> IRQ 20
 Registered led device: mmc0::
 mmc0: SDHCI controller on PCI [0000:02:06.2] using PIO
+ohci1394 0000:02:06.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
+ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[19]  MMIO=[e0101000-e01017ff]  Max Packet=[2048]  IR/IT contexts=[4/4]
 0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:1e:68:5e:3b:04
 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
 0000:00:19.0: eth0: MAC: 6, PHY: 6, PBA No: ffffff-0ff
+ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
+ehci_hcd 0000:00:1a.7: setting latency timer to 64
+ehci_hcd 0000:00:1a.7: EHCI Host Controller
+ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
+ehci_hcd 0000:00:1a.7: debug port 1
+ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
+ehci_hcd 0000:00:1a.7: irq 18, io mem 0xe0641000
+ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
+hub 1-0:1.0: USB hub found
+hub 1-0:1.0: 4 ports detected
 ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 20 (level, low) -> IRQ 20
 ehci_hcd 0000:00:1d.7: setting latency timer to 64
 ehci_hcd 0000:00:1d.7: EHCI Host Controller
 ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
 ehci_hcd 0000:00:1d.7: debug port 1
 ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
 ehci_hcd 0000:00:1d.7: irq 20, io mem 0xe0648000
-usb 1-2: new high speed USB device using ehci_hcd and address 3
 ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
 hub 2-0:1.0: USB hub found
 hub 2-0:1.0: 6 ports detected
 ata_piix 0000:00:1f.1: version 2.13
 ata_piix 0000:00:1f.1: quirky BIOS, skipping spindown on poweroff and hibernation
 ata_piix 0000:00:1f.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
 ata_piix 0000:00:1f.1: setting latency timer to 64
 scsi0 : ata_piix
 scsi1 : ata_piix
 ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x2120 irq 14
 ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x2128 irq 15
+ata2: port disabled. ignoring.
 pata_acpi 0000:00:03.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
 pata_acpi 0000:00:03.2: setting latency timer to 64
 pata_acpi 0000:00:03.2: PCI INT C disabled
-ata2: port disabled. ignoring.
 uhci_hcd: USB Universal Host Controller Interface driver
 uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
 uhci_hcd 0000:00:1a.0: setting latency timer to 64
 uhci_hcd 0000:00:1a.0: UHCI Host Controller
 uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
 uhci_hcd 0000:00:1a.0: irq 16, io base 0x00002080
 hub 3-0:1.0: USB hub found
 hub 3-0:1.0: 2 ports detected
 uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
 uhci_hcd 0000:00:1a.1: setting latency timer to 64
 uhci_hcd 0000:00:1a.1: UHCI Host Controller
 uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
 uhci_hcd 0000:00:1a.1: irq 17, io base 0x000020a0
 hub 4-0:1.0: USB hub found
 hub 4-0:1.0: 2 ports detected
 uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
 uhci_hcd 0000:00:1d.0: setting latency timer to 64
 uhci_hcd 0000:00:1d.0: UHCI Host Controller
 uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 5
 uhci_hcd 0000:00:1d.0: irq 20, io base 0x000020c0
 hub 5-0:1.0: USB hub found
 hub 5-0:1.0: 2 ports detected
 uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 22 (level, low) -> IRQ 22
 uhci_hcd 0000:00:1d.1: setting latency timer to 64
 uhci_hcd 0000:00:1d.1: UHCI Host Controller
 uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 6
 uhci_hcd 0000:00:1d.1: irq 22, io base 0x000020e0
 hub 6-0:1.0: USB hub found
 hub 6-0:1.0: 2 ports detected
 uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
 uhci_hcd 0000:00:1d.2: setting latency timer to 64
 uhci_hcd 0000:00:1d.2: UHCI Host Controller
 uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 7
 uhci_hcd 0000:00:1d.2: irq 18, io base 0x00002100
 hub 7-0:1.0: USB hub found
 hub 7-0:1.0: 2 ports detected
-hub 1-2:1.0: USB hub found
-hub 1-2:1.0: 4 ports detected
 ata1.00: ATA-7: SAMSUNG HS122JC, GQ100-04, max UDMA/100
 ata1.00: 234441648 sectors, multi 16: LBA 
 ata1.01: ATAPI: MATSHITADVD-RAM UJ-852S, 1.02, max MWDMA2
 ata1.00: configured for UDMA/100
 ata1.01: configured for MWDMA2
 scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG HS122JC  GQ10 PQ: 0 ANSI: 5
 scsi 0:0:1:0: CD-ROM            MATSHITA DVD-RAM UJ-852S  1.02 PQ: 0 ANSI: 5
 Uniform Multi-Platform E-IDE driver
 sd 0:0:0:0: [sda] 234441648 512-byte logical blocks: (120 GB/111 GiB)
 sd 0:0:0:0: [sda] Write Protect is off
 sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
 sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
  sda: sda1 sda3 sda4 < sda5 sda6 sda7 >
+sd 0:0:0:0: [sda] Attached SCSI disk
 sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
 Uniform CD-ROM driver Revision: 3.20
 sr 0:0:1:0: Attached scsi CD-ROM sr0
-sd 0:0:0:0: [sda] Attached SCSI disk
 sd 0:0:0:0: Attached scsi generic sg0 type 0
 sr 0:0:1:0: Attached scsi generic sg1 type 5
+usb 1-2: new high speed USB device using ehci_hcd and address 3
+hub 1-2:1.0: USB hub found
+hub 1-2:1.0: 4 ports detected
 usb 3-1: new full speed USB device using uhci_hcd and address 2
-usb 5-2: new full speed USB device using uhci_hcd and address 2
-ieee1394: Host added: ID:BUS[0-00:1023]  GUID[001b249929192210]
 device-mapper: ioctl: 4.16.0-ioctl (2009-11-05) initialised: dm-devel@redhat.com
+ieee1394: Host added: ID:BUS[0-00:1023]  GUID[001b249929192210]
+usb 5-2: new full speed USB device using uhci_hcd and address 2
 usb 1-2.2: new full speed USB device using ehci_hcd and address 4
 usb 1-2.3: new low speed USB device using ehci_hcd and address 5
 usbcore: registered new interface driver hiddev
 input: Logitech USB Receiver as /class/input/input1
 generic-usb 0003:046D:C50D.0001: input: USB HID v1.10 Mouse [Logitech USB Receiver] on usb-0000:00:1a.7-2.3/input0
 usbcore: registered new interface driver usbhid
 usbhid: USB HID core driver
 usb 1-2.4: new low speed USB device using ehci_hcd and address 6
 input: USB Compliant Keyboard as /class/input/input2
 generic-usb 0003:05A4:9841.0002: input: USB HID v1.10 Keyboard [USB Compliant Keyboard] on usb-0000:00:1a.7-2.4/input0
 input: USB Compliant Keyboard as /class/input/input3
 generic-usb 0003:05A4:9841.0003: input: USB HID v1.10 Device [USB Compliant Keyboard] on usb-0000:00:1a.7-2.4/input1
 PM: Starting manual resume from disk
 kjournald starting.  Commit interval 5 seconds
 EXT3-fs (dm-1): mounted filesystem with ordered data mode
 udevd version 125 started
 input: Sleep Button as /class/input/input4
 ACPI: Sleep Button [C2BF]
 input: Lid Switch as /class/input/input5
 ACPI: Lid Switch [C155]
 input: Power Button as /class/input/input6
 ACPI: Power Button [PWRF]
 ACPI: SSDT 000000007e7dbd42 0027F (v01 HP      Cpu0Ist 00003000 INTL 20060317)
 ACPI: SSDT 000000007e7dc046 005FA (v01 HP      Cpu0Cst 00003001 INTL 20060317)
 ACPI: AC Adapter [C23B] (on-line)
 Monitor-Mwait will be used to enter C-1 state
 Monitor-Mwait will be used to enter C-2 state
 Marking TSC unstable due to TSC halts in idle
-Switching to clocksource hpet
 ACPI: SSDT 000000007e7dbc7a 000C8 (v01 HP      Cpu1Ist 00003000 INTL 20060317)
 ACPI: SSDT 000000007e7dbfc1 00085 (v01 HP      Cpu1Cst 00003000 INTL 20060317)
+Switching to clocksource hpet
 agpgart-intel 0000:00:00.0: Intel 965GM Chipset
 agpgart-intel 0000:00:00.0: detected 7676K stolen memory
+agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
 ACPI: Battery Slot [C23D] (battery present)
 ACPI: WMI: Mapper loaded
-agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
 lis3lv02d: hardware type NC2510 found.
 lis3lv02d: 12 bits sensor found
-tpm_tis 00:02: 1.2 TPM (device-id 0xB, rev-id 16)
 input: ST LIS3LV02DL Accelerometer as /class/input/input7
 Registered led device: hp::hddprotect
 lis3lv02d driver loaded.
+tpm_tis 00:02: 1.2 TPM (device-id 0xB, rev-id 16)
 input: PC Speaker as /class/input/input8
+usblp0: USB Bidirectional printer dev 4 if 0 alt 1 proto 2 vid 0x03F0 pid 0x3102
+usbcore: registered new interface driver usblp
+input: PS/2 Generic Mouse as /class/input/input9
 cfg80211: Using static regulatory domain info
 cfg80211: Regulatory domain: 00
     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
     (2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2000 mBm)
     (2457000 KHz - 2482000 KHz @ 20000 KHz), (600 mBi, 2000 mBm)
     (2474000 KHz - 2494000 KHz @ 20000 KHz), (600 mBi, 2000 mBm)
     (5170000 KHz - 5250000 KHz @ 40000 KHz), (600 mBi, 2000 mBm)
     (5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 2000 mBm)
 cfg80211: Calling CRDA to update world regulatory domain
 cfg80211: Calling CRDA for country: EU
 yenta_cardbus 0000:02:06.0: CardBus bridge found [103c:30c9]
 yenta_cardbus 0000:02:06.0: ISA IRQ mask 0x0cb8, PCI irq 18
 yenta_cardbus 0000:02:06.0: Socket status: 30000006
 pci_bus 0000:02: Raising subordinate bus# of parent bus (#02) from #03 to #06
 yenta_cardbus 0000:02:06.0: pcmcia: parent PCI bridge I/O window: 0x3000 - 0x3fff
 yenta_cardbus 0000:02:06.0: pcmcia: parent PCI bridge Memory window: 0xe0100000 - 0xe03fffff
 yenta_cardbus 0000:02:06.0: pcmcia: parent PCI bridge Memory window: 0x80000000 - 0x83ffffff
-usblp0: USB Bidirectional printer dev 4 if 0 alt 1 proto 2 vid 0x03F0 pid 0x3102
-usbcore: registered new interface driver usblp
-input: HP WMI hotkeys as /class/input/input9
+input: HP WMI hotkeys as /class/input/input10
+Synaptics Touchpad, model: 1, fw: 6.3, id: 0x1a0b1, caps: 0xa04711/0xa00000
+input: SynPS/2 Synaptics TouchPad as /class/input/input11
 iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, 2.6.34-bisect-kd
 iwlagn: Copyright(c) 2003-2009 Intel Corporation
 iwlagn 0000:10:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
 iwlagn 0000:10:00.0: setting latency timer to 64
 iwlagn 0000:10:00.0: Detected Intel Wireless WiFi Link 4965AGN REV=0x4
 iwlagn 0000:10:00.0: Tunable channels: 11 802.11bg, 13 802.11a channels
 iwlagn 0000:10:00.0: irq 27 for MSI/MSI-X
 phy0: Selected rate control algorithm 'iwl-agn-rs'
-input: PS/2 Generic Mouse as /class/input/input10
 HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
 HDA Intel 0000:00:1b.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
 HDA Intel 0000:00:1b.0: irq 28 for MSI/MSI-X
 HDA Intel 0000:00:1b.0: setting latency timer to 64
-input: HDA Digital PCBeep as /class/input/input11
-Synaptics Touchpad, model: 1, fw: 6.3, id: 0x1a0b1, caps: 0xa04711/0xa00000
-input: SynPS/2 Synaptics TouchPad as /class/input/input12
+input: HDA Digital PCBeep as /class/input/input12
 EXT3-fs (dm-1): using internal journal
 loop: module loaded
 kjournald starting.  Commit interval 5 seconds
 EXT3-fs (dm-5): using internal journal
 EXT3-fs (dm-5): mounted filesystem with ordered data mode
 kjournald starting.  Commit interval 5 seconds
 EXT3-fs (dm-2): using internal journal
 EXT3-fs (dm-2): mounted filesystem with ordered data mode
 kjournald starting.  Commit interval 5 seconds
 EXT3-fs (dm-3): using internal journal
 EXT3-fs (dm-3): mounted filesystem with ordered data mode
 kjournald starting.  Commit interval 5 seconds
 EXT3-fs (dm-4): using internal journal
 EXT3-fs (dm-4): mounted filesystem with ordered data mode
 kjournald starting.  Commit interval 5 seconds
 EXT3-fs (dm-6): using internal journal
 EXT3-fs (dm-6): mounted filesystem with ordered data mode
 kjournald starting.  Commit interval 5 seconds
 EXT3-fs (dm-9): using internal journal
 EXT3-fs (dm-9): mounted filesystem with ordered data mode
 kjournald starting.  Commit interval 5 seconds
 EXT3-fs (dm-12): using internal journal
 EXT3-fs (dm-12): mounted filesystem with ordered data mode
 kjournald starting.  Commit interval 5 seconds
 EXT3-fs (dm-8): using internal journal
 EXT3-fs (dm-8): mounted filesystem with ordered data mode
 kjournald starting.  Commit interval 5 seconds
 EXT3-fs (dm-10): using internal journal
 EXT3-fs (dm-10): mounted filesystem with ordered data mode
 Adding 2097144k swap on /dev/mapper/main-swap.  Priority:-1 extents:1 across:2097144k 
 iwlagn 0000:10:00.0: firmware: requesting iwlwifi-4965-2.ucode
 iwlagn 0000:10:00.0: loaded firmware version 228.57.2.23
 wlan0: direct probe to AP 00:14:c1:38:e5:15 (try 1)
 wlan0: direct probe responded
 wlan0: authenticate with AP 00:14:c1:38:e5:15 (try 1)
 wlan0: authenticated
 wlan0: associate with AP 00:14:c1:38:e5:15 (try 1)
 wlan0: RX AssocResp from 00:14:c1:38:e5:15 (capab=0x411 status=0 aid=1)
 wlan0: associated
 RPC: Registered udp transport module.
 RPC: Registered tcp transport module.
 RPC: Registered tcp NFSv4.1 backchannel transport module.
 Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
 NET: Registered protocol family 10
 lo: Disabled Privacy Extensions
 lp: driver loaded but no devices found
 ppdev: user-space parallel port driver
 wlan0: no IPv6 routers present
 [drm] Initialized drm 1.1.0 20060810
 pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
 pci 0000:00:02.0: setting latency timer to 64
 pci 0000:00:02.0: irq 29 for MSI/MSI-X
 acpi device:00: registered as cooling_device9
 input: Video Bus as /class/input/input13
 ACPI: Video Device [C09A] (multi-head: yes  rom: no  post: no)
 [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0

--Boundary-00=_9ZEzLEmRLWYbOlg--
