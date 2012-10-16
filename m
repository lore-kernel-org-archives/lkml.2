Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753631Ab2JPK2M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 06:28:12 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:5816 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193Ab2JPK2K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 06:28:10 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Tue, 16 Oct 2012 03:28:02 -0700
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>
CC: "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "inki.dae@samsung.com" <inki.dae@samsung.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Date: Tue, 16 Oct 2012 12:27:55 +0200
Subject: Re: [Linaro-mm-sig] [RFC 0/2] DMA-mapping & IOMMU - physically
 contiguous allocations
Thread-Topic: [Linaro-mm-sig] [RFC 0/2] DMA-mapping & IOMMU - physically
 contiguous allocations
Thread-Index: Ac2riOooZrAc82VmQtCUqeE7OlPJLQ==
Message-ID: <20121016.132755.661591248175727826.hdoyu@nvidia.com>
References: <CAAQKjZMYFNMEnb2ue2aR+6AEbOixnQFyggbXrThBCW5VOznePg@mail.gmail.com><20121016090434.7d5e088152a3e0b0606903c8@nvidia.com><20121016085928.GV21164@n2100.arm.linux.org.uk>
In-Reply-To: <20121016085928.GV21164@n2100.arm.linux.org.uk>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-nvconfidentiality: public
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

Russell King - ARM Linux <linux@arm.linux.org.uk> wrote @ Tue, 16 Oct 2012 10:59:28 +0200:

> On Tue, Oct 16, 2012 at 09:04:34AM +0300, Hiroshi Doyu wrote:
> > In addition to those contiguous/discontiguous page allocation, is
> > there any way to _import_ anonymous pages allocated by a process to be
> > used in dma-mapping API later?
> > 
> > I'm considering the following scenario, an user process allocates a
> > buffer by malloc() in advance, and then it asks some driver to convert
> > that buffer into IOMMU'able/DMA'able ones later. In this case, pages
> > are discouguous and even they may not be yet allocated at
> > malloc()/mmap().
> 
> That situation is covered.  It's the streaming API you're wanting for that.
> dma_map_sg() - but you may need additional cache handling via
> flush_dcache_page() to ensure that your code is safe for all CPU cache
> architectures.
>
> Remember that pages allocated into userspace will be cacheable, so a cache
> flush is required before they can be DMA'd.  Hence the streaming
> API.

Is the syscall "cacheflush()" supposed to be the knob for that?

Or is there any other ones to have more precise control, "clean",
"invalidate" and "flush", from userland in generic way?
