Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498Ab1HRKOx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 06:14:53 -0400
Received: from bar.sig21.net ([80.81.252.164]:46098 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755443Ab1HRKOw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 06:14:52 -0400
Date: Thu, 18 Aug 2011 12:14:32 +0200
From: Johannes Stezenbach <js@sig21.net>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org, Daniel Mack <zonque@gmail.com>,
        Sven Neumann <s.neumann@raumfeld.com>
Subject: Re: [PATCH] ASoC: sta32x: Move resource allocation and release to
 the corresponding callback functions
Message-ID: <20110818101432.GA6648@sig21.net>
References: <1313652664.2917.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313652664.2917.3.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-21-Score: -2.9 (--)
X-Spam-21-Report: No, score=-2.9 required=5.0 tests=ALL_TRUSTED=-1,BAYES_00=-1.9 autolearn=no
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 18, 2011 at 03:31:04PM +0800, Axel Lin wrote:
> This patch includes below small fixes:
> 
> 1. Move sta32x_set_bias_level() from sta32x_i2c_remove() to sta32x_remove().
> 2. Remove a redundant regulator_bulk_free() call in sta32x_i2c_remove(),
>    as we will call regulator_bulk_free() in sta32x_remove().
> 3. Remove unneeded snd_soc_codec_set_drvdata(codec, NULL) in sta32x_i2c_remove.
>    The i2c core will set the clientdata to NULL.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
> hi,
> I don't have this hardware handy. I appreciate if someone can test this patch.
> 
> Axel

Your patch looks good, but I also don't have the hardware currently.
Maybe Sven or Daniel could test?  But even though it's untested:

Acked-by: Johannes Stezenbach <js@sig21.net>

Thanks
Johannes

>  sound/soc/codecs/sta32x.c |   13 ++-----------
>  1 files changed, 2 insertions(+), 11 deletions(-)
> 
> diff --git a/sound/soc/codecs/sta32x.c b/sound/soc/codecs/sta32x.c
> index 3d155f5..5c7def3 100644
> --- a/sound/soc/codecs/sta32x.c
> +++ b/sound/soc/codecs/sta32x.c
> @@ -812,6 +812,7 @@ static int sta32x_remove(struct snd_soc_codec *codec)
>  {
>  	struct sta32x_priv *sta32x = snd_soc_codec_get_drvdata(codec);
>  
> +	sta32x_set_bias_level(codec, SND_SOC_BIAS_OFF);
>  	regulator_bulk_disable(ARRAY_SIZE(sta32x->supplies), sta32x->supplies);
>  	regulator_bulk_free(ARRAY_SIZE(sta32x->supplies), sta32x->supplies);
>  
> @@ -871,18 +872,8 @@ static __devinit int sta32x_i2c_probe(struct i2c_client *i2c,
>  static __devexit int sta32x_i2c_remove(struct i2c_client *client)
>  {
>  	struct sta32x_priv *sta32x = i2c_get_clientdata(client);
> -	struct snd_soc_codec *codec = sta32x->codec;
> -
> -	if (codec)
> -		sta32x_set_bias_level(codec, SND_SOC_BIAS_OFF);
> -
> -	regulator_bulk_free(ARRAY_SIZE(sta32x->supplies), sta32x->supplies);
> -
> -	if (codec) {
> -		snd_soc_unregister_codec(&client->dev);
> -		snd_soc_codec_set_drvdata(codec, NULL);
> -	}
>  
> +	snd_soc_unregister_codec(&client->dev);
>  	kfree(sta32x);
>  	return 0;
>  }
> -- 
> 1.7.4.1
> 
> 
> 
> 
