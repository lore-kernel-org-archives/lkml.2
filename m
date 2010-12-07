Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953Ab0LGDZr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 22:25:47 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58821 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905Ab0LGDZq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 22:25:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=fkDGLXZcLh0PDRn3XLuL3EY6FSrdI29jzuOZhsH4W53Eeo6fZC+yDDQmUSfzZJOGid
         wvOgEuTMsQbAuCGVzFnW20FOjvmDFqCeIqNIMaAuW4WXtp5T675n01QAzmfWCt0svWN1
         paEF4807LmrSu3LpRLf9D3UYwy3A8EZknmq5k=
MIME-Version: 1.0
In-Reply-To: <20101207021328.207196531@goodmis.org>
References: <20101207015834.196176991@goodmis.org>
	<20101207021328.207196531@goodmis.org>
Date: Tue, 7 Dec 2010 11:25:43 +0800
Message-ID: <AANLkTimO+aBQD530btPmH3o7j931KEmFP=GKia-039wO@mail.gmail.com>
Subject: Re: [RFC][PATCH 01/10] sched: Change rt_task(prev) in pre_schedule_rt
 to likely
From: Yong Zhang <yong.zhang0@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Gregory Haskins <ghaskins@novell.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 7, 2010 at 9:58 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> From: Steven Rostedt <srostedt@redhat.com>
>
> As found with the branch annotation profiler, the unlikely(rt_task(prev))
> in pre_schedule_rt() is always wrong. In fact it should be likely due to
> the fact that we got to this function because we used prev's scheduling
> class (which had to be rt).
>
> Change the unlikely(rt_task(prev)) to likely(rt_task(prev))

I have sent a more radical patch before but it get ignored.
http://marc.info/?l=linux-kernel&m=126572702600950&w=2

>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Gregory Haskins <ghaskins@novell.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  kernel/sched_rt.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
> index bea7d79..7a5c4db 100644
> --- a/kernel/sched_rt.c
> +++ b/kernel/sched_rt.c
> @@ -1474,7 +1474,7 @@ skip:
>  static void pre_schedule_rt(struct rq *rq, struct task_struct *prev)
>  {
>        /* Try to pull RT tasks here if we lower this rq's prio */
> -       if (unlikely(rt_task(prev)) && rq->rt.highest_prio.curr > prev->prio)
> +       if (likely(rt_task(prev)) && rq->rt.highest_prio.curr > prev->prio)

IMHO, we can delete the checking for rt_task(prev).
Or am I missing something?

Thanks,
Yong
