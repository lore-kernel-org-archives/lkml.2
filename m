Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548Ab1COJnc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 05:43:32 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:30064 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753233Ab1COJn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 05:43:29 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Date: Tue, 15 Mar 2011 18:34:42 +0900
From: daeinki <inki.dae@samsung.com>
Subject: Re: [PATCH 3/7] ARM: Samsung: update/rewrite Samsung SYSMMU	(IOMMU)
 driver
In-reply-to: <20110315083515.GA3921@n2100.arm.linux.org.uk>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: InKi Dae <daeinki@gmail.com>, KyongHo Cho <pullip.cho@samsung.com>,
        Tomasz Stanislawski <t.stanislaws@samsung.com>, k.debski@samsung.com,
        linux-samsung-soc@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        =?UTF-8?B?6rCV66+86rec?= <mk7.kang@samsung.com>,
        linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        kgene.kim@samsung.com, Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <4D7F32B2.6020905@samsung.com>
Content-transfer-encoding: 8BIT
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
References: <1299229274-9753-4-git-send-email-m.szyprowski@samsung.com>
 <201103111615.01829.arnd@arndb.de>
 <000201cbe002$768d9de0$63a8d9a0$%szyprowski@samsung.com>
 <201103111700.17373.arnd@arndb.de>
 <AANLkTimagS1vBXEYjXQDx=OGhTRm=n0yO4n+kHTAqBOz@mail.gmail.com>
 <20110314124652.GF26085@n2100.arm.linux.org.uk>
 <AANLkTinzBvkcB111UZd2rJ9raaXkh2TqmTw5Y+4WFd48@mail.gmail.com>
 <20110315083515.GA3921@n2100.arm.linux.org.uk>
X-OriginalArrivalTime: 15 Mar 2011 09:34:43.0136 (UTC)
 FILETIME=[36E97C00:01CBE2F4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King - ARM Linux 쓴 글:
> On Tue, Mar 15, 2011 at 10:45:50AM +0900, InKi Dae wrote:
>> 2011/3/14 Russell King - ARM Linux <linux@arm.linux.org.uk>:
>>> On Mon, Mar 14, 2011 at 09:37:51PM +0900, KyongHo Cho wrote:
>>>> I have also noticed that dma_map_single/page/sg() can map physical
>>>> memory into an arbitrary device address region.
>>>> But it is not enough solution for various kinds of IOMMUs.
>>>> As Kukjin Kim addressed, we need to support larger page size than 4KB
>>>> because we can reduce TLB miss when we have larger page size.
>>>>
>>>> Our IOMMU(system mmu) supports all page size of ARM architecture
>>>> including 16MB, 1MB, 64KB and 4KB.
>>>> Since the largest size supported by buddy system of 32-bit architecture is 4MB,
>>>> our system support all page sizes except 16MB.
>>>> We proved that larger page size is helpful for DMA performance
>>>> significantly (more than 10%, approximately).
>>>> Big page size is not a problem for peripheral devices
>>>> because their address space is not suffer from external fragmentation.
>>> 1. dma_map_single() et.al. is used for mapping *system* *RAM* for devices
>>>   using whatever is necessary.  It must not be used for trying to setup
>>>   arbitary other mappings.
>>>
>>> 2. It doesn't matter where the memory for dma_map_single() et.al. comes
>>>   from provided the virtual address is a valid system RAM address or
>>>   the struct page * is a valid struct page in the memory map (iow, you
>>>   can't create this yourself.)
>> You mean that we cannot have arbitrary virtual address mapping for
>> iommu based device?
> 
> No.  I mean exactly what I said - I'm talking about the DMA API in the
> above two points.  The implication is that you can not create arbitary
> mappings of non-system RAM with the DMA API.
> 
sorry but I couldn't understand exactly what you said. could you give me 
your answer one more time?
does non-system RAM mean reserved memory regions? if not, is it 
arbitrary virtual address space that isn't kernel or user virtual 
address space and is the space for iommu based deivce?


>> actually, we have memory mapping to arbitrary device virtual address
>> space, not kernel virtual address space.
>>
>>> 3. In the case of an IOMMU, the DMA API does not limit you to only using
>>>   4K pages to setup the IOMMU mappings.  You can use whatever you like
>>>   provided the hardware can cope with it.  You can coalesce several
>>>   existing entries together provided you track what you're doing and can
>>>   undo what's been done when the mapping is no longer required.
>>>
>>> So really there's no reason not to use 64K, 1M and 16M IOMMU entries if
>>> that's the size of buffer which has been passed to the DMA API.
>>>
>>> _______________________________________________
>>> linux-arm-kernel mailing list
>>> linux-arm-kernel@lists.infradead.org
>>> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>>>
> 

