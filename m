Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537Ab0HBP12 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 11:27:28 -0400
Received: from toq11.bellnexxia.net ([209.226.175.118]:44219 "EHLO
	toq11-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151Ab0HBP11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 11:27:27 -0400
X-Greylist: delayed 458 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Aug 2010 11:27:26 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAMd6VkxGGNu+/2dsb2JhbACgD3LCboU5BA
Date: Mon, 2 Aug 2010 11:14:46 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH 01/12] perf: Use tracepoint_synchronize_unregister() to
	flush any pending tracepoint call
Message-ID: <20100802151445.GA11747@Krystal>
References: <1280707993-6599-1-git-send-regression-fweisbec@gmail.com> <1280707993-6599-2-git-send-regression-fweisbec@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1280707993-6599-2-git-send-regression-fweisbec@gmail.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 11:14:27 up 117 days,  1:06,  2 users,  load average: 0.10, 0.20,
	0.10
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Frederic Weisbecker (fweisbec@gmail.com) wrote:
> We use synchronize_sched() to ensure a tracepoint won't be called
> while/after we release the perf buffers it references.
> 
> But the tracepoint API has its own API for that:
> tracepoint_synchronize_unregister(). Use it instead as it's
> self-explanatory and eases maintainance.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>

Acked-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

Thanks!

Mathieu

> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  kernel/trace/trace_event_perf.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
> index 2375165..000e6e8 100644
> --- a/kernel/trace/trace_event_perf.c
> +++ b/kernel/trace/trace_event_perf.c
> @@ -131,10 +131,10 @@ void perf_trace_destroy(struct perf_event *p_event)
>  	tp_event->class->reg(tp_event, TRACE_REG_PERF_UNREGISTER);
>  
>  	/*
> -	 * Ensure our callback won't be called anymore. See
> -	 * tracepoint_probe_unregister() and __DO_TRACE().
> +	 * Ensure our callback won't be called anymore. The buffers
> +	 * will be freed after that.
>  	 */
> -	synchronize_sched();
> +	tracepoint_synchronize_unregister();
>  
>  	free_percpu(tp_event->perf_events);
>  	tp_event->perf_events = NULL;
> -- 
> 1.6.2.3
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
