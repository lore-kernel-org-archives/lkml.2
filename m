Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932764Ab1ERCbz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 22:31:55 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:50144 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753722Ab1ERCby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 22:31:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=tmR6e4CVV2RI6WBeTFchdviLPqYz9US3uLcymJkHU0J9sQJ1e5vV60N69QWgTiF4bS
         dFLp68el7PBWLqZlDLGd67fKWMxcI7zWy2qMrruDg5o0cJzSXoyCDv09ylJTwrdqIG7f
         lbEl1kiCsWhizMMOD/1CFtVwb+XaLTxURYEms=
MIME-Version: 1.0
In-Reply-To: <20110518013842.GD23940@home.goodmis.org>
References: <BANLkTikkeR_yf1HGhgq7WEO-kEvDGkV_tw@mail.gmail.com>
	<BANLkTim4n-WA_6nJpg4Nd99yuc3f+VWkcw@mail.gmail.com>
	<BANLkTikOecxhb8pZfAd19FLrPAPY4zacDQ@mail.gmail.com>
	<20110512120606.GA3639@zhy>
	<20110518013842.GD23940@home.goodmis.org>
Date: Wed, 18 May 2011 10:31:53 +0800
Message-ID: <BANLkTikOW9t6F8jvTJ0uPvyYDy+mpXh-DA@mail.gmail.com>
Subject: Re: [PATCH] sched: correct how RT task is picked
From: Yong Zhang <yong.zhang0@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Hillf Danton <dhillf@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Mike Galbraith <efault@gmx.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 18, 2011 at 9:38 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
>> I think you can take a look at next_prio(), it just calculate the
>> next highest task on the current cpu; in this case,
>> cpumask_test_cpu(cpu, &p->cpus_allowed) will be true for the most
>> of time, but maybe that task is bound to this cpu.
>
> I've been looking at the history here, and I think that '-1' is a relic.
>
> If you look at sched_rt.c in f65eda4f789168ba5ff3fa75546c29efeed19f58:
>
> $ git show f65eda4f:kernel/sched_rt.c
>
> You'll see that push_rt_task calls pick_next_highest_task_rt() with a
> -1. That code has long been replaced.

Yeah, the condition "cpu < 0" could be removed since we have no
that kind of caller.

>
> I'm a bit nervous about taking Hillf's patch as is. But a little more
> reviewing and testing may prove that it is legit.

But another point is like I said before:
'cpumask_test_cpu(cpu, &p->cpus_allowed)' doesn't equal to
'p->rt.nr_cpus_allowed > 1' because we could have bounded
task.
So the condition 'if (cpumask_test_cpu(cpu, &p->cpus_allowed))'
in Hillf's patch is not sufficient.

Thanks,
Yong



-- 
Only stand for myself
