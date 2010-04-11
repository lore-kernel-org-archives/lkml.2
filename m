Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751969Ab0DKNQa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Apr 2010 09:16:30 -0400
Received: from mail.skyhub.de ([78.46.96.112]:38317 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751812Ab0DKNQ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Apr 2010 09:16:28 -0400
Date: Sun, 11 Apr 2010 15:08:01 +0200
From: Borislav Petkov <bp@alien8.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com
Subject: Re: [PATCH -v2] rmap: make anon_vma_prepare link in all the
 anon_vmas of a mergeable VMA
Message-ID: <20100411130801.GA7189@a1.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
	Rik van Riel <riel@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Minchan Kim <minchan.kim@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
	Nick Piggin <npiggin@suse.de>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com
References: <alpine.LFD.2.00.1004101101180.3558@i5.linux-foundation.org>
 <20100410185145.GB28952@a1.tnic>
 <20100410185839.GA32035@a1.tnic>
 <alpine.LFD.2.00.1004101234210.3558@i5.linux-foundation.org>
 <alpine.LFD.2.00.1004101308250.3618@i5.linux-foundation.org>
 <20100410203628.GB32035@a1.tnic>
 <alpine.LFD.2.00.1004101336440.3618@i5.linux-foundation.org>
 <20100410212555.GA1797@a1.tnic>
 <alpine.LFD.2.00.1004101427090.3618@i5.linux-foundation.org>
 <20100410215115.GA2599@a1.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100410215115.GA2599@a1.tnic>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@alien8.de>
Date: Sat, Apr 10, 2010 at 11:51:15PM +0200

> > Damn, I really hoped that was it. Three independent bugs found and fixed, 
> > and still no joy? Oh well.
> 
> Yep, I'll redo the testing tomorrow, so that we are sure that even with
> the _three_ bugs fixed we still hit the funky list element issue.

Ok, I could verify that the three patches we were talking about still
can't fix the issue. However, just to make sure I'm sending the versions
of the patches I used for you guys to check.

[  529.667108] PM: Preallocating image memory... 
[  529.930881] BUG: unable to handle kernel NULL pointer dereference at (null)
[  529.931275] IP: [<ffffffff810c603c>] page_referenced+0xee/0x1dc
[  529.931377] PGD 22e33d067 PUD 22ddc1067 PMD 0 
[  529.931377] Oops: 0000 [#1] PREEMPT SMP 
[  529.931377] last sysfs file: /sys/power/state
[  529.931377] CPU 3 
[  529.931377] Modules linked in: powernow_k8 cpufreq_ondemand cpufreq_powersave cpufreq_userspace freq_table cpufreq_conservative binfmt_misc kvm_amd kvm ipv6 vfat fat dm_crypt dm_mod 8250_pnp 8250 ohci_hcd edac_core serial_core pcspkr k10temp
[  529.931377] 
[  529.931377] Pid: 3354, comm: hib.sh Tainted: G        W  2.6.34-rc3-00503-g0fcc334 #1 M3A78 PRO/System Product Name
[  529.931377] RIP: 0010:[<ffffffff810c603c>]  [<ffffffff810c603c>] page_referenced+0xee/0x1dc
[  529.931377] RSP: 0018:ffff880105a118b8  EFLAGS: 00010283
[  529.931377] RAX: ffff88022dc896c8 RBX: ffffea0007a15e10 RCX: 0000000000000000
[  529.931377] RDX: ffff880105a11cf8 RSI: ffff88022dc896a0 RDI: ffff88022b760000
[  529.931377] RBP: ffff880105a11938 R08: 0000000000000002 R09: 0000000000000000
[  529.931377] R10: 0000000000000000 R11: ffffffff00000012 R12: 0000000000000000
[  529.931377] R13: ffffffffffffffe0 R14: ffff88022dc89688 R15: ffff880105a11a00
[  529.931377] FS:  00007f21045876f0(0000) GS:ffff88000a600000(0000) knlGS:0000000000000000
[  529.931377] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  529.931377] CR2: 0000000000000000 CR3: 000000022b33f000 CR4: 00000000000006e0
[  529.931377] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  529.931377] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  529.931377] Process hib.sh (pid: 3354, threadinfo ffff880105a10000, task ffff88022b760000)
[  529.931377] Stack:
[  529.931377]  ffff88022dc896c8 00000000810b0082 0000000000000000 0000000000000000
[  529.931377] <0> 0000000000000000 0000000000000000 0000000000000000 0000000000000020
[  529.931377] <0> 0000000000000000 0000000200000000 7fffffffffffffff ffffea0007a15e38
[  529.931377] Call Trace:
[  529.931377]  [<ffffffff810b06bc>] shrink_page_list+0x154/0x4c7
[  529.931377]  [<ffffffff81067149>] ? print_lock_contention_bug+0x1b/0xe1
[  529.931377]  [<ffffffff810af59c>] ? isolate_pages_global+0xd0/0x1fc
[  529.931377]  [<ffffffff8140f9f6>] ? _raw_spin_unlock_irq+0x30/0x58
[  529.931377]  [<ffffffff810b0d8a>] shrink_inactive_list+0x35b/0x60c
[  529.931377]  [<ffffffff810b0556>] ? shrink_active_list+0x232/0x244
[  529.931377]  [<ffffffff810b1347>] shrink_zone+0x30c/0x3d6
[  529.931377]  [<ffffffff810b1f3d>] do_try_to_free_pages+0x191/0x29a
[  529.931377]  [<ffffffff810b20db>] shrink_all_memory+0x95/0xc4
[  529.931377]  [<ffffffff81078e1e>] ? memory_bm_test_bit+0x1/0x30
[  529.931377]  [<ffffffff810af4cc>] ? isolate_pages_global+0x0/0x1fc
[  529.931377]  [<ffffffff81079c9c>] ? count_data_pages+0x65/0x79
[  529.931377]  [<ffffffff81079f03>] hibernate_preallocate_memory+0x1aa/0x2cb
[  529.931377]  [<ffffffff8140bd74>] ? printk+0x41/0x45
[  529.931377]  [<ffffffff8107878f>] hibernation_snapshot+0x36/0x1e1
[  529.931377]  [<ffffffff81078a08>] hibernate+0xce/0x172
[  529.931377]  [<ffffffff81077775>] state_store+0x5c/0xd3
[  529.931377]  [<ffffffff8118f573>] kobj_attr_store+0x17/0x19
[  529.931377]  [<ffffffff8112e42c>] sysfs_write_file+0x108/0x144
[  529.931377]  [<ffffffff810db63b>] vfs_write+0xb2/0x153
[  529.931377]  [<ffffffff810663c9>] ? trace_hardirqs_on_caller+0x1f/0x14b
[  529.931377]  [<ffffffff810db79f>] sys_write+0x4a/0x71
[  529.931377]  [<ffffffff8100221b>] system_call_fastpath+0x16/0x1b
[  529.931377] Code: 3b 56 10 73 1e 48 83 fa f2 74 18 48 8d 4d cc 4d 89 f8 48 89 df e8 11 f2 ff ff 41 01 c4 83 7d cc 00 74 19 4d 8b 6d 20 49 83 ed 20 <49> 8b 45 20 0f 18 08 49 8d 45 20 48 39 45 80 75 aa 4c 89 f7 e8 
[  529.931377] RIP  [<ffffffff810c603c>] page_referenced+0xee/0x1dc
[  529.931377]  RSP <ffff880105a118b8>
[  529.931377] CR2: 0000000000000000
[  529.945250] ---[ end trace caa5471c993e6461 ]---
[  529.945558] note: hib.sh[3354] exited with preempt_count 2
[  529.945710] BUG: scheduling while atomic: hib.sh/3354/0x10000003
[  529.945858] INFO: lockdep is turned off.
[  529.946005] Modules linked in: powernow_k8 cpufreq_ondemand cpufreq_powersave cpufreq_userspace freq_table cpufreq_conservative binfmt_misc kvm_amd kvm ipv6 vfat fat dm_crypt dm_mod 8250_pnp 8250 ohci_hcd edac_core serial_core pcspkr k10temp
[  529.947595] Pid: 3354, comm: hib.sh Tainted: G      D W  2.6.34-rc3-00503-g0fcc334 #1
[  529.947848] Call Trace:
[  529.947993]  [<ffffffff810658df>] ? __debug_show_held_locks+0x1b/0x24
[  529.948147]  [<ffffffff8102dfac>] __schedule_bug+0x72/0x77
[  529.948296]  [<ffffffff8140c188>] schedule+0xe3/0x7ff
[  529.948449]  [<ffffffff810bd0e4>] ? unmap_vmas+0x90c/0x911
[  529.948599]  [<ffffffff81030ecb>] __cond_resched+0x18/0x24
[  529.948748]  [<ffffffff8140c971>] _cond_resched+0x2c/0x37
[  529.948896]  [<ffffffff810bcef1>] unmap_vmas+0x719/0x911
[  529.949049]  [<ffffffff8140f01e>] ? _raw_spin_lock_irqsave+0x1e/0x85
[  529.949199]  [<ffffffff8105a878>] ? up+0x14/0x3e
[  529.949347]  [<ffffffff810c171f>] exit_mmap+0x102/0x1e4
[  529.949639]  [<ffffffff810c1686>] ? exit_mmap+0x69/0x1e4
[  529.949787]  [<ffffffff810368bc>] mmput+0x48/0xb9
[  529.949935]  [<ffffffff8103ad90>] exit_mm+0x110/0x11d
[  529.950087]  [<ffffffff8103c9e6>] do_exit+0x1c5/0x6e5
[  529.950236]  [<ffffffff81039e2f>] ? kmsg_dump+0x13b/0x155
[  529.950525]  [<ffffffff8100616b>] ? oops_end+0x47/0x93
[  529.950671]  [<ffffffff810061b2>] oops_end+0x8e/0x93
[  529.950819]  [<ffffffff8101f3e5>] no_context+0x1fc/0x20b
[  529.950967]  [<ffffffff8101f580>] __bad_area_nosemaphore+0x18c/0x1af
[  529.951120]  [<ffffffff8101f7bb>] ? do_page_fault+0xa8/0x32d
[  529.951276]  [<ffffffff8101f5b6>] bad_area_nosemaphore+0x13/0x15
[  529.951572]  [<ffffffff8101f886>] do_page_fault+0x173/0x32d
[  529.951719]  [<ffffffff81410363>] ? error_sti+0x5/0x6
[  529.951867]  [<ffffffff81065387>] ? trace_hardirqs_off_caller+0x1f/0xa9
[  529.952018]  [<ffffffff8140ec9b>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[  529.952170]  [<ffffffff8141017f>] page_fault+0x1f/0x30
[  529.952319]  [<ffffffff810c603c>] ? page_referenced+0xee/0x1dc
[  529.952615]  [<ffffffff810c5fce>] ? page_referenced+0x80/0x1dc
[  529.952762]  [<ffffffff810b06bc>] shrink_page_list+0x154/0x4c7
[  529.952911]  [<ffffffff81067149>] ? print_lock_contention_bug+0x1b/0xe1
[  529.953065]  [<ffffffff810af59c>] ? isolate_pages_global+0xd0/0x1fc
[  529.953214]  [<ffffffff8140f9f6>] ? _raw_spin_unlock_irq+0x30/0x58
[  529.953363]  [<ffffffff810b0d8a>] shrink_inactive_list+0x35b/0x60c
[  529.953627]  [<ffffffff810b0556>] ? shrink_active_list+0x232/0x244
[  529.953775]  [<ffffffff810b1347>] shrink_zone+0x30c/0x3d6
[  529.953924]  [<ffffffff810b1f3d>] do_try_to_free_pages+0x191/0x29a
[  529.954077]  [<ffffffff810b20db>] shrink_all_memory+0x95/0xc4
[  529.954226]  [<ffffffff81078e1e>] ? memory_bm_test_bit+0x1/0x30
[  529.954486]  [<ffffffff810af4cc>] ? isolate_pages_global+0x0/0x1fc
[  529.954632]  [<ffffffff81079c9c>] ? count_data_pages+0x65/0x79
[  529.954782]  [<ffffffff81079f03>] hibernate_preallocate_memory+0x1aa/0x2cb
[  529.954931]  [<ffffffff8140bd74>] ? printk+0x41/0x45
[  529.955083]  [<ffffffff8107878f>] hibernation_snapshot+0x36/0x1e1
[  529.955233]  [<ffffffff81078a08>] hibernate+0xce/0x172
[  529.955457]  [<ffffffff81077775>] state_store+0x5c/0xd3
[  529.955604]  [<ffffffff8118f573>] kobj_attr_store+0x17/0x19
[  529.955752]  [<ffffffff8112e42c>] sysfs_write_file+0x108/0x144
[  529.955900]  [<ffffffff810db63b>] vfs_write+0xb2/0x153
[  529.956053]  [<ffffffff810663c9>] ? trace_hardirqs_on_caller+0x1f/0x14b
[  529.956202]  [<ffffffff810db79f>] sys_write+0x4a/0x71
[  529.956351]  [<ffffffff8100221b>] system_call_fastpath+0x16/0x1b
[  537.634362] SysRq : HELP : loglevel(0-9) reBoot Crash show-all-locks(D) terminate-all-tasks(E) memory-full-oom-kill(F) kill-all-tasks(I) thaw-filesystems(J) saK show-backtrace-all-active-cpus(L) show-memory-usage(M) nice-all-RT-tasks(N) powerOff show-registers(P) show-all-timers(Q) unRaw Sync show-task-states(T) Unmount show-blocked-tasks(W) dump-ftrace-buffer(Z) 
[  538.129750] SysRq : Emergency Sync
[  538.130161] Emergency Sync complete
[  538.902386] SysRq : Emergency Remount R/O
[  539.328830] SysRq : Resetting

-- 
Regards/Gruss,
Boris.
