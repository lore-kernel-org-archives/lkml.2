Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759198Ab0DHWUj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 18:20:39 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:32850 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751846Ab0DHWUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 18:20:37 -0400
Date: Thu, 8 Apr 2010 18:20:36 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Oliver Neukum <oliver@neukum.org>
cc: Daniel Mack <daniel@caiaq.de>, <linux-kernel@vger.kernel.org>,
       Pedro Ribeiro <pedrib@gmail.com>, <akpm@linux-foundation.org>,
       Greg KH <gregkh@suse.de>, <alsa-devel@alsa-project.org>,
       <linux-usb@vger.kernel.org>
Subject: Re: USB transfer_buffer allocations on 64bit systems
In-Reply-To: <201004082324.31481.oliver@neukum.org>
Message-ID: <Pine.LNX.4.44L0.1004081817230.21642-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Apr 2010, Oliver Neukum wrote:

> Am Donnerstag, 8. April 2010 18:59:38 schrieb Alan Stern:
> > On Thu, 8 Apr 2010, Oliver Neukum wrote:
> > 
> > > Am Mittwoch, 7. April 2010 17:46:17 schrieb Alan Stern:
> > > > Or alternatively, instead of allocating regular memory the routine
> > > > could simply fail.  Then the caller would be responsible for checking
> > > > and using regular memory instead of dma-consistent memory.  Of course,
> > > > that would put an even larger burden on the caller than just forcing it
> > > > to keep track of what flag to use.
> > > 
> > > Then it would be sensible to pass it a filled URB, modify it or return
> > > an error code.
> > 
> > That would work, but it doesn't match the way existing drivers use the
> > interface.  For example, the audio driver allocates a 16-byte coherent
> > buffer and then uses four bytes from it for each of four different 
> > URBs.
> 
> That will not work with any fallback that does not yield a coherent buffer.

What you mean isn't entirely clear.  But it certainly does work in 
various circumstances that don't yield coherent buffers.  For example, 
it works if the controller uses PIO instead of DMA.  It also works if 
the controller uses DMA and the URBs have to be bounced.

Alan Stern

