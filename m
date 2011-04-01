Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756977Ab1DAOSf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 10:18:35 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:51682 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756398Ab1DAOSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 10:18:33 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
Date: Fri, 1 Apr 2011 16:17:43 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Tony Lindgren <tony@atomide.com>, David Brown <davidb@codeaurora.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, Nicolas Pitre <nico@fluxnic.net>,
        Catalin Marinas <catalin.marinas@arm.com>
References: <20110317183048.GW7258@atomide.com> <201103301906.42429.arnd@arndb.de> <20110330210726.GA4593@n2100.arm.linux.org.uk>
In-Reply-To: <20110330210726.GA4593@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104011617.43199.arnd@arndb.de>
X-Provags-ID: V02:K0:cRgpirl/s6oGdPSexZjJYEfOcxhRMpbS6mKAHhPpQUl
 55lRN037X3++z67ICh4ZV8H50w5kXOvTl5V3hhKPn7/tqg2Wun
 CoYC+I+LFuBnD0i4pvgNKrF/iFU3I4pGp6F834oqU4fpZaHoYA
 vBgK8LI7VCAEkVcsoLGdCM77T2lsFMHiVuZTnesySTyQ6o/I0W
 yXfxQHIqGVdxdpRqAz+3Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 March 2011, Russell King - ARM Linux wrote:
> On Wed, Mar 30, 2011 at 07:06:41PM +0200, Arnd Bergmann wrote:
> > 
> > I'm still new to the ARM world, but I think one real problem is the way
> > that all platforms have their own trees with a very flat hierarchy --
> > a lot of people directly ask Linus to pull their trees, and the main
> > way to sort out conflicts is linux-next. The number of platforms in the
> > ARM arch is still increasing, so I assume that this only gets worse.
> 
> The reason that we've ended up with a flat heirarchy in terms of
> developers is down to pressure.  There was a time when we had a more
> structured system, where the sub-tree people submitted their patches
> to me and the list, they'd be reviewed (mostly and mostly only) by me
> before being merged into my tree and going upstream from there.
> 
> As the community grew, it got harder and harder to do decent reviewed
> of those patches and so the acceptance rate dropped.
> 
> Eventually we switched to the current arrangement where I'm essentially
> only concerned about core ARM code, and a few platforms which I have
> personal interest in (or are contracted to look after.)
> 
> For the rest I just look at the patches, and send back what feedback I
> can on them (which is mostly when my mailer turns a line red because
> it's matched one of my mutt regexps for spotting common mistakes.)

Thanks for the background information.

> > This would be no easier if everyone was asking you to pull their trees,
> > as I believe was the case before that. The amount of code getting changed
> > there is too large to get reviewed by a single person, and I believe
> > neither of you really wants the burden to judge if all of the branches
> > are ok (and complain to the authors when they are not).
> 
> Absolutely right - and the problem is that we still have no one who is
> willing to step up and do the review.
> 
> What I was promised at the time was that by giving sub-tree maintainers
> the loaded pistol, this problem of code quality would in effect be self-
> correcting.  If they make a hash out of it, they'd have to be the ones
> to fix it themselves.
> 
> Instead, what's happening is that the _entire_ ARM community, ARM
> hardware manufacturers and so forth is being blamed here.

This is not my impression. A lot of people are pointing out that there
are problems, and how they perceive them, but I don't think that anyone
really wants to blame the entire community.  Even less I believe that
people that understand the situation are blaming you personally.

> > Russell, do you think it would help to have an additional ARM platform
> > tree that collects all the changes that impact only the platform code but
> > not the core architecture? I believe that would be a way out, but requires
> > a careful selection of people responsible for it. In particular, I don't
> > think a single person can handle it without good sub-maintainers.
> 
> It's not that simple, as what happens when we have core ARM code updates
> which ends up touching every single board file?  The result is conflicts
> between trees, and that could get extremely messy indeed.

I believe that conflicts between two trees are really not the issue,
we have tools to solve those in multiple ways, e.g. by pulling in such
updates from a topic branch into both trees, or by declaring one of
the two trees the master that can pull in the other one occasionally
in order to resolve the conflicts.

> To be honest, given the politics, I don't want to be the one stuck in the
> middle, receiving and endless stream of Linus' complaints about the way
> the ARM community works, or the board support code.  However, inspite of
> the sub-tree maintainers having the responsibility for their own code I
> still find myself in the firing line.

I think that is partly a perception problem on your side. Understandably,
you still identify yourself with all of the code under arch/arm, so
if someone says that the ARM architecture code has problems, you take
it personally, even though the problems that are cited are almost
exclusively for code that you are not responsible for.

> And I have got to the point of just not giving a damn.  I can't change
> the ARM community (I've tried over the years to get more active review
> of platform changes and failed - and had it pointed out by folk like
> Alan Cox, that such a system is impossible due to lack of motivation
> by, eg, an OMAP person to review a Samsung change.)

I think we're actually just getting there. You were not the only one
to point out the problem and Linaro was specifically founded to solve
this issue, as far as I can tell. 

	Arnd
