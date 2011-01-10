Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820Ab1AJVRc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 16:17:32 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:61700 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754733Ab1AJVRb (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 10 Jan 2011 16:17:31 -0500
Date: Mon, 10 Jan 2011 16:16:18 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
        Ian Campbell <Ian.Campbell@eu.citrix.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "Derek G. Murray" <Derek.Murray@cl.cam.ac.uk>,
        Gerd Hoffmann <kraxel@redhat.com>
Subject: Re: [PATCH 06/11] xen: gntdev: move use of GNTMAP_contains_pte
 next to the map_op
Message-ID: <20110110211617.GB15016@dumpdata.com>
References: <alpine.DEB.2.00.1012151259510.2390@kaball-desktop>
 <1292420446-3348-6-git-send-email-stefano.stabellini@eu.citrix.com>
 <20110105202425.GD29993@dumpdata.com>
 <alpine.DEB.2.00.1101071403390.2390@kaball-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1101071403390.2390@kaball-desktop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 10, 2011 at 10:32:51AM +0000, Stefano Stabellini wrote:
> On Wed, 5 Jan 2011, Konrad Rzeszutek Wilk wrote:
> > On Wed, Dec 15, 2010 at 01:40:41PM +0000, stefano.stabellini@eu.citrix.com wrote:
> > > From: Ian Campbell <ian.campbell@citrix.com>
> > > 
> > > This flag controls the meaning of gnttab_map_grant_ref.host_addr and
> > > specifies that the field contains a refernce to the pte entry to be
> >                                       ^^^^^^^^ - reference
> 
> fixed it
> 
> > > diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
> > > index cf61c7d..b916d6b 100644
> > > --- a/drivers/xen/gntdev.c
> > > +++ b/drivers/xen/gntdev.c
> > > @@ -205,10 +205,12 @@ static int find_grant_ptes(pte_t *pte, pgtable_t token, unsigned long addr, void
> > >  	BUG_ON(pgnr >= map->count);
> > >  	pte_maddr  = (u64)pfn_to_mfn(page_to_pfn(token)) << PAGE_SHIFT;
> > >  	pte_maddr += (unsigned long)pte & ~PAGE_MASK;
> > > -	gnttab_set_map_op(&map->map_ops[pgnr], pte_maddr, map->flags,
> > > +	gnttab_set_map_op(&map->map_ops[pgnr], pte_maddr,
> > > +			  GNTMAP_contains_pte | map->flags,
> > 
> > Ok, but the gnttab_set_map_op will do the exact thing it did before. It still does this:
> > 
> > map->host_addr = addr;
> > 
> > irregardless if you pass in any flag.
> > 
> 
> Yes, but the flags are set in map_ops and that is critical because it
> changes the meanings of the hypercall arguments.

Aaaaaah.. That is what I missed. Thx
