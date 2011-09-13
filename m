Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752416Ab1IMKeo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 06:34:44 -0400
Received: from mailout1.go2.pl ([193.17.41.11]:36068 "EHLO mailout1.go2.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751967Ab1IMKel (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 06:34:41 -0400
Message-ID: <4E6F31B7.1000507@tlen.pl>
Date: Tue, 13 Sep 2011 12:34:31 +0200
From: Mateusz Murawski <matowy@tlen.pl>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:6.0.2) Gecko/20110902 Thunderbird/6.0.2
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: Re: VT-d / iommu problem on Intel S3210SH on 3.1.0-0.rc5
References: <5d3988ad.24b007ce.4e6e07a7.c204f@tlen.pl>
In-Reply-To: <5d3988ad.24b007ce.4e6e07a7.c204f@tlen.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-O2-Trust: 2, 66
X-O2-SPF: neutral
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-------- Original Message  --------
Subject: VT-d / iommu problem on Intel S3210SH
From: Mateusz Murawski <matowy@tlen.pl>
To: linux-kernel@vger.kernel.org
Date: Mon Sep 12 2011 15:22:47 GMT+0200 (Central European Daylight Time)

(CC to iommu@lists.linux-foundation.org)

> Hi
> I have problem with Intel VT for Directed I/O.
> When I enable this option in bios, my system (Fedora 15) can't start.
> Kernel 2.6.40.4-5.fc15.x86_64
> Bios S3200X38.86B.00.00.0052
>
> Last lines from dmesg
>
> [    5.357181] DRHD: handling fault status reg 3
> [    5.358179] DMAR:[DMA Write] Request device [02:08.0] fault addr ffe8a000
> [    5.358179] DMAR:[fault reason 02] Present bit in context entry is clear
> [   24.087406] dracut Warning: No root device "block:/dev/disk/by-uuid/1c624f0d-4593-4653-a4ce-b7af80d549ff" found
>
> Full dmesgs
> dmesg_bad_2.6.40 VT-d enable http://pastebin.com/AXAByHBh
> dmesg_good_2.6.40 VT-d enable iommu=off http://pastebin.com/8zrMRiin
>

Update:
After update to fedora 16, i have some more news.

[    5.566113] megasas: 00.00.05.40-rc1 Tue. Jul. 26 17:00:00 PDT 2011
[    5.575474] megasas: 0x1000:0x0411:0x8086:0x1001: bus 2:slot 14:func 0
[    5.583473] megaraid_sas 0000:02:0e.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    5.595382] megasas: FW now in Ready state
[    5.629114] blkid used greatest stack depth: 4720 bytes left
[    5.688185] megasas_init_mfi: fw_support_ieee=0
[    5.693172] megasas: INIT adapter done
[    5.761143] scsi0 : LSI SAS based MegaRAID driver
[    5.761164] megaraid_sas: fw state:c0000000
[    5.761167] megasas: fwstate:c0000000, dis_OCR=0
[    5.781140] modprobe used greatest stack depth: 4688 bytes left
[    5.812457] DRHD: handling fault status reg 2
[    5.808005] [Hardware Error]: Hardware error from APEI Generic Hardware Error Source: 1
[    5.808005] [Hardware Error]: APEI generic hardware error status
[    5.808005] [Hardware Error]: severity: 1, fatal
[    5.808005] [Hardware Error]: section: 0, severity: 1, fatal
[    5.808005] [Hardware Error]: flags: 0x01
[    5.808005] [Hardware Error]: primary
[    5.808005] [Hardware Error]: section_type: PCIe error
[    5.808005] [Firmware Warn]: error section length is too small
[    5.808005] Kernel panic - not syncing: Fatal hardware error!
[    5.808005] Pid: 0, comm: swapper Not tainted 3.1.0-0.rc5.git0.0.fc16.x86_64 #1
[    5.808005] Call Trace:
[    5.808005]  <NMI>  [<ffffffff814f9e93>] panic+0xa0/0x1b9
[    5.808005]  [<ffffffff812cfd68>] ghes_notify_nmi+0x128/0x1e5
[    5.808005]  [<ffffffff81508480>] notifier_call_chain+0x84/0xbb
[    5.808005]  [<ffffffff8150852f>] __atomic_notifier_call_chain+0x78/0xa8
[    5.808005]  [<ffffffff815084b7>] ? notifier_call_chain+0xbb/0xbb
[    5.808005]  [<ffffffff81508573>] atomic_notifier_call_chain+0x14/0x16
[    5.808005]  [<ffffffff815085a3>] notify_die+0x2e/0x30
[    5.808005]  [<ffffffff81505b88>] do_nmi+0x81/0x24a
[    5.808005]  [<ffffffff815057c0>] nmi+0x20/0x39
[    5.808005]  [<ffffffff810161d5>] ? mwait_idle+0x8c/0xc3
[    5.808005]  <<EOE>>  [<ffffffff8100e2f9>] cpu_idle+0xb5/0x101
[    5.808005]  [<ffffffff814e01d8>] rest_init+0xdc/0xe3
[    5.808005]  [<ffffffff814e00fc>] ? csum_partial_copy_generic+0x16c/0x16c
[    5.808005]  [<ffffffff81d53b9f>] start_kernel+0x3dd/0x3ea
[    5.808005]  [<ffffffff81d532c4>] x86_64_start_reservations+0xaf/0xb3
[    5.808005]  [<ffffffff81d53140>] ? early_idt_handlers+0x140/0x140
[    5.808005]  [<ffffffff81d533ca>] x86_64_start_kernel+0x102/0x111
[    5.813443] DMAR:[DMA Write] Request device [02:08.0] fault addr ffe85000
[    5.813443] DMAR:[fault reason 02] Present bit in context entry is clear
[    5.808005] Rebooting in 30 seconds..
[    5.808005] ACPI MEMORY or I/O RESET_REG.

Full dmesg
http://pastebin.com/vQCpLfB9

and another

