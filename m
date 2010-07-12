Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499Ab0GLB1B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 21:27:01 -0400
Received: from sh.osrg.net ([192.16.179.4]:47846 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752608Ab0GLB1A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 21:27:00 -0400
Date: Mon, 12 Jul 2010 10:25:08 +0900
To: zpfeffer@codeaurora.org
Cc: linux@arm.linux.org.uk, ebiederm@xmission.com, linux-arch@vger.kernel.org,
        dwalker@codeaurora.org, mel@csn.ul.ie, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, andi@firstfloor.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC 1/3 v3] mm: iommu: An API to unify IOMMU, CPU and device
 memory management
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <4C366678.60605@codeaurora.org>
References: <4C35034B.6040906@codeaurora.org>
	<20100707230710.GA31792@n2100.arm.linux.org.uk>
	<4C366678.60605@codeaurora.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100712102435B.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 12 Jul 2010 10:25:15 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 08 Jul 2010 16:59:52 -0700
Zach Pfeffer <zpfeffer@codeaurora.org> wrote:

> The problem I'm trying to solve boils down to this: map a set of
> contiguous physical buffers to an aligned IOMMU address. I need to
> allocate the set of physical buffers in a particular way: use 1 MB
> contiguous physical memory, then 64 KB, then 4 KB, etc. and I need to
> align the IOMMU address in a particular way.

Sounds like the DMA API already supports what you want.

You can set segment_boundary_mask in struct device_dma_parameters if
you want to align the IOMMU address. See IOMMU implementations that
support dma_get_seg_boundary() properly.
