Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751426Ab1GXQMZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 12:12:25 -0400
Received: from www.linutronix.de ([62.245.132.108]:51070 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769Ab1GXQMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 12:12:21 -0400
Date: Sun, 24 Jul 2011 18:12:19 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Maarten Lankhorst <m.b.lankhorst@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Darren Hart <dvhart@linux.intel.com>
Subject: Re: [ANNOUNCE] 3.0-rt3
In-Reply-To: <4E2C2ED6.4040904@gmail.com>
Message-ID: <alpine.LFD.2.02.1107241807390.3136@ionos>
References: <alpine.LFD.2.02.1107241223560.2702@ionos> <4E2C2ED6.4040904@gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Jul 2011, Maarten Lankhorst wrote:
> Oprofile seems to be upset at me, I swear I'm innocent!

I bet you are. Seems oprofile needs some care, but that has to wait a
couple of days as i'm travelling.
 
> [   46.460786] oprofile: using NMI interrupt.
> [   47.492263] BUG: sleeping function called from invalid context at kernel/rtmutex.c:645
> [   47.492265] in_atomic(): 1, irqs_disabled(): 1, pid: 0, name: kworker/0:1
> [   47.492267] Pid: 0, comm: kworker/0:1 Tainted: G         C  3.0.0-rt3-patser+ #39
> [   47.492269] Call Trace:
> [   47.492270]  <IRQ>  [<ffffffff8103fc0a>] __might_sleep+0xca/0xf0
> [   47.492279]  [<ffffffff8160d424>] rt_spin_lock+0x24/0x40
> [   47.492282]  [<ffffffff811476c7>] __kmalloc+0xc7/0x370

Grrr. Allocating memory from SMP function calls seems to become a
pattern :(

> Also not sure where this one came from:
> [   37.456688] BUG: spinlock bad magic on CPU#3, threaded-ml/1619
> [   37.456690]  lock: ffff8801fdc74d50, .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
> [   37.456692] Pid: 1619, comm: threaded-ml Tainted: G         C  3.0.0-rt3-patser+ #39
> [   37.456693] Call Trace:
> [   37.456697]  [<ffffffff81607a78>] spin_bug+0xa0/0xa8
> [   37.456699]  [<ffffffff8132b412>] do_raw_spin_lock+0xa2/0x170
> [   37.456702]  [<ffffffff8104a201>] ? get_parent_ip+0x11/0x50
> [   37.456704]  [<ffffffff8160d783>] _raw_spin_lock+0x23/0x30
> [   37.456706]  [<ffffffff810931ce>] rt_mutex_start_proxy_lock+0x2e/0xd0
> [   37.456708]  [<ffffffff8109093a>] futex_requeue+0x47a/0x850
> [   37.456710]  [<ffffffff8109138e>] do_futex+0xae/0xb00
> [   37.456712]  [<ffffffff81157dcd>] ? fget_light+0x6d/0x110
> [   37.456714]  [<ffffffff810b77b7>] ? audit_syscall_entry+0x2e7/0x310
> [   37.456715]  [<ffffffff814c9375>] ? sys_recvmsg+0x75/0x90
> [   37.456717]  [<ffffffff810923e6>] compat_sys_futex+0xf6/0x190
> [   37.456719]  [<ffffffff8100e864>] ? syscall_trace_enter+0x184/0x210
> [   37.456721]  [<ffffffff816158b3>] ia32_do_call+0x13/0x13

Urrgh, that's not a good one. Darren, can you please have a look at that?

Thanks,

	tglx
