Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755631Ab1IQXYq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Sep 2011 19:24:46 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:45454 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755334Ab1IQXYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Sep 2011 19:24:45 -0400
Date: Sat, 17 Sep 2011 17:24:42 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Rob Herring <robherring2@gmail.com>, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        marc.zyngier@arm.com, thomas.abraham@linaro.org, jamie@jamieiles.com,
        b-cousson@ti.com, shawn.guo@linaro.org,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH 2/5] irq: fix existing domain check in irq_domain_add
Message-ID: <20110917232442.GZ3523@ponder.secretlab.ca>
References: <1316017900-19918-1-git-send-email-robherring2@gmail.com>
 <1316017900-19918-3-git-send-email-robherring2@gmail.com>
 <alpine.LFD.2.02.1109141838510.2723@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1109141838510.2723@ionos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 14, 2011 at 06:44:50PM +0200, Thomas Gleixner wrote:
> On Wed, 14 Sep 2011, Rob Herring wrote:
> 
> > From: Rob Herring <rob.herring@calxeda.com>
> > 
> > irq_data will normally exist, so the domain was prevented from being set.
> > The simple domain code did not hit this as nr_irq is always 0.
> > 
> > Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> > Cc: Grant Likely <grant.likely@secretlab.ca>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> 
> I take this and 1/5 through irq/urgent

Thanks Thomas.

g.

> 
> Thanks,
> 
> 	tglx
> 
> > ---
> >  kernel/irq/irqdomain.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
> > index d5828da..84f4110 100644
> > --- a/kernel/irq/irqdomain.c
> > +++ b/kernel/irq/irqdomain.c
> > @@ -29,7 +29,7 @@ void irq_domain_add(struct irq_domain *domain)
> >  	 */
> >  	for (hwirq = 0; hwirq < domain->nr_irq; hwirq++) {
> >  		d = irq_get_irq_data(irq_domain_to_irq(domain, hwirq));
> > -		if (d || d->domain) {
> > +		if (d && d->domain) {
> >  			/* things are broken; just report, don't clean up */
> >  			WARN(1, "error: irq_desc already assigned to a domain");
> >  			return;
> > -- 
> > 1.7.5.4
> > 
> > 
