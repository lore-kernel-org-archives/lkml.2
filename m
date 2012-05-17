Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030464Ab2EQWYY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 18:24:24 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:43691 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030205Ab2EQWYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 18:24:22 -0400
X-Originating-IP: 217.70.178.135
X-Originating-IP: 50.43.46.74
Date: Thu, 17 May 2012 15:24:07 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH RFC tip/core/rcu 1/2] rcu: Fix code-style issues
 involving "else"
Message-ID: <20120517222407.GB15766@leaf>
References: <20120517221217.GA12196@linux.vnet.ibm.com>
 <1337292765-12221-1-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337292765-12221-1-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2012 at 03:12:44PM -0700, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paul.mckenney@linaro.org>
> 
> The Linux kernel coding style says that single-statement blocks should
> omit curly braces unless the other leg of the "if" statement has
> multiple statements, in which case the curly braces should be included.
> This commit fixes RCU's violations of this rule.
> 
> Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

> diff --git a/kernel/rcutiny_plugin.h b/kernel/rcutiny_plugin.h
> index fc31a2d..cd9ae33 100644
> --- a/kernel/rcutiny_plugin.h
> +++ b/kernel/rcutiny_plugin.h
> @@ -351,8 +351,9 @@ static int rcu_initiate_boost(void)
>  			rcu_preempt_ctrlblk.boost_tasks =
>  				rcu_preempt_ctrlblk.gp_tasks;
>  		invoke_rcu_callbacks();
> -	} else
> +	} else {
>  		RCU_TRACE(rcu_initiate_boost_trace());
> +	}
>  	return 1;
>  }
>  
> diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
> index e66b34a..d7c3cb1 100644
> --- a/kernel/rcutorture.c
> +++ b/kernel/rcutorture.c
> @@ -407,8 +407,9 @@ rcu_torture_cb(struct rcu_head *p)
>  	if (++rp->rtort_pipe_count >= RCU_TORTURE_PIPE_LEN) {
>  		rp->rtort_mbtest = 0;
>  		rcu_torture_free(rp);
> -	} else
> +	} else {
>  		cur_ops->deferred_free(rp);
> +	}
>  }
>  
>  static int rcu_no_completed(void)
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index 0da7b88..25874a3 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -893,8 +893,9 @@ static void __note_new_gpnum(struct rcu_state *rsp, struct rcu_node *rnp, struct
>  		if (rnp->qsmask & rdp->grpmask) {
>  			rdp->qs_pending = 1;
>  			rdp->passed_quiesce = 0;
> -		} else
> +		} else {
>  			rdp->qs_pending = 0;
> +		}
>  		zero_cpu_stall_ticks(rdp);
>  	}
>  }
> @@ -2115,9 +2116,9 @@ void synchronize_sched_expedited(void)
>  		put_online_cpus();
>  
>  		/* No joy, try again later.  Or just synchronize_sched(). */
> -		if (trycount++ < 10)
> +		if (trycount++ < 10) {
>  			udelay(trycount * num_online_cpus());
> -		else {
> +		} else {
>  			synchronize_sched();
>  			return;
>  		}
> diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
> index 2411000..c9b173c 100644
> --- a/kernel/rcutree_plugin.h
> +++ b/kernel/rcutree_plugin.h
> @@ -398,8 +398,9 @@ static noinline void rcu_read_unlock_special(struct task_struct *t)
>  							 rnp->grphi,
>  							 !!rnp->gp_tasks);
>  			rcu_report_unblock_qs_rnp(rnp, flags);
> -		} else
> +		} else {
>  			raw_spin_unlock_irqrestore(&rnp->lock, flags);
> +		}
>  
>  #ifdef CONFIG_RCU_BOOST
>  		/* Unboost if we were boosted. */
> @@ -429,9 +430,9 @@ void __rcu_read_unlock(void)
>  {
>  	struct task_struct *t = current;
>  
> -	if (t->rcu_read_lock_nesting != 1)
> +	if (t->rcu_read_lock_nesting != 1) {
>  		--t->rcu_read_lock_nesting;
> -	else {
> +	} else {
>  		barrier();  /* critical section before exit code. */
>  		t->rcu_read_lock_nesting = INT_MIN;
>  		barrier();  /* assign before ->rcu_read_unlock_special load */
> @@ -824,9 +825,9 @@ sync_rcu_preempt_exp_init(struct rcu_state *rsp, struct rcu_node *rnp)
>  	int must_wait = 0;
>  
>  	raw_spin_lock_irqsave(&rnp->lock, flags);
> -	if (list_empty(&rnp->blkd_tasks))
> +	if (list_empty(&rnp->blkd_tasks)) {
>  		raw_spin_unlock_irqrestore(&rnp->lock, flags);
> -	else {
> +	} else {
>  		rnp->exp_tasks = rnp->blkd_tasks.next;
>  		rcu_initiate_boost(rnp, flags);  /* releases rnp->lock */
>  		must_wait = 1;
> @@ -870,9 +871,9 @@ void synchronize_rcu_expedited(void)
>  	 * expedited grace period for us, just leave.
>  	 */
>  	while (!mutex_trylock(&sync_rcu_preempt_exp_mutex)) {
> -		if (trycount++ < 10)
> +		if (trycount++ < 10) {
>  			udelay(trycount * num_online_cpus());
> -		else {
> +		} else {
>  			synchronize_rcu();
>  			return;
>  		}
> @@ -2213,8 +2214,9 @@ static void rcu_prepare_for_idle(int cpu)
>  	if (rcu_cpu_has_callbacks(cpu)) {
>  		trace_rcu_prep_idle("More callbacks");
>  		invoke_rcu_core();
> -	} else
> +	} else {
>  		trace_rcu_prep_idle("Callbacks drained");
> +	}
>  }
>  
>  /*
> -- 
> 1.7.8
> 
