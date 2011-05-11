Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578Ab1EKQLy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:11:54 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34313 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756982Ab1EKQJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:09:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=V3TI8GIgARNB6Vr1KrDaYtPlLXQMhVybeuAFcBxv+ya2qEgpGpo4hQ5QZIUXAjFeHL
         c+CdQCgcSrt/yRm5N7XXq69D/3ksrcr6ThMHbJxT8NYUl/Wp+JnOZQx8kv0z3U4cVJ/V
         Sd6a3IlErFetMRONq4A/tM5z+oadMNrmew+9M=
Date: Wed, 11 May 2011 15:30:12 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Borislav Petkov <bp@amd64.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH 2/2] perf: Carve out callchain functionality
Message-ID: <20110511133009.GA1846@nowhere>
References: <1305119816-26280-1-git-send-email-bp@amd64.org>
 <1305119816-26280-3-git-send-email-bp@amd64.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305119816-26280-3-git-send-email-bp@amd64.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 11, 2011 at 03:16:56PM +0200, Borislav Petkov wrote:
> From: Borislav Petkov <borislav.petkov@amd.com>
> 
> Move callchain-related code into its own module:
> kernel/events/callchain.c
> 
> No functionality change.
> 
> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> ---
>  include/linux/perf_event.h |    7 +-
>  kernel/events/Makefile     |    2 +-
>  kernel/events/callchain.c  |  182 +++++++++++++++++++++++++++++++++
>  kernel/events/core.c       |  237 +++++--------------------------------------
>  4 files changed, 217 insertions(+), 211 deletions(-)
>  create mode 100644 kernel/events/callchain.c
> 
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index 687f852..7978850 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -961,7 +961,6 @@ enum event_type_t {
>  };
>  
>  #ifdef CONFIG_PERF_EVENTS
> -
>  extern struct list_head pmus;
>  extern int perf_pmu_register(struct pmu *pmu, char *name, int type);
>  extern void perf_pmu_unregister(struct pmu *pmu);
> @@ -1201,6 +1200,12 @@ static inline void cpu_ctx_sched_in(struct perf_cpu_context *cpuctx,
>  extern int
>  task_function_call(struct task_struct *p, int (*func) (void *info), void *info);
>  extern u64 perf_event_time(struct perf_event *event);
> +
> +extern int get_recursion_context(int *recursion);
> +extern inline void put_recursion_context(int *recursion, int rctx);
> +extern void put_callchain_buffers(void);
> +extern struct perf_callchain_entry *perf_callchain(struct pt_regs *regs);
> +extern int get_callchain_buffers(void);

I think it would be better to have these in a private kernel/events/events.h

Other than that, looks good, thanks.

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
