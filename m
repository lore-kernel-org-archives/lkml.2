Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756787Ab2HNRoh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 13:44:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:29808 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754939Ab2HNRof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 13:44:35 -0400
X-Authority-Analysis: v=2.0 cv=LIjkseq9 c=1 sm=0 a=s5Htg7xnQOKvHEu9STBOug==:17 a=OpT9cpI26MMA:10 a=HMINAUNbf7oA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=TNLAKgqMk2JoBKEYc2wA:9 a=PUjeQqilurYA:10 a=s5Htg7xnQOKvHEu9STBOug==:117
X-Cloudmark-Score: 0
X-Originating-IP: 72.230.195.127
Message-ID: <1344966273.6724.18.camel@gandalf.stny.rr.com>
Subject: Re: [rfc patch] fs,reiserfs: unlock superblock before callling
 reiserfs_quota_on_mount()
From: Steven Rostedt <rostedt@goodmis.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 14 Aug 2012 13:44:33 -0400
In-Reply-To: <1344965173.4282.3.camel@marge.simpson.net>
References: <1344949583.14924.36.camel@marge.simpson.net>
	 <1344954183.6724.8.camel@gandalf.stny.rr.com>
	 <1344955168.14924.85.camel@marge.simpson.net>
	 <1344956189.5477.1.camel@marge.simpson.net>
	 <alpine.LFD.2.02.1208141717570.32033@ionos>
	 <1344965173.4282.3.camel@marge.simpson.net>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-08-14 at 19:26 +0200, Mike Galbraith wrote:
> On Tue, 2012-08-14 at 17:18 +0200, Thomas Gleixner wrote: 
> > On Tue, 14 Aug 2012, Mike Galbraith wrote:
> > 
> > > On Tue, 2012-08-14 at 16:39 +0200, Mike Galbraith wrote: 
> > > > On Tue, 2012-08-14 at 10:23 -0400, Steven Rostedt wrote: 
> > > > > On Tue, 2012-08-14 at 15:06 +0200, Mike Galbraith wrote:
> > > > > > Greetings,
> > > > > > 
> > > > > > Using openSUSE's "partitioner" gizmo to set up a reiserfs partition with
> > > > > > quotas and whatnot enabled rewarded me with a deadlock.
> > > > > 
> > > > > Is this just a -rt bug? Can't this deadlock also in mainline?
> > > > 
> > > > It didn't with a NOPREEMPT kernel the one time I tried it, which seemed
> > > > mighty odd when I stared at the rt deadlock.  I'll give it another go, I
> > > > likely just munged q/d NOPREEMPT test.
> > > 
> > > Nope, no screw-up.  Maybe it can deadlock, but it refused to do so.
> > 
> > Lockdep should tell you if it could ...
> 
> I'll give that a shot.  I would expect the thing to gripe.. but then I
> expected the damn thing to deadlock properly with NOPREEMPT too, so.. :)
> 

But would it?

We have kworker blocked on the mutex where the owner did a flush_work(),
and waiting for kworker to finish because of a wait_for_completion(). I
don't see annotation here that will help lockdep catch such a thing.

-- Steve


