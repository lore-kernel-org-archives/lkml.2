Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758049Ab2IEBMK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 21:12:10 -0400
Received: from mga11.intel.com ([192.55.52.93]:13612 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752847Ab2IEBMA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 21:12:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,371,1344236400"; 
   d="scan'208";a="218142142"
Date: Wed, 5 Sep 2012 09:11:52 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: x86@kernel.org
Subject: WARNING: cpu_is_offline() at native_smp_send_reschedule()
Message-ID: <20120905011152.GA19853@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="bp/iNruPH9dso1Pn"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bp/iNruPH9dso1Pn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

Here is an old problem that happens also in 3.4. It's very unreliable:
it may only happen once per 3000 boots..

[   10.968565] reboot: machine restart
[   10.983510] ------------[ cut here ]------------
[   10.984218] WARNING: at /c/kernel-tests/src/stable/arch/x86/kernel/smp.c:123 native_smp_send_reschedule+0x46/0x50()
[   10.985880] Pid: 88, comm: kpktgend_0 Not tainted 3.6.0-rc3-00005-gb374aa1 #10
[   10.987185] Call Trace:
[   10.987506]  [<7902f42a>] warn_slowpath_common+0x5a/0x80
[   10.987506]  [<7901ee16>] ? native_smp_send_reschedule+0x46/0x50
[   10.987506]  [<7901ee16>] ? native_smp_send_reschedule+0x46/0x50
[   10.987506]  [<7902f4fd>] warn_slowpath_null+0x1d/0x20
[   10.987506]  [<7901ee16>] native_smp_send_reschedule+0x46/0x50
[   10.987506]  [<7905fdad>] trigger_load_balance+0x1bd/0x250
[   10.987506]  [<79056d14>] scheduler_tick+0xd4/0x100
[   10.987506]  [<7903bde5>] update_process_times+0x55/0x70
[   10.987506]  [<79071187>] tick_sched_timer+0x57/0xb0
[   10.987506]  [<793accee>] ? do_raw_spin_unlock+0x4e/0x90
[   10.987506]  [<7904e0b7>] __run_hrtimer.isra.29+0x57/0x100
[   10.987506]  [<79071130>] ? tick_nohz_handler+0xe0/0xe0
[   10.987506]  [<7904ed45>] hrtimer_interrupt+0xe5/0x280
[   10.987506]  [<7905a5a7>] ? sched_clock_cpu+0xc7/0x150
[   10.987506]  [<7901f9a4>] smp_apic_timer_interrupt+0x54/0x90
[   10.987506]  [<79882631>] apic_timer_interrupt+0x31/0x40
[   10.987506]  [<7905007b>] ? call_srcu+0x2b/0x70
[   10.987506]  [<793a00e0>] ? __bitmap_intersects+0x10/0x80
[   10.987506]  [<7988194f>] ? _raw_spin_unlock_irq+0x1f/0x40
[   10.987506]  [<7905307f>] finish_task_switch+0x7f/0xd0
[   10.987506]  [<79053038>] ? finish_task_switch+0x38/0xd0
[   10.987506]  [<7988044a>] __schedule+0x38a/0x770
[   10.987506]  [<7905a5a7>] ? sched_clock_cpu+0xc7/0x150
[   10.987506]  [<7987ea40>] ? schedule_timeout+0x100/0x1b0
[   10.987506]  [<793accee>] ? do_raw_spin_unlock+0x4e/0x90
[   10.987506]  [<7988084e>] schedule+0x1e/0x50
[   10.987506]  [<7987ea45>] schedule_timeout+0x105/0x1b0
[   10.987506]  [<7903adb0>] ? __internal_add_timer+0xb0/0xb0
[   10.987506]  [<796842f2>] pktgen_thread_worker+0x1342/0x1390
[   10.987506]  [<7988044a>] ? __schedule+0x38a/0x770
[   10.987506]  [<793accee>] ? do_raw_spin_unlock+0x4e/0x90
[   10.987506]  [<793accee>] ? do_raw_spin_unlock+0x4e/0x90
[   10.987506]  [<7904aa40>] ? abort_exclusive_wait+0x80/0x80
[   10.987506]  [<7904aa40>] ? abort_exclusive_wait+0x80/0x80
[   10.987506]  [<79682fb0>] ? pktgen_if_write+0x2210/0x2210
[   10.987506]  [<79049ff8>] kthread+0x78/0x80
[   10.987506]  [<79880000>] ? __up.isra.0+0xd/0x2d
[   10.987506]  [<79049f80>] ? insert_kthread_work+0x70/0x70
[   10.987506]  [<798830c6>] kernel_thread_helper+0x6/0xd

Here are all the oops messages I collected in the past days:

[    4.815145] Restarting system.
[    4.815644] reboot: machine restart
[    4.824591] ------------[ cut here ]------------
[    4.825423] WARNING: at /c/wfg/linux/arch/x86/kernel/smp.c:123 native_smp_send_reschedule+0x46/0x50()
[    4.826881] Pid: 18, comm: kworker/0:1 Not tainted 3.6.0-rc3-bisect-00007-g6320675 #25
[    4.828116] Call Trace:
[    4.828533]  [<7902f42a>] warn_slowpath_common+0x5a/0x80
[    4.828585]  [<7901ee16>] ? native_smp_send_reschedule+0x46/0x50
[    4.828585]  [<7901ee16>] ? native_smp_send_reschedule+0x46/0x50
[    4.828585]  [<7902f4fd>] warn_slowpath_null+0x1d/0x20
[    4.828585]  [<7901ee16>] native_smp_send_reschedule+0x46/0x50
[    4.828585]  [<7905fdad>] trigger_load_balance+0x1bd/0x250
[    4.828585]  [<79056d14>] scheduler_tick+0xd4/0x100
[    4.828585]  [<7903bde5>] update_process_times+0x55/0x70
[    4.828585]  [<79071187>] tick_sched_timer+0x57/0xb0
[    4.828585]  [<793accee>] ? do_raw_spin_unlock+0x4e/0x90
[    4.828585]  [<7904e0b7>] __run_hrtimer.isra.29+0x57/0x100
[    4.828585]  [<79071130>] ? tick_nohz_handler+0xe0/0xe0
[    4.828585]  [<7904ed45>] hrtimer_interrupt+0xe5/0x280
[    4.828585]  [<7905a5a7>] ? sched_clock_cpu+0xc7/0x150
[    4.828585]  [<7901f9a4>] smp_apic_timer_interrupt+0x54/0x90
[    4.828585]  [<79882401>] apic_timer_interrupt+0x31/0x40
[    4.828585]  [<7905007b>] ? call_srcu+0x2b/0x70
[    4.828585]  [<793a00e0>] ? __bitmap_intersects+0x10/0x80
[    4.828585]  [<7988171f>] ? _raw_spin_unlock_irq+0x1f/0x40
[    4.828585]  [<7905307f>] finish_task_switch+0x7f/0xd0
[    4.828585]  [<79053038>] ? finish_task_switch+0x38/0xd0
[    4.828585]  [<7988021a>] __schedule+0x38a/0x770
[    4.828585]  [<79045529>] ? worker_thread+0x1a9/0x380
[    4.828585]  [<793accee>] ? do_raw_spin_unlock+0x4e/0x90
[    4.828585]  [<7988061e>] schedule+0x1e/0x50
[    4.828585]  [<7904552e>] worker_thread+0x1ae/0x380
[    4.828585]  [<79056ed9>] ? complete+0x49/0x60
[    4.828585]  [<79045380>] ? manage_workers.isra.23+0x250/0x250
[    4.828585]  [<79049ff8>] kthread+0x78/0x80
[    4.828585]  [<79880000>] ? __schedule+0x170/0x770
[    4.828585]  [<79049f80>] ? insert_kthread_work+0x70/0x70
[    4.828585]  [<79882e86>] kernel_thread_helper+0x6/0xd
[    4.828585] ---[ end trace ae11d0bb45464df2 ]---
--
[    9.195595] Restarting system.
[    9.196142] reboot: machine restart
[    9.228474] ------------[ cut here ]------------
[    9.229329] WARNING: at /c/wfg/linux/arch/x86/kernel/smp.c:123 native_smp_send_reschedule+0x46/0x50()
[    9.230890] Pid: 88, comm: kpktgend_0 Not tainted 3.6.0-rc3-bisect #28
[    9.232034] Call Trace:
[    9.232468]  [<7902f42a>] warn_slowpath_common+0x5a/0x80
[    9.232468]  [<7901ee16>] ? native_smp_send_reschedule+0x46/0x50
[    9.232468]  [<7901ee16>] ? native_smp_send_reschedule+0x46/0x50
[    9.232468]  [<7902f4fd>] warn_slowpath_null+0x1d/0x20
[    9.232468]  [<7901ee16>] native_smp_send_reschedule+0x46/0x50
[    9.232468]  [<7905fdad>] trigger_load_balance+0x1bd/0x250
[    9.232468]  [<79056d14>] scheduler_tick+0xd4/0x100
[    9.232468]  [<7903bde5>] update_process_times+0x55/0x70
[    9.232468]  [<79071187>] tick_sched_timer+0x57/0xb0
[    9.232468]  [<793accee>] ? do_raw_spin_unlock+0x4e/0x90
[    9.232468]  [<7904e0b7>] __run_hrtimer.isra.29+0x57/0x100
[    9.232468]  [<79071130>] ? tick_nohz_handler+0xe0/0xe0
[    9.232468]  [<7904ed45>] hrtimer_interrupt+0xe5/0x280
[    9.232468]  [<7905a5a7>] ? sched_clock_cpu+0xc7/0x150
[    9.232468]  [<7901f9a4>] smp_apic_timer_interrupt+0x54/0x90
[    9.232468]  [<79882401>] apic_timer_interrupt+0x31/0x40
[    9.232468]  [<7905007b>] ? call_srcu+0x2b/0x70
[    9.232468]  [<793a00e0>] ? __bitmap_intersects+0x10/0x80
[    9.232468]  [<7988171f>] ? _raw_spin_unlock_irq+0x1f/0x40
[    9.232468]  [<7905307f>] finish_task_switch+0x7f/0xd0
[    9.232468]  [<79053038>] ? finish_task_switch+0x38/0xd0
[    9.232468]  [<7988021a>] __schedule+0x38a/0x770
[    9.232468]  [<7905a5a7>] ? sched_clock_cpu+0xc7/0x150
[    9.232468]  [<7987e810>] ? schedule_timeout+0x100/0x1b0
[    9.232468]  [<793accee>] ? do_raw_spin_unlock+0x4e/0x90
[    9.232468]  [<7988061e>] schedule+0x1e/0x50
[    9.232468]  [<7987e815>] schedule_timeout+0x105/0x1b0
[    9.232468]  [<7903adb0>] ? __internal_add_timer+0xb0/0xb0
[    9.232468]  [<796840c2>] pktgen_thread_worker+0x1342/0x1390
[    9.232468]  [<7988021a>] ? __schedule+0x38a/0x770
[    9.232468]  [<793accee>] ? do_raw_spin_unlock+0x4e/0x90
[    9.232468]  [<7904aa40>] ? abort_exclusive_wait+0x80/0x80
[    9.232468]  [<7904aa40>] ? abort_exclusive_wait+0x80/0x80
[    9.232468]  [<79682d80>] ? pktgen_if_write+0x2210/0x2210
[    9.232468]  [<79049ff8>] kthread+0x78/0x80
[    9.232468]  [<79880000>] ? __schedule+0x170/0x770
[    9.232468]  [<79049f80>] ? insert_kthread_work+0x70/0x70
[    9.232468]  [<79882e86>] kernel_thread_helper+0x6/0xd
[    9.232468] ---[ end trace 4b6a1d80f6ec28ef ]---
--
[    4.665800] Restarting system.
[    4.666537] machine restart
[    4.682180] ------------[ cut here ]------------
[    4.683044] WARNING: at /c/wfg/linux/arch/x86/kernel/smp.c:120 native_smp_send_reschedule+0x46/0x50()
[    4.684515] Pid: 115, comm: reboot Not tainted 3.4.0-bisect #30
[    4.685459] Call Trace:
[    4.685919]  [<7984acc5>] ? printk+0x18/0x1a
[    4.686173]  [<7902ab6a>] warn_slowpath_common+0x5a/0x80
[    4.686173]  [<7901ac46>] ? native_smp_send_reschedule+0x46/0x50
[    4.686173]  [<7901ac46>] ? native_smp_send_reschedule+0x46/0x50
[    4.686173]  [<7902ac3d>] warn_slowpath_null+0x1d/0x20
[    4.686173]  [<7901ac46>] native_smp_send_reschedule+0x46/0x50
[    4.686173]  [<79058885>] trigger_load_balance+0x295/0x340
[    4.686173]  [<7904f43f>] scheduler_tick+0xcf/0x100
[    4.686173]  [<79035985>] update_process_times+0x55/0x70
[    4.686173]  [<7906979b>] tick_sched_timer+0x5b/0xc0
[    4.686173]  [<7939794e>] ? do_raw_spin_unlock+0x4e/0x90
[    4.686173]  [<79047167>] __run_hrtimer.isra.29+0x57/0x100
[    4.686173]  [<79069740>] ? tick_nohz_handler+0xe0/0xe0
[    4.686173]  [<79047dd5>] hrtimer_interrupt+0xd5/0x240
[    4.686173]  [<7901b844>] smp_apic_timer_interrupt+0x54/0x90
[    4.686173]  [<79858e31>] apic_timer_interrupt+0x31/0x40
[    4.686173]  [<793877be>] ? delay_tsc+0x3e/0xa0
[    4.686173]  [<7938785b>] __const_udelay+0x1b/0x20
[    4.686173]  [<7901adff>] native_nmi_stop_other_cpus+0xaf/0xe0
[    4.686173]  [<7901a237>] native_machine_shutdown+0x57/0x80
[    4.686173]  [<79021c79>] kvm_shutdown+0x19/0x20
[    4.686173]  [<7901a1c2>] native_machine_restart+0x22/0x40
[    4.686173]  [<7901a3f9>] machine_restart+0x9/0x10
[    4.686173]  [<7903a643>] kernel_restart+0x33/0x50
[    4.686173]  [<7903a86d>] sys_reboot+0x13d/0x1e0
[    4.686173]  [<79052cd7>] ? sched_clock_cpu+0xc7/0x150
[    4.686173]  [<7902409f>] ? do_page_fault+0x19f/0x3e0
[    4.686173]  [<79021b60>] ? kvm_read_and_reset_pf_reason+0x40/0x40
[    4.686173]  [<79048466>] ? up_read+0x16/0x30
[    4.686173]  [<7902409f>] ? do_page_fault+0x19f/0x3e0
[    4.686173]  [<790c805b>] ? iterate_supers+0xab/0xd0
[    4.686173]  [<7939794e>] ? do_raw_spin_unlock+0x4e/0x90
[    4.686173]  [<79857eed>] ? _raw_spin_unlock+0x1d/0x30
[    4.686173]  [<790c805b>] ? iterate_supers+0xab/0xd0
[    4.686173]  [<790e9bd0>] ? __sync_filesystem+0xa0/0xa0
[    4.686173]  [<79859327>] sysenter_do_call+0x12/0x37
[    4.686173] ---[ end trace 9d854ed5f523a273 ]---
--
[    5.815913] Restarting system.
[    5.816485] machine restart
[    5.824887] ------------[ cut here ]------------
[    5.825679] WARNING: at /c/wfg/linux/arch/x86/kernel/smp.c:123 native_smp_send_reschedule+0x46/0x50()
[    5.827263] Pid: 16, comm: kworker/0:1 Not tainted 3.5.0-bisect #29
[    5.828336] Call Trace:
[    5.828793]  [<7902bb2a>] warn_slowpath_common+0x5a/0x80
[    5.828882]  [<7901ba16>] ? native_smp_send_reschedule+0x46/0x50
[    5.828882]  [<7901ba16>] ? native_smp_send_reschedule+0x46/0x50
[    5.828882]  [<7902bbfd>] warn_slowpath_null+0x1d/0x20
[    5.828882]  [<7901ba16>] native_smp_send_reschedule+0x46/0x50
[    5.828882]  [<7905bc0d>] trigger_load_balance+0x1bd/0x250
[    5.828882]  [<790529e4>] scheduler_tick+0xd4/0x100
[    5.828882]  [<79038245>] update_process_times+0x55/0x70
[    5.828882]  [<7906cc4b>] tick_sched_timer+0x5b/0xc0
[    5.828882]  [<7939fcce>] ? do_raw_spin_unlock+0x4e/0x90
[    5.828882]  [<79049f37>] __run_hrtimer.isra.29+0x57/0x100
[    5.828882]  [<7906cbf0>] ? tick_nohz_handler+0xe0/0xe0
[    5.828882]  [<7904abc5>] hrtimer_interrupt+0xe5/0x280
[    5.828882]  [<7901c5a4>] smp_apic_timer_interrupt+0x54/0x90
[    5.828882]  [<79870351>] apic_timer_interrupt+0x31/0x40
[    5.828882]  [<7904007b>] ? start_worker+0x2b/0x30
[    5.828882]  [<793900e0>] ? insn_get_prefixes+0x150/0x240
[    5.828882]  [<7986f46f>] ? _raw_spin_unlock_irq+0x1f/0x40
[    5.828882]  [<7904edcf>] finish_task_switch+0x7f/0xd0
[    5.828882]  [<7904ed88>] ? finish_task_switch+0x38/0xd0
[    5.828882]  [<7986df6a>] __schedule+0x38a/0x770
[    5.828882]  [<790415fc>] ? worker_thread+0x16c/0x270
[    5.828882]  [<7939fcce>] ? do_raw_spin_unlock+0x4e/0x90
[    5.828882]  [<7986e36e>] schedule+0x1e/0x50
[    5.828882]  [<79041601>] worker_thread+0x171/0x270
[    5.828882]  [<79052ba9>] ? complete+0x49/0x60
[    5.828882]  [<79041490>] ? manage_workers.isra.26+0x1c0/0x1c0
[    5.828882]  [<79045f18>] kthread+0x78/0x80
[    5.828882]  [<79860000>] ? ip_vs_control_net_cleanup+0xc0/0xd0
[    5.828882]  [<79045ea0>] ? kthread_flush_work_fn+0x10/0x10
[    5.828882]  [<79870dc6>] kernel_thread_helper+0x6/0xd
[    5.828882] ---[ end trace df77608ce627a14d ]---

Thanks,
Fengguang

--bp/iNruPH9dso1Pn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-kvm-waimea-4993-2012-08-31-06-28-52-3.6.0-rc3-00005-gb374aa1-10"

[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.6.0-rc3-00005-gb374aa1 (kbuild@kbuild) (gcc version 4.7.1 (Debian 4.7.1-6) ) #10 SMP Fri Aug 31 06:25:51 CST 2012
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x0000000000093bff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000093c00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000fffe000-0x000000000fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: non-PAE kernel!
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0xfffe max_arch_pfn = 0x100000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 00E0000000 mask FFE0000000 uncachable
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdab0-0x000fdabf] mapped at [780fdab0]
[    0.000000]   mpc: fdac0-fdbe4
[    0.000000] initial memory mapped: [mem 0x00000000-0x027fffff]
[    0.000000] Base memory trampoline at [7808f000] 8f000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x0fffdfff]
[    0.000000]  [mem 0x00000000-0x0fffdfff] page 4k
[    0.000000] kernel direct mapping tables up to 0xfffdfff @ [mem 0x027bd000-0x027fffff]
[    0.000000] cma: dma_contiguous_reserve(limit 00000000)
[    0.000000] cma: dma_contiguous_reserve: reserving 25 MiB for global area
[    0.000000] cma: dma_declare_contiguous(size 198c000, base 00000000, limit 00000000)
[    0.000000] cma: CMA: reserved 32 MiB at 0c000000
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 128412(97%)
[    0.000000] RAMDISK: [mem 0x0e73f000-0x0ffeffff]
[    0.000000] ACPI: RSDP 000fd920 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0fffe550 00038 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0fffff80 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0fffe590 01121 (v01   BXPC   BXDSDT 00000001 INTL 20100528)
[    0.000000] ACPI: FACS 0fffff40 00040
[    0.000000] ACPI: SSDT 0ffffe40 000FF (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0ffffd50 00080 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0ffffd10 00038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
[    0.000000] ACPI: SSDT 0ffff6c0 00644 (v01   BXPC BXSSDTPC 00000001 INTL 20100528)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 255MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 0fffe000
[    0.000000]   low ram: 0 - 0fffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:1d8ba41, boot clock
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x0fffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x00092fff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65409
[    0.000000] free_area_init_node: node 0, pgdat 79bb4900, node_mem_map 864bf280
[    0.000000]   DMA zone: 40 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3931 pages, LIFO batch:0
[    0.000000]   Normal zone: 600 pages used for memmap
[    0.000000]   Normal zone: 60838 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 2, APIC INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 2, APIC INT 05
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 2, APIC INT 09
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 2, APIC INT 0a
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 2, APIC INT 0b
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 2, APIC INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 2, APIC INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 2, APIC INT 04
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 2, APIC INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 2, APIC INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 2, APIC INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 2, APIC INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 2, APIC INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 2, APIC INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 2, APIC INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 331 pages/cpu @86229000 s1340288 r0 d15488 u1355776
[    0.000000] pcpu-alloc: s1340288 r0 d15488 u1355776 alloc=331*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1 
[    0.000000] kvm-clock: cpu 0, msr 0:e36fa41, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr e22b840
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 64769
[    0.000000] Kernel command line: trinity=2m hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 branch=regulator/topic/bypass log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=vmlinuz-2012-08-31-06-25-57-regulator:topic:bypass:b374aa1-b374aa1-i386-randconfig-k865-1-waimea BOOT_IMAGE=kernel-tests/kernels/i386-randconfig-k865/b374aa1/vmlinuz-3.6.0-rc3-00005-gb374aa1
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 170848k/262136k available (8718k kernel code, 90788k reserved, 3307k data, 1848k init, 0k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff16000 - 0xfffff000   ( 932 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0x887fe000 - 0xff7fe000   (1904 MB)
[    0.000000]     lowmem  : 0x78000000 - 0x87ffe000   ( 255 MB)
[    0.000000]       .init : 0x79bbf000 - 0x79d8d000   (1848 kB)
[    0.000000]       .data : 0x79883a75 - 0x79bbe740   (3307 kB)
[    0.000000]       .text : 0x79000000 - 0x79883a75   (8718 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] SLUB: Genslabs=15, HWalign=128, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 
[    0.000000] 
[    0.000000] 
[    0.000000] 
[    0.000000] NR_IRQS:2304 nr_irqs:512 16
[    0.000000] CPU 0 irqstacks, hard=83412000 soft=83414000
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 3807 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] ------------------------
[    0.000000] | Locking API testsuite:
[    0.000000] ----------------------------------------------------------------------------
[    0.000000]                                  | spin |wlock |rlock |mutex | wsem | rsem |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]                      A-A deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.000000]                  A-B-B-A deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.000000]              A-B-B-C-C-A deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.000000]              A-B-C-A-B-C deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.000000]          A-B-B-C-C-D-D-A deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.000000]          A-B-C-D-B-D-D-A deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.000000]          A-B-C-D-B-C-D-A deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.000000]                     double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                   initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]               recursive read-lock:             |  ok  |             |failed|
[    0.000000]            recursive read-lock #2:             |  ok  |             |failed|
[    0.000000]             mixed read-write-lock:             |failed|             |failed|
[    0.000000]             mixed write-read-lock:             |failed|             |failed|
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]      hard-irqs-on + irq-safe-A/12:failed|failed|  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/12:failed|failed|  ok  |
[    0.000000]      hard-irqs-on + irq-safe-A/21:failed|failed|  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/21:failed|failed|  ok  |
[    0.000000]        sirq-safe-A => hirqs-on/12:failed|failed|  ok  |
[    0.000000]        sirq-safe-A => hirqs-on/21:failed|failed|  ok  |
[    0.000000]          hard-safe-A + irqs-on/12:failed|failed|  ok  |
[    0.000000]          soft-safe-A + irqs-on/12:failed|failed|  ok  |
[    0.000000]          hard-safe-A + irqs-on/21:failed|failed|  ok  |
[    0.000000]          soft-safe-A + irqs-on/21:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/123:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/123:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/132:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/132:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/213:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/213:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/231:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/231:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/312:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/312:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/321:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/321:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/123:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/123:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/132:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/132:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/213:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/213:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/231:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/231:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/312:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/312:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/321:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/321:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/123:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/123:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/132:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/132:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/213:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/213:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/231:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/231:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/312:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/312:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/321:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/321:failed|failed|  ok  |
[    0.000000]       hard-irq read-recursion/123:  ok  |
[    0.000000]       soft-irq read-recursion/123:  ok  |
[    0.000000]       hard-irq read-recursion/132:  ok  |
[    0.000000]       soft-irq read-recursion/132:  ok  |
[    0.000000]       hard-irq read-recursion/213:  ok  |
[    0.000000]       soft-irq read-recursion/213:  ok  |
[    0.000000]       hard-irq read-recursion/231:  ok  |
[    0.000000]       soft-irq read-recursion/231:  ok  |
[    0.000000]       hard-irq read-recursion/312:  ok  |
[    0.000000]       soft-irq read-recursion/312:  ok  |
[    0.000000]       hard-irq read-recursion/321:  ok  |
[    0.000000]       soft-irq read-recursion/321:  ok  |
[    0.000000] --------------------------------------------------------
[    0.000000] 133 out of 218 testcases failed, as expected. |
[    0.000000] ----------------------------------------------------
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 3300.196 MHz processor
[    0.004000] Calibrating delay loop (skipped) preset value.. 6600.39 BogoMIPS (lpj=13200784)
[    0.005506] pid_max: default: 32768 minimum: 301
[    0.008067] Mount-cache hash table entries: 512
[    0.011078] Initializing cgroup subsys debug
[    0.012014] Initializing cgroup subsys devices
[    0.013790] Initializing cgroup subsys blkio
[    0.014667] mce: CPU supports 10 MCE banks
[    0.016062] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.016062] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.016062] tlb_flushall_shift is 0x6
[    0.029918] debug: unmapping init [mem 0x79d8d000-0x79d95fff]
[    0.031850] ACPI: Core revision 20120711
[    0.066465] Getting VERSION: 50014
[    0.067061] Getting VERSION: 50014
[    0.068017] Getting ID: 0
[    0.068483] Getting ID: f000000
[    0.070014] Getting LVT0: 8700
[    0.070531] Getting LVT1: 8400
[    0.072012] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.074081] enabled ExtINT on CPU#0
[    0.078081] ENABLING IO-APIC IRQs
[    0.078635] init IO_APIC IRQs
[    0.080012]  apic 2 pin 0 not connected
[    0.080661] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    0.083074] IOAPIC[0]: Set routing entry (2-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.084039] IOAPIC[0]: Set routing entry (2-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
[    0.088045] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    0.092042] IOAPIC[0]: Set routing entry (2-5 -> 0x35 -> IRQ 5 Mode:1 Active:0 Dest:1)
[    0.096037] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
[    0.100036] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
[    0.103204] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    0.104034] IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
[    0.108035] IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:1 Active:0 Dest:1)
[    0.112052] IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:1 Active:0 Dest:1)
[    0.116037] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
[    0.118433] IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
[    0.120038] IOAPIC[0]: Set routing entry (2-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
[    0.124036] IOAPIC[0]: Set routing entry (2-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
[    0.129062]  apic 2 pin 16 not connected
[    0.129672]  apic 2 pin 17 not connected
[    0.131301]  apic 2 pin 18 not connected
[    0.132013]  apic 2 pin 19 not connected
[    0.133699]  apic 2 pin 20 not connected
[    0.136014]  apic 2 pin 21 not connected
[    0.138672]  apic 2 pin 22 not connected
[    0.140014]  apic 2 pin 23 not connected
[    0.141813] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.144015] smpboot: CPU0: Intel Common KVM processor stepping 01
[    0.153627] Using local APIC timer interrupts.
[    0.153627] calibrating APIC timer ...
[    0.160010] ... lapic delta = 6432962
[    0.160010] ... PM-Timer delta = 368431
[    0.160010] APIC calibration not consistent with PM-Timer: 102ms instead of 100ms
[    0.160010] APIC delta adjusted to PM-Timer: 6250029 (6432962)
[    0.160010] TSC delta adjusted to PM-Timer: 330012818 (339672005)
[    0.160010] ..... delta 6250029
[    0.160010] ..... mult: 268419925
[    0.160010] ..... calibration result: 4000018
[    0.160010] ..... CPU clock speed is 3300.0512 MHz.
[    0.160010] ..... host bus clock speed is 1000.0018 MHz.
[    0.160085] Performance Events: unsupported Netburst CPU model 6 no PMU driver, software events only.
[    0.172799] SMP alternatives: lockdep: fixing up alternatives
[    0.180042] CPU 1 irqstacks, hard=834b6000 soft=834c8000
[    0.184016] smpboot: Booting Node   0, Processors  #1 OK
[    0.004000] Initializing CPU#1
[    0.004000] kvm-clock: cpu 1, msr 0:e4baa41, secondary cpu clock
[    0.004000] masked ExtINT on CPU#1
[    0.236179] Brought up 2 CPUs
[    0.236604] ----------------
[    0.240020] | NMI testsuite:
[    0.244018] --------------------
[    0.244024] KVM setup async PF for cpu 1
[    0.244027] kvm-stealtime: cpu 1, msr e376840
[    0.252019]   remote IPI:  ok  |
[    0.253515]    local IPI:  ok  |
[    0.256026] --------------------
[    0.256614] Good, all   2 testcases passed! |
[    0.260021] ---------------------------------
[    0.262787] smpboot: Total of 2 processors activated (13200.78 BogoMIPS)
[    0.268464] CPU0 attaching sched-domain:
[    0.270134]  domain 0: span 0-1 level CPU
[    0.272024]   groups: 0 (cpu_power = 971) 1 (cpu_power = 1023)
[    0.276077] CPU1 attaching sched-domain:
[    0.280022]  domain 0: span 0-1 level CPU
[    0.284022]   groups: 1 (cpu_power = 1023) 0 (cpu_power = 971)
[    0.288358] device: 'platform': device_add
[    0.292147] bus: 'platform': registered
[    0.294928] bus: 'cpu': registered
[    0.295515] device: 'cpu': device_add
[    0.302382] xor: automatically using best checksumming function:
[    0.344045]    pIII_sse  :    98.000 MB/sec
[    0.344819] atomic64 test passed for i386+ platform with CX8 and with SSE
[    0.348090] bus: 'virtio': registered
[    0.348728] device class 'regulator': registering
[    0.350712] Registering platform device 'reg-dummy'. Parent at platform
[    0.352032] device: 'reg-dummy': device_add
[    0.353821] bus: 'platform': add device reg-dummy
[    0.356150] bus: 'platform': add driver reg-dummy
[    0.357959] bus: 'platform': driver_probe_device: matched device reg-dummy with driver reg-dummy
[    0.360028] bus: 'platform': really_probe: probing driver reg-dummy with device reg-dummy
[    0.364076] device: 'regulator.0': device_add
[    0.365996] dummy: 
[    0.366456] driver: 'reg-dummy': driver_bound: bound to device 'reg-dummy'
[    0.368038] bus: 'platform': really_probe: bound device reg-dummy to driver reg-dummy
[    0.372048] cma: cma_init_reserved_areas()
[    0.372762] cma: cma_create_area(base 0000c000, count 2000)
[    0.377282] cma: cma_create_area: returned 834ad300
[    0.379516] NET: Registered protocol family 16
[    0.380336] device class 'bdi': registering
[    0.382150] device class 'pci_bus': registering
[    0.384118] bus: 'pci': registered
[    0.384676] device class 'lcd': registering
[    0.386399] device class 'video_output': registering
[    0.388050] device class 'tty': registering
[    0.389905] bus: 'i2c': registered
[    0.390490] bus: 'i2c': add driver dummy
[    0.392152] bus: 'eisa': registered
[    0.393739] EISA bus registered
[    0.397311] ACPI: bus type pci registered
[    0.399209] PCI: PCI BIOS revision 2.10 entry at 0xfc78c, last bus=0
[    0.400029] PCI: Using configuration type 1 for base access
[    0.402258] device: 'cpu0': device_add
[    0.404059] bus: 'cpu': add device cpu0
[    0.404759] device: 'cpu1': device_add
[    0.406435] bus: 'cpu': add device cpu1
[    0.436039] device: 'default': device_add
[    0.440239] bio: create slab <bio-0> at 0
[    0.442236] device class 'block': registering
[    0.512050] raid6: mmxx1     1619 MB/s
[    0.580051] raid6: mmxx2     1765 MB/s
[    0.648058] raid6: sse1x1    1348 MB/s
[    0.716060] raid6: sse1x2    1812 MB/s
[    0.784061] raid6: sse2x1    3301 MB/s
[    0.852063] raid6: sse2x2    3755 MB/s
[    0.854544] raid6: using algorithm sse2x2 (3755 MB/s)
[    0.855404] raid6: using intx1 recovery algorithm
[    0.856098] bus: 'i2c': add driver max732x
[    0.856817] bus: 'i2c': add driver pcf857x
[    0.858566] bus: 'platform': add driver rc5t583-gpio
[    0.860090] bus: 'i2c': add driver sx150x
[    0.860937] device class 'graphics': registering
[    0.864971] ACPI: Added _OSI(Module Device)
[    0.866786] ACPI: Added _OSI(Processor Device)
[    0.868069] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.869019] ACPI: Added _OSI(Processor Aggregator Device)
[    0.877717] ACPI: EC: Look up EC in DSDT
[    0.951881] ACPI: Interpreter enabled
[    0.952064] ACPI: (supports S0 S5)
[    0.953829] ACPI: Using IOAPIC for interrupt routing
[    0.956182] bus: 'acpi': registered
[    0.956792] bus: 'acpi': add driver power
[    0.958685] device: 'LNXSYSTM:00': device_add
[    0.960086] bus: 'acpi': add device LNXSYSTM:00
[    0.962451] device: 'device:00': device_add
[    0.964086] bus: 'acpi': add device device:00
[    0.968101] device: 'PNP0A03:00': device_add
[    0.969909] bus: 'acpi': add device PNP0A03:00
[    0.975697] device: 'device:01': device_add
[    0.976088] bus: 'acpi': add device device:01
[    0.980528] device: 'device:02': device_add
[    0.981379] bus: 'acpi': add device device:02
[    0.983729] device: 'PNP0B00:00': device_add
[    0.984148] bus: 'acpi': add device PNP0B00:00
[    0.990395] device: 'PNP0303:00': device_add
[    0.992103] bus: 'acpi': add device PNP0303:00
[    0.994691] device: 'PNP0F13:00': device_add
[    0.996097] bus: 'acpi': add device PNP0F13:00
[    0.998831] device: 'PNP0700:00': device_add
[    1.002140] bus: 'acpi': add device PNP0700:00
[    1.006444] device: 'PNP0400:00': device_add
[    1.008097] bus: 'acpi': add device PNP0400:00
[    1.012685] device: 'PNP0501:00': device_add
[    1.014475] bus: 'acpi': add device PNP0501:00
[    1.017191] device: 'device:03': device_add
[    1.019007] bus: 'acpi': add device device:03
[    1.022580] device: 'device:04': device_add
[    1.024088] bus: 'acpi': add device device:04
[    1.025501] device: 'device:05': device_add
[    1.027264] bus: 'acpi': add device device:05
[    1.028596] device: 'device:06': device_add
[    1.032091] bus: 'acpi': add device device:06
[    1.034707] device: 'device:07': device_add
[    1.035436] bus: 'acpi': add device device:07
[    1.040268] device: 'device:08': device_add
[    1.041384] bus: 'acpi': add device device:08
[    1.043744] device: 'device:09': device_add
[    1.044090] bus: 'acpi': add device device:09
[    1.048566] device: 'device:0a': device_add
[    1.049514] bus: 'acpi': add device device:0a
[    1.051839] device: 'device:0b': device_add
[    1.052130] bus: 'acpi': add device device:0b
[    1.056873] device: 'device:0c': device_add
[    1.057598] bus: 'acpi': add device device:0c
[    1.062473] device: 'device:0d': device_add
[    1.064091] bus: 'acpi': add device device:0d
[    1.066351] device: 'device:0e': device_add
[    1.068092] bus: 'acpi': add device device:0e
[    1.069618] device: 'device:0f': device_add
[    1.072104] bus: 'acpi': add device device:0f
[    1.074439] device: 'device:10': device_add
[    1.076126] bus: 'acpi': add device device:10
[    1.078685] device: 'device:11': device_add
[    1.080092] bus: 'acpi': add device device:11
[    1.084361] device: 'device:12': device_add
[    1.086166] bus: 'acpi': add device device:12
[    1.088492] device: 'device:13': device_add
[    1.089434] bus: 'acpi': add device device:13
[    1.092607] device: 'device:14': device_add
[    1.094440] bus: 'acpi': add device device:14
[    1.096792] device: 'device:15': device_add
[    1.097499] bus: 'acpi': add device device:15
[    1.102229] device: 'device:16': device_add
[    1.102945] bus: 'acpi': add device device:16
[    1.104845] device: 'device:17': device_add
[    1.106653] bus: 'acpi': add device device:17
[    1.110630] device: 'device:18': device_add
[    1.112096] bus: 'acpi': add device device:18
[    1.113637] device: 'device:19': device_add
[    1.115481] bus: 'acpi': add device device:19
[    1.120107] device: 'device:1a': device_add
[    1.120921] bus: 'acpi': add device device:1a
[    1.124266] device: 'device:1b': device_add
[    1.125018] bus: 'acpi': add device device:1b
[    1.128334] device: 'device:1c': device_add
[    1.130103] bus: 'acpi': add device device:1c
[    1.132353] device: 'device:1d': device_add
[    1.134133] bus: 'acpi': add device device:1d
[    1.136508] device: 'device:1e': device_add
[    1.138340] bus: 'acpi': add device device:1e
[    1.140628] device: 'device:1f': device_add
[    1.142401] bus: 'acpi': add device device:1f
[    1.144629] device: 'device:20': device_add
[    1.146415] bus: 'acpi': add device device:20
[    1.148656] device: 'device:21': device_add
[    1.150435] bus: 'acpi': add device device:21
[    1.154194] device: 'device:22': device_add
[    1.154997] bus: 'acpi': add device device:22
[    1.160921] device: 'PNP0103:00': device_add
[    1.162695] bus: 'acpi': add device PNP0103:00
[    1.166463] device: 'PNP0C0F:00': device_add
[    1.168097] bus: 'acpi': add device PNP0C0F:00
[    1.172701] device: 'PNP0C0F:01': device_add
[    1.174530] bus: 'acpi': add device PNP0C0F:01
[    1.178321] device: 'PNP0C0F:02': device_add
[    1.180100] bus: 'acpi': add device PNP0C0F:02
[    1.184627] device: 'PNP0C0F:03': device_add
[    1.186449] bus: 'acpi': add device PNP0C0F:03
[    1.190340] device: 'PNP0C0F:04': device_add
[    1.192102] bus: 'acpi': add device PNP0C0F:04
[    1.193704] device: 'LNXCPU:00': device_add
[    1.196099] bus: 'acpi': add device LNXCPU:00
[    1.198784] device: 'LNXCPU:01': device_add
[    1.200100] bus: 'acpi': add device LNXCPU:01
[    1.202314] device: 'device:23': device_add
[    1.204112] bus: 'acpi': add device device:23
[    1.206023] device: 'LNXPWRBN:00': device_add
[    1.206741] bus: 'acpi': add device LNXPWRBN:00
[    1.208529] bus: 'acpi': add driver ec
[    1.212115] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    1.216082] bus: 'acpi': add driver pci_root
[    1.217906] bus: 'acpi': driver_probe_device: matched device PNP0A03:00 with driver pci_root
[    1.224083] bus: 'acpi': really_probe: probing driver pci_root with device PNP0A03:00
[    1.227816] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    1.232104] pci_root PNP0A03:00: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
[    1.236110] device: 'pci0000:00': device_add
[    1.236941] device: '0000:00': device_add
[    1.238869] PCI host bridge to bus 0000:00
[    1.240090] pci_bus 0000:00: busn_res: [bus 00-ff] is inserted under domain [bus 00-ff]
[    1.244084] pci_bus 0000:00: root bus resource [bus 00-ff]
[    1.246111] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    1.248090] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    1.252090] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    1.254321] pci_bus 0000:00: root bus resource [mem 0xe0000000-0xfebfffff]
[    1.256168] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    1.260553] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    1.264669] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    1.271011] pci 0000:00:01.1: reg 20: [io  0xc1c0-0xc1cf]
[    1.276178] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    1.277788] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
[    1.280101] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
[    1.282639] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    1.288196] pci 0000:00:02.0: reg 10: [mem 0xfc000000-0xfdffffff pref]
[    1.294442] pci 0000:00:02.0: reg 14: [mem 0xfebf4000-0xfebf4fff]
[    1.308229] pci 0000:00:02.0: reg 30: [mem 0xfebe0000-0xfebeffff pref]
[    1.313279] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    1.316509] pci 0000:00:03.0: reg 10: [mem 0xfeba0000-0xfebbffff]
[    1.320483] pci 0000:00:03.0: reg 14: [io  0xc000-0xc03f]
[    1.328475] pci 0000:00:03.0: reg 30: [mem 0xfebc0000-0xfebdffff pref]
[    1.334328] pci 0000:00:04.0: [8086:2668] type 00 class 0x040300
[    1.336429] pci 0000:00:04.0: reg 10: [mem 0xfebf0000-0xfebf3fff]
[    1.346217] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    1.348620] pci 0000:00:05.0: reg 10: [io  0xc040-0xc07f]
[    1.351452] pci 0000:00:05.0: reg 14: [mem 0xfebf5000-0xfebf5fff]
[    1.362296] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    1.368093] pci 0000:00:06.0: reg 10: [io  0xc080-0xc0bf]
[    1.369908] pci 0000:00:06.0: reg 14: [mem 0xfebf6000-0xfebf6fff]
[    1.380818] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    1.385620] pci 0000:00:07.0: reg 10: [io  0xc0c0-0xc0ff]
[    1.389914] pci 0000:00:07.0: reg 14: [mem 0xfebf7000-0xfebf7fff]
[    1.402265] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    1.404612] pci 0000:00:08.0: reg 10: [io  0xc100-0xc13f]
[    1.408528] pci 0000:00:08.0: reg 14: [mem 0xfebf8000-0xfebf8fff]
[    1.418684] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    1.420616] pci 0000:00:09.0: reg 10: [io  0xc140-0xc17f]
[    1.424886] pci 0000:00:09.0: reg 14: [mem 0xfebf9000-0xfebf9fff]
[    1.437901] pci 0000:00:0a.0: [1af4:1001] type 00 class 0x010000
[    1.440599] pci 0000:00:0a.0: reg 10: [io  0xc180-0xc1bf]
[    1.444939] pci 0000:00:0a.0: reg 14: [mem 0xfebfa000-0xfebfafff]
[    1.457424] pci 0000:00:0b.0: [8086:25ab] type 00 class 0x088000
[    1.459834] pci 0000:00:0b.0: reg 10: [mem 0xfebfb000-0xfebfb00f]
[    1.468102] pci_bus 0000:00: on NUMA node 0
[    1.470934] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    1.496108]  pci0000:00: Unable to request _OSC control (_OSC support mask: 0x08)
[    1.500138] device: '0000:00:00.0': device_add
[    1.520391] bus: 'pci': add device 0000:00:00.0
[    1.522475] device: '0000:00:01.0': device_add
[    1.542400] bus: 'pci': add device 0000:00:01.0
[    1.544285] device: '0000:00:01.1': device_add
[    1.564427] bus: 'pci': add device 0000:00:01.1
[    1.566490] device: '0000:00:01.3': device_add
[    1.586576] bus: 'pci': add device 0000:00:01.3
[    1.589308] device: '0000:00:02.0': device_add
[    1.609313] bus: 'pci': add device 0000:00:02.0
[    1.611261] device: '0000:00:03.0': device_add
[    1.630106] bus: 'pci': add device 0000:00:03.0
[    1.633252] device: '0000:00:04.0': device_add
[    1.652627] bus: 'pci': add device 0000:00:04.0
[    1.654708] device: '0000:00:05.0': device_add
[    1.674559] bus: 'pci': add device 0000:00:05.0
[    1.676292] device: '0000:00:06.0': device_add
[    1.695333] bus: 'pci': add device 0000:00:06.0
[    1.697296] device: '0000:00:07.0': device_add
[    1.715625] bus: 'pci': add device 0000:00:07.0
[    1.716279] device: '0000:00:08.0': device_add
[    1.737364] bus: 'pci': add device 0000:00:08.0
[    1.739437] device: '0000:00:09.0': device_add
[    1.758717] bus: 'pci': add device 0000:00:09.0
[    1.760290] device: '0000:00:0a.0': device_add
[    1.778864] bus: 'pci': add device 0000:00:0a.0
[    1.780309] device: '0000:00:0b.0': device_add
[    1.804368] bus: 'pci': add device 0000:00:0b.0
[    1.806452] driver: 'PNP0A03:00': driver_bound: bound to device 'pci_root'
[    1.808126] bus: 'acpi': really_probe: bound device PNP0A03:00 to driver pci_root
[    1.812159] bus: 'acpi': add driver pci_link
[    1.814032] bus: 'acpi': driver_probe_device: matched device PNP0C0F:00 with driver pci_link
[    1.816121] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:00
[    1.824820] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    1.829619] driver: 'PNP0C0F:00': driver_bound: bound to device 'pci_link'
[    1.832122] bus: 'acpi': really_probe: bound device PNP0C0F:00 to driver pci_link
[    1.834492] bus: 'acpi': driver_probe_device: matched device PNP0C0F:01 with driver pci_link
[    1.840124] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:01
[    1.846362] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    1.848575] driver: 'PNP0C0F:01': driver_bound: bound to device 'pci_link'
[    1.850863] bus: 'acpi': really_probe: bound device PNP0C0F:01 to driver pci_link
[    1.856128] bus: 'acpi': driver_probe_device: matched device PNP0C0F:02 with driver pci_link
[    1.858563] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:02
[    1.861856] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    1.865701] driver: 'PNP0C0F:02': driver_bound: bound to device 'pci_link'
[    1.868124] bus: 'acpi': really_probe: bound device PNP0C0F:02 to driver pci_link
[    1.870600] bus: 'acpi': driver_probe_device: matched device PNP0C0F:03 with driver pci_link
[    1.872123] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:03
[    1.877803] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    1.880591] driver: 'PNP0C0F:03': driver_bound: bound to device 'pci_link'
[    1.882769] bus: 'acpi': really_probe: bound device PNP0C0F:03 to driver pci_link
[    1.884127] bus: 'acpi': driver_probe_device: matched device PNP0C0F:04 with driver pci_link
[    1.888124] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:04
[    1.893700] ACPI: PCI Interrupt Link [LNKS] (IRQs 9) *0
[    1.895951] driver: 'PNP0C0F:04': driver_bound: bound to device 'pci_link'
[    1.896125] bus: 'acpi': really_probe: bound device PNP0C0F:04 to driver pci_link
[    1.900233] bus: 'pnp': registered
[    1.900818] bus: 'platform': add driver reg-fixed-voltage
[    1.902790] bus: 'platform': add driver ab3100-regulators
[    1.904153] bus: 'platform': add driver da9052-regulator
[    1.906108] bus: 'platform': add driver gpio-regulator
[    1.908197] bus: 'i2c': add driver isl6271a
[    1.909977] bus: 'i2c': add driver lp3972
[    1.912152] bus: 'i2c': add driver max1586
[    1.912862] bus: 'platform': add driver max8925-regulator
[    1.914837] bus: 'platform': add driver tps6105x-regulator
[    1.916162] bus: 'i2c': add driver tps62360
[    1.917962] bus: 'i2c': add driver tps65023
[    1.920155] bus: 'platform': add driver tps6507x-pmic
[    1.922102] bus: 'platform': add driver tps65090-regulator
[    1.924154] bus: 'platform': add driver tps65217-pmic
[    1.926075] bus: 'platform': add driver wm8400-regulator
[    1.928156] bus: 'platform': add driver wm8994-ldo
[    1.930058] device class 'misc': registering
[    1.932133] device: 'vga_arbiter': device_add
[    1.934112] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    1.936189] vgaarb: loaded
[    1.936655] vgaarb: bridge control possible 0000:00:02.0
[    1.938652] bus: 'i2c': add driver 88PM860x
[    1.940154] bus: 'i2c': add driver tc3589x
[    1.941930] bus: 'i2c': add driver WM8400
[    1.944156] bus: 'i2c': add driver tps6105x
[    1.944880] tps65010: version 2 May 2005
[    1.946569] bus: 'i2c': add driver tps65010
[    1.948179] bus: 'i2c': remove driver tps65010
[    1.949957] driver: 'tps65010': driver_release
[    1.964152] bus: 'i2c': add driver tps65010
[    1.964884] bus: 'i2c': remove driver tps65010
[    1.965573] driver: 'tps65010': driver_release
[    1.980143] bus: 'i2c': add driver tps65010
[    1.980972] bus: 'i2c': remove driver tps65010
[    1.981736] driver: 'tps65010': driver_release
[    1.982551] tps65010: no chip?
[    1.983129] bus: 'i2c': add driver tps65217
[    1.983929] bus: 'i2c': add driver da9052
[    1.984156] bus: 'i2c': add driver max77693
[    1.984979] bus: 'i2c': add driver max8925
[    1.985787] bus: 'i2c': add driver max8998
[    1.986557] bus: 'i2c': add driver pcf50633
[    1.987382] bus: 'i2c': add driver ab3100
[    1.988171] bus: 'i2c': add driver tps65090
[    1.988956] bus: 'i2c': add driver rc5t583
[    1.990504] device class 'scsi_host': registering
[    1.991467] bus: 'scsi': registered
[    1.992129] device class 'scsi_device': registering
[    1.992934] SCSI subsystem initialized
[    1.993645] ACPI: bus type usb registered
[    1.994430] bus: 'usb': registered
[    1.995062] bus: 'usb': add driver usbfs
[    1.996178] usbcore: registered new interface driver usbfs
[    1.997105] bus: 'usb': add driver hub
[    1.997835] usbcore: registered new interface driver hub
[    2.000165] bus: 'usb': add driver usb
[    2.000855] usbcore: registered new device driver usb
[    2.002811] bus: 'serio': registered
[    2.004181] bus: 'gameport': registered
[    2.005869] device class 'input': registering
[    2.008210] bus: 'i2c': add driver tca6416-keypad
[    2.010117] bus: 'i2c': add driver tca8418_keypad
[    2.010874] bus: 'platform': add driver i2c-gpio
[    2.012170] device class 'pps': registering
[    2.013995] pps_core: LinuxPPS API ver. 1 registered
[    2.016131] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    2.020136] device class 'ptp': registering
[    2.021978] PTP clock support registered
[    2.022652] device class 'power_supply': registering
[    2.024176] device class 'hwmon': registering
[    2.026030] device class 'watchdog': registering
[    2.032261] device class 'devfreq': registering
[    2.033052] device class 'sound': registering
[    2.033807] PCI: Using ACPI for IRQ routing
[    2.034543] PCI: pci_cache_line_size set to 64 bytes
[    2.036798] e820: reserve RAM buffer [mem 0x00093c00-0x0009ffff]
[    2.037816] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    2.038938] device class 'net': registering
[    2.039771] device: 'lo': device_add
[    2.048221] Sangoma WANPIPE Router v1.1 (c) 1995-2000 Sangoma Technologies Inc.
[    2.049471] Bluetooth: Core ver 2.16
[    2.050153] device class 'bluetooth': registering
[    2.050952] NET: Registered protocol family 31
[    2.051703] Bluetooth: HCI device and connection manager initialized
[    2.052145] Bluetooth: HCI socket layer initialized
[    2.052977] Bluetooth: L2CAP socket layer initialized
[    2.053866] Bluetooth: SCO socket layer initialized
[    2.054673] NET: Registered protocol family 8
[    2.056133] NET: Registered protocol family 20
[    2.056973] device class 'atm': registering
[    2.057691] device class 'ieee80211': registering
[    2.058726] Registering platform device 'regulatory.0'. Parent at platform
[    2.059929] device: 'regulatory.0': device_add
[    2.060157] bus: 'platform': add device regulatory.0
[    2.068329] cfg80211: Calling CRDA to update world regulatory domain
[    2.069668] Switching to clocksource kvm-clock
[    2.072606] bus: 'pnp': add driver system
[    2.075330] pnp: PnP ACPI init
[    2.077155] device: 'pnp0': device_add
[    2.079885] ACPI: bus type pnp registered
[    2.082901] pnp 00:00: [bus 00-ff]
[    2.083487] pnp 00:00: [io  0x0cf8-0x0cff]
[    2.086275] pnp 00:00: [io  0x0000-0x0cf7 window]
[    2.090191] pnp 00:00: [io  0x0d00-0xffff window]
[    2.093211] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    2.097216] pnp 00:00: [mem 0xe0000000-0xfebfffff window]
[    2.106805] device: '00:00': device_add
[    2.110837] bus: 'pnp': add device 00:00
[    2.115203] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    2.122090] pnp 00:01: [io  0x0070-0x0071]
[    2.126959] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:3)
[    2.131248] pnp 00:01: [irq 8]
[    2.132902] pnp 00:01: [io  0x0072-0x0077]
[    2.135689] device: '00:01': device_add
[    2.137350] bus: 'pnp': add device 00:01
[    2.139216] pnp 00:01: Plug and Play ACPI device, IDs PNP0b00 (active)
[    2.144000] pnp 00:02: [io  0x0060]
[    2.146717] pnp 00:02: [io  0x0064]
[    2.148898] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:3)
[    2.151483] pnp 00:02: [irq 1]
[    2.153041] device: '00:02': device_add
[    2.154935] bus: 'pnp': add device 00:02
[    2.156956] pnp 00:02: Plug and Play ACPI device, IDs PNP0303 (active)
[    2.160875] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:3)
[    2.164401] pnp 00:03: [irq 12]
[    2.166046] device: '00:03': device_add
[    2.167884] bus: 'pnp': add device 00:03
[    2.169886] pnp 00:03: Plug and Play ACPI device, IDs PNP0f13 (active)
[    2.173448] pnp 00:04: [io  0x03f2-0x03f5]
[    2.175234] pnp 00:04: [io  0x03f7]
[    2.176964] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:3)
[    2.179493] pnp 00:04: [irq 6]
[    2.182160] pnp 00:04: [dma 2]
[    2.183851] device: '00:04': device_add
[    2.185682] bus: 'pnp': add device 00:04
[    2.186428] pnp 00:04: Plug and Play ACPI device, IDs PNP0700 (active)
[    2.190228] pnp 00:05: [io  0x0378-0x037f]
[    2.191980] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:3)
[    2.194418] pnp 00:05: [irq 7]
[    2.196055] device: '00:05': device_add
[    2.197908] bus: 'pnp': add device 00:05
[    2.199720] pnp 00:05: Plug and Play ACPI device, IDs PNP0400 (active)
[    2.202532] pnp 00:06: [io  0x03f8-0x03ff]
[    2.204315] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:3)
[    2.207882] pnp 00:06: [irq 4]
[    2.208422] device: '00:06': device_add
[    2.210210] bus: 'pnp': add device 00:06
[    2.212108] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    2.218341] pnp 00:07: [mem 0xfed00000-0xfed003ff]
[    2.220281] device: '00:07': device_add
[    2.222180] bus: 'pnp': add device 00:07
[    2.224053] pnp 00:07: Plug and Play ACPI device, IDs PNP0103 (active)
[    2.229982] pnp: PnP ACPI: found 8 devices
[    2.231721] ACPI: ACPI bus type pnp unregistered
[    2.232551] device class 'mem': registering
[    2.234469] device: 'mem': device_add
[    2.236283] device: 'null': device_add
[    2.238130] device: 'port': device_add
[    2.239989] device: 'zero': device_add
[    2.241860] device: 'full': device_add
[    2.243696] device: 'random': device_add
[    2.244499] device: 'urandom': device_add
[    2.246332] device: 'kmsg': device_add
[    2.248180] device: 'tty': device_add
[    2.250028] device: 'console': device_add
[    2.251864] device class 'firmware': registering
[    2.253714] device class 'thermal': registering
[    2.293696] bus: 'bcma': registered
[    2.294441] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    2.296500] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    2.299643] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    2.301820] pci_bus 0000:00: resource 7 [mem 0xe0000000-0xfebfffff]
[    2.304135] NET: Registered protocol family 2
[    2.307689] TCP established hash table entries: 8192 (order: 4, 65536 bytes)
[    2.310112] TCP bind hash table entries: 8192 (order: 6, 360448 bytes)
[    2.313936] TCP: Hash tables configured (established 8192 bind 8192)
[    2.316110] TCP: reno registered
[    2.317771] UDP hash table entries: 256 (order: 2, 24576 bytes)
[    2.319872] UDP-Lite hash table entries: 256 (order: 2, 24576 bytes)
[    2.322320] NET: Registered protocol family 1
[    2.324238] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    2.326342] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    2.328473] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    2.331766] pci 0000:00:02.0: Boot video device
[    2.333818] PCI: CLS 0 bytes, default 64
[    2.335956] Trying to unpack rootfs image as initramfs...
[    6.258673] debug: unmapping init [mem 0x8673f000-0x87feffff]
[    6.279230] device class 'msr': registering
[    6.280056] device: 'msr0': device_add
[    6.280811] device: 'msr1': device_add
[    6.281530] device class 'cpuid': registering
[    6.282215] device: 'cpu0': device_add
[    6.282945] device: 'cpu1': device_add
[    6.283665] Registering platform device 'microcode'. Parent at platform
[    6.284757] device: 'microcode': device_add
[    6.287795] bus: 'platform': add device microcode
[    6.289777] microcode: CPU0 sig=0xf61, pf=0x1, revision=0x1
[    6.291743] microcode: CPU1 sig=0xf61, pf=0x1, revision=0x1
[    6.293771] device: 'microcode': device_add
[    6.314972] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    6.366535] The force parameter has not been set to 1 so the Iris poweroff handler will not be installed.
[    6.368250] bus: 'clocksource': registered
[    6.368926] device: 'clocksource': device_add
[    6.369693] device: 'clocksource0': device_add
[    6.381626] bus: 'clocksource': add device clocksource0
[    6.382476] bus: 'platform': add driver alarmtimer
[    6.383188] Registering platform device 'alarmtimer'. Parent at platform
[    6.384177] device: 'alarmtimer': device_add
[    6.384820] bus: 'platform': add device alarmtimer
[    6.385582] bus: 'platform': driver_probe_device: matched device alarmtimer with driver alarmtimer
[    6.386892] bus: 'platform': really_probe: probing driver alarmtimer with device alarmtimer
[    6.388210] driver: 'alarmtimer': driver_bound: bound to device 'alarmtimer'
[    6.389304] bus: 'platform': really_probe: bound device alarmtimer to driver alarmtimer
[    6.406845] bus: 'rttest': registered
[    6.407485] device: 'rttest': device_add
[    6.446271] device: 'rttest0': device_add
[    6.446987] bus: 'rttest': add device rttest0
[    6.448044] device: 'rttest1': device_add
[    6.448778] bus: 'rttest': add device rttest1
[    6.452141] device: 'rttest2': device_add
[    6.453430] bus: 'rttest': add device rttest2
[    6.456052] device: 'rttest3': device_add
[    6.457302] bus: 'rttest': add device rttest3
[    6.496577] device: 'rttest4': device_add
[    6.497202] bus: 'rttest': add device rttest4
[    6.498247] device: 'rttest5': device_add
[    6.498982] bus: 'rttest': add device rttest5
[    6.499951] device: 'rttest6': device_add
[    6.500643] bus: 'rttest': add device rttest6
[    6.501572] device: 'rttest7': device_add
[    6.502205] bus: 'rttest': add device rttest7
[    6.502964] Initializing RT-Tester: OK
[    6.504000] bus: 'event_source': registered
[    6.504718] device: 'breakpoint': device_add
[    6.505440] bus: 'event_source': add device breakpoint
[    6.506337] device: 'software': device_add
[    6.507022] bus: 'event_source': add device software
[    6.554822] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    6.597669] device: 'dlm-control': device_add
[    6.598579] device: 'dlm-monitor': device_add
[    6.599526] device: 'dlm_plock': device_add
[    6.601419] DLM installed
[    6.623852] Key type cifs.spnego registered
[    6.624713] Key type cifs.idmap registered
[    6.625640] NTFS driver 2.1.30 [Flags: R/O DEBUG].
[    6.627681] QNX4 filesystem 0.2.3 registered.
[    6.628689] QNX6 filesystem 1.0.0 registered.
[    6.645065] JFS: nTxBlock = 1590, nTxLock = 12726
[    6.661158] SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, debug enabled
[    6.681468] 9p: Installing v9fs 9p2000 file system support
[    6.683201] NILFS version 2 loaded
[    6.685417] device: 'btrfs-control': device_add
[    6.686198] Btrfs loaded
[    6.700561] GFS2 installed
[    6.701467] alg: No test for cipher_null (cipher_null-generic)
[    6.702466] cryptomgr_test (45) used greatest stack depth: 7348 bytes left
[    6.707499] alg: No test for ecb(cipher_null) (ecb-cipher_null)
[    6.708542] cryptomgr_test (46) used greatest stack depth: 7076 bytes left
[    6.708653] alg: No test for digest_null (digest_null-generic)
[    6.708775] alg: No test for compress_null (compress_null-generic)
[    6.711345] cryptomgr_test (49) used greatest stack depth: 6812 bytes left
[    6.724434] cryptomgr_test (57) used greatest stack depth: 6800 bytes left
[    6.727183] cryptomgr_test (58) used greatest stack depth: 6768 bytes left
[    6.737238] alg: No test for fcrypt (fcrypt-generic)
[    6.757858] cryptomgr_test (76) used greatest stack depth: 6404 bytes left
[    6.781699] alg: No test for stdrng (krng)
[    6.782840] NET: Registered protocol family 38
[    6.797342] io scheduler noop registered
[    6.798033] io scheduler deadline registered (default)
[    6.798946] bus: 'platform': add driver basic-mmio-gpio
[    6.800227] bus: 'platform': add driver hgafb
[    6.801040] Registering platform device 'hgafb.0'. Parent at platform
[    6.818468] device: 'hgafb.0': device_add
[    6.819196] bus: 'platform': add device hgafb.0
[    6.820154] bus: 'platform': driver_probe_device: matched device hgafb.0 with driver hgafb
[    6.821756] bus: 'platform': really_probe: probing driver hgafb with device hgafb.0
[    6.823187] hgafb: HGA card not detected.
[    6.823916] hgafb: probe of hgafb.0 failed with error -22
[    6.825034] bus: 'platform': add driver tmio-fb
[    6.825860] bus: 'platform': add driver metronomefb
[    6.826773] bus: 'platform': add driver broadsheetfb
[    6.838780] bus: 'platform': add driver s1d13xxxfb
[    6.839683] bus: 'usb': add driver udlfb
[    6.850817] usbcore: registered new interface driver udlfb
[    6.861936] bus: 'usb': add driver smscufx
[    6.862616] usbcore: registered new interface driver smscufx
[    6.863482] Registering platform device 'vesafb.0'. Parent at platform
[    6.864502] device: 'vesafb.0': device_add
[    6.865262] bus: 'platform': add device vesafb.0
[    6.876136] bus: 'platform': add driver vesafb
[    6.876852] bus: 'platform': driver_probe_device: matched device vesafb.0 with driver vesafb
[    6.878116] bus: 'platform': really_probe: probing driver vesafb with device vesafb.0
[    6.895033] vesafb: probe of vesafb.0 rejects match -19
[    6.895964] bus: 'platform': remove driver vesafb
[    6.896823] driver: 'vesafb': driver_release
[    6.897694] bus: 'platform': remove device vesafb.0
[    6.909960] bus: 'acpi': add driver ac
[    6.910619] bus: 'acpi': add driver button
[    6.911262] bus: 'acpi': driver_probe_device: matched device LNXPWRBN:00 with driver button
[    6.912863] bus: 'acpi': really_probe: probing driver button with device LNXPWRBN:00
[    6.914071] device: 'input0': device_add
[    6.914932] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    6.916148] ACPI: Power Button [PWRF]
[    6.918810] driver: 'LNXPWRBN:00': driver_bound: bound to device 'button'
[    6.919964] bus: 'acpi': really_probe: bound device LNXPWRBN:00 to driver button
[    6.921256] bus: 'acpi': add driver fan
[    6.931054] bus: 'acpi': add driver processor
[    6.931757] bus: 'acpi': driver_probe_device: matched device LNXCPU:00 with driver processor
[    6.933010] bus: 'acpi': really_probe: probing driver processor with device LNXCPU:00
[    6.944164] device: 'cooling_device0': device_add
[    6.945178] driver: 'LNXCPU:00': driver_bound: bound to device 'processor'
[    6.946406] bus: 'acpi': really_probe: bound device LNXCPU:00 to driver processor
[    6.947656] bus: 'acpi': driver_probe_device: matched device LNXCPU:01 with driver processor
[    6.949088] bus: 'acpi': really_probe: probing driver processor with device LNXCPU:01
[    6.951230] device: 'cooling_device1': device_add
[    6.973358] driver: 'LNXCPU:01': driver_bound: bound to device 'processor'
[    6.974568] bus: 'acpi': really_probe: bound device LNXCPU:01 to driver processor
[    6.975828] bus: 'acpi': add driver thermal
[    6.976661] bus: 'platform': add driver virtio-mmio
[    7.010530] bus: 'platform': add driver reg-virt-consumer
[    7.011416] bus: 'platform': add driver reg-userspace-consumer
[    7.012436] device: 'ptyp0': device_add
[    7.013111] device: 'ptyp1': device_add
[    7.013826] device: 'ptyp2': device_add
[    7.014527] device: 'ptyp3': device_add
[    7.015203] device: 'ptyp4': device_add
[    7.034456] bus: 'acpi': add driver battery
[    7.035287] device: 'ptyp5': device_add
[    7.036040] device: 'ptyp6': device_add
[    7.036741] device: 'ptyp7': device_add
[    7.037454] device: 'ptyp8': device_add
[    7.038128] device: 'ptyp9': device_add
[    7.038818] device: 'ptypa': device_add
[    7.049579] device: 'ptypb': device_add
[    7.050255] device: 'ptypc': device_add
[    7.050959] device: 'ptypd': device_add
[    7.051678] device: 'ptype': device_add
[    7.052363] device: 'ptypf': device_add
[    7.053066] device: 'ptyq0': device_add
[    7.053739] device: 'ptyq1': device_add
[    7.063115] device: 'ptyq2': device_add
[    7.063890] device: 'ptyq3': device_add
[    7.064698] device: 'ptyq4': device_add
[    7.065458] device: 'ptyq5': device_add
[    7.068997] device: 'ptyq6': device_add
[    7.069767] device: 'ptyq7': device_add
[    7.070527] device: 'ptyq8': device_add
[    7.071161] device: 'ptyq9': device_add
[    7.071846] device: 'ptyqa': device_add
[    7.072559] device: 'ptyqb': device_add
[    7.073240] device: 'ptyqc': device_add
[    7.074035] device: 'ptyqd': device_add
[    7.084920] device: 'ptyqe': device_add
[    7.085655] device: 'ptyqf': device_add
[    7.086407] device: 'ptyr0': device_add
[    7.087086] device: 'ptyr1': device_add
[    7.087769] device: 'ptyr2': device_add
[    7.088479] device: 'ptyr3': device_add
[    7.089174] device: 'ptyr4': device_add
[    7.089944] device: 'ptyr5': device_add
[    7.090692] device: 'ptyr6': device_add
[    7.091480] device: 'ptyr7': device_add
[    7.092170] device: 'ptyr8': device_add
[    7.092889] device: 'ptyr9': device_add
[    7.103537] device: 'ptyra': device_add
[    7.110663] device: 'ptyrb': device_add
[    7.111667] device: 'ptyrc': device_add
[    7.112429] device: 'ptyrd': device_add
[    7.113157] device: 'ptyre': device_add
[    7.113890] device: 'ptyrf': device_add
[    7.114631] device: 'ptys0': device_add
[    7.115436] device: 'ptys1': device_add
[    7.116189] device: 'ptys2': device_add
[    7.124913] device: 'ptys3': device_add
[    7.125692] device: 'ptys4': device_add
[    7.126443] device: 'ptys5': device_add
[    7.128779] device: 'ptys6': device_add
[    7.129573] device: 'ptys7': device_add
[    7.130314] device: 'ptys8': device_add
[    7.131118] device: 'ptys9': device_add
[    7.131930] device: 'ptysa': device_add
[    7.132772] device: 'ptysb': device_add
[    7.133530] device: 'ptysc': device_add
[    7.134233] device: 'ptysd': device_add
[    7.134964] device: 'ptyse': device_add
[    7.135703] device: 'ptysf': device_add
[    7.136453] device: 'ptyt0': device_add
[    7.137148] device: 'ptyt1': device_add
[    7.137885] device: 'ptyt2': device_add
[    7.138632] device: 'ptyt3': device_add
[    7.139327] device: 'ptyt4': device_add
[    7.162659] device: 'ptyt5': device_add
[    7.163342] device: 'ptyt6': device_add
[    7.164098] device: 'ptyt7': device_add
[    7.164867] device: 'ptyt8': device_add
[    7.165597] device: 'ptyt9': device_add
[    7.166279] device: 'ptyta': device_add
[    7.167011] device: 'ptytb': device_add
[    7.167766] device: 'ptytc': device_add
[    7.168574] device: 'ptytd': device_add
[    7.169328] device: 'ptyte': device_add
[    7.170117] device: 'ptytf': device_add
[    7.170918] device: 'ptyu0': device_add
[    7.171707] device: 'ptyu1': device_add
[    7.172507] device: 'ptyu2': device_add
[    7.186248] device: 'ptyu3': device_add
[    7.187030] device: 'ptyu4': device_add
[    7.187845] device: 'ptyu5': device_add
[    7.188665] device: 'ptyu6': device_add
[    7.189434] device: 'ptyu7': device_add
[    7.190173] device: 'ptyu8': device_add
[    7.190947] device: 'ptyu9': device_add
[    7.191697] device: 'ptyua': device_add
[    7.192452] device: 'ptyub': device_add
[    7.193153] device: 'ptyuc': device_add
[    7.193889] device: 'ptyud': device_add
[    7.194648] device: 'ptyue': device_add
[    7.195336] device: 'ptyuf': device_add
[    7.196037] device: 'ptyv0': device_add
[    7.196763] device: 'ptyv1': device_add
[    7.197482] device: 'ptyv2': device_add
[    7.198154] device: 'ptyv3': device_add
[    7.210969] device: 'ptyv4': device_add
[    7.211751] device: 'ptyv5': device_add
[    7.212562] device: 'ptyv6': device_add
[    7.213298] device: 'ptyv7': device_add
[    7.214046] device: 'ptyv8': device_add
[    7.214780] device: 'ptyv9': device_add
[    7.215533] device: 'ptyva': device_add
[    7.216253] device: 'ptyvb': device_add
[    7.216973] device: 'ptyvc': device_add
[    7.217705] device: 'ptyvd': device_add
[    7.218440] device: 'ptyve': device_add
[    7.219216] device: 'ptyvf': device_add
[    7.219967] device: 'ptyw0': device_add
[    7.220744] device: 'ptyw1': device_add
[    7.221495] device: 'ptyw2': device_add
[    7.222214] device: 'ptyw3': device_add
[    7.222983] device: 'ptyw4': device_add
[    7.239899] device: 'ptyw5': device_add
[    7.240688] device: 'ptyw6': device_add
[    7.241488] device: 'ptyw7': device_add
[    7.242238] device: 'ptyw8': device_add
[    7.242974] device: 'ptyw9': device_add
[    7.243709] device: 'ptywa': device_add
[    7.244467] device: 'ptywb': device_add
[    7.245194] device: 'ptywc': device_add
[    7.245910] device: 'ptywd': device_add
[    7.246691] device: 'ptywe': device_add
[    7.247507] device: 'ptywf': device_add
[    7.248315] device: 'ptyx0': device_add
[    7.249138] device: 'ptyx1': device_add
[    7.265886] tsc: Refined TSC clocksource calibration: 3300.194 MHz
[    7.266947] device: 'ptyx2': device_add
[    7.267662] device: 'ptyx3': device_add
[    7.268425] device: 'ptyx4': device_add
[    7.269152] device: 'ptyx5': device_add
[    7.269902] device: 'ptyx6': device_add
[    7.270627] device: 'ptyx7': device_add
[    7.271334] device: 'ptyx8': device_add
[    7.272200] device: 'ptyx9': device_add
[    7.272974] device: 'ptyxa': device_add
[    7.273742] device: 'ptyxb': device_add
[    7.298601] device: 'ptyxc': device_add
[    7.299264] device: 'ptyxd': device_add
[    7.300037] device: 'ptyxe': device_add
[    7.300777] device: 'ptyxf': device_add
[    7.301532] device: 'ptyy0': device_add
[    7.302214] device: 'ptyy1': device_add
[    7.302972] device: 'ptyy2': device_add
[    7.303757] device: 'ptyy3': device_add
[    7.304457] device: 'ptyy4': device_add
[    7.305097] device: 'ptyy5': device_add
[    7.305769] device: 'ptyy6': device_add
[    7.306445] device: 'ptyy7': device_add
[    7.307072] device: 'ptyy8': device_add
[    7.323847] device: 'ptyy9': device_add
[    7.324592] device: 'ptyya': device_add
[    7.325287] device: 'ptyyb': device_add
[    7.326022] device: 'ptyyc': device_add
[    7.326764] device: 'ptyyd': device_add
[    7.327501] device: 'ptyye': device_add
[    7.328225] device: 'ptyyf': device_add
[    7.328969] device: 'ptyz0': device_add
[    7.329635] device: 'ptyz1': device_add
[    7.330265] device: 'ptyz2': device_add
[    7.330958] device: 'ptyz3': device_add
[    7.331651] device: 'ptyz4': device_add
[    7.332318] device: 'ptyz5': device_add
[    7.333000] device: 'ptyz6': device_add
[    7.340882] device: 'ptyz7': device_add
[    7.341623] device: 'ptyz8': device_add
[    7.342318] device: 'ptyz9': device_add
[    7.343054] device: 'ptyza': device_add
[    7.343764] device: 'ptyzb': device_add
[    7.344517] device: 'ptyzc': device_add
[    7.345225] device: 'ptyzd': device_add
[    7.345958] device: 'ptyze': device_add
[    7.346672] device: 'ptyzf': device_add
[    7.347416] device: 'ptya0': device_add
[    7.348201] device: 'ptya1': device_add
[    7.348985] device: 'ptya2': device_add
[    7.349766] device: 'ptya3': device_add
[    7.350539] device: 'ptya4': device_add
[    7.351319] device: 'ptya5': device_add
[    7.352159] device: 'ptya6': device_add
[    7.379037] device: 'ptya7': device_add
[    7.379788] device: 'ptya8': device_add
[    7.380541] device: 'ptya9': device_add
[    7.381266] device: 'ptyaa': device_add
[    7.382035] device: 'ptyab': device_add
[    7.382801] device: 'ptyac': device_add
[    7.383566] device: 'ptyad': device_add
[    7.384343] device: 'ptyae': device_add
[    7.385119] device: 'ptyaf': device_add
[    7.385887] device: 'ptyb0': device_add
[    7.386644] device: 'ptyb1': device_add
[    7.387351] device: 'ptyb2': device_add
[    7.409162] device: 'ptyb3': device_add
[    7.409925] device: 'ptyb4': device_add
[    7.410675] device: 'ptyb5': device_add
[    7.411424] device: 'ptyb6': device_add
[    7.412155] device: 'ptyb7': device_add
[    7.412902] device: 'ptyb8': device_add
[    7.413690] device: 'ptyb9': device_add
[    7.414516] device: 'ptyba': device_add
[    7.415280] device: 'ptybb': device_add
[    7.416080] device: 'ptybc': device_add
[    7.416832] device: 'ptybd': device_add
[    7.435651] device: 'ptybe': device_add
[    7.436496] device: 'ptybf': device_add
[    7.437273] device: 'ptyc0': device_add
[    7.438080] device: 'ptyc1': device_add
[    7.438890] device: 'ptyc2': device_add
[    7.439663] device: 'ptyc3': device_add
[    7.440485] device: 'ptyc4': device_add
[    7.441242] device: 'ptyc5': device_add
[    7.441992] device: 'ptyc6': device_add
[    7.442746] device: 'ptyc7': device_add
[    7.443479] device: 'ptyc8': device_add
[    7.444207] device: 'ptyc9': device_add
[    7.455994] device: 'ptyca': device_add
[    7.456771] device: 'ptycb': device_add
[    7.457603] device: 'ptycc': device_add
[    7.458354] device: 'ptycd': device_add
[    7.459091] device: 'ptyce': device_add
[    7.459866] device: 'ptycf': device_add
[    7.460684] device: 'ptyd0': device_add
[    7.461454] device: 'ptyd1': device_add
[    7.462230] device: 'ptyd2': device_add
[    7.463023] device: 'ptyd3': device_add
[    7.463846] device: 'ptyd4': device_add
[    7.482667] device: 'ptyd5': device_add
[    7.483414] device: 'ptyd6': device_add
[    7.484136] device: 'ptyd7': device_add
[    7.484893] device: 'ptyd8': device_add
[    7.485629] device: 'ptyd9': device_add
[    7.486344] device: 'ptyda': device_add
[    7.487142] device: 'ptydb': device_add
[    7.487878] device: 'ptydc': device_add
[    7.488642] device: 'ptydd': device_add
[    7.489412] device: 'ptyde': device_add
[    7.494627] device: 'ptydf': device_add
[    7.495322] device: 'ptye0': device_add
[    7.496087] device: 'ptye1': device_add
[    7.496838] device: 'ptye2': device_add
[    7.507647] device: 'ptye3': device_add
[    7.512127] device: 'ptye4': device_add
[    7.512876] device: 'ptye5': device_add
[    7.513623] device: 'ptye6': device_add
[    7.514344] device: 'ptye7': device_add
[    7.515087] device: 'ptye8': device_add
[    7.515830] device: 'ptye9': device_add
[    7.516553] device: 'ptyea': device_add
[    7.517278] device: 'ptyeb': device_add
[    7.518038] device: 'ptyec': device_add
[    7.518763] device: 'ptyed': device_add
[    7.519502] device: 'ptyee': device_add
[    7.520213] device: 'ptyef': device_add
[    7.520980] device: 'ttyp0': device_add
[    7.535755] device: 'ttyp1': device_add
[    7.536514] device: 'ttyp2': device_add
[    7.537216] device: 'ttyp3': device_add
[    7.537978] device: 'ttyp4': device_add
[    7.538721] device: 'ttyp5': device_add
[    7.539500] device: 'ttyp6': device_add
[    7.540238] device: 'ttyp7': device_add
[    7.540977] device: 'ttyp8': device_add
[    7.541702] device: 'ttyp9': device_add
[    7.542434] device: 'ttypa': device_add
[    7.543169] device: 'ttypb': device_add
[    7.543905] device: 'ttypc': device_add
[    7.544657] device: 'ttypd': device_add
[    7.545343] device: 'ttype': device_add
[    7.557876] device: 'ttypf': device_add
[    7.558617] device: 'ttyq0': device_add
[    7.559332] device: 'ttyq1': device_add
[    7.560086] device: 'ttyq2': device_add
[    7.560799] device: 'ttyq3': device_add
[    7.561541] device: 'ttyq4': device_add
[    7.562240] device: 'ttyq5': device_add
[    7.562987] device: 'ttyq6': device_add
[    7.563728] device: 'ttyq7': device_add
[    7.564497] device: 'ttyq8': device_add
[    7.565198] device: 'ttyq9': device_add
[    7.565933] device: 'ttyqa': device_add
[    7.566680] device: 'ttyqb': device_add
[    7.581502] device: 'ttyqc': device_add
[    7.582207] device: 'ttyqd': device_add
[    7.582964] device: 'ttyqe': device_add
[    7.583717] device: 'ttyqf': device_add
[    7.584478] device: 'ttyr0': device_add
[    7.585181] device: 'ttyr1': device_add
[    7.585926] device: 'ttyr2': device_add
[    7.586682] device: 'ttyr3': device_add
[    7.587427] device: 'ttyr4': device_add
[    7.588173] device: 'ttyr5': device_add
[    7.588923] device: 'ttyr6': device_add
[    7.589653] device: 'ttyr7': device_add
[    7.590348] device: 'ttyr8': device_add
[    7.591129] device: 'ttyr9': device_add
[    7.608921] device: 'ttyra': device_add
[    7.609668] device: 'ttyrb': device_add
[    7.610444] device: 'ttyrc': device_add
[    7.611178] device: 'ttyrd': device_add
[    7.611989] device: 'ttyre': device_add
[    7.620065] device: 'ttyrf': device_add
[    7.620793] device: 'ttys0': device_add
[    7.621524] device: 'ttys1': device_add
[    7.622242] device: 'ttys2': device_add
[    7.622985] device: 'ttys3': device_add
[    7.623727] device: 'ttys4': device_add
[    7.624482] device: 'ttys5': device_add
[    7.625166] device: 'ttys6': device_add
[    7.625906] device: 'ttys7': device_add
[    7.626636] device: 'ttys8': device_add
[    7.627315] device: 'ttys9': device_add
[    7.628063] device: 'ttysa': device_add
[    7.628770] device: 'ttysb': device_add
[    7.629471] device: 'ttysc': device_add
[    7.630159] device: 'ttysd': device_add
[    7.630907] device: 'ttyse': device_add
[    7.639334] device: 'ttysf': device_add
[    7.640111] device: 'ttyt0': device_add
[    7.640885] device: 'ttyt1': device_add
[    7.641631] device: 'ttyt2': device_add
[    7.649406] device: 'ttyt3': device_add
[    7.650112] device: 'ttyt4': device_add
[    7.650838] device: 'ttyt5': device_add
[    7.651562] device: 'ttyt6': device_add
[    7.652272] device: 'ttyt7': device_add
[    7.653012] device: 'ttyt8': device_add
[    7.653737] device: 'ttyt9': device_add
[    7.654454] device: 'ttyta': device_add
[    7.655148] device: 'ttytb': device_add
[    7.655903] device: 'ttytc': device_add
[    7.656661] device: 'ttytd': device_add
[    7.657353] device: 'ttyte': device_add
[    7.658052] device: 'ttytf': device_add
[    7.658785] device: 'ttyu0': device_add
[    7.659516] device: 'ttyu1': device_add
[    7.660226] device: 'ttyu2': device_add
[    7.660951] device: 'ttyu3': device_add
[    7.673604] device: 'ttyu4': device_add
[    7.674352] device: 'ttyu5': device_add
[    7.675107] device: 'ttyu6': device_add
[    7.675853] device: 'ttyu7': device_add
[    7.676628] device: 'ttyu8': device_add
[    7.677348] device: 'ttyu9': device_add
[    7.678096] device: 'ttyua': device_add
[    7.688769] device: 'ttyub': device_add
[    7.689503] device: 'ttyuc': device_add
[    7.690218] device: 'ttyud': device_add
[    7.690950] device: 'ttyue': device_add
[    7.691679] device: 'ttyuf': device_add
[    7.692428] device: 'ttyv0': device_add
[    7.693159] device: 'ttyv1': device_add
[    7.693926] device: 'ttyv2': device_add
[    7.694649] device: 'ttyv3': device_add
[    7.695345] device: 'ttyv4': device_add
[    7.707407] device: 'ttyv5': device_add
[    7.708168] device: 'ttyv6': device_add
[    7.711243] device: 'ttyv7': device_add
[    7.711981] device: 'ttyv8': device_add
[    7.714824] device: 'ttyv9': device_add
[    7.715562] device: 'ttyva': device_add
[    7.716288] device: 'ttyvb': device_add
[    7.717018] device: 'ttyvc': device_add
[    7.717732] device: 'ttyvd': device_add
[    7.718461] device: 'ttyve': device_add
[    7.719143] device: 'ttyvf': device_add
[    7.719861] device: 'ttyw0': device_add
[    7.720602] device: 'ttyw1': device_add
[    7.721287] device: 'ttyw2': device_add
[    7.732034] device: 'ttyw3': device_add
[    7.734626] device: 'ttyw4': device_add
[    7.736589] device: 'ttyw5': device_add
[    7.737272] device: 'ttyw6': device_add
[    7.738002] device: 'ttyw7': device_add
[    7.738747] device: 'ttyw8': device_add
[    7.739480] device: 'ttyw9': device_add
[    7.740195] device: 'ttywa': device_add
[    7.740922] device: 'ttywb': device_add
[    7.741636] device: 'ttywc': device_add
[    7.742323] device: 'ttywd': device_add
[    7.822625] device: 'ttywe': device_add
[    7.823403] device: 'ttywf': device_add
[    7.824181] device: 'ttyx0': device_add
[    7.824981] device: 'ttyx1': device_add
[    7.825726] device: 'ttyx2': device_add
[    7.826482] device: 'ttyx3': device_add
[    7.827218] device: 'ttyx4': device_add
[    7.827943] device: 'ttyx5': device_add
[    7.828680] device: 'ttyx6': device_add
[    7.838640] device: 'ttyx7': device_add
[    7.842403] device: 'ttyx8': device_add
[    7.843145] device: 'ttyx9': device_add
[    7.843892] device: 'ttyxa': device_add
[    7.844621] device: 'ttyxb': device_add
[    7.845312] device: 'ttyxc': device_add
[    7.846060] device: 'ttyxd': device_add
[    7.846797] device: 'ttyxe': device_add
[    7.847527] device: 'ttyxf': device_add
[    7.848236] device: 'ttyy0': device_add
[    7.848981] device: 'ttyy1': device_add
[    7.865859] device: 'ttyy2': device_add
[    7.866614] device: 'ttyy3': device_add
[    7.867322] device: 'ttyy4': device_add
[    7.868066] device: 'ttyy5': device_add
[    7.868816] device: 'ttyy6': device_add
[    7.869547] device: 'ttyy7': device_add
[    7.870255] device: 'ttyy8': device_add
[    7.870995] device: 'ttyy9': device_add
[    7.871732] device: 'ttyya': device_add
[    7.872467] device: 'ttyyb': device_add
[    7.873153] device: 'ttyyc': device_add
[    7.894018] device: 'ttyyd': device_add
[    7.894759] device: 'ttyye': device_add
[    7.895509] device: 'ttyyf': device_add
[    7.896235] device: 'ttyz0': device_add
[    7.896964] device: 'ttyz1': device_add
[    7.897681] device: 'ttyz2': device_add
[    7.898456] device: 'ttyz3': device_add
[    7.899152] device: 'ttyz4': device_add
[    7.899866] device: 'ttyz5': device_add
[    7.922659] device: 'ttyz6': device_add
[    7.923431] device: 'ttyz7': device_add
[    7.924176] device: 'ttyz8': device_add
[    7.924921] device: 'ttyz9': device_add
[    7.925634] device: 'ttyza': device_add
[    7.926331] device: 'ttyzb': device_add
[    7.927066] device: 'ttyzc': device_add
[    7.927784] device: 'ttyzd': device_add
[    7.928505] device: 'ttyze': device_add
[    7.933586] device: 'ttyzf': device_add
[    7.934297] device: 'ttya0': device_add
[    7.935022] device: 'ttya1': device_add
[    7.935751] device: 'ttya2': device_add
[    7.936480] device: 'ttya3': device_add
[    7.937199] device: 'ttya4': device_add
[    7.937946] device: 'ttya5': device_add
[    7.938684] device: 'ttya6': device_add
[    7.939404] device: 'ttya7': device_add
[    7.940121] device: 'ttya8': device_add
[    7.940862] device: 'ttya9': device_add
[    7.941585] device: 'ttyaa': device_add
[    7.942287] device: 'ttyab': device_add
[    7.953074] device: 'ttyac': device_add
[    7.953807] device: 'ttyad': device_add
[    7.954552] device: 'ttyae': device_add
[    7.955256] device: 'ttyaf': device_add
[    7.955985] device: 'ttyb0': device_add
[    7.956752] device: 'ttyb1': device_add
[    7.967546] device: 'ttyb2': device_add
[    7.968257] device: 'ttyb3': device_add
[    7.969009] device: 'ttyb4': device_add
[    7.972958] device: 'ttyb5': device_add
[    7.973797] device: 'ttyb6': device_add
[    7.975477] device: 'ttyb7': device_add
[    7.977399] device: 'ttyb8': device_add
[    7.981427] device: 'ttyb9': device_add
[    7.987693] device: 'ttyba': device_add
[    7.991158] device: 'ttybb': device_add
[    7.995131] device: 'ttybc': device_add
[    7.999225] device: 'ttybd': device_add
[    8.002283] device: 'ttybe': device_add
[    8.006168] device: 'ttybf': device_add
[    8.010300] device: 'ttyc0': device_add
[    8.012476] device: 'ttyc1': device_add
[    8.016491] device: 'ttyc2': device_add
[    8.021709] device: 'ttyc3': device_add
[    8.023473] device: 'ttyc4': device_add
[    8.028756] device: 'ttyc5': device_add
[    8.030401] device: 'ttyc6': device_add
[    8.034894] device: 'ttyc7': device_add
[    8.037920] device: 'ttyc8': device_add
[    8.040732] device: 'ttyc9': device_add
[    8.042352] device: 'ttyca': device_add
[    8.045446] device: 'ttycb': device_add
[    8.048467] device: 'ttycc': device_add
[    8.053081] device: 'ttycd': device_add
[    8.056045] device: 'ttyce': device_add
[    8.058707] device: 'ttycf': device_add
[    8.059510] device: 'ttyd0': device_add
[    8.062913] device: 'ttyd1': device_add
[    8.065745] device: 'ttyd2': device_add
[    8.067697] device: 'ttyd3': device_add
[    8.069459] device: 'ttyd4': device_add
[    8.072270] device: 'ttyd5': device_add
[    8.075149] device: 'ttyd6': device_add
[    8.078047] device: 'ttyd7': device_add
[    8.081038] device: 'ttyd8': device_add
[    8.084030] device: 'ttyd9': device_add
[    8.085996] device: 'ttyda': device_add
[    8.087957] device: 'ttydb': device_add
[    8.089929] device: 'ttydc': device_add
[    8.091792] device: 'ttydd': device_add
[    8.093751] device: 'ttyde': device_add
[    8.094569] device: 'ttydf': device_add
[    8.096475] device: 'ttye0': device_add
[    8.098483] device: 'ttye1': device_add
[    8.100356] device: 'ttye2': device_add
[    8.102235] device: 'ttye3': device_add
[    8.104091] device: 'ttye4': device_add
[    8.105995] device: 'ttye5': device_add
[    8.107745] device: 'ttye6': device_add
[    8.108538] device: 'ttye7': device_add
[    8.110345] device: 'ttye8': device_add
[    8.112165] device: 'ttye9': device_add
[    8.113990] device: 'ttyea': device_add
[    8.115746] device: 'ttyeb': device_add
[    8.116503] device: 'ttyec': device_add
[    8.118356] device: 'ttyed': device_add
[    8.120257] device: 'ttyee': device_add
[    8.122183] device: 'ttyef': device_add
[    8.124137] HDLC line discipline maxframe=4096
[    8.125979] N_HDLC line discipline registered.
[    8.127746] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    8.129982] Registering platform device 'serial8250'. Parent at platform
[    8.132269] device: 'serial8250': device_add
[    8.134129] bus: 'platform': add device serial8250
[    8.183780] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    8.184988] device: 'ttyS0': device_add
[    8.186091] device: 'ttyS1': device_add
[    8.188089] device: 'ttyS2': device_add
[    8.190104] device: 'ttyS3': device_add
[    8.192088] bus: 'platform': add driver serial8250
[    8.194148] bus: 'platform': driver_probe_device: matched device serial8250 with driver serial8250
[    8.198018] bus: 'platform': really_probe: probing driver serial8250 with device serial8250
[    8.200547] driver: 'serial8250': driver_bound: bound to device 'serial8250'
[    8.204138] bus: 'platform': really_probe: bound device serial8250 to driver serial8250
[    8.207751] bus: 'pnp': add driver serial
[    8.208570] bus: 'pnp': driver_probe_device: matched device 00:06 with driver serial
[    8.212254] bus: 'pnp': really_probe: probing driver serial with device 00:06
[    8.216117] device: 'ttyS0': device_unregister
[    8.218151] device: 'ttyS0': device_create_release
[    8.268104] 00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    8.270171] device: 'ttyS0': device_add
[    8.272102] driver: '00:06': driver_bound: bound to device 'serial'
[    8.275153] bus: 'pnp': really_probe: bound device 00:06 to driver serial
[    8.277526] bus: 'pci': add driver serial
[    8.279437] bus: 'platform': add driver timb-uart
[    8.281485] bus: 'platform': add driver altera_jtaguart
[    8.284479] device: 'ttyprintk': device_add
[    8.286456] device class 'virtio-ports': registering
[    8.288574] bus: 'virtio': add driver virtio_console
[    8.291677] device class 'raw': registering
[    8.292544] device: 'rawctl': device_add
[    8.295421] DoubleTalk PC - not found
[    8.297263] device: 'rtc': device_add
[    8.299226] Real Time Clock Driver v1.12b
[    8.301162] device: 'nvram': device_add
[    8.303947] Non-volatile memory driver v1.3
[    8.305781] bus: 'platform': add driver timeriomem_rng
[    8.308499] bus: 'virtio': add driver virtio_rng
[    8.310510] telclk_interrupt = 0xf non-mcpbl0010 hw.
[    8.313454] device class 'drm': registering
[    8.315435] [drm] Initialized drm 1.1.0 20060810
[    8.317434] bus: 'usb': add driver udl
[    8.319256] usbcore: registered new interface driver udl
[    8.322655] bus: 'isa': registered
[    8.323308] device: 'isa': device_add
[    8.327202] device: '1:0': device_add
[    8.329174] device: 'ram0': device_add
[    8.331349] device: '1:1': device_add
[    8.333336] device: 'ram1': device_add
[    8.335522] device: '1:2': device_add
[    8.337534] device: 'ram2': device_add
[    8.340803] device: '1:3': device_add
[    8.342731] device: 'ram3': device_add
[    8.344965] device: '1:4': device_add
[    8.346911] device: 'ram4': device_add
[    8.349197] device: '1:5': device_add
[    8.351122] device: 'ram5': device_add
[    8.353271] device: '1:6': device_add
[    8.355173] device: 'ram6': device_add
[    8.357327] device: '1:7': device_add
[    8.359228] device: 'ram7': device_add
[    8.361350] device: '1:8': device_add
[    8.363249] device: 'ram8': device_add
[    8.365427] device: '1:9': device_add
[    8.367327] device: 'ram9': device_add
[    8.369531] device: '1:10': device_add
[    8.371493] device: 'ram10': device_add
[    8.374753] device: '1:11': device_add
[    8.376714] device: 'ram11': device_add
[    8.378939] device: '1:12': device_add
[    8.380809] device: 'ram12': device_add
[    8.382984] device: '1:13': device_add
[    8.384960] device: 'ram13': device_add
[    8.387088] device: '1:14': device_add
[    8.389069] device: 'ram14': device_add
[    8.391190] device: '1:15': device_add
[    8.393149] device: 'ram15': device_add
[    8.395275] brd: module loaded
[    8.397042] device: 'loop-control': device_add
[    8.399204] device: '7:0': device_add
[    8.401158] device: 'loop0': device_add
[    8.403346] device: '7:1': device_add
[    8.405303] device: 'loop1': device_add
[    8.407505] device: '7:2': device_add
[    8.409448] device: 'loop2': device_add
[    8.412733] device: '7:3': device_add
[    8.413531] device: 'loop3': device_add
[    8.417046] device: '7:4': device_add
[    8.418995] device: 'loop4': device_add
[    8.421322] device: '7:5': device_add
[    8.423232] device: 'loop5': device_add
[    8.425456] device: '7:6': device_add
[    8.427348] device: 'loop6': device_add
[    8.429576] device: '7:7': device_add
[    8.431511] device: 'loop7': device_add
[    8.434739] loop: module loaded
[    8.435546] device class 'pktcdvd': registering
[    8.437567] device: 'pktcdvd': device_add
[    8.443315] nbd: registered device at major 43
[    8.445244] device: '43:0': device_add
[    8.447193] device: 'nbd0': device_add
[    8.449404] device: '43:1': device_add
[    8.451294] device: 'nbd1': device_add
[    8.453533] device: '43:2': device_add
[    8.455488] device: 'nbd2': device_add
[    8.458793] device: '43:3': device_add
[    8.460772] device: 'nbd3': device_add
[    8.463019] device: '43:4': device_add
[    8.465009] device: 'nbd4': device_add
[    8.467184] device: '43:5': device_add
[    8.469163] device: 'nbd5': device_add
[    8.471312] device: '43:6': device_add
[    8.473264] device: 'nbd6': device_add
[    8.475727] device: '43:7': device_add
[    8.477679] device: 'nbd7': device_add
[    8.480753] device: '43:8': device_add
[    8.481934] device: 'nbd8': device_add
[    8.484165] device: '43:9': device_add
[    8.486119] device: 'nbd9': device_add
[    8.488315] device: '43:10': device_add
[    8.490281] device: 'nbd10': device_add
[    8.492554] device: '43:11': device_add
[    8.495726] device: 'nbd11': device_add
[    8.498030] device: '43:12': device_add
[    8.499992] device: 'nbd12': device_add
[    8.503074] device: '43:13': device_add
[    8.505041] device: 'nbd13': device_add
[    8.507170] device: '43:14': device_add
[    8.509159] device: 'nbd14': device_add
[    8.511312] device: '43:15': device_add
[    8.513277] device: 'nbd15': device_add
[    8.515526] 'Low Performance USB Block' driver is deprecated. Please switch to usb-storage
[    8.518434] bus: 'usb': add driver ub
[    8.520254] usbcore: registered new interface driver ub
[    8.542445] drbd: initialized. Version: 8.3.13 (api:88/proto:86-96)
[    8.545757] drbd: built-in
[    8.546298] drbd: registered as block device major 147
[    8.548398] drbd: minor_table @ 0x7c9f2260
[    8.551094] device: 'rbd': device_add
[    8.553026] bus: 'rbd': registered
[    8.554709] rbd: loaded rbd (rados block device)
[    8.555554] bus: 'i2c': add driver ics932s401
[    8.557796] lkdtm: No crash points registered, enable through debugfs
[    8.560123] bus: 'i2c': add driver apds990x
[    8.562802] bus: 'i2c': add driver isl29020
[    8.564755] bus: 'i2c': add driver ds1682
[    8.566664] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Giometti
[    8.569163] device class 'c2port': registering
[    8.571093] bus: 'i2c': add driver hmc6352
[    8.572133] bus: 'i2c': add driver at24
[    8.574005] bus: 'i2c': add driver eeprom
[    8.575787] bus: 'i2c': add driver max6875
[    8.577755] bus: 'platform': add driver kim
[    8.578552] bus: 'platform': add driver sm501
[    8.580537] bus: 'pci': add driver sm501
[    8.582439] bus: 'i2c': add driver htcpld-chip
[    8.584407] bus: 'platform': add driver i2c-htcpld
[    8.586413] bus: 'platform': remove driver i2c-htcpld
[    8.588426] driver: 'i2c-htcpld': driver_release
[    8.590356] bus: 'i2c': add driver wm8994
[    8.592239] bus: 'platform': add driver ab3100-otp
[    8.594290] bus: 'platform': remove driver ab3100-otp
[    8.596309] driver: 'ab3100-otp': driver_release
[    8.598238] device class 'srp_host': registering
[    8.600169] device class 'srp_remote_ports': registering
[    8.602245] hp_sw: device handler registered
[    8.604146] emc: device handler registered
[    8.606036] alua: device handler registered
[    8.607796] st: Version 20101219, fixed bufsize 32768, s/g segs 256
[    8.610111] device class 'scsi_tape': registering
[    8.612095] bus: 'scsi': add driver st
[    8.613982] osst :I: Tape driver with OnStream support version 0.99.4
[    8.613982] osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
[    8.618443] device class 'onstream_tape': registering
[    8.620530] bus: 'scsi': add driver osst
[    8.622447] device class 'scsi_disk': registering
[    8.624447] bus: 'scsi': add driver sd
[    8.627280] bus: 'scsi': add driver sr
[    8.629153] device class 'scsi_generic': registering
[    8.631170] SCSI Media Changer driver v0.25 
[    8.633074] device class 'scsi_changer': registering
[    8.635121] bus: 'scsi': add driver ch
[    8.669265] Rounding down aligned max_sectors from 4294967295 to 8388600
[    8.673108] device: 'tcm_loop_0': device_add
[    8.675076] bus: 'tcm_loop_bus': registered
[    8.677002] bus: 'tcm_loop_bus': add driver tcm_loop
[    8.679082] device class 'mtd': registering
[    8.680925] device: 'mtd-unmap': device_add
[    8.682982] device: 'mtd-romap': device_add
[    8.685077] device: 'mtd-rwmap': device_add
[    8.687120] SSFDC read-only Flash Translation layer
[    8.689133] mtdoops: mtd device (mtddev=name/number) must be supplied
[    8.691331] bus: 'platform': add driver physmap-flash
[    8.693424] Could not find PAR responsible for SC520CDP Flash Bank #1
[    8.696701] Trying default address 0x8c00000
[    8.697485] SC520 CDP flash device: 0x800000 at 0x8800000
[    8.698339] Failed to ioremap_nocache
[    8.698946] NetSc520 flash device: 0x100000 at 0x200000
[    8.699788] Failed to ioremap_nocache
[    8.700428] bus: 'platform': add driver gpio-addr-flash
[    8.703065] bus: 'platform': add driver docg3
[    8.703828] bus: 'platform': remove driver docg3
[    8.707292] driver: 'docg3': driver_release
[    8.718011] Possible DiskOnChip with unknown ChipID 00 found at 0xca000
[    8.723121] No recognised DiskOnChip devices found
[    8.728542] device: 'mtd0': device_add
[    8.729425] ftl_cs: FTL header not found.
[    8.730664] device: '31:0': device_add
[    8.731533] device: 'mtdblock0': device_add
[    8.742785] bus: 'platform': add driver docg4
[    8.745725] bus: 'platform': remove driver docg4
[    8.748728] driver: 'docg4': driver_release
[    8.749541] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    8.755362] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    8.761212] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    8.767132] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    8.773031] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    8.778802] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    8.784706] NAND device: Manufacturer ID: 0x98, Chip ID: 0x39 (Toshiba NAND 128MiB 1,8V 8-bit), page size: 512, OOB size: 16
[    8.791699] flash size: 128 MiB
[    8.792290] page size: 512 bytes
[    8.795006] OOB area size: 16 bytes
[    8.795527] sector size: 16 KiB
[    8.798267] pages number: 262144
[    8.801019] pages per sector: 32
[    8.801578] bus width: 8
[    8.804161] bits in sector size: 14
[    8.806890] bits in page size: 9
[    8.807448] bits in OOB size: 4
[    8.810166] flash size with OOB: 135168 KiB
[    8.813046] page address bytes: 4
[    8.815676] sector address bytes: 3
[    8.816339] options: 0x42
[    8.824987] Scanning device for bad blocks
[    8.912053] Creating 1 MTD partitions on "NAND 128MiB 1,8V 8-bit":
[    8.914265] 0x000000000000-0x000008000000 : "NAND simulator partition 0"
[    8.917932] device: 'mtd1': device_add
[    8.920076] ftl_cs: FTL header not found.
[    8.922237] device: '31:1': device_add
[    8.924245] device: 'mtdblock1': device_add
[    8.926569] bus: 'usb': add driver alauda
[    8.928463] usbcore: registered new interface driver alauda
[    8.930943] LocalTalk card not found; 220 = ff, 240 = ff.
[    8.932203] device class 'uio': registering
[    8.934110] bus: 'platform': add driver uio_pdrv_genirq
[    8.935330] device class 'aoe': registering
[    8.937249] device: 'err': device_add
[    8.938359] device: 'discover': device_add
[    8.940355] device: 'interfaces': device_add
[    8.941512] device: 'revalidate': device_add
[    8.943481] device: 'flush': device_add
[    8.945903] aoe: AoE v47 initialised.
[    8.946898] bus: 'pnp': add driver i8042 kbd
[    8.948723] bus: 'pnp': driver_probe_device: matched device 00:02 with driver i8042 kbd
[    8.950448] bus: 'pnp': really_probe: probing driver i8042 kbd with device 00:02
[    8.952983] driver: '00:02': driver_bound: bound to device 'i8042 kbd'
[    8.954175] bus: 'pnp': really_probe: bound device 00:02 to driver i8042 kbd
[    8.955531] bus: 'pnp': add driver i8042 aux
[    8.956450] bus: 'pnp': driver_probe_device: matched device 00:03 with driver i8042 aux
[    8.958086] bus: 'pnp': really_probe: probing driver i8042 aux with device 00:03
[    8.959424] driver: '00:03': driver_bound: bound to device 'i8042 aux'
[    8.960718] bus: 'pnp': really_probe: bound device 00:03 to driver i8042 aux
[    8.962094] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    8.963554] Registering platform device 'i8042'. Parent at platform
[    8.964889] device: 'i8042': device_add
[    8.965576] bus: 'platform': add device i8042
[    8.966578] bus: 'platform': add driver i8042
[    8.967463] bus: 'platform': driver_probe_device: matched device i8042 with driver i8042
[    8.969131] bus: 'platform': really_probe: probing driver i8042 with device i8042
[    8.985805] serio: i8042 KBD port at 0x60,0x64 irq 1
[    8.986930] serio: i8042 AUX port at 0x60,0x64 irq 12
[    8.987995] device: 'serio0': device_add
[    8.988926] bus: 'serio': add device serio0
[    8.989958] driver: 'i8042': driver_bound: bound to device 'i8042'
[    8.991103] device: 'serio1': device_add
[    8.991974] bus: 'serio': add device serio1
[    8.993035] bus: 'platform': really_probe: bound device i8042 to driver i8042
[    8.994475] bus: 'i2c': add driver adp5588_keys
[    8.995334] bus: 'i2c': add driver adp5589_keys
[    8.996254] bus: 'serio': add driver atkbd
[    8.997208] bus: 'i2c': add driver mpr121
[    8.998083] bus: 'serio': driver_probe_device: matched device serio0 with driver atkbd
[    8.999472] bus: 'serio': really_probe: probing driver atkbd with device serio0
[    9.001048] bus: 'serio': add driver newtonkbd
[    9.002040] bus: 'platform': add driver opencores-kbd
[    9.003066] bus: 'i2c': add driver qt1070
[    9.003962] bus: 'platform': add driver tc3589x-keypad
[    9.005093] bus: 'gameport': add driver adc
[    9.006010] bus: 'i2c': add driver as5011
[    9.006732] bus: 'gameport': add driver grip_mp
[    9.007576] bus: 'serio': add driver iforce
[    9.008503] bus: 'gameport': add driver sidewinder
[    9.009496] bus: 'serio': add driver spaceball
[    9.010434] bus: 'gameport': add driver tmdc
[    9.011279] bus: 'serio': add driver warrior
[    9.012241] bus: 'platform': add driver max8925-onkey
[    9.013315] bus: 'i2c': add driver mpu3050
[    9.014197] bus: 'platform': add driver pcf50633-input
[    9.015275] bus: 'i2c': add driver pcf8574_keypad
[    9.016231] device: 'input1': device_add
[    9.016512] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
[    9.016540] driver: 'serio0': driver_bound: bound to device 'atkbd'
[    9.016543] bus: 'serio': really_probe: bound device serio0 to driver atkbd
[    9.016548] bus: 'serio': driver_probe_device: matched device serio1 with driver atkbd
[    9.016550] bus: 'serio': really_probe: probing driver atkbd with device serio1
[    9.021976] atkbd: probe of serio1 rejects match -19
[    9.026710] bus: 'platform': add driver rotary-encoder
[    9.027764] device: 'uinput': device_add
[    9.028756] bus: 'i2c': add driver smbus_alert
[    9.029718] i2c /dev entries driver
[    9.030410] device class 'i2c-dev': registering
[    9.031279] bus: 'platform': add driver simtec-i2c
[    9.032265] i2c-parport-light: adapter type unspecified
[    9.033300] bus: 'serio': add driver taos-evm
[    9.034247] bus: 'usb': add driver i2c-tiny-usb
[    9.035176] usbcore: registered new interface driver i2c-tiny-usb
[    9.036265] Driver for 1-wire Dallas network protocol.
[    9.037350] bus: 'w1': registered
[    9.038070] bus: 'w1': add driver w1_master_driver
[    9.039035] bus: 'w1': add driver w1_slave_driver
[    9.040096] device: 'test_ac': device_add
[    9.041047] power_supply test_ac: power_supply_changed
[    9.042138] power_supply test_ac: power_supply_changed_work
[    9.043215] device: 'test_battery': device_add
[    9.044403] device: 'thermal_zone0': device_add
[    9.045542] device: 'hwmon0': device_add
[    9.046480] power_supply test_battery: power_supply_changed
[    9.047526] power_supply test_battery: power_supply_changed_work
[    9.048901] device: 'test_usb': device_add
[    9.049767] power_supply test_usb: power_supply_changed
[    9.050783] bus: 'platform': add driver ds2780-battery
[    9.051893] bus: 'platform': add driver ds2781-battery
[    9.053017] bus: 'i2c': add driver ds2782-battery
[    9.053991] bus: 'platform': add driver pcf50633-mbc
[    9.055006] bus: 'platform': add driver max8903-charger
[    9.056033] power_supply test_usb: power_supply_changed_work
[    9.057182] bus: 'i2c': add driver asb100
[    9.058065] bus: 'i2c': add driver w83792d
[    9.058977] bus: 'i2c': add driver w83795
[    9.059717] bus: 'i2c': add driver ad7414
[    9.060539] bus: 'i2c': add driver adm1025
[    9.061458] bus: 'i2c': add driver adm1029
[    9.062278] bus: 'i2c': add driver ads1015
[    9.063167] bus: 'i2c': add driver ads7828
[    9.064029] bus: 'i2c': add driver adt7411
[    9.064936] bus: 'i2c': add driver adt7475
[    9.065761] bus: 'i2c': add driver asc7621
[    9.066551] bus: 'i2c': add driver atxp1
[    9.067343] bus: 'i2c': add driver ds620
[    9.068206] bus: 'i2c': add driver emc2103
[    9.069087] bus: 'i2c': add driver f75375
[    9.069967] bus: 'platform': add driver gpio-fan
[    9.070908] bus: 'i2c': add driver jc42
[    9.071667] bus: 'i2c': add driver lm63
[    9.072452] bus: 'i2c': add driver lm73
[    9.073285] bus: 'i2c': add driver lm75
[    9.074143] bus: 'i2c': add driver lm77
[    9.075051] bus: 'i2c': add driver lm78
[    9.075766] bus: 'i2c': add driver lm85
[    9.076563] bus: 'i2c': add driver lm87
[    9.077435] bus: 'i2c': add driver lm92
[    9.086811] bus: 'i2c': add driver lm93
[    9.087460] bus: 'i2c': add driver lm95241
[    9.088125] bus: 'i2c': add driver lm95245
[    9.088850] bus: 'i2c': add driver ltc4245
[    9.089590] bus: 'i2c': add driver mcp3021
[    9.090344] bus: 'platform': add driver ntc-thermistor
[    9.091293] sch56xx_common: Unsupported device id: 0xff
[    9.092205] sch56xx_common: Unsupported device id: 0xff
[    9.093022] bus: 'platform': add driver sch5627
[    9.093804] bus: 'platform': add driver sch5636
[    9.094528] bus: 'i2c': add driver sht21
[    9.095186] bus: 'i2c': add driver smm665
[    9.109955] bus: 'i2c': add driver smsc47m192
[    9.110729] bus: 'i2c': add driver amc6821
[    9.111424] bus: 'i2c': add driver thmc50
[    9.112121] bus: 'i2c': add driver tmp401
[    9.112839] bus: 'i2c': add driver w83l785ts
[    9.113535] bus: 'i2c': add driver pmbus
[    9.114169] bus: 'i2c': add driver adm1275
[    9.142459] bus: 'i2c': add driver lm25066
[    9.143174] bus: 'i2c': add driver ltc2978
[    9.143924] bus: 'i2c': add driver max16064
[    9.144695] bus: 'i2c': add driver max34440
[    9.145320] bus: 'i2c': add driver ucd9000
[    9.146039] bus: 'i2c': add driver ucd9200
[    9.146721] bus: 'i2c': add driver zl6100
[    9.147353] bus: 'isa': add driver pcwd
[    9.149125] device: 'pcwd.0': device_add
[    9.149808] bus: 'isa': add device pcwd.0
[    9.150592] device: 'pcwd.0': device_unregister
[    9.151357] bus: 'isa': remove device pcwd.0
[    9.152120] device: 'pcwd.1': device_add
[    9.152825] bus: 'isa': add device pcwd.1
[    9.172683] device: 'pcwd.1': device_unregister
[    9.173480] bus: 'isa': remove device pcwd.1
[    9.177825] device: 'pcwd.2': device_add
[    9.178552] bus: 'isa': add device pcwd.2
[    9.179306] device: 'pcwd.2': device_unregister
[    9.180172] bus: 'isa': remove device pcwd.2
[    9.180963] bus: 'isa': remove driver pcwd
[    9.200535] driver: 'pcwd': driver_release
[    9.201540] mixcomwd: No card detected, or port not available
[    9.213645] bus: 'usb': add driver pcwd_usb
[    9.217957] usbcore: registered new interface driver pcwd_usb
[    9.218906] acquirewdt: WDT driver for Acquire single board computer initialising
[    9.220156] bus: 'platform': add driver acquirewdt
[    9.220998] Registering platform device 'acquirewdt'. Parent at platform
[    9.222085] device: 'acquirewdt': device_add
[    9.233086] bus: 'platform': add device acquirewdt
[    9.234061] bus: 'platform': driver_probe_device: matched device acquirewdt with driver acquirewdt
[    9.235640] bus: 'platform': really_probe: probing driver acquirewdt with device acquirewdt
[    9.237036] acquirewdt: I/O address 0x0043 already in use
[    9.237937] acquirewdt: probe of acquirewdt failed with error -5
[    9.249139] device: 'watchdog': device_add
[    9.249961] sc520_wdt: WDT driver for SC520 initialised. timeout=30 sec (nowayout=0)
[    9.251293] wafer5823wdt: WDT driver for Wafer 5823 single board computer initialising
[    9.273683] wafer5823wdt: cannot register miscdev on minor=130 (err=-16)
[    9.274908] it87_wdt: no device
[    9.275462] sc1200wdt: build 20020303
[    9.276096] bus: 'pnp': add driver scl200wdt
[    9.276888] sc1200wdt: io parameter must be specified
[    9.277757] bus: 'pnp': remove driver scl200wdt
[    9.279874] driver: 'scl200wdt': driver_release
[    9.280688] pc87413_wdt: Version 1.1 at io 0x2E
[    9.281529] pc87413_wdt: cannot register miscdev on minor=130 (err=-16)
[    9.282697] sbc60xxwdt: cannot register miscdev on minor=130 (err=-16)
[    9.283867] sbc8360: failed to register misc device
[    9.284808] cpu5wdt: misc_register failed
[    9.285539] w83627hf_wdt: WDT driver for the Winbond(TM) W83627HF/THF/HG/DHG Super I/O chip initialising
[    9.309119] w83627hf_wdt: Watchdog already running. Resetting timeout to 60 sec
[    9.310365] w83627hf_wdt: cannot register miscdev on minor=130 (err=-16)
[    9.311528] w83697hf_wdt: WDT driver for W83697HF/HG initializing
[    9.312648] w83697hf_wdt: watchdog not found at address 0x2e
[    9.313599] w83697hf_wdt: No W83697HF/HG could be found
[    9.314498] machzwd: MachZ ZF-Logic Watchdog driver initializing
[    9.315510] machzwd: no ZF-Logic found
[    9.316220] watchdog: Software Watchdog: cannot register miscdev on minor=130 (err=-16).
[    9.317607] watchdog: Software Watchdog: a legacy watchdog module is probably present.
[    9.318949] device: 'watchdog1': device_add
[    9.319801] softdog: Software Watchdog Timer: 0.08 initialized. soft_noboot=0 soft_margin=60 sec soft_panic=0 (nowayout=0)
[    9.330891] md: linear personality registered for level -1
[    9.331852] md: raid0 personality registered for level 0
[    9.332800] md: raid1 personality registered for level 1
[    9.333675] md: raid10 personality registered for level 10
[    9.334527] md: raid6 personality registered for level 6
[    9.335292] md: raid5 personality registered for level 5
[    9.336167] md: raid4 personality registered for level 4
[    9.338010] device-mapper: uevent: version 1.0.3
[    9.339184] device: 'device-mapper': device_add
[    9.340099] device-mapper: ioctl: 4.23.0-ioctl (2012-07-25) initialised: dm-devel@redhat.com
[    9.353959] device-mapper: dm-log-userspace: version 1.1.0 loaded
[    9.355015] Bluetooth: Virtual HCI driver ver 1.3
[    9.355893] device: 'vhci': device_add
[    9.356669] Bluetooth: HCI UART driver ver 2.2
[    9.357477] Bluetooth: HCILL protocol initialized
[    9.358277] Bluetooth: HCIATH3K protocol initialized
[    9.359114] bus: 'usb': add driver bpa10x
[    9.359822] usbcore: registered new interface driver bpa10x
[    9.360757] bus: 'usb': add driver btusb
[    9.361461] usbcore: registered new interface driver btusb
[    9.362422] Bluetooth: Bluetooth Driver for TI WiLink - Version 1.0
[    9.363430] bus: 'platform': add driver btwilink
[    9.364264] Modular ISDN core version 1.1.29
[    9.378050] device class 'mISDN': registering
[    9.378897] device: 'mISDNtimer': device_add
[    9.379899] NET: Registered protocol family 34
[    9.380729] DSP module 2.0
[    9.381208] mISDN_dsp: DSP clocks every 64 samples. This equals 2 jiffies.
[    9.384315] device class 'dsp_pipeline': registering
[    9.385210] device: 'hwec': device_add
[    9.385959] gigaset: Driver for Gigaset 307x
[    9.386666] gigaset: no ISDN subsystem interface
[    9.387406] bus: 'usb': add driver bas_gigaset
[    9.388167] usbcore: registered new interface driver bas_gigaset
[    9.389149] bas_gigaset: USB Driver for Gigaset 307x
[    9.403052] bus: 'platform': add driver ser_gigaset
[    9.403939] bus: 'pci': add driver pci_eisa
[    9.404759] Registering platform device 'eisa.0'. Parent at platform
[    9.405837] device: 'eisa.0': device_add
[    9.406554] bus: 'platform': add device eisa.0
[    9.407435] EISA: Probing bus 0 at eisa.0
[    9.408123] EISA: Cannot allocate resource for mainboard
[    9.409080] bus: 'platform': remove device eisa.0
[    9.409917] cpuidle: using governor ladder
[    9.410606] cpuidle: using governor menu
[    9.424509] bus: 'memstick': registered
[    9.425162] device class 'memstick_host': registering
[    9.426072] bus: 'memstick': add driver mspro_block
[    9.426965] device: 'vhost-net': device_add
[    9.427864] bus: 'ipack': registered
[    9.428568] bus: 'ipack': add driver ipoctal
[    9.429348] beceem: Beceem Communications Inc. WiMAX driver, 5.2.45
[    9.430406] Copyright 2010. Beceem Communications Inc
[    9.431238] device class 'beceem': registering
[    9.432037] bus: 'usb': add driver usbbcm
[    9.432720] usbcore: registered new interface driver usbbcm
[    9.433635] bus: 'usb': add driver ft1000usb
[    9.434417] usbcore: registered new interface driver ft1000usb
[    9.449502] bus: 'i2c': add driver cptm1217
[    9.450262] i2c-core: driver [cptm1217] using legacy suspend method
[    9.451307] i2c-core: driver [cptm1217] using legacy resume method
[    9.452404] bus: 'i2c': add driver synaptics_rmi4_i2c
[    9.453553] device: 'binder': device_add
[    9.454860] device: 'ashmem': device_add
[    9.455654] ashmem: initialized
[    9.456231] device class 'timed_output': registering
[    9.457050] bus: 'platform': add driver timed-gpio
[    9.457872] device class 'ozmo_wpan': registering
[    9.458718] device: 'ozwpan': device_add
[    9.459583] bus: 'platform': add driver ozwpan
[    9.460460] Registering platform device 'ozwpan'. Parent at platform
[    9.461526] device: 'ozwpan': device_add
[    9.462178] bus: 'platform': add device ozwpan
[    9.463076] bus: 'platform': driver_probe_device: matched device ozwpan with driver ozwpan
[    9.464559] bus: 'platform': really_probe: probing driver ozwpan with device ozwpan
[    9.478941] ozwpan ozwpan: Ozmo Devices WPAN
[    9.479780] ozwpan ozwpan: new USB bus registered, assigned bus number 1
[    9.481297] device: 'usb1': device_add
[    9.482192] bus: 'usb': add device usb1
[    9.482971] bus: 'usb': driver_probe_device: matched device usb1 with driver usb
[    9.484188] bus: 'usb': really_probe: probing driver usb with device usb1
[    9.485329] device: '1-0:1.0': device_add
[    9.486056] bus: 'usb': add device 1-0:1.0
[    9.486769] bus: 'usb': driver_probe_device: matched device 1-0:1.0 with driver hub
[    9.487949] bus: 'usb': really_probe: probing driver hub with device 1-0:1.0
[    9.489201] hub 1-0:1.0: USB hub found
[    9.489933] hub 1-0:1.0: 8 ports detected
[    9.503992] driver: '1-0:1.0': driver_bound: bound to device 'hub'
[    9.505096] bus: 'usb': really_probe: bound device 1-0:1.0 to driver hub
[    9.506307] device: 'ep_81': device_add
[    9.507026] driver: 'usb1': driver_bound: bound to device 'usb'
[    9.507892] bus: 'usb': really_probe: bound device usb1 to driver usb
[    9.508880] device: 'ep_00': device_add
[    9.509601] driver: 'ozwpan': driver_bound: bound to device 'ozwpan'
[    9.510674] bus: 'platform': really_probe: bound device ozwpan to driver ozwpan
[    9.511976] hdaps: supported laptop not found!
[    9.512822] hdaps: driver init failed (ret=-19)!
[    9.513880] pktgen: Packet Generator for packet performance testing. Version: 2.74
[    9.527772] NET: Registered protocol family 26
[    9.528527] Netfilter messages via NETLINK v0.30.
[    9.529296] nfnl_acct: registering with nfnetlink.
[    9.530177] nf_conntrack version 0.5.0 (3181 buckets, 12724 max)
[    9.531875] ctnetlink v0.93: registering with nfnetlink.
[    9.532986] xt_time: kernel timezone is -0000
[    9.533799] IPVS: Registered protocols (TCP, UDP, SCTP)
[    9.534914] IPVS: Connection hash table configured (size=4096, memory=32Kbytes)
[    9.536069] IPVS: Each connection entry needs 272 bytes at least
[    9.537183] IPVS: Creating netns size=1756 id=0
[    9.537969] IPVS: ipvs loaded.
[    9.553609] IPVS: [lblc] scheduler registered.
[    9.554328] IPVS: [sh] scheduler registered.
[    9.555092] IPVS: [nq] scheduler registered.
[    9.556010] ip_tables: (C) 2000-2006 Netfilter Core Team
[    9.556950] TCP: bic registered
[    9.557515] TCP: cubic registered
[    9.558016] TCP: westwood registered
[    9.558623] TCP: highspeed registered
[    9.559218] TCP: vegas registered
[    9.559818] TCP: veno registered
[    9.560418] TCP: yeah registered
[    9.560962] TCP: illinois registered
[    9.561594] Initializing XFRM netlink socket
[    9.578606] NET: Registered protocol family 10
[    9.580919] mip6: Mobile IPv6
[    9.581476] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    9.582503] sit: IPv6 over IPv4 tunneling driver
[    9.583227] device: 'sit0': device_add
[    9.584345] NET: Registered protocol family 5
[    9.585645] NET: Registered protocol family 33
[    9.586437] Key type rxrpc registered
[    9.587039] Key type rxrpc_s registered
[    9.587755] lec:lane_module_init: lec.c: initialized
[    9.588642] l2tp_core: L2TP core driver, V2.0
[    9.589342] l2tp_debugfs: L2TP debugfs support
[    9.590111] NET: Registered protocol family 35
[    9.604534] 8021q: 802.1Q VLAN Support v1.8
[    9.606643] DCCP: Activated CCID 2 (TCP-like)
[    9.609278] sctp: Hash tables configured (established 1365 bind 1489)
[    9.610921] tipc: Activated (version 2.0.0)
[    9.612786] NET: Registered protocol family 30
[    9.613577] tipc: Started in single node mode
[    9.614246] 9pnet: Installing 9P2000 support
[    9.615025] bus: 'virtio': add driver 9pnet_virtio
[    9.628991] Key type dns_resolver registered
[    9.629831] Key type ceph registered
[    9.630476] libceph: loaded (mon/osd proto 15/24, osdmap 5/6 5/6)
[    9.640351] batman_adv: B.A.T.M.A.N. advanced 2012.3.0 (compatibility version 14) loaded
[    9.641783] openvswitch: Open vSwitch switching datapath
[    9.643164] bus: 'machinecheck': registered
[    9.643874] device: 'machinecheck': device_add
[    9.644678] device: 'machinecheck0': device_add
[    9.645458] bus: 'machinecheck': add device machinecheck0
[    9.646556] device: 'machinecheck1': device_add
[    9.647322] bus: 'machinecheck': add device machinecheck1
[    9.648487] device: 'mcelog': device_add
[    9.649612] 
[    9.649612] printing PIC contents
[    9.669622] ... PIC  IMR: ffff
[    9.670145] ... PIC  IRR: 1013
[    9.670686] ... PIC  ISR: 0000
[    9.671186] ... PIC ELCR: 0c00
[    9.671766] printing local APIC contents on CPU#0/0:
[    9.672567] ... APIC ID:      00000000 (0)
[    9.673256] ... APIC VERSION: 00050014
[    9.673893] ... APIC TASKPRI: 00000000 (00)
[    9.674582] ... APIC PROCPRI: 00000000
[    9.675186] ... APIC LDR: 01000000
[    9.675755] ... APIC DFR: ffffffff
[    9.675755] ... APIC SPIV: 000001ff
[    9.675755] ... APIC ISR field:
[    9.675755] 0000000000000000000000000000000000000000000000000000000000000000
[    9.675755] ... APIC TMR field:
[    9.675755] 0000000000000000000000000000000000000000000000000000000000000000
[    9.675755] ... APIC IRR field:
[    9.675755] 0000000000000000000000000000000000000000000000000000000000000000
[    9.675755] ... APIC ESR: 00000000
[    9.675755] ... APIC ICR: 000008fd
[    9.675755] ... APIC ICR2: 02000000
[    9.675755] ... APIC LVTT: 000000ef
[    9.675755] ... APIC LVTPC: 00010000
[    9.675755] ... APIC LVT0: 00010700
[    9.675755] ... APIC LVT1: 00000400
[    9.675755] ... APIC LVTERR: 000000fe
[    9.675755] ... APIC TMICT: 004bb02a
[    9.675755] ... APIC TMCCT: 0016b4da
[    9.675755] ... APIC TDCR: 00000003
[    9.675755] 
[    9.715434] number of MP IRQ sources: 15.
[    9.716124] number of IO-APIC #2 registers: 24.
[    9.716909] testing the IO APIC.......................
[    9.717768] IO APIC #2......
[    9.718236] .... register #00: 00000000
[    9.718906] .......    : physical APIC id: 00
[    9.719653] .......    : Delivery Type: 0
[    9.720330] .......    : LTS          : 0
[    9.721020] .... register #01: 00170011
[    9.721651] .......     : max redirection entries: 17
[    9.741986] .......     : PRQ implemented: 0
[    9.742703] .......     : IO APIC version: 11
[    9.743430] .... register #02: 00000000
[    9.744117] .......     : arbitration: 00
[    9.744827] .... IRQ redirection table:
[    9.745517]  NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:
[    9.746490]  00 00  1    0    0   0   0    0    0    00
[    9.747355]  01 03  0    0    0   0   0    1    1    31
[    9.748286]  02 03  0    0    0   0   0    1    1    30
[    9.749183]  03 03  0    0    0   0   0    1    1    33
[    9.750084]  04 03  1    0    0   0   0    1    1    34
[    9.751010]  05 03  1    1    0   0   0    1    1    35
[    9.768052]  06 03  0    0    0   0   0    1    1    36
[    9.769023]  07 03  0    0    0   0   0    1    1    37
[    9.769971]  08 03  0    0    0   0   0    1    1    38
[    9.770893]  09 03  0    1    0   0   0    1    1    39
[    9.771799]  0a 03  1    1    0   0   0    1    1    3A
[    9.772753]  0b 03  1    1    0   0   0    1    1    3B
[    9.773635]  0c 03  0    0    0   0   0    1    1    3C
[    9.774520]  0d 03  0    0    0   0   0    1    1    3D
[    9.775352]  0e 03  0    0    0   0   0    1    1    3E
[    9.776273]  0f 03  0    0    0   0   0    1    1    3F
[    9.777224]  10 00  1    0    0   0   0    0    0    00
[    9.786260]  11 00  1    0    0   0   0    0    0    00
[    9.787157]  12 00  1    0    0   0   0    0    0    00
[    9.788105]  13 00  1    0    0   0   0    0    0    00
[    9.789017]  14 00  1    0    0   0   0    0    0    00
[    9.789911]  15 00  1    0    0   0   0    0    0    00
[    9.790801]  16 00  1    0    0   0   0    0    0    00
[    9.791706]  17 00  1    0    0   0   0    0    0    00
[    9.792677] IRQ to pin mappings:
[    9.793247] IRQ0 -> 0:2
[    9.793745] IRQ1 -> 0:1
[    9.794216] IRQ3 -> 0:3
[    9.811760] IRQ4 -> 0:4
[    9.812267] IRQ5 -> 0:5
[    9.812762] IRQ6 -> 0:6
[    9.813226] IRQ7 -> 0:7
[    9.813721] IRQ8 -> 0:8
[    9.814185] IRQ9 -> 0:9
[    9.814629] IRQ10 -> 0:10
[    9.815058] IRQ11 -> 0:11
[    9.815529] IRQ12 -> 0:12
[    9.815969] IRQ13 -> 0:13
[    9.816488] IRQ14 -> 0:14
[    9.816915] IRQ15 -> 0:15
[    9.817336] .................................... done.
[    9.818190] Using IPI Shortcut mode
[    9.818893] device: 'cpu_dma_latency': device_add
[    9.819793] device: 'network_latency': device_add
[    9.820709] device: 'network_throughput': device_add
[    9.821673] registered taskstats version 1
[    9.822562] kAFS: Red Hat AFS client v0.1 registering.
[    9.843806] Key type trusted registered
[    9.845067] Key type encrypted registered
[    9.846149] raid6test: testing the 4-disk case...
[    9.847011] raid6test: test_disks(0, 1): faila=  0(D)  failb=  1(D)  OK
[    9.848119] raid6test: test_disks(0, 2): faila=  0(D)  failb=  2(P)  OK
[    9.849161] raid6test: test_disks(0, 3): faila=  0(D)  failb=  3(Q)  OK
[    9.850254] raid6test: test_disks(1, 2): faila=  1(D)  failb=  2(P)  OK
[    9.851333] raid6test: test_disks(1, 3): faila=  1(D)  failb=  3(Q)  OK
[    9.852505] raid6test: test_disks(2, 3): faila=  2(P)  failb=  3(Q)  OK
[    9.853614] raid6test: testing the 5-disk case...
[    9.861523] raid6test: test_disks(0, 1): faila=  0(D)  failb=  1(D)  OK
[    9.862605] raid6test: test_disks(0, 2): faila=  0(D)  failb=  2(D)  OK
[    9.863698] raid6test: test_disks(0, 3): faila=  0(D)  failb=  3(P)  OK
[    9.864808] raid6test: test_disks(0, 4): faila=  0(D)  failb=  4(Q)  OK
[    9.873877] raid6test: test_disks(1, 2): faila=  1(D)  failb=  2(D)  OK
[    9.874976] raid6test: test_disks(1, 3): faila=  1(D)  failb=  3(P)  OK
[    9.876093] raid6test: test_disks(1, 4): faila=  1(D)  failb=  4(Q)  OK
[    9.877195] raid6test: test_disks(2, 3): faila=  2(D)  failb=  3(P)  OK
[    9.878267] raid6test: test_disks(2, 4): faila=  2(D)  failb=  4(Q)  OK
[    9.889465] raid6test: test_disks(3, 4): faila=  3(P)  failb=  4(Q)  OK
[    9.890591] raid6test: testing the 11-disk case...
[    9.891431] raid6test: test_disks(0, 1): faila=  0(D)  failb=  1(D)  OK
[    9.896654] raid6test: test_disks(0, 2): faila=  0(D)  failb=  2(D)  OK
[    9.897777] raid6test: test_disks(0, 3): faila=  0(D)  failb=  3(D)  OK
[    9.898867] raid6test: test_disks(0, 4): faila=  0(D)  failb=  4(D)  OK
[    9.899956] raid6test: test_disks(0, 5): faila=  0(D)  failb=  5(D)  OK
[    9.901061] raid6test: test_disks(0, 6): faila=  0(D)  failb=  6(D)  OK
[    9.902180] raid6test: test_disks(0, 7): faila=  0(D)  failb=  7(D)  OK
[    9.903304] raid6test: test_disks(0, 8): faila=  0(D)  failb=  8(D)  OK
[    9.904423] raid6test: test_disks(0, 9): faila=  0(D)  failb=  9(P)  OK
[    9.919039] raid6test: test_disks(0, 10): faila=  0(D)  failb= 10(Q)  OK
[    9.920193] raid6test: test_disks(1, 2): faila=  1(D)  failb=  2(D)  OK
[    9.921323] raid6test: test_disks(1, 3): faila=  1(D)  failb=  3(D)  OK
[    9.943547] raid6test: test_disks(1, 4): faila=  1(D)  failb=  4(D)  OK
[    9.944700] raid6test: test_disks(1, 5): faila=  1(D)  failb=  5(D)  OK
[    9.945812] raid6test: test_disks(1, 6): faila=  1(D)  failb=  6(D)  OK
[    9.946937] raid6test: test_disks(1, 7): faila=  1(D)  failb=  7(D)  OK
[    9.962404] raid6test: test_disks(1, 8): faila=  1(D)  failb=  8(D)  OK
[    9.963724] raid6test: test_disks(1, 9): faila=  1(D)  failb=  9(P)  OK
[    9.964822] raid6test: test_disks(1, 10): faila=  1(D)  failb= 10(Q)  OK
[    9.965941] raid6test: test_disks(2, 3): faila=  2(D)  failb=  3(D)  OK
[    9.975135] raid6test: test_disks(2, 4): faila=  2(D)  failb=  4(D)  OK
[    9.976287] raid6test: test_disks(2, 5): faila=  2(D)  failb=  5(D)  OK
[    9.977575] raid6test: test_disks(2, 6): faila=  2(D)  failb=  6(D)  OK
[    9.978861] raid6test: test_disks(2, 7): faila=  2(D)  failb=  7(D)  OK
[    9.980115] raid6test: test_disks(2, 8): faila=  2(D)  failb=  8(D)  OK
[    9.981403] raid6test: test_disks(2, 9): faila=  2(D)  failb=  9(P)  OK
[    9.996655] raid6test: test_disks(2, 10): faila=  2(D)  failb= 10(Q)  OK
[    9.997763] raid6test: test_disks(3, 4): faila=  3(D)  failb=  4(D)  OK
[    9.998867] raid6test: test_disks(3, 5): faila=  3(D)  failb=  5(D)  OK
[    9.999990] raid6test: test_disks(3, 6): faila=  3(D)  failb=  6(D)  OK
[   10.019170] raid6test: test_disks(3, 7): faila=  3(D)  failb=  7(D)  OK
[   10.020438] raid6test: test_disks(3, 8): faila=  3(D)  failb=  8(D)  OK
[   10.021664] raid6test: test_disks(3, 9): faila=  3(D)  failb=  9(P)  OK
[   10.022886] raid6test: test_disks(3, 10): faila=  3(D)  failb= 10(Q)  OK
[   10.040164] raid6test: test_disks(4, 5): faila=  4(D)  failb=  5(D)  OK
[   10.041316] raid6test: test_disks(4, 6): faila=  4(D)  failb=  6(D)  OK
[   10.042462] raid6test: test_disks(4, 7): faila=  4(D)  failb=  7(D)  OK
[   10.043634] raid6test: test_disks(4, 8): faila=  4(D)  failb=  8(D)  OK
[   10.044891] raid6test: test_disks(4, 9): faila=  4(D)  failb=  9(P)  OK
[   10.046119] raid6test: test_disks(4, 10): faila=  4(D)  failb= 10(Q)  OK
[   10.064480] raid6test: test_disks(5, 6): faila=  5(D)  failb=  6(D)  OK
[   10.065706] raid6test: test_disks(5, 7): faila=  5(D)  failb=  7(D)  OK
[   10.066983] raid6test: test_disks(5, 8): faila=  5(D)  failb=  8(D)  OK
[   10.068264] raid6test: test_disks(5, 9): faila=  5(D)  failb=  9(P)  OK
[   10.082211] raid6test: test_disks(5, 10): faila=  5(D)  failb= 10(Q)  OK
[   10.083500] raid6test: test_disks(6, 7): faila=  6(D)  failb=  7(D)  OK
[   10.084822] raid6test: test_disks(6, 8): faila=  6(D)  failb=  8(D)  OK
[   10.085994] raid6test: test_disks(6, 9): faila=  6(D)  failb=  9(P)  OK
[   10.087136] raid6test: test_disks(6, 10): faila=  6(D)  failb= 10(Q)  OK
[   10.103313] raid6test: test_disks(7, 8): faila=  7(D)  failb=  8(D)  OK
[   10.104447] raid6test: test_disks(7, 9): faila=  7(D)  failb=  9(P)  OK
[   10.105609] raid6test: test_disks(7, 10): faila=  7(D)  failb= 10(Q)  OK
[   10.106837] raid6test: test_disks(8, 9): faila=  8(D)  failb=  9(P)  OK
[   10.108060] raid6test: test_disks(8, 10): faila=  8(D)  failb= 10(Q)  OK
[   10.109173] raid6test: test_disks(9, 10): faila=  9(P)  failb= 10(Q)  OK
[   10.110256] raid6test: testing the 12-disk case...
[   10.111070] raid6test: test_disks(0, 1): faila=  0(D)  failb=  1(D)  OK
[   10.112207] raid6test: test_disks(0, 2): faila=  0(D)  failb=  2(D)  OK
[   10.129428] raid6test: test_disks(0, 3): faila=  0(D)  failb=  3(D)  OK
[   10.130519] raid6test: test_disks(0, 4): faila=  0(D)  failb=  4(D)  OK
[   10.131620] raid6test: test_disks(0, 5): faila=  0(D)  failb=  5(D)  OK
[   10.132833] raid6test: test_disks(0, 6): faila=  0(D)  failb=  6(D)  OK
[   10.134109] raid6test: test_disks(0, 7): faila=  0(D)  failb=  7(D)  OK
[   10.135345] raid6test: test_disks(0, 8): faila=  0(D)  failb=  8(D)  OK
[   10.136642] raid6test: test_disks(0, 9): faila=  0(D)  failb=  9(D)  OK
[   10.137913] raid6test: test_disks(0, 10): faila=  0(D)  failb= 10(P)  OK
[   10.153129] raid6test: test_disks(0, 11): faila=  0(D)  failb= 11(Q)  OK
[   10.154228] raid6test: test_disks(1, 2): faila=  1(D)  failb=  2(D)  OK
[   10.155326] raid6test: test_disks(1, 3): faila=  1(D)  failb=  3(D)  OK
[   10.156629] raid6test: test_disks(1, 4): faila=  1(D)  failb=  4(D)  OK
[   10.157868] raid6test: test_disks(1, 5): faila=  1(D)  failb=  5(D)  OK
[   10.159098] raid6test: test_disks(1, 6): faila=  1(D)  failb=  6(D)  OK
[   10.160197] raid6test: test_disks(1, 7): faila=  1(D)  failb=  7(D)  OK
[   10.161272] raid6test: test_disks(1, 8): faila=  1(D)  failb=  8(D)  OK
[   10.178576] raid6test: test_disks(1, 9): faila=  1(D)  failb=  9(D)  OK
[   10.179845] raid6test: test_disks(1, 10): faila=  1(D)  failb= 10(P)  OK
[   10.181118] raid6test: test_disks(1, 11): faila=  1(D)  failb= 11(Q)  OK
[   10.182357] raid6test: test_disks(2, 3): faila=  2(D)  failb=  3(D)  OK
[   10.183472] raid6test: test_disks(2, 4): faila=  2(D)  failb=  4(D)  OK
[   10.184566] raid6test: test_disks(2, 5): faila=  2(D)  failb=  5(D)  OK
[   10.185712] raid6test: test_disks(2, 6): faila=  2(D)  failb=  6(D)  OK
[   10.186889] raid6test: test_disks(2, 7): faila=  2(D)  failb=  7(D)  OK
[   10.198156] raid6test: test_disks(2, 8): faila=  2(D)  failb=  8(D)  OK
[   10.199424] raid6test: test_disks(2, 9): faila=  2(D)  failb=  9(D)  OK
[   10.200711] raid6test: test_disks(2, 10): faila=  2(D)  failb= 10(P)  OK
[   10.201888] raid6test: test_disks(2, 11): faila=  2(D)  failb= 11(Q)  OK
[   10.203029] raid6test: test_disks(3, 4): faila=  3(D)  failb=  4(D)  OK
[   10.216567] raid6test: test_disks(3, 5): faila=  3(D)  failb=  5(D)  OK
[   10.217825] raid6test: test_disks(3, 6): faila=  3(D)  failb=  6(D)  OK
[   10.219032] raid6test: test_disks(3, 7): faila=  3(D)  failb=  7(D)  OK
[   10.220154] raid6test: test_disks(3, 8): faila=  3(D)  failb=  8(D)  OK
[   10.221259] raid6test: test_disks(3, 9): faila=  3(D)  failb=  9(D)  OK
[   10.227399] raid6test: test_disks(3, 10): faila=  3(D)  failb= 10(P)  OK
[   10.228510] raid6test: test_disks(3, 11): faila=  3(D)  failb= 11(Q)  OK
[   10.229700] raid6test: test_disks(4, 5): faila=  4(D)  failb=  5(D)  OK
[   10.230977] raid6test: test_disks(4, 6): faila=  4(D)  failb=  6(D)  OK
[   10.232265] raid6test: test_disks(4, 7): faila=  4(D)  failb=  7(D)  OK
[   10.233396] raid6test: test_disks(4, 8): faila=  4(D)  failb=  8(D)  OK
[   10.234488] raid6test: test_disks(4, 9): faila=  4(D)  failb=  9(D)  OK
[   10.235609] raid6test: test_disks(4, 10): faila=  4(D)  failb= 10(P)  OK
[   10.250844] raid6test: test_disks(4, 11): faila=  4(D)  failb= 11(Q)  OK
[   10.254251] raid6test: test_disks(5, 6): faila=  5(D)  failb=  6(D)  OK
[   10.255417] raid6test: test_disks(5, 7): faila=  5(D)  failb=  7(D)  OK
[   10.256549] raid6test: test_disks(5, 8): faila=  5(D)  failb=  8(D)  OK
[   10.257662] raid6test: test_disks(5, 9): faila=  5(D)  failb=  9(D)  OK
[   10.258808] raid6test: test_disks(5, 10): faila=  5(D)  failb= 10(P)  OK
[   10.260078] raid6test: test_disks(5, 11): faila=  5(D)  failb= 11(Q)  OK
[   10.261338] raid6test: test_disks(6, 7): faila=  6(D)  failb=  7(D)  OK
[   10.262567] raid6test: test_disks(6, 8): faila=  6(D)  failb=  8(D)  OK
[   10.263667] raid6test: test_disks(6, 9): faila=  6(D)  failb=  9(D)  OK
[   10.264776] raid6test: test_disks(6, 10): faila=  6(D)  failb= 10(P)  OK
[   10.265930] raid6test: test_disks(6, 11): faila=  6(D)  failb= 11(Q)  OK
[   10.279167] raid6test: test_disks(7, 8): faila=  7(D)  failb=  8(D)  OK
[   10.280461] raid6test: test_disks(7, 9): faila=  7(D)  failb=  9(D)  OK
[   10.281585] raid6test: test_disks(7, 10): faila=  7(D)  failb= 10(P)  OK
[   10.282782] raid6test: test_disks(7, 11): faila=  7(D)  failb= 11(Q)  OK
[   10.284072] raid6test: test_disks(8, 9): faila=  8(D)  failb=  9(D)  OK
[   10.285273] raid6test: test_disks(8, 10): faila=  8(D)  failb= 10(P)  OK
[   10.286363] raid6test: test_disks(8, 11): faila=  8(D)  failb= 11(Q)  OK
[   10.287482] raid6test: test_disks(9, 10): faila=  9(D)  failb= 10(P)  OK
[   10.288770] raid6test: test_disks(9, 11): faila=  9(D)  failb= 11(Q)  OK
[   10.289874] raid6test: test_disks(10, 11): faila= 10(P)  failb= 11(Q)  OK
[   10.291042] raid6test: testing the 16-disk case...
[   10.307305] raid6test: test_disks(0, 1): faila=  0(D)  failb=  1(D)  OK
[   10.308580] raid6test: test_disks(0, 2): faila=  0(D)  failb=  2(D)  OK
[   10.309702] raid6test: test_disks(0, 3): faila=  0(D)  failb=  3(D)  OK
[   10.310869] raid6test: test_disks(0, 4): faila=  0(D)  failb=  4(D)  OK
[   10.312178] raid6test: test_disks(0, 5): faila=  0(D)  failb=  5(D)  OK
[   10.313293] raid6test: test_disks(0, 6): faila=  0(D)  failb=  6(D)  OK
[   10.314415] raid6test: test_disks(0, 7): faila=  0(D)  failb=  7(D)  OK
[   10.315678] raid6test: test_disks(0, 8): faila=  0(D)  failb=  8(D)  OK
[   10.316963] raid6test: test_disks(0, 9): faila=  0(D)  failb=  9(D)  OK
[   10.318228] raid6test: test_disks(0, 10): faila=  0(D)  failb= 10(D)  OK
[   10.328856] raid6test: test_disks(0, 11): faila=  0(D)  failb= 11(D)  OK
[   10.330136] raid6test: test_disks(0, 12): faila=  0(D)  failb= 12(D)  OK
[   10.331437] raid6test: test_disks(0, 13): faila=  0(D)  failb= 13(D)  OK
[   10.332647] raid6test: test_disks(0, 14): faila=  0(D)  failb= 14(P)  OK
[   10.333734] raid6test: test_disks(0, 15): faila=  0(D)  failb= 15(Q)  OK
[   10.334881] raid6test: test_disks(1, 2): faila=  1(D)  failb=  2(D)  OK
[   10.336076] raid6test: test_disks(1, 3): faila=  1(D)  failb=  3(D)  OK
[   10.337324] raid6test: test_disks(1, 4): faila=  1(D)  failb=  4(D)  OK
[   10.338477] raid6test: test_disks(1, 5): faila=  1(D)  failb=  5(D)  OK
[   10.339707] raid6test: test_disks(1, 6): faila=  1(D)  failb=  6(D)  OK
[   10.341003] raid6test: test_disks(1, 7): faila=  1(D)  failb=  7(D)  OK
[   10.359708] raid6test: test_disks(1, 8): faila=  1(D)  failb=  8(D)  OK
[   10.360986] raid6test: test_disks(1, 9): faila=  1(D)  failb=  9(D)  OK
[   10.362291] raid6test: test_disks(1, 10): faila=  1(D)  failb= 10(D)  OK
[   10.363607] raid6test: test_disks(1, 11): faila=  1(D)  failb= 11(D)  OK
[   10.364894] raid6test: test_disks(1, 12): faila=  1(D)  failb= 12(D)  OK
[   10.366185] raid6test: test_disks(1, 13): faila=  1(D)  failb= 13(D)  OK
[   10.367470] raid6test: test_disks(1, 14): faila=  1(D)  failb= 14(P)  OK
[   10.368694] raid6test: test_disks(1, 15): faila=  1(D)  failb= 15(Q)  OK
[   10.369793] raid6test: test_disks(2, 3): faila=  2(D)  failb=  3(D)  OK
[   10.370882] raid6test: test_disks(2, 4): faila=  2(D)  failb=  4(D)  OK
[   10.371975] raid6test: test_disks(2, 5): faila=  2(D)  failb=  5(D)  OK
[   10.373081] raid6test: test_disks(2, 6): faila=  2(D)  failb=  6(D)  OK
[   10.374192] raid6test: test_disks(2, 7): faila=  2(D)  failb=  7(D)  OK
[   10.389868] raid6test: test_disks(2, 8): faila=  2(D)  failb=  8(D)  OK
[   10.391135] raid6test: test_disks(2, 9): faila=  2(D)  failb=  9(D)  OK
[   10.392434] raid6test: test_disks(2, 10): faila=  2(D)  failb= 10(D)  OK
[   10.393679] raid6test: test_disks(2, 11): faila=  2(D)  failb= 11(D)  OK
[   10.394908] raid6test: test_disks(2, 12): faila=  2(D)  failb= 12(D)  OK
[   10.396050] raid6test: test_disks(2, 13): faila=  2(D)  failb= 13(D)  OK
[   10.397141] raid6test: test_disks(2, 14): faila=  2(D)  failb= 14(P)  OK
[   10.398223] raid6test: test_disks(2, 15): faila=  2(D)  failb= 15(Q)  OK
[   10.409519] raid6test: test_disks(3, 4): faila=  3(D)  failb=  4(D)  OK
[   10.410643] raid6test: test_disks(3, 5): faila=  3(D)  failb=  5(D)  OK
[   10.411745] raid6test: test_disks(3, 6): faila=  3(D)  failb=  6(D)  OK
[   10.412941] raid6test: test_disks(3, 7): faila=  3(D)  failb=  7(D)  OK
[   10.414202] raid6test: test_disks(3, 8): faila=  3(D)  failb=  8(D)  OK
[   10.415498] raid6test: test_disks(3, 9): faila=  3(D)  failb=  9(D)  OK
[   10.416625] raid6test: test_disks(3, 10): faila=  3(D)  failb= 10(D)  OK
[   10.429473] raid6test: test_disks(3, 11): faila=  3(D)  failb= 11(D)  OK
[   10.430705] raid6test: test_disks(3, 12): faila=  3(D)  failb= 12(D)  OK
[   10.431947] raid6test: test_disks(3, 13): faila=  3(D)  failb= 13(D)  OK
[   10.433064] raid6test: test_disks(3, 14): faila=  3(D)  failb= 14(P)  OK
[   10.434178] raid6test: test_disks(3, 15): faila=  3(D)  failb= 15(Q)  OK
[   10.435326] raid6test: test_disks(4, 5): faila=  4(D)  failb=  5(D)  OK
[   10.436623] raid6test: test_disks(4, 6): faila=  4(D)  failb=  6(D)  OK
[   10.437870] raid6test: test_disks(4, 7): faila=  4(D)  failb=  7(D)  OK
[   10.439098] raid6test: test_disks(4, 8): faila=  4(D)  failb=  8(D)  OK
[   10.440400] raid6test: test_disks(4, 9): faila=  4(D)  failb=  9(D)  OK
[   10.452401] raid6test: test_disks(4, 10): faila=  4(D)  failb= 10(D)  OK
[   10.453519] raid6test: test_disks(4, 11): faila=  4(D)  failb= 11(D)  OK
[   10.454636] raid6test: test_disks(4, 12): faila=  4(D)  failb= 12(D)  OK
[   10.455751] raid6test: test_disks(4, 13): faila=  4(D)  failb= 13(D)  OK
[   10.456922] raid6test: test_disks(4, 14): faila=  4(D)  failb= 14(P)  OK
[   10.458180] raid6test: test_disks(4, 15): faila=  4(D)  failb= 15(Q)  OK
[   10.459498] raid6test: test_disks(5, 6): faila=  5(D)  failb=  6(D)  OK
[   10.460794] raid6test: test_disks(5, 7): faila=  5(D)  failb=  7(D)  OK
[   10.461987] raid6test: test_disks(5, 8): faila=  5(D)  failb=  8(D)  OK
[   10.463101] raid6test: test_disks(5, 9): faila=  5(D)  failb=  9(D)  OK
[   10.464229] raid6test: test_disks(5, 10): faila=  5(D)  failb= 10(D)  OK
[   10.479793] raid6test: test_disks(5, 11): faila=  5(D)  failb= 11(D)  OK
[   10.480937] raid6test: test_disks(5, 12): faila=  5(D)  failb= 12(D)  OK
[   10.482046] raid6test: test_disks(5, 13): faila=  5(D)  failb= 13(D)  OK
[   10.483151] raid6test: test_disks(5, 14): faila=  5(D)  failb= 14(P)  OK
[   10.484266] raid6test: test_disks(5, 15): faila=  5(D)  failb= 15(Q)  OK
[   10.485411] raid6test: test_disks(6, 7): faila=  6(D)  failb=  7(D)  OK
[   10.486530] raid6test: test_disks(6, 8): faila=  6(D)  failb=  8(D)  OK
[   10.487635] raid6test: test_disks(6, 9): faila=  6(D)  failb=  9(D)  OK
[   10.488783] raid6test: test_disks(6, 10): faila=  6(D)  failb= 10(D)  OK
[   10.490020] raid6test: test_disks(6, 11): faila=  6(D)  failb= 11(D)  OK
[   10.491267] raid6test: test_disks(6, 12): faila=  6(D)  failb= 12(D)  OK
[   10.503182] raid6test: test_disks(6, 13): faila=  6(D)  failb= 13(D)  OK
[   10.504489] raid6test: test_disks(6, 14): faila=  6(D)  failb= 14(P)  OK
[   10.505749] raid6test: test_disks(6, 15): faila=  6(D)  failb= 15(Q)  OK
[   10.506916] raid6test: test_disks(7, 8): faila=  7(D)  failb=  8(D)  OK
[   10.508163] raid6test: test_disks(7, 9): faila=  7(D)  failb=  9(D)  OK
[   10.509430] raid6test: test_disks(7, 10): faila=  7(D)  failb= 10(D)  OK
[   10.510551] raid6test: test_disks(7, 11): faila=  7(D)  failb= 11(D)  OK
[   10.511701] raid6test: test_disks(7, 12): faila=  7(D)  failb= 12(D)  OK
[   10.512835] raid6test: test_disks(7, 13): faila=  7(D)  failb= 13(D)  OK
[   10.513981] raid6test: test_disks(7, 14): faila=  7(D)  failb= 14(P)  OK
[   10.527885] raid6test: test_disks(7, 15): faila=  7(D)  failb= 15(Q)  OK
[   10.529093] raid6test: test_disks(8, 9): faila=  8(D)  failb=  9(D)  OK
[   10.530202] raid6test: test_disks(8, 10): faila=  8(D)  failb= 10(D)  OK
[   10.531325] raid6test: test_disks(8, 11): faila=  8(D)  failb= 11(D)  OK
[   10.532472] raid6test: test_disks(8, 12): faila=  8(D)  failb= 12(D)  OK
[   10.533585] raid6test: test_disks(8, 13): faila=  8(D)  failb= 13(D)  OK
[   10.534803] raid6test: test_disks(8, 14): faila=  8(D)  failb= 14(P)  OK
[   10.536079] raid6test: test_disks(8, 15): faila=  8(D)  failb= 15(Q)  OK
[   10.537361] raid6test: test_disks(9, 10): faila=  9(D)  failb= 10(D)  OK
[   10.538634] raid6test: test_disks(9, 11): faila=  9(D)  failb= 11(D)  OK
[   10.552578] raid6test: test_disks(9, 12): faila=  9(D)  failb= 12(D)  OK
[   10.553865] raid6test: test_disks(9, 13): faila=  9(D)  failb= 13(D)  OK
[   10.555143] raid6test: test_disks(9, 14): faila=  9(D)  failb= 14(P)  OK
[   10.556484] raid6test: test_disks(9, 15): faila=  9(D)  failb= 15(Q)  OK
[   10.557620] raid6test: test_disks(10, 11): faila= 10(D)  failb= 11(D)  OK
[   10.558749] raid6test: test_disks(10, 12): faila= 10(D)  failb= 12(D)  OK
[   10.559901] raid6test: test_disks(10, 13): faila= 10(D)  failb= 13(D)  OK
[   10.561068] raid6test: test_disks(10, 14): faila= 10(D)  failb= 14(P)  OK
[   10.562266] raid6test: test_disks(10, 15): faila= 10(D)  failb= 15(Q)  OK
[   10.563599] raid6test: test_disks(11, 12): faila= 11(D)  failb= 12(D)  OK
[   10.579227] raid6test: test_disks(11, 13): faila= 11(D)  failb= 13(D)  OK
[   10.580339] raid6test: test_disks(11, 14): faila= 11(D)  failb= 14(P)  OK
[   10.581472] raid6test: test_disks(11, 15): faila= 11(D)  failb= 15(Q)  OK
[   10.582601] raid6test: test_disks(12, 13): faila= 12(D)  failb= 13(D)  OK
[   10.583726] raid6test: test_disks(12, 14): faila= 12(D)  failb= 14(P)  OK
[   10.584840] raid6test: test_disks(12, 15): faila= 12(D)  failb= 15(Q)  OK
[   10.585976] raid6test: test_disks(13, 14): faila= 13(D)  failb= 14(P)  OK
[   10.587111] raid6test: test_disks(13, 15): faila= 13(D)  failb= 15(Q)  OK
[   10.588260] raid6test: test_disks(14, 15): faila= 14(P)  failb= 15(Q)  OK
[   10.589525] raid6test: 
[   10.589979] raid6test: complete (257 tests, 0 failures)
[   10.605571] hd: no drives specified - use hd=cyl,head,sectors on kernel command line
[   10.607130] bus: 'i2c': add driver wl1273-fm
[   10.607936] BIOS EDD facility v0.16 2004-Jun-25, 6 devices found
[   10.616530] debug: unmapping init [mem 0x79bbf000-0x79d8cfff]
libudev: udev_monitor_new_from_netlink_fd: error getting socket: Protocol not supported
mountall:mountall.c:3801: Assertion failed in main: udev_monitor = udev_monitor_new_from_netlink (udev, "udev")
General error mounting filesystems.
A maintenance shell will now be started.
CONTROL-D will terminate this shell and reboot the system.
wfg: rebooting
[   10.934070] Unregister pv shared memory for cpu 0
[   10.934806] Unregister pv shared memory for cpu 1
[   10.935691] sc520_wdt: Watchdog timer is now disabled...
[   10.936705] ozwpan ozwpan: shutdown
[   10.937318] serio serio1: shutdown
[   10.937928] atkbd serio0: shutdown
[   10.938782] i8042 i8042: shutdown
[   10.940584] pnp 00:07: shutdown
[   10.941155] serial 00:06: shutdown
[   10.941792] pnp 00:05: shutdown
[   10.942351] pnp 00:04: shutdown
[   10.942959] i8042 aux 00:03: shutdown
[   10.943646] i8042 kbd 00:02: shutdown
[   10.944296] pnp 00:01: shutdown
[   10.944893] pnp 00:00: shutdown
[   10.958545] pci 0000:00:0b.0: shutdown
[   10.959225] pci 0000:00:0a.0: shutdown
[   10.959851] pci 0000:00:09.0: shutdown
[   10.960514] pci 0000:00:08.0: shutdown
[   10.961124] pci 0000:00:07.0: shutdown
[   10.961824] pci 0000:00:06.0: shutdown
[   10.962463] pci 0000:00:05.0: shutdown
[   10.963030] pci 0000:00:04.0: shutdown
[   10.963691] pci 0000:00:03.0: shutdown
[   10.964350] pci 0000:00:02.0: shutdown
[   10.965031] pci 0000:00:01.3: shutdown
[   10.965733] pci 0000:00:01.1: shutdown
[   10.966426] pci 0000:00:01.0: shutdown
[   10.967080] pci 0000:00:00.0: shutdown
[   10.967917] Restarting system.
[   10.968565] reboot: machine restart
[   10.983510] ------------[ cut here ]------------
[   10.984218] WARNING: at /c/kernel-tests/src/stable/arch/x86/kernel/smp.c:123 native_smp_send_reschedule+0x46/0x50()
[   10.985880] Pid: 88, comm: kpktgend_0 Not tainted 3.6.0-rc3-00005-gb374aa1 #10
[   10.987185] Call Trace:
[   10.987506]  [<7902f42a>] warn_slowpath_common+0x5a/0x80
[   10.987506]  [<7901ee16>] ? native_smp_send_reschedule+0x46/0x50
[   10.987506]  [<7901ee16>] ? native_smp_send_reschedule+0x46/0x50
[   10.987506]  [<7902f4fd>] warn_slowpath_null+0x1d/0x20
[   10.987506]  [<7901ee16>] native_smp_send_reschedule+0x46/0x50
[   10.987506]  [<7905fdad>] trigger_load_balance+0x1bd/0x250
[   10.987506]  [<79056d14>] scheduler_tick+0xd4/0x100
[   10.987506]  [<7903bde5>] update_process_times+0x55/0x70
[   10.987506]  [<79071187>] tick_sched_timer+0x57/0xb0
[   10.987506]  [<793accee>] ? do_raw_spin_unlock+0x4e/0x90
[   10.987506]  [<7904e0b7>] __run_hrtimer.isra.29+0x57/0x100
[   10.987506]  [<79071130>] ? tick_nohz_handler+0xe0/0xe0
[   10.987506]  [<7904ed45>] hrtimer_interrupt+0xe5/0x280
[   10.987506]  [<7905a5a7>] ? sched_clock_cpu+0xc7/0x150
[   10.987506]  [<7901f9a4>] smp_apic_timer_interrupt+0x54/0x90
[   10.987506]  [<79882631>] apic_timer_interrupt+0x31/0x40
[   10.987506]  [<7905007b>] ? call_srcu+0x2b/0x70
[   10.987506]  [<793a00e0>] ? __bitmap_intersects+0x10/0x80
[   10.987506]  [<7988194f>] ? _raw_spin_unlock_irq+0x1f/0x40
[   10.987506]  [<7905307f>] finish_task_switch+0x7f/0xd0
[   10.987506]  [<79053038>] ? finish_task_switch+0x38/0xd0
[   10.987506]  [<7988044a>] __schedule+0x38a/0x770
[   10.987506]  [<7905a5a7>] ? sched_clock_cpu+0xc7/0x150
[   10.987506]  [<7987ea40>] ? schedule_timeout+0x100/0x1b0
[   10.987506]  [<793accee>] ? do_raw_spin_unlock+0x4e/0x90
[   10.987506]  [<7988084e>] schedule+0x1e/0x50
[   10.987506]  [<7987ea45>] schedule_timeout+0x105/0x1b0
[   10.987506]  [<7903adb0>] ? __internal_add_timer+0xb0/0xb0
[   10.987506]  [<796842f2>] pktgen_thread_worker+0x1342/0x1390
[   10.987506]  [<7988044a>] ? __schedule+0x38a/0x770
[   10.987506]  [<793accee>] ? do_raw_spin_unlock+0x4e/0x90
[   10.987506]  [<793accee>] ? do_raw_spin_unlock+0x4e/0x90
[   10.987506]  [<7904aa40>] ? abort_exclusive_wait+0x80/0x80
[   10.987506]  [<7904aa40>] ? abort_exclusive_wait+0x80/0x80
[   10.987506]  [<79682fb0>] ? pktgen_if_write+0x2210/0x2210
[   10.987506]  [<79049ff8>] kthread+0x78/0x80
[   10.987506]  [<79880000>] ? __up.isra.0+0xd/0x2d
[   10.987506]  [<79049f80>] ? insert_kthread_work+0x70/0x70
[   10.987506]  [<798830c6>] kernel_thread_helper+0x6/0xd
[   10.987506] ---[ end trace af2361d7125f0412 ]---

