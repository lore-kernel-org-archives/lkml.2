Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758586Ab0GTJ30 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 05:29:26 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40978 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758525Ab0GTJ3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 05:29:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=TkgIkBv0y7KZqEvInuEuytma6JIAbxHOo4GdIIBbuJ3LImAvClNBDGUAbSbOyy6GXu
         2dN/CwjRBVWUkil4+ONz57dqDcZuuneCvwI7hsqcd2Brs/FRAqo9XNdaFgeK7jDGz+Tx
         W8YLGw42gNHh2aalguTooFFwidWmR05rMRMPE=
Message-ID: <4C456C69.60606@suse.cz>
Date: Tue, 20 Jul 2010 11:29:13 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.4) Gecko/20100608 SUSE/3.1.0 Thunderbird/3.1
MIME-Version: 1.0
To: Robert Hancock <hancockrwd@gmail.com>
CC: Matthew Garrett <mjg59@srcf.ucam.org>, lenb@kernel.org,
        linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH 1/1] ACPI: pci_irq, add PRT_ quirk for IBM Bartolo
References: <1277673679-21458-1-git-send-email-jslaby@suse.cz>	<4C27E965.80508@gmail.com>	<4C283D84.6080504@suse.cz>	<20100628171410.GA27367@srcf.ucam.org>	<4C290245.2040001@suse.cz>	<20100628204820.GA32503@srcf.ucam.org>	<AANLkTil-sdbojCXBp6sR_4xL3JIe6ZENqXuueB61VJ8c@mail.gmail.com>	<4C2A3E27.4060407@suse.cz>	<AANLkTimkElR1u-iRyFfCEQR5VTZvcyEIGQodfmFNtbC_@mail.gmail.com>	<4C2B0C73.9050200@suse.cz>	<4C3278C8.60503@gmail.com>	<4C447D6D.5060801@suse.cz> <AANLkTin9_yEyMZImRbtKTvTeokks8dz0htQCu0B3RqXH@mail.gmail.com>
In-Reply-To: <AANLkTin9_yEyMZImRbtKTvTeokks8dz0htQCu0B3RqXH@mail.gmail.com>
X-Enigmail-Version: 1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/19/2010 09:19 PM, Robert Hancock wrote:
> On Mon, Jul 19, 2010 at 10:29 AM, Jiri Slaby <jslaby@suse.cz> wrote:
>>>> I still no point in comparing this to Windows' setup. We can't find out
>>>> whether it is quirked or better (without some bug) handled there.
>>>
>>> Well, you can see if Windows shows IRQ 10 or 11 for that device..
>>
>> But how can I find out which link it is routed to in Windows? Without
>> that information the number is meaningless, no?
> 
> If you look at the pattern of which IRQs are shared by what devices in
> Linux and compare it to Windows you can get a good idea. Normally the
> assignment of devices to interrupt lines is hard-wired on the
> motherboard and doesn't change.

Ok, thanks for the hint.

What we've found out is that it works on 2.6.27 (with slightly changed
configuration).

In dmesgs, the only two relevant differences I see are the 8250
interrupt sharing and disabled-apic handling. 8250.irqs_share=1 passed
to 2.6.32 does not help. The apic, in the new kernel, returns zeros on
read, whereas on the old one, there is a dummy page which returns
previously stored values if I understand correctly. Can this have an effect?

The diff between .configs is at:
http://www.fi.muni.cz/~xslaby/sklad/conf-diff

 Initializing cgroup subsys cpuset
 Initializing cgroup subsys cpu
-Linux version 2.6.27.19-5-default (geeko@buildhost) (gcc version 4.3.2
[gcc-4_3-branch revision 141291] (SUSE Linux) ) #1 SMP 2009-02-28
04:40:21 +0100
+Linux version 2.6.32.10-0.4-default (geeko@buildhost) (gcc version
4.3.4 [gcc-4_3-branch revision 152973] (SUSE Linux) ) #1 SMP 2010-03-29
11:58:05 +0200
+KERNEL supported cpus:
+  Intel GenuineIntel
+  AMD AuthenticAMD
+  NSC Geode by NSC
+  Cyrix CyrixInstead
+  Centaur CentaurHauls
+  Transmeta GenuineTMx86
+  Transmeta TransmetaCPU
+  UMC UMC UMC UMC
 BIOS-provided physical RAM map:
- BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
- BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
+ BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
+ BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
  BIOS-e820: 00000000000dc000 - 00000000000e0000 (reserved)
  BIOS-e820: 00000000000e5800 - 0000000000100000 (reserved)
  BIOS-e820: 0000000000100000 - 000000001fbf0000 (usable)
@@ -12,81 +21,128 @@
  BIOS-e820: 00000000fffe0000 - 0000000100000000 (reserved)
 DMI 2.3 present.
 last_pfn = 0x1fbf0 max_arch_pfn = 0x100000
+MTRR default type: uncachable
+MTRR fixed ranges enabled:
+  00000-9FFFF write-back
+  A0000-BFFFF uncachable
+  C0000-C7FFF write-protect
+  C8000-DFFFF uncachable
+  E0000-FFFFF write-protect
+MTRR variable ranges enabled:
+  0 base 000000000 mask FF0000000 write-back
+  1 base 010000000 mask FF8000000 write-back
+  2 base 018000000 mask FFC000000 write-back
+  3 base 01C000000 mask FFE000000 write-back
+  4 base 01E000000 mask FFF000000 write-back
+  5 base 01F000000 mask FFF800000 write-back
+  6 base 01F800000 mask FFFC00000 write-back
+  7 disabled
 x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
