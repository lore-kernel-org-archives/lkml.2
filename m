Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214Ab1LBL3E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 06:29:04 -0500
Received: from hera.cwi.nl ([192.16.191.8]:61265 "EHLO hera.cwi.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753839Ab1LBL25 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 06:28:57 -0500
Message-ID: <4ED8B66F.9020705@cwi.nl>
Date: Fri, 02 Dec 2011 11:28:47 +0000
From: "Wouter M. Koolen" <W.M.Koolen-Wijkstra@cwi.nl>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111114 Icedove/3.1.16
MIME-Version: 1.0
To: gregkh@suse.de
CC: linux-usb@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [usb] kernel BUG at arch/x86/mm/physaddr.c:15
Content-Type: multipart/mixed;
 boundary="------------090207080602010705060606"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090207080602010705060606
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi Greg,

(get_maintainer.pl points to you, but that may be too general. Please 
forward as necessary)

I am hitting this one every once in a while during boot:

kernel BUG at arch/x86/mm/physaddr.c:15!
invalid opcode: 0000 [#1] SMP
CPU 0
Modules linked in: isight_firmware(+) usbhid hid snd_hda_codec_realtek 
snd_hda_intel snd_hda_codec snd_hwde
p arc4 snd_pcm_oss snd_mixer_oss sr_mod b43 snd_pcm cdrom mac80211 
cfg80211 rfkill rng_core snd_seq uhci_hcd ehci_hcd ssb firewire_ohci snd_
timer snd_seq_device firewire_core mmc_core snd soundcore applesmc 
input_polldev crc_itu_t usbcore sky2 snd_page_alloc i2c_i801 pcspkr ac pr
ocessor evdev battery power_supply apple_bl ext4 mbcache jbd2 crc16 
sd_mod crc_t10dif ata_piix libata scsi_mod

Pid: 454, comm: modprobe Not tainted 3.1.4.debug+ #38 Apple Inc. 
MacBook4,1/Mac-F22788A9
RIP: 0010:[<ffffffff81027112>]  [<ffffffff81027112>] __phys_addr+0x62/0x70
RSP: 0018:ffff88006f425ab8  EFLAGS: 00010212
RAX: 000000002022b02e RBX: ffff88006f510740 RCX: 0000000000000001
RDX: 0000000000000000 RSI: 000000006f4e6c77 RDI: ffffffffa022b02e
RBP: ffff88006f425ab8 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffff880070ec14b8
R13: ffff88007addd090 R14: 0000000000000001 R15: ffffffffa022b02e
FS:  00007f6463aca700(0000) GS:ffff88007da00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f9e0066a520 CR3: 000000006f422000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process modprobe (pid: 454, threadinfo ffff88006f424000, task 
ffff880070f5a100)
Stack:
ffff88006f425b18 ffffffffa017c7f5 ffff88006f425af8 0000000000000001
ffffffffa0194e48 ffffffff81008470 ffffffff8108cabe ffff88006f510740
000000000000012c ffff880070ec14b8 0000000000000010 0000000000000001
Call Trace:
[<ffffffffa017c7f5>] usb_hcd_map_urb_for_dma+0x3d5/0x480 [usbcore]
[<ffffffff81008470>] ? nommu_map_sg+0xf0/0xf0
[<ffffffff8108cabe>] ? is_module_address+0x1e/0x30
[<ffffffffa017c9cd>] usb_hcd_submit_urb+0x12d/0x680 [usbcore]
[<ffffffffa017d99c>] usb_submit_urb+0xec/0x300 [usbcore]
[<ffffffffa017ee06>] usb_start_wait_urb+0x76/0x110 [usbcore]
[<ffffffffa017f105>] usb_control_msg+0xd5/0x110 [usbcore]
[<ffffffffa022a0c5>] isight_firmware_load+0xb5/0x2d8 [isight_firmware]
[<ffffffffa01821c6>] usb_probe_interface+0xd6/0x1f0 [usbcore]
[<ffffffff812f72c9>] driver_probe_device+0x79/0x1a0
[<ffffffff812f7493>] __driver_attach+0xa3/0xb0
[<ffffffff812f73f0>] ? driver_probe_device+0x1a0/0x1a0
[<ffffffff812f73f0>] ? driver_probe_device+0x1a0/0x1a0
[<ffffffff812f62ec>] bus_for_each_dev+0x5c/0x90
[<ffffffff812f6f79>] driver_attach+0x19/0x20
[<ffffffff812f6c00>] bus_add_driver+0x1a0/0x260
[<ffffffff812f79d1>] driver_register+0x71/0x140
[<ffffffff811db318>] ? __raw_spin_lock_init+0x38/0x70
[<ffffffffa0181070>] usb_register_driver+0xc0/0x1b0 [usbcore]
[<ffffffffa003e000>] ? 0xffffffffa003dfff
[<ffffffffa003e01e>] isight_firmware_init+0x1e/0x1000 [isight_firmware]
[<ffffffff810001cb>] do_one_initcall+0x3b/0x170
[<ffffffff8108c28b>] sys_init_module+0xbb/0x230
[<ffffffff8141bebb>] system_call_fastpath+0x16/0x1b
Code: 87 ff ff 48 39 c7 76 21 0f b6 0d d3 85 84 00 48 b8 00 00 00 00 00 
78 00 00 48 01 f8 48 89 c2 48 d3 ea 48 85 d2 74 cc 0f 0b 0f 0b <0f> 0b 
90 90 90 90 90 90 90 90 90 90 90 90 49 ba ff 0f 00 00 00
RIP  [<ffffffff81027112>] __phys_addr+0x62/0x70
RSP <ffff88006f425ab8>
---[ end trace f3191ac82c28c0c3 ]---

I am running 3.1.4  x86_64 on a Macbook 4,1. The isight camera firmware 
loading that seems to trigger this is trying to initialise
Bus 002 Device 003: ID 05ac:8501 Apple, Inc. Built-in iSight [Micron]
(lsusb -v attached)

I am quite confident I did not see this with 3.0. Unfortunately it does 
not happen reliably, so it would take me a while to bisect. I hope the 
splat already points to the problem, but let me know if a bisection 
would be appreciated. Or if you need any other information of course.

With kind regards,

Wouter Koolen

--------------090207080602010705060606
Content-Type: text/plain;
 name="dmesg"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg"

Initializing cgroup subsys cpuset
Initializing cgroup subsys cpu
Linux version 3.1.4.debug+ (root@wensbook) (gcc version 4.6.2 (Debian 4.6.2-4) ) #38 SMP Tue Nov 29 08:14:55 GMT 2011
Command line: BOOT_IMAGE=/boot/vmlinuz-3.1.4.debug+ root=UUID=21d8c00d-634e-477c-b7bd-347f09002b93 ro quiet
KERNEL supported cpus:
  Intel GenuineIntel
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007dd31000 (usable)
 BIOS-e820: 000000007dd31000 - 000000007df32000 (ACPI NVS)
 BIOS-e820: 000000007df32000 - 000000007dfe5000 (ACPI data)
 BIOS-e820: 000000007dfe5000 - 000000007dfe7000 (ACPI NVS)
 BIOS-e820: 000000007dfe7000 - 000000007eec3000 (ACPI data)
 BIOS-e820: 000000007eec3000 - 000000007eec5000 (ACPI NVS)
 BIOS-e820: 000000007eec5000 - 000000007eec8000 (ACPI data)
 BIOS-e820: 000000007eec8000 - 000000007eecb000 (ACPI NVS)
 BIOS-e820: 000000007eecb000 - 000000007eecc000 (ACPI data)
 BIOS-e820: 000000007eecc000 - 000000007eedf000 (ACPI NVS)
 BIOS-e820: 000000007eedf000 - 000000007eef9000 (ACPI data)
 BIOS-e820: 000000007eef9000 - 000000007eeff000 (reserved)
 BIOS-e820: 000000007eeff000 - 000000007ef00000 (ACPI data)
 BIOS-e820: 000000007ef00000 - 0000000080000000 (reserved)
 BIOS-e820: 00000000f0000000 - 00000000f4000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
 BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
 BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
NX (Execute Disable) protection: active
DMI 2.4 present.
DMI: Apple Inc. MacBook4,1/Mac-F22788A9, BIOS     MB41.88Z.00C1.B00.0802091535 02/09/08
e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
last_pfn = 0x7dd31 max_arch_pfn = 0x400000000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-BFFFF uncachable
  C0000-CFFFF write-protect
  D0000-DFFFF uncachable
  E0000-FFFFF write-protect
MTRR variable ranges enabled:
  0 base 0FFE00000 mask FFFE00000 write-protect
  1 base 000000000 mask F80000000 write-back
  2 base 07F000000 mask FFF000000 uncachable
  3 base 07EF00000 mask FFFF00000 uncachable
  4 disabled
  5 disabled
  6 disabled
  7 disabled
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
initial memory mapped : 0 - 20000000
Base memory trampoline at [ffff88000009a000] 9a000 size 20480
init_memory_mapping: 0000000000000000-000000007dd31000
 0000000000 - 007dc00000 page 2M
 007dc00000 - 007dd31000 page 4k
kernel direct mapping tables up to 7dd31000 @ 1fffc000-20000000
RAMDISK: 37b76000 - 37db3000
ACPI: RSDP 00000000000fe020 00024 (v02 APPLE )
ACPI: XSDT 000000007eeee1c0 00084 (v01 APPLE   Apple00 000000C1      01000013)
ACPI: FACP 000000007eeec000 000F4 (v03 APPLE   Apple00 000000C1 Loki 0000005F)
ACPI: DSDT 000000007eee1000 045C6 (v01 APPLE   MacBook 00040001 INTL 20061109)
ACPI: FACS 000000007eecc000 00040
ACPI: HPET 000000007eeeb000 00038 (v01 APPLE   Apple00 00000001 Loki 0000005F)
ACPI: APIC 000000007eeea000 00068 (v01 APPLE   Apple00 00000001 Loki 0000005F)
ACPI: MCFG 000000007eee9000 0003C (v01 APPLE   Apple00 00000001 Loki 0000005F)
ACPI: ASF! 000000007eee8000 000A5 (v32 APPLE   Apple00 00000001 Loki 0000005F)
ACPI: SBST 000000007eee7000 00030 (v01 APPLE   Apple00 00000001 Loki 0000005F)
ACPI: ECDT 000000007eee6000 00053 (v01 APPLE   Apple00 00000001 Loki 0000005F)
ACPI: SSDT 000000007eec7000 004DC (v01  APPLE    CpuPm 00003000 INTL 20061109)
ACPI: SSDT 000000007eec6000 0025F (v01  APPLE  Cpu0Tst 00003000 INTL 20061109)
ACPI: SSDT 000000007eec5000 000A6 (v01  APPLE  Cpu1Tst 00003000 INTL 20061109)
ACPI: SSDT 000000007eee0000 00544 (v01 SataRe  SataPri 00001000 INTL 20061109)
ACPI: SSDT 000000007eedf000 00477 (v01 SataRe  SataSec 00001000 INTL 20061109)
ACPI: Local APIC address 0xfee00000
 [ffffea0000000000-ffffea0001bfffff] PMD -> [ffff88007b400000-ffff88007cffffff] on node 0
Zone PFN ranges:
  DMA      0x00000010 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   empty
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000010 -> 0x0000009f
    0: 0x00000100 -> 0x0007dd31
On node 0 totalpages: 515264
  DMA zone: 56 pages used for memmap
  DMA zone: 5 pages reserved
  DMA zone: 3922 pages, LIFO batch:0
  DMA32 zone: 6991 pages used for memmap
  DMA32 zone: 504290 pages, LIFO batch:31
ACPI: PM-Timer IO Port: 0x408
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
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
nr_irqs_gsi: 40
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
Allocating PCI resources starting at 80000000 (gap: 80000000:70000000)
setup_percpu: NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
PERCPU: Embedded 26 pages/cpu @ffff88007da00000 s76480 r8192 d21824 u1048576
pcpu-alloc: s76480 r8192 d21824 u1048576 alloc=1*2097152
pcpu-alloc: [0] 0 1 
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 508212
Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.1.4.debug+ root=UUID=21d8c00d-634e-477c-b7bd-347f09002b93 ro quiet
PID hash table entries: 4096 (order: 3, 32768 bytes)
Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
Memory: 2008484k/2061508k available (4223k kernel code, 452k absent, 52572k reserved, 4438k data, 752k init)
Hierarchical RCU implementation.
	RCU dyntick-idle grace-period acceleration is enabled.
NR_IRQS:4352 nr_irqs:512 16
Extended CMOS year: 2000
Console: colour VGA+ 80x25
console [tty0] enabled
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
... MAX_LOCKDEP_SUBCLASSES:  8
... MAX_LOCK_DEPTH:          48
... MAX_LOCKDEP_KEYS:        8191
... CLASSHASH_SIZE:          4096
... MAX_LOCKDEP_ENTRIES:     16384
... MAX_LOCKDEP_CHAINS:      32768
... CHAINHASH_SIZE:          16384
 memory used by lock dependency info: 5823 kB
 per task-struct memory footprint: 1920 bytes
ODEBUG: 0 of 0 active objects replaced
hpet clockevent registered
Fast TSC calibration failed
TSC: Unable to calibrate against PIT
TSC: using HPET reference calibration
Detected 2393.993 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequency.. 4787.98 BogoMIPS (lpj=9575972)
pid_max: default: 32768 minimum: 301
BUG: scheduling while atomic: swapper/0/0x10000002
no locks held by swapper/0.
Modules linked in:
Pid: 0, comm: swapper Not tainted 3.1.4.debug+ #38
Call Trace:
 [<ffffffff8140d69e>] __schedule_bug+0x60/0x65
 [<ffffffff8189b85a>] ? pidmap_init+0x84/0xc4
 [<ffffffff81412199>] __schedule+0x759/0x920
 [<ffffffff8189b85a>] ? pidmap_init+0x84/0xc4
 [<ffffffff8103d855>] __cond_resched+0x25/0x40
 [<ffffffff814123dd>] _cond_resched+0x2d/0x40
 [<ffffffff811107df>] kmem_cache_alloc_trace+0x4f/0x1d0
 [<ffffffff8189b85a>] pidmap_init+0x84/0xc4
 [<ffffffff8188ab47>] start_kernel+0x339/0x3bc
 [<ffffffff8188a322>] x86_64_start_reservations+0x132/0x136
 [<ffffffff8188a416>] x86_64_start_kernel+0xf0/0xf7
Mount-cache hash table entries: 256
Initializing cgroup subsys cpuacct
Initializing cgroup subsys devices
Initializing cgroup subsys freezer
Initializing cgroup subsys net_cls
Initializing cgroup subsys blkio
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
mce: CPU supports 6 MCE banks
CPU0: Thermal monitoring enabled (TM2)
using mwait in idle threads.
ACPI: Core revision 20110623
BUG: scheduling while atomic: swapper/0/0x10000002
no locks held by swapper/0.
Modules linked in:
Pid: 0, comm: swapper Not tainted 3.1.4.debug+ #38
Call Trace:
 [<ffffffff8140d69e>] __schedule_bug+0x60/0x65
 [<ffffffff81412199>] __schedule+0x759/0x920
 [<ffffffff8103d855>] __cond_resched+0x25/0x40
 [<ffffffff814123dd>] _cond_resched+0x2d/0x40
 [<ffffffff81230c8c>] acpi_ps_complete_op+0x2bc/0x2d1
 [<ffffffff8121b420>] ? acpi_ds_load1_end_op+0xa4/0x249
 [<ffffffff81231559>] acpi_ps_parse_loop+0x8b8/0xa4f
 [<ffffffff81238118>] ? acpi_ut_create_generic_state+0x2d/0x4a
 [<ffffffff8123075a>] acpi_ps_parse_aml+0x107/0x37d
 [<ffffffff8122e7b9>] acpi_ns_one_complete_parse+0x125/0x142
 [<ffffffff8120ed80>] ? acpi_os_signal_semaphore+0x5f/0x6f
 [<ffffffff8122e81f>] acpi_ns_parse_table+0x49/0x8e
 [<ffffffff8122addd>] acpi_ns_load_table+0x75/0x110
 [<ffffffff81233788>] acpi_load_tables+0xa1/0x18e
 [<ffffffff818a9959>] acpi_early_init+0x6c/0xf7
 [<ffffffff8188abb8>] start_kernel+0x3aa/0x3bc
 [<ffffffff8188a322>] x86_64_start_reservations+0x132/0x136
 [<ffffffff8188a416>] x86_64_start_kernel+0xf0/0xf7
BUG: scheduling while atomic: swapper/0/0x10000002
no locks held by swapper/0.
Modules linked in:
Pid: 0, comm: swapper Not tainted 3.1.4.debug+ #38
Call Trace:
 [<ffffffff8140d69e>] __schedule_bug+0x60/0x65
 [<ffffffff81231ab6>] ? acpi_os_acquire_object+0x26/0x28
 [<ffffffff81412199>] __schedule+0x759/0x920
 [<ffffffff81231ab6>] ? acpi_os_acquire_object+0x26/0x28
 [<ffffffff8103d855>] __cond_resched+0x25/0x40
 [<ffffffff814123dd>] _cond_resched+0x2d/0x40
 [<ffffffff811103ab>] kmem_cache_alloc+0x4b/0x1f0
 [<ffffffff81231ab6>] ? acpi_os_acquire_object+0x26/0x28
 [<ffffffff81231ab6>] acpi_os_acquire_object+0x26/0x28
 [<ffffffff81231afd>] acpi_ps_alloc_op+0x37/0x5d
 [<ffffffff812301c2>] acpi_ps_get_next_arg+0xc8/0x2b6
 [<ffffffff81231239>] acpi_ps_parse_loop+0x598/0xa4f
 [<ffffffff81238118>] ? acpi_ut_create_generic_state+0x2d/0x4a
 [<ffffffff8123075a>] acpi_ps_parse_aml+0x107/0x37d
 [<ffffffff8122e7b9>] acpi_ns_one_complete_parse+0x125/0x142
 [<ffffffff8120ed80>] ? acpi_os_signal_semaphore+0x5f/0x6f
 [<ffffffff8122e85d>] acpi_ns_parse_table+0x87/0x8e
 [<ffffffff8122addd>] acpi_ns_load_table+0x75/0x110
 [<ffffffff81233788>] acpi_load_tables+0xa1/0x18e
 [<ffffffff818a9959>] acpi_early_init+0x6c/0xf7
 [<ffffffff8188abb8>] start_kernel+0x3aa/0x3bc
 [<ffffffff8188a322>] x86_64_start_reservations+0x132/0x136
 [<ffffffff8188a416>] x86_64_start_kernel+0xf0/0xf7
BUG: scheduling while atomic: swapper/0/0x10000002
no locks held by swapper/0.
Modules linked in:
Pid: 0, comm: swapper Not tainted 3.1.4.debug+ #38
Call Trace:
 [<ffffffff8140d69e>] __schedule_bug+0x60/0x65
 [<ffffffff81231ab6>] ? acpi_os_acquire_object+0x26/0x28
 [<ffffffff81412199>] __schedule+0x759/0x920
 [<ffffffff811190ce>] ? __delete_object+0x6e/0xc0
 [<ffffffff81231ab6>] ? acpi_os_acquire_object+0x26/0x28
 [<ffffffff8103d855>] __cond_resched+0x25/0x40
 [<ffffffff814123dd>] _cond_resched+0x2d/0x40
 [<ffffffff811103ab>] kmem_cache_alloc+0x4b/0x1f0
 [<ffffffff8110f3cb>] ? cache_free_debugcheck+0x13b/0x280
 [<ffffffff81231ab6>] acpi_os_acquire_object+0x26/0x28
 [<ffffffff81231b21>] acpi_ps_alloc_op+0x5b/0x5d
 [<ffffffff81230135>] acpi_ps_get_next_arg+0x3b/0x2b6
 [<ffffffff8120ee16>] ? acpi_os_release_object+0x9/0xd
 [<ffffffff81231239>] acpi_ps_parse_loop+0x598/0xa4f
 [<ffffffff81238118>] ? acpi_ut_create_generic_state+0x2d/0x4a
 [<ffffffff8123075a>] acpi_ps_parse_aml+0x107/0x37d
 [<ffffffff8122e7b9>] acpi_ns_one_complete_parse+0x125/0x142
 [<ffffffff8120ed80>] ? acpi_os_signal_semaphore+0x5f/0x6f
 [<ffffffff8122e85d>] acpi_ns_parse_table+0x87/0x8e
 [<ffffffff8122addd>] acpi_ns_load_table+0x75/0x110
 [<ffffffff81233788>] acpi_load_tables+0xa1/0x18e
 [<ffffffff818a9959>] acpi_early_init+0x6c/0xf7
 [<ffffffff8188abb8>] start_kernel+0x3aa/0x3bc
 [<ffffffff8188a322>] x86_64_start_reservations+0x132/0x136
 [<ffffffff8188a416>] x86_64_start_kernel+0xf0/0xf7
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Core(TM)2 Duo CPU     T8300  @ 2.40GHz stepping 06
Performance Events: PEBS fmt0+, Core2 events, Intel PMU driver.
... version:                2
... bit width:              40
... generic registers:      2
... value mask:             000000ffffffffff
... max period:             000000007fffffff
... fixed-purpose events:   3
... event mask:             0000000700000003
NMI watchdog enabled, takes one hw-pmu counter.
lockdep: fixing up alternatives.
Booting Node   0, Processors  #1 Ok.
smpboot cpu 1: start_ip = 9a000
NMI watchdog enabled, takes one hw-pmu counter.
Brought up 2 CPUs
Total of 2 processors activated (9575.89 BogoMIPS).
devtmpfs: initialized
PM: Registering ACPI NVS region at 7dd31000 (2101248 bytes)
PM: Registering ACPI NVS region at 7dfe5000 (8192 bytes)
PM: Registering ACPI NVS region at 7eec3000 (8192 bytes)
PM: Registering ACPI NVS region at 7eec8000 (12288 bytes)
PM: Registering ACPI NVS region at 7eecc000 (77824 bytes)
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xf0000000-0xffffffff] (base 0xf0000000)
PCI: MMCONFIG at [mem 0xf0000000-0xffffffff] reserved in E820
PCI: MMCONFIG for 0000 [bus00-3f] at [mem 0xf0000000-0xf3ffffff] (base 0xf0000000) (size reduced!)
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: Added _OSI(Module Device)
ACPI: Added _OSI(Processor Device)
ACPI: Added _OSI(3.0 _SCP Extensions)
ACPI: Added _OSI(Processor Aggregator Device)
ACPI: EC: EC description table is found, configuring boot EC
[Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
ACPI: SSDT 000000007eecaa98 00340 (v01  APPLE  Cpu0Ist 00003000 INTL 20061109)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT           (null) 00340 (v01  APPLE  Cpu0Ist 00003000 INTL 20061109)
ACPI: SSDT 000000007eec8c18 002AD (v01  APPLE  Cpu0Cst 00003001 INTL 20061109)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT           (null) 002AD (v01  APPLE  Cpu0Cst 00003001 INTL 20061109)
ACPI: SSDT 000000007eec9f18 000C8 (v01  APPLE  Cpu1Ist 00003000 INTL 20061109)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT           (null) 000C8 (v01  APPLE  Cpu1Ist 00003000 INTL 20061109)
ACPI: SSDT 000000007eec8f18 00085 (v01  APPLE  Cpu1Cst 00003000 INTL 20061109)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT           (null) 00085 (v01  APPLE  Cpu1Cst 00003000 INTL 20061109)
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
pci_root PNP0A08:00: host bridge window [mem 0x80000000-0xfebfffff]
pci 0000:00:00.0: [8086:2a00] type 0 class 0x000600
pci 0000:00:02.0: [8086:2a02] type 0 class 0x000300
pci 0000:00:02.0: reg 10: [mem 0x90100000-0x901fffff 64bit]
pci 0000:00:02.0: reg 18: [mem 0x80000000-0x8fffffff 64bit pref]
pci 0000:00:02.0: reg 20: [io  0x6110-0x6117]
pci 0000:00:02.1: [8086:2a03] type 0 class 0x000380
pci 0000:00:02.1: reg 10: [mem 0x90200000-0x902fffff 64bit]
pci 0000:00:1a.0: [8086:2834] type 0 class 0x000c03
pci 0000:00:1a.0: reg 20: [io  0x60c0-0x60df]
pci 0000:00:1a.1: [8086:2835] type 0 class 0x000c03
pci 0000:00:1a.1: reg 20: [io  0x60a0-0x60bf]
pci 0000:00:1a.7: [8086:283a] type 0 class 0x000c03
pci 0000:00:1a.7: reg 10: [mem 0x90704c00-0x90704fff]
pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1a.7: PME# disabled
pci 0000:00:1b.0: [8086:284b] type 0 class 0x000403
pci 0000:00:1b.0: reg 10: [mem 0x90700000-0x90703fff 64bit]
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1b.0: PME# disabled
pci 0000:00:1c.0: [8086:283f] type 1 class 0x000604
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: PME# disabled
pci 0000:00:1c.4: [8086:2847] type 1 class 0x000604
pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.4: PME# disabled
pci 0000:00:1c.5: [8086:2849] type 1 class 0x000604
pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.5: PME# disabled
pci 0000:00:1d.0: [8086:2830] type 0 class 0x000c03
pci 0000:00:1d.0: reg 20: [io  0x6080-0x609f]
pci 0000:00:1d.1: [8086:2831] type 0 class 0x000c03
pci 0000:00:1d.1: reg 20: [io  0x6060-0x607f]
pci 0000:00:1d.2: [8086:2832] type 0 class 0x000c03
pci 0000:00:1d.2: reg 20: [io  0x6040-0x605f]
pci 0000:00:1d.7: [8086:2836] type 0 class 0x000c03
pci 0000:00:1d.7: reg 10: [mem 0x90704800-0x90704bff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
pci 0000:00:1e.0: [8086:2448] type 1 class 0x000604
pci 0000:00:1f.0: [8086:2815] type 0 class 0x000601
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0680 (mask 000f)
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 1640 (mask 000f)
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 4 PIO at 0300 (mask 001f)
pci 0000:00:1f.1: [8086:2850] type 0 class 0x000101
pci 0000:00:1f.1: reg 10: [io  0x6108-0x610f]
pci 0000:00:1f.1: reg 14: [io  0x6124-0x6127]
pci 0000:00:1f.1: reg 18: [io  0x6100-0x6107]
pci 0000:00:1f.1: reg 1c: [io  0x6120-0x6123]
pci 0000:00:1f.1: reg 20: [io  0x60e0-0x60ef]
pci 0000:00:1f.2: [8086:2828] type 0 class 0x000101
pci 0000:00:1f.2: reg 10: [io  0x60f8-0x60ff]
pci 0000:00:1f.2: reg 14: [io  0x611c-0x611f]
pci 0000:00:1f.2: reg 18: [io  0x60f0-0x60f7]
pci 0000:00:1f.2: reg 1c: [io  0x6118-0x611b]
pci 0000:00:1f.2: reg 20: [io  0x6020-0x602f]
pci 0000:00:1f.2: reg 24: [io  0x4000-0x400f]
pci 0000:00:1f.2: PME# supported from D3hot
pci 0000:00:1f.2: PME# disabled
pci 0000:00:1f.3: [8086:283e] type 0 class 0x000c05
pci 0000:00:1f.3: reg 10: [mem 0x90705000-0x907050ff]
pci 0000:00:1f.3: reg 20: [io  0xefa0-0xefbf]
pci 0000:00:1c.0: PCI bridge to [bus 01-01]
pci 0000:00:1c.0:   bridge window [mem 0x90600000-0x906fffff]
pci 0000:02:00.0: [14e4:4328] type 0 class 0x000280
pci 0000:02:00.0: reg 10: [mem 0x90500000-0x90503fff 64bit]
pci 0000:02:00.0: reg 18: [mem 0x90000000-0x900fffff 64bit pref]
pci 0000:02:00.0: supports D1 D2
pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
pci 0000:02:00.0: PME# disabled
pci 0000:00:1c.4: PCI bridge to [bus 02-02]
pci 0000:00:1c.4:   bridge window [mem 0x90500000-0x905fffff]
pci 0000:00:1c.4:   bridge window [mem 0x90000000-0x900fffff 64bit pref]
pci 0000:03:00.0: [11ab:436a] type 0 class 0x000200
pci 0000:03:00.0: reg 10: [mem 0x90400000-0x90403fff 64bit]
pci 0000:03:00.0: reg 18: [io  0x5000-0x50ff]
pci 0000:03:00.0: reg 30: [mem 0xfffe0000-0xffffffff pref]
pci 0000:03:00.0: supports D1 D2
pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:03:00.0: PME# disabled
pci 0000:00:1c.5: PCI bridge to [bus 03-03]
pci 0000:00:1c.5:   bridge window [io  0x5000-0x5fff]
pci 0000:00:1c.5:   bridge window [mem 0x90400000-0x904fffff]
pci 0000:04:03.0: [11c1:5811] type 0 class 0x000c00
pci 0000:04:03.0: reg 10: [mem 0x90300000-0x90300fff]
pci 0000:04:03.0: supports D1 D2
pci 0000:04:03.0: PME# supported from D0 D1 D2 D3hot
pci 0000:04:03.0: PME# disabled
pci 0000:00:1e.0: PCI bridge to [bus 04-04] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x90300000-0x903fffff]
pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x80000000-0xfebfffff] (subtractive decode)
pci_bus 0000:00: on NUMA node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP05._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP06._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
 pci0000:00: Requesting ACPI _OSC control (0x1d)
 pci0000:00: ACPI _OSC control (0x1d) granted
ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 *7 11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 *5 6 7 10 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 *10 12 14 15)
ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12 14 15) *9
ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
vgaarb: loaded
vgaarb: bridge control possible 0000:00:02.0
PCI: Using ACPI for IRQ routing
PCI: pci_cache_line_size set to 64 bytes
reserve RAM buffer: 000000000009fc00 - 000000000009ffff 
reserve RAM buffer: 000000007dd31000 - 000000007fffffff 
HPET: 3 timers in total, 0 timers will be used for per-cpu timer
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 comparators, 64-bit 14.318180 MHz counter
Switching to clocksource hpet
Switched to NOHz mode on CPU #0
Switched to NOHz mode on CPU #1
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp 00:00: [bus 00-ff]
pnp 00:00: [io  0x0000-0x0cf7 window]
pnp 00:00: [io  0x0cf8-0x0cff]
pnp 00:00: [io  0x0d00-0xffff window]
pnp 00:00: [mem 0x000a0000-0x000bffff window]
pnp 00:00: [mem 0x000c0000-0x000c3fff window]
pnp 00:00: [mem 0x000c4000-0x000c7fff window]
pnp 00:00: [mem 0x000c8000-0x000cbfff window]
pnp 00:00: [mem 0x000cc000-0x000cffff window]
pnp 00:00: [mem 0x000d0000-0x000d3fff window]
pnp 00:00: [mem 0x000d4000-0x000d7fff window]
pnp 00:00: [mem 0x000d8000-0x000dbfff window]
pnp 00:00: [mem 0x000dc000-0x000dffff window]
pnp 00:00: [mem 0x000e0000-0x000e3fff window]
pnp 00:00: [mem 0x000e4000-0x000e7fff window]
pnp 00:00: [mem 0x000e8000-0x000ebfff window]
pnp 00:00: [mem 0x000ec000-0x000effff window]
pnp 00:00: [mem 0x000f0000-0x000fffff window]
pnp 00:00: [mem 0x80000000-0xfebfffff window]
pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
pnp 00:01: [mem 0xfed1c000-0xfed1ffff]
pnp 00:01: [mem 0xfed14000-0xfed17fff]
pnp 00:01: [mem 0xfed18000-0xfed18fff]
pnp 00:01: [mem 0xfed19000-0xfed19fff]
pnp 00:01: [mem 0xf0000000-0xf3ffffff]
pnp 00:01: [mem 0xfed20000-0xfed3ffff]
pnp 00:01: [mem 0xfed45000-0xfed8ffff]
system 00:01: [mem 0xfed1c000-0xfed1ffff] has been reserved
system 00:01: [mem 0xfed14000-0xfed17fff] has been reserved
system 00:01: [mem 0xfed18000-0xfed18fff] has been reserved
system 00:01: [mem 0xfed19000-0xfed19fff] has been reserved
system 00:01: [mem 0xf0000000-0xf3ffffff] has been reserved
system 00:01: [mem 0xfed20000-0xfed3ffff] has been reserved
system 00:01: [mem 0xfed45000-0xfed8ffff] has been reserved
system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:02: [io  0x0300-0x031f]
pnp 00:02: [irq 6]
pnp 00:02: Plug and Play ACPI device, IDs APP0001 (active)
pnp 00:03: [io  0x0000-0x001f]
pnp 00:03: [io  0x0081-0x0091]
pnp 00:03: [io  0x0093-0x009f]
pnp 00:03: [io  0x00c0-0x00df]
pnp 00:03: [dma 4]
pnp 00:03: Plug and Play ACPI device, IDs PNP0200 (active)
pnp 00:04: [mem 0xff000000-0xffffffff]
pnp 00:04: Plug and Play ACPI device, IDs INT0800 (active)
pnp 00:05: [irq 0 disabled]
pnp 00:05: [irq 8]
pnp 00:05: [mem 0xfed00000-0xfed003ff]
system 00:05: [mem 0xfed00000-0xfed003ff] has been reserved
system 00:05: Plug and Play ACPI device, IDs PNP0103 PNP0c01 (active)
pnp 00:06: [io  0x00f0]
pnp 00:06: [irq 13]
pnp 00:06: Plug and Play ACPI device, IDs PNP0c04 (active)
pnp 00:07: [io  0x002e-0x002f]
pnp 00:07: [io  0x004e-0x004f]
pnp 00:07: [io  0x0061]
pnp 00:07: [io  0x0063]
pnp 00:07: [io  0x0065]
pnp 00:07: [io  0x0067]
pnp 00:07: [io  0x0070]
pnp 00:07: [io  0x0080]
pnp 00:07: [io  0x0092]
pnp 00:07: [io  0x00b2-0x00b3]
pnp 00:07: [io  0x0680-0x069f]
pnp 00:07: [io  0x0800-0x080f]
pnp 00:07: [io  0x0810-0x0817]
pnp 00:07: [io  0x0400-0x047f]
pnp 00:07: [io  0x0500-0x053f]
pnp 00:07: [io  0x1640-0x164f]
system 00:07: [io  0x0680-0x069f] has been reserved
system 00:07: [io  0x0800-0x080f] has been reserved
system 00:07: [io  0x0810-0x0817] has been reserved
system 00:07: [io  0x0400-0x047f] has been reserved
system 00:07: [io  0x0500-0x053f] has been reserved
system 00:07: [io  0x1640-0x164f] has been reserved
system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:08: [io  0x0070-0x0077]
pnp 00:08: Plug and Play ACPI device, IDs PNP0b00 (active)
pnp: PnP ACPI: found 9 devices
ACPI: ACPI bus type pnp unregistered
pci 0000:03:00.0: no compatible bridge window for [mem 0xfffe0000-0xffffffff pref]
PCI: max bus depth: 1 pci_try_num: 2
pci 0000:00:1c.5: BAR 15: assigned [mem 0x90800000-0x908fffff pref]
pci 0000:00:1c.5: BAR 15: assigned [mem 0x90800000-0x90afffff pref]
pci 0000:00:1c.4: BAR 13: assigned [io  0x2000-0x2fff]
pci 0000:00:1c.0: BAR 15: assigned [mem 0x90b00000-0x90cfffff 64bit pref]
pci 0000:00:1c.0: BAR 13: assigned [io  0x3000-0x3fff]
pci 0000:00:1c.0: PCI bridge to [bus 01-01]
pci 0000:00:1c.0:   bridge window [io  0x3000-0x3fff]
pci 0000:00:1c.0:   bridge window [mem 0x90600000-0x906fffff]
pci 0000:00:1c.0:   bridge window [mem 0x90b00000-0x90cfffff 64bit pref]
pci 0000:00:1c.4: PCI bridge to [bus 02-02]
pci 0000:00:1c.4:   bridge window [io  0x2000-0x2fff]
pci 0000:00:1c.4:   bridge window [mem 0x90500000-0x905fffff]
pci 0000:00:1c.4:   bridge window [mem 0x90000000-0x900fffff 64bit pref]
pci 0000:03:00.0: BAR 6: assigned [mem 0x90800000-0x9081ffff pref]
pci 0000:00:1c.5: PCI bridge to [bus 03-03]
pci 0000:00:1c.5:   bridge window [io  0x5000-0x5fff]
pci 0000:00:1c.5:   bridge window [mem 0x90400000-0x904fffff]
pci 0000:00:1c.5:   bridge window [mem 0x90800000-0x90afffff pref]
pci 0000:00:1e.0: PCI bridge to [bus 04-04]
pci 0000:00:1e.0:   bridge window [mem 0x90300000-0x903fffff]
pci 0000:00:1c.0: enabling device (0000 -> 0003)
pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:1c.0: setting latency timer to 64
pci 0000:00:1c.4: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:1c.4: setting latency timer to 64
pci 0000:00:1c.5: PCI INT B -> GSI 17 (level, low) -> IRQ 17
pci 0000:00:1c.5: setting latency timer to 64
pci 0000:00:1e.0: power state changed by ACPI to D0
pci 0000:00:1e.0: power state changed by ACPI to D0
pci 0000:00:1e.0: setting latency timer to 64
pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
pci_bus 0000:01: resource 0 [io  0x3000-0x3fff]
pci_bus 0000:01: resource 1 [mem 0x90600000-0x906fffff]
pci_bus 0000:01: resource 2 [mem 0x90b00000-0x90cfffff 64bit pref]
pci_bus 0000:02: resource 0 [io  0x2000-0x2fff]
pci_bus 0000:02: resource 1 [mem 0x90500000-0x905fffff]
pci_bus 0000:02: resource 2 [mem 0x90000000-0x900fffff 64bit pref]
pci_bus 0000:03: resource 0 [io  0x5000-0x5fff]
pci_bus 0000:03: resource 1 [mem 0x90400000-0x904fffff]
pci_bus 0000:03: resource 2 [mem 0x90800000-0x90afffff pref]
pci_bus 0000:04: resource 1 [mem 0x90300000-0x903fffff]
pci_bus 0000:04: resource 4 [io  0x0000-0x0cf7]
pci_bus 0000:04: resource 5 [io  0x0d00-0xffff]
pci_bus 0000:04: resource 6 [mem 0x000a0000-0x000bffff]
pci_bus 0000:04: resource 7 [mem 0x80000000-0xfebfffff]
NET: Registered protocol family 2
IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 10, 4194304 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
UDP hash table entries: 1024 (order: 5, 163840 bytes)
UDP-Lite hash table entries: 1024 (order: 5, 163840 bytes)
NET: Registered protocol family 1
pci 0000:00:02.0: Boot video device
PCI: CLS mismatch (256 != 64), using 64 bytes
Unpacking initramfs...
Freeing initrd memory: 2292k freed
Machine check injector initialized
HugeTLB registered 2 MB page size, pre-allocated 0 pages
msgmni has been set to 3927
alg: No test for stdrng (krng)
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
start plist test
end plist test
pcieport 0000:00:1c.0: setting latency timer to 64
pcieport 0000:00:1c.0: irq 40 for MSI/MSI-X
pcieport 0000:00:1c.4: setting latency timer to 64
pcieport 0000:00:1c.4: irq 41 for MSI/MSI-X
pcieport 0000:00:1c.5: setting latency timer to 64
pcieport 0000:00:1c.5: irq 42 for MSI/MSI-X
pcieport 0000:00:1c.0: Signaling PME through PCIe PME interrupt
pcie_pme 0000:00:1c.0:pcie01: service driver pcie_pme loaded
pcieport 0000:00:1c.4: Signaling PME through PCIe PME interrupt
pci 0000:02:00.0: Signaling PME through PCIe PME interrupt
pcie_pme 0000:00:1c.4:pcie01: service driver pcie_pme loaded
pcieport 0000:00:1c.5: Signaling PME through PCIe PME interrupt
pci 0000:03:00.0: Signaling PME through PCIe PME interrupt
pcie_pme 0000:00:1c.5:pcie01: service driver pcie_pme loaded
input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input0
ACPI: Lid Switch [LID0]
input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
ACPI: Power Button [PWRB]
input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input2
ACPI: Sleep Button [SLPB]
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
ACPI: Power Button [PWRF]
input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input4
ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
Linux agpgart interface v0.103
agpgart-intel 0000:00:00.0: Intel 965GM Chipset
agpgart-intel 0000:00:00.0: detected gtt size: 524288K total, 262144K mappable
agpgart-intel 0000:00:00.0: detected 16384K stolen memory
agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0x80000000
[drm] Initialized drm 1.1.0 20060810
i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
i915 0000:00:02.0: setting latency timer to 64
i915 0000:00:02.0: irq 43 for MSI/MSI-X
[drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[drm] Driver supports precise vblank timestamp query.
vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[drm] initialized overlay support
fbcon: inteldrmfb (fb0) is primary device
Refined TSC clocksource calibration: 2393.999 MHz.
Switching to clocksource tsc
Console: switching to colour frame buffer device 160x50
fb0: inteldrmfb frame buffer device
drm: registered panic notifier
[drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
mousedev: PS/2 mouse device common for all mice
rtc_cmos 00:08: RTC can wake from S4
rtc (null): alarm rollover: day
rtc_cmos: dev (254:0)
rtc_cmos 00:08: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
cpuidle: using governor ladder
cpuidle: using governor menu
TCP cubic registered
NET: Registered protocol family 10
NET: Registered protocol family 17
Registering the dns_resolver key type
PM: Hibernation image not present or could not be loaded.
registered taskstats version 1
kmemleak: Kernel memory leak detector initialized
kmemleak: Automatic memory scanning thread started
rtc_cmos 00:08: setting system clock to 2011-12-02 09:31:28 UTC (1322818288)
Freeing unused kernel memory: 752k freed
Write protecting the kernel read-only data: 8192k
Freeing unused kernel memory: 1900k freed
Freeing unused kernel memory: 276k freed
udevd[50]: starting version 175
SCSI subsystem initialized
libata version 3.00 loaded.
ata_piix 0000:00:1f.1: version 2.13
ata_piix 0000:00:1f.1: power state changed by ACPI to D0
ata_piix 0000:00:1f.1: power state changed by ACPI to D0
ata_piix 0000:00:1f.1: PCI INT A -> GSI 21 (level, low) -> IRQ 21
ata_piix 0000:00:1f.1: setting latency timer to 64
scsi0 : ata_piix
scsi1 : ata_piix
ata1: PATA max UDMA/100 cmd 0x6108 ctl 0x6124 bmdma 0x60e0 irq 21
ata2: PATA max UDMA/100 cmd 0x6100 ctl 0x6120 bmdma 0x60e8 irq 21
ata_piix 0000:00:1f.2: PCI INT B -> GSI 18 (level, low) -> IRQ 18
ata_piix 0000:00:1f.2: MAP [ P0 -- -- -- ]
ata_piix 0000:00:1f.2: setting latency timer to 64
scsi2 : ata_piix
scsi3 : ata_piix
ata3: SATA max UDMA/133 cmd 0x60f8 ctl 0x611c bmdma 0x6020 irq 18
ata4: SATA max UDMA/133 cmd 0x60f0 ctl 0x6118 bmdma 0x6028 irq 18
ata1.00: ATAPI: MATSHITADVD-R   UJ-867, HB01, max UDMA/66
ata1.00: configured for UDMA/66
scsi 0:0:0:0: CD-ROM            MATSHITA DVD-R   UJ-867   HB01 PQ: 0 ANSI: 5
ata3.00: ATA-8: FUJITSU MHY2160BH, 0081000D, max UDMA/100
ata3.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata3.00: configured for UDMA/100
scsi 2:0:0:0: Direct-Access     ATA      FUJITSU MHY2160B 0081 PQ: 0 ANSI: 5
sd 2:0:0:0: [sda] 312581808 512-byte logical blocks: (160 GB/149 GiB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 sda4 sda5 sda6
sd 2:0:0:0: [sda] Attached SCSI disk
PM: Starting manual resume from disk
PM: Hibernation image partition 8:5 present
PM: Looking for hibernation image.
PM: Image not found (code -22)
PM: Hibernation image not present or could not be loaded.
EXT4-fs (sda4): mounted filesystem with ordered data mode. Opts: (null)
udevd[231]: starting version 175
ACPI: acpi_idle registered with cpuidle
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 21 (level, low) -> IRQ 21
ehci_hcd 0000:00:1a.7: setting latency timer to 64
ehci_hcd 0000:00:1a.7: EHCI Host Controller
ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1a.7: debug port 1
ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
ehci_hcd 0000:00:1a.7: irq 21, io mem 0x90704c00
input: PC Speaker as /devices/platform/pcspkr/input/input5
ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 3.1.4.debug+ ehci_hcd
usb usb1: SerialNumber: 0000:00:1a.7
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 4 ports detected
ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 20 (level, low) -> IRQ 20
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
ehci_hcd 0000:00:1d.7: irq 20, io mem 0x90704800
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: EHCI Host Controller
usb usb2: Manufacturer: Linux 3.1.4.debug+ ehci_hcd
usb usb2: SerialNumber: 0000:00:1d.7
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 6 ports detected
sky2: driver version 1.29
sky2 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
sky2 0000:03:00.0: setting latency timer to 64
sky2 0000:03:00.0: Yukon-2 EC Ultra chip revision 3
sky2 0000:03:00.0: irq 44 for MSI/MSI-X
sky2 0000:03:00.0: eth0: addr 00:1f:f3:d5:13:ce
Monitor-Mwait will be used to enter C-1 state
Monitor-Mwait will be used to enter C-2 state
Monitor-Mwait will be used to enter C-3 state
Marking TSC unstable due to TSC halts in idle
Switching to clocksource hpet
i801_smbus 0000:00:1f.3: PCI INT C -> GSI 20 (level, low) -> IRQ 20
uhci_hcd: USB Universal Host Controller Interface driver
uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
uhci_hcd 0000:00:1a.0: setting latency timer to 64
uhci_hcd 0000:00:1a.0: UHCI Host Controller
uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1a.0: irq 20, io base 0x000060c0
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 3.1.4.debug+ uhci_hcd
usb usb3: SerialNumber: 0000:00:1a.0
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1a.1: setting latency timer to 64
uhci_hcd 0000:00:1a.1: UHCI Host Controller
uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1a.1: irq 16, io base 0x000060a0
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 3.1.4.debug+ uhci_hcd
usb usb4: SerialNumber: 0000:00:1a.1
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.0: irq 16, io base 0x00006080
usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb5: Product: UHCI Host Controller
usb usb5: Manufacturer: Linux 3.1.4.debug+ uhci_hcd
usb usb5: SerialNumber: 0000:00:1d.0
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 6
uhci_hcd 0000:00:1d.1: irq 18, io base 0x00006060
usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb6: Product: UHCI Host Controller
usb usb6: Manufacturer: Linux 3.1.4.debug+ uhci_hcd
usb usb6: SerialNumber: 0000:00:1d.1
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 7
uhci_hcd 0000:00:1d.2: irq 21, io base 0x00006040
usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb7: Product: UHCI Host Controller
usb usb7: Manufacturer: Linux 3.1.4.debug+ uhci_hcd
usb usb7: SerialNumber: 0000:00:1d.2
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 2 ports detected
ACPI: Battery Slot [BAT0] (battery present)
ACPI: AC Adapter [ADP1] (on-line)
b43-pci-bridge 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
b43-pci-bridge 0000:02:00.0: setting latency timer to 64
ssb: Core 0 found: ChipCommon (cc 0x800, rev 0x13, vendor 0x4243)
ssb: Core 1 found: IEEE 802.11 (cc 0x812, rev 0x0C, vendor 0x4243)
ssb: Core 2 found: PCI-E (cc 0x820, rev 0x04, vendor 0x4243)
ssb: Core 3 found: PCI (cc 0x804, rev 0x0D, vendor 0x4243)
ssb: Core 4 found: USB 1.1 Host (cc 0x817, rev 0x04, vendor 0x4243)
ssb: Sonics Silicon Backplane found on PCI device 0000:02:00.0
applesmc: key=220 fan=1 temp=10 acc=1 lux=0 kbd=0
input: applesmc as /devices/platform/applesmc.768/input/input6
usb 2-4: new high speed USB device number 3 using ehci_hcd
sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda tray
cdrom: Uniform CD-ROM driver Revision: 3.20
sr 0:0:0:0: Attached scsi CD-ROM sr0
firewire_ohci 0000:04:03.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
usb 2-4: New USB device found, idVendor=05ac, idProduct=8501
usb 2-4: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 2-4: Product: Built-in iSight
usb 2-4: Manufacturer: Micron
firewire_ohci: Added fw-ohci device 0000:04:03.0, OHCI v1.0, 8 IR + 8 IT contexts, quirks 0x0
cfg80211: Calling CRDA to update world regulatory domain
usb 3-1: new full speed USB device number 2 using uhci_hcd
usb 3-1: New USB device found, idVendor=05ac, idProduct=1000
usb 3-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
b43-phy0: Broadcom 4321 WLAN found (core revision 12)
firewire_core: created device fw0: GUID 0021e9fffebe792a, S400
usb 3-2: new low speed USB device number 3 using uhci_hcd
ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
Registered led device: b43-phy0::tx
Registered led device: b43-phy0::rx
Registered led device: b43-phy0::radio
Broadcom 43xx driver loaded [ Features: PNLS, Firmware-ID: FW13 ]
usb 3-2: New USB device found, idVendor=045e, idProduct=0040
usb 3-2: New USB device strings: Mfr=1, Product=3, SerialNumber=0
usb 3-2: Product: Microsoft 3-Button Mouse with IntelliEye(TM)
usb 3-2: Manufacturer: Microsoft
snd_hda_intel 0000:00:1b.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
snd_hda_intel 0000:00:1b.0: irq 45 for MSI/MSI-X
snd_hda_intel 0000:00:1b.0: setting latency timer to 64
Linux video capture interface: v2.00
uvcvideo: Found UVC 1.00 device Built-in iSight (05ac:8501)
uvcvideo: UVC non compliance - GET_DEF(PROBE) not supported. Enabling workaround.
usbcore: registered new interface driver uvcvideo
USB Video Class driver (1.1.1)
hda_codec: ALC889A: SKU not ready 0x400000f0
input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input7
usb 5-1: new low speed USB device number 2 using uhci_hcd
usb 5-1: New USB device found, idVendor=0a81, idProduct=0205
usb 5-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 5-1: Product: PS2 to USB Converter
usb 5-1: Manufacturer: CHESEN
usb 3-1: usbfs: USBDEVFS_CONTROL failed cmd hid2hci rqt 64 rq 0 len 0 ret -84
generic-usb: probe of 0003:05AC:1000.0001 failed with error -71
generic-usb: probe of 0003:05AC:1000.0002 failed with error -71
input: Microsoft Microsoft 3-Button Mouse with IntelliEye(TM) as /devices/pci0000:00/0000:00:1a.0/usb3/3-2/3-2:1.0/input/input8
generic-usb 0003:045E:0040.0003: input,hidraw0: USB HID v1.10 Mouse [Microsoft Microsoft 3-Button Mouse with IntelliEye(TM)] on usb-0000:00:1a.0-2/input0
input: CHESEN PS2 to USB Converter as /devices/pci0000:00/0000:00:1d.0/usb5/5-1/5-1:1.0/input/input9
generic-usb 0003:0A81:0205.0004: input,hidraw1: USB HID v1.10 Keyboard [CHESEN PS2 to USB Converter] on usb-0000:00:1d.0-1/input0
usb 7-1: new low speed USB device number 2 using uhci_hcd
input: CHESEN PS2 to USB Converter as /devices/pci0000:00/0000:00:1d.0/usb5/5-1/5-1:1.1/input/input10
generic-usb 0003:0A81:0205.0005: input,hidraw2: USB HID v1.10 Mouse [CHESEN PS2 to USB Converter] on usb-0000:00:1d.0-1/input1
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
usb 7-1: New USB device found, idVendor=05ac, idProduct=8242
usb 7-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 7-1: Product: IR Receiver
usb 7-1: Manufacturer: Apple Computer, Inc.
usb 7-2: new full speed USB device number 3 using uhci_hcd
usb 7-2: New USB device found, idVendor=05ac, idProduct=022a
usb 7-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 7-2: Product: Apple Internal Keyboard / Trackpad
usb 7-2: Manufacturer: Apple Computer
usb 3-1: USB disconnect, device number 2
appletouch: Geyser mode initialized.
input: appletouch as /devices/pci0000:00/0000:00:1d.2/usb7/7-2/7-2:1.1/input/input11
usbcore: registered new interface driver appletouch
apple 0003:05AC:8242.0006: hiddev0,hidraw3: USB HID v1.11 Device [Apple Computer, Inc. IR Receiver] on usb-0000:00:1d.2-1/input0
input: Apple Computer Apple Internal Keyboard / Trackpad as /devices/pci0000:00/0000:00:1d.2/usb7/7-2/7-2:1.0/input/input12
apple 0003:05AC:022A.0007: input,hidraw4: USB HID v1.11 Keyboard [Apple Computer Apple Internal Keyboard / Trackpad] on usb-0000:00:1d.2-2/input0
input: Apple Computer Apple Internal Keyboard / Trackpad as /devices/pci0000:00/0000:00:1d.2/usb7/7-2/7-2:1.2/input/input13
apple 0003:05AC:022A.0008: input,hidraw5: USB HID v1.11 Device [Apple Computer Apple Internal Keyboard / Trackpad] on usb-0000:00:1d.2-2/input2
usb 3-1: new full speed USB device number 4 using uhci_hcd
usb 3-1: New USB device found, idVendor=05ac, idProduct=8205
usb 3-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
Bluetooth: Core ver 2.16
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
Bluetooth: L2CAP socket layer initialized
Bluetooth: SCO socket layer initialized
Bluetooth: Generic Bluetooth USB driver ver 0.6
usbcore: registered new interface driver btusb
Adding 3955912k swap on /dev/sda5.  Priority:-1 extents:1 across:3955912k 
EXT4-fs (sda4): re-mounted. Opts: (null)
EXT4-fs (sda4): re-mounted. Opts: errors=remount-ro
loop: module loaded
i2c /dev entries driver
fuse init (API version 7.17)
microcode: CPU0 sig=0x10676, pf=0x80, revision=0x60c
microcode: CPU1 sig=0x10676, pf=0x80, revision=0x60c
microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
microcode: CPU0 updated to revision 0x60f, date = 2010-09-29
microcode: CPU1 updated to revision 0x60f, date = 2010-09-29
input: ACPI Virtual Keyboard Device as /devices/virtual/input/input14
b43-phy0: Loading firmware version 508.1084 (2009-01-14 01:32:01)
ADDRCONF(NETDEV_UP): wlan0: link is not ready
sky2 0000:03:00.0: eth0: enabling interface
ADDRCONF(NETDEV_UP): eth0: link is not ready
Bluetooth: BNEP (Ethernet Emulation) ver 1.3
Bluetooth: BNEP filters: protocol multicast
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM ver 1.11
sky2 0000:03:00.0: eth0: Link is up at 100 Mbps, full duplex, flow control both
ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
eth0: no IPv6 routers present
wlan0: direct probe to d8:c7:c8:ad:e3:90 (try 1/3)
wlan0: direct probe responded
wlan0: authenticate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: authenticated
wlan0: associate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: RX AssocResp from d8:c7:c8:ad:e3:90 (capab=0x421 status=0 aid=2)
wlan0: associated
ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
wlan0: no IPv6 routers present
EXT4-fs (sda4): re-mounted. Opts: errors=remount-ro,commit=0
Bluetooth: HIDP (Human Interface Emulation) ver 1.2
ieee80211 phy0: wlan0: No probe response from AP d8:c7:c8:ad:e3:90 after 500ms, disconnecting.
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: authenticated
wlan0: associate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: RX ReassocResp from d8:c7:c8:ad:e3:90 (capab=0x421 status=0 aid=2)
wlan0: associated
ieee80211 phy0: wlan0: No probe response from AP d8:c7:c8:ad:e3:90 after 500ms, disconnecting.
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: authenticated
wlan0: associate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: RX ReassocResp from d8:c7:c8:ad:e3:90 (capab=0x421 status=0 aid=2)
wlan0: associated
applesmc: Th0S: read arg fail
applesmc: Th0H: read arg fail
ieee80211 phy0: wlan0: No probe response from AP d8:c7:c8:ad:e3:90 after 500ms, disconnecting.
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: authenticated
wlan0: associate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: RX ReassocResp from d8:c7:c8:ad:e3:90 (capab=0x421 status=0 aid=2)
wlan0: associated
ieee80211 phy0: wlan0: No probe response from AP d8:c7:c8:ad:e3:90 after 500ms, disconnecting.
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: authenticated
wlan0: associate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: RX ReassocResp from d8:c7:c8:ad:e3:90 (capab=0x421 status=0 aid=2)
wlan0: associated
ieee80211 phy0: wlan0: No probe response from AP d8:c7:c8:ad:e3:90 after 500ms, disconnecting.
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: authenticated
wlan0: associate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: RX ReassocResp from d8:c7:c8:ad:e3:90 (capab=0x421 status=0 aid=2)
wlan0: associated
applesmc: TM0P: read data fail
applesmc: Th0S: read arg fail
applesmc: TN0P: read arg fail
ieee80211 phy0: wlan0: No probe response from AP d8:c7:c8:ad:e3:90 after 500ms, disconnecting.
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: authenticated
wlan0: associate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: RX ReassocResp from d8:c7:c8:ad:e3:90 (capab=0x421 status=0 aid=2)
wlan0: associated
applesmc: Th0S: read arg fail
ieee80211 phy0: wlan0: No probe response from AP d8:c7:c8:ad:e3:90 after 500ms, disconnecting.
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: authenticated
wlan0: associate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: RX ReassocResp from d8:c7:c8:ad:e3:90 (capab=0x421 status=0 aid=2)
wlan0: associated
ieee80211 phy0: wlan0: No probe response from AP d8:c7:c8:ad:e3:90 after 500ms, disconnecting.
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: authenticated
wlan0: associate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: RX ReassocResp from d8:c7:c8:ad:e3:90 (capab=0x421 status=0 aid=2)
wlan0: associated
ACPI: EC: GPE storm detected, transactions will use polling mode
applesmc: TW0P: read arg fail
applesmc: TW0P: read arg fail
ieee80211 phy0: wlan0: No probe response from AP d8:c7:c8:ad:e3:90 after 500ms, disconnecting.
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: authenticated
wlan0: associate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: RX ReassocResp from d8:c7:c8:ad:e3:90 (capab=0x421 status=0 aid=2)
wlan0: associated
applesmc: TTF0: read arg fail
ieee80211 phy0: wlan0: No probe response from AP d8:c7:c8:ad:e3:90 after 500ms, disconnecting.
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: authenticated
wlan0: associate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: RX ReassocResp from d8:c7:c8:ad:e3:90 (capab=0x421 status=0 aid=2)
wlan0: associated
applesmc: TC0D: read data fail
applesmc: TN0P: read data fail
applesmc: TW0P: read arg fail
ieee80211 phy0: wlan0: No probe response from AP d8:c7:c8:ad:e3:90 after 500ms, disconnecting.
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: authenticated
wlan0: associate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: RX ReassocResp from d8:c7:c8:ad:e3:90 (capab=0x421 status=0 aid=2)
wlan0: associated
ieee80211 phy0: wlan0: No probe response from AP d8:c7:c8:ad:e3:90 after 500ms, disconnecting.
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: authenticated
wlan0: associate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: RX ReassocResp from d8:c7:c8:ad:e3:90 (capab=0x421 status=0 aid=2)
wlan0: associated
applesmc: TW0P: read arg fail
ieee80211 phy0: wlan0: No probe response from AP d8:c7:c8:ad:e3:90 after 500ms, disconnecting.
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: authenticated
wlan0: associate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: RX ReassocResp from d8:c7:c8:ad:e3:90 (capab=0x421 status=0 aid=2)
wlan0: associated
ieee80211 phy0: wlan0: No probe response from AP d8:c7:c8:ad:e3:90 after 500ms, disconnecting.
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: authenticated
wlan0: associate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: RX ReassocResp from d8:c7:c8:ad:e3:90 (capab=0x421 status=0 aid=2)
wlan0: associated
ieee80211 phy0: wlan0: No probe response from AP d8:c7:c8:ad:e3:90 after 500ms, disconnecting.
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: authenticated
wlan0: associate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: RX ReassocResp from d8:c7:c8:ad:e3:90 (capab=0x421 status=0 aid=2)
wlan0: associated
ieee80211 phy0: wlan0: No probe response from AP d8:c7:c8:ad:e3:90 after 500ms, disconnecting.
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: authenticated
wlan0: associate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: RX ReassocResp from d8:c7:c8:ad:e3:90 (capab=0x421 status=0 aid=2)
wlan0: associated
applesmc: Th0H: read arg fail
ieee80211 phy0: wlan0: No probe response from AP d8:c7:c8:ad:e3:90 after 500ms, disconnecting.
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: authenticated
wlan0: associate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: RX ReassocResp from d8:c7:c8:ad:e3:90 (capab=0x421 status=0 aid=2)
wlan0: associated
applesmc: TW0P: read arg fail
ieee80211 phy0: wlan0: No probe response from AP d8:c7:c8:ad:e3:90 after 500ms, disconnecting.
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: authenticated
wlan0: associate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: RX ReassocResp from d8:c7:c8:ad:e3:90 (capab=0x421 status=0 aid=2)
wlan0: associated
applesmc: TM0P: read arg fail
ieee80211 phy0: wlan0: No probe response from AP d8:c7:c8:ad:e3:90 after 500ms, disconnecting.
cfg80211: Calling CRDA to update world regulatory domain
applesmc: TM0P: read arg fail
wlan0: authenticate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: authenticated
wlan0: associate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: RX ReassocResp from d8:c7:c8:ad:e3:90 (capab=0x421 status=0 aid=2)
wlan0: associated
ieee80211 phy0: wlan0: No probe response from AP d8:c7:c8:ad:e3:90 after 500ms, disconnecting.
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: authenticated
wlan0: associate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: RX ReassocResp from d8:c7:c8:ad:e3:90 (capab=0x421 status=0 aid=2)
wlan0: associated
ieee80211 phy0: wlan0: No probe response from AP d8:c7:c8:ad:e3:90 after 500ms, disconnecting.
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: authenticated
wlan0: associate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: RX ReassocResp from d8:c7:c8:ad:e3:90 (capab=0x421 status=0 aid=2)
wlan0: associated
ieee80211 phy0: wlan0: No probe response from AP d8:c7:c8:ad:e3:90 after 500ms, disconnecting.
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: authenticated
wlan0: associate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: RX ReassocResp from d8:c7:c8:ad:e3:90 (capab=0x421 status=0 aid=2)
wlan0: associated
ieee80211 phy0: wlan0: No probe response from AP d8:c7:c8:ad:e3:90 after 500ms, disconnecting.
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: authenticated
wlan0: associate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: RX ReassocResp from d8:c7:c8:ad:e3:90 (capab=0x421 status=0 aid=2)
wlan0: associated
ieee80211 phy0: wlan0: No probe response from AP d8:c7:c8:ad:e3:90 after 500ms, disconnecting.
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: authenticated
wlan0: associate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: RX ReassocResp from d8:c7:c8:ad:e3:90 (capab=0x421 status=0 aid=2)
wlan0: associated
ieee80211 phy0: wlan0: No probe response from AP d8:c7:c8:ad:e3:90 after 500ms, disconnecting.
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: authenticated
wlan0: associate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: RX ReassocResp from d8:c7:c8:ad:e3:90 (capab=0x421 status=0 aid=2)
wlan0: associated
ieee80211 phy0: wlan0: No probe response from AP d8:c7:c8:ad:e3:90 after 500ms, disconnecting.
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: authenticated
wlan0: associate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: RX ReassocResp from d8:c7:c8:ad:e3:90 (capab=0x421 status=0 aid=2)
wlan0: associated
ieee80211 phy0: wlan0: No probe response from AP d8:c7:c8:ad:e3:90 after 500ms, disconnecting.
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: authenticated
wlan0: associate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: RX ReassocResp from d8:c7:c8:ad:e3:90 (capab=0x421 status=0 aid=2)
wlan0: associated
ieee80211 phy0: wlan0: No probe response from AP d8:c7:c8:ad:e3:90 after 500ms, disconnecting.
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: authenticated
wlan0: associate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: RX ReassocResp from d8:c7:c8:ad:e3:90 (capab=0x421 status=0 aid=2)
wlan0: associated
ieee80211 phy0: wlan0: No probe response from AP d8:c7:c8:ad:e3:90 after 500ms, disconnecting.
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: authenticated
wlan0: associate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: RX ReassocResp from d8:c7:c8:ad:e3:90 (capab=0x421 status=0 aid=2)
wlan0: associated
ieee80211 phy0: wlan0: No probe response from AP d8:c7:c8:ad:e3:90 after 500ms, disconnecting.
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: authenticated
wlan0: associate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: RX ReassocResp from d8:c7:c8:ad:e3:90 (capab=0x421 status=0 aid=2)
wlan0: associated
ieee80211 phy0: wlan0: No probe response from AP d8:c7:c8:ad:e3:90 after 500ms, disconnecting.
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: authenticated
wlan0: associate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: RX ReassocResp from d8:c7:c8:ad:e3:90 (capab=0x421 status=0 aid=2)
wlan0: associated
ieee80211 phy0: wlan0: No probe response from AP d8:c7:c8:ad:e3:90 after 500ms, disconnecting.
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: authenticate with d8:c7:c8:ad:e3:90 (try 2)
wlan0: authenticated
wlan0: associate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: RX ReassocResp from d8:c7:c8:ad:e3:90 (capab=0x421 status=0 aid=2)
wlan0: associated
ieee80211 phy0: wlan0: No probe response from AP d8:c7:c8:ad:e3:90 after 500ms, disconnecting.
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: authenticated
wlan0: associate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: RX ReassocResp from d8:c7:c8:ad:e3:90 (capab=0x421 status=0 aid=2)
wlan0: associated
ieee80211 phy0: wlan0: No probe response from AP d8:c7:c8:ad:e3:90 after 500ms, disconnecting.
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: authenticated
wlan0: associate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: RX ReassocResp from d8:c7:c8:ad:e3:90 (capab=0x421 status=0 aid=2)
wlan0: associated
applesmc: TC0P: read arg fail
ieee80211 phy0: wlan0: No probe response from AP d8:c7:c8:ad:e3:90 after 500ms, disconnecting.
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: authenticated
wlan0: associate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: RX ReassocResp from d8:c7:c8:ad:e3:90 (capab=0x421 status=0 aid=2)
wlan0: associated
ieee80211 phy0: wlan0: No probe response from AP d8:c7:c8:ad:e3:90 after 500ms, disconnecting.
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: authenticated
wlan0: associate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: RX ReassocResp from d8:c7:c8:ad:e3:90 (capab=0x421 status=0 aid=2)
wlan0: associated
applesmc: Th0H: read arg fail
ieee80211 phy0: wlan0: No probe response from AP d8:c7:c8:ad:e3:90 after 500ms, disconnecting.
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: authenticated
wlan0: associate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: RX ReassocResp from d8:c7:c8:ad:e3:90 (capab=0x421 status=0 aid=2)
wlan0: associated
ieee80211 phy0: wlan0: No probe response from AP d8:c7:c8:ad:e3:90 after 500ms, disconnecting.
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: authenticated
wlan0: associate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: RX ReassocResp from d8:c7:c8:ad:e3:90 (capab=0x421 status=0 aid=2)
wlan0: associated
ieee80211 phy0: wlan0: No probe response from AP d8:c7:c8:ad:e3:90 after 500ms, disconnecting.
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: authenticated
wlan0: associate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: RX ReassocResp from d8:c7:c8:ad:e3:90 (capab=0x421 status=0 aid=2)
wlan0: associated
ieee80211 phy0: wlan0: No probe response from AP d8:c7:c8:ad:e3:90 after 500ms, disconnecting.
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: authenticate with d8:c7:c8:ad:e3:90 (try 2)
wlan0: authenticated
wlan0: associate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: RX ReassocResp from d8:c7:c8:ad:e3:90 (capab=0x421 status=0 aid=2)
wlan0: associated
ieee80211 phy0: wlan0: No probe response from AP d8:c7:c8:ad:e3:90 after 500ms, disconnecting.
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: authenticated
wlan0: associate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: RX ReassocResp from d8:c7:c8:ad:e3:90 (capab=0x421 status=0 aid=2)
wlan0: associated
applesmc: TTF0: read arg fail
ieee80211 phy0: wlan0: No probe response from AP d8:c7:c8:ad:e3:90 after 500ms, disconnecting.
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: authenticated
wlan0: associate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: RX ReassocResp from d8:c7:c8:ad:e3:90 (capab=0x421 status=0 aid=2)
wlan0: associated
ieee80211 phy0: wlan0: No probe response from AP d8:c7:c8:ad:e3:90 after 500ms, disconnecting.
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: authenticated
wlan0: associate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: RX ReassocResp from d8:c7:c8:ad:e3:90 (capab=0x421 status=0 aid=2)
wlan0: associated
ieee80211 phy0: wlan0: No probe response from AP d8:c7:c8:ad:e3:90 after 500ms, disconnecting.
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: authenticated
wlan0: associate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: RX ReassocResp from d8:c7:c8:ad:e3:90 (capab=0x421 status=0 aid=2)
wlan0: associated
ieee80211 phy0: wlan0: No probe response from AP d8:c7:c8:ad:e3:90 after 500ms, disconnecting.
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: authenticated
wlan0: associate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: RX ReassocResp from d8:c7:c8:ad:e3:90 (capab=0x421 status=0 aid=2)
wlan0: associated
ieee80211 phy0: wlan0: No probe response from AP d8:c7:c8:ad:e3:90 after 500ms, disconnecting.
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: authenticated
wlan0: associate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: RX ReassocResp from d8:c7:c8:ad:e3:90 (capab=0x421 status=0 aid=2)
wlan0: associated
ieee80211 phy0: wlan0: No probe response from AP d8:c7:c8:ad:e3:90 after 500ms, disconnecting.
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: authenticated
wlan0: associate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: RX ReassocResp from d8:c7:c8:ad:e3:90 (capab=0x421 status=0 aid=2)
wlan0: associated
ieee80211 phy0: wlan0: No probe response from AP d8:c7:c8:ad:e3:90 after 500ms, disconnecting.
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: authenticated
wlan0: associate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: RX ReassocResp from d8:c7:c8:ad:e3:90 (capab=0x421 status=0 aid=2)
wlan0: associated
ieee80211 phy0: wlan0: No probe response from AP d8:c7:c8:ad:e3:90 after 500ms, disconnecting.
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: authenticated
wlan0: associate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: RX ReassocResp from d8:c7:c8:ad:e3:90 (capab=0x421 status=0 aid=2)
wlan0: associated
ieee80211 phy0: wlan0: No probe response from AP d8:c7:c8:ad:e3:90 after 500ms, disconnecting.
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: authenticated
wlan0: associate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: RX ReassocResp from d8:c7:c8:ad:e3:90 (capab=0x421 status=0 aid=2)
wlan0: associated
ieee80211 phy0: wlan0: No probe response from AP d8:c7:c8:ad:e3:90 after 500ms, disconnecting.
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: authenticated
wlan0: associate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: RX ReassocResp from d8:c7:c8:ad:e3:90 (capab=0x421 status=0 aid=2)
wlan0: associated
ieee80211 phy0: wlan0: No probe response from AP d8:c7:c8:ad:e3:90 after 500ms, disconnecting.
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: authenticated
wlan0: associate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: RX ReassocResp from d8:c7:c8:ad:e3:90 (capab=0x421 status=0 aid=2)
wlan0: associated
ieee80211 phy0: wlan0: No probe response from AP d8:c7:c8:ad:e3:90 after 500ms, disconnecting.
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: authenticated
wlan0: associate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: RX ReassocResp from d8:c7:c8:ad:e3:90 (capab=0x421 status=0 aid=2)
wlan0: associated
ieee80211 phy0: wlan0: No probe response from AP d8:c7:c8:ad:e3:90 after 500ms, disconnecting.
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: authenticated
wlan0: associate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: RX ReassocResp from d8:c7:c8:ad:e3:90 (capab=0x421 status=0 aid=2)
wlan0: associated
applesmc: TC0P: read arg fail
ieee80211 phy0: wlan0: No probe response from AP d8:c7:c8:ad:e3:90 after 500ms, disconnecting.
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: authenticated
wlan0: associate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: RX ReassocResp from d8:c7:c8:ad:e3:90 (capab=0x421 status=0 aid=2)
wlan0: associated
applesmc: Th0S: read arg fail
ieee80211 phy0: wlan0: No probe response from AP d8:c7:c8:ad:e3:90 after 500ms, disconnecting.
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: authenticated
wlan0: associate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: RX ReassocResp from d8:c7:c8:ad:e3:90 (capab=0x421 status=0 aid=2)
wlan0: associated
ieee80211 phy0: wlan0: No probe response from AP d8:c7:c8:ad:e3:90 after 500ms, disconnecting.
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: authenticated
wlan0: associate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: RX ReassocResp from d8:c7:c8:ad:e3:90 (capab=0x421 status=0 aid=2)
wlan0: associated
ieee80211 phy0: wlan0: No probe response from AP d8:c7:c8:ad:e3:90 after 500ms, disconnecting.
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: authenticated
wlan0: associate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: RX ReassocResp from d8:c7:c8:ad:e3:90 (capab=0x421 status=0 aid=2)
wlan0: associated
ieee80211 phy0: wlan0: No probe response from AP d8:c7:c8:ad:e3:90 after 500ms, disconnecting.
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: authenticated
wlan0: associate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: RX ReassocResp from d8:c7:c8:ad:e3:90 (capab=0x421 status=0 aid=2)
wlan0: associated
ieee80211 phy0: wlan0: No probe response from AP d8:c7:c8:ad:e3:90 after 500ms, disconnecting.
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: authenticated
wlan0: associate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: RX ReassocResp from d8:c7:c8:ad:e3:90 (capab=0x421 status=0 aid=2)
wlan0: associated
applesmc: Th1H: read data fail
ieee80211 phy0: wlan0: No probe response from AP d8:c7:c8:ad:e3:90 after 500ms, disconnecting.
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: authenticated
wlan0: associate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: RX ReassocResp from d8:c7:c8:ad:e3:90 (capab=0x421 status=0 aid=2)
wlan0: associated
ieee80211 phy0: wlan0: No probe response from AP d8:c7:c8:ad:e3:90 after 500ms, disconnecting.
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: authenticated
wlan0: associate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: RX ReassocResp from d8:c7:c8:ad:e3:90 (capab=0x421 status=0 aid=2)
wlan0: associated
ieee80211 phy0: wlan0: No probe response from AP d8:c7:c8:ad:e3:90 after 500ms, disconnecting.
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: authenticated
wlan0: associate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: RX ReassocResp from d8:c7:c8:ad:e3:90 (capab=0x421 status=0 aid=2)
wlan0: associated
ieee80211 phy0: wlan0: No probe response from AP d8:c7:c8:ad:e3:90 after 500ms, disconnecting.
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: authenticated
wlan0: associate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: RX ReassocResp from d8:c7:c8:ad:e3:90 (capab=0x421 status=0 aid=2)
wlan0: associated
ieee80211 phy0: wlan0: No probe response from AP d8:c7:c8:ad:e3:90 after 500ms, disconnecting.
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: authenticated
wlan0: associate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: RX ReassocResp from d8:c7:c8:ad:e3:90 (capab=0x421 status=0 aid=2)
wlan0: associated
ieee80211 phy0: wlan0: No probe response from AP d8:c7:c8:ad:e3:90 after 500ms, disconnecting.
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: authenticated
wlan0: associate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: RX ReassocResp from d8:c7:c8:ad:e3:90 (capab=0x421 status=0 aid=2)
wlan0: associated
ieee80211 phy0: wlan0: No probe response from AP d8:c7:c8:ad:e3:90 after 500ms, disconnecting.
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: authenticated
wlan0: associate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: RX ReassocResp from d8:c7:c8:ad:e3:90 (capab=0x421 status=0 aid=2)
wlan0: associated
ieee80211 phy0: wlan0: No probe response from AP d8:c7:c8:ad:e3:90 after 500ms, disconnecting.
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: authenticated
wlan0: associate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: RX ReassocResp from d8:c7:c8:ad:e3:90 (capab=0x421 status=0 aid=2)
wlan0: associated
applesmc: TW0P: read arg fail
ieee80211 phy0: wlan0: No probe response from AP d8:c7:c8:ad:e3:90 after 500ms, disconnecting.
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: authenticated
wlan0: associate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: RX ReassocResp from d8:c7:c8:ad:e3:90 (capab=0x421 status=0 aid=2)
wlan0: associated
ieee80211 phy0: wlan0: No probe response from AP d8:c7:c8:ad:e3:90 after 500ms, disconnecting.
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: authenticated
wlan0: associate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: RX ReassocResp from d8:c7:c8:ad:e3:90 (capab=0x421 status=0 aid=2)
wlan0: associated
ieee80211 phy0: wlan0: No probe response from AP d8:c7:c8:ad:e3:90 after 500ms, disconnecting.
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: authenticated
wlan0: associate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: RX ReassocResp from d8:c7:c8:ad:e3:90 (capab=0x421 status=0 aid=2)
wlan0: associated
ieee80211 phy0: wlan0: No probe response from AP d8:c7:c8:ad:e3:90 after 500ms, disconnecting.
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: authenticated
wlan0: associate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: RX ReassocResp from d8:c7:c8:ad:e3:90 (capab=0x421 status=0 aid=2)
wlan0: associated
applesmc: Th0H: read arg fail
ieee80211 phy0: wlan0: No probe response from AP d8:c7:c8:ad:e3:90 after 500ms, disconnecting.
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: authenticated
wlan0: associate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: RX ReassocResp from d8:c7:c8:ad:e3:90 (capab=0x421 status=0 aid=2)
wlan0: associated
ieee80211 phy0: wlan0: No probe response from AP d8:c7:c8:ad:e3:90 after 500ms, disconnecting.
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: authenticated
wlan0: associate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: RX ReassocResp from d8:c7:c8:ad:e3:90 (capab=0x421 status=0 aid=2)
wlan0: associated
ieee80211 phy0: wlan0: No probe response from AP d8:c7:c8:ad:e3:90 after 500ms, disconnecting.
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: authenticated
wlan0: associate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: RX ReassocResp from d8:c7:c8:ad:e3:90 (capab=0x421 status=0 aid=2)
wlan0: associated
applesmc: TW0P: read arg fail
ieee80211 phy0: wlan0: No probe response from AP d8:c7:c8:ad:e3:90 after 500ms, disconnecting.
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: authenticated
wlan0: associate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: RX ReassocResp from d8:c7:c8:ad:e3:90 (capab=0x421 status=0 aid=2)
wlan0: associated
ieee80211 phy0: wlan0: No probe response from AP d8:c7:c8:ad:e3:90 after 500ms, disconnecting.
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: authenticated
wlan0: associate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: RX ReassocResp from d8:c7:c8:ad:e3:90 (capab=0x421 status=0 aid=2)
wlan0: associated
applesmc: TM0P: read data fail
ieee80211 phy0: wlan0: No probe response from AP d8:c7:c8:ad:e3:90 after 500ms, disconnecting.
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: authenticated
wlan0: associate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: RX ReassocResp from d8:c7:c8:ad:e3:90 (capab=0x421 status=0 aid=2)
wlan0: associated
ieee80211 phy0: wlan0: No probe response from AP d8:c7:c8:ad:e3:90 after 500ms, disconnecting.
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: authenticated
wlan0: associate with d8:c7:c8:ad:e3:90 (try 1)
wlan0: RX ReassocResp from d8:c7:c8:ad:e3:90 (capab=0x421 status=0 aid=2)
wlan0: associated

--------------090207080602010705060606
Content-Type: text/plain;
 name="config-3.1.4.debug+"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="config-3.1.4.debug+"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.1.4.debug Kernel Configuration
#
CONFIG_64BIT=y
# CONFIG_X86_32 is not set
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf64-x86-64"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_ARCH_CLOCKSOURCE_DATA=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
# CONFIG_RWSEM_GENERIC_SPINLOCK is not set
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_DEFAULT_IDLE=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_HAVE_CPUMASK_OF_CPU_MAP=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ZONE_DMA32=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11"
# CONFIG_KTIME_SCALAR is not set
CONFIG_ARCH_CPU_PROBE_RELEASE=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_HAVE_IRQ_WORK=y
CONFIG_IRQ_WORK=y

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
CONFIG_LOCALVERSION=""
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
# CONFIG_POSIX_MQUEUE is not set
# CONFIG_BSD_PROCESS_ACCT is not set
CONFIG_FHANDLE=y
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
# CONFIG_TASK_XACCT is not set
# CONFIG_AUDIT is not set
CONFIG_HAVE_GENERIC_HARDIRQS=y

#
# IRQ subsystem
#
CONFIG_GENERIC_HARDIRQS=y
CONFIG_HAVE_SPARSE_IRQ=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
# CONFIG_RCU_TRACE is not set
CONFIG_RCU_FANOUT=64
# CONFIG_RCU_FANOUT_EXACT is not set
CONFIG_RCU_FAST_NO_HZ=y
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_IKCONFIG is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_DEVICE=y
CONFIG_CPUSETS=y
# CONFIG_PROC_PID_CPUSET is not set
CONFIG_CGROUP_CPUACCT=y
# CONFIG_RESOURCE_COUNTERS is not set
# CONFIG_CGROUP_PERF is not set
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_RT_GROUP_SCHED is not set
CONFIG_BLK_CGROUP=y
# CONFIG_DEBUG_BLK_CGROUP is not set
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_IPC_NS=y
CONFIG_USER_NS=y
CONFIG_PID_NS=y
CONFIG_NET_NS=y
CONFIG_SCHED_AUTOGROUP=y
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
# CONFIG_RD_BZIP2 is not set
# CONFIG_RD_LZMA is not set
# CONFIG_RD_XZ is not set
# CONFIG_RD_LZO is not set
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_EXPERT=y
# CONFIG_UID16 is not set
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
# CONFIG_EMBEDDED is not set
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_PERF_COUNTERS is not set
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
# CONFIG_COMPAT_BRK is not set
CONFIG_SLAB=y
# CONFIG_SLUB is not set
# CONFIG_SLOB is not set
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
CONFIG_OPROFILE=m
# CONFIG_OPROFILE_EVENT_MULTIPLEX is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_KPROBES=y
CONFIG_JUMP_LABEL=y
CONFIG_OPTPROBES=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_KRETPROBES=y
CONFIG_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
CONFIG_MODVERSIONS=y
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
# CONFIG_BLK_DEV_BSGLIB is not set
CONFIG_BLK_DEV_INTEGRITY=y
# CONFIG_BLK_DEV_THROTTLING is not set
CONFIG_BLOCK_COMPAT=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
CONFIG_CFQ_GROUP_IOSCHED=y
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_PREEMPT_NOTIFIERS=y
# CONFIG_INLINE_SPIN_TRYLOCK is not set
# CONFIG_INLINE_SPIN_TRYLOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK is not set
# CONFIG_INLINE_SPIN_LOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK_IRQ is not set
# CONFIG_INLINE_SPIN_LOCK_IRQSAVE is not set
# CONFIG_INLINE_SPIN_UNLOCK is not set
# CONFIG_INLINE_SPIN_UNLOCK_BH is not set
# CONFIG_INLINE_SPIN_UNLOCK_IRQ is not set
# CONFIG_INLINE_SPIN_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_READ_TRYLOCK is not set
# CONFIG_INLINE_READ_LOCK is not set
# CONFIG_INLINE_READ_LOCK_BH is not set
# CONFIG_INLINE_READ_LOCK_IRQ is not set
# CONFIG_INLINE_READ_LOCK_IRQSAVE is not set
# CONFIG_INLINE_READ_UNLOCK is not set
# CONFIG_INLINE_READ_UNLOCK_BH is not set
# CONFIG_INLINE_READ_UNLOCK_IRQ is not set
# CONFIG_INLINE_READ_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_WRITE_TRYLOCK is not set
# CONFIG_INLINE_WRITE_LOCK is not set
# CONFIG_INLINE_WRITE_LOCK_BH is not set
# CONFIG_INLINE_WRITE_LOCK_IRQ is not set
# CONFIG_INLINE_WRITE_LOCK_IRQSAVE is not set
# CONFIG_INLINE_WRITE_UNLOCK is not set
# CONFIG_INLINE_WRITE_UNLOCK_BH is not set
# CONFIG_INLINE_WRITE_UNLOCK_IRQ is not set
# CONFIG_INLINE_WRITE_UNLOCK_IRQRESTORE is not set
# CONFIG_MUTEX_SPIN_ON_OWNER is not set
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_SMP=y
CONFIG_X86_MPPARSE=y
# CONFIG_X86_EXTENDED_PLATFORM is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
CONFIG_SCHED_OMIT_FRAME_POINTER=y
# CONFIG_PARAVIRT_GUEST is not set
CONFIG_NO_BOOTMEM=y
# CONFIG_MEMTEST is not set
# CONFIG_MK8 is not set
# CONFIG_MPSC is not set
CONFIG_MCORE2=y
# CONFIG_MATOM is not set
# CONFIG_GENERIC_CPU is not set
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_CMPXCHG=y
CONFIG_CMPXCHG_LOCAL=y
CONFIG_CMPXCHG_DOUBLE=y
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_XADD=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_P6_NOP=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_PROCESSOR_SELECT=y
CONFIG_CPU_SUP_INTEL=y
# CONFIG_CPU_SUP_AMD is not set
# CONFIG_CPU_SUP_CENTAUR is not set
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
# CONFIG_CALGARY_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
# CONFIG_MAXSMP is not set
CONFIG_NR_CPUS=2
# CONFIG_SCHED_SMT is not set
CONFIG_SCHED_MC=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
# CONFIG_X86_MCE_AMD is not set
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=y
CONFIG_X86_THERMAL_VECTOR=y
# CONFIG_I8K is not set
CONFIG_MICROCODE=m
CONFIG_MICROCODE_INTEL=y
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=m
CONFIG_X86_CPUID=m
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
# CONFIG_NUMA is not set
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_PROC_KCORE_TEXT=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER=y
CONFIG_SPARSEMEM_VMEMMAP=y
CONFIG_HAVE_MEMBLOCK=y
# CONFIG_MEMORY_HOTPLUG is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=999999
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=65536
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_MEMORY_FAILURE=y
# CONFIG_HWPOISON_INJECT is not set
CONFIG_TRANSPARENT_HUGEPAGE=y
# CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS is not set
CONFIG_TRANSPARENT_HUGEPAGE_MADVISE=y
# CONFIG_CLEANCACHE is not set
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_EFI=y
CONFIG_SECCOMP=y
CONFIG_CC_STACKPROTECTOR=y
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
# CONFIG_CRASH_DUMP is not set
# CONFIG_KEXEC_JUMP is not set
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_HOTPLUG_CPU=y
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
CONFIG_ARCH_HIBERNATION_HEADER=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATE_CALLBACKS=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
CONFIG_PM_DEBUG=y
CONFIG_PM_ADVANCED_DEBUG=y
# CONFIG_PM_TEST_SUSPEND is not set
CONFIG_CAN_PM_TRACE=y
# CONFIG_PM_TRACE_RTC is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_PROCFS is not set
# CONFIG_ACPI_PROCFS_POWER is not set
# CONFIG_ACPI_EC_DEBUGFS is not set
# CONFIG_ACPI_PROC_EVENT is not set
CONFIG_ACPI_AC=m
CONFIG_ACPI_BATTERY=m
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=y
CONFIG_ACPI_FAN=m
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=m
# CONFIG_ACPI_IPMI is not set
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_PROCESSOR_AGGREGATOR=m
CONFIG_ACPI_THERMAL=m
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
CONFIG_ACPI_DEBUG=y
# CONFIG_ACPI_DEBUG_FUNC_TRACE is not set
CONFIG_ACPI_PCI_SLOT=m
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=m
CONFIG_ACPI_SBS=m
CONFIG_ACPI_HED=m
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_APEI is not set
# CONFIG_SFI is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_STAT=m
# CONFIG_CPU_FREQ_STAT_DETAILS is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=m
# CONFIG_CPU_FREQ_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_GOV_CONSERVATIVE is not set

#
# x86 CPU frequency scaling drivers
#
# CONFIG_X86_PCC_CPUFREQ is not set
CONFIG_X86_ACPI_CPUFREQ=m
# CONFIG_X86_POWERNOW_K8 is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
# CONFIG_X86_P4_CLOCKMOD is not set

#
# shared options
#
# CONFIG_X86_SPEEDSTEP_LIB is not set
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_INTEL_IDLE is not set

#
# Memory power savings
#
# CONFIG_I7300_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
CONFIG_PCIEPORTBUS=y
CONFIG_PCIEAER=y
# CONFIG_PCIE_ECRC is not set
# CONFIG_PCIEAER_INJECT is not set
CONFIG_PCIEASPM=y
# CONFIG_PCIEASPM_DEBUG is not set
CONFIG_PCIE_PME=y
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_STUB is not set
CONFIG_HT_IRQ=y
CONFIG_PCI_IOV=y
CONFIG_PCI_IOAPIC=y
CONFIG_PCI_LABEL=y
CONFIG_ISA_DMA_API=y
CONFIG_PCCARD=m
CONFIG_PCMCIA=m
CONFIG_PCMCIA_LOAD_CIS=y
CONFIG_CARDBUS=y

#
# PC-card bridges
#
CONFIG_YENTA=m
CONFIG_YENTA_O2=y
CONFIG_YENTA_RICOH=y
CONFIG_YENTA_TI=y
CONFIG_YENTA_ENE_TUNE=y
CONFIG_YENTA_TOSHIBA=y
# CONFIG_PD6729 is not set
CONFIG_I82092=m
CONFIG_PCCARD_NONSTATIC=y
# CONFIG_HOTPLUG_PCI is not set
# CONFIG_RAPIDIO is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=m
CONFIG_IA32_EMULATION=y
CONFIG_IA32_AOUT=y
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_KEYS_COMPAT=y
CONFIG_HAVE_TEXT_POKE_SMP=y
CONFIG_NET=y
CONFIG_COMPAT_NETLINK_MESSAGES=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_UNIX=y
CONFIG_XFRM=y
CONFIG_XFRM_USER=m
# CONFIG_XFRM_SUB_POLICY is not set
# CONFIG_XFRM_MIGRATE is not set
# CONFIG_XFRM_STATISTICS is not set
CONFIG_XFRM_IPCOMP=m
CONFIG_NET_KEY=m
# CONFIG_NET_KEY_MIGRATE is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_IP_FIB_TRIE_STATS=y
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
CONFIG_IP_ROUTE_CLASSID=y
# CONFIG_IP_PNP is not set
CONFIG_NET_IPIP=m
CONFIG_NET_IPGRE_DEMUX=m
CONFIG_NET_IPGRE=m
CONFIG_NET_IPGRE_BROADCAST=y
CONFIG_IP_MROUTE=y
CONFIG_IP_MROUTE_MULTIPLE_TABLES=y
CONFIG_IP_PIMSM_V1=y
CONFIG_IP_PIMSM_V2=y
# CONFIG_ARPD is not set
CONFIG_SYN_COOKIES=y
CONFIG_INET_AH=m
CONFIG_INET_ESP=m
CONFIG_INET_IPCOMP=m
CONFIG_INET_XFRM_TUNNEL=m
CONFIG_INET_TUNNEL=m
CONFIG_INET_XFRM_MODE_TRANSPORT=m
CONFIG_INET_XFRM_MODE_TUNNEL=m
CONFIG_INET_XFRM_MODE_BEET=m
CONFIG_INET_LRO=m
CONFIG_INET_DIAG=m
CONFIG_INET_TCP_DIAG=m
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=m
CONFIG_TCP_CONG_CUBIC=y
CONFIG_TCP_CONG_WESTWOOD=m
CONFIG_TCP_CONG_HTCP=m
# CONFIG_TCP_CONG_HSTCP is not set
# CONFIG_TCP_CONG_HYBLA is not set
# CONFIG_TCP_CONG_VEGAS is not set
# CONFIG_TCP_CONG_SCALABLE is not set
# CONFIG_TCP_CONG_LP is not set
# CONFIG_TCP_CONG_VENO is not set
# CONFIG_TCP_CONG_YEAH is not set
# CONFIG_TCP_CONG_ILLINOIS is not set
CONFIG_DEFAULT_CUBIC=y
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
CONFIG_IPV6=y
CONFIG_IPV6_PRIVACY=y
CONFIG_IPV6_ROUTER_PREF=y
# CONFIG_IPV6_ROUTE_INFO is not set
# CONFIG_IPV6_OPTIMISTIC_DAD is not set
CONFIG_INET6_AH=m
CONFIG_INET6_ESP=m
CONFIG_INET6_IPCOMP=m
# CONFIG_IPV6_MIP6 is not set
CONFIG_INET6_XFRM_TUNNEL=m
CONFIG_INET6_TUNNEL=m
CONFIG_INET6_XFRM_MODE_TRANSPORT=m
CONFIG_INET6_XFRM_MODE_TUNNEL=m
CONFIG_INET6_XFRM_MODE_BEET=m
# CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION is not set
CONFIG_IPV6_SIT=m
# CONFIG_IPV6_SIT_6RD is not set
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_IPV6_TUNNEL=m
# CONFIG_IPV6_MULTIPLE_TABLES is not set
# CONFIG_IPV6_MROUTE is not set
CONFIG_NETWORK_SECMARK=y
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
# CONFIG_NETFILTER is not set
# CONFIG_IP_DCCP is not set
# CONFIG_IP_SCTP is not set
# CONFIG_RDS is not set
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
# CONFIG_L2TP is not set
# CONFIG_BRIDGE is not set
# CONFIG_NET_DSA is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
CONFIG_LLC=m
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
CONFIG_ATALK=m
CONFIG_DEV_APPLETALK=m
CONFIG_IPDDP=m
CONFIG_IPDDP_ENCAP=y
CONFIG_IPDDP_DECAP=y
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set
# CONFIG_PHONET is not set
# CONFIG_IEEE802154 is not set
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=m
CONFIG_NET_SCH_HTB=m
CONFIG_NET_SCH_HFSC=m
CONFIG_NET_SCH_PRIO=m
CONFIG_NET_SCH_MULTIQ=m
CONFIG_NET_SCH_RED=m
CONFIG_NET_SCH_SFB=m
CONFIG_NET_SCH_SFQ=m
CONFIG_NET_SCH_TEQL=m
CONFIG_NET_SCH_TBF=m
CONFIG_NET_SCH_GRED=m
CONFIG_NET_SCH_DSMARK=m
CONFIG_NET_SCH_NETEM=m
CONFIG_NET_SCH_DRR=m
CONFIG_NET_SCH_MQPRIO=m
CONFIG_NET_SCH_CHOKE=m
CONFIG_NET_SCH_QFQ=m
CONFIG_NET_SCH_INGRESS=m

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=m
CONFIG_NET_CLS_TCINDEX=m
CONFIG_NET_CLS_ROUTE4=m
CONFIG_NET_CLS_FW=m
CONFIG_NET_CLS_U32=m
CONFIG_CLS_U32_PERF=y
CONFIG_CLS_U32_MARK=y
CONFIG_NET_CLS_RSVP=m
CONFIG_NET_CLS_RSVP6=m
CONFIG_NET_CLS_FLOW=m
CONFIG_NET_CLS_CGROUP=y
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
CONFIG_NET_EMATCH_CMP=m
CONFIG_NET_EMATCH_NBYTE=m
CONFIG_NET_EMATCH_U32=m
CONFIG_NET_EMATCH_META=m
CONFIG_NET_EMATCH_TEXT=m
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=m
CONFIG_NET_ACT_GACT=m
CONFIG_GACT_PROB=y
CONFIG_NET_ACT_MIRRED=m
CONFIG_NET_ACT_NAT=m
CONFIG_NET_ACT_PEDIT=m
CONFIG_NET_ACT_SIMP=m
CONFIG_NET_ACT_SKBEDIT=m
CONFIG_NET_ACT_CSUM=m
CONFIG_NET_CLS_IND=y
CONFIG_NET_SCH_FIFO=y
# CONFIG_DCB is not set
CONFIG_DNS_RESOLVER=y
CONFIG_BATMAN_ADV=m
# CONFIG_BATMAN_ADV_DEBUG is not set
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
CONFIG_HAVE_BPF_JIT=y
CONFIG_BPF_JIT=y

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_NET_TCPPROBE is not set
# CONFIG_NET_DROP_MONITOR is not set
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
CONFIG_BT=m
CONFIG_BT_L2CAP=y
CONFIG_BT_SCO=y
CONFIG_BT_RFCOMM=m
CONFIG_BT_RFCOMM_TTY=y
CONFIG_BT_BNEP=m
CONFIG_BT_BNEP_MC_FILTER=y
CONFIG_BT_BNEP_PROTO_FILTER=y
CONFIG_BT_HIDP=m

#
# Bluetooth device drivers
#
CONFIG_BT_HCIBTUSB=m
# CONFIG_BT_HCIBTSDIO is not set
# CONFIG_BT_HCIUART is not set
# CONFIG_BT_HCIBCM203X is not set
# CONFIG_BT_HCIBPA10X is not set
# CONFIG_BT_HCIBFUSB is not set
# CONFIG_BT_HCIDTL1 is not set
# CONFIG_BT_HCIBT3C is not set
# CONFIG_BT_HCIBLUECARD is not set
# CONFIG_BT_HCIBTUART is not set
# CONFIG_BT_HCIVHCI is not set
# CONFIG_BT_MRVL is not set
# CONFIG_BT_ATH3K is not set
# CONFIG_AF_RXRPC is not set
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_PROC=y
CONFIG_CFG80211=m
# CONFIG_NL80211_TESTMODE is not set
# CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
# CONFIG_CFG80211_REG_DEBUG is not set
CONFIG_CFG80211_DEFAULT_PS=y
# CONFIG_CFG80211_DEBUGFS is not set
# CONFIG_CFG80211_INTERNAL_REGDB is not set
CONFIG_CFG80211_WEXT=y
# CONFIG_WIRELESS_EXT_SYSFS is not set
# CONFIG_LIB80211 is not set
CONFIG_MAC80211=m
CONFIG_MAC80211_HAS_RC=y
# CONFIG_MAC80211_RC_PID is not set
CONFIG_MAC80211_RC_MINSTREL=y
CONFIG_MAC80211_RC_MINSTREL_HT=y
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT="minstrel_ht"
# CONFIG_MAC80211_MESH is not set
CONFIG_MAC80211_LEDS=y
# CONFIG_MAC80211_DEBUGFS is not set
# CONFIG_MAC80211_DEBUG_MENU is not set
# CONFIG_WIMAX is not set
CONFIG_RFKILL=m
CONFIG_RFKILL_LEDS=y
CONFIG_RFKILL_INPUT=y
# CONFIG_NET_9P is not set
# CONFIG_CAIF is not set
# CONFIG_CEPH_LIB is not set
# CONFIG_NFC is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
CONFIG_DEVTMPFS=y
# CONFIG_DEVTMPFS_MOUNT is not set
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_CONNECTOR is not set
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=m
CONFIG_BLK_DEV_LOOP_MIN_COUNT=0
# CONFIG_BLK_DEV_CRYPTOLOOP is not set

#
# DRBD disabled because PROC_FS, INET or CONNECTOR not selected
#
CONFIG_BLK_DEV_NBD=m
# CONFIG_BLK_DEV_OSD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
# CONFIG_BLK_DEV_RAM is not set
CONFIG_CDROM_PKTCDVD=m
CONFIG_CDROM_PKTCDVD_BUFFERS=8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_BLK_DEV_HD is not set
# CONFIG_BLK_DEV_RBD is not set
# CONFIG_SENSORS_LIS3LV02D is not set
CONFIG_MISC_DEVICES=y
# CONFIG_AD525X_DPOT is not set
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_INTEL_MID_PTI is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_ICS932S401 is not set
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_HP_ILO is not set
# CONFIG_APDS9802ALS is not set
# CONFIG_ISL29003 is not set
# CONFIG_ISL29020 is not set
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_SENSORS_BH1780 is not set
# CONFIG_SENSORS_BH1770 is not set
# CONFIG_SENSORS_APDS990X is not set
# CONFIG_HMC6352 is not set
# CONFIG_DS1682 is not set
# CONFIG_VMWARE_BALLOON is not set
# CONFIG_BMP085 is not set
# CONFIG_PCH_PHUB is not set
# CONFIG_USB_SWITCH_FSA9480 is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
CONFIG_EEPROM_AT24=m
CONFIG_EEPROM_LEGACY=m
# CONFIG_EEPROM_MAX6875 is not set
# CONFIG_EEPROM_93CX6 is not set
# CONFIG_CB710_CORE is not set
# CONFIG_IWMC3200TOP is not set

#
# Texas Instruments shared transport line discipline
#
# CONFIG_SENSORS_LIS3_I2C is not set
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=m
CONFIG_RAID_ATTRS=m
CONFIG_SCSI=m
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=m
CONFIG_SCSI_NETLINK=y
# CONFIG_SCSI_PROC_FS is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=m
CONFIG_CHR_DEV_ST=m
CONFIG_CHR_DEV_OSST=m
CONFIG_BLK_DEV_SR=m
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=m
CONFIG_CHR_DEV_SCH=m
CONFIG_SCSI_MULTI_LUN=y
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=m
CONFIG_SCSI_FC_ATTRS=m
CONFIG_SCSI_FC_TGT_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=m
CONFIG_SCSI_SAS_ATTRS=m
CONFIG_SCSI_SAS_LIBSAS=m
CONFIG_SCSI_SAS_ATA=y
CONFIG_SCSI_SAS_HOST_SMP=y
CONFIG_SCSI_SRP_ATTRS=m
CONFIG_SCSI_SRP_TGT_ATTRS=y
# CONFIG_SCSI_LOWLEVEL is not set
# CONFIG_SCSI_LOWLEVEL_PCMCIA is not set
# CONFIG_SCSI_DH is not set
CONFIG_SCSI_OSD_INITIATOR=m
CONFIG_SCSI_OSD_ULD=m
CONFIG_SCSI_OSD_DPRINT_SENSE=1
# CONFIG_SCSI_OSD_DEBUG is not set
CONFIG_ATA=m
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_ACPI=y
# CONFIG_SATA_PMP is not set

#
# Controllers with non-SFF native interface
#
# CONFIG_SATA_AHCI is not set
# CONFIG_SATA_AHCI_PLATFORM is not set
# CONFIG_SATA_INIC162X is not set
# CONFIG_SATA_ACARD_AHCI is not set
# CONFIG_SATA_SIL24 is not set
CONFIG_ATA_SFF=y

#
# SFF controllers with custom DMA interface
#
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_SX4 is not set
CONFIG_ATA_BMDMA=y

#
# SATA SFF controllers with BMDMA
#
CONFIG_ATA_PIIX=m
# CONFIG_SATA_MV is not set
# CONFIG_SATA_NV is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_SVW is not set
# CONFIG_SATA_ULI is not set
# CONFIG_SATA_VIA is not set
# CONFIG_SATA_VITESSE is not set

#
# PATA SFF controllers with BMDMA
#
# CONFIG_PATA_ALI is not set
# CONFIG_PATA_AMD is not set
# CONFIG_PATA_ARASAN_CF is not set
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_ATP867X is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CS5520 is not set
# CONFIG_PATA_CS5530 is not set
# CONFIG_PATA_CS5536 is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT8213 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NINJA32 is not set
# CONFIG_PATA_NS87415 is not set
# CONFIG_PATA_OLDPIIX is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RDC is not set
# CONFIG_PATA_SC1200 is not set
# CONFIG_PATA_SCH is not set
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_SIL680 is not set
# CONFIG_PATA_SIS is not set
# CONFIG_PATA_TOSHIBA is not set
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_VIA is not set
# CONFIG_PATA_WINBOND is not set

#
# PIO-only SFF controllers
#
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_PCMCIA is not set
# CONFIG_PATA_PLATFORM is not set
# CONFIG_PATA_RZ1000 is not set

#
# Generic fallback / legacy drivers
#
# CONFIG_PATA_ACPI is not set
# CONFIG_ATA_GENERIC is not set
# CONFIG_PATA_LEGACY is not set
CONFIG_MD=y
# CONFIG_BLK_DEV_MD is not set
# CONFIG_BLK_DEV_DM is not set
# CONFIG_TARGET_CORE is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=m
CONFIG_FIREWIRE_OHCI=m
CONFIG_FIREWIRE_OHCI_DEBUG=y
CONFIG_FIREWIRE_SBP2=m
CONFIG_FIREWIRE_NET=m
CONFIG_FIREWIRE_NOSY=m
# CONFIG_I2O is not set
CONFIG_MACINTOSH_DRIVERS=y
CONFIG_MAC_EMUMOUSEBTN=y
CONFIG_NETDEVICES=y
CONFIG_IFB=m
# CONFIG_DUMMY is not set
CONFIG_BONDING=m
# CONFIG_MACVLAN is not set
# CONFIG_EQUALIZER is not set
CONFIG_TUN=m
CONFIG_VETH=m
# CONFIG_NET_SB1000 is not set
# CONFIG_ARCNET is not set
# CONFIG_MII is not set
CONFIG_PHYLIB=m

#
# MII PHY device drivers
#
# CONFIG_MARVELL_PHY is not set
# CONFIG_DAVICOM_PHY is not set
# CONFIG_QSEMI_PHY is not set
# CONFIG_LXT_PHY is not set
# CONFIG_CICADA_PHY is not set
# CONFIG_VITESSE_PHY is not set
# CONFIG_SMSC_PHY is not set
CONFIG_BROADCOM_PHY=m
# CONFIG_ICPLUS_PHY is not set
# CONFIG_REALTEK_PHY is not set
# CONFIG_NATIONAL_PHY is not set
# CONFIG_STE10XP is not set
# CONFIG_LSI_ET1011C_PHY is not set
# CONFIG_MICREL_PHY is not set
# CONFIG_MDIO_BITBANG is not set
# CONFIG_NET_ETHERNET is not set
CONFIG_NETDEV_1000=y
# CONFIG_ACENIC is not set
# CONFIG_DL2K is not set
# CONFIG_E1000 is not set
# CONFIG_E1000E is not set
# CONFIG_IP1000 is not set
# CONFIG_IGB is not set
# CONFIG_IGBVF is not set
# CONFIG_NS83820 is not set
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
# CONFIG_R8169 is not set
# CONFIG_SIS190 is not set
# CONFIG_SKGE is not set
CONFIG_SKY2=m
# CONFIG_SKY2_DEBUG is not set
# CONFIG_VIA_VELOCITY is not set
# CONFIG_TIGON3 is not set
# CONFIG_BNX2 is not set
# CONFIG_CNIC is not set
# CONFIG_QLA3XXX is not set
# CONFIG_ATL1 is not set
# CONFIG_ATL1E is not set
# CONFIG_ATL1C is not set
# CONFIG_JME is not set
# CONFIG_STMMAC_ETH is not set
# CONFIG_PCH_GBE is not set
# CONFIG_NETDEV_10000 is not set
# CONFIG_TR is not set
CONFIG_WLAN=y
# CONFIG_PCMCIA_RAYCS is not set
# CONFIG_LIBERTAS_THINFIRM is not set
# CONFIG_AIRO is not set
# CONFIG_ATMEL is not set
# CONFIG_AT76C50X_USB is not set
# CONFIG_AIRO_CS is not set
# CONFIG_PCMCIA_WL3501 is not set
# CONFIG_PRISM54 is not set
# CONFIG_USB_ZD1201 is not set
# CONFIG_USB_NET_RNDIS_WLAN is not set
# CONFIG_RTL8180 is not set
# CONFIG_RTL8187 is not set
# CONFIG_ADM8211 is not set
# CONFIG_MAC80211_HWSIM is not set
# CONFIG_MWL8K is not set
# CONFIG_ATH_COMMON is not set
CONFIG_B43=m
CONFIG_B43_SSB=y
CONFIG_B43_PCI_AUTOSELECT=y
CONFIG_B43_PCICORE_AUTOSELECT=y
# CONFIG_B43_PCMCIA is not set
CONFIG_B43_SDIO=y
CONFIG_B43_PIO=y
CONFIG_B43_PHY_N=y
CONFIG_B43_PHY_LP=y
CONFIG_B43_LEDS=y
CONFIG_B43_HWRNG=y
# CONFIG_B43_DEBUG is not set
# CONFIG_B43LEGACY is not set
# CONFIG_HOSTAP is not set
# CONFIG_IPW2100 is not set
# CONFIG_IPW2200 is not set
# CONFIG_IWLAGN is not set
# CONFIG_IWL4965 is not set
# CONFIG_IWL3945 is not set
# CONFIG_IWM is not set
# CONFIG_LIBERTAS is not set
# CONFIG_HERMES is not set
# CONFIG_P54_COMMON is not set
# CONFIG_RT2X00 is not set
# CONFIG_RTL8192CE is not set
# CONFIG_RTL8192SE is not set
# CONFIG_RTL8192DE is not set
# CONFIG_RTL8192CU is not set
# CONFIG_WL1251 is not set
# CONFIG_WL12XX_MENU is not set
# CONFIG_ZD1211RW is not set
# CONFIG_MWIFIEX is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
# CONFIG_USB_USBNET is not set
# CONFIG_USB_HSO is not set
# CONFIG_USB_IPHETH is not set
# CONFIG_NET_PCMCIA is not set
# CONFIG_WAN is not set

#
# CAIF transport drivers
#
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
CONFIG_PPP=m
# CONFIG_PPP_MULTILINK is not set
CONFIG_PPP_FILTER=y
CONFIG_PPP_ASYNC=m
CONFIG_PPP_SYNC_TTY=m
CONFIG_PPP_DEFLATE=m
CONFIG_PPP_BSDCOMP=m
# CONFIG_PPP_MPPE is not set
# CONFIG_PPPOE is not set
# CONFIG_PPTP is not set
# CONFIG_SLIP is not set
CONFIG_SLHC=m
# CONFIG_NET_FC is not set
# CONFIG_NETCONSOLE is not set
# CONFIG_NETPOLL is not set
# CONFIG_NET_POLL_CONTROLLER is not set
# CONFIG_VMXNET3 is not set
# CONFIG_ISDN is not set
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=m
CONFIG_INPUT_POLLDEV=m
CONFIG_INPUT_SPARSEKMAP=m

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
CONFIG_INPUT_EVDEV=m
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
# CONFIG_INPUT_KEYBOARD is not set
CONFIG_INPUT_MOUSE=y
# CONFIG_MOUSE_PS2 is not set
# CONFIG_MOUSE_SERIAL is not set
CONFIG_MOUSE_APPLETOUCH=m
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_AD714X is not set
CONFIG_INPUT_PCSPKR=m
# CONFIG_INPUT_MMA8450 is not set
# CONFIG_INPUT_MPU3050 is not set
# CONFIG_INPUT_APANEL is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
# CONFIG_INPUT_KXTJ9 is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
CONFIG_INPUT_UINPUT=m
# CONFIG_INPUT_PCF8574 is not set
# CONFIG_INPUT_ADXL34X is not set
# CONFIG_INPUT_CMA3000 is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=m
# CONFIG_SERIO_I8042 is not set
# CONFIG_SERIO_SERPORT is not set
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PCIPS2 is not set
# CONFIG_SERIO_LIBPS2 is not set
# CONFIG_SERIO_RAW is not set
# CONFIG_SERIO_ALTERA_PS2 is not set
# CONFIG_SERIO_PS2MULT is not set
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_UNIX98_PTYS=y
CONFIG_DEVPTS_MULTIPLE_INSTANCES=y
# CONFIG_LEGACY_PTYS is not set
CONFIG_SERIAL_NONSTANDARD=y
CONFIG_ROCKETPORT=m
CONFIG_CYCLADES=m
# CONFIG_CYZ_INTR is not set
CONFIG_MOXA_INTELLIO=m
CONFIG_MOXA_SMARTIO=m
CONFIG_SYNCLINK=m
CONFIG_SYNCLINKMP=m
CONFIG_SYNCLINK_GT=m
# CONFIG_NOZOMI is not set
# CONFIG_ISI is not set
CONFIG_N_HDLC=m
# CONFIG_N_GSM is not set
# CONFIG_TRACE_SINK is not set
# CONFIG_DEVKMEM is not set
# CONFIG_STALDRV is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CS=m
CONFIG_SERIAL_8250_NR_UARTS=32
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
CONFIG_SERIAL_8250_RSA=y

#
# Non-8250 serial port support
#
CONFIG_SERIAL_MFD_HSU=m
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_JSM=m
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_PCH_UART is not set
# CONFIG_SERIAL_XILINX_PS_UART is not set
# CONFIG_TTY_PRINTK is not set
CONFIG_IPMI_HANDLER=m
# CONFIG_IPMI_PANIC_EVENT is not set
CONFIG_IPMI_DEVICE_INTERFACE=m
CONFIG_IPMI_SI=m
CONFIG_IPMI_WATCHDOG=m
CONFIG_IPMI_POWEROFF=m
CONFIG_HW_RANDOM=m
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
CONFIG_HW_RANDOM_INTEL=m
# CONFIG_HW_RANDOM_AMD is not set
# CONFIG_HW_RANDOM_VIA is not set
CONFIG_NVRAM=m
CONFIG_R3964=m
CONFIG_APPLICOM=m

#
# PCMCIA character devices
#
CONFIG_SYNCLINK_CS=m
CONFIG_CARDMAN_4000=m
CONFIG_CARDMAN_4040=m
CONFIG_IPWIRELESS=m
# CONFIG_MWAVE is not set
# CONFIG_RAW_DRIVER is not set
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
CONFIG_HANGCHECK_TIMER=m
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_RAMOOPS=m
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=m
# CONFIG_I2C_MUX is not set
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_ALGOBIT=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
CONFIG_I2C_I801=m
# CONFIG_I2C_ISCH is not set
# CONFIG_I2C_PIIX4 is not set
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set

#
# ACPI drivers
#
CONFIG_I2C_SCMI=m

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_INTEL_MID=m
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA_PCI is not set
# CONFIG_I2C_SIMTEC is not set
# CONFIG_I2C_XILINX is not set
# CONFIG_I2C_EG20T is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_DIOLAN_U2C is not set
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_TINY_USB is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_STUB is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_SPI is not set

#
# PPS support
#
# CONFIG_PPS is not set

#
# PPS generators support
#

#
# PTP clock support
#

#
# Enable Device Drivers -> PPS to see the PTP clock options.
#
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
# CONFIG_GPIOLIB is not set
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=m
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_TEST_POWER is not set
# CONFIG_BATTERY_DS2780 is not set
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_BQ20Z75 is not set
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_BATTERY_MAX17042 is not set
# CONFIG_CHARGER_ISP1704 is not set
# CONFIG_CHARGER_MAX8903 is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=m
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
# CONFIG_SENSORS_ABITUGURU is not set
# CONFIG_SENSORS_ABITUGURU3 is not set
# CONFIG_SENSORS_AD7414 is not set
# CONFIG_SENSORS_AD7418 is not set
CONFIG_SENSORS_ADM1021=m
CONFIG_SENSORS_ADM1025=m
CONFIG_SENSORS_ADM1026=m
CONFIG_SENSORS_ADM1029=m
CONFIG_SENSORS_ADM1031=m
CONFIG_SENSORS_ADM9240=m
# CONFIG_SENSORS_ADT7411 is not set
# CONFIG_SENSORS_ADT7462 is not set
# CONFIG_SENSORS_ADT7470 is not set
CONFIG_SENSORS_ADT7475=m
CONFIG_SENSORS_ASC7621=m
# CONFIG_SENSORS_K8TEMP is not set
CONFIG_SENSORS_K10TEMP=m
CONFIG_SENSORS_FAM15H_POWER=m
# CONFIG_SENSORS_ASB100 is not set
# CONFIG_SENSORS_ATXP1 is not set
CONFIG_SENSORS_DS620=m
CONFIG_SENSORS_DS1621=m
# CONFIG_SENSORS_I5K_AMB is not set
CONFIG_SENSORS_F71805F=m
CONFIG_SENSORS_F71882FG=m
CONFIG_SENSORS_F75375S=m
CONFIG_SENSORS_FSCHMD=m
CONFIG_SENSORS_G760A=m
CONFIG_SENSORS_GL518SM=m
CONFIG_SENSORS_GL520SM=m
CONFIG_SENSORS_CORETEMP=m
CONFIG_SENSORS_IBMAEM=m
CONFIG_SENSORS_IBMPEX=m
CONFIG_SENSORS_IT87=m
# CONFIG_SENSORS_JC42 is not set
# CONFIG_SENSORS_LINEAGE is not set
CONFIG_SENSORS_LM63=m
CONFIG_SENSORS_LM73=m
CONFIG_SENSORS_LM75=m
CONFIG_SENSORS_LM77=m
CONFIG_SENSORS_LM78=m
CONFIG_SENSORS_LM80=m
CONFIG_SENSORS_LM83=m
CONFIG_SENSORS_LM85=m
CONFIG_SENSORS_LM87=m
CONFIG_SENSORS_LM90=m
CONFIG_SENSORS_LM92=m
CONFIG_SENSORS_LM93=m
CONFIG_SENSORS_LTC4151=m
# CONFIG_SENSORS_LTC4215 is not set
# CONFIG_SENSORS_LTC4245 is not set
# CONFIG_SENSORS_LTC4261 is not set
CONFIG_SENSORS_LM95241=m
# CONFIG_SENSORS_LM95245 is not set
CONFIG_SENSORS_MAX16065=m
CONFIG_SENSORS_MAX1619=m
# CONFIG_SENSORS_MAX1668 is not set
# CONFIG_SENSORS_MAX6639 is not set
# CONFIG_SENSORS_MAX6642 is not set
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_NTC_THERMISTOR is not set
CONFIG_SENSORS_PC87360=m
CONFIG_SENSORS_PC87427=m
CONFIG_SENSORS_PCF8591=m
# CONFIG_PMBUS is not set
CONFIG_SENSORS_SHT21=m
CONFIG_SENSORS_SIS5595=m
# CONFIG_SENSORS_SMM665 is not set
# CONFIG_SENSORS_DME1737 is not set
CONFIG_SENSORS_EMC1403=m
# CONFIG_SENSORS_EMC2103 is not set
CONFIG_SENSORS_EMC6W201=m
CONFIG_SENSORS_SMSC47M1=m
CONFIG_SENSORS_SMSC47M192=m
# CONFIG_SENSORS_SMSC47B397 is not set
CONFIG_SENSORS_SCH56XX_COMMON=m
CONFIG_SENSORS_SCH5627=m
# CONFIG_SENSORS_SCH5636 is not set
CONFIG_SENSORS_ADS1015=m
CONFIG_SENSORS_ADS7828=m
# CONFIG_SENSORS_AMC6821 is not set
CONFIG_SENSORS_THMC50=m
# CONFIG_SENSORS_TMP102 is not set
# CONFIG_SENSORS_TMP401 is not set
# CONFIG_SENSORS_TMP421 is not set
CONFIG_SENSORS_VIA_CPUTEMP=m
CONFIG_SENSORS_VIA686A=m
CONFIG_SENSORS_VT1211=m
CONFIG_SENSORS_VT8231=m
CONFIG_SENSORS_W83781D=m
CONFIG_SENSORS_W83791D=m
CONFIG_SENSORS_W83792D=m
# CONFIG_SENSORS_W83793 is not set
# CONFIG_SENSORS_W83795 is not set
# CONFIG_SENSORS_W83L785TS is not set
# CONFIG_SENSORS_W83L786NG is not set
CONFIG_SENSORS_W83627HF=m
CONFIG_SENSORS_W83627EHF=m
CONFIG_SENSORS_APPLESMC=m

#
# ACPI drivers
#
CONFIG_SENSORS_ACPI_POWER=m
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=m
CONFIG_SSB_SPROM=y
CONFIG_SSB_BLOCKIO=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
CONFIG_SSB_B43_PCI_BRIDGE=y
CONFIG_SSB_PCMCIAHOST_POSSIBLE=y
# CONFIG_SSB_PCMCIAHOST is not set
CONFIG_SSB_SDIOHOST_POSSIBLE=y
CONFIG_SSB_SDIOHOST=y
# CONFIG_SSB_SILENT is not set
# CONFIG_SSB_DEBUG is not set
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
# CONFIG_BCMA is not set
CONFIG_MFD_SUPPORT=y
CONFIG_MFD_CORE=m
# CONFIG_MFD_88PM860X is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_TPS6105X is not set
# CONFIG_TPS6507X is not set
# CONFIG_TWL4030_CORE is not set
# CONFIG_MFD_STMPE is not set
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_PMIC_DA903X is not set
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_MAX8925 is not set
# CONFIG_MFD_MAX8997 is not set
# CONFIG_MFD_MAX8998 is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM831X_I2C is not set
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_WM8994 is not set
# CONFIG_MFD_PCF50633 is not set
# CONFIG_ABX500_CORE is not set
# CONFIG_MFD_CS5535 is not set
CONFIG_LPC_SCH=m
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_VX855 is not set
# CONFIG_MFD_WL1273_CORE is not set
# CONFIG_REGULATOR is not set
CONFIG_MEDIA_SUPPORT=m

#
# Multimedia core support
#
# CONFIG_MEDIA_CONTROLLER is not set
CONFIG_VIDEO_DEV=m
CONFIG_VIDEO_V4L2_COMMON=m
# CONFIG_DVB_CORE is not set
CONFIG_VIDEO_MEDIA=m

#
# Multimedia drivers
#
# CONFIG_RC_CORE is not set
CONFIG_MEDIA_ATTACH=y
CONFIG_MEDIA_TUNER=m
# CONFIG_MEDIA_TUNER_CUSTOMISE is not set
CONFIG_MEDIA_TUNER_SIMPLE=m
CONFIG_MEDIA_TUNER_TDA8290=m
CONFIG_MEDIA_TUNER_TDA827X=m
CONFIG_MEDIA_TUNER_TDA18271=m
CONFIG_MEDIA_TUNER_TDA9887=m
CONFIG_MEDIA_TUNER_TEA5761=m
CONFIG_MEDIA_TUNER_TEA5767=m
CONFIG_MEDIA_TUNER_MT20XX=m
CONFIG_MEDIA_TUNER_XC2028=m
CONFIG_MEDIA_TUNER_XC5000=m
CONFIG_MEDIA_TUNER_XC4000=m
CONFIG_MEDIA_TUNER_MC44S803=m
CONFIG_VIDEO_V4L2=m
CONFIG_VIDEO_CAPTURE_DRIVERS=y
# CONFIG_VIDEO_ADV_DEBUG is not set
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
CONFIG_VIDEO_HELPER_CHIPS_AUTO=y

#
# Audio decoders, processors and mixers
#

#
# RDS decoders
#

#
# Video decoders
#

#
# Video and audio decoders
#

#
# MPEG video encoders
#

#
# Video encoders
#

#
# Camera sensor devices
#

#
# Flash devices
#

#
# Video improvement chips
#

#
# Miscelaneous helper chips
#
# CONFIG_VIDEO_VIVI is not set
# CONFIG_VIDEO_CPIA2 is not set
# CONFIG_VIDEO_ZORAN is not set
# CONFIG_VIDEO_SAA7134 is not set
# CONFIG_VIDEO_MXB is not set
# CONFIG_VIDEO_HEXIUM_ORION is not set
# CONFIG_VIDEO_HEXIUM_GEMINI is not set
# CONFIG_VIDEO_TIMBERDALE is not set
# CONFIG_VIDEO_CAFE_CCIC is not set
# CONFIG_VIDEO_SR030PC30 is not set
# CONFIG_VIDEO_NOON010PC30 is not set
# CONFIG_SOC_CAMERA is not set
CONFIG_V4L_USB_DRIVERS=y
CONFIG_USB_VIDEO_CLASS=m
CONFIG_USB_VIDEO_CLASS_INPUT_EVDEV=y
CONFIG_USB_GSPCA=m
CONFIG_USB_M5602=m
CONFIG_USB_STV06XX=m
CONFIG_USB_GL860=m
CONFIG_USB_GSPCA_BENQ=m
CONFIG_USB_GSPCA_CONEX=m
CONFIG_USB_GSPCA_CPIA1=m
CONFIG_USB_GSPCA_ETOMS=m
CONFIG_USB_GSPCA_FINEPIX=m
CONFIG_USB_GSPCA_JEILINJ=m
CONFIG_USB_GSPCA_KINECT=m
CONFIG_USB_GSPCA_KONICA=m
CONFIG_USB_GSPCA_MARS=m
CONFIG_USB_GSPCA_MR97310A=m
CONFIG_USB_GSPCA_NW80X=m
CONFIG_USB_GSPCA_OV519=m
CONFIG_USB_GSPCA_OV534=m
CONFIG_USB_GSPCA_OV534_9=m
CONFIG_USB_GSPCA_PAC207=m
CONFIG_USB_GSPCA_PAC7302=m
CONFIG_USB_GSPCA_PAC7311=m
# CONFIG_USB_GSPCA_SE401 is not set
CONFIG_USB_GSPCA_SN9C2028=m
CONFIG_USB_GSPCA_SN9C20X=m
CONFIG_USB_GSPCA_SONIXB=m
CONFIG_USB_GSPCA_SONIXJ=m
CONFIG_USB_GSPCA_SPCA500=m
CONFIG_USB_GSPCA_SPCA501=m
CONFIG_USB_GSPCA_SPCA505=m
CONFIG_USB_GSPCA_SPCA506=m
CONFIG_USB_GSPCA_SPCA508=m
CONFIG_USB_GSPCA_SPCA561=m
CONFIG_USB_GSPCA_SPCA1528=m
CONFIG_USB_GSPCA_SQ905=m
CONFIG_USB_GSPCA_SQ905C=m
CONFIG_USB_GSPCA_SQ930X=m
CONFIG_USB_GSPCA_STK014=m
CONFIG_USB_GSPCA_STV0680=m
CONFIG_USB_GSPCA_SUNPLUS=m
CONFIG_USB_GSPCA_T613=m
CONFIG_USB_GSPCA_TV8532=m
CONFIG_USB_GSPCA_VC032X=m
CONFIG_USB_GSPCA_VICAM=m
CONFIG_USB_GSPCA_XIRLINK_CIT=m
CONFIG_USB_GSPCA_ZC3XX=m
# CONFIG_VIDEO_PVRUSB2 is not set
# CONFIG_VIDEO_HDPVR is not set
# CONFIG_VIDEO_EM28XX is not set
# CONFIG_VIDEO_USBVISION is not set
# CONFIG_USB_ET61X251 is not set
# CONFIG_USB_SN9C102 is not set
# CONFIG_USB_PWC is not set
# CONFIG_USB_ZR364XX is not set
# CONFIG_USB_STKWEBCAM is not set
# CONFIG_USB_S2255 is not set
# CONFIG_V4L_MEM2MEM_DRIVERS is not set
# CONFIG_RADIO_ADAPTERS is not set

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_INTEL=y
# CONFIG_AGP_SIS is not set
# CONFIG_AGP_VIA is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set
CONFIG_DRM=y
CONFIG_DRM_KMS_HELPER=y
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_I810 is not set
CONFIG_DRM_I915=y
CONFIG_DRM_I915_KMS=y
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_SIS is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
# CONFIG_STUB_POULSBO is not set
# CONFIG_VGASTATE is not set
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
# CONFIG_FB_DDC is not set
# CONFIG_FB_BOOT_VESA_SUPPORT is not set
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
# CONFIG_FB_SYS_FILLRECT is not set
# CONFIG_FB_SYS_COPYAREA is not set
# CONFIG_FB_SYS_IMAGEBLIT is not set
# CONFIG_FB_FOREIGN_ENDIAN is not set
# CONFIG_FB_SYS_FOPS is not set
# CONFIG_FB_WMT_GE_ROPS is not set
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
# CONFIG_FB_MODE_HELPERS is not set
# CONFIG_FB_TILEBLITTING is not set

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_VESA is not set
# CONFIG_FB_EFI is not set
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_GEODE is not set
# CONFIG_FB_TMIO is not set
# CONFIG_FB_UDL is not set
# CONFIG_FB_VIRTUAL is not set
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_BROADSHEET is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
# CONFIG_LCD_CLASS_DEVICE is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_GENERIC is not set
# CONFIG_BACKLIGHT_PROGEAR is not set
CONFIG_BACKLIGHT_APPLE=m
# CONFIG_BACKLIGHT_SAHARA is not set
# CONFIG_BACKLIGHT_ADP8860 is not set
# CONFIG_BACKLIGHT_ADP8870 is not set

#
# Display device support
#
CONFIG_DISPLAY_SUPPORT=m

#
# Display hardware drivers
#

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
# CONFIG_VGACON_SOFT_SCROLLBACK is not set
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
# CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
# CONFIG_LOGO_LINUX_VGA16 is not set
CONFIG_LOGO_LINUX_CLUT224=y
CONFIG_SOUND=m
CONFIG_SOUND_OSS_CORE=y
# CONFIG_SOUND_OSS_CORE_PRECLAIM is not set
CONFIG_SND=m
CONFIG_SND_TIMER=m
CONFIG_SND_PCM=m
CONFIG_SND_HWDEP=m
CONFIG_SND_JACK=y
CONFIG_SND_SEQUENCER=m
# CONFIG_SND_SEQ_DUMMY is not set
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=m
CONFIG_SND_PCM_OSS=m
CONFIG_SND_PCM_OSS_PLUGINS=y
# CONFIG_SND_SEQUENCER_OSS is not set
CONFIG_SND_HRTIMER=m
CONFIG_SND_SEQ_HRTIMER_DEFAULT=y
CONFIG_SND_DYNAMIC_MINORS=y
# CONFIG_SND_SUPPORT_OLD_API is not set
# CONFIG_SND_VERBOSE_PROCFS is not set
# CONFIG_SND_VERBOSE_PRINTK is not set
CONFIG_SND_DEBUG=y
# CONFIG_SND_DEBUG_VERBOSE is not set
CONFIG_SND_VMASTER=y
CONFIG_SND_DMA_SGBUF=y
# CONFIG_SND_RAWMIDI_SEQ is not set
# CONFIG_SND_OPL3_LIB_SEQ is not set
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
# CONFIG_SND_EMU10K1_SEQ is not set
CONFIG_SND_DRIVERS=y
# CONFIG_SND_PCSP is not set
# CONFIG_SND_DUMMY is not set
# CONFIG_SND_ALOOP is not set
# CONFIG_SND_VIRMIDI is not set
# CONFIG_SND_MTPAV is not set
# CONFIG_SND_SERIAL_U16550 is not set
# CONFIG_SND_MPU401 is not set
CONFIG_SND_PCI=y
# CONFIG_SND_AD1889 is not set
# CONFIG_SND_ALS300 is not set
# CONFIG_SND_ALS4000 is not set
# CONFIG_SND_ALI5451 is not set
# CONFIG_SND_ASIHPI is not set
# CONFIG_SND_ATIIXP is not set
# CONFIG_SND_ATIIXP_MODEM is not set
# CONFIG_SND_AU8810 is not set
# CONFIG_SND_AU8820 is not set
# CONFIG_SND_AU8830 is not set
# CONFIG_SND_AW2 is not set
# CONFIG_SND_AZT3328 is not set
# CONFIG_SND_BT87X is not set
# CONFIG_SND_CA0106 is not set
# CONFIG_SND_CMIPCI is not set
# CONFIG_SND_OXYGEN is not set
# CONFIG_SND_CS4281 is not set
# CONFIG_SND_CS46XX is not set
# CONFIG_SND_CS5530 is not set
# CONFIG_SND_CS5535AUDIO is not set
# CONFIG_SND_CTXFI is not set
# CONFIG_SND_DARLA20 is not set
# CONFIG_SND_GINA20 is not set
# CONFIG_SND_LAYLA20 is not set
# CONFIG_SND_DARLA24 is not set
# CONFIG_SND_GINA24 is not set
# CONFIG_SND_LAYLA24 is not set
# CONFIG_SND_MONA is not set
# CONFIG_SND_MIA is not set
# CONFIG_SND_ECHO3G is not set
# CONFIG_SND_INDIGO is not set
# CONFIG_SND_INDIGOIO is not set
# CONFIG_SND_INDIGODJ is not set
# CONFIG_SND_INDIGOIOX is not set
# CONFIG_SND_INDIGODJX is not set
# CONFIG_SND_EMU10K1 is not set
# CONFIG_SND_EMU10K1X is not set
# CONFIG_SND_ENS1370 is not set
# CONFIG_SND_ENS1371 is not set
# CONFIG_SND_ES1938 is not set
# CONFIG_SND_ES1968 is not set
# CONFIG_SND_FM801 is not set
CONFIG_SND_HDA_INTEL=m
CONFIG_SND_HDA_PREALLOC_SIZE=2048
CONFIG_SND_HDA_HWDEP=y
# CONFIG_SND_HDA_RECONFIG is not set
CONFIG_SND_HDA_INPUT_BEEP=y
CONFIG_SND_HDA_INPUT_BEEP_MODE=1
CONFIG_SND_HDA_INPUT_JACK=y
# CONFIG_SND_HDA_PATCH_LOADER is not set
CONFIG_SND_HDA_CODEC_REALTEK=y
CONFIG_SND_HDA_ENABLE_REALTEK_QUIRKS=y
# CONFIG_SND_HDA_CODEC_ANALOG is not set
# CONFIG_SND_HDA_CODEC_SIGMATEL is not set
# CONFIG_SND_HDA_CODEC_VIA is not set
# CONFIG_SND_HDA_CODEC_HDMI is not set
# CONFIG_SND_HDA_CODEC_CIRRUS is not set
# CONFIG_SND_HDA_CODEC_CONEXANT is not set
# CONFIG_SND_HDA_CODEC_CA0110 is not set
# CONFIG_SND_HDA_CODEC_CA0132 is not set
# CONFIG_SND_HDA_CODEC_CMEDIA is not set
# CONFIG_SND_HDA_CODEC_SI3054 is not set
CONFIG_SND_HDA_GENERIC=y
CONFIG_SND_HDA_POWER_SAVE=y
CONFIG_SND_HDA_POWER_SAVE_DEFAULT=0
# CONFIG_SND_HDSP is not set
# CONFIG_SND_HDSPM is not set
# CONFIG_SND_ICE1712 is not set
# CONFIG_SND_ICE1724 is not set
# CONFIG_SND_INTEL8X0 is not set
# CONFIG_SND_INTEL8X0M is not set
# CONFIG_SND_KORG1212 is not set
# CONFIG_SND_LOLA is not set
# CONFIG_SND_LX6464ES is not set
# CONFIG_SND_MAESTRO3 is not set
# CONFIG_SND_MIXART is not set
# CONFIG_SND_NM256 is not set
# CONFIG_SND_PCXHR is not set
# CONFIG_SND_RIPTIDE is not set
# CONFIG_SND_RME32 is not set
# CONFIG_SND_RME96 is not set
# CONFIG_SND_RME9652 is not set
# CONFIG_SND_SONICVIBES is not set
# CONFIG_SND_TRIDENT is not set
# CONFIG_SND_VIA82XX is not set
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VIRTUOSO is not set
# CONFIG_SND_VX222 is not set
# CONFIG_SND_YMFPCI is not set
# CONFIG_SND_USB is not set
CONFIG_SND_FIREWIRE=y
CONFIG_SND_FIREWIRE_LIB=m
# CONFIG_SND_FIREWIRE_SPEAKERS is not set
CONFIG_SND_ISIGHT=m
# CONFIG_SND_PCMCIA is not set
# CONFIG_SND_SOC is not set
# CONFIG_SOUND_PRIME is not set
CONFIG_HID_SUPPORT=y
CONFIG_HID=m
CONFIG_HIDRAW=y

#
# USB Input Devices
#
CONFIG_USB_HID=m
CONFIG_HID_PID=y
CONFIG_USB_HIDDEV=y

#
# USB HID Boot Protocol drivers
#
# CONFIG_USB_KBD is not set
# CONFIG_USB_MOUSE is not set

#
# Special HID drivers
#
# CONFIG_HID_A4TECH is not set
# CONFIG_HID_ACRUX is not set
CONFIG_HID_APPLE=m
# CONFIG_HID_BELKIN is not set
# CONFIG_HID_CHERRY is not set
# CONFIG_HID_CHICONY is not set
# CONFIG_HID_PRODIKEYS is not set
# CONFIG_HID_CYPRESS is not set
# CONFIG_HID_DRAGONRISE is not set
# CONFIG_HID_EMS_FF is not set
# CONFIG_HID_ELECOM is not set
# CONFIG_HID_EZKEY is not set
# CONFIG_HID_HOLTEK is not set
# CONFIG_HID_KEYTOUCH is not set
# CONFIG_HID_KYE is not set
# CONFIG_HID_UCLOGIC is not set
# CONFIG_HID_WALTOP is not set
# CONFIG_HID_GYRATION is not set
# CONFIG_HID_TWINHAN is not set
# CONFIG_HID_KENSINGTON is not set
# CONFIG_HID_LCPOWER is not set
# CONFIG_HID_LOGITECH is not set
CONFIG_HID_MAGICMOUSE=m
# CONFIG_HID_MICROSOFT is not set
# CONFIG_HID_MONTEREY is not set
# CONFIG_HID_MULTITOUCH is not set
# CONFIG_HID_NTRIG is not set
# CONFIG_HID_ORTEK is not set
# CONFIG_HID_PANTHERLORD is not set
# CONFIG_HID_PETALYNX is not set
# CONFIG_HID_PICOLCD is not set
# CONFIG_HID_QUANTA is not set
CONFIG_HID_ROCCAT=m
CONFIG_HID_ROCCAT_COMMON=m
# CONFIG_HID_ROCCAT_ARVO is not set
# CONFIG_HID_ROCCAT_KONE is not set
# CONFIG_HID_ROCCAT_KONEPLUS is not set
# CONFIG_HID_ROCCAT_KOVAPLUS is not set
# CONFIG_HID_ROCCAT_PYRA is not set
# CONFIG_HID_SAMSUNG is not set
# CONFIG_HID_SONY is not set
# CONFIG_HID_SPEEDLINK is not set
# CONFIG_HID_SUNPLUS is not set
# CONFIG_HID_GREENASIA is not set
# CONFIG_HID_SMARTJOYPLUS is not set
# CONFIG_HID_TOPSEED is not set
# CONFIG_HID_THRUSTMASTER is not set
# CONFIG_HID_WACOM is not set
# CONFIG_HID_WIIMOTE is not set
# CONFIG_HID_ZEROPLUS is not set
# CONFIG_HID_ZYDACRON is not set
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=m
# CONFIG_USB_DEBUG is not set
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
CONFIG_USB_DEVICEFS=y
# CONFIG_USB_DEVICE_CLASS is not set
CONFIG_USB_DYNAMIC_MINORS=y
CONFIG_USB_SUSPEND=y
# CONFIG_USB_OTG is not set
# CONFIG_USB_OTG_WHITELIST is not set
# CONFIG_USB_OTG_BLACKLIST_HUB is not set
# CONFIG_USB_MON is not set
# CONFIG_USB_WUSB is not set
CONFIG_USB_WUSB_CBAF=m
# CONFIG_USB_WUSB_CBAF_DEBUG is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
# CONFIG_USB_XHCI_HCD is not set
CONFIG_USB_EHCI_HCD=m
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
# CONFIG_USB_ISP1362_HCD is not set
# CONFIG_USB_OHCI_HCD is not set
CONFIG_USB_UHCI_HCD=m
# CONFIG_USB_U132_HCD is not set
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_WHCI_HCD is not set
# CONFIG_USB_HWA_HCD is not set

#
# USB Device Class drivers
#
CONFIG_USB_ACM=m
CONFIG_USB_PRINTER=m
CONFIG_USB_WDM=m
CONFIG_USB_TMC=m

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=m
# CONFIG_USB_STORAGE_DEBUG is not set
CONFIG_USB_STORAGE_REALTEK=m
CONFIG_REALTEK_AUTOPM=y
CONFIG_USB_STORAGE_DATAFAB=m
CONFIG_USB_STORAGE_FREECOM=m
CONFIG_USB_STORAGE_ISD200=m
CONFIG_USB_STORAGE_USBAT=m
CONFIG_USB_STORAGE_SDDR09=m
CONFIG_USB_STORAGE_SDDR55=m
CONFIG_USB_STORAGE_JUMPSHOT=m
CONFIG_USB_STORAGE_ALAUDA=m
CONFIG_USB_STORAGE_ONETOUCH=m
CONFIG_USB_STORAGE_KARMA=m
CONFIG_USB_STORAGE_CYPRESS_ATACB=m
CONFIG_USB_STORAGE_ENE_UB6250=m
CONFIG_USB_UAS=m
# CONFIG_USB_LIBUSUAL is not set

#
# USB Imaging devices
#
CONFIG_USB_MDC800=m
CONFIG_USB_MICROTEK=m

#
# USB port drivers
#
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=m
CONFIG_USB_EMI26=m
CONFIG_USB_ADUTUX=m
CONFIG_USB_SEVSEG=m
CONFIG_USB_RIO500=m
CONFIG_USB_LEGOTOWER=m
CONFIG_USB_LCD=m
CONFIG_USB_LED=m
CONFIG_USB_CYPRESS_CY7C63=m
CONFIG_USB_CYTHERM=m
# CONFIG_USB_IDMOUSE is not set
CONFIG_USB_FTDI_ELAN=m
CONFIG_USB_APPLEDISPLAY=m
CONFIG_USB_SISUSBVGA=m
CONFIG_USB_SISUSBVGA_CON=y
CONFIG_USB_LD=m
CONFIG_USB_TRANCEVIBRATOR=m
CONFIG_USB_IOWARRIOR=m
# CONFIG_USB_TEST is not set
CONFIG_USB_ISIGHTFW=m
CONFIG_USB_YUREX=m
# CONFIG_USB_GADGET is not set

#
# OTG and related infrastructure
#
CONFIG_USB_OTG_UTILS=y
CONFIG_NOP_USB_XCEIV=m
# CONFIG_UWB is not set
CONFIG_MMC=m
# CONFIG_MMC_DEBUG is not set
# CONFIG_MMC_UNSAFE_RESUME is not set
# CONFIG_MMC_CLKGATE is not set

#
# MMC/SD/SDIO Card Drivers
#
CONFIG_MMC_BLOCK=m
CONFIG_MMC_BLOCK_MINORS=8
CONFIG_MMC_BLOCK_BOUNCE=y
CONFIG_SDIO_UART=m
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=m
CONFIG_MMC_SDHCI_PCI=m
CONFIG_MMC_RICOH_MMC=y
CONFIG_MMC_SDHCI_PLTFM=m
CONFIG_MMC_WBSD=m
# CONFIG_MMC_TIFM_SD is not set
# CONFIG_MMC_SDRICOH_CS is not set
# CONFIG_MMC_CB710 is not set
CONFIG_MMC_VIA_SDMMC=m
CONFIG_MMC_VUB300=m
CONFIG_MMC_USHC=m
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
# CONFIG_LEDS_LM3530 is not set
# CONFIG_LEDS_ALIX2 is not set
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_LP3944 is not set
# CONFIG_LEDS_LP5521 is not set
# CONFIG_LEDS_LP5523 is not set
# CONFIG_LEDS_PCA955X is not set
# CONFIG_LEDS_BD2802 is not set
# CONFIG_LEDS_INTEL_SS4200 is not set
CONFIG_LEDS_TRIGGERS=y

#
# LED Triggers
#
CONFIG_LEDS_TRIGGER_TIMER=m
CONFIG_LEDS_TRIGGER_HEARTBEAT=m
CONFIG_LEDS_TRIGGER_BACKLIGHT=m
CONFIG_LEDS_TRIGGER_DEFAULT_ON=m

#
# iptables trigger is under Netfilter config (LED target)
#
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
CONFIG_EDAC=y

#
# Reporting subsystems
#
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_MM_EDAC=m
CONFIG_EDAC_MCE=y
CONFIG_EDAC_E752X=m
CONFIG_EDAC_I82975X=m
CONFIG_EDAC_I3000=m
CONFIG_EDAC_I3200=m
CONFIG_EDAC_X38=m
CONFIG_EDAC_I5400=m
CONFIG_EDAC_I7CORE=m
CONFIG_EDAC_I5000=m
CONFIG_EDAC_I5100=m
CONFIG_EDAC_I7300=m
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
CONFIG_RTC_DEBUG=y

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_DS1307 is not set
# CONFIG_RTC_DRV_DS1374 is not set
# CONFIG_RTC_DRV_DS1672 is not set
# CONFIG_RTC_DRV_DS3232 is not set
# CONFIG_RTC_DRV_MAX6900 is not set
# CONFIG_RTC_DRV_RS5C372 is not set
# CONFIG_RTC_DRV_ISL1208 is not set
# CONFIG_RTC_DRV_ISL12022 is not set
# CONFIG_RTC_DRV_X1205 is not set
# CONFIG_RTC_DRV_PCF8563 is not set
# CONFIG_RTC_DRV_PCF8583 is not set
# CONFIG_RTC_DRV_M41T80 is not set
# CONFIG_RTC_DRV_BQ32K is not set
# CONFIG_RTC_DRV_S35390A is not set
# CONFIG_RTC_DRV_FM3130 is not set
# CONFIG_RTC_DRV_RX8581 is not set
# CONFIG_RTC_DRV_RX8025 is not set
# CONFIG_RTC_DRV_EM3027 is not set
# CONFIG_RTC_DRV_RV3029C2 is not set

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
# CONFIG_RTC_DRV_DS1286 is not set
# CONFIG_RTC_DRV_DS1511 is not set
# CONFIG_RTC_DRV_DS1553 is not set
# CONFIG_RTC_DRV_DS1742 is not set
# CONFIG_RTC_DRV_STK17TA8 is not set
# CONFIG_RTC_DRV_M48T86 is not set
# CONFIG_RTC_DRV_M48T35 is not set
# CONFIG_RTC_DRV_M48T59 is not set
# CONFIG_RTC_DRV_MSM6242 is not set
# CONFIG_RTC_DRV_BQ4802 is not set
# CONFIG_RTC_DRV_RP5C01 is not set
# CONFIG_RTC_DRV_V3020 is not set

#
# on-CPU RTC drivers
#
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
# CONFIG_INTEL_MID_DMAC is not set
CONFIG_INTEL_IOATDMA=m
# CONFIG_TIMB_DMA is not set
# CONFIG_PCH_DMA is not set
CONFIG_DMA_ENGINE=y

#
# DMA Clients
#
CONFIG_NET_DMA=y
# CONFIG_ASYNC_TX_DMA is not set
# CONFIG_DMATEST is not set
CONFIG_DCA=m
# CONFIG_AUXDISPLAY is not set
# CONFIG_UIO is not set

#
# Virtio drivers
#
# CONFIG_VIRTIO_PCI is not set
# CONFIG_VIRTIO_BALLOON is not set
# CONFIG_STAGING is not set
# CONFIG_X86_PLATFORM_DEVICES is not set
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
# CONFIG_IOMMU_SUPPORT is not set
# CONFIG_VIRT_DRIVERS is not set

#
# Firmware Drivers
#
CONFIG_EDD=m
# CONFIG_EDD_OFF is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_EFI_VARS=m
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
CONFIG_DMIID=y
# CONFIG_DMI_SYSFS is not set
# CONFIG_ISCSI_IBFT_FIND is not set
# CONFIG_SIGMA is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# File systems
#
CONFIG_EXT2_FS=m
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
CONFIG_EXT2_FS_SECURITY=y
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=m
CONFIG_EXT3_DEFAULTS_TO_ORDERED=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
CONFIG_EXT4_FS=m
CONFIG_EXT4_FS_XATTR=y
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
# CONFIG_EXT4_DEBUG is not set
CONFIG_JBD=m
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=m
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=m
CONFIG_REISERFS_FS=m
# CONFIG_REISERFS_CHECK is not set
# CONFIG_REISERFS_PROC_INFO is not set
CONFIG_REISERFS_FS_XATTR=y
CONFIG_REISERFS_FS_POSIX_ACL=y
CONFIG_REISERFS_FS_SECURITY=y
CONFIG_JFS_FS=m
CONFIG_JFS_POSIX_ACL=y
CONFIG_JFS_SECURITY=y
# CONFIG_JFS_DEBUG is not set
# CONFIG_JFS_STATISTICS is not set
CONFIG_XFS_FS=m
# CONFIG_XFS_QUOTA is not set
CONFIG_XFS_POSIX_ACL=y
CONFIG_XFS_RT=y
# CONFIG_XFS_DEBUG is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
# CONFIG_BTRFS_FS is not set
# CONFIG_NILFS2_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
# CONFIG_QUOTA is not set
# CONFIG_QUOTACTL is not set
CONFIG_AUTOFS4_FS=m
CONFIG_FUSE_FS=m
CONFIG_CUSE=m
CONFIG_GENERIC_ACL=y

#
# Caches
#
CONFIG_FSCACHE=m
CONFIG_FSCACHE_STATS=y
# CONFIG_FSCACHE_HISTOGRAM is not set
# CONFIG_FSCACHE_DEBUG is not set
# CONFIG_FSCACHE_OBJECT_LIST is not set
CONFIG_CACHEFILES=m
# CONFIG_CACHEFILES_DEBUG is not set
# CONFIG_CACHEFILES_HISTOGRAM is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=m
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=m
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=m
CONFIG_MSDOS_FS=m
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="utf8"
CONFIG_NTFS_FS=m
# CONFIG_NTFS_DEBUG is not set
CONFIG_NTFS_RW=y

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=m
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_ECRYPT_FS is not set
# CONFIG_HFS_FS is not set
CONFIG_HFSPLUS_FS=m
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_LOGFS is not set
# CONFIG_CRAMFS is not set
# CONFIG_SQUASHFS is not set
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_ROMFS_FS is not set
CONFIG_PSTORE=y
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
# CONFIG_EXOFS_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=m
CONFIG_NFS_V3=y
CONFIG_NFS_V3_ACL=y
CONFIG_NFS_V4=y
# CONFIG_NFS_V4_1 is not set
CONFIG_NFS_FSCACHE=y
# CONFIG_NFS_USE_LEGACY_DNS is not set
CONFIG_NFS_USE_KERNEL_DNS=y
# CONFIG_NFS_USE_NEW_IDMAPPER is not set
# CONFIG_NFSD is not set
CONFIG_LOCKD=m
CONFIG_LOCKD_V4=y
CONFIG_NFS_ACL_SUPPORT=m
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=m
CONFIG_SUNRPC_GSS=m
CONFIG_RPCSEC_GSS_KRB5=m
# CONFIG_CEPH_FS is not set
# CONFIG_CIFS is not set
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
# CONFIG_OSF_PARTITION is not set
# CONFIG_AMIGA_PARTITION is not set
# CONFIG_ATARI_PARTITION is not set
# CONFIG_MAC_PARTITION is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
CONFIG_MINIX_SUBPARTITION=y
CONFIG_SOLARIS_X86_PARTITION=y
CONFIG_UNIXWARE_DISKLABEL=y
CONFIG_LDM_PARTITION=y
# CONFIG_LDM_DEBUG is not set
# CONFIG_SGI_PARTITION is not set
# CONFIG_ULTRIX_PARTITION is not set
# CONFIG_SUN_PARTITION is not set
# CONFIG_KARMA_PARTITION is not set
CONFIG_EFI_PARTITION=y
# CONFIG_SYSV68_PARTITION is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="utf8"
CONFIG_NLS_CODEPAGE_437=m
CONFIG_NLS_CODEPAGE_737=m
CONFIG_NLS_CODEPAGE_775=m
CONFIG_NLS_CODEPAGE_850=m
CONFIG_NLS_CODEPAGE_852=m
CONFIG_NLS_CODEPAGE_855=m
CONFIG_NLS_CODEPAGE_857=m
CONFIG_NLS_CODEPAGE_860=m
CONFIG_NLS_CODEPAGE_861=m
CONFIG_NLS_CODEPAGE_862=m
CONFIG_NLS_CODEPAGE_863=m
CONFIG_NLS_CODEPAGE_864=m
CONFIG_NLS_CODEPAGE_865=m
CONFIG_NLS_CODEPAGE_866=m
CONFIG_NLS_CODEPAGE_869=m
CONFIG_NLS_CODEPAGE_936=m
CONFIG_NLS_CODEPAGE_950=m
CONFIG_NLS_CODEPAGE_932=m
CONFIG_NLS_CODEPAGE_949=m
CONFIG_NLS_CODEPAGE_874=m
CONFIG_NLS_ISO8859_8=m
CONFIG_NLS_CODEPAGE_1250=m
CONFIG_NLS_CODEPAGE_1251=m
CONFIG_NLS_ASCII=m
CONFIG_NLS_ISO8859_1=m
CONFIG_NLS_ISO8859_2=m
CONFIG_NLS_ISO8859_3=m
CONFIG_NLS_ISO8859_4=m
CONFIG_NLS_ISO8859_5=m
CONFIG_NLS_ISO8859_6=m
CONFIG_NLS_ISO8859_7=m
CONFIG_NLS_ISO8859_9=m
CONFIG_NLS_ISO8859_13=m
CONFIG_NLS_ISO8859_14=m
CONFIG_NLS_ISO8859_15=m
CONFIG_NLS_KOI8_R=m
CONFIG_NLS_KOI8_U=m
CONFIG_NLS_UTF8=m
# CONFIG_DLM is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
# CONFIG_PRINTK_TIME is not set
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
CONFIG_MAGIC_SYSRQ=y
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
CONFIG_LOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR=y
# CONFIG_BOOTPARAM_HARDLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=0
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y
CONFIG_DEBUG_OBJECTS=y
# CONFIG_DEBUG_OBJECTS_SELFTEST is not set
# CONFIG_DEBUG_OBJECTS_FREE is not set
# CONFIG_DEBUG_OBJECTS_TIMERS is not set
# CONFIG_DEBUG_OBJECTS_WORK is not set
# CONFIG_DEBUG_OBJECTS_RCU_HEAD is not set
# CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER is not set
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
CONFIG_DEBUG_SLAB=y
CONFIG_DEBUG_SLAB_LEAK=y
CONFIG_DEBUG_KMEMLEAK=y
CONFIG_DEBUG_KMEMLEAK_EARLY_LOG_SIZE=2000
# CONFIG_DEBUG_KMEMLEAK_TEST is not set
# CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF is not set
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_PI_LIST=y
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
# CONFIG_PROVE_LOCKING is not set
# CONFIG_SPARSE_RCU_POINTER is not set
CONFIG_LOCKDEP=y
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_LOCKDEP=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_INFO=y
# CONFIG_DEBUG_INFO_REDUCED is not set
# CONFIG_DEBUG_VM is not set
CONFIG_DEBUG_VIRTUAL=y
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_LIST is not set
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=60
# CONFIG_KPROBES_SANITY_TEST is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
# CONFIG_DEBUG_PER_CPU_MAPS is not set
# CONFIG_LKDTM is not set
# CONFIG_CPU_NOTIFIER_ERROR_INJECT is not set
# CONFIG_FAULT_INJECTION is not set
CONFIG_LATENCYTOP=y
CONFIG_SYSCTL_SYSCALL_CHECK=y
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_RING_BUFFER=y
CONFIG_EVENT_TRACING=y
# CONFIG_EVENT_POWER_TRACING_DEPRECATED is not set
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
# CONFIG_FUNCTION_TRACER is not set
# CONFIG_IRQSOFF_TRACER is not set
# CONFIG_SCHED_TRACER is not set
# CONFIG_FTRACE_SYSCALLS is not set
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_PROFILE_ALL_BRANCHES is not set
# CONFIG_STACK_TRACER is not set
CONFIG_BLK_DEV_IO_TRACE=y
# CONFIG_KPROBE_EVENT is not set
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_MMIOTRACE is not set
# CONFIG_RING_BUFFER_BENCHMARK is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_FIREWIRE_OHCI_REMOTE_DMA is not set
# CONFIG_DYNAMIC_DEBUG is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_KMEMCHECK is not set
# CONFIG_TEST_KSTRTOX is not set
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
CONFIG_DEBUG_STACKOVERFLOW=y
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
# CONFIG_DEBUG_RODATA_TEST is not set
CONFIG_DEBUG_SET_MODULE_RONX=y
# CONFIG_DEBUG_NX_TEST is not set
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
# CONFIG_X86_DECODER_SELFTEST is not set
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
CONFIG_IO_DELAY_NONE=y
CONFIG_DEFAULT_IO_DELAY_TYPE=3
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
CONFIG_OPTIMIZE_INLINING=y
CONFIG_DEBUG_STRICT_USER_COPY_CHECKS=y

#
# Security options
#
CONFIG_KEYS=y
CONFIG_KEYS_DEBUG_PROC_KEYS=y
# CONFIG_SECURITY_DMESG_RESTRICT is not set
# CONFIG_SECURITY is not set
# CONFIG_SECURITYFS is not set
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_ASYNC_TX_DISABLE_PQ_VAL_DMA=y
CONFIG_ASYNC_TX_DISABLE_XOR_VAL_DMA=y
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
# CONFIG_CRYPTO_FIPS is not set
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=m
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=m
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=m
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP=m
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
CONFIG_CRYPTO_GF128MUL=m
CONFIG_CRYPTO_NULL=m
# CONFIG_CRYPTO_PCRYPT is not set
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=m
CONFIG_CRYPTO_AUTHENC=m
# CONFIG_CRYPTO_TEST is not set

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=m
CONFIG_CRYPTO_GCM=m
CONFIG_CRYPTO_SEQIV=m

#
# Block modes
#
CONFIG_CRYPTO_CBC=m
CONFIG_CRYPTO_CTR=m
CONFIG_CRYPTO_CTS=m
CONFIG_CRYPTO_ECB=m
# CONFIG_CRYPTO_LRW is not set
CONFIG_CRYPTO_PCBC=m
# CONFIG_CRYPTO_XTS is not set

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=m
# CONFIG_CRYPTO_XCBC is not set
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=m
CONFIG_CRYPTO_CRC32C_INTEL=m
CONFIG_CRYPTO_GHASH=m
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=m
CONFIG_CRYPTO_RMD128=m
CONFIG_CRYPTO_RMD160=m
CONFIG_CRYPTO_RMD256=m
CONFIG_CRYPTO_RMD320=m
CONFIG_CRYPTO_SHA1=m
CONFIG_CRYPTO_SHA256=m
CONFIG_CRYPTO_SHA512=m
CONFIG_CRYPTO_TGR192=m
CONFIG_CRYPTO_WP512=m
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=m

#
# Ciphers
#
CONFIG_CRYPTO_AES=m
CONFIG_CRYPTO_AES_X86_64=m
# CONFIG_CRYPTO_AES_NI_INTEL is not set
CONFIG_CRYPTO_ANUBIS=m
CONFIG_CRYPTO_ARC4=m
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_CAMELLIA=m
CONFIG_CRYPTO_CAST5=m
CONFIG_CRYPTO_CAST6=m
CONFIG_CRYPTO_DES=m
CONFIG_CRYPTO_FCRYPT=m
CONFIG_CRYPTO_KHAZAD=m
# CONFIG_CRYPTO_SALSA20 is not set
# CONFIG_CRYPTO_SALSA20_X86_64 is not set
CONFIG_CRYPTO_SEED=m
CONFIG_CRYPTO_SERPENT=m
CONFIG_CRYPTO_TEA=m
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=m
CONFIG_CRYPTO_TWOFISH_X86_64=m

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=m
CONFIG_CRYPTO_ZLIB=m
CONFIG_CRYPTO_LZO=m

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=m
CONFIG_CRYPTO_USER_API=m
CONFIG_CRYPTO_USER_API_HASH=m
CONFIG_CRYPTO_USER_API_SKCIPHER=m
# CONFIG_CRYPTO_HW is not set
CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_HAVE_KVM_EVENTFD=y
CONFIG_KVM_APIC_ARCHITECTURE=y
CONFIG_KVM_MMIO=y
CONFIG_KVM_ASYNC_PF=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=m
CONFIG_KVM_INTEL=m
# CONFIG_KVM_AMD is not set
# CONFIG_KVM_MMU_AUDIT is not set
# CONFIG_VHOST_NET is not set
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_CRC_CCITT=m
CONFIG_CRC16=m
CONFIG_CRC_T10DIF=m
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
CONFIG_CRC7=m
# CONFIG_LIBCRC32C is not set
# CONFIG_CRC8 is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=m
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
CONFIG_XZ_DEC_IA64=y
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=m
CONFIG_TEXTSEARCH_BM=m
CONFIG_TEXTSEARCH_FSM=m
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_CPU_RMAP=y
CONFIG_NLATTR=y
CONFIG_AVERAGE=y
# CONFIG_CORDIC is not set

--------------090207080602010705060606
Content-Type: text/plain;
 name="lsusb-isight"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="lsusb-isight"


Bus 002 Device 003: ID 05ac:8501 Apple, Inc. Built-in iSight [Micron]
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass          239 Miscellaneous Device
  bDeviceSubClass         2 ?
  bDeviceProtocol         1 Interface Association
  bMaxPacketSize0        64
  idVendor           0x05ac Apple, Inc.
  idProduct          0x8501 Built-in iSight [Micron]
  bcdDevice            1.84
  iManufacturer           1 Micron
  iProduct                2 Built-in iSight
  iSerial                 0 
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength          267
    bNumInterfaces          2
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0x80
      (Bus Powered)
    MaxPower              100mA
    Interface Association:
      bLength                 8
      bDescriptorType        11
      bFirstInterface         0
      bInterfaceCount         2
      bFunctionClass         14 Video
      bFunctionSubClass       3 Video Interface Collection
      bFunctionProtocol       0 
      iFunction               0 
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass        14 Video
      bInterfaceSubClass      1 Video Control
      bInterfaceProtocol      0 
      iInterface              0 
      VideoControl Interface Descriptor:
        bLength                13
        bDescriptorType        36
        bDescriptorSubtype      1 (HEADER)
        bcdUVC               1.00
        wTotalLength           49
        dwClockFrequency       13.500000MHz
        bInCollection           1
        baInterfaceNr( 0)       1
      VideoControl Interface Descriptor:
        bLength                16
        bDescriptorType        36
        bDescriptorSubtype      2 (INPUT_TERMINAL)
        bTerminalID             1
        wTerminalType      0x0201 Camera Sensor
        bAssocTerminal          0
        iTerminal               0 
        wObjectiveFocalLengthMin      0
        wObjectiveFocalLengthMax      0
        wOcularFocalLength            0
        bControlSize                  1
        bmControls           0x00000000
      VideoControl Interface Descriptor:
        bLength                11
        bDescriptorType        36
        bDescriptorSubtype      5 (PROCESSING_UNIT)
      Warning: Descriptor too short
        bUnitID                 2
        bSourceID               1
        wMaxMultiplier          0
        bControlSize            2
        bmControls     0x00000039
          Brightness
          Saturation
          Sharpness
          Gamma
        iProcessing             0 
        bmVideoStandards     0x 9
          None
          SECAM - 625/50
      VideoControl Interface Descriptor:
        bLength                 9
        bDescriptorType        36
        bDescriptorSubtype      3 (OUTPUT_TERMINAL)
        bTerminalID             3
        wTerminalType      0x0101 USB Streaming
        bAssocTerminal          0
        bSourceID               2
        iTerminal               0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0008  1x 8 bytes
        bInterval              10
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       0
      bNumEndpoints           0
      bInterfaceClass        14 Video
      bInterfaceSubClass      2 Video Streaming
      bInterfaceProtocol      0 
      iInterface              0 
      VideoStreaming Interface Descriptor:
        bLength                            14
        bDescriptorType                    36
        bDescriptorSubtype                  1 (INPUT_HEADER)
        bNumFormats                         1
        wTotalLength                      155
        bEndPointAddress                  130
        bmInfo                              0
        bTerminalLink                       3
        bStillCaptureMethod                 0
        bTriggerSupport                     0
        bTriggerUsage                       0
        bControlSize                        1
        bmaControls( 0)                    27
      VideoStreaming Interface Descriptor:
        bLength                            27
        bDescriptorType                    36
        bDescriptorSubtype                  4 (FORMAT_UNCOMPRESSED)
        bFormatIndex                        1
        bNumFrameDescriptors                3
        guidFormat                            {55595659-0000-1000-8000-00aa00389b71}
        bBitsPerPixel                      16
        bDefaultFrameIndex                  1
        bAspectRatioX                       0
        bAspectRatioY                       0
        bmInterlaceFlags                 0x00
          Interlaced stream or variable: No
          Fields per frame: 2 fields
          Field 1 first: No
          Field pattern: Field 1 only
          bCopyProtect                      0
      VideoStreaming Interface Descriptor:
        bLength                            38
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                         1
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                            640
        wHeight                           480
        dwMinBitRate                383976960
        dwMaxBitRate                383976960
        dwMaxVideoFrameBufferSize      614400
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  0
        dwMinFrameInterval             333333
        dwMaxFrameInterval             333333
        dwFrameIntervalStep                 0
      VideoStreaming Interface Descriptor:
        bLength                            38
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                         2
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                            352
        wHeight                           288
        dwMinBitRate                383976960
        dwMaxBitRate                383976960
        dwMaxVideoFrameBufferSize      202752
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  0
        dwMinFrameInterval             333333
        dwMaxFrameInterval             333333
        dwFrameIntervalStep                 0
      VideoStreaming Interface Descriptor:
        bLength                            38
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                         3
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                            320
        wHeight                           240
        dwMinBitRate                383976960
        dwMaxBitRate                383976960
        dwMaxVideoFrameBufferSize      153600
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  0
        dwMinFrameInterval             333333
        dwMaxFrameInterval             333333
        dwFrameIntervalStep                 0
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       1
      bNumEndpoints           1
      bInterfaceClass        14 Video
      bInterfaceSubClass      2 Video Streaming
      bInterfaceProtocol      0 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x1400  3x 1024 bytes
        bInterval               1
Device Qualifier (for other device speed):
  bLength                10
  bDescriptorType         6
  bcdUSB               2.00
  bDeviceClass           14 Video
  bDeviceSubClass         2 Video Streaming
  bDeviceProtocol         0 
  bMaxPacketSize0         8
  bNumConfigurations      1
Device Status:     0x0000
  (Bus Powered)

--------------090207080602010705060606--
