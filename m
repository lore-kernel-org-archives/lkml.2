Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752878Ab1I0WD5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 18:03:57 -0400
Received: from mail.windriver.com ([147.11.1.11]:52393 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502Ab1I0WD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 18:03:56 -0400
Message-ID: <4E824821.8040105@windriver.com>
Date: Tue, 27 Sep 2011 18:03:13 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.21) Gecko/20110831 Thunderbird/3.1.13
MIME-Version: 1.0
To: =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>
CC: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>,
        <linux-kernel@vger.kernel.org>, <kernel@pengutronix.de>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] dma/imx-sdma+imx-dma: explicitly #include <linux/module.h>
References: <1317018379-8897-1-git-send-email-u.kleine-koenig@pengutronix.de>
In-Reply-To: <1317018379-8897-1-git-send-email-u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-09-26 02:26 AM, Uwe Kleine-König wrote:
> This is needed after commit
> 
> 	include: replace linux/module.h with "struct module" wherever possible
> 
> (currently 25215aa in next).
> 
> Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---
> Hello,
> 
> maybe it's sensible for Paul to take that before his commit?

Thanks, I'll blend it into the commit adding module.h to the other
drivers/dma files.  It seems the imx boards don't have a defconfig
in the arch/arm/configs that enables this (CONFIG_IMX_[S]DMA).

What is really interesting (at least to me anyway) is that I
didn't get one iMX build in some 6000+ ARM randconfig builds....

I would have thought it would have showed up at least a couple
times, given that number of builds.  Maybe randconfig doesn't
deal so well with "choice" Kconfig items?

~/git/module.h/linux-2.6.git$ ls -1 ../build-10*arm |wc -l
6399
~/git/module.h/linux-2.6.git$ grep CONFIG_ARCH_[A-Z0-9]*=y ../build-10*arm*/.config | sed 's/.*CON/CON/'|sort |uniq
CONFIG_ARCH_EBSA110=y
CONFIG_ARCH_H7201=y
CONFIG_ARCH_H7202=y
CONFIG_ARCH_H720X=y
CONFIG_ARCH_VERSATILE=y
~/git/module.h/linux-2.6.git$ 

No ARCH_MXC, no ARCH_MXS, PXA, or any of the other 20+ variants.
Definitely not a random spread there, with all 6000 builds falling
in just 5 buckets.

Paul.


> 
> Best regards
> Uwe
> 
>  drivers/dma/imx-dma.c  |    1 +
>  drivers/dma/imx-sdma.c |    1 +
>  2 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/dma/imx-dma.c b/drivers/dma/imx-dma.c
> index d99f71c..3732de8 100644
> --- a/drivers/dma/imx-dma.c
> +++ b/drivers/dma/imx-dma.c
> @@ -23,6 +23,7 @@
>  #include <linux/slab.h>
>  #include <linux/platform_device.h>
>  #include <linux/dmaengine.h>
> +#include <linux/module.h>
>  
>  #include <asm/irq.h>
>  #include <mach/dma-v1.h>
> diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
> index b5cc27d..86fb6e5 100644
> --- a/drivers/dma/imx-sdma.c
> +++ b/drivers/dma/imx-sdma.c
> @@ -34,6 +34,7 @@
>  #include <linux/dmaengine.h>
>  #include <linux/of.h>
>  #include <linux/of_device.h>
> +#include <linux/module.h>
>  
>  #include <asm/irq.h>
>  #include <mach/sdma.h>
