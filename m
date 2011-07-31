Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752985Ab1GaWLN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 18:11:13 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:51466 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752900Ab1GaWLJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 18:11:09 -0400
MIME-Version: 1.0
In-Reply-To: <1312066923.22074.53.camel@i7.infradead.org>
References: <1312066693.22074.50.camel@i7.infradead.org>
	<1312066923.22074.53.camel@i7.infradead.org>
Date: Mon, 1 Aug 2011 00:11:08 +0200
Message-ID: <CAFLxGvy0QqoySDFwZpygHeXvQ7hG-B7z5iZq8qx3GUkFX8w2RQ@mail.gmail.com>
Subject: Re: [PATCH 1/5] um: Use __i386__ in ifdef for vsyscall exports, not SUBARCH_i386
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Arnaud Lacombe <lacombar@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        user-mode-linux-devel@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 31, 2011 at 1:02 AM, David Woodhouse <dwmw2@infradead.org> wrote:
> Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
> ---
>  arch/um/os-Linux/Makefile    |    2 --
>  arch/um/os-Linux/user_syms.c |    2 +-
>  2 files changed, 1 insertions(+), 3 deletions(-)
>
> diff --git a/arch/um/os-Linux/Makefile b/arch/um/os-Linux/Makefile
> index b33f4df..78658a7 100644
> --- a/arch/um/os-Linux/Makefile
> +++ b/arch/um/os-Linux/Makefile
> @@ -13,8 +13,6 @@ USER_OBJS := $(user-objs-y) aio.o elf_aux.o execvp.o file.o helper.o irq.o \
>        main.o mem.o process.o registers.o sigio.o signal.o start_up.o time.o \
>        tty.o tls.o uaccess.o umid.o util.o
>
> -CFLAGS_user_syms.o += -DSUBARCH_$(SUBARCH)
> -
>  HAVE_AIO_ABI := $(shell [ -r /usr/include/linux/aio_abi.h ] && \
>        echo -DHAVE_AIO_ABI )
>  CFLAGS_aio.o += $(HAVE_AIO_ABI)
> diff --git a/arch/um/os-Linux/user_syms.c b/arch/um/os-Linux/user_syms.c
> index 45ffe46..9165513 100644
> --- a/arch/um/os-Linux/user_syms.c
> +++ b/arch/um/os-Linux/user_syms.c
> @@ -45,7 +45,7 @@ EXPORT_SYMBOL(readdir64);
>  extern void truncate64(void) __attribute__((weak));
>  EXPORT_SYMBOL(truncate64);
>
> -#ifdef SUBARCH_i386
> +#ifdef __i386__
>  EXPORT_SYMBOL(vsyscall_ehdr);
>  EXPORT_SYMBOL(vsyscall_end);
>  #endif

Why do we need this?

-- 
Thanks,
//richard
