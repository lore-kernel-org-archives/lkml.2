Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115Ab0DIQBa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 12:01:30 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:47178 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750883Ab0DIQB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 12:01:28 -0400
Date: Fri, 9 Apr 2010 12:01:27 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Pedro Ribeiro <pedrib@gmail.com>
cc: Daniel Mack <daniel@caiaq.de>, Robert Hancock <hancockrwd@gmail.com>,
       <linux-kernel@vger.kernel.org>, <akpm@linux-foundation.org>,
       Greg KH <gregkh@suse.de>, <alsa-devel@alsa-project.org>,
       <linux-usb@vger.kernel.org>
Subject: Re: USB transfer_buffer allocations on 64bit systems
In-Reply-To: <m2n74fd948d1004081613n90408827s7c51ef572848fb1d@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1004091155570.1852-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Apr 2010, Pedro Ribeiro wrote:

> On 8 April 2010 17:57, Alan Stern <stern@rowland.harvard.edu> wrote:
> > On Thu, 8 Apr 2010, Daniel Mack wrote:
> >
> >> > > AFAIK, the driver shouldn't have to worry about this at all. When the
> >> > > buffer gets DMA-mapped for the controller, the DMA mapping code should
> >> > > see that the device has a 32-bit DMA mask and either bounce or IOMMU-map
> >> > > the memory so that it appears below 4GB.
> >> >
> >> > That's true.  It would of course be more efficient for the buffer to be
> >> > allocated below 4 GB, but it should work okay either way.  Daniel, do
> >> > you have any idea why it fails?
> >>
> >> No, and I can't do real tests as I lack a 64bit machine. I'll do some
> >> more investigation later today, but for now the only explanation I have
> >> is that not the remapped DMA buffer is used eventually by the EHCI code
> >> but the physical address of the original buffer.
> >>
> >> It would of course be best to fix the whole problem at this level, if
> >> possible.
> >
> > It definitely needs to be fixed at this level.  But I still think it's
> > appropriate to have new USB core functions for allocating and
> > deallocating I/O memory.  The additional price is small compared to
> > constantly bouncing the buffers.
> >
> > Pedro, in the hope of tracking down the problem, can you apply this
> > patch and see what output it produces in the system log when the
> > "interference" happens?  (Warning: It will produce quite a lot of
> > output whenever you send data to the audio device -- between 500 and
> > 1000 lines per second.)

> Hi Alan,
> 
> here is the output of the patch you sent me when the interference is triggered.
> 
> The log is long, 1.3mb in size.

I don't see anything suspicious.  The transfer_buffer addresses repeat 
every 32 URBs, and the DMA addresses cycle almost entirely uniformly 
from 0x20000000 to 0x23ffffff in units of 0x2000 (there are a few gaps 
where the interval is a little bigger).

Alan Stern

