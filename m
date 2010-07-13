Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753780Ab0GMIql (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 04:46:41 -0400
Received: from sh.osrg.net ([192.16.179.4]:39418 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752829Ab0GMIqk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 04:46:40 -0400
Date: Tue, 13 Jul 2010 17:45:39 +0900
To: alan@lxorguk.ukuu.org.uk
Cc: fujita.tomonori@lab.ntt.co.jp, zpfeffer@codeaurora.org, joro@8bytes.org,
        dwalker@codeaurora.org, andi@firstfloor.org, randy.dunlap@oracle.com,
        mel@csn.ul.ie, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC 3/3] mm: iommu: The Virtual Contiguous Memory Manager
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100713094244.7eb84f1b@lxorguk.ukuu.org.uk>
References: <20100713092012.7c1fe53e@lxorguk.ukuu.org.uk>
	<20100713173028M.fujita.tomonori@lab.ntt.co.jp>
	<20100713094244.7eb84f1b@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100713174519D.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 13 Jul 2010 17:45:43 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Jul 2010 09:42:44 +0100
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> On Tue, 13 Jul 2010 17:30:43 +0900
> FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> 
> > On Tue, 13 Jul 2010 09:20:12 +0100
> > Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > 
> > > > Why video4linux can't use the DMA API? Doing DMA with vmalloc'ed
> > > > buffers is a thing that we should avoid (there are some exceptions
> > > > like xfs though).
> > > 
> > > Vmalloc is about the only API for creating virtually linear memory areas.
> > > The video stuff really needs that to avoid lots of horrible special cases
> > > when doing buffer processing and the like.
> > > 
> > > Pretty much each driver using it has a pair of functions 'rvmalloc' and
> > > 'rvfree' so given a proper "vmalloc_for_dma()" type interface can easily
> > > be switched
> > 
> > We already have helper functions for DMA with vmap pages,
> > flush_kernel_vmap_range and invalidate_kernel_vmap_range.
> 
> I'm not sure they help at all because the DMA user for these pages isn't
> the video driver - it's the USB layer, and the USB layer isn't
> specifically aware it is being passed vmap pages.

Drivers can tell the USB layer that these are vmapped buffers? Adding
something to struct urb? I might be totally wrong since I don't know
anything about the USB layer.
