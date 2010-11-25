Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527Ab0KYKsL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 05:48:11 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62187 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941Ab0KYKsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 05:48:09 -0500
Subject: Re: [PATCH] ASoC: neo1973_gta02_wm8753: fix wrong parameter for
 snd_soc_register_dai and snd_soc_unregister_dai
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Graeme Gregory <graeme@openmoko.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
In-Reply-To: <1290675056.1928.1.camel@mola>
References: <1290675056.1928.1.camel@mola>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 25 Nov 2010 10:48:05 +0000
Message-ID: <1290682085.3302.15.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-25 at 16:50 +0800, Axel Lin wrote:
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  sound/soc/samsung/neo1973_gta02_wm8753.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/sound/soc/samsung/neo1973_gta02_wm8753.c b/sound/soc/samsung/neo1973_gta02_wm8753.c
> index 920e8d1..8c65b63 100644
> --- a/sound/soc/samsung/neo1973_gta02_wm8753.c
> +++ b/sound/soc/samsung/neo1973_gta02_wm8753.c
> @@ -438,7 +438,7 @@ static int __init neo1973_gta02_init(void)
>  		return -ENOMEM;
>  
>  	/* register bluetooth DAI here */
> -	ret = snd_soc_register_dai(&neo1973_gta02_snd_device->dev, -1, &bt_dai);
> +	ret = snd_soc_register_dai(&neo1973_gta02_snd_device->dev, &bt_dai);
>  	if (ret) {
>  		platform_device_put(neo1973_gta02_snd_device);
>  		return ret;
> @@ -491,7 +491,7 @@ module_init(neo1973_gta02_init);
>  
>  static void __exit neo1973_gta02_exit(void)
>  {
> -	snd_soc_unregister_dai(&neo1973_gta02_snd_device->dev, -1);
> +	snd_soc_unregister_dai(&neo1973_gta02_snd_device->dev);
>  	platform_device_unregister(neo1973_gta02_snd_device);
>  	gpio_free(GTA02_GPIO_HP_IN);
>  	gpio_free(GTA02_GPIO_AMP_SHUT);

Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

