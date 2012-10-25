Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934185Ab2JYAH4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 20:07:56 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:21724 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932178Ab2JYAHz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 20:07:55 -0400
Date: Wed, 24 Oct 2012 17:07:46 -0700
From: Mukesh Rathor <mukesh.rathor@oracle.com>
To: Mukesh Rathor <mukesh.rathor@oracle.com>
Cc: Ian Campbell <ian.campbell@citrix.com>,
        xen-devel <xen-devel@lists.xen.org>,
        Stefano Stabellini <stefano.stabellini@citrix.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [Xen-devel] [PATCH 4/5] xen: arm: implement remap interfaces
 needed for privcmd mappings.
Message-ID: <20121024170746.7c89a790@mantra.us.oracle.com>
In-Reply-To: <20121024164411.5b000087@mantra.us.oracle.com>
References: <1351084756.18035.28.camel@zakaz.uk.xensource.com>
	<1351084777-28898-4-git-send-email-ian.campbell@citrix.com>
	<20121024164411.5b000087@mantra.us.oracle.com>
Organization: Oracle Corporation
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Oct 2012 16:44:11 -0700
Mukesh Rathor <mukesh.rathor@oracle.com> wrote:

> >  
> >  #ifndef HYPERVISOR_VIRT_START
> > diff --git a/include/xen/interface/memory.h
> > b/include/xen/interface/memory.h index ad0dff5..5de2b36 100644
> > --- a/include/xen/interface/memory.h
> > +++ b/include/xen/interface/memory.h
> > @@ -188,6 +188,24 @@ DEFINE_GUEST_HANDLE_STRUCT(xen_add_to_physmap);
> >  /*** REMOVED ***/
> >  /*#define XENMEM_translate_gpfn_list  8*/
> >  
> > +#define XENMEM_add_to_physmap_range 23
> > +struct xen_add_to_physmap_range {
> > +    /* Which domain to change the mapping for. */
> > +    domid_t domid;
> > +    uint16_t space; /* => enum phys_map_space */
> > +
> > +    /* Number of pages to go through */
> > +    uint16_t size;
> > +    domid_t foreign_domid; /* IFF gmfn_foreign */
> > +
> > +    /* Indexes into space being mapped. */
> > +    GUEST_HANDLE(xen_ulong_t) idxs;
> > +
> > +    /* GPFN in domid where the source mapping page should appear.
> > */
> > +    GUEST_HANDLE(xen_pfn_t) gpfns;
> 
> 
> Looking at your arm implementation in xen, doesn't look like you are
> expecting idxs and gpfns to be contigous. In that case, shouldn't idxs
> and gpfns be pointers, ie, they are sent down as arrays? Or does
> GUEST_HANDLE do that, I can't seem to find where it's defined quickly.

Never mind, I see it got corrected to XEN_GUEST_HANDLE in staging tree.
Still doesn't compile tho:

public/memory.h:246: error: expected specifier-qualifier-list before
‘__guest_handle_xen_ulong_t’

I'll figure it out.

thanks,
Mukesh
