Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757041Ab0DGR4W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 13:56:22 -0400
Received: from mail-iw0-f197.google.com ([209.85.223.197]:57458 "EHLO
	mail-iw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754257Ab0DGR4V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 13:56:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=hOHt1Pu7Vxkr+wf2TQv60dA33B+AcNMy6llJChULvN5kCFkbmrsnPpbGqcIaEYH1Ha
         LTACCToBYTjnmyUD4JxB27Yh+L2o1uEJU0+E9R+jx6psn24hI3rFY4ginM48JfJEtf8l
         iM0Hok53umY+ox0beNGhx7rVTcapUb3F/KtZo=
MIME-Version: 1.0
In-Reply-To: <201004062159.o36Lx320032351@hera.kernel.org>
References: <201004062159.o36Lx320032351@hera.kernel.org>
Date: Wed, 7 Apr 2010 19:56:18 +0200
X-Google-Sender-Auth: 1e2920a535c2da6d
Message-ID: <v2t10f740e81004071056w26ed1b84i1e4af6a7747b70e3@mail.gmail.com>
Subject: Re: [WATCHDOG] set max63xx driver as ARM only
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Marc Zyngier <maz@misterjones.org>, Wim Van Sebroeck <wim@iguana.be>,
       Andrew Morton <akpm@linux-foundation.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 6, 2010 at 23:59, Linux Kernel Mailing List
<linux-kernel@vger.kernel.org> wrote:
> Gitweb:     http://git.kernel.org/linus/5e8037166497f8a1aa46325ed7febf0408d45caa
> Commit:     5e8037166497f8a1aa46325ed7febf0408d45caa
> Parent:     35c79780064976cf9d7537a00e59f97c2061fa7d
> Author:     Marc Zyngier <maz@misterjones.org>
> AuthorDate: Mon Mar 29 20:09:14 2010 +0100
> Committer:  Wim Van Sebroeck <wim@iguana.be>
> CommitDate: Sat Apr 3 22:39:30 2010 +0000
>
>    [WATCHDOG] set max63xx driver as ARM only
>
>    Use of ioremap() causes build failure on S390.
>    Restrict the driver to ARM until another architecture comes along
>    and enables the driver for its own use.
>
>    Signed-off-by: Marc Zyngier <maz@misterjones.org>
>    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
>    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>  drivers/watchdog/Kconfig |   11 ++++++-----
>  1 files changed, 6 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
> index bdcdbd5..0e8468f 100644
> --- a/drivers/watchdog/Kconfig
> +++ b/drivers/watchdog/Kconfig
> @@ -55,11 +55,6 @@ config SOFT_WATCHDOG
>          To compile this driver as a module, choose M here: the
>          module will be called softdog.
>
> -config MAX63XX_WATCHDOG
> -       tristate "Max63xx watchdog"
> -       help
> -         Support for memory mapped max63{69,70,71,72,73,74} watchdog timer.
> -
>  config WM831X_WATCHDOG
>        tristate "WM831x watchdog"
>        depends on MFD_WM831X
> @@ -305,6 +300,12 @@ config TS72XX_WATCHDOG
>          To compile this driver as a module, choose M here: the
>          module will be called ts72xx_wdt.
>
> +config MAX63XX_WATCHDOG
> +       tristate "Max63xx watchdog"
> +       depends on ARM

Shouldn't that have been `depends on HAS_IOMEM' instead?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
