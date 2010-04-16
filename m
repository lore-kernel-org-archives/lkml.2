Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755117Ab0DPPDN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 11:03:13 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:48083 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352Ab0DPPDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 11:03:10 -0400
Message-ID: <4BC87C28.70408@monstr.eu>
Date: Fri, 16 Apr 2010 17:03:04 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: steve@digidescorp.com
CC: Michal Simek <monstr@monstr.eu>, linux-kernel@vger.kernel.org,
       microblaze-uclinux@itee.uq.edu.au
Subject: Re: [microblaze-uclinux] Re: [PATCH 1/2] microblaze: add stack unwinder
References: <1271220928-3502-1-git-send-email-steve@digidescorp.com>	 <4BC820B2.6060604@monstr.eu> <1271428410.3366.23.camel@iscandar.digidescorp.com>
In-Reply-To: <1271428410.3366.23.camel@iscandar.digidescorp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven J. Magnani wrote:
> On Fri, 2010-04-16 at 10:32 +0200, Michal Simek wrote:
>> Please apply this patch and do the same testing as I did.
>>
>> diff --git a/arch/microblaze/kernel/reset.c b/arch/microblaze/kernel/reset.c
>> index a1721a3..76f6587 100644
>> --- a/arch/microblaze/kernel/reset.c
>> +++ b/arch/microblaze/kernel/reset.c
>> @@ -112,8 +112,8 @@ void of_platform_reset_gpio_probe(void)
>>   void machine_restart(char *cmd)
>>   {
>>          printk(KERN_NOTICE "Machine restart...\n");
>> +       machine_shutdown();
>>          gpio_system_reset();
>> -       dump_stack();
>>          while (1)
>>                  ;
>>   }
>> @@ -121,6 +121,7 @@ void machine_restart(char *cmd)
>>   void machine_shutdown(void)
>>   {
>>          printk(KERN_NOTICE "Machine shutdown...\n");
>> +       dump_stack();
>>          while (1)
>>                  ;
>>   }
> 
> I get this:
> 
> Call Trace:
> [<20003008>] microblaze_unwind+0x68/0x94
> [<20002c24>] show_stack+0x134/0x174
> [<20002c80>] dump_stack+0x1c/0x3c
> [<20001d84>] machine_shutdown+0x30/0x40
> [<20001dc0>] machine_restart+0x2c/0x48
> [<2002a540>] kernel_restart+0x5c/0x80
> [<2002a6b8>] sys_reboot+0x11c/0x218
> SYSCALL
> [<2d5c0248>] PID 118 [reboot]
> 
> Is your problem on a MMU or noMMU system?

Interesting. It was noMMU system.

> 
> If the unwinder stops early, it found a return address outside the
> kernel text, or couldn't find the addik that creates a stack frame - but
> there's not enough information here to tell what happened. In your case
> the backtrace goes off the rails before getting to the frame for
> dump_stack(), which is where the stack dump begins. We'd need to see the
> 21 words preceding the dump (show_stack's frame is 13 words, and
> microblaze_unwind's is 8) to know why.
> 
> Can you uncomment the #define DEBUG in unwind.c and try it again?

will do next week and let you know.

Thanks,
Michal


> 
> Thanks,
> ------------------------------------------------------------------------
>  Steven J. Magnani               "I claim this network for MARS!
>  www.digidescorp.com              Earthling, return my space modulator!"
> 
>  #include <standard.disclaimer>
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
