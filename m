Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014Ab2IJKVj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 06:21:39 -0400
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:49577 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751741Ab2IJKVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 06:21:37 -0400
MIME-Version: 1.0
In-Reply-To: <20120908101420.GA28448@n2100.arm.linux.org.uk>
References: <CADysL2bGP_FKW4dnxM4zbziOPfrbAemRazZYd_mS9i++bZGcqQ@mail.gmail.com>
	<20120908101420.GA28448@n2100.arm.linux.org.uk>
Date: Mon, 10 Sep 2012 15:51:35 +0530
Message-ID: <CADysL2Y7RP1OUthWri2v6cSqk-CRTh2R7urec7P2NdhaZ09KmA@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] ARM: new cache maintenance api for iommu
From: "Gupta, Ramesh" <grgupta@ti.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, tony@atomide.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,


On Sat, Sep 8, 2012 at 3:44 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Thu, Jul 05, 2012 at 10:50:17AM +0530, Gupta, Ramesh wrote:
>> + *   flush_iommu_mem(start, end)
>> + *
>> + *           Clean and invalidate the specified virtual address range.
>> + *           This is to support the non coherent iommu drivers.
>> + *           The iommu driver need to call this api with the page
>> + *           table memory address range to ensure the data held in
>> + *           the cache is visible to the slave processor MMU.
>> + *           - start  - virtual start address
>> + *           - end    - virtual end address
>
> I think:
>         iommu_flush_range(start, end)
> or
>         iommu_flush_area(start, size)
>                 Perform CPU specific cache operations are required to
>                 ensure that the IOMMU page table mappings covering the
>                 specified block of memory are visiable to the IOMMU.

I prefer iommu_flush_area(start, size).

>
> Notice that it's defined by purpose, not by implementation.  Also notice
> the distinction between _range taking two addresses, and _area taking
> a start plus size.
> Also notice that it is defined just for IOMMU page tables, not for general
> data for other processors.

Agree with your comments, may be I can add an explicit comment for not
using these apis other than IOMMU page tables.


> Note that iommu_flush_area is safer if your virt_to_phys() are non-linear.

Agree, I will send an updated patch series with iommu_flush_area.

thank you for the review comments.

Best regards
Ramesh Gupta G
