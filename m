Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058Ab0ELCEj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 22:04:39 -0400
Received: from sh.osrg.net ([192.16.179.4]:42925 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751554Ab0ELCEh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 22:04:37 -0400
Date: Wed, 12 May 2010 10:58:42 +0900
To: penberg@cs.helsinki.fi
Cc: vapier.adi@gmail.com, cl@linux.com, mpm@selenic.com,
       dmitry.torokhov@gmail.com, akpm@linux-foundation.org, os@emlix.com,
       Michael.Hennerich@analog.com, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, dg@emlix.com, osw@emlix.com, jw@emlix.com,
       npiggin@suse.de, rientjes@google.com, dbrownell@users.sourceforge.net,
       grant.likely@secretlab.ca
Subject: Re: [PATCH v3] ad7877: keep dma rx buffers in seperate cache lines
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <4BE9C58E.4070204@cs.helsinki.fi>
References: <alpine.DEB.2.00.1005111544330.8388@router.home>
	<AANLkTimzxrZyQAfocTwIt5zCVyXP7bReKOvP4K7m8epO@mail.gmail.com>
	<4BE9C58E.4070204@cs.helsinki.fi>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100512105907H.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 12 May 2010 10:58:45 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 May 2010 00:01:02 +0300
Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> Mike Frysinger wrote:
> > On Tue, May 11, 2010 at 16:46, Christoph Lameter wrote:
> >> On Tue, 11 May 2010, Mike Frysinger wrote:
> >>>> DMA. If the arch can only DMA into cacheline aligned objects then the
> >>>> correct method is to force kmalloc alignment to cacheline size.
> >>> these are SPI drivers and are usable on any arch that supports a SPI
> >>> bus (which is pretty much every arch).  forget about "embedded"
> >>> arches.
> >>>
> >>> the issue here is simple: a SPI driver (AD7877) needs to do a receive
> >>> SPI transfer into a DMA safe buffer.  what is the exact API to
> >>> dynamically allocate memory for the structure with this buffer
> >>> embedded in it such that the start of the structure is cached aligned
> >>> ?  creating a dedicated kmem cache may work, but it isnt a scalable
> >>> solution if every SPI driver needs to create its own cache.
> >> kmalloc returns a pointer to a DMA safe buffer. There is no requirement on
> >> the x86 hardware that the DMA buffers have to be cache aligned. Cachelines
> >> will be invalidated as needed.
> > 
> > so this guarantee is made by the kmalloc() API ?  and for arches where
> > the cacheline invalidation is handled in software rather than
> > hardware, they must declare a min alignment value for kmalloc to be at
> > least as big as their cache alignment ?
> > 
> > does the phrase "DMA safe buffer" imply cache alignment ?
> 
> Yes, you should be able to DMA into kmalloc'd memory. IIRC the block or 
> the SCSI layer depends on that.

Yeah, SCSI subsystem and drivers, and block drivers depend on it.
