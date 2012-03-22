Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755373Ab2CVKZt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 06:25:49 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:60732 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877Ab2CVKZr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 06:25:47 -0400
MIME-Version: 1.0
In-Reply-To: <20120322100236.GS15988@n2100.arm.linux.org.uk>
References: <CAB4K4y7ticNGWv1XWtqLatBG69yM2gv31ayt5DqWSSOUWTZrGg@mail.gmail.com>
	<20120319130445.GN15988@n2100.arm.linux.org.uk>
	<CAB4K4y4Sw4dyT7vX_YzgbYBK42LZuS96=6X3MtVdN-mBqOKr-Q@mail.gmail.com>
	<20120319132623.GO15988@n2100.arm.linux.org.uk>
	<4F696011.7080409@linaro.org>
	<CAB4K4y5ZkGY3pe3ty5fbaVTj626dAS3HuodX6HfDvym8g0qyZQ@mail.gmail.com>
	<CAB4K4y5phDP=4Ab1S2XwS+Oa25B5Pxe3p5D2ZO3G=2W=cMKm=w@mail.gmail.com>
	<20120322100236.GS15988@n2100.arm.linux.org.uk>
Date: Thu, 22 Mar 2012 15:55:46 +0530
Message-ID: <CAB4K4y5rOFbPm1XjeHxUFtc29tFAQ1besKLy5fz4MHq6UV0fdA@mail.gmail.com>
Subject: Re: Not able to use HIGH_RES_TIMERS on ARM
From: Ajeet Yadav <ajeet.yadav.77@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I understand your point,
Our target (2.6) always had ARCH_USES_GETTIMEOFFSET=y , but still we
were able to use the TRACER in past until the patch "kill
GENERIC_TIMER" published, anyone will ask me remove this patch and use
TRACER, becaue it was working before. :)

If I set  ARCH_USES_GETTIMEOFFSET=n to use this feature, my target
fail to boot. (reason I well understand from our past discussions)

but if do below, everything work find target as well as tracer.

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

On Thu, Mar 22, 2012 at 3:32 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Thu, Mar 22, 2012 at 02:46:31PM +0530, Ajeet Yadav wrote:
>> Hi John,
>> On our target  ARCH_USES_GETTIMEOFFSET=y, can you please help me how
>> can I useIRQSOFF_TRACER, PREEMPT_TRACER ?
>
> If you have ARCH_USES_GETTIMEOFFSET=y, the simple answer is: you can't.
>
> Your solution is to update your platform to use clock sources and clock
> events and disable the obsolete ARCH_USES_GETTIMEOFFSET option.
