Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755090Ab1HTTqm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Aug 2011 15:46:42 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:63258 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242Ab1HTTql convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Aug 2011 15:46:41 -0400
MIME-Version: 1.0
In-Reply-To: <4E5008A1.8070105@landley.net>
References: <4E5008A1.8070105@landley.net>
Date: Sat, 20 Aug 2011 21:46:41 +0200
X-Google-Sender-Auth: kg4lfq8RwIZ1JxxEw-jDGQoZ9Cw
Message-ID: <CAMuHMdWfpZdwqtPgQKJHYVWRLKMXOeaMWV-mTBQxpE12XNTg_g@mail.gmail.com>
Subject: Re: m68k with mmu doesn't compile after 66d857b08b8c3ed
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Rob Landley <rob@landley.net>
Cc: LKML <linux-kernel@vger.kernel.org>, gerg@uclinux.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rob,

You're really confusing me.

On Sat, Aug 20, 2011 at 21:18, Rob Landley <rob@landley.net> wrote:
> The m68k build in 3.0 dies with this:
>
>  CC      arch/m68k/kernel/dma.o
> In file included from arch/m68k/kernel/dma.c:4:
> arch/m68k/kernel/dma_no.c: In function 'dma_sync_single_for_cpu':
> arch/m68k/kernel/dma_no.c:44: error: implicit declaration of function 'flush_dcache_range'

Your subject says "m68k with mmu doesn't compile", but here you're
obviously compiling for nommu, as dma.c includes dma_no.c if CONFIG_MMU
is not set.

> make[1]: *** [arch/m68k/kernel/dma.o] Error 1
> make: *** [arch/m68k/kernel] Error 2
>
> That file includes <asm/cacheflush.h>, which for m68k is:
>
> #ifdef __uClinux__
> #include "cacheflush_no.h"
> #else
> #include "cacheflush_mm.h"
> #endif
>
> The nommu header (cacheflush_no.h) does #define flush_dcache_range(),
> but the clacheflush_mm.h version does not.  I.E. you can only currently

Are you using a uClinux toolchain that defines __uClinux__, or not?

> build m68k for Coldfire, you can no longer build it for an actual m68k.

JFYI, it builds fine for all "actual m68ks" (with MMU) I'm interested in.
And I guess Greg will say the same for Coldfire and "actual m68ks" without
MMU...

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
