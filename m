Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932122Ab1FPOgR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 10:36:17 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:54907 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932068Ab1FPOgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 10:36:14 -0400
Message-ID: <4DFA1474.7030206@ru.mvista.com>
Date: Thu, 16 Jun 2011 18:34:28 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Manuel Zerpies <manuel.f.zerpies@ww.stud.uni-erlangen.de>
CC: Greg Kroah-Hartman <gregkh@suse.de>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        christian.dietrich@informatik.uni-erlangen.de
Subject: Re: [PATCH 10/11] wusb: use printk_ratelimited() instead of printk_ratelimit()
References: <cover.1308142053.git.manuel.f.zerpies@ww.stud.uni-erlangen.de> <f69548c31f74b77bdc893772ef4012461dff119d.1308142053.git.manuel.f.zerpies@ww.stud.uni-erlangen.de>
In-Reply-To: <f69548c31f74b77bdc893772ef4012461dff119d.1308142053.git.manuel.f.zerpies@ww.stud.uni-erlangen.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Manuel Zerpies wrote:

> Since printk_ratelimit() shouldn't be used anymore (see comment in
> include/linux/printk.h), replace it with printk_ratelimited()

> Signed-off-by: Manuel Zerpies <manuel.f.zerpies@ww.stud.uni-erlangen.de>
> ---
>  drivers/usb/wusbcore/wa-xfer.c |    7 +++----
>  1 files changed, 3 insertions(+), 4 deletions(-)

> diff --git a/drivers/usb/wusbcore/wa-xfer.c b/drivers/usb/wusbcore/wa-xfer.c
> index 6ccd93a..4193345 100644
> --- a/drivers/usb/wusbcore/wa-xfer.c
> +++ b/drivers/usb/wusbcore/wa-xfer.c
> @@ -83,6 +83,7 @@
>  #include <linux/spinlock.h>
>  #include <linux/slab.h>
>  #include <linux/hash.h>
> +#include <linux/ratelimit.h>
>  
>  #include "wa-hc.h"
>  #include "wusbhc.h"
> @@ -1217,16 +1218,14 @@ static int wa_xfer_status_to_errno(u8 status)
>  	if (status == 0)
>  		return 0;
>  	if (status >= ARRAY_SIZE(xlat)) {
> -		if (printk_ratelimit())
> -			printk(KERN_ERR "%s(): BUG? "
> +		printk_ratelimited(KERN_ERR "%s(): BUG? "
>  			       "Unknown WA transfer status 0x%02x\n",
>  			       __func__, real_status);
>  		return -EINVAL;
>  	}
>  	errno = xlat[status];
>  	if (unlikely(errno > 0)) {
> -		if (printk_ratelimit())
> -			printk(KERN_ERR "%s(): BUG? "
> +		printk_ratelimited(KERN_ERR "%s(): BUG? "
>  			       "Inconsistent WA status: 0x%02x\n",
>  			       __func__, real_status);
>  		errno = -errno;

    Why not pr_err_ratelimited()?

WBR, Sergei
