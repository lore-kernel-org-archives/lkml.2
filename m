Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755791Ab2FWSvl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 14:51:41 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:64894 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754811Ab2FWSvi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 14:51:38 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1206231142150.14887@oneiric>
References: <alpine.DEB.2.02.1206231142150.14887@oneiric>
Date: Sat, 23 Jun 2012 20:51:38 +0200
X-Google-Sender-Auth: ebPHM9AIEF7hIwhCugPIXSbE4WM
Message-ID: <CAMuHMdXqieWY5C_C9ituryRwPSNDU__XL8X=g6EXF3-RH1DDdw@mail.gmail.com>
Subject: Re: should there still be arch-specific 4KSTACKS support?
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Broadening the audience...

On Sat, Jun 23, 2012 at 5:47 PM, Robert P. J. Day <rpjday@crashcourse.ca> wrote:
>  via some convoluted logic, i ended up doing the following search:
>
> $ grep -r 4KSTACKS *
> arch/sh/configs/r7785rp_defconfig:CONFIG_4KSTACKS=y
> arch/sh/Kconfig.debug:config 4KSTACKS
> arch/sh/include/asm/thread_info.h:#if defined(CONFIG_4KSTACKS)
> arch/mn10300/include/asm/thread_info.h:#ifdef CONFIG_4KSTACKS
> arch/m68k/Kconfig.machine:config 4KSTACKS
> arch/m68k/configs/m5208evb_defconfig:# CONFIG_4KSTACKS is not set
> arch/m68k/configs/m5275evb_defconfig:# CONFIG_4KSTACKS is not set
> arch/m68k/configs/m5475evb_defconfig:# CONFIG_4KSTACKS is not set
> arch/m68k/include/asm/thread_info.h:#ifdef CONFIG_4KSTACKS
> arch/c6x/include/asm/thread_info.h:#ifdef CONFIG_4KSTACKS
> drivers/lguest/interrupts_and_traps.c:   * Depending on the CONFIG_4KSTACKS option, the Guest can have one or
> kernel/lockdep.c:        * hardirq contexts (such as on 4KSTACKS), so only
> $
>
>  so even though 4KSTACKS support was officially removed in June of
> 2010:
>
> $ git show dcfa7262
>
> there's still traces of it, some of it obviously harmless, leftover
> cruft, but it would appear that both sh and m68k still provide a
> 4KSTACKS config option.
>
>  how much of that can be tossed as useless?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
