Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752548Ab0HZJnn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 05:43:43 -0400
Received: from sh.osrg.net ([192.16.179.4]:37447 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751582Ab0HZJnl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 05:43:41 -0400
Date: Thu, 26 Aug 2010 18:43:22 +0900
To: mitov@issp.bas.bg
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [RFC][PATCH] add
 dma_reserve_coherent_memory()/dma_free_reserved_memory() API
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <201008261001.57678.mitov@issp.bas.bg>
References: <201008260904.19973.mitov@issp.bas.bg>
	<20100826152333K.fujita.tomonori@lab.ntt.co.jp>
	<201008261001.57678.mitov@issp.bas.bg>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100826184231J.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 26 Aug 2010 18:43:23 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Aug 2010 10:01:52 +0300
Marin Mitov <mitov@issp.bas.bg> wrote:

> > If you add something to the videobuf-dma-contig API, that's fine by me
> > because drivers/media/video/videobuf-dma-contig.c uses the own
> > structure and plays with dma_alloc_coherent. As long as a driver
> > doesn't touch device->dma_mem directly, it's fine, 
> 
> Why, my understanding is that device->dma_mem is designed exactly for keeping 
> some chunk of coherent memory for device's private use via dma_alloc_from_coherent()
> (and that is what dt3155v4l driver is using it for).

I don't think so. device->dma_mem can be accessed only via the
DMA-API. I think that the DMA-API says that
dma_declare_coherent_memory declares coherent memory that can be
access exclusively by a certain device. It's not for reserving
coherent memory that can be used for any device for a device.

Anway, you don't need coherent memory. So using the API for coherent
memory isn't a good idea.


> > There are already some workarounds for
> > contigous memory in several drivers anyway.
> 
> Sure, can these workarounds be exposed as API for general use?

I don't think that's a good idea. Adding temporary workaround to the
generic API and removing it soon after that doesn't sound a good
developing maner.
