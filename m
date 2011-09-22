Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752Ab1IVTkX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 15:40:23 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49709 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753201Ab1IVTkS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 15:40:18 -0400
MIME-Version: 1.0
In-Reply-To: <20110922184316.25068.54702.stgit@localhost.localdomain>
References: <20110922184316.25068.54702.stgit@localhost.localdomain>
Date: Thu, 22 Sep 2011 21:40:17 +0200
X-Google-Sender-Auth: OjfKoQq3N95zeZtOOpBg3TDuFrw
Message-ID: <CAMuHMdWBz9+TCBUbaOY3HRv=khiDHkRCKdx5e53HCen54RUBVw@mail.gmail.com>
Subject: Re: [PATCH] gma500: gtt based hardware scrolling console
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: greg@kroah.com, linux-kernel@vger.kernel.org,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

On Thu, Sep 22, 2011 at 20:43, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
diff --git a/drivers/staging/gma500/framebuffer.c
b/drivers/staging/gma500/framebuffer.c
index 7748331..3f39a37 100644
--- a/drivers/staging/gma500/framebuffer.c
+++ b/drivers/staging/gma500/framebuffer.c

> @@ -416,6 +473,8 @@ static int psbfb_create(struct psb_fbdev *fbdev,
>
>        info->fix.smem_start = dev->mode_config.fb_base;
>        info->fix.smem_len = size;
> +       info->fix.ywrapstep = gtt_roll;

Do you really want to set this? I didn't see any other wrapping
support in your patch.
However, I guess you can implement wrapping support using the same
mapping trick?

> +       info->fix.ypanstep = gtt_roll;
>
>        if (backing->stolen) {
>                /* Accessed stolen memory directly */

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
