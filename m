Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758293Ab0HOP4Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Aug 2010 11:56:16 -0400
Received: from sh.osrg.net ([192.16.179.4]:43798 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757839Ab0HOP4O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Aug 2010 11:56:14 -0400
Date: Mon, 16 Aug 2010 00:55:42 +0900
To: linux@arm.linux.org.uk
Cc: fujita.tomonori@lab.ntt.co.jp, khc@pm.waw.pl, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org
Subject: Re: ARM: 2.6.3[45] PCI regression (IXP4xx and PXA?)
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100815082328.GA12222@n2100.arm.linux.org.uk>
References: <20100814184605.GA1999@n2100.arm.linux.org.uk>
	<20100815144122O.fujita.tomonori@lab.ntt.co.jp>
	<20100815082328.GA12222@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100816005427V.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 16 Aug 2010 00:55:44 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 15 Aug 2010 09:23:28 +0100
Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:

> On Sun, Aug 15, 2010 at 02:42:51PM +0900, FUJITA Tomonori wrote:
> > On Sat, 14 Aug 2010 19:46:05 +0100
> > Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> > 
> > > On Sat, Aug 14, 2010 at 06:30:37PM +0900, FUJITA Tomonori wrote:
> > > > On Fri, 13 Aug 2010 22:54:13 +0100
> > > > Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> > > > >  This means that when dmabounce comes to allocate the replacement
> > > > > buffer, it gets a buffer which won't be accessible to the DMA
> > > > > controller
> > > > 
> > > > Really? looks like dmabounce does nothing for coherent memory that
> > > > dma_alloc_coherent() allocates.
> > > > 
> > > > The following very hacky patch works?
> > > 
> > > So what happens if you use a driver which uses dma_alloc_coherent()
> > > directly?  Should the driver really be passed memory which is
> > > inaccessible to the device because its outside the host bridge PCI
> > > window?
> > 
> > I'm not sure what you mean.
> > 
> > A driver which uses dma_alloc_coherent() directly should
> > work. dma_alloc_coherent() allocates memory with GFP_DMA with that
> > patch for dmabounce devices. So the driver gets the access-able
> > memory.
> > 
> > The memory that dma_alloc_coherent() returns should be always
> > consistent. We can't bounce it. All we can do is returning a memory
> > that a device (and its bus) can access to.
> > 
> > Krzysztof, can you try the patch?
> 
> Why bother when we both agree that the patch is a dirty hack?
> 
> Come up with something cleaner first.

Because this fix needs to go to stable trees too. A simple patch is
better even if it's hacky.

For example, we can unify dma_needs_bounce functions in arm with a
clean solution, I think. But dma_needs_bounce() was changed after
2.6.35 so it would be difficult to backport a clean solution.

btw, will we have more like this case? If so, I think that it's worth
having a generic solution for this case instead of having the arch
(arm and powerpc) specific solution.
