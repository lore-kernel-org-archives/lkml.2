Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755712Ab1KHQ7h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 11:59:37 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:61996 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752802Ab1KHQ7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 11:59:35 -0500
Date: Tue, 8 Nov 2011 16:59:05 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>
Subject: Re: [PATCH v8 15/16] ARM: LPAE: add support for ATAG_MEM64
Message-ID: <20111108165905.GF10506@arm.com>
References: <1320682618-1182-1-git-send-email-catalin.marinas@arm.com>
 <1320682618-1182-16-git-send-email-catalin.marinas@arm.com>
 <4EB95ECB.8060905@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EB95ECB.8060905@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 08, 2011 at 04:54:35PM +0000, Stephen Boyd wrote:
> On 11/7/2011 8:16 AM, Catalin Marinas wrote:
> > diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
> > index 7e7977a..223af71 100644
> > --- a/arch/arm/kernel/setup.c
> > +++ b/arch/arm/kernel/setup.c
> > @@ -638,6 +638,29 @@ static int __init parse_tag_mem32(const struct tag *tag)
> >  
> >  __tagtable(ATAG_MEM, parse_tag_mem32);
> >  
> > +static int __init parse_tag_mem64(const struct tag *tag)
> > +{
> > +	/* We only use 32-bits for the size. */
> > +	unsigned long size;
> > +	phys_addr_t start, end;
> > +
> > +	start = tag->u.mem64.start;
> > +	size = tag->u.mem64.size;
> > +	end = start + size;
> > +
> > +	/* Ensure that the memory region is in range. */
> > +	if (end & ~PHYS_MASK)
> > +		pr_warning("Ignoring out-of-range mem64 tag (%.8llx-%.8llx)\n",
> 
> Can you add 0x (or #) here so we can see the 0x hex part?

There are some inconsistencies across the kernel, we just used the
printk format found in sanity_check_meminfo(). I don't have a problem
with changing this, though maybe some separate clean-up patch would be
better.

-- 
Catalin
