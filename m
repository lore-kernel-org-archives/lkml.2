Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933099Ab2GBUtK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 16:49:10 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:34649 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932078Ab2GBUtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 16:49:04 -0400
MIME-Version: 1.0
In-Reply-To: <20120702053110.GA2500@redhat.com>
References: <CANHD2=rF6dBkLLkWAj8uS3nq0B1wCt7Uvu=HzO84UNz2kuiaFg@mail.gmail.com>
	<20120313081235.GC15333@redhat.com>
	<CAErSpo6t-cVBdJfyARi3ifEuBUvopbG5GQSP5YywrvumDK8HFA@mail.gmail.com>
	<CANHD2=qSWRv76mjwhTNMgO=u5yYCh2QZzxbNLNaPWm1d52FtOg@mail.gmail.com>
	<20120528140448.GA22783@redhat.com>
	<CAErSpo6XVgzeQiWjXJs6vxdQ5_O7LFG-j4p=4S7rQSyBdq7-SA@mail.gmail.com>
	<20120529092154.GA2441@redhat.com>
	<CAErSpo6Xxq_kcEYACKUsuNDOJDhEDnxWgBUateOJEBcfqufhSg@mail.gmail.com>
	<CANHD2=o-eyd2JR7oK4gJgQi3Mi-a=R1RKuGsuWzzR_WosQaNEA@mail.gmail.com>
	<20120702053110.GA2500@redhat.com>
Date: Mon, 2 Jul 2012 21:49:02 +0100
Message-ID: <CANHD2=pEham5SZ6EguurMd9MBuyptyx5CGF1RDhU8Ow9CaRoXA@mail.gmail.com>
Subject: Re: Initializing iwl3945 error
From: Kamil Grzebien <ciptok@gmail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Content-Type: multipart/mixed; boundary=14dae9340c418eea6604c3deedb3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--14dae9340c418eea6604c3deedb3
Content-Type: text/plain; charset=ISO-8859-1

On Mon, Jul 2, 2012 at 6:31 AM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> On Sun, Jul 01, 2012 at 07:01:58PM +0100, Kamil Grzebien wrote:
>> I haven't tried your patch yet, but wanted to share with one thing.
>> Currently I use new kernel 3.4.3, where the problem doesn't exist
>> anymore. However I still would like to know what was the cause and
>> which change brought the solution. Is there anything which comes to
>> your mind in terms of recent changes in kernel? I also added logs from
>> the newest kernel, so it might be easier for track it.
>
> Below is the diff from working kernel and non working kernel.
> You are using PAE kernel what influence PCI mappings. Is this fixed also
> on 3.4 non-PAE kernel?

The problem is also fixed in non-PAE kernel. I've attached the logs
from that kernel also. Besides that currently I was comparing both PAE
kernels installed on my machine - kernel 3.3.7 (problem exist) and
kernel 3.4.3 (problem solved). There must be something that has
changed either in the code or maybe kernel configuration!?

Regards,
Kamil

