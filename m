Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758830Ab2DJOHU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 10:07:20 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:40710 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754338Ab2DJOHS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 10:07:18 -0400
Message-ID: <4F843EF5.6020507@ti.com>
Date: Tue, 10 Apr 2012 19:38:53 +0530
From: MR Swami Reddy <MR.Swami.Redy@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Lightning/1.0b2 Thunderbird/3.1.20
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Girdwood, Liam" <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>
Subject: Re: [PATCH RESEND] ASoC: Fix setting aif_val in lm49453_set_dai_fmt
References: <1333972124.2569.3.camel@phoenix>
In-Reply-To: <1333972124.2569.3.camel@phoenix>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This issues was fixed last week itself.
URL for the patch - 
http://mailman.alsa-project.org/pipermail/alsa-devel/2012-April/050967.html

Thanks
Swami
On Monday 09 April 2012 05:18 PM, Axel Lin wrote:
> CBS/CBM/CFS/CFM settings are controlled by BIT[3:4] of 0x60h
>
> for example, for SND_SOC_DAIFMT_CBS_CFS: what we want is to clear both BIT[3:4].
>
> aif_val = ~LM49453_AUDIO_PORT1_BASIC_CLK_MS | ~LM49453_AUDIO_PORT1_BASIC_SYNC_MS;
> actually set both bits.
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
> Seems the my mail failed to reach alsa mailing list.
> I resend to LKML instead.
>
> Axel
>  sound/soc/codecs/lm49453.c |    8 ++------
>  1 files changed, 2 insertions(+), 6 deletions(-)
>
> diff --git a/sound/soc/codecs/lm49453.c b/sound/soc/codecs/lm49453.c
> index 744063d..a25e80a 100644
> --- a/sound/soc/codecs/lm49453.c
> +++ b/sound/soc/codecs/lm49453.c
> @@ -1185,16 +1185,12 @@ static int lm49453_set_dai_fmt(struct snd_soc_dai *codec_dai, unsigned int fmt)
>
>         switch (fmt & SND_SOC_DAIFMT_MASTER_MASK) {
>         case SND_SOC_DAIFMT_CBS_CFS:
> -               aif_val = ~LM49453_AUDIO_PORT1_BASIC_CLK_MS |
> -                       ~LM49453_AUDIO_PORT1_BASIC_SYNC_MS;
>                 break;
>         case SND_SOC_DAIFMT_CBS_CFM:
> -               aif_val = ~LM49453_AUDIO_PORT1_BASIC_CLK_MS |
> -                       LM49453_AUDIO_PORT1_BASIC_SYNC_MS;
> +               aif_val = LM49453_AUDIO_PORT1_BASIC_SYNC_MS;
>                 break;
>         case SND_SOC_DAIFMT_CBM_CFS:
> -               aif_val = LM49453_AUDIO_PORT1_BASIC_CLK_MS |
> -                       ~LM49453_AUDIO_PORT1_BASIC_SYNC_MS;
> +               aif_val = LM49453_AUDIO_PORT1_BASIC_CLK_MS;
>                 break;
>         case SND_SOC_DAIFMT_CBM_CFM:
>                 aif_val = LM49453_AUDIO_PORT1_BASIC_CLK_MS |
> --
> 1.7.5.4
>
>
>