--bp/iNruPH9dso1Pn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.6.0-rc3-00005-gb374aa1"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.6.0-rc3 Kernel Configuration
#
# CONFIG_64BIT is not set
CONFIG_X86_32=y
# CONFIG_X86_64 is not set
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf32-i386"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/i386_defconfig"
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_MMU=y
# CONFIG_NEED_DMA_MAP_STATE is not set
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_GENERIC_GPIO=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
# CONFIG_RWSEM_GENERIC_SPINLOCK is not set
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_DEFAULT_IDLE=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_ARCH_HAS_CPU_AUTOPROBE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
# CONFIG_ZONE_DMA32 is not set
# CONFIG_AUDIT_ARCH is not set
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_X86_32_SMP=y
CONFIG_X86_HT=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-ecx -fcall-saved-edx"
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_HAVE_IRQ_WORK=y
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
# CONFIG_KERNEL_GZIP is not set
CONFIG_KERNEL_BZIP2=y
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
# CONFIG_SWAP is not set
# CONFIG_SYSVIPC is not set
# CONFIG_POSIX_MQUEUE is not set
# CONFIG_BSD_PROCESS_ACCT is not set
CONFIG_FHANDLE=y
CONFIG_TASKSTATS=y
# CONFIG_TASK_DELAY_ACCT is not set
# CONFIG_TASK_XACCT is not set
# CONFIG_AUDIT is not set
CONFIG_HAVE_GENERIC_HARDIRQS=y

