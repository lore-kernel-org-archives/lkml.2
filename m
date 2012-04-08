Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753780Ab2DHInR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 04:43:17 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:48501 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869Ab2DHInP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 04:43:15 -0400
MIME-Version: 1.0
In-Reply-To: <20120207051327.GA11737@oksana.dev.rtsoft.ru>
References: <20120207051327.GA11737@oksana.dev.rtsoft.ru>
Date: Sun, 8 Apr 2012 10:43:13 +0200
X-Google-Sender-Auth: YQM9dN0affdKbsBcLX1aNjTtap0
Message-ID: <CAMuHMdVjvw3Go99M9ByCSD+FKYy3mG8=Mq65KaY8Yu_kmc+eYw@mail.gmail.com>
Subject: Re: [PATCH] staging: android/ram_console: Don't build on arches w/o ioremap
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Greg KH <gregkh@linuxfoundation.org>, San Mehat <san@google.com>,
        Colin Cross <ccross@android.com>,
        =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
        kernel-team@android.com, linaro-kernel@lists.linaro.org,
        linux-kernel@vger.kernel.org, Chris Metcalf <cmetcalf@tilera.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 7, 2012 at 06:13, Anton Vorontsov
<anton.vorontsov@linaro.org> wrote:
> This patch fixes UML build:
>
>    CC      drivers/staging/android/ram_console.o
>  drivers/staging/android/ram_console.c: In function
>  'ram_console_driver_probe':
>  drivers/staging/android/ram_console.c:358:2: error: implicit declaration
>  of function 'ioremap' [-Werror=implicit-function-declaration]
>  cc1: some warnings being treated as errors
>  make[3]: *** [drivers/staging/android/ram_console.o] Error 1
>
> Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
> ---
>  drivers/staging/android/Kconfig |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/staging/android/Kconfig b/drivers/staging/android/Kconfig
> index becf711..2054ccb 100644
> --- a/drivers/staging/android/Kconfig
> +++ b/drivers/staging/android/Kconfig
> @@ -27,6 +27,7 @@ config ANDROID_LOGGER
>
>  config ANDROID_RAM_CONSOLE
>        bool "Android RAM buffer console"
> +       depends on !S390 && !UML

Shouldn't that be "depends on HAS_IOMEM" instead?
I guess it also break on tile, which is the third NO_IOMEM arch?

>        default n

Superfluous, "n" is the default.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
