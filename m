Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752122Ab0HTHSJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 03:18:09 -0400
Received: from sh.osrg.net ([192.16.179.4]:49734 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751076Ab0HTHSG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 03:18:06 -0400
Date: Fri, 20 Aug 2010 16:17:48 +0900
To: mitov@issp.bas.bg
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        fujita.tomonori@lab.ntt.co.jp
Subject: Re: [RFC][PATCH] add
 dma_reserve_coherent_memory()/dma_free_reserved_memory() API
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <201008191818.36068.mitov@issp.bas.bg>
References: <201008191818.36068.mitov@issp.bas.bg>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100820161631A.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 20 Aug 2010 16:17:49 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Aug 2010 18:18:35 +0300
Marin Mitov <mitov@issp.bas.bg> wrote:

> struct device contains a member: struct dma_coherent_mem *dma_mem;
> to hold information for a piece of memory declared dma-coherent.
> Alternatively the same member could also be used to hold preallocated
> dma-coherent memory for latter per-device use.

I think that drivers/base/dma-coherent.c is for architectures to
implement dma_alloc_coherent(). So using it for drivers doesn't look
correct.


> This tric is already used in drivers/staging/dt3155v4l.c
> dt3155_alloc_coherent()/dt3155_free_coherent()
> 
> Here proposed for general use by popular demand from video4linux folks.
> Helps for videobuf-dma-contig framework.

What you guys exactly want to do? If you just want to pre-allocate
coherent memory for latter usage, why dma_pool API (mm/dmapool.c)
doesn't work?
