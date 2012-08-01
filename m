Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637Ab2HAHdX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 03:33:23 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:56145 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754523Ab2HAHdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 03:33:22 -0400
Message-ID: <5018DBB8.2070004@googlemail.com>
Date: Wed, 01 Aug 2012 09:33:12 +0200
From: =?UTF-8?B?QW5kcmVhcyBCaWXDn21hbm4=?= <andreas.devel@googlemail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: =?UTF-8?B?QW5kcmVhcyBCaWXDn21hbm4=?= <andreas@biessmann.de>
CC: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] arm:gemini: fix irq.c
References: <1338981778-19938-1-git-send-email-andreas@biessmann.de> <4FEE13C0.10505@biessmann.de>
In-Reply-To: <4FEE13C0.10505@biessmann.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ping

On 29.06.12 22:44, Andreas Bießmann wrote:
> On 06.06.12 13:22, Andreas Bießmann wrote:
>> Commit 9f97da78bf018206fb623cd351d454af2f105fe0 moved disable_hlt() from
>> arch/arm/include/asm/system.h to arch/arm/include/asm/system_misc.h but missed
>> to change arch/arm/mach-gemini/irq.c.
>>
>> This patch fixes following error:
>>
>> ---8<---
>> arch/arm/mach-gemini/irq.c: In function 'gemini_init_irq':
>> arch/arm/mach-gemini/irq.c:79:2: error: implicit declaration of function 'disable_hlt' [-Werror=implicit-function-declaration]
>> --->8---
>>
>> Signed-off-by: Andreas Bießmann <andreas@biessmann.de>
>> cc: Hans Ulli Kroll <ulli.kroll@googlemail.com> 
>> cc: Russell King <linux@arm.linux.org.uk>
>> cc: linux-arm-kernel@lists.infradead.org
>> ---
>> Note: this is broken since 3.4 release, 3.3 is sane.
> 
> ping
> 
>>
>>  arch/arm/mach-gemini/irq.c |    1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/arch/arm/mach-gemini/irq.c b/arch/arm/mach-gemini/irq.c
>> index ca70e5f..020852d 100644
>> --- a/arch/arm/mach-gemini/irq.c
>> +++ b/arch/arm/mach-gemini/irq.c
>> @@ -17,6 +17,7 @@
>>  #include <linux/sched.h>
>>  #include <asm/irq.h>
>>  #include <asm/mach/irq.h>
>> +#include <asm/system_misc.h>
>>  #include <mach/hardware.h>
>>  
>>  #define IRQ_SOURCE(base_addr)	(base_addr + 0x00)
>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
