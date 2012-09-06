Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751899Ab2IFMD3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 08:03:29 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:39957 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020Ab2IFMD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 08:03:27 -0400
MIME-Version: 1.0
In-Reply-To: <20120906134830.52cbdfec@endymion.delvare>
References: <20120906134830.52cbdfec@endymion.delvare>
Date: Thu, 6 Sep 2012 14:03:27 +0200
X-Google-Sender-Auth: xkxzRklr4rlQbzV9Vu8pBlRHWbs
Message-ID: <CAMuHMdUXvB8P9J26KbMXeicv0BH=gdaCHaRq-ZAP=73hn+ThMw@mail.gmail.com>
Subject: Re: [PATCH] swim: Add missing spinlock init
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Finn Thain <fthain@telegraphics.com.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 6, 2012 at 1:48 PM, Jean Delvare <khali@linux-fr.org> wrote:
> It doesn't seem this spinlock was properly initialized.

Quiet possible. There's no SMP on m68k, so all spinlock ops expand to nothing.

> Signed-off-by: Jean Delvare <khali@linux-fr.org>
> Cc: Finn Thain <fthain@telegraphics.com.au>
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
> I can't even build-test this.
>
>  drivers/block/swim.c |    1 +
>  1 file changed, 1 insertion(+)
>
> --- linux-3.6-rc4.orig/drivers/block/swim.c     2012-07-21 22:58:29.000000000 +0200
> +++ linux-3.6-rc4/drivers/block/swim.c  2012-09-06 13:09:26.713382169 +0200
> @@ -845,6 +845,7 @@ static int __devinit swim_floppy_init(st
>                 swd->unit[drive].swd = swd;
>         }
>
> +       spin_lock_init(&swd->lock);
>         swd->queue = blk_init_queue(do_fd_request, &swd->lock);
>         if (!swd->queue) {
>                 err = -ENOMEM;

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
