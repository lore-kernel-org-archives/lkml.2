Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504Ab1AUInU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 03:43:20 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:54451 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431Ab1AUInS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 03:43:18 -0500
MIME-Version: 1.0
In-Reply-To: <20110120161101.GA17218@nowhere>
References: <AANLkTinNoYbDe5huY4_Q6YidbWxqXqVWbVP2_7o-=P3W@mail.gmail.com>
	<20110120161101.GA17218@nowhere>
Date: Fri, 21 Jan 2011 09:43:18 +0100
Message-ID: <AANLkTinhX6UwQA0HFhuu5=jbq84woVhqtahuzA5hEo2o@mail.gmail.com>
Subject: Re: [PATCH V2] tracing, perf : add cpu hotplug trace events
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-hotplug@vger.kernel.org,
        rostedt@goodmis.org, amit.kucheria@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 January 2011 17:11, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> On Thu, Jan 20, 2011 at 09:25:54AM +0100, Vincent Guittot wrote:
>> Please find below a new proposal for adding trace events for cpu hotplug.
>> The goal is to measure the latency of each part (kernel, architecture)
>> and also to trace the cpu hotplug activity with other power events. I
>> have tested these traces events on an arm platform.
>>
>> Changes since previous version:
>> -Use cpu_hotplug for trace name
>> -Define traces for kernel core and arch parts only
>> -Use DECLARE_EVENT_CLASS and DEFINE_EVENT
>> -Use proper indentation
>>
>> Subject: [PATCH] cpu hotplug tracepoint
>>
>> this patch adds new events for cpu hotplug tracing
>>  * plug/unplug sequence
>>  * core and architecture latency measurements
>>
>> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.com>
>> ---
>>  include/trace/events/cpu_hotplug.h |  117 ++++++++++++++++++++++++++++++++++++
>
> Note we can't apply new tracepoints if they are not inserted in the code.

I agree, i just want to have 1st feedbacks on the tracepoint interface
before providing a patch which inserts the trace in the code.

>
>> +DEFINE_EVENT(cpu_hotplug, cpu_hotplug_arch_wait_die_start,
>> +
>> +     TP_PROTO(unsigned int cpuid),
>> +
>> +     TP_ARGS(cpuid)
>> +);
>> +
>> +DEFINE_EVENT(cpu_hotplug, cpu_hotplug_arch_wait_die_end,
>> +
>> +     TP_PROTO(unsigned int cpuid),
>> +
>> +     TP_ARGS(cpuid)
>> +);
>
> What is wait die, compared to die for example?
>

The arch_wait_die is used to trace the process which waits for the cpu
to die (__cpu_die) and the arch_die is used to trace when the cpu dies
(cpu_die)

> We need those tracepoints to be applied to get that reviewable in practice.
>

Ok, I'm going to send a proposal

> Thanks.
>
