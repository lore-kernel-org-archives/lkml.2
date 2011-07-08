Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683Ab1GHJrq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 05:47:46 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:33468 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751969Ab1GHJrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 05:47:45 -0400
Date: Fri, 8 Jul 2011 10:47:22 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Heechul Yun <heechul@illinois.edu>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "saeed.bishara@gmail.com" <saeed.bishara@gmail.com>
Subject: Re: [PATCHv2] remove unnecessary cache flush on v6 copypage
Message-ID: <20110708094722.GC16293@e102109-lin.cambridge.arm.com>
References: <20110707143019.GA16819@heechul-desktop>
 <20110708093542.GA4812@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110708093542.GA4812@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 08, 2011 at 10:35:42AM +0100, Russell King - ARM Linux wrote:
> On Thu, Jul 07, 2011 at 09:30:19AM -0500, Heechul Yun wrote:
> > ARM: mm: remove unnecessary cache flush on v6 copypage
> > 
> > Originally introduced to maintain coherency between icache and dcache
> > in v6 nonaliasing mode. This is now handled by __sync_icache_dcache since
> > c0177800, therefore unneceary in this function.  
> > 
> > Signed-off-by: Heechul Yun <heechul@illinois.edu>
> > Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> > --
> > arch/arm/mm/copypage-v6.c |    1 -
> >  1 files changed, 0 insertions(+), 1 deletions(-)
> > 
> > diff --git a/arch/arm/mm/copypage-v6.c b/arch/arm/mm/copypage-v6.c
> > index bdba6c6..63cca00 100644
> > --- a/arch/arm/mm/copypage-v6.c
> > +++ b/arch/arm/mm/copypage-v6.c
> > @@ -41,7 +41,6 @@ static void v6_copy_user_highpage_nonaliasing(struct page *to,
> >  	kfrom = kmap_atomic(from, KM_USER0);
> >  	kto = kmap_atomic(to, KM_USER1);
> >  	copy_page(kto, kfrom);
> > -	__cpuc_flush_dcache_area(kto, PAGE_SIZE);
> >  	kunmap_atomic(kto, KM_USER1);
> >  	kunmap_atomic(kfrom, KM_USER0);
> >  }
> 
> The above patch is fine (it has tabs preserved) but the version in the
> patch system has spaces instead (each space character has been replaced
> with a '.') and so doesn't apply:

Does your patch system now understand a From: line in the patch log (and
preserve the author)? I can upload the patch on Heechul's behalf.

-- 
Catalin
