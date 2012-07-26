Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219Ab2GZQdZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 12:33:25 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:40199 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601Ab2GZQdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 12:33:24 -0400
Date: Thu, 26 Jul 2012 12:24:28 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ian Campbell <Ian.Campbell@citrix.com>
Cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH] xen/p2m: Check __brk_limit before allocating.
Message-ID: <20120726162428.GA9222@phenom.dumpdata.com>
References: <1343161413-11077-1-git-send-email-konrad.wilk@oracle.com>
 <1343289182.8016.38.camel@dagon.hellion.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343289182.8016.38.camel@dagon.hellion.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 26, 2012 at 08:53:02AM +0100, Ian Campbell wrote:
> On Tue, 2012-07-24 at 16:23 -0400, Konrad Rzeszutek Wilk wrote:
> > diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
> > index 64effdc..b5bb26c 100644
> > --- a/arch/x86/xen/p2m.c
> > +++ b/arch/x86/xen/p2m.c
> > @@ -498,7 +498,14 @@ static bool alloc_p2m(unsigned long pfn)
> >  
> >  	return true;
> >  }
> > -
> > +#include <asm/sections.h>
> > +bool __init can_extend_brk()
> > +{
> > +	/* Always reserve one for the DMI extend_brk call. */
> 
> That seems a bit fragile, what if someone adds something else or the
> link order changes etc?
> 
> Can't we just have a variant of extend_brk which returns NULL instead of
> BUG_ON and do error checking?
> 
> Or even just change extend_brk and push the BUG_ONs out to the callers
> -- there aren't that many of them.

Good thinking. Let me redo it that way and see get x86 folks input.
> 
> Ian.
> -- 
> Ian Campbell
> 
> 
> Most people in this society who aren't actively mad are, at best,
> reformed or potential lunatics.
> 		-- Susan Sontag
> 
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel
