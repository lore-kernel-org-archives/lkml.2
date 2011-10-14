Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932554Ab1JNEda (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 00:33:30 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:43616 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932357Ab1JNEd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 00:33:27 -0400
Message-ID: <4E97BB8E.3060204@gmail.com>
Date: Fri, 14 Oct 2011 10:03:18 +0530
From: Subash Patel <subashrp@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.23) Gecko/20110922 Lightning/1.0b2 Thunderbird/3.1.15 ThunderBrowse/3.8
MIME-Version: 1.0
To: Marek Szyprowski <m.szyprowski@samsung.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-mm@kvack.org,
        linaro-mm-sig@lists.linaro.org, Daniel Walker <dwalker@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Jonathan Corbet <corbet@lwn.net>, Mel Gorman <mel@csn.ul.ie>,
        Chunsang Jeong <chunsang.jeong@linaro.org>,
        Michal Nazarewicz <mina86@mina86.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Jesse Barker <jesse.barker@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Ankita Garg <ankita@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [Linaro-mm-sig] [PATCH 8/9] ARM: integrate CMA with DMA-mapping
 subsystem
References: <1317909290-29832-1-git-send-email-m.szyprowski@samsung.com> <1317909290-29832-10-git-send-email-m.szyprowski@samsung.com>
In-Reply-To: <1317909290-29832-10-git-send-email-m.szyprowski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marek,

As informed to you in private over IRC, below piece of code broke during 
booting EXYNOS4:SMDKV310 with ZONE_DMA enabled.


On 10/06/2011 07:24 PM, Marek Szyprowski wrote:
...
> diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
> index fbdd12e..9c27fbd 100644
> --- a/arch/arm/mm/init.c
> +++ b/arch/arm/mm/init.c
> @@ -21,6 +21,7 @@
>   #include<linux/gfp.h>
>   #include<linux/memblock.h>
>   #include<linux/sort.h>
> +#include<linux/dma-contiguous.h>
>
>   #include<asm/mach-types.h>
>   #include<asm/prom.h>
> @@ -371,6 +372,13 @@ void __init arm_memblock_init(struct meminfo *mi, struct machine_desc *mdesc)
>   	if (mdesc->reserve)
>   		mdesc->reserve();
>
> +	/* reserve memory for DMA contigouos allocations */
> +#ifdef CONFIG_ZONE_DMA
> +	dma_contiguous_reserve(PHYS_OFFSET + mdesc->dma_zone_size - 1);
> +#else
> +	dma_contiguous_reserve(0);
> +#endif
> +
>   	memblock_analyze();
>   	memblock_dump_all();
>   }
Regards,
Subash
