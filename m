Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932148Ab1JXMGK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 08:06:10 -0400
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:54017 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932075Ab1JXMGJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 08:06:09 -0400
MIME-Version: 1.0
In-Reply-To: <1319427161.5773.3.camel@phoenix>
References: <1319427161.5773.3.camel@phoenix>
Date: Mon, 24 Oct 2011 13:06:08 +0100
Message-ID: <CABS+qY1bfAneoVuHuKBpeGmPG_Knh_CDkf1xpaTFa+_oEZGdKA@mail.gmail.com>
Subject: Re: [PATCH 1/3] ASoC: wm8940: Fix setting PLL Output clock division ratio
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

On 24 October 2011 04:32, Axel Lin <axel.lin@gmail.com> wrote:
> According to the datasheet:
> The PLL Output clock division ratio is controlled by BIT[5:4] of
> WM8940_GPIO register(08h).
> Current code read/write the WM8940_ADDCNTRL(07h) register which is wrong.
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  sound/soc/codecs/wm8940.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/sound/soc/codecs/wm8940.c b/sound/soc/codecs/wm8940.c
> index a4abfdf..3cc3bce 100644
> --- a/sound/soc/codecs/wm8940.c
> +++ b/sound/soc/codecs/wm8940.c
> @@ -627,8 +627,8 @@ static int wm8940_set_dai_clkdiv(struct snd_soc_dai *codec_dai,
>                ret = snd_soc_write(codec, WM8940_CLOCK, reg | (div << 5));
>                break;
>        case WM8940_OPCLKDIV:
> -               reg = snd_soc_read(codec, WM8940_ADDCNTRL) & 0xFFCF;
> -               ret = snd_soc_write(codec, WM8940_ADDCNTRL, reg | (div << 4));
> +               reg = snd_soc_read(codec, WM8940_GPIO) & 0xFFCF;
> +               ret = snd_soc_write(codec, WM8940_GPIO, reg | (div << 4));
>                break;
>        }
>        return ret;
> --

Acked-by: Liam Girdwood <lrg@ti.com>