#
# IRQ subsystem
#
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_IRQ_DOMAIN=y
# CONFIG_IRQ_DOMAIN_DEBUG is not set
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_KTIME_SCALAR=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_GENERIC_CMOS_UPDATE=y

#
# Timers subsystem
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_FANOUT=32
CONFIG_RCU_FANOUT_LEAF=16
CONFIG_RCU_FANOUT_EXACT=y
CONFIG_RCU_FAST_NO_HZ=y
CONFIG_TREE_RCU_TRACE=y
CONFIG_IKCONFIG=y
# CONFIG_IKCONFIG_PROC is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_CGROUPS=y
CONFIG_CGROUP_DEBUG=y
# CONFIG_CGROUP_FREEZER is not set
CONFIG_CGROUP_DEVICE=y
# CONFIG_CPUSETS is not set
# CONFIG_CGROUP_CPUACCT is not set
CONFIG_RESOURCE_COUNTERS=y
# CONFIG_MEMCG is not set
# CONFIG_CGROUP_HUGETLB is not set
# CONFIG_CGROUP_PERF is not set
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_CFS_BANDWIDTH=y
CONFIG_RT_GROUP_SCHED=y
CONFIG_BLK_CGROUP=y
CONFIG_DEBUG_BLK_CGROUP=y
# CONFIG_CHECKPOINT_RESTORE is not set
# CONFIG_NAMESPACES is not set
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
CONFIG_UID16=y
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
# CONFIG_HOTPLUG is not set
CONFIG_PRINTK=y
CONFIG_BUG=y
# CONFIG_ELF_CORE is not set
# CONFIG_PCSPKR_PLATFORM is not set
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
# CONFIG_TIMERFD is not set
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
# CONFIG_AIO is not set
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y
CONFIG_PERF_USE_VMALLOC=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
CONFIG_DEBUG_PERF_USE_VMALLOC=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
CONFIG_SLUB_DEBUG=y
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
# CONFIG_PROFILING is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
# CONFIG_JUMP_LABEL is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_HAVE_DMA_CONTIGUOUS=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
CONFIG_GENERIC_SMP_IDLE_THREAD=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_ARCH_WANT_IPC_PARSE_VERSION=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_SECCOMP_FILTER=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
# CONFIG_MODULES is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_LBDAF=y
# CONFIG_BLK_DEV_BSG is not set
# CONFIG_BLK_DEV_BSGLIB is not set
# CONFIG_BLK_DEV_INTEGRITY is not set
# CONFIG_BLK_DEV_THROTTLING is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
CONFIG_ACORN_PARTITION=y
CONFIG_ACORN_PARTITION_CUMANA=y
# CONFIG_ACORN_PARTITION_EESOX is not set
CONFIG_ACORN_PARTITION_ICS=y
CONFIG_ACORN_PARTITION_ADFS=y
# CONFIG_ACORN_PARTITION_POWERTEC is not set
# CONFIG_ACORN_PARTITION_RISCIX is not set
# CONFIG_OSF_PARTITION is not set
# CONFIG_AMIGA_PARTITION is not set
# CONFIG_ATARI_PARTITION is not set
# CONFIG_MAC_PARTITION is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
# CONFIG_MINIX_SUBPARTITION is not set
# CONFIG_SOLARIS_X86_PARTITION is not set
# CONFIG_UNIXWARE_DISKLABEL is not set
# CONFIG_LDM_PARTITION is not set
# CONFIG_SGI_PARTITION is not set
# CONFIG_ULTRIX_PARTITION is not set
CONFIG_SUN_PARTITION=y
CONFIG_KARMA_PARTITION=y
# CONFIG_EFI_PARTITION is not set
CONFIG_SYSV68_PARTITION=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=y
# CONFIG_IOSCHED_CFQ is not set
CONFIG_DEFAULT_DEADLINE=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="deadline"
CONFIG_PADATA=y
# CONFIG_INLINE_SPIN_TRYLOCK is not set
# CONFIG_INLINE_SPIN_TRYLOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK is not set
# CONFIG_INLINE_SPIN_LOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK_IRQ is not set
# CONFIG_INLINE_SPIN_LOCK_IRQSAVE is not set
CONFIG_UNINLINE_SPIN_UNLOCK=y
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
# CONFIG_FREEZER is not set

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
CONFIG_SMP=y
CONFIG_X86_MPPARSE=y
# CONFIG_X86_BIGSMP is not set
# CONFIG_X86_EXTENDED_PLATFORM is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
CONFIG_X86_32_IRIS=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_PARAVIRT_GUEST=y
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
# CONFIG_XEN_PRIVILEGED_GUEST is not set
CONFIG_KVM_CLOCK=y
CONFIG_KVM_GUEST=y
CONFIG_LGUEST_GUEST=y
CONFIG_PARAVIRT=y
CONFIG_PARAVIRT_SPINLOCKS=y
CONFIG_PARAVIRT_CLOCK=y
# CONFIG_PARAVIRT_DEBUG is not set
CONFIG_NO_BOOTMEM=y
# CONFIG_MEMTEST is not set
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
CONFIG_MWINCHIPC6=y
# CONFIG_MWINCHIP3D is not set
# CONFIG_MELAN is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
CONFIG_X86_GENERIC=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_XADD=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INVLPG=y
CONFIG_X86_BSWAP=y
CONFIG_X86_POPAD_OK=y
CONFIG_X86_ALIGNMENT_16=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_OOSTORE=y
CONFIG_X86_MINIMUM_CPU_FAMILY=4
# CONFIG_PROCESSOR_SELECT is not set
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_CYRIX_32=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_TRANSMETA_32=y
CONFIG_CPU_SUP_UMC_32=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
# CONFIG_DMI is not set
# CONFIG_IOMMU_HELPER is not set
CONFIG_NR_CPUS=8
# CONFIG_SCHED_SMT is not set
CONFIG_SCHED_MC=y
CONFIG_IRQ_TIME_ACCOUNTING=y
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
CONFIG_X86_MCE=y
# CONFIG_X86_MCE_INTEL is not set
# CONFIG_X86_MCE_AMD is not set
CONFIG_X86_ANCIENT_MCE=y
# CONFIG_X86_MCE_INJECT is not set
CONFIG_VM86=y
# CONFIG_TOSHIBA is not set
# CONFIG_I8K is not set
CONFIG_X86_REBOOTFIXUPS=y
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
# CONFIG_HIGHMEM64G is not set
# CONFIG_VMSPLIT_3G is not set
# CONFIG_VMSPLIT_3G_OPT is not set
# CONFIG_VMSPLIT_2G is not set
CONFIG_VMSPLIT_2G_OPT=y
# CONFIG_VMSPLIT_1G is not set
CONFIG_PAGE_OFFSET=0x78000000
CONFIG_HIGHMEM=y
# CONFIG_ARCH_PHYS_ADDR_T_64BIT is not set
# CONFIG_ARCH_DMA_ADDR_T_64BIT is not set
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
CONFIG_MEMORY_ISOLATION=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=999999
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_MEMORY_FAILURE is not set
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
# CONFIG_CROSS_MEMORY_ATTACH is not set
# CONFIG_CLEANCACHE is not set
CONFIG_HIGHPTE=y
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
# CONFIG_MATH_EMULATION is not set
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
# CONFIG_X86_PAT is not set
# CONFIG_ARCH_RANDOM is not set
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
CONFIG_CC_STACKPROTECTOR=y
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
CONFIG_SCHED_HRTICK=y
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_X86_NEED_RELOCS=y
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_COMPAT_VDSO=y
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
# CONFIG_SUSPEND is not set
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
CONFIG_PM_DEBUG=y
# CONFIG_PM_ADVANCED_DEBUG is not set
CONFIG_ACPI=y
# CONFIG_ACPI_PROCFS is not set
# CONFIG_ACPI_PROCFS_POWER is not set
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
# CONFIG_ACPI_CONTAINER is not set
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_BGRT is not set
# CONFIG_ACPI_APEI is not set
# CONFIG_SFI is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
# CONFIG_CPU_FREQ_STAT is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_GOV_POWERSAVE is not set
CONFIG_CPU_FREQ_GOV_USERSPACE=y
# CONFIG_CPU_FREQ_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_GOV_CONSERVATIVE is not set

