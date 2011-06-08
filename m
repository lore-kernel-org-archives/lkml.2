Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756642Ab1FHXXe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 19:23:34 -0400
Received: from blu0-omc1-s9.blu0.hotmail.com ([65.55.116.20]:29228 "EHLO
	blu0-omc1-s9.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754011Ab1FHXXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 19:23:32 -0400
X-Greylist: delayed 363 seconds by postgrey-1.27 at vger.kernel.org; Wed, 08 Jun 2011 19:23:32 EDT
X-Originating-IP: [184.145.208.36]
X-Originating-Email: [pdumas9@sympatico.ca]
Message-ID: <BLU0-SMTP6812EDF7FA2A59A528E8FD96620@phx.gbl>
Date: Wed, 8 Jun 2011 19:23:29 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org, josh@joshtriplett.org,
        niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        eric.dumazet@gmail.com, darren@dvhart.com, patches@linaro.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH tip/core/rcu 07/28] Fix mismatched variable in
	rcutree_trace.c
References: <20110608192943.GA13211@linux.vnet.ibm.com> <1307561407-13809-7-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1307561407-13809-7-git-send-email-paulmck@linux.vnet.ibm.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 19:21:16 up 427 days,  9:10,  5 users,  load average: 0.03, 0.14,
	0.13
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 08 Jun 2011 23:23:31.0705 (UTC) FILETIME=[148FAE90:01CC2633]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> rcutree.c defines rcu_cpu_kthread_cpu as int, not unsigned int,
> so the extern has to follow that.

How comes this discrepancy was made possible in the first place ? This
declaration should appear in a header included by both rcutree_trace.c
and rcutree.c, which would have permitted the compiler to detect this.

Maybe kernel/rcutree.h would be a good location for these ?

Mathieu

> 
> Cc: paulmck@linux.vnet.ibm.com
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
>  kernel/rcutree_trace.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
> index 9678cc3..91c56e5 100644
> --- a/kernel/rcutree_trace.c
> +++ b/kernel/rcutree_trace.c
> @@ -47,7 +47,7 @@
>  #include "rcutree.h"
>  
>  DECLARE_PER_CPU(unsigned int, rcu_cpu_kthread_status);
> -DECLARE_PER_CPU(unsigned int, rcu_cpu_kthread_cpu);
> +DECLARE_PER_CPU(int, rcu_cpu_kthread_cpu);
>  DECLARE_PER_CPU(unsigned int, rcu_cpu_kthread_loops);
>  DECLARE_PER_CPU(char, rcu_cpu_has_work);
>  
> -- 
> 1.7.3.2
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
