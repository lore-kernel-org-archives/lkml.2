Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757601Ab2BOKJT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 05:09:19 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:44113 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034Ab2BOKJR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 05:09:17 -0500
MIME-Version: 1.0
In-Reply-To: <20120213172633.GA1426@atomide.com>
References: <CAM8FrK++W4ScR-htTDXeA7iniz9LTXB_29yzhDNfOu5=VLC+mQ@mail.gmail.com>
	<20120213172633.GA1426@atomide.com>
Date: Wed, 15 Feb 2012 11:09:16 +0100
Message-ID: <CAM8FrKLH5pRmuedp90B4rqHPbdduCmKYPnkN4Nz9ofc8YXq6mw@mail.gmail.com>
Subject: Re: Internal timers in deep sleep
From: Marcus Folkesson <marcus.folkesson@gmail.com>
To: Tony Lindgren <tony@atomide.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

Thanks for your answer.

The CPU goes down to Idle- or Wait For Interrupt-state but never to
any deeper state.
OMAP-L138 has only two possibilities to wake up from deep-sleep;
either from an RTC alarm or from an external wakeup-source.

The RTC has too low resolution (1s) for our application, so we need to
us the external interrupt as wakeup-source.

I have printed out the expire time for the next timer in queue (in
kernel/time/tick-sched.c:tick_nohz_stop_sched_tick()) and it is about
~10-200ms to next tick. (HZ=100). With this tight interval its not
possible to goto deepsleep with the latancies we have seen.


Med vänliga hälsningar / Best regards
Marcus Folkesson



2012/2/13 Tony Lindgren <tony@atomide.com>:
> Hi Marcus,
>
> * Marcus Folkesson <marcus.folkesson@gmail.com> [120211 03:37]:
>> Is it possible to speed up the time it takes to go to/from deepsleep?
>> The pm_suspend() does a lot of things, eg. freeze processes, suspend
>> drivers and so on.
>
> Depending on the omap, you can already do suspend while idle or off
> while idle. This means the RAM is in self-refresh and the omap is
> either suspended or powered off in the idle loop. This is typically
> done with a combination of constantly running 32 KiHz clocksource and
> wake-up capable GPT1 clockevent timer.
>
> If you have similar timers on your hardware, this may be the way to go.
> In this case there's no need to freeze processes, so the latency is
> quite minimal.
>
> Regards,
>
> Tony
