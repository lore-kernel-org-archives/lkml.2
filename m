Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219Ab1IZJBT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 05:01:19 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:49957 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978Ab1IZJBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 05:01:18 -0400
MIME-Version: 1.0
In-Reply-To: <CAD+V5YLSR-0YdytbJjPnHqKZ4YKdb+sSWgK529SdqrZyZR9=+g@mail.gmail.com>
References: <1316845316-5765-1-git-send-email-keguang.zhang@gmail.com>
	<CAD+V5YLrs91Cjj-EXbjREhs+sQnEjR=q5n3OXtEB0kFQ88p5Pw@mail.gmail.com>
	<CACoURw540BQgs4457uEtkGf41-uLbbubGBP23qnvT4W-MNJqOQ@mail.gmail.com>
	<CAD+V5YLSR-0YdytbJjPnHqKZ4YKdb+sSWgK529SdqrZyZR9=+g@mail.gmail.com>
Date: Mon, 26 Sep 2011 17:01:17 +0800
Message-ID: <CAJhJPsW9F8+Hw=4YSibJ6OedXAVOMaoAH37w_prN7axn=xjTGA@mail.gmail.com>
Subject: Re: [PATCH 1/2] MIPS: Add basic support for Loongson1B (UPDATED)
From: Kelvin Cheung <keguang.zhang@gmail.com>
To: wu zhangjin <wuzhangjin@gmail.com>
Cc: Shane McDonald <mcdonald.shane@gmail.com>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, ralf@linux-mips.org, r0bertz@gentoo.org,
        chenj@lemote.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have noticed this.
And all register accesses in my patch are done through __raw_readl/__raw_writel.

2011/9/26, wu zhangjin <wuzhangjin@gmail.com>:
> On Sun, Sep 25, 2011 at 9:40 PM, Shane McDonald
> <mcdonald.shane@gmail.com> wrote:
>>>> diff --git a/arch/mips/include/asm/mach-loongson1/regs-clk.h
>>>> b/arch/mips/include/asm/mach-loongson1/regs-clk.h
>>>> new file mode 100644
>>>> index 0000000..7a09d6a
>>>> --- /dev/null
>>>> +++ b/arch/mips/include/asm/mach-loongson1/regs-clk.h
>>>> @@ -0,0 +1,32 @@
>>>> +/*
>>>> + * Copyright (c) 2011 Zhang, Keguang <keguang.zhang@gmail.com>
>>>> + *
>>>> + * Loongson1 Clock Register Definitions.
>>>> + *
>>>> + * This program is free software; you can redistribute  it and/or
>>>> modify it
>>>> + * under  the terms of  the GNU General  Public License as published by
>>>> the
>>>> + * Free Software Foundation;  either version 2 of the  License, or (at
>>>> your
>>>> + * option) any later version.
>>>> + */
>>>> +
>>>> +#ifndef __ASM_MACH_LOONGSON1_REGS_CLK_H
>>>> +#define __ASM_MACH_LOONGSON1_REGS_CLK_H
>>>> +
>>>> +#define LS1_CLK_REG(x)         ((void __iomem *)(LOONGSON1_CLK_BASE +
>>>> (x)))
>>>
>>> "volatile" keyword may be required for __iomem access, the same to the
>>> following similar usage.
>>>
>>> Considering a scene is(LS1_XXX_REG(X) doesn't really exist):
>>>
>>> LS1_XXX_REG(X) = 0;              /* put cpu into idle and wait interrupt
>>> */
>>> LS1_XXX_REG(X) = 7;              /* recover the cpu frequency to the
>>> highest */
>>>
>>> If no "volatile" keyword indicated, the first line will be
>>> intelligently but wrongly removed by compiler.
>>
>> No -- please see Documentation/volatile-considered-harmful.txt,
>> particularly the paragraph starting at line 49.  This macro
>> is only being used as an argument to __raw_readl,
>> as it should be.
>
> Yeah, __raw_readl/writel() will use volatile to prevent it from
> optimization, thanks ;)
>
> "within the kernel, I/O memory  accesses are always done through
> accessor functions;
>  accessing I/O memory directly through pointers is frowned upon and
> does not work on all
>  architectures.  Those accessors are written to prevent unwanted
>  optimization,
> ....
>   - The above-mentioned accessor functions might use volatile on
>      architectures where direct I/O memory access does work.  Essentially,
>      each accessor call becomes a little critical section on its own and
>      ensures that the access happens as expected by the programmer.
> ...
> Patches to remove volatile variables are generally welcome - as long as
>  they come with a justification which shows that the concurrency issues have
>  been properly thought through.
> "
>
> Thanks & Regards,
> Wu Zhangjin
>
>>
>> Shane
>>
>


-- 
Best Regards!
Kelvin
