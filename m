Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932421Ab1KOVNQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 16:13:16 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:37182 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932307Ab1KOVNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 16:13:15 -0500
X-Originating-IP: 217.70.178.131
X-Originating-IP: 50.43.15.19
Date: Tue, 15 Nov 2011 13:13:02 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH tip/core/rcu 4/9] sched: add is_idle_task() to handle
 invalidated uses of idle_cpu()
Message-ID: <20111115211302.GA31473@leaf>
References: <20111115202736.GA11030@linux.vnet.ibm.com>
 <1321388885-11211-4-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321388885-11211-4-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 15, 2011 at 12:28:00PM -0800, Paul E. McKenney wrote:
> From: Paul E. McKenney <paul.mckenney@linaro.org>
> 
> Commit 908a3283 (Fix idle_cpu()) invalidated some uses of idle_cpu(),
> which used to say whether or not the CPU was running the idle task,
> but now instead says whether or not the CPU is running the idle task
> in the absence of pending wakeups.  Although this new implementation
> gives a better answer to the question "is this CPU idle?", it also
> invalidates other uses that were made of idle_cpu().
> 
> This commit therefore introduces a new is_idle_task() API member
> that determines whether or not the specified task is one of the
> idle tasks, allowing open-coded "->pid == 0" sequences to be replaced
> by something more meaningful.
> 
> Suggested-by: Josh Triplett <josh@joshtriplett.org>
> Suggested-by: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
>  include/linux/sched.h |    1 +
>  kernel/sched.c        |    9 +++++++++
>  2 files changed, 10 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 68daf4f..4b1077b 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -2071,6 +2071,7 @@ extern int sched_setscheduler(struct task_struct *, int,
>  extern int sched_setscheduler_nocheck(struct task_struct *, int,
>  				      const struct sched_param *);
>  extern struct task_struct *idle_task(int cpu);
> +extern int is_idle_task(struct task_struct *p);

The kernel has a bool type; please use it here rather than int, to make
the return value more obvious.

Also, any particular reason not to make this a static inline?

- Josh Triplett
