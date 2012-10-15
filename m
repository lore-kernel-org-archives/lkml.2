Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419Ab2JOB20 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 21:28:26 -0400
Received: from bosmailout16.eigbox.net ([66.96.185.16]:39507 "EHLO
	bosmailout16.eigbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555Ab2JOB2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 21:28:25 -0400
X-Greylist: delayed 2875 seconds by postgrey-1.27 at vger.kernel.org; Sun, 14 Oct 2012 21:28:25 EDT
X-Authority-Analysis: v=2.0 cv=LIXRtuq9 c=1 sm=1
 a=xCnBQGcVMpKAnt6pssLkvQ==:17 a=bc2JKO6qiGsA:10 a=jAXA38P_poEA:10
 a=nlncmwdmcoAA:10 a=IkcTkHD0fZMA:10 a=cRAXhCL3cXIA:10
 a=bJ0fqD8TFZgqkSadqForXVIPBlU=:19 a=5z8PQ-8DrPULJUTkwQsA:9 a=QEXdDO2ut3YA:10
 a=x8qw8EAkfcRkIpZA8Q87Bg==:117
X-EN-OrigOutIP: 10.20.18.7
X-EN-IMPSID: BCgU1k001099BUA01CgUkV
Message-ID: <507B5B3E.60102@yahoo.es>
Date: Mon, 15 Oct 2012 08:39:26 +0800
From: Hein Tibosch <hein_tibosch@yahoo.es>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Andy Shevchenko <andy.shevchenko@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        viresh kumar <viresh.kumar@linaro.org>,
        spear-devel <spear-devel@list.st.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "ludovic.desroches" <ludovic.desroches@atmel.com>,
        Havard Skinnemoen <havard@skinnemoen.net>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [PATCH REGRESSION FIX] dw_dmac: make driver's endianness configurable
References: <507A6FA5.1000800@yahoo.es> <CAHp75VdaqzoJPwJpQ9U1kpR-egveajeM71FLAxveWHz7gB+6Eg@mail.gmail.com>
In-Reply-To: <CAHp75VdaqzoJPwJpQ9U1kpR-egveajeM71FLAxveWHz7gB+6Eg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-EN-UserInfo: 3946c951b80c12a8be5482963a0b1232:e0ae43bc192b431f8b69f09a37527cbc
X-EN-AuthUser: hein@htibosch.net
X-EN-OrigIP: 114.79.56.37
X-EN-OrigHost: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy,
On 10/15/2012 4:08 AM, Andy Shevchenko wrote:
> On Sun, Oct 14, 2012 at 10:54 AM, Hein Tibosch <hein_tibosch@yahoo.es> wrote:
>> From: Hein Tibosch <hein_tibosch@yahoo.es>
>>
>> The dw_dmac was originally developed for avr32 to be used with the Synopsys
>> DesignWare AHB DMA controller. Starting from 2.6.38, access to the device's i/o
>> <snip>
>>  #define dma_readl(dw, name) \
>> -       readl(&(__dw_regs(dw)->name))
>> +       dma_readl_native(&(__dw_regs(dw)->name))
>>  #define dma_writel(dw, name, val) \
>> -       writel((val), &(__dw_regs(dw)->name))
>> +       dma_writel_native((val), &(__dw_regs(dw)->name))
>>
>>  #define channel_set_bit(dw, reg, mask) \
>>         dma_writel(dw, reg, ((mask) << 8) | (mask))
> Why did you not change this one?

Because "dma_writel" already calls "dma_writel_native"

