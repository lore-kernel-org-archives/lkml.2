Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691Ab1EGCLp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 22:11:45 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37838 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754422Ab1EGCLo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 22:11:44 -0400
MIME-Version: 1.0
In-Reply-To: <1304699437.10692.78.camel@localhost.localdomain>
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
	<1304699437.10692.78.camel@localhost.localdomain>
Date: Fri, 6 May 2011 19:11:42 -0700
Message-ID: <BANLkTi==w7b7w2e0p2TeQqwomuRdw6zTSQ@mail.gmail.com>
Subject: Re: [PATCH 5/7] seccomp_filter: Document what seccomp_filter is and
 how it works.
From: Will Drewry <wad@chromium.org>
To: Eric Paris <eparis@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, kees.cook@canonical.com,
        agl@chromium.org, jmorris@namei.org,
        Randy Dunlap <rdunlap@xenotime.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 6, 2011 at 6:35 AM, Eric Paris <eparis@redhat.com> wrote:
> I'm also starting to think a userspace library is a good idea as well.
> Everything in the kernel is an && with nothing but SET and APPLY.  We
> provide interfaces to build the strings as we go along including UNSET
> and stuff like that if there are users....

That sounds ideal to me. I think it'll be worth tagging this config
option as EXPERIMENTAL to begin with so that there's a chance to see
those of us who want it using it more widely and find out if there are
missing pieces or dumb limitations.  Hopefully by starting minimal, it
won't be a huge departure to evolve it if needed.

On Fri, May 6, 2011 at 9:30 AM, Eric Paris <eparis@redhat.com> wrote:

> On Thu, 2011-05-05 at 02:21 -0700, Will Drewry wrote:
>> On Wed, May 4, 2011 at 11:46 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
>
>> In particular, if the userspace code wants to stage some filters and
>> apply them all at once, when ready, I'm not sure that it makes sense
>> to me to put that complexity in the kernel itself.  For instance,
>> Eric's second sample showed a call that took an array of ints and
>> coalesced them into "fd == %d || ...".  That simple example shows that
>> we could easily get by with a pretty minimal kernel-supported
>> interface as long as the richer behavior could live userspace side --
>> even if just in a simple helper library.  It'd be pretty easy to
>> implement a userspace library that exposed add_filter(syscall_nr,
>> filter) and apply_filters() such that it could manage building the
>> final filter string for a given syscall and pushing it to prctl on
>> apply.
>
> Had a few minutes this morning so I started writing something that looks
> sorta like a userspace library.  It dosn't have unset yet but I don't
> think it'll be that hard for me to implement.  You can build some pretty
> complex filters easily.  Not sure when I'll get to work on it more, but
> it at least shows the idea of doing the complex work in a library and
> keeping a simple kernel interface....  Any thoughts?

Cool! I was thrown a little bit by spelling out the operations (eq,
ne, ..), but I can see how it might be useful for being able to
synthesize good filters before passing them off to the kernel.

It sounds like we might be moving towards a good starting point.  I'll
start playing with the interface some (and start on the kernel support
too :).

thanks!
