Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764Ab2ISIAB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 04:00:01 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:50807 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753111Ab2ISH76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 03:59:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Hiroshi Doyu <hdoyu@nvidia.com>
Subject: Re: [RFC 0/5] ARM: dma-mapping: New dma_map_ops to control IOVA more precisely
Date: Wed, 19 Sep 2012 07:59:45 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Joerg Roedel <joerg.roedel@amd.com>,
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
References: <1346223335-31455-1-git-send-email-hdoyu@nvidia.com> <20120918124918.GK2505@amd.com> <20120919095843.d1db155e0f085f4fcf64ea32@nvidia.com>
In-Reply-To: <20120919095843.d1db155e0f085f4fcf64ea32@nvidia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209190759.46174.arnd@arndb.de>
X-Provags-ID: V02:K0:0anadbv9l+/qm4XgN9ycsM5X8/GgeI5iQH3n3Gi/lMJ
 VP05hKIcwbNLYXuYb66borXgnPpTALSxANgh/lEawZ3/acCzl3
 Gh+P8cyezfJ8xyFni8X2GXZPu8lCJI3qefvTDJTkwZMe3jWcBk
 YeWqX8EXqClBOHYov1QXACNB+ZMJDfCIHeYysZGVp2qtYH6CW4
 up39fPgF99aIbGzKBORyTH3MgmxJHOZxyaYXj5Q4BLLigIS7IR
 +FqL5AwujDd74f5D2uqJLyzcoCL0e4OsQZWnYXB7AHvZlVf5yU
 kEUkHhxiJ7rPnpOM34yJlAnfmYCFY7gsYSlWwyhMc/SwszCgHN
 O9zkQt38VQTtgmnOD3sM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 19 September 2012, Hiroshi Doyu wrote:
> I guess that it would work. Originally I thought that using DMA-API
> and IOMMU-API together in driver might be kind of layering violation
> since IOMMU-API itself is used in DMA-API. Only DMA-API used in driver
> might be cleaner. Considering that DMA API traditionally handling
> anonymous {bus,iova} address only, introducing the concept of
> specific address in DMA API may not be so encouraged, though.
> 
> It would be nice to listen how other SoCs have solved similar needs.

In general, I would recommend using only the IOMMU API when you have a device
driver that needs to control the bus virtual address space and that manages
a device that resides in its own IOMMU context. I would recommend using
only the dma-mapping API when you have a device that lives in a shared
bus virtual address space with other devices, and then never ask for
a specific bus virtual address.

Can you explain what devices you see that don't fit in one of those two
categories?

	Arnd
