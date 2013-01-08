Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754437Ab3AHBzP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 20:55:15 -0500
Received: from mail-vb0-f50.google.com ([209.85.212.50]:62015 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753541Ab3AHBzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 20:55:13 -0500
MIME-Version: 1.0
In-Reply-To: <1357609797.5190.17.camel@gandalf.local.home>
References: <1357607254-511-1-git-send-email-fweisbec@gmail.com>
	<1357609797.5190.17.camel@gandalf.local.home>
Date: Tue, 8 Jan 2013 02:55:12 +0100
Message-ID: <CAFTL4hymZ9GqC+XEec0WGJij99jc_K3pdQZ48t0eKU45PzQEJg@mail.gmail.com>
Subject: Re: [PATCH] sched: Remove broken check for skip clock update
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/1/8 Steven Rostedt <rostedt@goodmis.org>:
> On Tue, 2013-01-08 at 02:07 +0100, Frederic Weisbecker wrote:
>> rq->skip_clock_update shouldn't be negative. Thus the check
>> in put_prev_task() is useless.
>>
>> It was probably intended to do the following check:
>>
>>       if (prev->on_rq && !rq->skip_clock_update)
>>
>> We only want to update the clock if the current task is
>> not voluntarily sleeping: otherwise deactivate_task()
>> already did the rq clock update in schedule(). But we want
>> to ignore that update if a ttwu did it for us, in which case
>> rq->skip_clock_update is 1.
>>
>> But update_rq_clock() already takes care of that so we
>> can just remove the broken condition.
>
> kernel/sched/rt.c:
>
>                                 /*
>                                  * Force a clock update if the CPU was idle,
>                                  * lest wakeup -> unthrottle time accumulate.
>                                  */
>                                 if (rt_rq->rt_nr_running && rq->curr == rq->idle)
>                                         rq->skip_clock_update = -1;

Grr, I knew I was missing something!

Ok let's drop that patch then.
