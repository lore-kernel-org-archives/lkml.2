Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932111Ab1EXRZA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 13:25:00 -0400
Received: from higgs.elka.pw.edu.pl ([194.29.160.5]:55563 "EHLO
	higgs.elka.pw.edu.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753185Ab1EXRY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 13:24:59 -0400
X-Comment: RFC 2476 MSA function at elektron.elka.pw.edu.pl logged sender identity as: wzabolot
Message-ID: <4DDBE9DC.5040607@ise.pw.edu.pl>
Date: Tue, 24 May 2011 19:24:44 +0200
From: wzab <wzab@ise.pw.edu.pl>
Reply-To: wzab@ise.pw.edu.pl
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.15) Gecko/20110402 Icedove/3.1.9
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: "Zabolotny, Wojciech" <wzab@ise.pw.edu.pl>
Subject: Kernel panic when booting 2.6.39
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When I'm booting one of my machines with the newest 2.6.39 kernel, I 
usually get the kernel panic. the system freezes completely, so that 
even panic messages are not logged.
I've managed to record them using serial console.


udevd[1022]: SYSFS{}= will be removed in a future udev version, please 
use ATTR{}= to match the event devicpci_hotplug: PCI Hot Plug PCI Core 
version: 0.5
e, or ATTRS{}= t------------[ cut here ]------------
------------[ cut here ]------------
BUG: unable to handle kernel NULL pointer dereference at 0000002b
IP: [<c05db4a0>] 0xc05db49f
*pde = 00000000
Oops: 0002 [#1] PREEMPT SMP
last sysfs file: /sys/devices/virtual/tty/ptyua/uevent
Modules linked in: processor(+) usbcore(+) pci_hotplug(+) unix

Pid: 1050, comm: modprobe Not tainted 2.6.39 #2 
/D865GBF
EIP: 0000:[<c05db4a0>] EFLAGS: 00000001 CPU: 0
EIP is at 0xc05db4a0
EAX: c02e0568 EBX: c02e0550 ECX: c0267066 EDX: c02e04f9
ESI: c05db4a0 EDI: 0000002d EBP: 00000025 ESP: f6253c50
  DS: da92 ES: 0001 FS: ccdb GS: 0033 SS: 0068
Process modprobe (pid: 1050, ti=f6252000 task=f58cf4e0 task.ti=f5a40000)
Stack:
  c02e0b89 c02e0550 00000046 c05db4a0 00000007 c05bda92 00000025 c052fbe0
  00005d92 00000025 c053cfd4 c013509e 00005d92 00005ddf 00005db7 00001db6
  c0135215 00000096 ffffc000 0000002b 00000003 c05bfde8 00000000 c013559b
Call Trace:
  [<c02e0b89>] ? serial8250_console_write+0xa9/0x150
  [<c02e0550>] ? wait_for_xmitr+0x80/0x80
  [<c013509e>] ? __call_console_drivers+0x6e/0x80
  [<c0135215>] ? console_unlock+0xd5/0x1b0
  [<c013559b>] ? vprintk+0x19b/0x3f0
  [<c04121e9>] ? _raw_spin_lock_irqsave+0x19/0x40
  [<c013097f>] ? sub_preempt_count+0x6f/0xa0
  [<c0265d85>] ? number.clone.1+0x335/0x350
  [<c0121a30>] ? vmalloc_sync_all+0xf0/0xf0
  [<c040f9c1>] ? printk+0x17/0x1e
  [<c0134c2f>] ? warn_slowpath_common+0x2f/0xb0
  [<c0121a30>] ? vmalloc_sync_all+0xf0/0xf0
  [<c0411f4c>] ? _raw_spin_unlock+0xc/0x30
  [<c0134ccb>] ? warn_slowpath_null+0x1b/0x20
  [<c0411f4c>] ? _raw_spin_unlock+0xc/0x30
  [<c03012f6>] ? get_device_parent.clone.12+0x106/0x160
  [<c01a4013>] ? kmem_cache_alloc+0x83/0x90
  [<c030181a>] ? device_add+0x8a/0x5b0
  [<c0125af0>] ? complete_all+0x40/0x60
  [<c01308f8>] ? get_parent_ip+0x8/0x20
  [<c013097f>] ? sub_preempt_count+0x6f/0xa0
  [<c0411f1e>] ? _raw_spin_unlock_irqrestore+0xe/0x30
  [<c035e218>] ? thermal_cooling_device_register+0xc8/0x220
  [<f82f2082>] ? acpi_processor_add+0x3b6/0x442 [processor]
  [<c0299e6f>] ? acpi_device_probe+0x34/0xe7
  [<c0303ba5>] ? driver_probe_device+0x65/0x160
  [<c029a23f>] ? acpi_match_device_ids+0x27/0x4d
  [<c0303d19>] ? __driver_attach+0x79/0x80
  [<c0303ca0>] ? driver_probe_device+0x160/0x160
  [<c0302f0b>] ? bus_for_each_dev+0x4b/0x70
  [<c0299daf>] ? acpi_device_hid+0x13/0x13
  [<c0303906>] ? driver_attach+0x16/0x20
  [<c0303ca0>] ? driver_probe_device+0x160/0x160
  [<c030356c>] ? bus_add_driver+0x9c/0x230
  [<c0299daf>] ? acpi_device_hid+0x13/0x13
  [<c03041af>] ? driver_register+0x5f/0x100
  [<c040f9c1>] ? printk+0x17/0x1e
  [<f830c05a>] ? acpi_processor_init+0x5a/0xb7 [processor]
  [<c01011f3>] ? do_one_initcall+0x33/0x170
  [<c019d9e8>] ? __vunmap+0xa8/0xe0
  [<f830c000>] ? 0xf830bfff
  [<c0163893>] ? sys_init_module+0x123/0x1960
  [<c0412b90>] ? sysenter_do_call+0x12/0x26
Code: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 <a9> aa 
00 00 f8 03 00 00 00 00 00 00 50 ff 2d c0 60 ff 2d c0 00
EIP: [<c05db4a0>] 0xc05db4a0 SS:ESP 0068:f6253c50
CR2: 000000000000002b
---[ end trace 89983478aa9ce18f ]---
Kernel panic - not syncing: Fatal exception in interrupt
Pid: 1050, comm: modprobe Tainted: G      D     2.6.39 #2
Call Trace:
  [<c040f8cc>] ? panic+0x61/0x13f
  [<c0105c46>] ? oops_end+0x86/0x90
  [<c0121590>] ? no_context+0xc0/0x150
  [<c0121a30>] ? vmalloc_sync_all+0xf0/0xf0
  [<c012176f>] ? bad_area_nosemaphore+0xf/0x20
  [<c0121c86>] ? do_page_fault+0x256/0x3f0
  [<c0411f1e>] ? _raw_spin_unlock_irqrestore+0xe/0x30
  [<c0151cc5>] ? down_trylock+0x25/0x40
  [<c01356eb>] ? vprintk+0x2eb/0x3f0
  [<c01308f8>] ? get_parent_ip+0x8/0x20
  [<c026713f>] ? delay_tsc+0x6f/0xa0
  [<c02e0550>] ? wait_for_xmitr+0x80/0x80
  [<c0267066>] ? __delay+0x6/0x10
  [<c02e04ef>] ? wait_for_xmitr+0x1f/0x80
  [<c02e0568>] ? serial8250_console_putchar+0x18/0x30
  [<c02dccdb>] ? uart_console_write+0x2b/0x60
  [<c02e0b89>] ? serial8250_console_write+0xa9/0x150
  [<c02e0550>] ? wait_for_xmitr+0x80/0x80
  [<c013509e>] ? __call_console_drivers+0x6e/0x80
  [<c0135215>] ? console_unlock+0xd5/0x1b0
  [<c013559b>] ? vprintk+0x19b/0x3f0
  [<c04121e9>] ? _raw_spin_lock_irqsave+0x19/0x40
  [<c013097f>] ? sub_preempt_count+0x6f/0xa0
  [<c0265d85>] ? number.clone.1+0x335/0x350
  [<c0121a30>] ? vmalloc_sync_all+0xf0/0xf0
  [<c040f9c1>] ? printk+0x17/0x1e
  [<c0134c2f>] ? warn_slowpath_common+0x2f/0xb0
  [<c0121a30>] ? vmalloc_sync_all+0xf0/0xf0
  [<c0411f4c>] ? _raw_spin_unlock+0xc/0x30
  [<c0134ccb>] ? warn_slowpath_null+0x1b/0x20
  [<c0411f4c>] ? _raw_spin_unlock+0xc/0x30
  [<c03012f6>] ? get_device_parent.clone.12+0x106/0x160
  [<c01a4013>] ? kmem_cache_alloc+0x83/0x90
  [<c030181a>] ? device_add+0x8a/0x5b0
  [<c0125af0>] ? complete_all+0x40/0x60
  [<c01308f8>] ? get_parent_ip+0x8/0x20
  [<c013097f>] ? sub_preempt_count+0x6f/0xa0
  [<c0411f1e>] ? _raw_spin_unlock_irqrestore+0xe/0x30
  [<c035e218>] ? thermal_cooling_device_register+0xc8/0x220
  [<f82f2082>] ? acpi_processor_add+0x3b6/0x442 [processor]
  [<c0299e6f>] ? acpi_device_probe+0x34/0xe7
  [<c0303ba5>] ? driver_probe_device+0x65/0x160
  [<c029a23f>] ? acpi_match_device_ids+0x27/0x4d
  [<c0303d19>] ? __driver_attach+0x79/0x80
  [<c0303ca0>] ? driver_probe_device+0x160/0x160
  [<c0302f0b>] ? bus_for_each_dev+0x4b/0x70
  [<c0299daf>] ? acpi_device_hid+0x13/0x13
  [<c0303906>] ? driver_attach+0x16/0x20
  [<c0303ca0>] ? driver_probe_device+0x160/0x160
  [<c030356c>] ? bus_add_driver+0x9c/0x230
  [<c0299daf>] ? acpi_device_hid+0x13/0x13
  [<c03041af>] ? driver_register+0x5f/0x100
  [<c040f9c1>] ? printk+0x17/0x1e
  [<f830c05a>] ? acpi_processor_init+0x5a/0xb7 [processor]
  [<c01011f3>] ? do_one_initcall+0x33/0x170
  [<c019d9e8>] ? __vunmap+0xa8/0xe0
  [<f830c000>] ? 0xf830bfff
  [<c0163893>] ? sys_init_module+0x123/0x1960
  [<c0412b90>] ? sysenter_do_call+0x12/0x26
