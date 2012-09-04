Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756651Ab2IDJJZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 05:09:25 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:44826 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756489Ab2IDJJX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 05:09:23 -0400
MIME-Version: 1.0
In-Reply-To: <5045A11B.3070300@gmail.com>
References: <1346660831-9662-1-git-send-email-javier.martin@vista-silicon.com>
	<5045A11B.3070300@gmail.com>
Date: Tue, 4 Sep 2012 11:09:20 +0200
Message-ID: <CACKLOr1nobfaKRnVVuiODAfCUugCYJ2=pDvbz6wn1Yexy7qb6A@mail.gmail.com>
Subject: Re: [ASoC] Fix: Revert 'ASoC: imx-ssi: Remove mono support'.
From: javier Martin <javier.martin@vista-silicon.com>
To: =?ISO-8859-1?Q?Ga=EBtan_Carlier?= <gcembed@gmail.com>
Cc: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        broonie@opensource.wolfsonmicro.com, fabio.estevam@freescale.com,
        s.hauer@pengutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 September 2012 08:35, Gaëtan Carlier <gcembed@gmail.com> wrote:
> Hi Javier,
>
> On 09/03/2012 10:27 AM, Javier Martin wrote:
>>
>> The following commit should be reverted:
>> 0865a75d4166bddc533fd50831829ceefb94f9b0
>>
>> The bug this patch is meant to solve doesn't occur in Visstrim_M10 boards.
>> Furthermore, after applying this patch sound in Visstrim_M10 is played
>> at slower rates.
>>
>> Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
>> ---
>> diff --git b/sound/soc/fsl/imx-ssi.c a/sound/soc/fsl/imx-ssi.c
>> index ac337ac..28dd76c 100644
>> --- b/sound/soc/fsl/imx-ssi.c
>> +++ a/sound/soc/fsl/imx-ssi.c
>> @@ -380,13 +380,13 @@ static int imx_ssi_dai_probe(struct snd_soc_dai
>> *dai)
>>   static struct snd_soc_dai_driver imx_ssi_dai = {
>>         .probe = imx_ssi_dai_probe,
>>         .playback = {
>> -               .channels_min = 2,
>> +               .channels_min = 1,
>>                 .channels_max = 2,
>>                 .rates = SNDRV_PCM_RATE_8000_96000,
>>                 .formats = SNDRV_PCM_FMTBIT_S16_LE,
>>         },
>>         .capture = {
>> -               .channels_min = 2,
>> +               .channels_min = 1,
>>                 .channels_max = 2,
>>                 .rates = SNDRV_PCM_RATE_8000_96000,
>>                 .formats = SNDRV_PCM_FMTBIT_S16_LE,
>>
> When applied on linux-next-20120824, the patch failed because original
> imx-ssi.c file looks like :
>
> static struct snd_soc_dai_driver imx_ssi_dai = {
>         .probe = imx_ssi_dai_probe,
>         .playback = {
>                 /* The SSI does not support monaural audio. */
>
>                 .channels_min = 2,
>                 .channels_max = 2,
>                 .rates = SNDRV_PCM_RATE_8000_96000,
>                 .formats = SNDRV_PCM_FMTBIT_S16_LE,
>         },
>         .capture = {
>                 .channels_min = 2,
>                 .channels_max = 2,
>                 .rates = SNDRV_PCM_RATE_8000_96000,
>                 .formats = SNDRV_PCM_FMTBIT_S16_LE,
>         },
>         .ops = &imx_ssi_pcm_dai_ops,
> };
>
> The comment line is missing in your patch. Here is the right patch :
>
> @@ -378,18 +378,17 @@ static int imx_ssi_dai_probe(struct snd_soc_dai *dai)
>
>  }
>
>  static struct snd_soc_dai_driver imx_ssi_dai = {
>         .probe = imx_ssi_dai_probe,
>         .playback = {
> -               /* The SSI does not support monaural audio. */
>
> -               .channels_min = 2,
> +               .channels_min = 1,
>                 .channels_max = 2,
>                 .rates = SNDRV_PCM_RATE_8000_96000,
>                 .formats = SNDRV_PCM_FMTBIT_S16_LE,
>         },
>         .capture = {
> -               .channels_min = 2,
> +               .channels_min = 1,
>                 .channels_max = 2,
>                 .rates = SNDRV_PCM_RATE_8000_96000,
>                 .formats = SNDRV_PCM_FMTBIT_S16_LE,
>         },
>         .ops = &imx_ssi_pcm_dai_ops,
>
> Regards,
> Gaëtan Carlier.


Mark,
could you pick up the fixed patch sent by Gaëtan?

Regards.

-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
