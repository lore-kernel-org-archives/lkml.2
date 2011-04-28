Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759162Ab1D1Kcq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 06:32:46 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:19991 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758198Ab1D1Kcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 06:32:45 -0400
Date: Thu, 28 Apr 2011 12:32:32 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [Linaro-mm-sig] [RFC] ARM DMA mapping TODO, v1
In-reply-to: <20110428093741.GV17290@n2100.arm.linux.org.uk>
To: "'Russell King - ARM Linux'" <linux@arm.linux.org.uk>,
        "'Benjamin Herrenschmidt'" <benh@kernel.crashing.org>
Cc: linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
        "'Arnd Bergmann'" <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org
Message-id: <003e01cc058f$94beb490$be3c1db0$%szyprowski@samsung.com>
Organization: SPRC
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
Thread-index: AcwFh/oBELAHNcGWQwGsX1As1NdVyAAAXj5A
References: <201104212129.17013.arnd@arndb.de>
 <20110427073514.GH17290@n2100.arm.linux.org.uk>
 <1303940271.2513.187.camel@pasglop>
 <20110428093741.GV17290@n2100.arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thursday, April 28, 2011 11:38 AM Russell King - ARM Linux wrote:

> > > > 2. Implement dma_alloc_noncoherent on ARM. Marek pointed out
> > > >    that this is needed, and it currently is not implemented, with
> > > >    an outdated comment explaining why it used to not be possible
> > > >    to do it.
> > >
> > > dma_alloc_noncoherent is an entirely pointless API afaics.
> >
> > I was about to ask what the point is ... (what is the expected
> > semantic ? Memory that is reachable but not necessarily cache
> > coherent ?)
> 
> As far as I can see, dma_alloc_noncoherent() should just be a wrapper
> around the normal page allocation function.  I don't see it ever needing
> to do anything special - and the advantage of just being the normal
> page allocation function is that its properties are well known and
> architecture independent.

If there is IOMMU chip that supports pages larger than 4KiB then
dma_alloc_noncoherent() might try to allocate such larger pages what will
result in faster access to the buffer (lower iommu tlb miss ratio).
For large buffers even 64KiB 'pages' gives a significant performance
improvement.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center

