Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757409Ab0HJANJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 20:13:09 -0400
Received: from www.tglx.de ([62.245.132.106]:39033 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757268Ab0HJANH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 20:13:07 -0400
Date: Tue, 10 Aug 2010 02:12:44 +0200
From: "Hans J. Koch" <hjk@linutronix.de>
To: "Hans J. Koch" <hjk@linutronix.de>
Cc: Leon Woestenberg <leon.woestenberg@gmail.com>, Tom Lyon <pugs@cisco.com>,
        mst@redhat.com, gregkh@suse.de, chrisw@sous-sol.org, joro@8bytes.org,
        avi@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: UIO DMA to userspace question
Message-ID: <20100810001244.GD2569@local>
References: <AANLkTimWdaBrJz-dQ3MHWwG7iZ5m1opSmLFKva880csi@mail.gmail.com>
 <20100809111155.GB2569@local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100809111155.GB2569@local>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 09, 2010 at 01:11:56PM +0200, Hans J. Koch wrote:
> On Sat, Aug 07, 2010 at 08:38:30PM +0200, Leon Woestenberg wrote:
> > Hello all,
> > 
> > can I use the UIO framework for the following?
> > 
> > The userspace portion of the driver allocates memory in user-space
> > using malloc() - usually resulting in a scatter pages in physical
> > memory.
> > The UIO kernel portion of the driver maps those using pci_map_sg().
> > 
> > Is this possible, or does the UIO framework assume memory for DMA is
> > allocated in kernel space?
> 
> You would have to write your own mmap() function and and set the pointer
> to it in struct uio_info->mmap. Have a look at uio_mmap() in

A few more thoughts about that: The UIO core currently doesn't support
dynamically allocated memory. That means, even if you manage to mmap your
memory allocated in userspace, it won't show up in sysfs. ATM, all UIO
supports is memory allocated at device creation time in kernel space.

So, what your trying to do is something that could probably work. The
uio_info->mmap pointer was made for unusual mappings. But it still causes
me some headaches. I'm not sure if this can be considered a clean solution.
An extension that makes UIO deal properly with dynamically allocated (DMA-)
memory would certainly be preferable.

Hans

