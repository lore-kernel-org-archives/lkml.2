Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759260Ab1CaVkx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 17:40:53 -0400
Received: from www.linutronix.de ([62.245.132.108]:51988 "EHLO linutronix.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759193Ab1CaVkt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 17:40:49 -0400
Date: Thu, 31 Mar 2011 23:40:11 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Nicolas Pitre <nico@fluxnic.net>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>, david@lang.hm,
        Ingo Molnar <mingo@elte.hu>, Arnd Bergmann <arnd@arndb.de>,
        Tony Lindgren <tony@atomide.com>, David Brown <davidb@codeaurora.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
In-Reply-To: <alpine.LFD.2.00.1103311429590.28032@xanadu.home>
Message-ID: <alpine.LFD.2.00.1103312229240.31043@localhost6.localdomain6>
References: <alpine.LFD.2.00.1103301531420.28032@xanadu.home> <AANLkTim6zg-U6HtAQbqnENqoK7x8erXSqOuTFVC0YE5r@mail.gmail.com> <alpine.LFD.2.00.1103301814250.28032@xanadu.home> <alpine.DEB.2.00.1103301728000.15330@asgard.lang.hm> <alpine.LFD.2.00.1103302255280.28032@xanadu.home>
 <alpine.DEB.2.00.1103302130500.29543@asgard.lang.hm> <alpine.LFD.2.00.1103310145390.28032@xanadu.home> <20110331080634.GA18022@elte.hu> <20110331083044.GB14323@n2100.arm.linux.org.uk> <alpine.DEB.2.00.1103310855450.29543@asgard.lang.hm>
 <20110331164539.GB19452@n2100.arm.linux.org.uk> <AANLkTi=tyifvJU-hhdd7gT74GMctrCbQBdUAoEaRXOCy@mail.gmail.com> <alpine.LFD.2.00.1103311429590.28032@xanadu.home>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Mar 2011, Nicolas Pitre wrote:
> On Thu, 31 Mar 2011, Linus Torvalds wrote:
> > What I'm _not_ seeing is a lot of cross-platform maintenance or sense
> > of people trying to reign things in and look for solutions to the
> > proliferation of random stupid and mindless platform code.
> 
> I do that, Russell does that, Catalin does that, Tony does that, and 
> maybe less than a handful of other important people I'm not listing 
> (sorry).  But clearly we are far far from being enough people doing that 
> kind of work.  And the fact is that the volume of ARM platform code is 
> steadily being produced at a rate far surpassing X86, and even higher 
> than all the other architectures put together.  Linaro is trying to help 
> here, but Linaro cannot conjure the needed experience and knowledge for 
> that kind of work with a magic wand.
> 
> So we need help!  If core kernel people could get off their X86 stool 
> and get down in the ARM mud to help sort out this mess that would be 
> really nice (thanks tglx).  Until then all that the few of us can do is 

The main help we can give (aside of actually looking at code and
concepts) is to feed back the experience we have with massive cleanups
and which mechanisms work and which not and - at least I can speak for
myself - to stand at your side when it comes to pushing that through.

One thing what really helps to force people to get their act together
is that you as maintainers identify trouble spots which are easily
addressable. Then put those spots on your list and require people who
want to submit new features in that area to cleanup the mess first and
then put their new feature thing on top. We successfully used this to
get the unification work after the mechanical i386/x86_64 merger
done. It requires a lot of stubborness, but it reduces the work burden
of the maintainers a lot.

Once you have the easy spots addressed, that could be device tree
stuff, gpio, irq_chips for the beginning and see how it works out,
then go steps further.

The important point here is from my POV that you put down the
requirements with no wiggle room and just ignore the "oh it could be
done better" whining. Either people come up with a patch which solves
the whole issue better or they just will cope. But when you have
consolidated stuff then you can and need to look from a high level
perspective and refine the infrastructure.

I really regret in hindsight, that I did not enforce the cleanup of
the irq layer way earlier and that I did not see the abuse of it early
enough. At some point I realized that being polite is the wrong
solution, so I forced myself to push this cleanup through. That's an
experience which I don't wish anybody else to make. Especially because
as long as the oldstyle stuff works oldstyle crap comes in faster than
you can fix it. See commit 9ad198c. And it's a massive effort to do
something which results in:

Total patches:                 414
Total files touched:	       702	
Total insertions:             6805
Total deletions:              8632
Lines added                  -1827

And that massive effort is just because you cannot break stuff after
the fact in a massive scale. The whole thing introduced a mere 6
patches fixup fallout which were applied one day after rc1. It could
have been avoided, but ....

So yes, we can and will help with advise, a certain amount of review
(especially on the concept level) and giving you all the support you
need to fight that trough.

Thanks,

	tglx
