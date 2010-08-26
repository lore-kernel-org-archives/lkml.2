Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752576Ab0HZR5i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 13:57:38 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:57139 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152Ab0HZR5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 13:57:35 -0400
Date: Thu, 26 Aug 2010 18:57:19 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: benh@kernel.crashing.org, khc@pm.waw.pl, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: ARM: 2.6.3[45] PCI regression (IXP4xx and PXA?)
Message-ID: <20100826175719.GC13224@n2100.arm.linux.org.uk>
References: <20100819234835Y.fujita.tomonori@lab.ntt.co.jp> <1282254713.22370.368.camel@pasglop> <20100826205344E.fujita.tomonori@lab.ntt.co.jp> <20100826225352S.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100826225352S.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 26, 2010 at 10:54:39PM +0900, FUJITA Tomonori wrote:
> On Thu, 26 Aug 2010 20:55:09 +0900
> FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> 
> > On Fri, 20 Aug 2010 07:51:52 +1000
> > Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
> > 
> > > On Thu, 2010-08-19 at 23:50 +0900, FUJITA Tomonori wrote:
> > > > 
> > > > You mean that you like to permit architectures to modify
> > > > dev->coherent_dma_mask behind a device? If so, I'm against it because
> > > > it means dev->coherent_dma_mask has two meanings. That's confusing.
> > > 
> > > No it's not. It has one and only one meaning which is the mask defining
> > > where the coherent memory can come from for that device. Nobody cares if
> > > the device can do more and has been "clipped" at set_coherent_dma_mask()
> > > time by the bus. This is not useful information.
> > 
> > Ok.
> 
> btw, I'm still not sure, letting architectures to clip the dma mask
> (and coherent mask) behind a driver is correct by defintion of the DMA
> API (it's not a real problem).
> 
> DMA-API.txt defines dma_set_mask is "checks to see if the mask is
> possible and update the device parameters if it is". It means that
> architectures can't clip the mask behind a driver, I think.
> 
> Lots of drivers do something like:
> 
> if (dma_set_mask(dev, DMA_BIT_MASK(64)))
>         if (dma_set_mask(dev, DMA_BIT_MASK(32)))
> 
> What arm does is accepting whatever dma mask and setting the clipped
> mask behind a driver. If we use this sementics (archs are free to clip
> the mask), drivers don't need the second dma_set_mask call. And the
> driver wrongly assumes that it successfully set 64bit dma mask (and
> possibly set the hardware to 64bit dma mode needlessly).

Ok, in that case lets disable all PCI drivers which do this on IXP4xx
then, because they obviously can't cope with the 64MB window that this
platform has.

Clearly they need to be rewritten such that they can cope with this,
irrespective of the fact that they've worked for ages with the current
solution.
