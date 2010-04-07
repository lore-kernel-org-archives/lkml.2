Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932827Ab0DGQQK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 12:16:10 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:32978 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932539Ab0DGQQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 12:16:08 -0400
Date: Wed, 7 Apr 2010 18:16:03 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       Pedro Ribeiro <pedrib@gmail.com>, akpm@linux-foundation.org,
       Greg KH <gregkh@suse.de>, alsa-devel@alsa-project.org,
       linux-usb@vger.kernel.org
Subject: Re: USB transfer_buffer allocations on 64bit systems
Message-ID: <20100407161603.GL30801@buzzloop.caiaq.de>
References: <20100407153154.GC13425@kroah.com>
 <Pine.LNX.4.44L0.1004071149140.1779-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1004071149140.1779-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 07, 2010 at 11:55:19AM -0400, Alan Stern wrote:
> On Wed, 7 Apr 2010, Greg KH wrote:
> 
> > Alan, any objection to just using usb_buffer_alloc() for every driver?
> > Or is that too much overhead?
> 
> I don't know what the overhead is.  But usb_buffer_alloc() requires the 
> caller to keep track of the buffer's DMA address, so it's not a simple 
> plug-in replacement.  In addition, the consistent memory that 
> usb_buffer_alloc() provides is a scarce resource on some platforms.
> 
> Writing new functions is the way to go.

Ok, I'll write some dummies for usb_malloc() and usb_zalloc() which
will just call kmalloc() with GFP_DMA32 for now. And while at it,
usb_alloc_buffer() will be renamed to usb_alloc_consistent(). Then I'll
try to clean up all existing drivers to use this new interface and
follow the changes.

In a next step, we should fine-tune when GFP_DMA32 is really needed.
And I'll leave all occurances of usb_alloc_consistent() as they are now.

Does that sound ok?

Thanks,
Daniel

