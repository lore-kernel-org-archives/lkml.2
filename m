Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773Ab2JDKI7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 06:08:59 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:42683 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496Ab2JDKI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 06:08:58 -0400
X-IronPort-AV: E=Sophos;i="4.80,533,1344211200"; 
   d="scan'208";a="14935981"
Date: Thu, 4 Oct 2012 11:07:46 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Jan Beulich <JBeulich@suse.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH] xen/xen_initial_domain: check that xen_start_info
 is initialized
In-Reply-To: <506D5A53020000780009F8B7@nat28.tlf.novell.com>
Message-ID: <alpine.DEB.2.02.1210041106560.29232@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1210031431080.29232@kaball.uk.xensource.com> <1349272182.650.150.camel@zakaz.uk.xensource.com> <alpine.DEB.2.02.1210031450220.29232@kaball.uk.xensource.com> <1349272482.650.151.camel@zakaz.uk.xensource.com>
 <20121003141116.GA10633@phenom.dumpdata.com> <1349276431.650.156.camel@zakaz.uk.xensource.com> <alpine.DEB.2.02.1210031641050.29232@kaball.uk.xensource.com> <1349279862.650.171.camel@zakaz.uk.xensource.com> <alpine.DEB.2.02.1210031658120.29232@kaball.uk.xensource.com>
 <1349280814.650.178.camel@zakaz.uk.xensource.com> <1349282492.650.185.camel@zakaz.uk.xensource.com> <alpine.DEB.2.02.1210031807340.29232@kaball.uk.xensource.com> <506D5A53020000780009F8B7@nat28.tlf.novell.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Oct 2012, Jan Beulich wrote:
> >>> On 03.10.12 at 19:08, Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
> wrote:
> > Since commit commit 4c071ee5268f7234c3d084b6093bebccc28cdcba ("arm:
> > initial Xen support") PV on HVM guests can be xen_initial_domain.
> > However PV on HVM guests might have an unitialized xen_start_info, so
> > check before accessing its fields.
> > 
> > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > Acked-by: Ian Campbell <Ian.Campbell@citrix.com>
> > Reported-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > 
> > diff --git a/include/xen/xen.h b/include/xen/xen.h
> > index 9a39ca5..e7101bb 100644
> > --- a/include/xen/xen.h
> > +++ b/include/xen/xen.h
> > @@ -28,7 +28,7 @@ extern enum xen_domain_type xen_domain_type;
> >  #include <asm/xen/hypervisor.h>
> >  
> >  #define xen_initial_domain()	(xen_domain() && \
> > -				 xen_start_info->flags & SIF_INITDOMAIN)
> > +				 xen_start_info && xen_start_info->flags & SIF_INITDOMAIN)
> >  #else  /* !CONFIG_XEN_DOM0 */
> >  #define xen_initial_domain()	(0)
> >  #endif	/* CONFIG_XEN_DOM0 */
> 
> Didn't your other patch statically initialize it?

Yes. Even though both patches can safely coexist, I wrote this one as an
alternative solution.