[    5.535913] megasas: 00.00.05.40-rc1 Tue. Jul. 26 17:00:00 PDT 2011
[    5.547479] megasas: 0x1000:0x0411:0x8086:0x1001: bus 2:slot 14:func 0
[    5.555361] megaraid_sas 0000:02:0e.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    5.564988] megasas: FW now in Ready state
[    5.642092] megasas_init_mfi: fw_support_ieee=0
[    5.642097] megasas: INIT adapter done
[    5.705109] scsi0 : LSI SAS based MegaRAID driver
[    5.710763] megaraid_sas: fw state:c0000000
[    5.711726] megasas: fwstate:c0000000, dis_OCR=0
[    5.727173] modprobe used greatest stack depth: 4688 bytes left
[    5.755005] [Hardware Error]: Hardware error from APEI Generic Hardware Error Source: 1
[    5.755003] DRHD: handling fault status reg 2
[    5.755003] DMAR:[DMA Write] Request device [02:08.0] fault addr ffe80000
[    5.755003] DMAR:[fault reason 02] Present bit in context entry is clear
[    5.759224] [Hardware Error]: APEI generic hardware error status
[    5.759224] [Hardware Error]: severity: 1, fatal
[    5.759224] [Hardware Error]: section: 0, severity: 1, fatal
[    5.759224] [Hardware Error]: flags: 0x01
[    5.759224] [Hardware Error]: primary
[    5.759224] [Hardware Error]: section_type: PCIe error
[    5.759224] [Firmware Warn]: error section length is too small
[    5.759224] Kernel panic - not syncing: Fatal hardware error!
[    5.759224] Pid: 0, comm: swapper Not tainted 3.1.0-0.rc5.git0.0.fc16.x86_64 #1
[    5.759224] Call Trace:
[    5.759224]  <NMI>  [<ffffffff814f9e93>] panic+0xa0/0x1b9
[    5.759224]  [<ffffffff812cfd68>] ghes_notify_nmi+0x128/0x1e5
[    5.759224]  [<ffffffff81508480>] notifier_call_chain+0x84/0xbb
[    5.759224]  [<ffffffff8150852f>] __atomic_notifier_call_chain+0x78/0xa8
[    5.759224]  [<ffffffff815084b7>] ? notifier_call_chain+0xbb/0xbb
[    5.759224]  [<ffffffff81053c40>] ? try_to_wake_up+0x1c3/0x1d5
[    5.759224]  [<ffffffff81508573>] atomic_notifier_call_chain+0x14/0x16
[    5.759224]  [<ffffffff815085a3>] notify_die+0x2e/0x30
[    5.759224]  [<ffffffff81505b88>] do_nmi+0x81/0x24a
[    5.759224]  [<ffffffff81053c40>] ? try_to_wake_up+0x1c3/0x1d5
[    5.759224]  [<ffffffff815057c0>] nmi+0x20/0x39
[    5.759224]  [<ffffffff81053c40>] ? try_to_wake_up+0x1c3/0x1d5
[    5.759224]  [<ffffffff8108ae23>] ? lock_time_inc+0x25/0x27
[    5.759224]  <<EOE>>  <IRQ>  [<ffffffff8108be28>] lock_release_holdtime.part.9+0x51/0x62
[    5.759224]  [<ffffffff8108ef08>] lock_release+0x186/0x1de
[    5.759224]  [<ffffffff81504d76>] _raw_spin_unlock_irqrestore+0x24/0x61
[    5.759224]  [<ffffffff81053c40>] try_to_wake_up+0x1c3/0x1d5
[    5.759224]  [<ffffffff8108cf2b>] ? lock_acquired+0x210/0x243
[    5.759224]  [<ffffffff81053c7b>] wake_up_process+0x15/0x17
[    5.759224]  [<ffffffff81073a28>] wake_up_worker+0x24/0x26
[    5.759224]  [<ffffffff81074cb5>] insert_work+0x66/0x6f
[    5.759224]  [<ffffffff8107572b>] __queue_work+0x284/0x2c2
[    5.759224]  [<ffffffff81075790>] delayed_work_timer_fn+0x27/0x2b
[    5.759224]  [<ffffffff8106a7e0>] run_timer_softirq+0x218/0x372
[    5.759224]  [<ffffffff8106a71f>] ? run_timer_softirq+0x157/0x372
[    5.759224]  [<ffffffff81080229>] ? sched_clock_local+0x12/0x75
[    5.759224]  [<ffffffff81075769>] ? __queue_work+0x2c2/0x2c2
[    5.759224]  [<ffffffff810152b7>] ? native_sched_clock+0x34/0x36
[    5.759224]  [<ffffffff81062ad2>] __do_softirq+0x112/0x25a
[    5.759224]  [<ffffffff81014ded>] ? paravirt_read_tsc+0x9/0xd
[    5.759224]  [<ffffffff810152c2>] ? sched_clock+0x9/0xd
[    5.759224]  [<ffffffff8150de7c>] call_softirq+0x1c/0x30
[    5.759224]  [<ffffffff81010bfd>] do_softirq+0x4b/0xa2
[    5.759224]  [<ffffffff81062e81>] irq_exit+0x5d/0xcf
[    5.759224]  [<ffffffff8150e811>] smp_apic_timer_interrupt+0x7c/0x8a
[    5.759224]  [<ffffffff8150c6f3>] apic_timer_interrupt+0x73/0x80
[    5.759224]  <EOI>  [<ffffffff810161d5>] ? mwait_idle+0x8c/0xc3
[    5.759224]  [<ffffffff810161cc>] ? mwait_idle+0x83/0xc3
[    5.759224]  [<ffffffff8100e2f9>] cpu_idle+0xb5/0x101
[    5.759224]  [<ffffffff814e01d8>] rest_init+0xdc/0xe3
[    5.759224]  [<ffffffff814e00fc>] ? csum_partial_copy_generic+0x16c/0x16c
[    5.759224]  [<ffffffff81d53b9f>] start_kernel+0x3dd/0x3ea
[    5.759224]  [<ffffffff81d532c4>] x86_64_start_reservations+0xaf/0xb3
[    5.759224]  [<ffffffff81d53140>] ? early_idt_handlers+0x140/0x140
[    5.759224]  [<ffffffff81d533ca>] x86_64_start_kernel+0x102/0x111
[    5.759224] BUG: scheduling while atomic: swapper/0/0x1401010a
[    5.759224] INFO: lockdep is turned off.
[    5.759224] Modules linked in: megaraid_sas
[    5.759224] irq event stamp: 140599
[    5.759224] hardirqs last  enabled at (140598): [<ffffffff81504d97>] _raw_spin_unlock_irqrestore+0x45/0x61
[    5.759224] hardirqs last disabled at (140599): [<ffffffff81504577>] _raw_spin_lock_irqsave+0x22/0x8e
[    5.759224] softirqs last  enabled at (140592): [<ffffffff810624f1>] _local_bh_enable+0x13/0x15
[    5.759224] softirqs last disabled at (140593): [<ffffffff8150de7c>] call_softirq+0x1c/0x30
[    5.759224] CPU 0
[    5.759224] Modules linked in: megaraid_sas
[    5.759224]
[    5.759224] Pid: 0, comm: swapper Not tainted 3.1.0-0.rc5.git0.0.fc16.x86_64 #1 Intel Corporation S3210SH/S3210SH
[    5.759224] RIP: 0010:[<ffffffff810161d5>]  [<ffffffff810161d5>] mwait_idle+0x8c/0xc3
[    5.759224] RSP: 0018:ffffffff81a01ea8  EFLAGS: 00000246
[    5.759224] RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0000000000000000
[    5.759224] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffffffff81a0d020
[    5.759224] RBP: ffffffff81a01ea8 R08: 0000000000000000 R09: ffffffff81a01dd8
[    5.759224] R10: ffffffff81a01dd8 R11: 000000000000011a R12: 00000000ffffffff
[    5.759224] R13: 0000000000000000 R14: ffffffff81a00000 R15: 00000000ffffffff
[    5.759224] FS:  0000000000000000(0000) GS:ffff88007f200000(0000) knlGS:0000000000000000
[    5.759224] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    5.759224] CR2: 00007f891117c978 CR3: 0000000001a05000 CR4: 00000000000406f0
[    5.759224] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    5.759224] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[    5.759224] Process swapper (pid: 0, threadinfo ffffffff81a00000, task ffffffff81a0d020)
[    5.759224] Stack:
[    5.759224]  ffffffff81a01ee8 ffffffff8100e2f9 ffffffff81a01ee8 20dedb5a4e200ca7
[    5.759224]  0000000000000002 ffffffff81a00000 0000000000000002 ffff88007fde4040
[    5.759224]  ffffffff81a01f18 ffffffff814e01d8 ffffffff814e00fc 0000000000000000
[    5.759224] Call Trace:
[    5.759224]  [<ffffffff8100e2f9>] cpu_idle+0xb5/0x101
[    5.759224]  [<ffffffff814e01d8>] rest_init+0xdc/0xe3
[    5.759224]  [<ffffffff814e00fc>] ? csum_partial_copy_generic+0x16c/0x16c
[    5.759224]  [<ffffffff81d53b9f>] start_kernel+0x3dd/0x3ea
[    5.759224]  [<ffffffff81d532c4>] x86_64_start_reservations+0xaf/0xb3
[    5.759224]  [<ffffffff81d53140>] ? early_idt_handlers+0x140/0x140
[    5.759224]  [<ffffffff81d533ca>] x86_64_start_kernel+0x102/0x111
[    5.759224] Code: 25 48 c4 00 00 48 89 d1 48 2d c8 1f 00 00 0f 01 c8 0f ae f0 e8 38 fb ff ff 85 c0 75 10 e8 06 93 07 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 0a e8 f6 92 07 00 e8 d8 fa ff ff 65 8b 3c 25 20 d4 00 00 e8
[    5.759224] Call Trace:
[    5.759224]  [<ffffffff8100e2f9>] cpu_idle+0xb5/0x101
[    5.759224]  [<ffffffff814e01d8>] rest_init+0xdc/0xe3
[    5.759224]  [<ffffffff814e00fc>] ? csum_partial_copy_generic+0x16c/0x16c
[    5.759224]  [<ffffffff81d53b9f>] start_kernel+0x3dd/0x3ea
[    5.759224]  [<ffffffff81d532c4>] x86_64_start_reservations+0xaf/0xb3
[    5.759224]  [<ffffffff81d53140>] ? early_idt_handlers+0x140/0x140
[    5.759224]  [<ffffffff81d533ca>] x86_64_start_kernel+0x102/0x111
[    6.518870] scsi scan: INQUIRY result too short (5), using 36
[    6.525709] scsi 0:0:24:0: Direct-Access                                    PQ: 0 ANSI: 0
[    6.536501] ------------[ cut here ]------------
[    6.536501] WARNING: at kernel/watchdog.c:241 watchdog_overflow_callback+0x9b/0xa6()
[    6.536501] Hardware name: S3210SH
[    6.536501] Watchdog detected hard LOCKUP on cpu 0
[    6.536501] Modules linked in: megaraid_sas
[    6.536501] Pid: 11, comm: kworker/0:1 Not tainted 3.1.0-0.rc5.git0.0.fc16.x86_64 #1
[    6.536501] Call Trace:
[    6.536501]  <NMI>  [<ffffffff8105c444>] warn_slowpath_common+0x83/0x9b
[    6.536501]  [<ffffffff8105c4ff>] warn_slowpath_fmt+0x46/0x48
[    6.536501]  [<ffffffff810c1f22>] watchdog_overflow_callback+0x9b/0xa6
[    6.536501]  [<ffffffff810ed99b>] __perf_event_overflow+0x100/0x189
[    6.536501]  [<ffffffff810ebbb2>] ? perf_event_update_userpage+0x110/0x11f
[    6.536501]  [<ffffffff810ee188>] perf_event_overflow+0x14/0x16
[    6.536501]  [<ffffffff8101f37a>] intel_pmu_handle_irq+0x3cc/0x42c
[    6.536501]  [<ffffffff8150666b>] perf_event_nmi_handler+0x43/0x8e
[    6.536501]  [<ffffffff81508480>] notifier_call_chain+0x84/0xbb
[    6.536501]  [<ffffffff8150852f>] __atomic_notifier_call_chain+0x78/0xa8
[    6.536501]  [<ffffffff815084b7>] ? notifier_call_chain+0xbb/0xbb
[    6.536501]  [<ffffffff81508573>] atomic_notifier_call_chain+0x14/0x16
[    6.536501]  [<ffffffff815085a3>] notify_die+0x2e/0x30
[    6.536501]  [<ffffffff81505b88>] do_nmi+0x81/0x24a
[    6.536501]  [<ffffffff815057c0>] nmi+0x20/0x39
[    6.536501]  [<ffffffff8101589f>] ? native_read_tsc+0x6/0x14
[    6.536501]  <<EOE>>  [<ffffffff81252d9e>] paravirt_read_tsc+0xe/0x12
[    6.536501]  [<ffffffff81252e7c>] delay_tsc+0x38/0xa3
[    6.536501]  [<ffffffff81252de9>] __delay+0xf/0x11
[    6.536501]  [<ffffffff812584b2>] do_raw_spin_lock+0xd8/0x142
[    6.536501]  [<ffffffff81504542>] _raw_spin_lock_irq+0x6f/0x82
[    6.536501]  [<ffffffff81076765>] ? worker_thread+0x38/0x15d
[    6.536501]  [<ffffffff81076765>] worker_thread+0x38/0x15d
[    6.536501]  [<ffffffff8107672d>] ? manage_workers+0x176/0x176
[    6.536501]  [<ffffffff8107a1cd>] kthread+0xa8/0xb0
[    6.536501]  [<ffffffff8150dd84>] kernel_thread_helper+0x4/0x10
[    6.536501]  [<ffffffff815051f4>] ? retint_restore_args+0x13/0x13
[    6.536501]  [<ffffffff8107a125>] ? __init_kthread_worker+0x5a/0x5a
[    6.536501]  [<ffffffff8150dd80>] ? gs_change+0x13/0x13
[    6.536501] ---[ end trace 62cac107f89d6b2b ]---
[    6.705028] ------------[ cut here ]------------
[    6.705028] WARNING: at kernel/watchdog.c:241 watchdog_overflow_callback+0x9b/0xa6()
[    6.705028] Hardware name: S3210SH
[    6.705028] Watchdog detected hard LOCKUP on cpu 3
[    6.705028] Modules linked in: megaraid_sas
[    6.705028] Pid: 34, comm: kworker/3:1 Tainted: G        W   3.1.0-0.rc5.git0.0.fc16.x86_64 #1
[    6.705028] Call Trace:
[    6.705028]  <NMI>  [<ffffffff8105c444>] warn_slowpath_common+0x83/0x9b
[    6.705028]  [<ffffffff8105c4ff>] warn_slowpath_fmt+0x46/0x48
[    6.705028]  [<ffffffff810c1f22>] watchdog_overflow_callback+0x9b/0xa6
[    6.705028]  [<ffffffff810ed99b>] __perf_event_overflow+0x100/0x189
[    6.705028]  [<ffffffff810ebbb2>] ? perf_event_update_userpage+0x110/0x11f
[    6.705028]  [<ffffffff810ee188>] perf_event_overflow+0x14/0x16
[    6.705028]  [<ffffffff8101f37a>] intel_pmu_handle_irq+0x3cc/0x42c
[    6.705028]  [<ffffffff8150666b>] perf_event_nmi_handler+0x43/0x8e
[    6.705028]  [<ffffffff81508480>] notifier_call_chain+0x84/0xbb
[    6.705028]  [<ffffffff8150852f>] __atomic_notifier_call_chain+0x78/0xa8
[    6.705028]  [<ffffffff815084b7>] ? notifier_call_chain+0xbb/0xbb
[    6.705028]  [<ffffffff81508573>] atomic_notifier_call_chain+0x14/0x16
[    6.705028]  [<ffffffff815085a3>] notify_die+0x2e/0x30
[    6.705028]  [<ffffffff81505b88>] do_nmi+0x81/0x24a
[    6.705028]  [<ffffffff815057c0>] nmi+0x20/0x39
[    6.705028]  [<ffffffff81074dbc>] ? wait_on_cpu_work+0x2f/0xa7
[    6.705028]  [<ffffffff8101589f>] ? native_read_tsc+0x6/0x14
[    6.705028]  <<EOE>>  [<ffffffff81252d9e>] paravirt_read_tsc+0xe/0x12
[    6.705028]  [<ffffffff81252e8a>] delay_tsc+0x46/0xa3
[    6.705028]  [<ffffffff81252de9>] __delay+0xf/0x11
[    6.705028]  [<ffffffff812584b2>] do_raw_spin_lock+0xd8/0x142
[    6.705028]  [<ffffffff81504542>] _raw_spin_lock_irq+0x6f/0x82
[    6.705028]  [<ffffffff81074dbc>] ? wait_on_cpu_work+0x2f/0xa7
[    6.705028]  [<ffffffff810152c2>] ? sched_clock+0x9/0xd
[    6.705028]  [<ffffffff81074dbc>] wait_on_cpu_work+0x2f/0xa7
[    6.705028]  [<ffffffff8108bbda>] ? look_up_lock_class+0x5f/0xc3
[    6.705028]  [<ffffffff81014ded>] ? paravirt_read_tsc+0x9/0xd
[    6.705028]  [<ffffffff81074e34>] ? wait_on_cpu_work+0xa7/0xa7
[    6.705028]  [<ffffffff8108f06f>] ? lock_acquire+0x10f/0x13e
[    6.705028]  [<ffffffff81074e34>] ? wait_on_cpu_work+0xa7/0xa7
[    6.705028]  [<ffffffff8108ef33>] ? lock_release+0x1b1/0x1de
[    6.705028]  [<ffffffff81074ecc>] wait_on_work+0x98/0xc7
[    6.705028]  [<ffffffff81074e34>] ? wait_on_cpu_work+0xa7/0xa7
[    6.705028]  [<ffffffff81259f46>] ? debug_object_activate+0x36/0xda
[    6.705028]  [<ffffffff81075fc3>] __cancel_work_timer+0xcc/0x10a
[    6.705028]  [<ffffffff81076013>] cancel_delayed_work_sync+0x12/0x14
[    6.705028]  [<ffffffff8136c7b4>] hub_quiesce+0x29/0x9a
[    6.705028]  [<ffffffff8136c901>] hub_suspend+0xb9/0xd1
[    6.705028]  [<ffffffff81504d90>] ? _raw_spin_unlock_irqrestore+0x3e/0x61
[    6.705028]  [<ffffffff813758fa>] usb_suspend_both+0x98/0x1d3
[    6.705028]  [<ffffffff81376372>] ? usb_probe_device+0x5f/0x5f
[    6.705028]  [<ffffffff813763a5>] usb_runtime_suspend+0x33/0x41
[    6.705028]  [<ffffffff8131e816>] rpm_callback+0x48/0x72
[    6.705028]  [<ffffffff8131eaac>] ? pm_runtime_autosuspend_expiration+0x56/0x7b
[    6.705028]  [<ffffffff8131ed91>] rpm_suspend+0x24c/0x3a8
[    6.705028]  [<ffffffff8131fa92>] ? pm_schedule_suspend+0xb1/0xb1
[    6.705028]  [<ffffffff8131fa92>] ? pm_schedule_suspend+0xb1/0xb1
[    6.705028]  [<ffffffff8131fb1a>] pm_runtime_work+0x88/0xa1
[    6.705028]  [<ffffffff81075b59>] process_one_work+0x205/0x3e7
[    6.705028]  [<ffffffff81075aa1>] ? process_one_work+0x14d/0x3e7
[    6.705028]  [<ffffffff8108cf2b>] ? lock_acquired+0x210/0x243
[    6.705028]  [<ffffffff81076807>] worker_thread+0xda/0x15d
[    6.705028]  [<ffffffff8107672d>] ? manage_workers+0x176/0x176
[    6.705028]  [<ffffffff8107a1cd>] kthread+0xa8/0xb0
[    6.705028]  [<ffffffff8150dd84>] kernel_thread_helper+0x4/0x10
[    6.705028]  [<ffffffff815051f4>] ? retint_restore_args+0x13/0x13
[    6.705028]  [<ffffffff8107a125>] ? __init_kthread_worker+0x5a/0x5a
[    6.705028]  [<ffffffff8150dd80>] ? gs_change+0x13/0x13
[    6.705028] ---[ end trace 62cac107f89d6b2c ]---
[    6.536516] ------------[ cut here ]------------
[    6.536516] WARNING: at kernel/watchdog.c:241 watchdog_overflow_callback+0x9b/0xa6()
[    6.536516] Hardware name: S3210SH
[    6.536516] Watchdog detected hard LOCKUP on cpu 1
[    6.536516] Modules linked in: megaraid_sas
[    6.536516] Pid: 242, comm: scsi_scan_0 Tainted: G        W   3.1.0-0.rc5.git0.0.fc16.x86_64 #1
[    6.536516] Call Trace:
[    6.536516]  <NMI>  [<ffffffff8105c444>] warn_slowpath_common+0x83/0x9b
[    6.536516]  [<ffffffff8105c4ff>] warn_slowpath_fmt+0x46/0x48
[    6.536516]  [<ffffffff810c1f22>] watchdog_overflow_callback+0x9b/0xa6
[    6.536516]  [<ffffffff810ed99b>] __perf_event_overflow+0x100/0x189
[    6.536516]  [<ffffffff810ebbb2>] ? perf_event_update_userpage+0x110/0x11f
[    6.536516]  [<ffffffff810ee188>] perf_event_overflow+0x14/0x16
[    6.536516]  [<ffffffff8101f37a>] intel_pmu_handle_irq+0x3cc/0x42c
[    6.536516]  [<ffffffff8150666b>] perf_event_nmi_handler+0x43/0x8e
[    6.536516]  [<ffffffff81508480>] notifier_call_chain+0x84/0xbb
[    6.536516]  [<ffffffff8150852f>] __atomic_notifier_call_chain+0x78/0xa8
[    6.536516]  [<ffffffff815084b7>] ? notifier_call_chain+0xbb/0xbb
[    6.536516]  [<ffffffff81508573>] atomic_notifier_call_chain+0x14/0x16
[    6.536516]  [<ffffffff815085a3>] notify_die+0x2e/0x30
[    6.536516]  [<ffffffff81505b88>] do_nmi+0x81/0x24a
[    6.536516]  [<ffffffff815057c0>] nmi+0x20/0x39
[    6.536516]  [<ffffffff8101589f>] ? native_read_tsc+0x6/0x14
[    6.536516]  <<EOE>>  [<ffffffff81252d9e>] paravirt_read_tsc+0xe/0x12
[    6.536516]  [<ffffffff81252e7c>] delay_tsc+0x38/0xa3
[    6.536516]  [<ffffffff81252de9>] __delay+0xf/0x11
[    6.536516]  [<ffffffff812584b2>] do_raw_spin_lock+0xd8/0x142
[    6.536516]  [<ffffffff81504542>] _raw_spin_lock_irq+0x6f/0x82
[    6.536516]  [<ffffffff81074dbc>] ? wait_on_cpu_work+0x2f/0xa7
[    6.536516]  [<ffffffff81074dbc>] wait_on_cpu_work+0x2f/0xa7
[    6.536516]  [<ffffffff8108b8c5>] ? trace_hardirqs_off+0xd/0xf
[    6.536516]  [<ffffffff81074e34>] ? wait_on_cpu_work+0xa7/0xa7
[    6.536516]  [<ffffffff8108f06f>] ? lock_acquire+0x10f/0x13e
[    6.536516]  [<ffffffff81074e34>] ? wait_on_cpu_work+0xa7/0xa7
[    6.536516]  [<ffffffff8108ef33>] ? lock_release+0x1b1/0x1de
[    6.536516]  [<ffffffff81074ecc>] wait_on_work+0x98/0xc7
[    6.536516]  [<ffffffff81074e34>] ? wait_on_cpu_work+0xa7/0xa7
[    6.536516]  [<ffffffff8106a25a>] ? try_to_del_timer_sync+0x73/0x81
[    6.536516]  [<ffffffff81075fc3>] __cancel_work_timer+0xcc/0x10a
[    6.536516]  [<ffffffff81076013>] cancel_delayed_work_sync+0x12/0x14
[    6.536516]  [<ffffffff81231665>] blk_sync_queue+0x27/0x2c
[    6.536516]  [<ffffffff81231685>] blk_cleanup_queue+0x1b/0x68
[    6.536516]  [<ffffffff81330292>] scsi_free_queue+0xe/0x10
[    6.536516]  [<ffffffff813339da>] __scsi_remove_device+0xac/0xb9
[    6.536516]  [<ffffffff81331910>] scsi_probe_and_add_lun+0xa6e/0xaab
[    6.536516]  [<ffffffff81331b5d>] __scsi_scan_target+0xb6/0x5d2
[    6.536516]  [<ffffffff8108f352>] ? mark_held_locks+0x6d/0x95
[    6.536516]  [<ffffffff81504d97>] ? _raw_spin_unlock_irqrestore+0x45/0x61
[    6.536516]  [<ffffffff8108f49b>] ? trace_hardirqs_on_caller+0x121/0x158
[    6.536516]  [<ffffffff813320d0>] scsi_scan_channel.part.2+0x57/0x72
[    6.536516]  [<ffffffff813323da>] scsi_scan_host_selected+0x109/0x191
[    6.536516]  [<ffffffff813324d7>] ? do_scsi_scan_host+0x75/0x75
[    6.536516]  [<ffffffff813324d2>] do_scsi_scan_host+0x70/0x75
[    6.536516]  [<ffffffff813324fa>] do_scan_async+0x23/0x142
[    6.536516]  [<ffffffff813324d7>] ? do_scsi_scan_host+0x75/0x75
[    6.536516]  [<ffffffff813324d7>] ? do_scsi_scan_host+0x75/0x75
[    6.536516]  [<ffffffff8107a1cd>] kthread+0xa8/0xb0
[    6.536516]  [<ffffffff8150dd84>] kernel_thread_helper+0x4/0x10
[    6.536516]  [<ffffffff815051f4>] ? retint_restore_args+0x13/0x13
[    6.536516]  [<ffffffff8107a125>] ? __init_kthread_worker+0x5a/0x5a
[    6.536516]  [<ffffffff8150dd80>] ? gs_change+0x13/0x13
[    6.536516] ---[ end trace 62cac107f89d6b2d ]---
[    6.536501] BUG: spinlock lockup on CPU#0, kworker/0:1/11, ffff88007f20de80
[    6.536501] Pid: 11, comm: kworker/0:1 Tainted: G        W   3.1.0-0.rc5.git0.0.fc16.x86_64 #1
[    6.536501] Call Trace:
[    6.536501]  [<ffffffff812584ec>] do_raw_spin_lock+0x112/0x142
[    6.536501]  [<ffffffff81504542>] _raw_spin_lock_irq+0x6f/0x82
[    6.536501]  [<ffffffff81076765>] ? worker_thread+0x38/0x15d
[    6.536501]  [<ffffffff81076765>] worker_thread+0x38/0x15d
[    6.536501]  [<ffffffff8107672d>] ? manage_workers+0x176/0x176
[    6.536501]  [<ffffffff8107a1cd>] kthread+0xa8/0xb0
[    6.536501]  [<ffffffff8150dd84>] kernel_thread_helper+0x4/0x10
[    6.536501]  [<ffffffff815051f4>] ? retint_restore_args+0x13/0x13
[    6.536501]  [<ffffffff8107a125>] ? __init_kthread_worker+0x5a/0x5a
[    6.536501]  [<ffffffff8150dd80>] ? gs_change+0x13/0x13
[    6.536501] sending NMI to all CPUs:
[    6.536501] NMI backtrace for cpu 0
[    6.536501] CPU 0
[    6.536501] Modules linked in: megaraid_sas
[    6.536501]
[    6.536501] Pid: 11, comm: kworker/0:1 Tainted: G        W   3.1.0-0.rc5.git0.0.fc16.x86_64 #1 Intel Corporation S3210SH/S3210SH
[    6.536501] RIP: 0010:[<ffffffff8101589f>]  [<ffffffff8101589f>] native_read_tsc+0x6/0x14
[    6.536501] RSP: 0018:ffff88007b593d48  EFLAGS: 00000006
[    6.536501] RAX: 000000000fa01898 RBX: ffff88007b593fd8 RCX: 000000000fa01850
[    6.536501] RDX: 00000000000000b2 RSI: 0000000000000200 RDI: 00000000002896c4
[    6.536501] RBP: ffff88007b593d48 R08: 0000000000000002 R09: 0000000000000000
[    6.536501] R10: 0000ffff00066c0a R11: 0000000000000000 R12: 000000000fa01850
[    6.536501] R13: 00000000002896c4 R14: 0000000000000000 R15: 000000009e8a5978
[    6.536501] FS:  0000000000000000(0000) GS:ffff88007f200000(0000) knlGS:0000000000000000
[    6.536501] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    6.536501] CR2: 00007f891117c978 CR3: 0000000001a05000 CR4: 00000000000406f0
[    6.536501] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    6.536501] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[    6.536501] Process kworker/0:1 (pid: 11, threadinfo ffff88007b592000, task ffff88007b58c9a0)
[    6.536501] Stack:
[    6.536501]  ffff88007b593d58 ffffffff81252d9e ffff88007b593d90 ffffffff81252e8a
[    6.536501]  0000000000002710 ffff88007b58c9a0 000000009e8a5978 ffff88007b58ce10
[    6.536501]  000000009e8a5978 ffff88007b593da0 ffffffff81252de9 ffff88007b593db0
[    6.536501] Call Trace:
[    6.536501]  [<ffffffff81252d9e>] paravirt_read_tsc+0xe/0x12
[    6.536501]  [<ffffffff81252e8a>] delay_tsc+0x46/0xa3
[    6.536501]  [<ffffffff81252de9>] __delay+0xf/0x11
[    6.536501]  [<ffffffff81252e17>] __const_udelay+0x2c/0x2e
[    6.536501]  [<ffffffff81028121>] arch_trigger_all_cpu_backtrace+0x76/0x89
[    6.536501]  [<ffffffff812584f1>] do_raw_spin_lock+0x117/0x142
[    6.536501]  [<ffffffff81504542>] _raw_spin_lock_irq+0x6f/0x82
[    6.536501]  [<ffffffff81076765>] ? worker_thread+0x38/0x15d
[    6.536501]  [<ffffffff81076765>] worker_thread+0x38/0x15d
[    6.536501]  [<ffffffff8107672d>] ? manage_workers+0x176/0x176
[    6.536501]  [<ffffffff8107a1cd>] kthread+0xa8/0xb0
[    6.536501]  [<ffffffff8150dd84>] kernel_thread_helper+0x4/0x10
[    6.536501]  [<ffffffff815051f4>] ? retint_restore_args+0x13/0x13
[    6.536501]  [<ffffffff8107a125>] ? __init_kthread_worker+0x5a/0x5a
[    6.536501]  [<ffffffff8150dd80>] ? gs_change+0x13/0x13
[    6.536501] Code: d5 23 00 5d c3 90 90 90 55 40 88 f8 48 89 e5 e6 70 e4 71 5d c3 55 40 88 f0 48 89 e5 e6 70 40 88 f8 e6 71 5d c3 55 48 89 e5 0f 31
[    6.536501]  c1 48 89 d0 48 c1 e0 20 48 09 c8 5d c3 55 b2 0b 88 d0 48 89
[    6.536501] Call Trace:
[    6.536501]  [<ffffffff81252d9e>] paravirt_read_tsc+0xe/0x12
[    6.536501]  [<ffffffff81252e8a>] delay_tsc+0x46/0xa3
[    6.536501]  [<ffffffff81252de9>] __delay+0xf/0x11
[    6.536501]  [<ffffffff81252e17>] __const_udelay+0x2c/0x2e
[    6.536501]  [<ffffffff81028121>] arch_trigger_all_cpu_backtrace+0x76/0x89
[    6.536501]  [<ffffffff812584f1>] do_raw_spin_lock+0x117/0x142
[    6.536501]  [<ffffffff81504542>] _raw_spin_lock_irq+0x6f/0x82
[    6.536501]  [<ffffffff81076765>] ? worker_thread+0x38/0x15d
[    6.536501]  [<ffffffff81076765>] worker_thread+0x38/0x15d
[    6.536501]  [<ffffffff8107672d>] ? manage_workers+0x176/0x176
[    6.536501]  [<ffffffff8107a1cd>] kthread+0xa8/0xb0
[    6.536501]  [<ffffffff8150dd84>] kernel_thread_helper+0x4/0x10
[    6.536501]  [<ffffffff815051f4>] ? retint_restore_args+0x13/0x13
[    6.536501]  [<ffffffff8107a125>] ? __init_kthread_worker+0x5a/0x5a
[    6.536501]  [<ffffffff8150dd80>] ? gs_change+0x13/0x13
[    6.705028] NMI backtrace for cpu 3
[    6.705028] CPU 3
[    6.705028] Modules linked in: megaraid_sas
[    6.705028]
[    6.705028] Pid: 34, comm: kworker/3:1 Tainted: G        W   3.1.0-0.rc5.git0.0.fc16.x86_64 #1 Intel Corporation S3210SH/S3210SH
[    6.705028] RIP: 0010:[<ffffffff812584ba>]  [<ffffffff812584ba>] do_raw_spin_lock+0xe0/0x142
[    6.705028] RSP: 0018:ffff88007b23d9e0  EFLAGS: 00000002
[    6.705028] RAX: ffff88007b23dfd8 RBX: ffff88007f20de80 RCX: 000000000fa01870
[    6.705028] RDX: 0000000000000001 RSI: ffffffff81074dbc RDI: 0000000000000001
[    6.705028] RBP: ffff88007b23da20 R08: 0000000000000002 R09: 0000000000000001
[    6.705028] R10: 0000000000000001 R11: ffff880076ab82c8 R12: ffff88007b240000
[    6.705028] R13: 000000009e8a5978 R14: ffff88007b240470 R15: 000000009e4d3953
[    6.705028] FS:  0000000000000000(0000) GS:ffff88007f800000(0000) knlGS:0000000000000000
[    6.705028] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    6.705028] CR2: 00007fac306bb000 CR3: 000000007b661000 CR4: 00000000000406e0
[    6.705028] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    6.705028] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[    6.705028] Process kworker/3:1 (pid: 34, threadinfo ffff88007b23c000, task ffff88007b240000)
[    6.705028] Stack:
[    6.705028]  ffff88007f20de98 0000000000000001 ffff88007b23da00 ffff88007f20de80
[    6.705028]  ffff88007f20de98 ffff880076ab82c8 ffffffff81b75130 ffff880076ab8318
[    6.705028]  ffff88007b23da50 ffffffff81504542 ffffffff81074dbc ffffffff810152c2
[    6.705028] Call Trace:
[    6.705028]  [<ffffffff81504542>] _raw_spin_lock_irq+0x6f/0x82
[    6.705028]  [<ffffffff81074dbc>] ? wait_on_cpu_work+0x2f/0xa7
[    6.705028]  [<ffffffff810152c2>] ? sched_clock+0x9/0xd
[    6.705028]  [<ffffffff81074dbc>] wait_on_cpu_work+0x2f/0xa7
[    6.705028]  [<ffffffff8108bbda>] ? look_up_lock_class+0x5f/0xc3
[    6.705028]  [<ffffffff81014ded>] ? paravirt_read_tsc+0x9/0xd
[    6.705028]  [<ffffffff81074e34>] ? wait_on_cpu_work+0xa7/0xa7
[    6.705028]  [<ffffffff8108f06f>] ? lock_acquire+0x10f/0x13e
[    6.705028]  [<ffffffff81074e34>] ? wait_on_cpu_work+0xa7/0xa7
[    6.705028]  [<ffffffff8108ef33>] ? lock_release+0x1b1/0x1de
[    6.705028]  [<ffffffff81074ecc>] wait_on_work+0x98/0xc7
[    6.705028]  [<ffffffff81074e34>] ? wait_on_cpu_work+0xa7/0xa7
[    6.705028]  [<ffffffff81259f46>] ? debug_object_activate+0x36/0xda
[    6.705028]  [<ffffffff81075fc3>] __cancel_work_timer+0xcc/0x10a
[    6.705028]  [<ffffffff81076013>] cancel_delayed_work_sync+0x12/0x14
[    6.705028]  [<ffffffff8136c7b4>] hub_quiesce+0x29/0x9a
[    6.705028]  [<ffffffff8136c901>] hub_suspend+0xb9/0xd1
[    6.705028]  [<ffffffff81504d90>] ? _raw_spin_unlock_irqrestore+0x3e/0x61
[    6.705028]  [<ffffffff813758fa>] usb_suspend_both+0x98/0x1d3
[    6.705028]  [<ffffffff81376372>] ? usb_probe_device+0x5f/0x5f
[    6.705028]  [<ffffffff813763a5>] usb_runtime_suspend+0x33/0x41
[    6.705028]  [<ffffffff8131e816>] rpm_callback+0x48/0x72
[    6.705028]  [<ffffffff8131eaac>] ? pm_runtime_autosuspend_expiration+0x56/0x7b
[    6.705028]  [<ffffffff8131ed91>] rpm_suspend+0x24c/0x3a8
[    6.705028]  [<ffffffff8131fa92>] ? pm_schedule_suspend+0xb1/0xb1
[    6.705028]  [<ffffffff8131fa92>] ? pm_schedule_suspend+0xb1/0xb1
[    6.705028]  [<ffffffff8131fb1a>] pm_runtime_work+0x88/0xa1
[    6.705028]  [<ffffffff81075b59>] process_one_work+0x205/0x3e7
[    6.705028]  [<ffffffff81075aa1>] ? process_one_work+0x14d/0x3e7
[    6.705028]  [<ffffffff8108cf2b>] ? lock_acquired+0x210/0x243
[    6.705028]  [<ffffffff81076807>] worker_thread+0xda/0x15d
[    6.705028]  [<ffffffff8107672d>] ? manage_workers+0x176/0x176
[    6.705028]  [<ffffffff8107a1cd>] kthread+0xa8/0xb0
[    6.705028]  [<ffffffff8150dd84>] kernel_thread_helper+0x4/0x10
[    6.705028]  [<ffffffff815051f4>] ? retint_restore_args+0x13/0x13
[    6.705028]  [<ffffffff8107a125>] ? __init_kthread_worker+0x5a/0x5a
[    6.705028]  [<ffffffff8150dd80>] ? gs_change+0x13/0x13
[    6.705028] Code: 00 01 00 75 04 f0 0f b1 0b 0f 94 c1 0f b6 c1 85 c0 75 53 bf 01 00 00 00 89 55 c8 49 ff c7 e8 28 a9 ff ff 8b 55 c8 eb 03 45 31 ff <4d> 39 ef 72 c4 85 d2 74 f4 41 8b 8c 24 bc 02 00 00 4c 89 f2 49
[    6.705028] Call Trace:
[    6.705028]  [<ffffffff81504542>] _raw_spin_lock_irq+0x6f/0x82
[    6.705028]  [<ffffffff81074dbc>] ? wait_on_cpu_work+0x2f/0xa7
[    6.705028]  [<ffffffff810152c2>] ? sched_clock+0x9/0xd
[    6.705028]  [<ffffffff81074dbc>] wait_on_cpu_work+0x2f/0xa7
[    6.705028]  [<ffffffff8108bbda>] ? look_up_lock_class+0x5f/0xc3
[    6.705028]  [<ffffffff81014ded>] ? paravirt_read_tsc+0x9/0xd
[    6.705028]  [<ffffffff81074e34>] ? wait_on_cpu_work+0xa7/0xa7
[    6.705028]  [<ffffffff8108f06f>] ? lock_acquire+0x10f/0x13e
[    6.705028]  [<ffffffff81074e34>] ? wait_on_cpu_work+0xa7/0xa7
[    6.705028]  [<ffffffff8108ef33>] ? lock_release+0x1b1/0x1de
[    6.705028]  [<ffffffff81074ecc>] wait_on_work+0x98/0xc7
[    6.705028]  [<ffffffff81074e34>] ? wait_on_cpu_work+0xa7/0xa7
[    6.705028]  [<ffffffff81259f46>] ? debug_object_activate+0x36/0xda
[    6.705028]  [<ffffffff81075fc3>] __cancel_work_timer+0xcc/0x10a
[    6.705028]  [<ffffffff81076013>] cancel_delayed_work_sync+0x12/0x14
[    6.705028]  [<ffffffff8136c7b4>] hub_quiesce+0x29/0x9a
[    6.705028]  [<ffffffff8136c901>] hub_suspend+0xb9/0xd1
[    6.705028]  [<ffffffff81504d90>] ? _raw_spin_unlock_irqrestore+0x3e/0x61
[    6.705028]  [<ffffffff813758fa>] usb_suspend_both+0x98/0x1d3
[    6.705028]  [<ffffffff81376372>] ? usb_probe_device+0x5f/0x5f
[    6.705028]  [<ffffffff813763a5>] usb_runtime_suspend+0x33/0x41
[    6.705028]  [<ffffffff8131e816>] rpm_callback+0x48/0x72
[    6.705028]  [<ffffffff8131eaac>] ? pm_runtime_autosuspend_expiration+0x56/0x7b
[    6.705028]  [<ffffffff8131ed91>] rpm_suspend+0x24c/0x3a8
[    6.705028]  [<ffffffff8131fa92>] ? pm_schedule_suspend+0xb1/0xb1
[    6.705028]  [<ffffffff8131fa92>] ? pm_schedule_suspend+0xb1/0xb1
[    6.705028]  [<ffffffff8131fb1a>] pm_runtime_work+0x88/0xa1
[    6.705028]  [<ffffffff81075b59>] process_one_work+0x205/0x3e7
[    6.705028]  [<ffffffff81075aa1>] ? process_one_work+0x14d/0x3e7
[    6.705028]  [<ffffffff8108cf2b>] ? lock_acquired+0x210/0x243
[    6.705028]  [<ffffffff81076807>] worker_thread+0xda/0x15d
[    6.705028]  [<ffffffff8107672d>] ? manage_workers+0x176/0x176
[    6.705028]  [<ffffffff8107a1cd>] kthread+0xa8/0xb0
[    6.705028]  [<ffffffff8150dd84>] kernel_thread_helper+0x4/0x10
[    6.705028]  [<ffffffff815051f4>] ? retint_restore_args+0x13/0x13
[    6.705028]  [<ffffffff8107a125>] ? __init_kthread_worker+0x5a/0x5a
[    6.705028]  [<ffffffff8150dd80>] ? gs_change+0x13/0x13
[    6.536516] NMI backtrace for cpu 1
[    6.536516] CPU 1
[    6.536516] Modules linked in: megaraid_sas
[    6.536516]
[    6.536516] Pid: 242, comm: scsi_scan_0 Tainted: G        W   3.1.0-0.rc5.git0.0.fc16.x86_64 #1 Intel Corporation S3210SH/S3210SH
[    6.536516] RIP: 0010:[<ffffffff8101589f>]  [<ffffffff8101589f>] native_read_tsc+0x6/0x14
[    6.536516] RSP: 0018:ffff88007333f8b8  EFLAGS: 00000006
[    6.536516] RAX: 000000000fa018b0 RBX: ffff88007333ffd8 RCX: 000000000fa01860
[    6.536516] RDX: 00000000000000b2 RSI: ffff88007f20de98 RDI: 0000000000000001
[    6.536516] RBP: ffff88007333f8b8 R08: 0000000000000002 R09: 0000000000000001
[    6.536516] R10: ffff88007f40a000 R11: ffff8800769432c8 R12: 000000000fa01860
[    6.536516] R13: 0000000000000001 R14: 0000000000000001 R15: 000000009e7911ae
[    6.536516] FS:  0000000000000000(0000) GS:ffff88007f400000(0000) knlGS:0000000000000000
[    6.536516] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    6.536516] CR2: 00007f33c8a01000 CR3: 0000000001a05000 CR4: 00000000000406e0
[    6.536516] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    6.536516] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[    6.536516] Process scsi_scan_0 (pid: 242, threadinfo ffff88007333e000, task ffff880073ec24d0)
[    6.536516] Stack:
[    6.536516]  ffff88007333f8c8 ffffffff81252d9e ffff88007333f900 ffffffff81252e8a
[    6.536516]  ffff88007f20de80 ffff880073ec24d0 000000009e8a5978 ffff880073ec2940
[    6.536516]  000000009e7911ae ffff88007333f910 ffffffff81252de9 ffff88007333f960
[    6.536516] Call Trace:
[    6.536516]  [<ffffffff81252d9e>] paravirt_read_tsc+0xe/0x12
[    6.536516]  [<ffffffff81252e8a>] delay_tsc+0x46/0xa3
[    6.536516]  [<ffffffff81252de9>] __delay+0xf/0x11
[    6.536516]  [<ffffffff812584b2>] do_raw_spin_lock+0xd8/0x142
[    6.536516]  [<ffffffff81504542>] _raw_spin_lock_irq+0x6f/0x82
[    6.536516]  [<ffffffff81074dbc>] ? wait_on_cpu_work+0x2f/0xa7
[    6.536516]  [<ffffffff81074dbc>] wait_on_cpu_work+0x2f/0xa7
[    6.536516]  [<ffffffff8108b8c5>] ? trace_hardirqs_off+0xd/0xf
[    6.536516]  [<ffffffff81074e34>] ? wait_on_cpu_work+0xa7/0xa7
[    6.536516]  [<ffffffff8108f06f>] ? lock_acquire+0x10f/0x13e
[    6.536516]  [<ffffffff81074e34>] ? wait_on_cpu_work+0xa7/0xa7
[    6.536516]  [<ffffffff8108ef33>] ? lock_release+0x1b1/0x1de
[    6.536516]  [<ffffffff81074ecc>] wait_on_work+0x98/0xc7
[    6.536516]  [<ffffffff81074e34>] ? wait_on_cpu_work+0xa7/0xa7
[    6.536516]  [<ffffffff8106a25a>] ? try_to_del_timer_sync+0x73/0x81
[    6.705028] BUG: spinlock lockup on CPU#3, kworker/3:1/34, ffff88007f20de80
[    6.705028] Pid: 34, comm: kworker/3:1 Tainted: G        W   3.1.0-0.rc5.git0.0.fc16.x86_64 #1
[    6.705028] Call Trace:
[    6.705028]  [<ffffffff812584ec>] do_raw_spin_lock+0x112/0x142
[    6.705028]  [<ffffffff81504542>] _raw_spin_lock_irq+0x6f/0x82
[    6.705028]  [<ffffffff81074dbc>] ? wait_on_cpu_work+0x2f/0xa7
[    6.705028]  [<ffffffff810152c2>] ? sched_clock+0x9/0xd
[    6.705028]  [<ffffffff81074dbc>] wait_on_cpu_work+0x2f/0xa7
[    6.705028]  [<ffffffff8108bbda>] ? look_up_lock_class+0x5f/0xc3
[    6.705028]  [<ffffffff81014ded>] ? paravirt_read_tsc+0x9/0xd
[    6.705028]  [<ffffffff81074e34>] ? wait_on_cpu_work+0xa7/0xa7
[    6.705028]  [<ffffffff8108f06f>] ? lock_acquire+0x10f/0x13e
[    6.705028]  [<ffffffff81074e34>] ? wait_on_cpu_work+0xa7/0xa7
[    6.705028]  [<ffffffff8108ef33>] ? lock_release+0x1b1/0x1de
[    6.705028]  [<ffffffff81074ecc>] wait_on_work+0x98/0xc7
[    6.705028]  [<ffffffff81074e34>] ? wait_on_cpu_work+0xa7/0xa7
[    6.705028]  [<ffffffff81259f46>] ? debug_object_activate+0x36/0xda
[    6.705028]  [<ffffffff81075fc3>] __cancel_work_timer+0xcc/0x10a
[    6.705028]  [<ffffffff81076013>] cancel_delayed_work_sync+0x12/0x14
[    6.705028]  [<ffffffff8136c7b4>] hub_quiesce+0x29/0x9a
[    6.705028]  [<ffffffff8136c901>] hub_suspend+0xb9/0xd1
[    6.705028]  [<ffffffff81504d90>] ? _raw_spin_unlock_irqrestore+0x3e/0x61
[    6.705028]  [<ffffffff813758fa>] usb_suspend_both+0x98/0x1d3
[    6.705028]  [<ffffffff81376372>] ? usb_probe_device+0x5f/0x5f
[    6.705028]  [<ffffffff813763a5>] usb_runtime_suspend+0x33/0x41
[    6.705028]  [<ffffffff8131e816>] rpm_callback+0x48/0x72
[    6.705028]  [<ffffffff8131eaac>] ? pm_runtime_autosuspend_expiration+0x56/0x7b
[    6.705028]  [<ffffffff8131ed91>] rpm_suspend+0x24c/0x3a8
[    6.705028]  [<ffffffff8131fa92>] ? pm_schedule_suspend+0xb1/0xb1
[    6.705028]  [<ffffffff8131fa92>] ? pm_schedule_suspend+0xb1/0xb1
[    6.705028]  [<ffffffff8131fb1a>] pm_runtime_work+0x88/0xa1
[    6.705028]  [<ffffffff81075b59>] process_one_work+0x205/0x3e7
[    6.705028]  [<ffffffff81075aa1>] ? process_one_work+0x14d/0x3e7
[    6.705028]  [<ffffffff8108cf2b>] ? lock_acquired+0x210/0x243
[    6.705028]  [<ffffffff81076807>] worker_thread+0xda/0x15d
[    6.705028]  [<ffffffff8107672d>] ? manage_workers+0x176/0x176
[    6.705028]  [<ffffffff8107a1cd>] kthread+0xa8/0xb0
[    6.705028]  [<ffffffff8150dd84>] kernel_thread_helper+0x4/0x10
[    6.705028]  [<ffffffff815051f4>] ? retint_restore_args+0x13/0x13
[    6.705028]  [<ffffffff8107a125>] ? __init_kthread_worker+0x5a/0x5a
[    6.705028]  [<ffffffff8150dd80>] ? gs_change+0x13/0x13
[    6.536516]  [<ffffffff81075fc3>] __cancel_work_timer+0xcc/0x10a
[    6.536516]  [<ffffffff81076013>] cancel_delayed_work_sync+0x12/0x14
[    6.536516]  [<ffffffff81231665>] blk_sync_queue+0x27/0x2c
[    6.536516]  [<ffffffff81231685>] blk_cleanup_queue+0x1b/0x68
[    6.536516]  [<ffffffff81330292>] scsi_free_queue+0xe/0x10
[    6.536516]  [<ffffffff813339da>] __scsi_remove_device+0xac/0xb9
[    6.536516]  [<ffffffff81331910>] scsi_probe_and_add_lun+0xa6e/0xaab
[    6.536516]  [<ffffffff81331b5d>] __scsi_scan_target+0xb6/0x5d2
[    6.536516]  [<ffffffff8108f352>] ? mark_held_locks+0x6d/0x95
[    6.536516]  [<ffffffff81504d97>] ? _raw_spin_unlock_irqrestore+0x45/0x61
[    6.536516]  [<ffffffff8108f49b>] ? trace_hardirqs_on_caller+0x121/0x158
[    6.536516]  [<ffffffff813320d0>] scsi_scan_channel.part.2+0x57/0x72
[    6.536516]  [<ffffffff813323da>] scsi_scan_host_selected+0x109/0x191
[    6.536516]  [<ffffffff813324d7>] ? do_scsi_scan_host+0x75/0x75
[    6.536516]  [<ffffffff813324d2>] do_scsi_scan_host+0x70/0x75
[    6.536516]  [<ffffffff813324fa>] do_scan_async+0x23/0x142
[    6.536516]  [<ffffffff813324d7>] ? do_scsi_scan_host+0x75/0x75
[    6.536516]  [<ffffffff813324d7>] ? do_scsi_scan_host+0x75/0x75
[    6.536516]  [<ffffffff8107a1cd>] kthread+0xa8/0xb0
[    6.536516]  [<ffffffff8150dd84>] kernel_thread_helper+0x4/0x10
[    6.536516]  [<ffffffff815051f4>] ? retint_restore_args+0x13/0x13
[    6.536516]  [<ffffffff8107a125>] ? __init_kthread_worker+0x5a/0x5a
[    6.536516]  [<ffffffff8150dd80>] ? gs_change+0x13/0x13
[    6.536516] Code: d5 23 00 5d c3 90 90 90 55 40 88 f8 48 89 e5 e6 70 e4 71 5d c3 55 40 88 f0 48 89 e5 e6 70 40 88 f8 e6 71 5d c3 55 48 89 e5 0f 31
[    6.536516]  c1 48 89 d0 48 c1 e0 20 48 09 c8 5d c3 55 b2 0b 88 d0 48 89
[    6.536516] Call Trace:
[    6.536516]  [<ffffffff81252d9e>] paravirt_read_tsc+0xe/0x12
[    6.536516]  [<ffffffff81252e8a>] delay_tsc+0x46/0xa3
[    6.536516]  [<ffffffff81252de9>] __delay+0xf/0x11
[    6.536516]  [<ffffffff812584b2>] do_raw_spin_lock+0xd8/0x142
[    6.536516]  [<ffffffff81504542>] _raw_spin_lock_irq+0x6f/0x82
[    6.536516]  [<ffffffff81074dbc>] ? wait_on_cpu_work+0x2f/0xa7
[    6.536516]  [<ffffffff81074dbc>] wait_on_cpu_work+0x2f/0xa7
[    6.536516]  [<ffffffff8108b8c5>] ? trace_hardirqs_off+0xd/0xf
[    6.536516]  [<ffffffff81074e34>] ? wait_on_cpu_work+0xa7/0xa7
[    6.536516]  [<ffffffff8108f06f>] ? lock_acquire+0x10f/0x13e
[    6.536516]  [<ffffffff81074e34>] ? wait_on_cpu_work+0xa7/0xa7
[    6.536516]  [<ffffffff8108ef33>] ? lock_release+0x1b1/0x1de
[    6.536516]  [<ffffffff81074ecc>] wait_on_work+0x98/0xc7
[    6.536516]  [<ffffffff81074e34>] ? wait_on_cpu_work+0xa7/0xa7
[    6.536516]  [<ffffffff8106a25a>] ? try_to_del_timer_sync+0x73/0x81
[    6.536516]  [<ffffffff81075fc3>] __cancel_work_timer+0xcc/0x10a
[    6.536516]  [<ffffffff81076013>] cancel_delayed_work_sync+0x12/0x14
[    6.536516]  [<ffffffff81231665>] blk_sync_queue+0x27/0x2c
[    6.536516]  [<ffffffff81231685>] blk_cleanup_queue+0x1b/0x68
[    6.536516]  [<ffffffff81330292>] scsi_free_queue+0xe/0x10
[    6.536516]  [<ffffffff813339da>] __scsi_remove_device+0xac/0xb9
[    6.536516]  [<ffffffff81331910>] scsi_probe_and_add_lun+0xa6e/0xaab
[    6.536516]  [<ffffffff81331b5d>] __scsi_scan_target+0xb6/0x5d2
[    6.536516]  [<ffffffff8108f352>] ? mark_held_locks+0x6d/0x95
[    6.536516]  [<ffffffff81504d97>] ? _raw_spin_unlock_irqrestore+0x45/0x61
[    6.536516]  [<ffffffff8108f49b>] ? trace_hardirqs_on_caller+0x121/0x158
[    6.536516]  [<ffffffff813320d0>] scsi_scan_channel.part.2+0x57/0x72
[    6.536516]  [<ffffffff813323da>] scsi_scan_host_selected+0x109/0x191
[    6.536516]  [<ffffffff813324d7>] ? do_scsi_scan_host+0x75/0x75
[    6.536516]  [<ffffffff813324d2>] do_scsi_scan_host+0x70/0x75
[    6.536516]  [<ffffffff813324fa>] do_scan_async+0x23/0x142
[    6.536516]  [<ffffffff813324d7>] ? do_scsi_scan_host+0x75/0x75
[    6.536516]  [<ffffffff813324d7>] ? do_scsi_scan_host+0x75/0x75
[    6.536516]  [<ffffffff8107a1cd>] kthread+0xa8/0xb0
[    6.536516]  [<ffffffff8150dd84>] kernel_thread_helper+0x4/0x10
[    6.536516]  [<ffffffff815051f4>] ? retint_restore_args+0x13/0x13
[    6.536516]  [<ffffffff8107a125>] ? __init_kthread_worker+0x5a/0x5a
[    6.536516]  [<ffffffff8150dd80>] ? gs_change+0x13/0x13
[  185.579002] NMI backtrace for cpu 2
[  185.579002] CPU 2
[  185.579002] Modules linked in: megaraid_sas
[  185.579002]
[  185.579002] Pid: 0, comm: kworker/0:1 Tainted: G        W   3.1.0-0.rc5.git0.0.fc16.x86_64 #1 Intel Corporation S3210SH/S3210SH
[  185.579002] RIP: 0010:[<ffffffff810161d5>]  [<ffffffff810161d5>] mwait_idle+0x8c/0xc3
[  185.579002] RSP: 0018:ffff88007b5b7ee8  EFLAGS: 00000246
[  185.579002] RAX: 0000000000000000 RBX: ffff88007b5b7fd8 RCX: 0000000000000000
[  185.579002] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff810161cc
[  185.579002] RBP: ffff88007b5b7ee8 R08: 0000000000000000 R09: 00000000001edc00
[  185.579002] R10: 00000000001edc00 R11: 0000000000000424 R12: ffffffff81b750f0
[    6.536516] BUG: spinlock lockup on CPU#1, scsi_scan_0/242, ffff88007f20de80
[    6.536516] Pid: 242, comm: scsi_scan_0 Tainted: G        W   3.1.0-0.rc5.git0.0.fc16.x86_64 #1
[    6.536516] Call Trace:
[    6.536516]  [<ffffffff812584ec>] do_raw_spin_lock+0x112/0x142
[    6.536516]  [<ffffffff81504542>] _raw_spin_lock_irq+0x6f/0x82
[    6.536516]  [<ffffffff81074dbc>] ? wait_on_cpu_work+0x2f/0xa7
[    6.536516]  [<ffffffff81074dbc>] wait_on_cpu_work+0x2f/0xa7
[    6.536516]  [<ffffffff8108b8c5>] ? trace_hardirqs_off+0xd/0xf
[    6.536516]  [<ffffffff81074e34>] ? wait_on_cpu_work+0xa7/0xa7
[    6.536516]  [<ffffffff8108f06f>] ? lock_acquire+0x10f/0x13e
[    6.536516]  [<ffffffff81074e34>] ? wait_on_cpu_work+0xa7/0xa7
[    6.536516]  [<ffffffff8108ef33>] ? lock_release+0x1b1/0x1de
[    6.536516]  [<ffffffff81074ecc>] wait_on_work+0x98/0xc7
[    6.536516]  [<ffffffff81074e34>] ? wait_on_cpu_work+0xa7/0xa7
[    6.536516]  [<ffffffff8106a25a>] ? try_to_del_timer_sync+0x73/0x81
[    6.536516]  [<ffffffff81075fc3>] __cancel_work_timer+0xcc/0x10a
[    6.536516]  [<ffffffff81076013>] cancel_delayed_work_sync+0x12/0x14
[    6.536516]  [<ffffffff81231665>] blk_sync_queue+0x27/0x2c
[    6.536516]  [<ffffffff81231685>] blk_cleanup_queue+0x1b/0x68
[    6.536516]  [<ffffffff81330292>] scsi_free_queue+0xe/0x10
[    6.536516]  [<ffffffff813339da>] __scsi_remove_device+0xac/0xb9
[    6.536516]  [<ffffffff81331910>] scsi_probe_and_add_lun+0xa6e/0xaab
[    6.536516]  [<ffffffff81331b5d>] __scsi_scan_target+0xb6/0x5d2
[    6.536516]  [<ffffffff8108f352>] ? mark_held_locks+0x6d/0x95
[    6.536516]  [<ffffffff81504d97>] ? _raw_spin_unlock_irqrestore+0x45/0x61
[    6.536516]  [<ffffffff8108f49b>] ? trace_hardirqs_on_caller+0x121/0x158
[    6.536516]  [<ffffffff813320d0>] scsi_scan_channel.part.2+0x57/0x72
[    6.536516]  [<ffffffff813323da>] scsi_scan_host_selected+0x109/0x191
[    6.536516]  [<ffffffff813324d7>] ? do_scsi_scan_host+0x75/0x75
[    6.536516]  [<ffffffff813324d2>] do_scsi_scan_host+0x70/0x75
[    6.536516]  [<ffffffff813324fa>] do_scan_async+0x23/0x142
[    6.536516]  [<ffffffff813324d7>] ? do_scsi_scan_host+0x75/0x75
[    6.536516]  [<ffffffff813324d7>] ? do_scsi_scan_host+0x75/0x75
[    6.536516]  [<ffffffff8107a1cd>] kthread+0xa8/0xb0
[    6.536516]  [<ffffffff8150dd84>] kernel_thread_helper+0x4/0x10
[    6.536516]  [<ffffffff815051f4>] ? retint_restore_args+0x13/0x13
[    6.536516]  [<ffffffff8107a125>] ? __init_kthread_worker+0x5a/0x5a
[    6.536516]  [<ffffffff8150dd80>] ? gs_change+0x13/0x13
[  185.579002] R13: ffff88007b5b6000 R14: 0000000000000000 R15: 0000000000000000
[  185.579002] FS:  0000000000000000(0000) GS:ffff88007f600000(0000) knlGS:0000000000000000
[  185.579002] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  185.579002] CR2: 00007f33c7bee228 CR3: 00000000748fc000 CR4: 00000000000406e0
[  185.579002] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  185.579002] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  185.579002] Process kworker/0:1 (pid: 0, threadinfo ffff88007b5b6000, task ffff88007b5bc9a0)
[  185.579002] Stack:
[  185.579002]  ffff88007b5b7f28 ffffffff8100e2f9 0000000000000000 690178187559c88e
[  185.579002]  ffff88007b5b7f18 0000000000000000 0000000000000000 0000000000000000
[  185.579002]  ffff88007b5b7f48 ffffffff814f0ea3 0000000000000000 a27aca25c7b80ed2
[  185.579002] Call Trace:
[  185.579002]  [<ffffffff8100e2f9>] cpu_idle+0xb5/0x101
[  185.579002]  [<ffffffff814f0ea3>] start_secondary+0x25d/0x25f
[  185.579002] Code: 25 48 c4 00 00 48 89 d1 48 2d c8 1f 00 00 0f 01 c8 0f ae f0 e8 38 fb ff ff 85 c0 75 10 e8 06 93 07 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 0a e8 f6 92 07 00 e8 d8 fa ff ff 65 8b 3c 25 20 d4 00 00 e8
[  185.579002] Call Trace:
[  185.579002]  [<ffffffff8100e2f9>] cpu_idle+0xb5/0x101
[  185.579002]  [<ffffffff814f0ea3>] start_secondary+0x25d/0x25f

Full dmesg http://pastebin.com/CFEJNe8h

M.Murawski



