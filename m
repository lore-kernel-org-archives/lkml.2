Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933274Ab2GEWzl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 18:55:41 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:56710 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932163Ab2GEWzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 18:55:40 -0400
X-Originating-IP: 217.70.178.130
X-Originating-IP: 50.43.46.74
Date: Thu, 5 Jul 2012 15:55:25 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org
Subject: Re: [PATCH tip/core/rcu] Introduce check for callback list/count
 mismatch
Message-ID: <20120705225525.GA26150@leaf>
References: <20120705223319.GA27331@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120705223319.GA27331@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 05, 2012 at 03:33:19PM -0700, Paul E. McKenney wrote:
> The recent bug that introduced the RCU callback list/count mismatch
> showed the need for a diagnostic to check for this, which this patch
> adds.
> 
> Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index 95c7b61..4154c95 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -1612,6 +1612,7 @@ static void rcu_do_batch(struct rcu_state *rsp, struct rcu_data *rdp)
>  		rdp->n_force_qs_snap = rsp->n_force_qs;
>  	} else if (rdp->qlen < rdp->qlen_last_fqs_check - qhimark)
>  		rdp->qlen_last_fqs_check = rdp->qlen;
> +	WARN_ON_ONCE((rdp->nxtlist == NULL) != (rdp->qlen == 0));
>  
>  	local_irq_restore(flags);
>  
> 
