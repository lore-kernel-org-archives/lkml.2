Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571Ab2GPQgc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 12:36:32 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:57068 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752976Ab2GPQg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 12:36:29 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+ngj4DPCmnlokoYf8OPMMF1gpTeiCRRy7JNETgEy
	GcdmEkmSpDpCOE
Message-ID: <1342456567.7659.97.camel@marge.simpson.net>
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
Date: Mon, 16 Jul 2012 18:36:07 +0200
In-Reply-To: <1342455968.7659.93.camel@marge.simpson.net>
References: <1342072060.7338.102.camel@marge.simpson.net>
	 <20120713125043.GH30128@shiny> <1342260883.7368.30.camel@marge.simpson.net>
	 <20120715175612.GF25961@shiny.int.fusionio.com>
	 <1342404140.7659.27.camel@marge.simpson.net>
	 <1342454547.5410.3.camel@gandalf.stny.rr.com>
	 <1342455968.7659.93.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-16 at 18:26 +0200, Mike Galbraith wrote: 
> On Mon, 2012-07-16 at 12:02 -0400, Steven Rostedt wrote: 
> > On Mon, 2012-07-16 at 04:02 +0200, Mike Galbraith wrote:
> > 
> > > > Great, thanks!  I got stuck in bug land on Friday.  You mentioned
> > > > performance problems earlier on Saturday, did this improve performance?
> > > 
> > > Yeah, the read_trylock() seems to improve throughput.  That's not
> > > heavily tested, but it certainly looks like it does.  No idea why.
> > 
> > Ouch, you just turned the rt_read_lock() into a spin lock. If a higher
> > priority process preempted a lower priority process that holds the same
> > lock, it will deadlock.
> 
> Hm, how, it's doing cpu_chill()?

'course PI is toast, so *poof*.  Since just enabling the lockdep bits
seems to fix it up, maybe that's the patchlet to submit (less is more).

-Mike