+e820 update range: 0000000000002000 - 0000000000006000 (usable) ==>
(reserved)
+Scanning 1 areas for low memory corruption
+modified physical RAM map:
+ modified: 0000000000000000 - 0000000000002000 (usable)
+ modified: 0000000000002000 - 0000000000006000 (reserved)
+ modified: 0000000000006000 - 000000000009f800 (usable)
+ modified: 000000000009f800 - 00000000000a0000 (reserved)
+ modified: 00000000000dc000 - 00000000000e0000 (reserved)
+ modified: 00000000000e5800 - 0000000000100000 (reserved)
+ modified: 0000000000100000 - 000000001fbf0000 (usable)
+ modified: 000000001fbf0000 - 000000001fbffc00 (ACPI data)
+ modified: 000000001fbffc00 - 000000001fc00000 (ACPI NVS)
+ modified: 00000000fffe0000 - 0000000100000000 (reserved)
+initial memory mapped : 0 - 00c00000
+init_memory_mapping: 0000000000000000-000000001fbf0000
+ 0000000000 - 0000400000 page 4k
+ 0000400000 - 001f800000 page 2M
+ 001f800000 - 001fbf0000 page 4k
 kernel direct mapping tables up to 1fbf0000 @ 7000-d000
-RAMDISK: 1f627000 - 1fbdfdb3
-ACPI: RSDP 000F7560, 0014 (r0 PTLTD )
-ACPI: RSDT 1FBFDAAC, 002C (r1 PTLTD     RSDT    6040000  LTP        0)
-ACPI: FACP 1FBFFB64, 0074 (r1 IBM    4810-31x  6040000 PTL   1000000)
-ACPI: DSDT 1FBFDAD8, 208C (r1  VIA   PTL_ACPI  6040000 MSFT  100000B)
-ACPI: FACS 1FBFFFC0, 0040
-ACPI: BOOT 1FBFFBD8, 0028 (r1 PTLTD  $SBFTBL$  6040000  LTP        1)
+RAMDISK: 1f68a000 - 1fbdf22e
+ACPI: RSDP 000f7560 00014 (v00 PTLTD )
+ACPI: RSDT 1fbfdaac 0002C (v01 PTLTD  ? RSDT   06040000  LTP 00000000)
+ACPI: FACP 1fbffb64 00074 (v01 IBM    4810-31x 06040000 PTL  01000000)
+ACPI: DSDT 1fbfdad8 0208C (v01  VIA   PTL_ACPI 06040000 MSFT 0100000B)
+ACPI: FACS 1fbfffc0 00040
+ACPI: BOOT 1fbffbd8 00028 (v01 PTLTD  $SBFTBL$ 06040000  LTP 00000001)
 0MB HIGHMEM available.
 507MB LOWMEM available.
   mapped low ram: 0 - 1fbf0000
-  low ram: 00000000 - 1fbf0000
-  bootmap 00002000 - 00005f80
+  low ram: 0 - 1fbf0000
+  node 0 low ram: 00000000 - 1fbf0000
+  node 0 bootmap 00009000 - 0000cf80
 (9 early reservations) ==> bootmem [0000000000 - 001fbf0000]
   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 -
0000001000]
   #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 -
0000002000]
   #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 -
0000007000]
-  #3 [0000100000 - 0000634a5c]    TEXT DATA BSS ==> [0000100000 -
0000634a5c]
-  #4 [001f627000 - 001fbdfdb3]          RAMDISK ==> [001f627000 -
001fbdfdb3]
-  #5 [0000635000 - 0000638000]    INIT_PG_TABLE ==> [0000635000 -
0000638000]
-  #6 [000009f000 - 0000100000]    BIOS reserved ==> [000009f000 -
0000100000]
+  #3 [0000200000 - 00008bea84]    TEXT DATA BSS ==> [0000200000 -
00008bea84]
+  #4 [001f68a000 - 001fbdf22e]          RAMDISK ==> [001f68a000 -
001fbdf22e]
+  #5 [000009f000 - 0000100000]    BIOS reserved ==> [000009f000 -
0000100000]
+  #6 [00008bf000 - 00008c209a]              BRK ==> [00008bf000 -
00008c209a]
   #7 [0000007000 - 0000009000]          PGTABLE ==> [0000007000 -
0000009000]
-  #8 [0000002000 - 0000006000]          BOOTMAP ==> [0000002000 -
0000006000]
+  #8 [0000009000 - 000000d000]          BOOTMAP ==> [0000009000 -
000000d000]
 Zone PFN ranges:
   DMA      0x00000000 -> 0x00001000
   Normal   0x00001000 -> 0x0001fbf0
   HighMem  0x0001fbf0 -> 0x0001fbf0
 Movable zone start PFN for each node
-early_node_map[2] active PFN ranges
-    0: 0x00000000 -> 0x0000009f
+early_node_map[3] active PFN ranges
+    0: 0x00000000 -> 0x00000002
+    0: 0x00000006 -> 0x0000009f
     0: 0x00000100 -> 0x0001fbf0
-On node 0 totalpages: 129935
-free_area_init_node: node 0, pgdat c050a280, node_mem_map c1000000
+On node 0 totalpages: 129931
+free_area_init_node: node 0, pgdat c0769580, node_mem_map c1001000
+  DMA zone: 32 pages used for memmap
+  DMA zone: 0 pages reserved
   DMA zone: 3963 pages, LIFO batch:0
-  Normal zone: 124829 pages, LIFO batch:31
+  Normal zone: 984 pages used for memmap
+  Normal zone: 124952 pages, LIFO batch:31
 Using APIC driver default
 ACPI: PM-Timer IO Port: 0x8008
 SMP: Allowing 1 CPUs, 0 hotplug CPUs
 No local APIC present or hardware disabled
-mapped APIC to ffffb000 (01479000)
+APIC: disable apic facility
+nr_irqs_gsi: 16
+PM: Registered nosave memory: 0000000000002000 - 0000000000006000
 PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
 PM: Registered nosave memory: 00000000000a0000 - 00000000000dc000
 PM: Registered nosave memory: 00000000000dc000 - 00000000000e0000
 PM: Registered nosave memory: 00000000000e0000 - 00000000000e6000
 PM: Registered nosave memory: 00000000000e6000 - 0000000000100000
