Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583Ab2DRJhK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 05:37:10 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57820 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251Ab2DRJhI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 05:37:08 -0400
MIME-Version: 1.0
In-Reply-To: <1334607965-9582-1-git-send-email-mjg@redhat.com>
References: <1334607965-9582-1-git-send-email-mjg@redhat.com>
Date: Wed, 18 Apr 2012 11:37:08 +0200
X-Google-Sender-Auth: vTFMDoLOFgsXV-DIaSKa_ckkfJo
Message-ID: <CAMuHMdVYSajTYmfXjtVRXhz0u=xW0LbQ5BxjR=n7PP77o0dXhw@mail.gmail.com>
Subject: Re: [PATCH V2 1/4] vgaarb: Add support for setting the default video device
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org, benh@kernel.crashing.org, airlied@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2012 at 22:26, Matthew Garrett <mjg@redhat.com> wrote:
> --- a/include/linux/vgaarb.h
> +++ b/include/linux/vgaarb.h
> @@ -31,6 +31,7 @@
>  #ifndef LINUX_VGA_H
>  #define LINUX_VGA_H
>
> +#include <video/vga.h>

Is this include really needed? x86_64/allmodconfig builds fine without it.

It causes m68k/allmodconfig to fail with:

In file included from include/linux/vgaarb.h:35,
                 from drivers/gpu/drm/drm_irq.c:43:
include/video/vga.h: In function ‘vga_mm_r’:
include/video/vga.h:242: error: implicit declaration of function ‘z_readb’
include/video/vga.h: In function ‘vga_mm_w’:
include/video/vga.h:247: error: implicit declaration of function ‘z_writeb’
include/video/vga.h: In function ‘vga_mm_w_fast’:
include/video/vga.h:253: error: implicit declaration of function ‘z_writew’
make[1]: *** [drivers/gpu/drm/drm_irq.o] Error 1

http://kisskb.ellerman.id.au/kisskb/buildresult/6127136/

Currently <video/vga.h> has a crude hack to make cirrusfb work on Amiga,
but that's the only VGA support m68k has.
There's also no <asm/vga.h>, so m68k/allmodconfig with CONFIG_AMIGA
disabled now fails with:

In file included from include/linux/vgaarb.h:34,
                 from drivers/gpu/drm/drm_irq.c:42:
include/video/vga.h:23:21: error: asm/vga.h: No such file or directory
make[1]: *** [drivers/gpu/drm/drm_irq.o] Error 1

Removing the #include <video/vga.h> fixes both cases.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
