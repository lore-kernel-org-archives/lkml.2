Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932928Ab2IFSGQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 14:06:16 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:56099 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932196Ab2IFSGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 14:06:13 -0400
MIME-Version: 1.0
In-Reply-To: <20120905154801.b21cf25d96767b69489aec29@canb.auug.org.au>
References: <20120905154801.b21cf25d96767b69489aec29@canb.auug.org.au>
Date: Thu, 6 Sep 2012 20:06:11 +0200
X-Google-Sender-Auth: JgmB0vAlfrpr-Yc46RopSxhdfok
Message-ID: <CAMuHMdWN--hXYTPYNi07vNB0DrMdDoc+MwxgUkSBihPw+VKGHg@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the final tree (staging
 tree related)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        =?UTF-8?Q?=22Samuel_Iglesias_Gons=C3=A1lvez=22?= 
	<siglesias@igalia.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 5, 2012 at 7:48 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> After merging the final tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
>
> drivers/staging/ipack/ipack.c: In function 'ipack_device_read_id':
> drivers/staging/ipack/ipack.c:291:2: error: implicit declaration of function 'ioread8' [-Werror=implicit-function-declaration]
> drivers/staging/ipack/ipack.c:309:3: error: implicit declaration of function 'ioread16be' [-Werror=implicit-function-declaration]
>
> Caused by commit 187e47824013 ("Staging: ipack: Read the ID space during
> device registration").
>
> I have added the following patch for today:
>
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Wed, 5 Sep 2012 15:44:11 +1000
> Subject: [PATCH] Staging: ipack: disable due to build error
>
> The powerpc allyesconfig build gives this:
>
> drivers/staging/ipack/ipack.c: In function 'ipack_device_read_id':
> drivers/staging/ipack/ipack.c:291:2: error: implicit declaration of function 'ioread8' [-Werror=implicit-function-declaration]
> drivers/staging/ipack/ipack.c:309:3: error: implicit declaration of function 'ioread16be' [-Werror=implicit-function-declaration]

The ipack driver also fails on s390/allmodconfig:

drivers/staging/ipack/devices/ipoctal.c:59:2: error: implicit
declaration of function 'iowrite8'
[-Werror=implicit-function-declaration]
drivers/staging/ipack/devices/ipoctal.c:72:2: error: implicit
declaration of function 'ioread8'
[-Werror=implicit-function-declaration]

http://kisskb.ellerman.id.au/kisskb/buildresult/7143741/

Guess it has to depend on HAS_IOMEM, too.

> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  drivers/staging/ipack/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/staging/ipack/Kconfig b/drivers/staging/ipack/Kconfig
> index af32178..5c428d7 100644
> --- a/drivers/staging/ipack/Kconfig
> +++ b/drivers/staging/ipack/Kconfig
> @@ -4,6 +4,7 @@
>
>  menuconfig IPACK_BUS
>         tristate "IndustryPack bus support"
> +       depends on BROKEN

Cool, can I do that for all build failures? ;-)

>         ---help---
>           If you say Y here you get support for the IndustryPack Framework
>           for drivers for many types of boards that support this industrial

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
