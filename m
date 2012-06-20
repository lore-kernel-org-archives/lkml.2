Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758010Ab2FTTyl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 15:54:41 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:56967 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757970Ab2FTTyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 15:54:40 -0400
Message-ID: <4FE22A69.3090309@xenotime.net>
Date: Wed, 20 Jun 2012 12:54:17 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: linux-kernel@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH] mfd: MFD_MAX77693 needs to select IRQ_DOMAIN
References: <1340156457.13830.1.camel@phoenix>
In-Reply-To: <1340156457.13830.1.camel@phoenix>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2012 06:40 PM, Axel Lin wrote:

> This fixes below build errors:
> 
>   CC      drivers/mfd/max77693-irq.o
> drivers/mfd/max77693-irq.c: In function 'max77693_irq_thread':
> drivers/mfd/max77693-irq.c:217:4: error: implicit declaration of function 'irq_find_mapping' [-Werror=implicit-function-declaration]
> drivers/mfd/max77693-irq.c: In function 'max77693_irq_init':
> drivers/mfd/max77693-irq.c:286:2: error: implicit declaration of function 'irq_domain_add_linear' [-Werror=implicit-function-declaration]
> drivers/mfd/max77693-irq.c:286:9: warning: assignment makes pointer from integer without a cast [enabled by default]
> cc1: some warnings being treated as errors
> make[2]: *** [drivers/mfd/max77693-irq.o] Error 1
> make[1]: *** [drivers/mfd] Error 2
> make: *** [drivers] Error 2
> 
> Reported-by: Randy Dunlap <rdunlap@xenotime.net>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>


Acked-by: Randy Dunlap <rdunlap@xenotime.net>

Thanks.


> ---
>  drivers/mfd/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index e129c82..79f1d4b 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -427,6 +427,7 @@ config MFD_MAX77693
>  	depends on I2C=y && GENERIC_HARDIRQS
>  	select MFD_CORE
>  	select REGMAP_I2C
> +	select IRQ_DOMAIN
>  	help
>  	  Say yes here to support for Maxim Semiconductor MAX77693.
>  	  This is a companion Power Management IC with Flash, Haptic, Charger,



-- 
~Randy
