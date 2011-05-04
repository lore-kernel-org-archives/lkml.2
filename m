Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755043Ab1EDPzn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 11:55:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22805 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752705Ab1EDPzm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 11:55:42 -0400
Subject: Re: [PATCH 5/7] seccomp_filter: Document what seccomp_filter is and
 how it works.
From: Eric Paris <eparis@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Will Drewry <wad@chromium.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        kees.cook@canonical.com, agl@chromium.org, jmorris@namei.org,
        Randy Dunlap <rdunlap@xenotime.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Wed, 04 May 2011 11:54:22 -0400
In-Reply-To: <1304511396.25414.2422.camel@gandalf.stny.rr.com>
References: <1303960136-14298-1-git-send-email-wad@chromium.org>
	 <1303960136-14298-4-git-send-email-wad@chromium.org>
	 <20110428070636.GC952@elte.hu>
	 <1304002571.2101.38.camel@localhost.localdomain>
	 <BANLkTi=5NYTM5T2LthVL+8kjQvYWwHSVPg@mail.gmail.com>
	 <20110429131845.GA1768@nowhere>
	 <BANLkTimhWZURqgAXG45=3CG-bNhv+g-Ftg@mail.gmail.com>
	 <20110503012857.GA8399@nowhere>
	 <BANLkTimhugGCnMQ4f2T2HOvwVLrGTREPkg@mail.gmail.com>
	 <1304511396.25414.2422.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1304524465.10692.21.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-04 at 08:16 -0400, Steven Rostedt wrote:
> On Tue, 2011-05-03 at 03:47 +0200, Frederic Weisbecker wrote:
> > 2011/5/3 Frederic Weisbecker <fweisbec@gmail.com>:
> 
> > Even better: applying a filter would always automatically be an
> > intersection of the previous one.
> > 
> > If you do:
> > 
> > SECCOMP_FILTER_SET, __NR_foo, "a == 1 || a == 2"
> > SECCOMP_FILTER_APPLY
> > SECCOMP_FILTER_SET, __NR_foo, "b == 2"
> > SECCOMP_FILTER_APPLY
> > SECCOMP_FILTER_SET, __NR_foo, "c == 3"
> > SECCOMP_FILTER_APPLY
> > 
> > The end result is:
> > 
> > "(a == 1 || a == 2) && b == 2  && c == 3"
> > 
> 
> I'm a little confused. Why do we have both a FILTER_SET and a
> FILTER_APPLY? Maybe this was discussed earlier in the thread and I
> missed it or simply forgot.
> 
> Why not just apply on the set call?

As this is a deny by default interface which only allows you to further
restrict you couldn't add more than 1 syscall if you didn't have an
explict 'apply' action.

SECCOMP_FILTER_SET, __NR_fo, "a=0"
SECCOMP_FILTER_SET, __NR_read, "1" == EPERM

Maybe apply on set is fine after the first apply, but we definitely need
some way to do more than 1 set before the rules are applied....

-Eric

