Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752662Ab0HTKgm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 06:36:42 -0400
Received: from sh.osrg.net ([192.16.179.4]:51817 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752510Ab0HTKgj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 06:36:39 -0400
Date: Fri, 20 Aug 2010 19:35:01 +0900
To: m.nazarewicz@samsung.com
Cc: fujita.tomonori@lab.ntt.co.jp, hverkuil@xs4all.nl, dwalker@codeaurora.org,
        linux@arm.linux.org.uk, corbet@lwn.net, p.osciak@samsung.com,
        broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        hvaibhav@ti.com, linux-mm@kvack.org, kyungmin.park@samsung.com,
        kgene.kim@samsung.com, zpfeffer@codeaurora.org, jaeryul.oh@samsung.com,
        m.szyprowski@samsung.com, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH/RFCv3 0/6] The Contiguous Memory Allocator framework
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <op.vhp7rxz77p4s8u@localhost>
References: <op.vhp4pws27p4s8u@localhost>
	<20100820155617S.fujita.tomonori@lab.ntt.co.jp>
	<op.vhp7rxz77p4s8u@localhost>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100820193328P.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 20 Aug 2010 19:35:03 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Aug 2010 10:10:45 +0200
**UNKNOWN CHARSET** <m.nazarewicz@samsung.com> wrote:

> > I wrote "similar to the existing API', not "reuse the existing API".
> 
> Yes, but I don't really know what you have in mind.  CMA is similar to various
> APIs in various ways: it's similar to any allocator since it takes
> size in bytes,

why don't take gfp_t flags?

Something like dev_alloc_page is more appropriate name?

Or something similar to dmapool API (mm/dmapool.c) might work
better. The purpose of dmapool API is creating a pool for consistent
memory per device. It's similar to yours, creating a pool for
contiguous memory per device(s)?


> it's similar to coherent since it takes device, it's similar to bootmem/memblock/etc
> since it takes alignment.

I don't think that bootmem/memblock matters here since it's not the
API for drivers.


> > 4k to 40k? I'm not sure. But If I see something like the following, I
> > suspect that there is a better way to integrate this into the existing
> > infrastructure.
> >
> > mm/cma-best-fit.c                   |  407 +++++++++++++++
> 
> Ah, sorry.  I misunderstood you.  I thought you were replying to both 2. and 3.
> above.
> 
> If we only take allocating algorithm then you're right.  Reusing existing one
> should not increase the patch size plus it would be probably a better solution.
> 
> No matter, I would rather first work and core CMA without worrying about reusing
> kmalloc()/coherent/etc. code especially since providing a plugable allocator API
> integration with existing allocating algorithms can be made later on.  To put it
> short I want first to make it work and then improve it.

I'm not sure that's how a new feature is merged.
