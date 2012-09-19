Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756433Ab2ISMvg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 08:51:36 -0400
Received: from [216.32.180.184] ([216.32.180.184]:4961 "EHLO
	co1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752852Ab2ISMvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 08:51:33 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zz98dI1432Izz1202h1d1ah1d2ahzz15d4Iz2dh668h839h944hd25he5bhf0ah11b5h121eh1220h1288h12a5h12a9h12bdh1155h)
X-WSS-ID: 0MALKZW-01-5KC-02
X-M-MSG: 
Date: Wed, 19 Sep 2012 14:50:20 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: Hiroshi Doyu <hdoyu@nvidia.com>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "minchan@kernel.org" <minchan@kernel.org>,
        "chunsang.jeong@linaro.org" <chunsang.jeong@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "subashrp@gmail.com" <subashrp@gmail.com>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Krishna Reddy <vdumpa@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
        "pullip.cho@samsung.com" <pullip.cho@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC 0/5] ARM: dma-mapping: New dma_map_ops to control IOVA more
 precisely
Message-ID: <20120919125020.GQ2505@amd.com>
References: <1346223335-31455-1-git-send-email-hdoyu@nvidia.com>
 <20120918124918.GK2505@amd.com>
 <20120919095843.d1db155e0f085f4fcf64ea32@nvidia.com>
 <201209190759.46174.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <201209190759.46174.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 19, 2012 at 07:59:45AM +0000, Arnd Bergmann wrote:
> On Wednesday 19 September 2012, Hiroshi Doyu wrote:
> > I guess that it would work. Originally I thought that using DMA-API
> > and IOMMU-API together in driver might be kind of layering violation
> > since IOMMU-API itself is used in DMA-API. Only DMA-API used in driver
> > might be cleaner. Considering that DMA API traditionally handling
> > anonymous {bus,iova} address only, introducing the concept of
> > specific address in DMA API may not be so encouraged, though.
> > 
> > It would be nice to listen how other SoCs have solved similar needs.
> 
> In general, I would recommend using only the IOMMU API when you have a device
> driver that needs to control the bus virtual address space and that manages
> a device that resides in its own IOMMU context. I would recommend using
> only the dma-mapping API when you have a device that lives in a shared
> bus virtual address space with other devices, and then never ask for
> a specific bus virtual address.
> 
> Can you explain what devices you see that don't fit in one of those two
> categories?

Well, I don't think that a driver should limit to one of these 2 APIs. A
driver can very well use the IOMMU-API during initialization (for
example to map the firmware to an address the device expects it to be)
and use the DMA-API later during normal operation to exchange data with
the device.

When a device driver would only use the IOMMU-API and needs small
DMA-able areas it has to re-implement something like the DMA-API
(basically an address allocator) for that. So I don't see a reason why
both can't be used in a device driver.

Regards,

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

