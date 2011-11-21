Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153Ab1KULeh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 06:34:37 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44332 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756078Ab1KULeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 06:34:36 -0500
Date: Mon, 21 Nov 2011 11:34:33 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Cc: Liam Girdwood <lrg@ti.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Mike Frysinger <vapier@gentoo.org>, Daniel Mack <zonque@gmail.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com
Subject: Re: [PATCH 2/3] sound/soc/lapis: add machine driver
Message-ID: <20111121113433.GD3784@opensource.wolfsonmicro.com>
References: <1321848532-8784-1-git-send-email-tomoya.rohm@gmail.com>
 <1321848532-8784-2-git-send-email-tomoya.rohm@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321848532-8784-2-git-send-email-tomoya.rohm@gmail.com>
X-Cookie: Don't get to bragging.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 21, 2011 at 01:08:51PM +0900, Tomoya MORINAGA wrote:
> Add machine driver for LAPIS Semiconductor ML7213 IOH.

This needs to come after you add the base platform support in the series
- clearly this won't work without the CPU side drivers it depends on.

As with the CODEC driver you really should be looking at the standards
for modern drivers and following them.

> @@ -60,6 +60,7 @@ source "sound/soc/s6000/Kconfig"
>  source "sound/soc/sh/Kconfig"
>  source "sound/soc/tegra/Kconfig"
>  source "sound/soc/txx9/Kconfig"
> +source "sound/soc/lapis/Kconfig"

Keep the Makefile and Kconfig entries sorted.

> +static struct snd_soc_dai_link ioh_i2s_dai = {
> +	.name = "I2S",
> +	.stream_name = "I2S HiFi",
> +	.cpu_dai_name = "ml7213ioh-i2s",
> +	.codec_dai_name = "ml7213ioh-hifi",

I'm very surprised this works...  If nothing else I'd expec the CODEC
DAI to have a different name to the CPU.

> +static int __init ioh_i2s_probe(struct platform_device *pdev)
> +{
> +	int ret;
> +
> +	soc_pdev = platform_device_alloc("soc-audio", -1);
> +	if (!soc_pdev)
> +		return -ENOMEM;

You should register the card as a standard platform device for new
drivers and use snd_soc_register_card().

> +static struct platform_driver ioh_i2s_driver = {
> +	.remove = ioh_i2s_remove,
> +	.driver = {
> +		.name = "ml7213ioh-machine",
> +		.owner = THIS_MODULE,
> +	},
> +};

You're already doing the platform device bit so it should be be a case
of changing the body of probe() and remove().

> +static int __init ioh_i2s_init(void)
> +{
> +	return platform_driver_probe(&ioh_i2s_driver,
> +				     ioh_i2s_probe);
> +}

Just make this a standard platform_driver_register().
