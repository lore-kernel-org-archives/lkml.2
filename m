Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120Ab0DIPPq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 11:15:46 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:44956 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752953Ab0DIPPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 11:15:45 -0400
Date: Fri, 9 Apr 2010 11:15:43 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Oliver Neukum <oliver@neukum.org>
cc: Daniel Mack <daniel@caiaq.de>, <linux-kernel@vger.kernel.org>,
       Pedro Ribeiro <pedrib@gmail.com>, <akpm@linux-foundation.org>,
       Greg KH <gregkh@suse.de>, <alsa-devel@alsa-project.org>,
       <linux-usb@vger.kernel.org>
Subject: Re: USB transfer_buffer allocations on 64bit systems
In-Reply-To: <201004091650.31488.oliver@neukum.org>
Message-ID: <Pine.LNX.4.44L0.1004091114500.1852-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Apr 2010, Oliver Neukum wrote:

> Am Freitag, 9. April 2010 16:41:48 schrieb Alan Stern:
> > > It'll work on x86. On incoherent architectures this violates the cacheline
> > > rules for DMA-mapping if you have to bounce.
> > 
> > Not true.  Consider: The driver allocates a 16-byte buffer (xbuf)  
> > divided up into four sets of four bytes, and sets
> > 
> >         urb[i].transfer_buffer_dma = xbuf_dma + 4*i;
> > 
> > Then usb_submit_urb(urb[i]) will copy the appropriate four bytes to a
> > bounce buffer and map the bounce buffer.  Accesses to the other parts
> > of xbuf won't violate the cacheline rules, because xbuf isn't mapped
> > for DMA -- only the bounce buffer is.  When urb[i] completes, the
> > bounce buffer contents will be copied back to the original four bytes
> > in xbuf.  Again, there is no violation of cacheline rules.
> 
> I think you are assuming that either every or no part of the buffer is mapped
> for DMA in place. I don't think you can assume that.

Yes I can, because the code that makes this decision is part of 
usbcore and it is under my control.

Alan Stern

