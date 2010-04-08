Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751655Ab0DHCKX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 22:10:23 -0400
Received: from netrider.rowland.org ([192.131.102.5]:56510 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751015Ab0DHCKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 22:10:19 -0400
Date: Wed, 7 Apr 2010 22:10:17 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Robert Hancock <hancockrwd@gmail.com>
cc: Daniel Mack <daniel@caiaq.de>, <linux-kernel@vger.kernel.org>,
       Pedro Ribeiro <pedrib@gmail.com>, <akpm@linux-foundation.org>,
       Greg KH <gregkh@suse.de>, <alsa-devel@alsa-project.org>,
       <linux-usb@vger.kernel.org>
Subject: Re: USB transfer_buffer allocations on 64bit systems
In-Reply-To: <4BBD1B6F.3000205@gmail.com>
Message-ID: <Pine.LNX.4.44L0.1004072207390.18281-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Apr 2010, Robert Hancock wrote:

> >> The problem is appearantly the way the transfer buffer is allocated in
> >> the drivers. In the snd-usb-caiaq driver, I used kzalloc() to get memory
> >> which works fine on 32bit systems. On x86_64, however, it seems that
> >> kzalloc() hands out memory beyond the 32bit addressable boundary, which
> >> the DMA controller of the 32bit PCI-connected EHCI controller is unable
> >> to write to or read from. Am I correct on this conclusion?
> >
> > That seems like the right answer.  You are correct that an EHCI
> > controller capable only of 32-bit memory accesses would not be able to
> > use a buffer above the 4 GB line.

> AFAIK, the driver shouldn't have to worry about this at all. When the 
> buffer gets DMA-mapped for the controller, the DMA mapping code should 
> see that the device has a 32-bit DMA mask and either bounce or IOMMU-map 
> the memory so that it appears below 4GB.

That's true.  It would of course be more efficient for the buffer to be
allocated below 4 GB, but it should work okay either way.  Daniel, do
you have any idea why it fails?

Alan Stern

