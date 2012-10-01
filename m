Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752385Ab2JAN73 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 09:59:29 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:35206 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153Ab2JAN7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 09:59:25 -0400
Date: Mon, 1 Oct 2012 09:47:53 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/16] iommu/amd: Add IOAPIC remapping routines
Message-ID: <20121001134753.GF4099@phenom.dumpdata.com>
References: <1348835046-3262-1-git-send-email-joerg.roedel@amd.com>
 <1348835046-3262-10-git-send-email-joerg.roedel@amd.com>
 <6d716497-bcf6-4d71-88a3-6ec772a4d396@sausexedgep01.amd.com>
 <20121001084051.GO4009@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121001084051.GO4009@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 01, 2012 at 10:40:51AM +0200, Joerg Roedel wrote:
> On Fri, Sep 28, 2012 at 10:45:15AM -0400, Konrad Rzeszutek Wilk wrote:
> > On Fri, Sep 28, 2012 at 02:23:59PM +0200, Joerg Roedel wrote:
> > > +	/*
> > > +	 * Mask level triggered irqs.
> > > +	 * Use IRQ_DELAYED_DISABLE for edge triggered irqs.
> > 
> > so how come it is not set?
> 
> Don't understand this. What is not set?

the IRQ_DELAYED_DISABLE. But I could not even find that enum anymore?
Has that been obsoleted?
> 
> > > +	if (!config_enabled(CONFIG_SMP))
> > > +		return -1;
> > 
> > -1? -ENOx something?
> 
> No, -1 for compatibiblity with the other implementation of this.

OK.
> 
> > > +	err = apic->cpu_mask_to_apicid_and(cfg->domain, mask, &dest);
> > > +	if (err) {
> > > +		if (assign_irq_vector(irq, cfg, data->affinity))
> > > +			pr_err("AMD-Vi: Failed to recover vector for irq %d\n", irq);
> > 
> > If we do OK with the assignment of the vector, should we just continue
> > on instead of returning error?
> 
> The purpose of this is to recover to the old affinity if we failed at
> this point. Even in this case, setting the new affinity still failed and
> we need to inform the caller about this. Thus returning the error.
> Also note the pr_err message which also tells you about the
> recovery-case :)

I was thinking the other way around. You recover the old affinity. Should
you print out a warning mentioning to the system admin that you could not
set the new affinity but reverted to the old one? Or will that not serve
anything except spam the kernel logs?
