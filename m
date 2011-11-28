Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859Ab1K1MU4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 07:20:56 -0500
Received: from smtp-out-216.synserver.de ([212.40.185.216]:1026 "EHLO
	smtp-out-211.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753722Ab1K1MUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 07:20:54 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 31575
Message-ID: <4ED37CE3.6040008@metafoo.de>
Date: Mon, 28 Nov 2011 13:21:55 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111114 Iceowl/1.0b2 Icedove/3.1.16
MIME-Version: 1.0
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>
CC: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Mike Frysinger <vapier@gentoo.org>, Daniel Mack <zonque@gmail.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com
Subject: Re: [PATCH v3] sound/soc/codecs: add LAPIS Semiconductor ML26124
References: <1322474755-18785-1-git-send-email-tomoya.rohm@gmail.com>
In-Reply-To: <1322474755-18785-1-git-send-email-tomoya.rohm@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28/2011 11:05 AM, Tomoya MORINAGA wrote:
> ML26124-01HB/ML26124-02GD is 16bit monaural audio CODEC which has high
> resistance to voltage noise. On chip regulator realizes power supply rejection
> ratio (PSRR) be over 90dB so more than 50dB is improved than ever. ML26124-01HB/
> ML26124-02GD can deliver stable audio performance without being affected by noise
> from the power supply circuit and peripheral components. The chip also includes
> a composite video signal output, which can be applied to various portable device
>  requirements. The ML26124 is realized these functions into very small package
> the size is only 2.56mm x 2.46mm therefore can be construct high quality sound
> system easily.
> ML26124-01HB is 25pin WCSP package; ML26124-02GD is 32pin WQFN package.
> 
> Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
> ---
>  sound/soc/codecs/Kconfig   |    4 +
>  sound/soc/codecs/Makefile  |    2 +
>  sound/soc/codecs/ml26124.c |  475 ++++++++++++++++++++++++++++++++++++++++++++
>  sound/soc/codecs/ml26124.h |  122 +++++++++++
>  4 files changed, 603 insertions(+), 0 deletions(-)
>  create mode 100644 sound/soc/codecs/ml26124.c
>  create mode 100644 sound/soc/codecs/ml26124.h
> 
> diff --git a/sound/soc/codecs/Kconfig b/sound/soc/codecs/Kconfig
> index 665d924..ce8e622 100644
> --- a/sound/soc/codecs/Kconfig
> +++ b/sound/soc/codecs/Kconfig
> @@ -38,6 +38,7 @@ config SND_SOC_ALL_CODECS
>  	select SND_SOC_MAX98095 if I2C
>  	select SND_SOC_MAX9850 if I2C
>  	select SND_SOC_MAX9877 if I2C
> +	select SND_SOC_ML26124 if I2C
>  	select SND_SOC_PCM3008
>  	select SND_SOC_SGTL5000 if I2C
>  	select SND_SOC_SN95031 if INTEL_SCU_IPC
> @@ -211,6 +212,9 @@ config SND_SOC_MAX98095
>  config SND_SOC_MAX9850
>  	tristate
>  
> +config SND_SOC_ML26124
> +	tristate
> +
>  config SND_SOC_PCM3008
>         tristate
>  
> diff --git a/sound/soc/codecs/Makefile b/sound/soc/codecs/Makefile
> index 5119a7e..c1353ff 100644
> --- a/sound/soc/codecs/Makefile
> +++ b/sound/soc/codecs/Makefile
> @@ -24,6 +24,7 @@ snd-soc-l3-objs := l3.o
>  snd-soc-max98088-objs := max98088.o
>  snd-soc-max98095-objs := max98095.o
>  snd-soc-max9850-objs := max9850.o
> +snd-soc-ml26124-objs := ml26124.o
>  snd-soc-pcm3008-objs := pcm3008.o
>  snd-soc-sgtl5000-objs := sgtl5000.o
>  snd-soc-alc5623-objs := alc5623.o
> @@ -122,6 +123,7 @@ obj-$(CONFIG_SND_SOC_JZ4740_CODEC)	+= snd-soc-jz4740-codec.o
>  obj-$(CONFIG_SND_SOC_MAX98088)	+= snd-soc-max98088.o
>  obj-$(CONFIG_SND_SOC_MAX98095)	+= snd-soc-max98095.o
>  obj-$(CONFIG_SND_SOC_MAX9850)	+= snd-soc-max9850.o
> +obj-$(CONFIG_SND_SOC_ML26124)   += snd-soc-ml26124.o
>  obj-$(CONFIG_SND_SOC_PCM3008)	+= snd-soc-pcm3008.o
>  obj-$(CONFIG_SND_SOC_SGTL5000)  += snd-soc-sgtl5000.o
>  obj-$(CONFIG_SND_SOC_SN95031)	+=snd-soc-sn95031.o
> diff --git a/sound/soc/codecs/ml26124.c b/sound/soc/codecs/ml26124.c
> new file mode 100644
> index 0000000..ee323fb
> --- /dev/null
> +++ b/sound/soc/codecs/ml26124.c
> @@ -0,0 +1,475 @@
> +/*
> + * Copyright (C) 2011 LAPIS Semiconductor Co., Ltd.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; version 2 of the License.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307, USA.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/moduleparam.h>
> +#include <linux/init.h>
> +#include <linux/delay.h>
> +#include <linux/pm.h>
> +#include <linux/i2c.h>
> +#include <linux/slab.h>
> +#include <linux/platform_device.h>
> +#include <sound/core.h>
> +#include <sound/pcm.h>
> +#include <sound/pcm_params.h>
> +#include <sound/soc.h>
> +#include <sound/tlv.h>
> +#include "ml26124.h"
> +
> +struct ml26124_priv {
> +	struct snd_pcm_substream *substream;

Is substream actually ever used?

> +};
> +
[...]
> +
> +static const struct snd_kcontrol_new ml26124_output_mixer_controls[] = {
> +	SOC_DAPM_SINGLE("DAC Switch", ML26124_SPK_AMP_OUT, 1, 1, 0),
> +	SOC_DAPM_SINGLE("Line in Switch", ML26124_SPK_AMP_OUT, 3, 1, 0),
> +	SOC_DAPM_SINGLE("PGA Switch", ML26124_SPK_AMP_OUT, 5, 1, 0),
> +};
> +
> +/* Input mux */
> +static const char * const ml26124_input_select[] = {"Analog MIC in",
> +						    "Digital MIC in"};
> +
> +static const struct soc_enum ml26124_insel_enum =
> +	SOC_ENUM_SINGLE(ML26124_MIC_IF_CTL, 0, 1, ml26124_input_select);
> +
> +static const struct snd_kcontrol_new ml26124_input_mux_controls =
> +	SOC_DAPM_ENUM("Input Select", ml26124_insel_enum);
> +
> +static const struct snd_kcontrol_new ml26124_line_control =
> +	SOC_DAPM_SINGLE("Switch", ML26124_PW_LOUT_PW_MNG, 1, 1, 0);
> +
> +static const struct snd_soc_dapm_widget ml26124_dapm_widgets[] = {
> +	SND_SOC_DAPM_SUPPLY("MCLK", ML26124_CLK_EN, 0, 0, NULL, 0),
> +	SND_SOC_DAPM_SUPPLY("PLL", ML26124_CLK_EN, 1, 0, NULL, 0),
> +	SND_SOC_DAPM_SUPPLY("MICBIAS", ML26124_PW_REF_PW_MNG, 0, 0, NULL, 0),
> +	SND_SOC_DAPM_MIXER("Output Mixer", ML26124_PW_SPAMP_PW_MNG, 0, 0,
> +			   &ml26124_output_mixer_controls[0],
> +			   ARRAY_SIZE(ml26124_output_mixer_controls)),
> +	SND_SOC_DAPM_DAC("DAC", "Playback", ML26124_PW_DAC_PW_MNG, 1, 0),
> +	SND_SOC_DAPM_ADC("ADC", "Capture", ML26124_PW_IN_PW_MNG, 1, 0),
> +	SND_SOC_DAPM_PGA("PGA", ML26124_PW_IN_PW_MNG, 3, 0, NULL, 0),
> +	SND_SOC_DAPM_MUX("Input Mux", SND_SOC_NOPM, 0, 0,
> +			  &ml26124_input_mux_controls),
> +	SND_SOC_DAPM_SWITCH("Line Out Enable", SND_SOC_NOPM, 0, 0,
> +			     &ml26124_line_control),
> +	SND_SOC_DAPM_INPUT("VIDEOIN"),
> +	SND_SOC_DAPM_INPUT("MDIN"),
> +	SND_SOC_DAPM_INPUT("MIN"),
> +	SND_SOC_DAPM_INPUT("LIN"),
> +	SND_SOC_DAPM_OUTPUT("VIDEOOUT"),
> +	SND_SOC_DAPM_OUTPUT("SPOUT"),
> +	SND_SOC_DAPM_OUTPUT("LOUT"),
> +};
> +
> +static const struct snd_soc_dapm_route ml26124_intercon[] = {
> +	/* output mixer */
> +	{"Output Mixer", "PGA Switch", "PGA"},
> +	{"Output Mixer", "DAC Switch", "DAC"},
> +	{"Output Mixer", NULL, "Line in Switch"},
> +	/* outputs */
> +	{"SPOUT", NULL, "Output Mixer"},
> +	{"LOUT", NULL, "Output Mixer"},
> +	{"SPOUT", NULL, "Output Mixer"},
> +
> +	/* input mux */
> +	{"Input Mux", "Analog MIC in", "MICBIAS"},
> +	{"Input Mux", "Digital MIC in", "MICBIAS"},
> +	{"ADC", NULL, "Input Mux"},
> +
> +	/* inputs */
> +	{"DAC", NULL, "MDIN"},
> +	{"PGA", NULL, "MIN"},
> +	{"SPOUT", NULL, "LIN"},

The routing looks a bit incomplete. There are quite a few dapm widgets which
are not used. E.g. MCLK, PLL, so they will never be enabled, which I would
assume would prevent the device from working. Also none of the inputs is
routed to the ADC, which seems a bit strange.

> +};
> +
[...]
> +static int snd_card_ml7213i2s_hw_free(struct snd_pcm_substream *substream,
> +				      struct snd_soc_dai *dai)

The name of the function doesn't really match the drivers name.

> +{
> +	struct snd_soc_codec *codec = dai->codec;
> +
> +	/* soft reset assert */
> +	snd_soc_update_bits(codec, ML26124_SW_RST, 0x01, 1);
> +
> +	/* Stop  Record/Playback Running */
> +	snd_soc_update_bits(codec, ML26124_REC_PLYBAK_RUN, 0x3, 0);

I would expect that this to cause problems with concurrent capture/playback
and one of them being stopped.

> +
> +	return 0;
> +}
> +
[...]
> +
> +static int ml26124_probe(struct snd_soc_codec *codec)
> +{
> +	int ret;
> +
> +	ret = snd_soc_codec_set_cache_io(codec, 8, 8, SND_SOC_I2C);
> +	if (ret < 0) {
> +		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
> +		return ret;
> +	}
> +
> +	/* Software Reset */
> +	snd_soc_update_bits(codec, ML26124_SW_RST, 0x01, 1);
> +	snd_soc_update_bits(codec, ML26124_SW_RST, 0x01, 0);
> +
> +	ml26124_set_bias_level(codec, SND_SOC_BIAS_STANDBY);
> +
> +	snd_soc_add_controls(codec, ml26124_snd_controls,
> +			     ARRAY_SIZE(ml26124_snd_controls));

Controls should use table based setup as well.

> +
> +	return 0;
> +}
> +
> +/* power down chip */
> +#define REG_CACHE_SIZE		0x79

You've defined ML26134_CACHESIZE with the same value above.

> +static struct snd_soc_codec_driver soc_codec_dev_ml26124 = {
> +	.probe =	ml26124_probe,
> +	.suspend =	ml26124_suspend,
> +	.resume =	ml26124_resume,
> +	.set_bias_level = ml26124_set_bias_level,
> +	.reg_cache_size = REG_CACHE_SIZE,
> +	.reg_word_size = sizeof(u8),
> +	.reg_cache_default = ml26124_reg,
> +	.dapm_widgets = ml26124_dapm_widgets,
> +	.num_dapm_widgets = ARRAY_SIZE(ml26124_dapm_widgets),
> +	.dapm_routes = ml26124_intercon,
> +	.num_dapm_routes = ARRAY_SIZE(ml26124_intercon),
> +};
> +
[...]
