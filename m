Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752431Ab0JPQzp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 12:55:45 -0400
Received: from shiva145.upmc.fr ([134.157.0.145]:64144 "EHLO shiva.upmc.fr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751063Ab0JPQzn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 12:55:43 -0400
X-Greylist: delayed 795 seconds by postgrey-1.27 at vger.kernel.org; Sat, 16 Oct 2010 12:55:42 EDT
X-Ids: courriel2
Message-ID: <4CB9D69D.60203@upmc.fr>
Date: Sat, 16 Oct 2010 18:45:17 +0200
From: Bernard Pidoux <bernard.pidoux@upmc.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100919 Mandriva/3.0.8-0.1mdv2010.1 (2010.1) Thunderbird/3.0.8
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Bernard Pidoux <bpidoux@free.fr>
Subject: booting "nosmp" kernel causing ACPI errors
Content-Type: multipart/mixed;
 boundary="------------030504040907020008070703"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030504040907020008070703
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

I observed ACPI errors when booting 2.6.35.7 kernel with "nosmp" argument.
dmesg shows a warning message starting with :
WARNING: at mm/page_alloc.c:1981 __alloc_pages_nodemask+0x5b4/0x6d0()
+Hardware name: MS-7519
+Modules linked in:
+Pid: 1, comm: swapper Not tainted 2.6.35.7 #2

This is followed by ACPI error messages and /proc/interrupts show that
interrupts 0-15 are then handled by XT-PIC-XT
instead of IO-APIC-edge and IO-APIC-fasteoi when runing smp kernel.

Here is lspci dump :

00:00.0 Host bridge: Intel Corporation 4 Series Chipset DRAM Controller 
(rev 03)
00:01.0 PCI bridge: Intel Corporation 4 Series Chipset PCI Express Root 
Port (rev 03)
00:1a.0 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB 
UHCI Controller #4
00:1a.1 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB 
UHCI Controller #5
00:1a.2 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB 
UHCI Controller #6
00:1a.7 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB2 
EHCI Controller #2
00:1b.0 Audio device: Intel Corporation 82801JI (ICH10 Family) HD Audio 
Controller
00:1c.0 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI Express 
Root Port 1
00:1c.1 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI Express 
Port 2
00:1c.5 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI Express 
Root Port 6
00:1d.0 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB 
UHCI Controller #1
00:1d.1 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB 
UHCI Controller #2
00:1d.2 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB 
UHCI Controller #3
00:1d.7 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB2 
EHCI Controller #1
00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 90)
00:1f.0 ISA bridge: Intel Corporation 82801JIB (ICH10) LPC Interface 
Controller
00:1f.2 IDE interface: Intel Corporation 82801JI (ICH10 Family) 4 port 
SATA IDE Controller #1
00:1f.3 SMBus: Intel Corporation 82801JI (ICH10 Family) SMBus Controller
00:1f.5 IDE interface: Intel Corporation 82801JI (ICH10 Family) 2 port 
SATA IDE Controller #2
01:00.0 VGA compatible controller: nVidia Corporation G98 [GeForce 8400 
GS] (rev a1)
02:00.0 IDE interface: JMicron Technology Corp. JMB368 IDE controller
04:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. 
RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 02)

I observed the same issue with another machine with also an MSI 
motherboard but using a PCI bridge VIA VT8237/VX700
even when booting with "pci=use_crs" argument.

Attached is diff -ruN file between 2.6.35.7 kernel without and with 
"nosmp" boot argument.

Bernard


--------------030504040907020008070703
Content-Type: text/x-patch;
 name="dmesg-2.6.35.7-nosmp.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg-2.6.35.7-nosmp.diff"

--- /temp/dmesg-2.6.35.7-smp.txt	2010-10-16 15:46:04.855806001 +0200
+++ /temp/dmesg-2.6.35.7-nosmp.txt	2010-10-16 15:58:01.668384001 +0200
@@ -1,5 +1,5 @@
 Linux version 2.6.35.7 (root@f6bvp-9) (gcc version 4.4.3 (GCC) ) #2 SMP Fri Oct 15 03:06:19 CEST 2010
-Command line: BOOT_IMAGE=2.6.35.7 root=UUID=082f0a78-6929-42dc-8d73-a249c2168c19 resume=UUID=cfa31406-4714-4734-ad27-ef4400c41f0c splash=silent vga=788
+Command line: BOOT_IMAGE=2.6.35.7 root=UUID=082f0a78-6929-42dc-8d73-a249c2168c19 nosmp resume=UUID=cfa31406-4714-4734-ad27-ef4400c41f0c splash=silent vga=788
 BIOS-provided physical RAM map:
  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
