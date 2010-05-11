Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757232Ab0EKO5M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 10:57:12 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:35506 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755974Ab0EKO5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 10:57:10 -0400
Date: Tue, 11 May 2010 10:57:07 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       USB list <linux-usb@vger.kernel.org>, <tiwai@suse.de>, <gregkh@suse.de>,
       <clemens@ladisch.de>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       <chrisw@sous-sol.org>, <iommu@lists.linux-foundation.org>,
       <andi@firstfloor.org>, <daniel@caiaq.de>, <pedrib@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, <dwmw2@infradead.org>
Subject: Re: [alsa-devel] USB transfer_buffer allocations on 64bit systems
In-Reply-To: <20100511142439.GA4898@phenom.dumpdata.com>
Message-ID: <Pine.LNX.4.44L0.1005111052260.1834-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 May 2010, Konrad Rzeszutek Wilk wrote:

> > > > Either the data isn't getting written to the buffer correctly or else
> > > > the buffer isn't getting sent to the device correctly.  Can anybody
> > > > suggest a means of determining which is the case?
> > > 
> > > I can't say anything about this log that including only DMA addresses.
> > > I'm not familiar with how the USB core does DMA stuff. And the USB
> > > stack design that the USB core does DMA stuff (allocating, mappings,
> > > etc) makes debugging DMA issues really difficult.
> > 
> > The DMA stuff is simple enough in this case.  The urb->transfer_buffer
> > address is passed to dma_map_single(), and the DMA address it returns
> > is stored in urb->transfer_dma.  Those are the two values printed out
> > by the debugging patch.
> 
> Is that address (urb->transfer_dma) the same as 
'virt_to_phys(urb->transfer_buffer)'

I don't know.  We didn't print out the value of
virt_to_phys(urb->transfer_buffer).  All I can say is that
urb->transfer_dma is the value returned by dma_map_single().

> (if not, then SWIOTLB is being utilized) and is the dma_sync_* done on the
> urb->transfer_dma (to properly sync the data from the SWIOTLB to the
> transfer_buffer) before you start using the urb->transfer_buffer?

There are no calls to any dma_sync_* routines.  Daniel will have to
check me on this, but I believe that urb->transfer_buffer is filled
before dma_map_single() is called and it isn't touched again until
after dma_unmap_single() (which occurs before urb's completion handler
is called).

Alan Stern

