Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757052Ab2I2RUn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2012 13:20:43 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:57957 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509Ab2I2RUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2012 13:20:42 -0400
MIME-Version: 1.0
In-Reply-To: <1348652941-31899-3-git-send-email-maximlevitsky@gmail.com>
References: <1348652941-31899-1-git-send-email-maximlevitsky@gmail.com>
	<1348652941-31899-3-git-send-email-maximlevitsky@gmail.com>
Date: Sat, 29 Sep 2012 19:20:41 +0200
X-Google-Sender-Auth: xcHexNE64DzMLvGkRlF4o6nX5Uo
Message-ID: <CAMuHMdW7zfM1CxkXTCq2=ErkaAAxGVFyQSZdH3jwvUXr_8oOsg@mail.gmail.com>
Subject: Re: [PATCH 2/2] memstick: add support for legacy memorysticks
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alex Dubov <oakad@yahoo.com>,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Linux-Next <linux-next@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 26, 2012 at 11:49 AM, Maxim Levitsky
<maximlevitsky@gmail.com> wrote:
> --- /dev/null
> +++ b/drivers/memstick/core/ms_block.c

> +#define pr_fmt(fmt) DRIVER_NAME ": " fmt
> +
> +#include <linux/module.h>
> +#include <linux/blkdev.h>
> +#include <linux/memstick.h>
> +#include <linux/idr.h>
> +#include <linux/hdreg.h>
> +#include <linux/delay.h>
> +#include <linux/slab.h>
> +#include <linux/random.h>
> +#include <linux/bitmap.h>
> +#include <linux/scatterlist.h>
> +#include <linux/jiffies.h>
> +#include <linux/workqueue.h>
> +#include <linux/mutex.h>
> +#include "ms_block.h"

http://kisskb.ellerman.id.au/kisskb/buildresult/7280352/
arch/m68k/include/asm/hardirq.h:23:20: error: expected ')' before 'DRIVER_NAME'
make[4]: *** [drivers/memstick/core/ms_block.o] Error 1

The reason for this is that pr_fmt() references DRIVER_NAME and is defined
before the first include, while DRIVER_NAME is only defined in ms_block.h,
which is the last included file. If any subsequent include file uses pr_fmt()
(e.g. the call to pr_crit() in arch/m68k/include/asm/hardirq.h), this
causes a build
failure.

I suggest moving the DRIVER_NAME define to ms_block.c.
Cfr. memstick.c and mspro_block.c, who already have their own definition.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
