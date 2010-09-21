Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756813Ab0IUVtu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 17:49:50 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:8975 "EHLO
	VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755901Ab0IUVtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 17:49:49 -0400
X-SpamScore: -20
X-BigFish: VS-20(zz1432N98dN9371Pzz1202hzz8275bhz2dh2a8h61h)
X-Spam-TCS-SCL: 0:0
Date: Tue, 21 Sep 2010 16:49:44 -0500
From: Scott Wood <scottwood@freescale.com>
To: Timur Tabi <timur.tabi@gmail.com>
CC: Kumar Gala <galak@kernel.crashing.org>, dan.j.williams@intel.com,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fsldma: add support to 36-bit physical address
Message-ID: <20100921164944.164ed0af@udp111988uds.am.freescale.net>
In-Reply-To: <AANLkTine--kry0c0n87WOqYyi3AQOb2KnmNRs-MeXcQt@mail.gmail.com>
References: <1285066638-7473-1-git-send-email-leoli@freescale.com>
	<877FD0B5-19A7-4A16-831E-369B80B104EA@kernel.crashing.org>
	<AANLkTimiwtoa6i10OTcgFnvbvcO9N4KWHyt4Poj-yj=T@mail.gmail.com>
	<20100921163456.7e2c9b32@udp111988uds.am.freescale.net>
	<AANLkTine--kry0c0n87WOqYyi3AQOb2KnmNRs-MeXcQt@mail.gmail.com>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Sep 2010 21:49:45.0431 (UTC) FILETIME=[E7A36670:01CB59D6]
X-Reverse-DNS: de01egw02.freescale.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Sep 2010 16:43:12 -0500
Timur Tabi <timur.tabi@gmail.com> wrote:

> On Tue, Sep 21, 2010 at 4:34 PM, Scott Wood <scottwood@freescale.com> wrote:
> 
> > This doesn't control allocation (it probably should with
> > dma_alloc_coherent, though I don't see it in the code), it controls
> > whether swiotlb will create a bounce buffer -- defeating the point of
> > using DMA to accelerate a memcpy.
> 
> But it would do that only for the 'dev' used in the dma_set_mask()
> call.  That dev is only used here:
> 
> 	chan->desc_pool = dma_pool_create("fsl_dma_engine_desc_pool",
> 					  chan->dev,
> 					  sizeof(struct fsl_desc_sw),
> 					  __alignof__(struct fsl_desc_sw), 0);
> 
> Since we don't DMA the descriptors themselves, I just don't see how
> this patch does anything.

Look in dmaengine.c, there are calls to dma_map_single() and
dma_map_page(), using what I assume is that same device pointer --
unless there's confusion between the channel and the controller.

-Scott

