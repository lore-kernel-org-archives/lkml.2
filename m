Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966223Ab2ERRwH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 13:52:07 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:48472 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965967Ab2ERRwF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 13:52:05 -0400
MIME-Version: 1.0
In-Reply-To: <1337331395.573.3.camel@twins>
References: <1337229266-15798-1-git-send-email-ccross@android.com>
	<1337331395.573.3.camel@twins>
Date: Fri, 18 May 2012 10:52:02 -0700
X-Google-Sender-Auth: BHZY4aDwQUaX96H23lqeLWOUKG8
Message-ID: <CAMbhsRQYeM8b167HVge11kVtniWKEukN+xGMvcMDf5+UOOc8_w@mail.gmail.com>
Subject: Re: [PATCH] sched/rt: fix SCHED_RR across cgroups
From: Colin Cross <ccross@android.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2012 at 1:56 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Wed, 2012-05-16 at 21:34 -0700, Colin Cross wrote:
>> task_tick_rt has an optimization to only reschedule SCHED_RR tasks
>> if they were the only element on their rq.  However, with cgroups
>> a SCHED_RR task could be the only element on its per-cgroup rq but
>> still be competing with other SCHED_RR tasks in its parent's
>> cgroup.  In this case, the SCHED_RR task in the child cgroup would
>> never yield at the end of its timeslice.  If the child cgroup
>> rt_runtime_us was the same as the parent cgroup rt_runtime_us,
>> the task in the parent cgroup would starve completely.
>>
>> Modify task_tick_rt to check that the task is the only task on its
>> rq, and that the each of the scheduling entities of its ancestors
>> is also the only entity on its rq.
>>
>> Signed-off-by: Colin Cross <ccross@android.com>
>
> OK, fair enough.. one does wonder though, WTH is android doing with
> SCHED_RR?

Nothing, I was just experimenting with how it interacted with cgroups
and the numbers didn't make sense.
