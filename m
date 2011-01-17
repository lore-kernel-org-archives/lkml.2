Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886Ab1AQNuB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 08:50:01 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:35903 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143Ab1AQNt7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 08:49:59 -0500
MIME-Version: 1.0
In-Reply-To: <20110114183516.GB1926@nowhere>
References: <AANLkTimsR3=BKSF8EyASu4_T_vTznw4yEqmxPS8gOQCy@mail.gmail.com>
	<20110107151200.GB1736@nowhere>
	<AANLkTi=L3=_2dzHH4Wu6QWXw=AUjxtrAu60xfM3-Qwn4@mail.gmail.com>
	<20110114183516.GB1926@nowhere>
Date: Mon, 17 Jan 2011 07:49:58 -0600
Message-ID: <AANLkTi=nugnkimG75Qh3t2vu8-qy2LKKHwoY2FFFpWDp@mail.gmail.com>
Subject: Re: [PATCH] tracing, perf : add cpu hotplug trace events
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-hotplug@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Amit Kucheria <amit.kucheria@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 January 2011 12:35, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> On Fri, Jan 07, 2011 at 07:25:08PM +0100, Vincent Guittot wrote:
>> On 7 January 2011 16:12, Frederic Weisbecker <fweisbec@gmail.com> wrote:
>> >> +
>> >> + TP_PROTO(unsigned int type, unsigned int step, unsigned int cpuid),
>> >
>> > I feel a bit uncomfortable with these opaque type and step.
>> >
>> > What about splitting the events:
>> >
>> >        cpu_down_start
>> >        cpu_down_end
>> >
>> >        cpu_up_start
>> >        cpu_up_end
>> >
>> > This ways they are much more self-explanatory.
>> >
>> > I also feel uncomfortable about exposing arch step details in core
>> > tracepoints.
>> >
>> > But if we consider the following sequence:
>> >
>> >        cpu_down() {
>> >                __cpu_disable() {
>> >                        platform_cpu_disable();
>> >                }
>> >        }
>> >
>> > Then exposing start/end of cpu_disable() makes sense, by way of:
>> >
>> >        cpu_arch_disable_start
>> >        cpu_arch_disable_end
>> >
>> >        cpu_arch_enable_start
>> >        cpu_arch_enable_end
>> >
>> >
>> >        cpu_arch_die_start
>> >        cpu_arch_die_end
>> >
>> >        cpu_arch_die_start
>> >        cpu_arch_die_end
>> >
>> > Because they are arch events that you can retrieve everywhere, the tracepoints
>> > are still called from the code code.
>> >
>> > Now for the machine part, it's very highly arch specific, most notably for arm
>> > so I wonder if it would make more sense to keep that seperate into arch
>> > tracepoints.
>> >
>>
>> May be we could find some event names that matches for all system and
>> that can be kept in the same file ?
>
> But that's only an ARM concern, right? So ARM can create its own
> set of tracepoints for that. If that becomes more widely useful then
> we can think about gathering the whole into a single file.
>

OK, we can do like that

>> > How does that all look? I hope I'm not overengineering.
>> >
>>
>> that's could be ok for me, I can find almost the same kind of
>> information with this solution. I just wonder what traces are the
>> easiest to treat for extracting some latency measurement or to treat
>> with other event like the power event.
>
> Hmm, I'm not sure what you mean. You want to know which tracepoints
> can be useful to measure latencies? Well, it depends on what kind
> of latency you seek in general: scheduler, io, etc...
>

I was just wondering which tracepoints format between my 1st proposal
and yours was the easier to post process by an application like
pytimechart.

I have updated the cpu hotplug tracepoint according to your remarks
and steve's ones. I have just replaced the second
cpu_arch_die_start/end in your proposal by cpu_arch_dead_start/endfrq
