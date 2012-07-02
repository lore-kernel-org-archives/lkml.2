Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932261Ab2GBFbT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 01:31:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22095 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752086Ab2GBFbP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 01:31:15 -0400
Date: Mon, 2 Jul 2012 07:31:12 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Kamil Grzebien <ciptok@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: Initializing iwl3945 error
Message-ID: <20120702053110.GA2500@redhat.com>
References: <CANHD2=rF6dBkLLkWAj8uS3nq0B1wCt7Uvu=HzO84UNz2kuiaFg@mail.gmail.com>
 <20120313081235.GC15333@redhat.com>
 <CAErSpo6t-cVBdJfyARi3ifEuBUvopbG5GQSP5YywrvumDK8HFA@mail.gmail.com>
 <CANHD2=qSWRv76mjwhTNMgO=u5yYCh2QZzxbNLNaPWm1d52FtOg@mail.gmail.com>
 <20120528140448.GA22783@redhat.com>
 <CAErSpo6XVgzeQiWjXJs6vxdQ5_O7LFG-j4p=4S7rQSyBdq7-SA@mail.gmail.com>
 <20120529092154.GA2441@redhat.com>
 <CAErSpo6Xxq_kcEYACKUsuNDOJDhEDnxWgBUateOJEBcfqufhSg@mail.gmail.com>
 <CANHD2=o-eyd2JR7oK4gJgQi3Mi-a=R1RKuGsuWzzR_WosQaNEA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANHD2=o-eyd2JR7oK4gJgQi3Mi-a=R1RKuGsuWzzR_WosQaNEA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 01, 2012 at 07:01:58PM +0100, Kamil Grzebien wrote:
> I haven't tried your patch yet, but wanted to share with one thing.
> Currently I use new kernel 3.4.3, where the problem doesn't exist
> anymore. However I still would like to know what was the cause and
> which change brought the solution. Is there anything which comes to
> your mind in terms of recent changes in kernel? I also added logs from
> the newest kernel, so it might be easier for track it.

Below is the diff from working kernel and non working kernel.
You are using PAE kernel what influence PCI mappings. Is this fixed also
on 3.4 non-PAE kernel?

Stanislaw

--- bad/dmesg.log	2012-05-28 15:12:13.559424823 +0200
+++ dmesg.log	2012-07-02 07:22:35.534393336 +0200
@@ -1,6 +1,6 @@
 Initializing cgroup subsys cpuset
 Initializing cgroup subsys cpu
-Linux version 3.3.0-4.fc16.i686 (mockbuild@x86-04.phx2.fedoraproject.org) (gcc version 4.6.2 20111027 (Red Hat 4.6.2-1) (GCC) ) #1 SMP Tue Mar 20 18:45:14 UTC 2012
+Linux version 3.4.3-1.fc17.i686.PAE (mockbuild@x86-04.phx2.fedoraproject.org) (gcc version 4.7.0 20120507 (Red Hat 4.7.0-5) (GCC) ) #1 SMP Mon Jun 18 20:31:39 UTC 2012
 BIOS-provided physical RAM map:
  BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
  BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
@@ -14,12 +14,12 @@ BIOS-provided physical RAM map:
  BIOS-e820: 00000000fee00000 - 00000000fee10000 (reserved)
  BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
  BIOS-e820: 0000000100000000 - 0000000120000000 (usable)
-Notice: NX (Execute Disable) protection cannot be enabled: non-PAE kernel!
+NX (Execute Disable) protection: active
 DMI 2.4 present.
 DMI: Dell Inc. XPS M1530                       /0D501F, BIOS A12 11/19/2008
 e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
 e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
-last_pfn = 0xdfe72 max_arch_pfn = 0x100000
+last_pfn = 0x120000 max_arch_pfn = 0x1000000
 MTRR default type: uncachable
 MTRR fixed ranges enabled:
   00000-9FFFF write-back
@@ -52,14 +52,14 @@ reg 1, base: 3583MB, range: 1MB, type UC
 reg 2, base: 3584MB, range: 512MB, type UC
 reg 3, base: 4GB, range: 512MB, type WB
 e820 update range: 00000000dff00000 - 0000000100000000 (usable) ==> (reserved)
-initial memory mapped : 0 - 01000000
-9b000 size 16384
-init_memory_mapping: 0000000000000000-00000000373fe000
- 0000000000 - 0000400000 page 4k
- 0000400000 - 0037000000 page 2M
- 0037000000 - 00373fe000 page 4k
-kernel direct mapping tables up to 373fe000 @ ffa000-1000000
-RAMDISK: 35f5c000 - 36fa6000
+initial memory mapped : 0 - 01200000
+Base memory trampoline at [c009b000] 9b000 size 16384
+init_memory_mapping: 0000000000000000-00000000375fe000
+ 0000000000 - 0000200000 page 4k
+ 0000200000 - 0037400000 page 2M
+ 0037400000 - 00375fe000 page 4k
+kernel direct mapping tables up to 375fe000 @ 11f8000-1200000
+RAMDISK: 3615c000 - 370a6000
 ACPI: RSDP 000fbc90 00024 (v02 DELL  )
 ACPI: XSDT dfe73a00 00064 (v01 DELL    M08     27D80B13 ASL  00000061)
 ACPI: FACP dfe7389c 000F4 (v04 DELL    M08     27D80B13 ASL  00000061)
@@ -73,35 +73,36 @@ ACPI: OSFR dfe73200 0002C (v01 DELL    M
 ACPI: BOOT dfe737c0 00028 (v01 DELL    M08     27D80B13 ASL  00000061)
 ACPI: SSDT dfe7217e 004CC (v01  PmRef    CpuPm 00003000 INTL 20050624)
 ACPI: Local APIC address 0xfee00000
-2698MB HIGHMEM available.
-883MB LOWMEM available.
-  mapped low ram: 0 - 373fe000
-  low ram: 0 - 373fe000
+3722MB HIGHMEM available.
+885MB LOWMEM available.
+  mapped low ram: 0 - 375fe000
+  low ram: 0 - 375fe000
 Zone PFN ranges:
   DMA      0x00000010 -> 0x00001000
-  Normal   0x00001000 -> 0x000373fe
-  HighMem  0x000373fe -> 0x000dfe72
+  Normal   0x00001000 -> 0x000375fe
+  HighMem  0x000375fe -> 0x00120000
 Movable zone start PFN for each node
 Early memory PFN ranges
     0: 0x00000010 -> 0x0000009f
     0: 0x00000100 -> 0x000dfe72
-On node 0 totalpages: 916993
-free_area_init_node: node 0, pgdat c0ba2f00, node_mem_map f435c200
+    0: 0x00100000 -> 0x00120000
+On node 0 totalpages: 1048065
+free_area_init_node: node 0, pgdat c0bd0d40, node_mem_map f3d5c200
   DMA zone: 32 pages used for memmap
   DMA zone: 0 pages reserved
   DMA zone: 3951 pages, LIFO batch:0
-  Normal zone: 1736 pages used for memmap
-  Normal zone: 220470 pages, LIFO batch:31
-  HighMem zone: 5397 pages used for memmap
-  HighMem zone: 685407 pages, LIFO batch:31
+  Normal zone: 1740 pages used for memmap
+  Normal zone: 220978 pages, LIFO batch:31
+  HighMem zone: 7445 pages used for memmap
+  HighMem zone: 813919 pages, LIFO batch:31
 Using APIC driver default
 ACPI: PM-Timer IO Port: 0x1008
 ACPI: Local APIC address 0xfee00000
-enabled)
-enabled)
-high edge lint[0x1])
-high edge lint[0x1])
-gsi_base[0])
+ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
+ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
+ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
+ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
+ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
 IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
 ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
 ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
@@ -117,40 +118,39 @@ PM: Registered nosave memory: 0000000000
 Allocating PCI resources starting at e0000000 (gap: e0000000:18000000)
 Booting paravirtualized kernel on bare hardware
 setup_percpu: NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:2 nr_node_ids:1
-PERCPU: Embedded 13 pages/cpu @f3c00000 s31168 r0 d22080 u2097152
-pcpu-alloc: s31168 r0 d22080 u2097152 alloc=1*4194304
-0 1 
-Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 909828
-Kernel command line: BOOT_IMAGE=/vmlinuz-3.3.0-4.fc16.i686 root=UUID=7417d839-a647-466e-b57d-fc65d20a6342 ro rd.md=0 rd.lvm=0 rd.dm=0 quiet SYSFONT=latarcyrheb-sun16 rhgb rd.luks=0 KEYTABLE=pl2 LANG=en_US.UTF-8
+PERCPU: Embedded 14 pages/cpu @f75cf000 s34112 r0 d23232 u57344
+pcpu-alloc: s34112 r0 d23232 u57344 alloc=14*4096
+pcpu-alloc: [0] 0 [0] 1 
+Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1038848
+Kernel command line: BOOT_IMAGE=/vmlinuz-3.4.3-1.fc17.i686.PAE root=UUID=29c27e52-ab08-4c1a-9ed7-86ab260b207b ro rd.md=0 rd.lvm=0 rd.dm=0 SYSFONT=True KEYTABLE=pl2 rd.luks=0 LANG=pl_PL.UTF-8 rhgb quiet
 PID hash table entries: 4096 (order: 2, 16384 bytes)
 Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
 Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
 Initializing CPU#0
-allocated 7336720 bytes of page_cgroup
+allocated 9437056 bytes of page_cgroup
 please try 'cgroup_disable=memory' option if you don't want memory cgroups
