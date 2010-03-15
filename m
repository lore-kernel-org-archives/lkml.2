Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936405Ab0CON6E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 09:58:04 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:43801 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S936289Ab0CON56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 09:57:58 -0400
Date: Mon, 15 Mar 2010 09:57:55 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Andrew Morton <akpm@linux-foundation.org>
cc: Mel Gorman <mel@csn.ul.ie>, Markus Rechberger <mrechberger@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Subject: Re: USBFS Memory allocation Bug
In-Reply-To: <20100314193114.619a2616.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.44L0.1003150955170.1743-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Mar 2010, Andrew Morton wrote:

> > > Then about the only other suggestion would be a mempool containing a small
> > > number of largest-possible buffers that is enabled if there is no swap
> > > available.
> > 
> > Considering that this is the first report I have heard about this sort 
> > of problem, and that adding swap space would probably fix it, I'm not 
> > inclined to make any changes.
> 
> Adding swap space is unlikely to help here.  For an order-6 allocation
> the page allocator will go into wtf-youre-kidding-me mode and won't
> even bother trying.
> 
> Asking the allocator for 2^6 physically contiguous pages is terribly
> unreliable and shouldn't be done by any kernel code which wants to be
> useful.

Then the user program shouldn't make I/O requests requiring such large 
amounts of contiguous kernel memory.

Even if a dedicated mempool is set up to ease the problem, there's 
still no guarantee that any particular request will be satisfied 
(particularly if multiple requests are made at the same time).

Alan Stern

