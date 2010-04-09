Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756927Ab0DIUPb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 16:15:31 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:51937 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756403Ab0DIUP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 16:15:28 -0400
Date: Fri, 9 Apr 2010 22:14:48 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Pedro Ribeiro <pedrib@gmail.com>, Robert Hancock <hancockrwd@gmail.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Greg KH <gregkh@suse.de>, alsa-devel@alsa-project.org,
       linux-usb@vger.kernel.org
Subject: Re: USB transfer_buffer allocations on 64bit systems
Message-ID: <20100409201448.GL30801@buzzloop.caiaq.de>
References: <w2r74fd948d1004091119j9f33d8a6kc1824d9243abf38b@mail.gmail.com>
 <Pine.LNX.4.44L0.1004091529240.1852-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1004091529240.1852-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 09, 2010 at 03:34:06PM -0400, Alan Stern wrote:
> On Fri, 9 Apr 2010, Pedro Ribeiro wrote:
> 
> > > The DMA pointers do indeed look sane. I wanted to take a deeper look at
> > > this and set up a 64bit system today. However, I fail to see the problem
> > > here. Pedro, how much RAM does your machine have installed?
> 
> > It has 4 GB.
> 
> That means DMA mapping cannot be the cause of the problem.  :-(

FWIW, as I stated in the first message of this thread, I had very
similar bug reports for a Mac OS X driver I'm maintaining, and the
solution that fixed everything was to force memory that has a _physical_
buffer address mask of 0x00000000ffffffff. And all machines I've seen
the bug on had 4GB of RAM or less. So appearantly, without that force
option, memory beyond the 4GB range was provided.

But I can't tell whether this effect also counts for Linux, and I must
admit I lack a deep enough understanding about the kernel's memory
management in 64bit mode and about how the DMA bouncing and remapping
logic works. Does anyone have an idea about how to explain that?

Daniel

