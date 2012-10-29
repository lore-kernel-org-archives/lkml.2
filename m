Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754972Ab2J2OqE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 10:46:04 -0400
Received: from aserp1050.oracle.com ([141.146.126.70]:37421 "EHLO
	aserp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791Ab2J2OqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 10:46:02 -0400
Date: Mon, 29 Oct 2012 09:50:26 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ian Campbell <Ian.Campbell@citrix.com>
Cc: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "mukesh.rathor@oracle.com" <mukesh.rathor@oracle.com>
Subject: Re: [PATCH 03/10] xen/hypercall: Make xen_remove_from_physmap the
 same on 64/32 builds.
Message-ID: <20121029135025.GW2708@phenom.dumpdata.com>
References: <1351015931-16991-1-git-send-email-konrad.wilk@oracle.com>
 <1351015931-16991-4-git-send-email-konrad.wilk@oracle.com>
 <1351071622.2237.130.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351071622.2237.130.camel@zakaz.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: aserp1040.oracle.com [141.146.126.69]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 10:40:22AM +0100, Ian Campbell wrote:
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

OK, we can always remove it later on?
