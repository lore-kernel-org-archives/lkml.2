Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328Ab2CFDDW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 22:03:22 -0500
Received: from mail-pz0-f52.google.com ([209.85.210.52]:34398 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757Ab2CFDDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 22:03:20 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of tomoya.rohm@gmail.com designates 10.68.218.228 as permitted sender) smtp.mail=tomoya.rohm@gmail.com; dkim=pass header.i=tomoya.rohm@gmail.com
MIME-Version: 1.0
In-Reply-To: <20120302125819.GE3230@opensource.wolfsonmicro.com>
References: <1329976011-2251-1-git-send-email-tomoya.rohm@gmail.com>
	<20120229235147.GM8295@opensource.wolfsonmicro.com>
	<CANKRQngOkGTPM9AWEaHoaNQCyN65B_ESB24ctcT_DiEen050fg@mail.gmail.com>
	<20120302125819.GE3230@opensource.wolfsonmicro.com>
Date: Tue, 6 Mar 2012 12:03:20 +0900
Message-ID: <CANKRQngoDf_U8U7txG0AT1TKmSeq2FfqwjWD7EEiLROWzn+f5Q@mail.gmail.com>
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

2012年3月2日21:58 Mark Brown <broonie@opensource.wolfsonmicro.com>:
>> >> +static int ml26124_set_dai_clkdiv(struct snd_soc_dai *codec_dai,
>> >> +                               int div_id, int div)
>> >> +{
>> >> +     struct snd_soc_codec *codec = codec_dai->codec;
>
>> >> +     switch (div_id) {
>> >> +     case ML26124_MCLK:
>> >> +             ml26124_update_bits(codec, ML26124_CLK_CTL,
>> >> +                                   BIT(0) | BIT(1), div);
>> >> +             break;
>
>> > Why can't the driver calculate this automatically given the MCLK?
>
>> Sorry, I can't understand your saying.
>> Why does this driver need to calculate ?
>> I think this driver can use "div" value directly.
>
> Why does the user have to set this divider by hand at all?  There's
> already a set_sysclk() function, just have the user specify the clock
> they're providing.
I see.
This processing will move to set_sysclk()

>> >> +     ret = snd_soc_codec_set_cache_io(codec, 8, 8, SND_SOC_I2C);
>> > You're mixing regmap API usage and ASoC level I2C, this should be
>> > _REGMAP.
>> Currently, it seems codec control via i2c works well.
>> Let me know why I should  use SND_SOC_REGMAP not _I2C.
> Have you checked what _I2C and _REGMAP do?
I've just checked it.
If SND_SOC_REGMAP is used, it seems there is no processing in it.
So, can I delete snd_soc_codec_set_cache_io ?

>
>> >> +static int __init ml26124_modinit(void)
>> >> +{
>> >> +     int ret;
>> >> +
>> >> +     ret = i2c_add_driver(&ml26124_i2c_driver);
>> >> +     if (ret != 0)
>
>> > module_i2c_driver().
>
>> Sorry, I can't understand your saying.
>
> Use module_i2c_driver().
I understand.
As a matter of interest, why can I use module_i2c_driver ?
There is no ASoC driver uses module_i2c_driver.

>> +static int ml26124_update_bits(struct snd_soc_codec *codec, unsigned short reg,
>> +                             unsigned int mask, unsigned int value)
>
> Why are you open coding this in your driver?  There is no point in
> replicating subsystem functionality.
For ML26124 spec, it's necessary.
Because the codec's register read-address and write-address is not the same.
E.G.
Sampling Rate Register
R: offset=0
W: offset=1

thanks,
-- 
ROHM Co., Ltd.
tomoya
