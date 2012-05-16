Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759888Ab2EPIrT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 04:47:19 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:49900 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759761Ab2EPIrO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 04:47:14 -0400
MIME-Version: 1.0
In-Reply-To: <1337157034-22773-1-git-send-email-geert@linux-m68k.org>
References: <1337157034-22773-1-git-send-email-geert@linux-m68k.org>
Date: Wed, 16 May 2012 10:47:13 +0200
X-Google-Sender-Auth: Jcv9hxKdZn6dOC56sFi_AHoCJqQ
Message-ID: <CAMuHMdUtL4_mv-e-EQAZmNcb9dAT=PXB59i7Vuj2vf8NnaBFzQ@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.4-rc7
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-kernel@vger.kernel.org
Cc: Linuxppc-dev <linuxppc-dev@ozlabs.org>,
        Parisc List <linux-parisc@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2012 at 10:30 AM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> JFYI, when comparing v3.4-rc7 to v3.4-rc6[3], the summaries are:
>  - build errors: +15/-14

15 regressions:
  + arch/powerpc/platforms/512x/mpc512x_shared.c: error: 'enum
fsl_diu_monitor_port' declared inside parameter list [-Werror]:  =>
70:9, 84:9, 88:36
  + arch/powerpc/platforms/512x/mpc512x_shared.c: error: 'return' with
a value, in function returning void [-Werror]:  => 189:2
  + arch/powerpc/platforms/512x/mpc512x_shared.c: error: function
declaration isn't a prototype [-Werror=strict-prototypes]:  => 69:5,
88:6, 83:6, 187:1
  + arch/powerpc/platforms/512x/mpc512x_shared.c: error: its scope is
only this definition or declaration, which is probably not what you
want [-Werror]:  => 70:9
  + drivers/virt/fsl_hypervisor.c: error: 'MSR_GS' undeclared (first
use in this function):  => 799:80

powerpc randconfig

  + arch/x86/include/asm/uaccess_32.h: error: call to
'copy_from_user_overflow' declared with attribute error:
copy_from_user() buffer size is not provably correct:  => 211:26

error in i386-randconfig, warning in i386-defconfig

  + drivers/ptp/ptp_pch.c: error: implicit declaration of function
'kfree' [-Werror=implicit-function-declaration]:  => 576:2
  + drivers/ptp/ptp_pch.c: error: implicit declaration of function
'kzalloc' [-Werror=implicit-function-declaration]:  => 587:2

Patch send.

  + error: "handle_edge_irq" [drivers/gpio/gpio-pch.ko] undefined!:  => N/A
  + error: "irq_to_desc" [drivers/gpio/gpio-pch.ko] undefined!:  => N/A

Fixed in the mean time, I guess.

  + error: No rule to make target include/config/auto.conf:  => N/A

x86_64-randconfig

  + lib/mpi/generic_mpih-mul1.c: error: inconsistent operand
constraints in an 'asm':  => 50:70
  + lib/mpi/generic_mpih-mul2.c: error: inconsistent operand
constraints in an 'asm':  => 49:70
  + lib/mpi/generic_mpih-mul3.c: error: inconsistent operand
constraints in an 'asm':  => 49:70
  + lib/mpi/mpih-div.c: error: inconsistent operand constraints in an
'asm':  => 135:122, 135:371, 97:122, 106:121, 106:370, 97:371

parisc-allmodconfig

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