#
# x86 CPU frequency scaling drivers
#
# CONFIG_X86_PCC_CPUFREQ is not set
# CONFIG_X86_ACPI_CPUFREQ is not set
CONFIG_X86_POWERNOW_K6=y
CONFIG_X86_POWERNOW_K7=y
CONFIG_X86_POWERNOW_K7_ACPI=y
# CONFIG_X86_POWERNOW_K8 is not set
# CONFIG_X86_GX_SUSPMOD is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
# CONFIG_X86_SPEEDSTEP_ICH is not set
# CONFIG_X86_SPEEDSTEP_SMI is not set
CONFIG_X86_P4_CLOCKMOD=y
# CONFIG_X86_CPUFREQ_NFORCE2 is not set
CONFIG_X86_LONGRUN=y
# CONFIG_X86_LONGHAUL is not set
# CONFIG_X86_E_POWERSAVER is not set

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=y
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
# CONFIG_INTEL_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
# CONFIG_PCIEPORTBUS is not set
CONFIG_ARCH_SUPPORTS_MSI=y
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
# CONFIG_PCI_STUB is not set
CONFIG_HT_IRQ=y
# CONFIG_PCI_IOV is not set
# CONFIG_PCI_PRI is not set
# CONFIG_PCI_PASID is not set
CONFIG_PCI_LABEL=y
CONFIG_ISA_DMA_API=y
CONFIG_ISA=y
CONFIG_EISA=y
# CONFIG_EISA_VLB_PRIMING is not set
CONFIG_EISA_PCI_EISA=y
CONFIG_EISA_VIRTUAL_ROOT=y
# CONFIG_EISA_NAMES is not set
# CONFIG_SCx200 is not set
# CONFIG_OLPC is not set
CONFIG_ALIX=y
# CONFIG_NET5501 is not set
CONFIG_AMD_NB=y
# CONFIG_RAPIDIO is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_HAVE_AOUT=y
CONFIG_BINFMT_AOUT=y
# CONFIG_BINFMT_MISC is not set
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_HAVE_TEXT_POKE_SMP=y
CONFIG_NET=y

