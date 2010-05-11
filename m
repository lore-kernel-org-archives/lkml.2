Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755629Ab0EKOjc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 10:39:32 -0400
Received: from sh.osrg.net ([192.16.179.4]:40793 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751640Ab0EKOja (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 10:39:30 -0400
Date: Tue, 11 May 2010 23:38:35 +0900
To: konrad.wilk@oracle.com
Cc: stern@rowland.harvard.edu, fujita.tomonori@lab.ntt.co.jp,
       alsa-devel@alsa-project.org, linux-usb@vger.kernel.org, tiwai@suse.de,
       gregkh@suse.de, clemens@ladisch.de, linux-kernel@vger.kernel.org,
       chrisw@sous-sol.org, iommu@lists.linux-foundation.org,
       andi@firstfloor.org, daniel@caiaq.de, pedrib@gmail.com,
       akpm@linux-foundation.org, dwmw2@infradead.org
Subject: Re: [alsa-devel] USB transfer_buffer allocations on 64bit systems
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100511142439.GA4898@phenom.dumpdata.com>
References: <20100511100637D.fujita.tomonori@lab.ntt.co.jp>
	<Pine.LNX.4.44L0.1005110956330.1834-100000@iolanthe.rowland.org>
	<20100511142439.GA4898@phenom.dumpdata.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100511233852B.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 11 May 2010 23:38:39 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 May 2010 10:24:40 -0400
Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:

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
> Is that address (urb->transfer_dma) the same as 'virt_to_phys(urb->transfer_buffer)'
> (if not, then SWIOTLB is being utilized) and is the dma_sync_* done on the
> urb->transfer_dma (to properly sync the data from the SWIOTLB to the
> transfer_buffer) before you start using the urb->transfer_buffer?

Or calling dma_unmap_single.

Can you tell me all the exact process of DMA that the usb core and the
driver do?
