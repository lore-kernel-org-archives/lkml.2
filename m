Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410Ab0HXP0g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 11:26:36 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:29539 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755396Ab0HXP0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 11:26:33 -0400
Message-ID: <4C73E46B.8050203@oracle.com>
Date: Tue, 24 Aug 2010 08:25:31 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] V4L/DVB: mantis: Fix IR_CORE dependency
References: <4C643A08.3000605@redhat.com> <20100824084528.GA26618@elte.hu>
In-Reply-To: <20100824084528.GA26618@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/24/10 01:45, Ingo Molnar wrote:
> 
> * Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
> 
>> Linus,
>>
>> Please pull from:
>>   ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git v4l_for_linus
>>
>> For 3 build fixes.
>>
>> Cheers,
>> Mauro.
>>
>> The following changes since commit ad41a1e0cab07c5125456e8d38e5b1ab148d04aa:
>>
>>   Merge branch 'io_remap_pfn_range' of git://www.jni.nu/cris (2010-08-12 10:17:19 -0700)
>>
>> are available in the git repository at:
>>
>>   ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git v4l_for_linus
>>
>> Mauro Carvalho Chehab (2):
>>       V4L/DVB: Fix IR_CORE dependencies
>>       V4L/DVB: fix Kconfig to depends on VIDEO_IR
>>
>> Randy Dunlap (1):
>>       V4L/DVB: v4l2-ctrls.c: needs to include slab.h
> 
> FYI, there's one more IR_CORE related build bug which triggers 
> frequently in randconfig tests - see the fix below.
> 
> Thanks,
> 
> 	Ingo
> 
> ------------------->
> From c56aef270d7ec01564c632c1f7ebab6b8f9f032c Mon Sep 17 00:00:00 2001
> From: Ingo Molnar <mingo@elte.hu>
> Date: Tue, 24 Aug 2010 10:41:33 +0200
> Subject: [PATCH] V4L/DVB: mantis: Fix IR_CORE dependency
> 
> This build bug triggers:
> 
>  drivers/built-in.o: In function `mantis_exit':
>  (.text+0x377413): undefined reference to `ir_input_unregister'
>  drivers/built-in.o: In function `mantis_input_init':
>  (.text+0x3774ff): undefined reference to `__ir_input_register'
> 
> If MANTIS_CORE is enabled but IR_CORE is not. Add the correct
> dependency.
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  drivers/media/dvb/mantis/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/dvb/mantis/Kconfig b/drivers/media/dvb/mantis/Kconfig
> index decdeda..fd0830e 100644
> --- a/drivers/media/dvb/mantis/Kconfig
> +++ b/drivers/media/dvb/mantis/Kconfig
> @@ -1,6 +1,6 @@
>  config MANTIS_CORE
>  	tristate "Mantis/Hopper PCI bridge based devices"
> -	depends on PCI && I2C && INPUT
> +	depends on PCI && I2C && INPUT && IR_CORE
>  
>  	help
>  	  Support for PCI cards based on the Mantis and Hopper PCi bridge.


Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
http://lkml.org/lkml/2010/8/17/341

thanks,
-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
