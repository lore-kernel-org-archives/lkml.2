Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755028Ab1LNHws (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 02:52:48 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33056 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753304Ab1LNHwo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 02:52:44 -0500
MIME-Version: 1.0
In-Reply-To: <CAB4K4y74HtRxF6iMayonaSvc2Uoe9Fr+7Bwf9Fr05NwbrSDU8g@mail.gmail.com>
References: <CAB4K4y74HtRxF6iMayonaSvc2Uoe9Fr+7Bwf9Fr05NwbrSDU8g@mail.gmail.com>
Date: Wed, 14 Dec 2011 08:52:42 +0100
X-Google-Sender-Auth: giwpD_kMvJBjsYQvwRa1CqBydWM
Message-ID: <CAMuHMdV_eyMhWS6+CFc--i_KBcyb31u11tEO3OkDQsB4HbYpfA@mail.gmail.com>
Subject: Re: [PATCH 1/1] Staging: zram: print the disk size in KB
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Ajeet Yadav <ajeet.yadav.77@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Jerome Marchand <jmarchan@redhat.com>,
        Nitin Gupta <ngupta@vflare.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 13, 2011 at 06:16, Ajeet Yadav <ajeet.yadav.77@gmail.com> wrote:
> From a5d5ba92b5af9134e617986884856334c377e1d0 Mon Sep 17 00:00:00 2001
> From: Ajeet Yadav <ajeet.yadav.77@gmail.com>
> Date: Mon, 12 Dec 2011 18:42:30 +0530
> Subject: [PATCH 1/1] Staging: zram: print the disk size in KB
>
> Total memory size is in KB, but the zram disk size was not
> printed in KB, correct the figure in KB units.

Kelvin bytes?

> Signed-off-by: Ajeet Yadav <ajeet.yadav.77@gmail.com>
> ---
>  drivers/staging/zram/zram_drv.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
> index 09de99f..ff591e3 100644
> --- a/drivers/staging/zram/zram_drv.c
> +++ b/drivers/staging/zram/zram_drv.c
> @@ -126,7 +126,7 @@ static void zram_set_disksize(struct zram *zram,
> size_t totalram_bytes)
>                "\tMemory Size: %zu kB\n"

kilobytes? Either this ...

>                "\tSize you selected: %llu kB\n"

... and this should be KiB ...

>                "Continuing anyway ...\n",
> -               totalram_bytes >> 10, zram->disksize
> +               totalram_bytes >> 10, zram->disksize >> 10

... or these should be / 1000 instead of >> 10.

>                );
>        }

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
