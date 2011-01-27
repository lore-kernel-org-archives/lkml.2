Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883Ab1A0KEM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 05:04:12 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:55367 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715Ab1A0KEK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 05:04:10 -0500
MIME-Version: 1.0
In-Reply-To: <20110126173241.GD1757@nowhere>
References: <AANLkTi=hQpCVJWZ_Op4mhnehufcBg2=h_=q4xXD66tGb@mail.gmail.com>
	<20110126173241.GD1757@nowhere>
Date: Thu, 27 Jan 2011 11:04:09 +0100
Message-ID: <AANLkTikEvEyMZgmCozw_yt1enRJ2+GTvd02BY30hUJt0@mail.gmail.com>
Subject: Re: [PATCH 2/2] tracing, perf : add cpu hotplug trace events
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-hotplug@vger.kernel.org,
        rostedt@goodmis.org, amit.kucheria@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 January 2011 18:32, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> On Tue, Jan 25, 2011 at 09:54:59AM +0100, Vincent Guittot wrote:
>> Please find below a new proposal for adding trace events for cpu hotplug.
>> The goal is to measure the latency of each part (kernel, architecture)
>> and also to trace the cpu hotplug activity with other power events. I
>> have tested these traces events on an arm platform.
>>
>> Subject: [PATCH 1/2] add cpu hotplug tracepoints
>>
>> this patch adds new events for cpu hotplug tracing
>>  * plug/unplug sequence
>>  * core and architecture latency measurements
>>
>> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
>> ---
>>  kernel/cpu.c |   17 +++++++++++++++++
>>  1 files changed, 17 insertions(+), 0 deletions(-)
>>
>> diff --git a/kernel/cpu.c b/kernel/cpu.c
>> index 156cc55..f04e9cf 100644
>> --- a/kernel/cpu.c
>> +++ b/kernel/cpu.c
>> @@ -16,6 +16,9 @@
>>  #include <linux/mutex.h>
>>  #include <linux/gfp.h>
>>
>> +#define CREATE_TRACE_POINTS
>> +#include <trace/events/cpu_hotplug.h>
>> +
>>  #ifdef CONFIG_SMP
>>  /* Serializes the updates to cpu_online_mask, cpu_present_mask */
>>  static DEFINE_MUTEX(cpu_add_remove_lock);
>> @@ -200,7 +203,9 @@ static int __ref take_cpu_down(void *_param)
>>       int err;
>>
>>       /* Ensure this CPU doesn't handle any more interrupts. */
>> +     trace_cpu_hotplug_arch_disable_start((unsigned int)(param->hcpu));
>>       err = __cpu_disable();
>> +     trace_cpu_hotplug_arch_disable_end((unsigned int)(param->hcpu));
>
> You should create a cpu var instead of doing that not very beautiful cast
> twice.
>

OK

> Probably we should eventually rename arch_disable into just disable.
>
> And same for die, because otherwise the name is quite long.
>

If we remove the arch extension of these names, we will have
trace_cpu_hotplug_arch_up for __cpu_up (trace_cpu_hotplug_up is
already used) and trace_cpu_hotplug_disable for __cpu_disable. would
that be acceptable ?

> Other than that, looks all good to me.
>
> Thanks.
>
