Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476Ab1ISLAK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 07:00:10 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45272 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755087Ab1ISLAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 07:00:08 -0400
Date: Mon, 19 Sep 2011 12:00:06 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Samuel Ortiz <samuel.ortiz@intel.com>, Dmitry Torokhov <dtor@mail.ru>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Misael Lopez Cruz <misael.lopez@ti.com>
Subject: Re: [PATCH 07/17] ASoC: twl6040: Lower the initial gains
Message-ID: <20110919110006.GH23727@opensource.wolfsonmicro.com>
References: <1316090379-30760-1-git-send-email-peter.ujfalusi@ti.com>
 <1316090379-30760-8-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316090379-30760-8-git-send-email-peter.ujfalusi@ti.com>
X-Cookie: You will soon forget this.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 15, 2011 at 03:39:29PM +0300, Peter Ujfalusi wrote:
> The default gains on outputs/inputs are set to 0dB.
> To be able to handle pop noise better, we need to lower
> the gains on controls, where it is possible.

It looks like what you really want to do here is implement support
having PGAs able to cache the gain the user has set but hold the gain at
zero while the PGA is disabled.  This would be generally useful, a lot
of older parts liked to have the PGAs muted when powering them.

> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> ---
>  sound/soc/codecs/twl6040.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/sound/soc/codecs/twl6040.c b/sound/soc/codecs/twl6040.c
> index 987d9c9..1f6068b 100644
> --- a/sound/soc/codecs/twl6040.c
> +++ b/sound/soc/codecs/twl6040.c
> @@ -269,6 +269,13 @@ static void twl6040_init_chip(struct snd_soc_codec *codec)
>  	/* No imput selected for microphone amplifiers */
>  	twl6040_write_reg_cache(codec, TWL6040_REG_MICLCTL, 0x18);
>  	twl6040_write_reg_cache(codec, TWL6040_REG_MICRCTL, 0x18);
> +
> +	/* Lower the gains */
> +	twl6040_write_reg_cache(codec, TWL6040_REG_HSGAIN, 0xff);
> +	twl6040_write_reg_cache(codec, TWL6040_REG_EARCTL, 0x1e);
> +	twl6040_write_reg_cache(codec, TWL6040_REG_HFLGAIN, 0x1d);
> +	twl6040_write_reg_cache(codec, TWL6040_REG_HFRGAIN, 0x1d);
> +	twl6040_write_reg_cache(codec, TWL6040_REG_LINEGAIN, 0);
>  }
>  
>  static void twl6040_restore_regs(struct snd_soc_codec *codec)
> -- 
> 1.7.6.1
> 
