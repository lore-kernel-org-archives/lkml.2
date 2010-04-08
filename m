Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758605Ab0DHLHv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 07:07:51 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:32784 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758571Ab0DHLHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 07:07:48 -0400
Date: Thu, 8 Apr 2010 13:07:43 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Oliver Neukum <oliver@neukum.org>
Cc: Greg KH <greg@kroah.com>, Alan Stern <stern@rowland.harvard.edu>,
       linux-kernel@vger.kernel.org, Pedro Ribeiro <pedrib@gmail.com>,
       akpm@linux-foundation.org, Greg KH <gregkh@suse.de>,
       alsa-devel@alsa-project.org, linux-usb@vger.kernel.org
Subject: Re: USB transfer_buffer allocations on 64bit systems
Message-ID: <20100408110743.GP30807@buzzloop.caiaq.de>
References: <20100407090623.GN30807@buzzloop.caiaq.de>
 <20100407153154.GC13425@kroah.com>
 <20100407153551.GK30801@buzzloop.caiaq.de>
 <201004080809.11756.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201004080809.11756.oliver@neukum.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 08, 2010 at 08:09:11AM +0200, Oliver Neukum wrote:
> Am Mittwoch, 7. April 2010 17:35:51 schrieb Daniel Mack:
> > > Alan, any objection to just using usb_buffer_alloc() for every driver?
> > > Or is that too much overhead?
> > 
> > FWIW, most drivers I've seen in the past hours use a wild mix of
> > kmalloc(), kzalloc(), kcalloc() and usb_buffer_alloc(). That should
> > really be unified.
> 
> kmalloc() & friends != usb_buffer_alloc(). They do different things.

I know. I just believe that many developers used usb_buffer_alloc() even
though they don't really need coherent DMA memory. The function's name
is misleading, and copy'n paste does the rest.

> It makes no sense to unify them. If you really need an ordinary
> buffer DMA will surely work on, this needs a third primitive.

I think it will help a lot to rename usb_buffer_alloc() in the first
place and then reconsider where coherent memory is really needed.

Daniel
