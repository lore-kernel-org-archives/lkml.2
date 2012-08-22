Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754933Ab2HVMEr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 08:04:47 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:63074 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753143Ab2HVMEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 08:04:44 -0400
X-AuditID: cbfee61a-b7fc66d0000043b7-a5-5034cada6642
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: "'Hiroshi Doyu'" <hdoyu@nvidia.com>
Cc: linux-arm-kernel@lists.infradead.org, linaro-mm-sig@lists.linaro.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kyungmin.park@samsung.com, arnd@arndb.de, linux@arm.linux.org.uk,
        chunsang.jeong@linaro.org, "'Krishna Reddy'" <vdumpa@nvidia.com>,
        konrad.wilk@oracle.com, subashrp@gmail.com, minchan@kernel.org
References: <1345630830-9586-1-git-send-email-hdoyu@nvidia.com>
In-reply-to: <1345630830-9586-1-git-send-email-hdoyu@nvidia.com>
Subject: RE: [RFC 0/4] ARM: dma-mapping: IOMMU atomic allocation
Date: Wed, 22 Aug 2012 14:04:26 +0200
Organization: SPRC
Message-id: <005901cd805e$4afd2e40$e0f78ac0$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2AT8wu1zPuTsKcR4m2C7+upU+9RAABJ9DQ
Content-language: pl
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOLMWRmVeSWpSXmKPExsVy+t9jQd1bp0wCDGZNMrC4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZUx5NZCnYwlHRtvQMYwPjA7YuRk4OCQETiWO/3rFA2GISF+6t
	B4pzcQgJTGeUeHi/jx3CmcUksefJJiaQKjYBQ4mut11AVRwcIgKqEk/nMoLUMAscYZK43/QH
	bKqQgL3E9f4JrCA2p4CDxOmvz5hB6oWB7J6ffiBhFqDWD4cPs4CE+QWEJCbOUgAJ8wq4SBy9
	coAFwhaU+DH5HpjNLKAlsX7ncSYIW15i85q3YBMlBNQlHv3VBQmLCBhJLOu8yghRIiJxt+E5
	6wRG4VlIJs1CMmkWkkmzkLQsYGRZxSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iREc3M+kdjCu
	bLA4xCjAwajEw+uRYBIgxJpYVlyZe4hRgoNZSYT30W6gEG9KYmVValF+fFFpTmrxIUZpDhYl
	cV7+PsMAIYH0xJLU7NTUgtQimCwTB6dUA2PDjj7Fy31nfX4wTP885V2iWfkOhVex826tFtwu
	qMy+6fWsp5f0GfU3eHYlGSlbs/0x2Xi3z8Y1wkX1uNT7TUv8T3bV7fqZsHyv4KS2A9YmL+y7
	j7syympab1nSmCGV1/22X2BXROWZ2A+d615oJH2LEZifK9Mq5ZO18v4swdnlCw+UFyzMblBi
	Kc5INNRiLipOBAChQwieagIAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hiroshi,

On Wednesday, August 22, 2012 12:20 PM Hiroshi Doyu wrote:

> The commit e9da6e9 "ARM: dma-mapping: remove custom consistent dma
> region" breaks the compatibility with existing drivers. This causes
> the following kernel oops(*1). That driver has called dma_pool_alloc()
> to allocate memory from the interrupt context, and it hits
> BUG_ON(in_interrpt()) in "get_vm_area_caller()". This patch seris
> fixes this problem with making use of the pre-allocate atomic memory
> pool which DMA is using in the same way as DMA does now.
> 
> Any comment would be really appreciated.

I was working on the similar patches, but You were faster. ;-)

Basically the patch no 1 and 2 are fine, but I don't like the changes proposed in 
patch 3 and 4. You should not alter the attributes provided by the user nor make any
assumptions that such attributes has been provided - drivers are allowed to call 
dma_alloc_attrs() directly. Please rework your patches to avoid such approach.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center



