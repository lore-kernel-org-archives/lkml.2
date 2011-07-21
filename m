Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752003Ab1GUJiN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 05:38:13 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:58819 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495Ab1GUJiL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 05:38:11 -0400
MIME-Version: 1.0
In-Reply-To: <1311239914-8301-9-git-send-email-richard@nod.at>
References: <1311239914-8301-1-git-send-email-richard@nod.at>
	<1311239914-8301-9-git-send-email-richard@nod.at>
Date: Thu, 21 Jul 2011 11:38:11 +0200
X-Google-Sender-Auth: idz6du9zs7JFWuytkLeHlSp4W2U
Message-ID: <CAMuHMdUg6xCWFDkN0ApBhPE2Yw4gCcU2Aew60k8J-7oB518FAQ@mail.gmail.com>
Subject: Re: [uml-devel] [PATCH 09/10] um: Ajdust size of pid_buf
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Richard Weinberger <richard@nod.at>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        user-mode-linux-devel@lists.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 21, 2011 at 11:18, Richard Weinberger <richard@nod.at> wrote:
> Linux can have pids up to 4*1024*1024.
> To handle such huge numbers pid_buf needs to be larger.
>
> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>  arch/um/drivers/harddog_user.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/arch/um/drivers/harddog_user.c b/arch/um/drivers/harddog_user.c
> index b56f8e0..84dce3f 100644
> --- a/arch/um/drivers/harddog_user.c
> +++ b/arch/um/drivers/harddog_user.c
> @@ -32,7 +32,7 @@ int start_watchdog(int *in_fd_ret, int *out_fd_ret, char *sock)
>  {
>        struct dog_data data;
>        int in_fds[2], out_fds[2], pid, n, err;
> -       char pid_buf[sizeof("nnnnn\0")], c;
> +       char pid_buf[sizeof("nnnnnnn\0")], c;

Why not make it handle the full 32-bit? That's just a few bytes extra
on the stack...

>        char *pid_args[] = { "/usr/bin/uml_watchdog", "-pid", pid_buf, NULL };
>        char *mconsole_args[] = { "/usr/bin/uml_watchdog", "-mconsole", NULL,
>                                  NULL };
> --
> 1.7.6

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
