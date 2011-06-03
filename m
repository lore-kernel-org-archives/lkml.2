Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754519Ab1FCLuU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 07:50:20 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:39174 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754401Ab1FCLuT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 07:50:19 -0400
Message-ID: <4DE8CA76.2060303@in.ibm.com>
Date: Fri, 03 Jun 2011 17:20:14 +0530
From: Suzuki Poulose <suzuki@in.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        linux ppc dev <linuxppc-dev@lists.ozlabs.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] Kexec support for PPC440x
References: <4DE345B0.8020505@in.ibm.com> <4DE50617.7090509@linutronix.de> <4DE72EFE.8080502@in.ibm.com>
In-Reply-To: <4DE72EFE.8080502@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02/11 12:04, Suzuki Poulose wrote:
> On 05/31/11 20:45, Sebastian Andrzej Siewior wrote:
>>
>> Suzuki Poulose wrote:
>>> Index: powerpc/arch/powerpc/kernel/44x_kexec_mapping.S
>>> ===================================================================
>>> --- /dev/null
>>> +++ powerpc/arch/powerpc/kernel/44x_kexec_mapping.S
>> ....
>>
>>> + *
>>> + */
>>> + bl nxtins /* Find our address */
>>> +nxtins: mflr r5 /* Make it accessible */
>>
>> Please don't mix labels and instructions.
> OK.
>>
>>> + tlbsx r23,0,r5 /* Find entry we are in */
>>
>> using tabs instead of spaces would make it look nice. Please also separate the arguments of the instruction i.e.
>> tlbsx r23, 0, r5
>
> Sure.
>>
>>
>>> Index: powerpc/arch/powerpc/kernel/misc_32.S
>>> ===================================================================
>>> --- powerpc.orig/arch/powerpc/kernel/misc_32.S
>>> +++ powerpc/arch/powerpc/kernel/misc_32.S
>>> @@ -736,6 +736,28 @@ relocate_new_kernel:
>>> mr r5, r31
>>>
>>> li r0, 0
>>> +#elif defined(CONFIG_44x) && !defined(CONFIG_47x)
>>> +
>>> + mr r29, r3
>>> + mr r30, r4
>>> + mr r31, r5
>>> +
>>> +#include "44x_kexec_mapping.S"
>>
>> The way you setup the 1:1 mapping should be close to what you are doing on
>> kernel entry.Isn't it possible to include the file here and in the entry
>> code?

> I will make this change and resend the patch.

I took a look at the way we do it at kernel entry. It looks more cleaner to leave
it untouched. Especially, when we add the support for 47x in the future, the code
  will become more unreadable.

What do you think ?

Thanks

Suzuki
>
> Thanks
>
> Suzuki
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev

