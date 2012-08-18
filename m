Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282Ab2HRNUp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 09:20:45 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:38548 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754868Ab2HRNUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 09:20:43 -0400
MIME-Version: 1.0
In-Reply-To: <1344275476.14513.99.camel@localhost.localdomain>
References: <1344275476.14513.99.camel@localhost.localdomain>
Date: Sat, 18 Aug 2012 15:20:42 +0200
X-Google-Sender-Auth: Q0SX-pDQNvYu21y9JP9oSQArbqU
Message-ID: <CAMuHMdWzw=hP2E2iXuNv_euXhreaGUE_91EZ2OcbtTm2HSUS7w@mail.gmail.com>
Subject: Re: [PATCH] m68k: Use PTR_RET rather than if(IS_ERR(.. [2]
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, applied and queued for 3.7.

On Mon, Aug 6, 2012 at 7:51 PM, Thomas Meyer <thomas@m3y3r.de> wrote:
> The semantic patch that makes this change is available
> in scripts/coccinelle/api/ptr_ret.cocci.
>
> More information about semantic patching is available at
> http://coccinelle.lip6.fr/
>
> Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
> ---
>
> diff -u -p a/arch/m68k/q40/config.c b/arch/m68k/q40/config.c
> --- a/arch/m68k/q40/config.c
> +++ b/arch/m68k/q40/config.c
> @@ -338,9 +338,6 @@ static __init int q40_add_kbd_device(voi
>                 return -ENODEV;
>
>         pdev = platform_device_register_simple("q40kbd", -1, NULL, 0);
> -       if (IS_ERR(pdev))
> -               return PTR_ERR(pdev);
> -
> -       return 0;
> +       return PTR_RET(pdev);
>  }
>  arch_initcall(q40_add_kbd_device);

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
