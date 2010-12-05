Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756297Ab0LEQ3j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 11:29:39 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64882 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755306Ab0LEQ3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 11:29:35 -0500
MIME-Version: 1.0
X-Originating-IP: [174.136.0.123]
From: Brian Gitonga Marete <marete@toshnix.com>
Date: Sun, 5 Dec 2010 19:29:13 +0300
Message-ID: <AANLkTi=d8y_zVaHHH6fHqqrJ0-R0inq=2pyk6fXtitEH@mail.gmail.com>
Subject: [kdump core available] Kernel Panic in 2.6.36.1
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Following is a bug report on a Kernel Panic in 2.6.36.1.

I have been experiencing (what I think) is the same panic since I
installed 2.6.36.1, but I have never been able to get any stack trace.
Finally, I was able to get a proper trace after configuring
kexec/kdump.

It is true that my kernel is tainted by a proprietary nvidia module,
but I am hoping the fact that I have a level 7 makedumpfile(8) core
available and that I am willing to readily furnish any information
asked for through the crash(8) utility will make up for this.

I do not want to be misleading but the panic seems to happen when I am
using my Huawei 3G USB modem, and have just been connected for some
reason or other. But I may be wrong.

Below is the information from crash(8). (I will be happy to answer any
further questions). Thanks

Basic Information
-----------------------------

      KERNEL: /boot/vmlinux-2.6.36.1
    DUMPFILE: dumpfile-2.6.36.1-1291561094  [PARTIAL DUMP]
        CPUS: 1
        DATE: Sun Dec  5 17:56:39 2010
      UPTIME: 00:08:13
LOAD AVERAGE: 1.12, 1.73, 1.36
       TASKS: 360
    NODENAME: phyllis
     RELEASE: 2.6.36.1
     VERSION: #2 SMP Wed Dec 1 16:16:23 EAT 2010
     MACHINE: i686  (1862 Mhz)
      MEMORY: 2.5 GB
       PANIC: "[  945.288731] Oops: 0000 [#1] SMP " (check log for details)
         PID: 3916
     COMMAND: "udevd"
        TASK: ed5b94f0  [THREAD_INFO: ec808000]
         CPU: 0
       STATE: TASK_RUNNING (PANIC)


Backtrace (crash bt)
-------------------------------

PID: 3916   TASK: ed5b94f0  CPU: 0   COMMAND: "udevd"
 #0 [ec809b18] crash_kexec at c018561f
 #1 [ec809b70] oops_end at c05c6702
 #2 [ec809b88] no_context at c0126c89
 #3 [ec809bb0] __bad_area_nosemaphore at c0126dab
 #4 [ec809bf0] bad_area_nosemaphore at c0126e5d
 #5 [ec809bfc] do_page_fault at c05c883f
 #6 [ec809c78] error_code (via page_fault) at c05c5be8
    EAX: 000001bc  EBX: 000001bc  ECX: 00000000  EDX: 000001bc  EBP: ec809cb8
    DS:  007b      ESI: 000001cc  ES:  007b      EDI: 00000086  GS:  ffff84b0
    CS:  0060      EIP: c0341625  ERR: ffffffff  EFLAGS: 00010046
 #7 [ec809cac] do_raw_spin_trylock at c0341625
 #8 [ec809cbc] _raw_spin_lock_irqsave at c05c4bbd
 #9 [ec809ce0] tty_buffer_request_room at c03b004c
#10 [ec809d08] tty_insert_flip_string_fixed_flag at c03b02f3
#11 [ec809d58] usb_hcd_giveback_urb at c0441385
#12 [ec809d70] ehci_urb_done at c0455e88
#13 [ec809d90] qh_completions at c045623b
#14 [ec809dd4] ehci_work at c0456c4b
#15 [ec809e38] ehci_irq at c0457a11
#16 [ec809e70] usb_hcd_irq at c0441770
#17 [ec809e80] handle_IRQ_event at c019ccc2
#18 [ec809eb0] handle_fasteoi_irq at c019edfb
#19 [ec809ec8] handle_irq at c0104a55
#20 [ec809ed4] do_IRQ at c01041e2
#21 [ec809f00] common_interrupt at c01033e4
    EAX: 00000000  EBX: ed1d7884  ECX: ed5b94f0  EDX: 00000052  EBP: ec809f44
    DS:  007b      ESI: ed5b94f0  ES:  007b      EDI: 00000000  GS:  0000
    CS:  0060      EIP: c05c534f  ERR: ffffff9e  EFLAGS: 00000202
#22 [ec809f34] _raw_spin_unlock_irq at c05c534f
#23 [ec809f48] do_setitimer at c014656a
#24 [ec809f80] alarm_setitimer at c01466d0
#25 [ec809fa8] sys_alarm at c014e9d6
#26 [ec809fb0] ia32_sysenter_target at c0102e51
    EAX: 0000001b  EBX: 00000000  ECX: b8019580  EDX: b7810dd0
    DS:  007b      ESI: b8019170  ES:  007b      EDI: b8049ef8
    SS:  007b      ESP: bfae15fc  EBP: bfae1778  GS:  0000
    CS:  0073      EIP: b77d8424  ERR: 0000001b  EFLAGS: 00000296

dmesg (crash log  -- Contains a Stack Trace)
----------------------------------------------------------------------

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.36.1 (marebri@phyllis) (gcc version
4.4.1 (Ubuntu 4.4.1-4ubuntu9) ) #2 SMP Wed Dec 1 16:16:23 EAT 2010
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000009fe70000 (usable)
[    0.000000]  BIOS-e820: 000000009fe70000 - 000000009ff00000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000009ff00000 - 00000000a0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
[    0.000000]  BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
[    0.000000] Notice: NX (Execute Disable) protection cannot be
enabled: non-PAE kernel!
[    0.000000] DMI present.
[    0.000000] e820 update range: 0000000000000000 - 0000000000001000
(usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] last_pfn = 0x9fe70 max_arch_pfn = 0x100000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-DFFFF uncachable
[    0.000000]   E0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 base 080000000 mask FE0000000 write-back
[    0.000000]   2 base 09FF00000 mask FFFF00000 uncachable
[    0.000000]   3 base 09FF00000 mask FFFF00000 uncachable
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] PAT not supported by CPU.
[    0.000000] e820 update range: 0000000000002000 - 0000000000010000
(usable) ==> (reserved)
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000001000 (reserved)
[    0.000000]  modified: 0000000000001000 - 0000000000002000 (usable)
[    0.000000]  modified: 0000000000002000 - 0000000000010000 (reserved)
[    0.000000]  modified: 0000000000010000 - 000000000009f800 (usable)
[    0.000000]  modified: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000dc000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 000000009fe70000 (usable)
[    0.000000]  modified: 000000009fe70000 - 000000009ff00000 (ACPI NVS)
[    0.000000]  modified: 000000009ff00000 - 00000000a0000000 (reserved)
[    0.000000]  modified: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  modified: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  modified: 00000000fed00000 - 00000000fed00400 (reserved)
[    0.000000]  modified: 00000000fed14000 - 00000000fed1a000 (reserved)
[    0.000000]  modified: 00000000fed1c000 - 00000000fed90000 (reserved)
[    0.000000]  modified: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  modified: 00000000ff000000 - 0000000100000000 (reserved)
[    0.000000] initial memory mapped : 0 - 01400000
[    0.000000] found SMP MP-table at [c00f7e90] f7e90
[    0.000000] init_memory_mapping: 0000000000000000-00000000377fe000
[    0.000000]  0000000000 - 0000400000 page 4k
[    0.000000]  0000400000 - 0037400000 page 2M
[    0.000000]  0037400000 - 00377fe000 page 4k
[    0.000000] kernel direct mapping tables up to 377fe000 @ 15000-1a000
[    0.000000] RAMDISK: 33279000 - 37ff0000
[    0.000000] Allocated new RAMDISK: 00eaf000 - 05c2549d
[    0.000000] Move RAMDISK from 0000000033279000 - 0000000037fef49c
to 00eaf000 - 05c2549c
[    0.000000] Reserving 128MB of memory at 96MB for crashkernel
(System RAM: 2558MB)
[    0.000000] ACPI: RSDP 000f7de0 00014 (v00 HP    )
[    0.000000] ACPI: RSDT 9fe7ef88 0004C (v01 HP     30BC     06040000
 LTP 00000000)
[    0.000000] ACPI: FACP 9fe86dfc 00074 (v01 HP     30BC     06040000
LOHR 0000005A)
[    0.000000] ACPI: DSDT 9fe7fadb 07321 (v01 HP     30BC     06040000
MSFT 0100000E)
[    0.000000] ACPI: FACS 9fe87fc0 00040
[    0.000000] ACPI: APIC 9fe86e70 00068 (v01 HP     30BC     06040000
LOHR 0000005A)
[    0.000000] ACPI: HPET 9fe86ed8 00038 (v01 HP     30BC     06040000
LOHR 0000005A)
[    0.000000] ACPI: MCFG 9fe86f10 0003C (v01 HP     30BC     06040000
LOHR 0000005A)
[    0.000000] ACPI: BOOT 9fe86fd8 00028 (v01 HP     30BC     06040000
 LTP 00000001)
[    0.000000] ACPI: APIC 9fe86f7e 0005A (v01 HP     30BC     06040000
 LTP 00000000)
