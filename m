Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758142Ab2BKMIt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Feb 2012 07:08:49 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:60954 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318Ab2BKMIs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Feb 2012 07:08:48 -0500
MIME-Version: 1.0
Date: Sat, 11 Feb 2012 13:08:47 +0100
Message-ID: <CAM8FrK++W4ScR-htTDXeA7iniz9LTXB_29yzhDNfOu5=VLC+mQ@mail.gmail.com>
Subject: Internal timers in deep sleep
From: Marcus Folkesson <marcus.folkesson@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello there,

I am currently working with an embedded system based on a OMAP-L138.
We are developing a Software Defined Radio (SDR) which is sending and
recieveing data in a slot-based scheme.
Power management is a really important subject in our application,
therefore we want to put the CPU into deepsleep (suspend to RAM) as
much as we can.
In short, this deepsleep-mode stops all the PLLs and put the SDRAM
into self-refresh.

Since all the the PLLs is stopped in deepsleep-mode, we loose all time
perception. This is a problem since our rx/tx scheme is slot-based and
if we don't know the time then we don't know when we should
listen/transmit.
To solve this, we have implemented a timer in a FPGA that still ticks
when the CPU is sleeping. This timer also work as an alarm-clock, e.g.
we can set a time when it should wake us up from deepsleep.
When going into deepsleep, the driver that communicates with the FPGA
set a wake-up alarm and then it calls pm_suspend(PM_SUSPEND_MEM).

Our application is also time-critical so we want to go to/from
deepsleep as fast as possible.
For some quick measurements, we have seen that it takes about 70ms to
go up from deepsleep.


Now to the questions!
1a.
When we are going into deepsleep, all internal timers used by the
kernel itself and other applications will be frozen and delayed. Do
you think this disorder will cause any problem?
Of cause, this can be seen as a stupid question, it all depends on our
application, but if you have any personal experience about this, so
please feel free to mention how the reasoning went.

1b.
Should I  take care of the internal timers (make the FPGA to wake up
on those too)? Do you know any good functions that exposes a list with
all timers?
I guess there must be a function that gives you the timer that expires
next but I have not found it.
Is the timer_list and htimers handled the same way? I guess the
htimers is not jiffie-based?

1c.
Should I adjust some internal variables (e.g. jiffies) when waking up?

2.
Is it possible to speed up the time it takes to go to/from deepsleep?
The pm_suspend() does a lot of things, eg. freeze processes, suspend
drivers and so on.
Of cause, those functions is not there for fun, but is some more
important than others...?

Thanks in advance

Med vänliga hälsningar / Best regards
Marcus Folkesson
