Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754427Ab2IIUoM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 16:44:12 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:43464 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340Ab2IIUoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 16:44:10 -0400
MIME-Version: 1.0
In-Reply-To: <1347223280-29847-1-git-send-email-geert@linux-m68k.org>
References: <1347223280-29847-1-git-send-email-geert@linux-m68k.org>
Date: Sun, 9 Sep 2012 22:44:09 +0200
X-Google-Sender-Auth: RLOMWiR5rBjGKoGrYpNS-8yv8-Q
Message-ID: <CAMuHMdVDJLKsa=H63hwsNL1DJtuX+YF=ZN5AAo7NvYbFX2itTg@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.6-rc5
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-kernel@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 9, 2012 at 10:41 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> JFYI, when comparing v3.6-rc5 to v3.6-rc4[3], the summaries are:
>   - build errors: +15/-4

  + arch/powerpc/platforms/512x/mpc512x_shared.c: error:
'FSL_DIU_PORT_DVI' undeclared (first use in this function):  => 189:9
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
  + arch/powerpc/platforms/512x/mpc512x_shared.c: error: parameter 1
('port') has incomplete type:  => 187:54, 83:56, 88:57, 69:56
  + arch/powerpc/platforms/512x/mpc512x_shared.c: error: return type
is an incomplete type:  => 187:1
  + arch/powerpc/sysdev/mpic.c: error: case label does not reduce to
an integer constant:  => 890:9, 898:9, 886:9, 894:9
  + arch/powerpc/sysdev/mv64x60_dev.c: error: assignment makes pointer
from integer without a cast [-Werror]:  => 253:11
  + arch/powerpc/sysdev/mv64x60_dev.c: error: implicit declaration of
function 'of_get_mac_address' [-Werror=implicit-function-declaration]:
 => 253:2
  + arch/powerpc/sysdev/tsi108_dev.c: error: assignment makes pointer
from integer without a cast [-Werror]:  => 107:12
  + arch/powerpc/sysdev/tsi108_dev.c: error: implicit declaration of
function 'of_get_mac_address' [-Werror=implicit-function-declaration]:
 => 107:3

powerpc-randconfig (it was a good random config today ;-)

  + error: fore200e.c: relocation truncated to fit: R_PPC64_REL24
against symbol `_restgpr0_23' defined in .text.save.restore section in
arch/powerpc/lib/built-in.o:  => (.text+0x1ff8134)
  + error: fore200e.c: relocation truncated to fit: R_PPC64_REL24
against symbol `_restgpr0_25' defined in .text.save.restore section in
arch/powerpc/lib/built-in.o:  => (.text+0x1ff884c)
  + error: fore200e.c: relocation truncated to fit: R_PPC64_REL24
against symbol `_savegpr0_27' defined in .text.save.restore section in
arch/powerpc/lib/built-in.o:  => (.text+0x1ff8e54)

powerpc-allyesconfig

> [1] http://kisskb.ellerman.id.au/kisskb/head/5400/ (all 116 configs)
> [3] http://kisskb.ellerman.id.au/kisskb/head/5381/ (all 116 configs)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
