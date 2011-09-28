Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482Ab1I1HYa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 03:24:30 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59647 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648Ab1I1HY3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 03:24:29 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <1317194488.2498.2.camel@phoenix>
References: <1317194488.2498.2.camel@phoenix>
From: Axel Lin <axel.lin@gmail.com>
Date: Wed, 28 Sep 2011 15:24:08 +0800
Message-ID: <CAF+7xWmV_WQScOsCn3NDfFacmX_Y=TJJ_9vD0OrdA_QjdCKK5A@mail.gmail.com>
Subject: Re: [PATCH] ASoC: adau1701: Initialize codec->control_data before
 using it
To: linux-kernel@vger.kernel.org
Cc: Cliff Cai <cliff.cai@analog.com>, Lars-Peter Clausen <lars@metafoo.de>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/9/28 Axel Lin <axel.lin@gmail.com>:
> Currently codec->control_data is not initialized before calling
> process_sigma_firmware(codec->control_data, ADAU1701_FIRMWARE).
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
This one is a v2 of original patch.
Sorry, forgot to add v2 in the subject line.

>  sound/soc/codecs/adau1701.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/sound/soc/codecs/adau1701.c b/sound/soc/codecs/adau1701.c
> index b7e4cc7..8b7e1c5 100644
> --- a/sound/soc/codecs/adau1701.c
> +++ b/sound/soc/codecs/adau1701.c
> @@ -458,6 +458,7 @@ static int adau1701_probe(struct snd_soc_codec *codec)
>        int ret;
>
>        codec->dapm.idle_bias_off = 1;
> +       codec->control_data = to_i2c_client(codec->dev);
>
>        ret = adau1701_load_firmware(codec);
>        if (ret)
> --
> 1.7.4.1
>
>
>
>
