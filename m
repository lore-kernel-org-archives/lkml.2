Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752461Ab0JVD1E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 23:27:04 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37054 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066Ab0JVD1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 23:27:03 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 22 Oct 2010 12:21:37 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        steiner@sgi.com, yinghai@kernel.org, mingo@elte.hu,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v2 2/2] try to fix /proc/stat scalability of irq sum of
 all cpu
Message-Id: <20101022122137.335103ca.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20101021125816.7d4517c8.akpm@linux-foundation.org>
References: <20101021160134.d4c99943.kamezawa.hiroyu@jp.fujitsu.com>
	<20101021160343.b7a0f60e.kamezawa.hiroyu@jp.fujitsu.com>
	<20101021125816.7d4517c8.akpm@linux-foundation.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Oct 2010 12:58:16 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> >  /*
> >   * Number of interrupts per cpu, since bootup
> > Index: mmotm-1020/kernel/irq/irqdesc.c
> > ===================================================================
> > --- mmotm-1020.orig/kernel/irq/irqdesc.c
> > +++ mmotm-1020/kernel/irq/irqdesc.c
> > @@ -393,3 +393,19 @@ unsigned int kstat_irqs_cpu(unsigned int
> >  	struct irq_desc *desc = irq_to_desc(irq);
> >  	return desc ? desc->kstat_irqs[cpu] : 0;
> >  }
> > +
> > +#ifdef CONFIG_GENERIC_HARDIRQS
> > +unsigned int  kstat_irqs(unsigned int irq)
> > +{
> > +	struct irq_desc *desc = irq_to_desc(irq);
> > +	int cpu;
> > +	int sum = 0;
> > +
> > +	if (!desc)
> > +		return 0;
> > +	for_each_possible_cpu(cpu)
> > +		sum += desc->kstat_irqs[cpu];
> > +	return sum;
> > +}
> > +EXPORT_SYMBOL_GPL(kstat_irqs);
> 
> kstat_irqs() needs to be exported to modules because of some silliness
> in drivers/isdn/hisax/config.c.  But in linux-next that silliness got
> deleted and the kstat_irqs export was removed.
> 
Okay, thank you for fixing.

-Kame