@@ -79,16 +79,18 @@
 ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
 ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
 ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
-ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
-IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
-ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
-ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
-ACPI: IRQ0 used by override.
-ACPI: IRQ2 used by override.
-ACPI: IRQ9 used by override.
-Using ACPI (MADT) for SMP configuration information
+ACPI: Skipping IOAPIC probe due to 'noapic' option.
+Using ACPI for processor (LAPIC) configuration information
 ACPI: HPET id: 0xffffffff base: 0xfed00000
-SMP: Allowing 4 CPUs, 2 hotplug CPUs
+Intel MultiProcessor Specification v1.4
+MPTABLE: OEM ID: Intel   
+MPTABLE: Product ID: Eaglelake   
+MPTABLE: APIC at: 0xFEE00000
+I/O APIC #2 Version 32 at 0xFEC00000.
+IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
+Processors: 2
+2 Processors exceeds max_cpus limit of 0
+SMP: Allowing 1 CPUs, 0 hotplug CPUs
 nr_irqs_gsi: 40
 early_res array is doubled to 64 at [170c0 - 178bf]
 PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
@@ -96,20 +98,20 @@
 PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
 Allocating PCI resources starting at 40000000 (gap: 40000000:bee00000)
 Booting paravirtualized kernel on bare hardware
-setup_percpu: NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:4 nr_node_ids:1
-PERCPU: Embedded 29 pages/cpu @ffff880001a00000 s89920 r8192 d20672 u524288
-pcpu-alloc: s89920 r8192 d20672 u524288 alloc=1*2097152
-pcpu-alloc: [0] 0 1 2 3 
+setup_percpu: NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:1 nr_node_ids:1
+PERCPU: Embedded 29 pages/cpu @ffff880001a00000 s89920 r8192 d20672 u2097152
+pcpu-alloc: s89920 r8192 d20672 u2097152 alloc=1*2097152
+pcpu-alloc: [0] 0 
 Built 1 zonelists in Node order, mobility grouping on.  Total pages: 258336
 Policy zone: DMA32
-Kernel command line: BOOT_IMAGE=2.6.35.7 root=UUID=082f0a78-6929-42dc-8d73-a249c2168c19 resume=UUID=cfa31406-4714-4734-ad27-ef4400c41f0c splash=silent vga=788
+Kernel command line: BOOT_IMAGE=2.6.35.7 root=UUID=082f0a78-6929-42dc-8d73-a249c2168c19 nosmp resume=UUID=cfa31406-4714-4734-ad27-ef4400c41f0c splash=silent vga=788
 PID hash table entries: 4096 (order: 3, 32768 bytes)
 xsave/xrstor: enabled xstate_bv 0x3, cntxt size 0x240
 Checking aperture...
 No AGP bridge found
 Calgary: detecting Calgary via BIOS EBDA area
 Calgary: Unable to locate Rio Grande table in EBDA - bailing!
-Subtract (49 early reservations)
+Subtract (46 early reservations)
   #1 [0001000000 - 00018772b8]   TEXT DATA BSS
   #2 [0037a21000 - 0037ff0000]         RAMDISK
   #3 [0001878000 - 000187819d]             BRK
@@ -143,23 +145,20 @@
   #31 [0001877980 - 00018779e8]         BOOTMEM
   #32 [0001877a00 - 0001877a68]         BOOTMEM
   #33 [0001877a80 - 0001877aa0]         BOOTMEM
-  #34 [0001877ac0 - 0001877b4a]         BOOTMEM
-  #35 [0001877b80 - 0001877c0a]         BOOTMEM
+  #34 [0001877ac0 - 0001877b50]         BOOTMEM
+  #35 [0001877b80 - 0001877c10]         BOOTMEM
   #36 [0001a00000 - 0001a1d000]         BOOTMEM
