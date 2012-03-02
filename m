Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756957Ab2CBIQI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 03:16:08 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38776 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499Ab2CBIQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 03:16:06 -0500
MIME-Version: 1.0
In-Reply-To: <20120229235147.GM8295@opensource.wolfsonmicro.com>
References: <1329976011-2251-1-git-send-email-tomoya.rohm@gmail.com>
	<20120229235147.GM8295@opensource.wolfsonmicro.com>
Date: Fri, 2 Mar 2012 17:16:04 +0900
Message-ID: <CANKRQngOkGTPM9AWEaHoaNQCyN65B_ESB24ctcT_DiEen050fg@mail.gmail.com>
Subject: Re: [PATCH v6] sound/soc/codecs: add LAPIS Semiconductor ML26124
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@ti.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, qi.wang@intel.com, yong.y.wang@intel.com,
        joel.clark@intel.com, kok.howg.ewe@intel.com
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012年3月1日8:51 Mark Brown <broonie@opensource.wolfsonmicro.com>:
>> +     SOC_SINGLE("Digital Switch", ML26124_DVOL_CTL, 4, 1, 0),
>
> This should probably be Digital Playback Switch so it lines up with the
> volume control in the UIs (and the Volume controls should be Digital X
> Volume).

No, not only Playback but also for both Playback and Capture.

>> +static int ml26124_set_dai_clkdiv(struct snd_soc_dai *codec_dai,
>> +                               int div_id, int div)
>> +{
>> +     struct snd_soc_codec *codec = codec_dai->codec;
>> +
>> +     switch (div_id) {
>> +     case ML26124_MCLK:
>> +             ml26124_update_bits(codec, ML26124_CLK_CTL,
>> +                                   BIT(0) | BIT(1), div);
>> +             break;
>
> Why can't the driver calculate this automatically given the MCLK?
Sorry, I can't understand your saying.
Why does this driver need to calculate ?
I think this driver can use "div" value directly.

>> +static int ml26124_pcm_trigger(struct snd_pcm_substream *substream,
>> +                           int cmd, struct snd_soc_dai *codec_dai)
>> +{
>> +     struct snd_soc_codec *codec = codec_dai->codec;
>> +
>> +     switch (cmd) {
>> +     case SNDRV_PCM_TRIGGER_STOP:
>> +     case SNDRV_PCM_TRIGGER_SUSPEND:
>> +     case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
>> +             ml26124_update_bits(codec, ML26124_REC_PLYBAK_RUN, 0x3,
>> +                                 0);
>
> I'm not sure you've tested this, you can't do I2C I/O from atomic
> context and trigger is atomic.  What does this control actually do?

This control starts ether Recording or Playing or both.
Anyway, this processing must be moved somewhere.

>
>> +static int ml26124_probe(struct snd_soc_codec *codec)
>> +{
>> +     int ret;
>> +     struct ml26124_priv *priv = snd_soc_codec_get_drvdata(codec);
>> +     codec->control_data = priv->regmap;
>> +
>> +     ret = snd_soc_codec_set_cache_io(codec, 8, 8, SND_SOC_I2C);
>> +     if (ret < 0) {
>> +             dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
>> +             return ret;
>> +     }
>
> You're mixing regmap API usage and ASoC level I2C, this should be
> _REGMAP.
>

Currently, it seems codec control via i2c works well.
Let me know why I should  use SND_SOC_REGMAP not _I2C.


>> +static int __init ml26124_modinit(void)
>> +{
>> +     int ret;
>> +
>> +     ret = i2c_add_driver(&ml26124_i2c_driver);
>> +     if (ret != 0)
>
> module_i2c_driver().

Sorry, I can't understand your saying.

thanks.
-- 
ROHM Co., Ltd.
tomoya
