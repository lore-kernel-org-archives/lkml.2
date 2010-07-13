Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504Ab0GMF5L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 01:57:11 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:57348 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210Ab0GMF5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 01:57:08 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6041"; a="47297323"
Message-ID: <4C3C0032.5020702@codeaurora.org>
Date: Mon, 12 Jul 2010 22:57:06 -0700
From: Zach Pfeffer <zpfeffer@codeaurora.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: linux@arm.linux.org.uk, ebiederm@xmission.com, linux-arch@vger.kernel.org,
        dwalker@codeaurora.org, mel@csn.ul.ie, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, andi@firstfloor.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC 1/3 v3] mm: iommu: An API to unify IOMMU, CPU and device
 memory management
References: <4C35034B.6040906@codeaurora.org>	<20100707230710.GA31792@n2100.arm.linux.org.uk>	<4C366678.60605@codeaurora.org> <20100712102435B.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100712102435B.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori wrote:
> On Thu, 08 Jul 2010 16:59:52 -0700
> Zach Pfeffer <zpfeffer@codeaurora.org> wrote:
> 
>> The problem I'm trying to solve boils down to this: map a set of
>> contiguous physical buffers to an aligned IOMMU address. I need to
>> allocate the set of physical buffers in a particular way: use 1 MB
>> contiguous physical memory, then 64 KB, then 4 KB, etc. and I need to
>> align the IOMMU address in a particular way.
> 
> Sounds like the DMA API already supports what you want.
> 
> You can set segment_boundary_mask in struct device_dma_parameters if
> you want to align the IOMMU address. See IOMMU implementations that
> support dma_get_seg_boundary() properly.

That function takes the wrong argument in a VCM world:

unsigned long dma_get_seg_boundary(struct device *dev);

The boundary should be an attribute of the device side mapping,
independent of the device. This would allow better code reuse.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
