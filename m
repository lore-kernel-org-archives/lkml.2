Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369Ab0JYMDF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 08:03:05 -0400
Received: from sh.osrg.net ([192.16.179.4]:52478 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750916Ab0JYMDD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 08:03:03 -0400
Date: Mon, 25 Oct 2010 21:01:47 +0900
To: catalin.marinas@arm.com
Cc: arnd@arndb.de, fujita.tomonori@lab.ntt.co.jp,
        linux-arm-kernel@lists.infradead.org, Will.Deacon@arm.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 13/18] ARM: LPAE: ensure dma_addr_t is the same
 size as phys_addr_t
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1288006329.14756.13.camel@e102109-lin.cambridge.arm.com>
References: <20101025090046.25275.80297.stgit@e102109-lin.cambridge.arm.com>
	<201010251308.24063.arnd@arndb.de>
	<1288006329.14756.13.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20101025205524G.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 25 Oct 2010 21:01:47 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Oct 2010 12:32:09 +0100
Catalin Marinas <catalin.marinas@arm.com> wrote:

> On Mon, 2010-10-25 at 12:08 +0100, Arnd Bergmann wrote:
> > On Monday 25 October 2010, Catalin Marinas wrote:
> > > From: Will Deacon <will.deacon@arm.com>
> > >
> > > Now that phys_addr_t can be 64-bit on ARM, we must ensure that dma_addr_t
> > > is sufficiently large to hold physical addresses.
> > >
> > > This patch uses the types.h implementation in asm-generic to define the
> > > dma_addr_t type as the same width as phys_addr_t.
> > >
> > > Signed-off-by: Will Deacon <will.deacon@arm.com>
> > > Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> > 
> > This patch will become obsolete once the "unify dma_addr_t typedef"
> > series from Fujita Tomonori is upstream, you will instead have to set
> > CONFIG_ARCH_DMA_ADDR_T_64BIT.
> 
> Yes, I know this and it's on my list to fix once I update the patches to
> 2.6.37-rc1.

This patch also conflicts with the patchset removing dma64_addr_t (you
really don't need dma64_addr_t):

http://marc.info/?l=linux-arch&m=128685377524976&w=2

Both in -mm and I think Andrew will merge both
CONFIG_ARCH_DMA_ADDR_T_64BIT and dma64_addr_t patchset.

So how about dropping this patch and folding the following into your
18th patch. Then Andrew will not get the conflict and -rc1 works fine
for you.

diff --git a/arch/arm/mm/Kconfig b/arch/arm/mm/Kconfig
index f2205e7..0a01b7b 100644
--- a/arch/arm/mm/Kconfig
+++ b/arch/arm/mm/Kconfig
@@ -617,6 +617,9 @@ config ARM_LPAE
 config ARCH_PHYS_ADDR_T_64BIT
 	def_bool ARM_LPAE
 
+config ARCH_DMA_ADDR_T_64BIT
+	def_bool ARM_LPAE
+
 config ARM_THUMB
 	bool "Support Thumb user binaries"
 	depends on CPU_ARM720T || CPU_ARM740T || CPU_ARM920T || CPU_ARM922T || CPU_ARM925T || CPU_ARM926T || CPU_ARM940T || CPU_ARM946E || CPU_ARM1020 || CPU_ARM1020E || CPU_ARM1022 || CPU_ARM1026 || CPU_XSCALE || CPU_XSC3 || CPU_MOHAWK || CPU_V6 || CPU_V7 || CPU_FEROCEON




