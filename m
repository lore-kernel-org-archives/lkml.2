Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759018Ab1D0Oek (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 10:34:40 -0400
Received: from sh.osrg.net ([192.16.179.4]:56627 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758912Ab1D0Oei (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 10:34:38 -0400
Date: Wed, 27 Apr 2011 23:34:16 +0900
To: catalin.marinas@arm.com
Cc: fujita.tomonori@lab.ntt.co.jp, arnd@arndb.de,
        linaro-mm-sig@lists.linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] ARM DMA mapping TODO, v1
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1303914570.15101.33.camel@e102109-lin.cambridge.arm.com>
References: <BANLkTinPbZZS9F1tRCA73fgoD-y__jSfCA@mail.gmail.com>
	<20110427230344I.fujita.tomonori@lab.ntt.co.jp>
	<1303914570.15101.33.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20110427233156M.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 27 Apr 2011 23:34:16 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Apr 2011 15:29:30 +0100
Catalin Marinas <catalin.marinas@arm.com> wrote:

> On Wed, 2011-04-27 at 15:06 +0100, FUJITA Tomonori wrote:
> > On Wed, 27 Apr 2011 10:52:25 +0100
> > Catalin Marinas <catalin.marinas@arm.com> wrote:
> > 
> > > Anyway, we end up with different DMA ops per device via dev_archdata.
> > 
> > Several architectures already do. What's wrong with the approach for
> > arm?
> 
> Nothing wrong IMHO but it depends on how you group the DMA ops as it may
> not be feasible to have all the combinations dmabounce/iommu/coherency
> combinations. I think the main combinations would be:
> 
> 1. standard (no-iommu) + non-coherent
> 2. standard (no-iommu) + coherent
> 3. iommu + non-coherent
> 4. iommu + coherent
> 5. dmabounce + non-coherent
> 6. dmabounce + coherent
> 
> I think dmabounce and iommu can be exclusive (unless the iommu cannot
> access the whole RAM). If that's the case, we can have three type of DMA
> ops:
> 
> 1. standard
> 2. iommu
> 3. dmabounce
> 
> with an additional flag via dev_archdata for cache coherency level (a
> device may be able to snoop the L1 or L2 cache etc.)

Sounds nothing wrong to me too. I like to see arm people to switch
from dmabounce to swiotlb though.
