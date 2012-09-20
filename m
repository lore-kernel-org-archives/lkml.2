Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755955Ab2ITP16 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 11:27:58 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:54586 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755661Ab2ITP14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 11:27:56 -0400
Message-ID: <505B35F7.2080201@wwwdotorg.org>
Date: Thu, 20 Sep 2012 09:27:51 -0600
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
References: <1346223335-31455-1-git-send-email-hdoyu@nvidia.com> <20120918124918.GK2505@amd.com> <20120919095843.d1db155e0f085f4fcf64ea32@nvidia.com> <201209190759.46174.arnd@arndb.de> <20120919125020.GQ2505@amd.com> <401E54CE964CD94BAE1EB4A729C7087E379FDC1EEB@HQMAIL04.nvidia.com> <505A7DB4.4090902@wwwdotorg.org> <401E54CE964CD94BAE1EB4A729C7087E379FDC1F2D@HQMAIL04.nvidia.com>
In-Reply-To: <401E54CE964CD94BAE1EB4A729C7087E379FDC1F2D@HQMAIL04.nvidia.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/2012 12:40 AM, Krishna Reddy wrote:
>>> On Tegra, the following use cases need specific IOVA mapping.
>>> 1. Few MMIO blocks need IOVA=PA mapping setup.
>>
>> In that case, why would we enable the IOMMU for that one device; IOMMU
>> disabled means VA==PA, right? Perhaps isolation of the device so it can only
>> access certain PA ranges for security?
> 
> The device(H/W controller) need to access few special memory blocks(IOVA==PA)
> and DRAM as well.

OK, so only /some/ of the VA space is VA==PA, and some is remapped;
that's a little different that what you originally implied above.

BTW, which HW module is this; AVP/COP or something else. This sounds
like an odd requirement.

> There is also a case where frame buffer memory is passed from BootLoader to Kernel and
> display H/W  continues to access it with IOMMU enabled. To support this, the one to one
> mapping has to be setup before enabling IOMMU.

Yes, that makes sense.
