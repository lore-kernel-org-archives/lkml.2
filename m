Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755791Ab0KKThY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 14:37:24 -0500
Received: from canuck.infradead.org ([134.117.69.58]:42360 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754502Ab0KKThX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 14:37:23 -0500
Subject: Re: [RFC][PATCH 12/22] sched: add runtime reporting for -deadline
 tasks
From: Peter Zijlstra <peterz@infradead.org>
To: Raistlin <raistlin@linux.it>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Chris Friesen <cfriesen@nortel.com>, oleg@redhat.com,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Darren Hart <darren@dvhart.com>, Johan Eker <johan.eker@ericsson.com>,
        "p.faure" <p.faure@akatech.ch>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Claudio Scordino <claudio@evidence.eu.com>,
        michael trimarchi <trimarchi@retis.sssup.it>,
        Fabio Checconi <fabio@gandalf.sssup.it>,
        Tommaso Cucinotta <cucinotta@sssup.it>,
        Juri Lelli <juri.lelli@gmail.com>,
        Nicola Manica <nicola.manica@disi.unitn.it>,
        Luca Abeni <luca.abeni@unitn.it>, Dhaval Giani <dhaval@retis.sssup.it>,
        Harald Gustafsson <hgu1972@gmail.com>,
        paulmck <paulmck@linux.vnet.ibm.com>
In-Reply-To: <1288334202.8661.153.camel@Palantir>
References: <1288333128.8661.137.camel@Palantir>
	 <1288334202.8661.153.camel@Palantir>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 11 Nov 2010 20:37:03 +0100
Message-ID: <1289504223.2084.174.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-29 at 08:36 +0200, Raistlin wrote:
> Make it available for the user-space the total amount of runtime
> time it has used from since it became a -deadline task.
> 
> This is something that is typically useful for monitoring from
> user-space the task CPU usage, and maybe implementing at that level
> some more sophisticated scheduling behaviour.
> 
> One example is feedback scheduling, where you try to adapt the
> scheduling parameters of a task by looking at its behaviour in
> a certain interval of time, applying concepts coming from control
> engineering.
> 
> Signed-off-by: Dario Faggioli <raistlin@linux.it>
> ---
>  include/linux/sched.h |    7 +++----
>  kernel/sched.c        |    3 +++
>  kernel/sched_debug.c  |    1 +
>  kernel/sched_dl.c     |    1 +
>  4 files changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 8ae947b..b6f0635 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1242,14 +1242,15 @@ struct sched_rt_entity {
>  #endif
>  };
>  
> -#ifdef CONFIG_SCHEDSTATS
>  struct sched_stats_dl {
> +#ifdef CONFIG_SCHEDSTATS
>  	u64			last_dmiss;
>  	u64			last_rorun;
>  	u64			dmiss_max;
>  	u64			rorun_max;
> -};
>  #endif
> +	u64			tot_rtime;
> +};
>  

I know we agreed to pull this from the sched_param2 structure and delay
exposing this information for a while until the base patches got merged
and came up with a solid use-case, but reading this patch makes me
wonder why tsk->se.sum_exec_runtime isn't good enough?
