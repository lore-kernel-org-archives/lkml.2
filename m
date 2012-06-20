Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755835Ab2FTJAo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 05:00:44 -0400
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:43365 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755773Ab2FTJAm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 05:00:42 -0400
MIME-Version: 1.0
In-Reply-To: <20120620084330.GA13009@n2100.arm.linux.org.uk>
References: <CADysL2aFufYzmxWOHp2xUt_TkqOQpX883za+7it5h2qd=PMwwA@mail.gmail.com>
	<20120620084330.GA13009@n2100.arm.linux.org.uk>
Date: Wed, 20 Jun 2012 14:30:32 +0530
Message-ID: <CADysL2bzL_TCmeEcSJdv-_WeXFyU3zNnU8mxtc81JDG7bLYHoQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] ARM: new cache maintenance api for iommu mem flush
From: "Gupta, Ramesh" <grgupta@ti.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, tony@atomide.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,


On Wed, Jun 20, 2012 at 2:13 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Tue, Jun 19, 2012 at 04:51:07PM +0530, Gupta, Ramesh wrote:
>> >From 785a1f2854002ce7c1c8880bc5d8d92a7868bf1c Mon Sep 17 00:00:00 2001
>> From: Ramesh Gupta G <grgupta@ti.com>
>> Date: Fri, 15 Jun 2012 16:37:20 +0530
>> Subject: [PATCH v2 1/4] ARM: new cache maintenance api for iommu mem flush
>>
>> non-coherent IOMMUs need to make sure that the
>> data held in the caches need to be visible for the
>> MMU hardware. A new L1 cache maintenance api has been
>> created to handle this. Thanks to RMK's suggestions on
>> creating a dedicated API for this purpose.
>>
>> ref:
>> http://marc.info/?l=linux-kernel&m=131316512713815&w=2
>>
>> Signed-off-by: Ramesh Gupta G <grgupta@ti.com>
>> ---
>>  arch/arm/include/asm/cacheflush.h |   17 +++++++++++++++++
>>  arch/arm/include/asm/glue-cache.h |    1 +
>>  arch/arm/mm/proc-macros.S         |    1 +
>>  3 files changed, 19 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/arm/include/asm/cacheflush.h
>> b/arch/arm/include/asm/cacheflush.h
>> index d5d8d5c..2b4f5aa 100644
>> --- a/arch/arm/include/asm/cacheflush.h
>> +++ b/arch/arm/include/asm/cacheflush.h
>> @@ -84,6 +84,11 @@
>>   *           - kaddr  - page address
>>   *           - size   - region size
>>   *
>> + *     flush_mem(start, end)
>> + *
>> + *             Clean and invalidate the specified virtual address range.
>> + *             - start  - virtual start address
>> + *             - end    - virtual end address
>
> You're missing a blank line here.

I will fix it.

> Also, "flush_mem" is a very lame name - it tells us nothing about what the
> purpose of this new API is.  Should it be used for when the CPU MMU TLB
> entries are changed?  What about if we're suspending, should it be used
> then?  What about if we're performing DMA - should it be used for that
> memory too?
>
> Please, give it a better name which describes what it is for.

I agree, will choose a better name to describe the api.

>> diff --git a/arch/arm/mm/proc-macros.S b/arch/arm/mm/proc-macros.S
>> index 2d8ff3a..f48a5ab 100644
>> --- a/arch/arm/mm/proc-macros.S
>> +++ b/arch/arm/mm/proc-macros.S
>> @@ -307,6 +307,7 @@ ENTRY(\name\()_cache_fns)
>>       .long   \name\()_dma_map_area
>>       .long   \name\()_dma_unmap_area
>>       .long   \name\()_dma_flush_range
>> +     .long   \name\()_flush_mem
>>       .size   \name\()_cache_fns, . - \name\()_cache_fns
>>  .endm
>
> This will immediately break the kernel compilation.  Therefore, your
> patch is incomplete and unsuitable for applying.

I was checking only with panda configuration, I will update the patch
set to take care of this.

Thank you for review comments.

-- 
regards
Ramesh Gupta G
