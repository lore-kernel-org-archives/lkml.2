Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753061Ab1HSLLU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 07:11:20 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:33849 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752343Ab1HSLLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 07:11:19 -0400
Date: Fri, 19 Aug 2011 12:10:54 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Ian Campbell <ijc@hellion.org.uk>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "tim@xen.org" <tim@xen.org>
Subject: Re: [PATCH v7 09/16] ARM: LPAE: MMU setup for the 3-level page
 table format
Message-ID: <20110819111054.GC6558@e102109-lin.cambridge.arm.com>
References: <1312988619-16804-1-git-send-email-catalin.marinas@arm.com>
 <1312988619-16804-10-git-send-email-catalin.marinas@arm.com>
 <1313749557.5010.345.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313749557.5010.345.camel@zakaz.uk.xensource.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 19, 2011 at 11:25:57AM +0100, Ian Campbell wrote:
> On Wed, 2011-08-10 at 16:03 +0100, Catalin Marinas wrote:
> > +/*
> > + *     cpu_v7_set_pte_ext(ptep, pte)
> > + *
> > + *     Set a level 2 translation table entry.
> > + *
> > + *     - ptep  - pointer to level 2 translation table entry
> > + *               (hardware version is stored at +2048 bytes)
> 
> +2048 thing not true for LPAE?
> 
> > + *     - pte   - PTE value to store
> > + *     - ext   - value for extended PTE bits
> 
> "ext" is not actually present/used in this variant, rather pte is split
> between r1 and r2?

Yes, you are right, the comments have just been copied from proc-v7.S.
I'll go through them again make sure they are still valid.

> > + */
> > +ENTRY(cpu_v7_set_pte_ext)
> > +#ifdef CONFIG_MMU
> > +       tst     r2, #L_PTE_PRESENT
> > +       beq     1f
> > +       tst     r3, #1 << (55 - 32)             @ L_PTE_DIRTY
> > +       orreq   r2, #L_PTE_RDONLY
> > +1:     strd    r2, r3, [r0]
> 
> AIUI this 64-bit store is not atomic. Is there something about the ARM
> architecture which would prevent the MMU prefetching the half written
> entry and caching it in the TLB?

CPU implementations that include LPAE guarantee the atomicity of a
double-word store (STRD) if the alignment is correct.

Thanks.

-- 
Catalin
