Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796Ab0IUVfG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 17:35:06 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:47448 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620Ab0IUVfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 17:35:05 -0400
X-SpamScore: -20
X-BigFish: VS-20(zz1432N98dN9371Pzz1202hzz8275bh8275dhz2dh2a8h61h)
X-Spam-TCS-SCL: 0:0
Date: Tue, 21 Sep 2010 16:34:56 -0500
From: Scott Wood <scottwood@freescale.com>
To: Timur Tabi <timur.tabi@gmail.com>
CC: Kumar Gala <galak@kernel.crashing.org>, dan.j.williams@intel.com,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fsldma: add support to 36-bit physical address
Message-ID: <20100921163456.7e2c9b32@udp111988uds.am.freescale.net>
In-Reply-To: <AANLkTimiwtoa6i10OTcgFnvbvcO9N4KWHyt4Poj-yj=T@mail.gmail.com>
References: <1285066638-7473-1-git-send-email-leoli@freescale.com>
	<877FD0B5-19A7-4A16-831E-369B80B104EA@kernel.crashing.org>
	<AANLkTimiwtoa6i10OTcgFnvbvcO9N4KWHyt4Poj-yj=T@mail.gmail.com>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Sep 2010 21:34:57.0838 (UTC) FILETIME=[D69774E0:01CB59D4]
X-Reverse-DNS: az33egw02.freescale.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Sep 2010 16:24:10 -0500
Timur Tabi <timur.tabi@gmail.com> wrote:

> On Tue, Sep 21, 2010 at 7:55 AM, Kumar Gala <galak@kernel.crashing.org> wrote:
> >
> > On Sep 21, 2010, at 5:57 AM, Li Yang wrote:
> >
> >> Signed-off-by: Li Yang <leoli@freescale.com>
> >> ---
> >
> > We really should have a sentence about how or why this works to address 36-bit addressing.
> 
> For example, I would like to know which memory is going to be
> allocated above 4GB.  I don't know much about the kernel's async
> library, but my understanding is that fsldma does not allocate any of
> the memory buffers that it copies data to/from.

This doesn't control allocation (it probably should with
dma_alloc_coherent, though I don't see it in the code), it controls
whether swiotlb will create a bounce buffer -- defeating the point of
using DMA to accelerate a memcpy.

-Scott

