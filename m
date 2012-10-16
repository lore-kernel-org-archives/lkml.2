Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672Ab2JPKbJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 06:31:09 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:45382 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789Ab2JPKbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 06:31:08 -0400
Message-ID: <507D375A.3040200@atmel.com>
Date: Tue, 16 Oct 2012 18:30:50 +0800
From: Josh Wu <josh.wu@atmel.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Hans-Christian Egtvedt <egtvedt@samfundet.no>
CC: linux-kernel@vger.kernel.org, hskinnemoen@gmail.com,
        linux-mtd@lists.infradead.org, dedekind1@gmail.com,
        fengguang.wu@intel.com
Subject: Re: [PATCH] avr32: fix build error in atstk1006_defconfig
References: <1350371967-8914-1-git-send-email-josh.wu@atmel.com> <20121016091740.GA6243@samfundet.no>
In-Reply-To: <20121016091740.GA6243@samfundet.no>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/2012 5:17 PM, Hans-Christian Egtvedt wrote:
> Around Tue 16 Oct 2012 15:19:27 +0800 or thereabout, Josh Wu wrote:
>> fixed the following compile error when use avr32 atstk1006_defconfig:
>>    drivers/mtd/nand/atmel_nand.c: In function 'pmecc_err_location':
>>    drivers/mtd/nand/atmel_nand.c:639: error: implicit declaration of function 'writel_relaxed'
>>
>> which was introduced by commit 1c7b874d33b463 ("mtd: at91: atmel_nand: add Programmable Multibit ECC controller support").
>> The PMECC for nand flash code uses writel_relaxed(). But in avr32, there is no macro "writel_relaxed" defined. This patch add writex_relaxed macro definitions.
>>
>> Signed-off-by: Josh Wu <josh.wu@atmel.com>
>> ---
>>   arch/avr32/include/asm/io.h |    4 ++++
>>   1 file changed, 4 insertions(+)
>>
>> diff --git a/arch/avr32/include/asm/io.h b/arch/avr32/include/asm/io.h
>> index cf60d0a..fc6483f 100644
>> --- a/arch/avr32/include/asm/io.h
>> +++ b/arch/avr32/include/asm/io.h
>> @@ -165,6 +165,10 @@ BUILDIO_IOPORT(l, u32)
>>   #define readw_be			__raw_readw
>>   #define readl_be			__raw_readl
>>   
>> +#define writeb_relaxed			writeb
>> +#define writew_relaxed			writew
>> +#define writel_relaxed			writel
>> +
> I'm wondering if they should be something similar to SH arch:
>
> #define writeb_relaxed(v,c) ((void)__raw_writeb((__force u8)ioswabb(v),c))
>
> What is the intention behind the macro? Which restriction is relaxed?

According to my understanding, the xxx_relaxed() is that I/O function 
without any memory barriers. for Multi-cpu, the execute order are less 
limited.
So the relaxed write function should be more effective than non-relaxed one.

But for single cpu, relaxed function should work same as non-relaxed 
function.
Please correct me if I'm understand in a wrong way.

Best Regards,
Josh Wu

>
>>   #define writeb_be			__raw_writeb
>>   #define writew_be			__raw_writew
>>   #define writel_be			__raw_writel

