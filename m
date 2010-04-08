Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758576Ab0DHHas (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 03:30:48 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:36237 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758436Ab0DHHaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 03:30:46 -0400
Date: Thu, 8 Apr 2010 09:30:41 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Robert Hancock <hancockrwd@gmail.com>, linux-kernel@vger.kernel.org,
       Pedro Ribeiro <pedrib@gmail.com>, akpm@linux-foundation.org,
       Greg KH <gregkh@suse.de>, alsa-devel@alsa-project.org,
       linux-usb@vger.kernel.org
Subject: Re: USB transfer_buffer allocations on 64bit systems
Message-ID: <20100408073041.GO30801@buzzloop.caiaq.de>
References: <4BBD1B6F.3000205@gmail.com>
 <Pine.LNX.4.44L0.1004072207390.18281-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1004072207390.18281-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 07, 2010 at 10:10:17PM -0400, Alan Stern wrote:
> On Wed, 7 Apr 2010, Robert Hancock wrote:
> 
> > >> The problem is appearantly the way the transfer buffer is allocated in
> > >> the drivers. In the snd-usb-caiaq driver, I used kzalloc() to get memory
> > >> which works fine on 32bit systems. On x86_64, however, it seems that
> > >> kzalloc() hands out memory beyond the 32bit addressable boundary, which
> > >> the DMA controller of the 32bit PCI-connected EHCI controller is unable
> > >> to write to or read from. Am I correct on this conclusion?
> > >
> > > That seems like the right answer.  You are correct that an EHCI
> > > controller capable only of 32-bit memory accesses would not be able to
> > > use a buffer above the 4 GB line.
> 
> > AFAIK, the driver shouldn't have to worry about this at all. When the 
> > buffer gets DMA-mapped for the controller, the DMA mapping code should 
> > see that the device has a 32-bit DMA mask and either bounce or IOMMU-map 
> > the memory so that it appears below 4GB.
> 
> That's true.  It would of course be more efficient for the buffer to be
> allocated below 4 GB, but it should work okay either way.  Daniel, do
> you have any idea why it fails?

No, and I can't do real tests as I lack a 64bit machine. I'll do some
more investigation later today, but for now the only explanation I have
is that not the remapped DMA buffer is used eventually by the EHCI code
but the physical address of the original buffer.

It would of course be best to fix the whole problem at this level, if
possible.

Daniel
