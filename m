Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092Ab0EKQJn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 12:09:43 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:49349 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752934Ab0EKQJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 12:09:42 -0400
Date: Tue, 11 May 2010 18:09:23 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, gregkh@suse.de,
       konrad.wilk@oracle.com, tiwai@suse.de,
       USB list <linux-usb@vger.kernel.org>, clemens@ladisch.de,
       Kernel development list <linux-kernel@vger.kernel.org>,
       chrisw@sous-sol.org, iommu@lists.linux-foundation.org,
       andi@firstfloor.org, pedrib@gmail.com,
       Andrew Morton <akpm@linux-foundation.org>, dwmw2@infradead.org
Subject: Re: [alsa-devel] USB transfer_buffer allocations on 64bit systems
Message-ID: <20100511160923.GZ30801@buzzloop.caiaq.de>
References: <20100512003450P.fujita.tomonori@lab.ntt.co.jp>
 <Pine.LNX.4.44L0.1005111158420.1834-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1005111158420.1834-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 11, 2010 at 12:06:09PM -0400, Alan Stern wrote:
> On Wed, 12 May 2010, FUJITA Tomonori wrote:
> 
> > > > Can you tell me all the exact process of DMA that the usb core and the
> > > > driver do?
> > > 
> > > 1. The audio driver stores data in urb->transfer_buffer.
> > 
> > How urb->transfer_buffer is allocated?
> 
> By kmalloc().  Right, Daniel?

Yes, and that's precisely the reason for the whole thread ;)

[...]

> > The driver does only DMA_TO_DEVICE? Or you see DMA problems only with
> > DMA_TO_DEVICE?
> 
> The particular test that Pedro is running uses audio output only -- 
> he's sending sound data to a speaker and it comes out noisy.
> 
> But the audio data has to come from somewhere, and I don't remember 
> where.  Pedro, does the noise occur only when you're playing sound that 
> comes from a different USB device?  What happens if you play sounds 
> that are stored on your hard disk, like an MP3 file?

AFAIK that was playback from a file, yes. It would be interesting to
have some results for the other direction as well, that's true.

Thanks,
Daniel

