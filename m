Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752427Ab0GMGEX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 02:04:23 -0400
Received: from sh.osrg.net ([192.16.179.4]:55876 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751032Ab0GMGEU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 02:04:20 -0400
Date: Tue, 13 Jul 2010 15:03:25 +0900
To: zpfeffer@codeaurora.org
Cc: fujita.tomonori@lab.ntt.co.jp, linux@arm.linux.org.uk,
        ebiederm@xmission.com, linux-arch@vger.kernel.org,
        dwalker@codeaurora.org, mel@csn.ul.ie, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, andi@firstfloor.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC 1/3 v3] mm: iommu: An API to unify IOMMU, CPU and device
 memory management
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <4C3C0032.5020702@codeaurora.org>
References: <4C366678.60605@codeaurora.org>
	<20100712102435B.fujita.tomonori@lab.ntt.co.jp>
	<4C3C0032.5020702@codeaurora.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100713150311B.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 13 Jul 2010 15:03:29 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Jul 2010 22:57:06 -0700
Zach Pfeffer <zpfeffer@codeaurora.org> wrote:

> FUJITA Tomonori wrote:
> > On Thu, 08 Jul 2010 16:59:52 -0700
> > Zach Pfeffer <zpfeffer@codeaurora.org> wrote:
> > 
> >> The problem I'm trying to solve boils down to this: map a set of
> >> contiguous physical buffers to an aligned IOMMU address. I need to
> >> allocate the set of physical buffers in a particular way: use 1 MB
> >> contiguous physical memory, then 64 KB, then 4 KB, etc. and I need to
> >> align the IOMMU address in a particular way.
> > 
> > Sounds like the DMA API already supports what you want.
> > 
> > You can set segment_boundary_mask in struct device_dma_parameters if
> > you want to align the IOMMU address. See IOMMU implementations that
> > support dma_get_seg_boundary() properly.
> 
> That function takes the wrong argument in a VCM world:
> 
> unsigned long dma_get_seg_boundary(struct device *dev);
> 
> The boundary should be an attribute of the device side mapping,
> independent of the device. This would allow better code reuse.

You mean that you want to specify this alignment attribute every time
you create an IOMMU mapping? Then you can set segment_boundary_mask
every time you create an IOMMU mapping. It's odd but it should work.

Another possible solution is extending struct dma_attrs. We could add
the alignment attribute to it.
