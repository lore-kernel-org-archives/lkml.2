Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757200Ab0JVOrG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 10:47:06 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:41911 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152Ab0JVOrE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 10:47:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=SdIu0IeEVk6++9JFn9E/NBUr//2gdvTD9BuNmXV7Pewyut1tb7Ct3QcC2XSJdjc2Z7
         0Xj896VdiY+qKHt6EbdqGsUvMxvuHesb23KdHpwGAj6AbS8MBn+MJK0+rXl1EYgIDQwp
         FFyJSzOM6LkAff+aI6pwU+DYanY3T6c7t7Q7M=
MIME-Version: 1.0
In-Reply-To: <20101022133130.4cb2cb96@absol.kitzblitz>
References: <20101022133130.4cb2cb96@absol.kitzblitz>
Date: Fri, 22 Oct 2010 16:47:02 +0200
X-Google-Sender-Auth: QoYuWH1A__J65KQhOA84Jpv3piI
Message-ID: <AANLkTimAb_gjx7m6pKvYHL=SjB9DousdUJA2K9uyPt1F@mail.gmail.com>
Subject: Re: [PATCH] rivafb: dubious assignment
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Nicolas Kaiser <nikai@nikai.net>, Jeff Garzik <jgarzik@pobox.com>
Cc: Antonino Daplas <adaplas@gmail.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 22, 2010 at 13:31, Nicolas Kaiser <nikai@nikai.net> wrote:
> A duplicated assignment unconditionally changes max_gfsize to
> GFIFO_SIZE.
>
> It looks to me like this might not be intended, or is it?
>
> Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
> ---
>  drivers/video/riva/riva_hw.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/video/riva/riva_hw.c b/drivers/video/riva/riva_hw.c
> index 78fdbf5..936abfa 100644
> --- a/drivers/video/riva/riva_hw.c
> +++ b/drivers/video/riva/riva_hw.c
> @@ -263,7 +263,6 @@ static int nv3_iterate(nv3_fifo_info *res_info, nv3_sim_state * state, nv3_arb_i
>     vmisses = 2;
>     if (ainfo->gburst_size == 128) max_gfsize = GFIFO_SIZE_128;
>     else  max_gfsize = GFIFO_SIZE;
> -    max_gfsize = GFIFO_SIZE;
>     while (1)
>     {
>         if (ainfo->vid_en)
> --
> 1.7.2.2

According to full-history-linux, this comes from the initial drop in 2.3.49pre2,
from nVidia code(?), imported by Jeff Garzik.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
