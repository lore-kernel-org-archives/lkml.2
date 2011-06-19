Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751973Ab1FSIdi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 04:33:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:48870 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751369Ab1FSIdg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 04:33:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=gR22M/7s4VkNOxvqOXxbLIShmVY9rfcWZ8gwh+GKGLtoO3IifbuK5hEnRQEYrr8bUO
         701lhfZom+hf6NvMMKmfrzLsxPa90V2v87+BDO3TAu3jL8cPwgbZT0VWruRo093Z/OwX
         q24U3+4J+CXGuzYZavbTg60kfIJAZDUURrFCE=
MIME-Version: 1.0
In-Reply-To: <1308417114.9218.220.camel@gandalf.stny.rr.com>
References: <BANLkTint_00+oHVGpgV4n4E2A9W5O8nJxA@mail.gmail.com>
	<1308275405.9218.156.camel@gandalf.stny.rr.com>
	<BANLkTik8PpdwGgLOE7rAauXqGYdnT53GpQ@mail.gmail.com>
	<1308322563.9218.184.camel@gandalf.stny.rr.com>
	<BANLkTimUd3BWFg4hi6OWLjUYsxvWRRBUZg@mail.gmail.com>
	<1308417114.9218.220.camel@gandalf.stny.rr.com>
Date: Sun, 19 Jun 2011 16:33:32 +0800
Message-ID: <BANLkTikm1h45+sCYeKOXBhw1haQAHO1uPA@mail.gmail.com>
Subject: Re: [PATCH] sched: update cpupri for runqueue when its priority changes
From: Hillf Danton <dhillf@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Mike Galbraith <efault@gmx.de>,
        Yong Zhang <yong.zhang0@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [140.211.167.34]); Sun, 19 Jun 2011 08:33:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 19, 2011 at 1:11 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
>> There are two cases that NULL is returned in _pick_next_task_rt(), it is the
>> second case, after checking rt_rq->rt_nr_running, that is captured, and if
>> NULL is returned in the second case, the CPU priority does change.
>
> The two cases are:
>
> 1) no rt task exists
> 2) the runqueue is throttled.
>
> We already talked about the throttled case. The case where no rt task
> exists means that the last rt task has been dequeued. When that happens,
> the cpupri is updated then. I don't see any bug. There's no need to
> update cpupri at this point.
>

In case 2) , the CPU will be held then by non-RT task, and we have to
update priority.

I understand 1) and 2) to be, there has RT tasks on runqueue but they
could not run at the moment.

If throttled RQ == no RT tasks, please drop this patch directly.

>>
>> In another scenario that has little with {en, de}queue, as shown by
>> requeue_task_rt(), the CPU priority will change if other RT tasks exist.
>>
>
> The requeue_task_rt() does not change the priority of the CPU. It just
> updates the task in its order of placement in the queue of other tasks
> of the same priority.
>

You are right, updating CPU priority for requeue is unnecessary.

thanks
           Hillf
