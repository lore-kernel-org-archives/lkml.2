Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998Ab1HCHRK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 03:17:10 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63694 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849Ab1HCHRG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 03:17:06 -0400
MIME-Version: 1.0
In-Reply-To: <20110802075735.GA3466@osiris.boeblingen.de.ibm.com>
References: <20110802075735.GA3466@osiris.boeblingen.de.ibm.com>
Date: Wed, 3 Aug 2011 09:17:04 +0200
X-Google-Sender-Auth: LIpUecOKEuYAoSvl6nOlGbs9aMA
Message-ID: <CAMuHMdXp+B7SJCy5yOQwdxWK7dkbiFVUp_QAtSyxMV8DYUHwfg@mail.gmail.com>
Subject: Re: [PATCH] nfs: add missing prefetch.h include
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>,
        Fred Isaman <iisaman@citi.umich.edu>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 2, 2011 at 09:57, Heiko Carstens <heiko.carstens@de.ibm.com> wrote:
> From: Heiko Carstens <heiko.carstens@de.ibm.com>
>
> Fix this compile error on s390:
>
>  CC [M]  fs/nfs/blocklayout/blocklayout.o
> fs/nfs/blocklayout/blocklayout.c: In function 'bl_end_io_read':
> fs/nfs/blocklayout/blocklayout.c:201:4: error: implicit declaration of function 'prefetchw'
>
> Introduced with 9549ec01 "pnfsblock: bl_read_pagelist".
>
> Cc: Fred Isaman <iisaman@citi.umich.edu>
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>

M68k also needs this, so
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

> ---
>  fs/nfs/blocklayout/blocklayout.c |    1 +
>  1 file changed, 1 insertion(+)
>
> --- a/fs/nfs/blocklayout/blocklayout.c
> +++ b/fs/nfs/blocklayout/blocklayout.c
> @@ -36,6 +36,7 @@
>  #include <linux/namei.h>
>  #include <linux/bio.h>         /* struct bio */
>  #include <linux/buffer_head.h> /* various write calls */
> +#include <linux/prefetch.h>
>
>  #include "blocklayout.h"

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
