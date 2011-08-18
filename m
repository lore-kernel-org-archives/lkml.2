Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755662Ab1HRN5V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 09:57:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:34999 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755057Ab1HRN5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 09:57:20 -0400
X-Authority-Analysis: v=1.1 cv=YhhhcVvq/Bf3xBNEvzTEV9JHGW2mXul7kEbaqsyQnMQ= c=1 sm=0 a=-Of2mRJSN24A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=SEF7xSSsAAAA:8 a=tHz9FfFoAAAA:8 a=20KFwNOVAAAA:8 a=pGLkceISAAAA:8 a=meVymXHHAAAA:8 a=rpu6-H9zEVN-ypFMwo4A:9 a=UbC8QpBdul44iZe74GQA:7 a=PUjeQqilurYA:10 a=6O0IECtVFhoA:10 a=LI9Vle30uBYA:10 a=jEp0ucaQiEUA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] signals: move trace header #include to after all
 others.
From: Steven Rostedt <rostedt@goodmis.org>
To: Ian Campbell <ian.campbell@citrix.com>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
In-Reply-To: <1313675198-7413-1-git-send-email-ian.campbell@citrix.com>
References: <1313675198-7413-1-git-send-email-ian.campbell@citrix.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 18 Aug 2011 09:57:17 -0400
Message-ID: <1313675838.15704.69.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-08-18 at 14:46 +0100, Ian Campbell wrote:
> Steven Rostedt says:
>     The trace events headers are suppose to be the last headers
>     included.
> and this fixes a build error when another header already includes trace stuff,
> which I saw when adding a highmem.h include to skbuff.h e.g.:
> In file included from include/trace/ftrace.h:296:0,
>                  from include/trace/define_trace.h:96,
>                  from include/trace/events/irq.h:150,
>                  from include/linux/interrupt.h:23,
>                  from arch/x86/include/asm/highmem.h:23,
>                  from include/linux/highmem.h:33,
>                  from include/linux/skbuff.h:32,
>                  from kernel/audit.h:24,
>                  from kernel/signal.c:38:
> include/trace/events/irq.h: In function 'ftrace_raw_output_softirq':
> include/trace/events/irq.h:87:1: error: 'HI_SOFTIRQ' undeclared (first use in this function)
> include/trace/events/irq.h:87:1: note: each undeclared identifier is reported only once for each function it appears in
> include/trace/events/irq.h:87:1: error: 'TIMER_SOFTIRQ' undeclared (first use in this function)
> include/trace/events/irq.h:87:1: error: 'NET_TX_SOFTIRQ' undeclared (first use in this function)
> include/trace/events/irq.h:87:1: error: 'NET_RX_SOFTIRQ' undeclared (first use in this function)
> include/trace/events/irq.h:87:1: error: 'BLOCK_SOFTIRQ' undeclared (first use in this function)
> include/trace/events/irq.h:87:1: error: 'BLOCK_IOPOLL_SOFTIRQ' undeclared (first use in this function)
> include/trace/events/irq.h:87:1: error: 'TASKLET_SOFTIRQ' undeclared (first use in this function)
> include/trace/events/irq.h:87:1: error: 'SCHED_SOFTIRQ' undeclared (first use in this function)
> include/trace/events/irq.h:87:1: error: 'HRTIMER_SOFTIRQ' undeclared (first use in this function)
> include/trace/events/irq.h:87:1: error: 'RCU_SOFTIRQ' undeclared (first use in this function)
> 
> See http://lkml.kernel.org/r/1313668307.5010.300.camel@zakaz.uk.xensource.com
> 
> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@redhat.com>

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

> ---
>  kernel/signal.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/signal.c b/kernel/signal.c
> index 291c970..d3cd4e7 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -28,8 +28,6 @@
>  #include <linux/freezer.h>
>  #include <linux/pid_namespace.h>
>  #include <linux/nsproxy.h>
> -#define CREATE_TRACE_POINTS
> -#include <trace/events/signal.h>
>  
>  #include <asm/param.h>
>  #include <asm/uaccess.h>
> @@ -37,6 +35,9 @@
>  #include <asm/siginfo.h>
>  #include "audit.h"	/* audit_signal_info() */
>  
> +#define CREATE_TRACE_POINTS
> +#include <trace/events/signal.h>
> +
>  /*
>   * SLAB caches for signal bits.
>   */


