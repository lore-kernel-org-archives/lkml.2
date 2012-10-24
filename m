Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758231Ab2JXLDP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 07:03:15 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:63087 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758119Ab2JXLDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 07:03:14 -0400
X-IronPort-AV: E=Sophos;i="4.80,639,1344211200"; 
   d="scan'208";a="15355559"
Date: Wed, 24 Oct 2012 12:02:43 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Ian Campbell <Ian.Campbell@citrix.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "mukesh.rathor@oracle.com" <mukesh.rathor@oracle.com>
Subject: Re: [PATCH 03/10] xen/hypercall: Make xen_remove_from_physmap the
 same on 64/32 builds.
In-Reply-To: <1351071622.2237.130.camel@zakaz.uk.xensource.com>
Message-ID: <alpine.DEB.2.02.1210241202140.2689@kaball.uk.xensource.com>
References: <1351015931-16991-1-git-send-email-konrad.wilk@oracle.com>  <1351015931-16991-4-git-send-email-konrad.wilk@oracle.com> <1351071622.2237.130.camel@zakaz.uk.xensource.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Oct 2012, Ian Campbell wrote:
> On Tue, 2012-10-23 at 19:12 +0100, Konrad Rzeszutek Wilk wrote:
> > By making the structure exactly the same size and with the same
> > offsets on 64 and 32-bit builds we are future-proofing ourselves.
> > 
> > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > ---
> >  include/xen/interface/memory.h |    7 ++++++-
> >  1 files changed, 6 insertions(+), 1 deletions(-)
> > 
> > diff --git a/include/xen/interface/memory.h b/include/xen/interface/memory.h
> > index 8beebdb..6b07b54 100644
> > --- a/include/xen/interface/memory.h
> > +++ b/include/xen/interface/memory.h
> > @@ -253,9 +253,14 @@ extern spinlock_t xen_reservation_lock;
> >  struct xen_remove_from_physmap {
> >      /* Which domain to change the mapping for. */
> >      domid_t domid;
> > -
> > +   /* To be used in the future if need to. */
> > +    uint8_t reserved[6];
> >      /* GPFN of the current mapping of the page. */
> >      xen_pfn_t gpfn;
> > +#ifdef CONFIG_X86_32
> > +    /* No need to do that on ARM as xen_pfn_t is always 8 bytes. */
> > +    uint8_t __pad[4];
> > +#endif
> 
> I'm not sure if this last one is necessary since this isn't a struct
> which would get used in an array. I guess it doesn't hurt though.

That's right, I don't think that the last padding is actually necessary.