-  #37 [0001a80000 - 0001a9d000]         BOOTMEM
-  #38 [0001b00000 - 0001b1d000]         BOOTMEM
-  #39 [0001b80000 - 0001b9d000]         BOOTMEM
-  #40 [0001877c40 - 0001877c48]         BOOTMEM
-  #41 [0001877c80 - 0001877c88]         BOOTMEM
-  #42 [0001877cc0 - 0001877cd0]         BOOTMEM
-  #43 [0001877d00 - 0001877d20]         BOOTMEM
-  #44 [0001877d40 - 0001877e70]         BOOTMEM
-  #45 [0001877e80 - 0001877ed0]         BOOTMEM
-  #46 [0001877f00 - 0001877f50]         BOOTMEM
-  #47 [00018b0000 - 00018b8000]         BOOTMEM
-  #48 [00018ae1c0 - 00018ae400]         BOOTMEM
-Memory: 1017960k/1048128k available (3885k kernel code, 452k absent, 29716k reserved, 3013k data, 688k init)
-SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
+  #37 [0001877c40 - 0001877c48]         BOOTMEM
+  #38 [0001877c80 - 0001877c88]         BOOTMEM
+  #39 [0001877cc0 - 0001877cc4]         BOOTMEM
+  #40 [0001877d00 - 0001877d08]         BOOTMEM
+  #41 [0001877d40 - 0001877e90]         BOOTMEM
+  #42 [0001877ec0 - 0001877f40]         BOOTMEM
+  #43 [0001877f40 - 0001877fc0]         BOOTMEM
+  #44 [00018b0000 - 00018b8000]         BOOTMEM
+  #45 [00018ae1c0 - 00018ae400]         BOOTMEM
+Memory: 1018308k/1048128k available (3885k kernel code, 452k absent, 29368k reserved, 3013k data, 688k init)
+SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
 Hierarchical RCU implementation.
 	RCU-based detection of stalled CPUs is disabled.
 	Verbose stalled-CPUs detection is disabled.
@@ -168,16 +167,15 @@
 console [tty0] enabled
 hpet clockevent registered
 Fast TSC calibration using PIT
-Detected 2807.010 MHz processor.
-Calibrating delay loop (skipped), value calculated using timer frequency.. 5614.02 BogoMIPS (lpj=2807010)
+Detected 2806.589 MHz processor.
+Calibrating delay loop (skipped), value calculated using timer frequency.. 5613.17 BogoMIPS (lpj=2806589)
 pid_max: default: 32768 minimum: 301
 Security Framework initialized
 TOMOYO Linux initialized
 Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
 Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
 Mount-cache hash table entries: 256
-CPU: Physical Processor ID: 0
-CPU: Processor Core ID: 0
+CPU: Unsupported number of siblings 2
 mce: CPU supports 6 MCE banks
 CPU0: Thermal monitoring enabled (TM2)
 using mwait in idle threads.
@@ -189,17 +187,19 @@
 ... max period:             000000007fffffff
 ... fixed-purpose events:   3
 ... event mask:             0000000700000003
+SMP alternatives: switching to UP code
+Freeing SMP alternatives: 16k freed
 ACPI: Core revision 20100428
+ACPI: setting ELCR to 0200 (from 0001)
 ftrace: converting mcount calls to 0f 1f 44 00 00
 ftrace: allocating 15316 entries in 61 pages
 Setting APIC routing to flat
-..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
-CPU0: Intel(R) Core(TM)2 Duo CPU     E7400  @ 2.80GHz stepping 0a
-Booting Node   0, Processors  #1
-Brought up 2 CPUs
-Total of 2 processors activated (11227.61 BogoMIPS).
+SMP mode deactivated.
+SMP disabled
+Brought up 1 CPUs
+Total of 1 processors activated (5613.17 BogoMIPS).
 devtmpfs: initialized
-Time: 10:30:53  Date: 10/16/10
+Time: 13:50:43  Date: 10/16/10
 NET: Registered protocol family 16
 ACPI: bus type pci registered
 PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
@@ -214,9 +214,58 @@
 ACPI: SSDT 000000003ff9e380 002B9 (v01 DpgPmm  P002Ist 00000012 INTL 20051117)
 ACPI: Dynamic OEM Table Load:
 ACPI: SSDT (null) 002B9 (v01 DpgPmm  P002Ist 00000012 INTL 20051117)
