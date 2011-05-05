Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152Ab1EEIBL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 04:01:11 -0400
Received: from sncsmrelay2.nai.com ([67.97.80.206]:52742 "EHLO
	sncsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752999Ab1EEIBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 04:01:09 -0400
Message-ID: <4DC257E2.3030704@snapgear.com>
Date: Thu, 5 May 2011 17:55:14 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Geert Uytterhoeven <geert@linux-m68k.org>,
        Linux/m68k <linux-m68k@vger.kernel.org>,
        Greg Ungerer <gerg@uclinux.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        uClinux list <uclinux-dev@uclinux.org>
Subject: Re: [PATCH] m68k: Merge mmu and non-mmu versions of sys_call_table
References: <alpine.DEB.2.00.1105042033190.9040@ayla.of.borg> <201105050824.34056.arnd@arndb.de>
In-Reply-To: <201105050824.34056.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On 05/05/11 16:24, Arnd Bergmann wrote:
> On Wednesday 04 May 2011, Geert Uytterhoeven wrote:
>> Impact for nommu:
>>    - Store table in .rodata instead of .text,
>>    - Let kernel/sys_ni.c handle the stubbing of MMU-only syscalls,
>>    - Implement sys_mremap and sys_nfsservct,
>>    - Remove unused padding at the end of the table.
>>
>> Impact for mmu:
>>    - Store table in .rodata instead of .data.
>>
>> Signed-off-by: Geert Uytterhoeven<geert@linux-m68k.org>
>
> What happened to the mmap syscall? IIRC, nommu is pointing to
> a different symbol (sys_mmap_pgoff/sys_mmap2).

Thats taken care of in this patch with:

 > diff --git a/arch/m68k/kernel/syscalltable.S 
b/arch/m68k/kernel/syscalltable.S
 > index 9b8393d..0284192 100644
 > --- a/arch/m68k/kernel/syscalltable.S
 > +++ b/arch/m68k/kernel/syscalltable.S
 > @@ -1,6 +1,4 @@
[snip]
 > +#ifndef CONFIG_MMU
 > +#define sys_mmap2		sys_mmap_pgoff
 > +#endif
 > +

Regards
Greg


> Did you check the macros in unistd to see if they match the
> actual table? I guess it would be a good time to comment out
> the ones that are not implemented in either of the two ABIs.
>
> Otherwise, this patch looks good to me.
>
> 	Arnd
> --
> To unsubscribe from this list: send the line "unsubscribe linux-m68k" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>


-- 
------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close                             FAX:         +61 7 3217 5323
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com
