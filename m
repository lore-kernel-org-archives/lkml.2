Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756735Ab1DGTnW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 15:43:22 -0400
Received: from relay1.sgi.com ([192.48.179.29]:42639 "HELO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756565Ab1DGTnV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 15:43:21 -0400
Message-ID: <4D9E13D4.3080702@sgi.com>
Date: Thu, 07 Apr 2011 12:43:16 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>
Cc: David Rientjes <rientjes@google.com>, Jack Steiner <steiner@sgi.com>,
        Robin Holt <holt@sgi.com>, Len Brown <len.brown@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 1/2] memblock: add error return when CONFIG_HAVE_MEMBLOCK
 is not set
References: <20110225180633.857892225@gulag1.americas.sgi.com>	<20110225180634.017570095@gulag1.americas.sgi.com>	<20110227120949.GF16453@elte.hu>	<20110227121518.GA19165@elte.hu>	<4D6AFBB0.70401@kernel.org>	<4D6BF63D.2020404@sgi.com>	<AANLkTi=Sn6DKAjGHQjtWGiLGh8vpuS-vmXK=TMDrbjdv@mail.gmail.com>	<4D6BFF46.3050001@sgi.com> <AANLkTi=Xf5RaF559QsRNijmG0YP7amkG569NZFhpt4QY@mail.gmail.com> <4D93CDD7.8000708@sgi.com>
In-Reply-To: <4D93CDD7.8000708@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Was there any further objections to these patches?

Mike Travis wrote:
> Subject: memblock: add error return when CONFIG_HAVE_MEMBLOCK is not set
> Author: Yinghai Lu <yinghai@kernel.org>
> 
>     Add an error return if CONFIG_HAVE_MEMBLOCK is not set instead
>     of having to add #ifdef CONFIG_HAVE_MEMBLOCK around blocks of
>     code calling that function.
> 
> Signed-off-by: Mike Travis <travis@sgi.com>
> ---
> include/linux/memblock.h |    9 ++++++++-
> 1 file changed, 8 insertions(+), 1 deletion(-)
> 
> --- linux.orig/include/linux/memblock.h
> +++ linux/include/linux/memblock.h
> @@ -2,6 +2,8 @@
> #define _LINUX_MEMBLOCK_H
> #ifdef __KERNEL__
> 
> +#define MEMBLOCK_ERROR    0
> +
> #ifdef CONFIG_HAVE_MEMBLOCK
> /*
>  * Logical memory blocks.
> @@ -20,7 +22,6 @@
> #include <asm/memblock.h>
> 
> #define INIT_MEMBLOCK_REGIONS    128
> -#define MEMBLOCK_ERROR        0
> 
> struct memblock_region {
>     phys_addr_t base;
> @@ -160,6 +161,12 @@ static inline unsigned long memblock_reg
> #define __initdata_memblock
> #endif
> 
> +#else
> +static inline phys_addr_t memblock_alloc(phys_addr_t size, phys_addr_t 
> align)
> +{
> +    return MEMBLOCK_ERROR;
> +}
> +
> #endif /* CONFIG_HAVE_MEMBLOCK */
> 
> #endif /* __KERNEL__ */
> 
> 
