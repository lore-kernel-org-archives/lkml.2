Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756446Ab1D0O3k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 10:29:40 -0400
Received: from service87.mimecast.com ([94.185.240.25]:53190 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753369Ab1D0O3i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 10:29:38 -0400
Subject: Re: [RFC] ARM DMA mapping TODO, v1
From: Catalin Marinas <catalin.marinas@arm.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: arnd@arndb.de, linaro-mm-sig@lists.linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <20110427230344I.fujita.tomonori@lab.ntt.co.jp>
References: <201104212129.17013.arnd@arndb.de>
	 <BANLkTinPbZZS9F1tRCA73fgoD-y__jSfCA@mail.gmail.com>
	 <20110427230344I.fujita.tomonori@lab.ntt.co.jp>
Organization: ARM Limited
Date: Wed, 27 Apr 2011 15:29:30 +0100
Message-ID: <1303914570.15101.33.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1
X-OriginalArrivalTime: 27 Apr 2011 14:29:31.0456 (UTC) FILETIME=[85BC2C00:01CC04E7]
X-MC-Unique: 111042715293500801
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-27 at 15:06 +0100, FUJITA Tomonori wrote:
> On Wed, 27 Apr 2011 10:52:25 +0100
> Catalin Marinas <catalin.marinas@arm.com> wrote:
> 
> > Anyway, we end up with different DMA ops per device via dev_archdata.
> 
> Several architectures already do. What's wrong with the approach for
> arm?

Nothing wrong IMHO but it depends on how you group the DMA ops as it may
not be feasible to have all the combinations dmabounce/iommu/coherency
combinations. I think the main combinations would be:

1. standard (no-iommu) + non-coherent
2. standard (no-iommu) + coherent
3. iommu + non-coherent
4. iommu + coherent
5. dmabounce + non-coherent
6. dmabounce + coherent

I think dmabounce and iommu can be exclusive (unless the iommu cannot
access the whole RAM). If that's the case, we can have three type of DMA
ops:

1. standard
2. iommu
3. dmabounce

with an additional flag via dev_archdata for cache coherency level (a
device may be able to snoop the L1 or L2 cache etc.)

-- 
Catalin


