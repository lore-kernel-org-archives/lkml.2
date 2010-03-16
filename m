Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757623Ab0CPF5Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 01:57:24 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53413 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757382Ab0CPF5X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 01:57:23 -0400
Date: Tue, 16 Mar 2010 06:57:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [patch] x86: handle legacy PIC interrupts on all the cpu's
Message-ID: <20100316055714.GA20758@elte.hu>
References: <1268692386.3296.43.camel@sbs-t61.sc.intel.com>
 <4B9EABE8.1020203@kernel.org>
 <1268693771.3296.49.camel@sbs-t61.sc.intel.com>
 <4B9EB185.3010400@kernel.org>
 <20100316053717.GA10765@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100316053717.GA10765@elte.hu>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Yinghai Lu <yinghai@kernel.org> wrote:
> 
> > On 03/15/2010 03:56 PM, Suresh Siddha wrote:
> > > On Mon, 2010-03-15 at 14:51 -0700, Yinghai Lu wrote:
> > >>> +	for (irq = 0; irq < legacy_pic->nr_legacy_irqs; irq++)
> > >>> +		if (!IO_APIC_IRQ(irq))
> > >>> +			per_cpu(vector_irq, cpu)[IRQ0_VECTOR + irq] = irq;
> > >>
> > >> seems those three lines are not needed...
> > > 
> > > Those are needed for !CONFIG_X86_IO_APIC case.
> > > 
> > then we can have
> > 
> > +#ifndef CONFIG_X86_IO_APIC
> > +	for (irq = 0; irq < legacy_pic->nr_legacy_irqs; irq++)
> > +		per_cpu(vector_irq, cpu)[IRQ0_VECTOR + irq] = irq;
> > +#endif
> > 
> > then we don't punish most setup with ioapic controller.
> 
> Ok - i've simplified the code with the above and have added your Acked-by - is 
> that is fine by you?

btw., the patch fixes the regression on the testbox - thanks Suresh!

	Ingo
