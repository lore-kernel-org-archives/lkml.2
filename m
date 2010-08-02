Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438Ab0HBP0f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 11:26:35 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:32197 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752873Ab0HBP0b (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 2 Aug 2010 11:26:31 -0400
Date: Mon, 2 Aug 2010 11:25:52 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, hpa@zytor.com
Cc: jeremy@goop.org, Ian.Campbell@citrix.com, albert_herranz@yahoo.es,
        x86@kernel.org, linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org,
        iommu@lists.linux-foundation.org, tglx@linutronix.de
Subject: Re: [PATCH 9/9] x86: Detect whether we should use Xen SWIOTLB.
Message-ID: <20100802152552.GA4732@phenom.dumpdata.com>
References: <20100728095157I.fujita.tomonori@lab.ntt.co.jp>
 <20100728223816.GB32739@phenom.dumpdata.com>
 <4C50B4C2.2070807@zytor.com>
 <20100729161653G.fujita.tomonori@lab.ntt.co.jp>
 <20100729160557.GA4403@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100729160557.GA4403@phenom.dumpdata.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4C56E394.0098:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I can eliminate step c) by making a) 'pci_xen_swiotlb_detect' do
> what it does now and also utilize the x86_init.iommu.iommu_init.
> In essence making it an IOMMU-type-ish.
> 
> The patch is on top of the other patches and the only reason I am calling
> in 'pci_iommu_alloc' the 'pci_xen_swiotlb_detect' before 'pci_swiotlb_detect'
> is because a user could specify 'swiotlb=force' and that would bypass the
> Xen SWIOTLB detection code and end up using the wrong dma_ops (under Xen
> of course). Oh, and I added a check in gart_iommu_hole_init() to stop it
> from setting the iommu_init to its own.
> 
> What do you guys think?

And silence ensues. Let me back up a bit as I think I am heading the
wrong way.

hpa, are your concerns that a) inserting a sub-system call in the
generic code is not good. Or b) that we have five IOMMUs (counting SWIOTLB in that
category) and that we don't jettison from memory the ones we don't need
(that would be the primary goal of driverization of those IOMMUs,
right?). Or c) we should remove all sub-system detect calls (Calgary, AMD,
Intel, AGP) altogether from pci-dma.c and depend more on
x86_init.iommu structure (perhaps expend it?)
