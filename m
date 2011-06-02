Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758717Ab1FBHa0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 03:30:26 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:46192 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758141Ab1FBHaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 03:30:25 -0400
Message-ID: <4DE73C04.5050208@in.ibm.com>
Date: Thu, 02 Jun 2011 13:00:12 +0530
From: Suzuki Poulose <suzuki@in.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        linux ppc dev <linuxppc-dev@lists.ozlabs.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] Kexec support for PPC440x
References: <4DE345B0.8020505@in.ibm.com>  <4DE50617.7090509@linutronix.de> <1306999551.29297.57.camel@pasglop>
In-Reply-To: <1306999551.29297.57.camel@pasglop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02/11 12:55, Benjamin Herrenschmidt wrote:
> On Tue, 2011-05-31 at 17:15 +0200, Sebastian Andrzej Siewior wrote:
>> Suzuki Poulose wrote:
>>> Index: powerpc/arch/powerpc/kernel/44x_kexec_mapping.S
>>> ===================================================================
>>> --- /dev/null
>>> +++ powerpc/arch/powerpc/kernel/44x_kexec_mapping.S
>> ....
>>
>>> + *
>>> + */
>>> +    bl    nxtins                /* Find our address */
>>> +nxtins:    mflr    r5                /* Make it accessible */
>>
>> Please don't mix labels and instructions.
>
> With proper indent it's fine as long as he uses numerical relative
> labels which should be the case here. For example, the above, it should
> look like:
>
> 	bl	1f
> 1:	mflr	r5
>
>>> +    tlbsx    r23,0,r5            /* Find entry we are in */
>>
>> using tabs instead of spaces would make it look nice. Please also separate
>> the arguments of the instruction i.e.
>> 	tlbsx	r23, 0, r5
>
> That's arguable. If you look at arch/powerpc, we tend not to separate
> the arguments ;-)
>
> Actually I used to, others didn't and I changed my own style.
>
>>> Index: powerpc/arch/powerpc/kernel/misc_32.S
>>> ===================================================================
>>> --- powerpc.orig/arch/powerpc/kernel/misc_32.S
>>> +++ powerpc/arch/powerpc/kernel/misc_32.S
>>> @@ -736,6 +736,28 @@ relocate_new_kernel:
>>>       mr      r5, r31
>>>
>>>       li    r0, 0
>>> +#elif defined(CONFIG_44x)&&  !defined(CONFIG_47x)
>>> +
>>> +    mr    r29, r3
>>> +    mr    r30, r4
>>> +    mr    r31, r5
>>> +
>>> +#include "44x_kexec_mapping.S"
>>
>> The way you setup the 1:1 mapping should be close to what you are doing on
>> kernel entry. Isn't it possible to include the file here and in the entry
>> code?
>
> It should just not be #included, what about branching out instead ?

This code, i.e, relocate_new_kernel is copied into the control buffer, which will
get the first chance to execute before the purgatory. So we may not be able to
branch to the code, since we are executing this from a different address and we
would invalidate the mapping for the code except the control buffer.

Thanks

Suzuki
  

