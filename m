Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259Ab2GXKzm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 06:55:42 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:57466 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752785Ab2GXKzl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 06:55:41 -0400
Message-ID: <500E7F22.9090803@ti.com>
Date: Tue, 24 Jul 2012 06:55:30 -0400
From: Cyril Chemparathy <cyril@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nico@linaro.org" <nico@linaro.org>, Will Deacon <Will.Deacon@arm.com>,
        Vitaly Andrianov <vitalya@ti.com>
Subject: Re: [RFC 03/23] ARM: LPAE: use phys_addr_t on virt <--> phys conversion
References: <1343092165-9470-1-git-send-email-cyril@ti.com> <1343092165-9470-4-git-send-email-cyril@ti.com> <20120724103717.GF20132@arm.com>
In-Reply-To: <20120724103717.GF20132@arm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/24/2012 6:37 AM, Catalin Marinas wrote:
> On Tue, Jul 24, 2012 at 02:09:05AM +0100, Cyril Chemparathy wrote:
>> This patch fixes up the types used when converting back and forth between
>> physical and virtual addresses.
>>
>> Signed-off-by: Vitaly Andrianov <vitalya@ti.com>
>> Signed-off-by: Cyril Chemparathy <cyril@ti.com>
>> ---
>>   arch/arm/include/asm/memory.h |   17 +++++++++++------
>>   1 file changed, 11 insertions(+), 6 deletions(-)
>>
>> diff --git a/arch/arm/include/asm/memory.h b/arch/arm/include/asm/memory.h
>> index fcb5757..7629dfe 100644
>> --- a/arch/arm/include/asm/memory.h
>> +++ b/arch/arm/include/asm/memory.h
>> @@ -169,22 +169,27 @@ extern unsigned long __pv_phys_offset;
>>   	: "=r" (to)					\
>>   	: "r" (from), "I" (type))
>>
>> -static inline unsigned long __virt_to_phys(unsigned long x)
>> +static inline phys_addr_t __virt_to_phys(unsigned long x)
>>   {
>>   	unsigned long t;
>>   	__pv_stub(x, t, "add", __PV_BITS_31_24);
>>   	return t;
>>   }
>>
>> -static inline unsigned long __phys_to_virt(unsigned long x)
>> +static inline unsigned long __phys_to_virt(phys_addr_t x)
>>   {
>>   	unsigned long t;
>>   	__pv_stub(x, t, "sub", __PV_BITS_31_24);
>>   	return t;
>>   }
>
> BTW, I would prefer if the phys-to-virt patching was fixed as well. It
> shouldn't be difficult.
>

On that topic - yes, we have this on our radar, but in our case we;re 
talking about patching (in head.S) and then repatching (at switch over).

One of the ideas we've been bouncing around has been to convert the 
phys-virt patch code into arithmetic on PFNs.  This way we don't have to 
get too messy with 64-bit in the patch code, and we can use the same 
patch code for both phys_to_virt and virt_to_phys.  Thoughts on this 
approach?

-- 
Thanks
- Cyril
