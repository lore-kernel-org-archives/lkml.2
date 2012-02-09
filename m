Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758663Ab2BIXqj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 18:46:39 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:64094 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758437Ab2BIXqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 18:46:37 -0500
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 9 Feb 2012 15:46:17 -0800
X-Google-Sender-Auth: h1433j6AcQwpeqf0wewywYYAjck
Message-ID: <CA+55aFyXyfYd+_NJ8kLYz-bk7Qt0SLHu4t7RN1PCQptt75RGXQ@mail.gmail.com>
Subject: Hmm.. WARN_ON_ONCE(cpuc->enabled)
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, x86@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, so I get the appended on my Core i5 when I did a "perf record -f
-e cycles:pp make -j" on the kernel build.

What's up, guys? I haven't tried that particular perf run in a while,
so it might have been going on for quite some time.

                             Linus

---

 WARNING: at arch/x86/kernel/cpu/perf_event_intel_ds.c:442
intel_pmu_pebs_enable+0x89/0xa0()
 Hardware name: System Product Name
 Pid: 12994, comm: perf Not tainted 3.3.0-rc3-00001-g690d137f448d #34
 Call Trace:
  <IRQ>  [<ffffffff8102f205>] warn_slowpath_common+0x75/0xb0
  [<ffffffff8105c1d4>] ? load_balance+0xc4/0x860
  [<ffffffff8102f305>] warn_slowpath_null+0x15/0x20
  [<ffffffff81013f59>] intel_pmu_pebs_enable+0x89/0xa0
  [<ffffffff81014614>] intel_pmu_enable_event+0xf4/0x190
  [<ffffffff81010f33>] x86_pmu_start+0x83/0x110
  [<ffffffff81098336>] perf_adjust_freq_unthr_context+0x106/0x170
  [<ffffffff810985a0>] perf_event_task_tick+0x200/0x2c0
  [<ffffffff8106a5d0>] ? tick_nohz_handler+0xf0/0xf0
  [<ffffffff81055856>] scheduler_tick+0xc6/0x100
  [<ffffffff8103b649>] update_process_times+0x69/0x80
  [<ffffffff8106a62f>] tick_sched_timer+0x5f/0xb0
  [<ffffffff8104dcd5>] __run_hrtimer.clone.31+0x55/0x110
  [<ffffffff8104e6ff>] hrtimer_interrupt+0xdf/0x210
  [<ffffffff8101c744>] smp_apic_timer_interrupt+0x64/0xa0
  [<ffffffff816a264b>] apic_timer_interrupt+0x6b/0x70
  <EOI>  [<ffffffff8109d8df>] ? find_get_page+0x6f/0xc0
  [<ffffffff8128c114>] ? avtab_search_node+0x74/0x90
  [<ffffffff810a8b23>] ? mark_page_accessed+0x43/0x50
  [<ffffffff8129744d>] cond_compute_av+0x2d/0xd0
  [<ffffffff81293922>] context_struct_compute_av+0x1f2/0x420
  [<ffffffff8110834f>] ? __getblk+0x1f/0x280
  [<ffffffff81294265>] security_compute_av+0xf5/0x2c0
  [<ffffffff8127eeec>] avc_has_perm_noaudit+0xfc/0x3a0
  [<ffffffff811058ec>] ? ll_rw_block+0x2c/0xb0
  [<ffffffff8127f1d6>] avc_has_perm_flags+0x46/0xa0
  [<ffffffff81284801>] inode_has_perm.clone.39+0x21/0x30
  [<ffffffff8128525a>] selinux_inode_permission+0xaa/0x100
  [<ffffffff8127cc97>] security_inode_permission+0x17/0x20
  [<ffffffff810e4280>] inode_permission+0x40/0xd0
  [<ffffffff810e566f>] link_path_walk+0x6f/0x8f0
  [<ffffffff810e7807>] path_openat+0xb7/0x430
  [<ffffffff810e7bc4>] do_filp_open+0x44/0xa0
  [<ffffffff810b15ee>] ? kmemdup+0x3e/0x50
  [<ffffffff8128245a>] ? selinux_cred_prepare+0x1a/0x40
  [<ffffffff810df7dd>] open_exec+0x2d/0xf0
  [<ffffffff810e08d1>] do_execve_common.clone.36+0x1f1/0x430
  [<ffffffff810e0b26>] do_execve+0x16/0x20
  [<ffffffff8100aba5>] sys_execve+0x45/0x70
  [<ffffffff816a1fec>] stub_execve+0x6c/0xc0
 ---[ end trace 55816fcc72df1997 ]---
 ------------[ cut here ]------------
 WARNING: at arch/x86/kernel/cpu/perf_event_intel_lbr.c:75