#
# Networking options
#
# CONFIG_PACKET is not set
CONFIG_UNIX=y
CONFIG_UNIX_DIAG=y
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
CONFIG_XFRM_USER=y
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
# CONFIG_XFRM_STATISTICS is not set
CONFIG_XFRM_IPCOMP=y
# CONFIG_NET_KEY is not set
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_IP_FIB_TRIE_STATS=y
# CONFIG_IP_MULTIPLE_TABLES is not set
# CONFIG_IP_ROUTE_MULTIPATH is not set
CONFIG_IP_ROUTE_VERBOSE=y
CONFIG_IP_ROUTE_CLASSID=y
CONFIG_IP_PNP=y
# CONFIG_IP_PNP_DHCP is not set
# CONFIG_IP_PNP_BOOTP is not set
CONFIG_IP_PNP_RARP=y
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE_DEMUX is not set
# CONFIG_ARPD is not set
CONFIG_SYN_COOKIES=y
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
CONFIG_INET_IPCOMP=y
CONFIG_INET_XFRM_TUNNEL=y
CONFIG_INET_TUNNEL=y
CONFIG_INET_XFRM_MODE_TRANSPORT=y
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
CONFIG_INET_XFRM_MODE_BEET=y
CONFIG_INET_LRO=y
# CONFIG_INET_DIAG is not set
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=y
CONFIG_TCP_CONG_CUBIC=y
CONFIG_TCP_CONG_WESTWOOD=y
# CONFIG_TCP_CONG_HTCP is not set
CONFIG_TCP_CONG_HSTCP=y
# CONFIG_TCP_CONG_HYBLA is not set
CONFIG_TCP_CONG_VEGAS=y
# CONFIG_TCP_CONG_SCALABLE is not set
# CONFIG_TCP_CONG_LP is not set
CONFIG_TCP_CONG_VENO=y
CONFIG_TCP_CONG_YEAH=y
CONFIG_TCP_CONG_ILLINOIS=y
# CONFIG_DEFAULT_BIC is not set
CONFIG_DEFAULT_CUBIC=y
# CONFIG_DEFAULT_VEGAS is not set
# CONFIG_DEFAULT_VENO is not set
# CONFIG_DEFAULT_WESTWOOD is not set
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_TCP_MD5SIG=y
CONFIG_IPV6=y
# CONFIG_IPV6_PRIVACY is not set
# CONFIG_IPV6_ROUTER_PREF is not set
# CONFIG_IPV6_OPTIMISTIC_DAD is not set
CONFIG_INET6_AH=y
# CONFIG_INET6_ESP is not set
# CONFIG_INET6_IPCOMP is not set
CONFIG_IPV6_MIP6=y
# CONFIG_INET6_XFRM_TUNNEL is not set
# CONFIG_INET6_TUNNEL is not set
CONFIG_INET6_XFRM_MODE_TRANSPORT=y
# CONFIG_INET6_XFRM_MODE_TUNNEL is not set
# CONFIG_INET6_XFRM_MODE_BEET is not set
# CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION is not set
CONFIG_IPV6_SIT=y
CONFIG_IPV6_SIT_6RD=y
CONFIG_IPV6_NDISC_NODETYPE=y
# CONFIG_IPV6_TUNNEL is not set
# CONFIG_IPV6_MULTIPLE_TABLES is not set
CONFIG_IPV6_MROUTE=y
# CONFIG_IPV6_MROUTE_MULTIPLE_TABLES is not set
CONFIG_IPV6_PIMSM_V2=y
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_NETFILTER_ADVANCED=y

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=y
CONFIG_NETFILTER_NETLINK_ACCT=y
CONFIG_NETFILTER_NETLINK_QUEUE=y
# CONFIG_NETFILTER_NETLINK_LOG is not set
CONFIG_NF_CONNTRACK=y
CONFIG_NF_CONNTRACK_MARK=y
CONFIG_NF_CONNTRACK_ZONES=y
CONFIG_NF_CONNTRACK_PROCFS=y
# CONFIG_NF_CONNTRACK_EVENTS is not set
CONFIG_NF_CONNTRACK_TIMEOUT=y
# CONFIG_NF_CONNTRACK_TIMESTAMP is not set
CONFIG_NF_CT_PROTO_DCCP=y
CONFIG_NF_CT_PROTO_GRE=y
CONFIG_NF_CT_PROTO_SCTP=y
# CONFIG_NF_CT_PROTO_UDPLITE is not set
CONFIG_NF_CONNTRACK_AMANDA=y
# CONFIG_NF_CONNTRACK_FTP is not set
# CONFIG_NF_CONNTRACK_H323 is not set
CONFIG_NF_CONNTRACK_IRC=y
# CONFIG_NF_CONNTRACK_NETBIOS_NS is not set
# CONFIG_NF_CONNTRACK_SNMP is not set
CONFIG_NF_CONNTRACK_PPTP=y
CONFIG_NF_CONNTRACK_SANE=y
CONFIG_NF_CONNTRACK_SIP=y
CONFIG_NF_CONNTRACK_TFTP=y
CONFIG_NF_CT_NETLINK=y
# CONFIG_NF_CT_NETLINK_TIMEOUT is not set
# CONFIG_NETFILTER_NETLINK_QUEUE_CT is not set
CONFIG_NETFILTER_XTABLES=y

