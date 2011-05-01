Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761295Ab1EARvT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 13:51:19 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:46916 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1761271Ab1EARvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 13:51:18 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+TyhEnzoSTThkNJzAy7AcbUH0TLbqB0fjui9F981
	yqlkP5cydUKoqQ
Subject: Re: [PATCH tip/core/rcu 31/86] rcu: further lower priority in
 rcu_yield()
From: Mike Galbraith <efault@gmx.de>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
In-Reply-To: <1304256126-26015-31-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20110501132142.GA25494@linux.vnet.ibm.com>
	 <1304256126-26015-31-git-send-email-paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 01 May 2011 19:51:04 +0200
Message-ID: <1304272264.7417.20.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-05-01 at 06:21 -0700, Paul E. McKenney wrote:
> From: Paul E. McKenney <paul.mckenney@linaro.org>
> 
> Although rcu_yield() dropped from real-time to normal priority, there
> is always the possibility that the competing tasks have been niced.
> So nice to 19 in rcu_yield() to help ensure that other tasks have a
> better chance of running.

But.. that just prolongs the pain of overhead you _have_ to eat, no?  In
a brief surge, fine, you can spread the cost out.. but how do you know
when it's ok to yield?

(When maintenance threads worrying about their CPU usage is worrisome.)

> Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
>  kernel/rcutree.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index 3295c7b..963b4b1 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -1561,6 +1561,7 @@ static void rcu_yield(void (*f)(unsigned long), unsigned long arg)
>  	mod_timer(&yield_timer, jiffies + 2);
>  	sp.sched_priority = 0;
>  	sched_setscheduler_nocheck(current, SCHED_NORMAL, &sp);
> +	set_user_nice(current, 19);
>  	schedule();
>  	sp.sched_priority = RCU_KTHREAD_PRIO;
>  	sched_setscheduler_nocheck(current, SCHED_FIFO, &sp);


