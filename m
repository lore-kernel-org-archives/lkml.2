Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213Ab0GMIel (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 04:34:41 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37236 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752714Ab0GMIek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 04:34:40 -0400
Date: Tue, 13 Jul 2010 09:42:44 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: zpfeffer@codeaurora.org, joro@8bytes.org, dwalker@codeaurora.org,
        andi@firstfloor.org, randy.dunlap@oracle.com, mel@csn.ul.ie,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC 3/3] mm: iommu: The Virtual Contiguous Memory Manager
Message-ID: <20100713094244.7eb84f1b@lxorguk.ukuu.org.uk>
In-Reply-To: <20100713173028M.fujita.tomonori@lab.ntt.co.jp>
References: <4C3BFDD3.8040209@codeaurora.org>
	<20100713145852C.fujita.tomonori@lab.ntt.co.jp>
	<20100713092012.7c1fe53e@lxorguk.ukuu.org.uk>
	<20100713173028M.fujita.tomonori@lab.ntt.co.jp>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Jul 2010 17:30:43 +0900
FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> On Tue, 13 Jul 2010 09:20:12 +0100
> Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> 
> > > Why video4linux can't use the DMA API? Doing DMA with vmalloc'ed
> > > buffers is a thing that we should avoid (there are some exceptions
> > > like xfs though).
> > 
> > Vmalloc is about the only API for creating virtually linear memory areas.
> > The video stuff really needs that to avoid lots of horrible special cases
> > when doing buffer processing and the like.
> > 
> > Pretty much each driver using it has a pair of functions 'rvmalloc' and
> > 'rvfree' so given a proper "vmalloc_for_dma()" type interface can easily
> > be switched
> 
> We already have helper functions for DMA with vmap pages,
> flush_kernel_vmap_range and invalidate_kernel_vmap_range.

I'm not sure they help at all because the DMA user for these pages isn't
the video driver - it's the USB layer, and the USB layer isn't
specifically aware it is being passed vmap pages.

Alan
