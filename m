Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751928Ab0HSIwZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 04:52:25 -0400
Received: from sh.osrg.net ([192.16.179.4]:39402 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750927Ab0HSIwX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 04:52:23 -0400
Date: Thu, 19 Aug 2010 17:51:51 +0900
To: khc@pm.waw.pl
Cc: fujita.tomonori@lab.ntt.co.jp, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: ARM: 2.6.3[45] PCI regression (IXP4xx and PXA?)
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <m3vd7agmqa.fsf@intrepid.localdomain>
References: <20100813215413.GA21607@n2100.arm.linux.org.uk>
	<20100814181306U.fujita.tomonori@lab.ntt.co.jp>
	<m3vd7agmqa.fsf@intrepid.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100819175024W.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 19 Aug 2010 17:51:51 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Aug 2010 01:29:49 +0200
Krzysztof Halasa <khc@pm.waw.pl> wrote:

> Hi,
> 
> FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> writes:
> 
> > A long solution would be having two dma_mask for a device and a
> > bus. We also need something to represent a DMA-capable range instead
> > of the dma mask.
> >
> > --- a/arch/arm/mm/dma-mapping.c
> > +++ b/arch/arm/mm/dma-mapping.c
> > @@ -77,6 +77,11 @@ static struct page *__dma_alloc_buffer(struct device *dev, size_t size, gfp_t gf
> >  	if (mask < 0xffffffffULL)
> >  		gfp |= GFP_DMA;
> >  
> > +#ifdef CONFIG_DMABOUNCE
> > +	if (dev->archdata.dmabounce)
> > +		gfp |= GFP_DMA;
> > +#endif
> > +
> >  	page = alloc_pages(gfp, order);
> >  	if (!page)
> >  		return NULL;
> 
> This patch fixes the problem on my IXP425.

Thanks a lot!

I'll re-send the patch in the proper format. Can you send it to
mainline for 2.6.36?

I'll work on the proper solution for this issue for 2.6.37.
