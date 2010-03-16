Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740Ab0CPW24 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 18:28:56 -0400
Received: from sh.osrg.net ([192.16.179.4]:38235 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752470Ab0CPW2z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 18:28:55 -0400
Date: Wed, 17 Mar 2010 07:28:43 +0900
To: stern@rowland.harvard.edu
Cc: James.Bottomley@HansenPartnership.com, fujita.tomonori@lab.ntt.co.jp,
       linux-kernel@vger.kernel.org
Subject: Re: dma_sync_sg_for_cpu applied to a single scatterlist element
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <Pine.LNX.4.44L0.1003161022020.1329-100000@iolanthe.rowland.org>
References: <1268693985.2853.62.camel@mulgrave.site>
	<Pine.LNX.4.44L0.1003161022020.1329-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100317072827F.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 17 Mar 2010 07:28:44 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Mar 2010 10:30:47 -0400 (EDT)
Alan Stern <stern@rowland.harvard.edu> wrote:

> On Mon, 15 Mar 2010, James Bottomley wrote:
> 
> > On Mon, 2010-03-15 at 17:30 -0400, Alan Stern wrote:
> > > This is addressed to James Bottomley as he is the author of
> > > Documentation/DMA-API.txt, but anyone else who can contribute is
> > > invited to do so.
> > > 
> > > Suppose a scatter-gather transfer with multiple scatterlist elements
> > > has been mapped via dma_map_sg().  Is it then valid to call 
> > > dma_sync_sg_for_cpu() with the "sg" argument pointing to one of the 
> > > mapped scatterlist elements (not necessarily the first one) and the 
> > > "nelems" argument set to 1?
> > 
> > It's not the design of the API, but I'm guessing, given the way the API
> > works on most arch's that it will work.  However, if you just want a
> > single element sync'd, won't dma_sync_single_for_cpu do that
> > transparently (as in just feed in the address and length from the sg
> > list), without mucking with the sg API?
> 
> On Tue, 16 Mar 2010, FUJITA Tomonori wrote:
> 
> > As James said, probably it works. As long as passed scatterlist
> > elements points to mapped regions, it works.
> > 
> > However, I think that the latest DMA-API.txt makes it clear that only
> > dma_sync_single_for_{cpu|device} supports a partial sync. So it's not
> > recommended, I guess.
> 
> What the documentation actually says about the dma_sync_* functions is:
> 
> 	All the parameters must be the same as those passed into the 
> 	single mapping API.

It's true to dma_sync_sg_for_*. You can see there:

With the sync_single API, you can use dma_handle and size parameters
that aren't identical to those passed into the single mapping API to
do a partial sync.

dma_sync_single_for_* can do a partial sync but dma_sync_sg_for_*
doesn't support a partial sync.


> So it isn't clear that dma_sync_sg_for_cpu(dev, sg, 1, dir) can be used
> on a mapping created by dma_map_sg(dev, sg, n, dir),

You should not do (though it might work).

> and it isn't 
> clear that dma_sync_single_for_cpu() can be used on a mapping created 
> by dma_map_sg().

You should not do (though it might work).


> But if you guys say it will work, I'll go ahead and use
> dma_sync_single_for_cpu().
> 

Well, it's undocumented. It might work but might not.
