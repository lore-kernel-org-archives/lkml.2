Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758835Ab2HHQZi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 12:25:38 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:34879 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120Ab2HHQZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 12:25:36 -0400
X-IronPort-AV: E=Sophos;i="4.77,733,1336348800"; 
   d="scan'208";a="13914136"
Date: Wed, 8 Aug 2012 17:24:43 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: David Vrabel <david.vrabel@citrix.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "Tim (Xen.org)" <tim@xen.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [Xen-devel] [PATCH v2 07/23] xen/arm: Xen detection and shared_info
 page mapping
In-Reply-To: <501FEF65.1000304@citrix.com>
Message-ID: <alpine.DEB.2.02.1208081715550.21096@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1208061428060.4645@kaball.uk.xensource.com> <1344263246-28036-7-git-send-email-stefano.stabellini@eu.citrix.com> <501FEF65.1000304@citrix.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Aug 2012, David Vrabel wrote:
> On 06/08/12 15:27, Stefano Stabellini wrote:
> > Check for a "/xen" node in the device tree, if it is present set
> > xen_domain_type to XEN_HVM_DOMAIN and continue initialization.
> > 
> > Map the real shared info page using XENMEM_add_to_physmap with
> > XENMAPSPACE_shared_info.
> > 
> > Changes in v2:
> > 
> > - replace pr_info with pr_debug.
> > 
> > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > ---
> >  arch/arm/xen/enlighten.c |   52 ++++++++++++++++++++++++++++++++++++++++++++++
> >  1 files changed, 52 insertions(+), 0 deletions(-)
> > 
> > diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
> > index d27c2a6..102d823 100644
> > --- a/arch/arm/xen/enlighten.c
> > +++ b/arch/arm/xen/enlighten.c
> > @@ -5,6 +5,9 @@
> >  #include <asm/xen/hypervisor.h>
> >  #include <asm/xen/hypercall.h>
> >  #include <linux/module.h>
> > +#include <linux/of.h>
> > +#include <linux/of_irq.h>
> > +#include <linux/of_address.h>
> >  
> >  struct start_info _xen_start_info;
> >  struct start_info *xen_start_info = &_xen_start_info;
> > @@ -33,3 +36,52 @@ int xen_remap_domain_mfn_range(struct vm_area_struct *vma,
> >  	return -ENOSYS;
> >  }
> >  EXPORT_SYMBOL_GPL(xen_remap_domain_mfn_range);
> > +
> > +/*
> > + * == Xen Device Tree format ==
> > + * - /xen node;
> > + * - compatible "arm,xen";
> > + * - one interrupt for Xen event notifications;
> > + * - one memory region to map the grant_table.
> > + */
> 
> These needs to be documented in Documentation/devicetree/bindings/ and
> should be sent to the devicetree-discuss mailing list for review.

That's a good idea.


> The node should be called 'hypervisor' I think.
> 
> The first word of the compatible string is the vendor/organization that
> defined the binding so should be "xen" here.  This does give a odd
> looking "xen,xen" but we'll have to live with that.
> 
> I'd suggest that the DT provided by the hypervisor or tools give the
> hypercall ABI version in the compatible string as well.  e.g.,
> 
> hypervisor {
>     compatible = "xen,xen-4.3", "xen,xen"
> };

It makes sense, I'll do that.


> I missed the Xen patch that adds this node for dom0.  Can you point me
> to it?

Nope, you didn't miss it: I don't have a patch for Xen yet.
