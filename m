Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747Ab0HBPc7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 11:32:59 -0400
Received: from sh.osrg.net ([192.16.179.4]:47608 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753304Ab0HBPc5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 11:32:57 -0400
Date: Tue, 3 Aug 2010 00:26:36 +0900
To: linux@arm.linux.org.uk
Cc: fujita.tomonori@lab.ntt.co.jp, benh@kernel.crashing.org,
        dwalker@codeaurora.org, arnd@arndb.de, Joerg.Roedel@amd.com,
        linux-kernel@vger.kernel.org, stepanm@codeaurora.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] arm: msm: Add System MMU support.
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100802100419.GC30670@n2100.arm.linux.org.uk>
References: <20100802090326.GA30670@n2100.arm.linux.org.uk>
	<20100802181919J.fujita.tomonori@lab.ntt.co.jp>
	<20100802100419.GC30670@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100803002542M.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 03 Aug 2010 00:26:39 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Aug 2010 11:04:19 +0100
Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:

> On Mon, Aug 02, 2010 at 06:20:01PM +0900, FUJITA Tomonori wrote:
> > On Mon, 2 Aug 2010 10:03:26 +0100
> > Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> > 
> > > On Mon, Aug 02, 2010 at 05:30:26PM +0900, FUJITA Tomonori wrote:
> > > > ARM's iommu code (arch/plat-omap/include/plat/iommu.h) is a library to
> > > > simplify the IOMMU implementations. It could be useful for all the
> > > > iommu implementations.
> > > 
> > > ITYM OMAP's iommu code.
> > 
> > Yeah, I meant that we could extend it to make it useful for other
> > iommu implementations. At least, we could make something generic like
> > struct iommu_functions, I think. Then we can embed a generic iommu
> > structure into an iommu specific struct (like we do with inode).
> > 
> > The current iommu-api (include/linux/iommu.h) is just about domain and
> > mapping concept. We can implement it on the top of the above
> > infrastructure.
> > 
> > I'm still trying to figure out how the DMA-API can work well with
> > them.
> 
> I'm not sure it can in totality.  The DMA-API solves the host CPU <->
> device aspect of DMA support only.
> 
> However, there is another use case for IOMMUs, which is to allow two
> separate peripheral devices to communicate with each other via system
> memory.  As the streaming DMA-API involves the idea of buffer ownership
> (of a singular agent), it is unsuitable for this use case.
> 
> The coherent allocation part of the DMA-API also only deals with the
> idea of there being a singular DMA agent accessing the allocated buffer
> (in conjunction with the host CPU).

I don't have a clear idea what kinda API works well in the above case
yet.

But we have been talking about more bigger things? Not just about the
interface, how things work together.

- OMAP's iommu code is a library to simplify OMAP implementations.

- include/linux/iommu.h is an interface to IOMMUs for specific
  interfaces.

- the DMA API could access to IOMMUs internally.

IOMMU library provides generic iommu interfaces (a structure including
IOMMU implementation specific function pointers). KVM uses some of
them. Architectures could implement the DMA API on the top of some the
interfaces too.
