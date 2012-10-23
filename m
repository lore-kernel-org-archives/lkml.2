Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756865Ab2JWSCo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 14:02:44 -0400
Received: from mail-1.atlantis.sk ([80.94.52.57]:53711 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756702Ab2JWSCm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 14:02:42 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH -next] sound: ice1712 build errors
Date: Tue, 23 Oct 2012 20:01:54 +0200
User-Agent: KMail/1.9.10 (enterprise35 0.20100827.1168748)
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org
References: <20121023151951.d5573eb8990a372754f29bf3@canb.auug.org.au> <5086D518.7050606@xenotime.net>
In-Reply-To: <5086D518.7050606@xenotime.net>
X-KMail-QuotePrefix: > 
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201210232001.55236.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 October 2012 19:34:16 Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@xenotime.net>
>
> Fix build errors by using correct kconfig symbol name:
>
> sound/pci/ice1712/psc724.c:417:5: error: 'struct snd_ice1712' has no member
> named 'pm_resume' sound/pci/ice1712/psc724.c:418:5: error: 'struct
> snd_ice1712' has no member named 'pm_suspend_enabled'

Thanks, I tried to test with CONFIG_PM disabled but was unable to disable it. 
Probably because of some CONFIG_PM and CONFIG_PM_SLEEP changes I missed...

> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
> Cc: Ondrej Zary <linux@rainbow-software.org>
> Cc:	Jaroslav Kysela <perex@perex.cz>
> Cc:	Takashi Iwai <tiwai@suse.de>
> Cc:	alsa-devel@alsa-project.org
> ---
>  sound/pci/ice1712/psc724.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- linux-next-20121023.orig/sound/pci/ice1712/psc724.c
> +++ linux-next-20121023/sound/pci/ice1712/psc724.c
> @@ -413,7 +413,7 @@ static int __devinit psc724_init(struct
>  	snd_wm8776_init(&spec->wm8776);
>  	spec->wm8766.ops.write = psc724_wm8766_write;
>  	spec->wm8766.card = ice->card;
> -#ifdef CONFIG_PM
> +#ifdef CONFIG_PM_SLEEP
>  	ice->pm_resume = psc724_resume;
>  	ice->pm_suspend_enabled = 1;
>  #endif


-- 
Ondrej Zary
