Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546Ab2GIHeI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 03:34:08 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:48851 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861Ab2GIHeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 03:34:05 -0400
MIME-Version: 1.0
In-Reply-To: <1341784614-2797-5-git-send-email-dh.herrmann@googlemail.com>
References: <1341784614-2797-1-git-send-email-dh.herrmann@googlemail.com>
	<1341784614-2797-5-git-send-email-dh.herrmann@googlemail.com>
Date: Mon, 9 Jul 2012 09:34:04 +0200
X-Google-Sender-Auth: PX6bVyZiq3RjYIJT_umHWQjCq1o
Message-ID: <CAMuHMdWsSqMjqDuE_qgNUjc1eCWZqLLo1GNxwLYZNih=YBFh0g@mail.gmail.com>
Subject: Re: [PATCH v2 04/11] fbdev: export get_fb_info()/put_fb_info()
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: David Herrmann <dh.herrmann@googlemail.com>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        florianschandinat@gmx.de, linux-fbdev@vger.kernel.org,
        gregkh@linuxfoundation.org, alan@lxorguk.ukuu.org.uk,
        bonbons@linux-vserver.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 8, 2012 at 11:56 PM, David Herrmann
<dh.herrmann@googlemail.com> wrote:
> --- a/drivers/video/fbmem.c
> +++ b/drivers/video/fbmem.c
> @@ -46,7 +46,7 @@ static DEFINE_MUTEX(registration_lock);
>  struct fb_info *registered_fb[FB_MAX] __read_mostly;
>  int num_registered_fb __read_mostly;
>
> -static struct fb_info *get_fb_info(unsigned int idx)
> +struct fb_info *get_fb_info(unsigned int idx)
>  {
>         struct fb_info *fb_info;
>
> @@ -61,14 +61,16 @@ static struct fb_info *get_fb_info(unsigned int idx)
>
>         return fb_info;
>  }
> +EXPORT_SYMBOL(get_fb_info);

EXPORT_SYMBOL_GPL?

> -static void put_fb_info(struct fb_info *fb_info)
> +void put_fb_info(struct fb_info *fb_info)
>  {
>         if (!atomic_dec_and_test(&fb_info->count))
>                 return;
>         if (fb_info->fbops->fb_destroy)
>                 fb_info->fbops->fb_destroy(fb_info);
>  }
> +EXPORT_SYMBOL(put_fb_info);

EXPORT_SYMBOL_GPL?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
