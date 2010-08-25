Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827Ab0HYUWv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 16:22:51 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:61678 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753557Ab0HYUWu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 16:22:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=RYEbc6X597FZn1jqaTpkan9ZluwaWbG4cSl4MruSK+f6nszPoeHd288jaXP8ggwui1
         wpaKlhFMTecIwo5QHiiUGZbLKuOFzaZxX4jM1y68BPpdglIkOjKOnteHTu67iV3rsQFi
         aylo36NRhtD6hpdRsX4LJhwRB4j8DZa97VgwY=
MIME-Version: 1.0
In-Reply-To: <20100825141111.GI21862@riva.ucam.org>
References: <20100825141111.GI21862@riva.ucam.org>
Date: Wed, 25 Aug 2010 22:22:48 +0200
X-Google-Sender-Auth: 0BWIlw8uZk4QkcdizRstrqkEoLc
Message-ID: <AANLkTin=WN6EmQno+tLo_o_iT=28h0RJW-Xjq-qFysCa@mail.gmail.com>
Subject: Re: [PATCH] Add new linearfb driver
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Colin Watson <cjwatson@canonical.com>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Jones <pjones@redhat.com>, Matthew Garrett <mjg@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 25, 2010 at 16:11, Colin Watson <cjwatson@canonical.com> wrote:
> Split out linearfb from efifb so that boot loaders can program it as a
> simple linear framebuffer on non-EFI systems.  This is useful for boot
> loaders with their own graphics drivers, e.g. GRUB 2, since in some
> cases on x86 they can set up non-VESA modes and thus can't program
> vesafb.

Nice! I guess offb and a few other old drivers could use it, too.

> diff --git a/drivers/video/linearfb.c b/drivers/video/linearfb.c
> new file mode 100644
> index 0000000..c93eaac
> --- /dev/null
> +++ b/drivers/video/linearfb.c

> +int linearfb_get_info(struct platform_device *dev, struct fb_info **p_info)
> +{
> +       int err;
> +       unsigned int size_vmode;
> +       unsigned int size_remap;
> +       unsigned int size_total;
> +       int request_succeeded = 0;
> +       struct fb_info *info;
> +
> +       if (!screen_info.lfb_depth)
> +               screen_info.lfb_depth = 32;
> +       if (!screen_info.pages)
> +               screen_info.pages = 1;
> +       if (!screen_info.lfb_base) {
> +               printk(KERN_DEBUG "linearfb: invalid framebuffer address\n");
> +               return -ENODEV;
> +       }

[...]

Wouldn't it be more logical to extract this info somewhere from the
platform_device's
platform_data? Screen_info is such a legacy thing.
That way linearfb can support multiple displays as well.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
