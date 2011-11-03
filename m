Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974Ab1KCHlR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 03:41:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63503 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752121Ab1KCHlQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 03:41:16 -0400
Date: Thu, 3 Nov 2011 09:41:04 +0200
From: Gleb Natapov <gleb@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH] perf: do not set task_ctx pointer in cpuctx if there is
 no events in the context
Message-ID: <20111103074104.GG14726@redhat.com>
References: <20111023171033.GI17571@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111023171033.GI17571@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo, Peter can you look into this please.

On Sun, Oct 23, 2011 at 07:10:33PM +0200, Gleb Natapov wrote:
> Do not set task_ctx pointer during sched_in if there is no
> events associated with the context.  Otherwise if during task
> execution total number of events in the system will become zero
> perf_event_context_sched_out() will not be called and cpuctx->task_ctx
> will be left with a stale value.
> 
> Signed-off-by: Gleb Natapov <gleb@redhat.com>
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index 0f85778..68b13ee 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -2172,7 +2172,8 @@ static void perf_event_context_sched_in(struct perf_event_context *ctx,
>  
>  	perf_event_sched_in(cpuctx, ctx, task);
>  
> -	cpuctx->task_ctx = ctx;
> +	if (ctx->nr_events)
> +		cpuctx->task_ctx = ctx;
>  
>  	perf_pmu_enable(ctx->pmu);
>  	perf_ctx_unlock(cpuctx, ctx);
> --
> 			Gleb.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--
			Gleb.
