Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757010Ab2HULXs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 07:23:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43922 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756938Ab2HULXq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 07:23:46 -0400
Message-ID: <50336FA5.7020906@redhat.com>
Date: Tue, 21 Aug 2012 08:23:17 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: linux-kernel@vger.kernel.org, Michael Buesch <m@bues.ch>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] gpio: bt8xx: Fix build error due to missing include file
References: <1345541833.17239.0.camel@phoenix>
In-Reply-To: <1345541833.17239.0.camel@phoenix>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

Em 21-08-2012 06:37, Axel Lin escreveu:
> This patch fixes below build error:
> 
>   CC [M]  drivers/gpio/gpio-bt8xx.o
> drivers/gpio/gpio-bt8xx.c:53:40: fatal error: ../media/video/bt8xx/bt848.h: No such file or directory
> compilation terminated.
> make[2]: *** [drivers/gpio/gpio-bt8xx.o] Error 1
> make[1]: *** [drivers/gpio] Error 2
> make: *** [drivers] Error 2
> 
> drivers/media/video/bt8xx/bt848.h is moved to drivers/media/pci/bt8xx/bt848.h
> by commit 68de959f773a1d49096835c411390bceff5d1549
> "[media] bt8xx: move analog TV part to be together with DTV one".
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>

Thanks for the patch!

I'll apply this one on my tree, as it is due to the drivers/media tree
reorg. So, it is better to keep it close to the patches there.

Regards,
Mauro

> ---
>  drivers/gpio/gpio-bt8xx.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/gpio/gpio-bt8xx.c b/drivers/gpio/gpio-bt8xx.c
> index e4cc7eb..92d555d 100644
> --- a/drivers/gpio/gpio-bt8xx.c
> +++ b/drivers/gpio/gpio-bt8xx.c
> @@ -50,7 +50,7 @@
>  #include <linux/slab.h>
>  
>  /* Steal the hardware definitions from the bttv driver. */
> -#include "../media/video/bt8xx/bt848.h"
> +#include "../media/pci/bt8xx/bt848.h"
>  
>  
>  #define BT8XXGPIO_NR_GPIOS		24 /* We have 24 GPIO pins */
> 

