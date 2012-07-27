Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752404Ab2G0Ody (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 10:33:54 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:49795 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839Ab2G0Odx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 10:33:53 -0400
X-IronPort-AV: E=Sophos;i="4.77,667,1336348800"; 
   d="scan'208";a="13737256"
Message-ID: <1343399630.25096.4.camel@zakaz.uk.xensource.com>
Subject: Re: [PATCH 13/24] xen/arm: get privilege status
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "Tim (Xen.org)" <tim@xen.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "arnd@arndb.de" <arnd@arndb.de>
Date: Fri, 27 Jul 2012 15:33:50 +0100
In-Reply-To: <alpine.DEB.2.02.1207271514140.26163@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1207251741470.26163@kaball.uk.xensource.com>
	 <1343316846-25860-13-git-send-email-stefano.stabellini@eu.citrix.com>
	 <1343382276.6812.126.camel@zakaz.uk.xensource.com>
	 <alpine.DEB.2.02.1207271514140.26163@kaball.uk.xensource.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-07-27 at 15:25 +0100, Stefano Stabellini wrote:
> On Fri, 27 Jul 2012, Ian Campbell wrote:
> > On Thu, 2012-07-26 at 16:33 +0100, Stefano Stabellini wrote:
> > > Use Xen features to figure out if we are privileged.
> > > 
> > > XENFEAT_dom0 was introduced by 23735 in xen-unstable.hg.
> > > 
> > > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > > ---
> > >  arch/arm/xen/enlighten.c         |    7 +++++++
> > >  include/xen/interface/features.h |    3 +++
> > >  2 files changed, 10 insertions(+), 0 deletions(-)
> > > 
> > > diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
> > > index dc68074..2e013cf 100644
> > > --- a/arch/arm/xen/enlighten.c
> > > +++ b/arch/arm/xen/enlighten.c
> > > @@ -2,6 +2,7 @@
> > >  #include <xen/interface/xen.h>
> > >  #include <xen/interface/memory.h>
> > >  #include <xen/platform_pci.h>
> > > +#include <xen/features.h>
> > >  #include <asm/xen/hypervisor.h>
> > >  #include <asm/xen/hypercall.h>
> > >  #include <linux/module.h>
> > > @@ -58,6 +59,12 @@ int __init xen_guest_init(void)
> > >  	}
> > >  	xen_domain_type = XEN_HVM_DOMAIN;
> > >  
> > > +	xen_setup_features();
> > > +	if (xen_feature(XENFEAT_dom0))
> > > +		xen_start_info->flags |= SIF_INITDOMAIN|SIF_PRIVILEGED;
> > > +	else
> > > +		xen_start_info->flags &= ~(SIF_INITDOMAIN|SIF_PRIVILEGED);
> > 
> > What happens here on platforms prior to hypervisor changeset 23735?
> 
> It wouldn't work.
> Considering that we are certainly not going to backport ARM support to
> Xen 4.1, and that both ARM and XENFEAT_dom0 will be present in Xen 4.2,
> do we really need to support the Xen unstable changesets between ARM was
> introduced and XENFEAT_dom0 appeared?

Sorry, I missed the "arm" in the path.

Ian.



