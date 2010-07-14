Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328Ab0GNCA6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 22:00:58 -0400
Received: from sh.osrg.net ([192.16.179.4]:34860 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752853Ab0GNCA4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 22:00:56 -0400
Date: Wed, 14 Jul 2010 10:59:38 +0900
To: zpfeffer@codeaurora.org
Cc: fujita.tomonori@lab.ntt.co.jp, linux@arm.linux.org.uk,
        ebiederm@xmission.com, linux-arch@vger.kernel.org,
        dwalker@codeaurora.org, mel@csn.ul.ie, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, andi@firstfloor.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC 1/3 v3] mm: iommu: An API to unify IOMMU, CPU and device
 memory management
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100713121420.GB4263@codeaurora.org>
References: <4C3C0032.5020702@codeaurora.org>
	<20100713150311B.fujita.tomonori@lab.ntt.co.jp>
	<20100713121420.GB4263@codeaurora.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100714104353B.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 14 Jul 2010 10:59:43 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Jul 2010 05:14:21 -0700
Zach Pfeffer <zpfeffer@codeaurora.org> wrote:

> > You mean that you want to specify this alignment attribute every time
> > you create an IOMMU mapping? Then you can set segment_boundary_mask
> > every time you create an IOMMU mapping. It's odd but it should work.
> 
> Kinda. I want to forget about IOMMUs, devices and CPUs. I just want to
> create a mapping that has the alignment I specify, regardless of the
> mapper. The mapping is created on a VCM and the VCM is associated with
> a mapper: a CPU, an IOMMU'd device or a direct mapped device.

Sounds like you can do the above with the combination of the current
APIs, create a virtual address and then an I/O address.

The above can't be a reason to add a new infrastructure includes more
than 3,000 lines.
 

> > Another possible solution is extending struct dma_attrs. We could add
> > the alignment attribute to it.
> 
> That may be useful, but in the current DMA-API may be seen as
> redundant info.

If there is real requirement, we can extend the DMA-API.
