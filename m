Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240Ab2H0PAt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 11:00:49 -0400
Received: from bosmailout02.eigbox.net ([66.96.185.2]:60403 "EHLO
	bosmailout02.eigbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753092Ab2H0PAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 11:00:31 -0400
X-Authority-Analysis: v=2.0 cv=aPZHX8Bm c=1 sm=1
 a=b13+pjR7gVc1Ry1IWBkISg==:17 a=bc2JKO6qiGsA:10 a=kfTud4QeKxsA:10
 a=6_yu9_eKWJgA:10 a=8nJEP1OIZ-IA:10 a=gHsnk5GASbAA:10
 a=bJ0fqD8TFZgqkSadqForXVIPBlU=:19 a=dCP5gS9r6t0cLp5NDqwA:9 a=wPNLvfGTeEIA:10
 a=6uKCkKhFq2wXOH2GoQX8aA==:117
X-EN-OrigOutIP: 10.20.18.3
X-EN-IMPSID: rr0U1j00G03yW7601r0Uit
Message-ID: <503B8B26.3050205@yahoo.es>
Date: Mon, 27 Aug 2012 22:58:46 +0800
From: Hein Tibosch <hein_tibosch@yahoo.es>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Hans-Christian Egtvedt <egtvedt@samfundet.no>
CC: viresh kumar <viresh.kumar@linaro.org>,
        spear-devel <spear-devel@list.st.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "ludovic.desroches" <ludovic.desroches@atmel.com>,
        Havard Skinnemoen <havard@skinnemoen.net>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>
Subject: Re: [PATCH 1/2] dw_dmac: make driver endianness configurable
References: <503A8CAE.6050606@yahoo.es> <20120827070323.GC28721@samfundet.no> <503B342C.9060300@yahoo.es> <20120827111431.GA27868@samfundet.no>
In-Reply-To: <20120827111431.GA27868@samfundet.no>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-EN-UserInfo: 3946c951b80c12a8be5482963a0b1232:e0ae43bc192b431f8b69f09a37527cbc
X-EN-AuthUser: hein@htibosch.net
X-EN-OrigIP: 114.79.63.205
X-EN-OrigHost: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/27/2012 7:14 PM, Hans-Christian Egtvedt wrote:
> Around Mon 27 Aug 2012 16:47:40 +0800 or thereabout, Hein Tibosch wrote:
>> On 8/27/2012 3:03 PM, Hans-Christian Egtvedt wrote:
>>> Brushing up the config items:
>>>
>>> +config DW_DMAC_BIG_ENDIAN_IO
>>> +	bool "Use big endian I/O register access"
>>> +	default y if AVR32
>>> +	depends on DW_DMAC
>>> +	help
>>> +	  Say yes here to use big endian I/O access when reading and writing
>>> +	  to the DMA controller registers. This is needed on some platforms,
>>> +	  like the Atmel AVR32 architecture.
>>> +
>>> +	  If unsure, use the default setting.
> This sounds good in my ears, but I don't speak English natively.
I think you Norwegians are doing very well in English
And btw, I'm not from .es but from .nl, which is very close to England

>> And as I'd like to define the maximum memory transfer width in the same
>> Kconfig:
>>
>> +config DW_DMAC_MEM_64_BIT
>> +	bool "Allow 64-bit memory transfers"
>> +	default y if !AVR32
>> +	depends on DW_DMAC
>> +	help
>> +	  Say yes if the DMA controller may do 64-bit memory transfers
>> +	  For AVR32, say no because only up to 32-bit transfers are
>> +	  defined
> Is this sane to add? Could some non-AVR32 platforms use 64-bit and 32-bit
> depending on runtime configuration? E.g. if you build a kernel with support
> for multiple boards/processors, and there is a mix of 32-bit and 64-bit wide
> DMA support.
>
> I think it is better to select 32/64-bit at runtime.

I did that in the first patch, adding a new property to the dw_dma_slave
structure. It had the small disadvantage that some arch code had to be
adapted (at32ap700x.c).

Viresh, what do you think? Add a property called "mem_64_bit_access" or so?

Or should it be passed as a member of 'dw_dma_platform_data', because it
is a property of the (entire) DMA controller?

Hein
