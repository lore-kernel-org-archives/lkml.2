Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759177Ab1CaTLS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 15:11:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43085 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759130Ab1CaTLQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 15:11:16 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1103311218240.28032@xanadu.home>
References: <201103301906.42429.arnd@arndb.de> <AANLkTim578-kwM14SJd06RW_QiC4WVCmFuG+ASgGC4sq@mail.gmail.com>
 <alpine.LFD.2.00.1103301531420.28032@xanadu.home> <AANLkTim6zg-U6HtAQbqnENqoK7x8erXSqOuTFVC0YE5r@mail.gmail.com>
 <alpine.LFD.2.00.1103301814250.28032@xanadu.home> <alpine.DEB.2.00.1103301728000.15330@asgard.lang.hm>
 <alpine.LFD.2.00.1103302255280.28032@xanadu.home> <alpine.DEB.2.00.1103302130500.29543@asgard.lang.hm>
 <alpine.LFD.2.00.1103310145390.28032@xanadu.home> <20110331080634.GA18022@elte.hu>
 <20110331083044.GB14323@n2100.arm.linux.org.uk> <alpine.DEB.2.00.1103310855450.29543@asgard.lang.hm>
 <alpine.LFD.2.00.1103311218240.28032@xanadu.home>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 31 Mar 2011 12:02:19 -0700
Message-ID: <AANLkTikumKg8nOi5O=zym3eS4UOKO0+vA21bGHaagL=9@mail.gmail.com>
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
To: Nicolas Pitre <nico@fluxnic.net>
Cc: david@lang.hm, Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Ingo Molnar <mingo@elte.hu>, Arnd Bergmann <arnd@arndb.de>,
        Tony Lindgren <tony@atomide.com>, David Brown <davidb@codeaurora.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 31, 2011 at 10:56 AM, Nicolas Pitre <nico@fluxnic.net> wrote:
>
> So... Is there missed opportunity for better code reuse here?  Most
> probably.  Is all that code the result of misabstracted and duplicated
> code?  Certainly not.  Let's just presume that half of that code is
> genuine crap and the other half is simply the result of new hardware for
> which there is no existing model to fit it in.  Even then, do we have 5
> times the reviewer bandwidth to properly review all that code compared
> to X86?  Absolutely not, not even close.

That's an odd assumption. And it's followed by a total red herring
that doesn't even make any sense. And then your conclusion seems to be
that ARM could never have the same quality anyway, because of the
whole lack of review issue is fundamental.

And from there you seem to go on to think that there are no major
problems, and things are "good enough"!

> If prominent people looking at this from the side line continue bashing
> at those who are both feet in the mud trying to contain the flood rather
> than actually helping then nothing will change.

The reason nothing seems to be changing is that you don't seem to
think it's even WORTH fixing. I really don't understand your
arguments.

They seem to boil down to the same thing that always happens in the
embedded world, and why most of the hardware and software is crap:
people don't think further than their own small project.

It's why embedded OS's have always been crap, and it's why Linux is
becomign so important to ARM - exactly because the embedded world
(both software and hardware) always just look at their own issue, and
say "hey, this is working for me right now, so I won't bother to try
to solve the bigger issues, because it's not worth my time".

To hammer that in:


> ...  And the fact is that _users_ of the
> ARM kernel are not complaining.  Things are far from being perfect, but
> so far things have been "good enough" for the majority of the people
> involved, and improvements are constantly being worked on with the men
> power available.

You really don't seem to care about how Thomas was complaining about
the whole maintenance issue. As he was trying to clean up irq
handling, the pure flow of more crap just made it hard to ever catch
up. THAT is the kind of maintenance problem where I go "This is a big
problem".

But for some individual board user or the code-monkey who creates yet
another board description, this isn't a problem. Because he's looking
at a single kernel and a single board at a time, and seldom cares
about anything else.

But guess what? That really _is_ a problem. And it's likely to be a
bigger problem in the future. Look at how we're actually starting to
see vendors who are making ARM into more of a real platform, rather
than a succession of one-off embedded boards, and think about what
that actually will entail.

I'm talking about things like ASUS getting their feet wet making
netbooks with ARM. Things like that have been promised for the last
several years now, and so far it's been a total failure.

And it's going to CONTINUE to be a failure, unless the ARM platform
mess can be sorted out.

Why? Think of the Ubuntu's etc of the world. If you can't make
half-way generic install images, you can't have a reasonably generic
distribution. And if you don't have that, then what happens to your
developer situation? Most sane people won't touch it with a ten-foot
pole, because the bother is simply not worth their time.

So the current embedded mindset of "hey, it's working for all these
individual people" is just broken. It's broken for multiple reasons.
It's broken because it makes it much harder to do top-level
maintenance (but the low-level guys don't care), and it's broken
because it results in insane fragmentation where it basically is never
an option to support anything but one - or a couple - particular
device.

The ARM -core- situation is simple, and those high-level people can
(and do) say that they'll just support ARM7 and screw all the other
cores.

But the platform problem is real. And it does need some solution,
because continuing to just do the same thing really does mean that
some new things simply cannot be done.

And the fact that it's been "good enough" in the past when every
single board was always just a one-off and had nothing to do with
other boards does _not_ mean that it's going to continue to be good
enough.

So the _good_ news is that all the high-end ARM's are largely
consolidating anyway, and when we're talking Cortex-A9 class hardware,
there generally aren't millions of SoC's. And I'm hoping the hardware
people are actually aware of this (presumably because their customers
are starting to push back against pointless hw churn too) and clearly
some manufacturers are trying to -create- platforms like OMAP that try
to have lots of shared characteristics (and then screw up a lot of the
details, but whatever).

But I still do think that on the software side, people need to stop
doing the whole "let's just copy that platform code for this other
platform that is quite similar but has a different XYZ chip".

                                   Linus