#
# Xtables combined modules
#
CONFIG_NETFILTER_XT_MARK=y
CONFIG_NETFILTER_XT_CONNMARK=y

#
# Xtables targets
#
# CONFIG_NETFILTER_XT_TARGET_CHECKSUM is not set
# CONFIG_NETFILTER_XT_TARGET_CLASSIFY is not set
# CONFIG_NETFILTER_XT_TARGET_CONNMARK is not set
CONFIG_NETFILTER_XT_TARGET_CT=y
# CONFIG_NETFILTER_XT_TARGET_DSCP is not set
# CONFIG_NETFILTER_XT_TARGET_HL is not set
# CONFIG_NETFILTER_XT_TARGET_HMARK is not set
# CONFIG_NETFILTER_XT_TARGET_IDLETIMER is not set
CONFIG_NETFILTER_XT_TARGET_LOG=y
CONFIG_NETFILTER_XT_TARGET_MARK=y
# CONFIG_NETFILTER_XT_TARGET_NFLOG is not set
# CONFIG_NETFILTER_XT_TARGET_NFQUEUE is not set
# CONFIG_NETFILTER_XT_TARGET_NOTRACK is not set
# CONFIG_NETFILTER_XT_TARGET_RATEEST is not set
# CONFIG_NETFILTER_XT_TARGET_TEE is not set
# CONFIG_NETFILTER_XT_TARGET_TRACE is not set
CONFIG_NETFILTER_XT_TARGET_TCPMSS=y
# CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP is not set

#
# Xtables matches
#
# CONFIG_NETFILTER_XT_MATCH_ADDRTYPE is not set
CONFIG_NETFILTER_XT_MATCH_CLUSTER=y
CONFIG_NETFILTER_XT_MATCH_COMMENT=y
CONFIG_NETFILTER_XT_MATCH_CONNBYTES=y
CONFIG_NETFILTER_XT_MATCH_CONNLIMIT=y
# CONFIG_NETFILTER_XT_MATCH_CONNMARK is not set
# CONFIG_NETFILTER_XT_MATCH_CONNTRACK is not set
CONFIG_NETFILTER_XT_MATCH_CPU=y
CONFIG_NETFILTER_XT_MATCH_DCCP=y
CONFIG_NETFILTER_XT_MATCH_DEVGROUP=y
CONFIG_NETFILTER_XT_MATCH_DSCP=y
CONFIG_NETFILTER_XT_MATCH_ECN=y
CONFIG_NETFILTER_XT_MATCH_ESP=y
# CONFIG_NETFILTER_XT_MATCH_HASHLIMIT is not set
# CONFIG_NETFILTER_XT_MATCH_HELPER is not set
CONFIG_NETFILTER_XT_MATCH_HL=y
# CONFIG_NETFILTER_XT_MATCH_IPRANGE is not set
# CONFIG_NETFILTER_XT_MATCH_IPVS is not set
# CONFIG_NETFILTER_XT_MATCH_LENGTH is not set
# CONFIG_NETFILTER_XT_MATCH_LIMIT is not set
CONFIG_NETFILTER_XT_MATCH_MAC=y
# CONFIG_NETFILTER_XT_MATCH_MARK is not set
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=y
CONFIG_NETFILTER_XT_MATCH_NFACCT=y
CONFIG_NETFILTER_XT_MATCH_OSF=y
CONFIG_NETFILTER_XT_MATCH_OWNER=y
# CONFIG_NETFILTER_XT_MATCH_POLICY is not set
# CONFIG_NETFILTER_XT_MATCH_PKTTYPE is not set
# CONFIG_NETFILTER_XT_MATCH_QUOTA is not set
# CONFIG_NETFILTER_XT_MATCH_RATEEST is not set
CONFIG_NETFILTER_XT_MATCH_REALM=y
CONFIG_NETFILTER_XT_MATCH_RECENT=y
# CONFIG_NETFILTER_XT_MATCH_SCTP is not set
CONFIG_NETFILTER_XT_MATCH_STATE=y
CONFIG_NETFILTER_XT_MATCH_STATISTIC=y
CONFIG_NETFILTER_XT_MATCH_STRING=y
CONFIG_NETFILTER_XT_MATCH_TCPMSS=y
CONFIG_NETFILTER_XT_MATCH_TIME=y
CONFIG_NETFILTER_XT_MATCH_U32=y
# CONFIG_IP_SET is not set
CONFIG_IP_VS=y
# CONFIG_IP_VS_IPV6 is not set
CONFIG_IP_VS_DEBUG=y
CONFIG_IP_VS_TAB_BITS=12

