Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937Ab1HVDkX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 23:40:23 -0400
Received: from dalsmrelay2.nai.com ([205.227.136.216]:54503 "EHLO
	dalsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887Ab1HVDkW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 23:40:22 -0400
Message-ID: <4E51CF9A.7060407@snapgear.com>
Date: Mon, 22 Aug 2011 13:40:10 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Rob Landley <rob@landley.net>, LKML <linux-kernel@vger.kernel.org>,
        <gerg@uclinux.org>
Subject: Re: m68k with mmu doesn't compile after 66d857b08b8c3ed
References: <4E5008A1.8070105@landley.net> <CAMuHMdWfpZdwqtPgQKJHYVWRLKMXOeaMWV-mTBQxpE12XNTg_g@mail.gmail.com>
In-Reply-To: <CAMuHMdWfpZdwqtPgQKJHYVWRLKMXOeaMWV-mTBQxpE12XNTg_g@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/08/11 05:46, Geert Uytterhoeven wrote:
> Hi Rob,
>
> You're really confusing me.
>
> On Sat, Aug 20, 2011 at 21:18, Rob Landley<rob@landley.net>  wrote:
>> The m68k build in 3.0 dies with this:
>>
>> áCC á á áarch/m68k/kernel/dma.o
>> In file included from arch/m68k/kernel/dma.c:4:
>> arch/m68k/kernel/dma_no.c: In function 'dma_sync_single_for_cpu':
>> arch/m68k/kernel/dma_no.c:44: error: implicit declaration of function 'flush_dcache_range'
>
> Your subject says "m68k with mmu doesn't compile", but here you're
> obviously compiling for nommu, as dma.c includes dma_no.c if CONFIG_MMU
> is not set.
>
>> make[1]: *** [arch/m68k/kernel/dma.o] Error 1
>> make: *** [arch/m68k/kernel] Error 2
>>
>> That file includes<asm/cacheflush.h>, which for m68k is:
>>
>> #ifdef __uClinux__
>> #include "cacheflush_no.h"
>> #else
>> #include "cacheflush_mm.h"
>> #endif
>>
>> The nommu header (cacheflush_no.h) does #define flush_dcache_range(),
>> but the clacheflush_mm.h version does not. áI.E. you can only currently
>
> Are you using a uClinux toolchain that defines __uClinux__, or not?
>
>> build m68k for Coldfire, you can no longer build it for an actual m68k.
>
> JFYI, it builds fine for all "actual m68ks" (with MMU) I'm interested in.
> And I guess Greg will say the same for Coldfire and "actual m68ks" without
> MMU...

Yes :-)
And from time to time I build all the defconfigs (so both MMU and
non-MMU) in arch/m68k/configs/. I thought they all worked on 3.0
if using an appropriate tool chain.

Regards
Greg


-- 
------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close                             FAX:         +61 7 3217 5323
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com
