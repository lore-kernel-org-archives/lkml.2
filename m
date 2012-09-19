Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553Ab2ISCul (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 22:50:41 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47338 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751017Ab2ISCuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 22:50:39 -0400
Date: Tue, 18 Sep 2012 22:50:36 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Chavan <ashish.chavan@kpitcummins.com>
Cc: lrg <lrg@ti.com>, alsa-devel <alsa-devel@alsa-project.org>,
        David Dajun Chen <david.chen@diasemi.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] [PATCH v2] ASoC: codecs: Add DA9055 codec driver
Message-ID: <20120919025035.GI8832@opensource.wolfsonmicro.com>
References: <1347622057.16763.27.camel@matrix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347622057.16763.27.camel@matrix>
X-Cookie: It's all in the mind, ya know.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 04:57:37PM +0530, Ashish Chavan wrote:

This looks like a good improvement, a few issues remain though:

> +	/* DAC Routing control */
> +	SOC_ENUM("DAC Left Select", da9055_dac_l_select),
> +	SOC_ENUM("DAC Right Select", da9055_dac_r_select),

DAPM.  This even says its a routing control...

> +	/* To select if MIC Bias powers MIC 1 or MIC 2 */
> +	SOC_ENUM("Mic Bias Select", da9055_mic_bias_select),

This would normally be something controlled by the board...  what
exactly is this doing?  How does the MICBIAS relate to the microphone
inputs?

> +	case SND_SOC_BIAS_STANDBY:
> +		if (codec->dapm.bias_level == SND_SOC_BIAS_OFF) {
> +			/* Enable VMID reference & master bias */
> +			snd_soc_update_bits(codec, DA9055_REFERENCES,
> +					    DA9055_VMID_EN | DA9055_BIAS_EN,
> +					    DA9055_VMID_EN | DA9055_BIAS_EN);
> +		}
> +		regcache_sync(da9055->regmap);

Doing the sync every time is very odd, why is it only done on
transitions from _OFF?  Given that there's no regulator support here
it's also a bit surprising that you need to do a sync outside of system
suspend...

> +	da9055->mclk_rate       = 0;    /* This will be set from set_sysclk() */
> +	da9055->master          = 0;    /* This will be set from set_fmt() */

You use kzalloc...
