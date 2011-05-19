Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757124Ab1ESOru (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 10:47:50 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49797 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757027Ab1ESOrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 10:47:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=U9fzZg3DK/muZOtvS6aUyFiASnVAWlmOslGeNct6UEYFKyG5tp1PGkAmmf8D8mSxab
         YP6a8QR/bB1ARV5kFxujAL00l1TOZdImTiVX4nUllpiBdFj6RQP1tlOyVZX5YJfFRw/x
         xG4vdKwnpNP9po2gT9q7M1/IRJ+5wZCYdyqW8=
Date: Thu, 19 May 2011 16:47:43 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [GIT PULL rcu/next] rcu commits for 2.6.40
Message-ID: <20110519144740.GC1956@nowhere>
References: <20110513162646.GW2258@linux.vnet.ibm.com>
 <20110516070808.GC24836@elte.hu>
 <20110516074822.GE2573@linux.vnet.ibm.com>
 <20110516115148.GA2421@elte.hu>
 <20110516122329.GA29356@elte.hu>
 <20110516212449.GJ2573@linux.vnet.ibm.com>
 <20110517024000.GA5026@nowhere>
 <4DD435C2.6040305@kernel.org>
 <20110518231314.GA1723@nowhere>
 <4DD49DAF.5080605@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DD49DAF.5080605@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 18, 2011 at 09:33:51PM -0700, Yinghai Lu wrote:
> ...
> [   89.913205] ------------[ cut here ]------------
> [   89.913216] WARNING: at kernel/rcutree.c:352 rcu_enter_nohz+0x49/0x8b()
> [   89.913220] Hardware name: Sun Fire X4800 M2 
> [   89.913224] Modules linked in:
> [   89.913230] Switched to NOHz mode on CPU #34
> [   89.913237] Pid: 0, comm: swapper Tainted: G        W   2.6.39-rc7-tip-yh-05281-g8e9254b-dirty #1019
> [   89.913242] Call Trace:
> [   89.913269]  [<ffffffff81080144>] warn_slowpath_common+0x85/0x9d
> [   89.913280]  [<ffffffff81080176>] warn_slowpath_null+0x1a/0x1c
> [   89.913290]  [<ffffffff810d32cc>] rcu_enter_nohz+0x49/0x8b
> [   89.913305]  [<ffffffff810ab121>] tick_nohz_stop_sched_tick+0x27d/0x366
> [   89.913317]  [<ffffffff810391bc>] cpu_idle+0x7a/0xcc
> [   89.913329]  [<ffffffff81bda6e3>] rest_init+0xb7/0xbe
> [   89.913340]  [<ffffffff81bda62c>] ? csum_partial_copy_generic+0x16c/0x16c
> [   89.913352]  [<ffffffff82742e39>] start_kernel+0x3b2/0x3bd
> [   89.913363]  [<ffffffff827422cc>] x86_64_start_reservations+0x9c/0xa0
> [   89.913374]  [<ffffffff827424a8>] x86_64_start_kernel+0x1d8/0x1e3
> [   89.913379] ---[ end trace a7919e7f17c0a726 ]---
> [   89.913401] Dumping ftrace buffer:
> [   89.913417] Switched to NOHz mode on CPU #4
> [   89.913428] ---------------------------------
> [   89.913444] Switched to NOHz mode on CPU #54
> [   89.913467] CPU:0 [LOST 39120 EVENTS]
<snip>
> [   89.918480]   <idle>-0       0d... 89913074us : <stack trace>
> [   89.918482]  => rcu_irq_enter
> [   89.918484]  => irq_enter
> [   89.918486]  => smp_apic_timer_interrupt
> [   89.918488]  => apic_timer_interrupt
> [   89.918489]  => cpu_idle
> [   89.918491]  => rest_init
> [   89.918492]  => start_kernel
> [   89.918494]  => x86_64_start_reservations
> [   89.918517]   <idle>-0       0dN.. 89913130us : <stack trace>
> [   89.918519]  => rcu_irq_exit
> [   89.918521]  => irq_exit
> [   89.918522]  => smp_apic_timer_interrupt
> [   89.918524]  => apic_timer_interrupt
> [   89.918526]  => cpu_idle
> [   89.918527]  => rest_init
> [   89.918529]  => start_kernel
> [   89.918530]  => x86_64_start_reservations
> [   89.918552]   <idle>-0       0d... 89913196us : <stack trace>
> [   89.918555]  => rcu_enter_nohz
> [   89.918556]  => tick_nohz_stop_sched_tick
> [   89.918558]  => cpu_idle
> [   89.918560]  => rest_init
> [   89.918561]  => start_kernel
> [   89.918563]  => x86_64_start_reservations
> [   89.918565]  => x86_64_start_kernel
> [   89.918569] ---------------------------------

So, the warning triggered there. But the pairing looks actually good,
given we had an interrupt right before that and it has called
irq_enter and irq_exit.

I have no clue about what happened there.

It may be easier if we have the value of dynticks and dynticks_nesting.

Can you please test the following branch?

	git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
		rcu/debug

It's Paul's branch + the early_initcall fix + the following patch:

---
commit 14667f347dea62d9e5a08e0f614840e50f73002c
Author: Frederic Weisbecker <fweisbec@gmail.com>
Date:   Thu May 19 16:25:19 2011 +0200

    rcu: Trace dynticks internal values
    
    To debug some nasty count bug.
    
    Not-signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index f30aea3..49d6348 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -349,6 +349,7 @@ void rcu_enter_nohz(void)
 	local_irq_save(flags);
 	trace_dump_stack();
 	rdtp = &__get_cpu_var(rcu_dynticks);
+	trace_printk("%x %x\n", atomic_read(&rdtp->dynticks), rdtp->dynticks_nesting);
 	if (WARN_ON_ONCE(rdtp->dynticks_nesting != 1))
 		ftrace_dump(DUMP_ORIG);
 	rdtp->dynticks_nesting = 1;
@@ -388,6 +389,7 @@ void rcu_exit_nohz(void)
 	local_irq_save(flags);
 	trace_dump_stack();
 	rdtp = &__get_cpu_var(rcu_dynticks);
+	trace_printk("%x %x\n", atomic_read(&rdtp->dynticks), rdtp->dynticks_nesting);
 	if (WARN_ON_ONCE(rdtp->dynticks_nesting != 0))
 		ftrace_dump(DUMP_ORIG);
 	rdtp->dynticks_nesting = 0;
@@ -463,9 +465,12 @@ void rcu_nmi_exit(void)
 void rcu_irq_enter(void)
 {
 	unsigned long flags;
+	struct rcu_dynticks *rdtp;
 
 	local_irq_save(flags);
 	trace_dump_stack();
+	rdtp = &__get_cpu_var(rcu_dynticks);
+	trace_printk("%x %x\n", atomic_read(&rdtp->dynticks), rdtp->dynticks_nesting);
 	__rcu_exit_nohz();
 	local_irq_restore(flags);
 }
@@ -480,9 +485,12 @@ void rcu_irq_enter(void)
 void rcu_irq_exit(void)
 {
 	unsigned long flags;
+	struct rcu_dynticks *rdtp;
 
 	local_irq_save(flags);
 	trace_dump_stack();
+	rdtp = &__get_cpu_var(rcu_dynticks);
+	trace_printk("%x %x\n", atomic_read(&rdtp->dynticks), rdtp->dynticks_nesting);
 	__rcu_enter_nohz();
 	local_irq_restore(flags);
 }
