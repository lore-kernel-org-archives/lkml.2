Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181Ab1BKLj1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 06:39:27 -0500
Received: from www.tglx.de ([62.245.132.106]:35420 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755759Ab1BKLj0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 06:39:26 -0500
Date: Fri, 11 Feb 2011 12:39:03 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Lars-Peter Clausen <lars@metafoo.de>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 17/75] genirq: Consolidate IRQ_DISABLED
In-Reply-To: <4D54EBE0.3050408@metafoo.de>
Message-ID: <alpine.LFD.2.00.1102111238370.31804@localhost6.localdomain6>
References: <20110210222908.661199947@linutronix.de> <20110210223255.961530799@linutronix.de> <4D54EBE0.3050408@metafoo.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Feb 2011, Lars-Peter Clausen wrote:

> On 02/11/2011 12:36 AM, Thomas Gleixner wrote:
> > Index: linux-2.6-tip/kernel/irq/chip.c
> > ===================================================================
> > --- linux-2.6-tip.orig/kernel/irq/chip.c
> > +++ linux-2.6-tip/kernel/irq/chip.c
> > @@ -192,11 +192,14 @@ EXPORT_SYMBOL_GPL(set_irq_nested_thread)
> >
> >  int irq_startup(struct irq_desc *desc)
> >  {
> > -	desc->status &= ~(IRQ_MASKED | IRQ_DISABLED);
> > +	desc->status &= ~IRQ_DISABLED;
> >  	desc->depth = 0;
> >
> > -	if (desc->irq_data.chip->irq_startup)
> > -		return desc->irq_data.chip->irq_startup(&desc->irq_data);
> > +	if (desc->irq_data.chip->irq_startup) {
> > +		int ret = desc->irq_data.chip->irq_startup(&desc->irq_data);
> > +		desc->status &= IRQ_MASKED;
> 
> Although it is fixed in patch 45 of this series, I guess it should rather be
> desc->status &= ~IRQ_MASKED here too.

Good catch. Will fix nevertheless.

Thanks,

	tglx
