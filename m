Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489Ab1ILJFN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 05:05:13 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:35233 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752959Ab1ILJFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 05:05:11 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+cVMtQqIucfHRX832LCR/CtYuWCTcLnXs0JnOdpW
	eUfKG5C8IevfaH
Subject: Re: [ANNOUNCE] 3.0.4-rt13
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
In-Reply-To: <1315817948.26517.16.camel@twins>
References: <alpine.LFD.2.02.1109101052340.2723@ionos>
	 <1315737307.6544.1.camel@marge.simson.net>
	 <1315817948.26517.16.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 12 Sep 2011 11:05:07 +0200
Message-ID: <1315818307.21927.30.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-09-12 at 10:59 +0200, Peter Zijlstra wrote:
> On Sun, 2011-09-11 at 12:35 +0200, Mike Galbraith wrote:
> > (gdb) list *do_sigtimedwait+0x62
> > 0xffffffff8104f3e2 is in do_sigtimedwait (kernel/signal.c:2628).
> > 2623             * Invert the set of allowed signals to get those we want to block.
> > 2624             */
> > 2625            sigdelsetmask(&mask, sigmask(SIGKILL) | sigmask(SIGSTOP));
> > 2626            signotset(&mask);
> > 2627
> > 2628            spin_lock_irq(&tsk->sighand->siglock);
> > 2629            sig = dequeue_signal(tsk, &mask, info);
> > 2630            if (!sig && timeout) {
> > 2631                    /*
> > 2632                     * None ready, temporarily unblock those we're interested
> > (gdb) list *do_sigtimedwait+0x15f
> > 0xffffffff8104f4df is in do_sigtimedwait (kernel/signal.c:2642).
> > 2637                    tsk->real_blocked = tsk->blocked;
> > 2638                    sigandsets(&tsk->blocked, &tsk->blocked, &mask);
> > 2639                    recalc_sigpending();
> > 2640                    spin_unlock_irq(&tsk->sighand->siglock);
> > 2641
> > 2642                    timeout = schedule_timeout_interruptible(timeout);
> > 2643
> > 2644                    spin_lock_irq(&tsk->sighand->siglock);
> > 2645                    __set_task_blocked(tsk, &tsk->real_blocked);
> > 2646                    siginitset(&tsk->real_blocked, 0);
> > 
> 
> 
> Right, so what Thomas says.. Now admittedly I haven't had my morning
> juice yet, but staring at that function I can't see why that warning
> would trigger at all.
> 
> I'm going to try and reproduce, but Thomas is already saying he can't,
> so I'm not too confident.
> 
> I you can easily trigger this, could you add some trace_printk() to
> migrate_disable/enable that prints both counters etc.. so we can see wtf
> happens?

It was highly repeatable with rt executive model running on 3 CPUs, will
poke.

	-Mike


