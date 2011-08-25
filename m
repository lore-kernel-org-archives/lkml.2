Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489Ab1HYNEb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 09:04:31 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:38858 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919Ab1HYNE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 09:04:29 -0400
Date: Thu, 25 Aug 2011 14:04:14 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Tejun Heo <tj@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: try_to_freeze() called with IRQs disabled on ARM
Message-ID: <20110825130414.GE8883@n2100.arm.linux.org.uk>
References: <201108232351.55432.rjw@sisk.pl> <CAOS58YNUSn2eVLDLzqKmrtL7M5tSetkhZ1ODecLK54NSDnZVAA@mail.gmail.com> <20110823220056.GK3895@n2100.arm.linux.org.uk> <CAOS58YNuCbaOsWBfmjSUsXsArZ5ng6c0B30yswFbRAWkho6L6Q@mail.gmail.com> <20110823221314.GL3895@n2100.arm.linux.org.uk> <CAOS58YNtQEuke=Ko9J2oNGMECjabzxj=Nrg1o64X1JC3YRmJuw@mail.gmail.com> <20110825121416.GB8883@n2100.arm.linux.org.uk> <20110825121710.GK3286@htj.dyndns.org> <20110825122543.GC8883@n2100.arm.linux.org.uk> <20110825123542.GM3286@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110825123542.GM3286@htj.dyndns.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 25, 2011 at 02:35:42PM +0200, Tejun Heo wrote:
> Hello,
> 
> On Thu, Aug 25, 2011 at 01:25:43PM +0100, Russell King - ARM Linux wrote:
> > No.  Stop bodging and hiding problems.  Anywhere which does this:
> > 
> > 	local_irq_enable();
> > 	do something
> > 	local_irq_disable();
> > 
> > is a bug.  Things are called with IRQs disabled for a reason - randomly
> > re-enabling IRQs does not "fix" stuff, it merely introduces subtle bugs
> > while hiding warnings of those bugs.
> > 
> > Please go back and read my response to Mark at the beginning of this
> > thread, where I describe why IRQs are disabled here.
> > 
> > The only solution here is to fix the problem properly, and I'm working
> > on a patch to fix the problem I highlighted in my earlier response to
> > Mark.  Once we have that problem fixed, we can then (more) safely call
> > do_signal() with IRQs enabled.
> 
> Arrrrrrrrgghhhhhhhhhhhh, why is communication so difficult with you?
> When did I ever suggest that as a proper fix.

I'm not the problem here - I'm pointing out that your suggestion is just
going to make things worse not better.  But it seems you can't cope with
people who criticise your solutions in any way.

> ARM is frigging broken
> in that path so don't push it over to PM and just deal with it inside
> ARM arch code.

For fuck sake, who said anything about pushing it over to PM to deal
with?

I'm talking about not putting sticky plasters over the problem, but fixing
the problem PROPERLY.  I'm sorry if doing a job properly offends you, but
you have to live with that.

I _HATE_ solutions which just paper over problems and make then disappear.
I've always been firmly in the "if there's a problem, fix the problem
properly" camp.  You seem to be firmly in the "lets paper over the problem
and forget about it".

> For now, we need to make the warning go away until it's properly fixed
> so turn off and on IRQ around get_signal_to_deliver() and mark it with
> giant FIXME comment.

No.  This is where we disagree.  It doesn't warrant that because it is
possible to fix the problem properly.  While _you_ may not be capable of
doing that, that's no reason not to seek help to have it fixed.

Given that I've posted a description of the problem, would it not be
reasonable to assume that I'm working on fixing it?  Strangely enough
before writing _any_ of the replies to this thread, I have a patch which
does just that - I just haven't tested it yet apart from a compile test.

> How many times did I write that?  I don't know how to make that any
> clearer to you.  Gees...

Hahaha.  Thanks for the laugh - because you never actually said that -
and you're now blaming me for miscommunication?
