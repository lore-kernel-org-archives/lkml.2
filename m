Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757097Ab2CUKQl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 06:16:41 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:33498 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278Ab2CUKQk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 06:16:40 -0400
MIME-Version: 1.0
In-Reply-To: <4F696011.7080409@linaro.org>
References: <CAB4K4y7ticNGWv1XWtqLatBG69yM2gv31ayt5DqWSSOUWTZrGg@mail.gmail.com>
	<20120319130445.GN15988@n2100.arm.linux.org.uk>
	<CAB4K4y4Sw4dyT7vX_YzgbYBK42LZuS96=6X3MtVdN-mBqOKr-Q@mail.gmail.com>
	<20120319132623.GO15988@n2100.arm.linux.org.uk>
	<4F696011.7080409@linaro.org>
Date: Wed, 21 Mar 2012 15:46:39 +0530
Message-ID: <CAB4K4y5ZkGY3pe3ty5fbaVTj626dAS3HuodX6HfDvym8g0qyZQ@mail.gmail.com>
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

Hi John,
Thank for clearing the confusion.

On Wed, Mar 21, 2012 at 10:28 AM, John Stultz <john.stultz@linaro.org> wrote:
> On 03/19/2012 06:26 AM, Russell King - ARM Linux wrote:
>>
>> On Mon, Mar 19, 2012 at 06:49:34PM +0530, Ajeet Yadav wrote:
>>>
>>> Therefore our target configuration with 2.6 kernel was
>>> GENERIC_CLOCKEVENTS=y, ARCH_USES_GETTIMEOFFSET=y,
>>
>> It's absolutely absurd to have a platform converted to use clockevents
>> and clocksources, and then select ARCH_USES_GETTIMEOFFSET.  That's saying
>> "I provide the new infrastructure, but I want the dodgy old compatibility
>> which doesn't work properly with a set of other features as well".
>>
>>> I conclude that GENERIC_CLOCKEVENTS is supported, hence I must set
>>> ARCH_USES_GETTIMEOFFSET=n, in order to use NO_HZ, HIGH_RES_TIMERS,
>>> IRQSOFF_TRACER, PREEMPT_TRACER
>>
>> Correct.  If you're using clockevents and clocksources, you should not
>> select ARCH_USES_GETTIMEOFFSET.
>>
>
> Hey Ajeet,
>    As Russell pointed out, it looks like you're confused as to the use of
> ARCH_USES_GETTIMEOFFSET. That option is only for legacy systems that don't
> provide continuous clocksources that can be used for timekeeping.
>
> In the past, time was incremented by one tick every timer interrupt.  Some
> systems could use the timer hardware (usually PIT style decrementer) to
> calculate inter-tick times. Its only for this style of hardware, that either
> wraps or resets each tick, that GETTIMEOFFSET is needed.  If you have a
> continuous counter that doesn't wrap for a reasonable number of ticks, you
> want to use the clocksource abstraction to represent that hardware. That has
> the benefits of allowing high res timers and nohz, since we don't need to
> keep a constant tick-beat to keep time (and also avoids lost-ticks and a
> host of problems that tick based timekeeping can run into).
>
> So I suspect you probably want to verify your hardware supports a
> clocksource and disable ARCH_USES_GETTIMEOFFSET.
>
> Sorry for any confusion!
>
> thanks
> -john
>
