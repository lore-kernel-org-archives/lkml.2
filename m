Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756601Ab2HNR0T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 13:26:19 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:35268 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752140Ab2HNR0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 13:26:17 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19zBzVcwkRzjzNtJPyhxIURYPRcMLzoOaMILd2iHG
	/FT9/uC7yGjM1A
Message-ID: <1344965173.4282.3.camel@marge.simpson.net>
Subject: Re: [rfc patch] fs,reiserfs: unlock superblock before callling
 reiserfs_quota_on_mount()
From: Mike Galbraith <efault@gmx.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 14 Aug 2012 19:26:13 +0200
In-Reply-To: <alpine.LFD.2.02.1208141717570.32033@ionos>
References: <1344949583.14924.36.camel@marge.simpson.net>
	 <1344954183.6724.8.camel@gandalf.stny.rr.com>
	 <1344955168.14924.85.camel@marge.simpson.net>
	 <1344956189.5477.1.camel@marge.simpson.net>
	 <alpine.LFD.2.02.1208141717570.32033@ionos>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-08-14 at 17:18 +0200, Thomas Gleixner wrote: 
> On Tue, 14 Aug 2012, Mike Galbraith wrote:
> 
> > On Tue, 2012-08-14 at 16:39 +0200, Mike Galbraith wrote: 
> > > On Tue, 2012-08-14 at 10:23 -0400, Steven Rostedt wrote: 
> > > > On Tue, 2012-08-14 at 15:06 +0200, Mike Galbraith wrote:
> > > > > Greetings,
> > > > > 
> > > > > Using openSUSE's "partitioner" gizmo to set up a reiserfs partition with
> > > > > quotas and whatnot enabled rewarded me with a deadlock.
> > > > 
> > > > Is this just a -rt bug? Can't this deadlock also in mainline?
> > > 
> > > It didn't with a NOPREEMPT kernel the one time I tried it, which seemed
> > > mighty odd when I stared at the rt deadlock.  I'll give it another go, I
> > > likely just munged q/d NOPREEMPT test.
> > 
> > Nope, no screw-up.  Maybe it can deadlock, but it refused to do so.
> 
> Lockdep should tell you if it could ...

I'll give that a shot.  I would expect the thing to gripe.. but then I
expected the damn thing to deadlock properly with NOPREEMPT too, so.. :)

-Mike


