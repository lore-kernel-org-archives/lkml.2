Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758398Ab2DFXih (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 19:38:37 -0400
Received: from gate.crashing.org ([63.228.1.57]:45907 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752848Ab2DFXig (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 19:38:36 -0400
Message-ID: <1333755470.3040.38.camel@pasglop>
Subject: Re: [PATCH v5 06/27] irq_domain/powerpc: eliminate irq_map; use
 irq_alloc_desc() instead
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Milton Miller <miltonm@bga.com>, Rob Herring <rob.herring@calxeda.com>,
        Thomas Gleixner <tglx@linutronix.de>, linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org
Date: Sat, 07 Apr 2012 09:37:50 +1000
In-Reply-To: <m24nsx9iz1.fsf@igel.home>
References: <1329383368-12122-1-git-send-email-grant.likely@secretlab.ca>
	 <1329383368-12122-7-git-send-email-grant.likely@secretlab.ca>
	 <m2iphj3zxr.fsf@igel.home> <m2hax2qeqs.fsf@igel.home>
	 <20120402202848.1EB833E02A7@localhost>
	 <20120402215524.GM24211@n2100.arm.linux.org.uk>
	 <1333406005.30734.61.camel@pasglop>
	 <20120402225223.GN24211@n2100.arm.linux.org.uk>
	 <1333409927.30734.62.camel@pasglop> <m24nsx9iz1.fsf@igel.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-04-06 at 13:51 +0200, Andreas Schwab wrote:
> Benjamin Herrenschmidt <benh@kernel.crashing.org> writes:
> 
> > Ok. Doesn't matter anyway, this shouldn't be the problem in this
> > specific case. IE. we shouldn't be setting that interrupt to NONE.
> 
> After removinge the call to irq_set_irq_type in mpic_host_map the irq
> problem disappears.
> 
> Instead of the irq_set_irq_type(,NONE) calls from mpic_host_map I see
> corresponding irq_set_irq_type(,LEVEL_LOW) calls now.

It's arguable that this irq_set_irq_type(,NONE) shouln't be there but
still ... it's been around for ever and things worked :-) So something
-else- is causing the problem and I'd like to understand what exactly.

(When I say arguable, I do mean it. There are some reasons to keep it
even if we agree that it's not "setting a default" but marking the
interrupt as somewhat disabled as Russell wants, that's fine with me, an
MPIC external interrupt should -always- have a proper type set before
being used).

First we need to fix that business with NR_IRQS/nr_irqs everywhere, then
if the problem persists, check why we aren't calling the proper
irq_set_irq_type() after the mapping is established (we should be).

Cheers,
Ben.


