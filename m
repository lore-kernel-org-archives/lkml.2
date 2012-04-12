Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762675Ab2DLURL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 16:17:11 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:54173 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756075Ab2DLURI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 16:17:08 -0400
MIME-Version: 1.0
In-Reply-To: <20120412200752.GA30685@merkur.ravnborg.org>
References: <1332960678-11879-1-git-send-email-andi@firstfloor.org>
	<1332960678-11879-2-git-send-email-andi@firstfloor.org>
	<CAMuHMdVX28zeebzN6277B5p2b=9s-Q06i01o5AHPyXAuKMigGQ@mail.gmail.com>
	<20120412194016.GA30558@merkur.ravnborg.org>
	<CAMuHMdXfpvprGD18_YYyctfrAk6iRJonWFGFRf9oSaH0u0zfhw@mail.gmail.com>
	<4F8733C5.5080609@linux.intel.com>
	<20120412200752.GA30685@merkur.ravnborg.org>
Date: Thu, 12 Apr 2012 22:17:07 +0200
X-Google-Sender-Auth: TS5-0vHYN7ZxrnAm1Mg3E89WnGY
Message-ID: <CAMuHMdXN0PcxZQb6=ReFrpG6U49tP8ujA+OKkeVGd_yeftaydw@mail.gmail.com>
Subject: Re: [PATCH 2/2] Add CONFIG_READABLE_ASM
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Andi Kleen <ak@linux.intel.com>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        x86@kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sam,

On Thu, Apr 12, 2012 at 22:07, Sam Ravnborg <sam@ravnborg.org> wrote:
> Could you try this:
>
> cc-disable-opt = $(call try-run,\
>        $(CC) $(KBUILD_CPPFLAGS) $(KBUILD_CFLAGS) -f$(strip $(1)) -c -xc /dev/null -o "$TMP",-fno-$(strip $(1)))
>
> KBUILD_CFLAGS += $(call cc-disable-opt, ipa-cp-clone)
>
>
> It will try if "gcc -fipa-cp-clone" is supported,
> and add -fno-ipa-cp-clone in that case.

Unfortunately not:

m68k-linux-gnu-gcc -Wp,-MD,kernel/.bounds.s.d  -nostdinc -isystem
/usr/lib/gcc/m68k-linux-gnu/4.1.2/include
-I/scratch/geert/linux/linux-next/arch/m68k/include
Iarch/m68k/include/generated -Iinclude  -include
/scratch/geert/linux/linux-next/include/linux/kconfig.h -D__KERNEL__
-Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing
-fno-common -Werror-implicit-function-declaration -Wno-format-security
-fno-delete-null-pointer-checks -Os -fno-reorder-blocks
-fno-ipa-cp-clone -pipe -fno-strength-reduce -ffixed-a2
-fno-omit-frame-pointer -fno-optimize-sibling-calls -g
-D"KBUILD_STR(s)=#s" -D"KBUILD_BASENAME=KBUILD_STR(bounds)"
-D"KBUILD_MODNAME=KBUILD_STR(bounds)" -fverbose-asm -S -o
kernel/bounds.s kernel/bounds.c
cc1: error: unrecognized command line option "-fno-ipa-cp-clone"
make[1]: *** [kernel/bounds.s] Error 1
make: *** [prepare0] Error 2

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
