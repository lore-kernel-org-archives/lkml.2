Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757854Ab1KVKrU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 05:47:20 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53851 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754060Ab1KVKrT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 05:47:19 -0500
MIME-Version: 1.0
In-Reply-To: <20111121112607.GB3784@opensource.wolfsonmicro.com>
References: <1321848532-8784-1-git-send-email-tomoya.rohm@gmail.com>
	<20111121112607.GB3784@opensource.wolfsonmicro.com>
Date: Tue, 22 Nov 2011 19:47:10 +0900
Message-ID: <CANKRQngsHv5M1+LaDq-fmaFCpG3f80DbJOrtvNShLn6hNWfg=w@mail.gmail.com>
Subject: Re: [PATCH 1/3] sound/soc/codecs: add LAPIS Semiconductor ML26124
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@ti.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Mike Frysinger <vapier@gentoo.org>, Daniel Mack <zonque@gmail.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

Thank you for your comments.
I have some questions.

2011/11/21 Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:
>> +static const struct snd_kcontrol_new ml26124_snd_controls[] = {
>> +     SOC_SINGLE_TLV("Record Digital Volume", ML26124_RECORD_DIG_VOL, 0, 0xff, 1, rec_play_digi_vol),
>
> Capture, not Record.

OK,
BTW, What's TLV ? Let me know the full spell of this "TLV".

>
>> +static const struct snd_kcontrol_new ml26124_dsp_controls[] = {
>> +     SOC_SINGLE("Play Limitter ON/OFF", ML26124_FILTER_EN, 0, 1, 0),
>
Do you mean SOC_SINGLE("Play Limitter Switch", ML26124_FILTER_EN, 0, 1, 0) ?


>> +     SOC_SINGLE("Set ALC position", ML26124_FILTER_EN, 5, 1, 0),
>
> What does this actually do?  From the name it *really* doesn't look like
> a mixer input.
>
The above means where connects the ALC.
So, this doesn't relate to mixer input.


>> +static const struct snd_soc_dapm_route intercon[] = {
>> +};
>
> I can't see how any of the DAPM widgets you specify will ever work with
> no interconnections.
I see.
However I couldn't understand the meaning of the widgets. So I didn't
write anything.
For example, wm8731 writes like below.
Could you explain this ?

static const struct snd_soc_dapm_route wm8731_intercon[] = {
	{"DAC", NULL, "OSC", wm8731_check_osc},
	{"ADC", NULL, "OSC", wm8731_check_osc},
	{"DAC", NULL, "ACTIVE"},
	{"ADC", NULL, "ACTIVE"},

	/* output mixer */
	{"Output Mixer", "Line Bypass Switch", "Line Input"},
	{"Output Mixer", "HiFi Playback Switch", "DAC"},
	{"Output Mixer", "Mic Sidetone Switch", "Mic Bias"},

	/* outputs */
	{"RHPOUT", NULL, "Output Mixer"},
	{"ROUT", NULL, "Output Mixer"},
	{"LHPOUT", NULL, "Output Mixer"},
	{"LOUT", NULL, "Output Mixer"},

	/* input mux */
	{"Input Mux", "Line In", "Line Input"},
	{"Input Mux", "Mic", "Mic Bias"},
	{"ADC", NULL, "Input Mux"},

	/* inputs */
	{"Line Input", NULL, "LLINEIN"},
	{"Line Input", NULL, "RLINEIN"},
	{"Mic Bias", NULL, "MICIN"},
};



>
>> +
>> +static int snd_card_codec_reg_read(struct ml26124_priv *priv,
>> +                                unsigned char reg, unsigned char *val)
>> +{
>> +     unsigned char data;
>> +     struct i2c_client *i2c;
>
> Use the standard register access code, don't open code things in your
> driver unless there's a good reason to.  Current best practice for most
> I2C or SPI devices is to use regmap, see any recently added driver for
> examples.
What's "regmap" mean ? or do you mean drivers/mfd/* ?
Could you tell me this ?

>> +     unsigned char data;
>> +     unsigned int rate = priv->rate;
>> +     unsigned int channels = priv->ch;
>> +
>> +     snd_card_codec_reg_read(priv, 0x30, &data);      /* Read MICVIAS Voltage */
>> +
>> +     snd_card_codec_reg_write(priv, 0x10, 0x01);     /* soft reset assert */
>> +     snd_card_codec_reg_write(priv, 0x10, 0x00);     /* soft reset negate */
>> +
>> +     snd_card_codec_reg_write(priv, 0x0c, 0x00);     /* Stop clock  */
>
> Use snd_soc_update_bits() and the other standard register access
> functions.
Using snd_soc_update_bits(), need to register ".read" method.
Is the same as the above  snd_card_codec_reg_read ?

Thanks in advance,
---
tomoya
ROHM Co., Ltd
