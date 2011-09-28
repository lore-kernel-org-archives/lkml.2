Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462Ab1I1H1I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 03:27:08 -0400
Received: from smtp-out-142.synserver.de ([212.40.185.142]:1110 "HELO
	smtp-out-141.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1751433Ab1I1H1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 03:27:07 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 17405
Message-ID: <4E82CC34.10204@metafoo.de>
Date: Wed, 28 Sep 2011 09:26:44 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110818 Icedove/3.0.11
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH] ASoC: adau1701: Initialize codec->control_data before
 using it
References: <1317194488.2498.2.camel@phoenix>
In-Reply-To: <1317194488.2498.2.camel@phoenix>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/28/2011 09:21 AM, Axel Lin wrote:
> Currently codec->control_data is not initialized before calling
> process_sigma_firmware(codec->control_data, ADAU1701_FIRMWARE).
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Lars-Peter Clausen <lars@metafoo.de>

Thanks

> ---
>  sound/soc/codecs/adau1701.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/sound/soc/codecs/adau1701.c b/sound/soc/codecs/adau1701.c
> index b7e4cc7..8b7e1c5 100644
> --- a/sound/soc/codecs/adau1701.c
> +++ b/sound/soc/codecs/adau1701.c
> @@ -458,6 +458,7 @@ static int adau1701_probe(struct snd_soc_codec *codec)
>  	int ret;
>  
>  	codec->dapm.idle_bias_off = 1;
> +	codec->control_data = to_i2c_client(codec->dev);
>  
>  	ret = adau1701_load_firmware(codec);
>  	if (ret)

