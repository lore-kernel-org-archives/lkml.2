Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753067Ab0DLRPQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 13:15:16 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:50631 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197Ab0DLRPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 13:15:13 -0400
Date: Mon, 12 Apr 2010 19:15:07 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Andi Kleen <andi@firstfloor.org>, Pedro Ribeiro <pedrib@gmail.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Greg KH <gregkh@suse.de>, alsa-devel@alsa-project.org,
       linux-usb@vger.kernel.org
Subject: Re: USB transfer_buffer allocations on 64bit systems
Message-ID: <20100412171507.GB30801@buzzloop.caiaq.de>
References: <20100412162947.GQ18855@one.firstfloor.org>
 <Pine.LNX.4.44L0.1004121252310.1702-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1004121252310.1702-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 12, 2010 at 12:57:16PM -0400, Alan Stern wrote:
> On Mon, 12 Apr 2010, Andi Kleen wrote:
> > Hmm, thanks. But things must still go wrong somewhere, otherwise
> > the GFP_DMA32 wouldn't be needed?
> 
> Indeed, something must go wrong somewhere.  Since Daniel's patch fixed
> the problem by changing the buffer from a streaming mapping to a
> coherent mapping, it's logical to assume that bad DMA addresses have
> something to do with it.  But we don't really know for certain.

Given that - at least for non-64-aware host controllers - we want memory
<4GB anyway for USB transfers to avoid DMA bouncing buffers, maybe we
should just do that and fix the problem at this level? I already started
to implement usb_[mz]alloc() and use it in some USB drivers.

But even after all collected wisdom about memory management in this
thread, I'm still uncertain of how to get suitable memory. Using
dma_alloc_coherent() seems overdone as that type of memory is not
necessarily needed and might be a costly good on some platforms. And as
fas as I understand, kmalloc(GFP_DMA) does not avoid memory >4GB.

Can anyone explain which is the right way to go?

Daniel
