Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753052Ab1HATtj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 15:49:39 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42835 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752915Ab1HATtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 15:49:35 -0400
Date: Mon, 1 Aug 2011 20:48:09 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Remy Bohmer <linux@bohmer.net>
Cc: Remy Bohmer <l.pinguin@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        tglx@linutronix.de,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Andrew Victor <linux@maxim.org.za>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] Add sched_clock to AT91 TCB clocksource driver
Message-ID: <20110801194809.GE19079@n2100.arm.linux.org.uk>
References: <1312124593-6088-1-git-send-email-linux@bohmer.net> <20110731150707.GA2975@n2100.arm.linux.org.uk> <CANqCtQJwUsLXfA408GzAr0rQtc2DRjtKqP8-m2UBUGEy-YP5dg@mail.gmail.com> <20110801092806.GD15578@n2100.arm.linux.org.uk> <CANqCtQK=H_B04A7knZSiuE5RLogTgMKxwtMK1HSqSgKA_U2J7A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANqCtQK=H_B04A7knZSiuE5RLogTgMKxwtMK1HSqSgKA_U2J7A@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 01, 2011 at 08:08:19PM +0200, Remy Bohmer wrote:
> Hi,
> 
> > You're forgetting that jiffies doesn't jump about.  A late initializing
> > sched_clock could jump.
> 
> Agreed. Currently the jiffies based clock does not move at all, thus
> it surely does not jump... ;-)
> 
> >> Anyway, do you have a better suggestion how to fix this? The tcb
> >> clocksource is loaded during a arch_initcall(), perhaps we need
> >> something before that point.
> >> I do not see an easy way to integrate it in MACHINE_START(.timer).
> >> Would 'late_time_init' be a better solution?
> >
> > late_time_init() is not that much better as that still happens after
> > sched_init() has been called.  sched_init() initializes various
> > structures which involves reading sched_clock().
> 
> But late_time_init does it before the sched_clock is declared stable.
> Until that point sched_clock will always return zero, as such we can
> IMHO safely assume that the scheduler is designed such that it can
> handle fixed zero timestamps for a while.

You're confused.

If you provide your own sched_clock(), that's what is used by everyone
who calls sched_clock() both before and after sched_clock_init() has
been called.

sched_clock_cpu() and cpu_clock() both will return zero up until
sched_clock_init() has been called, but sched_clock() itself may not.

And these parts of the scheduler I'm talking about use sched_clock()
itself, not sched_clock_cpu() nor cpu_clock().