#
# IPVS transport protocol load balancing support
#
CONFIG_IP_VS_PROTO_TCP=y
CONFIG_IP_VS_PROTO_UDP=y
# CONFIG_IP_VS_PROTO_AH_ESP is not set
# CONFIG_IP_VS_PROTO_ESP is not set
# CONFIG_IP_VS_PROTO_AH is not set
CONFIG_IP_VS_PROTO_SCTP=y

#
# IPVS scheduler
#
# CONFIG_IP_VS_RR is not set
# CONFIG_IP_VS_WRR is not set
# CONFIG_IP_VS_LC is not set
# CONFIG_IP_VS_WLC is not set
CONFIG_IP_VS_LBLC=y
# CONFIG_IP_VS_LBLCR is not set
# CONFIG_IP_VS_DH is not set
CONFIG_IP_VS_SH=y
# CONFIG_IP_VS_SED is not set
CONFIG_IP_VS_NQ=y

#
# IPVS SH scheduler
#
CONFIG_IP_VS_SH_TAB_BITS=8

#
# IPVS application helper
#
CONFIG_IP_VS_NFCT=y
# CONFIG_IP_VS_PE_SIP is not set

#
# IP: Netfilter Configuration
#
# CONFIG_NF_DEFRAG_IPV4 is not set
# CONFIG_NF_CONNTRACK_IPV4 is not set
# CONFIG_IP_NF_QUEUE is not set
CONFIG_IP_NF_IPTABLES=y
# CONFIG_IP_NF_MATCH_AH is not set
CONFIG_IP_NF_MATCH_ECN=y
# CONFIG_IP_NF_MATCH_RPFILTER is not set
# CONFIG_IP_NF_MATCH_TTL is not set
# CONFIG_IP_NF_FILTER is not set
# CONFIG_IP_NF_TARGET_ULOG is not set
# CONFIG_IP_NF_MANGLE is not set
# CONFIG_IP_NF_RAW is not set
# CONFIG_IP_NF_ARPTABLES is not set

#
# IPv6: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV6=y
CONFIG_NF_CONNTRACK_IPV6=y
CONFIG_IP6_NF_IPTABLES=y
CONFIG_IP6_NF_MATCH_AH=y
# CONFIG_IP6_NF_MATCH_EUI64 is not set
CONFIG_IP6_NF_MATCH_FRAG=y
CONFIG_IP6_NF_MATCH_OPTS=y
# CONFIG_IP6_NF_MATCH_HL is not set
CONFIG_IP6_NF_MATCH_IPV6HEADER=y
# CONFIG_IP6_NF_MATCH_MH is not set
# CONFIG_IP6_NF_MATCH_RPFILTER is not set
# CONFIG_IP6_NF_MATCH_RT is not set
# CONFIG_IP6_NF_TARGET_HL is not set
# CONFIG_IP6_NF_FILTER is not set
CONFIG_IP6_NF_MANGLE=y
CONFIG_IP6_NF_RAW=y
CONFIG_IP_DCCP=y

#
# DCCP CCIDs Configuration (EXPERIMENTAL)
#
# CONFIG_IP_DCCP_CCID2_DEBUG is not set
# CONFIG_IP_DCCP_CCID3 is not set

#
# DCCP Kernel Hacking
#
# CONFIG_IP_DCCP_DEBUG is not set
CONFIG_IP_SCTP=y
# CONFIG_SCTP_DBG_MSG is not set
# CONFIG_SCTP_DBG_OBJCNT is not set
# CONFIG_SCTP_HMAC_NONE is not set
CONFIG_SCTP_HMAC_SHA1=y
# CONFIG_SCTP_HMAC_MD5 is not set
# CONFIG_RDS is not set
CONFIG_TIPC=y
CONFIG_TIPC_ADVANCED=y
CONFIG_TIPC_PORTS=8191
CONFIG_ATM=y
# CONFIG_ATM_CLIP is not set
CONFIG_ATM_LANE=y
# CONFIG_ATM_MPOA is not set
# CONFIG_ATM_BR2684 is not set
CONFIG_L2TP=y
CONFIG_L2TP_DEBUGFS=y
# CONFIG_L2TP_V3 is not set
# CONFIG_BRIDGE is not set
CONFIG_VLAN_8021Q=y
# CONFIG_VLAN_8021Q_GVRP is not set
# CONFIG_DECNET is not set
CONFIG_LLC=y
CONFIG_LLC2=y
# CONFIG_IPX is not set
CONFIG_ATALK=y
CONFIG_DEV_APPLETALK=y
CONFIG_LTPC=y
# CONFIG_COPS is not set
# CONFIG_IPDDP is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
CONFIG_WAN_ROUTER=y
CONFIG_PHONET=y
# CONFIG_IEEE802154 is not set
# CONFIG_NET_SCHED is not set
CONFIG_DCB=y
CONFIG_DNS_RESOLVER=y
CONFIG_BATMAN_ADV=y
# CONFIG_BATMAN_ADV_BLA is not set
CONFIG_BATMAN_ADV_DEBUG=y
CONFIG_OPENVSWITCH=y
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
# CONFIG_NETPRIO_CGROUP is not set
CONFIG_BQL=y

#
# Network testing
#
CONFIG_NET_PKTGEN=y
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
CONFIG_BT=y
# CONFIG_BT_RFCOMM is not set
# CONFIG_BT_BNEP is not set
# CONFIG_BT_HIDP is not set

#
# Bluetooth device drivers
#
CONFIG_BT_HCIBTUSB=y
CONFIG_BT_HCIUART=y
# CONFIG_BT_HCIUART_H4 is not set
# CONFIG_BT_HCIUART_BCSP is not set
CONFIG_BT_HCIUART_ATH3K=y
CONFIG_BT_HCIUART_LL=y
# CONFIG_BT_HCIUART_3WIRE is not set
# CONFIG_BT_HCIBCM203X is not set
CONFIG_BT_HCIBPA10X=y
# CONFIG_BT_HCIBFUSB is not set
CONFIG_BT_HCIVHCI=y
# CONFIG_BT_MRVL is not set
# CONFIG_BT_ATH3K is not set
CONFIG_BT_WILINK=y
CONFIG_AF_RXRPC=y
CONFIG_AF_RXRPC_DEBUG=y
# CONFIG_RXKAD is not set
CONFIG_WIRELESS=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_PROC=y
CONFIG_CFG80211=y
CONFIG_NL80211_TESTMODE=y
CONFIG_CFG80211_DEVELOPER_WARNINGS=y
# CONFIG_CFG80211_REG_DEBUG is not set
# CONFIG_CFG80211_CERTIFICATION_ONUS is not set
CONFIG_CFG80211_DEFAULT_PS=y
CONFIG_CFG80211_DEBUGFS=y
# CONFIG_CFG80211_INTERNAL_REGDB is not set
CONFIG_CFG80211_WEXT=y
# CONFIG_LIB80211 is not set
CONFIG_MAC80211=y
CONFIG_MAC80211_HAS_RC=y
CONFIG_MAC80211_RC_PID=y
CONFIG_MAC80211_RC_MINSTREL=y
CONFIG_MAC80211_RC_MINSTREL_HT=y
# CONFIG_MAC80211_RC_DEFAULT_PID is not set
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT="minstrel_ht"
CONFIG_MAC80211_MESH=y
# CONFIG_MAC80211_DEBUGFS is not set
# CONFIG_MAC80211_MESSAGE_TRACING is not set
# CONFIG_MAC80211_DEBUG_MENU is not set
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
# CONFIG_RFKILL_REGULATOR is not set
CONFIG_NET_9P=y
CONFIG_NET_9P_VIRTIO=y
CONFIG_NET_9P_DEBUG=y
# CONFIG_CAIF is not set
CONFIG_CEPH_LIB=y
CONFIG_CEPH_LIB_PRETTYDEBUG=y
# CONFIG_CEPH_LIB_USE_DNS_RESOLVER is not set
# CONFIG_NFC is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
# CONFIG_STANDALONE is not set
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
CONFIG_DEBUG_DRIVER=y
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y
CONFIG_CMA=y
CONFIG_CMA_DEBUG=y

#
# Default contiguous memory area size:
#
CONFIG_CMA_SIZE_MBYTES=16
CONFIG_CMA_SIZE_PERCENTAGE=10
# CONFIG_CMA_SIZE_SEL_MBYTES is not set
# CONFIG_CMA_SIZE_SEL_PERCENTAGE is not set
# CONFIG_CMA_SIZE_SEL_MIN is not set
CONFIG_CMA_SIZE_SEL_MAX=y
CONFIG_CMA_ALIGNMENT=8
CONFIG_CMA_AREAS=7
CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
CONFIG_MTD=y
CONFIG_MTD_REDBOOT_PARTS=y
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
# CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED is not set
CONFIG_MTD_REDBOOT_PARTS_READONLY=y
CONFIG_MTD_CMDLINE_PARTS=y
CONFIG_MTD_AR7_PARTS=y

#
# User Modules And Translation Layers
#
# CONFIG_MTD_CHAR is not set
CONFIG_HAVE_MTD_OTP=y
CONFIG_MTD_BLKDEVS=y
CONFIG_MTD_BLOCK=y
CONFIG_FTL=y
CONFIG_NFTL=y
# CONFIG_NFTL_RW is not set
CONFIG_INFTL=y
# CONFIG_RFD_FTL is not set
CONFIG_SSFDC=y
# CONFIG_SM_FTL is not set
CONFIG_MTD_OOPS=y

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=y
# CONFIG_MTD_JEDECPROBE is not set
CONFIG_MTD_GEN_PROBE=y
CONFIG_MTD_CFI_ADV_OPTIONS=y
# CONFIG_MTD_CFI_NOSWAP is not set
# CONFIG_MTD_CFI_BE_BYTE_SWAP is not set
CONFIG_MTD_CFI_LE_BYTE_SWAP=y
# CONFIG_MTD_CFI_GEOMETRY is not set
CONFIG_MTD_MAP_BANK_WIDTH_1=y
CONFIG_MTD_MAP_BANK_WIDTH_2=y
CONFIG_MTD_MAP_BANK_WIDTH_4=y
# CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
CONFIG_MTD_CFI_I1=y
CONFIG_MTD_CFI_I2=y
# CONFIG_MTD_CFI_I4 is not set
# CONFIG_MTD_CFI_I8 is not set
CONFIG_MTD_OTP=y
CONFIG_MTD_CFI_INTELEXT=y
CONFIG_MTD_CFI_AMDSTD=y
# CONFIG_MTD_CFI_STAA is not set
CONFIG_MTD_CFI_UTIL=y
# CONFIG_MTD_RAM is not set
CONFIG_MTD_ROM=y
CONFIG_MTD_ABSENT=y

#
# Mapping drivers for chip access
#
CONFIG_MTD_COMPLEX_MAPPINGS=y
CONFIG_MTD_PHYSMAP=y
# CONFIG_MTD_PHYSMAP_COMPAT is not set
CONFIG_MTD_SC520CDP=y
CONFIG_MTD_NETSC520=y
# CONFIG_MTD_TS5500 is not set
# CONFIG_MTD_SBC_GXX is not set
# CONFIG_MTD_PCI is not set
CONFIG_MTD_GPIO_ADDR=y
# CONFIG_MTD_INTEL_VR_NOR is not set
# CONFIG_MTD_PLATRAM is not set
# CONFIG_MTD_LATCH_ADDR is not set

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
# CONFIG_MTD_SLRAM is not set
CONFIG_MTD_PHRAM=y
CONFIG_MTD_MTDRAM=y
CONFIG_MTDRAM_TOTAL_SIZE=4096
CONFIG_MTDRAM_ERASE_SIZE=128
CONFIG_MTDRAM_ABS_POS=0
CONFIG_MTD_BLOCK2MTD=y

#
# Disk-On-Chip Device Drivers
#
CONFIG_MTD_DOC2000=y
CONFIG_MTD_DOC2001=y
CONFIG_MTD_DOC2001PLUS=y
CONFIG_MTD_DOCG3=y
CONFIG_BCH_CONST_M=14
CONFIG_BCH_CONST_T=4
CONFIG_MTD_DOCPROBE=y
CONFIG_MTD_DOCECC=y
CONFIG_MTD_DOCPROBE_ADVANCED=y
CONFIG_MTD_DOCPROBE_ADDRESS=0x0
# CONFIG_MTD_DOCPROBE_HIGH is not set
CONFIG_MTD_DOCPROBE_55AA=y
CONFIG_MTD_NAND_ECC=y
CONFIG_MTD_NAND_ECC_SMC=y
CONFIG_MTD_NAND=y
# CONFIG_MTD_NAND_VERIFY_WRITE is not set
CONFIG_MTD_NAND_BCH=y
CONFIG_MTD_NAND_ECC_BCH=y
# CONFIG_MTD_SM_COMMON is not set
# CONFIG_MTD_NAND_MUSEUM_IDS is not set
# CONFIG_MTD_NAND_DENALI is not set
CONFIG_MTD_NAND_IDS=y
# CONFIG_MTD_NAND_RICOH is not set
# CONFIG_MTD_NAND_DISKONCHIP is not set
CONFIG_MTD_NAND_DOCG4=y
# CONFIG_MTD_NAND_CAFE is not set
CONFIG_MTD_NAND_CS553X=y
CONFIG_MTD_NAND_NANDSIM=y
# CONFIG_MTD_NAND_PLATFORM is not set
CONFIG_MTD_ALAUDA=y
# CONFIG_MTD_ONENAND is not set

#
# LPDDR flash memory drivers
#
CONFIG_MTD_LPDDR=y
CONFIG_MTD_QINFO_PROBE=y
# CONFIG_MTD_UBI is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
# CONFIG_ISAPNP is not set
# CONFIG_PNPBIOS is not set
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_DEV_XD is not set
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
CONFIG_BLK_DEV_LOOP_MIN_COUNT=8
CONFIG_BLK_DEV_CRYPTOLOOP=y
CONFIG_BLK_DEV_DRBD=y
CONFIG_DRBD_FAULT_INJECTION=y
CONFIG_BLK_DEV_NBD=y
# CONFIG_BLK_DEV_NVME is not set
# CONFIG_BLK_DEV_SX8 is not set
CONFIG_BLK_DEV_UB=y
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=4096
CONFIG_BLK_DEV_XIP=y
CONFIG_CDROM_PKTCDVD=y
CONFIG_CDROM_PKTCDVD_BUFFERS=8
CONFIG_CDROM_PKTCDVD_WCACHE=y
CONFIG_ATA_OVER_ETH=y
# CONFIG_VIRTIO_BLK is not set
CONFIG_BLK_DEV_HD=y
CONFIG_BLK_DEV_RBD=y

#
# Misc devices
#
# CONFIG_SENSORS_LIS3LV02D is not set
CONFIG_AD525X_DPOT=y
# CONFIG_AD525X_DPOT_I2C is not set
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_INTEL_MID_PTI is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
CONFIG_ICS932S401=y
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_HP_ILO is not set
# CONFIG_APDS9802ALS is not set
# CONFIG_ISL29003 is not set
CONFIG_ISL29020=y
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_SENSORS_BH1780 is not set
# CONFIG_SENSORS_BH1770 is not set
CONFIG_SENSORS_APDS990X=y
CONFIG_HMC6352=y
CONFIG_DS1682=y
# CONFIG_VMWARE_BALLOON is not set
# CONFIG_BMP085_I2C is not set
# CONFIG_PCH_PHUB is not set
# CONFIG_USB_SWITCH_FSA9480 is not set
CONFIG_C2PORT=y
# CONFIG_C2PORT_DURAMAR_2150 is not set

#
# EEPROM support
#
CONFIG_EEPROM_AT24=y
CONFIG_EEPROM_LEGACY=y
CONFIG_EEPROM_MAX6875=y
CONFIG_EEPROM_93CX6=y
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
CONFIG_TI_ST=y
# CONFIG_SENSORS_LIS3_I2C is not set

#
# Altera FPGA firmware download module
#
# CONFIG_ALTERA_STAPL is not set
# CONFIG_INTEL_MEI is not set
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
# CONFIG_SCSI_NETLINK is not set
# CONFIG_SCSI_PROC_FS is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
CONFIG_CHR_DEV_ST=y
CONFIG_CHR_DEV_OSST=y
CONFIG_BLK_DEV_SR=y
# CONFIG_BLK_DEV_SR_VENDOR is not set
CONFIG_CHR_DEV_SG=y
CONFIG_CHR_DEV_SCH=y
# CONFIG_SCSI_MULTI_LUN is not set
# CONFIG_SCSI_CONSTANTS is not set
# CONFIG_SCSI_LOGGING is not set
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
# CONFIG_SCSI_SPI_ATTRS is not set
# CONFIG_SCSI_FC_ATTRS is not set
# CONFIG_SCSI_ISCSI_ATTRS is not set
# CONFIG_SCSI_SAS_ATTRS is not set
# CONFIG_SCSI_SAS_LIBSAS is not set
CONFIG_SCSI_SRP_ATTRS=y
# CONFIG_SCSI_LOWLEVEL is not set
CONFIG_SCSI_DH=y
# CONFIG_SCSI_DH_RDAC is not set
CONFIG_SCSI_DH_HP_SW=y
CONFIG_SCSI_DH_EMC=y
CONFIG_SCSI_DH_ALUA=y
# CONFIG_SCSI_OSD_INITIATOR is not set
# CONFIG_ATA is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
CONFIG_MD_AUTODETECT=y
CONFIG_MD_LINEAR=y
CONFIG_MD_RAID0=y
CONFIG_MD_RAID1=y
CONFIG_MD_RAID10=y
CONFIG_MD_RAID456=y
CONFIG_MULTICORE_RAID456=y
# CONFIG_MD_MULTIPATH is not set
# CONFIG_MD_FAULTY is not set
CONFIG_BLK_DEV_DM=y
CONFIG_DM_DEBUG=y
# CONFIG_DM_CRYPT is not set
CONFIG_DM_SNAPSHOT=y
# CONFIG_DM_THIN_PROVISIONING is not set
CONFIG_DM_MIRROR=y
CONFIG_DM_RAID=y
CONFIG_DM_LOG_USERSPACE=y
CONFIG_DM_ZERO=y
# CONFIG_DM_MULTIPATH is not set
# CONFIG_DM_DELAY is not set
CONFIG_DM_UEVENT=y
# CONFIG_DM_FLAKEY is not set
# CONFIG_DM_VERITY is not set
CONFIG_TARGET_CORE=y
# CONFIG_TCM_IBLOCK is not set
# CONFIG_TCM_FILEIO is not set
CONFIG_TCM_PSCSI=y
CONFIG_LOOPBACK_TARGET=y
# CONFIG_ISCSI_TARGET is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
CONFIG_MACINTOSH_DRIVERS=y
# CONFIG_MAC_EMUMOUSEBTN is not set
# CONFIG_NETDEVICES is not set
CONFIG_ISDN=y
# CONFIG_ISDN_I4L is not set
# CONFIG_ISDN_CAPI is not set
CONFIG_ISDN_DRV_GIGASET=y
CONFIG_GIGASET_DUMMYLL=y
CONFIG_GIGASET_BASE=y
# CONFIG_GIGASET_M105 is not set
CONFIG_GIGASET_M101=y
# CONFIG_GIGASET_DEBUG is not set
CONFIG_MISDN=y
CONFIG_MISDN_DSP=y
# CONFIG_MISDN_L1OIP is not set

#
# mISDN hardware drivers
#
# CONFIG_MISDN_HFCPCI is not set
# CONFIG_MISDN_HFCMULTI is not set
# CONFIG_MISDN_HFCUSB is not set
# CONFIG_MISDN_AVMFRITZ is not set
# CONFIG_MISDN_SPEEDFAX is not set
# CONFIG_MISDN_INFINEON is not set
# CONFIG_MISDN_W6692 is not set
# CONFIG_MISDN_NETJET is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
CONFIG_INPUT_POLLDEV=y
CONFIG_INPUT_SPARSEKMAP=y
CONFIG_INPUT_MATRIXKMAP=y

#
# Userland interfaces
#
# CONFIG_INPUT_MOUSEDEV is not set
# CONFIG_INPUT_JOYDEV is not set
# CONFIG_INPUT_EVDEV is not set
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ADP5588=y
CONFIG_KEYBOARD_ADP5589=y
CONFIG_KEYBOARD_ATKBD=y
CONFIG_KEYBOARD_QT1070=y
# CONFIG_KEYBOARD_QT2160 is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_GPIO is not set
# CONFIG_KEYBOARD_GPIO_POLLED is not set
CONFIG_KEYBOARD_TCA6416=y
CONFIG_KEYBOARD_TCA8418=y
# CONFIG_KEYBOARD_MATRIX is not set
# CONFIG_KEYBOARD_LM8333 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
CONFIG_KEYBOARD_MPR121=y
CONFIG_KEYBOARD_NEWTON=y
CONFIG_KEYBOARD_OPENCORES=y
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_OMAP4 is not set
CONFIG_KEYBOARD_TC3589X=y
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_INPUT_MOUSE is not set
CONFIG_INPUT_JOYSTICK=y
# CONFIG_JOYSTICK_ANALOG is not set
CONFIG_JOYSTICK_A3D=y
# CONFIG_JOYSTICK_ADI is not set
# CONFIG_JOYSTICK_COBRA is not set
# CONFIG_JOYSTICK_GF2K is not set
# CONFIG_JOYSTICK_GRIP is not set
CONFIG_JOYSTICK_GRIP_MP=y
# CONFIG_JOYSTICK_GUILLEMOT is not set
# CONFIG_JOYSTICK_INTERACT is not set
CONFIG_JOYSTICK_SIDEWINDER=y
CONFIG_JOYSTICK_TMDC=y
CONFIG_JOYSTICK_IFORCE=y
# CONFIG_JOYSTICK_IFORCE_USB is not set
CONFIG_JOYSTICK_IFORCE_232=y
CONFIG_JOYSTICK_WARRIOR=y
# CONFIG_JOYSTICK_MAGELLAN is not set
# CONFIG_JOYSTICK_SPACEORB is not set
CONFIG_JOYSTICK_SPACEBALL=y
# CONFIG_JOYSTICK_STINGER is not set
# CONFIG_JOYSTICK_TWIDJOY is not set
# CONFIG_JOYSTICK_ZHENHUA is not set
CONFIG_JOYSTICK_AS5011=y
# CONFIG_JOYSTICK_JOYDUMP is not set
# CONFIG_JOYSTICK_XPAD is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_88PM860X_ONKEY is not set
# CONFIG_INPUT_AD714X is not set
# CONFIG_INPUT_BMA150 is not set
CONFIG_INPUT_MAX8925_ONKEY=y
# CONFIG_INPUT_MMA8450 is not set
CONFIG_INPUT_MPU3050=y
# CONFIG_INPUT_GP2A is not set
# CONFIG_INPUT_GPIO_TILT_POLLED is not set
# CONFIG_INPUT_WISTRON_BTNS is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
# CONFIG_INPUT_KXTJ9 is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
CONFIG_INPUT_UINPUT=y
CONFIG_INPUT_PCF50633_PMU=y
CONFIG_INPUT_PCF8574=y
CONFIG_INPUT_GPIO_ROTARY_ENCODER=y
# CONFIG_INPUT_DA9052_ONKEY is not set
# CONFIG_INPUT_ADXL34X is not set
CONFIG_INPUT_CMA3000=y
# CONFIG_INPUT_CMA3000_I2C is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_SERIO_ALTERA_PS2 is not set
# CONFIG_SERIO_PS2MULT is not set
CONFIG_GAMEPORT=y
# CONFIG_GAMEPORT_NS558 is not set
CONFIG_GAMEPORT_L4=y
# CONFIG_GAMEPORT_EMU10K1 is not set
# CONFIG_GAMEPORT_FM801 is not set

#
# Character devices
#
# CONFIG_VT is not set
# CONFIG_UNIX98_PTYS is not set
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
CONFIG_SERIAL_NONSTANDARD=y
# CONFIG_ROCKETPORT is not set
# CONFIG_CYCLADES is not set
# CONFIG_MOXA_INTELLIO is not set
# CONFIG_MOXA_SMARTIO is not set
# CONFIG_SYNCLINK is not set
# CONFIG_SYNCLINKMP is not set
# CONFIG_SYNCLINK_GT is not set
# CONFIG_NOZOMI is not set
# CONFIG_ISI is not set
CONFIG_N_HDLC=y
CONFIG_N_GSM=y
CONFIG_TRACE_ROUTER=y
CONFIG_TRACE_SINK=y
# CONFIG_DEVKMEM is not set
CONFIG_STALDRV=y

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_SERIAL_TIMBERDALE=y
CONFIG_SERIAL_ALTERA_JTAGUART=y
# CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_PCH_UART is not set
# CONFIG_SERIAL_XILINX_PS_UART is not set
CONFIG_TTY_PRINTK=y
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=y
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=y
CONFIG_HW_RANDOM_INTEL=y
CONFIG_HW_RANDOM_AMD=y
CONFIG_HW_RANDOM_GEODE=y
CONFIG_HW_RANDOM_VIA=y
CONFIG_HW_RANDOM_VIRTIO=y
CONFIG_NVRAM=y
CONFIG_RTC=y
CONFIG_DTLK=y
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set
# CONFIG_MWAVE is not set
# CONFIG_PC8736x_GPIO is not set
# CONFIG_NSC_GPIO is not set
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=256
# CONFIG_HPET is not set
# CONFIG_HANGCHECK_TIMER is not set
CONFIG_TCG_TPM=y
# CONFIG_TCG_TIS is not set
CONFIG_TCG_NSC=y
# CONFIG_TCG_ATMEL is not set
# CONFIG_TCG_INFINEON is not set
CONFIG_TELCLOCK=y
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=y
CONFIG_I2C_MUX=y

#
# Multiplexer I2C Chip support
#
# CONFIG_I2C_MUX_GPIO is not set
# CONFIG_I2C_MUX_PCA9541 is not set
# CONFIG_I2C_MUX_PCA954x is not set
# CONFIG_I2C_HELPER_AUTO is not set
CONFIG_I2C_SMBUS=y

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=y
# CONFIG_I2C_ALGOPCF is not set
CONFIG_I2C_ALGOPCA=y

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
# CONFIG_I2C_I801 is not set
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
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EG20T is not set
CONFIG_I2C_GPIO=y
# CONFIG_I2C_INTEL_MID is not set
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=y
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_DIOLAN_U2C is not set
CONFIG_I2C_PARPORT_LIGHT=y
CONFIG_I2C_TAOS_EVM=y
CONFIG_I2C_TINY_USB=y

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_PCA_ISA is not set
# CONFIG_SCx200_ACB is not set
# CONFIG_I2C_DEBUG_CORE is not set
CONFIG_I2C_DEBUG_ALGO=y
CONFIG_I2C_DEBUG_BUS=y
# CONFIG_SPI is not set
# CONFIG_HSI is not set

#
# PPS support
#
CONFIG_PPS=y
CONFIG_PPS_DEBUG=y

#
# PPS clients support
#
# CONFIG_PPS_CLIENT_KTIMER is not set
# CONFIG_PPS_CLIENT_LDISC is not set
# CONFIG_PPS_CLIENT_GPIO is not set

#
# PPS generators support
#

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=y

#
# Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
#
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
# CONFIG_DEBUG_GPIO is not set
# CONFIG_GPIO_SYSFS is not set
CONFIG_GPIO_GENERIC=y

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_GENERIC_PLATFORM=y
# CONFIG_GPIO_IT8761E is not set
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_ICH is not set
# CONFIG_GPIO_VX855 is not set

#
# I2C GPIO expanders:
#
# CONFIG_GPIO_MAX7300 is not set
CONFIG_GPIO_MAX732X=y
# CONFIG_GPIO_MAX732X_IRQ is not set
# CONFIG_GPIO_PCA953X is not set
CONFIG_GPIO_PCF857X=y
CONFIG_GPIO_RC5T583=y
CONFIG_GPIO_SX150X=y
# CONFIG_GPIO_TC3589X is not set
# CONFIG_GPIO_WM8994 is not set
# CONFIG_GPIO_ADP5588 is not set

#
# PCI GPIO expanders:
#
# CONFIG_GPIO_BT8XX is not set
# CONFIG_GPIO_AMD8111 is not set
# CONFIG_GPIO_LANGWELL is not set
# CONFIG_GPIO_PCH is not set
# CONFIG_GPIO_ML_IOH is not set
# CONFIG_GPIO_RDC321X is not set

#
# SPI GPIO expanders:
#
# CONFIG_GPIO_MCP23S08 is not set

#
# AC97 GPIO expanders:
#

#
# MODULbus GPIO expanders:
#
CONFIG_W1=y
CONFIG_W1_CON=y

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
# CONFIG_W1_MASTER_DS2490 is not set
# CONFIG_W1_MASTER_DS2482 is not set
# CONFIG_W1_MASTER_DS1WM is not set
# CONFIG_W1_MASTER_GPIO is not set

#
# 1-wire Slaves
#
# CONFIG_W1_SLAVE_THERM is not set
# CONFIG_W1_SLAVE_SMEM is not set
CONFIG_W1_SLAVE_DS2408=y
CONFIG_W1_SLAVE_DS2423=y
CONFIG_W1_SLAVE_DS2431=y
# CONFIG_W1_SLAVE_DS2433 is not set
# CONFIG_W1_SLAVE_DS2760 is not set
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
# CONFIG_W1_SLAVE_DS28E04 is not set
CONFIG_W1_SLAVE_BQ27000=y
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
# CONFIG_PDA_POWER is not set
# CONFIG_MAX8925_POWER is not set
CONFIG_TEST_POWER=y
CONFIG_BATTERY_DS2780=y
CONFIG_BATTERY_DS2781=y
CONFIG_BATTERY_DS2782=y
# CONFIG_BATTERY_SBS is not set
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_BATTERY_MAX17042 is not set
CONFIG_CHARGER_PCF50633=y
CONFIG_CHARGER_MAX8903=y
# CONFIG_CHARGER_LP8727 is not set
# CONFIG_CHARGER_GPIO is not set
# CONFIG_CHARGER_SMB347 is not set
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
CONFIG_HWMON_DEBUG_CHIP=y

