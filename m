Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751925Ab2JBSix (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 14:38:53 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:63321 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589Ab2JBSiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 14:38:51 -0400
MIME-Version: 1.0
In-Reply-To: <1349202763-1601-1-git-send-email-geert@linux-m68k.org>
References: <1349202763-1601-1-git-send-email-geert@linux-m68k.org>
Date: Tue, 2 Oct 2012 20:38:50 +0200
X-Google-Sender-Auth: zLHNENp6jfnJS26bYvRV8IdtqRc
Message-ID: <CAMuHMdXcMVkcqTJdH2zdo9=a2efeeQmPGUr9GZqRMuRrAuMBvw@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.6
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-kernel@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org, Chris Zankel <chris@zankel.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 2, 2012 at 8:32 PM, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> JFYI, when comparing v3.6 to v3.6-rc7[3], the summaries are:
>   - build errors: +4/-1

  + arch/powerpc/platforms/512x/mpc512x_shared.c: error:
'FSL_DIU_PORT_DVI' undeclared (first use in this function):  => 189:9
  + arch/powerpc/platforms/512x/mpc512x_shared.c: error: parameter 1
('port') has incomplete type:  => 187:54, 83:56, 88:57, 69:56
  + arch/powerpc/platforms/512x/mpc512x_shared.c: error: return type
is an incomplete type:  => 187:1

powerpc-randconfig

  + drivers/net/ethernet/realtek/r8169.c: error: expected identifier
before numeric constant:  => 451:2

xtensa-allmodconfig (hmm, this is not a new one, it felt through the
cracks in -rc7 because
of log line interleaving).

Ugh, arch/xtensa/include/asm/regs.h defines way to generic symbols,
like "MISC" (which
causes the above breakage), and even a few 2-letter symbols, which
surprisingly don't
cause conflicts...

> [1] http://kisskb.ellerman.id.au/kisskb/head/5469/ (all 117 configs)
> [3] http://kisskb.ellerman.id.au/kisskb/head/5445/ (all 117 configs)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
