Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758187Ab0DGRAN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 13:00:13 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:35493 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758103Ab0DGRAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 13:00:10 -0400
Date: Wed, 7 Apr 2010 19:00:01 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Oliver Neukum <oliver@neukum.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
       Pedro Ribeiro <pedrib@gmail.com>, akpm@linux-foundation.org,
       Greg KH <gregkh@suse.de>, alsa-devel@alsa-project.org,
       linux-usb@vger.kernel.org
Subject: Re: USB transfer_buffer allocations on 64bit systems
Message-ID: <20100407170001.GM30801@buzzloop.caiaq.de>
References: <Pine.LNX.4.44L0.1004071036060.1779-100000@iolanthe.rowland.org>
 <201004071854.55530.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201004071854.55530.oliver@neukum.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 07, 2010 at 06:54:55PM +0200, Oliver Neukum wrote:
> Am Mittwoch, 7. April 2010 16:59:47 schrieb Alan Stern:
> > > The fix is to use usb_buffer_alloc() for that purpose which ensures
> > > memory that is suitable for DMA. And on x86_64, this also means that the
> > > upper 32 bits of the address returned are all 0's.
> > 
> > That is not a good fix.  usb_buffer_alloc() provides coherent memory, 
> > which is not what we want.  I believe the correct fix is to specify the 
> > GFP_DMA32 flag in the kzalloc() call.
> > 
> > Of course, some EHCI hardware is capable of using 64-bit addresses.  
> > But not all, and other controller types aren't.  In principle we could
> > create a new allocation routine, which would take a pointer to the USB
> > bus as an additional argument and use it to decide whether the memory 
> > needs to lie below 4 GB.  I'm not sure adding this extra complexity 
> > would be worthwhile.
> 
> What about XHCI? Do you really want to limit it to 32bits?

No. Once we have the abstraction functions, we can well decide what to
do in there, depending on the actual controller we're running on.

Daniel

