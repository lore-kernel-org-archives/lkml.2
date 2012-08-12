Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751132Ab2HLOrd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2012 10:47:33 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:43740 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759Ab2HLOrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2012 10:47:32 -0400
MIME-Version: 1.0
In-Reply-To: <20120812142355.GA16664@localhost>
References: <20120812142355.GA16664@localhost>
Date: Sun, 12 Aug 2012 16:47:31 +0200
X-Google-Sender-Auth: jhRlHQOH1alOqgruzTxFaZ7elNI
Message-ID: <CAMuHMdXNC1SR5HgScihSc=WyX5bk4xB2LefpbS8ZuKJfDTF64A@mail.gmail.com>
Subject: Re: [PATCH] m68k: add generic atomic64_t support
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Greg Ungerer <gerg@uclinux.org>, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Fengguang,

On Sun, Aug 12, 2012 at 4:23 PM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> This fixes build errors like:
>
> fs/namespace.c:2290:1: error: unknown type name 'atomic64_t'
> fs/namespace.c:2290:1: error: implicit declaration of function 'ATOMIC64_INIT' [-Werror=implicit-function-declaration]
> fs/namespace.c:2290:1: error: initializer element is not constant
> fs/namespace.c: In function 'alloc_mnt_ns':
> fs/namespace.c:2299:2: error: implicit declaration of function 'atomic64_add_return' [-Werror=implicit-function-declaration]

> Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
> ---
>  arch/m68k/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
>
> --- linux.orig/arch/m68k/Kconfig        2012-08-12 21:15:49.730533572 +0800
> +++ linux/arch/m68k/Kconfig     2012-08-12 22:19:56.202624988 +0800
> @@ -12,6 +12,7 @@ config M68K
>         select FPU if MMU
>         select ARCH_WANT_IPC_PARSE_VERSION
>         select ARCH_USES_GETTIMEOFFSET if MMU && !COLDFIRE
> +       select GENERIC_ATOMIC64

For several CPU types (68020/68030/68040/68080), this is already selected in
arch/m68k/Kconfig.cpu
So probably this select should be moved to cover more CPU types?

For which config do you get this build error? I can't seem to trigger it in
current mainline nor -next with m5475evb_defconfig.
Does it depend on additional patches to introduce more atomic64 uses?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
