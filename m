Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751552Ab0DLMrL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 08:47:11 -0400
Received: from one.firstfloor.org ([213.235.205.2]:35449 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782Ab0DLMrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 08:47:09 -0400
Date: Mon, 12 Apr 2010 14:47:08 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Daniel Mack <daniel@caiaq.de>
Cc: Andi Kleen <andi@firstfloor.org>, Pedro Ribeiro <pedrib@gmail.com>,
       Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Greg KH <gregkh@suse.de>,
       alsa-devel@alsa-project.org, linux-usb@vger.kernel.org
Subject: Re: USB transfer_buffer allocations on 64bit systems
Message-ID: <20100412124708.GO18855@one.firstfloor.org>
References: <20100407090623.GN30807@buzzloop.caiaq.de> <Pine.LNX.4.44L0.1004071036060.1779-100000@iolanthe.rowland.org> <87sk719hbm.fsf@basil.nowhere.org> <20100412111439.GU30801@buzzloop.caiaq.de> <20100412115300.GM18855@one.firstfloor.org> <q2z74fd948d1004120511hebf19eaauc41ee9ed25dea19e@mail.gmail.com> <20100412121243.GN18855@one.firstfloor.org> <20100412123238.GW30801@buzzloop.caiaq.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100412123238.GW30801@buzzloop.caiaq.de>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 12, 2010 at 02:32:38PM +0200, Daniel Mack wrote:
> Another detail I can't explain is that on his machine, the kernel oopses
> when kmalloc() with GFP_DMA32 is used. The patch to try this also only
> touched the allocation in sound/usb/caiaq/audio.c.

Where did it oops?

> 
> > > The only which solved this problem was the first patch sent to me by
> > > Daniel Mack. I've been using it for days straight and it works fine.
> > 
> > Can you send a full boot log?
> 
> He just did. I put it online here:
> 
>   http://caiaq.de/download/tmp/pedro-dmesg

The system seems to set up the soft iotlb correctly.

[    0.468472] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.468539] Placing 64MB software IO TLB between ffff880020000000 - ffff880024000000
[    0.468610] software IO TLB at phys 0x20000000 - 0x24000000

Also if that was wrong a lot more things would go wrong.

I would suspect the driver. Are you sure:

- it sets up it's dma_masks correctly?
- it uses pci_map_single/sg correctly for all transferred data?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
