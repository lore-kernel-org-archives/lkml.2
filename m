Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365Ab1IGGhR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 02:37:17 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:44323 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296Ab1IGGhL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 02:37:11 -0400
MIME-Version: 1.0
Date: Wed, 7 Sep 2011 08:37:10 +0200
Message-ID: <CAC9WiBiNj-NS2mb8SaR1pK2JQdJOAbnN_rCXk1ZEMNaWQWZwxQ@mail.gmail.com>
Subject: Re: v3.1-rc5: Weird kernel log message when resuming avout NMI received
From: Francis Moreau <francis.moro@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Don Zickus <dzickus@redhat.com>, Stephane Eranian <eranian@google.com>,
        Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guys,

Just to let you know that I'm still getting this warning with 3.1-rc5

On Tue, Aug 16, 2011 at 5:07 PM, Francis Moreau <francis.moro@gmail.com> wrote:
> Peter,
>
> On Mon, Aug 15, 2011 at 10:37 AM, Francis Moreau <francis.moro@gmail.com> wrote:
>> Hello Peter,
>>
>> Sorry for the loooonnng delay but summer rest :)
>>
>> On Mon, Aug 1, 2011 at 1:05 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>>> On Sun, 2011-07-31 at 19:32 +0400, Cyrill Gorcunov wrote:
>>>
>>>> > >> I'm seeing those kernel message when resuming:
>>>> > >>
>>>> > >> [  524.973283] Uhhuh. NMI received for unknown reason 3d on CPU 0.
>>>> > >> [  524.973288] Do you have a strange power saving mode enabled?
>>>> > >> [  524.973289] Dazed and confused, but trying to continue
>>>> > >>
>>>> > >> I don't know if it's important or not because the system seems to work
>>>> > >> after but maybe it worths to report
>>>
>>> So I guess the problem is the NMI watchdog and suspend stuff not
>>> shutting things down properly..
>>>
>>> Argh, the PM notifier muck runs before the hotplug notifiers and it
>>> doesn't avoid hotplug races on its own.. what crap.
>>>
>>> something like the below perhaps, compile tested only.. does it work?
>>
>> Thanks for the fix, I'm going to give it a test and report in 2 days.
>>
>
> I'm trying to test the fix but have to stick with the 3.0 kernel and
> your patch seems to be based on 3.1.
>
> So I had to backport a couple of patches otherwise I'm getting the
> following error:
>
>  CC      kernel/events/core.o
> kernel/events/core.c: In function ‘perf_pm_resume_cpu’:
> kernel/events/core.c:7342: error: implicit declaration of function
> ‘perf_ctx_lock’
> kernel/events/core.c:7350: error: implicit declaration of function
> ‘perf_ctx_unlock’
> kernel/events/core.c: In function ‘perf_pm_suspend_cpu’:
> kernel/events/core.c:7370: error: implicit declaration of function
> ‘perf_event_sched_in’
>
> Here are the patches that I backported on top of 3.0:
>
>  perf: Collect the schedule-in rules in one function
>  perf: Change and simplify ctx::is_active semantics
>  perf: Simplify and fix __perf_install_in_context()
>  perf: Remove task_ctx_sched_in()
>  perf: Optimize event scheduling locking
>  perf: Clean up 'ctx' reference counting
>  perf: Optimize ctx_sched_out()
>
> After the second suspend/resume sequence I still have the same warning
> except that the reason has changed to '2d':
>
>  kernel:[  404.091393] Uhhuh. NMI received for unknown reason 2d on CPU 0.
>  kernel:[  404.091394] Do you have a strange power saving mode enabled?
>  kernel:[  404.091396] Dazed and confused, but trying to continue
>


-- 
Francis
