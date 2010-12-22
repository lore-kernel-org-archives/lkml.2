Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229Ab0LVPEg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 10:04:36 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:23047 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455Ab0LVPEf (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 22 Dec 2010 10:04:35 -0500
Date: Wed, 22 Dec 2010 10:02:58 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com,
        Jan Beulich <JBeulich@novell.com>, xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad@kernel.org>
Subject: Re: [PATCH 04/10] xen/mmu: For 1-1 mapping, automatically set
 _PAGE_IOMAP.
Message-ID: <20101222150258.GD1760@dumpdata.com>
References: <1292967460-15709-1-git-send-email-konrad.wilk@oracle.com>
 <1292967460-15709-5-git-send-email-konrad.wilk@oracle.com>
 <4D112A4B.5000503@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D112A4B.5000503@goop.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 21, 2010 at 02:29:31PM -0800, Jeremy Fitzhardinge wrote:
> On 12/21/2010 01:37 PM, Konrad Rzeszutek Wilk wrote:
> > This means that for PFNs (specifically: those in any E820 gaps
> > or non-RAM E820 regions) that have 1-1 mapping we set the
> > _PAGE_IOMAP flag.
> >
> > Later on we could remove the _PAGE_IOMAP code handling, but
> > for right now lets keep this in to not introduce any bisection
> > failures across this patchset.
> >
> > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > ---
> >  arch/x86/xen/mmu.c |    3 +++
> >  1 files changed, 3 insertions(+), 0 deletions(-)
> >
> > diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
> > index 4ba7e4e..bd02e7d 100644
> > --- a/arch/x86/xen/mmu.c
> > +++ b/arch/x86/xen/mmu.c
> > @@ -832,6 +832,9 @@ static pteval_t pte_pfn_to_mfn(pteval_t val)
> >  		pteval_t flags = val & PTE_FLAGS_MASK;
> >  		unsigned long mfn = pfn_to_mfn(pfn);
> >  
> > +		if (mfn == pfn)
> > +			flags |= _PAGE_IOMAP;
> 
> Why?  Does it really make sense to set _PAGE_IOMAP if they just happen
> to be the same value?

Yes. Without this, user applications, such as 'dmidecode' cannot get
data.

But I think with ditching a bunch of the _PAGE_IOMAP in the xen/mmu.c we can
remove this.

I would rather keep this patch as temporary scaffolding and when the
other set of patches is ready for the _PAGE_IOMAP, ditch this one.

> 
>     J
