Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072Ab2GSIBY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 04:01:24 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:46312 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752068Ab2GSIBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 04:01:22 -0400
Message-ID: <5007BEB2.5060405@in.ibm.com>
Date: Thu, 19 Jul 2012 13:30:50 +0530
From: "Suzuki K. Poulose" <suzuki@in.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        mahesh@linux.vnet.ibm.com, hbabu@us.ibm.com
Subject: Re: [PATCH] [powerpc] Export memory limit via device tree
References: <20120702114855.22333.95335.stgit@suzukikp.in.ibm.com> <1341985013.18850.29.camel@pasglop>
In-Reply-To: <1341985013.18850.29.camel@pasglop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12071821-1396-0000-0000-000001940677
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2012 11:06 AM, Benjamin Herrenschmidt wrote:
>> diff --git a/arch/powerpc/kernel/machine_kexec.c b/arch/powerpc/kernel/machine_kexec.c
>> index c957b12..0c9695d 100644
>> --- a/arch/powerpc/kernel/machine_kexec.c
>> +++ b/arch/powerpc/kernel/machine_kexec.c
>> @@ -207,6 +207,12 @@ static struct property crashk_size_prop = {
>>   	.value = &crashk_size,
>>   };
>>
>> +static struct property memory_limit_prop = {
>> +	.name = "linux,memory-limit",
>> +	.length = sizeof(phys_addr_t),
>> +	.value = &memory_limit,
>> +};
>> +
>
> AFAIK. phys_addr_t can change size, so instead make it point to a known
> fixes size quantity (a u64).
Ben,

Sorry for the delay in the response.

Some of the other properties are also of phys_addr_t, (e.g 
linux,crashkernel-base, linux,kernel-end ). Should we fix them as well ?

Or

Should we leave this also a phys_addr_t and let the userspace handle it ?

>
>> +
>> +	/* memory-limit is needed for constructing the crash regions */
>> +	prop = of_find_property(node, memory_limit_prop.name, NULL);
>> +	if (prop)
>> +		prom_remove_property(node, prop);
>> +
>> +	if (memory_limit)
>> +		prom_add_property(node, &memory_limit_prop);
>> +
>
> There's a patch floating around making prom_update_property properly
> handle both pre-existing and non-pre-existing props, you should probably
> base yourself on top of it. I'm about to stick that patch in powerpc
> -next
>
OK. I am testing the new patch based on the above commit. I will wait
for the clarification on the issue of the type, before I post it here.

Thanks
Suzuki

