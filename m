Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752296Ab1CZPBj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 11:01:39 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:46670 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077Ab1CZPBi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 11:01:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=A08qInY8wAUBSoDQ791B2fYL4cybzr7CMETAiH0iAycFUGpci9LywgC7TwtUA1PhAv
         S10kOviEdooUrp5Xoi1CHWsbIfW6kJgT11HiclsQCziZ1l0imuaiGsJ6N4k3qUTWEdAz
         TpYZ1+iLVNVfONmJFgpJL7D/vFhlUFVGCbkR4=
MIME-Version: 1.0
In-Reply-To: <1300448853-15651-1-git-send-email-ospite@studenti.unina.it>
References: <1300448853-15651-1-git-send-email-ospite@studenti.unina.it>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Sat, 26 Mar 2011 23:01:17 +0800
Message-ID: <AANLkTinG7R6L8JDQPYd7sJ0Z9YBnRrT1MG_fEV061pHh@mail.gmail.com>
Subject: Re: [PATCH] sound/soc/pxa/zylonite.c: set .codec_dai_name in initializer
To: Antonio Ospite <ospite@studenti.unina.it>
Cc: alsa-devel@alsa-project.org, Takashi Iwai <tiwai@suse.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, Jaroslav Kysela <perex@perex.cz>,
        Jarkko Nikula <jhnikula@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Timur Tabi <timur@freescale.com>, linux-arm-kernel@lists.infradead.org,
        Liam Girdwood <lrg@slimlogic.co.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 18, 2011 at 7:47 PM, Antonio Ospite
<ospite@studenti.unina.it> wrote:
> Fix the initialization of .codec_dai_name in zylonite_dai initializer,
> do not mix it with the initialization of .codec_name which is set
> already a few lines above.
>
> Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>

Acked-by: Eric Miao <eric.y.miao@gmail.com>

> ---
>
> Hi,
>
> I didn't test that because I don't have the hardware, I just noticed it by
> reading the code from 2.6.38 and thought this may be the right fix.
>
> Is there any mechanism to spot out when the same field in a struct initializer
> is set more than once?
>
> Regards,
>   Antonio Ospite
>   http://ao2.it
>
>  sound/soc/pxa/zylonite.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/sound/soc/pxa/zylonite.c b/sound/soc/pxa/zylonite.c
> index 25bba10..5e96f7e 100644
> --- a/sound/soc/pxa/zylonite.c
> +++ b/sound/soc/pxa/zylonite.c
> @@ -167,7 +167,7 @@ static struct snd_soc_dai_link zylonite_dai[] = {
>        .codec_name = "wm9713-codec",
>        .platform_name = "pxa-pcm-audio",
>        .cpu_dai_name = "pxa2xx-ac97",
> -       .codec_name = "wm9713-hifi",
> +       .codec_dai_name = "wm9713-hifi",
>        .init = zylonite_wm9713_init,
>  },
>  {
> @@ -176,7 +176,7 @@ static struct snd_soc_dai_link zylonite_dai[] = {
>        .codec_name = "wm9713-codec",
>        .platform_name = "pxa-pcm-audio",
>        .cpu_dai_name = "pxa2xx-ac97-aux",
> -       .codec_name = "wm9713-aux",
> +       .codec_dai_name = "wm9713-aux",
>  },
>  {
>        .name = "WM9713 Voice",
> @@ -184,7 +184,7 @@ static struct snd_soc_dai_link zylonite_dai[] = {
>        .codec_name = "wm9713-codec",
>        .platform_name = "pxa-pcm-audio",
>        .cpu_dai_name = "pxa-ssp-dai.2",
> -       .codec_name = "wm9713-voice",
> +       .codec_dai_name = "wm9713-voice",
>        .ops = &zylonite_voice_ops,
>  },
>  };
> --
> 1.7.4.1
>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>
