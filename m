Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759268Ab1DNQGq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 12:06:46 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:60982 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758736Ab1DNQGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 12:06:44 -0400
Date: Thu, 14 Apr 2011 12:06:40 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
X-X-Sender: nico@xanadu.home
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>, linux-sh@vger.kernel.org,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Paul Mundt <lethal@linux-sh.org>, lkml <linux-kernel@vger.kernel.org>,
        Dima Zavin <dmitriyz@google.com>,
        Saravana Kannan <skannan@codeaurora.org>,
        Ben Dooks <ben-linux@fluff.org>,
        =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/2] Common struct clk implementation, v14
In-Reply-To: <20110414153813.GC6259@n2100.arm.linux.org.uk>
Message-ID: <alpine.LFD.2.00.1104141154390.24613@xanadu.home>
References: <1299134429.100626.661279191478.0.gpush@pororo> <1302754859.2767.30.camel@pororo> <20110414100048.GB1611@n2100.arm.linux.org.uk> <1302776705.28876.113.camel@pasglop> <20110414103200.GF1611@n2100.arm.linux.org.uk> <alpine.LFD.2.00.1104140751220.24613@xanadu.home>
 <20110414120904.GH1611@n2100.arm.linux.org.uk> <alpine.LFD.2.00.1104140920110.24613@xanadu.home> <20110414153813.GC6259@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Apr 2011, Russell King - ARM Linux wrote:

> On Thu, Apr 14, 2011 at 09:39:58AM -0400, Nicolas Pitre wrote:
> > However we can and must do better in consolidation work in order to make 
> > the tree more maintainable of course.  _That_ is the real issue and 
> > _that_ is what the ARM tree sucks at.  The fact that this consolidation 
> > work might reduce the size of the ARM code is only a side effect, not 
> > the primary goal.  So let's not get too hung up about LOC but focus on 
> > improving the infrastructure instead.
> 
> Look, this is what is in amongst the 6K lines of new code - these are
> the top two in the diffstat with the highest number of additional lines:
> 
>  arch/arm/mach-ux500/clock-db8500.c                 | 1291 +++++++++++++
>  arch/arm/mach-ux500/prcmu-db8500.c                 | 2018 ++++++++++++++++++++
> 
> These comprise 50% of the 6K of new code.  clock-db8500.c is a mixture
> of code and data declarations for individual clocks - which is essentially
> what Linus picked up with his complaint on under OMAP.  That in itself
> makes me worried.

Sure.  So... let's see what we can do about it.  Having 1300 lines only 
for clock stuff on only one platform certainly looks silly.  Either we 
can consolidate some of that stuff with another similar-enough platform, 
or we're stuck with the ST-E hardware being just too different from, 
say, the OMAP clock hardware for those to be consolidated.  In the 
former case we can work towards a solution and that code currently in 
next won't make it to mainline, or in the later case... well... we'll 
have to live with it.  If in doubt let's simply ask the opinion of those 
mainline people who said they're willing to help with advices.  If in 
the end they have no better solutions than what we have now then it will 
be harder for them to complain.

> Looking at the other file, prcmu-db8500.c seems to contain at least 5 sets
> of mailbox support code.  Take a look at "Subject: [PATCH 9/9] mach-ux500:
> add DB5500 PRCMU interface" from Linus Walleij on 31st March on this list
> for the patch.  Are we sure that this couldn't be consolidated in some
> way, at least at file level?
> 
> So while you can say about not getting hung up about LOC, LOC is a good
> indication that things are still going wrong in much the same way.

Agreed.  My point is, we shouldn't be afraid to add more code if that 
code is allowing for some consolidation to happen down the road, which 
should be the case with the initial subject of this thread.


Nicolas
