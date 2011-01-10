Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408Ab1AJTsv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 14:48:51 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48460 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463Ab1AJTsu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 14:48:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:cc:content-type:content-transfer-encoding;
        b=m0fRCXBRbLtgYX1mp7tEmFONFKvGu6zpqMSLJwraQET6UkAFCXMmyd2wrz7QuG+MHI
         RzRW8tofEHQSqbHKWc7noRHwPt6Ud9u8uHaxHBO1Gd45ZkhfVqruRqnzVbuE6wCTO64f
         af2qRqcRDZvwLFdWwwCn4c6lNQ3eLFXct2qow=
MIME-Version: 1.0
Date: Mon, 10 Jan 2011 20:48:49 +0100
X-Google-Sender-Auth: XtRcT7-_9DaYmVlKvCwfPWoJ6ug
Message-ID: <AANLkTinsNvDffX-dMJSHfUnRAaCeCH7ioM69wwjm3nHR@mail.gmail.com>
Subject: error: implicit declaration of function 'msleep' (was: Re: [media]
 radio-aimslab.c: Fix gcc 4.5+ bug)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 7, 2011 at 04:02, Linux Kernel Mailing List
<linux-kernel@vger.kernel.org> wrote:
> Gitweb:     http://git.kernel.org/linus/e3c92215198cb6aa00ad38db2780faa6b72e0a3f
> Commit:     e3c92215198cb6aa00ad38db2780faa6b72e0a3f
> Parent:     a7862aa90ffd1113bc2898ae6be2e4861b1f76cc
> Author:     Mauro Carvalho Chehab <mchehab@redhat.com>
> AuthorDate: Thu Jan 6 08:16:04 2011 -0200
> Committer:  Mauro Carvalho Chehab <mchehab@redhat.com>
> CommitDate: Thu Jan 6 08:26:02 2011 -0200
>
>    [media] radio-aimslab.c: Fix gcc 4.5+ bug
>
>    gcc 4.5+ doesn't properly evaluate some inlined expressions.
>    A previous patch were proposed by Andrew Morton using noinline.
>    However, the entire inlined function is bogus, so let's just
>    remove it and be happy.
>
>    Reported-by: Andrew Morton <akpm@linux-foundation.org>
>    Cc: stable@kernel.org
>    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> ---
>  drivers/media/radio/radio-aimslab.c |   23 ++++++-----------------
>  1 files changed, 6 insertions(+), 17 deletions(-)
>
> diff --git a/drivers/media/radio/radio-aimslab.c b/drivers/media/radio/radio-aimslab.c
> index 05e832f..6cc5d13 100644
> --- a/drivers/media/radio/radio-aimslab.c
> +++ b/drivers/media/radio/radio-aimslab.c
> @@ -31,7 +31,6 @@
>  #include <linux/module.h>      /* Modules                      */
>  #include <linux/init.h>                /* Initdata                     */
>  #include <linux/ioport.h>      /* request_region               */
> -#include <linux/delay.h>       /* udelay                       */

Woops...

>  static void rt_decvol(struct rtrack *rt)
>  {
>        outb(0x58, rt->io);             /* volume down + sigstr + on    */
> -       sleep_delay(100000);
> +       msleep(100);

... still needed due to msleep(), cfr.
http://kisskb.ellerman.id.au/kisskb/buildresult/3776074/:

| drivers/media/radio/radio-aimslab.c:76: error: implicit declaration
of function 'msleep'

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
