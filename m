Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932818Ab0DGPzW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 11:55:22 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:58408 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932581Ab0DGPzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 11:55:20 -0400
Date: Wed, 7 Apr 2010 11:55:19 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg KH <greg@kroah.com>
cc: Daniel Mack <daniel@caiaq.de>, <linux-kernel@vger.kernel.org>,
       Pedro Ribeiro <pedrib@gmail.com>, <akpm@linux-foundation.org>,
       Greg KH <gregkh@suse.de>, <alsa-devel@alsa-project.org>,
       <linux-usb@vger.kernel.org>
Subject: Re: USB transfer_buffer allocations on 64bit systems
In-Reply-To: <20100407153154.GC13425@kroah.com>
Message-ID: <Pine.LNX.4.44L0.1004071149140.1779-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Apr 2010, Greg KH wrote:

> Yeah, I really don't want to have to change every driver in different
> ways just depending on if someone thinks it is going to need to run on
> this wierd hardware.

It's not weird hardware, as far as I know.  It's just a 64-bit system
with a 32-bit USB host controller.

(And remember, while there are 64-bit EHCI controllers, there are not 
any 64-bit OHCI or UHCI controllers.  So whenever somebody plugs a 
full-speed or low-speed device into a 64-bit machine, they will face 
this problem.  It's like the old problem of ISA devices that could 
only do DMA to addresses in the first 16 MB of memory -- what the 
original GFP_DMA flag was intended for.)

> Alan, any objection to just using usb_buffer_alloc() for every driver?
> Or is that too much overhead?

I don't know what the overhead is.  But usb_buffer_alloc() requires the 
caller to keep track of the buffer's DMA address, so it's not a simple 
plug-in replacement.  In addition, the consistent memory that 
usb_buffer_alloc() provides is a scarce resource on some platforms.

Writing new functions is the way to go.

Alan Stern