intel_pmu_lbr_enable+0x92/0xa0()
 Hardware name: System Product Name
 Pid: 12994, comm: perf Tainted: G        W    3.3.0-rc3-00001-g690d137f448d #34
 Call Trace:
  <IRQ>  [<ffffffff8102f205>] warn_slowpath_common+0x75/0xb0
  [<ffffffff8102f305>] warn_slowpath_null+0x15/0x20
  [<ffffffff81012e32>] intel_pmu_lbr_enable+0x92/0xa0
  [<ffffffff81013f38>] intel_pmu_pebs_enable+0x68/0xa0
  [<ffffffff81014614>] intel_pmu_enable_event+0xf4/0x190
  [<ffffffff81010f33>] x86_pmu_start+0x83/0x110
  [<ffffffff81098336>] perf_adjust_freq_unthr_context+0x106/0x170
  [<ffffffff810985a0>] perf_event_task_tick+0x200/0x2c0
  [<ffffffff8106a5d0>] ? tick_nohz_handler+0xf0/0xf0
  [<ffffffff81055856>] scheduler_tick+0xc6/0x100
  [<ffffffff8103b649>] update_process_times+0x69/0x80
  [<ffffffff8106a62f>] tick_sched_timer+0x5f/0xb0
  [<ffffffff8104dcd5>] __run_hrtimer.clone.31+0x55/0x110
  [<ffffffff8104e6ff>] hrtimer_interrupt+0xdf/0x210
  [<ffffffff8101c744>] smp_apic_timer_interrupt+0x64/0xa0
  [<ffffffff816a264b>] apic_timer_interrupt+0x6b/0x70
  <EOI>  [<ffffffff8109d8df>] ? find_get_page+0x6f/0xc0
  [<ffffffff8128c114>] ? avtab_search_node+0x74/0x90
  [<ffffffff810a8b23>] ? mark_page_accessed+0x43/0x50
  [<ffffffff8129744d>] cond_compute_av+0x2d/0xd0
  [<ffffffff81293922>] context_struct_compute_av+0x1f2/0x420
  [<ffffffff8110834f>] ? __getblk+0x1f/0x280
  [<ffffffff81294265>] security_compute_av+0xf5/0x2c0
  [<ffffffff8127eeec>] avc_has_perm_noaudit+0xfc/0x3a0
  [<ffffffff811058ec>] ? ll_rw_block+0x2c/0xb0
  [<ffffffff8127f1d6>] avc_has_perm_flags+0x46/0xa0
  [<ffffffff81284801>] inode_has_perm.clone.39+0x21/0x30
  [<ffffffff8128525a>] selinux_inode_permission+0xaa/0x100
  [<ffffffff8127cc97>] security_inode_permission+0x17/0x20
  [<ffffffff810e4280>] inode_permission+0x40/0xd0
  [<ffffffff810e566f>] link_path_walk+0x6f/0x8f0
  [<ffffffff810e7807>] path_openat+0xb7/0x430
  [<ffffffff810e7bc4>] do_filp_open+0x44/0xa0
  [<ffffffff810b15ee>] ? kmemdup+0x3e/0x50
  [<ffffffff8128245a>] ? selinux_cred_prepare+0x1a/0x40
  [<ffffffff810df7dd>] open_exec+0x2d/0xf0
  [<ffffffff810e08d1>] do_execve_common.clone.36+0x1f1/0x430
  [<ffffffff810e0b26>] do_execve+0x16/0x20
  [<ffffffff8100aba5>] sys_execve+0x45/0x70
  [<ffffffff816a1fec>] stub_execve+0x6c/0xc0
 ---[ end trace 55816fcc72df1998 ]---
