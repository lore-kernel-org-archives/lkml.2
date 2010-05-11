Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758241Ab0EKO2M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 10:28:12 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:43509 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757967Ab0EKO2J (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 11 May 2010 10:28:09 -0400
Date: Tue, 11 May 2010 10:24:40 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       alsa-devel@alsa-project.org, linux-usb@vger.kernel.org, tiwai@suse.de,
       gregkh@suse.de, clemens@ladisch.de, linux-kernel@vger.kernel.org,
       chrisw@sous-sol.org, iommu@lists.linux-foundation.org,
       andi@firstfloor.org, daniel@caiaq.de, pedrib@gmail.com,
       akpm@linux-foundation.org, dwmw2@infradead.org
Subject: Re: [alsa-devel] USB transfer_buffer allocations on 64bit systems
Message-ID: <20100511142439.GA4898@phenom.dumpdata.com>
References: <20100511100637D.fujita.tomonori@lab.ntt.co.jp> <Pine.LNX.4.44L0.1005110956330.1834-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1005110956330.1834-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090208.4BE96934.0127:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > Either the data isn't getting written to the buffer correctly or else
> > > the buffer isn't getting sent to the device correctly.  Can anybody
> > > suggest a means of determining which is the case?
> > 
> > I can't say anything about this log that including only DMA addresses.
> > I'm not familiar with how the USB core does DMA stuff. And the USB
> > stack design that the USB core does DMA stuff (allocating, mappings,
> > etc) makes debugging DMA issues really difficult.
> 
> The DMA stuff is simple enough in this case.  The urb->transfer_buffer
> address is passed to dma_map_single(), and the DMA address it returns
> is stored in urb->transfer_dma.  Those are the two values printed out
> by the debugging patch.

Is that address (urb->transfer_dma) the same as 'virt_to_phys(urb->transfer_buffer)'
(if not, then SWIOTLB is being utilized) and is the dma_sync_* done on the
urb->transfer_dma (to properly sync the data from the SWIOTLB to the
transfer_buffer) before you start using the urb->transfer_buffer?
