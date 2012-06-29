Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755706Ab2F2NRA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 09:17:00 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:51669 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753861Ab2F2NQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 09:16:58 -0400
X-Sasl-enc: NIXCuqE8fJ1CftVBLNwt53weeFpTlmevkXSBVmUHYl9I 1340975817
Message-ID: <4FEDAAC6.2050202@ladisch.de>
Date: Fri, 29 Jun 2012 15:16:54 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Marek Szyprowski <m.szyprowski@samsung.com>
CC: linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        linaro-mm-sig@lists.linaro.org, linux-mm@kvack.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Russell King - ARM Linux'" <linux@arm.linux.org.uk>,
        "'Benjamin Herrenschmidt'" <benh@kernel.crashing.org>,
        "'Konrad Rzeszutek Wilk'" <konrad.wilk@oracle.com>,
        "'David Gibson'" <david@gibson.dropbear.id.au>,
        "'Subash Patel'" <subash.ramaswamy@linaro.org>,
        "'Sumit Semwal'" <sumit.semwal@linaro.org>
Subject: Re: [PATCH] common: dma-mapping: add support for generic dma_mmap_*
 calls
References: <1339741135-7841-1-git-send-email-m.szyprowski@samsung.com> <4FED8D03.10507@ladisch.de> <00a501cd55f7$323946f0$96abd4d0$%szyprowski@samsung.com>
In-Reply-To: <00a501cd55f7$323946f0$96abd4d0$%szyprowski@samsung.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marek Szyprowski wrote:
> On Friday, June 29, 2012 1:10 PM Clemens Ladisch wrote:
>> Marek Szyprowski wrote:
>>> +++ b/drivers/base/dma-mapping.c
>>> ...
>>> +int dma_common_mmap(struct device *dev, struct vm_area_struct *vma,
>>> +		    void *cpu_addr, dma_addr_t dma_addr, size_t size)
>>> +{
>>> +	int ret = -ENXIO;
>>> +	...
>>> +	if (dma_mmap_from_coherent(dev, vma, cpu_addr, size, &ret))
>>> +		return ret;
>>
>> This will return -ENXIO if dma_mmap_from_coherent() succeeds.
>
> Thanks for spotting this!

Sorry, I was wrong; ret is actually set by dma_mmap_from_coherent's
output parameter.  (That function's documentation appears to be
incomplete.)


Regards,
Clemens
