Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757579Ab1FPQ43 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 12:56:29 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:37781 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752486Ab1FPQ42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 12:56:28 -0400
Date: Thu, 16 Jun 2011 10:56:24 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Rob Herring <robherring2@gmail.com>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH 03/11] dt/irq: add irq_domain_add_simple() helper
Message-ID: <20110616165624.GG3795@ponder.secretlab.ca>
References: <20110616042653.29371.2052.stgit@ponder>
 <20110616044141.29371.76366.stgit@ponder>
 <4DFA0D83.6070604@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DFA0D83.6070604@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 16, 2011 at 09:04:51AM -0500, Rob Herring wrote:
> Grant,
> 
> On 06/15/2011 11:41 PM, Grant Likely wrote:
> > irq_domain_add_simple() is an easy way to generate an irq translation
> > domain for simple irq controllers.  It assumes a flat 1:1 mapping from
> > hardware irq number to an offset of the first linux irq number assigned
> > to the controller
> > 
> > Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> > ---
> >  include/linux/irq.h    |   11 +++++++++
> >  kernel/irq/irqdomain.c |   58 +++++++++++++++++++++++++++++++++++++++++++++++-
> >  2 files changed, 68 insertions(+), 1 deletions(-)
> > 
> > diff --git a/include/linux/irq.h b/include/linux/irq.h
> > index a103c01..50830fc 100644
> > --- a/include/linux/irq.h
> > +++ b/include/linux/irq.h
> > @@ -797,6 +797,17 @@ extern unsigned int irq_domain_map(struct irq_domain *domain,
> >  				   irq_hw_number_t hwirq);
> >  extern void irq_domain_unmap(struct irq_domain *domain, irq_hw_number_t hw);
> >  
> > +struct of_device_id;
> > +#ifdef CONFIG_OF
> > +extern void irq_domain_add_simple(struct device_node *controller, int irq_base);
> > +extern void irq_domain_generate_simple(struct of_device_id *match,
> 
> match should be const

yup

> 
> > +					u64 phys_base, unsigned int irq_start);
> > +#else
> 
> Empty function for irq_domain_add_simple?

Haven't needed it yet.  I'll add it if it comes up.  Honestly, I'm not
even sure if this patch will survive very long once the IRQ
controllers start using irq_domains directly.  This is more of an easy
way to get an irq_domain registration so that DT translations work.

g.
