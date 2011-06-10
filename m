Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756883Ab1FJRaK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 13:30:10 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:45754 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755147Ab1FJRaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 13:30:08 -0400
Date: Fri, 10 Jun 2011 18:30:04 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org,
        Mike Frysinger <vapier@gentoo.org>, linux-kernel@vger.kernel.org,
        device-drivers-devel@blackfin.uclinux.org,
        uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [alsa-devel] [PATCH 2/3] ASoC: Blackfin: Add bf5xx-adau1701
	machine driver
Message-ID: <20110610173004.GJ26441@sirena.org.uk>
References: <1307726331-28618-1-git-send-email-lars@metafoo.de> <1307726331-28618-2-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307726331-28618-2-git-send-email-lars@metafoo.de>
X-Cookie: I had pancake makeup for brunch!
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 10, 2011 at 07:18:50PM +0200, Lars-Peter Clausen wrote:
> Add a machine driver to support the ADAU1701 SigmaDSP processors on
> Analog Devices BF5XX evaluation boards.

So, I keep on complaining about the way these drivers are just generic
to any random Blackfin plus CODEC combination rather than being board
specific.  It'd be good if we could improve this, even adding something
into the driver name to make it clear these are for the EVB would help. 

But it's about the same as all the other drivers so...

> +static struct snd_soc_dai_link bf5xx_adau1701_dai[] = {
> +	{
> +		.name = "adau1701",
> +		.stream_name = "adau1701",
> +		.cpu_dai_name = "bfin-i2s.0",
> +		.codec_dai_name = "adau1701",
> +		.platform_name = "bfin-i2s-pcm-audio",
> +		.codec_name = "adau1701.0-0034",
> +		.ops = &bf5xx_adau1701_ops,
> +	},
> +	{
> +		.name = "adau1701",
> +		.stream_name = "adau1701",
> +		.cpu_dai_name = "bfin-i2s.1",
> +		.codec_dai_name = "adau1701",
> +		.platform_name = "bfin-i2s-pcm-audio",
> +		.codec_name = "adau1701.0-0034",
> +		.ops = &bf5xx_adau1701_ops,
> +	},

For example this mapping could vary between systems, and I guess there
may be some possiblity that the CODEC I2C address could change.
