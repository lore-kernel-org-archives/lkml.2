Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754457Ab1DRKzi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 06:55:38 -0400
Received: from linux-sh.org ([111.68.239.195]:41017 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753700Ab1DRKzb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 06:55:31 -0400
Date: Mon, 18 Apr 2011 19:54:42 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>, linux-sh@vger.kernel.org,
        Sascha Hauer <s.hauer@pengutronix.de>,
        lkml <linux-kernel@vger.kernel.org>, Dima Zavin <dmitriyz@google.com>,
        Saravana Kannan <skannan@codeaurora.org>,
        Ben Dooks <ben-linux@fluff.org>,
        Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/2] Common struct clk implementation, v14
Message-ID: <20110418105442.GB27864@linux-sh.org>
References: <1299134429.100626.661279191478.0.gpush@pororo> <1302754859.2767.30.camel@pororo> <20110414100048.GB1611@n2100.arm.linux.org.uk> <1302776705.28876.113.camel@pasglop> <20110414103200.GF1611@n2100.arm.linux.org.uk> <alpine.LFD.2.00.1104140751220.24613@xanadu.home> <20110414120904.GH1611@n2100.arm.linux.org.uk> <alpine.LFD.2.00.1104140920110.24613@xanadu.home> <20110414153813.GC6259@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110414153813.GC6259@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 14, 2011 at 04:38:14PM +0100, Russell King - ARM Linux wrote:
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
> 
A common struct clk implementation will at least allow you to whittle
this number down a bit, but it's obviously not possible to attempt to
work with the generic infrastructure prior to it being merged. Given that
there is nothing ARM-specific about the patch series it doesn't much
matter which tree it ultimately gets merged through, so long as it's in
place for people to build on top of for the next merge window.

> Now, the next thing is that Linus hasn't been too happy about driver stuff
> coming via my tree either - it's something which has been the subject of
> concern in private email.  I've _already_ said something about that prior
> to the recent merge window.  So should I take the clk API stuff which
> touches the drivers subtree?  If yes, it needs to be kept entirely separate
> from the rest of the ARM stuff so we don't end up mixing drivers stuff with
> ARM stuff.

ARM has been the defacto owner for the clock bits to date, but between
clkdev and a common struct clk it's certainly possible to move to a clock
tree and treat it the same as any other subsystem. Moving things out of
arch/arm and in to more generic maintenance paths certainly reduces the
chance for abuse -- and also provides a path for driver stuff.

SH and ARM-based SH/R-Mobile CPUs already share a clock framework, which
I've slowly been refactoring in preparation for Jeremy's common struct
clk. With that merged I'll be able to kill off a couple hundred lines
from the existing implementation at least.

If you'd prefer not to be the guinea pig for the clock bits going in to
.40 I'm certainly happy to take them in a topic branch, convert my
platforms on top of that and send the bits off to Linus early in the
merge window.
