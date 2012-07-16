Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466Ab2GPQfp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 12:35:45 -0400
Received: from mx2.fusionio.com ([66.114.96.31]:59200 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752976Ab2GPQfm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 12:35:42 -0400
X-ASG-Debug-ID: 1342456541-0421b505a81bae0001-xx1T2L
X-Barracuda-Envelope-From: clmason@fusionio.com
Date: Mon, 16 Jul 2012 12:35:39 -0400
From: Chris Mason <chris.mason@fusionio.com>
To: Mike Galbraith <efault@gmx.de>
CC: Steven Rostedt <rostedt@goodmis.org>,
        "Chris L. Mason" <clmason@fusionio.com>,
        "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 3.4.4-rt13: btrfs + xfstests 006 = BOOM..  and a bonus rt_mutex
 deadlock report for absolutely free!
Message-ID: <20120716163539.GH25961@shiny.int.fusionio.com>
X-ASG-Orig-Subj: Re: 3.4.4-rt13: btrfs + xfstests 006 = BOOM..  and a bonus rt_mutex
 deadlock report for absolutely free!
Mail-Followup-To: Chris Mason <chris.mason@fusionio.com>,
	Mike Galbraith <efault@gmx.de>, Steven Rostedt <rostedt@goodmis.org>,
	"Chris L. Mason" <clmason@fusionio.com>,
	"linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>
References: <1342072060.7338.102.camel@marge.simpson.net>
 <20120713125043.GH30128@shiny>
 <1342260883.7368.30.camel@marge.simpson.net>
 <20120715175612.GF25961@shiny.int.fusionio.com>
 <1342404140.7659.27.camel@marge.simpson.net>
 <1342454547.5410.3.camel@gandalf.stny.rr.com>
 <1342455968.7659.93.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1342455968.7659.93.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2011-07-01)
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1342456541
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.60
X-Barracuda-Spam-Status: No, SCORE=0.60 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=MARKETING_SUBJECT
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.102878
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.60 MARKETING_SUBJECT      Subject contains popular marketing words
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 16, 2012 at 10:26:08AM -0600, Mike Galbraith wrote:
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
> 
> > I'm not sure why you would get a performance benefit from this, as the
> > mutex used is an adaptive one (failure to acquire the lock will only
> > sleep if preempted or if the owner is not running).
> 
> I'm not attached to it, can whack it in a heartbeat.. especially so it
> the thing can deadlock.  I've seen enough of those of late.
> 
> > We should look at why this performs better (if it really does).
> 
> Not sure it really does, there's variance, but it looked like it did.
> 

I'd use a benchmark that is more consistent than dbench for this.  I
love dbench for generating load (and the occasional deadlock) but it
tends to steer you in the wrong direction on performance.

-chris