-Allocating PCI resources starting at 20000000 (gap: 1fc00000:e03e0000)
-PERCPU: Allocating 37916 bytes of per cpu data
-NR_CPUS: 32, nr_cpu_ids: 1, nr_node_ids 1
-Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 128792
-Kernel command line:
root=/dev/disk/by-id/ata-Maxtor_4D040H2_D23LF17E-part2
resume=/dev/disk/by-id/ata-Maxtor_4D040H2_D23LF17E-part1 splash=silent
vga=0x317
+Allocating PCI resources starting at 1fc00000 (gap: 1fc00000:e03e0000)
+Booting paravirtualized kernel on bare hardware
+NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:1 nr_node_ids:1
+PERCPU: Embedded 12 pages/cpu @c1400000 s28184 r0 d20968 u4194304
+pcpu-alloc: s28184 r0 d20968 u4194304 alloc=1*4194304
+pcpu-alloc: [0] 0
+Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 128915
+Kernel command line:
root=/dev/disk/by-id/ata-WDC_WD400BB-23JHA1_WD-WMAMA1000905-part3
resume=/dev/disk/by-id/ata-WDC_WD400BB-23JHA1_WD-WMAMA1000905-part2
splash=silent 3
 bootsplash: silent mode.
+PID hash table entries: 2048 (order: 1, 8192 bytes)
+Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
+Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
 Enabling fast FPU save and restore... done.
 Enabling unmasked SIMD FPU exception support... done.
 Initializing CPU#0
-PID hash table entries: 2048 (order: 11, 8192 bytes)
-TSC: PIT calibration confirmed by PMTIMER.
-TSC: using PIT calibration value
-Detected 1191.973 MHz processor.
-Console: colour dummy device 80x25
-console [tty0] enabled
-Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
-Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
-Memory: 503284k/520128k available (2297k kernel code, 16264k reserved,
1925k data, 280k init, 0k highmem)
+allocated 2600640 bytes of page_cgroup
+please try 'cgroup_disable=memory' option if you don't want memory cgroups
+Initializing HighMem for node 0 (00000000:00000000)
+Memory: 500028k/520128k available (3228k kernel code, 19492k reserved,
2358k data, 400k init, 0k highmem)
 virtual kernel memory layout:
-    fixmap  : 0xffdf7000 - 0xfffff000   (2080 kB)
+    fixmap  : 0xffd34000 - 0xfffff000   (2860 kB)
     pkmap   : 0xff400000 - 0xff800000   (4096 kB)
-    vmalloc : 0xe0800000 - 0xff3fe000   ( 491 MB)
+    vmalloc : 0xe03f0000 - 0xff3fe000   ( 496 MB)
     lowmem  : 0xc0000000 - 0xdfbf0000   ( 507 MB)
-      .init : 0xc0527000 - 0xc056d000   ( 280 kB)
-      .data : 0xc033e4f5 - 0xc051fcd0   (1925 kB)
-      .text : 0xc0100000 - 0xc033e4f5   (2297 kB)
+      .init : 0xc0775000 - 0xc07d9000   ( 400 kB)
+      .data : 0xc0527319 - 0xc0774ee8   (2358 kB)
+      .text : 0xc0200000 - 0xc0527319   (3228 kB)
 Checking if this processor honours the WP bit even in supervisor mode...Ok.
-CPA: page pool initialized 1 of 1 pages preallocated
-Calibrating delay loop (skipped), value calculated using timer
frequency.. 2383.94 BogoMIPS (lpj=4767892)
+Hierarchical RCU implementation.
+NR_IRQS:2304 nr_irqs:256
+Console: colour VGA+ 80x25
+console [tty0] enabled
+Fast TSC calibration using PIT
+Detected 1191.909 MHz processor.
+Calibrating delay loop (skipped), value calculated using timer
frequency.. 2383.81 BogoMIPS (lpj=4767636)
 kdb version 4.4 by Keith Owens, Scott Lurndal. Copyright SGI, All
Rights Reserved
 Security Framework initialized
 AppArmor: AppArmor initialized
@@ -96,108 +152,102 @@
 Initializing cgroup subsys memory
 Initializing cgroup subsys devices
 Initializing cgroup subsys freezer
-CPU: L1 I Cache: 64K (32 bytes/line), D cache 64K (32 bytes/line)
-CPU: L2 Cache: 64K (32 bytes/line)
+Initializing cgroup subsys net_cls
+Performance Events:
 Checking 'hlt' instruction... OK.
 SMP alternatives: switching to UP code
-Freeing SMP alternatives: 18k freed
-ACPI: Core revision 20080609
-ACPI: Checking initramfs for custom DSDT
-Parsing all Control Methods:
-Table [DSDT](id 0001) - 259 Objects with 34 Devices 66 Methods 12 Regions
- tbxface-0596 [00] tb_load_namespace     : ACPI Tables successfully
acquired
+Freeing SMP alternatives: 14k freed
+ACPI: Core revision 20090903
 ACPI: setting ELCR to 0200 (from 0e00)
