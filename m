Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755621Ab0EJJVi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 05:21:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:44055 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753072Ab0EJJVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 05:21:35 -0400
Subject: Re: [alsa-devel] USB transfer_buffer allocations on 64bit systems
From: David Woodhouse <dwmw2@infradead.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: stern@rowland.harvard.edu, daniel@caiaq.de, clemens@ladisch.de,
       tiwai@suse.de, alsa-devel@alsa-project.org, gregkh@suse.de,
       konrad.wilk@oracle.com, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, chrisw@sous-sol.org,
       iommu@lists.linux-foundation.org, andi@firstfloor.org, pedrib@gmail.com,
       akpm@linux-foundation.org
In-Reply-To: <20100510115048E.fujita.tomonori@lab.ntt.co.jp>
References: <20100507102408.GM30801@buzzloop.caiaq.de>
	 <Pine.LNX.4.44L0.1005071048220.1804-100000@iolanthe.rowland.org>
	 <20100510115048E.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 10 May 2010 10:21:05 +0100
Message-ID: <1273483265.372.3383.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-10 at 11:50 +0900, FUJITA Tomonori wrote:
> On Fri, 7 May 2010 10:51:10 -0400 (EDT)
> Alan Stern <stern@rowland.harvard.edu> wrote:
> 
> > On Fri, 7 May 2010, Daniel Mack wrote:
> > 
> > > > At least the audio class and ua101 drivers don't do this and fill the
> > > > buffers before they are submitted.
> > > 
> > > Gnaa, you're right. I _thought_ my code does it the way I described, but
> > > what I wrote is how I _wanted_ to do it, not how it's currently done. I
> > > have a plan to change this in the future.
> > > 
> > > So unfortunately, that doesn't explain it either. Sorry for the noise.
> > 
> > At one point we tried an experiment, printing out the buffer and DMA 
> > addresses.  I don't recall seeing anything obviously wrong, but if an 
> > IOMMU was in use then that might not mean anything.  Is it possible 
> > that the IOMMU mappings sometimes get messed up for addresses above 4 
> > GB?
> 
> You mean that an IOMMU could allocate an address above 4GB wrongly? If
> so, IIRC, all the IOMMU implementations use dev->dma_mask and
> dev->coherent_dma_mask properly. And the DMA address space of the
> majority of IOMMUs are limited less than 4GB.

The Intel IOMMU code will use dev->dma_mask and dev->coherent_dma_mask
properly. It is not limited to 4GiB, but it will tend to give virtual
DMA addresses below 4GiB even when a device is capable of more; it'll
only give out higher addresses when the address space below 4GiB is
exhausted.

-- 
dwmw2

