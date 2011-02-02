Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283Ab1BBVr3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 16:47:29 -0500
Received: from relais.videotron.ca ([24.201.245.36]:48680 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753735Ab1BBVr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 16:47:27 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Wed, 02 Feb 2011 16:47:12 -0500 (EST)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Greg KH <greg@kroah.com>
Cc: Russell King <rmk@arm.linux.org.uk>, David Brown <davidb@codeaurora.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        Stepan Moskovchenko <stepanm@codeaurora.org>
Subject: Re: linux-next: manual merge of the msm tree with the arm tree
In-reply-to: <20110202204453.GB26104@flint.arm.linux.org.uk>
Message-id: <alpine.LFD.2.00.1102021557530.8212@xanadu.home>
References: <20110131131401.5d6c7646.sfr@canb.auug.org.au>
 <8ya4o8m70jp.fsf@huya.qualcomm.com> <20110202194359.GC27065@kroah.com>
 <20110202200030.GA26104@flint.arm.linux.org.uk>
 <20110202203252.GD28479@kroah.com>
 <20110202204453.GB26104@flint.arm.linux.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Feb 2011, Russell King wrote:

> On Wed, Feb 02, 2011 at 12:32:52PM -0800, Greg KH wrote:
> > On Wed, Feb 02, 2011 at 08:00:31PM +0000, Russell King wrote:
> > > On Wed, Feb 02, 2011 at 11:43:59AM -0800, Greg KH wrote:
> > > > On Wed, Feb 02, 2011 at 10:29:14AM -0800, David Brown wrote:
> > > > > On Sun, Jan 30 2011, Stephen Rothwell wrote:
> > > > > 
> > > > > > Hi David,
> > > > > >
> > > > > > Today's linux-next merge of the msm tree got conflicts in
> > > > > > arch/arm/mach-msm/board-msm7x27.c, arch/arm/mach-msm/board-msm7x30.c,
> > > > > > arch/arm/mach-msm/board-qsd8x50.c and arch/arm/mach-msm/board-sapphire.c
> > > > > > between commit eda53d6d032effb653410b79e1b49e652a881744 ("ARM: P2V: avoid
> > > > > > initializers and assembly using PHYS_OFFSET") from the arm tree and
> > > > > > commit 07a3cc4814f790354d4c7be2c9dc6143a714a07a ("msm: Clean up useless
> > > > > > ifdefs") from the msm tree.
> > > > > >
> > > > > > I fixed it up (see below) and can carry the fix as necessary.
> > > > > 
> > > > > What is the best way to resolve this?  I can't really merge against
> > > > > Russell's tree, since he may need to rebase his tree before the merge
> > > > > window?
> > > > 
> > > > Public trees should never be rebased, so that shouldn't happen.
> > > 
> > > No.  I refuse to operate in a rigid environment.
> > > 
> > > My tree is made available on the basis that the 'devel' branch is
> > > constantly remerged (sometimes many times a day) from the individual
> > > topic branches; 'devel' is a convenient branch for sfr to pull into
> > > linux-next, and for others to see what's in the tree.
> > 
> > merging is fine, right?
> > 
> > Not rebasing, you really don't want to do that.  Linus has been all over
> > that topic in the past, I doubt he wants to bring it up again in detail.

Linus has said that you are not supposed to rebase other people's tree.  
The obvious reason is that once you rebase someone else's work, you void 
all the testing that person might have done since the environment is not 
the same as the one in which it was tested initially.  This came about 
because davem (just to name a prominent figure) did use to rebase other 
people's tree he pulled into his tree in order to make a nice linearized 
history for some reasons.

Linus also said that, if you do publish a tree for others to base their 
work on, you must not rebase your tree for obvious reasons.

But never did Linus say that rebasing was outright forbidden.  There are 
cases where it is appropriate (e.g. linux-next) and other cases where it 
is not.  For people without enough git fu to make the difference then it 
is best not to rebase.  but in some workflows it is just the right 
thing to do.

> > > I am not permitted by people in the community to keep my development
> > > work unpublished.
> > > 
> > > All the requirements from various different people are incompatible,
> > > so I've chosen a way which satisfies the majority on the ARM community,
> > > which is the community my tree serves.  It does not serve mainline
> > > community interests.
> > 
> > So the goal of the ARM community isn't for the mainline community?  That
> > sounds like a big problem.

Please stop spreading B/S.

> > > So I do not operate a "commit the patch and its fixed" policy except
> > > for branches which people need to be fixed; they need to discuss their
> > > requirements with me to achieve that.
> > 
> > I'm not telling you how to run your branches, other than the simple fact
> > of: "if it's public, it shouldn't be rebased".  See Linus's comments for
> > why this is.

Then for all purposes please just consider RMK's tree as non existent.  
That should solve your problem.

Those who've worked well with RMK and his semi-rebasing workflow for the 
last 5 years should continue to do so as they see fit.

If you do need a stable branch for some features you need to base your 
work on, then just ask RMK for one.  He always managed it in the past.

The actual problem here is that some people, notably the msm folks, are 
bypassing the maintainer hierarchy and going straight to Linus for their 
pull requests instead of asking RMK to pull.  We once debated this at 
some point and it was agreed that completely independent SOC specific 
code with no dependencies on the common ARM code _could_ go straight to 
Linus directly if they crave for it.  But in this case:

1) the conflict is obviously simple

2) the conflict resolution is just as obvious

3) and Stephen is able and willing to carry this conflict resolution for 
   the foreseeable future until this all gets merged in mainline.

So... WTF is the actual problem here?


Nicolas