-evxfevnt-0091 [00] enable                : Transition to ACPI mode
successful
-weird, boot CPU (#0) not listedby the BIOS.
+Enabling APIC mode:  Flat.  Using 0 I/O APICs
+weird, boot CPU (#0) not listed by the BIOS.
 SMP motherboard not detected.
 Local APIC not detected. Using dummy APIC emulation.
 SMP disabled
 Brought up 1 CPUs
-Total of 1 processors activated (2383.94 BogoMIPS).
-CPU0 attaching NULL sched-domain.
-net_namespace: 1044 bytes
+Total of 1 processors activated (2383.81 BogoMIPS).
+devtmpfs: initialized
+regulator: core version 0.5
+Time: 21:46:46  Date: 04/13/11
 NET: Registered protocol family 16
 ACPI: bus type pci registered
 PCI: PCI BIOS revision 2.10 entry at 0xfd7ee, last bus=1
 PCI: Using configuration type 1 for base access
-perfmon: version 2.82
-perfmon: CPU hotplug support enabled
-evgpeblk-0957 [00] ev_create_gpe_block   : GPE 00 to 0F [_GPE] 2 regs
on int 0x9
+bio: create slab <bio-0> at 0
 ACPI: EC: Look up EC in DSDT
-Completing Region/Field/Buffer/Package
initialization:................................................
-Initialized 10/12 Regions 3/4 Fields 22/23 Buffers 13/13 Packages (268
nodes)
-Initializing Device/Processor/Thermal objects by executing _INI methods:
-Executed 0 _INI methods requiring 0 _STA executions (examined 37 objects)
-evgpeblk-1054 [00] ev_initialize_gpe_bloc: Found 3 Wake, Enabled 0
Runtime GPEs in this block
 ACPI: Interpreter enabled
 ACPI: (supports S0 S1 S5)
 ACPI: Using PIC for interrupt routing
+ACPI: No dock devices found.
+PCI: Ignoring host bridge windows from ACPI; if necessary, use
"pci=use_crs" and report a bug
 ACPI: PCI Root Bridge [PCI0] (0000:00)
-PCI: 0000:00:00.0 reg 10 32bit mmio: [fd000000, fdffffff]
-PCI: 0000:00:07.1 reg 20 io port: [1840, 184f]
-PCI: 0000:00:07.2 reg 20 io port: [1800, 181f]
-PCI: 0000:00:07.3 reg 20 io port: [1820, 183f]
+pci 0000:00:00.0: reg 10 32bit mmio pref: [0xfd000000-0xfdffffff]
+pci 0000:00:07.1: reg 20 io port: [0x1840-0x184f]
+pci 0000:00:07.2: reg 20 io port: [0x1800-0x181f]
+pci 0000:00:07.3: reg 20 io port: [0x1820-0x183f]
 pci 0000:00:07.4: quirk: region 6800-687f claimed by vt82c686 HW-mon
 pci 0000:00:07.4: quirk: region 8100-810f claimed by vt82c686 SMB
-PCI: 0000:00:07.5 reg 10 io port: [1000, 10ff]
-PCI: 0000:00:07.5 reg 14 io port: [1874, 1877]
-PCI: 0000:00:07.5 reg 18 io port: [1870, 1873]
-PCI: 0000:00:09.0 reg 10 io port: [1898, 189f]
-PCI: 0000:00:09.0 reg 14 io port: [1890, 1897]
-PCI: 0000:00:09.0 reg 18 io port: [1888, 188f]
-PCI: 0000:00:09.0 reg 1c io port: [1880, 1887]
-PCI: 0000:00:09.0 reg 20 io port: [1878, 187f]
-PCI: 0000:00:09.0 reg 24 io port: [1850, 185f]
-pci 0000:00:09.0: Netmos 9835 (9 parallel, 9 serial); changing class
SERIAL to OTHER (use parport_serial)
-PCI: 0000:00:0b.0 reg 10 io port: [18c0, 18c7]
-PCI: 0000:00:0b.0 reg 14 io port: [18b8, 18bf]
-PCI: 0000:00:0b.0 reg 18 io port: [18b0, 18b7]
-PCI: 0000:00:0b.0 reg 1c io port: [18a8, 18af]
-PCI: 0000:00:0b.0 reg 20 io port: [18a0, 18a7]
-PCI: 0000:00:0b.0 reg 24 io port: [1860, 186f]
-PCI: 0000:00:0d.0 reg 10 io port: [1400, 14ff]
-PCI: 0000:00:0d.0 reg 14 32bit mmio: [fb000000, fb000fff]
-PCI: 0000:00:0d.0 reg 30 32bit mmio: [0, ffff]
-pci 0000:00:0d.0: supports D1
-pci 0000:00:0d.0: supports D2
+pci 0000:00:07.5: reg 10 io port: [0x1000-0x10ff]
+pci 0000:00:07.5: reg 14 io port: [0x1874-0x1877]
+pci 0000:00:07.5: reg 18 io port: [0x1870-0x1873]
+pci 0000:00:09.0: reg 10 io port: [0x1898-0x189f]
+pci 0000:00:09.0: reg 14 io port: [0x1890-0x1897]
+pci 0000:00:09.0: reg 18 io port: [0x1888-0x188f]
+pci 0000:00:09.0: reg 1c io port: [0x1880-0x1887]
+pci 0000:00:09.0: reg 20 io port: [0x1878-0x187f]
+pci 0000:00:09.0: reg 24 io port: [0x1850-0x185f]
+pci 0000:00:0b.0: reg 10 io port: [0x18c0-0x18c7]
+pci 0000:00:0b.0: reg 14 io port: [0x18b8-0x18bf]
+pci 0000:00:0b.0: reg 18 io port: [0x18b0-0x18b7]
+pci 0000:00:0b.0: reg 1c io port: [0x18a8-0x18af]
+pci 0000:00:0b.0: reg 20 io port: [0x18a0-0x18a7]
+pci 0000:00:0b.0: reg 24 io port: [0x1860-0x186f]
+pci 0000:00:0d.0: reg 10 io port: [0x1400-0x14ff]
+pci 0000:00:0d.0: reg 14 32bit mmio: [0xfb000000-0xfb000fff]
+pci 0000:00:0d.0: reg 30 32bit mmio pref: [0x000000-0x00ffff]
+pci 0000:00:0d.0: supports D1 D2
 pci 0000:00:0d.0: PME# supported from D0 D1 D2 D3hot D3cold
 pci 0000:00:0d.0: PME# disabled
-PCI: 0000:01:00.0 reg 10 32bit mmio: [fc000000, fc7fffff]
-PCI: 0000:01:00.0 reg 14 32bit mmio: [fb100000, fb11ffff]
-PCI: 0000:01:00.0 reg 18 32bit mmio: [fb800000, fbffffff]
-PCI: 0000:01:00.0 reg 30 32bit mmio: [0, ffff]
-pci 0000:01:00.0: supports D1
-pci 0000:01:00.0: supports D2
-PCI: bridge 0000:00:01.0 32bit mmio: [fb100000, fc7fffff]
-bus 00 -> node 0
+pci 0000:01:00.0: reg 10 32bit mmio: [0xfc000000-0xfc7fffff]
+pci 0000:01:00.0: reg 14 32bit mmio: [0xfb100000-0xfb11ffff]
+pci 0000:01:00.0: reg 18 32bit mmio: [0xfb800000-0xfbffffff]
+pci 0000:01:00.0: reg 30 32bit mmio pref: [0x000000-0x00ffff]
+pci 0000:01:00.0: supports D1 D2
+pci 0000:00:01.0: PCI bridge to [bus 01-01]
+pci 0000:00:01.0: bridge 32bit mmio: [0xfb100000-0xfc7fffff]
+pci_bus 0000:00: on NUMA node 0
 ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
 ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PPB_._PRT]
 ACPI: PCI Interrupt Link [LNKA] (IRQs 5 7 9 10 *11 12)
 ACPI: PCI Interrupt Link [LNKB] (IRQs 5 7 9 10 11 12) *0, disabled.
 ACPI: PCI Interrupt Link [LNKC] (IRQs 5 7 9 *10 11 12)
 ACPI: PCI Interrupt Link [LNKD] (IRQs 5 7 *9 10 11 12)
-Linux Plug and Play Support v0.97 (c) Adam Belay
+vgaarb: device added:
PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
+vgaarb: loaded
+PCI: Using ACPI for IRQ routing
+NetLabel: Initializing
+NetLabel:  domain hash size = 128
+NetLabel:  protocols = UNLABELED CIPSOv4
+NetLabel:  unlabeled traffic allowed by default
+Switching to clocksource tsc
+AppArmor: AppArmor Filesystem Enabled
 pnp: PnP ACPI init
 ACPI: bus type pnp registered
 pnp: PnP ACPI: found 12 devices
 ACPI: ACPI bus type pnp unregistered
 PnPBIOS: Disabled by ACPI PNP
-PCI: Using ACPI for IRQ routing
-AppArmor: AppArmor Filesystem Enabled
 system 00:05: iomem range 0x0-0x9ffff could not be reserved
 system 00:05: iomem range 0xe0000-0xfffff could not be reserved
 system 00:06: ioport range 0x4d0-0x4d1 has been reserved
 pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
 pci 0000:00:01.0:   IO window: disabled
 pci 0000:00:01.0:   MEM window: 0xfb100000-0xfc7fffff
-pci 0000:00:01.0:   PREFETCH window: 0x00000020000000-0x000000200fffff
+pci 0000:00:01.0:   PREFETCH window: 0x20000000-0x200fffff
 pci 0000:00:01.0: setting latency timer to 64
-bus: 00 index 0 io port: [0, ffff]
-bus: 00 index 1 mmio: [0, ffffffff]
-bus: 01 index 0 mmio: [0, 0]
-bus: 01 index 1 mmio: [fb100000, fc7fffff]
-bus: 01 index 2 mmio: [20000000, 200fffff]
-bus: 01 index 3 mmio: [0, 0]
+pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
+pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffff]
+pci_bus 0000:01: resource 1 mem: [0xfb100000-0xfc7fffff]
+pci_bus 0000:01: resource 2 pref mem [0x20000000-0x200fffff]
 NET: Registered protocol family 2
 IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
 TCP established hash table entries: 16384 (order: 5, 131072 bytes)
