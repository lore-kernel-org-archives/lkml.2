Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757834Ab2FOUaY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 16:30:24 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:53143 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757465Ab2FOUaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 16:30:23 -0400
X-Originating-IP: 217.70.178.136
X-Originating-IP: 50.43.46.74
Date: Fri, 15 Jun 2012 13:30:08 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH tip/core/rcu 5/6] rcu: Fix diagnostic-printk typo in
 rcutorture
Message-ID: <20120615203008.GD31184@leaf>
References: <20120615185725.GA25163@linux.vnet.ibm.com>
 <1339786674-25265-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1339786674-25265-5-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339786674-25265-5-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2012 at 11:57:53AM -0700, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paul.mckenney@linaro.org>
> 
> The rcu_torture_barrier() function has a copy-and-paste typo in the
> string passed to rcutorture_shutdown_absorb(), which this commit fixes.
> 
> Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

> ---
>  kernel/rcutorture.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
> index 08d8537..54a3745 100644
> --- a/kernel/rcutorture.c
> +++ b/kernel/rcutorture.c
> @@ -1700,7 +1700,7 @@ static int rcu_torture_barrier(void *arg)
>  		schedule_timeout_interruptible(HZ / 10);
>  	} while (!kthread_should_stop() && fullstop == FULLSTOP_DONTSTOP);
>  	VERBOSE_PRINTK_STRING("rcu_torture_barrier task stopping");
> -	rcutorture_shutdown_absorb("rcu_torture_barrier_cbs");
> +	rcutorture_shutdown_absorb("rcu_torture_barrier");
>  	while (!kthread_should_stop())
>  		schedule_timeout_interruptible(1);
>  	return 0;
> -- 
> 1.7.8
> 
