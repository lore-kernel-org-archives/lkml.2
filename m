Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234Ab1GEJvD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 05:51:03 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41165 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755138Ab1GEJvA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 05:51:00 -0400
Date: Tue, 5 Jul 2011 11:50:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Will Drewry <wad@chromium.org>
Cc: James Morris <jmorris@namei.org>, Chris Evans <scarybeasts@gmail.com>,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>, djm@mindrot.org,
        segoon@openwall.com, kees.cook@canonical.com, rostedt@goodmis.org,
        fweisbec@gmail.com, tglx@linutronix.de,
        Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org,
        Eric Paris <eparis@redhat.com>, linux-security-module@vger.kernel.org
Subject: Re: [PATCH v9 05/13] seccomp_filter: Document what seccomp_filter is
 and how it works.
Message-ID: <20110705095019.GC5725@elte.hu>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTik2YtBbC+T3zyCooK71zZ_z2FdJuQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Will Drewry <wad@chromium.org> wrote:

> > In the end the 'sandboxing' feature should be a few dozen lines 
> > at most - all the rest will just be shared infrastructure.
> 
> Anytime a powerful feature can be a few lines of code, it's a good 
> thing.  It seems like we're still a ways away from defining what 
> the shared infrastructure is that would allow a few dozen lines of 
> code to be enough.  The bones are there, but there's a large amount 
> of missing and under-designed work.

But adding some intermediate solution with its own ABI and its own 
forked specializations hinders (and might even prevent, if it's "good 
enough") the proper solution of this topic.

It's not like such features are in super-high demand so we *want* and 
*need* as much generalization and unification as possible, to utilize 
economies of scale and such.

There's really just two ways forward that i can see (in terms of this 
going upstream via the events/tracing/instrumentation tree that i 
co-maintain):

 1) Do it properly generalized - as shown by the prototype patch.
    I can give you all help that is needed for that: we can host
    intermediate stages in -tip and we can push upstream step by
    step. You won't have to maintain some large in-limbo set of
    patches. 95% of the work you've identified will be warmly
    welcome by everyone and will be utilized well beyond sandboxing! 
    That's not a bad starting position to get something controversial 
    upstream: most of the crazy trees are 95% crazy.

 2) Give a compelling list of technical reasons why the
    generalization is not desirable and thus go for a minimally
    invasive solution

Option #2 does not apply because you've yourself stated that the 
generalizations make a ton of sense (and even if you didnt state it 
i'd make that point).

The option you seem to have opted for:

 3) do it in a half-ways and limited fashion due to time constraints 
    and perceived upstream resistence

is not something that was a winning model in the past so i'm not 
really interested in that.

Thanks,

	Ingo
