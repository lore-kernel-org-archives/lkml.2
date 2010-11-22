Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779Ab0KVNcd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 08:32:33 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:54783 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734Ab0KVNca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 08:32:30 -0500
Date: Mon, 22 Nov 2010 13:32:16 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 11/20] ARM: LPAE: Add fault handling support
Message-ID: <20101122133216.GI31227@n2100.arm.linux.org.uk>
References: <1289584840-18097-1-git-send-email-catalin.marinas@arm.com> <1289584840-18097-12-git-send-email-catalin.marinas@arm.com> <20101122131546.GG31227@n2100.arm.linux.org.uk> <1290431967.29754.11.camel@e102109-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290431967.29754.11.camel@e102109-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 22, 2010 at 01:19:27PM +0000, Catalin Marinas wrote:
> On Mon, 2010-11-22 at 13:15 +0000, Russell King - ARM Linux wrote:
> > On Fri, Nov 12, 2010 at 06:00:31PM +0000, Catalin Marinas wrote:
> > > @@ -108,7 +113,9 @@ void show_pte(struct mm_struct *mm, unsigned long addr)
> > > 
> > >               pte = pte_offset_map(pmd, addr);
> > >               printk(", *pte=%08lx", pte_val(*pte));
> > > +#ifndef CONFIG_ARM_LPAE
> > >               printk(", *ppte=%08lx", pte_val(pte[-LINUX_PTE_OFFSET]));
> > > +#endif
> > 
> > This is an unrelated change - should it be in a different patch?
> 
> It was intended to be in this patch as I couldn't find a better place.
> This patch sorts out the fault handling (and error reporting) for LPAE
> and we don't need the additional printk here.

It doesn't sort the fault error reporting actually.  With pte_val()
returning u64 constants on LPAE, all the above printk's using %08lx will
issue warnings.

Also, as one of your previous patches changed the non-LPAE stuff to use
u32, which is 'unsigned int', %08lx is wrong for them too, and will cause
the compiler to spit out warnings.

I can only assume this patch hasn't been build-tested, or maybe it has
but the warnings ignored?

It seems a larger patch is required here - and as such might as well
become a separate "fix fault reporting" patch.
