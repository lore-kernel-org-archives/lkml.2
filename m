Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933622Ab1C3Vig (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:38:36 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:46916 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964894Ab1C3VIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:08:16 -0400
Date: Wed, 30 Mar 2011 22:07:26 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Tony Lindgren <tony@atomide.com>, David Brown <davidb@codeaurora.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, Nicolas Pitre <nico@fluxnic.net>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
Message-ID: <20110330210726.GA4593@n2100.arm.linux.org.uk>
References: <20110317183048.GW7258@atomide.com> <AANLkTimWbb5DWiiCW821H6pRicbk1fS3PYcnGyUMznvM@mail.gmail.com> <20110318101512.GA15375@n2100.arm.linux.org.uk> <201103301906.42429.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201103301906.42429.arnd@arndb.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 30, 2011 at 07:06:41PM +0200, Arnd Bergmann wrote:
> On Friday 18 March 2011, Russell King - ARM Linux wrote:
> > I do get the impression that you're extremely unhappy with the way ARM
> > stuff works, and I've no real idea how to solve that.  I think much of
> > it is down to perception rather than anything tangible.
> > 
> > Maybe the only solution is for ARM to fork the kernel, which is something
> > I really don't want to do - but from what I'm seeing its the only solution
> > which could come close to making you happy.
> 
> I'm still new to the ARM world, but I think one real problem is the way
> that all platforms have their own trees with a very flat hierarchy --
> a lot of people directly ask Linus to pull their trees, and the main
> way to sort out conflicts is linux-next. The number of platforms in the
> ARM arch is still increasing, so I assume that this only gets worse.

The reason that we've ended up with a flat heirarchy in terms of
developers is down to pressure.  There was a time when we had a more
structured system, where the sub-tree people submitted their patches
to me and the list, they'd be reviewed (mostly and mostly only) by me
before being merged into my tree and going upstream from there.

As the community grew, it got harder and harder to do decent reviewed
of those patches and so the acceptance rate dropped.

Eventually we switched to the current arrangement where I'm essentially
only concerned about core ARM code, and a few platforms which I have
personal interest in (or are contracted to look after.)

For the rest I just look at the patches, and send back what feedback I
can on them (which is mostly when my mailer turns a line red because
it's matched one of my mutt regexps for spotting common mistakes.)

> This would be no easier if everyone was asking you to pull their trees,
> as I believe was the case before that. The amount of code getting changed
> there is too large to get reviewed by a single person, and I believe
> neither of you really wants the burden to judge if all of the branches
> are ok (and complain to the authors when they are not).

Absolutely right - and the problem is that we still have no one who is
willing to step up and do the review.

What I was promised at the time was that by giving sub-tree maintainers
the loaded pistol, this problem of code quality would in effect be self-
correcting.  If they make a hash out of it, they'd have to be the ones
to fix it themselves.

Instead, what's happening is that the _entire_ ARM community, ARM
hardware manufacturers and so forth is being blamed here.

> Russell, do you think it would help to have an additional ARM platform
> tree that collects all the changes that impact only the platform code but
> not the core architecture? I believe that would be a way out, but requires
> a careful selection of people responsible for it. In particular, I don't
> think a single person can handle it without good sub-maintainers.

It's not that simple, as what happens when we have core ARM code updates
which ends up touching every single board file?  The result is conflicts
between trees, and that could get extremely messy indeed.

To be honest, given the politics, I don't want to be the one stuck in the
middle, receiving and endless stream of Linus' complaints about the way
the ARM community works, or the board support code.  However, inspite of
the sub-tree maintainers having the responsibility for their own code I
still find myself in the firing line.

And I have got to the point of just not giving a damn.  I can't change
the ARM community (I've tried over the years to get more active review
of platform changes and failed - and had it pointed out by folk like
Alan Cox, that such a system is impossible due to lack of motivation
by, eg, an OMAP person to review a Samsung change.)

If this ultimately means that Linus decides to throw ARM out of the
mainline kernel, then I guess we'll need a git tree setup somewhere to
track mainline, and to take the ARM merges, and do our own kernel
releases with different version numbering.  I'm quite prepared to do
that and run such a tree, and not give a damn about what the sub-arch
people do provided I can still make the necessary core ARM code changes
as required (and if some sub-arch breaks they get to fix it.)  However,
that would be entirely limited to just ARM arch stuff and not drivers.
