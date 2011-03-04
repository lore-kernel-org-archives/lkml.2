Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759378Ab1CDJJJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 04:09:09 -0500
Received: from server103.greatnet.de ([83.133.97.6]:44147 "EHLO
	server103.greatnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759285Ab1CDJJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 04:09:05 -0500
Message-ID: <4D70AC2E.1060405@nachtwindheim.de>
Date: Fri, 04 Mar 2011 10:09:02 +0100
From: Henrik Kretzschmar <henne@nachtwindheim.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.16) Gecko/20101227 Icedove/3.0.11
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] x86: make some apic symbols init
References: <1299182701-8591-1-git-send-email-henne@nachtwindheim.de> <1299182701-8591-2-git-send-email-henne@nachtwindheim.de> <4D7005D6.9050108@gmail.com>
In-Reply-To: <4D7005D6.9050108@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 03.03.2011 22:19, schrieb Cyrill Gorcunov:
> On 03/03/2011 11:04 PM, Henrik Kretzschmar wrote:
>> apic_force_enable(), apic_verify() and the variable
>> force_enable_local_apic are only used by init code
>> and now get marked as such.
>>
>> Global __initdata variables may better be initialized,
>> since they are in the data section and not in the bss.
>>
>> Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
>> ---
>>  arch/x86/include/asm/apic.h |    2 +-
>>  arch/x86/kernel/apic/apic.c |    6 +++---
>>  2 files changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
>> index dbd558c..afe69e1 100644
>> --- a/arch/x86/include/asm/apic.h
>> +++ b/arch/x86/include/asm/apic.h
>> @@ -240,7 +240,7 @@ extern void setup_boot_APIC_clock(void);
>>  extern void setup_secondary_APIC_clock(void);
>>  extern int APIC_init_uniprocessor(void);
>>  extern void enable_NMI_through_LVT0(void);
>> -extern int apic_force_enable(unsigned long addr);
>> +extern int apic_force_enable(unsigned long addr) __init;
> 
> Nope, we either should _check_ all the prototipes and fix them
> either left them untouched. This will confuse code readers with "for
> what reason some functions have __init, some -- not". So I rather
> would fix this nit in different patch later which would address
> all of them (if this would not break someone's queue).
> 
Ack, I'll fix it.

>>   */
>> -static int force_enable_local_apic;
>> +static int force_enable_local_apic __initdata = 0;
> 
> Hmm, I fail to see why we need to set it to 0.

Ack, I'll fix this also.
 
