Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932127Ab1JXME4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 08:04:56 -0400
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:33921 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755452Ab1JXMEz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 08:04:55 -0400
MIME-Version: 1.0
In-Reply-To: <1319427072.5773.1.camel@phoenix>
References: <1319427072.5773.1.camel@phoenix>
Date: Mon, 24 Oct 2011 13:04:52 +0100
Message-ID: <CABS+qY00AkNJ2HbpK59Qjph_EPD7=caVyagTVE8okHrb74cnpA@mail.gmail.com>
Subject: Re: [PATCH] ASoC: wm8996: Avoid a redundant i2c_get_clientdata call
 in wm8996_i2c_remove
From: "Girdwood, Liam" <lrg@ti.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 October 2011 04:31, Axel Lin <axel.lin@gmail.com> wrote:
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  sound/soc/codecs/wm8996.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/sound/soc/codecs/wm8996.c b/sound/soc/codecs/wm8996.c
> index 645c980..32324c9 100644
> --- a/sound/soc/codecs/wm8996.c
> +++ b/sound/soc/codecs/wm8996.c
> @@ -3144,7 +3144,7 @@ static __devexit int wm8996_i2c_remove(struct i2c_client *client)
>        snd_soc_unregister_codec(&client->dev);
>        if (wm8996->pdata.ldo_ena > 0)
>                gpio_free(wm8996->pdata.ldo_ena);
> -       kfree(i2c_get_clientdata(client));
> +       kfree(wm8996);
>        return 0;
>  }
>

Acked-by: Liam Girdwood <lrg@ti.com>
