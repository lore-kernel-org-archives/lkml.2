Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132Ab0G2IM7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 04:12:59 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:54210 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753944Ab0G2IMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 04:12:55 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 1/2] arm: msm: Add System MMU support.
Date: Thu, 29 Jul 2010 10:12:05 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc4-next-20100709+; KDE/4.4.90; x86_64; ; )
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        linux-arm-msm@vger.kernel.org, dwalker@codeaurora.org,
        stepanm@codeaurora.org, linux-kernel@vger.kernel.org
References: <1280270466-13503-1-git-send-email-stepanm@codeaurora.org> <201007281950.20847.arnd@arndb.de> <20100728212156.GA6729@n2100.arm.linux.org.uk>
In-Reply-To: <20100728212156.GA6729@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007291012.05986.arnd@arndb.de>
X-Provags-ID: V02:K0:B0lj18c3zyyLGGCVrkVrSQlyQLz51KlfmG9rbxmJIqO
 /0YlteJC0ASqF2cZnmZwDzn5PLmjcEHz/2lq0Y96s1QlIfQSNB
 yQU+vrs6UW8EWdk69TEM6c1coDnjv8UoCshpubAZ3lsJhVnNEH
 nTVvNA9JlpwA4kkgY5bkbSARrcnbgCUC/Ztcn3MOLCwW6Y1n4W
 V3mCLLnFmKWTTBHYTDIZQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 July 2010 23:21:56 Russell King - ARM Linux wrote:
> On Wed, Jul 28, 2010 at 07:50:20PM +0200, Arnd Bergmann wrote:
> > The DMA API is extremely flexible, it works just fine with all the
> > IOMMUs that I've seen so far. Please take a look at
> > include/asm-generic/dma-mapping-common.h and its users to see how
> > to use multiple IOMMUs depending on the device.
> 
> We don't yet use those DMA API interface extensions because we haven't
> had the need.  If someone who has the need wants to put the effort in
> though...

Right, it shouldn't be hard now that the groundwork for that is done.
Also, it's only really needed if you have IOMMUs of different types in the
same system. If msm doesn't have any swiotlb or dmabounce devices,
it could always use the same implementation for all devices.

> One of the problems with it though is the abstraction of the sync*
> operations is the wrong way around for stuff like dmabounce - we want
> to be passed the base address of the buffer (so we can look this up),
> plus offset and length.  We don't want to know just the region which
> is affected.

Yes, but that is an unrelated (dmabounce specific) problem that seems to
be fixed by an existing patch.

The driver posted by Stepan doesn't even support the dma_sync_single_*
style operations, and I don't think it can run into that specific problem.
Are there even (hardware) IOMMUs that are connected to noncoherent
buses? AFAICT, anything that needs to flush a dcache range in dma_sync_*
has a trivial mapping between bus and phys addresses.

	Arnd
