Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161Ab0DLQ5T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 12:57:19 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:56763 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752886Ab0DLQ5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 12:57:17 -0400
Date: Mon, 12 Apr 2010 12:57:16 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Andi Kleen <andi@firstfloor.org>
cc: Daniel Mack <daniel@caiaq.de>, Pedro Ribeiro <pedrib@gmail.com>,
       <linux-kernel@vger.kernel.org>, <akpm@linux-foundation.org>,
       Greg KH <gregkh@suse.de>, <alsa-devel@alsa-project.org>,
       <linux-usb@vger.kernel.org>
Subject: Re: USB transfer_buffer allocations on 64bit systems
In-Reply-To: <20100412162947.GQ18855@one.firstfloor.org>
Message-ID: <Pine.LNX.4.44L0.1004121252310.1702-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Apr 2010, Andi Kleen wrote:

> On Mon, Apr 12, 2010 at 12:17:22PM -0400, Alan Stern wrote:
> > On Mon, 12 Apr 2010, Andi Kleen wrote:
> > 
> > > > Well, the sound driver itself doesn't care for any of those things, just
> > > > like any other USB driver doesn't. The USB core itself of the host
> > > > controller driver should do, and as far as I can see, it does that, yes.
> > > 
> > > Hmm, still things must go wrong somewhere. Perhaps need some instrumentation
> > > to see if all the transfer buffers really hit the PCI mapping functions.
> > 
> > Such a test has already been carried out earlier in this thread:
> > 
> > 	http://marc.info/?l=linux-usb&m=127074587029353&w=2
> > 	http://marc.info/?l=linux-usb&m=127076841801051&w=2
> > 	http://marc.info/?l=linux-usb&m=127082890510415&w=2
> 
> Hmm, thanks. But things must still go wrong somewhere, otherwise
> the GFP_DMA32 wouldn't be needed?

Indeed, something must go wrong somewhere.  Since Daniel's patch fixed
the problem by changing the buffer from a streaming mapping to a
coherent mapping, it's logical to assume that bad DMA addresses have
something to do with it.  But we don't really know for certain.

Alan Stern

