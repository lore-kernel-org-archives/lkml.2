Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933000Ab2IRMtn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 08:49:43 -0400
Received: from am1ehsobe004.messaging.microsoft.com ([213.199.154.207]:36286
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757515Ab2IRMth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 08:49:37 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz98dI1432Id6f1izz1202h1d1ah1d2ahzz15d4Iz2dh668h839h944hd25he5bhf0ah11b5h121eh1220h1288h12a5h12a9h12bdh1155h)
X-WSS-ID: 0MAJQA7-01-2NQ-02
X-M-MSG: 
Date: Tue, 18 Sep 2012 14:49:18 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Hiroshi Doyu <hdoyu@nvidia.com>
CC: <m.szyprowski@samsung.com>, <linux@arm.linux.org.uk>, <arnd@arndb.de>,
        <minchan@kernel.org>, <chunsang.jeong@linaro.org>,
        <linux-kernel@vger.kernel.org>, <subashrp@gmail.com>,
        <linaro-mm-sig@lists.linaro.org>, <linux-mm@kvack.org>,
        <iommu@lists.linux-foundation.org>, <vdumpa@nvidia.com>,
        <linux-tegra@vger.kernel.org>, <kyungmin.park@samsung.com>,
        <pullip.cho@samsung.com>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC 0/5] ARM: dma-mapping: New dma_map_ops to control IOVA more
 precisely
Message-ID: <20120918124918.GK2505@amd.com>
References: <1346223335-31455-1-git-send-email-hdoyu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1346223335-31455-1-git-send-email-hdoyu@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 29, 2012 at 09:55:30AM +0300, Hiroshi Doyu wrote:
> The following APIs are needed for us to support the legacy Tegra
> memory manager for devices("NvMap") with *DMA mapping API*.

Maybe I am not understanding the need completly. Can you elaborate on
why this is needed for legacy Tegra?

> New API:
> 
>  ->iova_alloc(): To allocate IOVA area.
>  ->iova_alloc_at(): To allocate IOVA area at specific address.
>  ->iova_free():  To free IOVA area.
> 
>  ->map_page_at(): To map page at specific IOVA.

This sounds like a layering violation. The situation today is as
follows:

	DMA-API   : Handle DMA-addresses including an address allocator
	IOMMU-API : Full control over DMA address space, no address
	            allocator

So what you want to do add to the DMA-API is already part of the
IOMMU-API.

Here is my suggestion what you can do instead of extending the DMA-API.
You can use the IOMMU-API to initialize the device address space with
any mappings at the IOVAs you need the mappings. In the end you allocate
another free range in the device address space and use that to satisfy
DMA-API allocations. Any reason why that could not work?


Regards,

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

