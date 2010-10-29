Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761503Ab0J2Rhk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 13:37:40 -0400
Received: from smtp.citrix.com ([66.165.176.89]:43294 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758052Ab0J2Rhi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 13:37:38 -0400
X-IronPort-AV: E=Sophos;i="4.58,260,1286164800"; 
   d="scan'208";a="10873154"
Subject: Re: [PATCH] xen: correct size of level2_kernel_pgt
From: Ian Campbell <Ian.Campbell@eu.citrix.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4CCB02DC.1010307@goop.org>
References: <1288367779-24001-1-git-send-email-ian.campbell@citrix.com>
	 <4CCB02DC.1010307@goop.org>
Content-Type: text/plain; charset="ISO-8859-1"
Organization: Citrix Systems, Inc.
Date: Fri, 29 Oct 2010 18:37:35 +0100
Message-ID: <1288373855.8069.27.camel@localhost.localdomain>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-29 at 18:22 +0100, Jeremy Fitzhardinge wrote:
> On 10/29/2010 08:56 AM, Ian Campbell wrote:
> > sizeof(pmd_t *) is 4 bytes on PAE leading to an allocation of only
> > 2048 bytes. The correct size is sizeof(pmd_t) giving us a full page
> > allocation.
> >
> > Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> > Cc: Jeremy Fitzhardinge <jeremy@goop.org>
> > ---
> >
> > Applies to mainline since 2.6.36 and to xen.git 2.6.32 based trees
> 
> This is just for 2.6.37?

2.6.36.stable too, I think. I added stable@kernel.org to my patch header
but didn't "guilt refresh" so it didn't show up here.

Ian.

> 
>     J
> 
> >  arch/x86/xen/mmu.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >
> > diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
> > index c237b81..21ed8d7 100644
> > --- a/arch/x86/xen/mmu.c
> > +++ b/arch/x86/xen/mmu.c
> > @@ -2126,7 +2126,7 @@ __init pgd_t *xen_setup_kernel_pagetable(pgd_t *pgd,
> >  {
> >  	pmd_t *kernel_pmd;
> >  
> > -	level2_kernel_pgt = extend_brk(sizeof(pmd_t *) * PTRS_PER_PMD, PAGE_SIZE);
> > +	level2_kernel_pgt = extend_brk(sizeof(pmd_t) * PTRS_PER_PMD, PAGE_SIZE);
> >  
> >  	max_pfn_mapped = PFN_DOWN(__pa(xen_start_info->pt_base) +
> >  				  xen_start_info->nr_pt_frames * PAGE_SIZE +
> 


