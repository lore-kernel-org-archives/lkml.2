Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758575Ab2I2Roa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2012 13:44:30 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43768 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756847Ab2I2Ro3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2012 13:44:29 -0400
Date: Sat, 29 Sep 2012 18:44:01 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Linus Torvalds <torvalds@linux-foundation.org>, arm@kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: ARM SoC tree, Was: Re: [PATCH 05/12] ARM: ixp4xx: use __iomem
	for MMIO
Message-ID: <20120929174400.GA6933@n2100.arm.linux.org.uk>
References: <1348868177-21205-1-git-send-email-arnd@arndb.de> <1348868177-21205-6-git-send-email-arnd@arndb.de> <m3lift6rru.fsf_-_@intrepid.localdomain> <201209291458.16112.arnd@arndb.de> <m3y5jskbir.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m3y5jskbir.fsf@intrepid.localdomain>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 29, 2012 at 07:02:36PM +0200, Krzysztof Halasa wrote:
> Arnd Bergmann <arnd@arndb.de> writes:
> > explaining that we're closing the window for 3.7 except for a
> > few things that were already submitted earlier.
> 
> No offense, but... You say how does it work for YOU but that's not
> exactly what I'm asking for. I'm asking for a statement that it's
> not OK for me to push my IXP4xx changes straight to Linus.

If you bypass arm-soc, then you may find you have more problems - if
the arm-soc goes in before you, and your tree conflicts with arm-soc.
There are major changes going through at the present time which could
very well mean that you miss something and IXP4xx gets broken because
you're not participating.

If you wish to find out about those breakages after the event, and
play constant catch up, then pushing straight to Linus is what you
should do.

If you wish to know about the breakages, and fix them up ahead of time,
then participate in the established process.

> > The arm-soc process is definitely meant to make your life easier
> > as well as help Linus understand what's going on with all of ARM
> > to the degree that he needs to know, but it only works if everyone
> > participates.
> 
> I'd like to know how is it easier for me. Actually, I think it would
> only make things worse for everyone (mostly for me). Also, I can't see
> how "it only works if everyone participates" is true.
> 
> I'm currently supporting (for our internal needs) hw platforms based
> on x86, MIPS and now ARM. I'm using 3.1 (non-trivial upgrades required
> so -ETIME) and 3.5 "stable" trees, and need to also use Linus' current
> tree since it's the next stable.

That makes no sense what so ever.  The tree which is used for the next
stable tree will be Linus' tree, which will be the result of merging all
those other trees into Linus' tree.  If you base your changes off only
Linus' tree on the run up to the next merge window, then you are preparing
your changes against an _older_ kernel than if you base them off a tree
containing the changes which will be _included_ in the next merge window.

So, in the long run, you'll end up doing the same amount of work, but
you'll end up having to do the "fix it for the merge window" hoops _after_
your tree has been merged into mainline, rather than before.

> Also, not that it's the most important, but how is it better for anyone
> to delay changes - which are completely orthogonal to arm-soc - for
> additional months? Doesn't "release early, release often" make sense
> anymore?

Err, no idea what you're getting at here, but take a moment to think about
it.

If you want to work in total isolation, that's your choice, but in the
long run you will be playing catch-up rather than being prepared early
for the changes which will happen at the next merge window.  If you want
-rc1, rc2, rc3, rc4 etc to be broken on IXP4xx until you get around to
fixing up the merge window breakage, then go ahead.

Otherwise, participate and be part of the community, and get your changes
into arm-soc, so that others can see what's going on.

