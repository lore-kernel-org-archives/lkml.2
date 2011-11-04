Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536Ab1KDJeE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 05:34:04 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39106 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262Ab1KDJeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 05:34:01 -0400
Date: Fri, 4 Nov 2011 12:31:24 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Yong Zhang <yong.zhang0@gmail.com>, David Rientjes <rientjes@google.com>,
        Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: WARNING: at kernel/lockdep.c:690 __lock_acquire+0x168/0x164b()
Message-ID: <20111104093123.GA2957@swordfish>
References: <alpine.DEB.2.00.1110201425560.5552@chino.kir.corp.google.com>
 <20111020213644.GB25124@google.com>
 <20111020230040.GC3586@swordfish.minsk.epam.com>
 <alpine.DEB.2.00.1110210212130.12963@chino.kir.corp.google.com>
 <20111021094520.GA9884@zhy>
 <20111103071735.GA3228@swordfish.minsk.epam.com>
 <20111103072705.GA15871@zhy>
 <20111103074506.GB3228@swordfish.minsk.epam.com>
 <20111103075354.GA16666@zhy>
 <20111104092520.GA16897@gere.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111104092520.GA16897@gere.osrc.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (11/04/11 10:25), Borislav Petkov wrote:
> > Understood. If someone can come up with a simple patch which could
> > cover the case I mentioned before, that would be great.
> > /me goes to poke at it.
> 
> I dunno whether this is related but I get the following on 3.1:
>

I think this is different problem. Failed check that lockdep key is marked as `static'.

	Sergey
 
> [ 5499.537074] INFO: trying to register non-static key.
> [ 5499.537080] the code is fine but needs lockdep annotation.
> [ 5499.537083] turning off the locking correctness validator.
> [ 5499.537088] Pid: 0, comm: kworker/0:1 Not tainted 3.1.0 #1
> [ 5499.537091] Call Trace:
> [ 5499.537094]  <IRQ>  [<ffffffff8107beed>] __lock_acquire+0x165d/0x1e30
> [ 5499.537109]  [<ffffffff810321fc>] ? double_rq_lock+0x2c/0x80
> [ 5499.537115]  [<ffffffff8107ccd3>] lock_acquire+0x93/0x160
> [ 5499.537120]  [<ffffffff810321fc>] ? double_rq_lock+0x2c/0x80
> [ 5499.537126]  [<ffffffff814d9866>] _raw_spin_lock+0x36/0x50
> [ 5499.537130]  [<ffffffff810321fc>] ? double_rq_lock+0x2c/0x80
> [ 5499.537135]  [<ffffffff810321fc>] double_rq_lock+0x2c/0x80
> [ 5499.537140]  [<ffffffff81039195>] load_balance+0x215/0x6c0
> [ 5499.537146]  [<ffffffff81039640>] ? load_balance+0x6c0/0x6c0
> [ 5499.537151]  [<ffffffff810396fd>] rebalance_domains+0xbd/0x1d0
> [ 5499.537155]  [<ffffffff81039640>] ? load_balance+0x6c0/0x6c0
> [ 5499.537161]  [<ffffffff810398ec>] run_rebalance_domains+0xdc/0x130
> [ 5499.537166]  [<ffffffff81048dcd>] __do_softirq+0xbd/0x290
> [ 5499.537173]  [<ffffffff814dc42c>] call_softirq+0x1c/0x30
> [ 5499.537178]  [<ffffffff81003eb5>] do_softirq+0x85/0xc0
> [ 5499.537183]  [<ffffffff810492ce>] irq_exit+0x9e/0xc0
> [ 5499.537189]  [<ffffffff8101ca9f>] smp_call_function_single_interrupt+0x2f/0x40
> [ 5499.537195]  [<ffffffff814dbeb0>] call_function_single_interrupt+0x70/0x80
> [ 5499.537199]  <EOI>  [<ffffffff810096e6>] ? native_sched_clock+0x26/0x70
> [ 5499.537212]  [<ffffffffa0038e1a>] ? acpi_idle_enter_simple+0xee/0x11f [processor]
> [ 5499.537221]  [<ffffffffa0038e15>] ? acpi_idle_enter_simple+0xe9/0x11f [processor]
> [ 5499.537227]  [<ffffffff813f8b1d>] cpuidle_idle_call+0xdd/0x350
> [ 5499.537233]  [<ffffffff8100081f>] cpu_idle+0x6f/0xd0
> [ 5499.537238]  [<ffffffff814cc665>] start_secondary+0x1ae/0x1b3
> 
> -- 
> Regards/Gruss,
> Boris.
> 
