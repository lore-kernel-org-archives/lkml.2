Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001Ab1H2HrN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 03:47:13 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35371 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752973Ab1H2HrJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 03:47:09 -0400
MIME-Version: 1.0
In-Reply-To: <1312801699-17474-1-git-send-email-geert@linux-m68k.org>
References: <1312801699-17474-1-git-send-email-geert@linux-m68k.org>
Date: Mon, 29 Aug 2011 09:47:08 +0200
X-Google-Sender-Auth: jXzUpB2jR6xtLTSR-t_w7_ph8vw
Message-ID: <CAMuHMdW9DCbZTWMfbhRu-HR4=bL3sb966RyGZH1FMjhKFzDSdQ@mail.gmail.com>
Subject: Re: [PATCH] tpm: TCG_ATMEL should depend on HAS_IOPORT
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Debora Velarde <debora@linux.vnet.ibm.com>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        Marcel Selhorst <m.selhorst@sirrix.com>
Cc: Jonas Bonn <jonas@southpole.se>, Arnd Bergmann <arnd@arndb.de>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 8, 2011 at 13:08, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> On m68k, I get:
>
> drivers/char/tpm/tpm_atmel.h: In function ‘atmel_get_base_addr’:
> drivers/char/tpm/tpm_atmel.h:129: error: implicit declaration of function ‘ioport_map’
> drivers/char/tpm/tpm_atmel.h:129: warning: return makes pointer from integer without a cast
>
> The code in tpm_atmel.h supports PPC64 (using the device tree and ioremap())
> and "anything else" (using ioport_map()). However, ioportmap() is only
> available on platforms that set HAS_IOPORT.
>
> Although PC64 seems to have HAS_IOPORT, a "depends on HAS_IOPORT" should work,

Since ...

> but I think it's better to expose the special PPC64 handling explicit using

... explicitly ...

> "depends on PPC64 || HAS_IOPORT".
>
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
>  drivers/char/tpm/Kconfig |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/char/tpm/Kconfig b/drivers/char/tpm/Kconfig
> index f6595ab..fa567f1 100644
> --- a/drivers/char/tpm/Kconfig
> +++ b/drivers/char/tpm/Kconfig
> @@ -43,6 +43,7 @@ config TCG_NSC
>
>  config TCG_ATMEL
>        tristate "Atmel TPM Interface"
> +       depends on PPC64 || HAS_IOPORT
>        ---help---
>          If you have a TPM security chip from Atmel say Yes and it
>          will be accessible from within Linux.  To compile this driver
> --
> 1.7.0.4

Ping? M68k allmodconfig breakage in 3.1-rc*.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
