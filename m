Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535Ab0HZKQx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 06:16:53 -0400
Received: from mail.issp.bas.bg ([195.96.236.10]:52530 "EHLO mail.issp.bas.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752774Ab0HZKQv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 06:16:51 -0400
From: Marin Mitov <mitov@issp.bas.bg>
Organization: Institute of Solid State Physics
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [RFC][PATCH] add dma_reserve_coherent_memory()/dma_free_reserved_memory() API
Date: Thu, 26 Aug 2010 13:14:51 +0300
User-Agent: KMail/1.13.3 (Linux/2.6.36-rc2; KDE/4.4.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        akpm@linux-foundation.org
References: <201008260904.19973.mitov@issp.bas.bg> <201008261001.57678.mitov@issp.bas.bg> <20100826184231J.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100826184231J.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008261314.56782.mitov@issp.bas.bg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, August 26, 2010 12:43:22 pm FUJITA Tomonori wrote:
> On Thu, 26 Aug 2010 10:01:52 +0300
> Marin Mitov <mitov@issp.bas.bg> wrote:
> 
> > > If you add something to the videobuf-dma-contig API, that's fine by me
> > > because drivers/media/video/videobuf-dma-contig.c uses the own
> > > structure and plays with dma_alloc_coherent. As long as a driver
> > > doesn't touch device->dma_mem directly, it's fine, 
> > 
> > Why, my understanding is that device->dma_mem is designed exactly for keeping 
> > some chunk of coherent memory for device's private use via dma_alloc_from_coherent()
> > (and that is what dt3155v4l driver is using it for).
> 
> I don't think so. device->dma_mem can be accessed only via the
> DMA-API. I think that the DMA-API says that
> dma_declare_coherent_memory declares coherent memory that can be
> access exclusively by a certain device. 

Here I agree with you: "that can be access exclusively by a certain device"

> It's not for reserving
> coherent memory that can be used for any device for a device.

Here I disagree with you: "that can be used for any device for a device".
Reserved coherent memory can be only and exclusively used by 
the __same__ device whose device->dma_mem is touched. No other devices 
are influenced because their device->dma_mem are NULL. and 
dma_alloc_from_coherent() is not invoked for them. That is why I think
this hack is not dangerous. If some device driver decide to reserve some
chunk of memory it is for its private use and no other device in the system
is influenced.

> 
> Anway, you don't need coherent memory. So using the API for coherent
> memory isn't a good idea.

Here I agree with you, but for now we have no alternative in media/video
framework.

> 
> 
> > > There are already some workarounds for
> > > contigous memory in several drivers anyway.
> > 
> > Sure, can these workarounds be exposed as API for general use?
> 
> I don't think that's a good idea. Adding temporary workaround to the
> generic API and removing it soon after that doesn't sound a good
> developing maner.

Yes, it is just a temporary solution. Just enhancing an existing temporary solution.

Thanks,

Marin Mitov

> 
