Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411Ab0IRJcN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 05:32:13 -0400
Received: from www.tglx.de ([62.245.132.106]:52178 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755345Ab0IRJcM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 05:32:12 -0400
Date: Sat, 18 Sep 2010 11:31:53 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Richard Cochran <richardcochran@gmail.com>
cc: john stultz <johnstul@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH] Posix CLOCK_RTC interface proof of concept
In-Reply-To: <20100918061528.GA3249@riccoc20.at.omicron.at>
Message-ID: <alpine.LFD.2.00.1009181127090.2416@localhost6.localdomain6>
References: <1284666092-23347-1-git-send-email-john.stultz@linaro.org> <alpine.LFD.2.00.1009171154430.2416@localhost6.localdomain6> <1284748958.2451.68.camel@localhost.localdomain> <20100918061528.GA3249@riccoc20.at.omicron.at>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 18 Sep 2010, Richard Cochran wrote:

> On Fri, Sep 17, 2010 at 11:42:38AM -0700, john stultz wrote:
> > On Fri, 2010-09-17 at 12:59 +0200, Thomas Gleixner wrote:
> > > That's basically a copy of enqueue_hrtimer(). Can't we use
> > > k_itimer.it.real for this and reuse the related functions in
> > > hrtimer.c? Not sure if it's worth the trouble though.
> > 
> > Yes, there's also a similar duplication in drivers/char/mmtimer.c and
> > Richard Cochran commented on the same (although I'm not sure if he ended
> > up using the hrtimer for his similar PTP code).
> 
> After taking a look at the hrtimer code, I decided to remove the timer
> implementation from the patch set. I do have the userland interface to
> timer_create/settime in place, but no clock drivers implement it yet.
>  
> > I was hoping to find something I could re-use in the hrtimer code, but
> > it seemed a little tightly linked to the fixed CLOCK_MONOTONIC/REALTIME
> > bases.
> 
> That was my impression, too. It looks like hrtimers are hard-coded to
> the clock event device via a global per-cpu variable. Would it be
> possible to decouple this for multiple, different clock event devices?

It needs some thought because the REALTIME/MONOTONIC implementation
needs to stay with the per cpu ness, but for RTC and others we need a
global queue. Though it shouldn't be too hard to solve that.

Thanks,

	tglx
