Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758533Ab1DNPjS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 11:39:18 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:54596 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756490Ab1DNPjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 11:39:16 -0400
Date: Thu, 14 Apr 2011 16:38:14 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>, linux-sh@vger.kernel.org,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Paul Mundt <lethal@linux-sh.org>, lkml <linux-kernel@vger.kernel.org>,
        Dima Zavin <dmitriyz@google.com>,
        Saravana Kannan <skannan@codeaurora.org>,
        Ben Dooks <ben-linux@fluff.org>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/2] Common struct clk implementation, v14
Message-ID: <20110414153813.GC6259@n2100.arm.linux.org.uk>
References: <1299134429.100626.661279191478.0.gpush@pororo> <1302754859.2767.30.camel@pororo> <20110414100048.GB1611@n2100.arm.linux.org.uk> <1302776705.28876.113.camel@pasglop> <20110414103200.GF1611@n2100.arm.linux.org.uk> <alpine.LFD.2.00.1104140751220.24613@xanadu.home> <20110414120904.GH1611@n2100.arm.linux.org.uk> <alpine.LFD.2.00.1104140920110.24613@xanadu.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1104140920110.24613@xanadu.home>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 14, 2011 at 09:39:58AM -0400, Nicolas Pitre wrote:
> I might have a look later.  However it is clear that the ARM tree will 
> _never_ be as small as, say, X86 or even PPC given the indisputable 
> amount of hardware variations within the ARM landscape that is not to be 
> seen anywhere else.  Until the ARM ecosystem converge towards a single 
> whole-system architecture we won't be able to match X86 in terms of code 
> reduction.  Anyone thinking otherwise is living in a different universe.
> 
> However we can and must do better in consolidation work in order to make 
> the tree more maintainable of course.  _That_ is the real issue and 
> _that_ is what the ARM tree sucks at.  The fact that this consolidation 
> work might reduce the size of the ARM code is only a side effect, not 
> the primary goal.  So let's not get too hung up about LOC but focus on 
> improving the infrastructure instead.

Look, this is what is in amongst the 6K lines of new code - these are
the top two in the diffstat with the highest number of additional lines:

 arch/arm/mach-ux500/clock-db8500.c                 | 1291 +++++++++++++
 arch/arm/mach-ux500/prcmu-db8500.c                 | 2018 ++++++++++++++++++++

These comprise 50% of the 6K of new code.  clock-db8500.c is a mixture
of code and data declarations for individual clocks - which is essentially
what Linus picked up with his complaint on under OMAP.  That in itself
makes me worried.

Looking at the other file, prcmu-db8500.c seems to contain at least 5 sets
of mailbox support code.  Take a look at "Subject: [PATCH 9/9] mach-ux500:
add DB5500 PRCMU interface" from Linus Walleij on 31st March on this list
for the patch.  Are we sure that this couldn't be consolidated in some
way, at least at file level?

So while you can say about not getting hung up about LOC, LOC is a good
indication that things are still going wrong in much the same way.

On the positive note, it looks like MX3 is being merged into IMX stuff,
which is good news, and the mxc91231 has been dropped.  We need to ensure
that good work like this, which will make Linus happy, doesn't get
swamped by new stuff.

We must take Linus' complaint about 'churn' seriously - it's not something
new that he's just started to complain about in the last month.  It's
something which he's complained about on a number of occasions.  Feel free
to think what you may about that, but just bear in mind that Linus holds
the keys to the mainline kernel, and he can put us in a different universe.

Now, the next thing is that Linus hasn't been too happy about driver stuff
coming via my tree either - it's something which has been the subject of
concern in private email.  I've _already_ said something about that prior
to the recent merge window.  So should I take the clk API stuff which
touches the drivers subtree?  If yes, it needs to be kept entirely separate
from the rest of the ARM stuff so we don't end up mixing drivers stuff with
ARM stuff.
