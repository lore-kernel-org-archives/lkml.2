Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932065Ab2FTJFZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 05:05:25 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:38558 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755867Ab2FTJFW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 05:05:22 -0400
MIME-Version: 1.0
In-Reply-To: <1331850130-32085-1-git-send-email-tony@bakeyournoodle.com>
References: <1331850130-32085-1-git-send-email-tony@bakeyournoodle.com>
Date: Wed, 20 Jun 2012 11:05:21 +0200
X-Google-Sender-Auth: 3Y4ISZVqbUYqQhh5n69P1Ox7snA
Message-ID: <CAMuHMdWmxwba4sfC9Eg6O=SQM0EJhquh0J9ca6DhjOc7wkv8cA@mail.gmail.com>
Subject: Re: [PATCH] mn10300: Remove -mmemfuncs from KBUILD_CFLAGS
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Tony Breeds <tony@bakeyournoodle.com>
Cc: David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        linux-am33-list@redhat.com,
        Linux Kernel ML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2012 at 11:22 PM, Tony Breeds <tony@bakeyournoodle.com> wrote:
> It seems the current (gcc 4.6.3) no longer provide this so remove it.
>
> With this patch the mn10300 architecture cross-compiles with gcc-4.6.3
>
> Signed-off-by: Tony Breeds <tony@bakeyournoodle.com>
> ---
>  arch/mn10300/Makefile |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/arch/mn10300/Makefile b/arch/mn10300/Makefile
> index 7120282..d6116c5 100644
> --- a/arch/mn10300/Makefile
> +++ b/arch/mn10300/Makefile
> @@ -26,7 +26,7 @@ CHECKFLAGS    +=
>  PROCESSOR      := unset
>  UNIT           := unset
>
> -KBUILD_CFLAGS  += -mam33 -mmem-funcs -DCPU=AM33
> +KBUILD_CFLAGS  += -mam33 -DCPU=AM33
>  KBUILD_AFLAGS  += -mam33 -DCPU=AM33
>
>  ifeq ($(CONFIG_MN10300_CURRENT_IN_E2),y)

Still needed: http://kisskb.ellerman.id.au/kisskb/buildresult/6546343/

Should it use $(call cc-option ...) instead?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
