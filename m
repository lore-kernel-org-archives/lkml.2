Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755678Ab2IUWZp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 18:25:45 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:52593 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752416Ab2IUWZo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 18:25:44 -0400
Message-ID: <505CE958.5020808@ti.com>
Date: Fri, 21 Sep 2012 18:25:28 -0400
From: Cyril Chemparathy <cyril@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Nicolas Pitre <nicolas.pitre@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <arnd@arndb.de>, <catalin.marinas@arm.com>,
        <grant.likely@secretlab.ca>, <linux@arm.linux.org.uk>,
        <will.deacon@arm.com>
Subject: Re: [PATCH v3 02/17] ARM: add self test for runtime patch mechanism
References: <1347385155-11643-1-git-send-email-cyril@ti.com> <1347385155-11643-3-git-send-email-cyril@ti.com> <alpine.LFD.2.02.1209211331320.6667@xanadu.home>
In-Reply-To: <alpine.LFD.2.02.1209211331320.6667@xanadu.home>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/21/2012 1:40 PM, Nicolas Pitre wrote:
> On Tue, 11 Sep 2012, Cyril Chemparathy wrote:
>
>> This patch adds basic sanity tests to ensure that the instruction patching
>> results in valid instruction encodings.  This is done by verifying the output
>> of the patch process against a vector of assembler generated instructions at
>> init time.
>>
>> Signed-off-by: Cyril Chemparathy <cyril@ti.com>
>> ---
>>   arch/arm/Kconfig                |   12 +++++++
>>   arch/arm/kernel/runtime-patch.c |   75 +++++++++++++++++++++++++++++++++++++++
>>   2 files changed, 87 insertions(+)
>>
>> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
>> index 36de4ea..bfcd29d 100644
>> --- a/arch/arm/Kconfig
>> +++ b/arch/arm/Kconfig
>> @@ -207,6 +207,18 @@ config ARM_PATCH_PHYS_VIRT
>>   	  this feature (eg, building a kernel for a single machine) and
>>   	  you need to shrink the kernel to the minimal size.
>>
>> +config ARM_RUNTIME_PATCH_TEST
>> +	bool "Self test runtime patching mechanism" if ARM_RUNTIME_PATCH
>> +	default y
>
> Here you probably want this instead:
>
> 	bool "Self test runtime patching mechanism"
> 	default y
> 	depends on ARM_RUNTIME_PATCH
>
> Otherwise ARM_RUNTIME_PATCH_TEST will be forced to y whenever
> ARM_RUNTIME_PATCH is unset.  That doesn't currently affect the build
> since the containing .c file is only compiled when ARM_RUNTIME_PATCH is
> set but that is still not strictly right.
>

Indeed.  Excellent.  Thanks.

> [...]
>> @@ -189,5 +261,8 @@ void __init runtime_patch_kernel(void)
>>   	const void *start = &__runtime_patch_table_begin;
>>   	const void *end   = &__runtime_patch_table_end;
>>
>> +#ifdef CONFIG_ARM_RUNTIME_PATCH_TEST
>> +	runtime_patch_test();
>> +#endif
>>   	BUG_ON(runtime_patch(start, end - start));
>
> I think you shoulld have runtime_patch_test() return a possible error
> code and use BUG_ON() with it as well.
>

Sure.  Will do in v4.

> With those minor changes you can add...
>
> Reviewed-by: Nicolas Pitre <nico@linaro.org>
>

Thanks.

-- 
- Cyril
