Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758041Ab0HOPjL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Aug 2010 11:39:11 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:35359 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757728Ab0HOPjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Aug 2010 11:39:08 -0400
Date: Sun, 15 Aug 2010 09:23:28 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: khc@pm.waw.pl, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org
Subject: Re: ARM: 2.6.3[45] PCI regression (IXP4xx and PXA?)
Message-ID: <20100815082328.GA12222@n2100.arm.linux.org.uk>
References: <20100813215413.GA21607@n2100.arm.linux.org.uk> <20100814181306U.fujita.tomonori@lab.ntt.co.jp> <20100814184605.GA1999@n2100.arm.linux.org.uk> <20100815144122O.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100815144122O.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 15, 2010 at 02:42:51PM +0900, FUJITA Tomonori wrote:
> On Sat, 14 Aug 2010 19:46:05 +0100
> Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> 
> > On Sat, Aug 14, 2010 at 06:30:37PM +0900, FUJITA Tomonori wrote:
> > > On Fri, 13 Aug 2010 22:54:13 +0100
> > > Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> > > >  This means that when dmabounce comes to allocate the replacement
> > > > buffer, it gets a buffer which won't be accessible to the DMA
> > > > controller
> > > 
> > > Really? looks like dmabounce does nothing for coherent memory that
> > > dma_alloc_coherent() allocates.
> > > 
> > > The following very hacky patch works?
> > 
> > So what happens if you use a driver which uses dma_alloc_coherent()
> > directly?  Should the driver really be passed memory which is
> > inaccessible to the device because its outside the host bridge PCI
> > window?
> 
> I'm not sure what you mean.
> 
> A driver which uses dma_alloc_coherent() directly should
> work. dma_alloc_coherent() allocates memory with GFP_DMA with that
> patch for dmabounce devices. So the driver gets the access-able
> memory.
> 
> The memory that dma_alloc_coherent() returns should be always
> consistent. We can't bounce it. All we can do is returning a memory
> that a device (and its bus) can access to.
> 
> Krzysztof, can you try the patch?

Why bother when we both agree that the patch is a dirty hack?

Come up with something cleaner first.
