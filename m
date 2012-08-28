Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751877Ab2H1DXJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 23:23:09 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56792 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610Ab2H1DXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 23:23:07 -0400
MIME-Version: 1.0
In-Reply-To: <503B8B26.3050205@yahoo.es>
References: <503A8CAE.6050606@yahoo.es>
	<20120827070323.GC28721@samfundet.no>
	<503B342C.9060300@yahoo.es>
	<20120827111431.GA27868@samfundet.no>
	<503B8B26.3050205@yahoo.es>
Date: Tue, 28 Aug 2012 08:53:06 +0530
Message-ID: <CAKohpo=ALUNOnQdQjNd1Y2jtocxjixKCiBrRZp8qGErqg1LSKw@mail.gmail.com>
Subject: Re: [PATCH 1/2] dw_dmac: make driver endianness configurable
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Hein Tibosch <hein_tibosch@yahoo.es>
Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        spear-devel <spear-devel@list.st.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "ludovic.desroches" <ludovic.desroches@atmel.com>,
        Havard Skinnemoen <havard@skinnemoen.net>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 August 2012 20:28, Hein Tibosch <hein_tibosch@yahoo.es> wrote:
>>> +config DW_DMAC_MEM_64_BIT
>>> +    bool "Allow 64-bit memory transfers"
>>> +    default y if !AVR32
>>> +    depends on DW_DMAC
>>> +    help
>>> +      Say yes if the DMA controller may do 64-bit memory transfers
>>> +      For AVR32, say no because only up to 32-bit transfers are
>>> +      defined
>> Is this sane to add? Could some non-AVR32 platforms use 64-bit and 32-bit
>> depending on runtime configuration? E.g. if you build a kernel with support
>> for multiple boards/processors, and there is a mix of 32-bit and 64-bit wide
>> DMA support.
>>
>> I think it is better to select 32/64-bit at runtime.
>
> I did that in the first patch, adding a new property to the dw_dma_slave
> structure. It had the small disadvantage that some arch code had to be
> adapted (at32ap700x.c).
>
> Viresh, what do you think? Add a property called "mem_64_bit_access" or so?
>
> Or should it be passed as a member of 'dw_dma_platform_data', because it
> is a property of the (entire) DMA controller?

I think second option is better. But can there be some supportive scenarios of
first option?

We have a system, with two different memory controllers, one supporting 32 bit
and other 64 bit?

Or what we can do now is: go with option 2, i.e. update dw_dma_platform_data
and if some platform like what i mentioned above comes, then we can move it
to slave data.

viresh
