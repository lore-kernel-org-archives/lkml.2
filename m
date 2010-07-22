Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756775Ab0GVDub (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 23:50:31 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:35069 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754192Ab0GVDu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 23:50:29 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6050"; a="48241574"
Date: Wed, 21 Jul 2010 20:50:26 -0700
From: Zach Pfeffer <zpfeffer@codeaurora.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux@arm.linux.org.uk, alan@lxorguk.ukuu.org.uk, randy.dunlap@oracle.com,
        dwalker@codeaurora.org, mel@csn.ul.ie, linux-arm-msm@vger.kernel.org,
        joro@8bytes.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        andi@firstfloor.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC 3/3] mm: iommu: The Virtual Contiguous Memory Manager
Message-ID: <20100722035026.GB14176@codeaurora.org>
References: <20100713094244.7eb84f1b@lxorguk.ukuu.org.uk>
 <20100713174519D.fujita.tomonori@lab.ntt.co.jp>
 <20100713090223.GB20590@n2100.arm.linux.org.uk>
 <20100714105922D.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100714105922D.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 14, 2010 at 10:59:43AM +0900, FUJITA Tomonori wrote:
> On Tue, 13 Jul 2010 10:02:23 +0100
> 
> Zach Pfeffer said this new VCM infrastructure can be useful for
> video4linux. However, I don't think we need 3,000-lines another
> abstraction layer to solve video4linux's issue nicely.

Its only 3000 lines because I haven't converted the code to use
function pointers.

> I can't find any reasonable reasons that we need to merge VCM; seems
> that the combination of the current APIs (or with some small
> extensions) can work for the issues that VCM tries to solve.

Getting back to the point. There is no API that can handle large
buffer allocation and sharing with low-level attribute control for
virtual address spaces outside the CPU. At this point if you need to
work with big buffers, 1 MB and 16 MB etc, and map those big buffers
to non-CPU virtual spaces you need to explicitly carve them out and
set up the mappings and sharing by hand. Its reasonable to have an API
that can do this especially since IOMMUs are going to become more
prevalent. The DMA API et al. take a CPU centric view of virtual space
management, sharing has to be explicitly written and external virtual
space management is left up to device driver writers. Given a system
where each device has an IOMMU or a MMU the whole concept of a
scatterlist goes away. The VCM API gets a jump on it.
