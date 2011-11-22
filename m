Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756310Ab1KVJ6z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 04:58:55 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:38538 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751167Ab1KVJ6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 04:58:54 -0500
Date: Tue, 22 Nov 2011 09:58:45 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Russell King <rmk@arm.linux.org.uk>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: Re: linux-next: manual merge of the arm-lpae tree with the arm tree
Message-ID: <20111122095845.GC31064@arm.com>
References: <20111122120358.aa2cefdcdace9a98acafd4b9@canb.auug.org.au>
 <20111122081317.GB22232@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111122081317.GB22232@flint.arm.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 08:13:17AM +0000, Russell King wrote:
> On Tue, Nov 22, 2011 at 12:03:58PM +1100, Stephen Rothwell wrote:
> > diff --cc arch/arm/mm/ioremap.c
> > index 12c7ad2,d1f78ba..0000000
> > --- a/arch/arm/mm/ioremap.c
> > +++ b/arch/arm/mm/ioremap.c
> > @@@ -194,7 -208,14 +202,8 @@@ void __iomem * __arm_ioremap_pfn_caller
> >   	 */
> >   	if (pfn >= 0x100000 && (__pfn_to_phys(pfn) & ~SUPERSECTION_MASK))
> >   		return NULL;
> > + #endif
> >   
> >  -	/*
> >  -	 * Don't allow RAM to be mapped - this causes problems with ARMv6+
> >  -	 */
> >  -	if (WARN_ON(pfn_valid(pfn)))
> >  -		return NULL;
> >  -
> 
> This certainly is not correct - if Catalin's lpae tree is removing this
> then that needs to be fixed.

No, my patch just adds the #endif. The combined diff above means that
WARN_ON line above is only found in my version of ioremap.c (as my patch
doesn't touch that line). The "if (WARN_ON))" block was removed in the
"generic ioremap optimisation" patch and Stephen also removed it in the
resulting ioremap.c after fixing the conflict.

-- 
Catalin
