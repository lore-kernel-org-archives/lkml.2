Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908Ab2IOD5V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 23:57:21 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:57705 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751344Ab2IOD5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 23:57:19 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+SfIYS4A6S+LQsfdwp3gDZ0cEjLYSj6LW6hVG3tp
	tBonfLuHWTXE1r
Message-ID: <1347681435.4340.154.camel@marge.simpson.net>
Subject: Re: 20% performance drop on PostgreSQL 9.2 from kernel 3.5.3 to
 3.6-rc5 on AMD chipsets - bisected
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Nikolay Ulyanitsky <lystor@gmail.com>,
        linux-kernel@vger.kernel.org,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
Date: Sat, 15 Sep 2012 05:57:15 +0200
In-Reply-To: <1347659971.7172.99.camel@twins>
References: <CA+Medix98MHYzpKSDKKWf7Wew0H4zDFsUS74LrhsP2Lxemd3Mw@mail.gmail.com>
	 <20120914212717.GA29307@liondog.tnic> <1347658843.7172.90.camel@twins>
	 <CA+55aFz6SxLEr0MNubz7rcwcqki7EM33Vp-q3KFEvuLG6a61ZQ@mail.gmail.com>
	 <1347659777.7172.97.camel@twins> <1347659971.7172.99.camel@twins>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-09-14 at 23:59 +0200, Peter Zijlstra wrote: 
> On Fri, 2012-09-14 at 23:56 +0200, Peter Zijlstra wrote:
> > On Fri, 2012-09-14 at 14:44 -0700, Linus Torvalds wrote:
> > > On Fri, Sep 14, 2012 at 2:40 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > > >
> > > > The problem the patch is trying to address is not having to scan an
> > > > entire package for idle cores on every wakeup now that packages are
> > > > getting stupid big.
> > > 
> > > No, it does something *else* too. That whole "left-right" logic to
> > > (according to the commit message) "prevent bouncing" is entirely new,
> > > afaik.
> > > 
> > > So it is *not* just about avoiding to have to scan the whole package.
> > > It changes actual semantics too. No?
> > 
> > Both things change semantics, not looking at the entire package is new
> > too. But yeah I guess you could look at the exact cross-stitching as an
> > enhancement to the 'idle_buggy' thing.
> 
> What I'm saying is that having an idle_buggy means you have to assign
> one in the first place, his left-right stuff might not be the simplest
> means to do that -- in fact I suggested he do a simple shift first time
> I saw that patch.

Shift just means that upon perturbation, tasks shift their way around
the package vs random bounce around, that's why I cross wired.
> So if not the left-right thing, you still need to do _something_ to make
> the idle_buggy work at all. So its not entirely separate.

Yeah.

-Mike


