Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261Ab0DLR4V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 13:56:21 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:47219 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776Ab0DLR4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 13:56:20 -0400
Date: Mon, 12 Apr 2010 19:56:09 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, Pedro Ribeiro <pedrib@gmail.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Greg KH <gregkh@suse.de>, alsa-devel@alsa-project.org,
       linux-usb@vger.kernel.org
Subject: Re: USB transfer_buffer allocations on 64bit systems
Message-ID: <20100412175609.GC30801@buzzloop.caiaq.de>
References: <20100412162947.GQ18855@one.firstfloor.org>
 <Pine.LNX.4.44L0.1004121252310.1702-100000@iolanthe.rowland.org>
 <20100412171507.GB30801@buzzloop.caiaq.de>
 <20100412172233.GR18855@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100412172233.GR18855@one.firstfloor.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 12, 2010 at 07:22:33PM +0200, Andi Kleen wrote:
> On Mon, Apr 12, 2010 at 07:15:07PM +0200, Daniel Mack wrote:
> > Given that - at least for non-64-aware host controllers - we want memory
> > <4GB anyway for USB transfers to avoid DMA bouncing buffers, maybe we
> > should just do that and fix the problem at this level? I already started
> > to implement usb_[mz]alloc() and use it in some USB drivers.
> 
> If the area is not mapped correctly it will fail in other situations,
> e.g. with an IOMMU active or in virtualized setups. So the bug
> has to be eventually tracked down.

Ok, agreed. But we all agree to the fact that we need an interface for
such allocations to avoid bounce buffers? If that is the case, we could
already start to implement that while we're tracking down the actual
bug.

[...]

> > Can anyone explain which is the right way to go?
> 
> The right thing would be to define a proper interface for it.
> 
> I had an attempt for it a couple of years ago with the mask allocator, 
> but it didn't make it into the tree.

Any plans to continue on this? Or can you dig it out again so others can
pick up the idea?

Daniel

