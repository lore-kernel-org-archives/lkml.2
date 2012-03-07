Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899Ab2CGKcq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 05:32:46 -0500
Received: from mail.skyhub.de ([78.46.96.112]:50774 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751415Ab2CGKco (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 05:32:44 -0500
Date: Wed, 7 Mar 2012 11:32:27 +0100
From: Borislav Petkov <bp@alien8.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: Linux 3.3-rc6
Message-ID: <20120307103227.GA5237@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
References: <CA+55aFxHj-7fQ0+yJv4WaeKCGha5+a+J=gtHi6m6EWg58q7Ljw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+55aFxHj-7fQ0+yJv4WaeKCGha5+a+J=gtHi6m6EWg58q7Ljw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 03, 2012 at 06:57:31PM -0800, Linus Torvalds wrote:
> Hmm. Nothing much to say about this -rc: it really is all small fixes
> and cleanups.
> 
> In fact, it's been calm enough that this *might* be the last -rc, but
> we'll see how the upcoming week goes. If it stays calm (and hopefully
> even calms down some more), there doesn't seem to be any major reason
> to drag out the release cycle any more.
> 
> But hey, that does imply that people who have seen regressions should
> re-check them and holler loudly if they are still seeing problems.

Just a couple of warnings, just saw them when booted
3.3.0-rc6-00104-gf3969bf78f14 yesterday on this box. I'm ccing Paul for
the first two, there's a fix already for the last one, I'm sending it to
Ingo.

Thanks.

...

[    0.027998] Performance Events: AMD PMU driver.
[    0.027998] ... version:                0
[    0.027998] ... bit width:              48
[    0.027998] ... generic registers:      4
[    0.027998] ... value mask:             0000ffffffffffff
[    0.027998] ... max period:             00007fffffffffff
[    0.027998] ... fixed-purpose events:   0
[    0.028000] ... event mask:             000000000000000f
[    0.028240] System has AMD C1E enabled
[    0.028257] ------------[ cut here ]------------
[    0.028263] WARNING: at include/linux/rcupdate.h:242 __atomic_notifier_call_chain+0x4d/0xe9()
[    0.028265] Hardware name: System Product Name
[    0.028266] Modules linked in:
[    0.028269] Pid: 0, comm: swapper/0 Not tainted 3.3.0-rc6-00104-gf3969bf78f14 #1
[    0.028270] Call Trace:
[    0.028274]  [<ffffffff81029d88>] warn_slowpath_common+0x83/0x9b
[    0.028277]  [<ffffffff81029dba>] warn_slowpath_null+0x1a/0x1c
[    0.028280]  [<ffffffff8104ff24>] __atomic_notifier_call_chain+0x4d/0xe9
[    0.028282]  [<ffffffff8104ffd4>] atomic_notifier_call_chain+0x14/0x16
[    0.028285]  [<ffffffff8122bfbd>] notify_write+0x29/0x2b
[    0.028288]  [<ffffffff8122eeff>] vt_console_print+0x243/0x2fe
[    0.028291]  [<ffffffff8102a029>] __call_console_drivers+0x77/0x89
[    0.028294]  [<ffffffff8102a212>] _call_console_drivers+0x5c/0x60
[    0.028296]  [<ffffffff8102a58a>] console_unlock+0x118/0x212
[    0.028298]  [<ffffffff8102ab3e>] vprintk+0x3be/0x403
[    0.028302]  [<ffffffff8108d13e>] ? rcu_idle_enter_common.isra.31+0x336/0x37b
[    0.028305]  [<ffffffff813df15e>] printk+0x41/0x43
[    0.028307]  [<ffffffff8108d1c8>] ? rcu_idle_enter+0x45/0x53
[    0.028309]  [<ffffffff8108d1c8>] ? rcu_idle_enter+0x45/0x53
[    0.028312]  [<ffffffff81009d77>] amd_e400_idle+0x6c/0xe7
[    0.028315]  [<ffffffff81000801>] cpu_idle+0x6c/0xc8
[    0.028318]  [<ffffffff813cce40>] rest_init+0x124/0x12b
[    0.028319]  [<ffffffff813ccd86>] ? rest_init+0x6a/0x12b
[    0.028323]  [<ffffffff81857a18>] start_kernel+0x2d5/0x2e2
[    0.028325]  [<ffffffff8185726e>] x86_64_start_reservations+0x7e/0x82
[    0.028327]  [<ffffffff81857362>] x86_64_start_kernel+0xf0/0xf7
[    0.028333] ---[ end trace 4eaa2a86a8e2da22 ]---
[    0.028334] ------------[ cut here ]------------
[    0.028336] WARNING: at include/linux/rcupdate.h:248 __atomic_notifier_call_chain+0xb4/0xe9()
[    0.028337] Hardware name: System Product Name
[    0.028338] Modules linked in:
[    0.028341] Pid: 0, comm: swapper/0 Tainted: G        W    3.3.0-rc6-00104-gf3969bf78f14 #1
[    0.028342] Call Trace:
[    0.028344]  [<ffffffff81029d88>] warn_slowpath_common+0x83/0x9b
[    0.028347]  [<ffffffff81029dba>] warn_slowpath_null+0x1a/0x1c
[    0.028349]  [<ffffffff8104ff8b>] __atomic_notifier_call_chain+0xb4/0xe9
[    0.028352]  [<ffffffff8104ff2b>] ? __atomic_notifier_call_chain+0x54/0xe9
[    0.028354]  [<ffffffff8104ffd4>] atomic_notifier_call_chain+0x14/0x16
[    0.028356]  [<ffffffff8122bfbd>] notify_write+0x29/0x2b
[    0.028359]  [<ffffffff8122eeff>] vt_console_print+0x243/0x2fe
[    0.028361]  [<ffffffff8102a029>] __call_console_drivers+0x77/0x89
[    0.028364]  [<ffffffff8102a212>] _call_console_drivers+0x5c/0x60
[    0.028367]  [<ffffffff8102a58a>] console_unlock+0x118/0x212
[    0.028369]  [<ffffffff8102ab3e>] vprintk+0x3be/0x403
[    0.028371]  [<ffffffff8108d13e>] ? rcu_idle_enter_common.isra.31+0x336/0x37b
[    0.028374]  [<ffffffff813df15e>] printk+0x41/0x43
[    0.028376]  [<ffffffff8108d1c8>] ? rcu_idle_enter+0x45/0x53
[    0.028378]  [<ffffffff8108d1c8>] ? rcu_idle_enter+0x45/0x53
[    0.028380]  [<ffffffff81009d77>] amd_e400_idle+0x6c/0xe7
[    0.028382]  [<ffffffff81000801>] cpu_idle+0x6c/0xc8
[    0.028384]  [<ffffffff813cce40>] rest_init+0x124/0x12b
[    0.028386]  [<ffffffff813ccd86>] ? rest_init+0x6a/0x12b
[    0.028388]  [<ffffffff81857a18>] start_kernel+0x2d5/0x2e2
[    0.028391]  [<ffffffff8185726e>] x86_64_start_reservations+0x7e/0x82
[    0.028393]  [<ffffffff81857362>] x86_64_start_kernel+0xf0/0xf7
[    0.028394] ---[ end trace 4eaa2a86a8e2da23 ]---
[    0.028998] Switch to broadcast mode on CPU0
[    0.035099] MCE: In-kernel MCE decoding enabled.
[    0.036006] 
[    0.036144] ===============================
[    0.036283] [ INFO: suspicious RCU usage. ]
[    0.036425] 3.3.0-rc6-00104-gf3969bf78f14 #1 Tainted: G        W   
[    0.036568] -------------------------------
[    0.036708] arch/x86/kernel/cpu/mcheck/mce.c:194 suspicious rcu_dereference_index_check() usage!
[    0.036998] 
[    0.036999] other info that might help us debug this:
[    0.037000] 
[    0.037412] 
[    0.037412] rcu_scheduler_active = 1, debug_locks = 0
[    0.037689] no locks held by swapper/0/1.
[    0.037828] 
[    0.037829] stack backtrace:
[    0.037999] Pid: 1, comm: swapper/0 Tainted: G        W    3.3.0-rc6-00104-gf3969bf78f14 #1
[    0.038245] Call Trace:
[    0.039003]  [<ffffffff810723a1>] lockdep_rcu_suspicious+0xd8/0xe1
[    0.039148]  [<ffffffff81877cc3>] ? thermal_init+0x8b/0x8b
[    0.039292]  [<ffffffff81014aa2>] mce_register_decode_chain+0xa4/0x179
[    0.039435]  [<ffffffff81877cc3>] ? thermal_init+0x8b/0x8b
[    0.039578]  [<ffffffff81877e16>] mce_amd_init+0x153/0x157
[    0.039721]  [<ffffffff8100020f>] do_one_initcall+0x7f/0x134
[    0.039864]  [<ffffffff81857a7e>] kernel_init+0x59/0x114
[    0.040000]  [<ffffffff813e99a4>] kernel_thread_helper+0x4/0x10
[    0.040144]  [<ffffffff8105a893>] ? local_clock+0xf/0x3b
[    0.040286]  [<ffffffff8105446e>] ? finish_task_switch+0x88/0xee
[    0.040429]  [<ffffffff813e7a84>] ? _raw_spin_unlock_irq+0x38/0x55
[    0.040572]  [<ffffffff813e7ee1>] ? retint_restore_args+0xe/0xe
[    0.040715]  [<ffffffff81857a25>] ? start_kernel+0x2e2/0x2e2
[    0.040857]  [<ffffffff813e99a0>] ? gs_change+0xb/0xb
[    0.045018] lockdep: fixing up alternatives.
[    0.048040] Booting Node   0, Processors  #1
[    0.048118] smpboot cpu 1: start_ip = 9a000
[    0.061016] Switch to broadcast mode on CPU1
[    0.065027] lockdep: fixing up alternatives.
[    0.066014]  #2
[    0.066051] smpboot cpu 2: start_ip = 9a000
[    0.078017] Switch to broadcast mode on CPU2
[    0.082029] lockdep: fixing up alternatives.
[    0.083016]  #3 Ok.
[    0.083154] smpboot cpu 3: start_ip = 9a000
[    0.095022] Brought up 4 CPUs
...

-- 
Regards/Gruss,
Boris.
