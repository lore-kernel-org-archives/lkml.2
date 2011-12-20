Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220Ab1LTKpe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 05:45:34 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57435 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751819Ab1LTKpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 05:45:30 -0500
Date: Tue, 20 Dec 2011 10:45:26 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Cc: Liam Girdwood <lrg@ti.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Mike Frysinger <vapier@gentoo.org>, Daniel Mack <zonque@gmail.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com
Subject: Re: [PATCH 2/3 v4] sound/soc/lapis: add machine driver for ML7213
 Carrier Board
Message-ID: <20111220104525.GG2866@opensource.wolfsonmicro.com>
References: <1324349144-12784-1-git-send-email-tomoya.rohm@gmail.com>
 <1324349144-12784-2-git-send-email-tomoya.rohm@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324349144-12784-2-git-send-email-tomoya.rohm@gmail.com>
X-Cookie: You enjoy the company of other people.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 20, 2011 at 11:45:43AM +0900, Tomoya MORINAGA wrote:

> +{
> +	struct snd_soc_pcm_runtime *rtd = substream->private_data;
> +	struct snd_soc_dai *codec_dai = rtd->codec_dai;
> +	struct snd_soc_dai *cpu_dai = rtd->cpu_dai;
> +
> +	unsigned int clk = 0;
> +	int ret = 0;
> +	int bclkfs;
> +	int mclkfs;
> +	int rate = params_rate(hw_params);

The coding style here is really odd, looks like you're mixing
declarations and code.

> +	default:
> +		pr_err("%s: Failed not support format\n", __func__);
> +		return -1;
> +		break;

Return sensible error codes and there's no reason for the break after
the return.

> +	ret = snd_soc_dai_set_clkdiv(cpu_dai, ML7213IOH_BCLKFS0, bclkfs);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = snd_soc_dai_set_clkdiv(cpu_dai, ML7213IOH_BCLKFS1, bclkfs);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = snd_soc_dai_set_clkdiv(cpu_dai, ML7213IOH_BCLKFS2, bclkfs);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = snd_soc_dai_set_clkdiv(cpu_dai, ML7213IOH_BCLKFS3, bclkfs);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = snd_soc_dai_set_clkdiv(cpu_dai, ML7213IOH_BCLKFS4, bclkfs);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = snd_soc_dai_set_clkdiv(cpu_dai, ML7213IOH_BCLKFS5, bclkfs);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = snd_soc_dai_set_clkdiv(cpu_dai, ML7213IOH_MCLKFS0, mclkfs);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = snd_soc_dai_set_clkdiv(cpu_dai, ML7213IOH_MCLKFS1, mclkfs);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = snd_soc_dai_set_clkdiv(cpu_dai, ML7213IOH_MCLKFS2, mclkfs);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = snd_soc_dai_set_clkdiv(cpu_dai, ML7213IOH_MCLKFS3, mclkfs);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = snd_soc_dai_set_clkdiv(cpu_dai, ML7213IOH_MCLKFS4, mclkfs);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = snd_soc_dai_set_clkdiv(cpu_dai, ML7213IOH_MCLKFS5, mclkfs);
> +	if (ret < 0)
> +		return ret;

This looks like the CODEC driver ought to be working these things out
for itself rather than having every machine using the device know about
these dividers.

You're also still missing the drivers for the CPU...
