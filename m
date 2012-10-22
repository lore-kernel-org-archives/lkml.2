Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816Ab2JVQks (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 12:40:48 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:23612 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095Ab2JVQkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 12:40:47 -0400
X-IronPort-AV: E=Sophos;i="4.80,630,1344211200"; 
   d="scan'208";a="15315856"
Date: Mon, 22 Oct 2012 17:40:19 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "mukesh.rathor@oracle.com" <mukesh.rathor@oracle.com>,
        Ian Campbell <Ian.Campbell@citrix.com>
Subject: Re: [PATCH 5/6] xen/pvh: balloon and grant changes.
In-Reply-To: <20121022160455.GC25200@phenom.dumpdata.com>
Message-ID: <alpine.DEB.2.02.1210221738440.2689@kaball.uk.xensource.com>
References: <1350695882-12820-1-git-send-email-konrad.wilk@oracle.com> <1350695882-12820-6-git-send-email-konrad.wilk@oracle.com> <alpine.DEB.2.02.1210221423510.2689@kaball.uk.xensource.com> <20121022160455.GC25200@phenom.dumpdata.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Oct 2012, Konrad Rzeszutek Wilk wrote:
> > > +
> > >  			int ret;
> > >  			ret = HYPERVISOR_update_va_mapping(
> > >  				(unsigned long)__va(pfn << PAGE_SHIFT),
> > > @@ -418,12 +420,13 @@ static enum bp_state decrease_reservation(unsigned long nr_pages, gfp_t gfp)
> > >  		scrub_page(page);
> > >  
> > >  		if (xen_pv_domain() && !PageHighMem(page)) {
> > > -			ret = HYPERVISOR_update_va_mapping(
> > > -				(unsigned long)__va(pfn << PAGE_SHIFT),
> > > -				__pte_ma(0), 0);
> > > -			BUG_ON(ret);
> > > +			if (!xen_feature(XENFEAT_auto_translated_physmap)) {
> > > +				ret = HYPERVISOR_update_va_mapping(
> > > +					(unsigned long)__va(pfn << PAGE_SHIFT),
> > > +					__pte_ma(0), 0);
> > > +				BUG_ON(ret);
> > > +			}
> > >  		}
> > 
> > this change, unlike the one before, actually makes things different for
> > traditional pv domains in case PageHighMem(page).
> 
> How? He is not altering the !PageHighMem check. Just adding a check
> before the hypercall to render it nop on PVH.

sorry, you are right, I need new glasses
