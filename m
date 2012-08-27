Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752501Ab2H0LOj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 07:14:39 -0400
Received: from cassarossa.samfundet.no ([129.241.93.19]:43318 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730Ab2H0LOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 07:14:38 -0400
Date: Mon, 27 Aug 2012 13:14:31 +0200
From: Hans-Christian Egtvedt <egtvedt@samfundet.no>
To: Hein Tibosch <hein_tibosch@yahoo.es>
Cc: viresh kumar <viresh.kumar@linaro.org>,
        spear-devel <spear-devel@list.st.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "ludovic.desroches" <ludovic.desroches@atmel.com>,
        Havard Skinnemoen <havard@skinnemoen.net>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>
Subject: Re: [PATCH 1/2] dw_dmac: make driver endianness configurable
Message-ID: <20120827111431.GA27868@samfundet.no>
References: <503A8CAE.6050606@yahoo.es>
 <20120827070323.GC28721@samfundet.no>
 <503B342C.9060300@yahoo.es>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <503B342C.9060300@yahoo.es>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Around Mon 27 Aug 2012 16:47:40 +0800 or thereabout, Hein Tibosch wrote:
> On 8/27/2012 3:03 PM, Hans-Christian Egtvedt wrote:
>> I think the English in kconfig could use some brushing up.
>>  
>>> +config DW_DMAC_BE
>>
>>
>> This name isn't that long, so we could skip the abbreviation of big endian;
>> DW_DMAC_BIG_ENDIAN_IO or something similar?
>>
>>> +	bool "Synopsys DesignWare AHB DMA needs big endian access"
>>>
>> bool "Use big endian I/O register access"
> 
> Brushing up the config items:
> 
> +config DW_DMAC_BIG_ENDIAN_IO
> +	bool "Use big endian I/O register access"
> +	default y if AVR32
> +	depends on DW_DMAC
> +	help
> +	  Say yes here to use big endian I/O access when reading and writing
> +	  to the DMA controller registers. This is needed on some platforms,
> +	  like the Atmel AVR32 architecture.
> +
> +	  If unsure, use the default setting.

This sounds good in my ears, but I don't speak English natively.

> And as I'd like to define the maximum memory transfer width in the same
> Kconfig:
> 
> +config DW_DMAC_MEM_64_BIT
> +	bool "Allow 64-bit memory transfers"
> +	default y if !AVR32
> +	depends on DW_DMAC
> +	help
> +	  Say yes if the DMA controller may do 64-bit memory transfers
> +	  For AVR32, say no because only up to 32-bit transfers are
> +	  defined

Is this sane to add? Could some non-AVR32 platforms use 64-bit and 32-bit
depending on runtime configuration? E.g. if you build a kernel with support
for multiple boards/processors, and there is a mix of 32-bit and 64-bit wide
DMA support.

I think it is better to select 32/64-bit at runtime.

-- 
mvh
Hans-Christian Egtvedt
