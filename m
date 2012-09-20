Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860Ab2ITGlD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 02:41:03 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:8412 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231Ab2ITGlA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 02:41:00 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Wed, 19 Sep 2012 23:40:37 -0700
From: Krishna Reddy <vdumpa@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Joerg Roedel <joerg.roedel@amd.com>, Arnd Bergmann <arnd@arndb.de>,
        Hiroshi Doyu <hdoyu@nvidia.com>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "minchan@kernel.org" <minchan@kernel.org>,
        "chunsang.jeong@linaro.org" <chunsang.jeong@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "subashrp@gmail.com" <subashrp@gmail.com>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
        "pullip.cho@samsung.com" <pullip.cho@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Wed, 19 Sep 2012 23:40:36 -0700
Subject: RE: [RFC 0/5] ARM: dma-mapping: New dma_map_ops to control IOVA
 more precisely
Thread-Topic: [RFC 0/5] ARM: dma-mapping: New dma_map_ops to control IOVA
 more precisely
Thread-Index: Ac2W1q01x4OVKakkSN+vu1KsZkBn5wAIJtrw
Message-ID: <401E54CE964CD94BAE1EB4A729C7087E379FDC1F2D@HQMAIL04.nvidia.com>
References: <1346223335-31455-1-git-send-email-hdoyu@nvidia.com>
 <20120918124918.GK2505@amd.com>
 <20120919095843.d1db155e0f085f4fcf64ea32@nvidia.com>
 <201209190759.46174.arnd@arndb.de> <20120919125020.GQ2505@amd.com>
 <401E54CE964CD94BAE1EB4A729C7087E379FDC1EEB@HQMAIL04.nvidia.com>
 <505A7DB4.4090902@wwwdotorg.org>
In-Reply-To: <505A7DB4.4090902@wwwdotorg.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > On Tegra, the following use cases need specific IOVA mapping.
> > 1. Few MMIO blocks need IOVA=PA mapping setup.
> 
> In that case, why would we enable the IOMMU for that one device; IOMMU
> disabled means VA==PA, right? Perhaps isolation of the device so it can only
> access certain PA ranges for security?

The device(H/W controller) need to access few special memory blocks(IOVA==PA)
and DRAM as well. If IOMMU is disabled, then it has to handle memory fragmentation,
 which defeats the purpose of IOMMU support.
There is also a case where frame buffer memory is passed from BootLoader to Kernel and
display H/W  continues to access it with IOMMU enabled. To support this, the one to one
mapping has to be setup before enabling IOMMU.

-KR



