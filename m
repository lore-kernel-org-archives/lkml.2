Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751785Ab0KDOQO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 10:16:14 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52900 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350Ab0KDOQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 10:16:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=rkkxZ4R2s8JXt/8mXx33OgiRyFf11nTkBagfER8z2cw9EYYs5O96Hsu4eQOHVBaAI/
         PcbKVBjqEvQ/qzM0rg5U4H79KMej3/p2broORP+ioevIYOdUNHeeIBZdbfVCdbs96UgM
         AJTKf241Ouwl5deQMXEKqsZS8N78BE4gttBzw=
Date: Thu, 4 Nov 2010 22:15:58 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: akpm@linux-foundation.org
Cc: mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: mmotm 2010-11-03-12-17 uploaded
Message-ID: <20101104141557.GA2472@darkstar>
References: <201011031919.oA3JJgkF008936@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201011031919.oA3JJgkF008936@imap1.linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 03, 2010 at 12:18:16PM -0700, akpm@linux-foundation.org wrote:
> The mm-of-the-moment snapshot 2010-11-03-12-17 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/
> 
> and will soon be available at
> 
>    git://zen-kernel.org/kernel/mmotm.git
> 
> It contains the following patches against 2.6.36:
> 

While booting I got:
[    0.766899] =================================
[    0.767135] [ INFO: inconsistent lock state ]
[    0.767255] 2.6.36-mm1 #1
[    0.767371] ---------------------------------
[    0.767490] inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-W} usage.
[    0.767613] kswapd0/544 [HC0[0]:SC0[0]:HE1:SE1] takes:
[    0.767733]  (cpu_hotplug.lock){+.+.?.}, at: [<ffffffff81041cbc>] get_online_cpus+0x3c/0x50
[    0.768082] {RECLAIM_FS-ON-W} state was registered at:
[    0.768203]   [<ffffffff8106c865>] mark_held_locks+0x4d/0x6b
[    0.768369]   [<ffffffff8106c935>] lockdep_trace_alloc+0xb2/0xd7
[    0.768534]   [<ffffffff810f721e>] kmem_cache_alloc+0x2a/0x126
[    0.768701]   [<ffffffff81247ae9>] idr_pre_get+0x2d/0x75
[    0.768867]   [<ffffffff81247b42>] ida_pre_get+0x11/0x73
[    0.769032]   [<ffffffff81056344>] create_worker+0x4a/0x153
[    0.769199]   [<ffffffff814ecbd6>] workqueue_cpu_callback+0xb9/0x205
[    0.769366]   [<ffffffff8150c9bb>] notifier_call_chain+0x33/0x5b
[    0.769532]   [<ffffffff810603fb>] __raw_notifier_call_chain+0x9/0xb
[    0.769697]   [<ffffffff81503af6>] _cpu_up+0x75/0x11a
[    0.769862]   [<ffffffff81503bf0>] cpu_up+0x55/0x6a
[    0.770008]   [<ffffffff81ad1655>] kernel_init+0xc9/0x1e2
[    0.770008]   [<ffffffff81003a64>] kernel_thread_helper+0x4/0x10
[    0.770008] irq event stamp: 27
[    0.770008] hardirqs last  enabled at (27): [<ffffffff8150923a>] _raw_spin_unlock_irqrestore+0x46/0x55
[    0.770008] hardirqs last disabled at (26): [<ffffffff81508c8b>] _raw_spin_lock_irqsave+0x24/0x58
[    0.770008] softirqs last  enabled at (20): [<ffffffff8104d897>] del_timer_sync+0x50/0x8f
[    0.770008] softirqs last disabled at (18): [<ffffffff8104d85f>] del_timer_sync+0x18/0x8f
[    0.770008] 
[    0.770008] other info that might help us debug this:
[    0.770008] no locks held by kswapd0/544.
[    0.770008] 
[    0.770008] stack backtrace:
[    0.770008] Pid: 544, comm: kswapd0 Not tainted 2.6.36-mm1 #1
[    0.770008] Call Trace:
[    0.770008]  [<ffffffff8106c5a4>] valid_state+0x18b/0x19e
[    0.770008]  [<ffffffff8100deb3>] ? save_stack_trace+0x2a/0x48
[    0.770008]  [<ffffffff8106cf9d>] ? check_usage_forwards+0x0/0x7e
[    0.770008]  [<ffffffff8106c6bd>] mark_lock+0x106/0x261
[    0.770008]  [<ffffffff8100deb3>] ? save_stack_trace+0x2a/0x48
[    0.770008]  [<ffffffff8106da58>] __lock_acquire+0x3b0/0xe14
[    0.770008]  [<ffffffff8106e4ad>] ? __lock_acquire+0xe05/0xe14
[    0.770008]  [<ffffffff8106c5d9>] ? mark_lock+0x22/0x261
[    0.770008]  [<ffffffff8106e4ad>] ? __lock_acquire+0xe05/0xe14
[    0.770008]  [<ffffffff8106e4ad>] ? __lock_acquire+0xe05/0xe14
[    0.770008]  [<ffffffff8106e594>] lock_acquire+0xd8/0x104
[    0.770008]  [<ffffffff81041cbc>] ? get_online_cpus+0x3c/0x50
[    0.770008]  [<ffffffff81507a82>] __mutex_lock_common+0x48/0x34f
[    0.770008]  [<ffffffff81041cbc>] ? get_online_cpus+0x3c/0x50
[    0.770008]  [<ffffffff8104d46d>] ? try_to_del_timer_sync+0x6e/0x7c
[    0.770008]  [<ffffffff81041cbc>] ? get_online_cpus+0x3c/0x50
[    0.770008]  [<ffffffff8150923a>] ? _raw_spin_unlock_irqrestore+0x46/0x55
[    0.770008]  [<ffffffff810d61f1>] ? calculate_normal_threshold+0x0/0x47
[    0.770008]  [<ffffffff81507e38>] mutex_lock_nested+0x37/0x3c
[    0.770008]  [<ffffffff81041cbc>] get_online_cpus+0x3c/0x50
[    0.770008]  [<ffffffff810d6aa9>] set_pgdat_percpu_threshold+0x1f/0x97
[    0.770008]  [<ffffffff810cfb06>] kswapd+0x255/0x8cb
[    0.770008]  [<ffffffff81039c42>] ? finish_task_switch+0x44/0xeb
[    0.770008]  [<ffffffff815070a2>] ? schedule+0x68a/0x6d7
[    0.770008]  [<ffffffff8105bcb6>] ? autoremove_wake_function+0x0/0x38
[    0.770008]  [<ffffffff810cf8b1>] ? kswapd+0x0/0x8cb
[    0.770008]  [<ffffffff8105b81d>] kthread+0x9c/0xa4
[    0.770008]  [<ffffffff81003a64>] kernel_thread_helper+0x4/0x10
[    0.770008]  [<ffffffff81509650>] ? restore_args+0x0/0x30
[    0.770008]  [<ffffffff8105b781>] ? kthread+0x0/0xa4
[    0.770008]  [<ffffffff81003a60>] ? kernel_thread_helper+0x0/0x10
