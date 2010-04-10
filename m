Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752208Ab0DJTFB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Apr 2010 15:05:01 -0400
Received: from mail.skyhub.de ([78.46.96.112]:46239 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751522Ab0DJTE7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Apr 2010 15:04:59 -0400
Date: Sat, 10 Apr 2010 20:58:39 +0200
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
Message-ID: <20100410185839.GA32035@a1.tnic>
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
References: <alpine.LFD.2.00.1004091638290.3558@i5.linux-foundation.org>
 <20100410003110.GI28964@cmpxchg.org>
 <alpine.LFD.2.00.1004091730130.3558@i5.linux-foundation.org>
 <20100410072714.GA9246@liondog.tnic>
 <20100410112639.GA24708@a1.tnic>
 <alpine.LFD.2.00.1004100821340.3558@i5.linux-foundation.org>
 <20100410163828.GA25579@a1.tnic>
 <alpine.LFD.2.00.1004100947400.3558@i5.linux-foundation.org>
 <alpine.LFD.2.00.1004101101180.3558@i5.linux-foundation.org>
 <20100410185145.GB28952@a1.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100410185145.GB28952@a1.tnic>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@alien8.de>
Date: Sat, Apr 10, 2010 at 08:51:45PM +0200

> Anyways, testing...

Nope, still b0rked. And this time is not a funny pattern but
ffffffffffffffe0 we had originally.

[  521.306972] BUG: unable to handle kernel NULL pointer dereference at (null)
[  521.307126] IP: [<ffffffff810c60b4>] page_referenced+0xee/0x1dc
[  521.307126] PGD 22d952067 PUD 2291db067 PMD 0 
[  521.307126] Oops: 0000 [#1] PREEMPT SMP 
[  521.307126] last sysfs file: /sys/power/state
[  521.307126] CPU 1 
[  521.307126] Modules linked in: powernow_k8 cpufreq_ondemand cpufreq_powersave cpufreq_userspace freq_table cpufreq_conservative binfmt_misc kvm_amd kvm ipv6 vfat fat dm_crypt dm_mod 8250_pnp 8250 pcspkr serial_core ohci_hcd edac_core k10temp
[  521.307126] 
[  521.307126] Pid: 2896, comm: hib.sh Not tainted 2.6.34-rc3-00501-gefb57c0-dirty #5 M3A78 PRO/System Product Name
[  521.307126] RIP: 0010:[<ffffffff810c60b4>]  [<ffffffff810c60b4>] page_referenced+0xee/0x1dc
[  521.307126] RSP: 0018:ffff88022bd9f8b8  EFLAGS: 00010283
[  521.307126] RAX: ffff88022af8c338 RBX: ffffea00067e2998 RCX: 0000000000000000
[  521.307126] RDX: ffff88022bd9fcf8 RSI: ffff88022af8c310 RDI: ffff88022c0c5e60
[  521.307126] RBP: ffff88022bd9f938 R08: 0000000000000002 R09: 0000000000000000
[  521.307126] R10: ffff88022b4454d8 R11: ffffffff00000012 R12: 0000000000000000
[  521.307126] R13: ffffffffffffffe0 R14: ffff88022af8c2f8 R15: ffff88022bd9fa00
[  521.307126] FS:  00007ff70fb586f0(0000) GS:ffff88000a200000(0000) knlGS:0000000000000000
[  521.307126] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  521.307126] CR2: 0000000000000000 CR3: 000000022e19c000 CR4: 00000000000006e0
[  521.307126] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  521.307126] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  521.307126] Process hib.sh (pid: 2896, threadinfo ffff88022bd9e000, task ffff88022c0c5e60)
[  521.307126] Stack:
[  521.307126]  ffff88022af8c338 00000000810c5dd3 ffff88022bd9f918 ffffffff810c5f3c
[  521.307126] <0> ffff880200000000 ffffffff00000001 ffff88022bd9ffd8 ffffea00067d2cf0
[  521.307126] <0> ffffea00067d2cf0 000000022bd9fcf8 ffffea00067d2cf0 ffffea00067e29c0
[  521.307126] Call Trace:
[  521.307126]  [<ffffffff810c5f3c>] ? try_to_unmap_anon+0xa2/0xb4
[  521.307126]  [<ffffffff810b06bc>] shrink_page_list+0x154/0x4c7
[  521.307126]  [<ffffffff81067149>] ? print_lock_contention_bug+0x1b/0xe1
[  521.307126]  [<ffffffff810af59c>] ? isolate_pages_global+0xd0/0x1fc
[  521.307126]  [<ffffffff8140fa66>] ? _raw_spin_unlock_irq+0x30/0x58
[  521.307126]  [<ffffffff810b0d8a>] shrink_inactive_list+0x35b/0x60c
[  521.307126]  [<ffffffff810b1347>] shrink_zone+0x30c/0x3d6
[  521.307126]  [<ffffffff810b1f3d>] do_try_to_free_pages+0x191/0x29a
[  521.307126]  [<ffffffff810b20db>] shrink_all_memory+0x95/0xc4
[  521.307126]  [<ffffffff810af4cc>] ? isolate_pages_global+0x0/0x1fc
[  521.307126]  [<ffffffff81079c9c>] ? count_data_pages+0x65/0x79
[  521.307126]  [<ffffffff81079f03>] hibernate_preallocate_memory+0x1aa/0x2cb
[  521.307126]  [<ffffffff8140bde4>] ? printk+0x41/0x45
[  521.307126]  [<ffffffff8107878f>] hibernation_snapshot+0x36/0x1e1
[  521.307126]  [<ffffffff81078a08>] hibernate+0xce/0x172
[  521.307126]  [<ffffffff81077775>] state_store+0x5c/0xd3
[  521.307126]  [<ffffffff8118f5eb>] kobj_attr_store+0x17/0x19
[  521.307126]  [<ffffffff8112e4a4>] sysfs_write_file+0x108/0x144
[  521.307126]  [<ffffffff810db6b3>] vfs_write+0xb2/0x153
[  521.307126]  [<ffffffff810663c9>] ? trace_hardirqs_on_caller+0x1f/0x14b
[  521.307126]  [<ffffffff810db817>] sys_write+0x4a/0x71
[  521.307126]  [<ffffffff8100221b>] system_call_fastpath+0x16/0x1b
[  521.307126] Code: 3b 56 10 73 1e 48 83 fa f2 74 18 48 8d 4d cc 4d 89 f8 48 89 df e8 11 f2 ff ff 41 01 c4 83 7d cc 00 74 19 4d 8b 6d 20 49 83 ed 20 <49> 8b 45 20 0f 18 08 49 8d 45 20 48 39 45 80 75 aa 4c 89 f7 e8 
[  521.307126] RIP  [<ffffffff810c60b4>] page_referenced+0xee/0x1dc
[  521.307126]  RSP <ffff88022bd9f8b8>
[  521.307126] CR2: 0000000000000000
[  521.320888] ---[ end trace 023d26183296e92e ]---
[  521.321033] note: hib.sh[2896] exited with preempt_count 2
[  521.321206] BUG: scheduling while atomic: hib.sh/2896/0x10000003
[  521.321355] INFO: lockdep is turned off.
[  521.321500] Modules linked in: powernow_k8 cpufreq_ondemand cpufreq_powersave cpufreq_userspace freq_table cpufreq_conservative binfmt_misc kvm_amd kvm ipv6 vfat fat dm_crypt dm_mod 8250_pnp 8250 pcspkr serial_core ohci_hcd edac_core k10temp
[  521.322884] Pid: 2896, comm: hib.sh Tainted: G      D    2.6.34-rc3-00501-gefb57c0-dirty #5
[  521.323139] Call Trace:
[  521.323288]  [<ffffffff810658df>] ? __debug_show_held_locks+0x1b/0x24
[  521.323440]  [<ffffffff8102dfac>] __schedule_bug+0x72/0x77
[  521.323587]  [<ffffffff8140c1f8>] schedule+0xe3/0x7ff
[  521.323735]  [<ffffffff81030ecb>] __cond_resched+0x18/0x24
[  521.323882]  [<ffffffff8140c9e1>] _cond_resched+0x2c/0x37
[  521.324029]  [<ffffffff810bcef1>] unmap_vmas+0x719/0x911
[  521.324207]  [<ffffffff810c1781>] exit_mmap+0x102/0x1e4
[  521.324356]  [<ffffffff810c16e8>] ? exit_mmap+0x69/0x1e4
[  521.324503]  [<ffffffff810368bc>] mmput+0x48/0xb9
[  521.324651]  [<ffffffff8103ad90>] exit_mm+0x110/0x11d
[  521.324798]  [<ffffffff8103c9e6>] do_exit+0x1c5/0x6e5
[  521.324945]  [<ffffffff81039e2f>] ? kmsg_dump+0x13b/0x155
[  521.325093]  [<ffffffff8100616b>] ? oops_end+0x47/0x93
[  521.325244]  [<ffffffff810061b2>] oops_end+0x8e/0x93
[  521.325396]  [<ffffffff8101f3e5>] no_context+0x1fc/0x20b
[  521.325544]  [<ffffffff8101f580>] __bad_area_nosemaphore+0x18c/0x1af
[  521.325691]  [<ffffffff8101f7bb>] ? do_page_fault+0xa8/0x32d
[  521.325839]  [<ffffffff8101f5b6>] bad_area_nosemaphore+0x13/0x15
[  521.325987]  [<ffffffff8101f886>] do_page_fault+0x173/0x32d
[  521.326138]  [<ffffffff81082b84>] ? __call_rcu+0x11d/0x130
[  521.326289]  [<ffffffff814103e3>] ? error_sti+0x5/0x6
[  521.326437]  [<ffffffff81065387>] ? trace_hardirqs_off_caller+0x1f/0xa9
[  521.326586]  [<ffffffff8140ed0b>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[  521.326737]  [<ffffffff814101ff>] page_fault+0x1f/0x30
[  521.326885]  [<ffffffff810c60b4>] ? page_referenced+0xee/0x1dc
[  521.327034]  [<ffffffff810c6046>] ? page_referenced+0x80/0x1dc
[  521.327185]  [<ffffffff810c5f3c>] ? try_to_unmap_anon+0xa2/0xb4
[  521.327336]  [<ffffffff810b06bc>] shrink_page_list+0x154/0x4c7
[  521.327483]  [<ffffffff81067149>] ? print_lock_contention_bug+0x1b/0xe1
[  521.327632]  [<ffffffff810af59c>] ? isolate_pages_global+0xd0/0x1fc
[  521.327780]  [<ffffffff8140fa66>] ? _raw_spin_unlock_irq+0x30/0x58
[  521.327928]  [<ffffffff810b0d8a>] shrink_inactive_list+0x35b/0x60c
[  521.328079]  [<ffffffff810b1347>] shrink_zone+0x30c/0x3d6
[  521.328232]  [<ffffffff810b1f3d>] do_try_to_free_pages+0x191/0x29a
[  521.328387]  [<ffffffff810b20db>] shrink_all_memory+0x95/0xc4
[  521.328535]  [<ffffffff810af4cc>] ? isolate_pages_global+0x0/0x1fc
[  521.328683]  [<ffffffff81079c9c>] ? count_data_pages+0x65/0x79
[  521.328831]  [<ffffffff81079f03>] hibernate_preallocate_memory+0x1aa/0x2cb
[  521.328979]  [<ffffffff8140bde4>] ? printk+0x41/0x45
[  521.329130]  [<ffffffff8107878f>] hibernation_snapshot+0x36/0x1e1
[  521.329283]  [<ffffffff81078a08>] hibernate+0xce/0x172
[  521.329432]  [<ffffffff81077775>] state_store+0x5c/0xd3
[  521.329580]  [<ffffffff8118f5eb>] kobj_attr_store+0x17/0x19
[  521.329727]  [<ffffffff8112e4a4>] sysfs_write_file+0x108/0x144
[  521.329875]  [<ffffffff810db6b3>] vfs_write+0xb2/0x153
[  521.330022]  [<ffffffff810663c9>] ? trace_hardirqs_on_caller+0x1f/0x14b
[  521.330174]  [<ffffffff810db817>] sys_write+0x4a/0x71
[  521.330326]  [<ffffffff8100221b>] system_call_fastpath+0x16/0x1b

-- 
Regards/Gruss,
Boris.
