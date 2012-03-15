Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882Ab2COEvL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 00:51:11 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:61279 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751657Ab2COEvI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 00:51:08 -0400
MIME-Version: 1.0
In-Reply-To: <20120314143941.GS3133@opensource.wolfsonmicro.com>
References: <20120308114704.GH3638@opensource.wolfsonmicro.com>
	<1331275026-31651-1-git-send-email-tomoya.rohm@gmail.com>
	<20120314143941.GS3133@opensource.wolfsonmicro.com>
Date: Thu, 15 Mar 2012 13:51:07 +0900
Message-ID: <CANKRQnhxAW-tXB3jbwctWRRTZJLrmPUfS2DfRXug=inQVW5OZw@mail.gmail.com>
Subject: Re: [alsa-devel] [PATCH v7] sound/soc/codecs: add LAPIS Semiconductor ML26124
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: alsa-devel@alsa-project.org, qi.wang@intel.com,
        Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org,
        yong.y.wang@intel.com, kok.howg.ewe@intel.com,
        Liam Girdwood <lrg@ti.com>, joel.clark@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2012 at 11:39 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Fri, Mar 09, 2012 at 03:37:06PM +0900, Tomoya MORINAGA wrote:
>> +     /* SAI configuration */
>> +     if (priv->channels == 1) {
>> +             ml26124_update_bits(codec, ML26124_SAI_TRANS_CTL, mask,
>> +                             ML26124_SAI_NO_DELAY | ML26124_SAI_FRAME_SYNC);
>> +             ml26124_update_bits(codec, ML26124_SAI_RCV_CTL, mask,
>> +                             ML26124_SAI_NO_DELAY | ML26124_SAI_FRAME_SYNC);
>> +     } else {
>> +             ml26124_update_bits(codec, ML26124_SAI_TRANS_CTL, mask,
>> +                                 ML26124_SAI_NO_DELAY);
>> +             ml26124_update_bits(codec, ML26124_SAI_RCV_CTL, mask,
>> +                                 ML26124_SAI_NO_DELAY);
>> +     }
>
> What happens if the system switches between 1 channel mode and
> multi-channel mode at runtime?  It looks like _SYNC will never be
> cleared.

Sorry,  'priv->channels == 1' means for telephone codec.
However, we don't support this function.
So, I'll delete these lines.

>> +static int ml26124_set_dai_sysclk(struct snd_soc_dai *codec_dai,
>> +             int clk_id, unsigned int freq, int dir)
>> +{
>> +     struct snd_soc_codec *codec = codec_dai->codec;
>> +     struct ml26124_priv *priv = snd_soc_codec_get_drvdata(codec);
>> +
>> +     switch (clk_id) {
>> +     case ML26124_USE_PLL:
>> +             ml26124_update_bits(codec, ML26124_CLK_CTL,
>> +                                 BIT(0) | BIT(1), 0);
>> +             break;
>> +     case ML26124_USE_MCLKI_256FS:
>> +             ml26124_update_bits(codec, ML26124_CLK_CTL,
>> +                                 BIT(0) | BIT(1), 1);
>> +             break;
>> +     case ML26124_USE_MCLKI_512FS:
>> +             ml26124_update_bits(codec, ML26124_CLK_CTL,
>> +                                 BIT(0) | BIT(1), 2);
>> +             break;
>> +     case ML26124_USE_MCLKI_1024FS:
>> +             ml26124_update_bits(codec, ML26124_CLK_CTL,
>> +                                 BIT(0) | BIT(1), 3);
>> +             break;
>
> Why not just specify the MCLK rate and then calculate the division based
> on the sample rate?

OK, I'll do like your saying.

>
>> +     case SND_SOC_BIAS_STANDBY:
>> +             /* VMID ON */
>> +             ml26124_update_bits(codec, ML26124_PW_REF_PW_MNG,
>> +                                 ML26124_VMID, ML26124_VMID);
>> +             msleep(500);
>
> This will sleep for 500ms when powering down which probably isn't what's
> desired...

I'll Move into "if (codec->dapm.bias_level == SND_SOC_BIAS_OFF)" condition.

thanks.
-- 
ROHM Co., Ltd.
tomoya
