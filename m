Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525Ab2HEOXd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 10:23:33 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:41364 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371Ab2HEOXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 10:23:32 -0400
Message-ID: <501E81D8.1010600@ti.com>
Date: Sun, 5 Aug 2012 10:23:20 -0400
From: Cyril Chemparathy <cyril@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Nicolas Pitre <nicolas.pitre@linaro.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <arnd@arndb.de>, <catalin.marinas@arm.com>, <linux@arm.linux.org.uk>,
        <will.deacon@arm.com>, Vitaly Andrianov <vitalya@ti.com>
Subject: Re: [PATCH 08/22] ARM: LPAE: use phys_addr_t for initrd location
 and size
References: <1343775898-28345-1-git-send-email-cyril@ti.com> <1343775898-28345-9-git-send-email-cyril@ti.com> <alpine.LFD.2.02.1208040255100.5231@xanadu.home>
In-Reply-To: <alpine.LFD.2.02.1208040255100.5231@xanadu.home>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/4/2012 2:57 AM, Nicolas Pitre wrote:
> On Tue, 31 Jul 2012, Cyril Chemparathy wrote:
>
>> From: Vitaly Andrianov <vitalya@ti.com>
>>
>> This patch fixes the initrd setup code to use phys_addr_t instead of assuming
>> 32-bit addressing.  Without this we cannot boot on systems where initrd is
>> located above the 4G physical address limit.
>>
>> Signed-off-by: Vitaly Andrianov <vitalya@ti.com>
>> Signed-off-by: Cyril Chemparathy <cyril@ti.com>
>> ---
>>   arch/arm/mm/init.c |   14 +++++++-------
>>   1 file changed, 7 insertions(+), 7 deletions(-)
>>
>> diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
>> index 8252c31..51f3e92 100644
>> --- a/arch/arm/mm/init.c
>> +++ b/arch/arm/mm/init.c
>> @@ -36,12 +36,12 @@
>>
>>   #include "mm.h"
>>
>> -static unsigned long phys_initrd_start __initdata = 0;
>> -static unsigned long phys_initrd_size __initdata = 0;
>> +static phys_addr_t phys_initrd_start __initdata = 0;
>> +static phys_addr_t phys_initrd_size __initdata = 0;
>
> phys_addr_t for the initrd size is rather overkill, isn't it?
>

Fair enough. :-)

>
> Nicolas
>

-- 
Thanks
- Cyril
