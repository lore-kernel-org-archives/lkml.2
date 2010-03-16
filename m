Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966303Ab0CPOau (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 10:30:50 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:56526 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752678Ab0CPOat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 10:30:49 -0400
Date: Tue, 16 Mar 2010 10:30:47 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
cc: Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: dma_sync_sg_for_cpu applied to a single scatterlist element
In-Reply-To: <1268693985.2853.62.camel@mulgrave.site>
Message-ID: <Pine.LNX.4.44L0.1003161022020.1329-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Mar 2010, James Bottomley wrote:

> On Mon, 2010-03-15 at 17:30 -0400, Alan Stern wrote:
> > This is addressed to James Bottomley as he is the author of
> > Documentation/DMA-API.txt, but anyone else who can contribute is
> > invited to do so.
> > 
> > Suppose a scatter-gather transfer with multiple scatterlist elements
> > has been mapped via dma_map_sg().  Is it then valid to call 
> > dma_sync_sg_for_cpu() with the "sg" argument pointing to one of the 
> > mapped scatterlist elements (not necessarily the first one) and the 
> > "nelems" argument set to 1?
> 
> It's not the design of the API, but I'm guessing, given the way the API
> works on most arch's that it will work.  However, if you just want a
> single element sync'd, won't dma_sync_single_for_cpu do that
> transparently (as in just feed in the address and length from the sg
> list), without mucking with the sg API?

On Tue, 16 Mar 2010, FUJITA Tomonori wrote:

> As James said, probably it works. As long as passed scatterlist
> elements points to mapped regions, it works.
> 
> However, I think that the latest DMA-API.txt makes it clear that only
> dma_sync_single_for_{cpu|device} supports a partial sync. So it's not
> recommended, I guess.

What the documentation actually says about the dma_sync_* functions is:

	All the parameters must be the same as those passed into the 
	single mapping API.

So it isn't clear that dma_sync_sg_for_cpu(dev, sg, 1, dir) can be used
on a mapping created by dma_map_sg(dev, sg, n, dir), and it isn't 
clear that dma_sync_single_for_cpu() can be used on a mapping created 
by dma_map_sg().

But if you guys say it will work, I'll go ahead and use
dma_sync_single_for_cpu().

Thanks,

Alan Stern

