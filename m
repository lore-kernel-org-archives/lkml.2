Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932965Ab0KPWOa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 17:14:30 -0500
Received: from mga09.intel.com ([134.134.136.24]:2227 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932808Ab0KPWO3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 17:14:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,207,1288594800"; 
   d="scan'208";a="574474488"
Message-ID: <4CE30244.6090208@linux.intel.com>
Date: Tue, 16 Nov 2010 14:14:28 -0800
From: "H. Peter Anvin" <hpa@linux.intel.com>
Organization: Intel Open Source Technology Center
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc13 Thunderbird/3.1.6
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de,
        linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@linux.jf.intel.com>
Subject: Re: [patch 1/2] bootmem: add alloc_bootmem_align()
References: <20101116212441.977574826@sbsiddha-MOBL3.sc.intel.com>
In-Reply-To: <20101116212441.977574826@sbsiddha-MOBL3.sc.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/2010 01:23 PM, Suresh Siddha wrote:
> Index: tree/include/linux/bootmem.h
> ===================================================================
> --- tree.orig/include/linux/bootmem.h
> +++ tree/include/linux/bootmem.h
> @@ -105,6 +105,8 @@ extern void *__alloc_bootmem_low_node(pg
>  
>  #define alloc_bootmem(x) \
>  	__alloc_bootmem(x, SMP_CACHE_BYTES, __pa(MAX_DMA_ADDRESS))
> +#define alloc_bootmem_align(x, align) \
> +	__alloc_bootmem(x, align, __pa(MAX_DMA_ADDRESS))
>  #define alloc_bootmem_nopanic(x) \
>  	__alloc_bootmem_nopanic(x, SMP_CACHE_BYTES, __pa(MAX_DMA_ADDRESS))
>  #define alloc_bootmem_pages(x) \

  [...]

>  	 */
> -	init_xstate_buf = alloc_bootmem(xstate_size);
> +	init_xstate_buf = alloc_bootmem_align(xstate_size,
> +					      __alignof__(struct xsave_struct));
>  	init_xstate_buf->i387.mxcsr = MXCSR_DEFAULT;

Perhaps it would make even more sense to have:

#define alloc_bootmem_alignof(x, type) \
	__alloc_bootmem(x, __alignof__(type), __pa(MAX_DMA_ADDRESS))


?

	-hpa