-Initializing HighMem for node 0 (000373fe:000dfe72)
-Memory: 3605028k/3668424k available (5337k kernel code, 62944k reserved, 2570k data, 620k init, 2763216k highmem)
+Initializing HighMem for node 0 (000375fe:00120000)
+Memory: 4119724k/4718592k available (5442k kernel code, 72536k reserved, 2650k data, 640k init, 3285456k highmem)
 virtual kernel memory layout:
     fixmap  : 0xffa96000 - 0xfffff000   (5540 kB)
-    pkmap   : 0xff400000 - 0xff800000   (4096 kB)
-    vmalloc : 0xf7bfe000 - 0xff3fe000   ( 120 MB)
-    lowmem  : 0xc0000000 - 0xf73fe000   ( 883 MB)
-      .init : 0xc0bb9000 - 0xc0c54000   ( 620 kB)
-      .data : 0xc093671f - 0xc0bb8f80   (2570 kB)
-      .text : 0xc0400000 - 0xc093671f   (5337 kB)
+    pkmap   : 0xff600000 - 0xff800000   (2048 kB)
+    vmalloc : 0xf7dfe000 - 0xff5fe000   ( 120 MB)
+    lowmem  : 0xc0000000 - 0xf75fe000   ( 885 MB)
+      .init : 0xc0be8000 - 0xc0c88000   ( 640 kB)
+      .data : 0xc0950a93 - 0xc0be7480   (2650 kB)
+      .text : 0xc0400000 - 0xc0950a93   (5442 kB)
 Checking if this processor honours the WP bit even in supervisor mode...Ok.
 SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
 Hierarchical RCU implementation.
-	RCU dyntick-idle grace-period acceleration is enabled.
 NR_IRQS:2304 nr_irqs:512 16
 CPU 0 irqstacks, hard=f3008000 soft=f300a000
 Extended CMOS year: 2000
 Console: colour dummy device 80x25
-enabled
+console [tty0] enabled
 hpet clockevent registered
 Fast TSC calibration using PIT
-Detected 2394.148 MHz processor.
-Calibrating delay loop (skipped), value calculated using timer frequency.. 4788.29 BogoMIPS (lpj=2394148)
+Detected 2393.857 MHz processor.
+Calibrating delay loop (skipped), value calculated using timer frequency.. 4787.71 BogoMIPS (lpj=2393857)
 pid_max: default: 32768 minimum: 301
 Security Framework initialized
 SELinux:  Initializing.
@@ -168,12 +168,12 @@ CPU: Processor Core ID: 0
 mce: CPU supports 6 MCE banks
 CPU0: Thermal monitoring enabled (TM2)
 using mwait in idle threads.
-ACPI: Core revision 20120111
-ftrace: allocating 21899 entries in 43 pages
+ACPI: Core revision 20120320
+ftrace: allocating 22370 entries in 44 pages
 Enabling APIC mode:  Flat.  Using 1 I/O APICs
 ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
 CPU0: Intel(R) Core(TM)2 Duo CPU     T8300  @ 2.40GHz stepping 06
-Performance Events: PEBS fmt0+, Core2 events, Intel PMU driver.
+Performance Events: PEBS fmt0+, 4-deep LBR, Core2 events, Intel PMU driver.
 ... version:                2
 ... bit width:              40
 ... generic registers:      2
@@ -181,17 +181,16 @@ Performance Events: PEBS fmt0+, Core2 ev
 ... max period:             000000007fffffff
 ... fixed-purpose events:   3
 ... event mask:             0000000700000003
-NMI watchdog enabled, takes one hw-pmu counter.
-CPU 1 irqstacks, hard=f30ce000 soft=f30d8000
+NMI watchdog: enabled, takes one hw-pmu counter.
+CPU 1 irqstacks, hard=f30e0000 soft=f30e2000
 Booting Node   0, Processors  #1 Ok.
-smpboot cpu 1: start_ip = 9b000
 Initializing CPU#1
-NMI watchdog enabled, takes one hw-pmu counter.
+NMI watchdog: enabled, takes one hw-pmu counter.
 Brought up 2 CPUs
-Total of 2 processors activated (9576.59 BogoMIPS).
+Total of 2 processors activated (9575.42 BogoMIPS).
 devtmpfs: initialized
 atomic64 test passed for i586+ platform with CX8 and with SSE
-RTC time: 12:29:27, date: 04/08/12
+RTC time: 18:54:40, date: 07/01/12
 NET: Registered protocol family 16
 ACPI: bus type pci registered
 PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
@@ -222,7 +221,7 @@ ACPI: (supports S0 S3 S4 S5)
 ACPI: Using IOAPIC for interrupt routing
 ACPI: No dock devices found.
 PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
-(domain 0000 [bus 00-ff])
+ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
 pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7]
 pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff]
 pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
@@ -235,7 +234,7 @@ pci_root PNP0A03:00: host bridge window 
 pci_root PNP0A03:00: host bridge window [mem 0xfeda7000-0xfedfffff]
 pci_root PNP0A03:00: host bridge window [mem 0xfee10000-0xff9fffff]
 pci_root PNP0A03:00: host bridge window [mem 0xffc00000-0xffdfffff]
-pci_root PNP0A03:00: host bridge window [0x120000000-0x317ffffff] (ignored, not CPU addressable)
+pci_root PNP0A03:00: host bridge window [mem 0x120000000-0x317ffffff]
 PCI host bridge to bus 0000:00
 pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
 pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
