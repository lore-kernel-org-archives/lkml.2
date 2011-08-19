Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726Ab1HSLsB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 07:48:01 -0400
Received: from aaar.vm.bytemark.co.uk ([80.68.92.230]:38757 "EHLO
	aaar.vm.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753400Ab1HSLr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 07:47:59 -0400
From: Ian Campbell <ijc@hellion.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "tim@xen.org" <tim@xen.org>
In-Reply-To: <20110819111054.GC6558@e102109-lin.cambridge.arm.com>
References: <1312988619-16804-1-git-send-email-catalin.marinas@arm.com>
	 <1312988619-16804-10-git-send-email-catalin.marinas@arm.com>
	 <1313749557.5010.345.camel@zakaz.uk.xensource.com>
	 <20110819111054.GC6558@e102109-lin.cambridge.arm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 19 Aug 2011 12:47:44 +0100
Message-ID: <1313754464.5010.348.camel@zakaz.uk.xensource.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 62.200.22.2
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [PATCH v7 09/16] ARM: LPAE: MMU setup for the 3-level page
 table format
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-08-19 at 12:10 +0100, Catalin Marinas wrote:
> 
> > > + */
> > > +ENTRY(cpu_v7_set_pte_ext)
> > > +#ifdef CONFIG_MMU
> > > +       tst     r2, #L_PTE_PRESENT
> > > +       beq     1f
> > > +       tst     r3, #1 << (55 - 32)             @ L_PTE_DIRTY
> > > +       orreq   r2, #L_PTE_RDONLY
> > > +1:     strd    r2, r3, [r0]
> > 
> > AIUI this 64-bit store is not atomic. Is there something about the
> ARM
> > architecture which would prevent the MMU prefetching the half
> written
> > entry and caching it in the TLB?
> 
> CPU implementations that include LPAE guarantee the atomicity of a
> double-word store (STRD) if the alignment is correct. 

Ah, I was looking at the standard v7 docs and not the LPAE extensions, I
see it now.

Thanks,
Ian.

-- 
Ian Campbell

The disks are getting full; purge a file today.

