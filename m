Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924Ab1BWOgx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 09:36:53 -0500
Received: from blu0-omc1-s2.blu0.hotmail.com ([65.55.116.13]:35335 "EHLO
	blu0-omc1-s2.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750823Ab1BWOgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 09:36:52 -0500
X-Originating-IP: [174.91.193.52]
X-Originating-Email: [pdumas9@sympatico.ca]
Message-ID: <BLU0-SMTP163E6A66B4089FBA19C6BF96DB0@phx.gbl>
Date: Wed, 23 Feb 2011 09:36:49 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org, josh@joshtriplett.org,
        niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        eric.dumazet@gmail.com, darren@dvhart.com,
        Amerigo Wang <amwang@redhat.com>
Subject: Re: [PATCH RFC tip/core/rcu 04/11] rcupdate: remove dead code
References: <20110223013917.GA20996@linux.vnet.ibm.com> <1298425183-21265-4-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1298425183-21265-4-git-send-email-paulmck@linux.vnet.ibm.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 09:04:55 up 321 days, 23:54,  6 users,  load average: 1.59, 1.63,
	1.57
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 23 Feb 2011 14:36:51.0778 (UTC) FILETIME=[1C29BA20:01CBD367]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> From: Amerigo Wang <amwang@redhat.com>
> 
> DEBUG_OBJECTS_RCU_HEAD depends on PREEMPT, so #ifndef CONFIG_PREEMPT
> is totally useless in kernel/rcupdate.c.

Why does it depend on PREEMPT exactly ? Only for the fixup ?

Thanks,

Mathieu

> 
> Signed-off-by: WANG Cong <amwang@redhat.com>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
>  kernel/rcupdate.c |    5 -----
>  1 files changed, 0 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
> index a23a57a..afd21d1 100644
> --- a/kernel/rcupdate.c
> +++ b/kernel/rcupdate.c
> @@ -215,10 +215,6 @@ static int rcuhead_fixup_free(void *addr, enum debug_obj_state state)
>  		 * If we detect that we are nested in a RCU read-side critical
>  		 * section, we should simply fail, otherwise we would deadlock.
>  		 */
> -#ifndef CONFIG_PREEMPT
> -		WARN_ON(1);
> -		return 0;
> -#else
>  		if (rcu_preempt_depth() != 0 || preempt_count() != 0 ||
>  		    irqs_disabled()) {
>  			WARN_ON(1);
> @@ -229,7 +225,6 @@ static int rcuhead_fixup_free(void *addr, enum debug_obj_state state)
>  		rcu_barrier_bh();
>  		debug_object_free(head, &rcuhead_debug_descr);
>  		return 1;
> -#endif
>  	default:
>  		return 0;
>  	}
> -- 
> 1.7.3.2
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
