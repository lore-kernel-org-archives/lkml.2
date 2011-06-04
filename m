Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526Ab1FDUFC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jun 2011 16:05:02 -0400
Received: from higgs.elka.pw.edu.pl ([194.29.160.5]:44132 "EHLO
	higgs.elka.pw.edu.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240Ab1FDUE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jun 2011 16:04:58 -0400
X-Comment: RFC 2476 MSA function at elektron.elka.pw.edu.pl logged sender identity as: wzabolot
Message-ID: <4DEA8FDD.1060905@elektron.elka.pw.edu.pl>
Date: Sat, 04 Jun 2011 22:04:45 +0200
From: "wzabolot@elektron.elka.pw.edu.pl" <W.Zabolotny@elka.pw.edu.pl>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110516 Icedove/3.1.10
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Random kernel panics when booting 2.6.39.1
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

When booting my machine:
processor	: 0
vendor_id	: GenuineIntel
cpu family	: 15
model		: 2
model name	: Intel(R) Pentium(R) 4 CPU 2.80GHz
stepping	: 9
cpu MHz		: 2793.178
cache size	: 512 KB

Output of lspci:
00:00.0 Host bridge: Intel Corporation 82865G/PE/P DRAM 
Controller/Host-Hub Interface (rev 02)
00:02.0 VGA compatible controller: Intel Corporation 82865G Integrated 
Graphics Controller (rev 02)
00:03.0 PCI bridge: Intel Corporation 82865G/PE/P PCI to CSA Bridge (rev 02)
00:06.0 System peripheral: Intel Corporation 82865G/PE/P Processor to 
I/O Memory Interface (rev 02)
00:1d.0 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB 
UHCI Controller #1 (rev 02)
00:1d.1 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB 
UHCI Controller #2 (rev 02)
00:1d.2 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB 
UHCI Controller #3 (rev 02)
00:1d.3 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB 
UHCI Controller #4 (rev 02)
00:1d.7 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB2 
EHCI Controller (rev 02)
00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev c2)
00:1f.0 ISA bridge: Intel Corporation 82801EB/ER (ICH5/ICH5R) LPC 
Interface Bridge (rev 02)
00:1f.1 IDE interface: Intel Corporation 82801EB/ER (ICH5/ICH5R) IDE 
Controller (rev 02)
00:1f.2 IDE interface: Intel Corporation 82801EB (ICH5) SATA Controller 
(rev 02)
00:1f.3 SMBus: Intel Corporation 82801EB/ER (ICH5/ICH5R) SMBus 
Controller (rev 02)
00:1f.5 Multimedia audio controller: Intel Corporation 82801EB/ER 
(ICH5/ICH5R) AC'97 Audio Controller (rev 02)
01:01.0 Ethernet controller: Intel Corporation 82547EI Gigabit Ethernet 
Controller
02:00.0 Multimedia video controller: Brooktree Corporation Bt878 Video 
Capture (rev 11)
02:00.1 Multimedia controller: Brooktree Corporation Bt878 Audio Capture 
(rev 11)
02:03.0 Communication controller: NetMos Technology PCI 9835 Multi-I/O 
Controller (rev 01)
02:04.0 Ethernet controller: Realtek Semiconductor Co., Ltd. 
RTL-8139/8139C/8139C+ (rev 10)
02:05.0 Ethernet controller: Realtek Semiconductor Co., Ltd. 
RTL-8139/8139C/8139C+ (rev 10)

with the newest 2.6.39.1 kernel, I experience random kernel panics.
I was able to record the following messages using the serial console
(however the message after kernel panic itself probably was not sent,
as interrupts were blocked ?)
The machine works stable with 2.6.37.3 kernel.


Below are logs from four starts of the system:
====================== First booting =================================
udevd[1023]: SYSFS{}= will be removed in a future udev version, please 
use ATTR{}= to match the event device, or ATTRS{}= to match a parent 
device, in /etc/udev/rules.d/zydas_qemu.rules:3