@@ -249,48 +248,49 @@ pci_bus 0000:00: root bus resource [mem 
 pci_bus 0000:00: root bus resource [mem 0xfeda7000-0xfedfffff]
 pci_bus 0000:00: root bus resource [mem 0xfee10000-0xff9fffff]
 pci_bus 0000:00: root bus resource [mem 0xffc00000-0xffdfffff]
-type 0 class 0x000600
-type 1 class 0x000604
+pci_bus 0000:00: root bus resource [mem 0x120000000-0x317ffffff]
+pci 0000:00:00.0: [8086:2a00] type 00 class 0x060000
+pci 0000:00:01.0: [8086:2a01] type 01 class 0x060400
 pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
-type 0 class 0x000c03
+pci 0000:00:1a.0: [8086:2834] type 00 class 0x0c0300
 pci 0000:00:1a.0: reg 20: [io  0x6f20-0x6f3f]
-type 0 class 0x000c03
+pci 0000:00:1a.1: [8086:2835] type 00 class 0x0c0300
 pci 0000:00:1a.1: reg 20: [io  0x6f00-0x6f1f]
-pci 0000:00:1a.7: [8086:283a] type 0 class 0x000c03
+pci 0000:00:1a.7: [8086:283a] type 00 class 0x0c0320
 pci 0000:00:1a.7: reg 10: [mem 0xfed1c400-0xfed1c7ff]
 pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
-pci 0000:00:1b.0: [8086:284b] type 0 class 0x000403
+pci 0000:00:1b.0: [8086:284b] type 00 class 0x040300
 pci 0000:00:1b.0: reg 10: [mem 0xf6ffc000-0xf6ffffff 64bit]
 pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
-pci 0000:00:1c.0: [8086:283f] type 1 class 0x000604
+pci 0000:00:1c.0: [8086:283f] type 01 class 0x060400
 pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
-type 1 class 0x000604
+pci 0000:00:1c.1: [8086:2841] type 01 class 0x060400
 pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
-type 1 class 0x000604
+pci 0000:00:1c.4: [8086:2847] type 01 class 0x060400
 pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
-type 0 class 0x000c03
+pci 0000:00:1d.0: [8086:2830] type 00 class 0x0c0300
 pci 0000:00:1d.0: reg 20: [io  0x6f80-0x6f9f]
-type 0 class 0x000c03
+pci 0000:00:1d.1: [8086:2831] type 00 class 0x0c0300
 pci 0000:00:1d.1: reg 20: [io  0x6f60-0x6f7f]
-type 0 class 0x000c03
+pci 0000:00:1d.2: [8086:2832] type 00 class 0x0c0300
 pci 0000:00:1d.2: reg 20: [io  0x6f40-0x6f5f]
-type 0 class 0x000c03
+pci 0000:00:1d.7: [8086:2836] type 00 class 0x0c0320
 pci 0000:00:1d.7: reg 10: [mem 0xfed1c000-0xfed1c3ff]
 pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
-type 1 class 0x000604
-type 0 class 0x000601
+pci 0000:00:1e.0: [8086:2448] type 01 class 0x060401
+pci 0000:00:1f.0: [8086:2815] type 00 class 0x060100
 pci 0000:00:1f.0: quirk: [io  0x1000-0x107f] claimed by ICH6 ACPI/GPIO/TCO
 pci 0000:00:1f.0: quirk: [io  0x1080-0x10bf] claimed by ICH6 GPIO
 pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0900 (mask 007f)
 pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 006c (mask 0007)
 pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 0c80 (mask 003f)
-type 0 class 0x000101
+pci 0000:00:1f.1: [8086:2850] type 00 class 0x01018a
 pci 0000:00:1f.1: reg 10: [io  0x01f0-0x01f7]
 pci 0000:00:1f.1: reg 14: [io  0x03f4-0x03f7]
 pci 0000:00:1f.1: reg 18: [io  0x0170-0x0177]
 pci 0000:00:1f.1: reg 1c: [io  0x0374-0x0377]
 pci 0000:00:1f.1: reg 20: [io  0x6fa0-0x6faf]
-type 0 class 0x000106
+pci 0000:00:1f.2: [8086:2829] type 00 class 0x010601
 pci 0000:00:1f.2: reg 10: [io  0x6eb0-0x6eb7]
 pci 0000:00:1f.2: reg 14: [io  0x6eb8-0x6ebb]
 pci 0000:00:1f.2: reg 18: [io  0x6ec0-0x6ec7]
@@ -298,10 +298,10 @@ pci 0000:00:1f.2: reg 1c: [io  0x6ec8-0x
 pci 0000:00:1f.2: reg 20: [io  0x6ee0-0x6eff]
 pci 0000:00:1f.2: reg 24: [mem 0xf6ffb800-0xf6ffbfff]
 pci 0000:00:1f.2: PME# supported from D3hot
-pci 0000:00:1f.3: [8086:283e] type 0 class 0x000c05
+pci 0000:00:1f.3: [8086:283e] type 00 class 0x0c0500
 pci 0000:00:1f.3: reg 10: [mem 0xf6ffb700-0xf6ffb7ff]
 pci 0000:00:1f.3: reg 20: [io  0x10c0-0x10df]
-type 0 class 0x000300
+pci 0000:01:00.0: [10de:0407] type 00 class 0x030000
 pci 0000:01:00.0: reg 10: [mem 0xf5000000-0xf5ffffff]
 pci 0000:01:00.0: reg 14: [mem 0xe0000000-0xefffffff 64bit pref]
 pci 0000:01:00.0: reg 1c: [mem 0xf2000000-0xf3ffffff 64bit]
@@ -311,7 +311,7 @@ pci 0000:00:01.0: PCI bridge to [bus 01-
 pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
 pci 0000:00:01.0:   bridge window [mem 0xf2000000-0xf6efffff]
 pci 0000:00:01.0:   bridge window [mem 0xe0000000-0xefffffff 64bit pref]
-type 0 class 0x000200
+pci 0000:09:00.0: [11ab:4354] type 00 class 0x020000
 pci 0000:09:00.0: reg 10: [mem 0xf1ffc000-0xf1ffffff 64bit]
 pci 0000:09:00.0: reg 18: [io  0xde00-0xdeff]
 pci 0000:09:00.0: supports D1 D2
@@ -319,7 +319,7 @@ pci 0000:09:00.0: PME# supported from D0
 pci 0000:00:1c.0: PCI bridge to [bus 09-09]
 pci 0000:00:1c.0:   bridge window [io  0xd000-0xdfff]
 pci 0000:00:1c.0:   bridge window [mem 0xf1f00000-0xf1ffffff]
-type 0 class 0x000280
+pci 0000:0b:00.0: [8086:4222] type 00 class 0x028000
 pci 0000:0b:00.0: reg 10: [mem 0xf1eff000-0xf1efffff]
 pci 0000:0b:00.0: PME# supported from D0 D3hot D3cold
 pci 0000:0b:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
@@ -329,27 +329,25 @@ pci 0000:00:1c.4: PCI bridge to [bus 0c-
 pci 0000:00:1c.4:   bridge window [io  0xc000-0xcfff]
 pci 0000:00:1c.4:   bridge window [mem 0xf1c00000-0xf1dfffff]
 pci 0000:00:1c.4:   bridge window [mem 0xf0000000-0xf01fffff 64bit pref]
-type 0 class 0x000c00
-pci 0000:03:09.0: proprietary Ricoh MMC controller disabled (via firewire function)
-pci 0000:03:09.0: MMC cards are now supported by standard SDHCI controller
+pci 0000:03:09.0: [1180:0832] type 00 class 0x0c0010
 pci 0000:03:09.0: reg 10: [mem 0xf1bff800-0xf1bfffff]
 pci 0000:03:09.0: supports D1 D2
 pci 0000:03:09.0: PME# supported from D0 D1 D2 D3hot D3cold
-type 0 class 0x000805
-pci 0000:03:09.1: reg 10: [mem 0xf1bff400-0xf1bff4ff]
+pci 0000:03:09.1: [1180:0822] type 00 class 0x080501
+pci 0000:03:09.1: reg 10: [mem 0xf1bff500-0xf1bff5ff]
 pci 0000:03:09.1: supports D1 D2
 pci 0000:03:09.1: PME# supported from D0 D1 D2 D3hot D3cold
-type 0 class 0x000880
+pci 0000:03:09.2: [1180:0592] type 00 class 0x088000
 pci 0000:03:09.2: reg 10: [mem 0xf1bff600-0xf1bff6ff]
 pci 0000:03:09.2: supports D1 D2
 pci 0000:03:09.2: PME# supported from D0 D1 D2 D3hot D3cold
-type 0 class 0x000880
+pci 0000:03:09.3: [1180:0852] type 00 class 0x088000
 pci 0000:03:09.3: reg 10: [mem 0xf1bff700-0xf1bff7ff]
 pci 0000:03:09.3: supports D1 D2
 pci 0000:03:09.3: PME# supported from D0 D1 D2 D3hot D3cold
-(subtractive decode)
+pci 0000:00:1e.0: PCI bridge to [bus 03-03] (subtractive decode)
 pci 0000:00:1e.0:   bridge window [mem 0xf1b00000-0xf1bfffff]
-(subtractive decode)
+pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
 pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
 pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
 pci 0000:00:1e.0:   bridge window [mem 0x000d0000-0x000dffff] (subtractive decode)
@@ -361,6 +359,7 @@ pci 0000:00:1e.0:   bridge window [mem 0
 pci 0000:00:1e.0:   bridge window [mem 0xfeda7000-0xfedfffff] (subtractive decode)
 pci 0000:00:1e.0:   bridge window [mem 0xfee10000-0xff9fffff] (subtractive decode)
 pci 0000:00:1e.0:   bridge window [mem 0xffc00000-0xffdfffff] (subtractive decode)
+pci 0000:00:1e.0:   bridge window [mem 0x120000000-0x317ffffff] (subtractive decode)
 pci_bus 0000:00: on NUMA node 0
 ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
 ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIE._PRT]
@@ -415,7 +414,7 @@ pnp 00:00: [mem 0xfed90000-0xfed9ffff wi
 pnp 00:00: [mem 0xfeda7000-0xfedfffff window]
 pnp 00:00: [mem 0xfee10000-0xff9fffff window]
 pnp 00:00: [mem 0xffc00000-0xffdfffff window]
-pnp 00:00: [mem 0x20000000-0x17ffffff window]
+pnp 00:00: [mem 0x120000000-0x317ffffff window]
 pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
 pnp 00:01: [io  0x004e-0x004f]
 pnp 00:01: [io  0x0068-0x006f]
@@ -468,10 +467,10 @@ pnp 00:0a: [irq 0 disabled]
 pnp 00:0a: [io  0x04d0-0x04d1]
 pnp 00:0a: [io  0x1000-0x1005]
 pnp 00:0a: [io  0x1008-0x100f]
-because it overlaps 0000:00:1f.0 BAR 13 [io  0x1000-0x107f]
+pnp 00:0a: disabling [io  0x1000-0x1005] because it overlaps 0000:00:1f.0 BAR 13 [io  0x1000-0x107f]
 pnp 00:0a: disabling [io  0x1008-0x100f] because it overlaps 0000:00:1f.0 BAR 13 [io  0x1000-0x107f]
 system 00:0a: [io  0x0900-0x097f] has been reserved
-has been reserved
+system 00:0a: [io  0x04d0-0x04d1] has been reserved
 system 00:0a: Plug and Play ACPI device, IDs PNP0c01 (active)
 pnp 00:0b: [io  0xf400-0xf4fe]
 pnp 00:0b: [io  0x0086]
@@ -481,13 +480,13 @@ pnp 00:0b: [io  0x1080-0x10bf]
 pnp 00:0b: [io  0x10c0-0x10df]
 pnp 00:0b: [io  0x1010-0x102f]
 pnp 00:0b: [io  0x0809]
-because it overlaps 0000:00:1f.0 BAR 13 [io  0x1000-0x107f]
-because it overlaps 0000:00:1f.0 BAR 13 [io  0x1000-0x107f]
+pnp 00:0b: disabling [io  0x1006-0x1007] because it overlaps 0000:00:1f.0 BAR 13 [io  0x1000-0x107f]
+pnp 00:0b: disabling [io  0x100a-0x1059] because it overlaps 0000:00:1f.0 BAR 13 [io  0x1000-0x107f]
 pnp 00:0b: disabling [io  0x1010-0x102f] because it overlaps 0000:00:1f.0 BAR 13 [io  0x1000-0x107f]
 system 00:0b: [io  0xf400-0xf4fe] has been reserved
 system 00:0b: [io  0x1080-0x10bf] has been reserved
 system 00:0b: [io  0x10c0-0x10df] has been reserved
-has been reserved
+system 00:0b: [io  0x0809] has been reserved
 system 00:0b: Plug and Play ACPI device, IDs PNP0c01 (active)
 pnp 00:0c: [mem 0x00000000-0x0009efff]
 pnp 00:0c: [mem 0x0009f000-0x0009ffff]
@@ -528,10 +527,15 @@ system 00:0c: [mem 0xf8000000-0xfbffffff
 system 00:0c: Plug and Play ACPI device, IDs PNP0c01 (active)
 pnp: PnP ACPI: found 13 devices
 ACPI: ACPI bus type pnp unregistered
-PCI: max bus depth: 1 pci_try_num: 2
-pci 0000:00:1c.1: BAR 15: assigned [mem 0xf0200000-0xf03fffff 64bit pref]
+pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 09-09] add_size 200000
+pci 0000:00:1c.1: bridge window [io  0x1000-0x0fff] to [bus 0b-0b] add_size 1000
+pci 0000:00:1c.1: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 0b-0b] add_size 200000
+pci 0000:00:1c.0: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
+pci 0000:00:1c.1: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
+pci 0000:00:1c.1: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
+pci 0000:00:1c.0: BAR 15: assigned [mem 0xf0200000-0xf03fffff 64bit pref]
+pci 0000:00:1c.1: BAR 15: assigned [mem 0xf0400000-0xf05fffff 64bit pref]
 pci 0000:00:1c.1: BAR 13: assigned [io  0x2000-0x2fff]
-pci 0000:00:1c.0: BAR 15: assigned [mem 0xf0400000-0xf05fffff 64bit pref]
 pci 0000:01:00.0: BAR 6: assigned [mem 0xf4000000-0xf401ffff pref]
 pci 0000:00:01.0: PCI bridge to [bus 01-01]
 pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
@@ -540,11 +544,11 @@ pci 0000:00:01.0:   bridge window [mem 0
 pci 0000:00:1c.0: PCI bridge to [bus 09-09]
 pci 0000:00:1c.0:   bridge window [io  0xd000-0xdfff]
 pci 0000:00:1c.0:   bridge window [mem 0xf1f00000-0xf1ffffff]
-pci 0000:00:1c.0:   bridge window [mem 0xf0400000-0xf05fffff 64bit pref]
+pci 0000:00:1c.0:   bridge window [mem 0xf0200000-0xf03fffff 64bit pref]
 pci 0000:00:1c.1: PCI bridge to [bus 0b-0b]
 pci 0000:00:1c.1:   bridge window [io  0x2000-0x2fff]
 pci 0000:00:1c.1:   bridge window [mem 0xf1e00000-0xf1efffff]
-pci 0000:00:1c.1:   bridge window [mem 0xf0200000-0xf03fffff 64bit pref]
+pci 0000:00:1c.1:   bridge window [mem 0xf0400000-0xf05fffff 64bit pref]
 pci 0000:00:1c.4: PCI bridge to [bus 0c-0d]
 pci 0000:00:1c.4:   bridge window [io  0xc000-0xcfff]
 pci 0000:00:1c.4:   bridge window [mem 0xf1c00000-0xf1dfffff]
@@ -564,15 +568,16 @@ pci_bus 0000:00: resource 12 [mem 0xfed9
 pci_bus 0000:00: resource 13 [mem 0xfeda7000-0xfedfffff]
 pci_bus 0000:00: resource 14 [mem 0xfee10000-0xff9fffff]
 pci_bus 0000:00: resource 15 [mem 0xffc00000-0xffdfffff]
+pci_bus 0000:00: resource 16 [mem 0x120000000-0x317ffffff]
 pci_bus 0000:01: resource 0 [io  0xe000-0xefff]
 pci_bus 0000:01: resource 1 [mem 0xf2000000-0xf6efffff]
 pci_bus 0000:01: resource 2 [mem 0xe0000000-0xefffffff 64bit pref]
 pci_bus 0000:09: resource 0 [io  0xd000-0xdfff]
 pci_bus 0000:09: resource 1 [mem 0xf1f00000-0xf1ffffff]
-pci_bus 0000:09: resource 2 [mem 0xf0400000-0xf05fffff 64bit pref]
+pci_bus 0000:09: resource 2 [mem 0xf0200000-0xf03fffff 64bit pref]
 pci_bus 0000:0b: resource 0 [io  0x2000-0x2fff]
 pci_bus 0000:0b: resource 1 [mem 0xf1e00000-0xf1efffff]
-pci_bus 0000:0b: resource 2 [mem 0xf0200000-0xf03fffff 64bit pref]
+pci_bus 0000:0b: resource 2 [mem 0xf0400000-0xf05fffff 64bit pref]
 pci_bus 0000:0c: resource 0 [io  0xc000-0xcfff]
 pci_bus 0000:0c: resource 1 [mem 0xf1c00000-0xf1dfffff]
 pci_bus 0000:0c: resource 2 [mem 0xf0000000-0xf01fffff 64bit pref]
@@ -589,29 +594,29 @@ pci_bus 0000:03: resource 12 [mem 0xfed9
 pci_bus 0000:03: resource 13 [mem 0xfeda7000-0xfedfffff]
 pci_bus 0000:03: resource 14 [mem 0xfee10000-0xff9fffff]
 pci_bus 0000:03: resource 15 [mem 0xffc00000-0xffdfffff]
+pci_bus 0000:03: resource 16 [mem 0x120000000-0x317ffffff]
 NET: Registered protocol family 2
 IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
 TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
 TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
 TCP: Hash tables configured (established 131072 bind 65536)
-TCP reno registered
+TCP: reno registered
 UDP hash table entries: 512 (order: 2, 16384 bytes)
 UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
 NET: Registered protocol family 1
 pci 0000:01:00.0: Boot video device
 PCI: CLS 64 bytes, default 64
 Unpacking initramfs...
-Freeing initrd memory: 16680k freed
+Freeing initrd memory: 15656k freed
 Simple Boot Flag at 0x79 set to 0x1
 apm: BIOS not found.
-Intel AES-NI instructions are not detected.
 audit: initializing netlink socket (disabled)
-type=2000 audit(1333888166.549:1): initialized
+type=2000 audit(1341168880.516:1): initialized
 highmem bounce pool size: 64 pages
-HugeTLB registered 4 MB page size, pre-allocated 0 pages
+HugeTLB registered 2 MB page size, pre-allocated 0 pages
 VFS: Disk quotas dquot_6.5.2
 Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
-msgmni has been set to 1676
+msgmni has been set to 1660
 SELinux:  Registering netfilter hooks
 alg: No test for stdrng (krng)
 NET: Registered protocol family 38
@@ -626,14 +631,13 @@ pcieport 0000:00:1c.4: irq 43 for MSI/MS
 pci_hotplug: PCI Hot Plug PCI Core version: 0.5
 pciehp: PCI Express Hot Plug Controller Driver version: 0.4
 acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
-registered
-vesafb: mode is 1024x768x32, linelength=4096, pages=0
+acpiphp: Slot [1] registered
+vesafb: mode is 1440x900x32, linelength=5760, pages=0
 vesafb: scrolling: redraw
 vesafb: Truecolor: size=8:8:8:8, shift=24:16:8:0
-vesafb: framebuffer at 0xf3000000, mapped to 0xf7c80000, using 3072k, total 3072k
-Console: switching to colour frame buffer device 128x48
+vesafb: framebuffer at 0xf3000000, mapped to 0xf7e80000, using 5120k, total 5120k
+Console: switching to colour frame buffer device 180x56
 fb0: VESA VGA frame buffer device
-intel_idle: MWAIT substates: 0x3122220
 intel_idle: does not run on family 6 model 23
 ACPI: AC Adapter [AC] (off-line)
 input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input0
@@ -642,17 +646,15 @@ input: Power Button as /devices/LNXSYSTM
 ACPI: Power Button [PBTN]
 input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input2
 ACPI: Sleep Button [SBTN]
+ACPI: Requesting acpi_cpufreq
 Monitor-Mwait will be used to enter C-1 state
 Monitor-Mwait will be used to enter C-2 state
 Monitor-Mwait will be used to enter C-3 state
 Marking TSC unstable due to TSC halts in idle
 ACPI: acpi_idle registered with cpuidle
 thermal LNXTHERM:00: registered as thermal_zone0
-ACPI: Thermal Zone [THM] (32 C)
+ACPI: Thermal Zone [THM] (53 C)
 GHES: HEST is not enabled!
-isapnp: Scanning for PnP cards...
-(battery present)
-isapnp: No Plug & Play device found
 Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
 Non-volatile memory driver v1.3
 Linux agpgart interface v0.103
@@ -662,6 +664,7 @@ ahci 0000:00:1f.2: irq 44 for MSI/MSI-X
 ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 3 ports 3 Gbps 0x5 impl SATA mode
 ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part ccc ems 
 ahci 0000:00:1f.2: setting latency timer to 64
+ACPI: Battery Slot [BAT0] (battery present)
 scsi0 : ahci
 scsi1 : ahci
 scsi2 : ahci
@@ -687,7 +690,7 @@ ehci_hcd 0000:00:1a.7: USB 2.0 started, 
 usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
 usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
 usb usb1: Product: EHCI Host Controller
-usb usb1: Manufacturer: Linux 3.3.0-4.fc16.i686 ehci_hcd
+usb usb1: Manufacturer: Linux 3.4.3-1.fc17.i686.PAE ehci_hcd
 usb usb1: SerialNumber: 0000:00:1a.7
 hub 1-0:1.0: USB hub found
 hub 1-0:1.0: 4 ports detected
@@ -701,7 +704,7 @@ ehci_hcd 0000:00:1d.7: USB 2.0 started, 
 usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
 usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
 usb usb2: Product: EHCI Host Controller
-usb usb2: Manufacturer: Linux 3.3.0-4.fc16.i686 ehci_hcd
+usb usb2: Manufacturer: Linux 3.4.3-1.fc17.i686.PAE ehci_hcd
 usb usb2: SerialNumber: 0000:00:1d.7
 hub 2-0:1.0: USB hub found
 hub 2-0:1.0: 6 ports detected
@@ -714,7 +717,7 @@ uhci_hcd 0000:00:1a.0: irq 20, io base 0
 usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
 usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
 usb usb3: Product: UHCI Host Controller
-usb usb3: Manufacturer: Linux 3.3.0-4.fc16.i686 uhci_hcd
+usb usb3: Manufacturer: Linux 3.4.3-1.fc17.i686.PAE uhci_hcd
 usb usb3: SerialNumber: 0000:00:1a.0
 hub 3-0:1.0: USB hub found
 hub 3-0:1.0: 2 ports detected
@@ -725,7 +728,7 @@ uhci_hcd 0000:00:1a.1: irq 21, io base 0
 usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
 usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
 usb usb4: Product: UHCI Host Controller
-usb usb4: Manufacturer: Linux 3.3.0-4.fc16.i686 uhci_hcd
+usb usb4: Manufacturer: Linux 3.4.3-1.fc17.i686.PAE uhci_hcd
 usb usb4: SerialNumber: 0000:00:1a.1
 hub 4-0:1.0: USB hub found
 hub 4-0:1.0: 2 ports detected
@@ -736,7 +739,7 @@ uhci_hcd 0000:00:1d.0: irq 20, io base 0
 usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
 usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
 usb usb5: Product: UHCI Host Controller
-usb usb5: Manufacturer: Linux 3.3.0-4.fc16.i686 uhci_hcd
+usb usb5: Manufacturer: Linux 3.4.3-1.fc17.i686.PAE uhci_hcd
 usb usb5: SerialNumber: 0000:00:1d.0
 hub 5-0:1.0: USB hub found
 hub 5-0:1.0: 2 ports detected
@@ -747,7 +750,7 @@ uhci_hcd 0000:00:1d.1: irq 21, io base 0
 usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
 usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
 usb usb6: Product: UHCI Host Controller
-usb usb6: Manufacturer: Linux 3.3.0-4.fc16.i686 uhci_hcd
+usb usb6: Manufacturer: Linux 3.4.3-1.fc17.i686.PAE uhci_hcd
 usb usb6: SerialNumber: 0000:00:1d.1
 hub 6-0:1.0: USB hub found
 hub 6-0:1.0: 2 ports detected
@@ -758,13 +761,13 @@ uhci_hcd 0000:00:1d.2: irq 22, io base 0
 usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
 usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
 usb usb7: Product: UHCI Host Controller
-usb usb7: Manufacturer: Linux 3.3.0-4.fc16.i686 uhci_hcd
+usb usb7: Manufacturer: Linux 3.4.3-1.fc17.i686.PAE uhci_hcd
 usb usb7: SerialNumber: 0000:00:1d.2
 hub 7-0:1.0: USB hub found
 hub 7-0:1.0: 2 ports detected
 usbcore: registered new interface driver usbserial
-USB Serial support registered for generic
 usbcore: registered new interface driver usbserial_generic
+USB Serial support registered for generic
 usbserial: USB Serial Driver core
 i8042: PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
 serio: i8042 KBD port at 0x60,0x64 irq 1
@@ -781,7 +784,7 @@ EFI Variables Facility v0.08 2004-May-17
 usbcore: registered new interface driver usbhid
 usbhid: USB HID core driver
 ip_tables: (C) 2000-2006 Netfilter Core Team
-TCP cubic registered
+TCP: cubic registered
 Initializing XFRM netlink socket
 NET: Registered protocol family 10
 Mobile IPv6
@@ -790,56 +793,56 @@ Registering the dns_resolver key type
 Using IPI No-Shortcut mode
 PM: Hibernation image not present or could not be loaded.
 registered taskstats version 1
-  Magic number: 8:784:480
-rtc_cmos 00:04: setting system clock to 2012-04-08 12:29:28 UTC (1333888168)
+  Magic number: 4:879:947
+tty tty4: hash matches
+rtc_cmos 00:04: setting system clock to 2012-07-01 18:54:41 UTC (1341168881)
 Initializing network drop monitor service
 input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
 ata4.00: ATAPI: Optiarc DVD+/-RW AD-7640A, JD05, max UDMA/33
 ata4.00: configured for UDMA/33
 ata3: SATA link down (SStatus 0 SControl 300)
 ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
-ata1.00: ATA-7: ST9200420ASG, 3.ADD, max UDMA/133
-ata1.00: 390721968 sectors, multi 8: LBA48 NCQ (depth 31/32)
+ata1.00: ATA-9: OCZ-VERTEX4, 1.3, max UDMA/133
+ata1.00: 500118192 sectors, multi 8: LBA48 NCQ (depth 31/32), AA
 ata1.00: configured for UDMA/133
-scsi 0:0:0:0: Direct-Access     ATA      ST9200420ASG     3.AD PQ: 0 ANSI: 5
+scsi 0:0:0:0: Direct-Access     ATA      OCZ-VERTEX4      1.3  PQ: 0 ANSI: 5
+sd 0:0:0:0: [sda] 500118192 512-byte logical blocks: (256 GB/238 GiB)
 sd 0:0:0:0: Attached scsi generic sg0 type 0
-sd 0:0:0:0: [sda] 390721968 512-byte logical blocks: (200 GB/186 GiB)
 sd 0:0:0:0: [sda] Write Protect is off
 sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
 sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 scsi 3:0:0:0: CD-ROM            Optiarc  DVD+-RW AD-7640A JD05 PQ: 0 ANSI: 5
+ sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 >
 usb 1-1: new high-speed USB device number 2 using ehci_hcd
+sd 0:0:0:0: [sda] Attached SCSI disk
 sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda caddy
 cdrom: Uniform CD-ROM driver Revision: 3.20
 sr 3:0:0:0: Attached scsi CD-ROM sr0
 sr 3:0:0:0: Attached scsi generic sg1 type 5
- sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 sda9 >
-sd 0:0:0:0: [sda] Attached SCSI disk
-Freeing unused kernel memory: 620k freed
-Write protecting the kernel text: 5340k
-Write protecting the kernel read-only data: 2096k
+Freeing unused kernel memory: 640k freed
+Write protecting the kernel text: 5444k
+Write protecting the kernel read-only data: 2140k
+NX-protecting the kernel data: 4796k
+dracut: dracut-018-40.git20120522.fc17
 usb 1-1: New USB device found, idVendor=05a9, idProduct=2640
 usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
 usb 1-1: Product: Laptop Integrated Webcam
 usb 1-1: Manufacturer: OmniVision Technologies, Inc. -2640-07.07.20.3
-dracut: dracut-013-20.fc16
 dracut: rd.luks=0: removing cryptoluks activation
-dracut: rd.lvm=0: removing LVM activation
-udevd[111]: starting version 173
-wmi: Mapper loaded
+udevd[111]: starting version 182
+[drm] Initialized drm 1.1.0 20060810
 acpi device:31: registered as cooling_device2
 input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A03:00/device:2e/LNXVIDEO:00/input/input4
 ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
-[drm] Initialized drm 1.1.0 20060810
-VGA switcheroo: detected Optimus DSM method \ handle
+wmi: Mapper loaded
 [drm] nouveau 0000:01:00.0: Detected an NV50 generation card (0x084700a2)
-checking generic (f3000000 300000) vs hw (e0000000 10000000)
-checking generic (f3000000 300000) vs hw (f2000000 2000000)
+checking generic (f3000000 500000) vs hw (e0000000 10000000)
+checking generic (f3000000 500000) vs hw (f2000000 2000000)
 fb: conflicting fb hw usage nouveaufb vs VESA VGA - removing generic driver
 Console: switching to colour dummy device 80x25
-[drm] nouveau 0000:01:00.0: Attempting to load BIOS image from PRAMIN
-usb 2-2: new high-speed USB device number 3 using ehci_hcd
+[drm] nouveau 0000:01:00.0: Checking PRAMIN for VBIOS
 [drm] nouveau 0000:01:00.0: ... appears to be valid
+[drm] nouveau 0000:01:00.0: Using VBIOS from PRAMIN
 [drm] nouveau 0000:01:00.0: BIT BIOS found
 [drm] nouveau 0000:01:00.0: Bios version 60.84.5e.00
 [drm] nouveau 0000:01:00.0: TMDS table version 2.0
@@ -859,27 +862,14 @@ usb 2-2: new high-speed USB device numbe
 [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 1 at offset 0xCB78
 [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 2 at offset 0xD5C8
 [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 3 at offset 0xD6BA
-usb 2-2: New USB device found, idVendor=0bb4, idProduct=0c99
-usb 2-2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
-usb 2-2: Product: Android Phone
 [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 4 at offset 0xD8ED
 [drm] nouveau 0000:01:00.0: Parsing VBIOS init table at offset 0xD952
-usb 2-2: Manufacturer: HTC
-usb 2-2: SerialNumber: HT999L903452
 [drm] nouveau 0000:01:00.0: 0xD952: Condition still not met after 20ms, skipping following opcodes
-Initializing USB Mass Storage driver...
-scsi5 : usb-storage 2-2:1.0
-[drm] nouveau 0000:01:00.0: 3 available performance level(s)
-[drm] nouveau 0000:01:00.0: 0: core 169MHz shader 338MHz memory 100MHz timing 0 voltage 1150mV fanspeed 100%
-[drm] nouveau 0000:01:00.0: 1: core 275MHz shader 550MHz memory 301MHz timing 1 voltage 1150mV fanspeed 100%
-[drm] nouveau 0000:01:00.0: 2: core 475MHz shader 950MHz memory 702MHz timing 2 voltage 1200mV fanspeed 100%
-[drm] nouveau 0000:01:00.0: c: core 275MHz shader 550MHz memory 302MHz voltage 1150mV
-usbcore: registered new interface driver usb-storage
-USB Mass Storage support registered.
-[TTM] Zone  kernel: Available graphics memory: 429556 kiB.
-[TTM] Zone highmem: Available graphics memory: 1811164 kiB.
-[TTM] Initializing pool allocator.
-[drm] nouveau 0000:01:00.0: Detected 256MiB VRAM
+[TTM] Zone  kernel: Available graphics memory: 425282 kiB
+[TTM] Zone highmem: Available graphics memory: 2068010 kiB
+[TTM] Initializing pool allocator
+[TTM] Initializing DMA pool allocator
+[drm] nouveau 0000:01:00.0: Detected 256MiB VRAM (GDDR3)
 mtrr: type mismatch for e0000000,10000000 old: write-back new: write-combining
 [drm] nouveau 0000:01:00.0: 512 MiB GART (aperture)
 [drm] nouveau 0000:01:00.0: DCB encoder 1 unknown
@@ -887,6 +877,11 @@ mtrr: type mismatch for e0000000,1000000
 [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
 [drm] No driver support for vblank timestamp query.
 [drm] nouveau 0000:01:00.0: ACPI backlight interface available, not registering our own
+[drm] nouveau 0000:01:00.0: 3 available performance level(s)
+[drm] nouveau 0000:01:00.0: 0: core 169MHz shader 338MHz memory 100MHz voltage 1150mV fanspeed 100%
+[drm] nouveau 0000:01:00.0: 1: core 275MHz shader 550MHz memory 301MHz voltage 1150mV fanspeed 100%
+[drm] nouveau 0000:01:00.0: 2: core 475MHz shader 950MHz memory 702MHz voltage 1200mV fanspeed 100%
+[drm] nouveau 0000:01:00.0: c: core 275MHz shader 550MHz memory 302MHz voltage 1150mV
 input: PS/2 Mouse as /devices/platform/i8042/serio1/input/input5
 input: AlpsPS/2 ALPS GlidePoint as /devices/platform/i8042/serio1/input/input6
 usb 3-2: new full-speed USB device number 2 using uhci_hcd
@@ -903,66 +898,58 @@ input: A4Tech USB Full Speed as /devices
 generic-usb 0003:09DA:8090.0001: input,hidraw0: USB HID v1.11 Mouse [A4Tech USB Full Speed] on usb-0000:00:1d.0-1/input0
 input: A4Tech USB Full Speed as /devices/pci0000:00/0000:00:1d.0/usb5/5-1/5-1:1.1/input/input8
 generic-usb 0003:09DA:8090.0002: input,hiddev0,hidraw1: USB HID v1.11 Keyboard [A4Tech USB Full Speed] on usb-0000:00:1d.0-1/input1
-scsi 5:0:0:0: Direct-Access     HTC      Android Phone    0100 PQ: 0 ANSI: 2
-sd 5:0:0:0: Attached scsi generic sg2 type 0
-sd 5:0:0:0: [sdb] Attached SCSI removable disk
-usb 6-1: new full-speed USB device number 2 using uhci_hcd
-usb 6-1: New USB device found, idVendor=054c, idProduct=03d5
-usb 6-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
-usb 6-1: Product: Motion Controller
-usb 6-1: Manufacturer: Sony Computer Entertainment
-input: Sony Computer Entertainment Motion Controller as /devices/pci0000:00/0000:00:1d.1/usb6/6-1/6-1:1.0/input/input9
-generic-usb 0003:054C:03D5.0003: input,hiddev0,hidraw2: USB HID v1.10 Gamepad [Sony Computer Entertainment Motion Controller] on usb-0000:00:1d.1-1/input0
-composite sync not supported
-[drm] nouveau 0000:01:00.0: allocated 1440x900 fb: 0x320000, bo f28cf600
-fbcon: nouveaufb (fb0) is primary device
-Console: switching to colour frame buffer device 180x56
-fb0: nouveaufb frame buffer device
-drm: registered panic notifier
-[drm] Initialized nouveau 0.0.16 20090420 for 0000:01:00.0 on minor 0
-dracut: Starting plymouth daemon
 usb 7-2: new full-speed USB device number 2 using uhci_hcd
-composite sync not supported
-dracut: rd.dm=0: removing DM RAID activation
 usb 7-2: New USB device found, idVendor=0a5c, idProduct=4500
 usb 7-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
 usb 7-2: Product: BCM2045B2
 usb 7-2: Manufacturer: Broadcom
-dracut: rd.md=0: removing MD RAID activation
 hub 7-2:1.0: USB hub found
 hub 7-2:1.0: 3 ports detected
-sdhci: Secure Digital Host Controller Interface driver
-sdhci: Copyright(c) Pierre Ossman
-(rev 22)
-Registered led device: mmc0::
-using DMA
-firewire_ohci: Added fw-ohci device 0000:03:09.0, OHCI v1.10, 4 IR + 4 IT contexts, quirks 0x11
+composite sync not supported
 usb 7-2.2: new full-speed USB device number 3 using uhci_hcd
+[drm] nouveau 0000:01:00.0: allocated 1440x900 fb: 0x320000, bo f6c97e00
+fbcon: nouveaufb (fb0) is primary device
+Console: switching to colour frame buffer device 180x56
+fb0: nouveaufb frame buffer device
+drm: registered panic notifier
+[drm] Initialized nouveau 1.0.0 20120316 for 0000:01:00.0 on minor 0
+dracut: Starting plymouth daemon
 usb 7-2.2: New USB device found, idVendor=0a5c, idProduct=4502
 usb 7-2.2: New USB device strings: Mfr=1, Product=0, SerialNumber=0
 usb 7-2.2: Manufacturer: Broadcom Corp
-input: Broadcom Corp as /devices/pci0000:00/0000:00:1d.2/usb7/7-2/7-2.2/7-2.2:1.0/input/input10
-generic-usb 0003:0A5C:4502.0004: input,hidraw3: USB HID v1.11 Keyboard [Broadcom Corp] on usb-0000:00:1d.2-2.2/input0
+input: Broadcom Corp as /devices/pci0000:00/0000:00:1d.2/usb7/7-2/7-2.2/7-2.2:1.0/input/input9
+generic-usb 0003:0A5C:4502.0003: input,hidraw2: USB HID v1.11 Keyboard [Broadcom Corp] on usb-0000:00:1d.2-2.2/input0
+composite sync not supported
 usb 7-2.3: new full-speed USB device number 4 using uhci_hcd
-firewire_core: created device fw0: GUID 334fc0001cece070, S400
 usb 7-2.3: New USB device found, idVendor=0a5c, idProduct=4503
 usb 7-2.3: New USB device strings: Mfr=1, Product=0, SerialNumber=0
 usb 7-2.3: Manufacturer: Broadcom Corp
-input: Broadcom Corp as /devices/pci0000:00/0000:00:1d.2/usb7/7-2/7-2.3/7-2.3:1.0/input/input11
-generic-usb 0003:0A5C:4503.0005: input,hidraw4: USB HID v1.11 Mouse [Broadcom Corp] on usb-0000:00:1d.2-2.3/input0
-EXT4-fs (sda7): mounted filesystem with ordered data mode. Opts: (null)
-dracut: Checking ext4: /dev/disk/by-uuid/7417d839-a647-466e-b57d-fc65d20a6342
-dracut: issuing e2fsck -a  /dev/disk/by-uuid/7417d839-a647-466e-b57d-fc65d20a6342
-dracut: _Fedora-16-i686-: clean, 238747/901120 files, 1776110/3584000 blocks
-dracut: Remounting /dev/disk/by-uuid/7417d839-a647-466e-b57d-fc65d20a6342 with -o ro
-EXT4-fs (sda7): mounted filesystem with ordered data mode. Opts: (null)
-dracut: Mounted root filesystem /dev/sda7
+input: Broadcom Corp as /devices/pci0000:00/0000:00:1d.2/usb7/7-2/7-2.3/7-2.3:1.0/input/input10
+generic-usb 0003:0A5C:4503.0004: input,hidraw3: USB HID v1.11 Mouse [Broadcom Corp] on usb-0000:00:1d.2-2.3/input0
+dracut: rd.dm=0: removing DM RAID activation
+dracut: rd.md=0: removing MD RAID activation
+sdhci: Secure Digital Host Controller Interface driver
+sdhci: Copyright(c) Pierre Ossman
+firewire_ohci 0000:03:09.0: added OHCI v1.10 device as card 0, 4 IR + 4 IT contexts, quirks 0x11
+sdhci-pci 0000:03:09.1: SDHCI controller found [1180:0822] (rev 22)
+Registered led device: mmc0::
+mmc0: SDHCI controller on PCI [0000:03:09.1] using DMA
+EXT4-fs (sda6): mounted filesystem with ordered data mode. Opts: (null)
+dracut: Checking ext4: /dev/disk/by-uuid/29c27e52-ab08-4c1a-9ed7-86ab260b207b
+dracut: issuing e2fsck -a  /dev/disk/by-uuid/29c27e52-ab08-4c1a-9ed7-86ab260b207b
+dracut: /dev/disk/by-uuid/29c27e52-ab08-4c1a-9ed7-86ab260b207b: clean, 275331/983040 files, 2231118/3932160 blocks
+dracut: Remounting /dev/disk/by-uuid/29c27e52-ab08-4c1a-9ed7-86ab260b207b with -o ro
+EXT4-fs (sda6): mounted filesystem with ordered data mode. Opts: (null)
+dracut: Mounted root filesystem /dev/sda6
 dracut: Switching root
-type=1404 audit(1333888173.684:2): enforcing=1 old_enforcing=0 auid=4294967295 ses=4294967295
-SELinux: 2048 avtab hash slots, 97362 rules.
-SELinux: 2048 avtab hash slots, 97362 rules.
-SELinux:  9 users, 13 roles, 3912 types, 215 bools, 1 sens, 1024 cats
-SELinux:  82 classes, 97362 rules
+type=1404 audit(1341168884.696:2): enforcing=1 old_enforcing=0 auid=4294967295 ses=4294967295
+firewire_core 0000:03:09.0: created device fw0: GUID 334fc0001cece070, S400
+SELinux: 2048 avtab hash slots, 100708 rules.
+SELinux: 2048 avtab hash slots, 100708 rules.
+SELinux:  9 users, 15 roles, 4148 types, 223 bools, 1 sens, 1024 cats
+SELinux:  83 classes, 100708 rules
+SELinux:  Permission ptrace_child in class process not defined in policy.
+SELinux: the above unknown classes and permissions will be allowed
 SELinux:  Completing initialization.
 SELinux:  Setting up existing superblocks.
 SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
@@ -979,18 +966,17 @@ SELinux: initialized (dev devpts, type d
 SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses transition SIDs
 SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
 SELinux: initialized (dev selinuxfs, type selinuxfs), uses genfs_contexts
-SELinux: initialized (dev usbfs, type usbfs), uses genfs_contexts
 SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
 SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
 SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
-SELinux: initialized (dev sda7, type ext4), uses xattr
-type=1403 audit(1333888173.953:3): policy loaded auid=4294967295 ses=4294967295
-systemd[1]: Successfully loaded SELinux policy in 347ms 981us.
-systemd[1]: Successfully loaded SELinux database in 54ms 927us, size on heap is 365K.
+SELinux: initialized (dev sda6, type ext4), uses xattr
+SELinux: initialized (dev securityfs, type securityfs), uses genfs_contexts
+type=1403 audit(1341168885.034:3): policy loaded auid=4294967295 ses=4294967295
+systemd[1]: Successfully loaded SELinux policy in 354ms 350us.
 systemd[1]: RTC configured in localtime, applying delta of 60 minutes to system time.
 SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
 SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
-systemd[1]: Relabelled /dev and /run in 42ms 476us.
+systemd[1]: Relabelled /dev and /run in 44ms 145us.
 SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
 SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
 SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
@@ -999,62 +985,51 @@ SELinux: initialized (dev cgroup, type c
 SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
 SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
 SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
-systemd[1]: systemd 37 running in system mode. (+PAM +LIBWRAP +AUDIT +SELINUX +SYSVINIT +LIBCRYPTSETUP; fedora)
+systemd[1]: systemd 44 running in system mode. (+PAM +LIBWRAP +AUDIT +SELINUX +IMA +SYSVINIT +LIBCRYPTSETUP; fedora)
 systemd[1]: Set hostname to <xps>.
 SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
-udevd[521]: starting version 173
-udevd[521]: specified group 'plugdev' unknown
-SELinux: initialized (dev configfs, type configfs), uses genfs_contexts
 SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
-SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses transition SIDs
-SELinux: initialized (dev securityfs, type securityfs), uses genfs_contexts
-EXT4-fs (sda7): re-mounted. Opts: (null)
-RPC: Registered named UNIX socket transport module.
-RPC: Registered udp transport module.
-RPC: Registered tcp transport module.
-RPC: Registered tcp NFSv4.1 backchannel transport module.
-SELinux: initialized (dev rpc_pipefs, type rpc_pipefs), uses genfs_contexts
-SELinux: initialized (dev binfmt_misc, type binfmt_misc), uses genfs_contexts
+systemd-journald[309]: Fixed max_use=201.9M max_size=25.2M min_size=64.0K keep_free=100.9M
+systemd-journald[309]: Vacuuming...
+udevd[307]: starting version 182
+EXT4-fs (sda6): re-mounted. Opts: (null)
 sky2: driver version 1.30
 sky2 0000:09:00.0: Yukon-2 FE+ chip revision 0
 sky2 0000:09:00.0: irq 45 for MSI/MSI-X
 sky2 0000:09:00.0: eth0: addr 00:21:9b:cd:55:50
 cfg80211: Calling CRDA to update world regulatory domain
-iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for Linux, in-tree:ds
-iwl3945: Copyright(c) 2003-2011 Intel Corporation
-iwl3945 0000:0b:00.0: enabling device (0000 -> 0002)
-iwl3945 0000:0b:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
 iTCO_vendor_support: vendor-support=0
-iwl3945 0000:0b:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
-iwl3945 0000:0b:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
-iwl3945 0000:0b:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
-iwl3945 0000:0b:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
-iwl3945 0000:0b:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
-iwl3945 0000:0b:00.0: bad EEPROM signature,EEPROM_GP=0x00000007
-iwl3945 0000:0b:00.0: EEPROM not found, EEPROM_GP=0xffffffff
-iwl3945 0000:0b:00.0: Unable to init EEPROM
 iTCO_wdt: Intel TCO WatchDog Timer Driver v1.07
 iTCO_wdt: Found a ICH8M TCO device (Version=2, TCOBASE=0x1060)
 iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
-iwl3945: probe of 0000:0b:00.0 failed with error -2
-microcode: CPU0 sig=0x10676, pf=0x80, revision=0x60c
+Linux media interface: v0.10
+Linux video capture interface: v2.00
+snd_hda_intel 0000:00:1b.0: irq 46 for MSI/MSI-X
 r592: driver successfully loaded
-mtp-probe[674]: checking bus 6, device 2: "/sys/devices/pci0000:00/0000:00:1d.1/usb6/6-1"
-mtp-probe[724]: checking bus 7, device 3: "/sys/devices/pci0000:00/0000:00:1d.2/usb7/7-2/7-2.2"
-mtp-probe[670]: checking bus 5, device 2: "/sys/devices/pci0000:00/0000:00:1d.0/usb5/5-1"
-mtp-probe[691]: checking bus 2, device 3: "/sys/devices/pci0000:00/0000:00:1d.7/usb2/2-2"
-mtp-probe[684]: checking bus 1, device 2: "/sys/devices/pci0000:00/0000:00:1a.7/usb1/1-1"
-mtp-probe[650]: checking bus 3, device 2: "/sys/devices/pci0000:00/0000:00:1a.0/usb3/3-2"
-mtp-probe[730]: checking bus 7, device 4: "/sys/devices/pci0000:00/0000:00:1d.2/usb7/7-2/7-2.3"
-mtp-probe[691]: bus: 2, device: 3 was not an MTP device
-mtp-probe[724]: bus: 7, device: 3 was not an MTP device
-mtp-probe[670]: bus: 5, device: 2 was not an MTP device
-mtp-probe[684]: bus: 1, device: 2 was not an MTP device
-mtp-probe[674]: bus: 6, device: 2 was not an MTP device
-mtp-probe[730]: bus: 7, device: 4 was not an MTP device
-mtp-probe[650]: bus: 3, device: 2 was not an MTP device
+uvcvideo: Found UVC 1.00 device Laptop Integrated Webcam (05a9:2640)
+input: Laptop Integrated Webcam as /devices/pci0000:00/0000:00:1a.7/usb1/1-1/1-1:1.0/input/input11
+usbcore: registered new interface driver uvcvideo
+USB Video Class driver (1.1.1)
+ALSA sound/pci/hda/hda_codec.c:5099 autoconfig: line_outs=1 (0xd/0x0/0x0/0x0/0x0) type:speaker
+ALSA sound/pci/hda/hda_codec.c:5103    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
+ALSA sound/pci/hda/hda_codec.c:5107    hp_outs=2 (0xa/0xf/0x0/0x0/0x0)
+ALSA sound/pci/hda/hda_codec.c:5108    mono: mono_out=0x0
+ALSA sound/pci/hda/hda_codec.c:5111    dig-out=0x21/0x0
+ALSA sound/pci/hda/hda_codec.c:5112    inputs:
+ALSA sound/pci/hda/hda_codec.c:5116  Internal Mic=0xc
+ALSA sound/pci/hda/hda_codec.c:5116  Mic=0xe
+ALSA sound/pci/hda/hda_codec.c:5118 
+ALSA sound/pci/hda/patch_sigmatel.c:3111 stac92xx: dac_nids=2 (0x2/0x5/0x0/0x0/0x0)
+iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for Linux, in-tree:ds
+iwl3945: Copyright(c) 2003-2011 Intel Corporation
+microcode: CPU0 sig=0x10676, pf=0x80, revision=0x60c
+iwl3945 0000:0b:00.0: Tunable channels: 13 802.11bg, 23 802.11a channels
+iwl3945 0000:0b:00.0: Detected Intel Wireless WiFi Link 3945ABG
+iwl3945 0000:0b:00.0: irq 47 for MSI/MSI-X
+Registered led device: phy0-led
+ieee80211 phy0: Selected rate control algorithm 'iwl-3945-rs'
 dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
-r852: driver loaded successfully
+input: Dell WMI hotkeys as /devices/virtual/input/input12
 cfg80211: World regulatory domain updated:
 cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
 cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
@@ -1062,103 +1037,54 @@ cfg80211:   (2457000 KHz - 2482000 KHz @
 cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
 cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
 cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
+Adding 4930552k swap on /dev/sda8.  Priority:0 extents:1 across:4930552k SS
 microcode: CPU0 updated to revision 0x60f, date = 2010-09-29
 microcode: CPU1 sig=0x10676, pf=0x80, revision=0x60c
+fuse init (API version 7.18)
+udevd[326]: renamed network interface eth0 to p2p1
 microcode: CPU1 updated to revision 0x60f, date = 2010-09-29
 microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
-Linux media interface: v0.10
-Linux video capture interface: v2.00
-input: Dell WMI hotkeys as /devices/virtual/input/input12
-snd_hda_intel 0000:00:1b.0: irq 46 for MSI/MSI-X
-uvcvideo: Found UVC 1.00 device Laptop Integrated Webcam (05a9:2640)
-uvcvideo: UVC non compliance - GET_DEF(PROBE) not supported. Enabling workaround.
-input: Laptop Integrated Webcam as /devices/pci0000:00/0000:00:1a.7/usb1/1-1/1-1:1.0/input/input13
-usbcore: registered new interface driver uvcvideo
-USB Video Class driver (1.1.1)
-ALSA sound/pci/hda/hda_codec.c:4927 autoconfig: line_outs=1 (0xd/0x0/0x0/0x0/0x0) type:speaker
-ALSA sound/pci/hda/hda_codec.c:4931    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
-ALSA sound/pci/hda/hda_codec.c:4935    hp_outs=2 (0xa/0xf/0x0/0x0/0x0)
-ALSA sound/pci/hda/hda_codec.c:4936    mono: mono_out=0x0
-ALSA sound/pci/hda/hda_codec.c:4939    dig-out=0x21/0x0
-ALSA sound/pci/hda/hda_codec.c:4940    inputs:
-ALSA sound/pci/hda/hda_codec.c:4944  Internal Mic=0xc
-ALSA sound/pci/hda/hda_codec.c:4944  Mic=0xe
-ALSA sound/pci/hda/hda_codec.c:4946 
-ALSA sound/pci/hda/patch_sigmatel.c:3090 stac92xx: dac_nids=2 (0x2/0x5/0x0/0x0/0x0)
-udevd[609]: renamed network interface eth0 to p2p1
-fuse init (API version 7.18)
 SELinux: initialized (dev fusectl, type fusectl), uses genfs_contexts
-mount[900]: mount: fusectl already mounted or /sys/fs/fuse/connections busy
-mount[900]: mount: according to mtab, fusectl is already mounted on /sys/fs/fuse/connections
-systemd[1]: sys-fs-fuse-connections.mount mount process exited, code=exited status=32
-Adding 2047996k swap on /dev/sda8.  Priority:0 extents:1 across:2047996k 
-systemd-fsck[893]: /dev/sda5: clean, 281/76304 files, 117477/304216 blocks
-SELinux: initialized (dev sda3, type fuseblk), uses genfs_contexts
-ntfs-3g[923]: Version 2011.4.12 integrated FUSE 27
-ntfs-3g[923]: Mounted /dev/sda3 (Read-Write, label "", NTFS 3.1)
-ntfs-3g[923]: Cmdline options: rw
-ntfs-3g[923]: Mount options: rw,allow_other,nonempty,atime,fsname=/dev/sda3,blkdev,blksize=4096
-ntfs-3g[923]: Ownership and permissions disabled, configuration type 1
-fedora-storage-init[912]: Setting up Logical Volume Management:   No volume groups found
-fedora-storage-init[912]: [  OK  ]
+cfg80211: Calling CRDA for country: GB
+cfg80211: Regulatory domain changed to country: GB
+cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
+cfg80211:   (2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
+cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
+cfg80211:   (5250000 KHz - 5330000 KHz @ 40000 KHz), (N/A, 2000 mBm)
+cfg80211:   (5490000 KHz - 5710000 KHz @ 40000 KHz), (N/A, 2700 mBm)
+SELinux: initialized (dev sda2, type fuseblk), uses genfs_contexts
 EXT4-fs (sda5): mounted filesystem with ordered data mode. Opts: (null)
 SELinux: initialized (dev sda5, type ext4), uses xattr
-fedora-storage-init[925]: Setting up Logical Volume Management:   No volume groups found
-fedora-storage-init[925]: [  OK  ]
-systemd-fsck[903]: /home: clean, 1056585/5799936 files, 19080578/23175424 blocks
-lvm[935]: No volume groups found
-EXT4-fs (sda6): mounting ext3 file system using the ext4 subsystem
-EXT4-fs (sda6): mounted filesystem with ordered data mode. Opts: (null)
-SELinux: initialized (dev sda6, type ext3), uses xattr
-EXT4-fs (sda9): warning: maximal mount count reached, running e2fsck is recommended
-EXT4-fs (sda9): mounted filesystem with ordered data mode. Opts: (null)
-SELinux: initialized (dev sda9, type ext4), uses xattr
-systemd-tmpfiles[951]: Successfully loaded SELinux database in 13ms 399us, size on heap is 366K.
+EXT4-fs (sda7): mounted filesystem with ordered data mode. Opts: (null)
+SELinux: initialized (dev sda7, type ext4), uses xattr
 nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
-auditd[965]: Started dispatcher: /sbin/audispd pid: 990
-iptables.init[959]: iptables: Applying firewall rules: [  OK  ]
-audispd[990]: priority_boost_parser called with: 4
-audispd[990]: max_restarts_parser called with: 10
-audispd[990]: audispd initialized with q_depth=120 and 1 active plugins
-ip6_tables: (C) 2000-2006 Netfilter Core Team
-ip6tables.init[960]: ip6tables: Applying firewall rules: [  OK  ]
-NetworkManager[1003]: <info> NetworkManager (version 0.9.2-1.fc16) is starting...
-NetworkManager[1003]: <info> Read config file /etc/NetworkManager/NetworkManager.conf
-NetworkManager[1003]: NetworkManager[1003]: <info> NetworkManager (version 0.9.2-1.fc16) is starting...
-NetworkManager[1003]: NetworkManager[1003]: <info> Read config file /etc/NetworkManager/NetworkManager.conf
-mcelog[996]: mcelog read: No such device
-auditctl[973]: No rules
-auditctl[973]: AUDIT_STATUS: enabled=0 flag=1 pid=965 rate_limit=0 backlog_limit=320 lost=0 backlog=0
-abrtd[1011]: Init complete, entering main loop
-acpid[1026]: starting up with netlink and the input layer
-acpid[1026]: skipping incomplete file /etc/acpi/events/videoconf
-acpid[1026]: 1 rule loaded
-acpid[1026]: waiting for events: event logging is off
-avahi-daemon[1025]: Found user 'avahi' (UID 70) and group 'avahi' (GID 70).
-avahi-daemon[1025]: Successfully dropped root privileges.
-avahi-daemon[1025]: avahi-daemon 0.6.30 starting up.
-auditd[965]: Init complete, auditd 2.1.3 listening for events (startup state enable)
-Loading iSCSI transport class v2.0-870.
-iscsi: registered transport (tcp)
-iscsi: registered transport (iser)
-libcxgbi:libcxgbi_init_module: tag itt 0x1fff, 13 bits, age 0xf, 4 bits.
-libcxgbi:ddp_setup_host_page_size: system PAGE 4096, ddp idx 0.
-Chelsio T3 iSCSI Driver cxgb3i v2.0.0 (Jun. 2010)
-iscsi: registered transport (cxgb3i)
-Chelsio T4 iSCSI Driver cxgb4i v0.9.1 (Aug. 2010)
-iscsi: registered transport (cxgb4i)
-cnic: Broadcom NetXtreme II CNIC Driver cnic v2.5.8 (Jan 3, 2012)
-Broadcom NetXtreme II iSCSI Driver bnx2i v2.7.0.3 (Jun 15, 2011)
-iscsi: registered transport (bnx2i)
-iscsi: registered transport (be2iscsi)
 sky2 0000:09:00.0: p2p1: enabling interface
 ADDRCONF(NETDEV_UP): p2p1: link is not ready
-8021q: 802.1Q VLAN Support v1.8
-netlink: 12 bytes leftover after parsing attributes.
-netlink: 12 bytes leftover after parsing attributes.
-netlink: 12 bytes leftover after parsing attributes.
+RPC: Registered named UNIX socket transport module.
+RPC: Registered udp transport module.
+RPC: Registered tcp transport module.
+RPC: Registered tcp NFSv4.1 backchannel transport module.
+iwl3945 0000:0b:00.0: loaded firmware version 15.32.2.9
+Bluetooth: Core ver 2.16
+NET: Registered protocol family 31
+Bluetooth: HCI device and connection manager initialized
+Bluetooth: HCI socket layer initialized
+Bluetooth: L2CAP socket layer initialized
+Bluetooth: SCO socket layer initialized
+Bluetooth: BNEP (Ethernet Emulation) ver 1.3
+Bluetooth: BNEP filters: protocol multicast
+ADDRCONF(NETDEV_UP): wlan0: link is not ready
+ip6_tables: (C) 2000-2006 Netfilter Core Team
 composite sync not supported
 composite sync not supported
+SELinux: initialized (dev fuse, type fuse), uses genfs_contexts
 composite sync not supported
+wlan0: authenticate with 80:b6:86:6b:2f:d8
+wlan0: send auth to 80:b6:86:6b:2f:d8 (try 1/3)
+wlan0: authenticated
+wlan0: associate with 80:b6:86:6b:2f:d8 (try 1/3)
+wlan0: RX AssocResp from 80:b6:86:6b:2f:d8 (capab=0x411 status=0 aid=2)
+wlan0: associated
+ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
 composite sync not supported
-hda-intel: IRQ timing workaround is activated for card #0. Suggest a bigger bdl_pos_adj.
+wlan0: no IPv6 routers present

