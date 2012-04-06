Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756313Ab2DFLRI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 07:17:08 -0400
Received: from www.linutronix.de ([62.245.132.108]:38283 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755867Ab2DFLRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 07:17:07 -0400
Date: Fri, 6 Apr 2012 13:17:04 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andreas Schwab <schwab@linux-m68k.org>
cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Milton Miller <miltonm@bga.com>, Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH v5 06/27] irq_domain/powerpc: eliminate irq_map; use
 irq_alloc_desc() instead
In-Reply-To: <m2r4w1akz4.fsf@igel.home>
Message-ID: <alpine.LFD.2.02.1204061315040.2542@ionos>
References: <1329383368-12122-1-git-send-email-grant.likely@secretlab.ca> <1329383368-12122-7-git-send-email-grant.likely@secretlab.ca> <m2iphj3zxr.fsf@igel.home> <m2hax2qeqs.fsf@igel.home> <20120402202848.1EB833E02A7@localhost> <m2y5qdow0v.fsf@igel.home>
 <20120404154020.40C513E09D5@localhost> <m2r4w1akz4.fsf@igel.home>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Apr 2012, Andreas Schwab wrote:

> Grant Likely <grant.likely@secretlab.ca> writes:
> 
> > Can you attach console output logs for each of configs above and also
> > with NR_IRQS=128?  That might give me some clues as to which specific
> > code is causing the issues.
> 
> It really looks like the issue starts when irq_expand_nr_irqs is called
> the first time to make nr_irqs bigger than NR_IRQS.

And it looks like the irqdomain code is the real culprit.

void irq_set_virq_count(unsigned int count)
{
        pr_debug("irq: Trying to set virq count to %d\n", count);

        BUG_ON(count < NUM_ISA_INTERRUPTS);
        if (count < NR_IRQS)
                irq_virq_count = count;
}

That looks simply wrong.....

s/NR_IRQS/nr_irqs/ should do the trick.

Thanks,

	tglx
