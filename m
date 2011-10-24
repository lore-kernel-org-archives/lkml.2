Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932119Ab1JXMEN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 08:04:13 -0400
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:43245 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755720Ab1JXMEM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 08:04:12 -0400
MIME-Version: 1.0
In-Reply-To: <1319294907.2678.2.camel@phoenix>
References: <1319294907.2678.2.camel@phoenix>
Date: Mon, 24 Oct 2011 13:04:10 +0100
Message-ID: <CABS+qY2wt_Rq74uO2OpPFkquX-noPUU1tiZ9wcs9fzpJ6EYC=w@mail.gmail.com>
Subject: Re: [PATCH] ASoC: wm8400: Fix setting Fout clock divider for FLL
 Control 4
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

On 22 October 2011 15:48, Axel Lin <axel.lin@gmail.com> wrote:
> What we want here is to clear the WM8400_FLL_OUTDIV_MASK bits then
> OR with factors.outdiv.
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  sound/soc/codecs/wm8400.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/sound/soc/codecs/wm8400.c b/sound/soc/codecs/wm8400.c
> index dc13be2..f29bc26 100644
> --- a/sound/soc/codecs/wm8400.c
> +++ b/sound/soc/codecs/wm8400.c
> @@ -1059,7 +1059,7 @@ static int wm8400_set_dai_pll(struct snd_soc_dai *codec_dai, int pll_id,
>        wm8400_write(codec, WM8400_FLL_CONTROL_3, factors.n);
>
>        reg = wm8400_read(codec, WM8400_FLL_CONTROL_4);
> -       reg &= WM8400_FLL_OUTDIV_MASK;
> +       reg &= ~WM8400_FLL_OUTDIV_MASK;
>        reg |= factors.outdiv;
>        wm8400_write(codec, WM8400_FLL_CONTROL_4, reg);
>
> --
> 1.7.5.4
>
>
>
>

Acked-by: Liam Girdwood <lrg@ti.com>
