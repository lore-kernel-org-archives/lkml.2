Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752391Ab0KWKda (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 05:33:30 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:53921 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991Ab0KWKd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 05:33:29 -0500
Subject: Re: [PATCH 1/3] ASoC: max98088 - fix a memory leak
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Peter Hsiang <Peter.Hsiang@maxim-ic.com>,
        Jesse Marroquin <jesse.marroquin@maxim-ic.com>
In-Reply-To: <1290498981.7286.4.camel@mola>
References: <1290498981.7286.4.camel@mola>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Nov 2010 10:33:24 +0000
Message-ID: <1290508404.3449.7.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-23 at 15:56 +0800, Axel Lin wrote:
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  sound/soc/codecs/max98088.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/sound/soc/codecs/max98088.c b/sound/soc/codecs/max98088.c
> index 4ee5b1a..b679586 100644
> --- a/sound/soc/codecs/max98088.c
> +++ b/sound/soc/codecs/max98088.c
> @@ -2020,7 +2020,10 @@ err_access:
>  
>  static int max98088_remove(struct snd_soc_codec *codec)
>  {
> +       struct max98088_priv *max98088 = snd_soc_codec_get_drvdata(codec);
> +
>         max98088_set_bias_level(codec, SND_SOC_BIAS_OFF);
> +       kfree(max98088->eq_texts);
>  
>         return 0;
>  }

All

Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

