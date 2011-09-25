Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802Ab1IYNkW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Sep 2011 09:40:22 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:42266 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736Ab1IYNkU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Sep 2011 09:40:20 -0400
MIME-Version: 1.0
In-Reply-To: <CAD+V5YLrs91Cjj-EXbjREhs+sQnEjR=q5n3OXtEB0kFQ88p5Pw@mail.gmail.com>
References: <1316845316-5765-1-git-send-email-keguang.zhang@gmail.com>
	<CAD+V5YLrs91Cjj-EXbjREhs+sQnEjR=q5n3OXtEB0kFQ88p5Pw@mail.gmail.com>
Date: Sun, 25 Sep 2011 07:40:18 -0600
Message-ID: <CACoURw540BQgs4457uEtkGf41-uLbbubGBP23qnvT4W-MNJqOQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] MIPS: Add basic support for Loongson1B (UPDATED)
From: Shane McDonald <mcdonald.shane@gmail.com>
To: wu zhangjin <wuzhangjin@gmail.com>
Cc: keguang.zhang@gmail.com, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, ralf@linux-mips.org, r0bertz@gentoo.org,
        chenj@lemote.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> diff --git a/arch/mips/include/asm/mach-loongson1/regs-clk.h b/arch/mips/include/asm/mach-loongson1/regs-clk.h
>> new file mode 100644
>> index 0000000..7a09d6a
>> --- /dev/null
>> +++ b/arch/mips/include/asm/mach-loongson1/regs-clk.h
>> @@ -0,0 +1,32 @@
>> +/*
>> + * Copyright (c) 2011 Zhang, Keguang <keguang.zhang@gmail.com>
>> + *
>> + * Loongson1 Clock Register Definitions.
>> + *
>> + * This program is free software; you can redistribute  it and/or modify it
>> + * under  the terms of  the GNU General  Public License as published by the
>> + * Free Software Foundation;  either version 2 of the  License, or (at your
>> + * option) any later version.
>> + */
>> +
>> +#ifndef __ASM_MACH_LOONGSON1_REGS_CLK_H
>> +#define __ASM_MACH_LOONGSON1_REGS_CLK_H
>> +
>> +#define LS1_CLK_REG(x)         ((void __iomem *)(LOONGSON1_CLK_BASE + (x)))
>
> "volatile" keyword may be required for __iomem access, the same to the
> following similar usage.
>
> Considering a scene is(LS1_XXX_REG(X) doesn't really exist):
>
> LS1_XXX_REG(X) = 0;              /* put cpu into idle and wait interrupt */
> LS1_XXX_REG(X) = 7;              /* recover the cpu frequency to the highest */
>
> If no "volatile" keyword indicated, the above two lines will be
> intelligently but wrongly removed by compiler.

No -- please see Documentation/volatile-considered-harmful.txt,
particularly the paragraph starting at line 49.  This macro
is only being used as an argument to __raw_readl,
as it should be.

Shane
