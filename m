Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964961Ab1C3Vg3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:36:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16164 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933639Ab1C3VgZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:36:25 -0400
Date: Wed, 30 Mar 2011 23:35:53 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH,RFC] perf: panic due to inclied cpu context task_ctx
	value
Message-ID: <20110330213553.GA20571@redhat.com>
References: <20110326173545.GA22919@redhat.com> <1301164168.2250.370.camel@laptop> <20110328133033.GA8254@redhat.com> <1301324275.4859.25.camel@twins> <1301327368.4859.28.camel@twins> <20110328165648.GA9304@redhat.com> <20110330130951.GA2124@jolsa.brq.redhat.com> <1301496684.4859.192.camel@twins> <20110330163730.GA6038@redhat.com> <1301520405.4859.213.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301520405.4859.213.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/30, Peter Zijlstra wrote:
>
> Anyway how about we do the partial revert below that should get us back
> to a working kernel and is a nice small patch to send -stable wards.
>
> After that we can try and be clever with clearing ->task_ctx from things
> like remove_from_context and the like.
>
> ---
>  include/linux/perf_event.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index 311b4dc..04d75a8 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -1086,7 +1086,7 @@ void perf_event_task_sched_out(struct task_struct *task, struct task_struct *nex
>  {
>  	perf_sw_event(PERF_COUNT_SW_CONTEXT_SWITCHES, 1, 1, NULL, 0);
>
> -	COND_STMT(&perf_sched_events, __perf_event_task_sched_out(task, next));
> +	__perf_event_task_sched_out(task, next);
>  }

I agree completely. We need the simple (and suitable for stable) fix first.

Oleg.

