Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030365Ab2CIWpY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 17:45:24 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:55518 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756909Ab2CIWpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 17:45:22 -0500
Message-ID: <4F5A87FF.8060606@linaro.org>
Date: Fri, 09 Mar 2012 23:45:19 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Rob Lee <rob.lee@linaro.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: linux-next: manual merge of the cpuidle-cons tree with the arm-soc
 tree
References: <20120309183732.512d3676599da324f4747219@canb.auug.org.au> <CAMXH7KE5En7U-2zydT3MfJ7C7B164-zsQuBoHMUqzD-Kb_nh1w@mail.gmail.com>
In-Reply-To: <CAMXH7KE5En7U-2zydT3MfJ7C7B164-zsQuBoHMUqzD-Kb_nh1w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09/2012 11:26 PM, Rob Lee wrote:
> Hello Stephen,
>
> Yes, your resolution looks correct to me.

For me too.

Thanks
   -- Daniel


> On Fri, Mar 9, 2012 at 1:37 AM, Stephen Rothwell<sfr@canb.auug.org.au>  wrote:
>> Hi Rob,
>>
>> Today's linux-next merge of the cpuidle-cons tree got a conflict in
>> arch/arm/mach-at91/cpuidle.c between commit 00482a4078f4 ("ARM: at91:
>> implement the standby function for pm/cpuidle") from the arm-soc tree and
>> commit 7a1f6e72dce1 ("ARM: at91: Consolidate time keeping and irq
>> enable") from the cpuidle-cons tree.
>>
>> I fixed it up (I think - see below) and can carry the fix as necessary.
>> --
>> Cheers,
>> Stephen Rothwell                    sfr@canb.auug.org.au
>>
>> diff --cc arch/arm/mach-at91/cpuidle.c
>> index 555d956,d40b3f3..0000000
>> --- a/arch/arm/mach-at91/cpuidle.c
>> +++ b/arch/arm/mach-at91/cpuidle.c
>> @@@ -37,23 -33,15 +33,8 @@@ static int at91_enter_idle(struct cpuid
>>                         struct cpuidle_driver *drv,
>>                                int index)
>>   {
>> -       struct timeval before, after;
>> -       int idle_time;
>> -
>> -       local_irq_disable();
>> -       do_gettimeofday(&before);
>> -       if (index == 0)
>> -               /* Wait for interrupt state */
>> -               cpu_do_idle();
>> -       else if (index == 1)
>> -               at91_standby();
>>   -      u32 saved_lpr;
>>   -
>>   -      __asm__("b 1f; .align 5; 1:\n"
>>   -      "       mcr p15, 0, r0, c7, c10, 4");   /* drain write buffer */
>>   -
>>   -      saved_lpr = sdram_selfrefresh_enable();
>>   -      cpu_do_idle();
>>   -      sdram_selfrefresh_disable(saved_lpr);
>> ++      at91_standby();
>>
>> -       do_gettimeofday(&after);
>> -       local_irq_enable();
>> -       idle_time = (after.tv_sec - before.tv_sec) * USEC_PER_SEC +
>> -                       (after.tv_usec - before.tv_usec);
>> -
>> -       dev->last_residency = idle_time;
>>         return index;
>>   }
>>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

