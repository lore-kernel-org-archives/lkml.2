Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756998Ab0IUWSR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 18:18:17 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:40316 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755540Ab0IUWSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 18:18:13 -0400
X-SpamScore: -25
X-BigFish: VS-25(zz1432N98dN1521M9371Pzz1202hzz8275bhz2dh2a8h61h)
X-Spam-TCS-SCL: 0:0
Date: Tue, 21 Sep 2010 17:17:46 -0500
From: Scott Wood <scottwood@freescale.com>
To: Timur Tabi <timur.tabi@gmail.com>
CC: Dan Malek <ppc6dev@digitaldans.com>, dan.j.williams@intel.com,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fsldma: add support to 36-bit physical address
Message-ID: <20100921171746.381f2e89@udp111988uds.am.freescale.net>
In-Reply-To: <AANLkTinKbBBbC1gmPewhn1f3MW-1MbARtiQZNX4w7Mi+@mail.gmail.com>
References: <1285066638-7473-1-git-send-email-leoli@freescale.com>
	<877FD0B5-19A7-4A16-831E-369B80B104EA@kernel.crashing.org>
	<AANLkTimiwtoa6i10OTcgFnvbvcO9N4KWHyt4Poj-yj=T@mail.gmail.com>
	<20100921163456.7e2c9b32@udp111988uds.am.freescale.net>
	<AANLkTine--kry0c0n87WOqYyi3AQOb2KnmNRs-MeXcQt@mail.gmail.com>
	<20100921164944.164ed0af@udp111988uds.am.freescale.net>
	<2C3F2C02-35B6-46AF-82DA-44ACCBFB8362@digitaldans.com>
	<AANLkTinKbBBbC1gmPewhn1f3MW-1MbARtiQZNX4w7Mi+@mail.gmail.com>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Sep 2010 22:17:47.0775 (UTC) FILETIME=[D264B8F0:01CB59DA]
X-Reverse-DNS: az33egw01.freescale.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Sep 2010 17:08:54 -0500
Timur Tabi <timur.tabi@gmail.com> wrote:

> On Tue, Sep 21, 2010 at 5:05 PM, Dan Malek <ppc6dev@digitaldans.com> wrote:
> 
> > The DMA descriptors are accessed using DMA by the
> > controller itself.
> 
> Yes and no.  Technically, it is DMA, but it's not something that
> SWIOTLB could ever know about.  We just pass the physical address to
> the DMA controller, and it does a memory read to obtain the data.
> That's not the kind of DMA that SWIOTLB would deal with, I think.

SWIOTLB should see that the address is directly DMAable and do nothing,
but you don't want to skip the DMA API altogether.  You still need to
flush caches if DMA is noncoherent, etc.

> My question is, should dmaengine be using the same 'dev' that fsldma
> uses to allocate the DMA descriptors?  I wonder if the 'dev' should be
> allocated internally by dmaengine, or provided by the client drivers.

It needs to be the actual device that is performing the DMA -- the
platform may need to do things such as IOMMU manipulation where
knowing the device matters.

-Scott

