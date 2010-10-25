Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720Ab0JYMbX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 08:31:23 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:58900 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751475Ab0JYMbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 08:31:22 -0400
Subject: Re: [RFC PATCH 13/18] ARM: LPAE: ensure dma_addr_t is the same
 size as phys_addr_t
From: Catalin Marinas <catalin.marinas@arm.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: arnd@arndb.de, linux-arm-kernel@lists.infradead.org,
        Will Deacon <Will.Deacon@arm.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20101025205524G.fujita.tomonori@lab.ntt.co.jp>
References: <20101025090046.25275.80297.stgit@e102109-lin.cambridge.arm.com>
	 <201010251308.24063.arnd@arndb.de>
	 <1288006329.14756.13.camel@e102109-lin.cambridge.arm.com>
	 <20101025205524G.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset="UTF-8"
Organization: ARM Limited
Date: Mon, 25 Oct 2010 13:31:13 +0100
Message-ID: <1288009873.14756.51.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Oct 2010 12:31:13.0580 (UTC) FILETIME=[83103EC0:01CB7440]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-25 at 13:01 +0100, FUJITA Tomonori wrote:
> On Mon, 25 Oct 2010 12:32:09 +0100
> Catalin Marinas <catalin.marinas@arm.com> wrote:
> 
> > On Mon, 2010-10-25 at 12:08 +0100, Arnd Bergmann wrote:
> > > On Monday 25 October 2010, Catalin Marinas wrote:
> > > > From: Will Deacon <will.deacon@arm.com>
> > > >
> > > > Now that phys_addr_t can be 64-bit on ARM, we must ensure that dma_addr_t
> > > > is sufficiently large to hold physical addresses.
> > > >
> > > > This patch uses the types.h implementation in asm-generic to define the
> > > > dma_addr_t type as the same width as phys_addr_t.
> > > >
> > > > Signed-off-by: Will Deacon <will.deacon@arm.com>
> > > > Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> > >
> > > This patch will become obsolete once the "unify dma_addr_t typedef"
> > > series from Fujita Tomonori is upstream, you will instead have to set
> > > CONFIG_ARCH_DMA_ADDR_T_64BIT.
> >
> > Yes, I know this and it's on my list to fix once I update the patches to
> > 2.6.37-rc1.
> 
> This patch also conflicts with the patchset removing dma64_addr_t (you
> really don't need dma64_addr_t):
> 
> http://marc.info/?l=linux-arch&m=128685377524976&w=2
> 
> Both in -mm and I think Andrew will merge both
> CONFIG_ARCH_DMA_ADDR_T_64BIT and dma64_addr_t patchset.
> 
> So how about dropping this patch and folding the following into your
> 18th patch. Then Andrew will not get the conflict and -rc1 works fine
> for you.

Yes, that's the plan, I was just waiting for -rc1 to rebase my patches
(given the loooong review process on the ARM list, I don't expect the
LPAE patches to be merged any time soon :)).

Thanks,

Catalin


