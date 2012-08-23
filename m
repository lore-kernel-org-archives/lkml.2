Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934385Ab2HWUu2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 16:50:28 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:48704 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934359Ab2HWUuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 16:50:22 -0400
MIME-Version: 1.0
In-Reply-To: <1345754768-4634-1-git-send-email-geert@linux-m68k.org>
References: <1345754768-4634-1-git-send-email-geert@linux-m68k.org>
Date: Thu, 23 Aug 2012 22:50:22 +0200
X-Google-Sender-Auth: gRpBwmqEgQSN410y7bDAZzPXNJY
Message-ID: <CAMuHMdWFY_iOXTfLO7zCm_RTdkEjj7BpT5o9pJ6cu3LdT8JsYQ@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.6-rc3
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-kernel@vger.kernel.org
Cc: "the arch/x86 maintainers" <x86@kernel.org>, linuxppc-dev@lists.ozlabs.org,
        linux-xtensa@linux-xtensa.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2012 at 10:46 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> JFYI, when comparing v3.6-rc3 to v3.6-rc2[3], the summaries are:
>   - build errors: +13/-9

  + arch/x86/include/asm/uaccess_32.h: error: call to
'copy_from_user_overflow' declared with attribute error:
copy_from_user() buffer size is not provably correct:  => 211:26

i386_defconfig, i386-randconfig, x86_64_defconfig

  + drivers/extcon/extcon_gpio.c: error: implicit declaration of
function 'devm_gpio_request_one'
[-Werror=implicit-function-declaration]:  => 110:2

xtensa-allmodconfig

  + error: No rule to make target drivers/scsi/aic7xxx/aicasm/*.[chyl]:  => N/A

i386-randconfig

  + error: eni.c: relocation truncated to fit: R_PPC64_REL24 against
symbol `._raw_read_lock' defined in .spinlock.text section in
kernel/built-in.o:  => (.text+0x1ff91bc)
  + error: eni.c: relocation truncated to fit: R_PPC64_REL24 against
symbol `.sprintf' defined in .text section in lib/lib.a(vsprintf.o):
=> (.text+0x1ff940c)
  + error: eni.c: relocation truncated to fit: R_PPC64_REL24 against
symbol `_restgpr0_16' defined in .text.save.restore section in
arch/powerpc/lib/built-in.o:  => (.text+0x1ffa6e8)
  + error: eni.c: relocation truncated to fit: R_PPC64_REL24 against
symbol `_savegpr0_27' defined in .text.save.restore section in
arch/powerpc/lib/built-in.o:  => (.text+0x1ff9854)
  + error: eni.c: relocation truncated to fit: R_PPC64_REL24 against
symbol `_savegpr0_30' defined in .text.save.restore section in
arch/powerpc/lib/built-in.o:  => (.text+0x1ff8eb4), (.text+0x1ff8e80)
  + error: fore200e.c: relocation truncated to fit: R_PPC64_REL24
against symbol `._raw_spin_unlock_irqrestore' defined in
.spinlock.text section in kernel/built-in.o:  => (.text+0x1ff82cc),
(.text+0x1ff8278)
  + error: fore200e.c: relocation truncated to fit: R_PPC64_REL24
against symbol `.mutex_unlock' defined in .sched.text section in
kernel/built-in.o:  => (.text+0x1ff83fc), (.text+0x1ff83a8)

powerpc-allyesconfig

  + error: via-pmu-event.c: undefined reference to
`.input_allocate_device':  => .init.text+0xdfbc)
  + error: via-pmu-event.c: undefined reference to
`.input_free_device':  => .init.text+0xe084)
  + error: via-pmu-event.c: undefined reference to
`.input_register_device':  => .init.text+0xe06c)

powerpc-randconfig

> [1] http://kisskb.ellerman.id.au/kisskb/head/5359/ (all 116 configs)
> [3] http://kisskb.ellerman.id.au/kisskb/head/5338/ (all 116 configs)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
