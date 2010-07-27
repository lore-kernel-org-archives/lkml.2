Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236Ab0G0OWr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 10:22:47 -0400
Received: from sh.osrg.net ([192.16.179.4]:55828 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753005Ab0G0OWp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 10:22:45 -0400
Date: Tue, 27 Jul 2010 23:21:37 +0900
To: corbet@lwn.net
Cc: m.szyprowski@samsung.com, linux@arm.linux.org.uk, m.nazarewicz@samsung.com,
        linux-mm@kvack.org, dwalker@codeaurora.org, p.osciak@samsung.com,
        broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        hvaibhav@ti.com, fujita.tomonori@lab.ntt.co.jp,
        kyungmin.park@samsung.com, zpfeffer@codeaurora.org,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv2 2/4] mm: cma: Contiguous Memory Allocator added
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100727065842.40ae76c8@bike.lwn.net>
References: <20100727120841.GC11468@n2100.arm.linux.org.uk>
	<003701cb2d89$adae4580$090ad080$%szyprowski@samsung.com>
	<20100727065842.40ae76c8@bike.lwn.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100727232106Z.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 27 Jul 2010 23:21:40 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Jul 2010 06:58:42 -0600
Jonathan Corbet <corbet@lwn.net> wrote:

> On Tue, 27 Jul 2010 14:45:58 +0200
> Marek Szyprowski <m.szyprowski@samsung.com> wrote:
> 
> > > How does one obtain the CPU address of this memory in order for the CPU
> > > to access it?  
> > 
> > Right, we did not cover such case. In CMA approach we tried to separate
> > memory allocation from the memory mapping into user/kernel space. Mapping
> > a buffer is much more complicated process that cannot be handled in a
> > generic way, so we decided to leave this for the device drivers. Usually
> > video processing devices also don't need in-kernel mapping for such
> > buffers at all.
> 
> Still...that *is* why I suggested an interface which would return both
> the DMA address and a kernel-space virtual address, just like the DMA
> API does...  Either that, or just return the void * kernel address and

The DMA API for coherent memory (dma_alloc_coherent) returns both an
DMA address and a kernel-space virtual address because it does both
allocation and mapping.

However, other DMA API (dma_map_*) returns only an DMA address because
it does only mapping.

I think that if we need new API for coherent memory, we could
unify it with the DMA API for coherent memory.

IMO, it's cleaner to having two separate APIs for allocation and
mapping (except for coherent memory). The drivers have been working
in that way.