+------------[ cut here ]------------
+WARNING: at mm/page_alloc.c:1981 __alloc_pages_nodemask+0x5b4/0x6d0()
+Hardware name: MS-7519
+Modules linked in:
+Pid: 1, comm: swapper Not tainted 2.6.35.7 #2
+Call Trace:
+ [<ffffffff8105718f>] warn_slowpath_common+0x7f/0xc0
+ [<ffffffff810571ea>] warn_slowpath_null+0x1a/0x20
+ [<ffffffff810e3574>] __alloc_pages_nodemask+0x5b4/0x6d0
+ [<ffffffff810385f0>] ? __ioremap_caller+0x290/0x3b0
+ [<ffffffff81112015>] alloc_page_interleave+0x45/0xa0
+ [<ffffffff81112f09>] alloc_pages_current+0xb9/0xe0
+ [<ffffffff81251ae5>] ? acpi_ex_system_memory_space_handler+0x0/0x1e7
+ [<ffffffff810e27be>] __get_free_pages+0xe/0x50
+ [<ffffffff8111d93e>] __kmalloc+0x14e/0x1c0
+ [<ffffffff8124d379>] acpi_os_allocate+0x2a/0x2c
+ [<ffffffff8124d50a>] acpi_ex_load_op+0xdd/0x295
+ [<ffffffff8124fec5>] acpi_ex_opcode_1A_1T_0R+0x2a/0x50
+ [<ffffffff81246da7>] acpi_ds_exec_end_op+0xef/0x3dc
+ [<ffffffff8125a298>] acpi_ps_parse_loop+0x7de/0x962
+ [<ffffffff812476a9>] ? acpi_ds_call_control_method+0x177/0x1e6
+ [<ffffffff812593b0>] acpi_ps_parse_aml+0x9f/0x2be
+ [<ffffffff8125ab0d>] acpi_ps_execute_method+0x1d2/0x2a1
+ [<ffffffff81255a72>] acpi_ns_evaluate+0xe6/0x1ad
+ [<ffffffff8125549b>] acpi_evaluate_object+0xfe/0x1f7
+ [<ffffffff8123ee8d>] acpi_processor_set_pdc+0x1c3/0x1ed
+ [<ffffffff8123ef71>] early_init_pdc+0xba/0xbd
+ [<ffffffff812576c8>] acpi_ns_walk_namespace+0xbe/0x18c
+ [<ffffffff8123eeb7>] ? early_init_pdc+0x0/0xbd
+ [<ffffffff8123eeb7>] ? early_init_pdc+0x0/0xbd
+ [<ffffffff812552c7>] acpi_walk_namespace+0x8a/0xc4
+ [<ffffffff81704512>] ? acpi_init+0x0/0x11c
+ [<ffffffff81704512>] ? acpi_init+0x0/0x11c
+ [<ffffffff81704764>] acpi_early_processor_set_pdc+0x3a/0x3c
+ [<ffffffff817043e9>] acpi_bus_init+0xb5/0x1de
+ [<ffffffff811ec89e>] ? kobject_create_and_add+0x3e/0x80
+ [<ffffffff816fca28>] ? genhd_device_init+0x0/0x7b
+ [<ffffffff81704512>] ? acpi_init+0x0/0x11c
+ [<ffffffff81704583>] acpi_init+0x71/0x11c
+ [<ffffffff8100204c>] do_one_initcall+0x3c/0x1d0
+ [<ffffffff816d4761>] kernel_init+0x156/0x1e0
+ [<ffffffff8100ade4>] kernel_thread_helper+0x4/0x10
+ [<ffffffff816d460b>] ? kernel_init+0x0/0x1e0
+ [<ffffffff8100ade0>] ? kernel_thread_helper+0x0/0x10
+---[ end trace a7919e7f17c0a725 ]---
+ACPI Error (psparse-0537): Method parse/execution failed [\_PR_.P003._OSC] (Node ffff88003f9be7a0), AE_NO_MEMORY
+ACPI Error (psparse-0537): Method parse/execution failed [\_PR_.P003._PDC] (Node ffff88003f9be780), AE_NO_MEMORY
+ACPI Error (psparse-0537): Method parse/execution failed [\_PR_.P004._OSC] (Node ffff88003f9be820), AE_NO_MEMORY
+ACPI Error (psparse-0537): Method parse/execution failed [\_PR_.P004._PDC] (Node ffff88003f9be800), AE_NO_MEMORY
 ACPI: Interpreter enabled
 ACPI: (supports S0 S1 S4 S5)
-ACPI: Using IOAPIC for interrupt routing
+ACPI: Using PIC for interrupt routing
 PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
 PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in ACPI motherboard resources
 ACPI: No dock devices found.
@@ -350,7 +399,7 @@
 system 00:08: [mem 0xfed20000-0xfed3ffff] has been reserved
 system 00:08: [mem 0xfed40000-0xfed8ffff] has been reserved
 system 00:0b: [mem 0xffc00000-0xffefffff] has been reserved
-system 00:0c: [mem 0xfec00000-0xfec00fff] could not be reserved
+system 00:0c: [mem 0xfec00000-0xfec00fff] has been reserved
 system 00:0c: [mem 0xfee00000-0xfee00fff] has been reserved
 system 00:0d: [io  0x0a00-0x0adf] has been reserved
 system 00:0d: [io  0x0ae0-0x0aef] has been reserved
