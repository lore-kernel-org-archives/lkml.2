Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753596Ab1FNCaG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 22:30:06 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:48774 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899Ab1FNCaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 22:30:03 -0400
Subject: Re: BUG on 3.0-rc on commit
 d72bce0e67e8afc6eb959f656013cbb577426f1e
From: Andrew Theurer <habanero@linux.vnet.ibm.com>
Reply-To: habanero@linux.vnet.ibm.com
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        paulmck <paulmck@linux.vnet.ibm.com>
In-Reply-To: <1308014683.9218.107.camel@gandalf.stny.rr.com>
References: <1307711837.23688.33.camel@atheurer-ubuntu10>
	 <1307715084.3941.166.camel@twins>  <1307717156.3941.169.camel@twins>
	 <1307720081.17297.6.camel@atheurer-w510>  <1307723232.3941.178.camel@twins>
	 <1307977614.17297.12.camel@atheurer-w510>
	 <1307979239.9218.76.camel@gandalf.stny.rr.com>
	 <1308009910.23688.34.camel@atheurer-ubuntu10>
	 <1308014683.9218.107.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 13 Jun 2011 21:29:54 -0500
Message-ID: <1308018594.23688.36.camel@atheurer-ubuntu10>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-13 at 21:24 -0400, Steven Rostedt wrote:
> On Mon, 2011-06-13 at 19:05 -0500, Andrew Theurer wrote:
> 
> > > Could you try this patch?
> > 
> > Yes, and it works!  Thanks very much!
> 
> Could you try this patch instead? I don't like holding off migration for
> the entire boot processes.

Sure, just tested this one, and it works fine as well.

-Andrew
> 
> -- Steve
> 
> diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
> index 88725c9..4505bfb 100644
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
> 
> 