@@ -205,39 +255,31 @@
 TCP: Hash tables configured (established 16384 bind 16384)
 TCP reno registered
 NET: Registered protocol family 1
-Unpacking initramfs...<7>Switched to high resolution mode on CPU 0
- done
-Freeing initrd memory: 5859k freed
+pci 0000:00:01.0: disabling DAC on VIA PCI bridge
+pci 0000:00:07.0: Disabling VIA external APIC routing
+pci 0000:01:00.0: Boot video device
+Unpacking initramfs...
+Freeing initrd memory: 5460k freed
 Simple Boot Flag at 0x36 set to 0x1
+Scanning for low memory corruption every 60 seconds
 audit: initializing netlink socket (disabled)
-type=2000 audit(1311129780.512:1): initialized
+type=2000 audit(1302731206.718:1): initialized
 HugeTLB registered 4 MB page size, pre-allocated 0 pages
-VFS: Disk quotas dquot_6.5.1
+VFS: Disk quotas dquot_6.5.2
 Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
-msgmni has been set to 248
-Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
+msgmni has been set to 246
+alg: No test for stdrng (krng)
+Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
 io scheduler noop registered
 io scheduler anticipatory registered
 io scheduler deadline registered
 io scheduler cfq registered (default)
-perfmon: added sampling format default
-PCI: VIA PCI bridge detected.Disabling DAC.
-pci 0000:00:07.0: Disabling VIA external APIC routing
-pci 0000:01:00.0: Boot video device
-vesafb: framebuffer at 0xfc000000, mapped to 0xe0880000, using 4096k,
total 4096k
-vesafb: mode is 1024x768x16, linelength=2048, pages=1
-vesafb: protected mode interface info at c000:67c0
-vesafb: pmi: set display start = c00c67d0, set palette = c00c6833
-vesafb: scrolling: redraw
-vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
-bootsplash 3.1.6-2004/03/31: looking for picture...
-bootsplash: silentjpeg size 59221 bytes
-bootsplash: ...found (1024x768, 31358 bytes, v3).
-Console: switching to colour frame buffer device 124x44
-fb0: VESA VGA frame buffer device
+pci-stub: invalid id string ""
 isapnp: Scanning for PnP cards...
 isapnp: No Plug & Play device found
-Serial: 8250/16550 driver8 ports, IRQ sharing enabled
+Non-volatile memory driver v1.3
+Linux agpgart interface v0.103
+Serial: 8250/16550 driver, 8 ports, IRQ sharing disabled
 serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
 serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
 00:07: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
@@ -251,6 +293,7 @@
 serial 0000:00:0b.0: PCI INT A -> Link[LNKA] -> GSI 11 (level, low) ->
IRQ 11
 0000:00:0b.0: ttyS6 at I/O 0x18c0 (irq = 11) is a 16550A
 0000:00:0b.0: ttyS7 at I/O 0x18b8 (irq = 11) is a 16550A
+Fixed MDIO Bus: probed
 PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
 serio: i8042 KBD port at 0x60,0x64 irq 1
 serio: i8042 AUX port at 0x60,0x64 irq 12
@@ -259,252 +302,198 @@
 cpuidle: using governor menu
 TCP cubic registered
 Using IPI No-Shortcut mode
