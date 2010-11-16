Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757676Ab0KPTeT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 14:34:19 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:51771 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757605Ab0KPTeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 14:34:14 -0500
Date: Tue, 16 Nov 2010 19:33:35 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 15/20] ARM: LPAE: use phys_addr_t instead of
	unsigned long for physical addresses
Message-ID: <20101116193335.GD21926@n2100.arm.linux.org.uk>
References: <1289842829-3027-1-git-send-email-catalin.marinas@arm.com> <1289842829-3027-16-git-send-email-catalin.marinas@arm.com> <4CE2D811.50701@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CE2D811.50701@codeaurora.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 11:14:25AM -0800, Stephen Boyd wrote:
> On 11/15/2010 09:40 AM, Catalin Marinas wrote:
> > @@ -188,21 +189,21 @@
> >   * translation for translating DMA addresses.  Use the driver
> >   * DMA support - see dma-mapping.h.
> >   */
> > -static inline unsigned long virt_to_phys(void *x)
> > +static inline phys_addr_t virt_to_phys(void *x)
> >  {
> >  	return __virt_to_phys((unsigned long)(x));
> >  }
> 
> As you're already in the area can you mark the argument to
> virt_to_phys() as const? I ran into a compiler warning due to that the
> other day.

It may make sense to mark it const volatile, as that's the most
permissive set of attributes possible (iow, it'll accept any pointer
without warning.)  However, might be an idea to check what other
arches do.
