Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755544Ab2DGBvz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 21:51:55 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:42293 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755189Ab2DGBvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 21:51:50 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v5 06/27] irq_domain/powerpc: eliminate irq_map; use irq_alloc_desc() instead
To: Thomas Gleixner <tglx@linutronix.de>,
        Andreas Schwab <schwab@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Milton Miller <miltonm@bga.com>, Rob Herring <rob.herring@calxeda.com>
In-Reply-To: <alpine.LFD.2.02.1204061315040.2542@ionos>
References: <1329383368-12122-1-git-send-email-grant.likely@secretlab.ca> <1329383368-12122-7-git-send-email-grant.likely@secretlab.ca> <m2iphj3zxr.fsf@igel.home> <m2hax2qeqs.fsf@igel.home> <20120402202848.1EB833E02A7@localhost> <m2y5qdow0v.fsf@igel.home> <20120404154020.40C513E09D5@localhost> <m2r4w1akz4.fsf@igel.home> <alpine.LFD.2.02.1204061315040.2542@ionos>
Date: Fri, 06 Apr 2012 18:29:42 -0700
Message-Id: <20120407012942.6EAD23E2083@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Apr 2012 13:17:04 +0200 (CEST), Thomas Gleixner <tglx@linutronix.de> wrote:
> On Fri, 6 Apr 2012, Andreas Schwab wrote:
> 
> > Grant Likely <grant.likely@secretlab.ca> writes:
> > 
> > > Can you attach console output logs for each of configs above and also
> > > with NR_IRQS=128?  That might give me some clues as to which specific
> > > code is causing the issues.
> > 
> > It really looks like the issue starts when irq_expand_nr_irqs is called
> > the first time to make nr_irqs bigger than NR_IRQS.
> 
> And it looks like the irqdomain code is the real culprit.
> 
> void irq_set_virq_count(unsigned int count)
> {
>         pr_debug("irq: Trying to set virq count to %d\n", count);
> 
>         BUG_ON(count < NUM_ISA_INTERRUPTS);
>         if (count < NR_IRQS)
>                 irq_virq_count = count;
> }
> 
> That looks simply wrong.....
> 
> s/NR_IRQS/nr_irqs/ should do the trick.

Yeah, that code is wrong and I'll fix it, but the only purpose of that
code is to support the direct mapping on hardware that has limit on
the largest irq number that it can handle.  That shouldn't be the
problem here.

g.

