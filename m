Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754377Ab2AJINQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 03:13:16 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49026 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279Ab2AJINP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 03:13:15 -0500
MIME-Version: 1.0
In-Reply-To: <1325799904.3508.12.camel@twins>
References: <CAOAMb1BHA=5fm7KTewYyke6u-8DP0iUuJMpgQw54vNeXFsGpoQ@mail.gmail.com>
	<1325786132.3508.1.camel@twins>
	<1325787342.12696.59.camel@gandalf.stny.rr.com>
	<1325799904.3508.12.camel@twins>
Date: Tue, 10 Jan 2012 17:13:15 +0900
Message-ID: <CAOAMb1A3DNU87oFRHPJZc5OARtsN4wjarmr+Ffu9oB_b0HOioA@mail.gmail.com>
Subject: Re: [PATCH] sched_rt: the task in irq context can be migrated during
 context switching
From: Chanho Min <chanho0207@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, chanho.min@lge.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 6, 2012 at 6:45 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, 2012-01-05 at 13:15 -0500, Steven Rostedt wrote:
>> On Thu, 2012-01-05 at 18:55 +0100, Peter Zijlstra wrote:
>>
>> > So the problem is quite real, as already said we don't need to worry
>> > about the future, but we might want to fix this in previous kernels.
>> > What I'm not entirely sure of is the proposed solution, Steven don't we
>> > get in trouble by simply bailing out on the push?
>>
>> It shouldn't break anything. We shouldn't be pushing tasks that are
>> running on a rq anyway.
>
> Its not running, but its in the middle of getting scheduled out.
>
>> I don't see any harm here. As this scenario can
>> only happen if we get an interrupt after letting go of the rq lock and
>> before doing the switch_to(). The schedule_tail() calls
>> post_schedule_rt() which does the push again, and will push task A at
>> that time.
>
> Right, so the post_schedule() hook will try again.
>
>> That said, I'm not sure this patch is enough. I'm worried about a pull
>> happening. As task A is running, we could possible possibly pick it on
>> another CPU to do a pull.
>>
>> Hmm, looking at the code, the pull already does a task_running() test,
>> so I guess we should be fine.
>
> Yeah, I'm not sure all those task_running() things make sense though,
> when !->on_rq && ->on_cpu we should busy wait for tasks, not skip them.
>
> Then again, with this WANT_INTERRUPTS_ON_CTXSW the busy wait crap is
> tricky. Luckily its going the way of the Dodo very soon.

So Will this be applied?  It will be critical and very hard to debug.
( pretty rare, sometimes system hang without any message )
It has been well tested on our ARM platform.

Thanks
Chanho
