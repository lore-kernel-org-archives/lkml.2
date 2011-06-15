Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779Ab1FOISO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 04:18:14 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40724 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752201Ab1FOISL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 04:18:11 -0400
Subject: Re: [PATCH 2/2] sched: Check if lowest_mask is initialized in
 find_lowest_rq
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Andrew Theurer <habanero@linux.vnet.ibm.com>
In-Reply-To: <20110614223657.824872966@goodmis.org>
References: <20110614223623.876681637@goodmis.org>
	 <20110614223657.824872966@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 15 Jun 2011 10:17:41 +0200
Message-ID: <1308125861.15315.2.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-14 at 18:36 -0400, Steven Rostedt wrote:
> plain text document attachment
> (0002-sched-Check-if-lowest_mask-is-initialized-in-find_lo.patch)
> From: Steven Rostedt <rostedt@goodmis.org>
> 
> On system boot up, the lowest_mask is initialized with early_initcall.
> But RT tasks may wake up on other early_initcall callers before the
> lowest_mask is initialized, causing a system crash.
> 
> The commit d72bce0e67 rcu: Cure load woes
> was the first commit to wake up RT tasks in early init. Before this
> commit this bug should not happen.
> 

Acked-by: Peter Zijlstra <peterz@infradead.org>

> Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>
> Reported-by: Andrew Theurer <habanero@linux.vnet.ibm.com>
> Tested-by: Andrew Theurer <habanero@linux.vnet.ibm.com>
> Link: http://lkml.kernel.org/r/1308014683.9218.107.camel@gandalf.stny.rr.com
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  kernel/sched_rt.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
> index 9b8d5dc..10d0182 100644
> --- a/kernel/sched_rt.c
> +++ b/kernel/sched_rt.c
> @@ -1239,6 +1239,10 @@ static int find_lowest_rq(struct task_struct *task)
>  	int this_cpu = smp_processor_id();
>  	int cpu      = task_cpu(task);
>  
> +	/* Make sure the mask is initialized first */
> +	if (unlikely(!lowest_mask))
> +		return -1;
> +
>  	if (task->rt.nr_cpus_allowed == 1)
>  		return -1; /* No other targets possible */
>  

