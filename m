Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483Ab0IDUTR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 16:19:17 -0400
Received: from 1wt.eu ([62.212.114.60]:43484 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753336Ab0IDUTQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 16:19:16 -0400
Date: Sat, 4 Sep 2010 22:19:12 +0200
From: Willy Tarreau <w@1wt.eu>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: stable? quality assurance?
Message-ID: <20100904201912.GN25062@1wt.eu>
References: <201009041842.19968.Martin@lichtvoll.de> <20100904172201.GM25062@1wt.eu> <201009042133.28709.Martin@lichtvoll.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201009042133.28709.Martin@lichtvoll.de>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 04, 2010 at 09:33:27PM +0200, Martin Steigerwald wrote:
> > Thus at one point you can't hope to get bug reports anymore.
> > When you see an -rc7 or -rc8, you think "hey, -rc4 was OK, let's
> > wait for -final and install it".
> 
> That fits perfectly well. If the first rcs are nicely testing, then ideally 
> all major issues should be done, when rc7 or rc8 are reached. And thus 
> time can be spent on fixing the major remaining open regression.

OK I see that you're talking about *open* regressions. I thought you were
talking about bugs in general. I think (but that's my own feeling) that as
soon as the cause of a regression is narrowed down enough to identify the
commit that caused it, it gets quickly fixed (though I have no numbers on
the subject). But when someone says "I was doing this or that when my
kernel froze", it can be anything. Drivers are different because they
impact less people than the core. However the developers don't always
have access to the hardware combination causing a reproducible error case.

> I guess 
> those who reported these regression are interested in testing a fix.

I really think that there's good interactivity when the bug is spotted.
The hard part is the one before.

> >   - people concerned by stability don't test every release. They test
> > when they can, precisely because they can't impact production. So they
> > don't contribute bug reports in time. And as the 2.4 maintainer, I'm
> > well aware of that, because when I break something, I only know about
> > it 3-4 months later.
> 
> How does this affect my suggestion above? If as you say the first rcs are 
> tested better and if as I assume those who reported regressions have an 
> interest in testing their fixes, I think this can work out nicely.

But you can't have developer sit on their code for 4 months waiting for
bug reports to come in. And if you're talking about open bugs only, each
one of them will think the issue is probably in the other one's code.
Common problem of development teams.

> Aside from that, I am not sure whether most people step in with rc1 or rc2 
> already. When I tested rc kernels - there have been some times - I usually 
> waited to rc3 or rc4 so I could be somewhat confident that really major 
> issues are fixed already.

I think that people waiting for a specific feature will immediately jump on
rc1 or rc2. People who are curious about what was stuffed in the new kernel
will likely wait for rc3/4, hoping to get something they can run a day long.

> > I think that trying to evaluate and publish quality per developer or
> > maintainer can have a better effect because everyone in the commit
> > chain is responsible. But even doing that is hard because some changes
> > touch everything and it's not obvious to say that Mr X or Y has done
> > some crap.
> 
> And who judges on what is crap? Build failures could be tracked 
> automatically. Partly maybe even performance regression as the automated 
> tests from Phoronix show. Well boot failures or freezes are even more 
> important. But then, you are probably not judging the quality of the work 
> of the developer but the difficulty of the area he works on.

I agree with you in general on this point, which makes the issue even harder
to solve. However, some bugs are definitely caused by crap (look for Al
Viro's occasional audit reports, missing locks and thinks like this should
not get merged). Every developer starts inexperienced, and may humbly ask
for help.

> Nix pointed out that programming ATI Radeon cards can be quite 
> challenging. And I do have lots of respect for the Radeon KMS related 
> work. So I think it would be unfair to point at one of the Radeon KMS 
> developers and say to him "you did crap" for example.

100% agreed. It's the same in my opinion for every piece of code that
relies on configs that are hard to obtain. For instance, if a driver
breaks on configs with more than 256 CPUs or 1 TB of RAM, we can't
necessarily blame the author for not being able to test his code in
such situations.

> I think crap does happen and am more concerned about how to handle it when 
> it does.

OK, but when an unusual config is required, sometimes the author cannot
help getting his code fixed.

> Okay, my contribution then: I report bugs. I reported 4-5 kernels bugs in 
> the last time. I reported some before, but only occassionally. 

That's really nice.

> I didn't 
> face that many bugs prior to 2.6.34 which contributed to my admittedly 
> very subjective impression that kernel quality has lowered.

Possible, but it's also possible that the new bugs affect an area that
you're using much more than the ones affected by bugs in older versions.
It's also possible that you became better at noticing bugs.

> > Last, developers must not betray their users' trust. When they're not
> > certain of their code, this must be advertised (this is often the case
> > but not always). That helps a lot end users select only reliable
> > features and experience more stability.
> 
> Well for me a balance must be met: A kernel has to work good enough for me 
> to use it regularily.

That's what everyone looks for, and obviously the threshold is not the same
for everyone, and the bugs don't affect everyone. You see, while 2.4 is in
feature freeze and thought to be very stable by its users (and I occasionally
encounter systems with 2 years of uptime under permanent stress), i would
not be surprized that some people consider it still not stable enough for
their usages. It's just a matter of personal taste.

> And currently 2.6.34 upto 2.6.36-rc2 on my ThinkPad 
> T42 simply do not fulfil that criterium. What annoys me most: Radeon KMS 
> already works perfectly stable on 2.6.33 for me. So the issue was not in 
> the initial version of Radeon KMS. It has been introduced afterwards. Thus 
> a supposedly more matured and stable version of it is working less stable 
> for me.

That's where you're on the wrong side. 2.6.34 is not supposed to be a more
matured and stable version than 2.6.33. It's supposed to be a more *advanced*
version. Some issues were fixed, some features were added, some improvements
were performed and many bugs were added in that whole process. There's a rule
to follow concerning kernel upgrades in my opinion : you should only upgrade
for at least one of these 4 reasons :
  - test new kernels
  - get new features
  - fix a known bug
  - remain on a supported version

It's very likely that you'll regularly switch between newer and older kernels
to switch between the first 2 and the last 2 reasons. But people who upgrade
just to be on the edge and who don't even contribute bug reports back are just
looking for trouble in my opinion.

Regards,
Willy

