Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756773Ab1KVLTZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 06:19:25 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47536 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752501Ab1KVLTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 06:19:23 -0500
Date: Tue, 22 Nov 2011 11:19:20 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Cc: Liam Girdwood <lrg@ti.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Mike Frysinger <vapier@gentoo.org>, Daniel Mack <zonque@gmail.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com
Subject: Re: [PATCH 1/3] sound/soc/codecs: add LAPIS Semiconductor ML26124
Message-ID: <20111122111920.GB30048@opensource.wolfsonmicro.com>
References: <1321848532-8784-1-git-send-email-tomoya.rohm@gmail.com>
 <20111121112607.GB3784@opensource.wolfsonmicro.com>
 <CANKRQngsHv5M1+LaDq-fmaFCpG3f80DbJOrtvNShLn6hNWfg=w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANKRQngsHv5M1+LaDq-fmaFCpG3f80DbJOrtvNShLn6hNWfg=w@mail.gmail.com>
X-Cookie: A is for Apple.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 07:47:10PM +0900, Tomoya MORINAGA wrote:
> 2011/11/21 Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:

> BTW, What's TLV ? Let me know the full spell of this "TLV".

Tag/Length/Value.

> >> +static const struct snd_kcontrol_new ml26124_dsp_controls[] = {
> >> +     SOC_SINGLE("Play Limitter ON/OFF", ML26124_FILTER_EN, 0, 1, 0),

> Do you mean SOC_SINGLE("Play Limitter Switch", ML26124_FILTER_EN, 0, 1, 0) ?

Yes.

> >> +     SOC_SINGLE("Set ALC position", ML26124_FILTER_EN, 5, 1, 0),

> > What does this actually do?  From the name it *really* doesn't look like
> > a mixer input.

> The above means where connects the ALC.
> So, this doesn't relate to mixer input.

If this control is not a mixer input it should not be a mixer input in
the driver.  Though with your explanation I still don't understand what
it does so presumably the naming also needs to be improved.

> However I couldn't understand the meaning of the widgets. So I didn't
> write anything.

See Documentation/sound/alsa/soc/dapm.txt.

> >> +static int snd_card_codec_reg_read(struct ml26124_priv *priv,
> >> +                                unsigned char reg, unsigned char *val)
> >> +{
> >> +     unsigned char data;
> >> +     struct i2c_client *i2c;

> > Use the standard register access code, don't open code things in your
> > driver unless there's a good reason to.  Current best practice for most
> > I2C or SPI devices is to use regmap, see any recently added driver for
> > examples.

> What's "regmap" mean ? or do you mean drivers/mfd/* ?
> Could you tell me this ?

drivers/base/regmap and also grep in sound/soc/codecs/*.c

> > Use snd_soc_update_bits() and the other standard register access
> > functions.

> Using snd_soc_update_bits(), need to register ".read" method.

Or use a cache.

> Is the same as the above  snd_card_codec_reg_read ?

I don't understand this question.
