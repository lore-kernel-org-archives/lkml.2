Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991Ab2BFH44 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 02:56:56 -0500
Received: from merlin.infradead.org ([205.233.59.134]:58162 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912Ab2BFH4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 02:56:55 -0500
Message-ID: <4F2F8780.5060207@kernel.dk>
Date: Mon, 06 Feb 2012 08:55:44 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Shaohua Li <shaohua.li@intel.com>
CC: lkml <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tejun Heo <tj@kernel.org>, Knut Petersen <Knut_Petersen@t-online.de>,
        mroos@linux.ee
Subject: Re: [patch]block: fix ioc locking warning
References: <1328514611.21268.66.camel@sli10-conroe>
In-Reply-To: <1328514611.21268.66.camel@sli10-conroe>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/2012 08:50 AM, Shaohua Li wrote:
> Meelis reported a warning:
> 
> WARNING: at kernel/timer.c:1122 run_timer_softirq+0x199/0x1ec()
> Hardware name: 939Dual-SATA2
> timer: cfq_idle_slice_timer+0x0/0xaa preempt leak: 00000102 -> 00000103
> Modules linked in: sr_mod cdrom videodev media drm_kms_helper ohci_hcd ehci_hcd v4l2_compat_ioctl32 usbcore i2c_ali15x3 snd_seq drm snd_timer snd_seq
> Pid: 0, comm: swapper Not tainted 3.3.0-rc2-00110-gd125666 #176
> Call Trace:
>  <IRQ>  [<ffffffff81022aaa>] warn_slowpath_common+0x7e/0x96
>  [<ffffffff8114c485>] ? cfq_slice_expired+0x1d/0x1d
>  [<ffffffff81022b56>] warn_slowpath_fmt+0x41/0x43
>  [<ffffffff8114c526>] ? cfq_idle_slice_timer+0xa1/0xaa
>  [<ffffffff8114c485>] ? cfq_slice_expired+0x1d/0x1d
>  [<ffffffff8102c124>] run_timer_softirq+0x199/0x1ec
>  [<ffffffff81047a53>] ? timekeeping_get_ns+0x12/0x31
>  [<ffffffff810145fd>] ? apic_write+0x11/0x13
>  [<ffffffff81027475>] __do_softirq+0x74/0xfa
>  [<ffffffff812f337a>] call_softirq+0x1a/0x30
>  [<ffffffff81002ff9>] do_softirq+0x31/0x68
>  [<ffffffff810276cf>] irq_exit+0x3d/0xa3
>  [<ffffffff81014aca>] smp_apic_timer_interrupt+0x6b/0x77
>  [<ffffffff812f2de9>] apic_timer_interrupt+0x69/0x70
>  <EOI>  [<ffffffff81040136>] ? sched_clock_cpu+0x73/0x7d
>  [<ffffffff81040136>] ? sched_clock_cpu+0x73/0x7d
>  [<ffffffff8100801f>] ? default_idle+0x1e/0x32
>  [<ffffffff81008019>] ? default_idle+0x18/0x32
>  [<ffffffff810008b1>] cpu_idle+0x87/0xd1
>  [<ffffffff812de861>] rest_init+0x85/0x89
>  [<ffffffff81659a4d>] start_kernel+0x2eb/0x2f8
>  [<ffffffff8165926e>] x86_64_start_reservations+0x7e/0x82
>  [<ffffffff81659362>] x86_64_start_kernel+0xf0/0xf7
> 
> this_q == locked_q is possible. There are two problems here:
> 1. In UP case, there is preemption counter issue as spin_trylock always
> successes.
> 2. In SMP case, the loop breaks too earlier.

Thanks Shaohua, applied!

-- 
Jens Axboe

