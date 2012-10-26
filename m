Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891Ab2JZBkO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 21:40:14 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:25339 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853Ab2JZBkM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 21:40:12 -0400
Date: Thu, 25 Oct 2012 18:39:58 -0700
From: Mukesh Rathor <mukesh.rathor@oracle.com>
To: Ian Campbell <Ian.Campbell@citrix.com>
Cc: xen-devel <xen-devel@lists.xen.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [Xen-devel] [PATCH 4/5] xen: arm: implement remap interfaces
 needed for privcmd mappings.
Message-ID: <20121025183958.0a4ae846@mantra.us.oracle.com>
In-Reply-To: <1351151219.18035.94.camel@zakaz.uk.xensource.com>
References: <1351084756.18035.28.camel@zakaz.uk.xensource.com>
	<1351084777-28898-4-git-send-email-ian.campbell@citrix.com>
	<20121024164411.5b000087@mantra.us.oracle.com>
	<20121024170746.7c89a790@mantra.us.oracle.com>
	<1351151219.18035.94.camel@zakaz.uk.xensource.com>
Organization: Oracle Corporation
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Oct 2012 08:46:59 +0100
Ian Campbell <Ian.Campbell@citrix.com> wrote:

> On Thu, 2012-10-25 at 01:07 +0100, Mukesh Rathor wrote:
> > On Wed, 24 Oct 2012 16:44:11 -0700
> > Mukesh Rathor <mukesh.rathor@oracle.com> wrote:
> > 
> > > >  
> > > > +    /* Indexes into space being mapped. */
> > > > +    GUEST_HANDLE(xen_ulong_t) idxs;
> > > > +
> > > > +    /* GPFN in domid where the source mapping page should
> > > > appear. */
> > > > +    GUEST_HANDLE(xen_pfn_t) gpfns;
> > > 
> > > 
> > > Looking at your arm implementation in xen, doesn't look like you
> > > are expecting idxs and gpfns to be contigous. In that case,
> > > shouldn't idxs and gpfns be pointers, ie, they are sent down as
> > > arrays? Or does GUEST_HANDLE do that, I can't seem to find where
> > > it's defined quickly.
> > 
> > Never mind, I see it got corrected to XEN_GUEST_HANDLE in staging
> > tree.
> 
> The macro is called XEN_GUEST_HANDLE in Xen and just GUEST_HANDLE in
> Linux.
> 
> > Still doesn't compile tho:
> > 
> > public/memory.h:246: error: expected specifier-qualifier-list before
> > ‘__guest_handle_xen_ulong_t’
> > 
> > I'll figure it out.
> 
> Looks like you've got it all sorted?

Yup. I made the change on xen side and added this patch to my tree
and got it working after reverting Konrad's setup.c changes. Not sure
if you need an ack from x86, but if you do:

Acked-by: Mukesh Rathor <mukesh.rathor@oracle.com>

thanks
Mukesh

