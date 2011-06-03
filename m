Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755586Ab1FCPGk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 11:06:40 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48621 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751621Ab1FCPGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 11:06:39 -0400
Date: Fri, 3 Jun 2011 16:06:36 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Milton Miller <miltonm@bga.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: genirq: Ensure we locate the passed IRQ in irq_alloc_descs()
Message-ID: <20110603150636.GA9492@opensource.wolfsonmicro.com>
References: <1307037313-15733-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <nack-locate@mdm.bga.com>
 <20110603104217.GA4777@opensource.wolfsonmicro.com>
 <locate-from-more@mdm.bga.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <locate-from-more@mdm.bga.com>
X-Cookie: You enjoy the company of other people.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 03, 2011 at 09:43:42AM -0500, Milton Miller wrote:

> I treated the arguments to irq_alloc_descs as having grown to
> accomidate the two uses having a common allocator with the partially
> redunant encoding.  In one case an exact irq was specified (irq >= 0),
> and one that allocates from anywhere (irq < 0, all callers passed -1).

> Maybe you have a new case.

No, I'm only aware of those two cases.  All my change does is make the
irq parameter be enough to select between the two - at the minute it's
just too weak.

> Do you need a specific irq or an allocated one?

> Or do you have a case where you don't know?

I need either a specific IRQ or an allocated one.  This is just a very
standard driver with an interrupt controller (well, there's a bunch of
devices that are going to be doing the same thing - it's far from just
one driver), it doesn't care what base it gets but systems can specify a
base if they care for the externally visible interrupts (so that they
can be supplied to other devices or whatever).

> > I need about 60 IRQs in the particular driver where I noticed this.

> Do you need a block of 60?  or just 60 somewhere?

The driver assumes it's going to get a contiguous range, it'd be a lot
of bookkeeping for no gain to have to cope with them being splattered
all over the place.

> How do you know from = 0 is safe?

If the user cares they can just pick a number for the base; if they're
going to pick a number they may as well pick the actual number.

> > I don't really see the relevance of this patch?  You're adding
> > functionality for limiting the maximum IRQ number allocated which seems
> > orthogonal to the issue.

> Its relavant in that irq_alloc_descs_range no longer gets both irq and from;
> the information is passed to the underling allocator in a different form.

That's not the goal of the patch, it's just something the patch happens
to do as part of the implementation as far as I can see.
