Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757980Ab0DGPf5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 11:35:57 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:38889 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431Ab0DGPf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 11:35:56 -0400
Date: Wed, 7 Apr 2010 17:35:51 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Greg KH <greg@kroah.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
       Pedro Ribeiro <pedrib@gmail.com>, akpm@linux-foundation.org,
       Greg KH <gregkh@suse.de>, alsa-devel@alsa-project.org,
       linux-usb@vger.kernel.org
Subject: Re: USB transfer_buffer allocations on 64bit systems
Message-ID: <20100407153551.GK30801@buzzloop.caiaq.de>
References: <20100407090623.GN30807@buzzloop.caiaq.de>
 <Pine.LNX.4.44L0.1004071036060.1779-100000@iolanthe.rowland.org>
 <20100407151125.GJ30801@buzzloop.caiaq.de>
 <20100407153154.GC13425@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100407153154.GC13425@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 07, 2010 at 08:31:54AM -0700, Greg KH wrote:
> On Wed, Apr 07, 2010 at 05:11:25PM +0200, Daniel Mack wrote:
> > I vote for a clean solution, a fixup of existing implementations and
> > a clear note about how to allocate buffers for USB drivers. I believe
> > faulty allocations of this kind can explain quite a lot of problems on
> > x86_64 machines.
> 
> Yeah, I really don't want to have to change every driver in different
> ways just depending on if someone thinks it is going to need to run on
> this wierd hardware.
> 
> Alan, any objection to just using usb_buffer_alloc() for every driver?
> Or is that too much overhead?

FWIW, most drivers I've seen in the past hours use a wild mix of
kmalloc(), kzalloc(), kcalloc() and usb_buffer_alloc(). That should
really be unified.

Daniel