+PM: Checking image partition
/dev/disk/by-id/ata-WDC_WD400BB-23JHA1_WD-WMAMA1000905-part2
+PM: Resume from disk failed.
 registered taskstats version 1
-Freeing unused kernel memory: 280k freed
-Write protecting the kernel text: 2300k
-Write protecting the kernel read-only data: 1732k
-ACPI: CPU0 (power states: C1[C1] C2[C2])
-processor ACPI_CPU:00: registered as cooling_device0
-ACPI: Processor [CPU0] (supports 16 throttling states)
-ACPI: No dock devices found.
+  Magic number: 7:428:803
+Freeing unused kernel memory: 400k freed
+Write protecting the kernel text: 3232k
+Write protecting the kernel read-only data: 2120k
 SCSI subsystem initialized
 libata version 3.00 loaded.
-pata_via 0000:00:07.1: version 0.3.3
+pata_via 0000:00:07.1: version 0.3.4
 scsi0 : pata_via
 scsi1 : pata_via
 ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x1840 irq 14
 ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x1848 irq 15
 ata1: port disabled. ignoring.
-Marking TSC unstable due to TSC halts in idle
-ata2.00: ATA-6: Maxtor 4D040H2, DAH017K0, max UDMA/100
+ata2.00: ATA-6: WDC WD400BB-23JHA1, 06.01C06, max UDMA/100
 ata2.00: 78156288 sectors, multi 16: LBA
 ata2.00: limited to UDMA/33 due to 40-wire cable
 ata2.00: configured for UDMA/33
-scsi 1:0:0:0: Direct-Access     ATA      Maxtor 4D040H2   DAH0 PQ: 0
ANSI: 5
+scsi 1:0:0:0: Direct-Access     ATA      WDC WD400BB-23JH 06.0 PQ: 0
ANSI: 5
 Uniform Multi-Platform E-IDE driver
-BIOS EDD facility v0.16 2004-Jun-25, 2 devices found
+Marking TSC unstable due to TSC halts in idle
+Switching to clocksource acpi_pm
+BIOS EDD facility v0.16 2004-Jun-25, 1 devices found
 udevd version 128 started
-sd 1:0:0:0: [sda] 78156288 512-byte hardware sectors: (40.0GB/37.2GiB)
+sd 1:0:0:0: [sda] 78156288 512-byte logical blocks: (40.0 GB/37.2 GiB)
 sd 1:0:0:0: [sda] Write Protect is off
 sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
 sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
-sd 1:0:0:0: [sda] 78156288 512-byte hardware sectors: (40.0GB/37.2GiB)
-sd 1:0:0:0: [sda] Write Protect is off
-sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
-sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
- sda:<3>ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6
-ata2.00: BMDMA stat 0x24
-ata2.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 dma 4096 in
-         res 51/84:00:00:00:00/00:00:00:00:00/e0 Emask 0x10 (ATA bus error)
-ata2.00: status: { DRDY ERR }
-ata2.00: error: { ICRC ABRT }
-ata2: soft resetting link
+ sda: sda1 sda2 sda3
+sd 1:0:0:0: [sda] Attached SCSI disk
 usbcore: registered new interface driver usbfs
 usbcore: registered new interface driver hub
 usbcore: registered new device driver usb
-USB Universal Host Controller Interface driver v3.0
+ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
+uhci_hcd: USB Universal Host Controller Interface driver
 ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 9
 PCI: setting IRQ 9 as level-triggered
 uhci_hcd 0000:00:07.2: PCI INT D -> Link[LNKD] -> GSI 9 (level, low) ->
IRQ 9
 uhci_hcd 0000:00:07.2: UHCI Host Controller
 uhci_hcd 0000:00:07.2: new USB bus registered, assigned bus number 1
 uhci_hcd 0000:00:07.2: irq 9, io base 0x00001800
-usb usb1: configuration #1 chosen from 1 choice
-hub 1-0:1.0: USB hub found
-hub 1-0:1.0: 2 ports detected
-ata2.00: configured for UDMA/33
-ata2: EH complete
-ata2.00: limiting speed to UDMA/25:PIO4
-ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6
-ata2.00: BMDMA stat 0x24
-ata2.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 dma 4096 in
-         res 51/84:00:00:00:00/00:00:00:00:00/e0 Emask 0x10 (ATA bus error)
-ata2.00: status: { DRDY ERR }
-ata2.00: error: { ICRC ABRT }
-ata2: soft resetting link
 usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
 usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
 usb usb1: Product: UHCI Host Controller
-usb usb1: Manufacturer: Linux 2.6.27.19-5-default uhci_hcd
+usb usb1: Manufacturer: Linux 2.6.32.10-0.4-default uhci_hcd
 usb usb1: SerialNumber: 0000:00:07.2
+usb usb1: configuration #1 chosen from 1 choice
+hub 1-0:1.0: USB hub found
+hub 1-0:1.0: 2 ports detected
 uhci_hcd 0000:00:07.3: PCI INT D -> Link[LNKD] -> GSI 9 (level, low) ->
IRQ 9
 uhci_hcd 0000:00:07.3: UHCI Host Controller
 uhci_hcd 0000:00:07.3: new USB bus registered, assigned bus number 2
 uhci_hcd 0000:00:07.3: irq 9, io base 0x00001820
-usb usb2: configuration #1 chosen from 1 choice
-hub 2-0:1.0: USB hub found
-hub 2-0:1.0: 2 ports detected
-ata2.00: configured for UDMA/25
-ata2: EH complete
-usb 1-1: new full speed USB device using uhci_hcd and address 2
-ata2.00: limiting speed to PIO4
-ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6
-ata2.00: BMDMA stat 0x24
-ata2.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 dma 4096 in
-         res 51/84:00:00:00:00/00:00:00:00:00/e0 Emask 0x10 (ATA bus error)
-ata2.00: status: { DRDY ERR }
-ata2.00: error: { ICRC ABRT }
-ata2: soft resetting link
 usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
 usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
 usb usb2: Product: UHCI Host Controller
-usb usb2: Manufacturer: Linux 2.6.27.19-5-default uhci_hcd
+usb usb2: Manufacturer: Linux 2.6.32.10-0.4-default uhci_hcd
 usb usb2: SerialNumber: 0000:00:07.3
