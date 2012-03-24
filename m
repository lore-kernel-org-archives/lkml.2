Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754328Ab2CXHGq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 03:06:46 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:58068 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236Ab2CXHGp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 03:06:45 -0400
MIME-Version: 1.0
In-Reply-To: <1332512896.23924.66.camel@gandalf.stny.rr.com>
References: <CAB4K4y7ticNGWv1XWtqLatBG69yM2gv31ayt5DqWSSOUWTZrGg@mail.gmail.com>
	<20120319130445.GN15988@n2100.arm.linux.org.uk>
	<CAB4K4y4Sw4dyT7vX_YzgbYBK42LZuS96=6X3MtVdN-mBqOKr-Q@mail.gmail.com>
	<20120319132623.GO15988@n2100.arm.linux.org.uk>
	<4F696011.7080409@linaro.org>
	<CAB4K4y5ZkGY3pe3ty5fbaVTj626dAS3HuodX6HfDvym8g0qyZQ@mail.gmail.com>
	<CAB4K4y5phDP=4Ab1S2XwS+Oa25B5Pxe3p5D2ZO3G=2W=cMKm=w@mail.gmail.com>
	<20120322100236.GS15988@n2100.arm.linux.org.uk>
	<CAB4K4y5rOFbPm1XjeHxUFtc29tFAQ1besKLy5fz4MHq6UV0fdA@mail.gmail.com>
	<4F6BECA7.7030007@linaro.org>
	<CAB4K4y4DvUb+908P4NJoyJbDa35R2jP5cHqnoNWr9HRZJYyj4w@mail.gmail.com>
	<1332512896.23924.66.camel@gandalf.stny.rr.com>
Date: Sat, 24 Mar 2012 12:36:44 +0530
Message-ID: <CAB4K4y46ATRL84XXYf6jYK3R9S_7JKV7hLOWa+PZgZh4eW5j9Q@mail.gmail.com>
Subject: Re: Not able to use HIGH_RES_TIMERS on ARM
From: Ajeet Yadav <ajeet.yadav.77@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 23, 2012 at 7:58 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Fri, 2012-03-23 at 14:40 +0530, Ajeet Yadav wrote:
>
>> linux-3.0.20/kernel/trace/Kconfig
>> linux-3.0.20-dirty/kernel/trace/Kconfig
>> --- linux-3.0.20/kernel/trace/Kconfig   2012-02-06 23:01:45.000000000 +0530
>> +++ linux-3.0.20-dirty/kernel/trace/Kconfig     2012-03-19
>> 18:21:41.000000000 +0530
>> @@ -173,7 +173,6 @@ config IRQSOFF_TRACER
>>        bool "Interrupts-off Latency Tracer"
>>        default n
>>        depends on TRACE_IRQFLAGS_SUPPORT
>> -       depends on !ARCH_USES_GETTIMEOFFSET
>>        select TRACE_IRQFLAGS
>>        select GENERIC_TRACER
>>        select TRACER_MAX_TRACE
>> @@ -195,7 +194,6 @@ config IRQSOFF_TRACER
>>  config PREEMPT_TRACER
>>        bool "Preemption-off Latency Tracer"
>>        default n
>> -       depends on !ARCH_USES_GETTIMEOFFSET
>>        depends on PREEMPT
>>        select GENERIC_TRACER
>>        select TRACER_MAX_TRACE
>
> A little history here.
>
> When I converted the irqsoff/preemptoff latency tracers from the
> original -rt patch (written by Ingo), these options originally had
> "depends on GENERIC_TIME". I just checked, and this goes at least back
> to 2.6.22.1-rt9 (long before ftrace).
>
> When I ported these to ftrace, I kept the dependencies. They probably
> are not needed and are only there for historical reasons.
>
> If this patch works fine for you, and that you are my only test case for
> this patch. I'd just say:
>
> Acked-by: Steven Rostedt <rostedt@goodmis.org>
>
> -- Steve
Hi Steve thanks for review, is their anything more I can do or shall I
consider this change as already submitted, thanks everyone for helping
me.
>
>
