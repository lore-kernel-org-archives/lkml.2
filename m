Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756013Ab2HVFGP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 01:06:15 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:46734 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753091Ab2HVFGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 01:06:12 -0400
Date: Tue, 21 Aug 2012 22:05:40 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: linux-next: manual merge of the rcu tree with the tip tree
Message-ID: <20120822050540.GC2531@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120822142735.5366c9abdee5274329e65fe3@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120822142735.5366c9abdee5274329e65fe3@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12082205-1780-0000-0000-0000089E95AF
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000293; HX=3.00000196; KW=3.00000007;
 PH=3.00000001; SC=3.00000007; SDB=6.00167419; UDB=6.00037924; UTC=2012-08-22
 05:06:10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2012 at 02:27:35PM +1000, Stephen Rothwell wrote:
> Hi Paul,
> 
> Today's linux-next merge of the rcu tree got a conflict in
> kernel/rcutree.h between commit 62ab7072476a ("rcu: Use
> smp_hotplug_thread facility for RCUs per-CPU kthread") from the tip tree
> and commit daa5d37ff51b ("rcu: Prevent force_quiescent_state() memory
> contention") from the rcu tree.
> 
> Just context changes (I think).  I fixed it up (see below) and can carry
> the fix as necessary.

This one also looks correct.

							Thanx, Paul

> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc kernel/rcutree.h
> index 1224d4c,c2a3e7d..0000000
> --- a/kernel/rcutree.h
> +++ b/kernel/rcutree.h
> @@@ -196,6 -200,13 +200,7 @@@ struct rcu_node 
>   				/* Refused to boost: not sure why, though. */
>   				/*  This can happen due to race conditions. */
>   #endif /* #ifdef CONFIG_RCU_BOOST */
>  -	struct task_struct *node_kthread_task;
>  -				/* kthread that takes care of this rcu_node */
>  -				/*  structure, for example, awakening the */
>  -				/*  per-CPU kthreads as needed. */
>  -	unsigned int node_kthread_status;
>  -				/* State of node_kthread_task for tracing. */
> + 	raw_spinlock_t fqslock ____cacheline_internodealigned_in_smp;
>   } ____cacheline_internodealigned_in_smp;
>   
>   /*