@@ -386,15 +435,19 @@
 pci 0000:00:1e.0:   bridge window [io  disabled]
 pci 0000:00:1e.0:   bridge window [mem disabled]
 pci 0000:00:1e.0:   bridge window [mem pref disabled]
-pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
+ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
+PCI: setting IRQ 10 as level-triggered
+pci 0000:00:01.0: PCI INT A -> Link[LNKA] -> GSI 10 (level, low) -> IRQ 10
 pci 0000:00:01.0: setting latency timer to 64
 pci 0000:00:1c.0: enabling device (0105 -> 0107)
-pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
+ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 5
+PCI: setting IRQ 5 as level-triggered
+pci 0000:00:1c.0: PCI INT A -> Link[LNKB] -> GSI 5 (level, low) -> IRQ 5
 pci 0000:00:1c.0: setting latency timer to 64
 pci 0000:00:1c.1: enabling device (0104 -> 0107)
-pci 0000:00:1c.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
+pci 0000:00:1c.1: PCI INT B -> Link[LNKA] -> GSI 10 (level, low) -> IRQ 10
 pci 0000:00:1c.1: setting latency timer to 64
-pci 0000:00:1c.5: PCI INT B -> GSI 16 (level, low) -> IRQ 16
+pci 0000:00:1c.5: PCI INT B -> Link[LNKA] -> GSI 10 (level, low) -> IRQ 10
 pci 0000:00:1c.5: setting latency timer to 64
 pci 0000:00:1e.0: setting latency timer to 64
 pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
@@ -435,11 +488,11 @@
 Trying to unpack rootfs image as initramfs...
 Freeing initrd memory: 5948k freed
 audit: initializing netlink socket (disabled)
-type=2000 audit(1287225053.259:1): initialized
+type=2000 audit(1287237043.175:1): initialized
 HugeTLB registered 2 MB page size, pre-allocated 0 pages
 VFS: Disk quotas dquot_6.5.2
 Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
-msgmni has been set to 1999
+msgmni has been set to 2000
 alg: No test for stdrng (krng)
 Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
 io scheduler noop registered
@@ -477,8 +530,8 @@
 PM: Checking image partition UUID=cfa31406-4714-4734-ad27-ef4400c41f0c
 PM: Resume from disk failed.
 registered taskstats version 1
-  Magic number: 14:762:527
-rtc_cmos 00:03: setting system clock to 2010-10-16 10:30:54 UTC (1287225054)
+  Magic number: 14:392:837
+rtc_cmos 00:03: setting system clock to 2010-10-16 13:50:43 UTC (1287237043)
 BIOS EDD facility v0.16 2004-Jun-25, 1 devices found
 Freeing unused kernel memory: 688k freed
 usbcore: registered new interface driver usbfs
@@ -488,13 +541,15 @@
 usbcore: registered new interface driver usbhid
 usbhid: USB HID core driver
 ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
-ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
+ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 14
+PCI: setting IRQ 14 as level-triggered
+ehci_hcd 0000:00:1a.7: PCI INT C -> Link[LNKC] -> GSI 14 (level, low) -> IRQ 14
 ehci_hcd 0000:00:1a.7: setting latency timer to 64
 ehci_hcd 0000:00:1a.7: EHCI Host Controller
 ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
 ehci_hcd 0000:00:1a.7: debug port 1
 ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
-ehci_hcd 0000:00:1a.7: irq 18, io mem 0xf9fffc00
+ehci_hcd 0000:00:1a.7: irq 14, io mem 0xf9fffc00
 ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
 usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
 usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
@@ -503,13 +558,15 @@
 usb usb1: SerialNumber: 0000:00:1a.7
 hub 1-0:1.0: USB hub found
 hub 1-0:1.0: 6 ports detected
-ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
+ACPI: PCI Interrupt Link [LNKH] enabled at IRQ 6
+PCI: setting IRQ 6 as level-triggered
+ehci_hcd 0000:00:1d.7: PCI INT A -> Link[LNKH] -> GSI 6 (level, low) -> IRQ 6
 ehci_hcd 0000:00:1d.7: setting latency timer to 64
 ehci_hcd 0000:00:1d.7: EHCI Host Controller
 ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
 ehci_hcd 0000:00:1d.7: debug port 1
 ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
-ehci_hcd 0000:00:1d.7: irq 23, io mem 0xf9fff800
+ehci_hcd 0000:00:1d.7: irq 6, io mem 0xf9fff800
 ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
 usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
 usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
@@ -520,11 +577,11 @@
 hub 2-0:1.0: 6 ports detected
 ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
 uhci_hcd: USB Universal Host Controller Interface driver
-uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
+uhci_hcd 0000:00:1a.0: PCI INT A -> Link[LNKA] -> GSI 10 (level, low) -> IRQ 10
 uhci_hcd 0000:00:1a.0: setting latency timer to 64
 uhci_hcd 0000:00:1a.0: UHCI Host Controller
 uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
-uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000bc00
+uhci_hcd 0000:00:1a.0: irq 10, io base 0x0000bc00
 usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
 usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
 usb usb3: Product: UHCI Host Controller
@@ -532,11 +589,13 @@
 usb usb3: SerialNumber: 0000:00:1a.0
 hub 3-0:1.0: USB hub found
 hub 3-0:1.0: 2 ports detected
-uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
+ACPI: PCI Interrupt Link [LNKF] enabled at IRQ 11
+PCI: setting IRQ 11 as level-triggered
+uhci_hcd 0000:00:1a.1: PCI INT B -> Link[LNKF] -> GSI 11 (level, low) -> IRQ 11
 uhci_hcd 0000:00:1a.1: setting latency timer to 64
 uhci_hcd 0000:00:1a.1: UHCI Host Controller
 uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
-uhci_hcd 0000:00:1a.1: irq 21, io base 0x0000b880
+uhci_hcd 0000:00:1a.1: irq 11, io base 0x0000b880
 usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
 usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
 usb usb4: Product: UHCI Host Controller
@@ -544,11 +603,13 @@
 usb usb4: SerialNumber: 0000:00:1a.1
 hub 4-0:1.0: USB hub found
 hub 4-0:1.0: 2 ports detected
-uhci_hcd 0000:00:1a.2: PCI INT D -> GSI 19 (level, low) -> IRQ 19
+ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 15
+PCI: setting IRQ 15 as level-triggered
+uhci_hcd 0000:00:1a.2: PCI INT D -> Link[LNKD] -> GSI 15 (level, low) -> IRQ 15
 uhci_hcd 0000:00:1a.2: setting latency timer to 64
 uhci_hcd 0000:00:1a.2: UHCI Host Controller
 uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
-uhci_hcd 0000:00:1a.2: irq 19, io base 0x0000b800
+uhci_hcd 0000:00:1a.2: irq 15, io base 0x0000b800
 usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
 usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
 usb usb5: Product: UHCI Host Controller
@@ -556,11 +617,11 @@
 usb usb5: SerialNumber: 0000:00:1a.2
 hub 5-0:1.0: USB hub found
 hub 5-0:1.0: 2 ports detected
-uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
+uhci_hcd 0000:00:1d.0: PCI INT A -> Link[LNKH] -> GSI 6 (level, low) -> IRQ 6
 uhci_hcd 0000:00:1d.0: setting latency timer to 64
 uhci_hcd 0000:00:1d.0: UHCI Host Controller
 uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
-uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000b480
+uhci_hcd 0000:00:1d.0: irq 6, io base 0x0000b480
 usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
 usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
 usb usb6: Product: UHCI Host Controller
@@ -568,11 +629,11 @@
 usb usb6: SerialNumber: 0000:00:1d.0
 hub 6-0:1.0: USB hub found
 hub 6-0:1.0: 2 ports detected
-uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
+uhci_hcd 0000:00:1d.1: PCI INT B -> Link[LNKD] -> GSI 15 (level, low) -> IRQ 15
 uhci_hcd 0000:00:1d.1: setting latency timer to 64
 uhci_hcd 0000:00:1d.1: UHCI Host Controller
 uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
-uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000b400
+uhci_hcd 0000:00:1d.1: irq 15, io base 0x0000b400
 usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
 usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
 usb usb7: Product: UHCI Host Controller
@@ -580,11 +641,11 @@
 usb usb7: SerialNumber: 0000:00:1d.1
 hub 7-0:1.0: USB hub found
 hub 7-0:1.0: 2 ports detected
-uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
+uhci_hcd 0000:00:1d.2: PCI INT C -> Link[LNKC] -> GSI 14 (level, low) -> IRQ 14
 uhci_hcd 0000:00:1d.2: setting latency timer to 64
 uhci_hcd 0000:00:1d.2: UHCI Host Controller
 uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
-uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000b080
+uhci_hcd 0000:00:1d.2: irq 14, io base 0x0000b080
 usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
 usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
 usb usb8: Product: UHCI Host Controller
@@ -595,20 +656,20 @@
 SCSI subsystem initialized
 libata version 3.00 loaded.
 ata_piix 0000:00:1f.2: version 2.13
-ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
+ata_piix 0000:00:1f.2: PCI INT B -> Link[LNKD] -> GSI 15 (level, low) -> IRQ 15
 ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
 ata_piix 0000:00:1f.2: setting latency timer to 64
 scsi0 : ata_piix
 scsi1 : ata_piix
-ata1: SATA max UDMA/133 cmd 0xb000 ctl 0xac00 bmdma 0xa480 irq 19
-ata2: SATA max UDMA/133 cmd 0xa880 ctl 0xa800 bmdma 0xa488 irq 19
-ata_piix 0000:00:1f.5: PCI INT B -> GSI 19 (level, low) -> IRQ 19
+ata1: SATA max UDMA/133 cmd 0xb000 ctl 0xac00 bmdma 0xa480 irq 15
+ata2: SATA max UDMA/133 cmd 0xa880 ctl 0xa800 bmdma 0xa488 irq 15
+ata_piix 0000:00:1f.5: PCI INT B -> Link[LNKD] -> GSI 15 (level, low) -> IRQ 15
 ata_piix 0000:00:1f.5: MAP [ P0 -- P1 -- ]
 ata_piix 0000:00:1f.5: setting latency timer to 64
 scsi2 : ata_piix
 scsi3 : ata_piix
-ata3: SATA max UDMA/133 cmd 0xa000 ctl 0x9c00 bmdma 0x9480 irq 19
-ata4: SATA max UDMA/133 cmd 0x9880 ctl 0x9800 bmdma 0x9488 irq 19
+ata3: SATA max UDMA/133 cmd 0xa000 ctl 0x9c00 bmdma 0x9480 irq 15
+ata4: SATA max UDMA/133 cmd 0x9880 ctl 0x9800 bmdma 0x9488 irq 15
 ata3: SATA link down (SStatus 0 SControl 300)
 ata4: SATA link down (SStatus 0 SControl 300)
 usb 4-2: new low speed USB device using uhci_hcd and address 2
@@ -633,17 +694,17 @@
 sd 1:0:1:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
  sda: sda1 sda2 < sda5 sda6 sda7 >
 sd 1:0:1:0: [sda] Attached SCSI disk
-pata_acpi 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
+pata_acpi 0000:02:00.0: PCI INT A -> Link[LNKA] -> GSI 10 (level, low) -> IRQ 10
 pata_acpi 0000:02:00.0: setting latency timer to 64
 pata_acpi 0000:02:00.0: PCI INT A disabled
 Uniform Multi-Platform E-IDE driver
 ide-gd driver 1.18
-pata_jmicron 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
+pata_jmicron 0000:02:00.0: PCI INT A -> Link[LNKA] -> GSI 10 (level, low) -> IRQ 10
 pata_jmicron 0000:02:00.0: setting latency timer to 64
 scsi4 : pata_jmicron
 scsi5 : pata_jmicron
-ata5: PATA max UDMA/100 cmd 0xdc00 ctl 0xd880 bmdma 0xd400 irq 16
-ata6: PATA max UDMA/100 cmd 0xd800 ctl 0xd480 bmdma 0xd408 irq 16
+ata5: PATA max UDMA/100 cmd 0xdc00 ctl 0xd880 bmdma 0xd400 irq 10
+ata6: PATA max UDMA/100 cmd 0xd800 ctl 0xd480 bmdma 0xd408 irq 10
 usb 5-1: New USB device found, idVendor=1241, idProduct=1503
 usb 5-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
 usb 5-1: Product: USB Keyboard
@@ -661,14 +722,14 @@
 EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: acl
 Not activating Mandatory Access Control now since /sbin/tomoyo-init doesn't exist.
 udev: starting version 153
-ACPI: acpi_idle registered with cpuidle
+parport_pc 00:07: reported by Plug and Play ACPI
+parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
+ppdev: user-space parallel port driver
 input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input3
 ACPI: Power Button [PWRB]
 input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input4
 ACPI: Power Button [PWRF]
-parport_pc 00:07: reported by Plug and Play ACPI
-parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
-ppdev: user-space parallel port driver
+ACPI: acpi_idle registered with cpuidle
 device-mapper: uevent: version 1.0.3
 device-mapper: ioctl: 4.17.0-ioctl (2010-03-05) initialised: dm-devel@redhat.com
 EXT4-fs (sda1): re-mounted. Opts: acl
@@ -676,7 +737,7 @@
 EXT4-fs (sda7): mounted filesystem with ordered data mode. Opts: acl
 Adding 4088504k swap on /dev/sda5.  Priority:-1 extents:1 across:4088504k 
 [drm] Initialized drm 1.1.0 20060810
