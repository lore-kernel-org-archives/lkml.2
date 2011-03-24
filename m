Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932184Ab1CXLmP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 07:42:15 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39452 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751726Ab1CXLmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 07:42:14 -0400
Date: Thu, 24 Mar 2011 11:42:11 +0000
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: Peter Hsiang <Peter.Hsiang@maxim-ic.com>
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jarkko Nikula <jhnikula@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] [PATCH] ASoC: Add max98095 CODEC driver
Message-ID: <20110324114211.GA26636@opensource.wolfsonmicro.com>
References: <B2150E1E4418E1438554A300EA5040E40DAC511079@ITSVLEX06.it.maxim-ic.internal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B2150E1E4418E1438554A300EA5040E40DAC511079@ITSVLEX06.it.maxim-ic.internal>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 23, 2011 at 08:57:41PM -0700, Peter Hsiang wrote:
> +static inline int rate_value(int rate, u8 *value)
> +{
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(rate_table); i++) {
> +		if (rate_table[i].rate >= rate) {
> +			*value = rate_table[i].sr;
> +			return 0;
> +		}
> +	}
> +	*value = rate_table[0].sr;
> +	return -EINVAL;
> +}

Not too clear as to why this is an inline function?

> +static int max98095_probe(struct snd_soc_codec *codec)
> +{
> +	struct max98095_priv *max98095 = snd_soc_codec_get_drvdata(codec);
> +	struct max98095_cdata *cdata;
> +	int ret = 0;
> +
> +	codec->cache_sync = 1;
> +	memcpy(codec->reg_cache, max98095_reg, sizeof(max98095_reg));

Keeping your own copy of the cache is rather deprecated.  As Mark
mentioned, you can let the ASoC cache manage your register cache as well
as use snd_soc_cache_sync() for syncing.

Thanks,
Dimitris
