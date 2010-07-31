Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750832Ab0GaEB1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jul 2010 00:01:27 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:60752 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1750709Ab0GaEB0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jul 2010 00:01:26 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX193cZRdAwZ3MZpT73Vo1ZaXmkJ2R0KzMH2dCM68Nm
	s4dwAYT76ZMx1J
Subject: Re: Regression (bisected): Lots of wakeups when using battery
From: Mike Galbraith <efault@gmx.de>
To: Jaime Velasco Juan <jsagarribay@gmail.com>
Cc: a.p.zijlstra@hello.nl, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20100730214523.GA5571@pogo>
References: <20100730214523.GA5571@pogo>
Content-Type: text/plain
Date: Sat, 31 Jul 2010 06:01:42 +0200
Message-Id: <1280548902.9686.51.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(corrects cc)

On Fri, 2010-07-30 at 22:45 +0100, Jaime Velasco Juan wrote:
> Hi, testing 2.6.35-rc5 I noticed that when my laptop is on battery,
> there are bursts of wakeups (they seem random, but usually happens once
> each 5 sec. or so; they cause some audible noise). If the laptop is plugged
> it behaves well. In single user mode, there are usually 2 wakeups/sec with
> the system idle, but on battery an with the bug, it goes to more than 100 w/s.
> 
> Bisection points to:
> 
> commit 3310d4d38fbc514e7b18bd3b1eea8effdd63b5aa
> Author: Peter Zijlstra <peterz@infradead.org>
> Date:   Thu Jun 17 18:02:37 2010 +0200
> 
>     nohz: Fix nohz ratelimit
>     
>     Chris Wedgwood reports that 39c0cbe (sched: Rate-limit nohz) causes a
>     serial console regression, unresponsiveness, and indeed it does. The
>     reason is that the nohz code is skipped even when the tick was already
>     stopped before the nohz_ratelimit(cpu) condition changed.
>     
>     Move the nohz_ratelimit() check to the other conditions which prevent
>     long idle sleeps.
> 
> Reverting said commit seems to fix the issue.

And if you revert that, using a serial console becomes.. unpleasant.

The whole ratelimit nohz thing has been dropped for now.  It's a nice
little optimization for high frequency switchers on an underutilized
box, but has caused more irritation than it's worth.

	-Mike

