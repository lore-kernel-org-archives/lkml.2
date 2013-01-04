Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754269Ab3ADEcC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 23:32:02 -0500
Received: from trent.utfs.org ([94.185.90.103]:60358 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753949Ab3ADEb6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 23:31:58 -0500
Date: Thu, 3 Jan 2013 20:31:43 -0800 (PST)
From: Christian Kujau <lists@nerdbynature.de>
To: Maciej Rutecki <maciej.rutecki@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>, Cong Wang <xiyou.wangcong@gmail.com>,
        linuxppc-dev@lists.ozlabs.org, zhong@linux.vnet.ibm.com
Subject: Re: [REGRESSION][3.8.-rc1][ INFO: possible circular locking dependency
 detected ]
In-Reply-To: <alpine.DEB.2.01.1212231321560.7378@trent.utfs.org>
Message-ID: <alpine.DEB.2.01.1301032031020.7378@trent.utfs.org>
References: <201212221628.26640.maciej.rutecki@gmail.com> <alpine.DEB.2.01.1212231321560.7378@trent.utfs.org>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AV-Checked: ClamAV using ClamSMTP (127.0.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 23 Dec 2012 at 13:34, Christian Kujau wrote:

> On Sat, 22 Dec 2012 at 16:28, Maciej Rutecki wrote:
> > Got during suspend to disk:
> 
> I got a similar message on a powerpc G4 system, right after bootup (no 
> suspend involved):
> 
>     http://nerdbynature.de/bits/3.8.0-rc1/

FWIW, this is still present with 3.8.0-rc2.

C.

> [   97.803049] ======================================================
> [   97.803051] [ INFO: possible circular locking dependency detected ]
> [   97.803059] 3.8.0-rc1-dirty #2 Not tainted
> [   97.803060] -------------------------------------------------------
> [   97.803066] kworker/0:1/235 is trying to acquire lock:
> [   97.803097]  ((fb_notifier_list).rwsem){.+.+.+}, at: [<c00606a0>] __blocking_notifier_call_chain+0x44/0x88
> [   97.803099] 
> [   97.803099] but task is already holding lock:
> [   97.803110]  (console_lock){+.+.+.}, at: [<c03b9fd0>] console_callback+0x20/0x194
> [   97.803112] 
> [   97.803112] which lock already depends on the new lock.
> 
> ...and on it goes. Please see the URL above for the whole dmesg and 
> .config.
> 
> @Li Zhong: I have applied your fix for the "MAX_STACK_TRACE_ENTRIES too 
>            low" warning[0] to 3.8-rc1 (hence the -dirty flag), but in the 
>            backtrace "ret_from_kernel_thread" shows up again. FWIW, your
>            patch helped to make the "MAX_STACK_TRACE_ENTRIES too low" 
>            warning go away in 3.7.0-rc7 and it did not re-appear ever 
>            since.
> 
> Thanks,
> Christian.
> 
> [0] http://lkml.indiana.edu/hypermail/linux/kernel/1211.3/01917.html
> 
> > [  269.784867] [ INFO: possible circular locking dependency detected ]
> > [  269.784869] 3.8.0-rc1 #1 Not tainted
> > [  269.784870] -------------------------------------------------------
> > [  269.784871] kworker/u:3/56 is trying to acquire lock:
> > [  269.784878]  ((fb_notifier_list).rwsem){.+.+.+}, at: [<ffffffff81062a1d>] 
> > __blocking_notifier_call_chain+0x49/0x80
> > [  269.784879] 
> > [  269.784879] but task is already holding lock:
> > [  269.784884]  (console_lock){+.+.+.}, at: [<ffffffff812ee4ce>] 
> > i915_drm_freeze+0x9e/0xbb
> > [  269.784884] 
> > [  269.784884] which lock already depends on the new lock.
> > [  269.784884] 
> > [  269.784885] 
> > [  269.784885] the existing dependency chain (in reverse order) is:
> > [  269.784887] 
> > [  269.784887] -> #1 (console_lock){+.+.+.}:
> > [  269.784890]        [<ffffffff810890e4>] lock_acquire+0x95/0x105
> > [  269.784893]        [<ffffffff810405a1>] console_lock+0x59/0x5b
> > [  269.784897]        [<ffffffff812ba125>] register_con_driver+0x36/0x128
> > [  269.784899]        [<ffffffff812bb27e>] take_over_console+0x1e/0x45
> > [  269.784903]        [<ffffffff81257a04>] fbcon_takeover+0x56/0x98
> > [  269.784906]        [<ffffffff8125b857>] fbcon_event_notify+0x2c1/0x5ea
> > [  269.784909]        [<ffffffff8149a211>] notifier_call_chain+0x67/0x92
> > [  269.784911]        [<ffffffff81062a33>] __blocking_notifier_call_chain+0x5f/0x80
> > [  269.784912]        [<ffffffff81062a63>] blocking_notifier_call_chain+0xf/0x11
> > [  269.784915]        [<ffffffff8124e85e>] fb_notifier_call_chain+0x16/0x18
> > [  269.784917]        [<ffffffff812505d7>] register_framebuffer+0x20a/0x26e
> > [  269.784920]        [<ffffffff812d3ca0>] 
> > drm_fb_helper_single_fb_probe+0x1ce/0x297
> > [  269.784922]        [<ffffffff812d3f40>] drm_fb_helper_initial_config+0x1d7/0x1ef
> > [  269.784924]        [<ffffffff8132cee2>] intel_fbdev_init+0x6f/0x82
> > [  269.784927]        [<ffffffff812f22f6>] i915_driver_load+0xa9e/0xc78
> > [  269.784929]        [<ffffffff812e020c>] drm_get_pci_dev+0x165/0x26d
> > [  269.784931]        [<ffffffff812ee8da>] i915_pci_probe+0x60/0x69
> > [  269.784933]        [<ffffffff8123fe8e>] local_pci_probe+0x39/0x61
> > [  269.784935]        [<ffffffff812400f5>] pci_device_probe+0xba/0xe0
> > [  269.784938]        [<ffffffff8133d3b6>] driver_probe_device+0x99/0x1c4
> > [  269.784940]        [<ffffffff8133d52f>] __driver_attach+0x4e/0x6f
> > [  269.784942]        [<ffffffff8133bae1>] bus_for_each_dev+0x52/0x84
> > [  269.784944]        [<ffffffff8133cec6>] driver_attach+0x19/0x1b
> > [  269.784946]        [<ffffffff8133cb65>] bus_add_driver+0xdf/0x203
> > [  269.784948]        [<ffffffff8133dad3>] driver_register+0x8e/0x114
> > [  269.784952]        [<ffffffff8123f581>] __pci_register_driver+0x5d/0x62
> > [  269.784953]        [<ffffffff812e0395>] drm_pci_init+0x81/0xe6
> > [  269.784957]        [<ffffffff81af7612>] i915_init+0x66/0x68
> > [  269.784959]        [<ffffffff810020b4>] do_one_initcall+0x7a/0x136
> > [  269.784962]        [<ffffffff8147ceaa>] kernel_init+0x141/0x296
> > [  269.784964]        [<ffffffff8149c7bc>] ret_from_fork+0x7c/0xb0
> > [  269.784966] 
> > [  269.784966] -> #0 ((fb_notifier_list).rwsem){.+.+.+}:
> > [  269.784967]        [<ffffffff81088955>] __lock_acquire+0xa7e/0xddd
> > [  269.784969]        [<ffffffff810890e4>] lock_acquire+0x95/0x105
> > [  269.784971]        [<ffffffff81495092>] down_read+0x34/0x43
> > [  269.784973]        [<ffffffff81062a1d>] __blocking_notifier_call_chain+0x49/0x80
> > [  269.784975]        [<ffffffff81062a63>] blocking_notifier_call_chain+0xf/0x11
> > [  269.784977]        [<ffffffff8124e85e>] fb_notifier_call_chain+0x16/0x18
> > [  269.784979]        [<ffffffff8124ec47>] fb_set_suspend+0x22/0x4d
> > [  269.784981]        [<ffffffff8132cfe3>] intel_fbdev_set_suspend+0x20/0x22
> > [  269.784983]        [<ffffffff812ee4db>] i915_drm_freeze+0xab/0xbb
> > [  269.784985]        [<ffffffff812eea82>] i915_pm_freeze+0x3d/0x41
> > [  269.784987]        [<ffffffff8123f759>] pci_pm_freeze+0x65/0x8d
> > [  269.784990]        [<ffffffff81342f20>] dpm_run_callback.isra.3+0x27/0x56
> > [  269.784993]        [<ffffffff81343085>] __device_suspend+0x136/0x1b1
> > [  269.784995]        [<ffffffff8134311a>] async_suspend+0x1a/0x58
> > [  269.784997]        [<ffffffff81063a6b>] async_run_entry_fn+0xa4/0x17c
> > [  269.785000]        [<ffffffff81058df2>] process_one_work+0x1cf/0x38e
> > [  269.785002]        [<ffffffff81059290>] worker_thread+0x12e/0x1cc
> > [  269.785004]        [<ffffffff8105d416>] kthread+0xac/0xb4
> > [  269.785006]        [<ffffffff8149c7bc>] ret_from_fork+0x7c/0xb0
> > [  269.785006] 
> > [  269.785006] other info that might help us debug this:
> > [  269.785006] 
> > [  269.785007]  Possible unsafe locking scenario:
> > [  269.785007] 
> > [  269.785008]        CPU0                    CPU1
> > [  269.785008]        ----                    ----
> > [  269.785009]   lock(console_lock);
> > [  269.785010]                                lock((fb_notifier_list).rwsem);
> > [  269.785012]                                lock(console_lock);
> > [  269.785013]   lock((fb_notifier_list).rwsem);
> > [  269.785013] 
> > [  269.785013]  *** DEADLOCK ***
> > [  269.785013] 
> > [  269.785014] 4 locks held by kworker/u:3/56:
> > [  269.785018]  #0:  (events_unbound){.+.+.+}, at: [<ffffffff81058d77>] 
> > process_one_work+0x154/0x38e
> > [  269.785021]  #1:  ((&entry->work)){+.+.+.}, at: [<ffffffff81058d77>] 
> > process_one_work+0x154/0x38e
> > [  269.785024]  #2:  (&__lockdep_no_validate__){......}, at: [<ffffffff81342d85>] 
> > device_lock+0xf/0x11
> > [  269.785027]  #3:  (console_lock){+.+.+.}, at: [<ffffffff812ee4ce>] 
> > i915_drm_freeze+0x9e/0xbb
> > [  269.785028] 
> > [  269.785028] stack backtrace:
> > [  269.785029] Pid: 56, comm: kworker/u:3 Not tainted 3.8.0-rc1 #1
> > [  269.785030] Call Trace:
> > [  269.785035]  [<ffffffff8148fcb5>] print_circular_bug+0x1f8/0x209
> > [  269.785036]  [<ffffffff81088955>] __lock_acquire+0xa7e/0xddd
> > [  269.785038]  [<ffffffff810890e4>] lock_acquire+0x95/0x105
> > [  269.785040]  [<ffffffff81062a1d>] ? __blocking_notifier_call_chain+0x49/0x80
> > [  269.785042]  [<ffffffff81495092>] down_read+0x34/0x43
> > [  269.785044]  [<ffffffff81062a1d>] ? __blocking_notifier_call_chain+0x49/0x80
> > [  269.785046]  [<ffffffff81062a1d>] __blocking_notifier_call_chain+0x49/0x80
> > [  269.785047]  [<ffffffff81062a63>] blocking_notifier_call_chain+0xf/0x11
> > [  269.785050]  [<ffffffff8124e85e>] fb_notifier_call_chain+0x16/0x18
> > [  269.785052]  [<ffffffff8124ec47>] fb_set_suspend+0x22/0x4d
> > [  269.785054]  [<ffffffff8132cfe3>] intel_fbdev_set_suspend+0x20/0x22
> > [  269.785055]  [<ffffffff812ee4db>] i915_drm_freeze+0xab/0xbb
> > [  269.785057]  [<ffffffff812eea82>] i915_pm_freeze+0x3d/0x41
> > [  269.785060]  [<ffffffff8123f759>] pci_pm_freeze+0x65/0x8d
> > [  269.785062]  [<ffffffff8123f6f4>] ? pci_pm_poweroff+0x9c/0x9c
> > [  269.785064]  [<ffffffff81342f20>] dpm_run_callback.isra.3+0x27/0x56
> > [  269.785066]  [<ffffffff81343085>] __device_suspend+0x136/0x1b1
> > [  269.785068]  [<ffffffff81089563>] ? trace_hardirqs_on_caller+0x117/0x173
> > [  269.785070]  [<ffffffff8134311a>] async_suspend+0x1a/0x58
> > [  269.785072]  [<ffffffff81063a6b>] async_run_entry_fn+0xa4/0x17c
> > [  269.785074]  [<ffffffff81058df2>] process_one_work+0x1cf/0x38e
> > [  269.785076]  [<ffffffff81058d77>] ? process_one_work+0x154/0x38e
> > [  269.785078]  [<ffffffff810639c7>] ? async_schedule+0x12/0x12
> > [  269.785080]  [<ffffffff8105679f>] ? spin_lock_irq+0x9/0xb
> > [  269.785082]  [<ffffffff81059290>] worker_thread+0x12e/0x1cc
> > [  269.785084]  [<ffffffff81059162>] ? rescuer_thread+0x187/0x187
> > [  269.785085]  [<ffffffff8105d416>] kthread+0xac/0xb4
> > [  269.785088]  [<ffffffff8105d36a>] ? __kthread_parkme+0x60/0x60
> > [  269.785090]  [<ffffffff8149c7bc>] ret_from_fork+0x7c/0xb0
> > [  269.785091]  [<ffffffff8105d36a>] ? __kthread_parkme+0x60/0x60
> > 
> > 
> > Config:
> > http://mrutecki.pl/download/kernel/3.8.0-rc1/s2disk/config-3.8.0-rc1
> > 
> > dmesg:
> > http://mrutecki.pl/download/kernel/3.8.0-rc1/s2disk/dmesg-3.8.0-rc1.txt
> > 
> > 
> > Found similar report:
> > http://marc.info/?l=linux-kernel&m=135546308908700&w=2
> > 
> > Regards
> > 
> > -- 
> > Maciej Rutecki
> > http://www.mrutecki.pl
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> > 
> 
> -- 
> BOFH excuse #435:
> 
> Internet shut down due to maintenance
> 

-- 
BOFH excuse #262:

Our POP server was kidnapped by a weasel.