-ata2.00: configured for PIO4
-ata2: EH complete
-sd 1:0:0:0: [sda] 78156288 512-byte hardware sectors: (40.0GB/37.2GiB)
-sd 1:0:0:0: [sda] Write Protect is off
-sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
-sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
- sda1 sda2
-sd 1:0:0:0: [sda] Attached SCSI disk
-sd 1:0:0:0: [sda] 78156288 512-byte hardware sectors: (40.0GB/37.2GiB)
-sd 1:0:0:0: [sda] Write Protect is off
-sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
-sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
-sda: detected capacity change from 0 to 40016019456
-usb 1-1: configuration #1 chosen from 1 choice
-usb 1-1: New USB device found, idVendor=090c, idProduct=1000
-usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
-usb 1-1: Product: USB DISK
-usb 1-1: Manufacturer: SMI Corporation
-usb 1-1: SerialNumber: AAD7593000008325
-usb 1-2: new full speed USB device using uhci_hcd and address 3
-usb 1-2: configuration #1 chosen from 1 choice
-usb 1-2: New USB device found, idVendor=0984, idProduct=0066
-usb 1-2: New USB device strings: Mfr=74, Product=57, SerialNumber=44
-usb 1-2: Product: USB_MultiBurner3
-usb 1-2: Manufacturer: Lenovo
-usb 1-2: SerialNumber: 070801035989
+usb usb2: configuration #1 chosen from 1 choice
+hub 2-0:1.0: USB hub found
+hub 2-0:1.0: 2 ports detected
 usb 2-1: new full speed USB device using uhci_hcd and address 2
-usb 2-1: configuration #1 chosen from 1 choice
-hub 2-1:1.0: USB hub found
-hub 2-1:1.0: 4 ports detected
-PM: Starting manual resume from disk
 usb 2-1: New USB device found, idVendor=04b3, idProduct=3016
 usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
 usb 2-1: Product: USB 1.1 2 port downstream low-power hub
 usb 2-1: Manufacturer: Lite-On Tech
+usb 2-1: configuration #1 chosen from 1 choice
+hub 2-1:1.0: USB hub found
+hub 2-1:1.0: 4 ports detected
+PM: Marking nosave pages: 0000000000002000 - 0000000000006000
+PM: Marking nosave pages: 000000000009f000 - 0000000000100000
+PM: Basic memory bitmaps created
+PM: Basic memory bitmaps freed
+PM: Starting manual resume from disk
+PM: Resume from partition 8:2
+PM: Checking hibernation image.
+PM: Error -22 checking image file
+PM: Resume from disk failed.
 usb 2-1.3: new low speed USB device using uhci_hcd and address 3
-usb 2-1.3: configuration #1 chosen from 1 choice
 usb 2-1.3: New USB device found, idVendor=04b3, idProduct=3019
 usb 2-1.3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
 usb 2-1.3: Product: IBM USB Travel Keyboard with UltraNav
 usb 2-1.3: Manufacturer: Lite-On Tech
+usb 2-1.3: configuration #1 chosen from 1 choice
+usbcore: registered new interface driver hiddev
+input: Lite-On Tech IBM USB Travel Keyboard with UltraNav as
/devices/pci0000:00/0000:00:07.3/usb2/2-1/2-1.3/2-1.3:1.0/input/input0
+generic-usb 0003:04B3:3019.0001: input,hidraw0: USB HID v1.00 Keyboard
[Lite-On Tech IBM USB Travel Keyboard with UltraNav] on
usb-0000:00:07.3-1.3/input0
+input: Lite-On Tech IBM USB Travel Keyboard with UltraNav as
/devices/pci0000:00/0000:00:07.3/usb2/2-1/2-1.3/2-1.3:1.1/input/input1
+generic-usb 0003:04B3:3019.0002: input,hidraw1: USB HID v1.00 Device
[Lite-On Tech IBM USB Travel Keyboard with UltraNav] on
usb-0000:00:07.3-1.3/input1
+usbcore: registered new interface driver usbhid
+usbhid: v2.6:USB HID core driver
 usb 2-1.4: new low speed USB device using uhci_hcd and address 4
-usb 2-1.4: configuration #1 chosen from 1 choice
+kjournald starting.  Commit interval 15 seconds
+EXT3 FS on sda3, internal journal
+EXT3-fs: mounted filesystem with ordered data mode.
 usb 2-1.4: New USB device found, idVendor=06cb, idProduct=0009
 usb 2-1.4: New USB device strings: Mfr=1, Product=2, SerialNumber=0
 usb 2-1.4: Product: Composite TouchPad / TrackPoint
 usb 2-1.4: Manufacturer: Synaptics Inc.
-usbcore: registered new interface driver hiddev
-input: Lite-On Tech IBM USB Travel Keyboard with UltraNav as
/devices/pci0000:00/0000:00:07.3/usb2/2-1/2-1.3/2-1.3:1.0/input/input0
-input,hidraw0: USB HID v1.00 Keyboard [Lite-On Tech IBM USB Travel
Keyboard with UltraNav] on usb-0000:00:07.3-1.3
-input: Lite-On Tech IBM USB Travel Keyboard with UltraNav as
/devices/pci0000:00/0000:00:07.3/usb2/2-1/2-1.3/2-1.3:1.1/input/input1
-input,hidraw1: USB HID v1.00 Device [Lite-On Tech IBM USB Travel
Keyboard with UltraNav] on usb-0000:00:07.3-1.3
+usb 2-1.4: configuration #1 chosen from 1 choice
 input: Synaptics Inc. Composite TouchPad / TrackPoint as
/devices/pci0000:00/0000:00:07.3/usb2/2-1/2-1.4/2-1.4:1.0/input/input2
-input,hidraw2: USB HID v1.00 Mouse [Synaptics Inc. Composite TouchPad /
TrackPoint] on usb-0000:00:07.3-1.4
-kjournald starting.  Commit interval 5 seconds
-EXT3 FS on sda2, internal journal
-EXT3-fs: mounted filesystem with ordered data mode.
+generic-usb 0003:06CB:0009.0003: input,hidraw2: USB HID v1.00 Mouse
[Synaptics Inc. Composite TouchPad / TrackPoint] on
usb-0000:00:07.3-1.4/input0
 input: Synaptics Inc. Composite TouchPad / TrackPoint as