[    0.000000] ACPI: SSDT 9fe7f8cd 0020A (v01  HP    30BC     00001000
INTL 20050624)
[    0.000000] ACPI: SSDT 9fe7f6a6 00227 (v01 HP     30BC     00003000
INTL 20050624)
[    0.000000] ACPI: SSDT 9fe7f4ca 001DC (v01 HP     30BC     00003001
INTL 20050624)
[    0.000000] ACPI: SSDT 9fe7efd4 004F6 (v01 HP     30BC     00003000
INTL 20050624)
[    0.000000] ACPI: BIOS bug: multiple APIC/MADT found, using 0
[    0.000000] ACPI: If "acpi_apic_instance=2" works better, notify
linux-acpi@vger.kernel.org
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 1670MB HIGHMEM available.
[    0.000000] 887MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 377fe000
[    0.000000]   low ram: 0 - 377fe000
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000001 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x000377fe
[    0.000000]   HighMem  0x000377fe -> 0x0009fe70
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000001 -> 0x00000002
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0009fe70
[    0.000000] On node 0 totalpages: 654848
[    0.000000] free_area_init_node: node 0, pgdat c0808ac0,
node_mem_map ce000020
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3952 pages, LIFO batch:0
[    0.000000]   Normal zone: 1744 pages used for memmap
[    0.000000]   Normal zone: 221486 pages, LIFO batch:31
[    0.000000]   HighMem zone: 3341 pages used for memmap
[    0.000000]   HighMem zone: 424293 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 2 CPUs, 1 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] early_res array is doubled to 64 at [16000 - 167ff]
[    0.000000] PM: Registered nosave memory: 0000000000002000 - 0000000000010000
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000dc000
[    0.000000] PM: Registered nosave memory: 00000000000dc000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at a0000000 (gap:
a0000000:40000000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2
nr_node_ids:1
[    0.000000] PERCPU: Embedded 334 pages/cpu @cf400000 s1344128 r0
d23936 u2097152
[    0.000000] pcpu-alloc: s1344128 r0 d23936 u2097152 alloc=1*4194304
[    0.000000] pcpu-alloc: [0] 0 1
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.
Total pages: 649731
[    0.000000] Kernel command line:
root=UUID=4fc50fb7-22f1-47c7-9bd2-5f2b7e13b5ff ro quiet splash
apparmor=0 selinux=1  crashkernel=384M-2G:64M,2G-:128M nmi_watch=1
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] allocated 13099180 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't
want memory cgroups
[    0.000000] Subtract (54 early reservations)
[    0.000000]   #1 [0000001000 - 0000002000]   EX TRAMPOLINE
[    0.000000]   #2 [0000100000 - 0000ea850c]   TEXT DATA BSS
[    0.000000]   #3 [0000ea9000 - 0000eae108]             BRK
[    0.000000]   #4 [00000f7ea0 - 0000100000]   BIOS reserved
[    0.000000]   #5 [00000f7e90 - 00000f7ea0]    MP-table mpf
[    0.000000]   #6 [000009f800 - 000009fd71]   BIOS reserved
[    0.000000]   #7 [000009fec9 - 00000f7e90]   BIOS reserved
[    0.000000]   #8 [000009fd71 - 000009fec9]    MP-table mpc
[    0.000000]   #9 [0000010000 - 0000011000]      TRAMPOLINE
[    0.000000]   #10 [0000011000 - 0000015000]     ACPI WAKEUP
[    0.000000]   #11 [0000015000 - 0000016000]         PGTABLE
[    0.000000]   #12 [0000eaf000 - 0005c26000]     NEW RAMDISK
[    0.000000]   #13 [0006000000 - 000e000000]    CRASH KERNEL
[    0.000000]   #14 [0005c26000 - 0005c27000]         BOOTMEM
[    0.000000]   #15 [000e000000 - 000f400000]         BOOTMEM
[    0.000000]   #16 [0005c27000 - 0005c27004]         BOOTMEM
[    0.000000]   #17 [0005c27040 - 0005c27300]         BOOTMEM
[    0.000000]   #18 [0005c27300 - 0005c27354]         BOOTMEM
[    0.000000]   #19 [0005c27380 - 0005c32380]         BOOTMEM
[    0.000000]   #20 [0005c32380 - 0005c32420]         BOOTMEM
[    0.000000]   #21 [0005c32440 - 0005c48440]         BOOTMEM
[    0.000000]   #22 [0005c48440 - 0005c48465]         BOOTMEM
[    0.000000]   #23 [0005c48480 - 0005c484a7]         BOOTMEM
[    0.000000]   #24 [0005c484c0 - 0005c48680]         BOOTMEM
[    0.000000]   #25 [0005c48680 - 0005c486c0]         BOOTMEM
[    0.000000]   #26 [0005c486c0 - 0005c48700]         BOOTMEM
[    0.000000]   #27 [0005c48700 - 0005c48740]         BOOTMEM
[    0.000000]   #28 [0005c48740 - 0005c48780]         BOOTMEM
[    0.000000]   #29 [0005c48780 - 0005c487c0]         BOOTMEM
[    0.000000]   #30 [0005c487c0 - 0005c48800]         BOOTMEM
[    0.000000]   #31 [0005c48800 - 0005c48840]         BOOTMEM
[    0.000000]   #32 [0005c48840 - 0005c48880]         BOOTMEM
[    0.000000]   #33 [0005c48880 - 0005c488c0]         BOOTMEM
[    0.000000]   #34 [0005c488c0 - 0005c48900]         BOOTMEM
[    0.000000]   #35 [0005c48900 - 0005c48940]         BOOTMEM
[    0.000000]   #36 [0005c48940 - 0005c48980]         BOOTMEM
[    0.000000]   #37 [0005c48980 - 0005c489c0]         BOOTMEM
[    0.000000]   #38 [0005c489c0 - 0005c489d0]         BOOTMEM
[    0.000000]   #39 [0005c48a00 - 0005c48a10]         BOOTMEM
[    0.000000]   #40 [0005c48a40 - 0005c48ac2]         BOOTMEM
[    0.000000]   #41 [0005c48b00 - 0005c48b82]         BOOTMEM
[    0.000000]   #42 [000f400000 - 000f54e000]         BOOTMEM
[    0.000000]   #43 [000f600000 - 000f74e000]         BOOTMEM
[    0.000000]   #44 [0005c4abc0 - 0005c4abc4]         BOOTMEM
[    0.000000]   #45 [0005c4ac00 - 0005c4ac04]         BOOTMEM
[    0.000000]   #46 [0005c4ac40 - 0005c4ac48]         BOOTMEM
[    0.000000]   #47 [0005c4ac80 - 0005c4ac88]         BOOTMEM
[    0.000000]   #48 [0005c4acc0 - 0005c4ad68]         BOOTMEM
[    0.000000]   #49 [0005c4ad80 - 0005c4ade8]         BOOTMEM
[    0.000000]   #50 [0005c4ae00 - 0005c4ee00]         BOOTMEM
[    0.000000]   #51 [0005c4ee00 - 0005ccee00]         BOOTMEM
[    0.000000]   #52 [0005ccee00 - 0005d0ee00]         BOOTMEM
[    0.000000]   #53 [000f74e000 - 00103cc0ac]         BOOTMEM
[    0.000000] Initializing HighMem for node 0 (000377fe:0009fe70)
[    0.000000] Memory: 2358080k/2619840k available (4913k kernel code,
261312k reserved, 2333k data, 1836k init, 1710536k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff16000 - 0xfffff000   ( 932 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
[    0.000000]       .init : 0xc0814000 - 0xc09df000   (1836 kB)
[    0.000000]       .data : 0xc05cc45f - 0xc08139e8   (2333 kB)
[    0.000000]       .text : 0xc0100000 - 0xc05cc45f   (4913 kB)
[    0.000000] Checking if this processor honours the WP bit even in
supervisor mode...Ok.
[    0.000000] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0,
CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU-based detection of stalled CPUs is disabled.
[    0.000000] 	Verbose stalled-CPUs detection is disabled.
[    0.000000] NR_IRQS:512
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat,
Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 3807 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 1862.252 MHz processor.
[    0.003340] Calibrating delay loop (skipped), value calculated
using timer frequency.. 3725.69 BogoMIPS (lpj=6207506)
[    0.003346] pid_max: default: 32768 minimum: 301
[    0.003397] Security Framework initialized
[    0.003404] SELinux:  Initializing.
[    0.003445] SELinux:  Starting in permissive mode
[    0.003450] AppArmor: AppArmor disabled by boot time parameter
[    0.003474] Mount-cache hash table entries: 512
[    0.004031] Initializing cgroup subsys ns
[    0.004040] Initializing cgroup subsys cpuacct
[    0.004052] Initializing cgroup subsys memory
[    0.004083] Initializing cgroup subsys devices
[    0.004087] Initializing cgroup subsys freezer
[    0.004146] using mwait in idle threads.
[    0.004155] Performance Events: Core events, core PMU driver.
[    0.004192] ... version:                1
[    0.004194] ... bit width:              40
[    0.004196] ... generic registers:      2
[    0.004198] ... value mask:             000000ffffffffff
[    0.004201] ... max period:             000000007fffffff
[    0.004203] ... fixed-purpose events:   0
[    0.004205] ... event mask:             0000000000000003
[    0.005123] lockdep: fixing up alternatives.
[    0.005126] SMP alternatives: switching to UP code
[    0.011608] ACPI: Core revision 20100702
[    0.030146] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.033789] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.066802] CPU0: Genuine Intel(R) CPU           T1350  @ 1.86GHz stepping 08
[    0.069999] NMI watchdog enabled, takes one hw-pmu counter.
[    0.069999] Brought up 1 CPUs
[    0.069999] Total of 1 processors activated (3725.69 BogoMIPS).
[    0.069999] regulator: core version 0.5
[    0.069999] Time: 17:40:53  Date: 12/05/10
[    0.069999] NET: Registered protocol family 16
[    0.069999] EISA bus registered
[    0.069999] ACPI: bus type pci registered
[    0.069999] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem
0xe0000000-0xefffffff] (base 0xe0000000)
[    0.069999] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.069999] PCI: Using MMCONFIG for extended config space
[    0.069999] PCI: Using configuration type 1 for base access
[    0.072576] bio: create slab <bio-0> at 0
[    0.081737] ACPI: EC: Look up EC in DSDT
[    0.095308] ACPI: BIOS _OSI(Linux) query ignored
[    0.097769] ACPI: Interpreter enabled
[    0.097775] ACPI: (supports S0 S3 S4 S5)
[    0.097822] ACPI: Using IOAPIC for interrupt routing
[    0.115000] ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
[    0.115900] ACPI: No dock devices found.
[    0.115907] PCI: Ignoring host bridge windows from ACPI; if
necessary, use "pci=use_crs" and report a bug
[    0.116528] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.117796] pci_root PNP0A08:00: host bridge window [io
0x0000-0x0cf7] (ignored)
[    0.117801] pci_root PNP0A08:00: host bridge window [io
0x0d00-0xffff] (ignored)
[    0.117804] pci_root PNP0A08:00: host bridge window [mem
0x000a0000-0x000bffff] (ignored)
[    0.117808] pci_root PNP0A08:00: host bridge window [mem
0x000d0000-0x000d3fff] (ignored)
[    0.117812] pci_root PNP0A08:00: host bridge window [mem
0x000d4000-0x000d7fff] (ignored)
[    0.117816] pci_root PNP0A08:00: host bridge window [mem
0x000d8000-0x000dbfff] (ignored)
[    0.117820] pci_root PNP0A08:00: host bridge window [mem
0xa0000000-0xfebfffff] (ignored)
[    0.118083] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.118090] pci 0000:00:01.0: PME# disabled
[    0.118257] pci 0000:00:1b.0: reg 10: [mem 0xde300000-0xde303fff 64bit]
[    0.118407] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.118415] pci 0000:00:1b.0: PME# disabled
[    0.118612] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.118620] pci 0000:00:1c.0: PME# disabled
[    0.118821] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.118830] pci 0000:00:1c.1: PME# disabled
[    0.119034] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.119042] pci 0000:00:1c.2: PME# disabled
[    0.119197] pci 0000:00:1d.0: reg 20: [io  0x1800-0x181f]
[    0.119366] pci 0000:00:1d.1: reg 20: [io  0x1820-0x183f]
[    0.119534] pci 0000:00:1d.2: reg 20: [io  0x1840-0x185f]
[    0.119703] pci 0000:00:1d.3: reg 20: [io  0x1860-0x187f]
[    0.119835] pci 0000:00:1d.7: reg 10: [mem 0xde304000-0xde3043ff]
[    0.120008] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.120017] pci 0000:00:1d.7: PME# disabled
[    0.120381] pci 0000:00:1f.0: quirk: [io  0x1000-0x107f] claimed by
ICH6 ACPI/GPIO/TCO
[    0.120388] pci 0000:00:1f.0: quirk: [io  0x1180-0x11bf] claimed by ICH6 GPIO
[    0.120395] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at
0680 (mask 007f)
[    0.120405] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at
0380 (mask 0007)
[    0.120501] pci 0000:00:1f.1: reg 10: [io  0x0000-0x0007]
[    0.120522] pci 0000:00:1f.1: reg 14: [io  0x0000-0x0003]
[    0.120543] pci 0000:00:1f.1: reg 18: [io  0x0000-0x0007]
[    0.120564] pci 0000:00:1f.1: reg 1c: [io  0x0000-0x0003]
[    0.120585] pci 0000:00:1f.1: reg 20: [io  0x1880-0x188f]
[    0.120710] pci 0000:00:1f.2: reg 10: [io  0x18c8-0x18cf]
[    0.120731] pci 0000:00:1f.2: reg 14: [io  0x18ac-0x18af]
[    0.120752] pci 0000:00:1f.2: reg 18: [io  0x18c0-0x18c7]
[    0.120773] pci 0000:00:1f.2: reg 1c: [io  0x18a8-0x18ab]
[    0.120794] pci 0000:00:1f.2: reg 20: [io  0x18b0-0x18bf]
[    0.120815] pci 0000:00:1f.2: reg 24: [mem 0xde304400-0xde3047ff]
[    0.120890] pci 0000:00:1f.2: PME# supported from D3hot
[    0.120898] pci 0000:00:1f.2: PME# disabled
[    0.121047] pci 0000:00:1f.3: reg 20: [io  0x18e0-0x18ff]
[    0.121251] pci 0000:01:00.0: reg 10: [mem 0xdd000000-0xddffffff]
[    0.121277] pci 0000:01:00.0: reg 14: [mem 0xc0000000-0xcfffffff 64bit pref]
[    0.121302] pci 0000:01:00.0: reg 1c: [mem 0xdc000000-0xdcffffff 64bit]
[    0.121334] pci 0000:01:00.0: reg 30: [mem 0x00000000-0x0001ffff pref]
[    0.121404] pci 0000:01:00.0: disabling ASPM on pre-1.1 PCIe
device.  You can enable it with 'pcie_aspm=force'
[    0.121432] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.121439] pci 0000:00:01.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.121446] pci 0000:00:01.0:   bridge window [mem 0xdc000000-0xddffffff]
[    0.121456] pci 0000:00:01.0:   bridge window [mem
0xc0000000-0xcfffffff 64bit pref]
[    0.121741] pci 0000:02:00.0: reg 10: [mem 0xd8000000-0xd8000fff]
[    0.122154] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
[    0.122170] pci 0000:02:00.0: PME# disabled
[    0.122243] pci 0000:02:00.0: disabling ASPM on pre-1.1 PCIe
device.  You can enable it with 'pcie_aspm=force'
[    0.122280] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.122289] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    0.122297] pci 0000:00:1c.0:   bridge window [mem 0xd8000000-0xd9ffffff]
[    0.122310] pci 0000:00:1c.0:   bridge window [mem
0xd2000000-0xd3ffffff 64bit pref]
[    0.122421] pci 0000:00:1c.1: PCI bridge to [bus 03-04]
[    0.122429] pci 0000:00:1c.1:   bridge window [io  0x3000-0x3fff]
[    0.122437] pci 0000:00:1c.1:   bridge window [mem 0xd6000000-0xd7ffffff]
[    0.122451] pci 0000:00:1c.1:   bridge window [mem
0xd0000000-0xd1ffffff 64bit pref]
[    0.122643] pci 0000:05:00.0: reg 10: [mem 0xda000000-0xda01ffff]
[    0.122702] pci 0000:05:00.0: reg 18: [io  0x4000-0x401f]
[    0.122901] pci 0000:05:00.0: PME# supported from D0 D3hot D3cold
[    0.122912] pci 0000:05:00.0: PME# disabled
[    0.122958] pci 0000:05:00.0: disabling ASPM on pre-1.1 PCIe
device.  You can enable it with 'pcie_aspm=force'
[    0.122987] pci 0000:00:1c.2: PCI bridge to [bus 05-06]
[    0.122995] pci 0000:00:1c.2:   bridge window [io  0x4000-0x4fff]
[    0.123003] pci 0000:00:1c.2:   bridge window [mem 0xda000000-0xdbffffff]
[    0.123017] pci 0000:00:1c.2:   bridge window [mem
0xd4000000-0xd5ffffff 64bit pref]
[    0.123139] pci 0000:07:05.0: proprietary Ricoh MMC controller
disabled (via firewire function)
[    0.123142] pci 0000:07:05.0: MMC cards are now supported by
standard SDHCI controller
[    0.123169] pci 0000:07:05.0: reg 10: [mem 0xde000000-0xde0007ff]
[    0.123322] pci 0000:07:05.0: supports D1 D2
[    0.123338] pci 0000:07:05.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.123346] pci 0000:07:05.0: PME# disabled
[    0.123418] pci 0000:07:05.1: reg 10: [mem 0xde000800-0xde0008ff]
[    0.123569] pci 0000:07:05.1: supports D1 D2
[    0.123572] pci 0000:07:05.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.123580] pci 0000:07:05.1: PME# disabled
[    0.123652] pci 0000:07:05.2: reg 10: [mem 0xde001000-0xde0010ff]
[    0.123805] pci 0000:07:05.2: supports D1 D2
[    0.123808] pci 0000:07:05.2: PME# supported from D0 D1 D2 D3hot D3cold
[    0.123816] pci 0000:07:05.2: PME# disabled
[    0.123886] pci 0000:07:05.3: reg 10: [mem 0xde001400-0xde0014ff]
[    0.124038] pci 0000:07:05.3: supports D1 D2
[    0.124040] pci 0000:07:05.3: PME# supported from D0 D1 D2 D3hot D3cold
[    0.124048] pci 0000:07:05.3: PME# disabled
[    0.124166] pci 0000:00:1e.0: PCI bridge to [bus 07-07] (subtractive decode)
[    0.124175] pci 0000:00:1e.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.124183] pci 0000:00:1e.0:   bridge window [mem 0xde000000-0xde0fffff]
[    0.124197] pci 0000:00:1e.0:   bridge window [mem
0xfff00000-0x000fffff pref] (disabled)
[    0.124201] pci 0000:00:1e.0:   bridge window [io  0x0000-0xffff]
(subtractive decode)
[    0.124204] pci 0000:00:1e.0:   bridge window [mem
0x00000000-0xffffffff] (subtractive decode)
[    0.124259] pci_bus 0000:00: on NUMA node 0
[    0.124265] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.124558] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEGP._PRT]
[    0.124702] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    0.124819] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[    0.124912] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP03._PRT]
[    0.125098] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
[    0.138179] ACPI: PCI Interrupt Link [LNKA] (IRQs *11)
[    0.138298] ACPI: PCI Interrupt Link [LNKB] (IRQs *3)
[    0.138415] ACPI: PCI Interrupt Link [LNKC] (IRQs *3)
[    0.138531] ACPI: PCI Interrupt Link [LNKD] (IRQs *4)
[    0.138650] ACPI: PCI Interrupt Link [LNKE] (IRQs *10)
[    0.138767] ACPI: PCI Interrupt Link [LNKF] (IRQs 11) *0, disabled.
[    0.138885] ACPI: PCI Interrupt Link [LNKG] (IRQs *5)
[    0.139002] ACPI: PCI Interrupt Link [LNKH] (IRQs *7)
[    0.139064] HEST: Table is not found!
[    0.139234] vgaarb: device added:
PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.139256] vgaarb: loaded
[    0.139450] SCSI subsystem initialized
[    0.139517] libata version 3.00 loaded.
[    0.139652] usbcore: registered new interface driver usbfs
[    0.139693] usbcore: registered new interface driver hub
[    0.139764] usbcore: registered new device driver usb
[    0.140533] ACPI: WMI: Mapper loaded
[    0.140535] PCI: Using ACPI for IRQ routing
[    0.140538] PCI: pci_cache_line_size set to 64 bytes
[    0.140838] reserve RAM buffer: 0000000000002000 - 000000000000ffff
[    0.140842] reserve RAM buffer: 000000000009f800 - 000000000009ffff
[    0.140846] reserve RAM buffer: 000000009fe70000 - 000000009fffffff
[    0.141137] Bluetooth: Core ver 2.15
[    0.141164] NET: Registered protocol family 31
[    0.141166] Bluetooth: HCI device and connection manager initialized
[    0.141183] Bluetooth: HCI socket layer initialized
[    0.141187] NET: Registered protocol family 8
[    0.141190] NET: Registered protocol family 20
[    0.141226] NetLabel: Initializing
[    0.141228] NetLabel:  domain hash size = 128
[    0.141230] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.141280] NetLabel:  unlabeled traffic allowed by default
[    0.141360] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.141368] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.141374] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.146839] Switching to clocksource tsc
[    0.157092] pnp: PnP ACPI init
[    0.157136] ACPI: bus type pnp registered
[    0.161359] pnp: PnP ACPI: found 10 devices
[    0.161362] ACPI: ACPI bus type pnp unregistered
[    0.161366] PnPBIOS: Disabled by ACPI PNP
[    0.161393] system 00:01: [mem 0xe0000000-0xefffffff] has been reserved
[    0.161398] system 00:01: [mem 0xfed14000-0xfed17fff] has been reserved
[    0.161402] system 00:01: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.161407] system 00:01: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.161411] system 00:01: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.161416] system 00:01: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.161420] system 00:01: [mem 0xfed40000-0xfed44fff] has been reserved
[    0.161424] system 00:01: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.161441] system 00:03: [mem 0xfed00000-0xfed003ff] has been reserved
[    0.161458] system 00:05: [io  0x0380-0x0383] has been reserved
[    0.161462] system 00:05: [io  0x0680-0x069f] has been reserved
[    0.161467] system 00:05: [io  0x0800-0x080f] has been reserved
[    0.161471] system 00:05: [io  0x1000-0x107f] has been reserved
[    0.161475] system 00:05: [io  0x1180-0x11bf] has been reserved
[    0.161479] system 00:05: [io  0x1640-0x164f] has been reserved
[    0.161494] system 00:06: [io  0x06a0-0x06af] has been reserved
[    0.161498] system 00:06: [io  0x06b0-0x06ff] has been reserved
[    0.199919] pci 0000:01:00.0: BAR 6: can't assign mem pref (size 0x20000)
[    0.199923] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.199926] pci 0000:00:01.0:   bridge window [io  disabled]
[    0.199935] pci 0000:00:01.0:   bridge window [mem 0xdc000000-0xddffffff]
[    0.199942] pci 0000:00:01.0:   bridge window [mem
0xc0000000-0xcfffffff 64bit pref]
[    0.199953] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.199959] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    0.199969] pci 0000:00:1c.0:   bridge window [mem 0xd8000000-0xd9ffffff]
[    0.199978] pci 0000:00:1c.0:   bridge window [mem
0xd2000000-0xd3ffffff 64bit pref]
[    0.199992] pci 0000:00:1c.1: PCI bridge to [bus 03-04]
[    0.199997] pci 0000:00:1c.1:   bridge window [io  0x3000-0x3fff]
[    0.200008] pci 0000:00:1c.1:   bridge window [mem 0xd6000000-0xd7ffffff]
[    0.200016] pci 0000:00:1c.1:   bridge window [mem
0xd0000000-0xd1ffffff 64bit pref]
[    0.200030] pci 0000:00:1c.2: PCI bridge to [bus 05-06]
[    0.200035] pci 0000:00:1c.2:   bridge window [io  0x4000-0x4fff]
[    0.200046] pci 0000:00:1c.2:   bridge window [mem 0xda000000-0xdbffffff]
[    0.200055] pci 0000:00:1c.2:   bridge window [mem
0xd4000000-0xd5ffffff 64bit pref]
[    0.200069] pci 0000:00:1e.0: PCI bridge to [bus 07-07]
[    0.200071] pci 0000:00:1e.0:   bridge window [io  disabled]
[    0.200082] pci 0000:00:1e.0:   bridge window [mem 0xde000000-0xde0fffff]
[    0.200090] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    0.200123] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.200131] pci 0000:00:01.0: setting latency timer to 64
[    0.200153] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.200161] pci 0000:00:1c.0: setting latency timer to 64
[    0.200181] pci 0000:00:1c.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    0.200189] pci 0000:00:1c.1: setting latency timer to 64
[    0.200212] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.200221] pci 0000:00:1c.2: setting latency timer to 64
[    0.200232] pci 0000:00:1e.0: enabling device (0004 -> 0006)
[    0.200242] pci 0000:00:1e.0: setting latency timer to 64
[    0.200249] pci_bus 0000:00: resource 0 [io  0x0000-0xffff]
[    0.200252] pci_bus 0000:00: resource 1 [mem 0x00000000-0xffffffff]
[    0.200256] pci_bus 0000:01: resource 1 [mem 0xdc000000-0xddffffff]
[    0.200259] pci_bus 0000:01: resource 2 [mem 0xc0000000-0xcfffffff
64bit pref]
[    0.200263] pci_bus 0000:02: resource 0 [io  0x2000-0x2fff]
[    0.200266] pci_bus 0000:02: resource 1 [mem 0xd8000000-0xd9ffffff]
[    0.200270] pci_bus 0000:02: resource 2 [mem 0xd2000000-0xd3ffffff
64bit pref]
[    0.200273] pci_bus 0000:03: resource 0 [io  0x3000-0x3fff]
[    0.200277] pci_bus 0000:03: resource 1 [mem 0xd6000000-0xd7ffffff]
[    0.200280] pci_bus 0000:03: resource 2 [mem 0xd0000000-0xd1ffffff
64bit pref]
[    0.200284] pci_bus 0000:05: resource 0 [io  0x4000-0x4fff]
[    0.200287] pci_bus 0000:05: resource 1 [mem 0xda000000-0xdbffffff]
[    0.200291] pci_bus 0000:05: resource 2 [mem 0xd4000000-0xd5ffffff
64bit pref]
[    0.200294] pci_bus 0000:07: resource 1 [mem 0xde000000-0xde0fffff]
[    0.200298] pci_bus 0000:07: resource 4 [io  0x0000-0xffff]
[    0.200301] pci_bus 0000:07: resource 5 [mem 0x00000000-0xffffffff]
[    0.200404] NET: Registered protocol family 2
[    0.200735] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.201819] TCP established hash table entries: 131072 (order: 8,
1048576 bytes)
[    0.202666] TCP bind hash table entries: 65536 (order: 9, 2621440 bytes)
[    0.206349] TCP: Hash tables configured (established 131072 bind 65536)
[    0.206398] TCP reno registered
[    0.206410] UDP hash table entries: 512 (order: 3, 49152 bytes)
[    0.206499] UDP-Lite hash table entries: 512 (order: 3, 49152 bytes)
[    0.206820] NET: Registered protocol family 1
[    0.207088] pci 0000:01:00.0: Boot video device
[    0.207138] PCI: CLS 64 bytes, default 64
[    0.207348] Trying to unpack rootfs image as initramfs...
[    2.704431] Freeing initrd memory: 79324k freed
[    2.761446] Simple Boot Flag at 0x35 set to 0x1
[    2.761614] cpufreq-nforce2: No nForce2 chipset.
[    2.761696] Scanning for low memory corruption every 60 seconds
[    2.762098] audit: initializing netlink socket (disabled)
[    2.762163] type=2000 audit(1291570855.759:1): initialized
[    2.782117] highmem bounce pool size: 64 pages
[    2.782127] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    2.786660] VFS: Disk quotas dquot_6.5.2
[    2.786920] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    2.788687] fuse init (API version 7.15)
[    2.788907] msgmni has been set to 1419
[    2.789231] SELinux:  Registering netfilter hooks
[    2.789971] io scheduler noop registered
[    2.789975] io scheduler deadline registered (default)
[    2.790509] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    2.790607] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    2.790752] intel_idle: MWAIT substates: 0x22220
[    2.790755] intel_idle: does not run on family 6 model 14
[    2.791279] ACPI: AC Adapter [ACAD] (on-line)
[    2.791538] input: Power Button as
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    2.791560] ACPI: Power Button [PWRB]
[    2.791683] input: Sleep Button as
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input1
[    2.791690] ACPI: Sleep Button [SLPB]
[    2.791816] input: Lid Switch as
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input2
[    2.792072] ACPI: Lid Switch [LID]
[    2.792237] input: Power Button as
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[    2.792244] ACPI: Power Button [PWRF]
[    2.792862] ACPI: acpi_idle registered with cpuidle
[    2.793055] Marking TSC unstable due to TSC halts in idle
[    2.793685] Switching to clocksource hpet
[    2.799689] thermal LNXTHERM:01: registered as thermal_zone0
[    2.799716] ACPI: Thermal Zone [THR1] (50 C)
[    2.799936] ERST: Table is not found!
[    2.799965] isapnp: Scanning for PnP cards...
[    3.157241] isapnp: No Plug & Play device found
[    3.158057] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    3.162696] brd: module loaded
[    3.164429] loop: module loaded
[    3.164779] ahci 0000:00:1f.2: version 3.0
[    3.164814] ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    3.164893] ahci 0000:00:1f.2: irq 40 for MSI/MSI-X
[    3.165023] ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 4 ports 1.5
Gbps 0x5 impl SATA mode
[    3.165028] ahci 0000:00:1f.2: flags: 64bit ncq pm led clo pio slum part
[    3.165037] ahci 0000:00:1f.2: setting latency timer to 64
[    3.165313] scsi0 : ahci
[    3.165572] scsi1 : ahci
[    3.165758] scsi2 : ahci
[    3.165938] scsi3 : ahci
[    3.166348] ata1: SATA max UDMA/133 abar m1024@0xde304400 port
0xde304500 irq 40
[    3.166351] ata2: DUMMY
[    3.166354] ata3: SATA max UDMA/133 abar m1024@0xde304400 port
0xde304600 irq 40
[    3.166357] ata4: DUMMY
[    3.166698] ata_piix 0000:00:1f.1: version 2.13
[    3.166714] ata_piix 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    3.166794] ata_piix 0000:00:1f.1: setting latency timer to 64
[    3.167087] scsi4 : ata_piix
[    3.167377] scsi5 : ata_piix
[    3.168178] ata5: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x1880 irq 14
[    3.168181] ata6: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x1888 irq 15
[    3.170597] Fixed MDIO Bus: probed
[    3.170604] PPP generic driver version 2.4.2
[    3.170953] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    3.171012] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    3.171032] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    3.171038] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    3.171278] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned
bus number 1
[    3.171324] ehci_hcd 0000:00:1d.7: using broken periodic workaround
[    3.171344] ehci_hcd 0000:00:1d.7: debug port 1
[    3.175245] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[    3.175695] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xde304000
[    3.179652] ata6: port disabled. ignoring.
[    3.186697] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    3.187148] hub 1-0:1.0: USB hub found
[    3.187159] hub 1-0:1.0: 8 ports detected
[    3.187486] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    3.187543] uhci_hcd: USB Universal Host Controller Interface driver
[    3.187602] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    3.187614] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    3.187619] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    3.187727] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned
bus number 2
[    3.187765] uhci_hcd 0000:00:1d.0: irq 23, io base 0x00001800
[    3.188069] hub 2-0:1.0: USB hub found
[    3.188080] hub 2-0:1.0: 2 ports detected
[    3.188310] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    3.188321] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    3.188327] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    3.188435] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned
bus number 3
[    3.188498] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00001820
[    3.188786] hub 3-0:1.0: USB hub found
[    3.188796] hub 3-0:1.0: 2 ports detected
[    3.189037] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    3.189048] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    3.189053] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    3.189158] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned
bus number 4
[    3.189223] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001840
[    3.189513] hub 4-0:1.0: USB hub found
[    3.189523] hub 4-0:1.0: 2 ports detected
[    3.189760] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
[    3.189771] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[    3.189776] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    3.189884] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned
bus number 5
[    3.189949] uhci_hcd 0000:00:1d.3: irq 16, io base 0x00001860
[    3.190258] hub 5-0:1.0: USB hub found
[    3.190268] hub 5-0:1.0: 2 ports detected
[    3.190592] usbcore: registered new interface driver libusual
[    3.190667] usbcore: registered new interface driver usbserial
[    3.190702] USB Serial support registered for generic
[    3.190746] usbcore: registered new interface driver usbserial_generic
[    3.190748] usbserial: USB Serial Driver core
[    3.190860] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at
0x60,0x64 irq 1,12
[    3.203533] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.203545] serio: i8042 AUX port at 0x60,0x64 irq 12
[    3.203812] mice: PS/2 mouse device common for all mice
[    3.204951] rtc_cmos 00:07: RTC can wake from S4
[    3.205088] rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
[    3.205132] rtc0: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
[    3.205448] device-mapper: uevent: version 1.0.3
[    3.205596] device-mapper: ioctl: 4.18.0-ioctl (2010-06-29)
initialised: dm-devel@redhat.com
[    3.205723] device-mapper: multipath: version 1.1.1 loaded
[    3.205737] device-mapper: multipath round-robin: version 1.0.0 loaded
[    3.206050] EISA: Probing bus 0 at eisa.0
[    3.206060] Cannot allocate resource for EISA slot 1
[    3.206064] Cannot allocate resource for EISA slot 2
[    3.206067] Cannot allocate resource for EISA slot 3
[    3.206070] Cannot allocate resource for EISA slot 4
[    3.206106] EISA: Detected 0 cards.
[    3.206359] cpuidle: using governor ladder
[    3.206619] cpuidle: using governor menu
[    3.209019] TCP cubic registered
[    3.209576] NET: Registered protocol family 10
[    3.211799] lo: Disabled Privacy Extensions
[    3.213559] NET: Registered protocol family 17
[    3.213873] Bluetooth: L2CAP ver 2.15
[    3.213876] Bluetooth: L2CAP socket layer initialized
[    3.213890] Bluetooth: SCO (Voice Link) ver 0.6
[    3.213892] Bluetooth: SCO socket layer initialized
[    3.214039] Bluetooth: RFCOMM TTY layer initialized
[    3.214052] Bluetooth: RFCOMM socket layer initialized
[    3.214054] Bluetooth: RFCOMM ver 1.11
[    3.214108] Registering the dns_resolver key type
[    3.214505] Using IPI No-Shortcut mode
[    3.214683] PM: Resume from disk failed.
[    3.214724] registered taskstats version 1
[    3.215446]   Magic number: 6:348:693
[    3.215579] rtc_cmos 00:07: setting system clock to 2010-12-05
17:40:57 UTC (1291570857)
[    3.215583] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    3.215585] EDD information not available.
[    3.215867] ACPI: Battery Slot [BAT0] (battery present)
[    3.218846] input: AT Translated Set 2 keyboard as
/devices/platform/i8042/serio0/input/input4
[    3.333858] ata5.00: ATAPI: HL-DT-ST DVDRAM GSA-4084N, KQ09, max MWDMA2
[    3.348267] ata5.00: configured for MWDMA2
[    3.486810] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    3.488267] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES)
filtered out
[    3.488274] ata1.00: ATA-7: ST98823AS, 7.24, max UDMA/100
[    3.488278] ata1.00: 156301488 sectors, multi 16: LBA48
[    3.489961] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES)
filtered out
[    3.489969] ata1.00: configured for UDMA/100
[    3.493488] ata3: SATA link down (SStatus 0 SControl 300)
[    3.493542] usb 1-4: new high speed USB device using ehci_hcd and address 2
[    3.500333] scsi 0:0:0:0: Direct-Access     ATA      ST98823AS
  7.24 PQ: 0 ANSI: 5
