Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753842Ab2ITCVo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 22:21:44 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:59002 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537Ab2ITCVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 22:21:42 -0400
Message-ID: <505A7DB4.4090902@wwwdotorg.org>
Date: Wed, 19 Sep 2012 20:21:40 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Krishna Reddy <vdumpa@nvidia.com>
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
Subject: Re: [RFC 0/5] ARM: dma-mapping: New dma_map_ops to control IOVA more
 precisely
References: <1346223335-31455-1-git-send-email-hdoyu@nvidia.com> <20120918124918.GK2505@amd.com> <20120919095843.d1db155e0f085f4fcf64ea32@nvidia.com> <201209190759.46174.arnd@arndb.de> <20120919125020.GQ2505@amd.com> <401E54CE964CD94BAE1EB4A729C7087E379FDC1EEB@HQMAIL04.nvidia.com>
In-Reply-To: <401E54CE964CD94BAE1EB4A729C7087E379FDC1EEB@HQMAIL04.nvidia.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2012 07:44 PM, Krishna Reddy wrote:
>> When a device driver would only use the IOMMU-API and needs small DMA-
>> able areas it has to re-implement something like the DMA-API (basically an
>> address allocator) for that. So I don't see a reason why both can't be used in a
>> device driver.
> 
> On Tegra, the following use cases need specific IOVA mapping.
> 1. Few MMIO blocks need IOVA=PA mapping setup.

In that case, why would we enable the IOMMU for that one device; IOMMU
disabled means VA==PA, right? Perhaps isolation of the device so it can
only access certain PA ranges for security?
