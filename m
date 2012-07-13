Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757636Ab2GMUuP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 16:50:15 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:38682 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755310Ab2GMUuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 16:50:13 -0400
MIME-Version: 1.0
In-Reply-To: <1340219980-12369-1-git-send-email-geert@linux-m68k.org>
References: <1340219980-12369-1-git-send-email-geert@linux-m68k.org>
Date: Fri, 13 Jul 2012 22:50:11 +0200
X-Google-Sender-Auth: y2DFE90Nr8Z0Dp9B3SeKuUo_NHU
Message-ID: <CAMuHMdUuP6eGSrJ+W75bRe13d+okA=RESsyje5JKX7xfjxHtnw@mail.gmail.com>
Subject: Re: [PATCH] mn10300: Fix pull clearing RESTORE_SIGMASK into
 block_sigmask() fallout
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Al Viro <viro@zeniv.linux.org.uk>, David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Cc: linux-am33-list@redhat.com, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping?

On Wed, Jun 20, 2012 at 9:19 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> commit a610d6e672d6d3723e8da257ad4a8a288a8f2f89 ("pull clearing
> RESTORE_SIGMASK into block_sigmask()") caused:
>
> arch/mn10300/kernel/signal.c: In function 'handle_signal':
> arch/mn10300/kernel/signal.c:462:3: warning: 'return' with no value, in function returning non-void [-Wreturn-type]
>
> Add the missing return values, and restore the indentation while we're at
> it.
>
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
>  arch/mn10300/kernel/signal.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/arch/mn10300/kernel/signal.c b/arch/mn10300/kernel/signal.c
> index 6ab0bee..4d584ae 100644
> --- a/arch/mn10300/kernel/signal.c
> +++ b/arch/mn10300/kernel/signal.c
> @@ -459,10 +459,11 @@ static int handle_signal(int sig,
>         else
>                 ret = setup_frame(sig, ka, oldset, regs);
>         if (ret)
> -               return;
> +               return ret;
>
>         signal_delivered(sig, info, ka, regs,
> -                                test_thread_flag(TIF_SINGLESTEP));
> +                        test_thread_flag(TIF_SINGLESTEP));
> +       return 0;
>  }
>
>  /*
> --
> 1.7.0.4

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