/devices/pci0000:00/0000:00:07.3/usb2/2-1/2-1.4/2-1.4:1.1/input/input3
-input,hidraw3: USB HID v1.00 Mouse [Synaptics Inc. Composite TouchPad /
TrackPoint] on usb-0000:00:07.3-1.4
-usbcore: registered new interface driver usbhid
-usbhid: v2.6:USB HID core driver
+generic-usb 0003:06CB:0009.0004: input,hidraw3: USB HID v1.00 Mouse
[Synaptics Inc. Composite TouchPad / TrackPoint] on
usb-0000:00:07.3-1.4/input1
 udevd version 128 started
-sd 1:0:0:0: Attached scsi generic sg0 type 0
-Linux agpgart interface v0.103
-Initializing USB Mass Storage driver...
-scsi2 : SCSI emulation for USB Mass Storage devices
-scsi3 : SCSI emulation for USB Mass Storage devices
-usbcore: registered new interface driver usb-storage
-USB Mass Storage support registered.
-usb-storage: device found at 3
-usb-storage: waiting for device to settle before scanning
-usb-storage: device found at 2
-usb-storage: waiting for device to settle before scanning
+input: PC Speaker as /devices/platform/pcspkr/input/input4
 agpgart: Detected VIA Apollo ProMedia/PLE133Ta chipset
 agpgart-via 0000:00:00.0: AGP aperture is 16M @ 0xfd000000
+sd 1:0:0:0: Attached scsi generic sg0 type 0
+natsemi dp8381x driver, version 2.1, Sept 11, 2006
+  originally by Donald Becker <becker@scyld.com>
+  2.4.x kernel port by Jeff Garzik, Tjeerd Mulder
+natsemi 0000:00:0d.0: PCI INT A -> Link[LNKD] -> GSI 9 (level, low) ->
IRQ 9
+natsemi eth0: NatSemi DP8381[56] at 0xfb000000 (0000:00:0d.0),
00:0d:60:02:8b:98, IRQ 9, port TP.
 pci_hotplug: PCI Hot Plug PCI Core version: 0.5
-input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input4
-ACPI: Power Button (FF) [PWRF]
-input: Power Button (CM) as
/devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input5
-shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
+input: Power Button as
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input5
+ACPI: Power Button [PWRB]
+input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input6
+ACPI: Power Button [PWRF]
 parport_pc: VIA 686A/8231 detected
 parport_pc: probing current configuration
 parport_pc: Current parallel port base: 0x378
 parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE,EPP]
-ACPI: Power Button (CM) [PWRB]
-scsi 2:0:0:0: Direct-Access     USB      Flash Disk       1100 PQ: 0
ANSI: 0 CCS
-sd 2:0:0:0: [sdb] 15663104 512-byte hardware sectors: (8.01GB/7.46GiB)
-scsi 3:0:0:0: CD-ROM            LENOVO   USB_MultiBurner3 NL31 PQ: 0
ANSI: 0
-scsi 3:0:0:0: Attached scsi generic sg1 type 5
-usb-storage: device scan complete
-sd 2:0:0:0: [sdb] Write Protect is off
-sd 2:0:0:0: [sdb] Mode Sense: 43 00 00 00
-sd 2:0:0:0: [sdb] Assuming drive cache: write through
-parport_pc: VIA parallel port: io=0x378, irq=7
-sd 2:0:0:0: [sdb] 15663104 512-byte hardware sectors: (8.01GB/7.46GiB)
-sd 2:0:0:0: [sdb] Write Protect is off
-sd 2:0:0:0: [sdb] Mode Sense: 43 00 00 00
-sd 2:0:0:0: [sdb] Assuming drive cache: write through
- sdb: sdb1
-sd 2:0:0:0: [sdb] Attached SCSI removable disk
-sd 2:0:0:0: Attached scsi generic sg2 type 0
-usb-storage: device scan complete
+shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
+rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
+rtc0: alarms up to one year, y3k, 242 bytes nvram
 vt596_smbus 0000:00:07.4: SMBUS: Error: Host SMBus controller not
enabled! - upgrade BIOS or use force=1
-natsemi dp8381x driver, version 2.1, Sept 11, 2006
-  originally by Donald Becker <becker@scyld.com>
-  2.4.x kernel port by Jeff Garzik, Tjeerd Mulder
-natsemi 0000:00:0d.0: PCI INT A -> Link[LNKD] -> GSI 9 (level, low) ->
IRQ 9
-natsemi eth0: NatSemi DP8381[56] at 0xfb000000 (0000:00:0d.0),
00:0d:60:02:8b:98, IRQ 9, port TP.
-input: PC Speaker as /devices/platform/pcspkr/input/input6
+parport_pc: VIA parallel port: io=0x378, irq=7
+ppdev: user-space parallel port driver
 ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 10
 PCI: setting IRQ 10 as level-triggered
 VIA 82xx Audio 0000:00:07.5: PCI INT C -> Link[LNKC] -> GSI 10 (level,
low) -> IRQ 10
 VIA 82xx Audio 0000:00:07.5: setting latency timer to 64
-rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
-rtc0: alarms up to one year, y3k
-ppdev: user-space parallel port driver
-sr0: scsi-1 drive
-Uniform CD-ROM driver Revision: 3.20
-sr 3:0:0:0: Attached scsi CD-ROM sr0
-Adding 2096472k swap on /dev/sda1.  Priority:-1 extents:1 across:2096472k
+Adding 2096472k swap on /dev/sda2.  Priority:-1 extents:1 across:2096472k
 device-mapper: uevent: version 1.0.3
-device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised:
dm-devel@redhat.com
+device-mapper: ioctl: 4.15.0-ioctl (2009-04-01) initialised:
dm-devel@redhat.com
 loop: module loaded

-- 
js
suse labs
