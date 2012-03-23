Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758035Ab2CWJLA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 05:11:00 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37327 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757832Ab2CWJK6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 05:10:58 -0400
MIME-Version: 1.0
In-Reply-To: <4F6BECA7.7030007@linaro.org>
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
Date: Fri, 23 Mar 2012 14:40:57 +0530
Message-ID: <CAB4K4y4DvUb+908P4NJoyJbDa35R2jP5cHqnoNWr9HRZJYyj4w@mail.gmail.com>
Subject: Re: Not able to use HIGH_RES_TIMERS on ARM
From: Ajeet Yadav <ajeet.yadav.77@gmail.com>
To: John Stultz <john.stultz@linaro.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 23, 2012 at 8:53 AM, John Stultz <john.stultz@linaro.org> wrote:
> On 03/22/2012 03:25 AM, Ajeet Yadav wrote:
>>
>> I understand your point,
>> Our target (2.6) always had ARCH_USES_GETTIMEOFFSET=y , but still we
>> were able to use the TRACER in past until the patch "kill
>> GENERIC_TIMER" published, anyone will ask me remove this patch and use
>> TRACER, becaue it was working before. :)
>
>
> Ajeet,
>    Sorry, by TRACER, do you mean PREEMPT_TRACER or something else? And what
> specific 2.6.X kernel were you using?
>
> Steven, I'm seeing:
>
> config PREEMPT_TRACER
>        bool "Preemption-off Latency Tracer"
>        default n
>        depends on !ARCH_USES_GETTIMEOFFSET
>
> Do you have any context as to why is !ARCH_USES_GETTIMEOFFSET flagged here?
Since boot problem is now fixed, I removed  "depends on
!ARCH_USES_GETTIMEOFFSET" from config NO_HZ, config HIGH_RES_TIMERS,
config IRQSOFF_TRACER, config
PREEMPT_TRACER, to continue my work.

Ref: time: Kill off CONFIG_GENERIC_TIME
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commit;h=592913ecb87a9e06f98ddb55b298f1a66bf94c6b

diff -Naurp -X linux-3.0.20/Documentation/dontdiff
linux-3.0.20/kernel/time/Kconfig
linux-3.0.20-dirty/kernel/time/Kconfig
--- linux-3.0.20/kernel/time/Kconfig    2012-02-06 23:01:45.000000000 +0530
+++ linux-3.0.20-dirty/kernel/time/Kconfig      2012-03-19
18:22:32.000000000 +0530
@@ -6,7 +6,7 @@ config TICK_ONESHOT

 config NO_HZ
       bool "Tickless System (Dynamic Ticks)"
-       depends on !ARCH_USES_GETTIMEOFFSET && GENERIC_CLOCKEVENTS
+       depends on GENERIC_CLOCKEVENTS
       select TICK_ONESHOT
       help
         This option enables a tickless system: timer interrupts will
@@ -15,7 +15,7 @@ config NO_HZ

 config HIGH_RES_TIMERS
       bool "High Resolution Timer Support"
-       depends on !ARCH_USES_GETTIMEOFFSET && GENERIC_CLOCKEVENTS
+       depends on GENERIC_CLOCKEVENTS
       select TICK_ONESHOT
       help
         This option enables high resolution timer support. If your
diff -Naurp -X linux-3.0.20/Documentation/dontdiff
linux-3.0.20/kernel/trace/Kconfig
linux-3.0.20-dirty/kernel/trace/Kconfig
--- linux-3.0.20/kernel/trace/Kconfig   2012-02-06 23:01:45.000000000 +0530
+++ linux-3.0.20-dirty/kernel/trace/Kconfig     2012-03-19
18:21:41.000000000 +0530
@@ -173,7 +173,6 @@ config IRQSOFF_TRACER
       bool "Interrupts-off Latency Tracer"
       default n
       depends on TRACE_IRQFLAGS_SUPPORT
-       depends on !ARCH_USES_GETTIMEOFFSET
       select TRACE_IRQFLAGS
       select GENERIC_TRACER
       select TRACER_MAX_TRACE
@@ -195,7 +194,6 @@ config IRQSOFF_TRACER
 config PREEMPT_TRACER
       bool "Preemption-off Latency Tracer"
       default n
-       depends on !ARCH_USES_GETTIMEOFFSET
       depends on PREEMPT
       select GENERIC_TRACER
       select TRACER_MAX_TRACE

>
> thanks
> -john
>