[    3.500802] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    3.500941] sd 0:0:0:0: [sda] 156301488 512-byte logical blocks:
(80.0 GB/74.5 GiB)
[    3.501105] sd 0:0:0:0: [sda] Write Protect is off
[    3.501109] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.501176] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    3.510308] scsi 4:0:0:0: CD-ROM            HL-DT-ST DVDRAM
GSA-4084N KQ09 PQ: 0 ANSI: 5
[    3.522227] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw
xa/form2 cdda tray
[    3.522232] cdrom: Uniform CD-ROM driver Revision: 3.20
[    3.522488] sr 4:0:0:0: Attached scsi CD-ROM sr0
[    3.522605] sr 4:0:0:0: Attached scsi generic sg1 type 5
[    3.542947]  sda: sda1 sda2 sda4 < sda5 sda6 >
[    3.543842] sd 0:0:0:0: [sda] Attached SCSI disk
[    3.543873] Freeing unused kernel memory: 1836k freed
[    3.545779] Write protecting the kernel text: 4916k
[    3.546086] Write protecting the kernel read-only data: 1880k
[    3.717010] udevd (114): /proc/114/oom_adj is deprecated, please
use /proc/114/oom_score_adj instead.
[    4.042694] input: Video Bus as
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:00/LNXVIDEO:00/input/input5
[    4.042834] ACPI: Video Device [VGA] (multi-head: yes  rom: no  post: no)
[    4.100271] Linux agpgart interface v0.103
[    4.213938] e1000e: Intel(R) PRO/1000 Network Driver - 1.2.7-k2
[    4.213943] e1000e: Copyright (c) 1999 - 2010 Intel Corporation.
[    4.214010] e1000e 0000:05:00.0: Disabling ASPM  L1
[    4.214045] e1000e 0000:05:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    4.214076] e1000e 0000:05:00.0: setting latency timer to 64
[    4.218949] e1000e 0000:05:00.0: irq 41 for MSI/MSI-X
[    4.219454] e1000e 0000:05:00.0: Disabling ASPM L0s
[    4.305485] ohci1394 0000:07:05.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    4.305497] ohci1394 0000:07:05.0: setting latency timer to 64
[    4.327342] e1000e 0000:05:00.0: eth0: (PCI Express:2.5GB/s:Width
x1) 00:16:36:8c:dc:cc
[    4.327348] e1000e 0000:05:00.0: eth0: Intel(R) PRO/1000 Network Connection
[    4.327427] e1000e 0000:05:00.0: eth0: MAC: 2, PHY: 2, PBA No: ffffff-0ff
[    4.362089] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[16]
MMIO=[de000000-de0007ff]  Max Packet=[2048]  IR/IT contexts=[4/4]
[    5.198987] md: linear personality registered for level -1
[    5.204498] md: multipath personality registered for level -4
[    5.209311] md: raid0 personality registered for level 0
[    5.225230] md: raid1 personality registered for level 1
[    5.239491] async_tx: api initialized (async)
[    5.300086] raid6: int32x1    591 MB/s
[    5.356747] raid6: int32x2    603 MB/s
[    5.413365] raid6: int32x4    516 MB/s
[    5.470123] raid6: int32x8    442 MB/s
[    5.526686] raid6: mmxx1     1703 MB/s
[    5.583366] raid6: mmxx2     1893 MB/s
[    5.640033] raid6: sse1x1    1267 MB/s
[    5.696694] raid6: sse1x2    1714 MB/s
[    5.753370] raid6: sse2x1    1890 MB/s
[    5.810014] raid6: sse2x2    2030 MB/s
[    5.810016] raid6: using algorithm sse2x2 (2030 MB/s)
[    5.816532] xor: automatically using best checksumming function: pIII_sse
[    5.830016]    pIII_sse  :  4731.600 MB/sec
[    5.830019] xor: using function: pIII_sse (4731.600 MB/sec)
[    5.840368] md: raid6 personality registered for level 6
[    5.840373] md: raid5 personality registered for level 5
[    5.840376] md: raid4 personality registered for level 4
[    5.856191] md: raid10 personality registered for level 10
[    6.039388] PM: Starting manual resume from disk
[    6.039394] PM: Resume from partition 8:5
[    6.039396] PM: Checking hibernation image.
[    6.039603] PM: Error -22 checking image file
[    6.039609] PM: Resume from disk failed.
[    6.051707] EXT3-fs: barriers not enabled
[    6.067405] kjournald starting.  Commit interval 5 seconds
[    6.067547] EXT3-fs (sda6): mounted filesystem with writeback data mode
[    6.077168] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[009fc000c27eb800]
[    6.654408] SELinux: 2048 avtab hash slots, 23005 rules.
[    6.658888] SELinux: 2048 avtab hash slots, 23005 rules.
[    6.659260] SELinux:  6 users, 7 roles, 1122 types, 35 bools, 1
sens, 256 cats
[    6.659265] SELinux:  74 classes, 23005 rules
[    6.660275] SELinux:  Permission module_request in class system not
defined in policy.
[    6.660294] SELinux:  Permission audit_access in class file not
defined in policy.
[    6.660302] SELinux:  Permission audit_access in class dir not
defined in policy.
[    6.660307] SELinux:  Permission execmod in class dir not defined in policy.
[    6.660316] SELinux:  Permission audit_access in class lnk_file not
defined in policy.
[    6.660319] SELinux:  Permission open in class lnk_file not defined
in policy.
[    6.660323] SELinux:  Permission execmod in class lnk_file not
defined in policy.
[    6.660330] SELinux:  Permission audit_access in class chr_file not
defined in policy.
[    6.660338] SELinux:  Permission audit_access in class blk_file not
defined in policy.
[    6.660342] SELinux:  Permission execmod in class blk_file not
defined in policy.
[    6.660349] SELinux:  Permission audit_access in class sock_file
not defined in policy.
[    6.660353] SELinux:  Permission execmod in class sock_file not
defined in policy.
[    6.660360] SELinux:  Permission audit_access in class fifo_file
not defined in policy.
[    6.660364] SELinux:  Permission execmod in class fifo_file not
defined in policy.
[    6.660493] SELinux:  Class tun_socket not defined in policy.
[    6.660496] SELinux: the above unknown classes and permissions will
be allowed
[    6.660509] SELinux:  Completing initialization.
[    6.660511] SELinux:  Setting up existing superblocks.
[    6.660640] SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
[    6.660686] SELinux: initialized (dev rootfs, type rootfs), uses
genfs_contexts
[    6.662063] SELinux: initialized (dev bdev, type bdev), uses genfs_contexts
[    6.662077] SELinux: initialized (dev proc, type proc), uses genfs_contexts
[    6.662132] SELinux: initialized (dev tmpfs, type tmpfs), uses
transition SIDs
[    6.662180] SELinux: initialized (dev sockfs, type sockfs), uses task SIDs
[    6.662223] SELinux: initialized (dev debugfs, type debugfs), uses
genfs_contexts
[    6.664673] SELinux: initialized (dev pipefs, type pipefs), uses task SIDs
[    6.664718] SELinux: initialized (dev anon_inodefs, type
anon_inodefs), uses genfs_contexts
[    6.664760] SELinux: initialized (dev devpts, type devpts), uses
transition SIDs
[    6.664809] SELinux: initialized (dev hugetlbfs, type hugetlbfs),
uses genfs_contexts
[    6.664849] SELinux: initialized (dev mqueue, type mqueue), uses
transition SIDs
[    6.664861] SELinux: initialized (dev selinuxfs, type selinuxfs),
uses genfs_contexts
[    6.665018] SELinux: initialized (dev usbfs, type usbfs), uses genfs_contexts
[    6.665055] SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
[    6.668263] SELinux: initialized (dev tmpfs, type tmpfs), uses
transition SIDs
[    6.681731] SELinux: initialized (dev sda6, type ext3), uses xattr
[    6.690801] type=1403 audit(1291570860.973:2): policy loaded
auid=4294967295 ses=4294967295
[    8.551700] SELinux: initialized (dev fusectl, type fusectl), uses
genfs_contexts
[    8.557339] SELinux: initialized (dev securityfs, type securityfs),
uses genfs_contexts
[    8.563824] SELinux: initialized (dev tmpfs, type tmpfs), uses
transition SIDs
[    8.591762] SELinux: initialized (dev tmpfs, type tmpfs), uses
transition SIDs
[    8.637055] SELinux: initialized (dev tmpfs, type tmpfs), uses
transition SIDs
[    8.677630] SELinux: initialized (dev tmpfs, type tmpfs), uses
transition SIDs
[    8.788349] type=1400 audit(1291560063.069:3): avc:  denied  { read
} for  pid=470 comm="fsck" path="/proc/454/mountinfo" dev=proc
ino=4580 scontext=system_u:system_r:fsadm_t:s0
tcontext=system_u:system_r:initrc_t:s0 tclass=file
[    9.274135] Adding 2931824k swap on /dev/sda5.  Priority:-1
extents:1 across:2931824k
[    9.329412] SELinux: initialized (dev cgroup, type cgroup), uses
genfs_contexts
[    9.975789] type=1400 audit(1291560064.256:4): avc:  denied  {
getattr } for  pid=480 comm="fsck.ext3" path="/cgroup" dev=cgroup
ino=4692 scontext=system_u:system_r:fsadm_t:s0
tcontext=system_u:object_r:cgroup_t:s0 tclass=dir
[   11.427729] udev: starting version 147
[   13.421512] input: HP WMI hotkeys as /devices/virtual/input/input6
[   13.580487] input: PC Speaker as /devices/platform/pcspkr/input/input7
[   13.704296] lp: driver loaded but no devices found
[   13.845584] intel_rng: FWH not detected
[   13.900943] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   14.412574] leds_ss4200: no LED devices found
[   14.642617] sdhci: Secure Digital Host Controller Interface driver
[   14.642621] sdhci: Copyright(c) Pierre Ossman
[   14.687176] coretemp coretemp.0: Unable to read TjMax from CPU.
[   14.687180] coretemp coretemp.0: TjMax is assumed as 100 C!
[   14.823287] sdhci-pci 0000:07:05.1: SDHCI controller found
[1180:0822] (rev 19)
[   14.823312] sdhci-pci 0000:07:05.1: enabling device (0000 -> 0002)
[   14.823323] sdhci-pci 0000:07:05.1: PCI INT B -> GSI 17 (level,
low) -> IRQ 17
[   14.824503] sdhci-pci 0000:07:05.1: Will use DMA mode even though
HW doesn't fully claim to support it.
[   14.824517] sdhci-pci 0000:07:05.1: setting latency timer to 64
[   14.824566] mmc0: no vmmc regulator found
[   14.826893] Registered led device: mmc0::
[   14.828251] mmc0: SDHCI controller on PCI [0000:07:05.1] using DMA
[   14.953531] Synaptics Touchpad, model: 1, fw: 6.3, id: 0x1a0b1,
caps: 0xa04713/0x200000/0x0
[   15.013820] input: SynPS/2 Synaptics TouchPad as
/devices/platform/i8042/serio1/input/input8
[   15.202703] iTCO_vendor_support: vendor-support=0
[   15.205353] cfg80211: Calling CRDA to update world regulatory domain
[   15.457180] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.06
[   15.458662] iTCO_wdt: Found a ICH7-M or ICH7-U TCO device
(Version=2, TCOBASE=0x1060)
[   15.460901] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[   15.597069] r852 0000:07:05.3: enabling device (0000 -> 0002)
[   15.597082] r852 0000:07:05.3: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[   15.597095] r852 0000:07:05.3: setting latency timer to 64
[   15.597200] r852: Non dma capable device detected, dma disabled
[   15.597295] r852: driver loaded succesfully
[   15.884034] ip_tables: (C) 2000-2006 Netfilter Core Team
[   17.166861] iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network
Connection driver for Linux, in-tree:s
[   17.166866] iwl3945: Copyright(c) 2003-2010 Intel Corporation
[   17.167013] iwl3945 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   17.167031] iwl3945 0000:02:00.0: setting latency timer to 64
[   17.208593] iwl3945 0000:02:00.0: Tunable channels: 11 802.11bg, 13
802.11a channels
[   17.208598] iwl3945 0000:02:00.0: Detected Intel Wireless WiFi Link 3945ABG
[   17.208826] iwl3945 0000:02:00.0: irq 42 for MSI/MSI-X
[   17.642335] cfg80211: World regulatory domain updated:
[   17.642340]     (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[   17.642344]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   17.642348]     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   17.642351]     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   17.642354]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   17.642358]     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   17.833438] phy0: Selected rate control algorithm 'iwl-3945-rs'
[   18.239943] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level,
low) -> IRQ 22
[   18.240066] HDA Intel 0000:00:1b.0: irq 43 for MSI/MSI-X
[   18.240133] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   18.501273] input: HDA Digital PCBeep as
/devices/pci0000:00/0000:00:1b.0/input/input9
[   19.567249] nvidia: module license 'NVIDIA' taints kernel.
[   19.567256] Disabling lock debugging due to kernel taint
[   21.089206] nvidia 0000:01:00.0: power state changed by ACPI to D0
[   21.089219] nvidia 0000:01:00.0: power state changed by ACPI to D0
[   21.089230] nvidia 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   21.089242] nvidia 0000:01:00.0: setting latency timer to 64
[   21.089249] vgaarb: device changed decodes:
PCI:0000:01:00.0,olddecodes=io+mem,decodes=none:owns=io+mem
[   21.090160] NVRM: loading NVIDIA UNIX x86 Kernel Module  260.19.12
Fri Oct  8 13:22:24 PDT 2010
[  415.895744] EXT3-fs (sda6): using internal journal
[  416.549056] EXT3-fs: barriers not enabled
[  416.720620] kjournald starting.  Commit interval 5 seconds
[  416.969649] EXT3-fs (sda1): using internal journal
[  416.969660] EXT3-fs (sda1): mounted filesystem with writeback data mode
[  417.034080] SELinux: initialized (dev sda1, type ext3), uses xattr
[  417.575998] SGI XFS with ACLs, security attributes, realtime, large
block/inode numbers, no debug enabled
[  417.589915] SGI XFS Quota Management subsystem
[  417.754174] XFS mounting filesystem sda2
[  418.908494] Ending clean XFS mount for filesystem: sda2
[  418.908543] SELinux: initialized (dev sda2, type xfs), uses xattr
[  418.954802] SELinux: initialized (dev configfs, type configfs),
uses genfs_contexts
[  420.059129] type=1400 audit(1291560474.339:5): avc:  denied  { read
} for  pid=1110 comm="avahi-daemon" path="pipe:[8378]" dev=pipefs
ino=8378 scontext=system_u:system_r:avahi_t:s0
tcontext=system_u:system_r:init_t:s0 tclass=fifo_file
[  420.463134] type=1400 audit(1291560474.743:6): avc:  denied  {
write } for  pid=1134 comm="avahi-daemon" name="log" dev=tmpfs
ino=8258 scontext=system_u:system_r:avahi_t:s0
tcontext=system_u:object_r:device_t:s0 tclass=sock_file
[  420.463186] type=1400 audit(1291560474.743:7): avc:  denied  {
sendto } for  pid=1134 comm="avahi-daemon" path="/dev/log"
scontext=system_u:system_r:avahi_t:s0
tcontext=system_u:system_r:init_t:s0 tclass=unix_dgram_socket
[  420.524637] type=1400 audit(1291560474.806:8): avc:  denied  {
connectto } for  pid=1134 comm="avahi-daemon"
path="/var/run/dbus/system_bus_socket"
scontext=system_u:system_r:avahi_t:s0
tcontext=system_u:system_r:init_t:s0 tclass=unix_stream_socket
[  420.691999] type=1400 audit(1291560474.973:9): avc:  denied  {
connectto } for  pid=1138 comm="hald"
path="/var/run/dbus/system_bus_socket"
scontext=system_u:system_r:hald_t:s0
tcontext=system_u:system_r:init_t:s0 tclass=unix_stream_socket
[  424.198998] type=1400 audit(1291560478.479:10): avc:  denied  {
getattr } for  pid=1371 comm="udevadm"
path="/dev/.udev/db/input:event3" dev=tmpfs ino=5883
scontext=system_u:system_r:hald_t:s0
tcontext=system_u:object_r:device_t:s0 tclass=file
[  424.199023] type=1400 audit(1291560478.479:11): avc:  denied  {
read } for  pid=1371 comm="udevadm" name="input:event3" dev=tmpfs
ino=5883 scontext=system_u:system_r:hald_t:s0
tcontext=system_u:object_r:device_t:s0 tclass=file
[  424.199039] type=1400 audit(1291560478.479:12): avc:  denied  {
open } for  pid=1371 comm="udevadm" name="input:event3" dev=tmpfs
ino=5883 scontext=system_u:system_r:hald_t:s0
tcontext=system_u:object_r:device_t:s0 tclass=file
[  425.066930] e1000e 0000:05:00.0: irq 41 for MSI/MSI-X
[  425.120905] e1000e 0000:05:00.0: irq 41 for MSI/MSI-X
[  425.121496] ADDRCONF(NETDEV_UP): eth0: link is not ready
[  457.842995] SELinux: initialized (dev fuse, type fuse), uses genfs_contexts
[  510.956212] RPC: Registered udp transport module.
[  510.956217] RPC: Registered tcp transport module.
[  510.956220] RPC: Registered tcp NFSv4.1 backchannel transport module.
[  512.114868] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[  543.695481] vboxdrv: Trying to deactivate the NMI watchdog permanently...
[  543.695486] vboxdrv: Warning: 2.6.31+ kernel detected. Most likely
the hardware performance
[  543.695488] vboxdrv: counter framework which can generate NMIs is
active. You have to prevent
[  543.695490] vboxdrv: the usage of hardware performance counters by
[  543.695491] vboxdrv:   echo 2 > /proc/sys/kernel/perf_counter_paranoid
[  543.695496] vboxdrv: Found 1 processor cores.
[  543.703379] vboxdrv: TSC mode is 'synchronous', kernel timer mode
is 'normal'.
[  543.703383] vboxdrv: Successfully loaded version 3.2.10 (interface
0x00140001).
[  548.211678] ppdev: user-space parallel port driver
[  550.877532] SELinux: initialized (dev binfmt_misc, type
binfmt_misc), uses genfs_contexts
[  565.065411] tun: Universal TUN/TAP device driver, 1.6
[  565.065416] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[  565.132257] ADDRCONF(NETDEV_UP): vtap0: link is not ready
[  565.136269] type=1400 audit(1291560619.416:13): avc:  denied  {
sendto } for  pid=1134 comm="avahi-daemon" path="/dev/log"
scontext=system_u:system_r:avahi_t:s0
tcontext=system_u:system_r:init_t:s0 tclass=unix_dgram_socket
[  565.200423] Bridge firewalling registered
[  575.323293] br0: no IPv6 routers present
[  603.730063] usb 1-1: new high speed USB device using ehci_hcd and address 3
[  603.967726] Initializing USB Mass Storage driver...
[  603.968317] scsi6 : usb-storage 1-1:1.0
[  603.968528] usbcore: registered new interface driver usb-storage
[  603.968530] USB Mass Storage support registered.
[  603.969210] usb 1-1: USB disconnect, address 3
[  612.240007] usb 1-1: new high speed USB device using ehci_hcd and address 4
[  612.381810] scsi9 : usb-storage 1-1:1.2
[  612.382804] scsi10 : usb-storage 1-1:1.3
[  612.448470] USB Serial support registered for GSM modem (1-port)
[  612.449214] option 1-1:1.0: GSM modem (1-port) converter detected
[  612.450751] usb 1-1: GSM modem (1-port) converter now attached to ttyUSB0
[  612.450775] option 1-1:1.1: GSM modem (1-port) converter detected
[  612.452223] usb 1-1: GSM modem (1-port) converter now attached to ttyUSB1
[  612.454677] usbcore: registered new interface driver option
[  612.454682] option: v0.7.2:USB Driver for GSM modems
[  613.383419] scsi 9:0:0:0: CD-ROM            HUAWEI   Mass Storage
  2.31 PQ: 0 ANSI: 2