>
> Stanislaw
>
> --- bad/dmesg.log       2012-05-28 15:12:13.559424823 +0200
> +++ dmesg.log   2012-07-02 07:22:35.534393336 +0200
> @@ -1,6 +1,6 @@
>  Initializing cgroup subsys cpuset
>  Initializing cgroup subsys cpu
> -Linux version 3.3.0-4.fc16.i686 (mockbuild@x86-04.phx2.fedoraproject.org) (gcc version 4.6.2 20111027 (Red Hat 4.6.2-1) (GCC) ) #1 SMP Tue Mar 20 18:45:14 UTC 2012
> +Linux version 3.4.3-1.fc17.i686.PAE (mockbuild@x86-04.phx2.fedoraproject.org) (gcc version 4.7.0 20120507 (Red Hat 4.7.0-5) (GCC) ) #1 SMP Mon Jun 18 20:31:39 UTC 2012
>  BIOS-provided physical RAM map:
>   BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
>   BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
> @@ -14,12 +14,12 @@ BIOS-provided physical RAM map:
>   BIOS-e820: 00000000fee00000 - 00000000fee10000 (reserved)
>   BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
>   BIOS-e820: 0000000100000000 - 0000000120000000 (usable)
> -Notice: NX (Execute Disable) protection cannot be enabled: non-PAE kernel!
> +NX (Execute Disable) protection: active
>  DMI 2.4 present.
>  DMI: Dell Inc. XPS M1530                       /0D501F, BIOS A12 11/19/2008
>  e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
>  e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
> -last_pfn = 0xdfe72 max_arch_pfn = 0x100000
> +last_pfn = 0x120000 max_arch_pfn = 0x1000000
>  MTRR default type: uncachable
>  MTRR fixed ranges enabled:
>    00000-9FFFF write-back
> @@ -52,14 +52,14 @@ reg 1, base: 3583MB, range: 1MB, type UC
>  reg 2, base: 3584MB, range: 512MB, type UC
>  reg 3, base: 4GB, range: 512MB, type WB
>  e820 update range: 00000000dff00000 - 0000000100000000 (usable) ==> (reserved)
> -initial memory mapped : 0 - 01000000
> -9b000 size 16384
> -init_memory_mapping: 0000000000000000-00000000373fe000
> - 0000000000 - 0000400000 page 4k
> - 0000400000 - 0037000000 page 2M
> - 0037000000 - 00373fe000 page 4k
> -kernel direct mapping tables up to 373fe000 @ ffa000-1000000
> -RAMDISK: 35f5c000 - 36fa6000
> +initial memory mapped : 0 - 01200000
> +Base memory trampoline at [c009b000] 9b000 size 16384
> +init_memory_mapping: 0000000000000000-00000000375fe000
> + 0000000000 - 0000200000 page 4k
> + 0000200000 - 0037400000 page 2M
> + 0037400000 - 00375fe000 page 4k
> +kernel direct mapping tables up to 375fe000 @ 11f8000-1200000
> +RAMDISK: 3615c000 - 370a6000
>  ACPI: RSDP 000fbc90 00024 (v02 DELL  )
>  ACPI: XSDT dfe73a00 00064 (v01 DELL    M08     27D80B13 ASL  00000061)
>  ACPI: FACP dfe7389c 000F4 (v04 DELL    M08     27D80B13 ASL  00000061)
> @@ -73,35 +73,36 @@ ACPI: OSFR dfe73200 0002C (v01 DELL    M
>  ACPI: BOOT dfe737c0 00028 (v01 DELL    M08     27D80B13 ASL  00000061)
>  ACPI: SSDT dfe7217e 004CC (v01  PmRef    CpuPm 00003000 INTL 20050624)
>  ACPI: Local APIC address 0xfee00000
> -2698MB HIGHMEM available.
> -883MB LOWMEM available.
> -  mapped low ram: 0 - 373fe000
> -  low ram: 0 - 373fe000
> +3722MB HIGHMEM available.
> +885MB LOWMEM available.
> +  mapped low ram: 0 - 375fe000
> +  low ram: 0 - 375fe000
>  Zone PFN ranges:
>    DMA      0x00000010 -> 0x00001000
> -  Normal   0x00001000 -> 0x000373fe
> -  HighMem  0x000373fe -> 0x000dfe72
> +  Normal   0x00001000 -> 0x000375fe
> +  HighMem  0x000375fe -> 0x00120000
>  Movable zone start PFN for each node
>  Early memory PFN ranges
>      0: 0x00000010 -> 0x0000009f
>      0: 0x00000100 -> 0x000dfe72
> -On node 0 totalpages: 916993
> -free_area_init_node: node 0, pgdat c0ba2f00, node_mem_map f435c200
> +    0: 0x00100000 -> 0x00120000
> +On node 0 totalpages: 1048065
> +free_area_init_node: node 0, pgdat c0bd0d40, node_mem_map f3d5c200
>    DMA zone: 32 pages used for memmap
>    DMA zone: 0 pages reserved
>    DMA zone: 3951 pages, LIFO batch:0
> -  Normal zone: 1736 pages used for memmap
> -  Normal zone: 220470 pages, LIFO batch:31
> -  HighMem zone: 5397 pages used for memmap
> -  HighMem zone: 685407 pages, LIFO batch:31
> +  Normal zone: 1740 pages used for memmap
> +  Normal zone: 220978 pages, LIFO batch:31
> +  HighMem zone: 7445 pages used for memmap
> +  HighMem zone: 813919 pages, LIFO batch:31
>  Using APIC driver default
>  ACPI: PM-Timer IO Port: 0x1008
>  ACPI: Local APIC address 0xfee00000
> -enabled)
> -enabled)
> -high edge lint[0x1])
> -high edge lint[0x1])
> -gsi_base[0])
> +ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
> +ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
> +ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
> +ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
> +ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
>  IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
>  ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
>  ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> @@ -117,40 +118,39 @@ PM: Registered nosave memory: 0000000000
>  Allocating PCI resources starting at e0000000 (gap: e0000000:18000000)
>  Booting paravirtualized kernel on bare hardware
>  setup_percpu: NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:2 nr_node_ids:1
> -PERCPU: Embedded 13 pages/cpu @f3c00000 s31168 r0 d22080 u2097152
> -pcpu-alloc: s31168 r0 d22080 u2097152 alloc=1*4194304
> -0 1
> -Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 909828
> -Kernel command line: BOOT_IMAGE=/vmlinuz-3.3.0-4.fc16.i686 root=UUID=7417d839-a647-466e-b57d-fc65d20a6342 ro rd.md=0 rd.lvm=0 rd.dm=0 quiet SYSFONT=latarcyrheb-sun16 rhgb rd.luks=0 KEYTABLE=pl2 LANG=en_US.UTF-8
> +PERCPU: Embedded 14 pages/cpu @f75cf000 s34112 r0 d23232 u57344
> +pcpu-alloc: s34112 r0 d23232 u57344 alloc=14*4096
> +pcpu-alloc: [0] 0 [0] 1
> +Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1038848
> +Kernel command line: BOOT_IMAGE=/vmlinuz-3.4.3-1.fc17.i686.PAE root=UUID=29c27e52-ab08-4c1a-9ed7-86ab260b207b ro rd.md=0 rd.lvm=0 rd.dm=0 SYSFONT=True KEYTABLE=pl2 rd.luks=0 LANG=pl_PL.UTF-8 rhgb quiet
>  PID hash table entries: 4096 (order: 2, 16384 bytes)
>  Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
>  Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
>  Initializing CPU#0
> -allocated 7336720 bytes of page_cgroup
> +allocated 9437056 bytes of page_cgroup
>  please try 'cgroup_disable=memory' option if you don't want memory cgroups
> -Initializing HighMem for node 0 (000373fe:000dfe72)
> -Memory: 3605028k/3668424k available (5337k kernel code, 62944k reserved, 2570k data, 620k init, 2763216k highmem)
> +Initializing HighMem for node 0 (000375fe:00120000)
> +Memory: 4119724k/4718592k available (5442k kernel code, 72536k reserved, 2650k data, 640k init, 3285456k highmem)
>  virtual kernel memory layout:
>      fixmap  : 0xffa96000 - 0xfffff000   (5540 kB)
> -    pkmap   : 0xff400000 - 0xff800000   (4096 kB)
> -    vmalloc : 0xf7bfe000 - 0xff3fe000   ( 120 MB)
> -    lowmem  : 0xc0000000 - 0xf73fe000   ( 883 MB)
> -      .init : 0xc0bb9000 - 0xc0c54000   ( 620 kB)
> -      .data : 0xc093671f - 0xc0bb8f80   (2570 kB)
> -      .text : 0xc0400000 - 0xc093671f   (5337 kB)
> +    pkmap   : 0xff600000 - 0xff800000   (2048 kB)
> +    vmalloc : 0xf7dfe000 - 0xff5fe000   ( 120 MB)
> +    lowmem  : 0xc0000000 - 0xf75fe000   ( 885 MB)
> +      .init : 0xc0be8000 - 0xc0c88000   ( 640 kB)
> +      .data : 0xc0950a93 - 0xc0be7480   (2650 kB)
> +      .text : 0xc0400000 - 0xc0950a93   (5442 kB)
>  Checking if this processor honours the WP bit even in supervisor mode...Ok.
>  SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
>  Hierarchical RCU implementation.
> -       RCU dyntick-idle grace-period acceleration is enabled.
>  NR_IRQS:2304 nr_irqs:512 16
>  CPU 0 irqstacks, hard=f3008000 soft=f300a000
>  Extended CMOS year: 2000
>  Console: colour dummy device 80x25
> -enabled
> +console [tty0] enabled
>  hpet clockevent registered
>  Fast TSC calibration using PIT
> -Detected 2394.148 MHz processor.
> -Calibrating delay loop (skipped), value calculated using timer frequency.. 4788.29 BogoMIPS (lpj=2394148)
> +Detected 2393.857 MHz processor.
> +Calibrating delay loop (skipped), value calculated using timer frequency.. 4787.71 BogoMIPS (lpj=2393857)
>  pid_max: default: 32768 minimum: 301
>  Security Framework initialized
>  SELinux:  Initializing.
> @@ -168,12 +168,12 @@ CPU: Processor Core ID: 0
>  mce: CPU supports 6 MCE banks
>  CPU0: Thermal monitoring enabled (TM2)
>  using mwait in idle threads.
> -ACPI: Core revision 20120111
> -ftrace: allocating 21899 entries in 43 pages
> +ACPI: Core revision 20120320
> +ftrace: allocating 22370 entries in 44 pages
>  Enabling APIC mode:  Flat.  Using 1 I/O APICs
>  ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
>  CPU0: Intel(R) Core(TM)2 Duo CPU     T8300  @ 2.40GHz stepping 06
> -Performance Events: PEBS fmt0+, Core2 events, Intel PMU driver.
> +Performance Events: PEBS fmt0+, 4-deep LBR, Core2 events, Intel PMU driver.
>  ... version:                2
>  ... bit width:              40
>  ... generic registers:      2
> @@ -181,17 +181,16 @@ Performance Events: PEBS fmt0+, Core2 ev
>  ... max period:             000000007fffffff
>  ... fixed-purpose events:   3
>  ... event mask:             0000000700000003
> -NMI watchdog enabled, takes one hw-pmu counter.
> -CPU 1 irqstacks, hard=f30ce000 soft=f30d8000
> +NMI watchdog: enabled, takes one hw-pmu counter.
> +CPU 1 irqstacks, hard=f30e0000 soft=f30e2000
>  Booting Node   0, Processors  #1 Ok.
> -smpboot cpu 1: start_ip = 9b000
>  Initializing CPU#1
> -NMI watchdog enabled, takes one hw-pmu counter.
> +NMI watchdog: enabled, takes one hw-pmu counter.
>  Brought up 2 CPUs
> -Total of 2 processors activated (9576.59 BogoMIPS).
> +Total of 2 processors activated (9575.42 BogoMIPS).
>  devtmpfs: initialized
>  atomic64 test passed for i586+ platform with CX8 and with SSE
> -RTC time: 12:29:27, date: 04/08/12
> +RTC time: 18:54:40, date: 07/01/12
>  NET: Registered protocol family 16
>  ACPI: bus type pci registered
>  PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
> @@ -222,7 +221,7 @@ ACPI: (supports S0 S3 S4 S5)
>  ACPI: Using IOAPIC for interrupt routing
>  ACPI: No dock devices found.
>  PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
> -(domain 0000 [bus 00-ff])
> +ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
>  pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7]
>  pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff]
>  pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
> @@ -235,7 +234,7 @@ pci_root PNP0A03:00: host bridge window
>  pci_root PNP0A03:00: host bridge window [mem 0xfeda7000-0xfedfffff]
>  pci_root PNP0A03:00: host bridge window [mem 0xfee10000-0xff9fffff]
>  pci_root PNP0A03:00: host bridge window [mem 0xffc00000-0xffdfffff]
> -pci_root PNP0A03:00: host bridge window [0x120000000-0x317ffffff] (ignored, not CPU addressable)
> +pci_root PNP0A03:00: host bridge window [mem 0x120000000-0x317ffffff]
>  PCI host bridge to bus 0000:00
>  pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
>  pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
> @@ -249,48 +248,49 @@ pci_bus 0000:00: root bus resource [mem
>  pci_bus 0000:00: root bus resource [mem 0xfeda7000-0xfedfffff]
>  pci_bus 0000:00: root bus resource [mem 0xfee10000-0xff9fffff]
>  pci_bus 0000:00: root bus resource [mem 0xffc00000-0xffdfffff]
> -type 0 class 0x000600
> -type 1 class 0x000604
> +pci_bus 0000:00: root bus resource [mem 0x120000000-0x317ffffff]
> +pci 0000:00:00.0: [8086:2a00] type 00 class 0x060000
> +pci 0000:00:01.0: [8086:2a01] type 01 class 0x060400
>  pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
> -type 0 class 0x000c03
> +pci 0000:00:1a.0: [8086:2834] type 00 class 0x0c0300
>  pci 0000:00:1a.0: reg 20: [io  0x6f20-0x6f3f]
> -type 0 class 0x000c03
> +pci 0000:00:1a.1: [8086:2835] type 00 class 0x0c0300
>  pci 0000:00:1a.1: reg 20: [io  0x6f00-0x6f1f]
> -pci 0000:00:1a.7: [8086:283a] type 0 class 0x000c03
> +pci 0000:00:1a.7: [8086:283a] type 00 class 0x0c0320
>  pci 0000:00:1a.7: reg 10: [mem 0xfed1c400-0xfed1c7ff]
>  pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
> -pci 0000:00:1b.0: [8086:284b] type 0 class 0x000403
> +pci 0000:00:1b.0: [8086:284b] type 00 class 0x040300
>  pci 0000:00:1b.0: reg 10: [mem 0xf6ffc000-0xf6ffffff 64bit]
>  pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
> -pci 0000:00:1c.0: [8086:283f] type 1 class 0x000604
> +pci 0000:00:1c.0: [8086:283f] type 01 class 0x060400
>  pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
> -type 1 class 0x000604
> +pci 0000:00:1c.1: [8086:2841] type 01 class 0x060400
>  pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
> -type 1 class 0x000604
> +pci 0000:00:1c.4: [8086:2847] type 01 class 0x060400
>  pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
> -type 0 class 0x000c03
> +pci 0000:00:1d.0: [8086:2830] type 00 class 0x0c0300
>  pci 0000:00:1d.0: reg 20: [io  0x6f80-0x6f9f]
> -type 0 class 0x000c03
> +pci 0000:00:1d.1: [8086:2831] type 00 class 0x0c0300
>  pci 0000:00:1d.1: reg 20: [io  0x6f60-0x6f7f]
> -type 0 class 0x000c03
> +pci 0000:00:1d.2: [8086:2832] type 00 class 0x0c0300
>  pci 0000:00:1d.2: reg 20: [io  0x6f40-0x6f5f]
> -type 0 class 0x000c03
> +pci 0000:00:1d.7: [8086:2836] type 00 class 0x0c0320
>  pci 0000:00:1d.7: reg 10: [mem 0xfed1c000-0xfed1c3ff]
>  pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
> -type 1 class 0x000604
> -type 0 class 0x000601
> +pci 0000:00:1e.0: [8086:2448] type 01 class 0x060401
> +pci 0000:00:1f.0: [8086:2815] type 00 class 0x060100
>  pci 0000:00:1f.0: quirk: [io  0x1000-0x107f] claimed by ICH6 ACPI/GPIO/TCO
>  pci 0000:00:1f.0: quirk: [io  0x1080-0x10bf] claimed by ICH6 GPIO
>  pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0900 (mask 007f)
>  pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 006c (mask 0007)
>  pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 0c80 (mask 003f)
> -type 0 class 0x000101
> +pci 0000:00:1f.1: [8086:2850] type 00 class 0x01018a
>  pci 0000:00:1f.1: reg 10: [io  0x01f0-0x01f7]
>  pci 0000:00:1f.1: reg 14: [io  0x03f4-0x03f7]
>  pci 0000:00:1f.1: reg 18: [io  0x0170-0x0177]
>  pci 0000:00:1f.1: reg 1c: [io  0x0374-0x0377]
>  pci 0000:00:1f.1: reg 20: [io  0x6fa0-0x6faf]
> -type 0 class 0x000106
> +pci 0000:00:1f.2: [8086:2829] type 00 class 0x010601
>  pci 0000:00:1f.2: reg 10: [io  0x6eb0-0x6eb7]
>  pci 0000:00:1f.2: reg 14: [io  0x6eb8-0x6ebb]
>  pci 0000:00:1f.2: reg 18: [io  0x6ec0-0x6ec7]
> @@ -298,10 +298,10 @@ pci 0000:00:1f.2: reg 1c: [io  0x6ec8-0x
>  pci 0000:00:1f.2: reg 20: [io  0x6ee0-0x6eff]
>  pci 0000:00:1f.2: reg 24: [mem 0xf6ffb800-0xf6ffbfff]
>  pci 0000:00:1f.2: PME# supported from D3hot
> -pci 0000:00:1f.3: [8086:283e] type 0 class 0x000c05
> +pci 0000:00:1f.3: [8086:283e] type 00 class 0x0c0500
>  pci 0000:00:1f.3: reg 10: [mem 0xf6ffb700-0xf6ffb7ff]
>  pci 0000:00:1f.3: reg 20: [io  0x10c0-0x10df]
> -type 0 class 0x000300
> +pci 0000:01:00.0: [10de:0407] type 00 class 0x030000
>  pci 0000:01:00.0: reg 10: [mem 0xf5000000-0xf5ffffff]
>  pci 0000:01:00.0: reg 14: [mem 0xe0000000-0xefffffff 64bit pref]
>  pci 0000:01:00.0: reg 1c: [mem 0xf2000000-0xf3ffffff 64bit]
> @@ -311,7 +311,7 @@ pci 0000:00:01.0: PCI bridge to [bus 01-
>  pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
>  pci 0000:00:01.0:   bridge window [mem 0xf2000000-0xf6efffff]
>  pci 0000:00:01.0:   bridge window [mem 0xe0000000-0xefffffff 64bit pref]
> -type 0 class 0x000200
> +pci 0000:09:00.0: [11ab:4354] type 00 class 0x020000
>  pci 0000:09:00.0: reg 10: [mem 0xf1ffc000-0xf1ffffff 64bit]
>  pci 0000:09:00.0: reg 18: [io  0xde00-0xdeff]
>  pci 0000:09:00.0: supports D1 D2
> @@ -319,7 +319,7 @@ pci 0000:09:00.0: PME# supported from D0
>  pci 0000:00:1c.0: PCI bridge to [bus 09-09]
>  pci 0000:00:1c.0:   bridge window [io  0xd000-0xdfff]
>  pci 0000:00:1c.0:   bridge window [mem 0xf1f00000-0xf1ffffff]
> -type 0 class 0x000280
> +pci 0000:0b:00.0: [8086:4222] type 00 class 0x028000
>  pci 0000:0b:00.0: reg 10: [mem 0xf1eff000-0xf1efffff]
>  pci 0000:0b:00.0: PME# supported from D0 D3hot D3cold
>  pci 0000:0b:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
> @@ -329,27 +329,25 @@ pci 0000:00:1c.4: PCI bridge to [bus 0c-
>  pci 0000:00:1c.4:   bridge window [io  0xc000-0xcfff]
>  pci 0000:00:1c.4:   bridge window [mem 0xf1c00000-0xf1dfffff]
>  pci 0000:00:1c.4:   bridge window [mem 0xf0000000-0xf01fffff 64bit pref]
> -type 0 class 0x000c00
> -pci 0000:03:09.0: proprietary Ricoh MMC controller disabled (via firewire function)
> -pci 0000:03:09.0: MMC cards are now supported by standard SDHCI controller
> +pci 0000:03:09.0: [1180:0832] type 00 class 0x0c0010
>  pci 0000:03:09.0: reg 10: [mem 0xf1bff800-0xf1bfffff]
>  pci 0000:03:09.0: supports D1 D2
>  pci 0000:03:09.0: PME# supported from D0 D1 D2 D3hot D3cold
> -type 0 class 0x000805
> -pci 0000:03:09.1: reg 10: [mem 0xf1bff400-0xf1bff4ff]
> +pci 0000:03:09.1: [1180:0822] type 00 class 0x080501
> +pci 0000:03:09.1: reg 10: [mem 0xf1bff500-0xf1bff5ff]
>  pci 0000:03:09.1: supports D1 D2
>  pci 0000:03:09.1: PME# supported from D0 D1 D2 D3hot D3cold
> -type 0 class 0x000880
> +pci 0000:03:09.2: [1180:0592] type 00 class 0x088000
>  pci 0000:03:09.2: reg 10: [mem 0xf1bff600-0xf1bff6ff]
>  pci 0000:03:09.2: supports D1 D2
>  pci 0000:03:09.2: PME# supported from D0 D1 D2 D3hot D3cold
> -type 0 class 0x000880
> +pci 0000:03:09.3: [1180:0852] type 00 class 0x088000
>  pci 0000:03:09.3: reg 10: [mem 0xf1bff700-0xf1bff7ff]
>  pci 0000:03:09.3: supports D1 D2
>  pci 0000:03:09.3: PME# supported from D0 D1 D2 D3hot D3cold
> -(subtractive decode)
> +pci 0000:00:1e.0: PCI bridge to [bus 03-03] (subtractive decode)
>  pci 0000:00:1e.0:   bridge window [mem 0xf1b00000-0xf1bfffff]
> -(subtractive decode)
> +pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
>  pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
>  pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
>  pci 0000:00:1e.0:   bridge window [mem 0x000d0000-0x000dffff] (subtractive decode)
> @@ -361,6 +359,7 @@ pci 0000:00:1e.0:   bridge window [mem 0
>  pci 0000:00:1e.0:   bridge window [mem 0xfeda7000-0xfedfffff] (subtractive decode)
>  pci 0000:00:1e.0:   bridge window [mem 0xfee10000-0xff9fffff] (subtractive decode)
>  pci 0000:00:1e.0:   bridge window [mem 0xffc00000-0xffdfffff] (subtractive decode)
> +pci 0000:00:1e.0:   bridge window [mem 0x120000000-0x317ffffff] (subtractive decode)
>  pci_bus 0000:00: on NUMA node 0
>  ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
>  ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIE._PRT]
> @@ -415,7 +414,7 @@ pnp 00:00: [mem 0xfed90000-0xfed9ffff wi
>  pnp 00:00: [mem 0xfeda7000-0xfedfffff window]
>  pnp 00:00: [mem 0xfee10000-0xff9fffff window]
>  pnp 00:00: [mem 0xffc00000-0xffdfffff window]
> -pnp 00:00: [mem 0x20000000-0x17ffffff window]
> +pnp 00:00: [mem 0x120000000-0x317ffffff window]
>  pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
>  pnp 00:01: [io  0x004e-0x004f]
>  pnp 00:01: [io  0x0068-0x006f]
> @@ -468,10 +467,10 @@ pnp 00:0a: [irq 0 disabled]
>  pnp 00:0a: [io  0x04d0-0x04d1]
>  pnp 00:0a: [io  0x1000-0x1005]
>  pnp 00:0a: [io  0x1008-0x100f]
> -because it overlaps 0000:00:1f.0 BAR 13 [io  0x1000-0x107f]
> +pnp 00:0a: disabling [io  0x1000-0x1005] because it overlaps 0000:00:1f.0 BAR 13 [io  0x1000-0x107f]
>  pnp 00:0a: disabling [io  0x1008-0x100f] because it overlaps 0000:00:1f.0 BAR 13 [io  0x1000-0x107f]
>  system 00:0a: [io  0x0900-0x097f] has been reserved
> -has been reserved
> +system 00:0a: [io  0x04d0-0x04d1] has been reserved
>  system 00:0a: Plug and Play ACPI device, IDs PNP0c01 (active)
>  pnp 00:0b: [io  0xf400-0xf4fe]
>  pnp 00:0b: [io  0x0086]
> @@ -481,13 +480,13 @@ pnp 00:0b: [io  0x1080-0x10bf]
>  pnp 00:0b: [io  0x10c0-0x10df]
>  pnp 00:0b: [io  0x1010-0x102f]
>  pnp 00:0b: [io  0x0809]
> -because it overlaps 0000:00:1f.0 BAR 13 [io  0x1000-0x107f]
> -because it overlaps 0000:00:1f.0 BAR 13 [io  0x1000-0x107f]
> +pnp 00:0b: disabling [io  0x1006-0x1007] because it overlaps 0000:00:1f.0 BAR 13 [io  0x1000-0x107f]
> +pnp 00:0b: disabling [io  0x100a-0x1059] because it overlaps 0000:00:1f.0 BAR 13 [io  0x1000-0x107f]
>  pnp 00:0b: disabling [io  0x1010-0x102f] because it overlaps 0000:00:1f.0 BAR 13 [io  0x1000-0x107f]
>  system 00:0b: [io  0xf400-0xf4fe] has been reserved
>  system 00:0b: [io  0x1080-0x10bf] has been reserved
>  system 00:0b: [io  0x10c0-0x10df] has been reserved
> -has been reserved
> +system 00:0b: [io  0x0809] has been reserved
>  system 00:0b: Plug and Play ACPI device, IDs PNP0c01 (active)
>  pnp 00:0c: [mem 0x00000000-0x0009efff]
>  pnp 00:0c: [mem 0x0009f000-0x0009ffff]
> @@ -528,10 +527,15 @@ system 00:0c: [mem 0xf8000000-0xfbffffff
>  system 00:0c: Plug and Play ACPI device, IDs PNP0c01 (active)
>  pnp: PnP ACPI: found 13 devices
>  ACPI: ACPI bus type pnp unregistered
> -PCI: max bus depth: 1 pci_try_num: 2
> -pci 0000:00:1c.1: BAR 15: assigned [mem 0xf0200000-0xf03fffff 64bit pref]
> +pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 09-09] add_size 200000
> +pci 0000:00:1c.1: bridge window [io  0x1000-0x0fff] to [bus 0b-0b] add_size 1000
> +pci 0000:00:1c.1: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 0b-0b] add_size 200000
> +pci 0000:00:1c.0: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
> +pci 0000:00:1c.1: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
> +pci 0000:00:1c.1: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
> +pci 0000:00:1c.0: BAR 15: assigned [mem 0xf0200000-0xf03fffff 64bit pref]
> +pci 0000:00:1c.1: BAR 15: assigned [mem 0xf0400000-0xf05fffff 64bit pref]
>  pci 0000:00:1c.1: BAR 13: assigned [io  0x2000-0x2fff]
> -pci 0000:00:1c.0: BAR 15: assigned [mem 0xf0400000-0xf05fffff 64bit pref]
>  pci 0000:01:00.0: BAR 6: assigned [mem 0xf4000000-0xf401ffff pref]
>  pci 0000:00:01.0: PCI bridge to [bus 01-01]
>  pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
> @@ -540,11 +544,11 @@ pci 0000:00:01.0:   bridge window [mem 0
>  pci 0000:00:1c.0: PCI bridge to [bus 09-09]
>  pci 0000:00:1c.0:   bridge window [io  0xd000-0xdfff]
>  pci 0000:00:1c.0:   bridge window [mem 0xf1f00000-0xf1ffffff]
> -pci 0000:00:1c.0:   bridge window [mem 0xf0400000-0xf05fffff 64bit pref]
> +pci 0000:00:1c.0:   bridge window [mem 0xf0200000-0xf03fffff 64bit pref]
>  pci 0000:00:1c.1: PCI bridge to [bus 0b-0b]
>  pci 0000:00:1c.1:   bridge window [io  0x2000-0x2fff]
>  pci 0000:00:1c.1:   bridge window [mem 0xf1e00000-0xf1efffff]
> -pci 0000:00:1c.1:   bridge window [mem 0xf0200000-0xf03fffff 64bit pref]
> +pci 0000:00:1c.1:   bridge window [mem 0xf0400000-0xf05fffff 64bit pref]
>  pci 0000:00:1c.4: PCI bridge to [bus 0c-0d]
>  pci 0000:00:1c.4:   bridge window [io  0xc000-0xcfff]
>  pci 0000:00:1c.4:   bridge window [mem 0xf1c00000-0xf1dfffff]
> @@ -564,15 +568,16 @@ pci_bus 0000:00: resource 12 [mem 0xfed9
>  pci_bus 0000:00: resource 13 [mem 0xfeda7000-0xfedfffff]
>  pci_bus 0000:00: resource 14 [mem 0xfee10000-0xff9fffff]
>  pci_bus 0000:00: resource 15 [mem 0xffc00000-0xffdfffff]
> +pci_bus 0000:00: resource 16 [mem 0x120000000-0x317ffffff]
>  pci_bus 0000:01: resource 0 [io  0xe000-0xefff]
>  pci_bus 0000:01: resource 1 [mem 0xf2000000-0xf6efffff]
>  pci_bus 0000:01: resource 2 [mem 0xe0000000-0xefffffff 64bit pref]
>  pci_bus 0000:09: resource 0 [io  0xd000-0xdfff]
>  pci_bus 0000:09: resource 1 [mem 0xf1f00000-0xf1ffffff]
> -pci_bus 0000:09: resource 2 [mem 0xf0400000-0xf05fffff 64bit pref]
> +pci_bus 0000:09: resource 2 [mem 0xf0200000-0xf03fffff 64bit pref]
>  pci_bus 0000:0b: resource 0 [io  0x2000-0x2fff]
>  pci_bus 0000:0b: resource 1 [mem 0xf1e00000-0xf1efffff]
> -pci_bus 0000:0b: resource 2 [mem 0xf0200000-0xf03fffff 64bit pref]
> +pci_bus 0000:0b: resource 2 [mem 0xf0400000-0xf05fffff 64bit pref]
>  pci_bus 0000:0c: resource 0 [io  0xc000-0xcfff]
>  pci_bus 0000:0c: resource 1 [mem 0xf1c00000-0xf1dfffff]
>  pci_bus 0000:0c: resource 2 [mem 0xf0000000-0xf01fffff 64bit pref]
> @@ -589,29 +594,29 @@ pci_bus 0000:03: resource 12 [mem 0xfed9
>  pci_bus 0000:03: resource 13 [mem 0xfeda7000-0xfedfffff]
>  pci_bus 0000:03: resource 14 [mem 0xfee10000-0xff9fffff]
>  pci_bus 0000:03: resource 15 [mem 0xffc00000-0xffdfffff]
> +pci_bus 0000:03: resource 16 [mem 0x120000000-0x317ffffff]
>  NET: Registered protocol family 2
>  IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
>  TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
>  TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
>  TCP: Hash tables configured (established 131072 bind 65536)
> -TCP reno registered
> +TCP: reno registered
>  UDP hash table entries: 512 (order: 2, 16384 bytes)
>  UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
>  NET: Registered protocol family 1
>  pci 0000:01:00.0: Boot video device
>  PCI: CLS 64 bytes, default 64
>  Unpacking initramfs...
> -Freeing initrd memory: 16680k freed
> +Freeing initrd memory: 15656k freed
>  Simple Boot Flag at 0x79 set to 0x1
>  apm: BIOS not found.
> -Intel AES-NI instructions are not detected.
>  audit: initializing netlink socket (disabled)
> -type=2000 audit(1333888166.549:1): initialized
> +type=2000 audit(1341168880.516:1): initialized
>  highmem bounce pool size: 64 pages
> -HugeTLB registered 4 MB page size, pre-allocated 0 pages
> +HugeTLB registered 2 MB page size, pre-allocated 0 pages
>  VFS: Disk quotas dquot_6.5.2
>  Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
> -msgmni has been set to 1676
> +msgmni has been set to 1660
>  SELinux:  Registering netfilter hooks
>  alg: No test for stdrng (krng)
>  NET: Registered protocol family 38
> @@ -626,14 +631,13 @@ pcieport 0000:00:1c.4: irq 43 for MSI/MS
>  pci_hotplug: PCI Hot Plug PCI Core version: 0.5
>  pciehp: PCI Express Hot Plug Controller Driver version: 0.4
>  acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
> -registered
> -vesafb: mode is 1024x768x32, linelength=4096, pages=0
> +acpiphp: Slot [1] registered
> +vesafb: mode is 1440x900x32, linelength=5760, pages=0
>  vesafb: scrolling: redraw
>  vesafb: Truecolor: size=8:8:8:8, shift=24:16:8:0
> -vesafb: framebuffer at 0xf3000000, mapped to 0xf7c80000, using 3072k, total 3072k
> -Console: switching to colour frame buffer device 128x48
> +vesafb: framebuffer at 0xf3000000, mapped to 0xf7e80000, using 5120k, total 5120k
> +Console: switching to colour frame buffer device 180x56
>  fb0: VESA VGA frame buffer device
> -intel_idle: MWAIT substates: 0x3122220
>  intel_idle: does not run on family 6 model 23
>  ACPI: AC Adapter [AC] (off-line)
>  input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input0
> @@ -642,17 +646,15 @@ input: Power Button as /devices/LNXSYSTM
>  ACPI: Power Button [PBTN]
>  input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input2
>  ACPI: Sleep Button [SBTN]
> +ACPI: Requesting acpi_cpufreq
>  Monitor-Mwait will be used to enter C-1 state
>  Monitor-Mwait will be used to enter C-2 state
>  Monitor-Mwait will be used to enter C-3 state
>  Marking TSC unstable due to TSC halts in idle
>  ACPI: acpi_idle registered with cpuidle
>  thermal LNXTHERM:00: registered as thermal_zone0
> -ACPI: Thermal Zone [THM] (32 C)
> +ACPI: Thermal Zone [THM] (53 C)
>  GHES: HEST is not enabled!
> -isapnp: Scanning for PnP cards...
> -(battery present)
> -isapnp: No Plug & Play device found
>  Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
>  Non-volatile memory driver v1.3
>  Linux agpgart interface v0.103
> @@ -662,6 +664,7 @@ ahci 0000:00:1f.2: irq 44 for MSI/MSI-X
>  ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 3 ports 3 Gbps 0x5 impl SATA mode
>  ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part ccc ems
>  ahci 0000:00:1f.2: setting latency timer to 64
> +ACPI: Battery Slot [BAT0] (battery present)
>  scsi0 : ahci
>  scsi1 : ahci
>  scsi2 : ahci
> @@ -687,7 +690,7 @@ ehci_hcd 0000:00:1a.7: USB 2.0 started,
>  usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
>  usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
>  usb usb1: Product: EHCI Host Controller
> -usb usb1: Manufacturer: Linux 3.3.0-4.fc16.i686 ehci_hcd
> +usb usb1: Manufacturer: Linux 3.4.3-1.fc17.i686.PAE ehci_hcd
>  usb usb1: SerialNumber: 0000:00:1a.7
>  hub 1-0:1.0: USB hub found
>  hub 1-0:1.0: 4 ports detected
> @@ -701,7 +704,7 @@ ehci_hcd 0000:00:1d.7: USB 2.0 started,
>  usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
>  usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
>  usb usb2: Product: EHCI Host Controller
> -usb usb2: Manufacturer: Linux 3.3.0-4.fc16.i686 ehci_hcd
> +usb usb2: Manufacturer: Linux 3.4.3-1.fc17.i686.PAE ehci_hcd
>  usb usb2: SerialNumber: 0000:00:1d.7
>  hub 2-0:1.0: USB hub found
>  hub 2-0:1.0: 6 ports detected
> @@ -714,7 +717,7 @@ uhci_hcd 0000:00:1a.0: irq 20, io base 0
>  usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
>  usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
>  usb usb3: Product: UHCI Host Controller
> -usb usb3: Manufacturer: Linux 3.3.0-4.fc16.i686 uhci_hcd
> +usb usb3: Manufacturer: Linux 3.4.3-1.fc17.i686.PAE uhci_hcd
>  usb usb3: SerialNumber: 0000:00:1a.0
>  hub 3-0:1.0: USB hub found
>  hub 3-0:1.0: 2 ports detected
> @@ -725,7 +728,7 @@ uhci_hcd 0000:00:1a.1: irq 21, io base 0
>  usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
>  usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
>  usb usb4: Product: UHCI Host Controller
> -usb usb4: Manufacturer: Linux 3.3.0-4.fc16.i686 uhci_hcd
> +usb usb4: Manufacturer: Linux 3.4.3-1.fc17.i686.PAE uhci_hcd
>  usb usb4: SerialNumber: 0000:00:1a.1
>  hub 4-0:1.0: USB hub found
>  hub 4-0:1.0: 2 ports detected
> @@ -736,7 +739,7 @@ uhci_hcd 0000:00:1d.0: irq 20, io base 0
>  usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
>  usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
>  usb usb5: Product: UHCI Host Controller
> -usb usb5: Manufacturer: Linux 3.3.0-4.fc16.i686 uhci_hcd
> +usb usb5: Manufacturer: Linux 3.4.3-1.fc17.i686.PAE uhci_hcd
>  usb usb5: SerialNumber: 0000:00:1d.0
>  hub 5-0:1.0: USB hub found
>  hub 5-0:1.0: 2 ports detected
> @@ -747,7 +750,7 @@ uhci_hcd 0000:00:1d.1: irq 21, io base 0
>  usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
>  usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
>  usb usb6: Product: UHCI Host Controller
> -usb usb6: Manufacturer: Linux 3.3.0-4.fc16.i686 uhci_hcd
> +usb usb6: Manufacturer: Linux 3.4.3-1.fc17.i686.PAE uhci_hcd
>  usb usb6: SerialNumber: 0000:00:1d.1
>  hub 6-0:1.0: USB hub found
>  hub 6-0:1.0: 2 ports detected
> @@ -758,13 +761,13 @@ uhci_hcd 0000:00:1d.2: irq 22, io base 0
>  usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
>  usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
>  usb usb7: Product: UHCI Host Controller
> -usb usb7: Manufacturer: Linux 3.3.0-4.fc16.i686 uhci_hcd
> +usb usb7: Manufacturer: Linux 3.4.3-1.fc17.i686.PAE uhci_hcd
>  usb usb7: SerialNumber: 0000:00:1d.2
>  hub 7-0:1.0: USB hub found
>  hub 7-0:1.0: 2 ports detected
>  usbcore: registered new interface driver usbserial
> -USB Serial support registered for generic
>  usbcore: registered new interface driver usbserial_generic
> +USB Serial support registered for generic
>  usbserial: USB Serial Driver core
>  i8042: PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
>  serio: i8042 KBD port at 0x60,0x64 irq 1
> @@ -781,7 +784,7 @@ EFI Variables Facility v0.08 2004-May-17
>  usbcore: registered new interface driver usbhid
>  usbhid: USB HID core driver
>  ip_tables: (C) 2000-2006 Netfilter Core Team
> -TCP cubic registered
> +TCP: cubic registered
>  Initializing XFRM netlink socket
>  NET: Registered protocol family 10
>  Mobile IPv6
> @@ -790,56 +793,56 @@ Registering the dns_resolver key type
>  Using IPI No-Shortcut mode
>  PM: Hibernation image not present or could not be loaded.
>  registered taskstats version 1
> -  Magic number: 8:784:480
> -rtc_cmos 00:04: setting system clock to 2012-04-08 12:29:28 UTC (1333888168)
> +  Magic number: 4:879:947
> +tty tty4: hash matches
> +rtc_cmos 00:04: setting system clock to 2012-07-01 18:54:41 UTC (1341168881)
>  Initializing network drop monitor service
>  input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
>  ata4.00: ATAPI: Optiarc DVD+/-RW AD-7640A, JD05, max UDMA/33
>  ata4.00: configured for UDMA/33
>  ata3: SATA link down (SStatus 0 SControl 300)
>  ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> -ata1.00: ATA-7: ST9200420ASG, 3.ADD, max UDMA/133
> -ata1.00: 390721968 sectors, multi 8: LBA48 NCQ (depth 31/32)
> +ata1.00: ATA-9: OCZ-VERTEX4, 1.3, max UDMA/133
> +ata1.00: 500118192 sectors, multi 8: LBA48 NCQ (depth 31/32), AA
>  ata1.00: configured for UDMA/133
> -scsi 0:0:0:0: Direct-Access     ATA      ST9200420ASG     3.AD PQ: 0 ANSI: 5
> +scsi 0:0:0:0: Direct-Access     ATA      OCZ-VERTEX4      1.3  PQ: 0 ANSI: 5
> +sd 0:0:0:0: [sda] 500118192 512-byte logical blocks: (256 GB/238 GiB)
>  sd 0:0:0:0: Attached scsi generic sg0 type 0
> -sd 0:0:0:0: [sda] 390721968 512-byte logical blocks: (200 GB/186 GiB)
>  sd 0:0:0:0: [sda] Write Protect is off
>  sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
>  sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
>  scsi 3:0:0:0: CD-ROM            Optiarc  DVD+-RW AD-7640A JD05 PQ: 0 ANSI: 5
> + sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 >
>  usb 1-1: new high-speed USB device number 2 using ehci_hcd
> +sd 0:0:0:0: [sda] Attached SCSI disk
>  sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda caddy
>  cdrom: Uniform CD-ROM driver Revision: 3.20
>  sr 3:0:0:0: Attached scsi CD-ROM sr0
>  sr 3:0:0:0: Attached scsi generic sg1 type 5
> - sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 sda9 >
> -sd 0:0:0:0: [sda] Attached SCSI disk
> -Freeing unused kernel memory: 620k freed
> -Write protecting the kernel text: 5340k
> -Write protecting the kernel read-only data: 2096k
> +Freeing unused kernel memory: 640k freed
> +Write protecting the kernel text: 5444k
> +Write protecting the kernel read-only data: 2140k
> +NX-protecting the kernel data: 4796k
> +dracut: dracut-018-40.git20120522.fc17
>  usb 1-1: New USB device found, idVendor=05a9, idProduct=2640
>  usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
>  usb 1-1: Product: Laptop Integrated Webcam
>  usb 1-1: Manufacturer: OmniVision Technologies, Inc. -2640-07.07.20.3
> -dracut: dracut-013-20.fc16
>  dracut: rd.luks=0: removing cryptoluks activation
> -dracut: rd.lvm=0: removing LVM activation
> -udevd[111]: starting version 173
> -wmi: Mapper loaded
> +udevd[111]: starting version 182
> +[drm] Initialized drm 1.1.0 20060810
>  acpi device:31: registered as cooling_device2
>  input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A03:00/device:2e/LNXVIDEO:00/input/input4
>  ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
> -[drm] Initialized drm 1.1.0 20060810
> -VGA switcheroo: detected Optimus DSM method \ handle
> +wmi: Mapper loaded
>  [drm] nouveau 0000:01:00.0: Detected an NV50 generation card (0x084700a2)
> -checking generic (f3000000 300000) vs hw (e0000000 10000000)
> -checking generic (f3000000 300000) vs hw (f2000000 2000000)
> +checking generic (f3000000 500000) vs hw (e0000000 10000000)
> +checking generic (f3000000 500000) vs hw (f2000000 2000000)
>  fb: conflicting fb hw usage nouveaufb vs VESA VGA - removing generic driver
>  Console: switching to colour dummy device 80x25
> -[drm] nouveau 0000:01:00.0: Attempting to load BIOS image from PRAMIN
> -usb 2-2: new high-speed USB device number 3 using ehci_hcd
> +[drm] nouveau 0000:01:00.0: Checking PRAMIN for VBIOS
>  [drm] nouveau 0000:01:00.0: ... appears to be valid
> +[drm] nouveau 0000:01:00.0: Using VBIOS from PRAMIN
>  [drm] nouveau 0000:01:00.0: BIT BIOS found
>  [drm] nouveau 0000:01:00.0: Bios version 60.84.5e.00
>  [drm] nouveau 0000:01:00.0: TMDS table version 2.0
> @@ -859,27 +862,14 @@ usb 2-2: new high-speed USB device numbe
>  [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 1 at offset 0xCB78
>  [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 2 at offset 0xD5C8
>  [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 3 at offset 0xD6BA
> -usb 2-2: New USB device found, idVendor=0bb4, idProduct=0c99
> -usb 2-2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> -usb 2-2: Product: Android Phone
>  [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 4 at offset 0xD8ED
>  [drm] nouveau 0000:01:00.0: Parsing VBIOS init table at offset 0xD952
> -usb 2-2: Manufacturer: HTC
> -usb 2-2: SerialNumber: HT999L903452
>  [drm] nouveau 0000:01:00.0: 0xD952: Condition still not met after 20ms, skipping following opcodes
> -Initializing USB Mass Storage driver...
> -scsi5 : usb-storage 2-2:1.0
> -[drm] nouveau 0000:01:00.0: 3 available performance level(s)
> -[drm] nouveau 0000:01:00.0: 0: core 169MHz shader 338MHz memory 100MHz timing 0 voltage 1150mV fanspeed 100%
> -[drm] nouveau 0000:01:00.0: 1: core 275MHz shader 550MHz memory 301MHz timing 1 voltage 1150mV fanspeed 100%
> -[drm] nouveau 0000:01:00.0: 2: core 475MHz shader 950MHz memory 702MHz timing 2 voltage 1200mV fanspeed 100%
> -[drm] nouveau 0000:01:00.0: c: core 275MHz shader 550MHz memory 302MHz voltage 1150mV
> -usbcore: registered new interface driver usb-storage
> -USB Mass Storage support registered.
> -[TTM] Zone  kernel: Available graphics memory: 429556 kiB.
> -[TTM] Zone highmem: Available graphics memory: 1811164 kiB.
> -[TTM] Initializing pool allocator.
> -[drm] nouveau 0000:01:00.0: Detected 256MiB VRAM
> +[TTM] Zone  kernel: Available graphics memory: 425282 kiB
> +[TTM] Zone highmem: Available graphics memory: 2068010 kiB
> +[TTM] Initializing pool allocator
> +[TTM] Initializing DMA pool allocator
> +[drm] nouveau 0000:01:00.0: Detected 256MiB VRAM (GDDR3)
>  mtrr: type mismatch for e0000000,10000000 old: write-back new: write-combining
>  [drm] nouveau 0000:01:00.0: 512 MiB GART (aperture)
>  [drm] nouveau 0000:01:00.0: DCB encoder 1 unknown
> @@ -887,6 +877,11 @@ mtrr: type mismatch for e0000000,1000000
>  [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
>  [drm] No driver support for vblank timestamp query.
>  [drm] nouveau 0000:01:00.0: ACPI backlight interface available, not registering our own
> +[drm] nouveau 0000:01:00.0: 3 available performance level(s)
> +[drm] nouveau 0000:01:00.0: 0: core 169MHz shader 338MHz memory 100MHz voltage 1150mV fanspeed 100%
> +[drm] nouveau 0000:01:00.0: 1: core 275MHz shader 550MHz memory 301MHz voltage 1150mV fanspeed 100%
> +[drm] nouveau 0000:01:00.0: 2: core 475MHz shader 950MHz memory 702MHz voltage 1200mV fanspeed 100%
> +[drm] nouveau 0000:01:00.0: c: core 275MHz shader 550MHz memory 302MHz voltage 1150mV
>  input: PS/2 Mouse as /devices/platform/i8042/serio1/input/input5
>  input: AlpsPS/2 ALPS GlidePoint as /devices/platform/i8042/serio1/input/input6
>  usb 3-2: new full-speed USB device number 2 using uhci_hcd
> @@ -903,66 +898,58 @@ input: A4Tech USB Full Speed as /devices
>  generic-usb 0003:09DA:8090.0001: input,hidraw0: USB HID v1.11 Mouse [A4Tech USB Full Speed] on usb-0000:00:1d.0-1/input0
>  input: A4Tech USB Full Speed as /devices/pci0000:00/0000:00:1d.0/usb5/5-1/5-1:1.1/input/input8
>  generic-usb 0003:09DA:8090.0002: input,hiddev0,hidraw1: USB HID v1.11 Keyboard [A4Tech USB Full Speed] on usb-0000:00:1d.0-1/input1
> -scsi 5:0:0:0: Direct-Access     HTC      Android Phone    0100 PQ: 0 ANSI: 2
> -sd 5:0:0:0: Attached scsi generic sg2 type 0
> -sd 5:0:0:0: [sdb] Attached SCSI removable disk
> -usb 6-1: new full-speed USB device number 2 using uhci_hcd
> -usb 6-1: New USB device found, idVendor=054c, idProduct=03d5
> -usb 6-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> -usb 6-1: Product: Motion Controller
> -usb 6-1: Manufacturer: Sony Computer Entertainment
> -input: Sony Computer Entertainment Motion Controller as /devices/pci0000:00/0000:00:1d.1/usb6/6-1/6-1:1.0/input/input9
> -generic-usb 0003:054C:03D5.0003: input,hiddev0,hidraw2: USB HID v1.10 Gamepad [Sony Computer Entertainment Motion Controller] on usb-0000:00:1d.1-1/input0
> -composite sync not supported
> -[drm] nouveau 0000:01:00.0: allocated 1440x900 fb: 0x320000, bo f28cf600
> -fbcon: nouveaufb (fb0) is primary device
> -Console: switching to colour frame buffer device 180x56
> -fb0: nouveaufb frame buffer device
> -drm: registered panic notifier
> -[drm] Initialized nouveau 0.0.16 20090420 for 0000:01:00.0 on minor 0
> -dracut: Starting plymouth daemon
>  usb 7-2: new full-speed USB device number 2 using uhci_hcd
> -composite sync not supported
> -dracut: rd.dm=0: removing DM RAID activation
>  usb 7-2: New USB device found, idVendor=0a5c, idProduct=4500
>  usb 7-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
>  usb 7-2: Product: BCM2045B2
>  usb 7-2: Manufacturer: Broadcom
> -dracut: rd.md=0: removing MD RAID activation
>  hub 7-2:1.0: USB hub found
>  hub 7-2:1.0: 3 ports detected
> -sdhci: Secure Digital Host Controller Interface driver
> -sdhci: Copyright(c) Pierre Ossman
> -(rev 22)
> -Registered led device: mmc0::
> -using DMA
> -firewire_ohci: Added fw-ohci device 0000:03:09.0, OHCI v1.10, 4 IR + 4 IT contexts, quirks 0x11
> +composite sync not supported
>  usb 7-2.2: new full-speed USB device number 3 using uhci_hcd
> +[drm] nouveau 0000:01:00.0: allocated 1440x900 fb: 0x320000, bo f6c97e00
> +fbcon: nouveaufb (fb0) is primary device
> +Console: switching to colour frame buffer device 180x56
> +fb0: nouveaufb frame buffer device
> +drm: registered panic notifier
> +[drm] Initialized nouveau 1.0.0 20120316 for 0000:01:00.0 on minor 0
> +dracut: Starting plymouth daemon
>  usb 7-2.2: New USB device found, idVendor=0a5c, idProduct=4502
>  usb 7-2.2: New USB device strings: Mfr=1, Product=0, SerialNumber=0
>  usb 7-2.2: Manufacturer: Broadcom Corp
> -input: Broadcom Corp as /devices/pci0000:00/0000:00:1d.2/usb7/7-2/7-2.2/7-2.2:1.0/input/input10
> -generic-usb 0003:0A5C:4502.0004: input,hidraw3: USB HID v1.11 Keyboard [Broadcom Corp] on usb-0000:00:1d.2-2.2/input0
> +input: Broadcom Corp as /devices/pci0000:00/0000:00:1d.2/usb7/7-2/7-2.2/7-2.2:1.0/input/input9
> +generic-usb 0003:0A5C:4502.0003: input,hidraw2: USB HID v1.11 Keyboard [Broadcom Corp] on usb-0000:00:1d.2-2.2/input0
> +composite sync not supported
>  usb 7-2.3: new full-speed USB device number 4 using uhci_hcd
> -firewire_core: created device fw0: GUID 334fc0001cece070, S400
>  usb 7-2.3: New USB device found, idVendor=0a5c, idProduct=4503
>  usb 7-2.3: New USB device strings: Mfr=1, Product=0, SerialNumber=0
>  usb 7-2.3: Manufacturer: Broadcom Corp
> -input: Broadcom Corp as /devices/pci0000:00/0000:00:1d.2/usb7/7-2/7-2.3/7-2.3:1.0/input/input11
> -generic-usb 0003:0A5C:4503.0005: input,hidraw4: USB HID v1.11 Mouse [Broadcom Corp] on usb-0000:00:1d.2-2.3/input0
> -EXT4-fs (sda7): mounted filesystem with ordered data mode. Opts: (null)
> -dracut: Checking ext4: /dev/disk/by-uuid/7417d839-a647-466e-b57d-fc65d20a6342
> -dracut: issuing e2fsck -a  /dev/disk/by-uuid/7417d839-a647-466e-b57d-fc65d20a6342
> -dracut: _Fedora-16-i686-: clean, 238747/901120 files, 1776110/3584000 blocks
> -dracut: Remounting /dev/disk/by-uuid/7417d839-a647-466e-b57d-fc65d20a6342 with -o ro
> -EXT4-fs (sda7): mounted filesystem with ordered data mode. Opts: (null)
> -dracut: Mounted root filesystem /dev/sda7
> +input: Broadcom Corp as /devices/pci0000:00/0000:00:1d.2/usb7/7-2/7-2.3/7-2.3:1.0/input/input10
> +generic-usb 0003:0A5C:4503.0004: input,hidraw3: USB HID v1.11 Mouse [Broadcom Corp] on usb-0000:00:1d.2-2.3/input0
> +dracut: rd.dm=0: removing DM RAID activation
> +dracut: rd.md=0: removing MD RAID activation
> +sdhci: Secure Digital Host Controller Interface driver
> +sdhci: Copyright(c) Pierre Ossman
> +firewire_ohci 0000:03:09.0: added OHCI v1.10 device as card 0, 4 IR + 4 IT contexts, quirks 0x11
> +sdhci-pci 0000:03:09.1: SDHCI controller found [1180:0822] (rev 22)
> +Registered led device: mmc0::
> +mmc0: SDHCI controller on PCI [0000:03:09.1] using DMA
> +EXT4-fs (sda6): mounted filesystem with ordered data mode. Opts: (null)
> +dracut: Checking ext4: /dev/disk/by-uuid/29c27e52-ab08-4c1a-9ed7-86ab260b207b
> +dracut: issuing e2fsck -a  /dev/disk/by-uuid/29c27e52-ab08-4c1a-9ed7-86ab260b207b
> +dracut: /dev/disk/by-uuid/29c27e52-ab08-4c1a-9ed7-86ab260b207b: clean, 275331/983040 files, 2231118/3932160 blocks
> +dracut: Remounting /dev/disk/by-uuid/29c27e52-ab08-4c1a-9ed7-86ab260b207b with -o ro
> +EXT4-fs (sda6): mounted filesystem with ordered data mode. Opts: (null)
> +dracut: Mounted root filesystem /dev/sda6
>  dracut: Switching root
> -type=1404 audit(1333888173.684:2): enforcing=1 old_enforcing=0 auid=4294967295 ses=4294967295
> -SELinux: 2048 avtab hash slots, 97362 rules.
> -SELinux: 2048 avtab hash slots, 97362 rules.
> -SELinux:  9 users, 13 roles, 3912 types, 215 bools, 1 sens, 1024 cats
> -SELinux:  82 classes, 97362 rules
> +type=1404 audit(1341168884.696:2): enforcing=1 old_enforcing=0 auid=4294967295 ses=4294967295
> +firewire_core 0000:03:09.0: created device fw0: GUID 334fc0001cece070, S400
> +SELinux: 2048 avtab hash slots, 100708 rules.
> +SELinux: 2048 avtab hash slots, 100708 rules.
> +SELinux:  9 users, 15 roles, 4148 types, 223 bools, 1 sens, 1024 cats
> +SELinux:  83 classes, 100708 rules
> +SELinux:  Permission ptrace_child in class process not defined in policy.
> +SELinux: the above unknown classes and permissions will be allowed
>  SELinux:  Completing initialization.
>  SELinux:  Setting up existing superblocks.
>  SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
> @@ -979,18 +966,17 @@ SELinux: initialized (dev devpts, type d
>  SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses transition SIDs
>  SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
>  SELinux: initialized (dev selinuxfs, type selinuxfs), uses genfs_contexts
> -SELinux: initialized (dev usbfs, type usbfs), uses genfs_contexts
>  SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
>  SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
>  SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
> -SELinux: initialized (dev sda7, type ext4), uses xattr
> -type=1403 audit(1333888173.953:3): policy loaded auid=4294967295 ses=4294967295
> -systemd[1]: Successfully loaded SELinux policy in 347ms 981us.
> -systemd[1]: Successfully loaded SELinux database in 54ms 927us, size on heap is 365K.
> +SELinux: initialized (dev sda6, type ext4), uses xattr
> +SELinux: initialized (dev securityfs, type securityfs), uses genfs_contexts
> +type=1403 audit(1341168885.034:3): policy loaded auid=4294967295 ses=4294967295
> +systemd[1]: Successfully loaded SELinux policy in 354ms 350us.
>  systemd[1]: RTC configured in localtime, applying delta of 60 minutes to system time.
>  SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
>  SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
> -systemd[1]: Relabelled /dev and /run in 42ms 476us.
> +systemd[1]: Relabelled /dev and /run in 44ms 145us.
>  SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
>  SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
>  SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
> @@ -999,62 +985,51 @@ SELinux: initialized (dev cgroup, type c
>  SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
>  SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
>  SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
> -systemd[1]: systemd 37 running in system mode. (+PAM +LIBWRAP +AUDIT +SELINUX +SYSVINIT +LIBCRYPTSETUP; fedora)
> +systemd[1]: systemd 44 running in system mode. (+PAM +LIBWRAP +AUDIT +SELINUX +IMA +SYSVINIT +LIBCRYPTSETUP; fedora)
>  systemd[1]: Set hostname to <xps>.
>  SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
> -udevd[521]: starting version 173
> -udevd[521]: specified group 'plugdev' unknown
> -SELinux: initialized (dev configfs, type configfs), uses genfs_contexts
>  SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
> -SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses transition SIDs
> -SELinux: initialized (dev securityfs, type securityfs), uses genfs_contexts
> -EXT4-fs (sda7): re-mounted. Opts: (null)
> -RPC: Registered named UNIX socket transport module.
> -RPC: Registered udp transport module.
> -RPC: Registered tcp transport module.
> -RPC: Registered tcp NFSv4.1 backchannel transport module.
> -SELinux: initialized (dev rpc_pipefs, type rpc_pipefs), uses genfs_contexts
> -SELinux: initialized (dev binfmt_misc, type binfmt_misc), uses genfs_contexts
> +systemd-journald[309]: Fixed max_use=201.9M max_size=25.2M min_size=64.0K keep_free=100.9M
> +systemd-journald[309]: Vacuuming...
> +udevd[307]: starting version 182
> +EXT4-fs (sda6): re-mounted. Opts: (null)
>  sky2: driver version 1.30
>  sky2 0000:09:00.0: Yukon-2 FE+ chip revision 0
>  sky2 0000:09:00.0: irq 45 for MSI/MSI-X
>  sky2 0000:09:00.0: eth0: addr 00:21:9b:cd:55:50
>  cfg80211: Calling CRDA to update world regulatory domain
> -iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for Linux, in-tree:ds
> -iwl3945: Copyright(c) 2003-2011 Intel Corporation
> -iwl3945 0000:0b:00.0: enabling device (0000 -> 0002)
> -iwl3945 0000:0b:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
>  iTCO_vendor_support: vendor-support=0
> -iwl3945 0000:0b:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
> -iwl3945 0000:0b:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
> -iwl3945 0000:0b:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
> -iwl3945 0000:0b:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
> -iwl3945 0000:0b:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
> -iwl3945 0000:0b:00.0: bad EEPROM signature,EEPROM_GP=0x00000007
> -iwl3945 0000:0b:00.0: EEPROM not found, EEPROM_GP=0xffffffff
> -iwl3945 0000:0b:00.0: Unable to init EEPROM
>  iTCO_wdt: Intel TCO WatchDog Timer Driver v1.07
>  iTCO_wdt: Found a ICH8M TCO device (Version=2, TCOBASE=0x1060)
>  iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
> -iwl3945: probe of 0000:0b:00.0 failed with error -2
> -microcode: CPU0 sig=0x10676, pf=0x80, revision=0x60c
> +Linux media interface: v0.10
> +Linux video capture interface: v2.00
> +snd_hda_intel 0000:00:1b.0: irq 46 for MSI/MSI-X
>  r592: driver successfully loaded
> -mtp-probe[674]: checking bus 6, device 2: "/sys/devices/pci0000:00/0000:00:1d.1/usb6/6-1"
> -mtp-probe[724]: checking bus 7, device 3: "/sys/devices/pci0000:00/0000:00:1d.2/usb7/7-2/7-2.2"
> -mtp-probe[670]: checking bus 5, device 2: "/sys/devices/pci0000:00/0000:00:1d.0/usb5/5-1"
> -mtp-probe[691]: checking bus 2, device 3: "/sys/devices/pci0000:00/0000:00:1d.7/usb2/2-2"
> -mtp-probe[684]: checking bus 1, device 2: "/sys/devices/pci0000:00/0000:00:1a.7/usb1/1-1"
> -mtp-probe[650]: checking bus 3, device 2: "/sys/devices/pci0000:00/0000:00:1a.0/usb3/3-2"
> -mtp-probe[730]: checking bus 7, device 4: "/sys/devices/pci0000:00/0000:00:1d.2/usb7/7-2/7-2.3"
> -mtp-probe[691]: bus: 2, device: 3 was not an MTP device
> -mtp-probe[724]: bus: 7, device: 3 was not an MTP device
> -mtp-probe[670]: bus: 5, device: 2 was not an MTP device
> -mtp-probe[684]: bus: 1, device: 2 was not an MTP device
> -mtp-probe[674]: bus: 6, device: 2 was not an MTP device
> -mtp-probe[730]: bus: 7, device: 4 was not an MTP device
> -mtp-probe[650]: bus: 3, device: 2 was not an MTP device
> +uvcvideo: Found UVC 1.00 device Laptop Integrated Webcam (05a9:2640)
> +input: Laptop Integrated Webcam as /devices/pci0000:00/0000:00:1a.7/usb1/1-1/1-1:1.0/input/input11
> +usbcore: registered new interface driver uvcvideo
> +USB Video Class driver (1.1.1)
> +ALSA sound/pci/hda/hda_codec.c:5099 autoconfig: line_outs=1 (0xd/0x0/0x0/0x0/0x0) type:speaker
> +ALSA sound/pci/hda/hda_codec.c:5103    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
> +ALSA sound/pci/hda/hda_codec.c:5107    hp_outs=2 (0xa/0xf/0x0/0x0/0x0)
> +ALSA sound/pci/hda/hda_codec.c:5108    mono: mono_out=0x0
> +ALSA sound/pci/hda/hda_codec.c:5111    dig-out=0x21/0x0
> +ALSA sound/pci/hda/hda_codec.c:5112    inputs:
> +ALSA sound/pci/hda/hda_codec.c:5116  Internal Mic=0xc
> +ALSA sound/pci/hda/hda_codec.c:5116  Mic=0xe
> +ALSA sound/pci/hda/hda_codec.c:5118
> +ALSA sound/pci/hda/patch_sigmatel.c:3111 stac92xx: dac_nids=2 (0x2/0x5/0x0/0x0/0x0)
> +iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for Linux, in-tree:ds
> +iwl3945: Copyright(c) 2003-2011 Intel Corporation
> +microcode: CPU0 sig=0x10676, pf=0x80, revision=0x60c
> +iwl3945 0000:0b:00.0: Tunable channels: 13 802.11bg, 23 802.11a channels
> +iwl3945 0000:0b:00.0: Detected Intel Wireless WiFi Link 3945ABG
> +iwl3945 0000:0b:00.0: irq 47 for MSI/MSI-X
> +Registered led device: phy0-led
> +ieee80211 phy0: Selected rate control algorithm 'iwl-3945-rs'
>  dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
> -r852: driver loaded successfully
> +input: Dell WMI hotkeys as /devices/virtual/input/input12
>  cfg80211: World regulatory domain updated:
>  cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
>  cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> @@ -1062,103 +1037,54 @@ cfg80211:   (2457000 KHz - 2482000 KHz @
>  cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
>  cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
>  cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> +Adding 4930552k swap on /dev/sda8.  Priority:0 extents:1 across:4930552k SS
>  microcode: CPU0 updated to revision 0x60f, date = 2010-09-29
>  microcode: CPU1 sig=0x10676, pf=0x80, revision=0x60c
> +fuse init (API version 7.18)
> +udevd[326]: renamed network interface eth0 to p2p1
>  microcode: CPU1 updated to revision 0x60f, date = 2010-09-29
>  microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
> -Linux media interface: v0.10
> -Linux video capture interface: v2.00
> -input: Dell WMI hotkeys as /devices/virtual/input/input12
> -snd_hda_intel 0000:00:1b.0: irq 46 for MSI/MSI-X
> -uvcvideo: Found UVC 1.00 device Laptop Integrated Webcam (05a9:2640)
> -uvcvideo: UVC non compliance - GET_DEF(PROBE) not supported. Enabling workaround.
> -input: Laptop Integrated Webcam as /devices/pci0000:00/0000:00:1a.7/usb1/1-1/1-1:1.0/input/input13
> -usbcore: registered new interface driver uvcvideo
> -USB Video Class driver (1.1.1)
> -ALSA sound/pci/hda/hda_codec.c:4927 autoconfig: line_outs=1 (0xd/0x0/0x0/0x0/0x0) type:speaker
> -ALSA sound/pci/hda/hda_codec.c:4931    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
> -ALSA sound/pci/hda/hda_codec.c:4935    hp_outs=2 (0xa/0xf/0x0/0x0/0x0)
> -ALSA sound/pci/hda/hda_codec.c:4936    mono: mono_out=0x0
> -ALSA sound/pci/hda/hda_codec.c:4939    dig-out=0x21/0x0
> -ALSA sound/pci/hda/hda_codec.c:4940    inputs:
> -ALSA sound/pci/hda/hda_codec.c:4944  Internal Mic=0xc
> -ALSA sound/pci/hda/hda_codec.c:4944  Mic=0xe
> -ALSA sound/pci/hda/hda_codec.c:4946
> -ALSA sound/pci/hda/patch_sigmatel.c:3090 stac92xx: dac_nids=2 (0x2/0x5/0x0/0x0/0x0)
> -udevd[609]: renamed network interface eth0 to p2p1
> -fuse init (API version 7.18)
>  SELinux: initialized (dev fusectl, type fusectl), uses genfs_contexts
> -mount[900]: mount: fusectl already mounted or /sys/fs/fuse/connections busy
> -mount[900]: mount: according to mtab, fusectl is already mounted on /sys/fs/fuse/connections
> -systemd[1]: sys-fs-fuse-connections.mount mount process exited, code=exited status=32
> -Adding 2047996k swap on /dev/sda8.  Priority:0 extents:1 across:2047996k
> -systemd-fsck[893]: /dev/sda5: clean, 281/76304 files, 117477/304216 blocks
> -SELinux: initialized (dev sda3, type fuseblk), uses genfs_contexts
> -ntfs-3g[923]: Version 2011.4.12 integrated FUSE 27
> -ntfs-3g[923]: Mounted /dev/sda3 (Read-Write, label "", NTFS 3.1)
> -ntfs-3g[923]: Cmdline options: rw
> -ntfs-3g[923]: Mount options: rw,allow_other,nonempty,atime,fsname=/dev/sda3,blkdev,blksize=4096
> -ntfs-3g[923]: Ownership and permissions disabled, configuration type 1
> -fedora-storage-init[912]: Setting up Logical Volume Management:   No volume groups found
> -fedora-storage-init[912]: [  OK  ]
> +cfg80211: Calling CRDA for country: GB
> +cfg80211: Regulatory domain changed to country: GB
> +cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
> +cfg80211:   (2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
> +cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
> +cfg80211:   (5250000 KHz - 5330000 KHz @ 40000 KHz), (N/A, 2000 mBm)
> +cfg80211:   (5490000 KHz - 5710000 KHz @ 40000 KHz), (N/A, 2700 mBm)
> +SELinux: initialized (dev sda2, type fuseblk), uses genfs_contexts
>  EXT4-fs (sda5): mounted filesystem with ordered data mode. Opts: (null)
>  SELinux: initialized (dev sda5, type ext4), uses xattr
> -fedora-storage-init[925]: Setting up Logical Volume Management:   No volume groups found
> -fedora-storage-init[925]: [  OK  ]
> -systemd-fsck[903]: /home: clean, 1056585/5799936 files, 19080578/23175424 blocks
> -lvm[935]: No volume groups found
> -EXT4-fs (sda6): mounting ext3 file system using the ext4 subsystem
> -EXT4-fs (sda6): mounted filesystem with ordered data mode. Opts: (null)
> -SELinux: initialized (dev sda6, type ext3), uses xattr
> -EXT4-fs (sda9): warning: maximal mount count reached, running e2fsck is recommended
> -EXT4-fs (sda9): mounted filesystem with ordered data mode. Opts: (null)
> -SELinux: initialized (dev sda9, type ext4), uses xattr
> -systemd-tmpfiles[951]: Successfully loaded SELinux database in 13ms 399us, size on heap is 366K.
> +EXT4-fs (sda7): mounted filesystem with ordered data mode. Opts: (null)
> +SELinux: initialized (dev sda7, type ext4), uses xattr
>  nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
> -auditd[965]: Started dispatcher: /sbin/audispd pid: 990
> -iptables.init[959]: iptables: Applying firewall rules: [  OK  ]
> -audispd[990]: priority_boost_parser called with: 4
> -audispd[990]: max_restarts_parser called with: 10
> -audispd[990]: audispd initialized with q_depth=120 and 1 active plugins
> -ip6_tables: (C) 2000-2006 Netfilter Core Team
> -ip6tables.init[960]: ip6tables: Applying firewall rules: [  OK  ]
> -NetworkManager[1003]: <info> NetworkManager (version 0.9.2-1.fc16) is starting...
> -NetworkManager[1003]: <info> Read config file /etc/NetworkManager/NetworkManager.conf
> -NetworkManager[1003]: NetworkManager[1003]: <info> NetworkManager (version 0.9.2-1.fc16) is starting...
> -NetworkManager[1003]: NetworkManager[1003]: <info> Read config file /etc/NetworkManager/NetworkManager.conf
> -mcelog[996]: mcelog read: No such device
> -auditctl[973]: No rules
> -auditctl[973]: AUDIT_STATUS: enabled=0 flag=1 pid=965 rate_limit=0 backlog_limit=320 lost=0 backlog=0
> -abrtd[1011]: Init complete, entering main loop
> -acpid[1026]: starting up with netlink and the input layer
> -acpid[1026]: skipping incomplete file /etc/acpi/events/videoconf
> -acpid[1026]: 1 rule loaded
> -acpid[1026]: waiting for events: event logging is off
> -avahi-daemon[1025]: Found user 'avahi' (UID 70) and group 'avahi' (GID 70).
> -avahi-daemon[1025]: Successfully dropped root privileges.
> -avahi-daemon[1025]: avahi-daemon 0.6.30 starting up.
> -auditd[965]: Init complete, auditd 2.1.3 listening for events (startup state enable)
> -Loading iSCSI transport class v2.0-870.
> -iscsi: registered transport (tcp)
> -iscsi: registered transport (iser)
> -libcxgbi:libcxgbi_init_module: tag itt 0x1fff, 13 bits, age 0xf, 4 bits.
> -libcxgbi:ddp_setup_host_page_size: system PAGE 4096, ddp idx 0.
> -Chelsio T3 iSCSI Driver cxgb3i v2.0.0 (Jun. 2010)
> -iscsi: registered transport (cxgb3i)
> -Chelsio T4 iSCSI Driver cxgb4i v0.9.1 (Aug. 2010)
> -iscsi: registered transport (cxgb4i)
> -cnic: Broadcom NetXtreme II CNIC Driver cnic v2.5.8 (Jan 3, 2012)
> -Broadcom NetXtreme II iSCSI Driver bnx2i v2.7.0.3 (Jun 15, 2011)
> -iscsi: registered transport (bnx2i)
> -iscsi: registered transport (be2iscsi)
>  sky2 0000:09:00.0: p2p1: enabling interface
>  ADDRCONF(NETDEV_UP): p2p1: link is not ready
> -8021q: 802.1Q VLAN Support v1.8
> -netlink: 12 bytes leftover after parsing attributes.
> -netlink: 12 bytes leftover after parsing attributes.
> -netlink: 12 bytes leftover after parsing attributes.
> +RPC: Registered named UNIX socket transport module.
> +RPC: Registered udp transport module.
> +RPC: Registered tcp transport module.
> +RPC: Registered tcp NFSv4.1 backchannel transport module.
> +iwl3945 0000:0b:00.0: loaded firmware version 15.32.2.9
> +Bluetooth: Core ver 2.16
> +NET: Registered protocol family 31
> +Bluetooth: HCI device and connection manager initialized
> +Bluetooth: HCI socket layer initialized
> +Bluetooth: L2CAP socket layer initialized
> +Bluetooth: SCO socket layer initialized
> +Bluetooth: BNEP (Ethernet Emulation) ver 1.3
> +Bluetooth: BNEP filters: protocol multicast
> +ADDRCONF(NETDEV_UP): wlan0: link is not ready
> +ip6_tables: (C) 2000-2006 Netfilter Core Team
>  composite sync not supported
>  composite sync not supported
> +SELinux: initialized (dev fuse, type fuse), uses genfs_contexts
>  composite sync not supported
> +wlan0: authenticate with 80:b6:86:6b:2f:d8
> +wlan0: send auth to 80:b6:86:6b:2f:d8 (try 1/3)
> +wlan0: authenticated
> +wlan0: associate with 80:b6:86:6b:2f:d8 (try 1/3)
> +wlan0: RX AssocResp from 80:b6:86:6b:2f:d8 (capab=0x411 status=0 aid=2)
> +wlan0: associated
> +ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
>  composite sync not supported
> -hda-intel: IRQ timing workaround is activated for card #0. Suggest a bigger bdl_pos_adj.
> +wlan0: no IPv6 routers present
>

--14dae9340c418eea6604c3deedb3
Content-Type: application/x-gzip; 
	name="iwl3945_kernel-3.4.3_noPAE.tar.gz.tar.gz"
Content-Disposition: attachment; 
	filename="iwl3945_kernel-3.4.3_noPAE.tar.gz.tar.gz"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h460otd50

H4sIABoI8k8AA9RbW3fiSJLu195fETv90HjHUJmpO7vu0zbGVUwbmzWu7Z6tU4cjJAEaQKIl4Uv9
+o1ISSAhgcE187CcUwWSIr6MjIxrpuwuvXjaWoTTH/51H4YfXVfpmxsaK34zJrjGVPYD54ahqkxR
VP4D4wx//gDsXyjT5rOOEzsC+MHxD9O99fz/6ecL4Ie15FKwr9AL/MS3F/43P5iCM43C9Qri9Th+
jcFZrWMv+beTGHapb/1g/QJPXhT7YQBKS20pTd6aONxo+bqpQ2MZOvPx2l+4v76YepOprdXsRbQm
nhtG9ioK/+E5SSuMpmfQmDrOBkhtGS0GgnHBNGZA48Fz4ZOdpPebGlJ/7HTO4Ax+4jDsD6CPPH9b
B8BNZGproq0Y8PmxIxF2Rb7q3Q+bOPST7yLqavYa+469gIfLPiztVXuXPKX3TMQFtvOBZvGWNaFb
jXVsjxfe2ZE4KVMJx5bQjciLvejJc49E4rsSuRPPEKdKtGHa4nj5ZE+TaGJWdDRx3ofkORUkz+Hv
QnK5uYvkcuddSKIik2u9Tya7imTr70Hyqnry3qWnyS4Szx+dhrRl2yKJDdIeu7wLE9/x2nD3BzS6
L56zTjy49lNaQMdNMGZQkHDsIAgTGHvgBfTQbUMQBs3BZRfmXhR4i3/fRb7u90C0VATBOQRJq+Z5
G669xQKjoNOCPwZD6HNNYVD/+cCuNcZvzuXE4ZIL4PwDtz7gDM1daFILrFeujZOJ7GDqvRVNeElH
cHHxywHVS/TIW4ZPdei79rUJFvtWYGHHyWg1CeAC2IsMCRgaX0Z25Mw2t1OIXc7+48MDuN7EXi8S
SF5XKMg6cGxnRuPUEk/8FwzDUuh4s5AV00plb1o3+IHnyE+85th25lW6S0l3Jen2jwzQkXSdAl5m
WVXSa0nafRPyRtLdvA0p5/1kRz7hHDF1GNuxt109XIt4DjdmfnlIHTzjNcu8nWN4RcbbKfN2j+FV
Ut6t/5/Aq2bjXt/cFHlv8stDa6CBm0YKt/pMP/DM2PsMyxYYXD5uYwxWQcDOIVy46AUGlroUquX3
OQTes7zJs5v4vYsXRv7UD7Dg2BgAmUO8SxZ5UxqFNIG+/PHqPPdrQb/Js+D3qzomnjOJAhN/g0nk
TEqBSeOif5hNydnUk9jUzWiaqfQLUm74Pnd2+ZIwyYo0B4NcRAuhMkvr79LdhOvAhXCV+Eukx/o2
oTp2EkawTKIInIVnBxiHKxYwRRlGsf8NxdDV3+BHZ7YO5tkN/hF+DNbLEcqOowL8uAjRPqUcJBGt
TyWHoSG8c4HVYxf4BO2V11gz1X79etVzvmOZD6Q7dzJJ/biuuDgu3flpjwJLzHjRK5XtK8whOARh
ZmiVsp9iSsaQRPZyFS78wANsKr5g/WeNJZH8Alp14LpiqnUDj1KQEY2KtlXN4838h2IospCqGNuW
NlOCml6s7KkHajUkFkiIXjFYgV5UfKBIktKncuzDT6sljIARJivI5gUJrUSMi4i+BxuIX2EyoXqi
uUfN6A/XveFvaGU6V51UAhTGqtPDZWeA9dbD8HpAM5yMHYvRD6FC44kJuO7e3gJUFj/l+mN4/QhU
migoDXHpkotnXAB9ZsoiTRjXJrviClwOb3PN63wP6g1+paim5RDxjURVvw/1OpeV1hCYetUR6Qx7
d48qVpfDvw9vvJeXF4mDeuX04BabV2x+daHul3VIqKYwUw2oexT8adDNVDVOCRWzXlWZTfKjJnU5
6HVSVCdbgD2odapSjT2o/c7Nx0xWJ5W1i6hc/74FGN5uZJXLyg39n2As98ObhxRVpBoQnX8C6tX9
fbZaRqoBcYJe92sgN0HBDSol1U4mKwyWD96EWDqr9WApcRQy02NM8DaknRNpCbbrYriOsfrJ29Bd
FqFbZv8KPvU+fup3+2A/2f6CQkylCzMprcHt/e+HySCP+4vwGXPMMg3/e2PucWT/G2JOGNzcZVV5
TTV+3b+E1FteMndBvF+yK1478l0YUTECBaINixSkyvLJn8763hIKRBsWuYyVniJ8krXGN5oA7YAm
chpU+HhYLWNn7FaG6drR4jXPidtJV6XBq3btfGn/6jA5L8y1VvD7QMqGqyJLPEpRcRssrluWsks7
iTwPu1DPHslETHztjPscVlOsNsBh2FToKl7TfcrVlKhhomqqI+oWh9aTlIYZS8gEiSkvRquSJaO3
ROZDPCxjyUuVg/iWxlPyc7jt3dxjUZU4s/Z+g0nZuKHoxwpWYhQC4yyrGVHh+w0uZdUUyzh2zDKn
bmoqM44a9HNMZUaaRyKfiuls46A+2Az6zUd/iVS9exiEUdJONyEqOy3vCE0Zi6Ru2M7KH/nuFzJZ
2gpZ+c72MusC98XDCgIvI/CjEEZ3/d6uHDPUMngu1m9YtiZ4k389CYKfAtG7TyeSsoqvuQq/kAqd
jHQa+yNqC76wKkwKgE/akM2e2o/NMQH+Li5KingOH4c9YE1RcftMqLvH0fChM7r/nwdojNcx7Yus
45Ef/Ym/potwbC/khcA8t6B/+ya3H8cq4lipwhbek7cX6uG/Weog41egdjDy3Wqi2tCKE2itt2kz
/0EOaPQvrx/PpJvScYgTBhN/uo5suU/qBxMKC/T7QIHou+RQJjN1WzCe96W4Om6ty+AwWAMuMKmS
EAI6g8/o7wxmYbJarKfyepcniEix8Qgth7r33ccD7KQfvKkfJ9TfY/yO7ae8ZTvqzOTdgPs2SCvq
wvk6ttxRGHR6FPTDdeRgkJQJl25jBtqel0ztVXtz2ebZHlzFlq7CUPKu7Mh+8qNkTadvKG/WluEK
jjHnwcyO3Gf8scsee8l6NVp5kbNat+HuYYSqH7YxmaG68RZtno3GfhJvb6E7xm15IXMkXVWC86D7
gDht6C7HnksHZVhoyqD+gfa/fp0YiivrmFjhmiYgYuAKzNk6rDVFqJWgvEKupk3qa+9jAfn4giv/
oTKrsm1WBMC4gpZG/3OoKHPtLxK8T9logSsfo/mnVV0YuV50Dstw7C/85BXk0SbpPQxaAI9yfymv
PpiFXdUu9G/pejgh5sHApSDqpeX6qNe//Ni9+PC0xHvrb83qMWiES3zx+XPv+kJYjjA8TTTtMTOb
qsPtpuW5RhPdbix0NhbMGCM5RG5r6V4w+l48LdMfLn1Ts3h/93jxGK09+K3798fLq9vuxWohJOl6
HiPN7eXdR7w1Gty2Pj/eNE2IZtMx/Ln2q8e9g941WlY8S9t9zE5J5JMKaA2gIXXWptgtt0MwHCVe
XDHga+J6BdqV9WrBuMKZITZwxjloQhWmuQevR2bZ3A+na5qyFU4/x9ZCcHWfdKUDbbTpnypubadu
jUZuKIpuCJYiQTiRBjFKT8ErFrnwaEuJZv5zSjHK9pAv0hDzs9yGpAA8gddwDW4Y/JzAsx0kec2d
slXiZEnivLyi2J4Vyg2WtQRtlhXVlUn3syCn6EwzNTH/oOi6qQp1vm2ooIFuZ87zMOMg9jmgIgWb
b8pZUi035oCVtU0P8RFV3njb0BV03rnMkTibigBZIMvRswkvbFREUtNVAZ0DUaEOMulMbEvPQjJe
TOSOIdI0NCwuYX5VPXrEz2ou+TOA7XYZXqSRlwCkWe8BeFpKQ0gBjHG635UCZJtfCACoH+jXA2Ay
XFLPRgBOngUkgFEAwPZ2HwBAi9SbAYwdJQdwmKNtAHAZ9k0BAWipMgBLUYVQMoCxIyxTAtCSHgBI
vJdcgoISN2iQ2k0dQGfmOXOyWTT4ZObHdFiL2TFGy52FAabKGG978PsAMB8B1lVUm0C8xtz15BPV
Em2w1Wrdzyu1zvD281UbPnpBjLYbX3DtHD79ji4yDS509RzuKRRcsKZyDn0/uB/TayUYCM9lGXKB
4esOkZFtF/aT70V0qpm+AdL5DP4S3XqJkUaWSxUxMLtibTZsC4WpeTnT1ujgt5KwcGR0VSJIbGeO
tRHl74uJYsqzOIjDSSKvqPaoNOYviRdQ0u3074fw6tkUg2voOmEQhwvMQk64QPWCu14uX7GLevId
D0z2IrRdDiflgC9J8rptZ3apZisPO2n0hTktUkKHAFkRVTluseMEHocdDP4Lf5wVnGtZmA56j9VE
QcehOC+hWErL0jXof/q2tZKCumkXFOeXgyKc62HwQBcLV9CI5z7t/JxhS2EvMA3i4M56ISN4OnYi
G8VJ5P259gLntdUC1TCNlqVgsTUN+73BEBqL1T8uSA4U46w0sIax3XdHS/ulnXektDlg6CYs0T2X
6yVeMl7kETqaqOesIyosbiJ76T2H0Tw/p6Bqrkit4NSGXfnqVBtK0b6kAcUskg3zEhNdBh1m6cex
T9VsaV+HM1PQXtA6SA7kT634UhQXpvrWW1+2UzzERg7jIEca7IsMlnKQIbXYuMShHeSgnaBvXlTi
OCxU4CUjZ1EewzrIMV7M/bBAjz5/kB5XZTKSDlNkUtJY0IZB/qbZYBMVe9cYZ0vEIife0HRCrP2r
hCjKkl6SoTCDEXQVRljq6tDvdLFbCObFeSoql6isDY8zT24QLUOcRhjRHLIQAI3HfrGMQC4cIvWm
5bON8RrtznfRjJJZ5NluXDBVYaha3ktKcSNcT9npyzf4FFEQHdM6mvUkiWyS3t42VEIwU8ttlAbD
gk6W4xteehkQZeqSwJudo6XcA4Qb9H6s4tOWmEPvw718XGBGLaAaWq3HXr/70IYnDEQhpowXhckt
Co5lM3YD/ELIS3HR5HRN3xsMoeiamauyFyTeovFwJmeMyjsTcL0O5XrQ59FUKF3/Su8bsY8Y5TB+
pudqhVcCMPxYCDhAw6EOPcCo3SX7QR8ddK+GMFkm7K/noDZdz1vB7dXDuRxNyNyZYE6RQmCf+znb
QWvtQmM2zbdd2rDzEXXElJmffTeZ7ZAX2vUC9dQLvMh3Ngkibh+ATmM19aNl7DQ7TDafOl4MxuRf
fujW8TJmHOCVbxg1V+toRcf2XqZgAKWOOE14+4Rk2bEqq/DSftszbXS64bSdO9U5Rt45NRLYfs6e
m6vlGhMwxuaahSK74XXlgtw/2JQLXqkMyHjzDQQqcujB+TZ8xECvyJYKKm5V4h51RVszVzQmvmdG
yG9QJ46xcTpL6ABZlLeDiAADXdpyY5MltiVADLaT+E8ylTcszdBa2D3nOfusMIbODIwFmDiS5WqC
y1mXahXDMHEidhIufUdXAXu6BGNKnO9o+5qp/xX7ODsh90OzT2bQ+cME6u7lxXDYLYCZAqPcw2NH
VhdYkPG2YrQ1LDnpLQeMz8YHJj4UUity6FQzdh9L21D0UliIBRtM7KW/eC2WjoopaD3TSEpbk/Lt
ipXj11VgiqkQ/KBDx6b9zv3dTe+jnJYbLm2Mn9JuvsgNTiyMJ1/lqw7Un2A/km1FNfHnOHWcr9BI
37raPDwrjaTsjvQGWt5BUiTvmoUMQGBaBpaG65LwXl76pnuYEK8wUZSY9RJzeatT6otLIDkbLFzQ
rIrsBlYJ7tJPKdnLFUdJnTBysclZB/MgfA5gsrCnWxZLYzji2A+xysbEl3hALQj8F95psl9IDWyX
ODsgl9tmo/thr9EP3TVmzmtZ5py9Sb5N/sdyKC0Go2FnkHYOFO3jU4a5nE7RwNBPqiOqTBUbk+x2
6GAlnJNPdzu0tPRqw5ZW1RWreuLsjFWgw3GzfOLcWa1ZDx1ShlO2/8RZxWtj8yrFa4Be48B9tw+P
sqq9De3CS5NqGnsKImC/GqwXi7PvE4FTBbs7MV21kVXralXUzhZ179scqiYd+NiJSR+sn9h3iKDp
enViE0O+/NJRK6j8OHUZVHIeOzGDKs36iX2HCKYwakxRTIjVrKqLd45B1Rk7fsWQeO+KfYcIXN34
GJV/0SrCrjqqtPJIqG0ct7FpEYYMhgoMVRhqJVBjI2oaV7MjQJkmaZRovUoAMzoVGhs+QzeUjZbv
Qsw8zjxv5pB1HbitAq2sOwqhexbifMeRTyeSz37ghs/U14VLifeftIkUeBSg7Oj1nE7D4C+YCS+C
0Iniv8gcHXk0J7AxVW5lMrXCvOmU5gGrIyxG5DBf8AYuYKMuRWLW2miEM64KhU4d/BHt3cPgbsAu
mdJmWPlX5YYvfgjZGw+YBZkzMb6WoPTTodw0oVIyLUGZJ0Cl+ZllB1xN+XNcgVTYeyDdLaRbhTxF
dylkfk5Gk86q+TKkdjJk/vdGBOmNayCN0yGzPzySkE4VUj1dl/lfIDXTn1VI8R5IayOla1Uh1fdA
2sYGsmbip5h4DultdDmxaiCt0yGzJZeQNVJq/ARI9rL5WyXEU3huldDwpwG24S69Y5TIzi17m6H0
xzQ0nplGvBJ8EkIacXDcbS9H1Fa20oXHbXl0KBny0+a3go2lnoSyJ85Y+nEox4UYyzwR7VB00Rg/
Be2NwKIx5RS0N2KKxrST0A6HEyxmT0M7GEk0zk5EOxRENH6ktR4VPzR+pNUeFTo0fpL1vhE1tCx9
b5AYlhlt+ELvyrSFLf86RXaTDJyFLd9pkn/+U/RtzRA7GLyEwXMMXsRQSxhY0NVhDPrdn/ItYNrY
oArqmsG1MsPpXitOuHCLILpZBuF2QRCT9pUrk3GoIi1gGEKtw5B/ZEJYaWTRJ4I0qk+UkjYNXa8w
84IA2hECmFlttoNREYClAvCSAKZhVZiNggB2vQCiKIDFqgIYqQCcBCj4o7rxR8co2ZVgvKpG48T1
pFc8d0DGxfVUxzWzUcvqFLJlrmLszkZP/aSZ/qQP6OrYT4pzkn1EFeq0OQm2Y+jcKdno5G1nEcqu
s6QYpwmiaLuKcYq2qh7htULVazFOEyRPoEUQtSCIcYQgOtu1FIlxmiC6yndA3NLS1MXCHe8VurUr
iFsbPszUe62S0xjKrve6pfDBjxDAsHZtw60NH3oqgFESwKwRQBQEEEcIYNYIIGoEUFMBtJIAllZd
gmL80t+OX8IyqgLsiV/besJRSvFLYWZ1HU+NXwqvBEHv/2j79u62cSXPr4L5Y0/bty2ZePClHc8Z
P/Lw3jjxtZ1092T7+FAkZWssiWpRcpL99FMF8AGQICm7s7nXbstG/QAUCoUCUFXQBEqIoEOyqYbB
aHOKzXShpLYlxcObfg2Dt5YUifHXbr55qkaEKmZQB0QCoeZL5aJ7ef7ekycOx++uLz8d351/MpCb
AmNFDhTy1IKMoDogb7JMAkJRn3y4PkcvGXkpd/mJJCm6dRFKAEEeVYfolyrjqfHO7NBAbaqYIVRW
oTpeXKE6voEq2AtReYUaB3VbudFW4bQHXFMCrk0L4cof6Ri0aYfMSiVA6zno0JnchlBjk8XLYxgb
saiJ+UyM5H9MYmFtvSQOtJp9VbNvErtthpbEsVazr2puEHttybEpvkjpnciY7i5tTveZrvhQyi1M
94yZ6op2A1iL6V46lQ1Ip0brXbc9YqzFdKAKFPHUIPasrW8w3UtjVXNs1twyGWviWCdWNcdmzWFT
X89syj5NVc2mjvVahmZNLAzTbBpUptl01gDxrM23KmrU0jpp2K6fa4tNal1sXEO1+k67em41L6d+
3QfTWOZ+a9WrQDQuUidWajQxiANTt9FyBwfl0gksJr6lF9zcwfHA9W0YzV64TrWVdFuHDTzwrQ2p
RLh1YpHOdEsbE9eYeGE3Xlw3itWN4h2WOw8p64Ji9exKZ0WzDKOIh+YWWSfmNXOcul/wXZ5PNHsE
W5PmZlttcs8vtfMzdWRPR7BtNkhDGymxH7CnNYMNkOaC1QHS5qyXNodbtDZnvWB7D7ug3DDfwkqe
aTSdCO7aNvHMlGdY/kIbRlOeab3pox2iI2gQdELVujVJJUxiajjBubUd1YXVBSUXTC9v7kDK8l1W
J1J32J6wNDV1Stwla+EIlJhB2lyL4h5ZSxQHE1M8PNgu7wVSDUUla7SlWjwaGlbF1DilEozZ9iWY
OUCTCY8Jz4bRkolUOuSPih8bDfFMI2M6MED2oZEehW0QFWAhnf9ur68wNAqmxoiOKQ5aWlw9jgn5
I9therDiUpRIn7btI/kFENP7KF8vT2bZJk5/0WtsntAV+3SLMExHjr7Ce35g3eJ3jmNaj2ObfYFo
S5awtyMeOYlB2lojJWmHUBbTOm7W37Ky7CBlZ+qjU9o6OvWClsHZC1YrwJlaHjoUoBeaJ5Ac9ECh
AAP42LUJB3NUxxChDaMl7FMZPzIqfjQ76EuP1DZIl/aC8p6t/Cu0l+/47fbTmgfWCR+AaabZ4z51
mA3DxgO35oFr8oCZu7ESpJMHzF7pa3jAzH2YhGIVD9zQygNT6fnMIgfMzgOv5oFn8oDbQTp5wM2p
WpZ/DQ+4eZYjoXgtB+4+POBhWywtJjp23K95YJrovrCDdPKgcahZln8ND1y3uR9Pu1ZyPsIt1UG+
m6IP+hZjKNTJw6GO17qkSHtX5mmtBNs6wvWtR1wdark0kPFad7CZfnNT24usXfUOIzf3bH0McCzX
v4M1BM3FaqCG1pXwcA378b37mni4hheJieXqeLiGl4yD7Tp5sIbW8UR/De0r5uEammcIAzW0rp2H
a3jROFiuoodrsCqYzhra19NDNXjOi8bBcmU9WAO33f+DDf3x89VpEVtsFOe6G91l5QV4o7wAC6fH
r//3/vbsfoyOdeP765s7XfMFoXgpBHx708IJA+elOKfvru+bOIHccL0M5+Ya9uwtHC98BQ5r4VD6
Ghy3jYMe9Ti01ajeYORjvq0ShNx/whjNbLXdZAty4HynyaFBHzToa6KNQiKzaC7DxE7f3H/8dHf/
9tPnjxeHR/Dn7W6zUv76ElyFzmANRgVFR82GoHep3LihHxVm4NyiU5W5yatQqCfPZmzs+jBfPZGv
Hz7+8xQmweXNv3ISgt1CKD0k//A1AOr4AwBnJYBLfCDWNgxA3TXqFfV5u3pXA2CsYzpUABda9RqI
c1Slpx3reEEwgPemxONEAKZXov6DUoJRy4LQ2g0YELnbMecrxLc2xH/IhloRBR1q47s24j+KrtsR
/aE2vu/otQ7YyVQXo3yeH6JoM52UodQRBk3I6iZqhqgDziOlY/OTefYrqOWj7Nuq+hmDp/OTVbZK
u7AXWZTU/trNvxZav5wp6yzP56gL9PqbtLfnt5dFMOoWVglLSFRZcjGfYpqA+t0G2Byo9rRYscun
cbZJJ1oIkkxzLL3CZxFwp0jeBQVn+aupH3fTfWmLQamrbRJqPuZS56CaAXlouq/DBilA40cWx3VR
RkzfY14XmfgXM+vgvsErMovUdKE8OSxCnGRS4uluNsNkJE79z5KlSJoCxMDh/TiW9xiS8mxYw5H7
+I/p9kM0TRcTI7jPKCX0UmWgmAwRlx0+gfkRGASuQVCGruVQ8vPHD6dnbz68uSDnl9e3n56FTkdN
ut1qgT/B+IF5MpvNYxn4+01dcTeSvgE5w2NzTEo1gRksQ/llQLDMD4g5popffZsvFpj9v8pQt043
I8xOJP+u4+EhDeY0gIUt2pKrq8tPWmarIyJ1BTsiwZFmACFZUJFxTPuDCZq22SY/ApEY4bEUFWNO
A9hnyzwGRSBkhcCYDAC5/Tbfxo8yK0GmkioU3ocIXRcGGwfN5NUa9MzqWgkuzmC9RG2+1MGBq7Ul
OJBimolQwpFiRdfCHPRS0udYK9XahBaGp0kkrETxLFBEjSo8a+l6N2qtIjCJOjeaFmIqTWkbcXMP
aSXmNmLL9tBK7NqILTs/K7FvJW5v6qzEoZ24tV+zEVMrwyxbMSux6CBu7rKsxJ6duLWBshJbhcSy
N7IRM8dGrHn8055xDkyGXWPKOwxJusYkJXLuqlUKlMtFLiMNIodjQkbcmx3qSKEmblSbgCKVciqM
uURD117akzPP8RqlfbN0yZ+g5k/QOK5CqtBOpXG16arOA3mKWhgew9XhmgOqO121EqciFKrrDqh2
Gwag/CbUHkMVO8w2VCzQhgpPmTFLJGU6F2SKEK3IHpXNqFUuONVGgesj7RgVMtpRTJjFWEcxs/lM
dBTzjGLcaRRDRhglXLPEHnzg9vnBPY0PmmuVo7yjHN+s1xeN0tCywCzhdeAxhecbpfUZJPbqB+ZY
t/RDUG0EXJ21RgeErkyNYtws5nUUc81iQUcxo5eCh0axPXoZdPTS1XrpaZZB4FgsA4G6T5uddgK0
qxYJKZ56skxyee9gwuw1yamtB64+TuhWmywjYswlVx8iv2UyOc7MLO3ZS6sOOoFrlg46SvuqtImt
L2F66VhhJ43SzF6aqtK0Ubqjl6EqHVKzdEcvQ65Km9jC7OUeo8Xs8uZ6mvrTfCcd5bXpmPKmfAD1
0qi3jInl6lZzsKcgCVvTPKatFqFuFtWmYIKOrUYTPTzJ02S5n7B37ZNefybUHr0B87dvevi+ZoBE
NcNDJfyhb/TG931radx1GMVCe7Gp0slTY4h83fbSSzM15oyapbm9dKRKR43Sze7J7NLlOZFZ1N43
kUhgkTSArV2sHModQw34obWLmO1clTa4HDhmo+vzU0stIC5xhMH0sH3FzNKLaF1fBqBzNjk7vcFk
vxaXd6POYLDOqq0/q07XXC7s4tc7J6Rzix1CG7cBiLAJ8frVJtDtlWnVmFkRNCZmqcEA3XaZ6quD
ZxYLbMWAq54aEWPxDwKno3QkS7uhWZrZS9fhC0Zpa/esXrpY2to9qhYo6rBGad/KjMAxGhzqZwFT
u6BWbPlJgho6YrDOirk/rU5/qM6ajT+rzsZGzS7AvbMpbGzQ7CI1ABF2QtRy1g8B2yA7hBSnAVq3
SftafSCCUF8wawfu8uhX2Zeh6bOMVGEHVTirqWZNKn0dNajiuq64TcU7qFLNAm5TuXYqWvYLD7pp
i8rKjfJMXFFZ6rJyo3x2rvDDbVGFVm6UL+EWJ5VtKis31BNpBVXTIQiprNwoH8JQB31Om8rKjfJN
k5H6sUEFC6OVG+X7xcqaDFpU1M6N4q1iRRXxFpWdG1BU1FSiRdXBjSRyayq3RdXBDfV0ckHltai6
uCFfZyhOSadNKmbnhiXvnU4VmoqhfzoP7HIRLuiGa83zQTh5Rt4F11IAe8DxbriWZtgDzuuEa6uM
PeC6eGfTJT3qHqBoF99sCmYAqotnNq0zANXFL5sqGoDq4pVNPw2znnXxy6a4+lvGRCdUW5sNQHXy
y6LiBqDCHqim3uuH4t28aivDAageXrU05ABUD69aanMAqpNXthyivVCCNaFebXaFtLgFra9eJyp9
HdrAjeTksnjlxyNrMS5jdyvLdWzgMdp05JSxPh3OrpWOK1WmHgfRiEpC7xTlr6DurvRKuTWmxeod
XNj4juS8GepS10Cb+O0kG238F3aqUWW7U5aEGjJuI/8KlsTJntU9pNt7ILmv6umr0MrF/58VWtkq
K+RQoWXAutGbQ9bK9SK5J/d77oREeT5/QHe+KiSHVfPS4a1eGcDtUB/aByxqYLcfuJ23pATmOrBi
S7GaM8MaAxQzRquMUEUUz9I6UasjYY1URcSGW/O+kapIag1yfUmkKoCEzl4ge0SqIpi1M38zUhVx
24lr9gqxDDzecoh+cYglgrSF55UhlgBG24qgB2zvqcOZPUXQYOghklpnXQeTOuYG5z8tfhHBrMqr
k0n7qgEumlEEe8ZFIqk189FL4iID5Rr7c+IiEcyaz+lvxkUCrj1uqTMOSidtxb++OuQp8EQrV4gE
y9OtdEnHp3pW8Y/imR7pYqkTM2tmwTJpn+hNgInk1lSCJbnbm/kSya25A0tyb6+UlwhjTXlZwvh7
5boEGGvMRgUT7JXkEmGsSS5LmHCv7JYIY81uWcJQZ6+8lohjzWtZ4dC9MloiTtiLw/bKZQk4wppR
tMLhe2WxRJxeNlOxV/5KxOmVQerulbkScVpCSDUcZ8DCEG5L+HRyuqdtUaYs6oBhL7cqhNuSw9DW
rw6jQLgt8Qut/eo3B4Tbkr7Q1q/9DQHhtTg1tfWrYx0v0zt1kNM9V3DhtaRvau/Xvmu38FpyGNv6
1bH0Cr8lh7G9X72LrvBbszO292vf5Vb4LTnk9ob1r5Z+Sx75SxY8vyWH/CULXtASOv6aBS9oCR9/
zYIXtISPv2bBC1oSx1+z4IUtyeOvWvDClujxVy14Yb/A7b3ghb0St/+CF/aK3t4LniWlN3/Ngufi
wjn04BLTCDx0ibm8lqFBac8Lxur5x/LJYfeofNLYfHIYAH3UVXfn1yTNEWKeP0IL9ngTOQBIRwSu
77UwfYZBTYg5BRt8jxeRu95XBihp6QDUhLyvYPLqESWM79TbXXYSq5VVmFCigNqkq8wWhIJlYDw+
X1x3PUM59MI0QuBaDxCjD/Nt53OWe+C4eBEx+BaXRuB7xoavOjHCLOLP8yTNipNhnQQvrGU42fmH
2ypu7KgMcTK2OX6ANvnn1Toq3sxdzbebaDnLx+MqBs91XIE+Fm83aVqVSaoX7KnrBcGTfAuzYrpL
uYsv39zKl2xVa98uIvkyvfPdD8ugNuc71UhCbEu0XkL3Lj/dyusc8/kWlwqGy0y0S+Zb7bU1bNUq
3S4w9DLH92K35KD0ljvUicMiCeuJjGaTMAf4JiODue9zbMOEHlqfcXMxRyw+SqtemiZTaBjohHUG
w4YnnBNktPFSpKSA+t7vHtK7D2d6/KAgV2eysCQ9kumj6ue/nSYOC/Ao9svb2wm5mOdP5K9dto1y
kuB/772xO2Za2RAdgy/wTz1vr2Iy50Ja8aE++R61KasuJngFWV3mD8vVvL4EKQaOer6nFRWO8Zhs
KdvFuMzmC3wb6DHLnrReocs0vnr+IB/tka/iYfhcvk02QHbwBN/11sjMh0Mzhwc6BTpTnGGoG774
DQ2QkanlY5EH0/zhsAzfLENQnbEoIlAx5+t/Q3OYy/VWhOhPC4ZMDpzF19TwNfTMFvsmy4pG2SSN
Egzs7CiPu2yjfDz7Sxebg2IGaw0STvHQhnqEqNylqXNTdBsVjuTq1e3lMXyNftdIaWEOmKTqNFGS
0k5STgM7KS1IWSdpuTttkYqClHeSuuUjNI/Zdr3YPagjpff4iApeuuEH+fBr9dQoUOnkxb4mfVwr
yjff1/heSo1wruKckfUXhmAglDCggOtRvJ6vEUtevzWa0QOkt0k6HVdAtwsA+SqDetvyIWQas+c0
j2awEcIXZ8k8J/jYz3cwsr5zWHRQthbp6mH7eAJLOExsqUhOHAPEq0HyGBsJsxRXz2QTfTMKBnXB
u80uxde9YW1DjXUSTOT/jkj+OJ9tT5iYUA9+oVXkslCraIaPUauoYrUEzLiyeI/IMsJHtNViMPPj
QP1WPfkLa6rzdKRCbtUHrQKZcap6ezw34lvVQ+Sy1iKYuYzXpoHz3a1UlwdrAubAmk1B5r+8uT0l
X96d2uh0Ah8IMHJ8cY8vEU9IkoHxgovVZrfCRCaFLvLkGC0I4xoxF/UbiOfkNInWqBm/nmLOhmw1
wgE81IpLQ2m+Wu9gtfswT4ooXgLK+Li4ED7+8PH32z9u765gFhW/w5/wmvncucAfJbn6Xo2P77oy
/71qiYb89cPlxZ9aKR9v8IsGXGffoK1nu+0WOrlvE84bTaAGeJ2VQcf+en1299FoBQ510YrbBb5C
/MJWvGm0ghngVSsM7K+3jVaE9YtuWmITnLz38XqHz7zXhX0MlSJX6oHr0ZV8utqIFAcpTTFOm5yP
KKx5sPDrxGin7EfMWsSU7V0ztxCDPrqKNtIYvLs9J7tVrmyHZCeP7fF3j9Fim5cvcevE9QPckivy
oW5t/ZLZL4FVBpknKJrw2+JNcBjFu/dvbq6Ks8aKFka6KHL//7JV6hj01ZwqXxb/L3wZ+Ovd+yuY
VrAWnR/qxVHlvnv/Bqwp+HaHShQnb/Fy4b9pJRkK/y1YC9ECtkbMdY4p7D+cwmgAs4nIlHIydB80
YaS/ZF7B+KGLPP0Is/s5W0TbOfBEmc6V8UHHXC+O/jfSkiLRw/oh2my1PBXPDiY6rkoHTGbbXIAN
IpcEfN/VzOgBBr70744eW5m3tbwbWml5g24pLddmYV+bgUw+MmYhO30PyyH8BgwS2HrDDpbksMhh
UhSVjo+Td1N0+/7uEtwrkNvTu1OpOHVsNFQs2PhELm475anYKv6L5KvtjKyXBHM8xIuMrNGaWuyW
sA4CF+M4JukyJwZyYEXe44oIqL36cc+zaAtD9KNYwc9O7xz5lLH6JVoZMOVqIQxAJNAzKs7nDpnI
Bmh/kwsb/o22/ybP0vFvrP03mS4w2kZggykuRt9hy3p1ekw5J9E02pAlg839fzpVpnaibDD1GR9l
UINsYMqnqyPgycXnq6s/9D/hOgh/4q+rLrJV56EzImDer+fz7/qY0Fpc2ZhynQSvBzpI9hpGN2QF
TznytECq/+45eOGOfxf2vzPcb8Pv8R7YZAQmu1wmuMudwU/bBfzEZ7DTWmI4p3riQPKACh0uVB1y
e+D8Cs434AIF52pw8sZYwUn2l/vi0Ui+H6jlZpGFQYTe4kv15Ori8hMshTC/YJM11RWKJ6NJ00c0
xONkQj7fnsGgOOSXN6vHCDbFyS9gDMNuTjOCD96AGjgsbGEdCS2AEqkePPkC1V6D58k9QQcCVtps
ik4aeJ2kmOEH+6UeaitXoaPaRQf/sNotp9AkqmF6uPvuwEzAAn5Qg1CThPhMQSeJ2sHLLaN0o8rw
DqBcsarspDoYurF3gKFoMNglgFLUjnm155n80HNYd2PKcQaDYCNTpEn+gmI3AHBEd/kUv2AGfiz4
WFjf8jgHWpB8SVdJtjmhiTfFj9cbWLvi7QnUx3QwPHHpBMu3KL0goFezzQk/IiUIdFEt2h/l+JxQ
A5HriAXJgKggmauTXUWrHSzH290GT/vUWs3HYsxHdDyLqT+ee4FXsdHA8XUcvZkTg9saDcUmP+6m
hI7gb7g5Rx7gLyQ3jZJho2RhoQDHtmlsSIrHcPFqj3Sy79QDBDRUOhAG+Ml866xNXjr1dGFheAvQ
gWmberAgUd86W5OXTz0EC6y6LKmmntOcek49c4IiD38H/fDUQwA8pC2Ei/2tqSfBvB6wF089iRjo
iHtNPSTzHJ3sdVNP4jAdp2PqJfXUAxqKxjVOKNY79WRJt1HS65h6UFhOvcxYP/HxgF8+rdOVZe38
ZFk7EUVqWgPl8wrL5LABaoJcNjLd6TiuhqMrof1cpRBBstaO8Ll/dDnefHWQvkQRcB2TdzdHm4jT
KE+L62x8JFQH0ESFv2YiUQPM7QF7zUTinq8jVhNpiNVeoJPtN5F27YnEfUfH6VzDdI5KHx6cHnxo
IgmXN0qy7okkHwOzjfR+tj8ioNLtQBjgp4vb6g7Sl4iu0RzcFnZgStGlbdE11gCP1dIm/q7oeizo
AXuN6MrkzzXivqLrcaaTvVp0PS50nE7R1Zvs00IgxZDo+rgtMkr2iK4fWJVUsr/W9XH70oEwwM+A
WcUseanWdXVM1zqTkj6tG+iiG2AkeDE47t8V3SDgPWCvEd0gcHXEfUVXJoioyV4tugGer9U4neaL
zlEZx48C6Q6JrozCN0p2i656bcY20vtqXd+xmxzJsNZVb8V0kL5EdD0dk1k1edKndT1HB3DrwfH+
puiCFqE9YK8QXUDkOuKeoutTzXLxXi+6gOPrOJ2iqzeZ4TknCqQ3ILo+K210bw/RlffWtpHe78wX
EewGg0QY4Key2+ykLxFdX8fEo/EOTO28xxBdoYuuDHMoBsf/u6IrNOujDfYa0RXM1xH3FV3BQp3s
1aIrNHvF7xFdbefsu7QQSH9IdGUOP6Nkj+h61HlZGvRcNlZHKIb6hQj3hceMgQTsxV4phpTHITom
3hNZCLnSRHlxqaZhFH4S2DidAC9n54Ej8MTg4zV8uz1m+sb2a5G1c/LPs/OjIpPp5PqWXf2pHA08
5wi+CXUufkTrgaK+9DDHlmQTVQX559mFOiRqk+p0ePFh0J1+/r2LTq/QxYVzmeEtbPpcdEV+LGdI
nC2X6EAAvIsWC7LUHA8CGgg8b9ts4/t4meUy3Bxs2Ju7c/nG4LfoKVWvVN0KjUaecTdp4DNpCUFV
KMrxZ0cD8ZiqGBOXL6LNMie7NSpGvGSF9m4fj8gP/nREKC18DcnqeRMtj2RucWRDroPh9avq70j6
fsBM2qXP6WpbX/HAXKivRAN0v6QtmnkWb0GCxJixsTOSn8gBcygdUWdEw8PKiS/HRxOS5Qjo08V/
Qlcfo+0YOK3hB7iPLC6mJ4XvyQOmpFrBSCzw3YWNXhpTGnaVXqarXV02xJy15M3bS/IlAimXbq5v
o3i+mG9/4F2uE2DctRhdRT9G1Nfo5CsfL5mrj/NEJy/26PBbNcneX17IIW8e/9BQOlTO1/fKCXdC
Ds4PZSz4CL55mD6/8N6TnlV3aaTxLeS445HOt/FuOo8tbkuyEDBXfwuA/P725qrhr6mVlzlqB11k
NfkMPbxBucqmeLV+ef3sGX/ie4D5BgX0SXdg3D4C11Y5BrZnC+T2U/pDOpFqRD7ObPXWw+X1JfmY
jW4fQR/Eu61xlw0l5X7g+mpC3s9hEVlFW5T3+RJ9QfFgubgqJtnGzGnSeBYDgfC4WxOMbZQ/oTdH
Xs+iqjRz5EU3gYXwAYZpVSxgYhJ6fOK5jlbQdYqL6ftHXF3xG2gM6UO6jLbxY+2XKgsXN9VD5WRb
G1qotLeK9BnyTQLUKjCH2ciBJZGB4T3h/sQV5DNoudpRVxzW2FTgTu+y4Qn8Lds8gahna9RP6AiD
+lr34wrA7sGTpsKp6PSO3G2iVb6QDri3oLUYDvM0izaJ4WS0hhKgnpfHUvEfy1XA8Cyq1FYoHPlc
F14Mj9GZ5fTuFD0FPq2hpZuYXHy5+PV4dPMbOb0Y+Z5wTo/I/7lw3KP6vpdrWJ5ML1xhaa7yuFgY
xUF5hg7DkdF8AeRUA63Nx45yuDi4vQVhAaOSMk5uiwWVcMc51FFc84pfoiTZt1VN7nQSSxsMm1D2
fhRC78//a/Tlzc3dm98FrBdjfmS4DejU3NOoXbAzKSorGMdYPX6x3C22cxKAOXd2KgLy8fxf6B+7
3j4STo85Ozwip6canhfqrbHxz6gfH4YsRBukVf6PXMw3UPnoNI7RaRT/IU/kP61b6hfQNUKu/wVG
Ijn9eAvD7mrYAtmaJzXy1zyJ/tQ66cIMwIUUpj3MVzCOpvLBDlDOzPXIu7NjxgPybn52qIP6DdDT
7RavsBLVi9LtOX9wioc4NVqfWhv02waDHcDmRmMUr76y2cygCm1UV+iZepuu8hRNZMIj/O4Y1Une
dlQn790mpRsVPu0VJa1fosvl6pfqHo5cXH9Clfn2szbknIaFXwfhZUXnF6ObT1dE+1dORzkf9eko
Z2PXEAqZXwD6EE3wG8VvDL9x/CbIv+N/XPzm4TcfvwXkP2oA13esPKgGTfqqJ/P8qabxQgxuyzd4
QojeKqPlMlbrOWwcxPdj+CLfkIcbkjwnI7DASJwcb76R79Ex6iwGH5MIeJkkP3RU3ELGoCyXE7xA
wpIlnwrz4gaUn3Je5mOmDaTPZUazTc1fU+YKFGhxTaNSIeOWCgw1te/FkIpRvk6BTNstlje8hYFl
3uhJpEDmvOqsvZZ4qiReGz+VKa4MaNmtpGPkE6zH6aKKa/GYY0S1SDoXfbOUoK7VvChNhIJ6m36H
9cTlnGkjF3p4N9xHhlI+ylZgjCSgpGA8Ka0BKJ6NAkCyiWJcrdR/Rw4NRsIZP8y3uGQ6LhjCuJkt
qRhoEhpovB7Y2ztuFOp7e+YJR8cqd+I2LGNrT7u39gZgeRgvAaud/YdovYV1Gy8sHzZyOf4tncal
2akoS7cQSWlu7j8tV/MvUlrBWI0fVxmqUIx+ulzFYzLCToFxMYb/s2qPAaDc9/AMr+TwJhkvdk/5
ifRBXWbPOFrx5ge0DH9NZO4uabpVAK4XyOMdYEjyFdPzTdRlPVJWBlnAyvIcXz+A/n9NNkvNfIHe
wi9wyGGdRgPcCWjFM7C2ZbI+9K0tGD/htOklG2cZevTfqwJMI5YXVoXB80WGjp3t8j1dqE/xYeTq
lyzFol8uL958ajhWi7o+dTal3CNVdRdKWL4C4Z/kQC7go0cQ/An5AfsiIjXQKiP4zNwWfzrUwAJM
iPFtOcfxxg2g4eYKJZigeGSo+LnKds9ptGvEzF0UhyoEtssfv7iO0hDKAo/R0DvATLvCd5yIHWrA
ARr3oFdUhFwVP1SGMOC6Df8OyXNOHr+RgzImmNDiBxPLewlWmdOgyM7VgAowcEEZM4u5UimzKdLt
crWfkFyAXwFaFdwwqiW6rF7fEypoTPHdG1qR7JbLH+XsD5zvzK3J/RB3fH0jcV4y4Prm9Oryo7TB
vmDMXwki8GST9oOMx2OCohBtcmwYbJKeYQolBoToh1A7NlmzOjtR7TEgBrpydnmnohW1wz1JKXBT
2ks5z+q9modbkrGbjmtDSWLwfoy7q4vbIravdo/VEeRDIn0IV79fyUmnmICLzxHuOcvhTjIDzB2Y
YednVTtEox1DkxNIs91WZrclMokdh42JI/PZcaEjsQG+1kigGx1cGrk0QPFf+a5ggTTAmxqJSSRG
OWVYhmGzDKQ9GKOQuOwd53xGCaa4jZ3ARPKGkWDCrxSfHGESh/sSA2vwLVmdmA/Mt5pYccOomQ8I
ak2MDOAm9/ge3FPEQhKbzR6YoDWxK4m5TiwGJOAalEutIvBEsZhtDh71wnYIw2Gd7+f+21pEwSjm
A+PQCUtN2DO/llfh+2xAnXXCMgP2wj03YMXAwHfCchPWOzutYdU7Ga+CFSZs8ObCgH0tbw3Q0K0s
I4F39ANyoCgmuCYmc2kw5FuMqcLTuSUgRjPcdTFnCYZm/jRfr+VanOHzovhTtpYv9FY1+rB3Ri12
d3f1p4pVKvYBsId5juYL2V6wfteP8zivNiSChcJn5Gl+ZgAxA6iIT+8FogHFdw1aSKJEMo7TZIh7
EZ2ebXSCQa1XGlxgHV/Nz8gXfFv24N3FxQ0/1HFQ8yy3G7De5T5tOc/lEaI0C0pr6qi0pki2AINR
7nNH0yh+wi1k+TnOllMY8TKkQaGLAYHBxA3YunenN3fkIALbErcSdQNhzxcMTDzUMekKx3gDU3i3
elpl31YGwIBWv/syojLGfpWVQPlRZajVSJ5fWxW36uwDbIjpIlo9yftq2HIs1/K0BEcO9u3QnAOK
MWOw3aHO4diAqoT+Y1Zu9csDFWR9C/evXbr5YUIMMEYlJoZRWoBY6nFsUSmdRypyVjtvR/NSY58L
21x3YMnnNR4+v4tHGBiIQhZ45XOQHxpYA2pJng5uQBV7IT6nmz9GOKqcB/ipCNwDWcRPz9lii4Y2
pa6z/EJm0UqdYsCf/5dR5cASRYsqme9qVbquo1XJHfqSKr0BjrGiSmFUGRpVgoAYVcKS31vlAGPj
vXrJ2r0sK/HwkLM+s5fXp1fy+nTohJ7qW9RqpwK6wUXFX94BLNa5xDz9cH1L3sFWIr3OQGJfhu5V
6Fw4bnHUxUeFi8dst1gMHnXtGkddQejxkGlIQwc5IuDGQY5DPQNLdGO9+CBHAnoaYHWQA/sbWBpx
f3merTcZHprXy4ckCzQy8xTn9u5qHm+ydAHrxyZbweKlCBloMuGIwrnDLU8QX8FWNmaekNk8KqQh
toZJpLM1cELHwHK7sV7I1gLQ1wBrzxdAfQv9Jbfr6miyKK+zxeTnqcDDsKqwj6+71YIv/9gANqU+
nhfOLsea04tzjL6Ix1AdfqEDiz4RfK02ge6FxWnDCJuI27uJE16cTpCLY9zmTVRzjh7nmIjCqa+t
n+mY0mKif7W29U/MugCwI71xI2rkPMB2gPUU/PxeG9M/0GoL0Hmov9dM6zVU6xS9p83e/7O8i3wF
A2jZJBE4jlv4Fvp/QyOxsQdzsHR59PfRSJEb61NHuI6jY3miG+vFU0cC6o2rNdL5FYOGnzG9qM+0
ouasOdtkUVJ5imBxLs9TlMsW63TuwpKucINGSW517uJjh8I6h3cw2XKd5XhHkP9YxbY4MyjrOfJV
pL6Fts4kVSaHkceEmCJGWtJkmpEZ5zPXK0dB4so3UmbTGO956qPDg9nUOcS7v/Vmvow25ZlfRQe2
saiZPd5HqrhVqjhe2clwoL+V0wVhXBmKJ3O61B3pTOpSUMjT/6Vxmr6OVnM5DvPZvDwfVaXDak+h
H92Xw4HuS470Y3A49aQtrY8QTtblHJ2FKvZTxqW3bXn/cFteHawXP5bZbvtIkggspFVZngvGcde0
j8hwwWUCPG2IXj5dmYEW9qF1TVjHPmEVpKaXxp3zEH2Q1jVVGGoeHEaZPdQ4QzXuH0N9x7JO9b25
iIVVbaCxUKm01fmpez5BBo3lR2MRY91q3GiuTX0z2Sh9BeNjQV1RmpTYXL7HZBMdk811ApcFxo1X
sjTuuy6uyM0pNL152YVp8gIfQ+Q02mVi0F5ddNLi89yO0YeXSyM30Hgf2oulUUJ6BuQe0uiKIMCt
+c+RRq6+N6WROlp1Id69d4ojR3EUpjjyDptqL1nkDVl0wzCQ71UmIFjoGR0Dd8jF/GG+3Tv8tEBx
KxTYKPzY4EnBQXxIrkHnAuSnPIfNfEmAy598CQoJRnVeTLSrMFzj9gIdw+O6ZvWA0lcKa8TECfDE
/2CTPhNW3vAhJJOhtJqDIOaPKa46yXIZO5NJXVg4eFwtf9uuDXiH6d++6o36s5iBF1enFQrmSoKm
zOab9Bt83WePZk9wFU8wCyHG/srRckqBxiteVCGYtpFc3pBf8T93shHpd0xG9NduvnnCjDrlOTmH
vShwDQz+N7/fidEsJwfomHKIGYN2K7QTZvNFWrjhyRxNMjEk8iDaRtKBcYx+Muh/tAJdU3HOh00H
JjQo9UB1rQcNAdlDmT9GF5bj6Y/RbjdPjlkYMz912SiaOsFIxDQahWnijwIvmjLPmTLHn9bgYGtp
S+I8z3cSm83y+ImMIvJ3KwjVM6JlBa9Dm5B4kUarI8J89Og/BkgHcy4iR+GXTIRu6B3zkDPqOYUf
V9mCAC+kND16k8oBwV6+rjFq9EYZ2WR1HYGPnmE/eegDTJynLR9XBdwGM71qmLIfWGVJiI8Eck1m
bisbD0mrUn4gY+9lrlYKVnozV6sPc8ibsEP0CQP7KgaAE4pHw/f1Z0zwOk9O8Ng89HwWuiRPc+2j
qkyMqRvIt2eq2SiPqczZGG9SaVGXaxRuUN99Bk3KuZDJoGmcxqnj47JSZVQB6ACz5WipUTEjEome
t9FU+crKZFiYdBlIA7LZAePGJTFzwgDTCryO2PccPJepk7KGmP4Nj5WpC7yW4ok+E5LHUlQ5bAyy
BRYARq0kMBOgbLa5BkpxlatBAw7yH+V52mhHRRGotLk1xXW6WcJcxjuU9RaEANj9OF8kmE5OIpHi
rEgas0k6m2P0E/xxnS3m8Y+xBszwMLACRmeqaJo9p+X5e9kw+Rjfuqo1r7Lh4T7pW2knF4ih3tTz
DLMXb8ucx9LMl8aM0YrA6N5t4dW8W4MWnKsUgWCSpxs19U1KX6PUcg6jI+sz+kXPgKvySkT+fIhp
MaE/sOjP8vtS4euAIe8DxAlWIaoPg5Dy5apuyCl8KwDxx2E43D53w+HQF3D44zAcc/rgtst11V/5
cwm4RV9vdY93e3lhIHKvDxG+dNDy4zBuwPvHGmSjHmz5ocKM8qcWmuhlo8x2ozVSfhpiJpMBzj1j
M1+nFab60NNEFoS9QxOtstU97IGTGlP/1XBj8RC7d5zWW22U4MPgGLGwX9Yfdw/pdjGt2lt93gOZ
0j7k5V+7dJcWsOrDPpi9kpqnC/xLLVTl50HWhrxXuF6slrjb3/uXz1Lu9vf9NYj9MwotmAIQbdsS
73u03W40FJ/3Cn2Om6T59oc2KOUv+pnInZDhprk0h3jbHAoDf8IPJ8UyWSYx388A4hQjhMqHbJOv
6Lx6u5NhDni2UKEVPSvrgEWZC7HMicd39cLGeSCT4OlgMkixDrkAQjyhXODN8hH68C1+4DKZpAuw
OTHPloPnYzsMJNxmZXwQFq4rwSOj4GfKAJ7s9uuU+GGT7dYFpPrQP2rCoTKlu8GJdBFN0wVuMI+V
HoQfMG808MR1gJeuEBozBaWO37uov7xV6D/dy7qXQzJfJnT7mZAcU8X/XEjBadi7xL0cEoSG9k75
V0CGMsH4z4T0wCzvXdpeA8nrF8eVaBc/Y5JgEOiVsprL2at2kge/Xp9ekV8/XJ79dnN6TX49/Xxx
eUd+hYZdfvz8O/n18uoUPv1x++XyI/4eyp3f/HF9d/vm7vP1/yazNMk20WHdhjD0eUNrpSpkcYVn
/aA7/v37Ov+PajaBppQJGHvMkt02qw0S+aGfER7siGj4MxWRFzour14VT0b/ne02q2iRfMWNxqRI
zrqMvt8DyAn1vXFwJT/KvPyMjekVKk/10RNj55/kKU3X9xjIchIEY3GlVRSgQ29HRV9gf74DpIfq
JRgx9sHyrKMcmB/0RjlAeaHel2kePmzSUXH+YDtdEGNYj1Vwzyq5f0yie5ltv863MK1eqHBt+aiB
HlQvdi2ePQQOo3RCziP5zgE5v7k4RcHYrRPYz5Nv2Qa2npv0YbdA57YfJMmW0XxV4zBpaudPP9ik
+VYIBnFoBUMMzcCCRTvD4jbuj91Tthox8vbNrwR2uvhWiIqmIho1d9AJ00Ite+l19dIV6OdjIUu3
j+oIEW+eJoxOwukkTiauO3HrWl1PJqCYf1vwULgTeUi7OLg5JNc3n45/m2/SBW7D8W+nZ++Oz95h
MLgMrD3PVisMYYI+FDzB9skJcAQTYLQFWZskuVGRr1VkHPMyx+EjjNtX9ctD6Gyj3RkAAMbW+GVS
9GWazKPalWyicqLXZUP5/JYqq15IiqM1nt0bNGxcn9IEvuPJkKLnWBLALJOnxp+/nMscm+WpT1do
EjnA2KkJxhbVIuwzQWtvg07SobuBaOzj3QA9piP51boToFqNLn1R1oCiuzoA3gHjJYEK2DmXBzJF
8QOMSqJVBzFEF48+5nfnn+6f5VXNfXH3iIkc8POo+HziaESevLRDom/JthA6Ah/Jb+jzeZE9kDuZ
eOeiSo7v+Bq5LwxyNVARuTx/D3oQYYqxOviipin6CcCvz05v35zga/Weo/dARuPXaJryHpPHFBTb
NI22J9xBSx10VPYt+pHtoD8aRiDTYW1g2Z7UTpQt27kqT6GgU82FYtpOSzfQnQxwBT0RwQxbyPfZ
CGiwMaXThyPCyg9RVcLAFV24lSOu4nY1t3+bv53jTHkqZ3kNpxLAnn64PSU58hiF8xh0MX7do4Nq
PI5BmYShXCaVcT+R6XLvgUP5CcVoquTY+e7oX4dyHZzk6zR6SjdGbeFwbRQ2PvCvoFb1ODJqq1WP
Do3XVMPQPhI8rhUqQ9QIkGbdqGIf1AAJltkqm8jv91J6vjsG0B58pqAe4V8yfxgpBEaPmzDBPjAM
CaTiyCc6NeYLGab2iLrJAzOBXM1jaEdsgOzDaARRtKlBuw87aUA0GoqnAHaBl8umb182/6e9I+1t
60bma/QrCOyH2lhLfuS7haaoYyu20cjW2k1bwDCCd9oP0bU6cvTX7wyPdz9dlVN0ISKIJM9BcoYc
Dq8hUJpGfW5TNEHgOj2NwEQPIUsdBQ8eTuCyr+DchV7wcZyEsn0wUIFZ3z4w5IXVuKU4ff6mtYc5
o6A7fP0hiaKI+yscA73Zoei2OGKobUZ8MW0ySxbPI/IDVL6NtW/P5j+kzGyNoZM7wgOUKDoYbwcf
wIIlT8IA2tYJmcbw3dFOUmfkDYYtypTpUANPnIZB6ONDc/wDzQgeOOPu4hw3xb2naITBSt5idDFp
r4+Ue2R2rI7W1jtqo9UEO27xcx5nYYiumAGTY9Nkn8j8izfFnVO1V+R0CBnMEqzkt66GCy6QybxL
iQc1ms+7KeH9vWJNNero2VFeXtDf+9cwF1h8ir4VL7l+TmaLpTcsDKIsZURtBwPAxLgzzi+PHJ0N
rlOfz+5QJ60P3rnG+mRe5u/17qT0NsNugbLgnxLwjdGRRj/9v6RNYPwUX38mvjcOvyTh4hkmDkfo
6XvQBcdj7+MTsObxMz5GyWxaLJZTYs4M/vwz+eXqT+AODST99TPh7yfjd8wA78qN3iYn/MYpfBsV
+KK7WeJr2nm+To4v24Ivq/DFC5QZX9fYjW9ZyOCIahlfk5nabnKwy3xtPCGU8nWyX1vwBZhb7biy
8eCsJZs6QG+NTwifw7zBk2ZaW3PbzE156ZTHnS7yolsYAeABNgnLIyd7Lk72ZhHOrMM0xE7mU+KM
A4s4ZVOacrC0mhrR3WpkQaN2Crz66iv5IGZzwgRJ5578uEjA1R7/7CWfvT8Tb9yJ51DsTjDpLD/9
dEIGEV7Zup0tfS/Nw6b8MbDmyTyahWAxlNN5+WvVCoHZYTC1Q8+sYS4ai0hPYNq/dcnl24zK4cEb
Mqq7ilVBH/BJiLGBA6MvZGM4c32NjXGabMzN6VlN++c8rV376wqeZVuY59LGUB3b89TLdtA03DxP
m67maZd54mmKlcudGGAm1+z84ac1zQ5dWlZcerH/6rkPwdZZvckB+azeKkEuhlk+lGLuo3CG5a7e
FYN81hXOxVcaoW2PYxTqGM8ofMo9EAt+DEyFxevOSwxdNz+RD19DL5FFAc/HYDquDCdTa9vIekBs
ge2tX9hB8yrjIIkFVml/M1KTovd3dnFxd3578+7opvfrRe+3jx8Gx4qYB/GS75hg2JlvKa1r80Dr
b4fLaDGZLJ676XOqePHGyuO5G4TV02mBwixwxnNt6kQbzOCDbElpxB3LWfURZsnHrvCRTz6LR36b
yJwC2Xt2fjbYhNDGEAw5wvvz27Vk4I3y4C71cxO5mRYns9EXL3utllCzo7MO67gpGwoG1Sjk/vam
NyBHPXwJEcYy0hvhkADEx1xJ6TuCktau0oomJx71EsriYVgCb75IScGnQ2XdDc4L6hUj/4eb6z+U
APgKNr8uKp4e7BRYuFUWy3C6kogHciwTLYJ1RKye6Obd/WejQ/n9U7lesoKRo7u4/1fbcb4MvbG2
oueYtskfzlp/HN/ia8p46G8tLsU3NTVn9ZYyjgW5YWHFmEDx1LDNl8/WZs0wMqk43yur7i2hzY2x
oeCqOdpkR+v6VtexupbfZXE3dFJKF4NFpZTzCBfo8AoD+CkVInK0wPu0p/JCOCfXbWw7NRlnhcNJ
rpbhzKFBJs0lq8sETULK4O4PcoY87qL5VASCqeEReFPPBxfZEEsCiyUuPnlJ+IYW2NqsWq604GAZ
NLfGPJ9fnd1c9kotzY9AUdE819R0rcNcPAGdZjGe8IinZDZZYr9W8UMVtu2Irb+1Gjf1jm3g+adH
3GhPQph62905lOKBmmKbJ3rib4/zEMcwrBEDpuF27JgEROZ5oe56UUCi2Qz8WYvv8Cd+0IZhw+zM
Jw+G4fg+WMF/Uw8feH5svTqk/+uEd39HneHk6QXzwGHVsgz8pGAp85+YTPDrX1EMNmloum7SV9D3
DMN4RbQXLFOaljjVIuRVkKzGWwf/hyapA41fI4khEVw8wCC8YHA0HtVJAN1IAMWyIrk76yPYjRW4
htZTtL4E4pULDGUnN81ahNRhiS0tDEECXpeHjAKFEoR2HuWWlyEIHQmVDNRr7RIeKuqwoRhYc4UT
x8VqchYipEk7jCObVqRAeHQnSe/qBmP45O8vIlwkrnpwDA7QAcMPmGvHGQZOlThGYBmCR2j6IhOJ
4c/nLcyaiTLEcVnUhOTAkQJPxzxGlxZweKyqEFfhKnRLO7ZTaFVVKVYUN2DRFnpOdXgSzh1rQIrT
DDVazyrgWExh6fVYLscyFJZZj+UjFvUlFvXrsXReeA42FZ6ZK7y4I8SR6tHwplHGw1JAq8yD5XmU
0HB3MuNhK6Bd5pErrFOsVA5Jy2dUQitcaOLyCZR8whUaoZHCipplzfF4g8vj5edWacGqaHIqxjOL
VWYN7c2VmcX8YkceT8KLmVXRcN6OOTHVHK2Gagm9Z3h6U8sGJEMhGaJx1yKZCsls7CP49jZvAfxL
DoU/mq0rFEehxGUU2ZJqkDypdEuJxCqVQpzdSenLSNfnV+Tqgp9tnbSwaYm6+AU99fvoOF9fcpbk
wefCbOvxI+ZcQ5MzZ/UImcGKAwWNGnqz1ooj1aLhSzWLAhjtC1br9mxwfU44LVXAZv6hYhAqBleD
3q+EK68GqIrvIil1JJT6NUWrgnN1lw/ScmijsS5gBXpRtfh2KhdyDVIavlmCDQUutUAvz6OElPKA
vzElBqdOB1VwoaKugrrNSvAUjmfWZZCB9eqwiH82FNyoh5sl9oUCepaCWnVQW0Kb25Cyp/ClTj5V
cL54JQxNYLzHE9sEWzLyl+04dpsH9lh2NsByyn2NtuLYU1C/DIVaxqobxY21xBxSrKAuB1WJuM4Y
1IGzAvzd/vM/PQ3n0yD5W+d/1LZ0I5v/WWL+Z1mH+d/3SLyLdjQRCMCfJeFT1K0e8FSP9gz6rmWe
Xor/37uWRvoiHlwuhMDV0hdX97XguPX6fumLDSJ52EOGFtcYi1qv3w09jPiArsHIwwXhExLDJ+43
zKPhSfrCn9Z6fY6LevgcU4I7ND964m2PMBonUfhTq8UtCVQDbc8OtUCy3ldck5uTO7wZPcCVZ1UL
cjSdTZ7aSUzQkbnBoIUwb4twbvd4vFUtwCx2VYCeNxjhZw5cxiH/ReHX0p/MwmQMBOJ3FLQl9Rug
vj69JX70nIzDtI7YgdA88uk7Oq+t11IjJcSKj9t6PZhFcbQInvlJxlEtlSZTOqdL/yBt8TrFvFaz
XHHoCI/Y4HMjYHMiXNTkisMnqPlZ1qwR1SnPYY5Gr8gRniAl7/jO1bF4TB23lnIN8F+G1BwraQ4R
H3dok3iQeTmq6vOEXN/9hzCpGREzylsQfKScPPBz/Tp7bBJBGudFioDuVQTm9xUBrYhA20EE9l8Q
ASO9sgxYjQxQM72XkQFLux4IQLnF5EhnbT9ZYPTUcXua63HHUj70l8cdO1FUEB/M18gZTsjS04sb
Cg8mcoIuJzsluH3ZbyEimNbnRSQnluTIMtaIyNpZRoWLKUJQwdpholZM+SGCjw60oYu91PjglsYH
d9PxIVSGO1w1PpRXW7YaH9KluuwP+v7GhwCM4z40VmcQXlJjfklj/qYaY0qUbKXGSotxW2rMKGvM
3KfGjL1orGkYeymNBSWNhZtqLFCiDFZqrLTIuqXGtLLG6P40Fu7ZB2uyjt/NB3O2dkDCPftgTebm
u/lg1g4iYHsVgf59RcAqIjB2EMGe3dC6nvCCbqhWcUO17+mGRpt5V+lUHNcKOaqQUlxoKZQ8gHTw
YOcCsty/uddL5l4vmnudNVvy0nbiJgsUNAbZXN+frR0Ve33RsPrH5P3gPBeTcS8eelP72bAKlFxf
9PI3dJtq8bZ/mtXklP/f7h1z6pp6ZFp3PPLQ52XFYJUDvGE02H8/oVbJVsBgqmyF81iG6bGh+kkF
Ru0VdHYjnRV7Wjq/abRN3sL7OE2Sr0r6TLzvG2xgnBrkz+nPSkaqxkpD3+NYtKPtIn3L6l/9uU4J
hlEWSuQ3ChNgjoQZVViwgi5YQRcVBoji7BS3TddbTraz5eTbsFKxOrnvc1O14VjDsXc3CCW98B5h
V+pvb1R/0yqLlWrBBuNuAtX6OB9BqwEhyIjb+PAhnoGEmvP71bl2Pv4twXgCeclcOtC9LqN3kxk+
bmhpWp9c/ioDx3q05HMI1orfLm161doG2pOc9OT+/gbjrtUvtLv0Ucp0VaRB5kWy9P3JtYspOuuX
1RVlq3WUYf95kFcvH3E2hsFPQNb4QDBmJI83kIcwmfNHnh8z0p17ggzIDu1AnFwh75JZhLffodX3
ej1Cddc47pK7JJg8Qwsg7xchuTPPHZ2RFF7tDGauBVAo8e1+PS7LqFW9PG3zkoajeHpHCo2S+wux
jZPvNRWRMRhCLk7vL65vT/v989P+PfwbzCaCUp2cU6GX8+PBCwjOqQjO3Nzi7LYeqMJRK6kxdZRv
Gs2S6XM084ZVoZkuUxtd94sk+MS3t6sCo3t0x1bIyHphGfFDaFI8+lrxfL1oDxIecp2cY7jrci98
CaGYFZlsMVKt83LFqTGS3t3J96a+N/uM5U9frP5GLjEIF0qiQxyn52BMaZjUtHswUkP7SLnsRSwr
F9dLVmi7xfXCeBBG6XjwV7oaHq5ryRN/aUii1Z5rXUAjGOEnQ2/8WBfVqNbpqbKVcqUaLpJsK9ei
WySPLK5vbMbO1l0dgTycbTmkQzqkQzqkQzqkQzqkQzqkQzqkQzqkQzqkQzqkQzqkQzqkQzqkrdP/
AOHMljAAaAEA
--14dae9340c418eea6604c3deedb3--
