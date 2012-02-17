Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779Ab2BQWKM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 17:10:12 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:41485 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651Ab2BQWKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 17:10:10 -0500
Date: Fri, 17 Feb 2012 14:10:05 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Hugh Dickins <hughd@google.com>
Cc: "Paul E. McKenney" <paul.mckenney@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH next] rcu: stop spurious warnings from
 synchronize_sched_expedited
Message-ID: <20120217221005.GX2976@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <alpine.LSU.2.00.1202171318010.5994@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1202171318010.5994@eggly.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12021722-3270-0000-0000-0000041E8345
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 17, 2012 at 01:20:31PM -0800, Hugh Dickins wrote:
> synchronize_sched_expedited() is spamming CONFIG_DEBUG_PREEMPT=y
> users with an unintended warning from the cpu_is_offline() check:
> use raw_smp_processor_id() instead of smp_processor_id() there.

Good catch!  Queued.

						Thanx, Paul

> Signed-off-by: Hugh Dickins <hughd@google.com>
> ---
> 
>  kernel/rcutree.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- next/kernel/rcutree.c	2012-02-17 08:02:15.680065066 -0800
> +++ linux/kernel/rcutree.c	2012-02-17 10:41:18.764003566 -0800
> @@ -2014,7 +2014,7 @@ void synchronize_sched_expedited(void)
>  	/* Note that atomic_inc_return() implies full memory barrier. */
>  	firstsnap = snap = atomic_inc_return(&sync_sched_expedited_started);
>  	get_online_cpus();
> -	WARN_ON_ONCE(cpu_is_offline(smp_processor_id()));
> +	WARN_ON_ONCE(cpu_is_offline(raw_smp_processor_id()));
> 
>  	/*
>  	 * Each pass through the following loop attempts to force a
> 

