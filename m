Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274Ab1KYCDT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 21:03:19 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:65262 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752840Ab1KYCDS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 21:03:18 -0500
MIME-Version: 1.0
In-Reply-To: <20111122111920.GB30048@opensource.wolfsonmicro.com>
References: <1321848532-8784-1-git-send-email-tomoya.rohm@gmail.com>
	<20111121112607.GB3784@opensource.wolfsonmicro.com>
	<CANKRQngsHv5M1+LaDq-fmaFCpG3f80DbJOrtvNShLn6hNWfg=w@mail.gmail.com>
	<20111122111920.GB30048@opensource.wolfsonmicro.com>
Date: Fri, 25 Nov 2011 11:03:17 +0900
Message-ID: <CANKRQng9zQkWPy8fH39BTQ9PKMEt2bOhEvrn9fWszhqSBO1rjw@mail.gmail.com>
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

>> > Use the standard register access code, don't open code things in your
>> > driver unless there's a good reason to.  Current best practice for most
>> > I2C or SPI devices is to use regmap, see any recently added driver for
>> > examples.
>
>> What's "regmap" mean ? or do you mean drivers/mfd/* ?
>> Could you tell me this ?
>
> drivers/base/regmap and also grep in sound/soc/codecs/*.c
Though grepping "regmap" at sound/soc/codecs/*.c, I couldn't find any file.
Is this true ?

Thanks,
tomoya

2011/11/22 Mark Brown <broonie@opensource.wolfsonmicro.com>:
> On Tue, Nov 22, 2011 at 07:47:10PM +0900, Tomoya MORINAGA wrote:
>> 2011/11/21 Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:
>
>> BTW, What's TLV ? Let me know the full spell of this "TLV".
>
> Tag/Length/Value.
>
>> >> +static const struct snd_kcontrol_new ml26124_dsp_controls[] = {
>> >> +     SOC_SINGLE("Play Limitter ON/OFF", ML26124_FILTER_EN, 0, 1, 0),
>
>> Do you mean SOC_SINGLE("Play Limitter Switch", ML26124_FILTER_EN, 0, 1, 0) ?
>
> Yes.
>
>> >> +     SOC_SINGLE("Set ALC position", ML26124_FILTER_EN, 5, 1, 0),
>
>> > What does this actually do?  From the name it *really* doesn't look like
>> > a mixer input.
>
>> The above means where connects the ALC.
>> So, this doesn't relate to mixer input.
>
> If this control is not a mixer input it should not be a mixer input in
> the driver.  Though with your explanation I still don't understand what
> it does so presumably the naming also needs to be improved.
>
>> However I couldn't understand the meaning of the widgets. So I didn't
>> write anything.
>
> See Documentation/sound/alsa/soc/dapm.txt.
>
>> >> +static int snd_card_codec_reg_read(struct ml26124_priv *priv,
>> >> +                                unsigned char reg, unsigned char *val)
>> >> +{
>> >> +     unsigned char data;
>> >> +     struct i2c_client *i2c;
>
>> > Use the standard register access code, don't open code things in your
>> > driver unless there's a good reason to.  Current best practice for most
>> > I2C or SPI devices is to use regmap, see any recently added driver for
>> > examples.
>
>> What's "regmap" mean ? or do you mean drivers/mfd/* ?
>> Could you tell me this ?
>
> drivers/base/regmap and also grep in sound/soc/codecs/*.c
>
>> > Use snd_soc_update_bits() and the other standard register access
>> > functions.
>
>> Using snd_soc_update_bits(), need to register ".read" method.
>
> Or use a cache.
>
>> Is the same as the above  snd_card_codec_reg_read ?
>
> I don't understand this question.
>
