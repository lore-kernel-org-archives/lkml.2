Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932841Ab1LFCC0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 21:02:26 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49688 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932811Ab1LFCCZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 21:02:25 -0500
MIME-Version: 1.0
In-Reply-To: <20111205183223.GB7467@opensource.wolfsonmicro.com>
References: <1322819115-15808-1-git-send-email-tomoya.rohm@gmail.com>
	<20111202153401.GX8245@opensource.wolfsonmicro.com>
	<CANKRQniyjT_2Ko=EYmffu3_NzDJQTMm9nY6rUp-DQ70e6AVQpA@mail.gmail.com>
	<20111205183223.GB7467@opensource.wolfsonmicro.com>
Date: Tue, 6 Dec 2011 11:02:24 +0900
Message-ID: <CANKRQnhEFvubv0b63z34=_xn4x4q=20enofqPrMsFetj1x7-NQ@mail.gmail.com>
Subject: Re: [PATCH v2] soc/lapis: add machine driver
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

2011/12/6 Mark Brown <broonie@opensource.wolfsonmicro.com>:
>> According to "machine.txt", I created this machine driver referring
>> corgi.c/spitz.c.
>> However, corgi.c/spitz.c. don't look obeying your saying.
>
> You really need to look at current drivers to make sure you're following
> current best practice - older drivers, particularly for obsolte hardware
> like the Zaurus machines, may well not reflect the current best practices.

I see.
I won't read this docs.

BTW, Let me know the best practice of machine driver?
I can't identify which driver is modern or not.


>> 2011/12/3 Mark Brown <broonie@opensource.wolfsonmicro.com>:
>
>> >> +     {I2C_BOARD_INFO("ioh_i2c-5", CODEC_DEV_ADDR + 0)},
>
>> > This looks completely wrong.  I'd not expect to see any I2C_BOARD_INFO
>> > usage at all in a machine driver (that should be done by whatever
>> > enumerates the system as a whole)
>
>> Do you mean machine driver must not use I2C_BOARD_INFO ? Is this true ?
>> Grepping I2C_BOARD_INFO at sound/soc,  the following drivers use
>> I2C_BOARD_INFO.
>> pxa/raumfeld.c: I2C_BOARD_INFO("max9485", 0x63),
>> pxa/magician.c:         I2C_BOARD_INFO("uda1380", 0x18),
>> s6000/s6105-ipcam.c:    { I2C_BOARD_INFO("tlv320aic33", 0x18), }
>
> You'll note that this is *really* rare; there are vastly more machine
> drivers that don't do this.  If there's some specific reason then
> there's nothing technical stopping this happening but it's very unusual.
I see.
I want to know how to use i2c device.
Let me know the best practice driver uses i2c device.

>
>> >> +     ret = snd_soc_dai_set_fmt(codec_dai, SND_SOC_DAIFMT_I2S |
>> >> +                             SND_SOC_DAIFMT_NB_NF | SND_SOC_DAIFMT_CBS_CFS);
>> >> +     if (ret < 0)
>> >> +             return ret;
>
>> > Use the dai_fmt field in the dai_link to set this.
>
>> Sorry, I can't understand your saying.
>> Let me know in more detail.
>
> I'm not sure what more to say...  Have you looked at that field and how
> it is both implemented and used in other drivers, or at the commit logs
> for relevant changes?  What do you find unclear?

You said "Use the dai_fmt field in the dai_link to set this."
However, both dai_fmt and dai_link are already implemented like below.
static struct snd_soc_dai_link ioh_i2s_dai = {
...
};

static struct snd_soc_card ioh_i2s_card = {
...
	.dai_link	= &ioh_i2s_dai,
...
};
So, I can't understand your saying.

>
>> > Should have MODULE_ALIAS too.
>
>> Do you mean machine driver should have MODULE_ALIAS ?
>> Grepping  MODULE_ALIAS at sound/soc, it seems MODULE_ALIAS is used in
>> platform driver only like below.
>> pxa/pxa2xx-i2s.c:MODULE_ALIAS("platform:pxa2xx-i2s");
>
> I don't think you're looking at a current kernel...
>
>> Does machine driver need like "MODULE_ALIAS("machine:ml7213CRB")" ?
>
> No, it should match the name of the platform driver you created.  The
> platform: refers to the bus type.

I understood.

thanks,

tomoya
