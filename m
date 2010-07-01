Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756393Ab0GAOfn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 10:35:43 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46716 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754103Ab0GAOfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 10:35:42 -0400
Date: Thu, 1 Jul 2010 15:35:40 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Raffaele Recalcati <lamiaposta71@gmail.com>
Cc: davinci-linux-open-source@linux.davincidsp.com,
       Raffaele Recalcati <raffaele.recalcati@bticino.it>,
       Davide Bonfanti <davide.bonfanti@bticino.it>,
       Liam Girdwood <lrg@slimlogic.co.uk>, Jaroslav Kysela <perex@perex.cz>,
       Takashi Iwai <tiwai@suse.de>,
       Troy Kisky <troy.kisky@boundarydevices.com>,
       alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] ASoC: DaVinci: Added two clocking possibilities to
 McBSP (I2S)
Message-ID: <20100701143540.GC8742@rakim.wolfsonmicro.main>
References: <1277905678-4695-1-git-send-email-lamiaposta71@gmail.com>
 <1277905678-4695-2-git-send-email-lamiaposta71@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277905678-4695-2-git-send-email-lamiaposta71@gmail.com>
X-Cookie: Sign my PETITION.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 30, 2010 at 03:47:56PM +0200, Raffaele Recalcati wrote:

> +static int davinci_i2s_dai_set_clkdiv(struct snd_soc_dai *cpu_dai,
> +				int div_id, int div)
> +{
> +	struct davinci_mcbsp_dev *dev = cpu_dai->private_data;
> +	int srgr;
> +
> +	dev->clk_div = div;
> +	return 0;
> +}

As previously mentioned this should check the div_id argument.

> +	switch (master) {
> +	case SND_SOC_DAIFMT_CBS_CFS:

...

> +	case SND_SOC_DAIFMT_CBM_CFS:

...

> +	default:
> +		/* Clock and frame sync given from external sources */

The two remaining options (_CBM_CFM and _CBS_CFM) are different, your
description matches _CBM_CFM.

> +		if (master == SND_SOC_DAIFMT_CBS_CFS ||
> +				master == SND_SOC_DAIFMT_CBS_CFM) {

Switch statement again.

> +	if (master == SND_SOC_DAIFMT_CBS_CFS ||
> +			master == SND_SOC_DAIFMT_CBS_CFM) {
> +		rcr |= DAVINCI_MCBSP_RCR_RFRLEN1(0);
> +		xcr |= DAVINCI_MCBSP_XCR_XFRLEN1(0);
> +	} else {

...and another.  Please fix all these.
