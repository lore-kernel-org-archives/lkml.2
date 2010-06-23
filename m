Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932Ab0FWGrr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 02:47:47 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44798 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328Ab0FWGrp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 02:47:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=udpmu3Tbuxi8yrcxIPYyxs5BZfwWueUIfr6yKXBv/Ri2Q6vG+lHgcA+11PzwvIrkUh
         ydET/c2/+ByCQI3EfwIBF/pLgNSqQH0/8Q+Gr+trhxecVoCdokeZBEn8lRd5Q+uxjFbq
         kIJiGOqWtmPmiZ8Dj2Vtrm2M9NHp7cO9tcvG4=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1006071312060.12965@axis700.grange>
References: <Pine.LNX.4.64.1006071312060.12965@axis700.grange>
Date: Wed, 23 Jun 2010 08:47:43 +0200
Message-ID: <AANLkTikndTP49meKLd1bh7De04wUHrFovpgwbIrpYGF9@mail.gmail.com>
Subject: Re: [PATCH] initialise DMA engine before MMC
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org,
       "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
       Dan Williams <dan.j.williams@intel.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-mmc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/6/7 Guennadi Liakhovetski <g.liakhovetski@gmx.de>:

> To use DMA engine based DMA with MMC in a non-modular build, the DMA
> engine has to initialise before MMC.
>
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
> diff --git a/drivers/Makefile b/drivers/Makefile
> index 91874e0..b713e75 100644
> --- a/drivers/Makefile
> +++ b/drivers/Makefile
> @@ -92,6 +92,7 @@ obj-$(CONFIG_EISA)            += eisa/
>  obj-y                          += lguest/
>  obj-$(CONFIG_CPU_FREQ)         += cpufreq/
>  obj-$(CONFIG_CPU_IDLE)         += cpuidle/
> +obj-$(CONFIG_DMA_ENGINE)       += dma/
>  obj-$(CONFIG_MMC)              += mmc/
>  obj-$(CONFIG_MEMSTICK)         += memstick/
>  obj-$(CONFIG_NEW_LEDS)         += leds/
> @@ -102,7 +103,6 @@ obj-$(CONFIG_CRYPTO)                += crypto/
>  obj-$(CONFIG_SUPERH)           += sh/
>  obj-$(CONFIG_ARCH_SHMOBILE)    += sh/
>  obj-$(CONFIG_GENERIC_TIME)     += clocksource/
> -obj-$(CONFIG_DMA_ENGINE)       += dma/
>  obj-$(CONFIG_DCA)              += dca/
>  obj-$(CONFIG_HID)              += hid/
>  obj-$(CONFIG_PPC_PS3)          += ps3/

What I did was to move my DMA engines to subsystem_initcall(), with this
approach I would have had to rearrange a lot of subsystems I think.

But if it's easier for you this way by all means do it.

Yours,
Linus Walleij
