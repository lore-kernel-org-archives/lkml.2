Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753003Ab1IMLSJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 07:18:09 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63133 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152Ab1IMLSH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 07:18:07 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1109132030020.14483@nippy.intranet>
References: <1315742394-16036-1-git-send-email-geert@linux-m68k.org>
	<alpine.LNX.2.00.1109132030020.14483@nippy.intranet>
Date: Tue, 13 Sep 2011 13:18:06 +0200
X-Google-Sender-Auth: vYDB7JwRAaydCOEKrwcck1EkU8M
Message-ID: <CAMuHMdXJEeooAjdQo+JhUWJcrGzKZb-jQPPhVggy3ocQyPe3Lw@mail.gmail.com>
Subject: Re: [PATCH 00/28 v6] m68k: Convert to genirq
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Finn Thain <fthain@telegraphics.com.au>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 13, 2011 at 13:11, Finn Thain <fthain@telegraphics.com.au> wrote:
> When I was testing your v5 patch series, I had to patch macmace.c to
> resolve some compiler errors --
>
> --- linux-m68k.orig/drivers/net/macmace.c       2011-09-13 18:33:55.000000000 +1000
> +++ linux-m68k/drivers/net/macmace.c    2011-09-13 18:34:05.000000000 +1000
> @@ -31,8 +31,8 @@
>  #include <linux/dma-mapping.h>
>  #include <linux/platform_device.h>
>  #include <linux/gfp.h>
> +#include <linux/interrupt.h>
>  #include <asm/io.h>
> -#include <asm/irq.h>
>  #include <asm/macints.h>
>  #include <asm/mac_psc.h>
>  #include <asm/page.h>
>
> Would you please check whether this is still needed after the v6 series?

Will do. Don't think I ever saw that problem, though.
Did it show up with genirq disabled or enabled?

> (I'd check myself, but I don't have the source tree on which your emailed
> patches were based...)

They're based on a v3.1-rc5 version of the m68k tree. I think it's
identical to the
current m68k master with v3.1-rc5 merged into.

> BTW, you'll probably want to patch this comment in
> include/linux/interrupt.h --
>
> /*
>  * Special function to avoid ifdeffery in kernel/irq/devres.c which
>  * gets magically built by GENERIC_HARDIRQS=n architectures (sparc,
>  * m68k).

Thanks, will do.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
