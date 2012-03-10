Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756165Ab2CJBTn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 20:19:43 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:59045 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750957Ab2CJBTm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 20:19:42 -0500
MIME-Version: 1.0
In-Reply-To: <1331338687.18199.1.camel@phoenix>
References: <1331338687.18199.1.camel@phoenix>
Date: Fri, 9 Mar 2012 20:19:29 -0500
X-Google-Sender-Auth: AVjgcCRGiZaK8b_xy77EPkFzE8E
Message-ID: <CAP=VYLoe9M2ygBCrPu4pS_1M-Nxt7vqXRSaxAEfx+2wdU7atqA@mail.gmail.com>
Subject: Re: [PATCH] regmap: Include linux/device.h to fix build error
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, but this was caught earlier and already fixed.

http://marc.info/?l=linux-next&m=133130596327850&w=2

Paul.

---

On Fri, Mar 9, 2012 at 7:18 PM, Axel Lin <axel.lin@gmail.com> wrote:
> Fix below build error:
>
>  CC      drivers/base/regmap/regmap.o
> drivers/base/regmap/regmap.c: In function 'devm_regmap_init':
> drivers/base/regmap/regmap.c:331: error: implicit declaration of function 'devres_alloc'
> drivers/base/regmap/regmap.c:331: warning: assignment makes pointer from integer without a cast
> drivers/base/regmap/regmap.c:338: error: implicit declaration of function 'devres_add'
> drivers/base/regmap/regmap.c:340: error: implicit declaration of function 'devres_free'
> drivers/base/regmap/regmap.c: In function '_regmap_raw_write':
> drivers/base/regmap/regmap.c:421: error: implicit declaration of function 'dev_err'
> make[3]: *** [drivers/base/regmap/regmap.o] Error 1
> make[2]: *** [drivers/base/regmap] Error 2
> make[1]: *** [drivers/base] Error 2
> make: *** [drivers] Error 2
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
> This patch is against linux-next 20120309.
>
>  drivers/base/regmap/regmap.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
> index e1a4097..3b09587 100644
> --- a/drivers/base/regmap/regmap.c
> +++ b/drivers/base/regmap/regmap.c
> @@ -11,6 +11,7 @@
>  */
>
>  #include <linux/slab.h>
> +#include <linux/device.h>
>  #include <linux/export.h>
>  #include <linux/mutex.h>
>  #include <linux/err.h>
> --
> 1.7.5.4
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
