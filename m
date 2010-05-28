Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752036Ab0E1Edr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 00:33:47 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:55081 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071Ab0E1Edq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 00:33:46 -0400
Date: Fri, 28 May 2010 10:03:39 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: "Luis Claudio R. Goncalves" <lclaudio@uudg.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       David Rientjes <rientjes@google.com>, Mel Gorman <mel@csn.ul.ie>,
       williams@redhat.com
Subject: Re: [RFC] oom-kill: give the dying task a higher priority
Message-ID: <20100528043339.GZ3519@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20100527180431.GP13035@uudg.org>
 <20100527183319.GA22313@redhat.com>
 <20100528090357.7DFB.A69D9226@jp.fujitsu.com>
 <20100528035147.GD11364@uudg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100528035147.GD11364@uudg.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Luis Claudio R. Goncalves <lclaudio@uudg.org> [2010-05-28 00:51:47]:

> @@ -382,6 +382,8 @@ static void dump_header(struct task_struct *p, gfp_t gfp_mask, int order,
>   */
>  static void __oom_kill_task(struct task_struct *p, int verbose)
>  {
> +	struct sched_param param;
> +
>  	if (is_global_init(p)) {
>  		WARN_ON(1);
>  		printk(KERN_WARNING "tried to kill init!\n");
> @@ -413,8 +415,9 @@ static void __oom_kill_task(struct task_struct *p, int verbose)
>  	 */
>  	p->rt.time_slice = HZ;
>  	set_tsk_thread_flag(p, TIF_MEMDIE);
> -
>  	force_sig(SIGKILL, p);
> +	param.sched_priority = MAX_RT_PRIO-1;
> +	sched_setscheduler_nocheck(p, SCHED_FIFO, &param);
>  }
>

I would like to understand the visible benefits of this patch. Have
you seen an OOM kill tasked really get bogged down. Should this task
really be competing with other important tasks for run time?

-- 
	Three Cheers,
	Balbir
