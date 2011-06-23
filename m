Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759453Ab1FWMef (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 08:34:35 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:40237 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759436Ab1FWMee (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 08:34:34 -0400
Message-ID: <4E0332C5.7010608@ti.com>
Date: Thu, 23 Jun 2011 13:34:13 +0100
From: Liam Girdwood <lrg@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110516 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Mike Frysinger <vapier.adi@gmail.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "device-drivers-devel@blackfin.uclinux.org" 
	<device-drivers-devel@blackfin.uclinux.org>
Subject: Re: [alsa-devel] [PATCH 1/3] ASoC: Add ADAV80x codec driver
References: <1308808818-26775-1-git-send-email-lars@metafoo.de>
In-Reply-To: <1308808818-26775-1-git-send-email-lars@metafoo.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/06/11 07:00, Lars-Peter Clausen wrote:
> This patch adds support for the Analog Devices ADAV801 and ADAV803 audio codec.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> 
> ---
> Changes since v1:
> * Sync register on resume
> * Don't use arrays for the mux enums and controls
> * Rework PLL handling. Use DAPM for powering the PLL and OSC down and use
>   set_sysclk to select the system clock instead of doing this implicitly in
>   set_pll.
> ---
>  MAINTAINERS                |    1 +
>  sound/soc/codecs/Kconfig   |    4 +
>  sound/soc/codecs/Makefile  |    2 +
>  sound/soc/codecs/adav80x.c |  908 ++++++++++++++++++++++++++++++++++++++++++++
>  sound/soc/codecs/adav80x.h |   31 ++
>  5 files changed, 946 insertions(+), 0 deletions(-)
>  create mode 100644 sound/soc/codecs/adav80x.c
>  create mode 100644 sound/soc/codecs/adav80x.h
> 

snip

> +
> +static int adav80x_probe(struct snd_soc_codec *codec)
> +{
> +       int ret;
> +       struct adav80x *adav80x = snd_soc_codec_get_drvdata(codec);
> +
> +       ret = snd_soc_codec_set_cache_io(codec, 7, 9, adav80x->control_type);
> +       if (ret) {
> +               dev_err(codec->dev, "failed to set cache I/O: %d\n", ret);
> +               return ret;
> +       }
> +
> +       /* Power down SYSCLK output, power down S/PDIF receiver */
> +       snd_soc_write(codec, ADAV80X_PLL_OUTE, 0x27);
> +       /* Disable DAC zero flag */
> +       snd_soc_write(codec, ADAV80X_DAC_CTRL3, 0x6);
> +
> +       return adav80x_set_bias_level(codec, SND_SOC_BIAS_STANDBY);
> +}
> +

It's usually better disable things like sysclk output in your machine driver as others may depend on it for probing.

Liam
