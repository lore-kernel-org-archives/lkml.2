Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753582Ab1JUHgT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 03:36:19 -0400
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:40139
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753378Ab1JUHgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 03:36:16 -0400
X-SpamScore: -23
X-BigFish: VS-23(zz9371K4015Lc3f2M542M1432Nzz1202hzz8275bh8275dhz2dh2a8h668h839h8e2h8e3h93fh)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Dong Aisheng-B29396 <B29396@freescale.com>
To: Axel Lin <axel.lin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Wolfram Sang <w.sang@pengutronix.de>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>
Subject: RE: [PATCH] ASoC: sgtl5000: Fix wrong mask in some
 snd_soc_update_bits calls
Thread-Topic: [PATCH] ASoC: sgtl5000: Fix wrong mask in some
 snd_soc_update_bits calls
Thread-Index: AQHMj5R0HB7ZtiNhCUCrkRhY5/nTIJWGUeQg
Date: Fri, 21 Oct 2011 07:36:11 +0000
Message-ID: <65EE16ACC360FA4D99C96DC085B3F7722AE773@039-SN1MPN1-003.039d.mgd.msft.net>
References: <1319162083.4352.2.camel@phoenix>
In-Reply-To: <1319162083.4352.2.camel@phoenix>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.242.89]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id p9L7aeW1024340

> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> owner@vger.kernel.org] On Behalf Of Axel Lin
> Sent: Friday, October 21, 2011 9:55 AM
> To: linux-kernel@vger.kernel.org
> Cc: Dong Aisheng-B29396; Wolfram Sang; Liam Girdwood; Mark Brown; alsa-
> devel@alsa-project.org
> Subject: [PATCH] ASoC: sgtl5000: Fix wrong mask in some
> snd_soc_update_bits calls
> 
> Ensure all mask bits are clear before setting new value.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
> I don't have this hardware, I'd appreciate if someone can test this patch.
> 
> Thanks,
> Axel
>  sound/soc/codecs/sgtl5000.c |   12 ++++++------
>  1 files changed, 6 insertions(+), 6 deletions(-)

It runs ok at my side.
Acked-by: Dong Aisheng <b29396@freescale.com>

> diff --git a/sound/soc/codecs/sgtl5000.c b/sound/soc/codecs/sgtl5000.c
> index 32b5bbd..d15695d 100644
> --- a/sound/soc/codecs/sgtl5000.c
> +++ b/sound/soc/codecs/sgtl5000.c
> @@ -723,7 +723,9 @@ static int sgtl5000_pcm_hw_params(struct
> snd_pcm_substream *substream,
>  		return -EINVAL;
>  	}
> 
> -	snd_soc_update_bits(codec, SGTL5000_CHIP_I2S_CTRL, i2s_ctl,
> i2s_ctl);
> +	snd_soc_update_bits(codec, SGTL5000_CHIP_I2S_CTRL,
> +			    SGTL5000_I2S_DLEN_MASK | SGTL5000_I2S_SCLKFREQ_MASK,
> +			    i2s_ctl);
> 
>  	return 0;
>  }
> @@ -1146,8 +1148,7 @@ static int sgtl5000_set_power_regs(struct
> snd_soc_codec *codec)
>  		vag = (vag - SGTL5000_ANA_GND_BASE) / SGTL5000_ANA_GND_STP;
> 
>  	snd_soc_update_bits(codec, SGTL5000_CHIP_REF_CTRL,
> -			vag << SGTL5000_ANA_GND_SHIFT,
> -			vag << SGTL5000_ANA_GND_SHIFT);
> +			SGTL5000_ANA_GND_MASK, vag << SGTL5000_ANA_GND_SHIFT);
> 
>  	/* set line out VAG to vddio / 2, in range (0.8v, 1.675v) */
>  	vag = vddio / 2;
> @@ -1161,9 +1162,8 @@ static int sgtl5000_set_power_regs(struct
> snd_soc_codec *codec)
>  		    SGTL5000_LINE_OUT_GND_STP;
> 
>  	snd_soc_update_bits(codec, SGTL5000_CHIP_LINE_OUT_CTRL,
> -			vag << SGTL5000_LINE_OUT_GND_SHIFT |
> -			SGTL5000_LINE_OUT_CURRENT_360u <<
> -				SGTL5000_LINE_OUT_CURRENT_SHIFT,
> +			SGTL5000_LINE_OUT_CURRENT_MASK |
> +			SGTL5000_LINE_OUT_GND_MASK,
>  			vag << SGTL5000_LINE_OUT_GND_SHIFT |
>  			SGTL5000_LINE_OUT_CURRENT_360u <<
>  				SGTL5000_LINE_OUT_CURRENT_SHIFT);
> --
> 1.7.5.4
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
