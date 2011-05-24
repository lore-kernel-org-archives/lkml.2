Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515Ab1EXIRm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 04:17:42 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:40425 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754102Ab1EXIRk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 04:17:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=if835UkoczNOGDJer2+OYPS8Y2Ugs+cfR7oXKmD3Xs1tmqYcpNpNjJHSIBEd6cCeKv
         /LgRNAccsZPbkMfcx4RWwhQDsbVc0fj3CFjtdQDUCvi0gMz7lTB9OxHfQP4YpCUIekkW
         ihjIBBl93YSINwpQMB0e2iJyZVam3tLdA0ip4=
MIME-Version: 1.0
In-Reply-To: <BANLkTimxmWiof9s5AvS3v_0X+sMiE=0x5g@mail.gmail.com>
References: <BANLkTimxmWiof9s5AvS3v_0X+sMiE=0x5g@mail.gmail.com>
Date: Tue, 24 May 2011 16:17:39 +0800
Message-ID: <BANLkTikhvhptDG-eRZ9uD5wSm3RxTn1RFw@mail.gmail.com>
Subject: Re: [PATCH] sched: remove noop in next_prio()
From: Yong Zhang <yong.zhang0@gmail.com>
To: Hillf Danton <dhillf@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Mike Galbraith <efault@gmx.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 21, 2011 at 10:19 PM, Hillf Danton <dhillf@gmail.com> wrote:
> When computing the next priority for a given run-queue, the check for
> RT priority of the task determined by the pick_next_highest_task_rt()
> function could be removed, since only RT task is returned by the
> function.
>
> Signed-off-by: Hillf Danton <dhillf@gmail.com>

Yup, it's true.

Reviewed-by: Yong Zhang <yong.zhang0@gmail.com>

> ---
>
> --- a/kernel/sched_rt.c 2011-04-27 11:48:50.000000000 +0800
> +++ b/kernel/sched_rt.c 2011-05-21 22:10:34.000000000 +0800
> @@ -670,7 +670,7 @@ static inline int next_prio(struct rq *r
>  {
>        struct task_struct *next = pick_next_highest_task_rt(rq, rq->cpu);
>
> -       if (next && rt_prio(next->prio))
> +       if (next)
>                return next->prio;
>        else
>                return MAX_RT_PRIO;
>



-- 
Only stand for myself
