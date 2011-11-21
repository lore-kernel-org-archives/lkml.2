Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762Ab1KULp2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 06:45:28 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42778 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750850Ab1KULp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 06:45:27 -0500
Date: Mon, 21 Nov 2011 11:45:24 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Cc: Liam Girdwood <lrg@ti.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Mike Frysinger <vapier@gentoo.org>, Daniel Mack <zonque@gmail.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com
Subject: Re: [PATCH 3/3] sound/soc/lapis: add platform driver
Message-ID: <20111121114524.GE3784@opensource.wolfsonmicro.com>
References: <1321848532-8784-1-git-send-email-tomoya.rohm@gmail.com>
 <1321848532-8784-3-git-send-email-tomoya.rohm@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321848532-8784-3-git-send-email-tomoya.rohm@gmail.com>
X-Cookie: Don't get to bragging.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 21, 2011 at 01:08:52PM +0900, Tomoya MORINAGA wrote:

> +/* =================== I2S CH0 config =================== */
> +#define	I2S_CH0_MCLK		(12288000) /* Master Clock Frequency[Hz] */

This looks like it should be board specific?

> +  #if IOH_I2S_USE_PARAM
> +	#define	I2S_CH0_FS_16000	16000
> +	#define	I2S_CH0_FS_32000	32000
> +	#define	I2S_CH0_FS_48000	48000
> +  #else
> +	#define	I2S_CH0_FS_8000		8000
> +	#define	I2S_CH0_FS_11025	11025
> +	#define	I2S_CH0_FS_22050	22050
> +	#define	I2S_CH0_FS_44100	44100
> +  #endif

What are these ifdefs for?  This should be configured at runtime.

> +/* select master or slave. The value is ioh_mssel_t */
> +#define	I2S_CH0_MSSEL			(ioh_mssel_master)
> +/* select MCLK or MLBCLK into Master Clock. The value is enum ioh_masterclk_t */
> +#define	I2S_CH0_MASTERCLKSEL		(ioh_masterclksel_mclk)

This and most of the following defines also look like compile time
configuration for things that should be runtime configured.  As with
the previous patches in the series the big picture issue here is that
you need to update your code to reflect the practices of modern
mainline Linux code - here the major issue is that you appear to be
doing all your configuration with #defines rather than by using runtime
configuration from the machine driver as is normal for ASoC code.

I got through a bunch more defines but stopped reviewing at some point
as there was so much of this issue.