i801_smbus 0000:00:1f.3: PCI INT B -> GSI 17 (level, low) -> IRQ 17
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
Floppy drive(s):
BUG: unable to handle kernel paging request at 2c0000a2
IP: [<c05bbcf4>] 0xc05bbcf3
*pde = 00000000
Oops: 0000 [#1] PREEMPT SMP
last sysfs file: /sys/devices/virtual/tty/ttyb9/uevent
Modules linked in: processor(+) 8250_pci floppy(+) 8250_pnp(+) parport 
snd shpchp i2c_i801 soundcore pci_hotplug snd_page_alloc unix

Pid: 1074, comm: modprobe Not tainted 2.6.39.1 #1 
/D865GBF
EIP: 0060:[<c05bbcf4>] EFLAGS: 00010086 CPU: 1
EIP is at 0xc05bbcf4
EAX: 0000001b EBX: 00000400 ECX: 00000000 EDX: c049db50
ESI: c0134bc5 EDI: c05bfdc0 EBP: 0000000f ESP: f5b19be0
  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process modprobe (pid: 1074, ti=f5b18000 task=f5a0ae00 task.ti=f5b18000)
Stack:
  c04124bd 00000000 c0135450 f5b19c74 00000000 13a677f7 c025007d 00000000
  f6605f80 e13bb98c c0108ac6 00000000 00000293 00000001 f5b19c6cNULL 
pointer dereference
invalid opcode: 0000 [#2] PREEMPT SMP
last sysfs file: /sys/devices/virtual/tty/ttyb9/uevent
Modules linked in: processor(+) 8250_pci floppy(+) 8250_pnp(+) parport 
snd shpchp i2c_i801 soundcore pci_hotplug snd_page_alloc unix

Pid: 1074, comm: modprobe Not tainted 2.6.39.1 #1 
/D865GBF
EIP: 0060:[<f6405f80>] EFLAGS: 00010086 CPU: 1
EIP is at 0xf6405f80
EAX: 0000000c EBX: 00000000 ECX: 00000001 EDX: 00010002
ESI: f5b19ba4 EDI: 0000000f EBP: f5b19c1f ESP: f5b19a7c
  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process modprobe (pid: 1074, ti=f5b18000 task=f5a0ae00 task.ti=f5b18000)
Stack:
  f8cff8b0 c0108ac6 f6405f80 f6405f80 00000000 f5b19ae4 c0152bd3 1627fbeb
  00000002 1627f839 00000002 00000002 8a130af4 00000000 048def99 00000000
  00000086 00000000 00000002 c0416d80 f6405f80 00000082 f8d02e30 0000001b
Call Trace:
  [<c0108ac6>] ? native_sched_clock+0x26/0x90
  [<c0152bd3>] ? sched_clock_local+0xd3/0x1c0
  [<c0155e3a>] ? ktime_get+0x6a/0x120
  [<c011a243>] ? lapic_next_event+0x13/0x20
  [<c015ae87>] ? clockevents_program_event+0x87/0x120
  [<c015bf86>] ? tick_dev_program_event+0x46/0x150
  [<c015c0a9>] ? tick_program_event+0x19/0x20
  [<c0151155>] ? hrtimer_interrupt+0x155/0x280
  [<c0104536>] ? do_IRQ+0x46/0xb0
  [<c011a7c2>] ? smp_apic_timer_interrupt+0x52/0x90
  [<c0413329>] ? common_interrupt+0x29/0x30
  [<c041007b>] ? schedule+0x17b/0x8a0
  [<c01500d8>] ? hrtimer_forward+0x68/0x2c0
  [<c04124bd>] ? _raw_spin_lock+0xd/0x30
  [<c0135450>] ? vprintk+0x50/0x3f0
  [<c025007d>] ?
  [<c025007d>] ?
generic_make_request+0x19d/0x390

======== Second booting =============================

udevd[1023]: segfault at dac81 ip 00005681 sp f82f0724 error 4
BUG: unable to handle kernel paging request at 00010296
IP: [<00010296>] 0x10295
*pde = 00000000
Oops: 0000 [#1] PREEMPT SMP
last sysfs file: /sys/module/intel_agp/initstate
Modules linked in: floppy(+) processor(+) intel_agp(+) pcspkr intel_gtt 
pci_hotplug ehci_hcd(+) evdev i2c_i801 8250_pnp usbcore unix

Pid: 1070, comm: modprobe Not tainted 2.6.39.1 #1 
/D865GBF
EIP: 0060:[<00010296>] EFLAGS: 00010296 CPU: 1
EIP is at 0x10296
EAX: f5591be1 EBX: c0121a30 ECX: ffffffff EDX: 0000ffeb
ESI: ffffffff EDI: c0266a97 EBP: 00000060 ESP: f5b05d74
  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process modprobe (pid: 1070, ti=f5b04000 task=f5966040 task.ti=f5b04000)
Stack:
  f6178400 ffffffff ffffff02 f61aa30a 0000fffe c05d0010 f5591bd7 f5591bc0
  00000017 ff0a0210 ffffffff f5591bc0 f5b05de4 c04c2db2 00000017 c0269ae5
  f5b05df4 f61aa3a0 00000000 f83ec3d6 f61aa398 c02608f2 f61aa380 f83ecfd4
Call Trace:
  [<c0269ae5>] ? kvasprintf+0x45/0x60
  [<c02608f2>] ? kobject_set_name_vargs+0x32/0x70
  [<c0300d74>] ? dev_set_name+0x14/0x20
  [<c035e3c1>] ? thermal_cooling_device_register+0xc1/0x220
  [<f83ec082>] ? acpi_processor_add+0x3b6/0x442 [processor]
  [<c0299fef>] ? acpi_device_probe+0x34/0xe7
  [<c0303d25>] ? driver_probe_device+0x65/0x160
  [<c029a3bf>] ? acpi_match_device_ids+0x27/0x4d
  [<c0303e99>] ? __driver_attach+0x79/0x80
  [<c0303e20>] ? driver_probe_device+0x160/0x160
  [<c030308b>] ? bus_for_each_dev+0x4b/0x70
  [<c0299f2f>] ? acpi_device_hid+0x13/0x13
  [<c0303a86>] ? driver_attach+0x16/0x20
  [<c0303e20>] ? driver_probe_device+0x160/0x160
  [<c03036ec>] ? bus_add_driver+0x9c/0x230
  [<c0299f2f>] ? acpi_device_hid+0x13/0x13
  [<c030432f>] ? driver_register+0x5f/0x100
  [<c040fc67>] ? printk+0x17/0x20
  [<f841305a>] ? acpi_processor_init+0x5a/0xb7 [processor]
  [<c01011f3>] ? do_one_initcall+0x33/0x170
  [<c019da08>] ? __vunmap+0xa8/0xe0
  [<f8413000>] ? 0xf8412fff
  [<c0163843>] ? sys_init_module+0x123/0x1960
  [<c0412e10>] ? sysenter_do_call+0x12/0x26
Code:  Bad EIP value.
EIP: [<00010296>] 0x10296 SS:ESP 0068:f5b05d74
CR2: 0000000000010296
---[ end trace a8bea5a64b02f72c ]---
note: modprobe[1070] exited with preempt_count 2

======= Third booting ==============================

pci_hotplug: PCI Hot Plug PCI Core version: 0.5
input: PC Speaker as /devices/platform/pcspkr/input/input3
i801_smbus 0000:00:1f.3: PCI INT B -> GSI 17 (level, low) -> IRQ 17
general protection fault: 0000 [#1] PREEMPT SMP
last sysfs file: /sys/devices/virtual/tty/ptyy3/uevent
Modules linked in: processor(+) i2c_i801 pcspkr evdev pci_hotplug 
soundcore snd_page_alloc unix

Pid: 1076, comm: modprobe Not tainted 2.6.39.1 #1 
/D865GBF
EIP: 00d8:[<c052007b>] EFLAGS: c0102eb0 CPU: 1
EIP is at 0xc052007b
EAX: 00000002 EBX: c014007b ECX: f5aeda58 EDX: c012230d
ESI: c0412b7e EDI: f5aeda58 EBP: 00000000 ESP: f5aed998
  DS: 230d ES: 1a30 FS: 246c GS: 0033 SS: 0068
Process modprobe (pid: 1076, ti=f5aec000 task=f619bbc0 task.ti=f5aec000)
Stack:
  ffffffff f5aeda58 00000060 00010082 c01214ee f5aeda60 c01214ee f60fc0a4
  00000000 f5aeda58 00000009 c0121a30 8314246b c012176f 00030001 c0121c86
  00030001 c0121c86 f59054c8 f592c5c8 00000086 00000002 f5913b80 f5aeda58
Call Trace:
  [<c01214ee>] ? no_context+0x1e/0x150
  [<c01214ee>] ? no_context+0x1e/0x150
  [<c0121a30>] ? vmalloc_sync_all+0xf0/0xf0
  [<c012176f>] ? bad_area_nosemaphore+0xf/0x20
  [<c0121c86>] ? do_page_fault+0x256/0x3f0
  [<c0121c86>] ? do_page_fault+0x256/0x3f0
  [<c021bbc5>] ? search_for_position_by_key+0x115/0x2c0
  [<c014007b>] ? alloc_uid+0x5b/0x100
  [<c0121a30>] ? vmalloc_sync_all+0xf0/0xf0
  [<c014007b>] ? alloc_uid+0x5b/0x100
  [<c0412b7e>] ? error_code+0x5a/0x60
  [<c014007b>] ? alloc_uid+0x5b/0x100
  [<c014007b>] ? alloc_uid+0x5b/0x100
  [<c01300d8>] ? thread_group_sched_runtime+0x58/0xe0
  [<c0121a30>] ? vmalloc_sync_all+0xf0/0xf0
  [<c014007b>] ? alloc_uid+0x5b/0x100
  [<c012230d>] ? fixup_exception+0x1d/0x90
  [<c0165662>] ? search_module_extables+0x12/0xa0
  [<c01214ee>] ? no_context+0x1e/0x150
  [<c012230d>] ? fixup_exception+0x1d/0x90
  [<c01217bb>] ? bad_area+0x3b/0x50
  [<c0121a30>] ? vmalloc_sync_all+0xf0/0xf0
  [<c0121d50>] ? do_page_fault+0x320/0x3f0
  [<c01217bb>] ? bad_area+0x3b/0x50
  [<c0121a30>] ? vmalloc_sync_all+0xf0/0xf0
  [<c01308f8>] ? get_parent_ip+0x8/0x20
  [<c013097f>] ? sub_preempt_count+0x6f/0xa0
  [<c0108ac6>] ? native_sched_clock+0x26/0x90
  [<c0152bd3>] ? sched_clock_local+0xd3/0x1c0
  [<c02a007b>] ? acpi_ds_store_object_to_local+0x6a/0x12f
  [<c0121a30>] ? vmalloc_sync_all+0xf0/0xf0
  [<c0412b7e>] ? error_code+0x5a/0x60
  [<c02a007b>] ? acpi_ds_store_object_to_local+0x6a/0x12f
  [<c02ac7c8>] ? acpi_ns_lookup+0xc8/0x2f9
  [<c0121a30>] ? vmalloc_sync_all+0xf0/0xf0
  [<c014007b>] ? alloc_uid+0x5b/0x100
  [<c0121a30>] ? vmalloc_sync_all+0xf0/0xf0
  [<c0196571>] ? find_vma+0x31/0x70
  [<c0121af3>] ? do_page_fault+0xc3/0x3f0
  [<c01217bb>] ? bad_area+0x3b/0x50
  [<c0121a30>] ? vmalloc_sync_all+0xf0/0xf0
  [<c0121d50>] ? do_page_fault+0x320/0x3f0
  [<c041218d>] ? _raw_spin_unlock_irq+0xd/0x30
  [<c0128e51>] ? finish_task_switch+0x31/0xb0
  [<c0121a30>] ? vmalloc_sync_all+0xf0/0xf0
  [<c0412b7e>] ? error_code+0x5a/0x60
  [<c0121a30>] ? vmalloc_sync_all+0xf0/0xf0
  [<c012007b>] ? hpet_work+0x1b/0x250
  [<c04100d8>] ? schedule+0x1d8/0x8a0
  [<c0121a30>] ? vmalloc_sync_all+0xf0/0xf0
  [<c0121a30>] ? vmalloc_sync_all+0xf0/0xf0
  [<c02ac7c8>] ? acpi_ns_lookup+0xc8/0x2f9
  [<c04121be>] ? _raw_spin_unlock_irqrestore+0xe/0x30
  [<c0151d11>] ? down_timeout+0x31/0x50
  [<c02adee0>] ? acpi_ns_get_node+0x5f/0x83
  [<c0121a30>] ? vmalloc_sync_all+0xf0/0xf0
  [<c0412b7e>] ? error_code+0x5a/0x60
  [<c0121a30>] ? vmalloc_sync_all+0xf0/0xf0
  [<c02b5634>] ? acpi_ut_delete_internal_object_list+0x10/0x20
  [<c02ad319>] ? acpi_evaluate_object+0x1db/0x1f5
  [<f82f9295>] ? acpi_processor_get_power_info+0x4e/0x53f [processor]
  [<c0130a17>] ? add_preempt_count+0x67/0xa0
  [<c04124bd>] ? _raw_spin_lock+0xd/0x30
  [<c013097f>] ? sub_preempt_count+0x6f/0xa0
  [<c04121be>] ? _raw_spin_unlock_irqrestore+0xe/0x30
  [<c0128cd3>] ? set_cpus_allowed_ptr+0x83/0x150
  [<f82f85c7>] ? acpi_processor_get_throttling+0x5d/0x66 [processor]
  [<f82f91c8>] ? acpi_processor_get_throttling_info+0x49c/0x4cc [processor]
  [<f82fb1db>] ? acpi_processor_power_init+0xcd/0x111 [processor]
  [<f82fb071>] ? acpi_processor_add+0x3a5/0x442 [processor]
  [<c0299fef>] ? acpi_device_probe+0x34/0xe7
  [<c0303d25>] ? driver_probe_device+0x65/0x160
  [<c029a3bf>] ? acpi_match_device_ids+0x27/0x4d
  [<c0303e99>] ? __driver_attach+0x79/0x80
  [<c0303e20>] ? driver_probe_device+0x160/0x160
  [<c030308b>] ? bus_for_each_dev+0x4b/0x70
  [<c0299f2f>] ? acpi_device_hid+0x13/0x13
  [<c0303a86>] ? driver_attach+0x16/0x20
  [<c0303e20>] ? driver_probe_device+0x160/0x160
  [<c03036ec>] ? bus_add_driver+0x9c/0x230
  [<c0299f2f>] ? acpi_device_hid+0x13/0x13
  [<c030432f>] ? driver_register+0x5f/0x100
  [<c040fc67>] ? printk+0x17/0x20
  [<f835405a>] ? acpi_processor_init+0x5a/0xb7 [processor]
  [<c01011f3>] ? do_one_initcall+0x33/0x170
  [<c019da08>] ? __vunmap+0xa8/0xe0
  [<f8354000>] ? 0xf8353fff
  [<c0163843>] ? sys_init_module+0x123/0x1960
  [<c0412e10>] ? sysenter_do_call+0x12/0x26
Code: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
EIP: [<c052007b>] 0xc052007b SS:ESP 0068:f5aed998


======= Fourth booting ==============================

BUG: unable to handle kernel paging request at 00010202
IP: [<c0266a19>] vsnprintf+0x49/0x3d0
*pde = 00000000
Oops: 0000 [#2] PREEMPT SMP
last sysfs file: /sys/devices/virtual/tty/ttyad/uevent
Modules linked in: processor(+) intel_gtt parport_pc(+) i2c_i801(+) 
ehci_hcd(+) soundcore parport shpchp floppy pci_hotplug 8250_pnp 
snd_page_alloc evdev usbcore pcspkr unix

Pid: 1083, comm: modprobe Not tainted 2.6.39.1 #1 
/D865GBF
EIP: 0060:[<c0266a19>] EFLAGS: 00010083 CPU: 1
EIP is at vsnprintf+0x49/0x3d0
EAX: b60e1804 EBX: 00000400 ECX: 00010202 EDX: 3fa4023f
ESI: 00010202 EDI: c05bfdc0 EBP: 00000046 ESP: f5b21970
  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process modprobe (pid: 1083, ti=f5b20000 task=f6152040 task.ti=f5b20000)
Stack:
  c012b212 f5b21a24 00000000 c0121380 c014a0d4 f5b21a44 c012230d c05bfdc0
  3fa4023f c01214ee 00000000 00000400 f5b21b0c c05bfdc0 f5b21a44 00000008
  c0121a30 00010202 c012176f 00030001 c0121c86 ffffffff 00000000 00000000
Call Trace:
  [<c012b212>] ? find_busiest_group+0x132/0xc70
  [<c0121380>] ? is_prefetch.clone.22+0x70/0x1c0
  [<c014a0d4>] ? search_exception_tables+0x14/0x30
  [<c012230d>] ? fixup_exception+0x1d/0x90
  [<c01214ee>] ? no_context+0x1e/0x150
  [<c0121a30>] ? vmalloc_sync_all+0xf0/0xf0
  [<c012176f>] ? bad_area_nosemaphore+0xf/0x20
  [<c0121c86>] ? do_page_fault+0x256/0x3f0
  [<c01532e0>] ? release_tgcred.clone.7+0x20/0x20
  [<c0121a30>] ? vmalloc_sync_all+0xf0/0xf0
  [<c0412b7e>] ? error_code+0x5a/0x60
  [<c0121a30>] ? vmalloc_sync_all+0xf0/0xf0
  [<c04135a3>] ? iret_exc+0x1d7/0x98f
  [<c0121392>] ? is_prefetch.clone.22+0x82/0x1c0
  [<c01058fe>] ? oops_begin+0xe/0x90
  [<c0121522>] ? no_context+0x52/0x150
  [<c0121a30>] ? vmalloc_sync_all+0xf0/0xf0
  [<c012176f>] ? bad_area_nosemaphore+0xf/0x20
  [<c0121c86>] ? do_page_fault+0x256/0x3f0
  [<c0412b7e>] ? error_code+0x5a/0x60
  [<c0121a30>] ? vmalloc_sync_all+0xf0/0xf0
  [<c0102eb0>] ? do_bounds+0x80/0x80
  [<c0122313>] ? fixup_exception+0x23/0x90
  [<c0121a30>] ? vmalloc_sync_all+0xf0/0xf0
  [<c0412b7e>] ? error_code+0x5a/0x60
  [<c0122313>] ? fixup_exception+0x23/0x90
  [<c01600d8>] ? rt_mutex_adjust_prio_chain+0x98/0x330
  [<c0121a30>] ? vmalloc_sync_all+0xf0/0xf0
  [<c01214ee>] ? no_context+0x1e/0x150
  [<c0121a30>] ? vmalloc_sync_all+0xf0/0xf0
  [<c012176f>] ? bad_area_nosemaphore+0xf/0x20
  [<c0121c86>] ? do_page_fault+0x256/0x3f0
  [<c0181ebf>] ? __alloc_pages_nodemask+0xff/0x6b0
  [<c0121a30>] ? vmalloc_sync_all+0xf0/0xf0
  [<c0412b7e>] ? error_code+0x5a/0x60
  [<c0121a30>] ? vmalloc_sync_all+0xf0/0xf0
  [<c04135a3>] ? iret_exc+0x1d7/0x98f
  [<c0121651>] ? __bad_area_nosemaphore+0x31/0x140
  [<c02b470f>] ? acpi_ut_valid_acpi_name+0x16/0x2d
  [<c02acd71>] ? acpi_ns_search_and_enter+0x94/0x13f
  [<c01217bb>] ? bad_area+0x3b/0x50
  [<c0121a30>] ? vmalloc_sync_all+0xf0/0xf0
  [<c0412b7e>] ? error_code+0x5a/0x60
  [<c0121a30>] ? vmalloc_sync_all+0xf0/0xf0
  [<c0265de1>] ? number.clone.1+0x211/0x350
  [<c0125e4a>] ? resched_task+0x3a/0x60
  [<c01308f8>] ? get_parent_ip+0x8/0x20
  [<c0121a30>] ? vmalloc_sync_all+0xf0/0xf0
  [<c0412b7e>] ? error_code+0x5a/0x60
  [<c0266a95>] ? vsnprintf+0xc5/0x3d0
  [<c0269ae5>] ? kvasprintf+0x45/0x60
  [<c02608f2>] ? kobject_set_name_vargs+0x32/0x70
  [<c0300d74>] ? dev_set_name+0x14/0x20
  [<c035e3c1>] ? thermal_cooling_device_register+0xc1/0x220
  [<f8419082>] ? acpi_processor_add+0x3b6/0x442 [processor]
  [<c0299fef>] ? acpi_device_probe+0x34/0xe7
  [<c0303d25>] ? driver_probe_device+0x65/0x160
  [<c029a3bf>] ? acpi_match_device_ids+0x27/0x4d
  [<c0303e99>] ? __driver_attach+0x79/0x80
  [<c0303e20>] ? driver_probe_device+0x160/0x160
  [<c030308b>] ? bus_for_each_dev+0x4b/0x70
  [<c0299f2f>] ? acpi_device_hid+0x13/0x13
  [<c0303a86>] ? driver_attach+0x16/0x20
  [<c0303e20>] ? driver_probe_device+0x160/0x160
  [<c03036ec>] ? bus_add_driver+0x9c/0x230
  [<c0299f2f>] ? acpi_device_hid+0x13/0x13
  [<c030432f>] ? driver_register+0x5f/0x100
  [<c040fc67>] ? printk+0x17/0x20
  [<f847a05a>] ? acpi_processor_init+0x5a/0xb7 [processor]
  [<c01011f3>] ? do_one_initcall+0x33/0x170
  [<c019da08>] ? __vunmap+0xa8/0xe0
  [<f847a000>] ? 0xf8479fff
  [<c0163843>] ? sys_init_module+0x123/0x1960
  [<c0412e10>] ? sysenter_do_call+0x12/0x26
Code: 28 00 00 00 00 0f 88 7b 03 00 00 8b 44 24 1c 03 44 24 20 89 44 24 
18 73 12 8b 54 24 1c c7 44 24 18 ff ff ff ff f7 d2 89 54 24 20 <0f> b6 
06 8b 5c 24 1c 84 c0 74 7c 8d 54 24 24 89 f0 e8 f1 eb ff
EIP: [<c0266a19>] vsnprintf+0x49/0x3d0 SS:ESP 0068:f5b21970
CR2: 0000000000010202
---[ end trace 34c5a12794a4228b ]---
note: modprobe[1083] exited with preempt_count 3
BUG: scheduling while atomic: modprobe/1083/0x10000004
Modules linked in: processor(+) intel_gtt parport_pc(+) i2c_i801(+) 
ehci_hcd(+) soundcore parport shpchp floppy pci_hotplug 8250_pnp 
snd_page_alloc evdev usbcore pcspkr unix
Pid: 1083, comm: modprobe Tainted: G      D     2.6.39.1 #1
Call Trace:
  [<c04103f1>] ? schedule+0x4f1/0x8a0
  [<c0152bd3>] ? sched_clock_local+0xd3/0x1c0
  [<c0155e3a>] ? ktime_get+0x6a/0x120
  [<c0130a5f>] ? __cond_resched+0xf/0x20
  [<c0410980>] ? _cond_resched+0x20/0x30
  [<c01938f0>] ? unmap_vmas+0x530/0x6b0
  [<c0198c19>] ? exit_mmap+0xc9/0x180
  [<c0132a7e>] ? mmput+0x1e/0xa0
  [<c013697c>] ? exit_mm+0xec/0x120
  [<c041007b>] ? schedule+0x17b/0x8a0
  [<c01381dd>] ? do_exit+0x53d/0x6d0
  [<c04121be>] ? _raw_spin_unlock_irqrestore+0xe/0x30
  [<c0136388>] ? kmsg_dump+0x58/0xd0
  [<c0105c27>] ? oops_end+0x67/0x90
  [<c040fc67>] ? printk+0x17/0x20
  [<c0121590>] ? no_context+0xc0/0x150
  [<c0121a30>] ? vmalloc_sync_all+0xf0/0xf0
  [<c012176f>] ? bad_area_nosemaphore+0xf/0x20
  [<c0121c86>] ? do_page_fault+0x256/0x3f0
  [<c01532e0>] ? release_tgcred.clone.7+0x20/0x20
  [<c0121a30>] ? vmalloc_sync_all+0xf0/0xf0
  [<c0412b7e>] ? error_code+0x5a/0x60
  [<c0121a30>] ? vmalloc_sync_all+0xf0/0xf0
  [<c0266a19>] ? vsnprintf+0x49/0x3d0
  [<c012b212>] ? find_busiest_group+0x132/0xc70
  [<c0121380>] ? is_prefetch.clone.22+0x70/0x1c0
  [<c014a0d4>] ? search_exception_tables+0x14/0x30
  [<c012230d>] ? fixup_exception+0x1d/0x90
  [<c01214ee>] ? no_context+0x1e/0x150
  [<c0121a30>] ? vmalloc_sync_all+0xf0/0xf0
  [<c012176f>] ? bad_area_nosemaphore+0xf/0x20
  [<c0121c86>] ? do_page_fault+0x256/0x3f0
  [<c01532e0>] ? release_tgcred.clone.7+0x20/0x20
  [<c0121a30>] ? vmalloc_sync_all+0xf0/0xf0
  [<c0412b7e>] ? error_code+0x5a/0x60
  [<c0121a30>] ? vmalloc_sync_all+0xf0/0xf0
  [<c04135a3>] ? iret_exc+0x1d7/0x98f
  [<c0121392>] ? is_prefetch.clone.22+0x82/0x1c0
  [<c01058fe>] ? oops_begin+0xe/0x90
  [<c0121522>] ? no_context+0x52/0x150
  [<c0121a30>] ? vmalloc_sync_all+0xf0/0xf0
  [<c012176f>] ? bad_area_nosemaphore+0xf/0x20
  [<c0121c86>] ? do_page_fault+0x256/0x3f0
  [<c0412b7e>] ? error_code+0x5a/0x60
  [<c0121a30>] ? vmalloc_sync_all+0xf0/0xf0
  [<c0102eb0>] ? do_bounds+0x80/0x80
  [<c0122313>] ? fixup_exception+0x23/0x90
  [<c0121a30>] ? vmalloc_sync_all+0xf0/0xf0
  [<c0412b7e>] ? error_code+0x5a/0x60
  [<c0122313>] ? fixup_exception+0x23/0x90
  [<c01600d8>] ? rt_mutex_adjust_prio_chain+0x98/0x330
  [<c0121a30>] ? vmalloc_sync_all+0xf0/0xf0
  [<c01214ee>] ? no_context+0x1e/0x150
  [<c0121a30>] ? vmalloc_sync_all+0xf0/0xf0
  [<c012176f>] ? bad_area_nosemaphore+0xf/0x20
  [<c0121c86>] ? do_page_fault+0x256/0x3f0
  [<c0181ebf>] ? __alloc_pages_nodemask+0xff/0x6b0
  [<c0121a30>] ? vmalloc_sync_all+0xf0/0xf0
  [<c0412b7e>] ? error_code+0x5a/0x60
  [<c0121a30>] ? vmalloc_sync_all+0xf0/0xf0
  [<c04135a3>] ? iret_exc+0x1d7/0x98f
  [<c0121651>] ? __bad_area_nosemaphore+0x31/0x140
  [<c02b470f>] ? acpi_ut_valid_acpi_name+0x16/0x2d
  [<c02acd71>] ? acpi_ns_search_and_enter+0x94/0x13f
  [<c01217bb>] ? bad_area+0x3b/0x50
  [<c0121a30>] ? vmalloc_sync_all+0xf0/0xf0
  [<c0412b7e>] ? error_code+0x5a/0x60
  [<c0121a30>] ? vmalloc_sync_all+0xf0/0xf0
  [<c0265de1>] ? number.clone.1+0x211/0x350
  [<c0125e4a>] ? resched_task+0x3a/0x60
  [<c01308f8>] ? get_parent_ip+0x8/0x20
  [<c0121a30>] ? vmalloc_sync_all+0xf0/0xf0
  [<c0412b7e>] ? error_code+0x5a/0x60
  [<c0266a95>] ? vsnprintf+0xc5/0x3d0
  [<c0269ae5>] ? kvasprintf+0x45/0x60
  [<c02608f2>] ? kobject_set_name_vargs+0x32/0x70
  [<c0300d74>] ? dev_set_name+0x14/0x20
  [<c035e3c1>] ? thermal_cooling_device_register+0xc1/0x220
  [<f8419082>] ? acpi_processor_add+0x3b6/0x442 [processor]
  [<c0299fef>] ? acpi_device_probe+0x34/0xe7
  [<c0303d25>] ? driver_probe_device+0x65/0x160
  [<c029a3bf>] ? acpi_match_device_ids+0x27/0x4d
  [<c0303e99>] ? __driver_attach+0x79/0x80
  [<c0303e20>] ? driver_probe_device+0x160/0x160
  [<c030308b>] ? bus_for_each_dev+0x4b/0x70
  [<c0299f2f>] ? acpi_device_hid+0x13/0x13
  [<c0303a86>] ? driver_attach+0x16/0x20
  [<c0303e20>] ? driver_probe_device+0x160/0x160
  [<c03036ec>] ? bus_add_driver+0x9c/0x230
  [<c0299f2f>] ? acpi_device_hid+0x13/0x13
  [<c030432f>] ? driver_register+0x5f/0x100
  [<c040fc67>] ? printk+0x17/0x20
  [<f847a05a>] ? acpi_processor_init+0x5a/0xb7 [processor]
  [<c01011f3>] ? do_one_initcall+0x33/0x170
  [<c019da08>] ? __vunmap+0xa8/0xe0
  [<f847a000>] ? 0xf8479fff
  [<c0163843>] ? sys_init_module+0x123/0x1960
  [<c0412e10>] ? sysenter_do_call+0x12/0x26
parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
