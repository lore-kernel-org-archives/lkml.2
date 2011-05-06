Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756443Ab1EFNgO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 09:36:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12849 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756428Ab1EFNgN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 09:36:13 -0400
Subject: Re: [PATCH 5/7] seccomp_filter: Document what seccomp_filter is and
 how it works.
From: Eric Paris <eparis@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Will Drewry <wad@chromium.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        kees.cook@canonical.com, agl@chromium.org, jmorris@namei.org,
        Randy Dunlap <rdunlap@xenotime.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Fri, 06 May 2011 09:35:37 -0400
In-Reply-To: <1304682803.25414.2520.camel@gandalf.stny.rr.com>
References: <20110428070636.GC952@elte.hu>
	 <1304002571.2101.38.camel@localhost.localdomain>
	 <BANLkTi=5NYTM5T2LthVL+8kjQvYWwHSVPg@mail.gmail.com>
	 <20110429131845.GA1768@nowhere>
	 <BANLkTimhWZURqgAXG45=3CG-bNhv+g-Ftg@mail.gmail.com>
	 <20110503012857.GA8399@nowhere>
	 <BANLkTimhugGCnMQ4f2T2HOvwVLrGTREPkg@mail.gmail.com>
	 <BANLkTimPFHwJfqXHShnOt7mBp84NQQNWDw@mail.gmail.com>
	 <20110504175229.GB1804@nowhere>
	 <1304533382.25414.2447.camel@gandalf.stny.rr.com>
	 <20110504183052.GD1804@nowhere>
	 <1304534785.25414.2452.camel@gandalf.stny.rr.com>
	 <BANLkTin2ZS8DCLGZXxV7EN+S-aNRK=B8Sw@mail.gmail.com>
	 <1304682803.25414.2520.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1304688940.10692.75.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-05-06 at 07:53 -0400, Steven Rostedt wrote:
> On Thu, 2011-05-05 at 02:21 -0700, Will Drewry wrote:
> 
> > In particular, if the userspace code wants to stage some filters and
> > apply them all at once, when ready, I'm not sure that it makes sense
> > to me to put that complexity in the kernel itself.  For instance,
> > Eric's second sample showed a call that took an array of ints and
> > coalesced them into "fd == %d || ...".  That simple example shows that
> > we could easily get by with a pretty minimal kernel-supported
> > interface as long as the richer behavior could live userspace side --
> > even if just in a simple helper library.  It'd be pretty easy to
> > implement a userspace library that exposed add_filter(syscall_nr,
> > filter) and apply_filters() such that it could manage building the
> > final filter string for a given syscall and pushing it to prctl on
> > apply.
> 
> I'm fine with a single kernel call and the "temporary filter" be done in
> userspace. Making the kernel code less complex is better :)

I'm also starting to think a userspace library is a good idea as well.
Everything in the kernel is an && with nothing but SET and APPLY.  We
provide interfaces to build the strings as we go along including UNSET
and stuff like that if there are users....

-Eric