[  613.397962] scsi 10:0:0:0: Direct-Access     HUAWEI   MMC Storage
   2.31 PQ: 0 ANSI: 2
[  613.407954] sr1: scsi-1 drive
[  613.408174] sr 9:0:0:0: Attached scsi CD-ROM sr1
[  613.408283] sr 9:0:0:0: Attached scsi generic sg2 type 5
[  613.423947] sd 10:0:0:0: Attached scsi generic sg3 type 0
[  613.432526] sd 10:0:0:0: [sdb] Attached SCSI removable disk
[  623.849825] PPP BSD Compression module registered
[  623.902223] PPP Deflate Compression module registered
[  628.035752] ISO 9660 Extensions: Microsoft Joliet Level 1
[  628.060042] ISOFS: changing to secondary root
[  628.063182] SELinux: initialized (dev sr1, type iso9660), uses genfs_contexts
[  945.288709] BUG: unable to handle kernel NULL pointer dereference at 000001bc
[  945.288718] IP: [<c0341625>] do_raw_spin_trylock+0x5/0x40
[  945.288728] *pde = 00000000
[  945.288731] Oops: 0000 [#1] SMP
[  945.288736] last sysfs file:
/sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq
[  945.288740] Modules linked in: nls_utf8 isofs ppp_deflate
zlib_deflate bsd_comp ppp_async crc_ccitt option usb_wwan usb_storage
bridge stp tun binfmt_misc ppdev vboxnetadp vboxnetflt vboxdrv
ipt_ULOG nfsd lockd nfs_acl auth_rpcgss sunrpc autofs4 configfs xfs
exportfs dm_crypt nvidia(P) snd_hda_codec_conexant snd_hda_intel
snd_hda_codec arc4 snd_pcm_oss snd_mixer_oss iwl3945 snd_pcm iwlcore
snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi iptable_filter
mac80211 snd_seq_midi_event snd_seq ip_tables r852 snd_timer iTCO_wdt
x_tables sm_common joydev snd_seq_device iTCO_vendor_support cfg80211
nand sdhci_pci snd nand_ids coretemp sdhci nand_ecc soundcore psmouse
mtd led_class shpchp snd_page_alloc serio_raw pcspkr lp hp_wmi parport
raid10 raid456 async_pq async_xor xor async_memcpy async_raid6_recov
raid6_pq async_tx raid1 raid0 multipath linear ohci1394 e1000e
intel_agp ieee1394 agpgart video output
[  945.288831]
[  945.288836] Pid: 3916, comm: udevd Tainted: P            2.6.36.1
#2 30BC/HP Pavilion dv6000 (EY798AV#ABA)
[  945.288840] EIP: 0060:[<c0341625>] EFLAGS: 00010046 CPU: 0
[  945.288844] EIP is at do_raw_spin_trylock+0x5/0x40
[  945.288847] EAX: 000001bc EBX: 000001bc ECX: 00000000 EDX: 000001bc
[  945.288850] ESI: 000001cc EDI: 00000086 EBP: ec809cb8 ESP: ec809cb8
[  945.288853]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[  945.288857] Process udevd (pid: 3916, ti=ec808000 task=ed5b94f0
task.ti=ec808000)
[  945.288860] Stack:
[  945.288862]  ec809cdc c05c4bc2 00000000 00000001 00000000 c03b0051
ef90c700 ed3d7800
[  945.288870] <0> 00000000 ec809d04 c03b0051 0000000e 00000000
00000001 00000046 000001bc
[  945.288879] <0> ef90c700 ed3d7800 00000000 ec809d24 c03b02f8
00000000 ec852000 00000000
[  945.288888] Call Trace:
[  945.288895]  [<c05c4bc2>] ? _raw_spin_lock_irqsave+0x52/0x80
[  945.288901]  [<c03b0051>] ? tty_buffer_request_room+0x21/0x150
[  945.288906]  [<c03b0051>] ? tty_buffer_request_room+0x21/0x150
[  945.288910]  [<c03b02f8>] ? tty_insert_flip_string_fixed_flag+0x38/0x90
[  945.288916]  [<f82450b7>] ? 0xf82450b7
[  945.288921]  [<c0441388>] ? usb_hcd_giveback_urb+0x48/0xc0
[  945.288927]  [<c0455e8d>] ? ehci_urb_done+0xad/0xd0
[  945.288931]  [<c0456240>] ? qh_completions+0x390/0x450
[  945.288935]  [<c0456c50>] ? ehci_work+0x90/0x8c0
[  945.288940]  [<c04578a1>] ? ehci_irq+0x21/0x200
[  945.288944]  [<c04578a1>] ? ehci_irq+0x21/0x200
[  945.288948]  [<c05c4c4c>] ? _raw_spin_lock+0x5c/0x70
[  945.288952]  [<c0457a16>] ? ehci_irq+0x196/0x200
[  945.288956]  [<c0441773>] ? usb_hcd_irq+0x33/0x70
[  945.288962]  [<c019ccc4>] ? handle_IRQ_event+0x44/0x150
[  945.288967]  [<c019ee00>] ? handle_fasteoi_irq+0x60/0xc0
[  945.288972]  [<c0104a58>] ? handle_irq+0x18/0x30
[  945.288976]  [<c01041e7>] ? do_IRQ+0x47/0xc0
[  945.288980]  [<c01033e9>] ? common_interrupt+0x29/0x30
[  945.288984]  [<c05c534f>] ? _raw_spin_unlock_irq+0x1f/0x30
[  945.288990]  [<c014656f>] ? do_setitimer+0x15f/0x1f0
[  945.288994]  [<c01466d5>] ? alarm_setitimer+0x35/0x60
[  945.289000]  [<c014e9db>] ? sys_alarm+0xb/0x10
[  945.289004]  [<c0102e58>] ? sysenter_do_call+0x12/0x33
[  945.289006] Code: 01 83 c2 01 8a 18 83 e9 01 38 1a 75 11 85 c9 75
ed b8 01 00 00 00 5b 5d c3 90 8d 74 26 00 31 c0 5b 5d c3 90 90 90 55
89 c2 89 e5 <0f> b7 02 38 e0 8d 88 00 01 00 00 75 05 3e 66 0f b1 0a 0f
94 c1
[  945.289056] EIP: [<c0341625>] do_raw_spin_trylock+0x5/0x40 SS:ESP
0068:ec809cb8
[  945.289062] CR2: 00000000000001bc


Devices (crash dev)
------------------------------------

CHRDEV    NAME              CDEV    OPERATIONS
   1      mem             f7172a40  memory_fops
   4      /dev/vc/0       c0e9bfc0  console_fops
   4      tty             f7171188  tty_fops
   4      ttyS            f6bb06c8  tty_fops
   5      /dev/tty        c0e99ca0  tty_fops
   5      /dev/console    c0e99ce0  console_fops
   5      /dev/ptmx       c0e99e40  ptmx_fops
   6      lp              c51dbd40  cleanup_module+4032
   7      vcs             f7172b40  vcs_fops
  10      misc            f711c380  misc_fops
  13      input           f7122200  input_fops
  14      sound           c522cbc0  cleanup_module+156
  21      sg              f7364440  sg_fops
  29      fb              f705ee40  fb_fops
  99      ppdev           ee642980  cleanup_module+360
 108      ppp             f6b3c480  ppp_device_fops
 116      alsa            c51306c0  snd_minor_info_oss_done+208
 128      ptm             f6bb0488  tty_fops
 136      pts             f6bb0548  tty_fops
 171      ieee1394         (none)
 180      usb             f7122080  usb_fops
 188      ttyUSB          f7326a88  tty_fops
 189      usb_device      c0ea1b80  usbdev_file_operations
 195      nvidia          c51dbc80  nv_fops
 216      rfcomm          f735f908  tty_fops
 252      hidraw          c0ea34e0  hidraw_ops
 253      usbmon          c0ea1ce0  mon_fops_binary
 254      rtc             f736b698  rtc_dev_fops

BLKDEV    NAME             GENDISK  OPERATIONS
   1      ramdisk         f6bab800  brd_fops
 259      blkext           (none)
   7      loop            f6a85400  lo_fops
   8      sd              ec880c00  sd_fops
   9      md               (none)
  11      sr              ed158c00  sr_bdops
  65      sd               (none)
  66      sd               (none)
  67      sd               (none)
  68      sd               (none)
  69      sd               (none)
  70      sd               (none)
  71      sd               (none)
 128      sd               (none)
 129      sd               (none)
 130      sd               (none)
 131      sd               (none)
 132      sd               (none)
 133      sd               (none)
 134      sd               (none)
 135      sd               (none)
 252      device-mapper    (none)
 253      pktcdvd          (none)
 254      mdp              (none)

IRQs (crash irq)
--------------------------------

    IRQ: 0
 STATUS: 400000 ()
HANDLER: c0810e40            <ioapic_chip>
         typename: c06f446b  "IO-APIC"
          startup: c011d660  <startup_ioapic_irq>
         shutdown: c019e920  <default_shutdown>
           enable: c019e970  <default_enable>
          disable: c019e880  <default_disable>
              ack: c011e4d0  <ack_apic_edge>
             mask: c011dfa0  <mask_IO_APIC_irq>
         mask_ack: 0
           unmask: c011da30  <unmask_IO_APIC_irq>
              eoi: c011e7c0  <ack_apic_level>
              end: c019cbb0  <noop>
     set_affinity: c011f5f0  <set_ioapic_affinity_irq>
        retrigger: c011e020  <ioapic_retrigger_irq>
         set_type: 0
         set_wake: 0
 ACTION: c07c5200            <irq0>
          handler: c0104e60  <timer_interrupt>
            flags: 5a20
             name: c0700585  "timer"
           dev_id: 0
             next: 0
  DEPTH: 0

    IRQ: 1
 STATUS: 0
HANDLER: c0810e40            <ioapic_chip>
         typename: c06f446b  "IO-APIC"
          startup: c011d660  <startup_ioapic_irq>
         shutdown: c019e920  <default_shutdown>
           enable: c019e970  <default_enable>
          disable: c019e880  <default_disable>
              ack: c011e4d0  <ack_apic_edge>
             mask: c011dfa0  <mask_IO_APIC_irq>
         mask_ack: 0
           unmask: c011da30  <unmask_IO_APIC_irq>
              eoi: c011e7c0  <ack_apic_level>
              end: c019cbb0  <noop>
     set_affinity: c011f5f0  <set_ioapic_affinity_irq>
        retrigger: c011e020  <ioapic_retrigger_irq>
         set_type: 0
         set_wake: 0
 ACTION: f6b3ce40
          handler: c04678f0  <i8042_interrupt>
            flags: 80
             name: c073d139  "i8042"
           dev_id: f7369000
             next: 0
  DEPTH: 0

    IRQ: 2
 STATUS: 200 (IRQ_DISABLED)
HANDLER: c07c5440            <i8259A_chip>
         typename: c06f208a  "XT-PIC"
          startup: c019e950  <default_startup>
         shutdown: c0105d00  <disable_8259A_irq>
           enable: c019e970  <default_enable>
          disable: c0105d00  <disable_8259A_irq>
              ack: 0
             mask: c0105d00  <disable_8259A_irq>
         mask_ack: c0105d00  <disable_8259A_irq>
           unmask: c0105ca0  <enable_8259A_irq>
              eoi: 0
              end: c019cbb0  <noop>
     set_affinity: 0
        retrigger: 0
         set_type: 0
         set_wake: 0
 ACTION: (none)
  DEPTH: 1

    IRQ: 3
 STATUS: 200 (IRQ_DISABLED)
HANDLER: c0810e40            <ioapic_chip>
         typename: c06f446b  "IO-APIC"
          startup: c011d660  <startup_ioapic_irq>
         shutdown: c019e920  <default_shutdown>
           enable: c019e970  <default_enable>
          disable: c019e880  <default_disable>
              ack: c011e4d0  <ack_apic_edge>
             mask: c011dfa0  <mask_IO_APIC_irq>
         mask_ack: 0
           unmask: c011da30  <unmask_IO_APIC_irq>
              eoi: c011e7c0  <ack_apic_level>
              end: c019cbb0  <noop>
     set_affinity: c011f5f0  <set_ioapic_affinity_irq>
        retrigger: c011e020  <ioapic_retrigger_irq>
         set_type: 0
         set_wake: 0
 ACTION: (none)
  DEPTH: 1

    IRQ: 4
 STATUS: 200 (IRQ_DISABLED)
HANDLER: c0810e40            <ioapic_chip>
         typename: c06f446b  "IO-APIC"
          startup: c011d660  <startup_ioapic_irq>
         shutdown: c019e920  <default_shutdown>
           enable: c019e970  <default_enable>
          disable: c019e880  <default_disable>
              ack: c011e4d0  <ack_apic_edge>
             mask: c011dfa0  <mask_IO_APIC_irq>
         mask_ack: 0
           unmask: c011da30  <unmask_IO_APIC_irq>
              eoi: c011e7c0  <ack_apic_level>
              end: c019cbb0  <noop>
     set_affinity: c011f5f0  <set_ioapic_affinity_irq>
        retrigger: c011e020  <ioapic_retrigger_irq>
         set_type: 0
         set_wake: 0
 ACTION: (none)
  DEPTH: 1

    IRQ: 5
 STATUS: 200 (IRQ_DISABLED)
HANDLER: c0810e40            <ioapic_chip>
         typename: c06f446b  "IO-APIC"
          startup: c011d660  <startup_ioapic_irq>
         shutdown: c019e920  <default_shutdown>
           enable: c019e970  <default_enable>
          disable: c019e880  <default_disable>
              ack: c011e4d0  <ack_apic_edge>
             mask: c011dfa0  <mask_IO_APIC_irq>
         mask_ack: 0
           unmask: c011da30  <unmask_IO_APIC_irq>
              eoi: c011e7c0  <ack_apic_level>
              end: c019cbb0  <noop>
     set_affinity: c011f5f0  <set_ioapic_affinity_irq>
        retrigger: c011e020  <ioapic_retrigger_irq>
         set_type: 0
         set_wake: 0
 ACTION: (none)
  DEPTH: 1

    IRQ: 6
 STATUS: 200 (IRQ_DISABLED)
HANDLER: c0810e40            <ioapic_chip>
         typename: c06f446b  "IO-APIC"
          startup: c011d660  <startup_ioapic_irq>
         shutdown: c019e920  <default_shutdown>
           enable: c019e970  <default_enable>
          disable: c019e880  <default_disable>
              ack: c011e4d0  <ack_apic_edge>
             mask: c011dfa0  <mask_IO_APIC_irq>
         mask_ack: 0
           unmask: c011da30  <unmask_IO_APIC_irq>
              eoi: c011e7c0  <ack_apic_level>
              end: c019cbb0  <noop>
     set_affinity: c011f5f0  <set_ioapic_affinity_irq>
        retrigger: c011e020  <ioapic_retrigger_irq>
         set_type: 0
         set_wake: 0
 ACTION: (none)
  DEPTH: 1

    IRQ: 7
 STATUS: 200 (IRQ_DISABLED)
HANDLER: c0810e40            <ioapic_chip>
         typename: c06f446b  "IO-APIC"
          startup: c011d660  <startup_ioapic_irq>
         shutdown: c019e920  <default_shutdown>
           enable: c019e970  <default_enable>
          disable: c019e880  <default_disable>
              ack: c011e4d0  <ack_apic_edge>
             mask: c011dfa0  <mask_IO_APIC_irq>
         mask_ack: 0
           unmask: c011da30  <unmask_IO_APIC_irq>
              eoi: c011e7c0  <ack_apic_level>
              end: c019cbb0  <noop>
     set_affinity: c011f5f0  <set_ioapic_affinity_irq>
        retrigger: c011e020  <ioapic_retrigger_irq>
         set_type: 0
         set_wake: 0
 ACTION: (none)
  DEPTH: 1

    IRQ: 8
 STATUS: 0
HANDLER: c0810e40            <ioapic_chip>
         typename: c06f446b  "IO-APIC"
          startup: c011d660  <startup_ioapic_irq>
         shutdown: c019e920  <default_shutdown>
           enable: c019e970  <default_enable>
          disable: c019e880  <default_disable>
              ack: c011e4d0  <ack_apic_edge>
             mask: c011dfa0  <mask_IO_APIC_irq>
         mask_ack: 0
           unmask: c011da30  <unmask_IO_APIC_irq>
              eoi: c011e7c0  <ack_apic_level>
              end: c019cbb0  <noop>
     set_affinity: c011f5f0  <set_ioapic_affinity_irq>
        retrigger: c011e020  <ioapic_retrigger_irq>
         set_type: 0
         set_wake: 0
 ACTION: f6b3cf00
          handler: c0123ca0  <hpet_rtc_interrupt>
            flags: 20
             name: f6b34a90  "rtc0"
           dev_id: f736b400
             next: 0
  DEPTH: 0

    IRQ: 9
 STATUS: 4000 (IRQ_LEVEL)
HANDLER: c0810e40            <ioapic_chip>
         typename: c06f446b  "IO-APIC"
          startup: c011d660  <startup_ioapic_irq>
         shutdown: c019e920  <default_shutdown>
           enable: c019e970  <default_enable>
          disable: c019e880  <default_disable>
              ack: c011e4d0  <ack_apic_edge>
             mask: c011dfa0  <mask_IO_APIC_irq>
         mask_ack: 0
           unmask: c011da30  <unmask_IO_APIC_irq>
              eoi: c011e7c0  <ack_apic_level>
              end: c019cbb0  <noop>
     set_affinity: c011f5f0  <set_ioapic_affinity_irq>
        retrigger: c011e020  <ioapic_retrigger_irq>
         set_type: 0
         set_wake: 0
 ACTION: f70640c0
          handler: c036e11c  <acpi_irq>
            flags: 80
             name: c073b204  "acpi"
           dev_id: c036e11c
             next: 0
  DEPTH: 0

    IRQ: 10
 STATUS: 200 (IRQ_DISABLED)
HANDLER: c0810e40            <ioapic_chip>
         typename: c06f446b  "IO-APIC"
          startup: c011d660  <startup_ioapic_irq>
         shutdown: c019e920  <default_shutdown>
           enable: c019e970  <default_enable>
          disable: c019e880  <default_disable>
              ack: c011e4d0  <ack_apic_edge>
             mask: c011dfa0  <mask_IO_APIC_irq>
         mask_ack: 0
           unmask: c011da30  <unmask_IO_APIC_irq>
              eoi: c011e7c0  <ack_apic_level>
              end: c019cbb0  <noop>
     set_affinity: c011f5f0  <set_ioapic_affinity_irq>
        retrigger: c011e020  <ioapic_retrigger_irq>
         set_type: 0
         set_wake: 0
 ACTION: (none)
  DEPTH: 1

    IRQ: 11
 STATUS: 200 (IRQ_DISABLED)
HANDLER: c0810e40            <ioapic_chip>
         typename: c06f446b  "IO-APIC"
          startup: c011d660  <startup_ioapic_irq>
         shutdown: c019e920  <default_shutdown>
           enable: c019e970  <default_enable>
          disable: c019e880  <default_disable>
              ack: c011e4d0  <ack_apic_edge>
             mask: c011dfa0  <mask_IO_APIC_irq>
         mask_ack: 0
           unmask: c011da30  <unmask_IO_APIC_irq>
              eoi: c011e7c0  <ack_apic_level>
              end: c019cbb0  <noop>
     set_affinity: c011f5f0  <set_ioapic_affinity_irq>
        retrigger: c011e020  <ioapic_retrigger_irq>
         set_type: 0
         set_wake: 0
 ACTION: (none)
  DEPTH: 1

    IRQ: 12
 STATUS: 0
HANDLER: c0810e40            <ioapic_chip>
         typename: c06f446b  "IO-APIC"
          startup: c011d660  <startup_ioapic_irq>
         shutdown: c019e920  <default_shutdown>
           enable: c019e970  <default_enable>
          disable: c019e880  <default_disable>
              ack: c011e4d0  <ack_apic_edge>
             mask: c011dfa0  <mask_IO_APIC_irq>
         mask_ack: 0
           unmask: c011da30  <unmask_IO_APIC_irq>
              eoi: c011e7c0  <ack_apic_level>
              end: c019cbb0  <noop>
     set_affinity: c011f5f0  <set_ioapic_affinity_irq>
        retrigger: c011e020  <ioapic_retrigger_irq>
         set_type: 0
         set_wake: 0
 ACTION: f6b3ce00
          handler: c04678f0  <i8042_interrupt>
            flags: 80
             name: c073d139  "i8042"
           dev_id: f7369000
             next: 0
  DEPTH: 0

    IRQ: 13
 STATUS: 200 (IRQ_DISABLED)
HANDLER: c0810e40            <ioapic_chip>
         typename: c06f446b  "IO-APIC"
          startup: c011d660  <startup_ioapic_irq>
         shutdown: c019e920  <default_shutdown>
           enable: c019e970  <default_enable>
          disable: c019e880  <default_disable>
              ack: c011e4d0  <ack_apic_edge>
             mask: c011dfa0  <mask_IO_APIC_irq>
         mask_ack: 0
           unmask: c011da30  <unmask_IO_APIC_irq>
              eoi: c011e7c0  <ack_apic_level>
              end: c019cbb0  <noop>
     set_affinity: c011f5f0  <set_ioapic_affinity_irq>
        retrigger: c011e020  <ioapic_retrigger_irq>
         set_type: 0
         set_wake: 0
 ACTION: (none)
  DEPTH: 1

    IRQ: 14
 STATUS: 0
HANDLER: c0810e40            <ioapic_chip>
         typename: c06f446b  "IO-APIC"
          startup: c011d660  <startup_ioapic_irq>
         shutdown: c019e920  <default_shutdown>
           enable: c019e970  <default_enable>
          disable: c019e880  <default_disable>
              ack: c011e4d0  <ack_apic_edge>
             mask: c011dfa0  <mask_IO_APIC_irq>
         mask_ack: 0
           unmask: c011da30  <unmask_IO_APIC_irq>
              eoi: c011e7c0  <ack_apic_level>
              end: c019cbb0  <noop>
     set_affinity: c011f5f0  <set_ioapic_affinity_irq>
        retrigger: c011e020  <ioapic_retrigger_irq>
         set_type: 0
         set_wake: 0
 ACTION: f6b07e40
          handler: c0412650  <ata_bmdma_interrupt>
            flags: 80
             name: c073a397  "ata_piix"
           dev_id: f6bb772c
             next: 0
  DEPTH: 0

    IRQ: 15
 STATUS: 0
HANDLER: c0810e40            <ioapic_chip>
         typename: c06f446b  "IO-APIC"
          startup: c011d660  <startup_ioapic_irq>
         shutdown: c019e920  <default_shutdown>
           enable: c019e970  <default_enable>
          disable: c019e880  <default_disable>
              ack: c011e4d0  <ack_apic_edge>
             mask: c011dfa0  <mask_IO_APIC_irq>
         mask_ack: 0
           unmask: c011da30  <unmask_IO_APIC_irq>
              eoi: c011e7c0  <ack_apic_level>
              end: c019cbb0  <noop>
     set_affinity: c011f5f0  <set_ioapic_affinity_irq>
        retrigger: c011e020  <ioapic_retrigger_irq>
         set_type: 0
         set_wake: 0
 ACTION: f6b07e80
          handler: c0412650  <ata_bmdma_interrupt>
            flags: 80
             name: c073a397  "ata_piix"
           dev_id: f6bb772c
             next: 0
  DEPTH: 0

    IRQ: 16
 STATUS: 4000 (IRQ_LEVEL)
HANDLER: c0810e40            <ioapic_chip>
         typename: c06f446b  "IO-APIC"
          startup: c011d660  <startup_ioapic_irq>
         shutdown: c019e920  <default_shutdown>
           enable: c019e970  <default_enable>
          disable: c019e880  <default_disable>
              ack: c011e4d0  <ack_apic_edge>
             mask: c011dfa0  <mask_IO_APIC_irq>
         mask_ack: 0
           unmask: c011da30  <unmask_IO_APIC_irq>
              eoi: c011e7c0  <ack_apic_level>
              end: c019cbb0  <noop>
     set_affinity: c011f5f0  <set_ioapic_affinity_irq>
        retrigger: c011e020  <ioapic_retrigger_irq>
         set_type: 0
         set_wake: 0
 ACTION: f6b3cc80
          handler: c0441740  <usb_hcd_irq>
            flags: 80
             name: f7337858  "uhci_hcd:usb5"
           dev_id: f7337800
             next: c546aec0
 ACTION: c546aec0
          handler: f85230a0  <ohci_irq_handler>
            flags: 80
             name: f8524a40  "ohci1394"
           dev_id: f708fcd8
             next: c4d63780
 ACTION: c4d63780
          handler: f957ca80  <nv_kern_isr>
            flags: 80
             name: f96e7086  "nvidia"
           dev_id: c481ec00
             next: 0
  DEPTH: 0

    IRQ: 17
 STATUS: 4000 (IRQ_LEVEL)
HANDLER: c0810e40            <ioapic_chip>
         typename: c06f446b  "IO-APIC"
          startup: c011d660  <startup_ioapic_irq>
         shutdown: c019e920  <default_shutdown>
           enable: c019e970  <default_enable>
          disable: c019e880  <default_disable>
              ack: c011e4d0  <ack_apic_edge>
             mask: c011dfa0  <mask_IO_APIC_irq>
         mask_ack: 0
           unmask: c011da30  <unmask_IO_APIC_irq>
              eoi: c011e7c0  <ack_apic_level>
              end: c019cbb0  <noop>
     set_affinity: c011f5f0  <set_ioapic_affinity_irq>
        retrigger: c011e020  <ioapic_retrigger_irq>
         set_type: 0
         set_wake: 0
 ACTION: c5130bc0
          handler: f81d6520  <sdhci_add_host+6240>
            flags: 80
             name: c565cf78  "mmc0"
           dev_id: c4c40c00
             next: c5130840
 ACTION: c5130840
          handler: f82eebc0  <r852_card_update_present+80>
            flags: 80
             name: f82ef888  "r852"
           dev_id: c52d9e00
             next: 0
  DEPTH: 0

    IRQ: 18
 STATUS: 4000 (IRQ_LEVEL)
HANDLER: c0810e40            <ioapic_chip>
         typename: c06f446b  "IO-APIC"
          startup: c011d660  <startup_ioapic_irq>
         shutdown: c019e920  <default_shutdown>
           enable: c019e970  <default_enable>
          disable: c019e880  <default_disable>
              ack: c011e4d0  <ack_apic_edge>
             mask: c011dfa0  <mask_IO_APIC_irq>
         mask_ack: 0
           unmask: c011da30  <unmask_IO_APIC_irq>
              eoi: c011e7c0  <ack_apic_level>
              end: c019cbb0  <noop>
     set_affinity: c011f5f0  <set_ioapic_affinity_irq>
        retrigger: c011e020  <ioapic_retrigger_irq>
         set_type: 0
         set_wake: 0
 ACTION: f6b3cb80
          handler: c0441740  <usb_hcd_irq>
            flags: 80
             name: f7336058  "uhci_hcd:usb4"
           dev_id: f7336000
             next: 0
  DEPTH: 0

    IRQ: 19
 STATUS: 4000 (IRQ_LEVEL)
HANDLER: c0810e40            <ioapic_chip>
         typename: c06f446b  "IO-APIC"
          startup: c011d660  <startup_ioapic_irq>
         shutdown: c019e920  <default_shutdown>
           enable: c019e970  <default_enable>
          disable: c019e880  <default_disable>
              ack: c011e4d0  <ack_apic_edge>
             mask: c011dfa0  <mask_IO_APIC_irq>
         mask_ack: 0
           unmask: c011da30  <unmask_IO_APIC_irq>
              eoi: c011e7c0  <ack_apic_level>
              end: c019cbb0  <noop>
     set_affinity: c011f5f0  <set_ioapic_affinity_irq>
        retrigger: c011e020  <ioapic_retrigger_irq>
         set_type: 0
         set_wake: 0
 ACTION: f6b3ca80
          handler: c0441740  <usb_hcd_irq>
            flags: 80
             name: f7334858  "uhci_hcd:usb3"
           dev_id: f7334800
             next: 0
  DEPTH: 0

    IRQ: 20
 STATUS: 200 (IRQ_DISABLED)
HANDLER: c07cf000            <no_irq_chip>
         typename: c0761912  "none"
          startup: c019cbc0  <noop_ret>
         shutdown: c019cbb0  <noop>
           enable: c019cbb0  <noop>
          disable: c019cbb0  <noop>
              ack: c019d090  <ack_bad>
             mask: 0
         mask_ack: 0
           unmask: 0
              eoi: 0
              end: c019cbb0  <noop>
     set_affinity: 0
        retrigger: 0
         set_type: 0
         set_wake: 0
 ACTION: (none)
  DEPTH: 1

    IRQ: 21
 STATUS: 200 (IRQ_DISABLED)
HANDLER: c07cf000            <no_irq_chip>
         typename: c0761912  "none"
          startup: c019cbc0  <noop_ret>
         shutdown: c019cbb0  <noop>
           enable: c019cbb0  <noop>
          disable: c019cbb0  <noop>
              ack: c019d090  <ack_bad>
             mask: 0
         mask_ack: 0
           unmask: 0
              eoi: 0
              end: c019cbb0  <noop>
     set_affinity: 0
        retrigger: 0
         set_type: 0
         set_wake: 0
 ACTION: (none)
  DEPTH: 1

    IRQ: 22
 STATUS: 4200 (IRQ_DISABLED|IRQ_LEVEL)

Modules (crash mod)
--------------------------------------------------------------------------------------------------------

 MODULE   NAME                       SIZE  OBJECT FILE
f8020300  output                     1851  (not loaded)  [CONFIG_KALLSYMS]
f8056240  arc4                       1018  (not loaded)  [CONFIG_KALLSYMS]
f80648e0  parport                   25181  (not loaded)  [CONFIG_KALLSYMS]
f8068960  exportfs                   2881  (not loaded)  [CONFIG_KALLSYMS]
f806f520  autofs4                   19057  (not loaded)  [CONFIG_KALLSYMS]
f8071fe0  hp_wmi                     4530  (not loaded)  [CONFIG_KALLSYMS]
f8079240  snd_hda_intel             18041  (not loaded)  [CONFIG_KALLSYMS]
f807f360  lp                         7250  (not loaded)  [CONFIG_KALLSYMS]
f8082c80  linear                     4102  (not loaded)  [CONFIG_KALLSYMS]
f8086560  nfs_acl                    1847  (not loaded)  [CONFIG_KALLSYMS]
f808d320  pcspkr                     1242  (not loaded)  [CONFIG_KALLSYMS]
f8095be0  snd_hda_codec_conexant    23962  (not loaded)  [CONFIG_KALLSYMS]
f8098b20  serio_raw                  3343  (not loaded)  [CONFIG_KALLSYMS]
f809d340  dm_crypt                   9510  (not loaded)  [CONFIG_KALLSYMS]
f80a5360  snd_page_alloc             5743  (not loaded)  [CONFIG_KALLSYMS]
f80b5460  snd_hda_codec             59368  (not loaded)  [CONFIG_KALLSYMS]
f80bc340  multipath                  6047  (not loaded)  [CONFIG_KALLSYMS]
f80bf2a0  crc_ccitt                  1109  (not loaded)  [CONFIG_KALLSYMS]
f80c47c0  ipt_ULOG                   5170  (not loaded)  [CONFIG_KALLSYMS]
f80c9680  ppp_async                  6234  (not loaded)  [CONFIG_KALLSYMS]
f80d04a0  shpchp                    22901  (not loaded)  [CONFIG_KALLSYMS]
f80d5cc0  vboxnetflt                13435  (not loaded)  [CONFIG_KALLSYMS]
f80e51e0  configfs                  19182  (not loaded)  [CONFIG_KALLSYMS]
f80f1720  auth_rpcgss               28189  (not loaded)  [CONFIG_KALLSYMS]
f80f6c00  raid0                      8135  (not loaded)  [CONFIG_KALLSYMS]
f81010e0  nls_utf8                    942  (not loaded)  [CONFIG_KALLSYMS]
f812e900  isofs                     27914  (not loaded)  [CONFIG_KALLSYMS]
f8132460  led_class                  1695  (not loaded)  [CONFIG_KALLSYMS]
f8135ec0  bsd_comp                   4218  (not loaded)  [CONFIG_KALLSYMS]
f813dfc0  vboxnetadp                 5815  (not loaded)  [CONFIG_KALLSYMS]
f8145c20  raid1                     21263  (not loaded)  [CONFIG_KALLSYMS]
f8155560  mtd                       14894  (not loaded)  [CONFIG_KALLSYMS]
f81590c0  ppdev                      4750  (not loaded)  [CONFIG_KALLSYMS]
f8164a80  psmouse                   40816  (not loaded)  [CONFIG_KALLSYMS]
f8169340  async_tx                   2031  (not loaded)  [CONFIG_KALLSYMS]
f816ce20  soundcore                  4550  (not loaded)  [CONFIG_KALLSYMS]
f8180e20  raid6_pq                  80029  (not loaded)  [CONFIG_KALLSYMS]
f81851e0  async_raid6_recov          1231  (not loaded)  [CONFIG_KALLSYMS]
f818bea0  agpgart                   30396  (not loaded)  [CONFIG_KALLSYMS]
f8194920  zlib_deflate              17758  (not loaded)  [CONFIG_KALLSYMS]
f819a2c0  video                     17303  (not loaded)  [CONFIG_KALLSYMS]
f81b1420  binfmt_misc                5602  (not loaded)  [CONFIG_KALLSYMS]
f81b3aa0  nand_ecc                   3238  (not loaded)  [CONFIG_KALLSYMS]
f81c4ae0  tun                       11461  (not loaded)  [CONFIG_KALLSYMS]
f81cba60  ppp_deflate                3098  (not loaded)  [CONFIG_KALLSYMS]
f81ce340  stp                        1282  (not loaded)  [CONFIG_KALLSYMS]
f81d74a0  sdhci                     14133  (not loaded)  [CONFIG_KALLSYMS]
f81e2e00  coretemp                   4034  (not loaded)  [CONFIG_KALLSYMS]
f81ec8c0  nand_ids                   2713  (not loaded)  [CONFIG_KALLSYMS]
f82249c0  snd                       41456  (not loaded)  [CONFIG_KALLSYMS]
f822f3a0  usb_storage               27558  (not loaded)  [CONFIG_KALLSYMS]
f8235160  sdhci_pci                  4929  (not loaded)  [CONFIG_KALLSYMS]
f8246800  usb_wwan                   7049  (not loaded)  [CONFIG_KALLSYMS]
f82523c0  nand                      30456  (not loaded)  [CONFIG_KALLSYMS]
f82581c0  option                    13229  (not loaded)  [CONFIG_KALLSYMS]
f8277b20  cfg80211                 117976  (not loaded)  [CONFIG_KALLSYMS]
f8287340  iTCO_vendor_support        1487  (not loaded)  [CONFIG_KALLSYMS]
f8292da0  snd_seq_device             4203  (not loaded)  [CONFIG_KALLSYMS]
f82a1d60  joydev                     8119  (not loaded)  [CONFIG_KALLSYMS]
f82ab9e0  sm_common                  2939  (not loaded)  [CONFIG_KALLSYMS]
f82bb520  x_tables                  10814  (not loaded)  [CONFIG_KALLSYMS]
f82cbea0  iTCO_wdt                   8429  (not loaded)  [CONFIG_KALLSYMS]
f82e1580  snd_timer                 14628  (not loaded)  [CONFIG_KALLSYMS]
f82efdc0  r852                       8978  (not loaded)  [CONFIG_KALLSYMS]
f8349500  lockd                     54924  (not loaded)  [CONFIG_KALLSYMS]
f834dec0  ip_tables                  8575  (not loaded)  [CONFIG_KALLSYMS]
f835c020  snd_seq                   38531  (not loaded)  [CONFIG_KALLSYMS]
f836ad00  snd_seq_midi_event         4097  (not loaded)  [CONFIG_KALLSYMS]
f8398580  mac80211                 172564  (not loaded)  [CONFIG_KALLSYMS]
f83a91e0  iptable_filter              922  (not loaded)  [CONFIG_KALLSYMS]
f83be2c0  snd_rawmidi               14289  (not loaded)  [CONFIG_KALLSYMS]
f83c01e0  async_memcpy               1037  (not loaded)  [CONFIG_KALLSYMS]
f83ccc60  snd_seq_midi               3758  (not loaded)  [CONFIG_KALLSYMS]
f83e2de0  snd_seq_oss               23615  (not loaded)  [CONFIG_KALLSYMS]
f83ee1e0  snd_seq_dummy               926  (not loaded)  [CONFIG_KALLSYMS]
f83f4360  xor                       14904  (not loaded)  [CONFIG_KALLSYMS]
f8416560  async_xor                  2137  (not loaded)  [CONFIG_KALLSYMS]
f8426d80  iwlcore                   62467  (not loaded)  [CONFIG_KALLSYMS]
f84382e0  bridge                    57709  (not loaded)  [CONFIG_KALLSYMS]
f84497c0  async_pq                   2902  (not loaded)  [CONFIG_KALLSYMS]
f845aea0  raid456                   52880  (not loaded)  [CONFIG_KALLSYMS]
f84681e0  raid10                    22850  (not loaded)  [CONFIG_KALLSYMS]
f847e540  snd_pcm                   54357  (not loaded)  [CONFIG_KALLSYMS]
f8484f40  snd_mixer_oss             12587  (not loaded)  [CONFIG_KALLSYMS]
f84a10c0  e1000e                   125394  (not loaded)  [CONFIG_KALLSYMS]
f84bee40  ieee1394                  80233  (not loaded)  [CONFIG_KALLSYMS]
f84f07e0  iwl3945                   61689  (not loaded)  [CONFIG_KALLSYMS]
f8509320  snd_pcm_oss               31055  (not loaded)  [CONFIG_KALLSYMS]
f85171e0  intel_agp                 24907  (not loaded)  [CONFIG_KALLSYMS]
f8525d20  ohci1394                  26939  (not loaded)  [CONFIG_KALLSYMS]
f87872c0  xfs                      612975  (not loaded)  [CONFIG_KALLSYMS]
f8e236c0  sunrpc                   153161  (not loaded)  [CONFIG_KALLSYMS]
f8e4af60  vboxdrv                  149070  (not loaded)  [CONFIG_KALLSYMS]
f8e963a0  nfsd                     218986  (not loaded)  [CONFIG_KALLSYMS]
f98cf0a0  nvidia                  9327074  (not loaded)  [CONFIG_KALLSYMS]

Timers (crash timer)
---------------------------------------------------------------------

TVEC_BASES[0]: c0a1a240
 JIFFIES
  193586
 EXPIRES  TIMER_LIST  FUNCTION
  193587   f6ac1684   c0457710  <ehci_watchdog>
  193589   cf545048   c0157fb0  <delayed_work_timer_fn>
  193614   c07ff064   c0157fb0  <delayed_work_timer_fn>
  193639   c481ed78   f957c980  <nv_kern_rc_timer>
  193664   c437f63c   c05193e0  <tcp_write_timer>
  193775   ed1b9ef0   c014e930  <process_timeout>
  193786   c437ef7c   c05193e0  <tcp_write_timer>
  193799   ed7b1ef0   c014e930  <process_timeout>
  193801   cf544be4   c0157fb0  <delayed_work_timer_fn>
  193804   c0e7b360   c01d9f20  <sync_supers_timer_fn>
  194102   edcfcd4c   f8430010  <br_timer_value+624>
  194102   c5610680   f8494aa0  <e1000_watchdog>
  194102   c4efea7c   c0157fb0  <delayed_work_timer_fn>
  194408   f6a8bcbc   c032e3c0  <blk_rq_timed_out_timer>
  194528   c0801c20   c0157fb0  <delayed_work_timer_fn>
  194611   c4e85f04   c014e930  <process_timeout>
  194816   ec9868bc   c05193e0  <tcp_write_timer>
  195008   f6a8cafc   c032e3c0  <blk_rq_timed_out_timer>
  195159   c0800ca0   c04fbe20  <peer_check_expire>
  195304   c56fb66c   c02b8670  <commit_timeout>
  195328   ec9846fc   c05193e0  <tcp_write_timer>
  195600   c0804ae0   c0157fb0  <delayed_work_timer_fn>
  195600   c0807e00   c0157fb0  <delayed_work_timer_fn>
  196183   ed749ef0   c014e930  <process_timeout>
  196763   ed51fef0   c014e930  <process_timeout>
  196800   ec984dbc   c05193e0  <tcp_write_timer>
  196928   c0ea5a64   c0157fb0  <delayed_work_timer_fn>
  197673   ef4edf04   c014e930  <process_timeout>
  198834   f6b57f08   c014e930  <process_timeout>
  198912   f8e26424   c0157fb0  <delayed_work_timer_fn>
  199200   c07c8904   c0157fb0  <delayed_work_timer_fn>
  199232   f6a8b59c   c032e3c0  <blk_rq_timed_out_timer>
  200700   c0804240   c055b4e0  <addrconf_verify>
  201728   edcfcd04   f8434340  <br_multicast_enable_port+256>
  205440   ec985b3c   c05193e0  <tcp_write_timer>
  206848   ec9861fc   c05193e0  <tcp_write_timer>
  208183   edd79ef0   c014e930  <process_timeout>
  223744   c437e1fc   c05193e0  <tcp_write_timer>
  244224   cf404184   c0159250  <idle_worker_timeout>
  250183   ed651ef0   c014e930  <process_timeout>
  260352   edcfce24   f842bda0  <br_fdb_cleanup>
  270336   c0ea6030   c0534650  <inet_frag_secret_rebuild>
  270900   c07e1d64   c0157fb0  <delayed_work_timer_fn>
  271360   c0ea5480   c04e1bb0  <flow_cache_new_hashrnd>
  271360   c0ea7b10   c0534650  <inet_frag_secret_rebuild>
  271360   c0ea5640   c04e7f30  <rif_check_expire>
  274055   f709debc   c014e930  <process_timeout>
 2351104   c437ee2c   c05189d0  <tcp_keepalive_timer>
25690112   c5498910   c0558c00  <ipv6_regen_rndid>
25690112   c4e94710   c0558c00  <ipv6_regen_rndid>
25821184   ee6c8310   c0558c00  <ipv6_regen_rndid>
25821184   ed097f10   c0558c00  <ipv6_regen_rndid>
25821184   ed560f10   c0558c00  <ipv6_regen_rndid>

Run Queue
------------------------------------------------------------------------------

CPU 0 RUNQUEUE: cf547a40
  CURRENT: PID: 3916   TASK: ed5b94f0  COMMAND: "udevd"
  RT PRIO_ARRAY: cf547b04
     [no tasks queued]
  CFS RB_ROOT: cf547ac0
     [120] PID: 23     TASK: f714d3c0  COMMAND: "kworker/0:1"
     [120] PID: 990    TASK: c50fd3c0  COMMAND: "rsyslogd"
     [120] PID: 1005   TASK: c531a9e0  COMMAND: "rsyslogd"
     [120] PID: 1138   TASK: c51929e0  COMMAND: "hald"
     [120] PID: 476    TASK: c55953c0  COMMAND: "upstart-udev-br"
     [120] PID: 1106   TASK: c554bed0  COMMAND: "dbus-daemon"
     [120] PID: 4522   TASK: ee7068b0  COMMAND: "pppd"
     [120] PID: 4497   TASK: ec9ba9e0  COMMAND: "NetworkManager"
     [120] PID: 4823   TASK: ec9bbed0  COMMAND: "ip-down"


Thanks. Will be happy to furnish any requested information as I am
still keeping the dump file around.

-- 
Brian Gitonga Marete
Toshnix Systems
Tel: +254722151590
