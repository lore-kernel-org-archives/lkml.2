Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751431Ab2F2GMe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 02:12:34 -0400
Received: from dnvwsmailout1.mcafee.com ([161.69.31.173]:11915 "EHLO
	DNVWSMAILOUT1.mcafee.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011Ab2F2GMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 02:12:33 -0400
Message-ID: <4FED46E2.3070008@snapgear.com>
Date: Fri, 29 Jun 2012 16:10:42 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
CC: Geert Uytterhoeven <geert@linux-m68k.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: Re: should there still be arch-specific 4KSTACKS support?
References: <alpine.DEB.2.02.1206231142150.14887@oneiric> <CAMuHMdXqieWY5C_C9ituryRwPSNDU__XL8X=g6EXF3-RH1DDdw@mail.gmail.com>
In-Reply-To: <CAMuHMdXqieWY5C_C9ituryRwPSNDU__XL8X=g6EXF3-RH1DDdw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/06/12 04:51, Geert Uytterhoeven wrote:
> Broadening the audience...
>
> On Sat, Jun 23, 2012 at 5:47 PM, Robert P. J. Day <rpjday@crashcourse.ca> wrote:
>>   via some convoluted logic, i ended up doing the following search:
>>
>> $ grep -r 4KSTACKS *
>> arch/sh/configs/r7785rp_defconfig:CONFIG_4KSTACKS=y
>> arch/sh/Kconfig.debug:config 4KSTACKS
>> arch/sh/include/asm/thread_info.h:#if defined(CONFIG_4KSTACKS)
>> arch/mn10300/include/asm/thread_info.h:#ifdef CONFIG_4KSTACKS
>> arch/m68k/Kconfig.machine:config 4KSTACKS
>> arch/m68k/configs/m5208evb_defconfig:# CONFIG_4KSTACKS is not set
>> arch/m68k/configs/m5275evb_defconfig:# CONFIG_4KSTACKS is not set
>> arch/m68k/configs/m5475evb_defconfig:# CONFIG_4KSTACKS is not set
>> arch/m68k/include/asm/thread_info.h:#ifdef CONFIG_4KSTACKS
>> arch/c6x/include/asm/thread_info.h:#ifdef CONFIG_4KSTACKS
>> drivers/lguest/interrupts_and_traps.c:   * Depending on the CONFIG_4KSTACKS option, the Guest can have one or
>> kernel/lockdep.c:        * hardirq contexts (such as on 4KSTACKS), so only
>> $
>>
>>   so even though 4KSTACKS support was officially removed in June of
>> 2010:
>>
>> $ git show dcfa7262
>>
>> there's still traces of it, some of it obviously harmless, leftover
>> cruft, but it would appear that both sh and m68k still provide a
>> 4KSTACKS config option.
>>
>>   how much of that can be tossed as useless?

Well, it still works on non-mmu m68k. Yes, I am aware of the issues,
but for those types of small memory non-mmu systems 4k stacks is a
saving. And those types of systems don't tend to use the parts of
the kernel that have been known to want lots of kernel stack.

But if opposition was incredibly strong to having anything support
4k stacks, I probably won't loose any sleep over it being removed
for m68k.

Regards
Greg


------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close                             FAX:         +61 7 3217 5323
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com