#
# Native drivers
#
CONFIG_SENSORS_AD7414=y
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADM1021 is not set
CONFIG_SENSORS_ADM1025=y
# CONFIG_SENSORS_ADM1026 is not set
CONFIG_SENSORS_ADM1029=y
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
CONFIG_SENSORS_ADT7411=y
# CONFIG_SENSORS_ADT7462 is not set
# CONFIG_SENSORS_ADT7470 is not set
CONFIG_SENSORS_ADT7475=y
CONFIG_SENSORS_ASC7621=y
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
CONFIG_SENSORS_ASB100=y
CONFIG_SENSORS_ATXP1=y
CONFIG_SENSORS_DS620=y
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_DA9052_ADC is not set
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
CONFIG_SENSORS_F75375S=y
# CONFIG_SENSORS_FSCHMD is not set
# CONFIG_SENSORS_G760A is not set
# CONFIG_SENSORS_GL518SM is not set
# CONFIG_SENSORS_GL520SM is not set
CONFIG_SENSORS_GPIO_FAN=y
# CONFIG_SENSORS_HIH6130 is not set
# CONFIG_SENSORS_CORETEMP is not set
# CONFIG_SENSORS_IT87 is not set
CONFIG_SENSORS_JC42=y
# CONFIG_SENSORS_LINEAGE is not set
CONFIG_SENSORS_LM63=y
CONFIG_SENSORS_LM73=y
CONFIG_SENSORS_LM75=y
CONFIG_SENSORS_LM77=y
CONFIG_SENSORS_LM78=y
# CONFIG_SENSORS_LM80 is not set
# CONFIG_SENSORS_LM83 is not set
CONFIG_SENSORS_LM85=y
CONFIG_SENSORS_LM87=y
# CONFIG_SENSORS_LM90 is not set
CONFIG_SENSORS_LM92=y
CONFIG_SENSORS_LM93=y
# CONFIG_SENSORS_LTC4151 is not set
# CONFIG_SENSORS_LTC4215 is not set
CONFIG_SENSORS_LTC4245=y
# CONFIG_SENSORS_LTC4261 is not set
CONFIG_SENSORS_LM95241=y
CONFIG_SENSORS_LM95245=y
# CONFIG_SENSORS_MAX16065 is not set
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_MAX1668 is not set
# CONFIG_SENSORS_MAX6639 is not set
# CONFIG_SENSORS_MAX6642 is not set
# CONFIG_SENSORS_MAX6650 is not set
CONFIG_SENSORS_MCP3021=y
CONFIG_SENSORS_NTC_THERMISTOR=y
# CONFIG_SENSORS_PC87360 is not set
CONFIG_SENSORS_PC87427=y
# CONFIG_SENSORS_PCF8591 is not set
CONFIG_PMBUS=y
CONFIG_SENSORS_PMBUS=y
CONFIG_SENSORS_ADM1275=y
CONFIG_SENSORS_LM25066=y
CONFIG_SENSORS_LTC2978=y
CONFIG_SENSORS_MAX16064=y
CONFIG_SENSORS_MAX34440=y
# CONFIG_SENSORS_MAX8688 is not set
CONFIG_SENSORS_UCD9000=y
CONFIG_SENSORS_UCD9200=y
CONFIG_SENSORS_ZL6100=y
# CONFIG_SENSORS_SHT15 is not set
CONFIG_SENSORS_SHT21=y
# CONFIG_SENSORS_SIS5595 is not set
CONFIG_SENSORS_SMM665=y
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_EMC1403 is not set
CONFIG_SENSORS_EMC2103=y
# CONFIG_SENSORS_EMC6W201 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
CONFIG_SENSORS_SMSC47M192=y
# CONFIG_SENSORS_SMSC47B397 is not set
CONFIG_SENSORS_SCH56XX_COMMON=y
CONFIG_SENSORS_SCH5627=y
CONFIG_SENSORS_SCH5636=y
CONFIG_SENSORS_ADS1015=y
CONFIG_SENSORS_ADS7828=y
CONFIG_SENSORS_AMC6821=y
# CONFIG_SENSORS_INA2XX is not set
CONFIG_SENSORS_THMC50=y
# CONFIG_SENSORS_TMP102 is not set
CONFIG_SENSORS_TMP401=y
# CONFIG_SENSORS_TMP421 is not set
CONFIG_SENSORS_VIA_CPUTEMP=y
# CONFIG_SENSORS_VIA686A is not set
CONFIG_SENSORS_VT1211=y
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
# CONFIG_SENSORS_W83791D is not set
CONFIG_SENSORS_W83792D=y
# CONFIG_SENSORS_W83793 is not set
CONFIG_SENSORS_W83795=y
CONFIG_SENSORS_W83795_FANCTRL=y
CONFIG_SENSORS_W83L785TS=y
# CONFIG_SENSORS_W83L786NG is not set
# CONFIG_SENSORS_W83627HF is not set
# CONFIG_SENSORS_W83627EHF is not set
# CONFIG_SENSORS_APPLESMC is not set

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=y
# CONFIG_DA9052_WATCHDOG is not set
CONFIG_ACQUIRE_WDT=y
# CONFIG_ADVANTECH_WDT is not set
# CONFIG_ALIM1535_WDT is not set
# CONFIG_ALIM7101_WDT is not set
# CONFIG_F71808E_WDT is not set
# CONFIG_SP5100_TCO is not set
CONFIG_SC520_WDT=y
CONFIG_SBC_FITPC2_WATCHDOG=y
# CONFIG_EUROTECH_WDT is not set
# CONFIG_IB700_WDT is not set
# CONFIG_IBMASR is not set
CONFIG_WAFER_WDT=y
# CONFIG_I6300ESB_WDT is not set
# CONFIG_IE6XX_WDT is not set
# CONFIG_ITCO_WDT is not set
# CONFIG_IT8712F_WDT is not set
CONFIG_IT87_WDT=y
# CONFIG_HP_WATCHDOG is not set
CONFIG_SC1200_WDT=y
CONFIG_PC87413_WDT=y
# CONFIG_NV_TCO is not set
CONFIG_60XX_WDT=y
CONFIG_SBC8360_WDT=y
# CONFIG_SBC7240_WDT is not set
CONFIG_CPU5_WDT=y
# CONFIG_SMSC_SCH311X_WDT is not set
# CONFIG_SMSC37B787_WDT is not set
# CONFIG_VIA_WDT is not set
CONFIG_W83627HF_WDT=y
CONFIG_W83697HF_WDT=y
# CONFIG_W83697UG_WDT is not set
# CONFIG_W83877F_WDT is not set
# CONFIG_W83977F_WDT is not set
CONFIG_MACHZ_WDT=y
# CONFIG_SBC_EPX_C3_WATCHDOG is not set

#
# ISA-based Watchdog Cards
#
CONFIG_PCWATCHDOG=y
CONFIG_MIXCOMWD=y
# CONFIG_WDT is not set

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
# CONFIG_WDTPCI is not set

#
# USB-based Watchdog Cards
#
CONFIG_USBPCWATCHDOG=y
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
# CONFIG_SSB is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=y
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
# CONFIG_BCMA_HOST_PCI is not set
# CONFIG_BCMA_DRIVER_GMAC_CMN is not set
# CONFIG_BCMA_DEBUG is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
CONFIG_MFD_88PM860X=y
# CONFIG_MFD_88PM800 is not set
# CONFIG_MFD_88PM805 is not set
CONFIG_MFD_SM501=y
# CONFIG_MFD_SM501_GPIO is not set
# CONFIG_HTC_PASIC3 is not set
CONFIG_HTC_I2CPLD=y
# CONFIG_MFD_LM3533 is not set
CONFIG_TPS6105X=y
CONFIG_TPS65010=y
# CONFIG_TPS6507X is not set
CONFIG_MFD_TPS65217=y
# CONFIG_MFD_TPS6586X is not set
# CONFIG_MFD_TPS65910 is not set
# CONFIG_MFD_TPS65912_I2C is not set
# CONFIG_TWL4030_CORE is not set
# CONFIG_TWL6040_CORE is not set
# CONFIG_MFD_STMPE is not set
CONFIG_MFD_TC3589X=y
# CONFIG_MFD_TMIO is not set
# CONFIG_PMIC_DA903X is not set
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_I2C=y
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_MAX77686 is not set
CONFIG_MFD_MAX77693=y
CONFIG_MFD_MAX8925=y
# CONFIG_MFD_MAX8997 is not set
CONFIG_MFD_MAX8998=y
# CONFIG_MFD_SEC_CORE is not set
# CONFIG_MFD_ARIZONA_I2C is not set
CONFIG_MFD_WM8400=y
# CONFIG_MFD_WM831X_I2C is not set
# CONFIG_MFD_WM8350_I2C is not set
CONFIG_MFD_WM8994=y
CONFIG_MFD_PCF50633=y
# CONFIG_PCF50633_ADC is not set
# CONFIG_PCF50633_GPIO is not set
# CONFIG_MFD_MC13XXX_I2C is not set
CONFIG_ABX500_CORE=y
CONFIG_AB3100_CORE=y
CONFIG_AB3100_OTP=y
# CONFIG_MFD_CS5535 is not set
# CONFIG_MFD_TIMBERDALE is not set
# CONFIG_LPC_SCH is not set
# CONFIG_LPC_ICH is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_VX855 is not set
CONFIG_MFD_WL1273_CORE=y
CONFIG_MFD_TPS65090=y
# CONFIG_MFD_AAT2870_CORE is not set
CONFIG_MFD_RC5T583=y
# CONFIG_MFD_PALMAS is not set
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
CONFIG_REGULATOR_DUMMY=y
CONFIG_REGULATOR_FIXED_VOLTAGE=y
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
CONFIG_REGULATOR_USERSPACE_CONSUMER=y
CONFIG_REGULATOR_GPIO=y
# CONFIG_REGULATOR_AD5398 is not set
CONFIG_REGULATOR_DA9052=y
CONFIG_REGULATOR_ISL6271A=y
# CONFIG_REGULATOR_88PM8607 is not set
CONFIG_REGULATOR_MAX1586=y
# CONFIG_REGULATOR_MAX8649 is not set
# CONFIG_REGULATOR_MAX8660 is not set
CONFIG_REGULATOR_MAX8925=y
# CONFIG_REGULATOR_MAX8952 is not set
# CONFIG_REGULATOR_MAX8998 is not set
# CONFIG_REGULATOR_LP3971 is not set
CONFIG_REGULATOR_LP3972=y
# CONFIG_REGULATOR_LP872X is not set
# CONFIG_REGULATOR_PCF50633 is not set
# CONFIG_REGULATOR_RC5T583 is not set
CONFIG_REGULATOR_AB3100=y
CONFIG_REGULATOR_TPS6105X=y
CONFIG_REGULATOR_TPS62360=y
CONFIG_REGULATOR_TPS65023=y
CONFIG_REGULATOR_TPS6507X=y
CONFIG_REGULATOR_TPS65090=y
CONFIG_REGULATOR_TPS65217=y
CONFIG_REGULATOR_WM8400=y
CONFIG_REGULATOR_WM8994=y
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set
CONFIG_DRM=y
CONFIG_DRM_USB=y
CONFIG_DRM_KMS_HELPER=y
# CONFIG_DRM_LOAD_EDID_FIRMWARE is not set
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_NOUVEAU is not set

#
# I2C encoder or helper chips
#
# CONFIG_DRM_I2C_CH7006 is not set
# CONFIG_DRM_I2C_SIL164 is not set
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
# CONFIG_DRM_VMWGFX is not set
# CONFIG_DRM_GMA500 is not set
CONFIG_DRM_UDL=y
# CONFIG_DRM_AST is not set
# CONFIG_DRM_MGAG200 is not set
# CONFIG_DRM_CIRRUS_QEMU is not set
# CONFIG_STUB_POULSBO is not set
# CONFIG_VGASTATE is not set
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
# CONFIG_FB_DDC is not set
CONFIG_FB_BOOT_VESA_SUPPORT=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=y
CONFIG_FB_SYS_COPYAREA=y
CONFIG_FB_SYS_IMAGEBLIT=y
CONFIG_FB_FOREIGN_ENDIAN=y
# CONFIG_FB_BOTH_ENDIAN is not set
CONFIG_FB_BIG_ENDIAN=y
# CONFIG_FB_LITTLE_ENDIAN is not set
CONFIG_FB_SYS_FOPS=y
# CONFIG_FB_WMT_GE_ROPS is not set
CONFIG_FB_DEFERRED_IO=y
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

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
# CONFIG_FB_UVESA is not set
CONFIG_FB_VESA=y
# CONFIG_FB_N411 is not set
CONFIG_FB_HGA=y
CONFIG_FB_S1D13XXX=y
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I740 is not set
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
CONFIG_FB_TMIO=y
# CONFIG_FB_TMIO_ACCELL is not set
# CONFIG_FB_SM501 is not set
CONFIG_FB_SMSCUFX=y
CONFIG_FB_UDL=y
CONFIG_FB_VIRTUAL=y
CONFIG_FB_METRONOME=y
# CONFIG_FB_MB862XX is not set
CONFIG_FB_BROADSHEET=y
# CONFIG_FB_AUO_K190X is not set
# CONFIG_EXYNOS_VIDEO is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
# CONFIG_LCD_PLATFORM is not set
# CONFIG_BACKLIGHT_CLASS_DEVICE is not set
# CONFIG_LOGO is not set
CONFIG_SOUND=y
# CONFIG_SOUND_OSS_CORE is not set
# CONFIG_SND is not set
# CONFIG_SOUND_PRIME is not set

#
# HID support
#
# CONFIG_HID is not set

#
# USB HID support
#
# CONFIG_USB_HID is not set
CONFIG_HID_PID=y

#
# USB HID Boot Protocol drivers
#
CONFIG_USB_KBD=y
# CONFIG_USB_MOUSE is not set
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB_ARCH_HAS_XHCI=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set
# CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set

#
# Miscellaneous USB options
#
# CONFIG_USB_DYNAMIC_MINORS is not set
# CONFIG_USB_SUSPEND is not set
# CONFIG_USB_OTG_WHITELIST is not set
# CONFIG_USB_OTG_BLACKLIST_HUB is not set
# CONFIG_USB_MON is not set
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
# CONFIG_USB_XHCI_HCD is not set
# CONFIG_USB_EHCI_HCD is not set
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
# CONFIG_USB_ISP1362_HCD is not set
# CONFIG_USB_OHCI_HCD is not set
# CONFIG_USB_UHCI_HCD is not set
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_HCD_BCMA is not set
# CONFIG_USB_CHIPIDEA is not set

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
# CONFIG_USB_PRINTER is not set
# CONFIG_USB_WDM is not set
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
# CONFIG_USB_STORAGE is not set
# CONFIG_USB_UAS is not set
# CONFIG_USB_LIBUSUAL is not set

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set

#
# USB port drivers
#
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_SEVSEG is not set
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
# CONFIG_USB_LED is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_YUREX is not set

#
# USB Physical Layer drivers
#
# CONFIG_USB_ISP1301 is not set
# CONFIG_USB_ATM is not set
# CONFIG_USB_GADGET is not set

#
# OTG and related infrastructure
#
# CONFIG_USB_GPIO_VBUS is not set
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_UWB is not set
# CONFIG_MMC is not set
CONFIG_MEMSTICK=y
# CONFIG_MEMSTICK_DEBUG is not set

#
# MemoryStick drivers
#
CONFIG_MEMSTICK_UNSAFE_RESUME=y
CONFIG_MSPRO_BLOCK=y

#
# MemoryStick Host Controller Drivers
#
# CONFIG_MEMSTICK_TIFM_MS is not set
# CONFIG_MEMSTICK_JMICRON_38X is not set
# CONFIG_MEMSTICK_R592 is not set
# CONFIG_NEW_LEDS is not set
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
# CONFIG_RTC_CLASS is not set
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
# CONFIG_INTEL_MID_DMAC is not set
# CONFIG_INTEL_IOATDMA is not set
# CONFIG_TIMB_DMA is not set
# CONFIG_PCH_DMA is not set
CONFIG_AUXDISPLAY=y
CONFIG_UIO=y
# CONFIG_UIO_CIF is not set
# CONFIG_UIO_PDRV is not set
CONFIG_UIO_PDRV_GENIRQ=y
# CONFIG_UIO_AEC is not set
# CONFIG_UIO_SERCOS3 is not set
# CONFIG_UIO_PCI_GENERIC is not set
# CONFIG_UIO_NETX is not set
CONFIG_VIRTIO=y
CONFIG_VIRTIO_RING=y

#
# Virtio drivers
#
# CONFIG_VIRTIO_PCI is not set
# CONFIG_VIRTIO_BALLOON is not set
CONFIG_VIRTIO_MMIO=y
CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES=y

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
CONFIG_STAGING=y
# CONFIG_SLICOSS is not set
# CONFIG_USBIP_CORE is not set
# CONFIG_ECHO is not set
# CONFIG_ASUS_OLED is not set
# CONFIG_RTS_PSTOR is not set
CONFIG_RTS5139=y
# CONFIG_RTS5139_DEBUG is not set
# CONFIG_TRANZPORT is not set
# CONFIG_DX_SEP is not set
# CONFIG_ZSMALLOC is not set
# CONFIG_FB_SM7XX is not set
# CONFIG_CRYSTALHD is not set
# CONFIG_FB_XGI is not set
# CONFIG_ACPI_QUICKSTART is not set
CONFIG_BCM_WIMAX=y
CONFIG_FT1000=y
CONFIG_FT1000_USB=y

#
# Speakup console speech
#
CONFIG_TOUCHSCREEN_CLEARPAD_TM1217=y
CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4=y
# CONFIG_STAGING_MEDIA is not set

#
# Android
#
CONFIG_ANDROID=y
CONFIG_ANDROID_BINDER_IPC=y
CONFIG_ASHMEM=y
# CONFIG_ANDROID_LOGGER is not set
CONFIG_ANDROID_TIMED_OUTPUT=y
CONFIG_ANDROID_TIMED_GPIO=y
# CONFIG_ANDROID_LOW_MEMORY_KILLER is not set
# CONFIG_PHONE is not set
CONFIG_USB_WPAN_HCD=y
CONFIG_IPACK_BUS=y
# CONFIG_BOARD_TPCI200 is not set
CONFIG_SERIAL_IPOCTAL=y
# CONFIG_WIMAX_GDM72XX is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_FUJITSU_TABLET is not set
# CONFIG_HP_ACCEL is not set
# CONFIG_THINKPAD_ACPI is not set
CONFIG_SENSORS_HDAPS=y
# CONFIG_INTEL_MENLOW is not set
# CONFIG_ACPI_WMI is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_ACPI_CMPC is not set
# CONFIG_INTEL_IPS is not set
# CONFIG_IBM_RTL is not set
# CONFIG_XO15_EBOOK is not set
# CONFIG_SAMSUNG_Q10 is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKSRC_I8253=y
CONFIG_CLKEVT_I8253=y
CONFIG_CLKBLD_I8253=y
CONFIG_IOMMU_SUPPORT=y

#
# Remoteproc drivers (EXPERIMENTAL)
#

#
# Rpmsg drivers (EXPERIMENTAL)
#
CONFIG_VIRT_DRIVERS=y
CONFIG_PM_DEVFREQ=y

#
# DEVFREQ Governors
#
CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND=y
# CONFIG_DEVFREQ_GOV_PERFORMANCE is not set
# CONFIG_DEVFREQ_GOV_POWERSAVE is not set
# CONFIG_DEVFREQ_GOV_USERSPACE is not set

#
# DEVFREQ Drivers
#
# CONFIG_EXTCON is not set
CONFIG_MEMORY=y
# CONFIG_IIO is not set
# CONFIG_VME_BUS is not set
# CONFIG_PWM is not set

#
# Firmware Drivers
#
CONFIG_EDD=y
# CONFIG_EDD_OFF is not set
# CONFIG_FIRMWARE_MEMMAP is not set
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
CONFIG_ISCSI_IBFT_FIND=y
# CONFIG_GOOGLE_FIRMWARE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_EXT2_FS=y
# CONFIG_EXT2_FS_XATTR is not set
CONFIG_EXT2_FS_XIP=y
CONFIG_EXT3_FS=y
# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
# CONFIG_EXT3_FS_XATTR is not set
# CONFIG_EXT4_FS is not set
CONFIG_FS_XIP=y
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
# CONFIG_REISERFS_FS is not set
CONFIG_JFS_FS=y
CONFIG_JFS_POSIX_ACL=y
# CONFIG_JFS_SECURITY is not set
CONFIG_JFS_DEBUG=y
CONFIG_JFS_STATISTICS=y
CONFIG_XFS_FS=y
CONFIG_XFS_QUOTA=y
CONFIG_XFS_POSIX_ACL=y
CONFIG_XFS_RT=y
CONFIG_XFS_DEBUG=y
CONFIG_GFS2_FS=y
# CONFIG_OCFS2_FS is not set
CONFIG_BTRFS_FS=y
CONFIG_BTRFS_FS_POSIX_ACL=y
# CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
CONFIG_NILFS2_FS=y
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
# CONFIG_FILE_LOCKING is not set
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_FANOTIFY is not set
# CONFIG_QUOTA is not set
CONFIG_QUOTA_NETLINK_INTERFACE=y
CONFIG_QUOTACTL=y
# CONFIG_AUTOFS4_FS is not set
# CONFIG_FUSE_FS is not set

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# CD-ROM/DVD Filesystems
#
# CONFIG_ISO9660_FS is not set
# CONFIG_UDF_FS is not set

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
CONFIG_NTFS_FS=y
CONFIG_NTFS_DEBUG=y
# CONFIG_NTFS_RW is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
# CONFIG_TMPFS is not set
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_ECRYPT_FS is not set
CONFIG_HFS_FS=y
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_JFFS2_FS is not set
# CONFIG_LOGFS is not set
# CONFIG_CRAMFS is not set
# CONFIG_SQUASHFS is not set
# CONFIG_VXFS_FS is not set
CONFIG_MINIX_FS=y
CONFIG_OMFS_FS=y
CONFIG_HPFS_FS=y
CONFIG_QNX4FS_FS=y
CONFIG_QNX6FS_FS=y
# CONFIG_QNX6FS_DEBUG is not set
# CONFIG_ROMFS_FS is not set
# CONFIG_PSTORE is not set
CONFIG_SYSV_FS=y
# CONFIG_UFS_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
# CONFIG_CEPH_FS is not set
CONFIG_CIFS=y
CONFIG_CIFS_STATS=y
# CONFIG_CIFS_STATS2 is not set
CONFIG_CIFS_WEAK_PW_HASH=y
CONFIG_CIFS_UPCALL=y
CONFIG_CIFS_XATTR=y
CONFIG_CIFS_POSIX=y
CONFIG_CIFS_DEBUG2=y
# CONFIG_CIFS_DFS_UPCALL is not set
CONFIG_CIFS_ACL=y
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
CONFIG_AFS_FS=y
CONFIG_AFS_DEBUG=y
CONFIG_9P_FS=y
CONFIG_9P_FS_POSIX_ACL=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=y
CONFIG_NLS_CODEPAGE_775=y
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
CONFIG_NLS_CODEPAGE_855=y
CONFIG_NLS_CODEPAGE_857=y
CONFIG_NLS_CODEPAGE_860=y
# CONFIG_NLS_CODEPAGE_861 is not set
CONFIG_NLS_CODEPAGE_862=y
CONFIG_NLS_CODEPAGE_863=y
CONFIG_NLS_CODEPAGE_864=y
CONFIG_NLS_CODEPAGE_865=y
# CONFIG_NLS_CODEPAGE_866 is not set
CONFIG_NLS_CODEPAGE_869=y
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
CONFIG_NLS_CODEPAGE_932=y
CONFIG_NLS_CODEPAGE_949=y
CONFIG_NLS_CODEPAGE_874=y
CONFIG_NLS_ISO8859_8=y
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
# CONFIG_NLS_ASCII is not set
CONFIG_NLS_ISO8859_1=y
# CONFIG_NLS_ISO8859_2 is not set
CONFIG_NLS_ISO8859_3=y
CONFIG_NLS_ISO8859_4=y
# CONFIG_NLS_ISO8859_5 is not set
CONFIG_NLS_ISO8859_6=y
# CONFIG_NLS_ISO8859_7 is not set
CONFIG_NLS_ISO8859_9=y
# CONFIG_NLS_ISO8859_13 is not set
CONFIG_NLS_ISO8859_14=y
CONFIG_NLS_ISO8859_15=y
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
# CONFIG_NLS_MAC_ROMAN is not set
# CONFIG_NLS_MAC_CELTIC is not set
# CONFIG_NLS_MAC_CENTEURO is not set
CONFIG_NLS_MAC_CROATIAN=y
CONFIG_NLS_MAC_CYRILLIC=y
# CONFIG_NLS_MAC_GAELIC is not set
# CONFIG_NLS_MAC_GREEK is not set
# CONFIG_NLS_MAC_ICELAND is not set
CONFIG_NLS_MAC_INUIT=y
CONFIG_NLS_MAC_ROMANIAN=y
CONFIG_NLS_MAC_TURKISH=y
# CONFIG_NLS_UTF8 is not set
CONFIG_DLM=y
# CONFIG_DLM_DEBUG is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
# CONFIG_ENABLE_WARN_DEPRECATED is not set
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=1024
CONFIG_MAGIC_SYSRQ=y
# CONFIG_STRIP_ASM_SYMS is not set
# CONFIG_READABLE_ASM is not set
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_SHIRQ=y
# CONFIG_LOCKUP_DETECTOR is not set
# CONFIG_HARDLOCKUP_DETECTOR is not set
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y
# CONFIG_DEBUG_OBJECTS is not set
CONFIG_SLUB_DEBUG_ON=y
# CONFIG_SLUB_STATS is not set
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
CONFIG_RT_MUTEX_TESTER=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
# CONFIG_PROVE_LOCKING is not set
# CONFIG_SPARSE_RCU_POINTER is not set
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
CONFIG_DEBUG_LOCKDEP=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_STACKTRACE=y
CONFIG_DEBUG_STACK_USAGE=y
# CONFIG_DEBUG_KOBJECT is not set
# CONFIG_DEBUG_HIGHMEM is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_INFO is not set
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
# CONFIG_DEBUG_WRITECOUNT is not set
# CONFIG_DEBUG_MEMORY_INIT is not set
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
# CONFIG_RCU_CPU_STALL_INFO is not set
CONFIG_RCU_TRACE=y
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
# CONFIG_DEBUG_PER_CPU_MAPS is not set
CONFIG_LKDTM=y
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
CONFIG_FAULT_INJECTION=y
CONFIG_FAILSLAB=y
CONFIG_FAIL_PAGE_ALLOC=y
CONFIG_FAIL_MAKE_REQUEST=y
# CONFIG_FAIL_IO_TIMEOUT is not set
CONFIG_FAULT_INJECTION_DEBUG_FS=y
# CONFIG_FAULT_INJECTION_STACKTRACE_FILTER is not set
CONFIG_LATENCYTOP=y
CONFIG_DEBUG_PAGEALLOC=y
CONFIG_WANT_PAGE_DEBUG_FLAGS=y
CONFIG_PAGE_GUARD=y
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DYNAMIC_DEBUG is not set
# CONFIG_DMA_API_DEBUG is not set
CONFIG_ATOMIC64_SELFTEST=y
CONFIG_ASYNC_RAID6_TEST=y
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_KMEMCHECK is not set
# CONFIG_TEST_KSTRTOX is not set
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
CONFIG_DEBUG_STACKOVERFLOW=y
# CONFIG_X86_PTDUMP is not set
# CONFIG_DEBUG_RODATA is not set
# CONFIG_DOUBLEFAULT is not set
# CONFIG_DEBUG_TLBFLUSH is not set
CONFIG_IOMMU_STRESS=y
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=0
# CONFIG_DEBUG_BOOT_PARAMS is not set
CONFIG_CPA_DEBUG=y
CONFIG_OPTIMIZE_INLINING=y
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
CONFIG_DEBUG_NMI_SELFTEST=y

#
# Security options
#
CONFIG_KEYS=y
CONFIG_TRUSTED_KEYS=y
CONFIG_ENCRYPTED_KEYS=y
CONFIG_KEYS_DEBUG_PROC_KEYS=y
# CONFIG_SECURITY_DMESG_RESTRICT is not set
# CONFIG_SECURITY is not set
CONFIG_SECURITYFS=y
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_XOR_BLOCKS=y
CONFIG_ASYNC_CORE=y
CONFIG_ASYNC_MEMCPY=y
CONFIG_ASYNC_XOR=y
CONFIG_ASYNC_PQ=y
CONFIG_ASYNC_RAID6_RECOV=y
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP=y
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_USER=y
# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_PCRYPT=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=y
CONFIG_CRYPTO_GCM=y
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=y
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_PCBC=y
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=y
# CONFIG_CRYPTO_XCBC is not set
CONFIG_CRYPTO_VMAC=y

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
# CONFIG_CRYPTO_CRC32C_INTEL is not set
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
# CONFIG_CRYPTO_MICHAEL_MIC is not set
CONFIG_CRYPTO_RMD128=y
# CONFIG_CRYPTO_RMD160 is not set
CONFIG_CRYPTO_RMD256=y
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
# CONFIG_CRYPTO_SHA512 is not set
# CONFIG_CRYPTO_TGR192 is not set
CONFIG_CRYPTO_WP512=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
# CONFIG_CRYPTO_AES_586 is not set
# CONFIG_CRYPTO_AES_NI_INTEL is not set
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_BLOWFISH_COMMON=y
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAST5=y
# CONFIG_CRYPTO_CAST6 is not set
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_SALSA20 is not set
# CONFIG_CRYPTO_SALSA20_586 is not set
CONFIG_CRYPTO_SEED=y
# CONFIG_CRYPTO_SERPENT is not set
# CONFIG_CRYPTO_SERPENT_SSE2_586 is not set
CONFIG_CRYPTO_TEA=y
# CONFIG_CRYPTO_TWOFISH is not set
# CONFIG_CRYPTO_TWOFISH_586 is not set

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_ZLIB=y
# CONFIG_CRYPTO_LZO is not set

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
CONFIG_CRYPTO_USER_API=y
# CONFIG_CRYPTO_USER_API_HASH is not set
CONFIG_CRYPTO_USER_API_SKCIPHER=y
CONFIG_CRYPTO_HW=y
# CONFIG_CRYPTO_DEV_PADLOCK is not set
# CONFIG_CRYPTO_DEV_GEODE is not set
# CONFIG_CRYPTO_DEV_HIFN_795X is not set
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
# CONFIG_KVM is not set
CONFIG_VHOST_NET=y
# CONFIG_LGUEST is not set
# CONFIG_BINARY_PRINTF is not set

#
# Library routines
#
CONFIG_RAID6_PQ=y
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_IO=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
# CONFIG_CRC32_SLICEBY8 is not set
# CONFIG_CRC32_SLICEBY4 is not set
CONFIG_CRC32_SARWATE=y
# CONFIG_CRC32_BIT is not set
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
CONFIG_CRC8=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
# CONFIG_XZ_DEC is not set
# CONFIG_XZ_DEC_BCJ is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_BCH=y
CONFIG_BCH_CONST_PARAMS=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=y
CONFIG_TEXTSEARCH_BM=y
CONFIG_TEXTSEARCH_FSM=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_LRU_CACHE=y
CONFIG_AVERAGE=y
CONFIG_CORDIC=y
# CONFIG_DDR is not set

--bp/iNruPH9dso1Pn--
