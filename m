Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710Ab1CYOMf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 10:12:35 -0400
Received: from smtp.citrix.com ([66.165.176.89]:53361 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752142Ab1CYOMe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 10:12:34 -0400
X-IronPort-AV: E=Sophos;i="4.63,243,1299474000"; 
   d="scan'208";a="13317375"
Subject: Re: [PATCH] xen: Convert genirq namespace
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
In-Reply-To: <1301052715.11560.200.camel@cthulhu.hellion.org.uk>
References: <alpine.LFD.2.00.1103251100270.31464@localhost6.localdomain6>
	 <1301052715.11560.200.camel@cthulhu.hellion.org.uk>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Fri, 25 Mar 2011 14:12:31 +0000
Message-ID: <1301062351.3263.5.camel@cthulhu.hellion.org.uk>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resending with Konrad's correct address in the hopes he'll pick this one
up too ;-)

On Fri, 2011-03-25 at 11:31 +0000, Ian Campbell wrote:
> On Fri, 2011-03-25 at 10:01 +0000, Thomas Gleixner wrote:
> > Converted with coccinelle.
> > 
> > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> 
> Seems pretty obvious and mechanical...
> 
> Acked-by: Ian Campbell <ian.campbell@citrix.com>
> 
> Are you carrying it or shall we?
> 
> > ---
> >  drivers/xen/events.c |   22 +++++++++++-----------
> >  1 file changed, 11 insertions(+), 11 deletions(-)
> > 
> > Index: linux-2.6-tip/drivers/xen/events.c
> > ===================================================================
> > --- linux-2.6-tip.orig/drivers/xen/events.c
> > +++ linux-2.6-tip/drivers/xen/events.c
> > @@ -122,7 +122,7 @@ static struct irq_chip xen_pirq_chip;
> >  /* Get info for IRQ */
> >  static struct irq_info *info_for_irq(unsigned irq)
> >  {
> > -	return get_irq_data(irq);
> > +	return irq_get_handler_data(irq);
> >  }
> >  
> >  /* Constructors for packed IRQ information. */
> > @@ -403,7 +403,7 @@ static void xen_irq_init(unsigned irq)
> >  
> >  	info->type = IRQT_UNBOUND;
> >  
> > -	set_irq_data(irq, info);
> > +	irq_set_handler_data(irq, info);
> >  
> >  	list_add_tail(&info->list, &xen_irq_list_head);
> >  }
> > @@ -458,11 +458,11 @@ static int __must_check xen_allocate_irq
> >  
> >  static void xen_free_irq(unsigned irq)
> >  {
> > -	struct irq_info *info = get_irq_data(irq);
> > +	struct irq_info *info = irq_get_handler_data(irq);
> >  
> >  	list_del(&info->list);
> >  
> > -	set_irq_data(irq, NULL);
> > +	irq_set_handler_data(irq, NULL);
> >  
> >  	kfree(info);
> >  
> > @@ -639,8 +639,8 @@ int xen_bind_pirq_gsi_to_irq(unsigned gs
> >  	if (irq < 0)
> >  		goto out;
> >  
> > -	set_irq_chip_and_handler_name(irq, &xen_pirq_chip,
> > -				      handle_level_irq, name);
> > +	irq_set_chip_and_handler_name(irq, &xen_pirq_chip, handle_level_irq,
> > +				      name);
> >  
> >  	irq_op.irq = irq;
> >  	irq_op.vector = 0;
> > @@ -690,8 +690,8 @@ int xen_bind_pirq_msi_to_irq(struct pci_
> >  	if (irq == -1)
> >  		goto out;
> >  
> > -	set_irq_chip_and_handler_name(irq, &xen_pirq_chip,
> > -				      handle_level_irq, name);
> > +	irq_set_chip_and_handler_name(irq, &xen_pirq_chip, handle_level_irq,
> > +				      name);
> >  
> >  	xen_irq_info_pirq_init(irq, 0, pirq, 0, vector, 0);
> >  	ret = irq_set_msi_desc(irq, msidesc);
> > @@ -772,7 +772,7 @@ int bind_evtchn_to_irq(unsigned int evtc
> >  		if (irq == -1)
> >  			goto out;
> >  
> > -		set_irq_chip_and_handler_name(irq, &xen_dynamic_chip,
> > +		irq_set_chip_and_handler_name(irq, &xen_dynamic_chip,
> >  					      handle_fasteoi_irq, "event");
> >  
> >  		xen_irq_info_evtchn_init(irq, evtchn);
> > @@ -799,7 +799,7 @@ static int bind_ipi_to_irq(unsigned int 
> >  		if (irq < 0)
> >  			goto out;
> >  
> > -		set_irq_chip_and_handler_name(irq, &xen_percpu_chip,
> > +		irq_set_chip_and_handler_name(irq, &xen_percpu_chip,
> >  					      handle_percpu_irq, "ipi");
> >  
> >  		bind_ipi.vcpu = cpu;
> > @@ -848,7 +848,7 @@ int bind_virq_to_irq(unsigned int virq, 
> >  		if (irq == -1)
> >  			goto out;
> >  
> > -		set_irq_chip_and_handler_name(irq, &xen_percpu_chip,
> > +		irq_set_chip_and_handler_name(irq, &xen_percpu_chip,
> >  					      handle_percpu_irq, "virq");
> >  
> >  		bind_virq.virq = virq;
> 


