Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240Ab2ICJbw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 05:31:52 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:47330 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756085Ab2ICJbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 05:31:51 -0400
X-Originating-IP: 217.70.178.129
X-Originating-IP: 50.43.46.74
Date: Mon, 3 Sep 2012 02:31:43 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org
Subject: Re: [PATCH tip/core/rcu 14/23] rcu: Remove now-unused rcu_state
 fields
Message-ID: <20120903093143.GC5574@leaf>
References: <20120830181811.GA29154@linux.vnet.ibm.com>
 <1346350718-30937-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1346350718-30937-14-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346350718-30937-14-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2012 at 11:18:29AM -0700, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> 
> Moving the RCU grace-period processing to a kthread and adjusting the
> tracing resulted in two of the rcu_state structure's fields being unused.
> This commit therefore removes them.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  kernel/rcutree.h |    7 -------
>  1 files changed, 0 insertions(+), 7 deletions(-)
> 
> diff --git a/kernel/rcutree.h b/kernel/rcutree.h
> index 2d4cc18..8f0293c 100644
> --- a/kernel/rcutree.h
> +++ b/kernel/rcutree.h
> @@ -378,13 +378,6 @@ struct rcu_state {
>  
>  	u8	fqs_state ____cacheline_internodealigned_in_smp;
>  						/* Force QS state. */
> -	u8	fqs_active;			/* force_quiescent_state() */
> -						/*  is running. */
> -	u8	fqs_need_gp;			/* A CPU was prevented from */
> -						/*  starting a new grace */
> -						/*  period because */
> -						/*  force_quiescent_state() */
> -						/*  was running. */
>  	u8	boost;				/* Subject to priority boost. */
>  	unsigned long gpnum;			/* Current gp number. */
>  	unsigned long completed;		/* # of last completed gp. */
> -- 
> 1.7.8
> 