-nouveau 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
+nouveau 0000:01:00.0: PCI INT A -> Link[LNKA] -> GSI 10 (level, low) -> IRQ 10
 nouveau 0000:01:00.0: setting latency timer to 64
 [drm] nouveau 0000:01:00.0: Detected an NV50 generation card (0x098200a2)
 checking generic (fb000000 e00000) vs hw (d0000000 10000000)
@@ -709,7 +770,7 @@
 [drm] nouveau 0000:01:00.0: 0xC3D8: parsing output script 0
 [drm] nouveau 0000:01:00.0: 0xAE2E: parsing output script 0
 [drm] nouveau 0000:01:00.0: Detected 512MiB VRAM
-[TTM] Zone  kernel: Available graphics memory: 512298 kiB.
+[TTM] Zone  kernel: Available graphics memory: 512480 kiB.
 [TTM] Initializing pool allocator.
 [drm] nouveau 0000:01:00.0: 512 MiB GART (aperture)
 [drm] nouveau 0000:01:00.0: Allocating FIFO number 1
@@ -722,7 +783,7 @@
 [drm] nouveau 0000:01:00.0: Detected a VGA connector
 [drm] nouveau 0000:01:00.0: Detected a TV connector
 [drm] nouveau 0000:01:00.0:   no encoders, ignoring
-[drm] nouveau 0000:01:00.0: allocated 1280x1024 fb: 0x40250000, bo ffff88003eeb2000
+[drm] nouveau 0000:01:00.0: allocated 1280x1024 fb: 0x40250000, bo ffff88003e2a5000
 Console: switching to colour frame buffer device 160x64
 fb0: nouveaufb frame buffer device
 drm: registered panic notifier
@@ -733,20 +794,22 @@
 [drm] nouveau 0000:01:00.0: nouveau_channel_alloc: initialised FIFO 2
 [drm] nouveau 0000:01:00.0: 0x11F1: parsing clock script 0
 r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
-r8169 0000:04:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
+r8169 0000:04:00.0: PCI INT A -> Link[LNKB] -> GSI 5 (level, low) -> IRQ 5
 r8169 0000:04:00.0: setting latency timer to 64
 r8169 0000:04:00.0: irq 44 for MSI/MSI-X
-r8169 0000:04:00.0: eth0: RTL8168c/8111c at 0xffffc9001359e000, 00:21:85:5e:a8:9e, XID 1c4000c0 IRQ 44
-i801_smbus 0000:00:1f.3: PCI INT C -> GSI 18 (level, low) -> IRQ 18
+r8169 0000:04:00.0: eth0: RTL8168c/8111c at 0xffffc9001055a000, 00:21:85:5e:a8:9e, XID 1c4000c0 IRQ 44
+i801_smbus 0000:00:1f.3: PCI INT C -> Link[LNKC] -> GSI 14 (level, low) -> IRQ 14
 iTCO_vendor_support: vendor-support=0
-sd 1:0:1:0: Attached scsi generic sg0 type 0
-scsi 4:0:0:0: Attached scsi generic sg1 type 5
+iTCO_wdt: Intel TCO WatchDog Timer Driver v1.06
+iTCO_wdt: unable to reset NO_REBOOT flag, platform may have disabled it
 sr0: scsi3-mmc drive: 40x/40x writer cd/rw xa/form2 cdda tray
 Uniform CD-ROM driver Revision: 3.20
 sr 4:0:0:0: Attached scsi CD-ROM sr0
-iTCO_wdt: Intel TCO WatchDog Timer Driver v1.06
-iTCO_wdt: unable to reset NO_REBOOT flag, platform may have disabled it
-HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
+sd 1:0:1:0: Attached scsi generic sg0 type 0
+sr 4:0:0:0: Attached scsi generic sg1 type 5
+ACPI: PCI Interrupt Link [LNKG] enabled at IRQ 3
+PCI: setting IRQ 3 as level-triggered
+HDA Intel 0000:00:1b.0: PCI INT A -> Link[LNKG] -> GSI 3 (level, low) -> IRQ 3
 HDA Intel 0000:00:1b.0: irq 45 for MSI/MSI-X
 HDA Intel 0000:00:1b.0: setting latency timer to 64
 SKU: Nid=0x1d sku_cfg=0x4007f603
@@ -802,4 +865,3 @@
 mkiss: ax0: Trying crc-smack
 mkiss: ax0: Trying crc-flexnet
 xfbbd uses old SIOCAX25GETINFO
-fuse init (API version 7.14)

--------------030504040907020008070703--
