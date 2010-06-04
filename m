Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802Ab0FDH6S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 03:58:18 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58636 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753320Ab0FDH6Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 03:58:16 -0400
Date: Fri, 4 Jun 2010 09:57:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Brian Swetland <swetland@google.com>
Cc: tytso@mit.edu, Neil Brown <neilb@suse.de>,
       Arve Hj?nnev?g <arve@android.com>, Thomas Gleixner <tglx@linutronix.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Stern <stern@rowland.harvard.edu>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       James Bottomley <James.Bottomley@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: suspend blockers & Android integration
Message-ID: <20100604075722.GA15181@elte.hu>
References: <20100603193045.GA7188@elte.hu>
 <AANLkTinsOF3wnxsruR0TvjBAQcHks4tf0ay_sM2xB_p4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinsOF3wnxsruR0TvjBAQcHks4tf0ay_sM2xB_p4@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0018]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Brian Swetland <swetland@google.com> wrote:

> On Thu, Jun 3, 2010 at 12:30 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > Sadly the response from the Android team has been 100% uncompromising: either
> > suspend blockers or nothing.
> 
> Well, we're willing to accept something that gives us the same
> functionality (thus rewriting the api several times to meet various
> objections, current discussions around
> constraint-based-implementations / pm-qos, etc).  We believe we're
> solving a real problem here and have not seen a counter-proposal that
> accomplishes the same.
>
> Suggestions such as "just yell at developers for writing bad apps" or
> "it's the user's fault if they install a lousy app" or "make your app
> marketplace more restrictive" are not helpful. [...]

Agreed.

> [...]  The technical discussions around alternatives are more so (though I 
> do feel like we're going in circles in places), [...]

Yep.

> [...] which again is why we're still here talking about this (that and Arve 
> is about a billion times more patient and persistent than I am).
> 
> We're not interested in massively rearchitecting our userspace to accomplish 
> this (and the "rewrite your userspace!" proposals I've seen have had race 
> conditions and/or significant more complexity than the wakelock model).

Having a somewhat different ABI for achieving things you'll probably have 
prepare for. I doubt it would result in any large-scale, massive rewrites.

> ...
> 
> > Also, why did the Android team start its contributions with such a 
> > difficult and controversial kernel feature?
> 
> We started here because it's possibly the only api level change we have -- 
> almost everything else is driver or subarch type work or controversial but 
> entirely self-contained (like the binder, which I would be shocked to see 
> ever hit mainline). [...]

So why arent those bits mainline? It's a 1000 times easier to get drivers and 
small improvements and non-ABI changes upstream.

After basically two years of growing your fork (and some attempts to get your 
drivers into drivers/staging/ - from where they have meanwhile dropped out 
again) you re-started with the worst possible thing to merge: a big and 
difficult kernel feature affecting many subsystems. Why?

This is one of the fundamental problems here. People simply dont know you, 
because you have not worked with us much - and hence they dont trust you 
positively out of box - they are neutral at best.

And believe me, it's hard enough to get difficult features upstream if people 
_do_ know you and when they positively _do_ trust you ... Arent you talking to 
Andrew Morton about how to do these things properly? This is kernel 
contribution 101 really.

> [...]  Assertions have been made that because the "android kernel" (not a 
> term I like -- linux is linux, we have some assorted patches on top) [...]

I've been tracking android-common and android-msm for a while and i have to 
say that it shows a very lackluster attitude towards upstream:

 - The latest branches i can see are v2.6.32 based today. We are in the
   v2.6.35 stabilization cycle and are developing v2.6.36. I.e. your upstream
   base is about a year too old.

 - The last commit is a couple of weeks old AFAICS.

 - The diffstat of android-common/android-2.6.32 is:

      890 files changed, 39962 insertions(+), 6286 deletions(-)

   Those assorted patches have spread over nearly a thousand files. FYI, by
   the looks of it you are facing an exponentially worsening maintenance
   overhead curve here.

Is there perhaps some other tree i should be following? I'm looking at:

 [remote "android-msm"]
         url = git://android.git.kernel.org/kernel/msm.git
         fetch = +refs/heads/*:refs/remotes/android-msm/*
 [remote "android-common"]
         url = git://android.git.kernel.org/kernel/common.git
         fetch = +refs/heads/*:refs/remotes/android-common/*

Btw., the commits i've glanced at looked mostly clean and well structured, so 
i see no fundamental reason why this couldn't be done better.

> See: http://www.kroah.com/log/linux/android-kernel-problems.html and various 
> other rants about the evil terrible android forks, etc.
> 
> So, we figure, let's sort out the hard problem first and then move on with 
> our lives.

Well, my suggestion would be to first build up a path towards upstream, build 
up trust, reduce your very high cross section to mainline - and do the most 
difficult bits last.

Especially 'move on with our lives' suggests that you just want to get rid of 
this ABI divergence and continue-as-usual with the pattern of non-cooperation, 
hm?

> > There is absolutely _zero_ technical reason why the Android team should 
> > present this as as an all-or-nothing effort. Why not merge hw drivers 
> > first (with suspend blockers commented or stubbed out), to reduce the fork 
> > distance?
> 
> If that's the case then there is no problem and people could stop yelling at 
> us and just submit their drivers.  Awesome.
> 
> I can't speak for all the nameless silicon vendors Greg represents, that we 
> apparently are preventing from doing this (how? I don't know!), etc, but for 
> my team maintaining multiple versions of drivers is a headache, we'd rather 
> square away the wakelock debate first and figure something out there, as it 
> just seems like a more logical approach.  Maybe we're crazy.

It's not crazy, it's just IMHO inefficient and very difficult to do it like 
that. And you arent the first one to try it like that (people _always_ 
gravitate towards coming with their most difficult patches first - because 
they are very often the most useful patches) - it's a non-trivial learning 
curve IMHO.

	Ingo
