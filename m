Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030735Ab2HHTUF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 15:20:05 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:49323 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932896Ab2HHTUC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 15:20:02 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 11/11] pm/drivers: fix use of SIMPLE_DEV_PM_OPS
Date: Wed, 8 Aug 2012 21:25:55 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0+; KDE/4.6.0; x86_64; ; )
Cc: Takashi Iwai <tiwai@suse.de>, Stephen Warren <swarren@wwwdotorg.org>,
        linux-arm-kernel@lists.infradead.org, arm@kernel.org,
        linux-kernel@vger.kernel.org, Laxman Dewangan <ldewangan@nvidia.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>
References: <1344437248-20560-1-git-send-email-arnd@arndb.de> <s5hwr19fi6h.wl%tiwai@suse.de> <201208081726.21878.arnd@arndb.de>
In-Reply-To: <201208081726.21878.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208082125.56184.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, August 08, 2012, Arnd Bergmann wrote:
> On Wednesday 08 August 2012, Takashi Iwai wrote:
> > At Wed, 8 Aug 2012 16:22:29 +0000,
> > Arnd Bergmann wrote:
> > > > Laxman already posted a patch for this, which I'm hoping will make it
> > > > into 3.6, through the I2C tree.
> > > > 
> > > > http://www.spinics.net/lists/linux-i2c/msg09359.html
> > > 
> > > Ok, dropping this one then.
> > 
> > I'm going to fix the similar errors in sound tree tomorrow, too.
> > 
> 
> Ok. this leaves the omap-rng driver, and my patch comes down to the below.
> Thanks!

Looks good!

Sorry for introducing those warnings in the first place, I should have been
more careful about that.

Thanks,
Rafael


> 8<----
> 
> From d83e9e0e5c0e41a0ee2ba6293c8be21e54988f99 Mon Sep 17 00:00:00 2001
> From: Arnd Bergmann <arnd@arndb.de>
> Date: Sat, 4 Aug 2012 07:11:34 +0000
> Subject: [PATCH] omap-rng: fix use of SIMPLE_DEV_PM_OPS
> 
> omap_rng_suspend and omap_rng_resume are unused if CONFIG_PM is enabled
> but CONFIG_PM_SLEEP is disabled. I found this while building all defconfig
> files on ARM. It's not clear to me if this is the right solution, but
> at least it makes the code consistent again.
> 
> Without this patch, building omap1_defconfig results in:
> 
> drivers/char/hw_random/omap-rng.c:165:12: warning: 'omap_rng_suspend' defined but not used [-Wunused-function]
> drivers/char/hw_random/omap-rng.c:171:12: warning: 'omap_rng_resume' defined but not used [-Wunused-function]
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Rafael J. Wysocki <rjw@sisk.pl>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> 
> diff --git a/drivers/char/hw_random/omap-rng.c b/drivers/char/hw_random/omap-rng.c
> index d706bd0e..4fbdceb 100644
> --- a/drivers/char/hw_random/omap-rng.c
> +++ b/drivers/char/hw_random/omap-rng.c
> @@ -160,7 +160,7 @@ static int __exit omap_rng_remove(struct platform_device *pdev)
>  	return 0;
>  }
>  
> -#ifdef CONFIG_PM
> +#ifdef CONFIG_PM_SLEEP
>  
>  static int omap_rng_suspend(struct device *dev)
>  {
> 
> 
> 

