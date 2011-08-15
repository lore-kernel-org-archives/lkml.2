Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915Ab1HOMZQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 08:25:16 -0400
Received: from bar.sig21.net ([80.81.252.164]:37377 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752709Ab1HOMZO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 08:25:14 -0400
Date: Mon, 15 Aug 2011 14:25:06 +0200
From: Johannes Stezenbach <js@sig21.net>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH] ASoC: sta32x: shortcut the for loop to get ir and mcs
Message-ID: <20110815122506.GA26490@sig21.net>
References: <1313292664.6074.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313292664.6074.1.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-21-Score: -2.9 (--)
X-Spam-21-Report: No, score=-2.9 required=5.0 tests=ALL_TRUSTED=-1,BAYES_00=-1.9 autolearn=no
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 14, 2011 at 11:31:04AM +0800, Axel Lin wrote:
> There is exactly one match or no match at all during the for loop iteration,
> thus we can break from the for loop once a match is found.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Looks good.

Acked-by: Johannes Stezenbach <js@sig21.net>


Thanks,
Johannes


> ---
>  sound/soc/codecs/sta32x.c |    8 ++++++--
>  1 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/sound/soc/codecs/sta32x.c b/sound/soc/codecs/sta32x.c
> index fbd7eb9..3d155f5 100644
> --- a/sound/soc/codecs/sta32x.c
> +++ b/sound/soc/codecs/sta32x.c
> @@ -524,13 +524,17 @@ static int sta32x_hw_params(struct snd_pcm_substream *substream,
>  	rate = params_rate(params);
>  	pr_debug("rate: %u\n", rate);
>  	for (i = 0; i < ARRAY_SIZE(interpolation_ratios); i++)
> -		if (interpolation_ratios[i].fs == rate)
> +		if (interpolation_ratios[i].fs == rate) {
>  			ir = interpolation_ratios[i].ir;
> +			break;
> +		}
>  	if (ir < 0)
>  		return -EINVAL;
>  	for (i = 0; mclk_ratios[ir][i].ratio; i++)
> -		if (mclk_ratios[ir][i].ratio * rate == sta32x->mclk)
> +		if (mclk_ratios[ir][i].ratio * rate == sta32x->mclk) {
>  			mcs = mclk_ratios[ir][i].mcs;
> +			break;
> +		}
>  	if (mcs < 0)
>  		return -EINVAL;
>  
> -- 
> 1.7.4.1
> 
> 
> 
> 
