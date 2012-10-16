Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777Ab2JPI7s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 04:59:48 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:53070 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950Ab2JPI7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 04:59:46 -0400
Date: Tue, 16 Oct 2012 09:59:28 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Hiroshi Doyu <hdoyu@nvidia.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Inki Dae <inki.dae@samsung.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-tegra@vger.kernel.org
Subject: Re: [Linaro-mm-sig] [RFC 0/2] DMA-mapping & IOMMU - physically
	contiguous allocations
Message-ID: <20121016085928.GV21164@n2100.arm.linux.org.uk>
References: <1350309832-18461-1-git-send-email-m.szyprowski@samsung.com> <CAAQKjZMYFNMEnb2ue2aR+6AEbOixnQFyggbXrThBCW5VOznePg@mail.gmail.com> <20121016090434.7d5e088152a3e0b0606903c8@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121016090434.7d5e088152a3e0b0606903c8@nvidia.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2012 at 09:04:34AM +0300, Hiroshi Doyu wrote:
> In addition to those contiguous/discontiguous page allocation, is
> there any way to _import_ anonymous pages allocated by a process to be
> used in dma-mapping API later?
> 
> I'm considering the following scenario, an user process allocates a
> buffer by malloc() in advance, and then it asks some driver to convert
> that buffer into IOMMU'able/DMA'able ones later. In this case, pages
> are discouguous and even they may not be yet allocated at
> malloc()/mmap().

That situation is covered.  It's the streaming API you're wanting for that.
dma_map_sg() - but you may need additional cache handling via
flush_dcache_page() to ensure that your code is safe for all CPU cache
architectures.

Remember that pages allocated into userspace will be cacheable, so a cache
flush is required before they can be DMA'd.  Hence the streaming API.
