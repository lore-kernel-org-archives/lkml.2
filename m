Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756740Ab0FIJJF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 05:09:05 -0400
Received: from daytona.panasas.com ([67.152.220.89]:43536 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755995Ab0FIJJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 05:09:03 -0400
Message-ID: <4C0F5A2A.5080806@panasas.com>
Date: Wed, 09 Jun 2010 12:08:58 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
       =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jeff Dike <jdike@addtoit.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [uml-devel] [PATCH resend] um, hweight: Fix UML boot crash
References: <4C0F4B00.4090307@panasas.com>	<4C0F4C40.5020207@panasas.com> <AANLkTinwQmWP-rFu9e-ns5twsZwZjuSLi5vcll55ZZhx@mail.gmail.com>
In-Reply-To: <AANLkTinwQmWP-rFu9e-ns5twsZwZjuSLi5vcll55ZZhx@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Jun 2010 09:09:01.0524 (UTC) FILETIME=[66C9E940:01CB07B3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/09/2010 11:46 AM, Geert Uytterhoeven wrote:
> On Wed, Jun 9, 2010 at 10:09, Boaz Harrosh <bharrosh@panasas.com> wrote:
>> On 06/09/2010 11:04 AM, Boaz Harrosh wrote:
>>> From: Borislav Petkov <bp@alien8.de>
>>>
>>> Obviously UML cannot stomach callee reg-saving trickery
>>> introduced with d61931d89be506372d01a90d1755f6d0a9fafe2d
>>> (x86: Add optimized popcnt variants) and oopses during boot:
>>> http://marc.info/?l=linux-kernel&m=127522065202435&w=2
>>>
>>> Redirect arch_hweight.h include from the x86 portion to the generic
>>> arch_hweight.h which is a fallback to the software hweight routines.
>>>
>>> LKML-Reference: <201005271944.09541.toralf.foerster@gmx.de>
>>> Signed-off-by: Borislav Petkov <bp@alien8.de>
> 
> Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>

Tested-by: Boaz Harrosh <bharrosh@panasas.com>

> 
>> who's going to push this ASAP. I was just (again) 3/4 through a bisect
>> on 2.6.35-rc2. When I finally realized "Hey that patch, I forgot".
>> (My concentration is not what it used to be)
>>
>> Please push this, someone
> 
> Peter, are you happy with this?
> Although we still don't know why UML cannot grok it, it does fix a
> regression in post-2.6.34.
> 

I have x86_64 setup (host and guest). Without this I'm unable to boot any
UML image (2.6.35-rc2). With it all is well as before.

Boaz
>>> ---
>>>  arch/um/include/asm/arch_hweight.h |    6 ++++++
>>>  1 files changed, 6 insertions(+), 0 deletions(-)
>>>  create mode 100644 arch/um/include/asm/arch_hweight.h
>>>
>>> diff --git a/arch/um/include/asm/arch_hweight.h b/arch/um/include/asm/arch_hweight.h
>>> new file mode 100644
>>> index 0000000..c656cf4
>>> --- /dev/null
>>> +++ b/arch/um/include/asm/arch_hweight.h
>>> @@ -0,0 +1,6 @@
>>> +#ifndef _ASM_UM_HWEIGHT_H
>>> +#define _ASM_UM_HWEIGHT_H
>>> +
>>> +#include <asm-generic/bitops/arch_hweight.h>
>>> +
>>> +#endif
> 
> Gr{oetje,eeting}s,
> 
> 						Geert
> 
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
> 							    -- Linus Torvalds

