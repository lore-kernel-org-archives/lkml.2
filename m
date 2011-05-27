Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758778Ab1E0JRt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 05:17:49 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:53854 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227Ab1E0JRs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 05:17:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=e279n1pfK0Q5Yt7GgfKDXtIbAmBdfBfUShAmZRHHgMx9UtarJfh3OgdVPcU/unEYfg
         rFdNQgCLMX5X0+be5jjqXX4wqtTumu4IZ/1H313v7r+4I4etMmpeM/URyr44BKgbz3mV
         8Ld/hoCgEUtopxkfi+6UC5xbV/7HhgI9arcNM=
MIME-Version: 1.0
In-Reply-To: <BANLkTin1QYAx7as41t78-n0giLSBWoToVA@mail.gmail.com>
References: <BANLkTin1QYAx7as41t78-n0giLSBWoToVA@mail.gmail.com>
Date: Fri, 27 May 2011 17:17:47 +0800
Message-ID: <BANLkTi=N8cm_9OKk8VCPVxPPn+Ejuhzq6w@mail.gmail.com>
Subject: Re: [PATCH] sched: remove noop in pre_schedule_rt()
From: Yong Zhang <yong.zhang0@gmail.com>
To: Hillf Danton <dhillf@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 26, 2011 at 9:08 PM, Hillf Danton <dhillf@gmail.com> wrote:
> Checking task to be RT is removed since only RT task is served here.
>
> Signed-off-by: Hillf Danton <dhillf@gmail.com>

Actually this patch has been raised for two times:
https://lkml.org/lkml/2010/12/13/622
http://lkml.org/lkml/2010/2/9/139

Thanks,
Yong

> ---
>
> --- tip-git/kernel/sched_rt.c   Sun May 22 20:12:01 2011
> +++ sched_rt.c  Thu May 26 21:11:19 2011
> @@ -1516,7 +1516,7 @@ skip:
>  static void pre_schedule_rt(struct rq *rq, struct task_struct *prev)
>  {
>        /* Try to pull RT tasks here if we lower this rq's prio */
> -       if (unlikely(rt_task(prev)) && rq->rt.highest_prio.curr > prev->prio)
> +       if (rq->rt.highest_prio.curr > prev->prio)
>                pull_rt_task(rq);
>  }
>



-- 
Only stand for myself
