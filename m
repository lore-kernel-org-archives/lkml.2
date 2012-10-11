Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752242Ab2JKMKV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 08:10:21 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:63531 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924Ab2JKMKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 08:10:19 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] pinctrl/nomadik: support other alternate-C functions
Date: Thu, 11 Oct 2012 12:10:11 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        Anmar Oueja <anmar.oueja@linaro.org>,
        "Jean-Nicolas Graux" <jean-nicolas.graux@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@nvidia.com>
References: <1349185041-1810-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1349185041-1810-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201210111210.12122.arnd@arndb.de>
X-Provags-ID: V02:K0:OYSIJQ1H4w5nell7Enr07BcSGY/hf6zocSwFM1Nhhzf
 rWq0zWed0lT3b7Jzba5r25OpMvjpw+bRkiT5mia8t8VJgl0fc0
 +8dzU1fF0zaxV4Ek1K+bDjN6Sx+OQwHCoIo4NSd6owFW90le/q
 JCdGlWtcSFQrZ9mL8KI/4ENswkzRwwuXMbGZC7cLSL8TFg+4US
 jkd6J5JoNZJswBZP5EFqCr9lUJFYHDuEpWSzY2ZBHnmylnkkRk
 s4ALSA4wwc1fb6BHA0XVyKwdeb//Fo2LUd380xsbg1kRcduawM
 aALQxMRUeDsk9fpcvcZd6KVXRDFMVMEKg+isVNulhDZanR1eQc
 TJ0bGvx1cSqQXFFcFP9A=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 02 October 2012, Linus Walleij wrote:
> --- a/drivers/pinctrl/pinctrl-nomadik.c
> +++ b/drivers/pinctrl/pinctrl-nomadik.c
> @@ -30,6 +30,7 @@
>  #include <linux/pinctrl/pinconf.h>
>  /* Since we request GPIOs from ourself */
>  #include <linux/pinctrl/consumer.h>
> +#include <linux/mfd/dbx500-prcmu.h>
>  
>  #include <asm/mach/irq.h>
>  

This patch just showed up in linux-next and caused this error
when building nhk8815_defconfig:

In file included from /home/arnd/linux-arm/drivers/pinctrl/pinctrl-nomadik.c:33:0:
/home/arnd/linux-arm/include/linux/mfd/dbx500-prcmu.h:459:90: error: redefinition of 'prcmu_abb_read'
/home/arnd/linux-arm/include/linux/mfd/db8500-prcmu.h:673:90: note: previous definition of 'prcmu_abb_read' was here
/home/arnd/linux-arm/include/linux/mfd/dbx500-prcmu.h:464:90: error: redefinition of 'prcmu_abb_write'
/home/arnd/linux-arm/include/linux/mfd/db8500-prcmu.h:678:90: note: previous definition of 'prcmu_abb_write' was here
/home/arnd/linux-arm/include/linux/mfd/dbx500-prcmu.h:475:90: error: redefinition of 'prcmu_config_clkout'
/home/arnd/linux-arm/include/linux/mfd/db8500-prcmu.h:643:90: note: previous definition of 'prcmu_config_clkout' was here
/home/arnd/linux-arm/include/linux/mfd/dbx500-prcmu.h:537:90: error: redefinition of 'prcmu_ac_wake_req'
/home/arnd/linux-arm/include/linux/mfd/db8500-prcmu.h:683:90: note: previous definition of 'prcmu_ac_wake_req' was here
/home/arnd/linux-arm/include/linux/mfd/dbx500-prcmu.h:542:91: error: redefinition of 'prcmu_ac_sleep_req'
/home/arnd/linux-arm/include/linux/mfd/db8500-prcmu.h:688:91: note: previous definition of 'prcmu_ac_sleep_req' was here
make[2]: *** [drivers/pinctrl/pinctrl-nomadik.o] Error 1
make[1]: *** [drivers/pinctrl/] Error 2
make: *** [sub-make] Error 2


	Arnd
