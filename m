Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163Ab1EDR4A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 13:56:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5282 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754647Ab1EDRz7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 13:55:59 -0400
Subject: Re: [PATCH 5/7] seccomp_filter: Document what seccomp_filter is and
 how it works.
From: Eric Paris <eparis@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Will Drewry <wad@chromium.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        kees.cook@canonical.com, agl@chromium.org, jmorris@namei.org,
        Randy Dunlap <rdunlap@xenotime.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Wed, 04 May 2011 13:55:33 -0400
In-Reply-To: <20110504170353.GA1804@nowhere>
References: <1304002571.2101.38.camel@localhost.localdomain>
	 <BANLkTi=5NYTM5T2LthVL+8kjQvYWwHSVPg@mail.gmail.com>
	 <20110429131845.GA1768@nowhere>
	 <BANLkTimhWZURqgAXG45=3CG-bNhv+g-Ftg@mail.gmail.com>
	 <20110503012857.GA8399@nowhere>
	 <BANLkTimhugGCnMQ4f2T2HOvwVLrGTREPkg@mail.gmail.com>
	 <1304511396.25414.2422.camel@gandalf.stny.rr.com>
	 <1304524465.10692.21.camel@localhost.localdomain>
	 <1304525169.25414.2427.camel@gandalf.stny.rr.com>
	 <1304526163.10692.33.camel@localhost.localdomain>
	 <20110504170353.GA1804@nowhere>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1304531735.10692.58.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-04 at 19:03 +0200, Frederic Weisbecker wrote:
> On Wed, May 04, 2011 at 12:22:40PM -0400, Eric Paris wrote:
> So the following set of operations:
> > 
> > SECCOMP_FILTER_SET, __NR_foo, "a=0"
> > SECCOMP_FILTER_SET, __NR_read, "1"
> > SECCOPM_FILTER_APPLY
> >  
> > SECCOMP_FILTER_SET, __NR_foo, "b=0"
> > SECCOMP_FILTER_APPLY
> > 
> > SECCOMP_FILTER_SET, __NR_write, "1"
> > SECCOMP_FILTER_APPLY
> > 
> > Would return EPERM for the __NR_write entry since it was a new syscall
> > after a set.  I think we agree on all this.
> 
> No, why?
> 
> The default filter for a syscall, if none have been given for it, is "0".
> 
> Thus, if you write "1" later, the entire filter is going to be:
> 
> 	"0 && 1"
> 
> Which is fine, we are not overriding already applied permissions there.
> 
> So where is the need to return -EPERM in such a specific case? Is it
> worth the corner case to check in the kernel, and to handle in userspace?
> And for what reason?

I assumed without looking at the code (always a bad idea) that he wasn't
going to explicitly create a rule with "0" and was going to implicitly
deny anything without a rule.  If there is an explicit "0" rule then you
are right, i don't see a need to deny the set operation in the kernel.
But if it is implicit in the non-existence of a filter then it should be
easy to tell userspace it isn't allowed any more.

-Eric

-Eric


