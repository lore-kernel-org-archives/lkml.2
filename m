Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923Ab0CROOB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 10:14:01 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:50532 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753871Ab0CROOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 10:14:00 -0400
Date: Thu, 18 Mar 2010 10:13:59 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
cc: James.Bottomley@HansenPartnership.com, <linux-kernel@vger.kernel.org>
Subject: Re: dma_sync_sg_for_cpu applied to a single scatterlist element
In-Reply-To: <20100318104619S.fujita.tomonori@lab.ntt.co.jp>
Message-ID: <Pine.LNX.4.44L0.1003181013260.1665-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Mar 2010, FUJITA Tomonori wrote:

> On Wed, 17 Mar 2010 11:22:01 -0400 (EDT)
> Alan Stern <stern@rowland.harvard.edu> wrote:
> 
> > Here's the situation.  The USB controller drivers don't all support
> > scatter-gather operation.  So there's a library routine in the USB core
> > which calls dma_map_sg() and then creates a separate I/O request for
> > each scatterlist element.  The driver can process these requests one at
> > a time, and when they are all finished the library routine calls
> > dma_unmap_sg().
> > 
> > However...  For tracing purposes (usbmon -- like tcpdump but for USB),
> > we may need to copy the data from each I/O request's transfer buffer.  
> > Unfortunately, this copying is done as each request is submitted (for 
> > output) or as it completes (for input), at which times the buffers are 
> > all mapped for DMA.  That's the problem.
> > 
> > Would we be better off not using dma_map_sg() at all in this situation?
> > We could map each scatterlist buffer individually with dma_map_single()
> > as the request is submitted and then unmap the buffer when the request
> > completes, just like with non-sg transfers; then the problem wouldn't
> > arise.
> > 
> > Would there be any significant penalty for doing this?  I realize it
> > would prevent adjacent buffers from getting coalesced, but that's
> > probably okay.  Any other reason not to?
> 
> No reason. About merging adjacent buffers, there are few IOMMU
> implementations that do. The recent IOMMU implementations such as VT-d
> and AMD IOMMU don't.
> 
> If drivers don't support scatter-gather operation, they had better use
> dma_map_page() instead of forging scatter-gather lists and playing
> with dma_map_sg().

Okay, I'll handle it that way.  Thanks for the advice.

Alan Stern

