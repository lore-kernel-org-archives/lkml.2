Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753713Ab1JKMdK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 08:33:10 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54572 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753276Ab1JKMdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 08:33:09 -0400
Date: Tue, 11 Oct 2011 13:33:05 +0100
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Subject: Re: [PATCH] ASoC: Writing register default value for the reset
	register
Message-ID: <20111011123305.GA2899@opensource.wolfsonmicro.com>
References: <1318326900.3526.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318326900.3526.2.camel@phoenix>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 11, 2011 at 05:55:00PM +0800, Axel Lin wrote:
> The WM8983 can be reset by performing a write of any value to
> the software reset register.
> To avoid writing to the software reset register while resume,
> we should write the same value in wm8983_reg_defs to software
> reset register in wm8983_probe().
> The write to the reset register is suppressed by the cache
> restore code when it skips writes of default registers.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  sound/soc/codecs/wm8983.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/sound/soc/codecs/wm8983.c b/sound/soc/codecs/wm8983.c
> index 17f04ec..93ee284 100644
> --- a/sound/soc/codecs/wm8983.c
> +++ b/sound/soc/codecs/wm8983.c
> @@ -1007,7 +1007,7 @@ static int wm8983_probe(struct snd_soc_codec *codec)
>  		return ret;
>  	}
>  
> -	ret = snd_soc_write(codec, WM8983_SOFTWARE_RESET, 0x8983);
> +	ret = snd_soc_write(codec, WM8983_SOFTWARE_RESET, 0);
>  	if (ret < 0) {
>  		dev_err(codec->dev, "Failed to issue reset: %d\n", ret);
>  		return ret;

We should probably just handle the reset register specially during
resume.

Thanks,
Dimitris
