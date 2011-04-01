Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520Ab1DAUTe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 16:19:34 -0400
Received: from relais.videotron.ca ([24.201.245.36]:41198 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755121Ab1DAUTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 16:19:32 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Fri, 01 Apr 2011 16:19:31 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Arnd Bergmann <arnd@arndb.de>
Cc: Will Deacon <will.deacon@arm.com>, Ingo Molnar <mingo@elte.hu>,
        david@lang.hm, Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        lkml <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        David Brown <davidb@codeaurora.org>, linux-omap@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
In-reply-to: <201104011755.57412.arnd@arndb.de>
Message-id: <alpine.LFD.2.00.1104011557080.28032@xanadu.home>
References: <alpine.LFD.2.00.1103310145390.28032@xanadu.home>
 <201104011554.07924.arnd@arndb.de>
 <1301671655.28467.52.camel@e102144-lin.cambridge.arm.com>
 <201104011755.57412.arnd@arndb.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Apr 2011, Arnd Bergmann wrote:

> On Friday 01 April 2011, Will Deacon wrote:
> 
> > > 1. The core arch code is not a problem (Russell does a great job here)
> > > 2. The platform specific code contains a lot of crap that doesn't belong there
> > >    (not enough reviewers to push back on crap)
> > > 3. The amount of crap in platform specfic files is growing exponentially,
> > >    despite the best efforts of a handful of people to clean it up.
> > > 4. Having one source file per board does not scale any more.
> > > 5. Discoverable hardware would solve this, but is not going to happen
> > >    in practice.
> > > 6. Board firmware would not solve this and is usually not present.
> > > 7. Boot loaders can not be trusted to pass valid information
> > > 8. Device tree blobs can solve a lot of the problems, and nobody has
> > >    come up with a better solution.
> > 
> > Right, so this is directly related to point (5) because in essence FDT
> > is a way to make undiscoverable hardware discoverable by probing the
> > tree. The `it's just data' mantra sums it up nicely.
> 
> Well, except that because of point 7, device trees are still inferior to
> having correct and complete information in hardware.

I helped with the design of a rather simple patch for ARM allowing for:

	cat zImage foobar.dtb > zImage_with_dtb

Then the kernel is smart enough to detect it has a dtb on its tail and 
use it.

In a perfect world the bootloader would be bug free and always up to 
date with the best DT data.  In practice I'm very skeptical this will 
always be the case and painless.  At least the above makes it very 
simple to have a self contained kernel when (not if) need be.

> > > 9. All interesting work is going into a handful of platforms, all of which
> > >    are ARMv7 based.
> > 
> > I think starting out ARMv7-only might make this more manageable but
> > there are still shed loads of pre-v7 chips out there which we should try
> > not to break.
> 
> Yes, see below: the idea is to touch as little of the existing code
> as possible, at least in the first stages.

I don't think this is a realistic approach.  See my previous mail. Once 
you start identifying concrete and well defined areas that needs 
cleaning, it is best to come up with solutions that covers as much 
existing code as possible, validating that the solution is also worth it 
in the process.  The more existing code you may cover with your cleanup, 
the more likely it will fit future hardware as well.


Nicolas
