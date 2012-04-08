Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754370Ab2DHIn7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 04:43:59 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:61633 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754041Ab2DHInu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 04:43:50 -0400
MIME-Version: 1.0
In-Reply-To: <1332350313-2501-1-git-send-email-ccross@android.com>
References: <1332350313-2501-1-git-send-email-ccross@android.com>
Date: Sun, 8 Apr 2012 10:43:48 +0200
X-Google-Sender-Auth: 6dTVUM4p57wDSzDvoSX4RJnoW5k
Message-ID: <CAMuHMdXM9bcmNdet4XAvtWuwPAr9KZS_pbm1TzKCM8UW2hcZmw@mail.gmail.com>
Subject: Re: [PATCH] android: make persistent_ram based drivers depend on HAVE_MEMBLOCK
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Colin Cross <ccross@android.com>
Cc: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        John Stultz <john.stultz@linaro.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Android Kernel Team <kernel-team@android.com>,
        gregkh@linuxfoundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2012 at 18:18, Colin Cross <ccross@android.com> wrote:
> m68k doesn't have memblock_reserve, which causes a build failure
> with allmodconfig.  Make PERSISTENT_RAM and RAM_CONSOLE depend on
> HAVE_MEMBLOCK.
>
> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Reported-by: Paul Gortmaker <paul.gortmaker@windriver.com>
> Signed-off-by: Colin Cross <ccross@android.com>

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

> ---
>  drivers/staging/android/Kconfig |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>
> I can't test on m68k, but this disables the options if I remove
> HAVE_MEMBLOCK from arm.
>
> diff --git a/drivers/staging/android/Kconfig b/drivers/staging/android/Kconfig
> index 08a3b11..eb1dee2 100644
> --- a/drivers/staging/android/Kconfig
> +++ b/drivers/staging/android/Kconfig
> @@ -27,13 +27,14 @@ config ANDROID_LOGGER
>
>  config ANDROID_PERSISTENT_RAM
>        bool
> +       depends on HAVE_MEMBLOCK
>        select REED_SOLOMON
>        select REED_SOLOMON_ENC8
>        select REED_SOLOMON_DEC8
>
>  config ANDROID_RAM_CONSOLE
>        bool "Android RAM buffer console"
> -       depends on !S390 && !UML
> +       depends on !S390 && !UML && HAVE_MEMBLOCK
>        select ANDROID_PERSISTENT_RAM
>        default n

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
