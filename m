Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751028Ab0G2EQI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 00:16:08 -0400
Received: from sh.osrg.net ([192.16.179.4]:40053 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750735Ab0G2EQE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 00:16:04 -0400
Date: Thu, 29 Jul 2010 13:15:37 +0900
To: linux@arm.linux.org.uk
Cc: arnd@arndb.de, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, dwalker@codeaurora.org,
        stepanm@codeaurora.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] arm: msm: Add System MMU support.
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100728212156.GA6729@n2100.arm.linux.org.uk>
References: <ea4bbdecc271f7fa5749d09645f38c0d.squirrel@www.codeaurora.org>
	<201007281950.20847.arnd@arndb.de>
	<20100728212156.GA6729@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100729131500Q.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 29 Jul 2010 13:15:39 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Jul 2010 22:21:56 +0100
Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:

> On Wed, Jul 28, 2010 at 07:50:20PM +0200, Arnd Bergmann wrote:
> > The DMA API is extremely flexible, it works just fine with all the
> > IOMMUs that I've seen so far. Please take a look at
> > include/asm-generic/dma-mapping-common.h and its users to see how
> > to use multiple IOMMUs depending on the device.
> 
> We don't yet use those DMA API interface extensions because we haven't
> had the need.  If someone who has the need wants to put the effort in
> though...
> 
> One of the problems with it though is the abstraction of the sync*
> operations is the wrong way around for stuff like dmabounce - we want
> to be passed the base address of the buffer (so we can look this up),
> plus offset and length.  We don't want to know just the region which
> is affected.

We can't pass the base address because the DMA API callers don't pass
the base address for dma_sync_single_for_{device|cpu}.

dma_sync_single_range_for_* requires the base address but they are
obsolete.

So you need to fix dmabounce. Actually, I send you a patch to fix
dmabounce long ago (looks like not applied yet):

http://kerneltrap.org/mailarchive/linux-netdev/2010/4/5/6274046
