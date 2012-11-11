Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752445Ab2KKKAW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 05:00:22 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:40580 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969Ab2KKKAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 05:00:20 -0500
MIME-Version: 1.0
In-Reply-To: <1352627709-12732-1-git-send-email-geert@linux-m68k.org>
References: <1352627709-12732-1-git-send-email-geert@linux-m68k.org>
Date: Sun, 11 Nov 2012 11:00:20 +0100
X-Google-Sender-Auth: NYFDrRuZ65JbIIVrJR14vBgLlFs
Message-ID: <CAMuHMdUzvFfJLmvRL0f_ghXBFfzOhx-uKVU0a8E2mNRH=RzfVw@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.7-rc4
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-kernel@vger.kernel.org
Cc: "the arch/x86 maintainers" <x86@kernel.org>, linuxppc-dev@lists.ozlabs.org,
        sparclinux <sparclinux@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 11, 2012 at 10:55 AM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> JFYI, when comparing v3.7-rc4 to v3.7-rc3[3], the summaries are:
>   - build errors: +4/-235

  + error: No rule to make target include/config/auto.conf:  => N/A

x86_64-randconfig

  + error: phy_n.c: relocation truncated to fit: R_PPC64_REL24 against
symbol `._mcount' defined in .text section in
arch/powerpc/kernel/entry_64.o: (.text+0x1ff96e8) =>
(.text+0x1ff8348), (.text+0x1ff7c54), (.text+0x1ff96fc),
(.text+0x1ff8048), (.text+0x1ff90b4)
  + error: phy_n.c: relocation truncated to fit: R_PPC64_REL24 against
symbol `_restgpr0_21' defined in .text.save.restore section in
arch/powerpc/lib/built-in.o:  => (.text+0x1ff9e80)
  + error: relocation truncated to fit: R_PPC64_REL24 against symbol
`.memset' defined in .text section in arch/powerpc/lib/built-in.o:  =>
(.text+0x1ffa004)

powerpc-allyesconfig

>   - build warnings: +2027/-170

Scary, but the majority (+1987) turn out to be those pesky sparc-allmodconfig
"__mcount_loc already exists" warnings. Can they please be fixed?

> As I haven't mastered kup yet, there's no verbose summary at
> http://www.kernel.org/pub/linux/kernel/people/geert/linux-log/v3.7-rc4.summary.gz
>
> Happy fixing! ;-)
>
> Thanks to the linux-next team for providing the build service.
>
> [1] http://kisskb.ellerman.id.au/kisskb/head/5600/ (all 117 configs)
> [3] http://kisskb.ellerman.id.au/kisskb/head/5580/ (all 117 configs)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
