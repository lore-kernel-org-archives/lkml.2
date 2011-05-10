Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480Ab1EJJmG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 05:42:06 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51781 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377Ab1EJJmD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 05:42:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=OXj2kcPI0c3nBLGHbWCkX5FtVUGjdx+ArUMN3RBtRourfnj5sWDYvVbPigPU+pqbiX
         H7lKqJVzh2QMYwKa12h+LKz3PxxGGybtHo61X06Qg6SglmNv2a9sEXXk7PLe8NJKlGx3
         XHB1KCbFLabw7X8qdJFPMXYda9qcoFtK+triY=
MIME-Version: 1.0
In-Reply-To: <1305019249-9898-1-git-send-email-ndevos@redhat.com>
References: <1305019249-9898-1-git-send-email-ndevos@redhat.com>
Date: Tue, 10 May 2011 11:42:01 +0200
X-Google-Sender-Auth: -CHxpmp_ywY-AhH3HST5KG8a1BQ
Message-ID: <BANLkTinEJZ=fvJmWRkQ7kKyxbFRaJnum7g@mail.gmail.com>
Subject: Re: [PATCH] omap2/omapfb: make DBG() more resistant in if-else constructions
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Niels de Vos <ndevos@redhat.com>
Cc: linux-omap@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 10, 2011 at 11:20, Niels de Vos <ndevos@redhat.com> wrote:
> When DBG() is used in a simple if-else, the resulting code path
> currently depends on the definition of DBG(). Inserting the statement in
> a "do { ... } while (0)" prevents this possible misuse.
>
> Signed-off-by: Niels de Vos <ndevos@redhat.com>

> --- a/drivers/video/omap2/omapfb/omapfb.h
> +++ b/drivers/video/omap2/omapfb/omapfb.h
> @@ -34,8 +34,10 @@
>  #ifdef DEBUG
>  extern unsigned int omapfb_debug;
>  #define DBG(format, ...) \
> -       if (omapfb_debug) \
> -               printk(KERN_DEBUG "OMAPFB: " format, ## __VA_ARGS__)
> +       do { \
> +               if (omapfb_debug) \
> +                       printk(KERN_DEBUG "OMAPFB: " format, ## __VA_ARGS__); \
> +       while (0)

Where's the closing '}'?

>  #else
>  #define DBG(format, ...)

BTW, no printf()-style format checking here.

>  #endif

What about using the standard pr_debug()/dev_dbg() instead?
With dynamic debug, it can be enabled at run time.
As a bonus, you get printf()-style format checking if debugging is disabled.


Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
