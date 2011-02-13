Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379Ab1BMMFD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 07:05:03 -0500
Received: from science.horizon.com ([71.41.210.146]:15508 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754094Ab1BMMEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 07:04:55 -0500
Date: 13 Feb 2011 07:04:52 -0500
Message-ID: <20110213120452.19194.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux-kernel@vger.kernel.org
Subject: Lockup with 2.6.38-rc4
Cc: linux@horizon.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been suffering a number of annoying lockups on my laptop with
2.6.38-rcX, but usually there was nothing to report.   Generally, the
X server would keep moving the mouse, but I couldn't even run dmesg in
a shell and the machine would become completely locked up as I tries to
do things.

ssh login would connect (at the TCP level) but not do anything else.

However, this time the kernel messges made the syslog.  Hopefully
someone can get some ideas.

The machine was idle at the time, with a few xterms and firefox
running.  I rebooted it at 06:45.  (I had to hit the power button;
alt-sysrq-b wasn't working.)

Laptop itself is a Dell, Core 2 Duo, 2 GB RAM, running 32-bit
Debian/unstable userland.  Kernel is stock 2.6.38-rc4, compiled 32-bit with
GCC 4.4.5. The problem didn't happen with 2.6.36, but I didn't run any
.37 kernels.

lspci -nn is:

00:00.0 Host bridge [0600]: Intel Corporation Mobile 945GM/PM/GMS, 943/940GML and 945GT Express Memory Controller Hub [8086:27a0] (rev 03)
00:02.0 VGA compatible controller [0300]: Intel Corporation Mobile 945GM/GMS, 943/940GML Express Integrated Graphics Controller [8086:27a2] (rev 03)
00:02.1 Display controller [0380]: Intel Corporation Mobile 945GM/GMS/GME, 943/940GML Express Integrated Graphics Controller [8086:27a6] (rev 03)
00:1b.0 Audio device [0403]: Intel Corporation N10/ICH 7 Family High Definition Audio Controller [8086:27d8] (rev 01)
00:1c.0 PCI bridge [0604]: Intel Corporation N10/ICH 7 Family PCI Express Port 1 [8086:27d0] (rev 01)
00:1c.1 PCI bridge [0604]: Intel Corporation N10/ICH 7 Family PCI Express Port 2 [8086:27d2] (rev 01)
00:1c.3 PCI bridge [0604]: Intel Corporation N10/ICH 7 Family PCI Express Port 4 [8086:27d6] (rev 01)
00:1d.0 USB Controller [0c03]: Intel Corporation N10/ICH 7 Family USB UHCI Controller #1 [8086:27c8] (rev 01)
00:1d.1 USB Controller [0c03]: Intel Corporation N10/ICH 7 Family USB UHCI Controller #2 [8086:27c9] (rev 01)
00:1d.2 USB Controller [0c03]: Intel Corporation N10/ICH 7 Family USB UHCI Controller #3 [8086:27ca] (rev 01)
00:1d.3 USB Controller [0c03]: Intel Corporation N10/ICH 7 Family USB UHCI Controller #4 [8086:27cb] (rev 01)
00:1d.7 USB Controller [0c03]: Intel Corporation N10/ICH 7 Family USB2 EHCI Controller [8086:27cc] (rev 01)
00:1e.0 PCI bridge [0604]: Intel Corporation 82801 Mobile PCI Bridge [8086:2448] (rev e1)
00:1f.0 ISA bridge [0601]: Intel Corporation 82801GBM (ICH7-M) LPC Interface Bridge [8086:27b9] (rev 01)
00:1f.2 IDE interface [0101]: Intel Corporation 82801GBM/GHM (ICH7 Family) SATA IDE Controller [8086:27c4] (rev 01)
00:1f.3 SMBus [0c05]: Intel Corporation N10/ICH 7 Family SMBus Controller [8086:27da] (rev 01)
02:00.0 Ethernet controller [0200]: Broadcom Corporation BCM4401-B0 100Base-TX [14e4:170c] (rev 02)
02:01.0 FireWire (IEEE 1394) [0c00]: Ricoh Co Ltd R5C832 IEEE 1394 Controller [1180:0832]
02:01.1 SD Host controller [0805]: Ricoh Co Ltd R5C822 SD/SDIO/MMC/MS/MSPro Host Adapter [1180:0822] (rev 19)
02:01.2 System peripheral [0880]: Ricoh Co Ltd R5C843 MMC Host Controller [1180:0843] (rev 01)
02:01.3 System peripheral [0880]: Ricoh Co Ltd R5C592 Memory Stick Bus Host Adapter [1180:0592] (rev 0a)
02:01.4 System peripheral [0880]: Ricoh Co Ltd xD-Picture Card Controller [1180:0852] (rev 05)
0c:00.0 Network controller [0280]: Broadcom Corporation BCM4321 802.11a/b/g/n [14e4:4328] (rev 01)

I am using wired ethernet, not the wireless.


"Bad" messages before reboot (sorry there are a lot, but I don't
know where the good info might be):

05:45:46: ata2: lost interrupt (Status 0x58)
05:45:46: ata2: drained 65536 bytes to clear DRQ.
05:45:46: ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
05:45:46: sr 1:0:0:0: CDB: Get event status notification: 4a 01 00 00 10 00 00 00 08 00
05:45:46: ata2.00: cmd a0/00:00:00:08:00/00:00:00:00:00/a0 tag 0 pio 16392 in
05:45:46:          res 40/00:03:00:00:00/00:00:00:00:00/a0 Emask 0x4 (timeout)
05:45:46: ata2.00: status: { DRDY }
05:45:46: ata2: soft resetting link
05:45:46: ata2.00: configured for UDMA/33
05:45:46: ata2: EH complete
05:46:12: INFO: rcu_sched_state detected stall on CPU 0 (t=18000 jiffies)
05:46:12: sending NMI to all CPUs:
05:46:12: NMI backtrace for cpu 0
05:46:12: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
05:46:12: 
05:46:12: Pid: 3145, comm: firefox-bin Not tainted 2.6.38-rc4 #226 0MG532/MXC061                          
05:46:12: EIP: 0060:[<c110f7f5>] EFLAGS: 00000082 CPU: 0
05:46:12: EIP is at delay_tsc+0x22/0x55
05:46:12: EAX: 87b7e7d8 EBX: 00000001 ECX: 00000000 EDX: 00001659
05:46:12: ESI: c1436640 EDI: 87b7e784 EBP: 001e7aea ESP: f21a3c20
05:46:12:  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
05:46:12: Process firefox-bin (pid: 3145, ti=f21a2000 task=f613c6c0 task.ti=f21a2000)
05:46:12: Stack:
05:46:12:  00000000 c1436640 00000001 c1436640 00000000 c1436640 c110f7bf c1015f6d
05:46:12:  c13a101a f6402e14 c105c85b c13a901b c13a9102 00000000 00004650 00000000
05:46:12:  00000000 00000000 00000000 00000000 f21a3d2c c105caf0 f613c6c0 c1032df0
05:46:12: Call Trace:
05:46:12:  [<c110f7bf>] ? __const_udelay+0x18/0x19
05:46:12:  [<c1015f6d>] ? arch_trigger_all_cpu_backtrace+0x52/0x65
05:46:12:  [<c105c85b>] ? __rcu_pending+0x6c/0x277
05:46:12:  [<c105caf0>] ? rcu_check_callbacks+0x8a/0xb6
05:46:12:  [<c1032df0>] ? update_process_times+0x2a/0x53
05:46:12:  [<c1047627>] ? tick_sched_timer+0x64/0x8d
05:46:12:  [<c103f332>] ? __run_hrtimer+0x6d/0xc3
05:46:12:  [<c103f595>] ? hrtimer_interrupt+0x10c/0x213
05:46:12:  [<c102e915>] ? irq_exit+0x41/0x64
05:46:12:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
05:46:12:  [<c10157cc>] ? smp_apic_timer_interrupt+0x6c/0x7d
05:46:12:  [<c1002c69>] ? common_interrupt+0x29/0x30
05:46:12:  [<c1304e02>] ? apic_timer_interrupt+0x2a/0x30
05:46:12:  [<c106eda8>] ? shrink_zone+0x1cb/0x4c3
05:46:12:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
05:46:12:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
05:46:12:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
05:46:12:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
05:46:12:  [<c1042852>] ? ktime_get+0x5e/0xd9
05:46:12:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
05:46:12:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
05:46:12:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
05:46:12:  [<c1047272>] ? tick_program_event+0x19/0x1c
05:46:12:  [<c102e915>] ? irq_exit+0x41/0x64
05:46:12:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
05:46:12:  [<c101acf3>] ? do_page_fault+0x0/0x30d
05:46:12:  [<c1305022>] ? error_code+0x5a/0x60
05:46:12:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
05:46:12:  [<c101acf3>] ? do_page_fault+0x0/0x30d
05:46:12: Code: ff 8d 04 80 e9 d4 ff ff ff 55 89 c5 57 56 53 83 ec 08 64 8b 0d b8 7f 4e c1 8d 76 00 0f ae e8 0f 31 89 c7 8d 76 00 0f ae e8 0f 31 <89> c3 89 c6 29 fb 39 eb 73 21 f3 90 64 8b 1d b8 7f 4e c1 39 d9 
05:46:12: Call Trace:
05:46:12:  [<c110f7bf>] ? __const_udelay+0x18/0x19
05:46:12:  [<c1015f6d>] ? arch_trigger_all_cpu_backtrace+0x52/0x65
05:46:12:  [<c105c85b>] ? __rcu_pending+0x6c/0x277
05:46:12:  [<c105caf0>] ? rcu_check_callbacks+0x8a/0xb6
05:46:12:  [<c1032df0>] ? update_process_times+0x2a/0x53
05:46:12:  [<c1047627>] ? tick_sched_timer+0x64/0x8d
05:46:12:  [<c103f332>] ? __run_hrtimer+0x6d/0xc3
05:46:12:  [<c103f595>] ? hrtimer_interrupt+0x10c/0x213
05:46:12:  [<c102e915>] ? irq_exit+0x41/0x64
05:46:12:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
05:46:12:  [<c10157cc>] ? smp_apic_timer_interrupt+0x6c/0x7d
05:46:12:  [<c1002c69>] ? common_interrupt+0x29/0x30
05:46:12:  [<c1304e02>] ? apic_timer_interrupt+0x2a/0x30
05:46:12:  [<c106eda8>] ? shrink_zone+0x1cb/0x4c3
05:46:12:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
05:46:12:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
05:46:12:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
05:46:12:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
05:46:12:  [<c1042852>] ? ktime_get+0x5e/0xd9
05:46:12:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
05:46:12:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
05:46:12:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
05:46:12:  [<c1047272>] ? tick_program_event+0x19/0x1c
05:46:12:  [<c102e915>] ? irq_exit+0x41/0x64
05:46:12:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
05:46:12:  [<c101acf3>] ? do_page_fault+0x0/0x30d
05:46:12:  [<c1305022>] ? error_code+0x5a/0x60
05:46:12:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
05:46:12:  [<c101acf3>] ? do_page_fault+0x0/0x30d
05:46:12: Pid: 3145, comm: firefox-bin Not tainted 2.6.38-rc4 #226
05:46:12: Call Trace:
05:46:12:  [<c10054b6>] ? show_trace+0xf/0x11
05:46:12:  [<c1015eff>] ? arch_trigger_all_cpu_backtrace_handler+0x57/0x73
05:46:12:  [<c104039f>] ? notifier_call_chain+0x23/0x46
05:46:12:  [<c10403e3>] ? atomic_notifier_call_chain+0x1a/0x1d
05:46:12:  [<c1040477>] ? notify_die+0x30/0x34
05:46:12:  [<c1003657>] ? do_nmi+0x68/0x267
05:46:12:  [<c13050d1>] ? nmi_stack_correct+0x28/0x2d
05:46:12:  [<c10100d8>] ? do_machine_check+0x2c0/0x6d2
05:46:12:  [<c110f7f5>] ? delay_tsc+0x22/0x55
05:46:12:  [<c110f7bf>] ? __const_udelay+0x18/0x19
05:46:12:  [<c1015f6d>] ? arch_trigger_all_cpu_backtrace+0x52/0x65
05:46:12:  [<c105c85b>] ? __rcu_pending+0x6c/0x277
05:46:12:  [<c105caf0>] ? rcu_check_callbacks+0x8a/0xb6
05:46:12:  [<c1032df0>] ? update_process_times+0x2a/0x53
05:46:12:  [<c1047627>] ? tick_sched_timer+0x64/0x8d
05:46:12:  [<c103f332>] ? __run_hrtimer+0x6d/0xc3
05:46:12:  [<c103f595>] ? hrtimer_interrupt+0x10c/0x213
05:46:12:  [<c102e915>] ? irq_exit+0x41/0x64
05:46:12:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
05:46:12:  [<c10157cc>] ? smp_apic_timer_interrupt+0x6c/0x7d
05:46:12:  [<c1002c69>] ? common_interrupt+0x29/0x30
05:46:12:  [<c1304e02>] ? apic_timer_interrupt+0x2a/0x30
05:46:12:  [<c106eda8>] ? shrink_zone+0x1cb/0x4c3
05:46:12:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
05:46:12:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
05:46:12:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
05:46:12:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
05:46:12:  [<c1042852>] ? ktime_get+0x5e/0xd9
05:46:12:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
05:46:12:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
05:46:12:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
05:46:12:  [<c1047272>] ? tick_program_event+0x19/0x1c
05:46:12:  [<c102e915>] ? irq_exit+0x41/0x64
05:46:12:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
05:46:12:  [<c101acf3>] ? do_page_fault+0x0/0x30d
05:46:12:  [<c1305022>] ? error_code+0x5a/0x60
05:46:12:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
05:46:12:  [<c101acf3>] ? do_page_fault+0x0/0x30d
05:46:12: NMI backtrace for cpu 1
05:46:12: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
05:46:12: 
05:46:12: Pid: 0, comm: kworker/0:0 Not tainted 2.6.38-rc4 #226 0MG532/MXC061                          
05:46:12: EIP: 0060:[<c115b1d0>] EFLAGS: 00000093 CPU: 1
05:46:12: EIP is at acpi_idle_do_entry+0x3c/0x44
05:46:12: EAX: f6011440 EBX: e21252af ECX: 3b9aca00 EDX: 00001016
05:46:12: ESI: 1201fad7 EDI: f6011440 EBP: f6011000 ESP: f6089f74
05:46:12:  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
05:46:12: Process kworker/0:0 (pid: 0, ti=f6088000 task=f6042520 task.ti=f6088000)
05:46:12: Stack:
05:46:12:  c115b406 00000000 00000000 00000000 f601101c 00003e80 00000000 f601101c
05:46:12:  f6011134 00000000 00000000 c123289f c1495ccc 00000001 c1001ae9 01020800
05:46:12:  00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
05:46:12: Call Trace:
05:46:12:  [<c115b406>] ? acpi_idle_enter_bm+0x1a7/0x261
05:46:12:  [<c123289f>] ? cpuidle_idle_call+0x67/0x98
05:46:12:  [<c1001ae9>] ? cpu_idle+0x41/0x5c
05:46:12: Code: 26 89 e0 25 00 e0 ff ff 83 60 0c fb 0f ae f0 89 f6 8b 40 08 a8 08 75 03 fb f4 fa 89 e0 25 00 e0 ff ff 83 48 0c 04 c3 8b 50 04 ec <8b> 15 00 46 52 c1 ed c3 55 31 c0 57 56 53 83 ec 08 8b 5a 30 64 
05:46:12: Call Trace:
05:46:12:  [<c115b406>] ? acpi_idle_enter_bm+0x1a7/0x261
05:46:12:  [<c123289f>] ? cpuidle_idle_call+0x67/0x98
05:46:12:  [<c1001ae9>] ? cpu_idle+0x41/0x5c
05:46:12: Pid: 0, comm: kworker/0:0 Not tainted 2.6.38-rc4 #226
05:46:12: Call Trace:
05:46:12:  [<c10054b6>] ? show_trace+0xf/0x11
05:46:12:  [<c1015eff>] ? arch_trigger_all_cpu_backtrace_handler+0x57/0x73
05:46:12:  [<c104039f>] ? notifier_call_chain+0x23/0x46
05:46:12:  [<c10403e3>] ? atomic_notifier_call_chain+0x1a/0x1d
05:46:12:  [<c1040477>] ? notify_die+0x30/0x34
05:46:12:  [<c1003657>] ? do_nmi+0x68/0x267
05:46:12:  [<c1040c67>] ? sched_clock_local+0x19/0x17c
05:46:12:  [<c13050d1>] ? nmi_stack_correct+0x28/0x2d
05:46:12:  [<c104007b>] ? copy_namespaces+0x1/0x7e
05:46:12:  [<c115b1d0>] ? acpi_idle_do_entry+0x3c/0x44
05:46:12:  [<c115b406>] ? acpi_idle_enter_bm+0x1a7/0x261
05:46:12:  [<c123289f>] ? cpuidle_idle_call+0x67/0x98
05:46:12:  [<c1001ae9>] ? cpu_idle+0x41/0x5c
05:46:17: ata2: lost interrupt (Status 0x58)
05:46:17: ata2: drained 65536 bytes to clear DRQ.
05:46:17: ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
05:46:17: sr 1:0:0:0: CDB: Get event status notification: 4a 01 00 00 10 00 00 00 08 00
05:46:17: ata2.00: cmd a0/00:00:00:08:00/00:00:00:00:00/a0 tag 0 pio 16392 in
05:46:17:          res 40/00:03:00:00:00/00:00:00:00:00/a0 Emask 0x4 (timeout)
05:46:17: ata2.00: status: { DRDY }
05:46:17: ata2: soft resetting link
05:46:17: ata2.00: configured for UDMA/33
05:46:17: ata2: EH complete
05:46:48: ata2: lost interrupt (Status 0x58)
05:46:48: ata2: drained 65536 bytes to clear DRQ.
05:46:48: ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
05:46:48: sr 1:0:0:0: CDB: Get event status notification: 4a 01 00 00 10 00 00 00 08 00
05:46:48: ata2.00: cmd a0/00:00:00:08:00/00:00:00:00:00/a0 tag 0 pio 16392 in
05:46:48:          res 40/00:03:00:00:00/00:00:00:00:00/a0 Emask 0x4 (timeout)
05:46:48: ata2.00: status: { DRDY }
05:46:48: ata2: soft resetting link
05:46:48: ata2.00: configured for UDMA/33
05:46:48: ata2: EH complete
05:47:18: BUG: soft lockup - CPU#0 stuck for 61s! [firefox-bin:3145]
05:47:18: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
05:47:18: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
05:47:18: 
05:47:18: Pid: 3145, comm: firefox-bin Not tainted 2.6.38-rc4 #226 0MG532/MXC061                          
05:47:18: EIP: 0060:[<c106eda8>] EFLAGS: 00000286 CPU: 0
05:47:18: EIP is at shrink_zone+0x1cb/0x4c3
05:47:18: EAX: 00000c47 EBX: c1492e00 ECX: 0000003d EDX: 00000016
05:47:18: ESI: f21a3e24 EDI: c1493040 EBP: f21a3dec ESP: f21a3d68
05:47:18:  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
05:47:18: Process firefox-bin (pid: 3145, ti=f21a2000 task=f613c6c0 task.ti=f21a2000)
05:47:18: Stack:
05:47:18:  00000c85 00000000 00000000 c1492e00 0000c88d 00000020 00000021 c1493098
05:47:18:  00000004 c14930a8 c1493040 c14930a4 c14930a0 c149309c 0000000b 0000a189
05:47:18:  00001e14 00000000 0000003c 00000000 00000000 00000000 00000000 00000040
05:47:18: Call Trace:
05:47:18:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
05:47:18:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
05:47:18:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
05:47:18:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
05:47:18:  [<c1042852>] ? ktime_get+0x5e/0xd9
05:47:18:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
05:47:18:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
05:47:18:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
05:47:18:  [<c1047272>] ? tick_program_event+0x19/0x1c
05:47:18:  [<c102e915>] ? irq_exit+0x41/0x64
05:47:18:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
05:47:18:  [<c101acf3>] ? do_page_fault+0x0/0x30d
05:47:18:  [<c1305022>] ? error_code+0x5a/0x60
05:47:18:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
05:47:18:  [<c101acf3>] ? do_page_fault+0x0/0x30d
05:47:18: Code: 8b 93 78 02 00 00 8b bb 70 02 00 00 42 47 89 c1 b8 c9 00 00 00 2b 44 24 48 0f af c2 31 d2 f7 f7 8b 7c 24 28 fe 07 fb 89 44 24 68 <89> 4c 24 60 8d 44 01 01 c7 44 24 64 00 00 00 00 c7 44 24 6c 00 
05:47:18: Call Trace:
05:47:18:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
05:47:18:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
05:47:18:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
05:47:18:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
05:47:18:  [<c1042852>] ? ktime_get+0x5e/0xd9
05:47:18:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
05:47:18:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
05:47:18:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
05:47:18:  [<c1047272>] ? tick_program_event+0x19/0x1c
05:47:18:  [<c102e915>] ? irq_exit+0x41/0x64
05:47:18:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
05:47:18:  [<c101acf3>] ? do_page_fault+0x0/0x30d
05:47:18:  [<c1305022>] ? error_code+0x5a/0x60
05:47:18:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
05:47:18:  [<c101acf3>] ? do_page_fault+0x0/0x30d
05:47:19: ata2: lost interrupt (Status 0x58)
05:47:19: ata2: drained 65536 bytes to clear DRQ.
05:47:19: ata2.00: limiting speed to UDMA/25:PIO4
05:47:19: ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
05:47:19: sr 1:0:0:0: CDB: Get event status notification: 4a 01 00 00 10 00 00 00 08 00
05:47:19: ata2.00: cmd a0/00:00:00:08:00/00:00:00:00:00/a0 tag 0 pio 16392 in
05:47:19:          res 40/00:03:00:00:00/00:00:00:00:00/a0 Emask 0x4 (timeout)
05:47:19: ata2.00: status: { DRDY }
05:47:19: ata2: soft resetting link
05:47:19: ata2.00: configured for UDMA/25
05:47:19: ata2: EH complete
05:47:50: ata2: lost interrupt (Status 0x58)
05:47:50: ata2: drained 65536 bytes to clear DRQ.
05:47:50: ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
05:47:50: sr 1:0:0:0: CDB: Get event status notification: 4a 01 00 00 10 00 00 00 08 00
05:47:50: ata2.00: cmd a0/00:00:00:08:00/00:00:00:00:00/a0 tag 0 pio 16392 in
05:47:50:          res 40/00:03:00:00:00/00:00:00:00:00/a0 Emask 0x4 (timeout)
05:47:50: ata2.00: status: { DRDY }
05:47:50: ata2: soft resetting link
05:47:50: ata2.00: configured for UDMA/25
05:47:50: ata2: EH complete
05:48:21: ata2: lost interrupt (Status 0x58)
05:48:21: ata2: drained 65536 bytes to clear DRQ.
05:48:21: ata2.00: limiting speed to PIO4
05:48:21: ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
05:48:21: sr 1:0:0:0: CDB: Get event status notification: 4a 01 00 00 10 00 00 00 08 00
05:48:21: ata2.00: cmd a0/00:00:00:08:00/00:00:00:00:00/a0 tag 0 pio 16392 in
05:48:21:          res 40/00:03:00:00:00/00:00:00:00:00/a0 Emask 0x4 (timeout)
05:48:21: ata2.00: status: { DRDY }
05:48:21: ata2: soft resetting link
05:48:21: ata2.00: configured for PIO4
05:48:21: ata2: EH complete
05:48:29: BUG: soft lockup - CPU#0 stuck for 63s! [firefox-bin:3145]
05:48:29: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
05:48:29: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
05:48:29: 
05:48:29: Pid: 3145, comm: firefox-bin Not tainted 2.6.38-rc4 #226 0MG532/MXC061                          
05:48:29: EIP: 0060:[<c1110bba>] EFLAGS: 00000292 CPU: 0
05:48:29: EIP is at div64_u64+0x14/0xef
05:48:29: EAX: 000004c4 EBX: 000004c4 ECX: 00000c6c EDX: 00000000
05:48:29: ESI: 00000000 EDI: f21a3d50 EBP: f21a3d60 ESP: f21a3d38
05:48:29:  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
05:48:29: Process firefox-bin (pid: 3145, ti=f21a2000 task=f613c6c0 task.ti=f21a2000)
05:48:29: Stack:
05:48:29:  f21a3d50 00000000 00000000 00000c6c c111007b 0000007b 000005f5 00000000
05:48:29:  f21a3e24 00000001 f21a3dec c106ee41 00000c6c 00000000 00000000 c1492e00
05:48:29:  0000c88d 00000020 00000021 c1493098 00000002 c14930a8 c1493040 c14930a4
05:48:29: Call Trace:
05:48:29:  [<c111007b>] ? __put_user_8+0xf/0x19
05:48:29:  [<c106ee41>] ? shrink_zone+0x264/0x4c3
05:48:29:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
05:48:29:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
05:48:29:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
05:48:29:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
05:48:29:  [<c1042852>] ? ktime_get+0x5e/0xd9
05:48:29:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
05:48:29:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
05:48:29:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
05:48:29:  [<c1047272>] ? tick_program_event+0x19/0x1c
05:48:29:  [<c102e915>] ? irq_exit+0x41/0x64
05:48:29:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
05:48:29:  [<c101acf3>] ? do_page_fault+0x0/0x30d
05:48:29:  [<c1305022>] ? error_code+0x5a/0x60
05:48:29:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
05:48:29:  [<c101acf3>] ? do_page_fault+0x0/0x30d
05:48:29: Code: f9 e8 db fe ff ff 85 db 79 07 f7 d8 83 d2 00 f7 da 59 5b 5e 5f c9 c3 55 89 e5 57 56 89 d6 53 89 c3 83 ec 1c 8b 55 0c 8d 7c 24 18 <85> d2 75 1a 89 3c 24 8b 4d 08 89 f2 e8 a5 fe ff ff 89 44 24 04 
05:48:29: Call Trace:
05:48:29:  [<c111007b>] ? __put_user_8+0xf/0x19
05:48:29:  [<c106ee41>] ? shrink_zone+0x264/0x4c3
05:48:29:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
05:48:29:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
05:48:29:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
05:48:29:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
05:48:29:  [<c1042852>] ? ktime_get+0x5e/0xd9
05:48:29:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
05:48:29:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
05:48:29:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
05:48:29:  [<c1047272>] ? tick_program_event+0x19/0x1c
05:48:29:  [<c102e915>] ? irq_exit+0x41/0x64
05:48:29:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
05:48:29:  [<c101acf3>] ? do_page_fault+0x0/0x30d
05:48:29:  [<c1305022>] ? error_code+0x5a/0x60
05:48:29:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
05:48:29:  [<c101acf3>] ? do_page_fault+0x0/0x30d
05:48:52: ata2: lost interrupt (Status 0x58)
05:48:52: ata2: drained 65536 bytes to clear DRQ.
05:48:52: ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
05:48:52: sr 1:0:0:0: CDB: Get event status notification: 4a 01 00 00 10 00 00 00 08 00
05:48:52: ata2.00: cmd a0/00:00:00:08:00/00:00:00:00:00/a0 tag 0 pio 16392 in
05:48:52:          res 40/00:03:00:00:00/00:00:00:00:00/a0 Emask 0x4 (timeout)
05:48:52: ata2.00: status: { DRDY }
05:48:52: ata2: soft resetting link
05:48:52: ata2.00: configured for PIO4
05:48:52: ata2: EH complete
05:49:04: INFO: task khugepaged:546 blocked for more than 120 seconds.
05:49:04: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
05:49:04: khugepaged      D f58bfee0     0   546      2 0x00000000
05:49:04:  f613ebe0 00000046 00000002 f58bfee0 00000000 c14eba00 00000000 00000001
05:49:04:  c14eba00 f613ed48 c14eba00 f613ed48 f613ed4c c14eba00 f613ebe0 c14eba00
05:49:04:  0000000a 00000003 004352da 00000002 c106a170 c1493880 00000003 00000041
05:49:04: Call Trace:
05:49:04:  [<c106a170>] ? __alloc_pages_nodemask+0xfd/0x647
05:49:04:  [<c1032cb6>] ? try_to_del_timer_sync+0x61/0x67
05:49:04:  [<c1304649>] ? rwsem_down_failed_common+0x9d/0xc5
05:49:04:  [<c13046c3>] ? call_rwsem_down_read_failed+0x7/0xc
05:49:04:  [<c13040e3>] ? down_read+0x14/0x16
05:49:04:  [<c1089d3b>] ? khugepaged+0x20c/0xb50
05:49:04:  [<c103c967>] ? autoremove_wake_function+0x0/0x31
05:49:04:  [<c1089b2f>] ? khugepaged+0x0/0xb50
05:49:04:  [<c103c677>] ? kthread+0x63/0x68
05:49:04:  [<c103c614>] ? kthread+0x0/0x68
05:49:04:  [<c1002c76>] ? kernel_thread_helper+0x6/0x10
05:49:04: INFO: task firefox-bin:4621 blocked for more than 120 seconds.
05:49:04: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
05:49:04: firefox-bin     D d702bf58     0  4621   3127 0x00000000
05:49:04:  f0dcc000 00200082 00000002 d702bf58 00000001 75d00000 00000000 00000001
05:49:04:  c14eba00 f0dcc168 c14eba00 f0dcc168 f0dcc16c c14eba00 f0dcc000 c14eba00
05:49:04:  764fb000 c10775f2 764fb000 d702bf28 00000000 000007fb f6602018 f0c53b58
05:49:04: Call Trace:
05:49:04:  [<c10775f2>] ? zap_page_range+0x72/0x7c
05:49:04:  [<c10769dc>] ? sys_madvise+0x450/0x468
05:49:04:  [<c1304649>] ? rwsem_down_failed_common+0x9d/0xc5
05:49:04:  [<c13046ce>] ? call_rwsem_down_write_failed+0x6/0x8
05:49:04:  [<c13040cd>] ? down_write+0x1c/0x1e
05:49:04:  [<c107bde1>] ? sys_munmap+0x18/0x35
05:49:04:  [<c1002750>] ? sysenter_do_call+0x12/0x26
05:49:04:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
05:49:12: INFO: rcu_sched_state detected stall on CPU 0 (t=72030 jiffies)
05:49:12: sending NMI to all CPUs:
05:49:12: NMI backtrace for cpu 0
05:49:12: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
05:49:12: 
05:49:12: Pid: 3145, comm: firefox-bin Not tainted 2.6.38-rc4 #226 0MG532/MXC061                          
05:49:12: EIP: 0060:[<c110f7eb>] EFLAGS: 00000082 CPU: 0
05:49:12: EIP is at delay_tsc+0x18/0x55
05:49:12: EAX: 48e29a34 EBX: 00000001 ECX: 00000000 EDX: 000016ad
05:49:12: ESI: c1436640 EDI: 00000000 EBP: 001e7aea ESP: f21a3c20
05:49:12:  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
05:49:12: Process firefox-bin (pid: 3145, ti=f21a2000 task=f613c6c0 task.ti=f21a2000)
05:49:12: Stack:
05:49:12:  00000000 c1436640 00000001 c1436640 00000000 c1436640 c110f7bf c1015f6d
05:49:12:  c13a101a f6402e14 c105c85b c13a901b c13a9102 00000000 0001195e 00000000
05:49:12:  00000000 00000000 00000000 00000000 f21a3d2c c105caf0 f613c6c0 c1032df0
05:49:12: Call Trace:
05:49:12:  [<c110f7bf>] ? __const_udelay+0x18/0x19
05:49:12:  [<c1015f6d>] ? arch_trigger_all_cpu_backtrace+0x52/0x65
05:49:12:  [<c105c85b>] ? __rcu_pending+0x6c/0x277
05:49:12:  [<c105caf0>] ? rcu_check_callbacks+0x8a/0xb6
05:49:12:  [<c1032df0>] ? update_process_times+0x2a/0x53
05:49:12:  [<c1047627>] ? tick_sched_timer+0x64/0x8d
05:49:12:  [<c103f332>] ? __run_hrtimer+0x6d/0xc3
05:49:12:  [<c103f595>] ? hrtimer_interrupt+0x10c/0x213
05:49:12:  [<c10157cc>] ? smp_apic_timer_interrupt+0x6c/0x7d
05:49:12:  [<c1304e02>] ? apic_timer_interrupt+0x2a/0x30
05:49:12:  [<c111007b>] ? __put_user_8+0xf/0x19
05:49:12:  [<c106eda8>] ? shrink_zone+0x1cb/0x4c3
05:49:12:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
05:49:12:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
05:49:12:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
05:49:12:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
05:49:12:  [<c1042852>] ? ktime_get+0x5e/0xd9
05:49:12:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
05:49:12:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
05:49:12:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
05:49:12:  [<c1047272>] ? tick_program_event+0x19/0x1c
05:49:12:  [<c102e915>] ? irq_exit+0x41/0x64
05:49:12:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
05:49:12:  [<c101acf3>] ? do_page_fault+0x0/0x30d
05:49:12:  [<c1305022>] ? error_code+0x5a/0x60
05:49:12:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
05:49:12:  [<c101acf3>] ? do_page_fault+0x0/0x30d
05:49:12: Code: 69 c0 c7 10 00 00 e9 dc ff ff ff 8d 04 80 e9 d4 ff ff ff 55 89 c5 57 56 53 83 ec 08 64 8b 0d b8 7f 4e c1 8d 76 00 0f ae e8 0f 31 <89> c7 8d 76 00 0f ae e8 0f 31 89 c3 89 c6 29 fb 39 eb 73 21 f3 
05:49:12: Call Trace:
05:49:12:  [<c110f7bf>] ? __const_udelay+0x18/0x19
05:49:12:  [<c1015f6d>] ? arch_trigger_all_cpu_backtrace+0x52/0x65
05:49:12:  [<c105c85b>] ? __rcu_pending+0x6c/0x277
05:49:12:  [<c105caf0>] ? rcu_check_callbacks+0x8a/0xb6
05:49:12:  [<c1032df0>] ? update_process_times+0x2a/0x53
05:49:12:  [<c1047627>] ? tick_sched_timer+0x64/0x8d
05:49:12:  [<c103f332>] ? __run_hrtimer+0x6d/0xc3
05:49:12:  [<c103f595>] ? hrtimer_interrupt+0x10c/0x213
05:49:12:  [<c10157cc>] ? smp_apic_timer_interrupt+0x6c/0x7d
05:49:12:  [<c1304e02>] ? apic_timer_interrupt+0x2a/0x30
05:49:12:  [<c111007b>] ? __put_user_8+0xf/0x19
05:49:12:  [<c106eda8>] ? shrink_zone+0x1cb/0x4c3
05:49:12:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
05:49:12:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
05:49:12:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
05:49:12:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
05:49:12:  [<c1042852>] ? ktime_get+0x5e/0xd9
05:49:12:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
05:49:12:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
05:49:12:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
05:49:12:  [<c1047272>] ? tick_program_event+0x19/0x1c
05:49:12:  [<c102e915>] ? irq_exit+0x41/0x64
05:49:12:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
05:49:12:  [<c101acf3>] ? do_page_fault+0x0/0x30d
05:49:12:  [<c1305022>] ? error_code+0x5a/0x60
05:49:12:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
05:49:12:  [<c101acf3>] ? do_page_fault+0x0/0x30d
05:49:12: Pid: 3145, comm: firefox-bin Not tainted 2.6.38-rc4 #226
05:49:12: Call Trace:
05:49:12:  [<c10054b6>] ? show_trace+0xf/0x11
05:49:12:  [<c1015eff>] ? arch_trigger_all_cpu_backtrace_handler+0x57/0x73
05:49:12:  [<c104039f>] ? notifier_call_chain+0x23/0x46
05:49:12:  [<c10403e3>] ? atomic_notifier_call_chain+0x1a/0x1d
05:49:12:  [<c1040477>] ? notify_die+0x30/0x34
05:49:12:  [<c1003657>] ? do_nmi+0x68/0x267
05:49:12:  [<c13050d1>] ? nmi_stack_correct+0x28/0x2d
05:49:12:  [<c10100d8>] ? do_machine_check+0x2c0/0x6d2
05:49:12:  [<c110f7eb>] ? delay_tsc+0x18/0x55
05:49:12:  [<c110f7bf>] ? __const_udelay+0x18/0x19
05:49:12:  [<c1015f6d>] ? arch_trigger_all_cpu_backtrace+0x52/0x65
05:49:12:  [<c105c85b>] ? __rcu_pending+0x6c/0x277
05:49:12:  [<c105caf0>] ? rcu_check_callbacks+0x8a/0xb6
05:49:12:  [<c1032df0>] ? update_process_times+0x2a/0x53
05:49:12:  [<c1047627>] ? tick_sched_timer+0x64/0x8d
05:49:12:  [<c103f332>] ? __run_hrtimer+0x6d/0xc3
05:49:12:  [<c103f595>] ? hrtimer_interrupt+0x10c/0x213
05:49:12:  [<c10157cc>] ? smp_apic_timer_interrupt+0x6c/0x7d
05:49:12:  [<c1304e02>] ? apic_timer_interrupt+0x2a/0x30
05:49:12:  [<c111007b>] ? __put_user_8+0xf/0x19
05:49:12:  [<c106eda8>] ? shrink_zone+0x1cb/0x4c3
05:49:12:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
05:49:12:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
05:49:12:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
05:49:12:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
05:49:12:  [<c1042852>] ? ktime_get+0x5e/0xd9
05:49:12:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
05:49:12:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
05:49:12:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
05:49:12:  [<c1047272>] ? tick_program_event+0x19/0x1c
05:49:12:  [<c102e915>] ? irq_exit+0x41/0x64
05:49:12:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
05:49:12:  [<c101acf3>] ? do_page_fault+0x0/0x30d
05:49:12:  [<c1305022>] ? error_code+0x5a/0x60
05:49:12:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
05:49:12:  [<c101acf3>] ? do_page_fault+0x0/0x30d
05:49:12: NMI backtrace for cpu 1
05:49:12: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
05:49:12: 
05:49:12: Pid: 0, comm: kworker/0:0 Not tainted 2.6.38-rc4 #226 0MG532/MXC061                          
05:49:12: EIP: 0060:[<c115b1d0>] EFLAGS: 00000093 CPU: 1
05:49:12: EIP is at acpi_idle_do_entry+0x3c/0x44
05:49:12: EAX: f6011440 EBX: d0ddf42d ECX: 3b9aca00 EDX: 00001016
05:49:12: ESI: 1201fb01 EDI: f6011440 EBP: f6011000 ESP: f6089f74
05:49:12:  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
05:49:12: Process kworker/0:0 (pid: 0, ti=f6088000 task=f6042520 task.ti=f6088000)
05:49:12: Stack:
05:49:12:  c115b406 00000000 00000000 00000000 f601101c 00003e80 00000000 f601101c
05:49:12:  f6011134 00000000 00000000 c123289f c1495ccc 00000001 c1001ae9 01020800
05:49:12:  00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
05:49:12: Call Trace:
05:49:12:  [<c115b406>] ? acpi_idle_enter_bm+0x1a7/0x261
05:49:12:  [<c123289f>] ? cpuidle_idle_call+0x67/0x98
05:49:12:  [<c1001ae9>] ? cpu_idle+0x41/0x5c
05:49:12: Code: 26 89 e0 25 00 e0 ff ff 83 60 0c fb 0f ae f0 89 f6 8b 40 08 a8 08 75 03 fb f4 fa 89 e0 25 00 e0 ff ff 83 48 0c 04 c3 8b 50 04 ec <8b> 15 00 46 52 c1 ed c3 55 31 c0 57 56 53 83 ec 08 8b 5a 30 64 
05:49:12: Call Trace:
05:49:12:  [<c115b406>] ? acpi_idle_enter_bm+0x1a7/0x261
05:49:12:  [<c123289f>] ? cpuidle_idle_call+0x67/0x98
05:49:12:  [<c1001ae9>] ? cpu_idle+0x41/0x5c
05:49:12: Pid: 0, comm: kworker/0:0 Not tainted 2.6.38-rc4 #226
05:49:12: Call Trace:
05:49:12:  [<c10054b6>] ? show_trace+0xf/0x11
05:49:12:  [<c1015eff>] ? arch_trigger_all_cpu_backtrace_handler+0x57/0x73
05:49:12:  [<c104039f>] ? notifier_call_chain+0x23/0x46
05:49:12:  [<c10403e3>] ? atomic_notifier_call_chain+0x1a/0x1d
05:49:12:  [<c1040477>] ? notify_die+0x30/0x34
05:49:12:  [<c1003657>] ? do_nmi+0x68/0x267
05:49:12:  [<c1040c67>] ? sched_clock_local+0x19/0x17c
05:49:12:  [<c13050d1>] ? nmi_stack_correct+0x28/0x2d
05:49:12:  [<c104007b>] ? copy_namespaces+0x1/0x7e
05:49:12:  [<c115b1d0>] ? acpi_idle_do_entry+0x3c/0x44
05:49:12:  [<c115b406>] ? acpi_idle_enter_bm+0x1a7/0x261
05:49:12:  [<c123289f>] ? cpuidle_idle_call+0x67/0x98
05:49:12:  [<c1001ae9>] ? cpu_idle+0x41/0x5c
05:49:23: ata2: lost interrupt (Status 0x58)
05:49:23: ata2: drained 65536 bytes to clear DRQ.
05:49:23: ata2.00: limiting speed to PIO3
05:49:23: ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
05:49:23: sr 1:0:0:0: CDB: Get event status notification: 4a 01 00 00 10 00 00 00 08 00
05:49:23: ata2.00: cmd a0/00:00:00:08:00/00:00:00:00:00/a0 tag 0 pio 16392 in
05:49:23:          res 40/00:03:00:00:00/00:00:00:00:00/a0 Emask 0x4 (timeout)
05:49:23: ata2.00: status: { DRDY }
05:49:23: ata2: soft resetting link
05:49:23: ata2.00: configured for PIO3
05:49:23: ata2: EH complete
05:50:35: INFO: rcu_sched_state detected stall on CPU 1 (t=18000 jiffies)
05:50:35: sending NMI to all CPUs:
05:50:35: NMI backtrace for cpu 1
05:50:35: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
05:50:35: 
05:50:35: Pid: 3145, comm: firefox-bin Not tainted 2.6.38-rc4 #226 0MG532/MXC061                          
05:50:35: EIP: 0060:[<c110f7eb>] EFLAGS: 00000086 CPU: 1
05:50:35: EIP is at delay_tsc+0x18/0x55
05:50:35: EAX: f00ba37c EBX: 00000001 ECX: 00000001 EDX: 000016d3
05:50:35: ESI: c1436640 EDI: 00000001 EBP: 001e7a67 ESP: f21a3bf0
05:50:35:  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
05:50:35: Process firefox-bin (pid: 3145, ti=f21a2000 task=f613c6c0 task.ti=f21a2000)
05:50:35: Stack:
05:50:35:  00000000 c1436640 00000001 c1436640 00000001 c1436640 c110f7bf c1015f6d
05:50:35:  c13a101a f6602e14 c105c85b c13a901b c13a9102 00000001 00004650 00000000
05:50:35:  00000000 00000001 00000000 00000001 f21a3cfc c105caf0 f613c6c0 c1032df0
05:50:35: Call Trace:
05:50:35:  [<c110f7bf>] ? __const_udelay+0x18/0x19
05:50:35:  [<c1015f6d>] ? arch_trigger_all_cpu_backtrace+0x52/0x65
05:50:35:  [<c105c85b>] ? __rcu_pending+0x6c/0x277
05:50:35:  [<c105caf0>] ? rcu_check_callbacks+0x8a/0xb6
05:50:35:  [<c1032df0>] ? update_process_times+0x2a/0x53
05:50:36:  [<c1047627>] ? tick_sched_timer+0x64/0x8d
05:50:36:  [<c103f332>] ? __run_hrtimer+0x6d/0xc3
05:50:36:  [<c103f595>] ? hrtimer_interrupt+0x10c/0x213
05:50:36:  [<c10157cc>] ? smp_apic_timer_interrupt+0x6c/0x7d
05:50:36:  [<c1304e02>] ? apic_timer_interrupt+0x2a/0x30
05:50:36:  [<c111007b>] ? __put_user_8+0xf/0x19
05:50:36:  [<c1110c89>] ? div64_u64+0xe3/0xef
05:50:36:  [<c111007b>] ? __put_user_8+0xf/0x19
05:50:36:  [<c106ee41>] ? shrink_zone+0x264/0x4c3
05:50:36:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
05:50:36:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
05:50:36:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
05:50:36:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
05:50:36:  [<c1042852>] ? ktime_get+0x5e/0xd9
05:50:36:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
05:50:36:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
05:50:36:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
05:50:36:  [<c1047272>] ? tick_program_event+0x19/0x1c
05:50:36:  [<c102e915>] ? irq_exit+0x41/0x64
05:50:36:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
05:50:36:  [<c101acf3>] ? do_page_fault+0x0/0x30d
05:50:36:  [<c1305022>] ? error_code+0x5a/0x60
05:50:36:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
05:50:36:  [<c101acf3>] ? do_page_fault+0x0/0x30d
05:50:36: Code: 69 c0 c7 10 00 00 e9 dc ff ff ff 8d 04 80 e9 d4 ff ff ff 55 89 c5 57 56 53 83 ec 08 64 8b 0d b8 7f 4e c1 8d 76 00 0f ae e8 0f 31 <89> c7 8d 76 00 0f ae e8 0f 31 89 c3 89 c6 29 fb 39 eb 73 21 f3 
05:50:36: Call Trace:
05:50:36:  [<c110f7bf>] ? __const_udelay+0x18/0x19
05:50:36:  [<c1015f6d>] ? arch_trigger_all_cpu_backtrace+0x52/0x65
05:50:36:  [<c105c85b>] ? __rcu_pending+0x6c/0x277
05:50:36:  [<c105caf0>] ? rcu_check_callbacks+0x8a/0xb6
05:50:36:  [<c1032df0>] ? update_process_times+0x2a/0x53
05:50:36:  [<c1047627>] ? tick_sched_timer+0x64/0x8d
05:50:36:  [<c103f332>] ? __run_hrtimer+0x6d/0xc3
05:50:36:  [<c103f595>] ? hrtimer_interrupt+0x10c/0x213
05:50:36:  [<c10157cc>] ? smp_apic_timer_interrupt+0x6c/0x7d
05:50:36:  [<c1304e02>] ? apic_timer_interrupt+0x2a/0x30
05:50:36:  [<c111007b>] ? __put_user_8+0xf/0x19
05:50:36:  [<c1110c89>] ? div64_u64+0xe3/0xef
05:50:36:  [<c111007b>] ? __put_user_8+0xf/0x19
05:50:36:  [<c106ee41>] ? shrink_zone+0x264/0x4c3
05:50:36:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
05:50:36:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
05:50:36:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
05:50:36:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
05:50:36:  [<c1042852>] ? ktime_get+0x5e/0xd9
05:50:36:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
05:50:36:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
05:50:36:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
05:50:36:  [<c1047272>] ? tick_program_event+0x19/0x1c
05:50:36:  [<c102e915>] ? irq_exit+0x41/0x64
05:50:36:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
05:50:36:  [<c101acf3>] ? do_page_fault+0x0/0x30d
05:50:36:  [<c1305022>] ? error_code+0x5a/0x60
05:50:36:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
05:50:36:  [<c101acf3>] ? do_page_fault+0x0/0x30d
05:50:36: Pid: 3145, comm: firefox-bin Not tainted 2.6.38-rc4 #226
05:50:36: Call Trace:
05:50:36:  [<c10054b6>] ? show_trace+0xf/0x11
05:50:36:  [<c1015eff>] ? arch_trigger_all_cpu_backtrace_handler+0x57/0x73
05:50:36:  [<c104039f>] ? notifier_call_chain+0x23/0x46
05:50:36:  [<c10403e3>] ? atomic_notifier_call_chain+0x1a/0x1d
05:50:36:  [<c1040477>] ? notify_die+0x30/0x34
05:50:36:  [<c1003657>] ? do_nmi+0x68/0x267
05:50:36:  [<c13050d1>] ? nmi_stack_correct+0x28/0x2d
05:50:36:  [<c10100d8>] ? do_machine_check+0x2c0/0x6d2
05:50:36:  [<c110f7eb>] ? delay_tsc+0x18/0x55
05:50:36:  [<c110f7bf>] ? __const_udelay+0x18/0x19
05:50:36:  [<c1015f6d>] ? arch_trigger_all_cpu_backtrace+0x52/0x65
05:50:36:  [<c105c85b>] ? __rcu_pending+0x6c/0x277
05:50:36:  [<c105caf0>] ? rcu_check_callbacks+0x8a/0xb6
05:50:36:  [<c1032df0>] ? update_process_times+0x2a/0x53
05:50:36:  [<c1047627>] ? tick_sched_timer+0x64/0x8d
05:50:36:  [<c103f332>] ? __run_hrtimer+0x6d/0xc3
05:50:36:  [<c103f595>] ? hrtimer_interrupt+0x10c/0x213
05:50:36:  [<c10157cc>] ? smp_apic_timer_interrupt+0x6c/0x7d
05:50:36:  [<c1304e02>] ? apic_timer_interrupt+0x2a/0x30
05:50:36:  [<c111007b>] ? __put_user_8+0xf/0x19
05:50:36:  [<c1110c89>] ? div64_u64+0xe3/0xef
05:50:36:  [<c111007b>] ? __put_user_8+0xf/0x19
05:50:36:  [<c106ee41>] ? shrink_zone+0x264/0x4c3
05:50:36:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
05:50:36:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
05:50:36:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
05:50:36:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
05:50:36:  [<c1042852>] ? ktime_get+0x5e/0xd9
05:50:36:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
05:50:36:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
05:50:36:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
05:50:36:  [<c1047272>] ? tick_program_event+0x19/0x1c
05:50:36:  [<c102e915>] ? irq_exit+0x41/0x64
05:50:36:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
05:50:36:  [<c101acf3>] ? do_page_fault+0x0/0x30d
05:50:36:  [<c1305022>] ? error_code+0x5a/0x60
05:50:36:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
05:50:36:  [<c101acf3>] ? do_page_fault+0x0/0x30d
05:50:36: NMI backtrace for cpu 0
05:50:36: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
05:50:36: 
05:50:36: Pid: 0, comm: swapper Not tainted 2.6.38-rc4 #226 0MG532/MXC061                          
05:50:36: EIP: 0060:[<c1019322>] EFLAGS: 00000047 CPU: 0
05:50:36: EIP is at read_hpet+0xe/0x12
05:50:36: EAX: 5d3ce636 EBX: 00f650ae ECX: 00000000 EDX: 00000000
05:50:36: ESI: c1433a80 EDI: 76b86058 EBP: c1421ee8 ESP: c1421ee8
05:50:36:  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
05:50:36: Process swapper (pid: 0, ti=c1420000 task=c142fe20 task.ti=c1420000)
05:50:36: Stack:
05:50:36:  00000000 c1042852 0000b898 c1433a00 0000b982 00000000 f6405f80 00002b31
05:50:36:  f6402cc8 00000000 c1040fb3 974f0854 00002b31 f6402cc8 c1040fe3 c10477b9
05:50:36:  00000000 000003e8 00000000 c1421f6c c102eb08 ffffffcf c1003d1a f60d9440
05:50:36: Call Trace:
05:50:36:  [<c1042852>] ? ktime_get+0x5e/0xd9
05:50:36:  [<c1040fb3>] ? sched_clock_tick+0x4c/0x6e
05:50:36:  [<c1040fe3>] ? sched_clock_idle_wakeup_event+0xe/0x14
05:50:36:  [<c10477b9>] ? tick_check_idle+0x3d/0x82
05:50:36:  [<c102eb08>] ? irq_enter+0x34/0x54
05:50:36:  [<c1003d1a>] ? do_IRQ+0x1e/0x95
05:50:36:  [<c1040c67>] ? sched_clock_local+0x19/0x17c
05:50:36:  [<c1002c69>] ? common_interrupt+0x29/0x30
05:50:36:  [<c115b48b>] ? acpi_idle_enter_bm+0x22c/0x261
05:50:36:  [<c123289f>] ? cpuidle_idle_call+0x67/0x98
05:50:36:  [<c1001ae9>] ? cpu_idle+0x41/0x5c
05:50:36:  [<c14987ce>] ? start_kernel+0x276/0x27b
05:50:36:  [<c149839a>] ? unknown_bootoption+0x0/0x18c
05:50:36: Code: 4f c1 8b 92 f0 00 00 00 29 d0 89 c2 31 c0 81 fa 80 00 00 00 ba c2 ff ff ff 0f 4c c2 c3 55 a1 34 e7 4f c1 89 e5 8b 80 f0 00 00 00 <31> d2 c9 c3 83 3d 38 e7 4f c1 00 75 37 83 3d 20 e7 4f c1 00 74 
05:50:36: Call Trace:
05:50:36:  [<c1042852>] ? ktime_get+0x5e/0xd9
05:50:36:  [<c1040fb3>] ? sched_clock_tick+0x4c/0x6e
05:50:36:  [<c1040fe3>] ? sched_clock_idle_wakeup_event+0xe/0x14
05:50:36:  [<c10477b9>] ? tick_check_idle+0x3d/0x82
05:50:36:  [<c102eb08>] ? irq_enter+0x34/0x54
05:50:36:  [<c1003d1a>] ? do_IRQ+0x1e/0x95
05:50:36:  [<c1040c67>] ? sched_clock_local+0x19/0x17c
05:50:36:  [<c1002c69>] ? common_interrupt+0x29/0x30
05:50:36:  [<c115b48b>] ? acpi_idle_enter_bm+0x22c/0x261
05:50:36:  [<c123289f>] ? cpuidle_idle_call+0x67/0x98
05:50:36:  [<c1001ae9>] ? cpu_idle+0x41/0x5c
05:50:36:  [<c14987ce>] ? start_kernel+0x276/0x27b
05:50:36:  [<c149839a>] ? unknown_bootoption+0x0/0x18c
05:50:36: Pid: 0, comm: swapper Not tainted 2.6.38-rc4 #226
05:50:36: Call Trace:
05:50:36:  [<c10054b6>] ? show_trace+0xf/0x11
05:50:36:  [<c1015eff>] ? arch_trigger_all_cpu_backtrace_handler+0x57/0x73
05:50:36:  [<c104039f>] ? notifier_call_chain+0x23/0x46
05:50:36:  [<c10403e3>] ? atomic_notifier_call_chain+0x1a/0x1d
05:50:36:  [<c1040477>] ? notify_die+0x30/0x34
05:50:36:  [<c1003657>] ? do_nmi+0x68/0x267
05:50:36:  [<c13050d1>] ? nmi_stack_correct+0x28/0x2d
05:50:36:  [<c1019322>] ? read_hpet+0xe/0x12
05:50:36:  [<c1042852>] ? ktime_get+0x5e/0xd9
05:50:36:  [<c1040fb3>] ? sched_clock_tick+0x4c/0x6e
05:50:36:  [<c1040fe3>] ? sched_clock_idle_wakeup_event+0xe/0x14
05:50:36:  [<c10477b9>] ? tick_check_idle+0x3d/0x82
05:50:36:  [<c102eb08>] ? irq_enter+0x34/0x54
05:50:36:  [<c1003d1a>] ? do_IRQ+0x1e/0x95
05:50:36:  [<c1040c67>] ? sched_clock_local+0x19/0x17c
05:50:36:  [<c1002c69>] ? common_interrupt+0x29/0x30
05:50:36:  [<c115b48b>] ? acpi_idle_enter_bm+0x22c/0x261
05:50:36:  [<c123289f>] ? cpuidle_idle_call+0x67/0x98
05:50:36:  [<c1001ae9>] ? cpu_idle+0x41/0x5c
05:50:36:  [<c14987ce>] ? start_kernel+0x276/0x27b
05:50:36:  [<c149839a>] ? unknown_bootoption+0x0/0x18c
05:51:04: INFO: task khugepaged:546 blocked for more than 120 seconds.
05:51:04: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
05:51:04: khugepaged      D f58bfee0     0   546      2 0x00000000
05:51:04:  f613ebe0 00000046 00000002 f58bfee0 00000000 c14eba00 00000000 00000001
05:51:04:  c14eba00 f613ed48 c14eba00 f613ed48 f613ed4c c14eba00 f613ebe0 c14eba00
05:51:04:  0000000a 00000003 004352da 00000002 c106a170 c1493880 00000003 00000041
05:51:04: Call Trace:
05:51:04:  [<c106a170>] ? __alloc_pages_nodemask+0xfd/0x647
05:51:04:  [<c1032cb6>] ? try_to_del_timer_sync+0x61/0x67
05:51:04:  [<c1304649>] ? rwsem_down_failed_common+0x9d/0xc5
05:51:04:  [<c13046c3>] ? call_rwsem_down_read_failed+0x7/0xc
05:51:04:  [<c13040e3>] ? down_read+0x14/0x16
05:51:04:  [<c1089d3b>] ? khugepaged+0x20c/0xb50
05:51:04:  [<c103c967>] ? autoremove_wake_function+0x0/0x31
05:51:04:  [<c1089b2f>] ? khugepaged+0x0/0xb50
05:51:04:  [<c103c677>] ? kthread+0x63/0x68
05:51:04:  [<c103c614>] ? kthread+0x0/0x68
05:51:04:  [<c1002c76>] ? kernel_thread_helper+0x6/0x10
05:51:04: INFO: task firefox-bin:4621 blocked for more than 120 seconds.
05:51:04: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
05:51:04: firefox-bin     D d702bf58     0  4621   3127 0x00000000
05:51:04:  f0dcc000 00200082 00000002 d702bf58 00000001 75d00000 00000000 00000001
05:51:04:  c14eba00 f0dcc168 c14eba00 f0dcc168 f0dcc16c c14eba00 f0dcc000 c14eba00
05:51:04:  764fb000 c10775f2 764fb000 d702bf28 00000000 000007fb f6602018 f0c53b58
05:51:04: Call Trace:
05:51:04:  [<c10775f2>] ? zap_page_range+0x72/0x7c
05:51:04:  [<c10769dc>] ? sys_madvise+0x450/0x468
05:51:04:  [<c1304649>] ? rwsem_down_failed_common+0x9d/0xc5
05:51:04:  [<c13046ce>] ? call_rwsem_down_write_failed+0x6/0x8
05:51:04:  [<c13040cd>] ? down_write+0x1c/0x1e
05:51:04:  [<c107bde1>] ? sys_munmap+0x18/0x35
05:51:04:  [<c1002750>] ? sysenter_do_call+0x12/0x26
05:51:04:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
05:51:46: BUG: soft lockup - CPU#1 stuck for 63s! [firefox-bin:3145]
05:51:46: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
05:51:46: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
05:51:46: 
05:51:46: Pid: 3145, comm: firefox-bin Not tainted 2.6.38-rc4 #226 0MG532/MXC061                          
05:51:46: EIP: 0060:[<c106eda8>] EFLAGS: 00000206 CPU: 1
05:51:46: EIP is at shrink_zone+0x1cb/0x4c3
05:51:46: EAX: 00000c61 EBX: c1492e00 ECX: 0000003d EDX: 0000000c
05:51:46: ESI: f21a3e24 EDI: c1493040 EBP: f21a3dec ESP: f21a3d68
05:51:46:  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
05:51:46: Process firefox-bin (pid: 3145, ti=f21a2000 task=f613c6c0 task.ti=f21a2000)
05:51:46: Stack:
05:51:46:  00000c9f 00000000 00000000 c1492e00 0000c88d 00000020 00000021 c1493098
05:51:46:  00000004 c14930a8 c1493040 c14930a4 c14930a0 c149309c 0000000b 0000a189
05:51:46:  00001e0e 00000000 0000003c 00000000 00000000 00000000 00000000 00000040
05:51:46: Call Trace:
05:51:46:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
05:51:46:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
05:51:46:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
05:51:46:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
05:51:46:  [<c1042852>] ? ktime_get+0x5e/0xd9
05:51:46:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
05:51:46:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
05:51:46:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
05:51:46:  [<c1047272>] ? tick_program_event+0x19/0x1c
05:51:46:  [<c102e915>] ? irq_exit+0x41/0x64
05:51:46:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
05:51:46:  [<c101acf3>] ? do_page_fault+0x0/0x30d
05:51:46:  [<c1305022>] ? error_code+0x5a/0x60
05:51:46:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
05:51:46:  [<c101acf3>] ? do_page_fault+0x0/0x30d
05:51:46: Code: 8b 93 78 02 00 00 8b bb 70 02 00 00 42 47 89 c1 b8 c9 00 00 00 2b 44 24 48 0f af c2 31 d2 f7 f7 8b 7c 24 28 fe 07 fb 89 44 24 68 <89> 4c 24 60 8d 44 01 01 c7 44 24 64 00 00 00 00 c7 44 24 6c 00 
05:51:46: Call Trace:
05:51:46:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
05:51:46:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
05:51:46:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
05:51:46:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
05:51:46:  [<c1042852>] ? ktime_get+0x5e/0xd9
05:51:46:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
05:51:46:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
05:51:46:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
05:51:46:  [<c1047272>] ? tick_program_event+0x19/0x1c
05:51:46:  [<c102e915>] ? irq_exit+0x41/0x64
05:51:46:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
05:51:46:  [<c101acf3>] ? do_page_fault+0x0/0x30d
05:51:46:  [<c1305022>] ? error_code+0x5a/0x60
05:51:46:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
05:51:46:  [<c101acf3>] ? do_page_fault+0x0/0x30d
05:52:54: BUG: soft lockup - CPU#1 stuck for 61s! [firefox-bin:3145]
05:52:54: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
05:52:54: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
05:52:54: 
05:52:54: Pid: 3145, comm: firefox-bin Not tainted 2.6.38-rc4 #226 0MG532/MXC061                          
05:52:54: EIP: 0060:[<c1110a74>] EFLAGS: 00000246 CPU: 1
05:52:54: EIP is at div_u64_rem+0x4/0x2a
05:52:54: EAX: 00000c64 EBX: 00000c64 ECX: 00000ca2 EDX: 00000000
05:52:54: ESI: 00000000 EDI: f21a3d50 EBP: f21a3d30 ESP: f21a3d2c
05:52:54:  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
05:52:54: Process firefox-bin (pid: 3145, ti=f21a2000 task=f613c6c0 task.ti=f21a2000)
05:52:54: Stack:
05:52:54:  00000000 f21a3d60 c1110bcb f21a3d50 00000000 00000000 00000c64 0000007b
05:52:54:  ffff007b 00000c64 00000000 f21a3e24 00000003 f21a3dec c106ee41 00000ca2
05:52:54:  00000000 00000000 c1492e00 0000c88d 00000020 00000021 c1493098 00000004
05:52:54: Call Trace:
05:52:54:  [<c1110bcb>] ? div64_u64+0x25/0xef
05:52:54:  [<c106ee41>] ? shrink_zone+0x264/0x4c3
05:52:54:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
05:52:54:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
05:52:54:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
05:52:54:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
05:52:54:  [<c1042852>] ? ktime_get+0x5e/0xd9
05:52:54:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
05:52:54:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
05:52:54:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
05:52:54:  [<c1047272>] ? tick_program_event+0x19/0x1c
05:52:54:  [<c102e915>] ? irq_exit+0x41/0x64
05:52:54:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
05:52:54:  [<c101acf3>] ? do_page_fault+0x0/0x30d
05:52:54:  [<c1305022>] ? error_code+0x5a/0x60
05:52:54:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
05:52:54:  [<c101acf3>] ? do_page_fault+0x0/0x30d
05:52:54: Code: c0 c3 90 88 c2 83 e0 0f c0 ea 04 0f b6 d2 6b d2 0a 8d 04 02 c3 b9 0a 00 00 00 31 d2 f7 f1 c1 e0 04 01 d0 c3 90 90 90 55 89 e5 56 <89> ce 53 31 c9 89 c3 39 f2 72 08 89 d0 31 d2 f7 f6 89 c1 89 d8 
05:52:54: Call Trace:
05:52:54:  [<c1110bcb>] ? div64_u64+0x25/0xef
05:52:54:  [<c106ee41>] ? shrink_zone+0x264/0x4c3
05:52:54:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
05:52:54:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
05:52:54:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
05:52:54:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
05:52:54:  [<c1042852>] ? ktime_get+0x5e/0xd9
05:52:54:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
05:52:54:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
05:52:54:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
05:52:54:  [<c1047272>] ? tick_program_event+0x19/0x1c
05:52:54:  [<c102e915>] ? irq_exit+0x41/0x64
05:52:54:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
05:52:54:  [<c101acf3>] ? do_page_fault+0x0/0x30d
05:52:54:  [<c1305022>] ? error_code+0x5a/0x60
05:52:54:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
05:52:54:  [<c101acf3>] ? do_page_fault+0x0/0x30d
05:53:04: INFO: task khugepaged:546 blocked for more than 120 seconds.
05:53:04: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
05:53:04: khugepaged      D f58bfee0     0   546      2 0x00000000
05:53:04:  f613ebe0 00000046 00000002 f58bfee0 00000000 c14eba00 00000000 00000001
05:53:04:  c14eba00 f613ed48 c14eba00 f613ed48 f613ed4c c14eba00 f613ebe0 c14eba00
05:53:04:  0000000a 00000003 004352da 00000002 c106a170 c1493880 00000003 00000041
05:53:04: Call Trace:
05:53:04:  [<c106a170>] ? __alloc_pages_nodemask+0xfd/0x647
05:53:04:  [<c1032cb6>] ? try_to_del_timer_sync+0x61/0x67
05:53:04:  [<c1304649>] ? rwsem_down_failed_common+0x9d/0xc5
05:53:04:  [<c13046c3>] ? call_rwsem_down_read_failed+0x7/0xc
05:53:04:  [<c13040e3>] ? down_read+0x14/0x16
05:53:04:  [<c1089d3b>] ? khugepaged+0x20c/0xb50
05:53:04:  [<c103c967>] ? autoremove_wake_function+0x0/0x31
05:53:04:  [<c1089b2f>] ? khugepaged+0x0/0xb50
05:53:04:  [<c103c677>] ? kthread+0x63/0x68
05:53:04:  [<c103c614>] ? kthread+0x0/0x68
05:53:04:  [<c1002c76>] ? kernel_thread_helper+0x6/0x10
05:53:04: INFO: task firefox-bin:4621 blocked for more than 120 seconds.
05:53:04: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
05:53:04: firefox-bin     D d702bf58     0  4621   3127 0x00000000
05:53:04:  f0dcc000 00200082 00000002 d702bf58 00000001 75d00000 00000000 00000001
05:53:04:  c14eba00 f0dcc168 c14eba00 f0dcc168 f0dcc16c c14eba00 f0dcc000 c14eba00
05:53:04:  764fb000 c10775f2 764fb000 d702bf28 00000000 000007fb f6602018 f0c53b58
05:53:04: Call Trace:
05:53:04:  [<c10775f2>] ? zap_page_range+0x72/0x7c
05:53:04:  [<c10769dc>] ? sys_madvise+0x450/0x468
05:53:04:  [<c1304649>] ? rwsem_down_failed_common+0x9d/0xc5
05:53:04:  [<c13046ce>] ? call_rwsem_down_write_failed+0x6/0x8
05:53:04:  [<c13040cd>] ? down_write+0x1c/0x1e
05:53:04:  [<c107bde1>] ? sys_munmap+0x18/0x35
05:53:04:  [<c1002750>] ? sysenter_do_call+0x12/0x26
05:53:04:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
05:53:04: INFO: task udisks-daemon:4202 blocked for more than 120 seconds.
05:53:04: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
05:53:04: udisks-daemon   D f203bf98     0  4202   4201 0x00000000
05:53:04:  f0dc97a0 00000086 00000000 f203bf98 00000000 01605a00 00000000 00000001
05:53:04:  c14eba00 f0dc9908 c14eba00 f0dc9908 f0dc990c c14eba00 f0dc97a0 c14eba00
05:53:04:  000016b2 f6605a00 f0e357a0 f6605a00 f203bc90 c1040c67 abec0261 00002b20
05:53:04: Call Trace:
05:53:04:  [<c1040c67>] ? sched_clock_local+0x19/0x17c
05:53:04:  [<c13039e1>] ? schedule_timeout+0x13/0x96
05:53:04:  [<c10214fd>] ? check_preempt_wakeup+0x97/0xe0
05:53:04:  [<c1020aaa>] ? check_preempt_curr+0x20/0x59
05:53:04:  [<c13038de>] ? wait_for_common+0xbb/0x113
05:53:04:  [<c1027b51>] ? default_wake_function+0x0/0x8
05:53:04:  [<c1039364>] ? wait_on_work+0xa1/0xcc
05:53:04:  [<c1038367>] ? wq_barrier_func+0x0/0x8
05:53:04:  [<c103942c>] ? __cancel_work_timer+0x9d/0xd3
05:53:04:  [<c1103da5>] ? disk_clear_events+0x5c/0xc7
05:53:04:  [<c10abf9b>] ? check_disk_change+0x17/0x40
05:53:04:  [<c11f4de6>] ? cdrom_open+0x378/0x41d
05:53:04:  [<c13038e7>] ? wait_for_common+0xc4/0x113
05:53:04:  [<c1027b51>] ? default_wake_function+0x0/0x8
05:53:04:  [<c110a359>] ? kobject_get+0xf/0x13
05:53:04:  [<c1103f18>] ? get_disk+0x29/0x3f
05:53:04:  [<c1103f35>] ? exact_lock+0x7/0xd
05:53:04:  [<c11c1259>] ? kobj_lookup+0xda/0x105
05:53:04:  [<c110a359>] ? kobject_get+0xf/0x13
05:53:04:  [<c11d8921>] ? sr_block_open+0x70/0x8e
05:53:04:  [<c10aca9d>] ? __blkdev_get+0x7f/0x27f
05:53:04:  [<c10ace29>] ? blkdev_get+0x18c/0x287
05:53:04:  [<c10942c1>] ? do_lookup+0xb5/0x1b4
05:53:04:  [<c10acf24>] ? blkdev_open+0x0/0x5b
05:53:04:  [<c108bad4>] ? __dentry_open+0xf0/0x1c7
05:53:04:  [<c1093b75>] ? generic_permission+0x18/0x8c
05:53:04:  [<c108bc5a>] ? nameidata_to_filp+0x3e/0x49
05:53:04:  [<c10952e9>] ? finish_open+0x81/0x125
05:53:04:  [<c1095d12>] ? do_path_lookup+0x49/0xba
05:53:04:  [<c10968f8>] ? do_filp_open+0x174/0x4c9
05:53:04:  [<c1303ee8>] ? mutex_lock+0xb/0x24
05:53:04:  [<c11d886d>] ? scsi_cd_put+0x25/0x31
05:53:04:  [<c108b8df>] ? do_sys_open+0x4e/0xdd
05:53:04:  [<c108b9bc>] ? sys_open+0x23/0x28
05:53:04:  [<c1002750>] ? sysenter_do_call+0x12/0x26
05:53:36: INFO: rcu_sched_state detected stall on CPU 1 (t=72030 jiffies)
05:53:36: sending NMI to all CPUs:
05:53:36: NMI backtrace for cpu 1
05:53:36: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
05:53:36: 
05:53:36: Pid: 3145, comm: firefox-bin Not tainted 2.6.38-rc4 #226 0MG532/MXC061                          
05:53:36: EIP: 0060:[<c110f7eb>] EFLAGS: 00000082 CPU: 1
05:53:36: EIP is at delay_tsc+0x18/0x55
05:53:36: EAX: b135c5d8 EBX: 00000001 ECX: 00000001 EDX: 00001727
05:53:36: ESI: c1436640 EDI: 00000001 EBP: 001e7a67 ESP: f21a3c20
05:53:36:  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
05:53:36: Process firefox-bin (pid: 3145, ti=f21a2000 task=f613c6c0 task.ti=f21a2000)
05:53:36: Stack:
05:53:36:  00000000 c1436640 00000001 c1436640 00000001 c1436640 c110f7bf c1015f6d
05:53:36:  c13a101a f6602e14 c105c85b c13a901b c13a9102 00000001 0001195e 00000000
05:53:36:  00000000 00000001 00000000 00000001 f21a3d2c c105caf0 f613c6c0 c1032df0
05:53:36: Call Trace:
05:53:36:  [<c110f7bf>] ? __const_udelay+0x18/0x19
05:53:36:  [<c1015f6d>] ? arch_trigger_all_cpu_backtrace+0x52/0x65
05:53:36:  [<c105c85b>] ? __rcu_pending+0x6c/0x277
05:53:36:  [<c105caf0>] ? rcu_check_callbacks+0x8a/0xb6
05:53:36:  [<c1032df0>] ? update_process_times+0x2a/0x53
05:53:36:  [<c1047627>] ? tick_sched_timer+0x64/0x8d
05:53:36:  [<c103f332>] ? __run_hrtimer+0x6d/0xc3
05:53:36:  [<c103f595>] ? hrtimer_interrupt+0x10c/0x213
05:53:36:  [<c10157cc>] ? smp_apic_timer_interrupt+0x6c/0x7d
05:53:36:  [<c1304e02>] ? apic_timer_interrupt+0x2a/0x30
05:53:36:  [<c106eda8>] ? shrink_zone+0x1cb/0x4c3
05:53:36:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
05:53:36:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
05:53:36:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
05:53:36:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
05:53:36:  [<c1042852>] ? ktime_get+0x5e/0xd9
05:53:36:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
05:53:36:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
05:53:36:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
05:53:36:  [<c1047272>] ? tick_program_event+0x19/0x1c
05:53:36:  [<c102e915>] ? irq_exit+0x41/0x64
05:53:36:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
05:53:36:  [<c101acf3>] ? do_page_fault+0x0/0x30d
05:53:36:  [<c1305022>] ? error_code+0x5a/0x60
05:53:36:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
05:53:36:  [<c101acf3>] ? do_page_fault+0x0/0x30d
05:53:36: Code: 69 c0 c7 10 00 00 e9 dc ff ff ff 8d 04 80 e9 d4 ff ff ff 55 89 c5 57 56 53 83 ec 08 64 8b 0d b8 7f 4e c1 8d 76 00 0f ae e8 0f 31 <89> c7 8d 76 00 0f ae e8 0f 31 89 c3 89 c6 29 fb 39 eb 73 21 f3 
05:53:36: Call Trace:
05:53:36:  [<c110f7bf>] ? __const_udelay+0x18/0x19
05:53:36:  [<c1015f6d>] ? arch_trigger_all_cpu_backtrace+0x52/0x65
05:53:36:  [<c105c85b>] ? __rcu_pending+0x6c/0x277
05:53:36:  [<c105caf0>] ? rcu_check_callbacks+0x8a/0xb6
05:53:36:  [<c1032df0>] ? update_process_times+0x2a/0x53
05:53:36:  [<c1047627>] ? tick_sched_timer+0x64/0x8d
05:53:36:  [<c103f332>] ? __run_hrtimer+0x6d/0xc3
05:53:36:  [<c103f595>] ? hrtimer_interrupt+0x10c/0x213
05:53:36:  [<c10157cc>] ? smp_apic_timer_interrupt+0x6c/0x7d
05:53:36:  [<c1304e02>] ? apic_timer_interrupt+0x2a/0x30
05:53:36:  [<c106eda8>] ? shrink_zone+0x1cb/0x4c3
05:53:36:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
05:53:36:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
05:53:36:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
05:53:36:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
05:53:36:  [<c1042852>] ? ktime_get+0x5e/0xd9
05:53:36:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
05:53:36:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
05:53:36:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
05:53:36:  [<c1047272>] ? tick_program_event+0x19/0x1c
05:53:36:  [<c102e915>] ? irq_exit+0x41/0x64
05:53:36:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
05:53:36:  [<c101acf3>] ? do_page_fault+0x0/0x30d
05:53:36:  [<c1305022>] ? error_code+0x5a/0x60
05:53:36:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
05:53:36:  [<c101acf3>] ? do_page_fault+0x0/0x30d
05:53:36: Pid: 3145, comm: firefox-bin Not tainted 2.6.38-rc4 #226
05:53:36: Call Trace:
05:53:36:  [<c10054b6>] ? show_trace+0xf/0x11
05:53:36:  [<c1015eff>] ? arch_trigger_all_cpu_backtrace_handler+0x57/0x73
05:53:36:  [<c104039f>] ? notifier_call_chain+0x23/0x46
05:53:36:  [<c10403e3>] ? atomic_notifier_call_chain+0x1a/0x1d
05:53:36:  [<c1040477>] ? notify_die+0x30/0x34
05:53:36:  [<c1003657>] ? do_nmi+0x68/0x267
05:53:36:  [<c13050d1>] ? nmi_stack_correct+0x28/0x2d
05:53:36:  [<c10100d8>] ? do_machine_check+0x2c0/0x6d2
05:53:36:  [<c110f7eb>] ? delay_tsc+0x18/0x55
05:53:36:  [<c110f7bf>] ? __const_udelay+0x18/0x19
05:53:36:  [<c1015f6d>] ? arch_trigger_all_cpu_backtrace+0x52/0x65
05:53:36:  [<c105c85b>] ? __rcu_pending+0x6c/0x277
05:53:36:  [<c105caf0>] ? rcu_check_callbacks+0x8a/0xb6
05:53:36:  [<c1032df0>] ? update_process_times+0x2a/0x53
05:53:36:  [<c1047627>] ? tick_sched_timer+0x64/0x8d
05:53:36:  [<c103f332>] ? __run_hrtimer+0x6d/0xc3
05:53:36:  [<c103f595>] ? hrtimer_interrupt+0x10c/0x213
05:53:36:  [<c10157cc>] ? smp_apic_timer_interrupt+0x6c/0x7d
05:53:36:  [<c1304e02>] ? apic_timer_interrupt+0x2a/0x30
05:53:36:  [<c106eda8>] ? shrink_zone+0x1cb/0x4c3
05:53:36:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
05:53:36:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
05:53:36:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
05:53:36:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
05:53:36:  [<c1042852>] ? ktime_get+0x5e/0xd9
05:53:36:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
05:53:36:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
05:53:36:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
05:53:36:  [<c1047272>] ? tick_program_event+0x19/0x1c
05:53:36:  [<c102e915>] ? irq_exit+0x41/0x64
05:53:36:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
05:53:36:  [<c101acf3>] ? do_page_fault+0x0/0x30d
05:53:36:  [<c1305022>] ? error_code+0x5a/0x60
05:53:36:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
05:53:36:  [<c101acf3>] ? do_page_fault+0x0/0x30d
05:53:36: NMI backtrace for cpu 0
05:53:36: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
05:53:36: 
05:53:36: Pid: 0, comm: swapper Not tainted 2.6.38-rc4 #226 0MG532/MXC061                          
05:53:36: EIP: 0060:[<c1014d6d>] EFLAGS: 00000002 CPU: 0
05:53:36: EIP is at lapic_timer_setup+0x1e/0x6d
05:53:36: EAX: 00000003 EBX: 00000046 ECX: 00000001 EDX: 00000000
05:53:36: ESI: 00000003 EDI: c14e8cc8 EBP: 00000000 ESP: c1421f14
05:53:36:  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
05:53:36: Process swapper (pid: 0, ti=c1420000 task=c142fe20 task.ti=c1420000)
05:53:36: Stack:
05:53:36:  f6401fc0 c1046378 00000000 000003e8 c104778c 00000000 000003e8 00000000
05:53:36:  c1421f6c c102eb08 ffffffcf c1003d1a f60d9440 c1421f9c c1040c67 861aa2e1
05:53:36:  00002b5b 00000000 000003e8 f60d9440 f60d9000 c1002c69 00000000 00002b5b
05:53:36: Call Trace:
05:53:36:  [<c1046378>] ? clockevents_set_mode+0x12/0x3b
05:53:36:  [<c104778c>] ? tick_check_idle+0x10/0x82
05:53:36:  [<c102eb08>] ? irq_enter+0x34/0x54
05:53:36:  [<c1003d1a>] ? do_IRQ+0x1e/0x95
05:53:36:  [<c1040c67>] ? sched_clock_local+0x19/0x17c
05:53:36:  [<c1002c69>] ? common_interrupt+0x29/0x30
05:53:36:  [<c115b48b>] ? acpi_idle_enter_bm+0x22c/0x261
05:53:36:  [<c123289f>] ? cpuidle_idle_call+0x67/0x98
05:53:36:  [<c1001ae9>] ? cpu_idle+0x41/0x5c
05:53:36:  [<c14987ce>] ? start_kernel+0x276/0x27b
05:53:36:  [<c149839a>] ? unknown_bootoption+0x0/0x18c
05:53:36: Code: 80 03 00 00 ff 91 a8 00 00 00 31 c0 c3 53 f6 42 04 08 75 64 9c 5b fa 83 f8 01 76 1e 83 f8 03 77 55 31 d2 b9 01 00 00 00 83 f8 02 <a1> cc af 4f c1 0f 95 c2 e8 2a ff ff ff eb 3c 8b 15 b4 37 43 c1 
05:53:36: Call Trace:
05:53:36:  [<c1046378>] ? clockevents_set_mode+0x12/0x3b
05:53:36:  [<c104778c>] ? tick_check_idle+0x10/0x82
05:53:36:  [<c102eb08>] ? irq_enter+0x34/0x54
05:53:36:  [<c1003d1a>] ? do_IRQ+0x1e/0x95
05:53:36:  [<c1040c67>] ? sched_clock_local+0x19/0x17c
05:53:36:  [<c1002c69>] ? common_interrupt+0x29/0x30
05:53:36:  [<c115b48b>] ? acpi_idle_enter_bm+0x22c/0x261
05:53:36:  [<c123289f>] ? cpuidle_idle_call+0x67/0x98
05:53:36:  [<c1001ae9>] ? cpu_idle+0x41/0x5c
05:53:36:  [<c14987ce>] ? start_kernel+0x276/0x27b
05:53:36:  [<c149839a>] ? unknown_bootoption+0x0/0x18c
05:53:36: Pid: 0, comm: swapper Not tainted 2.6.38-rc4 #226
05:53:36: Call Trace:
05:53:36:  [<c10054b6>] ? show_trace+0xf/0x11
05:53:36:  [<c1015eff>] ? arch_trigger_all_cpu_backtrace_handler+0x57/0x73
05:53:36:  [<c104039f>] ? notifier_call_chain+0x23/0x46
05:53:36:  [<c10403e3>] ? atomic_notifier_call_chain+0x1a/0x1d
05:53:36:  [<c1040477>] ? notify_die+0x30/0x34
05:53:36:  [<c1003657>] ? do_nmi+0x68/0x267
05:53:36:  [<c13050d1>] ? nmi_stack_correct+0x28/0x2d
05:53:36:  [<c1014d6d>] ? lapic_timer_setup+0x1e/0x6d
05:53:36:  [<c1046378>] ? clockevents_set_mode+0x12/0x3b
05:53:36:  [<c104778c>] ? tick_check_idle+0x10/0x82
05:53:36:  [<c102eb08>] ? irq_enter+0x34/0x54
05:53:36:  [<c1003d1a>] ? do_IRQ+0x1e/0x95
05:53:36:  [<c1040c67>] ? sched_clock_local+0x19/0x17c
05:53:36:  [<c1002c69>] ? common_interrupt+0x29/0x30
05:53:36:  [<c115b48b>] ? acpi_idle_enter_bm+0x22c/0x261
05:53:36:  [<c123289f>] ? cpuidle_idle_call+0x67/0x98
05:53:36:  [<c1001ae9>] ? cpu_idle+0x41/0x5c
05:53:36:  [<c14987ce>] ? start_kernel+0x276/0x27b
05:53:36:  [<c149839a>] ? unknown_bootoption+0x0/0x18c
05:54:46: BUG: soft lockup - CPU#1 stuck for 64s! [firefox-bin:3145]
05:54:46: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
05:54:46: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
05:54:46: 
05:54:46: Pid: 3145, comm: firefox-bin Not tainted 2.6.38-rc4 #226 0MG532/MXC061                          
05:54:46: EIP: 0060:[<c106eda8>] EFLAGS: 00000202 CPU: 1
05:54:46: EIP is at shrink_zone+0x1cb/0x4c3
05:54:46: EAX: 00000c6e EBX: c1492e00 ECX: 0000003d EDX: 00000030
05:54:46: ESI: f21a3e24 EDI: c1493040 EBP: f21a3dec ESP: f21a3d68
05:54:46:  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
05:54:46: Process firefox-bin (pid: 3145, ti=f21a2000 task=f613c6c0 task.ti=f21a2000)
05:54:46: Stack:
05:54:46:  00000cac 00000000 00000000 c1492e00 0000c88d 00000020 00000021 c1493098
05:54:46:  00000004 c14930a8 c1493040 c14930a4 c14930a0 c149309c 0000000b 0000a189
05:54:46:  00001e16 00000000 0000003c 00000000 00000000 00000000 00000000 00000040
05:54:46: Call Trace:
05:54:46:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
05:54:46:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
05:54:46:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
05:54:46:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
05:54:46:  [<c1042852>] ? ktime_get+0x5e/0xd9
05:54:46:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
05:54:46:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
05:54:46:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
05:54:46:  [<c1047272>] ? tick_program_event+0x19/0x1c
05:54:46:  [<c102e915>] ? irq_exit+0x41/0x64
05:54:46:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
05:54:46:  [<c101acf3>] ? do_page_fault+0x0/0x30d
05:54:46:  [<c1305022>] ? error_code+0x5a/0x60
05:54:46:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
05:54:46:  [<c101acf3>] ? do_page_fault+0x0/0x30d
05:54:46: Code: 8b 93 78 02 00 00 8b bb 70 02 00 00 42 47 89 c1 b8 c9 00 00 00 2b 44 24 48 0f af c2 31 d2 f7 f7 8b 7c 24 28 fe 07 fb 89 44 24 68 <89> 4c 24 60 8d 44 01 01 c7 44 24 64 00 00 00 00 c7 44 24 6c 00 
05:54:46: Call Trace:
05:54:46:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
05:54:46:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
05:54:46:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
05:54:46:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
05:54:46:  [<c1042852>] ? ktime_get+0x5e/0xd9
05:54:46:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
05:54:46:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
05:54:46:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
05:54:46:  [<c1047272>] ? tick_program_event+0x19/0x1c
05:54:46:  [<c102e915>] ? irq_exit+0x41/0x64
05:54:46:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
05:54:46:  [<c101acf3>] ? do_page_fault+0x0/0x30d
05:54:46:  [<c1305022>] ? error_code+0x5a/0x60
05:54:46:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
05:54:46:  [<c101acf3>] ? do_page_fault+0x0/0x30d
05:55:04: INFO: task khugepaged:546 blocked for more than 120 seconds.
05:55:04: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
05:55:04: khugepaged      D f58bfee0     0   546      2 0x00000000
05:55:04:  f613ebe0 00000046 00000002 f58bfee0 00000000 c14eba00 00000000 00000001
05:55:04:  c14eba00 f613ed48 c14eba00 f613ed48 f613ed4c c14eba00 f613ebe0 c14eba00
05:55:04:  0000000a 00000003 004352da 00000002 c106a170 c1493880 00000003 00000041
05:55:04: Call Trace:
05:55:04:  [<c106a170>] ? __alloc_pages_nodemask+0xfd/0x647
05:55:04:  [<c1032cb6>] ? try_to_del_timer_sync+0x61/0x67
05:55:04:  [<c1304649>] ? rwsem_down_failed_common+0x9d/0xc5
05:55:04:  [<c13046c3>] ? call_rwsem_down_read_failed+0x7/0xc
05:55:04:  [<c13040e3>] ? down_read+0x14/0x16
05:55:04:  [<c1089d3b>] ? khugepaged+0x20c/0xb50
05:55:04:  [<c103c967>] ? autoremove_wake_function+0x0/0x31
05:55:04:  [<c1089b2f>] ? khugepaged+0x0/0xb50
05:55:04:  [<c103c677>] ? kthread+0x63/0x68
05:55:04:  [<c103c614>] ? kthread+0x0/0x68
05:55:04:  [<c1002c76>] ? kernel_thread_helper+0x6/0x10
05:55:04: INFO: task firefox-bin:4621 blocked for more than 120 seconds.
05:55:04: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
05:55:04: firefox-bin     D d702bf58     0  4621   3127 0x00000000
05:55:04:  f0dcc000 00200082 00000002 d702bf58 00000001 75d00000 00000000 00000001
05:55:04:  c14eba00 f0dcc168 c14eba00 f0dcc168 f0dcc16c c14eba00 f0dcc000 c14eba00
05:55:04:  764fb000 c10775f2 764fb000 d702bf28 00000000 000007fb f6602018 f0c53b58
05:55:04: Call Trace:
05:55:04:  [<c10775f2>] ? zap_page_range+0x72/0x7c
05:55:04:  [<c10769dc>] ? sys_madvise+0x450/0x468
05:55:04:  [<c1304649>] ? rwsem_down_failed_common+0x9d/0xc5
05:55:04:  [<c13046ce>] ? call_rwsem_down_write_failed+0x6/0x8
05:55:04:  [<c13040cd>] ? down_write+0x1c/0x1e
05:55:04:  [<c107bde1>] ? sys_munmap+0x18/0x35
05:55:04:  [<c1002750>] ? sysenter_do_call+0x12/0x26
05:55:04:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
05:55:04: INFO: task udisks-daemon:4202 blocked for more than 120 seconds.
05:55:04: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
05:55:04: udisks-daemon   D f203bf98     0  4202   4201 0x00000000
05:55:04:  f0dc97a0 00000086 00000000 f203bf98 00000000 01605a00 00000000 00000001
05:55:04:  c14eba00 f0dc9908 c14eba00 f0dc9908 f0dc990c c14eba00 f0dc97a0 c14eba00
05:55:04:  000016b2 f6605a00 f0e357a0 f6605a00 f203bc90 c1040c67 abec0261 00002b20
05:55:04: Call Trace:
05:55:04:  [<c1040c67>] ? sched_clock_local+0x19/0x17c
05:55:04:  [<c13039e1>] ? schedule_timeout+0x13/0x96
05:55:04:  [<c10214fd>] ? check_preempt_wakeup+0x97/0xe0
05:55:04:  [<c1020aaa>] ? check_preempt_curr+0x20/0x59
05:55:04:  [<c13038de>] ? wait_for_common+0xbb/0x113
05:55:04:  [<c1027b51>] ? default_wake_function+0x0/0x8
05:55:04:  [<c1039364>] ? wait_on_work+0xa1/0xcc
05:55:04:  [<c1038367>] ? wq_barrier_func+0x0/0x8
05:55:04:  [<c103942c>] ? __cancel_work_timer+0x9d/0xd3
05:55:04:  [<c1103da5>] ? disk_clear_events+0x5c/0xc7
05:55:04:  [<c10abf9b>] ? check_disk_change+0x17/0x40
05:55:04:  [<c11f4de6>] ? cdrom_open+0x378/0x41d
05:55:04:  [<c13038e7>] ? wait_for_common+0xc4/0x113
05:55:04:  [<c1027b51>] ? default_wake_function+0x0/0x8
05:55:04:  [<c110a359>] ? kobject_get+0xf/0x13
05:55:04:  [<c1103f18>] ? get_disk+0x29/0x3f
05:55:04:  [<c1103f35>] ? exact_lock+0x7/0xd
05:55:04:  [<c11c1259>] ? kobj_lookup+0xda/0x105
05:55:04:  [<c110a359>] ? kobject_get+0xf/0x13
05:55:04:  [<c11d8921>] ? sr_block_open+0x70/0x8e
05:55:04:  [<c10aca9d>] ? __blkdev_get+0x7f/0x27f
05:55:04:  [<c10ace29>] ? blkdev_get+0x18c/0x287
05:55:04:  [<c10942c1>] ? do_lookup+0xb5/0x1b4
05:55:04:  [<c10acf24>] ? blkdev_open+0x0/0x5b
05:55:04:  [<c108bad4>] ? __dentry_open+0xf0/0x1c7
05:55:04:  [<c1093b75>] ? generic_permission+0x18/0x8c
05:55:04:  [<c108bc5a>] ? nameidata_to_filp+0x3e/0x49
05:55:04:  [<c10952e9>] ? finish_open+0x81/0x125
05:55:04:  [<c1095d12>] ? do_path_lookup+0x49/0xba
05:55:04:  [<c10968f8>] ? do_filp_open+0x174/0x4c9
05:55:04:  [<c1303ee8>] ? mutex_lock+0xb/0x24
05:55:04:  [<c11d886d>] ? scsi_cd_put+0x25/0x31
05:55:04:  [<c108b8df>] ? do_sys_open+0x4e/0xdd
05:55:04:  [<c108b9bc>] ? sys_open+0x23/0x28
05:55:04:  [<c1002750>] ? sysenter_do_call+0x12/0x26
05:55:58: BUG: soft lockup - CPU#1 stuck for 63s! [firefox-bin:3145]
05:55:58: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
05:55:58: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
05:55:58: 
05:55:58: Pid: 3145, comm: firefox-bin Not tainted 2.6.38-rc4 #226 0MG532/MXC061                          
05:55:58: EIP: 0060:[<c1110a70>] EFLAGS: 00000246 CPU: 1
05:55:58: EIP is at div_u64_rem+0x0/0x2a
05:55:58: EAX: 000005f5 EBX: 000005f5 ECX: 00000cb3 EDX: 00000000
05:55:58: ESI: 00000000 EDI: f21a3d50 EBP: f21a3d60 ESP: f21a3d34
05:55:58:  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
05:55:58: Process firefox-bin (pid: 3145, ti=f21a2000 task=f613c6c0 task.ti=f21a2000)
05:55:58: Stack:
05:55:58:  c1110bcb f21a3d50 00000000 00000000 00000c75 0000007b ffff007b 00000c75
05:55:58:  00000000 f21a3e24 00000000 f21a3dec c106ee41 00000cb3 00000000 00000000
05:55:58:  c1492e00 0000c88d 00000020 00000021 c1493098 00000001 c14930a8 c1493040
05:55:58: Call Trace:
05:55:58:  [<c1110bcb>] ? div64_u64+0x25/0xef
05:55:58:  [<c106ee41>] ? shrink_zone+0x264/0x4c3
05:55:58:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
05:55:58:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
05:55:58:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
05:55:58:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
05:55:58:  [<c1042852>] ? ktime_get+0x5e/0xd9
05:55:58:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
05:55:58:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
05:55:58:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
05:55:58:  [<c1047272>] ? tick_program_event+0x19/0x1c
05:55:58:  [<c102e915>] ? irq_exit+0x41/0x64
05:55:58:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
05:55:58:  [<c101acf3>] ? do_page_fault+0x0/0x30d
05:55:58:  [<c1305022>] ? error_code+0x5a/0x60
05:55:58:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
05:55:58:  [<c101acf3>] ? do_page_fault+0x0/0x30d
05:55:58: Code: 04 82 c3 31 c0 c3 90 88 c2 83 e0 0f c0 ea 04 0f b6 d2 6b d2 0a 8d 04 02 c3 b9 0a 00 00 00 31 d2 f7 f1 c1 e0 04 01 d0 c3 90 90 90 <55> 89 e5 56 89 ce 53 31 c9 89 c3 39 f2 72 08 89 d0 31 d2 f7 f6 
05:55:58: Call Trace:
05:55:58:  [<c1110bcb>] ? div64_u64+0x25/0xef
05:55:58:  [<c106ee41>] ? shrink_zone+0x264/0x4c3
05:55:58:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
05:55:58:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
05:55:58:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
05:55:58:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
05:55:58:  [<c1042852>] ? ktime_get+0x5e/0xd9
05:55:58:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
05:55:58:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
05:55:58:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
05:55:58:  [<c1047272>] ? tick_program_event+0x19/0x1c
05:55:58:  [<c102e915>] ? irq_exit+0x41/0x64
05:55:58:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
05:55:58:  [<c101acf3>] ? do_page_fault+0x0/0x30d
05:55:58:  [<c1305022>] ? error_code+0x5a/0x60
05:55:58:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
05:55:58:  [<c101acf3>] ? do_page_fault+0x0/0x30d
05:56:36: INFO: rcu_sched_state detected stall on CPU 1 (t=126060 jiffies)
05:56:36: sending NMI to all CPUs:
05:56:36: NMI backtrace for cpu 1
05:56:36: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
05:56:36: 
05:56:36: Pid: 3145, comm: firefox-bin Not tainted 2.6.38-rc4 #226 0MG532/MXC061                          
05:56:36: EIP: 0060:[<c110f7eb>] EFLAGS: 00000082 CPU: 1
05:56:36: EIP is at delay_tsc+0x18/0x55
05:56:36: EAX: 725f9944 EBX: 00000001 ECX: 00000001 EDX: 0000177b
05:56:36: ESI: c1436640 EDI: 00000001 EBP: 001e7a67 ESP: f21a3c20
05:56:36:  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
05:56:36: Process firefox-bin (pid: 3145, ti=f21a2000 task=f613c6c0 task.ti=f21a2000)
05:56:36: Stack:
05:56:36:  00000000 c1436640 00000001 c1436640 00000001 c1436640 c110f7bf c1015f6d
05:56:36:  c13a101a f6602e14 c105c85b c13a901b c13a9102 00000001 0001ec6c 00000000
05:56:36:  00000000 00000001 00000000 00000001 f21a3d2c c105caf0 f613c6c0 c1032df0
05:56:36: Call Trace:
05:56:36:  [<c110f7bf>] ? __const_udelay+0x18/0x19
05:56:36:  [<c1015f6d>] ? arch_trigger_all_cpu_backtrace+0x52/0x65
05:56:36:  [<c105c85b>] ? __rcu_pending+0x6c/0x277
05:56:36:  [<c105caf0>] ? rcu_check_callbacks+0x8a/0xb6
05:56:36:  [<c1032df0>] ? update_process_times+0x2a/0x53
05:56:36:  [<c1047627>] ? tick_sched_timer+0x64/0x8d
05:56:36:  [<c103f332>] ? __run_hrtimer+0x6d/0xc3
05:56:36:  [<c103f595>] ? hrtimer_interrupt+0x10c/0x213
05:56:36:  [<c102e915>] ? irq_exit+0x41/0x64
05:56:36:  [<c10157cc>] ? smp_apic_timer_interrupt+0x6c/0x7d
05:56:36:  [<c1304e02>] ? apic_timer_interrupt+0x2a/0x30
05:56:36:  [<c106ee01>] ? shrink_zone+0x224/0x4c3
05:56:36:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
05:56:36:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
05:56:36:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
05:56:36:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
05:56:36:  [<c1042852>] ? ktime_get+0x5e/0xd9
05:56:36:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
05:56:36:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
05:56:36:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
05:56:36:  [<c1047272>] ? tick_program_event+0x19/0x1c
05:56:36:  [<c102e915>] ? irq_exit+0x41/0x64
05:56:36:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
05:56:36:  [<c101acf3>] ? do_page_fault+0x0/0x30d
05:56:36:  [<c1305022>] ? error_code+0x5a/0x60
05:56:36:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
05:56:36:  [<c101acf3>] ? do_page_fault+0x0/0x30d
05:56:36: Code: 69 c0 c7 10 00 00 e9 dc ff ff ff 8d 04 80 e9 d4 ff ff ff 55 89 c5 57 56 53 83 ec 08 64 8b 0d b8 7f 4e c1 8d 76 00 0f ae e8 0f 31 <89> c7 8d 76 00 0f ae e8 0f 31 89 c3 89 c6 29 fb 39 eb 73 21 f3 
05:56:36: Call Trace:
05:56:36:  [<c110f7bf>] ? __const_udelay+0x18/0x19
05:56:36:  [<c1015f6d>] ? arch_trigger_all_cpu_backtrace+0x52/0x65
05:56:36:  [<c105c85b>] ? __rcu_pending+0x6c/0x277
05:56:36:  [<c105caf0>] ? rcu_check_callbacks+0x8a/0xb6
05:56:36:  [<c1032df0>] ? update_process_times+0x2a/0x53
05:56:36:  [<c1047627>] ? tick_sched_timer+0x64/0x8d
05:56:36:  [<c103f332>] ? __run_hrtimer+0x6d/0xc3
05:56:36:  [<c103f595>] ? hrtimer_interrupt+0x10c/0x213
05:56:36:  [<c102e915>] ? irq_exit+0x41/0x64
05:56:36:  [<c10157cc>] ? smp_apic_timer_interrupt+0x6c/0x7d
05:56:36:  [<c1304e02>] ? apic_timer_interrupt+0x2a/0x30
05:56:36:  [<c106ee01>] ? shrink_zone+0x224/0x4c3
05:56:36:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
05:56:36:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
05:56:36:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
05:56:36:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
05:56:36:  [<c1042852>] ? ktime_get+0x5e/0xd9
05:56:36:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
05:56:36:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
05:56:36:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
05:56:36:  [<c1047272>] ? tick_program_event+0x19/0x1c
05:56:36:  [<c102e915>] ? irq_exit+0x41/0x64
05:56:36:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
05:56:36:  [<c101acf3>] ? do_page_fault+0x0/0x30d
05:56:36:  [<c1305022>] ? error_code+0x5a/0x60
05:56:36:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
05:56:36:  [<c101acf3>] ? do_page_fault+0x0/0x30d
05:56:36: Pid: 3145, comm: firefox-bin Not tainted 2.6.38-rc4 #226
05:56:36: Call Trace:
05:56:36:  [<c10054b6>] ? show_trace+0xf/0x11
05:56:36:  [<c1015eff>] ? arch_trigger_all_cpu_backtrace_handler+0x57/0x73
05:56:36:  [<c104039f>] ? notifier_call_chain+0x23/0x46
05:56:36:  [<c10403e3>] ? atomic_notifier_call_chain+0x1a/0x1d
05:56:36:  [<c1040477>] ? notify_die+0x30/0x34
05:56:36:  [<c1003657>] ? do_nmi+0x68/0x267
05:56:36:  [<c106205f>] ? perf_ctx_adjust_freq+0x15/0x13d
05:56:36:  [<c13050d1>] ? nmi_stack_correct+0x28/0x2d
05:56:36:  [<c10100d8>] ? do_machine_check+0x2c0/0x6d2
05:56:36:  [<c110f7eb>] ? delay_tsc+0x18/0x55
05:56:36:  [<c110f7bf>] ? __const_udelay+0x18/0x19
05:56:36:  [<c1015f6d>] ? arch_trigger_all_cpu_backtrace+0x52/0x65
05:56:36:  [<c105c85b>] ? __rcu_pending+0x6c/0x277
05:56:36:  [<c105caf0>] ? rcu_check_callbacks+0x8a/0xb6
05:56:36:  [<c1032df0>] ? update_process_times+0x2a/0x53
05:56:36:  [<c1047627>] ? tick_sched_timer+0x64/0x8d
05:56:36:  [<c103f332>] ? __run_hrtimer+0x6d/0xc3
05:56:36:  [<c103f595>] ? hrtimer_interrupt+0x10c/0x213
05:56:36:  [<c102e915>] ? irq_exit+0x41/0x64
05:56:36:  [<c10157cc>] ? smp_apic_timer_interrupt+0x6c/0x7d
05:56:36:  [<c1304e02>] ? apic_timer_interrupt+0x2a/0x30
05:56:36:  [<c106ee01>] ? shrink_zone+0x224/0x4c3
05:56:36:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
05:56:36:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
05:56:36:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
05:56:36:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
05:56:36:  [<c1042852>] ? ktime_get+0x5e/0xd9
05:56:36:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
05:56:36:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
05:56:36:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
05:56:36:  [<c1047272>] ? tick_program_event+0x19/0x1c
05:56:36:  [<c102e915>] ? irq_exit+0x41/0x64
05:56:36:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
05:56:36:  [<c101acf3>] ? do_page_fault+0x0/0x30d
05:56:36:  [<c1305022>] ? error_code+0x5a/0x60
05:56:36:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
05:56:36:  [<c101acf3>] ? do_page_fault+0x0/0x30d
05:56:36: NMI backtrace for cpu 0
05:56:36: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
05:56:36: 
05:56:36: Pid: 0, comm: swapper Not tainted 2.6.38-rc4 #226 0MG532/MXC061                          
05:56:36: EIP: 0060:[<c1040d1a>] EFLAGS: 00000097 CPU: 0
05:56:36: EIP is at sched_clock_local+0xcc/0x17c
05:56:36: EAX: ffa067a7 EBX: 00002b85 ECX: 751922a4 EDX: ffffffff
05:56:36: ESI: 74e646a8 EDI: 00002b85 EBP: c1421f9c ESP: c1421f50
05:56:36:  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
05:56:36: Process swapper (pid: 0, ti=c1420000 task=c142fe20 task.ti=c1420000)
05:56:36: Stack:
05:56:36:  74e64792 00002b85 00002b85 c1435bd0 00000000 00000004 000000ea 00000000
05:56:36:  ffffffff ffffffff f6405f90 f6405f80 ffa067a7 ffffffff 74b98a4b 00002b85
05:56:36:  00000000 000003e8 f60d9440 f60d9000 c1040fe3 c115b486 00000000 002ca4b6
05:56:36: Call Trace:
05:56:36:  [<c1040fe3>] ? sched_clock_idle_wakeup_event+0xe/0x14
05:56:36:  [<c115b486>] ? acpi_idle_enter_bm+0x227/0x261
05:56:36:  [<c123289f>] ? cpuidle_idle_call+0x67/0x98
05:56:36:  [<c1001ae9>] ? cpu_idle+0x41/0x5c
05:56:36:  [<c14987ce>] ? start_kernel+0x276/0x27b
05:56:36:  [<c149839a>] ? unknown_bootoption+0x0/0x18c
05:56:36: Code: 8b 74 24 38 8b 7c 24 3c eb 04 89 ce 89 df 81 c1 fc db 32 00 8b 44 24 38 83 d3 00 8b 54 24 3c 29 c8 19 da 89 44 24 30 89 54 24 34 <83> fa 00 7c 0f 7f 05 83 f8 00 76 08 8b 4c 24 38 8b 5c 24 3c 8b 
05:56:36: Call Trace:
05:56:36:  [<c1040fe3>] ? sched_clock_idle_wakeup_event+0xe/0x14
05:56:36:  [<c115b486>] ? acpi_idle_enter_bm+0x227/0x261
05:56:36:  [<c123289f>] ? cpuidle_idle_call+0x67/0x98
05:56:36:  [<c1001ae9>] ? cpu_idle+0x41/0x5c
05:56:36:  [<c14987ce>] ? start_kernel+0x276/0x27b
05:56:36:  [<c149839a>] ? unknown_bootoption+0x0/0x18c
05:56:36: Pid: 0, comm: swapper Not tainted 2.6.38-rc4 #226
05:56:36: Call Trace:
05:56:36:  [<c10054b6>] ? show_trace+0xf/0x11
05:56:36:  [<c1015eff>] ? arch_trigger_all_cpu_backtrace_handler+0x57/0x73
05:56:36:  [<c104039f>] ? notifier_call_chain+0x23/0x46
05:56:36:  [<c10403e3>] ? atomic_notifier_call_chain+0x1a/0x1d
05:56:36:  [<c1040477>] ? notify_die+0x30/0x34
05:56:36:  [<c1003657>] ? do_nmi+0x68/0x267
05:56:36:  [<c13050d1>] ? nmi_stack_correct+0x28/0x2d
05:56:36:  [<c1040d1a>] ? sched_clock_local+0xcc/0x17c
05:56:36:  [<c1040fe3>] ? sched_clock_idle_wakeup_event+0xe/0x14
05:56:36:  [<c115b486>] ? acpi_idle_enter_bm+0x227/0x261
05:56:36:  [<c123289f>] ? cpuidle_idle_call+0x67/0x98
05:56:36:  [<c1001ae9>] ? cpu_idle+0x41/0x5c
05:56:36:  [<c14987ce>] ? start_kernel+0x276/0x27b
05:56:36:  [<c149839a>] ? unknown_bootoption+0x0/0x18c
05:57:44: BUG: soft lockup - CPU#1 stuck for 61s! [firefox-bin:3145]
05:57:44: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
05:57:44: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
05:57:44: 
05:57:44: Pid: 3145, comm: firefox-bin Not tainted 2.6.38-rc4 #226 0MG532/MXC061                          
05:57:44: EIP: 0060:[<c1110a8b>] EFLAGS: 00000293 CPU: 1
05:57:44: EIP is at div_u64_rem+0x1b/0x2a
05:57:44: EAX: 00000000 EBX: 00000c7c ECX: 00000000 EDX: 00000c7c
05:57:44: ESI: 00000cba EDI: f21a3d50 EBP: f21a3d30 ESP: f21a3d28
05:57:44:  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
05:57:44: Process firefox-bin (pid: 3145, ti=f21a2000 task=f613c6c0 task.ti=f21a2000)
05:57:44: Stack:
05:57:44:  00000c7c 00000000 f21a3d60 c1110bcb f21a3d50 00000000 00000000 00000c7c
05:57:44:  c111007b 0000007b 000004c4 00000000 f21a3e24 00000002 f21a3dec c106ee41
05:57:44:  00000cba 00000000 00000000 c1492e00 0000c88d 00000020 00000021 c1493098
05:57:44: Call Trace:
05:57:44:  [<c1110bcb>] ? div64_u64+0x25/0xef
05:57:44:  [<c111007b>] ? __put_user_8+0xf/0x19
05:57:44:  [<c106ee41>] ? shrink_zone+0x264/0x4c3
05:57:44:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
05:57:44:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
05:57:44:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
05:57:44:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
05:57:44:  [<c1042852>] ? ktime_get+0x5e/0xd9
05:57:44:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
05:57:44:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
05:57:44:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
05:57:44:  [<c1047272>] ? tick_program_event+0x19/0x1c
05:57:44:  [<c102e915>] ? irq_exit+0x41/0x64
05:57:44:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
05:57:44:  [<c101acf3>] ? do_page_fault+0x0/0x30d
05:57:44:  [<c1305022>] ? error_code+0x5a/0x60
05:57:44:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
05:57:44:  [<c101acf3>] ? do_page_fault+0x0/0x30d
05:57:44: Code: 00 00 00 31 d2 f7 f1 c1 e0 04 01 d0 c3 90 90 90 55 89 e5 56 89 ce 53 31 c9 89 c3 39 f2 72 08 89 d0 31 d2 f7 f6 89 c1 89 d8 f7 f6 <89> c3 8b 45 08 89 10 89 d8 89 ca 5b 5e c9 c3 55 89 c5 57 56 89 
05:57:44: Call Trace:
05:57:44:  [<c1110bcb>] ? div64_u64+0x25/0xef
05:57:44:  [<c111007b>] ? __put_user_8+0xf/0x19
05:57:44:  [<c106ee41>] ? shrink_zone+0x264/0x4c3
05:57:44:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
05:57:44:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
05:57:44:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
05:57:44:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
05:57:44:  [<c1042852>] ? ktime_get+0x5e/0xd9
05:57:44:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
05:57:44:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
05:57:44:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
05:57:44:  [<c1047272>] ? tick_program_event+0x19/0x1c
05:57:44:  [<c102e915>] ? irq_exit+0x41/0x64
05:57:44:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
05:57:44:  [<c101acf3>] ? do_page_fault+0x0/0x30d
05:57:44:  [<c1305022>] ? error_code+0x5a/0x60
05:57:44:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
05:57:44:  [<c101acf3>] ? do_page_fault+0x0/0x30d
05:58:55: BUG: soft lockup - CPU#1 stuck for 63s! [firefox-bin:3145]
05:58:55: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
05:58:55: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
05:58:55: 
05:58:55: Pid: 3145, comm: firefox-bin Not tainted 2.6.38-rc4 #226 0MG532/MXC061                          
05:58:55: EIP: 0060:[<c1110a70>] EFLAGS: 00000246 CPU: 1
05:58:55: EIP is at div_u64_rem+0x0/0x2a
05:58:55: EAX: 00000c7f EBX: 00000c7f ECX: 00000cbd EDX: 00000000
05:58:55: ESI: 00000000 EDI: f21a3d50 EBP: f21a3d60 ESP: f21a3d34
05:58:55:  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
05:58:55: Process firefox-bin (pid: 3145, ti=f21a2000 task=f613c6c0 task.ti=f21a2000)
05:58:55: Stack:
05:58:55:  c1110bcb f21a3d50 00000000 00000000 00000c7f c111007b 0000007b 000004c4
05:58:55:  00000000 f21a3e24 00000002 f21a3dec c106ee41 00000cbd 00000000 00000000
05:58:55:  c1492e00 0000c88d 00000020 00000021 c1493098 00000003 c14930a8 c1493040
05:58:55: Call Trace:
05:58:55:  [<c1110bcb>] ? div64_u64+0x25/0xef
05:58:55:  [<c111007b>] ? __put_user_8+0xf/0x19
05:58:55:  [<c106ee41>] ? shrink_zone+0x264/0x4c3
05:58:55:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
05:58:55:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
05:58:55:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
05:58:55:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
05:58:55:  [<c1042852>] ? ktime_get+0x5e/0xd9
05:58:55:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
05:58:55:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
05:58:55:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
05:58:55:  [<c1047272>] ? tick_program_event+0x19/0x1c
05:58:55:  [<c102e915>] ? irq_exit+0x41/0x64
05:58:55:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
05:58:55:  [<c101acf3>] ? do_page_fault+0x0/0x30d
05:58:55:  [<c1305022>] ? error_code+0x5a/0x60
05:58:55:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
05:58:55:  [<c101acf3>] ? do_page_fault+0x0/0x30d
05:58:55: Code: 04 82 c3 31 c0 c3 90 88 c2 83 e0 0f c0 ea 04 0f b6 d2 6b d2 0a 8d 04 02 c3 b9 0a 00 00 00 31 d2 f7 f1 c1 e0 04 01 d0 c3 90 90 90 <55> 89 e5 56 89 ce 53 31 c9 89 c3 39 f2 72 08 89 d0 31 d2 f7 f6 
05:58:55: Call Trace:
05:58:55:  [<c1110bcb>] ? div64_u64+0x25/0xef
05:58:55:  [<c111007b>] ? __put_user_8+0xf/0x19
05:58:55:  [<c106ee41>] ? shrink_zone+0x264/0x4c3
05:58:55:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
05:58:55:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
05:58:55:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
05:58:55:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
05:58:55:  [<c1042852>] ? ktime_get+0x5e/0xd9
05:58:55:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
05:58:55:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
05:58:55:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
05:58:55:  [<c1047272>] ? tick_program_event+0x19/0x1c
05:58:55:  [<c102e915>] ? irq_exit+0x41/0x64
05:58:55:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
05:58:55:  [<c101acf3>] ? do_page_fault+0x0/0x30d
05:58:55:  [<c1305022>] ? error_code+0x5a/0x60
05:58:55:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
05:58:55:  [<c101acf3>] ? do_page_fault+0x0/0x30d
05:59:36: INFO: rcu_sched_state detected stall on CPU 1 (t=180090 jiffies)
05:59:36: sending NMI to all CPUs:
05:59:36: NMI backtrace for cpu 1
05:59:36: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
05:59:36: 
05:59:36: Pid: 3145, comm: firefox-bin Not tainted 2.6.38-rc4 #226 0MG532/MXC061                          
05:59:36: EIP: 0060:[<c110f7aa>] EFLAGS: 00000006 CPU: 1
05:59:36: EIP is at __const_udelay+0x3/0x19
05:59:36: EAX: 01062560 EBX: 00000001 ECX: 00000800 EDX: fffff000
05:59:36: ESI: c1436640 EDI: 00000001 EBP: c1436640 ESP: f21a3c3c
05:59:36:  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
05:59:36: Process firefox-bin (pid: 3145, ti=f21a2000 task=f613c6c0 task.ti=f21a2000)
05:59:36: Stack:
05:59:36:  c1015f6d c13a101a f6602e14 c105c85b c13a901b c13a9102 00000001 0002bf7a
05:59:36:  00000000 00000000 00000001 00000000 00000001 f21a3d2c c105caf0 f613c6c0
05:59:36:  c1032df0 f6602cc8 63b1c6a6 00002baf c1047627 f6602cc8 f6602c70 f6602cc8
05:59:36: Call Trace:
05:59:36:  [<c1015f6d>] ? arch_trigger_all_cpu_backtrace+0x52/0x65
05:59:36:  [<c105c85b>] ? __rcu_pending+0x6c/0x277
05:59:36:  [<c105caf0>] ? rcu_check_callbacks+0x8a/0xb6
05:59:36:  [<c1032df0>] ? update_process_times+0x2a/0x53
05:59:36:  [<c1047627>] ? tick_sched_timer+0x64/0x8d
05:59:36:  [<c103f332>] ? __run_hrtimer+0x6d/0xc3
05:59:36:  [<c103f595>] ? hrtimer_interrupt+0x10c/0x213
05:59:36:  [<c102e915>] ? irq_exit+0x41/0x64
05:59:36:  [<c10157cc>] ? smp_apic_timer_interrupt+0x6c/0x7d
05:59:36:  [<c1304e02>] ? apic_timer_interrupt+0x2a/0x30
05:59:36:  [<c111007b>] ? __put_user_8+0xf/0x19
05:59:36:  [<c106ede9>] ? shrink_zone+0x20c/0x4c3
05:59:36:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
05:59:36:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
05:59:36:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
05:59:36:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
05:59:36:  [<c1042852>] ? ktime_get+0x5e/0xd9
05:59:36:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
05:59:36:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
05:59:36:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
05:59:36:  [<c1047272>] ? tick_program_event+0x19/0x1c
05:59:36:  [<c102e915>] ? irq_exit+0x41/0x64
05:59:36:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
05:59:36:  [<c101acf3>] ? do_page_fault+0x0/0x30d
05:59:36:  [<c1305022>] ? error_code+0x5a/0x60
05:59:36:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
05:59:36:  [<c101acf3>] ? do_page_fault+0x0/0x30d
05:59:36: Code: 00 eb 0e 8d b4 26 00 00 00 00 8d bc 27 00 00 00 00 48 75 fd 48 c3 c7 05 c0 14 44 c1 d3 f7 10 c1 c3 ff 15 c0 14 44 c1 c3 c1 e0 02 <64> 8b 15 9c b9 4e c1 6b d2 4b f7 e2 8d 42 01 ff 15 c0 14 44 c1 
05:59:36: Call Trace:
05:59:36:  [<c1015f6d>] ? arch_trigger_all_cpu_backtrace+0x52/0x65
05:59:36:  [<c105c85b>] ? __rcu_pending+0x6c/0x277
05:59:36:  [<c105caf0>] ? rcu_check_callbacks+0x8a/0xb6
05:59:36:  [<c1032df0>] ? update_process_times+0x2a/0x53
05:59:36:  [<c1047627>] ? tick_sched_timer+0x64/0x8d
05:59:36:  [<c103f332>] ? __run_hrtimer+0x6d/0xc3
05:59:36:  [<c103f595>] ? hrtimer_interrupt+0x10c/0x213
05:59:36:  [<c102e915>] ? irq_exit+0x41/0x64
05:59:36:  [<c10157cc>] ? smp_apic_timer_interrupt+0x6c/0x7d
05:59:36:  [<c1304e02>] ? apic_timer_interrupt+0x2a/0x30
05:59:36:  [<c111007b>] ? __put_user_8+0xf/0x19
05:59:36:  [<c106ede9>] ? shrink_zone+0x20c/0x4c3
05:59:36:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
05:59:36:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
05:59:36:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
05:59:36:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
05:59:36:  [<c1042852>] ? ktime_get+0x5e/0xd9
05:59:36:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
05:59:36:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
05:59:36:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
05:59:36:  [<c1047272>] ? tick_program_event+0x19/0x1c
05:59:36:  [<c102e915>] ? irq_exit+0x41/0x64
05:59:36:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
05:59:36:  [<c101acf3>] ? do_page_fault+0x0/0x30d
05:59:36:  [<c1305022>] ? error_code+0x5a/0x60
05:59:36:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
05:59:36:  [<c101acf3>] ? do_page_fault+0x0/0x30d
05:59:36: Pid: 3145, comm: firefox-bin Not tainted 2.6.38-rc4 #226
05:59:36: Call Trace:
05:59:36:  [<c10054b6>] ? show_trace+0xf/0x11
05:59:36:  [<c1015eff>] ? arch_trigger_all_cpu_backtrace_handler+0x57/0x73
05:59:36:  [<c104039f>] ? notifier_call_chain+0x23/0x46
05:59:36:  [<c10403e3>] ? atomic_notifier_call_chain+0x1a/0x1d
05:59:36:  [<c1040477>] ? notify_die+0x30/0x34
05:59:36:  [<c1003657>] ? do_nmi+0x68/0x267
05:59:36:  [<c13050d1>] ? nmi_stack_correct+0x28/0x2d
05:59:36:  [<c110f7aa>] ? __const_udelay+0x3/0x19
05:59:36:  [<c1015f6d>] ? arch_trigger_all_cpu_backtrace+0x52/0x65
05:59:36:  [<c105c85b>] ? __rcu_pending+0x6c/0x277
05:59:36:  [<c105caf0>] ? rcu_check_callbacks+0x8a/0xb6
05:59:36:  [<c1032df0>] ? update_process_times+0x2a/0x53
05:59:36:  [<c1047627>] ? tick_sched_timer+0x64/0x8d
05:59:36:  [<c103f332>] ? __run_hrtimer+0x6d/0xc3
05:59:36:  [<c103f595>] ? hrtimer_interrupt+0x10c/0x213
05:59:36:  [<c102e915>] ? irq_exit+0x41/0x64
05:59:36:  [<c10157cc>] ? smp_apic_timer_interrupt+0x6c/0x7d
05:59:36:  [<c1304e02>] ? apic_timer_interrupt+0x2a/0x30
05:59:36:  [<c111007b>] ? __put_user_8+0xf/0x19
05:59:36:  [<c106ede9>] ? shrink_zone+0x20c/0x4c3
05:59:36:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
05:59:36:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
05:59:36:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
05:59:36:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
05:59:36:  [<c1042852>] ? ktime_get+0x5e/0xd9
05:59:36:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
05:59:36:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
05:59:36:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
05:59:36:  [<c1047272>] ? tick_program_event+0x19/0x1c
05:59:36:  [<c102e915>] ? irq_exit+0x41/0x64
05:59:36:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
05:59:36:  [<c101acf3>] ? do_page_fault+0x0/0x30d
05:59:36:  [<c1305022>] ? error_code+0x5a/0x60
05:59:36:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
05:59:36:  [<c101acf3>] ? do_page_fault+0x0/0x30d
05:59:36: NMI backtrace for cpu 0
05:59:36: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
05:59:36: 
05:59:36: Pid: 0, comm: swapper Not tainted 2.6.38-rc4 #226 0MG532/MXC061                          
05:59:36: EIP: 0060:[<c1002888>] EFLAGS: 00000097 CPU: 0
05:59:36: EIP is at irq_entries_start+0x48/0x400
05:59:36: EAX: 63b1e841 EBX: 00000000 ECX: 00002baf EDX: 00002baf
05:59:36: ESI: 000003e8 EDI: f60d9440 EBP: f60d9000 ESP: c1421f9c
05:59:36:  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
05:59:36: Process swapper (pid: 0, ti=c1420000 task=c142fe20 task.ti=c1420000)
05:59:36: Stack:
05:59:36:  c115b48b 00000060 00000297 00000000 0032771f 00000000 00000ceb 00000000
05:59:36:  00000000 f60d901c f60d9134 c1423000 0174d003 c123289f c1495ccc 00000000
05:59:36:  c1001ae9 c14bf2c4 0009f600 c14987ce 000000c5 c149839a c14bf2c4 00020800
05:59:36: Call Trace:
05:59:36:  [<c115b48b>] ? acpi_idle_enter_bm+0x22c/0x261
05:59:36:  [<c123289f>] ? cpuidle_idle_call+0x67/0x98
05:59:36:  [<c1001ae9>] ? cpu_idle+0x41/0x5c
05:59:36:  [<c14987ce>] ? start_kernel+0x276/0x27b
05:59:36:  [<c149839a>] ? unknown_bootoption+0x0/0x18c
05:59:36: Code: 00 00 90 6a 58 eb 16 6a 57 eb 12 6a 56 eb 0e 6a 55 eb 0a 6a 54 eb 06 6a 53 eb 02 6a 52 e9 c1 03 00 00 90 6a 51 eb 16 6a 50 eb 12 <6a> 4f eb 0e 6a 4e eb 0a 6a 4d eb 06 6a 4c eb 02 6a 4b e9 a1 03 
05:59:36: Call Trace:
05:59:36:  [<c115b48b>] ? acpi_idle_enter_bm+0x22c/0x261
05:59:36:  [<c123289f>] ? cpuidle_idle_call+0x67/0x98
05:59:36:  [<c1001ae9>] ? cpu_idle+0x41/0x5c
05:59:36:  [<c14987ce>] ? start_kernel+0x276/0x27b
05:59:36:  [<c149839a>] ? unknown_bootoption+0x0/0x18c
05:59:36: Pid: 0, comm: swapper Not tainted 2.6.38-rc4 #226
05:59:36: Call Trace:
05:59:36:  [<c10054b6>] ? show_trace+0xf/0x11
05:59:36:  [<c1015eff>] ? arch_trigger_all_cpu_backtrace_handler+0x57/0x73
05:59:36:  [<c104039f>] ? notifier_call_chain+0x23/0x46
05:59:36:  [<c10403e3>] ? atomic_notifier_call_chain+0x1a/0x1d
05:59:36:  [<c1040477>] ? notify_die+0x30/0x34
05:59:36:  [<c1003657>] ? do_nmi+0x68/0x267
05:59:36:  [<c1040c67>] ? sched_clock_local+0x19/0x17c
05:59:36:  [<c13050d1>] ? nmi_stack_correct+0x28/0x2d
05:59:36:  [<c1002888>] ? irq_entries_start+0x48/0x400
05:59:36:  [<c115b48b>] ? acpi_idle_enter_bm+0x22c/0x261
05:59:36:  [<c123289f>] ? cpuidle_idle_call+0x67/0x98
05:59:36:  [<c1001ae9>] ? cpu_idle+0x41/0x5c
05:59:36:  [<c14987ce>] ? start_kernel+0x276/0x27b
05:59:36:  [<c149839a>] ? unknown_bootoption+0x0/0x18c
06:00:41: BUG: soft lockup - CPU#1 stuck for 61s! [firefox-bin:3145]
06:00:41: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
06:00:41: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
06:00:41: 
06:00:41: Pid: 3145, comm: firefox-bin Not tainted 2.6.38-rc4 #226 0MG532/MXC061                          
06:00:41: EIP: 0060:[<c1110ba6>] EFLAGS: 00000246 CPU: 1
06:00:41: EIP is at div64_u64+0x0/0xef
06:00:41: EAX: 000005f5 EBX: 00000000 ECX: 00000cc4 EDX: 00000000
06:00:41: ESI: f21a3e24 EDI: 00000000 EBP: f21a3dec ESP: f21a3d64
06:00:41:  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
06:00:41: Process firefox-bin (pid: 3145, ti=f21a2000 task=f613c6c0 task.ti=f21a2000)
06:00:41: Stack:
06:00:41:  c106ee41 00000cc4 00000000 00000000 c1492e00 0000c88d 00000020 00000021
06:00:41:  c1493098 00000001 c14930a8 c1493040 c14930a4 c14930a0 c149309c 0000000b
06:00:41:  00000000 00000cc4 00000000 fffffffe 00000000 00000000 00000000 00000000
06:00:41: Call Trace:
06:00:41:  [<c106ee41>] ? shrink_zone+0x264/0x4c3
06:00:41:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
06:00:41:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
06:00:41:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
06:00:41:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
06:00:41:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:00:41:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
06:00:41:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
06:00:41:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
06:00:41:  [<c1047272>] ? tick_program_event+0x19/0x1c
06:00:41:  [<c102e915>] ? irq_exit+0x41/0x64
06:00:41:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:00:41:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:00:41:  [<c1305022>] ? error_code+0x5a/0x60
06:00:41:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
06:00:41:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:00:41: Code: 1e 85 db 7f 19 eb 1e 89 cf 89 34 24 c1 ff 1f 89 f9 31 d9 29 f9 e8 db fe ff ff 85 db 79 07 f7 d8 83 d2 00 f7 da 59 5b 5e 5f c9 c3 <55> 89 e5 57 56 89 d6 53 89 c3 83 ec 1c 8b 55 0c 8d 7c 24 18 85 
06:00:41: Call Trace:
06:00:41:  [<c106ee41>] ? shrink_zone+0x264/0x4c3
06:00:41:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
06:00:41:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
06:00:41:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
06:00:41:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
06:00:41:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:00:41:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
06:00:41:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
06:00:41:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
06:00:41:  [<c1047272>] ? tick_program_event+0x19/0x1c
06:00:41:  [<c102e915>] ? irq_exit+0x41/0x64
06:00:41:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:00:41:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:00:41:  [<c1305022>] ? error_code+0x5a/0x60
06:00:41:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
06:00:41:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:02:12: INFO: rcu_sched_state detected stall on CPU 1 (t=18000 jiffies)
06:02:12: sending NMI to all CPUs:
06:02:12: NMI backtrace for cpu 1
06:02:12: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
06:02:12: 
06:02:12: Pid: 3145, comm: firefox-bin Not tainted 2.6.38-rc4 #226 0MG532/MXC061                          
06:02:12: EIP: 0060:[<c110f7e9>] EFLAGS: 00000082 CPU: 1
06:02:12: EIP is at delay_tsc+0x16/0x55
06:02:12: EAX: 001e7a67 EBX: 00000001 ECX: 00000001 EDX: 001e7a66
06:02:12: ESI: c1436640 EDI: 00000001 EBP: 001e7a67 ESP: f21a3c20
06:02:12:  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
06:02:12: Process firefox-bin (pid: 3145, ti=f21a2000 task=f613c6c0 task.ti=f21a2000)
06:02:12: Stack:
06:02:12:  00000000 c1436640 00000001 c1436640 00000001 c1436640 c110f7bf c1015f6d
06:02:12:  c13a101a f6602e14 c105c85b c13a901b c13a9102 00000001 00004650 00000000
06:02:12:  00000000 00000001 00000000 00000001 f21a3d2c c105caf0 f613c6c0 c1032df0
06:02:12: Call Trace:
06:02:12:  [<c110f7bf>] ? __const_udelay+0x18/0x19
06:02:12:  [<c1015f6d>] ? arch_trigger_all_cpu_backtrace+0x52/0x65
06:02:12:  [<c105c85b>] ? __rcu_pending+0x6c/0x277
06:02:12:  [<c105caf0>] ? rcu_check_callbacks+0x8a/0xb6
06:02:12:  [<c1032df0>] ? update_process_times+0x2a/0x53
06:02:12:  [<c1047627>] ? tick_sched_timer+0x64/0x8d
06:02:12:  [<c103f332>] ? __run_hrtimer+0x6d/0xc3
06:02:12:  [<c103f595>] ? hrtimer_interrupt+0x10c/0x213
06:02:12:  [<c10157cc>] ? smp_apic_timer_interrupt+0x6c/0x7d
06:02:12:  [<c111007b>] ? __put_user_8+0xf/0x19
06:02:12:  [<c1304e02>] ? apic_timer_interrupt+0x2a/0x30
06:02:12:  [<c111007b>] ? __put_user_8+0xf/0x19
06:02:12:  [<c106eda8>] ? shrink_zone+0x1cb/0x4c3
06:02:12:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
06:02:12:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
06:02:12:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
06:02:12:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
06:02:12:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:02:12:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
06:02:12:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
06:02:12:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
06:02:12:  [<c1047272>] ? tick_program_event+0x19/0x1c
06:02:12:  [<c102e915>] ? irq_exit+0x41/0x64
06:02:12:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:02:12:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:02:12:  [<c1305022>] ? error_code+0x5a/0x60
06:02:12:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
06:02:12:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:02:12: Code: c1 c3 69 c0 c7 10 00 00 e9 dc ff ff ff 8d 04 80 e9 d4 ff ff ff 55 89 c5 57 56 53 83 ec 08 64 8b 0d b8 7f 4e c1 8d 76 00 0f ae e8 <0f> 31 89 c7 8d 76 00 0f ae e8 0f 31 89 c3 89 c6 29 fb 39 eb 73 
06:02:12: Call Trace:
06:02:12:  [<c110f7bf>] ? __const_udelay+0x18/0x19
06:02:12:  [<c1015f6d>] ? arch_trigger_all_cpu_backtrace+0x52/0x65
06:02:12:  [<c105c85b>] ? __rcu_pending+0x6c/0x277
06:02:12:  [<c105caf0>] ? rcu_check_callbacks+0x8a/0xb6
06:02:12:  [<c1032df0>] ? update_process_times+0x2a/0x53
06:02:12:  [<c1047627>] ? tick_sched_timer+0x64/0x8d
06:02:12:  [<c103f332>] ? __run_hrtimer+0x6d/0xc3
06:02:12:  [<c103f595>] ? hrtimer_interrupt+0x10c/0x213
06:02:12:  [<c10157cc>] ? smp_apic_timer_interrupt+0x6c/0x7d
06:02:12:  [<c111007b>] ? __put_user_8+0xf/0x19
06:02:12:  [<c1304e02>] ? apic_timer_interrupt+0x2a/0x30
06:02:12:  [<c111007b>] ? __put_user_8+0xf/0x19
06:02:12:  [<c106eda8>] ? shrink_zone+0x1cb/0x4c3
06:02:12:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
06:02:12:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
06:02:12:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
06:02:12:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
06:02:12:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:02:12:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
06:02:12:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
06:02:12:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
06:02:12:  [<c1047272>] ? tick_program_event+0x19/0x1c
06:02:12:  [<c102e915>] ? irq_exit+0x41/0x64
06:02:12:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:02:12:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:02:12:  [<c1305022>] ? error_code+0x5a/0x60
06:02:12:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
06:02:12:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:02:12: Pid: 3145, comm: firefox-bin Not tainted 2.6.38-rc4 #226
06:02:12: Call Trace:
06:02:12:  [<c10054b6>] ? show_trace+0xf/0x11
06:02:12:  [<c1015eff>] ? arch_trigger_all_cpu_backtrace_handler+0x57/0x73
06:02:12:  [<c104039f>] ? notifier_call_chain+0x23/0x46
06:02:12:  [<c10403e3>] ? atomic_notifier_call_chain+0x1a/0x1d
06:02:12:  [<c1040477>] ? notify_die+0x30/0x34
06:02:12:  [<c1003657>] ? do_nmi+0x68/0x267
06:02:12:  [<c13050d1>] ? nmi_stack_correct+0x28/0x2d
06:02:12:  [<c10100d8>] ? do_machine_check+0x2c0/0x6d2
06:02:12:  [<c110f7e9>] ? delay_tsc+0x16/0x55
06:02:12:  [<c110f7bf>] ? __const_udelay+0x18/0x19
06:02:12:  [<c1015f6d>] ? arch_trigger_all_cpu_backtrace+0x52/0x65
06:02:12:  [<c105c85b>] ? __rcu_pending+0x6c/0x277
06:02:12:  [<c105caf0>] ? rcu_check_callbacks+0x8a/0xb6
06:02:12:  [<c1032df0>] ? update_process_times+0x2a/0x53
06:02:12:  [<c1047627>] ? tick_sched_timer+0x64/0x8d
06:02:12:  [<c103f332>] ? __run_hrtimer+0x6d/0xc3
06:02:12:  [<c103f595>] ? hrtimer_interrupt+0x10c/0x213
06:02:12:  [<c10157cc>] ? smp_apic_timer_interrupt+0x6c/0x7d
06:02:12:  [<c111007b>] ? __put_user_8+0xf/0x19
06:02:12:  [<c1304e02>] ? apic_timer_interrupt+0x2a/0x30
06:02:12:  [<c111007b>] ? __put_user_8+0xf/0x19
06:02:12:  [<c106eda8>] ? shrink_zone+0x1cb/0x4c3
06:02:12:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
06:02:12:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
06:02:12:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
06:02:12:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
06:02:12:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:02:12:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
06:02:12:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
06:02:12:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
06:02:12:  [<c1047272>] ? tick_program_event+0x19/0x1c
06:02:12:  [<c102e915>] ? irq_exit+0x41/0x64
06:02:12:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:02:12:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:02:12:  [<c1305022>] ? error_code+0x5a/0x60
06:02:12:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
06:02:12:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:02:12: NMI backtrace for cpu 0
06:02:12: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
06:02:12: 
06:02:12: Pid: 0, comm: swapper Not tainted 2.6.38-rc4 #226 0MG532/MXC061                          
06:02:12: EIP: 0060:[<c1019322>] EFLAGS: 00000046 CPU: 0
06:02:12: EIP is at read_hpet+0xe/0x12
06:02:12: EAX: af3ddf6d EBX: 00fcaff6 ECX: fffff000 EDX: 00000000
06:02:12: ESI: c1433a80 EDI: 3bb6ca07 EBP: c1421efc ESP: c1421efc
06:02:12:  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
06:02:12: Process swapper (pid: 0, ti=c1420000 task=c142fe20 task.ti=c1420000)
06:02:12: Stack:
06:02:12:  00000000 c1042852 00000003 c14e8cc8 0000bc3b 00000000 00000000 000003e8
06:02:12:  f6402cc8 00000000 c10477a4 00000000 000003e8 00000000 c1421f6c c102eb08
06:02:12:  ffffffcf c1003d1a f60d9440 c1421f9c c1040c67 a4bbb678 00002bd3 00000000
06:02:12: Call Trace:
06:02:12:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:02:12:  [<c10477a4>] ? tick_check_idle+0x28/0x82
06:02:12:  [<c102eb08>] ? irq_enter+0x34/0x54
06:02:12:  [<c1003d1a>] ? do_IRQ+0x1e/0x95
06:02:12:  [<c1040c67>] ? sched_clock_local+0x19/0x17c
06:02:12:  [<c1002c69>] ? common_interrupt+0x29/0x30
06:02:12:  [<c115b48b>] ? acpi_idle_enter_bm+0x22c/0x261
06:02:12:  [<c123289f>] ? cpuidle_idle_call+0x67/0x98
06:02:12:  [<c1001ae9>] ? cpu_idle+0x41/0x5c
06:02:12:  [<c14987ce>] ? start_kernel+0x276/0x27b
06:02:12:  [<c149839a>] ? unknown_bootoption+0x0/0x18c
06:02:12: Code: 4f c1 8b 92 f0 00 00 00 29 d0 89 c2 31 c0 81 fa 80 00 00 00 ba c2 ff ff ff 0f 4c c2 c3 55 a1 34 e7 4f c1 89 e5 8b 80 f0 00 00 00 <31> d2 c9 c3 83 3d 38 e7 4f c1 00 75 37 83 3d 20 e7 4f c1 00 74 
06:02:12: Call Trace:
06:02:12:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:02:12:  [<c10477a4>] ? tick_check_idle+0x28/0x82
06:02:12:  [<c102eb08>] ? irq_enter+0x34/0x54
06:02:12:  [<c1003d1a>] ? do_IRQ+0x1e/0x95
06:02:12:  [<c1040c67>] ? sched_clock_local+0x19/0x17c
06:02:12:  [<c1002c69>] ? common_interrupt+0x29/0x30
06:02:12:  [<c115b48b>] ? acpi_idle_enter_bm+0x22c/0x261
06:02:12:  [<c123289f>] ? cpuidle_idle_call+0x67/0x98
06:02:12:  [<c1001ae9>] ? cpu_idle+0x41/0x5c
06:02:12:  [<c14987ce>] ? start_kernel+0x276/0x27b
06:02:12:  [<c149839a>] ? unknown_bootoption+0x0/0x18c
06:02:12: Pid: 0, comm: swapper Not tainted 2.6.38-rc4 #226
06:02:12: Call Trace:
06:02:12:  [<c10054b6>] ? show_trace+0xf/0x11
06:02:12:  [<c1015eff>] ? arch_trigger_all_cpu_backtrace_handler+0x57/0x73
06:02:12:  [<c104039f>] ? notifier_call_chain+0x23/0x46
06:02:12:  [<c10403e3>] ? atomic_notifier_call_chain+0x1a/0x1d
06:02:12:  [<c1040477>] ? notify_die+0x30/0x34
06:02:12:  [<c1003657>] ? do_nmi+0x68/0x267
06:02:12:  [<c13050d1>] ? nmi_stack_correct+0x28/0x2d
06:02:12:  [<c104007b>] ? copy_namespaces+0x1/0x7e
06:02:12:  [<c1019322>] ? read_hpet+0xe/0x12
06:02:12:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:02:12:  [<c10477a4>] ? tick_check_idle+0x28/0x82
06:02:12:  [<c102eb08>] ? irq_enter+0x34/0x54
06:02:12:  [<c1003d1a>] ? do_IRQ+0x1e/0x95
06:02:12:  [<c1040c67>] ? sched_clock_local+0x19/0x17c
06:02:12:  [<c1002c69>] ? common_interrupt+0x29/0x30
06:02:12:  [<c115b48b>] ? acpi_idle_enter_bm+0x22c/0x261
06:02:12:  [<c123289f>] ? cpuidle_idle_call+0x67/0x98
06:02:12:  [<c1001ae9>] ? cpu_idle+0x41/0x5c
06:02:12:  [<c14987ce>] ? start_kernel+0x276/0x27b
06:02:12:  [<c149839a>] ? unknown_bootoption+0x0/0x18c
06:03:21: BUG: soft lockup - CPU#1 stuck for 63s! [firefox-bin:3145]
06:03:21: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
06:03:21: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
06:03:21: 
06:03:21: Pid: 3145, comm: firefox-bin Not tainted 2.6.38-rc4 #226 0MG532/MXC061                          
06:03:21: EIP: 0060:[<c106eda8>] EFLAGS: 00000202 CPU: 1
06:03:21: EIP is at shrink_zone+0x1cb/0x4c3
06:03:21: EAX: 00000cc9 EBX: c1492e00 ECX: 0000003d EDX: 00000009
06:03:21: ESI: f21a3e24 EDI: c1493040 EBP: f21a3dec ESP: f21a3d68
06:03:21:  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
06:03:21: Process firefox-bin (pid: 3145, ti=f21a2000 task=f613c6c0 task.ti=f21a2000)
06:03:21: Stack:
06:03:21:  00000d07 00000000 00000000 c1492e00 0000c88d 00000020 00000021 c1493098
06:03:21:  00000004 c14930a8 c1493040 c14930a4 c14930a0 c149309c 0000000b 0000a189
06:03:21:  00001e09 00000000 0000003c 00000000 00000000 00000000 00000000 00000040
06:03:21: Call Trace:
06:03:21:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
06:03:21:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
06:03:21:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
06:03:21:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
06:03:21:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:03:21:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
06:03:21:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
06:03:21:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
06:03:21:  [<c1047272>] ? tick_program_event+0x19/0x1c
06:03:21:  [<c102e915>] ? irq_exit+0x41/0x64
06:03:21:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:03:21:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:03:21:  [<c1305022>] ? error_code+0x5a/0x60
06:03:21:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
06:03:21:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:03:21: Code: 8b 93 78 02 00 00 8b bb 70 02 00 00 42 47 89 c1 b8 c9 00 00 00 2b 44 24 48 0f af c2 31 d2 f7 f7 8b 7c 24 28 fe 07 fb 89 44 24 68 <89> 4c 24 60 8d 44 01 01 c7 44 24 64 00 00 00 00 c7 44 24 6c 00 
06:03:21: Call Trace:
06:03:21:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
06:03:21:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
06:03:21:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
06:03:21:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
06:03:21:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:03:21:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
06:03:21:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
06:03:21:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
06:03:21:  [<c1047272>] ? tick_program_event+0x19/0x1c
06:03:21:  [<c102e915>] ? irq_exit+0x41/0x64
06:03:21:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:03:21:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:03:21:  [<c1305022>] ? error_code+0x5a/0x60
06:03:21:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
06:03:21:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:04:30: BUG: soft lockup - CPU#1 stuck for 61s! [firefox-bin:3145]
06:04:30: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
06:04:30: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
06:04:30: 
06:04:30: Pid: 3145, comm: firefox-bin Not tainted 2.6.38-rc4 #226 0MG532/MXC061                          
06:04:30: EIP: 0060:[<c106eda8>] EFLAGS: 00000292 CPU: 1
06:04:30: EIP is at shrink_zone+0x1cb/0x4c3
06:04:30: EAX: 00000ccf EBX: c1492e00 ECX: 0000003d EDX: 00000027
06:04:30: ESI: f21a3e24 EDI: c1493040 EBP: f21a3dec ESP: f21a3d68
06:04:30:  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
06:04:30: Process firefox-bin (pid: 3145, ti=f21a2000 task=f613c6c0 task.ti=f21a2000)
06:04:30: Stack:
06:04:30:  00000d0d 00000000 00000000 c1492e00 0000c88d 00000020 00000021 c1493098
06:04:30:  00000004 c14930a8 c1493040 c14930a4 c14930a0 c149309c 0000000b 0000a189
06:04:30:  00001e0b 00000000 0000003c 00000000 00000000 00000000 00000000 00000040
06:04:30: Call Trace:
06:04:30:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
06:04:30:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
06:04:30:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
06:04:30:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
06:04:30:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:04:30:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
06:04:30:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
06:04:30:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
06:04:30:  [<c1047272>] ? tick_program_event+0x19/0x1c
06:04:30:  [<c102e915>] ? irq_exit+0x41/0x64
06:04:30:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:04:30:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:04:30:  [<c1305022>] ? error_code+0x5a/0x60
06:04:30:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
06:04:30:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:04:30: Code: 8b 93 78 02 00 00 8b bb 70 02 00 00 42 47 89 c1 b8 c9 00 00 00 2b 44 24 48 0f af c2 31 d2 f7 f7 8b 7c 24 28 fe 07 fb 89 44 24 68 <89> 4c 24 60 8d 44 01 01 c7 44 24 64 00 00 00 00 c7 44 24 6c 00 
06:04:30: Call Trace:
06:04:30:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
06:04:30:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
06:04:30:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
06:04:30:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
06:04:30:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:04:30:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
06:04:30:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
06:04:30:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
06:04:30:  [<c1047272>] ? tick_program_event+0x19/0x1c
06:04:30:  [<c102e915>] ? irq_exit+0x41/0x64
06:04:30:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:04:30:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:04:30:  [<c1305022>] ? error_code+0x5a/0x60
06:04:30:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
06:04:30:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:05:12: INFO: rcu_sched_state detected stall on CPU 1 (t=72030 jiffies)
06:05:12: sending NMI to all CPUs:
06:05:12: NMI backtrace for cpu 1
06:05:12: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
06:05:12: 
06:05:12: Pid: 3145, comm: firefox-bin Not tainted 2.6.38-rc4 #226 0MG532/MXC061                          
06:05:12: EIP: 0060:[<c110f7b1>] EFLAGS: 00000006 CPU: 1
06:05:12: EIP is at __const_udelay+0xa/0x19
06:05:12: EAX: 01062560 EBX: 00000001 ECX: 00000800 EDX: 006597cf
06:05:12: ESI: c1436640 EDI: 00000001 EBP: c1436640 ESP: f21a3c3c
06:05:12:  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
06:05:12: Process firefox-bin (pid: 3145, ti=f21a2000 task=f613c6c0 task.ti=f21a2000)
06:05:12: Stack:
06:05:12:  c1015f6d c13a101a f6602e14 c105c85b c13a901b c13a9102 00000001 0001195e
06:05:12:  00000000 00000000 00000001 00000000 00000001 f21a3d2c c105caf0 f613c6c0
06:05:12:  c1032df0 f6602cc8 93873937 00002bfd c1047627 f6602cc8 f6602c70 f6602cc8
06:05:12: Call Trace:
06:05:12:  [<c1015f6d>] ? arch_trigger_all_cpu_backtrace+0x52/0x65
06:05:12:  [<c105c85b>] ? __rcu_pending+0x6c/0x277
06:05:12:  [<c105caf0>] ? rcu_check_callbacks+0x8a/0xb6
06:05:12:  [<c1032df0>] ? update_process_times+0x2a/0x53
06:05:12:  [<c1047627>] ? tick_sched_timer+0x64/0x8d
06:05:12:  [<c103f332>] ? __run_hrtimer+0x6d/0xc3
06:05:12:  [<c103f595>] ? hrtimer_interrupt+0x10c/0x213
06:05:12:  [<c10157cc>] ? smp_apic_timer_interrupt+0x6c/0x7d
06:05:12:  [<c1304e02>] ? apic_timer_interrupt+0x2a/0x30
06:05:12:  [<c106eda8>] ? shrink_zone+0x1cb/0x4c3
06:05:12:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
06:05:12:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
06:05:12:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
06:05:12:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
06:05:12:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:05:12:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
06:05:12:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
06:05:12:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
06:05:12:  [<c1047272>] ? tick_program_event+0x19/0x1c
06:05:12:  [<c102e915>] ? irq_exit+0x41/0x64
06:05:12:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:05:12:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:05:12:  [<c1305022>] ? error_code+0x5a/0x60
06:05:12:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
06:05:12:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:05:12: Code: 00 00 00 8d bc 27 00 00 00 00 48 75 fd 48 c3 c7 05 c0 14 44 c1 d3 f7 10 c1 c3 ff 15 c0 14 44 c1 c3 c1 e0 02 64 8b 15 9c b9 4e c1 <6b> d2 4b f7 e2 8d 42 01 ff 15 c0 14 44 c1 c3 69 c0 c7 10 00 00 
06:05:12: Call Trace:
06:05:12:  [<c1015f6d>] ? arch_trigger_all_cpu_backtrace+0x52/0x65
06:05:12:  [<c105c85b>] ? __rcu_pending+0x6c/0x277
06:05:12:  [<c105caf0>] ? rcu_check_callbacks+0x8a/0xb6
06:05:12:  [<c1032df0>] ? update_process_times+0x2a/0x53
06:05:12:  [<c1047627>] ? tick_sched_timer+0x64/0x8d
06:05:12:  [<c103f332>] ? __run_hrtimer+0x6d/0xc3
06:05:12:  [<c103f595>] ? hrtimer_interrupt+0x10c/0x213
06:05:12:  [<c10157cc>] ? smp_apic_timer_interrupt+0x6c/0x7d
06:05:12:  [<c1304e02>] ? apic_timer_interrupt+0x2a/0x30
06:05:12:  [<c106eda8>] ? shrink_zone+0x1cb/0x4c3
06:05:12:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
06:05:12:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
06:05:12:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
06:05:12:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
06:05:12:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:05:12:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
06:05:12:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
06:05:12:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
06:05:12:  [<c1047272>] ? tick_program_event+0x19/0x1c
06:05:12:  [<c102e915>] ? irq_exit+0x41/0x64
06:05:12:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:05:12:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:05:12:  [<c1305022>] ? error_code+0x5a/0x60
06:05:12:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
06:05:12:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:05:12: Pid: 3145, comm: firefox-bin Not tainted 2.6.38-rc4 #226
06:05:12: Call Trace:
06:05:12:  [<c10054b6>] ? show_trace+0xf/0x11
06:05:12:  [<c1015eff>] ? arch_trigger_all_cpu_backtrace_handler+0x57/0x73
06:05:12:  [<c104039f>] ? notifier_call_chain+0x23/0x46
06:05:12:  [<c10403e3>] ? atomic_notifier_call_chain+0x1a/0x1d
06:05:12:  [<c1040477>] ? notify_die+0x30/0x34
06:05:12:  [<c1003657>] ? do_nmi+0x68/0x267
06:05:12:  [<c13050d1>] ? nmi_stack_correct+0x28/0x2d
06:05:12:  [<c110f7b1>] ? __const_udelay+0xa/0x19
06:05:12:  [<c1015f6d>] ? arch_trigger_all_cpu_backtrace+0x52/0x65
06:05:12:  [<c105c85b>] ? __rcu_pending+0x6c/0x277
06:05:12:  [<c105caf0>] ? rcu_check_callbacks+0x8a/0xb6
06:05:12:  [<c1032df0>] ? update_process_times+0x2a/0x53
06:05:12:  [<c1047627>] ? tick_sched_timer+0x64/0x8d
06:05:12:  [<c103f332>] ? __run_hrtimer+0x6d/0xc3
06:05:12:  [<c103f595>] ? hrtimer_interrupt+0x10c/0x213
06:05:12:  [<c10157cc>] ? smp_apic_timer_interrupt+0x6c/0x7d
06:05:12:  [<c1304e02>] ? apic_timer_interrupt+0x2a/0x30
06:05:12:  [<c106eda8>] ? shrink_zone+0x1cb/0x4c3
06:05:12:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
06:05:12:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
06:05:12:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
06:05:12:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
06:05:12:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:05:12:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
06:05:12:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
06:05:12:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
06:05:12:  [<c1047272>] ? tick_program_event+0x19/0x1c
06:05:12:  [<c102e915>] ? irq_exit+0x41/0x64
06:05:12:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:05:12:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:05:12:  [<c1305022>] ? error_code+0x5a/0x60
06:05:12:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
06:05:12:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:05:12: NMI backtrace for cpu 0
06:05:12: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
06:05:12: 
06:05:12: Pid: 0, comm: swapper Not tainted 2.6.38-rc4 #226 0MG532/MXC061                          
06:05:12: EIP: 0060:[<c1019322>] EFLAGS: 00000057 CPU: 0
06:05:12: EIP is at read_hpet+0xe/0x12
06:05:12: EAX: 48f23d2c EBX: 00fe5612 ECX: fffff000 EDX: 00000000
06:05:12: ESI: c1433a80 EDI: 417cbbf2 EBP: c1421efc ESP: c1421efc
06:05:12:  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
06:05:12: Process swapper (pid: 0, ti=c1420000 task=c142fe20 task.ti=c1420000)
06:05:12: Stack:
06:05:12:  00000000 c1042852 00000003 c14e8cc8 0000bcef 00000000 00000000 000003e8
06:05:12:  f6402cc8 00000000 c10477a4 00000000 000003e8 00000000 c1421f6c c102eb08
06:05:12:  ffffffcf c1003d1a f60d9440 c1421f9c c1040c67 938758e9 00002bfd 00000000
06:05:12: Call Trace:
06:05:12:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:05:12:  [<c10477a4>] ? tick_check_idle+0x28/0x82
06:05:12:  [<c102eb08>] ? irq_enter+0x34/0x54
06:05:12:  [<c1003d1a>] ? do_IRQ+0x1e/0x95
06:05:12:  [<c1040c67>] ? sched_clock_local+0x19/0x17c
06:05:12:  [<c1002c69>] ? common_interrupt+0x29/0x30
06:05:12:  [<c115b48b>] ? acpi_idle_enter_bm+0x22c/0x261
06:05:12:  [<c123289f>] ? cpuidle_idle_call+0x67/0x98
06:05:12:  [<c1001ae9>] ? cpu_idle+0x41/0x5c
06:05:12:  [<c14987ce>] ? start_kernel+0x276/0x27b
06:05:12:  [<c149839a>] ? unknown_bootoption+0x0/0x18c
06:05:12: Code: 4f c1 8b 92 f0 00 00 00 29 d0 89 c2 31 c0 81 fa 80 00 00 00 ba c2 ff ff ff 0f 4c c2 c3 55 a1 34 e7 4f c1 89 e5 8b 80 f0 00 00 00 <31> d2 c9 c3 83 3d 38 e7 4f c1 00 75 37 83 3d 20 e7 4f c1 00 74 
06:05:12: Call Trace:
06:05:12:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:05:12:  [<c10477a4>] ? tick_check_idle+0x28/0x82
06:05:12:  [<c102eb08>] ? irq_enter+0x34/0x54
06:05:12:  [<c1003d1a>] ? do_IRQ+0x1e/0x95
06:05:12:  [<c1040c67>] ? sched_clock_local+0x19/0x17c
06:05:12:  [<c1002c69>] ? common_interrupt+0x29/0x30
06:05:12:  [<c115b48b>] ? acpi_idle_enter_bm+0x22c/0x261
06:05:12:  [<c123289f>] ? cpuidle_idle_call+0x67/0x98
06:05:12:  [<c1001ae9>] ? cpu_idle+0x41/0x5c
06:05:12:  [<c14987ce>] ? start_kernel+0x276/0x27b
06:05:12:  [<c149839a>] ? unknown_bootoption+0x0/0x18c
06:05:12: Pid: 0, comm: swapper Not tainted 2.6.38-rc4 #226
06:05:12: Call Trace:
06:05:12:  [<c10054b6>] ? show_trace+0xf/0x11
06:05:12:  [<c1015eff>] ? arch_trigger_all_cpu_backtrace_handler+0x57/0x73
06:05:12:  [<c104039f>] ? notifier_call_chain+0x23/0x46
06:05:12:  [<c10403e3>] ? atomic_notifier_call_chain+0x1a/0x1d
06:05:12:  [<c1040477>] ? notify_die+0x30/0x34
06:05:12:  [<c1003657>] ? do_nmi+0x68/0x267
06:05:12:  [<c13050d1>] ? nmi_stack_correct+0x28/0x2d
06:05:12:  [<c104007b>] ? copy_namespaces+0x1/0x7e
06:05:12:  [<c1019322>] ? read_hpet+0xe/0x12
06:05:12:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:05:12:  [<c10477a4>] ? tick_check_idle+0x28/0x82
06:05:12:  [<c102eb08>] ? irq_enter+0x34/0x54
06:05:12:  [<c1003d1a>] ? do_IRQ+0x1e/0x95
06:05:12:  [<c1040c67>] ? sched_clock_local+0x19/0x17c
06:05:12:  [<c1002c69>] ? common_interrupt+0x29/0x30
06:05:12:  [<c115b48b>] ? acpi_idle_enter_bm+0x22c/0x261
06:05:12:  [<c123289f>] ? cpuidle_idle_call+0x67/0x98
06:05:12:  [<c1001ae9>] ? cpu_idle+0x41/0x5c
06:05:12:  [<c14987ce>] ? start_kernel+0x276/0x27b
06:05:12:  [<c149839a>] ? unknown_bootoption+0x0/0x18c
06:06:22: BUG: soft lockup - CPU#1 stuck for 63s! [firefox-bin:3145]
06:06:22: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
06:06:22: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
06:06:22: 
06:06:22: Pid: 3145, comm: firefox-bin Not tainted 2.6.38-rc4 #226 0MG532/MXC061                          
06:06:22: EIP: 0060:[<c106ee2e>] EFLAGS: 00000202 CPU: 1
06:06:22: EIP is at shrink_zone+0x251/0x4c3
06:06:22: EAX: 00000cdd EBX: 00000000 ECX: 00000000 EDX: 00000000
06:06:22: ESI: f21a3e24 EDI: 00000003 EBP: f21a3dec ESP: f21a3d68
06:06:22:  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
06:06:22: Process firefox-bin (pid: 3145, ti=f21a2000 task=f613c6c0 task.ti=f21a2000)
06:06:22: Stack:
06:06:22:  00000d1b 00000000 00000000 c1492e00 0000c88d 00000020 00000021 c1493098
06:06:22:  00000004 c14930a8 c1493040 c14930a4 c14930a0 c149309c 0000000b 00000000
06:06:22:  00000d1b 00000000 00000001 00000000 00000000 00000000 00000000 00000040
06:06:22: Call Trace:
06:06:22:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
06:06:22:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
06:06:22:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
06:06:22:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
06:06:22:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:06:22:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
06:06:22:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
06:06:22:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
06:06:22:  [<c1047272>] ? tick_program_event+0x19/0x1c
06:06:22:  [<c102e915>] ? irq_exit+0x41/0x64
06:06:22:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:06:22:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:06:22:  [<c1305022>] ? error_code+0x5a/0x60
06:06:22:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
06:06:22:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:06:22: Code: 24 3c 00 75 07 83 7c 24 38 00 74 32 83 7c 24 48 02 8a 4c 24 38 19 d2 8b 5c 24 44 d3 e8 83 e2 08 8b 4c 14 64 0f af c8 f7 64 14 60 <89> 5c 24 04 8d 14 11 8b 4c 24 40 89 0c 24 e8 65 1d 0a 00 81 c7 
06:06:22: Call Trace:
06:06:22:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
06:06:22:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
06:06:22:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
06:06:22:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
06:06:22:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:06:22:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
06:06:22:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
06:06:22:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
06:06:22:  [<c1047272>] ? tick_program_event+0x19/0x1c
06:06:22:  [<c102e915>] ? irq_exit+0x41/0x64
06:06:22:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:06:22:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:06:22:  [<c1305022>] ? error_code+0x5a/0x60
06:06:22:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
06:06:22:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:07:34: BUG: soft lockup - CPU#1 stuck for 63s! [firefox-bin:3145]
06:07:34: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
06:07:34: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
06:07:34: 
06:07:34: Pid: 3145, comm: firefox-bin Not tainted 2.6.38-rc4 #226 0MG532/MXC061                          
06:07:34: EIP: 0060:[<c1110c94>] EFLAGS: 00000292 CPU: 1
06:07:34: EIP is at div64_u64+0xee/0xef
06:07:34: EAX: 00000000 EBX: 00000000 ECX: 00000000 EDX: 00000000
06:07:34: ESI: f21a3e24 EDI: 00000001 EBP: f21a3dec ESP: f21a3d64
06:07:34:  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
06:07:34: Process firefox-bin (pid: 3145, ti=f21a2000 task=f613c6c0 task.ti=f21a2000)
06:07:34: Stack:
06:07:34:  c106ee41 00000d22 00000000 00000000 c1492e00 0000c88d 00000020 00000021
06:07:34:  c1493098 00000002 c14930a8 c1493040 c14930a4 c14930a0 c149309c 0000000b
06:07:34:  00000000 00000d22 00000000 ffffffff 00000000 00000000 00000000 00000000
06:07:34: Call Trace:
06:07:34:  [<c106ee41>] ? shrink_zone+0x264/0x4c3
06:07:34:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
06:07:34:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
06:07:34:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
06:07:34:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
06:07:34:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:07:34:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
06:07:34:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
06:07:34:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
06:07:34:  [<c1047272>] ? tick_program_event+0x19/0x1c
06:07:34:  [<c102e915>] ? irq_exit+0x41/0x64
06:07:34:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:07:34:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:07:34:  [<c1305022>] ? error_code+0x5a/0x60
06:07:34:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
06:07:34:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:07:34: Code: 24 10 1b 74 24 14 3b 75 0c 72 11 77 05 3b 5d 08 72 0a 83 44 24 04 01 83 54 24 08 00 8b 44 24 04 8b 54 24 08 83 c4 1c 5b 5e 5f c9 <c3> 55 89 e5 56 89 d6 53 c1 fa 1f 83 ec 20 89 c3 89 54 24 18 89 
06:07:34: Call Trace:
06:07:34:  [<c106ee41>] ? shrink_zone+0x264/0x4c3
06:07:34:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
06:07:34:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
06:07:34:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
06:07:34:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
06:07:34:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:07:34:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
06:07:34:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
06:07:34:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
06:07:34:  [<c1047272>] ? tick_program_event+0x19/0x1c
06:07:34:  [<c102e915>] ? irq_exit+0x41/0x64
06:07:34:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:07:34:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:07:34:  [<c1305022>] ? error_code+0x5a/0x60
06:07:34:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
06:07:34:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:08:12: INFO: rcu_sched_state detected stall on CPU 1 (t=126060 jiffies)
06:08:12: sending NMI to all CPUs:
06:08:12: NMI backtrace for cpu 1
06:08:12: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
06:08:12: 
06:08:12: Pid: 3145, comm: firefox-bin Not tainted 2.6.38-rc4 #226 0MG532/MXC061                          
06:08:12: EIP: 0060:[<c110f7eb>] EFLAGS: 00000082 CPU: 1
06:08:12: EIP is at delay_tsc+0x18/0x55
06:08:12: EAX: 1f3a7d00 EBX: 00000001 ECX: 00000001 EDX: 000018bf
06:08:12: ESI: c1436640 EDI: 00000001 EBP: 001e7a67 ESP: f21a3c20
06:08:12:  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
06:08:12: Process firefox-bin (pid: 3145, ti=f21a2000 task=f613c6c0 task.ti=f21a2000)
06:08:12: Stack:
06:08:12:  00000000 c1436640 00000001 c1436640 00000001 c1436640 c110f7bf c1015f6d
06:08:12:  c13a101a f6602e14 c105c85b c13a901b c13a9102 00000001 0001ec6c 00000000
06:08:12:  00000000 00000001 00000000 00000001 f21a3d2c c105caf0 f613c6c0 c1032df0
06:08:12: Call Trace:
06:08:12:  [<c110f7bf>] ? __const_udelay+0x18/0x19
06:08:12:  [<c1015f6d>] ? arch_trigger_all_cpu_backtrace+0x52/0x65
06:08:12:  [<c105c85b>] ? __rcu_pending+0x6c/0x277
06:08:12:  [<c105caf0>] ? rcu_check_callbacks+0x8a/0xb6
06:08:12:  [<c1032df0>] ? update_process_times+0x2a/0x53
06:08:12:  [<c1047627>] ? tick_sched_timer+0x64/0x8d
06:08:12:  [<c103f332>] ? __run_hrtimer+0x6d/0xc3
06:08:12:  [<c103f595>] ? hrtimer_interrupt+0x10c/0x213
06:08:12:  [<c102e915>] ? irq_exit+0x41/0x64
06:08:12:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:08:12:  [<c10157cc>] ? smp_apic_timer_interrupt+0x6c/0x7d
06:08:12:  [<c1110a7b>] ? div_u64_rem+0xb/0x2a
06:08:12:  [<c1304e02>] ? apic_timer_interrupt+0x2a/0x30
06:08:12:  [<c111007b>] ? __put_user_8+0xf/0x19
06:08:12:  [<c106eda8>] ? shrink_zone+0x1cb/0x4c3
06:08:12:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
06:08:12:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
06:08:12:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
06:08:12:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
06:08:12:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:08:12:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
06:08:12:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
06:08:12:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
06:08:12:  [<c1047272>] ? tick_program_event+0x19/0x1c
06:08:12:  [<c102e915>] ? irq_exit+0x41/0x64
06:08:12:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:08:12:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:08:12:  [<c1305022>] ? error_code+0x5a/0x60
06:08:12:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
06:08:12:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:08:12: Code: 69 c0 c7 10 00 00 e9 dc ff ff ff 8d 04 80 e9 d4 ff ff ff 55 89 c5 57 56 53 83 ec 08 64 8b 0d b8 7f 4e c1 8d 76 00 0f ae e8 0f 31 <89> c7 8d 76 00 0f ae e8 0f 31 89 c3 89 c6 29 fb 39 eb 73 21 f3 
06:08:12: Call Trace:
06:08:12:  [<c110f7bf>] ? __const_udelay+0x18/0x19
06:08:12:  [<c1015f6d>] ? arch_trigger_all_cpu_backtrace+0x52/0x65
06:08:12:  [<c105c85b>] ? __rcu_pending+0x6c/0x277
06:08:12:  [<c105caf0>] ? rcu_check_callbacks+0x8a/0xb6
06:08:12:  [<c1032df0>] ? update_process_times+0x2a/0x53
06:08:12:  [<c1047627>] ? tick_sched_timer+0x64/0x8d
06:08:12:  [<c103f332>] ? __run_hrtimer+0x6d/0xc3
06:08:12:  [<c103f595>] ? hrtimer_interrupt+0x10c/0x213
06:08:12:  [<c102e915>] ? irq_exit+0x41/0x64
06:08:12:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:08:12:  [<c10157cc>] ? smp_apic_timer_interrupt+0x6c/0x7d
06:08:12:  [<c1110a7b>] ? div_u64_rem+0xb/0x2a
06:08:12:  [<c1304e02>] ? apic_timer_interrupt+0x2a/0x30
06:08:12:  [<c111007b>] ? __put_user_8+0xf/0x19
06:08:12:  [<c106eda8>] ? shrink_zone+0x1cb/0x4c3
06:08:12:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
06:08:12:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
06:08:12:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
06:08:12:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
06:08:12:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:08:12:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
06:08:12:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
06:08:12:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
06:08:12:  [<c1047272>] ? tick_program_event+0x19/0x1c
06:08:12:  [<c102e915>] ? irq_exit+0x41/0x64
06:08:12:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:08:12:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:08:12:  [<c1305022>] ? error_code+0x5a/0x60
06:08:12:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
06:08:12:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:08:12: Pid: 3145, comm: firefox-bin Not tainted 2.6.38-rc4 #226
06:08:12: Call Trace:
06:08:12:  [<c10054b6>] ? show_trace+0xf/0x11
06:08:12:  [<c1015eff>] ? arch_trigger_all_cpu_backtrace_handler+0x57/0x73
06:08:12:  [<c104039f>] ? notifier_call_chain+0x23/0x46
06:08:12:  [<c10403e3>] ? atomic_notifier_call_chain+0x1a/0x1d
06:08:12:  [<c1040477>] ? notify_die+0x30/0x34
06:08:12:  [<c1003657>] ? do_nmi+0x68/0x267
06:08:12:  [<c13050d1>] ? nmi_stack_correct+0x28/0x2d
06:08:12:  [<c10100d8>] ? do_machine_check+0x2c0/0x6d2
06:08:12:  [<c110f7eb>] ? delay_tsc+0x18/0x55
06:08:12:  [<c110f7bf>] ? __const_udelay+0x18/0x19
06:08:12:  [<c1015f6d>] ? arch_trigger_all_cpu_backtrace+0x52/0x65
06:08:12:  [<c105c85b>] ? __rcu_pending+0x6c/0x277
06:08:12:  [<c105caf0>] ? rcu_check_callbacks+0x8a/0xb6
06:08:12:  [<c1032df0>] ? update_process_times+0x2a/0x53
06:08:12:  [<c1047627>] ? tick_sched_timer+0x64/0x8d
06:08:12:  [<c103f332>] ? __run_hrtimer+0x6d/0xc3
06:08:12:  [<c103f595>] ? hrtimer_interrupt+0x10c/0x213
06:08:12:  [<c102e915>] ? irq_exit+0x41/0x64
06:08:12:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:08:12:  [<c10157cc>] ? smp_apic_timer_interrupt+0x6c/0x7d
06:08:12:  [<c1110a7b>] ? div_u64_rem+0xb/0x2a
06:08:12:  [<c1304e02>] ? apic_timer_interrupt+0x2a/0x30
06:08:12:  [<c111007b>] ? __put_user_8+0xf/0x19
06:08:12:  [<c106eda8>] ? shrink_zone+0x1cb/0x4c3
06:08:12:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
06:08:12:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
06:08:12:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
06:08:12:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
06:08:12:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:08:12:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
06:08:12:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
06:08:12:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
06:08:12:  [<c1047272>] ? tick_program_event+0x19/0x1c
06:08:12:  [<c102e915>] ? irq_exit+0x41/0x64
06:08:12:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:08:12:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:08:12:  [<c1305022>] ? error_code+0x5a/0x60
06:08:12:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
06:08:12:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:08:12: NMI backtrace for cpu 0
06:08:12: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
06:08:12: 
06:08:12: Pid: 0, comm: swapper Not tainted 2.6.38-rc4 #226 0MG532/MXC061                          
06:08:12: EIP: 0060:[<c1019322>] EFLAGS: 00000057 CPU: 0
06:08:12: EIP is at read_hpet+0xe/0x12
06:08:12: EAX: e2a69b43 EBX: 00fffc2e ECX: fffff000 EDX: 00000000
06:08:12: ESI: c1433a80 EDI: 47757485 EBP: c1421efc ESP: c1421efc
06:08:12:  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
06:08:12: Process swapper (pid: 0, ti=c1420000 task=c142fe20 task.ti=c1420000)
06:08:12: Stack:
06:08:12:  00000000 c1042852 00000003 c14e8cc8 0000bda3 00000000 00000000 000003e8
06:08:12:  f6402cc8 00000000 c10477a4 00000000 000003e8 00000000 c1421f6c c102eb08
06:08:12:  ffffffcf c1003d1a f60d9440 c1421f9c c1040c67 8252faaf 00002c27 00000000
06:08:12: Call Trace:
06:08:12:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:08:12:  [<c10477a4>] ? tick_check_idle+0x28/0x82
06:08:12:  [<c102eb08>] ? irq_enter+0x34/0x54
06:08:12:  [<c1003d1a>] ? do_IRQ+0x1e/0x95
06:08:12:  [<c1040c67>] ? sched_clock_local+0x19/0x17c
06:08:12:  [<c1002c69>] ? common_interrupt+0x29/0x30
06:08:12:  [<c115b48b>] ? acpi_idle_enter_bm+0x22c/0x261
06:08:12:  [<c123289f>] ? cpuidle_idle_call+0x67/0x98
06:08:12:  [<c1001ae9>] ? cpu_idle+0x41/0x5c
06:08:12:  [<c14987ce>] ? start_kernel+0x276/0x27b
06:08:12:  [<c149839a>] ? unknown_bootoption+0x0/0x18c
06:08:12: Code: 4f c1 8b 92 f0 00 00 00 29 d0 89 c2 31 c0 81 fa 80 00 00 00 ba c2 ff ff ff 0f 4c c2 c3 55 a1 34 e7 4f c1 89 e5 8b 80 f0 00 00 00 <31> d2 c9 c3 83 3d 38 e7 4f c1 00 75 37 83 3d 20 e7 4f c1 00 74 
06:08:12: Call Trace:
06:08:12:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:08:12:  [<c10477a4>] ? tick_check_idle+0x28/0x82
06:08:12:  [<c102eb08>] ? irq_enter+0x34/0x54
06:08:12:  [<c1003d1a>] ? do_IRQ+0x1e/0x95
06:08:12:  [<c1040c67>] ? sched_clock_local+0x19/0x17c
06:08:12:  [<c1002c69>] ? common_interrupt+0x29/0x30
06:08:12:  [<c115b48b>] ? acpi_idle_enter_bm+0x22c/0x261
06:08:12:  [<c123289f>] ? cpuidle_idle_call+0x67/0x98
06:08:12:  [<c1001ae9>] ? cpu_idle+0x41/0x5c
06:08:12:  [<c14987ce>] ? start_kernel+0x276/0x27b
06:08:12:  [<c149839a>] ? unknown_bootoption+0x0/0x18c
06:08:12: Pid: 0, comm: swapper Not tainted 2.6.38-rc4 #226
06:08:12: Call Trace:
06:08:12:  [<c10054b6>] ? show_trace+0xf/0x11
06:08:12:  [<c1015eff>] ? arch_trigger_all_cpu_backtrace_handler+0x57/0x73
06:08:12:  [<c104039f>] ? notifier_call_chain+0x23/0x46
06:08:12:  [<c10403e3>] ? atomic_notifier_call_chain+0x1a/0x1d
06:08:12:  [<c1040477>] ? notify_die+0x30/0x34
06:08:12:  [<c1003657>] ? do_nmi+0x68/0x267
06:08:12:  [<c13050d1>] ? nmi_stack_correct+0x28/0x2d
06:08:12:  [<c104007b>] ? copy_namespaces+0x1/0x7e
06:08:12:  [<c1019322>] ? read_hpet+0xe/0x12
06:08:12:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:08:12:  [<c10477a4>] ? tick_check_idle+0x28/0x82
06:08:12:  [<c102eb08>] ? irq_enter+0x34/0x54
06:08:12:  [<c1003d1a>] ? do_IRQ+0x1e/0x95
06:08:12:  [<c1040c67>] ? sched_clock_local+0x19/0x17c
06:08:12:  [<c1002c69>] ? common_interrupt+0x29/0x30
06:08:12:  [<c115b48b>] ? acpi_idle_enter_bm+0x22c/0x261
06:08:12:  [<c123289f>] ? cpuidle_idle_call+0x67/0x98
06:08:12:  [<c1001ae9>] ? cpu_idle+0x41/0x5c
06:08:12:  [<c14987ce>] ? start_kernel+0x276/0x27b
06:08:12:  [<c149839a>] ? unknown_bootoption+0x0/0x18c
06:09:19: BUG: soft lockup - CPU#1 stuck for 61s! [firefox-bin:3145]
06:09:19: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
06:09:19: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
06:09:19: 
06:09:19: Pid: 3145, comm: firefox-bin Not tainted 2.6.38-rc4 #226 0MG532/MXC061                          
06:09:19: EIP: 0060:[<c106eda8>] EFLAGS: 00000202 CPU: 1
06:09:19: EIP is at shrink_zone+0x1cb/0x4c3
06:09:19: EAX: 00000cf1 EBX: c1492e00 ECX: 0000003d EDX: 00000015
06:09:19: ESI: f21a3e24 EDI: c1493040 EBP: f21a3dec ESP: f21a3d68
06:09:19:  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
06:09:19: Process firefox-bin (pid: 3145, ti=f21a2000 task=f613c6c0 task.ti=f21a2000)
06:09:19: Stack:
06:09:19:  00000d2f 00000000 00000000 c1492e00 0000c88d 00000020 00000021 c1493098
06:09:19:  00000004 c14930a8 c1493040 c14930a4 c14930a0 c149309c 0000000b 0000a189
06:09:19:  00001e15 00000000 0000003c 00000000 00000000 00000000 00000000 00000040
06:09:19: Call Trace:
06:09:19:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
06:09:19:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
06:09:19:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
06:09:19:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
06:09:19:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:09:19:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
06:09:19:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
06:09:19:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
06:09:19:  [<c1047272>] ? tick_program_event+0x19/0x1c
06:09:19:  [<c102e915>] ? irq_exit+0x41/0x64
06:09:19:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:09:19:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:09:19:  [<c1305022>] ? error_code+0x5a/0x60
06:09:19:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
06:09:19:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:09:19: Code: 8b 93 78 02 00 00 8b bb 70 02 00 00 42 47 89 c1 b8 c9 00 00 00 2b 44 24 48 0f af c2 31 d2 f7 f7 8b 7c 24 28 fe 07 fb 89 44 24 68 <89> 4c 24 60 8d 44 01 01 c7 44 24 64 00 00 00 00 c7 44 24 6c 00 
06:09:19: Call Trace:
06:09:19:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
06:09:19:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
06:09:19:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
06:09:19:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
06:09:19:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:09:19:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
06:09:19:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
06:09:19:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
06:09:19:  [<c1047272>] ? tick_program_event+0x19/0x1c
06:09:19:  [<c102e915>] ? irq_exit+0x41/0x64
06:09:19:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:09:19:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:09:19:  [<c1305022>] ? error_code+0x5a/0x60
06:09:19:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
06:09:19:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:10:31: BUG: soft lockup - CPU#1 stuck for 63s! [firefox-bin:3145]
06:10:31: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
06:10:31: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
06:10:31: 
06:10:31: Pid: 3145, comm: firefox-bin Not tainted 2.6.38-rc4 #226 0MG532/MXC061                          
06:10:31: EIP: 0060:[<c106eda8>] EFLAGS: 00000202 CPU: 1
06:10:31: EIP is at shrink_zone+0x1cb/0x4c3
06:10:31: EAX: 00000cf8 EBX: c1492e00 ECX: 0000003d EDX: 00000009
06:10:31: ESI: f21a3e24 EDI: c1493040 EBP: f21a3dec ESP: f21a3d68
06:10:31:  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
06:10:31: Process firefox-bin (pid: 3145, ti=f21a2000 task=f613c6c0 task.ti=f21a2000)
06:10:31: Stack:
06:10:31:  00000d36 00000000 00000000 c1492e00 0000c88d 00000020 00000021 c1493098
06:10:31:  00000004 c14930a8 c1493040 c14930a4 c14930a0 c149309c 0000000b 0000a189
06:10:31:  00001e17 00000000 0000003c 00000000 00000000 00000000 00000000 00000040
06:10:31: Call Trace:
06:10:31:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
06:10:31:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
06:10:31:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
06:10:31:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
06:10:31:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:10:31:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
06:10:31:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
06:10:31:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
06:10:31:  [<c1047272>] ? tick_program_event+0x19/0x1c
06:10:31:  [<c102e915>] ? irq_exit+0x41/0x64
06:10:31:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:10:31:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:10:31:  [<c1305022>] ? error_code+0x5a/0x60
06:10:31:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
06:10:31:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:10:31: Code: 8b 93 78 02 00 00 8b bb 70 02 00 00 42 47 89 c1 b8 c9 00 00 00 2b 44 24 48 0f af c2 31 d2 f7 f7 8b 7c 24 28 fe 07 fb 89 44 24 68 <89> 4c 24 60 8d 44 01 01 c7 44 24 64 00 00 00 00 c7 44 24 6c 00 
06:10:31: Call Trace:
06:10:31:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
06:10:31:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
06:10:31:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
06:10:31:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
06:10:31:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:10:31:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
06:10:31:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
06:10:31:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
06:10:31:  [<c1047272>] ? tick_program_event+0x19/0x1c
06:10:31:  [<c102e915>] ? irq_exit+0x41/0x64
06:10:31:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:10:31:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:10:31:  [<c1305022>] ? error_code+0x5a/0x60
06:10:31:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
06:10:31:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:11:12: INFO: rcu_sched_state detected stall on CPU 1 (t=180090 jiffies)
06:11:12: sending NMI to all CPUs:
06:11:12: NMI backtrace for cpu 1
06:11:12: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
06:11:12: 
06:11:12: Pid: 3145, comm: firefox-bin Not tainted 2.6.38-rc4 #226 0MG532/MXC061                          
06:11:12: EIP: 0060:[<c110f7b1>] EFLAGS: 00000006 CPU: 1
06:11:12: EIP is at __const_udelay+0xa/0x19
06:11:12: EAX: 01062560 EBX: 00000001 ECX: 00000800 EDX: 006597cf
06:11:12: ESI: c1436640 EDI: 00000001 EBP: c1436640 ESP: f21a3c3c
06:11:12:  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
06:11:12: Process firefox-bin (pid: 3145, ti=f21a2000 task=f613c6c0 task.ti=f21a2000)
06:11:12: Stack:
06:11:12:  c1015f6d c13a101a f6602e14 c105c85b c13a901b c13a9102 00000001 0002bf7a
06:11:12:  00000000 00000000 00000001 00000000 00000001 f21a3d2c c105caf0 f613c6c0
06:11:12:  c1032df0 f6602cc8 711e7ead 00002c51 c1047627 f6602cc8 f6602c70 f6602cc8
06:11:12: Call Trace:
06:11:12:  [<c1015f6d>] ? arch_trigger_all_cpu_backtrace+0x52/0x65
06:11:12:  [<c105c85b>] ? __rcu_pending+0x6c/0x277
06:11:12:  [<c105caf0>] ? rcu_check_callbacks+0x8a/0xb6
06:11:12:  [<c1032df0>] ? update_process_times+0x2a/0x53
06:11:12:  [<c1047627>] ? tick_sched_timer+0x64/0x8d
06:11:12:  [<c103f332>] ? __run_hrtimer+0x6d/0xc3
06:11:12:  [<c103f595>] ? hrtimer_interrupt+0x10c/0x213
06:11:12:  [<c102e915>] ? irq_exit+0x41/0x64
06:11:12:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:11:12:  [<c10157cc>] ? smp_apic_timer_interrupt+0x6c/0x7d
06:11:12:  [<c1110a8b>] ? div_u64_rem+0x1b/0x2a
06:11:12:  [<c1304e02>] ? apic_timer_interrupt+0x2a/0x30
06:11:12:  [<c106eda8>] ? shrink_zone+0x1cb/0x4c3
06:11:12:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
06:11:12:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
06:11:12:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
06:11:12:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
06:11:12:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:11:12:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
06:11:12:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
06:11:12:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
06:11:12:  [<c1047272>] ? tick_program_event+0x19/0x1c
06:11:12:  [<c102e915>] ? irq_exit+0x41/0x64
06:11:12:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:11:12:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:11:12:  [<c1305022>] ? error_code+0x5a/0x60
06:11:12:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
06:11:12:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:11:12: Code: 00 00 00 8d bc 27 00 00 00 00 48 75 fd 48 c3 c7 05 c0 14 44 c1 d3 f7 10 c1 c3 ff 15 c0 14 44 c1 c3 c1 e0 02 64 8b 15 9c b9 4e c1 <6b> d2 4b f7 e2 8d 42 01 ff 15 c0 14 44 c1 c3 69 c0 c7 10 00 00 
06:11:12: Call Trace:
06:11:12:  [<c1015f6d>] ? arch_trigger_all_cpu_backtrace+0x52/0x65
06:11:12:  [<c105c85b>] ? __rcu_pending+0x6c/0x277
06:11:12:  [<c105caf0>] ? rcu_check_callbacks+0x8a/0xb6
06:11:12:  [<c1032df0>] ? update_process_times+0x2a/0x53
06:11:12:  [<c1047627>] ? tick_sched_timer+0x64/0x8d
06:11:12:  [<c103f332>] ? __run_hrtimer+0x6d/0xc3
06:11:12:  [<c103f595>] ? hrtimer_interrupt+0x10c/0x213
06:11:12:  [<c102e915>] ? irq_exit+0x41/0x64
06:11:12:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:11:12:  [<c10157cc>] ? smp_apic_timer_interrupt+0x6c/0x7d
06:11:12:  [<c1110a8b>] ? div_u64_rem+0x1b/0x2a
06:11:12:  [<c1304e02>] ? apic_timer_interrupt+0x2a/0x30
06:11:12:  [<c106eda8>] ? shrink_zone+0x1cb/0x4c3
06:11:12:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
06:11:12:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
06:11:12:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
06:11:12:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
06:11:12:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:11:12:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
06:11:12:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
06:11:12:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
06:11:12:  [<c1047272>] ? tick_program_event+0x19/0x1c
06:11:12:  [<c102e915>] ? irq_exit+0x41/0x64
06:11:12:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:11:12:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:11:12:  [<c1305022>] ? error_code+0x5a/0x60
06:11:12:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
06:11:12:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:11:12: Pid: 3145, comm: firefox-bin Not tainted 2.6.38-rc4 #226
06:11:12: Call Trace:
06:11:12:  [<c10054b6>] ? show_trace+0xf/0x11
06:11:12:  [<c1015eff>] ? arch_trigger_all_cpu_backtrace_handler+0x57/0x73
06:11:12:  [<c104039f>] ? notifier_call_chain+0x23/0x46
06:11:12:  [<c10403e3>] ? atomic_notifier_call_chain+0x1a/0x1d
06:11:12:  [<c1040477>] ? notify_die+0x30/0x34
06:11:12:  [<c1003657>] ? do_nmi+0x68/0x267
06:11:12:  [<c13050d1>] ? nmi_stack_correct+0x28/0x2d
06:11:12:  [<c110f7b1>] ? __const_udelay+0xa/0x19
06:11:12:  [<c1015f6d>] ? arch_trigger_all_cpu_backtrace+0x52/0x65
06:11:12:  [<c105c85b>] ? __rcu_pending+0x6c/0x277
06:11:12:  [<c105caf0>] ? rcu_check_callbacks+0x8a/0xb6
06:11:12:  [<c1032df0>] ? update_process_times+0x2a/0x53
06:11:12:  [<c1047627>] ? tick_sched_timer+0x64/0x8d
06:11:12:  [<c103f332>] ? __run_hrtimer+0x6d/0xc3
06:11:12:  [<c103f595>] ? hrtimer_interrupt+0x10c/0x213
06:11:12:  [<c102e915>] ? irq_exit+0x41/0x64
06:11:12:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:11:12:  [<c10157cc>] ? smp_apic_timer_interrupt+0x6c/0x7d
06:11:12:  [<c1110a8b>] ? div_u64_rem+0x1b/0x2a
06:11:12:  [<c1304e02>] ? apic_timer_interrupt+0x2a/0x30
06:11:12:  [<c106eda8>] ? shrink_zone+0x1cb/0x4c3
06:11:12:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
06:11:12:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
06:11:12:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
06:11:12:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
06:11:12:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:11:12:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
06:11:12:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
06:11:12:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
06:11:12:  [<c1047272>] ? tick_program_event+0x19/0x1c
06:11:12:  [<c102e915>] ? irq_exit+0x41/0x64
06:11:12:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:11:12:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:11:12:  [<c1305022>] ? error_code+0x5a/0x60
06:11:12:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
06:11:12:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:11:12: NMI backtrace for cpu 0
06:11:12: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
06:11:12: 
06:11:12: Pid: 0, comm: swapper Not tainted 2.6.38-rc4 #226 0MG532/MXC061                          
06:11:12: EIP: 0060:[<c1019322>] EFLAGS: 00000047 CPU: 0
06:11:12: EIP is at read_hpet+0xe/0x12
06:11:12: EAX: 7c5af9a0 EBX: 0101a24a ECX: fffff000 EDX: 00000000
06:11:12: ESI: c1433a80 EDI: 4d6e1818 EBP: c1421efc ESP: c1421efc
06:11:12:  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
06:11:12: Process swapper (pid: 0, ti=c1420000 task=c142fe20 task.ti=c1420000)
06:11:12: Stack:
06:11:12:  00000000 c1042852 00000003 c14e8cc8 0000be57 00000000 00000000 000003e8
06:11:12:  f6402cc8 00000000 c10477a4 00000000 000003e8 00000000 c1421f6c c102eb08
06:11:12:  ffffffcf c1003d1a f60d9440 c1421f9c c1040c67 711e9d02 00002c51 00000000
06:11:12: Call Trace:
06:11:12:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:11:12:  [<c10477a4>] ? tick_check_idle+0x28/0x82
06:11:12:  [<c102eb08>] ? irq_enter+0x34/0x54
06:11:12:  [<c1003d1a>] ? do_IRQ+0x1e/0x95
06:11:12:  [<c1040c67>] ? sched_clock_local+0x19/0x17c
06:11:12:  [<c1002c69>] ? common_interrupt+0x29/0x30
06:11:12:  [<c115b48b>] ? acpi_idle_enter_bm+0x22c/0x261
06:11:12:  [<c123289f>] ? cpuidle_idle_call+0x67/0x98
06:11:12:  [<c1001ae9>] ? cpu_idle+0x41/0x5c
06:11:12:  [<c14987ce>] ? start_kernel+0x276/0x27b
06:11:12:  [<c149839a>] ? unknown_bootoption+0x0/0x18c
06:11:12: Code: 4f c1 8b 92 f0 00 00 00 29 d0 89 c2 31 c0 81 fa 80 00 00 00 ba c2 ff ff ff 0f 4c c2 c3 55 a1 34 e7 4f c1 89 e5 8b 80 f0 00 00 00 <31> d2 c9 c3 83 3d 38 e7 4f c1 00 75 37 83 3d 20 e7 4f c1 00 74 
06:11:12: Call Trace:
06:11:12:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:11:12:  [<c10477a4>] ? tick_check_idle+0x28/0x82
06:11:12:  [<c102eb08>] ? irq_enter+0x34/0x54
06:11:12:  [<c1003d1a>] ? do_IRQ+0x1e/0x95
06:11:12:  [<c1040c67>] ? sched_clock_local+0x19/0x17c
06:11:12:  [<c1002c69>] ? common_interrupt+0x29/0x30
06:11:12:  [<c115b48b>] ? acpi_idle_enter_bm+0x22c/0x261
06:11:12:  [<c123289f>] ? cpuidle_idle_call+0x67/0x98
06:11:12:  [<c1001ae9>] ? cpu_idle+0x41/0x5c
06:11:12:  [<c14987ce>] ? start_kernel+0x276/0x27b
06:11:12:  [<c149839a>] ? unknown_bootoption+0x0/0x18c
06:11:12: Pid: 0, comm: swapper Not tainted 2.6.38-rc4 #226
06:11:12: Call Trace:
06:11:12:  [<c10054b6>] ? show_trace+0xf/0x11
06:11:12:  [<c1015eff>] ? arch_trigger_all_cpu_backtrace_handler+0x57/0x73
06:11:12:  [<c104039f>] ? notifier_call_chain+0x23/0x46
06:11:12:  [<c10403e3>] ? atomic_notifier_call_chain+0x1a/0x1d
06:11:12:  [<c1040477>] ? notify_die+0x30/0x34
06:11:12:  [<c1003657>] ? do_nmi+0x68/0x267
06:11:12:  [<c13050d1>] ? nmi_stack_correct+0x28/0x2d
06:11:12:  [<c104007b>] ? copy_namespaces+0x1/0x7e
06:11:12:  [<c1019322>] ? read_hpet+0xe/0x12
06:11:12:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:11:12:  [<c10477a4>] ? tick_check_idle+0x28/0x82
06:11:12:  [<c102eb08>] ? irq_enter+0x34/0x54
06:11:12:  [<c1003d1a>] ? do_IRQ+0x1e/0x95
06:11:12:  [<c1040c67>] ? sched_clock_local+0x19/0x17c
06:11:12:  [<c1002c69>] ? common_interrupt+0x29/0x30
06:11:12:  [<c115b48b>] ? acpi_idle_enter_bm+0x22c/0x261
06:11:12:  [<c123289f>] ? cpuidle_idle_call+0x67/0x98
06:11:12:  [<c1001ae9>] ? cpu_idle+0x41/0x5c
06:11:12:  [<c14987ce>] ? start_kernel+0x276/0x27b
06:11:12:  [<c149839a>] ? unknown_bootoption+0x0/0x18c
06:12:17: BUG: soft lockup - CPU#1 stuck for 61s! [firefox-bin:3145]
06:12:17: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
06:12:17: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
06:12:17: 
06:12:17: Pid: 3145, comm: firefox-bin Not tainted 2.6.38-rc4 #226 0MG532/MXC061                          
06:12:17: EIP: 0060:[<c106eda8>] EFLAGS: 00000282 CPU: 1
06:12:17: EIP is at shrink_zone+0x1cb/0x4c3
06:12:17: EAX: 00000d05 EBX: c1492e00 ECX: 0000003d EDX: 0000001b
06:12:17: ESI: f21a3e24 EDI: c1493040 EBP: f21a3dec ESP: f21a3d68
06:12:17:  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
06:12:17: Process firefox-bin (pid: 3145, ti=f21a2000 task=f613c6c0 task.ti=f21a2000)
06:12:17: Stack:
06:12:17:  00000d43 00000000 00000000 c1492e00 0000c88d 00000020 00000021 c1493098
06:12:17:  00000004 c14930a8 c1493040 c14930a4 c14930a0 c149309c 0000000b 0000a189
06:12:17:  00001e1b 00000000 0000003c 00000000 00000000 00000000 00000000 00000040
06:12:17: Call Trace:
06:12:17:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
06:12:17:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
06:12:17:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
06:12:17:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
06:12:17:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:12:17:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
06:12:17:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
06:12:17:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
06:12:17:  [<c1047272>] ? tick_program_event+0x19/0x1c
06:12:17:  [<c102e915>] ? irq_exit+0x41/0x64
06:12:17:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:12:17:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:12:17:  [<c1305022>] ? error_code+0x5a/0x60
06:12:17:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
06:12:17:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:12:17: Code: 8b 93 78 02 00 00 8b bb 70 02 00 00 42 47 89 c1 b8 c9 00 00 00 2b 44 24 48 0f af c2 31 d2 f7 f7 8b 7c 24 28 fe 07 fb 89 44 24 68 <89> 4c 24 60 8d 44 01 01 c7 44 24 64 00 00 00 00 c7 44 24 6c 00 
06:12:17: Call Trace:
06:12:17:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
06:12:17:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
06:12:17:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
06:12:17:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
06:12:17:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:12:17:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
06:12:17:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
06:12:17:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
06:12:17:  [<c1047272>] ? tick_program_event+0x19/0x1c
06:12:17:  [<c102e915>] ? irq_exit+0x41/0x64
06:12:17:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:12:17:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:12:17:  [<c1305022>] ? error_code+0x5a/0x60
06:12:17:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
06:12:17:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:13:28: BUG: soft lockup - CPU#1 stuck for 63s! [firefox-bin:3145]
06:13:28: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
06:13:28: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
06:13:28: 
06:13:28: Pid: 3145, comm: firefox-bin Not tainted 2.6.38-rc4 #226 0MG532/MXC061                          
06:13:28: EIP: 0060:[<c1110a8b>] EFLAGS: 00000293 CPU: 1
06:13:28: EIP is at div_u64_rem+0x1b/0x2a
06:13:28: EAX: 00000000 EBX: 000005f5 ECX: 00000000 EDX: 000005f5
06:13:28: ESI: 00000d4a EDI: f21a3d50 EBP: f21a3d30 ESP: f21a3d28
06:13:28:  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
06:13:28: Process firefox-bin (pid: 3145, ti=f21a2000 task=f613c6c0 task.ti=f21a2000)
06:13:28: Stack:
06:13:28:  000005f5 00000000 f21a3d60 c1110bcb f21a3d50 00000000 00000000 00000d0c
06:13:28:  c111007b 0000007b 00000d0c 00000000 f21a3e24 00000000 f21a3dec c106ee41
06:13:28:  00000d4a 00000000 00000000 c1492e00 0000c88d 00000020 00000021 c1493098
06:13:28: Call Trace:
06:13:28:  [<c1110bcb>] ? div64_u64+0x25/0xef
06:13:28:  [<c111007b>] ? __put_user_8+0xf/0x19
06:13:28:  [<c106ee41>] ? shrink_zone+0x264/0x4c3
06:13:28:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
06:13:28:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
06:13:28:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
06:13:28:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
06:13:28:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:13:28:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
06:13:28:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
06:13:28:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
06:13:28:  [<c1047272>] ? tick_program_event+0x19/0x1c
06:13:28:  [<c102e915>] ? irq_exit+0x41/0x64
06:13:28:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:13:28:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:13:28:  [<c1305022>] ? error_code+0x5a/0x60
06:13:28:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
06:13:28:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:13:28: Code: 00 00 00 31 d2 f7 f1 c1 e0 04 01 d0 c3 90 90 90 55 89 e5 56 89 ce 53 31 c9 89 c3 39 f2 72 08 89 d0 31 d2 f7 f6 89 c1 89 d8 f7 f6 <89> c3 8b 45 08 89 10 89 d8 89 ca 5b 5e c9 c3 55 89 c5 57 56 89 
06:13:28: Call Trace:
06:13:28:  [<c1110bcb>] ? div64_u64+0x25/0xef
06:13:28:  [<c111007b>] ? __put_user_8+0xf/0x19
06:13:28:  [<c106ee41>] ? shrink_zone+0x264/0x4c3
06:13:28:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
06:13:28:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
06:13:28:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
06:13:28:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
06:13:28:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:13:28:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
06:13:28:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
06:13:28:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
06:13:28:  [<c1047272>] ? tick_program_event+0x19/0x1c
06:13:28:  [<c102e915>] ? irq_exit+0x41/0x64
06:13:28:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:13:28:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:13:28:  [<c1305022>] ? error_code+0x5a/0x60
06:13:28:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
06:13:28:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:14:12: INFO: rcu_sched_state detected stall on CPU 1 (t=234120 jiffies)
06:14:12: sending NMI to all CPUs:
06:14:12: NMI backtrace for cpu 1
06:14:12: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
06:14:12: 
06:14:12: Pid: 3145, comm: firefox-bin Not tainted 2.6.38-rc4 #226 0MG532/MXC061                          
06:14:12: EIP: 0060:[<c110f7b1>] EFLAGS: 00000006 CPU: 1
06:14:12: EIP is at __const_udelay+0xa/0x19
06:14:12: EAX: 01062560 EBX: 00000001 ECX: 00000800 EDX: 006597cf
06:14:12: ESI: c1436640 EDI: 00000001 EBP: c1436640 ESP: f21a3c3c
06:14:12:  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
06:14:12: Process firefox-bin (pid: 3145, ti=f21a2000 task=f613c6c0 task.ti=f21a2000)
06:14:12: Stack:
06:14:12:  c1015f6d c13a101a f6602e14 c105c85b c13a901b c13a9102 00000001 00039288
06:14:12:  00000000 00000000 00000001 00000000 00000001 f21a3d2c c105caf0 f613c6c0
06:14:12:  c1032df0 f6602cc8 5fea1ffe 00002c7b c1047627 f6602cc8 f6602c70 f6602cc8
06:14:12: Call Trace:
06:14:12:  [<c1015f6d>] ? arch_trigger_all_cpu_backtrace+0x52/0x65
06:14:12:  [<c105c85b>] ? __rcu_pending+0x6c/0x277
06:14:12:  [<c105caf0>] ? rcu_check_callbacks+0x8a/0xb6
06:14:12:  [<c1032df0>] ? update_process_times+0x2a/0x53
06:14:12:  [<c1047627>] ? tick_sched_timer+0x64/0x8d
06:14:12:  [<c103f332>] ? __run_hrtimer+0x6d/0xc3
06:14:12:  [<c103f595>] ? hrtimer_interrupt+0x10c/0x213
06:14:12:  [<c102e915>] ? irq_exit+0x41/0x64
06:14:12:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:14:12:  [<c10157cc>] ? smp_apic_timer_interrupt+0x6c/0x7d
06:14:12:  [<c1110a8d>] ? div_u64_rem+0x1d/0x2a
06:14:12:  [<c1304e02>] ? apic_timer_interrupt+0x2a/0x30
06:14:12:  [<c106eda8>] ? shrink_zone+0x1cb/0x4c3
06:14:12:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
06:14:12:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
06:14:12:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
06:14:12:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
06:14:12:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:14:12:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
06:14:12:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
06:14:12:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
06:14:12:  [<c1047272>] ? tick_program_event+0x19/0x1c
06:14:12:  [<c102e915>] ? irq_exit+0x41/0x64
06:14:12:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:14:12:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:14:12:  [<c1305022>] ? error_code+0x5a/0x60
06:14:12:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
06:14:12:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:14:12: Code: 00 00 00 8d bc 27 00 00 00 00 48 75 fd 48 c3 c7 05 c0 14 44 c1 d3 f7 10 c1 c3 ff 15 c0 14 44 c1 c3 c1 e0 02 64 8b 15 9c b9 4e c1 <6b> d2 4b f7 e2 8d 42 01 ff 15 c0 14 44 c1 c3 69 c0 c7 10 00 00 
06:14:12: Call Trace:
06:14:12:  [<c1015f6d>] ? arch_trigger_all_cpu_backtrace+0x52/0x65
06:14:12:  [<c105c85b>] ? __rcu_pending+0x6c/0x277
06:14:12:  [<c105caf0>] ? rcu_check_callbacks+0x8a/0xb6
06:14:12:  [<c1032df0>] ? update_process_times+0x2a/0x53
06:14:12:  [<c1047627>] ? tick_sched_timer+0x64/0x8d
06:14:12:  [<c103f332>] ? __run_hrtimer+0x6d/0xc3
06:14:12:  [<c103f595>] ? hrtimer_interrupt+0x10c/0x213
06:14:12:  [<c102e915>] ? irq_exit+0x41/0x64
06:14:12:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:14:12:  [<c10157cc>] ? smp_apic_timer_interrupt+0x6c/0x7d
06:14:12:  [<c1110a8d>] ? div_u64_rem+0x1d/0x2a
06:14:12:  [<c1304e02>] ? apic_timer_interrupt+0x2a/0x30
06:14:12:  [<c106eda8>] ? shrink_zone+0x1cb/0x4c3
06:14:12:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
06:14:12:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
06:14:12:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
06:14:12:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
06:14:12:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:14:12:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
06:14:12:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
06:14:12:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
06:14:12:  [<c1047272>] ? tick_program_event+0x19/0x1c
06:14:12:  [<c102e915>] ? irq_exit+0x41/0x64
06:14:12:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:14:12:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:14:12:  [<c1305022>] ? error_code+0x5a/0x60
06:14:12:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
06:14:12:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:14:12: Pid: 3145, comm: firefox-bin Not tainted 2.6.38-rc4 #226
06:14:12: Call Trace:
06:14:12:  [<c10054b6>] ? show_trace+0xf/0x11
06:14:12:  [<c1015eff>] ? arch_trigger_all_cpu_backtrace_handler+0x57/0x73
06:14:12:  [<c104039f>] ? notifier_call_chain+0x23/0x46
06:14:12:  [<c10403e3>] ? atomic_notifier_call_chain+0x1a/0x1d
06:14:12:  [<c1040477>] ? notify_die+0x30/0x34
06:14:12:  [<c1003657>] ? do_nmi+0x68/0x267
06:14:12:  [<c13050d1>] ? nmi_stack_correct+0x28/0x2d
06:14:12:  [<c110f7b1>] ? __const_udelay+0xa/0x19
06:14:12:  [<c1015f6d>] ? arch_trigger_all_cpu_backtrace+0x52/0x65
06:14:12:  [<c105c85b>] ? __rcu_pending+0x6c/0x277
06:14:12:  [<c105caf0>] ? rcu_check_callbacks+0x8a/0xb6
06:14:12:  [<c1032df0>] ? update_process_times+0x2a/0x53
06:14:12:  [<c1047627>] ? tick_sched_timer+0x64/0x8d
06:14:12:  [<c103f332>] ? __run_hrtimer+0x6d/0xc3
06:14:12:  [<c103f595>] ? hrtimer_interrupt+0x10c/0x213
06:14:12:  [<c102e915>] ? irq_exit+0x41/0x64
06:14:12:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:14:12:  [<c10157cc>] ? smp_apic_timer_interrupt+0x6c/0x7d
06:14:12:  [<c1110a8d>] ? div_u64_rem+0x1d/0x2a
06:14:12:  [<c1304e02>] ? apic_timer_interrupt+0x2a/0x30
06:14:12:  [<c106eda8>] ? shrink_zone+0x1cb/0x4c3
06:14:12:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
06:14:12:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
06:14:12:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
06:14:12:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
06:14:12:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:14:12:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
06:14:12:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
06:14:12:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
06:14:12:  [<c1047272>] ? tick_program_event+0x19/0x1c
06:14:12:  [<c102e915>] ? irq_exit+0x41/0x64
06:14:12:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:14:12:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:14:12:  [<c1305022>] ? error_code+0x5a/0x60
06:14:12:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
06:14:12:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:14:12: NMI backtrace for cpu 0
06:14:12: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
06:14:12: 
06:14:12: Pid: 0, comm: swapper Not tainted 2.6.38-rc4 #226 0MG532/MXC061                          
06:14:12: EIP: 0060:[<c1014d6d>] EFLAGS: 00000002 CPU: 0
06:14:12: EIP is at lapic_timer_setup+0x1e/0x6d
06:14:12: EAX: 00000003 EBX: 00000046 ECX: 00000001 EDX: 00000000
06:14:12: ESI: 00000003 EDI: c14e8cc8 EBP: 00000000 ESP: c1421f14
06:14:12:  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
06:14:12: Process swapper (pid: 0, ti=c1420000 task=c142fe20 task.ti=c1420000)
06:14:12: Stack:
06:14:12:  f6401fc0 c1046378 00000000 000003e8 c104778c 00000000 000003e8 00000000
06:14:12:  c1421f6c c102eb08 ffffffcf c1003d1a f60d9440 c1421f9c c1040c67 5fea41df
06:14:12:  00002c7b 00000000 000003e8 f60d9440 f60d9000 c1002c69 00000000 00002c7b
06:14:12: Call Trace:
06:14:12:  [<c1046378>] ? clockevents_set_mode+0x12/0x3b
06:14:12:  [<c104778c>] ? tick_check_idle+0x10/0x82
06:14:12:  [<c102eb08>] ? irq_enter+0x34/0x54
06:14:12:  [<c1003d1a>] ? do_IRQ+0x1e/0x95
06:14:12:  [<c1040c67>] ? sched_clock_local+0x19/0x17c
06:14:12:  [<c1002c69>] ? common_interrupt+0x29/0x30
06:14:12:  [<c115b48b>] ? acpi_idle_enter_bm+0x22c/0x261
06:14:12:  [<c123289f>] ? cpuidle_idle_call+0x67/0x98
06:14:12:  [<c1001ae9>] ? cpu_idle+0x41/0x5c
06:14:12:  [<c14987ce>] ? start_kernel+0x276/0x27b
06:14:12:  [<c149839a>] ? unknown_bootoption+0x0/0x18c
06:14:12: Code: 80 03 00 00 ff 91 a8 00 00 00 31 c0 c3 53 f6 42 04 08 75 64 9c 5b fa 83 f8 01 76 1e 83 f8 03 77 55 31 d2 b9 01 00 00 00 83 f8 02 <a1> cc af 4f c1 0f 95 c2 e8 2a ff ff ff eb 3c 8b 15 b4 37 43 c1 
06:14:12: Call Trace:
06:14:12:  [<c1046378>] ? clockevents_set_mode+0x12/0x3b
06:14:12:  [<c104778c>] ? tick_check_idle+0x10/0x82
06:14:12:  [<c102eb08>] ? irq_enter+0x34/0x54
06:14:12:  [<c1003d1a>] ? do_IRQ+0x1e/0x95
06:14:12:  [<c1040c67>] ? sched_clock_local+0x19/0x17c
06:14:12:  [<c1002c69>] ? common_interrupt+0x29/0x30
06:14:12:  [<c115b48b>] ? acpi_idle_enter_bm+0x22c/0x261
06:14:12:  [<c123289f>] ? cpuidle_idle_call+0x67/0x98
06:14:12:  [<c1001ae9>] ? cpu_idle+0x41/0x5c
06:14:12:  [<c14987ce>] ? start_kernel+0x276/0x27b
06:14:12:  [<c149839a>] ? unknown_bootoption+0x0/0x18c
06:14:12: Pid: 0, comm: swapper Not tainted 2.6.38-rc4 #226
06:14:12: Call Trace:
06:14:12:  [<c10054b6>] ? show_trace+0xf/0x11
06:14:12:  [<c1015eff>] ? arch_trigger_all_cpu_backtrace_handler+0x57/0x73
06:14:12:  [<c104039f>] ? notifier_call_chain+0x23/0x46
06:14:12:  [<c10403e3>] ? atomic_notifier_call_chain+0x1a/0x1d
06:14:12:  [<c1040477>] ? notify_die+0x30/0x34
06:14:12:  [<c1003657>] ? do_nmi+0x68/0x267
06:14:12:  [<c13050d1>] ? nmi_stack_correct+0x28/0x2d
06:14:12:  [<c1014d6d>] ? lapic_timer_setup+0x1e/0x6d
06:14:12:  [<c1046378>] ? clockevents_set_mode+0x12/0x3b
06:14:12:  [<c104778c>] ? tick_check_idle+0x10/0x82
06:14:12:  [<c102eb08>] ? irq_enter+0x34/0x54
06:14:12:  [<c1003d1a>] ? do_IRQ+0x1e/0x95
06:14:12:  [<c1040c67>] ? sched_clock_local+0x19/0x17c
06:14:12:  [<c1002c69>] ? common_interrupt+0x29/0x30
06:14:12:  [<c115b48b>] ? acpi_idle_enter_bm+0x22c/0x261
06:14:12:  [<c123289f>] ? cpuidle_idle_call+0x67/0x98
06:14:12:  [<c1001ae9>] ? cpu_idle+0x41/0x5c
06:14:12:  [<c14987ce>] ? start_kernel+0x276/0x27b
06:14:12:  [<c149839a>] ? unknown_bootoption+0x0/0x18c
06:15:21: BUG: soft lockup - CPU#1 stuck for 63s! [firefox-bin:3145]
06:15:21: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
06:15:21: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
06:15:21: 
06:15:21: Pid: 3145, comm: firefox-bin Not tainted 2.6.38-rc4 #226 0MG532/MXC061                          
06:15:21: EIP: 0060:[<c1110a8b>] EFLAGS: 00000297 CPU: 1
06:15:21: EIP is at div_u64_rem+0x1b/0x2a
06:15:21: EAX: 00000000 EBX: 000004c4 ECX: 00000000 EDX: 000004c4
06:15:21: ESI: 00000d57 EDI: f21a3d50 EBP: f21a3d30 ESP: f21a3d28
06:15:21:  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
06:15:21: Process firefox-bin (pid: 3145, ti=f21a2000 task=f613c6c0 task.ti=f21a2000)
06:15:21: Stack:
06:15:21:  000004c4 00000000 f21a3d60 c1110bcb f21a3d50 00000000 00000000 00000000
06:15:21:  0000007b ffff007b 000005f5 00000000 f21a3e24 00000001 f21a3dec c106ee41
06:15:21:  00000d57 00000000 00000000 c1492e00 0000c88d 00000020 00000021 c1493098
06:15:21: Call Trace:
06:15:21:  [<c1110bcb>] ? div64_u64+0x25/0xef
06:15:21:  [<c106ee41>] ? shrink_zone+0x264/0x4c3
06:15:21:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
06:15:21:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
06:15:21:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
06:15:21:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
06:15:21:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:15:21:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
06:15:21:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
06:15:21:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
06:15:21:  [<c1047272>] ? tick_program_event+0x19/0x1c
06:15:21:  [<c102e915>] ? irq_exit+0x41/0x64
06:15:21:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:15:21:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:15:21:  [<c1305022>] ? error_code+0x5a/0x60
06:15:21:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
06:15:21:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:15:21: Code: 00 00 00 31 d2 f7 f1 c1 e0 04 01 d0 c3 90 90 90 55 89 e5 56 89 ce 53 31 c9 89 c3 39 f2 72 08 89 d0 31 d2 f7 f6 89 c1 89 d8 f7 f6 <89> c3 8b 45 08 89 10 89 d8 89 ca 5b 5e c9 c3 55 89 c5 57 56 89 
06:15:21: Call Trace:
06:15:21:  [<c1110bcb>] ? div64_u64+0x25/0xef
06:15:21:  [<c106ee41>] ? shrink_zone+0x264/0x4c3
06:15:21:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
06:15:21:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
06:15:21:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
06:15:21:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
06:15:21:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:15:21:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
06:15:21:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
06:15:21:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
06:15:21:  [<c1047272>] ? tick_program_event+0x19/0x1c
06:15:21:  [<c102e915>] ? irq_exit+0x41/0x64
06:15:21:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:15:21:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:15:21:  [<c1305022>] ? error_code+0x5a/0x60
06:15:21:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
06:15:21:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:16:29: BUG: soft lockup - CPU#1 stuck for 61s! [firefox-bin:3145]
06:16:29: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
06:16:29: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
06:16:29: 
06:16:29: Pid: 3145, comm: firefox-bin Not tainted 2.6.38-rc4 #226 0MG532/MXC061                          
06:16:29: EIP: 0060:[<c106eda8>] EFLAGS: 00000212 CPU: 1
06:16:29: EIP is at shrink_zone+0x1cb/0x4c3
06:16:29: EAX: 00000d20 EBX: c1492e00 ECX: 0000003d EDX: 00000015
06:16:29: ESI: f21a3e24 EDI: c1493040 EBP: f21a3dec ESP: f21a3d68
06:16:29:  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
06:16:29: Process firefox-bin (pid: 3145, ti=f21a2000 task=f613c6c0 task.ti=f21a2000)
06:16:29: Stack:
06:16:29:  00000d5e 00000000 00000000 c1492e00 0000c88d 00000020 00000021 c1493098
06:16:29:  00000004 c14930a8 c1493040 c14930a4 c14930a0 c149309c 0000000b 0000a189
06:16:29:  00001e23 00000000 0000003c 00000000 00000000 00000000 00000000 00000040
06:16:29: Call Trace:
06:16:29:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
06:16:29:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
06:16:29:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
06:16:29:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
06:16:29:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:16:29:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
06:16:29:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
06:16:29:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
06:16:29:  [<c1047272>] ? tick_program_event+0x19/0x1c
06:16:29:  [<c102e915>] ? irq_exit+0x41/0x64
06:16:29:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:16:29:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:16:29:  [<c1305022>] ? error_code+0x5a/0x60
06:16:29:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
06:16:29:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:16:29: Code: 8b 93 78 02 00 00 8b bb 70 02 00 00 42 47 89 c1 b8 c9 00 00 00 2b 44 24 48 0f af c2 31 d2 f7 f7 8b 7c 24 28 fe 07 fb 89 44 24 68 <89> 4c 24 60 8d 44 01 01 c7 44 24 64 00 00 00 00 c7 44 24 6c 00 
06:16:29: Call Trace:
06:16:29:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
06:16:29:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
06:16:29:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
06:16:29:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
06:16:29:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:16:29:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
06:16:29:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
06:16:29:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
06:16:29:  [<c1047272>] ? tick_program_event+0x19/0x1c
06:16:29:  [<c102e915>] ? irq_exit+0x41/0x64
06:16:29:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:16:29:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:16:29:  [<c1305022>] ? error_code+0x5a/0x60
06:16:29:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
06:16:29:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:18:00: INFO: rcu_sched_state detected stall on CPU 1 (t=18000 jiffies)
06:18:00: sending NMI to all CPUs:
06:18:00: NMI backtrace for cpu 1
06:18:00: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
06:18:00: 
06:18:00: Pid: 3145, comm: firefox-bin Not tainted 2.6.38-rc4 #226 0MG532/MXC061                          
06:18:00: EIP: 0060:[<c110f7eb>] EFLAGS: 00000082 CPU: 1
06:18:00: EIP is at delay_tsc+0x18/0x55
06:18:00: EAX: 7983fad8 EBX: 00000001 ECX: 00000001 EDX: 000019d0
06:18:00: ESI: c1436640 EDI: 00000001 EBP: 001e7a67 ESP: f21a3c20
06:18:00:  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
06:18:00: Process firefox-bin (pid: 3145, ti=f21a2000 task=f613c6c0 task.ti=f21a2000)
06:18:00: Stack:
06:18:00:  00000000 c1436640 00000001 c1436640 00000001 c1436640 c110f7bf c1015f6d
06:18:00:  c13a101a f6602e14 c105c85b c13a901b c13a9102 00000001 00004650 00000000
06:18:00:  00000000 00000001 00000000 00000001 f21a3d2c c105caf0 f613c6c0 c1032df0
06:18:00: Call Trace:
06:18:00:  [<c110f7bf>] ? __const_udelay+0x18/0x19
06:18:00:  [<c1015f6d>] ? arch_trigger_all_cpu_backtrace+0x52/0x65
06:18:00:  [<c105c85b>] ? __rcu_pending+0x6c/0x277
06:18:00:  [<c105caf0>] ? rcu_check_callbacks+0x8a/0xb6
06:18:00:  [<c1032df0>] ? update_process_times+0x2a/0x53
06:18:00:  [<c1047627>] ? tick_sched_timer+0x64/0x8d
06:18:00:  [<c103f332>] ? __run_hrtimer+0x6d/0xc3
06:18:00:  [<c103f595>] ? hrtimer_interrupt+0x10c/0x213
06:18:00:  [<c10157cc>] ? smp_apic_timer_interrupt+0x6c/0x7d
06:18:00:  [<c1304e02>] ? apic_timer_interrupt+0x2a/0x30
06:18:00:  [<c106f017>] ? shrink_zone+0x43a/0x4c3
06:18:00:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
06:18:00:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
06:18:00:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
06:18:00:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
06:18:00:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:18:00:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
06:18:00:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
06:18:00:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
06:18:00:  [<c1047272>] ? tick_program_event+0x19/0x1c
06:18:00:  [<c102e915>] ? irq_exit+0x41/0x64
06:18:00:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:18:00:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:18:00:  [<c1305022>] ? error_code+0x5a/0x60
06:18:00:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
06:18:00:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:18:00: Code: 69 c0 c7 10 00 00 e9 dc ff ff ff 8d 04 80 e9 d4 ff ff ff 55 89 c5 57 56 53 83 ec 08 64 8b 0d b8 7f 4e c1 8d 76 00 0f ae e8 0f 31 <89> c7 8d 76 00 0f ae e8 0f 31 89 c3 89 c6 29 fb 39 eb 73 21 f3 
06:18:00: Call Trace:
06:18:00:  [<c110f7bf>] ? __const_udelay+0x18/0x19
06:18:00:  [<c1015f6d>] ? arch_trigger_all_cpu_backtrace+0x52/0x65
06:18:00:  [<c105c85b>] ? __rcu_pending+0x6c/0x277
06:18:00:  [<c105caf0>] ? rcu_check_callbacks+0x8a/0xb6
06:18:00:  [<c1032df0>] ? update_process_times+0x2a/0x53
06:18:00:  [<c1047627>] ? tick_sched_timer+0x64/0x8d
06:18:00:  [<c103f332>] ? __run_hrtimer+0x6d/0xc3
06:18:00:  [<c103f595>] ? hrtimer_interrupt+0x10c/0x213
06:18:00:  [<c10157cc>] ? smp_apic_timer_interrupt+0x6c/0x7d
06:18:00:  [<c1304e02>] ? apic_timer_interrupt+0x2a/0x30
06:18:00:  [<c106f017>] ? shrink_zone+0x43a/0x4c3
06:18:00:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
06:18:00:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
06:18:00:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
06:18:00:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
06:18:00:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:18:00:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
06:18:00:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
06:18:00:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
06:18:00:  [<c1047272>] ? tick_program_event+0x19/0x1c
06:18:00:  [<c102e915>] ? irq_exit+0x41/0x64
06:18:00:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:18:00:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:18:00:  [<c1305022>] ? error_code+0x5a/0x60
06:18:00:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
06:18:00:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:18:00: Pid: 3145, comm: firefox-bin Not tainted 2.6.38-rc4 #226
06:18:00: Call Trace:
06:18:00:  [<c10054b6>] ? show_trace+0xf/0x11
06:18:00:  [<c1015eff>] ? arch_trigger_all_cpu_backtrace_handler+0x57/0x73
06:18:00:  [<c104039f>] ? notifier_call_chain+0x23/0x46
06:18:00:  [<c10403e3>] ? atomic_notifier_call_chain+0x1a/0x1d
06:18:00:  [<c1040477>] ? notify_die+0x30/0x34
06:18:00:  [<c1003657>] ? do_nmi+0x68/0x267
06:18:00:  [<c13050d1>] ? nmi_stack_correct+0x28/0x2d
06:18:00:  [<c10100d8>] ? do_machine_check+0x2c0/0x6d2
06:18:00:  [<c110f7eb>] ? delay_tsc+0x18/0x55
06:18:00:  [<c110f7bf>] ? __const_udelay+0x18/0x19
06:18:00:  [<c1015f6d>] ? arch_trigger_all_cpu_backtrace+0x52/0x65
06:18:00:  [<c105c85b>] ? __rcu_pending+0x6c/0x277
06:18:00:  [<c105caf0>] ? rcu_check_callbacks+0x8a/0xb6
06:18:00:  [<c1032df0>] ? update_process_times+0x2a/0x53
06:18:00:  [<c1047627>] ? tick_sched_timer+0x64/0x8d
06:18:00:  [<c103f332>] ? __run_hrtimer+0x6d/0xc3
06:18:00:  [<c103f595>] ? hrtimer_interrupt+0x10c/0x213
06:18:00:  [<c10157cc>] ? smp_apic_timer_interrupt+0x6c/0x7d
06:18:00:  [<c1304e02>] ? apic_timer_interrupt+0x2a/0x30
06:18:00:  [<c106f017>] ? shrink_zone+0x43a/0x4c3
06:18:00:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
06:18:00:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
06:18:00:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
06:18:00:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
06:18:00:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:18:00:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
06:18:00:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
06:18:00:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
06:18:00:  [<c1047272>] ? tick_program_event+0x19/0x1c
06:18:00:  [<c102e915>] ? irq_exit+0x41/0x64
06:18:00:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:18:00:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:18:00:  [<c1305022>] ? error_code+0x5a/0x60
06:18:00:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
06:18:00:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:18:00: NMI backtrace for cpu 0
06:18:00: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
06:18:00: 
06:18:00: Pid: 0, comm: swapper Not tainted 2.6.38-rc4 #226 0MG532/MXC061                          
06:18:00: EIP: 0060:[<c1019322>] EFLAGS: 00000046 CPU: 0
06:18:00: EIP is at read_hpet+0xe/0x12
06:18:00: EAX: d84d8b64 EBX: 01055dd8 ECX: 00000000 EDX: 00000000
06:18:00: ESI: c1433a80 EDI: 3b854ba7 EBP: c1421ee8 ESP: c1421ee8
06:18:00:  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
06:18:00: Process swapper (pid: 0, ti=c1420000 task=c142fe20 task.ti=c1420000)
06:18:00: Stack:
06:18:00:  00000000 c1042852 0000605e c1433a00 0000bfef 00000000 f6405f80 00002cb0
06:18:00:  f6402cc8 00000000 c1040fb3 5dee549d 00002cb0 f6402cc8 c1040fe3 c10477b9
06:18:00:  00000000 000003e8 00000000 c1421f6c c102eb08 ffffffcf c1003d1a f60d9440
06:18:00: Call Trace:
06:18:00:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:18:00:  [<c1040fb3>] ? sched_clock_tick+0x4c/0x6e
06:18:00:  [<c1040fe3>] ? sched_clock_idle_wakeup_event+0xe/0x14
06:18:00:  [<c10477b9>] ? tick_check_idle+0x3d/0x82
06:18:00:  [<c102eb08>] ? irq_enter+0x34/0x54
06:18:00:  [<c1003d1a>] ? do_IRQ+0x1e/0x95
06:18:00:  [<c1040c67>] ? sched_clock_local+0x19/0x17c
06:18:00:  [<c1002c69>] ? common_interrupt+0x29/0x30
06:18:00:  [<c115b48b>] ? acpi_idle_enter_bm+0x22c/0x261
06:18:00:  [<c123289f>] ? cpuidle_idle_call+0x67/0x98
06:18:00:  [<c1001ae9>] ? cpu_idle+0x41/0x5c
06:18:00:  [<c14987ce>] ? start_kernel+0x276/0x27b
06:18:00:  [<c149839a>] ? unknown_bootoption+0x0/0x18c
06:18:00: Code: 4f c1 8b 92 f0 00 00 00 29 d0 89 c2 31 c0 81 fa 80 00 00 00 ba c2 ff ff ff 0f 4c c2 c3 55 a1 34 e7 4f c1 89 e5 8b 80 f0 00 00 00 <31> d2 c9 c3 83 3d 38 e7 4f c1 00 75 37 83 3d 20 e7 4f c1 00 74 
06:18:00: Call Trace:
06:18:00:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:18:00:  [<c1040fb3>] ? sched_clock_tick+0x4c/0x6e
06:18:00:  [<c1040fe3>] ? sched_clock_idle_wakeup_event+0xe/0x14
06:18:00:  [<c10477b9>] ? tick_check_idle+0x3d/0x82
06:18:00:  [<c102eb08>] ? irq_enter+0x34/0x54
06:18:00:  [<c1003d1a>] ? do_IRQ+0x1e/0x95
06:18:00:  [<c1040c67>] ? sched_clock_local+0x19/0x17c
06:18:00:  [<c1002c69>] ? common_interrupt+0x29/0x30
06:18:00:  [<c115b48b>] ? acpi_idle_enter_bm+0x22c/0x261
06:18:00:  [<c123289f>] ? cpuidle_idle_call+0x67/0x98
06:18:00:  [<c1001ae9>] ? cpu_idle+0x41/0x5c
06:18:00:  [<c14987ce>] ? start_kernel+0x276/0x27b
06:18:00:  [<c149839a>] ? unknown_bootoption+0x0/0x18c
06:18:00: Pid: 0, comm: swapper Not tainted 2.6.38-rc4 #226
06:18:00: Call Trace:
06:18:00:  [<c10054b6>] ? show_trace+0xf/0x11
06:18:00:  [<c1015eff>] ? arch_trigger_all_cpu_backtrace_handler+0x57/0x73
06:18:00:  [<c104039f>] ? notifier_call_chain+0x23/0x46
06:18:00:  [<c10403e3>] ? atomic_notifier_call_chain+0x1a/0x1d
06:18:00:  [<c1040477>] ? notify_die+0x30/0x34
06:18:00:  [<c1003657>] ? do_nmi+0x68/0x267
06:18:00:  [<c13050d1>] ? nmi_stack_correct+0x28/0x2d
06:18:00:  [<c1019322>] ? read_hpet+0xe/0x12
06:18:00:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:18:00:  [<c1040fb3>] ? sched_clock_tick+0x4c/0x6e
06:18:00:  [<c1040fe3>] ? sched_clock_idle_wakeup_event+0xe/0x14
06:18:00:  [<c10477b9>] ? tick_check_idle+0x3d/0x82
06:18:00:  [<c102eb08>] ? irq_enter+0x34/0x54
06:18:00:  [<c1003d1a>] ? do_IRQ+0x1e/0x95
06:18:00:  [<c1040c67>] ? sched_clock_local+0x19/0x17c
06:18:00:  [<c1002c69>] ? common_interrupt+0x29/0x30
06:18:00:  [<c115b48b>] ? acpi_idle_enter_bm+0x22c/0x261
06:18:00:  [<c123289f>] ? cpuidle_idle_call+0x67/0x98
06:18:00:  [<c1001ae9>] ? cpu_idle+0x41/0x5c
06:18:00:  [<c14987ce>] ? start_kernel+0x276/0x27b
06:18:00:  [<c149839a>] ? unknown_bootoption+0x0/0x18c
06:19:06: BUG: soft lockup - CPU#1 stuck for 61s! [firefox-bin:3145]
06:19:06: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
06:19:06: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
06:19:06: 
06:19:06: Pid: 3145, comm: firefox-bin Not tainted 2.6.38-rc4 #226 0MG532/MXC061                          
06:19:06: EIP: 0060:[<c106ee2a>] EFLAGS: 00000246 CPU: 1
06:19:06: EIP is at shrink_zone+0x24d/0x4c3
06:19:06: EAX: 00000014 EBX: 00000000 ECX: 00000000 EDX: 00000000
06:19:06: ESI: f21a3e24 EDI: 00000001 EBP: f21a3dec ESP: f21a3d68
06:19:06:  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
06:19:06: Process firefox-bin (pid: 3145, ti=f21a2000 task=f613c6c0 task.ti=f21a2000)
06:19:06: Stack:
06:19:06:  00000da3 00000000 00000000 c1492e00 0000c88d 00000020 00000021 c1493098
06:19:06:  00000002 c14930a8 c1493040 c14930a4 c14930a0 c149309c 0000000b 00000000
06:19:06:  00000da3 00000000 ffffffff 00000000 00000000 00000000 00000000 00000040
06:19:06: Call Trace:
06:19:06:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
06:19:06:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
06:19:06:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
06:19:06:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
06:19:06:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:19:06:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
06:19:06:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
06:19:06:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
06:19:06:  [<c1047272>] ? tick_program_event+0x19/0x1c
06:19:06:  [<c102e915>] ? irq_exit+0x41/0x64
06:19:06:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:19:06:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:19:06:  [<c1305022>] ? error_code+0x5a/0x60
06:19:06:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
06:19:06:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:19:06: Code: 48 c1 83 7c 24 3c 00 75 07 83 7c 24 38 00 74 32 83 7c 24 48 02 8a 4c 24 38 19 d2 8b 5c 24 44 d3 e8 83 e2 08 8b 4c 14 64 0f af c8 <f7> 64 14 60 89 5c 24 04 8d 14 11 8b 4c 24 40 89 0c 24 e8 65 1d 
06:19:06: Call Trace:
06:19:06:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
06:19:06:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
06:19:06:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
06:19:06:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
06:19:06:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:19:06:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
06:19:06:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
06:19:06:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
06:19:06:  [<c1047272>] ? tick_program_event+0x19/0x1c
06:19:06:  [<c102e915>] ? irq_exit+0x41/0x64
06:19:06:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:19:06:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:19:06:  [<c1305022>] ? error_code+0x5a/0x60
06:19:06:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
06:19:06:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:20:18: BUG: soft lockup - CPU#1 stuck for 64s! [firefox-bin:3145]
06:20:18: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
06:20:18: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
06:20:18: 
06:20:18: Pid: 3145, comm: firefox-bin Not tainted 2.6.38-rc4 #226 0MG532/MXC061                          
06:20:18: EIP: 0060:[<c106eda8>] EFLAGS: 00000206 CPU: 1
06:20:18: EIP is at shrink_zone+0x1cb/0x4c3
06:20:18: EAX: 00000d6c EBX: c1492e00 ECX: 0000003d EDX: 00000014
06:20:18: ESI: f21a3e24 EDI: c1493040 EBP: f21a3dec ESP: f21a3d68
06:20:18:  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
06:20:18: Process firefox-bin (pid: 3145, ti=f21a2000 task=f613c6c0 task.ti=f21a2000)
06:20:18: Stack:
06:20:18:  00000daa 00000000 00000000 c1492e00 0000c88d 00000020 00000021 c1493098
06:20:18:  00000004 c14930a8 c1493040 c14930a4 c14930a0 c149309c 0000000b 0000a189
06:20:18:  00001e11 00000000 0000003c 00000000 00000000 00000000 00000000 00000040
06:20:18: Call Trace:
06:20:18:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
06:20:18:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
06:20:18:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
06:20:18:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
06:20:18:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:20:18:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
06:20:18:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
06:20:18:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
06:20:18:  [<c1047272>] ? tick_program_event+0x19/0x1c
06:20:18:  [<c102e915>] ? irq_exit+0x41/0x64
06:20:18:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:20:18:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:20:18:  [<c1305022>] ? error_code+0x5a/0x60
06:20:18:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
06:20:18:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:20:18: Code: 8b 93 78 02 00 00 8b bb 70 02 00 00 42 47 89 c1 b8 c9 00 00 00 2b 44 24 48 0f af c2 31 d2 f7 f7 8b 7c 24 28 fe 07 fb 89 44 24 68 <89> 4c 24 60 8d 44 01 01 c7 44 24 64 00 00 00 00 c7 44 24 6c 00 
06:20:18: Call Trace:
06:20:18:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
06:20:18:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
06:20:18:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
06:20:18:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
06:20:18:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:20:18:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
06:20:18:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
06:20:18:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
06:20:18:  [<c1047272>] ? tick_program_event+0x19/0x1c
06:20:18:  [<c102e915>] ? irq_exit+0x41/0x64
06:20:18:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:20:18:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:20:18:  [<c1305022>] ? error_code+0x5a/0x60
06:20:18:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
06:20:18:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:21:00: INFO: rcu_sched_state detected stall on CPU 1 (t=72030 jiffies)
06:21:00: sending NMI to all CPUs:
06:21:00: NMI backtrace for cpu 1
06:21:00: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
06:21:00: 
06:21:00: Pid: 3145, comm: firefox-bin Not tainted 2.6.38-rc4 #226 0MG532/MXC061                          
06:21:00: EIP: 0060:[<c110f7eb>] EFLAGS: 00000082 CPU: 1
06:21:00: EIP is at delay_tsc+0x18/0x55
06:21:00: EAX: 3a9e25cc EBX: 00000001 ECX: 00000001 EDX: 00001a24
06:21:00: ESI: c1436640 EDI: 00000001 EBP: 001e7a67 ESP: f21a3c20
06:21:00:  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
06:21:00: Process firefox-bin (pid: 3145, ti=f21a2000 task=f613c6c0 task.ti=f21a2000)
06:21:00: Stack:
06:21:00:  00000000 c1436640 00000001 c1436640 00000001 c1436640 c110f7bf c1015f6d
06:21:00:  c13a101a f6602e14 c105c85b c13a901b c13a9102 00000001 0001195e 00000000
06:21:00:  00000000 00000001 00000000 00000001 f21a3d2c c105caf0 f613c6c0 c1032df0
06:21:00: Call Trace:
06:21:00:  [<c110f7bf>] ? __const_udelay+0x18/0x19
06:21:00:  [<c1015f6d>] ? arch_trigger_all_cpu_backtrace+0x52/0x65
06:21:00:  [<c105c85b>] ? __rcu_pending+0x6c/0x277
06:21:00:  [<c105caf0>] ? rcu_check_callbacks+0x8a/0xb6
06:21:00:  [<c1032df0>] ? update_process_times+0x2a/0x53
06:21:00:  [<c1047627>] ? tick_sched_timer+0x64/0x8d
06:21:00:  [<c103f332>] ? __run_hrtimer+0x6d/0xc3
06:21:00:  [<c103f595>] ? hrtimer_interrupt+0x10c/0x213
06:21:00:  [<c10157cc>] ? smp_apic_timer_interrupt+0x6c/0x7d
06:21:00:  [<c11100d8>] ? strncat+0x2/0x29
06:21:00:  [<c1304e02>] ? apic_timer_interrupt+0x2a/0x30
06:21:00:  [<c111007b>] ? __put_user_8+0xf/0x19
06:21:00:  [<c106ee01>] ? shrink_zone+0x224/0x4c3
06:21:00:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
06:21:00:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
06:21:00:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
06:21:00:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
06:21:00:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:21:00:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
06:21:00:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
06:21:00:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
06:21:00:  [<c1047272>] ? tick_program_event+0x19/0x1c
06:21:00:  [<c102e915>] ? irq_exit+0x41/0x64
06:21:00:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:21:00:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:21:00:  [<c1305022>] ? error_code+0x5a/0x60
06:21:00:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
06:21:00:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:21:00: Code: 69 c0 c7 10 00 00 e9 dc ff ff ff 8d 04 80 e9 d4 ff ff ff 55 89 c5 57 56 53 83 ec 08 64 8b 0d b8 7f 4e c1 8d 76 00 0f ae e8 0f 31 <89> c7 8d 76 00 0f ae e8 0f 31 89 c3 89 c6 29 fb 39 eb 73 21 f3 
06:21:00: Call Trace:
06:21:00:  [<c110f7bf>] ? __const_udelay+0x18/0x19
06:21:00:  [<c1015f6d>] ? arch_trigger_all_cpu_backtrace+0x52/0x65
06:21:00:  [<c105c85b>] ? __rcu_pending+0x6c/0x277
06:21:00:  [<c105caf0>] ? rcu_check_callbacks+0x8a/0xb6
06:21:00:  [<c1032df0>] ? update_process_times+0x2a/0x53
06:21:00:  [<c1047627>] ? tick_sched_timer+0x64/0x8d
06:21:00:  [<c103f332>] ? __run_hrtimer+0x6d/0xc3
06:21:00:  [<c103f595>] ? hrtimer_interrupt+0x10c/0x213
06:21:00:  [<c10157cc>] ? smp_apic_timer_interrupt+0x6c/0x7d
06:21:00:  [<c11100d8>] ? strncat+0x2/0x29
06:21:00:  [<c1304e02>] ? apic_timer_interrupt+0x2a/0x30
06:21:00:  [<c111007b>] ? __put_user_8+0xf/0x19
06:21:00:  [<c106ee01>] ? shrink_zone+0x224/0x4c3
06:21:00:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
06:21:00:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
06:21:00:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
06:21:00:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
06:21:00:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:21:00:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
06:21:00:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
06:21:00:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
06:21:00:  [<c1047272>] ? tick_program_event+0x19/0x1c
06:21:00:  [<c102e915>] ? irq_exit+0x41/0x64
06:21:00:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:21:00:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:21:00:  [<c1305022>] ? error_code+0x5a/0x60
06:21:00:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
06:21:00:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:21:00: Pid: 3145, comm: firefox-bin Not tainted 2.6.38-rc4 #226
06:21:00: Call Trace:
06:21:00:  [<c10054b6>] ? show_trace+0xf/0x11
06:21:00:  [<c1015eff>] ? arch_trigger_all_cpu_backtrace_handler+0x57/0x73
06:21:00:  [<c104039f>] ? notifier_call_chain+0x23/0x46
06:21:00:  [<c10403e3>] ? atomic_notifier_call_chain+0x1a/0x1d
06:21:00:  [<c1040477>] ? notify_die+0x30/0x34
06:21:00:  [<c1003657>] ? do_nmi+0x68/0x267
06:21:00:  [<c13050d1>] ? nmi_stack_correct+0x28/0x2d
06:21:00:  [<c10100d8>] ? do_machine_check+0x2c0/0x6d2
06:21:00:  [<c110f7eb>] ? delay_tsc+0x18/0x55
06:21:00:  [<c110f7bf>] ? __const_udelay+0x18/0x19
06:21:00:  [<c1015f6d>] ? arch_trigger_all_cpu_backtrace+0x52/0x65
06:21:00:  [<c105c85b>] ? __rcu_pending+0x6c/0x277
06:21:00:  [<c105caf0>] ? rcu_check_callbacks+0x8a/0xb6
06:21:00:  [<c1032df0>] ? update_process_times+0x2a/0x53
06:21:00:  [<c1047627>] ? tick_sched_timer+0x64/0x8d
06:21:00:  [<c103f332>] ? __run_hrtimer+0x6d/0xc3
06:21:00:  [<c103f595>] ? hrtimer_interrupt+0x10c/0x213
06:21:00:  [<c10157cc>] ? smp_apic_timer_interrupt+0x6c/0x7d
06:21:00:  [<c11100d8>] ? strncat+0x2/0x29
06:21:00:  [<c1304e02>] ? apic_timer_interrupt+0x2a/0x30
06:21:00:  [<c111007b>] ? __put_user_8+0xf/0x19
06:21:00:  [<c106ee01>] ? shrink_zone+0x224/0x4c3
06:21:00:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
06:21:00:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
06:21:00:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
06:21:00:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
06:21:00:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:21:00:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
06:21:00:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
06:21:00:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
06:21:00:  [<c1047272>] ? tick_program_event+0x19/0x1c
06:21:00:  [<c102e915>] ? irq_exit+0x41/0x64
06:21:00:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:21:00:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:21:00:  [<c1305022>] ? error_code+0x5a/0x60
06:21:00:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
06:21:00:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:21:00: NMI backtrace for cpu 0
06:21:00: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
06:21:00: 
06:21:00: Pid: 0, comm: swapper Not tainted 2.6.38-rc4 #226 0MG532/MXC061                          
06:21:00: EIP: 0060:[<c1019322>] EFLAGS: 00000057 CPU: 0
06:21:00: EIP is at read_hpet+0xe/0x12
06:21:00: EAX: 7201e221 EBX: 010703f4 ECX: fffff000 EDX: 00000000
06:21:00: ESI: c1433a80 EDI: 418000b6 EBP: c1421efc ESP: c1421efc
06:21:00:  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
06:21:00: Process swapper (pid: 0, ti=c1420000 task=c142fe20 task.ti=c1420000)
06:21:00: Stack:
06:21:00:  00000000 c1042852 00000003 c14e8cc8 0000c0a3 00000000 00000000 000003e8
06:21:00:  f6402cc8 00000000 c10477a4 00000000 000003e8 00000000 c1421f6c c102eb08
06:21:00:  ffffffcf c1003d1a f60d9440 c1421f9c c1040c67 4cb9eda9 00002cda 00000000
06:21:00: Call Trace:
06:21:00:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:21:00:  [<c10477a4>] ? tick_check_idle+0x28/0x82
06:21:00:  [<c102eb08>] ? irq_enter+0x34/0x54
06:21:00:  [<c1003d1a>] ? do_IRQ+0x1e/0x95
06:21:00:  [<c1040c67>] ? sched_clock_local+0x19/0x17c
06:21:00:  [<c1002c69>] ? common_interrupt+0x29/0x30
06:21:00:  [<c115b48b>] ? acpi_idle_enter_bm+0x22c/0x261
06:21:00:  [<c123289f>] ? cpuidle_idle_call+0x67/0x98
06:21:00:  [<c1001ae9>] ? cpu_idle+0x41/0x5c
06:21:00:  [<c14987ce>] ? start_kernel+0x276/0x27b
06:21:00:  [<c149839a>] ? unknown_bootoption+0x0/0x18c
06:21:00: Code: 4f c1 8b 92 f0 00 00 00 29 d0 89 c2 31 c0 81 fa 80 00 00 00 ba c2 ff ff ff 0f 4c c2 c3 55 a1 34 e7 4f c1 89 e5 8b 80 f0 00 00 00 <31> d2 c9 c3 83 3d 38 e7 4f c1 00 75 37 83 3d 20 e7 4f c1 00 74 
06:21:00: Call Trace:
06:21:00:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:21:00:  [<c10477a4>] ? tick_check_idle+0x28/0x82
06:21:00:  [<c102eb08>] ? irq_enter+0x34/0x54
06:21:00:  [<c1003d1a>] ? do_IRQ+0x1e/0x95
06:21:00:  [<c1040c67>] ? sched_clock_local+0x19/0x17c
06:21:00:  [<c1002c69>] ? common_interrupt+0x29/0x30
06:21:00:  [<c115b48b>] ? acpi_idle_enter_bm+0x22c/0x261
06:21:00:  [<c123289f>] ? cpuidle_idle_call+0x67/0x98
06:21:00:  [<c1001ae9>] ? cpu_idle+0x41/0x5c
06:21:00:  [<c14987ce>] ? start_kernel+0x276/0x27b
06:21:00:  [<c149839a>] ? unknown_bootoption+0x0/0x18c
06:21:00: Pid: 0, comm: swapper Not tainted 2.6.38-rc4 #226
06:21:00: Call Trace:
06:21:00:  [<c10054b6>] ? show_trace+0xf/0x11
06:21:00:  [<c1015eff>] ? arch_trigger_all_cpu_backtrace_handler+0x57/0x73
06:21:00:  [<c104039f>] ? notifier_call_chain+0x23/0x46
06:21:00:  [<c10403e3>] ? atomic_notifier_call_chain+0x1a/0x1d
06:21:00:  [<c1040477>] ? notify_die+0x30/0x34
06:21:00:  [<c1003657>] ? do_nmi+0x68/0x267
06:21:00:  [<c13050d1>] ? nmi_stack_correct+0x28/0x2d
06:21:00:  [<c104007b>] ? copy_namespaces+0x1/0x7e
06:21:00:  [<c1019322>] ? read_hpet+0xe/0x12
06:21:00:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:21:00:  [<c10477a4>] ? tick_check_idle+0x28/0x82
06:21:00:  [<c102eb08>] ? irq_enter+0x34/0x54
06:21:00:  [<c1003d1a>] ? do_IRQ+0x1e/0x95
06:21:00:  [<c1040c67>] ? sched_clock_local+0x19/0x17c
06:21:00:  [<c1002c69>] ? common_interrupt+0x29/0x30
06:21:00:  [<c115b48b>] ? acpi_idle_enter_bm+0x22c/0x261
06:21:00:  [<c123289f>] ? cpuidle_idle_call+0x67/0x98
06:21:00:  [<c1001ae9>] ? cpu_idle+0x41/0x5c
06:21:00:  [<c14987ce>] ? start_kernel+0x276/0x27b
06:21:00:  [<c149839a>] ? unknown_bootoption+0x0/0x18c
06:22:10: BUG: soft lockup - CPU#1 stuck for 63s! [firefox-bin:3145]
06:22:10: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
06:22:10: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
06:22:10: 
06:22:10: Pid: 3145, comm: firefox-bin Not tainted 2.6.38-rc4 #226 0MG532/MXC061                          
06:22:10: EIP: 0060:[<c106ee2e>] EFLAGS: 00000246 CPU: 1
06:22:10: EIP is at shrink_zone+0x251/0x4c3
06:22:10: EAX: 000005f5 EBX: 00000000 ECX: 00000000 EDX: 00000000
06:22:10: ESI: f21a3e24 EDI: 00000000 EBP: f21a3dec ESP: f21a3d68
06:22:10:  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
06:22:10: Process firefox-bin (pid: 3145, ti=f21a2000 task=f613c6c0 task.ti=f21a2000)
06:22:10: Stack:
06:22:10:  00000db7 00000000 00000000 c1492e00 0000c88d 00000020 00000021 c1493098
06:22:10:  00000001 c14930a8 c1493040 c14930a4 c14930a0 c149309c 0000000b 00000000
06:22:10:  00000db7 00000000 fffffffe 00000000 00000000 00000000 00000000 00000040
06:22:10: Call Trace:
06:22:10:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
06:22:10:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
06:22:10:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
06:22:10:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
06:22:10:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:22:10:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
06:22:10:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
06:22:10:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
06:22:10:  [<c1047272>] ? tick_program_event+0x19/0x1c
06:22:10:  [<c102e915>] ? irq_exit+0x41/0x64
06:22:10:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:22:10:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:22:10:  [<c1305022>] ? error_code+0x5a/0x60
06:22:10:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
06:22:10:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:22:10: Code: 24 3c 00 75 07 83 7c 24 38 00 74 32 83 7c 24 48 02 8a 4c 24 38 19 d2 8b 5c 24 44 d3 e8 83 e2 08 8b 4c 14 64 0f af c8 f7 64 14 60 <89> 5c 24 04 8d 14 11 8b 4c 24 40 89 0c 24 e8 65 1d 0a 00 81 c7 
06:22:10: Call Trace:
06:22:10:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
06:22:10:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
06:22:10:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
06:22:10:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
06:22:10:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:22:10:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
06:22:10:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
06:22:10:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
06:22:10:  [<c1047272>] ? tick_program_event+0x19/0x1c
06:22:10:  [<c102e915>] ? irq_exit+0x41/0x64
06:22:10:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:22:10:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:22:10:  [<c1305022>] ? error_code+0x5a/0x60
06:22:10:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
06:22:10:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:23:18: BUG: soft lockup - CPU#1 stuck for 61s! [firefox-bin:3145]
06:23:18: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
06:23:18: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
06:23:18: 
06:23:18: Pid: 3145, comm: firefox-bin Not tainted 2.6.38-rc4 #226 0MG532/MXC061                          
06:23:18: EIP: 0060:[<c106eda8>] EFLAGS: 00000206 CPU: 1
06:23:18: EIP is at shrink_zone+0x1cb/0x4c3
06:23:18: EAX: 00000d80 EBX: c1492e00 ECX: 0000003d EDX: 00000006
06:23:18: ESI: f21a3e24 EDI: c1493040 EBP: f21a3dec ESP: f21a3d68
06:23:18:  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
06:23:18: Process firefox-bin (pid: 3145, ti=f21a2000 task=f613c6c0 task.ti=f21a2000)
06:23:18: Stack:
06:23:18:  00000dbe 00000000 00000000 c1492e00 0000c88d 00000020 00000021 c1493098
06:23:18:  00000004 c14930a8 c1493040 c14930a4 c14930a0 c149309c 0000000b 0000a189
06:23:18:  00001e17 00000000 0000003c 00000000 00000000 00000000 00000000 00000040
06:23:18: Call Trace:
06:23:18:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
06:23:18:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
06:23:18:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
06:23:18:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
06:23:18:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:23:18:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
06:23:18:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
06:23:18:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
06:23:18:  [<c1047272>] ? tick_program_event+0x19/0x1c
06:23:18:  [<c102e915>] ? irq_exit+0x41/0x64
06:23:18:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:23:18:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:23:18:  [<c1305022>] ? error_code+0x5a/0x60
06:23:18:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
06:23:18:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:23:18: Code: 8b 93 78 02 00 00 8b bb 70 02 00 00 42 47 89 c1 b8 c9 00 00 00 2b 44 24 48 0f af c2 31 d2 f7 f7 8b 7c 24 28 fe 07 fb 89 44 24 68 <89> 4c 24 60 8d 44 01 01 c7 44 24 64 00 00 00 00 c7 44 24 6c 00 
06:23:18: Call Trace:
06:23:18:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
06:23:18:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
06:23:18:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
06:23:18:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
06:23:18:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:23:18:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
06:23:18:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
06:23:18:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
06:23:18:  [<c1047272>] ? tick_program_event+0x19/0x1c
06:23:18:  [<c102e915>] ? irq_exit+0x41/0x64
06:23:18:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:23:18:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:23:18:  [<c1305022>] ? error_code+0x5a/0x60
06:23:18:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
06:23:18:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:24:00: INFO: rcu_sched_state detected stall on CPU 1 (t=126060 jiffies)
06:24:00: sending NMI to all CPUs:
06:24:00: NMI backtrace for cpu 1
06:24:00: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
06:24:00: 
06:24:00: Pid: 3145, comm: firefox-bin Not tainted 2.6.38-rc4 #226 0MG532/MXC061                          
06:24:00: EIP: 0060:[<c110f7eb>] EFLAGS: 00000082 CPU: 1
06:24:00: EIP is at delay_tsc+0x18/0x55
06:24:00: EAX: fbb8b324 EBX: 00000001 ECX: 00000001 EDX: 00001a77
06:24:00: ESI: c1436640 EDI: 00000001 EBP: 001e7a67 ESP: f21a3c20
06:24:00:  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
06:24:00: Process firefox-bin (pid: 3145, ti=f21a2000 task=f613c6c0 task.ti=f21a2000)
06:24:00: Stack:
06:24:00:  00000000 c1436640 00000001 c1436640 00000001 c1436640 c110f7bf c1015f6d
06:24:00:  c13a101a f6602e14 c105c85b c13a901b c13a9102 00000001 0001ec6c 00000000
06:24:00:  00000000 00000001 00000000 00000001 f21a3d2c c105caf0 f613c6c0 c1032df0
06:24:00: Call Trace:
06:24:00:  [<c110f7bf>] ? __const_udelay+0x18/0x19
06:24:00:  [<c1015f6d>] ? arch_trigger_all_cpu_backtrace+0x52/0x65
06:24:00:  [<c105c85b>] ? __rcu_pending+0x6c/0x277
06:24:00:  [<c105caf0>] ? rcu_check_callbacks+0x8a/0xb6
06:24:00:  [<c1032df0>] ? update_process_times+0x2a/0x53
06:24:00:  [<c1047627>] ? tick_sched_timer+0x64/0x8d
06:24:00:  [<c103f332>] ? __run_hrtimer+0x6d/0xc3
06:24:00:  [<c103f595>] ? hrtimer_interrupt+0x10c/0x213
06:24:00:  [<c102e915>] ? irq_exit+0x41/0x64
06:24:00:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:24:00:  [<c10157cc>] ? smp_apic_timer_interrupt+0x6c/0x7d
06:24:00:  [<c1110a8d>] ? div_u64_rem+0x1d/0x2a
06:24:00:  [<c1304e02>] ? apic_timer_interrupt+0x2a/0x30
06:24:00:  [<c106eda8>] ? shrink_zone+0x1cb/0x4c3
06:24:00:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
06:24:00:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
06:24:00:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
06:24:00:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
06:24:00:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:24:00:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
06:24:00:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
06:24:00:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
06:24:00:  [<c1047272>] ? tick_program_event+0x19/0x1c
06:24:00:  [<c102e915>] ? irq_exit+0x41/0x64
06:24:00:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:24:00:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:24:00:  [<c1305022>] ? error_code+0x5a/0x60
06:24:00:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
06:24:00:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:24:00: Code: 69 c0 c7 10 00 00 e9 dc ff ff ff 8d 04 80 e9 d4 ff ff ff 55 89 c5 57 56 53 83 ec 08 64 8b 0d b8 7f 4e c1 8d 76 00 0f ae e8 0f 31 <89> c7 8d 76 00 0f ae e8 0f 31 89 c3 89 c6 29 fb 39 eb 73 21 f3 
06:24:00: Call Trace:
06:24:00:  [<c110f7bf>] ? __const_udelay+0x18/0x19
06:24:00:  [<c1015f6d>] ? arch_trigger_all_cpu_backtrace+0x52/0x65
06:24:00:  [<c105c85b>] ? __rcu_pending+0x6c/0x277
06:24:00:  [<c105caf0>] ? rcu_check_callbacks+0x8a/0xb6
06:24:00:  [<c1032df0>] ? update_process_times+0x2a/0x53
06:24:00:  [<c1047627>] ? tick_sched_timer+0x64/0x8d
06:24:00:  [<c103f332>] ? __run_hrtimer+0x6d/0xc3
06:24:00:  [<c103f595>] ? hrtimer_interrupt+0x10c/0x213
06:24:00:  [<c102e915>] ? irq_exit+0x41/0x64
06:24:00:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:24:00:  [<c10157cc>] ? smp_apic_timer_interrupt+0x6c/0x7d
06:24:00:  [<c1110a8d>] ? div_u64_rem+0x1d/0x2a
06:24:00:  [<c1304e02>] ? apic_timer_interrupt+0x2a/0x30
06:24:00:  [<c106eda8>] ? shrink_zone+0x1cb/0x4c3
06:24:00:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
06:24:00:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
06:24:00:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
06:24:00:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
06:24:00:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:24:00:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
06:24:00:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
06:24:00:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
06:24:00:  [<c1047272>] ? tick_program_event+0x19/0x1c
06:24:00:  [<c102e915>] ? irq_exit+0x41/0x64
06:24:00:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:24:00:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:24:00:  [<c1305022>] ? error_code+0x5a/0x60
06:24:00:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
06:24:00:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:24:00: Pid: 3145, comm: firefox-bin Not tainted 2.6.38-rc4 #226
06:24:00: Call Trace:
06:24:00:  [<c10054b6>] ? show_trace+0xf/0x11
06:24:00:  [<c1015eff>] ? arch_trigger_all_cpu_backtrace_handler+0x57/0x73
06:24:00:  [<c104039f>] ? notifier_call_chain+0x23/0x46
06:24:00:  [<c10403e3>] ? atomic_notifier_call_chain+0x1a/0x1d
06:24:00:  [<c1040477>] ? notify_die+0x30/0x34
06:24:00:  [<c1003657>] ? do_nmi+0x68/0x267
06:24:00:  [<c13050d1>] ? nmi_stack_correct+0x28/0x2d
06:24:00:  [<c10100d8>] ? do_machine_check+0x2c0/0x6d2
06:24:00:  [<c110f7eb>] ? delay_tsc+0x18/0x55
06:24:00:  [<c110f7bf>] ? __const_udelay+0x18/0x19
06:24:00:  [<c1015f6d>] ? arch_trigger_all_cpu_backtrace+0x52/0x65
06:24:00:  [<c105c85b>] ? __rcu_pending+0x6c/0x277
06:24:00:  [<c105caf0>] ? rcu_check_callbacks+0x8a/0xb6
06:24:00:  [<c1032df0>] ? update_process_times+0x2a/0x53
06:24:00:  [<c1047627>] ? tick_sched_timer+0x64/0x8d
06:24:00:  [<c103f332>] ? __run_hrtimer+0x6d/0xc3
06:24:00:  [<c103f595>] ? hrtimer_interrupt+0x10c/0x213
06:24:00:  [<c102e915>] ? irq_exit+0x41/0x64
06:24:00:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:24:00:  [<c10157cc>] ? smp_apic_timer_interrupt+0x6c/0x7d
06:24:00:  [<c1110a8d>] ? div_u64_rem+0x1d/0x2a
06:24:00:  [<c1304e02>] ? apic_timer_interrupt+0x2a/0x30
06:24:00:  [<c106eda8>] ? shrink_zone+0x1cb/0x4c3
06:24:00:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
06:24:00:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
06:24:00:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
06:24:00:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
06:24:00:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:24:00:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
06:24:00:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
06:24:00:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
06:24:00:  [<c1047272>] ? tick_program_event+0x19/0x1c
06:24:00:  [<c102e915>] ? irq_exit+0x41/0x64
06:24:00:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:24:00:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:24:00:  [<c1305022>] ? error_code+0x5a/0x60
06:24:00:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
06:24:00:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:24:00: NMI backtrace for cpu 0
06:24:00: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
06:24:00: 
06:24:00: Pid: 0, comm: swapper Not tainted 2.6.38-rc4 #226 0MG532/MXC061                          
06:24:00: EIP: 0060:[<c1019322>] EFLAGS: 00000047 CPU: 0
06:24:00: EIP is at read_hpet+0xe/0x12
06:24:00: EAX: 0bb63987 EBX: 0108aa10 ECX: fffff000 EDX: 00000000
06:24:00: ESI: c1433a80 EDI: 477a8b97 EBP: c1421efc ESP: c1421efc
06:24:00:  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
06:24:00: Process swapper (pid: 0, ti=c1420000 task=c142fe20 task.ti=c1420000)
06:24:00: Stack:
06:24:00:  00000000 c1042852 00000003 c14e8cc8 0000c157 00000000 00000000 000003e8
06:24:00:  f6402cc8 00000000 c10477a4 00000000 000003e8 00000000 c1421f6c c102eb08
06:24:00:  ffffffcf c1003d1a f60d9440 c1421f9c c1040c67 3b859097 00002d04 00000000
06:24:00: Call Trace:
06:24:00:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:24:00:  [<c10477a4>] ? tick_check_idle+0x28/0x82
06:24:00:  [<c102eb08>] ? irq_enter+0x34/0x54
06:24:00:  [<c1003d1a>] ? do_IRQ+0x1e/0x95
06:24:00:  [<c1040c67>] ? sched_clock_local+0x19/0x17c
06:24:00:  [<c1002c69>] ? common_interrupt+0x29/0x30
06:24:00:  [<c115b48b>] ? acpi_idle_enter_bm+0x22c/0x261
06:24:00:  [<c123289f>] ? cpuidle_idle_call+0x67/0x98
06:24:00:  [<c1001ae9>] ? cpu_idle+0x41/0x5c
06:24:00:  [<c14987ce>] ? start_kernel+0x276/0x27b
06:24:00:  [<c149839a>] ? unknown_bootoption+0x0/0x18c
06:24:00: Code: 4f c1 8b 92 f0 00 00 00 29 d0 89 c2 31 c0 81 fa 80 00 00 00 ba c2 ff ff ff 0f 4c c2 c3 55 a1 34 e7 4f c1 89 e5 8b 80 f0 00 00 00 <31> d2 c9 c3 83 3d 38 e7 4f c1 00 75 37 83 3d 20 e7 4f c1 00 74 
06:24:00: Call Trace:
06:24:00:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:24:00:  [<c10477a4>] ? tick_check_idle+0x28/0x82
06:24:00:  [<c102eb08>] ? irq_enter+0x34/0x54
06:24:00:  [<c1003d1a>] ? do_IRQ+0x1e/0x95
06:24:00:  [<c1040c67>] ? sched_clock_local+0x19/0x17c
06:24:00:  [<c1002c69>] ? common_interrupt+0x29/0x30
06:24:00:  [<c115b48b>] ? acpi_idle_enter_bm+0x22c/0x261
06:24:00:  [<c123289f>] ? cpuidle_idle_call+0x67/0x98
06:24:00:  [<c1001ae9>] ? cpu_idle+0x41/0x5c
06:24:00:  [<c14987ce>] ? start_kernel+0x276/0x27b
06:24:00:  [<c149839a>] ? unknown_bootoption+0x0/0x18c
06:24:00: Pid: 0, comm: swapper Not tainted 2.6.38-rc4 #226
06:24:00: Call Trace:
06:24:00:  [<c10054b6>] ? show_trace+0xf/0x11
06:24:00:  [<c1015eff>] ? arch_trigger_all_cpu_backtrace_handler+0x57/0x73
06:24:00:  [<c104039f>] ? notifier_call_chain+0x23/0x46
06:24:00:  [<c10403e3>] ? atomic_notifier_call_chain+0x1a/0x1d
06:24:00:  [<c1040477>] ? notify_die+0x30/0x34
06:24:00:  [<c1003657>] ? do_nmi+0x68/0x267
06:24:00:  [<c13050d1>] ? nmi_stack_correct+0x28/0x2d
06:24:00:  [<c104007b>] ? copy_namespaces+0x1/0x7e
06:24:00:  [<c1019322>] ? read_hpet+0xe/0x12
06:24:00:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:24:00:  [<c10477a4>] ? tick_check_idle+0x28/0x82
06:24:00:  [<c102eb08>] ? irq_enter+0x34/0x54
06:24:00:  [<c1003d1a>] ? do_IRQ+0x1e/0x95
06:24:00:  [<c1040c67>] ? sched_clock_local+0x19/0x17c
06:24:00:  [<c1002c69>] ? common_interrupt+0x29/0x30
06:24:00:  [<c115b48b>] ? acpi_idle_enter_bm+0x22c/0x261
06:24:00:  [<c123289f>] ? cpuidle_idle_call+0x67/0x98
06:24:00:  [<c1001ae9>] ? cpu_idle+0x41/0x5c
06:24:00:  [<c14987ce>] ? start_kernel+0x276/0x27b
06:24:00:  [<c149839a>] ? unknown_bootoption+0x0/0x18c
06:25:11: BUG: soft lockup - CPU#1 stuck for 64s! [firefox-bin:3145]
06:25:11: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
06:25:11: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
06:25:11: 
06:25:11: Pid: 3145, comm: firefox-bin Not tainted 2.6.38-rc4 #226 0MG532/MXC061                          
06:25:11: EIP: 0060:[<c106eda8>] EFLAGS: 00000286 CPU: 1
06:25:11: EIP is at shrink_zone+0x1cb/0x4c3
06:25:11: EAX: 00000d97 EBX: c1492e00 ECX: 0000003d EDX: 00000004
06:25:11: ESI: f21a3e24 EDI: c1493040 EBP: f21a3dec ESP: f21a3d68
06:25:11:  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
06:25:11: Process firefox-bin (pid: 3145, ti=f21a2000 task=f613c6c0 task.ti=f21a2000)
06:25:11: Stack:
06:25:11:  00000dd5 00000000 00000000 c1492e00 0000c88d 00000020 00000021 c1493098
06:25:11:  00000004 c14930a8 c1493040 c14930a4 c14930a0 c149309c 0000000b 0000a189
06:25:11:  00001e1e 00000000 0000003c 00000000 00000000 00000000 00000000 00000040
06:25:11: Call Trace:
06:25:11:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
06:25:11:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
06:25:11:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
06:25:11:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
06:25:11:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:25:11:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
06:25:11:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
06:25:11:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
06:25:11:  [<c1047272>] ? tick_program_event+0x19/0x1c
06:25:11:  [<c102e915>] ? irq_exit+0x41/0x64
06:25:11:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:25:11:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:25:11:  [<c1305022>] ? error_code+0x5a/0x60
06:25:11:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
06:25:11:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:25:11: Code: 8b 93 78 02 00 00 8b bb 70 02 00 00 42 47 89 c1 b8 c9 00 00 00 2b 44 24 48 0f af c2 31 d2 f7 f7 8b 7c 24 28 fe 07 fb 89 44 24 68 <89> 4c 24 60 8d 44 01 01 c7 44 24 64 00 00 00 00 c7 44 24 6c 00 
06:25:11: Call Trace:
06:25:11:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
06:25:11:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
06:25:11:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
06:25:11:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
06:25:11:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:25:11:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
06:25:11:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
06:25:11:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
06:25:11:  [<c1047272>] ? tick_program_event+0x19/0x1c
06:25:11:  [<c102e915>] ? irq_exit+0x41/0x64
06:25:11:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:25:11:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:25:11:  [<c1305022>] ? error_code+0x5a/0x60
06:25:11:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
06:25:11:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:26:22: BUG: soft lockup - CPU#1 stuck for 63s! [firefox-bin:3145]
06:26:22: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
06:26:22: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
06:26:22: 
06:26:22: Pid: 3145, comm: firefox-bin Not tainted 2.6.38-rc4 #226 0MG532/MXC061                          
06:26:22: EIP: 0060:[<c106eda8>] EFLAGS: 00000282 CPU: 1
06:26:22: EIP is at shrink_zone+0x1cb/0x4c3
06:26:22: EAX: 00000da4 EBX: c1492e00 ECX: 0000003d EDX: 00000009
06:26:22: ESI: f21a3e24 EDI: c1493040 EBP: f21a3dec ESP: f21a3d68
06:26:22:  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
06:26:22: Process firefox-bin (pid: 3145, ti=f21a2000 task=f613c6c0 task.ti=f21a2000)
06:26:22: Stack:
06:26:22:  00000de2 00000000 00000000 c1492e00 0000c88d 00000020 00000021 c1493098
06:26:22:  00000004 c14930a8 c1493040 c14930a4 c14930a0 c149309c 0000000b 0000a189
06:26:22:  00001e22 00000000 0000003c 00000000 00000000 00000000 00000000 00000040
06:26:22: Call Trace:
06:26:22:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
06:26:22:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
06:26:22:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
06:26:22:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
06:26:22:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:26:22:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
06:26:22:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
06:26:22:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
06:26:22:  [<c1047272>] ? tick_program_event+0x19/0x1c
06:26:22:  [<c102e915>] ? irq_exit+0x41/0x64
06:26:22:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:26:22:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:26:22:  [<c1305022>] ? error_code+0x5a/0x60
06:26:22:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
06:26:22:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:26:22: Code: 8b 93 78 02 00 00 8b bb 70 02 00 00 42 47 89 c1 b8 c9 00 00 00 2b 44 24 48 0f af c2 31 d2 f7 f7 8b 7c 24 28 fe 07 fb 89 44 24 68 <89> 4c 24 60 8d 44 01 01 c7 44 24 64 00 00 00 00 c7 44 24 6c 00 
06:26:22: Call Trace:
06:26:22:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
06:26:22:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
06:26:22:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
06:26:22:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
06:26:22:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:26:22:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
06:26:22:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
06:26:22:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
06:26:22:  [<c1047272>] ? tick_program_event+0x19/0x1c
06:26:22:  [<c102e915>] ? irq_exit+0x41/0x64
06:26:22:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:26:22:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:26:22:  [<c1305022>] ? error_code+0x5a/0x60
06:26:22:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
06:26:22:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:27:00: INFO: rcu_sched_state detected stall on CPU 1 (t=180090 jiffies)
06:27:00: sending NMI to all CPUs:
06:27:00: NMI backtrace for cpu 1
06:27:00: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
06:27:00: 
06:27:00: Pid: 3145, comm: firefox-bin Not tainted 2.6.38-rc4 #226 0MG532/MXC061                          
06:27:00: EIP: 0060:[<c110f7b1>] EFLAGS: 00000006 CPU: 1
06:27:00: EIP is at __const_udelay+0xa/0x19
06:27:00: EAX: 01062560 EBX: 00000001 ECX: 00000800 EDX: 006597cf
06:27:00: ESI: c1436640 EDI: 00000001 EBP: c1436640 ESP: f21a3c3c
06:27:00:  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
06:27:00: Process firefox-bin (pid: 3145, ti=f21a2000 task=f613c6c0 task.ti=f21a2000)
06:27:00: Stack:
06:27:00:  c1015f6d c13a101a f6602e14 c105c85b c13a901b c13a9102 00000001 0002bf7a
06:27:00:  00000000 00000000 00000001 00000000 00000001 f21a3d2c c105caf0 f613c6c0
06:27:00:  c1032df0 f6602cc8 2a511350 00002d2e c1047627 f6602cc8 f6602c70 f6602cc8
06:27:00: Call Trace:
06:27:00:  [<c1015f6d>] ? arch_trigger_all_cpu_backtrace+0x52/0x65
06:27:00:  [<c105c85b>] ? __rcu_pending+0x6c/0x277
06:27:00:  [<c105caf0>] ? rcu_check_callbacks+0x8a/0xb6
06:27:00:  [<c1032df0>] ? update_process_times+0x2a/0x53
06:27:00:  [<c1047627>] ? tick_sched_timer+0x64/0x8d
06:27:00:  [<c103f332>] ? __run_hrtimer+0x6d/0xc3
06:27:00:  [<c103f595>] ? hrtimer_interrupt+0x10c/0x213
06:27:00:  [<c102e915>] ? irq_exit+0x41/0x64
06:27:00:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:27:00:  [<c10157cc>] ? smp_apic_timer_interrupt+0x6c/0x7d
06:27:00:  [<c1110a8b>] ? div_u64_rem+0x1b/0x2a
06:27:00:  [<c1304e02>] ? apic_timer_interrupt+0x2a/0x30
06:27:00:  [<c111007b>] ? __put_user_8+0xf/0x19
06:27:00:  [<c106eda8>] ? shrink_zone+0x1cb/0x4c3
06:27:00:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
06:27:00:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
06:27:00:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
06:27:00:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
06:27:00:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:27:00:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
06:27:00:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
06:27:00:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
06:27:00:  [<c1047272>] ? tick_program_event+0x19/0x1c
06:27:00:  [<c102e915>] ? irq_exit+0x41/0x64
06:27:00:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:27:00:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:27:00:  [<c1305022>] ? error_code+0x5a/0x60
06:27:00:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
06:27:00:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:27:00: Code: 00 00 00 8d bc 27 00 00 00 00 48 75 fd 48 c3 c7 05 c0 14 44 c1 d3 f7 10 c1 c3 ff 15 c0 14 44 c1 c3 c1 e0 02 64 8b 15 9c b9 4e c1 <6b> d2 4b f7 e2 8d 42 01 ff 15 c0 14 44 c1 c3 69 c0 c7 10 00 00 
06:27:00: Call Trace:
06:27:00:  [<c1015f6d>] ? arch_trigger_all_cpu_backtrace+0x52/0x65
06:27:00:  [<c105c85b>] ? __rcu_pending+0x6c/0x277
06:27:00:  [<c105caf0>] ? rcu_check_callbacks+0x8a/0xb6
06:27:00:  [<c1032df0>] ? update_process_times+0x2a/0x53
06:27:00:  [<c1047627>] ? tick_sched_timer+0x64/0x8d
06:27:00:  [<c103f332>] ? __run_hrtimer+0x6d/0xc3
06:27:00:  [<c103f595>] ? hrtimer_interrupt+0x10c/0x213
06:27:00:  [<c102e915>] ? irq_exit+0x41/0x64
06:27:00:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:27:00:  [<c10157cc>] ? smp_apic_timer_interrupt+0x6c/0x7d
06:27:00:  [<c1110a8b>] ? div_u64_rem+0x1b/0x2a
06:27:00:  [<c1304e02>] ? apic_timer_interrupt+0x2a/0x30
06:27:00:  [<c111007b>] ? __put_user_8+0xf/0x19
06:27:00:  [<c106eda8>] ? shrink_zone+0x1cb/0x4c3
06:27:00:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
06:27:00:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
06:27:00:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
06:27:00:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
06:27:00:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:27:00:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
06:27:00:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
06:27:00:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
06:27:00:  [<c1047272>] ? tick_program_event+0x19/0x1c
06:27:00:  [<c102e915>] ? irq_exit+0x41/0x64
06:27:00:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:27:00:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:27:00:  [<c1305022>] ? error_code+0x5a/0x60
06:27:00:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
06:27:00:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:27:00: Pid: 3145, comm: firefox-bin Not tainted 2.6.38-rc4 #226
06:27:00: Call Trace:
06:27:00:  [<c10054b6>] ? show_trace+0xf/0x11
06:27:00:  [<c1015eff>] ? arch_trigger_all_cpu_backtrace_handler+0x57/0x73
06:27:00:  [<c104039f>] ? notifier_call_chain+0x23/0x46
06:27:00:  [<c10403e3>] ? atomic_notifier_call_chain+0x1a/0x1d
06:27:00:  [<c1040477>] ? notify_die+0x30/0x34
06:27:00:  [<c1003657>] ? do_nmi+0x68/0x267
06:27:00:  [<c13050d1>] ? nmi_stack_correct+0x28/0x2d
06:27:00:  [<c110f7b1>] ? __const_udelay+0xa/0x19
06:27:00:  [<c1015f6d>] ? arch_trigger_all_cpu_backtrace+0x52/0x65
06:27:00:  [<c105c85b>] ? __rcu_pending+0x6c/0x277
06:27:00:  [<c105caf0>] ? rcu_check_callbacks+0x8a/0xb6
06:27:00:  [<c1032df0>] ? update_process_times+0x2a/0x53
06:27:00:  [<c1047627>] ? tick_sched_timer+0x64/0x8d
06:27:00:  [<c103f332>] ? __run_hrtimer+0x6d/0xc3
06:27:00:  [<c103f595>] ? hrtimer_interrupt+0x10c/0x213
06:27:00:  [<c102e915>] ? irq_exit+0x41/0x64
06:27:00:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:27:00:  [<c10157cc>] ? smp_apic_timer_interrupt+0x6c/0x7d
06:27:00:  [<c1110a8b>] ? div_u64_rem+0x1b/0x2a
06:27:00:  [<c1304e02>] ? apic_timer_interrupt+0x2a/0x30
06:27:00:  [<c111007b>] ? __put_user_8+0xf/0x19
06:27:00:  [<c106eda8>] ? shrink_zone+0x1cb/0x4c3
06:27:00:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
06:27:00:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
06:27:00:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
06:27:00:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
06:27:00:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:27:00:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
06:27:00:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
06:27:00:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
06:27:00:  [<c1047272>] ? tick_program_event+0x19/0x1c
06:27:00:  [<c102e915>] ? irq_exit+0x41/0x64
06:27:00:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:27:00:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:27:00:  [<c1305022>] ? error_code+0x5a/0x60
06:27:00:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
06:27:00:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:27:00: NMI backtrace for cpu 0
06:27:00: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
06:27:00: 
06:27:00: Pid: 0, comm: swapper Not tainted 2.6.38-rc4 #226 0MG532/MXC061                          
06:27:00: EIP: 0060:[<c1019322>] EFLAGS: 00000057 CPU: 0
06:27:00: EIP is at read_hpet+0xe/0x12
06:27:00: EAX: a56a9180 EBX: 010a502c ECX: fffff000 EDX: 00000000
06:27:00: ESI: c1433a80 EDI: 4d74ee20 EBP: c1421efc ESP: c1421efc
06:27:00:  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
06:27:00: Process swapper (pid: 0, ti=c1420000 task=c142fe20 task.ti=c1420000)
06:27:00: Stack:
06:27:00:  00000000 c1042852 00000003 c14e8cc8 0000c20b 00000000 00000000 000003e8
06:27:00:  f6402cc8 00000000 c10477a4 00000000 000003e8 00000000 c1421f6c c102eb08
06:27:00:  ffffffcf c1003d1a f60d9440 c1421f9c c1040c67 2a513302 00002d2e 00000000
06:27:00: Call Trace:
06:27:00:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:27:00:  [<c10477a4>] ? tick_check_idle+0x28/0x82
06:27:00:  [<c102eb08>] ? irq_enter+0x34/0x54
06:27:00:  [<c1003d1a>] ? do_IRQ+0x1e/0x95
06:27:00:  [<c1040c67>] ? sched_clock_local+0x19/0x17c
06:27:00:  [<c1002c69>] ? common_interrupt+0x29/0x30
06:27:00:  [<c115b48b>] ? acpi_idle_enter_bm+0x22c/0x261
06:27:00:  [<c123289f>] ? cpuidle_idle_call+0x67/0x98
06:27:00:  [<c1001ae9>] ? cpu_idle+0x41/0x5c
06:27:00:  [<c14987ce>] ? start_kernel+0x276/0x27b
06:27:00:  [<c149839a>] ? unknown_bootoption+0x0/0x18c
06:27:00: Code: 4f c1 8b 92 f0 00 00 00 29 d0 89 c2 31 c0 81 fa 80 00 00 00 ba c2 ff ff ff 0f 4c c2 c3 55 a1 34 e7 4f c1 89 e5 8b 80 f0 00 00 00 <31> d2 c9 c3 83 3d 38 e7 4f c1 00 75 37 83 3d 20 e7 4f c1 00 74 
06:27:00: Call Trace:
06:27:00:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:27:00:  [<c10477a4>] ? tick_check_idle+0x28/0x82
06:27:00:  [<c102eb08>] ? irq_enter+0x34/0x54
06:27:00:  [<c1003d1a>] ? do_IRQ+0x1e/0x95
06:27:00:  [<c1040c67>] ? sched_clock_local+0x19/0x17c
06:27:00:  [<c1002c69>] ? common_interrupt+0x29/0x30
06:27:00:  [<c115b48b>] ? acpi_idle_enter_bm+0x22c/0x261
06:27:00:  [<c123289f>] ? cpuidle_idle_call+0x67/0x98
06:27:00:  [<c1001ae9>] ? cpu_idle+0x41/0x5c
06:27:00:  [<c14987ce>] ? start_kernel+0x276/0x27b
06:27:00:  [<c149839a>] ? unknown_bootoption+0x0/0x18c
06:27:00: Pid: 0, comm: swapper Not tainted 2.6.38-rc4 #226
06:27:00: Call Trace:
06:27:00:  [<c10054b6>] ? show_trace+0xf/0x11
06:27:00:  [<c1015eff>] ? arch_trigger_all_cpu_backtrace_handler+0x57/0x73
06:27:00:  [<c104039f>] ? notifier_call_chain+0x23/0x46
06:27:00:  [<c10403e3>] ? atomic_notifier_call_chain+0x1a/0x1d
06:27:00:  [<c1040477>] ? notify_die+0x30/0x34
06:27:00:  [<c1003657>] ? do_nmi+0x68/0x267
06:27:00:  [<c13050d1>] ? nmi_stack_correct+0x28/0x2d
06:27:00:  [<c104007b>] ? copy_namespaces+0x1/0x7e
06:27:00:  [<c1019322>] ? read_hpet+0xe/0x12
06:27:00:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:27:00:  [<c10477a4>] ? tick_check_idle+0x28/0x82
06:27:00:  [<c102eb08>] ? irq_enter+0x34/0x54
06:27:00:  [<c1003d1a>] ? do_IRQ+0x1e/0x95
06:27:00:  [<c1040c67>] ? sched_clock_local+0x19/0x17c
06:27:00:  [<c1002c69>] ? common_interrupt+0x29/0x30
06:27:00:  [<c115b48b>] ? acpi_idle_enter_bm+0x22c/0x261
06:27:00:  [<c123289f>] ? cpuidle_idle_call+0x67/0x98
06:27:00:  [<c1001ae9>] ? cpu_idle+0x41/0x5c
06:27:00:  [<c14987ce>] ? start_kernel+0x276/0x27b
06:27:00:  [<c149839a>] ? unknown_bootoption+0x0/0x18c
06:28:33: INFO: rcu_sched_state detected stall on CPU 1 (t=18000 jiffies)
06:28:33: sending NMI to all CPUs:
06:28:33: NMI backtrace for cpu 1
06:28:33: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
06:28:33: 
06:28:33: Pid: 3145, comm: firefox-bin Not tainted 2.6.38-rc4 #226 0MG532/MXC061                          
06:28:33: EIP: 0060:[<c110f7b1>] EFLAGS: 00000006 CPU: 1
06:28:33: EIP is at __const_udelay+0xa/0x19
06:28:33: EAX: 01062560 EBX: 00000001 ECX: 00000800 EDX: 006597cf
06:28:33: ESI: c1436640 EDI: 00000001 EBP: c1436640 ESP: f21a3c3c
06:28:33:  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
06:28:33: Process firefox-bin (pid: 3145, ti=f21a2000 task=f613c6c0 task.ti=f21a2000)
06:28:33: Stack:
06:28:33:  c1015f6d c13a101a f6602e14 c105c85b c13a901b c13a9102 00000001 00004650
06:28:33:  00000000 00000000 00000001 00000000 00000001 f21a3d2c c105caf0 f613c6c0
06:28:33:  c1032df0 f6602cc8 bfaaad39 00002d43 c1047627 f6602cc8 f6602c70 f6602cc8
06:28:33: Call Trace:
06:28:33:  [<c1015f6d>] ? arch_trigger_all_cpu_backtrace+0x52/0x65
06:28:33:  [<c105c85b>] ? __rcu_pending+0x6c/0x277
06:28:33:  [<c105caf0>] ? rcu_check_callbacks+0x8a/0xb6
06:28:33:  [<c1032df0>] ? update_process_times+0x2a/0x53
06:28:33:  [<c1047627>] ? tick_sched_timer+0x64/0x8d
06:28:33:  [<c103f332>] ? __run_hrtimer+0x6d/0xc3
06:28:33:  [<c103f595>] ? hrtimer_interrupt+0x10c/0x213
06:28:33:  [<c10157cc>] ? smp_apic_timer_interrupt+0x6c/0x7d
06:28:33:  [<c111007b>] ? __put_user_8+0xf/0x19
06:28:33:  [<c1304e02>] ? apic_timer_interrupt+0x2a/0x30
06:28:33:  [<c106edfe>] ? shrink_zone+0x221/0x4c3
06:28:33:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
06:28:33:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
06:28:33:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
06:28:33:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
06:28:33:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:28:33:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
06:28:33:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
06:28:33:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
06:28:33:  [<c1047272>] ? tick_program_event+0x19/0x1c
06:28:33:  [<c102e915>] ? irq_exit+0x41/0x64
06:28:33:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:28:33:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:28:33:  [<c1305022>] ? error_code+0x5a/0x60
06:28:33:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
06:28:33:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:28:33: Code: 00 00 00 8d bc 27 00 00 00 00 48 75 fd 48 c3 c7 05 c0 14 44 c1 d3 f7 10 c1 c3 ff 15 c0 14 44 c1 c3 c1 e0 02 64 8b 15 9c b9 4e c1 <6b> d2 4b f7 e2 8d 42 01 ff 15 c0 14 44 c1 c3 69 c0 c7 10 00 00 
06:28:33: Call Trace:
06:28:33:  [<c1015f6d>] ? arch_trigger_all_cpu_backtrace+0x52/0x65
06:28:33:  [<c105c85b>] ? __rcu_pending+0x6c/0x277
06:28:33:  [<c105caf0>] ? rcu_check_callbacks+0x8a/0xb6
06:28:33:  [<c1032df0>] ? update_process_times+0x2a/0x53
06:28:33:  [<c1047627>] ? tick_sched_timer+0x64/0x8d
06:28:33:  [<c103f332>] ? __run_hrtimer+0x6d/0xc3
06:28:33:  [<c103f595>] ? hrtimer_interrupt+0x10c/0x213
06:28:33:  [<c10157cc>] ? smp_apic_timer_interrupt+0x6c/0x7d
06:28:33:  [<c111007b>] ? __put_user_8+0xf/0x19
06:28:33:  [<c1304e02>] ? apic_timer_interrupt+0x2a/0x30
06:28:33:  [<c106edfe>] ? shrink_zone+0x221/0x4c3
06:28:33:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
06:28:33:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
06:28:33:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
06:28:33:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
06:28:33:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:28:33:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
06:28:33:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
06:28:33:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
06:28:33:  [<c1047272>] ? tick_program_event+0x19/0x1c
06:28:33:  [<c102e915>] ? irq_exit+0x41/0x64
06:28:33:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:28:33:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:28:33:  [<c1305022>] ? error_code+0x5a/0x60
06:28:33:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
06:28:33:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:28:33: Pid: 3145, comm: firefox-bin Not tainted 2.6.38-rc4 #226
06:28:33: Call Trace:
06:28:33:  [<c10054b6>] ? show_trace+0xf/0x11
06:28:33:  [<c1015eff>] ? arch_trigger_all_cpu_backtrace_handler+0x57/0x73
06:28:33:  [<c104039f>] ? notifier_call_chain+0x23/0x46
06:28:33:  [<c10403e3>] ? atomic_notifier_call_chain+0x1a/0x1d
06:28:33:  [<c1040477>] ? notify_die+0x30/0x34
06:28:33:  [<c1003657>] ? do_nmi+0x68/0x267
06:28:33:  [<c13050d1>] ? nmi_stack_correct+0x28/0x2d
06:28:33:  [<c110f7b1>] ? __const_udelay+0xa/0x19
06:28:33:  [<c1015f6d>] ? arch_trigger_all_cpu_backtrace+0x52/0x65
06:28:33:  [<c105c85b>] ? __rcu_pending+0x6c/0x277
06:28:33:  [<c105caf0>] ? rcu_check_callbacks+0x8a/0xb6
06:28:33:  [<c1032df0>] ? update_process_times+0x2a/0x53
06:28:33:  [<c1047627>] ? tick_sched_timer+0x64/0x8d
06:28:33:  [<c103f332>] ? __run_hrtimer+0x6d/0xc3
06:28:33:  [<c103f595>] ? hrtimer_interrupt+0x10c/0x213
06:28:33:  [<c10157cc>] ? smp_apic_timer_interrupt+0x6c/0x7d
06:28:33:  [<c111007b>] ? __put_user_8+0xf/0x19
06:28:33:  [<c1304e02>] ? apic_timer_interrupt+0x2a/0x30
06:28:33:  [<c106edfe>] ? shrink_zone+0x221/0x4c3
06:28:33:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
06:28:33:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
06:28:33:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
06:28:33:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
06:28:33:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:28:33:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
06:28:33:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
06:28:33:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
06:28:33:  [<c1047272>] ? tick_program_event+0x19/0x1c
06:28:33:  [<c102e915>] ? irq_exit+0x41/0x64
06:28:33:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:28:33:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:28:33:  [<c1305022>] ? error_code+0x5a/0x60
06:28:33:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
06:28:33:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:28:33: NMI backtrace for cpu 0
06:28:33: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
06:28:33: 
06:28:33: Pid: 0, comm: swapper Not tainted 2.6.38-rc4 #226 0MG532/MXC061                          
06:28:33: EIP: 0060:[<c1019322>] EFLAGS: 00000046 CPU: 0
06:28:33: EIP is at read_hpet+0xe/0x12
06:28:33: EAX: f487b6ee EBX: 010b2970 ECX: fffff000 EDX: 00000000
06:28:33: ESI: c1433a80 EDI: 3bae3c6e EBP: c1421efc ESP: c1421efc
06:28:33:  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
06:28:33: Process swapper (pid: 0, ti=c1420000 task=c142fe20 task.ti=c1420000)
06:28:33: Stack:
06:28:33:  00000000 c1042852 00000003 c14e8cc8 0000c268 00000000 00000000 000003e8
06:28:33:  f6402cc8 00000000 c10477a4 00000000 000003e8 00000000 c1421f6c c102eb08
06:28:33:  ffffffcf c1003d1a f60d9440 c1421f9c c1040c67 bfaacfa5 00002d43 00000000
06:28:33: Call Trace:
06:28:33:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:28:33:  [<c10477a4>] ? tick_check_idle+0x28/0x82
06:28:33:  [<c102eb08>] ? irq_enter+0x34/0x54
06:28:33:  [<c1003d1a>] ? do_IRQ+0x1e/0x95
06:28:33:  [<c1040c67>] ? sched_clock_local+0x19/0x17c
06:28:33:  [<c1002c69>] ? common_interrupt+0x29/0x30
06:28:33:  [<c115b48b>] ? acpi_idle_enter_bm+0x22c/0x261
06:28:33:  [<c123289f>] ? cpuidle_idle_call+0x67/0x98
06:28:33:  [<c1001ae9>] ? cpu_idle+0x41/0x5c
06:28:33:  [<c14987ce>] ? start_kernel+0x276/0x27b
06:28:33:  [<c149839a>] ? unknown_bootoption+0x0/0x18c
06:28:33: Code: 4f c1 8b 92 f0 00 00 00 29 d0 89 c2 31 c0 81 fa 80 00 00 00 ba c2 ff ff ff 0f 4c c2 c3 55 a1 34 e7 4f c1 89 e5 8b 80 f0 00 00 00 <31> d2 c9 c3 83 3d 38 e7 4f c1 00 75 37 83 3d 20 e7 4f c1 00 74 
06:28:33: Call Trace:
06:28:33:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:28:33:  [<c10477a4>] ? tick_check_idle+0x28/0x82
06:28:33:  [<c102eb08>] ? irq_enter+0x34/0x54
06:28:33:  [<c1003d1a>] ? do_IRQ+0x1e/0x95
06:28:33:  [<c1040c67>] ? sched_clock_local+0x19/0x17c
06:28:33:  [<c1002c69>] ? common_interrupt+0x29/0x30
06:28:33:  [<c115b48b>] ? acpi_idle_enter_bm+0x22c/0x261
06:28:33:  [<c123289f>] ? cpuidle_idle_call+0x67/0x98
06:28:33:  [<c1001ae9>] ? cpu_idle+0x41/0x5c
06:28:33:  [<c14987ce>] ? start_kernel+0x276/0x27b
06:28:33:  [<c149839a>] ? unknown_bootoption+0x0/0x18c
06:28:33: Pid: 0, comm: swapper Not tainted 2.6.38-rc4 #226
06:28:33: Call Trace:
06:28:33:  [<c10054b6>] ? show_trace+0xf/0x11
06:28:33:  [<c1015eff>] ? arch_trigger_all_cpu_backtrace_handler+0x57/0x73
06:28:33:  [<c104039f>] ? notifier_call_chain+0x23/0x46
06:28:33:  [<c10403e3>] ? atomic_notifier_call_chain+0x1a/0x1d
06:28:33:  [<c1040477>] ? notify_die+0x30/0x34
06:28:33:  [<c1003657>] ? do_nmi+0x68/0x267
06:28:33:  [<c1040c67>] ? sched_clock_local+0x19/0x17c
06:28:33:  [<c13050d1>] ? nmi_stack_correct+0x28/0x2d
06:28:33:  [<c104007b>] ? copy_namespaces+0x1/0x7e
06:28:33:  [<c1019322>] ? read_hpet+0xe/0x12
06:28:33:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:28:33:  [<c10477a4>] ? tick_check_idle+0x28/0x82
06:28:33:  [<c102eb08>] ? irq_enter+0x34/0x54
06:28:33:  [<c1003d1a>] ? do_IRQ+0x1e/0x95
06:28:33:  [<c1040c67>] ? sched_clock_local+0x19/0x17c
06:28:33:  [<c1002c69>] ? common_interrupt+0x29/0x30
06:28:33:  [<c115b48b>] ? acpi_idle_enter_bm+0x22c/0x261
06:28:33:  [<c123289f>] ? cpuidle_idle_call+0x67/0x98
06:28:33:  [<c1001ae9>] ? cpu_idle+0x41/0x5c
06:28:33:  [<c14987ce>] ? start_kernel+0x276/0x27b
06:28:33:  [<c149839a>] ? unknown_bootoption+0x0/0x18c
06:29:40: BUG: soft lockup - CPU#1 stuck for 61s! [firefox-bin:3145]
06:29:40: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
06:29:40: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
06:29:40: 
06:29:40: Pid: 3145, comm: firefox-bin Not tainted 2.6.38-rc4 #226 0MG532/MXC061                          
06:29:40: EIP: 0060:[<c106ee0f>] EFLAGS: 00000202 CPU: 1
06:29:40: EIP is at shrink_zone+0x232/0x4c3
06:29:40: EAX: 00000e26 EBX: c1492e00 ECX: 00000000 EDX: c1492e00
06:29:40: ESI: f21a3e24 EDI: 00000003 EBP: f21a3dec ESP: f21a3d68
06:29:40:  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
06:29:40: Process firefox-bin (pid: 3145, ti=f21a2000 task=f613c6c0 task.ti=f21a2000)
06:29:40: Stack:
06:29:40:  00000e5e 00000000 00000000 c1492e00 0000c88d 00000020 00000021 c1493098
06:29:40:  00000004 c14930a8 c1493040 c14930a4 c14930a0 c149309c 0000000b 00000000
06:29:40:  00000e5e 00000000 00000001 00000000 00000000 00000000 00000000 00000040
06:29:40: Call Trace:
06:29:40:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
06:29:40:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
06:29:40:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
06:29:40:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
06:29:40:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:29:40:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
06:29:40:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
06:29:40:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
06:29:40:  [<c1047272>] ? tick_program_event+0x19/0x1c
06:29:40:  [<c102e915>] ? irq_exit+0x41/0x64
06:29:40:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:29:40:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:29:40:  [<c1305022>] ? error_code+0x5a/0x60
06:29:40:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
06:29:40:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:29:40: Code: 01 8b 54 24 0c 89 44 24 20 b9 00 00 00 00 8d 84 ba 84 02 00 00 8b 40 18 85 c0 0f 48 c1 83 7c 24 3c 00 75 07 83 7c 24 38 00 74 32 <83> 7c 24 48 02 8a 4c 24 38 19 d2 8b 5c 24 44 d3 e8 83 e2 08 8b 
06:29:40: Call Trace:
06:29:40:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
06:29:40:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
06:29:40:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
06:29:40:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
06:29:40:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:29:40:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
06:29:40:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
06:29:40:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
06:29:40:  [<c1047272>] ? tick_program_event+0x19/0x1c
06:29:40:  [<c102e915>] ? irq_exit+0x41/0x64
06:29:40:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:29:40:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:29:40:  [<c1305022>] ? error_code+0x5a/0x60
06:29:40:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
06:29:40:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:30:52: BUG: soft lockup - CPU#1 stuck for 63s! [firefox-bin:3145]
06:30:52: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
06:30:52: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
06:30:52: 
06:30:52: Pid: 3145, comm: firefox-bin Not tainted 2.6.38-rc4 #226 0MG532/MXC061                          
06:30:52: EIP: 0060:[<c1110a7b>] EFLAGS: 00000246 CPU: 1
06:30:52: EIP is at div_u64_rem+0xb/0x2a
06:30:52: EAX: 00000e27 EBX: 00000e27 ECX: 00000000 EDX: 00000000
06:30:52: ESI: 00000e65 EDI: f21a3d50 EBP: f21a3d30 ESP: f21a3d28
06:30:52:  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
06:30:52: Process firefox-bin (pid: 3145, ti=f21a2000 task=f613c6c0 task.ti=f21a2000)
06:30:52: Stack:
06:30:52:  00000e27 00000000 f21a3d60 c1110bcb f21a3d50 00000000 00000000 00000014
06:30:52:  ffff007b c111007b 000004c4 00000000 f21a3e24 00000002 f21a3dec c106ee41
06:30:52:  00000e65 00000000 00000000 c1492e00 0000c88d 00000020 00000021 c1493098
06:30:52: Call Trace:
06:30:52:  [<c1110bcb>] ? div64_u64+0x25/0xef
06:30:52:  [<c111007b>] ? __put_user_8+0xf/0x19
06:30:52:  [<c106ee41>] ? shrink_zone+0x264/0x4c3
06:30:52:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
06:30:52:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
06:30:52:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
06:30:52:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
06:30:52:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:30:52:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
06:30:52:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
06:30:52:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
06:30:52:  [<c1047272>] ? tick_program_event+0x19/0x1c
06:30:52:  [<c102e915>] ? irq_exit+0x41/0x64
06:30:52:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:30:52:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:30:52:  [<c1305022>] ? error_code+0x5a/0x60
06:30:52:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
06:30:52:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:30:52: Code: 0f c0 ea 04 0f b6 d2 6b d2 0a 8d 04 02 c3 b9 0a 00 00 00 31 d2 f7 f1 c1 e0 04 01 d0 c3 90 90 90 55 89 e5 56 89 ce 53 31 c9 89 c3 <39> f2 72 08 89 d0 31 d2 f7 f6 89 c1 89 d8 f7 f6 89 c3 8b 45 08 
06:30:52: Call Trace:
06:30:52:  [<c1110bcb>] ? div64_u64+0x25/0xef
06:30:52:  [<c111007b>] ? __put_user_8+0xf/0x19
06:30:52:  [<c106ee41>] ? shrink_zone+0x264/0x4c3
06:30:52:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
06:30:52:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
06:30:52:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
06:30:52:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
06:30:52:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:30:52:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
06:30:52:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
06:30:52:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
06:30:52:  [<c1047272>] ? tick_program_event+0x19/0x1c
06:30:52:  [<c102e915>] ? irq_exit+0x41/0x64
06:30:52:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:30:52:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:30:52:  [<c1305022>] ? error_code+0x5a/0x60
06:30:52:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
06:30:52:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:31:33: INFO: rcu_sched_state detected stall on CPU 1 (t=72030 jiffies)
06:31:33: sending NMI to all CPUs:
06:31:33: NMI backtrace for cpu 1
06:31:33: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
06:31:33: 
06:31:33: Pid: 3145, comm: firefox-bin Not tainted 2.6.38-rc4 #226 0MG532/MXC061                          
06:31:33: EIP: 0060:[<c110f7aa>] EFLAGS: 00000006 CPU: 1
06:31:33: EIP is at __const_udelay+0x3/0x19
06:31:33: EAX: 01062560 EBX: 00000001 ECX: 00000800 EDX: fffff000
06:31:33: ESI: c1436640 EDI: 00000001 EBP: c1436640 ESP: f21a3c3c
06:31:33:  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
06:31:33: Process firefox-bin (pid: 3145, ti=f21a2000 task=f613c6c0 task.ti=f21a2000)
06:31:33: Stack:
06:31:33:  c1015f6d c13a101a f6602e14 c105c85b c13a901b c13a9102 00000001 0001195e
06:31:33:  00000000 00000000 00000001 00000000 00000001 f21a3d2c c105caf0 f613c6c0
06:31:33:  c1032df0 f6602cc8 ae765073 00002d6d c1047627 f6602cc8 f6602c70 f6602cc8
06:31:33: Call Trace:
06:31:33:  [<c1015f6d>] ? arch_trigger_all_cpu_backtrace+0x52/0x65
06:31:33:  [<c105c85b>] ? __rcu_pending+0x6c/0x277
06:31:33:  [<c105caf0>] ? rcu_check_callbacks+0x8a/0xb6
06:31:33:  [<c1032df0>] ? update_process_times+0x2a/0x53
06:31:33:  [<c1047627>] ? tick_sched_timer+0x64/0x8d
06:31:33:  [<c103f332>] ? __run_hrtimer+0x6d/0xc3
06:31:33:  [<c103f595>] ? hrtimer_interrupt+0x10c/0x213
06:31:33:  [<c102e915>] ? irq_exit+0x41/0x64
06:31:33:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:31:33:  [<c10157cc>] ? smp_apic_timer_interrupt+0x6c/0x7d
06:31:33:  [<c1110a8b>] ? div_u64_rem+0x1b/0x2a
06:31:33:  [<c1304e02>] ? apic_timer_interrupt+0x2a/0x30
06:31:33:  [<c111007b>] ? __put_user_8+0xf/0x19
06:31:33:  [<c106ede9>] ? shrink_zone+0x20c/0x4c3
06:31:33:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
06:31:33:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
06:31:33:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
06:31:33:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
06:31:33:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:31:33:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
06:31:33:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
06:31:33:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
06:31:33:  [<c1047272>] ? tick_program_event+0x19/0x1c
06:31:33:  [<c102e915>] ? irq_exit+0x41/0x64
06:31:33:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:31:33:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:31:33:  [<c1305022>] ? error_code+0x5a/0x60
06:31:33:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
06:31:33:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:31:33: Code: 00 eb 0e 8d b4 26 00 00 00 00 8d bc 27 00 00 00 00 48 75 fd 48 c3 c7 05 c0 14 44 c1 d3 f7 10 c1 c3 ff 15 c0 14 44 c1 c3 c1 e0 02 <64> 8b 15 9c b9 4e c1 6b d2 4b f7 e2 8d 42 01 ff 15 c0 14 44 c1 
06:31:33: Call Trace:
06:31:33:  [<c1015f6d>] ? arch_trigger_all_cpu_backtrace+0x52/0x65
06:31:33:  [<c105c85b>] ? __rcu_pending+0x6c/0x277
06:31:33:  [<c105caf0>] ? rcu_check_callbacks+0x8a/0xb6
06:31:33:  [<c1032df0>] ? update_process_times+0x2a/0x53
06:31:33:  [<c1047627>] ? tick_sched_timer+0x64/0x8d
06:31:33:  [<c103f332>] ? __run_hrtimer+0x6d/0xc3
06:31:33:  [<c103f595>] ? hrtimer_interrupt+0x10c/0x213
06:31:33:  [<c102e915>] ? irq_exit+0x41/0x64
06:31:33:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:31:33:  [<c10157cc>] ? smp_apic_timer_interrupt+0x6c/0x7d
06:31:33:  [<c1110a8b>] ? div_u64_rem+0x1b/0x2a
06:31:33:  [<c1304e02>] ? apic_timer_interrupt+0x2a/0x30
06:31:33:  [<c111007b>] ? __put_user_8+0xf/0x19
06:31:33:  [<c106ede9>] ? shrink_zone+0x20c/0x4c3
06:31:33:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
06:31:33:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
06:31:33:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
06:31:33:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
06:31:33:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:31:33:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
06:31:33:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
06:31:33:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
06:31:33:  [<c1047272>] ? tick_program_event+0x19/0x1c
06:31:33:  [<c102e915>] ? irq_exit+0x41/0x64
06:31:33:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:31:33:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:31:33:  [<c1305022>] ? error_code+0x5a/0x60
06:31:33:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
06:31:33:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:31:33: Pid: 3145, comm: firefox-bin Not tainted 2.6.38-rc4 #226
06:31:33: Call Trace:
06:31:33:  [<c10054b6>] ? show_trace+0xf/0x11
06:31:33:  [<c1015eff>] ? arch_trigger_all_cpu_backtrace_handler+0x57/0x73
06:31:33:  [<c104039f>] ? notifier_call_chain+0x23/0x46
06:31:33:  [<c10403e3>] ? atomic_notifier_call_chain+0x1a/0x1d
06:31:33:  [<c1040477>] ? notify_die+0x30/0x34
06:31:33:  [<c1003657>] ? do_nmi+0x68/0x267
06:31:33:  [<c13050d1>] ? nmi_stack_correct+0x28/0x2d
06:31:33:  [<c110f7aa>] ? __const_udelay+0x3/0x19
06:31:33:  [<c1015f6d>] ? arch_trigger_all_cpu_backtrace+0x52/0x65
06:31:33:  [<c105c85b>] ? __rcu_pending+0x6c/0x277
06:31:33:  [<c105caf0>] ? rcu_check_callbacks+0x8a/0xb6
06:31:33:  [<c1032df0>] ? update_process_times+0x2a/0x53
06:31:33:  [<c1047627>] ? tick_sched_timer+0x64/0x8d
06:31:33:  [<c103f332>] ? __run_hrtimer+0x6d/0xc3
06:31:33:  [<c103f595>] ? hrtimer_interrupt+0x10c/0x213
06:31:33:  [<c102e915>] ? irq_exit+0x41/0x64
06:31:33:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:31:33:  [<c10157cc>] ? smp_apic_timer_interrupt+0x6c/0x7d
06:31:33:  [<c1110a8b>] ? div_u64_rem+0x1b/0x2a
06:31:33:  [<c1304e02>] ? apic_timer_interrupt+0x2a/0x30
06:31:33:  [<c111007b>] ? __put_user_8+0xf/0x19
06:31:33:  [<c106ede9>] ? shrink_zone+0x20c/0x4c3
06:31:33:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
06:31:33:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
06:31:33:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
06:31:33:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
06:31:33:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:31:33:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
06:31:33:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
06:31:33:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
06:31:33:  [<c1047272>] ? tick_program_event+0x19/0x1c
06:31:33:  [<c102e915>] ? irq_exit+0x41/0x64
06:31:33:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:31:33:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:31:33:  [<c1305022>] ? error_code+0x5a/0x60
06:31:33:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
06:31:33:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:31:33: NMI backtrace for cpu 0
06:31:33: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
06:31:33: 
06:31:33: Pid: 0, comm: swapper Not tainted 2.6.38-rc4 #226 0MG532/MXC061                          
06:31:33: EIP: 0060:[<c1014bd0>] EFLAGS: 00000002 CPU: 0
06:31:33: EIP is at lapic_is_integrated+0x11/0x17
06:31:33: EAX: 00050014 EBX: 00000001 ECX: 00000001 EDX: fffff000
06:31:33: ESI: 0008773b EDI: 000000ef EBP: 00000001 ESP: c1421efc
06:31:33:  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
06:31:33: Process swapper (pid: 0, ti=c1420000 task=c142fe20 task.ti=c1420000)
06:31:33: Stack:
06:31:33:  c1014cc4 00000046 00000003 c14e8cc8 00000000 c1014d7a f6401fc0 c1046378
06:31:33:  00000000 000003e8 c104778c 00000000 000003e8 00000000 c1421f6c c102eb08
06:31:33:  ffffffcf c1003d1a f60d9440 c1421f9c c1040c67 ae767026 00002d6d 00000000
06:31:33: Call Trace:
06:31:33:  [<c1014cc4>] ? __setup_APIC_LVTT+0x20/0x95
06:31:33:  [<c1014d7a>] ? lapic_timer_setup+0x2b/0x6d
06:31:33:  [<c1046378>] ? clockevents_set_mode+0x12/0x3b
06:31:33:  [<c104778c>] ? tick_check_idle+0x10/0x82
06:31:33:  [<c102eb08>] ? irq_enter+0x34/0x54
06:31:33:  [<c1003d1a>] ? do_IRQ+0x1e/0x95
06:31:33:  [<c1040c67>] ? sched_clock_local+0x19/0x17c
06:31:33:  [<c1002c69>] ? common_interrupt+0x29/0x30
06:31:33:  [<c115b48b>] ? acpi_idle_enter_bm+0x22c/0x261
06:31:33:  [<c123289f>] ? cpuidle_idle_call+0x67/0x98
06:31:33:  [<c1001ae9>] ? cpu_idle+0x41/0x5c
06:31:33:  [<c14987ce>] ? start_kernel+0x276/0x27b
06:31:33:  [<c149839a>] ? unknown_bootoption+0x0/0x18c
06:31:33: Code: 15 b4 37 43 c1 b8 20 00 00 00 ff 92 a4 00 00 00 8b 15 b4 37 43 c1 ff 52 64 c3 8b 15 b4 37 43 c1 b8 30 00 00 00 ff 92 a4 00 00 00 <25> f0 00 00 00 c3 eb 02 f3 90 b8 00 03 00 00 8b 15 b4 37 43 c1 
06:31:33: Call Trace:
06:31:33:  [<c1014cc4>] ? __setup_APIC_LVTT+0x20/0x95
06:31:33:  [<c1014d7a>] ? lapic_timer_setup+0x2b/0x6d
06:31:33:  [<c1046378>] ? clockevents_set_mode+0x12/0x3b
06:31:33:  [<c104778c>] ? tick_check_idle+0x10/0x82
06:31:33:  [<c102eb08>] ? irq_enter+0x34/0x54
06:31:33:  [<c1003d1a>] ? do_IRQ+0x1e/0x95
06:31:33:  [<c1040c67>] ? sched_clock_local+0x19/0x17c
06:31:33:  [<c1002c69>] ? common_interrupt+0x29/0x30
06:31:33:  [<c115b48b>] ? acpi_idle_enter_bm+0x22c/0x261
06:31:33:  [<c123289f>] ? cpuidle_idle_call+0x67/0x98
06:31:33:  [<c1001ae9>] ? cpu_idle+0x41/0x5c
06:31:33:  [<c14987ce>] ? start_kernel+0x276/0x27b
06:31:33:  [<c149839a>] ? unknown_bootoption+0x0/0x18c
06:31:33: Pid: 0, comm: swapper Not tainted 2.6.38-rc4 #226
06:31:33: Call Trace:
06:31:33:  [<c10054b6>] ? show_trace+0xf/0x11
06:31:33:  [<c1015eff>] ? arch_trigger_all_cpu_backtrace_handler+0x57/0x73
06:31:33:  [<c104039f>] ? notifier_call_chain+0x23/0x46
06:31:33:  [<c10403e3>] ? atomic_notifier_call_chain+0x1a/0x1d
06:31:33:  [<c1040477>] ? notify_die+0x30/0x34
06:31:33:  [<c1003657>] ? do_nmi+0x68/0x267
06:31:33:  [<c13050d1>] ? nmi_stack_correct+0x28/0x2d
06:31:33:  [<c104007b>] ? copy_namespaces+0x1/0x7e
06:31:33:  [<c1014bd0>] ? lapic_is_integrated+0x11/0x17
06:31:33:  [<c1014cc4>] ? __setup_APIC_LVTT+0x20/0x95
06:31:33:  [<c1014d7a>] ? lapic_timer_setup+0x2b/0x6d
06:31:33:  [<c1046378>] ? clockevents_set_mode+0x12/0x3b
06:31:33:  [<c104778c>] ? tick_check_idle+0x10/0x82
06:31:33:  [<c102eb08>] ? irq_enter+0x34/0x54
06:31:33:  [<c1003d1a>] ? do_IRQ+0x1e/0x95
06:31:33:  [<c1040c67>] ? sched_clock_local+0x19/0x17c
06:31:33:  [<c1002c69>] ? common_interrupt+0x29/0x30
06:31:33:  [<c115b48b>] ? acpi_idle_enter_bm+0x22c/0x261
06:31:33:  [<c123289f>] ? cpuidle_idle_call+0x67/0x98
06:31:33:  [<c1001ae9>] ? cpu_idle+0x41/0x5c
06:31:33:  [<c14987ce>] ? start_kernel+0x276/0x27b
06:31:33:  [<c149839a>] ? unknown_bootoption+0x0/0x18c
06:32:38: BUG: soft lockup - CPU#1 stuck for 61s! [firefox-bin:3145]
06:32:38: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
06:32:38: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
06:32:38: 
06:32:38: Pid: 3145, comm: firefox-bin Not tainted 2.6.38-rc4 #226 0MG532/MXC061                          
06:32:38: EIP: 0060:[<c1110a8b>] EFLAGS: 00000297 CPU: 1
06:32:38: EIP is at div_u64_rem+0x1b/0x2a
06:32:38: EAX: 00000000 EBX: 00000e34 ECX: 00000000 EDX: 00000e34
06:32:38: ESI: 00000e72 EDI: f21a3d50 EBP: f21a3d30 ESP: f21a3d28
06:32:38:  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
06:32:38: Process firefox-bin (pid: 3145, ti=f21a2000 task=f613c6c0 task.ti=f21a2000)
06:32:38: Stack:
06:32:38:  00000e34 00000000 f21a3d60 c1110bcb f21a3d50 00000000 00000000 00000000
06:32:38:  0000007b ffff007b 000004c4 00000000 f21a3e24 00000002 f21a3dec c106ee41
06:32:38:  00000e72 00000000 00000000 c1492e00 0000c88d 00000020 00000021 c1493098
06:32:38: Call Trace:
06:32:38:  [<c1110bcb>] ? div64_u64+0x25/0xef
06:32:38:  [<c106ee41>] ? shrink_zone+0x264/0x4c3
06:32:38:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
06:32:38:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
06:32:38:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
06:32:38:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
06:32:38:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:32:38:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
06:32:38:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
06:32:38:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
06:32:38:  [<c1047272>] ? tick_program_event+0x19/0x1c
06:32:38:  [<c102e915>] ? irq_exit+0x41/0x64
06:32:38:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:32:38:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:32:38:  [<c1305022>] ? error_code+0x5a/0x60
06:32:38:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
06:32:38:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:32:38: Code: 00 00 00 31 d2 f7 f1 c1 e0 04 01 d0 c3 90 90 90 55 89 e5 56 89 ce 53 31 c9 89 c3 39 f2 72 08 89 d0 31 d2 f7 f6 89 c1 89 d8 f7 f6 <89> c3 8b 45 08 89 10 89 d8 89 ca 5b 5e c9 c3 55 89 c5 57 56 89 
06:32:38: Call Trace:
06:32:38:  [<c1110bcb>] ? div64_u64+0x25/0xef
06:32:38:  [<c106ee41>] ? shrink_zone+0x264/0x4c3
06:32:38:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
06:32:38:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
06:32:38:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
06:32:38:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
06:32:38:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:32:38:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
06:32:38:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
06:32:38:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
06:32:38:  [<c1047272>] ? tick_program_event+0x19/0x1c
06:32:38:  [<c102e915>] ? irq_exit+0x41/0x64
06:32:38:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:32:38:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:32:38:  [<c1305022>] ? error_code+0x5a/0x60
06:32:38:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
06:32:38:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:33:49: BUG: soft lockup - CPU#1 stuck for 63s! [firefox-bin:3145]
06:33:49: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
06:33:49: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
06:33:49: 
06:33:49: Pid: 3145, comm: firefox-bin Not tainted 2.6.38-rc4 #226 0MG532/MXC061                          
06:33:49: EIP: 0060:[<c1110a70>] EFLAGS: 00000246 CPU: 1
06:33:49: EIP is at div_u64_rem+0x0/0x2a
06:33:49: EAX: 00000e3b EBX: 00000e3b ECX: 00000e79 EDX: 00000000
06:33:49: ESI: 00000000 EDI: f21a3d50 EBP: f21a3d60 ESP: f21a3d34
06:33:49:  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
06:33:49: Process firefox-bin (pid: 3145, ti=f21a2000 task=f613c6c0 task.ti=f21a2000)
06:33:49: Stack:
06:33:49:  c1110bcb f21a3d50 00000000 00000000 00000e3b 0000007b ffff007b 00000e3b
06:33:49:  00000000 f21a3e24 00000003 f21a3dec c106ee41 00000e79 00000000 00000000
06:33:49:  c1492e00 0000c88d 00000020 00000021 c1493098 00000004 c14930a8 c1493040
06:33:49: Call Trace:
06:33:49:  [<c1110bcb>] ? div64_u64+0x25/0xef
06:33:49:  [<c106ee41>] ? shrink_zone+0x264/0x4c3
06:33:49:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
06:33:49:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
06:33:49:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
06:33:49:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
06:33:49:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:33:49:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
06:33:49:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
06:33:49:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
06:33:49:  [<c1047272>] ? tick_program_event+0x19/0x1c
06:33:49:  [<c102e915>] ? irq_exit+0x41/0x64
06:33:49:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:33:49:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:33:49:  [<c1305022>] ? error_code+0x5a/0x60
06:33:49:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
06:33:49:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:33:49: Code: 04 82 c3 31 c0 c3 90 88 c2 83 e0 0f c0 ea 04 0f b6 d2 6b d2 0a 8d 04 02 c3 b9 0a 00 00 00 31 d2 f7 f1 c1 e0 04 01 d0 c3 90 90 90 <55> 89 e5 56 89 ce 53 31 c9 89 c3 39 f2 72 08 89 d0 31 d2 f7 f6 
06:33:49: Call Trace:
06:33:49:  [<c1110bcb>] ? div64_u64+0x25/0xef
06:33:49:  [<c106ee41>] ? shrink_zone+0x264/0x4c3
06:33:49:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
06:33:49:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
06:33:49:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
06:33:49:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
06:33:49:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:33:49:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
06:33:49:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
06:33:49:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
06:33:49:  [<c1047272>] ? tick_program_event+0x19/0x1c
06:33:49:  [<c102e915>] ? irq_exit+0x41/0x64
06:33:49:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:33:49:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:33:49:  [<c1305022>] ? error_code+0x5a/0x60
06:33:49:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
06:33:49:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:34:33: INFO: rcu_sched_state detected stall on CPU 1 (t=126060 jiffies)
06:34:33: sending NMI to all CPUs:
06:34:33: NMI backtrace for cpu 1
06:34:33: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
06:34:33: 
06:34:33: Pid: 3145, comm: firefox-bin Not tainted 2.6.38-rc4 #226 0MG532/MXC061                          
06:34:33: EIP: 0060:[<c110f7b1>] EFLAGS: 00000006 CPU: 1
06:34:33: EIP is at __const_udelay+0xa/0x19
06:34:33: EAX: 01062560 EBX: 00000001 ECX: 00000800 EDX: 006597cf
06:34:33: ESI: c1436640 EDI: 00000001 EBP: c1436640 ESP: f21a3c3c
06:34:33:  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
06:34:33: Process firefox-bin (pid: 3145, ti=f21a2000 task=f613c6c0 task.ti=f21a2000)
06:34:33: Stack:
06:34:33:  c1015f6d c13a101a f6602e14 c105c85b c13a901b c13a9102 00000001 0001ec6c
06:34:33:  00000000 00000000 00000001 00000000 00000001 f21a3d2c c105caf0 f613c6c0
06:34:33:  c1032df0 f6602cc8 9d41f41d 00002d97 c1047627 f6602cc8 f6602c70 f6602cc8
06:34:33: Call Trace:
06:34:33:  [<c1015f6d>] ? arch_trigger_all_cpu_backtrace+0x52/0x65
06:34:33:  [<c105c85b>] ? __rcu_pending+0x6c/0x277
06:34:33:  [<c105caf0>] ? rcu_check_callbacks+0x8a/0xb6
06:34:33:  [<c1032df0>] ? update_process_times+0x2a/0x53
06:34:33:  [<c1047627>] ? tick_sched_timer+0x64/0x8d
06:34:33:  [<c103f332>] ? __run_hrtimer+0x6d/0xc3
06:34:33:  [<c103f595>] ? hrtimer_interrupt+0x10c/0x213
06:34:33:  [<c102e915>] ? irq_exit+0x41/0x64
06:34:33:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:34:33:  [<c10157cc>] ? smp_apic_timer_interrupt+0x6c/0x7d
06:34:33:  [<c1110a8b>] ? div_u64_rem+0x1b/0x2a
06:34:33:  [<c1304e02>] ? apic_timer_interrupt+0x2a/0x30
06:34:33:  [<c106edfc>] ? shrink_zone+0x21f/0x4c3
06:34:33:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
06:34:33:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
06:34:33:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
06:34:33:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
06:34:33:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:34:33:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
06:34:33:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
06:34:33:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
06:34:33:  [<c1047272>] ? tick_program_event+0x19/0x1c
06:34:33:  [<c102e915>] ? irq_exit+0x41/0x64
06:34:33:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:34:33:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:34:33:  [<c1305022>] ? error_code+0x5a/0x60
06:34:33:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
06:34:33:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:34:33: Code: 00 00 00 8d bc 27 00 00 00 00 48 75 fd 48 c3 c7 05 c0 14 44 c1 d3 f7 10 c1 c3 ff 15 c0 14 44 c1 c3 c1 e0 02 64 8b 15 9c b9 4e c1 <6b> d2 4b f7 e2 8d 42 01 ff 15 c0 14 44 c1 c3 69 c0 c7 10 00 00 
06:34:33: Call Trace:
06:34:33:  [<c1015f6d>] ? arch_trigger_all_cpu_backtrace+0x52/0x65
06:34:33:  [<c105c85b>] ? __rcu_pending+0x6c/0x277
06:34:33:  [<c105caf0>] ? rcu_check_callbacks+0x8a/0xb6
06:34:33:  [<c1032df0>] ? update_process_times+0x2a/0x53
06:34:33:  [<c1047627>] ? tick_sched_timer+0x64/0x8d
06:34:33:  [<c103f332>] ? __run_hrtimer+0x6d/0xc3
06:34:33:  [<c103f595>] ? hrtimer_interrupt+0x10c/0x213
06:34:33:  [<c102e915>] ? irq_exit+0x41/0x64
06:34:33:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:34:33:  [<c10157cc>] ? smp_apic_timer_interrupt+0x6c/0x7d
06:34:33:  [<c1110a8b>] ? div_u64_rem+0x1b/0x2a
06:34:33:  [<c1304e02>] ? apic_timer_interrupt+0x2a/0x30
06:34:33:  [<c106edfc>] ? shrink_zone+0x21f/0x4c3
06:34:33:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
06:34:33:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
06:34:33:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
06:34:33:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
06:34:33:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:34:33:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
06:34:33:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
06:34:33:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
06:34:33:  [<c1047272>] ? tick_program_event+0x19/0x1c
06:34:33:  [<c102e915>] ? irq_exit+0x41/0x64
06:34:33:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:34:33:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:34:33:  [<c1305022>] ? error_code+0x5a/0x60
06:34:33:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
06:34:33:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:34:33: Pid: 3145, comm: firefox-bin Not tainted 2.6.38-rc4 #226
06:34:33: Call Trace:
06:34:33:  [<c10054b6>] ? show_trace+0xf/0x11
06:34:33:  [<c1015eff>] ? arch_trigger_all_cpu_backtrace_handler+0x57/0x73
06:34:33:  [<c104039f>] ? notifier_call_chain+0x23/0x46
06:34:33:  [<c10403e3>] ? atomic_notifier_call_chain+0x1a/0x1d
06:34:33:  [<c1040477>] ? notify_die+0x30/0x34
06:34:33:  [<c1003657>] ? do_nmi+0x68/0x267
06:34:33:  [<c13050d1>] ? nmi_stack_correct+0x28/0x2d
06:34:33:  [<c110f7b1>] ? __const_udelay+0xa/0x19
06:34:33:  [<c1015f6d>] ? arch_trigger_all_cpu_backtrace+0x52/0x65
06:34:33:  [<c105c85b>] ? __rcu_pending+0x6c/0x277
06:34:33:  [<c105caf0>] ? rcu_check_callbacks+0x8a/0xb6
06:34:33:  [<c1032df0>] ? update_process_times+0x2a/0x53
06:34:33:  [<c1047627>] ? tick_sched_timer+0x64/0x8d
06:34:33:  [<c103f332>] ? __run_hrtimer+0x6d/0xc3
06:34:33:  [<c103f595>] ? hrtimer_interrupt+0x10c/0x213
06:34:33:  [<c102e915>] ? irq_exit+0x41/0x64
06:34:33:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:34:33:  [<c10157cc>] ? smp_apic_timer_interrupt+0x6c/0x7d
06:34:33:  [<c1110a8b>] ? div_u64_rem+0x1b/0x2a
06:34:33:  [<c1304e02>] ? apic_timer_interrupt+0x2a/0x30
06:34:33:  [<c106edfc>] ? shrink_zone+0x21f/0x4c3
06:34:33:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
06:34:33:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
06:34:33:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
06:34:33:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
06:34:33:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:34:33:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
06:34:33:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
06:34:33:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
06:34:33:  [<c1047272>] ? tick_program_event+0x19/0x1c
06:34:33:  [<c102e915>] ? irq_exit+0x41/0x64
06:34:33:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:34:33:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:34:33:  [<c1305022>] ? error_code+0x5a/0x60
06:34:33:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
06:34:33:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:34:33: NMI backtrace for cpu 0
06:34:33: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
06:34:33: 
06:34:33: Pid: 0, comm: swapper Not tainted 2.6.38-rc4 #226 0MG532/MXC061                          
06:34:33: EIP: 0060:[<c1019322>] EFLAGS: 00000057 CPU: 0
06:34:33: EIP is at read_hpet+0xe/0x12
06:34:33: EAX: 27f06909 EBX: 010e75a8 ECX: fffff000 EDX: 00000000
06:34:33: ESI: c1433a80 EDI: 476f8d15 EBP: c1421efc ESP: c1421efc
06:34:33:  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
06:34:33: Process swapper (pid: 0, ti=c1420000 task=c142fe20 task.ti=c1420000)
06:34:33: Stack:
06:34:33:  00000000 c1042852 00000003 c14e8cc8 0000c3d0 00000000 00000000 000003e8
06:34:33:  f6402cc8 00000000 c10477a4 00000000 000003e8 00000000 c1421f6c c102eb08
06:34:33:  ffffffcf c1003d1a f60d9440 c1421f9c c1040c67 9d421344 00002d97 00000000
06:34:33: Call Trace:
06:34:33:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:34:33:  [<c10477a4>] ? tick_check_idle+0x28/0x82
06:34:33:  [<c102eb08>] ? irq_enter+0x34/0x54
06:34:33:  [<c1003d1a>] ? do_IRQ+0x1e/0x95
06:34:33:  [<c1040c67>] ? sched_clock_local+0x19/0x17c
06:34:33:  [<c1002c69>] ? common_interrupt+0x29/0x30
06:34:33:  [<c115b48b>] ? acpi_idle_enter_bm+0x22c/0x261
06:34:33:  [<c123289f>] ? cpuidle_idle_call+0x67/0x98
06:34:33:  [<c1001ae9>] ? cpu_idle+0x41/0x5c
06:34:33:  [<c14987ce>] ? start_kernel+0x276/0x27b
06:34:33:  [<c149839a>] ? unknown_bootoption+0x0/0x18c
06:34:33: Code: 4f c1 8b 92 f0 00 00 00 29 d0 89 c2 31 c0 81 fa 80 00 00 00 ba c2 ff ff ff 0f 4c c2 c3 55 a1 34 e7 4f c1 89 e5 8b 80 f0 00 00 00 <31> d2 c9 c3 83 3d 38 e7 4f c1 00 75 37 83 3d 20 e7 4f c1 00 74 
06:34:33: Call Trace:
06:34:33:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:34:33:  [<c10477a4>] ? tick_check_idle+0x28/0x82
06:34:33:  [<c102eb08>] ? irq_enter+0x34/0x54
06:34:33:  [<c1003d1a>] ? do_IRQ+0x1e/0x95
06:34:33:  [<c1040c67>] ? sched_clock_local+0x19/0x17c
06:34:33:  [<c1002c69>] ? common_interrupt+0x29/0x30
06:34:33:  [<c115b48b>] ? acpi_idle_enter_bm+0x22c/0x261
06:34:33:  [<c123289f>] ? cpuidle_idle_call+0x67/0x98
06:34:33:  [<c1001ae9>] ? cpu_idle+0x41/0x5c
06:34:33:  [<c14987ce>] ? start_kernel+0x276/0x27b
06:34:33:  [<c149839a>] ? unknown_bootoption+0x0/0x18c
06:34:33: Pid: 0, comm: swapper Not tainted 2.6.38-rc4 #226
06:34:33: Call Trace:
06:34:33:  [<c10054b6>] ? show_trace+0xf/0x11
06:34:33:  [<c1015eff>] ? arch_trigger_all_cpu_backtrace_handler+0x57/0x73
06:34:33:  [<c104039f>] ? notifier_call_chain+0x23/0x46
06:34:33:  [<c10403e3>] ? atomic_notifier_call_chain+0x1a/0x1d
06:34:33:  [<c1040477>] ? notify_die+0x30/0x34
06:34:33:  [<c1003657>] ? do_nmi+0x68/0x267
06:34:33:  [<c13050d1>] ? nmi_stack_correct+0x28/0x2d
06:34:33:  [<c104007b>] ? copy_namespaces+0x1/0x7e
06:34:33:  [<c1019322>] ? read_hpet+0xe/0x12
06:34:33:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:34:33:  [<c10477a4>] ? tick_check_idle+0x28/0x82
06:34:33:  [<c102eb08>] ? irq_enter+0x34/0x54
06:34:33:  [<c1003d1a>] ? do_IRQ+0x1e/0x95
06:34:33:  [<c1040c67>] ? sched_clock_local+0x19/0x17c
06:34:33:  [<c1002c69>] ? common_interrupt+0x29/0x30
06:34:33:  [<c115b48b>] ? acpi_idle_enter_bm+0x22c/0x261
06:34:33:  [<c123289f>] ? cpuidle_idle_call+0x67/0x98
06:34:33:  [<c1001ae9>] ? cpu_idle+0x41/0x5c
06:34:33:  [<c14987ce>] ? start_kernel+0x276/0x27b
06:34:33:  [<c149839a>] ? unknown_bootoption+0x0/0x18c
06:35:42: BUG: soft lockup - CPU#1 stuck for 63s! [firefox-bin:3145]
06:35:42: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
06:35:42: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
06:35:42: 
06:35:42: Pid: 3145, comm: firefox-bin Not tainted 2.6.38-rc4 #226 0MG532/MXC061                          
06:35:42: EIP: 0060:[<c106ee41>] EFLAGS: 00000292 CPU: 1
06:35:42: EIP is at shrink_zone+0x264/0x4c3
06:35:42: EAX: 00000000 EBX: 00000000 ECX: 00000000 EDX: 00000000
06:35:42: ESI: f21a3e24 EDI: 00000003 EBP: f21a3dec ESP: f21a3d68
06:35:42:  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
06:35:42: Process firefox-bin (pid: 3145, ti=f21a2000 task=f613c6c0 task.ti=f21a2000)
06:35:42: Stack:
06:35:42:  00000e86 00000000 00000000 c1492e00 0000c88d 00000020 00000021 c1493098
06:35:42:  00000004 c14930a8 c1493040 c14930a4 c14930a0 c149309c 0000000b 00000000
06:35:42:  00000e86 00000000 00000001 00000000 00000000 00000000 00000000 00000040
06:35:42: Call Trace:
06:35:42:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
06:35:42:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
06:35:42:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
06:35:42:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
06:35:42:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:35:42:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
06:35:42:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
06:35:42:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
06:35:42:  [<c1047272>] ? tick_program_event+0x19/0x1c
06:35:42:  [<c102e915>] ? irq_exit+0x41/0x64
06:35:42:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:35:42:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:35:42:  [<c1305022>] ? error_code+0x5a/0x60
06:35:42:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
06:35:42:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:35:42: Code: 24 38 19 d2 8b 5c 24 44 d3 e8 83 e2 08 8b 4c 14 64 0f af c8 f7 64 14 60 89 5c 24 04 8d 14 11 8b 4c 24 40 89 0c 24 e8 65 1d 0a 00 <81> c7 94 00 00 00 8b 5c 24 0c 03 44 bb 2c 89 44 bb 2c 83 f8 1f 
06:35:42: Call Trace:
06:35:42:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
06:35:42:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
06:35:42:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
06:35:42:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
06:35:42:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:35:42:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
06:35:42:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
06:35:42:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
06:35:42:  [<c1047272>] ? tick_program_event+0x19/0x1c
06:35:42:  [<c102e915>] ? irq_exit+0x41/0x64
06:35:42:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:35:42:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:35:42:  [<c1305022>] ? error_code+0x5a/0x60
06:35:42:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
06:35:42:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:36:50: BUG: soft lockup - CPU#1 stuck for 61s! [firefox-bin:3145]
06:36:50: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
06:36:50: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
06:36:50: 
06:36:50: Pid: 3145, comm: firefox-bin Not tainted 2.6.38-rc4 #226 0MG532/MXC061                          
06:36:50: EIP: 0060:[<c106ee70>] EFLAGS: 00000246 CPU: 1
06:36:50: EIP is at shrink_zone+0x293/0x4c3
06:36:50: EAX: 00000000 EBX: c1492e00 ECX: fffffffe EDX: 00000000
06:36:50: ESI: f21a3e24 EDI: 00000094 EBP: f21a3dec ESP: f21a3d68
06:36:50:  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
06:36:50: Process firefox-bin (pid: 3145, ti=f21a2000 task=f613c6c0 task.ti=f21a2000)
06:36:50: Stack:
06:36:50:  00000e93 00000000 00000000 c1492e00 0000c88d 00000020 00000021 c1493098
06:36:50:  00000001 c14930a8 c1493040 c14930a4 c14930a0 c149309c 0000000b 00000000
06:36:50:  00000e93 00000000 fffffffe 00000000 00000000 00000000 00000000 00000040
06:36:50: Call Trace:
06:36:50:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
06:36:50:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
06:36:50:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
06:36:50:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
06:36:50:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:36:50:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
06:36:50:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
06:36:50:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
06:36:50:  [<c1047272>] ? tick_program_event+0x19/0x1c
06:36:50:  [<c102e915>] ? irq_exit+0x41/0x64
06:36:50:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:36:50:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:36:50:  [<c1305022>] ? error_code+0x5a/0x60
06:36:50:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
06:36:50:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:36:50: Code: 00 00 8b 5c 24 0c 03 44 bb 2c 89 44 bb 2c 83 f8 1f 77 04 31 c0 eb 0c 8b 54 24 0c c7 44 ba 2c 00 00 00 00 8b 4c 24 48 89 44 8c 54 <41> 89 4c 24 48 83 f9 02 75 15 8b 5c 24 0c c7 44 24 48 00 00 00 
06:36:50: Call Trace:
06:36:50:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
06:36:50:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
06:36:50:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
06:36:50:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
06:36:50:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:36:50:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
06:36:50:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
06:36:50:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
06:36:50:  [<c1047272>] ? tick_program_event+0x19/0x1c
06:36:50:  [<c102e915>] ? irq_exit+0x41/0x64
06:36:50:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:36:50:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:36:50:  [<c1305022>] ? error_code+0x5a/0x60
06:36:50:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
06:36:50:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:37:33: INFO: rcu_sched_state detected stall on CPU 1 (t=180090 jiffies)
06:37:33: sending NMI to all CPUs:
06:37:33: NMI backtrace for cpu 1
06:37:33: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
06:37:33: 
06:37:33: Pid: 3145, comm: firefox-bin Not tainted 2.6.38-rc4 #226 0MG532/MXC061                          
06:37:33: EIP: 0060:[<c110f7eb>] EFLAGS: 00000086 CPU: 1
06:37:33: EIP is at delay_tsc+0x18/0x55
06:37:33: EAX: 1c3029c4 EBX: 00000001 ECX: 00000001 EDX: 00001bf2
06:37:33: ESI: c1436640 EDI: 00000001 EBP: 001e7a67 ESP: f21a3c14
06:37:33:  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
06:37:33: Process firefox-bin (pid: 3145, ti=f21a2000 task=f613c6c0 task.ti=f21a2000)
06:37:33: Stack:
06:37:33:  00000000 c1436640 00000001 c1436640 00000001 c1436640 c110f7bf c1015f6d
06:37:33:  c13a101a f6602e14 c105c85b c13a901b c13a9102 00000001 0002bf7a 00000000
06:37:33:  00000000 00000001 00000000 00000001 f21a3d20 c105caf0 f613c6c0 c1032df0
06:37:33: Call Trace:
06:37:33:  [<c110f7bf>] ? __const_udelay+0x18/0x19
06:37:33:  [<c1015f6d>] ? arch_trigger_all_cpu_backtrace+0x52/0x65
06:37:33:  [<c105c85b>] ? __rcu_pending+0x6c/0x277
06:37:33:  [<c105caf0>] ? rcu_check_callbacks+0x8a/0xb6
06:37:33:  [<c1032df0>] ? update_process_times+0x2a/0x53
06:37:33:  [<c1047627>] ? tick_sched_timer+0x64/0x8d
06:37:33:  [<c103f332>] ? __run_hrtimer+0x6d/0xc3
06:37:33:  [<c103f595>] ? hrtimer_interrupt+0x10c/0x213
06:37:33:  [<c103f5e5>] ? hrtimer_interrupt+0x15c/0x213
06:37:33:  [<c10157cc>] ? smp_apic_timer_interrupt+0x6c/0x7d
06:37:33:  [<c102e915>] ? irq_exit+0x41/0x64
06:37:33:  [<c1304e02>] ? apic_timer_interrupt+0x2a/0x30
06:37:33:  [<c1110baa>] ? div64_u64+0x4/0xef
06:37:33:  [<c106ee41>] ? shrink_zone+0x264/0x4c3
06:37:33:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
06:37:33:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
06:37:33:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
06:37:33:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
06:37:33:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:37:33:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
06:37:33:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
06:37:33:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
06:37:33:  [<c1047272>] ? tick_program_event+0x19/0x1c
06:37:33:  [<c102e915>] ? irq_exit+0x41/0x64
06:37:33:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:37:33:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:37:33:  [<c1305022>] ? error_code+0x5a/0x60
06:37:33:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
06:37:33:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:37:33: Code: 69 c0 c7 10 00 00 e9 dc ff ff ff 8d 04 80 e9 d4 ff ff ff 55 89 c5 57 56 53 83 ec 08 64 8b 0d b8 7f 4e c1 8d 76 00 0f ae e8 0f 31 <89> c7 8d 76 00 0f ae e8 0f 31 89 c3 89 c6 29 fb 39 eb 73 21 f3 
06:37:33: Call Trace:
06:37:33:  [<c110f7bf>] ? __const_udelay+0x18/0x19
06:37:33:  [<c1015f6d>] ? arch_trigger_all_cpu_backtrace+0x52/0x65
06:37:33:  [<c105c85b>] ? __rcu_pending+0x6c/0x277
06:37:33:  [<c105caf0>] ? rcu_check_callbacks+0x8a/0xb6
06:37:33:  [<c1032df0>] ? update_process_times+0x2a/0x53
06:37:33:  [<c1047627>] ? tick_sched_timer+0x64/0x8d
06:37:33:  [<c103f332>] ? __run_hrtimer+0x6d/0xc3
06:37:33:  [<c103f595>] ? hrtimer_interrupt+0x10c/0x213
06:37:33:  [<c103f5e5>] ? hrtimer_interrupt+0x15c/0x213
06:37:33:  [<c10157cc>] ? smp_apic_timer_interrupt+0x6c/0x7d
06:37:33:  [<c102e915>] ? irq_exit+0x41/0x64
06:37:33:  [<c1304e02>] ? apic_timer_interrupt+0x2a/0x30
06:37:33:  [<c1110baa>] ? div64_u64+0x4/0xef
06:37:33:  [<c106ee41>] ? shrink_zone+0x264/0x4c3
06:37:33:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
06:37:33:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
06:37:33:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
06:37:33:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
06:37:33:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:37:33:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
06:37:33:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
06:37:33:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
06:37:33:  [<c1047272>] ? tick_program_event+0x19/0x1c
06:37:33:  [<c102e915>] ? irq_exit+0x41/0x64
06:37:33:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:37:33:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:37:33:  [<c1305022>] ? error_code+0x5a/0x60
06:37:33:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
06:37:33:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:37:33: Pid: 3145, comm: firefox-bin Not tainted 2.6.38-rc4 #226
06:37:33: Call Trace:
06:37:33:  [<c10054b6>] ? show_trace+0xf/0x11
06:37:33:  [<c1015eff>] ? arch_trigger_all_cpu_backtrace_handler+0x57/0x73
06:37:33:  [<c104039f>] ? notifier_call_chain+0x23/0x46
06:37:33:  [<c10403e3>] ? atomic_notifier_call_chain+0x1a/0x1d
06:37:33:  [<c1040477>] ? notify_die+0x30/0x34
06:37:33:  [<c1003657>] ? do_nmi+0x68/0x267
06:37:33:  [<c13050d1>] ? nmi_stack_correct+0x28/0x2d
06:37:33:  [<c10100d8>] ? do_machine_check+0x2c0/0x6d2
06:37:33:  [<c110f7eb>] ? delay_tsc+0x18/0x55
06:37:33:  [<c110f7bf>] ? __const_udelay+0x18/0x19
06:37:33:  [<c1015f6d>] ? arch_trigger_all_cpu_backtrace+0x52/0x65
06:37:33:  [<c105c85b>] ? __rcu_pending+0x6c/0x277
06:37:33:  [<c105caf0>] ? rcu_check_callbacks+0x8a/0xb6
06:37:33:  [<c1032df0>] ? update_process_times+0x2a/0x53
06:37:33:  [<c1047627>] ? tick_sched_timer+0x64/0x8d
06:37:33:  [<c103f332>] ? __run_hrtimer+0x6d/0xc3
06:37:33:  [<c103f595>] ? hrtimer_interrupt+0x10c/0x213
06:37:33:  [<c103f5e5>] ? hrtimer_interrupt+0x15c/0x213
06:37:33:  [<c10157cc>] ? smp_apic_timer_interrupt+0x6c/0x7d
06:37:33:  [<c102e915>] ? irq_exit+0x41/0x64
06:37:33:  [<c1304e02>] ? apic_timer_interrupt+0x2a/0x30
06:37:33:  [<c1110baa>] ? div64_u64+0x4/0xef
06:37:33:  [<c106ee41>] ? shrink_zone+0x264/0x4c3
06:37:33:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
06:37:33:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
06:37:33:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
06:37:33:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
06:37:33:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:37:33:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
06:37:33:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
06:37:33:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
06:37:33:  [<c1047272>] ? tick_program_event+0x19/0x1c
06:37:33:  [<c102e915>] ? irq_exit+0x41/0x64
06:37:33:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:37:33:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:37:33:  [<c1305022>] ? error_code+0x5a/0x60
06:37:33:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
06:37:33:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:37:33: NMI backtrace for cpu 0
06:37:33: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
06:37:33: 
06:37:33: Pid: 0, comm: swapper Not tainted 2.6.38-rc4 #226 0MG532/MXC061                          
06:37:33: EIP: 0060:[<c1019322>] EFLAGS: 00000057 CPU: 0
06:37:33: EIP is at read_hpet+0xe/0x12
06:37:33: EAX: c1a4c2df EBX: 01101bc4 ECX: fffff000 EDX: 00000000
06:37:33: ESI: c1433a80 EDI: 4d696f16 EBP: c1421efc ESP: c1421efc
06:37:33:  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
06:37:33: Process swapper (pid: 0, ti=c1420000 task=c142fe20 task.ti=c1420000)
06:37:33: Stack:
06:37:33:  00000000 c1042852 00000003 c14e8cc8 0000c484 00000000 00000000 000003e8
06:37:33:  f6402cc8 00000000 c10477a4 00000000 000003e8 00000000 c1421f6c c102eb08
06:37:33:  ffffffcf c1003d1a f60d9440 c1421f9c c1040c67 8c0db703 00002dc1 00000000
06:37:33: Call Trace:
06:37:33:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:37:33:  [<c10477a4>] ? tick_check_idle+0x28/0x82
06:37:33:  [<c102eb08>] ? irq_enter+0x34/0x54
06:37:33:  [<c1003d1a>] ? do_IRQ+0x1e/0x95
06:37:33:  [<c1040c67>] ? sched_clock_local+0x19/0x17c
06:37:33:  [<c1002c69>] ? common_interrupt+0x29/0x30
06:37:33:  [<c115b48b>] ? acpi_idle_enter_bm+0x22c/0x261
06:37:33:  [<c123289f>] ? cpuidle_idle_call+0x67/0x98
06:37:33:  [<c1001ae9>] ? cpu_idle+0x41/0x5c
06:37:33:  [<c14987ce>] ? start_kernel+0x276/0x27b
06:37:33:  [<c149839a>] ? unknown_bootoption+0x0/0x18c
06:37:33: Code: 4f c1 8b 92 f0 00 00 00 29 d0 89 c2 31 c0 81 fa 80 00 00 00 ba c2 ff ff ff 0f 4c c2 c3 55 a1 34 e7 4f c1 89 e5 8b 80 f0 00 00 00 <31> d2 c9 c3 83 3d 38 e7 4f c1 00 75 37 83 3d 20 e7 4f c1 00 74 
06:37:33: Call Trace:
06:37:33:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:37:33:  [<c10477a4>] ? tick_check_idle+0x28/0x82
06:37:33:  [<c102eb08>] ? irq_enter+0x34/0x54
06:37:33:  [<c1003d1a>] ? do_IRQ+0x1e/0x95
06:37:33:  [<c1040c67>] ? sched_clock_local+0x19/0x17c
06:37:33:  [<c1002c69>] ? common_interrupt+0x29/0x30
06:37:33:  [<c115b48b>] ? acpi_idle_enter_bm+0x22c/0x261
06:37:33:  [<c123289f>] ? cpuidle_idle_call+0x67/0x98
06:37:33:  [<c1001ae9>] ? cpu_idle+0x41/0x5c
06:37:33:  [<c14987ce>] ? start_kernel+0x276/0x27b
06:37:33:  [<c149839a>] ? unknown_bootoption+0x0/0x18c
06:37:33: Pid: 0, comm: swapper Not tainted 2.6.38-rc4 #226
06:37:33: Call Trace:
06:37:33:  [<c10054b6>] ? show_trace+0xf/0x11
06:37:33:  [<c1015eff>] ? arch_trigger_all_cpu_backtrace_handler+0x57/0x73
06:37:33:  [<c104039f>] ? notifier_call_chain+0x23/0x46
06:37:33:  [<c10403e3>] ? atomic_notifier_call_chain+0x1a/0x1d
06:37:33:  [<c1040477>] ? notify_die+0x30/0x34
06:37:33:  [<c1003657>] ? do_nmi+0x68/0x267
06:37:33:  [<c13050d1>] ? nmi_stack_correct+0x28/0x2d
06:37:33:  [<c104007b>] ? copy_namespaces+0x1/0x7e
06:37:33:  [<c1019322>] ? read_hpet+0xe/0x12
06:37:33:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:37:33:  [<c10477a4>] ? tick_check_idle+0x28/0x82
06:37:33:  [<c102eb08>] ? irq_enter+0x34/0x54
06:37:33:  [<c1003d1a>] ? do_IRQ+0x1e/0x95
06:37:33:  [<c1040c67>] ? sched_clock_local+0x19/0x17c
06:37:33:  [<c1002c69>] ? common_interrupt+0x29/0x30
06:37:33:  [<c115b48b>] ? acpi_idle_enter_bm+0x22c/0x261
06:37:33:  [<c123289f>] ? cpuidle_idle_call+0x67/0x98
06:37:33:  [<c1001ae9>] ? cpu_idle+0x41/0x5c
06:37:33:  [<c14987ce>] ? start_kernel+0x276/0x27b
06:37:33:  [<c149839a>] ? unknown_bootoption+0x0/0x18c
06:38:42: BUG: soft lockup - CPU#1 stuck for 63s! [firefox-bin:3145]
06:38:42: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
06:38:42: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
06:38:42: 
06:38:42: Pid: 3145, comm: firefox-bin Not tainted 2.6.38-rc4 #226 0MG532/MXC061                          
06:38:42: EIP: 0060:[<c1110a7b>] EFLAGS: 00000246 CPU: 1
06:38:42: EIP is at div_u64_rem+0xb/0x2a
06:38:42: EAX: 000005f5 EBX: 000005f5 ECX: 00000000 EDX: 00000000
06:38:42: ESI: 00000ea0 EDI: f21a3d50 EBP: f21a3d30 ESP: f21a3d28
06:38:42:  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
06:38:42: Process firefox-bin (pid: 3145, ti=f21a2000 task=f613c6c0 task.ti=f21a2000)
06:38:42: Stack:
06:38:42:  000005f5 00000000 f21a3d60 c1110bcb f21a3d50 00000000 00000000 00000e62
06:38:42:  0000007b ffff007b 00000e62 00000000 f21a3e24 00000000 f21a3dec c106ee41
06:38:42:  00000ea0 00000000 00000000 c1492e00 0000c88d 00000020 00000021 c1493098
06:38:42: Call Trace:
06:38:42:  [<c1110bcb>] ? div64_u64+0x25/0xef
06:38:42:  [<c106ee41>] ? shrink_zone+0x264/0x4c3
06:38:42:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
06:38:42:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
06:38:42:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
06:38:42:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
06:38:42:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:38:42:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
06:38:42:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
06:38:42:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
06:38:42:  [<c1047272>] ? tick_program_event+0x19/0x1c
06:38:42:  [<c102e915>] ? irq_exit+0x41/0x64
06:38:42:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:38:42:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:38:42:  [<c1305022>] ? error_code+0x5a/0x60
06:38:42:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
06:38:42:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:38:42: Code: 0f c0 ea 04 0f b6 d2 6b d2 0a 8d 04 02 c3 b9 0a 00 00 00 31 d2 f7 f1 c1 e0 04 01 d0 c3 90 90 90 55 89 e5 56 89 ce 53 31 c9 89 c3 <39> f2 72 08 89 d0 31 d2 f7 f6 89 c1 89 d8 f7 f6 89 c3 8b 45 08 
06:38:42: Call Trace:
06:38:42:  [<c1110bcb>] ? div64_u64+0x25/0xef
06:38:42:  [<c106ee41>] ? shrink_zone+0x264/0x4c3
06:38:42:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
06:38:42:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
06:38:42:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
06:38:42:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
06:38:42:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:38:42:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
06:38:42:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
06:38:42:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
06:38:42:  [<c1047272>] ? tick_program_event+0x19/0x1c
06:38:42:  [<c102e915>] ? irq_exit+0x41/0x64
06:38:42:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:38:42:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:38:42:  [<c1305022>] ? error_code+0x5a/0x60
06:38:42:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
06:38:42:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:39:54: BUG: soft lockup - CPU#1 stuck for 63s! [firefox-bin:3145]
06:39:54: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
06:39:54: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
06:39:54: 
06:39:54: Pid: 3145, comm: firefox-bin Not tainted 2.6.38-rc4 #226 0MG532/MXC061                          
06:39:54: EIP: 0060:[<c106ee68>] EFLAGS: 00000246 CPU: 1
06:39:54: EIP is at shrink_zone+0x28b/0x4c3
06:39:54: EAX: 00000000 EBX: c1492e00 ECX: 00000000 EDX: 00000000
06:39:54: ESI: f21a3e24 EDI: 00000097 EBP: f21a3dec ESP: f21a3d68
06:39:54:  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
06:39:54: Process firefox-bin (pid: 3145, ti=f21a2000 task=f613c6c0 task.ti=f21a2000)
06:39:54: Stack:
06:39:54:  00000ead 00000000 00000000 c1492e00 0000c88d 00000020 00000021 c1493098
06:39:54:  00000004 c14930a8 c1493040 c14930a4 c14930a0 c149309c 0000000b 00000000
06:39:54:  00000ead 00000000 00000001 00000000 00000000 00000000 00000000 00000040
06:39:54: Call Trace:
06:39:54:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
06:39:54:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
06:39:54:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
06:39:54:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
06:39:54:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:39:54:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
06:39:54:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
06:39:54:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
06:39:54:  [<c1047272>] ? tick_program_event+0x19/0x1c
06:39:54:  [<c102e915>] ? irq_exit+0x41/0x64
06:39:54:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:39:54:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:39:54:  [<c1305022>] ? error_code+0x5a/0x60
06:39:54:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
06:39:54:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:39:54: Code: 65 1d 0a 00 81 c7 94 00 00 00 8b 5c 24 0c 03 44 bb 2c 89 44 bb 2c 83 f8 1f 77 04 31 c0 eb 0c 8b 54 24 0c c7 44 ba 2c 00 00 00 00 <8b> 4c 24 48 89 44 8c 54 41 89 4c 24 48 83 f9 02 75 15 8b 5c 24 
06:39:54: Call Trace:
06:39:54:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
06:39:54:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
06:39:54:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
06:39:54:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
06:39:54:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:39:54:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
06:39:54:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
06:39:54:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
06:39:54:  [<c1047272>] ? tick_program_event+0x19/0x1c
06:39:54:  [<c102e915>] ? irq_exit+0x41/0x64
06:39:54:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:39:54:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:39:54:  [<c1305022>] ? error_code+0x5a/0x60
06:39:54:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
06:39:54:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:40:33: INFO: rcu_sched_state detected stall on CPU 1 (t=234120 jiffies)
06:40:33: sending NMI to all CPUs:
06:40:33: NMI backtrace for cpu 1
06:40:33: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
06:40:33: 
06:40:33: Pid: 3145, comm: firefox-bin Not tainted 2.6.38-rc4 #226 0MG532/MXC061                          
06:40:33: EIP: 0060:[<c110f7eb>] EFLAGS: 00000082 CPU: 1
06:40:33: EIP is at delay_tsc+0x18/0x55
06:40:33: EAX: dd4c4808 EBX: 00000001 ECX: 00000001 EDX: 00001c45
06:40:33: ESI: c1436640 EDI: 00000001 EBP: 001e7a67 ESP: f21a3c20
06:40:33:  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
06:40:33: Process firefox-bin (pid: 3145, ti=f21a2000 task=f613c6c0 task.ti=f21a2000)
06:40:33: Stack:
06:40:33:  00000000 c1436640 00000001 c1436640 00000001 c1436640 c110f7bf c1015f6d
06:40:33:  c13a101a f6602e14 c105c85b c13a901b c13a9102 00000001 00039288 00000000
06:40:33:  00000000 00000001 00000000 00000001 f21a3d2c c105caf0 f613c6c0 c1032df0
06:40:33: Call Trace:
06:40:33:  [<c110f7bf>] ? __const_udelay+0x18/0x19
06:40:33:  [<c1015f6d>] ? arch_trigger_all_cpu_backtrace+0x52/0x65
06:40:33:  [<c105c85b>] ? __rcu_pending+0x6c/0x277
06:40:33:  [<c105caf0>] ? rcu_check_callbacks+0x8a/0xb6
06:40:33:  [<c1032df0>] ? update_process_times+0x2a/0x53
06:40:33:  [<c1047627>] ? tick_sched_timer+0x64/0x8d
06:40:33:  [<c103f332>] ? __run_hrtimer+0x6d/0xc3
06:40:33:  [<c103f595>] ? hrtimer_interrupt+0x10c/0x213
06:40:33:  [<c10157cc>] ? smp_apic_timer_interrupt+0x6c/0x7d
06:40:33:  [<c13000d8>] ? native_cpu_up+0x147/0x5bb
06:40:33:  [<c1304e02>] ? apic_timer_interrupt+0x2a/0x30
06:40:33:  [<c106eda8>] ? shrink_zone+0x1cb/0x4c3
06:40:33:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
06:40:33:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
06:40:33:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
06:40:33:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
06:40:33:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:40:33:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
06:40:33:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
06:40:33:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
06:40:33:  [<c1047272>] ? tick_program_event+0x19/0x1c
06:40:33:  [<c102e915>] ? irq_exit+0x41/0x64
06:40:33:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:40:33:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:40:33:  [<c1305022>] ? error_code+0x5a/0x60
06:40:33:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
06:40:33:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:40:33: Code: 69 c0 c7 10 00 00 e9 dc ff ff ff 8d 04 80 e9 d4 ff ff ff 55 89 c5 57 56 53 83 ec 08 64 8b 0d b8 7f 4e c1 8d 76 00 0f ae e8 0f 31 <89> c7 8d 76 00 0f ae e8 0f 31 89 c3 89 c6 29 fb 39 eb 73 21 f3 
06:40:33: Call Trace:
06:40:33:  [<c110f7bf>] ? __const_udelay+0x18/0x19
06:40:33:  [<c1015f6d>] ? arch_trigger_all_cpu_backtrace+0x52/0x65
06:40:33:  [<c105c85b>] ? __rcu_pending+0x6c/0x277
06:40:33:  [<c105caf0>] ? rcu_check_callbacks+0x8a/0xb6
06:40:33:  [<c1032df0>] ? update_process_times+0x2a/0x53
06:40:33:  [<c1047627>] ? tick_sched_timer+0x64/0x8d
06:40:33:  [<c103f332>] ? __run_hrtimer+0x6d/0xc3
06:40:33:  [<c103f595>] ? hrtimer_interrupt+0x10c/0x213
06:40:33:  [<c10157cc>] ? smp_apic_timer_interrupt+0x6c/0x7d
06:40:33:  [<c13000d8>] ? native_cpu_up+0x147/0x5bb
06:40:33:  [<c1304e02>] ? apic_timer_interrupt+0x2a/0x30
06:40:33:  [<c106eda8>] ? shrink_zone+0x1cb/0x4c3
06:40:33:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
06:40:33:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
06:40:33:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
06:40:33:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
06:40:33:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:40:33:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
06:40:33:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
06:40:33:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
06:40:33:  [<c1047272>] ? tick_program_event+0x19/0x1c
06:40:33:  [<c102e915>] ? irq_exit+0x41/0x64
06:40:33:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:40:33:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:40:33:  [<c1305022>] ? error_code+0x5a/0x60
06:40:33:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
06:40:33:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:40:33: Pid: 3145, comm: firefox-bin Not tainted 2.6.38-rc4 #226
06:40:33: Call Trace:
06:40:33:  [<c10054b6>] ? show_trace+0xf/0x11
06:40:33:  [<c1015eff>] ? arch_trigger_all_cpu_backtrace_handler+0x57/0x73
06:40:33:  [<c104039f>] ? notifier_call_chain+0x23/0x46
06:40:33:  [<c10403e3>] ? atomic_notifier_call_chain+0x1a/0x1d
06:40:33:  [<c1040477>] ? notify_die+0x30/0x34
06:40:33:  [<c1003657>] ? do_nmi+0x68/0x267
06:40:33:  [<c13050d1>] ? nmi_stack_correct+0x28/0x2d
06:40:33:  [<c10100d8>] ? do_machine_check+0x2c0/0x6d2
06:40:33:  [<c110f7eb>] ? delay_tsc+0x18/0x55
06:40:33:  [<c110f7bf>] ? __const_udelay+0x18/0x19
06:40:33:  [<c1015f6d>] ? arch_trigger_all_cpu_backtrace+0x52/0x65
06:40:33:  [<c105c85b>] ? __rcu_pending+0x6c/0x277
06:40:33:  [<c105caf0>] ? rcu_check_callbacks+0x8a/0xb6
06:40:33:  [<c1032df0>] ? update_process_times+0x2a/0x53
06:40:33:  [<c1047627>] ? tick_sched_timer+0x64/0x8d
06:40:33:  [<c103f332>] ? __run_hrtimer+0x6d/0xc3
06:40:33:  [<c103f595>] ? hrtimer_interrupt+0x10c/0x213
06:40:33:  [<c10157cc>] ? smp_apic_timer_interrupt+0x6c/0x7d
06:40:33:  [<c13000d8>] ? native_cpu_up+0x147/0x5bb
06:40:33:  [<c1304e02>] ? apic_timer_interrupt+0x2a/0x30
06:40:33:  [<c106eda8>] ? shrink_zone+0x1cb/0x4c3
06:40:33:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
06:40:33:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
06:40:33:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
06:40:33:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
06:40:33:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:40:33:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
06:40:33:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
06:40:33:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
06:40:33:  [<c1047272>] ? tick_program_event+0x19/0x1c
06:40:33:  [<c102e915>] ? irq_exit+0x41/0x64
06:40:33:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:40:33:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:40:33:  [<c1305022>] ? error_code+0x5a/0x60
06:40:33:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
06:40:33:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:40:33: NMI backtrace for cpu 0
06:40:33: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
06:40:33: 
06:40:33: Pid: 0, comm: swapper Not tainted 2.6.38-rc4 #226 0MG532/MXC061                          
06:40:33: EIP: 0060:[<c1019322>] EFLAGS: 00000057 CPU: 0
06:40:33: EIP is at read_hpet+0xe/0x12
06:40:33: EAX: 5b591d27 EBX: 0111c1e0 ECX: fffff000 EDX: 00000000
06:40:33: ESI: c1433a80 EDI: 53633001 EBP: c1421efc ESP: c1421efc
06:40:33:  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
06:40:33: Process swapper (pid: 0, ti=c1420000 task=c142fe20 task.ti=c1420000)
06:40:33: Stack:
06:40:33:  00000000 c1042852 00000003 c14e8cc8 0000c538 00000000 00000000 000003e8
06:40:33:  f6402cc8 00000000 c10477a4 00000000 000003e8 00000000 c1421f6c c102eb08
06:40:33:  ffffffcf c1003d1a f60d9440 c1421f9c c1040c67 7ad958c5 00002deb 00000000
06:40:33: Call Trace:
06:40:33:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:40:33:  [<c10477a4>] ? tick_check_idle+0x28/0x82
06:40:33:  [<c102eb08>] ? irq_enter+0x34/0x54
06:40:33:  [<c1003d1a>] ? do_IRQ+0x1e/0x95
06:40:33:  [<c1040c67>] ? sched_clock_local+0x19/0x17c
06:40:33:  [<c1002c69>] ? common_interrupt+0x29/0x30
06:40:33:  [<c115b48b>] ? acpi_idle_enter_bm+0x22c/0x261
06:40:33:  [<c123289f>] ? cpuidle_idle_call+0x67/0x98
06:40:33:  [<c1001ae9>] ? cpu_idle+0x41/0x5c
06:40:33:  [<c14987ce>] ? start_kernel+0x276/0x27b
06:40:33:  [<c149839a>] ? unknown_bootoption+0x0/0x18c
06:40:33: Code: 4f c1 8b 92 f0 00 00 00 29 d0 89 c2 31 c0 81 fa 80 00 00 00 ba c2 ff ff ff 0f 4c c2 c3 55 a1 34 e7 4f c1 89 e5 8b 80 f0 00 00 00 <31> d2 c9 c3 83 3d 38 e7 4f c1 00 75 37 83 3d 20 e7 4f c1 00 74 
06:40:33: Call Trace:
06:40:33:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:40:33:  [<c10477a4>] ? tick_check_idle+0x28/0x82
06:40:33:  [<c102eb08>] ? irq_enter+0x34/0x54
06:40:33:  [<c1003d1a>] ? do_IRQ+0x1e/0x95
06:40:33:  [<c1040c67>] ? sched_clock_local+0x19/0x17c
06:40:33:  [<c1002c69>] ? common_interrupt+0x29/0x30
06:40:33:  [<c115b48b>] ? acpi_idle_enter_bm+0x22c/0x261
06:40:33:  [<c123289f>] ? cpuidle_idle_call+0x67/0x98
06:40:33:  [<c1001ae9>] ? cpu_idle+0x41/0x5c
06:40:33:  [<c14987ce>] ? start_kernel+0x276/0x27b
06:40:33:  [<c149839a>] ? unknown_bootoption+0x0/0x18c
06:40:33: Pid: 0, comm: swapper Not tainted 2.6.38-rc4 #226
06:40:33: Call Trace:
06:40:33:  [<c10054b6>] ? show_trace+0xf/0x11
06:40:33:  [<c1015eff>] ? arch_trigger_all_cpu_backtrace_handler+0x57/0x73
06:40:33:  [<c104039f>] ? notifier_call_chain+0x23/0x46
06:40:33:  [<c10403e3>] ? atomic_notifier_call_chain+0x1a/0x1d
06:40:33:  [<c1040477>] ? notify_die+0x30/0x34
06:40:33:  [<c1003657>] ? do_nmi+0x68/0x267
06:40:33:  [<c13050d1>] ? nmi_stack_correct+0x28/0x2d
06:40:33:  [<c104007b>] ? copy_namespaces+0x1/0x7e
06:40:33:  [<c1019322>] ? read_hpet+0xe/0x12
06:40:33:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:40:33:  [<c10477a4>] ? tick_check_idle+0x28/0x82
06:40:33:  [<c102eb08>] ? irq_enter+0x34/0x54
06:40:33:  [<c1003d1a>] ? do_IRQ+0x1e/0x95
06:40:33:  [<c1040c67>] ? sched_clock_local+0x19/0x17c
06:40:33:  [<c1002c69>] ? common_interrupt+0x29/0x30
06:40:33:  [<c115b48b>] ? acpi_idle_enter_bm+0x22c/0x261
06:40:33:  [<c123289f>] ? cpuidle_idle_call+0x67/0x98
06:40:33:  [<c1001ae9>] ? cpu_idle+0x41/0x5c
06:40:33:  [<c14987ce>] ? start_kernel+0x276/0x27b
06:40:33:  [<c149839a>] ? unknown_bootoption+0x0/0x18c
06:42:04: INFO: rcu_sched_state detected stall on CPU 1 (t=18000 jiffies)
06:42:04: sending NMI to all CPUs:
06:42:04: NMI backtrace for cpu 1
06:42:04: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
06:42:04: 
06:42:04: Pid: 3145, comm: firefox-bin Not tainted 2.6.38-rc4 #226 0MG532/MXC061                          
06:42:04: EIP: 0060:[<c110f7eb>] EFLAGS: 00000082 CPU: 1
06:42:04: EIP is at delay_tsc+0x18/0x55
06:42:04: EAX: ff54deec EBX: 00000001 ECX: 00000001 EDX: 00001c6f
06:42:04: ESI: c1436640 EDI: 00000001 EBP: 001e7a67 ESP: f21a3c20
06:42:04:  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
06:42:04: Process firefox-bin (pid: 3145, ti=f21a2000 task=f613c6c0 task.ti=f21a2000)
06:42:04: Stack:
06:42:04:  00000000 c1436640 00000001 c1436640 00000001 c1436640 c110f7bf c1015f6d
06:42:04:  c13a101a f6602e14 c105c85b c13a901b c13a9102 00000001 00004650 00000000
06:42:04:  00000000 00000001 00000000 00000001 f21a3d2c c105caf0 f613c6c0 c1032df0
06:42:04: Call Trace:
06:42:04:  [<c110f7bf>] ? __const_udelay+0x18/0x19
06:42:04:  [<c1015f6d>] ? arch_trigger_all_cpu_backtrace+0x52/0x65
06:42:04:  [<c105c85b>] ? __rcu_pending+0x6c/0x277
06:42:04:  [<c105caf0>] ? rcu_check_callbacks+0x8a/0xb6
06:42:04:  [<c1032df0>] ? update_process_times+0x2a/0x53
06:42:04:  [<c1047627>] ? tick_sched_timer+0x64/0x8d
06:42:04:  [<c103f332>] ? __run_hrtimer+0x6d/0xc3
06:42:04:  [<c103f595>] ? hrtimer_interrupt+0x10c/0x213
06:42:04:  [<c102e915>] ? irq_exit+0x41/0x64
06:42:04:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:42:04:  [<c10157cc>] ? smp_apic_timer_interrupt+0x6c/0x7d
06:42:04:  [<c1110a7b>] ? div_u64_rem+0xb/0x2a
06:42:04:  [<c1304e02>] ? apic_timer_interrupt+0x2a/0x30
06:42:04:  [<c106eda8>] ? shrink_zone+0x1cb/0x4c3
06:42:04:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
06:42:04:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
06:42:04:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
06:42:04:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
06:42:04:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:42:04:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
06:42:04:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
06:42:04:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
06:42:04:  [<c1047272>] ? tick_program_event+0x19/0x1c
06:42:04:  [<c102e915>] ? irq_exit+0x41/0x64
06:42:04:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:42:04:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:42:04:  [<c1305022>] ? error_code+0x5a/0x60
06:42:04:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
06:42:04:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:42:04: Code: 69 c0 c7 10 00 00 e9 dc ff ff ff 8d 04 80 e9 d4 ff ff ff 55 89 c5 57 56 53 83 ec 08 64 8b 0d b8 7f 4e c1 8d 76 00 0f ae e8 0f 31 <89> c7 8d 76 00 0f ae e8 0f 31 89 c3 89 c6 29 fb 39 eb 73 21 f3 
06:42:04: Call Trace:
06:42:04:  [<c110f7bf>] ? __const_udelay+0x18/0x19
06:42:04:  [<c1015f6d>] ? arch_trigger_all_cpu_backtrace+0x52/0x65
06:42:04:  [<c105c85b>] ? __rcu_pending+0x6c/0x277
06:42:04:  [<c105caf0>] ? rcu_check_callbacks+0x8a/0xb6
06:42:04:  [<c1032df0>] ? update_process_times+0x2a/0x53
06:42:04:  [<c1047627>] ? tick_sched_timer+0x64/0x8d
06:42:04:  [<c103f332>] ? __run_hrtimer+0x6d/0xc3
06:42:04:  [<c103f595>] ? hrtimer_interrupt+0x10c/0x213
06:42:04:  [<c102e915>] ? irq_exit+0x41/0x64
06:42:04:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:42:04:  [<c10157cc>] ? smp_apic_timer_interrupt+0x6c/0x7d
06:42:04:  [<c1110a7b>] ? div_u64_rem+0xb/0x2a
06:42:04:  [<c1304e02>] ? apic_timer_interrupt+0x2a/0x30
06:42:04:  [<c106eda8>] ? shrink_zone+0x1cb/0x4c3
06:42:04:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
06:42:04:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
06:42:04:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
06:42:04:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
06:42:04:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:42:04:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
06:42:04:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
06:42:04:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
06:42:04:  [<c1047272>] ? tick_program_event+0x19/0x1c
06:42:04:  [<c102e915>] ? irq_exit+0x41/0x64
06:42:04:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:42:04:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:42:04:  [<c1305022>] ? error_code+0x5a/0x60
06:42:04:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
06:42:04:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:42:04: Pid: 3145, comm: firefox-bin Not tainted 2.6.38-rc4 #226
06:42:04: Call Trace:
06:42:04:  [<c10054b6>] ? show_trace+0xf/0x11
06:42:04:  [<c1015eff>] ? arch_trigger_all_cpu_backtrace_handler+0x57/0x73
06:42:04:  [<c104039f>] ? notifier_call_chain+0x23/0x46
06:42:04:  [<c10403e3>] ? atomic_notifier_call_chain+0x1a/0x1d
06:42:04:  [<c1040477>] ? notify_die+0x30/0x34
06:42:04:  [<c1003657>] ? do_nmi+0x68/0x267
06:42:04:  [<c13050d1>] ? nmi_stack_correct+0x28/0x2d
06:42:04:  [<c10100d8>] ? do_machine_check+0x2c0/0x6d2
06:42:04:  [<c110f7eb>] ? delay_tsc+0x18/0x55
06:42:04:  [<c110f7bf>] ? __const_udelay+0x18/0x19
06:42:04:  [<c1015f6d>] ? arch_trigger_all_cpu_backtrace+0x52/0x65
06:42:04:  [<c105c85b>] ? __rcu_pending+0x6c/0x277
06:42:04:  [<c105caf0>] ? rcu_check_callbacks+0x8a/0xb6
06:42:04:  [<c1032df0>] ? update_process_times+0x2a/0x53
06:42:04:  [<c1047627>] ? tick_sched_timer+0x64/0x8d
06:42:04:  [<c103f332>] ? __run_hrtimer+0x6d/0xc3
06:42:04:  [<c103f595>] ? hrtimer_interrupt+0x10c/0x213
06:42:04:  [<c102e915>] ? irq_exit+0x41/0x64
06:42:04:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:42:04:  [<c10157cc>] ? smp_apic_timer_interrupt+0x6c/0x7d
06:42:04:  [<c1110a7b>] ? div_u64_rem+0xb/0x2a
06:42:04:  [<c1304e02>] ? apic_timer_interrupt+0x2a/0x30
06:42:04:  [<c106eda8>] ? shrink_zone+0x1cb/0x4c3
06:42:04:  [<c106f8b8>] ? do_try_to_free_pages+0x87/0x2f0
06:42:04:  [<c106fc0c>] ? try_to_free_pages+0x63/0x6b
06:42:04:  [<c106a463>] ? __alloc_pages_nodemask+0x3f0/0x647
06:42:04:  [<c108ae84>] ? do_huge_pmd_anonymous_page+0x82/0x1ef
06:42:04:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:42:04:  [<c1079534>] ? handle_mm_fault+0x6f/0x100
06:42:04:  [<c104713b>] ? tick_dev_program_event+0x26/0x114
06:42:04:  [<c101afe4>] ? do_page_fault+0x2f1/0x30d
06:42:04:  [<c1047272>] ? tick_program_event+0x19/0x1c
06:42:04:  [<c102e915>] ? irq_exit+0x41/0x64
06:42:04:  [<c10157d1>] ? smp_apic_timer_interrupt+0x71/0x7d
06:42:04:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:42:04:  [<c1305022>] ? error_code+0x5a/0x60
06:42:04:  [<c1300000>] ? native_cpu_up+0x6f/0x5bb
06:42:04:  [<c101acf3>] ? do_page_fault+0x0/0x30d
06:42:04: NMI backtrace for cpu 0
06:42:04: Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
06:42:04: 
06:42:04: Pid: 0, comm: swapper Not tainted 2.6.38-rc4 #226 0MG532/MXC061                          
06:42:04: EIP: 0060:[<c1019322>] EFLAGS: 00000046 CPU: 0
06:42:04: EIP is at read_hpet+0xe/0x12
06:42:04: EAX: a8ab7498 EBX: 01129638 ECX: 00000000 EDX: 00000000
06:42:04: ESI: c1433a80 EDI: 3ba6d97a EBP: c1421ee8 ESP: c1421ee8
06:42:04:  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
06:42:04: Process swapper (pid: 0, ti=c1420000 task=c142fe20 task.ti=c1420000)
06:42:04: Stack:
06:42:04:  00000000 c1042852 0000584f c1433a00 0000c593 00000000 f6405f80 00002e00
06:42:04:  f6402cc8 00000000 c1040fb3 930787e0 00002e00 f6402cc8 c1040fe3 c10477b9
06:42:04:  00000000 000003e8 00000000 c1421f6c c102eb08 ffffffcf c1003d1a f60d9440
06:42:04: Call Trace:
06:42:04:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:42:04:  [<c1040fb3>] ? sched_clock_tick+0x4c/0x6e
06:42:04:  [<c1040fe3>] ? sched_clock_idle_wakeup_event+0xe/0x14
06:42:04:  [<c10477b9>] ? tick_check_idle+0x3d/0x82
06:42:04:  [<c102eb08>] ? irq_enter+0x34/0x54
06:42:04:  [<c1003d1a>] ? do_IRQ+0x1e/0x95
06:42:04:  [<c1040c67>] ? sched_clock_local+0x19/0x17c
06:42:04:  [<c1002c69>] ? common_interrupt+0x29/0x30
06:42:04:  [<c115b48b>] ? acpi_idle_enter_bm+0x22c/0x261
06:42:04:  [<c123289f>] ? cpuidle_idle_call+0x67/0x98
06:42:04:  [<c1001ae9>] ? cpu_idle+0x41/0x5c
06:42:04:  [<c14987ce>] ? start_kernel+0x276/0x27b
06:42:04:  [<c149839a>] ? unknown_bootoption+0x0/0x18c
06:42:04: Code: 4f c1 8b 92 f0 00 00 00 29 d0 89 c2 31 c0 81 fa 80 00 00 00 ba c2 ff ff ff 0f 4c c2 c3 55 a1 34 e7 4f c1 89 e5 8b 80 f0 00 00 00 <31> d2 c9 c3 83 3d 38 e7 4f c1 00 75 37 83 3d 20 e7 4f c1 00 74 
06:42:04: Call Trace:
06:42:04:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:42:04:  [<c1040fb3>] ? sched_clock_tick+0x4c/0x6e
06:42:04:  [<c1040fe3>] ? sched_clock_idle_wakeup_event+0xe/0x14
06:42:04:  [<c10477b9>] ? tick_check_idle+0x3d/0x82
06:42:04:  [<c102eb08>] ? irq_enter+0x34/0x54
06:42:04:  [<c1003d1a>] ? do_IRQ+0x1e/0x95
06:42:04:  [<c1040c67>] ? sched_clock_local+0x19/0x17c
06:42:04:  [<c1002c69>] ? common_interrupt+0x29/0x30
06:42:04:  [<c115b48b>] ? acpi_idle_enter_bm+0x22c/0x261
06:42:04:  [<c123289f>] ? cpuidle_idle_call+0x67/0x98
06:42:04:  [<c1001ae9>] ? cpu_idle+0x41/0x5c
06:42:04:  [<c14987ce>] ? start_kernel+0x276/0x27b
06:42:04:  [<c149839a>] ? unknown_bootoption+0x0/0x18c
06:42:04: Pid: 0, comm: swapper Not tainted 2.6.38-rc4 #226
06:42:04: Call Trace:
06:42:04:  [<c10054b6>] ? show_trace+0xf/0x11
06:42:04:  [<c1015eff>] ? arch_trigger_all_cpu_backtrace_handler+0x57/0x73
06:42:04:  [<c104039f>] ? notifier_call_chain+0x23/0x46
06:42:04:  [<c10403e3>] ? atomic_notifier_call_chain+0x1a/0x1d
06:42:04:  [<c1040477>] ? notify_die+0x30/0x34
06:42:04:  [<c1003657>] ? do_nmi+0x68/0x267
06:42:04:  [<c13050d1>] ? nmi_stack_correct+0x28/0x2d
06:42:04:  [<c1019322>] ? read_hpet+0xe/0x12
06:42:04:  [<c1042852>] ? ktime_get+0x5e/0xd9
06:42:04:  [<c1040fb3>] ? sched_clock_tick+0x4c/0x6e
06:42:04:  [<c1040fe3>] ? sched_clock_idle_wakeup_event+0xe/0x14
06:42:04:  [<c10477b9>] ? tick_check_idle+0x3d/0x82
06:42:04:  [<c102eb08>] ? irq_enter+0x34/0x54
06:42:04:  [<c1003d1a>] ? do_IRQ+0x1e/0x95
06:42:04:  [<c1040c67>] ? sched_clock_local+0x19/0x17c
06:42:04:  [<c1002c69>] ? common_interrupt+0x29/0x30
06:42:04:  [<c115b48b>] ? acpi_idle_enter_bm+0x22c/0x261
06:42:04:  [<c123289f>] ? cpuidle_idle_call+0x67/0x98
06:42:04:  [<c1001ae9>] ? cpu_idle+0x41/0x5c
06:42:04:  [<c14987ce>] ? start_kernel+0x276/0x27b
06:42:04:  [<c149839a>] ? unknown_bootoption+0x0/0x18c
