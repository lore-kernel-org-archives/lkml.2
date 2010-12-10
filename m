Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756421Ab0LJRuA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 12:50:00 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:58533 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753566Ab0LJRt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 12:49:58 -0500
Date: Sat, 11 Dec 2010 02:48:43 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Peter Huewe <peterhuewe@gmx.de>,
        Ian Lartey <ian@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mfd/wm831x-irq: Convert to new irq_chip functions and fix build failure
Message-ID: <20101210174843.GB3750@linux-sh.org>
References: <1291937687-20243-1-git-send-email-peterhuewe@gmx.de> <12ABA93B-6923-4AF7-BF34-E070BE72A8E2@opensource.wolfsonmicro.com> <alpine.LFD.2.00.1012100233510.2653@localhost6.localdomain6> <20101210050755.GA21712@linux-sh.org> <20101210121420.GC3200@rakim.wolfsonmicro.main> <20101210154332.GB21712@linux-sh.org> <20101210172407.GF3200@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101210172407.GF3200@rakim.wolfsonmicro.main>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 10, 2010 at 05:24:08PM +0000, Mark Brown wrote:
> On Sat, Dec 11, 2010 at 12:43:32AM +0900, Paul Mundt wrote:
> > The "savings" are largely triggering these sorts of issues, where anyone
> > using deprecated functionality blows up the build and gets fixed up
> > incrementally, as well as stopping people from adding new users of the
> > deprecated API.
> 
> OK, so disabling this for 2.6.37 and reenabling in -next wouldn't cause
> any substantial disrupton to SH?  As I say I would also argue in favour
> of enabling on x86 if we're pushing the changeover aggressively (Thomas
> did indicate that he wants to do this, I'd send a patch but I'm unlikely
> to have the time to do sufficient build testts on that platform).
> 
The conversion for x86 ought to be pretty straightforward, it's nowhere
near the minefield that most of the embedded architectures are with
regards to IRQ chip implementations. It's probably a bit late to run
around auditing all the drivers for .37 though, this is probably
something we should have done during -rc2 or so. It's certainly
reasonable for the .38 window, though.

> No, not at all.  As I mentioned in my previous posting this particular
> driver has already been converted to use the new API (I posted the
> patches about a month ago), as have all the other drivers I'm
> responsible for.  What I'm saying is that doing the conversion for this
> and all the other affected drivers at this point in the 2.6.37 release
> cycle seems rather invasive.
> 
Yes, agreed.

> The API was introduced and the old one flagged as deprecated during the
> 2.6.37 merge window so SH has been rather...  prompt in implementing and
> enforcing the conversion.  2.6.37-rc1 was the first kernel that had the
> new operations for drivers to use so implementations of this would have
> had to go into Linus-destined trees after the merge window or done cross
> tree merges with the genirq tree prior to then.  The normal expectation
> with such an API change would be that conversions would be done once the
> change had propagated through Linus' tree into the relevant development
> tree for the driver and only appear in mainline in the following merge
> window.
> 
Basically what happened is this came about as a result of the sparseirq
refactoring that was going on in the genirq tree. I was hacking on and
converting over in preparation for the merge window, so this was all done
well in advance of -rc1. In hindsight, yes, we probably could have done a
driver audit for the irq_chip users at the same time the rest of the
refactoring was going on, but I'm also willing to accept some early
adopter pain.

I have no intention of dropping the select from SH, but I'm not going to
insist that these drivers have the deprecated dependency if we're a) not
really using them and b) there's a reasonable expectation that they'll
basically be taken care of in .38 anyways.

I haven't been following the progress in -next, but now that you've
pointed it out I'll give it a look. It's less effort to just fix up the
remaining users than it is to audit API dependencies for all of them at
least.
