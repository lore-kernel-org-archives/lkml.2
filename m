Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697Ab1HTCkO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 22:40:14 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:37380 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289Ab1HTCkL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 22:40:11 -0400
MIME-Version: 1.0
In-Reply-To: <201108192231.02665.trenn@suse.de>
References: <1313766244-22313-1-git-send-email-tom.leiming@gmail.com>
	<1313766244-22313-3-git-send-email-tom.leiming@gmail.com>
	<201108192231.02665.trenn@suse.de>
Date: Sat, 20 Aug 2011 10:40:09 +0800
Message-ID: <CACVXFVPeFyg7YoAsY63Mpy9HVR1y3ibg9R8HnUfLVe=hKf3ApA@mail.gmail.com>
Subject: Re: [PATCH 3/3] trace points: power: remove 'cpu_id' from trace_cpu_idle
From: Ming Lei <tom.leiming@gmail.com>
To: Thomas Renninger <trenn@suse.de>
Cc: rostedt@goodmis.org, fweisbec@gmail.com, jean.pihet@newoldbits.com,
        mingo@redhat.com, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, Len Brown <lenb@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2011/8/20 Thomas Renninger <trenn@suse.de>:
> On Friday, August 19, 2011 05:04:04 PM tom.leiming@gmail.com wrote:
>> From: Ming Lei <tom.leiming@gmail.com>
>>
>> This patch removes the 'cpu_id' parameter of the cpu_idle
>> trace point, based on the ideas below:
>>
>> - the cpu_id which is passed to trace point is always the current
>>   cpu
> Are you sure this will always be true?

It is sure at least now,  the only place to pass 'dev->cpu' is inside
cpuidle_idle_call,
but the cpuidle_device is got from __this_cpu_read(cpuidle_devices),
so it should
be true for such case.

>
>> - the current cpu info has been included into the trace result
>>   already
>> - smp_processor_id() can't be used safely in preemptible context.
>
> The cpuid has been added to idle events on purpose for example to be
> able to pass C-state dependencies.
> 2 cores may only enter a deeper sleep state if the 2nd core enters it
> as well.
> There may be architectures where you could trigger a sleep state on
> a foreign cpu.
>
> This may not be used now, but if the kernel does want to use it, you do
> not want to adjust a dozen userspace apps.
>
> Not sure how to quickly solve the:
> "smp_processor_id() can't be used safely in preemptible context."
> problem, though.
> A convention could be declared that if -1 is passed, it's the same cpu
> entering the sleep state as the running one. This will probably
> break userspace apps as well...
>
> Best would be to clean up x86 and let idle routines always be entered
> from cpuidle subsystem which knows the cpu id already and eliminate
> all idle functions in arch/x86/kernel/process.c.
>
>   Thomas
>
> PS: I do not care about patch 1 and 2 as these events are ARM specific
> afaik. But I vote against this one.
>


thanks,
-- 
Ming Lei
