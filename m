Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352Ab1LTKk6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 05:40:58 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53037 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752209Ab1LTKkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 05:40:51 -0500
Date: Tue, 20 Dec 2011 10:40:47 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Cc: Liam Girdwood <lrg@ti.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Mike Frysinger <vapier@gentoo.org>, Daniel Mack <zonque@gmail.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com
Subject: Re: [PATCH 1/3 v5] sound/soc/codecs: add LAPIS Semiconductor ML26124
Message-ID: <20111220104047.GE2866@opensource.wolfsonmicro.com>
References: <1324349144-12784-1-git-send-email-tomoya.rohm@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324349144-12784-1-git-send-email-tomoya.rohm@gmail.com>
X-Cookie: You enjoy the company of other people.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 20, 2011 at 11:45:42AM +0900, Tomoya MORINAGA wrote:

> +	switch (level) {
> +	case SND_SOC_BIAS_ON:
> +		/* VMID ON */
> +		snd_soc_update_bits(codec, ML26124_PW_REF_PW_MNG,
> +				    ML26124_VMID, ML26124_VMID);
> +		msleep(500);
> +	case SND_SOC_BIAS_PREPARE:

You're missing a break here.

> +static int ml26124_pcm_trigger(struct snd_pcm_substream *substream,
> +			      int cmd, struct snd_soc_dai *codec_dai)
> +{
> +	struct snd_soc_codec *codec = codec_dai->codec;
> +
> +	if (cmd == SNDRV_PCM_TRIGGER_STOP) {
> +		snd_soc_update_bits(codec, ML26124_REC_PLYBAK_RUN, 0x3, 0);
> +		return 0;
> +	} else if (cmd == SNDRV_PCM_TRIGGER_START) {
> +		if (substream->stream == SNDRV_PCM_STREAM_CAPTURE)

Use switch statements, though frankly I'd be astonished if this code
actually runs as the trigger() callback is called in atomic context and
the register I/O functionality needs interrupts.  How have you tested
this code?

> +	.reg_cache_size = ML26134_CACHESIZE,
> +	.reg_word_size = sizeof(u8),
> +	.reg_cache_default = ml26124_reg,

New drivers really should use regmap rather than the ASoC cache code.
