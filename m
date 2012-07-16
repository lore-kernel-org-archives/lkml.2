Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494Ab2GPQ0O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 12:26:14 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:40975 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751888Ab2GPQ0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 12:26:12 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+WANxMadKW6Fdg8m9b+2GrkDVm176NRgSyZJN2ep
	speRdM3m7im+7M
Message-ID: <1342455968.7659.93.camel@marge.simpson.net>
Subject: Re: 3.4.4-rt13: btrfs + xfstests 006 = BOOM..  and a bonus rt_mutex
 deadlock report for absolutely free!
From: Mike Galbraith <efault@gmx.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Chris Mason <chris.mason@fusionio.com>,
        "Chris L. Mason" <clmason@fusionio.com>,
        "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Mon, 16 Jul 2012 18:26:08 +0200
In-Reply-To: <1342454547.5410.3.camel@gandalf.stny.rr.com>
References: <1342072060.7338.102.camel@marge.simpson.net>
	 <20120713125043.GH30128@shiny> <1342260883.7368.30.camel@marge.simpson.net>
	 <20120715175612.GF25961@shiny.int.fusionio.com>
	 <1342404140.7659.27.camel@marge.simpson.net>
	 <1342454547.5410.3.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-16 at 12:02 -0400, Steven Rostedt wrote: 
> On Mon, 2012-07-16 at 04:02 +0200, Mike Galbraith wrote:
> 
> > > Great, thanks!  I got stuck in bug land on Friday.  You mentioned
> > > performance problems earlier on Saturday, did this improve performance?
> > 
> > Yeah, the read_trylock() seems to improve throughput.  That's not
> > heavily tested, but it certainly looks like it does.  No idea why.
> 
> Ouch, you just turned the rt_read_lock() into a spin lock. If a higher
> priority process preempted a lower priority process that holds the same
> lock, it will deadlock.

Hm, how, it's doing cpu_chill()?

> I'm not sure why you would get a performance benefit from this, as the
> mutex used is an adaptive one (failure to acquire the lock will only
> sleep if preempted or if the owner is not running).

I'm not attached to it, can whack it in a heartbeat.. especially so it
the thing can deadlock.  I've seen enough of those of late.

> We should look at why this performs better (if it really does).

Not sure it really does, there's variance, but it looked like it did.

-Mike


