Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932515Ab1KOVfb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 16:35:31 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:56987 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932467Ab1KOVfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 16:35:30 -0500
X-Originating-IP: 217.70.178.148
X-Originating-IP: 50.43.15.19
Date: Tue, 15 Nov 2011 13:35:14 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH tip/core/rcu 5/9] rcu: Make RCU use the new
 is_idle_task() API
Message-ID: <20111115213514.GC31473@leaf>
References: <20111115202736.GA11030@linux.vnet.ibm.com>
 <1321388885-11211-5-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321388885-11211-5-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 15, 2011 at 12:28:01PM -0800, Paul E. McKenney wrote:
> From: Paul E. McKenney <paul.mckenney@linaro.org>
> 
> Change from direct comparison of ->pid with zero to is_idle_task().
> 
> Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  kernel/rcutiny.c |    4 ++--
>  kernel/rcutree.c |    4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
> index 4e16ce3..e5bd949 100644
> --- a/kernel/rcutiny.c
> +++ b/kernel/rcutiny.c
> @@ -64,7 +64,7 @@ static void rcu_idle_enter_common(long long oldval)
>  		return;
>  	}
>  	RCU_TRACE(trace_rcu_dyntick("Start", oldval, rcu_dynticks_nesting));
> -	if (current->pid != 0) {
> +	if (!is_idle_task(current)) {
>  		struct task_struct *idle = idle_task(smp_processor_id());
>  
>  		RCU_TRACE(trace_rcu_dyntick("Error on entry: not idle task",
> @@ -118,7 +118,7 @@ static void rcu_idle_exit_common(long long oldval)
>  		return;
>  	}
>  	RCU_TRACE(trace_rcu_dyntick("End", oldval, rcu_dynticks_nesting));
> -	if (current->pid != 0) {
> +	if (!is_idle_task(current)) {
>  		struct task_struct *idle = idle_task(smp_processor_id());
>  
>  		RCU_TRACE(trace_rcu_dyntick("Error on exit: not idle task",
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index 49e0783..7fb8b0e 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -355,7 +355,7 @@ static void rcu_idle_enter_common(struct rcu_dynticks *rdtp, long long oldval)
>  		return;
>  	}
>  	trace_rcu_dyntick("Start", oldval, rdtp->dynticks_nesting);
> -	if (current->pid != 0) {
> +	if (!is_idle_task(current)) {
>  		struct task_struct *idle = idle_task(smp_processor_id());
>  
>  		trace_rcu_dyntick("Error on entry: not idle task",
> @@ -449,7 +449,7 @@ static void rcu_idle_exit_common(struct rcu_dynticks *rdtp, long long oldval)
>  	smp_mb__after_atomic_inc();  /* See above. */
>  	WARN_ON_ONCE(!(atomic_read(&rdtp->dynticks) & 0x1));
>  	trace_rcu_dyntick("End", oldval, rdtp->dynticks_nesting);
> -	if (current->pid != 0) {
> +	if (!is_idle_task(current)) {
>  		struct task_struct *idle = idle_task(smp_processor_id());
>  
>  		trace_rcu_dyntick("Error on exit: not idle task",
> -- 
> 1.7.3.2
> 
