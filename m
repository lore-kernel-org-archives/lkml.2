Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753813Ab1KOIlM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 03:41:12 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37635 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753578Ab1KOIlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 03:41:10 -0500
Date: Tue, 15 Nov 2011 16:40:59 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [ANNOUNCE] 3.2-rc1-rt2
Message-ID: <20111115084059.GA23250@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <alpine.LFD.2.02.1111150050590.4902@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1111150050590.4902@ionos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 15, 2011 at 02:15:52AM +0100, Thomas Gleixner wrote:
> Dear RT Folks,
> 
> I'm pleased to announce the 3.2-rc1-rt2 release.
> 
> Changes vs. 3.2-rc1-rt2:
> 
>   * Add missing softirq export (John Kacur)
> 
>   * Fix rcu macro substitution (John Kacur)
> 
>   * Fix device mapper BUG_ON (Reported by Luis Claudio)
> 
>   * Fix x86 aesni (crypto) preemption problem (Peter Zijlstra,
>     reported by Carsten Emde)
> 
>   * Fix UP (tiny) RCU build issues (Reported by Tim Sanders)

Got below warning:

[    8.459702] BUG: sleeping function called from invalid context at linux/kernel/rtmutex.c:645
[    8.459705] in_atomic(): 1, irqs_disabled(): 0, pid: 1, name: swapper/0
[    8.459707] 1 lock held by swapper/0/1:
[    8.459708]  #0:  (&sig->cred_guard_mutex){+.+.+.}, at: [<ffffffff81154c45>] prepare_bprm_creds+0x35/0x80
[    8.459717] Pid: 1, comm: swapper/0 Not tainted 3.2.0-rc1-rt2-11311-g3c4c0e7-dirty #10
[    8.459718] Call Trace:
[    8.459724]  [<ffffffff81040c4e>] __might_sleep+0x12e/0x1e0
[    8.459730]  [<ffffffff815f4d74>] rt_spin_lock+0x24/0x60
[    8.459735]  [<ffffffff8114506e>] memcg_check_events+0x11e/0x230
[    8.459739]  [<ffffffff81146c5a>] T.1144+0x8a/0xf0
[    8.459743]  [<ffffffff81146d16>] __mem_cgroup_commit_charge_lrucare+0x56/0x180
[    8.459747]  [<ffffffff810430c9>] ? sub_preempt_count+0xa9/0xe0
[    8.459751]  [<ffffffff81147d08>] mem_cgroup_cache_charge+0xd8/0xe0
[    8.459756]  [<ffffffff81103a49>] add_to_page_cache_locked+0x49/0x100
[    8.459760]  [<ffffffff8110344f>] ? find_get_page+0xdf/0x1a0
[    8.459764]  [<ffffffff81103b22>] add_to_page_cache_lru+0x22/0x50
[    8.459767]  [<ffffffff81103ca5>] do_read_cache_page+0x75/0x1a0
[    8.459774]  [<ffffffff812695f0>] ? nfs_follow_link+0xc0/0xc0
[    8.459777]  [<ffffffff81103e1c>] read_cache_page_async+0x1c/0x20
[    8.459781]  [<ffffffff81103e2e>] read_cache_page+0xe/0x20
[    8.459785]  [<ffffffff81269589>] nfs_follow_link+0x59/0xc0
[    8.459789]  [<ffffffff8115de07>] path_openat+0x2a7/0x470
[    8.459793]  [<ffffffff8115e0e9>] do_filp_open+0x49/0xa0
[    8.459798]  [<ffffffff81155b22>] open_exec+0x32/0xf0
[    8.459803]  [<ffffffff811a3e0b>] load_elf_binary+0x85b/0x1d30
[    8.459810]  [<ffffffff81096d55>] ? __lock_acquire+0x4f5/0xbf0
[    8.459816]  [<ffffffff8100a819>] ? native_sched_clock+0x29/0x80
[    8.459821]  [<ffffffff8108429f>] ? local_clock+0x4f/0x60
[    8.459824]  [<ffffffff815f4658>] ? rt_spin_lock_slowunlock+0x78/0x80
[    8.459828]  [<ffffffff81091a39>] ? trace_hardirqs_off_caller+0x29/0x120
[    8.459832]  [<ffffffff8109119e>] ? put_lock_stats+0xe/0x40
[    8.459836]  [<ffffffff815f4658>] ? rt_spin_lock_slowunlock+0x78/0x80
[    8.459840]  [<ffffffff811a35b0>] ? elf_map+0x1d0/0x1d0
[    8.459843]  [<ffffffff810430c9>] ? sub_preempt_count+0xa9/0xe0
[    8.459847]  [<ffffffff811a35b0>] ? elf_map+0x1d0/0x1d0
[    8.459850]  [<ffffffff81154748>] search_binary_handler+0x1c8/0x4b0
[    8.459854]  [<ffffffff811545d7>] ? search_binary_handler+0x57/0x4b0
[    8.459858]  [<ffffffff81156876>] do_execve_common+0x276/0x330
[    8.459862]  [<ffffffff811569ba>] do_execve+0x3a/0x40
[    8.459866]  [<ffffffff8100bdca>] sys_execve+0x4a/0x80
[    8.459871]  [<ffffffff815f85e8>] kernel_execve+0x68/0xd0
[    8.459877]  [<ffffffff81000333>] ? run_init_process+0x23/0x30
[    8.459881]  [<ffffffff81000398>] init_post+0x58/0xd0
[    8.459888]  [<ffffffff81b5e6bd>] kernel_init+0x156/0x160
[    8.459892]  [<ffffffff815f8574>] kernel_thread_helper+0x4/0x10
[    8.459896]  [<ffffffff810423bc>] ? finish_task_switch+0x8c/0x110
[    8.459900]  [<ffffffff815f5bab>] ? _raw_spin_unlock_irq+0x3b/0x70
[    8.459903]  [<ffffffff815f5f61>] ? retint_restore_args+0xe/0xe
[    8.459907]  [<ffffffff81b5e567>] ? parse_early_options+0x20/0x20
[    8.459911]  [<ffffffff815f8570>] ? gs_change+0xb/0xb

Thanks,
Yong
