Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751915Ab1AXWKv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 17:10:51 -0500
Received: from www.tglx.de ([62.245.132.106]:36400 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751107Ab1AXWKv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 17:10:51 -0500
Date: Mon, 24 Jan 2011 23:10:18 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: john stultz <johnstul@us.ibm.com>
cc: Torben Hohn <torbenh@gmx.de>, LKML <linux-kernel@vger.kernel.org>,
        hch@infradead.org, yong.zhang0@gmail.com,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 01/18] move do_timer() from kernel/timer.c into
 kernel/time/timekeeping.c
In-Reply-To: <1295901169.4845.29.camel@work-vm>
Message-ID: <alpine.LFD.2.00.1101242254420.31804@localhost6.localdomain6>
References: <1295651224-29823-1-git-send-email-torbenh@gmx.de>  <1295651224-29823-2-git-send-email-torbenh@gmx.de> <1295901169.4845.29.camel@work-vm>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

B1;2401;0cOn Mon, 24 Jan 2011, john stultz wrote:
> I'm guessing Thomas is thinking to move these bits into timekeeping.c so
> xtime_lock can be made static there, it just strikes me oddly.
> Especially since jiffies access is still going to need the xtime_lock,
> so we'd have to move all the jiffies code into timekeeping.c to do so.

That should go into jiffies.c. We don't need to move everything to
timekeeping.c.
 
> Splitting the xtime_lock int a static timekeeper.lock and a static
> jiffies_lock might be the clean way to divide things, but that really
> just adds extra locking overhead. But maybe that's not much of an issue.
> 
> Thomas: I suspect I'm just not seeing where you're going with this.
> Could you clarify a bit? :)

We really want to restrict xtime_lock to the core timekeeping
code. xtime_update() is really meant to take care of the timekeeping
updates. do_timer() is a horrible misnomer today.

The call to calc_global_load() is there for hysterical raisins and we
really should get rid of it sooner than later. I'm quite sure that it
could be run from a timer callback as well. Peter ?

Does that answer your questions ?

Thanks,

	tglx


