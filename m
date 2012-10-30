Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965530Ab2J3SzH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 14:55:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9923 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965249Ab2J3SzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 14:55:03 -0400
X-Authority-Analysis: v=2.0 cv=KcBQQHkD c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=UdlrXtXKRkIA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=SBH4brdnqqgA:10 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=Z4Rwk6OoAAAA:8 a=20KFwNOVAAAA:8 a=9AzMRrQhAAAA:8 a=NufY4J3AAAAA:8 a=KKAkSRfTAAAA:8 a=JfrnYn6hAAAA:8 a=ftUzEednAAAA:8 a=sozttTNsAAAA:8 a=EUspDBNiAAAA:8 a=VnNF1IyMAAAA:8 a=fh4mg5NFAAAA:8 a=G2TvuVglnKdlU-ZeKSQA:9 a=PUjeQqilurYA:10 a=MSl-tDqOz04A:10 a=LI9Vle30uBYA:10 a=jbrJJM5MRmoA:10 a=jEp0ucaQiEUA:10 a=SxxB86fLhQ4A:10 a=re9sYKne76oA:10 a=WwgC8nHKvroA:10 a=3Rfx1nUSh_UA:10 a=QwxQZocgbLcA:10 a=x2szoZtqnggA:10 a=IG2fH9E8heMA:10 a=Im-eZXwrtqoA:10 a=jeBq3FmKZ4MA:10 a=Zh68SRI7RUMA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1351623300.4004.25.camel@gandalf.local.home>
Subject: Re: [PATCH 09/32] nohz/cpuset: Restart tick when nohz flag is
 cleared on cpuset
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <clark.williams@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>,
        Alessio Igor Bogani <abogani@kernel.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@ti.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>
Date: Tue, 30 Oct 2012 14:55:00 -0400
In-Reply-To: <20121029203847.966629295@goodmis.org>
References: <20121029202711.062749374@goodmis.org>
	 <20121029203847.966629295@goodmis.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-10-29 at 16:27 -0400, Steven Rostedt wrote:
> plain text document attachment
> (0009-nohz-cpuset-Restart-tick-when-nohz-flag-is-cleared-o.patch)
> From: Frederic Weisbecker <fweisbec@gmail.com>
> 
> Issue an IPI to restart the tick on a CPU that belongs
> to a cpuset when its nohz flag gets cleared.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Alessio Igor Bogani <abogani@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Avi Kivity <avi@redhat.com>
> Cc: Chris Metcalf <cmetcalf@tilera.com>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
> Cc: Geoff Levand <geoff@infradead.org>
> Cc: Gilad Ben Yossef <gilad@benyossef.com>
> Cc: Hakan Akkan <hakanakkan@gmail.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Kevin Hilman <khilman@ti.com>
> Cc: Max Krasnyansky <maxk@qualcomm.com>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Stephen Hemminger <shemminger@vyatta.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Sven-Thorsten Dietrich <thebigcorporation@gmail.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> ---
>  include/linux/cpuset.h   |    2 ++
>  kernel/cpuset.c          |   25 +++++++++++++++++++++++--
>  kernel/time/tick-sched.c |    8 ++++++++
>  3 files changed, 33 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
> index 7e7eb41..631968b 100644
> --- a/include/linux/cpuset.h
> +++ b/include/linux/cpuset.h
> @@ -260,6 +260,8 @@ static inline bool cpuset_adaptive_nohz(void)
>  	 */
>  	return cpuset_cpu_adaptive_nohz(smp_processor_id());
>  }
> +
> +extern void cpuset_exit_nohz_interrupt(void *unused);
>  #else
>  static inline bool cpuset_cpu_adaptive_nohz(int cpu) { return false; }
>  static inline bool cpuset_adaptive_nohz(void) { return false; }
> diff --git a/kernel/cpuset.c b/kernel/cpuset.c
> index 6319d8e..1b67e5b 100644
> --- a/kernel/cpuset.c
> +++ b/kernel/cpuset.c
> @@ -1200,6 +1200,14 @@ static void cpuset_change_flag(struct task_struct *tsk,
>  
>  DEFINE_PER_CPU(atomic_t, cpu_adaptive_nohz_ref);
>  
> +static void cpu_exit_nohz(int cpu)
> +{
> +	preempt_disable();
> +	smp_call_function_single(cpu, cpuset_exit_nohz_interrupt,
> +				 NULL, true);
> +	preempt_enable();
> +}
> +
>  static void update_nohz_cpus(struct cpuset *old_cs, struct cpuset *cs)
>  {
>  	int cpu;
> @@ -1211,9 +1219,22 @@ static void update_nohz_cpus(struct cpuset *old_cs, struct cpuset *cs)
>  	for_each_cpu(cpu, cs->cpus_allowed) {
>  		atomic_t *ref = &per_cpu(cpu_adaptive_nohz_ref, cpu);
>  		if (is_adaptive_nohz(cs))
> -			atomic_inc(ref);
> +			val = atomic_inc_return(ref);
>  		else
> -			atomic_dec(ref);
> +			val = atomic_dec_return(ref);
> +
> +		if (!val) {
> +			/*
> +			 * The update to cpu_adaptive_nohz_ref must be
> +			 * visible right away. So that once we restart the tick
> +			 * from the IPI, it won't be stopped again due to cache
> +			 * update lag.
> +			 * FIXME: We probably need more to ensure this value is really
> +			 * visible right away.

What more do you want? stomp_machine()??

> +			 */
> +			smp_mb();

The atomic_inc_return() and atomic_dec_return() already imply a
smp_mb().

Later patches change this code, so I wont dwell on this patch too much.


> +			cpu_exit_nohz(cpu);
> +		}
>  	}
>  }
>  #else
> diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> index 0a5e650..de7de68 100644
> --- a/kernel/time/tick-sched.c
> +++ b/kernel/time/tick-sched.c
> @@ -884,6 +884,14 @@ void tick_nohz_check_adaptive(void)
>  	}
>  }
>  
> +void cpuset_exit_nohz_interrupt(void *unused)
> +{
> +	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
> +
> +	if (ts->tick_stopped && !is_idle_task(current))
> +		tick_nohz_restart_adaptive();

BTW, what a confusing name. "restart_adaptive()"? It sounds like we are
going to restart the adaptive code, like restarting NOHZ.

-- Steve

> +}
> +
>  void tick_nohz_post_schedule(void)
>  {
>  	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);


