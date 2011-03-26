Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751526Ab1CZRo4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 13:44:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12740 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750731Ab1CZRoz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 13:44:55 -0400
Date: Sat, 26 Mar 2011 18:35:45 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH,RFC] perf: panic due to inclied cpu context task_ctx
	value
Message-ID: <20110326173545.GA22919@redhat.com>
References: <20110324164436.GC1930@jolsa.brq.redhat.com> <1301153868.2250.359.camel@laptop> <20110326161346.GA18272@redhat.com> <1301157483.2250.366.camel@laptop> <20110326170922.GA20329@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110326170922.GA20329@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/26, Oleg Nesterov wrote:
>
> On 03/26, Peter Zijlstra wrote:
> >
> > diff --git a/kernel/perf_event.c b/kernel/perf_event.c
> > index c75925c..e9e4e35 100644
> > --- a/kernel/perf_event.c
> > +++ b/kernel/perf_event.c
> > @@ -1073,6 +1073,8 @@ event_sched_out(struct perf_event *event,
> >  	if (!is_software_event(event))
> >  		cpuctx->active_oncpu--;
> >  	ctx->nr_active--;
> > +	if (!ctx->nr_active && cpuctx->task_ctx == ctx)
> > +		cpuctx->task_ctx = NULL;
>
> If we clear cpuctx->task_ctx, we should also clear ctx->is_active.
>
> Otherwise I can't see any problem, but I do not understand this code
> enough.

but probably we also need update_context_time().

Oleg.

