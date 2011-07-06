Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755247Ab1GFSY0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 14:24:26 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47016 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753831Ab1GFSYY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 14:24:24 -0400
MIME-Version: 1.0
In-Reply-To: <20110705095019.GC5725@elte.hu>
References: <BANLkTi=sB2R-gWM30a0KKSGXz5p7OHRfeA@mail.gmail.com>
	<alpine.LRH.2.00.1106301128590.13496@tundra.namei.org>
	<20110701115600.GK20990@elte.hu>
	<BANLkTim8CGx89nOg0HX=S1=arunBU3sEGQ@mail.gmail.com>
	<20110701130705.GG12605@elte.hu>
	<BANLkTimN0nEa2Bog2-vzCv=1XOG5OsJjLA@mail.gmail.com>
	<20110701161027.GA29035@elte.hu>
	<BANLkTikCaACO8o9HkAnkuaTuoKqqQWQrtw@mail.gmail.com>
	<20110701210011.GA22171@elte.hu>
	<BANLkTik2YtBbC+T3zyCooK71zZ_z2FdJuQ@mail.gmail.com>
	<20110705095019.GC5725@elte.hu>
Date: Wed, 6 Jul 2011 13:24:22 -0500
Message-ID: <CABqD9hYme6fSTfeTG+351sMu=Uh5PxE3-ASTXi8Tk17n2y_29A@mail.gmail.com>
Subject: Re: [PATCH v9 05/13] seccomp_filter: Document what seccomp_filter is
 and how it works.
From: Will Drewry <wad@chromium.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: James Morris <jmorris@namei.org>, Chris Evans <scarybeasts@gmail.com>,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>, djm@mindrot.org,
        segoon@openwall.com, kees.cook@canonical.com, rostedt@goodmis.org,
        fweisbec@gmail.com, tglx@linutronix.de,
        Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org,
        Eric Paris <eparis@redhat.com>, linux-security-module@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 5, 2011 at 4:50 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Will Drewry <wad@chromium.org> wrote:
>
>> > In the end the 'sandboxing' feature should be a few dozen lines
>> > at most - all the rest will just be shared infrastructure.
>>
>> Anytime a powerful feature can be a few lines of code, it's a good
>> thing.  It seems like we're still a ways away from defining what
>> the shared infrastructure is that would allow a few dozen lines of
>> code to be enough.  The bones are there, but there's a large amount
>> of missing and under-designed work.
>
> But adding some intermediate solution with its own ABI and its own
> forked specializations hinders (and might even prevent, if it's "good
> enough") the proper solution of this topic.
>
> It's not like such features are in super-high demand so we *want* and
> *need* as much generalization and unification as possible, to utilize
> economies of scale and such.
>
> There's really just two ways forward that i can see (in terms of this
> going upstream via the events/tracing/instrumentation tree that i
> co-maintain):
>
>  1) Do it properly generalized - as shown by the prototype patch.
>    I can give you all help that is needed for that: we can host
>    intermediate stages in -tip and we can push upstream step by
>    step. You won't have to maintain some large in-limbo set of
>    patches. 95% of the work you've identified will be warmly
>    welcome by everyone and will be utilized well beyond sandboxing!
>    That's not a bad starting position to get something controversial
>    upstream: most of the crazy trees are 95% crazy.
>
>  2) Give a compelling list of technical reasons why the
>    generalization is not desirable and thus go for a minimally
>    invasive solution
>
> Option #2 does not apply because you've yourself stated that the
> generalizations make a ton of sense (and even if you didnt state it
> i'd make that point).
>
> The option you seem to have opted for:
>
>  3) do it in a half-ways and limited fashion due to time constraints
>    and perceived upstream resistence
>
> is not something that was a winning model in the past so i'm not
> really interested in that.


My connectivity it a bit limiting right now, but I'll go think through
what we've discussed in these threads and what you propose here and
see if I can chart out a path that makes sense to me, or if there are
pieces I just can't resolve.  I'll follow up soon-ish.

My main concerns at this point center around making sure that whatever
solution results still implements the original goal of the patch set
-- to reduce the attack surface of the kernel in a reliable way.
Having a robust plan will help there, I hope, and give others
something to provide constructive feedback on.  Also, I'd much prefer
to be making progress on this sooner rather than waiting until October
just to figure out where to begin.  As is, I'm not entirely sold that
perf/ftrace event ids are the right interface*, but it does make sense
to explore it more thoroughly given their use in the event analysis in
this patch series.  Most likely, I'll be able to resolve my own
objection :)

thanks,
will


*  For instance, I can compile a filter set with __NR_unistd as the id
in the current patch series and have that compiled code work when run
without traversing a debugfs mount point.  That will just be another
area to be addressed in whatever the next solution is.
